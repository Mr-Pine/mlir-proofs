
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

noncomputable mlir_def fd_ed25519_verify_batch_single_msg := "llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.align = 1 : i64, llvm.dereferenceable = 64 : i64, llvm.noundef}, {llvm.align = 1 : i64, llvm.dereferenceable = 32 : i64, llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.noundef, llvm.zeroext}], frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<i32 (ptr, i64, ptr, ptr, ptr, i8)>, linkage = #llvm.linkage<external>, no_inline, no_unwind, passthrough = ["sspstrong", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], res_attrs = [{llvm.range = #llvm.constant_range<i32, -3, 1>}], sym_name = "fd_ed25519_verify_batch_single_msg", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr, %arg1: i64, %arg2: !llvm.ptr, %arg3: !llvm.ptr, %arg4: !llvm.ptr, %arg5: i8):
  %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1 = "llvm.mlir.constant"() <{value = -17 : i8}> : () -> i8
  %2 = "llvm.mlir.constant"() <{value = -16 : i8}> : () -> i8
  %3 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
  %4 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %5 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %6 = "llvm.mlir.constant"() <{value = 6 : i64}> : () -> i64
  %7 = "llvm.mlir.constant"() <{value = 5 : i64}> : () -> i64
  %8 = "llvm.mlir.zero"() : () -> !llvm.ptr
  %9 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %10 = "llvm.mlir.constant"() <{value = -2 : i32}> : () -> i32
  %11 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %12 = "llvm.mlir.constant"() <{value = 4294967232 : i64}> : () -> i64
  %13 = "llvm.mlir.constant"() <{value = 4294967264 : i64}> : () -> i64
  %14 = "llvm.mlir.constant"() <{value = -3 : i32}> : () -> i32
  %15 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = !llvm.array<16 x struct<"struct.fd_curve25519_edwards", (vector<8xi64>, vector<8xi64>, vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %16 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = !llvm.array<16 x struct<"struct.fd_curve25519_edwards", (vector<8xi64>, vector<8xi64>, vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %17 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.array<512 x i8>}> : (i32) -> !llvm.ptr
  %18 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.array<64 x i8>}> : (i32) -> !llvm.ptr
  %19 = "llvm.add"(%arg5, %1) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  %20 = "llvm.icmp"(%19, %2) <{predicate = 6 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%20, %3)[^bb12, ^bb1] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i32) -> ()
^bb1:  // pred: ^bb0
  "llvm.intr.lifetime.start"(%15) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%16) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%17) : (!llvm.ptr) -> ()
  %21 = "llvm.getelementptr"(%arg2) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %22 = "llvm.zext"(%arg5) <{nonNeg}> : (i8) -> i64
  "llvm.br"(%5)[^bb3] : (i64) -> ()
^bb2:  // pred: ^bb8
  %23 = "llvm.getelementptr"(%arg2) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %24 = "llvm.zext"(%arg5) <{nonNeg}> : (i8) -> i64
  "llvm.br"(%5)[^bb10] : (i64) -> ()
^bb3(%25: i64):  // 2 preds: ^bb1, ^bb8
  %26 = "llvm.shl"(%25, %6) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %27 = "llvm.getelementptr"(%arg2, %26) <{elem_type = i8, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %28 = "llvm.getelementptr"(%21, %26) <{elem_type = i8, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %29 = "llvm.shl"(%25, %7) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %30 = "llvm.getelementptr"(%arg3, %29) <{elem_type = i8, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %31 = "llvm.call"(%28) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_curve25519_scalar_validate.144, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> !llvm.ptr
  %32 = "llvm.icmp"(%31, %8) <{predicate = 0 : i64}> : (!llvm.ptr, !llvm.ptr) -> i1
  "llvm.cond_br"(%32, %3)[^bb11, ^bb4] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i32) -> ()
^bb4:  // pred: ^bb3
  %33 = "llvm.getelementptr"(%16, %25) <{elem_type = !llvm.array<192 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %34 = "llvm.getelementptr"(%15, %25) <{elem_type = !llvm.array<192 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %35 = "llvm.call"(%33, %30, %34, %27) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_ed25519_point_frombytes_2x, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> i32
  %36 = "llvm.icmp"(%35, %9) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%36)[^bb6, ^bb5] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb5:  // pred: ^bb4
  %37 = "llvm.icmp"(%35, %3) <{predicate = 0 : i64}> : (i32, i32) -> i1
  %38 = "llvm.select"(%37, %10, %3) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i32, i32) -> i32
  "llvm.br"(%38)[^bb11] : (i32) -> ()
^bb6:  // pred: ^bb4
  %39 = "llvm.call"(%33) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_ed25519_affine_is_small_order.145, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i32
  %40 = "llvm.icmp"(%39, %9) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%40, %10)[^bb7, ^bb11] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb7:  // pred: ^bb6
  %41 = "llvm.call"(%34) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_ed25519_affine_is_small_order.145, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i32
  %42 = "llvm.icmp"(%41, %9) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%42, %3)[^bb8, ^bb11] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb8:  // pred: ^bb7
  "llvm.intr.lifetime.start"(%18) : (!llvm.ptr) -> ()
  %43 = "llvm.getelementptr"(%arg4, %25) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %44 = "llvm.load"(%43) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 _ZTS17fd_sha512_private", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 _ZTS17fd_sha512_private", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %45 = "llvm.call"(%44) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_sha512_init, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> !llvm.ptr
  %46 = "llvm.call"(%45, %27, %4) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_append, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %47 = "llvm.call"(%46, %30, %4) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_append, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %48 = "llvm.call"(%47, %arg0, %arg1) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_append, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %49 = "llvm.call"(%48, %18) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_sha512_fini, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %50 = "llvm.getelementptr"(%17, %29) <{elem_type = i8, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %51 = "llvm.call"(%50, %18) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_curve25519_scalar_reduce, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.intr.lifetime.end"(%18) : (!llvm.ptr) -> ()
  %52 = "llvm.add"(%25, %11) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %53 = "llvm.icmp"(%52, %22) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%53, %52)[^bb2, ^bb3] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb9:  // pred: ^bb10
  %54 = "llvm.add"(%56, %11) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %55 = "llvm.icmp"(%54, %24) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%55, %9, %54)[^bb11, ^bb10] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 1, 1>}> : (i1, i32, i64) -> ()
^bb10(%56: i64):  // 2 preds: ^bb2, ^bb9
  %57 = "llvm.shl"(%56, %6) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %58 = "llvm.and"(%57, %12) : (i64, i64) -> i64
  %59 = "llvm.getelementptr"(%23, %58) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %60 = "llvm.shl"(%56, %7) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %61 = "llvm.and"(%60, %13) : (i64, i64) -> i64
  %62 = "llvm.getelementptr"(%17, %61) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %63 = "llvm.getelementptr"(%16, %56) <{elem_type = !llvm.array<192 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %64 = "llvm.getelementptr"(%15, %56) <{elem_type = !llvm.array<192 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %65 = "llvm.call"(%62, %63, %59, %64) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_verify_equation, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> i32
  %66 = "llvm.icmp"(%65, %9) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%66, %14)[^bb11, ^bb9] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i32) -> ()
^bb11(%67: i32):  // 6 preds: ^bb3, ^bb5, ^bb6, ^bb7, ^bb9, ^bb10
  "llvm.intr.lifetime.end"(%17) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%16) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%15) : (!llvm.ptr) -> ()
  "llvm.br"(%67)[^bb12] : (i32) -> ()
^bb12(%68: i32):  // 2 preds: ^bb0, ^bb11
  "llvm.return"(%68) : (i32) -> ()
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
