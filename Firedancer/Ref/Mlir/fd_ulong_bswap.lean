module

-- build/native/gcc/mlir_canonicalized/ref/region/fd_ulong_bswap.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Firedancer.Ref

@[expose] public section

mlir_def fd_ulong_bswap :=
{
  ^bb0(%arg0: i64):
    %0 = "llvm.intr.bswap"(%arg0) : (i64) -> i64
    "llvm.return"(%0) : (i64) -> ()
}

end

end MLIR.Firedancer.Ref
