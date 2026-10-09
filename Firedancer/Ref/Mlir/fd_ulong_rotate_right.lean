module

-- build/native/gcc/mlir_canonicalized/ref/region/fd_ulong_rotate_right.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Firedancer.Ref

@[expose] public section

mlir_def fd_ulong_rotate_right :=
{
  ^bb0(%arg0: i64, %arg1: i32):
    %0 = "llvm.zext"(%arg1) : (i32) -> i64
    %1 = "llvm.intr.fshr"(%arg0, %arg0, %0) : (i64, i64, i64) -> i64
    "llvm.return"(%1) : (i64) -> ()
}

end

end MLIR.Firedancer.Ref
