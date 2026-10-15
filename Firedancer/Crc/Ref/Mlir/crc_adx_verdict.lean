
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab



namespace MLIR.Firedancer.Crc.Ref

@[expose] public section

mlir_def crc_adx_verdict := "llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.noundef}], function_type = !llvm.func<i32 (ptr, i64)>, linkage = #llvm.linkage<external>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], sym_name = "crc_adx_verdict", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr, %arg1: i64):
  %0 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %1 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %2 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %3 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %4 = "llvm.mlir.constant"() <{value = -3 : i32}> : () -> i32
  %5 = "llvm.icmp"(%arg1, %0) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%5, %1, %0, %2)[^bb5, ^bb1] <{operandSegmentSizes = array<i32: 1, 1, 2>}> : (i1, i32, i64, i32) -> ()
^bb1(%6: i64, %7: i32):  // 2 preds: ^bb0, ^bb3
  %8 = "llvm.getelementptr"(%arg0, %6) <{elem_type = !llvm.array<4 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %9 = "llvm.load"(%8) <{alignment = 4 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i32
  "llvm.switch"(%9, %9, %7)[^bb5, ^bb3, ^bb2] <{branch_weights = array<i32: 1, 4000, 1>, case_operand_segments = array<i32: 1, 0>, case_values = dense<[0, -3]> : vector<2xi32>, operandSegmentSizes = array<i32: 1, 1, 1>}> : (i32, i32, i32) -> ()
^bb2:  // pred: ^bb1
  "llvm.br"(%1)[^bb3] : (i32) -> ()
^bb3(%10: i32):  // 2 preds: ^bb1, ^bb2
  %11 = "llvm.add"(%6, %3) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %12 = "llvm.icmp"(%11, %arg1) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%12, %11, %10)[^bb4, ^bb1] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 2>}> : (i1, i64, i32) -> ()
^bb4:  // pred: ^bb3
  %13 = "llvm.icmp"(%10, %1) <{predicate = 0 : i64}> : (i32, i32) -> i1
  %14 = "llvm.select"(%13, %4, %1) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i32, i32) -> i32
  "llvm.br"(%14)[^bb5] : (i32) -> ()
^bb5(%15: i32):  // 3 preds: ^bb0, ^bb1, ^bb4
  "llvm.return"(%15) : (i32) -> ()
}) : () -> ()

end

end MLIR.Firedancer.Crc.Ref
