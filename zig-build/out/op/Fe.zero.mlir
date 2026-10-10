"llvm.mlir.global"() <{addr_space = 0 : i32, alignment = 8 : i64, constant, dso_local, global_type = !llvm.struct<"Fe", (array<5 x i64>)>, linkage = #llvm.linkage<private>, sym_name = "Fe.zero", unnamed_addr = 2 : i64, visibility_ = 0 : i64}> ({
  %4016 = "llvm.mlir.zero"() : () -> !llvm.struct<"Fe", (array<5 x i64>)>
  "llvm.return"(%4016) : (!llvm.struct<"Fe", (array<5 x i64>)>) -> ()
}) : () -> ()
