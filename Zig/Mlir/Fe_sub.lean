module

-- zig-build/out/mlir_canonicalized/region/Fe.sub.mlir

public import SSA.Projects.RIR.Semantics.Func
public import SSA.Projects.RIR.Syntax.Elab

meta import SSA.Projects.RIR.Semantics.Func

namespace LeanMLIR.RIR.Zig

@[expose] public section

mlir_def Fe_sub :=
{
  ^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: !llvm.ptr):
    %0 = "llvm.mlir.constant"() <{value = 51 : i64}> : () -> i64
    %1 = "llvm.mlir.constant"() <{value = 2251799813685247 : i64}> : () -> i64
    %2 = "llvm.mlir.constant"() <{value = -19 : i64}> : () -> i64
    %3 = "llvm.mlir.constant"() <{value = 4503599627370458 : i64}> : () -> i64
    %4 = "llvm.mlir.constant"() <{value = 4503599627370494 : i64}> : () -> i64
    %5 = "llvm.load"(%arg2) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %6 = "llvm.getelementptr"(%arg2) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
    %7 = "llvm.load"(%6) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %8 = "llvm.getelementptr"(%arg2) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
    %9 = "llvm.load"(%8) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %10 = "llvm.getelementptr"(%arg2) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
    %11 = "llvm.load"(%10) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %12 = "llvm.getelementptr"(%arg2) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
    %13 = "llvm.load"(%12) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %14 = "llvm.lshr"(%5, %0) : (i64, i64) -> i64
    %15 = "llvm.add"(%7, %14) <{overflowFlags = #llvm.overflow<nuw>}> : (i64, i64) -> i64
    %16 = "llvm.and"(%5, %1) : (i64, i64) -> i64
    %17 = "llvm.lshr"(%15, %0) : (i64, i64) -> i64
    %18 = "llvm.add"(%17, %9) <{overflowFlags = #llvm.overflow<nuw>}> : (i64, i64) -> i64
    %19 = "llvm.and"(%15, %1) : (i64, i64) -> i64
    %20 = "llvm.lshr"(%18, %0) : (i64, i64) -> i64
    %21 = "llvm.add"(%20, %11) <{overflowFlags = #llvm.overflow<nuw>}> : (i64, i64) -> i64
    %22 = "llvm.and"(%18, %1) : (i64, i64) -> i64
    %23 = "llvm.lshr"(%21, %0) : (i64, i64) -> i64
    %24 = "llvm.add"(%23, %13) <{overflowFlags = #llvm.overflow<nuw>}> : (i64, i64) -> i64
    %25 = "llvm.and"(%21, %1) : (i64, i64) -> i64
    %26 = "llvm.lshr"(%24, %0) : (i64, i64) -> i64
    %27 = "llvm.and"(%24, %1) : (i64, i64) -> i64
    %28 = "llvm.load"(%arg1) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %29 = "llvm.mul"(%26, %2) <{overflowFlags = #llvm.overflow<nsw>}> : (i64, i64) -> i64
    %30 = "llvm.sub"(%28, %16) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %31 = "llvm.add"(%30, %3) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %32 = "llvm.add"(%31, %29) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %33 = "llvm.getelementptr"(%arg1) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
    %34 = "llvm.load"(%33) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %35 = "llvm.sub"(%34, %19) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %36 = "llvm.add"(%35, %4) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %37 = "llvm.getelementptr"(%arg1) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
    %38 = "llvm.load"(%37) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %39 = "llvm.sub"(%38, %22) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %40 = "llvm.add"(%39, %4) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %41 = "llvm.getelementptr"(%arg1) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
    %42 = "llvm.load"(%41) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %43 = "llvm.sub"(%42, %25) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %44 = "llvm.add"(%43, %4) <{overflowFlags = #llvm.overflow<none>}> : (i64, i64) -> i64
    %45 = "llvm.getelementptr"(%arg1) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
    %46 = "llvm.load"(%45) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %47 = "llvm.add"(%46, %4) <{overflowFlags = #llvm.overflow<nuw>}> : (i64, i64) -> i64
    %48 = "llvm.sub"(%47, %27) <{overflowFlags = #llvm.overflow<nuw>}> : (i64, i64) -> i64
    "llvm.store"(%32, %arg0) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %49 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%36, %49) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %50 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%40, %50) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %51 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%44, %51) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %52 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%48, %52) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    "llvm.return"() : () -> ()
}

end

end LeanMLIR.RIR.Zig
