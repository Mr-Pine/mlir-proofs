
module

public import MLIR.Semantics.GlobalInitializer
public import MLIR.Syntax.Elab



namespace Firedancer.Lane.Mlir

@[expose] public section

mlir_const_def fd_f25519_one_28 := "llvm.mlir.global"() <{addr_space = 0 : i32, alignment = 64 : i64, constant, dso_local, global_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>, linkage = #llvm.linkage<internal>, sym_name = "fd_f25519_one.28", unnamed_addr = 0 : i64, visibility_ = 0 : i64}> ({
  %0 = "llvm.mlir.undef"() : () -> !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>
  %1 = "llvm.mlir.constant"() <{value = dense<[1, 0, 0, 0, 0, 0, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %2 = "llvm.mlir.undef"() : () -> !llvm.struct<"struct.fd_f25519", (vector<8xi64>)>
  %3 = "llvm.insertvalue"(%2, %1) <{position = array<i64: 0>}> : (!llvm.struct<"struct.fd_f25519", (vector<8xi64>)>, vector<8xi64>) -> !llvm.struct<"struct.fd_f25519", (vector<8xi64>)>
  %4 = "llvm.insertvalue"(%0, %3) <{position = array<i64: 0>}> : (!llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>, !llvm.struct<"struct.fd_f25519", (vector<8xi64>)>) -> !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>
  "llvm.return"(%4) : (!llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>) -> ()
}) : () -> ()

end

end Firedancer.Lane.Mlir
