#!/usr/bin/env bash
# crypto_sign_ed25519_verify_detached from libsodium, as LLVM 23 MLIR op files.
#
# Flags are configure's defaults on x86_64 Linux (no CFLAGS given, no
# --enable-opt): configure runs out of tree in out/autoconf and its
# DEFS, CPPFLAGS and CFLAGS are taken from src/libsodium/Makefile.
# Added, as in Firedancer's MLIR production profile: -fno-inline and
# -funcspec-max-clones=0, so each C function stays its own region.
# Nothing else is changed; the verify path has no assembly.
#
# Sources: libsodium (1.0.22) at a6a93de672b7e2c6c13a02cbbe0e6457fe9306fd
# (SRC); clang, LLVM and MLIR 23.1.3 (LLVM); Firedancer's mlir_extract_region.py
# at 73199608ac3b (EXTRACT). out/op is committed, the rest of out/ is not.
set -euo pipefail

SRC=${SRC:-$HOME/src/libsodium}
OUT=${OUT:-$(cd "$(dirname "$0")" && pwd)/out}
LLVM=${LLVM:-$HOME/.local/llvm-23/bin}
CLANG=${CLANG:-$(readlink -f "$LLVM/clang")}
LLVM_LINK=${LLVM_LINK:-$(dirname "$(readlink -f "$LLVM/opt")")/llvm-link}
EXTRACT=${EXTRACT:-$HOME/firedancer/src/ballet/ed25519/conformance_verification/mlir_extract_region.py}
COMMIT=a6a93de672b7e2c6c13a02cbbe0e6457fe9306fd
[ "$(git -C "$SRC" rev-parse HEAD)" = "$COMMIT" ] || { echo "$SRC is not at $COMMIT" >&2; exit 1; }
ENTRY=crypto_sign_ed25519_verify_detached

rm -rf "$OUT"; mkdir -p "$OUT/autoconf" "$OUT/tu" "$OUT/op" "$OUT/op-uncanonicalized"

# The unwrapped Nix clang links with interpreter /lib/ld64.so.1, so
# configure's run tests need the system loader.  LDFLAGS only.
(cd "$OUT/autoconf" && CC="$CLANG" LDFLAGS=-Wl,--dynamic-linker=/lib64/ld-linux-x86-64.so.2 \
  "$SRC/configure" > configure.out 2>&1)
MK="$OUT/autoconf/src/libsodium/Makefile"
eval "DEFS=($(sed -n 's/^DEFS = //p' "$MK"))"
eval "CPPFLAGS=($(sed -n 's/^CPPFLAGS = //p' "$MK"))"
eval "CFLAGS=($(sed -n 's/^CFLAGS = //p' "$MK"))"
FLAGS=(-std=gnu23 "${DEFS[@]}" -I"$OUT/autoconf/src/libsodium" -I"$SRC/src/libsodium"
  -I"$SRC/src/libsodium/include/sodium" -I"$OUT/autoconf/src/libsodium/include/sodium"
  "${CPPFLAGS[@]}" "${CFLAGS[@]}" -fno-inline -mllvm -funcspec-max-clones=0)
printf '%q ' "${FLAGS[@]}" > "$OUT/flags.txt"

TUS=(crypto_sign/ed25519/ref10/open.c crypto_sign/ed25519/ref10/sign.c
  crypto_core/ed25519/ref10/ed25519_ref10.c crypto_hash/sha512/cp/hash_sha512_cp.c
  crypto_verify/verify.c sodium/utils.c)

lls=()
for tu in "${TUS[@]}"; do
  ll="$OUT/tu/$(echo "$tu" | tr / _ | sed 's/\.c$//').ll"
  "$CLANG" "${FLAGS[@]}" -S -emit-llvm "$SRC/src/libsodium/$tu" -o "$ll"
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
