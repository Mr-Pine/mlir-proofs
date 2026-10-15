
module

public import MLIR.Semantics.GlobalInitializer
public import MLIR.Syntax.Elab



namespace Firedancer.Lane.Mlir

@[expose] public section

mlir_const_def _str_3_53 := "llvm.mlir.global"() <{addr_space = 0 : i32, alignment = 1 : i64, constant, dso_local, global_type = !llvm.array<41 x i8>, linkage = #llvm.linkage<private>, sym_name = ".str.3.53", unnamed_addr = 2 : i64, value = "msg_sz[i]<=FD_ED25519_SIGN_BATCH_MSG_MAX\00", visibility_ = 0 : i64}> ({
}) : () -> ()

end

end Firedancer.Lane.Mlir
