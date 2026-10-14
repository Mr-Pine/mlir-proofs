
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.Lane.Mlir.fd_r43x6_pow22523

namespace Firedancer.Lane.Mlir

@[expose] public section

mlir_def fd_r43x6_ge_decode := "llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<i32 (ptr, ptr, ptr, ptr)>, linkage = #llvm.linkage<external>, no_unwind, passthrough = ["sspstrong", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], res_attrs = [{llvm.range = #llvm.constant_range<i32, -1, 1>}], sym_name = "fd_r43x6_ge_decode", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: !llvm.ptr, %arg3: !llvm.ptr):
  %0 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
  %1 = "llvm.mlir.constant"() <{value = dense<[8796093022207, 8796093022207, 8796093022207, 8796093022207, 1099511627775, 1099511627775, 1099511627775, 1099511627775]> : vector<8xi64>}> : () -> vector<8xi64>
  %2 = "llvm.mlir.constant"() <{value = dense<[43, 43, 43, 43, 40, 40, 40, 40]> : vector<8xi64>}> : () -> vector<8xi64>
  %3 = "llvm.mlir.constant"() <{value = dense<43> : vector<8xi64>}> : () -> vector<8xi64>
  %4 = "llvm.mlir.constant"() <{value = dense<[8795933638637, 8796091973631, 8796091973631, 8796091973631, 8796091973631, 1099510579199, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %5 = "llvm.mlir.constant"() <{value = false}> : () -> i1
  %6 = "llvm.mlir.constant"() <{value = -19 : i64}> : () -> i64
  %7 = "llvm.mlir.constant"() <{value = 1099511627776 : i64}> : () -> i64
  %8 = "llvm.mlir.constant"() <{value = 1048576 : i64}> : () -> i64
  %9 = "llvm.mlir.constant"() <{value = 8796093022207 : i64}> : () -> i64
  %10 = "llvm.mlir.constant"() <{value = 43 : i64}> : () -> i64
  %11 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %12 = "llvm.mlir.constant"() <{value = 1099511627775 : i64}> : () -> i64
  %13 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
  %14 = "llvm.mlir.constant"() <{value = -1048576 : i64}> : () -> i64
  %15 = "llvm.mlir.constant"() <{value = 5 : i64}> : () -> i64
  %16 = "llvm.mlir.constant"() <{value = 4 : i64}> : () -> i64
  %17 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %18 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %19 = "llvm.mlir.constant"() <{value = dense<[3467281080496, 6582290652611, 5210002954932, 329084955603, 4526638806224, 373767602335, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %20 = "llvm.mlir.constant"() <{value = true}> : () -> i1
  %21 = "llvm.mlir.constant"() <{value = 63 : i64}> : () -> i64
  %22 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %23 = "llvm.mlir.constant"() <{value = dense<0> : vector<2xi64>}> : () -> vector<2xi64>
  %24 = "llvm.mlir.constant"() <{value = dense<-19> : vector<2xi64>}> : () -> vector<2xi64>
  %25 = "llvm.mlir.constant"() <{value = dense<1099511627776> : vector<2xi64>}> : () -> vector<2xi64>
  %26 = "llvm.mlir.constant"() <{value = dense<8796093022207> : vector<2xi64>}> : () -> vector<2xi64>
  %27 = "llvm.mlir.constant"() <{value = dense<43> : vector<2xi64>}> : () -> vector<2xi64>
  %28 = "llvm.mlir.constant"() <{value = dense<1048576> : vector<2xi64>}> : () -> vector<2xi64>
  %29 = "llvm.mlir.constant"() <{value = dense<19> : vector<2xi64>}> : () -> vector<2xi64>
  %30 = "llvm.mlir.constant"() <{value = dense<40> : vector<2xi64>}> : () -> vector<2xi64>
  %31 = "llvm.mlir.constant"() <{value = dense<1099511627775> : vector<2xi64>}> : () -> vector<2xi64>
  %32 = "llvm.mlir.constant"() <{value = dense<-1048576> : vector<2xi64>}> : () -> vector<2xi64>
  %33 = "llvm.mlir.constant"() <{value = 8795933638637 : i64}> : () -> i64
  %34 = "llvm.mlir.constant"() <{value = 8796091973631 : i64}> : () -> i64
  %35 = "llvm.mlir.constant"() <{value = 1099510579199 : i64}> : () -> i64
  %36 = "llvm.mlir.constant"() <{value = dense<[1, 0, 0, 0, 0, 0, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %37 = "llvm.mlir.constant"() <{value = dense<704489577558> : vector<8xi64>}> : () -> vector<8xi64>
  %38 = "llvm.mlir.constant"() <{value = dense<7696165686388> : vector<8xi64>}> : () -> vector<8xi64>
  %39 = "llvm.mlir.constant"() <{value = dense<260847760460> : vector<8xi64>}> : () -> vector<8xi64>
  %40 = "llvm.mlir.constant"() <{value = dense<7518893317> : vector<8xi64>}> : () -> vector<8xi64>
  %41 = "llvm.mlir.constant"() <{value = dense<253762649449> : vector<8xi64>}> : () -> vector<8xi64>
  %42 = "llvm.mlir.constant"() <{value = dense<6365466163363> : vector<8xi64>}> : () -> vector<8xi64>
  %43 = "llvm.mlir.constant"() <{value = dense<[159383552, 1048576, 1048576, 1048576, 1048576, 1048576, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %44 = "llvm.mlir.constant"() <{value = dense<[-1, 0, 0, 0, 0, 0, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %45 = "llvm.mlir.constant"() <{value = dense<18> : vector<8xi64>}> : () -> vector<8xi64>
  %46 = "llvm.mlir.constant"() <{value = dense<[8795933638636, 8796091973631, 8796091973631, 8796091973631, 8796091973631, 1099510579199, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %47 = "llvm.mlir.constant"() <{value = dense<[19, 1, 1, 1, 1, 1, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %48 = "llvm.mlir.constant"() <{value = dense<[43, 43, 43, 43, 43, 40, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %49 = "llvm.mlir.constant"() <{value = dense<[8796093022207, 8796093022207, 8796093022207, 8796093022207, 8796093022207, 1099511627775, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %50 = "llvm.mlir.constant"() <{value = dense<24> : vector<8xi64>}> : () -> vector<8xi64>
  %51 = "llvm.mlir.constant"() <{value = dense<7> : vector<8xi64>}> : () -> vector<8xi64>
  %52 = "llvm.mlir.constant"() <{value = dense<[-1, -1, -1, -1, -1, -1, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %53 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %54 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %55 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %56 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %57 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %58 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %59 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %60 = "llvm.mlir.constant"() <{value = dense<[-1, -1, -1, 9223372036854775807]> : vector<4xi64>}> : () -> vector<4xi64>
  %61 = "llvm.mlir.poison"() : () -> vector<4xi64>
  %62 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %63 = "llvm.mlir.constant"() <{value = 7 : i64}> : () -> i64
  %64 = "llvm.mlir.poison"() : () -> vector<64xi8>
  %65 = "llvm.mlir.constant"() <{value = dense<[0, 3, 6, 1, 4, 7, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %66 = "llvm.mlir.constant"() <{value = dense<8796093022207> : vector<8xi64>}> : () -> vector<8xi64>
  %67 = "llvm.mlir.poison"() : () -> vector<8xi64>
  %68 = "llvm.mlir.constant"() <{value = dense<[0, 1, 1, 1, 1, 1, 0, 1]> : vector<8xi64>}> : () -> vector<8xi64>
  %69 = "llvm.mlir.constant"() <{value = dense<[0, 1, 0, 1, 1, 1, 1, 1]> : vector<8xi64>}> : () -> vector<8xi64>
  %70 = "llvm.mlir.constant"() <{value = dense<[1, 1, 0, 1, 0, 1, 1, 1]> : vector<8xi64>}> : () -> vector<8xi64>
  %71 = "llvm.mlir.constant"() <{value = dense<0> : vector<8xi64>}> : () -> vector<8xi64>
  %72 = "llvm.mlir.constant"() <{value = dense<9> : vector<8xi64>}> : () -> vector<8xi64>
  %73 = "llvm.mlir.constant"() <{value = dense<[0, 0, -1, -1, -1, -1, -1, -1]> : vector<8xi64>}> : () -> vector<8xi64>
  %74 = "llvm.mlir.constant"() <{value = dense<[0, -1, 0, -1, -1, -1, -1, -1]> : vector<8xi64>}> : () -> vector<8xi64>
  %75 = "llvm.mlir.poison"() : () -> i64
  %76 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %77 = "llvm.mlir.undef"() : () -> vector<8xi64>
  %78 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %79 = "llvm.insertelement"(%77, %76, %78) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %80 = "llvm.insertelement"(%79, %76, %59) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %81 = "llvm.insertelement"(%80, %62, %58) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %82 = "llvm.insertelement"(%81, %62, %57) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %83 = "llvm.insertelement"(%82, %62, %56) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %84 = "llvm.insertelement"(%83, %62, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %85 = "llvm.insertelement"(%84, %75, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %86 = "llvm.insertelement"(%85, %75, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %87 = "llvm.insertelement"(%77, %76, %78) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %88 = "llvm.insertelement"(%87, %62, %59) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %89 = "llvm.insertelement"(%88, %76, %58) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %90 = "llvm.insertelement"(%89, %62, %57) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %91 = "llvm.insertelement"(%90, %62, %56) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %92 = "llvm.insertelement"(%91, %62, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %93 = "llvm.insertelement"(%92, %75, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %94 = "llvm.insertelement"(%93, %75, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %95 = "llvm.insertelement"(%77, %76, %78) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %96 = "llvm.insertelement"(%95, %76, %59) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %97 = "llvm.insertelement"(%96, %62, %58) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %98 = "llvm.insertelement"(%97, %62, %57) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %99 = "llvm.insertelement"(%98, %62, %56) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %100 = "llvm.insertelement"(%99, %75, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %101 = "llvm.insertelement"(%100, %75, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %102 = "llvm.insertelement"(%101, %75, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %103 = "llvm.insertelement"(%77, %76, %78) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %104 = "llvm.insertelement"(%103, %62, %59) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %105 = "llvm.insertelement"(%104, %76, %58) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %106 = "llvm.insertelement"(%105, %62, %57) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %107 = "llvm.insertelement"(%106, %62, %56) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %108 = "llvm.insertelement"(%107, %75, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %109 = "llvm.insertelement"(%108, %75, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %110 = "llvm.insertelement"(%109, %75, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %111 = "llvm.insertelement"(%77, %75, %78) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %112 = "llvm.insertelement"(%111, %75, %59) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %113 = "llvm.insertelement"(%112, %75, %58) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %114 = "llvm.insertelement"(%113, %75, %57) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %115 = "llvm.insertelement"(%114, %75, %56) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %116 = "llvm.insertelement"(%115, %75, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %117 = "llvm.insertelement"(%116, %75, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %118 = "llvm.insertelement"(%117, %62, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %119 = "llvm.insertelement"(%77, %62, %78) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %120 = "llvm.insertelement"(%119, %62, %59) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %121 = "llvm.insertelement"(%120, %62, %58) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %122 = "llvm.insertelement"(%121, %62, %57) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %123 = "llvm.insertelement"(%122, %62, %56) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %124 = "llvm.insertelement"(%123, %75, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %125 = "llvm.insertelement"(%124, %75, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %126 = "llvm.insertelement"(%125, %75, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %127 = "llvm.insertelement"(%77, %62, %78) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %128 = "llvm.insertelement"(%127, %75, %59) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %129 = "llvm.insertelement"(%128, %75, %58) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %130 = "llvm.insertelement"(%129, %75, %57) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %131 = "llvm.insertelement"(%130, %75, %56) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %132 = "llvm.insertelement"(%131, %75, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %133 = "llvm.insertelement"(%132, %75, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %134 = "llvm.insertelement"(%133, %75, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %135 = "llvm.insertelement"(%77, %75, %78) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %136 = "llvm.insertelement"(%135, %75, %59) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %137 = "llvm.insertelement"(%136, %75, %58) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %138 = "llvm.insertelement"(%137, %75, %57) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %139 = "llvm.insertelement"(%138, %75, %56) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %140 = "llvm.insertelement"(%139, %75, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %141 = "llvm.insertelement"(%140, %62, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %142 = "llvm.insertelement"(%141, %62, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %143 = "llvm.insertelement"(%77, %75, %78) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %144 = "llvm.insertelement"(%143, %75, %59) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %145 = "llvm.insertelement"(%144, %75, %58) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %146 = "llvm.insertelement"(%145, %75, %57) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %147 = "llvm.insertelement"(%146, %75, %56) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %148 = "llvm.insertelement"(%147, %62, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %149 = "llvm.insertelement"(%148, %62, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %150 = "llvm.insertelement"(%149, %62, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %151 = "llvm.insertelement"(%77, %62, %78) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %152 = "llvm.insertelement"(%151, %62, %59) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %153 = "llvm.insertelement"(%152, %62, %58) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %154 = "llvm.insertelement"(%153, %75, %57) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %155 = "llvm.insertelement"(%154, %75, %56) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %156 = "llvm.insertelement"(%155, %75, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %157 = "llvm.insertelement"(%156, %75, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %158 = "llvm.insertelement"(%157, %75, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %159 = "llvm.insertelement"(%77, %75, %78) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %160 = "llvm.insertelement"(%159, %75, %59) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %161 = "llvm.insertelement"(%160, %75, %58) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %162 = "llvm.insertelement"(%161, %75, %57) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %163 = "llvm.insertelement"(%162, %62, %56) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %164 = "llvm.insertelement"(%163, %62, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %165 = "llvm.insertelement"(%164, %62, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %166 = "llvm.insertelement"(%165, %62, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %167 = "llvm.insertelement"(%77, %62, %78) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %168 = "llvm.insertelement"(%167, %62, %59) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %169 = "llvm.insertelement"(%168, %75, %58) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %170 = "llvm.insertelement"(%169, %75, %57) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %171 = "llvm.insertelement"(%170, %75, %56) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %172 = "llvm.insertelement"(%171, %75, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %173 = "llvm.insertelement"(%172, %75, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %174 = "llvm.insertelement"(%173, %75, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %175 = "llvm.insertelement"(%77, %75, %78) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %176 = "llvm.insertelement"(%175, %75, %59) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %177 = "llvm.insertelement"(%176, %75, %58) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %178 = "llvm.insertelement"(%177, %62, %57) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %179 = "llvm.insertelement"(%178, %62, %56) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %180 = "llvm.insertelement"(%179, %62, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %181 = "llvm.insertelement"(%180, %62, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %182 = "llvm.insertelement"(%181, %62, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %183 = "llvm.insertelement"(%77, %75, %78) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %184 = "llvm.insertelement"(%183, %75, %59) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %185 = "llvm.insertelement"(%184, %62, %58) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %186 = "llvm.insertelement"(%185, %62, %57) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %187 = "llvm.insertelement"(%186, %62, %56) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %188 = "llvm.insertelement"(%187, %62, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %189 = "llvm.insertelement"(%188, %62, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %190 = "llvm.insertelement"(%189, %62, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %191 = "llvm.insertelement"(%77, %33, %78) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %192 = "llvm.insertelement"(%191, %34, %59) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %193 = "llvm.insertelement"(%192, %34, %58) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %194 = "llvm.insertelement"(%193, %34, %57) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %195 = "llvm.insertelement"(%194, %34, %56) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %196 = "llvm.insertelement"(%195, %35, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %197 = "llvm.insertelement"(%196, %75, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %198 = "llvm.insertelement"(%197, %75, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %199 = "llvm.insertelement"(%77, %22, %78) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %200 = "llvm.insertelement"(%199, %62, %59) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %201 = "llvm.insertelement"(%200, %75, %58) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %202 = "llvm.insertelement"(%201, %75, %57) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %203 = "llvm.insertelement"(%202, %62, %56) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %204 = "llvm.insertelement"(%203, %62, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %205 = "llvm.insertelement"(%204, %75, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %206 = "llvm.insertelement"(%205, %75, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %207 = "llvm.insertelement"(%77, %75, %78) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %208 = "llvm.insertelement"(%207, %75, %59) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %209 = "llvm.insertelement"(%208, %62, %58) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %210 = "llvm.insertelement"(%209, %62, %57) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %211 = "llvm.insertelement"(%210, %62, %56) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %212 = "llvm.insertelement"(%211, %62, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %213 = "llvm.insertelement"(%212, %75, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %214 = "llvm.insertelement"(%213, %75, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %215 = "llvm.insertelement"(%77, %75, %78) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %216 = "llvm.insertelement"(%215, %75, %59) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %217 = "llvm.insertelement"(%216, %75, %58) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %218 = "llvm.insertelement"(%217, %75, %57) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %219 = "llvm.insertelement"(%218, %11, %56) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %220 = "llvm.insertelement"(%219, %11, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %221 = "llvm.insertelement"(%220, %11, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %222 = "llvm.insertelement"(%221, %11, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %223 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %224 = "llvm.load"(%223) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %225 = "llvm.load"(%arg3) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %226 = "llvm.and"(%225, %60) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %227 = "llvm.shufflevector"(%226, %61) <{mask = array<i32: 0, 1, 2, 3, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %228 = "llvm.insertelement"(%227, %62, %63) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %229 = "llvm.bitcast"(%228) : (vector<8xi64>) -> vector<64xi8>
  %230 = "llvm.shufflevector"(%229, %64) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 63, 63, 5, 6, 7, 8, 9, 10, 63, 63, 10, 11, 12, 13, 14, 15, 16, 63, 16, 17, 18, 19, 20, 21, 63, 63, 21, 22, 23, 24, 25, 26, 63, 63, 26, 27, 28, 29, 30, 31, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %231 = "llvm.bitcast"(%230) : (vector<64xi8>) -> vector<8xi64>
  %232 = "llvm.lshr"(%231, %65) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %233 = "llvm.and"(%232, %66) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %234 = "llvm.shufflevector"(%233, %67) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %235 = "llvm.shufflevector"(%233, %67) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 3, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %236 = "llvm.shufflevector"(%233, %67) <{mask = array<i32: 4, 4, 1, 1, 1, 1, 1, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %237 = "llvm.shufflevector"(%233, %67) <{mask = array<i32: 4, 5, 1, 2, 3, 4, 5, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %238 = "llvm.shufflevector"(%233, %67) <{mask = array<i32: 3, 7, 5, 7, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %239 = "llvm.shufflevector"(%233, %67) <{mask = array<i32: 5, 7, 5, 7, 2, 3, 4, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %240 = "llvm.shl"(%234, %68) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %241 = "llvm.shl"(%236, %69) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %242 = "llvm.shl"(%238, %70) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %243 = "llvm.call_intrinsic"(%71, %241, %237) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %244 = "llvm.call_intrinsic"(%71, %242, %239) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %245 = "llvm.call_intrinsic"(%71, %240, %235) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %246 = "llvm.shl"(%245, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %247 = "llvm.call_intrinsic"(%71, %241, %237) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %248 = "llvm.shl"(%247, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %249 = "llvm.call_intrinsic"(%71, %242, %239) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %250 = "llvm.shl"(%249, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %251 = "llvm.and"(%243, %73) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %252 = "llvm.and"(%244, %74) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %253 = "llvm.add"(%252, %251) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %254 = "llvm.call_intrinsic"(%253, %240, %235) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %255 = "llvm.and"(%248, %73) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %256 = "llvm.and"(%250, %74) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %257 = "llvm.add"(%255, %246) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %258 = "llvm.add"(%257, %256) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %259 = "llvm.and"(%243, %86) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %260 = "llvm.and"(%244, %94) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %261 = "llvm.and"(%248, %102) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %262 = "llvm.and"(%250, %110) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %263 = "llvm.add"(%262, %261) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %264 = "llvm.shufflevector"(%118, %258) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %265 = "llvm.add"(%264, %254) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %266 = "llvm.shufflevector"(%118, %263) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %267 = "llvm.shufflevector"(%258, %126) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %268 = "llvm.add"(%260, %259) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %269 = "llvm.add"(%268, %266) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %270 = "llvm.add"(%269, %267) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %271 = "llvm.and"(%265, %52) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %272 = "llvm.shufflevector"(%265, %270) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %273 = "llvm.shl"(%272, %51) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %274 = "llvm.add"(%273, %271) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %275 = "llvm.mul"(%272, %50) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %276 = "llvm.add"(%274, %275) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %277 = "llvm.and"(%276, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %278 = "llvm.lshr"(%276, %48) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %279 = "llvm.shufflevector"(%278, %67) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %280 = "llvm.call_intrinsic"(%277, %47, %279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %281 = "llvm.add"(%280, %46) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %282 = "llvm.and"(%281, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %283 = "llvm.ashr"(%281, %48) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %284 = "llvm.shufflevector"(%283, %134) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 8, 8>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %285 = "llvm.mul"(%284, %45) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %286 = "llvm.and"(%285, %44) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %287 = "llvm.add"(%284, %282) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %288 = "llvm.add"(%287, %286) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %289 = "llvm.add"(%288, %43) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %290 = "llvm.call_intrinsic"(%71, %42, %280) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %291 = "llvm.shl"(%290, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %292 = "llvm.call_intrinsic"(%291, %41, %280) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %293 = "llvm.call_intrinsic"(%71, %41, %280) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %294 = "llvm.shl"(%293, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %295 = "llvm.call_intrinsic"(%294, %40, %280) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %296 = "llvm.call_intrinsic"(%71, %40, %280) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %297 = "llvm.shl"(%296, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %298 = "llvm.call_intrinsic"(%297, %39, %280) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %299 = "llvm.call_intrinsic"(%71, %39, %280) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %300 = "llvm.shl"(%299, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %301 = "llvm.call_intrinsic"(%300, %38, %280) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %302 = "llvm.call_intrinsic"(%71, %38, %280) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %303 = "llvm.shl"(%302, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %304 = "llvm.call_intrinsic"(%303, %37, %280) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %305 = "llvm.call_intrinsic"(%71, %37, %280) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %306 = "llvm.shl"(%305, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %307 = "llvm.shufflevector"(%118, %292) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %308 = "llvm.shufflevector"(%142, %295) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %309 = "llvm.shufflevector"(%150, %298) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %310 = "llvm.shufflevector"(%298, %158) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %311 = "llvm.shufflevector"(%166, %301) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %312 = "llvm.shufflevector"(%301, %174) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %313 = "llvm.shufflevector"(%182, %304) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %314 = "llvm.shufflevector"(%304, %134) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %315 = "llvm.shufflevector"(%190, %306) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %316 = "llvm.shufflevector"(%306, %67) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %317 = "llvm.call_intrinsic"(%307, %42, %280) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %318 = "llvm.add"(%309, %308) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %319 = "llvm.add"(%318, %311) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %320 = "llvm.add"(%319, %313) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %321 = "llvm.add"(%320, %317) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %322 = "llvm.add"(%321, %315) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %323 = "llvm.add"(%312, %310) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %324 = "llvm.add"(%323, %314) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %325 = "llvm.add"(%324, %316) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %326 = "llvm.and"(%322, %52) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %327 = "llvm.shufflevector"(%322, %325) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %328 = "llvm.shl"(%327, %51) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %329 = "llvm.add"(%328, %326) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %330 = "llvm.mul"(%327, %50) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %331 = "llvm.add"(%329, %330) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %332 = "llvm.and"(%331, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %333 = "llvm.lshr"(%331, %48) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %334 = "llvm.shufflevector"(%333, %67) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %335 = "llvm.call_intrinsic"(%332, %47, %334) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %336 = "llvm.add"(%335, %36) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %337 = "llvm.shufflevector"(%336, %67) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %338 = "llvm.shufflevector"(%336, %67) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 3, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %339 = "llvm.shufflevector"(%336, %67) <{mask = array<i32: 4, 4, 1, 1, 1, 1, 1, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %340 = "llvm.shufflevector"(%336, %67) <{mask = array<i32: 4, 5, 1, 2, 3, 4, 5, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %341 = "llvm.shufflevector"(%336, %67) <{mask = array<i32: 3, 7, 5, 7, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %342 = "llvm.shufflevector"(%336, %67) <{mask = array<i32: 5, 7, 5, 7, 2, 3, 4, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %343 = "llvm.shl"(%337, %68) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %344 = "llvm.shl"(%339, %69) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %345 = "llvm.shl"(%341, %70) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %346 = "llvm.call_intrinsic"(%71, %344, %340) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %347 = "llvm.call_intrinsic"(%71, %345, %342) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %348 = "llvm.call_intrinsic"(%71, %343, %338) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %349 = "llvm.shl"(%348, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %350 = "llvm.call_intrinsic"(%71, %344, %340) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %351 = "llvm.shl"(%350, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %352 = "llvm.call_intrinsic"(%71, %345, %342) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %353 = "llvm.shl"(%352, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %354 = "llvm.and"(%346, %73) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %355 = "llvm.and"(%347, %74) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %356 = "llvm.add"(%355, %354) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %357 = "llvm.call_intrinsic"(%356, %343, %338) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %358 = "llvm.and"(%351, %73) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %359 = "llvm.and"(%353, %74) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %360 = "llvm.add"(%358, %349) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %361 = "llvm.add"(%360, %359) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %362 = "llvm.and"(%346, %86) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %363 = "llvm.and"(%347, %94) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %364 = "llvm.and"(%351, %102) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %365 = "llvm.and"(%353, %110) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %366 = "llvm.add"(%365, %364) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %367 = "llvm.shufflevector"(%118, %361) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %368 = "llvm.add"(%367, %357) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %369 = "llvm.shufflevector"(%118, %366) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %370 = "llvm.shufflevector"(%361, %126) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %371 = "llvm.add"(%363, %362) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %372 = "llvm.add"(%371, %369) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %373 = "llvm.add"(%372, %370) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %374 = "llvm.and"(%368, %52) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %375 = "llvm.shufflevector"(%368, %373) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %376 = "llvm.shl"(%375, %51) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %377 = "llvm.add"(%376, %374) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %378 = "llvm.mul"(%375, %50) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %379 = "llvm.add"(%377, %378) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %380 = "llvm.and"(%379, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %381 = "llvm.lshr"(%379, %48) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %382 = "llvm.shufflevector"(%381, %67) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %383 = "llvm.call_intrinsic"(%380, %47, %382) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %384 = "llvm.shufflevector"(%383, %67) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %385 = "llvm.shufflevector"(%383, %67) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 3, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %386 = "llvm.shufflevector"(%383, %67) <{mask = array<i32: 4, 4, 1, 1, 1, 1, 1, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %387 = "llvm.shufflevector"(%383, %67) <{mask = array<i32: 4, 5, 1, 2, 3, 4, 5, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %388 = "llvm.shufflevector"(%383, %67) <{mask = array<i32: 3, 7, 5, 7, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %389 = "llvm.shufflevector"(%383, %67) <{mask = array<i32: 5, 7, 5, 7, 2, 3, 4, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %390 = "llvm.shl"(%384, %68) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %391 = "llvm.shl"(%386, %69) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %392 = "llvm.shl"(%388, %70) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %393 = "llvm.call_intrinsic"(%71, %391, %387) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %394 = "llvm.call_intrinsic"(%71, %392, %389) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %395 = "llvm.call_intrinsic"(%71, %390, %385) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %396 = "llvm.shl"(%395, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %397 = "llvm.call_intrinsic"(%71, %391, %387) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %398 = "llvm.shl"(%397, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %399 = "llvm.call_intrinsic"(%71, %392, %389) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %400 = "llvm.shl"(%399, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %401 = "llvm.and"(%393, %73) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %402 = "llvm.and"(%394, %74) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %403 = "llvm.add"(%402, %401) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %404 = "llvm.call_intrinsic"(%403, %390, %385) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %405 = "llvm.and"(%398, %73) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %406 = "llvm.and"(%400, %74) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %407 = "llvm.add"(%405, %396) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %408 = "llvm.add"(%407, %406) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %409 = "llvm.and"(%393, %86) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %410 = "llvm.and"(%394, %94) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %411 = "llvm.and"(%398, %102) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %412 = "llvm.and"(%400, %110) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %413 = "llvm.add"(%412, %411) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %414 = "llvm.shufflevector"(%118, %408) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %415 = "llvm.add"(%414, %404) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %416 = "llvm.shufflevector"(%118, %413) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %417 = "llvm.shufflevector"(%408, %126) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %418 = "llvm.add"(%410, %409) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %419 = "llvm.add"(%418, %416) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %420 = "llvm.add"(%419, %417) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %421 = "llvm.and"(%415, %52) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %422 = "llvm.shufflevector"(%415, %420) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %423 = "llvm.shl"(%422, %51) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %424 = "llvm.add"(%423, %421) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %425 = "llvm.mul"(%422, %50) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %426 = "llvm.add"(%424, %425) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %427 = "llvm.and"(%426, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %428 = "llvm.lshr"(%426, %48) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %429 = "llvm.shufflevector"(%428, %67) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %430 = "llvm.call_intrinsic"(%427, %47, %429) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %431 = "llvm.shufflevector"(%336, %67) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %432 = "llvm.shufflevector"(%336, %67) <{mask = array<i32: 1, 1, 1, 1, 1, 1, 1, 1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %433 = "llvm.shufflevector"(%336, %67) <{mask = array<i32: 2, 2, 2, 2, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %434 = "llvm.shufflevector"(%336, %67) <{mask = array<i32: 3, 3, 3, 3, 3, 3, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %435 = "llvm.shufflevector"(%336, %67) <{mask = array<i32: 4, 4, 4, 4, 4, 4, 4, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %436 = "llvm.shufflevector"(%336, %67) <{mask = array<i32: 5, 5, 5, 5, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %437 = "llvm.call_intrinsic"(%71, %431, %383) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %438 = "llvm.shl"(%437, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %439 = "llvm.call_intrinsic"(%438, %432, %383) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %440 = "llvm.call_intrinsic"(%71, %432, %383) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %441 = "llvm.shl"(%440, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %442 = "llvm.call_intrinsic"(%441, %433, %383) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %443 = "llvm.call_intrinsic"(%71, %433, %383) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %444 = "llvm.shl"(%443, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %445 = "llvm.call_intrinsic"(%444, %434, %383) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %446 = "llvm.call_intrinsic"(%71, %434, %383) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %447 = "llvm.shl"(%446, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %448 = "llvm.call_intrinsic"(%447, %435, %383) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %449 = "llvm.call_intrinsic"(%71, %435, %383) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %450 = "llvm.shl"(%449, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %451 = "llvm.call_intrinsic"(%450, %436, %383) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %452 = "llvm.call_intrinsic"(%71, %436, %383) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %453 = "llvm.shl"(%452, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %454 = "llvm.shufflevector"(%118, %439) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %455 = "llvm.shufflevector"(%142, %442) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %456 = "llvm.shufflevector"(%150, %445) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %457 = "llvm.shufflevector"(%445, %158) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %458 = "llvm.shufflevector"(%166, %448) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %459 = "llvm.shufflevector"(%448, %174) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %460 = "llvm.shufflevector"(%182, %451) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %461 = "llvm.shufflevector"(%451, %134) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %462 = "llvm.shufflevector"(%190, %453) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %463 = "llvm.shufflevector"(%453, %67) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %464 = "llvm.call_intrinsic"(%454, %431, %383) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %465 = "llvm.add"(%456, %455) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %466 = "llvm.add"(%465, %458) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %467 = "llvm.add"(%466, %460) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %468 = "llvm.add"(%467, %464) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %469 = "llvm.add"(%468, %462) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %470 = "llvm.add"(%459, %457) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %471 = "llvm.add"(%470, %461) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %472 = "llvm.add"(%471, %463) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %473 = "llvm.and"(%469, %52) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %474 = "llvm.shufflevector"(%469, %472) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %475 = "llvm.shl"(%474, %51) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %476 = "llvm.add"(%475, %473) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %477 = "llvm.mul"(%474, %50) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %478 = "llvm.add"(%476, %477) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %479 = "llvm.and"(%478, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %480 = "llvm.lshr"(%478, %48) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %481 = "llvm.shufflevector"(%480, %67) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %482 = "llvm.call_intrinsic"(%479, %47, %481) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %483 = "llvm.shufflevector"(%289, %67) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %484 = "llvm.shufflevector"(%289, %67) <{mask = array<i32: 1, 1, 1, 1, 1, 1, 1, 1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %485 = "llvm.shufflevector"(%289, %67) <{mask = array<i32: 2, 2, 2, 2, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %486 = "llvm.shufflevector"(%289, %67) <{mask = array<i32: 3, 3, 3, 3, 3, 3, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %487 = "llvm.shufflevector"(%289, %67) <{mask = array<i32: 4, 4, 4, 4, 4, 4, 4, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %488 = "llvm.shufflevector"(%289, %67) <{mask = array<i32: 5, 5, 5, 5, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %489 = "llvm.call_intrinsic"(%71, %483, %482) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %490 = "llvm.shl"(%489, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %491 = "llvm.call_intrinsic"(%490, %484, %482) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %492 = "llvm.call_intrinsic"(%71, %484, %482) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %493 = "llvm.shl"(%492, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %494 = "llvm.call_intrinsic"(%493, %485, %482) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %495 = "llvm.call_intrinsic"(%71, %485, %482) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %496 = "llvm.shl"(%495, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %497 = "llvm.call_intrinsic"(%496, %486, %482) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %498 = "llvm.call_intrinsic"(%71, %486, %482) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %499 = "llvm.shl"(%498, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %500 = "llvm.call_intrinsic"(%499, %487, %482) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %501 = "llvm.call_intrinsic"(%71, %487, %482) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %502 = "llvm.shl"(%501, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %503 = "llvm.call_intrinsic"(%502, %488, %482) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %504 = "llvm.call_intrinsic"(%71, %488, %482) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %505 = "llvm.shl"(%504, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %506 = "llvm.shufflevector"(%118, %491) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %507 = "llvm.shufflevector"(%142, %494) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %508 = "llvm.shufflevector"(%150, %497) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %509 = "llvm.shufflevector"(%497, %158) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %510 = "llvm.shufflevector"(%166, %500) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %511 = "llvm.shufflevector"(%500, %174) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %512 = "llvm.shufflevector"(%182, %503) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %513 = "llvm.shufflevector"(%503, %134) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %514 = "llvm.shufflevector"(%190, %505) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %515 = "llvm.shufflevector"(%505, %67) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %516 = "llvm.call_intrinsic"(%506, %483, %482) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %517 = "llvm.add"(%508, %507) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %518 = "llvm.add"(%517, %510) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %519 = "llvm.add"(%518, %512) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %520 = "llvm.add"(%519, %516) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %521 = "llvm.add"(%520, %514) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %522 = "llvm.add"(%511, %509) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %523 = "llvm.add"(%522, %513) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %524 = "llvm.add"(%523, %515) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %525 = "llvm.and"(%521, %52) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %526 = "llvm.shufflevector"(%521, %524) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %527 = "llvm.shl"(%526, %51) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %528 = "llvm.add"(%527, %525) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %529 = "llvm.mul"(%526, %50) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %530 = "llvm.add"(%528, %529) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %531 = "llvm.and"(%530, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %532 = "llvm.lshr"(%530, %48) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %533 = "llvm.shufflevector"(%532, %67) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %534 = "llvm.call_intrinsic"(%531, %47, %533) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %535 = "llvm.shufflevector"(%534, %67) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %536 = "llvm.shufflevector"(%534, %67) <{mask = array<i32: 1, 1, 1, 1, 1, 1, 1, 1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %537 = "llvm.shufflevector"(%534, %67) <{mask = array<i32: 2, 2, 2, 2, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %538 = "llvm.shufflevector"(%534, %67) <{mask = array<i32: 3, 3, 3, 3, 3, 3, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %539 = "llvm.shufflevector"(%534, %67) <{mask = array<i32: 4, 4, 4, 4, 4, 4, 4, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %540 = "llvm.shufflevector"(%534, %67) <{mask = array<i32: 5, 5, 5, 5, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %541 = "llvm.call_intrinsic"(%71, %535, %430) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %542 = "llvm.shl"(%541, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %543 = "llvm.call_intrinsic"(%542, %536, %430) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %544 = "llvm.call_intrinsic"(%71, %536, %430) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %545 = "llvm.shl"(%544, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %546 = "llvm.call_intrinsic"(%545, %537, %430) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %547 = "llvm.call_intrinsic"(%71, %537, %430) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %548 = "llvm.shl"(%547, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %549 = "llvm.call_intrinsic"(%548, %538, %430) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %550 = "llvm.call_intrinsic"(%71, %538, %430) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %551 = "llvm.shl"(%550, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %552 = "llvm.call_intrinsic"(%551, %539, %430) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %553 = "llvm.call_intrinsic"(%71, %539, %430) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %554 = "llvm.shl"(%553, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %555 = "llvm.call_intrinsic"(%554, %540, %430) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %556 = "llvm.call_intrinsic"(%71, %540, %430) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %557 = "llvm.shl"(%556, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %558 = "llvm.shufflevector"(%118, %543) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %559 = "llvm.shufflevector"(%142, %546) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %560 = "llvm.shufflevector"(%150, %549) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %561 = "llvm.shufflevector"(%549, %158) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %562 = "llvm.shufflevector"(%166, %552) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %563 = "llvm.shufflevector"(%552, %174) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %564 = "llvm.shufflevector"(%182, %555) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %565 = "llvm.shufflevector"(%555, %134) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %566 = "llvm.shufflevector"(%190, %557) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %567 = "llvm.shufflevector"(%557, %67) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %568 = "llvm.call_intrinsic"(%558, %535, %430) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %569 = "llvm.add"(%560, %559) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %570 = "llvm.add"(%569, %562) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %571 = "llvm.add"(%570, %564) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %572 = "llvm.add"(%571, %568) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %573 = "llvm.add"(%572, %566) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %574 = "llvm.add"(%563, %561) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %575 = "llvm.add"(%574, %565) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %576 = "llvm.add"(%575, %567) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %577 = "llvm.and"(%573, %52) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %578 = "llvm.shufflevector"(%573, %576) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %579 = "llvm.shl"(%578, %51) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %580 = "llvm.add"(%579, %577) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %581 = "llvm.mul"(%578, %50) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %582 = "llvm.add"(%580, %581) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %583 = "llvm.and"(%582, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %584 = "llvm.lshr"(%582, %48) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %585 = "llvm.shufflevector"(%584, %67) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %586 = "llvm.call_intrinsic"(%583, %47, %585) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %587 = "llvm.call"(%586) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_pow22523, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> vector<8xi64>
  %588 = "llvm.call_intrinsic"(%71, %535, %587) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %589 = "llvm.shl"(%588, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %590 = "llvm.call_intrinsic"(%589, %536, %587) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %591 = "llvm.call_intrinsic"(%71, %536, %587) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %592 = "llvm.shl"(%591, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %593 = "llvm.call_intrinsic"(%592, %537, %587) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %594 = "llvm.call_intrinsic"(%71, %537, %587) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %595 = "llvm.shl"(%594, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %596 = "llvm.call_intrinsic"(%595, %538, %587) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %597 = "llvm.call_intrinsic"(%71, %538, %587) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %598 = "llvm.shl"(%597, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %599 = "llvm.call_intrinsic"(%598, %539, %587) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %600 = "llvm.call_intrinsic"(%71, %539, %587) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %601 = "llvm.shl"(%600, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %602 = "llvm.call_intrinsic"(%601, %540, %587) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %603 = "llvm.call_intrinsic"(%71, %540, %587) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %604 = "llvm.shl"(%603, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %605 = "llvm.shufflevector"(%118, %590) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %606 = "llvm.shufflevector"(%142, %593) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %607 = "llvm.shufflevector"(%150, %596) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %608 = "llvm.shufflevector"(%596, %158) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %609 = "llvm.shufflevector"(%166, %599) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %610 = "llvm.shufflevector"(%599, %174) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %611 = "llvm.shufflevector"(%182, %602) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %612 = "llvm.shufflevector"(%602, %134) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %613 = "llvm.shufflevector"(%190, %604) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %614 = "llvm.shufflevector"(%604, %67) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %615 = "llvm.call_intrinsic"(%605, %535, %587) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %616 = "llvm.add"(%607, %606) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %617 = "llvm.add"(%616, %609) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %618 = "llvm.add"(%617, %611) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %619 = "llvm.add"(%618, %615) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %620 = "llvm.add"(%619, %613) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %621 = "llvm.add"(%610, %608) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %622 = "llvm.add"(%621, %612) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %623 = "llvm.add"(%622, %614) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %624 = "llvm.and"(%620, %52) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %625 = "llvm.shufflevector"(%620, %623) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %626 = "llvm.shl"(%625, %51) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %627 = "llvm.add"(%626, %624) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %628 = "llvm.mul"(%625, %50) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %629 = "llvm.add"(%627, %628) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %630 = "llvm.and"(%629, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %631 = "llvm.lshr"(%629, %48) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %632 = "llvm.shufflevector"(%631, %67) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %633 = "llvm.call_intrinsic"(%630, %47, %632) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %634 = "llvm.shufflevector"(%633, %67) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %635 = "llvm.shufflevector"(%633, %67) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 3, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %636 = "llvm.shufflevector"(%633, %67) <{mask = array<i32: 4, 4, 1, 1, 1, 1, 1, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %637 = "llvm.shufflevector"(%633, %67) <{mask = array<i32: 4, 5, 1, 2, 3, 4, 5, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %638 = "llvm.shufflevector"(%633, %67) <{mask = array<i32: 3, 7, 5, 7, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %639 = "llvm.shufflevector"(%633, %67) <{mask = array<i32: 5, 7, 5, 7, 2, 3, 4, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %640 = "llvm.shl"(%634, %68) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %641 = "llvm.shl"(%636, %69) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %642 = "llvm.shl"(%638, %70) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %643 = "llvm.call_intrinsic"(%71, %641, %637) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %644 = "llvm.call_intrinsic"(%71, %642, %639) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %645 = "llvm.call_intrinsic"(%71, %640, %635) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %646 = "llvm.shl"(%645, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %647 = "llvm.call_intrinsic"(%71, %641, %637) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %648 = "llvm.shl"(%647, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %649 = "llvm.call_intrinsic"(%71, %642, %639) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %650 = "llvm.shl"(%649, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %651 = "llvm.and"(%643, %73) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %652 = "llvm.and"(%644, %74) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %653 = "llvm.add"(%652, %651) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %654 = "llvm.call_intrinsic"(%653, %640, %635) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %655 = "llvm.and"(%648, %73) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %656 = "llvm.and"(%650, %74) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %657 = "llvm.add"(%655, %646) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %658 = "llvm.add"(%657, %656) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %659 = "llvm.and"(%643, %86) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %660 = "llvm.and"(%644, %94) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %661 = "llvm.and"(%648, %102) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %662 = "llvm.and"(%650, %110) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %663 = "llvm.add"(%662, %661) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %664 = "llvm.shufflevector"(%118, %658) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %665 = "llvm.add"(%664, %654) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %666 = "llvm.shufflevector"(%118, %663) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %667 = "llvm.shufflevector"(%658, %126) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %668 = "llvm.add"(%660, %659) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %669 = "llvm.add"(%668, %666) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %670 = "llvm.add"(%669, %667) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %671 = "llvm.and"(%665, %52) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %672 = "llvm.shufflevector"(%665, %670) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %673 = "llvm.shl"(%672, %51) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %674 = "llvm.add"(%673, %671) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %675 = "llvm.mul"(%672, %50) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %676 = "llvm.add"(%674, %675) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %677 = "llvm.and"(%676, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %678 = "llvm.lshr"(%676, %48) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %679 = "llvm.shufflevector"(%678, %67) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %680 = "llvm.call_intrinsic"(%677, %47, %679) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %681 = "llvm.call_intrinsic"(%71, %431, %680) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %682 = "llvm.shl"(%681, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %683 = "llvm.call_intrinsic"(%682, %432, %680) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %684 = "llvm.call_intrinsic"(%71, %432, %680) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %685 = "llvm.shl"(%684, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %686 = "llvm.call_intrinsic"(%685, %433, %680) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %687 = "llvm.call_intrinsic"(%71, %433, %680) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %688 = "llvm.shl"(%687, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %689 = "llvm.call_intrinsic"(%688, %434, %680) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %690 = "llvm.call_intrinsic"(%71, %434, %680) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %691 = "llvm.shl"(%690, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %692 = "llvm.call_intrinsic"(%691, %435, %680) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %693 = "llvm.call_intrinsic"(%71, %435, %680) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %694 = "llvm.shl"(%693, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %695 = "llvm.call_intrinsic"(%694, %436, %680) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %696 = "llvm.call_intrinsic"(%71, %436, %680) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %697 = "llvm.shl"(%696, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %698 = "llvm.shufflevector"(%118, %683) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %699 = "llvm.shufflevector"(%142, %686) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %700 = "llvm.shufflevector"(%150, %689) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %701 = "llvm.shufflevector"(%689, %158) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %702 = "llvm.shufflevector"(%166, %692) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %703 = "llvm.shufflevector"(%692, %174) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %704 = "llvm.shufflevector"(%182, %695) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %705 = "llvm.shufflevector"(%695, %134) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %706 = "llvm.shufflevector"(%190, %697) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %707 = "llvm.shufflevector"(%697, %67) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %708 = "llvm.call_intrinsic"(%698, %431, %680) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %709 = "llvm.add"(%700, %699) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %710 = "llvm.add"(%709, %702) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %711 = "llvm.add"(%710, %704) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %712 = "llvm.add"(%711, %708) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %713 = "llvm.add"(%712, %706) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %714 = "llvm.add"(%703, %701) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %715 = "llvm.add"(%714, %705) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %716 = "llvm.add"(%715, %707) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %717 = "llvm.and"(%713, %52) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %718 = "llvm.shufflevector"(%713, %716) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %719 = "llvm.shl"(%718, %51) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %720 = "llvm.add"(%719, %717) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %721 = "llvm.mul"(%718, %50) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %722 = "llvm.add"(%720, %721) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %723 = "llvm.and"(%722, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %724 = "llvm.lshr"(%722, %48) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %725 = "llvm.shufflevector"(%724, %67) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %726 = "llvm.call_intrinsic"(%723, %47, %725) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %727 = "llvm.sub"(%726, %288) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %728 = "llvm.add"(%727, %198) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %729 = "llvm.add"(%726, %289) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %730 = "llvm.shufflevector"(%729, %728) <{mask = array<i32: 1, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<2xi64>
  %731 = "llvm.shufflevector"(%729, %728) <{mask = array<i32: 2, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<2xi64>
  %732 = "llvm.shufflevector"(%729, %728) <{mask = array<i32: 3, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<2xi64>
  %733 = "llvm.shufflevector"(%729, %728) <{mask = array<i32: 4, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<2xi64>
  %734 = "llvm.shufflevector"(%729, %728) <{mask = array<i32: 5, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<2xi64>
  %735 = "llvm.add"(%734, %32) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %736 = "llvm.and"(%735, %31) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %737 = "llvm.ashr"(%735, %30) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %738 = "llvm.mul"(%737, %29) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %739 = "llvm.shufflevector"(%729, %728) <{mask = array<i32: 0, 8>}> : (vector<8xi64>, vector<8xi64>) -> vector<2xi64>
  %740 = "llvm.add"(%738, %739) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %741 = "llvm.add"(%736, %28) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %742 = "llvm.ashr"(%740, %27) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %743 = "llvm.add"(%742, %730) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %744 = "llvm.ashr"(%743, %27) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %745 = "llvm.add"(%744, %731) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %746 = "llvm.ashr"(%745, %27) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %747 = "llvm.add"(%746, %732) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %748 = "llvm.ashr"(%747, %27) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %749 = "llvm.add"(%748, %733) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %750 = "llvm.and"(%740, %26) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %751 = "llvm.and"(%743, %26) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %752 = "llvm.and"(%745, %26) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %753 = "llvm.and"(%747, %26) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %754 = "llvm.ashr"(%749, %27) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %755 = "llvm.and"(%749, %26) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %756 = "llvm.add"(%750, %29) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %757 = "llvm.lshr"(%756, %27) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %758 = "llvm.and"(%756, %26) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %759 = "llvm.add"(%751, %757) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %760 = "llvm.lshr"(%759, %27) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %761 = "llvm.and"(%759, %26) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %762 = "llvm.add"(%752, %760) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %763 = "llvm.lshr"(%762, %27) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %764 = "llvm.and"(%762, %26) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %765 = "llvm.add"(%753, %763) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %766 = "llvm.lshr"(%765, %27) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %767 = "llvm.and"(%765, %26) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %768 = "llvm.add"(%755, %766) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %769 = "llvm.lshr"(%768, %27) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %770 = "llvm.and"(%768, %26) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %771 = "llvm.add"(%741, %754) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %772 = "llvm.add"(%771, %769) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %773 = "llvm.and"(%772, %31) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %774 = "llvm.icmp"(%772, %25) <{predicate = 6 : i64}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi1>
  %775 = "llvm.select"(%774, %24, %23) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<2xi1>, vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %776 = "llvm.add"(%775, %758) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %777 = "llvm.ashr"(%776, %27) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %778 = "llvm.add"(%777, %761) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %779 = "llvm.ashr"(%778, %27) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %780 = "llvm.add"(%779, %764) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %781 = "llvm.ashr"(%780, %27) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %782 = "llvm.add"(%781, %767) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %783 = "llvm.ashr"(%782, %27) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %784 = "llvm.add"(%783, %770) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %785 = "llvm.ashr"(%784, %27) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %786 = "llvm.add"(%785, %773) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %787 = "llvm.or"(%778, %776) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %788 = "llvm.or"(%787, %780) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %789 = "llvm.or"(%788, %782) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %790 = "llvm.or"(%789, %784) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %791 = "llvm.and"(%790, %26) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %792 = "llvm.or"(%791, %786) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %793 = "llvm.icmp"(%792, %23) <{predicate = 1 : i64}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi1>
  %794 = "llvm.extractelement"(%793, %62) : (vector<2xi1>, i64) -> i1
  %795 = "llvm.extractelement"(%793, %22) : (vector<2xi1>, i64) -> i1
  %796 = "llvm.and"(%794, %795) : (i1, i1) -> i1
  "llvm.cond_br"(%796)[^bb2, ^bb1] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb1:  // pred: ^bb0
  %797 = "llvm.lshr"(%224, %21) : (i64, i64) -> i64
  %798 = "llvm.trunc"(%797) <{overflowFlags = 3 : i32}> : (i64) -> i32
  %799 = "llvm.xor"(%795, %20) : (i1, i1) -> i1
  %800 = "llvm.sext"(%799) : (i1) -> i8
  %801 = "llvm.bitcast"(%800) : (i8) -> vector<8xi1>
  %802 = "llvm.select"(%801, %36, %19) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %803 = "llvm.shufflevector"(%633, %67) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %804 = "llvm.shufflevector"(%633, %67) <{mask = array<i32: 1, 1, 1, 1, 1, 1, 1, 1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %805 = "llvm.shufflevector"(%633, %67) <{mask = array<i32: 2, 2, 2, 2, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %806 = "llvm.shufflevector"(%633, %67) <{mask = array<i32: 3, 3, 3, 3, 3, 3, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %807 = "llvm.shufflevector"(%633, %67) <{mask = array<i32: 4, 4, 4, 4, 4, 4, 4, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %808 = "llvm.shufflevector"(%633, %67) <{mask = array<i32: 5, 5, 5, 5, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %809 = "llvm.call_intrinsic"(%71, %803, %802) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %810 = "llvm.shl"(%809, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %811 = "llvm.call_intrinsic"(%810, %804, %802) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %812 = "llvm.call_intrinsic"(%71, %804, %802) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %813 = "llvm.shl"(%812, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %814 = "llvm.call_intrinsic"(%813, %805, %802) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %815 = "llvm.call_intrinsic"(%71, %805, %802) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %816 = "llvm.shl"(%815, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %817 = "llvm.call_intrinsic"(%816, %806, %802) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %818 = "llvm.call_intrinsic"(%71, %806, %802) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %819 = "llvm.shl"(%818, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %820 = "llvm.call_intrinsic"(%819, %807, %802) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %821 = "llvm.call_intrinsic"(%71, %807, %802) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %822 = "llvm.shl"(%821, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %823 = "llvm.call_intrinsic"(%822, %808, %802) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %824 = "llvm.call_intrinsic"(%71, %808, %802) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %825 = "llvm.shl"(%824, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %826 = "llvm.shufflevector"(%118, %811) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %827 = "llvm.shufflevector"(%142, %814) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %828 = "llvm.shufflevector"(%150, %817) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %829 = "llvm.shufflevector"(%817, %158) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %830 = "llvm.shufflevector"(%166, %820) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %831 = "llvm.shufflevector"(%820, %174) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %832 = "llvm.shufflevector"(%182, %823) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %833 = "llvm.shufflevector"(%823, %134) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %834 = "llvm.shufflevector"(%190, %825) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %835 = "llvm.shufflevector"(%825, %67) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %836 = "llvm.call_intrinsic"(%826, %803, %802) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %837 = "llvm.add"(%828, %827) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %838 = "llvm.add"(%837, %830) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %839 = "llvm.add"(%838, %832) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %840 = "llvm.add"(%839, %836) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %841 = "llvm.add"(%840, %834) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %842 = "llvm.add"(%831, %829) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %843 = "llvm.add"(%842, %833) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %844 = "llvm.add"(%843, %835) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %845 = "llvm.and"(%841, %52) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %846 = "llvm.shufflevector"(%841, %844) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %847 = "llvm.shl"(%846, %51) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %848 = "llvm.add"(%847, %845) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %849 = "llvm.mul"(%846, %50) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %850 = "llvm.add"(%848, %849) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %851 = "llvm.and"(%850, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %852 = "llvm.lshr"(%850, %48) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %853 = "llvm.shufflevector"(%852, %67) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %854 = "llvm.call_intrinsic"(%851, %47, %853) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %855 = "llvm.extractelement"(%854, %62) : (vector<8xi64>, i64) -> i64
  %856 = "llvm.extractelement"(%854, %22) : (vector<8xi64>, i64) -> i64
  %857 = "llvm.extractelement"(%854, %18) : (vector<8xi64>, i64) -> i64
  %858 = "llvm.extractelement"(%854, %17) : (vector<8xi64>, i64) -> i64
  %859 = "llvm.extractelement"(%854, %16) : (vector<8xi64>, i64) -> i64
  %860 = "llvm.extractelement"(%854, %15) : (vector<8xi64>, i64) -> i64
  %861 = "llvm.add"(%860, %14) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %862 = "llvm.ashr"(%861, %13) : (i64, i64) -> i64
  %863 = "llvm.and"(%861, %12) : (i64, i64) -> i64
  %864 = "llvm.mul"(%862, %11) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %865 = "llvm.add"(%864, %855) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %866 = "llvm.ashr"(%865, %10) : (i64, i64) -> i64
  %867 = "llvm.and"(%865, %9) : (i64, i64) -> i64
  %868 = "llvm.add"(%866, %856) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %869 = "llvm.ashr"(%868, %10) : (i64, i64) -> i64
  %870 = "llvm.and"(%868, %9) : (i64, i64) -> i64
  %871 = "llvm.add"(%869, %857) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %872 = "llvm.ashr"(%871, %10) : (i64, i64) -> i64
  %873 = "llvm.and"(%871, %9) : (i64, i64) -> i64
  %874 = "llvm.add"(%872, %858) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %875 = "llvm.ashr"(%874, %10) : (i64, i64) -> i64
  %876 = "llvm.and"(%874, %9) : (i64, i64) -> i64
  %877 = "llvm.add"(%875, %859) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %878 = "llvm.ashr"(%877, %10) : (i64, i64) -> i64
  %879 = "llvm.and"(%877, %9) : (i64, i64) -> i64
  %880 = "llvm.add"(%867, %11) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %881 = "llvm.lshr"(%880, %10) : (i64, i64) -> i64
  %882 = "llvm.and"(%880, %9) : (i64, i64) -> i64
  %883 = "llvm.add"(%870, %881) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %884 = "llvm.lshr"(%883, %10) : (i64, i64) -> i64
  %885 = "llvm.and"(%883, %9) : (i64, i64) -> i64
  %886 = "llvm.add"(%873, %884) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %887 = "llvm.lshr"(%886, %10) : (i64, i64) -> i64
  %888 = "llvm.and"(%886, %9) : (i64, i64) -> i64
  %889 = "llvm.add"(%876, %887) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %890 = "llvm.lshr"(%889, %10) : (i64, i64) -> i64
  %891 = "llvm.and"(%889, %9) : (i64, i64) -> i64
  %892 = "llvm.add"(%879, %890) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %893 = "llvm.lshr"(%892, %10) : (i64, i64) -> i64
  %894 = "llvm.and"(%892, %9) : (i64, i64) -> i64
  %895 = "llvm.add"(%863, %8) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %896 = "llvm.add"(%895, %878) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %897 = "llvm.add"(%896, %893) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %898 = "llvm.and"(%897, %12) : (i64, i64) -> i64
  %899 = "llvm.icmp"(%897, %7) <{predicate = 6 : i64}> : (i64, i64) -> i1
  %900 = "llvm.select"(%899, %6, %62) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %901 = "llvm.add"(%900, %882) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %902 = "llvm.ashr"(%901, %10) : (i64, i64) -> i64
  %903 = "llvm.add"(%902, %885) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %904 = "llvm.ashr"(%903, %10) : (i64, i64) -> i64
  %905 = "llvm.add"(%904, %888) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %906 = "llvm.ashr"(%905, %10) : (i64, i64) -> i64
  %907 = "llvm.add"(%906, %891) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %908 = "llvm.ashr"(%907, %10) : (i64, i64) -> i64
  %909 = "llvm.add"(%908, %894) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %910 = "llvm.ashr"(%909, %10) : (i64, i64) -> i64
  %911 = "llvm.add"(%910, %898) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %912 = "llvm.or"(%903, %901) : (i64, i64) -> i64
  %913 = "llvm.or"(%912, %905) : (i64, i64) -> i64
  %914 = "llvm.or"(%913, %907) : (i64, i64) -> i64
  %915 = "llvm.or"(%914, %909) : (i64, i64) -> i64
  %916 = "llvm.and"(%915, %9) : (i64, i64) -> i64
  %917 = "llvm.or"(%916, %911) : (i64, i64) -> i64
  %918 = "llvm.icmp"(%917, %62) <{predicate = 1 : i64}> : (i64, i64) -> i1
  %919 = "llvm.trunc"(%901) <{overflowFlags = 0 : i32}> : (i64) -> i32
  %920 = "llvm.and"(%919, %59) : (i32, i32) -> i32
  %921 = "llvm.icmp"(%920, %798) <{predicate = 0 : i64}> : (i32, i32) -> i1
  %922 = "llvm.select"(%918, %921, %5) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i1, i1) -> i1
  %923 = "llvm.sext"(%922) : (i1) -> i8
  %924 = "llvm.sub"(%4, %854) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %925 = "llvm.and"(%924, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %926 = "llvm.ashr"(%924, %48) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %927 = "llvm.shufflevector"(%926, %134) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 8, 8>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %928 = "llvm.mul"(%927, %45) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %929 = "llvm.and"(%928, %44) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %930 = "llvm.add"(%925, %43) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %931 = "llvm.add"(%930, %927) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %932 = "llvm.add"(%931, %929) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %933 = "llvm.bitcast"(%923) : (i8) -> vector<8xi1>
  %934 = "llvm.select"(%933, %854, %932) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %935 = "llvm.shufflevector"(%934, %67) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %936 = "llvm.shufflevector"(%934, %67) <{mask = array<i32: 1, 1, 1, 1, 1, 1, 1, 1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %937 = "llvm.shufflevector"(%934, %67) <{mask = array<i32: 2, 2, 2, 2, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %938 = "llvm.shufflevector"(%934, %67) <{mask = array<i32: 3, 3, 3, 3, 3, 3, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %939 = "llvm.shufflevector"(%934, %67) <{mask = array<i32: 4, 4, 4, 4, 4, 4, 4, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %940 = "llvm.shufflevector"(%934, %67) <{mask = array<i32: 5, 5, 5, 5, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %941 = "llvm.call_intrinsic"(%71, %935, %233) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %942 = "llvm.shl"(%941, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %943 = "llvm.call_intrinsic"(%942, %936, %233) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %944 = "llvm.call_intrinsic"(%71, %936, %233) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %945 = "llvm.shl"(%944, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %946 = "llvm.call_intrinsic"(%945, %937, %233) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %947 = "llvm.call_intrinsic"(%71, %937, %233) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %948 = "llvm.shl"(%947, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %949 = "llvm.call_intrinsic"(%948, %938, %233) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %950 = "llvm.call_intrinsic"(%71, %938, %233) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %951 = "llvm.shl"(%950, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %952 = "llvm.call_intrinsic"(%951, %939, %233) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %953 = "llvm.call_intrinsic"(%71, %939, %233) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %954 = "llvm.shl"(%953, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %955 = "llvm.call_intrinsic"(%954, %940, %233) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %956 = "llvm.call_intrinsic"(%71, %940, %233) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %957 = "llvm.shl"(%956, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %958 = "llvm.shufflevector"(%118, %943) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %959 = "llvm.shufflevector"(%142, %946) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %960 = "llvm.shufflevector"(%150, %949) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %961 = "llvm.shufflevector"(%949, %158) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %962 = "llvm.shufflevector"(%166, %952) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %963 = "llvm.shufflevector"(%952, %174) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %964 = "llvm.shufflevector"(%182, %955) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %965 = "llvm.shufflevector"(%955, %134) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %966 = "llvm.shufflevector"(%190, %957) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %967 = "llvm.shufflevector"(%957, %67) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %968 = "llvm.call_intrinsic"(%958, %935, %233) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %969 = "llvm.add"(%960, %959) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %970 = "llvm.add"(%969, %962) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %971 = "llvm.add"(%970, %964) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %972 = "llvm.add"(%971, %968) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %973 = "llvm.add"(%972, %966) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %974 = "llvm.add"(%963, %961) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %975 = "llvm.add"(%974, %965) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %976 = "llvm.add"(%975, %967) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %977 = "llvm.and"(%973, %52) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %978 = "llvm.shufflevector"(%973, %976) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %979 = "llvm.shl"(%978, %51) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %980 = "llvm.add"(%979, %977) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %981 = "llvm.mul"(%978, %50) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %982 = "llvm.add"(%980, %981) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %983 = "llvm.and"(%982, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %984 = "llvm.lshr"(%982, %48) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %985 = "llvm.shufflevector"(%984, %67) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %986 = "llvm.call_intrinsic"(%983, %47, %985) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %987 = "llvm.shufflevector"(%934, %206) <{mask = array<i32: 0, 1, 8, 9, 4, 5, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %988 = "llvm.shufflevector"(%233, %986) <{mask = array<i32: 0, 1, 8, 9, 4, 5, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %989 = "llvm.shufflevector"(%934, %214) <{mask = array<i32: 2, 3, 10, 11, 6, 7, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %990 = "llvm.shufflevector"(%233, %986) <{mask = array<i32: 2, 3, 10, 11, 6, 7, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %991 = "llvm.shufflevector"(%987, %988) <{mask = array<i32: 0, 8, 2, 10, -1, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %992 = "llvm.shufflevector"(%987, %988) <{mask = array<i32: -1, -1, -1, -1, 5, 13, 7, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %993 = "llvm.shufflevector"(%989, %990) <{mask = array<i32: 0, 8, 2, 10, -1, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %994 = "llvm.shufflevector"(%989, %990) <{mask = array<i32: 1, 9, 3, 11, -1, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %995 = "llvm.shufflevector"(%991, %994) <{mask = array<i32: 0, 1, 2, 3, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%995, %arg0) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %996 = "llvm.shufflevector"(%987, %988) <{mask = array<i32: 1, 9, 3, 11, 4, 12, 6, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%996, %arg1) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %997 = "llvm.shufflevector"(%993, %992) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%997, %arg2) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %998 = "llvm.load"(%arg0) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %999 = "llvm.lshr"(%998, %3) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1000 = "llvm.load"(%arg1) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1001 = "llvm.lshr"(%1000, %3) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1002 = "llvm.lshr"(%997, %2) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1003 = "llvm.mul"(%1002, %222) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1004 = "llvm.and"(%998, %66) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1005 = "llvm.shufflevector"(%1003, %1002) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1006 = "llvm.add"(%1005, %1004) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1006, %arg0) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1007 = "llvm.load"(%arg1) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1008 = "llvm.and"(%1007, %66) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1009 = "llvm.add"(%1008, %999) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1009, %arg1) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1010 = "llvm.load"(%arg2) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1011 = "llvm.and"(%1010, %1) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1012 = "llvm.add"(%1011, %1001) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.br"(%1012, %78)[^bb3] : (vector<8xi64>, i32) -> ()
^bb2:  // pred: ^bb0
  "llvm.store"(%71, %arg0) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%71, %arg1) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.br"(%71, %0)[^bb3] : (vector<8xi64>, i32) -> ()
^bb3(%1013: vector<8xi64>, %1014: i32):  // 2 preds: ^bb1, ^bb2
  "llvm.store"(%1013, %arg2) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.return"(%1014) : (i32) -> ()
}) : () -> ()

    with
      @fd_r43x6_pow22523 := Firedancer.Lane.Mlir.fd_r43x6_pow22523

end

end Firedancer.Lane.Mlir
