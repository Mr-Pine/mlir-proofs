module

-- zig-build/out/mlir_canonicalized/region/Fe.reduce.mlir

public import SSA.Projects.RIR.Semantics.Func
public import SSA.Projects.RIR.Syntax.Elab

meta import SSA.Projects.RIR.Semantics.Func

namespace LeanMLIR.RIR.Zig

@[expose] public section

mlir_def Fe_reduce :=
{
  ^bb0(%arg0: !llvm.ptr):
    %0 = "llvm.mlir.constant"() <{value = 51 : i64}> : () -> i64
    %1 = "llvm.mlir.constant"() <{value = 2251799813685247 : i64}> : () -> i64
    %2 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
    %3 = "llvm.mlir.constant"() <{value = 2251799813685229 : i64}> : () -> i64
    %4 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
    %5 = "llvm.load"(%4) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %6 = "llvm.load"(%arg0) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %7 = "llvm.lshr"(%6, %0) : (i64, i64) -> i64
    %8 = "llvm.add"(%7, %5) <{overflowFlags = #llvm.overflow<nuw>}> : (i64, i64) -> i64
    %9 = "llvm.and"(%6, %1) : (i64, i64) -> i64
    %10 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
    %11 = "llvm.load"(%10) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %12 = "llvm.lshr"(%8, %0) : (i64, i64) -> i64
    %13 = "llvm.add"(%11, %12) <{overflowFlags = #llvm.overflow<nuw>}> : (i64, i64) -> i64
    %14 = "llvm.and"(%8, %1) : (i64, i64) -> i64
    %15 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
    %16 = "llvm.load"(%15) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %17 = "llvm.lshr"(%13, %0) : (i64, i64) -> i64
    %18 = "llvm.add"(%16, %17) <{overflowFlags = #llvm.overflow<nuw>}> : (i64, i64) -> i64
    %19 = "llvm.and"(%13, %1) : (i64, i64) -> i64
    %20 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
    %21 = "llvm.load"(%20) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %22 = "llvm.lshr"(%18, %0) : (i64, i64) -> i64
    %23 = "llvm.add"(%21, %22) <{overflowFlags = #llvm.overflow<nuw>}> : (i64, i64) -> i64
    %24 = "llvm.and"(%18, %1) : (i64, i64) -> i64
    %25 = "llvm.lshr"(%23, %0) : (i64, i64) -> i64
    %26 = "llvm.mul"(%25, %2) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    %27 = "llvm.add"(%26, %9) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    %28 = "llvm.and"(%23, %1) : (i64, i64) -> i64
    %29 = "llvm.lshr"(%27, %0) : (i64, i64) -> i64
    %30 = "llvm.add"(%29, %14) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    %31 = "llvm.and"(%27, %1) : (i64, i64) -> i64
    %32 = "llvm.lshr"(%30, %0) : (i64, i64) -> i64
    %33 = "llvm.add"(%32, %19) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    %34 = "llvm.and"(%30, %1) : (i64, i64) -> i64
    %35 = "llvm.lshr"(%33, %0) : (i64, i64) -> i64
    %36 = "llvm.add"(%35, %24) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    %37 = "llvm.and"(%33, %1) : (i64, i64) -> i64
    %38 = "llvm.lshr"(%36, %0) : (i64, i64) -> i64
    %39 = "llvm.add"(%38, %28) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    %40 = "llvm.and"(%36, %1) : (i64, i64) -> i64
    %41 = "llvm.lshr"(%39, %0) : (i64, i64) -> i64
    %42 = "llvm.mul"(%41, %2) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    %43 = "llvm.add"(%42, %31) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    %44 = "llvm.and"(%39, %1) : (i64, i64) -> i64
    %45 = "llvm.add"(%43, %2) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    %46 = "llvm.lshr"(%45, %0) : (i64, i64) -> i64
    %47 = "llvm.add"(%46, %34) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    %48 = "llvm.and"(%45, %1) : (i64, i64) -> i64
    %49 = "llvm.lshr"(%47, %0) : (i64, i64) -> i64
    %50 = "llvm.add"(%49, %37) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    %51 = "llvm.and"(%47, %1) : (i64, i64) -> i64
    %52 = "llvm.lshr"(%50, %0) : (i64, i64) -> i64
    %53 = "llvm.add"(%52, %40) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    %54 = "llvm.and"(%50, %1) : (i64, i64) -> i64
    %55 = "llvm.lshr"(%53, %0) : (i64, i64) -> i64
    %56 = "llvm.add"(%55, %44) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    %57 = "llvm.and"(%53, %1) : (i64, i64) -> i64
    %58 = "llvm.lshr"(%56, %0) : (i64, i64) -> i64
    %59 = "llvm.mul"(%58, %2) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    %60 = "llvm.add"(%59, %48) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    %61 = "llvm.add"(%60, %3) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    %62 = "llvm.add"(%51, %1) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    %63 = "llvm.add"(%54, %1) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    %64 = "llvm.add"(%57, %1) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    %65 = "llvm.add"(%56, %1) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    %66 = "llvm.lshr"(%61, %0) : (i64, i64) -> i64
    %67 = "llvm.add"(%66, %62) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    %68 = "llvm.and"(%61, %1) : (i64, i64) -> i64
    "llvm.store"(%68, %arg0) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %69 = "llvm.lshr"(%67, %0) : (i64, i64) -> i64
    %70 = "llvm.add"(%69, %63) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    %71 = "llvm.and"(%67, %1) : (i64, i64) -> i64
    "llvm.store"(%71, %4) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %72 = "llvm.lshr"(%70, %0) : (i64, i64) -> i64
    %73 = "llvm.add"(%72, %64) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    %74 = "llvm.and"(%70, %1) : (i64, i64) -> i64
    "llvm.store"(%74, %10) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %75 = "llvm.lshr"(%73, %0) : (i64, i64) -> i64
    %76 = "llvm.add"(%75, %65) <{overflowFlags = #llvm.overflow<nsw, nuw>}> : (i64, i64) -> i64
    %77 = "llvm.and"(%73, %1) : (i64, i64) -> i64
    "llvm.store"(%77, %15) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %78 = "llvm.and"(%76, %1) : (i64, i64) -> i64
    "llvm.store"(%78, %20) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    "llvm.return"() : () -> ()
}

end

end LeanMLIR.RIR.Zig
