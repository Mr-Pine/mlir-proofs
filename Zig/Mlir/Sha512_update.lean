module

-- zig-build/out/mlir_canonicalized/region/Sha512.update.mlir

public import SSA.Projects.RIR.Semantics.Func
public import SSA.Projects.RIR.Syntax.Elab
public import Zig.Mlir.Sha512_round

meta import SSA.Projects.RIR.Semantics.Func
meta import Zig.Mlir.Sha512_round

namespace LeanMLIR.RIR.Zig

@[expose] public section

noncomputable mlir_def Sha512_update :=
{
  ^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: i64):
    %0 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
    %1 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
    %2 = "llvm.mlir.constant"() <{value = 127 : i64}> : () -> i64
    %3 = "llvm.mlir.constant"() <{value = -128 : i8}> : () -> i8
    %4 = "llvm.mlir.constant"() <{value = 128 : i64}> : () -> i64
    %5 = "llvm.mlir.constant"() <{value = 256 : i64}> : () -> i64
    %6 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 208>}> : (!llvm.ptr) -> !llvm.ptr
    %7 = "llvm.load"(%6) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %8 = "llvm.icmp"(%7, %0) <{predicate = 0 : i64}> : (i8, i8) -> i1
    "llvm.cond_br"(%8, %1)[^bb3, ^bb1] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
  ^bb1:  // pred: ^bb0
    %9 = "llvm.zext"(%7) : (i8) -> i64
    %10 = "llvm.add"(%arg2, %9) <{overflowFlags = #llvm.overflow<nuw>}> : (i64, i64) -> i64
    %11 = "llvm.icmp"(%10, %2) <{predicate = 8 : i64}> : (i64, i64) -> i1
    "llvm.cond_br"(%11, %1)[^bb2, ^bb3] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
  ^bb2:  // pred: ^bb1
    %12 = "llvm.sub"(%3, %7) <{overflowFlags = #llvm.overflow<nuw>}> : (i8, i8) -> i8
    %13 = "llvm.zext"(%12) <{nonNeg}> : (i8) -> i64
    %14 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 80>}> : (!llvm.ptr) -> !llvm.ptr
    %15 = "llvm.getelementptr"(%14, %9) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
    "llvm.intr.memcpy"(%15, %arg1, %13) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    "llvm.call"(%arg0, %14) <{CConv = #llvm.cconv<fastcc>, callee = @Sha512.round, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
    "llvm.store"(%0, %6) <{alignment = 16 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
    "llvm.br"(%13)[^bb3] : (i64) -> ()
  ^bb3(%16: i64):  // 3 preds: ^bb0, ^bb1, ^bb2
    "llvm.br"(%16)[^bb4] : (i64) -> ()
  ^bb4(%17: i64):  // 2 preds: ^bb3, ^bb5
    %18 = "llvm.add"(%17, %4) <{overflowFlags = #llvm.overflow<nuw>}> : (i64, i64) -> i64
    %19 = "llvm.icmp"(%18, %arg2) <{predicate = 8 : i64}> : (i64, i64) -> i1
    %20 = "llvm.getelementptr"(%arg1, %17) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
    "llvm.cond_br"(%19)[^bb6, ^bb5] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
  ^bb5:  // pred: ^bb4
    "llvm.call"(%arg0, %20) <{CConv = #llvm.cconv<fastcc>, callee = @Sha512.round, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
    "llvm.br"(%18)[^bb4] : (i64) -> ()
  ^bb6:  // pred: ^bb4
    %21 = "llvm.sub"(%arg2, %17) <{overflowFlags = #llvm.overflow<nuw>}> : (i64, i64) -> i64
    %22 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 80>}> : (!llvm.ptr) -> !llvm.ptr
    %23 = "llvm.load"(%6) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %24 = "llvm.zext"(%23) : (i8) -> i64
    %25 = "llvm.getelementptr"(%22, %24) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
    "llvm.intr.memcpy"(%25, %20, %21) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    %26 = "llvm.load"(%6) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %27 = "llvm.icmp"(%21, %5) <{predicate = 6 : i64}> : (i64, i64) -> i1
    %28 = "llvm.mlir.constant"() <{value = true}> : () -> i1
    %29 = "llvm.mlir.poison"() : () -> i1
    %30 = "llvm.select"(%27, %28, %29) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i1, i1) -> i1
    "llvm.cond_br"(%30)[^assume0, ^assume0] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
  ^assume0:
    %31 = "llvm.trunc"(%21) <{overflowFlags = #llvm.overflow<nuw>}> : (i64) -> i8
    %32 = "llvm.add"(%26, %31) <{overflowFlags = #llvm.overflow<nuw>}> : (i8, i8) -> i8
    "llvm.store"(%32, %6) <{alignment = 16 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
    %33 = "llvm.load"(%arg0) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i128
    %34 = "llvm.zext"(%arg2) : (i64) -> i128
    %35 = "llvm.add"(%33, %34) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    "llvm.store"(%35, %arg0) <{alignment = 16 : i64, ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
    "llvm.return"() : () -> ()
}
  with @Sha512.round := Sha512_round

end

end LeanMLIR.RIR.Zig
