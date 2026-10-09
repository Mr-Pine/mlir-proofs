module

-- zig-build/out/mlir_canonicalized/region/Scalar.toBytes.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Zig

@[expose] public section

mlir_def Scalar_toBytes :=
{
  ^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr):
    %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
    %1 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
    %2 = "llvm.mlir.constant"() <{value = 4 : i64}> : () -> i64
    %3 = "llvm.mlir.constant"() <{value = 7 : i64}> : () -> i64
    %4 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
    %5 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
    %6 = "llvm.mlir.constant"() <{value = 4294967296 : i64}> : () -> i64
    %7 = "llvm.alloca"(%0) <{alignment = 1 : i64, elem_type = !llvm.array<32 x i8>}> : (i32) -> !llvm.ptr
    "llvm.br"(%1)[^bb1] : (i64) -> ()
  ^bb1(%8: i64):  // 2 preds: ^bb0, ^bb2
    %9 = "llvm.icmp"(%8, %2) <{predicate = 0 : i64}> : (i64, i64) -> i1
    "llvm.cond_br"(%9)[^bb3, ^bb2] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
  ^bb2:  // pred: ^bb1
    %10 = "llvm.mul"(%8, %3) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    %11 = "llvm.getelementptr"(%7, %10) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
    %12 = "llvm.getelementptr"(%arg1, %8) <{elem_type = !llvm.array<5 x i64>, inbounds, rawConstantIndices = array<i32: 0, -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
    %13 = "llvm.load"(%12) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    "llvm.store"(%13, %11) <{alignment = 1 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %14 = "llvm.add"(%8, %4) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    "llvm.br"(%14)[^bb1] : (i64) -> ()
  ^bb3:  // pred: ^bb1
    %15 = "llvm.getelementptr"(%7) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 28>}> : (!llvm.ptr) -> !llvm.ptr
    %16 = "llvm.getelementptr"(%arg1) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
    %17 = "llvm.load"(%16) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %18 = "llvm.icmp"(%17, %6) <{predicate = 6 : i64}> : (i64, i64) -> i1
    %19 = "llvm.mlir.constant"() <{value = true}> : () -> i1
    %20 = "llvm.mlir.poison"() : () -> i1
    %21 = "llvm.select"(%18, %19, %20) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i1, i1) -> i1
    "llvm.cond_br"(%21)[^assume0, ^assume0] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
  ^assume0:
    %22 = "llvm.trunc"(%17) <{overflowFlags = #llvm.overflow<nuw>}> : (i64) -> i32
    "llvm.store"(%22, %15) <{alignment = 1 : i64, ordering = 0 : i64}> : (i32, !llvm.ptr) -> ()
    "llvm.intr.memcpy"(%arg0, %7, %5) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    "llvm.return"() : () -> ()
}

end

end MLIR.Zig
