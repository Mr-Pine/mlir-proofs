#!/usr/bin/env bash
# Zig's ed25519 verify, compiled to LLVM IR and imported into MLIR, one region per function.
#
#   ZIG=<zig 0.15.2> ./build.sh   # writes out/mlir_canonicalized/region/*.mlir and ../Zig/Mlir
#
# src/ is lib/std/crypto at ziglang/zig 738d2be9d6b6 (GitHub master), its imports pointed at the
# local files. ReleaseSmall keeps Fe.mul a function (it is callconv(.inline) in ReleaseFast);
# without SSE, LLVM leaves the limb arithmetic scalar. Zig 0.15.2 emits LLVM 20 IR, which
# mlir-translate-20 imports. Zig's unoptimized IR, run through its own clang at -Os, gives Zig's
# optimized IR exactly; `noinline.py` first keeps verify's parts as functions.
set -euo pipefail
cd "$(dirname "$0")"
ZIG=${ZIG:-zig}
LLVM=${LLVM:-/usr/lib/llvm-20/bin}
mkdir -p out
"$ZIG" build-obj -OReleaseSmall -target x86_64-linux -mcpu=x86_64-sse-sse2 -fno-emit-bin \
  --verbose-llvm-ir=out/verify.unopt.ll verify.zig
python3 noinline.py out/verify.unopt.ll out/verify.marked.ll
"$ZIG" clang -target x86_64-linux-musl -Os -S -emit-llvm -Wno-override-module \
  out/verify.marked.ll -o out/verify.opt.ll
python3 globals.py out/verify.opt.ll out/verify.full.ll
# symbol names Lean can take: no module prefix, no type arguments, globals named
sed -E \
  -e 's/src\.scalar\.(reduce64|mul8|rejectNonCanonical)\b/scalar.\1/g' \
  -e 's/src\.ed25519\.Ed25519\.//g' -e 's/(precompute|rejectNonCanonical)__anon_[0-9]+/\1/g' \
  -e 's/src\.(field|edwards25519|scalar)\.//g' -e 's/Fe\._carry128/Fe.carry128/g' \
  -e 's/"src\.sha2\.Sha2x64\([^)]*\)\.([a-z]+)"/Sha512.\1/g' \
  -e 's/"src\.sha2\.Sha2x64\([^)]*\)"/Sha512/g' \
  out/verify.full.ll > out/verify.ll
"$LLVM/mlir-translate" --import-llvm out/verify.ll 2>/dev/null |
  "$LLVM/mlir-opt" --mlir-print-op-generic -o out/verify.mlir
mkdir -p out/mlir_canonicalized/region
"$LLVM/mlir-opt" --canonicalize='region-simplify=disabled' --mlir-print-op-generic \
  out/verify.mlir -o out/verify.canonical.mlir
python3 rewrite.py out/verify.canonical.mlir out/mlir_canonicalized/verify.mlir
python3 extract_region.py out/mlir_canonicalized/verify.mlir out/mlir_canonicalized/region
python3 rewrite.py --regions out/mlir_canonicalized/region
python3 lift.py --src out/mlir_canonicalized/region --out ../Zig/Mlir --prefix Zig.Mlir \
  --ns LeanMLIR.RIR.Zig zig_ed25519_verify
