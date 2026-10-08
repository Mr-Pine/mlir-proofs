module

-- build/native/gcc/mlir_canonicalized/avx512/region/fd_ed25519_order8_point_y1.mlir

public import SSA.Projects.RIR.Semantics.GlobalInitializer
public import SSA.Projects.RIR.Syntax.Elab

meta import SSA.Projects.RIR.Semantics.GlobalInitializer

namespace LeanMLIR.RIR.Firedancer.Avx512

@[expose] public section

mlir_const_def fd_ed25519_order8_point_y1 :=
{
    %0 = "llvm.mlir.constant"() <{value = dense<[5761437145031, 1544431467273, 264614458840, 5044391481365, 8643435850947, 1048095302895, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
    %1 = "llvm.mlir.undef"() : () -> !llvm.struct<"struct.fd_f25519", (vector<8xi64>)>
    %2 = "llvm.insertvalue"(%1, %0) <{position = array<i64: 0>}> : (!llvm.struct<"struct.fd_f25519", (vector<8xi64>)>, vector<8xi64>) -> !llvm.struct<"struct.fd_f25519", (vector<8xi64>)>
    %3 = "llvm.mlir.undef"() : () -> !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>
    %4 = "llvm.insertvalue"(%3, %2) <{position = array<i64: 0>}> : (!llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>, !llvm.struct<"struct.fd_f25519", (vector<8xi64>)>) -> !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>
    "llvm.return"(%4) : (!llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>) -> ()
}

end

end LeanMLIR.RIR.Firedancer.Avx512
