module

-- zig-build/out/mlir_canonicalized/region/Fe.sq.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Zig.Mlir.Fe_carry128

meta import MLIR.Semantics.Func
meta import Zig.Mlir.Fe_carry128

namespace MLIR.Zig

@[expose] public section

mlir_def Fe_sq :=
{
  ^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr):
    %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
    %1 = "llvm.mlir.constant"() <{value = 1 : i128}> : () -> i128
    %2 = "llvm.mlir.constant"() <{value = 38 : i128}> : () -> i128
    %3 = "llvm.mlir.constant"() <{value = 19 : i128}> : () -> i128
    %4 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
    %5 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.array<5 x i128>}> : (i32) -> !llvm.ptr
    %6 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.array<5 x i64>}> : (i32) -> !llvm.ptr
    "llvm.intr.lifetime.start"(%5) <{size = 80 : i64}> : (!llvm.ptr) -> ()
    %7 = "llvm.load"(%arg1) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %8 = "llvm.zext"(%7) : (i64) -> i128
    %9 = "llvm.getelementptr"(%arg1) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
    %10 = "llvm.load"(%9) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %11 = "llvm.zext"(%10) : (i64) -> i128
    %12 = "llvm.getelementptr"(%arg1) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
    %13 = "llvm.load"(%12) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %14 = "llvm.zext"(%13) : (i64) -> i128
    %15 = "llvm.getelementptr"(%arg1) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
    %16 = "llvm.load"(%15) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %17 = "llvm.zext"(%16) : (i64) -> i128
    %18 = "llvm.getelementptr"(%arg1) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
    %19 = "llvm.load"(%18) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %20 = "llvm.zext"(%19) : (i64) -> i128
    %21 = "llvm.shl"(%8, %1) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %22 = "llvm.shl"(%11, %1) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %23 = "llvm.mul"(%14, %2) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %24 = "llvm.mul"(%17, %3) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %25 = "llvm.mul"(%20, %3) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %26 = "llvm.mul"(%8, %8) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %27 = "llvm.mul"(%20, %2) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %28 = "llvm.mul"(%27, %11) <{overflowFlags = #llvm.overflow<none>}> : (i128, i128) -> i128
    %29 = "llvm.mul"(%23, %17) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %30 = "llvm.add"(%29, %26) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %31 = "llvm.add"(%30, %28) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    "llvm.store"(%31, %5) <{alignment = 16 : i64, ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
    %32 = "llvm.getelementptr"(%5) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
    %33 = "llvm.mul"(%21, %11) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %34 = "llvm.mul"(%23, %20) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %35 = "llvm.add"(%34, %33) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %36 = "llvm.mul"(%24, %17) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %37 = "llvm.add"(%35, %36) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    "llvm.store"(%37, %32) <{alignment = 16 : i64, ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
    %38 = "llvm.getelementptr"(%5) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
    %39 = "llvm.mul"(%21, %14) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %40 = "llvm.mul"(%11, %11) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %41 = "llvm.add"(%39, %40) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %42 = "llvm.mul"(%27, %17) <{overflowFlags = #llvm.overflow<none>}> : (i128, i128) -> i128
    %43 = "llvm.add"(%41, %42) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    "llvm.store"(%43, %38) <{alignment = 16 : i64, ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
    %44 = "llvm.getelementptr"(%5) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 48>}> : (!llvm.ptr) -> !llvm.ptr
    %45 = "llvm.mul"(%21, %17) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %46 = "llvm.mul"(%22, %14) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %47 = "llvm.add"(%45, %46) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %48 = "llvm.mul"(%25, %20) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %49 = "llvm.add"(%47, %48) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    "llvm.store"(%49, %44) <{alignment = 16 : i64, ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
    %50 = "llvm.getelementptr"(%5) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
    %51 = "llvm.mul"(%21, %20) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %52 = "llvm.mul"(%22, %17) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %53 = "llvm.mul"(%14, %14) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %54 = "llvm.add"(%52, %53) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %55 = "llvm.add"(%54, %51) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    "llvm.store"(%55, %50) <{alignment = 16 : i64, ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
    "llvm.call"(%6, %5) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.carry128, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
    "llvm.intr.lifetime.end"(%5) <{size = 80 : i64}> : (!llvm.ptr) -> ()
    "llvm.intr.memcpy"(%arg0, %6, %4) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    "llvm.return"() : () -> ()
}
  with @Fe.carry128 := Fe_carry128

end

end MLIR.Zig
