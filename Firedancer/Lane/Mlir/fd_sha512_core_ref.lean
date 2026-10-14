
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.Lane.Mlir.fd_sha512_core_ref_K

namespace Firedancer.Lane.Mlir

@[expose] public section

mlir_def fd_sha512_core_ref := "llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.noundef, llvm.range = #llvm.constant_range<i64, 1, 144115188075855872>}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr, i64)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], sym_name = "fd_sha512_core_ref", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: i64):
  %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1 = "llvm.mlir.constant"() <{value = 16 : i64}> : () -> i64
  %2 = "llvm.mlir.constant"() <{value = 56 : i64}> : () -> i64
  %3 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %4 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %5 = "llvm.mlir.constant"() <{value = 50 : i64}> : () -> i64
  %6 = "llvm.mlir.constant"() <{value = 46 : i64}> : () -> i64
  %7 = "llvm.mlir.constant"() <{value = 23 : i64}> : () -> i64
  %8 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %9 = "llvm.mlir.addressof"() <{global_name = @fd_sha512_core_ref.K}> : () -> !llvm.ptr
  %10 = "llvm.mlir.constant"() <{value = 36 : i64}> : () -> i64
  %11 = "llvm.mlir.constant"() <{value = 30 : i64}> : () -> i64
  %12 = "llvm.mlir.constant"() <{value = 25 : i64}> : () -> i64
  %13 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %14 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %15 = "llvm.mlir.constant"() <{value = 15 : i64}> : () -> i64
  %16 = "llvm.mlir.constant"() <{value = 14 : i64}> : () -> i64
  %17 = "llvm.mlir.constant"() <{value = 63 : i64}> : () -> i64
  %18 = "llvm.mlir.constant"() <{value = 7 : i64}> : () -> i64
  %19 = "llvm.mlir.constant"() <{value = 45 : i64}> : () -> i64
  %20 = "llvm.mlir.constant"() <{value = 6 : i64}> : () -> i64
  %21 = "llvm.mlir.constant"() <{value = 9 : i64}> : () -> i64
  %22 = "llvm.mlir.constant"() <{value = 10 : i64}> : () -> i64
  %23 = "llvm.mlir.constant"() <{value = 80 : i64}> : () -> i64
  %24 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.array<16 x i64>}> : (i32) -> !llvm.ptr
  %25 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %26 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %27 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %28 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %29 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  %30 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 48>}> : (!llvm.ptr) -> !llvm.ptr
  %31 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 56>}> : (!llvm.ptr) -> !llvm.ptr
  %32 = "llvm.load"(%arg0) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %33 = "llvm.load"(%25) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %34 = "llvm.load"(%26) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %35 = "llvm.load"(%27) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %36 = "llvm.load"(%28) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %37 = "llvm.load"(%29) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %38 = "llvm.load"(%30) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %39 = "llvm.load"(%31) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  "llvm.br"(%39, %38, %37, %36, %35, %34, %33, %32, %arg1, %arg2)[^bb1] : (i64, i64, i64, i64, i64, i64, i64, i64, !llvm.ptr, i64) -> ()
^bb1(%40: i64, %41: i64, %42: i64, %43: i64, %44: i64, %45: i64, %46: i64, %47: i64, %48: !llvm.ptr, %49: i64):  // 2 preds: ^bb0, ^bb4
  "llvm.intr.lifetime.start"(%24) : (!llvm.ptr) -> ()
  "llvm.br"(%47, %46, %45, %44, %43, %42, %3, %40, %41)[^bb2] : (i64, i64, i64, i64, i64, i64, i64, i64, i64) -> ()
^bb2(%50: i64, %51: i64, %52: i64, %53: i64, %54: i64, %55: i64, %56: i64, %57: i64, %58: i64):  // 2 preds: ^bb1, ^bb2
  %59 = "llvm.shl"(%56, %4) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %60 = "llvm.getelementptr"(%48, %59) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %61 = "llvm.load"(%60) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %62 = "llvm.intr.bswap"(%61) : (i64) -> i64
  %63 = "llvm.getelementptr"(%24, %56) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%62, %63) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %64 = "llvm.intr.fshl"(%54, %54, %5) : (i64, i64, i64) -> i64
  %65 = "llvm.intr.fshl"(%54, %54, %6) : (i64, i64, i64) -> i64
  %66 = "llvm.xor"(%64, %65) : (i64, i64) -> i64
  %67 = "llvm.intr.fshl"(%54, %54, %7) : (i64, i64, i64) -> i64
  %68 = "llvm.xor"(%66, %67) : (i64, i64) -> i64
  %69 = "llvm.and"(%54, %55) : (i64, i64) -> i64
  %70 = "llvm.xor"(%54, %8) : (i64, i64) -> i64
  %71 = "llvm.and"(%58, %70) : (i64, i64) -> i64
  %72 = "llvm.or"(%69, %71) : (i64, i64) -> i64
  %73 = "llvm.getelementptr"(%9, %56) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %74 = "llvm.load"(%73) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %75 = "llvm.add"(%72, %57) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %76 = "llvm.add"(%75, %68) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %77 = "llvm.add"(%76, %62) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %78 = "llvm.add"(%77, %74) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %79 = "llvm.intr.fshl"(%50, %50, %10) : (i64, i64, i64) -> i64
  %80 = "llvm.intr.fshl"(%50, %50, %11) : (i64, i64, i64) -> i64
  %81 = "llvm.xor"(%79, %80) : (i64, i64) -> i64
  %82 = "llvm.intr.fshl"(%50, %50, %12) : (i64, i64, i64) -> i64
  %83 = "llvm.xor"(%81, %82) : (i64, i64) -> i64
  %84 = "llvm.xor"(%51, %52) : (i64, i64) -> i64
  %85 = "llvm.and"(%50, %84) : (i64, i64) -> i64
  %86 = "llvm.and"(%51, %52) : (i64, i64) -> i64
  %87 = "llvm.xor"(%85, %86) : (i64, i64) -> i64
  %88 = "llvm.add"(%83, %87) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %89 = "llvm.add"(%78, %53) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %90 = "llvm.add"(%88, %78) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %91 = "llvm.or"(%56, %13) <{isDisjoint}> : (i64, i64) -> i64
  %92 = "llvm.shl"(%91, %4) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %93 = "llvm.getelementptr"(%48, %92) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %94 = "llvm.load"(%93) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %95 = "llvm.intr.bswap"(%94) : (i64) -> i64
  %96 = "llvm.getelementptr"(%24, %91) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%95, %96) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %97 = "llvm.intr.fshl"(%89, %89, %5) : (i64, i64, i64) -> i64
  %98 = "llvm.intr.fshl"(%89, %89, %6) : (i64, i64, i64) -> i64
  %99 = "llvm.xor"(%97, %98) : (i64, i64) -> i64
  %100 = "llvm.intr.fshl"(%89, %89, %7) : (i64, i64, i64) -> i64
  %101 = "llvm.xor"(%99, %100) : (i64, i64) -> i64
  %102 = "llvm.and"(%89, %54) : (i64, i64) -> i64
  %103 = "llvm.xor"(%89, %8) : (i64, i64) -> i64
  %104 = "llvm.and"(%55, %103) : (i64, i64) -> i64
  %105 = "llvm.or"(%102, %104) : (i64, i64) -> i64
  %106 = "llvm.getelementptr"(%9, %91) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %107 = "llvm.load"(%106) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %108 = "llvm.add"(%105, %58) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %109 = "llvm.add"(%108, %101) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %110 = "llvm.add"(%109, %95) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %111 = "llvm.add"(%110, %107) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %112 = "llvm.intr.fshl"(%90, %90, %10) : (i64, i64, i64) -> i64
  %113 = "llvm.intr.fshl"(%90, %90, %11) : (i64, i64, i64) -> i64
  %114 = "llvm.xor"(%112, %113) : (i64, i64) -> i64
  %115 = "llvm.intr.fshl"(%90, %90, %12) : (i64, i64, i64) -> i64
  %116 = "llvm.xor"(%114, %115) : (i64, i64) -> i64
  %117 = "llvm.xor"(%50, %51) : (i64, i64) -> i64
  %118 = "llvm.and"(%90, %117) : (i64, i64) -> i64
  %119 = "llvm.and"(%50, %51) : (i64, i64) -> i64
  %120 = "llvm.xor"(%118, %119) : (i64, i64) -> i64
  %121 = "llvm.add"(%116, %120) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %122 = "llvm.add"(%111, %52) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %123 = "llvm.add"(%121, %111) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %124 = "llvm.add"(%56, %14) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %125 = "llvm.icmp"(%124, %1) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%125, %123, %90, %50, %51, %122, %89, %1, %55, %54, %123, %90, %50, %51, %122, %89, %124, %55, %54)[^bb3, ^bb2] <{loop_annotation = #llvm.loop_annotation<mustProgress = true>, operandSegmentSizes = array<i32: 1, 9, 9>}> : (i1, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64) -> ()
^bb3(%126: i64, %127: i64, %128: i64, %129: i64, %130: i64, %131: i64, %132: i64, %133: i64, %134: i64):  // 2 preds: ^bb2, ^bb3
  %135 = "llvm.or"(%132, %13) <{isDisjoint}> : (i64, i64) -> i64
  %136 = "llvm.and"(%135, %15) : (i64, i64) -> i64
  %137 = "llvm.getelementptr"(%24, %136) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %138 = "llvm.load"(%137) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %139 = "llvm.add"(%132, %16) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %140 = "llvm.and"(%139, %16) : (i64, i64) -> i64
  %141 = "llvm.getelementptr"(%24, %140) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %142 = "llvm.load"(%141) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %143 = "llvm.intr.fshl"(%138, %138, %17) : (i64, i64, i64) -> i64
  %144 = "llvm.intr.fshl"(%138, %138, %2) : (i64, i64, i64) -> i64
  %145 = "llvm.xor"(%143, %144) : (i64, i64) -> i64
  %146 = "llvm.lshr"(%138, %18) : (i64, i64) -> i64
  %147 = "llvm.xor"(%145, %146) : (i64, i64) -> i64
  %148 = "llvm.intr.fshl"(%142, %142, %19) : (i64, i64, i64) -> i64
  %149 = "llvm.intr.fshl"(%142, %142, %4) : (i64, i64, i64) -> i64
  %150 = "llvm.xor"(%148, %149) : (i64, i64) -> i64
  %151 = "llvm.lshr"(%142, %20) : (i64, i64) -> i64
  %152 = "llvm.xor"(%150, %151) : (i64, i64) -> i64
  %153 = "llvm.add"(%132, %21) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %154 = "llvm.and"(%153, %15) : (i64, i64) -> i64
  %155 = "llvm.getelementptr"(%24, %154) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %156 = "llvm.load"(%155) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %157 = "llvm.and"(%132, %16) : (i64, i64) -> i64
  %158 = "llvm.getelementptr"(%24, %157) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %159 = "llvm.load"(%158) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %160 = "llvm.add"(%147, %156) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %161 = "llvm.add"(%160, %159) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %162 = "llvm.add"(%161, %152) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%162, %158) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %163 = "llvm.intr.fshl"(%130, %130, %5) : (i64, i64, i64) -> i64
  %164 = "llvm.intr.fshl"(%130, %130, %6) : (i64, i64, i64) -> i64
  %165 = "llvm.xor"(%163, %164) : (i64, i64) -> i64
  %166 = "llvm.intr.fshl"(%130, %130, %7) : (i64, i64, i64) -> i64
  %167 = "llvm.xor"(%165, %166) : (i64, i64) -> i64
  %168 = "llvm.and"(%130, %131) : (i64, i64) -> i64
  %169 = "llvm.xor"(%130, %8) : (i64, i64) -> i64
  %170 = "llvm.and"(%134, %169) : (i64, i64) -> i64
  %171 = "llvm.or"(%168, %170) : (i64, i64) -> i64
  %172 = "llvm.getelementptr"(%9, %132) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %173 = "llvm.load"(%172) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %174 = "llvm.add"(%171, %133) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %175 = "llvm.add"(%174, %167) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %176 = "llvm.add"(%175, %173) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %177 = "llvm.add"(%176, %162) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %178 = "llvm.intr.fshl"(%126, %126, %10) : (i64, i64, i64) -> i64
  %179 = "llvm.intr.fshl"(%126, %126, %11) : (i64, i64, i64) -> i64
  %180 = "llvm.xor"(%178, %179) : (i64, i64) -> i64
  %181 = "llvm.intr.fshl"(%126, %126, %12) : (i64, i64, i64) -> i64
  %182 = "llvm.xor"(%180, %181) : (i64, i64) -> i64
  %183 = "llvm.xor"(%127, %128) : (i64, i64) -> i64
  %184 = "llvm.and"(%126, %183) : (i64, i64) -> i64
  %185 = "llvm.and"(%127, %128) : (i64, i64) -> i64
  %186 = "llvm.xor"(%184, %185) : (i64, i64) -> i64
  %187 = "llvm.add"(%182, %186) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %188 = "llvm.add"(%177, %129) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %189 = "llvm.add"(%187, %177) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %190 = "llvm.add"(%132, %14) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %191 = "llvm.and"(%190, %16) : (i64, i64) -> i64
  %192 = "llvm.getelementptr"(%24, %191) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %193 = "llvm.load"(%192) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %194 = "llvm.add"(%132, %15) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %195 = "llvm.and"(%194, %15) : (i64, i64) -> i64
  %196 = "llvm.getelementptr"(%24, %195) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %197 = "llvm.load"(%196) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %198 = "llvm.intr.fshl"(%193, %193, %17) : (i64, i64, i64) -> i64
  %199 = "llvm.intr.fshl"(%193, %193, %2) : (i64, i64, i64) -> i64
  %200 = "llvm.xor"(%198, %199) : (i64, i64) -> i64
  %201 = "llvm.lshr"(%193, %18) : (i64, i64) -> i64
  %202 = "llvm.xor"(%200, %201) : (i64, i64) -> i64
  %203 = "llvm.intr.fshl"(%197, %197, %19) : (i64, i64, i64) -> i64
  %204 = "llvm.intr.fshl"(%197, %197, %4) : (i64, i64, i64) -> i64
  %205 = "llvm.xor"(%203, %204) : (i64, i64) -> i64
  %206 = "llvm.lshr"(%197, %20) : (i64, i64) -> i64
  %207 = "llvm.xor"(%205, %206) : (i64, i64) -> i64
  %208 = "llvm.add"(%132, %22) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %209 = "llvm.and"(%208, %16) : (i64, i64) -> i64
  %210 = "llvm.getelementptr"(%24, %209) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %211 = "llvm.load"(%210) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %212 = "llvm.and"(%135, %15) : (i64, i64) -> i64
  %213 = "llvm.getelementptr"(%24, %212) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %214 = "llvm.load"(%213) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %215 = "llvm.add"(%202, %211) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %216 = "llvm.add"(%215, %214) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %217 = "llvm.add"(%216, %207) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%217, %213) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %218 = "llvm.intr.fshl"(%188, %188, %5) : (i64, i64, i64) -> i64
  %219 = "llvm.intr.fshl"(%188, %188, %6) : (i64, i64, i64) -> i64
  %220 = "llvm.xor"(%218, %219) : (i64, i64) -> i64
  %221 = "llvm.intr.fshl"(%188, %188, %7) : (i64, i64, i64) -> i64
  %222 = "llvm.xor"(%220, %221) : (i64, i64) -> i64
  %223 = "llvm.and"(%188, %130) : (i64, i64) -> i64
  %224 = "llvm.xor"(%188, %8) : (i64, i64) -> i64
  %225 = "llvm.and"(%131, %224) : (i64, i64) -> i64
  %226 = "llvm.or"(%223, %225) : (i64, i64) -> i64
  %227 = "llvm.getelementptr"(%9, %135) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %228 = "llvm.load"(%227) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %229 = "llvm.add"(%226, %134) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %230 = "llvm.add"(%229, %222) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %231 = "llvm.add"(%230, %228) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %232 = "llvm.add"(%231, %217) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %233 = "llvm.intr.fshl"(%189, %189, %10) : (i64, i64, i64) -> i64
  %234 = "llvm.intr.fshl"(%189, %189, %11) : (i64, i64, i64) -> i64
  %235 = "llvm.xor"(%233, %234) : (i64, i64) -> i64
  %236 = "llvm.intr.fshl"(%189, %189, %12) : (i64, i64, i64) -> i64
  %237 = "llvm.xor"(%235, %236) : (i64, i64) -> i64
  %238 = "llvm.xor"(%126, %127) : (i64, i64) -> i64
  %239 = "llvm.and"(%189, %238) : (i64, i64) -> i64
  %240 = "llvm.and"(%126, %127) : (i64, i64) -> i64
  %241 = "llvm.xor"(%239, %240) : (i64, i64) -> i64
  %242 = "llvm.add"(%237, %241) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %243 = "llvm.add"(%232, %128) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %244 = "llvm.add"(%242, %232) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %245 = "llvm.icmp"(%190, %23) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%245, %244, %189, %126, %127, %243, %188, %190, %131, %130)[^bb4, ^bb3] <{loop_annotation = #llvm.loop_annotation<mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 9>}> : (i1, i64, i64, i64, i64, i64, i64, i64, i64, i64) -> ()
^bb4:  // pred: ^bb3
  %246 = "llvm.add"(%244, %47) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%246, %arg0) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %247 = "llvm.add"(%189, %46) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%247, %25) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %248 = "llvm.add"(%126, %45) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%248, %26) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %249 = "llvm.add"(%127, %44) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%249, %27) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %250 = "llvm.add"(%243, %43) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%250, %28) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %251 = "llvm.add"(%188, %42) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%251, %29) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %252 = "llvm.add"(%130, %41) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%252, %30) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %253 = "llvm.add"(%131, %40) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%253, %31) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %254 = "llvm.getelementptr"(%48) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.lifetime.end"(%24) : (!llvm.ptr) -> ()
  %255 = "llvm.add"(%49, %8) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %256 = "llvm.icmp"(%255, %3) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%256, %253, %252, %251, %250, %249, %248, %247, %246, %254, %255)[^bb5, ^bb1] <{loop_annotation = #llvm.loop_annotation<mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 10>}> : (i1, i64, i64, i64, i64, i64, i64, i64, i64, !llvm.ptr, i64) -> ()
^bb5:  // pred: ^bb4
  "llvm.return"() : () -> ()
}) : () -> ()

    with
      @fd_sha512_core_ref.K := Firedancer.Lane.Mlir.fd_sha512_core_ref_K

end

end Firedancer.Lane.Mlir
