module

-- zig-build/out/mlir_canonicalized/region/Fe.edwards25519d.mlir

public import SSA.Projects.RIR.Semantics.GlobalInitializer
public import SSA.Projects.RIR.Syntax.Elab

meta import SSA.Projects.RIR.Semantics.GlobalInitializer

namespace LeanMLIR.RIR.Zig

@[expose] public section

mlir_const_def Fe_edwards25519d :=
{
    %0 = "llvm.mlir.constant"() <{value = dense<[929955233495203, 466365720129213, 1662059464998953, 2033849074728123, 1442794654840575]> : tensor<5xi64>}> : () -> !llvm.array<5 x i64>
    %1 = "llvm.mlir.undef"() : () -> !llvm.struct<"Fe", (array<5 x i64>)>
    %2 = "llvm.insertvalue"(%1, %0) <{position = array<i64: 0>}> : (!llvm.struct<"Fe", (array<5 x i64>)>, !llvm.array<5 x i64>) -> !llvm.struct<"Fe", (array<5 x i64>)>
    "llvm.return"(%2) : (!llvm.struct<"Fe", (array<5 x i64>)>) -> ()
}

end

end LeanMLIR.RIR.Zig
