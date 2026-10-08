module

-- zig-build/out/mlir_canonicalized/region/Edwards25519.dbl.mlir

public import SSA.Projects.RIR.Semantics.Func
public import SSA.Projects.RIR.Syntax.Elab
public import Zig.Mlir.Fe_add
public import Zig.Mlir.Fe_carry128
public import Zig.Mlir.Fe_mul
public import Zig.Mlir.Fe_sq
public import Zig.Mlir.Fe_sub

meta import SSA.Projects.RIR.Semantics.Func
meta import Zig.Mlir.Fe_add
meta import Zig.Mlir.Fe_carry128
meta import Zig.Mlir.Fe_mul
meta import Zig.Mlir.Fe_sq
meta import Zig.Mlir.Fe_sub

namespace LeanMLIR.RIR.Zig

@[expose] public section

mlir_def Edwards25519_dbl :=
{
  ^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr):
    %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
    %1 = "llvm.mlir.constant"() <{value = 168 : i64}> : () -> i64
    %2 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
    %3 = "llvm.mlir.constant"() <{value = 1 : i128}> : () -> i128
    %4 = "llvm.mlir.constant"() <{value = 38 : i128}> : () -> i128
    %5 = "llvm.mlir.constant"() <{value = 19 : i128}> : () -> i128
    %6 = "llvm.mlir.constant"() <{value = false}> : () -> i1
    %7 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.array<5 x i128>}> : (i32) -> !llvm.ptr
    %8 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %9 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %10 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %11 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %12 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %13 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %14 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %15 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %16 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %17 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %18 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %19 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %20 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>}> : (i32) -> !llvm.ptr
    "llvm.intr.memcpy"(%20, %arg1, %1) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    %21 = "llvm.getelementptr"(%arg1) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.call"(%19, %arg1, %21) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.add, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    "llvm.call"(%18, %19) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.sq, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
    "llvm.call"(%17, %arg1) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.sq, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
    %22 = "llvm.getelementptr"(%20) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.call"(%16, %22) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.sq, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
    %23 = "llvm.load"(%16) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %24 = "llvm.load"(%17) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %25 = "llvm.add"(%24, %23) <{overflowFlags = #llvm.overflow<nuw>}> : (i64, i64) -> i64
    %26 = "llvm.getelementptr"(%16) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
    %27 = "llvm.load"(%26) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %28 = "llvm.getelementptr"(%17) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
    %29 = "llvm.load"(%28) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %30 = "llvm.add"(%29, %27) <{overflowFlags = #llvm.overflow<nuw>}> : (i64, i64) -> i64
    %31 = "llvm.getelementptr"(%16) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
    %32 = "llvm.load"(%31) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %33 = "llvm.getelementptr"(%17) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
    %34 = "llvm.load"(%33) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %35 = "llvm.add"(%34, %32) <{overflowFlags = #llvm.overflow<nuw>}> : (i64, i64) -> i64
    %36 = "llvm.getelementptr"(%16) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
    %37 = "llvm.load"(%36) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %38 = "llvm.getelementptr"(%17) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
    %39 = "llvm.load"(%38) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %40 = "llvm.add"(%39, %37) <{overflowFlags = #llvm.overflow<nuw>}> : (i64, i64) -> i64
    %41 = "llvm.getelementptr"(%16) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
    %42 = "llvm.load"(%41) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %43 = "llvm.getelementptr"(%17) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
    %44 = "llvm.load"(%43) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %45 = "llvm.add"(%44, %42) <{overflowFlags = #llvm.overflow<nuw>}> : (i64, i64) -> i64
    "llvm.store"(%25, %15) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %46 = "llvm.getelementptr"(%15) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%30, %46) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %47 = "llvm.getelementptr"(%15) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%35, %47) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %48 = "llvm.getelementptr"(%15) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%40, %48) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %49 = "llvm.getelementptr"(%15) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%45, %49) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    "llvm.call"(%14, %16, %17) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.sub, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    "llvm.call"(%17, %18, %15) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.sub, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    %50 = "llvm.getelementptr"(%20) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 80>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.intr.lifetime.start"(%7) <{size = 80 : i64}> : (!llvm.ptr) -> ()
    %51 = "llvm.load"(%50) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %52 = "llvm.zext"(%51) : (i64) -> i128
    %53 = "llvm.getelementptr"(%20) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 88>}> : (!llvm.ptr) -> !llvm.ptr
    %54 = "llvm.load"(%53) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %55 = "llvm.zext"(%54) : (i64) -> i128
    %56 = "llvm.getelementptr"(%20) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
    %57 = "llvm.load"(%56) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %58 = "llvm.zext"(%57) : (i64) -> i128
    %59 = "llvm.getelementptr"(%20) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 104>}> : (!llvm.ptr) -> !llvm.ptr
    %60 = "llvm.load"(%59) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %61 = "llvm.zext"(%60) : (i64) -> i128
    %62 = "llvm.getelementptr"(%20) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 112>}> : (!llvm.ptr) -> !llvm.ptr
    %63 = "llvm.load"(%62) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %64 = "llvm.zext"(%63) : (i64) -> i128
    %65 = "llvm.shl"(%52, %3) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %66 = "llvm.shl"(%55, %3) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %67 = "llvm.mul"(%58, %4) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %68 = "llvm.mul"(%61, %5) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %69 = "llvm.mul"(%64, %5) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %70 = "llvm.mul"(%52, %52) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %71 = "llvm.mul"(%64, %4) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %72 = "llvm.mul"(%71, %55) <{overflowFlags = #llvm.overflow<none>}> : (i128, i128) -> i128
    %73 = "llvm.mul"(%67, %61) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %74 = "llvm.add"(%73, %70) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %75 = "llvm.add"(%74, %72) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %76 = "llvm.getelementptr"(%7) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
    %77 = "llvm.mul"(%65, %55) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %78 = "llvm.mul"(%67, %64) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %79 = "llvm.add"(%78, %77) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %80 = "llvm.mul"(%68, %61) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %81 = "llvm.add"(%79, %80) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %82 = "llvm.getelementptr"(%7) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
    %83 = "llvm.mul"(%65, %58) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %84 = "llvm.mul"(%55, %55) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %85 = "llvm.add"(%83, %84) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %86 = "llvm.mul"(%71, %61) <{overflowFlags = #llvm.overflow<none>}> : (i128, i128) -> i128
    %87 = "llvm.add"(%85, %86) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %88 = "llvm.getelementptr"(%7) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 48>}> : (!llvm.ptr) -> !llvm.ptr
    %89 = "llvm.mul"(%65, %61) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %90 = "llvm.mul"(%66, %58) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %91 = "llvm.add"(%89, %90) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %92 = "llvm.mul"(%69, %64) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %93 = "llvm.add"(%91, %92) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %94 = "llvm.getelementptr"(%7) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
    %95 = "llvm.mul"(%65, %64) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %96 = "llvm.mul"(%66, %61) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %97 = "llvm.mul"(%58, %58) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %98 = "llvm.add"(%96, %97) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %99 = "llvm.add"(%98, %95) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %100 = "llvm.shl"(%75, %3) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    "llvm.store"(%100, %7) <{alignment = 16 : i64, ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
    %101 = "llvm.shl"(%81, %3) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    "llvm.store"(%101, %76) <{alignment = 16 : i64, ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
    %102 = "llvm.shl"(%87, %3) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    "llvm.store"(%102, %82) <{alignment = 16 : i64, ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
    %103 = "llvm.shl"(%93, %3) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    "llvm.store"(%103, %88) <{alignment = 16 : i64, ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
    %104 = "llvm.shl"(%99, %3) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    "llvm.store"(%104, %94) <{alignment = 16 : i64, ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
    "llvm.call"(%13, %7) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.carry128, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
    "llvm.intr.lifetime.end"(%7) <{size = 80 : i64}> : (!llvm.ptr) -> ()
    "llvm.call"(%12, %13, %14) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.sub, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    "llvm.call"(%11, %17, %12) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.mul, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    "llvm.intr.memcpy"(%arg0, %11, %2) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    %105 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.call"(%10, %15, %14) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.mul, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    "llvm.intr.memcpy"(%105, %10, %2) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    %106 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 80>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.call"(%9, %14, %12) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.mul, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    "llvm.intr.memcpy"(%106, %9, %2) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    %107 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 120>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.call"(%8, %17, %15) <{CConv = #llvm.cconv<fastcc>, callee = @Fe.mul, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    "llvm.intr.memcpy"(%107, %8, %2) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    %108 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 160>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%6, %108) <{alignment = 8 : i64, ordering = 0 : i64}> : (i1, !llvm.ptr) -> ()
    "llvm.return"() : () -> ()
}
  with @Fe.add := Fe_add, @Fe.carry128 := Fe_carry128, @Fe.mul := Fe_mul, @Fe.sq := Fe_sq,
    @Fe.sub := Fe_sub

end

end LeanMLIR.RIR.Zig
