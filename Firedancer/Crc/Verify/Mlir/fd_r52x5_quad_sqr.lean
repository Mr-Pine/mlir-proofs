module

-- crc/out/mlirproofs/regions/verify/fd_r52x5_quad_sqr.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Firedancer.Crc.Verify

@[expose] public section

mlir_def fd_r52x5_quad_sqr :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr, ptr, ptr, ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "256"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], sym_name = "fd_r52x5_quad_sqr", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg49: !llvm.ptr, %arg50: !llvm.ptr, %arg51: !llvm.ptr, %arg52: !llvm.ptr, %arg53: !llvm.ptr, %arg54: vector<4xi64>, %arg55: vector<4xi64>, %arg56: vector<4xi64>, %arg57: vector<4xi64>, %arg58: vector<4xi64>):
  %223 = "llvm.mlir.constant"() <{value = dense<0> : vector<4xi64>}> : () -> vector<4xi64>
  %224 = "llvm.mlir.constant"() <{value = dense<1> : vector<4xi64>}> : () -> vector<4xi64>
  %225 = "llvm.mlir.constant"() <{value = dense<38> : vector<4xi64>}> : () -> vector<4xi64>
  %226 = "llvm.mlir.constant"() <{value = dense<2251799813685247> : vector<4xi64>}> : () -> vector<4xi64>
  %227 = "llvm.mlir.constant"() <{value = dense<2> : vector<4xi64>}> : () -> vector<4xi64>
  %228 = "llvm.mlir.constant"() <{value = dense<51> : vector<4xi64>}> : () -> vector<4xi64>
  %229 = "llvm.mlir.constant"() <{value = dense<19> : vector<4xi64>}> : () -> vector<4xi64>
  %230 = "llvm.call_intrinsic"(%223, %arg56, %arg57) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %231 = "llvm.call_intrinsic"(%230, %arg55, %arg58) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %232 = "llvm.call_intrinsic"(%223, %arg55, %arg57) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %233 = "llvm.call_intrinsic"(%232, %arg54, %arg58) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %234 = "llvm.shl"(%233, %224) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %235 = "llvm.call_intrinsic"(%234, %arg56, %arg56) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %236 = "llvm.add"(%235, %231) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %237 = "llvm.mul"(%236, %225) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %238 = "llvm.call_intrinsic"(%237, %arg54, %arg54) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %239 = "llvm.and"(%238, %226) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %240 = "llvm.call_intrinsic"(%223, %arg55, %arg57) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %241 = "llvm.call_intrinsic"(%240, %arg54, %arg58) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %242 = "llvm.call_intrinsic"(%223, %arg55, %arg56) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %243 = "llvm.call_intrinsic"(%242, %arg54, %arg57) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %244 = "llvm.shl"(%243, %227) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %245 = "llvm.shl"(%241, %224) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %246 = "llvm.add"(%244, %245) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %247 = "llvm.call_intrinsic"(%246, %arg56, %arg56) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %248 = "llvm.call_intrinsic"(%223, %arg58, %arg58) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %249 = "llvm.mul"(%248, %225) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %250 = "llvm.add"(%249, %247) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %251 = "llvm.lshr"(%250, %228) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %252 = "llvm.call_intrinsic"(%239, %229, %251) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %253 = "llvm.lshr"(%238, %228) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %254 = "llvm.call_intrinsic"(%223, %arg54, %arg55) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %255 = "llvm.call_intrinsic"(%254, %arg54, %arg54) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %256 = "llvm.shl"(%255, %224) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %257 = "llvm.call_intrinsic"(%223, %arg56, %arg57) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %258 = "llvm.call_intrinsic"(%257, %arg55, %arg58) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %259 = "llvm.shl"(%258, %224) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %260 = "llvm.call_intrinsic"(%259, %arg56, %arg58) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %261 = "llvm.shl"(%260, %224) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %262 = "llvm.call_intrinsic"(%261, %arg57, %arg57) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %263 = "llvm.mul"(%262, %229) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %264 = "llvm.add"(%263, %256) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %265 = "llvm.and"(%264, %226) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %266 = "llvm.add"(%265, %253) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %267 = "llvm.lshr"(%264, %228) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %268 = "llvm.call_intrinsic"(%223, %arg54, %arg55) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %269 = "llvm.shl"(%268, %224) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %270 = "llvm.call_intrinsic"(%269, %arg54, %arg56) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %271 = "llvm.shl"(%270, %224) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %272 = "llvm.call_intrinsic"(%271, %arg55, %arg55) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %273 = "llvm.call_intrinsic"(%223, %arg56, %arg58) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %274 = "llvm.shl"(%273, %224) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %275 = "llvm.call_intrinsic"(%274, %arg57, %arg57) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %276 = "llvm.call_intrinsic"(%275, %arg57, %arg58) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %277 = "llvm.mul"(%276, %225) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %278 = "llvm.add"(%277, %272) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %279 = "llvm.and"(%278, %226) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %280 = "llvm.add"(%279, %267) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %281 = "llvm.lshr"(%278, %228) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %282 = "llvm.call_intrinsic"(%223, %arg55, %arg56) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %283 = "llvm.call_intrinsic"(%282, %arg54, %arg57) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %284 = "llvm.call_intrinsic"(%223, %arg54, %arg56) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %285 = "llvm.shl"(%284, %224) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %286 = "llvm.call_intrinsic"(%285, %arg55, %arg55) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %287 = "llvm.add"(%286, %283) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %288 = "llvm.shl"(%287, %224) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %289 = "llvm.call_intrinsic"(%223, %arg57, %arg58) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %290 = "llvm.shl"(%289, %227) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %291 = "llvm.call_intrinsic"(%290, %arg58, %arg58) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %292 = "llvm.mul"(%291, %229) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %293 = "llvm.add"(%292, %288) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %294 = "llvm.and"(%293, %226) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %295 = "llvm.add"(%294, %281) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %296 = "llvm.lshr"(%293, %228) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %297 = "llvm.and"(%250, %226) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %298 = "llvm.add"(%296, %297) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.store"(%252, %arg49) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.store"(%266, %arg50) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.store"(%280, %arg51) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.store"(%295, %arg52) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.store"(%298, %arg53) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end MLIR.Firedancer.Crc.Verify
