module

-- build/llvm23/mlir_canonicalized/avx512/op/fd_r43x6_is_nonzero.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

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
  %227 = "llvm.mlir.constant"() <{value = -19 : i64}> : () -> i64
  %228 = "llvm.extractelement"(%arg24, %213) : (vector<8xi64>, i64) -> i64
  %229 = "llvm.extractelement"(%arg24, %214) : (vector<8xi64>, i64) -> i64
  %230 = "llvm.extractelement"(%arg24, %215) : (vector<8xi64>, i64) -> i64
  %231 = "llvm.extractelement"(%arg24, %216) : (vector<8xi64>, i64) -> i64
  %232 = "llvm.extractelement"(%arg24, %217) : (vector<8xi64>, i64) -> i64
  %233 = "llvm.extractelement"(%arg24, %218) : (vector<8xi64>, i64) -> i64
  %234 = "llvm.add"(%233, %219) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %235 = "llvm.ashr"(%234, %220) : (i64, i64) -> i64
  %236 = "llvm.and"(%234, %221) : (i64, i64) -> i64
  %237 = "llvm.mul"(%235, %222) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %238 = "llvm.add"(%237, %228) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %239 = "llvm.ashr"(%238, %223) : (i64, i64) -> i64
  %240 = "llvm.and"(%238, %224) : (i64, i64) -> i64
  %241 = "llvm.add"(%239, %229) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %242 = "llvm.ashr"(%241, %223) : (i64, i64) -> i64
  %243 = "llvm.and"(%241, %224) : (i64, i64) -> i64
  %244 = "llvm.add"(%242, %230) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %245 = "llvm.ashr"(%244, %223) : (i64, i64) -> i64
  %246 = "llvm.and"(%244, %224) : (i64, i64) -> i64
  %247 = "llvm.add"(%245, %231) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %248 = "llvm.ashr"(%247, %223) : (i64, i64) -> i64
  %249 = "llvm.and"(%247, %224) : (i64, i64) -> i64
  %250 = "llvm.add"(%248, %232) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %251 = "llvm.ashr"(%250, %223) : (i64, i64) -> i64
  %252 = "llvm.and"(%250, %224) : (i64, i64) -> i64
  %253 = "llvm.add"(%240, %222) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %254 = "llvm.lshr"(%253, %223) : (i64, i64) -> i64
  %255 = "llvm.and"(%253, %224) : (i64, i64) -> i64
  %256 = "llvm.add"(%243, %254) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %257 = "llvm.lshr"(%256, %223) : (i64, i64) -> i64
  %258 = "llvm.and"(%256, %224) : (i64, i64) -> i64
  %259 = "llvm.add"(%246, %257) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %260 = "llvm.lshr"(%259, %223) : (i64, i64) -> i64
  %261 = "llvm.and"(%259, %224) : (i64, i64) -> i64
  %262 = "llvm.add"(%249, %260) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %263 = "llvm.lshr"(%262, %223) : (i64, i64) -> i64
  %264 = "llvm.and"(%262, %224) : (i64, i64) -> i64
  %265 = "llvm.add"(%252, %263) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %266 = "llvm.lshr"(%265, %223) : (i64, i64) -> i64
  %267 = "llvm.and"(%265, %224) : (i64, i64) -> i64
  %268 = "llvm.add"(%236, %225) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %269 = "llvm.add"(%268, %251) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %270 = "llvm.add"(%269, %266) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %271 = "llvm.and"(%270, %221) : (i64, i64) -> i64
  %272 = "llvm.icmp"(%270, %226) <{predicate = 6 : i64}> : (i64, i64) -> i1
  %273 = "llvm.select"(%272, %227, %213) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %274 = "llvm.add"(%273, %255) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %275 = "llvm.ashr"(%274, %223) : (i64, i64) -> i64
  %276 = "llvm.add"(%275, %258) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %277 = "llvm.ashr"(%276, %223) : (i64, i64) -> i64
  %278 = "llvm.add"(%277, %261) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %279 = "llvm.ashr"(%278, %223) : (i64, i64) -> i64
  %280 = "llvm.add"(%279, %264) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %281 = "llvm.ashr"(%280, %223) : (i64, i64) -> i64
  %282 = "llvm.add"(%281, %267) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %283 = "llvm.ashr"(%282, %223) : (i64, i64) -> i64
  %284 = "llvm.add"(%283, %271) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
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

end

end MLIR.Firedancer.Avx512
