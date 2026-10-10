"llvm.mlir.global"() <{addr_space = 0 : i32, alignment = 8 : i64, constant, dso_local, global_type = !llvm.struct<"Fe", (array<5 x i64>)>, linkage = #llvm.linkage<private>, sym_name = "Fe.sqrtm1", unnamed_addr = 2 : i64, visibility_ = 0 : i64}> ({
  %4028 = "llvm.mlir.constant"() <{value = dense<[1718705420411056, 234908883556509, 2233514472574048, 2117202627021982, 765476049583133]> : tensor<5xi64>}> : () -> !llvm.array<5 x i64>
  %4029 = "llvm.mlir.undef"() : () -> !llvm.struct<"Fe", (array<5 x i64>)>
  %4030 = "llvm.insertvalue"(%4029, %4028) <{position = array<i64: 0>}> : (!llvm.struct<"Fe", (array<5 x i64>)>, !llvm.array<5 x i64>) -> !llvm.struct<"Fe", (array<5 x i64>)>
  "llvm.return"(%4030) : (!llvm.struct<"Fe", (array<5 x i64>)>) -> ()
}) : () -> ()
