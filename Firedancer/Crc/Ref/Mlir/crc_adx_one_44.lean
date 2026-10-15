
module

public import MLIR.Semantics.GlobalInitializer
public import MLIR.Syntax.Elab



namespace MLIR.Firedancer.Crc.Ref

@[expose] public section

mlir_const_def crc_adx_one_44 := "llvm.mlir.global"() <{addr_space = 0 : i32, alignment = 16 : i64, constant, dso_local, global_type = !llvm.array<4 x i64>, linkage = #llvm.linkage<internal>, sym_name = "crc_adx_one.44", unnamed_addr = 2 : i64, value = dense<[1, 0, 0, 0]> : tensor<4xi64>, visibility_ = 0 : i64}> ({
}) : () -> ()

end

end MLIR.Firedancer.Crc.Ref
