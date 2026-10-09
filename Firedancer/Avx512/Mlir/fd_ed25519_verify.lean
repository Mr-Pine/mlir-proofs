module

-- build/llvm23/mlir_canonicalized/avx512/op/fd_ed25519_verify.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Ref.Mlir.fd_curve25519_scalar_reduce
public import Firedancer.Ref.Mlir.fd_curve25519_scalar_validate
public import Firedancer.Avx512.Mlir.fd_ed25519_affine_is_small_order
public import Firedancer.Avx512.Mlir.fd_ed25519_double_scalar_mul_base
public import Firedancer.Avx512.Mlir.fd_ed25519_point_eq_z1
public import Firedancer.Avx512.Mlir.fd_ed25519_point_frombytes_2x
public import Firedancer.Avx512.Mlir.fd_ed25519_point_neg
public import Firedancer.Ref.Mlir.fd_sha512_append
public import Firedancer.Ref.Mlir.fd_sha512_fini
public import Firedancer.Ref.Mlir.fd_sha512_init

meta import MLIR.Semantics.Func
meta import Firedancer.Ref.Mlir.fd_curve25519_scalar_reduce
meta import Firedancer.Ref.Mlir.fd_curve25519_scalar_validate
meta import Firedancer.Avx512.Mlir.fd_ed25519_affine_is_small_order
meta import Firedancer.Avx512.Mlir.fd_ed25519_double_scalar_mul_base
meta import Firedancer.Avx512.Mlir.fd_ed25519_point_eq_z1
meta import Firedancer.Avx512.Mlir.fd_ed25519_point_frombytes_2x
meta import Firedancer.Avx512.Mlir.fd_ed25519_point_neg
meta import Firedancer.Ref.Mlir.fd_sha512_append
meta import Firedancer.Ref.Mlir.fd_sha512_fini
meta import Firedancer.Ref.Mlir.fd_sha512_init

namespace MLIR.Firedancer.Avx512

@[expose] public section

noncomputable mlir_def fd_ed25519_verify :=
"llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.noundef}, {llvm.align = 1 : i64, llvm.dereferenceable = 64 : i64, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.align = 1 : i64, llvm.dereferenceable = 32 : i64, llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.nofree, llvm.noundef}], dso_local, function_type = !llvm.func<i32 (ptr, i64, ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], res_attrs = [{llvm.range = #llvm.constant_range<i32, -3, 1>}], sym_name = "fd_ed25519_verify", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg43: !llvm.ptr, %arg44: i64, %arg45: !llvm.ptr, %arg46: !llvm.ptr, %arg47: !llvm.ptr):
  %702 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %703 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %704 = "llvm.mlir.zero"() : () -> !llvm.ptr
  %705 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
  %706 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %707 = "llvm.mlir.constant"() <{value = -2 : i32}> : () -> i32
  %708 = "llvm.mlir.constant"() <{value = -3 : i32}> : () -> i32
  %709 = "llvm.alloca"(%702) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_curve25519_edwards", (vector<8xi64>, vector<8xi64>, vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %710 = "llvm.alloca"(%702) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_curve25519_edwards", (vector<8xi64>, vector<8xi64>, vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %711 = "llvm.alloca"(%702) <{alignment = 16 : i64, elem_type = !llvm.array<64 x i8>}> : (i32) -> !llvm.ptr
  %712 = "llvm.alloca"(%702) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_curve25519_edwards", (vector<8xi64>, vector<8xi64>, vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %713 = "llvm.getelementptr"(%arg45) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %714 = "llvm.call"(%713) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_curve25519_scalar_validate, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> !llvm.ptr
  %715 = "llvm.icmp"(%714, %704) <{predicate = 0 : i64}> : (!llvm.ptr, !llvm.ptr) -> i1
  "llvm.cond_br"(%715, %705)[^bb7, ^bb1] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i32) -> ()
^bb1:  // pred: ^bb0
  "llvm.intr.lifetime.start"(%709) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%710) : (!llvm.ptr) -> ()
  %716 = "llvm.call"(%709, %arg46, %710, %arg45) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_ed25519_point_frombytes_2x, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> i32
  %717 = "llvm.icmp"(%716, %706) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%717)[^bb3, ^bb2] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb2:  // pred: ^bb1
  %718 = "llvm.icmp"(%716, %705) <{predicate = 0 : i64}> : (i32, i32) -> i1
  %719 = "llvm.select"(%718, %707, %705) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i32, i32) -> i32
  "llvm.br"(%719)[^bb6] : (i32) -> ()
^bb3:  // pred: ^bb1
  %720 = "llvm.call"(%709) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_ed25519_affine_is_small_order, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i32
  %721 = "llvm.icmp"(%720, %706) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%721, %707)[^bb4, ^bb6] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb4:  // pred: ^bb3
  %722 = "llvm.call"(%710) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_ed25519_affine_is_small_order, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i32
  %723 = "llvm.icmp"(%722, %706) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%723, %705)[^bb5, ^bb6] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb5:  // pred: ^bb4
  "llvm.intr.lifetime.start"(%711) : (!llvm.ptr) -> ()
  %724 = "llvm.call"(%arg47) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_sha512_init, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> !llvm.ptr
  %725 = "llvm.call"(%arg47, %arg45, %703) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_append, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %726 = "llvm.call"(%arg47, %arg46, %703) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_append, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %727 = "llvm.call"(%arg47, %arg43, %arg44) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_append, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %728 = "llvm.call"(%arg47, %711) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_sha512_fini, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %729 = "llvm.call"(%711, %711) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_curve25519_scalar_reduce, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%712) : (!llvm.ptr) -> ()
  %730 = "llvm.call"(%709, %709) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_ed25519_point_neg, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %731 = "llvm.call"(%712, %711, %709, %713) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_ed25519_double_scalar_mul_base, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %732 = "llvm.call"(%712, %710) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_eq_z1, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> i32
  %733 = "llvm.icmp"(%732, %706) <{predicate = 0 : i64}> : (i32, i32) -> i1
  %734 = "llvm.select"(%733, %708, %706) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i32, i32) -> i32
  "llvm.intr.lifetime.end"(%712) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%711) : (!llvm.ptr) -> ()
  "llvm.br"(%734)[^bb6] : (i32) -> ()
^bb6(%735: i32):  // 4 preds: ^bb2, ^bb3, ^bb4, ^bb5
  "llvm.intr.lifetime.end"(%710) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%709) : (!llvm.ptr) -> ()
  "llvm.br"(%735)[^bb7] : (i32) -> ()
^bb7(%736: i32):  // 2 preds: ^bb0, ^bb6
  "llvm.return"(%736) : (i32) -> ()
}) : () -> ()
  with @fd_curve25519_scalar_reduce := Ref.fd_curve25519_scalar_reduce,
    @fd_curve25519_scalar_validate := Ref.fd_curve25519_scalar_validate,
    @fd_ed25519_affine_is_small_order := fd_ed25519_affine_is_small_order,
    @fd_ed25519_double_scalar_mul_base := fd_ed25519_double_scalar_mul_base,
    @fd_ed25519_point_eq_z1 := fd_ed25519_point_eq_z1,
    @fd_ed25519_point_frombytes_2x := fd_ed25519_point_frombytes_2x,
    @fd_ed25519_point_neg := fd_ed25519_point_neg, @fd_sha512_append := Ref.fd_sha512_append,
    @fd_sha512_fini := Ref.fd_sha512_fini, @fd_sha512_init := Ref.fd_sha512_init

end

end MLIR.Firedancer.Avx512
