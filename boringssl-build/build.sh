#!/usr/bin/env bash
# ED25519_verify from BoringSSL, as LLVM 23 MLIR op files.
#
# Flags are CMake's Release ones for x86_64 Linux with clang
# (cmake -DCMAKE_BUILD_TYPE=Release, see compile_commands.json), minus
# -ggdb (no IR semantics) and -Werror/-fcolor-diagnostics.  Added, as in
# Firedancer's MLIR production profile: -fno-inline and
# -funcspec-max-clones=0, so each C function stays its own region, and
# FIAT_25519_NO_ASM, replacing fiat's inline-asm value barrier with (x).
# Assembly stays: SHA-512's block functions are external declarations.
#
# Linked TUs: curve25519.cc, fipsmodule/bcm.cc (SHA-512), sha/sha512.cc
# (public wrappers), mem.cc (CRYPTO_memcmp).  crypto.cc is left out, so
# OPENSSL_get_ia32cap (CPU dispatch) stays an external declaration.
#
# Sources: BoringSSL at 3b39936f376ed568431fd3f95c3421f5b0726e70
# (SRC); clang, LLVM and MLIR 23.1.3 (LLVM); Firedancer's mlir_extract_region.py
# at 73199608ac3b (EXTRACT). out/op is committed, the rest of out/ is not.
set -euo pipefail

SRC=${SRC:-$HOME/src/boringssl}
OUT=${OUT:-$(cd "$(dirname "$0")" && pwd)/out}
LLVM=${LLVM:-$HOME/.local/llvm-23/bin}
CLANGXX=${CLANGXX:-$(dirname "$(readlink -f "$LLVM/clang")")/clang++}
LLVM_LINK=${LLVM_LINK:-$(dirname "$(readlink -f "$LLVM/opt")")/llvm-link}
EXTRACT=${EXTRACT:-$HOME/firedancer/src/ballet/ed25519/conformance_verification/mlir_extract_region.py}
COMMIT=3b39936f376ed568431fd3f95c3421f5b0726e70
[ "$(git -C "$SRC" rev-parse HEAD)" = "$COMMIT" ] || { echo "$SRC is not at $COMMIT" >&2; exit 1; }
ENTRY=ED25519_verify

CXXFLAGS=(-DBORINGSSL_IMPLEMENTATION -I"$SRC/include"
  -fno-strict-aliasing -fno-common -fvisibility=hidden -O3 -DNDEBUG -std=gnu++17
  -Wformat=2 -Wmissing-field-initializers -Wshadow -Wsign-compare -Wtype-limits -Wvla
  -Wwrite-strings -Wimplicit-fallthrough -Wall -Wnewline-eof -Wextra-semi
  -Wheader-hygiene -Wmissing-prototypes -Wstring-concatenation
  -Wframe-larger-than=25344 -Wctad-maybe-unsupported -fno-exceptions -fno-rtti
  -fno-inline -mllvm -funcspec-max-clones=0 -DFIAT_25519_NO_ASM)

TUS=(crypto/curve25519/curve25519.cc crypto/fipsmodule/bcm.cc crypto/sha/sha512.cc crypto/mem.cc)

rm -rf "$OUT"; mkdir -p "$OUT/tu" "$OUT/op" "$OUT/op-uncanonicalized"

# CMake's own Release command for curve25519.cc, to compare with CXXFLAGS.
cmake -S "$SRC" -B "$OUT/cmake" -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER="${CLANGXX%++}" \
  -DCMAKE_CXX_COMPILER="$CLANGXX" -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DBUILD_TESTING=OFF > "$OUT/cmake.out"
python3 -c 'import json, sys
for e in json.load(open(sys.argv[1])):
  if e["file"].endswith("crypto/curve25519/curve25519.cc"): print(e["command"])' \
  "$OUT/cmake/compile_commands.json" > "$OUT/cmake-release-command.txt"
lls=()
for tu in "${TUS[@]}"; do
  ll="$OUT/tu/$(basename "$tu" .cc).ll"
  "$CLANGXX" "${CXXFLAGS[@]}" -S -emit-llvm "$SRC/$tu" -o "$ll"
  lls+=("$ll")
done
"$LLVM_LINK" -S "${lls[@]}" -o "$OUT/ed25519_verify.full.ll"
"$LLVM/opt" -S -passes='internalize,globaldce' -internalize-public-api-list="$ENTRY" \
  "$OUT/ed25519_verify.full.ll" -o "$OUT/ed25519_verify.ll"
"$LLVM/mlir-translate" --import-llvm "$OUT/ed25519_verify.ll" | \
  "$LLVM/mlir-opt" --mlir-print-op-generic -o "$OUT/ed25519_verify.mlir"
python3 "$EXTRACT" "$OUT/ed25519_verify.mlir" "$OUT/op-uncanonicalized"
"$LLVM/mlir-opt" --canonicalize='region-simplify=disabled' --mlir-print-op-generic \
  "$OUT/ed25519_verify.mlir" -o "$OUT/ed25519_verify.canonicalized.mlir"
python3 "$EXTRACT" "$OUT/ed25519_verify.canonicalized.mlir" "$OUT/op"
python3 "$(dirname "$0")/analyze.py" "$OUT/ed25519_verify.canonicalized.mlir" > "$OUT/summary.md"
