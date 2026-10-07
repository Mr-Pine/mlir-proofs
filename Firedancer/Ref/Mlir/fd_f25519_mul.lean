module

-- build/native/gcc/mlir_canonicalized/ref/region/fd_f25519_mul.mlir

public import SSA.Projects.RIR.Semantics.Func
public import SSA.Projects.RIR.Syntax.Elab
public import Firedancer.Ref.Mlir.fiat_25519_carry_mul

meta import SSA.Projects.RIR.Semantics.Func
meta import Firedancer.Ref.Mlir.fiat_25519_carry_mul

namespace LeanMLIR.RIR.Firedancer.Ref

@[expose] public section

mlir_def fd_f25519_mul :=
{
  ^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: !llvm.ptr):
    "llvm.call"(%arg0, %arg1, %arg2) <{CConv = #llvm.cconv<fastcc>, callee = @fiat_25519_carry_mul, fastmathFlags = #llvm.fastmath<none>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    "llvm.return"(%arg0) : (!llvm.ptr) -> ()
}
  with @fiat_25519_carry_mul := fiat_25519_carry_mul

end

end LeanMLIR.RIR.Firedancer.Ref
