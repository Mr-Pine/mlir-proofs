
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab



namespace Firedancer.Lane.Mlir

@[expose] public section

mlir_def fd_r43x6_ge_decode_init := "llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<external>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], sym_name = "fd_r43x6_ge_decode_init", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr):
  %0 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %1 = "llvm.mlir.constant"() <{value = dense<[1, 0, 0, 0, 0, 0, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %2 = "llvm.mlir.constant"() <{value = dense<704489577558> : vector<8xi64>}> : () -> vector<8xi64>
  %3 = "llvm.mlir.constant"() <{value = dense<7696165686388> : vector<8xi64>}> : () -> vector<8xi64>
  %4 = "llvm.mlir.constant"() <{value = dense<260847760460> : vector<8xi64>}> : () -> vector<8xi64>
  %5 = "llvm.mlir.constant"() <{value = dense<7518893317> : vector<8xi64>}> : () -> vector<8xi64>
  %6 = "llvm.mlir.constant"() <{value = dense<253762649449> : vector<8xi64>}> : () -> vector<8xi64>
  %7 = "llvm.mlir.constant"() <{value = dense<6365466163363> : vector<8xi64>}> : () -> vector<8xi64>
  %8 = "llvm.mlir.constant"() <{value = dense<[159383552, 1048576, 1048576, 1048576, 1048576, 1048576, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %9 = "llvm.mlir.constant"() <{value = dense<[-1, 0, 0, 0, 0, 0, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %10 = "llvm.mlir.constant"() <{value = dense<18> : vector<8xi64>}> : () -> vector<8xi64>
  %11 = "llvm.mlir.constant"() <{value = dense<[8795933638636, 8796091973631, 8796091973631, 8796091973631, 8796091973631, 1099510579199, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %12 = "llvm.mlir.constant"() <{value = dense<[19, 1, 1, 1, 1, 1, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %13 = "llvm.mlir.constant"() <{value = dense<[43, 43, 43, 43, 43, 40, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %14 = "llvm.mlir.constant"() <{value = dense<[8796093022207, 8796093022207, 8796093022207, 8796093022207, 8796093022207, 1099511627775, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %15 = "llvm.mlir.constant"() <{value = dense<24> : vector<8xi64>}> : () -> vector<8xi64>
  %16 = "llvm.mlir.constant"() <{value = dense<7> : vector<8xi64>}> : () -> vector<8xi64>
  %17 = "llvm.mlir.constant"() <{value = dense<[-1, -1, -1, -1, -1, -1, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %18 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %19 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %20 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %21 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %22 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %23 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %24 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %25 = "llvm.mlir.constant"() <{value = 63 : i64}> : () -> i64
  %26 = "llvm.mlir.constant"() <{value = dense<[-1, -1, -1, 9223372036854775807]> : vector<4xi64>}> : () -> vector<4xi64>
  %27 = "llvm.mlir.poison"() : () -> vector<4xi64>
  %28 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %29 = "llvm.mlir.constant"() <{value = 7 : i64}> : () -> i64
  %30 = "llvm.mlir.poison"() : () -> vector<64xi8>
  %31 = "llvm.mlir.constant"() <{value = dense<[0, 3, 6, 1, 4, 7, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %32 = "llvm.mlir.constant"() <{value = dense<8796093022207> : vector<8xi64>}> : () -> vector<8xi64>
  %33 = "llvm.mlir.poison"() : () -> vector<8xi64>
  %34 = "llvm.mlir.constant"() <{value = dense<[0, 1, 1, 1, 1, 1, 0, 1]> : vector<8xi64>}> : () -> vector<8xi64>
  %35 = "llvm.mlir.constant"() <{value = dense<[0, 1, 0, 1, 1, 1, 1, 1]> : vector<8xi64>}> : () -> vector<8xi64>
  %36 = "llvm.mlir.constant"() <{value = dense<[1, 1, 0, 1, 0, 1, 1, 1]> : vector<8xi64>}> : () -> vector<8xi64>
  %37 = "llvm.mlir.constant"() <{value = dense<0> : vector<8xi64>}> : () -> vector<8xi64>
  %38 = "llvm.mlir.constant"() <{value = dense<9> : vector<8xi64>}> : () -> vector<8xi64>
  %39 = "llvm.mlir.constant"() <{value = dense<[0, 0, -1, -1, -1, -1, -1, -1]> : vector<8xi64>}> : () -> vector<8xi64>
  %40 = "llvm.mlir.constant"() <{value = dense<[0, -1, 0, -1, -1, -1, -1, -1]> : vector<8xi64>}> : () -> vector<8xi64>
  %41 = "llvm.mlir.poison"() : () -> i64
  %42 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %43 = "llvm.mlir.undef"() : () -> vector<8xi64>
  %44 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %45 = "llvm.insertelement"(%43, %42, %44) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %46 = "llvm.insertelement"(%45, %42, %24) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %47 = "llvm.insertelement"(%46, %28, %23) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %48 = "llvm.insertelement"(%47, %28, %22) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %49 = "llvm.insertelement"(%48, %28, %21) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %50 = "llvm.insertelement"(%49, %28, %20) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %51 = "llvm.insertelement"(%50, %41, %19) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %52 = "llvm.insertelement"(%51, %41, %18) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %53 = "llvm.insertelement"(%43, %42, %44) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %54 = "llvm.insertelement"(%53, %28, %24) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %55 = "llvm.insertelement"(%54, %42, %23) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %56 = "llvm.insertelement"(%55, %28, %22) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %57 = "llvm.insertelement"(%56, %28, %21) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %58 = "llvm.insertelement"(%57, %28, %20) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %59 = "llvm.insertelement"(%58, %41, %19) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %60 = "llvm.insertelement"(%59, %41, %18) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %61 = "llvm.insertelement"(%43, %42, %44) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %62 = "llvm.insertelement"(%61, %42, %24) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %63 = "llvm.insertelement"(%62, %28, %23) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %64 = "llvm.insertelement"(%63, %28, %22) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %65 = "llvm.insertelement"(%64, %28, %21) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %66 = "llvm.insertelement"(%65, %41, %20) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %67 = "llvm.insertelement"(%66, %41, %19) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %68 = "llvm.insertelement"(%67, %41, %18) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %69 = "llvm.insertelement"(%43, %42, %44) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %70 = "llvm.insertelement"(%69, %28, %24) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %71 = "llvm.insertelement"(%70, %42, %23) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %72 = "llvm.insertelement"(%71, %28, %22) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %73 = "llvm.insertelement"(%72, %28, %21) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %74 = "llvm.insertelement"(%73, %41, %20) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %75 = "llvm.insertelement"(%74, %41, %19) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %76 = "llvm.insertelement"(%75, %41, %18) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %77 = "llvm.insertelement"(%43, %41, %44) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %78 = "llvm.insertelement"(%77, %41, %24) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %79 = "llvm.insertelement"(%78, %41, %23) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %80 = "llvm.insertelement"(%79, %41, %22) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %81 = "llvm.insertelement"(%80, %41, %21) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %82 = "llvm.insertelement"(%81, %41, %20) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %83 = "llvm.insertelement"(%82, %41, %19) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %84 = "llvm.insertelement"(%83, %28, %18) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %85 = "llvm.insertelement"(%43, %28, %44) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %86 = "llvm.insertelement"(%85, %28, %24) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %87 = "llvm.insertelement"(%86, %28, %23) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %88 = "llvm.insertelement"(%87, %28, %22) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %89 = "llvm.insertelement"(%88, %28, %21) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %90 = "llvm.insertelement"(%89, %41, %20) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %91 = "llvm.insertelement"(%90, %41, %19) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %92 = "llvm.insertelement"(%91, %41, %18) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %93 = "llvm.insertelement"(%43, %28, %44) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %94 = "llvm.insertelement"(%93, %41, %24) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %95 = "llvm.insertelement"(%94, %41, %23) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %96 = "llvm.insertelement"(%95, %41, %22) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %97 = "llvm.insertelement"(%96, %41, %21) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %98 = "llvm.insertelement"(%97, %41, %20) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %99 = "llvm.insertelement"(%98, %41, %19) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %100 = "llvm.insertelement"(%99, %41, %18) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %101 = "llvm.insertelement"(%43, %41, %44) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %102 = "llvm.insertelement"(%101, %41, %24) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %103 = "llvm.insertelement"(%102, %41, %23) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %104 = "llvm.insertelement"(%103, %41, %22) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %105 = "llvm.insertelement"(%104, %41, %21) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %106 = "llvm.insertelement"(%105, %41, %20) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %107 = "llvm.insertelement"(%106, %28, %19) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %108 = "llvm.insertelement"(%107, %28, %18) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %109 = "llvm.insertelement"(%43, %41, %44) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %110 = "llvm.insertelement"(%109, %41, %24) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %111 = "llvm.insertelement"(%110, %41, %23) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %112 = "llvm.insertelement"(%111, %41, %22) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %113 = "llvm.insertelement"(%112, %41, %21) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %114 = "llvm.insertelement"(%113, %28, %20) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %115 = "llvm.insertelement"(%114, %28, %19) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %116 = "llvm.insertelement"(%115, %28, %18) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %117 = "llvm.insertelement"(%43, %28, %44) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %118 = "llvm.insertelement"(%117, %28, %24) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %119 = "llvm.insertelement"(%118, %28, %23) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %120 = "llvm.insertelement"(%119, %41, %22) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %121 = "llvm.insertelement"(%120, %41, %21) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %122 = "llvm.insertelement"(%121, %41, %20) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %123 = "llvm.insertelement"(%122, %41, %19) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %124 = "llvm.insertelement"(%123, %41, %18) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %125 = "llvm.insertelement"(%43, %41, %44) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %126 = "llvm.insertelement"(%125, %41, %24) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %127 = "llvm.insertelement"(%126, %41, %23) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %128 = "llvm.insertelement"(%127, %41, %22) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %129 = "llvm.insertelement"(%128, %28, %21) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %130 = "llvm.insertelement"(%129, %28, %20) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %131 = "llvm.insertelement"(%130, %28, %19) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %132 = "llvm.insertelement"(%131, %28, %18) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %133 = "llvm.insertelement"(%43, %28, %44) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %134 = "llvm.insertelement"(%133, %28, %24) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %135 = "llvm.insertelement"(%134, %41, %23) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %136 = "llvm.insertelement"(%135, %41, %22) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %137 = "llvm.insertelement"(%136, %41, %21) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %138 = "llvm.insertelement"(%137, %41, %20) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %139 = "llvm.insertelement"(%138, %41, %19) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %140 = "llvm.insertelement"(%139, %41, %18) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %141 = "llvm.insertelement"(%43, %41, %44) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %142 = "llvm.insertelement"(%141, %41, %24) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %143 = "llvm.insertelement"(%142, %41, %23) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %144 = "llvm.insertelement"(%143, %28, %22) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %145 = "llvm.insertelement"(%144, %28, %21) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %146 = "llvm.insertelement"(%145, %28, %20) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %147 = "llvm.insertelement"(%146, %28, %19) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %148 = "llvm.insertelement"(%147, %28, %18) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %149 = "llvm.insertelement"(%43, %41, %44) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %150 = "llvm.insertelement"(%149, %41, %24) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %151 = "llvm.insertelement"(%150, %28, %23) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %152 = "llvm.insertelement"(%151, %28, %22) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %153 = "llvm.insertelement"(%152, %28, %21) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %154 = "llvm.insertelement"(%153, %28, %20) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %155 = "llvm.insertelement"(%154, %28, %19) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %156 = "llvm.insertelement"(%155, %28, %18) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %157 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %158 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 720>}> : (!llvm.ptr) -> !llvm.ptr
  %159 = "llvm.load"(%157) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %160 = "llvm.load"(%arg1) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %161 = "llvm.lshr"(%159, %25) : (i64, i64) -> i64
  %162 = "llvm.trunc"(%161) <{overflowFlags = 3 : i32}> : (i64) -> i32
  "llvm.store"(%162, %158) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "fd_r43x6_ge_decode", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 64>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 128>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 192>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 256>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 320>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 384>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 448>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 512>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 576>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 640>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 704>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 712>, <#llvm.tbaa_type_desc<id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 720>}>, access_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 720>]}> : (i32, !llvm.ptr) -> ()
  %163 = "llvm.and"(%160, %26) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %164 = "llvm.shufflevector"(%163, %27) <{mask = array<i32: 0, 1, 2, 3, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %165 = "llvm.insertelement"(%164, %28, %29) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %166 = "llvm.bitcast"(%165) : (vector<8xi64>) -> vector<64xi8>
  %167 = "llvm.shufflevector"(%166, %30) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 63, 63, 5, 6, 7, 8, 9, 10, 63, 63, 10, 11, 12, 13, 14, 15, 16, 63, 16, 17, 18, 19, 20, 21, 63, 63, 21, 22, 23, 24, 25, 26, 63, 63, 26, 27, 28, 29, 30, 31, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %168 = "llvm.bitcast"(%167) : (vector<64xi8>) -> vector<8xi64>
  %169 = "llvm.lshr"(%168, %31) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %170 = "llvm.and"(%169, %32) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %171 = "llvm.shufflevector"(%170, %33) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %172 = "llvm.shufflevector"(%170, %33) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 3, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %173 = "llvm.shufflevector"(%170, %33) <{mask = array<i32: 4, 4, 1, 1, 1, 1, 1, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %174 = "llvm.shufflevector"(%170, %33) <{mask = array<i32: 4, 5, 1, 2, 3, 4, 5, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %175 = "llvm.shufflevector"(%170, %33) <{mask = array<i32: 3, 7, 5, 7, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %176 = "llvm.shufflevector"(%170, %33) <{mask = array<i32: 5, 7, 5, 7, 2, 3, 4, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %177 = "llvm.shl"(%171, %34) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %178 = "llvm.shl"(%173, %35) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %179 = "llvm.shl"(%175, %36) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %180 = "llvm.call_intrinsic"(%37, %178, %174) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %181 = "llvm.call_intrinsic"(%37, %179, %176) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %182 = "llvm.call_intrinsic"(%37, %177, %172) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %183 = "llvm.shl"(%182, %38) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %184 = "llvm.call_intrinsic"(%37, %178, %174) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %185 = "llvm.shl"(%184, %38) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %186 = "llvm.call_intrinsic"(%37, %179, %176) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %187 = "llvm.shl"(%186, %38) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %188 = "llvm.and"(%180, %39) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %189 = "llvm.and"(%181, %40) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %190 = "llvm.add"(%189, %188) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %191 = "llvm.call_intrinsic"(%190, %177, %172) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %192 = "llvm.and"(%185, %39) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %193 = "llvm.and"(%187, %40) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %194 = "llvm.add"(%192, %183) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %195 = "llvm.add"(%194, %193) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %196 = "llvm.and"(%180, %52) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %197 = "llvm.and"(%181, %60) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %198 = "llvm.and"(%185, %68) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %199 = "llvm.and"(%187, %76) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %200 = "llvm.add"(%199, %198) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %201 = "llvm.shufflevector"(%84, %195) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %202 = "llvm.add"(%201, %191) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %203 = "llvm.shufflevector"(%84, %200) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %204 = "llvm.shufflevector"(%195, %92) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %205 = "llvm.add"(%197, %196) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %206 = "llvm.add"(%205, %203) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %207 = "llvm.add"(%206, %204) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %208 = "llvm.and"(%202, %17) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %209 = "llvm.shufflevector"(%202, %207) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %210 = "llvm.shl"(%209, %16) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %211 = "llvm.add"(%210, %208) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %212 = "llvm.mul"(%209, %15) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %213 = "llvm.add"(%211, %212) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %214 = "llvm.and"(%213, %14) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %215 = "llvm.lshr"(%213, %13) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %216 = "llvm.shufflevector"(%215, %33) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %217 = "llvm.call_intrinsic"(%214, %12, %216) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %218 = "llvm.add"(%217, %11) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %219 = "llvm.and"(%218, %14) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %220 = "llvm.ashr"(%218, %13) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %221 = "llvm.shufflevector"(%220, %100) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 8, 8>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %222 = "llvm.mul"(%221, %10) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %223 = "llvm.and"(%222, %9) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %224 = "llvm.add"(%219, %8) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %225 = "llvm.add"(%224, %221) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %226 = "llvm.add"(%225, %223) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %227 = "llvm.call_intrinsic"(%37, %7, %217) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %228 = "llvm.shl"(%227, %38) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %229 = "llvm.call_intrinsic"(%228, %6, %217) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %230 = "llvm.call_intrinsic"(%37, %6, %217) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %231 = "llvm.shl"(%230, %38) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %232 = "llvm.call_intrinsic"(%231, %5, %217) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %233 = "llvm.call_intrinsic"(%37, %5, %217) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %234 = "llvm.shl"(%233, %38) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %235 = "llvm.call_intrinsic"(%234, %4, %217) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %236 = "llvm.call_intrinsic"(%37, %4, %217) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %237 = "llvm.shl"(%236, %38) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %238 = "llvm.call_intrinsic"(%237, %3, %217) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %239 = "llvm.call_intrinsic"(%37, %3, %217) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %240 = "llvm.shl"(%239, %38) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %241 = "llvm.call_intrinsic"(%240, %2, %217) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %242 = "llvm.call_intrinsic"(%37, %2, %217) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %243 = "llvm.shl"(%242, %38) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %244 = "llvm.shufflevector"(%84, %229) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %245 = "llvm.shufflevector"(%108, %232) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %246 = "llvm.shufflevector"(%116, %235) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %247 = "llvm.shufflevector"(%235, %124) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %248 = "llvm.shufflevector"(%132, %238) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %249 = "llvm.shufflevector"(%238, %140) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %250 = "llvm.shufflevector"(%148, %241) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %251 = "llvm.shufflevector"(%241, %100) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %252 = "llvm.shufflevector"(%156, %243) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %253 = "llvm.shufflevector"(%243, %33) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %254 = "llvm.call_intrinsic"(%244, %7, %217) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %255 = "llvm.add"(%246, %245) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %256 = "llvm.add"(%255, %248) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %257 = "llvm.add"(%256, %250) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %258 = "llvm.add"(%257, %254) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %259 = "llvm.add"(%258, %252) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %260 = "llvm.add"(%249, %247) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %261 = "llvm.add"(%260, %251) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %262 = "llvm.add"(%261, %253) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %263 = "llvm.and"(%259, %17) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %264 = "llvm.shufflevector"(%259, %262) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %265 = "llvm.shl"(%264, %16) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %266 = "llvm.add"(%265, %263) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %267 = "llvm.mul"(%264, %15) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %268 = "llvm.add"(%266, %267) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %269 = "llvm.and"(%268, %14) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %270 = "llvm.lshr"(%268, %13) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %271 = "llvm.shufflevector"(%270, %33) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %272 = "llvm.call_intrinsic"(%269, %12, %271) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %273 = "llvm.add"(%272, %1) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %274 = "llvm.shufflevector"(%273, %33) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %275 = "llvm.shufflevector"(%273, %33) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 3, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %276 = "llvm.shufflevector"(%273, %33) <{mask = array<i32: 4, 4, 1, 1, 1, 1, 1, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %277 = "llvm.shufflevector"(%273, %33) <{mask = array<i32: 4, 5, 1, 2, 3, 4, 5, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %278 = "llvm.shufflevector"(%273, %33) <{mask = array<i32: 3, 7, 5, 7, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %279 = "llvm.shufflevector"(%273, %33) <{mask = array<i32: 5, 7, 5, 7, 2, 3, 4, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %280 = "llvm.shl"(%274, %34) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %281 = "llvm.shl"(%276, %35) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %282 = "llvm.shl"(%278, %36) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %283 = "llvm.call_intrinsic"(%37, %281, %277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %284 = "llvm.call_intrinsic"(%37, %282, %279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %285 = "llvm.call_intrinsic"(%37, %280, %275) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %286 = "llvm.shl"(%285, %38) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %287 = "llvm.call_intrinsic"(%37, %281, %277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %288 = "llvm.shl"(%287, %38) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %289 = "llvm.call_intrinsic"(%37, %282, %279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %290 = "llvm.shl"(%289, %38) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %291 = "llvm.and"(%283, %39) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %292 = "llvm.and"(%284, %40) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %293 = "llvm.add"(%292, %291) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %294 = "llvm.call_intrinsic"(%293, %280, %275) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %295 = "llvm.and"(%288, %39) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %296 = "llvm.and"(%290, %40) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %297 = "llvm.add"(%295, %286) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %298 = "llvm.add"(%297, %296) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %299 = "llvm.and"(%283, %52) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %300 = "llvm.and"(%284, %60) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %301 = "llvm.and"(%288, %68) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %302 = "llvm.and"(%290, %76) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %303 = "llvm.add"(%302, %301) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %304 = "llvm.shufflevector"(%84, %298) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %305 = "llvm.add"(%304, %294) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %306 = "llvm.shufflevector"(%84, %303) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %307 = "llvm.shufflevector"(%298, %92) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %308 = "llvm.add"(%300, %299) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %309 = "llvm.add"(%308, %306) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %310 = "llvm.add"(%309, %307) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %311 = "llvm.and"(%305, %17) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %312 = "llvm.shufflevector"(%305, %310) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %313 = "llvm.shl"(%312, %16) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %314 = "llvm.add"(%313, %311) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %315 = "llvm.mul"(%312, %15) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %316 = "llvm.add"(%314, %315) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %317 = "llvm.and"(%316, %14) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %318 = "llvm.lshr"(%316, %13) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %319 = "llvm.shufflevector"(%318, %33) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %320 = "llvm.call_intrinsic"(%317, %12, %319) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %321 = "llvm.shufflevector"(%320, %33) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %322 = "llvm.shufflevector"(%320, %33) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 3, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %323 = "llvm.shufflevector"(%320, %33) <{mask = array<i32: 4, 4, 1, 1, 1, 1, 1, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %324 = "llvm.shufflevector"(%320, %33) <{mask = array<i32: 4, 5, 1, 2, 3, 4, 5, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %325 = "llvm.shufflevector"(%320, %33) <{mask = array<i32: 3, 7, 5, 7, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %326 = "llvm.shufflevector"(%320, %33) <{mask = array<i32: 5, 7, 5, 7, 2, 3, 4, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %327 = "llvm.shl"(%321, %34) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %328 = "llvm.shl"(%323, %35) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %329 = "llvm.shl"(%325, %36) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %330 = "llvm.call_intrinsic"(%37, %328, %324) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %331 = "llvm.call_intrinsic"(%37, %329, %326) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %332 = "llvm.call_intrinsic"(%37, %327, %322) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %333 = "llvm.shl"(%332, %38) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %334 = "llvm.call_intrinsic"(%37, %328, %324) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %335 = "llvm.shl"(%334, %38) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %336 = "llvm.call_intrinsic"(%37, %329, %326) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %337 = "llvm.shl"(%336, %38) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %338 = "llvm.and"(%330, %39) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %339 = "llvm.and"(%331, %40) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %340 = "llvm.add"(%339, %338) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %341 = "llvm.call_intrinsic"(%340, %327, %322) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %342 = "llvm.and"(%335, %39) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %343 = "llvm.and"(%337, %40) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %344 = "llvm.add"(%342, %333) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %345 = "llvm.add"(%344, %343) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %346 = "llvm.and"(%330, %52) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %347 = "llvm.and"(%331, %60) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %348 = "llvm.and"(%335, %68) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %349 = "llvm.and"(%337, %76) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %350 = "llvm.add"(%349, %348) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %351 = "llvm.shufflevector"(%84, %345) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %352 = "llvm.add"(%351, %341) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %353 = "llvm.shufflevector"(%84, %350) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %354 = "llvm.shufflevector"(%345, %92) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %355 = "llvm.add"(%347, %346) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %356 = "llvm.add"(%355, %353) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %357 = "llvm.add"(%356, %354) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %358 = "llvm.and"(%352, %17) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %359 = "llvm.shufflevector"(%352, %357) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %360 = "llvm.shl"(%359, %16) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %361 = "llvm.add"(%360, %358) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %362 = "llvm.mul"(%359, %15) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %363 = "llvm.add"(%361, %362) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %364 = "llvm.and"(%363, %14) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %365 = "llvm.lshr"(%363, %13) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %366 = "llvm.shufflevector"(%365, %33) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %367 = "llvm.call_intrinsic"(%364, %12, %366) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %368 = "llvm.shufflevector"(%273, %33) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %369 = "llvm.shufflevector"(%273, %33) <{mask = array<i32: 1, 1, 1, 1, 1, 1, 1, 1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %370 = "llvm.shufflevector"(%273, %33) <{mask = array<i32: 2, 2, 2, 2, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %371 = "llvm.shufflevector"(%273, %33) <{mask = array<i32: 3, 3, 3, 3, 3, 3, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %372 = "llvm.shufflevector"(%273, %33) <{mask = array<i32: 4, 4, 4, 4, 4, 4, 4, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %373 = "llvm.shufflevector"(%273, %33) <{mask = array<i32: 5, 5, 5, 5, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %374 = "llvm.call_intrinsic"(%37, %368, %320) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %375 = "llvm.shl"(%374, %38) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %376 = "llvm.call_intrinsic"(%375, %369, %320) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %377 = "llvm.call_intrinsic"(%37, %369, %320) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %378 = "llvm.shl"(%377, %38) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %379 = "llvm.call_intrinsic"(%378, %370, %320) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %380 = "llvm.call_intrinsic"(%37, %370, %320) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %381 = "llvm.shl"(%380, %38) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %382 = "llvm.call_intrinsic"(%381, %371, %320) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %383 = "llvm.call_intrinsic"(%37, %371, %320) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %384 = "llvm.shl"(%383, %38) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %385 = "llvm.call_intrinsic"(%384, %372, %320) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %386 = "llvm.call_intrinsic"(%37, %372, %320) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %387 = "llvm.shl"(%386, %38) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %388 = "llvm.call_intrinsic"(%387, %373, %320) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %389 = "llvm.call_intrinsic"(%37, %373, %320) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %390 = "llvm.shl"(%389, %38) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %391 = "llvm.shufflevector"(%84, %376) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %392 = "llvm.shufflevector"(%108, %379) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %393 = "llvm.shufflevector"(%116, %382) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %394 = "llvm.shufflevector"(%382, %124) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %395 = "llvm.shufflevector"(%132, %385) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %396 = "llvm.shufflevector"(%385, %140) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %397 = "llvm.shufflevector"(%148, %388) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %398 = "llvm.shufflevector"(%388, %100) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %399 = "llvm.shufflevector"(%156, %390) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %400 = "llvm.shufflevector"(%390, %33) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %401 = "llvm.call_intrinsic"(%391, %368, %320) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %402 = "llvm.add"(%393, %392) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %403 = "llvm.add"(%402, %395) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %404 = "llvm.add"(%403, %397) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %405 = "llvm.add"(%404, %401) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %406 = "llvm.add"(%405, %399) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %407 = "llvm.add"(%396, %394) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %408 = "llvm.add"(%407, %398) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %409 = "llvm.add"(%408, %400) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %410 = "llvm.and"(%406, %17) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %411 = "llvm.shufflevector"(%406, %409) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %412 = "llvm.shl"(%411, %16) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %413 = "llvm.add"(%412, %410) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %414 = "llvm.mul"(%411, %15) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %415 = "llvm.add"(%413, %414) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %416 = "llvm.and"(%415, %14) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %417 = "llvm.lshr"(%415, %13) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %418 = "llvm.shufflevector"(%417, %33) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %419 = "llvm.call_intrinsic"(%416, %12, %418) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %420 = "llvm.shufflevector"(%226, %33) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %421 = "llvm.shufflevector"(%226, %33) <{mask = array<i32: 1, 1, 1, 1, 1, 1, 1, 1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %422 = "llvm.shufflevector"(%226, %33) <{mask = array<i32: 2, 2, 2, 2, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %423 = "llvm.shufflevector"(%226, %33) <{mask = array<i32: 3, 3, 3, 3, 3, 3, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %424 = "llvm.shufflevector"(%226, %33) <{mask = array<i32: 4, 4, 4, 4, 4, 4, 4, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %425 = "llvm.shufflevector"(%226, %33) <{mask = array<i32: 5, 5, 5, 5, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %426 = "llvm.call_intrinsic"(%37, %420, %419) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %427 = "llvm.shl"(%426, %38) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %428 = "llvm.call_intrinsic"(%427, %421, %419) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %429 = "llvm.call_intrinsic"(%37, %421, %419) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %430 = "llvm.shl"(%429, %38) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %431 = "llvm.call_intrinsic"(%430, %422, %419) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %432 = "llvm.call_intrinsic"(%37, %422, %419) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %433 = "llvm.shl"(%432, %38) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %434 = "llvm.call_intrinsic"(%433, %423, %419) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %435 = "llvm.call_intrinsic"(%37, %423, %419) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %436 = "llvm.shl"(%435, %38) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %437 = "llvm.call_intrinsic"(%436, %424, %419) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %438 = "llvm.call_intrinsic"(%37, %424, %419) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %439 = "llvm.shl"(%438, %38) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %440 = "llvm.call_intrinsic"(%439, %425, %419) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %441 = "llvm.call_intrinsic"(%37, %425, %419) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %442 = "llvm.shl"(%441, %38) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %443 = "llvm.shufflevector"(%84, %428) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %444 = "llvm.shufflevector"(%108, %431) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %445 = "llvm.shufflevector"(%116, %434) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %446 = "llvm.shufflevector"(%434, %124) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %447 = "llvm.shufflevector"(%132, %437) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %448 = "llvm.shufflevector"(%437, %140) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %449 = "llvm.shufflevector"(%148, %440) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %450 = "llvm.shufflevector"(%440, %100) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %451 = "llvm.shufflevector"(%156, %442) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %452 = "llvm.shufflevector"(%442, %33) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %453 = "llvm.call_intrinsic"(%443, %420, %419) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %454 = "llvm.add"(%445, %444) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %455 = "llvm.add"(%454, %447) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %456 = "llvm.add"(%455, %449) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %457 = "llvm.add"(%456, %453) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %458 = "llvm.add"(%457, %451) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %459 = "llvm.add"(%448, %446) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %460 = "llvm.add"(%459, %450) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %461 = "llvm.add"(%460, %452) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %462 = "llvm.and"(%458, %17) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %463 = "llvm.shufflevector"(%458, %461) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %464 = "llvm.shl"(%463, %16) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %465 = "llvm.add"(%464, %462) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %466 = "llvm.mul"(%463, %15) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %467 = "llvm.add"(%465, %466) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %468 = "llvm.and"(%467, %14) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %469 = "llvm.lshr"(%467, %13) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %470 = "llvm.shufflevector"(%469, %33) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %471 = "llvm.call_intrinsic"(%468, %12, %470) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %472 = "llvm.shufflevector"(%471, %33) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %473 = "llvm.shufflevector"(%471, %33) <{mask = array<i32: 1, 1, 1, 1, 1, 1, 1, 1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %474 = "llvm.shufflevector"(%471, %33) <{mask = array<i32: 2, 2, 2, 2, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %475 = "llvm.shufflevector"(%471, %33) <{mask = array<i32: 3, 3, 3, 3, 3, 3, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %476 = "llvm.shufflevector"(%471, %33) <{mask = array<i32: 4, 4, 4, 4, 4, 4, 4, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %477 = "llvm.shufflevector"(%471, %33) <{mask = array<i32: 5, 5, 5, 5, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %478 = "llvm.call_intrinsic"(%37, %472, %367) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %479 = "llvm.shl"(%478, %38) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %480 = "llvm.call_intrinsic"(%479, %473, %367) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %481 = "llvm.call_intrinsic"(%37, %473, %367) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %482 = "llvm.shl"(%481, %38) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %483 = "llvm.call_intrinsic"(%482, %474, %367) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %484 = "llvm.call_intrinsic"(%37, %474, %367) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %485 = "llvm.shl"(%484, %38) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %486 = "llvm.call_intrinsic"(%485, %475, %367) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %487 = "llvm.call_intrinsic"(%37, %475, %367) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %488 = "llvm.shl"(%487, %38) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %489 = "llvm.call_intrinsic"(%488, %476, %367) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %490 = "llvm.call_intrinsic"(%37, %476, %367) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %491 = "llvm.shl"(%490, %38) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %492 = "llvm.call_intrinsic"(%491, %477, %367) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %493 = "llvm.call_intrinsic"(%37, %477, %367) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %494 = "llvm.shl"(%493, %38) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %495 = "llvm.shufflevector"(%84, %480) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %496 = "llvm.shufflevector"(%108, %483) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %497 = "llvm.shufflevector"(%116, %486) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %498 = "llvm.shufflevector"(%486, %124) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %499 = "llvm.shufflevector"(%132, %489) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %500 = "llvm.shufflevector"(%489, %140) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %501 = "llvm.shufflevector"(%148, %492) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %502 = "llvm.shufflevector"(%492, %100) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %503 = "llvm.shufflevector"(%156, %494) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %504 = "llvm.shufflevector"(%494, %33) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %505 = "llvm.call_intrinsic"(%495, %472, %367) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %506 = "llvm.add"(%497, %496) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %507 = "llvm.add"(%506, %499) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %508 = "llvm.add"(%507, %501) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %509 = "llvm.add"(%508, %505) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %510 = "llvm.add"(%509, %503) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %511 = "llvm.add"(%500, %498) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %512 = "llvm.add"(%511, %502) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %513 = "llvm.add"(%512, %504) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %514 = "llvm.and"(%510, %17) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %515 = "llvm.shufflevector"(%510, %513) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %516 = "llvm.shl"(%515, %16) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %517 = "llvm.add"(%516, %514) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %518 = "llvm.mul"(%515, %15) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %519 = "llvm.add"(%517, %518) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %520 = "llvm.and"(%519, %14) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %521 = "llvm.lshr"(%519, %13) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %522 = "llvm.shufflevector"(%521, %33) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %523 = "llvm.call_intrinsic"(%520, %12, %522) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %524 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 448>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%170, %524) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %525 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 512>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%226, %525) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %526 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 576>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%273, %526) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %527 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 640>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%471, %527) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %528 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%523, %528) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%523, %arg0) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %529 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%523, %529) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %530 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 704>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%28, %530) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "fd_r43x6_ge_decode", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 64>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 128>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 192>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 256>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 320>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 384>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 448>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 512>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 576>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 640>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 704>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 712>, <#llvm.tbaa_type_desc<id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 720>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 704>]}> : (i64, !llvm.ptr) -> ()
  %531 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 712>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%0, %531) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "fd_r43x6_ge_decode", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 64>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 128>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 192>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 256>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 320>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 384>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 448>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 512>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 576>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 640>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 704>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 712>, <#llvm.tbaa_type_desc<id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 720>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 712>]}> : (i64, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end Firedancer.Lane.Mlir
