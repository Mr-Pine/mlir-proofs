
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab



namespace Firedancer.LaneNI.Mlir

@[expose] public section

mlir_def fd_f25519_update_fg_62_var := "llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (i32, ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], sym_name = "fd_f25519_update_fg_62_var", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: i32, %arg1: !llvm.ptr, %arg2: !llvm.ptr, %arg3: !llvm.ptr):
  %0 = "llvm.mlir.constant"() <{value = 62 : i128}> : () -> i128
  %1 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %2 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %3 = "llvm.mlir.constant"() <{value = 4611686018427387903 : i64}> : () -> i64
  %4 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %5 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
  %6 = "llvm.load"(%arg3) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %7 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %8 = "llvm.load"(%7) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %9 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %10 = "llvm.load"(%9) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %11 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %12 = "llvm.load"(%11) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %13 = "llvm.sext"(%6) : (i64) -> i128
  %14 = "llvm.load"(%arg1) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %15 = "llvm.sext"(%14) : (i64) -> i128
  %16 = "llvm.mul"(%15, %13) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %17 = "llvm.sext"(%8) : (i64) -> i128
  %18 = "llvm.load"(%arg2) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %19 = "llvm.sext"(%18) : (i64) -> i128
  %20 = "llvm.mul"(%19, %17) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %21 = "llvm.add"(%20, %16) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %22 = "llvm.sext"(%10) : (i64) -> i128
  %23 = "llvm.mul"(%15, %22) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %24 = "llvm.sext"(%12) : (i64) -> i128
  %25 = "llvm.mul"(%19, %24) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %26 = "llvm.add"(%25, %23) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %27 = "llvm.ashr"(%26, %0) : (i128, i128) -> i128
  %28 = "llvm.ashr"(%21, %0) : (i128, i128) -> i128
  %29 = "llvm.icmp"(%arg0, %1) <{predicate = 4 : i64}> : (i32, i32) -> i1
  %30 = "llvm.trunc"(%27) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %31 = "llvm.trunc"(%28) <{overflowFlags = 0 : i32}> : (i128) -> i64
  "llvm.cond_br"(%29, %30, %31)[^bb1, ^bb3] <{operandSegmentSizes = array<i32: 1, 0, 2>}> : (i1, i64, i64) -> ()
^bb1:  // pred: ^bb0
  %32 = "llvm.zext"(%arg0) <{nonNeg}> : (i32) -> i64
  "llvm.br"(%2, %28, %27)[^bb4] : (i64, i128, i128) -> ()
^bb2:  // pred: ^bb4
  %33 = "llvm.trunc"(%67) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %34 = "llvm.trunc"(%66) <{overflowFlags = 0 : i32}> : (i128) -> i64
  "llvm.br"(%34, %33)[^bb3] : (i64, i64) -> ()
^bb3(%35: i64, %36: i64):  // 2 preds: ^bb0, ^bb2
  %37 = "llvm.add"(%arg0, %5) <{overflowFlags = 0 : i32}> : (i32, i32) -> i32
  %38 = "llvm.sext"(%37) : (i32) -> i64
  %39 = "llvm.getelementptr"(%arg1, %38) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%36, %39) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %40 = "llvm.getelementptr"(%arg2, %38) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%35, %40) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
^bb4(%41: i64, %42: i128, %43: i128):  // 2 preds: ^bb1, ^bb4
  %44 = "llvm.getelementptr"(%arg1, %41) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %45 = "llvm.load"(%44) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %46 = "llvm.sext"(%45) : (i64) -> i128
  %47 = "llvm.mul"(%46, %13) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %48 = "llvm.getelementptr"(%arg2, %41) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %49 = "llvm.load"(%48) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %50 = "llvm.sext"(%49) : (i64) -> i128
  %51 = "llvm.mul"(%50, %17) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %52 = "llvm.add"(%47, %42) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %53 = "llvm.add"(%52, %51) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %54 = "llvm.mul"(%46, %22) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %55 = "llvm.mul"(%50, %24) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %56 = "llvm.add"(%54, %43) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %57 = "llvm.add"(%56, %55) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %58 = "llvm.trunc"(%53) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %59 = "llvm.and"(%58, %3) : (i64, i64) -> i64
  %60 = "llvm.add"(%41, %4) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %61 = "llvm.getelementptr"(%arg1, %60) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%59, %61) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %62 = "llvm.trunc"(%57) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %63 = "llvm.and"(%62, %3) : (i64, i64) -> i64
  %64 = "llvm.getelementptr"(%arg2, %60) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%63, %64) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %65 = "llvm.add"(%41, %2) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %66 = "llvm.ashr"(%57, %0) : (i128, i128) -> i128
  %67 = "llvm.ashr"(%53, %0) : (i128, i128) -> i128
  %68 = "llvm.icmp"(%65, %32) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%68, %65, %67, %66)[^bb2, ^bb4] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 3>}> : (i1, i64, i128, i128) -> ()
}) : () -> ()

end

end Firedancer.LaneNI.Mlir
