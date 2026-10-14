
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab



namespace Firedancer.Lane.Mlir

@[expose] public section

mlir_def fd_r43x6_repsqr_mul2 := "llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef, llvm.writeonly}, {llvm.noundef}, {llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.writeonly}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef, llvm.range = #llvm.constant_range<i64, 0, 101>}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, vector<8xi64>, vector<8xi64>, ptr, vector<8xi64>, vector<8xi64>, i64)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], sym_name = "fd_r43x6_repsqr_mul2", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr, %arg1: vector<8xi64>, %arg2: vector<8xi64>, %arg3: !llvm.ptr, %arg4: vector<8xi64>, %arg5: vector<8xi64>, %arg6: i64):
  %0 = "llvm.mlir.constant"() <{value = dense<[19, 1, 1, 1, 1, 1, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %1 = "llvm.mlir.constant"() <{value = dense<[43, 43, 43, 43, 43, 40, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %2 = "llvm.mlir.constant"() <{value = dense<[8796093022207, 8796093022207, 8796093022207, 8796093022207, 8796093022207, 1099511627775, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %3 = "llvm.mlir.constant"() <{value = dense<24> : vector<8xi64>}> : () -> vector<8xi64>
  %4 = "llvm.mlir.constant"() <{value = dense<7> : vector<8xi64>}> : () -> vector<8xi64>
  %5 = "llvm.mlir.constant"() <{value = dense<[-1, -1, -1, -1, -1, -1, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %6 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %7 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %8 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %9 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %10 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %11 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %12 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %13 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %14 = "llvm.mlir.poison"() : () -> vector<8xi64>
  %15 = "llvm.mlir.constant"() <{value = dense<[0, 1, 1, 1, 1, 1, 0, 1]> : vector<8xi64>}> : () -> vector<8xi64>
  %16 = "llvm.mlir.constant"() <{value = dense<[0, 1, 0, 1, 1, 1, 1, 1]> : vector<8xi64>}> : () -> vector<8xi64>
  %17 = "llvm.mlir.constant"() <{value = dense<[1, 1, 0, 1, 0, 1, 1, 1]> : vector<8xi64>}> : () -> vector<8xi64>
  %18 = "llvm.mlir.constant"() <{value = dense<0> : vector<8xi64>}> : () -> vector<8xi64>
  %19 = "llvm.mlir.constant"() <{value = dense<9> : vector<8xi64>}> : () -> vector<8xi64>
  %20 = "llvm.mlir.constant"() <{value = dense<[0, 0, -1, -1, -1, -1, -1, -1]> : vector<8xi64>}> : () -> vector<8xi64>
  %21 = "llvm.mlir.constant"() <{value = dense<[0, -1, 0, -1, -1, -1, -1, -1]> : vector<8xi64>}> : () -> vector<8xi64>
  %22 = "llvm.mlir.poison"() : () -> i64
  %23 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %24 = "llvm.mlir.undef"() : () -> vector<8xi64>
  %25 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %26 = "llvm.insertelement"(%24, %23, %25) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %27 = "llvm.insertelement"(%26, %23, %12) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %28 = "llvm.insertelement"(%27, %13, %11) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %29 = "llvm.insertelement"(%28, %13, %10) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %30 = "llvm.insertelement"(%29, %13, %9) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %31 = "llvm.insertelement"(%30, %13, %8) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %32 = "llvm.insertelement"(%31, %22, %7) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %33 = "llvm.insertelement"(%32, %22, %6) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %34 = "llvm.insertelement"(%24, %23, %25) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %35 = "llvm.insertelement"(%34, %13, %12) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %36 = "llvm.insertelement"(%35, %23, %11) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %37 = "llvm.insertelement"(%36, %13, %10) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %38 = "llvm.insertelement"(%37, %13, %9) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %39 = "llvm.insertelement"(%38, %13, %8) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %40 = "llvm.insertelement"(%39, %22, %7) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %41 = "llvm.insertelement"(%40, %22, %6) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %42 = "llvm.insertelement"(%24, %23, %25) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %43 = "llvm.insertelement"(%42, %23, %12) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %44 = "llvm.insertelement"(%43, %13, %11) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %45 = "llvm.insertelement"(%44, %13, %10) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %46 = "llvm.insertelement"(%45, %13, %9) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %47 = "llvm.insertelement"(%46, %22, %8) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %48 = "llvm.insertelement"(%47, %22, %7) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %49 = "llvm.insertelement"(%48, %22, %6) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %50 = "llvm.insertelement"(%24, %23, %25) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %51 = "llvm.insertelement"(%50, %13, %12) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %52 = "llvm.insertelement"(%51, %23, %11) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %53 = "llvm.insertelement"(%52, %13, %10) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %54 = "llvm.insertelement"(%53, %13, %9) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %55 = "llvm.insertelement"(%54, %22, %8) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %56 = "llvm.insertelement"(%55, %22, %7) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %57 = "llvm.insertelement"(%56, %22, %6) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %58 = "llvm.insertelement"(%24, %22, %25) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %59 = "llvm.insertelement"(%58, %22, %12) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %60 = "llvm.insertelement"(%59, %22, %11) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %61 = "llvm.insertelement"(%60, %22, %10) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %62 = "llvm.insertelement"(%61, %22, %9) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %63 = "llvm.insertelement"(%62, %22, %8) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %64 = "llvm.insertelement"(%63, %22, %7) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %65 = "llvm.insertelement"(%64, %13, %6) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %66 = "llvm.insertelement"(%24, %13, %25) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %67 = "llvm.insertelement"(%66, %13, %12) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %68 = "llvm.insertelement"(%67, %13, %11) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %69 = "llvm.insertelement"(%68, %13, %10) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %70 = "llvm.insertelement"(%69, %13, %9) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %71 = "llvm.insertelement"(%70, %22, %8) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %72 = "llvm.insertelement"(%71, %22, %7) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %73 = "llvm.insertelement"(%72, %22, %6) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %74 = "llvm.insertelement"(%24, %22, %25) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %75 = "llvm.insertelement"(%74, %22, %12) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %76 = "llvm.insertelement"(%75, %22, %11) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %77 = "llvm.insertelement"(%76, %22, %10) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %78 = "llvm.insertelement"(%77, %22, %9) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %79 = "llvm.insertelement"(%78, %22, %8) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %80 = "llvm.insertelement"(%79, %13, %7) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %81 = "llvm.insertelement"(%80, %13, %6) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %82 = "llvm.insertelement"(%24, %22, %25) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %83 = "llvm.insertelement"(%82, %22, %12) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %84 = "llvm.insertelement"(%83, %22, %11) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %85 = "llvm.insertelement"(%84, %22, %10) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %86 = "llvm.insertelement"(%85, %22, %9) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %87 = "llvm.insertelement"(%86, %13, %8) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %88 = "llvm.insertelement"(%87, %13, %7) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %89 = "llvm.insertelement"(%88, %13, %6) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %90 = "llvm.insertelement"(%24, %13, %25) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %91 = "llvm.insertelement"(%90, %13, %12) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %92 = "llvm.insertelement"(%91, %13, %11) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %93 = "llvm.insertelement"(%92, %22, %10) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %94 = "llvm.insertelement"(%93, %22, %9) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %95 = "llvm.insertelement"(%94, %22, %8) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %96 = "llvm.insertelement"(%95, %22, %7) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %97 = "llvm.insertelement"(%96, %22, %6) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %98 = "llvm.insertelement"(%24, %22, %25) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %99 = "llvm.insertelement"(%98, %22, %12) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %100 = "llvm.insertelement"(%99, %22, %11) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %101 = "llvm.insertelement"(%100, %22, %10) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %102 = "llvm.insertelement"(%101, %13, %9) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %103 = "llvm.insertelement"(%102, %13, %8) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %104 = "llvm.insertelement"(%103, %13, %7) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %105 = "llvm.insertelement"(%104, %13, %6) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %106 = "llvm.insertelement"(%24, %13, %25) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %107 = "llvm.insertelement"(%106, %13, %12) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %108 = "llvm.insertelement"(%107, %22, %11) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %109 = "llvm.insertelement"(%108, %22, %10) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %110 = "llvm.insertelement"(%109, %22, %9) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %111 = "llvm.insertelement"(%110, %22, %8) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %112 = "llvm.insertelement"(%111, %22, %7) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %113 = "llvm.insertelement"(%112, %22, %6) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %114 = "llvm.insertelement"(%24, %22, %25) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %115 = "llvm.insertelement"(%114, %22, %12) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %116 = "llvm.insertelement"(%115, %22, %11) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %117 = "llvm.insertelement"(%116, %13, %10) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %118 = "llvm.insertelement"(%117, %13, %9) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %119 = "llvm.insertelement"(%118, %13, %8) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %120 = "llvm.insertelement"(%119, %13, %7) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %121 = "llvm.insertelement"(%120, %13, %6) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %122 = "llvm.insertelement"(%24, %13, %25) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %123 = "llvm.insertelement"(%122, %22, %12) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %124 = "llvm.insertelement"(%123, %22, %11) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %125 = "llvm.insertelement"(%124, %22, %10) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %126 = "llvm.insertelement"(%125, %22, %9) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %127 = "llvm.insertelement"(%126, %22, %8) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %128 = "llvm.insertelement"(%127, %22, %7) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %129 = "llvm.insertelement"(%128, %22, %6) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %130 = "llvm.insertelement"(%24, %22, %25) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %131 = "llvm.insertelement"(%130, %22, %12) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %132 = "llvm.insertelement"(%131, %13, %11) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %133 = "llvm.insertelement"(%132, %13, %10) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %134 = "llvm.insertelement"(%133, %13, %9) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %135 = "llvm.insertelement"(%134, %13, %8) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %136 = "llvm.insertelement"(%135, %13, %7) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %137 = "llvm.insertelement"(%136, %13, %6) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %138 = "llvm.icmp"(%arg6, %13) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%138, %arg4, %arg1, %arg1, %arg4, %arg6)[^bb2, ^bb1] <{operandSegmentSizes = array<i32: 1, 2, 3>}> : (i1, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, i64) -> ()
^bb1(%139: vector<8xi64>, %140: vector<8xi64>, %141: i64):  // 2 preds: ^bb0, ^bb1
  %142 = "llvm.shufflevector"(%139, %14) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %143 = "llvm.shufflevector"(%139, %14) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 3, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %144 = "llvm.shufflevector"(%139, %14) <{mask = array<i32: 4, 4, 1, 1, 1, 1, 1, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %145 = "llvm.shufflevector"(%139, %14) <{mask = array<i32: 4, 5, 1, 2, 3, 4, 5, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %146 = "llvm.shufflevector"(%139, %14) <{mask = array<i32: 3, 7, 5, 7, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %147 = "llvm.shufflevector"(%139, %14) <{mask = array<i32: 5, 7, 5, 7, 2, 3, 4, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %148 = "llvm.shl"(%142, %15) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %149 = "llvm.shl"(%144, %16) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %150 = "llvm.shl"(%146, %17) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %151 = "llvm.call_intrinsic"(%18, %149, %145) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %152 = "llvm.call_intrinsic"(%18, %150, %147) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %153 = "llvm.call_intrinsic"(%18, %148, %143) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %154 = "llvm.shl"(%153, %19) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %155 = "llvm.call_intrinsic"(%18, %149, %145) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %156 = "llvm.shl"(%155, %19) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %157 = "llvm.call_intrinsic"(%18, %150, %147) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %158 = "llvm.shl"(%157, %19) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %159 = "llvm.and"(%151, %20) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %160 = "llvm.and"(%152, %21) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %161 = "llvm.add"(%160, %159) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %162 = "llvm.call_intrinsic"(%161, %148, %143) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %163 = "llvm.and"(%156, %20) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %164 = "llvm.and"(%158, %21) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %165 = "llvm.add"(%163, %154) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %166 = "llvm.add"(%165, %164) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %167 = "llvm.and"(%151, %33) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %168 = "llvm.and"(%152, %41) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %169 = "llvm.and"(%156, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %170 = "llvm.and"(%158, %57) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %171 = "llvm.add"(%170, %169) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %172 = "llvm.shufflevector"(%65, %166) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %173 = "llvm.add"(%172, %162) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %174 = "llvm.shufflevector"(%65, %171) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %175 = "llvm.shufflevector"(%166, %73) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %176 = "llvm.add"(%168, %167) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %177 = "llvm.add"(%176, %174) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %178 = "llvm.add"(%177, %175) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %179 = "llvm.and"(%173, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %180 = "llvm.shufflevector"(%173, %178) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %181 = "llvm.shl"(%180, %4) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %182 = "llvm.add"(%181, %179) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %183 = "llvm.mul"(%180, %3) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %184 = "llvm.add"(%182, %183) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %185 = "llvm.and"(%184, %2) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %186 = "llvm.lshr"(%184, %1) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %187 = "llvm.shufflevector"(%186, %14) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %188 = "llvm.call_intrinsic"(%185, %0, %187) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %189 = "llvm.shufflevector"(%140, %14) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %190 = "llvm.shufflevector"(%140, %14) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 3, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %191 = "llvm.shufflevector"(%140, %14) <{mask = array<i32: 4, 4, 1, 1, 1, 1, 1, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %192 = "llvm.shufflevector"(%140, %14) <{mask = array<i32: 4, 5, 1, 2, 3, 4, 5, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %193 = "llvm.shufflevector"(%140, %14) <{mask = array<i32: 3, 7, 5, 7, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %194 = "llvm.shufflevector"(%140, %14) <{mask = array<i32: 5, 7, 5, 7, 2, 3, 4, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %195 = "llvm.shl"(%189, %15) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %196 = "llvm.shl"(%191, %16) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %197 = "llvm.shl"(%193, %17) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %198 = "llvm.call_intrinsic"(%18, %196, %192) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %199 = "llvm.call_intrinsic"(%18, %197, %194) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %200 = "llvm.call_intrinsic"(%18, %195, %190) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %201 = "llvm.shl"(%200, %19) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %202 = "llvm.call_intrinsic"(%18, %196, %192) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %203 = "llvm.shl"(%202, %19) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %204 = "llvm.call_intrinsic"(%18, %197, %194) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %205 = "llvm.shl"(%204, %19) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %206 = "llvm.and"(%198, %20) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %207 = "llvm.and"(%199, %21) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %208 = "llvm.add"(%207, %206) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %209 = "llvm.call_intrinsic"(%208, %195, %190) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %210 = "llvm.and"(%203, %20) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %211 = "llvm.and"(%205, %21) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %212 = "llvm.add"(%210, %201) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %213 = "llvm.add"(%212, %211) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %214 = "llvm.and"(%198, %33) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %215 = "llvm.and"(%199, %41) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %216 = "llvm.and"(%203, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %217 = "llvm.and"(%205, %57) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %218 = "llvm.add"(%217, %216) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %219 = "llvm.shufflevector"(%65, %213) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %220 = "llvm.add"(%219, %209) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %221 = "llvm.shufflevector"(%65, %218) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %222 = "llvm.shufflevector"(%213, %73) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %223 = "llvm.add"(%215, %214) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %224 = "llvm.add"(%223, %221) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %225 = "llvm.add"(%224, %222) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %226 = "llvm.and"(%220, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %227 = "llvm.shufflevector"(%220, %225) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %228 = "llvm.shl"(%227, %4) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %229 = "llvm.add"(%228, %226) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %230 = "llvm.mul"(%227, %3) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %231 = "llvm.add"(%229, %230) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %232 = "llvm.and"(%231, %2) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %233 = "llvm.lshr"(%231, %1) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %234 = "llvm.shufflevector"(%233, %14) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %235 = "llvm.call_intrinsic"(%232, %0, %234) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %236 = "llvm.add"(%141, %23) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %237 = "llvm.icmp"(%236, %13) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%237, %235, %188, %188, %235, %236)[^bb2, ^bb1] <{loop_annotation = #llvm.loop_annotation<mustProgress = true>, operandSegmentSizes = array<i32: 1, 2, 3>}> : (i1, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, i64) -> ()
^bb2(%238: vector<8xi64>, %239: vector<8xi64>):  // 2 preds: ^bb0, ^bb1
  %240 = "llvm.shufflevector"(%239, %14) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %241 = "llvm.shufflevector"(%239, %14) <{mask = array<i32: 1, 1, 1, 1, 1, 1, 1, 1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %242 = "llvm.shufflevector"(%239, %14) <{mask = array<i32: 2, 2, 2, 2, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %243 = "llvm.shufflevector"(%239, %14) <{mask = array<i32: 3, 3, 3, 3, 3, 3, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %244 = "llvm.shufflevector"(%239, %14) <{mask = array<i32: 4, 4, 4, 4, 4, 4, 4, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %245 = "llvm.shufflevector"(%239, %14) <{mask = array<i32: 5, 5, 5, 5, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %246 = "llvm.call_intrinsic"(%18, %240, %arg2) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %247 = "llvm.shl"(%246, %19) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %248 = "llvm.call_intrinsic"(%247, %241, %arg2) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %249 = "llvm.call_intrinsic"(%18, %241, %arg2) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %250 = "llvm.shl"(%249, %19) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %251 = "llvm.call_intrinsic"(%250, %242, %arg2) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %252 = "llvm.call_intrinsic"(%18, %242, %arg2) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %253 = "llvm.shl"(%252, %19) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %254 = "llvm.call_intrinsic"(%253, %243, %arg2) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %255 = "llvm.call_intrinsic"(%18, %243, %arg2) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %256 = "llvm.shl"(%255, %19) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %257 = "llvm.call_intrinsic"(%256, %244, %arg2) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %258 = "llvm.call_intrinsic"(%18, %244, %arg2) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %259 = "llvm.shl"(%258, %19) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %260 = "llvm.call_intrinsic"(%259, %245, %arg2) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %261 = "llvm.call_intrinsic"(%18, %245, %arg2) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %262 = "llvm.shl"(%261, %19) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %263 = "llvm.shufflevector"(%65, %248) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %264 = "llvm.shufflevector"(%81, %251) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %265 = "llvm.shufflevector"(%89, %254) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %266 = "llvm.shufflevector"(%254, %97) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %267 = "llvm.shufflevector"(%105, %257) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %268 = "llvm.shufflevector"(%257, %113) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %269 = "llvm.shufflevector"(%121, %260) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %270 = "llvm.shufflevector"(%260, %129) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %271 = "llvm.shufflevector"(%137, %262) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %272 = "llvm.shufflevector"(%262, %14) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %273 = "llvm.call_intrinsic"(%263, %240, %arg2) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %274 = "llvm.add"(%265, %264) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %275 = "llvm.add"(%274, %267) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %276 = "llvm.add"(%275, %269) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %277 = "llvm.add"(%276, %273) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %278 = "llvm.add"(%277, %271) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %279 = "llvm.add"(%268, %266) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %280 = "llvm.add"(%279, %270) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %281 = "llvm.add"(%280, %272) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %282 = "llvm.and"(%278, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %283 = "llvm.shufflevector"(%278, %281) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %284 = "llvm.shl"(%283, %4) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %285 = "llvm.add"(%284, %282) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %286 = "llvm.mul"(%283, %3) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %287 = "llvm.add"(%285, %286) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %288 = "llvm.and"(%287, %2) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %289 = "llvm.lshr"(%287, %1) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %290 = "llvm.shufflevector"(%289, %14) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %291 = "llvm.call_intrinsic"(%288, %0, %290) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %292 = "llvm.shufflevector"(%238, %14) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %293 = "llvm.shufflevector"(%238, %14) <{mask = array<i32: 1, 1, 1, 1, 1, 1, 1, 1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %294 = "llvm.shufflevector"(%238, %14) <{mask = array<i32: 2, 2, 2, 2, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %295 = "llvm.shufflevector"(%238, %14) <{mask = array<i32: 3, 3, 3, 3, 3, 3, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %296 = "llvm.shufflevector"(%238, %14) <{mask = array<i32: 4, 4, 4, 4, 4, 4, 4, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %297 = "llvm.shufflevector"(%238, %14) <{mask = array<i32: 5, 5, 5, 5, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %298 = "llvm.call_intrinsic"(%18, %292, %arg5) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %299 = "llvm.shl"(%298, %19) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %300 = "llvm.call_intrinsic"(%299, %293, %arg5) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %301 = "llvm.call_intrinsic"(%18, %293, %arg5) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %302 = "llvm.shl"(%301, %19) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %303 = "llvm.call_intrinsic"(%302, %294, %arg5) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %304 = "llvm.call_intrinsic"(%18, %294, %arg5) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %305 = "llvm.shl"(%304, %19) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %306 = "llvm.call_intrinsic"(%305, %295, %arg5) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %307 = "llvm.call_intrinsic"(%18, %295, %arg5) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %308 = "llvm.shl"(%307, %19) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %309 = "llvm.call_intrinsic"(%308, %296, %arg5) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %310 = "llvm.call_intrinsic"(%18, %296, %arg5) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %311 = "llvm.shl"(%310, %19) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %312 = "llvm.call_intrinsic"(%311, %297, %arg5) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %313 = "llvm.call_intrinsic"(%18, %297, %arg5) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %314 = "llvm.shl"(%313, %19) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %315 = "llvm.shufflevector"(%65, %300) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %316 = "llvm.shufflevector"(%81, %303) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %317 = "llvm.shufflevector"(%89, %306) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %318 = "llvm.shufflevector"(%306, %97) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %319 = "llvm.shufflevector"(%105, %309) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %320 = "llvm.shufflevector"(%309, %113) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %321 = "llvm.shufflevector"(%121, %312) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %322 = "llvm.shufflevector"(%312, %129) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %323 = "llvm.shufflevector"(%137, %314) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %324 = "llvm.shufflevector"(%314, %14) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %325 = "llvm.call_intrinsic"(%315, %292, %arg5) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %326 = "llvm.add"(%317, %316) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %327 = "llvm.add"(%326, %319) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %328 = "llvm.add"(%327, %321) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %329 = "llvm.add"(%328, %325) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %330 = "llvm.add"(%329, %323) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %331 = "llvm.add"(%320, %318) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %332 = "llvm.add"(%331, %322) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %333 = "llvm.add"(%332, %324) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %334 = "llvm.and"(%330, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %335 = "llvm.shufflevector"(%330, %333) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %336 = "llvm.shl"(%335, %4) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %337 = "llvm.add"(%336, %334) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %338 = "llvm.mul"(%335, %3) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %339 = "llvm.add"(%337, %338) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %340 = "llvm.and"(%339, %2) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %341 = "llvm.lshr"(%339, %1) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %342 = "llvm.shufflevector"(%341, %14) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %343 = "llvm.call_intrinsic"(%340, %0, %342) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%291, %arg0) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%343, %arg3) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end Firedancer.Lane.Mlir
