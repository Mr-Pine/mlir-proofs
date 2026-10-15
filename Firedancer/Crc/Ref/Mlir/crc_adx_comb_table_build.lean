
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.Crc.Ref.Mlir.__const_crc_adx_comb_table_build_pb
public import Firedancer.Crc.Ref.Mlir.crc_adx_comb_table
public import Firedancer.Crc.Ref.Mlir.crc_fe64_inv_1
public import Firedancer.Crc.Ref.Mlir.crc_fe64_mul_c_2
public import Firedancer.Crc.Ref.Mlir.crc_fe64_mul_c_2
public import Firedancer.Crc.Ref.Mlir.crc_fe64_mul_c_2
public import Firedancer.Crc.Ref.Mlir.crc_ge_adx_to_table_ref_16
public import Firedancer.Crc.Ref.Mlir.crc_ge_adx_add_ref_17
public import Firedancer.Crc.Ref.Mlir.crc_ge_adx_dbl_ref_18

namespace MLIR.Firedancer.Crc.Ref

@[expose] public section

mlir_def crc_adx_comb_table_build := "llvm.func"() <{CConv = #llvm.cconv<fastcc>, dso_local, function_type = !llvm.func<void ()>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = readwrite, argMem = none, inaccessibleMem = none, errnoMem = readwrite, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], sym_name = "crc_adx_comb_table_build", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
  %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1 = "llvm.mlir.addressof"() <{global_name = @__const.crc_adx_comb_table_build.pb}> : () -> !llvm.ptr
  %2 = "llvm.mlir.constant"() <{value = 128 : i64}> : () -> i64
  %3 = "llvm.mlir.constant"() <{value = 64 : i64}> : () -> i64
  %4 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %5 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %6 = "llvm.mlir.addressof"() <{global_name = @crc_adx_comb_table}> : () -> !llvm.ptr
  %7 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %8 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %9 = "llvm.mlir.constant"() <{value = 8 : i64}> : () -> i64
  %10 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %11 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %12 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.array<16 x i64>}> : (i32) -> !llvm.ptr
  %13 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.array<16 x i64>}> : (i32) -> !llvm.ptr
  %14 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.array<4 x i64>}> : (i32) -> !llvm.ptr
  %15 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.array<16 x i64>}> : (i32) -> !llvm.ptr
  %16 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.array<16 x i64>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%12) : (!llvm.ptr) -> ()
  "llvm.intr.memcpy"(%12, %1, %2) <{arg_attrs = [{llvm.align = 16 : i64, llvm.dereferenceable = 128 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 16 : i64, llvm.dereferenceable = 128 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %17 = "llvm.getelementptr"(%13) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %18 = "llvm.getelementptr"(%15) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %19 = "llvm.getelementptr"(%13) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %20 = "llvm.getelementptr"(%15) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %21 = "llvm.getelementptr"(%15) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %22 = "llvm.getelementptr"(%13) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %23 = "llvm.getelementptr"(%16) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %24 = "llvm.getelementptr"(%15) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.br"(%5)[^bb2] : (i64) -> ()
^bb1:  // pred: ^bb4
  "llvm.intr.lifetime.end"(%12) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
^bb2(%25: i64):  // 2 preds: ^bb0, ^bb4
  "llvm.intr.lifetime.start"(%13) : (!llvm.ptr) -> ()
  "llvm.intr.memcpy"(%13, %12, %2) <{arg_attrs = [{llvm.align = 16 : i64, llvm.dereferenceable = 128 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 16 : i64, llvm.dereferenceable = 128 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %26 = "llvm.getelementptr"(%6, %25) <{elem_type = !llvm.array<768 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.br"(%5)[^bb3] : (i64) -> ()
^bb3(%27: i64):  // 2 preds: ^bb2, ^bb3
  "llvm.intr.lifetime.start"(%14) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%15) : (!llvm.ptr) -> ()
  "llvm.intr.memset"(%24, %7, %4) <{arg_attrs = [{llvm.align = 16 : i64, llvm.dereferenceable = 32 : i64, llvm.nonnull, llvm.noundef}, {}, {}], isVolatile = false}> : (!llvm.ptr, i8, i64) -> ()
  "llvm.intr.lifetime.start"(%16) : (!llvm.ptr) -> ()
  %28 = "llvm.getelementptr"(%26, %27) <{elem_type = !llvm.array<96 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.call"(%14, %17) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @crc_fe64_inv.1, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%15, %13, %14) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @crc_fe64_mul_c.2, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%18, %19, %14) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @crc_fe64_mul_c.2, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.store"(%8, %20) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  "llvm.call"(%21, %22, %14) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @crc_fe64_mul_c.2, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%16, %15) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @crc_ge_adx_to_table_ref.16, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.memcpy"(%28, %16, %3) <{arg_attrs = [{llvm.align = 32 : i64, llvm.dereferenceable = 64 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 16 : i64, llvm.dereferenceable = 64 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %29 = "llvm.getelementptr"(%28) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memcpy"(%29, %23, %4) <{arg_attrs = [{llvm.align = 32 : i64, llvm.dereferenceable = 32 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 16 : i64, llvm.dereferenceable = 32 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.call"(%13, %13, %12) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crc_ge_adx_add_ref.17, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%16) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%15) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%14) : (!llvm.ptr) -> ()
  %30 = "llvm.add"(%27, %8) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %31 = "llvm.icmp"(%30, %9) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%31, %10, %30)[^bb5, ^bb3] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 1, 1>}> : (i1, i32, i64) -> ()
^bb4:  // pred: ^bb5
  "llvm.intr.lifetime.end"(%13) : (!llvm.ptr) -> ()
  %32 = "llvm.add"(%25, %8) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %33 = "llvm.icmp"(%32, %3) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%33, %32)[^bb1, ^bb2] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb5(%34: i32):  // 2 preds: ^bb3, ^bb5
  "llvm.call"(%12, %12) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @crc_ge_adx_dbl_ref.18, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %35 = "llvm.add"(%34, %0) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %36 = "llvm.icmp"(%35, %11) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%36, %35)[^bb4, ^bb5] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
}) : () -> ()

    with
      @__const.crc_adx_comb_table_build.pb := MLIR.Firedancer.Crc.Ref.__const_crc_adx_comb_table_build_pb,
      @crc_adx_comb_table := MLIR.Firedancer.Crc.Ref.crc_adx_comb_table,
      @crc_fe64_inv.1 := MLIR.Firedancer.Crc.Ref.crc_fe64_inv_1,
      @crc_fe64_mul_c.2 := MLIR.Firedancer.Crc.Ref.crc_fe64_mul_c_2,
      @crc_fe64_mul_c.2 := MLIR.Firedancer.Crc.Ref.crc_fe64_mul_c_2,
      @crc_fe64_mul_c.2 := MLIR.Firedancer.Crc.Ref.crc_fe64_mul_c_2,
      @crc_ge_adx_to_table_ref.16 := MLIR.Firedancer.Crc.Ref.crc_ge_adx_to_table_ref_16,
      @crc_ge_adx_add_ref.17 := MLIR.Firedancer.Crc.Ref.crc_ge_adx_add_ref_17,
      @crc_ge_adx_dbl_ref.18 := MLIR.Firedancer.Crc.Ref.crc_ge_adx_dbl_ref_18

end

end MLIR.Firedancer.Crc.Ref
