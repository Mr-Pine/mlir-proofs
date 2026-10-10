"llvm.mlir.global"() <{addr_space = 0 : i32, alignment = 8 : i64, constant, dso_local, global_type = !llvm.struct<"Fe", (array<5 x i64>)>, linkage = #llvm.linkage<private>, sym_name = "Fe.edwards25519d2", unnamed_addr = 2 : i64, visibility_ = 0 : i64}> ({
  %4000 = "llvm.mlir.constant"() <{value = dense<[1859910466990425, 932731440258426, 1072319116312658, 1815898335770999, 633789495995903]> : tensor<5xi64>}> : () -> !llvm.array<5 x i64>
  %4001 = "llvm.mlir.undef"() : () -> !llvm.struct<"Fe", (array<5 x i64>)>
  %4002 = "llvm.insertvalue"(%4001, %4000) <{position = array<i64: 0>}> : (!llvm.struct<"Fe", (array<5 x i64>)>, !llvm.array<5 x i64>) -> !llvm.struct<"Fe", (array<5 x i64>)>
  "llvm.return"(%4002) : (!llvm.struct<"Fe", (array<5 x i64>)>) -> ()
}) : () -> ()
