module

-- crc/out/mlirproofs/regions/verify/fd_r52x5_ge_is_small_order_affine.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_limbs_eq
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_limbs_is_zero
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_lane_canon
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_order8_y0
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_order8_y1

meta import MLIR.Semantics.Func
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_limbs_eq
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_limbs_is_zero
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_lane_canon
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_order8_y0
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_order8_y1

namespace MLIR.Firedancer.Crc.Ed25519.Avx512

@[expose] public section

mlir_def fd_r52x5_ge_is_small_order_affine :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<i32 (ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "256"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], res_attrs = [{llvm.range = #llvm.constant_range<i32, 0, 2>}], sym_name = "fd_r52x5_ge_is_small_order_affine", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg209: !llvm.ptr):
  %3403 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %3404 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %3405 = "llvm.mlir.addressof"() <{global_name = @fd_r52x5_order8_y0}> : () -> !llvm.ptr
  %3406 = "llvm.mlir.addressof"() <{global_name = @fd_r52x5_order8_y1}> : () -> !llvm.ptr
  %3407 = "llvm.alloca"(%3403) <{alignment = 16 : i64, elem_type = !llvm.array<5 x i64>}> : (i32) -> !llvm.ptr
  %3408 = "llvm.alloca"(%3403) <{alignment = 16 : i64, elem_type = !llvm.array<5 x i64>}> : (i32) -> !llvm.ptr
  %3409 = "llvm.load"(%arg209) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3410 = "llvm.getelementptr"(%arg209) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %3411 = "llvm.load"(%3410) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3412 = "llvm.getelementptr"(%arg209) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %3413 = "llvm.load"(%3412) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3414 = "llvm.getelementptr"(%arg209) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %3415 = "llvm.load"(%3414) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3416 = "llvm.getelementptr"(%arg209) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %3417 = "llvm.load"(%3416) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%3407) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3408) : (!llvm.ptr) -> ()
  "llvm.call"(%3407, %3409, %3411, %3413, %3415, %3417, %3404) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_lane_canon, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 7, 0>}> : (!llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, i32) -> ()
  "llvm.call"(%3408, %3409, %3411, %3413, %3415, %3417, %3403) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_lane_canon, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 7, 0>}> : (!llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, i32) -> ()
  %3418 = "llvm.call"(%3407) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_r52x5_limbs_is_zero, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i32
  %3419 = "llvm.icmp"(%3418, %3404) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%3419, %3403)[^bb1, ^bb4] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb1:  // pred: ^bb0
  %3420 = "llvm.call"(%3408) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_r52x5_limbs_is_zero, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i32
  %3421 = "llvm.icmp"(%3420, %3404) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%3421, %3403)[^bb2, ^bb4] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb2:  // pred: ^bb1
  %3422 = "llvm.call"(%3408, %3405) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_r52x5_limbs_eq, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> i32
  %3423 = "llvm.icmp"(%3422, %3404) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%3423, %3403)[^bb3, ^bb4] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb3:  // pred: ^bb2
  %3424 = "llvm.call"(%3408, %3406) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_r52x5_limbs_eq, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> i32
  "llvm.br"(%3424)[^bb4] : (i32) -> ()
^bb4(%3425: i32):  // 4 preds: ^bb0, ^bb1, ^bb2, ^bb3
  "llvm.intr.lifetime.end"(%3408) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3407) : (!llvm.ptr) -> ()
  "llvm.return"(%3425) : (i32) -> ()
}) : () -> ()
  with @fd_r52x5_limbs_eq := fd_r52x5_limbs_eq, @fd_r52x5_limbs_is_zero := fd_r52x5_limbs_is_zero,
    @fd_r52x5_quad_lane_canon := fd_r52x5_quad_lane_canon,
    @fd_r52x5_order8_y0 := fd_r52x5_order8_y0, @fd_r52x5_order8_y1 := fd_r52x5_order8_y1

end

end MLIR.Firedancer.Crc.Ed25519.Avx512
