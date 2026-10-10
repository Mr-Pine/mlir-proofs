module

-- boringssl-build/out/op/_ZL2d2.mlir
-- d2

public import MLIR.Semantics.GlobalInitializer
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.GlobalInitializer

namespace MLIR.Boringssl

@[expose] public section

mlir_const_def d2 :=
"llvm.mlir.global"() <{addr_space = 0 : i32, alignment = 8 : i64, constant, dso_local, global_type = !llvm.struct<"struct.bssl::fe", (array<5 x i64>)>, linkage = #llvm.linkage<internal>, sym_name = "_ZL2d2", unnamed_addr = 0 : i64, visibility_ = 0 : i64}> ({
  %2044 = "llvm.mlir.constant"() <{value = dense<[1859910466990425, 932731440258426, 1072319116312658, 1815898335770999, 633789495995903]> : tensor<5xi64>}> : () -> !llvm.array<5 x i64>
  %2045 = "llvm.mlir.undef"() : () -> !llvm.struct<"struct.bssl::fe", (array<5 x i64>)>
  %2046 = "llvm.insertvalue"(%2045, %2044) <{position = array<i64: 0>}> : (!llvm.struct<"struct.bssl::fe", (array<5 x i64>)>, !llvm.array<5 x i64>) -> !llvm.struct<"struct.bssl::fe", (array<5 x i64>)>
  "llvm.return"(%2046) : (!llvm.struct<"struct.bssl::fe", (array<5 x i64>)>) -> ()
}) : () -> ()

end

end MLIR.Boringssl
