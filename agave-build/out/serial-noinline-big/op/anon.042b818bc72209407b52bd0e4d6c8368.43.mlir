"llvm.mlir.global"() <{addr_space = 0 : i32, alignment = 8 : i64, constant, dso_local, global_type = !llvm.struct<packed (ptr, array<16 x i8>)>, linkage = #llvm.linkage<internal>, sym_name = "anon.042b818bc72209407b52bd0e4d6c8368.43", unnamed_addr = 2 : i64, visibility_ = 0 : i64}> ({
  %5485 = "llvm.mlir.constant"() <{value = "S\00\00\00\00\00\00\00\DF\00\00\00\1B\00\00\00"}> : () -> !llvm.array<16 x i8>
  %5486 = "llvm.mlir.addressof"() <{global_name = @anon.042b818bc72209407b52bd0e4d6c8368.0}> : () -> !llvm.ptr
  %5487 = "llvm.mlir.undef"() : () -> !llvm.struct<packed (ptr, array<16 x i8>)>
  %5488 = "llvm.insertvalue"(%5487, %5486) <{position = array<i64: 0>}> : (!llvm.struct<packed (ptr, array<16 x i8>)>, !llvm.ptr) -> !llvm.struct<packed (ptr, array<16 x i8>)>
  %5489 = "llvm.insertvalue"(%5488, %5485) <{position = array<i64: 1>}> : (!llvm.struct<packed (ptr, array<16 x i8>)>, !llvm.array<16 x i8>) -> !llvm.struct<packed (ptr, array<16 x i8>)>
  "llvm.return"(%5489) : (!llvm.struct<packed (ptr, array<16 x i8>)>) -> ()
}) : () -> ()
