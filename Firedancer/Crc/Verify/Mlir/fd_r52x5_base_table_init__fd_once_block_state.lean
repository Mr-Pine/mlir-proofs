module

-- crc/out/mlirproofs/regions/verify/fd_r52x5_base_table_init._fd_once_block_state.mlir

public import MLIR.Semantics.GlobalInitializer
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.GlobalInitializer

namespace MLIR.Firedancer.Crc.Verify

@[expose] public section

mlir_const_def fd_r52x5_base_table_init__fd_once_block_state :=
"llvm.mlir.global"() <{addr_space = 0 : i32, alignment = 4 : i64, dso_local, global_type = i1, linkage = #llvm.linkage<internal>, sym_name = "fd_r52x5_base_table_init._fd_once_block_state", unnamed_addr = 2 : i64, value = false, visibility_ = 0 : i64}> ({
}) : () -> ()

end

end MLIR.Firedancer.Crc.Verify
