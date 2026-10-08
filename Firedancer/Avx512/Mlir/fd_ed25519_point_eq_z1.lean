module

-- build/native/gcc/mlir_canonicalized/avx512/region/fd_ed25519_point_eq_z1.mlir

public import SSA.Projects.RIR.Semantics.Func
public import SSA.Projects.RIR.Syntax.Elab
public import Firedancer.Avx512.Mlir.fd_ed25519_point_eq

meta import SSA.Projects.RIR.Semantics.Func
meta import Firedancer.Avx512.Mlir.fd_ed25519_point_eq

namespace LeanMLIR.RIR.Firedancer.Avx512

@[expose] public section

mlir_def fd_ed25519_point_eq_z1 :=
{
  ^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr):
    %0 = "llvm.call"(%arg0, %arg1) <{CConv = #llvm.cconv<fastcc>, callee = @fd_ed25519_point_eq, fastmathFlags = #llvm.fastmath<none>}> : (!llvm.ptr, !llvm.ptr) -> i32
    "llvm.return"(%0) : (i32) -> ()
}
  with @fd_ed25519_point_eq := fd_ed25519_point_eq

end

end LeanMLIR.RIR.Firedancer.Avx512
