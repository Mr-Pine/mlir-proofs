
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab



namespace Firedancer.LaneNI.Mlir

@[expose] public section

mlir_def fd_r43x6_scale_fast := "llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.noundef}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<vector<8xi64> (vector<8xi64>)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], sym_name = "fd_r43x6_scale_fast", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg0: vector<8xi64>):
  %0 = "llvm.mlir.constant"() <{value = dense<24> : vector<8xi64>}> : () -> vector<8xi64>
  %1 = "llvm.mlir.constant"() <{value = dense<7> : vector<8xi64>}> : () -> vector<8xi64>
  %2 = "llvm.mlir.constant"() <{value = dense<[-1, -1, -1, -1, -1, -1, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %3 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %4 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %5 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %6 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %7 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %8 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %9 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %10 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %11 = "llvm.mlir.constant"() <{value = dense<0> : vector<8xi64>}> : () -> vector<8xi64>
  %12 = "llvm.mlir.constant"() <{value = dense<121666> : vector<8xi64>}> : () -> vector<8xi64>
  %13 = "llvm.mlir.constant"() <{value = dense<9> : vector<8xi64>}> : () -> vector<8xi64>
  %14 = "llvm.mlir.poison"() : () -> i64
  %15 = "llvm.mlir.undef"() : () -> vector<8xi64>
  %16 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %17 = "llvm.insertelement"(%15, %14, %16) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %18 = "llvm.insertelement"(%17, %14, %9) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %19 = "llvm.insertelement"(%18, %14, %8) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %20 = "llvm.insertelement"(%19, %14, %7) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %21 = "llvm.insertelement"(%20, %14, %6) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %22 = "llvm.insertelement"(%21, %14, %5) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %23 = "llvm.insertelement"(%22, %14, %4) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %24 = "llvm.insertelement"(%23, %10, %3) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %25 = "llvm.insertelement"(%15, %10, %16) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %26 = "llvm.insertelement"(%25, %10, %9) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %27 = "llvm.insertelement"(%26, %10, %8) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %28 = "llvm.insertelement"(%27, %10, %7) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %29 = "llvm.insertelement"(%28, %10, %6) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %30 = "llvm.insertelement"(%29, %10, %5) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %31 = "llvm.insertelement"(%30, %14, %4) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %32 = "llvm.insertelement"(%31, %14, %3) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %33 = "llvm.call_intrinsic"(%11, %12, %arg0) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %34 = "llvm.shl"(%33, %13) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %35 = "llvm.shufflevector"(%24, %34) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %36 = "llvm.call_intrinsic"(%35, %12, %arg0) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %37 = "llvm.and"(%36, %2) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %38 = "llvm.shufflevector"(%36, %32) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %39 = "llvm.shl"(%38, %1) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %40 = "llvm.add"(%39, %37) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %41 = "llvm.mul"(%38, %0) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %42 = "llvm.add"(%40, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.return"(%42) : (vector<8xi64>) -> ()
}) : () -> ()

end

end Firedancer.LaneNI.Mlir
