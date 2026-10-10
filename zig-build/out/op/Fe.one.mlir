"llvm.mlir.global"() <{addr_space = 0 : i32, alignment = 8 : i64, constant, dso_local, global_type = !llvm.struct<"Fe", (array<5 x i64>)>, linkage = #llvm.linkage<private>, sym_name = "Fe.one", unnamed_addr = 2 : i64, visibility_ = 0 : i64}> ({
  %4038 = "llvm.mlir.constant"() <{value = dense<[1, 0, 0, 0, 0]> : tensor<5xi64>}> : () -> !llvm.array<5 x i64>
  %4039 = "llvm.mlir.undef"() : () -> !llvm.struct<"Fe", (array<5 x i64>)>
  %4040 = "llvm.insertvalue"(%4039, %4038) <{position = array<i64: 0>}> : (!llvm.struct<"Fe", (array<5 x i64>)>, !llvm.array<5 x i64>) -> !llvm.struct<"Fe", (array<5 x i64>)>
  "llvm.return"(%4040) : (!llvm.struct<"Fe", (array<5 x i64>)>) -> ()
}) : () -> ()
