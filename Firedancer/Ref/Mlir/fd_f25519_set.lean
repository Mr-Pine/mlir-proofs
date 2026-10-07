module

-- build/native/gcc/mlir_canonicalized/ref/region/fd_f25519_set.mlir

public import SSA.Projects.RIR.Semantics.Func
public import SSA.Projects.RIR.Syntax.Elab

meta import SSA.Projects.RIR.Semantics.Func

namespace LeanMLIR.RIR.Firedancer.Ref

@[expose] public section

mlir_def fd_f25519_set :=
{
  ^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr):
    %0 = "llvm.load"(%arg1) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
    "llvm.store"(%0, %arg0) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
    %1 = "llvm.getelementptr"(%arg1) <{elem_type = !llvm.array<5 x i64>, rawConstantIndices = array<i32: 0, 1>}> : (!llvm.ptr) -> !llvm.ptr
    %2 = "llvm.load"(%1) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
    %3 = "llvm.getelementptr"(%arg0) <{elem_type = !llvm.array<5 x i64>, rawConstantIndices = array<i32: 0, 1>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%2, %3) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
    %4 = "llvm.getelementptr"(%arg1) <{elem_type = !llvm.array<5 x i64>, rawConstantIndices = array<i32: 0, 2>}> : (!llvm.ptr) -> !llvm.ptr
    %5 = "llvm.load"(%4) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
    %6 = "llvm.getelementptr"(%arg0) <{elem_type = !llvm.array<5 x i64>, rawConstantIndices = array<i32: 0, 2>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%5, %6) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
    %7 = "llvm.getelementptr"(%arg1) <{elem_type = !llvm.array<5 x i64>, rawConstantIndices = array<i32: 0, 3>}> : (!llvm.ptr) -> !llvm.ptr
    %8 = "llvm.load"(%7) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
    %9 = "llvm.getelementptr"(%arg0) <{elem_type = !llvm.array<5 x i64>, rawConstantIndices = array<i32: 0, 3>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%8, %9) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
    %10 = "llvm.getelementptr"(%arg1) <{elem_type = !llvm.array<5 x i64>, rawConstantIndices = array<i32: 0, 4>}> : (!llvm.ptr) -> !llvm.ptr
    %11 = "llvm.load"(%10) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
    %12 = "llvm.getelementptr"(%arg0) <{elem_type = !llvm.array<5 x i64>, rawConstantIndices = array<i32: 0, 4>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%11, %12) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
    "llvm.return"(%arg0) : (!llvm.ptr) -> ()
}

end

end LeanMLIR.RIR.Firedancer.Ref
