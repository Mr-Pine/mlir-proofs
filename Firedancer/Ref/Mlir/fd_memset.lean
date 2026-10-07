module

-- build/native/gcc/mlir_canonicalized/ref/region/fd_memset.mlir

public import SSA.Projects.RIR.Semantics.Func
public import SSA.Projects.RIR.Syntax.Elab

meta import SSA.Projects.RIR.Semantics.Func

namespace LeanMLIR.RIR.Firedancer.Ref

@[expose] public section

mlir_def fd_memset :=
{
  ^bb0(%arg0: !llvm.ptr, %arg1: i64):
    %0 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
    "llvm.intr.memset"(%arg0, %0, %arg1) <{isVolatile = false}> : (!llvm.ptr, i8, i64) -> ()
    "llvm.return"(%arg0) : (!llvm.ptr) -> ()
}

end

end LeanMLIR.RIR.Firedancer.Ref
