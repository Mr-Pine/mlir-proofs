module

-- zig-build/out/mlir_canonicalized/region/Sha512.iv.mlir

public import SSA.Projects.RIR.Semantics.GlobalInitializer
public import SSA.Projects.RIR.Syntax.Elab

meta import SSA.Projects.RIR.Semantics.GlobalInitializer

namespace LeanMLIR.RIR.Zig

@[expose] public section

mlir_const_def Sha512_iv :=
{
    %0 = "llvm.mlir.constant"() <{value = dense<0> : tensor<15xi8>}> : () -> !llvm.array<15 x i8>
    %1 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
    %2 = "llvm.mlir.constant"() <{value = dense<0> : tensor<128xi8>}> : () -> !llvm.array<128 x i8>
    %3 = "llvm.mlir.constant"() <{value = dense<[7640891576956012808, -4942790177534073029, 4354685564936845355, -6534734903238641935, 5840696475078001361, -7276294671716946913, 2270897969802886507, 6620516959819538809]> : tensor<8xi64>}> : () -> !llvm.array<8 x i64>
    %4 = "llvm.mlir.constant"() <{value = 0 : i128}> : () -> i128
    %5 = "llvm.mlir.undef"() : () -> !llvm.struct<"Sha512", (i128, array<8 x i64>, array<128 x i8>, i8, array<15 x i8>)>
    %6 = "llvm.insertvalue"(%5, %4) <{position = array<i64: 0>}> : (!llvm.struct<"Sha512", (i128, array<8 x i64>, array<128 x i8>, i8, array<15 x i8>)>, i128) -> !llvm.struct<"Sha512", (i128, array<8 x i64>, array<128 x i8>, i8, array<15 x i8>)>
    %7 = "llvm.insertvalue"(%6, %3) <{position = array<i64: 1>}> : (!llvm.struct<"Sha512", (i128, array<8 x i64>, array<128 x i8>, i8, array<15 x i8>)>, !llvm.array<8 x i64>) -> !llvm.struct<"Sha512", (i128, array<8 x i64>, array<128 x i8>, i8, array<15 x i8>)>
    %8 = "llvm.insertvalue"(%7, %2) <{position = array<i64: 2>}> : (!llvm.struct<"Sha512", (i128, array<8 x i64>, array<128 x i8>, i8, array<15 x i8>)>, !llvm.array<128 x i8>) -> !llvm.struct<"Sha512", (i128, array<8 x i64>, array<128 x i8>, i8, array<15 x i8>)>
    %9 = "llvm.insertvalue"(%8, %1) <{position = array<i64: 3>}> : (!llvm.struct<"Sha512", (i128, array<8 x i64>, array<128 x i8>, i8, array<15 x i8>)>, i8) -> !llvm.struct<"Sha512", (i128, array<8 x i64>, array<128 x i8>, i8, array<15 x i8>)>
    %10 = "llvm.insertvalue"(%9, %0) <{position = array<i64: 4>}> : (!llvm.struct<"Sha512", (i128, array<8 x i64>, array<128 x i8>, i8, array<15 x i8>)>, !llvm.array<15 x i8>) -> !llvm.struct<"Sha512", (i128, array<8 x i64>, array<128 x i8>, i8, array<15 x i8>)>
    "llvm.return"(%10) : (!llvm.struct<"Sha512", (i128, array<8 x i64>, array<128 x i8>, i8, array<15 x i8>)>) -> ()
}

end

end LeanMLIR.RIR.Zig
