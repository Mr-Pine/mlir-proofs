"llvm.mlir.global"() <{addr_space = 0 : i32, alignment = 16 : i64, constant, dso_local, global_type = !llvm.struct<"Sha512", (i128, array<8 x i64>, array<128 x i8>, i8, array<15 x i8>)>, linkage = #llvm.linkage<private>, sym_name = "Sha512.iv", unnamed_addr = 2 : i64, visibility_ = 0 : i64}> ({
  %4017 = "llvm.mlir.undef"() : () -> !llvm.array<15 x i8>
  %4018 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %4019 = "llvm.mlir.undef"() : () -> !llvm.array<128 x i8>
  %4020 = "llvm.mlir.constant"() <{value = dense<[7640891576956012808, -4942790177534073029, 4354685564936845355, -6534734903238641935, 5840696475078001361, -7276294671716946913, 2270897969802886507, 6620516959819538809]> : tensor<8xi64>}> : () -> !llvm.array<8 x i64>
  %4021 = "llvm.mlir.constant"() <{value = 0 : i128}> : () -> i128
  %4022 = "llvm.mlir.undef"() : () -> !llvm.struct<"Sha512", (i128, array<8 x i64>, array<128 x i8>, i8, array<15 x i8>)>
  %4023 = "llvm.insertvalue"(%4022, %4021) <{position = array<i64: 0>}> : (!llvm.struct<"Sha512", (i128, array<8 x i64>, array<128 x i8>, i8, array<15 x i8>)>, i128) -> !llvm.struct<"Sha512", (i128, array<8 x i64>, array<128 x i8>, i8, array<15 x i8>)>
  %4024 = "llvm.insertvalue"(%4023, %4020) <{position = array<i64: 1>}> : (!llvm.struct<"Sha512", (i128, array<8 x i64>, array<128 x i8>, i8, array<15 x i8>)>, !llvm.array<8 x i64>) -> !llvm.struct<"Sha512", (i128, array<8 x i64>, array<128 x i8>, i8, array<15 x i8>)>
  %4025 = "llvm.insertvalue"(%4024, %4019) <{position = array<i64: 2>}> : (!llvm.struct<"Sha512", (i128, array<8 x i64>, array<128 x i8>, i8, array<15 x i8>)>, !llvm.array<128 x i8>) -> !llvm.struct<"Sha512", (i128, array<8 x i64>, array<128 x i8>, i8, array<15 x i8>)>
  %4026 = "llvm.insertvalue"(%4025, %4018) <{position = array<i64: 3>}> : (!llvm.struct<"Sha512", (i128, array<8 x i64>, array<128 x i8>, i8, array<15 x i8>)>, i8) -> !llvm.struct<"Sha512", (i128, array<8 x i64>, array<128 x i8>, i8, array<15 x i8>)>
  %4027 = "llvm.insertvalue"(%4026, %4017) <{position = array<i64: 4>}> : (!llvm.struct<"Sha512", (i128, array<8 x i64>, array<128 x i8>, i8, array<15 x i8>)>, !llvm.array<15 x i8>) -> !llvm.struct<"Sha512", (i128, array<8 x i64>, array<128 x i8>, i8, array<15 x i8>)>
  "llvm.return"(%4027) : (!llvm.struct<"Sha512", (i128, array<8 x i64>, array<128 x i8>, i8, array<15 x i8>)>) -> ()
}) : () -> ()
