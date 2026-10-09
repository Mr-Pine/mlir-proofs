module

-- build/native/gcc/mlir_canonicalized/ref/region/fd_f25519_add_nr.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Ref.Mlir.fiat_25519_add

meta import MLIR.Semantics.Func
meta import Firedancer.Ref.Mlir.fiat_25519_add

namespace MLIR.Firedancer.Ref

@[expose] public section

mlir_def fd_f25519_add_nr :=
{
  ^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: !llvm.ptr):
    "llvm.call"(%arg0, %arg1, %arg2) <{CConv = #llvm.cconv<fastcc>, callee = @fiat_25519_add, fastmathFlags = #llvm.fastmath<none>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    "llvm.return"(%arg0) : (!llvm.ptr) -> ()
}
  with @fiat_25519_add := fiat_25519_add

end

end MLIR.Firedancer.Ref
