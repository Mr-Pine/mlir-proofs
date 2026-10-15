
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab



namespace MLIR.Firedancer.Crc.Ref

@[expose] public section

mlir_def fd_ulong_align_up := "llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.noundef}, {llvm.noundef, llvm.range = #llvm.constant_range<i64, 8, 129>}], dso_local, function_type = !llvm.func<i64 (i64, i64)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], res_attrs = [{llvm.range = #llvm.constant_range<i64, 0, -7>}], sym_name = "fd_ulong_align_up", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg0: i64, %arg1: i64):
  %0 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %1 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %2 = "llvm.add"(%arg0, %0) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %3 = "llvm.add"(%2, %arg1) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %4 = "llvm.sub"(%1, %arg1) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %5 = "llvm.and"(%3, %4) : (i64, i64) -> i64
  "llvm.return"(%5) : (i64) -> ()
}) : () -> ()

end

end MLIR.Firedancer.Crc.Ref
