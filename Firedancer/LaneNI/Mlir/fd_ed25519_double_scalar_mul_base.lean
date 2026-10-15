
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.LaneNI.Mlir.fd_ed25519_base_point_wnaf_table
public import Firedancer.LaneNI.Mlir.fd_curve25519_scalar_wnaf
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
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_add_with_opts
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_add_final_mul
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_sub_with_opts
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_add_final_mul
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_add_final_mul_projective

namespace Firedancer.LaneNI.Mlir

@[expose] public section

noncomputable mlir_def fd_ed25519_double_scalar_mul_base := "llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nofree, llvm.noundef, llvm.returned}, {llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.noundef}], frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<ptr (ptr, ptr, ptr, ptr)>, linkage = #llvm.linkage<external>, no_inline, no_unwind, passthrough = ["sspstrong", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], res_attrs = [{llvm.noundef}], sym_name = "fd_ed25519_double_scalar_mul_base", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: !llvm.ptr, %arg3: !llvm.ptr):
  %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %2 = "llvm.mlir.constant"() <{value = 8 : i32}> : () -> i32
  %3 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %4 = "llvm.mlir.constant"() <{value = 8 : i64}> : () -> i64
  %5 = "llvm.mlir.constant"() <{value = 255 : i32}> : () -> i32
  %6 = "llvm.mlir.constant"() <{value = 0 : i16}> : () -> i16
  %7 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
  %8 = "llvm.mlir.constant"() <{value = 1 : i16}> : () -> i16
  %9 = "llvm.mlir.addressof"() <{global_name = @fd_ed25519_base_point_wnaf_table}> : () -> !llvm.ptr
  %10 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %11 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %12 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %13 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.array<256 x i16>}> : (i32) -> !llvm.ptr
  %14 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.array<256 x i16>}> : (i32) -> !llvm.ptr
  %15 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = !llvm.array<8 x struct<"struct.fd_curve25519_edwards", (vector<8xi64>, vector<8xi64>, vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %16 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_curve25519_edwards", (vector<8xi64>, vector<8xi64>, vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %17 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_curve25519_edwards", (vector<8xi64>, vector<8xi64>, vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%13) : (!llvm.ptr) -> ()
  "llvm.call"(%13, %arg1, %1) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_curve25519_scalar_wnaf, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> ()
  "llvm.intr.lifetime.start"(%14) : (!llvm.ptr) -> ()
  "llvm.call"(%14, %arg3, %2) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_curve25519_scalar_wnaf, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> ()
  "llvm.intr.lifetime.start"(%15) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%16) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%17) : (!llvm.ptr) -> ()
  %18 = "llvm.call"(%15, %arg2) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_set, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %19 = "llvm.call"(%16, %arg2, %0) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_dbln, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> !llvm.ptr
  "llvm.call"(%15) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @fd_curve25519_into_precomputed, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> ()
  "llvm.br"(%3)[^bb2] : (i64) -> ()
^bb1:  // pred: ^bb2
  %20 = "llvm.call"(%arg0) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_ed25519_point_set_zero, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.br"(%5)[^bb3] : (i32) -> ()
^bb2(%21: i64):  // 2 preds: ^bb0, ^bb2
  %22 = "llvm.getelementptr"(%15, %21) <{elem_type = !llvm.array<192 x i8>, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %23 = "llvm.getelementptr"(%22) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -192>}> : (!llvm.ptr) -> !llvm.ptr
  %24 = "llvm.call"(%17, %16, %23, %0) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_with_opts, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, i32) -> !llvm.ptr
  %25 = "llvm.call"(%22, %17) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_final_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.call"(%22) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @fd_curve25519_into_precomputed, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> ()
  %26 = "llvm.add"(%21, %3) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %27 = "llvm.icmp"(%26, %4) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%27, %26)[^bb1, ^bb2] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb3(%28: i32):  // 2 preds: ^bb1, ^bb5
  %29 = "llvm.zext"(%28) <{nonNeg}> : (i32) -> i64
  %30 = "llvm.getelementptr"(%13, %29) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %31 = "llvm.load"(%30) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %32 = "llvm.icmp"(%31, %6) <{predicate = 0 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%32)[^bb4, ^bb6] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb4:  // pred: ^bb3
  %33 = "llvm.getelementptr"(%14, %29) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %34 = "llvm.load"(%33) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %35 = "llvm.icmp"(%34, %6) <{predicate = 0 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%35)[^bb5, ^bb6] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb5:  // pred: ^bb4
  %36 = "llvm.add"(%28, %7) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %37 = "llvm.icmp"(%28, %12) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%37, %36)[^bb19, ^bb3] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb6:  // 2 preds: ^bb3, ^bb4
  %38 = "llvm.icmp"(%28, %7) <{predicate = 4 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%38)[^bb7, ^bb19] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb7:  // pred: ^bb6
  %39 = "llvm.zext"(%28) <{nonNeg}> : (i32) -> i64
  "llvm.br"(%39)[^bb8] : (i64) -> ()
^bb8(%40: i64):  // 2 preds: ^bb7, ^bb18
  %41 = "llvm.call"(%17, %arg0) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_partial_dbl, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %42 = "llvm.getelementptr"(%13, %40) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %43 = "llvm.load"(%42) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %44 = "llvm.icmp"(%43, %6) <{predicate = 4 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%44)[^bb9, ^bb10] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb9:  // pred: ^bb8
  %45 = "llvm.call"(%arg0, %17) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_final_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %46 = "llvm.lshr"(%43, %8) : (i16, i16) -> i16
  %47 = "llvm.zext"(%46) <{nonNeg}> : (i16) -> i64
  %48 = "llvm.getelementptr"(%15, %47) <{elem_type = !llvm.array<192 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %49 = "llvm.call"(%17, %arg0, %48, %0) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_with_opts, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, i32) -> !llvm.ptr
  "llvm.br"()[^bb12] : () -> ()
^bb10:  // pred: ^bb8
  %50 = "llvm.icmp"(%43, %6) <{predicate = 2 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%50)[^bb11, ^bb12] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb11:  // pred: ^bb10
  %51 = "llvm.call"(%arg0, %17) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_final_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %52 = "llvm.sub"(%6, %43) <{overflowFlags = 0 : i32}> : (i16, i16) -> i16
  %53 = "llvm.lshr"(%52, %8) : (i16, i16) -> i16
  %54 = "llvm.zext"(%53) <{nonNeg}> : (i16) -> i64
  %55 = "llvm.getelementptr"(%15, %54) <{elem_type = !llvm.array<192 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %56 = "llvm.call"(%17, %arg0, %55, %0) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_sub_with_opts, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, i32) -> !llvm.ptr
  "llvm.br"()[^bb12] : () -> ()
^bb12:  // 3 preds: ^bb9, ^bb10, ^bb11
  %57 = "llvm.getelementptr"(%14, %40) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %58 = "llvm.load"(%57) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %59 = "llvm.icmp"(%58, %6) <{predicate = 4 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%59)[^bb13, ^bb14] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb13:  // pred: ^bb12
  %60 = "llvm.call"(%arg0, %17) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_final_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %61 = "llvm.lshr"(%58, %8) : (i16, i16) -> i16
  %62 = "llvm.zext"(%61) <{nonNeg}> : (i16) -> i64
  %63 = "llvm.getelementptr"(%9, %62) <{elem_type = !llvm.array<192 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %64 = "llvm.call"(%17, %arg0, %63, %0) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_with_opts, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, i32) -> !llvm.ptr
  "llvm.br"()[^bb16] : () -> ()
^bb14:  // pred: ^bb12
  %65 = "llvm.icmp"(%58, %6) <{predicate = 2 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%65)[^bb15, ^bb16] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb15:  // pred: ^bb14
  %66 = "llvm.call"(%arg0, %17) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_final_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %67 = "llvm.sub"(%6, %58) <{overflowFlags = 0 : i32}> : (i16, i16) -> i16
  %68 = "llvm.lshr"(%67, %8) : (i16, i16) -> i16
  %69 = "llvm.zext"(%68) <{nonNeg}> : (i16) -> i64
  %70 = "llvm.getelementptr"(%9, %69) <{elem_type = !llvm.array<192 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %71 = "llvm.call"(%17, %arg0, %70, %0) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_sub_with_opts, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, i32) -> !llvm.ptr
  "llvm.br"()[^bb16] : () -> ()
^bb16:  // 3 preds: ^bb13, ^bb14, ^bb15
  %72 = "llvm.icmp"(%40, %10) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%72)[^bb17, ^bb18] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb17:  // pred: ^bb16
  %73 = "llvm.call"(%arg0, %17) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_final_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.br"()[^bb19] : () -> ()
^bb18:  // pred: ^bb16
  %74 = "llvm.call"(%arg0, %17) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_final_mul_projective, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %75 = "llvm.add"(%40, %11) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %76 = "llvm.icmp"(%40, %10) <{predicate = 4 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%76, %75)[^bb8, ^bb19] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
^bb19:  // 4 preds: ^bb5, ^bb6, ^bb17, ^bb18
  "llvm.intr.lifetime.end"(%17) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%16) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%15) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%14) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%13) : (!llvm.ptr) -> ()
  "llvm.return"(%arg0) : (!llvm.ptr) -> ()
}) : () -> ()

    with
      @fd_ed25519_base_point_wnaf_table := Firedancer.LaneNI.Mlir.fd_ed25519_base_point_wnaf_table,
      @fd_curve25519_scalar_wnaf := Firedancer.LaneNI.Mlir.fd_curve25519_scalar_wnaf,
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
      @fd_ed25519_point_add_with_opts := Firedancer.LaneNI.Mlir.fd_ed25519_point_add_with_opts,
      @fd_ed25519_point_add_final_mul := Firedancer.LaneNI.Mlir.fd_ed25519_point_add_final_mul,
      @fd_ed25519_point_sub_with_opts := Firedancer.LaneNI.Mlir.fd_ed25519_point_sub_with_opts,
      @fd_ed25519_point_add_final_mul := Firedancer.LaneNI.Mlir.fd_ed25519_point_add_final_mul,
      @fd_ed25519_point_add_final_mul_projective := Firedancer.LaneNI.Mlir.fd_ed25519_point_add_final_mul_projective

end

end Firedancer.LaneNI.Mlir
