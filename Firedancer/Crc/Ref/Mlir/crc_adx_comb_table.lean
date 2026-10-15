
module

public import MLIR.Semantics.GlobalInitializer
public import MLIR.Syntax.Elab



namespace MLIR.Firedancer.Crc.Ref

@[expose] public section

mlir_const_def crc_adx_comb_table := "llvm.mlir.global"() <{addr_space = 0 : i32, alignment = 64 : i64, dso_local, global_type = !llvm.array<64 x array<8 x array<12 x i64>>>, linkage = #llvm.linkage<internal>, sym_name = "crc_adx_comb_table", unnamed_addr = 0 : i64, value = dense<0> : tensor<64x8x12xi64>, visibility_ = 0 : i64}> ({
}) : () -> ()

end

end MLIR.Firedancer.Crc.Ref
