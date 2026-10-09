module

-- build/llvm23/mlir_canonicalized/avx512/op/fd_ed25519_order8_point_y0.mlir

public import MLIR.Semantics.GlobalInitializer
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.GlobalInitializer

namespace MLIR.Firedancer.Avx512

@[expose] public section

mlir_const_def fd_ed25519_order8_point_y0 :=
"llvm.mlir.global"() <{addr_space = 0 : i32, alignment = 64 : i64, constant, dso_local, global_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>, linkage = #llvm.linkage<internal>, sym_name = "fd_ed25519_order8_point_y0", unnamed_addr = 0 : i64, visibility_ = 0 : i64}> ({
  %3378 = "llvm.mlir.undef"() : () -> !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>
  %3379 = "llvm.mlir.constant"() <{value = dense<[3034655877158, 7251661554934, 8531478563367, 3751701540842, 152657171260, 51416324880, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %3380 = "llvm.mlir.undef"() : () -> !llvm.struct<"struct.fd_f25519", (vector<8xi64>)>
  %3381 = "llvm.insertvalue"(%3380, %3379) <{position = array<i64: 0>}> : (!llvm.struct<"struct.fd_f25519", (vector<8xi64>)>, vector<8xi64>) -> !llvm.struct<"struct.fd_f25519", (vector<8xi64>)>
  %3382 = "llvm.insertvalue"(%3378, %3381) <{position = array<i64: 0>}> : (!llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>, !llvm.struct<"struct.fd_f25519", (vector<8xi64>)>) -> !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>
  "llvm.return"(%3382) : (!llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>) -> ()
}) : () -> ()

end

end MLIR.Firedancer.Avx512
