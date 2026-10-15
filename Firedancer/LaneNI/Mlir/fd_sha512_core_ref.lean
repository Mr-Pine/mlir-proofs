
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.LaneNI.Mlir.fd_sha512_core_ref_K
public import Firedancer.LaneNI.Mlir.fd_ulong_bswap
public import Firedancer.LaneNI.Mlir.fd_ulong_rotate_right
public import Firedancer.LaneNI.Mlir.fd_ulong_rotate_right
public import Firedancer.LaneNI.Mlir.fd_ulong_rotate_right
public import Firedancer.LaneNI.Mlir.fd_ulong_rotate_right
public import Firedancer.LaneNI.Mlir.fd_ulong_rotate_right
public import Firedancer.LaneNI.Mlir.fd_ulong_rotate_right
public import Firedancer.LaneNI.Mlir.fd_ulong_rotate_right
public import Firedancer.LaneNI.Mlir.fd_ulong_rotate_right
public import Firedancer.LaneNI.Mlir.fd_ulong_rotate_right
public import Firedancer.LaneNI.Mlir.fd_ulong_rotate_right
public import Firedancer.LaneNI.Mlir.fd_ulong_rotate_right
public import Firedancer.LaneNI.Mlir.fd_ulong_rotate_right
public import Firedancer.LaneNI.Mlir.fd_ulong_rotate_right
public import Firedancer.LaneNI.Mlir.fd_ulong_rotate_right
public import Firedancer.LaneNI.Mlir.fd_ulong_rotate_right
public import Firedancer.LaneNI.Mlir.fd_ulong_rotate_right

namespace Firedancer.LaneNI.Mlir

@[expose] public section

mlir_def fd_sha512_core_ref := "llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.noundef, llvm.range = #llvm.constant_range<i64, 1, 144115188075855872>}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr, i64)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], sym_name = "fd_sha512_core_ref", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: i64):
  %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1 = "llvm.mlir.constant"() <{value = 16 : i64}> : () -> i64
  %2 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %3 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %4 = "llvm.mlir.constant"() <{value = 14 : i32}> : () -> i32
  %5 = "llvm.mlir.constant"() <{value = 18 : i32}> : () -> i32
  %6 = "llvm.mlir.constant"() <{value = 41 : i32}> : () -> i32
  %7 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %8 = "llvm.mlir.addressof"() <{global_name = @fd_sha512_core_ref.K}> : () -> !llvm.ptr
  %9 = "llvm.mlir.constant"() <{value = 28 : i32}> : () -> i32
  %10 = "llvm.mlir.constant"() <{value = 34 : i32}> : () -> i32
  %11 = "llvm.mlir.constant"() <{value = 39 : i32}> : () -> i32
  %12 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %13 = "llvm.mlir.constant"() <{value = 15 : i64}> : () -> i64
  %14 = "llvm.mlir.constant"() <{value = 14 : i64}> : () -> i64
  %15 = "llvm.mlir.constant"() <{value = 8 : i32}> : () -> i32
  %16 = "llvm.mlir.constant"() <{value = 7 : i64}> : () -> i64
  %17 = "llvm.mlir.constant"() <{value = 19 : i32}> : () -> i32
  %18 = "llvm.mlir.constant"() <{value = 61 : i32}> : () -> i32
  %19 = "llvm.mlir.constant"() <{value = 6 : i64}> : () -> i64
  %20 = "llvm.mlir.constant"() <{value = 9 : i64}> : () -> i64
  %21 = "llvm.mlir.constant"() <{value = 80 : i64}> : () -> i64
  %22 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.array<16 x i64>}> : (i32) -> !llvm.ptr
  %23 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %24 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %25 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %26 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %27 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  %28 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 48>}> : (!llvm.ptr) -> !llvm.ptr
  %29 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 56>}> : (!llvm.ptr) -> !llvm.ptr
  %30 = "llvm.load"(%arg0) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %31 = "llvm.load"(%23) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %32 = "llvm.load"(%24) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %33 = "llvm.load"(%25) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %34 = "llvm.load"(%26) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %35 = "llvm.load"(%27) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %36 = "llvm.load"(%28) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %37 = "llvm.load"(%29) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  "llvm.br"(%37, %36, %35, %34, %33, %32, %31, %30, %arg1, %arg2)[^bb1] : (i64, i64, i64, i64, i64, i64, i64, i64, !llvm.ptr, i64) -> ()
^bb1(%38: i64, %39: i64, %40: i64, %41: i64, %42: i64, %43: i64, %44: i64, %45: i64, %46: !llvm.ptr, %47: i64):  // 2 preds: ^bb0, ^bb4
  "llvm.intr.lifetime.start"(%22) : (!llvm.ptr) -> ()
  "llvm.br"(%45, %44, %43, %42, %41, %40, %2, %38, %39)[^bb2] : (i64, i64, i64, i64, i64, i64, i64, i64, i64) -> ()
^bb2(%48: i64, %49: i64, %50: i64, %51: i64, %52: i64, %53: i64, %54: i64, %55: i64, %56: i64):  // 2 preds: ^bb1, ^bb2
  %57 = "llvm.shl"(%54, %3) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %58 = "llvm.getelementptr"(%46, %57) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %59 = "llvm.load"(%58) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %60 = "llvm.call"(%59) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_ulong_bswap, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (i64) -> i64
  %61 = "llvm.getelementptr"(%22, %54) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%60, %61) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %62 = "llvm.call"(%52, %4) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ulong_rotate_right, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (i64, i32) -> i64
  %63 = "llvm.call"(%52, %5) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ulong_rotate_right, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (i64, i32) -> i64
  %64 = "llvm.xor"(%63, %62) : (i64, i64) -> i64
  %65 = "llvm.call"(%52, %6) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ulong_rotate_right, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (i64, i32) -> i64
  %66 = "llvm.xor"(%64, %65) : (i64, i64) -> i64
  %67 = "llvm.and"(%52, %53) : (i64, i64) -> i64
  %68 = "llvm.xor"(%52, %7) : (i64, i64) -> i64
  %69 = "llvm.and"(%56, %68) : (i64, i64) -> i64
  %70 = "llvm.or"(%67, %69) <{isDisjoint}> : (i64, i64) -> i64
  %71 = "llvm.getelementptr"(%8, %54) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %72 = "llvm.load"(%71) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %73 = "llvm.add"(%70, %55) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %74 = "llvm.add"(%73, %60) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %75 = "llvm.add"(%74, %66) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %76 = "llvm.add"(%75, %72) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %77 = "llvm.call"(%48, %9) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ulong_rotate_right, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (i64, i32) -> i64
  %78 = "llvm.call"(%48, %10) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ulong_rotate_right, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (i64, i32) -> i64
  %79 = "llvm.xor"(%78, %77) : (i64, i64) -> i64
  %80 = "llvm.call"(%48, %11) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ulong_rotate_right, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (i64, i32) -> i64
  %81 = "llvm.xor"(%79, %80) : (i64, i64) -> i64
  %82 = "llvm.xor"(%49, %50) : (i64, i64) -> i64
  %83 = "llvm.and"(%48, %82) : (i64, i64) -> i64
  %84 = "llvm.and"(%49, %50) : (i64, i64) -> i64
  %85 = "llvm.xor"(%83, %84) : (i64, i64) -> i64
  %86 = "llvm.add"(%76, %51) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %87 = "llvm.add"(%76, %85) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %88 = "llvm.add"(%87, %81) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %89 = "llvm.add"(%54, %12) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %90 = "llvm.icmp"(%89, %1) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%90, %88, %48, %49, %50, %86, %52, %1, %56, %53, %88, %48, %49, %50, %86, %52, %89, %56, %53)[^bb3, ^bb2] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 9, 9>}> : (i1, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64) -> ()
^bb3(%91: i64, %92: i64, %93: i64, %94: i64, %95: i64, %96: i64, %97: i64, %98: i64, %99: i64):  // 2 preds: ^bb2, ^bb3
  %100 = "llvm.add"(%97, %12) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %101 = "llvm.and"(%100, %13) : (i64, i64) -> i64
  %102 = "llvm.getelementptr"(%22, %101) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %103 = "llvm.load"(%102) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %104 = "llvm.add"(%97, %14) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %105 = "llvm.and"(%104, %13) : (i64, i64) -> i64
  %106 = "llvm.getelementptr"(%22, %105) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %107 = "llvm.load"(%106) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %108 = "llvm.call"(%103, %0) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ulong_rotate_right, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (i64, i32) -> i64
  %109 = "llvm.call"(%103, %15) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ulong_rotate_right, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (i64, i32) -> i64
  %110 = "llvm.lshr"(%103, %16) : (i64, i64) -> i64
  %111 = "llvm.xor"(%108, %110) : (i64, i64) -> i64
  %112 = "llvm.xor"(%111, %109) : (i64, i64) -> i64
  %113 = "llvm.call"(%107, %17) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ulong_rotate_right, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (i64, i32) -> i64
  %114 = "llvm.call"(%107, %18) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ulong_rotate_right, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (i64, i32) -> i64
  %115 = "llvm.lshr"(%107, %19) : (i64, i64) -> i64
  %116 = "llvm.xor"(%113, %115) : (i64, i64) -> i64
  %117 = "llvm.xor"(%116, %114) : (i64, i64) -> i64
  %118 = "llvm.add"(%97, %20) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %119 = "llvm.and"(%118, %13) : (i64, i64) -> i64
  %120 = "llvm.getelementptr"(%22, %119) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %121 = "llvm.load"(%120) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %122 = "llvm.and"(%97, %13) : (i64, i64) -> i64
  %123 = "llvm.getelementptr"(%22, %122) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %124 = "llvm.load"(%123) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %125 = "llvm.add"(%121, %112) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %126 = "llvm.add"(%125, %117) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %127 = "llvm.add"(%126, %124) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%127, %123) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %128 = "llvm.call"(%95, %4) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ulong_rotate_right, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (i64, i32) -> i64
  %129 = "llvm.call"(%95, %5) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ulong_rotate_right, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (i64, i32) -> i64
  %130 = "llvm.xor"(%129, %128) : (i64, i64) -> i64
  %131 = "llvm.call"(%95, %6) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ulong_rotate_right, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (i64, i32) -> i64
  %132 = "llvm.xor"(%130, %131) : (i64, i64) -> i64
  %133 = "llvm.and"(%95, %96) : (i64, i64) -> i64
  %134 = "llvm.xor"(%95, %7) : (i64, i64) -> i64
  %135 = "llvm.and"(%99, %134) : (i64, i64) -> i64
  %136 = "llvm.or"(%133, %135) : (i64, i64) -> i64
  %137 = "llvm.getelementptr"(%8, %97) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %138 = "llvm.load"(%137) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %139 = "llvm.add"(%136, %98) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %140 = "llvm.add"(%139, %127) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %141 = "llvm.add"(%140, %132) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %142 = "llvm.add"(%141, %138) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %143 = "llvm.call"(%91, %9) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ulong_rotate_right, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (i64, i32) -> i64
  %144 = "llvm.call"(%91, %10) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ulong_rotate_right, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (i64, i32) -> i64
  %145 = "llvm.xor"(%144, %143) : (i64, i64) -> i64
  %146 = "llvm.call"(%91, %11) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ulong_rotate_right, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (i64, i32) -> i64
  %147 = "llvm.xor"(%145, %146) : (i64, i64) -> i64
  %148 = "llvm.xor"(%92, %93) : (i64, i64) -> i64
  %149 = "llvm.and"(%91, %148) : (i64, i64) -> i64
  %150 = "llvm.and"(%92, %93) : (i64, i64) -> i64
  %151 = "llvm.xor"(%149, %150) : (i64, i64) -> i64
  %152 = "llvm.add"(%142, %94) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %153 = "llvm.add"(%142, %151) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %154 = "llvm.add"(%153, %147) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %155 = "llvm.icmp"(%100, %21) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%155, %154, %91, %92, %93, %152, %95, %100, %99, %96)[^bb4, ^bb3] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 9>}> : (i1, i64, i64, i64, i64, i64, i64, i64, i64, i64) -> ()
^bb4:  // pred: ^bb3
  %156 = "llvm.add"(%154, %45) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%156, %arg0) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %157 = "llvm.add"(%91, %44) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%157, %23) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %158 = "llvm.add"(%92, %43) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%158, %24) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %159 = "llvm.add"(%93, %42) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%159, %25) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %160 = "llvm.add"(%152, %41) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%160, %26) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %161 = "llvm.add"(%95, %40) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%161, %27) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %162 = "llvm.add"(%96, %39) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%162, %28) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %163 = "llvm.add"(%99, %38) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%163, %29) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %164 = "llvm.getelementptr"(%46) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.lifetime.end"(%22) : (!llvm.ptr) -> ()
  %165 = "llvm.add"(%47, %7) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %166 = "llvm.icmp"(%165, %2) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%166, %163, %162, %161, %160, %159, %158, %157, %156, %164, %165)[^bb5, ^bb1] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 10>}> : (i1, i64, i64, i64, i64, i64, i64, i64, i64, !llvm.ptr, i64) -> ()
^bb5:  // pred: ^bb4
  "llvm.return"() : () -> ()
}) : () -> ()

    with
      @fd_sha512_core_ref.K := Firedancer.LaneNI.Mlir.fd_sha512_core_ref_K,
      @fd_ulong_bswap := Firedancer.LaneNI.Mlir.fd_ulong_bswap,
      @fd_ulong_rotate_right := Firedancer.LaneNI.Mlir.fd_ulong_rotate_right,
      @fd_ulong_rotate_right := Firedancer.LaneNI.Mlir.fd_ulong_rotate_right,
      @fd_ulong_rotate_right := Firedancer.LaneNI.Mlir.fd_ulong_rotate_right,
      @fd_ulong_rotate_right := Firedancer.LaneNI.Mlir.fd_ulong_rotate_right,
      @fd_ulong_rotate_right := Firedancer.LaneNI.Mlir.fd_ulong_rotate_right,
      @fd_ulong_rotate_right := Firedancer.LaneNI.Mlir.fd_ulong_rotate_right,
      @fd_ulong_rotate_right := Firedancer.LaneNI.Mlir.fd_ulong_rotate_right,
      @fd_ulong_rotate_right := Firedancer.LaneNI.Mlir.fd_ulong_rotate_right,
      @fd_ulong_rotate_right := Firedancer.LaneNI.Mlir.fd_ulong_rotate_right,
      @fd_ulong_rotate_right := Firedancer.LaneNI.Mlir.fd_ulong_rotate_right,
      @fd_ulong_rotate_right := Firedancer.LaneNI.Mlir.fd_ulong_rotate_right,
      @fd_ulong_rotate_right := Firedancer.LaneNI.Mlir.fd_ulong_rotate_right,
      @fd_ulong_rotate_right := Firedancer.LaneNI.Mlir.fd_ulong_rotate_right,
      @fd_ulong_rotate_right := Firedancer.LaneNI.Mlir.fd_ulong_rotate_right,
      @fd_ulong_rotate_right := Firedancer.LaneNI.Mlir.fd_ulong_rotate_right,
      @fd_ulong_rotate_right := Firedancer.LaneNI.Mlir.fd_ulong_rotate_right

end

end Firedancer.LaneNI.Mlir
