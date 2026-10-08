module

-- zig-build/out/mlir_canonicalized/region/Fe.mul.mlir

public import SSA.Projects.RIR.Semantics.Func
public import SSA.Projects.RIR.Syntax.Elab
public import Zig.Mlir.Fe__carry128

meta import SSA.Projects.RIR.Semantics.Func
meta import Zig.Mlir.Fe__carry128

namespace LeanMLIR.RIR.Zig

@[expose] public section

mlir_def Fe_mul :=
{
  ^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: !llvm.ptr):
    %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
    %1 = "llvm.mlir.constant"() <{value = 19 : i128}> : () -> i128
    %2 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
    %3 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
    %4 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.array<5 x i128>}> : (i32) -> !llvm.ptr
    %5 = "llvm.load"(%arg1) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %6 = "llvm.zext"(%5) : (i64) -> i128
    %7 = "llvm.load"(%arg2) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %8 = "llvm.zext"(%7) : (i64) -> i128
    %9 = "llvm.getelementptr"(%arg1) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
    %10 = "llvm.load"(%9) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %11 = "llvm.zext"(%10) : (i64) -> i128
    %12 = "llvm.getelementptr"(%arg2) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
    %13 = "llvm.load"(%12) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %14 = "llvm.zext"(%13) : (i64) -> i128
    %15 = "llvm.getelementptr"(%arg1) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
    %16 = "llvm.load"(%15) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %17 = "llvm.zext"(%16) : (i64) -> i128
    %18 = "llvm.getelementptr"(%arg2) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
    %19 = "llvm.load"(%18) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %20 = "llvm.zext"(%19) : (i64) -> i128
    %21 = "llvm.getelementptr"(%arg1) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
    %22 = "llvm.load"(%21) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %23 = "llvm.zext"(%22) : (i64) -> i128
    %24 = "llvm.getelementptr"(%arg2) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
    %25 = "llvm.load"(%24) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %26 = "llvm.zext"(%25) : (i64) -> i128
    %27 = "llvm.getelementptr"(%arg1) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
    %28 = "llvm.load"(%27) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %29 = "llvm.zext"(%28) : (i64) -> i128
    %30 = "llvm.getelementptr"(%arg2) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
    %31 = "llvm.load"(%30) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %32 = "llvm.zext"(%31) : (i64) -> i128
    %33 = "llvm.mul"(%11, %1) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %34 = "llvm.mul"(%17, %1) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %35 = "llvm.mul"(%23, %1) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %36 = "llvm.mul"(%29, %1) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i128, i128) -> i128
    %37 = "llvm.mul"(%8, %6) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %38 = "llvm.mul"(%33, %32) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %39 = "llvm.mul"(%34, %26) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %40 = "llvm.mul"(%35, %20) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %41 = "llvm.mul"(%36, %14) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %42 = "llvm.add"(%39, %37) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %43 = "llvm.add"(%42, %40) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %44 = "llvm.add"(%43, %38) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %45 = "llvm.add"(%44, %41) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    "llvm.store"(%45, %4) <{alignment = 16 : i64, ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
    %46 = "llvm.getelementptr"(%4) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
    %47 = "llvm.mul"(%14, %6) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %48 = "llvm.mul"(%11, %8) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %49 = "llvm.add"(%47, %48) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %50 = "llvm.mul"(%34, %32) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %51 = "llvm.mul"(%35, %26) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %52 = "llvm.mul"(%36, %20) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %53 = "llvm.add"(%49, %51) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %54 = "llvm.add"(%53, %50) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %55 = "llvm.add"(%54, %52) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    "llvm.store"(%55, %46) <{alignment = 16 : i64, ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
    %56 = "llvm.getelementptr"(%4) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
    %57 = "llvm.mul"(%20, %6) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %58 = "llvm.mul"(%14, %11) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %59 = "llvm.mul"(%17, %8) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %60 = "llvm.mul"(%35, %32) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %61 = "llvm.mul"(%36, %26) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %62 = "llvm.add"(%59, %58) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %63 = "llvm.add"(%62, %57) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %64 = "llvm.add"(%63, %60) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %65 = "llvm.add"(%64, %61) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    "llvm.store"(%65, %56) <{alignment = 16 : i64, ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
    %66 = "llvm.getelementptr"(%4) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 48>}> : (!llvm.ptr) -> !llvm.ptr
    %67 = "llvm.mul"(%26, %6) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %68 = "llvm.mul"(%20, %11) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %69 = "llvm.mul"(%17, %14) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %70 = "llvm.mul"(%23, %8) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %71 = "llvm.mul"(%36, %32) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %72 = "llvm.add"(%68, %69) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %73 = "llvm.add"(%72, %70) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %74 = "llvm.add"(%73, %67) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %75 = "llvm.add"(%74, %71) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    "llvm.store"(%75, %66) <{alignment = 16 : i64, ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
    %76 = "llvm.getelementptr"(%4) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
    %77 = "llvm.mul"(%32, %6) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %78 = "llvm.mul"(%26, %11) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %79 = "llvm.mul"(%20, %17) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %80 = "llvm.mul"(%23, %14) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %81 = "llvm.mul"(%29, %8) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %82 = "llvm.add"(%80, %79) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %83 = "llvm.add"(%82, %78) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %84 = "llvm.add"(%83, %81) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    %85 = "llvm.add"(%84, %77) <{overflowFlags = #llvm.overflow<nuw>}> : (i128, i128) -> i128
    "llvm.store"(%85, %76) <{alignment = 16 : i64, ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
    "llvm.call"(%3, %4) <{CConv = #llvm.cconv<fastcc>, callee = @Fe._carry128, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
    "llvm.intr.memcpy"(%arg0, %3, %2) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    "llvm.return"() : () -> ()
}
  with @Fe._carry128 := Fe__carry128

end

end LeanMLIR.RIR.Zig
