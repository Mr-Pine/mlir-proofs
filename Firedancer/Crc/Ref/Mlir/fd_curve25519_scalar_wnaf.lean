
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.Crc.Ref.Mlir.fd_ulong_find_lsb

namespace MLIR.Firedancer.Crc.Ref

@[expose] public section

mlir_def fd_curve25519_scalar_wnaf := "llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.noundef}], function_type = !llvm.func<void (ptr, ptr, i32)>, linkage = #llvm.linkage<external>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], sym_name = "fd_curve25519_scalar_wnaf", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: i32):
  %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1 = "llvm.mlir.constant"() <{value = 9223372036854775807 : i64}> : () -> i64
  %2 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %3 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %4 = "llvm.mlir.constant"() <{value = 512 : i64}> : () -> i64
  %5 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %6 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %7 = "llvm.mlir.constant"() <{value = 63 : i64}> : () -> i64
  %8 = "llvm.mlir.constant"() <{value = 6 : i64}> : () -> i64
  %9 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %10 = "llvm.mlir.constant"() <{value = 64 : i64}> : () -> i64
  %11 = "llvm.mlir.constant"() <{value = 320 : i64}> : () -> i64
  %12 = "llvm.mlir.constant"() <{value = 4 : i64}> : () -> i64
  %13 = "llvm.mlir.constant"() <{value = false}> : () -> i1
  %14 = "llvm.mlir.constant"() <{value = 256 : i64}> : () -> i64
  %15 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.array<5 x i64>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%15) : (!llvm.ptr) -> ()
  %16 = "llvm.load"(%arg1) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  "llvm.store"(%16, %15) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %17 = "llvm.getelementptr"(%15) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %18 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %19 = "llvm.load"(%18) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  "llvm.store"(%19, %17) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %20 = "llvm.getelementptr"(%15) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %21 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %22 = "llvm.load"(%21) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  "llvm.store"(%22, %20) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %23 = "llvm.getelementptr"(%15) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %24 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %25 = "llvm.load"(%24) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %26 = "llvm.and"(%25, %1) : (i64, i64) -> i64
  "llvm.store"(%26, %23) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %27 = "llvm.getelementptr"(%15) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2, %27) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  "llvm.intr.memset"(%arg0, %3, %4) <{arg_attrs = [{llvm.align = 2 : i64, llvm.dereferenceable = 512 : i64, llvm.nonnull, llvm.noundef}, {}, {}], isVolatile = false}> : (!llvm.ptr, i8, i64) -> ()
  %28 = "llvm.sext"(%arg2) : (i32) -> i64
  %29 = "llvm.add"(%28, %5) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %30 = "llvm.shl"(%5, %29) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %31 = "llvm.add"(%30, %6) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %32 = "llvm.sub"(%7, %28) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  "llvm.br"(%2)[^bb1] : (i64) -> ()
^bb1(%33: i64):  // 2 preds: ^bb0, ^bb15
  %34 = "llvm.lshr"(%33, %8) : (i64, i64) -> i64
  %35 = "llvm.getelementptr"(%15, %34) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %36 = "llvm.load"(%35) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %37 = "llvm.and"(%33, %7) : (i64, i64) -> i64
  %38 = "llvm.lshr"(%36, %37) : (i64, i64) -> i64
  %39 = "llvm.icmp"(%38, %2) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%39, %36, %38, %34, %33)[^bb2, ^bb6] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 4>}> : (i1, i64, i64, i64, i64) -> ()
^bb2:  // pred: ^bb1
  %40 = "llvm.icmp"(%34, %9) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%40, %34)[^bb16, ^bb4] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb3:  // pred: ^bb4
  %41 = "llvm.icmp"(%43, %9) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%41, %43)[^bb16, ^bb4] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb4(%42: i64):  // 2 preds: ^bb2, ^bb3
  %43 = "llvm.add"(%42, %5) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %44 = "llvm.getelementptr"(%15, %43) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %45 = "llvm.load"(%44) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %46 = "llvm.icmp"(%45, %2) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%46)[^bb3, ^bb5] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb5:  // pred: ^bb4
  %47 = "llvm.shl"(%43, %8) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  "llvm.br"(%45, %45, %43, %47)[^bb6] : (i64, i64, i64, i64) -> ()
^bb6(%48: i64, %49: i64, %50: i64, %51: i64):  // 2 preds: ^bb1, ^bb5
  %52 = "llvm.call"(%49) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_ulong_find_lsb, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (i64) -> i32
  %53 = "llvm.zext"(%52) <{nonNeg}> : (i32) -> i64
  %54 = "llvm.add"(%51, %53) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %55 = "llvm.and"(%54, %7) : (i64, i64) -> i64
  %56 = "llvm.getelementptr"(%15, %50) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %57 = "llvm.lshr"(%48, %55) : (i64, i64) -> i64
  %58 = "llvm.icmp"(%55, %2) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%58, %57)[^bb8, ^bb7] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
^bb7:  // pred: ^bb6
  %59 = "llvm.getelementptr"(%56) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %60 = "llvm.load"(%59) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %61 = "llvm.sub"(%10, %55) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %62 = "llvm.shl"(%60, %61) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %63 = "llvm.or"(%62, %57) <{isDisjoint}> : (i64, i64) -> i64
  "llvm.br"(%63)[^bb8] : (i64) -> ()
^bb8(%64: i64):  // 2 preds: ^bb6, ^bb7
  %65 = "llvm.and"(%64, %31) : (i64, i64) -> i64
  %66 = "llvm.shl"(%31, %55) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %67 = "llvm.xor"(%66, %6) : (i64, i64) -> i64
  %68 = "llvm.and"(%48, %67) : (i64, i64) -> i64
  "llvm.store"(%68, %56) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %69 = "llvm.icmp"(%55, %32) <{predicate = 8 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%69)[^bb9, ^bb10] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb9:  // pred: ^bb8
  %70 = "llvm.sub"(%10, %55) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %71 = "llvm.lshr"(%31, %70) : (i64, i64) -> i64
  %72 = "llvm.xor"(%71, %6) : (i64, i64) -> i64
  %73 = "llvm.getelementptr"(%56) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %74 = "llvm.load"(%73) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %75 = "llvm.and"(%74, %72) : (i64, i64) -> i64
  "llvm.store"(%75, %73) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  "llvm.br"()[^bb10] : () -> ()
^bb10:  // 2 preds: ^bb8, ^bb9
  %76 = "llvm.lshr"(%65, %28) : (i64, i64) -> i64
  %77 = "llvm.icmp"(%76, %2) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%77)[^bb11, ^bb12] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb11:  // pred: ^bb10
  %78 = "llvm.trunc"(%65) <{overflowFlags = 0 : i32}> : (i64) -> i16
  %79 = "llvm.getelementptr"(%arg0, %54) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%78, %79) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i16, !llvm.ptr) -> ()
  %80 = "llvm.add"(%54, %29) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.br"(%80)[^bb15] : (i64) -> ()
^bb12:  // pred: ^bb10
  %81 = "llvm.sub"(%65, %30) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %82 = "llvm.trunc"(%81) <{overflowFlags = 0 : i32}> : (i64) -> i16
  %83 = "llvm.getelementptr"(%arg0, %54) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%82, %83) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i16, !llvm.ptr) -> ()
  %84 = "llvm.add"(%54, %29) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %85 = "llvm.icmp"(%84, %11) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%85)[^bb13, ^bb16] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb13:  // pred: ^bb12
  %86 = "llvm.and"(%84, %7) : (i64, i64) -> i64
  %87 = "llvm.lshr"(%84, %8) : (i64, i64) -> i64
  "llvm.br"(%86, %87)[^bb14] : (i64, i64) -> ()
^bb14(%88: i64, %89: i64):  // 2 preds: ^bb13, ^bb14
  %90 = "llvm.getelementptr"(%15, %89) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %91 = "llvm.load"(%90) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %92 = "llvm.shl"(%5, %88) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %93 = "llvm.add"(%91, %92) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%93, %90) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %94 = "llvm.icmp"(%93, %91) <{predicate = 6 : i64}> : (i64, i64) -> i1
  %95 = "llvm.add"(%89, %5) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %96 = "llvm.icmp"(%89, %12) <{predicate = 6 : i64}> : (i64, i64) -> i1
  %97 = "llvm.select"(%94, %96, %13) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i1, i1) -> i1
  "llvm.cond_br"(%97, %2, %95, %84)[^bb14, ^bb15] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 2, 1>}> : (i1, i64, i64, i64) -> ()
^bb15(%98: i64):  // 2 preds: ^bb11, ^bb14
  %99 = "llvm.icmp"(%98, %14) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%99, %98)[^bb1, ^bb16] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
^bb16:  // 4 preds: ^bb2, ^bb3, ^bb12, ^bb15
  "llvm.intr.lifetime.end"(%15) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

    with
      @fd_ulong_find_lsb := MLIR.Firedancer.Crc.Ref.fd_ulong_find_lsb

end

end MLIR.Firedancer.Crc.Ref
