
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.Crc.Ref.Mlir.crc_adx_memzero

namespace MLIR.Firedancer.Crc.Ref

@[expose] public section

mlir_def crc_adx_recode16_bias := "llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, no_inline, no_unwind, passthrough = [["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], sym_name = "crc_adx_recode16_bias", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr):
  %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %2 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %3 = "llvm.mlir.constant"() <{value = 8608480567731124087 : i64}> : () -> i64
  %4 = "llvm.mlir.constant"() <{value = -8608480567731124088 : i64}> : () -> i64
  %5 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %6 = "llvm.mlir.constant"() <{value = 4 : i64}> : () -> i64
  %7 = "llvm.mlir.constant"() <{value = 268435455 : i64}> : () -> i64
  %8 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %9 = "llvm.mlir.constant"() <{value = 60 : i64}> : () -> i64
  %10 = "llvm.mlir.constant"() <{value = 15 : i8}> : () -> i8
  %11 = "llvm.mlir.constant"() <{value = -7 : i8}> : () -> i8
  %12 = "llvm.mlir.constant"() <{value = 64 : i64}> : () -> i64
  %13 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.array<4 x i64>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%13) : (!llvm.ptr) -> ()
  "llvm.intr.memcpy"(%13, %arg1, %1) <{arg_attrs = [{llvm.align = 16 : i64, llvm.dereferenceable = 32 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 1 : i64, llvm.dereferenceable = 32 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.br"(%2, %2)[^bb1] : (i64, i64) -> ()
^bb1(%14: i64, %15: i64):  // 2 preds: ^bb0, ^bb1
  %16 = "llvm.getelementptr"(%13, %14) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %17 = "llvm.load"(%16) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %18 = "llvm.add"(%17, %3) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %19 = "llvm.icmp"(%17, %4) <{predicate = 8 : i64}> : (i64, i64) -> i1
  %20 = "llvm.add"(%18, %15) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %21 = "llvm.icmp"(%20, %18) <{predicate = 6 : i64}> : (i64, i64) -> i1
  %22 = "llvm.or"(%19, %21) : (i1, i1) -> i1
  %23 = "llvm.zext"(%22) : (i1) -> i64
  "llvm.store"(%20, %16) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %24 = "llvm.add"(%14, %5) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %25 = "llvm.icmp"(%24, %6) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%25, %2, %24, %23)[^bb3, ^bb1] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 1, 2>}> : (i1, i64, i64, i64) -> ()
^bb2:  // pred: ^bb3
  "llvm.call"(%13, %1) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @crc_adx_memzero, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, i64) -> ()
  "llvm.intr.lifetime.end"(%13) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
^bb3(%26: i64):  // 2 preds: ^bb1, ^bb3
  %27 = "llvm.lshr"(%26, %6) : (i64, i64) -> i64
  %28 = "llvm.and"(%27, %7) : (i64, i64) -> i64
  %29 = "llvm.getelementptr"(%13, %28) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %30 = "llvm.load"(%29) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %31 = "llvm.shl"(%26, %8) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %32 = "llvm.and"(%31, %9) : (i64, i64) -> i64
  %33 = "llvm.lshr"(%30, %32) : (i64, i64) -> i64
  %34 = "llvm.trunc"(%33) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %35 = "llvm.and"(%34, %10) : (i8, i8) -> i8
  %36 = "llvm.add"(%35, %11) <{overflowFlags = 1 : i32}> : (i8, i8) -> i8
  %37 = "llvm.getelementptr"(%arg0, %26) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%36, %37) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %38 = "llvm.add"(%26, %5) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %39 = "llvm.icmp"(%38, %12) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%39, %38)[^bb2, ^bb3] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
}) : () -> ()

    with
      @crc_adx_memzero := MLIR.Firedancer.Crc.Ref.crc_adx_memzero

end

end MLIR.Firedancer.Crc.Ref
