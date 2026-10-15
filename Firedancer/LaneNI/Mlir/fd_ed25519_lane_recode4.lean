
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab



namespace Firedancer.LaneNI.Mlir

@[expose] public section

mlir_def fd_ed25519_lane_recode4 := "llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writeonly}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], sym_name = "fd_ed25519_lane_recode4", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr):
  %0 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %1 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %2 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %3 = "llvm.mlir.constant"() <{value = 2147483647 : i64}> : () -> i64
  %4 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %5 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %6 = "llvm.mlir.constant"() <{value = 15 : i32}> : () -> i32
  %7 = "llvm.mlir.constant"() <{value = 8 : i32}> : () -> i32
  %8 = "llvm.mlir.constant"() <{value = 240 : i32}> : () -> i32
  %9 = "llvm.mlir.constant"() <{value = 64 : i64}> : () -> i64
  "llvm.br"(%0, %1)[^bb2] : (i64, i32) -> ()
^bb1:  // pred: ^bb2
  "llvm.return"() : () -> ()
^bb2(%10: i64, %11: i32):  // 2 preds: ^bb0, ^bb2
  %12 = "llvm.lshr"(%10, %2) : (i64, i64) -> i64
  %13 = "llvm.and"(%12, %3) : (i64, i64) -> i64
  %14 = "llvm.getelementptr"(%arg0, %13) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %15 = "llvm.load"(%14) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %16 = "llvm.zext"(%15) : (i8) -> i32
  %17 = "llvm.trunc"(%10) <{overflowFlags = 0 : i32}> : (i64) -> i32
  %18 = "llvm.shl"(%17, %4) <{overflowFlags = 0 : i32}> : (i32, i32) -> i32
  %19 = "llvm.and"(%18, %5) : (i32, i32) -> i32
  %20 = "llvm.lshr"(%16, %19) : (i32, i32) -> i32
  %21 = "llvm.and"(%20, %6) : (i32, i32) -> i32
  %22 = "llvm.add"(%21, %11) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %23 = "llvm.add"(%22, %7) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %24 = "llvm.lshr"(%23, %5) : (i32, i32) -> i32
  %25 = "llvm.and"(%23, %8) : (i32, i32) -> i32
  %26 = "llvm.sub"(%22, %25) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %27 = "llvm.trunc"(%26) <{overflowFlags = 1 : i32}> : (i32) -> i8
  %28 = "llvm.getelementptr"(%arg1, %10) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%27, %28) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %29 = "llvm.add"(%10, %2) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %30 = "llvm.icmp"(%29, %9) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%30, %29, %24)[^bb1, ^bb2] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 2>}> : (i1, i64, i32) -> ()
}) : () -> ()

end

end Firedancer.LaneNI.Mlir
