module

-- ~/fd-pr9879/build/llvm23-production/mlir_canonicalized/avx512/op/fd_f25519_one.mlir

public import MLIR.Semantics.GlobalInitializer
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.GlobalInitializer

namespace MLIR.Firedancer.R52x5

@[expose] public section

mlir_const_def fd_f25519_one :=
"llvm.mlir.global"() <{addr_space = 0 : i32, alignment = 64 : i64, constant, dso_local, global_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>, linkage = #llvm.linkage<internal>, sym_name = "fd_f25519_one", unnamed_addr = 0 : i64, visibility_ = 0 : i64}> ({
  %6436 = "llvm.mlir.undef"() : () -> !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>
  %6437 = "llvm.mlir.constant"() <{value = dense<[1, 0, 0, 0, 0, 0, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %6438 = "llvm.mlir.undef"() : () -> !llvm.struct<"struct.fd_f25519", (vector<8xi64>)>
  %6439 = "llvm.insertvalue"(%6438, %6437) <{position = array<i64: 0>}> : (!llvm.struct<"struct.fd_f25519", (vector<8xi64>)>, vector<8xi64>) -> !llvm.struct<"struct.fd_f25519", (vector<8xi64>)>
  %6440 = "llvm.insertvalue"(%6436, %6439) <{position = array<i64: 0>}> : (!llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>, !llvm.struct<"struct.fd_f25519", (vector<8xi64>)>) -> !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>
  "llvm.return"(%6440) : (!llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>) -> ()
}) : () -> ()

end

end MLIR.Firedancer.R52x5
