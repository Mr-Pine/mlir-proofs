module

-- build/native/gcc/mlir_canonicalized/ref/region/fd_ulong_load_8.mlir

public import SSA.Projects.RIR.Semantics.Func
public import SSA.Projects.RIR.Syntax.Elab

meta import SSA.Projects.RIR.Semantics.Func

namespace LeanMLIR.RIR.Firedancer.Ref

@[expose] public section

mlir_def fd_ulong_load_8 :=
{
  ^bb0(%arg0: !llvm.ptr):
    %0 = "llvm.load"(%arg0) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
    "llvm.return"(%0) : (i64) -> ()
}

end

end LeanMLIR.RIR.Firedancer.Ref
