
module

public import MLIR.Semantics.GlobalInitializer
public import MLIR.Syntax.Elab



namespace Firedancer.Lane.Mlir

@[expose] public section

mlir_const_def fd_ed25519_sign_batch8_buf := "llvm.mlir.global"() <{addr_space = 0 : i32, alignment = 64 : i64, dso_local, global_type = !llvm.array<8 x array<2112 x i8>>, linkage = #llvm.linkage<internal>, sym_name = "fd_ed25519_sign_batch8.buf", thread_local_, unnamed_addr = 0 : i64, value = dense<0> : tensor<8x2112xi8>, visibility_ = 0 : i64}> ({
}) : () -> ()

end

end Firedancer.Lane.Mlir
