
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.Lane.Mlir.fd_f25519_one_28
public import Firedancer.Lane.Mlir.fd_f25519_sqrt_ratio

namespace Firedancer.Lane.Mlir

@[expose] public section

noncomputable mlir_def fd_ristretto255_point_tobytes := "llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nofree, llvm.noundef, llvm.returned, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<ptr (ptr, ptr)>, linkage = #llvm.linkage<external>, no_unwind, passthrough = ["sspstrong", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], res_attrs = [{llvm.noundef}], sym_name = "fd_ristretto255_point_tobytes", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr):
  %0 = "llvm.mlir.constant"() <{value = 44 : i64}> : () -> i64
  %1 = "llvm.mlir.constant"() <{value = 22 : i64}> : () -> i64
  %2 = "llvm.mlir.constant"() <{value = 23 : i64}> : () -> i64
  %3 = "llvm.mlir.constant"() <{value = 159383552 : i64}> : () -> i64
  %4 = "llvm.mlir.constant"() <{value = 1048576 : i64}> : () -> i64
  %5 = "llvm.mlir.constant"() <{value = 18 : i64}> : () -> i64
  %6 = "llvm.mlir.constant"() <{value = -1 : i8}> : () -> i8
  %7 = "llvm.mlir.constant"() <{value = 1 : i8}> : () -> i8
  %8 = "llvm.mlir.undef"() : () -> vector<4xi64>
  %9 = "llvm.mlir.constant"() <{value = 21 : i64}> : () -> i64
  %10 = "llvm.mlir.constant"() <{value = 42 : i64}> : () -> i64
  %11 = "llvm.mlir.constant"() <{value = 20 : i64}> : () -> i64
  %12 = "llvm.mlir.constant"() <{value = dense<[8796093022207, -1]> : vector<2xi64>}> : () -> vector<2xi64>
  %13 = "llvm.mlir.poison"() : () -> vector<2xi64>
  %14 = "llvm.mlir.constant"() <{value = dense<8796093022207> : vector<4xi64>}> : () -> vector<4xi64>
  %15 = "llvm.mlir.poison"() : () -> vector<4xi64>
  %16 = "llvm.mlir.constant"() <{value = -19 : i64}> : () -> i64
  %17 = "llvm.mlir.constant"() <{value = 1099511627776 : i64}> : () -> i64
  %18 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %19 = "llvm.mlir.constant"() <{value = 1099511627775 : i64}> : () -> i64
  %20 = "llvm.mlir.constant"() <{value = 43 : i64}> : () -> i64
  %21 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
  %22 = "llvm.mlir.constant"() <{value = 8796093022207 : i64}> : () -> i64
  %23 = "llvm.mlir.constant"() <{value = 5 : i64}> : () -> i64
  %24 = "llvm.mlir.constant"() <{value = 4 : i64}> : () -> i64
  %25 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %26 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %27 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %28 = "llvm.mlir.constant"() <{value = dense<[6229856174314, 199041956127, 2700399369577, 6360829848608, 3297631104039, 1034433989535, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %29 = "llvm.mlir.constant"() <{value = dense<[3467281080496, 6582290652611, 5210002954932, 329084955603, 4526638806224, 373767602335, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %30 = "llvm.mlir.poison"() : () -> vector<6xi64>
  %31 = "llvm.mlir.addressof"() <{global_name = @fd_f25519_one.28}> : () -> !llvm.ptr
  %32 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %33 = "llvm.mlir.constant"() <{value = dense<[0, -1, 0, -1, -1, -1, -1, -1]> : vector<8xi64>}> : () -> vector<8xi64>
  %34 = "llvm.mlir.constant"() <{value = dense<[0, 0, -1, -1, -1, -1, -1, -1]> : vector<8xi64>}> : () -> vector<8xi64>
  %35 = "llvm.mlir.constant"() <{value = dense<[1, 1, 0, 1, 0, 1, 1, 1]> : vector<8xi64>}> : () -> vector<8xi64>
  %36 = "llvm.mlir.constant"() <{value = dense<[0, 1, 0, 1, 1, 1, 1, 1]> : vector<8xi64>}> : () -> vector<8xi64>
  %37 = "llvm.mlir.constant"() <{value = dense<[0, 1, 1, 1, 1, 1, 0, 1]> : vector<8xi64>}> : () -> vector<8xi64>
  %38 = "llvm.mlir.constant"() <{value = dense<24> : vector<8xi64>}> : () -> vector<8xi64>
  %39 = "llvm.mlir.constant"() <{value = dense<7> : vector<8xi64>}> : () -> vector<8xi64>
  %40 = "llvm.mlir.constant"() <{value = dense<[-1, -1, -1, -1, -1, -1, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %41 = "llvm.mlir.constant"() <{value = dense<9> : vector<8xi64>}> : () -> vector<8xi64>
  %42 = "llvm.mlir.constant"() <{value = dense<0> : vector<8xi64>}> : () -> vector<8xi64>
  %43 = "llvm.mlir.constant"() <{value = dense<[159383552, 1048576, 1048576, 1048576, 1048576, 1048576, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %44 = "llvm.mlir.constant"() <{value = dense<[-1, 0, 0, 0, 0, 0, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %45 = "llvm.mlir.constant"() <{value = dense<18> : vector<8xi64>}> : () -> vector<8xi64>
  %46 = "llvm.mlir.constant"() <{value = dense<[8795933638637, 8796091973631, 8796091973631, 8796091973631, 8796091973631, 1099510579199, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %47 = "llvm.mlir.constant"() <{value = dense<[19, 1, 1, 1, 1, 1, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %48 = "llvm.mlir.poison"() : () -> vector<8xi64>
  %49 = "llvm.mlir.constant"() <{value = dense<[43, 43, 43, 43, 43, 40, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %50 = "llvm.mlir.constant"() <{value = dense<[8796093022207, 8796093022207, 8796093022207, 8796093022207, 8796093022207, 1099511627775, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %51 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %52 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %53 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %54 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %55 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %56 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %57 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %58 = "llvm.mlir.poison"() : () -> i64
  %59 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %60 = "llvm.mlir.undef"() : () -> vector<8xi64>
  %61 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %62 = "llvm.insertelement"(%60, %59, %61) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %63 = "llvm.insertelement"(%62, %58, %57) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %64 = "llvm.insertelement"(%63, %59, %56) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %65 = "llvm.insertelement"(%64, %58, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %66 = "llvm.insertelement"(%65, %59, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %67 = "llvm.insertelement"(%66, %58, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %68 = "llvm.insertelement"(%67, %59, %52) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %69 = "llvm.insertelement"(%68, %58, %51) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %70 = "llvm.insertelement"(%60, %58, %61) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %71 = "llvm.insertelement"(%70, %59, %57) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %72 = "llvm.insertelement"(%71, %58, %56) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %73 = "llvm.insertelement"(%72, %59, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %74 = "llvm.insertelement"(%73, %58, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %75 = "llvm.insertelement"(%74, %59, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %76 = "llvm.insertelement"(%75, %58, %52) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %77 = "llvm.insertelement"(%76, %59, %51) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %78 = "llvm.insertelement"(%60, %59, %61) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %79 = "llvm.insertelement"(%78, %58, %57) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %80 = "llvm.insertelement"(%79, %58, %56) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %81 = "llvm.insertelement"(%80, %58, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %82 = "llvm.insertelement"(%81, %58, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %83 = "llvm.insertelement"(%82, %58, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %84 = "llvm.insertelement"(%83, %58, %52) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %85 = "llvm.insertelement"(%84, %58, %51) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %86 = "llvm.insertelement"(%60, %58, %61) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %87 = "llvm.insertelement"(%86, %58, %57) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %88 = "llvm.insertelement"(%87, %58, %56) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %89 = "llvm.insertelement"(%88, %58, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %90 = "llvm.insertelement"(%89, %58, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %91 = "llvm.insertelement"(%90, %58, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %92 = "llvm.insertelement"(%91, %58, %52) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %93 = "llvm.insertelement"(%92, %59, %51) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %94 = "llvm.insertelement"(%60, %58, %61) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %95 = "llvm.insertelement"(%94, %58, %57) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %96 = "llvm.insertelement"(%95, %58, %56) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %97 = "llvm.insertelement"(%96, %58, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %98 = "llvm.insertelement"(%97, %58, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %99 = "llvm.insertelement"(%98, %58, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %100 = "llvm.insertelement"(%99, %59, %52) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %101 = "llvm.insertelement"(%100, %59, %51) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %102 = "llvm.insertelement"(%60, %58, %61) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %103 = "llvm.insertelement"(%102, %58, %57) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %104 = "llvm.insertelement"(%103, %58, %56) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %105 = "llvm.insertelement"(%104, %58, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %106 = "llvm.insertelement"(%105, %58, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %107 = "llvm.insertelement"(%106, %59, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %108 = "llvm.insertelement"(%107, %59, %52) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %109 = "llvm.insertelement"(%108, %59, %51) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %110 = "llvm.insertelement"(%60, %59, %61) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %111 = "llvm.insertelement"(%110, %59, %57) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %112 = "llvm.insertelement"(%111, %59, %56) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %113 = "llvm.insertelement"(%112, %58, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %114 = "llvm.insertelement"(%113, %58, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %115 = "llvm.insertelement"(%114, %58, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %116 = "llvm.insertelement"(%115, %58, %52) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %117 = "llvm.insertelement"(%116, %58, %51) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %118 = "llvm.insertelement"(%60, %58, %61) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %119 = "llvm.insertelement"(%118, %58, %57) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %120 = "llvm.insertelement"(%119, %58, %56) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %121 = "llvm.insertelement"(%120, %58, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %122 = "llvm.insertelement"(%121, %59, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %123 = "llvm.insertelement"(%122, %59, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %124 = "llvm.insertelement"(%123, %59, %52) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %125 = "llvm.insertelement"(%124, %59, %51) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %126 = "llvm.insertelement"(%60, %59, %61) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %127 = "llvm.insertelement"(%126, %59, %57) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %128 = "llvm.insertelement"(%127, %58, %56) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %129 = "llvm.insertelement"(%128, %58, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %130 = "llvm.insertelement"(%129, %58, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %131 = "llvm.insertelement"(%130, %58, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %132 = "llvm.insertelement"(%131, %58, %52) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %133 = "llvm.insertelement"(%132, %58, %51) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %134 = "llvm.insertelement"(%60, %58, %61) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %135 = "llvm.insertelement"(%134, %58, %57) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %136 = "llvm.insertelement"(%135, %58, %56) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %137 = "llvm.insertelement"(%136, %59, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %138 = "llvm.insertelement"(%137, %59, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %139 = "llvm.insertelement"(%138, %59, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %140 = "llvm.insertelement"(%139, %59, %52) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %141 = "llvm.insertelement"(%140, %59, %51) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %142 = "llvm.insertelement"(%60, %58, %61) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %143 = "llvm.insertelement"(%142, %58, %57) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %144 = "llvm.insertelement"(%143, %59, %56) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %145 = "llvm.insertelement"(%144, %59, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %146 = "llvm.insertelement"(%145, %59, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %147 = "llvm.insertelement"(%146, %59, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %148 = "llvm.insertelement"(%147, %59, %52) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %149 = "llvm.insertelement"(%148, %59, %51) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %150 = "llvm.insertelement"(%60, %32, %61) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %151 = "llvm.insertelement"(%150, %32, %57) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %152 = "llvm.insertelement"(%151, %59, %56) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %153 = "llvm.insertelement"(%152, %59, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %154 = "llvm.insertelement"(%153, %59, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %155 = "llvm.insertelement"(%154, %59, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %156 = "llvm.insertelement"(%155, %58, %52) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %157 = "llvm.insertelement"(%156, %58, %51) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %158 = "llvm.insertelement"(%60, %32, %61) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %159 = "llvm.insertelement"(%158, %59, %57) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %160 = "llvm.insertelement"(%159, %32, %56) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %161 = "llvm.insertelement"(%160, %59, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %162 = "llvm.insertelement"(%161, %59, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %163 = "llvm.insertelement"(%162, %59, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %164 = "llvm.insertelement"(%163, %58, %52) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %165 = "llvm.insertelement"(%164, %58, %51) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %166 = "llvm.insertelement"(%60, %32, %61) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %167 = "llvm.insertelement"(%166, %32, %57) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %168 = "llvm.insertelement"(%167, %59, %56) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %169 = "llvm.insertelement"(%168, %59, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %170 = "llvm.insertelement"(%169, %59, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %171 = "llvm.insertelement"(%170, %58, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %172 = "llvm.insertelement"(%171, %58, %52) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %173 = "llvm.insertelement"(%172, %58, %51) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %174 = "llvm.insertelement"(%60, %32, %61) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %175 = "llvm.insertelement"(%174, %59, %57) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %176 = "llvm.insertelement"(%175, %32, %56) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %177 = "llvm.insertelement"(%176, %59, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %178 = "llvm.insertelement"(%177, %59, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %179 = "llvm.insertelement"(%178, %58, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %180 = "llvm.insertelement"(%179, %58, %52) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %181 = "llvm.insertelement"(%180, %58, %51) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %182 = "llvm.insertelement"(%60, %59, %61) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %183 = "llvm.insertelement"(%182, %59, %57) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %184 = "llvm.insertelement"(%183, %59, %56) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %185 = "llvm.insertelement"(%184, %59, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %186 = "llvm.insertelement"(%185, %59, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %187 = "llvm.insertelement"(%186, %58, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %188 = "llvm.insertelement"(%187, %58, %52) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %189 = "llvm.insertelement"(%188, %58, %51) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %190 = "llvm.insertelement"(%60, %59, %61) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %191 = "llvm.insertelement"(%190, %9, %57) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %192 = "llvm.insertelement"(%191, %10, %56) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %193 = "llvm.insertelement"(%192, %58, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %194 = "llvm.insertelement"(%193, %11, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %195 = "llvm.insertelement"(%194, %58, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %196 = "llvm.insertelement"(%195, %58, %52) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %197 = "llvm.insertelement"(%196, %58, %51) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %198 = "llvm.insertelement"(%8, %58, %61) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %199 = "llvm.insertelement"(%198, %20, %57) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %200 = "llvm.insertelement"(%199, %58, %56) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %201 = "llvm.insertelement"(%200, %58, %55) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %202 = "llvm.insertelement"(%60, %22, %61) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %203 = "llvm.insertelement"(%202, %22, %57) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %204 = "llvm.insertelement"(%203, %22, %56) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %205 = "llvm.insertelement"(%204, %22, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %206 = "llvm.insertelement"(%205, %22, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %207 = "llvm.insertelement"(%206, %19, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %208 = "llvm.insertelement"(%207, %58, %52) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %209 = "llvm.insertelement"(%208, %58, %51) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %210 = "llvm.insertelement"(%60, %5, %61) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %211 = "llvm.insertelement"(%210, %5, %57) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %212 = "llvm.insertelement"(%211, %5, %56) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %213 = "llvm.insertelement"(%212, %5, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %214 = "llvm.insertelement"(%213, %5, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %215 = "llvm.insertelement"(%214, %5, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %216 = "llvm.insertelement"(%215, %58, %52) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %217 = "llvm.insertelement"(%216, %58, %51) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %218 = "llvm.insertelement"(%60, %32, %61) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %219 = "llvm.insertelement"(%218, %59, %57) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %220 = "llvm.insertelement"(%219, %59, %56) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %221 = "llvm.insertelement"(%220, %59, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %222 = "llvm.insertelement"(%221, %59, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %223 = "llvm.insertelement"(%222, %59, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %224 = "llvm.insertelement"(%223, %58, %52) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %225 = "llvm.insertelement"(%224, %58, %51) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %226 = "llvm.insertelement"(%60, %3, %61) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %227 = "llvm.insertelement"(%226, %4, %57) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %228 = "llvm.insertelement"(%227, %4, %56) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %229 = "llvm.insertelement"(%228, %4, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %230 = "llvm.insertelement"(%229, %4, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %231 = "llvm.insertelement"(%230, %4, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %232 = "llvm.insertelement"(%231, %58, %52) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %233 = "llvm.insertelement"(%232, %58, %51) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %234 = "llvm.insertelement"(%60, %59, %61) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %235 = "llvm.insertelement"(%234, %20, %57) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %236 = "llvm.insertelement"(%235, %1, %56) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %237 = "llvm.insertelement"(%236, %27, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %238 = "llvm.insertelement"(%237, %58, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %239 = "llvm.insertelement"(%238, %2, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %240 = "llvm.insertelement"(%239, %58, %52) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %241 = "llvm.insertelement"(%240, %58, %51) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %242 = "llvm.insertelement"(%60, %59, %61) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %243 = "llvm.insertelement"(%242, %20, %57) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %244 = "llvm.insertelement"(%243, %1, %56) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %245 = "llvm.insertelement"(%244, %58, %55) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %246 = "llvm.insertelement"(%245, %0, %54) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %247 = "llvm.insertelement"(%246, %2, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %248 = "llvm.insertelement"(%247, %58, %52) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %249 = "llvm.insertelement"(%248, %58, %51) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %250 = "llvm.alloca"(%57) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %251 = "llvm.alloca"(%57) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %252 = "llvm.load"(%arg1) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %253 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %254 = "llvm.load"(%253) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %255 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %256 = "llvm.load"(%255) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %257 = "llvm.shufflevector"(%252, %254) <{mask = array<i32: 0, 8, 2, 10, 4, 12, 6, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %258 = "llvm.shufflevector"(%252, %254) <{mask = array<i32: 1, 9, 3, 11, 5, 13, 7, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %259 = "llvm.shufflevector"(%256, %69) <{mask = array<i32: 0, 8, 2, 10, 4, 12, 6, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %260 = "llvm.shufflevector"(%256, %77) <{mask = array<i32: 1, 9, 3, 11, 5, 13, 7, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %261 = "llvm.shufflevector"(%257, %259) <{mask = array<i32: 0, 1, 8, 4, 5, 12, 9, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %262 = "llvm.shufflevector"(%258, %260) <{mask = array<i32: 0, 1, 8, 4, 5, 12, 9, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %263 = "llvm.shufflevector"(%257, %259) <{mask = array<i32: 2, 3, 10, 6, 7, 14, 9, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %264 = "llvm.shufflevector"(%258, %260) <{mask = array<i32: 2, 3, 10, 6, 7, 14, 9, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %265 = "llvm.add"(%262, %263) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %266 = "llvm.and"(%265, %50) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %267 = "llvm.lshr"(%265, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %268 = "llvm.shufflevector"(%267, %48) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %269 = "llvm.call_intrinsic"(%266, %47, %268) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.intr.lifetime.start"(%250) : (!llvm.ptr) -> ()
  %270 = "llvm.sub"(%263, %262) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %271 = "llvm.add"(%270, %46) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %272 = "llvm.and"(%271, %50) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %273 = "llvm.ashr"(%271, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %274 = "llvm.shufflevector"(%273, %85) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 8, 8>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %275 = "llvm.mul"(%274, %45) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %276 = "llvm.and"(%275, %44) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %277 = "llvm.add"(%272, %43) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %278 = "llvm.add"(%277, %274) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %279 = "llvm.add"(%278, %276) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %280 = "llvm.shufflevector"(%269, %48) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %281 = "llvm.shufflevector"(%269, %48) <{mask = array<i32: 1, 1, 1, 1, 1, 1, 1, 1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %282 = "llvm.shufflevector"(%269, %48) <{mask = array<i32: 2, 2, 2, 2, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %283 = "llvm.shufflevector"(%269, %48) <{mask = array<i32: 3, 3, 3, 3, 3, 3, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %284 = "llvm.shufflevector"(%269, %48) <{mask = array<i32: 4, 4, 4, 4, 4, 4, 4, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %285 = "llvm.shufflevector"(%269, %48) <{mask = array<i32: 5, 5, 5, 5, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %286 = "llvm.call_intrinsic"(%42, %280, %279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %287 = "llvm.shl"(%286, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %288 = "llvm.call_intrinsic"(%287, %281, %279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %289 = "llvm.call_intrinsic"(%42, %281, %279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %290 = "llvm.shl"(%289, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %291 = "llvm.call_intrinsic"(%290, %282, %279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %292 = "llvm.call_intrinsic"(%42, %282, %279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %293 = "llvm.shl"(%292, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %294 = "llvm.call_intrinsic"(%293, %283, %279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %295 = "llvm.call_intrinsic"(%42, %283, %279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %296 = "llvm.shl"(%295, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %297 = "llvm.call_intrinsic"(%296, %284, %279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %298 = "llvm.call_intrinsic"(%42, %284, %279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %299 = "llvm.shl"(%298, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %300 = "llvm.call_intrinsic"(%299, %285, %279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %301 = "llvm.call_intrinsic"(%42, %285, %279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %302 = "llvm.shl"(%301, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %303 = "llvm.shufflevector"(%93, %288) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %304 = "llvm.shufflevector"(%101, %291) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %305 = "llvm.shufflevector"(%109, %294) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %306 = "llvm.shufflevector"(%294, %117) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %307 = "llvm.shufflevector"(%125, %297) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %308 = "llvm.shufflevector"(%297, %133) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %309 = "llvm.shufflevector"(%141, %300) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %310 = "llvm.shufflevector"(%300, %85) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %311 = "llvm.shufflevector"(%149, %302) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %312 = "llvm.shufflevector"(%302, %48) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %313 = "llvm.call_intrinsic"(%303, %280, %279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %314 = "llvm.add"(%305, %304) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %315 = "llvm.add"(%314, %307) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %316 = "llvm.add"(%315, %309) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %317 = "llvm.add"(%316, %313) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %318 = "llvm.add"(%317, %311) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %319 = "llvm.add"(%308, %306) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %320 = "llvm.add"(%319, %310) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %321 = "llvm.add"(%320, %312) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %322 = "llvm.and"(%318, %40) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %323 = "llvm.shufflevector"(%318, %321) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %324 = "llvm.shl"(%323, %39) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %325 = "llvm.add"(%324, %322) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %326 = "llvm.mul"(%323, %38) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %327 = "llvm.add"(%325, %326) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %328 = "llvm.and"(%327, %50) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %329 = "llvm.lshr"(%327, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %330 = "llvm.shufflevector"(%329, %48) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %331 = "llvm.call_intrinsic"(%328, %47, %330) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %332 = "llvm.shufflevector"(%252, %48) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %333 = "llvm.shufflevector"(%254, %48) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %334 = "llvm.shufflevector"(%256, %48) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %335 = "llvm.shufflevector"(%252, %48) <{mask = array<i32: 4, 4, 4, 4, 4, 4, 4, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %336 = "llvm.shufflevector"(%254, %48) <{mask = array<i32: 4, 4, 4, 4, 4, 4, 4, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %337 = "llvm.shufflevector"(%256, %48) <{mask = array<i32: 4, 4, 4, 4, 4, 4, 4, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %338 = "llvm.call_intrinsic"(%42, %332, %262) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %339 = "llvm.shl"(%338, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %340 = "llvm.call_intrinsic"(%339, %333, %262) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %341 = "llvm.call_intrinsic"(%42, %333, %262) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %342 = "llvm.shl"(%341, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %343 = "llvm.call_intrinsic"(%342, %334, %262) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %344 = "llvm.call_intrinsic"(%42, %334, %262) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %345 = "llvm.shl"(%344, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %346 = "llvm.call_intrinsic"(%345, %335, %262) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %347 = "llvm.call_intrinsic"(%42, %335, %262) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %348 = "llvm.shl"(%347, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %349 = "llvm.call_intrinsic"(%348, %336, %262) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %350 = "llvm.call_intrinsic"(%42, %336, %262) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %351 = "llvm.shl"(%350, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %352 = "llvm.call_intrinsic"(%351, %337, %262) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %353 = "llvm.call_intrinsic"(%42, %337, %262) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %354 = "llvm.shl"(%353, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %355 = "llvm.shufflevector"(%93, %340) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %356 = "llvm.shufflevector"(%101, %343) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %357 = "llvm.shufflevector"(%109, %346) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %358 = "llvm.shufflevector"(%346, %117) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %359 = "llvm.shufflevector"(%125, %349) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %360 = "llvm.shufflevector"(%349, %133) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %361 = "llvm.shufflevector"(%141, %352) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %362 = "llvm.shufflevector"(%352, %85) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %363 = "llvm.shufflevector"(%149, %354) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %364 = "llvm.shufflevector"(%354, %48) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %365 = "llvm.call_intrinsic"(%355, %332, %262) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %366 = "llvm.add"(%357, %356) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %367 = "llvm.add"(%366, %359) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %368 = "llvm.add"(%367, %361) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %369 = "llvm.add"(%368, %365) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %370 = "llvm.add"(%369, %363) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %371 = "llvm.add"(%360, %358) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %372 = "llvm.add"(%371, %362) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %373 = "llvm.add"(%372, %364) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %374 = "llvm.and"(%370, %40) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %375 = "llvm.shufflevector"(%370, %373) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %376 = "llvm.shl"(%375, %39) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %377 = "llvm.add"(%376, %374) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %378 = "llvm.mul"(%375, %38) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %379 = "llvm.add"(%377, %378) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %380 = "llvm.and"(%379, %50) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %381 = "llvm.lshr"(%379, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %382 = "llvm.shufflevector"(%381, %48) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %383 = "llvm.call_intrinsic"(%380, %47, %382) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %384 = "llvm.shufflevector"(%383, %48) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %385 = "llvm.shufflevector"(%383, %48) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 3, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %386 = "llvm.shufflevector"(%383, %48) <{mask = array<i32: 4, 4, 1, 1, 1, 1, 1, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %387 = "llvm.shufflevector"(%383, %48) <{mask = array<i32: 4, 5, 1, 2, 3, 4, 5, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %388 = "llvm.shufflevector"(%383, %48) <{mask = array<i32: 3, 7, 5, 7, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %389 = "llvm.shufflevector"(%383, %48) <{mask = array<i32: 5, 7, 5, 7, 2, 3, 4, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %390 = "llvm.shl"(%384, %37) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %391 = "llvm.shl"(%386, %36) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %392 = "llvm.shl"(%388, %35) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %393 = "llvm.call_intrinsic"(%42, %391, %387) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %394 = "llvm.call_intrinsic"(%42, %392, %389) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %395 = "llvm.call_intrinsic"(%42, %390, %385) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %396 = "llvm.shl"(%395, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %397 = "llvm.call_intrinsic"(%42, %391, %387) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %398 = "llvm.shl"(%397, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %399 = "llvm.call_intrinsic"(%42, %392, %389) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %400 = "llvm.shl"(%399, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %401 = "llvm.and"(%393, %34) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %402 = "llvm.and"(%394, %33) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %403 = "llvm.add"(%402, %401) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %404 = "llvm.call_intrinsic"(%403, %390, %385) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %405 = "llvm.and"(%398, %34) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %406 = "llvm.and"(%400, %33) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %407 = "llvm.add"(%405, %396) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %408 = "llvm.add"(%407, %406) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %409 = "llvm.and"(%393, %157) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %410 = "llvm.and"(%394, %165) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %411 = "llvm.and"(%398, %173) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %412 = "llvm.and"(%400, %181) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %413 = "llvm.add"(%412, %411) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %414 = "llvm.shufflevector"(%93, %408) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %415 = "llvm.add"(%414, %404) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %416 = "llvm.shufflevector"(%93, %413) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %417 = "llvm.shufflevector"(%408, %189) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %418 = "llvm.add"(%410, %409) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %419 = "llvm.add"(%418, %416) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %420 = "llvm.add"(%419, %417) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %421 = "llvm.and"(%415, %40) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %422 = "llvm.shufflevector"(%415, %420) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %423 = "llvm.shl"(%422, %39) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %424 = "llvm.add"(%423, %421) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %425 = "llvm.mul"(%422, %38) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %426 = "llvm.add"(%424, %425) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %427 = "llvm.and"(%426, %50) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %428 = "llvm.lshr"(%426, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %429 = "llvm.shufflevector"(%428, %48) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %430 = "llvm.call_intrinsic"(%427, %47, %429) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %431 = "llvm.shufflevector"(%331, %48) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %432 = "llvm.shufflevector"(%331, %48) <{mask = array<i32: 1, 1, 1, 1, 1, 1, 1, 1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %433 = "llvm.shufflevector"(%331, %48) <{mask = array<i32: 2, 2, 2, 2, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %434 = "llvm.shufflevector"(%331, %48) <{mask = array<i32: 3, 3, 3, 3, 3, 3, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %435 = "llvm.shufflevector"(%331, %48) <{mask = array<i32: 4, 4, 4, 4, 4, 4, 4, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %436 = "llvm.shufflevector"(%331, %48) <{mask = array<i32: 5, 5, 5, 5, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %437 = "llvm.call_intrinsic"(%42, %431, %430) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %438 = "llvm.shl"(%437, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %439 = "llvm.call_intrinsic"(%438, %432, %430) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %440 = "llvm.call_intrinsic"(%42, %432, %430) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %441 = "llvm.shl"(%440, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %442 = "llvm.call_intrinsic"(%441, %433, %430) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %443 = "llvm.call_intrinsic"(%42, %433, %430) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %444 = "llvm.shl"(%443, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %445 = "llvm.call_intrinsic"(%444, %434, %430) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %446 = "llvm.call_intrinsic"(%42, %434, %430) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %447 = "llvm.shl"(%446, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %448 = "llvm.call_intrinsic"(%447, %435, %430) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %449 = "llvm.call_intrinsic"(%42, %435, %430) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %450 = "llvm.shl"(%449, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %451 = "llvm.call_intrinsic"(%450, %436, %430) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %452 = "llvm.call_intrinsic"(%42, %436, %430) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %453 = "llvm.shl"(%452, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %454 = "llvm.shufflevector"(%93, %439) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %455 = "llvm.shufflevector"(%101, %442) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %456 = "llvm.shufflevector"(%109, %445) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %457 = "llvm.shufflevector"(%445, %117) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %458 = "llvm.shufflevector"(%125, %448) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %459 = "llvm.shufflevector"(%448, %133) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %460 = "llvm.shufflevector"(%141, %451) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %461 = "llvm.shufflevector"(%451, %85) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %462 = "llvm.shufflevector"(%149, %453) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %463 = "llvm.shufflevector"(%453, %48) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %464 = "llvm.call_intrinsic"(%454, %431, %430) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %465 = "llvm.add"(%456, %455) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %466 = "llvm.add"(%465, %458) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %467 = "llvm.add"(%466, %460) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %468 = "llvm.add"(%467, %464) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %469 = "llvm.add"(%468, %462) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %470 = "llvm.add"(%459, %457) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %471 = "llvm.add"(%470, %461) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %472 = "llvm.add"(%471, %463) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %473 = "llvm.and"(%469, %40) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %474 = "llvm.shufflevector"(%469, %472) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %475 = "llvm.shl"(%474, %39) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %476 = "llvm.add"(%475, %473) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %477 = "llvm.mul"(%474, %38) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %478 = "llvm.add"(%476, %477) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %479 = "llvm.and"(%478, %50) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %480 = "llvm.lshr"(%478, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %481 = "llvm.shufflevector"(%480, %48) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %482 = "llvm.call_intrinsic"(%479, %47, %481) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%482, %250) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%251) : (!llvm.ptr) -> ()
  %483 = "llvm.call"(%251, %31, %250) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_f25519_sqrt_ratio, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> i32
  %484 = "llvm.load"(%251) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<6xi64>
  %485 = "llvm.shufflevector"(%484, %30) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<6xi64>, vector<6xi64>) -> vector<8xi64>
  %486 = "llvm.shufflevector"(%484, %30) <{mask = array<i32: 1, 1, 1, 1, 1, 1, 1, 1>}> : (vector<6xi64>, vector<6xi64>) -> vector<8xi64>
  %487 = "llvm.shufflevector"(%484, %30) <{mask = array<i32: 2, 2, 2, 2, 2, 2, 2, 2>}> : (vector<6xi64>, vector<6xi64>) -> vector<8xi64>
  %488 = "llvm.shufflevector"(%484, %30) <{mask = array<i32: 3, 3, 3, 3, 3, 3, 3, 3>}> : (vector<6xi64>, vector<6xi64>) -> vector<8xi64>
  %489 = "llvm.shufflevector"(%484, %30) <{mask = array<i32: 4, 4, 4, 4, 4, 4, 4, 4>}> : (vector<6xi64>, vector<6xi64>) -> vector<8xi64>
  %490 = "llvm.shufflevector"(%484, %30) <{mask = array<i32: 5, 5, 5, 5, 5, 5, 5, 5>}> : (vector<6xi64>, vector<6xi64>) -> vector<8xi64>
  %491 = "llvm.call_intrinsic"(%42, %485, %331) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %492 = "llvm.shl"(%491, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %493 = "llvm.call_intrinsic"(%492, %486, %331) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %494 = "llvm.call_intrinsic"(%42, %486, %331) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %495 = "llvm.shl"(%494, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %496 = "llvm.call_intrinsic"(%495, %487, %331) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %497 = "llvm.call_intrinsic"(%42, %487, %331) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %498 = "llvm.shl"(%497, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %499 = "llvm.call_intrinsic"(%498, %488, %331) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %500 = "llvm.call_intrinsic"(%42, %488, %331) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %501 = "llvm.shl"(%500, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %502 = "llvm.call_intrinsic"(%501, %489, %331) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %503 = "llvm.call_intrinsic"(%42, %489, %331) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %504 = "llvm.shl"(%503, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %505 = "llvm.call_intrinsic"(%504, %490, %331) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %506 = "llvm.call_intrinsic"(%42, %490, %331) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %507 = "llvm.shl"(%506, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %508 = "llvm.shufflevector"(%93, %493) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %509 = "llvm.shufflevector"(%101, %496) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %510 = "llvm.shufflevector"(%109, %499) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %511 = "llvm.shufflevector"(%499, %117) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %512 = "llvm.shufflevector"(%125, %502) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %513 = "llvm.shufflevector"(%502, %133) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %514 = "llvm.shufflevector"(%141, %505) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %515 = "llvm.shufflevector"(%505, %85) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %516 = "llvm.shufflevector"(%149, %507) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %517 = "llvm.shufflevector"(%507, %48) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %518 = "llvm.call_intrinsic"(%508, %485, %331) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %519 = "llvm.add"(%510, %509) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %520 = "llvm.add"(%519, %512) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %521 = "llvm.add"(%520, %514) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %522 = "llvm.add"(%521, %518) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %523 = "llvm.add"(%522, %516) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %524 = "llvm.add"(%513, %511) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %525 = "llvm.add"(%524, %515) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %526 = "llvm.add"(%525, %517) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %527 = "llvm.and"(%523, %40) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %528 = "llvm.shufflevector"(%523, %526) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %529 = "llvm.shl"(%528, %39) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %530 = "llvm.add"(%529, %527) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %531 = "llvm.mul"(%528, %38) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %532 = "llvm.add"(%530, %531) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %533 = "llvm.and"(%532, %50) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %534 = "llvm.lshr"(%532, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %535 = "llvm.shufflevector"(%534, %48) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %536 = "llvm.call_intrinsic"(%533, %47, %535) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %537 = "llvm.call_intrinsic"(%42, %485, %383) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %538 = "llvm.shl"(%537, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %539 = "llvm.call_intrinsic"(%538, %486, %383) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %540 = "llvm.call_intrinsic"(%42, %486, %383) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %541 = "llvm.shl"(%540, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %542 = "llvm.call_intrinsic"(%541, %487, %383) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %543 = "llvm.call_intrinsic"(%42, %487, %383) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %544 = "llvm.shl"(%543, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %545 = "llvm.call_intrinsic"(%544, %488, %383) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %546 = "llvm.call_intrinsic"(%42, %488, %383) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %547 = "llvm.shl"(%546, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %548 = "llvm.call_intrinsic"(%547, %489, %383) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %549 = "llvm.call_intrinsic"(%42, %489, %383) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %550 = "llvm.shl"(%549, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %551 = "llvm.call_intrinsic"(%550, %490, %383) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %552 = "llvm.call_intrinsic"(%42, %490, %383) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %553 = "llvm.shl"(%552, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %554 = "llvm.shufflevector"(%93, %539) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %555 = "llvm.shufflevector"(%101, %542) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %556 = "llvm.shufflevector"(%109, %545) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %557 = "llvm.shufflevector"(%545, %117) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %558 = "llvm.shufflevector"(%125, %548) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %559 = "llvm.shufflevector"(%548, %133) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %560 = "llvm.shufflevector"(%141, %551) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %561 = "llvm.shufflevector"(%551, %85) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %562 = "llvm.shufflevector"(%149, %553) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %563 = "llvm.shufflevector"(%553, %48) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %564 = "llvm.call_intrinsic"(%554, %485, %383) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %565 = "llvm.add"(%556, %555) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %566 = "llvm.add"(%565, %558) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %567 = "llvm.add"(%566, %560) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %568 = "llvm.add"(%567, %564) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %569 = "llvm.add"(%568, %562) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %570 = "llvm.add"(%559, %557) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %571 = "llvm.add"(%570, %561) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %572 = "llvm.add"(%571, %563) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %573 = "llvm.and"(%569, %40) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %574 = "llvm.shufflevector"(%569, %572) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %575 = "llvm.shl"(%574, %39) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %576 = "llvm.add"(%575, %573) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %577 = "llvm.mul"(%574, %38) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %578 = "llvm.add"(%576, %577) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %579 = "llvm.and"(%578, %50) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %580 = "llvm.lshr"(%578, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %581 = "llvm.shufflevector"(%580, %48) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %582 = "llvm.call_intrinsic"(%579, %47, %581) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %583 = "llvm.shufflevector"(%536, %48) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %584 = "llvm.shufflevector"(%536, %48) <{mask = array<i32: 1, 1, 1, 1, 1, 1, 1, 1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %585 = "llvm.shufflevector"(%536, %48) <{mask = array<i32: 2, 2, 2, 2, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %586 = "llvm.shufflevector"(%536, %48) <{mask = array<i32: 3, 3, 3, 3, 3, 3, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %587 = "llvm.shufflevector"(%536, %48) <{mask = array<i32: 4, 4, 4, 4, 4, 4, 4, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %588 = "llvm.shufflevector"(%536, %48) <{mask = array<i32: 5, 5, 5, 5, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %589 = "llvm.call_intrinsic"(%42, %583, %582) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %590 = "llvm.shl"(%589, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %591 = "llvm.call_intrinsic"(%590, %584, %582) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %592 = "llvm.call_intrinsic"(%42, %584, %582) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %593 = "llvm.shl"(%592, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %594 = "llvm.call_intrinsic"(%593, %585, %582) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %595 = "llvm.call_intrinsic"(%42, %585, %582) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %596 = "llvm.shl"(%595, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %597 = "llvm.call_intrinsic"(%596, %586, %582) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %598 = "llvm.call_intrinsic"(%42, %586, %582) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %599 = "llvm.shl"(%598, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %600 = "llvm.call_intrinsic"(%599, %587, %582) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %601 = "llvm.call_intrinsic"(%42, %587, %582) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %602 = "llvm.shl"(%601, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %603 = "llvm.call_intrinsic"(%602, %588, %582) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %604 = "llvm.call_intrinsic"(%42, %588, %582) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %605 = "llvm.shl"(%604, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %606 = "llvm.shufflevector"(%93, %591) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %607 = "llvm.shufflevector"(%101, %594) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %608 = "llvm.shufflevector"(%109, %597) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %609 = "llvm.shufflevector"(%597, %117) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %610 = "llvm.shufflevector"(%125, %600) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %611 = "llvm.shufflevector"(%600, %133) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %612 = "llvm.shufflevector"(%141, %603) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %613 = "llvm.shufflevector"(%603, %85) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %614 = "llvm.shufflevector"(%149, %605) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %615 = "llvm.shufflevector"(%605, %48) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %616 = "llvm.call_intrinsic"(%606, %583, %582) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %617 = "llvm.add"(%608, %607) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %618 = "llvm.add"(%617, %610) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %619 = "llvm.add"(%618, %612) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %620 = "llvm.add"(%619, %616) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %621 = "llvm.add"(%620, %614) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %622 = "llvm.add"(%611, %609) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %623 = "llvm.add"(%622, %613) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %624 = "llvm.add"(%623, %615) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %625 = "llvm.and"(%621, %40) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %626 = "llvm.shufflevector"(%621, %624) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %627 = "llvm.shl"(%626, %39) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %628 = "llvm.add"(%627, %625) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %629 = "llvm.mul"(%626, %38) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %630 = "llvm.add"(%628, %629) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %631 = "llvm.and"(%630, %50) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %632 = "llvm.lshr"(%630, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %633 = "llvm.shufflevector"(%632, %48) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %634 = "llvm.call_intrinsic"(%631, %47, %633) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %635 = "llvm.shufflevector"(%634, %48) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %636 = "llvm.shufflevector"(%634, %48) <{mask = array<i32: 1, 1, 1, 1, 1, 1, 1, 1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %637 = "llvm.shufflevector"(%634, %48) <{mask = array<i32: 2, 2, 2, 2, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %638 = "llvm.shufflevector"(%634, %48) <{mask = array<i32: 3, 3, 3, 3, 3, 3, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %639 = "llvm.shufflevector"(%634, %48) <{mask = array<i32: 4, 4, 4, 4, 4, 4, 4, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %640 = "llvm.shufflevector"(%634, %48) <{mask = array<i32: 5, 5, 5, 5, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %641 = "llvm.call_intrinsic"(%42, %635, %264) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %642 = "llvm.shl"(%641, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %643 = "llvm.call_intrinsic"(%642, %636, %264) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %644 = "llvm.call_intrinsic"(%42, %636, %264) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %645 = "llvm.shl"(%644, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %646 = "llvm.call_intrinsic"(%645, %637, %264) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %647 = "llvm.call_intrinsic"(%42, %637, %264) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %648 = "llvm.shl"(%647, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %649 = "llvm.call_intrinsic"(%648, %638, %264) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %650 = "llvm.call_intrinsic"(%42, %638, %264) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %651 = "llvm.shl"(%650, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %652 = "llvm.call_intrinsic"(%651, %639, %264) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %653 = "llvm.call_intrinsic"(%42, %639, %264) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %654 = "llvm.shl"(%653, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %655 = "llvm.call_intrinsic"(%654, %640, %264) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %656 = "llvm.call_intrinsic"(%42, %640, %264) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %657 = "llvm.shl"(%656, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %658 = "llvm.shufflevector"(%93, %643) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %659 = "llvm.shufflevector"(%101, %646) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %660 = "llvm.shufflevector"(%109, %649) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %661 = "llvm.shufflevector"(%649, %117) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %662 = "llvm.shufflevector"(%125, %652) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %663 = "llvm.shufflevector"(%652, %133) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %664 = "llvm.shufflevector"(%141, %655) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %665 = "llvm.shufflevector"(%655, %85) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %666 = "llvm.shufflevector"(%149, %657) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %667 = "llvm.shufflevector"(%657, %48) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %668 = "llvm.call_intrinsic"(%658, %635, %264) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %669 = "llvm.add"(%660, %659) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %670 = "llvm.add"(%669, %662) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %671 = "llvm.add"(%670, %664) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %672 = "llvm.add"(%671, %668) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %673 = "llvm.add"(%672, %666) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %674 = "llvm.add"(%663, %661) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %675 = "llvm.add"(%674, %665) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %676 = "llvm.add"(%675, %667) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %677 = "llvm.and"(%673, %40) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %678 = "llvm.shufflevector"(%673, %676) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %679 = "llvm.shl"(%678, %39) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %680 = "llvm.add"(%679, %677) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %681 = "llvm.mul"(%678, %38) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %682 = "llvm.add"(%680, %681) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %683 = "llvm.and"(%682, %50) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %684 = "llvm.lshr"(%682, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %685 = "llvm.shufflevector"(%684, %48) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %686 = "llvm.call_intrinsic"(%683, %47, %685) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %687 = "llvm.call_intrinsic"(%42, %332, %29) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %688 = "llvm.shl"(%687, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %689 = "llvm.call_intrinsic"(%688, %333, %29) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %690 = "llvm.call_intrinsic"(%42, %333, %29) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %691 = "llvm.shl"(%690, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %692 = "llvm.call_intrinsic"(%691, %334, %29) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %693 = "llvm.call_intrinsic"(%42, %334, %29) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %694 = "llvm.shl"(%693, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %695 = "llvm.call_intrinsic"(%694, %335, %29) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %696 = "llvm.call_intrinsic"(%42, %335, %29) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %697 = "llvm.shl"(%696, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %698 = "llvm.call_intrinsic"(%697, %336, %29) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %699 = "llvm.call_intrinsic"(%42, %336, %29) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %700 = "llvm.shl"(%699, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %701 = "llvm.call_intrinsic"(%700, %337, %29) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %702 = "llvm.call_intrinsic"(%42, %337, %29) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %703 = "llvm.shl"(%702, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %704 = "llvm.shufflevector"(%93, %689) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %705 = "llvm.shufflevector"(%101, %692) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %706 = "llvm.shufflevector"(%109, %695) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %707 = "llvm.shufflevector"(%695, %117) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %708 = "llvm.shufflevector"(%125, %698) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %709 = "llvm.shufflevector"(%698, %133) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %710 = "llvm.shufflevector"(%141, %701) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %711 = "llvm.shufflevector"(%701, %85) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %712 = "llvm.shufflevector"(%149, %703) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %713 = "llvm.shufflevector"(%703, %48) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %714 = "llvm.call_intrinsic"(%704, %332, %29) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %715 = "llvm.add"(%706, %705) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %716 = "llvm.add"(%715, %708) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %717 = "llvm.add"(%716, %710) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %718 = "llvm.add"(%717, %714) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %719 = "llvm.add"(%718, %712) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %720 = "llvm.add"(%709, %707) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %721 = "llvm.add"(%720, %711) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %722 = "llvm.add"(%721, %713) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %723 = "llvm.and"(%719, %40) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %724 = "llvm.shufflevector"(%719, %722) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %725 = "llvm.shl"(%724, %39) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %726 = "llvm.add"(%725, %723) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %727 = "llvm.mul"(%724, %38) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %728 = "llvm.add"(%726, %727) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %729 = "llvm.and"(%728, %50) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %730 = "llvm.lshr"(%728, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %731 = "llvm.shufflevector"(%730, %48) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %732 = "llvm.call_intrinsic"(%729, %47, %731) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %733 = "llvm.shufflevector"(%252, %48) <{mask = array<i32: 1, 1, 1, 1, 1, 1, 1, 1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %734 = "llvm.shufflevector"(%254, %48) <{mask = array<i32: 1, 1, 1, 1, 1, 1, 1, 1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %735 = "llvm.shufflevector"(%256, %48) <{mask = array<i32: 1, 1, 1, 1, 1, 1, 1, 1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %736 = "llvm.shufflevector"(%252, %48) <{mask = array<i32: 5, 5, 5, 5, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %737 = "llvm.shufflevector"(%254, %48) <{mask = array<i32: 5, 5, 5, 5, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %738 = "llvm.shufflevector"(%256, %48) <{mask = array<i32: 5, 5, 5, 5, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %739 = "llvm.call_intrinsic"(%42, %733, %29) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %740 = "llvm.shl"(%739, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %741 = "llvm.call_intrinsic"(%740, %734, %29) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %742 = "llvm.call_intrinsic"(%42, %734, %29) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %743 = "llvm.shl"(%742, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %744 = "llvm.call_intrinsic"(%743, %735, %29) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %745 = "llvm.call_intrinsic"(%42, %735, %29) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %746 = "llvm.shl"(%745, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %747 = "llvm.call_intrinsic"(%746, %736, %29) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %748 = "llvm.call_intrinsic"(%42, %736, %29) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %749 = "llvm.shl"(%748, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %750 = "llvm.call_intrinsic"(%749, %737, %29) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %751 = "llvm.call_intrinsic"(%42, %737, %29) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %752 = "llvm.shl"(%751, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %753 = "llvm.call_intrinsic"(%752, %738, %29) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %754 = "llvm.call_intrinsic"(%42, %738, %29) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %755 = "llvm.shl"(%754, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %756 = "llvm.shufflevector"(%93, %741) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %757 = "llvm.shufflevector"(%101, %744) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %758 = "llvm.shufflevector"(%109, %747) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %759 = "llvm.shufflevector"(%747, %117) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %760 = "llvm.shufflevector"(%125, %750) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %761 = "llvm.shufflevector"(%750, %133) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %762 = "llvm.shufflevector"(%141, %753) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %763 = "llvm.shufflevector"(%753, %85) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %764 = "llvm.shufflevector"(%149, %755) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %765 = "llvm.shufflevector"(%755, %48) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %766 = "llvm.call_intrinsic"(%756, %733, %29) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %767 = "llvm.add"(%758, %757) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %768 = "llvm.add"(%767, %760) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %769 = "llvm.add"(%768, %762) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %770 = "llvm.add"(%769, %766) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %771 = "llvm.add"(%770, %764) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %772 = "llvm.add"(%761, %759) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %773 = "llvm.add"(%772, %763) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %774 = "llvm.add"(%773, %765) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %775 = "llvm.and"(%771, %40) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %776 = "llvm.shufflevector"(%771, %774) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %777 = "llvm.shl"(%776, %39) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %778 = "llvm.add"(%777, %775) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %779 = "llvm.mul"(%776, %38) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %780 = "llvm.add"(%778, %779) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %781 = "llvm.and"(%780, %50) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %782 = "llvm.lshr"(%780, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %783 = "llvm.shufflevector"(%782, %48) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %784 = "llvm.call_intrinsic"(%781, %47, %783) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %785 = "llvm.call_intrinsic"(%42, %583, %28) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %786 = "llvm.shl"(%785, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %787 = "llvm.call_intrinsic"(%786, %584, %28) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %788 = "llvm.call_intrinsic"(%42, %584, %28) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %789 = "llvm.shl"(%788, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %790 = "llvm.call_intrinsic"(%789, %585, %28) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %791 = "llvm.call_intrinsic"(%42, %585, %28) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %792 = "llvm.shl"(%791, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %793 = "llvm.call_intrinsic"(%792, %586, %28) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %794 = "llvm.call_intrinsic"(%42, %586, %28) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %795 = "llvm.shl"(%794, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %796 = "llvm.call_intrinsic"(%795, %587, %28) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %797 = "llvm.call_intrinsic"(%42, %587, %28) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %798 = "llvm.shl"(%797, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %799 = "llvm.call_intrinsic"(%798, %588, %28) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %800 = "llvm.call_intrinsic"(%42, %588, %28) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %801 = "llvm.shl"(%800, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %802 = "llvm.shufflevector"(%93, %787) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %803 = "llvm.shufflevector"(%101, %790) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %804 = "llvm.shufflevector"(%109, %793) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %805 = "llvm.shufflevector"(%793, %117) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %806 = "llvm.shufflevector"(%125, %796) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %807 = "llvm.shufflevector"(%796, %133) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %808 = "llvm.shufflevector"(%141, %799) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %809 = "llvm.shufflevector"(%799, %85) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %810 = "llvm.shufflevector"(%149, %801) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %811 = "llvm.shufflevector"(%801, %48) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %812 = "llvm.call_intrinsic"(%802, %583, %28) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %813 = "llvm.add"(%804, %803) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %814 = "llvm.add"(%813, %806) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %815 = "llvm.add"(%814, %808) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %816 = "llvm.add"(%815, %812) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %817 = "llvm.add"(%816, %810) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %818 = "llvm.add"(%807, %805) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %819 = "llvm.add"(%818, %809) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %820 = "llvm.add"(%819, %811) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %821 = "llvm.and"(%817, %40) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %822 = "llvm.shufflevector"(%817, %820) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %823 = "llvm.shl"(%822, %39) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %824 = "llvm.add"(%823, %821) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %825 = "llvm.mul"(%822, %38) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %826 = "llvm.add"(%824, %825) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %827 = "llvm.and"(%826, %50) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %828 = "llvm.lshr"(%826, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %829 = "llvm.shufflevector"(%828, %48) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %830 = "llvm.call_intrinsic"(%827, %47, %829) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %831 = "llvm.shufflevector"(%252, %48) <{mask = array<i32: 3, 3, 3, 3, 3, 3, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %832 = "llvm.shufflevector"(%254, %48) <{mask = array<i32: 3, 3, 3, 3, 3, 3, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %833 = "llvm.shufflevector"(%256, %48) <{mask = array<i32: 3, 3, 3, 3, 3, 3, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %834 = "llvm.shufflevector"(%252, %48) <{mask = array<i32: 7, 7, 7, 7, 7, 7, 7, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %835 = "llvm.shufflevector"(%254, %48) <{mask = array<i32: 7, 7, 7, 7, 7, 7, 7, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %836 = "llvm.shufflevector"(%256, %48) <{mask = array<i32: 7, 7, 7, 7, 7, 7, 7, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %837 = "llvm.call_intrinsic"(%42, %831, %686) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %838 = "llvm.shl"(%837, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %839 = "llvm.call_intrinsic"(%838, %832, %686) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %840 = "llvm.call_intrinsic"(%42, %832, %686) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %841 = "llvm.shl"(%840, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %842 = "llvm.call_intrinsic"(%841, %833, %686) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %843 = "llvm.call_intrinsic"(%42, %833, %686) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %844 = "llvm.shl"(%843, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %845 = "llvm.call_intrinsic"(%844, %834, %686) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %846 = "llvm.call_intrinsic"(%42, %834, %686) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %847 = "llvm.shl"(%846, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %848 = "llvm.call_intrinsic"(%847, %835, %686) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %849 = "llvm.call_intrinsic"(%42, %835, %686) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %850 = "llvm.shl"(%849, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %851 = "llvm.call_intrinsic"(%850, %836, %686) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %852 = "llvm.call_intrinsic"(%42, %836, %686) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %853 = "llvm.shl"(%852, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %854 = "llvm.shufflevector"(%93, %839) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %855 = "llvm.shufflevector"(%101, %842) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %856 = "llvm.shufflevector"(%109, %845) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %857 = "llvm.shufflevector"(%845, %117) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %858 = "llvm.shufflevector"(%125, %848) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %859 = "llvm.shufflevector"(%848, %133) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %860 = "llvm.shufflevector"(%141, %851) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %861 = "llvm.shufflevector"(%851, %85) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %862 = "llvm.shufflevector"(%149, %853) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %863 = "llvm.shufflevector"(%853, %48) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %864 = "llvm.call_intrinsic"(%854, %831, %686) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %865 = "llvm.add"(%856, %855) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %866 = "llvm.add"(%865, %858) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %867 = "llvm.add"(%866, %860) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %868 = "llvm.add"(%867, %864) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %869 = "llvm.add"(%868, %862) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %870 = "llvm.add"(%859, %857) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %871 = "llvm.add"(%870, %861) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %872 = "llvm.add"(%871, %863) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %873 = "llvm.and"(%869, %40) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %874 = "llvm.shufflevector"(%869, %872) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %875 = "llvm.shl"(%874, %39) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %876 = "llvm.add"(%875, %873) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %877 = "llvm.mul"(%874, %38) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %878 = "llvm.add"(%876, %877) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %879 = "llvm.and"(%878, %50) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %880 = "llvm.lshr"(%878, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %881 = "llvm.shufflevector"(%880, %48) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %882 = "llvm.call_intrinsic"(%879, %47, %881) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %883 = "llvm.extractelement"(%882, %59) : (vector<8xi64>, i64) -> i64
  %884 = "llvm.extractelement"(%882, %27) : (vector<8xi64>, i64) -> i64
  %885 = "llvm.extractelement"(%882, %26) : (vector<8xi64>, i64) -> i64
  %886 = "llvm.extractelement"(%882, %25) : (vector<8xi64>, i64) -> i64
  %887 = "llvm.extractelement"(%882, %24) : (vector<8xi64>, i64) -> i64
  %888 = "llvm.extractelement"(%882, %23) : (vector<8xi64>, i64) -> i64
  %889 = "llvm.and"(%883, %22) : (i64, i64) -> i64
  %890 = "llvm.ashr"(%888, %21) : (i64, i64) -> i64
  %891 = "llvm.and"(%884, %22) : (i64, i64) -> i64
  %892 = "llvm.ashr"(%883, %20) : (i64, i64) -> i64
  %893 = "llvm.add"(%891, %892) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %894 = "llvm.and"(%885, %22) : (i64, i64) -> i64
  %895 = "llvm.ashr"(%884, %20) : (i64, i64) -> i64
  %896 = "llvm.add"(%894, %895) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %897 = "llvm.and"(%886, %22) : (i64, i64) -> i64
  %898 = "llvm.ashr"(%885, %20) : (i64, i64) -> i64
  %899 = "llvm.add"(%897, %898) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %900 = "llvm.and"(%887, %22) : (i64, i64) -> i64
  %901 = "llvm.ashr"(%886, %20) : (i64, i64) -> i64
  %902 = "llvm.add"(%900, %901) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %903 = "llvm.and"(%888, %19) : (i64, i64) -> i64
  %904 = "llvm.ashr"(%887, %20) : (i64, i64) -> i64
  %905 = "llvm.add"(%904, %32) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %906 = "llvm.add"(%905, %903) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %907 = "llvm.ashr"(%906, %21) : (i64, i64) -> i64
  %908 = "llvm.and"(%906, %19) : (i64, i64) -> i64
  %909 = "llvm.add"(%907, %890) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %910 = "llvm.mul"(%909, %18) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %911 = "llvm.add"(%910, %889) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %912 = "llvm.ashr"(%911, %20) : (i64, i64) -> i64
  %913 = "llvm.and"(%911, %22) : (i64, i64) -> i64
  %914 = "llvm.add"(%893, %912) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %915 = "llvm.ashr"(%914, %20) : (i64, i64) -> i64
  %916 = "llvm.and"(%914, %22) : (i64, i64) -> i64
  %917 = "llvm.add"(%896, %915) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %918 = "llvm.ashr"(%917, %20) : (i64, i64) -> i64
  %919 = "llvm.and"(%917, %22) : (i64, i64) -> i64
  %920 = "llvm.add"(%899, %918) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %921 = "llvm.ashr"(%920, %20) : (i64, i64) -> i64
  %922 = "llvm.and"(%920, %22) : (i64, i64) -> i64
  %923 = "llvm.add"(%902, %921) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %924 = "llvm.ashr"(%923, %20) : (i64, i64) -> i64
  %925 = "llvm.and"(%923, %22) : (i64, i64) -> i64
  %926 = "llvm.add"(%913, %18) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %927 = "llvm.lshr"(%926, %20) : (i64, i64) -> i64
  %928 = "llvm.and"(%926, %22) : (i64, i64) -> i64
  %929 = "llvm.add"(%916, %927) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %930 = "llvm.lshr"(%929, %20) : (i64, i64) -> i64
  %931 = "llvm.and"(%929, %22) : (i64, i64) -> i64
  %932 = "llvm.add"(%919, %930) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %933 = "llvm.lshr"(%932, %20) : (i64, i64) -> i64
  %934 = "llvm.and"(%932, %22) : (i64, i64) -> i64
  %935 = "llvm.add"(%922, %933) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %936 = "llvm.lshr"(%935, %20) : (i64, i64) -> i64
  %937 = "llvm.and"(%935, %22) : (i64, i64) -> i64
  %938 = "llvm.add"(%925, %936) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %939 = "llvm.lshr"(%938, %20) : (i64, i64) -> i64
  %940 = "llvm.and"(%938, %22) : (i64, i64) -> i64
  %941 = "llvm.add"(%908, %27) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %942 = "llvm.add"(%941, %924) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %943 = "llvm.add"(%942, %939) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %944 = "llvm.and"(%943, %19) : (i64, i64) -> i64
  %945 = "llvm.icmp"(%943, %17) <{predicate = 6 : i64}> : (i64, i64) -> i1
  %946 = "llvm.select"(%945, %16, %59) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %947 = "llvm.add"(%946, %928) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %948 = "llvm.ashr"(%947, %20) : (i64, i64) -> i64
  %949 = "llvm.add"(%948, %931) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %950 = "llvm.ashr"(%949, %20) : (i64, i64) -> i64
  %951 = "llvm.add"(%950, %934) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %952 = "llvm.ashr"(%951, %20) : (i64, i64) -> i64
  %953 = "llvm.add"(%952, %937) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %954 = "llvm.ashr"(%953, %20) : (i64, i64) -> i64
  %955 = "llvm.insertelement"(%15, %947, %59) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %956 = "llvm.insertelement"(%955, %949, %27) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %957 = "llvm.insertelement"(%956, %951, %26) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %958 = "llvm.insertelement"(%957, %953, %25) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %959 = "llvm.and"(%958, %14) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %960 = "llvm.add"(%954, %940) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %961 = "llvm.ashr"(%960, %20) : (i64, i64) -> i64
  %962 = "llvm.add"(%961, %944) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %963 = "llvm.insertelement"(%13, %960, %59) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  %964 = "llvm.insertelement"(%963, %962, %27) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  %965 = "llvm.and"(%964, %12) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %966 = "llvm.shufflevector"(%959, %15) <{mask = array<i32: 0, 1, 2, 3, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %967 = "llvm.shufflevector"(%966, %101) <{mask = array<i32: 0, 1, 2, 3, -1, -1, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %968 = "llvm.shufflevector"(%965, %13) <{mask = array<i32: 0, 1, -1, -1, -1, -1, -1, -1>}> : (vector<2xi64>, vector<2xi64>) -> vector<8xi64>
  %969 = "llvm.shufflevector"(%967, %968) <{mask = array<i32: 0, 1, 2, 3, 8, 9, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %970 = "llvm.lshr"(%969, %197) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %971 = "llvm.shl"(%959, %201) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %972 = "llvm.shufflevector"(%971, %15) <{mask = array<i32: 1, -1, -1, -1, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %973 = "llvm.shl"(%959, %201) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %974 = "llvm.shufflevector"(%973, %15) <{mask = array<i32: 1, -1, -1, -1, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %975 = "llvm.or"(%972, %970) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %976 = "llvm.or"(%975, %974) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %977 = "llvm.bitcast"(%976) : (vector<8xi64>) -> vector<64xi8>
  %978 = "llvm.extractelement"(%977, %59) : (vector<64xi8>, i64) -> i8
  %979 = "llvm.and"(%978, %7) : (i8, i8) -> i8
  %980 = "llvm.add"(%979, %6) <{overflowFlags = 1 : i32}> : (i8, i8) -> i8
  %981 = "llvm.bitcast"(%980) : (i8) -> vector<8xi1>
  %982 = "llvm.select"(%981, %261, %784) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %983 = "llvm.select"(%981, %262, %732) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %984 = "llvm.select"(%981, %582, %830) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %985 = "llvm.shufflevector"(%982, %48) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %986 = "llvm.shufflevector"(%982, %48) <{mask = array<i32: 1, 1, 1, 1, 1, 1, 1, 1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %987 = "llvm.shufflevector"(%982, %48) <{mask = array<i32: 2, 2, 2, 2, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %988 = "llvm.shufflevector"(%982, %48) <{mask = array<i32: 3, 3, 3, 3, 3, 3, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %989 = "llvm.shufflevector"(%982, %48) <{mask = array<i32: 4, 4, 4, 4, 4, 4, 4, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %990 = "llvm.shufflevector"(%982, %48) <{mask = array<i32: 5, 5, 5, 5, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %991 = "llvm.call_intrinsic"(%42, %985, %686) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %992 = "llvm.shl"(%991, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %993 = "llvm.call_intrinsic"(%992, %986, %686) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %994 = "llvm.call_intrinsic"(%42, %986, %686) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %995 = "llvm.shl"(%994, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %996 = "llvm.call_intrinsic"(%995, %987, %686) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %997 = "llvm.call_intrinsic"(%42, %987, %686) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %998 = "llvm.shl"(%997, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %999 = "llvm.call_intrinsic"(%998, %988, %686) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1000 = "llvm.call_intrinsic"(%42, %988, %686) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1001 = "llvm.shl"(%1000, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1002 = "llvm.call_intrinsic"(%1001, %989, %686) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1003 = "llvm.call_intrinsic"(%42, %989, %686) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1004 = "llvm.shl"(%1003, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1005 = "llvm.call_intrinsic"(%1004, %990, %686) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1006 = "llvm.call_intrinsic"(%42, %990, %686) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1007 = "llvm.shl"(%1006, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1008 = "llvm.shufflevector"(%93, %993) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1009 = "llvm.shufflevector"(%101, %996) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1010 = "llvm.shufflevector"(%109, %999) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1011 = "llvm.shufflevector"(%999, %117) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1012 = "llvm.shufflevector"(%125, %1002) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1013 = "llvm.shufflevector"(%1002, %133) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1014 = "llvm.shufflevector"(%141, %1005) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1015 = "llvm.shufflevector"(%1005, %85) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1016 = "llvm.shufflevector"(%149, %1007) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1017 = "llvm.shufflevector"(%1007, %48) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1018 = "llvm.call_intrinsic"(%1008, %985, %686) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1019 = "llvm.add"(%1010, %1009) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1020 = "llvm.add"(%1019, %1012) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1021 = "llvm.add"(%1020, %1014) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1022 = "llvm.add"(%1021, %1018) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1023 = "llvm.add"(%1022, %1016) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1024 = "llvm.add"(%1013, %1011) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1025 = "llvm.add"(%1024, %1015) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1026 = "llvm.add"(%1025, %1017) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1027 = "llvm.and"(%1023, %40) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1028 = "llvm.shufflevector"(%1023, %1026) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1029 = "llvm.shl"(%1028, %39) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1030 = "llvm.add"(%1029, %1027) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1031 = "llvm.mul"(%1028, %38) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1032 = "llvm.add"(%1030, %1031) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1033 = "llvm.and"(%1032, %50) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1034 = "llvm.lshr"(%1032, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1035 = "llvm.shufflevector"(%1034, %48) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1036 = "llvm.call_intrinsic"(%1033, %47, %1035) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1037 = "llvm.extractelement"(%1036, %59) : (vector<8xi64>, i64) -> i64
  %1038 = "llvm.extractelement"(%1036, %27) : (vector<8xi64>, i64) -> i64
  %1039 = "llvm.extractelement"(%1036, %26) : (vector<8xi64>, i64) -> i64
  %1040 = "llvm.extractelement"(%1036, %25) : (vector<8xi64>, i64) -> i64
  %1041 = "llvm.extractelement"(%1036, %24) : (vector<8xi64>, i64) -> i64
  %1042 = "llvm.extractelement"(%1036, %23) : (vector<8xi64>, i64) -> i64
  %1043 = "llvm.and"(%1037, %22) : (i64, i64) -> i64
  %1044 = "llvm.ashr"(%1042, %21) : (i64, i64) -> i64
  %1045 = "llvm.and"(%1038, %22) : (i64, i64) -> i64
  %1046 = "llvm.ashr"(%1037, %20) : (i64, i64) -> i64
  %1047 = "llvm.add"(%1045, %1046) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1048 = "llvm.and"(%1039, %22) : (i64, i64) -> i64
  %1049 = "llvm.ashr"(%1038, %20) : (i64, i64) -> i64
  %1050 = "llvm.add"(%1048, %1049) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1051 = "llvm.and"(%1040, %22) : (i64, i64) -> i64
  %1052 = "llvm.ashr"(%1039, %20) : (i64, i64) -> i64
  %1053 = "llvm.add"(%1051, %1052) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1054 = "llvm.and"(%1041, %22) : (i64, i64) -> i64
  %1055 = "llvm.ashr"(%1040, %20) : (i64, i64) -> i64
  %1056 = "llvm.add"(%1054, %1055) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1057 = "llvm.and"(%1042, %19) : (i64, i64) -> i64
  %1058 = "llvm.ashr"(%1041, %20) : (i64, i64) -> i64
  %1059 = "llvm.add"(%1058, %32) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1060 = "llvm.add"(%1059, %1057) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1061 = "llvm.ashr"(%1060, %21) : (i64, i64) -> i64
  %1062 = "llvm.and"(%1060, %19) : (i64, i64) -> i64
  %1063 = "llvm.add"(%1061, %1044) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1064 = "llvm.mul"(%1063, %18) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1065 = "llvm.add"(%1064, %1043) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1066 = "llvm.ashr"(%1065, %20) : (i64, i64) -> i64
  %1067 = "llvm.and"(%1065, %22) : (i64, i64) -> i64
  %1068 = "llvm.add"(%1047, %1066) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1069 = "llvm.ashr"(%1068, %20) : (i64, i64) -> i64
  %1070 = "llvm.and"(%1068, %22) : (i64, i64) -> i64
  %1071 = "llvm.add"(%1050, %1069) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1072 = "llvm.ashr"(%1071, %20) : (i64, i64) -> i64
  %1073 = "llvm.and"(%1071, %22) : (i64, i64) -> i64
  %1074 = "llvm.add"(%1053, %1072) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1075 = "llvm.ashr"(%1074, %20) : (i64, i64) -> i64
  %1076 = "llvm.and"(%1074, %22) : (i64, i64) -> i64
  %1077 = "llvm.add"(%1056, %1075) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1078 = "llvm.ashr"(%1077, %20) : (i64, i64) -> i64
  %1079 = "llvm.and"(%1077, %22) : (i64, i64) -> i64
  %1080 = "llvm.add"(%1067, %18) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1081 = "llvm.lshr"(%1080, %20) : (i64, i64) -> i64
  %1082 = "llvm.and"(%1080, %22) : (i64, i64) -> i64
  %1083 = "llvm.add"(%1070, %1081) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1084 = "llvm.lshr"(%1083, %20) : (i64, i64) -> i64
  %1085 = "llvm.and"(%1083, %22) : (i64, i64) -> i64
  %1086 = "llvm.add"(%1073, %1084) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1087 = "llvm.lshr"(%1086, %20) : (i64, i64) -> i64
  %1088 = "llvm.and"(%1086, %22) : (i64, i64) -> i64
  %1089 = "llvm.add"(%1076, %1087) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1090 = "llvm.lshr"(%1089, %20) : (i64, i64) -> i64
  %1091 = "llvm.and"(%1089, %22) : (i64, i64) -> i64
  %1092 = "llvm.add"(%1079, %1090) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1093 = "llvm.lshr"(%1092, %20) : (i64, i64) -> i64
  %1094 = "llvm.and"(%1092, %22) : (i64, i64) -> i64
  %1095 = "llvm.add"(%1062, %27) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1096 = "llvm.add"(%1095, %1078) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1097 = "llvm.add"(%1096, %1093) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1098 = "llvm.and"(%1097, %19) : (i64, i64) -> i64
  %1099 = "llvm.icmp"(%1097, %17) <{predicate = 6 : i64}> : (i64, i64) -> i1
  %1100 = "llvm.select"(%1099, %16, %59) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %1101 = "llvm.add"(%1100, %1082) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1102 = "llvm.ashr"(%1101, %20) : (i64, i64) -> i64
  %1103 = "llvm.add"(%1102, %1085) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1104 = "llvm.ashr"(%1103, %20) : (i64, i64) -> i64
  %1105 = "llvm.add"(%1104, %1088) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1106 = "llvm.ashr"(%1105, %20) : (i64, i64) -> i64
  %1107 = "llvm.add"(%1106, %1091) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1108 = "llvm.ashr"(%1107, %20) : (i64, i64) -> i64
  %1109 = "llvm.insertelement"(%15, %1101, %59) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1110 = "llvm.insertelement"(%1109, %1103, %27) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1111 = "llvm.insertelement"(%1110, %1105, %26) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1112 = "llvm.insertelement"(%1111, %1107, %25) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1113 = "llvm.and"(%1112, %14) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1114 = "llvm.add"(%1108, %1094) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1115 = "llvm.ashr"(%1114, %20) : (i64, i64) -> i64
  %1116 = "llvm.add"(%1115, %1098) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1117 = "llvm.insertelement"(%13, %1114, %59) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  %1118 = "llvm.insertelement"(%1117, %1116, %27) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  %1119 = "llvm.and"(%1118, %12) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1120 = "llvm.shufflevector"(%1113, %15) <{mask = array<i32: 0, 1, 2, 3, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %1121 = "llvm.shufflevector"(%1120, %101) <{mask = array<i32: 0, 1, 2, 3, -1, -1, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1122 = "llvm.shufflevector"(%1119, %13) <{mask = array<i32: 0, 1, -1, -1, -1, -1, -1, -1>}> : (vector<2xi64>, vector<2xi64>) -> vector<8xi64>
  %1123 = "llvm.shufflevector"(%1121, %1122) <{mask = array<i32: 0, 1, 2, 3, 8, 9, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1124 = "llvm.lshr"(%1123, %197) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1125 = "llvm.shl"(%1113, %201) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1126 = "llvm.shufflevector"(%1125, %15) <{mask = array<i32: 1, -1, -1, -1, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %1127 = "llvm.shl"(%1113, %201) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1128 = "llvm.shufflevector"(%1127, %15) <{mask = array<i32: 1, -1, -1, -1, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %1129 = "llvm.or"(%1126, %1124) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1130 = "llvm.or"(%1129, %1128) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1131 = "llvm.bitcast"(%1130) : (vector<8xi64>) -> vector<64xi8>
  %1132 = "llvm.extractelement"(%1131, %59) : (vector<64xi8>, i64) -> i8
  %1133 = "llvm.and"(%1132, %7) : (i8, i8) -> i8
  %1134 = "llvm.sub"(%46, %983) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1135 = "llvm.and"(%1134, %50) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1136 = "llvm.ashr"(%1134, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1137 = "llvm.shufflevector"(%1136, %85) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 8, 8>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1138 = "llvm.mul"(%1137, %45) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1139 = "llvm.and"(%1138, %44) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1140 = "llvm.add"(%1135, %43) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1141 = "llvm.add"(%1140, %1137) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1142 = "llvm.add"(%1141, %1139) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1143 = "llvm.add"(%1133, %6) <{overflowFlags = 1 : i32}> : (i8, i8) -> i8
  %1144 = "llvm.bitcast"(%1143) : (i8) -> vector<8xi1>
  %1145 = "llvm.select"(%1144, %983, %1142) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1146 = "llvm.sub"(%263, %1145) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1147 = "llvm.add"(%1146, %46) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1148 = "llvm.and"(%1147, %50) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1149 = "llvm.ashr"(%1147, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1150 = "llvm.shufflevector"(%1149, %85) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 8, 8>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1151 = "llvm.mul"(%1150, %45) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1152 = "llvm.and"(%1151, %44) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1153 = "llvm.add"(%1148, %43) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1154 = "llvm.add"(%1153, %1150) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1155 = "llvm.add"(%1154, %1152) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1156 = "llvm.shufflevector"(%1155, %48) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1157 = "llvm.shufflevector"(%1155, %48) <{mask = array<i32: 1, 1, 1, 1, 1, 1, 1, 1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1158 = "llvm.shufflevector"(%1155, %48) <{mask = array<i32: 2, 2, 2, 2, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1159 = "llvm.shufflevector"(%1155, %48) <{mask = array<i32: 3, 3, 3, 3, 3, 3, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1160 = "llvm.shufflevector"(%1155, %48) <{mask = array<i32: 4, 4, 4, 4, 4, 4, 4, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1161 = "llvm.shufflevector"(%1155, %48) <{mask = array<i32: 5, 5, 5, 5, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1162 = "llvm.call_intrinsic"(%42, %1156, %984) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1163 = "llvm.shl"(%1162, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1164 = "llvm.call_intrinsic"(%1163, %1157, %984) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1165 = "llvm.call_intrinsic"(%42, %1157, %984) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1166 = "llvm.shl"(%1165, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1167 = "llvm.call_intrinsic"(%1166, %1158, %984) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1168 = "llvm.call_intrinsic"(%42, %1158, %984) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1169 = "llvm.shl"(%1168, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1170 = "llvm.call_intrinsic"(%1169, %1159, %984) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1171 = "llvm.call_intrinsic"(%42, %1159, %984) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1172 = "llvm.shl"(%1171, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1173 = "llvm.call_intrinsic"(%1172, %1160, %984) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1174 = "llvm.call_intrinsic"(%42, %1160, %984) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1175 = "llvm.shl"(%1174, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1176 = "llvm.call_intrinsic"(%1175, %1161, %984) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1177 = "llvm.call_intrinsic"(%42, %1161, %984) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1178 = "llvm.shl"(%1177, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1179 = "llvm.shufflevector"(%93, %1164) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1180 = "llvm.shufflevector"(%101, %1167) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1181 = "llvm.shufflevector"(%109, %1170) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1182 = "llvm.shufflevector"(%1170, %117) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1183 = "llvm.shufflevector"(%125, %1173) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1184 = "llvm.shufflevector"(%1173, %133) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1185 = "llvm.shufflevector"(%141, %1176) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1186 = "llvm.shufflevector"(%1176, %85) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1187 = "llvm.shufflevector"(%149, %1178) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1188 = "llvm.shufflevector"(%1178, %48) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1189 = "llvm.call_intrinsic"(%1179, %1156, %984) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1190 = "llvm.add"(%1181, %1180) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1191 = "llvm.add"(%1190, %1183) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1192 = "llvm.add"(%1191, %1185) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1193 = "llvm.add"(%1192, %1189) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1194 = "llvm.add"(%1193, %1187) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1195 = "llvm.add"(%1184, %1182) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1196 = "llvm.add"(%1195, %1186) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1197 = "llvm.add"(%1196, %1188) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1198 = "llvm.and"(%1194, %40) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1199 = "llvm.shufflevector"(%1194, %1197) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1200 = "llvm.shl"(%1199, %39) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1201 = "llvm.add"(%1200, %1198) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1202 = "llvm.mul"(%1199, %38) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1203 = "llvm.add"(%1201, %1202) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1204 = "llvm.and"(%1203, %50) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1205 = "llvm.lshr"(%1203, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1206 = "llvm.shufflevector"(%1205, %48) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1207 = "llvm.call_intrinsic"(%1204, %47, %1206) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1208 = "llvm.sub"(%46, %1207) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1209 = "llvm.and"(%1208, %209) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1210 = "llvm.ashr"(%1208, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1211 = "llvm.shufflevector"(%1210, %85) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 8, 8>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1212 = "llvm.mul"(%1211, %217) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1213 = "llvm.and"(%1212, %225) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1214 = "llvm.add"(%1209, %233) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1215 = "llvm.add"(%1214, %1211) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1216 = "llvm.add"(%1215, %1213) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1217 = "llvm.extractelement"(%1207, %59) : (vector<8xi64>, i64) -> i64
  %1218 = "llvm.extractelement"(%1207, %27) : (vector<8xi64>, i64) -> i64
  %1219 = "llvm.extractelement"(%1207, %26) : (vector<8xi64>, i64) -> i64
  %1220 = "llvm.extractelement"(%1207, %25) : (vector<8xi64>, i64) -> i64
  %1221 = "llvm.extractelement"(%1207, %24) : (vector<8xi64>, i64) -> i64
  %1222 = "llvm.extractelement"(%1207, %23) : (vector<8xi64>, i64) -> i64
  %1223 = "llvm.and"(%1217, %22) : (i64, i64) -> i64
  %1224 = "llvm.ashr"(%1222, %21) : (i64, i64) -> i64
  %1225 = "llvm.and"(%1218, %22) : (i64, i64) -> i64
  %1226 = "llvm.ashr"(%1217, %20) : (i64, i64) -> i64
  %1227 = "llvm.add"(%1225, %1226) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1228 = "llvm.and"(%1219, %22) : (i64, i64) -> i64
  %1229 = "llvm.ashr"(%1218, %20) : (i64, i64) -> i64
  %1230 = "llvm.add"(%1228, %1229) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1231 = "llvm.and"(%1220, %22) : (i64, i64) -> i64
  %1232 = "llvm.ashr"(%1219, %20) : (i64, i64) -> i64
  %1233 = "llvm.add"(%1231, %1232) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1234 = "llvm.and"(%1221, %22) : (i64, i64) -> i64
  %1235 = "llvm.ashr"(%1220, %20) : (i64, i64) -> i64
  %1236 = "llvm.add"(%1234, %1235) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1237 = "llvm.and"(%1222, %19) : (i64, i64) -> i64
  %1238 = "llvm.ashr"(%1221, %20) : (i64, i64) -> i64
  %1239 = "llvm.add"(%1238, %32) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1240 = "llvm.add"(%1239, %1237) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1241 = "llvm.ashr"(%1240, %21) : (i64, i64) -> i64
  %1242 = "llvm.and"(%1240, %19) : (i64, i64) -> i64
  %1243 = "llvm.add"(%1241, %1224) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1244 = "llvm.mul"(%1243, %18) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1245 = "llvm.add"(%1244, %1223) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1246 = "llvm.ashr"(%1245, %20) : (i64, i64) -> i64
  %1247 = "llvm.and"(%1245, %22) : (i64, i64) -> i64
  %1248 = "llvm.add"(%1227, %1246) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1249 = "llvm.ashr"(%1248, %20) : (i64, i64) -> i64
  %1250 = "llvm.and"(%1248, %22) : (i64, i64) -> i64
  %1251 = "llvm.add"(%1230, %1249) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1252 = "llvm.ashr"(%1251, %20) : (i64, i64) -> i64
  %1253 = "llvm.and"(%1251, %22) : (i64, i64) -> i64
  %1254 = "llvm.add"(%1233, %1252) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1255 = "llvm.ashr"(%1254, %20) : (i64, i64) -> i64
  %1256 = "llvm.and"(%1254, %22) : (i64, i64) -> i64
  %1257 = "llvm.add"(%1236, %1255) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1258 = "llvm.ashr"(%1257, %20) : (i64, i64) -> i64
  %1259 = "llvm.and"(%1257, %22) : (i64, i64) -> i64
  %1260 = "llvm.add"(%1247, %18) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1261 = "llvm.lshr"(%1260, %20) : (i64, i64) -> i64
  %1262 = "llvm.and"(%1260, %22) : (i64, i64) -> i64
  %1263 = "llvm.add"(%1250, %1261) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1264 = "llvm.lshr"(%1263, %20) : (i64, i64) -> i64
  %1265 = "llvm.and"(%1263, %22) : (i64, i64) -> i64
  %1266 = "llvm.add"(%1253, %1264) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1267 = "llvm.lshr"(%1266, %20) : (i64, i64) -> i64
  %1268 = "llvm.and"(%1266, %22) : (i64, i64) -> i64
  %1269 = "llvm.add"(%1256, %1267) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1270 = "llvm.lshr"(%1269, %20) : (i64, i64) -> i64
  %1271 = "llvm.and"(%1269, %22) : (i64, i64) -> i64
  %1272 = "llvm.add"(%1259, %1270) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1273 = "llvm.lshr"(%1272, %20) : (i64, i64) -> i64
  %1274 = "llvm.and"(%1272, %22) : (i64, i64) -> i64
  %1275 = "llvm.add"(%1242, %27) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1276 = "llvm.add"(%1275, %1258) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1277 = "llvm.add"(%1276, %1273) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1278 = "llvm.and"(%1277, %19) : (i64, i64) -> i64
  %1279 = "llvm.icmp"(%1277, %17) <{predicate = 6 : i64}> : (i64, i64) -> i1
  %1280 = "llvm.select"(%1279, %16, %59) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %1281 = "llvm.add"(%1280, %1262) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1282 = "llvm.ashr"(%1281, %20) : (i64, i64) -> i64
  %1283 = "llvm.add"(%1282, %1265) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1284 = "llvm.ashr"(%1283, %20) : (i64, i64) -> i64
  %1285 = "llvm.add"(%1284, %1268) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1286 = "llvm.ashr"(%1285, %20) : (i64, i64) -> i64
  %1287 = "llvm.add"(%1286, %1271) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1288 = "llvm.ashr"(%1287, %20) : (i64, i64) -> i64
  %1289 = "llvm.insertelement"(%15, %1281, %59) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1290 = "llvm.insertelement"(%1289, %1283, %27) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1291 = "llvm.insertelement"(%1290, %1285, %26) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1292 = "llvm.insertelement"(%1291, %1287, %25) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1293 = "llvm.and"(%1292, %14) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1294 = "llvm.add"(%1288, %1274) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1295 = "llvm.ashr"(%1294, %20) : (i64, i64) -> i64
  %1296 = "llvm.add"(%1295, %1278) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1297 = "llvm.insertelement"(%13, %1294, %59) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  %1298 = "llvm.insertelement"(%1297, %1296, %27) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  %1299 = "llvm.and"(%1298, %12) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1300 = "llvm.shufflevector"(%1293, %15) <{mask = array<i32: 0, 1, 2, 3, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %1301 = "llvm.shufflevector"(%1300, %101) <{mask = array<i32: 0, 1, 2, 3, -1, -1, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1302 = "llvm.shufflevector"(%1299, %13) <{mask = array<i32: 0, 1, -1, -1, -1, -1, -1, -1>}> : (vector<2xi64>, vector<2xi64>) -> vector<8xi64>
  %1303 = "llvm.shufflevector"(%1301, %1302) <{mask = array<i32: 0, 1, 2, 3, 8, 9, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1304 = "llvm.lshr"(%1303, %197) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1305 = "llvm.shl"(%1293, %201) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1306 = "llvm.shufflevector"(%1305, %15) <{mask = array<i32: 1, -1, -1, -1, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %1307 = "llvm.shl"(%1293, %201) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1308 = "llvm.shufflevector"(%1307, %15) <{mask = array<i32: 1, -1, -1, -1, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %1309 = "llvm.or"(%1306, %1304) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1310 = "llvm.or"(%1309, %1308) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1311 = "llvm.bitcast"(%1310) : (vector<8xi64>) -> vector<64xi8>
  %1312 = "llvm.extractelement"(%1311, %59) : (vector<64xi8>, i64) -> i8
  %1313 = "llvm.and"(%1312, %7) : (i8, i8) -> i8
  %1314 = "llvm.add"(%1313, %6) <{overflowFlags = 1 : i32}> : (i8, i8) -> i8
  %1315 = "llvm.bitcast"(%1314) : (i8) -> vector<8xi1>
  %1316 = "llvm.select"(%1315, %1207, %1216) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1317 = "llvm.extractelement"(%1316, %59) : (vector<8xi64>, i64) -> i64
  %1318 = "llvm.extractelement"(%1316, %27) : (vector<8xi64>, i64) -> i64
  %1319 = "llvm.extractelement"(%1316, %26) : (vector<8xi64>, i64) -> i64
  %1320 = "llvm.extractelement"(%1316, %25) : (vector<8xi64>, i64) -> i64
  %1321 = "llvm.extractelement"(%1316, %24) : (vector<8xi64>, i64) -> i64
  %1322 = "llvm.extractelement"(%1316, %23) : (vector<8xi64>, i64) -> i64
  %1323 = "llvm.and"(%1317, %22) : (i64, i64) -> i64
  %1324 = "llvm.ashr"(%1322, %21) : (i64, i64) -> i64
  %1325 = "llvm.and"(%1318, %22) : (i64, i64) -> i64
  %1326 = "llvm.ashr"(%1317, %20) : (i64, i64) -> i64
  %1327 = "llvm.add"(%1325, %1326) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1328 = "llvm.and"(%1319, %22) : (i64, i64) -> i64
  %1329 = "llvm.ashr"(%1318, %20) : (i64, i64) -> i64
  %1330 = "llvm.add"(%1328, %1329) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1331 = "llvm.and"(%1320, %22) : (i64, i64) -> i64
  %1332 = "llvm.ashr"(%1319, %20) : (i64, i64) -> i64
  %1333 = "llvm.add"(%1331, %1332) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1334 = "llvm.and"(%1321, %22) : (i64, i64) -> i64
  %1335 = "llvm.ashr"(%1320, %20) : (i64, i64) -> i64
  %1336 = "llvm.add"(%1334, %1335) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1337 = "llvm.and"(%1322, %19) : (i64, i64) -> i64
  %1338 = "llvm.ashr"(%1321, %20) : (i64, i64) -> i64
  %1339 = "llvm.add"(%1338, %32) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1340 = "llvm.add"(%1339, %1337) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1341 = "llvm.ashr"(%1340, %21) : (i64, i64) -> i64
  %1342 = "llvm.and"(%1340, %19) : (i64, i64) -> i64
  %1343 = "llvm.add"(%1341, %1324) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1344 = "llvm.mul"(%1343, %18) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1345 = "llvm.add"(%1344, %1323) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1346 = "llvm.ashr"(%1345, %20) : (i64, i64) -> i64
  %1347 = "llvm.and"(%1345, %22) : (i64, i64) -> i64
  %1348 = "llvm.add"(%1327, %1346) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1349 = "llvm.ashr"(%1348, %20) : (i64, i64) -> i64
  %1350 = "llvm.and"(%1348, %22) : (i64, i64) -> i64
  %1351 = "llvm.add"(%1330, %1349) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1352 = "llvm.ashr"(%1351, %20) : (i64, i64) -> i64
  %1353 = "llvm.and"(%1351, %22) : (i64, i64) -> i64
  %1354 = "llvm.add"(%1333, %1352) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1355 = "llvm.ashr"(%1354, %20) : (i64, i64) -> i64
  %1356 = "llvm.and"(%1354, %22) : (i64, i64) -> i64
  %1357 = "llvm.add"(%1336, %1355) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1358 = "llvm.ashr"(%1357, %20) : (i64, i64) -> i64
  %1359 = "llvm.and"(%1357, %22) : (i64, i64) -> i64
  %1360 = "llvm.add"(%1347, %18) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1361 = "llvm.lshr"(%1360, %20) : (i64, i64) -> i64
  %1362 = "llvm.and"(%1360, %22) : (i64, i64) -> i64
  %1363 = "llvm.add"(%1350, %1361) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1364 = "llvm.lshr"(%1363, %20) : (i64, i64) -> i64
  %1365 = "llvm.and"(%1363, %22) : (i64, i64) -> i64
  %1366 = "llvm.add"(%1353, %1364) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1367 = "llvm.lshr"(%1366, %20) : (i64, i64) -> i64
  %1368 = "llvm.and"(%1366, %22) : (i64, i64) -> i64
  %1369 = "llvm.add"(%1356, %1367) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1370 = "llvm.lshr"(%1369, %20) : (i64, i64) -> i64
  %1371 = "llvm.and"(%1369, %22) : (i64, i64) -> i64
  %1372 = "llvm.add"(%1359, %1370) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1373 = "llvm.lshr"(%1372, %20) : (i64, i64) -> i64
  %1374 = "llvm.and"(%1372, %22) : (i64, i64) -> i64
  %1375 = "llvm.add"(%1342, %27) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1376 = "llvm.add"(%1375, %1358) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1377 = "llvm.add"(%1376, %1373) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1378 = "llvm.and"(%1377, %19) : (i64, i64) -> i64
  %1379 = "llvm.icmp"(%1377, %17) <{predicate = 6 : i64}> : (i64, i64) -> i1
  %1380 = "llvm.select"(%1379, %16, %59) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %1381 = "llvm.add"(%1380, %1362) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1382 = "llvm.ashr"(%1381, %20) : (i64, i64) -> i64
  %1383 = "llvm.add"(%1382, %1365) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1384 = "llvm.ashr"(%1383, %20) : (i64, i64) -> i64
  %1385 = "llvm.add"(%1384, %1368) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1386 = "llvm.ashr"(%1385, %20) : (i64, i64) -> i64
  %1387 = "llvm.add"(%1386, %1371) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1388 = "llvm.ashr"(%1387, %20) : (i64, i64) -> i64
  %1389 = "llvm.insertelement"(%15, %1381, %59) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1390 = "llvm.insertelement"(%1389, %1383, %27) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1391 = "llvm.insertelement"(%1390, %1385, %26) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1392 = "llvm.insertelement"(%1391, %1387, %25) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1393 = "llvm.and"(%1392, %14) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1394 = "llvm.add"(%1388, %1374) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1395 = "llvm.ashr"(%1394, %20) : (i64, i64) -> i64
  %1396 = "llvm.add"(%1395, %1378) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1397 = "llvm.insertelement"(%13, %1394, %59) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  %1398 = "llvm.insertelement"(%1397, %1396, %27) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  %1399 = "llvm.and"(%1398, %12) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1400 = "llvm.shufflevector"(%1393, %15) <{mask = array<i32: 0, 1, 2, 3, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %1401 = "llvm.shufflevector"(%1400, %101) <{mask = array<i32: 0, 1, 2, 3, -1, -1, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1402 = "llvm.shufflevector"(%1399, %13) <{mask = array<i32: 0, 1, -1, -1, -1, -1, -1, -1>}> : (vector<2xi64>, vector<2xi64>) -> vector<8xi64>
  %1403 = "llvm.shufflevector"(%1401, %1402) <{mask = array<i32: 0, 1, 2, 3, 8, 9, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1404 = "llvm.lshr"(%1403, %197) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1405 = "llvm.shl"(%1403, %241) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1406 = "llvm.shl"(%1403, %249) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1407 = "llvm.shufflevector"(%1404, %48) <{mask = array<i32: 0, 1, 2, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<4xi64>
  %1408 = "llvm.shufflevector"(%1405, %48) <{mask = array<i32: 1, 2, 3, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<4xi64>
  %1409 = "llvm.or"(%1407, %1408) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1410 = "llvm.shufflevector"(%1406, %48) <{mask = array<i32: 1, 2, 4, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<4xi64>
  %1411 = "llvm.or"(%1409, %1410) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.store"(%1411, %arg0) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%251) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%250) : (!llvm.ptr) -> ()
  "llvm.return"(%arg0) : (!llvm.ptr) -> ()
}) : () -> ()

    with
      @fd_f25519_one.28 := Firedancer.Lane.Mlir.fd_f25519_one_28,
      @fd_f25519_sqrt_ratio := Firedancer.Lane.Mlir.fd_f25519_sqrt_ratio

end

end Firedancer.Lane.Mlir
