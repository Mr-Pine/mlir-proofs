module

-- build/native/gcc/mlir_canonicalized/ref/region/fd_f25519_mul3.mlir

public import SSA.Projects.RIR.Semantics.Func
public import SSA.Projects.RIR.Syntax.Elab
public import Firedancer.Ref.Mlir.fd_f25519_mul

meta import SSA.Projects.RIR.Semantics.Func
meta import Firedancer.Ref.Mlir.fd_f25519_mul

namespace LeanMLIR.RIR.Firedancer.Ref

@[expose] public section

mlir_def fd_f25519_mul3 :=
{
  ^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: !llvm.ptr, %arg3: !llvm.ptr, %arg4: !llvm.ptr, %arg5: !llvm.ptr, %arg6: !llvm.ptr, %arg7: !llvm.ptr, %arg8: !llvm.ptr):
    %0 = "llvm.call"(%arg0, %arg1, %arg2) <{CConv = #llvm.cconv<fastcc>, callee = @fd_f25519_mul, fastmathFlags = #llvm.fastmath<none>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
    %1 = "llvm.call"(%arg3, %arg4, %arg5) <{CConv = #llvm.cconv<fastcc>, callee = @fd_f25519_mul, fastmathFlags = #llvm.fastmath<none>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
    %2 = "llvm.call"(%arg6, %arg7, %arg8) <{CConv = #llvm.cconv<fastcc>, callee = @fd_f25519_mul, fastmathFlags = #llvm.fastmath<none>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
    "llvm.return"() : () -> ()
}
  with @fd_f25519_mul := fd_f25519_mul

end

end LeanMLIR.RIR.Firedancer.Ref
