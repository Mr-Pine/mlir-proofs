module

-- crc/out/mlirproofs/regions/verify/fd_r52x5_verify_core.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Crc.Verify.Extern.fd_curve25519_scalar_reduce
public import Firedancer.Crc.Verify.Mlir.fd_curve25519_scalar_validate
public import Firedancer.Crc.Verify.Mlir.fd_memeq
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_affine_is_small_order
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_double_scalar_mul_base
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_double_scalar_mul_base_split
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_encode_canon
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_ge_affine_canon
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_ge_decode1
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_ge_decode2
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_ge_eq_z1
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_ge_is_small_order_affine
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_neg
public import Firedancer.Crc.Verify.Extern.fd_sha512_append
public import Firedancer.Crc.Verify.Extern.fd_sha512_fini
public import Firedancer.Crc.Verify.Extern.fd_sha512_init

meta import MLIR.Semantics.Func
meta import Firedancer.Crc.Verify.Extern.fd_curve25519_scalar_reduce
meta import Firedancer.Crc.Verify.Mlir.fd_curve25519_scalar_validate
meta import Firedancer.Crc.Verify.Mlir.fd_memeq
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_affine_is_small_order
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_double_scalar_mul_base
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_double_scalar_mul_base_split
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_encode_canon
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_ge_affine_canon
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_ge_decode1
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_ge_decode2
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_ge_eq_z1
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_ge_is_small_order_affine
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_neg
meta import Firedancer.Crc.Verify.Extern.fd_sha512_append
meta import Firedancer.Crc.Verify.Extern.fd_sha512_fini
meta import Firedancer.Crc.Verify.Extern.fd_sha512_init

namespace MLIR.Firedancer.Crc.Verify

@[expose] public section

noncomputable mlir_def fd_r52x5_verify_core :=
"llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.noundef}, {llvm.noundef, llvm.writeonly}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<i32 (ptr, i64, ptr, ptr, ptr, ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, no_inline, no_unwind, passthrough = ["sspstrong", ["min-legal-vector-width", "256"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], res_attrs = [{llvm.range = #llvm.constant_range<i32, -2, 1>}], sym_name = "fd_r52x5_verify_core", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg154: !llvm.ptr, %arg155: i64, %arg156: !llvm.ptr, %arg157: !llvm.ptr, %arg158: !llvm.ptr, %arg159: !llvm.ptr, %arg160: !llvm.ptr, %arg161: !llvm.ptr):
  %2316 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %2317 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %2318 = "llvm.mlir.zero"() : () -> !llvm.ptr
  %2319 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
  %2320 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %2321 = "llvm.mlir.constant"() <{value = -2 : i32}> : () -> i32
  %2322 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %2323 = "llvm.mlir.constant"() <{value = 192 : i64}> : () -> i64
  %2324 = "llvm.alloca"(%2316) <{alignment = 64 : i64, elem_type = !llvm.struct<"struct.fd_r52x5_ge", (vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, array<32 x i8>)>}> : (i32) -> !llvm.ptr
  %2325 = "llvm.alloca"(%2316) <{alignment = 64 : i64, elem_type = !llvm.struct<"struct.fd_r52x5_ge", (vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, array<32 x i8>)>}> : (i32) -> !llvm.ptr
  %2326 = "llvm.alloca"(%2316) <{alignment = 64 : i64, elem_type = !llvm.struct<"struct.fd_r52x5_ge", (vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, array<32 x i8>)>}> : (i32) -> !llvm.ptr
  %2327 = "llvm.alloca"(%2316) <{alignment = 16 : i64, elem_type = !llvm.array<64 x i8>}> : (i32) -> !llvm.ptr
  %2328 = "llvm.alloca"(%2316) <{alignment = 16 : i64, elem_type = !llvm.array<5 x i64>}> : (i32) -> !llvm.ptr
  %2329 = "llvm.alloca"(%2316) <{alignment = 16 : i64, elem_type = !llvm.array<5 x i64>}> : (i32) -> !llvm.ptr
  %2330 = "llvm.alloca"(%2316) <{alignment = 16 : i64, elem_type = !llvm.array<32 x i8>}> : (i32) -> !llvm.ptr
  %2331 = "llvm.alloca"(%2316) <{alignment = 16 : i64, elem_type = !llvm.array<64 x i8>}> : (i32) -> !llvm.ptr
  %2332 = "llvm.alloca"(%2316) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2333 = "llvm.alloca"(%2316) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2334 = "llvm.alloca"(%2316) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2335 = "llvm.alloca"(%2316) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2336 = "llvm.alloca"(%2316) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2337 = "llvm.getelementptr"(%arg156) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %2338 = "llvm.call"(%2337) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @fd_curve25519_scalar_validate, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> !llvm.ptr
  %2339 = "llvm.icmp"(%2338, %2318) <{predicate = 0 : i64}> : (!llvm.ptr, !llvm.ptr) -> i1
  "llvm.cond_br"(%2339, %2319)[^bb21, ^bb1] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i32) -> ()
^bb1:  // pred: ^bb0
  "llvm.intr.lifetime.start"(%2324) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2325) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2326) : (!llvm.ptr) -> ()
  %2340 = "llvm.icmp"(%arg159, %2318) <{predicate = 0 : i64}> : (!llvm.ptr, !llvm.ptr) -> i1
  "llvm.cond_br"(%2340)[^bb12, ^bb2] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb2:  // pred: ^bb1
  %2341 = "llvm.load"(%arg160) <{alignment = 4 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %2342 = "llvm.icmp"(%2341, %2320) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2342)[^bb3, ^bb5] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb3:  // pred: ^bb2
  %2343 = "llvm.call"(%2325, %arg156) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_r52x5_ge_decode1, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> i32
  %2344 = "llvm.icmp"(%2343, %2320) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2344, %2319)[^bb20, ^bb4] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i32) -> ()
^bb4:  // pred: ^bb3
  %2345 = "llvm.call"(%2325) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_r52x5_ge_is_small_order_affine, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i32
  %2346 = "llvm.sub"(%2320, %2345) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  "llvm.br"(%2346)[^bb20] : (i32) -> ()
^bb5:  // pred: ^bb2
  "llvm.intr.lifetime.start"(%2327) : (!llvm.ptr) -> ()
  %2347 = "llvm.call"(%arg158) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_sha512_init, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> !llvm.ptr
  %2348 = "llvm.call"(%2347, %arg156, %2317) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_append, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %2349 = "llvm.call"(%2348, %arg157, %2317) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_append, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %2350 = "llvm.call"(%2349, %arg154, %arg155) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_append, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %2351 = "llvm.call"(%2350, %2327) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_sha512_fini, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %2352 = "llvm.call"(%2327, %2327) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_curve25519_scalar_reduce, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.call"(%2326, %2327, %arg159, %2337) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_r52x5_double_scalar_mul_base_split, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = readwrite, argMem = readwrite, inaccessibleMem = none, errnoMem = readwrite, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2328) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2329) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2330) : (!llvm.ptr) -> ()
  "llvm.call"(%2328, %2329, %2326) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_ge_affine_canon, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  %2353 = "llvm.load"(%2328) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  "llvm.call"(%2330, %2353, %2329) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {}, {llvm.noundef}], callee = @fd_r52x5_encode_canon, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, i64, !llvm.ptr) -> ()
  %2354 = "llvm.call"(%2330, %arg156) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_memeq, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> i32
  %2355 = "llvm.icmp"(%2354, %2320) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2355)[^bb7, ^bb6] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb6:  // pred: ^bb5
  %2356 = "llvm.call"(%2328, %2329) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_affine_is_small_order, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> i32
  %2357 = "llvm.icmp"(%2356, %2320) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2357, %2316, %2319)[^bb10, ^bb11] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 1, 1>}> : (i1, i32, i32) -> ()
^bb7:  // pred: ^bb5
  %2358 = "llvm.call"(%2325, %arg156) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_r52x5_ge_decode1, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> i32
  %2359 = "llvm.icmp"(%2358, %2320) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2359, %2319)[^bb11, ^bb8] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i32) -> ()
^bb8:  // pred: ^bb7
  %2360 = "llvm.call"(%2325) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_r52x5_ge_is_small_order_affine, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i32
  %2361 = "llvm.icmp"(%2360, %2320) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2361, %2319)[^bb9, ^bb11] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb9:  // pred: ^bb8
  %2362 = "llvm.call"(%2326, %2325) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_ge_eq_z1, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> i32
  "llvm.br"(%2362)[^bb10] : (i32) -> ()
^bb10(%2363: i32):  // 2 preds: ^bb6, ^bb9
  "llvm.store"(%2363, %arg160) <{alignment = 4 : i64, ordering = 0 : i64}> : (i32, !llvm.ptr) -> ()
  "llvm.br"(%2320)[^bb11] : (i32) -> ()
^bb11(%2364: i32):  // 4 preds: ^bb6, ^bb7, ^bb8, ^bb10
  "llvm.intr.lifetime.end"(%2330) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2329) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2328) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2327) : (!llvm.ptr) -> ()
  "llvm.br"(%2364)[^bb20] : (i32) -> ()
^bb12:  // pred: ^bb1
  %2365 = "llvm.call"(%2324, %arg157, %2325, %arg156) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_r52x5_ge_decode2, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> i32
  %2366 = "llvm.and"(%2365, %2316) : (i32, i32) -> i32
  %2367 = "llvm.icmp"(%2366, %2320) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2367, %2321)[^bb20, ^bb13] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i32) -> ()
^bb13:  // pred: ^bb12
  %2368 = "llvm.icmp"(%2365, %2322) <{predicate = 6 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2368, %2319)[^bb20, ^bb14] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i32) -> ()
^bb14:  // pred: ^bb13
  %2369 = "llvm.call"(%2324) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_r52x5_ge_is_small_order_affine, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i32
  %2370 = "llvm.icmp"(%2369, %2320) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2370, %2321)[^bb15, ^bb20] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb15:  // pred: ^bb14
  %2371 = "llvm.call"(%2325) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_r52x5_ge_is_small_order_affine, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i32
  %2372 = "llvm.icmp"(%2371, %2320) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2372, %2319)[^bb16, ^bb20] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb16:  // pred: ^bb15
  %2373 = "llvm.load"(%arg160) <{alignment = 4 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %2374 = "llvm.icmp"(%2373, %2320) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2374, %2320)[^bb20, ^bb17] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i32) -> ()
^bb17:  // pred: ^bb16
  "llvm.intr.lifetime.start"(%2331) : (!llvm.ptr) -> ()
  %2375 = "llvm.call"(%arg158) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_sha512_init, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> !llvm.ptr
  %2376 = "llvm.call"(%2375, %arg156, %2317) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_append, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %2377 = "llvm.call"(%2376, %arg157, %2317) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_append, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %2378 = "llvm.call"(%2377, %arg154, %arg155) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_append, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %2379 = "llvm.call"(%2378, %2331) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_sha512_fini, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %2380 = "llvm.call"(%2331, %2331) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_curve25519_scalar_reduce, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %2381 = "llvm.load"(%2324) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2382 = "llvm.getelementptr"(%2324) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %2383 = "llvm.load"(%2382) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2384 = "llvm.getelementptr"(%2324) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %2385 = "llvm.load"(%2384) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2386 = "llvm.getelementptr"(%2324) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %2387 = "llvm.load"(%2386) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2388 = "llvm.getelementptr"(%2324) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %2389 = "llvm.load"(%2388) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%2332) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2333) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2334) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2335) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2336) : (!llvm.ptr) -> ()
  "llvm.call"(%2332, %2333, %2334, %2335, %2336, %2381, %2383, %2385, %2387, %2389) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_neg, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2390 = "llvm.load"(%2332) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<32xi8>
  %2391 = "llvm.load"(%2333) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<32xi8>
  %2392 = "llvm.load"(%2334) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<32xi8>
  %2393 = "llvm.load"(%2335) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<32xi8>
  %2394 = "llvm.load"(%2336) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<32xi8>
  "llvm.intr.lifetime.end"(%2336) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2335) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2334) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2333) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2332) : (!llvm.ptr) -> ()
  %2395 = "llvm.bitcast"(%2381) : (vector<4xi64>) -> vector<32xi8>
  %2396 = "llvm.shufflevector"(%2390, %2395) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 24, 25, 26, 27, 28, 29, 30, 31>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %2397 = "llvm.bitcast"(%2383) : (vector<4xi64>) -> vector<32xi8>
  %2398 = "llvm.shufflevector"(%2391, %2397) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 24, 25, 26, 27, 28, 29, 30, 31>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %2399 = "llvm.bitcast"(%2385) : (vector<4xi64>) -> vector<32xi8>
  %2400 = "llvm.shufflevector"(%2392, %2399) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 24, 25, 26, 27, 28, 29, 30, 31>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %2401 = "llvm.bitcast"(%2387) : (vector<4xi64>) -> vector<32xi8>
  %2402 = "llvm.shufflevector"(%2393, %2401) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 24, 25, 26, 27, 28, 29, 30, 31>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %2403 = "llvm.bitcast"(%2389) : (vector<4xi64>) -> vector<32xi8>
  %2404 = "llvm.shufflevector"(%2394, %2403) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 24, 25, 26, 27, 28, 29, 30, 31>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  "llvm.store"(%2396, %2324) <{alignment = 64 : i64, ordering = 0 : i64}> : (vector<32xi8>, !llvm.ptr) -> ()
  "llvm.store"(%2398, %2382) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<32xi8>, !llvm.ptr) -> ()
  "llvm.store"(%2400, %2384) <{alignment = 64 : i64, ordering = 0 : i64}> : (vector<32xi8>, !llvm.ptr) -> ()
  "llvm.store"(%2402, %2386) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<32xi8>, !llvm.ptr) -> ()
  "llvm.store"(%2404, %2388) <{alignment = 64 : i64, ordering = 0 : i64}> : (vector<32xi8>, !llvm.ptr) -> ()
  "llvm.call"(%2326, %2331, %2324, %2337) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_r52x5_double_scalar_mul_base, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = readwrite, argMem = readwrite, inaccessibleMem = none, errnoMem = readwrite, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  %2405 = "llvm.call"(%2326, %2325) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_ge_eq_z1, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> i32
  "llvm.store"(%2405, %arg160) <{alignment = 4 : i64, ordering = 0 : i64}> : (i32, !llvm.ptr) -> ()
  %2406 = "llvm.icmp"(%arg161, %2318) <{predicate = 0 : i64}> : (!llvm.ptr, !llvm.ptr) -> i1
  "llvm.cond_br"(%2406)[^bb19, ^bb18] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb18:  // pred: ^bb17
  "llvm.intr.memcpy"(%arg161, %2324, %2323) <{arg_attrs = [{llvm.align = 64 : i64, llvm.dereferenceable = 192 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 64 : i64, llvm.dereferenceable = 192 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.br"()[^bb19] : () -> ()
^bb19:  // 2 preds: ^bb17, ^bb18
  "llvm.intr.lifetime.end"(%2331) : (!llvm.ptr) -> ()
  "llvm.br"(%2320)[^bb20] : (i32) -> ()
^bb20(%2407: i32):  // 9 preds: ^bb3, ^bb4, ^bb11, ^bb12, ^bb13, ^bb14, ^bb15, ^bb16, ^bb19
  "llvm.intr.lifetime.end"(%2326) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2325) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2324) : (!llvm.ptr) -> ()
  "llvm.br"(%2407)[^bb21] : (i32) -> ()
^bb21(%2408: i32):  // 2 preds: ^bb0, ^bb20
  "llvm.return"(%2408) : (i32) -> ()
}) : () -> ()
  with @fd_curve25519_scalar_reduce := fd_curve25519_scalar_reduce,
    @fd_curve25519_scalar_validate := fd_curve25519_scalar_validate, @fd_memeq := fd_memeq,
    @fd_r52x5_affine_is_small_order := fd_r52x5_affine_is_small_order,
    @fd_r52x5_double_scalar_mul_base := fd_r52x5_double_scalar_mul_base,
    @fd_r52x5_double_scalar_mul_base_split := fd_r52x5_double_scalar_mul_base_split,
    @fd_r52x5_encode_canon := fd_r52x5_encode_canon,
    @fd_r52x5_ge_affine_canon := fd_r52x5_ge_affine_canon,
    @fd_r52x5_ge_decode1 := fd_r52x5_ge_decode1, @fd_r52x5_ge_decode2 := fd_r52x5_ge_decode2,
    @fd_r52x5_ge_eq_z1 := fd_r52x5_ge_eq_z1,
    @fd_r52x5_ge_is_small_order_affine := fd_r52x5_ge_is_small_order_affine,
    @fd_r52x5_quad_neg := fd_r52x5_quad_neg, @fd_sha512_append := fd_sha512_append,
    @fd_sha512_fini := fd_sha512_fini, @fd_sha512_init := fd_sha512_init

end

end MLIR.Firedancer.Crc.Verify
