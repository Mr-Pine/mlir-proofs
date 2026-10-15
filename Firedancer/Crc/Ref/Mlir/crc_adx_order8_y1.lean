
module

public import MLIR.Semantics.GlobalInitializer
public import MLIR.Syntax.Elab



namespace MLIR.Firedancer.Crc.Ref

@[expose] public section

mlir_const_def crc_adx_order8_y1 := "llvm.mlir.global"() <{addr_space = 0 : i32, alignment = 16 : i64, constant, dso_local, global_type = !llvm.array<4 x i64>, linkage = #llvm.linkage<internal>, sym_name = "crc_adx_order8_y1", unnamed_addr = 0 : i64, value = dense<[5753433450240153543, 1109873483171183802, -4121856693609750486, 8792060642635663182]> : tensor<4xi64>, visibility_ = 0 : i64}> ({
}) : () -> ()

end

end MLIR.Firedancer.Crc.Ref
