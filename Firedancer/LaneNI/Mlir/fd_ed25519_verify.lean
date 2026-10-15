
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.LaneNI.Mlir.fd_curve25519_scalar_validate_144
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_frombytes_2x
public import Firedancer.LaneNI.Mlir.fd_ed25519_affine_is_small_order_145
public import Firedancer.LaneNI.Mlir.fd_ed25519_affine_is_small_order_145
public import Firedancer.LaneNI.Mlir.fd_sha512_init
public import Firedancer.LaneNI.Mlir.fd_sha512_append
public import Firedancer.LaneNI.Mlir.fd_sha512_append
public import Firedancer.LaneNI.Mlir.fd_sha512_append
public import Firedancer.LaneNI.Mlir.fd_sha512_fini
public import Firedancer.LaneNI.Mlir.fd_curve25519_scalar_reduce
public import Firedancer.LaneNI.Mlir.fd_ed25519_verify_equation

namespace Firedancer.LaneNI.Mlir

@[expose] public section

noncomputable mlir_def fd_ed25519_verify := "llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.align = 1 : i64, llvm.dereferenceable = 64 : i64, llvm.noundef}, {llvm.align = 1 : i64, llvm.dereferenceable = 32 : i64, llvm.noundef}, {llvm.noundef}], frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<i32 (ptr, i64, ptr, ptr, ptr)>, linkage = #llvm.linkage<external>, no_inline, no_unwind, passthrough = ["sspstrong", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], res_attrs = [{llvm.range = #llvm.constant_range<i32, -3, 1>}], sym_name = "fd_ed25519_verify", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr, %arg1: i64, %arg2: !llvm.ptr, %arg3: !llvm.ptr, %arg4: !llvm.ptr):
  %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %2 = "llvm.mlir.zero"() : () -> !llvm.ptr
  %3 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
  %4 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %5 = "llvm.mlir.constant"() <{value = -2 : i32}> : () -> i32
  %6 = "llvm.mlir.constant"() <{value = -3 : i32}> : () -> i32
  %7 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_curve25519_edwards", (vector<8xi64>, vector<8xi64>, vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %8 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_curve25519_edwards", (vector<8xi64>, vector<8xi64>, vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %9 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.array<64 x i8>}> : (i32) -> !llvm.ptr
  %10 = "llvm.getelementptr"(%arg2) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %11 = "llvm.call"(%10) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_curve25519_scalar_validate.144, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> !llvm.ptr
  %12 = "llvm.icmp"(%11, %2) <{predicate = 0 : i64}> : (!llvm.ptr, !llvm.ptr) -> i1
  "llvm.cond_br"(%12, %3)[^bb7, ^bb1] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i32) -> ()
^bb1:  // pred: ^bb0
  "llvm.intr.lifetime.start"(%7) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%8) : (!llvm.ptr) -> ()
  %13 = "llvm.call"(%7, %arg3, %8, %arg2) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_ed25519_point_frombytes_2x, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> i32
  %14 = "llvm.icmp"(%13, %4) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%14)[^bb3, ^bb2] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb2:  // pred: ^bb1
  %15 = "llvm.icmp"(%13, %3) <{predicate = 0 : i64}> : (i32, i32) -> i1
  %16 = "llvm.select"(%15, %5, %3) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i32, i32) -> i32
  "llvm.br"(%16)[^bb6] : (i32) -> ()
^bb3:  // pred: ^bb1
  %17 = "llvm.call"(%7) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_ed25519_affine_is_small_order.145, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i32
  %18 = "llvm.icmp"(%17, %4) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%18, %5)[^bb4, ^bb6] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb4:  // pred: ^bb3
  %19 = "llvm.call"(%8) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_ed25519_affine_is_small_order.145, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i32
  %20 = "llvm.icmp"(%19, %4) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%20, %3)[^bb5, ^bb6] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb5:  // pred: ^bb4
  "llvm.intr.lifetime.start"(%9) : (!llvm.ptr) -> ()
  %21 = "llvm.call"(%arg4) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_sha512_init, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> !llvm.ptr
  %22 = "llvm.call"(%21, %arg2, %1) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_append, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %23 = "llvm.call"(%22, %arg3, %1) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_append, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %24 = "llvm.call"(%23, %arg0, %arg1) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_append, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %25 = "llvm.call"(%24, %9) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_sha512_fini, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %26 = "llvm.call"(%9, %9) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_curve25519_scalar_reduce, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %27 = "llvm.call"(%9, %7, %10, %8) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_verify_equation, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> i32
  %28 = "llvm.icmp"(%27, %4) <{predicate = 0 : i64}> : (i32, i32) -> i1
  %29 = "llvm.select"(%28, %6, %4) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i32, i32) -> i32
  "llvm.intr.lifetime.end"(%9) : (!llvm.ptr) -> ()
  "llvm.br"(%29)[^bb6] : (i32) -> ()
^bb6(%30: i32):  // 4 preds: ^bb2, ^bb3, ^bb4, ^bb5
  "llvm.intr.lifetime.end"(%8) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%7) : (!llvm.ptr) -> ()
  "llvm.br"(%30)[^bb7] : (i32) -> ()
^bb7(%31: i32):  // 2 preds: ^bb0, ^bb6
  "llvm.return"(%31) : (i32) -> ()
}) : () -> ()

    with
      @fd_curve25519_scalar_validate.144 := Firedancer.LaneNI.Mlir.fd_curve25519_scalar_validate_144,
      @fd_ed25519_point_frombytes_2x := Firedancer.LaneNI.Mlir.fd_ed25519_point_frombytes_2x,
      @fd_ed25519_affine_is_small_order.145 := Firedancer.LaneNI.Mlir.fd_ed25519_affine_is_small_order_145,
      @fd_ed25519_affine_is_small_order.145 := Firedancer.LaneNI.Mlir.fd_ed25519_affine_is_small_order_145,
      @fd_sha512_init := Firedancer.LaneNI.Mlir.fd_sha512_init,
      @fd_sha512_append := Firedancer.LaneNI.Mlir.fd_sha512_append,
      @fd_sha512_append := Firedancer.LaneNI.Mlir.fd_sha512_append,
      @fd_sha512_append := Firedancer.LaneNI.Mlir.fd_sha512_append,
      @fd_sha512_fini := Firedancer.LaneNI.Mlir.fd_sha512_fini,
      @fd_curve25519_scalar_reduce := Firedancer.LaneNI.Mlir.fd_curve25519_scalar_reduce,
      @fd_ed25519_verify_equation := Firedancer.LaneNI.Mlir.fd_ed25519_verify_equation

end

end Firedancer.LaneNI.Mlir
