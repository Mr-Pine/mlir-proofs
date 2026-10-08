module

-- zig-build/out/mlir_canonicalized/region/Edwards25519.neg.mlir

public import SSA.Projects.RIR.Semantics.Func
public import SSA.Projects.RIR.Syntax.Elab
public import Zig.Mlir.Fe_neg

meta import SSA.Projects.RIR.Semantics.Func
meta import Zig.Mlir.Fe_neg

namespace LeanMLIR.RIR.Zig

@[expose] public section

mlir_def Edwards25519_neg :=
{
  ^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr):
    %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
    %1 = "llvm.mlir.constant"() <{value = 168 : i64}> : () -> i64
    %2 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
    %3 = "llvm.mlir.constant"() <{value = false}> : () -> i1
    %4 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %5 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %6 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>}> : (i32) -> !llvm.ptr
    "llvm.intr.memcpy"(%6, %arg1, %1) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    "llvm.call"(%5, %arg1) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.neg, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
    "llvm.intr.memcpy"(%arg0, %5, %2) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    %7 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
    %8 = "llvm.getelementptr"(%arg1) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.intr.memcpy"(%7, %8, %2) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    %9 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 80>}> : (!llvm.ptr) -> !llvm.ptr
    %10 = "llvm.getelementptr"(%arg1) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 80>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.intr.memcpy"(%9, %10, %2) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    %11 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 120>}> : (!llvm.ptr) -> !llvm.ptr
    %12 = "llvm.getelementptr"(%6) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 120>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.call"(%4, %12) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.neg, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
    "llvm.intr.memcpy"(%11, %4, %2) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    %13 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 160>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%3, %13) <{alignment = 8 : i64, ordering = 0 : i64}> : (i1, !llvm.ptr) -> ()
    "llvm.return"() : () -> ()
}
  with @Fe.neg := Fe_neg

end

end LeanMLIR.RIR.Zig
