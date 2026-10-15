
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.LaneNI.Mlir.fd_ulong_find_lsb
public import Firedancer.LaneNI.Mlir.fd_int_min
public import Firedancer.LaneNI.Mlir.fd_int_min
public import Firedancer.LaneNI.Mlir.fd_ulong_find_lsb

namespace Firedancer.LaneNI.Mlir

@[expose] public section

mlir_def fd_f25519_posdivsteps_62_var := "llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<i64 (i64, i64, i64, ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], sym_name = "fd_f25519_posdivsteps_62_var", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: i64, %arg1: i64, %arg2: i64, %arg3: !llvm.ptr, %arg4: !llvm.ptr):
  %0 = "llvm.mlir.constant"() <{value = -4611686018427387904 : i64}> : () -> i64
  %1 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %2 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %3 = "llvm.mlir.constant"() <{value = 62 : i32}> : () -> i32
  %4 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %5 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %6 = "llvm.mlir.constant"() <{value = 64 : i32}> : () -> i32
  %7 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %8 = "llvm.mlir.constant"() <{value = 8 : i64}> : () -> i64
  %9 = "llvm.mlir.constant"() <{value = 15 : i64}> : () -> i64
  %10 = "llvm.mlir.constant"() <{value = 62 : i64}> : () -> i64
  %11 = "llvm.mlir.constant"() <{value = 63 : i64}> : () -> i64
  %12 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %13 = "llvm.load"(%arg4) <{alignment = 4 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i32
  %14 = "llvm.or"(%arg2, %0) : (i64, i64) -> i64
  %15 = "llvm.call"(%14) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_ulong_find_lsb, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (i64) -> i32
  %16 = "llvm.zext"(%15) <{nonNeg}> : (i32) -> i64
  %17 = "llvm.shl"(%1, %16) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %18 = "llvm.sub"(%arg0, %16) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %19 = "llvm.lshr"(%arg1, %1) : (i64, i64) -> i64
  %20 = "llvm.lshr"(%arg1, %2) : (i64, i64) -> i64
  %21 = "llvm.xor"(%19, %20) : (i64, i64) -> i64
  %22 = "llvm.trunc"(%21) <{overflowFlags = 0 : i32}> : (i64) -> i32
  %23 = "llvm.and"(%15, %22) : (i32, i32) -> i32
  %24 = "llvm.xor"(%23, %13) : (i32, i32) -> i32
  %25 = "llvm.icmp"(%15, %3) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%25, %4, %1, %17, %4, %18, %24)[^bb6, ^bb1] <{operandSegmentSizes = array<i32: 1, 6, 0>}> : (i1, i64, i64, i64, i64, i64, i32) -> ()
^bb1:  // pred: ^bb0
  %26 = "llvm.sub"(%3, %15) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %27 = "llvm.lshr"(%arg2, %16) : (i64, i64) -> i64
  "llvm.br"(%24, %26, %18, %4, %17, %27, %arg1, %1, %4)[^bb2] : (i32, i32, i64, i64, i64, i64, i64, i64, i64) -> ()
^bb2(%28: i32, %29: i32, %30: i64, %31: i64, %32: i64, %33: i64, %34: i64, %35: i64, %36: i64):  // 2 preds: ^bb1, ^bb5
  %37 = "llvm.icmp"(%30, %4) <{predicate = 2 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%37)[^bb3, ^bb4] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb3:  // pred: ^bb2
  %38 = "llvm.sub"(%4, %30) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %39 = "llvm.and"(%33, %34) : (i64, i64) -> i64
  %40 = "llvm.lshr"(%39, %1) : (i64, i64) -> i64
  %41 = "llvm.trunc"(%40) <{overflowFlags = 0 : i32}> : (i64) -> i32
  %42 = "llvm.xor"(%28, %41) : (i32, i32) -> i32
  %43 = "llvm.trunc"(%38) <{overflowFlags = 0 : i32}> : (i64) -> i32
  %44 = "llvm.add"(%43, %5) <{overflowFlags = 0 : i32}> : (i32, i32) -> i32
  %45 = "llvm.call"(%44, %29) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_int_min, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (i32, i32) -> i32
  %46 = "llvm.sub"(%6, %45) <{overflowFlags = 0 : i32}> : (i32, i32) -> i32
  %47 = "llvm.zext"(%46) <{nonNeg}> : (i32) -> i64
  %48 = "llvm.lshr"(%7, %47) : (i64, i64) -> i64
  %49 = "llvm.mul"(%33, %34) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %50 = "llvm.mul"(%33, %33) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %51 = "llvm.add"(%50, %10) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %52 = "llvm.mul"(%49, %51) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %53 = "llvm.and"(%52, %11) : (i64, i64) -> i64
  %54 = "llvm.and"(%53, %48) : (i64, i64) -> i64
  "llvm.br"(%35, %32, %31, %33, %34, %42, %36, %54, %38)[^bb5] : (i64, i64, i64, i64, i64, i32, i64, i64, i64) -> ()
^bb4:  // pred: ^bb2
  %55 = "llvm.trunc"(%30) <{overflowFlags = 0 : i32}> : (i64) -> i32
  %56 = "llvm.add"(%55, %5) <{overflowFlags = 0 : i32}> : (i32, i32) -> i32
  %57 = "llvm.call"(%56, %29) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_int_min, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (i32, i32) -> i32
  %58 = "llvm.sub"(%6, %57) <{overflowFlags = 0 : i32}> : (i32, i32) -> i32
  %59 = "llvm.zext"(%58) <{nonNeg}> : (i32) -> i64
  %60 = "llvm.lshr"(%7, %59) : (i64, i64) -> i64
  %61 = "llvm.shl"(%34, %1) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %62 = "llvm.add"(%61, %2) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %63 = "llvm.and"(%62, %8) : (i64, i64) -> i64
  %64 = "llvm.add"(%63, %34) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %65 = "llvm.mul"(%64, %33) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %66 = "llvm.sub"(%4, %65) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %67 = "llvm.and"(%66, %9) : (i64, i64) -> i64
  %68 = "llvm.and"(%67, %60) : (i64, i64) -> i64
  "llvm.br"(%31, %36, %35, %34, %33, %28, %32, %68, %30)[^bb5] : (i64, i64, i64, i64, i64, i32, i64, i64, i64) -> ()
^bb5(%69: i64, %70: i64, %71: i64, %72: i64, %73: i64, %74: i32, %75: i64, %76: i64, %77: i64):  // 2 preds: ^bb3, ^bb4
  %78 = "llvm.mul"(%76, %72) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %79 = "llvm.add"(%78, %73) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %80 = "llvm.mul"(%76, %75) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %81 = "llvm.add"(%80, %70) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %82 = "llvm.mul"(%76, %69) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %83 = "llvm.add"(%82, %71) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %84 = "llvm.zext"(%29) <{nonNeg}> : (i32) -> i64
  %85 = "llvm.shl"(%7, %84) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %86 = "llvm.or"(%85, %79) : (i64, i64) -> i64
  %87 = "llvm.call"(%86) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_ulong_find_lsb, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (i64) -> i32
  %88 = "llvm.zext"(%87) <{nonNeg}> : (i32) -> i64
  %89 = "llvm.lshr"(%79, %88) : (i64, i64) -> i64
  %90 = "llvm.shl"(%75, %88) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %91 = "llvm.shl"(%69, %88) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %92 = "llvm.sub"(%77, %88) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %93 = "llvm.sub"(%29, %87) <{overflowFlags = 0 : i32}> : (i32, i32) -> i32
  %94 = "llvm.lshr"(%72, %1) : (i64, i64) -> i64
  %95 = "llvm.lshr"(%72, %2) : (i64, i64) -> i64
  %96 = "llvm.xor"(%94, %95) : (i64, i64) -> i64
  %97 = "llvm.trunc"(%96) <{overflowFlags = 0 : i32}> : (i64) -> i32
  %98 = "llvm.and"(%87, %97) : (i32, i32) -> i32
  %99 = "llvm.xor"(%98, %74) : (i32, i32) -> i32
  %100 = "llvm.icmp"(%93, %12) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%100, %81, %83, %90, %91, %92, %99, %99, %93, %92, %91, %90, %89, %72, %83, %81)[^bb6, ^bb2] <{operandSegmentSizes = array<i32: 1, 6, 9>}> : (i1, i64, i64, i64, i64, i64, i32, i32, i32, i64, i64, i64, i64, i64, i64, i64) -> ()
^bb6(%101: i64, %102: i64, %103: i64, %104: i64, %105: i64, %106: i32):  // 2 preds: ^bb0, ^bb5
  "llvm.store"(%103, %arg3) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %107 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%104, %107) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %108 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%101, %108) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %109 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%102, %109) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  "llvm.store"(%106, %arg4) <{alignment = 4 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i32, !llvm.ptr) -> ()
  "llvm.return"(%105) : (i64) -> ()
}) : () -> ()

    with
      @fd_ulong_find_lsb := Firedancer.LaneNI.Mlir.fd_ulong_find_lsb,
      @fd_int_min := Firedancer.LaneNI.Mlir.fd_int_min,
      @fd_int_min := Firedancer.LaneNI.Mlir.fd_int_min,
      @fd_ulong_find_lsb := Firedancer.LaneNI.Mlir.fd_ulong_find_lsb

end

end Firedancer.LaneNI.Mlir
