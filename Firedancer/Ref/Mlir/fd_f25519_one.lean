module

-- build/llvm23/mlir_canonicalized/ref/op/fd_f25519_one.mlir

public import MLIR.Semantics.GlobalInitializer
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.GlobalInitializer

namespace MLIR.Firedancer.Ref

@[expose] public section

mlir_const_def fd_f25519_one :=
"llvm.mlir.global"() <{addr_space = 0 : i32, alignment = 16 : i64, constant, dso_local, global_type = !llvm.array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>, linkage = #llvm.linkage<internal>, sym_name = "fd_f25519_one", unnamed_addr = 0 : i64, visibility_ = 0 : i64}> ({
  %4038 = "llvm.mlir.undef"() : () -> !llvm.array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>
  %4039 = "llvm.mlir.constant"() <{value = dense<[1, 0, 0, 0, 0]> : tensor<5xi64>}> : () -> !llvm.array<5 x i64>
  %4040 = "llvm.mlir.undef"() : () -> !llvm.struct<"struct.fd_f25519", (array<5 x i64>)>
  %4041 = "llvm.insertvalue"(%4040, %4039) <{position = array<i64: 0>}> : (!llvm.struct<"struct.fd_f25519", (array<5 x i64>)>, !llvm.array<5 x i64>) -> !llvm.struct<"struct.fd_f25519", (array<5 x i64>)>
  %4042 = "llvm.insertvalue"(%4038, %4041) <{position = array<i64: 0>}> : (!llvm.array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>, !llvm.struct<"struct.fd_f25519", (array<5 x i64>)>) -> !llvm.array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>
  "llvm.return"(%4042) : (!llvm.array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>) -> ()
}) : () -> ()

end

end MLIR.Firedancer.Ref
