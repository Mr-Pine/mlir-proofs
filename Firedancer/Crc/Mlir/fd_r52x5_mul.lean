module

-- crc/out/mlir/recipe/mlirproofs/avx512/fd_r52x5_mul.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Firedancer.Crc

@[expose] public section

mlir_def fd_r52x5_mul :=
"llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<vector<8xi64> (vector<8xi64>, vector<8xi64>)>, linkage = #llvm.linkage<external>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], sym_name = "fd_r52x5_mul", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 0 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg46: vector<8xi64>, %arg47: vector<8xi64>):
  %199 = "llvm.mlir.constant"() <{value = dense<[19, 1, 1, 1, 1, 0, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %200 = "llvm.mlir.constant"() <{value = dense<51> : vector<8xi64>}> : () -> vector<8xi64>
  %201 = "llvm.mlir.constant"() <{value = dense<2251799813685247> : vector<8xi64>}> : () -> vector<8xi64>
  %202 = "llvm.mlir.constant"() <{value = dense<18> : vector<8xi64>}> : () -> vector<8xi64>
  %203 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %204 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %205 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %206 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %207 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %208 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %209 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %210 = "llvm.mlir.poison"() : () -> vector<8xi64>
  %211 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %212 = "llvm.mlir.constant"() <{value = dense<0> : vector<8xi64>}> : () -> vector<8xi64>
  %213 = "llvm.mlir.constant"() <{value = dense<1> : vector<8xi64>}> : () -> vector<8xi64>
  %214 = "llvm.mlir.poison"() : () -> i64
  %215 = "llvm.mlir.undef"() : () -> vector<8xi64>
  %216 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %217 = "llvm.insertelement"(%215, %214, %216) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %218 = "llvm.insertelement"(%217, %214, %209) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %219 = "llvm.insertelement"(%218, %214, %208) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %220 = "llvm.insertelement"(%219, %214, %207) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %221 = "llvm.insertelement"(%220, %211, %206) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %222 = "llvm.insertelement"(%221, %211, %205) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %223 = "llvm.insertelement"(%222, %211, %204) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %224 = "llvm.insertelement"(%223, %211, %203) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %225 = "llvm.insertelement"(%215, %214, %216) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %226 = "llvm.insertelement"(%225, %214, %209) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %227 = "llvm.insertelement"(%226, %214, %208) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %228 = "llvm.insertelement"(%227, %211, %207) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %229 = "llvm.insertelement"(%228, %211, %206) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %230 = "llvm.insertelement"(%229, %211, %205) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %231 = "llvm.insertelement"(%230, %211, %204) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %232 = "llvm.insertelement"(%231, %211, %203) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %233 = "llvm.insertelement"(%215, %214, %216) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %234 = "llvm.insertelement"(%233, %214, %209) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %235 = "llvm.insertelement"(%234, %214, %208) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %236 = "llvm.insertelement"(%235, %214, %207) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %237 = "llvm.insertelement"(%236, %214, %206) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %238 = "llvm.insertelement"(%237, %214, %205) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %239 = "llvm.insertelement"(%238, %214, %204) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %240 = "llvm.insertelement"(%239, %211, %203) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %241 = "llvm.insertelement"(%215, %214, %216) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %242 = "llvm.insertelement"(%241, %214, %209) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %243 = "llvm.insertelement"(%242, %214, %208) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %244 = "llvm.insertelement"(%243, %214, %207) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %245 = "llvm.insertelement"(%244, %214, %206) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %246 = "llvm.insertelement"(%245, %214, %205) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %247 = "llvm.insertelement"(%246, %211, %204) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %248 = "llvm.insertelement"(%247, %211, %203) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %249 = "llvm.insertelement"(%215, %214, %216) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %250 = "llvm.insertelement"(%249, %214, %209) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %251 = "llvm.insertelement"(%250, %214, %208) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %252 = "llvm.insertelement"(%251, %214, %207) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %253 = "llvm.insertelement"(%252, %214, %206) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %254 = "llvm.insertelement"(%253, %211, %205) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %255 = "llvm.insertelement"(%254, %211, %204) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %256 = "llvm.insertelement"(%255, %211, %203) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %257 = "llvm.insertelement"(%215, %211, %216) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %258 = "llvm.insertelement"(%257, %211, %209) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %259 = "llvm.insertelement"(%258, %214, %208) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %260 = "llvm.insertelement"(%259, %214, %207) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %261 = "llvm.insertelement"(%260, %214, %206) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %262 = "llvm.insertelement"(%261, %214, %205) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %263 = "llvm.insertelement"(%262, %214, %204) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %264 = "llvm.insertelement"(%263, %214, %203) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %265 = "llvm.insertelement"(%215, %211, %216) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %266 = "llvm.insertelement"(%265, %214, %209) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %267 = "llvm.insertelement"(%266, %214, %208) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %268 = "llvm.insertelement"(%267, %214, %207) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %269 = "llvm.insertelement"(%268, %214, %206) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %270 = "llvm.insertelement"(%269, %214, %205) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %271 = "llvm.insertelement"(%270, %214, %204) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %272 = "llvm.insertelement"(%271, %214, %203) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %273 = "llvm.shufflevector"(%arg46, %210) <{mask = array<i32: 3, 3, 3, 3, 3, 3, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %274 = "llvm.call_intrinsic"(%212, %arg47, %273) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %275 = "llvm.shl"(%274, %213) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %276 = "llvm.shufflevector"(%arg46, %210) <{mask = array<i32: 4, 4, 4, 4, 4, 4, 4, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %277 = "llvm.call_intrinsic"(%275, %arg47, %276) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %278 = "llvm.shufflevector"(%224, %277) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %279 = "llvm.call_intrinsic"(%212, %arg47, %276) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %280 = "llvm.shl"(%279, %213) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %281 = "llvm.shufflevector"(%232, %280) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %282 = "llvm.shufflevector"(%arg46, %210) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %283 = "llvm.call_intrinsic"(%212, %arg47, %282) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %284 = "llvm.shl"(%283, %213) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %285 = "llvm.shufflevector"(%arg46, %210) <{mask = array<i32: 1, 1, 1, 1, 1, 1, 1, 1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %286 = "llvm.call_intrinsic"(%284, %arg47, %285) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %287 = "llvm.shufflevector"(%240, %286) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %288 = "llvm.call_intrinsic"(%287, %arg47, %282) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %289 = "llvm.call_intrinsic"(%212, %arg47, %285) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %290 = "llvm.shl"(%289, %213) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %291 = "llvm.shufflevector"(%arg46, %210) <{mask = array<i32: 2, 2, 2, 2, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %292 = "llvm.call_intrinsic"(%290, %arg47, %291) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %293 = "llvm.shufflevector"(%248, %292) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %294 = "llvm.call_intrinsic"(%212, %arg47, %291) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %295 = "llvm.shl"(%294, %213) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %296 = "llvm.call_intrinsic"(%295, %arg47, %273) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %297 = "llvm.shufflevector"(%256, %296) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %298 = "llvm.add"(%281, %278) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %299 = "llvm.add"(%298, %288) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %300 = "llvm.add"(%299, %293) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %301 = "llvm.add"(%300, %297) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %302 = "llvm.shufflevector"(%301, %256) <{mask = array<i32: 0, 1, 2, 3, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %303 = "llvm.shufflevector"(%280, %210) <{mask = array<i32: 3, 4, 5, 6, 7, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %304 = "llvm.shufflevector"(%296, %264) <{mask = array<i32: 5, 6, 7, 8, 9, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %305 = "llvm.shufflevector"(%277, %272) <{mask = array<i32: 4, 5, 6, 7, 8, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %306 = "llvm.add"(%303, %305) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %307 = "llvm.add"(%306, %304) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %308 = "llvm.shufflevector"(%301, %307) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %309 = "llvm.add"(%308, %302) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %310 = "llvm.mul"(%308, %202) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %311 = "llvm.add"(%309, %310) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %312 = "llvm.and"(%311, %201) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %313 = "llvm.lshr"(%311, %200) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %314 = "llvm.shufflevector"(%313, %210) <{mask = array<i32: 4, 0, 1, 2, 3, 5, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %315 = "llvm.call_intrinsic"(%312, %314, %199) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.return"(%315) : (vector<8xi64>) -> ()
}) : () -> ()

end

end MLIR.Firedancer.Crc
