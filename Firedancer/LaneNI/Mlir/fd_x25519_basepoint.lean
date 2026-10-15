
module

public import MLIR.Semantics.GlobalInitializer
public import MLIR.Syntax.Elab



namespace Firedancer.LaneNI.Mlir

@[expose] public section

mlir_const_def fd_x25519_basepoint := "llvm.mlir.global"() <{addr_space = 0 : i32, alignment = 16 : i64, constant, dso_local, global_type = !llvm.struct<packed (i8, array<31 x i8>)>, linkage = #llvm.linkage<internal>, sym_name = "fd_x25519_basepoint", unnamed_addr = 0 : i64, visibility_ = 0 : i64}> ({
  %0 = "llvm.mlir.constant"() <{value = dense<0> : tensor<31xi8>}> : () -> !llvm.array<31 x i8>
  %1 = "llvm.mlir.constant"() <{value = 9 : i8}> : () -> i8
  %2 = "llvm.mlir.undef"() : () -> !llvm.struct<packed (i8, array<31 x i8>)>
  %3 = "llvm.insertvalue"(%2, %1) <{position = array<i64: 0>}> : (!llvm.struct<packed (i8, array<31 x i8>)>, i8) -> !llvm.struct<packed (i8, array<31 x i8>)>
  %4 = "llvm.insertvalue"(%3, %0) <{position = array<i64: 1>}> : (!llvm.struct<packed (i8, array<31 x i8>)>, !llvm.array<31 x i8>) -> !llvm.struct<packed (i8, array<31 x i8>)>
  "llvm.return"(%4) : (!llvm.struct<packed (i8, array<31 x i8>)>) -> ()
}) : () -> ()

end

end Firedancer.LaneNI.Mlir
