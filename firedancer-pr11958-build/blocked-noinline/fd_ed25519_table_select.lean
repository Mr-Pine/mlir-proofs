
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.LaneNI.Mlir.fd_ed25519_base_point_const_time_table
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_set_zero_precomputed
public import Firedancer.LaneNI.Mlir.const_time_eq
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_if
public import Firedancer.LaneNI.Mlir.const_time_eq
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_if
public import Firedancer.LaneNI.Mlir.const_time_eq
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_if
public import Firedancer.LaneNI.Mlir.const_time_eq
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_if
public import Firedancer.LaneNI.Mlir.const_time_eq
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_if
public import Firedancer.LaneNI.Mlir.const_time_eq
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_if
public import Firedancer.LaneNI.Mlir.const_time_eq
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_if
public import Firedancer.LaneNI.Mlir.const_time_eq
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_if
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_neg_if

namespace Firedancer.LaneNI.Mlir

@[expose] public section

noncomputable mlir_def fd_ed25519_table_select := "llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.noundef, llvm.range = #llvm.constant_range<i32, -1073741824, 33>}, {llvm.noundef, llvm.signext}, {llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr, i32, i8, ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], sym_name = "fd_ed25519_table_select", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return, zero_call_used_regs = "all"}> ({
^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: i32, %arg3: i8, %arg4: !llvm.ptr, %arg5: !llvm.ptr):
  %0 = "llvm.mlir.constant"() <{value = 7 : i8}> : () -> i8
  %1 = "llvm.mlir.constant"() <{value = 1 : i8}> : () -> i8
  %2 = "llvm.mlir.constant"() <{value = -1 : i8}> : () -> i8
  %3 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %4 = "llvm.mlir.addressof"() <{global_name = @fd_ed25519_base_point_const_time_table}> : () -> !llvm.ptr
  %5 = "llvm.mlir.constant"() <{value = 2 : i8}> : () -> i8
  %6 = "llvm.mlir.constant"() <{value = 3 : i8}> : () -> i8
  %7 = "llvm.mlir.constant"() <{value = 4 : i8}> : () -> i8
  %8 = "llvm.mlir.constant"() <{value = 5 : i8}> : () -> i8
  %9 = "llvm.mlir.constant"() <{value = 6 : i8}> : () -> i8
  %10 = "llvm.lshr"(%arg3, %0) : (i8, i8) -> i8
  "llvm.store"(%10, %arg5) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %11 = "llvm.shl"(%10, %1) <{overflowFlags = 3 : i32}> : (i8, i8) -> i8
  %12 = "llvm.sub"(%1, %11) <{overflowFlags = 1 : i32}> : (i8, i8) -> i8
  %13 = "llvm.mul"(%12, %arg3) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  %14 = "llvm.add"(%13, %2) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  "llvm.store"(%14, %arg4) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %15 = "llvm.call"(%arg1) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_ed25519_point_set_zero_precomputed, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> !llvm.ptr
  %16 = "llvm.load"(%arg4) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %17 = "llvm.call"(%3, %16) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef, llvm.zeroext}, {llvm.noundef, llvm.zeroext}], callee = @const_time_eq, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>, res_attrs = [{llvm.zeroext}], zero_call_used_regs = "all"}> : (i8, i8) -> i8
  %18 = "llvm.sext"(%arg2) : (i32) -> i64
  %19 = "llvm.getelementptr"(%4, %18) <{elem_type = !llvm.array<1536 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.call"(%arg0, %17, %19, %arg1) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef, llvm.zeroext}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_if, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>, zero_call_used_regs = "all"}> : (!llvm.ptr, i8, !llvm.ptr, !llvm.ptr) -> ()
  %20 = "llvm.load"(%arg4) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %21 = "llvm.call"(%1, %20) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef, llvm.zeroext}, {llvm.noundef, llvm.zeroext}], callee = @const_time_eq, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>, res_attrs = [{llvm.zeroext}], zero_call_used_regs = "all"}> : (i8, i8) -> i8
  %22 = "llvm.getelementptr"(%19) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 192>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%arg1, %21, %22, %arg0) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef, llvm.zeroext}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_if, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>, zero_call_used_regs = "all"}> : (!llvm.ptr, i8, !llvm.ptr, !llvm.ptr) -> ()
  %23 = "llvm.load"(%arg4) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %24 = "llvm.call"(%5, %23) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef, llvm.zeroext}, {llvm.noundef, llvm.zeroext}], callee = @const_time_eq, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>, res_attrs = [{llvm.zeroext}], zero_call_used_regs = "all"}> : (i8, i8) -> i8
  %25 = "llvm.getelementptr"(%19) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 384>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%arg0, %24, %25, %arg1) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef, llvm.zeroext}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_if, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>, zero_call_used_regs = "all"}> : (!llvm.ptr, i8, !llvm.ptr, !llvm.ptr) -> ()
  %26 = "llvm.load"(%arg4) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %27 = "llvm.call"(%6, %26) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef, llvm.zeroext}, {llvm.noundef, llvm.zeroext}], callee = @const_time_eq, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>, res_attrs = [{llvm.zeroext}], zero_call_used_regs = "all"}> : (i8, i8) -> i8
  %28 = "llvm.getelementptr"(%19) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 576>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%arg1, %27, %28, %arg0) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef, llvm.zeroext}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_if, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>, zero_call_used_regs = "all"}> : (!llvm.ptr, i8, !llvm.ptr, !llvm.ptr) -> ()
  %29 = "llvm.load"(%arg4) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %30 = "llvm.call"(%7, %29) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef, llvm.zeroext}, {llvm.noundef, llvm.zeroext}], callee = @const_time_eq, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>, res_attrs = [{llvm.zeroext}], zero_call_used_regs = "all"}> : (i8, i8) -> i8
  %31 = "llvm.getelementptr"(%19) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 768>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%arg0, %30, %31, %arg1) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef, llvm.zeroext}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_if, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>, zero_call_used_regs = "all"}> : (!llvm.ptr, i8, !llvm.ptr, !llvm.ptr) -> ()
  %32 = "llvm.load"(%arg4) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %33 = "llvm.call"(%8, %32) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef, llvm.zeroext}, {llvm.noundef, llvm.zeroext}], callee = @const_time_eq, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>, res_attrs = [{llvm.zeroext}], zero_call_used_regs = "all"}> : (i8, i8) -> i8
  %34 = "llvm.getelementptr"(%19) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 960>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%arg1, %33, %34, %arg0) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef, llvm.zeroext}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_if, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>, zero_call_used_regs = "all"}> : (!llvm.ptr, i8, !llvm.ptr, !llvm.ptr) -> ()
  %35 = "llvm.load"(%arg4) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %36 = "llvm.call"(%9, %35) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef, llvm.zeroext}, {llvm.noundef, llvm.zeroext}], callee = @const_time_eq, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>, res_attrs = [{llvm.zeroext}], zero_call_used_regs = "all"}> : (i8, i8) -> i8
  %37 = "llvm.getelementptr"(%19) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1152>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%arg0, %36, %37, %arg1) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef, llvm.zeroext}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_if, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>, zero_call_used_regs = "all"}> : (!llvm.ptr, i8, !llvm.ptr, !llvm.ptr) -> ()
  %38 = "llvm.load"(%arg4) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %39 = "llvm.call"(%0, %38) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef, llvm.zeroext}, {llvm.noundef, llvm.zeroext}], callee = @const_time_eq, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>, res_attrs = [{llvm.zeroext}], zero_call_used_regs = "all"}> : (i8, i8) -> i8
  %40 = "llvm.getelementptr"(%19) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1344>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%arg1, %39, %40, %arg0) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef, llvm.zeroext}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_if, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>, zero_call_used_regs = "all"}> : (!llvm.ptr, i8, !llvm.ptr, !llvm.ptr) -> ()
  %41 = "llvm.load"(%arg5) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  "llvm.call"(%arg0, %arg1, %41) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef, llvm.zeroext}], callee = @fd_ed25519_point_neg_if, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>, zero_call_used_regs = "all"}> : (!llvm.ptr, !llvm.ptr, i8) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

    with
      @fd_ed25519_base_point_const_time_table := Firedancer.LaneNI.Mlir.fd_ed25519_base_point_const_time_table,
      @fd_ed25519_point_set_zero_precomputed := Firedancer.LaneNI.Mlir.fd_ed25519_point_set_zero_precomputed,
      @const_time_eq := Firedancer.LaneNI.Mlir.const_time_eq,
      @fd_ed25519_point_if := Firedancer.LaneNI.Mlir.fd_ed25519_point_if,
      @const_time_eq := Firedancer.LaneNI.Mlir.const_time_eq,
      @fd_ed25519_point_if := Firedancer.LaneNI.Mlir.fd_ed25519_point_if,
      @const_time_eq := Firedancer.LaneNI.Mlir.const_time_eq,
      @fd_ed25519_point_if := Firedancer.LaneNI.Mlir.fd_ed25519_point_if,
      @const_time_eq := Firedancer.LaneNI.Mlir.const_time_eq,
      @fd_ed25519_point_if := Firedancer.LaneNI.Mlir.fd_ed25519_point_if,
      @const_time_eq := Firedancer.LaneNI.Mlir.const_time_eq,
      @fd_ed25519_point_if := Firedancer.LaneNI.Mlir.fd_ed25519_point_if,
      @const_time_eq := Firedancer.LaneNI.Mlir.const_time_eq,
      @fd_ed25519_point_if := Firedancer.LaneNI.Mlir.fd_ed25519_point_if,
      @const_time_eq := Firedancer.LaneNI.Mlir.const_time_eq,
      @fd_ed25519_point_if := Firedancer.LaneNI.Mlir.fd_ed25519_point_if,
      @const_time_eq := Firedancer.LaneNI.Mlir.const_time_eq,
      @fd_ed25519_point_if := Firedancer.LaneNI.Mlir.fd_ed25519_point_if,
      @fd_ed25519_point_neg_if := Firedancer.LaneNI.Mlir.fd_ed25519_point_neg_if

end

end Firedancer.LaneNI.Mlir
