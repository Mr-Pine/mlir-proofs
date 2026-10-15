
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.Crc.Ref.Mlir.crc_ge_adx_dbl_ref

namespace MLIR.Firedancer.Crc.Ref

@[expose] public section

mlir_def crc_adx_point_dbln := "llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], sym_name = "crc_adx_point_dbln", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr):
  %0 = "llvm.mlir.constant"() <{value = 128 : i64}> : () -> i64
  %1 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %2 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %3 = "llvm.mlir.constant"() <{value = 33 : i32}> : () -> i32
  %4 = "llvm.icmp"(%arg0, %arg1) <{predicate = 0 : i64}> : (!llvm.ptr, !llvm.ptr) -> i1
  "llvm.cond_br"(%4)[^bb1, ^bb2] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb1:  // 2 preds: ^bb0, ^bb2
  "llvm.br"(%1)[^bb4] : (i32) -> ()
^bb2:  // pred: ^bb0
  "llvm.intr.memcpy"(%arg0, %arg1, %0) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 128 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 128 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.br"()[^bb1] : () -> ()
^bb3:  // pred: ^bb4
  "llvm.return"() : () -> ()
^bb4(%5: i32):  // 2 preds: ^bb1, ^bb4
  "llvm.call"(%arg0, %arg0) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @crc_ge_adx_dbl_ref, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %6 = "llvm.add"(%5, %2) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %7 = "llvm.icmp"(%6, %3) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%7, %6)[^bb3, ^bb4] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
}) : () -> ()

    with
      @crc_ge_adx_dbl_ref := MLIR.Firedancer.Crc.Ref.crc_ge_adx_dbl_ref

end

end MLIR.Firedancer.Crc.Ref
