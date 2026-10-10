module

-- sodium-build/out/op/sc25519_is_canonical.L.mlir

public import MLIR.Semantics.GlobalInitializer
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.GlobalInitializer

namespace MLIR.Sodium

@[expose] public section

mlir_const_def sc25519_is_canonical_L :=
"llvm.mlir.global"() <{addr_space = 0 : i32, alignment = 16 : i64, constant, dso_local, global_type = !llvm.array<32 x i8>, linkage = #llvm.linkage<internal>, sym_name = "sc25519_is_canonical.L", unnamed_addr = 2 : i64, value = "\ED\D3\F5\\\1Ac\12X\D6\9C\F7\A2\DE\F9\DE\14\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\10", visibility_ = 0 : i64}> ({
}) : () -> ()

end

end MLIR.Sodium
