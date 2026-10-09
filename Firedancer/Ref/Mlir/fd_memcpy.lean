module

-- build/native/gcc/mlir_canonicalized/ref/region/fd_memcpy.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Firedancer.Ref

@[expose] public section

mlir_def fd_memcpy :=
{
  ^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: i64):
    "llvm.intr.memcpy"(%arg0, %arg1, %arg2) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    "llvm.return"(%arg0) : (!llvm.ptr) -> ()
}

end

end MLIR.Firedancer.Ref
