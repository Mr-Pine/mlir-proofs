module

-- sodium-build/out/op/_crypto_sign_ed25519_ref10_hinit.DOM2PREFIX.mlir

public import MLIR.Semantics.GlobalInitializer
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.GlobalInitializer

namespace MLIR.Sodium

@[expose] public section

mlir_const_def _crypto_sign_ed25519_ref10_hinit_DOM2PREFIX :=
"llvm.mlir.global"() <{addr_space = 0 : i32, alignment = 16 : i64, constant, dso_local, global_type = !llvm.array<34 x i8>, linkage = #llvm.linkage<internal>, sym_name = "_crypto_sign_ed25519_ref10_hinit.DOM2PREFIX", unnamed_addr = 0 : i64, value = "SigEd25519 no Ed25519 collisions\01\00", visibility_ = 0 : i64}> ({
}) : () -> ()

end

end MLIR.Sodium
