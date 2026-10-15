
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab



namespace Firedancer.LaneNI.Mlir

@[expose] public section

mlir_def fd_x25519_is_zero_const_time := "llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<i32 (ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], res_attrs = [{llvm.range = #llvm.constant_range<i32, 0, 2>}], sym_name = "fd_x25519_is_zero_const_time", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, zero_call_used_regs = "all"}> ({
^bb0(%arg0: !llvm.ptr):
  %0 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %1 = "llvm.mlir.constant"() <{value = dense<false> : vector<16xi1>}> : () -> vector<16xi1>
  %2 = "llvm.mlir.constant"() <{value = dense<0> : vector<16xi8>}> : () -> vector<16xi8>
  %3 = "llvm.mlir.constant"() <{value = 16 : i64}> : () -> i64
  %4 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %5 = "llvm.mlir.constant"() <{value = 0 : i16}> : () -> i16
  "llvm.br"(%0, %1)[^bb1] : (i64, vector<16xi1>) -> ()
^bb1(%6: i64, %7: vector<16xi1>):  // 2 preds: ^bb0, ^bb1
  %8 = "llvm.getelementptr"(%arg0, %6) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %9 = "llvm.load"(%8) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<16xi8>
  %10 = "llvm.freeze"(%9) : (vector<16xi8>) -> vector<16xi8>
  %11 = "llvm.icmp"(%10, %2) <{predicate = 1 : i64}> : (vector<16xi8>, vector<16xi8>) -> vector<16xi1>
  %12 = "llvm.or"(%7, %11) : (vector<16xi1>, vector<16xi1>) -> vector<16xi1>
  %13 = "llvm.add"(%6, %3) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %14 = "llvm.icmp"(%13, %4) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%14, %13, %12)[^bb2, ^bb1] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true, runtimeDisable = true>, mustProgress = true, isVectorized = true>, operandSegmentSizes = array<i32: 1, 0, 2>}> : (i1, i64, vector<16xi1>) -> ()
^bb2:  // pred: ^bb1
  %15 = "llvm.bitcast"(%12) : (vector<16xi1>) -> i16
  %16 = "llvm.icmp"(%15, %5) <{predicate = 0 : i64}> : (i16, i16) -> i1
  %17 = "llvm.zext"(%16) : (i1) -> i32
  "llvm.return"(%17) : (i32) -> ()
}) : () -> ()

end

end Firedancer.LaneNI.Mlir
