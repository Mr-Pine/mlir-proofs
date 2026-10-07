module

-- build/native/gcc/mlir_canonicalized/ref/region/fd_f25519_add.mlir

public import SSA.Projects.RIR.Semantics.Func
public import SSA.Projects.RIR.Syntax.Elab
public import Firedancer.Ref.Mlir.fiat_25519_add
public import Firedancer.Ref.Mlir.fiat_25519_carry

meta import SSA.Projects.RIR.Semantics.Func
meta import Firedancer.Ref.Mlir.fiat_25519_add
meta import Firedancer.Ref.Mlir.fiat_25519_carry

namespace LeanMLIR.RIR.Firedancer.Ref

@[expose] public section

mlir_def fd_f25519_add :=
{
  ^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: !llvm.ptr):
    "llvm.call"(%arg0, %arg1, %arg2) <{CConv = #llvm.cconv<fastcc>, callee = @fiat_25519_add, fastmathFlags = #llvm.fastmath<none>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    "llvm.call"(%arg0, %arg0) <{CConv = #llvm.cconv<fastcc>, callee = @fiat_25519_carry, fastmathFlags = #llvm.fastmath<none>}> : (!llvm.ptr, !llvm.ptr) -> ()
    "llvm.return"(%arg0) : (!llvm.ptr) -> ()
}
  with @fiat_25519_add := fiat_25519_add, @fiat_25519_carry := fiat_25519_carry

end

end LeanMLIR.RIR.Firedancer.Ref
