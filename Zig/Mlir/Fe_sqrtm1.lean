module

-- zig-build/out/mlir_canonicalized/region/Fe.sqrtm1.mlir

public import MLIR.Semantics.GlobalInitializer
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.GlobalInitializer

namespace MLIR.Zig

@[expose] public section

mlir_const_def Fe_sqrtm1 :=
{
    %0 = "llvm.mlir.constant"() <{value = dense<[1718705420411056, 234908883556509, 2233514472574048, 2117202627021982, 765476049583133]> : tensor<5xi64>}> : () -> !llvm.array<5 x i64>
    %1 = "llvm.mlir.undef"() : () -> !llvm.struct<"Fe", (array<5 x i64>)>
    %2 = "llvm.insertvalue"(%1, %0) <{position = array<i64: 0>}> : (!llvm.struct<"Fe", (array<5 x i64>)>, !llvm.array<5 x i64>) -> !llvm.struct<"Fe", (array<5 x i64>)>
    "llvm.return"(%2) : (!llvm.struct<"Fe", (array<5 x i64>)>) -> ()
}

end

end MLIR.Zig
