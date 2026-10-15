
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab



namespace MLIR.Firedancer.Crc.Ref

@[expose] public section

mlir_def crc_adx_affine_is_small_order := "llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<i32 (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], res_attrs = [{llvm.range = #llvm.constant_range<i32, 0, 2>}], sym_name = "crc_adx_affine_is_small_order", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr):
  %0 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %1 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %2 = "llvm.mlir.constant"() <{value = 2707385501144840649318225287225658788936804267575313519463743609750303402022 : i256}> : () -> i256
  %3 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %4 = "llvm.mlir.constant"() <{value = 55188659117513257062467267217118295137698188065244968500265048394206261417927 : i256}> : () -> i256
  %5 = "llvm.load"(%arg0) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %6 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %7 = "llvm.load"(%6) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %8 = "llvm.or"(%7, %5) : (i64, i64) -> i64
  %9 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %10 = "llvm.load"(%9) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %11 = "llvm.or"(%8, %10) : (i64, i64) -> i64
  %12 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %13 = "llvm.load"(%12) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %14 = "llvm.or"(%11, %13) : (i64, i64) -> i64
  %15 = "llvm.icmp"(%14, %0) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%15, %1)[^bb4, ^bb1] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i32) -> ()
^bb1:  // pred: ^bb0
  %16 = "llvm.load"(%arg1) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %17 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %18 = "llvm.load"(%17) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %19 = "llvm.or"(%18, %16) : (i64, i64) -> i64
  %20 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %21 = "llvm.load"(%20) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %22 = "llvm.or"(%19, %21) : (i64, i64) -> i64
  %23 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %24 = "llvm.load"(%23) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %25 = "llvm.or"(%22, %24) : (i64, i64) -> i64
  %26 = "llvm.icmp"(%25, %0) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%26, %1)[^bb4, ^bb2] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i32) -> ()
^bb2:  // pred: ^bb1
  %27 = "llvm.load"(%arg1) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i256
  %28 = "llvm.icmp"(%27, %2) <{predicate = 1 : i64}> : (i256, i256) -> i1
  %29 = "llvm.zext"(%28) : (i1) -> i32
  %30 = "llvm.icmp"(%29, %3) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%30, %1)[^bb4, ^bb3] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i32) -> ()
^bb3:  // pred: ^bb2
  %31 = "llvm.load"(%arg1) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i256
  %32 = "llvm.icmp"(%31, %4) <{predicate = 1 : i64}> : (i256, i256) -> i1
  %33 = "llvm.zext"(%32) : (i1) -> i32
  %34 = "llvm.icmp"(%33, %3) <{predicate = 0 : i64}> : (i32, i32) -> i1
  %35 = "llvm.zext"(%34) : (i1) -> i32
  "llvm.br"(%35)[^bb4] : (i32) -> ()
^bb4(%36: i32):  // 4 preds: ^bb0, ^bb1, ^bb2, ^bb3
  "llvm.return"(%36) : (i32) -> ()
}) : () -> ()

end

end MLIR.Firedancer.Crc.Ref
