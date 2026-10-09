module

-- zig-build/out/mlir_canonicalized/region/Edwards25519.rejectIdentity.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Zig.Mlir.Fe_isZero

meta import MLIR.Semantics.Func
meta import Zig.Mlir.Fe_isZero

namespace MLIR.Zig

@[expose] public section

mlir_def Edwards25519_rejectIdentity :=
{
  ^bb0(%arg0: !llvm.ptr):
    %0 = "llvm.mlir.constant"() <{value = 3 : i16}> : () -> i16
    %1 = "llvm.mlir.constant"() <{value = 0 : i16}> : () -> i16
    %2 = "llvm.call"(%arg0) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.isZero, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i1
    %3 = "llvm.select"(%2, %0, %1) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i16, i16) -> i16
    "llvm.return"(%3) : (i16) -> ()
}
  with @Fe.isZero := Fe_isZero

end

end MLIR.Zig
