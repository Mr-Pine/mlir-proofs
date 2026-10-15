
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.LaneNI.Mlir.fd_ed25519_point_set_zero
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_set_zero
public import Firedancer.LaneNI.Mlir.fd_ed25519_partial_dbl
public import Firedancer.LaneNI.Mlir.fd_ed25519_partial_dbl
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_add_final_mul_projective
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_add_final_mul
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_sub_with_opts
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_add_final_mul
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_add_with_opts
public import Firedancer.LaneNI.Mlir.fd_curve25519_scalar_wnaf
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_set
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_dbln
public import Firedancer.LaneNI.Mlir.fd_curve25519_into_precomputed
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_add_with_opts
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_add_final_mul
public import Firedancer.LaneNI.Mlir.fd_curve25519_into_precomputed
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_add_final_mul
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_add_final_mul_projective
public import Firedancer.LaneNI.Mlir.fd_ed25519_partial_dbl

namespace Firedancer.LaneNI.Mlir

@[expose] public section

mlir_def fd_ed25519_multi_scalar_mul_with_opts := "llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nofree, llvm.nonnull, llvm.noundef, llvm.returned}, {llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.noundef}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<ptr (ptr, ptr, ptr, i64)>, linkage = #llvm.linkage<internal>, no_inline, no_unwind, passthrough = ["sspstrong", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], res_attrs = [{llvm.nonnull, llvm.noundef}], sym_name = "fd_ed25519_multi_scalar_mul_with_opts", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: !llvm.ptr, %arg3: i64):
  %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %2 = "llvm.mlir.constant"() <{value = 5 : i64}> : () -> i64
  %3 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %4 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %5 = "llvm.mlir.constant"() <{value = 8 : i64}> : () -> i64
  %6 = "llvm.mlir.constant"() <{value = 255 : i64}> : () -> i64
  %7 = "llvm.mlir.constant"() <{value = 0 : i16}> : () -> i16
  %8 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %9 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %10 = "llvm.mlir.constant"() <{value = 255 : i32}> : () -> i32
  %11 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
  %12 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.array<32 x array<256 x i16>>}> : (i32) -> !llvm.ptr
  %13 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = !llvm.array<32 x array<8 x struct<"struct.fd_curve25519_edwards", (vector<8xi64>, vector<8xi64>, vector<8xi64>)>>>}> : (i32) -> !llvm.ptr
  %14 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_curve25519_edwards", (vector<8xi64>, vector<8xi64>, vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %15 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_curve25519_edwards", (vector<8xi64>, vector<8xi64>, vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%12) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%13) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%14) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%15) : (!llvm.ptr) -> ()
  %16 = "llvm.icmp"(%arg3, %1) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%16, %1)[^bb2, ^bb11] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb1:  // pred: ^bb12
  %17 = "llvm.call"(%arg0) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @fd_ed25519_point_set_zero, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.br"(%6)[^bb3] : (i64) -> ()
^bb2:  // pred: ^bb0
  %18 = "llvm.call"(%arg0) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @fd_ed25519_point_set_zero, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> !llvm.ptr
  %19 = "llvm.call"(%15, %arg0) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_ed25519_partial_dbl, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.br"(%10)[^bb15] : (i32) -> ()
^bb3(%20: i64):  // 2 preds: ^bb1, ^bb4
  %21 = "llvm.call"(%15, %arg0) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_ed25519_partial_dbl, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %22 = "llvm.getelementptr"(%12, %20) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.br"(%1)[^bb5] : (i64) -> ()
^bb4:  // pred: ^bb10
  %23 = "llvm.call"(%arg0, %15) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_final_mul_projective, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %24 = "llvm.add"(%20, %9) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  "llvm.br"(%24)[^bb3] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>}> : (i64) -> ()
^bb5(%25: i64):  // 2 preds: ^bb3, ^bb9
  %26 = "llvm.getelementptr"(%22, %25) <{elem_type = !llvm.array<512 x i8>, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %27 = "llvm.load"(%26) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %28 = "llvm.sext"(%27) : (i16) -> i32
  %29 = "llvm.icmp"(%27, %7) <{predicate = 4 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%29)[^bb8, ^bb6] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb6:  // pred: ^bb5
  %30 = "llvm.icmp"(%27, %7) <{predicate = 2 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%30)[^bb7, ^bb9] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb7:  // pred: ^bb6
  %31 = "llvm.call"(%arg0, %15) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_final_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %32 = "llvm.getelementptr"(%13, %25) <{elem_type = !llvm.array<1536 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %33 = "llvm.sub"(%8, %28) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %34 = "llvm.lshr"(%33, %0) : (i32, i32) -> i32
  %35 = "llvm.zext"(%34) <{nonNeg}> : (i32) -> i64
  %36 = "llvm.getelementptr"(%32, %35) <{elem_type = !llvm.array<192 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %37 = "llvm.call"(%15, %arg0, %36, %0) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_sub_with_opts, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, i32) -> !llvm.ptr
  "llvm.br"()[^bb9] : () -> ()
^bb8:  // pred: ^bb5
  %38 = "llvm.call"(%arg0, %15) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_final_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %39 = "llvm.getelementptr"(%13, %25) <{elem_type = !llvm.array<1536 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %40 = "llvm.lshr"(%28, %0) : (i32, i32) -> i32
  %41 = "llvm.zext"(%40) <{nonNeg}> : (i32) -> i64
  %42 = "llvm.getelementptr"(%39, %41) <{elem_type = !llvm.array<192 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %43 = "llvm.call"(%15, %arg0, %42, %0) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_with_opts, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, i32) -> !llvm.ptr
  "llvm.br"()[^bb9] : () -> ()
^bb9:  // 3 preds: ^bb6, ^bb7, ^bb8
  %44 = "llvm.add"(%25, %4) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %45 = "llvm.icmp"(%44, %arg3) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%45, %44)[^bb10, ^bb5] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb10:  // pred: ^bb9
  %46 = "llvm.icmp"(%20, %1) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%46)[^bb14, ^bb4] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb11(%47: i64):  // 2 preds: ^bb0, ^bb12
  %48 = "llvm.getelementptr"(%12, %47) <{elem_type = !llvm.array<512 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %49 = "llvm.shl"(%47, %2) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %50 = "llvm.getelementptr"(%arg1, %49) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.call"(%48, %50, %3) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_curve25519_scalar_wnaf, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> ()
  %51 = "llvm.getelementptr"(%13, %47) <{elem_type = !llvm.array<1536 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %52 = "llvm.getelementptr"(%arg2, %47) <{elem_type = !llvm.array<192 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %53 = "llvm.call"(%51, %52) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_set, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %54 = "llvm.call"(%14, %52, %0) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_dbln, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> !llvm.ptr
  "llvm.call"(%51) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @fd_curve25519_into_precomputed, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> ()
  "llvm.br"(%4)[^bb13] : (i64) -> ()
^bb12:  // pred: ^bb13
  %55 = "llvm.add"(%47, %4) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %56 = "llvm.icmp"(%55, %arg3) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%56, %55)[^bb1, ^bb11] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb13(%57: i64):  // 2 preds: ^bb11, ^bb13
  %58 = "llvm.getelementptr"(%51, %57) <{elem_type = !llvm.array<192 x i8>, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %59 = "llvm.getelementptr"(%58) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -192>}> : (!llvm.ptr) -> !llvm.ptr
  %60 = "llvm.call"(%15, %14, %59, %0) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_with_opts, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, i32) -> !llvm.ptr
  %61 = "llvm.call"(%58, %15) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_final_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.call"(%58) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @fd_curve25519_into_precomputed, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> ()
  %62 = "llvm.add"(%57, %4) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %63 = "llvm.icmp"(%62, %5) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%63, %62)[^bb12, ^bb13] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb14:  // 2 preds: ^bb10, ^bb15
  %64 = "llvm.call"(%arg0, %15) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_final_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.intr.lifetime.end"(%15) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%14) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%13) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%12) : (!llvm.ptr) -> ()
  "llvm.return"(%arg0) : (!llvm.ptr) -> ()
^bb15(%65: i32):  // 2 preds: ^bb2, ^bb15
  %66 = "llvm.call"(%arg0, %15) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_final_mul_projective, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %67 = "llvm.add"(%65, %11) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %68 = "llvm.call"(%15, %arg0) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_ed25519_partial_dbl, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %69 = "llvm.icmp"(%67, %8) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%69, %67)[^bb14, ^bb15] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
}) : () -> ()

    with
      @fd_ed25519_point_set_zero := Firedancer.LaneNI.Mlir.fd_ed25519_point_set_zero,
      @fd_ed25519_point_set_zero := Firedancer.LaneNI.Mlir.fd_ed25519_point_set_zero,
      @fd_ed25519_partial_dbl := Firedancer.LaneNI.Mlir.fd_ed25519_partial_dbl,
      @fd_ed25519_partial_dbl := Firedancer.LaneNI.Mlir.fd_ed25519_partial_dbl,
      @fd_ed25519_point_add_final_mul_projective := Firedancer.LaneNI.Mlir.fd_ed25519_point_add_final_mul_projective,
      @fd_ed25519_point_add_final_mul := Firedancer.LaneNI.Mlir.fd_ed25519_point_add_final_mul,
      @fd_ed25519_point_sub_with_opts := Firedancer.LaneNI.Mlir.fd_ed25519_point_sub_with_opts,
      @fd_ed25519_point_add_final_mul := Firedancer.LaneNI.Mlir.fd_ed25519_point_add_final_mul,
      @fd_ed25519_point_add_with_opts := Firedancer.LaneNI.Mlir.fd_ed25519_point_add_with_opts,
      @fd_curve25519_scalar_wnaf := Firedancer.LaneNI.Mlir.fd_curve25519_scalar_wnaf,
      @fd_ed25519_point_set := Firedancer.LaneNI.Mlir.fd_ed25519_point_set,
      @fd_ed25519_point_dbln := Firedancer.LaneNI.Mlir.fd_ed25519_point_dbln,
      @fd_curve25519_into_precomputed := Firedancer.LaneNI.Mlir.fd_curve25519_into_precomputed,
      @fd_ed25519_point_add_with_opts := Firedancer.LaneNI.Mlir.fd_ed25519_point_add_with_opts,
      @fd_ed25519_point_add_final_mul := Firedancer.LaneNI.Mlir.fd_ed25519_point_add_final_mul,
      @fd_curve25519_into_precomputed := Firedancer.LaneNI.Mlir.fd_curve25519_into_precomputed,
      @fd_ed25519_point_add_final_mul := Firedancer.LaneNI.Mlir.fd_ed25519_point_add_final_mul,
      @fd_ed25519_point_add_final_mul_projective := Firedancer.LaneNI.Mlir.fd_ed25519_point_add_final_mul_projective,
      @fd_ed25519_partial_dbl := Firedancer.LaneNI.Mlir.fd_ed25519_partial_dbl

end

end Firedancer.LaneNI.Mlir
