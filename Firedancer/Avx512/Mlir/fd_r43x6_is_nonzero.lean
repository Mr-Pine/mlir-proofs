module

-- build/llvm23/mlir_canonicalized/avx512/op/fd_r43x6_is_nonzero.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Avx512.Mlir.fd_long_if

meta import MLIR.Semantics.Func
meta import Firedancer.Avx512.Mlir.fd_long_if

namespace MLIR.Firedancer.Avx512

@[expose] public section

mlir_def fd_r43x6_is_nonzero :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.noundef}], dso_local, function_type = !llvm.func<i32 (vector<8xi64>)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], res_attrs = [{llvm.range = #llvm.constant_range<i32, 0, 2>}], sym_name = "fd_r43x6_is_nonzero", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg24: vector<8xi64>):
  %213 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %214 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %215 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %216 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %217 = "llvm.mlir.constant"() <{value = 4 : i64}> : () -> i64
  %218 = "llvm.mlir.constant"() <{value = 5 : i64}> : () -> i64
  %219 = "llvm.mlir.constant"() <{value = -1048576 : i64}> : () -> i64
  %220 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
  %221 = "llvm.mlir.constant"() <{value = 1099511627775 : i64}> : () -> i64
  %222 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %223 = "llvm.mlir.constant"() <{value = 43 : i64}> : () -> i64
  %224 = "llvm.mlir.constant"() <{value = 8796093022207 : i64}> : () -> i64
  %225 = "llvm.mlir.constant"() <{value = 1048576 : i64}> : () -> i64
  %226 = "llvm.mlir.constant"() <{value = 1099511627776 : i64}> : () -> i64
  %227 = "llvm.extractelement"(%arg24, %213) : (vector<8xi64>, i64) -> i64
  %228 = "llvm.extractelement"(%arg24, %214) : (vector<8xi64>, i64) -> i64
  %229 = "llvm.extractelement"(%arg24, %215) : (vector<8xi64>, i64) -> i64
  %230 = "llvm.extractelement"(%arg24, %216) : (vector<8xi64>, i64) -> i64
  %231 = "llvm.extractelement"(%arg24, %217) : (vector<8xi64>, i64) -> i64
  %232 = "llvm.extractelement"(%arg24, %218) : (vector<8xi64>, i64) -> i64
  %233 = "llvm.add"(%232, %219) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %234 = "llvm.ashr"(%233, %220) : (i64, i64) -> i64
  %235 = "llvm.and"(%233, %221) : (i64, i64) -> i64
  %236 = "llvm.mul"(%234, %222) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %237 = "llvm.add"(%236, %227) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %238 = "llvm.ashr"(%237, %223) : (i64, i64) -> i64
  %239 = "llvm.and"(%237, %224) : (i64, i64) -> i64
  %240 = "llvm.add"(%238, %228) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %241 = "llvm.ashr"(%240, %223) : (i64, i64) -> i64
  %242 = "llvm.and"(%240, %224) : (i64, i64) -> i64
  %243 = "llvm.add"(%241, %229) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %244 = "llvm.ashr"(%243, %223) : (i64, i64) -> i64
  %245 = "llvm.and"(%243, %224) : (i64, i64) -> i64
  %246 = "llvm.add"(%244, %230) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %247 = "llvm.ashr"(%246, %223) : (i64, i64) -> i64
  %248 = "llvm.and"(%246, %224) : (i64, i64) -> i64
  %249 = "llvm.add"(%247, %231) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %250 = "llvm.ashr"(%249, %223) : (i64, i64) -> i64
  %251 = "llvm.and"(%249, %224) : (i64, i64) -> i64
  %252 = "llvm.add"(%239, %222) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %253 = "llvm.lshr"(%252, %223) : (i64, i64) -> i64
  %254 = "llvm.and"(%252, %224) : (i64, i64) -> i64
  %255 = "llvm.add"(%242, %253) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %256 = "llvm.lshr"(%255, %223) : (i64, i64) -> i64
  %257 = "llvm.and"(%255, %224) : (i64, i64) -> i64
  %258 = "llvm.add"(%245, %256) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %259 = "llvm.lshr"(%258, %223) : (i64, i64) -> i64
  %260 = "llvm.and"(%258, %224) : (i64, i64) -> i64
  %261 = "llvm.add"(%248, %259) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %262 = "llvm.lshr"(%261, %223) : (i64, i64) -> i64
  %263 = "llvm.and"(%261, %224) : (i64, i64) -> i64
  %264 = "llvm.add"(%251, %262) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %265 = "llvm.lshr"(%264, %223) : (i64, i64) -> i64
  %266 = "llvm.and"(%264, %224) : (i64, i64) -> i64
  %267 = "llvm.add"(%235, %225) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %268 = "llvm.add"(%267, %250) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %269 = "llvm.add"(%268, %265) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %270 = "llvm.and"(%269, %221) : (i64, i64) -> i64
  %271 = "llvm.icmp"(%269, %226) <{predicate = 6 : i64}> : (i64, i64) -> i1
  %272 = "llvm.zext"(%271) : (i1) -> i32
  %273 = "llvm.call"(%272) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_long_if, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (i32) -> i64
  %274 = "llvm.sub"(%254, %273) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %275 = "llvm.ashr"(%274, %223) : (i64, i64) -> i64
  %276 = "llvm.add"(%275, %257) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %277 = "llvm.ashr"(%276, %223) : (i64, i64) -> i64
  %278 = "llvm.add"(%277, %260) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %279 = "llvm.ashr"(%278, %223) : (i64, i64) -> i64
  %280 = "llvm.add"(%279, %263) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %281 = "llvm.ashr"(%280, %223) : (i64, i64) -> i64
  %282 = "llvm.add"(%281, %266) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %283 = "llvm.ashr"(%282, %223) : (i64, i64) -> i64
  %284 = "llvm.add"(%283, %270) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %285 = "llvm.or"(%276, %274) : (i64, i64) -> i64
  %286 = "llvm.or"(%285, %278) : (i64, i64) -> i64
  %287 = "llvm.or"(%286, %280) : (i64, i64) -> i64
  %288 = "llvm.or"(%287, %282) : (i64, i64) -> i64
  %289 = "llvm.and"(%288, %224) : (i64, i64) -> i64
  %290 = "llvm.or"(%289, %284) : (i64, i64) -> i64
  %291 = "llvm.icmp"(%290, %213) <{predicate = 1 : i64}> : (i64, i64) -> i1
  %292 = "llvm.zext"(%291) : (i1) -> i32
  "llvm.return"(%292) : (i32) -> ()
}) : () -> ()
  with @fd_long_if := fd_long_if

end

end MLIR.Firedancer.Avx512
