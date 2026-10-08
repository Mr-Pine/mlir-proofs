module

-- zig-build/out/mlir_canonicalized/region/Sha512.final.mlir

public import SSA.Projects.RIR.Semantics.Func
public import SSA.Projects.RIR.Syntax.Elab
public import Zig.Mlir.Sha512_round

meta import SSA.Projects.RIR.Semantics.Func
meta import Zig.Mlir.Sha512_round

namespace LeanMLIR.RIR.Zig

@[expose] public section

noncomputable mlir_def Sha512_final :=
{
  ^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr):
    %0 = "llvm.mlir.constant"() <{value = 128 : i64}> : () -> i64
    %1 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
    %2 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
    %3 = "llvm.mlir.constant"() <{value = -128 : i8}> : () -> i8
    %4 = "llvm.mlir.constant"() <{value = 1 : i8}> : () -> i8
    %5 = "llvm.mlir.constant"() <{value = 111 : i8}> : () -> i8
    %6 = "llvm.mlir.constant"() <{value = 5 : i128}> : () -> i128
    %7 = "llvm.mlir.constant"() <{value = 3 : i8}> : () -> i8
    %8 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
    %9 = "llvm.mlir.constant"() <{value = 16 : i64}> : () -> i64
    %10 = "llvm.mlir.constant"() <{value = 127 : i64}> : () -> i64
    %11 = "llvm.mlir.constant"() <{value = 8 : i128}> : () -> i128
    %12 = "llvm.mlir.constant"() <{value = 8 : i64}> : () -> i64
    %13 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
    %14 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 80>}> : (!llvm.ptr) -> !llvm.ptr
    %15 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 208>}> : (!llvm.ptr) -> !llvm.ptr
    %16 = "llvm.load"(%15) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %17 = "llvm.zext"(%16) : (i8) -> i64
    %18 = "llvm.getelementptr"(%14, %17) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
    %19 = "llvm.sub"(%0, %17) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    "llvm.intr.memset"(%18, %1, %19) <{isVolatile = false}> : (!llvm.ptr, i8, i64) -> ()
    %20 = "llvm.load"(%15) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %21 = "llvm.zext"(%20) : (i8) -> i64
    %22 = "llvm.getelementptr"(%14, %21) <{elem_type = !llvm.array<128 x i8>, inbounds, rawConstantIndices = array<i32: 0, -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
    "llvm.store"(%3, %22) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
    %23 = "llvm.load"(%15) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
    %24 = "llvm.add"(%23, %4) <{overflowFlags = #llvm.overflow<nuw>}> : (i8, i8) -> i8
    "llvm.store"(%24, %15) <{alignment = 16 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
    %25 = "llvm.icmp"(%23, %5) <{predicate = 8 : i64}> : (i8, i8) -> i1
    "llvm.cond_br"(%25)[^bb2, ^bb1] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
  ^bb1:  // 2 preds: ^bb0, ^bb2
    %26 = "llvm.load"(%arg0) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i128
    %27 = "llvm.lshr"(%26, %6) : (i128, i128) -> i128
    %28 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 207>}> : (!llvm.ptr) -> !llvm.ptr
    %29 = "llvm.trunc"(%26) <{overflowFlags = #llvm.overflow<none>}> : (i128) -> i8
    %30 = "llvm.shl"(%29, %7) <{overflowFlags = #llvm.overflow<none>}> : (i8, i8) -> i8
    "llvm.store"(%30, %28) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
    "llvm.br"(%8, %27)[^bb3] : (i64, i128) -> ()
  ^bb2:  // pred: ^bb0
    "llvm.call"(%arg0, %14) <{CConv = #llvm.cconv<fastcc>, callee = @Sha512.round, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
    "llvm.intr.memset"(%14, %1, %0) <{isVolatile = false}> : (!llvm.ptr, i8, i64) -> ()
    "llvm.br"()[^bb1] : () -> ()
  ^bb3(%31: i64, %32: i128):  // 2 preds: ^bb1, ^bb4
    %33 = "llvm.icmp"(%31, %9) <{predicate = 0 : i64}> : (i64, i64) -> i1
    "llvm.cond_br"(%33)[^bb5, ^bb4] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
  ^bb4:  // pred: ^bb3
    %34 = "llvm.sub"(%10, %31) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    %35 = "llvm.getelementptr"(%14, %34) <{elem_type = !llvm.array<128 x i8>, inbounds, rawConstantIndices = array<i32: 0, -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
    %36 = "llvm.trunc"(%32) <{overflowFlags = #llvm.overflow<none>}> : (i128) -> i8
    "llvm.store"(%36, %35) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
    %37 = "llvm.lshr"(%32, %11) : (i128, i128) -> i128
    %38 = "llvm.add"(%31, %8) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    "llvm.br"(%38, %37)[^bb3] : (i64, i128) -> ()
  ^bb5:  // pred: ^bb3
    "llvm.call"(%arg0, %14) <{CConv = #llvm.cconv<fastcc>, callee = @Sha512.round, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
    %39 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.br"(%2)[^bb6] : (i64) -> ()
  ^bb6(%40: i64):  // 2 preds: ^bb5, ^bb7
    %41 = "llvm.icmp"(%40, %12) <{predicate = 0 : i64}> : (i64, i64) -> i1
    "llvm.cond_br"(%41)[^bb8, ^bb7] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
  ^bb7:  // pred: ^bb6
    %42 = "llvm.getelementptr"(%39, %40) <{elem_type = !llvm.array<8 x i64>, inbounds, rawConstantIndices = array<i32: 0, -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
    %43 = "llvm.load"(%42) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %44 = "llvm.shl"(%40, %13) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    %45 = "llvm.getelementptr"(%arg1, %44) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
    %46 = "llvm.intr.bswap"(%43) : (i64) -> i64
    "llvm.store"(%46, %45) <{alignment = 1 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %47 = "llvm.add"(%40, %8) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    "llvm.br"(%47)[^bb6] : (i64) -> ()
  ^bb8:  // pred: ^bb6
    "llvm.return"() : () -> ()
}
  with @Sha512.round := Sha512_round

end

end LeanMLIR.RIR.Zig
