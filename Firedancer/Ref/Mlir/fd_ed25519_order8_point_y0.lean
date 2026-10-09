module

-- build/llvm23/mlir_canonicalized/ref/op/fd_ed25519_order8_point_y0.mlir

public import MLIR.Semantics.GlobalInitializer
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.GlobalInitializer

namespace MLIR.Firedancer.Ref

@[expose] public section

mlir_const_def fd_ed25519_order8_point_y0 :=
"llvm.mlir.global"() <{addr_space = 0 : i32, alignment = 16 : i64, constant, dso_local, global_type = !llvm.array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>, linkage = #llvm.linkage<internal>, sym_name = "fd_ed25519_order8_point_y0", unnamed_addr = 0 : i64, visibility_ = 0 : i64}> ({
  %2218 = "llvm.mlir.undef"() : () -> !llvm.array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>
  %2219 = "llvm.mlir.constant"() <{value = dense<[2166873539340326, 1778179147085316, 1886209374839743, 1223329526802818, 105300633354275]> : tensor<5xi64>}> : () -> !llvm.array<5 x i64>
  %2220 = "llvm.mlir.undef"() : () -> !llvm.struct<"struct.fd_f25519", (array<5 x i64>)>
  %2221 = "llvm.insertvalue"(%2220, %2219) <{position = array<i64: 0>}> : (!llvm.struct<"struct.fd_f25519", (array<5 x i64>)>, !llvm.array<5 x i64>) -> !llvm.struct<"struct.fd_f25519", (array<5 x i64>)>
  %2222 = "llvm.insertvalue"(%2218, %2221) <{position = array<i64: 0>}> : (!llvm.array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>, !llvm.struct<"struct.fd_f25519", (array<5 x i64>)>) -> !llvm.array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>
  "llvm.return"(%2222) : (!llvm.array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>) -> ()
}) : () -> ()

end

end MLIR.Firedancer.Ref
