module

-- build/native/gcc/mlir_canonicalized/avx512/region/fd_ed25519_point_add_final_mul_projective.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Avx512.Mlir.fd_ed25519_point_set

meta import MLIR.Semantics.Func
meta import Firedancer.Avx512.Mlir.fd_ed25519_point_set

namespace MLIR.Firedancer.Avx512

@[expose] public section

mlir_def fd_ed25519_point_add_final_mul_projective :=
{
  ^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr):
    %0 = "llvm.call"(%arg0, %arg1) <{CConv = #llvm.cconv<fastcc>, callee = @fd_ed25519_point_set, fastmathFlags = #llvm.fastmath<none>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
    "llvm.return"(%arg0) : (!llvm.ptr) -> ()
}
  with @fd_ed25519_point_set := fd_ed25519_point_set

end

end MLIR.Firedancer.Avx512
