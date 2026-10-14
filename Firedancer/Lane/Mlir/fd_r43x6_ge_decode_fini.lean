
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.Lane.Mlir.fd_r43x6_ge_decode_step_slow

namespace Firedancer.Lane.Mlir

@[expose] public section

mlir_def fd_r43x6_ge_decode_fini := "llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.noundef}], frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<i32 (ptr, ptr, ptr, ptr)>, linkage = #llvm.linkage<external>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], res_attrs = [{llvm.range = #llvm.constant_range<i32, -1, 1>}], sym_name = "fd_r43x6_ge_decode_fini", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: !llvm.ptr, %arg3: !llvm.ptr):
  %0 = "llvm.mlir.constant"() <{value = dense<[8796093022207, 8796093022207, 8796093022207, 8796093022207, 1099511627775, 1099511627775, 1099511627775, 1099511627775]> : vector<8xi64>}> : () -> vector<8xi64>
  %1 = "llvm.mlir.constant"() <{value = dense<8796093022207> : vector<8xi64>}> : () -> vector<8xi64>
  %2 = "llvm.mlir.constant"() <{value = dense<[43, 43, 43, 43, 40, 40, 40, 40]> : vector<8xi64>}> : () -> vector<8xi64>
  %3 = "llvm.mlir.constant"() <{value = dense<43> : vector<8xi64>}> : () -> vector<8xi64>
  %4 = "llvm.mlir.constant"() <{value = dense<[159383552, 1048576, 1048576, 1048576, 1048576, 1048576, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %5 = "llvm.mlir.constant"() <{value = dense<[-1, 0, 0, 0, 0, 0, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %6 = "llvm.mlir.constant"() <{value = dense<18> : vector<8xi64>}> : () -> vector<8xi64>
  %7 = "llvm.mlir.constant"() <{value = dense<[8795933638637, 8796091973631, 8796091973631, 8796091973631, 8796091973631, 1099510579199, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %8 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
  %9 = "llvm.mlir.constant"() <{value = -19 : i64}> : () -> i64
  %10 = "llvm.mlir.constant"() <{value = 1099511627776 : i64}> : () -> i64
  %11 = "llvm.mlir.constant"() <{value = 1048576 : i64}> : () -> i64
  %12 = "llvm.mlir.constant"() <{value = 43 : i64}> : () -> i64
  %13 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %14 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
  %15 = "llvm.mlir.constant"() <{value = -1048576 : i64}> : () -> i64
  %16 = "llvm.mlir.constant"() <{value = 5 : i64}> : () -> i64
  %17 = "llvm.mlir.constant"() <{value = 4 : i64}> : () -> i64
  %18 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %19 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %20 = "llvm.mlir.constant"() <{value = dense<[3467281080496, 6582290652611, 5210002954932, 329084955603, 4526638806224, 373767602335, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %21 = "llvm.mlir.constant"() <{value = dense<[1, 0, 0, 0, 0, 0, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %22 = "llvm.mlir.constant"() <{value = true}> : () -> i1
  %23 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %24 = "llvm.mlir.constant"() <{value = dense<0> : vector<2xi64>}> : () -> vector<2xi64>
  %25 = "llvm.mlir.constant"() <{value = dense<-19> : vector<2xi64>}> : () -> vector<2xi64>
  %26 = "llvm.mlir.constant"() <{value = dense<1099511627776> : vector<2xi64>}> : () -> vector<2xi64>
  %27 = "llvm.mlir.constant"() <{value = dense<8796093022207> : vector<2xi64>}> : () -> vector<2xi64>
  %28 = "llvm.mlir.constant"() <{value = dense<43> : vector<2xi64>}> : () -> vector<2xi64>
  %29 = "llvm.mlir.constant"() <{value = dense<1048576> : vector<2xi64>}> : () -> vector<2xi64>
  %30 = "llvm.mlir.constant"() <{value = dense<19> : vector<2xi64>}> : () -> vector<2xi64>
  %31 = "llvm.mlir.constant"() <{value = dense<40> : vector<2xi64>}> : () -> vector<2xi64>
  %32 = "llvm.mlir.constant"() <{value = dense<1099511627775> : vector<2xi64>}> : () -> vector<2xi64>
  %33 = "llvm.mlir.constant"() <{value = dense<-1048576> : vector<2xi64>}> : () -> vector<2xi64>
  %34 = "llvm.mlir.constant"() <{value = 8796093022189 : i64}> : () -> i64
  %35 = "llvm.mlir.constant"() <{value = 8796093022207 : i64}> : () -> i64
  %36 = "llvm.mlir.constant"() <{value = 1099511627775 : i64}> : () -> i64
  %37 = "llvm.mlir.constant"() <{value = dense<[0, -1, 0, -1, -1, -1, -1, -1]> : vector<8xi64>}> : () -> vector<8xi64>
  %38 = "llvm.mlir.constant"() <{value = dense<[0, 0, -1, -1, -1, -1, -1, -1]> : vector<8xi64>}> : () -> vector<8xi64>
  %39 = "llvm.mlir.constant"() <{value = dense<[1, 1, 0, 1, 0, 1, 1, 1]> : vector<8xi64>}> : () -> vector<8xi64>
  %40 = "llvm.mlir.constant"() <{value = dense<[0, 1, 0, 1, 1, 1, 1, 1]> : vector<8xi64>}> : () -> vector<8xi64>
  %41 = "llvm.mlir.constant"() <{value = dense<[0, 1, 1, 1, 1, 1, 0, 1]> : vector<8xi64>}> : () -> vector<8xi64>
  %42 = "llvm.mlir.constant"() <{value = dense<[19, 1, 1, 1, 1, 1, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %43 = "llvm.mlir.constant"() <{value = dense<[43, 43, 43, 43, 43, 40, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %44 = "llvm.mlir.constant"() <{value = dense<[8796093022207, 8796093022207, 8796093022207, 8796093022207, 8796093022207, 1099511627775, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %45 = "llvm.mlir.constant"() <{value = dense<24> : vector<8xi64>}> : () -> vector<8xi64>
  %46 = "llvm.mlir.constant"() <{value = dense<7> : vector<8xi64>}> : () -> vector<8xi64>
  %47 = "llvm.mlir.constant"() <{value = dense<[-1, -1, -1, -1, -1, -1, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %48 = "llvm.mlir.poison"() : () -> vector<8xi64>
  %49 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %50 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %51 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %52 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %53 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %54 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %55 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %56 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %57 = "llvm.mlir.poison"() : () -> vector<6xi64>
  %58 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %59 = "llvm.mlir.constant"() <{value = dense<0> : vector<8xi64>}> : () -> vector<8xi64>
  %60 = "llvm.mlir.constant"() <{value = dense<9> : vector<8xi64>}> : () -> vector<8xi64>
  %61 = "llvm.mlir.poison"() : () -> i64
  %62 = "llvm.mlir.undef"() : () -> vector<8xi64>
  %63 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %64 = "llvm.insertelement"(%62, %61, %63) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %65 = "llvm.insertelement"(%64, %61, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %66 = "llvm.insertelement"(%65, %61, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %67 = "llvm.insertelement"(%66, %61, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %68 = "llvm.insertelement"(%67, %61, %52) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %69 = "llvm.insertelement"(%68, %61, %51) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %70 = "llvm.insertelement"(%69, %61, %50) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %71 = "llvm.insertelement"(%70, %58, %49) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %72 = "llvm.insertelement"(%62, %61, %63) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %73 = "llvm.insertelement"(%72, %61, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %74 = "llvm.insertelement"(%73, %61, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %75 = "llvm.insertelement"(%74, %61, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %76 = "llvm.insertelement"(%75, %61, %52) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %77 = "llvm.insertelement"(%76, %61, %51) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %78 = "llvm.insertelement"(%77, %58, %50) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %79 = "llvm.insertelement"(%78, %58, %49) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %80 = "llvm.insertelement"(%62, %61, %63) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %81 = "llvm.insertelement"(%80, %61, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %82 = "llvm.insertelement"(%81, %61, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %83 = "llvm.insertelement"(%82, %61, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %84 = "llvm.insertelement"(%83, %61, %52) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %85 = "llvm.insertelement"(%84, %58, %51) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %86 = "llvm.insertelement"(%85, %58, %50) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %87 = "llvm.insertelement"(%86, %58, %49) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %88 = "llvm.insertelement"(%62, %58, %63) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %89 = "llvm.insertelement"(%88, %58, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %90 = "llvm.insertelement"(%89, %58, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %91 = "llvm.insertelement"(%90, %61, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %92 = "llvm.insertelement"(%91, %61, %52) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %93 = "llvm.insertelement"(%92, %61, %51) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %94 = "llvm.insertelement"(%93, %61, %50) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %95 = "llvm.insertelement"(%94, %61, %49) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %96 = "llvm.insertelement"(%62, %61, %63) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %97 = "llvm.insertelement"(%96, %61, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %98 = "llvm.insertelement"(%97, %61, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %99 = "llvm.insertelement"(%98, %61, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %100 = "llvm.insertelement"(%99, %58, %52) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %101 = "llvm.insertelement"(%100, %58, %51) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %102 = "llvm.insertelement"(%101, %58, %50) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %103 = "llvm.insertelement"(%102, %58, %49) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %104 = "llvm.insertelement"(%62, %58, %63) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %105 = "llvm.insertelement"(%104, %58, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %106 = "llvm.insertelement"(%105, %61, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %107 = "llvm.insertelement"(%106, %61, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %108 = "llvm.insertelement"(%107, %61, %52) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %109 = "llvm.insertelement"(%108, %61, %51) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %110 = "llvm.insertelement"(%109, %61, %50) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %111 = "llvm.insertelement"(%110, %61, %49) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %112 = "llvm.insertelement"(%62, %61, %63) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %113 = "llvm.insertelement"(%112, %61, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %114 = "llvm.insertelement"(%113, %61, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %115 = "llvm.insertelement"(%114, %58, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %116 = "llvm.insertelement"(%115, %58, %52) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %117 = "llvm.insertelement"(%116, %58, %51) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %118 = "llvm.insertelement"(%117, %58, %50) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %119 = "llvm.insertelement"(%118, %58, %49) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %120 = "llvm.insertelement"(%62, %58, %63) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %121 = "llvm.insertelement"(%120, %61, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %122 = "llvm.insertelement"(%121, %61, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %123 = "llvm.insertelement"(%122, %61, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %124 = "llvm.insertelement"(%123, %61, %52) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %125 = "llvm.insertelement"(%124, %61, %51) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %126 = "llvm.insertelement"(%125, %61, %50) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %127 = "llvm.insertelement"(%126, %61, %49) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %128 = "llvm.insertelement"(%62, %61, %63) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %129 = "llvm.insertelement"(%128, %61, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %130 = "llvm.insertelement"(%129, %58, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %131 = "llvm.insertelement"(%130, %58, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %132 = "llvm.insertelement"(%131, %58, %52) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %133 = "llvm.insertelement"(%132, %58, %51) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %134 = "llvm.insertelement"(%133, %58, %50) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %135 = "llvm.insertelement"(%134, %58, %49) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %136 = "llvm.insertelement"(%62, %56, %63) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %137 = "llvm.insertelement"(%136, %56, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %138 = "llvm.insertelement"(%137, %58, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %139 = "llvm.insertelement"(%138, %58, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %140 = "llvm.insertelement"(%139, %58, %52) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %141 = "llvm.insertelement"(%140, %58, %51) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %142 = "llvm.insertelement"(%141, %61, %50) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %143 = "llvm.insertelement"(%142, %61, %49) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %144 = "llvm.insertelement"(%62, %56, %63) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %145 = "llvm.insertelement"(%144, %58, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %146 = "llvm.insertelement"(%145, %56, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %147 = "llvm.insertelement"(%146, %58, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %148 = "llvm.insertelement"(%147, %58, %52) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %149 = "llvm.insertelement"(%148, %58, %51) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %150 = "llvm.insertelement"(%149, %61, %50) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %151 = "llvm.insertelement"(%150, %61, %49) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %152 = "llvm.insertelement"(%62, %56, %63) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %153 = "llvm.insertelement"(%152, %56, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %154 = "llvm.insertelement"(%153, %58, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %155 = "llvm.insertelement"(%154, %58, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %156 = "llvm.insertelement"(%155, %58, %52) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %157 = "llvm.insertelement"(%156, %61, %51) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %158 = "llvm.insertelement"(%157, %61, %50) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %159 = "llvm.insertelement"(%158, %61, %49) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %160 = "llvm.insertelement"(%62, %56, %63) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %161 = "llvm.insertelement"(%160, %58, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %162 = "llvm.insertelement"(%161, %56, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %163 = "llvm.insertelement"(%162, %58, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %164 = "llvm.insertelement"(%163, %58, %52) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %165 = "llvm.insertelement"(%164, %61, %51) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %166 = "llvm.insertelement"(%165, %61, %50) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %167 = "llvm.insertelement"(%166, %61, %49) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %168 = "llvm.insertelement"(%62, %58, %63) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %169 = "llvm.insertelement"(%168, %58, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %170 = "llvm.insertelement"(%169, %58, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %171 = "llvm.insertelement"(%170, %58, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %172 = "llvm.insertelement"(%171, %58, %52) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %173 = "llvm.insertelement"(%172, %61, %51) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %174 = "llvm.insertelement"(%173, %61, %50) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %175 = "llvm.insertelement"(%174, %61, %49) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %176 = "llvm.insertelement"(%62, %34, %63) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %177 = "llvm.insertelement"(%176, %35, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %178 = "llvm.insertelement"(%177, %35, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %179 = "llvm.insertelement"(%178, %35, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %180 = "llvm.insertelement"(%179, %35, %52) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %181 = "llvm.insertelement"(%180, %36, %51) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %182 = "llvm.insertelement"(%181, %61, %50) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %183 = "llvm.insertelement"(%182, %61, %49) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %184 = "llvm.insertelement"(%62, %23, %63) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %185 = "llvm.insertelement"(%184, %58, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %186 = "llvm.insertelement"(%185, %61, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %187 = "llvm.insertelement"(%186, %61, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %188 = "llvm.insertelement"(%187, %58, %52) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %189 = "llvm.insertelement"(%188, %58, %51) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %190 = "llvm.insertelement"(%189, %61, %50) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %191 = "llvm.insertelement"(%190, %61, %49) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %192 = "llvm.insertelement"(%62, %61, %63) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %193 = "llvm.insertelement"(%192, %61, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %194 = "llvm.insertelement"(%193, %58, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %195 = "llvm.insertelement"(%194, %58, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %196 = "llvm.insertelement"(%195, %58, %52) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %197 = "llvm.insertelement"(%196, %58, %51) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %198 = "llvm.insertelement"(%197, %61, %50) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %199 = "llvm.insertelement"(%198, %61, %49) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %200 = "llvm.insertelement"(%62, %61, %63) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %201 = "llvm.insertelement"(%200, %61, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %202 = "llvm.insertelement"(%201, %61, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %203 = "llvm.insertelement"(%202, %61, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %204 = "llvm.insertelement"(%203, %13, %52) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %205 = "llvm.insertelement"(%204, %13, %51) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %206 = "llvm.insertelement"(%205, %13, %50) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %207 = "llvm.insertelement"(%206, %13, %49) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  "llvm.call"(%arg3, %56) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_ge_decode_step_slow, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, i64) -> ()
  %208 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 512>}> : (!llvm.ptr) -> !llvm.ptr
  %209 = "llvm.load"(%208) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %210 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 576>}> : (!llvm.ptr) -> !llvm.ptr
  %211 = "llvm.load"(%210) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<6xi64>
  %212 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 640>}> : (!llvm.ptr) -> !llvm.ptr
  %213 = "llvm.load"(%212) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<6xi64>
  %214 = "llvm.load"(%arg3) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %215 = "llvm.shufflevector"(%213, %57) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<6xi64>, vector<6xi64>) -> vector<8xi64>
  %216 = "llvm.shufflevector"(%213, %57) <{mask = array<i32: 1, 1, 1, 1, 1, 1, 1, 1>}> : (vector<6xi64>, vector<6xi64>) -> vector<8xi64>
  %217 = "llvm.shufflevector"(%213, %57) <{mask = array<i32: 2, 2, 2, 2, 2, 2, 2, 2>}> : (vector<6xi64>, vector<6xi64>) -> vector<8xi64>
  %218 = "llvm.shufflevector"(%213, %57) <{mask = array<i32: 3, 3, 3, 3, 3, 3, 3, 3>}> : (vector<6xi64>, vector<6xi64>) -> vector<8xi64>
  %219 = "llvm.shufflevector"(%213, %57) <{mask = array<i32: 4, 4, 4, 4, 4, 4, 4, 4>}> : (vector<6xi64>, vector<6xi64>) -> vector<8xi64>
  %220 = "llvm.shufflevector"(%213, %57) <{mask = array<i32: 5, 5, 5, 5, 5, 5, 5, 5>}> : (vector<6xi64>, vector<6xi64>) -> vector<8xi64>
  %221 = "llvm.call_intrinsic"(%59, %215, %214) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %222 = "llvm.shl"(%221, %60) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %223 = "llvm.call_intrinsic"(%222, %216, %214) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %224 = "llvm.call_intrinsic"(%59, %216, %214) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %225 = "llvm.shl"(%224, %60) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %226 = "llvm.call_intrinsic"(%225, %217, %214) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %227 = "llvm.call_intrinsic"(%59, %217, %214) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %228 = "llvm.shl"(%227, %60) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %229 = "llvm.call_intrinsic"(%228, %218, %214) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %230 = "llvm.call_intrinsic"(%59, %218, %214) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %231 = "llvm.shl"(%230, %60) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %232 = "llvm.call_intrinsic"(%231, %219, %214) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %233 = "llvm.call_intrinsic"(%59, %219, %214) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %234 = "llvm.shl"(%233, %60) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %235 = "llvm.call_intrinsic"(%234, %220, %214) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %236 = "llvm.call_intrinsic"(%59, %220, %214) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %237 = "llvm.shl"(%236, %60) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %238 = "llvm.shufflevector"(%71, %223) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %239 = "llvm.shufflevector"(%79, %226) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %240 = "llvm.shufflevector"(%87, %229) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %241 = "llvm.shufflevector"(%229, %95) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %242 = "llvm.shufflevector"(%103, %232) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %243 = "llvm.shufflevector"(%232, %111) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %244 = "llvm.shufflevector"(%119, %235) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %245 = "llvm.shufflevector"(%235, %127) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %246 = "llvm.shufflevector"(%135, %237) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %247 = "llvm.shufflevector"(%237, %48) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %248 = "llvm.call_intrinsic"(%238, %215, %214) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %249 = "llvm.add"(%240, %239) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %250 = "llvm.add"(%249, %242) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %251 = "llvm.add"(%250, %244) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %252 = "llvm.add"(%251, %248) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %253 = "llvm.add"(%252, %246) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %254 = "llvm.add"(%243, %241) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %255 = "llvm.add"(%254, %245) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %256 = "llvm.add"(%255, %247) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %257 = "llvm.and"(%253, %47) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %258 = "llvm.shufflevector"(%253, %256) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %259 = "llvm.shl"(%258, %46) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %260 = "llvm.add"(%259, %257) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %261 = "llvm.mul"(%258, %45) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %262 = "llvm.add"(%260, %261) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %263 = "llvm.and"(%262, %44) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %264 = "llvm.lshr"(%262, %43) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %265 = "llvm.shufflevector"(%264, %48) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %266 = "llvm.call_intrinsic"(%263, %42, %265) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %267 = "llvm.shufflevector"(%266, %48) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %268 = "llvm.shufflevector"(%266, %48) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 3, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %269 = "llvm.shufflevector"(%266, %48) <{mask = array<i32: 4, 4, 1, 1, 1, 1, 1, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %270 = "llvm.shufflevector"(%266, %48) <{mask = array<i32: 4, 5, 1, 2, 3, 4, 5, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %271 = "llvm.shufflevector"(%266, %48) <{mask = array<i32: 3, 7, 5, 7, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %272 = "llvm.shufflevector"(%266, %48) <{mask = array<i32: 5, 7, 5, 7, 2, 3, 4, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %273 = "llvm.shl"(%267, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %274 = "llvm.shl"(%269, %40) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %275 = "llvm.shl"(%271, %39) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %276 = "llvm.call_intrinsic"(%59, %274, %270) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %277 = "llvm.call_intrinsic"(%59, %275, %272) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %278 = "llvm.call_intrinsic"(%59, %273, %268) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %279 = "llvm.shl"(%278, %60) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %280 = "llvm.call_intrinsic"(%59, %274, %270) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %281 = "llvm.shl"(%280, %60) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %282 = "llvm.call_intrinsic"(%59, %275, %272) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %283 = "llvm.shl"(%282, %60) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %284 = "llvm.and"(%276, %38) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %285 = "llvm.and"(%277, %37) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %286 = "llvm.add"(%285, %284) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %287 = "llvm.call_intrinsic"(%286, %273, %268) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %288 = "llvm.and"(%281, %38) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %289 = "llvm.and"(%283, %37) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %290 = "llvm.add"(%288, %279) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %291 = "llvm.add"(%290, %289) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %292 = "llvm.and"(%276, %143) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %293 = "llvm.and"(%277, %151) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %294 = "llvm.and"(%281, %159) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %295 = "llvm.and"(%283, %167) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %296 = "llvm.add"(%295, %294) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %297 = "llvm.shufflevector"(%71, %291) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %298 = "llvm.add"(%297, %287) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %299 = "llvm.shufflevector"(%71, %296) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %300 = "llvm.shufflevector"(%291, %175) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %301 = "llvm.add"(%293, %292) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %302 = "llvm.add"(%301, %299) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %303 = "llvm.add"(%302, %300) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %304 = "llvm.and"(%298, %47) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %305 = "llvm.shufflevector"(%298, %303) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %306 = "llvm.shl"(%305, %46) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %307 = "llvm.add"(%306, %304) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %308 = "llvm.mul"(%305, %45) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %309 = "llvm.add"(%307, %308) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %310 = "llvm.and"(%309, %44) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %311 = "llvm.lshr"(%309, %43) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %312 = "llvm.shufflevector"(%311, %48) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %313 = "llvm.call_intrinsic"(%310, %42, %312) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %314 = "llvm.shufflevector"(%211, %57) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<6xi64>, vector<6xi64>) -> vector<8xi64>
  %315 = "llvm.shufflevector"(%211, %57) <{mask = array<i32: 1, 1, 1, 1, 1, 1, 1, 1>}> : (vector<6xi64>, vector<6xi64>) -> vector<8xi64>
  %316 = "llvm.shufflevector"(%211, %57) <{mask = array<i32: 2, 2, 2, 2, 2, 2, 2, 2>}> : (vector<6xi64>, vector<6xi64>) -> vector<8xi64>
  %317 = "llvm.shufflevector"(%211, %57) <{mask = array<i32: 3, 3, 3, 3, 3, 3, 3, 3>}> : (vector<6xi64>, vector<6xi64>) -> vector<8xi64>
  %318 = "llvm.shufflevector"(%211, %57) <{mask = array<i32: 4, 4, 4, 4, 4, 4, 4, 4>}> : (vector<6xi64>, vector<6xi64>) -> vector<8xi64>
  %319 = "llvm.shufflevector"(%211, %57) <{mask = array<i32: 5, 5, 5, 5, 5, 5, 5, 5>}> : (vector<6xi64>, vector<6xi64>) -> vector<8xi64>
  %320 = "llvm.call_intrinsic"(%59, %314, %313) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %321 = "llvm.shl"(%320, %60) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %322 = "llvm.call_intrinsic"(%321, %315, %313) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %323 = "llvm.call_intrinsic"(%59, %315, %313) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %324 = "llvm.shl"(%323, %60) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %325 = "llvm.call_intrinsic"(%324, %316, %313) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %326 = "llvm.call_intrinsic"(%59, %316, %313) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %327 = "llvm.shl"(%326, %60) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %328 = "llvm.call_intrinsic"(%327, %317, %313) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %329 = "llvm.call_intrinsic"(%59, %317, %313) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %330 = "llvm.shl"(%329, %60) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %331 = "llvm.call_intrinsic"(%330, %318, %313) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %332 = "llvm.call_intrinsic"(%59, %318, %313) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %333 = "llvm.shl"(%332, %60) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %334 = "llvm.call_intrinsic"(%333, %319, %313) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %335 = "llvm.call_intrinsic"(%59, %319, %313) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %336 = "llvm.shl"(%335, %60) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %337 = "llvm.shufflevector"(%71, %322) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %338 = "llvm.shufflevector"(%79, %325) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %339 = "llvm.shufflevector"(%87, %328) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %340 = "llvm.shufflevector"(%328, %95) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %341 = "llvm.shufflevector"(%103, %331) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %342 = "llvm.shufflevector"(%331, %111) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %343 = "llvm.shufflevector"(%119, %334) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %344 = "llvm.shufflevector"(%334, %127) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %345 = "llvm.shufflevector"(%135, %336) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %346 = "llvm.shufflevector"(%336, %48) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %347 = "llvm.call_intrinsic"(%337, %314, %313) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %348 = "llvm.add"(%339, %338) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %349 = "llvm.add"(%348, %341) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %350 = "llvm.add"(%349, %343) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %351 = "llvm.add"(%350, %347) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %352 = "llvm.add"(%351, %345) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %353 = "llvm.add"(%342, %340) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %354 = "llvm.add"(%353, %344) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %355 = "llvm.add"(%354, %346) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %356 = "llvm.and"(%352, %47) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %357 = "llvm.shufflevector"(%352, %355) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %358 = "llvm.shl"(%357, %46) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %359 = "llvm.add"(%358, %356) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %360 = "llvm.mul"(%357, %45) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %361 = "llvm.add"(%359, %360) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %362 = "llvm.and"(%361, %44) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %363 = "llvm.lshr"(%361, %43) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %364 = "llvm.shufflevector"(%363, %48) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %365 = "llvm.call_intrinsic"(%362, %42, %364) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %366 = "llvm.sub"(%365, %209) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %367 = "llvm.add"(%366, %183) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %368 = "llvm.add"(%365, %209) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %369 = "llvm.shufflevector"(%368, %367) <{mask = array<i32: 1, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<2xi64>
  %370 = "llvm.shufflevector"(%368, %367) <{mask = array<i32: 2, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<2xi64>
  %371 = "llvm.shufflevector"(%368, %367) <{mask = array<i32: 3, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<2xi64>
  %372 = "llvm.shufflevector"(%368, %367) <{mask = array<i32: 4, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<2xi64>
  %373 = "llvm.shufflevector"(%368, %367) <{mask = array<i32: 5, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<2xi64>
  %374 = "llvm.add"(%373, %33) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %375 = "llvm.and"(%374, %32) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %376 = "llvm.ashr"(%374, %31) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %377 = "llvm.mul"(%376, %30) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %378 = "llvm.shufflevector"(%368, %367) <{mask = array<i32: 0, 8>}> : (vector<8xi64>, vector<8xi64>) -> vector<2xi64>
  %379 = "llvm.add"(%377, %378) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %380 = "llvm.add"(%375, %29) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %381 = "llvm.ashr"(%379, %28) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %382 = "llvm.add"(%381, %369) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %383 = "llvm.ashr"(%382, %28) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %384 = "llvm.add"(%383, %370) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %385 = "llvm.ashr"(%384, %28) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %386 = "llvm.add"(%385, %371) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %387 = "llvm.ashr"(%386, %28) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %388 = "llvm.add"(%387, %372) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %389 = "llvm.and"(%379, %27) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %390 = "llvm.and"(%382, %27) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %391 = "llvm.and"(%384, %27) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %392 = "llvm.and"(%386, %27) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %393 = "llvm.ashr"(%388, %28) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %394 = "llvm.and"(%388, %27) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %395 = "llvm.add"(%389, %30) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %396 = "llvm.lshr"(%395, %28) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %397 = "llvm.and"(%395, %27) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %398 = "llvm.add"(%390, %396) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %399 = "llvm.lshr"(%398, %28) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %400 = "llvm.and"(%398, %27) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %401 = "llvm.add"(%391, %399) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %402 = "llvm.lshr"(%401, %28) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %403 = "llvm.and"(%401, %27) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %404 = "llvm.add"(%392, %402) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %405 = "llvm.lshr"(%404, %28) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %406 = "llvm.and"(%404, %27) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %407 = "llvm.add"(%394, %405) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %408 = "llvm.lshr"(%407, %28) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %409 = "llvm.and"(%407, %27) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %410 = "llvm.add"(%380, %393) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %411 = "llvm.add"(%410, %408) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %412 = "llvm.and"(%411, %32) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %413 = "llvm.icmp"(%411, %26) <{predicate = 6 : i64}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi1>
  %414 = "llvm.select"(%413, %25, %24) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<2xi1>, vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %415 = "llvm.add"(%414, %397) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %416 = "llvm.ashr"(%415, %28) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %417 = "llvm.add"(%416, %400) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %418 = "llvm.ashr"(%417, %28) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %419 = "llvm.add"(%418, %403) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %420 = "llvm.ashr"(%419, %28) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %421 = "llvm.add"(%420, %406) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %422 = "llvm.ashr"(%421, %28) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %423 = "llvm.add"(%422, %409) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %424 = "llvm.ashr"(%423, %28) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %425 = "llvm.add"(%424, %412) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %426 = "llvm.or"(%417, %415) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %427 = "llvm.or"(%426, %419) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %428 = "llvm.or"(%427, %421) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %429 = "llvm.or"(%428, %423) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %430 = "llvm.and"(%429, %27) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %431 = "llvm.or"(%430, %425) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %432 = "llvm.icmp"(%431, %24) <{predicate = 1 : i64}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi1>
  %433 = "llvm.extractelement"(%432, %58) : (vector<2xi1>, i64) -> i1
  %434 = "llvm.extractelement"(%432, %23) : (vector<2xi1>, i64) -> i1
  %435 = "llvm.and"(%433, %434) : (i1, i1) -> i1
  "llvm.cond_br"(%435)[^bb2, ^bb1] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb1:  // pred: ^bb0
  %436 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 720>}> : (!llvm.ptr) -> !llvm.ptr
  %437 = "llvm.load"(%436) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "fd_r43x6_ge_decode", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 64>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 128>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 192>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 256>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 320>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 384>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 448>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 512>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 576>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 640>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 704>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 712>, <#llvm.tbaa_type_desc<id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 720>}>, access_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 720>]}> : (!llvm.ptr) -> i32
  %438 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 448>}> : (!llvm.ptr) -> !llvm.ptr
  %439 = "llvm.load"(%438) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %440 = "llvm.xor"(%434, %22) : (i1, i1) -> i1
  %441 = "llvm.sext"(%440) : (i1) -> i8
  %442 = "llvm.bitcast"(%441) : (i8) -> vector<8xi1>
  %443 = "llvm.select"(%442, %21, %20) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %444 = "llvm.shufflevector"(%266, %48) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %445 = "llvm.shufflevector"(%266, %48) <{mask = array<i32: 1, 1, 1, 1, 1, 1, 1, 1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %446 = "llvm.shufflevector"(%266, %48) <{mask = array<i32: 2, 2, 2, 2, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %447 = "llvm.shufflevector"(%266, %48) <{mask = array<i32: 3, 3, 3, 3, 3, 3, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %448 = "llvm.shufflevector"(%266, %48) <{mask = array<i32: 4, 4, 4, 4, 4, 4, 4, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %449 = "llvm.shufflevector"(%266, %48) <{mask = array<i32: 5, 5, 5, 5, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %450 = "llvm.call_intrinsic"(%59, %444, %443) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %451 = "llvm.shl"(%450, %60) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %452 = "llvm.call_intrinsic"(%451, %445, %443) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %453 = "llvm.call_intrinsic"(%59, %445, %443) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %454 = "llvm.shl"(%453, %60) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %455 = "llvm.call_intrinsic"(%454, %446, %443) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %456 = "llvm.call_intrinsic"(%59, %446, %443) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %457 = "llvm.shl"(%456, %60) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %458 = "llvm.call_intrinsic"(%457, %447, %443) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %459 = "llvm.call_intrinsic"(%59, %447, %443) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %460 = "llvm.shl"(%459, %60) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %461 = "llvm.call_intrinsic"(%460, %448, %443) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %462 = "llvm.call_intrinsic"(%59, %448, %443) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %463 = "llvm.shl"(%462, %60) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %464 = "llvm.call_intrinsic"(%463, %449, %443) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %465 = "llvm.call_intrinsic"(%59, %449, %443) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %466 = "llvm.shl"(%465, %60) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %467 = "llvm.shufflevector"(%71, %452) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %468 = "llvm.shufflevector"(%79, %455) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %469 = "llvm.shufflevector"(%87, %458) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %470 = "llvm.shufflevector"(%458, %95) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %471 = "llvm.shufflevector"(%103, %461) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %472 = "llvm.shufflevector"(%461, %111) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %473 = "llvm.shufflevector"(%119, %464) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %474 = "llvm.shufflevector"(%464, %127) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %475 = "llvm.shufflevector"(%135, %466) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %476 = "llvm.shufflevector"(%466, %48) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %477 = "llvm.call_intrinsic"(%467, %444, %443) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %478 = "llvm.add"(%469, %468) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %479 = "llvm.add"(%478, %471) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %480 = "llvm.add"(%479, %473) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %481 = "llvm.add"(%480, %477) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %482 = "llvm.add"(%481, %475) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %483 = "llvm.add"(%472, %470) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %484 = "llvm.add"(%483, %474) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %485 = "llvm.add"(%484, %476) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %486 = "llvm.and"(%482, %47) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %487 = "llvm.shufflevector"(%482, %485) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %488 = "llvm.shl"(%487, %46) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %489 = "llvm.add"(%488, %486) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %490 = "llvm.mul"(%487, %45) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %491 = "llvm.add"(%489, %490) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %492 = "llvm.and"(%491, %44) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %493 = "llvm.lshr"(%491, %43) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %494 = "llvm.shufflevector"(%493, %48) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %495 = "llvm.call_intrinsic"(%492, %42, %494) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %496 = "llvm.extractelement"(%495, %58) : (vector<8xi64>, i64) -> i64
  %497 = "llvm.extractelement"(%495, %23) : (vector<8xi64>, i64) -> i64
  %498 = "llvm.extractelement"(%495, %19) : (vector<8xi64>, i64) -> i64
  %499 = "llvm.extractelement"(%495, %18) : (vector<8xi64>, i64) -> i64
  %500 = "llvm.extractelement"(%495, %17) : (vector<8xi64>, i64) -> i64
  %501 = "llvm.extractelement"(%495, %16) : (vector<8xi64>, i64) -> i64
  %502 = "llvm.add"(%501, %15) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %503 = "llvm.ashr"(%502, %14) : (i64, i64) -> i64
  %504 = "llvm.and"(%502, %36) : (i64, i64) -> i64
  %505 = "llvm.mul"(%503, %13) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %506 = "llvm.add"(%505, %496) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %507 = "llvm.ashr"(%506, %12) : (i64, i64) -> i64
  %508 = "llvm.and"(%506, %35) : (i64, i64) -> i64
  %509 = "llvm.add"(%507, %497) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %510 = "llvm.ashr"(%509, %12) : (i64, i64) -> i64
  %511 = "llvm.and"(%509, %35) : (i64, i64) -> i64
  %512 = "llvm.add"(%510, %498) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %513 = "llvm.ashr"(%512, %12) : (i64, i64) -> i64
  %514 = "llvm.and"(%512, %35) : (i64, i64) -> i64
  %515 = "llvm.add"(%513, %499) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %516 = "llvm.ashr"(%515, %12) : (i64, i64) -> i64
  %517 = "llvm.and"(%515, %35) : (i64, i64) -> i64
  %518 = "llvm.add"(%516, %500) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %519 = "llvm.ashr"(%518, %12) : (i64, i64) -> i64
  %520 = "llvm.and"(%518, %35) : (i64, i64) -> i64
  %521 = "llvm.add"(%508, %13) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %522 = "llvm.lshr"(%521, %12) : (i64, i64) -> i64
  %523 = "llvm.and"(%521, %35) : (i64, i64) -> i64
  %524 = "llvm.add"(%511, %522) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %525 = "llvm.lshr"(%524, %12) : (i64, i64) -> i64
  %526 = "llvm.and"(%524, %35) : (i64, i64) -> i64
  %527 = "llvm.add"(%514, %525) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %528 = "llvm.lshr"(%527, %12) : (i64, i64) -> i64
  %529 = "llvm.and"(%527, %35) : (i64, i64) -> i64
  %530 = "llvm.add"(%517, %528) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %531 = "llvm.lshr"(%530, %12) : (i64, i64) -> i64
  %532 = "llvm.and"(%530, %35) : (i64, i64) -> i64
  %533 = "llvm.add"(%520, %531) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %534 = "llvm.lshr"(%533, %12) : (i64, i64) -> i64
  %535 = "llvm.and"(%533, %35) : (i64, i64) -> i64
  %536 = "llvm.add"(%504, %11) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %537 = "llvm.add"(%536, %519) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %538 = "llvm.add"(%537, %534) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %539 = "llvm.and"(%538, %36) : (i64, i64) -> i64
  %540 = "llvm.icmp"(%538, %10) <{predicate = 6 : i64}> : (i64, i64) -> i1
  %541 = "llvm.select"(%540, %9, %58) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %542 = "llvm.add"(%541, %523) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %543 = "llvm.ashr"(%542, %12) : (i64, i64) -> i64
  %544 = "llvm.add"(%543, %526) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %545 = "llvm.ashr"(%544, %12) : (i64, i64) -> i64
  %546 = "llvm.add"(%545, %529) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %547 = "llvm.ashr"(%546, %12) : (i64, i64) -> i64
  %548 = "llvm.add"(%547, %532) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %549 = "llvm.ashr"(%548, %12) : (i64, i64) -> i64
  %550 = "llvm.add"(%549, %535) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %551 = "llvm.ashr"(%550, %12) : (i64, i64) -> i64
  %552 = "llvm.add"(%551, %539) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %553 = "llvm.or"(%544, %542) : (i64, i64) -> i64
  %554 = "llvm.or"(%553, %546) : (i64, i64) -> i64
  %555 = "llvm.or"(%554, %548) : (i64, i64) -> i64
  %556 = "llvm.or"(%555, %550) : (i64, i64) -> i64
  %557 = "llvm.and"(%556, %35) : (i64, i64) -> i64
  %558 = "llvm.or"(%557, %552) : (i64, i64) -> i64
  %559 = "llvm.icmp"(%558, %58) <{predicate = 0 : i64}> : (i64, i64) -> i1
  %560 = "llvm.trunc"(%542) <{overflowFlags = 0 : i32}> : (i64) -> i32
  %561 = "llvm.and"(%560, %55) : (i32, i32) -> i32
  %562 = "llvm.select"(%559, %8, %561) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i32, i32) -> i32
  %563 = "llvm.icmp"(%437, %562) <{predicate = 0 : i64}> : (i32, i32) -> i1
  %564 = "llvm.sext"(%563) : (i1) -> i8
  %565 = "llvm.sub"(%7, %495) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %566 = "llvm.and"(%565, %44) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %567 = "llvm.ashr"(%565, %43) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %568 = "llvm.shufflevector"(%567, %127) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 8, 8>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %569 = "llvm.mul"(%568, %6) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %570 = "llvm.and"(%569, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %571 = "llvm.add"(%566, %4) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %572 = "llvm.add"(%571, %568) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %573 = "llvm.add"(%572, %570) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %574 = "llvm.bitcast"(%564) : (i8) -> vector<8xi1>
  %575 = "llvm.select"(%574, %495, %573) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %576 = "llvm.shufflevector"(%575, %48) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %577 = "llvm.shufflevector"(%575, %48) <{mask = array<i32: 1, 1, 1, 1, 1, 1, 1, 1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %578 = "llvm.shufflevector"(%575, %48) <{mask = array<i32: 2, 2, 2, 2, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %579 = "llvm.shufflevector"(%575, %48) <{mask = array<i32: 3, 3, 3, 3, 3, 3, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %580 = "llvm.shufflevector"(%575, %48) <{mask = array<i32: 4, 4, 4, 4, 4, 4, 4, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %581 = "llvm.shufflevector"(%575, %48) <{mask = array<i32: 5, 5, 5, 5, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %582 = "llvm.call_intrinsic"(%59, %576, %439) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %583 = "llvm.shl"(%582, %60) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %584 = "llvm.call_intrinsic"(%583, %577, %439) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %585 = "llvm.call_intrinsic"(%59, %577, %439) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %586 = "llvm.shl"(%585, %60) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %587 = "llvm.call_intrinsic"(%586, %578, %439) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %588 = "llvm.call_intrinsic"(%59, %578, %439) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %589 = "llvm.shl"(%588, %60) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %590 = "llvm.call_intrinsic"(%589, %579, %439) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %591 = "llvm.call_intrinsic"(%59, %579, %439) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %592 = "llvm.shl"(%591, %60) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %593 = "llvm.call_intrinsic"(%592, %580, %439) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %594 = "llvm.call_intrinsic"(%59, %580, %439) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %595 = "llvm.shl"(%594, %60) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %596 = "llvm.call_intrinsic"(%595, %581, %439) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %597 = "llvm.call_intrinsic"(%59, %581, %439) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %598 = "llvm.shl"(%597, %60) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %599 = "llvm.shufflevector"(%71, %584) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %600 = "llvm.shufflevector"(%79, %587) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %601 = "llvm.shufflevector"(%87, %590) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %602 = "llvm.shufflevector"(%590, %95) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %603 = "llvm.shufflevector"(%103, %593) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %604 = "llvm.shufflevector"(%593, %111) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %605 = "llvm.shufflevector"(%119, %596) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %606 = "llvm.shufflevector"(%596, %127) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %607 = "llvm.shufflevector"(%135, %598) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %608 = "llvm.shufflevector"(%598, %48) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %609 = "llvm.call_intrinsic"(%599, %576, %439) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %610 = "llvm.add"(%601, %600) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %611 = "llvm.add"(%610, %603) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %612 = "llvm.add"(%611, %605) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %613 = "llvm.add"(%612, %609) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %614 = "llvm.add"(%613, %607) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %615 = "llvm.add"(%604, %602) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %616 = "llvm.add"(%615, %606) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %617 = "llvm.add"(%616, %608) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %618 = "llvm.and"(%614, %47) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %619 = "llvm.shufflevector"(%614, %617) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %620 = "llvm.shl"(%619, %46) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %621 = "llvm.add"(%620, %618) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %622 = "llvm.mul"(%619, %45) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %623 = "llvm.add"(%621, %622) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %624 = "llvm.and"(%623, %44) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %625 = "llvm.lshr"(%623, %43) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %626 = "llvm.shufflevector"(%625, %48) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %627 = "llvm.call_intrinsic"(%624, %42, %626) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %628 = "llvm.shufflevector"(%575, %191) <{mask = array<i32: 0, 1, 8, 9, 4, 5, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %629 = "llvm.shufflevector"(%439, %627) <{mask = array<i32: 0, 1, 8, 9, 4, 5, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %630 = "llvm.shufflevector"(%575, %199) <{mask = array<i32: 2, 3, 10, 11, 6, 7, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %631 = "llvm.shufflevector"(%439, %627) <{mask = array<i32: 2, 3, 10, 11, 6, 7, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %632 = "llvm.shufflevector"(%628, %629) <{mask = array<i32: 0, 8, 2, 10, -1, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %633 = "llvm.shufflevector"(%628, %629) <{mask = array<i32: -1, -1, -1, -1, 5, 13, 7, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %634 = "llvm.shufflevector"(%630, %631) <{mask = array<i32: 0, 8, 2, 10, -1, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %635 = "llvm.shufflevector"(%630, %631) <{mask = array<i32: 1, 9, 3, 11, -1, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %636 = "llvm.shufflevector"(%632, %635) <{mask = array<i32: 0, 1, 2, 3, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%636, %arg0) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %637 = "llvm.shufflevector"(%628, %629) <{mask = array<i32: 1, 9, 3, 11, 4, 12, 6, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%637, %arg1) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %638 = "llvm.shufflevector"(%634, %633) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%638, %arg2) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %639 = "llvm.load"(%arg0) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %640 = "llvm.lshr"(%639, %3) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %641 = "llvm.load"(%arg1) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %642 = "llvm.lshr"(%641, %3) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %643 = "llvm.lshr"(%638, %2) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %644 = "llvm.mul"(%643, %207) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %645 = "llvm.and"(%639, %1) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %646 = "llvm.shufflevector"(%644, %643) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %647 = "llvm.add"(%646, %645) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%647, %arg0) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %648 = "llvm.load"(%arg1) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %649 = "llvm.and"(%648, %1) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %650 = "llvm.add"(%649, %640) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%650, %arg1) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %651 = "llvm.load"(%arg2) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %652 = "llvm.and"(%651, %0) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %653 = "llvm.add"(%652, %642) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.br"(%653, %63)[^bb3] : (vector<8xi64>, i32) -> ()
^bb2:  // pred: ^bb0
  "llvm.store"(%59, %arg0) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%59, %arg1) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.br"(%59, %8)[^bb3] : (vector<8xi64>, i32) -> ()
^bb3(%654: vector<8xi64>, %655: i32):  // 2 preds: ^bb1, ^bb2
  "llvm.store"(%654, %arg2) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.return"(%655) : (i32) -> ()
}) : () -> ()

    with
      @fd_r43x6_ge_decode_step_slow := Firedancer.Lane.Mlir.fd_r43x6_ge_decode_step_slow

end

end Firedancer.Lane.Mlir
