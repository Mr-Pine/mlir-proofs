#!/usr/bin/env bash
# Zig's ed25519 verify, compiled to LLVM IR and imported into MLIR, one op file per function and
# global, then lifted.
#
#   ZIG=<zig 0.15.2> ./build.sh   # from verify.zig: rewrites out/verify.ll, out/op, ../Zig/Mlir
#   ./build.sh                    # without zig: from the committed out/verify.ll
#
# src/ is lib/std/crypto at ziglang/zig 738d2be9d6b6 (GitHub master), its imports pointed at the
# local files. ReleaseSmall keeps Fe.mul a function (it is callconv(.inline) in ReleaseFast);
# without SSE, LLVM leaves the limb arithmetic scalar. Zig's unoptimized IR, run through its own
# clang at -Os, gives Zig's optimized IR exactly; `noinline.py` first keeps verify's parts as
# functions, `globals.py` and the `sed` give symbols Lean can take. Zig 0.15.2 is not installed
# here, so its output, out/verify.ll, is committed and the pipeline starts from it when `zig` is
# absent. LLVM 23's mlir-translate imports it; out/op and ../Zig/Mlir quote the result verbatim.
set -euo pipefail
cd "$(dirname "$0")"
ZIG=${ZIG:-zig}
LLVM=${LLVM:-$HOME/.local/llvm-23/bin}
LIFT=${LIFT:-../../lean-mlir/.claude/skills/mlir-proofs/scripts/lift.py}
mkdir -p out
if command -v "$ZIG" >/dev/null; then
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
else
  echo "no $ZIG: starting from the committed out/verify.ll" >&2
fi
"$LLVM/mlir-translate" --import-llvm out/verify.ll |
  "$LLVM/mlir-opt" --mlir-print-op-generic -o out/verify.mlir
"$LLVM/mlir-opt" --canonicalize='region-simplify=disabled' --mlir-print-op-generic \
  out/verify.mlir -o out/verify.canonical.mlir
rm -rf out/op
python3 mlir_extract_region.py out/verify.canonical.mlir out/op
python3 "$LIFT" --ops out/op --all --out ../Zig/Mlir --prefix Zig.Mlir --ns MLIR.Zig \
  --header zig-build/out/op
