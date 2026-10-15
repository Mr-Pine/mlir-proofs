
module

public import MLIR.Semantics.GlobalInitializer
public import MLIR.Syntax.Elab



namespace Firedancer.LaneNI.Mlir

@[expose] public section

mlir_const_def _str_8 := "llvm.mlir.global"() <{addr_space = 0 : i32, alignment = 1 : i64, constant, dso_local, global_type = !llvm.array<8 x i8>, linkage = #llvm.linkage<private>, sym_name = ".str.8", unnamed_addr = 2 : i64, value = "unknown\00", visibility_ = 0 : i64}> ({
}) : () -> ()

end

end Firedancer.LaneNI.Mlir
