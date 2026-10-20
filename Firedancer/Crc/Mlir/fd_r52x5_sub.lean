module

-- crc/out/mlir/recipe/mlirproofs/avx512/fd_r52x5_sub.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Firedancer.Crc

@[expose] public section

mlir_def fd_r52x5_sub :=
"llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<vector<8xi64> (vector<8xi64>, vector<8xi64>)>, linkage = #llvm.linkage<external>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], sym_name = "fd_r52x5_sub", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 0 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg41: vector<8xi64>, %arg42: vector<8xi64>):
  %62 = "llvm.mlir.constant"() <{value = dense<[36028797018963664, 36028797018963952, 36028797018963952, 36028797018963952, 36028797018963952, 0, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %63 = "llvm.mlir.constant"() <{value = dense<2251799813685247> : vector<8xi64>}> : () -> vector<8xi64>
  %64 = "llvm.mlir.constant"() <{value = dense<51> : vector<8xi64>}> : () -> vector<8xi64>
  %65 = "llvm.mlir.poison"() : () -> vector<8xi64>
  %66 = "llvm.mlir.constant"() <{value = dense<[19, 1, 1, 1, 1, 0, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %67 = "llvm.sub"(%arg41, %arg42) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %68 = "llvm.add"(%67, %62) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %69 = "llvm.and"(%68, %63) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %70 = "llvm.lshr"(%68, %64) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %71 = "llvm.shufflevector"(%70, %65) <{mask = array<i32: 4, 0, 1, 2, 3, 5, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %72 = "llvm.call_intrinsic"(%69, %71, %66) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.return"(%72) : (vector<8xi64>) -> ()
}) : () -> ()

end

end MLIR.Firedancer.Crc
