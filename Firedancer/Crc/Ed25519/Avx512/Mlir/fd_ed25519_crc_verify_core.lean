module

-- crc/out/mlirproofs/regions/verify/fd_ed25519_crc_verify_core.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Crc.Ed25519.Extern.fd_curve25519_scalar_reduce
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_curve25519_scalar_validate
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_memeq
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_affine_is_small_order
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_double_scalar_mul_base
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_double_scalar_mul_base_split
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_encode_canon
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_ge_affine_canon
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_ge_decode1
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_ge_decode2
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_ge_eq_z1
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_ge_is_small_order_affine
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_neg
public import Firedancer.Crc.Ed25519.Extern.fd_sha512_append
public import Firedancer.Crc.Ed25519.Extern.fd_sha512_fini
public import Firedancer.Crc.Ed25519.Extern.fd_sha512_init

meta import MLIR.Semantics.Func
meta import Firedancer.Crc.Ed25519.Extern.fd_curve25519_scalar_reduce
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_curve25519_scalar_validate
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_memeq
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_affine_is_small_order
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_double_scalar_mul_base
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_double_scalar_mul_base_split
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_encode_canon
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_ge_affine_canon
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_ge_decode1
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_ge_decode2
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_ge_eq_z1
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_ge_is_small_order_affine
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_neg
meta import Firedancer.Crc.Ed25519.Extern.fd_sha512_append
meta import Firedancer.Crc.Ed25519.Extern.fd_sha512_fini
meta import Firedancer.Crc.Ed25519.Extern.fd_sha512_init

namespace MLIR.Firedancer.Crc.Ed25519.Avx512

@[expose] public section

noncomputable mlir_def fd_ed25519_crc_verify_core :=
"llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.noundef}, {llvm.noundef, llvm.writeonly}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<i32 (ptr, i64, ptr, ptr, ptr, ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, no_inline, no_unwind, passthrough = ["sspstrong", ["min-legal-vector-width", "256"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], res_attrs = [{llvm.range = #llvm.constant_range<i32, -2, 1>}], sym_name = "fd_ed25519_crc_verify_core", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg213: !llvm.ptr, %arg214: i64, %arg215: !llvm.ptr, %arg216: !llvm.ptr, %arg217: !llvm.ptr, %arg218: !llvm.ptr, %arg219: !llvm.ptr, %arg220: !llvm.ptr):
  %3460 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %3461 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %3462 = "llvm.mlir.zero"() : () -> !llvm.ptr
  %3463 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
  %3464 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %3465 = "llvm.mlir.constant"() <{value = -2 : i32}> : () -> i32
  %3466 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %3467 = "llvm.mlir.constant"() <{value = 160 : i64}> : () -> i64
  %3468 = "llvm.alloca"(%3460) <{alignment = 32 : i64, elem_type = !llvm.struct<"struct.fd_r52x5_ge", (vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>)>}> : (i32) -> !llvm.ptr
  %3469 = "llvm.alloca"(%3460) <{alignment = 32 : i64, elem_type = !llvm.struct<"struct.fd_r52x5_ge", (vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>)>}> : (i32) -> !llvm.ptr
  %3470 = "llvm.alloca"(%3460) <{alignment = 32 : i64, elem_type = !llvm.struct<"struct.fd_r52x5_ge", (vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>)>}> : (i32) -> !llvm.ptr
  %3471 = "llvm.alloca"(%3460) <{alignment = 16 : i64, elem_type = !llvm.array<64 x i8>}> : (i32) -> !llvm.ptr
  %3472 = "llvm.alloca"(%3460) <{alignment = 16 : i64, elem_type = !llvm.array<5 x i64>}> : (i32) -> !llvm.ptr
  %3473 = "llvm.alloca"(%3460) <{alignment = 16 : i64, elem_type = !llvm.array<5 x i64>}> : (i32) -> !llvm.ptr
  %3474 = "llvm.alloca"(%3460) <{alignment = 16 : i64, elem_type = !llvm.array<32 x i8>}> : (i32) -> !llvm.ptr
  %3475 = "llvm.alloca"(%3460) <{alignment = 16 : i64, elem_type = !llvm.array<64 x i8>}> : (i32) -> !llvm.ptr
  %3476 = "llvm.alloca"(%3460) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3477 = "llvm.alloca"(%3460) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3478 = "llvm.alloca"(%3460) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3479 = "llvm.alloca"(%3460) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3480 = "llvm.alloca"(%3460) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3481 = "llvm.getelementptr"(%arg215) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %3482 = "llvm.call"(%3481) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @fd_curve25519_scalar_validate, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> !llvm.ptr
  %3483 = "llvm.icmp"(%3482, %3462) <{predicate = 0 : i64}> : (!llvm.ptr, !llvm.ptr) -> i1
  "llvm.cond_br"(%3483, %3463)[^bb21, ^bb1] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i32) -> ()
^bb1:  // pred: ^bb0
  "llvm.intr.lifetime.start"(%3468) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3469) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3470) : (!llvm.ptr) -> ()
  %3484 = "llvm.icmp"(%arg218, %3462) <{predicate = 0 : i64}> : (!llvm.ptr, !llvm.ptr) -> i1
  "llvm.cond_br"(%3484)[^bb12, ^bb2] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb2:  // pred: ^bb1
  %3485 = "llvm.load"(%arg219) <{alignment = 4 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %3486 = "llvm.icmp"(%3485, %3464) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%3486)[^bb3, ^bb5] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb3:  // pred: ^bb2
  %3487 = "llvm.call"(%3469, %arg215) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_r52x5_ge_decode1, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> i32
  %3488 = "llvm.icmp"(%3487, %3464) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%3488, %3463)[^bb20, ^bb4] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i32) -> ()
^bb4:  // pred: ^bb3
  %3489 = "llvm.call"(%3469) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_r52x5_ge_is_small_order_affine, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i32
  %3490 = "llvm.sub"(%3464, %3489) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  "llvm.br"(%3490)[^bb20] : (i32) -> ()
^bb5:  // pred: ^bb2
  "llvm.intr.lifetime.start"(%3471) : (!llvm.ptr) -> ()
  %3491 = "llvm.call"(%arg217) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_sha512_init, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> !llvm.ptr
  %3492 = "llvm.call"(%3491, %arg215, %3461) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_append, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %3493 = "llvm.call"(%3492, %arg216, %3461) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_append, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %3494 = "llvm.call"(%3493, %arg213, %arg214) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_append, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %3495 = "llvm.call"(%3494, %3471) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_sha512_fini, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %3496 = "llvm.call"(%3471, %3471) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_curve25519_scalar_reduce, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.call"(%3470, %3471, %arg218, %3481) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_r52x5_double_scalar_mul_base_split, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3472) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3473) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3474) : (!llvm.ptr) -> ()
  "llvm.call"(%3472, %3473, %3470) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_ge_affine_canon, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%3474, %3472, %3473) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_encode_canon, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  %3497 = "llvm.call"(%3474, %arg215) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_memeq, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> i32
  %3498 = "llvm.icmp"(%3497, %3464) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%3498)[^bb7, ^bb6] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb6:  // pred: ^bb5
  %3499 = "llvm.call"(%3472, %3473) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_affine_is_small_order, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> i32
  %3500 = "llvm.icmp"(%3499, %3464) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%3500, %3460, %3463)[^bb10, ^bb11] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 1, 1>}> : (i1, i32, i32) -> ()
^bb7:  // pred: ^bb5
  %3501 = "llvm.call"(%3469, %arg215) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_r52x5_ge_decode1, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> i32
  %3502 = "llvm.icmp"(%3501, %3464) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%3502, %3463)[^bb11, ^bb8] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i32) -> ()
^bb8:  // pred: ^bb7
  %3503 = "llvm.call"(%3469) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_r52x5_ge_is_small_order_affine, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i32
  %3504 = "llvm.icmp"(%3503, %3464) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%3504, %3463)[^bb9, ^bb11] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb9:  // pred: ^bb8
  %3505 = "llvm.call"(%3470, %3469) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_ge_eq_z1, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> i32
  "llvm.br"(%3505)[^bb10] : (i32) -> ()
^bb10(%3506: i32):  // 2 preds: ^bb6, ^bb9
  "llvm.store"(%3506, %arg219) <{alignment = 4 : i64, ordering = 0 : i64}> : (i32, !llvm.ptr) -> ()
  "llvm.br"(%3464)[^bb11] : (i32) -> ()
^bb11(%3507: i32):  // 4 preds: ^bb6, ^bb7, ^bb8, ^bb10
  "llvm.intr.lifetime.end"(%3474) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3473) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3472) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3471) : (!llvm.ptr) -> ()
  "llvm.br"(%3507)[^bb20] : (i32) -> ()
^bb12:  // pred: ^bb1
  %3508 = "llvm.call"(%3468, %arg216, %3469, %arg215) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_r52x5_ge_decode2, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> i32
  %3509 = "llvm.and"(%3508, %3460) : (i32, i32) -> i32
  %3510 = "llvm.icmp"(%3509, %3464) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%3510, %3465)[^bb20, ^bb13] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i32) -> ()
^bb13:  // pred: ^bb12
  %3511 = "llvm.icmp"(%3508, %3466) <{predicate = 6 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%3511, %3463)[^bb20, ^bb14] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i32) -> ()
^bb14:  // pred: ^bb13
  %3512 = "llvm.call"(%3468) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_r52x5_ge_is_small_order_affine, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i32
  %3513 = "llvm.icmp"(%3512, %3464) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%3513, %3465)[^bb15, ^bb20] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb15:  // pred: ^bb14
  %3514 = "llvm.call"(%3469) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_r52x5_ge_is_small_order_affine, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i32
  %3515 = "llvm.icmp"(%3514, %3464) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%3515, %3463)[^bb16, ^bb20] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb16:  // pred: ^bb15
  %3516 = "llvm.load"(%arg219) <{alignment = 4 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %3517 = "llvm.icmp"(%3516, %3464) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%3517, %3464)[^bb20, ^bb17] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i32) -> ()
^bb17:  // pred: ^bb16
  "llvm.intr.lifetime.start"(%3475) : (!llvm.ptr) -> ()
  %3518 = "llvm.call"(%arg217) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_sha512_init, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> !llvm.ptr
  %3519 = "llvm.call"(%3518, %arg215, %3461) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_append, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %3520 = "llvm.call"(%3519, %arg216, %3461) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_append, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %3521 = "llvm.call"(%3520, %arg213, %arg214) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_append, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %3522 = "llvm.call"(%3521, %3475) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_sha512_fini, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %3523 = "llvm.call"(%3475, %3475) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_curve25519_scalar_reduce, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %3524 = "llvm.load"(%3468) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3525 = "llvm.getelementptr"(%3468) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %3526 = "llvm.load"(%3525) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3527 = "llvm.getelementptr"(%3468) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %3528 = "llvm.load"(%3527) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3529 = "llvm.getelementptr"(%3468) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %3530 = "llvm.load"(%3529) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3531 = "llvm.getelementptr"(%3468) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %3532 = "llvm.load"(%3531) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%3476) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3477) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3478) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3479) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3480) : (!llvm.ptr) -> ()
  "llvm.call"(%3476, %3477, %3478, %3479, %3480, %3524, %3526, %3528, %3530, %3532) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_neg, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %3533 = "llvm.load"(%3476) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<32xi8>
  %3534 = "llvm.load"(%3477) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<32xi8>
  %3535 = "llvm.load"(%3478) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<32xi8>
  %3536 = "llvm.load"(%3479) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<32xi8>
  %3537 = "llvm.load"(%3480) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<32xi8>
  "llvm.intr.lifetime.end"(%3480) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3479) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3478) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3477) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3476) : (!llvm.ptr) -> ()
  %3538 = "llvm.bitcast"(%3524) : (vector<4xi64>) -> vector<32xi8>
  %3539 = "llvm.shufflevector"(%3533, %3538) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 24, 25, 26, 27, 28, 29, 30, 31>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3540 = "llvm.bitcast"(%3526) : (vector<4xi64>) -> vector<32xi8>
  %3541 = "llvm.shufflevector"(%3534, %3540) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 24, 25, 26, 27, 28, 29, 30, 31>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3542 = "llvm.bitcast"(%3528) : (vector<4xi64>) -> vector<32xi8>
  %3543 = "llvm.shufflevector"(%3535, %3542) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 24, 25, 26, 27, 28, 29, 30, 31>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3544 = "llvm.bitcast"(%3530) : (vector<4xi64>) -> vector<32xi8>
  %3545 = "llvm.shufflevector"(%3536, %3544) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 24, 25, 26, 27, 28, 29, 30, 31>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3546 = "llvm.bitcast"(%3532) : (vector<4xi64>) -> vector<32xi8>
  %3547 = "llvm.shufflevector"(%3537, %3546) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 24, 25, 26, 27, 28, 29, 30, 31>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  "llvm.store"(%3539, %3468) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<32xi8>, !llvm.ptr) -> ()
  "llvm.store"(%3541, %3525) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<32xi8>, !llvm.ptr) -> ()
  "llvm.store"(%3543, %3527) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<32xi8>, !llvm.ptr) -> ()
  "llvm.store"(%3545, %3529) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<32xi8>, !llvm.ptr) -> ()
  "llvm.store"(%3547, %3531) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<32xi8>, !llvm.ptr) -> ()
  "llvm.call"(%3470, %3475, %3468, %3481) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_r52x5_double_scalar_mul_base, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  %3548 = "llvm.call"(%3470, %3469) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_ge_eq_z1, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> i32
  "llvm.store"(%3548, %arg219) <{alignment = 4 : i64, ordering = 0 : i64}> : (i32, !llvm.ptr) -> ()
  %3549 = "llvm.icmp"(%arg220, %3462) <{predicate = 0 : i64}> : (!llvm.ptr, !llvm.ptr) -> i1
  "llvm.cond_br"(%3549)[^bb19, ^bb18] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb18:  // pred: ^bb17
  "llvm.intr.memcpy"(%arg220, %3468, %3467) <{arg_attrs = [{llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.br"()[^bb19] : () -> ()
^bb19:  // 2 preds: ^bb17, ^bb18
  "llvm.intr.lifetime.end"(%3475) : (!llvm.ptr) -> ()
  "llvm.br"(%3464)[^bb20] : (i32) -> ()
^bb20(%3550: i32):  // 9 preds: ^bb3, ^bb4, ^bb11, ^bb12, ^bb13, ^bb14, ^bb15, ^bb16, ^bb19
  "llvm.intr.lifetime.end"(%3470) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3469) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3468) : (!llvm.ptr) -> ()
  "llvm.br"(%3550)[^bb21] : (i32) -> ()
^bb21(%3551: i32):  // 2 preds: ^bb0, ^bb20
  "llvm.return"(%3551) : (i32) -> ()
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

end MLIR.Firedancer.Crc.Ed25519.Avx512
