module

-- build/native/gcc/mlir_canonicalized/ref/region/fd_f25519_if.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Ref.Mlir.fiat_25519_selectznz

meta import MLIR.Semantics.Func
meta import Firedancer.Ref.Mlir.fiat_25519_selectznz

namespace MLIR.Firedancer.Ref

@[expose] public section

mlir_def fd_f25519_if :=
{
  ^bb0(%arg0: !llvm.ptr, %arg1: i32, %arg2: !llvm.ptr, %arg3: !llvm.ptr):
    %0 = "llvm.trunc"(%arg1) : (i32) -> i8
    "llvm.call"(%arg0, %0, %arg3, %arg2) <{CConv = #llvm.cconv<fastcc>, callee = @fiat_25519_selectznz, fastmathFlags = #llvm.fastmath<none>}> : (!llvm.ptr, i8, !llvm.ptr, !llvm.ptr) -> ()
    "llvm.return"(%arg0) : (!llvm.ptr) -> ()
}
  with @fiat_25519_selectznz := fiat_25519_selectznz

end

end MLIR.Firedancer.Ref
