#!/usr/bin/env bash
# Zig's ed25519 verify, compiled to LLVM IR and imported into MLIR, one region per function.
#
#   ZIG=<zig 0.15.2> ./build.sh   # writes out/mlir_canonicalized/region/*.mlir and ../Zig/Mlir
#
# src/ is lib/std/crypto at ziglang/zig 738d2be9d6b6 (GitHub master), its imports pointed at the
# local files. ReleaseSmall keeps Fe.mul a function (it is callconv(.inline) in ReleaseFast);
# without SSE, LLVM leaves the limb arithmetic scalar. Zig 0.15.2 emits LLVM 20 IR, which
# mlir-translate-20 imports.
set -euo pipefail
cd "$(dirname "$0")"
ZIG=${ZIG:-zig}
LLVM=${LLVM:-/usr/lib/llvm-20/bin}
mkdir -p out
"$ZIG" build-obj -OReleaseSmall -target x86_64-linux -mcpu=x86_64-sse-sse2 -fno-emit-bin \
  -femit-llvm-ir=out/verify.full.ll verify.zig
# symbol names Lean can take: no module prefix, no type arguments, globals named
sed -E \
  -e 's/src\.(field|edwards25519|scalar)\.//g' \
  -e 's/"src\.sha2\.Sha2x64\([^)]*\)\.([a-z]+)"/Sha512.\1/g' \
  -e 's/"src\.sha2\.Sha2x64\([^)]*\)"/Sha512/g' \
  -e 's/@0\b/@scalar.field_order_s/g' -e 's/@1\b/@Fe.edwards25519d/g' \
  -e 's/@2\b/@Fe.one/g' -e 's/@3\b/@Edwards25519.fromBytes.invalid/g' \
  -e 's/@4\b/@Fe.sqrtm1/g' -e 's/@5\b/@Sha512.iv/g' -e 's/@6\b/@Fe.zero/g' \
  -e 's/@7\b/@Edwards25519.identityElement/g' -e 's/@8\b/@Fe.edwards25519d2/g' \
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
