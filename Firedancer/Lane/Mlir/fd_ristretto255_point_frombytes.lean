
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.Lane.Mlir.fd_f25519_one_28
public import Firedancer.Lane.Mlir.fd_f25519_sqrt_ratio

namespace Firedancer.Lane.Mlir

@[expose] public section

mlir_def fd_ristretto255_point_frombytes := "llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nofree, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<ptr (ptr, ptr)>, linkage = #llvm.linkage<external>, no_unwind, passthrough = ["sspstrong", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], res_attrs = [{llvm.noundef}], sym_name = "fd_ristretto255_point_frombytes", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr):
  %0 = "llvm.mlir.constant"() <{value = true}> : () -> i1
  %1 = "llvm.mlir.constant"() <{value = -1 : i8}> : () -> i8
  %2 = "llvm.mlir.undef"() : () -> vector<4xi64>
  %3 = "llvm.mlir.constant"() <{value = dense<2> : vector<8xi64>}> : () -> vector<8xi64>
  %4 = "llvm.mlir.poison"() : () -> vector<6xi64>
  %5 = "llvm.mlir.addressof"() <{global_name = @fd_f25519_one.28}> : () -> !llvm.ptr
  %6 = "llvm.mlir.constant"() <{value = dense<[8796093022189, 8796093022207, 8796093022207, 8796093022207, 8796093022207, 1099511627775, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %7 = "llvm.mlir.constant"() <{value = dense<[8795933638637, 8796091973631, 8796091973631, 8796091973631, 8796091973631, 1099510579199, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %8 = "llvm.mlir.constant"() <{value = dense<[6365466163363, 253762649449, 7518893317, 260847760460, 7696165686388, 704489577558, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %9 = "llvm.mlir.constant"() <{value = dense<[1, 0, 0, 0, 0, 0, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %10 = "llvm.mlir.constant"() <{value = dense<[159383552, 1048576, 1048576, 1048576, 1048576, 1048576, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %11 = "llvm.mlir.constant"() <{value = dense<[-1, 0, 0, 0, 0, 0, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %12 = "llvm.mlir.constant"() <{value = dense<18> : vector<8xi64>}> : () -> vector<8xi64>
  %13 = "llvm.mlir.constant"() <{value = dense<[8795933638638, 8796091973631, 8796091973631, 8796091973631, 8796091973631, 1099510579199, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %14 = "llvm.mlir.constant"() <{value = dense<[19, 1, 1, 1, 1, 1, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %15 = "llvm.mlir.constant"() <{value = dense<[43, 43, 43, 43, 43, 40, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %16 = "llvm.mlir.constant"() <{value = dense<[8796093022207, 8796093022207, 8796093022207, 8796093022207, 8796093022207, 1099511627775, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %17 = "llvm.mlir.constant"() <{value = dense<24> : vector<8xi64>}> : () -> vector<8xi64>
  %18 = "llvm.mlir.constant"() <{value = dense<7> : vector<8xi64>}> : () -> vector<8xi64>
  %19 = "llvm.mlir.constant"() <{value = dense<[-1, -1, -1, -1, -1, -1, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %20 = "llvm.mlir.constant"() <{value = dense<[0, -1, 0, -1, -1, -1, -1, -1]> : vector<8xi64>}> : () -> vector<8xi64>
  %21 = "llvm.mlir.constant"() <{value = dense<[0, 0, -1, -1, -1, -1, -1, -1]> : vector<8xi64>}> : () -> vector<8xi64>
  %22 = "llvm.mlir.constant"() <{value = dense<9> : vector<8xi64>}> : () -> vector<8xi64>
  %23 = "llvm.mlir.constant"() <{value = dense<0> : vector<8xi64>}> : () -> vector<8xi64>
  %24 = "llvm.mlir.constant"() <{value = dense<[1, 1, 0, 1, 0, 1, 1, 1]> : vector<8xi64>}> : () -> vector<8xi64>
  %25 = "llvm.mlir.constant"() <{value = dense<[0, 1, 0, 1, 1, 1, 1, 1]> : vector<8xi64>}> : () -> vector<8xi64>
  %26 = "llvm.mlir.constant"() <{value = dense<[0, 1, 1, 1, 1, 1, 0, 1]> : vector<8xi64>}> : () -> vector<8xi64>
  %27 = "llvm.mlir.zero"() : () -> !llvm.ptr
  %28 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %29 = "llvm.mlir.constant"() <{value = 1 : i8}> : () -> i8
  %30 = "llvm.mlir.poison"() : () -> vector<8xi64>
  %31 = "llvm.mlir.constant"() <{value = 44 : i64}> : () -> i64
  %32 = "llvm.mlir.constant"() <{value = 22 : i64}> : () -> i64
  %33 = "llvm.mlir.constant"() <{value = 23 : i64}> : () -> i64
  %34 = "llvm.mlir.constant"() <{value = 21 : i64}> : () -> i64
  %35 = "llvm.mlir.constant"() <{value = 42 : i64}> : () -> i64
  %36 = "llvm.mlir.constant"() <{value = 20 : i64}> : () -> i64
  %37 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %38 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %39 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %40 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %41 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %42 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %43 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %44 = "llvm.mlir.constant"() <{value = dense<[-1, -1, -1, 9223372036854775807]> : vector<4xi64>}> : () -> vector<4xi64>
  %45 = "llvm.mlir.poison"() : () -> vector<4xi64>
  %46 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %47 = "llvm.mlir.constant"() <{value = 7 : i64}> : () -> i64
  %48 = "llvm.mlir.poison"() : () -> vector<64xi8>
  %49 = "llvm.mlir.constant"() <{value = dense<[0, 3, 6, 1, 4, 7, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %50 = "llvm.mlir.constant"() <{value = dense<8796093022207> : vector<8xi64>}> : () -> vector<8xi64>
  %51 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %52 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %53 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %54 = "llvm.mlir.constant"() <{value = 4 : i64}> : () -> i64
  %55 = "llvm.mlir.constant"() <{value = 5 : i64}> : () -> i64
  %56 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
  %57 = "llvm.mlir.constant"() <{value = 1099511627775 : i64}> : () -> i64
  %58 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %59 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %60 = "llvm.mlir.constant"() <{value = 43 : i64}> : () -> i64
  %61 = "llvm.mlir.constant"() <{value = 8796093022207 : i64}> : () -> i64
  %62 = "llvm.mlir.constant"() <{value = 1099511627776 : i64}> : () -> i64
  %63 = "llvm.mlir.constant"() <{value = -19 : i64}> : () -> i64
  %64 = "llvm.mlir.constant"() <{value = dense<8796093022207> : vector<4xi64>}> : () -> vector<4xi64>
  %65 = "llvm.mlir.poison"() : () -> vector<2xi64>
  %66 = "llvm.mlir.constant"() <{value = dense<[8796093022207, -1]> : vector<2xi64>}> : () -> vector<2xi64>
  %67 = "llvm.mlir.poison"() : () -> i64
  %68 = "llvm.mlir.undef"() : () -> vector<8xi64>
  %69 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %70 = "llvm.insertelement"(%68, %67, %69) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %71 = "llvm.insertelement"(%70, %67, %43) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %72 = "llvm.insertelement"(%71, %67, %42) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %73 = "llvm.insertelement"(%72, %67, %41) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %74 = "llvm.insertelement"(%73, %67, %40) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %75 = "llvm.insertelement"(%74, %67, %39) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %76 = "llvm.insertelement"(%75, %46, %38) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %77 = "llvm.insertelement"(%76, %46, %37) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %78 = "llvm.insertelement"(%68, %46, %69) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %79 = "llvm.insertelement"(%78, %34, %43) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %80 = "llvm.insertelement"(%79, %35, %42) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %81 = "llvm.insertelement"(%80, %67, %41) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %82 = "llvm.insertelement"(%81, %36, %40) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %83 = "llvm.insertelement"(%82, %67, %39) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %84 = "llvm.insertelement"(%83, %67, %38) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %85 = "llvm.insertelement"(%84, %67, %37) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %86 = "llvm.insertelement"(%68, %46, %69) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %87 = "llvm.insertelement"(%86, %60, %43) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %88 = "llvm.insertelement"(%87, %32, %42) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %89 = "llvm.insertelement"(%88, %51, %41) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %90 = "llvm.insertelement"(%89, %67, %40) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %91 = "llvm.insertelement"(%90, %33, %39) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %92 = "llvm.insertelement"(%91, %67, %38) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %93 = "llvm.insertelement"(%92, %67, %37) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %94 = "llvm.insertelement"(%68, %46, %69) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %95 = "llvm.insertelement"(%94, %60, %43) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %96 = "llvm.insertelement"(%95, %32, %42) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %97 = "llvm.insertelement"(%96, %67, %41) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %98 = "llvm.insertelement"(%97, %31, %40) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %99 = "llvm.insertelement"(%98, %33, %39) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %100 = "llvm.insertelement"(%99, %67, %38) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %101 = "llvm.insertelement"(%100, %67, %37) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %102 = "llvm.insertelement"(%68, %58, %69) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %103 = "llvm.insertelement"(%102, %58, %43) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %104 = "llvm.insertelement"(%103, %46, %42) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %105 = "llvm.insertelement"(%104, %46, %41) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %106 = "llvm.insertelement"(%105, %46, %40) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %107 = "llvm.insertelement"(%106, %46, %39) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %108 = "llvm.insertelement"(%107, %67, %38) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %109 = "llvm.insertelement"(%108, %67, %37) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %110 = "llvm.insertelement"(%68, %58, %69) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %111 = "llvm.insertelement"(%110, %46, %43) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %112 = "llvm.insertelement"(%111, %58, %42) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %113 = "llvm.insertelement"(%112, %46, %41) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %114 = "llvm.insertelement"(%113, %46, %40) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %115 = "llvm.insertelement"(%114, %46, %39) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %116 = "llvm.insertelement"(%115, %67, %38) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %117 = "llvm.insertelement"(%116, %67, %37) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %118 = "llvm.insertelement"(%68, %58, %69) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %119 = "llvm.insertelement"(%118, %58, %43) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %120 = "llvm.insertelement"(%119, %46, %42) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %121 = "llvm.insertelement"(%120, %46, %41) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %122 = "llvm.insertelement"(%121, %46, %40) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %123 = "llvm.insertelement"(%122, %67, %39) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %124 = "llvm.insertelement"(%123, %67, %38) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %125 = "llvm.insertelement"(%124, %67, %37) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %126 = "llvm.insertelement"(%68, %58, %69) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %127 = "llvm.insertelement"(%126, %46, %43) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %128 = "llvm.insertelement"(%127, %58, %42) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %129 = "llvm.insertelement"(%128, %46, %41) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %130 = "llvm.insertelement"(%129, %46, %40) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %131 = "llvm.insertelement"(%130, %67, %39) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %132 = "llvm.insertelement"(%131, %67, %38) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %133 = "llvm.insertelement"(%132, %67, %37) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %134 = "llvm.insertelement"(%68, %67, %69) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %135 = "llvm.insertelement"(%134, %67, %43) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %136 = "llvm.insertelement"(%135, %67, %42) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %137 = "llvm.insertelement"(%136, %67, %41) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %138 = "llvm.insertelement"(%137, %67, %40) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %139 = "llvm.insertelement"(%138, %67, %39) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %140 = "llvm.insertelement"(%139, %67, %38) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %141 = "llvm.insertelement"(%140, %46, %37) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %142 = "llvm.insertelement"(%68, %46, %69) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %143 = "llvm.insertelement"(%142, %46, %43) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %144 = "llvm.insertelement"(%143, %46, %42) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %145 = "llvm.insertelement"(%144, %46, %41) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %146 = "llvm.insertelement"(%145, %46, %40) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %147 = "llvm.insertelement"(%146, %67, %39) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %148 = "llvm.insertelement"(%147, %67, %38) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %149 = "llvm.insertelement"(%148, %67, %37) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %150 = "llvm.insertelement"(%68, %46, %69) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %151 = "llvm.insertelement"(%150, %67, %43) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %152 = "llvm.insertelement"(%151, %67, %42) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %153 = "llvm.insertelement"(%152, %67, %41) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %154 = "llvm.insertelement"(%153, %67, %40) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %155 = "llvm.insertelement"(%154, %67, %39) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %156 = "llvm.insertelement"(%155, %67, %38) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %157 = "llvm.insertelement"(%156, %67, %37) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %158 = "llvm.insertelement"(%68, %67, %69) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %159 = "llvm.insertelement"(%158, %67, %43) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %160 = "llvm.insertelement"(%159, %67, %42) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %161 = "llvm.insertelement"(%160, %67, %41) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %162 = "llvm.insertelement"(%161, %67, %40) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %163 = "llvm.insertelement"(%162, %46, %39) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %164 = "llvm.insertelement"(%163, %46, %38) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %165 = "llvm.insertelement"(%164, %46, %37) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %166 = "llvm.insertelement"(%68, %46, %69) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %167 = "llvm.insertelement"(%166, %46, %43) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %168 = "llvm.insertelement"(%167, %46, %42) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %169 = "llvm.insertelement"(%168, %67, %41) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %170 = "llvm.insertelement"(%169, %67, %40) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %171 = "llvm.insertelement"(%170, %67, %39) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %172 = "llvm.insertelement"(%171, %67, %38) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %173 = "llvm.insertelement"(%172, %67, %37) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %174 = "llvm.insertelement"(%68, %67, %69) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %175 = "llvm.insertelement"(%174, %67, %43) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %176 = "llvm.insertelement"(%175, %67, %42) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %177 = "llvm.insertelement"(%176, %67, %41) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %178 = "llvm.insertelement"(%177, %46, %40) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %179 = "llvm.insertelement"(%178, %46, %39) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %180 = "llvm.insertelement"(%179, %46, %38) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %181 = "llvm.insertelement"(%180, %46, %37) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %182 = "llvm.insertelement"(%68, %46, %69) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %183 = "llvm.insertelement"(%182, %46, %43) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %184 = "llvm.insertelement"(%183, %67, %42) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %185 = "llvm.insertelement"(%184, %67, %41) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %186 = "llvm.insertelement"(%185, %67, %40) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %187 = "llvm.insertelement"(%186, %67, %39) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %188 = "llvm.insertelement"(%187, %67, %38) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %189 = "llvm.insertelement"(%188, %67, %37) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %190 = "llvm.insertelement"(%68, %67, %69) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %191 = "llvm.insertelement"(%190, %67, %43) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %192 = "llvm.insertelement"(%191, %67, %42) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %193 = "llvm.insertelement"(%192, %46, %41) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %194 = "llvm.insertelement"(%193, %46, %40) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %195 = "llvm.insertelement"(%194, %46, %39) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %196 = "llvm.insertelement"(%195, %46, %38) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %197 = "llvm.insertelement"(%196, %46, %37) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %198 = "llvm.insertelement"(%68, %67, %69) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %199 = "llvm.insertelement"(%198, %67, %43) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %200 = "llvm.insertelement"(%199, %46, %42) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %201 = "llvm.insertelement"(%200, %46, %41) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %202 = "llvm.insertelement"(%201, %46, %40) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %203 = "llvm.insertelement"(%202, %46, %39) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %204 = "llvm.insertelement"(%203, %46, %38) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %205 = "llvm.insertelement"(%204, %46, %37) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %206 = "llvm.insertelement"(%2, %67, %69) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %207 = "llvm.insertelement"(%206, %60, %43) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %208 = "llvm.insertelement"(%207, %67, %42) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %209 = "llvm.insertelement"(%208, %67, %41) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %210 = "llvm.insertelement"(%68, %51, %69) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %211 = "llvm.insertelement"(%210, %46, %43) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %212 = "llvm.insertelement"(%211, %67, %42) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %213 = "llvm.insertelement"(%212, %67, %41) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %214 = "llvm.insertelement"(%213, %46, %40) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %215 = "llvm.insertelement"(%214, %46, %39) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %216 = "llvm.insertelement"(%215, %67, %38) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %217 = "llvm.insertelement"(%216, %67, %37) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %218 = "llvm.insertelement"(%68, %67, %69) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %219 = "llvm.insertelement"(%218, %67, %43) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %220 = "llvm.insertelement"(%219, %46, %42) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %221 = "llvm.insertelement"(%220, %46, %41) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %222 = "llvm.insertelement"(%221, %46, %40) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %223 = "llvm.insertelement"(%222, %46, %39) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %224 = "llvm.insertelement"(%223, %67, %38) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %225 = "llvm.insertelement"(%224, %67, %37) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %226 = "llvm.alloca"(%43) <{alignment = 16 : i64, elem_type = !llvm.array<32 x i8>}> : (i32) -> !llvm.ptr
  %227 = "llvm.alloca"(%43) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %228 = "llvm.alloca"(%43) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %229 = "llvm.load"(%arg1) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %230 = "llvm.and"(%229, %44) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %231 = "llvm.shufflevector"(%230, %45) <{mask = array<i32: 0, 1, 2, 3, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %232 = "llvm.insertelement"(%231, %46, %47) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %233 = "llvm.bitcast"(%232) : (vector<8xi64>) -> vector<64xi8>
  %234 = "llvm.shufflevector"(%233, %48) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 63, 63, 5, 6, 7, 8, 9, 10, 63, 63, 10, 11, 12, 13, 14, 15, 16, 63, 16, 17, 18, 19, 20, 21, 63, 63, 21, 22, 23, 24, 25, 26, 63, 63, 26, 27, 28, 29, 30, 31, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %235 = "llvm.bitcast"(%234) : (vector<64xi8>) -> vector<8xi64>
  %236 = "llvm.lshr"(%235, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %237 = "llvm.and"(%236, %50) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.intr.lifetime.start"(%226) : (!llvm.ptr) -> ()
  %238 = "llvm.extractelement"(%237, %46) : (vector<8xi64>, i64) -> i64
  %239 = "llvm.extractelement"(%237, %51) : (vector<8xi64>, i64) -> i64
  %240 = "llvm.extractelement"(%237, %52) : (vector<8xi64>, i64) -> i64
  %241 = "llvm.extractelement"(%237, %53) : (vector<8xi64>, i64) -> i64
  %242 = "llvm.extractelement"(%237, %54) : (vector<8xi64>, i64) -> i64
  %243 = "llvm.extractelement"(%237, %55) : (vector<8xi64>, i64) -> i64
  %244 = "llvm.lshr"(%243, %56) : (i64, i64) -> i64
  %245 = "llvm.and"(%243, %57) : (i64, i64) -> i64
  %246 = "llvm.add"(%245, %58) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %247 = "llvm.ashr"(%246, %56) : (i64, i64) -> i64
  %248 = "llvm.and"(%246, %57) : (i64, i64) -> i64
  %249 = "llvm.add"(%247, %244) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %250 = "llvm.mul"(%249, %59) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %251 = "llvm.add"(%250, %238) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %252 = "llvm.ashr"(%251, %60) : (i64, i64) -> i64
  %253 = "llvm.and"(%251, %61) : (i64, i64) -> i64
  %254 = "llvm.add"(%252, %239) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %255 = "llvm.ashr"(%254, %60) : (i64, i64) -> i64
  %256 = "llvm.and"(%254, %61) : (i64, i64) -> i64
  %257 = "llvm.add"(%255, %240) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %258 = "llvm.ashr"(%257, %60) : (i64, i64) -> i64
  %259 = "llvm.and"(%257, %61) : (i64, i64) -> i64
  %260 = "llvm.add"(%258, %241) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %261 = "llvm.ashr"(%260, %60) : (i64, i64) -> i64
  %262 = "llvm.and"(%260, %61) : (i64, i64) -> i64
  %263 = "llvm.add"(%261, %242) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %264 = "llvm.ashr"(%263, %60) : (i64, i64) -> i64
  %265 = "llvm.and"(%263, %61) : (i64, i64) -> i64
  %266 = "llvm.add"(%253, %59) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %267 = "llvm.lshr"(%266, %60) : (i64, i64) -> i64
  %268 = "llvm.and"(%266, %61) : (i64, i64) -> i64
  %269 = "llvm.add"(%256, %267) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %270 = "llvm.lshr"(%269, %60) : (i64, i64) -> i64
  %271 = "llvm.and"(%269, %61) : (i64, i64) -> i64
  %272 = "llvm.add"(%259, %270) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %273 = "llvm.lshr"(%272, %60) : (i64, i64) -> i64
  %274 = "llvm.and"(%272, %61) : (i64, i64) -> i64
  %275 = "llvm.add"(%262, %273) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %276 = "llvm.lshr"(%275, %60) : (i64, i64) -> i64
  %277 = "llvm.and"(%275, %61) : (i64, i64) -> i64
  %278 = "llvm.add"(%265, %276) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %279 = "llvm.lshr"(%278, %60) : (i64, i64) -> i64
  %280 = "llvm.and"(%278, %61) : (i64, i64) -> i64
  %281 = "llvm.add"(%248, %51) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %282 = "llvm.add"(%281, %264) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %283 = "llvm.add"(%282, %279) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %284 = "llvm.and"(%283, %57) : (i64, i64) -> i64
  %285 = "llvm.icmp"(%283, %62) <{predicate = 6 : i64}> : (i64, i64) -> i1
  %286 = "llvm.select"(%285, %63, %46) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %287 = "llvm.add"(%286, %268) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %288 = "llvm.ashr"(%287, %60) : (i64, i64) -> i64
  %289 = "llvm.add"(%288, %271) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %290 = "llvm.ashr"(%289, %60) : (i64, i64) -> i64
  %291 = "llvm.add"(%290, %274) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %292 = "llvm.ashr"(%291, %60) : (i64, i64) -> i64
  %293 = "llvm.add"(%292, %277) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %294 = "llvm.ashr"(%293, %60) : (i64, i64) -> i64
  %295 = "llvm.insertelement"(%45, %287, %46) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %296 = "llvm.insertelement"(%295, %289, %51) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %297 = "llvm.insertelement"(%296, %291, %52) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %298 = "llvm.insertelement"(%297, %293, %53) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %299 = "llvm.and"(%298, %64) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %300 = "llvm.add"(%294, %280) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %301 = "llvm.ashr"(%300, %60) : (i64, i64) -> i64
  %302 = "llvm.add"(%301, %284) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %303 = "llvm.insertelement"(%65, %300, %46) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  %304 = "llvm.insertelement"(%303, %302, %51) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  %305 = "llvm.and"(%304, %66) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %306 = "llvm.shufflevector"(%299, %45) <{mask = array<i32: 0, 1, 2, 3, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %307 = "llvm.shufflevector"(%306, %77) <{mask = array<i32: 0, 1, 2, 3, -1, -1, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %308 = "llvm.shufflevector"(%305, %65) <{mask = array<i32: 0, 1, -1, -1, -1, -1, -1, -1>}> : (vector<2xi64>, vector<2xi64>) -> vector<8xi64>
  %309 = "llvm.shufflevector"(%307, %308) <{mask = array<i32: 0, 1, 2, 3, 8, 9, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %310 = "llvm.lshr"(%309, %85) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %311 = "llvm.shl"(%309, %93) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %312 = "llvm.shl"(%309, %101) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %313 = "llvm.shufflevector"(%310, %30) <{mask = array<i32: 0, 1, 2, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<4xi64>
  %314 = "llvm.shufflevector"(%311, %30) <{mask = array<i32: 1, 2, 3, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<4xi64>
  %315 = "llvm.or"(%313, %314) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %316 = "llvm.shufflevector"(%312, %30) <{mask = array<i32: 1, 2, 4, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<4xi64>
  %317 = "llvm.or"(%315, %316) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.store"(%317, %226) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<4xi64>, !llvm.ptr) -> ()
  %318 = "llvm.load"(%arg1) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i256
  %319 = "llvm.load"(%226) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i256
  %320 = "llvm.icmp"(%318, %319) <{predicate = 1 : i64}> : (i256, i256) -> i1
  %321 = "llvm.load"(%arg1) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %322 = "llvm.and"(%321, %29) : (i8, i8) -> i8
  %323 = "llvm.zext"(%320) : (i1) -> i8
  %324 = "llvm.or"(%322, %323) : (i8, i8) -> i8
  %325 = "llvm.icmp"(%324, %28) <{predicate = 0 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%325, %27)[^bb1, ^bb4] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, !llvm.ptr) -> ()
^bb1:  // pred: ^bb0
  %326 = "llvm.shufflevector"(%237, %30) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %327 = "llvm.shufflevector"(%237, %30) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 3, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %328 = "llvm.shufflevector"(%237, %30) <{mask = array<i32: 4, 4, 1, 1, 1, 1, 1, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %329 = "llvm.shufflevector"(%237, %30) <{mask = array<i32: 4, 5, 1, 2, 3, 4, 5, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %330 = "llvm.shufflevector"(%237, %30) <{mask = array<i32: 3, 7, 5, 7, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %331 = "llvm.shufflevector"(%237, %30) <{mask = array<i32: 5, 7, 5, 7, 2, 3, 4, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %332 = "llvm.shl"(%326, %26) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %333 = "llvm.shl"(%328, %25) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %334 = "llvm.shl"(%330, %24) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %335 = "llvm.call_intrinsic"(%23, %333, %329) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %336 = "llvm.call_intrinsic"(%23, %334, %331) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %337 = "llvm.call_intrinsic"(%23, %332, %327) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %338 = "llvm.shl"(%337, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %339 = "llvm.call_intrinsic"(%23, %333, %329) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %340 = "llvm.shl"(%339, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %341 = "llvm.call_intrinsic"(%23, %334, %331) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %342 = "llvm.shl"(%341, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %343 = "llvm.and"(%335, %21) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %344 = "llvm.and"(%336, %20) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %345 = "llvm.add"(%344, %343) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %346 = "llvm.call_intrinsic"(%345, %332, %327) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %347 = "llvm.and"(%340, %21) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %348 = "llvm.and"(%342, %20) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %349 = "llvm.add"(%347, %338) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %350 = "llvm.add"(%349, %348) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %351 = "llvm.and"(%335, %109) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %352 = "llvm.and"(%336, %117) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %353 = "llvm.and"(%340, %125) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %354 = "llvm.and"(%342, %133) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %355 = "llvm.add"(%354, %353) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %356 = "llvm.shufflevector"(%141, %350) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %357 = "llvm.add"(%356, %346) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %358 = "llvm.shufflevector"(%141, %355) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %359 = "llvm.shufflevector"(%350, %149) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %360 = "llvm.add"(%352, %351) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %361 = "llvm.add"(%360, %358) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %362 = "llvm.add"(%361, %359) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %363 = "llvm.and"(%357, %19) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %364 = "llvm.shufflevector"(%357, %362) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %365 = "llvm.shl"(%364, %18) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %366 = "llvm.add"(%365, %363) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %367 = "llvm.mul"(%364, %17) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %368 = "llvm.add"(%366, %367) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %369 = "llvm.and"(%368, %16) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %370 = "llvm.lshr"(%368, %15) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %371 = "llvm.shufflevector"(%370, %30) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %372 = "llvm.call_intrinsic"(%369, %14, %371) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %373 = "llvm.sub"(%13, %372) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %374 = "llvm.and"(%373, %16) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %375 = "llvm.ashr"(%373, %15) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %376 = "llvm.shufflevector"(%375, %157) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 8, 8>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %377 = "llvm.mul"(%376, %12) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %378 = "llvm.and"(%377, %11) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %379 = "llvm.add"(%374, %10) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %380 = "llvm.add"(%379, %376) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %381 = "llvm.add"(%380, %378) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %382 = "llvm.add"(%372, %9) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %383 = "llvm.and"(%382, %16) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %384 = "llvm.lshr"(%382, %15) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %385 = "llvm.shufflevector"(%384, %30) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %386 = "llvm.call_intrinsic"(%383, %14, %385) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %387 = "llvm.shufflevector"(%386, %30) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %388 = "llvm.shufflevector"(%386, %30) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 3, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %389 = "llvm.shufflevector"(%386, %30) <{mask = array<i32: 4, 4, 1, 1, 1, 1, 1, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %390 = "llvm.shufflevector"(%386, %30) <{mask = array<i32: 4, 5, 1, 2, 3, 4, 5, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %391 = "llvm.shufflevector"(%386, %30) <{mask = array<i32: 3, 7, 5, 7, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %392 = "llvm.shufflevector"(%386, %30) <{mask = array<i32: 5, 7, 5, 7, 2, 3, 4, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %393 = "llvm.shl"(%387, %26) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %394 = "llvm.shl"(%389, %25) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %395 = "llvm.shl"(%391, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %396 = "llvm.call_intrinsic"(%23, %394, %390) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %397 = "llvm.call_intrinsic"(%23, %395, %392) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %398 = "llvm.call_intrinsic"(%23, %393, %388) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %399 = "llvm.shl"(%398, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %400 = "llvm.call_intrinsic"(%23, %394, %390) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %401 = "llvm.shl"(%400, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %402 = "llvm.call_intrinsic"(%23, %395, %392) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %403 = "llvm.shl"(%402, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %404 = "llvm.and"(%396, %21) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %405 = "llvm.and"(%397, %20) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %406 = "llvm.add"(%405, %404) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %407 = "llvm.call_intrinsic"(%406, %393, %388) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %408 = "llvm.and"(%401, %21) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %409 = "llvm.and"(%403, %20) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %410 = "llvm.add"(%408, %399) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %411 = "llvm.add"(%410, %409) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %412 = "llvm.and"(%396, %109) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %413 = "llvm.and"(%397, %117) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %414 = "llvm.and"(%401, %125) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %415 = "llvm.and"(%403, %133) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %416 = "llvm.add"(%415, %414) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %417 = "llvm.shufflevector"(%141, %411) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %418 = "llvm.add"(%417, %407) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %419 = "llvm.shufflevector"(%141, %416) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %420 = "llvm.shufflevector"(%411, %149) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %421 = "llvm.add"(%413, %412) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %422 = "llvm.add"(%421, %419) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %423 = "llvm.add"(%422, %420) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %424 = "llvm.and"(%418, %19) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %425 = "llvm.shufflevector"(%418, %423) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %426 = "llvm.shl"(%425, %18) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %427 = "llvm.add"(%426, %424) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %428 = "llvm.mul"(%425, %17) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %429 = "llvm.add"(%427, %428) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %430 = "llvm.and"(%429, %16) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %431 = "llvm.lshr"(%429, %15) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %432 = "llvm.shufflevector"(%431, %30) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %433 = "llvm.call_intrinsic"(%430, %14, %432) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %434 = "llvm.shufflevector"(%381, %30) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %435 = "llvm.shufflevector"(%381, %30) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 3, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %436 = "llvm.shufflevector"(%381, %30) <{mask = array<i32: 4, 4, 1, 1, 1, 1, 1, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %437 = "llvm.shufflevector"(%381, %30) <{mask = array<i32: 4, 5, 1, 2, 3, 4, 5, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %438 = "llvm.shufflevector"(%381, %30) <{mask = array<i32: 3, 7, 5, 7, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %439 = "llvm.shufflevector"(%381, %30) <{mask = array<i32: 5, 7, 5, 7, 2, 3, 4, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %440 = "llvm.shl"(%434, %26) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %441 = "llvm.shl"(%436, %25) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %442 = "llvm.shl"(%438, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %443 = "llvm.call_intrinsic"(%23, %441, %437) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %444 = "llvm.call_intrinsic"(%23, %442, %439) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %445 = "llvm.call_intrinsic"(%23, %440, %435) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %446 = "llvm.shl"(%445, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %447 = "llvm.call_intrinsic"(%23, %441, %437) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %448 = "llvm.shl"(%447, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %449 = "llvm.call_intrinsic"(%23, %442, %439) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %450 = "llvm.shl"(%449, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %451 = "llvm.and"(%443, %21) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %452 = "llvm.and"(%444, %20) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %453 = "llvm.add"(%452, %451) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %454 = "llvm.call_intrinsic"(%453, %440, %435) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %455 = "llvm.and"(%448, %21) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %456 = "llvm.and"(%450, %20) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %457 = "llvm.add"(%455, %446) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %458 = "llvm.add"(%457, %456) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %459 = "llvm.and"(%443, %109) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %460 = "llvm.and"(%444, %117) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %461 = "llvm.and"(%448, %125) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %462 = "llvm.and"(%450, %133) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %463 = "llvm.add"(%462, %461) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %464 = "llvm.shufflevector"(%141, %458) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %465 = "llvm.add"(%464, %454) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %466 = "llvm.shufflevector"(%141, %463) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %467 = "llvm.shufflevector"(%458, %149) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %468 = "llvm.add"(%460, %459) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %469 = "llvm.add"(%468, %466) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %470 = "llvm.add"(%469, %467) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %471 = "llvm.and"(%465, %19) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %472 = "llvm.shufflevector"(%465, %470) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %473 = "llvm.shl"(%472, %18) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %474 = "llvm.add"(%473, %471) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %475 = "llvm.mul"(%472, %17) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %476 = "llvm.add"(%474, %475) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %477 = "llvm.and"(%476, %16) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %478 = "llvm.lshr"(%476, %15) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %479 = "llvm.shufflevector"(%478, %30) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %480 = "llvm.call_intrinsic"(%477, %14, %479) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %481 = "llvm.shufflevector"(%480, %30) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %482 = "llvm.shufflevector"(%480, %30) <{mask = array<i32: 1, 1, 1, 1, 1, 1, 1, 1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %483 = "llvm.shufflevector"(%480, %30) <{mask = array<i32: 2, 2, 2, 2, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %484 = "llvm.shufflevector"(%480, %30) <{mask = array<i32: 3, 3, 3, 3, 3, 3, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %485 = "llvm.shufflevector"(%480, %30) <{mask = array<i32: 4, 4, 4, 4, 4, 4, 4, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %486 = "llvm.shufflevector"(%480, %30) <{mask = array<i32: 5, 5, 5, 5, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %487 = "llvm.call_intrinsic"(%23, %481, %8) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %488 = "llvm.shl"(%487, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %489 = "llvm.call_intrinsic"(%488, %482, %8) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %490 = "llvm.call_intrinsic"(%23, %482, %8) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %491 = "llvm.shl"(%490, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %492 = "llvm.call_intrinsic"(%491, %483, %8) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %493 = "llvm.call_intrinsic"(%23, %483, %8) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %494 = "llvm.shl"(%493, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %495 = "llvm.call_intrinsic"(%494, %484, %8) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %496 = "llvm.call_intrinsic"(%23, %484, %8) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %497 = "llvm.shl"(%496, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %498 = "llvm.call_intrinsic"(%497, %485, %8) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %499 = "llvm.call_intrinsic"(%23, %485, %8) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %500 = "llvm.shl"(%499, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %501 = "llvm.call_intrinsic"(%500, %486, %8) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %502 = "llvm.call_intrinsic"(%23, %486, %8) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %503 = "llvm.shl"(%502, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %504 = "llvm.shufflevector"(%141, %489) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %505 = "llvm.shufflevector"(%77, %492) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %506 = "llvm.shufflevector"(%165, %495) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %507 = "llvm.shufflevector"(%495, %173) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %508 = "llvm.shufflevector"(%181, %498) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %509 = "llvm.shufflevector"(%498, %189) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %510 = "llvm.shufflevector"(%197, %501) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %511 = "llvm.shufflevector"(%501, %157) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %512 = "llvm.shufflevector"(%205, %503) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %513 = "llvm.shufflevector"(%503, %30) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %514 = "llvm.call_intrinsic"(%504, %481, %8) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %515 = "llvm.add"(%506, %505) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %516 = "llvm.add"(%515, %508) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %517 = "llvm.add"(%516, %510) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %518 = "llvm.add"(%517, %514) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %519 = "llvm.add"(%518, %512) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %520 = "llvm.add"(%509, %507) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %521 = "llvm.add"(%520, %511) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %522 = "llvm.add"(%521, %513) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %523 = "llvm.and"(%519, %19) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %524 = "llvm.shufflevector"(%519, %522) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %525 = "llvm.shl"(%524, %18) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %526 = "llvm.add"(%525, %523) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %527 = "llvm.mul"(%524, %17) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %528 = "llvm.add"(%526, %527) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %529 = "llvm.and"(%528, %16) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %530 = "llvm.lshr"(%528, %15) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %531 = "llvm.shufflevector"(%530, %30) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %532 = "llvm.call_intrinsic"(%529, %14, %531) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %533 = "llvm.sub"(%7, %532) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %534 = "llvm.and"(%533, %16) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %535 = "llvm.ashr"(%533, %15) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %536 = "llvm.shufflevector"(%535, %157) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 8, 8>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %537 = "llvm.mul"(%536, %12) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %538 = "llvm.and"(%537, %11) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %539 = "llvm.sub"(%534, %433) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %540 = "llvm.add"(%539, %6) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %541 = "llvm.add"(%540, %536) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %542 = "llvm.add"(%541, %538) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %543 = "llvm.and"(%542, %16) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %544 = "llvm.ashr"(%542, %15) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %545 = "llvm.shufflevector"(%544, %157) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 8, 8>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %546 = "llvm.mul"(%545, %12) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %547 = "llvm.and"(%546, %11) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %548 = "llvm.add"(%543, %10) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %549 = "llvm.add"(%548, %545) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %550 = "llvm.add"(%549, %547) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.intr.lifetime.start"(%227) : (!llvm.ptr) -> ()
  %551 = "llvm.shufflevector"(%550, %30) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %552 = "llvm.shufflevector"(%550, %30) <{mask = array<i32: 1, 1, 1, 1, 1, 1, 1, 1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %553 = "llvm.shufflevector"(%550, %30) <{mask = array<i32: 2, 2, 2, 2, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %554 = "llvm.shufflevector"(%550, %30) <{mask = array<i32: 3, 3, 3, 3, 3, 3, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %555 = "llvm.shufflevector"(%550, %30) <{mask = array<i32: 4, 4, 4, 4, 4, 4, 4, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %556 = "llvm.shufflevector"(%550, %30) <{mask = array<i32: 5, 5, 5, 5, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %557 = "llvm.call_intrinsic"(%23, %551, %433) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %558 = "llvm.shl"(%557, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %559 = "llvm.call_intrinsic"(%558, %552, %433) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %560 = "llvm.call_intrinsic"(%23, %552, %433) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %561 = "llvm.shl"(%560, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %562 = "llvm.call_intrinsic"(%561, %553, %433) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %563 = "llvm.call_intrinsic"(%23, %553, %433) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %564 = "llvm.shl"(%563, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %565 = "llvm.call_intrinsic"(%564, %554, %433) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %566 = "llvm.call_intrinsic"(%23, %554, %433) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %567 = "llvm.shl"(%566, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %568 = "llvm.call_intrinsic"(%567, %555, %433) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %569 = "llvm.call_intrinsic"(%23, %555, %433) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %570 = "llvm.shl"(%569, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %571 = "llvm.call_intrinsic"(%570, %556, %433) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %572 = "llvm.call_intrinsic"(%23, %556, %433) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %573 = "llvm.shl"(%572, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %574 = "llvm.shufflevector"(%141, %559) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %575 = "llvm.shufflevector"(%77, %562) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %576 = "llvm.shufflevector"(%165, %565) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %577 = "llvm.shufflevector"(%565, %173) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %578 = "llvm.shufflevector"(%181, %568) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %579 = "llvm.shufflevector"(%568, %189) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %580 = "llvm.shufflevector"(%197, %571) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %581 = "llvm.shufflevector"(%571, %157) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %582 = "llvm.shufflevector"(%205, %573) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %583 = "llvm.shufflevector"(%573, %30) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %584 = "llvm.call_intrinsic"(%574, %551, %433) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %585 = "llvm.add"(%576, %575) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %586 = "llvm.add"(%585, %578) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %587 = "llvm.add"(%586, %580) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %588 = "llvm.add"(%587, %584) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %589 = "llvm.add"(%588, %582) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %590 = "llvm.add"(%579, %577) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %591 = "llvm.add"(%590, %581) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %592 = "llvm.add"(%591, %583) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %593 = "llvm.and"(%589, %19) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %594 = "llvm.shufflevector"(%589, %592) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %595 = "llvm.shl"(%594, %18) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %596 = "llvm.add"(%595, %593) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %597 = "llvm.mul"(%594, %17) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %598 = "llvm.add"(%596, %597) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %599 = "llvm.and"(%598, %16) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %600 = "llvm.lshr"(%598, %15) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %601 = "llvm.shufflevector"(%600, %30) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %602 = "llvm.call_intrinsic"(%599, %14, %601) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%602, %227) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%228) : (!llvm.ptr) -> ()
  %603 = "llvm.call"(%228, %5, %227) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_f25519_sqrt_ratio, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> i32
  %604 = "llvm.load"(%228) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<6xi64>
  %605 = "llvm.shufflevector"(%604, %4) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<6xi64>, vector<6xi64>) -> vector<8xi64>
  %606 = "llvm.shufflevector"(%604, %4) <{mask = array<i32: 1, 1, 1, 1, 1, 1, 1, 1>}> : (vector<6xi64>, vector<6xi64>) -> vector<8xi64>
  %607 = "llvm.shufflevector"(%604, %4) <{mask = array<i32: 2, 2, 2, 2, 2, 2, 2, 2>}> : (vector<6xi64>, vector<6xi64>) -> vector<8xi64>
  %608 = "llvm.shufflevector"(%604, %4) <{mask = array<i32: 3, 3, 3, 3, 3, 3, 3, 3>}> : (vector<6xi64>, vector<6xi64>) -> vector<8xi64>
  %609 = "llvm.shufflevector"(%604, %4) <{mask = array<i32: 4, 4, 4, 4, 4, 4, 4, 4>}> : (vector<6xi64>, vector<6xi64>) -> vector<8xi64>
  %610 = "llvm.shufflevector"(%604, %4) <{mask = array<i32: 5, 5, 5, 5, 5, 5, 5, 5>}> : (vector<6xi64>, vector<6xi64>) -> vector<8xi64>
  %611 = "llvm.call_intrinsic"(%23, %605, %386) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %612 = "llvm.shl"(%611, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %613 = "llvm.call_intrinsic"(%612, %606, %386) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %614 = "llvm.call_intrinsic"(%23, %606, %386) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %615 = "llvm.shl"(%614, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %616 = "llvm.call_intrinsic"(%615, %607, %386) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %617 = "llvm.call_intrinsic"(%23, %607, %386) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %618 = "llvm.shl"(%617, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %619 = "llvm.call_intrinsic"(%618, %608, %386) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %620 = "llvm.call_intrinsic"(%23, %608, %386) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %621 = "llvm.shl"(%620, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %622 = "llvm.call_intrinsic"(%621, %609, %386) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %623 = "llvm.call_intrinsic"(%23, %609, %386) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %624 = "llvm.shl"(%623, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %625 = "llvm.call_intrinsic"(%624, %610, %386) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %626 = "llvm.call_intrinsic"(%23, %610, %386) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %627 = "llvm.shl"(%626, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %628 = "llvm.shufflevector"(%141, %613) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %629 = "llvm.shufflevector"(%77, %616) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %630 = "llvm.shufflevector"(%165, %619) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %631 = "llvm.shufflevector"(%619, %173) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %632 = "llvm.shufflevector"(%181, %622) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %633 = "llvm.shufflevector"(%622, %189) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %634 = "llvm.shufflevector"(%197, %625) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %635 = "llvm.shufflevector"(%625, %157) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %636 = "llvm.shufflevector"(%205, %627) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %637 = "llvm.shufflevector"(%627, %30) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %638 = "llvm.call_intrinsic"(%628, %605, %386) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %639 = "llvm.add"(%630, %629) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %640 = "llvm.add"(%639, %632) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %641 = "llvm.add"(%640, %634) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %642 = "llvm.add"(%641, %638) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %643 = "llvm.add"(%642, %636) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %644 = "llvm.add"(%633, %631) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %645 = "llvm.add"(%644, %635) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %646 = "llvm.add"(%645, %637) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %647 = "llvm.and"(%643, %19) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %648 = "llvm.shufflevector"(%643, %646) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %649 = "llvm.shl"(%648, %18) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %650 = "llvm.add"(%649, %647) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %651 = "llvm.mul"(%648, %17) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %652 = "llvm.add"(%650, %651) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %653 = "llvm.and"(%652, %16) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %654 = "llvm.lshr"(%652, %15) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %655 = "llvm.shufflevector"(%654, %30) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %656 = "llvm.call_intrinsic"(%653, %14, %655) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %657 = "llvm.call_intrinsic"(%23, %605, %656) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %658 = "llvm.shl"(%657, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %659 = "llvm.call_intrinsic"(%658, %606, %656) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %660 = "llvm.call_intrinsic"(%23, %606, %656) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %661 = "llvm.shl"(%660, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %662 = "llvm.call_intrinsic"(%661, %607, %656) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %663 = "llvm.call_intrinsic"(%23, %607, %656) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %664 = "llvm.shl"(%663, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %665 = "llvm.call_intrinsic"(%664, %608, %656) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %666 = "llvm.call_intrinsic"(%23, %608, %656) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %667 = "llvm.shl"(%666, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %668 = "llvm.call_intrinsic"(%667, %609, %656) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %669 = "llvm.call_intrinsic"(%23, %609, %656) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %670 = "llvm.shl"(%669, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %671 = "llvm.call_intrinsic"(%670, %610, %656) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %672 = "llvm.call_intrinsic"(%23, %610, %656) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %673 = "llvm.shl"(%672, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %674 = "llvm.shufflevector"(%141, %659) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %675 = "llvm.shufflevector"(%77, %662) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %676 = "llvm.shufflevector"(%165, %665) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %677 = "llvm.shufflevector"(%665, %173) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %678 = "llvm.shufflevector"(%181, %668) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %679 = "llvm.shufflevector"(%668, %189) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %680 = "llvm.shufflevector"(%197, %671) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %681 = "llvm.shufflevector"(%671, %157) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %682 = "llvm.shufflevector"(%205, %673) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %683 = "llvm.shufflevector"(%673, %30) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %684 = "llvm.call_intrinsic"(%674, %605, %656) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %685 = "llvm.add"(%676, %675) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %686 = "llvm.add"(%685, %678) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %687 = "llvm.add"(%686, %680) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %688 = "llvm.add"(%687, %684) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %689 = "llvm.add"(%688, %682) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %690 = "llvm.add"(%679, %677) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %691 = "llvm.add"(%690, %681) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %692 = "llvm.add"(%691, %683) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %693 = "llvm.and"(%689, %19) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %694 = "llvm.shufflevector"(%689, %692) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %695 = "llvm.shl"(%694, %18) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %696 = "llvm.add"(%695, %693) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %697 = "llvm.mul"(%694, %17) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %698 = "llvm.add"(%696, %697) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %699 = "llvm.and"(%698, %16) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %700 = "llvm.lshr"(%698, %15) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %701 = "llvm.shufflevector"(%700, %30) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %702 = "llvm.call_intrinsic"(%699, %14, %701) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %703 = "llvm.shufflevector"(%702, %30) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %704 = "llvm.shufflevector"(%702, %30) <{mask = array<i32: 1, 1, 1, 1, 1, 1, 1, 1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %705 = "llvm.shufflevector"(%702, %30) <{mask = array<i32: 2, 2, 2, 2, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %706 = "llvm.shufflevector"(%702, %30) <{mask = array<i32: 3, 3, 3, 3, 3, 3, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %707 = "llvm.shufflevector"(%702, %30) <{mask = array<i32: 4, 4, 4, 4, 4, 4, 4, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %708 = "llvm.shufflevector"(%702, %30) <{mask = array<i32: 5, 5, 5, 5, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %709 = "llvm.call_intrinsic"(%23, %703, %550) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %710 = "llvm.shl"(%709, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %711 = "llvm.call_intrinsic"(%710, %704, %550) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %712 = "llvm.call_intrinsic"(%23, %704, %550) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %713 = "llvm.shl"(%712, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %714 = "llvm.call_intrinsic"(%713, %705, %550) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %715 = "llvm.call_intrinsic"(%23, %705, %550) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %716 = "llvm.shl"(%715, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %717 = "llvm.call_intrinsic"(%716, %706, %550) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %718 = "llvm.call_intrinsic"(%23, %706, %550) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %719 = "llvm.shl"(%718, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %720 = "llvm.call_intrinsic"(%719, %707, %550) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %721 = "llvm.call_intrinsic"(%23, %707, %550) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %722 = "llvm.shl"(%721, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %723 = "llvm.call_intrinsic"(%722, %708, %550) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %724 = "llvm.call_intrinsic"(%23, %708, %550) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %725 = "llvm.shl"(%724, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %726 = "llvm.shufflevector"(%141, %711) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %727 = "llvm.shufflevector"(%77, %714) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %728 = "llvm.shufflevector"(%165, %717) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %729 = "llvm.shufflevector"(%717, %173) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %730 = "llvm.shufflevector"(%181, %720) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %731 = "llvm.shufflevector"(%720, %189) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %732 = "llvm.shufflevector"(%197, %723) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %733 = "llvm.shufflevector"(%723, %157) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %734 = "llvm.shufflevector"(%205, %725) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %735 = "llvm.shufflevector"(%725, %30) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %736 = "llvm.call_intrinsic"(%726, %703, %550) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %737 = "llvm.add"(%728, %727) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %738 = "llvm.add"(%737, %730) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %739 = "llvm.add"(%738, %732) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %740 = "llvm.add"(%739, %736) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %741 = "llvm.add"(%740, %734) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %742 = "llvm.add"(%731, %729) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %743 = "llvm.add"(%742, %733) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %744 = "llvm.add"(%743, %735) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %745 = "llvm.and"(%741, %19) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %746 = "llvm.shufflevector"(%741, %744) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %747 = "llvm.shl"(%746, %18) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %748 = "llvm.add"(%747, %745) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %749 = "llvm.mul"(%746, %17) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %750 = "llvm.add"(%748, %749) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %751 = "llvm.and"(%750, %16) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %752 = "llvm.lshr"(%750, %15) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %753 = "llvm.shufflevector"(%752, %30) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %754 = "llvm.call_intrinsic"(%751, %14, %753) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %755 = "llvm.call_intrinsic"(%23, %3, %237) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %756 = "llvm.shl"(%755, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %757 = "llvm.call_intrinsic"(%756, %23, %237) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %758 = "llvm.call_intrinsic"(%23, %23, %237) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %759 = "llvm.shl"(%758, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %760 = "llvm.call_intrinsic"(%759, %23, %237) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %761 = "llvm.shufflevector"(%141, %757) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %762 = "llvm.shufflevector"(%77, %760) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %763 = "llvm.shufflevector"(%165, %760) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %764 = "llvm.shufflevector"(%760, %173) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %765 = "llvm.shufflevector"(%181, %760) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %766 = "llvm.shufflevector"(%760, %189) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %767 = "llvm.shufflevector"(%197, %760) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %768 = "llvm.shufflevector"(%760, %157) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %769 = "llvm.shufflevector"(%205, %759) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %770 = "llvm.shufflevector"(%759, %30) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %771 = "llvm.call_intrinsic"(%761, %3, %237) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %772 = "llvm.add"(%763, %762) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %773 = "llvm.add"(%772, %765) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %774 = "llvm.add"(%773, %767) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %775 = "llvm.add"(%774, %771) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %776 = "llvm.add"(%775, %769) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %777 = "llvm.add"(%766, %764) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %778 = "llvm.add"(%777, %768) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %779 = "llvm.add"(%778, %770) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %780 = "llvm.and"(%776, %19) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %781 = "llvm.shufflevector"(%776, %779) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %782 = "llvm.shl"(%781, %18) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %783 = "llvm.add"(%782, %780) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %784 = "llvm.mul"(%781, %17) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %785 = "llvm.add"(%783, %784) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %786 = "llvm.and"(%785, %16) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %787 = "llvm.lshr"(%785, %15) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %788 = "llvm.shufflevector"(%787, %30) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %789 = "llvm.call_intrinsic"(%786, %14, %788) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %790 = "llvm.shufflevector"(%789, %30) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %791 = "llvm.shufflevector"(%789, %30) <{mask = array<i32: 1, 1, 1, 1, 1, 1, 1, 1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %792 = "llvm.shufflevector"(%789, %30) <{mask = array<i32: 2, 2, 2, 2, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %793 = "llvm.shufflevector"(%789, %30) <{mask = array<i32: 3, 3, 3, 3, 3, 3, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %794 = "llvm.shufflevector"(%789, %30) <{mask = array<i32: 4, 4, 4, 4, 4, 4, 4, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %795 = "llvm.shufflevector"(%789, %30) <{mask = array<i32: 5, 5, 5, 5, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %796 = "llvm.call_intrinsic"(%23, %790, %656) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %797 = "llvm.shl"(%796, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %798 = "llvm.call_intrinsic"(%797, %791, %656) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %799 = "llvm.call_intrinsic"(%23, %791, %656) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %800 = "llvm.shl"(%799, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %801 = "llvm.call_intrinsic"(%800, %792, %656) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %802 = "llvm.call_intrinsic"(%23, %792, %656) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %803 = "llvm.shl"(%802, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %804 = "llvm.call_intrinsic"(%803, %793, %656) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %805 = "llvm.call_intrinsic"(%23, %793, %656) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %806 = "llvm.shl"(%805, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %807 = "llvm.call_intrinsic"(%806, %794, %656) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %808 = "llvm.call_intrinsic"(%23, %794, %656) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %809 = "llvm.shl"(%808, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %810 = "llvm.call_intrinsic"(%809, %795, %656) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %811 = "llvm.call_intrinsic"(%23, %795, %656) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %812 = "llvm.shl"(%811, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %813 = "llvm.shufflevector"(%141, %798) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %814 = "llvm.shufflevector"(%77, %801) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %815 = "llvm.shufflevector"(%165, %804) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %816 = "llvm.shufflevector"(%804, %173) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %817 = "llvm.shufflevector"(%181, %807) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %818 = "llvm.shufflevector"(%807, %189) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %819 = "llvm.shufflevector"(%197, %810) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %820 = "llvm.shufflevector"(%810, %157) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %821 = "llvm.shufflevector"(%205, %812) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %822 = "llvm.shufflevector"(%812, %30) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %823 = "llvm.call_intrinsic"(%813, %790, %656) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %824 = "llvm.add"(%815, %814) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %825 = "llvm.add"(%824, %817) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %826 = "llvm.add"(%825, %819) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %827 = "llvm.add"(%826, %823) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %828 = "llvm.add"(%827, %821) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %829 = "llvm.add"(%818, %816) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %830 = "llvm.add"(%829, %820) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %831 = "llvm.add"(%830, %822) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %832 = "llvm.and"(%828, %19) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %833 = "llvm.shufflevector"(%828, %831) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %834 = "llvm.shl"(%833, %18) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %835 = "llvm.add"(%834, %832) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %836 = "llvm.mul"(%833, %17) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %837 = "llvm.add"(%835, %836) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %838 = "llvm.and"(%837, %16) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %839 = "llvm.lshr"(%837, %15) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %840 = "llvm.shufflevector"(%839, %30) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %841 = "llvm.call_intrinsic"(%838, %14, %840) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %842 = "llvm.sub"(%7, %841) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %843 = "llvm.and"(%842, %16) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %844 = "llvm.ashr"(%842, %15) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %845 = "llvm.shufflevector"(%844, %157) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 8, 8>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %846 = "llvm.mul"(%845, %12) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %847 = "llvm.and"(%846, %11) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %848 = "llvm.add"(%843, %10) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %849 = "llvm.add"(%848, %845) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %850 = "llvm.add"(%849, %847) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %851 = "llvm.extractelement"(%841, %46) : (vector<8xi64>, i64) -> i64
  %852 = "llvm.extractelement"(%841, %51) : (vector<8xi64>, i64) -> i64
  %853 = "llvm.extractelement"(%841, %52) : (vector<8xi64>, i64) -> i64
  %854 = "llvm.extractelement"(%841, %53) : (vector<8xi64>, i64) -> i64
  %855 = "llvm.extractelement"(%841, %54) : (vector<8xi64>, i64) -> i64
  %856 = "llvm.extractelement"(%841, %55) : (vector<8xi64>, i64) -> i64
  %857 = "llvm.and"(%851, %61) : (i64, i64) -> i64
  %858 = "llvm.ashr"(%856, %56) : (i64, i64) -> i64
  %859 = "llvm.and"(%852, %61) : (i64, i64) -> i64
  %860 = "llvm.ashr"(%851, %60) : (i64, i64) -> i64
  %861 = "llvm.add"(%859, %860) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %862 = "llvm.and"(%853, %61) : (i64, i64) -> i64
  %863 = "llvm.ashr"(%852, %60) : (i64, i64) -> i64
  %864 = "llvm.add"(%862, %863) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %865 = "llvm.and"(%854, %61) : (i64, i64) -> i64
  %866 = "llvm.ashr"(%853, %60) : (i64, i64) -> i64
  %867 = "llvm.add"(%865, %866) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %868 = "llvm.and"(%855, %61) : (i64, i64) -> i64
  %869 = "llvm.ashr"(%854, %60) : (i64, i64) -> i64
  %870 = "llvm.add"(%868, %869) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %871 = "llvm.and"(%856, %57) : (i64, i64) -> i64
  %872 = "llvm.ashr"(%855, %60) : (i64, i64) -> i64
  %873 = "llvm.add"(%872, %58) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %874 = "llvm.add"(%873, %871) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %875 = "llvm.ashr"(%874, %56) : (i64, i64) -> i64
  %876 = "llvm.and"(%874, %57) : (i64, i64) -> i64
  %877 = "llvm.add"(%875, %858) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %878 = "llvm.mul"(%877, %59) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %879 = "llvm.add"(%878, %857) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %880 = "llvm.ashr"(%879, %60) : (i64, i64) -> i64
  %881 = "llvm.and"(%879, %61) : (i64, i64) -> i64
  %882 = "llvm.add"(%861, %880) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %883 = "llvm.ashr"(%882, %60) : (i64, i64) -> i64
  %884 = "llvm.and"(%882, %61) : (i64, i64) -> i64
  %885 = "llvm.add"(%864, %883) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %886 = "llvm.ashr"(%885, %60) : (i64, i64) -> i64
  %887 = "llvm.and"(%885, %61) : (i64, i64) -> i64
  %888 = "llvm.add"(%867, %886) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %889 = "llvm.ashr"(%888, %60) : (i64, i64) -> i64
  %890 = "llvm.and"(%888, %61) : (i64, i64) -> i64
  %891 = "llvm.add"(%870, %889) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %892 = "llvm.ashr"(%891, %60) : (i64, i64) -> i64
  %893 = "llvm.and"(%891, %61) : (i64, i64) -> i64
  %894 = "llvm.add"(%881, %59) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %895 = "llvm.lshr"(%894, %60) : (i64, i64) -> i64
  %896 = "llvm.and"(%894, %61) : (i64, i64) -> i64
  %897 = "llvm.add"(%884, %895) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %898 = "llvm.lshr"(%897, %60) : (i64, i64) -> i64
  %899 = "llvm.and"(%897, %61) : (i64, i64) -> i64
  %900 = "llvm.add"(%887, %898) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %901 = "llvm.lshr"(%900, %60) : (i64, i64) -> i64
  %902 = "llvm.and"(%900, %61) : (i64, i64) -> i64
  %903 = "llvm.add"(%890, %901) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %904 = "llvm.lshr"(%903, %60) : (i64, i64) -> i64
  %905 = "llvm.and"(%903, %61) : (i64, i64) -> i64
  %906 = "llvm.add"(%893, %904) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %907 = "llvm.lshr"(%906, %60) : (i64, i64) -> i64
  %908 = "llvm.and"(%906, %61) : (i64, i64) -> i64
  %909 = "llvm.add"(%876, %51) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %910 = "llvm.add"(%909, %892) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %911 = "llvm.add"(%910, %907) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %912 = "llvm.and"(%911, %57) : (i64, i64) -> i64
  %913 = "llvm.icmp"(%911, %62) <{predicate = 6 : i64}> : (i64, i64) -> i1
  %914 = "llvm.select"(%913, %63, %46) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %915 = "llvm.add"(%914, %896) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %916 = "llvm.ashr"(%915, %60) : (i64, i64) -> i64
  %917 = "llvm.add"(%916, %899) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %918 = "llvm.ashr"(%917, %60) : (i64, i64) -> i64
  %919 = "llvm.add"(%918, %902) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %920 = "llvm.ashr"(%919, %60) : (i64, i64) -> i64
  %921 = "llvm.add"(%920, %905) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %922 = "llvm.ashr"(%921, %60) : (i64, i64) -> i64
  %923 = "llvm.insertelement"(%45, %915, %46) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %924 = "llvm.insertelement"(%923, %917, %51) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %925 = "llvm.insertelement"(%924, %919, %52) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %926 = "llvm.insertelement"(%925, %921, %53) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %927 = "llvm.and"(%926, %64) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %928 = "llvm.add"(%922, %908) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %929 = "llvm.ashr"(%928, %60) : (i64, i64) -> i64
  %930 = "llvm.add"(%929, %912) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %931 = "llvm.insertelement"(%65, %928, %46) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  %932 = "llvm.insertelement"(%931, %930, %51) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  %933 = "llvm.and"(%932, %66) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %934 = "llvm.shufflevector"(%927, %45) <{mask = array<i32: 0, 1, 2, 3, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %935 = "llvm.shufflevector"(%934, %77) <{mask = array<i32: 0, 1, 2, 3, -1, -1, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %936 = "llvm.shufflevector"(%933, %65) <{mask = array<i32: 0, 1, -1, -1, -1, -1, -1, -1>}> : (vector<2xi64>, vector<2xi64>) -> vector<8xi64>
  %937 = "llvm.shufflevector"(%935, %936) <{mask = array<i32: 0, 1, 2, 3, 8, 9, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %938 = "llvm.lshr"(%937, %85) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %939 = "llvm.shl"(%927, %209) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %940 = "llvm.shufflevector"(%939, %45) <{mask = array<i32: 1, -1, -1, -1, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %941 = "llvm.shl"(%927, %209) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %942 = "llvm.shufflevector"(%941, %45) <{mask = array<i32: 1, -1, -1, -1, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %943 = "llvm.or"(%940, %938) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %944 = "llvm.or"(%943, %942) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %945 = "llvm.bitcast"(%944) : (vector<8xi64>) -> vector<64xi8>
  %946 = "llvm.extractelement"(%945, %46) : (vector<64xi8>, i64) -> i8
  %947 = "llvm.and"(%946, %29) : (i8, i8) -> i8
  %948 = "llvm.add"(%947, %1) <{overflowFlags = 1 : i32}> : (i8, i8) -> i8
  %949 = "llvm.bitcast"(%948) : (i8) -> vector<8xi1>
  %950 = "llvm.select"(%949, %841, %850) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %951 = "llvm.shufflevector"(%381, %30) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %952 = "llvm.shufflevector"(%381, %30) <{mask = array<i32: 1, 1, 1, 1, 1, 1, 1, 1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %953 = "llvm.shufflevector"(%381, %30) <{mask = array<i32: 2, 2, 2, 2, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %954 = "llvm.shufflevector"(%381, %30) <{mask = array<i32: 3, 3, 3, 3, 3, 3, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %955 = "llvm.shufflevector"(%381, %30) <{mask = array<i32: 4, 4, 4, 4, 4, 4, 4, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %956 = "llvm.shufflevector"(%381, %30) <{mask = array<i32: 5, 5, 5, 5, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %957 = "llvm.call_intrinsic"(%23, %951, %754) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %958 = "llvm.shl"(%957, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %959 = "llvm.call_intrinsic"(%958, %952, %754) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %960 = "llvm.call_intrinsic"(%23, %952, %754) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %961 = "llvm.shl"(%960, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %962 = "llvm.call_intrinsic"(%961, %953, %754) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %963 = "llvm.call_intrinsic"(%23, %953, %754) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %964 = "llvm.shl"(%963, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %965 = "llvm.call_intrinsic"(%964, %954, %754) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %966 = "llvm.call_intrinsic"(%23, %954, %754) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %967 = "llvm.shl"(%966, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %968 = "llvm.call_intrinsic"(%967, %955, %754) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %969 = "llvm.call_intrinsic"(%23, %955, %754) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %970 = "llvm.shl"(%969, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %971 = "llvm.call_intrinsic"(%970, %956, %754) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %972 = "llvm.call_intrinsic"(%23, %956, %754) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %973 = "llvm.shl"(%972, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %974 = "llvm.shufflevector"(%141, %959) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %975 = "llvm.shufflevector"(%77, %962) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %976 = "llvm.shufflevector"(%165, %965) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %977 = "llvm.shufflevector"(%965, %173) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %978 = "llvm.shufflevector"(%181, %968) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %979 = "llvm.shufflevector"(%968, %189) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %980 = "llvm.shufflevector"(%197, %971) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %981 = "llvm.shufflevector"(%971, %157) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %982 = "llvm.shufflevector"(%205, %973) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %983 = "llvm.shufflevector"(%973, %30) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %984 = "llvm.call_intrinsic"(%974, %951, %754) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %985 = "llvm.add"(%976, %975) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %986 = "llvm.add"(%985, %978) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %987 = "llvm.add"(%986, %980) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %988 = "llvm.add"(%987, %984) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %989 = "llvm.add"(%988, %982) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %990 = "llvm.add"(%979, %977) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %991 = "llvm.add"(%990, %981) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %992 = "llvm.add"(%991, %983) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %993 = "llvm.and"(%989, %19) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %994 = "llvm.shufflevector"(%989, %992) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %995 = "llvm.shl"(%994, %18) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %996 = "llvm.add"(%995, %993) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %997 = "llvm.mul"(%994, %17) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %998 = "llvm.add"(%996, %997) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %999 = "llvm.and"(%998, %16) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1000 = "llvm.lshr"(%998, %15) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1001 = "llvm.shufflevector"(%1000, %30) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1002 = "llvm.call_intrinsic"(%999, %14, %1001) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1003 = "llvm.shufflevector"(%950, %30) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1004 = "llvm.shufflevector"(%950, %30) <{mask = array<i32: 1, 1, 1, 1, 1, 1, 1, 1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1005 = "llvm.shufflevector"(%950, %30) <{mask = array<i32: 2, 2, 2, 2, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1006 = "llvm.shufflevector"(%950, %30) <{mask = array<i32: 3, 3, 3, 3, 3, 3, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1007 = "llvm.shufflevector"(%950, %30) <{mask = array<i32: 4, 4, 4, 4, 4, 4, 4, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1008 = "llvm.shufflevector"(%950, %30) <{mask = array<i32: 5, 5, 5, 5, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1009 = "llvm.call_intrinsic"(%23, %1003, %1002) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1010 = "llvm.shl"(%1009, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1011 = "llvm.call_intrinsic"(%1010, %1004, %1002) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1012 = "llvm.call_intrinsic"(%23, %1004, %1002) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1013 = "llvm.shl"(%1012, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1014 = "llvm.call_intrinsic"(%1013, %1005, %1002) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1015 = "llvm.call_intrinsic"(%23, %1005, %1002) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1016 = "llvm.shl"(%1015, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1017 = "llvm.call_intrinsic"(%1016, %1006, %1002) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1018 = "llvm.call_intrinsic"(%23, %1006, %1002) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1019 = "llvm.shl"(%1018, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1020 = "llvm.call_intrinsic"(%1019, %1007, %1002) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1021 = "llvm.call_intrinsic"(%23, %1007, %1002) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1022 = "llvm.shl"(%1021, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1023 = "llvm.call_intrinsic"(%1022, %1008, %1002) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1024 = "llvm.call_intrinsic"(%23, %1008, %1002) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1025 = "llvm.shl"(%1024, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1026 = "llvm.shufflevector"(%141, %1011) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1027 = "llvm.shufflevector"(%77, %1014) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1028 = "llvm.shufflevector"(%165, %1017) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1029 = "llvm.shufflevector"(%1017, %173) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1030 = "llvm.shufflevector"(%181, %1020) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1031 = "llvm.shufflevector"(%1020, %189) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1032 = "llvm.shufflevector"(%197, %1023) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1033 = "llvm.shufflevector"(%1023, %157) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1034 = "llvm.shufflevector"(%205, %1025) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1035 = "llvm.shufflevector"(%1025, %30) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1036 = "llvm.call_intrinsic"(%1026, %1003, %1002) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1037 = "llvm.add"(%1028, %1027) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1038 = "llvm.add"(%1037, %1030) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1039 = "llvm.add"(%1038, %1032) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1040 = "llvm.add"(%1039, %1036) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1041 = "llvm.add"(%1040, %1034) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1042 = "llvm.add"(%1031, %1029) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1043 = "llvm.add"(%1042, %1033) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1044 = "llvm.add"(%1043, %1035) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1045 = "llvm.and"(%1041, %19) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1046 = "llvm.shufflevector"(%1041, %1044) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1047 = "llvm.shl"(%1046, %18) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1048 = "llvm.add"(%1047, %1045) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1049 = "llvm.mul"(%1046, %17) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1050 = "llvm.add"(%1048, %1049) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1051 = "llvm.and"(%1050, %16) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1052 = "llvm.lshr"(%1050, %15) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1053 = "llvm.shufflevector"(%1052, %30) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1054 = "llvm.call_intrinsic"(%1051, %14, %1053) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1055 = "llvm.icmp"(%603, %69) <{predicate = 0 : i64}> : (i32, i32) -> i1
  %1056 = "llvm.extractelement"(%1054, %46) : (vector<8xi64>, i64) -> i64
  %1057 = "llvm.extractelement"(%1054, %51) : (vector<8xi64>, i64) -> i64
  %1058 = "llvm.extractelement"(%1054, %52) : (vector<8xi64>, i64) -> i64
  %1059 = "llvm.extractelement"(%1054, %53) : (vector<8xi64>, i64) -> i64
  %1060 = "llvm.extractelement"(%1054, %54) : (vector<8xi64>, i64) -> i64
  %1061 = "llvm.extractelement"(%1054, %55) : (vector<8xi64>, i64) -> i64
  %1062 = "llvm.and"(%1056, %61) : (i64, i64) -> i64
  %1063 = "llvm.ashr"(%1061, %56) : (i64, i64) -> i64
  %1064 = "llvm.and"(%1057, %61) : (i64, i64) -> i64
  %1065 = "llvm.ashr"(%1056, %60) : (i64, i64) -> i64
  %1066 = "llvm.add"(%1064, %1065) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1067 = "llvm.and"(%1058, %61) : (i64, i64) -> i64
  %1068 = "llvm.ashr"(%1057, %60) : (i64, i64) -> i64
  %1069 = "llvm.add"(%1067, %1068) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1070 = "llvm.and"(%1059, %61) : (i64, i64) -> i64
  %1071 = "llvm.ashr"(%1058, %60) : (i64, i64) -> i64
  %1072 = "llvm.add"(%1070, %1071) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1073 = "llvm.and"(%1060, %61) : (i64, i64) -> i64
  %1074 = "llvm.ashr"(%1059, %60) : (i64, i64) -> i64
  %1075 = "llvm.add"(%1073, %1074) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1076 = "llvm.and"(%1061, %57) : (i64, i64) -> i64
  %1077 = "llvm.ashr"(%1060, %60) : (i64, i64) -> i64
  %1078 = "llvm.add"(%1077, %58) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1079 = "llvm.add"(%1078, %1076) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1080 = "llvm.ashr"(%1079, %56) : (i64, i64) -> i64
  %1081 = "llvm.and"(%1079, %57) : (i64, i64) -> i64
  %1082 = "llvm.add"(%1080, %1063) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1083 = "llvm.mul"(%1082, %59) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1084 = "llvm.add"(%1083, %1062) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1085 = "llvm.ashr"(%1084, %60) : (i64, i64) -> i64
  %1086 = "llvm.and"(%1084, %61) : (i64, i64) -> i64
  %1087 = "llvm.add"(%1066, %1085) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1088 = "llvm.ashr"(%1087, %60) : (i64, i64) -> i64
  %1089 = "llvm.and"(%1087, %61) : (i64, i64) -> i64
  %1090 = "llvm.add"(%1069, %1088) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1091 = "llvm.ashr"(%1090, %60) : (i64, i64) -> i64
  %1092 = "llvm.and"(%1090, %61) : (i64, i64) -> i64
  %1093 = "llvm.add"(%1072, %1091) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1094 = "llvm.ashr"(%1093, %60) : (i64, i64) -> i64
  %1095 = "llvm.and"(%1093, %61) : (i64, i64) -> i64
  %1096 = "llvm.add"(%1075, %1094) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1097 = "llvm.ashr"(%1096, %60) : (i64, i64) -> i64
  %1098 = "llvm.and"(%1096, %61) : (i64, i64) -> i64
  %1099 = "llvm.add"(%1086, %59) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1100 = "llvm.lshr"(%1099, %60) : (i64, i64) -> i64
  %1101 = "llvm.and"(%1099, %61) : (i64, i64) -> i64
  %1102 = "llvm.add"(%1089, %1100) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1103 = "llvm.lshr"(%1102, %60) : (i64, i64) -> i64
  %1104 = "llvm.and"(%1102, %61) : (i64, i64) -> i64
  %1105 = "llvm.add"(%1092, %1103) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1106 = "llvm.lshr"(%1105, %60) : (i64, i64) -> i64
  %1107 = "llvm.and"(%1105, %61) : (i64, i64) -> i64
  %1108 = "llvm.add"(%1095, %1106) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1109 = "llvm.lshr"(%1108, %60) : (i64, i64) -> i64
  %1110 = "llvm.and"(%1108, %61) : (i64, i64) -> i64
  %1111 = "llvm.add"(%1098, %1109) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1112 = "llvm.lshr"(%1111, %60) : (i64, i64) -> i64
  %1113 = "llvm.and"(%1111, %61) : (i64, i64) -> i64
  %1114 = "llvm.add"(%1081, %51) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1115 = "llvm.add"(%1114, %1097) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1116 = "llvm.add"(%1115, %1112) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1117 = "llvm.and"(%1116, %57) : (i64, i64) -> i64
  %1118 = "llvm.icmp"(%1116, %62) <{predicate = 6 : i64}> : (i64, i64) -> i1
  %1119 = "llvm.select"(%1118, %63, %46) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %1120 = "llvm.add"(%1119, %1101) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1121 = "llvm.ashr"(%1120, %60) : (i64, i64) -> i64
  %1122 = "llvm.add"(%1121, %1104) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1123 = "llvm.ashr"(%1122, %60) : (i64, i64) -> i64
  %1124 = "llvm.add"(%1123, %1107) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1125 = "llvm.ashr"(%1124, %60) : (i64, i64) -> i64
  %1126 = "llvm.add"(%1125, %1110) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1127 = "llvm.ashr"(%1126, %60) : (i64, i64) -> i64
  %1128 = "llvm.insertelement"(%45, %1120, %46) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1129 = "llvm.insertelement"(%1128, %1122, %51) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1130 = "llvm.insertelement"(%1129, %1124, %52) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1131 = "llvm.insertelement"(%1130, %1126, %53) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1132 = "llvm.and"(%1131, %64) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1133 = "llvm.add"(%1127, %1113) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1134 = "llvm.ashr"(%1133, %60) : (i64, i64) -> i64
  %1135 = "llvm.add"(%1134, %1117) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1136 = "llvm.insertelement"(%65, %1133, %46) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  %1137 = "llvm.insertelement"(%1136, %1135, %51) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  %1138 = "llvm.and"(%1137, %66) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1139 = "llvm.shufflevector"(%1132, %45) <{mask = array<i32: 0, 1, 2, 3, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %1140 = "llvm.shufflevector"(%1139, %77) <{mask = array<i32: 0, 1, 2, 3, -1, -1, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1141 = "llvm.shufflevector"(%1138, %65) <{mask = array<i32: 0, 1, -1, -1, -1, -1, -1, -1>}> : (vector<2xi64>, vector<2xi64>) -> vector<8xi64>
  %1142 = "llvm.shufflevector"(%1140, %1141) <{mask = array<i32: 0, 1, 2, 3, 8, 9, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1143 = "llvm.lshr"(%1142, %85) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1144 = "llvm.shl"(%1132, %209) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1145 = "llvm.shufflevector"(%1144, %45) <{mask = array<i32: 1, -1, -1, -1, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %1146 = "llvm.shl"(%1132, %209) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1147 = "llvm.shufflevector"(%1146, %45) <{mask = array<i32: 1, -1, -1, -1, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %1148 = "llvm.or"(%1145, %1143) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1149 = "llvm.or"(%1148, %1147) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1150 = "llvm.bitcast"(%1149) : (vector<8xi64>) -> vector<64xi8>
  %1151 = "llvm.extractelement"(%1150, %46) : (vector<64xi8>, i64) -> i8
  %1152 = "llvm.and"(%1151, %29) : (i8, i8) -> i8
  %1153 = "llvm.icmp"(%1002, %23) <{predicate = 1 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %1154 = "llvm.bitcast"(%1153) : (vector<8xi1>) -> i8
  %1155 = "llvm.icmp"(%1154, %28) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %1156 = "llvm.icmp"(%1002, %6) <{predicate = 1 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %1157 = "llvm.bitcast"(%1156) : (vector<8xi1>) -> i8
  %1158 = "llvm.icmp"(%1157, %28) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %1159 = "llvm.select"(%1155, %0, %1158) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i1, i1) -> i1
  %1160 = "llvm.or"(%1159, %1055) : (i1, i1) -> i1
  %1161 = "llvm.zext"(%1160) : (i1) -> i8
  %1162 = "llvm.or"(%1152, %1161) : (i8, i8) -> i8
  %1163 = "llvm.icmp"(%1162, %28) <{predicate = 0 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%1163, %27)[^bb2, ^bb3] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, !llvm.ptr) -> ()
^bb2:  // pred: ^bb1
  %1164 = "llvm.shufflevector"(%950, %217) <{mask = array<i32: 0, 1, 8, 9, 4, 5, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1165 = "llvm.shufflevector"(%1002, %1054) <{mask = array<i32: 0, 1, 8, 9, 4, 5, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1166 = "llvm.shufflevector"(%950, %225) <{mask = array<i32: 2, 3, 10, 11, 6, 7, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1167 = "llvm.shufflevector"(%1002, %1054) <{mask = array<i32: 2, 3, 10, 11, 6, 7, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1168 = "llvm.shufflevector"(%1164, %1165) <{mask = array<i32: 0, 8, 2, 10, -1, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1169 = "llvm.shufflevector"(%1164, %1165) <{mask = array<i32: -1, -1, -1, -1, 5, 13, 7, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1170 = "llvm.shufflevector"(%1166, %1167) <{mask = array<i32: 0, 8, 2, 10, -1, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1171 = "llvm.shufflevector"(%1166, %1167) <{mask = array<i32: 1, 9, 3, 11, -1, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1172 = "llvm.shufflevector"(%1168, %1171) <{mask = array<i32: 0, 1, 2, 3, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1172, %arg0) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1173 = "llvm.shufflevector"(%1164, %1165) <{mask = array<i32: 1, 9, 3, 11, 4, 12, 6, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1174 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1173, %1174) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1175 = "llvm.shufflevector"(%1170, %1169) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1176 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1175, %1176) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.br"(%arg0)[^bb3] : (!llvm.ptr) -> ()
^bb3(%1177: !llvm.ptr):  // 2 preds: ^bb1, ^bb2
  "llvm.intr.lifetime.end"(%228) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%227) : (!llvm.ptr) -> ()
  "llvm.br"(%1177)[^bb4] : (!llvm.ptr) -> ()
^bb4(%1178: !llvm.ptr):  // 2 preds: ^bb0, ^bb3
  "llvm.intr.lifetime.end"(%226) : (!llvm.ptr) -> ()
  "llvm.return"(%1178) : (!llvm.ptr) -> ()
}) : () -> ()

    with
      @fd_f25519_one.28 := Firedancer.Lane.Mlir.fd_f25519_one_28,
      @fd_f25519_sqrt_ratio := Firedancer.Lane.Mlir.fd_f25519_sqrt_ratio

end

end Firedancer.Lane.Mlir
