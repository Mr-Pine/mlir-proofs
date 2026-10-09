module

-- zig-build/out/mlir_canonicalized/region/Fe.neg.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Zig.Mlir.Fe_sub
public import Zig.Mlir.Fe_zero

meta import MLIR.Semantics.Func
meta import Zig.Mlir.Fe_sub
meta import Zig.Mlir.Fe_zero

namespace MLIR.Zig

@[expose] public section

mlir_def Fe_neg :=
{
  ^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr):
    %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
    %1 = "llvm.mlir.addressof"() <{global_name = @Fe.zero}> : () -> !llvm.ptr
    %2 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
    %3 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    "llvm.call"(%3, %1, %arg1) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.sub, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    "llvm.intr.memcpy"(%arg0, %3, %2) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    "llvm.return"() : () -> ()
}
  with @Fe.sub := Fe_sub, @Fe.zero := Fe_zero

end

end MLIR.Zig
