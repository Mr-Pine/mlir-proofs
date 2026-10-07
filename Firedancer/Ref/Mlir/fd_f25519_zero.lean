module

-- build/native/gcc/mlir_canonicalized/ref/region/fd_f25519_zero.mlir

public import SSA.Projects.RIR.Semantics.GlobalInitializer
public import SSA.Projects.RIR.Syntax.Elab

meta import SSA.Projects.RIR.Semantics.GlobalInitializer

namespace LeanMLIR.RIR.Firedancer.Ref

@[expose] public section

mlir_const_def fd_f25519_zero :=
{
    %0 = "llvm.mlir.constant"() <{value = dense<0> : tensor<5xi64>}> : () -> !llvm.array<5 x i64>
    %1 = "llvm.mlir.undef"() : () -> !llvm.struct<"struct.fd_f25519", (array<5 x i64>)>
    %2 = "llvm.insertvalue"(%1, %0) <{position = array<i64: 0>}> : (!llvm.struct<"struct.fd_f25519", (array<5 x i64>)>, !llvm.array<5 x i64>) -> !llvm.struct<"struct.fd_f25519", (array<5 x i64>)>
    %3 = "llvm.mlir.undef"() : () -> !llvm.array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>
    %4 = "llvm.insertvalue"(%3, %2) <{position = array<i64: 0>}> : (!llvm.array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>, !llvm.struct<"struct.fd_f25519", (array<5 x i64>)>) -> !llvm.array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>
    "llvm.return"(%4) : (!llvm.array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>) -> ()
}

end

end LeanMLIR.RIR.Firedancer.Ref
