module

-- zig-build/out/mlir_canonicalized/region/scalar.field_order_s.mlir

public import SSA.Projects.RIR.Semantics.GlobalInitializer
public import SSA.Projects.RIR.Syntax.Elab

meta import SSA.Projects.RIR.Semantics.GlobalInitializer

namespace LeanMLIR.RIR.Zig

@[expose] public section

mlir_const_def scalar_field_order_s :=
{
    %0 = "llvm.mlir.constant"() <{value = dense<[237, 211, 245, 92, 26, 99, 18, 88, 214, 156, 247, 162, 222, 249, 222, 20, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 16]> : tensor<32xi8>}> : () -> !llvm.array<32 x i8>
    "llvm.return"(%0) : (!llvm.array<32 x i8>) -> ()
}

end

end LeanMLIR.RIR.Zig
