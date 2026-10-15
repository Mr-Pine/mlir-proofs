
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.LaneNI.Mlir.fd_curve25519_scalar_wnaf
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_set
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_dbln
public import Firedancer.LaneNI.Mlir.fd_curve25519_into_precomputed
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_set_zero
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_add_with_opts
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_add_final_mul
public import Firedancer.LaneNI.Mlir.fd_curve25519_into_precomputed
public import Firedancer.LaneNI.Mlir.fd_ed25519_partial_dbl
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_add_final_mul
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_add_with_opts
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_add_final_mul
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_sub_with_opts
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_add_final_mul
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_add_final_mul_projective

namespace Firedancer.LaneNI.Mlir

@[expose] public section

mlir_def fd_ed25519_scalar_mul := "llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nofree, llvm.noundef, llvm.returned}, {llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<ptr (ptr, ptr, ptr)>, linkage = #llvm.linkage<external>, no_inline, no_unwind, passthrough = ["sspstrong", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], res_attrs = [{llvm.noundef}], sym_name = "fd_ed25519_scalar_mul", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: !llvm.ptr):
  %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %2 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %3 = "llvm.mlir.constant"() <{value = 8 : i64}> : () -> i64
  %4 = "llvm.mlir.constant"() <{value = 255 : i32}> : () -> i32
  %5 = "llvm.mlir.constant"() <{value = 0 : i16}> : () -> i16
  %6 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
  %7 = "llvm.mlir.constant"() <{value = 1 : i16}> : () -> i16
  %8 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %9 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %10 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %11 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.array<256 x i16>}> : (i32) -> !llvm.ptr
  %12 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = !llvm.array<8 x struct<"struct.fd_curve25519_edwards", (vector<8xi64>, vector<8xi64>, vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %13 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_curve25519_edwards", (vector<8xi64>, vector<8xi64>, vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %14 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_curve25519_edwards", (vector<8xi64>, vector<8xi64>, vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%11) : (!llvm.ptr) -> ()
  "llvm.call"(%11, %arg1, %1) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_curve25519_scalar_wnaf, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> ()
  "llvm.intr.lifetime.start"(%12) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%13) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%14) : (!llvm.ptr) -> ()
  %15 = "llvm.call"(%12, %arg2) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_set, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %16 = "llvm.call"(%13, %arg2, %0) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_dbln, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> !llvm.ptr
  "llvm.call"(%12) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @fd_curve25519_into_precomputed, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> ()
  "llvm.br"(%2)[^bb2] : (i64) -> ()
^bb1:  // pred: ^bb2
  %17 = "llvm.call"(%arg0) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_ed25519_point_set_zero, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.br"(%4)[^bb3] : (i32) -> ()
^bb2(%18: i64):  // 2 preds: ^bb0, ^bb2
  %19 = "llvm.getelementptr"(%12, %18) <{elem_type = !llvm.array<192 x i8>, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %20 = "llvm.getelementptr"(%19) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -192>}> : (!llvm.ptr) -> !llvm.ptr
  %21 = "llvm.call"(%14, %13, %20, %0) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_with_opts, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, i32) -> !llvm.ptr
  %22 = "llvm.call"(%19, %14) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_final_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.call"(%19) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @fd_curve25519_into_precomputed, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> ()
  %23 = "llvm.add"(%18, %2) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %24 = "llvm.icmp"(%23, %3) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%24, %23)[^bb1, ^bb2] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb3(%25: i32):  // 2 preds: ^bb1, ^bb4
  %26 = "llvm.zext"(%25) <{nonNeg}> : (i32) -> i64
  %27 = "llvm.getelementptr"(%11, %26) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %28 = "llvm.load"(%27) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %29 = "llvm.icmp"(%28, %5) <{predicate = 0 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%29)[^bb4, ^bb5] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb4:  // pred: ^bb3
  %30 = "llvm.add"(%25, %6) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %31 = "llvm.icmp"(%25, %10) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%31, %30)[^bb14, ^bb3] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb5:  // pred: ^bb3
  %32 = "llvm.icmp"(%25, %6) <{predicate = 4 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%32)[^bb6, ^bb14] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb6:  // pred: ^bb5
  %33 = "llvm.zext"(%25) <{nonNeg}> : (i32) -> i64
  "llvm.br"(%33)[^bb7] : (i64) -> ()
^bb7(%34: i64):  // 2 preds: ^bb6, ^bb13
  %35 = "llvm.call"(%14, %arg0) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_partial_dbl, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %36 = "llvm.getelementptr"(%11, %34) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %37 = "llvm.load"(%36) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %38 = "llvm.icmp"(%37, %5) <{predicate = 4 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%38)[^bb8, ^bb9] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb8:  // pred: ^bb7
  %39 = "llvm.call"(%arg0, %14) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_final_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %40 = "llvm.lshr"(%37, %7) : (i16, i16) -> i16
  %41 = "llvm.zext"(%40) <{nonNeg}> : (i16) -> i64
  %42 = "llvm.getelementptr"(%12, %41) <{elem_type = !llvm.array<192 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %43 = "llvm.call"(%14, %arg0, %42, %0) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_with_opts, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, i32) -> !llvm.ptr
  "llvm.br"()[^bb11] : () -> ()
^bb9:  // pred: ^bb7
  %44 = "llvm.icmp"(%37, %5) <{predicate = 2 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%44)[^bb10, ^bb11] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb10:  // pred: ^bb9
  %45 = "llvm.call"(%arg0, %14) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_final_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %46 = "llvm.sub"(%5, %37) <{overflowFlags = 0 : i32}> : (i16, i16) -> i16
  %47 = "llvm.lshr"(%46, %7) : (i16, i16) -> i16
  %48 = "llvm.zext"(%47) <{nonNeg}> : (i16) -> i64
  %49 = "llvm.getelementptr"(%12, %48) <{elem_type = !llvm.array<192 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %50 = "llvm.call"(%14, %arg0, %49, %0) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_sub_with_opts, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, i32) -> !llvm.ptr
  "llvm.br"()[^bb11] : () -> ()
^bb11:  // 3 preds: ^bb8, ^bb9, ^bb10
  %51 = "llvm.icmp"(%34, %8) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%51)[^bb12, ^bb13] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb12:  // pred: ^bb11
  %52 = "llvm.call"(%arg0, %14) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_final_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.br"()[^bb14] : () -> ()
^bb13:  // pred: ^bb11
  %53 = "llvm.call"(%arg0, %14) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_final_mul_projective, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %54 = "llvm.add"(%34, %9) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %55 = "llvm.icmp"(%34, %8) <{predicate = 4 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%55, %54)[^bb7, ^bb14] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
^bb14:  // 4 preds: ^bb4, ^bb5, ^bb12, ^bb13
  "llvm.intr.lifetime.end"(%14) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%13) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%12) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%11) : (!llvm.ptr) -> ()
  "llvm.return"(%arg0) : (!llvm.ptr) -> ()
}) : () -> ()

    with
      @fd_curve25519_scalar_wnaf := Firedancer.LaneNI.Mlir.fd_curve25519_scalar_wnaf,
      @fd_ed25519_point_set := Firedancer.LaneNI.Mlir.fd_ed25519_point_set,
      @fd_ed25519_point_dbln := Firedancer.LaneNI.Mlir.fd_ed25519_point_dbln,
      @fd_curve25519_into_precomputed := Firedancer.LaneNI.Mlir.fd_curve25519_into_precomputed,
      @fd_ed25519_point_set_zero := Firedancer.LaneNI.Mlir.fd_ed25519_point_set_zero,
      @fd_ed25519_point_add_with_opts := Firedancer.LaneNI.Mlir.fd_ed25519_point_add_with_opts,
      @fd_ed25519_point_add_final_mul := Firedancer.LaneNI.Mlir.fd_ed25519_point_add_final_mul,
      @fd_curve25519_into_precomputed := Firedancer.LaneNI.Mlir.fd_curve25519_into_precomputed,
      @fd_ed25519_partial_dbl := Firedancer.LaneNI.Mlir.fd_ed25519_partial_dbl,
      @fd_ed25519_point_add_final_mul := Firedancer.LaneNI.Mlir.fd_ed25519_point_add_final_mul,
      @fd_ed25519_point_add_with_opts := Firedancer.LaneNI.Mlir.fd_ed25519_point_add_with_opts,
      @fd_ed25519_point_add_final_mul := Firedancer.LaneNI.Mlir.fd_ed25519_point_add_final_mul,
      @fd_ed25519_point_sub_with_opts := Firedancer.LaneNI.Mlir.fd_ed25519_point_sub_with_opts,
      @fd_ed25519_point_add_final_mul := Firedancer.LaneNI.Mlir.fd_ed25519_point_add_final_mul,
      @fd_ed25519_point_add_final_mul_projective := Firedancer.LaneNI.Mlir.fd_ed25519_point_add_final_mul_projective

end

end Firedancer.LaneNI.Mlir
