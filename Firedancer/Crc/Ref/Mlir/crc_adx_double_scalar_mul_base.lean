
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.Crc.Ref.Mlir.crc_adx_base_table
public import Firedancer.Crc.Ref.Extern.crc_adx_base_table_init
public import Firedancer.Crc.Ref.Mlir.crc_adx_odd_table
public import Firedancer.Crc.Ref.Mlir.crc_adx_wnaf
public import Firedancer.Crc.Ref.Mlir.crc_adx_wnaf
public import Firedancer.Crc.Ref.Mlir.crc_ge_adx_dbl_ref
public import Firedancer.Crc.Ref.Mlir.crc_adx_add_digit
public import Firedancer.Crc.Ref.Mlir.crc_adx_add_digit

namespace MLIR.Firedancer.Crc.Ref

@[expose] public section

noncomputable mlir_def crc_adx_double_scalar_mul_base := "llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], function_type = !llvm.func<void (ptr, ptr, ptr, ptr)>, linkage = #llvm.linkage<external>, no_inline, no_unwind, passthrough = [["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], sym_name = "crc_adx_double_scalar_mul_base", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: !llvm.ptr, %arg3: !llvm.ptr):
  %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1 = "llvm.mlir.constant"() <{value = 8 : i32}> : () -> i32
  %2 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %3 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %4 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
  %5 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %6 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %7 = "llvm.mlir.constant"() <{value = 128 : i64}> : () -> i64
  %8 = "llvm.mlir.constant"() <{value = 0 : i16}> : () -> i16
  %9 = "llvm.mlir.addressof"() <{global_name = @crc_adx_base_table}> : () -> !llvm.ptr
  %10 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %11 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %12 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = !llvm.array<8 x array<16 x i64>>}> : (i32) -> !llvm.ptr
  %13 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.array<256 x i16>}> : (i32) -> !llvm.ptr
  %14 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.array<256 x i16>}> : (i32) -> !llvm.ptr
  "llvm.call"() <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, callee = @crc_adx_base_table_init, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
  "llvm.intr.lifetime.start"(%12) : (!llvm.ptr) -> ()
  "llvm.call"(%12, %arg2, %1) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crc_adx_odd_table, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> ()
  "llvm.intr.lifetime.start"(%13) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%14) : (!llvm.ptr) -> ()
  %15 = "llvm.call"(%13, %arg1, %2) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crc_adx_wnaf, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> i32
  %16 = "llvm.call"(%14, %arg3, %1) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crc_adx_wnaf, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> i32
  %17 = "llvm.intr.smax"(%15, %16) : (i32, i32) -> i32
  %18 = "llvm.icmp"(%16, %15) <{predicate = 4 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%18)[^bb1, ^bb2] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb1:  // pred: ^bb0
  %19 = "llvm.sext"(%15) : (i32) -> i64
  %20 = "llvm.shl"(%19, %3) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %21 = "llvm.getelementptr"(%13, %20) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %22 = "llvm.xor"(%15, %4) : (i32, i32) -> i32
  %23 = "llvm.add"(%17, %22) <{overflowFlags = 0 : i32}> : (i32, i32) -> i32
  %24 = "llvm.zext"(%23) : (i32) -> i64
  %25 = "llvm.shl"(%24, %3) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %26 = "llvm.add"(%25, %5) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  "llvm.intr.memset"(%21, %6, %26) <{arg_attrs = [{llvm.align = 2 : i64, llvm.dereferenceable = 1 : i64, llvm.nonnull, llvm.noundef}, {}, {}], isVolatile = false, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, i8, i64) -> ()
  "llvm.br"()[^bb2] : () -> ()
^bb2:  // 2 preds: ^bb0, ^bb1
  %27 = "llvm.icmp"(%15, %16) <{predicate = 4 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%27)[^bb4, ^bb3] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb3:  // pred: ^bb2
  %28 = "llvm.add"(%17, %4) <{overflowFlags = 0 : i32}> : (i32, i32) -> i32
  "llvm.br"(%28)[^bb5] : (i32) -> ()
^bb4:  // pred: ^bb2
  %29 = "llvm.sext"(%16) : (i32) -> i64
  %30 = "llvm.shl"(%29, %3) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %31 = "llvm.getelementptr"(%14, %30) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %32 = "llvm.add"(%17, %4) <{overflowFlags = 0 : i32}> : (i32, i32) -> i32
  %33 = "llvm.sub"(%32, %16) <{overflowFlags = 0 : i32}> : (i32, i32) -> i32
  %34 = "llvm.zext"(%33) : (i32) -> i64
  %35 = "llvm.shl"(%34, %3) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %36 = "llvm.add"(%35, %5) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  "llvm.intr.memset"(%31, %6, %36) <{arg_attrs = [{llvm.align = 2 : i64, llvm.dereferenceable = 1 : i64, llvm.nonnull, llvm.noundef}, {}, {}], isVolatile = false, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, i8, i64) -> ()
  "llvm.br"(%32)[^bb5] : (i32) -> ()
^bb5(%37: i32):  // 2 preds: ^bb3, ^bb4
  "llvm.intr.memset"(%arg0, %6, %7) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 128 : i64, llvm.nonnull, llvm.noundef}, {}, {}], isVolatile = false}> : (!llvm.ptr, i8, i64) -> ()
  %38 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3, %38) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %39 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3, %39) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %40 = "llvm.icmp"(%37, %4) <{predicate = 4 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%40)[^bb6, ^bb7] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb6:  // pred: ^bb5
  %41 = "llvm.zext"(%37) <{nonNeg}> : (i32) -> i64
  "llvm.br"(%41)[^bb8] : (i64) -> ()
^bb7:  // 2 preds: ^bb5, ^bb12
  "llvm.intr.lifetime.end"(%14) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%13) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%12) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
^bb8(%42: i64):  // 2 preds: ^bb6, ^bb12
  "llvm.call"(%arg0, %arg0) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @crc_ge_adx_dbl_ref, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %43 = "llvm.getelementptr"(%13, %42) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %44 = "llvm.load"(%43) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %45 = "llvm.icmp"(%44, %8) <{predicate = 0 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%45)[^bb10, ^bb9] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb9:  // pred: ^bb8
  "llvm.call"(%arg0, %12, %44) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef, llvm.signext}], callee = @crc_adx_add_digit, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i16) -> ()
  "llvm.br"()[^bb10] : () -> ()
^bb10:  // 2 preds: ^bb8, ^bb9
  %46 = "llvm.getelementptr"(%14, %42) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %47 = "llvm.load"(%46) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %48 = "llvm.icmp"(%47, %8) <{predicate = 0 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%48)[^bb12, ^bb11] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb11:  // pred: ^bb10
  "llvm.call"(%arg0, %9, %47) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef, llvm.signext}], callee = @crc_adx_add_digit, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i16) -> ()
  "llvm.br"()[^bb12] : () -> ()
^bb12:  // 2 preds: ^bb10, ^bb11
  %49 = "llvm.add"(%42, %10) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %50 = "llvm.icmp"(%42, %11) <{predicate = 4 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%50, %49)[^bb8, ^bb7] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
}) : () -> ()

    with
      @crc_adx_base_table := MLIR.Firedancer.Crc.Ref.crc_adx_base_table,
      @crc_adx_base_table_init := MLIR.Firedancer.Crc.Ref.crc_adx_base_table_init,
      @crc_adx_odd_table := MLIR.Firedancer.Crc.Ref.crc_adx_odd_table,
      @crc_adx_wnaf := MLIR.Firedancer.Crc.Ref.crc_adx_wnaf,
      @crc_adx_wnaf := MLIR.Firedancer.Crc.Ref.crc_adx_wnaf,
      @crc_ge_adx_dbl_ref := MLIR.Firedancer.Crc.Ref.crc_ge_adx_dbl_ref,
      @crc_adx_add_digit := MLIR.Firedancer.Crc.Ref.crc_adx_add_digit,
      @crc_adx_add_digit := MLIR.Firedancer.Crc.Ref.crc_adx_add_digit

end

end MLIR.Firedancer.Crc.Ref
