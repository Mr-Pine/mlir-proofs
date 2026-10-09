module

-- build/native/gcc/mlir_canonicalized/ref/region/fd_f25519_sub.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Ref.Mlir.fiat_25519_carry
public import Firedancer.Ref.Mlir.fiat_25519_sub

meta import MLIR.Semantics.Func
meta import Firedancer.Ref.Mlir.fiat_25519_carry
meta import Firedancer.Ref.Mlir.fiat_25519_sub

namespace MLIR.Firedancer.Ref

@[expose] public section

mlir_def fd_f25519_sub :=
{
  ^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: !llvm.ptr):
    "llvm.call"(%arg0, %arg1, %arg2) <{CConv = #llvm.cconv<fastcc>, callee = @fiat_25519_sub, fastmathFlags = #llvm.fastmath<none>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    "llvm.call"(%arg0, %arg0) <{CConv = #llvm.cconv<fastcc>, callee = @fiat_25519_carry, fastmathFlags = #llvm.fastmath<none>}> : (!llvm.ptr, !llvm.ptr) -> ()
    "llvm.return"(%arg0) : (!llvm.ptr) -> ()
}
  with @fiat_25519_carry := fiat_25519_carry, @fiat_25519_sub := fiat_25519_sub

end

end MLIR.Firedancer.Ref
