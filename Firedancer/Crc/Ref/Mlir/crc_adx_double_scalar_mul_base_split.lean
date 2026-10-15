
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.Crc.Ref.Mlir.crc_adx_base_split_table
public import Firedancer.Crc.Ref.Mlir.crc_adx_base_table
public import Firedancer.Crc.Ref.Extern.crc_adx_base_table_init
public import Firedancer.Crc.Ref.Mlir.crc_adx_wnaf
public import Firedancer.Crc.Ref.Mlir.crc_adx_wnaf
public import Firedancer.Crc.Ref.Mlir.crc_ge_adx_dbl_ref
public import Firedancer.Crc.Ref.Mlir.crc_adx_add_digit
public import Firedancer.Crc.Ref.Mlir.crc_adx_add_digit

namespace MLIR.Firedancer.Crc.Ref

@[expose] public section

noncomputable mlir_def crc_adx_double_scalar_mul_base_split := "llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], function_type = !llvm.func<void (ptr, ptr, ptr, ptr)>, linkage = #llvm.linkage<external>, no_inline, no_unwind, passthrough = [["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], sym_name = "crc_adx_double_scalar_mul_base_split", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: !llvm.ptr, %arg3: !llvm.ptr):
  %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %2 = "llvm.mlir.constant"() <{value = 8 : i32}> : () -> i32
  %3 = "llvm.mlir.constant"() <{value = 264 : i32}> : () -> i32
  %4 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %5 = "llvm.mlir.constant"() <{value = 263 : i32}> : () -> i32
  %6 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %7 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %8 = "llvm.mlir.constant"() <{value = 128 : i64}> : () -> i64
  %9 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %10 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %11 = "llvm.mlir.constant"() <{value = 33 : i64}> : () -> i64
  %12 = "llvm.mlir.constant"() <{value = 0 : i16}> : () -> i16
  %13 = "llvm.mlir.constant"() <{value = 9 : i64}> : () -> i64
  %14 = "llvm.mlir.addressof"() <{global_name = @crc_adx_base_split_table}> : () -> !llvm.ptr
  %15 = "llvm.mlir.addressof"() <{global_name = @crc_adx_base_table}> : () -> !llvm.ptr
  %16 = "llvm.mlir.constant"() <{value = 8 : i64}> : () -> i64
  %17 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %18 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.array<264 x i16>}> : (i32) -> !llvm.ptr
  %19 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.array<264 x i16>}> : (i32) -> !llvm.ptr
  "llvm.call"() <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, callee = @crc_adx_base_table_init, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
  "llvm.intr.lifetime.start"(%18) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%19) : (!llvm.ptr) -> ()
  %20 = "llvm.call"(%18, %arg1, %1) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crc_adx_wnaf, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> i32
  %21 = "llvm.call"(%19, %arg3, %2) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crc_adx_wnaf, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> i32
  %22 = "llvm.icmp"(%20, %3) <{predicate = 2 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%22)[^bb1, ^bb2] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb1:  // pred: ^bb0
  %23 = "llvm.sext"(%20) : (i32) -> i64
  %24 = "llvm.shl"(%23, %4) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %25 = "llvm.getelementptr"(%18, %24) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %26 = "llvm.sub"(%5, %20) <{overflowFlags = 0 : i32}> : (i32, i32) -> i32
  %27 = "llvm.zext"(%26) : (i32) -> i64
  %28 = "llvm.shl"(%27, %4) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %29 = "llvm.add"(%28, %6) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  "llvm.intr.memset"(%25, %7, %29) <{arg_attrs = [{llvm.align = 2 : i64, llvm.dereferenceable = 1 : i64, llvm.nonnull, llvm.noundef}, {}, {}], isVolatile = false, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, i8, i64) -> ()
  "llvm.br"()[^bb2] : () -> ()
^bb2:  // 2 preds: ^bb0, ^bb1
  %30 = "llvm.icmp"(%21, %3) <{predicate = 2 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%30)[^bb3, ^bb4] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb3:  // pred: ^bb2
  %31 = "llvm.sext"(%21) : (i32) -> i64
  %32 = "llvm.shl"(%31, %4) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %33 = "llvm.getelementptr"(%19, %32) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %34 = "llvm.sub"(%5, %21) <{overflowFlags = 0 : i32}> : (i32, i32) -> i32
  %35 = "llvm.zext"(%34) : (i32) -> i64
  %36 = "llvm.shl"(%35, %4) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %37 = "llvm.add"(%36, %6) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  "llvm.intr.memset"(%33, %7, %37) <{arg_attrs = [{llvm.align = 2 : i64, llvm.dereferenceable = 1 : i64, llvm.nonnull, llvm.noundef}, {}, {}], isVolatile = false, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, i8, i64) -> ()
  "llvm.br"()[^bb4] : () -> ()
^bb4:  // 2 preds: ^bb2, ^bb3
  "llvm.intr.memset"(%arg0, %7, %8) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 128 : i64, llvm.nonnull, llvm.noundef}, {}, {}], isVolatile = false}> : (!llvm.ptr, i8, i64) -> ()
  %38 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%4, %38) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %39 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%4, %39) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  "llvm.br"(%9)[^bb6] : (i64) -> ()
^bb5:  // pred: ^bb7
  "llvm.intr.lifetime.end"(%19) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%18) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
^bb6(%40: i64):  // 2 preds: ^bb4, ^bb7
  "llvm.call"(%arg0, %arg0) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @crc_ge_adx_dbl_ref, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.br"(%10)[^bb8] : (i64) -> ()
^bb7:  // pred: ^bb12
  %41 = "llvm.add"(%40, %17) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %42 = "llvm.icmp"(%40, %10) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%42, %41)[^bb5, ^bb6] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb8(%43: i64):  // 2 preds: ^bb6, ^bb12
  %44 = "llvm.mul"(%43, %11) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %45 = "llvm.add"(%44, %40) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %46 = "llvm.getelementptr"(%18, %45) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %47 = "llvm.load"(%46) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %48 = "llvm.getelementptr"(%19, %45) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %49 = "llvm.load"(%48) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %50 = "llvm.icmp"(%47, %12) <{predicate = 0 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%50)[^bb10, ^bb9] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb9:  // pred: ^bb8
  %51 = "llvm.shl"(%43, %13) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %52 = "llvm.getelementptr"(%arg2, %51) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.call"(%arg0, %52, %47) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef, llvm.signext}], callee = @crc_adx_add_digit, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i16) -> ()
  "llvm.br"()[^bb10] : () -> ()
^bb10:  // 2 preds: ^bb8, ^bb9
  %53 = "llvm.icmp"(%49, %12) <{predicate = 0 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%53)[^bb12, ^bb11] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb11:  // pred: ^bb10
  %54 = "llvm.icmp"(%43, %10) <{predicate = 0 : i64}> : (i64, i64) -> i1
  %55 = "llvm.getelementptr"(%14, %43) <{elem_type = !llvm.array<16384 x i8>, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %56 = "llvm.getelementptr"(%55) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -16384>}> : (!llvm.ptr) -> !llvm.ptr
  %57 = "llvm.select"(%54, %15, %56) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.call"(%arg0, %57, %49) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef, llvm.signext}], callee = @crc_adx_add_digit, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i16) -> ()
  "llvm.br"()[^bb12] : () -> ()
^bb12:  // 2 preds: ^bb10, ^bb11
  %58 = "llvm.add"(%43, %4) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %59 = "llvm.icmp"(%58, %16) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%59, %58)[^bb7, ^bb8] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
}) : () -> ()

    with
      @crc_adx_base_split_table := MLIR.Firedancer.Crc.Ref.crc_adx_base_split_table,
      @crc_adx_base_table := MLIR.Firedancer.Crc.Ref.crc_adx_base_table,
      @crc_adx_base_table_init := MLIR.Firedancer.Crc.Ref.crc_adx_base_table_init,
      @crc_adx_wnaf := MLIR.Firedancer.Crc.Ref.crc_adx_wnaf,
      @crc_adx_wnaf := MLIR.Firedancer.Crc.Ref.crc_adx_wnaf,
      @crc_ge_adx_dbl_ref := MLIR.Firedancer.Crc.Ref.crc_ge_adx_dbl_ref,
      @crc_adx_add_digit := MLIR.Firedancer.Crc.Ref.crc_adx_add_digit,
      @crc_adx_add_digit := MLIR.Firedancer.Crc.Ref.crc_adx_add_digit

end

end MLIR.Firedancer.Crc.Ref
