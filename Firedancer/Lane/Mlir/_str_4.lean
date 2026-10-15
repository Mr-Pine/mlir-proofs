
module

public import MLIR.Semantics.GlobalInitializer
public import MLIR.Syntax.Elab



namespace Firedancer.Lane.Mlir

@[expose] public section

mlir_const_def _str_4 := "llvm.mlir.global"() <{addr_space = 0 : i32, alignment = 1 : i64, constant, dso_local, global_type = !llvm.array<17 x i8>, linkage = #llvm.linkage<private>, sym_name = ".str.4", unnamed_addr = 2 : i64, value = "misaligned shsha\00", visibility_ = 0 : i64}> ({
}) : () -> ()

end

end Firedancer.Lane.Mlir
