module

-- build/native/gcc/mlir_canonicalized/ref/region/fd_int_min.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Firedancer.Ref

@[expose] public section

mlir_def fd_int_min :=
{
  ^bb0(%arg0: i32):
    %0 = "llvm.mlir.constant"() <{value = 14 : i32}> : () -> i32
    %1 = "llvm.intr.smin"(%arg0, %0) : (i32, i32) -> i32
    "llvm.return"(%1) : (i32) -> ()
}

end

end MLIR.Firedancer.Ref
