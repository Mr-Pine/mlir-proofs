
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.LaneNI.Mlir.fd_r43x6_invert
public import Firedancer.LaneNI.Mlir.fd_r43x6_mul_fast
public import Firedancer.LaneNI.Mlir.fd_r43x6_mul_fast
public import Firedancer.LaneNI.Mlir.fd_r43x6_pack_18

namespace Firedancer.LaneNI.Mlir

@[expose] public section

mlir_def fd_r43x6_ge_encode := "llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<vector<4xi64> (vector<8xi64>, vector<8xi64>, vector<8xi64>)>, linkage = #llvm.linkage<external>, no_inline, no_unwind, passthrough = ["sspstrong", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], sym_name = "fd_r43x6_ge_encode", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: vector<8xi64>, %arg1: vector<8xi64>, %arg2: vector<8xi64>):
  %0 = "llvm.mlir.undef"() : () -> vector<2xi64>
  %1 = "llvm.mlir.poison"() : () -> vector<2xi64>
  %2 = "llvm.mlir.constant"() <{value = 1099511627776 : i64}> : () -> i64
  %3 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
  %4 = "llvm.mlir.constant"() <{value = dense<8796093022207> : vector<4xi64>}> : () -> vector<4xi64>
  %5 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %6 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %7 = "llvm.mlir.poison"() : () -> vector<4xi64>
  %8 = "llvm.mlir.constant"() <{value = 43 : i64}> : () -> i64
  %9 = "llvm.mlir.constant"() <{value = -19 : i64}> : () -> i64
  %10 = "llvm.mlir.constant"() <{value = 1099511627775 : i64}> : () -> i64
  %11 = "llvm.mlir.constant"() <{value = 8796093022207 : i64}> : () -> i64
  %12 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %13 = "llvm.mlir.constant"() <{value = dense<1099511627776> : vector<2xi64>}> : () -> vector<2xi64>
  %14 = "llvm.mlir.constant"() <{value = dense<8796093022207> : vector<2xi64>}> : () -> vector<2xi64>
  %15 = "llvm.mlir.constant"() <{value = dense<43> : vector<2xi64>}> : () -> vector<2xi64>
  %16 = "llvm.mlir.constant"() <{value = dense<1099511627775> : vector<2xi64>}> : () -> vector<2xi64>
  %17 = "llvm.mlir.constant"() <{value = dense<19> : vector<2xi64>}> : () -> vector<2xi64>
  %18 = "llvm.mlir.constant"() <{value = dense<40> : vector<2xi64>}> : () -> vector<2xi64>
  %19 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %20 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %21 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %22 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %23 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %24 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %25 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %26 = "llvm.mlir.poison"() : () -> i64
  %27 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %28 = "llvm.mlir.undef"() : () -> vector<8xi64>
  %29 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %30 = "llvm.insertelement"(%28, %27, %29) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %31 = "llvm.insertelement"(%30, %26, %25) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %32 = "llvm.insertelement"(%31, %27, %24) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %33 = "llvm.insertelement"(%32, %26, %23) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %34 = "llvm.insertelement"(%33, %27, %22) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %35 = "llvm.insertelement"(%34, %26, %21) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %36 = "llvm.insertelement"(%35, %27, %20) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %37 = "llvm.insertelement"(%36, %26, %19) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %38 = "llvm.insertelement"(%28, %26, %29) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %39 = "llvm.insertelement"(%38, %27, %25) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %40 = "llvm.insertelement"(%39, %26, %24) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %41 = "llvm.insertelement"(%40, %26, %23) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %42 = "llvm.insertelement"(%41, %26, %22) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %43 = "llvm.insertelement"(%42, %26, %21) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %44 = "llvm.insertelement"(%43, %26, %20) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %45 = "llvm.insertelement"(%44, %26, %19) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %46 = "llvm.insertelement"(%0, %11, %29) : (vector<2xi64>, i64, i32) -> vector<2xi64>
  %47 = "llvm.insertelement"(%46, %26, %25) : (vector<2xi64>, i64, i32) -> vector<2xi64>
  %48 = "llvm.insertelement"(%28, %26, %29) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %49 = "llvm.insertelement"(%48, %26, %25) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %50 = "llvm.insertelement"(%49, %26, %24) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %51 = "llvm.insertelement"(%50, %26, %23) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %52 = "llvm.insertelement"(%51, %26, %22) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %53 = "llvm.insertelement"(%52, %26, %21) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %54 = "llvm.insertelement"(%53, %27, %20) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %55 = "llvm.insertelement"(%54, %27, %19) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %56 = "llvm.shufflevector"(%arg0, %arg1) <{mask = array<i32: 0, 8, 2, 10, 4, 12, 6, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %57 = "llvm.shufflevector"(%arg0, %arg1) <{mask = array<i32: 1, 9, -1, -1, 5, 13, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %58 = "llvm.shufflevector"(%arg2, %37) <{mask = array<i32: 0, 8, 2, 10, 4, 12, 6, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %59 = "llvm.shufflevector"(%arg2, %45) <{mask = array<i32: 1, 9, -1, -1, 5, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %60 = "llvm.shufflevector"(%56, %58) <{mask = array<i32: 0, 1, 8, 4, 5, 12, 9, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %61 = "llvm.shufflevector"(%57, %59) <{mask = array<i32: 0, 1, 8, 4, 5, 12, 9, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %62 = "llvm.shufflevector"(%56, %58) <{mask = array<i32: 2, 3, 10, 6, 7, 14, 9, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %63 = "llvm.call"(%62) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_invert, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> vector<8xi64>
  %64 = "llvm.call"(%60, %63) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %65 = "llvm.call"(%61, %63) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %66 = "llvm.shufflevector"(%65, %64) <{mask = array<i32: 5, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<2xi64>
  %67 = "llvm.ashr"(%66, %18) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %68 = "llvm.mul"(%67, %17) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %69 = "llvm.and"(%66, %16) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %70 = "llvm.shufflevector"(%65, %64) <{mask = array<i32: 0, 8>}> : (vector<8xi64>, vector<8xi64>) -> vector<2xi64>
  %71 = "llvm.add"(%68, %70) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %72 = "llvm.ashr"(%71, %15) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %73 = "llvm.and"(%71, %14) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %74 = "llvm.shufflevector"(%65, %64) <{mask = array<i32: 1, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<2xi64>
  %75 = "llvm.add"(%72, %74) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %76 = "llvm.ashr"(%75, %15) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %77 = "llvm.and"(%75, %14) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %78 = "llvm.shufflevector"(%65, %64) <{mask = array<i32: 2, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<2xi64>
  %79 = "llvm.add"(%76, %78) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %80 = "llvm.ashr"(%79, %15) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %81 = "llvm.and"(%79, %14) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %82 = "llvm.shufflevector"(%65, %64) <{mask = array<i32: 3, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<2xi64>
  %83 = "llvm.add"(%80, %82) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %84 = "llvm.ashr"(%83, %15) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %85 = "llvm.and"(%83, %14) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %86 = "llvm.shufflevector"(%65, %64) <{mask = array<i32: 4, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<2xi64>
  %87 = "llvm.add"(%84, %86) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %88 = "llvm.ashr"(%87, %15) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %89 = "llvm.and"(%87, %14) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %90 = "llvm.add"(%88, %69) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %91 = "llvm.add"(%73, %17) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %92 = "llvm.lshr"(%91, %15) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %93 = "llvm.add"(%77, %92) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %94 = "llvm.lshr"(%93, %15) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %95 = "llvm.add"(%81, %94) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %96 = "llvm.lshr"(%95, %15) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %97 = "llvm.add"(%85, %96) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %98 = "llvm.lshr"(%97, %15) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %99 = "llvm.add"(%89, %98) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %100 = "llvm.lshr"(%99, %15) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %101 = "llvm.add"(%90, %100) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %102 = "llvm.icmp"(%101, %13) <{predicate = 2 : i64}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi1>
  %103 = "llvm.extractelement"(%102, %12) : (vector<2xi1>, i64) -> i1
  %104 = "llvm.extractelement"(%71, %12) : (vector<2xi64>, i64) -> i64
  %105 = "llvm.extractelement"(%91, %12) : (vector<2xi64>, i64) -> i64
  %106 = "llvm.select"(%103, %104, %105) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %107 = "llvm.extractelement"(%91, %27) : (vector<2xi64>, i64) -> i64
  %108 = "llvm.and"(%107, %11) : (i64, i64) -> i64
  %109 = "llvm.extractelement"(%93, %27) : (vector<2xi64>, i64) -> i64
  %110 = "llvm.and"(%109, %11) : (i64, i64) -> i64
  %111 = "llvm.extractelement"(%95, %27) : (vector<2xi64>, i64) -> i64
  %112 = "llvm.and"(%111, %11) : (i64, i64) -> i64
  %113 = "llvm.extractelement"(%97, %27) : (vector<2xi64>, i64) -> i64
  %114 = "llvm.and"(%113, %11) : (i64, i64) -> i64
  %115 = "llvm.extractelement"(%99, %27) : (vector<2xi64>, i64) -> i64
  %116 = "llvm.and"(%115, %11) : (i64, i64) -> i64
  %117 = "llvm.extractelement"(%101, %27) : (vector<2xi64>, i64) -> i64
  %118 = "llvm.and"(%117, %10) : (i64, i64) -> i64
  %119 = "llvm.extractelement"(%102, %27) : (vector<2xi1>, i64) -> i1
  %120 = "llvm.select"(%119, %9, %27) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %121 = "llvm.add"(%120, %108) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %122 = "llvm.ashr"(%121, %8) : (i64, i64) -> i64
  %123 = "llvm.add"(%122, %110) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %124 = "llvm.ashr"(%123, %8) : (i64, i64) -> i64
  %125 = "llvm.add"(%124, %112) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %126 = "llvm.ashr"(%125, %8) : (i64, i64) -> i64
  %127 = "llvm.add"(%126, %114) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %128 = "llvm.ashr"(%127, %8) : (i64, i64) -> i64
  %129 = "llvm.insertelement"(%7, %121, %27) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %130 = "llvm.insertelement"(%129, %123, %12) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %131 = "llvm.insertelement"(%130, %125, %6) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %132 = "llvm.insertelement"(%131, %127, %5) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %133 = "llvm.and"(%132, %4) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %134 = "llvm.shl"(%106, %3) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %135 = "llvm.and"(%134, %2) : (i64, i64) -> i64
  %136 = "llvm.add"(%128, %116) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %137 = "llvm.ashr"(%136, %8) : (i64, i64) -> i64
  %138 = "llvm.add"(%137, %118) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %139 = "llvm.insertelement"(%1, %136, %27) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  %140 = "llvm.insertelement"(%139, %138, %12) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  %141 = "llvm.insertelement"(%47, %135, %12) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  %142 = "llvm.and"(%140, %141) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %143 = "llvm.or"(%140, %141) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %144 = "llvm.shufflevector"(%133, %7) <{mask = array<i32: 0, 1, 2, 3, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %145 = "llvm.shufflevector"(%144, %55) <{mask = array<i32: 0, 1, 2, 3, -1, -1, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %146 = "llvm.shufflevector"(%142, %143) <{mask = array<i32: 0, 3, -1, -1, -1, -1, -1, -1>}> : (vector<2xi64>, vector<2xi64>) -> vector<8xi64>
  %147 = "llvm.shufflevector"(%145, %146) <{mask = array<i32: 0, 1, 2, 3, 8, 9, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %148 = "llvm.call"(%147) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_pack.18, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> vector<4xi64>
  "llvm.return"(%148) : (vector<4xi64>) -> ()
}) : () -> ()

    with
      @fd_r43x6_invert := Firedancer.LaneNI.Mlir.fd_r43x6_invert,
      @fd_r43x6_mul_fast := Firedancer.LaneNI.Mlir.fd_r43x6_mul_fast,
      @fd_r43x6_mul_fast := Firedancer.LaneNI.Mlir.fd_r43x6_mul_fast,
      @fd_r43x6_pack.18 := Firedancer.LaneNI.Mlir.fd_r43x6_pack_18

end

end Firedancer.LaneNI.Mlir
