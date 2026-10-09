module

-- zig-build/out/mlir_canonicalized/region/Fe.add.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Zig

@[expose] public section

mlir_def Fe_add :=
{
  ^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: !llvm.ptr):
    %0 = "llvm.load"(%arg1) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %1 = "llvm.load"(%arg2) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %2 = "llvm.add"(%1, %0) <{overflowFlags = #llvm.overflow<nuw>}> : (i64, i64) -> i64
    %3 = "llvm.getelementptr"(%arg1) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
    %4 = "llvm.load"(%3) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %5 = "llvm.getelementptr"(%arg2) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
    %6 = "llvm.load"(%5) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %7 = "llvm.add"(%6, %4) <{overflowFlags = #llvm.overflow<nuw>}> : (i64, i64) -> i64
    %8 = "llvm.getelementptr"(%arg1) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
    %9 = "llvm.load"(%8) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %10 = "llvm.getelementptr"(%arg2) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
    %11 = "llvm.load"(%10) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %12 = "llvm.add"(%11, %9) <{overflowFlags = #llvm.overflow<nuw>}> : (i64, i64) -> i64
    %13 = "llvm.getelementptr"(%arg1) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
    %14 = "llvm.load"(%13) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %15 = "llvm.getelementptr"(%arg2) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
    %16 = "llvm.load"(%15) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %17 = "llvm.add"(%16, %14) <{overflowFlags = #llvm.overflow<nuw>}> : (i64, i64) -> i64
    %18 = "llvm.getelementptr"(%arg1) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
    %19 = "llvm.load"(%18) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %20 = "llvm.getelementptr"(%arg2) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
    %21 = "llvm.load"(%20) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    %22 = "llvm.add"(%21, %19) <{overflowFlags = #llvm.overflow<nuw>}> : (i64, i64) -> i64
    "llvm.store"(%2, %arg0) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %23 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%7, %23) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %24 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%12, %24) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %25 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%17, %25) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    %26 = "llvm.getelementptr"(%arg0) <{elem_type = i8, inbounds, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%22, %26) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
    "llvm.return"() : () -> ()
}

end

end MLIR.Zig
