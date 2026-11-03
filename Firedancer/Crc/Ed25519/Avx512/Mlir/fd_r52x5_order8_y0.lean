module

-- crc/out/mlirproofs/regions/verify/fd_r52x5_order8_y0.mlir

public import MLIR.Semantics.GlobalInitializer
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.GlobalInitializer

namespace MLIR.Firedancer.Crc.Ed25519.Avx512

@[expose] public section

mlir_const_def fd_r52x5_order8_y0 :=
"llvm.mlir.global"() <{addr_space = 0 : i32, alignment = 16 : i64, constant, dso_local, global_type = !llvm.array<5 x i64>, linkage = #llvm.linkage<internal>, sym_name = "fd_r52x5_order8_y0", unnamed_addr = 0 : i64, value = dense<[2166873539340326, 1778179147085316, 1886209374839743, 1223329526802818, 105300633354275]> : tensor<5xi64>, visibility_ = 0 : i64}> ({
}) : () -> ()

end

end MLIR.Firedancer.Crc.Ed25519.Avx512
