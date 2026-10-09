module

-- zig-build/out/mlir_canonicalized/region/Verifier.isIdentity.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Zig.Mlir.Fe_isZero
public import Zig.Mlir.Fe_sub

meta import MLIR.Semantics.Func
meta import Zig.Mlir.Fe_isZero
meta import Zig.Mlir.Fe_sub

namespace MLIR.Zig

@[expose] public section

mlir_def Verifier_isIdentity :=
{
  ^bb0(%arg0: !llvm.ptr):
    %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
    %1 = "llvm.mlir.constant"() <{value = 168 : i64}> : () -> i64
    %2 = "llvm.mlir.constant"() <{value = false}> : () -> i1
    %3 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %4 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>}> : (i32) -> !llvm.ptr
    "llvm.intr.memcpy"(%4, %arg0, %1) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    %5 = "llvm.call"(%arg0) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.isZero, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i1
    "llvm.cond_br"(%5, %2)[^bb2, ^bb1] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i1) -> ()
  ^bb1(%6: i1):  // 2 preds: ^bb0, ^bb2
    "llvm.return"(%6) : (i1) -> ()
  ^bb2:  // pred: ^bb0
    %7 = "llvm.getelementptr"(%4) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
    %8 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 80>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.intr.lifetime.start"(%3) <{size = 40 : i64}> : (!llvm.ptr) -> ()
    "llvm.call"(%3, %7, %8) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.sub, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    %9 = "llvm.call"(%3) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.isZero, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i1
    "llvm.intr.lifetime.end"(%3) <{size = 40 : i64}> : (!llvm.ptr) -> ()
    "llvm.br"(%9)[^bb1] : (i1) -> ()
}
  with @Fe.isZero := Fe_isZero, @Fe.sub := Fe_sub

end

end MLIR.Zig
