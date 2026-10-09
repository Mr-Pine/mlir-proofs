module

-- ~/fd-pr9879/build/llvm23-production/mlir_canonicalized/avx512/op/fd_ed25519_verify.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.R52x5.Mlir.fd_curve25519_scalar_reduce
public import Firedancer.R52x5.Mlir.fd_curve25519_scalar_validate
public import Firedancer.R52x5.Mlir.fd_ed25519_affine_is_small_order
public import Firedancer.R52x5.Mlir.fd_ed25519_double_scalar_mul_base
public import Firedancer.R52x5.Mlir.fd_ed25519_point_affine_eq
public import Firedancer.R52x5.Mlir.fd_ed25519_point_frombytes_2x
public import Firedancer.R52x5.Mlir.fd_ed25519_point_neg
public import Firedancer.R52x5.Mlir.fd_sha512_append
public import Firedancer.R52x5.Mlir.fd_sha512_fini
public import Firedancer.R52x5.Mlir.fd_sha512_init

meta import MLIR.Semantics.Func
meta import Firedancer.R52x5.Mlir.fd_curve25519_scalar_reduce
meta import Firedancer.R52x5.Mlir.fd_curve25519_scalar_validate
meta import Firedancer.R52x5.Mlir.fd_ed25519_affine_is_small_order
meta import Firedancer.R52x5.Mlir.fd_ed25519_double_scalar_mul_base
meta import Firedancer.R52x5.Mlir.fd_ed25519_point_affine_eq
meta import Firedancer.R52x5.Mlir.fd_ed25519_point_frombytes_2x
meta import Firedancer.R52x5.Mlir.fd_ed25519_point_neg
meta import Firedancer.R52x5.Mlir.fd_sha512_append
meta import Firedancer.R52x5.Mlir.fd_sha512_fini
meta import Firedancer.R52x5.Mlir.fd_sha512_init

namespace MLIR.Firedancer.R52x5

@[expose] public section

noncomputable mlir_def fd_ed25519_verify :=
"llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.align = 1 : i64, llvm.dereferenceable = 64 : i64, llvm.noundef}, {llvm.align = 1 : i64, llvm.dereferenceable = 32 : i64, llvm.noundef}, {llvm.noundef}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<i32 (ptr, i64, ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, no_inline, no_unwind, passthrough = ["sspstrong", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], res_attrs = [{llvm.range = #llvm.constant_range<i32, -3, 1>}], sym_name = "fd_ed25519_verify", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg31: !llvm.ptr, %arg32: i64, %arg33: !llvm.ptr, %arg34: !llvm.ptr, %arg35: !llvm.ptr):
  %298 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %299 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %300 = "llvm.mlir.zero"() : () -> !llvm.ptr
  %301 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
  %302 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %303 = "llvm.mlir.constant"() <{value = -2 : i32}> : () -> i32
  %304 = "llvm.mlir.constant"() <{value = -3 : i32}> : () -> i32
  %305 = "llvm.alloca"(%298) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_curve25519_edwards", (vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, array<32 x i8>)>>}> : (i32) -> !llvm.ptr
  %306 = "llvm.alloca"(%298) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_curve25519_edwards", (vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, array<32 x i8>)>>}> : (i32) -> !llvm.ptr
  %307 = "llvm.alloca"(%298) <{alignment = 16 : i64, elem_type = !llvm.array<64 x i8>}> : (i32) -> !llvm.ptr
  %308 = "llvm.alloca"(%298) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_curve25519_edwards", (vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, array<32 x i8>)>>}> : (i32) -> !llvm.ptr
  %309 = "llvm.getelementptr"(%arg33) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %310 = "llvm.call"(%309) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_curve25519_scalar_validate, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> !llvm.ptr
  %311 = "llvm.icmp"(%310, %300) <{predicate = 0 : i64}> : (!llvm.ptr, !llvm.ptr) -> i1
  "llvm.cond_br"(%311, %301)[^bb7, ^bb1] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i32) -> ()
^bb1:  // pred: ^bb0
  "llvm.intr.lifetime.start"(%305) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%306) : (!llvm.ptr) -> ()
  %312 = "llvm.call"(%305, %arg34, %306, %arg33) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_ed25519_point_frombytes_2x, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> i32
  %313 = "llvm.icmp"(%312, %302) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%313)[^bb3, ^bb2] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb2:  // pred: ^bb1
  %314 = "llvm.icmp"(%312, %301) <{predicate = 0 : i64}> : (i32, i32) -> i1
  %315 = "llvm.select"(%314, %303, %301) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i32, i32) -> i32
  "llvm.br"(%315)[^bb6] : (i32) -> ()
^bb3:  // pred: ^bb1
  %316 = "llvm.call"(%305) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_ed25519_affine_is_small_order, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i32
  %317 = "llvm.icmp"(%316, %302) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%317, %303)[^bb4, ^bb6] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb4:  // pred: ^bb3
  %318 = "llvm.call"(%306) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_ed25519_affine_is_small_order, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i32
  %319 = "llvm.icmp"(%318, %302) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%319, %301)[^bb5, ^bb6] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb5:  // pred: ^bb4
  "llvm.intr.lifetime.start"(%307) : (!llvm.ptr) -> ()
  %320 = "llvm.call"(%arg35) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_sha512_init, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> !llvm.ptr
  %321 = "llvm.call"(%arg35, %arg33, %299) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_append, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %322 = "llvm.call"(%arg35, %arg34, %299) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_append, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %323 = "llvm.call"(%arg35, %arg31, %arg32) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_append, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %324 = "llvm.call"(%arg35, %307) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_sha512_fini, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %325 = "llvm.call"(%307, %307) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_curve25519_scalar_reduce, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%308) : (!llvm.ptr) -> ()
  %326 = "llvm.call"(%305, %305) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_ed25519_point_neg, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %327 = "llvm.call"(%308, %307, %305, %309) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_ed25519_double_scalar_mul_base, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %328 = "llvm.call"(%308, %306) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_affine_eq, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> i32
  %329 = "llvm.icmp"(%328, %302) <{predicate = 0 : i64}> : (i32, i32) -> i1
  %330 = "llvm.select"(%329, %304, %302) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i32, i32) -> i32
  "llvm.intr.lifetime.end"(%308) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%307) : (!llvm.ptr) -> ()
  "llvm.br"(%330)[^bb6] : (i32) -> ()
^bb6(%331: i32):  // 4 preds: ^bb2, ^bb3, ^bb4, ^bb5
  "llvm.intr.lifetime.end"(%306) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%305) : (!llvm.ptr) -> ()
  "llvm.br"(%331)[^bb7] : (i32) -> ()
^bb7(%332: i32):  // 2 preds: ^bb0, ^bb6
  "llvm.return"(%332) : (i32) -> ()
}) : () -> ()
  with @fd_curve25519_scalar_reduce := fd_curve25519_scalar_reduce,
    @fd_curve25519_scalar_validate := fd_curve25519_scalar_validate,
    @fd_ed25519_affine_is_small_order := fd_ed25519_affine_is_small_order,
    @fd_ed25519_double_scalar_mul_base := fd_ed25519_double_scalar_mul_base,
    @fd_ed25519_point_affine_eq := fd_ed25519_point_affine_eq,
    @fd_ed25519_point_frombytes_2x := fd_ed25519_point_frombytes_2x,
    @fd_ed25519_point_neg := fd_ed25519_point_neg, @fd_sha512_append := fd_sha512_append,
    @fd_sha512_fini := fd_sha512_fini, @fd_sha512_init := fd_sha512_init

end

end MLIR.Firedancer.R52x5
