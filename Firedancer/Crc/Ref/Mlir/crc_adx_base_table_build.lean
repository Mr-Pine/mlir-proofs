
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.Crc.Ref.Mlir.__const_crc_adx_base_table_build_b
public import Firedancer.Crc.Ref.Mlir.crc_adx_base_table
public import Firedancer.Crc.Ref.Mlir.crc_adx_base_split_table
public import Firedancer.Crc.Ref.Mlir.crc_adx_odd_table
public import Firedancer.Crc.Ref.Mlir.crc_adx_point_dbln
public import Firedancer.Crc.Ref.Mlir.crc_adx_odd_table

namespace MLIR.Firedancer.Crc.Ref

@[expose] public section

mlir_def crc_adx_base_table_build := "llvm.func"() <{CConv = #llvm.cconv<fastcc>, dso_local, function_type = !llvm.func<void ()>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = readwrite, argMem = none, inaccessibleMem = none, errnoMem = readwrite, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], sym_name = "crc_adx_base_table_build", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
  %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1 = "llvm.mlir.addressof"() <{global_name = @__const.crc_adx_base_table_build.b}> : () -> !llvm.ptr
  %2 = "llvm.mlir.constant"() <{value = 128 : i64}> : () -> i64
  %3 = "llvm.mlir.addressof"() <{global_name = @crc_adx_base_table}> : () -> !llvm.ptr
  %4 = "llvm.mlir.constant"() <{value = 128 : i32}> : () -> i32
  %5 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %6 = "llvm.mlir.addressof"() <{global_name = @crc_adx_base_split_table}> : () -> !llvm.ptr
  %7 = "llvm.mlir.constant"() <{value = 8 : i64}> : () -> i64
  %8 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.array<16 x i64>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%8) : (!llvm.ptr) -> ()
  "llvm.intr.memcpy"(%8, %1, %2) <{arg_attrs = [{llvm.align = 16 : i64, llvm.dereferenceable = 128 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 16 : i64, llvm.dereferenceable = 128 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.call"(%3, %1, %4) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @crc_adx_odd_table, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> ()
  "llvm.br"(%5)[^bb2] : (i64) -> ()
^bb1:  // pred: ^bb2
  "llvm.intr.lifetime.end"(%8) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
^bb2(%9: i64):  // 2 preds: ^bb0, ^bb2
  "llvm.call"(%8, %8) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @crc_adx_point_dbln, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %10 = "llvm.getelementptr"(%6, %9) <{elem_type = !llvm.array<16384 x i8>, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %11 = "llvm.getelementptr"(%10) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -16384>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%11, %8, %4) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @crc_adx_odd_table, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> ()
  %12 = "llvm.add"(%9, %5) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %13 = "llvm.icmp"(%12, %7) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%13, %12)[^bb1, ^bb2] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
}) : () -> ()

    with
      @__const.crc_adx_base_table_build.b := MLIR.Firedancer.Crc.Ref.__const_crc_adx_base_table_build_b,
      @crc_adx_base_table := MLIR.Firedancer.Crc.Ref.crc_adx_base_table,
      @crc_adx_base_split_table := MLIR.Firedancer.Crc.Ref.crc_adx_base_split_table,
      @crc_adx_odd_table := MLIR.Firedancer.Crc.Ref.crc_adx_odd_table,
      @crc_adx_point_dbln := MLIR.Firedancer.Crc.Ref.crc_adx_point_dbln,
      @crc_adx_odd_table := MLIR.Firedancer.Crc.Ref.crc_adx_odd_table

end

end MLIR.Firedancer.Crc.Ref
