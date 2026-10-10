"llvm.mlir.global"() <{addr_space = 0 : i32, alignment = 16 : i64, constant, dso_local, global_type = !llvm.struct<packed (i8, array<127 x i8>)>, linkage = #llvm.linkage<internal>, sym_name = "PAD", unnamed_addr = 2 : i64, visibility_ = 0 : i64}> ({
  %3318 = "llvm.mlir.constant"() <{value = dense<0> : tensor<127xi8>}> : () -> !llvm.array<127 x i8>
  %3319 = "llvm.mlir.constant"() <{value = -128 : i8}> : () -> i8
  %3320 = "llvm.mlir.undef"() : () -> !llvm.struct<packed (i8, array<127 x i8>)>
  %3321 = "llvm.insertvalue"(%3320, %3319) <{position = array<i64: 0>}> : (!llvm.struct<packed (i8, array<127 x i8>)>, i8) -> !llvm.struct<packed (i8, array<127 x i8>)>
  %3322 = "llvm.insertvalue"(%3321, %3318) <{position = array<i64: 1>}> : (!llvm.struct<packed (i8, array<127 x i8>)>, !llvm.array<127 x i8>) -> !llvm.struct<packed (i8, array<127 x i8>)>
  "llvm.return"(%3322) : (!llvm.struct<packed (i8, array<127 x i8>)>) -> ()
}) : () -> ()
