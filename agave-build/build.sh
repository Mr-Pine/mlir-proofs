#!/usr/bin/env bash
# Lifts Agave's ed25519 signature check into MLIR op files for lean-mlir.
#
# The crates are the registry ones Agave e818d643's Cargo.lock pins,
# unmodified; wrapper/ only calls solana_signature::Signature::verify.
# agave/ holds the Agave files this follows, from
# https://raw.githubusercontent.com/anza-xyz/agave/e818d643945cd82c7144013af58ccf82d31df2dd/
# rustc 1.98.1 (Agave's rust-toolchain.toml, LLVM 22) optimizes; LLVM 23
# only reads its bitcode, cuts, imports and canonicalizes, as in
# Firedancer's make-mlir (config/everything.mk).
#
# Usage: ./build.sh [variant...]   (default: serial avx2)
# Variants: serial, avx2, <backend>-noinline (modular builds),
# <backend>-noinline-big (modular, with big inlined callees kept apart:
# the serial proofs' build), <backend>-noinline-all (exploration only),
# and dispatch (Agave's own flags: AVX2 picked at run time; not extractable).
# Outputs land in out/<variant>/:
#   full.bc         the fat-LTO module as compiled (rustc's LLVM 22)
#   full.ll         the same, disassembled by LLVM 23
#   verify.ll       the entry's reachable subset, runtime cut, as imported
#   verify.mlir     MLIR module, generic form
#   canonical.mlir  the same through mlir-opt --canonicalize
#   op/*.mlir       each function and global of canonical.mlir
#   inventory.md    functions, globals, ops, intrinsics, attributes
set -euo pipefail

HERE=$(cd "$(dirname "$0")" && pwd)
TOOLCHAIN=${TOOLCHAIN:-1.98.1}
RUSTUP=${RUSTUP:-$HOME/.local/rustup-nix/bin/rustup}
LLVM_BIN=${LLVM_BIN:-$(dirname "$(readlink -f "$HOME/.local/llvm-23/bin/opt")")}
MLIR_BIN=${MLIR_BIN:-$(dirname "$(readlink -f "$HOME/.local/llvm-23/bin/mlir-opt")")}
FIREDANCER=${FIREDANCER:-$HOME/firedancer}
# Firedancer's extractor, copied: long Rust symbols get hashed file names.
EXTRACT=$HERE/scripts/mlir_extract_region.py
ENTRY=agave_ed25519_verify
export CARGO_HOME=${CARGO_HOME:-$HERE/.cargo}
# rustup's cargo proxy does not put rustc on PATH here.
PATH=$(dirname "$("$RUSTUP" which --toolchain "$TOOLCHAIN" rustc)"):$PATH

# Agave's .cargo/config.toml targets x86-64-v2 on Linux.  The production
# binary picks AVX2 at run time through cpufeatures; here it is static.
# -funcspec-max-clones=0 and -inline-threshold=0 are Firedancer's
# modularity flags (its -fno-inline), for the noinline variants only.
flags() {
  local f="-C target-cpu=x86-64-v2 --remap-path-prefix=$CARGO_HOME=/cargo"
  case $1 in
    serial*) f+=' --cfg curve25519_backend="serial" --cfg sha2_backend="soft"' ;;
    avx2*)   f+=' -C target-feature=+avx2' ;;
    dispatch) ;;
    *) echo "unknown variant $1" >&2; exit 2 ;;
  esac
  case $1 in
    *-noinline) f+=' -C llvm-args=-funcspec-max-clones=0 -C llvm-args=-inline-threshold=0' ;;
    # The noinline build, with the functions scripts/noinline-big.txt lists also kept apart: the
    # ones it would still inline into a caller past ~300 ops.
    *-noinline-big) f+=' -C llvm-args=-funcspec-max-clones=0 -C llvm-args=-inline-threshold=0'
      while read -r fn; do f+=" -C llvm-args=-force-attribute=$fn:noinline"; done \
        < <(grep -v -E '^(#|$)' "$HERE/scripts/noinline-big.txt") ;;
    # No inlining at all: rustc's MIR inliner off, every function noinline in LLVM (alwaysinline
    # removed first). Exploration only: far from Agave's build.
    *-noinline-all) f+=' -C llvm-args=-funcspec-max-clones=0 -Z inline-mir=no'
      f+=' -C llvm-args=-force-remove-attribute=alwaysinline -C llvm-args=-force-attribute=noinline' ;;
  esac
  echo "$f"
}

build() {
  local v=$1 out=$HERE/out/$1 tgt=$HERE/target/$1
  rm -rf "$out"; mkdir -p "$out"
  echo "== $v: $(flags "$v")"
  # The fat-LTO step runs in the wrapper's rustc; rerun it every time.
  cargo clean --manifest-path "$HERE/wrapper/Cargo.toml" --release --target-dir "$tgt" \
    -p agave-ed25519-verify
  # -Z inline-mir needs a nightly flag.
  RUSTC_BOOTSTRAP=$([[ $v == *-noinline-all ]] && echo 1) RUSTFLAGS=$(flags "$v") \
    cargo rustc --manifest-path "$HERE/wrapper/Cargo.toml" \
    --release --locked --offline --target-dir "$tgt" -- --emit=llvm-bc="$out/full.bc"
  "$LLVM_BIN/llvm-dis" "$out/full.bc" -o "$out/full.ll"

  # Keep the entry and what it reaches, as make-mlir does.  std's #[used]
  # statics (ARGV_INIT_ARRAY, EMPTY_PANIC) root a program, not the entry.
  grep -v -E '^@llvm\.(compiler\.)?used = ' "$out/full.ll" |
    "$LLVM_BIN/opt" -S -passes='internalize,globaldce' \
      -internalize-public-api-list=$ENTRY -o "$out/reach.ll"
  # Fat LTO brings in std: a panic reaches its whole runtime.  Cut it at
  # the panic entry points, which become declarations like bcmp.
  local cut; cut=$(python3 -I "$HERE/scripts/boundary.py" "$out/reach.ll" $ENTRY)
  echo "$cut" | tr , '\n' > "$out/cut.txt"
  "$LLVM_BIN/llvm-extract" -S --delete $(sed 's/^/--func=/' "$out/cut.txt") \
    "$out/reach.ll" -o "$out/cut.ll"
  # llvm-extract makes every local symbol hidden; internalize them again.
  "$LLVM_BIN/opt" -S -passes='internalize,globaldce' \
    -internalize-public-api-list=$ENTRY "$out/cut.ll" -o "$out/verify.ll"
  rm "$out/reach.ll" "$out/cut.ll"

  "$MLIR_BIN/mlir-translate" --import-llvm "$out/verify.ll" |
    "$MLIR_BIN/mlir-opt" --mlir-print-op-generic -o "$out/verify.mlir"
  "$MLIR_BIN/mlir-opt" --canonicalize='region-simplify=disabled' --mlir-print-op-generic \
    "$out/verify.mlir" -o "$out/canonical.mlir"
  # The dispatch build keeps cpufeatures' mutable cache, which the
  # extractor refuses; it is built to see what dispatch leaves behind.
  if python3 -I "$EXTRACT" "$out/canonical.mlir" "$out/op" > "$out/op.txt"; then
    python3 -I "$HERE/scripts/inventory.py" "$out" "$LLVM_BIN/llvm-cxxfilt" > "$out/inventory.md"
  elif [ "$v" = dispatch ]; then rmdir "$out/op"; else exit 1; fi

  {
    echo "variant: $v"
    echo "RUSTFLAGS: $(flags "$v")"
    rustc -vV | grep -E '^(rustc|LLVM)'
    "$LLVM_BIN/opt" --version | grep 'LLVM version'
    "$MLIR_BIN/mlir-opt" --version | grep 'LLVM version' | sed 's/^/mlir-opt /'
    echo "extractor: scripts/mlir_extract_region.py (firedancer $(git -C "$FIREDANCER" rev-parse --short HEAD)'s, long names hashed)"
  } > "$out/versions.txt"
}

cd "$HERE"
cargo fetch --manifest-path wrapper/Cargo.toml --locked
python3 -I scripts/lock_check.py wrapper/Cargo.lock agave/Cargo.lock
for v in "${@:-serial avx2}"; do for w in $v; do build "$w"; done; done
