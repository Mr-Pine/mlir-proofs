
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.Crc.Ref.Mlir.fd_curve25519_scalar_validate
public import Firedancer.Crc.Ref.Mlir.crc_adx_point_decode1
public import Firedancer.Crc.Ref.Mlir.crc_adx_point_is_small_order_affine
public import Firedancer.Crc.Ref.Mlir.fd_sha512_init
public import Firedancer.Crc.Ref.Mlir.fd_sha512_append
public import Firedancer.Crc.Ref.Mlir.fd_sha512_append
public import Firedancer.Crc.Ref.Mlir.fd_sha512_append
public import Firedancer.Crc.Ref.Mlir.fd_sha512_fini
public import Firedancer.Crc.Ref.Mlir.fd_curve25519_scalar_reduce
public import Firedancer.Crc.Ref.Mlir.crc_adx_double_scalar_mul_base_split
public import Firedancer.Crc.Ref.Mlir.crc_adx_point_affine_canon
public import Firedancer.Crc.Ref.Mlir.crc_adx_encode_canon
public import Firedancer.Crc.Ref.Mlir.fd_memeq
public import Firedancer.Crc.Ref.Mlir.crc_adx_affine_is_small_order
public import Firedancer.Crc.Ref.Mlir.crc_adx_point_decode1
public import Firedancer.Crc.Ref.Mlir.crc_adx_point_is_small_order_affine
public import Firedancer.Crc.Ref.Mlir.crc_adx_point_eq_z1
public import Firedancer.Crc.Ref.Mlir.crc_adx_point_decode1
public import Firedancer.Crc.Ref.Mlir.crc_adx_point_is_small_order_affine
public import Firedancer.Crc.Ref.Mlir.crc_adx_point_decode1
public import Firedancer.Crc.Ref.Mlir.crc_adx_point_decode1
public import Firedancer.Crc.Ref.Mlir.crc_adx_point_is_small_order_affine
public import Firedancer.Crc.Ref.Mlir.fd_sha512_init
public import Firedancer.Crc.Ref.Mlir.fd_sha512_append
public import Firedancer.Crc.Ref.Mlir.fd_sha512_append
public import Firedancer.Crc.Ref.Mlir.fd_sha512_append
public import Firedancer.Crc.Ref.Mlir.fd_sha512_fini
public import Firedancer.Crc.Ref.Mlir.fd_curve25519_scalar_reduce
public import Firedancer.Crc.Ref.Mlir.crc_adx_point_neg
public import Firedancer.Crc.Ref.Mlir.crc_adx_double_scalar_mul_base
public import Firedancer.Crc.Ref.Mlir.crc_adx_point_affine_canon
public import Firedancer.Crc.Ref.Mlir.crc_adx_encode_canon
public import Firedancer.Crc.Ref.Mlir.fd_memeq
public import Firedancer.Crc.Ref.Mlir.crc_adx_affine_is_small_order
public import Firedancer.Crc.Ref.Mlir.crc_adx_point_decode1
public import Firedancer.Crc.Ref.Mlir.crc_adx_point_is_small_order_affine
public import Firedancer.Crc.Ref.Mlir.crc_adx_point_eq_z1

namespace MLIR.Firedancer.Crc.Ref

@[expose] public section

noncomputable mlir_def crc_adx_verify_core := "llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.nofree, llvm.noundef}, {llvm.nofree, llvm.noundef, llvm.writeonly}], function_type = !llvm.func<i32 (ptr, i64, ptr, ptr, ptr, ptr, ptr, ptr)>, linkage = #llvm.linkage<external>, no_inline, no_unwind, passthrough = [["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], res_attrs = [{llvm.range = #llvm.constant_range<i32, -2, 1>}], sym_name = "crc_adx_verify_core", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr, %arg1: i64, %arg2: !llvm.ptr, %arg3: !llvm.ptr, %arg4: !llvm.ptr, %arg5: !llvm.ptr, %arg6: !llvm.ptr, %arg7: !llvm.ptr):
  %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %2 = "llvm.mlir.zero"() : () -> !llvm.ptr
  %3 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
  %4 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %5 = "llvm.mlir.constant"() <{value = -2 : i32}> : () -> i32
  %6 = "llvm.mlir.constant"() <{value = 128 : i64}> : () -> i64
  %7 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.array<16 x i64>}> : (i32) -> !llvm.ptr
  %8 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.array<16 x i64>}> : (i32) -> !llvm.ptr
  %9 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.array<16 x i64>}> : (i32) -> !llvm.ptr
  %10 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.array<64 x i8>}> : (i32) -> !llvm.ptr
  %11 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.array<4 x i64>}> : (i32) -> !llvm.ptr
  %12 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.array<4 x i64>}> : (i32) -> !llvm.ptr
  %13 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.array<32 x i8>}> : (i32) -> !llvm.ptr
  %14 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.array<64 x i8>}> : (i32) -> !llvm.ptr
  %15 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.array<4 x i64>}> : (i32) -> !llvm.ptr
  %16 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.array<4 x i64>}> : (i32) -> !llvm.ptr
  %17 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.array<32 x i8>}> : (i32) -> !llvm.ptr
  %18 = "llvm.getelementptr"(%arg2) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %19 = "llvm.call"(%18) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @fd_curve25519_scalar_validate, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> !llvm.ptr
  %20 = "llvm.icmp"(%19, %2) <{predicate = 0 : i64}> : (!llvm.ptr, !llvm.ptr) -> i1
  "llvm.cond_br"(%20, %3)[^bb28, ^bb1] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i32) -> ()
^bb1:  // pred: ^bb0
  "llvm.intr.lifetime.start"(%7) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%8) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%9) : (!llvm.ptr) -> ()
  %21 = "llvm.icmp"(%arg5, %2) <{predicate = 0 : i64}> : (!llvm.ptr, !llvm.ptr) -> i1
  "llvm.cond_br"(%21)[^bb12, ^bb2] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb2:  // pred: ^bb1
  %22 = "llvm.load"(%arg6) <{alignment = 4 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i32
  %23 = "llvm.icmp"(%22, %4) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%23)[^bb3, ^bb5] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb3:  // pred: ^bb2
  %24 = "llvm.call"(%8, %arg2) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @crc_adx_point_decode1, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> i32
  %25 = "llvm.icmp"(%24, %4) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%25, %3)[^bb27, ^bb4] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i32) -> ()
^bb4:  // pred: ^bb3
  %26 = "llvm.call"(%8) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @crc_adx_point_is_small_order_affine, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i32
  %27 = "llvm.sub"(%4, %26) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  "llvm.br"(%27)[^bb27] : (i32) -> ()
^bb5:  // pred: ^bb2
  "llvm.intr.lifetime.start"(%10) : (!llvm.ptr) -> ()
  %28 = "llvm.call"(%arg4) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_sha512_init, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> !llvm.ptr
  %29 = "llvm.call"(%28, %arg2, %1) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_append, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %30 = "llvm.call"(%29, %arg3, %1) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_append, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %31 = "llvm.call"(%30, %arg0, %arg1) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_append, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %32 = "llvm.call"(%31, %10) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_sha512_fini, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %33 = "llvm.call"(%10, %10) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_curve25519_scalar_reduce, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.call"(%9, %10, %arg5, %18) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @crc_adx_double_scalar_mul_base_split, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%11) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%12) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%13) : (!llvm.ptr) -> ()
  "llvm.call"(%11, %12, %9) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crc_adx_point_affine_canon, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%13, %11, %12) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crc_adx_encode_canon, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  %34 = "llvm.call"(%13, %arg2) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_memeq, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> i32
  %35 = "llvm.icmp"(%34, %4) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%35)[^bb7, ^bb6] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb6:  // pred: ^bb5
  %36 = "llvm.call"(%11, %12) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @crc_adx_affine_is_small_order, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> i32
  %37 = "llvm.icmp"(%36, %4) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%37, %0, %3)[^bb10, ^bb11] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 1, 1>}> : (i1, i32, i32) -> ()
^bb7:  // pred: ^bb5
  %38 = "llvm.call"(%8, %arg2) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @crc_adx_point_decode1, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> i32
  %39 = "llvm.icmp"(%38, %4) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%39, %3)[^bb11, ^bb8] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i32) -> ()
^bb8:  // pred: ^bb7
  %40 = "llvm.call"(%8) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @crc_adx_point_is_small_order_affine, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i32
  %41 = "llvm.icmp"(%40, %4) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%41, %3)[^bb9, ^bb11] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb9:  // pred: ^bb8
  %42 = "llvm.call"(%9, %8) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @crc_adx_point_eq_z1, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> i32
  "llvm.br"(%42)[^bb10] : (i32) -> ()
^bb10(%43: i32):  // 2 preds: ^bb6, ^bb9
  "llvm.store"(%43, %arg6) <{alignment = 4 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i32, !llvm.ptr) -> ()
  "llvm.br"(%4)[^bb11] : (i32) -> ()
^bb11(%44: i32):  // 4 preds: ^bb6, ^bb7, ^bb8, ^bb10
  "llvm.intr.lifetime.end"(%13) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%12) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%11) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%10) : (!llvm.ptr) -> ()
  "llvm.br"(%44)[^bb27] : (i32) -> ()
^bb12:  // pred: ^bb1
  %45 = "llvm.call"(%7, %arg3) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @crc_adx_point_decode1, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> i32
  %46 = "llvm.icmp"(%45, %4) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%46, %5)[^bb27, ^bb13] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i32) -> ()
^bb13:  // pred: ^bb12
  %47 = "llvm.call"(%7) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @crc_adx_point_is_small_order_affine, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i32
  %48 = "llvm.icmp"(%47, %4) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%48)[^bb15, ^bb14] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb14:  // pred: ^bb13
  %49 = "llvm.call"(%8, %arg2) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @crc_adx_point_decode1, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> i32
  %50 = "llvm.icmp"(%49, %4) <{predicate = 0 : i64}> : (i32, i32) -> i1
  %51 = "llvm.select"(%50, %3, %5) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i32, i32) -> i32
  "llvm.br"(%51)[^bb27] : (i32) -> ()
^bb15:  // pred: ^bb13
  %52 = "llvm.load"(%arg6) <{alignment = 4 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i32
  %53 = "llvm.icmp"(%52, %4) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%53)[^bb16, ^bb18] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb16:  // pred: ^bb15
  %54 = "llvm.call"(%8, %arg2) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @crc_adx_point_decode1, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> i32
  %55 = "llvm.icmp"(%54, %4) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%55, %3)[^bb27, ^bb17] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i32) -> ()
^bb17:  // pred: ^bb16
  %56 = "llvm.call"(%8) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @crc_adx_point_is_small_order_affine, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i32
  %57 = "llvm.sub"(%4, %56) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  "llvm.br"(%57)[^bb27] : (i32) -> ()
^bb18:  // pred: ^bb15
  "llvm.intr.lifetime.start"(%14) : (!llvm.ptr) -> ()
  %58 = "llvm.call"(%arg4) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_sha512_init, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> !llvm.ptr
  %59 = "llvm.call"(%58, %arg2, %1) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_append, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %60 = "llvm.call"(%59, %arg3, %1) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_append, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %61 = "llvm.call"(%60, %arg0, %arg1) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_append, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %62 = "llvm.call"(%61, %14) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_sha512_fini, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %63 = "llvm.call"(%14, %14) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_curve25519_scalar_reduce, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.call"(%7, %7) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @crc_adx_point_neg, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%9, %14, %7, %18) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @crc_adx_double_scalar_mul_base, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  %64 = "llvm.icmp"(%arg7, %2) <{predicate = 0 : i64}> : (!llvm.ptr, !llvm.ptr) -> i1
  "llvm.cond_br"(%64)[^bb20, ^bb19] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb19:  // pred: ^bb18
  "llvm.intr.memcpy"(%arg7, %7, %6) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 128 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 16 : i64, llvm.dereferenceable = 128 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.br"()[^bb20] : () -> ()
^bb20:  // 2 preds: ^bb18, ^bb19
  "llvm.intr.lifetime.start"(%15) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%16) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%17) : (!llvm.ptr) -> ()
  "llvm.call"(%15, %16, %9) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crc_adx_point_affine_canon, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%17, %15, %16) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crc_adx_encode_canon, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  %65 = "llvm.call"(%17, %arg2) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_memeq, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> i32
  %66 = "llvm.icmp"(%65, %4) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%66)[^bb22, ^bb21] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb21:  // pred: ^bb20
  %67 = "llvm.call"(%15, %16) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @crc_adx_affine_is_small_order, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> i32
  %68 = "llvm.icmp"(%67, %4) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%68, %0, %3)[^bb25, ^bb26] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 1, 1>}> : (i1, i32, i32) -> ()
^bb22:  // pred: ^bb20
  %69 = "llvm.call"(%8, %arg2) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @crc_adx_point_decode1, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> i32
  %70 = "llvm.icmp"(%69, %4) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%70, %3)[^bb26, ^bb23] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i32) -> ()
^bb23:  // pred: ^bb22
  %71 = "llvm.call"(%8) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @crc_adx_point_is_small_order_affine, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i32
  %72 = "llvm.icmp"(%71, %4) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%72, %3)[^bb24, ^bb26] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb24:  // pred: ^bb23
  %73 = "llvm.call"(%9, %8) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @crc_adx_point_eq_z1, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> i32
  "llvm.br"(%73)[^bb25] : (i32) -> ()
^bb25(%74: i32):  // 2 preds: ^bb21, ^bb24
  "llvm.store"(%74, %arg6) <{alignment = 4 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i32, !llvm.ptr) -> ()
  "llvm.br"(%4)[^bb26] : (i32) -> ()
^bb26(%75: i32):  // 4 preds: ^bb21, ^bb22, ^bb23, ^bb25
  "llvm.intr.lifetime.end"(%17) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%16) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%15) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%14) : (!llvm.ptr) -> ()
  "llvm.br"(%75)[^bb27] : (i32) -> ()
^bb27(%76: i32):  // 8 preds: ^bb3, ^bb4, ^bb11, ^bb12, ^bb14, ^bb16, ^bb17, ^bb26
  "llvm.intr.lifetime.end"(%9) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%8) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%7) : (!llvm.ptr) -> ()
  "llvm.br"(%76)[^bb28] : (i32) -> ()
^bb28(%77: i32):  // 2 preds: ^bb0, ^bb27
  "llvm.return"(%77) : (i32) -> ()
}) : () -> ()

    with
      @fd_curve25519_scalar_validate := MLIR.Firedancer.Crc.Ref.fd_curve25519_scalar_validate,
      @crc_adx_point_decode1 := MLIR.Firedancer.Crc.Ref.crc_adx_point_decode1,
      @crc_adx_point_is_small_order_affine := MLIR.Firedancer.Crc.Ref.crc_adx_point_is_small_order_affine,
      @fd_sha512_init := MLIR.Firedancer.Crc.Ref.fd_sha512_init,
      @fd_sha512_append := MLIR.Firedancer.Crc.Ref.fd_sha512_append,
      @fd_sha512_append := MLIR.Firedancer.Crc.Ref.fd_sha512_append,
      @fd_sha512_append := MLIR.Firedancer.Crc.Ref.fd_sha512_append,
      @fd_sha512_fini := MLIR.Firedancer.Crc.Ref.fd_sha512_fini,
      @fd_curve25519_scalar_reduce := MLIR.Firedancer.Crc.Ref.fd_curve25519_scalar_reduce,
      @crc_adx_double_scalar_mul_base_split := MLIR.Firedancer.Crc.Ref.crc_adx_double_scalar_mul_base_split,
      @crc_adx_point_affine_canon := MLIR.Firedancer.Crc.Ref.crc_adx_point_affine_canon,
      @crc_adx_encode_canon := MLIR.Firedancer.Crc.Ref.crc_adx_encode_canon,
      @fd_memeq := MLIR.Firedancer.Crc.Ref.fd_memeq,
      @crc_adx_affine_is_small_order := MLIR.Firedancer.Crc.Ref.crc_adx_affine_is_small_order,
      @crc_adx_point_decode1 := MLIR.Firedancer.Crc.Ref.crc_adx_point_decode1,
      @crc_adx_point_is_small_order_affine := MLIR.Firedancer.Crc.Ref.crc_adx_point_is_small_order_affine,
      @crc_adx_point_eq_z1 := MLIR.Firedancer.Crc.Ref.crc_adx_point_eq_z1,
      @crc_adx_point_decode1 := MLIR.Firedancer.Crc.Ref.crc_adx_point_decode1,
      @crc_adx_point_is_small_order_affine := MLIR.Firedancer.Crc.Ref.crc_adx_point_is_small_order_affine,
      @crc_adx_point_decode1 := MLIR.Firedancer.Crc.Ref.crc_adx_point_decode1,
      @crc_adx_point_decode1 := MLIR.Firedancer.Crc.Ref.crc_adx_point_decode1,
      @crc_adx_point_is_small_order_affine := MLIR.Firedancer.Crc.Ref.crc_adx_point_is_small_order_affine,
      @fd_sha512_init := MLIR.Firedancer.Crc.Ref.fd_sha512_init,
      @fd_sha512_append := MLIR.Firedancer.Crc.Ref.fd_sha512_append,
      @fd_sha512_append := MLIR.Firedancer.Crc.Ref.fd_sha512_append,
      @fd_sha512_append := MLIR.Firedancer.Crc.Ref.fd_sha512_append,
      @fd_sha512_fini := MLIR.Firedancer.Crc.Ref.fd_sha512_fini,
      @fd_curve25519_scalar_reduce := MLIR.Firedancer.Crc.Ref.fd_curve25519_scalar_reduce,
      @crc_adx_point_neg := MLIR.Firedancer.Crc.Ref.crc_adx_point_neg,
      @crc_adx_double_scalar_mul_base := MLIR.Firedancer.Crc.Ref.crc_adx_double_scalar_mul_base,
      @crc_adx_point_affine_canon := MLIR.Firedancer.Crc.Ref.crc_adx_point_affine_canon,
      @crc_adx_encode_canon := MLIR.Firedancer.Crc.Ref.crc_adx_encode_canon,
      @fd_memeq := MLIR.Firedancer.Crc.Ref.fd_memeq,
      @crc_adx_affine_is_small_order := MLIR.Firedancer.Crc.Ref.crc_adx_affine_is_small_order,
      @crc_adx_point_decode1 := MLIR.Firedancer.Crc.Ref.crc_adx_point_decode1,
      @crc_adx_point_is_small_order_affine := MLIR.Firedancer.Crc.Ref.crc_adx_point_is_small_order_affine,
      @crc_adx_point_eq_z1 := MLIR.Firedancer.Crc.Ref.crc_adx_point_eq_z1

end

end MLIR.Firedancer.Crc.Ref
