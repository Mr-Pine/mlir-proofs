module

-- crc/out/mlirproofs/regions/verify/fd_r52x5_ge_is_small_order_affine.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_limbs_eq
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_limbs_is_zero
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_lane_canon
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_order8_y0
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_order8_y1

meta import MLIR.Semantics.Func
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_limbs_eq
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_limbs_is_zero
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_lane_canon
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_order8_y0
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_order8_y1

namespace MLIR.Firedancer.Crc.Verify

@[expose] public section

mlir_def fd_r52x5_ge_is_small_order_affine :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<i32 (ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "256"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], res_attrs = [{llvm.range = #llvm.constant_range<i32, 0, 2>}], sym_name = "fd_r52x5_ge_is_small_order_affine", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg151: !llvm.ptr):
  %2290 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %2291 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %2292 = "llvm.mlir.addressof"() <{global_name = @fd_r52x5_order8_y0}> : () -> !llvm.ptr
  %2293 = "llvm.mlir.addressof"() <{global_name = @fd_r52x5_order8_y1}> : () -> !llvm.ptr
  %2294 = "llvm.alloca"(%2290) <{alignment = 16 : i64, elem_type = !llvm.array<5 x i64>}> : (i32) -> !llvm.ptr
  %2295 = "llvm.alloca"(%2290) <{alignment = 16 : i64, elem_type = !llvm.array<5 x i64>}> : (i32) -> !llvm.ptr
  %2296 = "llvm.load"(%arg151) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2297 = "llvm.getelementptr"(%arg151) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %2298 = "llvm.load"(%2297) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2299 = "llvm.getelementptr"(%arg151) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %2300 = "llvm.load"(%2299) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2301 = "llvm.getelementptr"(%arg151) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %2302 = "llvm.load"(%2301) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2303 = "llvm.getelementptr"(%arg151) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %2304 = "llvm.load"(%2303) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%2294) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2295) : (!llvm.ptr) -> ()
  "llvm.call"(%2294, %2296, %2298, %2300, %2302, %2304, %2291) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_lane_canon, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 7, 0>}> : (!llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, i32) -> ()
  "llvm.call"(%2295, %2296, %2298, %2300, %2302, %2304, %2290) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_lane_canon, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 7, 0>}> : (!llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, i32) -> ()
  %2305 = "llvm.call"(%2294) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_r52x5_limbs_is_zero, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i32
  %2306 = "llvm.icmp"(%2305, %2291) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2306, %2290)[^bb1, ^bb4] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb1:  // pred: ^bb0
  %2307 = "llvm.call"(%2295) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_r52x5_limbs_is_zero, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i32
  %2308 = "llvm.icmp"(%2307, %2291) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2308, %2290)[^bb2, ^bb4] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb2:  // pred: ^bb1
  %2309 = "llvm.call"(%2295, %2292) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_r52x5_limbs_eq, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> i32
  %2310 = "llvm.icmp"(%2309, %2291) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2310, %2290)[^bb3, ^bb4] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb3:  // pred: ^bb2
  %2311 = "llvm.call"(%2295, %2293) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_r52x5_limbs_eq, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> i32
  "llvm.br"(%2311)[^bb4] : (i32) -> ()
^bb4(%2312: i32):  // 4 preds: ^bb0, ^bb1, ^bb2, ^bb3
  "llvm.intr.lifetime.end"(%2295) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2294) : (!llvm.ptr) -> ()
  "llvm.return"(%2312) : (i32) -> ()
}) : () -> ()
  with @fd_r52x5_limbs_eq := fd_r52x5_limbs_eq, @fd_r52x5_limbs_is_zero := fd_r52x5_limbs_is_zero,
    @fd_r52x5_quad_lane_canon := fd_r52x5_quad_lane_canon,
    @fd_r52x5_order8_y0 := fd_r52x5_order8_y0, @fd_r52x5_order8_y1 := fd_r52x5_order8_y1

end

end MLIR.Firedancer.Crc.Verify
