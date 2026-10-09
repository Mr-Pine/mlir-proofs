module

-- build/native/gcc/mlir_canonicalized/ref/region/fd_f25519_frombytes.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Ref.Mlir.fiat_25519_from_bytes

meta import MLIR.Semantics.Func
meta import Firedancer.Ref.Mlir.fiat_25519_from_bytes

namespace MLIR.Firedancer.Ref

@[expose] public section

mlir_def fd_f25519_frombytes :=
{
  ^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr):
    "llvm.call"(%arg0, %arg1) <{CConv = #llvm.cconv<fastcc>, callee = @fiat_25519_from_bytes, fastmathFlags = #llvm.fastmath<none>}> : (!llvm.ptr, !llvm.ptr) -> ()
    "llvm.return"(%arg0) : (!llvm.ptr) -> ()
}
  with @fiat_25519_from_bytes := fiat_25519_from_bytes

end

end MLIR.Firedancer.Ref
