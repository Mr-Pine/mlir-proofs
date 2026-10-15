
module

public import MLIR.Semantics.GlobalInitializer
public import MLIR.Syntax.Elab



namespace Firedancer.LaneNI.Mlir

@[expose] public section

mlir_const_def __func___fd_sha512_leave := "llvm.mlir.global"() <{addr_space = 0 : i32, alignment = 1 : i64, constant, dso_local, global_type = !llvm.array<16 x i8>, linkage = #llvm.linkage<private>, sym_name = "__func__.fd_sha512_leave", unnamed_addr = 2 : i64, value = "fd_sha512_leave\00", visibility_ = 0 : i64}> ({
}) : () -> ()

end

end Firedancer.LaneNI.Mlir
