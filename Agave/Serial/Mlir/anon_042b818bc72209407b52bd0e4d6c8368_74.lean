module

-- agave-build/out/serial-noinline/op/anon.042b818bc72209407b52bd0e4d6c8368.74.mlir

public import MLIR.Semantics.GlobalInitializer
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.GlobalInitializer

namespace MLIR.Agave.Serial

@[expose] public section

mlir_const_def anon_042b818bc72209407b52bd0e4d6c8368_74 :=
"llvm.mlir.global"() <{addr_space = 0 : i32, alignment = 8 : i64, constant, dso_local, global_type = !llvm.struct<packed (ptr, array<16 x i8>)>, linkage = #llvm.linkage<internal>, sym_name = "anon.042b818bc72209407b52bd0e4d6c8368.74", unnamed_addr = 2 : i64, visibility_ = 0 : i64}> ({
  %5717 = "llvm.mlir.constant"() <{value = "W\00\00\00\00\00\00\00\0B\01\00\00\09\00\00\00"}> : () -> !llvm.array<16 x i8>
  %5718 = "llvm.mlir.addressof"() <{global_name = @anon.042b818bc72209407b52bd0e4d6c8368.9}> : () -> !llvm.ptr
  %5719 = "llvm.mlir.undef"() : () -> !llvm.struct<packed (ptr, array<16 x i8>)>
  %5720 = "llvm.insertvalue"(%5719, %5718) <{position = array<i64: 0>}> : (!llvm.struct<packed (ptr, array<16 x i8>)>, !llvm.ptr) -> !llvm.struct<packed (ptr, array<16 x i8>)>
  %5721 = "llvm.insertvalue"(%5720, %5717) <{position = array<i64: 1>}> : (!llvm.struct<packed (ptr, array<16 x i8>)>, !llvm.array<16 x i8>) -> !llvm.struct<packed (ptr, array<16 x i8>)>
  "llvm.return"(%5721) : (!llvm.struct<packed (ptr, array<16 x i8>)>) -> ()
}) : () -> ()

end

end MLIR.Agave.Serial
