#!/usr/bin/env bash
# The same link set as build.sh, compiled with -fno-inline -fno-unroll-loops: functions too long in
# the production lifts are proved on these instead, in Firedancer/LaneNI (a build of its own).
#
#   FD=<firedancer checkout at ac6d4a84b> ./build-noinline.sh
set -euo pipefail
cd "$(dirname "$0")"
FD=${FD:-$HOME/pr11958/firedancer}
LLVM=${LLVM:-$HOME/.local/llvm-23/bin}
EXTRACTOR=${EXTRACTOR:-../../lean-mlir/extractor/target/release/extractor}
OUT=../Firedancer/LaneNI/Mlir
mkdir -p out-noinline
sed -e "s|@FD@|$FD|g" -e "s|@CLANG@|$LLVM/clang|g" \
  -e 's|"-O3",|"-O3", "-fno-inline", "-fno-unroll-loops",|' compile_commands.in.json \
  > out-noinline/compile_commands.json
rm -rf out-noinline/build
"$EXTRACTOR" --llvm-bin "$LLVM" compile out-noinline/compile_commands.json out-noinline
"$EXTRACTOR" --llvm-bin "$LLVM" translate out-noinline/module.ll out-noinline
rm -rf "$OUT" blocked-noinline
roots=$(grep -o '^  "llvm.func"() <{.*sym_name = "[^"]*"' out-noinline/module.mlir | sed 's/.*sym_name = "//; s/"$//')
"$EXTRACTOR" import out-noinline/module.mlir .. Firedancer/LaneNI/Mlir Firedancer.LaneNI.Mlir \
  $(for r in $roots; do echo --root-func "$r"; done)
python3 postprocess.py "$OUT" Firedancer.LaneNI.Mlir
mkdir -p blocked-noinline
for f in $(cat blocked-noinline.txt 2>/dev/null); do
  mv "$OUT/$f.lean" blocked-noinline/
done
