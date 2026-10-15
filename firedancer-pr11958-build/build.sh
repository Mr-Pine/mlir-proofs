#!/usr/bin/env bash
# Firedancer PR 11958 (ac6d4a84b, eight-lane multi-message batch verify), lifted with the MLIR
# extractor: every function of the ed25519 link set (ballet/ed25519, sha512, fd_hash).
#
#   FD=<firedancer checkout at ac6d4a84b> ./build.sh   # rewrites out/module.mlir, ../Firedancer/Lane/Mlir
#
# The flags are a clang build's for this machine (znver4, -O3, FD_HAS_AVX512, FD_SHA512_CORE_IMPL=0),
# with -g0 (debug intrinsics would swell every op) and without -falign-functions (a function
# attribute the framework rejects); neither changes the code. postprocess.py marks lifts too big for
# the code generator noncomputable, and makes the callees the framework
# cannot lift yet (blocked/: inttoptr in the multi-buffer SHA-512) parameters of their callers, and
# the cached verify a parameter of the cached batch entry until it is proved.
set -euo pipefail
cd "$(dirname "$0")"
FD=${FD:-$HOME/pr11958/firedancer}
LLVM=${LLVM:-$HOME/.local/llvm-23/bin}
EXTRACTOR=${EXTRACTOR:-../../lean-mlir/extractor/target/release/extractor}
OUT=../Firedancer/Lane/Mlir
sed -e "s|@FD@|$FD|g" -e "s|@CLANG@|$LLVM/clang|g" compile_commands.in.json > out/compile_commands.json
rm -rf out/build
"$EXTRACTOR" --llvm-bin "$LLVM" compile out/compile_commands.json out
"$EXTRACTOR" --llvm-bin "$LLVM" translate out/module.ll out
rm -rf "$OUT" blocked
# every function of the module; those the framework cannot lift yet stay in blocked/
roots=$(grep -o '^  "llvm.func"() <{.*sym_name = "[^"]*"' out/module.mlir | sed 's/.*sym_name = "//; s/"$//')
"$EXTRACTOR" import out/module.mlir .. Firedancer/Lane/Mlir Firedancer.Lane.Mlir \
  $(for r in $roots; do echo --root-func "$r"; done)
python3 postprocess.py "$OUT" Firedancer.Lane.Mlir
mkdir -p blocked
# inttoptr (the multi-buffer SHA-512), variadic calls (FD_LOG_*), inline asm barriers, ctpop,
# zero_call_used_regs, thread_local_, load.relative, and their callers
for f in $(cat blocked.txt); do
  mv "$OUT/$f.lean" blocked/
done
