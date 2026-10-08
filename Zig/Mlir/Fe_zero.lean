module

-- zig-build/out/mlir_canonicalized/region/Fe.zero.mlir

public import SSA.Projects.RIR.Semantics.GlobalInitializer
public import SSA.Projects.RIR.Syntax.Elab

meta import SSA.Projects.RIR.Semantics.GlobalInitializer

namespace LeanMLIR.RIR.Zig

@[expose] public section

mlir_const_def Fe_zero :=
{
    %0 = "llvm.mlir.constant"() <{value = dense<0> : tensor<5xi64>}> : () -> !llvm.array<5 x i64>
    %1 = "llvm.mlir.undef"() : () -> !llvm.struct<"Fe", (array<5 x i64>)>
    %2 = "llvm.insertvalue"(%1, %0) <{position = array<i64: 0>}> : (!llvm.struct<"Fe", (array<5 x i64>)>, !llvm.array<5 x i64>) -> !llvm.struct<"Fe", (array<5 x i64>)>
    "llvm.return"(%2) : (!llvm.struct<"Fe", (array<5 x i64>)>) -> ()
}

end

end LeanMLIR.RIR.Zig
