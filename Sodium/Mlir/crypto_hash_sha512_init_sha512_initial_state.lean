module

-- sodium-build/out/op/crypto_hash_sha512_init.sha512_initial_state.mlir

public import MLIR.Semantics.GlobalInitializer
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.GlobalInitializer

namespace MLIR.Sodium

@[expose] public section

mlir_const_def crypto_hash_sha512_init_sha512_initial_state :=
"llvm.mlir.global"() <{addr_space = 0 : i32, alignment = 16 : i64, constant, dso_local, global_type = !llvm.array<8 x i64>, linkage = #llvm.linkage<internal>, sym_name = "crypto_hash_sha512_init.sha512_initial_state", unnamed_addr = 0 : i64, value = dense<[7640891576956012808, -4942790177534073029, 4354685564936845355, -6534734903238641935, 5840696475078001361, -7276294671716946913, 2270897969802886507, 6620516959819538809]> : tensor<8xi64>, visibility_ = 0 : i64}> ({
}) : () -> ()

end

end MLIR.Sodium
