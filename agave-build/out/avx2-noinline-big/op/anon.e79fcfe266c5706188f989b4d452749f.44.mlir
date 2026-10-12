"llvm.mlir.global"() <{addr_space = 0 : i32, alignment = 8 : i64, constant, dso_local, global_type = !llvm.struct<packed (ptr, array<16 x i8>)>, linkage = #llvm.linkage<internal>, sym_name = "anon.e79fcfe266c5706188f989b4d452749f.44", unnamed_addr = 2 : i64, visibility_ = 0 : i64}> ({
  %4515 = "llvm.mlir.constant"() <{value = "S\00\00\00\00\00\00\00\DF\00\00\00\1B\00\00\00"}> : () -> !llvm.array<16 x i8>
  %4516 = "llvm.mlir.addressof"() <{global_name = @anon.e79fcfe266c5706188f989b4d452749f.0}> : () -> !llvm.ptr
  %4517 = "llvm.mlir.undef"() : () -> !llvm.struct<packed (ptr, array<16 x i8>)>
  %4518 = "llvm.insertvalue"(%4517, %4516) <{position = array<i64: 0>}> : (!llvm.struct<packed (ptr, array<16 x i8>)>, !llvm.ptr) -> !llvm.struct<packed (ptr, array<16 x i8>)>
  %4519 = "llvm.insertvalue"(%4518, %4515) <{position = array<i64: 1>}> : (!llvm.struct<packed (ptr, array<16 x i8>)>, !llvm.array<16 x i8>) -> !llvm.struct<packed (ptr, array<16 x i8>)>
  "llvm.return"(%4519) : (!llvm.struct<packed (ptr, array<16 x i8>)>) -> ()
}) : () -> ()
