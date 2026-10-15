
module

public import MLIR.Semantics.GlobalInitializer
public import MLIR.Syntax.Elab



namespace MLIR.Firedancer.Crc.Ref

@[expose] public section

mlir_const_def crc_fe64_canon_P_46 := "llvm.mlir.global"() <{addr_space = 0 : i32, alignment = 16 : i64, constant, dso_local, global_type = !llvm.array<4 x i64>, linkage = #llvm.linkage<internal>, sym_name = "crc_fe64_canon.P.46", unnamed_addr = 2 : i64, value = dense<[-19, -1, -1, 9223372036854775807]> : tensor<4xi64>, visibility_ = 0 : i64}> ({
}) : () -> ()

end

end MLIR.Firedancer.Crc.Ref
