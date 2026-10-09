module

-- build/native/gcc/mlir_canonicalized/ref/region/fd_ed25519_point_set_zero.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Ref.Mlir.fd_f25519_set
public import Firedancer.Ref.Mlir.fd_f25519_one
public import Firedancer.Ref.Mlir.fd_f25519_zero

meta import MLIR.Semantics.Func
meta import Firedancer.Ref.Mlir.fd_f25519_set
meta import Firedancer.Ref.Mlir.fd_f25519_one
meta import Firedancer.Ref.Mlir.fd_f25519_zero

namespace MLIR.Firedancer.Ref

@[expose] public section

mlir_def fd_ed25519_point_set_zero :=
{
  ^bb0(%arg0: !llvm.ptr):
    %0 = "llvm.mlir.addressof"() <{global_name = @fd_f25519_zero}> : () -> !llvm.ptr
    %1 = "llvm.mlir.addressof"() <{global_name = @fd_f25519_one}> : () -> !llvm.ptr
    %2 = "llvm.call"(%arg0, %0) <{CConv = #llvm.cconv<fastcc>, callee = @fd_f25519_set, fastmathFlags = #llvm.fastmath<none>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
    %3 = "llvm.getelementptr"(%arg0) <{elem_type = !llvm.struct<"struct.fd_curve25519_edwards", (array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>, array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>, array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>, array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>)>, inbounds, rawConstantIndices = array<i32: 0, 1>}> : (!llvm.ptr) -> !llvm.ptr
    %4 = "llvm.call"(%3, %1) <{CConv = #llvm.cconv<fastcc>, callee = @fd_f25519_set, fastmathFlags = #llvm.fastmath<none>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
    %5 = "llvm.getelementptr"(%arg0) <{elem_type = !llvm.struct<"struct.fd_curve25519_edwards", (array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>, array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>, array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>, array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>)>, inbounds, rawConstantIndices = array<i32: 0, 3>}> : (!llvm.ptr) -> !llvm.ptr
    %6 = "llvm.call"(%5, %1) <{CConv = #llvm.cconv<fastcc>, callee = @fd_f25519_set, fastmathFlags = #llvm.fastmath<none>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
    %7 = "llvm.getelementptr"(%arg0) <{elem_type = !llvm.struct<"struct.fd_curve25519_edwards", (array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>, array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>, array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>, array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>)>, inbounds, rawConstantIndices = array<i32: 0, 2>}> : (!llvm.ptr) -> !llvm.ptr
    %8 = "llvm.call"(%7, %0) <{CConv = #llvm.cconv<fastcc>, callee = @fd_f25519_set, fastmathFlags = #llvm.fastmath<none>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
    "llvm.return"(%arg0) : (!llvm.ptr) -> ()
}
  with @fd_f25519_set := fd_f25519_set, @fd_f25519_one := fd_f25519_one,
    @fd_f25519_zero := fd_f25519_zero

end

end MLIR.Firedancer.Ref
