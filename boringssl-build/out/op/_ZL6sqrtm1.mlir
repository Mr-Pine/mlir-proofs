"llvm.mlir.global"() <{addr_space = 0 : i32, alignment = 8 : i64, constant, dso_local, global_type = !llvm.struct<"struct.bssl::fe", (array<5 x i64>)>, linkage = #llvm.linkage<internal>, sym_name = "_ZL6sqrtm1", unnamed_addr = 0 : i64, visibility_ = 0 : i64}> ({
  %2047 = "llvm.mlir.constant"() <{value = dense<[1718705420411056, 234908883556509, 2233514472574048, 2117202627021982, 765476049583133]> : tensor<5xi64>}> : () -> !llvm.array<5 x i64>
  %2048 = "llvm.mlir.undef"() : () -> !llvm.struct<"struct.bssl::fe", (array<5 x i64>)>
  %2049 = "llvm.insertvalue"(%2048, %2047) <{position = array<i64: 0>}> : (!llvm.struct<"struct.bssl::fe", (array<5 x i64>)>, !llvm.array<5 x i64>) -> !llvm.struct<"struct.bssl::fe", (array<5 x i64>)>
  "llvm.return"(%2049) : (!llvm.struct<"struct.bssl::fe", (array<5 x i64>)>) -> ()
}) : () -> ()
