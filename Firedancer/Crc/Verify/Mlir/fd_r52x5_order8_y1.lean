module

-- crc/out/mlirproofs/regions/verify/fd_r52x5_order8_y1.mlir

public import MLIR.Semantics.GlobalInitializer
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.GlobalInitializer

namespace MLIR.Firedancer.Crc.Verify

@[expose] public section

mlir_const_def fd_r52x5_order8_y1 :=
"llvm.mlir.global"() <{addr_space = 0 : i32, alignment = 16 : i64, constant, dso_local, global_type = !llvm.array<5 x i64>, linkage = #llvm.linkage<internal>, sym_name = "fd_r52x5_order8_y1", unnamed_addr = 0 : i64, value = dense<[84926274344903, 473620666599931, 365590438845504, 1028470286882429, 2146499180330972]> : tensor<5xi64>, visibility_ = 0 : i64}> ({
}) : () -> ()

end

end MLIR.Firedancer.Crc.Verify
