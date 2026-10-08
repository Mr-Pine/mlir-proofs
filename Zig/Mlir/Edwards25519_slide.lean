module

-- zig-build/out/mlir_canonicalized/region/Edwards25519.slide.mlir

public import SSA.Projects.RIR.Semantics.Func
public import SSA.Projects.RIR.Syntax.Elab
public import Zig.Mlir.Scalar_fromBytes
public import Zig.Mlir.Scalar_toBytes

meta import SSA.Projects.RIR.Semantics.Func
meta import Zig.Mlir.Scalar_fromBytes
meta import Zig.Mlir.Scalar_toBytes

namespace LeanMLIR.RIR.Zig

@[expose] public section

mlir_def Edwards25519_slide :=
{
  ^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr):
    %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
    %1 = "llvm.mlir.constant"() <{value = -1 : i8}> : () -> i8
    %2 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
    %3 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
    %4 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
    %5 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
    %6 = "llvm.mlir.constant"() <{value = 15 : i8}> : () -> i8
    %7 = "llvm.mlir.constant"() <{value = 4 : i8}> : () -> i8
    %8 = "llvm.mlir.constant"() <{value = 63 : i64}> : () -> i64
    %9 = "llvm.mlir.constant"() <{value = 8 : i8}> : () -> i8
    %10 = "llvm.mlir.constant"() <{value = -16 : i8}> : () -> i8
    %11 = "llvm.mlir.constant"() <{value = 64 : i64}> : () -> i64
    %12 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Scalar", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %13 = "llvm.alloca"(%0) <{alignment = 1 : i64, elem_type = !llvm.array<64 x i8>}> : (i32) -> !llvm.ptr
    %14 = "llvm.alloca"(%0) <{alignment = 1 : i64, elem_type = !llvm.array<32 x i8>}> : (i32) -> !llvm.ptr
    %15 = "llvm.getelementptr"(%arg1) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 31>}> : (!llvm.ptr) -> !llvm.ptr
    %16 = "llvm.load"(%15) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %17 = "llvm.icmp"(%16, %1) <{predicate = 4 : i64}> : (i8, i8) -> i1
    "llvm.cond_br"(%17, %arg1)[^bb1, ^bb2] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, !llvm.ptr) -> ()
  ^bb1(%18: !llvm.ptr):  // 2 preds: ^bb0, ^bb2
    "llvm.br"(%2)[^bb3] : (i64) -> ()
  ^bb2:  // pred: ^bb0
    "llvm.intr.lifetime.start"(%12) <{size = 40 : i64}> : (!llvm.ptr) -> ()
    "llvm.call"(%12, %arg1) <{CConv = #llvm.cconv<fastcc>, callee = @Scalar.fromBytes, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
    "llvm.call"(%14, %12) <{CConv = #llvm.cconv<fastcc>, callee = @Scalar.toBytes, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
    "llvm.intr.lifetime.end"(%12) <{size = 40 : i64}> : (!llvm.ptr) -> ()
    "llvm.br"(%14)[^bb1] : (!llvm.ptr) -> ()
  ^bb3(%19: i64):  // 2 preds: ^bb1, ^bb4
    %20 = "llvm.icmp"(%19, %3) <{predicate = 0 : i64}> : (i64, i64) -> i1
    "llvm.cond_br"(%20, %2, %4)[^bb5, ^bb4] <{operandSegmentSizes = array<i32: 1, 2, 0>}> : (i1, i64, i8) -> ()
  ^bb4:  // pred: ^bb3
    %21 = "llvm.getelementptr"(%18, %19) <{elem_type = !llvm.array<32 x i8>, inbounds, rawConstantIndices = array<i32: 0, -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
    %22 = "llvm.load"(%21) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %23 = "llvm.shl"(%19, %5) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    %24 = "llvm.getelementptr"(%13, %23) <{elem_type = !llvm.array<64 x i8>, inbounds, rawConstantIndices = array<i32: 0, -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
    %25 = "llvm.and"(%22, %6) : (i8, i8) -> i8
    "llvm.store"(%25, %24) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
    %26 = "llvm.or"(%23, %5) <{isDisjoint}> : (i64, i64) -> i64
    %27 = "llvm.getelementptr"(%13, %26) <{elem_type = !llvm.array<64 x i8>, inbounds, rawConstantIndices = array<i32: 0, -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
    %28 = "llvm.lshr"(%22, %7) : (i8, i8) -> i8
    "llvm.store"(%28, %27) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
    %29 = "llvm.add"(%19, %5) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    "llvm.br"(%29)[^bb3] : (i64) -> ()
  ^bb5(%30: i64, %31: i8):  // 2 preds: ^bb3, ^bb6
    %32 = "llvm.icmp"(%30, %8) <{predicate = 0 : i64}> : (i64, i64) -> i1
    "llvm.cond_br"(%32)[^bb7, ^bb6] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
  ^bb6:  // pred: ^bb5
    %33 = "llvm.getelementptr"(%13, %30) <{elem_type = !llvm.array<63 x i8>, inbounds, rawConstantIndices = array<i32: 0, -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
    %34 = "llvm.load"(%33) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %35 = "llvm.add"(%34, %31) <{overflowFlags = #llvm.overflow<nsw>}> : (i8, i8) -> i8
    %36 = "llvm.add"(%35, %9) <{overflowFlags = #llvm.overflow<nsw>}> : (i8, i8) -> i8
    %37 = "llvm.ashr"(%36, %7) : (i8, i8) -> i8
    %38 = "llvm.and"(%36, %10) : (i8, i8) -> i8
    %39 = "llvm.sub"(%35, %38) <{overflowFlags = #llvm.overflow<nsw>}> : (i8, i8) -> i8
    "llvm.store"(%39, %33) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
    %40 = "llvm.add"(%30, %5) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    "llvm.br"(%40, %37)[^bb5] : (i64, i8) -> ()
  ^bb7:  // pred: ^bb5
    %41 = "llvm.getelementptr"(%13) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 63>}> : (!llvm.ptr) -> !llvm.ptr
    %42 = "llvm.load"(%41) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %43 = "llvm.add"(%42, %31) <{overflowFlags = #llvm.overflow<nsw>}> : (i8, i8) -> i8
    "llvm.store"(%43, %41) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
    "llvm.intr.memcpy"(%arg0, %13, %11) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    "llvm.return"() : () -> ()
}
  with @Scalar.fromBytes := Scalar_fromBytes, @Scalar.toBytes := Scalar_toBytes

end

end LeanMLIR.RIR.Zig
