module

-- ~/fd-pr9879/build/llvm23-production/mlir_canonicalized/avx512/op/wc_bcast_wide.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Firedancer.R52x5

@[expose] public section

mlir_def wc_bcast_wide :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.noundef, llvm.range = #llvm.constant_range<i32, 0, 2>}, {llvm.noundef, llvm.range = #llvm.constant_range<i32, 0, 2>}, {llvm.noundef, llvm.range = #llvm.constant_range<i32, 0, 2>}, {llvm.noundef, llvm.range = #llvm.constant_range<i32, 0, 2>}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<vector<4xi64> (i32, i32, i32, i32)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "256"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], sym_name = "wc_bcast_wide", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg114: i32, %arg115: i32, %arg116: i32, %arg117: i32):
  %3220 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %3221 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %3222 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %3223 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %3224 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %3225 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %3226 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %3227 = "llvm.mlir.poison"() : () -> vector<8xi32>
  %3228 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %3229 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %3230 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %3231 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %3232 = "llvm.mlir.poison"() : () -> i32
  %3233 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %3234 = "llvm.mlir.undef"() : () -> vector<8xi32>
  %3235 = "llvm.insertelement"(%3234, %3233, %3233) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %3236 = "llvm.insertelement"(%3235, %3233, %3226) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %3237 = "llvm.insertelement"(%3236, %3233, %3225) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %3238 = "llvm.insertelement"(%3237, %3233, %3224) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %3239 = "llvm.insertelement"(%3238, %3232, %3223) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %3240 = "llvm.insertelement"(%3239, %3232, %3222) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %3241 = "llvm.insertelement"(%3240, %3232, %3221) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %3242 = "llvm.insertelement"(%3241, %3232, %3220) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %3243 = "llvm.insertelement"(%3227, %arg114, %3228) : (vector<8xi32>, i32, i64) -> vector<8xi32>
  %3244 = "llvm.insertelement"(%3243, %arg115, %3229) : (vector<8xi32>, i32, i64) -> vector<8xi32>
  %3245 = "llvm.insertelement"(%3244, %arg116, %3230) : (vector<8xi32>, i32, i64) -> vector<8xi32>
  %3246 = "llvm.insertelement"(%3245, %arg117, %3231) : (vector<8xi32>, i32, i64) -> vector<8xi32>
  %3247 = "llvm.sub"(%3242, %3246) <{overflowFlags = 1 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %3248 = "llvm.shufflevector"(%3247, %3227) <{mask = array<i32: 0, 0, 1, 1, 2, 2, 3, 3>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %3249 = "llvm.bitcast"(%3248) : (vector<8xi32>) -> vector<4xi64>
  "llvm.return"(%3249) : (vector<4xi64>) -> ()
}) : () -> ()

end

end MLIR.Firedancer.R52x5
