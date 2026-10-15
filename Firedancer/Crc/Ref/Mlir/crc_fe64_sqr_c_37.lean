
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.Crc.Ref.Mlir.crc_fe64_addc_34
public import Firedancer.Crc.Ref.Mlir.crc_fe64_addc_34
public import Firedancer.Crc.Ref.Mlir.crc_fe64_addc_34
public import Firedancer.Crc.Ref.Mlir.crc_fe64_addc_34
public import Firedancer.Crc.Ref.Mlir.crc_fe64_addc_34
public import Firedancer.Crc.Ref.Mlir.crc_fe64_addc_34
public import Firedancer.Crc.Ref.Mlir.crc_fe64_addc_34
public import Firedancer.Crc.Ref.Mlir.crc_fe64_addc_34
public import Firedancer.Crc.Ref.Mlir.crc_fe64_addc_34
public import Firedancer.Crc.Ref.Mlir.crc_fe64_addc_34
public import Firedancer.Crc.Ref.Mlir.crc_fe64_addc_34
public import Firedancer.Crc.Ref.Mlir.crc_fe64_addc_34
public import Firedancer.Crc.Ref.Mlir.crc_fe64_addc_34
public import Firedancer.Crc.Ref.Mlir.crc_fe64_addc_34
public import Firedancer.Crc.Ref.Mlir.crc_fe64_addc_34
public import Firedancer.Crc.Ref.Mlir.crc_fe64_addc_34
public import Firedancer.Crc.Ref.Mlir.crc_fe64_addc_34
public import Firedancer.Crc.Ref.Mlir.crc_fe64_addc_34
public import Firedancer.Crc.Ref.Mlir.crc_fe64_addc_34
public import Firedancer.Crc.Ref.Mlir.crc_fe64_addc_34
public import Firedancer.Crc.Ref.Mlir.crc_fe64_addc_34
public import Firedancer.Crc.Ref.Mlir.crc_fe64_addc_34
public import Firedancer.Crc.Ref.Mlir.crc_fe64_addc_34
public import Firedancer.Crc.Ref.Mlir.crc_fe64_addc_34
public import Firedancer.Crc.Ref.Mlir.crc_fe64_addc_34
public import Firedancer.Crc.Ref.Mlir.crc_fe64_addc_34
public import Firedancer.Crc.Ref.Mlir.crc_fe64_addc_34
public import Firedancer.Crc.Ref.Mlir.crc_fe64_addc_34
public import Firedancer.Crc.Ref.Mlir.crc_fe64_addc_34
public import Firedancer.Crc.Ref.Mlir.crc_fe64_addc_34
public import Firedancer.Crc.Ref.Mlir.crc_fe64_addc_34
public import Firedancer.Crc.Ref.Mlir.crc_fe64_addc_34
public import Firedancer.Crc.Ref.Mlir.crc_fe64_addc_34
public import Firedancer.Crc.Ref.Mlir.crc_fe64_addc_34
public import Firedancer.Crc.Ref.Mlir.crc_fe64_addc_34
public import Firedancer.Crc.Ref.Mlir.crc_fe64_addc_34
public import Firedancer.Crc.Ref.Mlir.crc_fe64_addc_34
public import Firedancer.Crc.Ref.Mlir.crc_fe64_addc_34
public import Firedancer.Crc.Ref.Mlir.crc_fe64_addc_34
public import Firedancer.Crc.Ref.Mlir.crc_fe64_addc_34
public import Firedancer.Crc.Ref.Mlir.crc_fe64_addc_34
public import Firedancer.Crc.Ref.Mlir.crc_fe64_addc_34
public import Firedancer.Crc.Ref.Mlir.crc_fe64_addc_34
public import Firedancer.Crc.Ref.Mlir.crc_fe64_addc_34
public import Firedancer.Crc.Ref.Mlir.crc_fe64_addc_34
public import Firedancer.Crc.Ref.Mlir.crc_fe64_addc_34
public import Firedancer.Crc.Ref.Mlir.crc_fe64_addc_34
public import Firedancer.Crc.Ref.Mlir.crc_fe64_addc_34

namespace MLIR.Firedancer.Crc.Ref

@[expose] public section

mlir_def crc_fe64_sqr_c_37 := "llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], sym_name = "crc_fe64_sqr_c.37", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr):
  %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1 = "llvm.mlir.constant"() <{value = 64 : i128}> : () -> i128
  %2 = "llvm.mlir.constant"() <{value = 38 : i128}> : () -> i128
  %3 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %4 = "llvm.mlir.constant"() <{value = 9223372036854775807 : i64}> : () -> i64
  %5 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %6 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %7 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %8 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %9 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %10 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %11 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %12 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %13 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %14 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %15 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %16 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %17 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %18 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %19 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %20 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %21 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %22 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %23 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %24 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %25 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %26 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %27 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %28 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %29 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %30 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %31 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %32 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %33 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %34 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %35 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %36 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %37 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %38 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %39 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %40 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %41 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %42 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %43 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %44 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %45 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %46 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %47 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %48 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %49 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %50 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %51 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %52 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %53 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %54 = "llvm.load"(%arg1) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %55 = "llvm.zext"(%54) : (i64) -> i128
  %56 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %57 = "llvm.load"(%56) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %58 = "llvm.zext"(%57) : (i64) -> i128
  %59 = "llvm.mul"(%58, %55) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %60 = "llvm.trunc"(%59) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %61 = "llvm.lshr"(%59, %1) : (i128, i128) -> i128
  %62 = "llvm.trunc"(%61) <{overflowFlags = 2 : i32}> : (i128) -> i64
  %63 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %64 = "llvm.load"(%63) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %65 = "llvm.zext"(%64) : (i64) -> i128
  %66 = "llvm.mul"(%65, %55) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %67 = "llvm.trunc"(%66) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %68 = "llvm.lshr"(%66, %1) : (i128, i128) -> i128
  %69 = "llvm.trunc"(%68) <{overflowFlags = 2 : i32}> : (i128) -> i64
  %70 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %71 = "llvm.load"(%70) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %72 = "llvm.zext"(%71) : (i64) -> i128
  %73 = "llvm.mul"(%72, %65) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %74 = "llvm.trunc"(%73) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %75 = "llvm.lshr"(%73, %1) : (i128, i128) -> i128
  %76 = "llvm.trunc"(%75) <{overflowFlags = 2 : i32}> : (i128) -> i64
  %77 = "llvm.mul"(%72, %55) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %78 = "llvm.trunc"(%77) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %79 = "llvm.lshr"(%77, %1) : (i128, i128) -> i128
  %80 = "llvm.trunc"(%79) <{overflowFlags = 2 : i32}> : (i128) -> i64
  %81 = "llvm.mul"(%72, %58) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %82 = "llvm.trunc"(%81) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %83 = "llvm.lshr"(%81, %1) : (i128, i128) -> i128
  %84 = "llvm.trunc"(%83) <{overflowFlags = 2 : i32}> : (i128) -> i64
  "llvm.intr.lifetime.start"(%6) : (!llvm.ptr) -> ()
  %85 = "llvm.call"(%69, %84, %6) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crc_fe64_addc.34, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i64, i64, !llvm.ptr) -> i64
  %86 = "llvm.mul"(%65, %58) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %87 = "llvm.trunc"(%86) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %88 = "llvm.lshr"(%86, %1) : (i128, i128) -> i128
  %89 = "llvm.trunc"(%88) <{overflowFlags = 2 : i32}> : (i128) -> i64
  "llvm.intr.lifetime.start"(%7) : (!llvm.ptr) -> ()
  %90 = "llvm.call"(%74, %89, %7) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crc_fe64_addc.34, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i64, i64, !llvm.ptr) -> i64
  "llvm.intr.lifetime.start"(%8) : (!llvm.ptr) -> ()
  %91 = "llvm.call"(%67, %80, %8) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crc_fe64_addc.34, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i64, i64, !llvm.ptr) -> i64
  "llvm.intr.lifetime.start"(%9) : (!llvm.ptr) -> ()
  %92 = "llvm.load"(%6) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %93 = "llvm.call"(%91, %92, %9) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crc_fe64_addc.34, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i64, i64, !llvm.ptr) -> i64
  %94 = "llvm.or"(%93, %85) : (i64, i64) -> i64
  "llvm.intr.lifetime.start"(%10) : (!llvm.ptr) -> ()
  %95 = "llvm.load"(%7) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %96 = "llvm.call"(%94, %95, %10) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crc_fe64_addc.34, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i64, i64, !llvm.ptr) -> i64
  %97 = "llvm.or"(%96, %90) : (i64, i64) -> i64
  %98 = "llvm.add"(%97, %76) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  "llvm.intr.lifetime.start"(%11) : (!llvm.ptr) -> ()
  %99 = "llvm.load"(%8) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %100 = "llvm.call"(%99, %82, %11) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crc_fe64_addc.34, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i64, i64, !llvm.ptr) -> i64
  "llvm.intr.lifetime.start"(%12) : (!llvm.ptr) -> ()
  %101 = "llvm.load"(%9) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %102 = "llvm.call"(%101, %87, %12) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crc_fe64_addc.34, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i64, i64, !llvm.ptr) -> i64
  "llvm.intr.lifetime.start"(%13) : (!llvm.ptr) -> ()
  %103 = "llvm.call"(%62, %78, %13) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crc_fe64_addc.34, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i64, i64, !llvm.ptr) -> i64
  "llvm.intr.lifetime.start"(%14) : (!llvm.ptr) -> ()
  %104 = "llvm.load"(%11) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %105 = "llvm.call"(%103, %104, %14) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crc_fe64_addc.34, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i64, i64, !llvm.ptr) -> i64
  %106 = "llvm.or"(%105, %100) : (i64, i64) -> i64
  "llvm.intr.lifetime.start"(%15) : (!llvm.ptr) -> ()
  %107 = "llvm.load"(%12) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %108 = "llvm.call"(%106, %107, %15) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crc_fe64_addc.34, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i64, i64, !llvm.ptr) -> i64
  %109 = "llvm.or"(%108, %102) : (i64, i64) -> i64
  "llvm.intr.lifetime.start"(%16) : (!llvm.ptr) -> ()
  %110 = "llvm.load"(%10) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %111 = "llvm.call"(%109, %110, %16) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crc_fe64_addc.34, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i64, i64, !llvm.ptr) -> i64
  %112 = "llvm.add"(%98, %111) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %113 = "llvm.mul"(%55, %55) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %114 = "llvm.trunc"(%113) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %115 = "llvm.lshr"(%113, %1) : (i128, i128) -> i128
  %116 = "llvm.trunc"(%115) <{overflowFlags = 2 : i32}> : (i128) -> i64
  %117 = "llvm.mul"(%58, %58) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %118 = "llvm.trunc"(%117) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %119 = "llvm.lshr"(%117, %1) : (i128, i128) -> i128
  %120 = "llvm.trunc"(%119) <{overflowFlags = 2 : i32}> : (i128) -> i64
  "llvm.intr.lifetime.start"(%17) : (!llvm.ptr) -> ()
  %121 = "llvm.load"(%13) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %122 = "llvm.call"(%121, %121, %17) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crc_fe64_addc.34, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i64, i64, !llvm.ptr) -> i64
  "llvm.intr.lifetime.start"(%18) : (!llvm.ptr) -> ()
  %123 = "llvm.load"(%14) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %124 = "llvm.call"(%123, %123, %18) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crc_fe64_addc.34, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i64, i64, !llvm.ptr) -> i64
  %125 = "llvm.mul"(%72, %72) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %126 = "llvm.trunc"(%125) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %127 = "llvm.lshr"(%125, %1) : (i128, i128) -> i128
  %128 = "llvm.trunc"(%127) <{overflowFlags = 2 : i32}> : (i128) -> i64
  "llvm.intr.lifetime.start"(%19) : (!llvm.ptr) -> ()
  %129 = "llvm.load"(%15) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %130 = "llvm.call"(%129, %129, %19) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crc_fe64_addc.34, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i64, i64, !llvm.ptr) -> i64
  "llvm.intr.lifetime.start"(%20) : (!llvm.ptr) -> ()
  %131 = "llvm.load"(%16) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %132 = "llvm.call"(%131, %131, %20) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crc_fe64_addc.34, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i64, i64, !llvm.ptr) -> i64
  %133 = "llvm.mul"(%65, %65) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %134 = "llvm.trunc"(%133) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %135 = "llvm.lshr"(%133, %1) : (i128, i128) -> i128
  %136 = "llvm.trunc"(%135) <{overflowFlags = 2 : i32}> : (i128) -> i64
  "llvm.intr.lifetime.start"(%21) : (!llvm.ptr) -> ()
  %137 = "llvm.call"(%112, %112, %21) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crc_fe64_addc.34, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i64, i64, !llvm.ptr) -> i64
  "llvm.intr.lifetime.start"(%22) : (!llvm.ptr) -> ()
  %138 = "llvm.call"(%60, %60, %22) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crc_fe64_addc.34, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i64, i64, !llvm.ptr) -> i64
  "llvm.intr.lifetime.start"(%23) : (!llvm.ptr) -> ()
  %139 = "llvm.load"(%17) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %140 = "llvm.call"(%138, %139, %23) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crc_fe64_addc.34, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i64, i64, !llvm.ptr) -> i64
  %141 = "llvm.or"(%140, %122) : (i64, i64) -> i64
  "llvm.intr.lifetime.start"(%24) : (!llvm.ptr) -> ()
  %142 = "llvm.load"(%18) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %143 = "llvm.call"(%141, %142, %24) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crc_fe64_addc.34, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i64, i64, !llvm.ptr) -> i64
  %144 = "llvm.or"(%143, %124) : (i64, i64) -> i64
  "llvm.intr.lifetime.start"(%25) : (!llvm.ptr) -> ()
  %145 = "llvm.load"(%19) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %146 = "llvm.call"(%144, %145, %25) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crc_fe64_addc.34, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i64, i64, !llvm.ptr) -> i64
  %147 = "llvm.or"(%146, %130) : (i64, i64) -> i64
  "llvm.intr.lifetime.start"(%26) : (!llvm.ptr) -> ()
  %148 = "llvm.load"(%20) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %149 = "llvm.call"(%147, %148, %26) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crc_fe64_addc.34, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i64, i64, !llvm.ptr) -> i64
  %150 = "llvm.or"(%149, %132) : (i64, i64) -> i64
  "llvm.intr.lifetime.start"(%27) : (!llvm.ptr) -> ()
  %151 = "llvm.load"(%21) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %152 = "llvm.call"(%150, %151, %27) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crc_fe64_addc.34, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i64, i64, !llvm.ptr) -> i64
  %153 = "llvm.or"(%152, %137) : (i64, i64) -> i64
  %154 = "llvm.add"(%153, %136) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  "llvm.intr.lifetime.start"(%28) : (!llvm.ptr) -> ()
  %155 = "llvm.load"(%23) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %156 = "llvm.call"(%118, %155, %28) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crc_fe64_addc.34, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i64, i64, !llvm.ptr) -> i64
  "llvm.intr.lifetime.start"(%29) : (!llvm.ptr) -> ()
  %157 = "llvm.load"(%24) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %158 = "llvm.call"(%120, %157, %29) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crc_fe64_addc.34, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i64, i64, !llvm.ptr) -> i64
  "llvm.intr.lifetime.start"(%30) : (!llvm.ptr) -> ()
  %159 = "llvm.load"(%25) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %160 = "llvm.call"(%126, %159, %30) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crc_fe64_addc.34, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i64, i64, !llvm.ptr) -> i64
  "llvm.intr.lifetime.start"(%31) : (!llvm.ptr) -> ()
  %161 = "llvm.load"(%26) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %162 = "llvm.call"(%128, %161, %31) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crc_fe64_addc.34, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i64, i64, !llvm.ptr) -> i64
  "llvm.intr.lifetime.start"(%32) : (!llvm.ptr) -> ()
  %163 = "llvm.load"(%27) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %164 = "llvm.call"(%134, %163, %32) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crc_fe64_addc.34, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i64, i64, !llvm.ptr) -> i64
  "llvm.intr.lifetime.start"(%33) : (!llvm.ptr) -> ()
  %165 = "llvm.load"(%22) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %166 = "llvm.call"(%116, %165, %33) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crc_fe64_addc.34, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i64, i64, !llvm.ptr) -> i64
  "llvm.intr.lifetime.start"(%34) : (!llvm.ptr) -> ()
  %167 = "llvm.load"(%28) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %168 = "llvm.call"(%166, %167, %34) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crc_fe64_addc.34, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i64, i64, !llvm.ptr) -> i64
  %169 = "llvm.or"(%168, %156) : (i64, i64) -> i64
  "llvm.intr.lifetime.start"(%35) : (!llvm.ptr) -> ()
  %170 = "llvm.load"(%29) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %171 = "llvm.call"(%169, %170, %35) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crc_fe64_addc.34, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i64, i64, !llvm.ptr) -> i64
  %172 = "llvm.or"(%171, %158) : (i64, i64) -> i64
  "llvm.intr.lifetime.start"(%36) : (!llvm.ptr) -> ()
  %173 = "llvm.load"(%30) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %174 = "llvm.call"(%172, %173, %36) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crc_fe64_addc.34, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i64, i64, !llvm.ptr) -> i64
  %175 = "llvm.or"(%174, %160) : (i64, i64) -> i64
  "llvm.intr.lifetime.start"(%37) : (!llvm.ptr) -> ()
  %176 = "llvm.load"(%31) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %177 = "llvm.call"(%175, %176, %37) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crc_fe64_addc.34, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i64, i64, !llvm.ptr) -> i64
  %178 = "llvm.or"(%177, %162) : (i64, i64) -> i64
  "llvm.intr.lifetime.start"(%38) : (!llvm.ptr) -> ()
  %179 = "llvm.load"(%32) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %180 = "llvm.call"(%178, %179, %38) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crc_fe64_addc.34, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i64, i64, !llvm.ptr) -> i64
  %181 = "llvm.or"(%180, %164) : (i64, i64) -> i64
  %182 = "llvm.add"(%154, %181) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %183 = "llvm.load"(%36) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %184 = "llvm.zext"(%183) : (i64) -> i128
  %185 = "llvm.mul"(%184, %2) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %186 = "llvm.trunc"(%185) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %187 = "llvm.lshr"(%185, %1) : (i128, i128) -> i128
  %188 = "llvm.trunc"(%187) <{overflowFlags = 3 : i32}> : (i128) -> i64
  %189 = "llvm.load"(%37) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %190 = "llvm.zext"(%189) : (i64) -> i128
  %191 = "llvm.mul"(%190, %2) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %192 = "llvm.trunc"(%191) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %193 = "llvm.lshr"(%191, %1) : (i128, i128) -> i128
  %194 = "llvm.trunc"(%193) <{overflowFlags = 3 : i32}> : (i128) -> i64
  "llvm.intr.lifetime.start"(%39) : (!llvm.ptr) -> ()
  %195 = "llvm.load"(%34) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %196 = "llvm.call"(%195, %194, %39) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crc_fe64_addc.34, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i64, i64, !llvm.ptr) -> i64
  %197 = "llvm.load"(%38) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %198 = "llvm.zext"(%197) : (i64) -> i128
  %199 = "llvm.mul"(%198, %2) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %200 = "llvm.trunc"(%199) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %201 = "llvm.lshr"(%199, %1) : (i128, i128) -> i128
  %202 = "llvm.trunc"(%201) <{overflowFlags = 3 : i32}> : (i128) -> i64
  "llvm.intr.lifetime.start"(%40) : (!llvm.ptr) -> ()
  %203 = "llvm.load"(%35) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %204 = "llvm.call"(%203, %202, %40) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crc_fe64_addc.34, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i64, i64, !llvm.ptr) -> i64
  %205 = "llvm.zext"(%182) : (i64) -> i128
  %206 = "llvm.mul"(%205, %2) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %207 = "llvm.trunc"(%206) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %208 = "llvm.lshr"(%206, %1) : (i128, i128) -> i128
  %209 = "llvm.trunc"(%208) <{overflowFlags = 3 : i32}> : (i128) -> i64
  "llvm.intr.lifetime.start"(%41) : (!llvm.ptr) -> ()
  %210 = "llvm.load"(%33) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %211 = "llvm.call"(%210, %188, %41) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crc_fe64_addc.34, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i64, i64, !llvm.ptr) -> i64
  "llvm.intr.lifetime.start"(%42) : (!llvm.ptr) -> ()
  %212 = "llvm.load"(%39) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %213 = "llvm.call"(%211, %212, %42) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crc_fe64_addc.34, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i64, i64, !llvm.ptr) -> i64
  %214 = "llvm.or"(%213, %196) : (i64, i64) -> i64
  "llvm.intr.lifetime.start"(%43) : (!llvm.ptr) -> ()
  %215 = "llvm.load"(%40) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %216 = "llvm.call"(%214, %215, %43) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crc_fe64_addc.34, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i64, i64, !llvm.ptr) -> i64
  %217 = "llvm.or"(%216, %204) : (i64, i64) -> i64
  %218 = "llvm.add"(%217, %209) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  "llvm.intr.lifetime.start"(%44) : (!llvm.ptr) -> ()
  %219 = "llvm.load"(%41) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %220 = "llvm.call"(%219, %192, %44) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crc_fe64_addc.34, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i64, i64, !llvm.ptr) -> i64
  "llvm.intr.lifetime.start"(%45) : (!llvm.ptr) -> ()
  %221 = "llvm.load"(%42) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %222 = "llvm.call"(%221, %200, %45) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crc_fe64_addc.34, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i64, i64, !llvm.ptr) -> i64
  "llvm.intr.lifetime.start"(%46) : (!llvm.ptr) -> ()
  %223 = "llvm.load"(%43) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %224 = "llvm.call"(%223, %207, %46) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crc_fe64_addc.34, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i64, i64, !llvm.ptr) -> i64
  "llvm.intr.lifetime.start"(%47) : (!llvm.ptr) -> ()
  %225 = "llvm.call"(%114, %186, %47) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crc_fe64_addc.34, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i64, i64, !llvm.ptr) -> i64
  "llvm.intr.lifetime.start"(%48) : (!llvm.ptr) -> ()
  %226 = "llvm.load"(%44) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %227 = "llvm.call"(%225, %226, %48) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crc_fe64_addc.34, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i64, i64, !llvm.ptr) -> i64
  %228 = "llvm.or"(%227, %220) : (i64, i64) -> i64
  "llvm.intr.lifetime.start"(%49) : (!llvm.ptr) -> ()
  %229 = "llvm.load"(%45) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %230 = "llvm.call"(%228, %229, %49) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crc_fe64_addc.34, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i64, i64, !llvm.ptr) -> i64
  %231 = "llvm.or"(%230, %222) : (i64, i64) -> i64
  "llvm.intr.lifetime.start"(%50) : (!llvm.ptr) -> ()
  %232 = "llvm.load"(%46) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %233 = "llvm.call"(%231, %232, %50) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crc_fe64_addc.34, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i64, i64, !llvm.ptr) -> i64
  %234 = "llvm.or"(%233, %224) : (i64, i64) -> i64
  %235 = "llvm.add"(%218, %234) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %236 = "llvm.load"(%50) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %237 = "llvm.intr.fshl"(%235, %236, %3) : (i64, i64, i64) -> i64
  %238 = "llvm.and"(%236, %4) : (i64, i64) -> i64
  %239 = "llvm.mul"(%237, %5) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  "llvm.intr.lifetime.start"(%51) : (!llvm.ptr) -> ()
  %240 = "llvm.load"(%47) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %241 = "llvm.call"(%240, %239, %51) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crc_fe64_addc.34, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i64, i64, !llvm.ptr) -> i64
  "llvm.intr.lifetime.start"(%52) : (!llvm.ptr) -> ()
  %242 = "llvm.load"(%48) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %243 = "llvm.call"(%242, %241, %52) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crc_fe64_addc.34, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i64, i64, !llvm.ptr) -> i64
  "llvm.intr.lifetime.start"(%53) : (!llvm.ptr) -> ()
  %244 = "llvm.load"(%49) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %245 = "llvm.call"(%244, %243, %53) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crc_fe64_addc.34, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i64, i64, !llvm.ptr) -> i64
  %246 = "llvm.add"(%245, %238) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %247 = "llvm.load"(%51) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  "llvm.store"(%247, %arg0) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %248 = "llvm.load"(%52) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %249 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%248, %249) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %250 = "llvm.load"(%53) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %251 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%250, %251) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %252 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%246, %252) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%53) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%52) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%51) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%50) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%49) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%48) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%47) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%46) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%45) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%44) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%43) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%42) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%41) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%40) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%39) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%38) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%37) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%36) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%35) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%34) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%33) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%32) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%31) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%30) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%29) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%28) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%27) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%26) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%25) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%24) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%23) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%22) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%21) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%20) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%19) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%18) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%17) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%16) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%15) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%14) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%13) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%12) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%11) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%10) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%9) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%8) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%7) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%6) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

    with
      @crc_fe64_addc.34 := MLIR.Firedancer.Crc.Ref.crc_fe64_addc_34,
      @crc_fe64_addc.34 := MLIR.Firedancer.Crc.Ref.crc_fe64_addc_34,
      @crc_fe64_addc.34 := MLIR.Firedancer.Crc.Ref.crc_fe64_addc_34,
      @crc_fe64_addc.34 := MLIR.Firedancer.Crc.Ref.crc_fe64_addc_34,
      @crc_fe64_addc.34 := MLIR.Firedancer.Crc.Ref.crc_fe64_addc_34,
      @crc_fe64_addc.34 := MLIR.Firedancer.Crc.Ref.crc_fe64_addc_34,
      @crc_fe64_addc.34 := MLIR.Firedancer.Crc.Ref.crc_fe64_addc_34,
      @crc_fe64_addc.34 := MLIR.Firedancer.Crc.Ref.crc_fe64_addc_34,
      @crc_fe64_addc.34 := MLIR.Firedancer.Crc.Ref.crc_fe64_addc_34,
      @crc_fe64_addc.34 := MLIR.Firedancer.Crc.Ref.crc_fe64_addc_34,
      @crc_fe64_addc.34 := MLIR.Firedancer.Crc.Ref.crc_fe64_addc_34,
      @crc_fe64_addc.34 := MLIR.Firedancer.Crc.Ref.crc_fe64_addc_34,
      @crc_fe64_addc.34 := MLIR.Firedancer.Crc.Ref.crc_fe64_addc_34,
      @crc_fe64_addc.34 := MLIR.Firedancer.Crc.Ref.crc_fe64_addc_34,
      @crc_fe64_addc.34 := MLIR.Firedancer.Crc.Ref.crc_fe64_addc_34,
      @crc_fe64_addc.34 := MLIR.Firedancer.Crc.Ref.crc_fe64_addc_34,
      @crc_fe64_addc.34 := MLIR.Firedancer.Crc.Ref.crc_fe64_addc_34,
      @crc_fe64_addc.34 := MLIR.Firedancer.Crc.Ref.crc_fe64_addc_34,
      @crc_fe64_addc.34 := MLIR.Firedancer.Crc.Ref.crc_fe64_addc_34,
      @crc_fe64_addc.34 := MLIR.Firedancer.Crc.Ref.crc_fe64_addc_34,
      @crc_fe64_addc.34 := MLIR.Firedancer.Crc.Ref.crc_fe64_addc_34,
      @crc_fe64_addc.34 := MLIR.Firedancer.Crc.Ref.crc_fe64_addc_34,
      @crc_fe64_addc.34 := MLIR.Firedancer.Crc.Ref.crc_fe64_addc_34,
      @crc_fe64_addc.34 := MLIR.Firedancer.Crc.Ref.crc_fe64_addc_34,
      @crc_fe64_addc.34 := MLIR.Firedancer.Crc.Ref.crc_fe64_addc_34,
      @crc_fe64_addc.34 := MLIR.Firedancer.Crc.Ref.crc_fe64_addc_34,
      @crc_fe64_addc.34 := MLIR.Firedancer.Crc.Ref.crc_fe64_addc_34,
      @crc_fe64_addc.34 := MLIR.Firedancer.Crc.Ref.crc_fe64_addc_34,
      @crc_fe64_addc.34 := MLIR.Firedancer.Crc.Ref.crc_fe64_addc_34,
      @crc_fe64_addc.34 := MLIR.Firedancer.Crc.Ref.crc_fe64_addc_34,
      @crc_fe64_addc.34 := MLIR.Firedancer.Crc.Ref.crc_fe64_addc_34,
      @crc_fe64_addc.34 := MLIR.Firedancer.Crc.Ref.crc_fe64_addc_34,
      @crc_fe64_addc.34 := MLIR.Firedancer.Crc.Ref.crc_fe64_addc_34,
      @crc_fe64_addc.34 := MLIR.Firedancer.Crc.Ref.crc_fe64_addc_34,
      @crc_fe64_addc.34 := MLIR.Firedancer.Crc.Ref.crc_fe64_addc_34,
      @crc_fe64_addc.34 := MLIR.Firedancer.Crc.Ref.crc_fe64_addc_34,
      @crc_fe64_addc.34 := MLIR.Firedancer.Crc.Ref.crc_fe64_addc_34,
      @crc_fe64_addc.34 := MLIR.Firedancer.Crc.Ref.crc_fe64_addc_34,
      @crc_fe64_addc.34 := MLIR.Firedancer.Crc.Ref.crc_fe64_addc_34,
      @crc_fe64_addc.34 := MLIR.Firedancer.Crc.Ref.crc_fe64_addc_34,
      @crc_fe64_addc.34 := MLIR.Firedancer.Crc.Ref.crc_fe64_addc_34,
      @crc_fe64_addc.34 := MLIR.Firedancer.Crc.Ref.crc_fe64_addc_34,
      @crc_fe64_addc.34 := MLIR.Firedancer.Crc.Ref.crc_fe64_addc_34,
      @crc_fe64_addc.34 := MLIR.Firedancer.Crc.Ref.crc_fe64_addc_34,
      @crc_fe64_addc.34 := MLIR.Firedancer.Crc.Ref.crc_fe64_addc_34,
      @crc_fe64_addc.34 := MLIR.Firedancer.Crc.Ref.crc_fe64_addc_34,
      @crc_fe64_addc.34 := MLIR.Firedancer.Crc.Ref.crc_fe64_addc_34,
      @crc_fe64_addc.34 := MLIR.Firedancer.Crc.Ref.crc_fe64_addc_34

end

end MLIR.Firedancer.Crc.Ref
