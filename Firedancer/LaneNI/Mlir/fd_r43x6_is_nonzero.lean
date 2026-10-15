
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab



namespace Firedancer.LaneNI.Mlir

@[expose] public section

mlir_def fd_r43x6_is_nonzero := "llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.noundef}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<i32 (vector<8xi64>)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], res_attrs = [{llvm.range = #llvm.constant_range<i32, 0, 2>}], sym_name = "fd_r43x6_is_nonzero", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg0: vector<8xi64>):
  %0 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %1 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %2 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %3 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %4 = "llvm.mlir.constant"() <{value = 4 : i64}> : () -> i64
  %5 = "llvm.mlir.constant"() <{value = 5 : i64}> : () -> i64
  %6 = "llvm.mlir.constant"() <{value = -1048576 : i64}> : () -> i64
  %7 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
  %8 = "llvm.mlir.constant"() <{value = 1099511627775 : i64}> : () -> i64
  %9 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %10 = "llvm.mlir.constant"() <{value = 43 : i64}> : () -> i64
  %11 = "llvm.mlir.constant"() <{value = 8796093022207 : i64}> : () -> i64
  %12 = "llvm.mlir.constant"() <{value = 1048576 : i64}> : () -> i64
  %13 = "llvm.mlir.constant"() <{value = 1099511627776 : i64}> : () -> i64
  %14 = "llvm.mlir.constant"() <{value = -19 : i64}> : () -> i64
  %15 = "llvm.extractelement"(%arg0, %0) : (vector<8xi64>, i64) -> i64
  %16 = "llvm.extractelement"(%arg0, %1) : (vector<8xi64>, i64) -> i64
  %17 = "llvm.extractelement"(%arg0, %2) : (vector<8xi64>, i64) -> i64
  %18 = "llvm.extractelement"(%arg0, %3) : (vector<8xi64>, i64) -> i64
  %19 = "llvm.extractelement"(%arg0, %4) : (vector<8xi64>, i64) -> i64
  %20 = "llvm.extractelement"(%arg0, %5) : (vector<8xi64>, i64) -> i64
  %21 = "llvm.add"(%20, %6) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %22 = "llvm.ashr"(%21, %7) : (i64, i64) -> i64
  %23 = "llvm.and"(%21, %8) : (i64, i64) -> i64
  %24 = "llvm.mul"(%22, %9) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %25 = "llvm.add"(%24, %15) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %26 = "llvm.ashr"(%25, %10) : (i64, i64) -> i64
  %27 = "llvm.and"(%25, %11) : (i64, i64) -> i64
  %28 = "llvm.add"(%26, %16) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %29 = "llvm.ashr"(%28, %10) : (i64, i64) -> i64
  %30 = "llvm.and"(%28, %11) : (i64, i64) -> i64
  %31 = "llvm.add"(%29, %17) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %32 = "llvm.ashr"(%31, %10) : (i64, i64) -> i64
  %33 = "llvm.and"(%31, %11) : (i64, i64) -> i64
  %34 = "llvm.add"(%32, %18) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %35 = "llvm.ashr"(%34, %10) : (i64, i64) -> i64
  %36 = "llvm.and"(%34, %11) : (i64, i64) -> i64
  %37 = "llvm.add"(%35, %19) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %38 = "llvm.ashr"(%37, %10) : (i64, i64) -> i64
  %39 = "llvm.and"(%37, %11) : (i64, i64) -> i64
  %40 = "llvm.add"(%27, %9) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %41 = "llvm.lshr"(%40, %10) : (i64, i64) -> i64
  %42 = "llvm.and"(%40, %11) : (i64, i64) -> i64
  %43 = "llvm.add"(%30, %41) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %44 = "llvm.lshr"(%43, %10) : (i64, i64) -> i64
  %45 = "llvm.and"(%43, %11) : (i64, i64) -> i64
  %46 = "llvm.add"(%33, %44) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %47 = "llvm.lshr"(%46, %10) : (i64, i64) -> i64
  %48 = "llvm.and"(%46, %11) : (i64, i64) -> i64
  %49 = "llvm.add"(%36, %47) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %50 = "llvm.lshr"(%49, %10) : (i64, i64) -> i64
  %51 = "llvm.and"(%49, %11) : (i64, i64) -> i64
  %52 = "llvm.add"(%39, %50) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %53 = "llvm.lshr"(%52, %10) : (i64, i64) -> i64
  %54 = "llvm.and"(%52, %11) : (i64, i64) -> i64
  %55 = "llvm.add"(%23, %12) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %56 = "llvm.add"(%55, %38) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %57 = "llvm.add"(%56, %53) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %58 = "llvm.and"(%57, %8) : (i64, i64) -> i64
  %59 = "llvm.icmp"(%57, %13) <{predicate = 6 : i64}> : (i64, i64) -> i1
  %60 = "llvm.select"(%59, %14, %0) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %61 = "llvm.add"(%60, %42) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %62 = "llvm.ashr"(%61, %10) : (i64, i64) -> i64
  %63 = "llvm.add"(%62, %45) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %64 = "llvm.ashr"(%63, %10) : (i64, i64) -> i64
  %65 = "llvm.add"(%64, %48) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %66 = "llvm.ashr"(%65, %10) : (i64, i64) -> i64
  %67 = "llvm.add"(%66, %51) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %68 = "llvm.ashr"(%67, %10) : (i64, i64) -> i64
  %69 = "llvm.add"(%68, %54) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %70 = "llvm.ashr"(%69, %10) : (i64, i64) -> i64
  %71 = "llvm.add"(%70, %58) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %72 = "llvm.or"(%63, %61) : (i64, i64) -> i64
  %73 = "llvm.or"(%72, %65) : (i64, i64) -> i64
  %74 = "llvm.or"(%73, %67) : (i64, i64) -> i64
  %75 = "llvm.or"(%74, %69) : (i64, i64) -> i64
  %76 = "llvm.and"(%75, %11) : (i64, i64) -> i64
  %77 = "llvm.or"(%76, %71) : (i64, i64) -> i64
  %78 = "llvm.icmp"(%77, %0) <{predicate = 1 : i64}> : (i64, i64) -> i1
  %79 = "llvm.zext"(%78) : (i1) -> i32
  "llvm.return"(%79) : (i32) -> ()
}) : () -> ()

end

end Firedancer.LaneNI.Mlir
