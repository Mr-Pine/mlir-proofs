module

-- build/native/gcc/mlir_canonicalized/ref/region/fd_f25519_eq.mlir

public import SSA.Projects.RIR.Semantics.Func
public import SSA.Projects.RIR.Syntax.Elab
public import Firedancer.Ref.Mlir.fd_f25519_is_zero
public import Firedancer.Ref.Mlir.fd_f25519_sub

meta import SSA.Projects.RIR.Semantics.Func
meta import Firedancer.Ref.Mlir.fd_f25519_is_zero
meta import Firedancer.Ref.Mlir.fd_f25519_sub

namespace LeanMLIR.RIR.Firedancer.Ref

@[expose] public section

mlir_def fd_f25519_eq :=
{
  ^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr):
    %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
    %1 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>}> : (i32) -> !llvm.ptr
    "llvm.intr.lifetime.start"(%1) <{size = 40 : i64}> : (!llvm.ptr) -> ()
    %2 = "llvm.call"(%1, %arg0, %arg1) <{CConv = #llvm.cconv<fastcc>, callee = @fd_f25519_sub, fastmathFlags = #llvm.fastmath<none>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
    %3 = "llvm.call"(%1) <{CConv = #llvm.cconv<fastcc>, callee = @fd_f25519_is_zero, fastmathFlags = #llvm.fastmath<none>}> : (!llvm.ptr) -> i32
    "llvm.intr.lifetime.end"(%1) <{size = 40 : i64}> : (!llvm.ptr) -> ()
    "llvm.return"(%3) : (i32) -> ()
}
  with @fd_f25519_is_zero := fd_f25519_is_zero, @fd_f25519_sub := fd_f25519_sub

end

end LeanMLIR.RIR.Firedancer.Ref
