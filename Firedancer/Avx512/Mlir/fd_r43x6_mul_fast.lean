module

-- build/llvm23/mlir_canonicalized/avx512/op/fd_r43x6_mul_fast.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Firedancer.Avx512

@[expose] public section

mlir_def fd_r43x6_mul_fast :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], dso_local, function_type = !llvm.func<vector<8xi64> (vector<8xi64>, vector<8xi64>)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], sym_name = "fd_r43x6_mul_fast", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg26: vector<8xi64>, %arg27: vector<8xi64>):
  %306 = "llvm.mlir.constant"() <{value = dense<24> : vector<8xi64>}> : () -> vector<8xi64>
  %307 = "llvm.mlir.constant"() <{value = dense<7> : vector<8xi64>}> : () -> vector<8xi64>
  %308 = "llvm.mlir.constant"() <{value = dense<[-1, -1, -1, -1, -1, -1, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %309 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %310 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %311 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %312 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %313 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %314 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %315 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %316 = "llvm.mlir.poison"() : () -> vector<8xi64>
  %317 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %318 = "llvm.mlir.constant"() <{value = dense<0> : vector<8xi64>}> : () -> vector<8xi64>
  %319 = "llvm.mlir.constant"() <{value = dense<9> : vector<8xi64>}> : () -> vector<8xi64>
  %320 = "llvm.mlir.poison"() : () -> i64
  %321 = "llvm.mlir.undef"() : () -> vector<8xi64>
  %322 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %323 = "llvm.insertelement"(%321, %320, %322) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %324 = "llvm.insertelement"(%323, %320, %315) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %325 = "llvm.insertelement"(%324, %320, %314) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %326 = "llvm.insertelement"(%325, %320, %313) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %327 = "llvm.insertelement"(%326, %320, %312) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %328 = "llvm.insertelement"(%327, %320, %311) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %329 = "llvm.insertelement"(%328, %320, %310) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %330 = "llvm.insertelement"(%329, %317, %309) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %331 = "llvm.insertelement"(%321, %320, %322) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %332 = "llvm.insertelement"(%331, %320, %315) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %333 = "llvm.insertelement"(%332, %320, %314) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %334 = "llvm.insertelement"(%333, %320, %313) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %335 = "llvm.insertelement"(%334, %320, %312) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %336 = "llvm.insertelement"(%335, %320, %311) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %337 = "llvm.insertelement"(%336, %317, %310) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %338 = "llvm.insertelement"(%337, %317, %309) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %339 = "llvm.insertelement"(%321, %320, %322) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %340 = "llvm.insertelement"(%339, %320, %315) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %341 = "llvm.insertelement"(%340, %320, %314) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %342 = "llvm.insertelement"(%341, %320, %313) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %343 = "llvm.insertelement"(%342, %320, %312) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %344 = "llvm.insertelement"(%343, %317, %311) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %345 = "llvm.insertelement"(%344, %317, %310) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %346 = "llvm.insertelement"(%345, %317, %309) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %347 = "llvm.insertelement"(%321, %317, %322) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %348 = "llvm.insertelement"(%347, %317, %315) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %349 = "llvm.insertelement"(%348, %317, %314) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %350 = "llvm.insertelement"(%349, %320, %313) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %351 = "llvm.insertelement"(%350, %320, %312) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %352 = "llvm.insertelement"(%351, %320, %311) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %353 = "llvm.insertelement"(%352, %320, %310) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %354 = "llvm.insertelement"(%353, %320, %309) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %355 = "llvm.insertelement"(%321, %320, %322) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %356 = "llvm.insertelement"(%355, %320, %315) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %357 = "llvm.insertelement"(%356, %320, %314) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %358 = "llvm.insertelement"(%357, %320, %313) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %359 = "llvm.insertelement"(%358, %317, %312) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %360 = "llvm.insertelement"(%359, %317, %311) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %361 = "llvm.insertelement"(%360, %317, %310) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %362 = "llvm.insertelement"(%361, %317, %309) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %363 = "llvm.insertelement"(%321, %317, %322) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %364 = "llvm.insertelement"(%363, %317, %315) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %365 = "llvm.insertelement"(%364, %320, %314) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %366 = "llvm.insertelement"(%365, %320, %313) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %367 = "llvm.insertelement"(%366, %320, %312) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %368 = "llvm.insertelement"(%367, %320, %311) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %369 = "llvm.insertelement"(%368, %320, %310) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %370 = "llvm.insertelement"(%369, %320, %309) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %371 = "llvm.insertelement"(%321, %320, %322) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %372 = "llvm.insertelement"(%371, %320, %315) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %373 = "llvm.insertelement"(%372, %320, %314) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %374 = "llvm.insertelement"(%373, %317, %313) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %375 = "llvm.insertelement"(%374, %317, %312) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %376 = "llvm.insertelement"(%375, %317, %311) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %377 = "llvm.insertelement"(%376, %317, %310) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %378 = "llvm.insertelement"(%377, %317, %309) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %379 = "llvm.insertelement"(%321, %317, %322) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %380 = "llvm.insertelement"(%379, %320, %315) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %381 = "llvm.insertelement"(%380, %320, %314) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %382 = "llvm.insertelement"(%381, %320, %313) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %383 = "llvm.insertelement"(%382, %320, %312) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %384 = "llvm.insertelement"(%383, %320, %311) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %385 = "llvm.insertelement"(%384, %320, %310) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %386 = "llvm.insertelement"(%385, %320, %309) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %387 = "llvm.insertelement"(%321, %320, %322) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %388 = "llvm.insertelement"(%387, %320, %315) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %389 = "llvm.insertelement"(%388, %317, %314) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %390 = "llvm.insertelement"(%389, %317, %313) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %391 = "llvm.insertelement"(%390, %317, %312) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %392 = "llvm.insertelement"(%391, %317, %311) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %393 = "llvm.insertelement"(%392, %317, %310) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %394 = "llvm.insertelement"(%393, %317, %309) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %395 = "llvm.shufflevector"(%arg26, %316) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %396 = "llvm.shufflevector"(%arg26, %316) <{mask = array<i32: 1, 1, 1, 1, 1, 1, 1, 1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %397 = "llvm.shufflevector"(%arg26, %316) <{mask = array<i32: 2, 2, 2, 2, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %398 = "llvm.shufflevector"(%arg26, %316) <{mask = array<i32: 3, 3, 3, 3, 3, 3, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %399 = "llvm.shufflevector"(%arg26, %316) <{mask = array<i32: 4, 4, 4, 4, 4, 4, 4, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %400 = "llvm.shufflevector"(%arg26, %316) <{mask = array<i32: 5, 5, 5, 5, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %401 = "llvm.call_intrinsic"(%318, %395, %arg27) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %402 = "llvm.shl"(%401, %319) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %403 = "llvm.call_intrinsic"(%402, %396, %arg27) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %404 = "llvm.call_intrinsic"(%318, %396, %arg27) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %405 = "llvm.shl"(%404, %319) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %406 = "llvm.call_intrinsic"(%405, %397, %arg27) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %407 = "llvm.call_intrinsic"(%318, %397, %arg27) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %408 = "llvm.shl"(%407, %319) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %409 = "llvm.call_intrinsic"(%408, %398, %arg27) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %410 = "llvm.call_intrinsic"(%318, %398, %arg27) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %411 = "llvm.shl"(%410, %319) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %412 = "llvm.call_intrinsic"(%411, %399, %arg27) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %413 = "llvm.call_intrinsic"(%318, %399, %arg27) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %414 = "llvm.shl"(%413, %319) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %415 = "llvm.call_intrinsic"(%414, %400, %arg27) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %416 = "llvm.call_intrinsic"(%318, %400, %arg27) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %417 = "llvm.shl"(%416, %319) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %418 = "llvm.shufflevector"(%330, %403) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %419 = "llvm.shufflevector"(%338, %406) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %420 = "llvm.shufflevector"(%346, %409) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %421 = "llvm.shufflevector"(%409, %354) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %422 = "llvm.shufflevector"(%362, %412) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %423 = "llvm.shufflevector"(%412, %370) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %424 = "llvm.shufflevector"(%378, %415) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %425 = "llvm.shufflevector"(%415, %386) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %426 = "llvm.shufflevector"(%394, %417) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %427 = "llvm.shufflevector"(%417, %316) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %428 = "llvm.call_intrinsic"(%418, %395, %arg27) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %429 = "llvm.add"(%420, %419) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %430 = "llvm.add"(%429, %422) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %431 = "llvm.add"(%430, %424) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %432 = "llvm.add"(%431, %428) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %433 = "llvm.add"(%432, %426) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %434 = "llvm.add"(%423, %421) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %435 = "llvm.add"(%434, %425) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %436 = "llvm.add"(%435, %427) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %437 = "llvm.and"(%433, %308) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %438 = "llvm.shufflevector"(%433, %436) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %439 = "llvm.shl"(%438, %307) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %440 = "llvm.add"(%439, %437) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %441 = "llvm.mul"(%438, %306) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %442 = "llvm.add"(%440, %441) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.return"(%442) : (vector<8xi64>) -> ()
}) : () -> ()

end

end MLIR.Firedancer.Avx512
