module

-- crc/out/mlirproofs/regions/verify/fd_r52x5_quad_mul.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Firedancer.Crc.Verify

@[expose] public section

mlir_def fd_r52x5_quad_mul :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr, ptr, ptr, ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "256"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], sym_name = "fd_r52x5_quad_mul", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg59: !llvm.ptr, %arg60: !llvm.ptr, %arg61: !llvm.ptr, %arg62: !llvm.ptr, %arg63: !llvm.ptr, %arg64: vector<4xi64>, %arg65: vector<4xi64>, %arg66: vector<4xi64>, %arg67: vector<4xi64>, %arg68: vector<4xi64>, %arg69: vector<4xi64>, %arg70: vector<4xi64>, %arg71: vector<4xi64>, %arg72: vector<4xi64>, %arg73: vector<4xi64>):
  %319 = "llvm.mlir.constant"() <{value = dense<0> : vector<4xi64>}> : () -> vector<4xi64>
  %320 = "llvm.mlir.constant"() <{value = dense<1> : vector<4xi64>}> : () -> vector<4xi64>
  %321 = "llvm.mlir.constant"() <{value = dense<19> : vector<4xi64>}> : () -> vector<4xi64>
  %322 = "llvm.mlir.constant"() <{value = dense<2251799813685247> : vector<4xi64>}> : () -> vector<4xi64>
  %323 = "llvm.mlir.constant"() <{value = dense<38> : vector<4xi64>}> : () -> vector<4xi64>
  %324 = "llvm.mlir.constant"() <{value = dense<51> : vector<4xi64>}> : () -> vector<4xi64>
  %325 = "llvm.call_intrinsic"(%319, %arg66, %arg72) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %326 = "llvm.call_intrinsic"(%325, %arg65, %arg73) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %327 = "llvm.call_intrinsic"(%326, %arg67, %arg71) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %328 = "llvm.call_intrinsic"(%327, %arg68, %arg70) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %329 = "llvm.call_intrinsic"(%319, %arg65, %arg72) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %330 = "llvm.call_intrinsic"(%329, %arg64, %arg73) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %331 = "llvm.call_intrinsic"(%330, %arg66, %arg71) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %332 = "llvm.call_intrinsic"(%331, %arg67, %arg70) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %333 = "llvm.call_intrinsic"(%332, %arg68, %arg69) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %334 = "llvm.shl"(%333, %320) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %335 = "llvm.add"(%334, %328) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %336 = "llvm.mul"(%335, %321) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %337 = "llvm.call_intrinsic"(%336, %arg64, %arg69) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %338 = "llvm.and"(%337, %322) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %339 = "llvm.call_intrinsic"(%319, %arg65, %arg72) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %340 = "llvm.call_intrinsic"(%339, %arg64, %arg73) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %341 = "llvm.call_intrinsic"(%340, %arg66, %arg71) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %342 = "llvm.call_intrinsic"(%341, %arg67, %arg70) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %343 = "llvm.call_intrinsic"(%342, %arg68, %arg69) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %344 = "llvm.call_intrinsic"(%319, %arg65, %arg71) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %345 = "llvm.call_intrinsic"(%344, %arg64, %arg72) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %346 = "llvm.call_intrinsic"(%345, %arg66, %arg70) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %347 = "llvm.call_intrinsic"(%346, %arg67, %arg69) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %348 = "llvm.shl"(%347, %320) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %349 = "llvm.add"(%348, %343) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %350 = "llvm.call_intrinsic"(%319, %arg68, %arg73) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %351 = "llvm.mul"(%350, %323) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %352 = "llvm.add"(%349, %351) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %353 = "llvm.lshr"(%352, %324) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %354 = "llvm.call_intrinsic"(%338, %321, %353) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %355 = "llvm.lshr"(%337, %324) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %356 = "llvm.call_intrinsic"(%319, %arg65, %arg69) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %357 = "llvm.call_intrinsic"(%356, %arg64, %arg70) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %358 = "llvm.call_intrinsic"(%319, %arg64, %arg69) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %359 = "llvm.shl"(%358, %320) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %360 = "llvm.add"(%359, %357) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %361 = "llvm.call_intrinsic"(%319, %arg67, %arg72) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %362 = "llvm.call_intrinsic"(%361, %arg66, %arg73) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %363 = "llvm.call_intrinsic"(%362, %arg68, %arg71) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %364 = "llvm.call_intrinsic"(%319, %arg66, %arg72) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %365 = "llvm.call_intrinsic"(%364, %arg65, %arg73) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %366 = "llvm.call_intrinsic"(%365, %arg67, %arg71) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %367 = "llvm.call_intrinsic"(%366, %arg68, %arg70) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %368 = "llvm.shl"(%367, %320) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %369 = "llvm.add"(%368, %363) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %370 = "llvm.mul"(%369, %321) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %371 = "llvm.add"(%360, %370) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %372 = "llvm.and"(%371, %322) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %373 = "llvm.add"(%372, %355) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %374 = "llvm.lshr"(%371, %324) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %375 = "llvm.call_intrinsic"(%319, %arg65, %arg70) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %376 = "llvm.call_intrinsic"(%375, %arg64, %arg71) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %377 = "llvm.call_intrinsic"(%376, %arg66, %arg69) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %378 = "llvm.call_intrinsic"(%319, %arg65, %arg69) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %379 = "llvm.call_intrinsic"(%378, %arg64, %arg70) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %380 = "llvm.shl"(%379, %320) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %381 = "llvm.add"(%380, %377) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %382 = "llvm.call_intrinsic"(%319, %arg68, %arg72) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %383 = "llvm.call_intrinsic"(%382, %arg67, %arg73) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %384 = "llvm.call_intrinsic"(%319, %arg67, %arg72) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %385 = "llvm.call_intrinsic"(%384, %arg66, %arg73) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %386 = "llvm.call_intrinsic"(%385, %arg68, %arg71) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %387 = "llvm.shl"(%386, %320) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %388 = "llvm.add"(%387, %383) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %389 = "llvm.mul"(%388, %321) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %390 = "llvm.add"(%381, %389) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %391 = "llvm.and"(%390, %322) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %392 = "llvm.add"(%391, %374) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %393 = "llvm.lshr"(%390, %324) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %394 = "llvm.call_intrinsic"(%319, %arg65, %arg71) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %395 = "llvm.call_intrinsic"(%394, %arg64, %arg72) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %396 = "llvm.call_intrinsic"(%395, %arg66, %arg70) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %397 = "llvm.call_intrinsic"(%396, %arg67, %arg69) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %398 = "llvm.call_intrinsic"(%319, %arg65, %arg70) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %399 = "llvm.call_intrinsic"(%398, %arg64, %arg71) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %400 = "llvm.call_intrinsic"(%399, %arg66, %arg69) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %401 = "llvm.shl"(%400, %320) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %402 = "llvm.add"(%401, %397) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %403 = "llvm.call_intrinsic"(%319, %arg68, %arg72) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %404 = "llvm.call_intrinsic"(%403, %arg67, %arg73) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %405 = "llvm.shl"(%404, %320) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %406 = "llvm.call_intrinsic"(%405, %arg68, %arg73) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %407 = "llvm.mul"(%406, %321) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %408 = "llvm.add"(%402, %407) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %409 = "llvm.and"(%408, %322) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %410 = "llvm.add"(%409, %393) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %411 = "llvm.lshr"(%408, %324) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %412 = "llvm.and"(%352, %322) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %413 = "llvm.add"(%411, %412) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.store"(%354, %arg59) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.store"(%373, %arg60) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.store"(%392, %arg61) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.store"(%410, %arg62) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.store"(%413, %arg63) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end MLIR.Firedancer.Crc.Verify
