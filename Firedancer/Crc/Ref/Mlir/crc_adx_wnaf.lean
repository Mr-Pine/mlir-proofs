
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab



namespace MLIR.Firedancer.Crc.Ref

@[expose] public section

mlir_def crc_adx_wnaf := "llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.noundef, llvm.range = #llvm.constant_range<i32, 3, 9>}], dso_local, function_type = !llvm.func<i32 (ptr, ptr, i32)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], sym_name = "crc_adx_wnaf", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: i32):
  %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %2 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %3 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %4 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %5 = "llvm.mlir.constant"() <{value = 0 : i16}> : () -> i16
  %6 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %7 = "llvm.mlir.constant"() <{value = false}> : () -> i1
  %8 = "llvm.mlir.constant"() <{value = 63 : i64}> : () -> i64
  %9 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.array<4 x i64>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%9) : (!llvm.ptr) -> ()
  %10 = "llvm.load"(%arg1) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %11 = "llvm.getelementptr"(%9) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %12 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %13 = "llvm.load"(%12) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  "llvm.store"(%13, %11) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %14 = "llvm.getelementptr"(%9) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %15 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %16 = "llvm.load"(%15) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  "llvm.store"(%16, %14) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %17 = "llvm.getelementptr"(%9) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %18 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %19 = "llvm.load"(%18) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  "llvm.store"(%19, %17) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %20 = "llvm.add"(%arg2, %0) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %21 = "llvm.zext"(%20) <{nonNeg}> : (i32) -> i64
  %22 = "llvm.shl"(%1, %21) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %23 = "llvm.add"(%22, %2) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %24 = "llvm.zext"(%arg2) <{nonNeg}> : (i32) -> i64
  %25 = "llvm.or"(%13, %16) : (i64, i64) -> i64
  %26 = "llvm.or"(%25, %19) : (i64, i64) -> i64
  %27 = "llvm.or"(%26, %10) : (i64, i64) -> i64
  %28 = "llvm.icmp"(%27, %3) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%28, %4, %19, %16, %13, %4, %10)[^bb9, ^bb1] <{operandSegmentSizes = array<i32: 1, 1, 5>}> : (i1, i32, i64, i64, i64, i32, i64) -> ()
^bb1(%29: i64, %30: i64, %31: i64, %32: i32, %33: i64):  // 2 preds: ^bb0, ^bb8
  %34 = "llvm.and"(%33, %1) : (i64, i64) -> i64
  %35 = "llvm.icmp"(%34, %3) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%35, %29, %30, %31, %33, %5)[^bb8, ^bb2] <{operandSegmentSizes = array<i32: 1, 5, 0>}> : (i1, i64, i64, i64, i64, i16) -> ()
^bb2:  // pred: ^bb1
  %36 = "llvm.and"(%33, %23) : (i64, i64) -> i64
  %37 = "llvm.lshr"(%36, %24) : (i64, i64) -> i64
  %38 = "llvm.icmp"(%37, %3) <{predicate = 0 : i64}> : (i64, i64) -> i1
  %39 = "llvm.select"(%38, %3, %22) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %40 = "llvm.sub"(%36, %39) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %41 = "llvm.icmp"(%40, %3) <{predicate = 4 : i64}> : (i64, i64) -> i1
  %42 = "llvm.icmp"(%40, %33) <{predicate = 8 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%41)[^bb3, ^bb5] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb3:  // pred: ^bb2
  "llvm.cond_br"(%42, %1)[^bb4, ^bb7] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
^bb4(%43: i64):  // 2 preds: ^bb3, ^bb4
  %44 = "llvm.getelementptr"(%9, %43) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %45 = "llvm.load"(%44) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %46 = "llvm.add"(%45, %2) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %47 = "llvm.icmp"(%45, %3) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.store"(%46, %44) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %48 = "llvm.add"(%43, %1) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %49 = "llvm.icmp"(%43, %6) <{predicate = 6 : i64}> : (i64, i64) -> i1
  %50 = "llvm.select"(%49, %47, %7) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i1, i1) -> i1
  "llvm.cond_br"(%50, %48)[^bb4, ^bb7] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
^bb5:  // pred: ^bb2
  "llvm.cond_br"(%42, %1)[^bb7, ^bb6] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb6(%51: i64):  // 2 preds: ^bb5, ^bb6
  %52 = "llvm.getelementptr"(%9, %51) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %53 = "llvm.load"(%52) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %54 = "llvm.add"(%53, %1) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %55 = "llvm.icmp"(%53, %2) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.store"(%54, %52) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %56 = "llvm.add"(%51, %1) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %57 = "llvm.icmp"(%51, %6) <{predicate = 6 : i64}> : (i64, i64) -> i1
  %58 = "llvm.select"(%57, %55, %7) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i1, i1) -> i1
  "llvm.cond_br"(%58, %56)[^bb6, ^bb7] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
^bb7:  // 4 preds: ^bb3, ^bb4, ^bb5, ^bb6
  %59 = "llvm.sub"(%33, %40) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %60 = "llvm.trunc"(%40) <{overflowFlags = 1 : i32}> : (i64) -> i16
  %61 = "llvm.load"(%11) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %62 = "llvm.load"(%14) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %63 = "llvm.load"(%17) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  "llvm.br"(%63, %62, %61, %59, %60)[^bb8] : (i64, i64, i64, i64, i16) -> ()
^bb8(%64: i64, %65: i64, %66: i64, %67: i64, %68: i16):  // 2 preds: ^bb1, ^bb7
  %69 = "llvm.add"(%32, %0) <{overflowFlags = 0 : i32}> : (i32, i32) -> i32
  %70 = "llvm.sext"(%32) : (i32) -> i64
  %71 = "llvm.getelementptr"(%arg0, %70) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%68, %71) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i16, !llvm.ptr) -> ()
  %72 = "llvm.intr.fshl"(%66, %67, %8) : (i64, i64, i64) -> i64
  %73 = "llvm.intr.fshl"(%65, %66, %8) : (i64, i64, i64) -> i64
  "llvm.store"(%73, %11) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %74 = "llvm.intr.fshl"(%64, %65, %8) : (i64, i64, i64) -> i64
  "llvm.store"(%74, %14) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %75 = "llvm.lshr"(%64, %1) : (i64, i64) -> i64
  "llvm.store"(%75, %17) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %76 = "llvm.or"(%73, %72) : (i64, i64) -> i64
  %77 = "llvm.or"(%76, %74) : (i64, i64) -> i64
  %78 = "llvm.or"(%77, %75) : (i64, i64) -> i64
  %79 = "llvm.icmp"(%78, %3) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%79, %69, %75, %74, %73, %69, %72)[^bb9, ^bb1] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 1, 5>}> : (i1, i32, i64, i64, i64, i32, i64) -> ()
^bb9(%80: i32):  // 2 preds: ^bb0, ^bb8
  "llvm.intr.lifetime.end"(%9) : (!llvm.ptr) -> ()
  "llvm.return"(%80) : (i32) -> ()
}) : () -> ()

end

end MLIR.Firedancer.Crc.Ref
