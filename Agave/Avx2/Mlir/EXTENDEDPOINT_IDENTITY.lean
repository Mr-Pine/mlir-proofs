module

-- agave-build/out/avx2-noinline-big/op/_RNvNtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx29constants22EXTENDEDPOINT_IDENTITY.mlir
-- solana_ed25519[c79103de3f6f5451]::backend::vector::avx2::constants::EXTENDEDPOINT_IDENTITY

public import MLIR.Semantics.GlobalInitializer
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.GlobalInitializer

namespace MLIR.Agave.Avx2

@[expose] public section

mlir_const_def EXTENDEDPOINT_IDENTITY :=
"llvm.mlir.global"() <{addr_space = 0 : i32, alignment = 32 : i64, constant, dso_local, global_type = !llvm.array<160 x i8>, linkage = #llvm.linkage<internal>, sym_name = "_RNvNtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx29constants22EXTENDEDPOINT_IDENTITY", unnamed_addr = 2 : i64, value = "\00\00\00\00\01\00\00\00\00\00\00\00\00\00\00\00\01\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00", visibility_ = 0 : i64}> ({
}) : () -> ()

end

end MLIR.Agave.Avx2
