module

-- build/native/gcc/mlir_canonicalized/avx512/region/fd_r43x6_unpack.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Firedancer.Avx512

@[expose] public section

mlir_def fd_r43x6_unpack :=
{
  ^bb0(%arg0: vector<4xi64>):
    %0 = "llvm.mlir.constant"() <{value = dense<8796093022207> : vector<8xi64>}> : () -> vector<8xi64>
    %1 = "llvm.mlir.constant"() <{value = dense<[0, 3, 6, 1, 4, 7, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
    %2 = "llvm.mlir.constant"() <{value = 7 : i64}> : () -> i64
    %3 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
    %4 = "llvm.mlir.poison"() : () -> vector<4xi64>
    %5 = "llvm.mlir.poison"() : () -> vector<64xi8>
    %6 = "llvm.shufflevector"(%arg0, %4) <{mask = array<i32: 0, 1, 2, 3, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
    %7 = "llvm.insertelement"(%6, %3, %2) : (vector<8xi64>, i64, i64) -> vector<8xi64>
    %8 = "llvm.bitcast"(%7) : (vector<8xi64>) -> vector<64xi8>
    %9 = "llvm.shufflevector"(%8, %5) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 63, 63, 5, 6, 7, 8, 9, 10, 63, 63, 10, 11, 12, 13, 14, 15, 16, 63, 16, 17, 18, 19, 20, 21, 63, 63, 21, 22, 23, 24, 25, 26, 63, 63, 26, 27, 28, 29, 30, 31, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
    %10 = "llvm.bitcast"(%9) : (vector<64xi8>) -> vector<8xi64>
    %11 = "llvm.lshr"(%10, %1) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
    %12 = "llvm.and"(%11, %0) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
    "llvm.return"(%12) : (vector<8xi64>) -> ()
}

end

end MLIR.Firedancer.Avx512
