module

-- zig-build/out/mlir_canonicalized/region/Fe.edwards25519d2.mlir

public import MLIR.Semantics.GlobalInitializer
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.GlobalInitializer

namespace MLIR.Zig

@[expose] public section

mlir_const_def Fe_edwards25519d2 :=
{
    %0 = "llvm.mlir.constant"() <{value = dense<[1859910466990425, 932731440258426, 1072319116312658, 1815898335770999, 633789495995903]> : tensor<5xi64>}> : () -> !llvm.array<5 x i64>
    %1 = "llvm.mlir.undef"() : () -> !llvm.struct<"Fe", (array<5 x i64>)>
    %2 = "llvm.insertvalue"(%1, %0) <{position = array<i64: 0>}> : (!llvm.struct<"Fe", (array<5 x i64>)>, !llvm.array<5 x i64>) -> !llvm.struct<"Fe", (array<5 x i64>)>
    "llvm.return"(%2) : (!llvm.struct<"Fe", (array<5 x i64>)>) -> ()
}

end

end MLIR.Zig
