
module

public import MLIR.Semantics.GlobalInitializer
public import MLIR.Syntax.Elab



namespace Firedancer.Lane.Mlir

@[expose] public section

mlir_const_def decode_stage_sqr_cnt := "llvm.mlir.global"() <{addr_space = 0 : i32, alignment = 16 : i64, constant, dso_local, global_type = !llvm.array<12 x i64>, linkage = #llvm.linkage<internal>, sym_name = "decode_stage.sqr_cnt", unnamed_addr = 2 : i64, value = dense<[1, 2, 0, 1, 5, 10, 20, 10, 50, 100, 50, 2]> : tensor<12xi64>, visibility_ = 0 : i64}> ({
}) : () -> ()

end

end Firedancer.Lane.Mlir
