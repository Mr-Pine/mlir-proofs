module

-- build/native/gcc/mlir_canonicalized/avx512/region/fd_ed25519_order8_point_y0.mlir

public import MLIR.Semantics.GlobalInitializer
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.GlobalInitializer

namespace MLIR.Firedancer.Avx512

@[expose] public section

mlir_const_def fd_ed25519_order8_point_y0 :=
{
    %0 = "llvm.mlir.constant"() <{value = dense<[3034655877158, 7251661554934, 8531478563367, 3751701540842, 152657171260, 51416324880, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
    %1 = "llvm.mlir.undef"() : () -> !llvm.struct<"struct.fd_f25519", (vector<8xi64>)>
    %2 = "llvm.insertvalue"(%1, %0) <{position = array<i64: 0>}> : (!llvm.struct<"struct.fd_f25519", (vector<8xi64>)>, vector<8xi64>) -> !llvm.struct<"struct.fd_f25519", (vector<8xi64>)>
    %3 = "llvm.mlir.undef"() : () -> !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>
    %4 = "llvm.insertvalue"(%3, %2) <{position = array<i64: 0>}> : (!llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>, !llvm.struct<"struct.fd_f25519", (vector<8xi64>)>) -> !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>
    "llvm.return"(%4) : (!llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>) -> ()
}

end

end MLIR.Firedancer.Avx512
