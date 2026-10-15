
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab



namespace Firedancer.LaneNI.Mlir

@[expose] public section

mlir_def fd_r43x6_mod := "llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.noundef}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<vector<8xi64> (vector<8xi64>)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], res_attrs = [{llvm.range = #llvm.constant_range<i64, -1, 8796093022208>}], sym_name = "fd_r43x6_mod", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg0: vector<8xi64>):
  %0 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %1 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %2 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %3 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %4 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %5 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %6 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %7 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %8 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %9 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %10 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %11 = "llvm.mlir.constant"() <{value = 4 : i64}> : () -> i64
  %12 = "llvm.mlir.constant"() <{value = 5 : i64}> : () -> i64
  %13 = "llvm.mlir.constant"() <{value = 8796093022207 : i64}> : () -> i64
  %14 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
  %15 = "llvm.mlir.constant"() <{value = 43 : i64}> : () -> i64
  %16 = "llvm.mlir.constant"() <{value = 1099511627775 : i64}> : () -> i64
  %17 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %18 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %19 = "llvm.mlir.constant"() <{value = 1099511627776 : i64}> : () -> i64
  %20 = "llvm.mlir.constant"() <{value = -19 : i64}> : () -> i64
  %21 = "llvm.mlir.poison"() : () -> vector<4xi64>
  %22 = "llvm.mlir.constant"() <{value = dense<8796093022207> : vector<4xi64>}> : () -> vector<4xi64>
  %23 = "llvm.mlir.poison"() : () -> vector<2xi64>
  %24 = "llvm.mlir.constant"() <{value = dense<[8796093022207, -1]> : vector<2xi64>}> : () -> vector<2xi64>
  %25 = "llvm.mlir.poison"() : () -> i64
  %26 = "llvm.mlir.undef"() : () -> vector<8xi64>
  %27 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %28 = "llvm.insertelement"(%26, %25, %27) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %29 = "llvm.insertelement"(%28, %25, %6) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %30 = "llvm.insertelement"(%29, %25, %5) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %31 = "llvm.insertelement"(%30, %25, %4) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %32 = "llvm.insertelement"(%31, %25, %3) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %33 = "llvm.insertelement"(%32, %25, %2) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %34 = "llvm.insertelement"(%33, %7, %1) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %35 = "llvm.insertelement"(%34, %7, %0) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %36 = "llvm.extractelement"(%arg0, %7) : (vector<8xi64>, i64) -> i64
  %37 = "llvm.extractelement"(%arg0, %8) : (vector<8xi64>, i64) -> i64
  %38 = "llvm.extractelement"(%arg0, %9) : (vector<8xi64>, i64) -> i64
  %39 = "llvm.extractelement"(%arg0, %10) : (vector<8xi64>, i64) -> i64
  %40 = "llvm.extractelement"(%arg0, %11) : (vector<8xi64>, i64) -> i64
  %41 = "llvm.extractelement"(%arg0, %12) : (vector<8xi64>, i64) -> i64
  %42 = "llvm.and"(%36, %13) : (i64, i64) -> i64
  %43 = "llvm.ashr"(%41, %14) : (i64, i64) -> i64
  %44 = "llvm.and"(%37, %13) : (i64, i64) -> i64
  %45 = "llvm.ashr"(%36, %15) : (i64, i64) -> i64
  %46 = "llvm.add"(%44, %45) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %47 = "llvm.and"(%38, %13) : (i64, i64) -> i64
  %48 = "llvm.ashr"(%37, %15) : (i64, i64) -> i64
  %49 = "llvm.add"(%47, %48) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %50 = "llvm.and"(%39, %13) : (i64, i64) -> i64
  %51 = "llvm.ashr"(%38, %15) : (i64, i64) -> i64
  %52 = "llvm.add"(%50, %51) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %53 = "llvm.and"(%40, %13) : (i64, i64) -> i64
  %54 = "llvm.ashr"(%39, %15) : (i64, i64) -> i64
  %55 = "llvm.add"(%53, %54) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %56 = "llvm.and"(%41, %16) : (i64, i64) -> i64
  %57 = "llvm.ashr"(%40, %15) : (i64, i64) -> i64
  %58 = "llvm.add"(%57, %17) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %59 = "llvm.add"(%58, %56) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %60 = "llvm.ashr"(%59, %14) : (i64, i64) -> i64
  %61 = "llvm.and"(%59, %16) : (i64, i64) -> i64
  %62 = "llvm.add"(%60, %43) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %63 = "llvm.mul"(%62, %18) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %64 = "llvm.add"(%63, %42) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %65 = "llvm.ashr"(%64, %15) : (i64, i64) -> i64
  %66 = "llvm.and"(%64, %13) : (i64, i64) -> i64
  %67 = "llvm.add"(%46, %65) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %68 = "llvm.ashr"(%67, %15) : (i64, i64) -> i64
  %69 = "llvm.and"(%67, %13) : (i64, i64) -> i64
  %70 = "llvm.add"(%49, %68) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %71 = "llvm.ashr"(%70, %15) : (i64, i64) -> i64
  %72 = "llvm.and"(%70, %13) : (i64, i64) -> i64
  %73 = "llvm.add"(%52, %71) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %74 = "llvm.ashr"(%73, %15) : (i64, i64) -> i64
  %75 = "llvm.and"(%73, %13) : (i64, i64) -> i64
  %76 = "llvm.add"(%55, %74) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %77 = "llvm.ashr"(%76, %15) : (i64, i64) -> i64
  %78 = "llvm.and"(%76, %13) : (i64, i64) -> i64
  %79 = "llvm.add"(%66, %18) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %80 = "llvm.lshr"(%79, %15) : (i64, i64) -> i64
  %81 = "llvm.and"(%79, %13) : (i64, i64) -> i64
  %82 = "llvm.add"(%69, %80) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %83 = "llvm.lshr"(%82, %15) : (i64, i64) -> i64
  %84 = "llvm.and"(%82, %13) : (i64, i64) -> i64
  %85 = "llvm.add"(%72, %83) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %86 = "llvm.lshr"(%85, %15) : (i64, i64) -> i64
  %87 = "llvm.and"(%85, %13) : (i64, i64) -> i64
  %88 = "llvm.add"(%75, %86) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %89 = "llvm.lshr"(%88, %15) : (i64, i64) -> i64
  %90 = "llvm.and"(%88, %13) : (i64, i64) -> i64
  %91 = "llvm.add"(%78, %89) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %92 = "llvm.lshr"(%91, %15) : (i64, i64) -> i64
  %93 = "llvm.and"(%91, %13) : (i64, i64) -> i64
  %94 = "llvm.add"(%61, %8) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %95 = "llvm.add"(%94, %77) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %96 = "llvm.add"(%95, %92) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %97 = "llvm.and"(%96, %16) : (i64, i64) -> i64
  %98 = "llvm.icmp"(%96, %19) <{predicate = 6 : i64}> : (i64, i64) -> i1
  %99 = "llvm.select"(%98, %20, %7) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %100 = "llvm.add"(%99, %81) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %101 = "llvm.ashr"(%100, %15) : (i64, i64) -> i64
  %102 = "llvm.add"(%101, %84) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %103 = "llvm.ashr"(%102, %15) : (i64, i64) -> i64
  %104 = "llvm.add"(%103, %87) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %105 = "llvm.ashr"(%104, %15) : (i64, i64) -> i64
  %106 = "llvm.add"(%105, %90) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %107 = "llvm.ashr"(%106, %15) : (i64, i64) -> i64
  %108 = "llvm.insertelement"(%21, %100, %7) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %109 = "llvm.insertelement"(%108, %102, %8) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %110 = "llvm.insertelement"(%109, %104, %9) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %111 = "llvm.insertelement"(%110, %106, %10) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %112 = "llvm.and"(%111, %22) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %113 = "llvm.add"(%107, %93) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %114 = "llvm.ashr"(%113, %15) : (i64, i64) -> i64
  %115 = "llvm.add"(%114, %97) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %116 = "llvm.insertelement"(%23, %113, %7) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  %117 = "llvm.insertelement"(%116, %115, %8) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  %118 = "llvm.and"(%117, %24) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %119 = "llvm.shufflevector"(%112, %21) <{mask = array<i32: 0, 1, 2, 3, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %120 = "llvm.shufflevector"(%119, %35) <{mask = array<i32: 0, 1, 2, 3, -1, -1, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %121 = "llvm.shufflevector"(%118, %23) <{mask = array<i32: 0, 1, -1, -1, -1, -1, -1, -1>}> : (vector<2xi64>, vector<2xi64>) -> vector<8xi64>
  %122 = "llvm.shufflevector"(%120, %121) <{mask = array<i32: 0, 1, 2, 3, 8, 9, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.return"(%122) : (vector<8xi64>) -> ()
}) : () -> ()

end

end Firedancer.LaneNI.Mlir
