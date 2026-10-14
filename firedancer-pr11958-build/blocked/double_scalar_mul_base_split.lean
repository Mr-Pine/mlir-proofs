
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.Lane.Mlir.fd_ed25519_base_point_wnaf_table
public import Firedancer.Lane.Mlir.fd_curve25519_scalar_wnaf
public import Firedancer.Lane.Mlir.fd_curve25519_scalar_wnaf
public import Firedancer.Lane.Mlir.fd_ed25519_partial_dbl
public import Firedancer.Lane.Mlir.fd_r43x6_ge_decode_step_slow
public import Firedancer.Lane.Mlir.fd_r43x6_ge_decode_step_slow
public import Firedancer.Lane.Mlir.fd_r43x6_ge_decode_step_slow
public import Firedancer.Lane.Mlir.fd_r43x6_ge_decode_step_slow
public import Firedancer.Lane.Mlir.fd_r43x6_ge_decode_step_slow

namespace Firedancer.Lane.Mlir

@[expose] public section

noncomputable mlir_def double_scalar_mul_base_split := "llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nofree, llvm.noundef, llvm.returned}, {llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<ptr (ptr, ptr, ptr, ptr, ptr, ptr)>, inline_hint, linkage = #llvm.linkage<internal>, no_unwind, passthrough = ["sspstrong", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], res_attrs = [{llvm.noundef}], sym_name = "double_scalar_mul_base_split", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: !llvm.ptr, %arg3: !llvm.ptr, %arg4: !llvm.ptr, %arg5: !llvm.ptr):
  %0 = "llvm.mlir.constant"() <{value = -2 : i64}> : () -> i64
  %1 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %2 = "llvm.mlir.constant"() <{value = dense<[8796093022207, 8796093022207, 8796093022207, 8796093022207, 1099511627775, 1099511627775, 1099511627775, 1099511627775]> : vector<8xi64>}> : () -> vector<8xi64>
  %3 = "llvm.mlir.constant"() <{value = dense<1048576> : vector<8xi64>}> : () -> vector<8xi64>
  %4 = "llvm.mlir.constant"() <{value = dense<[159383552, 159383552, 159383552, 159383552, 1048576, 1048576, 1048576, 1048576]> : vector<8xi64>}> : () -> vector<8xi64>
  %5 = "llvm.mlir.constant"() <{value = dense<8796093022207> : vector<8xi64>}> : () -> vector<8xi64>
  %6 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %7 = "llvm.mlir.constant"() <{value = dense<[43, 43, 43, 43, 40, 40, 40, 40]> : vector<8xi64>}> : () -> vector<8xi64>
  %8 = "llvm.mlir.constant"() <{value = dense<43> : vector<8xi64>}> : () -> vector<8xi64>
  %9 = "llvm.mlir.constant"() <{value = dense<-1048576> : vector<8xi64>}> : () -> vector<8xi64>
  %10 = "llvm.mlir.constant"() <{value = dense<[-159383552, -159383552, -159383552, -159383552, -1048576, -1048576, -1048576, -1048576]> : vector<8xi64>}> : () -> vector<8xi64>
  %11 = "llvm.mlir.constant"() <{value = 1099511627775 : i64}> : () -> i64
  %12 = "llvm.mlir.constant"() <{value = 8796093022189 : i64}> : () -> i64
  %13 = "llvm.mlir.constant"() <{value = 8796093022207 : i64}> : () -> i64
  %14 = "llvm.mlir.constant"() <{value = 2199023255550 : i64}> : () -> i64
  %15 = "llvm.mlir.constant"() <{value = 17592186044378 : i64}> : () -> i64
  %16 = "llvm.mlir.constant"() <{value = 17592186044414 : i64}> : () -> i64
  %17 = "llvm.mlir.constant"() <{value = 5 : i64}> : () -> i64
  %18 = "llvm.mlir.constant"() <{value = 12 : i64}> : () -> i64
  %19 = "llvm.mlir.constant"() <{value = -3 : i64}> : () -> i64
  %20 = "llvm.mlir.constant"() <{value = dense<[19, 1, 1, 1, 1, 1, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %21 = "llvm.mlir.constant"() <{value = dense<[43, 43, 43, 43, 43, 40, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %22 = "llvm.mlir.constant"() <{value = dense<[8796093022207, 8796093022207, 8796093022207, 8796093022207, 8796093022207, 1099511627775, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %23 = "llvm.mlir.constant"() <{value = dense<24> : vector<8xi64>}> : () -> vector<8xi64>
  %24 = "llvm.mlir.constant"() <{value = dense<7> : vector<8xi64>}> : () -> vector<8xi64>
  %25 = "llvm.mlir.constant"() <{value = dense<[-1, -1, -1, -1, -1, -1, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %26 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %27 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %28 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %29 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %30 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %31 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %32 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %33 = "llvm.mlir.constant"() <{value = 8 : i32}> : () -> i32
  %34 = "llvm.mlir.addressof"() <{global_name = @fd_ed25519_base_point_wnaf_table}> : () -> !llvm.ptr
  %35 = "llvm.mlir.constant"() <{value = 8 : i64}> : () -> i64
  %36 = "llvm.mlir.constant"() <{value = dense<[24576, 49152, 73728, 98304]> : vector<4xi64>}> : () -> vector<4xi64>
  %37 = "llvm.mlir.constant"() <{value = dense<[0, 1, 1, 0, 0, 0, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %38 = "llvm.mlir.constant"() <{value = 64 : i64}> : () -> i64
  %39 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %40 = "llvm.mlir.constant"() <{value = 128 : i64}> : () -> i64
  %41 = "llvm.mlir.constant"() <{value = 31 : i64}> : () -> i64
  %42 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %43 = "llvm.mlir.constant"() <{value = 96 : i64}> : () -> i64
  %44 = "llvm.mlir.constant"() <{value = 160 : i64}> : () -> i64
  %45 = "llvm.mlir.constant"() <{value = 192 : i64}> : () -> i64
  %46 = "llvm.mlir.constant"() <{value = 224 : i64}> : () -> i64
  %47 = "llvm.mlir.constant"() <{value = 0 : i16}> : () -> i16
  %48 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %49 = "llvm.mlir.constant"() <{value = 63 : i64}> : () -> i64
  %50 = "llvm.mlir.constant"() <{value = 95 : i64}> : () -> i64
  %51 = "llvm.mlir.constant"() <{value = 127 : i64}> : () -> i64
  %52 = "llvm.mlir.constant"() <{value = 159 : i64}> : () -> i64
  %53 = "llvm.mlir.constant"() <{value = 191 : i64}> : () -> i64
  %54 = "llvm.mlir.constant"() <{value = 223 : i64}> : () -> i64
  %55 = "llvm.mlir.zero"() : () -> !llvm.ptr
  %56 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %57 = "llvm.mlir.poison"() : () -> vector<8xi64>
  %58 = "llvm.mlir.constant"() <{value = dense<[0, 1, 1, 1, 1, 1, 0, 1]> : vector<8xi64>}> : () -> vector<8xi64>
  %59 = "llvm.mlir.constant"() <{value = dense<[0, 1, 0, 1, 1, 1, 1, 1]> : vector<8xi64>}> : () -> vector<8xi64>
  %60 = "llvm.mlir.constant"() <{value = dense<[1, 1, 0, 1, 0, 1, 1, 1]> : vector<8xi64>}> : () -> vector<8xi64>
  %61 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %62 = "llvm.mlir.constant"() <{value = dense<0> : vector<8xi64>}> : () -> vector<8xi64>
  %63 = "llvm.mlir.constant"() <{value = dense<9> : vector<8xi64>}> : () -> vector<8xi64>
  %64 = "llvm.mlir.constant"() <{value = dense<[0, 0, -1, -1, -1, -1, -1, -1]> : vector<8xi64>}> : () -> vector<8xi64>
  %65 = "llvm.mlir.constant"() <{value = dense<[0, -1, 0, -1, -1, -1, -1, -1]> : vector<8xi64>}> : () -> vector<8xi64>
  %66 = "llvm.mlir.poison"() : () -> i64
  %67 = "llvm.mlir.undef"() : () -> vector<8xi64>
  %68 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %69 = "llvm.insertelement"(%67, %48, %68) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %70 = "llvm.insertelement"(%69, %48, %31) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %71 = "llvm.insertelement"(%70, %61, %30) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %72 = "llvm.insertelement"(%71, %61, %32) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %73 = "llvm.insertelement"(%72, %61, %29) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %74 = "llvm.insertelement"(%73, %61, %28) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %75 = "llvm.insertelement"(%74, %66, %27) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %76 = "llvm.insertelement"(%75, %66, %26) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %77 = "llvm.insertelement"(%67, %48, %68) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %78 = "llvm.insertelement"(%77, %61, %31) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %79 = "llvm.insertelement"(%78, %48, %30) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %80 = "llvm.insertelement"(%79, %61, %32) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %81 = "llvm.insertelement"(%80, %61, %29) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %82 = "llvm.insertelement"(%81, %61, %28) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %83 = "llvm.insertelement"(%82, %66, %27) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %84 = "llvm.insertelement"(%83, %66, %26) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %85 = "llvm.insertelement"(%67, %48, %68) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %86 = "llvm.insertelement"(%85, %48, %31) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %87 = "llvm.insertelement"(%86, %61, %30) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %88 = "llvm.insertelement"(%87, %61, %32) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %89 = "llvm.insertelement"(%88, %61, %29) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %90 = "llvm.insertelement"(%89, %66, %28) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %91 = "llvm.insertelement"(%90, %66, %27) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %92 = "llvm.insertelement"(%91, %66, %26) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %93 = "llvm.insertelement"(%67, %48, %68) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %94 = "llvm.insertelement"(%93, %61, %31) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %95 = "llvm.insertelement"(%94, %48, %30) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %96 = "llvm.insertelement"(%95, %61, %32) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %97 = "llvm.insertelement"(%96, %61, %29) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %98 = "llvm.insertelement"(%97, %66, %28) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %99 = "llvm.insertelement"(%98, %66, %27) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %100 = "llvm.insertelement"(%99, %66, %26) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %101 = "llvm.insertelement"(%67, %66, %68) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %102 = "llvm.insertelement"(%101, %66, %31) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %103 = "llvm.insertelement"(%102, %66, %30) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %104 = "llvm.insertelement"(%103, %66, %32) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %105 = "llvm.insertelement"(%104, %66, %29) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %106 = "llvm.insertelement"(%105, %66, %28) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %107 = "llvm.insertelement"(%106, %66, %27) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %108 = "llvm.insertelement"(%107, %61, %26) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %109 = "llvm.insertelement"(%67, %61, %68) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %110 = "llvm.insertelement"(%109, %61, %31) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %111 = "llvm.insertelement"(%110, %61, %30) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %112 = "llvm.insertelement"(%111, %61, %32) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %113 = "llvm.insertelement"(%112, %61, %29) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %114 = "llvm.insertelement"(%113, %66, %28) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %115 = "llvm.insertelement"(%114, %66, %27) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %116 = "llvm.insertelement"(%115, %66, %26) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %117 = "llvm.insertelement"(%67, %66, %68) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %118 = "llvm.insertelement"(%117, %66, %31) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %119 = "llvm.insertelement"(%118, %66, %30) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %120 = "llvm.insertelement"(%119, %15, %32) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %121 = "llvm.insertelement"(%120, %66, %29) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %122 = "llvm.insertelement"(%121, %66, %28) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %123 = "llvm.insertelement"(%122, %66, %27) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %124 = "llvm.insertelement"(%123, %16, %26) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %125 = "llvm.insertelement"(%67, %66, %68) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %126 = "llvm.insertelement"(%125, %66, %31) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %127 = "llvm.insertelement"(%126, %66, %30) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %128 = "llvm.insertelement"(%127, %16, %32) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %129 = "llvm.insertelement"(%128, %66, %29) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %130 = "llvm.insertelement"(%129, %66, %28) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %131 = "llvm.insertelement"(%130, %66, %27) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %132 = "llvm.insertelement"(%131, %16, %26) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %133 = "llvm.insertelement"(%67, %66, %68) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %134 = "llvm.insertelement"(%133, %66, %31) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %135 = "llvm.insertelement"(%134, %66, %30) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %136 = "llvm.insertelement"(%135, %16, %32) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %137 = "llvm.insertelement"(%136, %66, %29) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %138 = "llvm.insertelement"(%137, %66, %28) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %139 = "llvm.insertelement"(%138, %66, %27) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %140 = "llvm.insertelement"(%139, %14, %26) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %141 = "llvm.insertelement"(%67, %12, %68) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %142 = "llvm.insertelement"(%141, %66, %31) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %143 = "llvm.insertelement"(%142, %66, %30) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %144 = "llvm.insertelement"(%143, %66, %32) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %145 = "llvm.insertelement"(%144, %13, %29) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %146 = "llvm.insertelement"(%145, %66, %28) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %147 = "llvm.insertelement"(%146, %66, %27) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %148 = "llvm.insertelement"(%147, %66, %26) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %149 = "llvm.insertelement"(%67, %13, %68) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %150 = "llvm.insertelement"(%149, %66, %31) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %151 = "llvm.insertelement"(%150, %66, %30) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %152 = "llvm.insertelement"(%151, %66, %32) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %153 = "llvm.insertelement"(%152, %13, %29) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %154 = "llvm.insertelement"(%153, %66, %28) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %155 = "llvm.insertelement"(%154, %66, %27) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %156 = "llvm.insertelement"(%155, %66, %26) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %157 = "llvm.insertelement"(%67, %13, %68) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %158 = "llvm.insertelement"(%157, %66, %31) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %159 = "llvm.insertelement"(%158, %66, %30) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %160 = "llvm.insertelement"(%159, %66, %32) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %161 = "llvm.insertelement"(%160, %11, %29) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %162 = "llvm.insertelement"(%161, %66, %28) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %163 = "llvm.insertelement"(%162, %66, %27) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %164 = "llvm.insertelement"(%163, %66, %26) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %165 = "llvm.insertelement"(%67, %66, %68) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %166 = "llvm.insertelement"(%165, %66, %31) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %167 = "llvm.insertelement"(%166, %66, %30) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %168 = "llvm.insertelement"(%167, %66, %32) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %169 = "llvm.insertelement"(%168, %6, %29) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %170 = "llvm.insertelement"(%169, %6, %28) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %171 = "llvm.insertelement"(%170, %6, %27) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %172 = "llvm.insertelement"(%171, %6, %26) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %173 = "llvm.insertelement"(%67, %12, %68) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %174 = "llvm.insertelement"(%173, %66, %31) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %175 = "llvm.insertelement"(%174, %66, %30) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %176 = "llvm.insertelement"(%175, %12, %32) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %177 = "llvm.insertelement"(%176, %13, %29) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %178 = "llvm.insertelement"(%177, %66, %28) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %179 = "llvm.insertelement"(%178, %66, %27) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %180 = "llvm.insertelement"(%179, %13, %26) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %181 = "llvm.insertelement"(%67, %13, %68) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %182 = "llvm.insertelement"(%181, %66, %31) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %183 = "llvm.insertelement"(%182, %66, %30) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %184 = "llvm.insertelement"(%183, %13, %32) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %185 = "llvm.insertelement"(%184, %13, %29) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %186 = "llvm.insertelement"(%185, %66, %28) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %187 = "llvm.insertelement"(%186, %66, %27) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %188 = "llvm.insertelement"(%187, %13, %26) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %189 = "llvm.insertelement"(%67, %13, %68) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %190 = "llvm.insertelement"(%189, %66, %31) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %191 = "llvm.insertelement"(%190, %66, %30) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %192 = "llvm.insertelement"(%191, %13, %32) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %193 = "llvm.insertelement"(%192, %11, %29) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %194 = "llvm.insertelement"(%193, %66, %28) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %195 = "llvm.insertelement"(%194, %66, %27) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %196 = "llvm.insertelement"(%195, %11, %26) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %197 = "llvm.alloca"(%31) <{alignment = 16 : i64, elem_type = !llvm.array<256 x i16>}> : (i32) -> !llvm.ptr
  %198 = "llvm.alloca"(%31) <{alignment = 16 : i64, elem_type = !llvm.array<256 x i16>}> : (i32) -> !llvm.ptr
  %199 = "llvm.alloca"(%31) <{alignment = 16 : i64, elem_type = !llvm.array<8 x ptr>}> : (i32) -> !llvm.ptr
  %200 = "llvm.alloca"(%31) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_curve25519_edwards", (vector<8xi64>, vector<8xi64>, vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%197) : (!llvm.ptr) -> ()
  "llvm.call"(%197, %arg1, %32) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_curve25519_scalar_wnaf, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> ()
  "llvm.intr.lifetime.start"(%198) : (!llvm.ptr) -> ()
  "llvm.call"(%198, %arg3, %33) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_curve25519_scalar_wnaf, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> ()
  "llvm.intr.lifetime.start"(%199) : (!llvm.ptr) -> ()
  "llvm.store"(%34, %199) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 _ZTS21fd_curve25519_edwards", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 _ZTS21fd_curve25519_edwards", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %201 = "llvm.getelementptr"(%199) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%arg4, %201) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 _ZTS21fd_curve25519_edwards", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 _ZTS21fd_curve25519_edwards", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %202 = "llvm.getelementptr"(%arg4, %36) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, vector<4xi64>) -> vector<4x!llvm.ptr>
  %203 = "llvm.getelementptr"(%199) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%202, %203) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 _ZTS21fd_curve25519_edwards", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 _ZTS21fd_curve25519_edwards", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (vector<4x!llvm.ptr>, !llvm.ptr) -> ()
  %204 = "llvm.getelementptr"(%arg4) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 122880>}> : (!llvm.ptr) -> !llvm.ptr
  %205 = "llvm.getelementptr"(%199) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 48>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%204, %205) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 _ZTS21fd_curve25519_edwards", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 _ZTS21fd_curve25519_edwards", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %206 = "llvm.getelementptr"(%arg4) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 147456>}> : (!llvm.ptr) -> !llvm.ptr
  %207 = "llvm.getelementptr"(%199) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 56>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%206, %207) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 _ZTS21fd_curve25519_edwards", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 _ZTS21fd_curve25519_edwards", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%200) : (!llvm.ptr) -> ()
  "llvm.store"(%37, %arg0) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %208 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memset"(%208, %39, %40) <{arg_attrs = [{llvm.align = 64 : i64, llvm.dereferenceable = 128 : i64, llvm.nonnull, llvm.noundef}, {}, {}], isVolatile = false}> : (!llvm.ptr, i8, i64) -> ()
  "llvm.br"(%41)[^bb1] : (i64) -> ()
^bb1(%209: i64):  // 2 preds: ^bb0, ^bb3
  %210 = "llvm.getelementptr"(%197, %209) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %211 = "llvm.load"(%210) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %212 = "llvm.getelementptr"(%198, %209) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %213 = "llvm.load"(%212) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %214 = "llvm.or"(%211, %213) : (i16, i16) -> i16
  %215 = "llvm.add"(%209, %42) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %216 = "llvm.getelementptr"(%197, %215) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %217 = "llvm.load"(%216) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %218 = "llvm.getelementptr"(%198, %215) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %219 = "llvm.load"(%218) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %220 = "llvm.or"(%217, %214) : (i16, i16) -> i16
  %221 = "llvm.or"(%220, %219) : (i16, i16) -> i16
  %222 = "llvm.add"(%209, %38) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %223 = "llvm.getelementptr"(%197, %222) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %224 = "llvm.load"(%223) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %225 = "llvm.getelementptr"(%198, %222) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %226 = "llvm.load"(%225) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %227 = "llvm.or"(%224, %221) : (i16, i16) -> i16
  %228 = "llvm.or"(%227, %226) : (i16, i16) -> i16
  %229 = "llvm.add"(%209, %43) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %230 = "llvm.getelementptr"(%197, %229) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %231 = "llvm.load"(%230) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %232 = "llvm.getelementptr"(%198, %229) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %233 = "llvm.load"(%232) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %234 = "llvm.or"(%231, %228) : (i16, i16) -> i16
  %235 = "llvm.or"(%234, %233) : (i16, i16) -> i16
  %236 = "llvm.add"(%209, %40) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %237 = "llvm.getelementptr"(%197, %236) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %238 = "llvm.load"(%237) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %239 = "llvm.getelementptr"(%198, %236) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %240 = "llvm.load"(%239) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %241 = "llvm.or"(%238, %235) : (i16, i16) -> i16
  %242 = "llvm.or"(%241, %240) : (i16, i16) -> i16
  %243 = "llvm.add"(%209, %44) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %244 = "llvm.getelementptr"(%197, %243) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %245 = "llvm.load"(%244) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %246 = "llvm.getelementptr"(%198, %243) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %247 = "llvm.load"(%246) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %248 = "llvm.or"(%245, %242) : (i16, i16) -> i16
  %249 = "llvm.or"(%248, %247) : (i16, i16) -> i16
  %250 = "llvm.add"(%209, %45) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %251 = "llvm.getelementptr"(%197, %250) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %252 = "llvm.load"(%251) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %253 = "llvm.getelementptr"(%198, %250) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %254 = "llvm.load"(%253) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %255 = "llvm.or"(%252, %249) : (i16, i16) -> i16
  %256 = "llvm.or"(%255, %254) : (i16, i16) -> i16
  %257 = "llvm.add"(%209, %46) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %258 = "llvm.getelementptr"(%197, %257) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %259 = "llvm.load"(%258) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %260 = "llvm.getelementptr"(%198, %257) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %261 = "llvm.load"(%260) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %262 = "llvm.or"(%259, %256) : (i16, i16) -> i16
  %263 = "llvm.or"(%262, %261) : (i16, i16) -> i16
  %264 = "llvm.icmp"(%263, %47) <{predicate = 0 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%264, %209)[^bb2, ^bb4] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb2:  // pred: ^bb1
  %265 = "llvm.add"(%209, %48) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %266 = "llvm.getelementptr"(%197, %265) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %267 = "llvm.load"(%266) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %268 = "llvm.getelementptr"(%198, %265) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %269 = "llvm.load"(%268) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %270 = "llvm.or"(%267, %269) : (i16, i16) -> i16
  %271 = "llvm.add"(%209, %41) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %272 = "llvm.getelementptr"(%197, %271) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %273 = "llvm.load"(%272) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %274 = "llvm.getelementptr"(%198, %271) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %275 = "llvm.load"(%274) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %276 = "llvm.or"(%273, %270) : (i16, i16) -> i16
  %277 = "llvm.or"(%276, %275) : (i16, i16) -> i16
  %278 = "llvm.add"(%209, %49) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %279 = "llvm.getelementptr"(%197, %278) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %280 = "llvm.load"(%279) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %281 = "llvm.getelementptr"(%198, %278) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %282 = "llvm.load"(%281) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %283 = "llvm.or"(%280, %277) : (i16, i16) -> i16
  %284 = "llvm.or"(%283, %282) : (i16, i16) -> i16
  %285 = "llvm.add"(%209, %50) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %286 = "llvm.getelementptr"(%197, %285) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %287 = "llvm.load"(%286) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %288 = "llvm.getelementptr"(%198, %285) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %289 = "llvm.load"(%288) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %290 = "llvm.or"(%287, %284) : (i16, i16) -> i16
  %291 = "llvm.or"(%290, %289) : (i16, i16) -> i16
  %292 = "llvm.add"(%209, %51) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %293 = "llvm.getelementptr"(%197, %292) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %294 = "llvm.load"(%293) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %295 = "llvm.getelementptr"(%198, %292) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %296 = "llvm.load"(%295) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %297 = "llvm.or"(%294, %291) : (i16, i16) -> i16
  %298 = "llvm.or"(%297, %296) : (i16, i16) -> i16
  %299 = "llvm.add"(%209, %52) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %300 = "llvm.getelementptr"(%197, %299) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %301 = "llvm.load"(%300) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %302 = "llvm.getelementptr"(%198, %299) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %303 = "llvm.load"(%302) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %304 = "llvm.or"(%301, %298) : (i16, i16) -> i16
  %305 = "llvm.or"(%304, %303) : (i16, i16) -> i16
  %306 = "llvm.add"(%209, %53) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %307 = "llvm.getelementptr"(%197, %306) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %308 = "llvm.load"(%307) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %309 = "llvm.getelementptr"(%198, %306) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %310 = "llvm.load"(%309) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %311 = "llvm.or"(%308, %305) : (i16, i16) -> i16
  %312 = "llvm.or"(%311, %310) : (i16, i16) -> i16
  %313 = "llvm.add"(%209, %54) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %314 = "llvm.getelementptr"(%197, %313) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %315 = "llvm.load"(%314) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %316 = "llvm.getelementptr"(%198, %313) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %317 = "llvm.load"(%316) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %318 = "llvm.or"(%315, %312) : (i16, i16) -> i16
  %319 = "llvm.or"(%318, %317) : (i16, i16) -> i16
  %320 = "llvm.icmp"(%319, %47) <{predicate = 0 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%320, %265)[^bb3, ^bb4] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb3:  // pred: ^bb2
  %321 = "llvm.add"(%209, %0) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %322 = "llvm.icmp"(%265, %61) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%322, %321)[^bb38, ^bb1] <{loop_annotation = #llvm.loop_annotation<mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb4(%323: i64):  // 2 preds: ^bb1, ^bb2
  %324 = "llvm.icmp"(%323, %48) <{predicate = 4 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%324)[^bb5, ^bb38] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb5:  // pred: ^bb4
  %325 = "llvm.icmp"(%arg5, %55) <{predicate = 0 : i64}> : (!llvm.ptr, !llvm.ptr) -> i1
  %326 = "llvm.getelementptr"(%arg5) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 712>}> : (!llvm.ptr) -> !llvm.ptr
  %327 = "llvm.getelementptr"(%arg5) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 704>}> : (!llvm.ptr) -> !llvm.ptr
  %328 = "llvm.getelementptr"(%200) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %329 = "llvm.getelementptr"(%200) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %330 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.br"(%323)[^bb6] : (i64) -> ()
^bb6(%331: i64):  // 2 preds: ^bb5, ^bb12
  %332 = "llvm.call"(%200, %arg0) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_ed25519_partial_dbl, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.cond_br"(%325)[^bb11, ^bb7] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb7:  // pred: ^bb6
  %333 = "llvm.load"(%326) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "fd_r43x6_ge_decode", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 64>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 128>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 192>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 256>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 320>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 384>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 448>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 512>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 576>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 640>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 704>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 712>, <#llvm.tbaa_type_desc<id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 720>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 712>]}> : (!llvm.ptr) -> i64
  %334 = "llvm.icmp"(%333, %56) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%334)[^bb9, ^bb8] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb8:  // pred: ^bb7
  %335 = "llvm.load"(%arg5) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %336 = "llvm.shufflevector"(%335, %57) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %337 = "llvm.shufflevector"(%335, %57) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 3, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %338 = "llvm.shufflevector"(%335, %57) <{mask = array<i32: 4, 4, 1, 1, 1, 1, 1, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %339 = "llvm.shufflevector"(%335, %57) <{mask = array<i32: 4, 5, 1, 2, 3, 4, 5, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %340 = "llvm.shufflevector"(%335, %57) <{mask = array<i32: 3, 7, 5, 7, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %341 = "llvm.shufflevector"(%335, %57) <{mask = array<i32: 5, 7, 5, 7, 2, 3, 4, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %342 = "llvm.shl"(%336, %58) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %343 = "llvm.shl"(%338, %59) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %344 = "llvm.shl"(%340, %60) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %345 = "llvm.call_intrinsic"(%62, %343, %339) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %346 = "llvm.call_intrinsic"(%62, %344, %341) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %347 = "llvm.call_intrinsic"(%62, %342, %337) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %348 = "llvm.shl"(%347, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %349 = "llvm.call_intrinsic"(%62, %343, %339) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %350 = "llvm.shl"(%349, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %351 = "llvm.call_intrinsic"(%62, %344, %341) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %352 = "llvm.shl"(%351, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %353 = "llvm.and"(%345, %64) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %354 = "llvm.and"(%346, %65) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %355 = "llvm.add"(%354, %353) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %356 = "llvm.call_intrinsic"(%355, %342, %337) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %357 = "llvm.and"(%350, %64) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %358 = "llvm.and"(%352, %65) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %359 = "llvm.add"(%357, %348) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %360 = "llvm.add"(%359, %358) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %361 = "llvm.and"(%345, %76) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %362 = "llvm.and"(%346, %84) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %363 = "llvm.and"(%350, %92) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %364 = "llvm.and"(%352, %100) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %365 = "llvm.add"(%364, %363) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %366 = "llvm.shufflevector"(%108, %360) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %367 = "llvm.add"(%366, %356) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %368 = "llvm.shufflevector"(%108, %365) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %369 = "llvm.shufflevector"(%360, %116) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %370 = "llvm.add"(%362, %361) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %371 = "llvm.add"(%370, %368) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %372 = "llvm.add"(%371, %369) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %373 = "llvm.and"(%367, %25) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %374 = "llvm.shufflevector"(%367, %372) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %375 = "llvm.shl"(%374, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %376 = "llvm.add"(%375, %373) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %377 = "llvm.mul"(%374, %23) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %378 = "llvm.add"(%376, %377) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %379 = "llvm.and"(%378, %22) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %380 = "llvm.lshr"(%378, %21) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %381 = "llvm.shufflevector"(%380, %57) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %382 = "llvm.call_intrinsic"(%379, %20, %381) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %383 = "llvm.shufflevector"(%382, %57) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %384 = "llvm.shufflevector"(%382, %57) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 3, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %385 = "llvm.shufflevector"(%382, %57) <{mask = array<i32: 4, 4, 1, 1, 1, 1, 1, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %386 = "llvm.shufflevector"(%382, %57) <{mask = array<i32: 4, 5, 1, 2, 3, 4, 5, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %387 = "llvm.shufflevector"(%382, %57) <{mask = array<i32: 3, 7, 5, 7, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %388 = "llvm.shufflevector"(%382, %57) <{mask = array<i32: 5, 7, 5, 7, 2, 3, 4, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %389 = "llvm.shl"(%383, %58) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %390 = "llvm.shl"(%385, %59) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %391 = "llvm.shl"(%387, %60) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %392 = "llvm.call_intrinsic"(%62, %390, %386) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %393 = "llvm.call_intrinsic"(%62, %391, %388) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %394 = "llvm.call_intrinsic"(%62, %389, %384) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %395 = "llvm.shl"(%394, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %396 = "llvm.call_intrinsic"(%62, %390, %386) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %397 = "llvm.shl"(%396, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %398 = "llvm.call_intrinsic"(%62, %391, %388) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %399 = "llvm.shl"(%398, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %400 = "llvm.and"(%392, %64) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %401 = "llvm.and"(%393, %65) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %402 = "llvm.add"(%401, %400) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %403 = "llvm.call_intrinsic"(%402, %389, %384) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %404 = "llvm.and"(%397, %64) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %405 = "llvm.and"(%399, %65) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %406 = "llvm.add"(%404, %395) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %407 = "llvm.add"(%406, %405) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %408 = "llvm.and"(%392, %76) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %409 = "llvm.and"(%393, %84) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %410 = "llvm.and"(%397, %92) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %411 = "llvm.and"(%399, %100) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %412 = "llvm.add"(%411, %410) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %413 = "llvm.shufflevector"(%108, %407) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %414 = "llvm.add"(%413, %403) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %415 = "llvm.shufflevector"(%108, %412) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %416 = "llvm.shufflevector"(%407, %116) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %417 = "llvm.add"(%409, %408) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %418 = "llvm.add"(%417, %415) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %419 = "llvm.add"(%418, %416) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %420 = "llvm.and"(%414, %25) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %421 = "llvm.shufflevector"(%414, %419) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %422 = "llvm.shl"(%421, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %423 = "llvm.add"(%422, %420) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %424 = "llvm.mul"(%421, %23) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %425 = "llvm.add"(%423, %424) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %426 = "llvm.and"(%425, %22) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %427 = "llvm.lshr"(%425, %21) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %428 = "llvm.shufflevector"(%427, %57) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %429 = "llvm.call_intrinsic"(%426, %20, %428) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %430 = "llvm.shufflevector"(%429, %57) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %431 = "llvm.shufflevector"(%429, %57) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 3, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %432 = "llvm.shufflevector"(%429, %57) <{mask = array<i32: 4, 4, 1, 1, 1, 1, 1, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %433 = "llvm.shufflevector"(%429, %57) <{mask = array<i32: 4, 5, 1, 2, 3, 4, 5, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %434 = "llvm.shufflevector"(%429, %57) <{mask = array<i32: 3, 7, 5, 7, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %435 = "llvm.shufflevector"(%429, %57) <{mask = array<i32: 5, 7, 5, 7, 2, 3, 4, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %436 = "llvm.shl"(%430, %58) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %437 = "llvm.shl"(%432, %59) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %438 = "llvm.shl"(%434, %60) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %439 = "llvm.call_intrinsic"(%62, %437, %433) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %440 = "llvm.call_intrinsic"(%62, %438, %435) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %441 = "llvm.call_intrinsic"(%62, %436, %431) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %442 = "llvm.shl"(%441, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %443 = "llvm.call_intrinsic"(%62, %437, %433) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %444 = "llvm.shl"(%443, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %445 = "llvm.call_intrinsic"(%62, %438, %435) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %446 = "llvm.shl"(%445, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %447 = "llvm.and"(%439, %64) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %448 = "llvm.and"(%440, %65) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %449 = "llvm.add"(%448, %447) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %450 = "llvm.call_intrinsic"(%449, %436, %431) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %451 = "llvm.and"(%444, %64) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %452 = "llvm.and"(%446, %65) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %453 = "llvm.add"(%451, %442) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %454 = "llvm.add"(%453, %452) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %455 = "llvm.and"(%439, %76) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %456 = "llvm.and"(%440, %84) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %457 = "llvm.and"(%444, %92) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %458 = "llvm.and"(%446, %100) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %459 = "llvm.add"(%458, %457) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %460 = "llvm.shufflevector"(%108, %454) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %461 = "llvm.add"(%460, %450) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %462 = "llvm.shufflevector"(%108, %459) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %463 = "llvm.shufflevector"(%454, %116) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %464 = "llvm.add"(%456, %455) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %465 = "llvm.add"(%464, %462) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %466 = "llvm.add"(%465, %463) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %467 = "llvm.and"(%461, %25) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %468 = "llvm.shufflevector"(%461, %466) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %469 = "llvm.shl"(%468, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %470 = "llvm.add"(%469, %467) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %471 = "llvm.mul"(%468, %23) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %472 = "llvm.add"(%470, %471) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %473 = "llvm.and"(%472, %22) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %474 = "llvm.lshr"(%472, %21) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %475 = "llvm.shufflevector"(%474, %57) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %476 = "llvm.call_intrinsic"(%473, %20, %475) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%476, %arg5) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %477 = "llvm.add"(%333, %19) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%477, %326) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "fd_r43x6_ge_decode", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 64>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 128>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 192>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 256>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 320>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 384>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 448>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 512>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 576>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 640>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 704>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 712>, <#llvm.tbaa_type_desc<id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 720>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 712>]}> : (i64, !llvm.ptr) -> ()
  "llvm.br"()[^bb11] : () -> ()
^bb9:  // pred: ^bb7
  %478 = "llvm.load"(%327) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "fd_r43x6_ge_decode", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 64>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 128>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 192>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 256>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 320>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 384>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 448>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 512>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 576>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 640>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 704>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 712>, <#llvm.tbaa_type_desc<id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 720>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 704>]}> : (!llvm.ptr) -> i64
  %479 = "llvm.icmp"(%478, %18) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%479)[^bb10, ^bb11] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb10:  // pred: ^bb9
  "llvm.call"(%arg5, %56) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_ge_decode_step_slow, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, i64) -> ()
  "llvm.br"()[^bb11] : () -> ()
^bb11:  // 4 preds: ^bb6, ^bb8, ^bb9, ^bb10
  %480 = "llvm.load"(%200) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi64>
  %481 = "llvm.load"(%328) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi64>
  %482 = "llvm.load"(%329) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.br"(%61, %482, %481, %480)[^bb13] : (i64, vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
^bb12:  // pred: ^bb37
  "llvm.store"(%2193, %328) <{alignment = 64 : i64, ordering = 0 : i64}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%2192, %329) <{alignment = 64 : i64, ordering = 0 : i64}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%2194, %200) <{alignment = 64 : i64, ordering = 0 : i64}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%2194, %arg0) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%2193, %208) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%2192, %330) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %483 = "llvm.add"(%331, %48) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %484 = "llvm.icmp"(%331, %61) <{predicate = 4 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%484, %483)[^bb6, ^bb38] <{loop_annotation = #llvm.loop_annotation<mustProgress = true>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
^bb13(%485: i64, %486: vector<8xi64>, %487: vector<8xi64>, %488: vector<8xi64>):  // 2 preds: ^bb11, ^bb37
  %489 = "llvm.shl"(%485, %17) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %490 = "llvm.add"(%489, %331) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %491 = "llvm.getelementptr"(%197, %490) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %492 = "llvm.load"(%491) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %493 = "llvm.getelementptr"(%198, %490) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %494 = "llvm.load"(%493) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %495 = "llvm.sext"(%492) : (i16) -> i32
  %496 = "llvm.icmp"(%492, %47) <{predicate = 4 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%496)[^bb14, ^bb19] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb14:  // pred: ^bb13
  "llvm.store"(%488, %arg0) <{alias_scopes = [#llvm.alias_scope<id = distinct[0]<>, domain = <id = distinct[1]<>, description = "fd_ed25519_point_add_final_mul">, description = "fd_ed25519_point_add_final_mul: argument 0">], alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%487, %208) <{alias_scopes = [#llvm.alias_scope<id = distinct[0]<>, domain = <id = distinct[1]<>, description = "fd_ed25519_point_add_final_mul">, description = "fd_ed25519_point_add_final_mul: argument 0">], alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%486, %330) <{alias_scopes = [#llvm.alias_scope<id = distinct[0]<>, domain = <id = distinct[1]<>, description = "fd_ed25519_point_add_final_mul">, description = "fd_ed25519_point_add_final_mul: argument 0">], alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %497 = "llvm.lshr"(%495, %31) : (i32, i32) -> i32
  %498 = "llvm.trunc"(%485) <{overflowFlags = 0 : i32}> : (i64) -> i32
  %499 = "llvm.shl"(%498, %30) <{overflowFlags = 0 : i32}> : (i32, i32) -> i32
  %500 = "llvm.add"(%497, %499) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %501 = "llvm.zext"(%500) <{nonNeg}> : (i32) -> i64
  %502 = "llvm.getelementptr"(%arg2, %501) <{elem_type = !llvm.array<192 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %503 = "llvm.load"(%502) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %504 = "llvm.getelementptr"(%502) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %505 = "llvm.load"(%504) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %506 = "llvm.getelementptr"(%502) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %507 = "llvm.load"(%506) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %508 = "llvm.shufflevector"(%488, %57) <{mask = array<i32: 1, -1, -1, -1, 5, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %509 = "llvm.shufflevector"(%487, %57) <{mask = array<i32: 1, -1, -1, -1, 5, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %510 = "llvm.shufflevector"(%486, %57) <{mask = array<i32: 1, -1, -1, -1, 5, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %511 = "llvm.sub"(%508, %488) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %512 = "llvm.add"(%511, %148) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %513 = "llvm.shufflevector"(%512, %488) <{mask = array<i32: 0, 8, 10, 11, 4, 12, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %514 = "llvm.sub"(%509, %487) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %515 = "llvm.add"(%514, %156) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %516 = "llvm.shufflevector"(%515, %487) <{mask = array<i32: 0, 8, 10, 11, 4, 12, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %517 = "llvm.sub"(%510, %486) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %518 = "llvm.add"(%517, %164) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %519 = "llvm.shufflevector"(%518, %486) <{mask = array<i32: 0, 8, 10, 11, 4, 12, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %520 = "llvm.add"(%513, %488) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %521 = "llvm.shufflevector"(%513, %520) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %522 = "llvm.add"(%516, %487) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %523 = "llvm.shufflevector"(%516, %522) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %524 = "llvm.add"(%519, %486) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %525 = "llvm.shufflevector"(%519, %524) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %526 = "llvm.add"(%521, %10) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %527 = "llvm.add"(%523, %9) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %528 = "llvm.add"(%525, %9) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %529 = "llvm.ashr"(%526, %8) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %530 = "llvm.ashr"(%527, %8) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %531 = "llvm.ashr"(%528, %7) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %532 = "llvm.mul"(%531, %172) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %533 = "llvm.and"(%526, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %534 = "llvm.shufflevector"(%532, %531) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %535 = "llvm.add"(%533, %4) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %536 = "llvm.add"(%535, %534) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %537 = "llvm.and"(%527, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %538 = "llvm.add"(%529, %3) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %539 = "llvm.add"(%538, %537) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %540 = "llvm.and"(%528, %2) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %541 = "llvm.add"(%530, %3) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %542 = "llvm.add"(%541, %540) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %543 = "llvm.shufflevector"(%503, %57) <{mask = array<i32: 0, 1, 2, 3, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %544 = "llvm.shufflevector"(%505, %57) <{mask = array<i32: 0, 1, 2, 3, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %545 = "llvm.shufflevector"(%507, %57) <{mask = array<i32: 0, 1, 2, 3, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %546 = "llvm.shufflevector"(%503, %57) <{mask = array<i32: 4, 5, 6, 7, 4, 5, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %547 = "llvm.shufflevector"(%505, %57) <{mask = array<i32: 4, 5, 6, 7, 4, 5, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %548 = "llvm.shufflevector"(%507, %57) <{mask = array<i32: 4, 5, 6, 7, 4, 5, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %549 = "llvm.call_intrinsic"(%62, %543, %536) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %550 = "llvm.call_intrinsic"(%62, %544, %536) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %551 = "llvm.call_intrinsic"(%550, %543, %539) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %552 = "llvm.call_intrinsic"(%62, %545, %536) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %553 = "llvm.call_intrinsic"(%552, %544, %539) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %554 = "llvm.call_intrinsic"(%553, %543, %542) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %555 = "llvm.call_intrinsic"(%62, %546, %536) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %556 = "llvm.call_intrinsic"(%555, %545, %539) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %557 = "llvm.call_intrinsic"(%556, %544, %542) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %558 = "llvm.call_intrinsic"(%62, %547, %536) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %559 = "llvm.call_intrinsic"(%558, %546, %539) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %560 = "llvm.call_intrinsic"(%559, %545, %542) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %561 = "llvm.call_intrinsic"(%62, %548, %536) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %562 = "llvm.call_intrinsic"(%561, %547, %539) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %563 = "llvm.call_intrinsic"(%562, %546, %542) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %564 = "llvm.call_intrinsic"(%62, %548, %539) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %565 = "llvm.call_intrinsic"(%564, %547, %542) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %566 = "llvm.call_intrinsic"(%62, %543, %536) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %567 = "llvm.shl"(%566, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %568 = "llvm.add"(%567, %551) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %569 = "llvm.call_intrinsic"(%62, %544, %536) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %570 = "llvm.call_intrinsic"(%569, %543, %539) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %571 = "llvm.shl"(%570, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %572 = "llvm.add"(%571, %554) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %573 = "llvm.call_intrinsic"(%62, %545, %536) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %574 = "llvm.call_intrinsic"(%573, %544, %539) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %575 = "llvm.call_intrinsic"(%574, %543, %542) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %576 = "llvm.shl"(%575, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %577 = "llvm.add"(%576, %557) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %578 = "llvm.call_intrinsic"(%62, %546, %536) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %579 = "llvm.call_intrinsic"(%578, %545, %539) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %580 = "llvm.call_intrinsic"(%579, %544, %542) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %581 = "llvm.shl"(%580, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %582 = "llvm.add"(%581, %560) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %583 = "llvm.call_intrinsic"(%62, %547, %536) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %584 = "llvm.call_intrinsic"(%583, %546, %539) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %585 = "llvm.call_intrinsic"(%584, %545, %542) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %586 = "llvm.shl"(%585, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %587 = "llvm.add"(%586, %563) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %588 = "llvm.call_intrinsic"(%62, %548, %536) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %589 = "llvm.call_intrinsic"(%588, %547, %539) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %590 = "llvm.call_intrinsic"(%589, %546, %542) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %591 = "llvm.shl"(%590, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %592 = "llvm.add"(%591, %565) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %593 = "llvm.call_intrinsic"(%62, %548, %539) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %594 = "llvm.call_intrinsic"(%593, %547, %542) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %595 = "llvm.shl"(%594, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %596 = "llvm.call_intrinsic"(%595, %548, %542) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %597 = "llvm.call_intrinsic"(%62, %548, %542) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %598 = "llvm.shl"(%597, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %599 = "llvm.shufflevector"(%577, %57) <{mask = array<i32: 4, 5, 6, 7, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %600 = "llvm.shufflevector"(%582, %57) <{mask = array<i32: 4, 5, 6, 7, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %601 = "llvm.shufflevector"(%587, %57) <{mask = array<i32: 4, 5, 6, 7, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %602 = "llvm.add"(%599, %549) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %603 = "llvm.shufflevector"(%549, %602) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %604 = "llvm.add"(%600, %568) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %605 = "llvm.shufflevector"(%568, %604) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %606 = "llvm.add"(%601, %572) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %607 = "llvm.shufflevector"(%572, %606) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %608 = "llvm.add"(%592, %599) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %609 = "llvm.shufflevector"(%608, %592) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %610 = "llvm.add"(%596, %600) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %611 = "llvm.shufflevector"(%610, %596) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %612 = "llvm.add"(%598, %601) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %613 = "llvm.shufflevector"(%612, %598) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %614 = "llvm.shl"(%609, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %615 = "llvm.add"(%614, %603) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %616 = "llvm.mul"(%609, %23) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %617 = "llvm.add"(%615, %616) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %618 = "llvm.shl"(%611, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %619 = "llvm.add"(%618, %605) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %620 = "llvm.mul"(%611, %23) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %621 = "llvm.add"(%619, %620) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %622 = "llvm.shl"(%613, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %623 = "llvm.add"(%622, %607) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %624 = "llvm.mul"(%613, %23) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %625 = "llvm.add"(%623, %624) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %626 = "llvm.lshr"(%617, %8) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %627 = "llvm.lshr"(%621, %8) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %628 = "llvm.lshr"(%625, %7) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %629 = "llvm.mul"(%628, %172) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %630 = "llvm.and"(%617, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %631 = "llvm.shufflevector"(%629, %628) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %632 = "llvm.add"(%631, %630) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %633 = "llvm.and"(%621, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %634 = "llvm.add"(%633, %626) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %635 = "llvm.and"(%625, %2) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %636 = "llvm.add"(%635, %627) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %637 = "llvm.shufflevector"(%632, %57) <{mask = array<i32: 1, -1, -1, 2, 5, -1, -1, 6>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %638 = "llvm.shufflevector"(%634, %57) <{mask = array<i32: 1, -1, -1, 2, 5, -1, -1, 6>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %639 = "llvm.shufflevector"(%636, %57) <{mask = array<i32: 1, -1, -1, 2, 5, -1, -1, 6>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %640 = "llvm.sub"(%637, %632) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %641 = "llvm.add"(%640, %180) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %642 = "llvm.shufflevector"(%632, %57) <{mask = array<i32: -1, 0, 3, -1, -1, 4, 7, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %643 = "llvm.sub"(%638, %634) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %644 = "llvm.add"(%643, %188) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %645 = "llvm.shufflevector"(%634, %57) <{mask = array<i32: -1, 0, 3, -1, -1, 4, 7, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %646 = "llvm.sub"(%639, %636) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %647 = "llvm.add"(%646, %196) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %648 = "llvm.shufflevector"(%636, %57) <{mask = array<i32: -1, 0, 3, -1, -1, 4, 7, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %649 = "llvm.add"(%642, %632) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %650 = "llvm.shufflevector"(%641, %649) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %651 = "llvm.add"(%645, %634) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %652 = "llvm.shufflevector"(%644, %651) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %653 = "llvm.add"(%648, %636) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %654 = "llvm.shufflevector"(%647, %653) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %655 = "llvm.add"(%650, %10) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %656 = "llvm.add"(%652, %9) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %657 = "llvm.add"(%654, %9) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %658 = "llvm.ashr"(%655, %8) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %659 = "llvm.ashr"(%657, %7) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %660 = "llvm.mul"(%659, %172) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %661 = "llvm.and"(%655, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %662 = "llvm.shufflevector"(%660, %659) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %663 = "llvm.add"(%662, %4) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %664 = "llvm.add"(%663, %661) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %665 = "llvm.and"(%656, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %666 = "llvm.ashr"(%656, %8) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %667 = "llvm.add"(%665, %3) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %668 = "llvm.add"(%667, %658) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %669 = "llvm.and"(%657, %2) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %670 = "llvm.add"(%666, %3) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %671 = "llvm.add"(%670, %669) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %672 = "llvm.shufflevector"(%664, %57) <{mask = array<i32: 3, 1, 3, 1, 7, 5, 7, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %673 = "llvm.shufflevector"(%668, %57) <{mask = array<i32: 3, 1, 3, 1, 7, 5, 7, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %674 = "llvm.shufflevector"(%671, %57) <{mask = array<i32: 3, 1, 3, 1, 7, 5, 7, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %675 = "llvm.shufflevector"(%664, %57) <{mask = array<i32: 0, 2, 2, 0, 0, 2, 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %676 = "llvm.shufflevector"(%668, %57) <{mask = array<i32: 0, 2, 2, 0, 0, 2, 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %677 = "llvm.shufflevector"(%671, %57) <{mask = array<i32: 0, 2, 2, 0, 0, 2, 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %678 = "llvm.shufflevector"(%664, %57) <{mask = array<i32: 4, 6, 6, 4, 4, 6, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %679 = "llvm.shufflevector"(%668, %57) <{mask = array<i32: 4, 6, 6, 4, 4, 6, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %680 = "llvm.shufflevector"(%671, %57) <{mask = array<i32: 4, 6, 6, 4, 4, 6, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %681 = "llvm.call_intrinsic"(%62, %675, %672) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %682 = "llvm.call_intrinsic"(%62, %676, %672) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %683 = "llvm.call_intrinsic"(%682, %675, %673) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %684 = "llvm.call_intrinsic"(%62, %677, %672) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %685 = "llvm.call_intrinsic"(%684, %676, %673) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %686 = "llvm.call_intrinsic"(%685, %675, %674) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %687 = "llvm.call_intrinsic"(%62, %678, %672) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %688 = "llvm.call_intrinsic"(%687, %677, %673) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %689 = "llvm.call_intrinsic"(%688, %676, %674) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %690 = "llvm.call_intrinsic"(%62, %679, %672) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %691 = "llvm.call_intrinsic"(%690, %678, %673) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %692 = "llvm.call_intrinsic"(%691, %677, %674) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %693 = "llvm.call_intrinsic"(%62, %680, %672) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %694 = "llvm.call_intrinsic"(%693, %679, %673) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %695 = "llvm.call_intrinsic"(%694, %678, %674) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %696 = "llvm.call_intrinsic"(%62, %680, %673) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %697 = "llvm.call_intrinsic"(%696, %679, %674) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %698 = "llvm.call_intrinsic"(%62, %675, %672) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %699 = "llvm.shl"(%698, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %700 = "llvm.add"(%699, %683) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %701 = "llvm.call_intrinsic"(%62, %676, %672) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %702 = "llvm.call_intrinsic"(%701, %675, %673) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %703 = "llvm.shl"(%702, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %704 = "llvm.add"(%703, %686) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %705 = "llvm.call_intrinsic"(%62, %677, %672) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %706 = "llvm.call_intrinsic"(%705, %676, %673) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %707 = "llvm.call_intrinsic"(%706, %675, %674) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %708 = "llvm.shl"(%707, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %709 = "llvm.add"(%708, %689) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %710 = "llvm.call_intrinsic"(%62, %678, %672) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %711 = "llvm.call_intrinsic"(%710, %677, %673) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %712 = "llvm.call_intrinsic"(%711, %676, %674) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %713 = "llvm.shl"(%712, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %714 = "llvm.add"(%713, %692) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %715 = "llvm.call_intrinsic"(%62, %679, %672) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %716 = "llvm.call_intrinsic"(%715, %678, %673) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %717 = "llvm.call_intrinsic"(%716, %677, %674) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %718 = "llvm.shl"(%717, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %719 = "llvm.add"(%718, %695) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %720 = "llvm.call_intrinsic"(%62, %680, %672) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %721 = "llvm.call_intrinsic"(%720, %679, %673) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %722 = "llvm.call_intrinsic"(%721, %678, %674) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %723 = "llvm.shl"(%722, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %724 = "llvm.add"(%723, %697) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %725 = "llvm.call_intrinsic"(%62, %680, %673) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %726 = "llvm.call_intrinsic"(%725, %679, %674) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %727 = "llvm.shl"(%726, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %728 = "llvm.call_intrinsic"(%727, %680, %674) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %729 = "llvm.call_intrinsic"(%62, %680, %674) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %730 = "llvm.shl"(%729, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %731 = "llvm.shufflevector"(%709, %57) <{mask = array<i32: 4, 5, 6, 7, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %732 = "llvm.shufflevector"(%714, %57) <{mask = array<i32: 4, 5, 6, 7, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %733 = "llvm.shufflevector"(%719, %57) <{mask = array<i32: 4, 5, 6, 7, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %734 = "llvm.add"(%731, %681) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %735 = "llvm.shufflevector"(%681, %734) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %736 = "llvm.add"(%732, %700) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %737 = "llvm.shufflevector"(%700, %736) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %738 = "llvm.add"(%733, %704) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %739 = "llvm.shufflevector"(%704, %738) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %740 = "llvm.add"(%724, %731) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %741 = "llvm.shufflevector"(%740, %724) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %742 = "llvm.add"(%728, %732) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %743 = "llvm.shufflevector"(%742, %728) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %744 = "llvm.add"(%730, %733) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %745 = "llvm.shufflevector"(%744, %730) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %746 = "llvm.shl"(%741, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %747 = "llvm.add"(%746, %735) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %748 = "llvm.mul"(%741, %23) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %749 = "llvm.add"(%747, %748) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %750 = "llvm.shl"(%743, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %751 = "llvm.add"(%750, %737) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %752 = "llvm.mul"(%743, %23) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %753 = "llvm.add"(%751, %752) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %754 = "llvm.shl"(%745, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %755 = "llvm.add"(%754, %739) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %756 = "llvm.mul"(%745, %23) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %757 = "llvm.add"(%755, %756) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %758 = "llvm.lshr"(%749, %8) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %759 = "llvm.lshr"(%753, %8) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %760 = "llvm.lshr"(%757, %7) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %761 = "llvm.mul"(%760, %172) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %762 = "llvm.and"(%749, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %763 = "llvm.shufflevector"(%761, %760) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %764 = "llvm.add"(%763, %762) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %765 = "llvm.and"(%753, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %766 = "llvm.add"(%765, %758) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %767 = "llvm.and"(%757, %2) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %768 = "llvm.add"(%767, %759) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.cond_br"(%325, %768, %766, %764)[^bb25, ^bb15] <{operandSegmentSizes = array<i32: 1, 3, 0>}> : (i1, vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
^bb15:  // pred: ^bb14
  %769 = "llvm.load"(%326) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "fd_r43x6_ge_decode", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 64>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 128>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 192>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 256>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 320>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 384>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 448>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 512>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 576>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 640>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 704>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 712>, <#llvm.tbaa_type_desc<id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 720>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 712>]}> : (!llvm.ptr) -> i64
  %770 = "llvm.icmp"(%769, %56) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%770)[^bb17, ^bb16] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb16:  // pred: ^bb15
  %771 = "llvm.load"(%arg5) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %772 = "llvm.shufflevector"(%771, %57) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %773 = "llvm.shufflevector"(%771, %57) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 3, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %774 = "llvm.shufflevector"(%771, %57) <{mask = array<i32: 4, 4, 1, 1, 1, 1, 1, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %775 = "llvm.shufflevector"(%771, %57) <{mask = array<i32: 4, 5, 1, 2, 3, 4, 5, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %776 = "llvm.shufflevector"(%771, %57) <{mask = array<i32: 3, 7, 5, 7, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %777 = "llvm.shufflevector"(%771, %57) <{mask = array<i32: 5, 7, 5, 7, 2, 3, 4, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %778 = "llvm.shl"(%772, %58) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %779 = "llvm.shl"(%774, %59) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %780 = "llvm.shl"(%776, %60) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %781 = "llvm.call_intrinsic"(%62, %779, %775) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %782 = "llvm.call_intrinsic"(%62, %780, %777) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %783 = "llvm.call_intrinsic"(%62, %778, %773) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %784 = "llvm.shl"(%783, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %785 = "llvm.call_intrinsic"(%62, %779, %775) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %786 = "llvm.shl"(%785, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %787 = "llvm.call_intrinsic"(%62, %780, %777) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %788 = "llvm.shl"(%787, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %789 = "llvm.and"(%781, %64) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %790 = "llvm.and"(%782, %65) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %791 = "llvm.add"(%790, %789) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %792 = "llvm.call_intrinsic"(%791, %778, %773) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %793 = "llvm.and"(%786, %64) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %794 = "llvm.and"(%788, %65) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %795 = "llvm.add"(%793, %784) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %796 = "llvm.add"(%795, %794) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %797 = "llvm.and"(%781, %76) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %798 = "llvm.and"(%782, %84) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %799 = "llvm.and"(%786, %92) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %800 = "llvm.and"(%788, %100) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %801 = "llvm.add"(%800, %799) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %802 = "llvm.shufflevector"(%108, %796) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %803 = "llvm.add"(%802, %792) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %804 = "llvm.shufflevector"(%108, %801) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %805 = "llvm.shufflevector"(%796, %116) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %806 = "llvm.add"(%798, %797) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %807 = "llvm.add"(%806, %804) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %808 = "llvm.add"(%807, %805) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %809 = "llvm.and"(%803, %25) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %810 = "llvm.shufflevector"(%803, %808) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %811 = "llvm.shl"(%810, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %812 = "llvm.add"(%811, %809) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %813 = "llvm.mul"(%810, %23) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %814 = "llvm.add"(%812, %813) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %815 = "llvm.and"(%814, %22) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %816 = "llvm.lshr"(%814, %21) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %817 = "llvm.shufflevector"(%816, %57) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %818 = "llvm.call_intrinsic"(%815, %20, %817) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %819 = "llvm.shufflevector"(%818, %57) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %820 = "llvm.shufflevector"(%818, %57) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 3, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %821 = "llvm.shufflevector"(%818, %57) <{mask = array<i32: 4, 4, 1, 1, 1, 1, 1, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %822 = "llvm.shufflevector"(%818, %57) <{mask = array<i32: 4, 5, 1, 2, 3, 4, 5, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %823 = "llvm.shufflevector"(%818, %57) <{mask = array<i32: 3, 7, 5, 7, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %824 = "llvm.shufflevector"(%818, %57) <{mask = array<i32: 5, 7, 5, 7, 2, 3, 4, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %825 = "llvm.shl"(%819, %58) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %826 = "llvm.shl"(%821, %59) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %827 = "llvm.shl"(%823, %60) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %828 = "llvm.call_intrinsic"(%62, %826, %822) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %829 = "llvm.call_intrinsic"(%62, %827, %824) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %830 = "llvm.call_intrinsic"(%62, %825, %820) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %831 = "llvm.shl"(%830, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %832 = "llvm.call_intrinsic"(%62, %826, %822) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %833 = "llvm.shl"(%832, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %834 = "llvm.call_intrinsic"(%62, %827, %824) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %835 = "llvm.shl"(%834, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %836 = "llvm.and"(%828, %64) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %837 = "llvm.and"(%829, %65) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %838 = "llvm.add"(%837, %836) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %839 = "llvm.call_intrinsic"(%838, %825, %820) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %840 = "llvm.and"(%833, %64) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %841 = "llvm.and"(%835, %65) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %842 = "llvm.add"(%840, %831) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %843 = "llvm.add"(%842, %841) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %844 = "llvm.and"(%828, %76) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %845 = "llvm.and"(%829, %84) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %846 = "llvm.and"(%833, %92) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %847 = "llvm.and"(%835, %100) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %848 = "llvm.add"(%847, %846) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %849 = "llvm.shufflevector"(%108, %843) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %850 = "llvm.add"(%849, %839) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %851 = "llvm.shufflevector"(%108, %848) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %852 = "llvm.shufflevector"(%843, %116) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %853 = "llvm.add"(%845, %844) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %854 = "llvm.add"(%853, %851) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %855 = "llvm.add"(%854, %852) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %856 = "llvm.and"(%850, %25) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %857 = "llvm.shufflevector"(%850, %855) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %858 = "llvm.shl"(%857, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %859 = "llvm.add"(%858, %856) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %860 = "llvm.mul"(%857, %23) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %861 = "llvm.add"(%859, %860) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %862 = "llvm.and"(%861, %22) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %863 = "llvm.lshr"(%861, %21) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %864 = "llvm.shufflevector"(%863, %57) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %865 = "llvm.call_intrinsic"(%862, %20, %864) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %866 = "llvm.shufflevector"(%865, %57) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %867 = "llvm.shufflevector"(%865, %57) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 3, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %868 = "llvm.shufflevector"(%865, %57) <{mask = array<i32: 4, 4, 1, 1, 1, 1, 1, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %869 = "llvm.shufflevector"(%865, %57) <{mask = array<i32: 4, 5, 1, 2, 3, 4, 5, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %870 = "llvm.shufflevector"(%865, %57) <{mask = array<i32: 3, 7, 5, 7, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %871 = "llvm.shufflevector"(%865, %57) <{mask = array<i32: 5, 7, 5, 7, 2, 3, 4, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %872 = "llvm.shl"(%866, %58) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %873 = "llvm.shl"(%868, %59) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %874 = "llvm.shl"(%870, %60) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %875 = "llvm.call_intrinsic"(%62, %873, %869) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %876 = "llvm.call_intrinsic"(%62, %874, %871) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %877 = "llvm.call_intrinsic"(%62, %872, %867) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %878 = "llvm.shl"(%877, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %879 = "llvm.call_intrinsic"(%62, %873, %869) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %880 = "llvm.shl"(%879, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %881 = "llvm.call_intrinsic"(%62, %874, %871) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %882 = "llvm.shl"(%881, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %883 = "llvm.and"(%875, %64) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %884 = "llvm.and"(%876, %65) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %885 = "llvm.add"(%884, %883) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %886 = "llvm.call_intrinsic"(%885, %872, %867) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %887 = "llvm.and"(%880, %64) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %888 = "llvm.and"(%882, %65) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %889 = "llvm.add"(%887, %878) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %890 = "llvm.add"(%889, %888) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %891 = "llvm.and"(%875, %76) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %892 = "llvm.and"(%876, %84) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %893 = "llvm.and"(%880, %92) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %894 = "llvm.and"(%882, %100) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %895 = "llvm.add"(%894, %893) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %896 = "llvm.shufflevector"(%108, %890) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %897 = "llvm.add"(%896, %886) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %898 = "llvm.shufflevector"(%108, %895) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %899 = "llvm.shufflevector"(%890, %116) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %900 = "llvm.add"(%892, %891) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %901 = "llvm.add"(%900, %898) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %902 = "llvm.add"(%901, %899) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %903 = "llvm.and"(%897, %25) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %904 = "llvm.shufflevector"(%897, %902) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %905 = "llvm.shl"(%904, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %906 = "llvm.add"(%905, %903) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %907 = "llvm.mul"(%904, %23) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %908 = "llvm.add"(%906, %907) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %909 = "llvm.and"(%908, %22) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %910 = "llvm.lshr"(%908, %21) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %911 = "llvm.shufflevector"(%910, %57) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %912 = "llvm.call_intrinsic"(%909, %20, %911) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%912, %arg5) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %913 = "llvm.add"(%769, %19) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%913, %326) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "fd_r43x6_ge_decode", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 64>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 128>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 192>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 256>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 320>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 384>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 448>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 512>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 576>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 640>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 704>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 712>, <#llvm.tbaa_type_desc<id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 720>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 712>]}> : (i64, !llvm.ptr) -> ()
  "llvm.br"(%768, %766, %764)[^bb25] : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
^bb17:  // pred: ^bb15
  %914 = "llvm.load"(%327) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "fd_r43x6_ge_decode", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 64>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 128>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 192>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 256>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 320>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 384>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 448>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 512>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 576>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 640>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 704>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 712>, <#llvm.tbaa_type_desc<id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 720>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 704>]}> : (!llvm.ptr) -> i64
  %915 = "llvm.icmp"(%914, %18) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%915, %768, %766, %764)[^bb18, ^bb25] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 3>}> : (i1, vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
^bb18:  // pred: ^bb17
  "llvm.call"(%arg5, %56) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_ge_decode_step_slow, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, i64) -> ()
  "llvm.br"(%768, %766, %764)[^bb25] : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
^bb19:  // pred: ^bb13
  %916 = "llvm.icmp"(%492, %47) <{predicate = 2 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%916, %486, %487, %488)[^bb20, ^bb25] <{operandSegmentSizes = array<i32: 1, 0, 3>}> : (i1, vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
^bb20:  // pred: ^bb19
  "llvm.store"(%488, %arg0) <{alias_scopes = [#llvm.alias_scope<id = distinct[2]<>, domain = <id = distinct[3]<>, description = "fd_ed25519_point_add_final_mul">, description = "fd_ed25519_point_add_final_mul: argument 0">], alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%487, %208) <{alias_scopes = [#llvm.alias_scope<id = distinct[2]<>, domain = <id = distinct[3]<>, description = "fd_ed25519_point_add_final_mul">, description = "fd_ed25519_point_add_final_mul: argument 0">], alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%486, %330) <{alias_scopes = [#llvm.alias_scope<id = distinct[2]<>, domain = <id = distinct[3]<>, description = "fd_ed25519_point_add_final_mul">, description = "fd_ed25519_point_add_final_mul: argument 0">], alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %917 = "llvm.sub"(%68, %495) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %918 = "llvm.lshr"(%917, %31) : (i32, i32) -> i32
  %919 = "llvm.trunc"(%485) <{overflowFlags = 0 : i32}> : (i64) -> i32
  %920 = "llvm.shl"(%919, %30) <{overflowFlags = 0 : i32}> : (i32, i32) -> i32
  %921 = "llvm.add"(%918, %920) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %922 = "llvm.zext"(%921) <{nonNeg}> : (i32) -> i64
  %923 = "llvm.getelementptr"(%arg2, %922) <{elem_type = !llvm.array<192 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %924 = "llvm.load"(%923) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %925 = "llvm.getelementptr"(%923) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %926 = "llvm.load"(%925) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %927 = "llvm.getelementptr"(%923) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %928 = "llvm.load"(%927) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %929 = "llvm.sub"(%124, %924) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %930 = "llvm.sub"(%132, %926) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %931 = "llvm.sub"(%140, %928) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %932 = "llvm.shufflevector"(%924, %929) <{mask = array<i32: 1, 0, 2, 11, 5, 4, 6, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %933 = "llvm.shufflevector"(%926, %930) <{mask = array<i32: 1, 0, 2, 11, 5, 4, 6, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %934 = "llvm.shufflevector"(%928, %931) <{mask = array<i32: 1, 0, 2, 11, 5, 4, 6, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %935 = "llvm.shufflevector"(%488, %57) <{mask = array<i32: 1, -1, -1, -1, 5, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %936 = "llvm.shufflevector"(%487, %57) <{mask = array<i32: 1, -1, -1, -1, 5, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %937 = "llvm.shufflevector"(%486, %57) <{mask = array<i32: 1, -1, -1, -1, 5, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %938 = "llvm.sub"(%935, %488) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %939 = "llvm.add"(%938, %148) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %940 = "llvm.shufflevector"(%939, %488) <{mask = array<i32: 0, 8, 10, 11, 4, 12, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %941 = "llvm.sub"(%936, %487) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %942 = "llvm.add"(%941, %156) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %943 = "llvm.shufflevector"(%942, %487) <{mask = array<i32: 0, 8, 10, 11, 4, 12, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %944 = "llvm.sub"(%937, %486) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %945 = "llvm.add"(%944, %164) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %946 = "llvm.shufflevector"(%945, %486) <{mask = array<i32: 0, 8, 10, 11, 4, 12, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %947 = "llvm.add"(%940, %488) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %948 = "llvm.shufflevector"(%940, %947) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %949 = "llvm.add"(%943, %487) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %950 = "llvm.shufflevector"(%943, %949) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %951 = "llvm.add"(%946, %486) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %952 = "llvm.shufflevector"(%946, %951) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %953 = "llvm.add"(%948, %10) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %954 = "llvm.add"(%950, %9) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %955 = "llvm.add"(%952, %9) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %956 = "llvm.ashr"(%953, %8) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %957 = "llvm.ashr"(%954, %8) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %958 = "llvm.ashr"(%955, %7) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %959 = "llvm.mul"(%958, %172) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %960 = "llvm.and"(%953, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %961 = "llvm.shufflevector"(%959, %958) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %962 = "llvm.add"(%960, %4) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %963 = "llvm.add"(%962, %961) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %964 = "llvm.and"(%954, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %965 = "llvm.add"(%956, %3) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %966 = "llvm.add"(%965, %964) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %967 = "llvm.and"(%955, %2) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %968 = "llvm.add"(%957, %3) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %969 = "llvm.add"(%968, %967) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %970 = "llvm.shufflevector"(%932, %57) <{mask = array<i32: 0, 1, 2, 3, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %971 = "llvm.shufflevector"(%933, %57) <{mask = array<i32: 0, 1, 2, 3, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %972 = "llvm.shufflevector"(%934, %57) <{mask = array<i32: 0, 1, 2, 3, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %973 = "llvm.shufflevector"(%932, %57) <{mask = array<i32: 4, 5, 6, 7, 4, 5, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %974 = "llvm.shufflevector"(%933, %57) <{mask = array<i32: 4, 5, 6, 7, 4, 5, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %975 = "llvm.shufflevector"(%934, %57) <{mask = array<i32: 4, 5, 6, 7, 4, 5, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %976 = "llvm.call_intrinsic"(%62, %970, %963) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %977 = "llvm.call_intrinsic"(%62, %971, %963) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %978 = "llvm.call_intrinsic"(%977, %970, %966) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %979 = "llvm.call_intrinsic"(%62, %972, %963) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %980 = "llvm.call_intrinsic"(%979, %971, %966) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %981 = "llvm.call_intrinsic"(%980, %970, %969) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %982 = "llvm.call_intrinsic"(%62, %973, %963) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %983 = "llvm.call_intrinsic"(%982, %972, %966) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %984 = "llvm.call_intrinsic"(%983, %971, %969) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %985 = "llvm.call_intrinsic"(%62, %974, %963) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %986 = "llvm.call_intrinsic"(%985, %973, %966) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %987 = "llvm.call_intrinsic"(%986, %972, %969) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %988 = "llvm.call_intrinsic"(%62, %975, %963) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %989 = "llvm.call_intrinsic"(%988, %974, %966) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %990 = "llvm.call_intrinsic"(%989, %973, %969) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %991 = "llvm.call_intrinsic"(%62, %975, %966) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %992 = "llvm.call_intrinsic"(%991, %974, %969) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %993 = "llvm.call_intrinsic"(%62, %970, %963) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %994 = "llvm.shl"(%993, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %995 = "llvm.add"(%994, %978) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %996 = "llvm.call_intrinsic"(%62, %971, %963) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %997 = "llvm.call_intrinsic"(%996, %970, %966) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %998 = "llvm.shl"(%997, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %999 = "llvm.add"(%998, %981) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1000 = "llvm.call_intrinsic"(%62, %972, %963) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1001 = "llvm.call_intrinsic"(%1000, %971, %966) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1002 = "llvm.call_intrinsic"(%1001, %970, %969) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1003 = "llvm.shl"(%1002, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1004 = "llvm.add"(%1003, %984) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1005 = "llvm.call_intrinsic"(%62, %973, %963) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1006 = "llvm.call_intrinsic"(%1005, %972, %966) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1007 = "llvm.call_intrinsic"(%1006, %971, %969) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1008 = "llvm.shl"(%1007, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1009 = "llvm.add"(%1008, %987) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1010 = "llvm.call_intrinsic"(%62, %974, %963) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1011 = "llvm.call_intrinsic"(%1010, %973, %966) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1012 = "llvm.call_intrinsic"(%1011, %972, %969) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1013 = "llvm.shl"(%1012, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1014 = "llvm.add"(%1013, %990) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1015 = "llvm.call_intrinsic"(%62, %975, %963) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1016 = "llvm.call_intrinsic"(%1015, %974, %966) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1017 = "llvm.call_intrinsic"(%1016, %973, %969) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1018 = "llvm.shl"(%1017, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1019 = "llvm.add"(%1018, %992) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1020 = "llvm.call_intrinsic"(%62, %975, %966) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1021 = "llvm.call_intrinsic"(%1020, %974, %969) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1022 = "llvm.shl"(%1021, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1023 = "llvm.call_intrinsic"(%1022, %975, %969) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1024 = "llvm.call_intrinsic"(%62, %975, %969) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1025 = "llvm.shl"(%1024, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1026 = "llvm.shufflevector"(%1004, %57) <{mask = array<i32: 4, 5, 6, 7, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1027 = "llvm.shufflevector"(%1009, %57) <{mask = array<i32: 4, 5, 6, 7, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1028 = "llvm.shufflevector"(%1014, %57) <{mask = array<i32: 4, 5, 6, 7, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1029 = "llvm.add"(%1026, %976) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1030 = "llvm.shufflevector"(%976, %1029) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1031 = "llvm.add"(%1027, %995) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1032 = "llvm.shufflevector"(%995, %1031) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1033 = "llvm.add"(%1028, %999) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1034 = "llvm.shufflevector"(%999, %1033) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1035 = "llvm.add"(%1019, %1026) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1036 = "llvm.shufflevector"(%1035, %1019) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1037 = "llvm.add"(%1023, %1027) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1038 = "llvm.shufflevector"(%1037, %1023) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1039 = "llvm.add"(%1025, %1028) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1040 = "llvm.shufflevector"(%1039, %1025) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1041 = "llvm.shl"(%1036, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1042 = "llvm.add"(%1041, %1030) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1043 = "llvm.mul"(%1036, %23) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1044 = "llvm.add"(%1042, %1043) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1045 = "llvm.shl"(%1038, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1046 = "llvm.add"(%1045, %1032) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1047 = "llvm.mul"(%1038, %23) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1048 = "llvm.add"(%1046, %1047) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1049 = "llvm.shl"(%1040, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1050 = "llvm.add"(%1049, %1034) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1051 = "llvm.mul"(%1040, %23) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1052 = "llvm.add"(%1050, %1051) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1053 = "llvm.lshr"(%1044, %8) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1054 = "llvm.lshr"(%1048, %8) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1055 = "llvm.lshr"(%1052, %7) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1056 = "llvm.mul"(%1055, %172) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1057 = "llvm.and"(%1044, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1058 = "llvm.shufflevector"(%1056, %1055) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1059 = "llvm.add"(%1058, %1057) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1060 = "llvm.and"(%1048, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1061 = "llvm.add"(%1060, %1053) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1062 = "llvm.and"(%1052, %2) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1063 = "llvm.add"(%1062, %1054) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1064 = "llvm.shufflevector"(%1059, %57) <{mask = array<i32: 1, -1, -1, 2, 5, -1, -1, 6>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1065 = "llvm.shufflevector"(%1061, %57) <{mask = array<i32: 1, -1, -1, 2, 5, -1, -1, 6>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1066 = "llvm.shufflevector"(%1063, %57) <{mask = array<i32: 1, -1, -1, 2, 5, -1, -1, 6>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1067 = "llvm.sub"(%1064, %1059) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1068 = "llvm.add"(%1067, %180) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1069 = "llvm.shufflevector"(%1059, %57) <{mask = array<i32: -1, 0, 3, -1, -1, 4, 7, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1070 = "llvm.sub"(%1065, %1061) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1071 = "llvm.add"(%1070, %188) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1072 = "llvm.shufflevector"(%1061, %57) <{mask = array<i32: -1, 0, 3, -1, -1, 4, 7, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1073 = "llvm.sub"(%1066, %1063) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1074 = "llvm.add"(%1073, %196) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1075 = "llvm.shufflevector"(%1063, %57) <{mask = array<i32: -1, 0, 3, -1, -1, 4, 7, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1076 = "llvm.add"(%1069, %1059) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1077 = "llvm.shufflevector"(%1068, %1076) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1078 = "llvm.add"(%1072, %1061) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1079 = "llvm.shufflevector"(%1071, %1078) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1080 = "llvm.add"(%1075, %1063) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1081 = "llvm.shufflevector"(%1074, %1080) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1082 = "llvm.add"(%1077, %10) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1083 = "llvm.add"(%1079, %9) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1084 = "llvm.add"(%1081, %9) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1085 = "llvm.ashr"(%1082, %8) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1086 = "llvm.ashr"(%1084, %7) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1087 = "llvm.mul"(%1086, %172) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1088 = "llvm.and"(%1082, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1089 = "llvm.shufflevector"(%1087, %1086) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1090 = "llvm.add"(%1089, %4) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1091 = "llvm.add"(%1090, %1088) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1092 = "llvm.and"(%1083, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1093 = "llvm.ashr"(%1083, %8) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1094 = "llvm.add"(%1092, %3) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1095 = "llvm.add"(%1094, %1085) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1096 = "llvm.and"(%1084, %2) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1097 = "llvm.add"(%1093, %3) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1098 = "llvm.add"(%1097, %1096) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1099 = "llvm.shufflevector"(%1091, %57) <{mask = array<i32: 3, 1, 3, 1, 7, 5, 7, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1100 = "llvm.shufflevector"(%1095, %57) <{mask = array<i32: 3, 1, 3, 1, 7, 5, 7, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1101 = "llvm.shufflevector"(%1098, %57) <{mask = array<i32: 3, 1, 3, 1, 7, 5, 7, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1102 = "llvm.shufflevector"(%1091, %57) <{mask = array<i32: 0, 2, 2, 0, 0, 2, 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1103 = "llvm.shufflevector"(%1095, %57) <{mask = array<i32: 0, 2, 2, 0, 0, 2, 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1104 = "llvm.shufflevector"(%1098, %57) <{mask = array<i32: 0, 2, 2, 0, 0, 2, 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1105 = "llvm.shufflevector"(%1091, %57) <{mask = array<i32: 4, 6, 6, 4, 4, 6, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1106 = "llvm.shufflevector"(%1095, %57) <{mask = array<i32: 4, 6, 6, 4, 4, 6, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1107 = "llvm.shufflevector"(%1098, %57) <{mask = array<i32: 4, 6, 6, 4, 4, 6, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1108 = "llvm.call_intrinsic"(%62, %1102, %1099) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1109 = "llvm.call_intrinsic"(%62, %1103, %1099) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1110 = "llvm.call_intrinsic"(%1109, %1102, %1100) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1111 = "llvm.call_intrinsic"(%62, %1104, %1099) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1112 = "llvm.call_intrinsic"(%1111, %1103, %1100) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1113 = "llvm.call_intrinsic"(%1112, %1102, %1101) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1114 = "llvm.call_intrinsic"(%62, %1105, %1099) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1115 = "llvm.call_intrinsic"(%1114, %1104, %1100) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1116 = "llvm.call_intrinsic"(%1115, %1103, %1101) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1117 = "llvm.call_intrinsic"(%62, %1106, %1099) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1118 = "llvm.call_intrinsic"(%1117, %1105, %1100) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1119 = "llvm.call_intrinsic"(%1118, %1104, %1101) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1120 = "llvm.call_intrinsic"(%62, %1107, %1099) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1121 = "llvm.call_intrinsic"(%1120, %1106, %1100) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1122 = "llvm.call_intrinsic"(%1121, %1105, %1101) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1123 = "llvm.call_intrinsic"(%62, %1107, %1100) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1124 = "llvm.call_intrinsic"(%1123, %1106, %1101) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1125 = "llvm.call_intrinsic"(%62, %1102, %1099) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1126 = "llvm.shl"(%1125, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1127 = "llvm.add"(%1126, %1110) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1128 = "llvm.call_intrinsic"(%62, %1103, %1099) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1129 = "llvm.call_intrinsic"(%1128, %1102, %1100) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1130 = "llvm.shl"(%1129, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1131 = "llvm.add"(%1130, %1113) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1132 = "llvm.call_intrinsic"(%62, %1104, %1099) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1133 = "llvm.call_intrinsic"(%1132, %1103, %1100) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1134 = "llvm.call_intrinsic"(%1133, %1102, %1101) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1135 = "llvm.shl"(%1134, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1136 = "llvm.add"(%1135, %1116) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1137 = "llvm.call_intrinsic"(%62, %1105, %1099) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1138 = "llvm.call_intrinsic"(%1137, %1104, %1100) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1139 = "llvm.call_intrinsic"(%1138, %1103, %1101) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1140 = "llvm.shl"(%1139, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1141 = "llvm.add"(%1140, %1119) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1142 = "llvm.call_intrinsic"(%62, %1106, %1099) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1143 = "llvm.call_intrinsic"(%1142, %1105, %1100) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1144 = "llvm.call_intrinsic"(%1143, %1104, %1101) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1145 = "llvm.shl"(%1144, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1146 = "llvm.add"(%1145, %1122) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1147 = "llvm.call_intrinsic"(%62, %1107, %1099) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1148 = "llvm.call_intrinsic"(%1147, %1106, %1100) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1149 = "llvm.call_intrinsic"(%1148, %1105, %1101) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1150 = "llvm.shl"(%1149, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1151 = "llvm.add"(%1150, %1124) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1152 = "llvm.call_intrinsic"(%62, %1107, %1100) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1153 = "llvm.call_intrinsic"(%1152, %1106, %1101) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1154 = "llvm.shl"(%1153, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1155 = "llvm.call_intrinsic"(%1154, %1107, %1101) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1156 = "llvm.call_intrinsic"(%62, %1107, %1101) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1157 = "llvm.shl"(%1156, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1158 = "llvm.shufflevector"(%1136, %57) <{mask = array<i32: 4, 5, 6, 7, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1159 = "llvm.shufflevector"(%1141, %57) <{mask = array<i32: 4, 5, 6, 7, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1160 = "llvm.shufflevector"(%1146, %57) <{mask = array<i32: 4, 5, 6, 7, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1161 = "llvm.add"(%1158, %1108) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1162 = "llvm.shufflevector"(%1108, %1161) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1163 = "llvm.add"(%1159, %1127) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1164 = "llvm.shufflevector"(%1127, %1163) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1165 = "llvm.add"(%1160, %1131) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1166 = "llvm.shufflevector"(%1131, %1165) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1167 = "llvm.add"(%1151, %1158) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1168 = "llvm.shufflevector"(%1167, %1151) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1169 = "llvm.add"(%1155, %1159) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1170 = "llvm.shufflevector"(%1169, %1155) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1171 = "llvm.add"(%1157, %1160) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1172 = "llvm.shufflevector"(%1171, %1157) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1173 = "llvm.shl"(%1168, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1174 = "llvm.add"(%1173, %1162) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1175 = "llvm.mul"(%1168, %23) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1176 = "llvm.add"(%1174, %1175) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1177 = "llvm.shl"(%1170, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1178 = "llvm.add"(%1177, %1164) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1179 = "llvm.mul"(%1170, %23) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1180 = "llvm.add"(%1178, %1179) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1181 = "llvm.shl"(%1172, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1182 = "llvm.add"(%1181, %1166) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1183 = "llvm.mul"(%1172, %23) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1184 = "llvm.add"(%1182, %1183) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1185 = "llvm.lshr"(%1176, %8) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1186 = "llvm.lshr"(%1180, %8) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1187 = "llvm.lshr"(%1184, %7) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1188 = "llvm.mul"(%1187, %172) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1189 = "llvm.and"(%1176, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1190 = "llvm.shufflevector"(%1188, %1187) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1191 = "llvm.add"(%1190, %1189) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1192 = "llvm.and"(%1180, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1193 = "llvm.add"(%1192, %1185) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1194 = "llvm.and"(%1184, %2) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1195 = "llvm.add"(%1194, %1186) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.cond_br"(%325, %1195, %1193, %1191)[^bb25, ^bb21] <{operandSegmentSizes = array<i32: 1, 3, 0>}> : (i1, vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
^bb21:  // pred: ^bb20
  %1196 = "llvm.load"(%326) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "fd_r43x6_ge_decode", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 64>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 128>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 192>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 256>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 320>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 384>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 448>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 512>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 576>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 640>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 704>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 712>, <#llvm.tbaa_type_desc<id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 720>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 712>]}> : (!llvm.ptr) -> i64
  %1197 = "llvm.icmp"(%1196, %56) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1197)[^bb23, ^bb22] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb22:  // pred: ^bb21
  %1198 = "llvm.load"(%arg5) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1199 = "llvm.shufflevector"(%1198, %57) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1200 = "llvm.shufflevector"(%1198, %57) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 3, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1201 = "llvm.shufflevector"(%1198, %57) <{mask = array<i32: 4, 4, 1, 1, 1, 1, 1, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1202 = "llvm.shufflevector"(%1198, %57) <{mask = array<i32: 4, 5, 1, 2, 3, 4, 5, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1203 = "llvm.shufflevector"(%1198, %57) <{mask = array<i32: 3, 7, 5, 7, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1204 = "llvm.shufflevector"(%1198, %57) <{mask = array<i32: 5, 7, 5, 7, 2, 3, 4, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1205 = "llvm.shl"(%1199, %58) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1206 = "llvm.shl"(%1201, %59) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1207 = "llvm.shl"(%1203, %60) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1208 = "llvm.call_intrinsic"(%62, %1206, %1202) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1209 = "llvm.call_intrinsic"(%62, %1207, %1204) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1210 = "llvm.call_intrinsic"(%62, %1205, %1200) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1211 = "llvm.shl"(%1210, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1212 = "llvm.call_intrinsic"(%62, %1206, %1202) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1213 = "llvm.shl"(%1212, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1214 = "llvm.call_intrinsic"(%62, %1207, %1204) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1215 = "llvm.shl"(%1214, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1216 = "llvm.and"(%1208, %64) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1217 = "llvm.and"(%1209, %65) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1218 = "llvm.add"(%1217, %1216) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1219 = "llvm.call_intrinsic"(%1218, %1205, %1200) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1220 = "llvm.and"(%1213, %64) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1221 = "llvm.and"(%1215, %65) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1222 = "llvm.add"(%1220, %1211) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1223 = "llvm.add"(%1222, %1221) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1224 = "llvm.and"(%1208, %76) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1225 = "llvm.and"(%1209, %84) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1226 = "llvm.and"(%1213, %92) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1227 = "llvm.and"(%1215, %100) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1228 = "llvm.add"(%1227, %1226) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1229 = "llvm.shufflevector"(%108, %1223) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1230 = "llvm.add"(%1229, %1219) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1231 = "llvm.shufflevector"(%108, %1228) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1232 = "llvm.shufflevector"(%1223, %116) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1233 = "llvm.add"(%1225, %1224) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1234 = "llvm.add"(%1233, %1231) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1235 = "llvm.add"(%1234, %1232) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1236 = "llvm.and"(%1230, %25) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1237 = "llvm.shufflevector"(%1230, %1235) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1238 = "llvm.shl"(%1237, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1239 = "llvm.add"(%1238, %1236) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1240 = "llvm.mul"(%1237, %23) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1241 = "llvm.add"(%1239, %1240) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1242 = "llvm.and"(%1241, %22) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1243 = "llvm.lshr"(%1241, %21) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1244 = "llvm.shufflevector"(%1243, %57) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1245 = "llvm.call_intrinsic"(%1242, %20, %1244) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1246 = "llvm.shufflevector"(%1245, %57) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1247 = "llvm.shufflevector"(%1245, %57) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 3, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1248 = "llvm.shufflevector"(%1245, %57) <{mask = array<i32: 4, 4, 1, 1, 1, 1, 1, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1249 = "llvm.shufflevector"(%1245, %57) <{mask = array<i32: 4, 5, 1, 2, 3, 4, 5, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1250 = "llvm.shufflevector"(%1245, %57) <{mask = array<i32: 3, 7, 5, 7, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1251 = "llvm.shufflevector"(%1245, %57) <{mask = array<i32: 5, 7, 5, 7, 2, 3, 4, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1252 = "llvm.shl"(%1246, %58) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1253 = "llvm.shl"(%1248, %59) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1254 = "llvm.shl"(%1250, %60) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1255 = "llvm.call_intrinsic"(%62, %1253, %1249) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1256 = "llvm.call_intrinsic"(%62, %1254, %1251) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1257 = "llvm.call_intrinsic"(%62, %1252, %1247) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1258 = "llvm.shl"(%1257, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1259 = "llvm.call_intrinsic"(%62, %1253, %1249) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1260 = "llvm.shl"(%1259, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1261 = "llvm.call_intrinsic"(%62, %1254, %1251) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1262 = "llvm.shl"(%1261, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1263 = "llvm.and"(%1255, %64) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1264 = "llvm.and"(%1256, %65) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1265 = "llvm.add"(%1264, %1263) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1266 = "llvm.call_intrinsic"(%1265, %1252, %1247) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1267 = "llvm.and"(%1260, %64) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1268 = "llvm.and"(%1262, %65) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1269 = "llvm.add"(%1267, %1258) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1270 = "llvm.add"(%1269, %1268) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1271 = "llvm.and"(%1255, %76) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1272 = "llvm.and"(%1256, %84) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1273 = "llvm.and"(%1260, %92) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1274 = "llvm.and"(%1262, %100) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1275 = "llvm.add"(%1274, %1273) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1276 = "llvm.shufflevector"(%108, %1270) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1277 = "llvm.add"(%1276, %1266) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1278 = "llvm.shufflevector"(%108, %1275) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1279 = "llvm.shufflevector"(%1270, %116) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1280 = "llvm.add"(%1272, %1271) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1281 = "llvm.add"(%1280, %1278) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1282 = "llvm.add"(%1281, %1279) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1283 = "llvm.and"(%1277, %25) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1284 = "llvm.shufflevector"(%1277, %1282) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1285 = "llvm.shl"(%1284, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1286 = "llvm.add"(%1285, %1283) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1287 = "llvm.mul"(%1284, %23) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1288 = "llvm.add"(%1286, %1287) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1289 = "llvm.and"(%1288, %22) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1290 = "llvm.lshr"(%1288, %21) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1291 = "llvm.shufflevector"(%1290, %57) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1292 = "llvm.call_intrinsic"(%1289, %20, %1291) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1293 = "llvm.shufflevector"(%1292, %57) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1294 = "llvm.shufflevector"(%1292, %57) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 3, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1295 = "llvm.shufflevector"(%1292, %57) <{mask = array<i32: 4, 4, 1, 1, 1, 1, 1, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1296 = "llvm.shufflevector"(%1292, %57) <{mask = array<i32: 4, 5, 1, 2, 3, 4, 5, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1297 = "llvm.shufflevector"(%1292, %57) <{mask = array<i32: 3, 7, 5, 7, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1298 = "llvm.shufflevector"(%1292, %57) <{mask = array<i32: 5, 7, 5, 7, 2, 3, 4, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1299 = "llvm.shl"(%1293, %58) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1300 = "llvm.shl"(%1295, %59) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1301 = "llvm.shl"(%1297, %60) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1302 = "llvm.call_intrinsic"(%62, %1300, %1296) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1303 = "llvm.call_intrinsic"(%62, %1301, %1298) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1304 = "llvm.call_intrinsic"(%62, %1299, %1294) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1305 = "llvm.shl"(%1304, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1306 = "llvm.call_intrinsic"(%62, %1300, %1296) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1307 = "llvm.shl"(%1306, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1308 = "llvm.call_intrinsic"(%62, %1301, %1298) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1309 = "llvm.shl"(%1308, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1310 = "llvm.and"(%1302, %64) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1311 = "llvm.and"(%1303, %65) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1312 = "llvm.add"(%1311, %1310) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1313 = "llvm.call_intrinsic"(%1312, %1299, %1294) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1314 = "llvm.and"(%1307, %64) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1315 = "llvm.and"(%1309, %65) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1316 = "llvm.add"(%1314, %1305) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1317 = "llvm.add"(%1316, %1315) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1318 = "llvm.and"(%1302, %76) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1319 = "llvm.and"(%1303, %84) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1320 = "llvm.and"(%1307, %92) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1321 = "llvm.and"(%1309, %100) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1322 = "llvm.add"(%1321, %1320) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1323 = "llvm.shufflevector"(%108, %1317) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1324 = "llvm.add"(%1323, %1313) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1325 = "llvm.shufflevector"(%108, %1322) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1326 = "llvm.shufflevector"(%1317, %116) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1327 = "llvm.add"(%1319, %1318) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1328 = "llvm.add"(%1327, %1325) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1329 = "llvm.add"(%1328, %1326) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1330 = "llvm.and"(%1324, %25) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1331 = "llvm.shufflevector"(%1324, %1329) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1332 = "llvm.shl"(%1331, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1333 = "llvm.add"(%1332, %1330) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1334 = "llvm.mul"(%1331, %23) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1335 = "llvm.add"(%1333, %1334) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1336 = "llvm.and"(%1335, %22) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1337 = "llvm.lshr"(%1335, %21) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1338 = "llvm.shufflevector"(%1337, %57) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1339 = "llvm.call_intrinsic"(%1336, %20, %1338) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1339, %arg5) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1340 = "llvm.add"(%1196, %19) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%1340, %326) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "fd_r43x6_ge_decode", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 64>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 128>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 192>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 256>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 320>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 384>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 448>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 512>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 576>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 640>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 704>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 712>, <#llvm.tbaa_type_desc<id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 720>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 712>]}> : (i64, !llvm.ptr) -> ()
  "llvm.br"(%1195, %1193, %1191)[^bb25] : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
^bb23:  // pred: ^bb21
  %1341 = "llvm.load"(%327) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "fd_r43x6_ge_decode", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 64>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 128>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 192>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 256>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 320>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 384>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 448>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 512>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 576>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 640>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 704>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 712>, <#llvm.tbaa_type_desc<id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 720>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 704>]}> : (!llvm.ptr) -> i64
  %1342 = "llvm.icmp"(%1341, %18) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1342, %1195, %1193, %1191)[^bb24, ^bb25] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 3>}> : (i1, vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
^bb24:  // pred: ^bb23
  "llvm.call"(%arg5, %56) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_ge_decode_step_slow, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, i64) -> ()
  "llvm.br"(%1195, %1193, %1191)[^bb25] : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
^bb25(%1343: vector<8xi64>, %1344: vector<8xi64>, %1345: vector<8xi64>):  // 9 preds: ^bb14, ^bb16, ^bb17, ^bb18, ^bb19, ^bb20, ^bb22, ^bb23, ^bb24
  %1346 = "llvm.sext"(%494) : (i16) -> i32
  %1347 = "llvm.icmp"(%494, %47) <{predicate = 4 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%1347)[^bb26, ^bb31] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb26:  // pred: ^bb25
  "llvm.store"(%1345, %arg0) <{alias_scopes = [#llvm.alias_scope<id = distinct[4]<>, domain = <id = distinct[5]<>, description = "fd_ed25519_point_add_final_mul">, description = "fd_ed25519_point_add_final_mul: argument 0">], alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%1344, %208) <{alias_scopes = [#llvm.alias_scope<id = distinct[4]<>, domain = <id = distinct[5]<>, description = "fd_ed25519_point_add_final_mul">, description = "fd_ed25519_point_add_final_mul: argument 0">], alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%1343, %330) <{alias_scopes = [#llvm.alias_scope<id = distinct[4]<>, domain = <id = distinct[5]<>, description = "fd_ed25519_point_add_final_mul">, description = "fd_ed25519_point_add_final_mul: argument 0">], alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1348 = "llvm.getelementptr"(%199, %485) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1349 = "llvm.load"(%1348) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 _ZTS21fd_curve25519_edwards", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 _ZTS21fd_curve25519_edwards", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %1350 = "llvm.lshr"(%1346, %31) : (i32, i32) -> i32
  %1351 = "llvm.zext"(%1350) <{nonNeg}> : (i32) -> i64
  %1352 = "llvm.getelementptr"(%1349, %1351) <{elem_type = !llvm.array<192 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1353 = "llvm.load"(%1352) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1354 = "llvm.getelementptr"(%1352) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %1355 = "llvm.load"(%1354) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1356 = "llvm.getelementptr"(%1352) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %1357 = "llvm.load"(%1356) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1358 = "llvm.shufflevector"(%1345, %57) <{mask = array<i32: 1, -1, -1, -1, 5, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1359 = "llvm.shufflevector"(%1344, %57) <{mask = array<i32: 1, -1, -1, -1, 5, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1360 = "llvm.shufflevector"(%1343, %57) <{mask = array<i32: 1, -1, -1, -1, 5, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1361 = "llvm.sub"(%1358, %1345) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1362 = "llvm.add"(%1361, %148) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1363 = "llvm.shufflevector"(%1362, %1345) <{mask = array<i32: 0, 8, 10, 11, 4, 12, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1364 = "llvm.sub"(%1359, %1344) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1365 = "llvm.add"(%1364, %156) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1366 = "llvm.shufflevector"(%1365, %1344) <{mask = array<i32: 0, 8, 10, 11, 4, 12, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1367 = "llvm.sub"(%1360, %1343) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1368 = "llvm.add"(%1367, %164) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1369 = "llvm.shufflevector"(%1368, %1343) <{mask = array<i32: 0, 8, 10, 11, 4, 12, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1370 = "llvm.add"(%1363, %1345) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1371 = "llvm.shufflevector"(%1363, %1370) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1372 = "llvm.add"(%1366, %1344) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1373 = "llvm.shufflevector"(%1366, %1372) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1374 = "llvm.add"(%1369, %1343) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1375 = "llvm.shufflevector"(%1369, %1374) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1376 = "llvm.add"(%1371, %10) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1377 = "llvm.add"(%1373, %9) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1378 = "llvm.add"(%1375, %9) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1379 = "llvm.ashr"(%1376, %8) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1380 = "llvm.ashr"(%1377, %8) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1381 = "llvm.ashr"(%1378, %7) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1382 = "llvm.mul"(%1381, %172) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1383 = "llvm.and"(%1376, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1384 = "llvm.shufflevector"(%1382, %1381) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1385 = "llvm.add"(%1383, %4) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1386 = "llvm.add"(%1385, %1384) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1387 = "llvm.and"(%1377, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1388 = "llvm.add"(%1379, %3) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1389 = "llvm.add"(%1388, %1387) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1390 = "llvm.and"(%1378, %2) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1391 = "llvm.add"(%1380, %3) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1392 = "llvm.add"(%1391, %1390) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1393 = "llvm.shufflevector"(%1353, %57) <{mask = array<i32: 0, 1, 2, 3, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1394 = "llvm.shufflevector"(%1355, %57) <{mask = array<i32: 0, 1, 2, 3, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1395 = "llvm.shufflevector"(%1357, %57) <{mask = array<i32: 0, 1, 2, 3, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1396 = "llvm.shufflevector"(%1353, %57) <{mask = array<i32: 4, 5, 6, 7, 4, 5, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1397 = "llvm.shufflevector"(%1355, %57) <{mask = array<i32: 4, 5, 6, 7, 4, 5, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1398 = "llvm.shufflevector"(%1357, %57) <{mask = array<i32: 4, 5, 6, 7, 4, 5, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1399 = "llvm.call_intrinsic"(%62, %1393, %1386) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1400 = "llvm.call_intrinsic"(%62, %1394, %1386) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1401 = "llvm.call_intrinsic"(%1400, %1393, %1389) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1402 = "llvm.call_intrinsic"(%62, %1395, %1386) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1403 = "llvm.call_intrinsic"(%1402, %1394, %1389) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1404 = "llvm.call_intrinsic"(%1403, %1393, %1392) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1405 = "llvm.call_intrinsic"(%62, %1396, %1386) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1406 = "llvm.call_intrinsic"(%1405, %1395, %1389) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1407 = "llvm.call_intrinsic"(%1406, %1394, %1392) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1408 = "llvm.call_intrinsic"(%62, %1397, %1386) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1409 = "llvm.call_intrinsic"(%1408, %1396, %1389) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1410 = "llvm.call_intrinsic"(%1409, %1395, %1392) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1411 = "llvm.call_intrinsic"(%62, %1398, %1386) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1412 = "llvm.call_intrinsic"(%1411, %1397, %1389) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1413 = "llvm.call_intrinsic"(%1412, %1396, %1392) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1414 = "llvm.call_intrinsic"(%62, %1398, %1389) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1415 = "llvm.call_intrinsic"(%1414, %1397, %1392) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1416 = "llvm.call_intrinsic"(%62, %1393, %1386) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1417 = "llvm.shl"(%1416, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1418 = "llvm.add"(%1417, %1401) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1419 = "llvm.call_intrinsic"(%62, %1394, %1386) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1420 = "llvm.call_intrinsic"(%1419, %1393, %1389) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1421 = "llvm.shl"(%1420, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1422 = "llvm.add"(%1421, %1404) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1423 = "llvm.call_intrinsic"(%62, %1395, %1386) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1424 = "llvm.call_intrinsic"(%1423, %1394, %1389) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1425 = "llvm.call_intrinsic"(%1424, %1393, %1392) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1426 = "llvm.shl"(%1425, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1427 = "llvm.add"(%1426, %1407) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1428 = "llvm.call_intrinsic"(%62, %1396, %1386) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1429 = "llvm.call_intrinsic"(%1428, %1395, %1389) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1430 = "llvm.call_intrinsic"(%1429, %1394, %1392) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1431 = "llvm.shl"(%1430, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1432 = "llvm.add"(%1431, %1410) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1433 = "llvm.call_intrinsic"(%62, %1397, %1386) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1434 = "llvm.call_intrinsic"(%1433, %1396, %1389) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1435 = "llvm.call_intrinsic"(%1434, %1395, %1392) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1436 = "llvm.shl"(%1435, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1437 = "llvm.add"(%1436, %1413) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1438 = "llvm.call_intrinsic"(%62, %1398, %1386) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1439 = "llvm.call_intrinsic"(%1438, %1397, %1389) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1440 = "llvm.call_intrinsic"(%1439, %1396, %1392) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1441 = "llvm.shl"(%1440, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1442 = "llvm.add"(%1441, %1415) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1443 = "llvm.call_intrinsic"(%62, %1398, %1389) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1444 = "llvm.call_intrinsic"(%1443, %1397, %1392) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1445 = "llvm.shl"(%1444, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1446 = "llvm.call_intrinsic"(%1445, %1398, %1392) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1447 = "llvm.call_intrinsic"(%62, %1398, %1392) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1448 = "llvm.shl"(%1447, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1449 = "llvm.shufflevector"(%1427, %57) <{mask = array<i32: 4, 5, 6, 7, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1450 = "llvm.shufflevector"(%1432, %57) <{mask = array<i32: 4, 5, 6, 7, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1451 = "llvm.shufflevector"(%1437, %57) <{mask = array<i32: 4, 5, 6, 7, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1452 = "llvm.add"(%1449, %1399) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1453 = "llvm.shufflevector"(%1399, %1452) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1454 = "llvm.add"(%1450, %1418) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1455 = "llvm.shufflevector"(%1418, %1454) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1456 = "llvm.add"(%1451, %1422) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1457 = "llvm.shufflevector"(%1422, %1456) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1458 = "llvm.add"(%1442, %1449) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1459 = "llvm.shufflevector"(%1458, %1442) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1460 = "llvm.add"(%1446, %1450) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1461 = "llvm.shufflevector"(%1460, %1446) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1462 = "llvm.add"(%1448, %1451) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1463 = "llvm.shufflevector"(%1462, %1448) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1464 = "llvm.shl"(%1459, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1465 = "llvm.add"(%1464, %1453) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1466 = "llvm.mul"(%1459, %23) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1467 = "llvm.add"(%1465, %1466) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1468 = "llvm.shl"(%1461, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1469 = "llvm.add"(%1468, %1455) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1470 = "llvm.mul"(%1461, %23) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1471 = "llvm.add"(%1469, %1470) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1472 = "llvm.shl"(%1463, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1473 = "llvm.add"(%1472, %1457) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1474 = "llvm.mul"(%1463, %23) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1475 = "llvm.add"(%1473, %1474) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1476 = "llvm.lshr"(%1467, %8) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1477 = "llvm.lshr"(%1471, %8) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1478 = "llvm.lshr"(%1475, %7) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1479 = "llvm.mul"(%1478, %172) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1480 = "llvm.and"(%1467, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1481 = "llvm.shufflevector"(%1479, %1478) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1482 = "llvm.add"(%1481, %1480) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1483 = "llvm.and"(%1471, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1484 = "llvm.add"(%1483, %1476) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1485 = "llvm.and"(%1475, %2) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1486 = "llvm.add"(%1485, %1477) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1487 = "llvm.shufflevector"(%1482, %57) <{mask = array<i32: 1, -1, -1, 2, 5, -1, -1, 6>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1488 = "llvm.shufflevector"(%1484, %57) <{mask = array<i32: 1, -1, -1, 2, 5, -1, -1, 6>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1489 = "llvm.shufflevector"(%1486, %57) <{mask = array<i32: 1, -1, -1, 2, 5, -1, -1, 6>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1490 = "llvm.sub"(%1487, %1482) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1491 = "llvm.add"(%1490, %180) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1492 = "llvm.shufflevector"(%1482, %57) <{mask = array<i32: -1, 0, 3, -1, -1, 4, 7, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1493 = "llvm.sub"(%1488, %1484) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1494 = "llvm.add"(%1493, %188) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1495 = "llvm.shufflevector"(%1484, %57) <{mask = array<i32: -1, 0, 3, -1, -1, 4, 7, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1496 = "llvm.sub"(%1489, %1486) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1497 = "llvm.add"(%1496, %196) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1498 = "llvm.shufflevector"(%1486, %57) <{mask = array<i32: -1, 0, 3, -1, -1, 4, 7, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1499 = "llvm.add"(%1492, %1482) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1500 = "llvm.shufflevector"(%1491, %1499) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1501 = "llvm.add"(%1495, %1484) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1502 = "llvm.shufflevector"(%1494, %1501) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1503 = "llvm.add"(%1498, %1486) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1504 = "llvm.shufflevector"(%1497, %1503) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1505 = "llvm.add"(%1500, %10) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1506 = "llvm.add"(%1502, %9) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1507 = "llvm.add"(%1504, %9) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1508 = "llvm.ashr"(%1505, %8) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1509 = "llvm.ashr"(%1507, %7) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1510 = "llvm.mul"(%1509, %172) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1511 = "llvm.and"(%1505, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1512 = "llvm.shufflevector"(%1510, %1509) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1513 = "llvm.add"(%1512, %4) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1514 = "llvm.add"(%1513, %1511) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1515 = "llvm.and"(%1506, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1516 = "llvm.ashr"(%1506, %8) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1517 = "llvm.add"(%1515, %3) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1518 = "llvm.add"(%1517, %1508) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1519 = "llvm.and"(%1507, %2) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1520 = "llvm.add"(%1516, %3) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1521 = "llvm.add"(%1520, %1519) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1522 = "llvm.shufflevector"(%1514, %57) <{mask = array<i32: 3, 1, 3, 1, 7, 5, 7, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1523 = "llvm.shufflevector"(%1518, %57) <{mask = array<i32: 3, 1, 3, 1, 7, 5, 7, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1524 = "llvm.shufflevector"(%1521, %57) <{mask = array<i32: 3, 1, 3, 1, 7, 5, 7, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1525 = "llvm.shufflevector"(%1514, %57) <{mask = array<i32: 0, 2, 2, 0, 0, 2, 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1526 = "llvm.shufflevector"(%1518, %57) <{mask = array<i32: 0, 2, 2, 0, 0, 2, 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1527 = "llvm.shufflevector"(%1521, %57) <{mask = array<i32: 0, 2, 2, 0, 0, 2, 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1528 = "llvm.shufflevector"(%1514, %57) <{mask = array<i32: 4, 6, 6, 4, 4, 6, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1529 = "llvm.shufflevector"(%1518, %57) <{mask = array<i32: 4, 6, 6, 4, 4, 6, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1530 = "llvm.shufflevector"(%1521, %57) <{mask = array<i32: 4, 6, 6, 4, 4, 6, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1531 = "llvm.call_intrinsic"(%62, %1525, %1522) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1532 = "llvm.call_intrinsic"(%62, %1526, %1522) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1533 = "llvm.call_intrinsic"(%1532, %1525, %1523) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1534 = "llvm.call_intrinsic"(%62, %1527, %1522) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1535 = "llvm.call_intrinsic"(%1534, %1526, %1523) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1536 = "llvm.call_intrinsic"(%1535, %1525, %1524) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1537 = "llvm.call_intrinsic"(%62, %1528, %1522) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1538 = "llvm.call_intrinsic"(%1537, %1527, %1523) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1539 = "llvm.call_intrinsic"(%1538, %1526, %1524) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1540 = "llvm.call_intrinsic"(%62, %1529, %1522) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1541 = "llvm.call_intrinsic"(%1540, %1528, %1523) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1542 = "llvm.call_intrinsic"(%1541, %1527, %1524) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1543 = "llvm.call_intrinsic"(%62, %1530, %1522) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1544 = "llvm.call_intrinsic"(%1543, %1529, %1523) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1545 = "llvm.call_intrinsic"(%1544, %1528, %1524) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1546 = "llvm.call_intrinsic"(%62, %1530, %1523) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1547 = "llvm.call_intrinsic"(%1546, %1529, %1524) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1548 = "llvm.call_intrinsic"(%62, %1525, %1522) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1549 = "llvm.shl"(%1548, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1550 = "llvm.add"(%1549, %1533) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1551 = "llvm.call_intrinsic"(%62, %1526, %1522) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1552 = "llvm.call_intrinsic"(%1551, %1525, %1523) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1553 = "llvm.shl"(%1552, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1554 = "llvm.add"(%1553, %1536) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1555 = "llvm.call_intrinsic"(%62, %1527, %1522) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1556 = "llvm.call_intrinsic"(%1555, %1526, %1523) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1557 = "llvm.call_intrinsic"(%1556, %1525, %1524) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1558 = "llvm.shl"(%1557, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1559 = "llvm.add"(%1558, %1539) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1560 = "llvm.call_intrinsic"(%62, %1528, %1522) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1561 = "llvm.call_intrinsic"(%1560, %1527, %1523) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1562 = "llvm.call_intrinsic"(%1561, %1526, %1524) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1563 = "llvm.shl"(%1562, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1564 = "llvm.add"(%1563, %1542) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1565 = "llvm.call_intrinsic"(%62, %1529, %1522) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1566 = "llvm.call_intrinsic"(%1565, %1528, %1523) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1567 = "llvm.call_intrinsic"(%1566, %1527, %1524) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1568 = "llvm.shl"(%1567, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1569 = "llvm.add"(%1568, %1545) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1570 = "llvm.call_intrinsic"(%62, %1530, %1522) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1571 = "llvm.call_intrinsic"(%1570, %1529, %1523) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1572 = "llvm.call_intrinsic"(%1571, %1528, %1524) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1573 = "llvm.shl"(%1572, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1574 = "llvm.add"(%1573, %1547) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1575 = "llvm.call_intrinsic"(%62, %1530, %1523) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1576 = "llvm.call_intrinsic"(%1575, %1529, %1524) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1577 = "llvm.shl"(%1576, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1578 = "llvm.call_intrinsic"(%1577, %1530, %1524) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1579 = "llvm.call_intrinsic"(%62, %1530, %1524) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1580 = "llvm.shl"(%1579, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1581 = "llvm.shufflevector"(%1559, %57) <{mask = array<i32: 4, 5, 6, 7, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1582 = "llvm.shufflevector"(%1564, %57) <{mask = array<i32: 4, 5, 6, 7, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1583 = "llvm.shufflevector"(%1569, %57) <{mask = array<i32: 4, 5, 6, 7, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1584 = "llvm.add"(%1581, %1531) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1585 = "llvm.shufflevector"(%1531, %1584) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1586 = "llvm.add"(%1582, %1550) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1587 = "llvm.shufflevector"(%1550, %1586) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1588 = "llvm.add"(%1583, %1554) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1589 = "llvm.shufflevector"(%1554, %1588) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1590 = "llvm.add"(%1574, %1581) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1591 = "llvm.shufflevector"(%1590, %1574) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1592 = "llvm.add"(%1578, %1582) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1593 = "llvm.shufflevector"(%1592, %1578) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1594 = "llvm.add"(%1580, %1583) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1595 = "llvm.shufflevector"(%1594, %1580) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1596 = "llvm.shl"(%1591, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1597 = "llvm.add"(%1596, %1585) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1598 = "llvm.mul"(%1591, %23) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1599 = "llvm.add"(%1597, %1598) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1600 = "llvm.shl"(%1593, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1601 = "llvm.add"(%1600, %1587) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1602 = "llvm.mul"(%1593, %23) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1603 = "llvm.add"(%1601, %1602) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1604 = "llvm.shl"(%1595, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1605 = "llvm.add"(%1604, %1589) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1606 = "llvm.mul"(%1595, %23) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1607 = "llvm.add"(%1605, %1606) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1608 = "llvm.lshr"(%1599, %8) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1609 = "llvm.lshr"(%1603, %8) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1610 = "llvm.lshr"(%1607, %7) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1611 = "llvm.mul"(%1610, %172) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1612 = "llvm.and"(%1599, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1613 = "llvm.shufflevector"(%1611, %1610) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1614 = "llvm.add"(%1613, %1612) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1615 = "llvm.and"(%1603, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1616 = "llvm.add"(%1615, %1608) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1617 = "llvm.and"(%1607, %2) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1618 = "llvm.add"(%1617, %1609) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.cond_br"(%325, %1618, %1616, %1614)[^bb37, ^bb27] <{operandSegmentSizes = array<i32: 1, 3, 0>}> : (i1, vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
^bb27:  // pred: ^bb26
  %1619 = "llvm.load"(%326) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "fd_r43x6_ge_decode", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 64>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 128>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 192>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 256>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 320>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 384>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 448>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 512>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 576>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 640>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 704>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 712>, <#llvm.tbaa_type_desc<id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 720>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 712>]}> : (!llvm.ptr) -> i64
  %1620 = "llvm.icmp"(%1619, %56) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1620)[^bb29, ^bb28] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb28:  // pred: ^bb27
  %1621 = "llvm.load"(%arg5) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1622 = "llvm.shufflevector"(%1621, %57) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1623 = "llvm.shufflevector"(%1621, %57) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 3, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1624 = "llvm.shufflevector"(%1621, %57) <{mask = array<i32: 4, 4, 1, 1, 1, 1, 1, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1625 = "llvm.shufflevector"(%1621, %57) <{mask = array<i32: 4, 5, 1, 2, 3, 4, 5, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1626 = "llvm.shufflevector"(%1621, %57) <{mask = array<i32: 3, 7, 5, 7, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1627 = "llvm.shufflevector"(%1621, %57) <{mask = array<i32: 5, 7, 5, 7, 2, 3, 4, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1628 = "llvm.shl"(%1622, %58) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1629 = "llvm.shl"(%1624, %59) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1630 = "llvm.shl"(%1626, %60) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1631 = "llvm.call_intrinsic"(%62, %1629, %1625) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1632 = "llvm.call_intrinsic"(%62, %1630, %1627) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1633 = "llvm.call_intrinsic"(%62, %1628, %1623) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1634 = "llvm.shl"(%1633, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1635 = "llvm.call_intrinsic"(%62, %1629, %1625) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1636 = "llvm.shl"(%1635, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1637 = "llvm.call_intrinsic"(%62, %1630, %1627) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1638 = "llvm.shl"(%1637, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1639 = "llvm.and"(%1631, %64) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1640 = "llvm.and"(%1632, %65) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1641 = "llvm.add"(%1640, %1639) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1642 = "llvm.call_intrinsic"(%1641, %1628, %1623) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1643 = "llvm.and"(%1636, %64) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1644 = "llvm.and"(%1638, %65) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1645 = "llvm.add"(%1643, %1634) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1646 = "llvm.add"(%1645, %1644) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1647 = "llvm.and"(%1631, %76) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1648 = "llvm.and"(%1632, %84) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1649 = "llvm.and"(%1636, %92) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1650 = "llvm.and"(%1638, %100) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1651 = "llvm.add"(%1650, %1649) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1652 = "llvm.shufflevector"(%108, %1646) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1653 = "llvm.add"(%1652, %1642) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1654 = "llvm.shufflevector"(%108, %1651) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1655 = "llvm.shufflevector"(%1646, %116) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1656 = "llvm.add"(%1648, %1647) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1657 = "llvm.add"(%1656, %1654) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1658 = "llvm.add"(%1657, %1655) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1659 = "llvm.and"(%1653, %25) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1660 = "llvm.shufflevector"(%1653, %1658) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1661 = "llvm.shl"(%1660, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1662 = "llvm.add"(%1661, %1659) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1663 = "llvm.mul"(%1660, %23) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1664 = "llvm.add"(%1662, %1663) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1665 = "llvm.and"(%1664, %22) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1666 = "llvm.lshr"(%1664, %21) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1667 = "llvm.shufflevector"(%1666, %57) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1668 = "llvm.call_intrinsic"(%1665, %20, %1667) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1669 = "llvm.shufflevector"(%1668, %57) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1670 = "llvm.shufflevector"(%1668, %57) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 3, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1671 = "llvm.shufflevector"(%1668, %57) <{mask = array<i32: 4, 4, 1, 1, 1, 1, 1, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1672 = "llvm.shufflevector"(%1668, %57) <{mask = array<i32: 4, 5, 1, 2, 3, 4, 5, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1673 = "llvm.shufflevector"(%1668, %57) <{mask = array<i32: 3, 7, 5, 7, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1674 = "llvm.shufflevector"(%1668, %57) <{mask = array<i32: 5, 7, 5, 7, 2, 3, 4, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1675 = "llvm.shl"(%1669, %58) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1676 = "llvm.shl"(%1671, %59) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1677 = "llvm.shl"(%1673, %60) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1678 = "llvm.call_intrinsic"(%62, %1676, %1672) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1679 = "llvm.call_intrinsic"(%62, %1677, %1674) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1680 = "llvm.call_intrinsic"(%62, %1675, %1670) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1681 = "llvm.shl"(%1680, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1682 = "llvm.call_intrinsic"(%62, %1676, %1672) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1683 = "llvm.shl"(%1682, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1684 = "llvm.call_intrinsic"(%62, %1677, %1674) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1685 = "llvm.shl"(%1684, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1686 = "llvm.and"(%1678, %64) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1687 = "llvm.and"(%1679, %65) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1688 = "llvm.add"(%1687, %1686) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1689 = "llvm.call_intrinsic"(%1688, %1675, %1670) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1690 = "llvm.and"(%1683, %64) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1691 = "llvm.and"(%1685, %65) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1692 = "llvm.add"(%1690, %1681) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1693 = "llvm.add"(%1692, %1691) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1694 = "llvm.and"(%1678, %76) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1695 = "llvm.and"(%1679, %84) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1696 = "llvm.and"(%1683, %92) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1697 = "llvm.and"(%1685, %100) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1698 = "llvm.add"(%1697, %1696) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1699 = "llvm.shufflevector"(%108, %1693) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1700 = "llvm.add"(%1699, %1689) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1701 = "llvm.shufflevector"(%108, %1698) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1702 = "llvm.shufflevector"(%1693, %116) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1703 = "llvm.add"(%1695, %1694) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1704 = "llvm.add"(%1703, %1701) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1705 = "llvm.add"(%1704, %1702) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1706 = "llvm.and"(%1700, %25) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1707 = "llvm.shufflevector"(%1700, %1705) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1708 = "llvm.shl"(%1707, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1709 = "llvm.add"(%1708, %1706) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1710 = "llvm.mul"(%1707, %23) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1711 = "llvm.add"(%1709, %1710) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1712 = "llvm.and"(%1711, %22) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1713 = "llvm.lshr"(%1711, %21) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1714 = "llvm.shufflevector"(%1713, %57) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1715 = "llvm.call_intrinsic"(%1712, %20, %1714) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1716 = "llvm.shufflevector"(%1715, %57) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1717 = "llvm.shufflevector"(%1715, %57) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 3, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1718 = "llvm.shufflevector"(%1715, %57) <{mask = array<i32: 4, 4, 1, 1, 1, 1, 1, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1719 = "llvm.shufflevector"(%1715, %57) <{mask = array<i32: 4, 5, 1, 2, 3, 4, 5, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1720 = "llvm.shufflevector"(%1715, %57) <{mask = array<i32: 3, 7, 5, 7, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1721 = "llvm.shufflevector"(%1715, %57) <{mask = array<i32: 5, 7, 5, 7, 2, 3, 4, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1722 = "llvm.shl"(%1716, %58) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1723 = "llvm.shl"(%1718, %59) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1724 = "llvm.shl"(%1720, %60) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1725 = "llvm.call_intrinsic"(%62, %1723, %1719) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1726 = "llvm.call_intrinsic"(%62, %1724, %1721) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1727 = "llvm.call_intrinsic"(%62, %1722, %1717) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1728 = "llvm.shl"(%1727, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1729 = "llvm.call_intrinsic"(%62, %1723, %1719) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1730 = "llvm.shl"(%1729, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1731 = "llvm.call_intrinsic"(%62, %1724, %1721) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1732 = "llvm.shl"(%1731, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1733 = "llvm.and"(%1725, %64) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1734 = "llvm.and"(%1726, %65) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1735 = "llvm.add"(%1734, %1733) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1736 = "llvm.call_intrinsic"(%1735, %1722, %1717) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1737 = "llvm.and"(%1730, %64) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1738 = "llvm.and"(%1732, %65) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1739 = "llvm.add"(%1737, %1728) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1740 = "llvm.add"(%1739, %1738) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1741 = "llvm.and"(%1725, %76) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1742 = "llvm.and"(%1726, %84) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1743 = "llvm.and"(%1730, %92) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1744 = "llvm.and"(%1732, %100) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1745 = "llvm.add"(%1744, %1743) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1746 = "llvm.shufflevector"(%108, %1740) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1747 = "llvm.add"(%1746, %1736) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1748 = "llvm.shufflevector"(%108, %1745) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1749 = "llvm.shufflevector"(%1740, %116) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1750 = "llvm.add"(%1742, %1741) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1751 = "llvm.add"(%1750, %1748) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1752 = "llvm.add"(%1751, %1749) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1753 = "llvm.and"(%1747, %25) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1754 = "llvm.shufflevector"(%1747, %1752) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1755 = "llvm.shl"(%1754, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1756 = "llvm.add"(%1755, %1753) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1757 = "llvm.mul"(%1754, %23) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1758 = "llvm.add"(%1756, %1757) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1759 = "llvm.and"(%1758, %22) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1760 = "llvm.lshr"(%1758, %21) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1761 = "llvm.shufflevector"(%1760, %57) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1762 = "llvm.call_intrinsic"(%1759, %20, %1761) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1762, %arg5) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1763 = "llvm.add"(%1619, %19) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%1763, %326) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "fd_r43x6_ge_decode", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 64>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 128>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 192>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 256>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 320>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 384>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 448>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 512>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 576>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 640>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 704>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 712>, <#llvm.tbaa_type_desc<id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 720>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 712>]}> : (i64, !llvm.ptr) -> ()
  "llvm.br"(%1618, %1616, %1614)[^bb37] : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
^bb29:  // pred: ^bb27
  %1764 = "llvm.load"(%327) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "fd_r43x6_ge_decode", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 64>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 128>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 192>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 256>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 320>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 384>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 448>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 512>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 576>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 640>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 704>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 712>, <#llvm.tbaa_type_desc<id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 720>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 704>]}> : (!llvm.ptr) -> i64
  %1765 = "llvm.icmp"(%1764, %18) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1765, %1618, %1616, %1614)[^bb30, ^bb37] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 3>}> : (i1, vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
^bb30:  // pred: ^bb29
  "llvm.call"(%arg5, %56) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_ge_decode_step_slow, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, i64) -> ()
  "llvm.br"(%1618, %1616, %1614)[^bb37] : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
^bb31:  // pred: ^bb25
  %1766 = "llvm.icmp"(%494, %47) <{predicate = 2 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%1766, %1343, %1344, %1345)[^bb32, ^bb37] <{operandSegmentSizes = array<i32: 1, 0, 3>}> : (i1, vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
^bb32:  // pred: ^bb31
  "llvm.store"(%1345, %arg0) <{alias_scopes = [#llvm.alias_scope<id = distinct[6]<>, domain = <id = distinct[7]<>, description = "fd_ed25519_point_add_final_mul">, description = "fd_ed25519_point_add_final_mul: argument 0">], alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%1344, %208) <{alias_scopes = [#llvm.alias_scope<id = distinct[6]<>, domain = <id = distinct[7]<>, description = "fd_ed25519_point_add_final_mul">, description = "fd_ed25519_point_add_final_mul: argument 0">], alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%1343, %330) <{alias_scopes = [#llvm.alias_scope<id = distinct[6]<>, domain = <id = distinct[7]<>, description = "fd_ed25519_point_add_final_mul">, description = "fd_ed25519_point_add_final_mul: argument 0">], alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1767 = "llvm.getelementptr"(%199, %485) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1768 = "llvm.load"(%1767) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 _ZTS21fd_curve25519_edwards", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 _ZTS21fd_curve25519_edwards", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %1769 = "llvm.sub"(%68, %1346) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %1770 = "llvm.lshr"(%1769, %31) : (i32, i32) -> i32
  %1771 = "llvm.zext"(%1770) <{nonNeg}> : (i32) -> i64
  %1772 = "llvm.getelementptr"(%1768, %1771) <{elem_type = !llvm.array<192 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1773 = "llvm.load"(%1772) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1774 = "llvm.getelementptr"(%1772) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %1775 = "llvm.load"(%1774) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1776 = "llvm.getelementptr"(%1772) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %1777 = "llvm.load"(%1776) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1778 = "llvm.sub"(%124, %1773) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1779 = "llvm.sub"(%132, %1775) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1780 = "llvm.sub"(%140, %1777) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1781 = "llvm.shufflevector"(%1773, %1778) <{mask = array<i32: 1, 0, 2, 11, 5, 4, 6, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1782 = "llvm.shufflevector"(%1775, %1779) <{mask = array<i32: 1, 0, 2, 11, 5, 4, 6, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1783 = "llvm.shufflevector"(%1777, %1780) <{mask = array<i32: 1, 0, 2, 11, 5, 4, 6, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1784 = "llvm.shufflevector"(%1345, %57) <{mask = array<i32: 1, -1, -1, -1, 5, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1785 = "llvm.shufflevector"(%1344, %57) <{mask = array<i32: 1, -1, -1, -1, 5, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1786 = "llvm.shufflevector"(%1343, %57) <{mask = array<i32: 1, -1, -1, -1, 5, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1787 = "llvm.sub"(%1784, %1345) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1788 = "llvm.add"(%1787, %148) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1789 = "llvm.shufflevector"(%1788, %1345) <{mask = array<i32: 0, 8, 10, 11, 4, 12, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1790 = "llvm.sub"(%1785, %1344) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1791 = "llvm.add"(%1790, %156) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1792 = "llvm.shufflevector"(%1791, %1344) <{mask = array<i32: 0, 8, 10, 11, 4, 12, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1793 = "llvm.sub"(%1786, %1343) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1794 = "llvm.add"(%1793, %164) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1795 = "llvm.shufflevector"(%1794, %1343) <{mask = array<i32: 0, 8, 10, 11, 4, 12, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1796 = "llvm.add"(%1789, %1345) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1797 = "llvm.shufflevector"(%1789, %1796) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1798 = "llvm.add"(%1792, %1344) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1799 = "llvm.shufflevector"(%1792, %1798) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1800 = "llvm.add"(%1795, %1343) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1801 = "llvm.shufflevector"(%1795, %1800) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1802 = "llvm.add"(%1797, %10) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1803 = "llvm.add"(%1799, %9) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1804 = "llvm.add"(%1801, %9) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1805 = "llvm.ashr"(%1802, %8) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1806 = "llvm.ashr"(%1803, %8) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1807 = "llvm.ashr"(%1804, %7) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1808 = "llvm.mul"(%1807, %172) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1809 = "llvm.and"(%1802, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1810 = "llvm.shufflevector"(%1808, %1807) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1811 = "llvm.add"(%1809, %4) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1812 = "llvm.add"(%1811, %1810) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1813 = "llvm.and"(%1803, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1814 = "llvm.add"(%1805, %3) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1815 = "llvm.add"(%1814, %1813) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1816 = "llvm.and"(%1804, %2) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1817 = "llvm.add"(%1806, %3) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1818 = "llvm.add"(%1817, %1816) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1819 = "llvm.shufflevector"(%1781, %57) <{mask = array<i32: 0, 1, 2, 3, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1820 = "llvm.shufflevector"(%1782, %57) <{mask = array<i32: 0, 1, 2, 3, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1821 = "llvm.shufflevector"(%1783, %57) <{mask = array<i32: 0, 1, 2, 3, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1822 = "llvm.shufflevector"(%1781, %57) <{mask = array<i32: 4, 5, 6, 7, 4, 5, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1823 = "llvm.shufflevector"(%1782, %57) <{mask = array<i32: 4, 5, 6, 7, 4, 5, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1824 = "llvm.shufflevector"(%1783, %57) <{mask = array<i32: 4, 5, 6, 7, 4, 5, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1825 = "llvm.call_intrinsic"(%62, %1819, %1812) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1826 = "llvm.call_intrinsic"(%62, %1820, %1812) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1827 = "llvm.call_intrinsic"(%1826, %1819, %1815) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1828 = "llvm.call_intrinsic"(%62, %1821, %1812) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1829 = "llvm.call_intrinsic"(%1828, %1820, %1815) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1830 = "llvm.call_intrinsic"(%1829, %1819, %1818) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1831 = "llvm.call_intrinsic"(%62, %1822, %1812) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1832 = "llvm.call_intrinsic"(%1831, %1821, %1815) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1833 = "llvm.call_intrinsic"(%1832, %1820, %1818) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1834 = "llvm.call_intrinsic"(%62, %1823, %1812) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1835 = "llvm.call_intrinsic"(%1834, %1822, %1815) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1836 = "llvm.call_intrinsic"(%1835, %1821, %1818) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1837 = "llvm.call_intrinsic"(%62, %1824, %1812) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1838 = "llvm.call_intrinsic"(%1837, %1823, %1815) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1839 = "llvm.call_intrinsic"(%1838, %1822, %1818) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1840 = "llvm.call_intrinsic"(%62, %1824, %1815) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1841 = "llvm.call_intrinsic"(%1840, %1823, %1818) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1842 = "llvm.call_intrinsic"(%62, %1819, %1812) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1843 = "llvm.shl"(%1842, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1844 = "llvm.add"(%1843, %1827) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1845 = "llvm.call_intrinsic"(%62, %1820, %1812) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1846 = "llvm.call_intrinsic"(%1845, %1819, %1815) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1847 = "llvm.shl"(%1846, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1848 = "llvm.add"(%1847, %1830) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1849 = "llvm.call_intrinsic"(%62, %1821, %1812) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1850 = "llvm.call_intrinsic"(%1849, %1820, %1815) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1851 = "llvm.call_intrinsic"(%1850, %1819, %1818) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1852 = "llvm.shl"(%1851, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1853 = "llvm.add"(%1852, %1833) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1854 = "llvm.call_intrinsic"(%62, %1822, %1812) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1855 = "llvm.call_intrinsic"(%1854, %1821, %1815) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1856 = "llvm.call_intrinsic"(%1855, %1820, %1818) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1857 = "llvm.shl"(%1856, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1858 = "llvm.add"(%1857, %1836) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1859 = "llvm.call_intrinsic"(%62, %1823, %1812) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1860 = "llvm.call_intrinsic"(%1859, %1822, %1815) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1861 = "llvm.call_intrinsic"(%1860, %1821, %1818) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1862 = "llvm.shl"(%1861, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1863 = "llvm.add"(%1862, %1839) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1864 = "llvm.call_intrinsic"(%62, %1824, %1812) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1865 = "llvm.call_intrinsic"(%1864, %1823, %1815) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1866 = "llvm.call_intrinsic"(%1865, %1822, %1818) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1867 = "llvm.shl"(%1866, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1868 = "llvm.add"(%1867, %1841) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1869 = "llvm.call_intrinsic"(%62, %1824, %1815) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1870 = "llvm.call_intrinsic"(%1869, %1823, %1818) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1871 = "llvm.shl"(%1870, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1872 = "llvm.call_intrinsic"(%1871, %1824, %1818) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1873 = "llvm.call_intrinsic"(%62, %1824, %1818) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1874 = "llvm.shl"(%1873, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1875 = "llvm.shufflevector"(%1853, %57) <{mask = array<i32: 4, 5, 6, 7, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1876 = "llvm.shufflevector"(%1858, %57) <{mask = array<i32: 4, 5, 6, 7, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1877 = "llvm.shufflevector"(%1863, %57) <{mask = array<i32: 4, 5, 6, 7, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1878 = "llvm.add"(%1875, %1825) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1879 = "llvm.shufflevector"(%1825, %1878) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1880 = "llvm.add"(%1876, %1844) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1881 = "llvm.shufflevector"(%1844, %1880) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1882 = "llvm.add"(%1877, %1848) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1883 = "llvm.shufflevector"(%1848, %1882) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1884 = "llvm.add"(%1868, %1875) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1885 = "llvm.shufflevector"(%1884, %1868) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1886 = "llvm.add"(%1872, %1876) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1887 = "llvm.shufflevector"(%1886, %1872) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1888 = "llvm.add"(%1874, %1877) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1889 = "llvm.shufflevector"(%1888, %1874) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1890 = "llvm.shl"(%1885, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1891 = "llvm.add"(%1890, %1879) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1892 = "llvm.mul"(%1885, %23) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1893 = "llvm.add"(%1891, %1892) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1894 = "llvm.shl"(%1887, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1895 = "llvm.add"(%1894, %1881) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1896 = "llvm.mul"(%1887, %23) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1897 = "llvm.add"(%1895, %1896) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1898 = "llvm.shl"(%1889, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1899 = "llvm.add"(%1898, %1883) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1900 = "llvm.mul"(%1889, %23) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1901 = "llvm.add"(%1899, %1900) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1902 = "llvm.lshr"(%1893, %8) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1903 = "llvm.lshr"(%1897, %8) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1904 = "llvm.lshr"(%1901, %7) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1905 = "llvm.mul"(%1904, %172) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1906 = "llvm.and"(%1893, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1907 = "llvm.shufflevector"(%1905, %1904) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1908 = "llvm.add"(%1907, %1906) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1909 = "llvm.and"(%1897, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1910 = "llvm.add"(%1909, %1902) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1911 = "llvm.and"(%1901, %2) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1912 = "llvm.add"(%1911, %1903) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1913 = "llvm.shufflevector"(%1908, %57) <{mask = array<i32: 1, -1, -1, 2, 5, -1, -1, 6>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1914 = "llvm.shufflevector"(%1910, %57) <{mask = array<i32: 1, -1, -1, 2, 5, -1, -1, 6>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1915 = "llvm.shufflevector"(%1912, %57) <{mask = array<i32: 1, -1, -1, 2, 5, -1, -1, 6>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1916 = "llvm.sub"(%1913, %1908) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1917 = "llvm.add"(%1916, %180) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1918 = "llvm.shufflevector"(%1908, %57) <{mask = array<i32: -1, 0, 3, -1, -1, 4, 7, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1919 = "llvm.sub"(%1914, %1910) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1920 = "llvm.add"(%1919, %188) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1921 = "llvm.shufflevector"(%1910, %57) <{mask = array<i32: -1, 0, 3, -1, -1, 4, 7, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1922 = "llvm.sub"(%1915, %1912) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1923 = "llvm.add"(%1922, %196) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1924 = "llvm.shufflevector"(%1912, %57) <{mask = array<i32: -1, 0, 3, -1, -1, 4, 7, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1925 = "llvm.add"(%1918, %1908) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1926 = "llvm.shufflevector"(%1917, %1925) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1927 = "llvm.add"(%1921, %1910) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1928 = "llvm.shufflevector"(%1920, %1927) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1929 = "llvm.add"(%1924, %1912) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1930 = "llvm.shufflevector"(%1923, %1929) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1931 = "llvm.add"(%1926, %10) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1932 = "llvm.add"(%1928, %9) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1933 = "llvm.add"(%1930, %9) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1934 = "llvm.ashr"(%1931, %8) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1935 = "llvm.ashr"(%1933, %7) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1936 = "llvm.mul"(%1935, %172) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1937 = "llvm.and"(%1931, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1938 = "llvm.shufflevector"(%1936, %1935) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1939 = "llvm.add"(%1938, %4) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1940 = "llvm.add"(%1939, %1937) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1941 = "llvm.and"(%1932, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1942 = "llvm.ashr"(%1932, %8) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1943 = "llvm.add"(%1941, %3) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1944 = "llvm.add"(%1943, %1934) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1945 = "llvm.and"(%1933, %2) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1946 = "llvm.add"(%1942, %3) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1947 = "llvm.add"(%1946, %1945) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1948 = "llvm.shufflevector"(%1940, %57) <{mask = array<i32: 3, 1, 3, 1, 7, 5, 7, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1949 = "llvm.shufflevector"(%1944, %57) <{mask = array<i32: 3, 1, 3, 1, 7, 5, 7, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1950 = "llvm.shufflevector"(%1947, %57) <{mask = array<i32: 3, 1, 3, 1, 7, 5, 7, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1951 = "llvm.shufflevector"(%1940, %57) <{mask = array<i32: 0, 2, 2, 0, 0, 2, 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1952 = "llvm.shufflevector"(%1944, %57) <{mask = array<i32: 0, 2, 2, 0, 0, 2, 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1953 = "llvm.shufflevector"(%1947, %57) <{mask = array<i32: 0, 2, 2, 0, 0, 2, 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1954 = "llvm.shufflevector"(%1940, %57) <{mask = array<i32: 4, 6, 6, 4, 4, 6, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1955 = "llvm.shufflevector"(%1944, %57) <{mask = array<i32: 4, 6, 6, 4, 4, 6, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1956 = "llvm.shufflevector"(%1947, %57) <{mask = array<i32: 4, 6, 6, 4, 4, 6, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1957 = "llvm.call_intrinsic"(%62, %1951, %1948) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1958 = "llvm.call_intrinsic"(%62, %1952, %1948) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1959 = "llvm.call_intrinsic"(%1958, %1951, %1949) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1960 = "llvm.call_intrinsic"(%62, %1953, %1948) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1961 = "llvm.call_intrinsic"(%1960, %1952, %1949) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1962 = "llvm.call_intrinsic"(%1961, %1951, %1950) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1963 = "llvm.call_intrinsic"(%62, %1954, %1948) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1964 = "llvm.call_intrinsic"(%1963, %1953, %1949) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1965 = "llvm.call_intrinsic"(%1964, %1952, %1950) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1966 = "llvm.call_intrinsic"(%62, %1955, %1948) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1967 = "llvm.call_intrinsic"(%1966, %1954, %1949) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1968 = "llvm.call_intrinsic"(%1967, %1953, %1950) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1969 = "llvm.call_intrinsic"(%62, %1956, %1948) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1970 = "llvm.call_intrinsic"(%1969, %1955, %1949) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1971 = "llvm.call_intrinsic"(%1970, %1954, %1950) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1972 = "llvm.call_intrinsic"(%62, %1956, %1949) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1973 = "llvm.call_intrinsic"(%1972, %1955, %1950) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1974 = "llvm.call_intrinsic"(%62, %1951, %1948) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1975 = "llvm.shl"(%1974, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1976 = "llvm.add"(%1975, %1959) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1977 = "llvm.call_intrinsic"(%62, %1952, %1948) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1978 = "llvm.call_intrinsic"(%1977, %1951, %1949) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1979 = "llvm.shl"(%1978, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1980 = "llvm.add"(%1979, %1962) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1981 = "llvm.call_intrinsic"(%62, %1953, %1948) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1982 = "llvm.call_intrinsic"(%1981, %1952, %1949) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1983 = "llvm.call_intrinsic"(%1982, %1951, %1950) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1984 = "llvm.shl"(%1983, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1985 = "llvm.add"(%1984, %1965) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1986 = "llvm.call_intrinsic"(%62, %1954, %1948) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1987 = "llvm.call_intrinsic"(%1986, %1953, %1949) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1988 = "llvm.call_intrinsic"(%1987, %1952, %1950) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1989 = "llvm.shl"(%1988, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1990 = "llvm.add"(%1989, %1968) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1991 = "llvm.call_intrinsic"(%62, %1955, %1948) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1992 = "llvm.call_intrinsic"(%1991, %1954, %1949) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1993 = "llvm.call_intrinsic"(%1992, %1953, %1950) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1994 = "llvm.shl"(%1993, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1995 = "llvm.add"(%1994, %1971) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1996 = "llvm.call_intrinsic"(%62, %1956, %1948) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1997 = "llvm.call_intrinsic"(%1996, %1955, %1949) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1998 = "llvm.call_intrinsic"(%1997, %1954, %1950) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1999 = "llvm.shl"(%1998, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2000 = "llvm.add"(%1999, %1973) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2001 = "llvm.call_intrinsic"(%62, %1956, %1949) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2002 = "llvm.call_intrinsic"(%2001, %1955, %1950) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2003 = "llvm.shl"(%2002, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2004 = "llvm.call_intrinsic"(%2003, %1956, %1950) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2005 = "llvm.call_intrinsic"(%62, %1956, %1950) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2006 = "llvm.shl"(%2005, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2007 = "llvm.shufflevector"(%1985, %57) <{mask = array<i32: 4, 5, 6, 7, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2008 = "llvm.shufflevector"(%1990, %57) <{mask = array<i32: 4, 5, 6, 7, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2009 = "llvm.shufflevector"(%1995, %57) <{mask = array<i32: 4, 5, 6, 7, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2010 = "llvm.add"(%2007, %1957) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2011 = "llvm.shufflevector"(%1957, %2010) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2012 = "llvm.add"(%2008, %1976) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2013 = "llvm.shufflevector"(%1976, %2012) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2014 = "llvm.add"(%2009, %1980) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2015 = "llvm.shufflevector"(%1980, %2014) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2016 = "llvm.add"(%2000, %2007) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2017 = "llvm.shufflevector"(%2016, %2000) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2018 = "llvm.add"(%2004, %2008) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2019 = "llvm.shufflevector"(%2018, %2004) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2020 = "llvm.add"(%2006, %2009) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2021 = "llvm.shufflevector"(%2020, %2006) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2022 = "llvm.shl"(%2017, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2023 = "llvm.add"(%2022, %2011) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2024 = "llvm.mul"(%2017, %23) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2025 = "llvm.add"(%2023, %2024) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2026 = "llvm.shl"(%2019, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2027 = "llvm.add"(%2026, %2013) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2028 = "llvm.mul"(%2019, %23) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2029 = "llvm.add"(%2027, %2028) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2030 = "llvm.shl"(%2021, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2031 = "llvm.add"(%2030, %2015) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2032 = "llvm.mul"(%2021, %23) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2033 = "llvm.add"(%2031, %2032) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2034 = "llvm.lshr"(%2025, %8) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2035 = "llvm.lshr"(%2029, %8) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2036 = "llvm.lshr"(%2033, %7) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2037 = "llvm.mul"(%2036, %172) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2038 = "llvm.and"(%2025, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2039 = "llvm.shufflevector"(%2037, %2036) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2040 = "llvm.add"(%2039, %2038) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2041 = "llvm.and"(%2029, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2042 = "llvm.add"(%2041, %2034) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2043 = "llvm.and"(%2033, %2) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2044 = "llvm.add"(%2043, %2035) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.cond_br"(%325, %2044, %2042, %2040)[^bb37, ^bb33] <{operandSegmentSizes = array<i32: 1, 3, 0>}> : (i1, vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
^bb33:  // pred: ^bb32
  %2045 = "llvm.load"(%326) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "fd_r43x6_ge_decode", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 64>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 128>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 192>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 256>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 320>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 384>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 448>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 512>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 576>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 640>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 704>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 712>, <#llvm.tbaa_type_desc<id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 720>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 712>]}> : (!llvm.ptr) -> i64
  %2046 = "llvm.icmp"(%2045, %56) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%2046)[^bb35, ^bb34] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb34:  // pred: ^bb33
  %2047 = "llvm.load"(%arg5) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2048 = "llvm.shufflevector"(%2047, %57) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2049 = "llvm.shufflevector"(%2047, %57) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 3, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2050 = "llvm.shufflevector"(%2047, %57) <{mask = array<i32: 4, 4, 1, 1, 1, 1, 1, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2051 = "llvm.shufflevector"(%2047, %57) <{mask = array<i32: 4, 5, 1, 2, 3, 4, 5, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2052 = "llvm.shufflevector"(%2047, %57) <{mask = array<i32: 3, 7, 5, 7, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2053 = "llvm.shufflevector"(%2047, %57) <{mask = array<i32: 5, 7, 5, 7, 2, 3, 4, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2054 = "llvm.shl"(%2048, %58) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2055 = "llvm.shl"(%2050, %59) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2056 = "llvm.shl"(%2052, %60) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2057 = "llvm.call_intrinsic"(%62, %2055, %2051) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2058 = "llvm.call_intrinsic"(%62, %2056, %2053) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2059 = "llvm.call_intrinsic"(%62, %2054, %2049) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2060 = "llvm.shl"(%2059, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2061 = "llvm.call_intrinsic"(%62, %2055, %2051) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2062 = "llvm.shl"(%2061, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2063 = "llvm.call_intrinsic"(%62, %2056, %2053) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2064 = "llvm.shl"(%2063, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2065 = "llvm.and"(%2057, %64) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2066 = "llvm.and"(%2058, %65) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2067 = "llvm.add"(%2066, %2065) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2068 = "llvm.call_intrinsic"(%2067, %2054, %2049) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2069 = "llvm.and"(%2062, %64) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2070 = "llvm.and"(%2064, %65) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2071 = "llvm.add"(%2069, %2060) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2072 = "llvm.add"(%2071, %2070) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2073 = "llvm.and"(%2057, %76) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2074 = "llvm.and"(%2058, %84) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2075 = "llvm.and"(%2062, %92) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2076 = "llvm.and"(%2064, %100) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2077 = "llvm.add"(%2076, %2075) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2078 = "llvm.shufflevector"(%108, %2072) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2079 = "llvm.add"(%2078, %2068) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2080 = "llvm.shufflevector"(%108, %2077) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2081 = "llvm.shufflevector"(%2072, %116) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2082 = "llvm.add"(%2074, %2073) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2083 = "llvm.add"(%2082, %2080) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2084 = "llvm.add"(%2083, %2081) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2085 = "llvm.and"(%2079, %25) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2086 = "llvm.shufflevector"(%2079, %2084) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2087 = "llvm.shl"(%2086, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2088 = "llvm.add"(%2087, %2085) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2089 = "llvm.mul"(%2086, %23) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2090 = "llvm.add"(%2088, %2089) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2091 = "llvm.and"(%2090, %22) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2092 = "llvm.lshr"(%2090, %21) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2093 = "llvm.shufflevector"(%2092, %57) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2094 = "llvm.call_intrinsic"(%2091, %20, %2093) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2095 = "llvm.shufflevector"(%2094, %57) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2096 = "llvm.shufflevector"(%2094, %57) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 3, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2097 = "llvm.shufflevector"(%2094, %57) <{mask = array<i32: 4, 4, 1, 1, 1, 1, 1, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2098 = "llvm.shufflevector"(%2094, %57) <{mask = array<i32: 4, 5, 1, 2, 3, 4, 5, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2099 = "llvm.shufflevector"(%2094, %57) <{mask = array<i32: 3, 7, 5, 7, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2100 = "llvm.shufflevector"(%2094, %57) <{mask = array<i32: 5, 7, 5, 7, 2, 3, 4, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2101 = "llvm.shl"(%2095, %58) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2102 = "llvm.shl"(%2097, %59) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2103 = "llvm.shl"(%2099, %60) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2104 = "llvm.call_intrinsic"(%62, %2102, %2098) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2105 = "llvm.call_intrinsic"(%62, %2103, %2100) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2106 = "llvm.call_intrinsic"(%62, %2101, %2096) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2107 = "llvm.shl"(%2106, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2108 = "llvm.call_intrinsic"(%62, %2102, %2098) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2109 = "llvm.shl"(%2108, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2110 = "llvm.call_intrinsic"(%62, %2103, %2100) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2111 = "llvm.shl"(%2110, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2112 = "llvm.and"(%2104, %64) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2113 = "llvm.and"(%2105, %65) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2114 = "llvm.add"(%2113, %2112) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2115 = "llvm.call_intrinsic"(%2114, %2101, %2096) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2116 = "llvm.and"(%2109, %64) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2117 = "llvm.and"(%2111, %65) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2118 = "llvm.add"(%2116, %2107) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2119 = "llvm.add"(%2118, %2117) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2120 = "llvm.and"(%2104, %76) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2121 = "llvm.and"(%2105, %84) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2122 = "llvm.and"(%2109, %92) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2123 = "llvm.and"(%2111, %100) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2124 = "llvm.add"(%2123, %2122) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2125 = "llvm.shufflevector"(%108, %2119) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2126 = "llvm.add"(%2125, %2115) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2127 = "llvm.shufflevector"(%108, %2124) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2128 = "llvm.shufflevector"(%2119, %116) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2129 = "llvm.add"(%2121, %2120) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2130 = "llvm.add"(%2129, %2127) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2131 = "llvm.add"(%2130, %2128) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2132 = "llvm.and"(%2126, %25) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2133 = "llvm.shufflevector"(%2126, %2131) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2134 = "llvm.shl"(%2133, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2135 = "llvm.add"(%2134, %2132) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2136 = "llvm.mul"(%2133, %23) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2137 = "llvm.add"(%2135, %2136) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2138 = "llvm.and"(%2137, %22) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2139 = "llvm.lshr"(%2137, %21) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2140 = "llvm.shufflevector"(%2139, %57) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2141 = "llvm.call_intrinsic"(%2138, %20, %2140) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2142 = "llvm.shufflevector"(%2141, %57) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2143 = "llvm.shufflevector"(%2141, %57) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 3, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2144 = "llvm.shufflevector"(%2141, %57) <{mask = array<i32: 4, 4, 1, 1, 1, 1, 1, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2145 = "llvm.shufflevector"(%2141, %57) <{mask = array<i32: 4, 5, 1, 2, 3, 4, 5, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2146 = "llvm.shufflevector"(%2141, %57) <{mask = array<i32: 3, 7, 5, 7, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2147 = "llvm.shufflevector"(%2141, %57) <{mask = array<i32: 5, 7, 5, 7, 2, 3, 4, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2148 = "llvm.shl"(%2142, %58) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2149 = "llvm.shl"(%2144, %59) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2150 = "llvm.shl"(%2146, %60) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2151 = "llvm.call_intrinsic"(%62, %2149, %2145) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2152 = "llvm.call_intrinsic"(%62, %2150, %2147) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2153 = "llvm.call_intrinsic"(%62, %2148, %2143) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2154 = "llvm.shl"(%2153, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2155 = "llvm.call_intrinsic"(%62, %2149, %2145) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2156 = "llvm.shl"(%2155, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2157 = "llvm.call_intrinsic"(%62, %2150, %2147) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2158 = "llvm.shl"(%2157, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2159 = "llvm.and"(%2151, %64) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2160 = "llvm.and"(%2152, %65) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2161 = "llvm.add"(%2160, %2159) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2162 = "llvm.call_intrinsic"(%2161, %2148, %2143) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2163 = "llvm.and"(%2156, %64) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2164 = "llvm.and"(%2158, %65) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2165 = "llvm.add"(%2163, %2154) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2166 = "llvm.add"(%2165, %2164) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2167 = "llvm.and"(%2151, %76) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2168 = "llvm.and"(%2152, %84) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2169 = "llvm.and"(%2156, %92) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2170 = "llvm.and"(%2158, %100) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2171 = "llvm.add"(%2170, %2169) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2172 = "llvm.shufflevector"(%108, %2166) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2173 = "llvm.add"(%2172, %2162) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2174 = "llvm.shufflevector"(%108, %2171) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2175 = "llvm.shufflevector"(%2166, %116) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2176 = "llvm.add"(%2168, %2167) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2177 = "llvm.add"(%2176, %2174) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2178 = "llvm.add"(%2177, %2175) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2179 = "llvm.and"(%2173, %25) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2180 = "llvm.shufflevector"(%2173, %2178) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2181 = "llvm.shl"(%2180, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2182 = "llvm.add"(%2181, %2179) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2183 = "llvm.mul"(%2180, %23) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2184 = "llvm.add"(%2182, %2183) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2185 = "llvm.and"(%2184, %22) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2186 = "llvm.lshr"(%2184, %21) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2187 = "llvm.shufflevector"(%2186, %57) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2188 = "llvm.call_intrinsic"(%2185, %20, %2187) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%2188, %arg5) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2189 = "llvm.add"(%2045, %19) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%2189, %326) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "fd_r43x6_ge_decode", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 64>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 128>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 192>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 256>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 320>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 384>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 448>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 512>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 576>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 640>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 704>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 712>, <#llvm.tbaa_type_desc<id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 720>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 712>]}> : (i64, !llvm.ptr) -> ()
  "llvm.br"(%2044, %2042, %2040)[^bb37] : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
^bb35:  // pred: ^bb33
  %2190 = "llvm.load"(%327) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "fd_r43x6_ge_decode", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 64>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 128>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 192>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 256>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 320>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 384>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 448>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 512>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 576>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 640>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 704>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 712>, <#llvm.tbaa_type_desc<id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 720>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 704>]}> : (!llvm.ptr) -> i64
  %2191 = "llvm.icmp"(%2190, %18) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%2191, %2044, %2042, %2040)[^bb36, ^bb37] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 3>}> : (i1, vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
^bb36:  // pred: ^bb35
  "llvm.call"(%arg5, %56) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_ge_decode_step_slow, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, i64) -> ()
  "llvm.br"(%2044, %2042, %2040)[^bb37] : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
^bb37(%2192: vector<8xi64>, %2193: vector<8xi64>, %2194: vector<8xi64>):  // 9 preds: ^bb26, ^bb28, ^bb29, ^bb30, ^bb31, ^bb32, ^bb34, ^bb35, ^bb36
  %2195 = "llvm.add"(%485, %1) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2196 = "llvm.icmp"(%2195, %35) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%2196, %2195, %2192, %2193, %2194)[^bb12, ^bb13] <{loop_annotation = #llvm.loop_annotation<mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 4>}> : (i1, i64, vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
^bb38:  // 3 preds: ^bb3, ^bb4, ^bb12
  "llvm.intr.lifetime.end"(%200) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%199) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%198) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%197) : (!llvm.ptr) -> ()
  "llvm.return"(%arg0) : (!llvm.ptr) -> ()
}) : () -> ()

    with
      @fd_ed25519_base_point_wnaf_table := Firedancer.Lane.Mlir.fd_ed25519_base_point_wnaf_table,
      @fd_curve25519_scalar_wnaf := Firedancer.Lane.Mlir.fd_curve25519_scalar_wnaf,
      @fd_curve25519_scalar_wnaf := Firedancer.Lane.Mlir.fd_curve25519_scalar_wnaf,
      @fd_ed25519_partial_dbl := Firedancer.Lane.Mlir.fd_ed25519_partial_dbl,
      @fd_r43x6_ge_decode_step_slow := Firedancer.Lane.Mlir.fd_r43x6_ge_decode_step_slow,
      @fd_r43x6_ge_decode_step_slow := Firedancer.Lane.Mlir.fd_r43x6_ge_decode_step_slow,
      @fd_r43x6_ge_decode_step_slow := Firedancer.Lane.Mlir.fd_r43x6_ge_decode_step_slow,
      @fd_r43x6_ge_decode_step_slow := Firedancer.Lane.Mlir.fd_r43x6_ge_decode_step_slow,
      @fd_r43x6_ge_decode_step_slow := Firedancer.Lane.Mlir.fd_r43x6_ge_decode_step_slow

end

end Firedancer.Lane.Mlir
