
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab



namespace Firedancer.LaneNI.Mlir

@[expose] public section

mlir_def fd_r43x6_pack_90 := "llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.noundef}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<vector<4xi64> (vector<8xi64>)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], sym_name = "fd_r43x6_pack.90", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg0: vector<8xi64>):
  %0 = "llvm.mlir.poison"() : () -> vector<8xi64>
  %1 = "llvm.mlir.constant"() <{value = 44 : i64}> : () -> i64
  %2 = "llvm.mlir.constant"() <{value = 43 : i64}> : () -> i64
  %3 = "llvm.mlir.constant"() <{value = 22 : i64}> : () -> i64
  %4 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %5 = "llvm.mlir.constant"() <{value = 23 : i64}> : () -> i64
  %6 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %7 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %8 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %9 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %10 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %11 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %12 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %13 = "llvm.mlir.poison"() : () -> i64
  %14 = "llvm.mlir.constant"() <{value = 20 : i64}> : () -> i64
  %15 = "llvm.mlir.constant"() <{value = 42 : i64}> : () -> i64
  %16 = "llvm.mlir.constant"() <{value = 21 : i64}> : () -> i64
  %17 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %18 = "llvm.mlir.undef"() : () -> vector<8xi64>
  %19 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %20 = "llvm.insertelement"(%18, %17, %19) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %21 = "llvm.insertelement"(%20, %16, %12) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %22 = "llvm.insertelement"(%21, %15, %11) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %23 = "llvm.insertelement"(%22, %13, %10) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %24 = "llvm.insertelement"(%23, %14, %9) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %25 = "llvm.insertelement"(%24, %13, %8) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %26 = "llvm.insertelement"(%25, %13, %7) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %27 = "llvm.insertelement"(%26, %13, %6) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %28 = "llvm.insertelement"(%18, %17, %19) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %29 = "llvm.insertelement"(%28, %2, %12) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %30 = "llvm.insertelement"(%29, %3, %11) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %31 = "llvm.insertelement"(%30, %4, %10) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %32 = "llvm.insertelement"(%31, %13, %9) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %33 = "llvm.insertelement"(%32, %5, %8) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %34 = "llvm.insertelement"(%33, %13, %7) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %35 = "llvm.insertelement"(%34, %13, %6) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %36 = "llvm.insertelement"(%18, %17, %19) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %37 = "llvm.insertelement"(%36, %2, %12) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %38 = "llvm.insertelement"(%37, %3, %11) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %39 = "llvm.insertelement"(%38, %13, %10) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %40 = "llvm.insertelement"(%39, %1, %9) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %41 = "llvm.insertelement"(%40, %5, %8) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %42 = "llvm.insertelement"(%41, %13, %7) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %43 = "llvm.insertelement"(%42, %13, %6) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %44 = "llvm.lshr"(%arg0, %27) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %45 = "llvm.shl"(%arg0, %35) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %46 = "llvm.shl"(%arg0, %43) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %47 = "llvm.shufflevector"(%44, %0) <{mask = array<i32: 0, 1, 2, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<4xi64>
  %48 = "llvm.shufflevector"(%45, %0) <{mask = array<i32: 1, 2, 3, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<4xi64>
  %49 = "llvm.or"(%47, %48) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %50 = "llvm.shufflevector"(%46, %0) <{mask = array<i32: 1, 2, 4, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<4xi64>
  %51 = "llvm.or"(%49, %50) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.return"(%51) : (vector<4xi64>) -> ()
}) : () -> ()

end

end Firedancer.LaneNI.Mlir
