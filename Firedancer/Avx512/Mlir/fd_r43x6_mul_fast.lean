module

-- build/llvm23/mlir_canonicalized/avx512/op/fd_r43x6_mul_fast.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Firedancer.Avx512

@[expose] public section

mlir_def fd_r43x6_mul_fast :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], dso_local, function_type = !llvm.func<vector<8xi64> (vector<8xi64>, vector<8xi64>)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], sym_name = "fd_r43x6_mul_fast", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg27: vector<8xi64>, %arg28: vector<8xi64>):
  %311 = "llvm.mlir.constant"() <{value = dense<24> : vector<8xi64>}> : () -> vector<8xi64>
  %312 = "llvm.mlir.constant"() <{value = dense<7> : vector<8xi64>}> : () -> vector<8xi64>
  %313 = "llvm.mlir.constant"() <{value = dense<[-1, -1, -1, -1, -1, -1, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %314 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %315 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %316 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %317 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %318 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %319 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %320 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %321 = "llvm.mlir.poison"() : () -> vector<8xi64>
  %322 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %323 = "llvm.mlir.constant"() <{value = dense<0> : vector<8xi64>}> : () -> vector<8xi64>
  %324 = "llvm.mlir.constant"() <{value = dense<9> : vector<8xi64>}> : () -> vector<8xi64>
  %325 = "llvm.mlir.poison"() : () -> i64
  %326 = "llvm.mlir.undef"() : () -> vector<8xi64>
  %327 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %328 = "llvm.insertelement"(%326, %325, %327) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %329 = "llvm.insertelement"(%328, %325, %320) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %330 = "llvm.insertelement"(%329, %325, %319) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %331 = "llvm.insertelement"(%330, %325, %318) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %332 = "llvm.insertelement"(%331, %325, %317) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %333 = "llvm.insertelement"(%332, %325, %316) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %334 = "llvm.insertelement"(%333, %325, %315) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %335 = "llvm.insertelement"(%334, %322, %314) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %336 = "llvm.insertelement"(%326, %325, %327) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %337 = "llvm.insertelement"(%336, %325, %320) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %338 = "llvm.insertelement"(%337, %325, %319) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %339 = "llvm.insertelement"(%338, %325, %318) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %340 = "llvm.insertelement"(%339, %325, %317) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %341 = "llvm.insertelement"(%340, %325, %316) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %342 = "llvm.insertelement"(%341, %322, %315) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %343 = "llvm.insertelement"(%342, %322, %314) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %344 = "llvm.insertelement"(%326, %325, %327) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %345 = "llvm.insertelement"(%344, %325, %320) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %346 = "llvm.insertelement"(%345, %325, %319) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %347 = "llvm.insertelement"(%346, %325, %318) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %348 = "llvm.insertelement"(%347, %325, %317) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %349 = "llvm.insertelement"(%348, %322, %316) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %350 = "llvm.insertelement"(%349, %322, %315) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %351 = "llvm.insertelement"(%350, %322, %314) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %352 = "llvm.insertelement"(%326, %322, %327) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %353 = "llvm.insertelement"(%352, %322, %320) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %354 = "llvm.insertelement"(%353, %322, %319) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %355 = "llvm.insertelement"(%354, %325, %318) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %356 = "llvm.insertelement"(%355, %325, %317) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %357 = "llvm.insertelement"(%356, %325, %316) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %358 = "llvm.insertelement"(%357, %325, %315) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %359 = "llvm.insertelement"(%358, %325, %314) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %360 = "llvm.insertelement"(%326, %325, %327) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %361 = "llvm.insertelement"(%360, %325, %320) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %362 = "llvm.insertelement"(%361, %325, %319) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %363 = "llvm.insertelement"(%362, %325, %318) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %364 = "llvm.insertelement"(%363, %322, %317) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %365 = "llvm.insertelement"(%364, %322, %316) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %366 = "llvm.insertelement"(%365, %322, %315) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %367 = "llvm.insertelement"(%366, %322, %314) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %368 = "llvm.insertelement"(%326, %322, %327) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %369 = "llvm.insertelement"(%368, %322, %320) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %370 = "llvm.insertelement"(%369, %325, %319) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %371 = "llvm.insertelement"(%370, %325, %318) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %372 = "llvm.insertelement"(%371, %325, %317) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %373 = "llvm.insertelement"(%372, %325, %316) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %374 = "llvm.insertelement"(%373, %325, %315) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %375 = "llvm.insertelement"(%374, %325, %314) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %376 = "llvm.insertelement"(%326, %325, %327) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %377 = "llvm.insertelement"(%376, %325, %320) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %378 = "llvm.insertelement"(%377, %325, %319) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %379 = "llvm.insertelement"(%378, %322, %318) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %380 = "llvm.insertelement"(%379, %322, %317) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %381 = "llvm.insertelement"(%380, %322, %316) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %382 = "llvm.insertelement"(%381, %322, %315) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %383 = "llvm.insertelement"(%382, %322, %314) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %384 = "llvm.insertelement"(%326, %322, %327) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %385 = "llvm.insertelement"(%384, %325, %320) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %386 = "llvm.insertelement"(%385, %325, %319) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %387 = "llvm.insertelement"(%386, %325, %318) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %388 = "llvm.insertelement"(%387, %325, %317) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %389 = "llvm.insertelement"(%388, %325, %316) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %390 = "llvm.insertelement"(%389, %325, %315) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %391 = "llvm.insertelement"(%390, %325, %314) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %392 = "llvm.insertelement"(%326, %325, %327) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %393 = "llvm.insertelement"(%392, %325, %320) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %394 = "llvm.insertelement"(%393, %322, %319) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %395 = "llvm.insertelement"(%394, %322, %318) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %396 = "llvm.insertelement"(%395, %322, %317) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %397 = "llvm.insertelement"(%396, %322, %316) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %398 = "llvm.insertelement"(%397, %322, %315) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %399 = "llvm.insertelement"(%398, %322, %314) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %400 = "llvm.shufflevector"(%arg27, %321) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %401 = "llvm.shufflevector"(%arg27, %321) <{mask = array<i32: 1, 1, 1, 1, 1, 1, 1, 1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %402 = "llvm.shufflevector"(%arg27, %321) <{mask = array<i32: 2, 2, 2, 2, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %403 = "llvm.shufflevector"(%arg27, %321) <{mask = array<i32: 3, 3, 3, 3, 3, 3, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %404 = "llvm.shufflevector"(%arg27, %321) <{mask = array<i32: 4, 4, 4, 4, 4, 4, 4, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %405 = "llvm.shufflevector"(%arg27, %321) <{mask = array<i32: 5, 5, 5, 5, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %406 = "llvm.call_intrinsic"(%323, %400, %arg28) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %407 = "llvm.shl"(%406, %324) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %408 = "llvm.call_intrinsic"(%407, %401, %arg28) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %409 = "llvm.call_intrinsic"(%323, %401, %arg28) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %410 = "llvm.shl"(%409, %324) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %411 = "llvm.call_intrinsic"(%410, %402, %arg28) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %412 = "llvm.call_intrinsic"(%323, %402, %arg28) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %413 = "llvm.shl"(%412, %324) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %414 = "llvm.call_intrinsic"(%413, %403, %arg28) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %415 = "llvm.call_intrinsic"(%323, %403, %arg28) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %416 = "llvm.shl"(%415, %324) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %417 = "llvm.call_intrinsic"(%416, %404, %arg28) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %418 = "llvm.call_intrinsic"(%323, %404, %arg28) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %419 = "llvm.shl"(%418, %324) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %420 = "llvm.call_intrinsic"(%419, %405, %arg28) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %421 = "llvm.call_intrinsic"(%323, %405, %arg28) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %422 = "llvm.shl"(%421, %324) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %423 = "llvm.shufflevector"(%335, %408) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %424 = "llvm.shufflevector"(%343, %411) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %425 = "llvm.shufflevector"(%351, %414) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %426 = "llvm.shufflevector"(%414, %359) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %427 = "llvm.shufflevector"(%367, %417) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %428 = "llvm.shufflevector"(%417, %375) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %429 = "llvm.shufflevector"(%383, %420) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %430 = "llvm.shufflevector"(%420, %391) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %431 = "llvm.shufflevector"(%399, %422) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %432 = "llvm.shufflevector"(%422, %321) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %433 = "llvm.call_intrinsic"(%423, %400, %arg28) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %434 = "llvm.add"(%425, %424) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %435 = "llvm.add"(%434, %427) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %436 = "llvm.add"(%435, %429) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %437 = "llvm.add"(%436, %433) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %438 = "llvm.add"(%437, %431) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %439 = "llvm.add"(%428, %426) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %440 = "llvm.add"(%439, %430) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %441 = "llvm.add"(%440, %432) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %442 = "llvm.and"(%438, %313) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %443 = "llvm.shufflevector"(%438, %441) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %444 = "llvm.shl"(%443, %312) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %445 = "llvm.add"(%444, %442) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %446 = "llvm.mul"(%443, %311) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %447 = "llvm.add"(%445, %446) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.return"(%447) : (vector<8xi64>) -> ()
}) : () -> ()

end

end MLIR.Firedancer.Avx512
