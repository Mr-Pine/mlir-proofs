module

-- build/llvm23/mlir_canonicalized/ref/op/fd_ed25519_order8_point_y1.mlir

public import MLIR.Semantics.GlobalInitializer
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.GlobalInitializer

namespace MLIR.Firedancer.Ref

@[expose] public section

mlir_const_def fd_ed25519_order8_point_y1 :=
"llvm.mlir.global"() <{addr_space = 0 : i32, alignment = 16 : i64, constant, dso_local, global_type = !llvm.array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>, linkage = #llvm.linkage<internal>, sym_name = "fd_ed25519_order8_point_y1", unnamed_addr = 0 : i64, visibility_ = 0 : i64}> ({
  %2213 = "llvm.mlir.undef"() : () -> !llvm.array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>
  %2214 = "llvm.mlir.constant"() <{value = dense<[84926274344903, 473620666599931, 365590438845504, 1028470286882429, 2146499180330972]> : tensor<5xi64>}> : () -> !llvm.array<5 x i64>
  %2215 = "llvm.mlir.undef"() : () -> !llvm.struct<"struct.fd_f25519", (array<5 x i64>)>
  %2216 = "llvm.insertvalue"(%2215, %2214) <{position = array<i64: 0>}> : (!llvm.struct<"struct.fd_f25519", (array<5 x i64>)>, !llvm.array<5 x i64>) -> !llvm.struct<"struct.fd_f25519", (array<5 x i64>)>
  %2217 = "llvm.insertvalue"(%2213, %2216) <{position = array<i64: 0>}> : (!llvm.array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>, !llvm.struct<"struct.fd_f25519", (array<5 x i64>)>) -> !llvm.array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>
  "llvm.return"(%2217) : (!llvm.array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>) -> ()
}) : () -> ()

end

end MLIR.Firedancer.Ref
