
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.Crc.Ref.Mlir.crc_ge_adx_dbl_ref
public import Firedancer.Crc.Ref.Mlir.crc_ge_adx_to_table_ref
public import Firedancer.Crc.Ref.Mlir.crc_ge_adx_add_ref
public import Firedancer.Crc.Ref.Mlir.crc_ge_adx_to_table_ref

namespace MLIR.Firedancer.Crc.Ref

@[expose] public section

mlir_def crc_adx_odd_table := "llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.noundef, llvm.range = #llvm.constant_range<i32, 4, 129>}], dso_local, function_type = !llvm.func<void (ptr, ptr, i32)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], sym_name = "crc_adx_odd_table", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: i32):
  %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1 = "llvm.mlir.constant"() <{value = 128 : i64}> : () -> i64
  %2 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %3 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.array<16 x i64>}> : (i32) -> !llvm.ptr
  %4 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.array<16 x i64>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%3) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%4) : (!llvm.ptr) -> ()
  "llvm.intr.memcpy"(%3, %arg1, %1) <{arg_attrs = [{llvm.align = 16 : i64, llvm.dereferenceable = 128 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 128 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.call"(%4, %3) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @crc_ge_adx_dbl_ref, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%arg0, %3) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @crc_ge_adx_to_table_ref, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %5 = "llvm.zext"(%arg2) <{nonNeg}> : (i32) -> i64
  "llvm.br"(%2)[^bb2] : (i64) -> ()
^bb1:  // pred: ^bb2
  "llvm.intr.lifetime.end"(%4) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
^bb2(%6: i64):  // 2 preds: ^bb0, ^bb2
  "llvm.call"(%3, %3, %4) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crc_ge_adx_add_ref, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  %7 = "llvm.getelementptr"(%arg0, %6) <{elem_type = !llvm.array<128 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.call"(%7, %3) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @crc_ge_adx_to_table_ref, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %8 = "llvm.add"(%6, %2) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %9 = "llvm.icmp"(%8, %5) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%9, %8)[^bb1, ^bb2] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
}) : () -> ()

    with
      @crc_ge_adx_dbl_ref := MLIR.Firedancer.Crc.Ref.crc_ge_adx_dbl_ref,
      @crc_ge_adx_to_table_ref := MLIR.Firedancer.Crc.Ref.crc_ge_adx_to_table_ref,
      @crc_ge_adx_add_ref := MLIR.Firedancer.Crc.Ref.crc_ge_adx_add_ref,
      @crc_ge_adx_to_table_ref := MLIR.Firedancer.Crc.Ref.crc_ge_adx_to_table_ref

end

end MLIR.Firedancer.Crc.Ref
