module

-- zig-build/out/mlir_canonicalized/region/Fe.cMov.mlir

public import SSA.Projects.RIR.Semantics.Func
public import SSA.Projects.RIR.Syntax.Elab

meta import SSA.Projects.RIR.Semantics.Func

namespace LeanMLIR.RIR.Zig

@[expose] public section

mlir_def Fe_cMov :=
{
  ^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: i64):
    %0 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
    %1 = "llvm.sub"(%0, %arg2) <{overflowFlags = #llvm.overflow<nsw>}> : (i64, i64) -> i64
    %2 = "llvm.load"(%arg0) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %3 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
    %4 = "llvm.load"(%3) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %5 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
    %6 = "llvm.load"(%5) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %7 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
    %8 = "llvm.load"(%7) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %9 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
    %10 = "llvm.load"(%9) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %11 = "llvm.load"(%arg1) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %12 = "llvm.xor"(%11, %2) : (i64, i64) -> i64
    %13 = "llvm.getelementptr"(%arg1) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
    %14 = "llvm.load"(%13) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %15 = "llvm.xor"(%14, %4) : (i64, i64) -> i64
    %16 = "llvm.getelementptr"(%arg1) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
    %17 = "llvm.load"(%16) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %18 = "llvm.xor"(%17, %6) : (i64, i64) -> i64
    %19 = "llvm.getelementptr"(%arg1) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
    %20 = "llvm.load"(%19) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %21 = "llvm.xor"(%20, %8) : (i64, i64) -> i64
    %22 = "llvm.getelementptr"(%arg1) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
    %23 = "llvm.load"(%22) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %24 = "llvm.xor"(%23, %10) : (i64, i64) -> i64
    %25 = "llvm.and"(%12, %1) : (i64, i64) -> i64
    %26 = "llvm.and"(%15, %1) : (i64, i64) -> i64
    %27 = "llvm.and"(%18, %1) : (i64, i64) -> i64
    %28 = "llvm.and"(%21, %1) : (i64, i64) -> i64
    %29 = "llvm.and"(%24, %1) : (i64, i64) -> i64
    %30 = "llvm.xor"(%25, %2) : (i64, i64) -> i64
    "llvm.store"(%30, %arg0) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %31 = "llvm.xor"(%26, %4) : (i64, i64) -> i64
    "llvm.store"(%31, %3) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %32 = "llvm.xor"(%27, %6) : (i64, i64) -> i64
    "llvm.store"(%32, %5) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %33 = "llvm.xor"(%28, %8) : (i64, i64) -> i64
    "llvm.store"(%33, %7) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %34 = "llvm.xor"(%29, %10) : (i64, i64) -> i64
    "llvm.store"(%34, %9) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    "llvm.return"() : () -> ()
}

end

end LeanMLIR.RIR.Zig
