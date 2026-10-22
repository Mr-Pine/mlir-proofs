module

-- crc/out/mlirproofs/regions/verify/fd_r52x5_affine_is_small_order.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_limbs_eq
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_limbs_is_zero
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_order8_y0
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_order8_y1

meta import MLIR.Semantics.Func
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_limbs_eq
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_limbs_is_zero
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_order8_y0
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_order8_y1

namespace MLIR.Firedancer.Crc.Ed25519.Avx512

@[expose] public section

mlir_def fd_r52x5_affine_is_small_order :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<i32 (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], res_attrs = [{llvm.range = #llvm.constant_range<i32, 0, 2>}], sym_name = "fd_r52x5_affine_is_small_order", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg195: !llvm.ptr, %arg196: !llvm.ptr):
  %2523 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %2524 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %2525 = "llvm.mlir.addressof"() <{global_name = @fd_r52x5_order8_y0}> : () -> !llvm.ptr
  %2526 = "llvm.mlir.addressof"() <{global_name = @fd_r52x5_order8_y1}> : () -> !llvm.ptr
  %2527 = "llvm.call"(%arg195) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r52x5_limbs_is_zero, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i32
  %2528 = "llvm.icmp"(%2527, %2523) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2528, %2524)[^bb1, ^bb4] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb1:  // pred: ^bb0
  %2529 = "llvm.call"(%arg196) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r52x5_limbs_is_zero, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i32
  %2530 = "llvm.icmp"(%2529, %2523) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2530, %2524)[^bb2, ^bb4] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb2:  // pred: ^bb1
  %2531 = "llvm.call"(%arg196, %2525) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_r52x5_limbs_eq, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> i32
  %2532 = "llvm.icmp"(%2531, %2523) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2532, %2524)[^bb3, ^bb4] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb3:  // pred: ^bb2
  %2533 = "llvm.call"(%arg196, %2526) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_r52x5_limbs_eq, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> i32
  "llvm.br"(%2533)[^bb4] : (i32) -> ()
^bb4(%2534: i32):  // 4 preds: ^bb0, ^bb1, ^bb2, ^bb3
  "llvm.return"(%2534) : (i32) -> ()
}) : () -> ()
  with @fd_r52x5_limbs_eq := fd_r52x5_limbs_eq, @fd_r52x5_limbs_is_zero := fd_r52x5_limbs_is_zero,
    @fd_r52x5_order8_y0 := fd_r52x5_order8_y0, @fd_r52x5_order8_y1 := fd_r52x5_order8_y1

end

end MLIR.Firedancer.Crc.Ed25519.Avx512
