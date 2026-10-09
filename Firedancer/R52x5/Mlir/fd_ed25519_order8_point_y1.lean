module

-- ~/fd-pr9879/build/llvm23-production/mlir_canonicalized/avx512/op/fd_ed25519_order8_point_y1.mlir

public import MLIR.Semantics.GlobalInitializer
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.GlobalInitializer

namespace MLIR.Firedancer.R52x5

@[expose] public section

mlir_const_def fd_ed25519_order8_point_y1 :=
"llvm.mlir.global"() <{addr_space = 0 : i32, alignment = 64 : i64, constant, dso_local, global_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>, linkage = #llvm.linkage<internal>, sym_name = "fd_ed25519_order8_point_y1", unnamed_addr = 0 : i64, visibility_ = 0 : i64}> ({
  %4882 = "llvm.mlir.undef"() : () -> !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>
  %4883 = "llvm.mlir.constant"() <{value = dense<[84926274344903, 473620666599931, 365590438845504, 1028470286882429, 2146499180330972, 0, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %4884 = "llvm.mlir.undef"() : () -> !llvm.struct<"struct.fd_f25519", (vector<8xi64>)>
  %4885 = "llvm.insertvalue"(%4884, %4883) <{position = array<i64: 0>}> : (!llvm.struct<"struct.fd_f25519", (vector<8xi64>)>, vector<8xi64>) -> !llvm.struct<"struct.fd_f25519", (vector<8xi64>)>
  %4886 = "llvm.insertvalue"(%4882, %4885) <{position = array<i64: 0>}> : (!llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>, !llvm.struct<"struct.fd_f25519", (vector<8xi64>)>) -> !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>
  "llvm.return"(%4886) : (!llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>) -> ()
}) : () -> ()

end

end MLIR.Firedancer.R52x5
