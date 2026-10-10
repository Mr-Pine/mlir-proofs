module

-- agave-build/out/avx2-noinline/op/anon.e79fcfe266c5706188f989b4d452749f.25.mlir

public import MLIR.Semantics.GlobalInitializer
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.GlobalInitializer

namespace MLIR.Agave.Avx2

@[expose] public section

mlir_const_def anon_e79fcfe266c5706188f989b4d452749f_25 :=
"llvm.mlir.global"() <{addr_space = 0 : i32, alignment = 8 : i64, constant, dso_local, global_type = !llvm.struct<packed (ptr, array<16 x i8>)>, linkage = #llvm.linkage<internal>, sym_name = "anon.e79fcfe266c5706188f989b4d452749f.25", unnamed_addr = 2 : i64, visibility_ = 0 : i64}> ({
  %4824 = "llvm.mlir.constant"() <{value = "W\00\00\00\00\00\00\00\DD\00\00\00\09\00\00\00"}> : () -> !llvm.array<16 x i8>
  %4825 = "llvm.mlir.addressof"() <{global_name = @anon.e79fcfe266c5706188f989b4d452749f.24}> : () -> !llvm.ptr
  %4826 = "llvm.mlir.undef"() : () -> !llvm.struct<packed (ptr, array<16 x i8>)>
  %4827 = "llvm.insertvalue"(%4826, %4825) <{position = array<i64: 0>}> : (!llvm.struct<packed (ptr, array<16 x i8>)>, !llvm.ptr) -> !llvm.struct<packed (ptr, array<16 x i8>)>
  %4828 = "llvm.insertvalue"(%4827, %4824) <{position = array<i64: 1>}> : (!llvm.struct<packed (ptr, array<16 x i8>)>, !llvm.array<16 x i8>) -> !llvm.struct<packed (ptr, array<16 x i8>)>
  "llvm.return"(%4828) : (!llvm.struct<packed (ptr, array<16 x i8>)>) -> ()
}) : () -> ()

end

end MLIR.Agave.Avx2
