
module

public import MLIR.Semantics.GlobalInitializer
public import MLIR.Syntax.Elab



namespace MLIR.Firedancer.Crc.Ref

@[expose] public section

mlir_const_def crc_adx_base_table := "llvm.mlir.global"() <{addr_space = 0 : i32, alignment = 64 : i64, dso_local, global_type = !llvm.array<128 x array<16 x i64>>, linkage = #llvm.linkage<internal>, sym_name = "crc_adx_base_table", unnamed_addr = 0 : i64, value = dense<0> : tensor<128x16xi64>, visibility_ = 0 : i64}> ({
}) : () -> ()

end

end MLIR.Firedancer.Crc.Ref
