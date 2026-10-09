module

-- build/llvm23/mlir_canonicalized/avx512/op/fd_ed25519_order8_point_y1.mlir

public import MLIR.Semantics.GlobalInitializer
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.GlobalInitializer

namespace MLIR.Firedancer.Avx512

@[expose] public section

mlir_const_def fd_ed25519_order8_point_y1 :=
"llvm.mlir.global"() <{addr_space = 0 : i32, alignment = 64 : i64, constant, dso_local, global_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>, linkage = #llvm.linkage<internal>, sym_name = "fd_ed25519_order8_point_y1", unnamed_addr = 0 : i64, visibility_ = 0 : i64}> ({
  %3373 = "llvm.mlir.undef"() : () -> !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>
  %3374 = "llvm.mlir.constant"() <{value = dense<[5761437145031, 1544431467273, 264614458840, 5044391481365, 8643435850947, 1048095302895, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %3375 = "llvm.mlir.undef"() : () -> !llvm.struct<"struct.fd_f25519", (vector<8xi64>)>
  %3376 = "llvm.insertvalue"(%3375, %3374) <{position = array<i64: 0>}> : (!llvm.struct<"struct.fd_f25519", (vector<8xi64>)>, vector<8xi64>) -> !llvm.struct<"struct.fd_f25519", (vector<8xi64>)>
  %3377 = "llvm.insertvalue"(%3373, %3376) <{position = array<i64: 0>}> : (!llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>, !llvm.struct<"struct.fd_f25519", (vector<8xi64>)>) -> !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>
  "llvm.return"(%3377) : (!llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>) -> ()
}) : () -> ()

end

end MLIR.Firedancer.Avx512
