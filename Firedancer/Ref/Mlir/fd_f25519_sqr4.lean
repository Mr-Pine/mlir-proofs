module

-- build/native/gcc/mlir_canonicalized/ref/region/fd_f25519_sqr4.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Ref.Mlir.fd_f25519_sqr

meta import MLIR.Semantics.Func
meta import Firedancer.Ref.Mlir.fd_f25519_sqr

namespace MLIR.Firedancer.Ref

@[expose] public section

mlir_def fd_f25519_sqr4 :=
{
  ^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: !llvm.ptr, %arg3: !llvm.ptr, %arg4: !llvm.ptr, %arg5: !llvm.ptr, %arg6: !llvm.ptr, %arg7: !llvm.ptr):
    %0 = "llvm.call"(%arg0, %arg1) <{CConv = #llvm.cconv<fastcc>, callee = @fd_f25519_sqr, fastmathFlags = #llvm.fastmath<none>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
    %1 = "llvm.call"(%arg2, %arg3) <{CConv = #llvm.cconv<fastcc>, callee = @fd_f25519_sqr, fastmathFlags = #llvm.fastmath<none>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
    %2 = "llvm.call"(%arg4, %arg5) <{CConv = #llvm.cconv<fastcc>, callee = @fd_f25519_sqr, fastmathFlags = #llvm.fastmath<none>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
    %3 = "llvm.call"(%arg6, %arg7) <{CConv = #llvm.cconv<fastcc>, callee = @fd_f25519_sqr, fastmathFlags = #llvm.fastmath<none>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
    "llvm.return"() : () -> ()
}
  with @fd_f25519_sqr := fd_f25519_sqr

end

end MLIR.Firedancer.Ref
