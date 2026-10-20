module

-- crc/out/mlirproofs/regions/verify/fd_r52x5_base_split_table.mlir

public import MLIR.Semantics.GlobalInitializer
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.GlobalInitializer

namespace MLIR.Firedancer.Crc.Verify

@[expose] public section

mlir_const_def fd_r52x5_base_split_table :=
"llvm.mlir.global"() <{addr_space = 0 : i32, alignment = 64 : i64, dso_local, global_type = !llvm.array<7 x array<128 x struct<"struct.fd_r52x5_ge", (vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, array<32 x i8>)>>>, linkage = #llvm.linkage<internal>, sym_name = "fd_r52x5_base_split_table", unnamed_addr = 0 : i64, visibility_ = 0 : i64}> ({
  %3553 = "llvm.mlir.zero"() : () -> !llvm.array<7 x array<128 x struct<"struct.fd_r52x5_ge", (vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, array<32 x i8>)>>>
  "llvm.return"(%3553) : (!llvm.array<7 x array<128 x struct<"struct.fd_r52x5_ge", (vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, array<32 x i8>)>>>) -> ()
}) : () -> ()

end

end MLIR.Firedancer.Crc.Verify
