module

-- boringssl-build/out/op/_ZZL12fe_isnonzeroPKN4bssl2feEE4zero.mlir
-- fe_isnonzero(bssl::fe const*)::zero

public import MLIR.Semantics.GlobalInitializer
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.GlobalInitializer

namespace MLIR.Boringssl

@[expose] public section

mlir_const_def fe_isnonzero_zero :=
"llvm.mlir.global"() <{addr_space = 0 : i32, alignment = 16 : i64, constant, dso_local, global_type = !llvm.array<32 x i8>, linkage = #llvm.linkage<internal>, sym_name = "_ZZL12fe_isnonzeroPKN4bssl2feEE4zero", unnamed_addr = 0 : i64, value = dense<0> : tensor<32xi8>, visibility_ = 0 : i64}> ({
}) : () -> ()

end

end MLIR.Boringssl
