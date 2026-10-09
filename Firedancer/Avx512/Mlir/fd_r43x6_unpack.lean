module

-- build/llvm23/mlir_canonicalized/avx512/op/fd_r43x6_unpack.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Firedancer.Avx512

@[expose] public section

mlir_def fd_r43x6_unpack :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.noundef}], dso_local, function_type = !llvm.func<vector<8xi64> (vector<4xi64>)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], res_attrs = [{llvm.range = #llvm.constant_range<i64, 0, 8796093022208>}], sym_name = "fd_r43x6_unpack", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg25: vector<4xi64>):
  %293 = "llvm.mlir.poison"() : () -> vector<4xi64>
  %294 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %295 = "llvm.mlir.constant"() <{value = 7 : i64}> : () -> i64
  %296 = "llvm.mlir.poison"() : () -> vector<64xi8>
  %297 = "llvm.mlir.constant"() <{value = dense<[0, 3, 6, 1, 4, 7, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %298 = "llvm.mlir.constant"() <{value = dense<8796093022207> : vector<8xi64>}> : () -> vector<8xi64>
  %299 = "llvm.shufflevector"(%arg25, %293) <{mask = array<i32: 0, 1, 2, 3, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %300 = "llvm.insertelement"(%299, %294, %295) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %301 = "llvm.bitcast"(%300) : (vector<8xi64>) -> vector<64xi8>
  %302 = "llvm.shufflevector"(%301, %296) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 63, 63, 5, 6, 7, 8, 9, 10, 63, 63, 10, 11, 12, 13, 14, 15, 16, 63, 16, 17, 18, 19, 20, 21, 63, 63, 21, 22, 23, 24, 25, 26, 63, 63, 26, 27, 28, 29, 30, 31, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %303 = "llvm.bitcast"(%302) : (vector<64xi8>) -> vector<8xi64>
  %304 = "llvm.lshr"(%303, %297) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %305 = "llvm.and"(%304, %298) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.return"(%305) : (vector<8xi64>) -> ()
}) : () -> ()

end

end MLIR.Firedancer.Avx512
