
module

public import MLIR.Semantics.GlobalInitializer
public import MLIR.Syntax.Elab



namespace MLIR.Firedancer.Crc.Ref

@[expose] public section

mlir_const_def __const_crc_adx_base_table_build_b := "llvm.mlir.global"() <{addr_space = 0 : i32, alignment = 16 : i64, constant, dso_local, global_type = !llvm.array<16 x i64>, linkage = #llvm.linkage<private>, sym_name = "__const.crc_adx_base_table_build.b", unnamed_addr = 2 : i64, value = dense<[-3938910931347188454, 7578651490590762930, -4565275417906848676, 2407515759118799870, 7378697629483820632, 7378697629483820646, 7378697629483820646, 7378697629483820646, 1, 0, 0, 0, 7916917699147980195, 2373572377730700021, 7415826109900252029, 7460035829407905381]> : tensor<16xi64>, visibility_ = 0 : i64}> ({
}) : () -> ()

end

end MLIR.Firedancer.Crc.Ref
