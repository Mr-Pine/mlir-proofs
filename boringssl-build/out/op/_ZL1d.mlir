"llvm.mlir.global"() <{addr_space = 0 : i32, alignment = 8 : i64, constant, dso_local, global_type = !llvm.struct<"struct.bssl::fe", (array<5 x i64>)>, linkage = #llvm.linkage<internal>, sym_name = "_ZL1d", unnamed_addr = 0 : i64, visibility_ = 0 : i64}> ({
  %2050 = "llvm.mlir.constant"() <{value = dense<[929955233495203, 466365720129213, 1662059464998953, 2033849074728123, 1442794654840575]> : tensor<5xi64>}> : () -> !llvm.array<5 x i64>
  %2051 = "llvm.mlir.undef"() : () -> !llvm.struct<"struct.bssl::fe", (array<5 x i64>)>
  %2052 = "llvm.insertvalue"(%2051, %2050) <{position = array<i64: 0>}> : (!llvm.struct<"struct.bssl::fe", (array<5 x i64>)>, !llvm.array<5 x i64>) -> !llvm.struct<"struct.bssl::fe", (array<5 x i64>)>
  "llvm.return"(%2052) : (!llvm.struct<"struct.bssl::fe", (array<5 x i64>)>) -> ()
}) : () -> ()
