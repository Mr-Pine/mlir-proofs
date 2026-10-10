module

-- zig-build/out/op/Fe.edwards25519d.mlir

public import MLIR.Semantics.GlobalInitializer
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.GlobalInitializer

namespace MLIR.Zig

@[expose] public section

mlir_const_def Fe_edwards25519d :=
"llvm.mlir.global"() <{addr_space = 0 : i32, alignment = 8 : i64, constant, dso_local, global_type = !llvm.struct<"Fe", (array<5 x i64>)>, linkage = #llvm.linkage<private>, sym_name = "Fe.edwards25519d", unnamed_addr = 2 : i64, visibility_ = 0 : i64}> ({
  %4041 = "llvm.mlir.constant"() <{value = dense<[929955233495203, 466365720129213, 1662059464998953, 2033849074728123, 1442794654840575]> : tensor<5xi64>}> : () -> !llvm.array<5 x i64>
  %4042 = "llvm.mlir.undef"() : () -> !llvm.struct<"Fe", (array<5 x i64>)>
  %4043 = "llvm.insertvalue"(%4042, %4041) <{position = array<i64: 0>}> : (!llvm.struct<"Fe", (array<5 x i64>)>, !llvm.array<5 x i64>) -> !llvm.struct<"Fe", (array<5 x i64>)>
  "llvm.return"(%4043) : (!llvm.struct<"Fe", (array<5 x i64>)>) -> ()
}) : () -> ()

end

end MLIR.Zig
