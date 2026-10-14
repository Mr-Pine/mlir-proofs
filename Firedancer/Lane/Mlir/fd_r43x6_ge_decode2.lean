
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.Lane.Mlir.fd_r43x6_pow22523_2

namespace Firedancer.Lane.Mlir

@[expose] public section

noncomputable mlir_def fd_r43x6_ge_decode2 := "llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.nofree, llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<i32 (ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr)>, linkage = #llvm.linkage<external>, no_unwind, passthrough = ["sspstrong", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], res_attrs = [{llvm.range = #llvm.constant_range<i32, -2, 1>}], sym_name = "fd_r43x6_ge_decode2", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: !llvm.ptr, %arg3: !llvm.ptr, %arg4: !llvm.ptr, %arg5: !llvm.ptr, %arg6: !llvm.ptr, %arg7: !llvm.ptr):
  %0 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
  %1 = "llvm.mlir.constant"() <{value = -2 : i32}> : () -> i32
  %2 = "llvm.mlir.constant"() <{value = dense<[8796093022207, 8796093022207, 8796093022207, 8796093022207, 1099511627775, 1099511627775, 1099511627775, 1099511627775]> : vector<8xi64>}> : () -> vector<8xi64>
  %3 = "llvm.mlir.constant"() <{value = dense<[43, 43, 43, 43, 40, 40, 40, 40]> : vector<8xi64>}> : () -> vector<8xi64>
  %4 = "llvm.mlir.constant"() <{value = dense<43> : vector<8xi64>}> : () -> vector<8xi64>
  %5 = "llvm.mlir.constant"() <{value = false}> : () -> i1
  %6 = "llvm.mlir.constant"() <{value = dense<1> : vector<2xi32>}> : () -> vector<2xi32>
  %7 = "llvm.mlir.constant"() <{value = dense<[8795933638637, 8796091973631, 8796091973631, 8796091973631, 8796091973631, 1099510579199, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %8 = "llvm.mlir.constant"() <{value = dense<[3467281080496, 6582290652611, 5210002954932, 329084955603, 4526638806224, 373767602335, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %9 = "llvm.mlir.constant"() <{value = true}> : () -> i1
  %10 = "llvm.mlir.constant"() <{value = dense<0> : vector<2xi64>}> : () -> vector<2xi64>
  %11 = "llvm.mlir.constant"() <{value = dense<-19> : vector<2xi64>}> : () -> vector<2xi64>
  %12 = "llvm.mlir.constant"() <{value = dense<1099511627776> : vector<2xi64>}> : () -> vector<2xi64>
  %13 = "llvm.mlir.constant"() <{value = dense<8796093022207> : vector<2xi64>}> : () -> vector<2xi64>
  %14 = "llvm.mlir.constant"() <{value = dense<43> : vector<2xi64>}> : () -> vector<2xi64>
  %15 = "llvm.mlir.constant"() <{value = dense<1048576> : vector<2xi64>}> : () -> vector<2xi64>
  %16 = "llvm.mlir.constant"() <{value = dense<19> : vector<2xi64>}> : () -> vector<2xi64>
  %17 = "llvm.mlir.constant"() <{value = dense<40> : vector<2xi64>}> : () -> vector<2xi64>
  %18 = "llvm.mlir.constant"() <{value = dense<1099511627775> : vector<2xi64>}> : () -> vector<2xi64>
  %19 = "llvm.mlir.constant"() <{value = dense<-1048576> : vector<2xi64>}> : () -> vector<2xi64>
  %20 = "llvm.mlir.constant"() <{value = -19 : i64}> : () -> i64
  %21 = "llvm.mlir.constant"() <{value = 1099511627776 : i64}> : () -> i64
  %22 = "llvm.mlir.constant"() <{value = 1048576 : i64}> : () -> i64
  %23 = "llvm.mlir.constant"() <{value = 8796093022207 : i64}> : () -> i64
  %24 = "llvm.mlir.constant"() <{value = 43 : i64}> : () -> i64
  %25 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %26 = "llvm.mlir.constant"() <{value = 1099511627775 : i64}> : () -> i64
  %27 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
  %28 = "llvm.mlir.constant"() <{value = -1048576 : i64}> : () -> i64
  %29 = "llvm.mlir.constant"() <{value = 5 : i64}> : () -> i64
  %30 = "llvm.mlir.constant"() <{value = 4 : i64}> : () -> i64
  %31 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %32 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
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
  %60 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %61 = "llvm.mlir.constant"() <{value = dense<63> : vector<2xi64>}> : () -> vector<2xi64>
  %62 = "llvm.mlir.constant"() <{value = 9223372036854775807 : i64}> : () -> i64
  %63 = "llvm.mlir.poison"() : () -> vector<4xi64>
  %64 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %65 = "llvm.mlir.constant"() <{value = 7 : i64}> : () -> i64
  %66 = "llvm.mlir.poison"() : () -> vector<64xi8>
  %67 = "llvm.mlir.constant"() <{value = dense<[0, 3, 6, 1, 4, 7, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %68 = "llvm.mlir.constant"() <{value = dense<8796093022207> : vector<8xi64>}> : () -> vector<8xi64>
  %69 = "llvm.mlir.poison"() : () -> vector<8xi64>
  %70 = "llvm.mlir.constant"() <{value = dense<[0, 1, 1, 1, 1, 1, 0, 1]> : vector<8xi64>}> : () -> vector<8xi64>
  %71 = "llvm.mlir.constant"() <{value = dense<[0, 1, 0, 1, 1, 1, 1, 1]> : vector<8xi64>}> : () -> vector<8xi64>
  %72 = "llvm.mlir.constant"() <{value = dense<[1, 1, 0, 1, 0, 1, 1, 1]> : vector<8xi64>}> : () -> vector<8xi64>
  %73 = "llvm.mlir.constant"() <{value = dense<0> : vector<8xi64>}> : () -> vector<8xi64>
  %74 = "llvm.mlir.constant"() <{value = dense<9> : vector<8xi64>}> : () -> vector<8xi64>
  %75 = "llvm.mlir.constant"() <{value = dense<[0, 0, -1, -1, -1, -1, -1, -1]> : vector<8xi64>}> : () -> vector<8xi64>
  %76 = "llvm.mlir.constant"() <{value = dense<[0, -1, 0, -1, -1, -1, -1, -1]> : vector<8xi64>}> : () -> vector<8xi64>
  %77 = "llvm.mlir.poison"() : () -> i64
  %78 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %79 = "llvm.mlir.undef"() : () -> vector<8xi64>
  %80 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %81 = "llvm.insertelement"(%79, %78, %80) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %82 = "llvm.insertelement"(%81, %78, %59) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %83 = "llvm.insertelement"(%82, %64, %58) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %84 = "llvm.insertelement"(%83, %64, %57) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %85 = "llvm.insertelement"(%84, %64, %56) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %86 = "llvm.insertelement"(%85, %64, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %87 = "llvm.insertelement"(%86, %77, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %88 = "llvm.insertelement"(%87, %77, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %89 = "llvm.insertelement"(%79, %78, %80) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %90 = "llvm.insertelement"(%89, %64, %59) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %91 = "llvm.insertelement"(%90, %78, %58) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %92 = "llvm.insertelement"(%91, %64, %57) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %93 = "llvm.insertelement"(%92, %64, %56) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %94 = "llvm.insertelement"(%93, %64, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %95 = "llvm.insertelement"(%94, %77, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %96 = "llvm.insertelement"(%95, %77, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %97 = "llvm.insertelement"(%79, %78, %80) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %98 = "llvm.insertelement"(%97, %78, %59) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %99 = "llvm.insertelement"(%98, %64, %58) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %100 = "llvm.insertelement"(%99, %64, %57) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %101 = "llvm.insertelement"(%100, %64, %56) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %102 = "llvm.insertelement"(%101, %77, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %103 = "llvm.insertelement"(%102, %77, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %104 = "llvm.insertelement"(%103, %77, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %105 = "llvm.insertelement"(%79, %78, %80) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %106 = "llvm.insertelement"(%105, %64, %59) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %107 = "llvm.insertelement"(%106, %78, %58) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %108 = "llvm.insertelement"(%107, %64, %57) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %109 = "llvm.insertelement"(%108, %64, %56) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %110 = "llvm.insertelement"(%109, %77, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %111 = "llvm.insertelement"(%110, %77, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %112 = "llvm.insertelement"(%111, %77, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %113 = "llvm.insertelement"(%79, %77, %80) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %114 = "llvm.insertelement"(%113, %77, %59) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %115 = "llvm.insertelement"(%114, %77, %58) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %116 = "llvm.insertelement"(%115, %77, %57) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %117 = "llvm.insertelement"(%116, %77, %56) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %118 = "llvm.insertelement"(%117, %77, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %119 = "llvm.insertelement"(%118, %77, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %120 = "llvm.insertelement"(%119, %64, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %121 = "llvm.insertelement"(%79, %64, %80) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %122 = "llvm.insertelement"(%121, %64, %59) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %123 = "llvm.insertelement"(%122, %64, %58) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %124 = "llvm.insertelement"(%123, %64, %57) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %125 = "llvm.insertelement"(%124, %64, %56) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %126 = "llvm.insertelement"(%125, %77, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %127 = "llvm.insertelement"(%126, %77, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %128 = "llvm.insertelement"(%127, %77, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %129 = "llvm.insertelement"(%79, %64, %80) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %130 = "llvm.insertelement"(%129, %77, %59) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %131 = "llvm.insertelement"(%130, %77, %58) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %132 = "llvm.insertelement"(%131, %77, %57) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %133 = "llvm.insertelement"(%132, %77, %56) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %134 = "llvm.insertelement"(%133, %77, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %135 = "llvm.insertelement"(%134, %77, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %136 = "llvm.insertelement"(%135, %77, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %137 = "llvm.insertelement"(%79, %77, %80) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %138 = "llvm.insertelement"(%137, %77, %59) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %139 = "llvm.insertelement"(%138, %77, %58) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %140 = "llvm.insertelement"(%139, %77, %57) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %141 = "llvm.insertelement"(%140, %77, %56) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %142 = "llvm.insertelement"(%141, %77, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %143 = "llvm.insertelement"(%142, %64, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %144 = "llvm.insertelement"(%143, %64, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %145 = "llvm.insertelement"(%79, %77, %80) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %146 = "llvm.insertelement"(%145, %77, %59) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %147 = "llvm.insertelement"(%146, %77, %58) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %148 = "llvm.insertelement"(%147, %77, %57) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %149 = "llvm.insertelement"(%148, %77, %56) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %150 = "llvm.insertelement"(%149, %64, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %151 = "llvm.insertelement"(%150, %64, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %152 = "llvm.insertelement"(%151, %64, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %153 = "llvm.insertelement"(%79, %64, %80) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %154 = "llvm.insertelement"(%153, %64, %59) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %155 = "llvm.insertelement"(%154, %64, %58) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %156 = "llvm.insertelement"(%155, %77, %57) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %157 = "llvm.insertelement"(%156, %77, %56) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %158 = "llvm.insertelement"(%157, %77, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %159 = "llvm.insertelement"(%158, %77, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %160 = "llvm.insertelement"(%159, %77, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %161 = "llvm.insertelement"(%79, %77, %80) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %162 = "llvm.insertelement"(%161, %77, %59) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %163 = "llvm.insertelement"(%162, %77, %58) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %164 = "llvm.insertelement"(%163, %77, %57) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %165 = "llvm.insertelement"(%164, %64, %56) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %166 = "llvm.insertelement"(%165, %64, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %167 = "llvm.insertelement"(%166, %64, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %168 = "llvm.insertelement"(%167, %64, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %169 = "llvm.insertelement"(%79, %64, %80) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %170 = "llvm.insertelement"(%169, %64, %59) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %171 = "llvm.insertelement"(%170, %77, %58) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %172 = "llvm.insertelement"(%171, %77, %57) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %173 = "llvm.insertelement"(%172, %77, %56) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %174 = "llvm.insertelement"(%173, %77, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %175 = "llvm.insertelement"(%174, %77, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %176 = "llvm.insertelement"(%175, %77, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %177 = "llvm.insertelement"(%79, %77, %80) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %178 = "llvm.insertelement"(%177, %77, %59) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %179 = "llvm.insertelement"(%178, %77, %58) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %180 = "llvm.insertelement"(%179, %64, %57) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %181 = "llvm.insertelement"(%180, %64, %56) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %182 = "llvm.insertelement"(%181, %64, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %183 = "llvm.insertelement"(%182, %64, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %184 = "llvm.insertelement"(%183, %64, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %185 = "llvm.insertelement"(%79, %77, %80) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %186 = "llvm.insertelement"(%185, %77, %59) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %187 = "llvm.insertelement"(%186, %64, %58) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %188 = "llvm.insertelement"(%187, %64, %57) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %189 = "llvm.insertelement"(%188, %64, %56) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %190 = "llvm.insertelement"(%189, %64, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %191 = "llvm.insertelement"(%190, %64, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %192 = "llvm.insertelement"(%191, %64, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %193 = "llvm.insertelement"(%79, %33, %80) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %194 = "llvm.insertelement"(%193, %34, %59) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %195 = "llvm.insertelement"(%194, %34, %58) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %196 = "llvm.insertelement"(%195, %34, %57) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %197 = "llvm.insertelement"(%196, %34, %56) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %198 = "llvm.insertelement"(%197, %35, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %199 = "llvm.insertelement"(%198, %77, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %200 = "llvm.insertelement"(%199, %77, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %201 = "llvm.insertelement"(%79, %32, %80) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %202 = "llvm.insertelement"(%201, %64, %59) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %203 = "llvm.insertelement"(%202, %77, %58) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %204 = "llvm.insertelement"(%203, %77, %57) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %205 = "llvm.insertelement"(%204, %64, %56) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %206 = "llvm.insertelement"(%205, %64, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %207 = "llvm.insertelement"(%206, %77, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %208 = "llvm.insertelement"(%207, %77, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %209 = "llvm.insertelement"(%79, %77, %80) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %210 = "llvm.insertelement"(%209, %77, %59) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %211 = "llvm.insertelement"(%210, %64, %58) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %212 = "llvm.insertelement"(%211, %64, %57) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %213 = "llvm.insertelement"(%212, %64, %56) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %214 = "llvm.insertelement"(%213, %64, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %215 = "llvm.insertelement"(%214, %77, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %216 = "llvm.insertelement"(%215, %77, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %217 = "llvm.insertelement"(%79, %77, %80) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %218 = "llvm.insertelement"(%217, %77, %59) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %219 = "llvm.insertelement"(%218, %77, %58) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %220 = "llvm.insertelement"(%219, %77, %57) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %221 = "llvm.insertelement"(%220, %25, %56) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %222 = "llvm.insertelement"(%221, %25, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %223 = "llvm.insertelement"(%222, %25, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %224 = "llvm.insertelement"(%223, %25, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %225 = "llvm.alloca"(%59) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %226 = "llvm.alloca"(%59) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %227 = "llvm.load"(%arg3) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %228 = "llvm.load"(%arg7) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %229 = "llvm.extractelement"(%227, %60) : (vector<4xi64>, i64) -> i64
  %230 = "llvm.extractelement"(%228, %60) : (vector<4xi64>, i64) -> i64
  %231 = "llvm.shufflevector"(%228, %227) <{mask = array<i32: 3, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<2xi64>
  %232 = "llvm.lshr"(%231, %61) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %233 = "llvm.trunc"(%232) <{overflowFlags = 3 : i32}> : (vector<2xi64>) -> vector<2xi32>
  %234 = "llvm.and"(%229, %62) : (i64, i64) -> i64
  %235 = "llvm.and"(%230, %62) : (i64, i64) -> i64
  %236 = "llvm.insertelement"(%227, %234, %60) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %237 = "llvm.insertelement"(%228, %235, %60) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %238 = "llvm.shufflevector"(%236, %63) <{mask = array<i32: 0, 1, 2, 3, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %239 = "llvm.insertelement"(%238, %64, %65) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %240 = "llvm.bitcast"(%239) : (vector<8xi64>) -> vector<64xi8>
  %241 = "llvm.shufflevector"(%240, %66) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 63, 63, 5, 6, 7, 8, 9, 10, 63, 63, 10, 11, 12, 13, 14, 15, 16, 63, 16, 17, 18, 19, 20, 21, 63, 63, 21, 22, 23, 24, 25, 26, 63, 63, 26, 27, 28, 29, 30, 31, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %242 = "llvm.bitcast"(%241) : (vector<64xi8>) -> vector<8xi64>
  %243 = "llvm.lshr"(%242, %67) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %244 = "llvm.and"(%243, %68) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %245 = "llvm.shufflevector"(%237, %63) <{mask = array<i32: 0, 1, 2, 3, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %246 = "llvm.insertelement"(%245, %64, %65) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %247 = "llvm.bitcast"(%246) : (vector<8xi64>) -> vector<64xi8>
  %248 = "llvm.shufflevector"(%247, %66) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 63, 63, 5, 6, 7, 8, 9, 10, 63, 63, 10, 11, 12, 13, 14, 15, 16, 63, 16, 17, 18, 19, 20, 21, 63, 63, 21, 22, 23, 24, 25, 26, 63, 63, 26, 27, 28, 29, 30, 31, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %249 = "llvm.bitcast"(%248) : (vector<64xi8>) -> vector<8xi64>
  %250 = "llvm.lshr"(%249, %67) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %251 = "llvm.and"(%250, %68) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %252 = "llvm.shufflevector"(%244, %69) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %253 = "llvm.shufflevector"(%244, %69) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 3, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %254 = "llvm.shufflevector"(%244, %69) <{mask = array<i32: 4, 4, 1, 1, 1, 1, 1, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %255 = "llvm.shufflevector"(%244, %69) <{mask = array<i32: 4, 5, 1, 2, 3, 4, 5, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %256 = "llvm.shufflevector"(%244, %69) <{mask = array<i32: 3, 7, 5, 7, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %257 = "llvm.shufflevector"(%244, %69) <{mask = array<i32: 5, 7, 5, 7, 2, 3, 4, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %258 = "llvm.shl"(%252, %70) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %259 = "llvm.shl"(%254, %71) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %260 = "llvm.shl"(%256, %72) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %261 = "llvm.call_intrinsic"(%73, %259, %255) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %262 = "llvm.call_intrinsic"(%73, %260, %257) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %263 = "llvm.call_intrinsic"(%73, %258, %253) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %264 = "llvm.shl"(%263, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %265 = "llvm.call_intrinsic"(%73, %259, %255) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %266 = "llvm.shl"(%265, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %267 = "llvm.call_intrinsic"(%73, %260, %257) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %268 = "llvm.shl"(%267, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %269 = "llvm.and"(%261, %75) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %270 = "llvm.and"(%262, %76) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %271 = "llvm.add"(%270, %269) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %272 = "llvm.call_intrinsic"(%271, %258, %253) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %273 = "llvm.and"(%266, %75) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %274 = "llvm.and"(%268, %76) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %275 = "llvm.add"(%273, %264) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %276 = "llvm.add"(%275, %274) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %277 = "llvm.and"(%261, %88) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %278 = "llvm.and"(%262, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %279 = "llvm.and"(%266, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %280 = "llvm.and"(%268, %112) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %281 = "llvm.add"(%280, %279) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %282 = "llvm.shufflevector"(%120, %276) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %283 = "llvm.add"(%282, %272) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %284 = "llvm.shufflevector"(%120, %281) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %285 = "llvm.shufflevector"(%276, %128) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %286 = "llvm.add"(%278, %277) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %287 = "llvm.add"(%286, %284) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %288 = "llvm.add"(%287, %285) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %289 = "llvm.and"(%283, %52) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %290 = "llvm.shufflevector"(%283, %288) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %291 = "llvm.shl"(%290, %51) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %292 = "llvm.add"(%291, %289) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %293 = "llvm.mul"(%290, %50) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %294 = "llvm.add"(%292, %293) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %295 = "llvm.and"(%294, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %296 = "llvm.lshr"(%294, %48) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %297 = "llvm.shufflevector"(%296, %69) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %298 = "llvm.call_intrinsic"(%295, %47, %297) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %299 = "llvm.shufflevector"(%251, %69) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %300 = "llvm.shufflevector"(%251, %69) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 3, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %301 = "llvm.shufflevector"(%251, %69) <{mask = array<i32: 4, 4, 1, 1, 1, 1, 1, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %302 = "llvm.shufflevector"(%251, %69) <{mask = array<i32: 4, 5, 1, 2, 3, 4, 5, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %303 = "llvm.shufflevector"(%251, %69) <{mask = array<i32: 3, 7, 5, 7, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %304 = "llvm.shufflevector"(%251, %69) <{mask = array<i32: 5, 7, 5, 7, 2, 3, 4, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %305 = "llvm.shl"(%299, %70) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %306 = "llvm.shl"(%301, %71) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %307 = "llvm.shl"(%303, %72) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %308 = "llvm.call_intrinsic"(%73, %306, %302) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %309 = "llvm.call_intrinsic"(%73, %307, %304) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %310 = "llvm.call_intrinsic"(%73, %305, %300) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %311 = "llvm.shl"(%310, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %312 = "llvm.call_intrinsic"(%73, %306, %302) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %313 = "llvm.shl"(%312, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %314 = "llvm.call_intrinsic"(%73, %307, %304) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %315 = "llvm.shl"(%314, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %316 = "llvm.and"(%308, %75) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %317 = "llvm.and"(%309, %76) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %318 = "llvm.add"(%317, %316) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %319 = "llvm.call_intrinsic"(%318, %305, %300) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %320 = "llvm.and"(%313, %75) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %321 = "llvm.and"(%315, %76) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %322 = "llvm.add"(%320, %311) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %323 = "llvm.add"(%322, %321) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %324 = "llvm.and"(%308, %88) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %325 = "llvm.and"(%309, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %326 = "llvm.and"(%313, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %327 = "llvm.and"(%315, %112) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %328 = "llvm.add"(%327, %326) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %329 = "llvm.shufflevector"(%120, %323) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %330 = "llvm.add"(%329, %319) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %331 = "llvm.shufflevector"(%120, %328) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %332 = "llvm.shufflevector"(%323, %128) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %333 = "llvm.add"(%325, %324) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %334 = "llvm.add"(%333, %331) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %335 = "llvm.add"(%334, %332) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %336 = "llvm.and"(%330, %52) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %337 = "llvm.shufflevector"(%330, %335) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %338 = "llvm.shl"(%337, %51) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %339 = "llvm.add"(%338, %336) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %340 = "llvm.mul"(%337, %50) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %341 = "llvm.add"(%339, %340) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %342 = "llvm.and"(%341, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %343 = "llvm.lshr"(%341, %48) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %344 = "llvm.shufflevector"(%343, %69) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %345 = "llvm.call_intrinsic"(%342, %47, %344) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %346 = "llvm.add"(%298, %46) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %347 = "llvm.and"(%346, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %348 = "llvm.ashr"(%346, %48) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %349 = "llvm.shufflevector"(%348, %136) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 8, 8>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %350 = "llvm.mul"(%349, %45) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %351 = "llvm.and"(%350, %44) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %352 = "llvm.add"(%349, %347) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %353 = "llvm.add"(%352, %351) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %354 = "llvm.add"(%353, %43) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %355 = "llvm.add"(%345, %46) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %356 = "llvm.and"(%355, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %357 = "llvm.ashr"(%355, %48) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %358 = "llvm.shufflevector"(%357, %136) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 8, 8>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %359 = "llvm.mul"(%358, %45) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %360 = "llvm.and"(%359, %44) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %361 = "llvm.add"(%358, %356) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %362 = "llvm.add"(%361, %360) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %363 = "llvm.add"(%362, %43) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %364 = "llvm.call_intrinsic"(%73, %42, %298) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %365 = "llvm.shl"(%364, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %366 = "llvm.call_intrinsic"(%365, %41, %298) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %367 = "llvm.call_intrinsic"(%73, %41, %298) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %368 = "llvm.shl"(%367, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %369 = "llvm.call_intrinsic"(%368, %40, %298) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %370 = "llvm.call_intrinsic"(%73, %40, %298) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %371 = "llvm.shl"(%370, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %372 = "llvm.call_intrinsic"(%371, %39, %298) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %373 = "llvm.call_intrinsic"(%73, %39, %298) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %374 = "llvm.shl"(%373, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %375 = "llvm.call_intrinsic"(%374, %38, %298) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %376 = "llvm.call_intrinsic"(%73, %38, %298) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %377 = "llvm.shl"(%376, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %378 = "llvm.call_intrinsic"(%377, %37, %298) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %379 = "llvm.call_intrinsic"(%73, %37, %298) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %380 = "llvm.shl"(%379, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %381 = "llvm.shufflevector"(%120, %366) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %382 = "llvm.shufflevector"(%144, %369) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %383 = "llvm.shufflevector"(%152, %372) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %384 = "llvm.shufflevector"(%372, %160) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %385 = "llvm.shufflevector"(%168, %375) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %386 = "llvm.shufflevector"(%375, %176) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %387 = "llvm.shufflevector"(%184, %378) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %388 = "llvm.shufflevector"(%378, %136) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %389 = "llvm.shufflevector"(%192, %380) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %390 = "llvm.shufflevector"(%380, %69) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %391 = "llvm.call_intrinsic"(%381, %42, %298) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %392 = "llvm.add"(%383, %382) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %393 = "llvm.add"(%392, %385) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %394 = "llvm.add"(%393, %387) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %395 = "llvm.add"(%394, %391) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %396 = "llvm.add"(%395, %389) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %397 = "llvm.add"(%386, %384) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %398 = "llvm.add"(%397, %388) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %399 = "llvm.add"(%398, %390) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %400 = "llvm.and"(%396, %52) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %401 = "llvm.shufflevector"(%396, %399) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %402 = "llvm.shl"(%401, %51) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %403 = "llvm.add"(%402, %400) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %404 = "llvm.mul"(%401, %50) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %405 = "llvm.add"(%403, %404) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %406 = "llvm.and"(%405, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %407 = "llvm.lshr"(%405, %48) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %408 = "llvm.shufflevector"(%407, %69) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %409 = "llvm.call_intrinsic"(%406, %47, %408) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %410 = "llvm.add"(%409, %36) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %411 = "llvm.call_intrinsic"(%73, %42, %345) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %412 = "llvm.shl"(%411, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %413 = "llvm.call_intrinsic"(%412, %41, %345) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %414 = "llvm.call_intrinsic"(%73, %41, %345) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %415 = "llvm.shl"(%414, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %416 = "llvm.call_intrinsic"(%415, %40, %345) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %417 = "llvm.call_intrinsic"(%73, %40, %345) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %418 = "llvm.shl"(%417, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %419 = "llvm.call_intrinsic"(%418, %39, %345) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %420 = "llvm.call_intrinsic"(%73, %39, %345) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %421 = "llvm.shl"(%420, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %422 = "llvm.call_intrinsic"(%421, %38, %345) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %423 = "llvm.call_intrinsic"(%73, %38, %345) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %424 = "llvm.shl"(%423, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %425 = "llvm.call_intrinsic"(%424, %37, %345) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %426 = "llvm.call_intrinsic"(%73, %37, %345) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %427 = "llvm.shl"(%426, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %428 = "llvm.shufflevector"(%120, %413) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %429 = "llvm.shufflevector"(%144, %416) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %430 = "llvm.shufflevector"(%152, %419) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %431 = "llvm.shufflevector"(%419, %160) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %432 = "llvm.shufflevector"(%168, %422) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %433 = "llvm.shufflevector"(%422, %176) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %434 = "llvm.shufflevector"(%184, %425) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %435 = "llvm.shufflevector"(%425, %136) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %436 = "llvm.shufflevector"(%192, %427) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %437 = "llvm.shufflevector"(%427, %69) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %438 = "llvm.call_intrinsic"(%428, %42, %345) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %439 = "llvm.add"(%430, %429) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %440 = "llvm.add"(%439, %432) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %441 = "llvm.add"(%440, %434) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %442 = "llvm.add"(%441, %438) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %443 = "llvm.add"(%442, %436) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %444 = "llvm.add"(%433, %431) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %445 = "llvm.add"(%444, %435) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %446 = "llvm.add"(%445, %437) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %447 = "llvm.and"(%443, %52) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %448 = "llvm.shufflevector"(%443, %446) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %449 = "llvm.shl"(%448, %51) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %450 = "llvm.add"(%449, %447) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %451 = "llvm.mul"(%448, %50) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %452 = "llvm.add"(%450, %451) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %453 = "llvm.and"(%452, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %454 = "llvm.lshr"(%452, %48) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %455 = "llvm.shufflevector"(%454, %69) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %456 = "llvm.call_intrinsic"(%453, %47, %455) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %457 = "llvm.add"(%456, %36) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %458 = "llvm.shufflevector"(%410, %69) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %459 = "llvm.shufflevector"(%410, %69) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 3, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %460 = "llvm.shufflevector"(%410, %69) <{mask = array<i32: 4, 4, 1, 1, 1, 1, 1, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %461 = "llvm.shufflevector"(%410, %69) <{mask = array<i32: 4, 5, 1, 2, 3, 4, 5, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %462 = "llvm.shufflevector"(%410, %69) <{mask = array<i32: 3, 7, 5, 7, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %463 = "llvm.shufflevector"(%410, %69) <{mask = array<i32: 5, 7, 5, 7, 2, 3, 4, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %464 = "llvm.shl"(%458, %70) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %465 = "llvm.shl"(%460, %71) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %466 = "llvm.shl"(%462, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %467 = "llvm.call_intrinsic"(%73, %465, %461) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %468 = "llvm.call_intrinsic"(%73, %466, %463) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %469 = "llvm.call_intrinsic"(%73, %464, %459) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %470 = "llvm.shl"(%469, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %471 = "llvm.call_intrinsic"(%73, %465, %461) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %472 = "llvm.shl"(%471, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %473 = "llvm.call_intrinsic"(%73, %466, %463) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %474 = "llvm.shl"(%473, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %475 = "llvm.and"(%467, %75) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %476 = "llvm.and"(%468, %76) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %477 = "llvm.add"(%476, %475) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %478 = "llvm.call_intrinsic"(%477, %464, %459) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %479 = "llvm.and"(%472, %75) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %480 = "llvm.and"(%474, %76) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %481 = "llvm.add"(%479, %470) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %482 = "llvm.add"(%481, %480) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %483 = "llvm.and"(%467, %88) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %484 = "llvm.and"(%468, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %485 = "llvm.and"(%472, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %486 = "llvm.and"(%474, %112) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %487 = "llvm.add"(%486, %485) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %488 = "llvm.shufflevector"(%120, %482) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %489 = "llvm.add"(%488, %478) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %490 = "llvm.shufflevector"(%120, %487) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %491 = "llvm.shufflevector"(%482, %128) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %492 = "llvm.add"(%484, %483) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %493 = "llvm.add"(%492, %490) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %494 = "llvm.add"(%493, %491) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %495 = "llvm.and"(%489, %52) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %496 = "llvm.shufflevector"(%489, %494) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %497 = "llvm.shl"(%496, %51) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %498 = "llvm.add"(%497, %495) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %499 = "llvm.mul"(%496, %50) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %500 = "llvm.add"(%498, %499) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %501 = "llvm.and"(%500, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %502 = "llvm.lshr"(%500, %48) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %503 = "llvm.shufflevector"(%502, %69) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %504 = "llvm.call_intrinsic"(%501, %47, %503) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %505 = "llvm.shufflevector"(%457, %69) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %506 = "llvm.shufflevector"(%457, %69) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 3, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %507 = "llvm.shufflevector"(%457, %69) <{mask = array<i32: 4, 4, 1, 1, 1, 1, 1, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %508 = "llvm.shufflevector"(%457, %69) <{mask = array<i32: 4, 5, 1, 2, 3, 4, 5, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %509 = "llvm.shufflevector"(%457, %69) <{mask = array<i32: 3, 7, 5, 7, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %510 = "llvm.shufflevector"(%457, %69) <{mask = array<i32: 5, 7, 5, 7, 2, 3, 4, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %511 = "llvm.shl"(%505, %70) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %512 = "llvm.shl"(%507, %71) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %513 = "llvm.shl"(%509, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %514 = "llvm.call_intrinsic"(%73, %512, %508) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %515 = "llvm.call_intrinsic"(%73, %513, %510) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %516 = "llvm.call_intrinsic"(%73, %511, %506) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %517 = "llvm.shl"(%516, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %518 = "llvm.call_intrinsic"(%73, %512, %508) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %519 = "llvm.shl"(%518, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %520 = "llvm.call_intrinsic"(%73, %513, %510) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %521 = "llvm.shl"(%520, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %522 = "llvm.and"(%514, %75) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %523 = "llvm.and"(%515, %76) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %524 = "llvm.add"(%523, %522) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %525 = "llvm.call_intrinsic"(%524, %511, %506) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %526 = "llvm.and"(%519, %75) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %527 = "llvm.and"(%521, %76) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %528 = "llvm.add"(%526, %517) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %529 = "llvm.add"(%528, %527) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %530 = "llvm.and"(%514, %88) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %531 = "llvm.and"(%515, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %532 = "llvm.and"(%519, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %533 = "llvm.and"(%521, %112) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %534 = "llvm.add"(%533, %532) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %535 = "llvm.shufflevector"(%120, %529) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %536 = "llvm.add"(%535, %525) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %537 = "llvm.shufflevector"(%120, %534) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %538 = "llvm.shufflevector"(%529, %128) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %539 = "llvm.add"(%531, %530) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %540 = "llvm.add"(%539, %537) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %541 = "llvm.add"(%540, %538) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %542 = "llvm.and"(%536, %52) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %543 = "llvm.shufflevector"(%536, %541) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %544 = "llvm.shl"(%543, %51) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %545 = "llvm.add"(%544, %542) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %546 = "llvm.mul"(%543, %50) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %547 = "llvm.add"(%545, %546) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %548 = "llvm.and"(%547, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %549 = "llvm.lshr"(%547, %48) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %550 = "llvm.shufflevector"(%549, %69) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %551 = "llvm.call_intrinsic"(%548, %47, %550) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %552 = "llvm.shufflevector"(%504, %69) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %553 = "llvm.shufflevector"(%504, %69) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 3, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %554 = "llvm.shufflevector"(%504, %69) <{mask = array<i32: 4, 4, 1, 1, 1, 1, 1, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %555 = "llvm.shufflevector"(%504, %69) <{mask = array<i32: 4, 5, 1, 2, 3, 4, 5, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %556 = "llvm.shufflevector"(%504, %69) <{mask = array<i32: 3, 7, 5, 7, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %557 = "llvm.shufflevector"(%504, %69) <{mask = array<i32: 5, 7, 5, 7, 2, 3, 4, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %558 = "llvm.shl"(%552, %70) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %559 = "llvm.shl"(%554, %71) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %560 = "llvm.shl"(%556, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %561 = "llvm.call_intrinsic"(%73, %559, %555) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %562 = "llvm.call_intrinsic"(%73, %560, %557) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %563 = "llvm.call_intrinsic"(%73, %558, %553) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %564 = "llvm.shl"(%563, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %565 = "llvm.call_intrinsic"(%73, %559, %555) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %566 = "llvm.shl"(%565, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %567 = "llvm.call_intrinsic"(%73, %560, %557) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %568 = "llvm.shl"(%567, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %569 = "llvm.and"(%561, %75) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %570 = "llvm.and"(%562, %76) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %571 = "llvm.add"(%570, %569) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %572 = "llvm.call_intrinsic"(%571, %558, %553) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %573 = "llvm.and"(%566, %75) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %574 = "llvm.and"(%568, %76) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %575 = "llvm.add"(%573, %564) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %576 = "llvm.add"(%575, %574) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %577 = "llvm.and"(%561, %88) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %578 = "llvm.and"(%562, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %579 = "llvm.and"(%566, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %580 = "llvm.and"(%568, %112) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %581 = "llvm.add"(%580, %579) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %582 = "llvm.shufflevector"(%120, %576) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %583 = "llvm.add"(%582, %572) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %584 = "llvm.shufflevector"(%120, %581) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %585 = "llvm.shufflevector"(%576, %128) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %586 = "llvm.add"(%578, %577) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %587 = "llvm.add"(%586, %584) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %588 = "llvm.add"(%587, %585) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %589 = "llvm.and"(%583, %52) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %590 = "llvm.shufflevector"(%583, %588) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %591 = "llvm.shl"(%590, %51) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %592 = "llvm.add"(%591, %589) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %593 = "llvm.mul"(%590, %50) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %594 = "llvm.add"(%592, %593) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %595 = "llvm.and"(%594, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %596 = "llvm.lshr"(%594, %48) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %597 = "llvm.shufflevector"(%596, %69) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %598 = "llvm.call_intrinsic"(%595, %47, %597) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %599 = "llvm.shufflevector"(%551, %69) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %600 = "llvm.shufflevector"(%551, %69) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 3, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %601 = "llvm.shufflevector"(%551, %69) <{mask = array<i32: 4, 4, 1, 1, 1, 1, 1, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %602 = "llvm.shufflevector"(%551, %69) <{mask = array<i32: 4, 5, 1, 2, 3, 4, 5, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %603 = "llvm.shufflevector"(%551, %69) <{mask = array<i32: 3, 7, 5, 7, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %604 = "llvm.shufflevector"(%551, %69) <{mask = array<i32: 5, 7, 5, 7, 2, 3, 4, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %605 = "llvm.shl"(%599, %70) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %606 = "llvm.shl"(%601, %71) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %607 = "llvm.shl"(%603, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %608 = "llvm.call_intrinsic"(%73, %606, %602) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %609 = "llvm.call_intrinsic"(%73, %607, %604) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %610 = "llvm.call_intrinsic"(%73, %605, %600) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %611 = "llvm.shl"(%610, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %612 = "llvm.call_intrinsic"(%73, %606, %602) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %613 = "llvm.shl"(%612, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %614 = "llvm.call_intrinsic"(%73, %607, %604) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %615 = "llvm.shl"(%614, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %616 = "llvm.and"(%608, %75) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %617 = "llvm.and"(%609, %76) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %618 = "llvm.add"(%617, %616) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %619 = "llvm.call_intrinsic"(%618, %605, %600) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %620 = "llvm.and"(%613, %75) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %621 = "llvm.and"(%615, %76) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %622 = "llvm.add"(%620, %611) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %623 = "llvm.add"(%622, %621) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %624 = "llvm.and"(%608, %88) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %625 = "llvm.and"(%609, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %626 = "llvm.and"(%613, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %627 = "llvm.and"(%615, %112) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %628 = "llvm.add"(%627, %626) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %629 = "llvm.shufflevector"(%120, %623) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %630 = "llvm.add"(%629, %619) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %631 = "llvm.shufflevector"(%120, %628) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %632 = "llvm.shufflevector"(%623, %128) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %633 = "llvm.add"(%625, %624) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %634 = "llvm.add"(%633, %631) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %635 = "llvm.add"(%634, %632) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %636 = "llvm.and"(%630, %52) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %637 = "llvm.shufflevector"(%630, %635) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %638 = "llvm.shl"(%637, %51) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %639 = "llvm.add"(%638, %636) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %640 = "llvm.mul"(%637, %50) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %641 = "llvm.add"(%639, %640) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %642 = "llvm.and"(%641, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %643 = "llvm.lshr"(%641, %48) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %644 = "llvm.shufflevector"(%643, %69) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %645 = "llvm.call_intrinsic"(%642, %47, %644) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %646 = "llvm.shufflevector"(%410, %69) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %647 = "llvm.shufflevector"(%410, %69) <{mask = array<i32: 1, 1, 1, 1, 1, 1, 1, 1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %648 = "llvm.shufflevector"(%410, %69) <{mask = array<i32: 2, 2, 2, 2, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %649 = "llvm.shufflevector"(%410, %69) <{mask = array<i32: 3, 3, 3, 3, 3, 3, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %650 = "llvm.shufflevector"(%410, %69) <{mask = array<i32: 4, 4, 4, 4, 4, 4, 4, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %651 = "llvm.shufflevector"(%410, %69) <{mask = array<i32: 5, 5, 5, 5, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %652 = "llvm.call_intrinsic"(%73, %646, %504) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %653 = "llvm.shl"(%652, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %654 = "llvm.call_intrinsic"(%653, %647, %504) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %655 = "llvm.call_intrinsic"(%73, %647, %504) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %656 = "llvm.shl"(%655, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %657 = "llvm.call_intrinsic"(%656, %648, %504) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %658 = "llvm.call_intrinsic"(%73, %648, %504) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %659 = "llvm.shl"(%658, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %660 = "llvm.call_intrinsic"(%659, %649, %504) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %661 = "llvm.call_intrinsic"(%73, %649, %504) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %662 = "llvm.shl"(%661, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %663 = "llvm.call_intrinsic"(%662, %650, %504) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %664 = "llvm.call_intrinsic"(%73, %650, %504) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %665 = "llvm.shl"(%664, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %666 = "llvm.call_intrinsic"(%665, %651, %504) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %667 = "llvm.call_intrinsic"(%73, %651, %504) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %668 = "llvm.shl"(%667, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %669 = "llvm.shufflevector"(%120, %654) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %670 = "llvm.shufflevector"(%144, %657) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %671 = "llvm.shufflevector"(%152, %660) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %672 = "llvm.shufflevector"(%660, %160) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %673 = "llvm.shufflevector"(%168, %663) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %674 = "llvm.shufflevector"(%663, %176) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %675 = "llvm.shufflevector"(%184, %666) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %676 = "llvm.shufflevector"(%666, %136) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %677 = "llvm.shufflevector"(%192, %668) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %678 = "llvm.shufflevector"(%668, %69) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %679 = "llvm.call_intrinsic"(%669, %646, %504) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %680 = "llvm.add"(%671, %670) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %681 = "llvm.add"(%680, %673) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %682 = "llvm.add"(%681, %675) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %683 = "llvm.add"(%682, %679) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %684 = "llvm.add"(%683, %677) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %685 = "llvm.add"(%674, %672) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %686 = "llvm.add"(%685, %676) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %687 = "llvm.add"(%686, %678) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %688 = "llvm.and"(%684, %52) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %689 = "llvm.shufflevector"(%684, %687) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %690 = "llvm.shl"(%689, %51) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %691 = "llvm.add"(%690, %688) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %692 = "llvm.mul"(%689, %50) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %693 = "llvm.add"(%691, %692) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %694 = "llvm.and"(%693, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %695 = "llvm.lshr"(%693, %48) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %696 = "llvm.shufflevector"(%695, %69) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %697 = "llvm.call_intrinsic"(%694, %47, %696) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %698 = "llvm.shufflevector"(%457, %69) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %699 = "llvm.shufflevector"(%457, %69) <{mask = array<i32: 1, 1, 1, 1, 1, 1, 1, 1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %700 = "llvm.shufflevector"(%457, %69) <{mask = array<i32: 2, 2, 2, 2, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %701 = "llvm.shufflevector"(%457, %69) <{mask = array<i32: 3, 3, 3, 3, 3, 3, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %702 = "llvm.shufflevector"(%457, %69) <{mask = array<i32: 4, 4, 4, 4, 4, 4, 4, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %703 = "llvm.shufflevector"(%457, %69) <{mask = array<i32: 5, 5, 5, 5, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %704 = "llvm.call_intrinsic"(%73, %698, %551) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %705 = "llvm.shl"(%704, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %706 = "llvm.call_intrinsic"(%705, %699, %551) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %707 = "llvm.call_intrinsic"(%73, %699, %551) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %708 = "llvm.shl"(%707, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %709 = "llvm.call_intrinsic"(%708, %700, %551) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %710 = "llvm.call_intrinsic"(%73, %700, %551) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %711 = "llvm.shl"(%710, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %712 = "llvm.call_intrinsic"(%711, %701, %551) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %713 = "llvm.call_intrinsic"(%73, %701, %551) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %714 = "llvm.shl"(%713, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %715 = "llvm.call_intrinsic"(%714, %702, %551) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %716 = "llvm.call_intrinsic"(%73, %702, %551) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %717 = "llvm.shl"(%716, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %718 = "llvm.call_intrinsic"(%717, %703, %551) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %719 = "llvm.call_intrinsic"(%73, %703, %551) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %720 = "llvm.shl"(%719, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %721 = "llvm.shufflevector"(%120, %706) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %722 = "llvm.shufflevector"(%144, %709) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %723 = "llvm.shufflevector"(%152, %712) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %724 = "llvm.shufflevector"(%712, %160) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %725 = "llvm.shufflevector"(%168, %715) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %726 = "llvm.shufflevector"(%715, %176) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %727 = "llvm.shufflevector"(%184, %718) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %728 = "llvm.shufflevector"(%718, %136) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %729 = "llvm.shufflevector"(%192, %720) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %730 = "llvm.shufflevector"(%720, %69) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %731 = "llvm.call_intrinsic"(%721, %698, %551) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %732 = "llvm.add"(%723, %722) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %733 = "llvm.add"(%732, %725) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %734 = "llvm.add"(%733, %727) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %735 = "llvm.add"(%734, %731) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %736 = "llvm.add"(%735, %729) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %737 = "llvm.add"(%726, %724) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %738 = "llvm.add"(%737, %728) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %739 = "llvm.add"(%738, %730) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %740 = "llvm.and"(%736, %52) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %741 = "llvm.shufflevector"(%736, %739) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %742 = "llvm.shl"(%741, %51) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %743 = "llvm.add"(%742, %740) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %744 = "llvm.mul"(%741, %50) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %745 = "llvm.add"(%743, %744) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %746 = "llvm.and"(%745, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %747 = "llvm.lshr"(%745, %48) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %748 = "llvm.shufflevector"(%747, %69) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %749 = "llvm.call_intrinsic"(%746, %47, %748) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %750 = "llvm.shufflevector"(%354, %69) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %751 = "llvm.shufflevector"(%354, %69) <{mask = array<i32: 1, 1, 1, 1, 1, 1, 1, 1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %752 = "llvm.shufflevector"(%354, %69) <{mask = array<i32: 2, 2, 2, 2, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %753 = "llvm.shufflevector"(%354, %69) <{mask = array<i32: 3, 3, 3, 3, 3, 3, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %754 = "llvm.shufflevector"(%354, %69) <{mask = array<i32: 4, 4, 4, 4, 4, 4, 4, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %755 = "llvm.shufflevector"(%354, %69) <{mask = array<i32: 5, 5, 5, 5, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %756 = "llvm.call_intrinsic"(%73, %750, %697) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %757 = "llvm.shl"(%756, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %758 = "llvm.call_intrinsic"(%757, %751, %697) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %759 = "llvm.call_intrinsic"(%73, %751, %697) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %760 = "llvm.shl"(%759, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %761 = "llvm.call_intrinsic"(%760, %752, %697) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %762 = "llvm.call_intrinsic"(%73, %752, %697) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %763 = "llvm.shl"(%762, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %764 = "llvm.call_intrinsic"(%763, %753, %697) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %765 = "llvm.call_intrinsic"(%73, %753, %697) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %766 = "llvm.shl"(%765, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %767 = "llvm.call_intrinsic"(%766, %754, %697) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %768 = "llvm.call_intrinsic"(%73, %754, %697) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %769 = "llvm.shl"(%768, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %770 = "llvm.call_intrinsic"(%769, %755, %697) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %771 = "llvm.call_intrinsic"(%73, %755, %697) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %772 = "llvm.shl"(%771, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %773 = "llvm.shufflevector"(%120, %758) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %774 = "llvm.shufflevector"(%144, %761) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %775 = "llvm.shufflevector"(%152, %764) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %776 = "llvm.shufflevector"(%764, %160) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %777 = "llvm.shufflevector"(%168, %767) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %778 = "llvm.shufflevector"(%767, %176) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %779 = "llvm.shufflevector"(%184, %770) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %780 = "llvm.shufflevector"(%770, %136) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %781 = "llvm.shufflevector"(%192, %772) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %782 = "llvm.shufflevector"(%772, %69) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %783 = "llvm.call_intrinsic"(%773, %750, %697) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %784 = "llvm.add"(%775, %774) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %785 = "llvm.add"(%784, %777) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %786 = "llvm.add"(%785, %779) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %787 = "llvm.add"(%786, %783) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %788 = "llvm.add"(%787, %781) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %789 = "llvm.add"(%778, %776) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %790 = "llvm.add"(%789, %780) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %791 = "llvm.add"(%790, %782) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %792 = "llvm.and"(%788, %52) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %793 = "llvm.shufflevector"(%788, %791) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %794 = "llvm.shl"(%793, %51) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %795 = "llvm.add"(%794, %792) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %796 = "llvm.mul"(%793, %50) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %797 = "llvm.add"(%795, %796) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %798 = "llvm.and"(%797, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %799 = "llvm.lshr"(%797, %48) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %800 = "llvm.shufflevector"(%799, %69) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %801 = "llvm.call_intrinsic"(%798, %47, %800) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %802 = "llvm.shufflevector"(%363, %69) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %803 = "llvm.shufflevector"(%363, %69) <{mask = array<i32: 1, 1, 1, 1, 1, 1, 1, 1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %804 = "llvm.shufflevector"(%363, %69) <{mask = array<i32: 2, 2, 2, 2, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %805 = "llvm.shufflevector"(%363, %69) <{mask = array<i32: 3, 3, 3, 3, 3, 3, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %806 = "llvm.shufflevector"(%363, %69) <{mask = array<i32: 4, 4, 4, 4, 4, 4, 4, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %807 = "llvm.shufflevector"(%363, %69) <{mask = array<i32: 5, 5, 5, 5, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %808 = "llvm.call_intrinsic"(%73, %802, %749) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %809 = "llvm.shl"(%808, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %810 = "llvm.call_intrinsic"(%809, %803, %749) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %811 = "llvm.call_intrinsic"(%73, %803, %749) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %812 = "llvm.shl"(%811, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %813 = "llvm.call_intrinsic"(%812, %804, %749) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %814 = "llvm.call_intrinsic"(%73, %804, %749) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %815 = "llvm.shl"(%814, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %816 = "llvm.call_intrinsic"(%815, %805, %749) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %817 = "llvm.call_intrinsic"(%73, %805, %749) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %818 = "llvm.shl"(%817, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %819 = "llvm.call_intrinsic"(%818, %806, %749) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %820 = "llvm.call_intrinsic"(%73, %806, %749) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %821 = "llvm.shl"(%820, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %822 = "llvm.call_intrinsic"(%821, %807, %749) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %823 = "llvm.call_intrinsic"(%73, %807, %749) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %824 = "llvm.shl"(%823, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %825 = "llvm.shufflevector"(%120, %810) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %826 = "llvm.shufflevector"(%144, %813) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %827 = "llvm.shufflevector"(%152, %816) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %828 = "llvm.shufflevector"(%816, %160) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %829 = "llvm.shufflevector"(%168, %819) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %830 = "llvm.shufflevector"(%819, %176) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %831 = "llvm.shufflevector"(%184, %822) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %832 = "llvm.shufflevector"(%822, %136) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %833 = "llvm.shufflevector"(%192, %824) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %834 = "llvm.shufflevector"(%824, %69) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %835 = "llvm.call_intrinsic"(%825, %802, %749) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %836 = "llvm.add"(%827, %826) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %837 = "llvm.add"(%836, %829) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %838 = "llvm.add"(%837, %831) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %839 = "llvm.add"(%838, %835) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %840 = "llvm.add"(%839, %833) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %841 = "llvm.add"(%830, %828) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %842 = "llvm.add"(%841, %832) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %843 = "llvm.add"(%842, %834) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %844 = "llvm.and"(%840, %52) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %845 = "llvm.shufflevector"(%840, %843) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %846 = "llvm.shl"(%845, %51) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %847 = "llvm.add"(%846, %844) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %848 = "llvm.mul"(%845, %50) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %849 = "llvm.add"(%847, %848) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %850 = "llvm.and"(%849, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %851 = "llvm.lshr"(%849, %48) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %852 = "llvm.shufflevector"(%851, %69) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %853 = "llvm.call_intrinsic"(%850, %47, %852) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %854 = "llvm.shufflevector"(%801, %69) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %855 = "llvm.shufflevector"(%801, %69) <{mask = array<i32: 1, 1, 1, 1, 1, 1, 1, 1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %856 = "llvm.shufflevector"(%801, %69) <{mask = array<i32: 2, 2, 2, 2, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %857 = "llvm.shufflevector"(%801, %69) <{mask = array<i32: 3, 3, 3, 3, 3, 3, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %858 = "llvm.shufflevector"(%801, %69) <{mask = array<i32: 4, 4, 4, 4, 4, 4, 4, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %859 = "llvm.shufflevector"(%801, %69) <{mask = array<i32: 5, 5, 5, 5, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %860 = "llvm.call_intrinsic"(%73, %854, %598) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %861 = "llvm.shl"(%860, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %862 = "llvm.call_intrinsic"(%861, %855, %598) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %863 = "llvm.call_intrinsic"(%73, %855, %598) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %864 = "llvm.shl"(%863, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %865 = "llvm.call_intrinsic"(%864, %856, %598) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %866 = "llvm.call_intrinsic"(%73, %856, %598) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %867 = "llvm.shl"(%866, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %868 = "llvm.call_intrinsic"(%867, %857, %598) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %869 = "llvm.call_intrinsic"(%73, %857, %598) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %870 = "llvm.shl"(%869, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %871 = "llvm.call_intrinsic"(%870, %858, %598) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %872 = "llvm.call_intrinsic"(%73, %858, %598) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %873 = "llvm.shl"(%872, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %874 = "llvm.call_intrinsic"(%873, %859, %598) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %875 = "llvm.call_intrinsic"(%73, %859, %598) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %876 = "llvm.shl"(%875, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %877 = "llvm.shufflevector"(%120, %862) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %878 = "llvm.shufflevector"(%144, %865) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %879 = "llvm.shufflevector"(%152, %868) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %880 = "llvm.shufflevector"(%868, %160) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %881 = "llvm.shufflevector"(%168, %871) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %882 = "llvm.shufflevector"(%871, %176) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %883 = "llvm.shufflevector"(%184, %874) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %884 = "llvm.shufflevector"(%874, %136) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %885 = "llvm.shufflevector"(%192, %876) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %886 = "llvm.shufflevector"(%876, %69) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %887 = "llvm.call_intrinsic"(%877, %854, %598) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %888 = "llvm.add"(%879, %878) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %889 = "llvm.add"(%888, %881) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %890 = "llvm.add"(%889, %883) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %891 = "llvm.add"(%890, %887) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %892 = "llvm.add"(%891, %885) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %893 = "llvm.add"(%882, %880) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %894 = "llvm.add"(%893, %884) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %895 = "llvm.add"(%894, %886) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %896 = "llvm.and"(%892, %52) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %897 = "llvm.shufflevector"(%892, %895) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %898 = "llvm.shl"(%897, %51) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %899 = "llvm.add"(%898, %896) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %900 = "llvm.mul"(%897, %50) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %901 = "llvm.add"(%899, %900) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %902 = "llvm.and"(%901, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %903 = "llvm.lshr"(%901, %48) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %904 = "llvm.shufflevector"(%903, %69) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %905 = "llvm.call_intrinsic"(%902, %47, %904) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %906 = "llvm.shufflevector"(%853, %69) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %907 = "llvm.shufflevector"(%853, %69) <{mask = array<i32: 1, 1, 1, 1, 1, 1, 1, 1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %908 = "llvm.shufflevector"(%853, %69) <{mask = array<i32: 2, 2, 2, 2, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %909 = "llvm.shufflevector"(%853, %69) <{mask = array<i32: 3, 3, 3, 3, 3, 3, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %910 = "llvm.shufflevector"(%853, %69) <{mask = array<i32: 4, 4, 4, 4, 4, 4, 4, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %911 = "llvm.shufflevector"(%853, %69) <{mask = array<i32: 5, 5, 5, 5, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %912 = "llvm.call_intrinsic"(%73, %906, %645) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %913 = "llvm.shl"(%912, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %914 = "llvm.call_intrinsic"(%913, %907, %645) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %915 = "llvm.call_intrinsic"(%73, %907, %645) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %916 = "llvm.shl"(%915, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %917 = "llvm.call_intrinsic"(%916, %908, %645) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %918 = "llvm.call_intrinsic"(%73, %908, %645) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %919 = "llvm.shl"(%918, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %920 = "llvm.call_intrinsic"(%919, %909, %645) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %921 = "llvm.call_intrinsic"(%73, %909, %645) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %922 = "llvm.shl"(%921, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %923 = "llvm.call_intrinsic"(%922, %910, %645) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %924 = "llvm.call_intrinsic"(%73, %910, %645) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %925 = "llvm.shl"(%924, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %926 = "llvm.call_intrinsic"(%925, %911, %645) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %927 = "llvm.call_intrinsic"(%73, %911, %645) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %928 = "llvm.shl"(%927, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %929 = "llvm.shufflevector"(%120, %914) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %930 = "llvm.shufflevector"(%144, %917) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %931 = "llvm.shufflevector"(%152, %920) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %932 = "llvm.shufflevector"(%920, %160) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %933 = "llvm.shufflevector"(%168, %923) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %934 = "llvm.shufflevector"(%923, %176) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %935 = "llvm.shufflevector"(%184, %926) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %936 = "llvm.shufflevector"(%926, %136) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %937 = "llvm.shufflevector"(%192, %928) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %938 = "llvm.shufflevector"(%928, %69) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %939 = "llvm.call_intrinsic"(%929, %906, %645) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %940 = "llvm.add"(%931, %930) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %941 = "llvm.add"(%940, %933) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %942 = "llvm.add"(%941, %935) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %943 = "llvm.add"(%942, %939) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %944 = "llvm.add"(%943, %937) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %945 = "llvm.add"(%934, %932) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %946 = "llvm.add"(%945, %936) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %947 = "llvm.add"(%946, %938) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %948 = "llvm.and"(%944, %52) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %949 = "llvm.shufflevector"(%944, %947) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %950 = "llvm.shl"(%949, %51) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %951 = "llvm.add"(%950, %948) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %952 = "llvm.mul"(%949, %50) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %953 = "llvm.add"(%951, %952) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %954 = "llvm.and"(%953, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %955 = "llvm.lshr"(%953, %48) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %956 = "llvm.shufflevector"(%955, %69) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %957 = "llvm.call_intrinsic"(%954, %47, %956) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.intr.lifetime.start"(%225) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%226) : (!llvm.ptr) -> ()
  "llvm.call"(%225, %905, %226, %957) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_pow22523_2, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, vector<8xi64>, !llvm.ptr, vector<8xi64>) -> ()
  %958 = "llvm.load"(%225) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %959 = "llvm.load"(%226) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.intr.lifetime.end"(%226) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%225) : (!llvm.ptr) -> ()
  %960 = "llvm.call_intrinsic"(%73, %854, %958) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %961 = "llvm.shl"(%960, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %962 = "llvm.call_intrinsic"(%961, %855, %958) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %963 = "llvm.call_intrinsic"(%73, %855, %958) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %964 = "llvm.shl"(%963, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %965 = "llvm.call_intrinsic"(%964, %856, %958) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %966 = "llvm.call_intrinsic"(%73, %856, %958) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %967 = "llvm.shl"(%966, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %968 = "llvm.call_intrinsic"(%967, %857, %958) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %969 = "llvm.call_intrinsic"(%73, %857, %958) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %970 = "llvm.shl"(%969, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %971 = "llvm.call_intrinsic"(%970, %858, %958) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %972 = "llvm.call_intrinsic"(%73, %858, %958) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %973 = "llvm.shl"(%972, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %974 = "llvm.call_intrinsic"(%973, %859, %958) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %975 = "llvm.call_intrinsic"(%73, %859, %958) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %976 = "llvm.shl"(%975, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %977 = "llvm.shufflevector"(%120, %962) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %978 = "llvm.shufflevector"(%144, %965) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %979 = "llvm.shufflevector"(%152, %968) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %980 = "llvm.shufflevector"(%968, %160) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %981 = "llvm.shufflevector"(%168, %971) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %982 = "llvm.shufflevector"(%971, %176) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %983 = "llvm.shufflevector"(%184, %974) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %984 = "llvm.shufflevector"(%974, %136) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %985 = "llvm.shufflevector"(%192, %976) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %986 = "llvm.shufflevector"(%976, %69) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %987 = "llvm.call_intrinsic"(%977, %854, %958) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %988 = "llvm.add"(%979, %978) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %989 = "llvm.add"(%988, %981) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %990 = "llvm.add"(%989, %983) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %991 = "llvm.add"(%990, %987) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %992 = "llvm.add"(%991, %985) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %993 = "llvm.add"(%982, %980) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %994 = "llvm.add"(%993, %984) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %995 = "llvm.add"(%994, %986) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %996 = "llvm.and"(%992, %52) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %997 = "llvm.shufflevector"(%992, %995) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %998 = "llvm.shl"(%997, %51) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %999 = "llvm.add"(%998, %996) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1000 = "llvm.mul"(%997, %50) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1001 = "llvm.add"(%999, %1000) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1002 = "llvm.and"(%1001, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1003 = "llvm.lshr"(%1001, %48) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1004 = "llvm.shufflevector"(%1003, %69) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1005 = "llvm.call_intrinsic"(%1002, %47, %1004) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1006 = "llvm.call_intrinsic"(%73, %906, %959) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1007 = "llvm.shl"(%1006, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1008 = "llvm.call_intrinsic"(%1007, %907, %959) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1009 = "llvm.call_intrinsic"(%73, %907, %959) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1010 = "llvm.shl"(%1009, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1011 = "llvm.call_intrinsic"(%1010, %908, %959) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1012 = "llvm.call_intrinsic"(%73, %908, %959) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1013 = "llvm.shl"(%1012, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1014 = "llvm.call_intrinsic"(%1013, %909, %959) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1015 = "llvm.call_intrinsic"(%73, %909, %959) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1016 = "llvm.shl"(%1015, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1017 = "llvm.call_intrinsic"(%1016, %910, %959) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1018 = "llvm.call_intrinsic"(%73, %910, %959) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1019 = "llvm.shl"(%1018, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1020 = "llvm.call_intrinsic"(%1019, %911, %959) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1021 = "llvm.call_intrinsic"(%73, %911, %959) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1022 = "llvm.shl"(%1021, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1023 = "llvm.shufflevector"(%120, %1008) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1024 = "llvm.shufflevector"(%144, %1011) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1025 = "llvm.shufflevector"(%152, %1014) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1026 = "llvm.shufflevector"(%1014, %160) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1027 = "llvm.shufflevector"(%168, %1017) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1028 = "llvm.shufflevector"(%1017, %176) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1029 = "llvm.shufflevector"(%184, %1020) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1030 = "llvm.shufflevector"(%1020, %136) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1031 = "llvm.shufflevector"(%192, %1022) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1032 = "llvm.shufflevector"(%1022, %69) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1033 = "llvm.call_intrinsic"(%1023, %906, %959) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1034 = "llvm.add"(%1025, %1024) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1035 = "llvm.add"(%1034, %1027) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1036 = "llvm.add"(%1035, %1029) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1037 = "llvm.add"(%1036, %1033) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1038 = "llvm.add"(%1037, %1031) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1039 = "llvm.add"(%1028, %1026) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1040 = "llvm.add"(%1039, %1030) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1041 = "llvm.add"(%1040, %1032) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1042 = "llvm.and"(%1038, %52) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1043 = "llvm.shufflevector"(%1038, %1041) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1044 = "llvm.shl"(%1043, %51) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1045 = "llvm.add"(%1044, %1042) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1046 = "llvm.mul"(%1043, %50) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1047 = "llvm.add"(%1045, %1046) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1048 = "llvm.and"(%1047, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1049 = "llvm.lshr"(%1047, %48) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1050 = "llvm.shufflevector"(%1049, %69) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1051 = "llvm.call_intrinsic"(%1048, %47, %1050) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1052 = "llvm.shufflevector"(%1005, %69) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1053 = "llvm.shufflevector"(%1005, %69) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 3, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1054 = "llvm.shufflevector"(%1005, %69) <{mask = array<i32: 4, 4, 1, 1, 1, 1, 1, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1055 = "llvm.shufflevector"(%1005, %69) <{mask = array<i32: 4, 5, 1, 2, 3, 4, 5, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1056 = "llvm.shufflevector"(%1005, %69) <{mask = array<i32: 3, 7, 5, 7, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1057 = "llvm.shufflevector"(%1005, %69) <{mask = array<i32: 5, 7, 5, 7, 2, 3, 4, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1058 = "llvm.shl"(%1052, %70) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1059 = "llvm.shl"(%1054, %71) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1060 = "llvm.shl"(%1056, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1061 = "llvm.call_intrinsic"(%73, %1059, %1055) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1062 = "llvm.call_intrinsic"(%73, %1060, %1057) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1063 = "llvm.call_intrinsic"(%73, %1058, %1053) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1064 = "llvm.shl"(%1063, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1065 = "llvm.call_intrinsic"(%73, %1059, %1055) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1066 = "llvm.shl"(%1065, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1067 = "llvm.call_intrinsic"(%73, %1060, %1057) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1068 = "llvm.shl"(%1067, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1069 = "llvm.and"(%1061, %75) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1070 = "llvm.and"(%1062, %76) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1071 = "llvm.add"(%1070, %1069) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1072 = "llvm.call_intrinsic"(%1071, %1058, %1053) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1073 = "llvm.and"(%1066, %75) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1074 = "llvm.and"(%1068, %76) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1075 = "llvm.add"(%1073, %1064) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1076 = "llvm.add"(%1075, %1074) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1077 = "llvm.and"(%1061, %88) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1078 = "llvm.and"(%1062, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1079 = "llvm.and"(%1066, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1080 = "llvm.and"(%1068, %112) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1081 = "llvm.add"(%1080, %1079) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1082 = "llvm.shufflevector"(%120, %1076) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1083 = "llvm.add"(%1082, %1072) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1084 = "llvm.shufflevector"(%120, %1081) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1085 = "llvm.shufflevector"(%1076, %128) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1086 = "llvm.add"(%1078, %1077) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1087 = "llvm.add"(%1086, %1084) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1088 = "llvm.add"(%1087, %1085) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1089 = "llvm.and"(%1083, %52) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1090 = "llvm.shufflevector"(%1083, %1088) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1091 = "llvm.shl"(%1090, %51) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1092 = "llvm.add"(%1091, %1089) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1093 = "llvm.mul"(%1090, %50) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1094 = "llvm.add"(%1092, %1093) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1095 = "llvm.and"(%1094, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1096 = "llvm.lshr"(%1094, %48) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1097 = "llvm.shufflevector"(%1096, %69) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1098 = "llvm.call_intrinsic"(%1095, %47, %1097) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1099 = "llvm.shufflevector"(%1051, %69) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1100 = "llvm.shufflevector"(%1051, %69) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 3, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1101 = "llvm.shufflevector"(%1051, %69) <{mask = array<i32: 4, 4, 1, 1, 1, 1, 1, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1102 = "llvm.shufflevector"(%1051, %69) <{mask = array<i32: 4, 5, 1, 2, 3, 4, 5, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1103 = "llvm.shufflevector"(%1051, %69) <{mask = array<i32: 3, 7, 5, 7, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1104 = "llvm.shufflevector"(%1051, %69) <{mask = array<i32: 5, 7, 5, 7, 2, 3, 4, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1105 = "llvm.shl"(%1099, %70) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1106 = "llvm.shl"(%1101, %71) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1107 = "llvm.shl"(%1103, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1108 = "llvm.call_intrinsic"(%73, %1106, %1102) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1109 = "llvm.call_intrinsic"(%73, %1107, %1104) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1110 = "llvm.call_intrinsic"(%73, %1105, %1100) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1111 = "llvm.shl"(%1110, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1112 = "llvm.call_intrinsic"(%73, %1106, %1102) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1113 = "llvm.shl"(%1112, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1114 = "llvm.call_intrinsic"(%73, %1107, %1104) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1115 = "llvm.shl"(%1114, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1116 = "llvm.and"(%1108, %75) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1117 = "llvm.and"(%1109, %76) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1118 = "llvm.add"(%1117, %1116) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1119 = "llvm.call_intrinsic"(%1118, %1105, %1100) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1120 = "llvm.and"(%1113, %75) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1121 = "llvm.and"(%1115, %76) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1122 = "llvm.add"(%1120, %1111) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1123 = "llvm.add"(%1122, %1121) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1124 = "llvm.and"(%1108, %88) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1125 = "llvm.and"(%1109, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1126 = "llvm.and"(%1113, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1127 = "llvm.and"(%1115, %112) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1128 = "llvm.add"(%1127, %1126) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1129 = "llvm.shufflevector"(%120, %1123) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1130 = "llvm.add"(%1129, %1119) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1131 = "llvm.shufflevector"(%120, %1128) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1132 = "llvm.shufflevector"(%1123, %128) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1133 = "llvm.add"(%1125, %1124) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1134 = "llvm.add"(%1133, %1131) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1135 = "llvm.add"(%1134, %1132) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1136 = "llvm.and"(%1130, %52) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1137 = "llvm.shufflevector"(%1130, %1135) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1138 = "llvm.shl"(%1137, %51) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1139 = "llvm.add"(%1138, %1136) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1140 = "llvm.mul"(%1137, %50) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1141 = "llvm.add"(%1139, %1140) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1142 = "llvm.and"(%1141, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1143 = "llvm.lshr"(%1141, %48) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1144 = "llvm.shufflevector"(%1143, %69) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1145 = "llvm.call_intrinsic"(%1142, %47, %1144) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1146 = "llvm.call_intrinsic"(%73, %646, %1098) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1147 = "llvm.shl"(%1146, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1148 = "llvm.call_intrinsic"(%1147, %647, %1098) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1149 = "llvm.call_intrinsic"(%73, %647, %1098) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1150 = "llvm.shl"(%1149, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1151 = "llvm.call_intrinsic"(%1150, %648, %1098) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1152 = "llvm.call_intrinsic"(%73, %648, %1098) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1153 = "llvm.shl"(%1152, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1154 = "llvm.call_intrinsic"(%1153, %649, %1098) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1155 = "llvm.call_intrinsic"(%73, %649, %1098) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1156 = "llvm.shl"(%1155, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1157 = "llvm.call_intrinsic"(%1156, %650, %1098) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1158 = "llvm.call_intrinsic"(%73, %650, %1098) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1159 = "llvm.shl"(%1158, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1160 = "llvm.call_intrinsic"(%1159, %651, %1098) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1161 = "llvm.call_intrinsic"(%73, %651, %1098) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1162 = "llvm.shl"(%1161, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1163 = "llvm.shufflevector"(%120, %1148) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1164 = "llvm.shufflevector"(%144, %1151) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1165 = "llvm.shufflevector"(%152, %1154) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1166 = "llvm.shufflevector"(%1154, %160) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1167 = "llvm.shufflevector"(%168, %1157) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1168 = "llvm.shufflevector"(%1157, %176) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1169 = "llvm.shufflevector"(%184, %1160) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1170 = "llvm.shufflevector"(%1160, %136) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1171 = "llvm.shufflevector"(%192, %1162) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1172 = "llvm.shufflevector"(%1162, %69) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1173 = "llvm.call_intrinsic"(%1163, %646, %1098) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1174 = "llvm.add"(%1165, %1164) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1175 = "llvm.add"(%1174, %1167) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1176 = "llvm.add"(%1175, %1169) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1177 = "llvm.add"(%1176, %1173) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1178 = "llvm.add"(%1177, %1171) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1179 = "llvm.add"(%1168, %1166) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1180 = "llvm.add"(%1179, %1170) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1181 = "llvm.add"(%1180, %1172) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1182 = "llvm.and"(%1178, %52) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1183 = "llvm.shufflevector"(%1178, %1181) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1184 = "llvm.shl"(%1183, %51) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1185 = "llvm.add"(%1184, %1182) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1186 = "llvm.mul"(%1183, %50) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1187 = "llvm.add"(%1185, %1186) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1188 = "llvm.and"(%1187, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1189 = "llvm.lshr"(%1187, %48) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1190 = "llvm.shufflevector"(%1189, %69) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1191 = "llvm.call_intrinsic"(%1188, %47, %1190) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1192 = "llvm.call_intrinsic"(%73, %698, %1145) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1193 = "llvm.shl"(%1192, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1194 = "llvm.call_intrinsic"(%1193, %699, %1145) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1195 = "llvm.call_intrinsic"(%73, %699, %1145) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1196 = "llvm.shl"(%1195, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1197 = "llvm.call_intrinsic"(%1196, %700, %1145) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1198 = "llvm.call_intrinsic"(%73, %700, %1145) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1199 = "llvm.shl"(%1198, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1200 = "llvm.call_intrinsic"(%1199, %701, %1145) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1201 = "llvm.call_intrinsic"(%73, %701, %1145) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1202 = "llvm.shl"(%1201, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1203 = "llvm.call_intrinsic"(%1202, %702, %1145) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1204 = "llvm.call_intrinsic"(%73, %702, %1145) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1205 = "llvm.shl"(%1204, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1206 = "llvm.call_intrinsic"(%1205, %703, %1145) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1207 = "llvm.call_intrinsic"(%73, %703, %1145) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1208 = "llvm.shl"(%1207, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1209 = "llvm.shufflevector"(%120, %1194) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1210 = "llvm.shufflevector"(%144, %1197) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1211 = "llvm.shufflevector"(%152, %1200) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1212 = "llvm.shufflevector"(%1200, %160) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1213 = "llvm.shufflevector"(%168, %1203) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1214 = "llvm.shufflevector"(%1203, %176) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1215 = "llvm.shufflevector"(%184, %1206) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1216 = "llvm.shufflevector"(%1206, %136) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1217 = "llvm.shufflevector"(%192, %1208) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1218 = "llvm.shufflevector"(%1208, %69) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1219 = "llvm.call_intrinsic"(%1209, %698, %1145) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1220 = "llvm.add"(%1211, %1210) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1221 = "llvm.add"(%1220, %1213) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1222 = "llvm.add"(%1221, %1215) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1223 = "llvm.add"(%1222, %1219) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1224 = "llvm.add"(%1223, %1217) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1225 = "llvm.add"(%1214, %1212) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1226 = "llvm.add"(%1225, %1216) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1227 = "llvm.add"(%1226, %1218) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1228 = "llvm.and"(%1224, %52) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1229 = "llvm.shufflevector"(%1224, %1227) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1230 = "llvm.shl"(%1229, %51) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1231 = "llvm.add"(%1230, %1228) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1232 = "llvm.mul"(%1229, %50) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1233 = "llvm.add"(%1231, %1232) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1234 = "llvm.and"(%1233, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1235 = "llvm.lshr"(%1233, %48) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1236 = "llvm.shufflevector"(%1235, %69) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1237 = "llvm.call_intrinsic"(%1234, %47, %1236) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1238 = "llvm.sub"(%1191, %353) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1239 = "llvm.add"(%1238, %200) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1240 = "llvm.sub"(%1237, %362) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1241 = "llvm.add"(%1240, %200) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1242 = "llvm.add"(%1191, %354) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1243 = "llvm.extractelement"(%1241, %64) : (vector<8xi64>, i64) -> i64
  %1244 = "llvm.extractelement"(%1241, %32) : (vector<8xi64>, i64) -> i64
  %1245 = "llvm.extractelement"(%1241, %31) : (vector<8xi64>, i64) -> i64
  %1246 = "llvm.extractelement"(%1241, %60) : (vector<8xi64>, i64) -> i64
  %1247 = "llvm.extractelement"(%1241, %30) : (vector<8xi64>, i64) -> i64
  %1248 = "llvm.extractelement"(%1241, %29) : (vector<8xi64>, i64) -> i64
  %1249 = "llvm.add"(%1248, %28) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1250 = "llvm.ashr"(%1249, %27) : (i64, i64) -> i64
  %1251 = "llvm.and"(%1249, %26) : (i64, i64) -> i64
  %1252 = "llvm.mul"(%1250, %25) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1253 = "llvm.add"(%1252, %1243) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1254 = "llvm.ashr"(%1253, %24) : (i64, i64) -> i64
  %1255 = "llvm.and"(%1253, %23) : (i64, i64) -> i64
  %1256 = "llvm.add"(%1254, %1244) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1257 = "llvm.ashr"(%1256, %24) : (i64, i64) -> i64
  %1258 = "llvm.and"(%1256, %23) : (i64, i64) -> i64
  %1259 = "llvm.add"(%1257, %1245) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1260 = "llvm.ashr"(%1259, %24) : (i64, i64) -> i64
  %1261 = "llvm.and"(%1259, %23) : (i64, i64) -> i64
  %1262 = "llvm.add"(%1260, %1246) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1263 = "llvm.ashr"(%1262, %24) : (i64, i64) -> i64
  %1264 = "llvm.and"(%1262, %23) : (i64, i64) -> i64
  %1265 = "llvm.add"(%1263, %1247) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1266 = "llvm.ashr"(%1265, %24) : (i64, i64) -> i64
  %1267 = "llvm.and"(%1265, %23) : (i64, i64) -> i64
  %1268 = "llvm.add"(%1255, %25) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1269 = "llvm.lshr"(%1268, %24) : (i64, i64) -> i64
  %1270 = "llvm.and"(%1268, %23) : (i64, i64) -> i64
  %1271 = "llvm.add"(%1258, %1269) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1272 = "llvm.lshr"(%1271, %24) : (i64, i64) -> i64
  %1273 = "llvm.and"(%1271, %23) : (i64, i64) -> i64
  %1274 = "llvm.add"(%1261, %1272) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1275 = "llvm.lshr"(%1274, %24) : (i64, i64) -> i64
  %1276 = "llvm.and"(%1274, %23) : (i64, i64) -> i64
  %1277 = "llvm.add"(%1264, %1275) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1278 = "llvm.lshr"(%1277, %24) : (i64, i64) -> i64
  %1279 = "llvm.and"(%1277, %23) : (i64, i64) -> i64
  %1280 = "llvm.add"(%1267, %1278) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1281 = "llvm.lshr"(%1280, %24) : (i64, i64) -> i64
  %1282 = "llvm.and"(%1280, %23) : (i64, i64) -> i64
  %1283 = "llvm.add"(%1251, %22) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1284 = "llvm.add"(%1283, %1266) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1285 = "llvm.add"(%1284, %1281) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1286 = "llvm.and"(%1285, %26) : (i64, i64) -> i64
  %1287 = "llvm.icmp"(%1285, %21) <{predicate = 6 : i64}> : (i64, i64) -> i1
  %1288 = "llvm.select"(%1287, %20, %64) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %1289 = "llvm.add"(%1288, %1270) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1290 = "llvm.ashr"(%1289, %24) : (i64, i64) -> i64
  %1291 = "llvm.add"(%1290, %1273) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1292 = "llvm.ashr"(%1291, %24) : (i64, i64) -> i64
  %1293 = "llvm.add"(%1292, %1276) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1294 = "llvm.ashr"(%1293, %24) : (i64, i64) -> i64
  %1295 = "llvm.add"(%1294, %1279) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1296 = "llvm.ashr"(%1295, %24) : (i64, i64) -> i64
  %1297 = "llvm.add"(%1296, %1282) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1298 = "llvm.ashr"(%1297, %24) : (i64, i64) -> i64
  %1299 = "llvm.add"(%1298, %1286) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1300 = "llvm.or"(%1291, %1289) : (i64, i64) -> i64
  %1301 = "llvm.or"(%1300, %1293) : (i64, i64) -> i64
  %1302 = "llvm.or"(%1301, %1295) : (i64, i64) -> i64
  %1303 = "llvm.or"(%1302, %1297) : (i64, i64) -> i64
  %1304 = "llvm.and"(%1303, %23) : (i64, i64) -> i64
  %1305 = "llvm.or"(%1304, %1299) : (i64, i64) -> i64
  %1306 = "llvm.icmp"(%1305, %64) <{predicate = 1 : i64}> : (i64, i64) -> i1
  %1307 = "llvm.shufflevector"(%1242, %1239) <{mask = array<i32: 1, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<2xi64>
  %1308 = "llvm.shufflevector"(%1242, %1239) <{mask = array<i32: 2, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<2xi64>
  %1309 = "llvm.shufflevector"(%1242, %1239) <{mask = array<i32: 3, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<2xi64>
  %1310 = "llvm.shufflevector"(%1242, %1239) <{mask = array<i32: 4, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<2xi64>
  %1311 = "llvm.shufflevector"(%1242, %1239) <{mask = array<i32: 5, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<2xi64>
  %1312 = "llvm.add"(%1311, %19) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1313 = "llvm.and"(%1312, %18) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1314 = "llvm.ashr"(%1312, %17) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1315 = "llvm.mul"(%1314, %16) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1316 = "llvm.shufflevector"(%1242, %1239) <{mask = array<i32: 0, 8>}> : (vector<8xi64>, vector<8xi64>) -> vector<2xi64>
  %1317 = "llvm.add"(%1315, %1316) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1318 = "llvm.add"(%1313, %15) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1319 = "llvm.ashr"(%1317, %14) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1320 = "llvm.add"(%1319, %1307) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1321 = "llvm.ashr"(%1320, %14) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1322 = "llvm.add"(%1321, %1308) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1323 = "llvm.ashr"(%1322, %14) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1324 = "llvm.add"(%1323, %1309) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1325 = "llvm.ashr"(%1324, %14) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1326 = "llvm.add"(%1325, %1310) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1327 = "llvm.and"(%1317, %13) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1328 = "llvm.and"(%1320, %13) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1329 = "llvm.and"(%1322, %13) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1330 = "llvm.and"(%1324, %13) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1331 = "llvm.ashr"(%1326, %14) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1332 = "llvm.and"(%1326, %13) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1333 = "llvm.add"(%1327, %16) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1334 = "llvm.lshr"(%1333, %14) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1335 = "llvm.and"(%1333, %13) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1336 = "llvm.add"(%1328, %1334) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1337 = "llvm.lshr"(%1336, %14) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1338 = "llvm.and"(%1336, %13) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1339 = "llvm.add"(%1329, %1337) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1340 = "llvm.lshr"(%1339, %14) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1341 = "llvm.and"(%1339, %13) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1342 = "llvm.add"(%1330, %1340) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1343 = "llvm.lshr"(%1342, %14) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1344 = "llvm.and"(%1342, %13) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1345 = "llvm.add"(%1332, %1343) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1346 = "llvm.lshr"(%1345, %14) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1347 = "llvm.and"(%1345, %13) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1348 = "llvm.add"(%1318, %1331) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1349 = "llvm.add"(%1348, %1346) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1350 = "llvm.and"(%1349, %18) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1351 = "llvm.icmp"(%1349, %12) <{predicate = 6 : i64}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi1>
  %1352 = "llvm.select"(%1351, %11, %10) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<2xi1>, vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1353 = "llvm.add"(%1352, %1335) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1354 = "llvm.ashr"(%1353, %14) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1355 = "llvm.add"(%1354, %1338) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1356 = "llvm.ashr"(%1355, %14) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1357 = "llvm.add"(%1356, %1341) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1358 = "llvm.ashr"(%1357, %14) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1359 = "llvm.add"(%1358, %1344) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1360 = "llvm.ashr"(%1359, %14) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1361 = "llvm.add"(%1360, %1347) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1362 = "llvm.ashr"(%1361, %14) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1363 = "llvm.add"(%1362, %1350) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1364 = "llvm.or"(%1355, %1353) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1365 = "llvm.or"(%1364, %1357) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1366 = "llvm.or"(%1365, %1359) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1367 = "llvm.or"(%1366, %1361) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1368 = "llvm.and"(%1367, %13) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1369 = "llvm.or"(%1368, %1363) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1370 = "llvm.icmp"(%1369, %10) <{predicate = 1 : i64}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi1>
  %1371 = "llvm.extractelement"(%1370, %64) : (vector<2xi1>, i64) -> i1
  %1372 = "llvm.extractelement"(%1370, %32) : (vector<2xi1>, i64) -> i1
  %1373 = "llvm.and"(%1371, %1372) : (i1, i1) -> i1
  "llvm.cond_br"(%1373)[^bb3, ^bb1] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb1:  // pred: ^bb0
  %1374 = "llvm.add"(%1237, %363) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1375 = "llvm.extractelement"(%1374, %29) : (vector<8xi64>, i64) -> i64
  %1376 = "llvm.add"(%1375, %28) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1377 = "llvm.and"(%1376, %26) : (i64, i64) -> i64
  %1378 = "llvm.add"(%1377, %22) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1379 = "llvm.ashr"(%1376, %27) : (i64, i64) -> i64
  %1380 = "llvm.mul"(%1379, %25) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1381 = "llvm.extractelement"(%1374, %64) : (vector<8xi64>, i64) -> i64
  %1382 = "llvm.add"(%1380, %1381) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1383 = "llvm.ashr"(%1382, %24) : (i64, i64) -> i64
  %1384 = "llvm.extractelement"(%1374, %32) : (vector<8xi64>, i64) -> i64
  %1385 = "llvm.add"(%1383, %1384) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1386 = "llvm.ashr"(%1385, %24) : (i64, i64) -> i64
  %1387 = "llvm.extractelement"(%1374, %31) : (vector<8xi64>, i64) -> i64
  %1388 = "llvm.add"(%1386, %1387) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1389 = "llvm.ashr"(%1388, %24) : (i64, i64) -> i64
  %1390 = "llvm.extractelement"(%1374, %60) : (vector<8xi64>, i64) -> i64
  %1391 = "llvm.add"(%1389, %1390) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1392 = "llvm.ashr"(%1391, %24) : (i64, i64) -> i64
  %1393 = "llvm.extractelement"(%1374, %30) : (vector<8xi64>, i64) -> i64
  %1394 = "llvm.add"(%1392, %1393) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1395 = "llvm.ashr"(%1394, %24) : (i64, i64) -> i64
  %1396 = "llvm.add"(%1378, %1395) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1397 = "llvm.and"(%1394, %23) : (i64, i64) -> i64
  %1398 = "llvm.and"(%1391, %23) : (i64, i64) -> i64
  %1399 = "llvm.and"(%1388, %23) : (i64, i64) -> i64
  %1400 = "llvm.and"(%1385, %23) : (i64, i64) -> i64
  %1401 = "llvm.and"(%1382, %23) : (i64, i64) -> i64
  %1402 = "llvm.add"(%1401, %25) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1403 = "llvm.lshr"(%1402, %24) : (i64, i64) -> i64
  %1404 = "llvm.add"(%1400, %1403) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1405 = "llvm.lshr"(%1404, %24) : (i64, i64) -> i64
  %1406 = "llvm.add"(%1399, %1405) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1407 = "llvm.lshr"(%1406, %24) : (i64, i64) -> i64
  %1408 = "llvm.add"(%1398, %1407) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1409 = "llvm.lshr"(%1408, %24) : (i64, i64) -> i64
  %1410 = "llvm.add"(%1397, %1409) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1411 = "llvm.lshr"(%1410, %24) : (i64, i64) -> i64
  %1412 = "llvm.add"(%1396, %1411) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1413 = "llvm.icmp"(%1412, %21) <{predicate = 6 : i64}> : (i64, i64) -> i1
  %1414 = "llvm.select"(%1413, %20, %64) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %1415 = "llvm.and"(%1402, %23) : (i64, i64) -> i64
  %1416 = "llvm.add"(%1414, %1415) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1417 = "llvm.ashr"(%1416, %24) : (i64, i64) -> i64
  %1418 = "llvm.and"(%1404, %23) : (i64, i64) -> i64
  %1419 = "llvm.add"(%1417, %1418) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1420 = "llvm.or"(%1419, %1416) : (i64, i64) -> i64
  %1421 = "llvm.ashr"(%1419, %24) : (i64, i64) -> i64
  %1422 = "llvm.and"(%1406, %23) : (i64, i64) -> i64
  %1423 = "llvm.add"(%1421, %1422) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1424 = "llvm.or"(%1420, %1423) : (i64, i64) -> i64
  %1425 = "llvm.ashr"(%1423, %24) : (i64, i64) -> i64
  %1426 = "llvm.and"(%1408, %23) : (i64, i64) -> i64
  %1427 = "llvm.add"(%1425, %1426) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1428 = "llvm.or"(%1424, %1427) : (i64, i64) -> i64
  %1429 = "llvm.ashr"(%1427, %24) : (i64, i64) -> i64
  %1430 = "llvm.and"(%1410, %23) : (i64, i64) -> i64
  %1431 = "llvm.add"(%1429, %1430) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1432 = "llvm.or"(%1428, %1431) : (i64, i64) -> i64
  %1433 = "llvm.and"(%1432, %23) : (i64, i64) -> i64
  %1434 = "llvm.ashr"(%1431, %24) : (i64, i64) -> i64
  %1435 = "llvm.and"(%1412, %26) : (i64, i64) -> i64
  %1436 = "llvm.add"(%1434, %1435) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1437 = "llvm.or"(%1433, %1436) : (i64, i64) -> i64
  %1438 = "llvm.icmp"(%1437, %64) <{predicate = 1 : i64}> : (i64, i64) -> i1
  %1439 = "llvm.and"(%1438, %1306) : (i1, i1) -> i1
  "llvm.cond_br"(%1439)[^bb4, ^bb2] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb2:  // pred: ^bb1
  %1440 = "llvm.xor"(%1372, %9) : (i1, i1) -> i1
  %1441 = "llvm.sext"(%1440) : (i1) -> i8
  %1442 = "llvm.bitcast"(%1441) : (i8) -> vector<8xi1>
  %1443 = "llvm.select"(%1442, %36, %8) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1444 = "llvm.xor"(%1306, %9) : (i1, i1) -> i1
  %1445 = "llvm.sext"(%1444) : (i1) -> i8
  %1446 = "llvm.bitcast"(%1445) : (i8) -> vector<8xi1>
  %1447 = "llvm.select"(%1446, %36, %8) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1448 = "llvm.shufflevector"(%1005, %69) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1449 = "llvm.shufflevector"(%1005, %69) <{mask = array<i32: 1, 1, 1, 1, 1, 1, 1, 1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1450 = "llvm.shufflevector"(%1005, %69) <{mask = array<i32: 2, 2, 2, 2, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1451 = "llvm.shufflevector"(%1005, %69) <{mask = array<i32: 3, 3, 3, 3, 3, 3, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1452 = "llvm.shufflevector"(%1005, %69) <{mask = array<i32: 4, 4, 4, 4, 4, 4, 4, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1453 = "llvm.shufflevector"(%1005, %69) <{mask = array<i32: 5, 5, 5, 5, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1454 = "llvm.call_intrinsic"(%73, %1448, %1443) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1455 = "llvm.shl"(%1454, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1456 = "llvm.call_intrinsic"(%1455, %1449, %1443) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1457 = "llvm.call_intrinsic"(%73, %1449, %1443) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1458 = "llvm.shl"(%1457, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1459 = "llvm.call_intrinsic"(%1458, %1450, %1443) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1460 = "llvm.call_intrinsic"(%73, %1450, %1443) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1461 = "llvm.shl"(%1460, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1462 = "llvm.call_intrinsic"(%1461, %1451, %1443) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1463 = "llvm.call_intrinsic"(%73, %1451, %1443) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1464 = "llvm.shl"(%1463, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1465 = "llvm.call_intrinsic"(%1464, %1452, %1443) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1466 = "llvm.call_intrinsic"(%73, %1452, %1443) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1467 = "llvm.shl"(%1466, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1468 = "llvm.call_intrinsic"(%1467, %1453, %1443) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1469 = "llvm.call_intrinsic"(%73, %1453, %1443) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1470 = "llvm.shl"(%1469, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1471 = "llvm.shufflevector"(%120, %1456) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1472 = "llvm.shufflevector"(%144, %1459) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1473 = "llvm.shufflevector"(%152, %1462) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1474 = "llvm.shufflevector"(%1462, %160) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1475 = "llvm.shufflevector"(%168, %1465) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1476 = "llvm.shufflevector"(%1465, %176) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1477 = "llvm.shufflevector"(%184, %1468) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1478 = "llvm.shufflevector"(%1468, %136) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1479 = "llvm.shufflevector"(%192, %1470) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1480 = "llvm.shufflevector"(%1470, %69) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1481 = "llvm.call_intrinsic"(%1471, %1448, %1443) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1482 = "llvm.add"(%1473, %1472) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1483 = "llvm.add"(%1482, %1475) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1484 = "llvm.add"(%1483, %1477) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1485 = "llvm.add"(%1484, %1481) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1486 = "llvm.add"(%1485, %1479) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1487 = "llvm.add"(%1476, %1474) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1488 = "llvm.add"(%1487, %1478) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1489 = "llvm.add"(%1488, %1480) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1490 = "llvm.and"(%1486, %52) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1491 = "llvm.shufflevector"(%1486, %1489) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1492 = "llvm.shl"(%1491, %51) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1493 = "llvm.add"(%1492, %1490) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1494 = "llvm.mul"(%1491, %50) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1495 = "llvm.add"(%1493, %1494) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1496 = "llvm.and"(%1495, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1497 = "llvm.lshr"(%1495, %48) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1498 = "llvm.shufflevector"(%1497, %69) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1499 = "llvm.call_intrinsic"(%1496, %47, %1498) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1500 = "llvm.shufflevector"(%1051, %69) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1501 = "llvm.shufflevector"(%1051, %69) <{mask = array<i32: 1, 1, 1, 1, 1, 1, 1, 1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1502 = "llvm.shufflevector"(%1051, %69) <{mask = array<i32: 2, 2, 2, 2, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1503 = "llvm.shufflevector"(%1051, %69) <{mask = array<i32: 3, 3, 3, 3, 3, 3, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1504 = "llvm.shufflevector"(%1051, %69) <{mask = array<i32: 4, 4, 4, 4, 4, 4, 4, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1505 = "llvm.shufflevector"(%1051, %69) <{mask = array<i32: 5, 5, 5, 5, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1506 = "llvm.call_intrinsic"(%73, %1500, %1447) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1507 = "llvm.shl"(%1506, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1508 = "llvm.call_intrinsic"(%1507, %1501, %1447) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1509 = "llvm.call_intrinsic"(%73, %1501, %1447) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1510 = "llvm.shl"(%1509, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1511 = "llvm.call_intrinsic"(%1510, %1502, %1447) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1512 = "llvm.call_intrinsic"(%73, %1502, %1447) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1513 = "llvm.shl"(%1512, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1514 = "llvm.call_intrinsic"(%1513, %1503, %1447) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1515 = "llvm.call_intrinsic"(%73, %1503, %1447) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1516 = "llvm.shl"(%1515, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1517 = "llvm.call_intrinsic"(%1516, %1504, %1447) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1518 = "llvm.call_intrinsic"(%73, %1504, %1447) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1519 = "llvm.shl"(%1518, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1520 = "llvm.call_intrinsic"(%1519, %1505, %1447) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1521 = "llvm.call_intrinsic"(%73, %1505, %1447) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1522 = "llvm.shl"(%1521, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1523 = "llvm.shufflevector"(%120, %1508) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1524 = "llvm.shufflevector"(%144, %1511) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1525 = "llvm.shufflevector"(%152, %1514) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1526 = "llvm.shufflevector"(%1514, %160) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1527 = "llvm.shufflevector"(%168, %1517) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1528 = "llvm.shufflevector"(%1517, %176) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1529 = "llvm.shufflevector"(%184, %1520) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1530 = "llvm.shufflevector"(%1520, %136) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1531 = "llvm.shufflevector"(%192, %1522) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1532 = "llvm.shufflevector"(%1522, %69) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1533 = "llvm.call_intrinsic"(%1523, %1500, %1447) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1534 = "llvm.add"(%1525, %1524) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1535 = "llvm.add"(%1534, %1527) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1536 = "llvm.add"(%1535, %1529) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1537 = "llvm.add"(%1536, %1533) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1538 = "llvm.add"(%1537, %1531) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1539 = "llvm.add"(%1528, %1526) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1540 = "llvm.add"(%1539, %1530) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1541 = "llvm.add"(%1540, %1532) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1542 = "llvm.and"(%1538, %52) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1543 = "llvm.shufflevector"(%1538, %1541) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1544 = "llvm.shl"(%1543, %51) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1545 = "llvm.add"(%1544, %1542) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1546 = "llvm.mul"(%1543, %50) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1547 = "llvm.add"(%1545, %1546) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1548 = "llvm.and"(%1547, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1549 = "llvm.lshr"(%1547, %48) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1550 = "llvm.shufflevector"(%1549, %69) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1551 = "llvm.call_intrinsic"(%1548, %47, %1550) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1552 = "llvm.sub"(%7, %1499) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1553 = "llvm.and"(%1552, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1554 = "llvm.ashr"(%1552, %48) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1555 = "llvm.shufflevector"(%1554, %136) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 8, 8>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1556 = "llvm.mul"(%1555, %45) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1557 = "llvm.and"(%1556, %44) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1558 = "llvm.add"(%1553, %43) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1559 = "llvm.add"(%1558, %1555) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1560 = "llvm.add"(%1559, %1557) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1561 = "llvm.shufflevector"(%1551, %1499) <{mask = array<i32: 5, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<2xi64>
  %1562 = "llvm.add"(%1561, %19) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1563 = "llvm.ashr"(%1562, %17) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1564 = "llvm.mul"(%1563, %16) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1565 = "llvm.shufflevector"(%1551, %1499) <{mask = array<i32: 0, 8>}> : (vector<8xi64>, vector<8xi64>) -> vector<2xi64>
  %1566 = "llvm.add"(%1564, %1565) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1567 = "llvm.and"(%1566, %13) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1568 = "llvm.add"(%1567, %16) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1569 = "llvm.shufflevector"(%1551, %1499) <{mask = array<i32: 2, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<2xi64>
  %1570 = "llvm.shufflevector"(%1551, %1499) <{mask = array<i32: 3, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<2xi64>
  %1571 = "llvm.shufflevector"(%1551, %1499) <{mask = array<i32: 4, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<2xi64>
  %1572 = "llvm.and"(%1562, %18) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1573 = "llvm.add"(%1572, %15) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1574 = "llvm.and"(%1568, %13) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1575 = "llvm.ashr"(%1566, %14) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1576 = "llvm.shufflevector"(%1551, %1499) <{mask = array<i32: 1, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<2xi64>
  %1577 = "llvm.add"(%1575, %1576) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1578 = "llvm.and"(%1577, %13) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1579 = "llvm.lshr"(%1568, %14) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1580 = "llvm.add"(%1578, %1579) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1581 = "llvm.ashr"(%1577, %14) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1582 = "llvm.add"(%1581, %1569) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1583 = "llvm.and"(%1582, %13) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1584 = "llvm.lshr"(%1580, %14) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1585 = "llvm.add"(%1583, %1584) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1586 = "llvm.ashr"(%1582, %14) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1587 = "llvm.add"(%1586, %1570) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1588 = "llvm.and"(%1587, %13) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1589 = "llvm.lshr"(%1585, %14) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1590 = "llvm.add"(%1588, %1589) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1591 = "llvm.ashr"(%1587, %14) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1592 = "llvm.add"(%1591, %1571) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1593 = "llvm.and"(%1592, %13) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1594 = "llvm.lshr"(%1590, %14) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1595 = "llvm.add"(%1593, %1594) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1596 = "llvm.ashr"(%1592, %14) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1597 = "llvm.lshr"(%1595, %14) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1598 = "llvm.add"(%1573, %1596) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1599 = "llvm.add"(%1598, %1597) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1600 = "llvm.icmp"(%1599, %12) <{predicate = 6 : i64}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi1>
  %1601 = "llvm.select"(%1600, %11, %10) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<2xi1>, vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1602 = "llvm.add"(%1601, %1574) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1603 = "llvm.and"(%1580, %13) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1604 = "llvm.and"(%1585, %13) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1605 = "llvm.and"(%1590, %13) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1606 = "llvm.and"(%1595, %13) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1607 = "llvm.and"(%1599, %18) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1608 = "llvm.ashr"(%1602, %14) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1609 = "llvm.add"(%1608, %1603) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1610 = "llvm.ashr"(%1609, %14) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1611 = "llvm.add"(%1610, %1604) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1612 = "llvm.ashr"(%1611, %14) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1613 = "llvm.add"(%1612, %1605) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1614 = "llvm.ashr"(%1613, %14) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1615 = "llvm.add"(%1614, %1606) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1616 = "llvm.ashr"(%1615, %14) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1617 = "llvm.add"(%1616, %1607) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1618 = "llvm.or"(%1609, %1602) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1619 = "llvm.or"(%1618, %1611) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1620 = "llvm.or"(%1619, %1613) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1621 = "llvm.or"(%1620, %1615) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1622 = "llvm.and"(%1621, %13) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1623 = "llvm.or"(%1622, %1617) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1624 = "llvm.icmp"(%1623, %10) <{predicate = 1 : i64}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi1>
  %1625 = "llvm.trunc"(%1602) <{overflowFlags = 0 : i32}> : (vector<2xi64>) -> vector<2xi32>
  %1626 = "llvm.and"(%1625, %6) : (vector<2xi32>, vector<2xi32>) -> vector<2xi32>
  %1627 = "llvm.icmp"(%1626, %233) <{predicate = 0 : i64}> : (vector<2xi32>, vector<2xi32>) -> vector<2xi1>
  %1628 = "llvm.extractelement"(%1627, %32) : (vector<2xi1>, i64) -> i1
  %1629 = "llvm.extractelement"(%1624, %32) : (vector<2xi1>, i64) -> i1
  %1630 = "llvm.select"(%1629, %1628, %5) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i1, i1) -> i1
  %1631 = "llvm.sext"(%1630) : (i1) -> i8
  %1632 = "llvm.bitcast"(%1631) : (i8) -> vector<8xi1>
  %1633 = "llvm.select"(%1632, %1499, %1560) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1634 = "llvm.extractelement"(%1627, %64) : (vector<2xi1>, i64) -> i1
  %1635 = "llvm.extractelement"(%1624, %64) : (vector<2xi1>, i64) -> i1
  %1636 = "llvm.select"(%1635, %1634, %5) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i1, i1) -> i1
  %1637 = "llvm.sext"(%1636) : (i1) -> i8
  %1638 = "llvm.sub"(%7, %1551) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1639 = "llvm.and"(%1638, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1640 = "llvm.ashr"(%1638, %48) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1641 = "llvm.shufflevector"(%1640, %136) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 8, 8>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1642 = "llvm.mul"(%1641, %45) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1643 = "llvm.and"(%1642, %44) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1644 = "llvm.add"(%1639, %43) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1645 = "llvm.add"(%1644, %1641) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1646 = "llvm.add"(%1645, %1643) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1647 = "llvm.bitcast"(%1637) : (i8) -> vector<8xi1>
  %1648 = "llvm.select"(%1647, %1551, %1646) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1649 = "llvm.shufflevector"(%1633, %69) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1650 = "llvm.shufflevector"(%1633, %69) <{mask = array<i32: 1, 1, 1, 1, 1, 1, 1, 1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1651 = "llvm.shufflevector"(%1633, %69) <{mask = array<i32: 2, 2, 2, 2, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1652 = "llvm.shufflevector"(%1633, %69) <{mask = array<i32: 3, 3, 3, 3, 3, 3, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1653 = "llvm.shufflevector"(%1633, %69) <{mask = array<i32: 4, 4, 4, 4, 4, 4, 4, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1654 = "llvm.shufflevector"(%1633, %69) <{mask = array<i32: 5, 5, 5, 5, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1655 = "llvm.call_intrinsic"(%73, %1649, %244) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1656 = "llvm.shl"(%1655, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1657 = "llvm.call_intrinsic"(%1656, %1650, %244) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1658 = "llvm.call_intrinsic"(%73, %1650, %244) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1659 = "llvm.shl"(%1658, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1660 = "llvm.call_intrinsic"(%1659, %1651, %244) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1661 = "llvm.call_intrinsic"(%73, %1651, %244) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1662 = "llvm.shl"(%1661, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1663 = "llvm.call_intrinsic"(%1662, %1652, %244) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1664 = "llvm.call_intrinsic"(%73, %1652, %244) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1665 = "llvm.shl"(%1664, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1666 = "llvm.call_intrinsic"(%1665, %1653, %244) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1667 = "llvm.call_intrinsic"(%73, %1653, %244) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1668 = "llvm.shl"(%1667, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1669 = "llvm.call_intrinsic"(%1668, %1654, %244) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1670 = "llvm.call_intrinsic"(%73, %1654, %244) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1671 = "llvm.shl"(%1670, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1672 = "llvm.shufflevector"(%120, %1657) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1673 = "llvm.shufflevector"(%144, %1660) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1674 = "llvm.shufflevector"(%152, %1663) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1675 = "llvm.shufflevector"(%1663, %160) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1676 = "llvm.shufflevector"(%168, %1666) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1677 = "llvm.shufflevector"(%1666, %176) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1678 = "llvm.shufflevector"(%184, %1669) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1679 = "llvm.shufflevector"(%1669, %136) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1680 = "llvm.shufflevector"(%192, %1671) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1681 = "llvm.shufflevector"(%1671, %69) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1682 = "llvm.call_intrinsic"(%1672, %1649, %244) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1683 = "llvm.add"(%1674, %1673) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1684 = "llvm.add"(%1683, %1676) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1685 = "llvm.add"(%1684, %1678) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1686 = "llvm.add"(%1685, %1682) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1687 = "llvm.add"(%1686, %1680) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1688 = "llvm.add"(%1677, %1675) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1689 = "llvm.add"(%1688, %1679) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1690 = "llvm.add"(%1689, %1681) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1691 = "llvm.and"(%1687, %52) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1692 = "llvm.shufflevector"(%1687, %1690) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1693 = "llvm.shl"(%1692, %51) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1694 = "llvm.add"(%1693, %1691) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1695 = "llvm.mul"(%1692, %50) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1696 = "llvm.add"(%1694, %1695) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1697 = "llvm.and"(%1696, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1698 = "llvm.lshr"(%1696, %48) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1699 = "llvm.shufflevector"(%1698, %69) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1700 = "llvm.call_intrinsic"(%1697, %47, %1699) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1701 = "llvm.shufflevector"(%1648, %69) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1702 = "llvm.shufflevector"(%1648, %69) <{mask = array<i32: 1, 1, 1, 1, 1, 1, 1, 1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1703 = "llvm.shufflevector"(%1648, %69) <{mask = array<i32: 2, 2, 2, 2, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1704 = "llvm.shufflevector"(%1648, %69) <{mask = array<i32: 3, 3, 3, 3, 3, 3, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1705 = "llvm.shufflevector"(%1648, %69) <{mask = array<i32: 4, 4, 4, 4, 4, 4, 4, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1706 = "llvm.shufflevector"(%1648, %69) <{mask = array<i32: 5, 5, 5, 5, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1707 = "llvm.call_intrinsic"(%73, %1701, %251) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1708 = "llvm.shl"(%1707, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1709 = "llvm.call_intrinsic"(%1708, %1702, %251) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1710 = "llvm.call_intrinsic"(%73, %1702, %251) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1711 = "llvm.shl"(%1710, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1712 = "llvm.call_intrinsic"(%1711, %1703, %251) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1713 = "llvm.call_intrinsic"(%73, %1703, %251) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1714 = "llvm.shl"(%1713, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1715 = "llvm.call_intrinsic"(%1714, %1704, %251) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1716 = "llvm.call_intrinsic"(%73, %1704, %251) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1717 = "llvm.shl"(%1716, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1718 = "llvm.call_intrinsic"(%1717, %1705, %251) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1719 = "llvm.call_intrinsic"(%73, %1705, %251) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1720 = "llvm.shl"(%1719, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1721 = "llvm.call_intrinsic"(%1720, %1706, %251) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1722 = "llvm.call_intrinsic"(%73, %1706, %251) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1723 = "llvm.shl"(%1722, %74) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1724 = "llvm.shufflevector"(%120, %1709) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1725 = "llvm.shufflevector"(%144, %1712) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1726 = "llvm.shufflevector"(%152, %1715) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1727 = "llvm.shufflevector"(%1715, %160) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1728 = "llvm.shufflevector"(%168, %1718) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1729 = "llvm.shufflevector"(%1718, %176) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1730 = "llvm.shufflevector"(%184, %1721) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1731 = "llvm.shufflevector"(%1721, %136) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1732 = "llvm.shufflevector"(%192, %1723) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1733 = "llvm.shufflevector"(%1723, %69) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1734 = "llvm.call_intrinsic"(%1724, %1701, %251) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1735 = "llvm.add"(%1726, %1725) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1736 = "llvm.add"(%1735, %1728) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1737 = "llvm.add"(%1736, %1730) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1738 = "llvm.add"(%1737, %1734) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1739 = "llvm.add"(%1738, %1732) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1740 = "llvm.add"(%1729, %1727) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1741 = "llvm.add"(%1740, %1731) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1742 = "llvm.add"(%1741, %1733) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1743 = "llvm.and"(%1739, %52) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1744 = "llvm.shufflevector"(%1739, %1742) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1745 = "llvm.shl"(%1744, %51) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1746 = "llvm.add"(%1745, %1743) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1747 = "llvm.mul"(%1744, %50) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1748 = "llvm.add"(%1746, %1747) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1749 = "llvm.and"(%1748, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1750 = "llvm.lshr"(%1748, %48) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1751 = "llvm.shufflevector"(%1750, %69) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1752 = "llvm.call_intrinsic"(%1749, %47, %1751) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1753 = "llvm.shufflevector"(%1633, %208) <{mask = array<i32: 0, 1, 8, 9, 4, 5, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1754 = "llvm.shufflevector"(%244, %1700) <{mask = array<i32: 0, 1, 8, 9, 4, 5, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1755 = "llvm.shufflevector"(%1633, %216) <{mask = array<i32: 2, 3, 10, 11, 6, 7, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1756 = "llvm.shufflevector"(%244, %1700) <{mask = array<i32: 2, 3, 10, 11, 6, 7, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1757 = "llvm.shufflevector"(%1753, %1754) <{mask = array<i32: 0, 8, 2, 10, -1, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1758 = "llvm.shufflevector"(%1753, %1754) <{mask = array<i32: -1, -1, -1, -1, 5, 13, 7, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1759 = "llvm.shufflevector"(%1755, %1756) <{mask = array<i32: 0, 8, 2, 10, -1, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1760 = "llvm.shufflevector"(%1755, %1756) <{mask = array<i32: 1, 9, 3, 11, -1, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1761 = "llvm.shufflevector"(%1757, %1760) <{mask = array<i32: 0, 1, 2, 3, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1761, %arg0) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1762 = "llvm.shufflevector"(%1753, %1754) <{mask = array<i32: 1, 9, 3, 11, 4, 12, 6, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1762, %arg1) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1763 = "llvm.shufflevector"(%1759, %1758) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1763, %arg2) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1764 = "llvm.shufflevector"(%1648, %208) <{mask = array<i32: 0, 1, 8, 9, 4, 5, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1765 = "llvm.shufflevector"(%251, %1752) <{mask = array<i32: 0, 1, 8, 9, 4, 5, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1766 = "llvm.shufflevector"(%1648, %216) <{mask = array<i32: 2, 3, 10, 11, 6, 7, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1767 = "llvm.shufflevector"(%251, %1752) <{mask = array<i32: 2, 3, 10, 11, 6, 7, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1768 = "llvm.shufflevector"(%1764, %1765) <{mask = array<i32: 0, 8, 2, 10, -1, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1769 = "llvm.shufflevector"(%1764, %1765) <{mask = array<i32: -1, -1, -1, -1, 5, 13, 7, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1770 = "llvm.shufflevector"(%1766, %1767) <{mask = array<i32: 0, 8, 2, 10, -1, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1771 = "llvm.shufflevector"(%1766, %1767) <{mask = array<i32: 1, 9, 3, 11, -1, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1772 = "llvm.shufflevector"(%1768, %1771) <{mask = array<i32: 0, 1, 2, 3, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1772, %arg4) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1773 = "llvm.shufflevector"(%1764, %1765) <{mask = array<i32: 1, 9, 3, 11, 4, 12, 6, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1773, %arg5) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1774 = "llvm.shufflevector"(%1770, %1769) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1774, %arg6) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1775 = "llvm.load"(%arg0) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1776 = "llvm.lshr"(%1775, %4) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1777 = "llvm.load"(%arg1) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1778 = "llvm.lshr"(%1777, %4) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1779 = "llvm.load"(%arg2) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1780 = "llvm.lshr"(%1779, %3) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1781 = "llvm.mul"(%1780, %224) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1782 = "llvm.and"(%1775, %68) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1783 = "llvm.shufflevector"(%1781, %1780) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1784 = "llvm.add"(%1783, %1782) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1784, %arg0) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1785 = "llvm.load"(%arg1) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1786 = "llvm.and"(%1785, %68) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1787 = "llvm.add"(%1786, %1776) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1787, %arg1) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1788 = "llvm.load"(%arg2) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1789 = "llvm.and"(%1788, %2) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1790 = "llvm.add"(%1789, %1778) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1790, %arg2) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1791 = "llvm.load"(%arg4) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1792 = "llvm.lshr"(%1791, %4) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1793 = "llvm.load"(%arg5) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1794 = "llvm.lshr"(%1793, %4) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1795 = "llvm.load"(%arg6) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1796 = "llvm.lshr"(%1795, %3) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1797 = "llvm.mul"(%1796, %224) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1798 = "llvm.and"(%1791, %68) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1799 = "llvm.shufflevector"(%1797, %1796) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1800 = "llvm.add"(%1799, %1798) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1800, %arg4) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1801 = "llvm.load"(%arg5) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1802 = "llvm.and"(%1801, %68) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1803 = "llvm.add"(%1802, %1792) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1803, %arg5) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1804 = "llvm.load"(%arg6) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1805 = "llvm.and"(%1804, %2) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1806 = "llvm.add"(%1805, %1794) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.br"(%1806, %80)[^bb5] : (vector<8xi64>, i32) -> ()
^bb3:  // pred: ^bb0
  "llvm.store"(%73, %arg0) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%73, %arg4) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%73, %arg1) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%73, %arg5) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%73, %arg2) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.br"(%73, %0)[^bb5] : (vector<8xi64>, i32) -> ()
^bb4:  // pred: ^bb1
  "llvm.store"(%73, %arg0) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%73, %arg4) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%73, %arg1) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%73, %arg5) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%73, %arg2) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.br"(%73, %1)[^bb5] : (vector<8xi64>, i32) -> ()
^bb5(%1807: vector<8xi64>, %1808: i32):  // 3 preds: ^bb2, ^bb3, ^bb4
  "llvm.store"(%1807, %arg6) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.return"(%1808) : (i32) -> ()
}) : () -> ()

    with
      @fd_r43x6_pow22523_2 := Firedancer.Lane.Mlir.fd_r43x6_pow22523_2

end

end Firedancer.Lane.Mlir
