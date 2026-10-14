
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.Lane.Mlir.decode_stage_sqr_cnt

namespace Firedancer.Lane.Mlir

@[expose] public section

mlir_def fd_r43x6_ge_decode_step_slow := "llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef}, {llvm.noundef}], frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, i64)>, linkage = #llvm.linkage<external>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], sym_name = "fd_r43x6_ge_decode_step_slow", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr, %arg1: i64):
  %0 = "llvm.mlir.addressof"() <{global_name = @decode_stage.sqr_cnt}> : () -> !llvm.ptr
  %1 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %2 = "llvm.mlir.constant"() <{value = dense<[19, 1, 1, 1, 1, 1, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %3 = "llvm.mlir.constant"() <{value = dense<[43, 43, 43, 43, 43, 40, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %4 = "llvm.mlir.constant"() <{value = dense<[8796093022207, 8796093022207, 8796093022207, 8796093022207, 8796093022207, 1099511627775, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %5 = "llvm.mlir.constant"() <{value = dense<24> : vector<8xi64>}> : () -> vector<8xi64>
  %6 = "llvm.mlir.constant"() <{value = dense<7> : vector<8xi64>}> : () -> vector<8xi64>
  %7 = "llvm.mlir.constant"() <{value = dense<[-1, -1, -1, -1, -1, -1, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %8 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %9 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %10 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %11 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %12 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %13 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %14 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %15 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %16 = "llvm.mlir.constant"() <{value = 12 : i64}> : () -> i64
  %17 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %18 = "llvm.mlir.constant"() <{value = -2 : i64}> : () -> i64
  %19 = "llvm.mlir.poison"() : () -> vector<8xi64>
  %20 = "llvm.mlir.constant"() <{value = dense<[0, 1, 1, 1, 1, 1, 0, 1]> : vector<8xi64>}> : () -> vector<8xi64>
  %21 = "llvm.mlir.constant"() <{value = dense<[0, 1, 0, 1, 1, 1, 1, 1]> : vector<8xi64>}> : () -> vector<8xi64>
  %22 = "llvm.mlir.constant"() <{value = dense<[1, 1, 0, 1, 0, 1, 1, 1]> : vector<8xi64>}> : () -> vector<8xi64>
  %23 = "llvm.mlir.constant"() <{value = dense<0> : vector<8xi64>}> : () -> vector<8xi64>
  %24 = "llvm.mlir.constant"() <{value = dense<9> : vector<8xi64>}> : () -> vector<8xi64>
  %25 = "llvm.mlir.constant"() <{value = dense<[0, 0, -1, -1, -1, -1, -1, -1]> : vector<8xi64>}> : () -> vector<8xi64>
  %26 = "llvm.mlir.constant"() <{value = dense<[0, -1, 0, -1, -1, -1, -1, -1]> : vector<8xi64>}> : () -> vector<8xi64>
  %27 = "llvm.mlir.poison"() : () -> i64
  %28 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %29 = "llvm.mlir.undef"() : () -> vector<8xi64>
  %30 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %31 = "llvm.insertelement"(%29, %28, %30) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %32 = "llvm.insertelement"(%31, %28, %14) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %33 = "llvm.insertelement"(%32, %15, %13) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %34 = "llvm.insertelement"(%33, %15, %12) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %35 = "llvm.insertelement"(%34, %15, %11) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %36 = "llvm.insertelement"(%35, %15, %10) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %37 = "llvm.insertelement"(%36, %27, %9) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %38 = "llvm.insertelement"(%37, %27, %8) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %39 = "llvm.insertelement"(%29, %28, %30) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %40 = "llvm.insertelement"(%39, %15, %14) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %41 = "llvm.insertelement"(%40, %28, %13) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %42 = "llvm.insertelement"(%41, %15, %12) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %43 = "llvm.insertelement"(%42, %15, %11) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %44 = "llvm.insertelement"(%43, %15, %10) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %45 = "llvm.insertelement"(%44, %27, %9) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %46 = "llvm.insertelement"(%45, %27, %8) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %47 = "llvm.insertelement"(%29, %28, %30) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %48 = "llvm.insertelement"(%47, %28, %14) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %49 = "llvm.insertelement"(%48, %15, %13) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %50 = "llvm.insertelement"(%49, %15, %12) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %51 = "llvm.insertelement"(%50, %15, %11) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %52 = "llvm.insertelement"(%51, %27, %10) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %53 = "llvm.insertelement"(%52, %27, %9) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %54 = "llvm.insertelement"(%53, %27, %8) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %55 = "llvm.insertelement"(%29, %28, %30) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %56 = "llvm.insertelement"(%55, %15, %14) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %57 = "llvm.insertelement"(%56, %28, %13) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %58 = "llvm.insertelement"(%57, %15, %12) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %59 = "llvm.insertelement"(%58, %15, %11) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %60 = "llvm.insertelement"(%59, %27, %10) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %61 = "llvm.insertelement"(%60, %27, %9) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %62 = "llvm.insertelement"(%61, %27, %8) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %63 = "llvm.insertelement"(%29, %27, %30) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %64 = "llvm.insertelement"(%63, %27, %14) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %65 = "llvm.insertelement"(%64, %27, %13) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %66 = "llvm.insertelement"(%65, %27, %12) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %67 = "llvm.insertelement"(%66, %27, %11) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %68 = "llvm.insertelement"(%67, %27, %10) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %69 = "llvm.insertelement"(%68, %27, %9) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %70 = "llvm.insertelement"(%69, %15, %8) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %71 = "llvm.insertelement"(%29, %15, %30) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %72 = "llvm.insertelement"(%71, %15, %14) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %73 = "llvm.insertelement"(%72, %15, %13) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %74 = "llvm.insertelement"(%73, %15, %12) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %75 = "llvm.insertelement"(%74, %15, %11) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %76 = "llvm.insertelement"(%75, %27, %10) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %77 = "llvm.insertelement"(%76, %27, %9) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %78 = "llvm.insertelement"(%77, %27, %8) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %79 = "llvm.insertelement"(%29, %27, %30) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %80 = "llvm.insertelement"(%79, %27, %14) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %81 = "llvm.insertelement"(%80, %27, %13) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %82 = "llvm.insertelement"(%81, %27, %12) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %83 = "llvm.insertelement"(%82, %27, %11) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %84 = "llvm.insertelement"(%83, %27, %10) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %85 = "llvm.insertelement"(%84, %15, %9) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %86 = "llvm.insertelement"(%85, %15, %8) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %87 = "llvm.insertelement"(%29, %27, %30) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %88 = "llvm.insertelement"(%87, %27, %14) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %89 = "llvm.insertelement"(%88, %27, %13) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %90 = "llvm.insertelement"(%89, %27, %12) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %91 = "llvm.insertelement"(%90, %27, %11) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %92 = "llvm.insertelement"(%91, %15, %10) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %93 = "llvm.insertelement"(%92, %15, %9) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %94 = "llvm.insertelement"(%93, %15, %8) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %95 = "llvm.insertelement"(%29, %15, %30) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %96 = "llvm.insertelement"(%95, %15, %14) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %97 = "llvm.insertelement"(%96, %15, %13) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %98 = "llvm.insertelement"(%97, %27, %12) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %99 = "llvm.insertelement"(%98, %27, %11) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %100 = "llvm.insertelement"(%99, %27, %10) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %101 = "llvm.insertelement"(%100, %27, %9) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %102 = "llvm.insertelement"(%101, %27, %8) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %103 = "llvm.insertelement"(%29, %27, %30) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %104 = "llvm.insertelement"(%103, %27, %14) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %105 = "llvm.insertelement"(%104, %27, %13) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %106 = "llvm.insertelement"(%105, %27, %12) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %107 = "llvm.insertelement"(%106, %15, %11) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %108 = "llvm.insertelement"(%107, %15, %10) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %109 = "llvm.insertelement"(%108, %15, %9) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %110 = "llvm.insertelement"(%109, %15, %8) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %111 = "llvm.insertelement"(%29, %15, %30) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %112 = "llvm.insertelement"(%111, %15, %14) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %113 = "llvm.insertelement"(%112, %27, %13) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %114 = "llvm.insertelement"(%113, %27, %12) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %115 = "llvm.insertelement"(%114, %27, %11) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %116 = "llvm.insertelement"(%115, %27, %10) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %117 = "llvm.insertelement"(%116, %27, %9) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %118 = "llvm.insertelement"(%117, %27, %8) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %119 = "llvm.insertelement"(%29, %27, %30) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %120 = "llvm.insertelement"(%119, %27, %14) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %121 = "llvm.insertelement"(%120, %27, %13) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %122 = "llvm.insertelement"(%121, %15, %12) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %123 = "llvm.insertelement"(%122, %15, %11) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %124 = "llvm.insertelement"(%123, %15, %10) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %125 = "llvm.insertelement"(%124, %15, %9) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %126 = "llvm.insertelement"(%125, %15, %8) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %127 = "llvm.insertelement"(%29, %15, %30) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %128 = "llvm.insertelement"(%127, %27, %14) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %129 = "llvm.insertelement"(%128, %27, %13) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %130 = "llvm.insertelement"(%129, %27, %12) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %131 = "llvm.insertelement"(%130, %27, %11) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %132 = "llvm.insertelement"(%131, %27, %10) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %133 = "llvm.insertelement"(%132, %27, %9) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %134 = "llvm.insertelement"(%133, %27, %8) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %135 = "llvm.insertelement"(%29, %27, %30) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %136 = "llvm.insertelement"(%135, %27, %14) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %137 = "llvm.insertelement"(%136, %15, %13) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %138 = "llvm.insertelement"(%137, %15, %12) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %139 = "llvm.insertelement"(%138, %15, %11) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %140 = "llvm.insertelement"(%139, %15, %10) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %141 = "llvm.insertelement"(%140, %15, %9) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %142 = "llvm.insertelement"(%141, %15, %8) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %143 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 704>}> : (!llvm.ptr) -> !llvm.ptr
  %144 = "llvm.icmp"(%arg1, %15) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%144)[^bb27, ^bb1] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb1:  // pred: ^bb0
  %145 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 712>}> : (!llvm.ptr) -> !llvm.ptr
  %146 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 384>}> : (!llvm.ptr) -> !llvm.ptr
  %147 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %148 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 320>}> : (!llvm.ptr) -> !llvm.ptr
  %149 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 256>}> : (!llvm.ptr) -> !llvm.ptr
  %150 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 192>}> : (!llvm.ptr) -> !llvm.ptr
  %151 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %152 = "llvm.load"(%143) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "fd_r43x6_ge_decode", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 64>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 128>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 192>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 256>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 320>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 384>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 448>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 512>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 576>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 640>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 704>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 712>, <#llvm.tbaa_type_desc<id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 720>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 704>]}> : (!llvm.ptr) -> i64
  "llvm.br"(%152, %arg1)[^bb2] : (i64, i64) -> ()
^bb2(%153: i64, %154: i64):  // 2 preds: ^bb1, ^bb26
  %155 = "llvm.icmp"(%153, %16) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%155)[^bb3, ^bb27] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb3:  // pred: ^bb2
  %156 = "llvm.load"(%145) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "fd_r43x6_ge_decode", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 64>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 128>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 192>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 256>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 320>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 384>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 448>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 512>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 576>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 640>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 704>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 712>, <#llvm.tbaa_type_desc<id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 720>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 712>]}> : (!llvm.ptr) -> i64
  %157 = "llvm.intr.umin"(%156, %154) : (i64, i64) -> i64
  %158 = "llvm.load"(%arg0) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %159 = "llvm.icmp"(%156, %15) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%159, %158)[^bb8, ^bb4] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, vector<8xi64>) -> ()
^bb4:  // pred: ^bb3
  %160 = "llvm.and"(%157, %17) : (i64, i64) -> i64
  %161 = "llvm.icmp"(%157, %17) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%161, %158)[^bb7, ^bb5] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, vector<8xi64>) -> ()
^bb5:  // pred: ^bb4
  %162 = "llvm.and"(%157, %18) : (i64, i64) -> i64
  "llvm.br"(%158, %15)[^bb9] : (vector<8xi64>, i64) -> ()
^bb6:  // pred: ^bb9
  %163 = "llvm.icmp"(%160, %15) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%163, %312, %312)[^bb8, ^bb7] <{operandSegmentSizes = array<i32: 1, 1, 1>}> : (i1, vector<8xi64>, vector<8xi64>) -> ()
^bb7(%164: vector<8xi64>):  // 2 preds: ^bb4, ^bb6
  %165 = "llvm.trunc"(%157) <{overflowFlags = 0 : i32}> : (i64) -> i1
  "llvm.intr.assume"(%165) <{op_bundle_sizes = array<i32>}> : (i1) -> ()
  %166 = "llvm.shufflevector"(%164, %19) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %167 = "llvm.shufflevector"(%164, %19) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 3, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %168 = "llvm.shufflevector"(%164, %19) <{mask = array<i32: 4, 4, 1, 1, 1, 1, 1, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %169 = "llvm.shufflevector"(%164, %19) <{mask = array<i32: 4, 5, 1, 2, 3, 4, 5, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %170 = "llvm.shufflevector"(%164, %19) <{mask = array<i32: 3, 7, 5, 7, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %171 = "llvm.shufflevector"(%164, %19) <{mask = array<i32: 5, 7, 5, 7, 2, 3, 4, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %172 = "llvm.shl"(%166, %20) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %173 = "llvm.shl"(%168, %21) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %174 = "llvm.shl"(%170, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %175 = "llvm.call_intrinsic"(%23, %173, %169) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %176 = "llvm.call_intrinsic"(%23, %174, %171) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %177 = "llvm.call_intrinsic"(%23, %172, %167) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %178 = "llvm.shl"(%177, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %179 = "llvm.call_intrinsic"(%23, %173, %169) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %180 = "llvm.shl"(%179, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %181 = "llvm.call_intrinsic"(%23, %174, %171) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %182 = "llvm.shl"(%181, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %183 = "llvm.and"(%175, %25) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %184 = "llvm.and"(%176, %26) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %185 = "llvm.add"(%184, %183) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %186 = "llvm.call_intrinsic"(%185, %172, %167) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %187 = "llvm.and"(%180, %25) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %188 = "llvm.and"(%182, %26) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %189 = "llvm.add"(%187, %178) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %190 = "llvm.add"(%189, %188) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %191 = "llvm.and"(%175, %38) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %192 = "llvm.and"(%176, %46) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %193 = "llvm.and"(%180, %54) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %194 = "llvm.and"(%182, %62) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %195 = "llvm.add"(%194, %193) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %196 = "llvm.shufflevector"(%70, %190) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %197 = "llvm.add"(%196, %186) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %198 = "llvm.shufflevector"(%70, %195) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %199 = "llvm.shufflevector"(%190, %78) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %200 = "llvm.add"(%192, %191) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %201 = "llvm.add"(%200, %198) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %202 = "llvm.add"(%201, %199) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %203 = "llvm.and"(%197, %7) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %204 = "llvm.shufflevector"(%197, %202) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %205 = "llvm.shl"(%204, %6) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %206 = "llvm.add"(%205, %203) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %207 = "llvm.mul"(%204, %5) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %208 = "llvm.add"(%206, %207) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %209 = "llvm.and"(%208, %4) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %210 = "llvm.lshr"(%208, %3) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %211 = "llvm.shufflevector"(%210, %19) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %212 = "llvm.call_intrinsic"(%209, %2, %211) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.br"(%212)[^bb8] : (vector<8xi64>) -> ()
^bb8(%213: vector<8xi64>):  // 3 preds: ^bb3, ^bb6, ^bb7
  "llvm.store"(%213, %arg0) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %214 = "llvm.sub"(%156, %157) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%214, %145) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "fd_r43x6_ge_decode", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 64>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 128>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 192>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 256>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 320>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 384>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 448>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 512>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 576>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 640>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 704>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 712>, <#llvm.tbaa_type_desc<id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 720>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 712>]}> : (i64, !llvm.ptr) -> ()
  %215 = "llvm.sub"(%154, %157) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %216 = "llvm.icmp"(%215, %15) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%216)[^bb27, ^bb10] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb9(%217: vector<8xi64>, %218: i64):  // 2 preds: ^bb5, ^bb9
  %219 = "llvm.shufflevector"(%217, %19) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %220 = "llvm.shufflevector"(%217, %19) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 3, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %221 = "llvm.shufflevector"(%217, %19) <{mask = array<i32: 4, 4, 1, 1, 1, 1, 1, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %222 = "llvm.shufflevector"(%217, %19) <{mask = array<i32: 4, 5, 1, 2, 3, 4, 5, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %223 = "llvm.shufflevector"(%217, %19) <{mask = array<i32: 3, 7, 5, 7, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %224 = "llvm.shufflevector"(%217, %19) <{mask = array<i32: 5, 7, 5, 7, 2, 3, 4, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %225 = "llvm.shl"(%219, %20) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %226 = "llvm.shl"(%221, %21) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %227 = "llvm.shl"(%223, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %228 = "llvm.call_intrinsic"(%23, %226, %222) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %229 = "llvm.call_intrinsic"(%23, %227, %224) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %230 = "llvm.call_intrinsic"(%23, %225, %220) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %231 = "llvm.shl"(%230, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %232 = "llvm.call_intrinsic"(%23, %226, %222) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %233 = "llvm.shl"(%232, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %234 = "llvm.call_intrinsic"(%23, %227, %224) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %235 = "llvm.shl"(%234, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %236 = "llvm.and"(%228, %25) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %237 = "llvm.and"(%229, %26) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %238 = "llvm.add"(%237, %236) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %239 = "llvm.call_intrinsic"(%238, %225, %220) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %240 = "llvm.and"(%233, %25) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %241 = "llvm.and"(%235, %26) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %242 = "llvm.add"(%240, %231) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %243 = "llvm.add"(%242, %241) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %244 = "llvm.and"(%228, %38) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %245 = "llvm.and"(%229, %46) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %246 = "llvm.and"(%233, %54) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %247 = "llvm.and"(%235, %62) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %248 = "llvm.add"(%247, %246) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %249 = "llvm.shufflevector"(%70, %243) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %250 = "llvm.add"(%249, %239) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %251 = "llvm.shufflevector"(%70, %248) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %252 = "llvm.shufflevector"(%243, %78) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %253 = "llvm.add"(%245, %244) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %254 = "llvm.add"(%253, %251) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %255 = "llvm.add"(%254, %252) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %256 = "llvm.and"(%250, %7) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %257 = "llvm.shufflevector"(%250, %255) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %258 = "llvm.shl"(%257, %6) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %259 = "llvm.add"(%258, %256) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %260 = "llvm.mul"(%257, %5) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %261 = "llvm.add"(%259, %260) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %262 = "llvm.and"(%261, %4) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %263 = "llvm.lshr"(%261, %3) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %264 = "llvm.shufflevector"(%263, %19) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %265 = "llvm.call_intrinsic"(%262, %2, %264) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %266 = "llvm.shufflevector"(%265, %19) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %267 = "llvm.shufflevector"(%265, %19) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 3, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %268 = "llvm.shufflevector"(%265, %19) <{mask = array<i32: 4, 4, 1, 1, 1, 1, 1, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %269 = "llvm.shufflevector"(%265, %19) <{mask = array<i32: 4, 5, 1, 2, 3, 4, 5, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %270 = "llvm.shufflevector"(%265, %19) <{mask = array<i32: 3, 7, 5, 7, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %271 = "llvm.shufflevector"(%265, %19) <{mask = array<i32: 5, 7, 5, 7, 2, 3, 4, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %272 = "llvm.shl"(%266, %20) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %273 = "llvm.shl"(%268, %21) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %274 = "llvm.shl"(%270, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %275 = "llvm.call_intrinsic"(%23, %273, %269) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %276 = "llvm.call_intrinsic"(%23, %274, %271) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %277 = "llvm.call_intrinsic"(%23, %272, %267) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %278 = "llvm.shl"(%277, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %279 = "llvm.call_intrinsic"(%23, %273, %269) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %280 = "llvm.shl"(%279, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %281 = "llvm.call_intrinsic"(%23, %274, %271) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %282 = "llvm.shl"(%281, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %283 = "llvm.and"(%275, %25) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %284 = "llvm.and"(%276, %26) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %285 = "llvm.add"(%284, %283) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %286 = "llvm.call_intrinsic"(%285, %272, %267) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %287 = "llvm.and"(%280, %25) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %288 = "llvm.and"(%282, %26) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %289 = "llvm.add"(%287, %278) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %290 = "llvm.add"(%289, %288) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %291 = "llvm.and"(%275, %38) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %292 = "llvm.and"(%276, %46) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %293 = "llvm.and"(%280, %54) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %294 = "llvm.and"(%282, %62) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %295 = "llvm.add"(%294, %293) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %296 = "llvm.shufflevector"(%70, %290) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %297 = "llvm.add"(%296, %286) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %298 = "llvm.shufflevector"(%70, %295) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %299 = "llvm.shufflevector"(%290, %78) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %300 = "llvm.add"(%292, %291) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %301 = "llvm.add"(%300, %298) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %302 = "llvm.add"(%301, %299) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %303 = "llvm.and"(%297, %7) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %304 = "llvm.shufflevector"(%297, %302) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %305 = "llvm.shl"(%304, %6) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %306 = "llvm.add"(%305, %303) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %307 = "llvm.mul"(%304, %5) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %308 = "llvm.add"(%306, %307) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %309 = "llvm.and"(%308, %4) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %310 = "llvm.lshr"(%308, %3) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %311 = "llvm.shufflevector"(%310, %19) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %312 = "llvm.call_intrinsic"(%309, %2, %311) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %313 = "llvm.add"(%218, %1) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %314 = "llvm.icmp"(%313, %162) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%314, %312, %313)[^bb6, ^bb9] <{loop_annotation = #llvm.loop_annotation<mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 2>}> : (i1, vector<8xi64>, i64) -> ()
^bb10:  // pred: ^bb8
  %315 = "llvm.icmp"(%156, %154) <{predicate = 8 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%315, %153, %215)[^bb26, ^bb11] <{operandSegmentSizes = array<i32: 1, 2, 0>}> : (i1, i64, i64) -> ()
^bb11:  // pred: ^bb10
  "llvm.switch"(%153)[^bb23, ^bb12, ^bb13, ^bb14, ^bb15, ^bb16, ^bb17, ^bb18, ^bb19, ^bb20, ^bb21, ^bb22] <{case_operand_segments = array<i32: 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0>, case_values = dense<[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]> : vector<11xi64>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i64) -> ()
^bb12:  // pred: ^bb11
  "llvm.store"(%213, %150) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.br"(%213)[^bb24] : (vector<8xi64>) -> ()
^bb13:  // pred: ^bb11
  %316 = "llvm.load"(%151) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %317 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %318 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 1, 1, 1, 1, 1, 1, 1, 1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %319 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 2, 2, 2, 2, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %320 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 3, 3, 3, 3, 3, 3, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %321 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 4, 4, 4, 4, 4, 4, 4, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %322 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 5, 5, 5, 5, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %323 = "llvm.call_intrinsic"(%23, %317, %316) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %324 = "llvm.shl"(%323, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %325 = "llvm.call_intrinsic"(%324, %318, %316) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %326 = "llvm.call_intrinsic"(%23, %318, %316) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %327 = "llvm.shl"(%326, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %328 = "llvm.call_intrinsic"(%327, %319, %316) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %329 = "llvm.call_intrinsic"(%23, %319, %316) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %330 = "llvm.shl"(%329, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %331 = "llvm.call_intrinsic"(%330, %320, %316) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %332 = "llvm.call_intrinsic"(%23, %320, %316) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %333 = "llvm.shl"(%332, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %334 = "llvm.call_intrinsic"(%333, %321, %316) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %335 = "llvm.call_intrinsic"(%23, %321, %316) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %336 = "llvm.shl"(%335, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %337 = "llvm.call_intrinsic"(%336, %322, %316) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %338 = "llvm.call_intrinsic"(%23, %322, %316) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %339 = "llvm.shl"(%338, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %340 = "llvm.shufflevector"(%70, %325) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %341 = "llvm.shufflevector"(%86, %328) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %342 = "llvm.shufflevector"(%94, %331) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %343 = "llvm.shufflevector"(%331, %102) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %344 = "llvm.shufflevector"(%110, %334) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %345 = "llvm.shufflevector"(%334, %118) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %346 = "llvm.shufflevector"(%126, %337) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %347 = "llvm.shufflevector"(%337, %134) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %348 = "llvm.shufflevector"(%142, %339) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %349 = "llvm.shufflevector"(%339, %19) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %350 = "llvm.call_intrinsic"(%340, %317, %316) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %351 = "llvm.add"(%342, %341) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %352 = "llvm.add"(%351, %344) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %353 = "llvm.add"(%352, %346) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %354 = "llvm.add"(%353, %350) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %355 = "llvm.add"(%354, %348) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %356 = "llvm.add"(%345, %343) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %357 = "llvm.add"(%356, %347) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %358 = "llvm.add"(%357, %349) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %359 = "llvm.and"(%355, %7) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %360 = "llvm.shufflevector"(%355, %358) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %361 = "llvm.shl"(%360, %6) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %362 = "llvm.add"(%361, %359) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %363 = "llvm.mul"(%360, %5) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %364 = "llvm.add"(%362, %363) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %365 = "llvm.and"(%364, %4) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %366 = "llvm.lshr"(%364, %3) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %367 = "llvm.shufflevector"(%366, %19) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %368 = "llvm.call_intrinsic"(%365, %2, %367) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%368, %149) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.br"(%368)[^bb24] : (vector<8xi64>) -> ()
^bb14:  // pred: ^bb11
  %369 = "llvm.load"(%150) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %370 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %371 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 1, 1, 1, 1, 1, 1, 1, 1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %372 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 2, 2, 2, 2, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %373 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 3, 3, 3, 3, 3, 3, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %374 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 4, 4, 4, 4, 4, 4, 4, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %375 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 5, 5, 5, 5, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %376 = "llvm.call_intrinsic"(%23, %370, %369) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %377 = "llvm.shl"(%376, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %378 = "llvm.call_intrinsic"(%377, %371, %369) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %379 = "llvm.call_intrinsic"(%23, %371, %369) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %380 = "llvm.shl"(%379, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %381 = "llvm.call_intrinsic"(%380, %372, %369) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %382 = "llvm.call_intrinsic"(%23, %372, %369) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %383 = "llvm.shl"(%382, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %384 = "llvm.call_intrinsic"(%383, %373, %369) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %385 = "llvm.call_intrinsic"(%23, %373, %369) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %386 = "llvm.shl"(%385, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %387 = "llvm.call_intrinsic"(%386, %374, %369) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %388 = "llvm.call_intrinsic"(%23, %374, %369) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %389 = "llvm.shl"(%388, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %390 = "llvm.call_intrinsic"(%389, %375, %369) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %391 = "llvm.call_intrinsic"(%23, %375, %369) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %392 = "llvm.shl"(%391, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %393 = "llvm.shufflevector"(%70, %378) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %394 = "llvm.shufflevector"(%86, %381) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %395 = "llvm.shufflevector"(%94, %384) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %396 = "llvm.shufflevector"(%384, %102) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %397 = "llvm.shufflevector"(%110, %387) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %398 = "llvm.shufflevector"(%387, %118) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %399 = "llvm.shufflevector"(%126, %390) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %400 = "llvm.shufflevector"(%390, %134) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %401 = "llvm.shufflevector"(%142, %392) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %402 = "llvm.shufflevector"(%392, %19) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %403 = "llvm.call_intrinsic"(%393, %370, %369) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %404 = "llvm.add"(%395, %394) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %405 = "llvm.add"(%404, %397) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %406 = "llvm.add"(%405, %399) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %407 = "llvm.add"(%406, %403) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %408 = "llvm.add"(%407, %401) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %409 = "llvm.add"(%398, %396) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %410 = "llvm.add"(%409, %400) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %411 = "llvm.add"(%410, %402) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %412 = "llvm.and"(%408, %7) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %413 = "llvm.shufflevector"(%408, %411) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %414 = "llvm.shl"(%413, %6) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %415 = "llvm.add"(%414, %412) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %416 = "llvm.mul"(%413, %5) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %417 = "llvm.add"(%415, %416) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %418 = "llvm.and"(%417, %4) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %419 = "llvm.lshr"(%417, %3) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %420 = "llvm.shufflevector"(%419, %19) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %421 = "llvm.call_intrinsic"(%418, %2, %420) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.br"(%421)[^bb24] : (vector<8xi64>) -> ()
^bb15:  // pred: ^bb11
  %422 = "llvm.load"(%149) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %423 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %424 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 1, 1, 1, 1, 1, 1, 1, 1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %425 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 2, 2, 2, 2, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %426 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 3, 3, 3, 3, 3, 3, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %427 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 4, 4, 4, 4, 4, 4, 4, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %428 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 5, 5, 5, 5, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %429 = "llvm.call_intrinsic"(%23, %423, %422) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %430 = "llvm.shl"(%429, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %431 = "llvm.call_intrinsic"(%430, %424, %422) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %432 = "llvm.call_intrinsic"(%23, %424, %422) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %433 = "llvm.shl"(%432, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %434 = "llvm.call_intrinsic"(%433, %425, %422) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %435 = "llvm.call_intrinsic"(%23, %425, %422) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %436 = "llvm.shl"(%435, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %437 = "llvm.call_intrinsic"(%436, %426, %422) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %438 = "llvm.call_intrinsic"(%23, %426, %422) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %439 = "llvm.shl"(%438, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %440 = "llvm.call_intrinsic"(%439, %427, %422) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %441 = "llvm.call_intrinsic"(%23, %427, %422) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %442 = "llvm.shl"(%441, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %443 = "llvm.call_intrinsic"(%442, %428, %422) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %444 = "llvm.call_intrinsic"(%23, %428, %422) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %445 = "llvm.shl"(%444, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %446 = "llvm.shufflevector"(%70, %431) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %447 = "llvm.shufflevector"(%86, %434) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %448 = "llvm.shufflevector"(%94, %437) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %449 = "llvm.shufflevector"(%437, %102) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %450 = "llvm.shufflevector"(%110, %440) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %451 = "llvm.shufflevector"(%440, %118) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %452 = "llvm.shufflevector"(%126, %443) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %453 = "llvm.shufflevector"(%443, %134) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %454 = "llvm.shufflevector"(%142, %445) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %455 = "llvm.shufflevector"(%445, %19) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %456 = "llvm.call_intrinsic"(%446, %423, %422) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %457 = "llvm.add"(%448, %447) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %458 = "llvm.add"(%457, %450) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %459 = "llvm.add"(%458, %452) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %460 = "llvm.add"(%459, %456) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %461 = "llvm.add"(%460, %454) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %462 = "llvm.add"(%451, %449) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %463 = "llvm.add"(%462, %453) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %464 = "llvm.add"(%463, %455) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %465 = "llvm.and"(%461, %7) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %466 = "llvm.shufflevector"(%461, %464) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %467 = "llvm.shl"(%466, %6) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %468 = "llvm.add"(%467, %465) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %469 = "llvm.mul"(%466, %5) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %470 = "llvm.add"(%468, %469) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %471 = "llvm.and"(%470, %4) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %472 = "llvm.lshr"(%470, %3) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %473 = "llvm.shufflevector"(%472, %19) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %474 = "llvm.call_intrinsic"(%471, %2, %473) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.br"(%474)[^bb24] : (vector<8xi64>) -> ()
^bb16:  // pred: ^bb11
  %475 = "llvm.load"(%147) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %476 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %477 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 1, 1, 1, 1, 1, 1, 1, 1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %478 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 2, 2, 2, 2, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %479 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 3, 3, 3, 3, 3, 3, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %480 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 4, 4, 4, 4, 4, 4, 4, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %481 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 5, 5, 5, 5, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %482 = "llvm.call_intrinsic"(%23, %476, %475) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %483 = "llvm.shl"(%482, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %484 = "llvm.call_intrinsic"(%483, %477, %475) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %485 = "llvm.call_intrinsic"(%23, %477, %475) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %486 = "llvm.shl"(%485, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %487 = "llvm.call_intrinsic"(%486, %478, %475) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %488 = "llvm.call_intrinsic"(%23, %478, %475) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %489 = "llvm.shl"(%488, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %490 = "llvm.call_intrinsic"(%489, %479, %475) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %491 = "llvm.call_intrinsic"(%23, %479, %475) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %492 = "llvm.shl"(%491, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %493 = "llvm.call_intrinsic"(%492, %480, %475) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %494 = "llvm.call_intrinsic"(%23, %480, %475) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %495 = "llvm.shl"(%494, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %496 = "llvm.call_intrinsic"(%495, %481, %475) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %497 = "llvm.call_intrinsic"(%23, %481, %475) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %498 = "llvm.shl"(%497, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %499 = "llvm.shufflevector"(%70, %484) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %500 = "llvm.shufflevector"(%86, %487) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %501 = "llvm.shufflevector"(%94, %490) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %502 = "llvm.shufflevector"(%490, %102) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %503 = "llvm.shufflevector"(%110, %493) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %504 = "llvm.shufflevector"(%493, %118) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %505 = "llvm.shufflevector"(%126, %496) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %506 = "llvm.shufflevector"(%496, %134) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %507 = "llvm.shufflevector"(%142, %498) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %508 = "llvm.shufflevector"(%498, %19) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %509 = "llvm.call_intrinsic"(%499, %476, %475) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %510 = "llvm.add"(%501, %500) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %511 = "llvm.add"(%510, %503) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %512 = "llvm.add"(%511, %505) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %513 = "llvm.add"(%512, %509) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %514 = "llvm.add"(%513, %507) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %515 = "llvm.add"(%504, %502) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %516 = "llvm.add"(%515, %506) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %517 = "llvm.add"(%516, %508) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %518 = "llvm.and"(%514, %7) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %519 = "llvm.shufflevector"(%514, %517) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %520 = "llvm.shl"(%519, %6) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %521 = "llvm.add"(%520, %518) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %522 = "llvm.mul"(%519, %5) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %523 = "llvm.add"(%521, %522) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %524 = "llvm.and"(%523, %4) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %525 = "llvm.lshr"(%523, %3) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %526 = "llvm.shufflevector"(%525, %19) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %527 = "llvm.call_intrinsic"(%524, %2, %526) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%527, %148) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.br"(%527)[^bb24] : (vector<8xi64>) -> ()
^bb17:  // pred: ^bb11
  %528 = "llvm.load"(%147) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %529 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %530 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 1, 1, 1, 1, 1, 1, 1, 1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %531 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 2, 2, 2, 2, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %532 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 3, 3, 3, 3, 3, 3, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %533 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 4, 4, 4, 4, 4, 4, 4, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %534 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 5, 5, 5, 5, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %535 = "llvm.call_intrinsic"(%23, %529, %528) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %536 = "llvm.shl"(%535, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %537 = "llvm.call_intrinsic"(%536, %530, %528) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %538 = "llvm.call_intrinsic"(%23, %530, %528) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %539 = "llvm.shl"(%538, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %540 = "llvm.call_intrinsic"(%539, %531, %528) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %541 = "llvm.call_intrinsic"(%23, %531, %528) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %542 = "llvm.shl"(%541, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %543 = "llvm.call_intrinsic"(%542, %532, %528) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %544 = "llvm.call_intrinsic"(%23, %532, %528) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %545 = "llvm.shl"(%544, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %546 = "llvm.call_intrinsic"(%545, %533, %528) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %547 = "llvm.call_intrinsic"(%23, %533, %528) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %548 = "llvm.shl"(%547, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %549 = "llvm.call_intrinsic"(%548, %534, %528) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %550 = "llvm.call_intrinsic"(%23, %534, %528) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %551 = "llvm.shl"(%550, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %552 = "llvm.shufflevector"(%70, %537) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %553 = "llvm.shufflevector"(%86, %540) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %554 = "llvm.shufflevector"(%94, %543) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %555 = "llvm.shufflevector"(%543, %102) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %556 = "llvm.shufflevector"(%110, %546) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %557 = "llvm.shufflevector"(%546, %118) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %558 = "llvm.shufflevector"(%126, %549) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %559 = "llvm.shufflevector"(%549, %134) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %560 = "llvm.shufflevector"(%142, %551) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %561 = "llvm.shufflevector"(%551, %19) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %562 = "llvm.call_intrinsic"(%552, %529, %528) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %563 = "llvm.add"(%554, %553) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %564 = "llvm.add"(%563, %556) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %565 = "llvm.add"(%564, %558) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %566 = "llvm.add"(%565, %562) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %567 = "llvm.add"(%566, %560) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %568 = "llvm.add"(%557, %555) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %569 = "llvm.add"(%568, %559) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %570 = "llvm.add"(%569, %561) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %571 = "llvm.and"(%567, %7) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %572 = "llvm.shufflevector"(%567, %570) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %573 = "llvm.shl"(%572, %6) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %574 = "llvm.add"(%573, %571) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %575 = "llvm.mul"(%572, %5) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %576 = "llvm.add"(%574, %575) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %577 = "llvm.and"(%576, %4) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %578 = "llvm.lshr"(%576, %3) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %579 = "llvm.shufflevector"(%578, %19) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %580 = "llvm.call_intrinsic"(%577, %2, %579) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.br"(%580)[^bb24] : (vector<8xi64>) -> ()
^bb18:  // pred: ^bb11
  %581 = "llvm.load"(%147) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %582 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %583 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 1, 1, 1, 1, 1, 1, 1, 1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %584 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 2, 2, 2, 2, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %585 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 3, 3, 3, 3, 3, 3, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %586 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 4, 4, 4, 4, 4, 4, 4, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %587 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 5, 5, 5, 5, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %588 = "llvm.call_intrinsic"(%23, %582, %581) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %589 = "llvm.shl"(%588, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %590 = "llvm.call_intrinsic"(%589, %583, %581) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %591 = "llvm.call_intrinsic"(%23, %583, %581) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %592 = "llvm.shl"(%591, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %593 = "llvm.call_intrinsic"(%592, %584, %581) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %594 = "llvm.call_intrinsic"(%23, %584, %581) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %595 = "llvm.shl"(%594, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %596 = "llvm.call_intrinsic"(%595, %585, %581) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %597 = "llvm.call_intrinsic"(%23, %585, %581) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %598 = "llvm.shl"(%597, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %599 = "llvm.call_intrinsic"(%598, %586, %581) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %600 = "llvm.call_intrinsic"(%23, %586, %581) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %601 = "llvm.shl"(%600, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %602 = "llvm.call_intrinsic"(%601, %587, %581) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %603 = "llvm.call_intrinsic"(%23, %587, %581) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %604 = "llvm.shl"(%603, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %605 = "llvm.shufflevector"(%70, %590) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %606 = "llvm.shufflevector"(%86, %593) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %607 = "llvm.shufflevector"(%94, %596) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %608 = "llvm.shufflevector"(%596, %102) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %609 = "llvm.shufflevector"(%110, %599) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %610 = "llvm.shufflevector"(%599, %118) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %611 = "llvm.shufflevector"(%126, %602) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %612 = "llvm.shufflevector"(%602, %134) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %613 = "llvm.shufflevector"(%142, %604) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %614 = "llvm.shufflevector"(%604, %19) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %615 = "llvm.call_intrinsic"(%605, %582, %581) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %616 = "llvm.add"(%607, %606) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %617 = "llvm.add"(%616, %609) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %618 = "llvm.add"(%617, %611) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %619 = "llvm.add"(%618, %615) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %620 = "llvm.add"(%619, %613) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %621 = "llvm.add"(%610, %608) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %622 = "llvm.add"(%621, %612) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %623 = "llvm.add"(%622, %614) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %624 = "llvm.and"(%620, %7) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %625 = "llvm.shufflevector"(%620, %623) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %626 = "llvm.shl"(%625, %6) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %627 = "llvm.add"(%626, %624) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %628 = "llvm.mul"(%625, %5) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %629 = "llvm.add"(%627, %628) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %630 = "llvm.and"(%629, %4) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %631 = "llvm.lshr"(%629, %3) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %632 = "llvm.shufflevector"(%631, %19) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %633 = "llvm.call_intrinsic"(%630, %2, %632) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.br"(%633)[^bb24] : (vector<8xi64>) -> ()
^bb19:  // pred: ^bb11
  %634 = "llvm.load"(%148) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %635 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %636 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 1, 1, 1, 1, 1, 1, 1, 1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %637 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 2, 2, 2, 2, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %638 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 3, 3, 3, 3, 3, 3, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %639 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 4, 4, 4, 4, 4, 4, 4, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %640 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 5, 5, 5, 5, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %641 = "llvm.call_intrinsic"(%23, %635, %634) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %642 = "llvm.shl"(%641, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %643 = "llvm.call_intrinsic"(%642, %636, %634) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %644 = "llvm.call_intrinsic"(%23, %636, %634) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %645 = "llvm.shl"(%644, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %646 = "llvm.call_intrinsic"(%645, %637, %634) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %647 = "llvm.call_intrinsic"(%23, %637, %634) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %648 = "llvm.shl"(%647, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %649 = "llvm.call_intrinsic"(%648, %638, %634) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %650 = "llvm.call_intrinsic"(%23, %638, %634) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %651 = "llvm.shl"(%650, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %652 = "llvm.call_intrinsic"(%651, %639, %634) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %653 = "llvm.call_intrinsic"(%23, %639, %634) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %654 = "llvm.shl"(%653, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %655 = "llvm.call_intrinsic"(%654, %640, %634) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %656 = "llvm.call_intrinsic"(%23, %640, %634) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %657 = "llvm.shl"(%656, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %658 = "llvm.shufflevector"(%70, %643) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %659 = "llvm.shufflevector"(%86, %646) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %660 = "llvm.shufflevector"(%94, %649) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %661 = "llvm.shufflevector"(%649, %102) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %662 = "llvm.shufflevector"(%110, %652) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %663 = "llvm.shufflevector"(%652, %118) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %664 = "llvm.shufflevector"(%126, %655) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %665 = "llvm.shufflevector"(%655, %134) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %666 = "llvm.shufflevector"(%142, %657) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %667 = "llvm.shufflevector"(%657, %19) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %668 = "llvm.call_intrinsic"(%658, %635, %634) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %669 = "llvm.add"(%660, %659) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %670 = "llvm.add"(%669, %662) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %671 = "llvm.add"(%670, %664) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %672 = "llvm.add"(%671, %668) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %673 = "llvm.add"(%672, %666) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %674 = "llvm.add"(%663, %661) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %675 = "llvm.add"(%674, %665) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %676 = "llvm.add"(%675, %667) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %677 = "llvm.and"(%673, %7) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %678 = "llvm.shufflevector"(%673, %676) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %679 = "llvm.shl"(%678, %6) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %680 = "llvm.add"(%679, %677) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %681 = "llvm.mul"(%678, %5) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %682 = "llvm.add"(%680, %681) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %683 = "llvm.and"(%682, %4) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %684 = "llvm.lshr"(%682, %3) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %685 = "llvm.shufflevector"(%684, %19) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %686 = "llvm.call_intrinsic"(%683, %2, %685) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%686, %146) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.br"(%686)[^bb24] : (vector<8xi64>) -> ()
^bb20:  // pred: ^bb11
  %687 = "llvm.load"(%147) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %688 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %689 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 1, 1, 1, 1, 1, 1, 1, 1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %690 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 2, 2, 2, 2, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %691 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 3, 3, 3, 3, 3, 3, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %692 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 4, 4, 4, 4, 4, 4, 4, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %693 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 5, 5, 5, 5, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %694 = "llvm.call_intrinsic"(%23, %688, %687) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %695 = "llvm.shl"(%694, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %696 = "llvm.call_intrinsic"(%695, %689, %687) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %697 = "llvm.call_intrinsic"(%23, %689, %687) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %698 = "llvm.shl"(%697, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %699 = "llvm.call_intrinsic"(%698, %690, %687) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %700 = "llvm.call_intrinsic"(%23, %690, %687) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %701 = "llvm.shl"(%700, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %702 = "llvm.call_intrinsic"(%701, %691, %687) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %703 = "llvm.call_intrinsic"(%23, %691, %687) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %704 = "llvm.shl"(%703, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %705 = "llvm.call_intrinsic"(%704, %692, %687) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %706 = "llvm.call_intrinsic"(%23, %692, %687) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %707 = "llvm.shl"(%706, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %708 = "llvm.call_intrinsic"(%707, %693, %687) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %709 = "llvm.call_intrinsic"(%23, %693, %687) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %710 = "llvm.shl"(%709, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %711 = "llvm.shufflevector"(%70, %696) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %712 = "llvm.shufflevector"(%86, %699) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %713 = "llvm.shufflevector"(%94, %702) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %714 = "llvm.shufflevector"(%702, %102) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %715 = "llvm.shufflevector"(%110, %705) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %716 = "llvm.shufflevector"(%705, %118) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %717 = "llvm.shufflevector"(%126, %708) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %718 = "llvm.shufflevector"(%708, %134) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %719 = "llvm.shufflevector"(%142, %710) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %720 = "llvm.shufflevector"(%710, %19) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %721 = "llvm.call_intrinsic"(%711, %688, %687) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %722 = "llvm.add"(%713, %712) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %723 = "llvm.add"(%722, %715) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %724 = "llvm.add"(%723, %717) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %725 = "llvm.add"(%724, %721) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %726 = "llvm.add"(%725, %719) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %727 = "llvm.add"(%716, %714) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %728 = "llvm.add"(%727, %718) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %729 = "llvm.add"(%728, %720) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %730 = "llvm.and"(%726, %7) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %731 = "llvm.shufflevector"(%726, %729) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %732 = "llvm.shl"(%731, %6) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %733 = "llvm.add"(%732, %730) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %734 = "llvm.mul"(%731, %5) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %735 = "llvm.add"(%733, %734) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %736 = "llvm.and"(%735, %4) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %737 = "llvm.lshr"(%735, %3) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %738 = "llvm.shufflevector"(%737, %19) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %739 = "llvm.call_intrinsic"(%736, %2, %738) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.br"(%739)[^bb24] : (vector<8xi64>) -> ()
^bb21:  // pred: ^bb11
  %740 = "llvm.load"(%147) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %741 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %742 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 1, 1, 1, 1, 1, 1, 1, 1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %743 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 2, 2, 2, 2, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %744 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 3, 3, 3, 3, 3, 3, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %745 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 4, 4, 4, 4, 4, 4, 4, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %746 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 5, 5, 5, 5, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %747 = "llvm.call_intrinsic"(%23, %741, %740) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %748 = "llvm.shl"(%747, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %749 = "llvm.call_intrinsic"(%748, %742, %740) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %750 = "llvm.call_intrinsic"(%23, %742, %740) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %751 = "llvm.shl"(%750, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %752 = "llvm.call_intrinsic"(%751, %743, %740) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %753 = "llvm.call_intrinsic"(%23, %743, %740) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %754 = "llvm.shl"(%753, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %755 = "llvm.call_intrinsic"(%754, %744, %740) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %756 = "llvm.call_intrinsic"(%23, %744, %740) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %757 = "llvm.shl"(%756, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %758 = "llvm.call_intrinsic"(%757, %745, %740) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %759 = "llvm.call_intrinsic"(%23, %745, %740) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %760 = "llvm.shl"(%759, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %761 = "llvm.call_intrinsic"(%760, %746, %740) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %762 = "llvm.call_intrinsic"(%23, %746, %740) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %763 = "llvm.shl"(%762, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %764 = "llvm.shufflevector"(%70, %749) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %765 = "llvm.shufflevector"(%86, %752) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %766 = "llvm.shufflevector"(%94, %755) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %767 = "llvm.shufflevector"(%755, %102) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %768 = "llvm.shufflevector"(%110, %758) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %769 = "llvm.shufflevector"(%758, %118) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %770 = "llvm.shufflevector"(%126, %761) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %771 = "llvm.shufflevector"(%761, %134) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %772 = "llvm.shufflevector"(%142, %763) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %773 = "llvm.shufflevector"(%763, %19) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %774 = "llvm.call_intrinsic"(%764, %741, %740) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %775 = "llvm.add"(%766, %765) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %776 = "llvm.add"(%775, %768) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %777 = "llvm.add"(%776, %770) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %778 = "llvm.add"(%777, %774) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %779 = "llvm.add"(%778, %772) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %780 = "llvm.add"(%769, %767) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %781 = "llvm.add"(%780, %771) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %782 = "llvm.add"(%781, %773) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %783 = "llvm.and"(%779, %7) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %784 = "llvm.shufflevector"(%779, %782) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %785 = "llvm.shl"(%784, %6) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %786 = "llvm.add"(%785, %783) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %787 = "llvm.mul"(%784, %5) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %788 = "llvm.add"(%786, %787) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %789 = "llvm.and"(%788, %4) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %790 = "llvm.lshr"(%788, %3) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %791 = "llvm.shufflevector"(%790, %19) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %792 = "llvm.call_intrinsic"(%789, %2, %791) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.br"(%792)[^bb24] : (vector<8xi64>) -> ()
^bb22:  // pred: ^bb11
  %793 = "llvm.load"(%146) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %794 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %795 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 1, 1, 1, 1, 1, 1, 1, 1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %796 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 2, 2, 2, 2, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %797 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 3, 3, 3, 3, 3, 3, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %798 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 4, 4, 4, 4, 4, 4, 4, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %799 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 5, 5, 5, 5, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %800 = "llvm.call_intrinsic"(%23, %794, %793) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %801 = "llvm.shl"(%800, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %802 = "llvm.call_intrinsic"(%801, %795, %793) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %803 = "llvm.call_intrinsic"(%23, %795, %793) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %804 = "llvm.shl"(%803, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %805 = "llvm.call_intrinsic"(%804, %796, %793) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %806 = "llvm.call_intrinsic"(%23, %796, %793) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %807 = "llvm.shl"(%806, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %808 = "llvm.call_intrinsic"(%807, %797, %793) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %809 = "llvm.call_intrinsic"(%23, %797, %793) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %810 = "llvm.shl"(%809, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %811 = "llvm.call_intrinsic"(%810, %798, %793) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %812 = "llvm.call_intrinsic"(%23, %798, %793) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %813 = "llvm.shl"(%812, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %814 = "llvm.call_intrinsic"(%813, %799, %793) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %815 = "llvm.call_intrinsic"(%23, %799, %793) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %816 = "llvm.shl"(%815, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %817 = "llvm.shufflevector"(%70, %802) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %818 = "llvm.shufflevector"(%86, %805) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %819 = "llvm.shufflevector"(%94, %808) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %820 = "llvm.shufflevector"(%808, %102) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %821 = "llvm.shufflevector"(%110, %811) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %822 = "llvm.shufflevector"(%811, %118) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %823 = "llvm.shufflevector"(%126, %814) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %824 = "llvm.shufflevector"(%814, %134) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %825 = "llvm.shufflevector"(%142, %816) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %826 = "llvm.shufflevector"(%816, %19) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %827 = "llvm.call_intrinsic"(%817, %794, %793) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %828 = "llvm.add"(%819, %818) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %829 = "llvm.add"(%828, %821) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %830 = "llvm.add"(%829, %823) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %831 = "llvm.add"(%830, %827) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %832 = "llvm.add"(%831, %825) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %833 = "llvm.add"(%822, %820) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %834 = "llvm.add"(%833, %824) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %835 = "llvm.add"(%834, %826) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %836 = "llvm.and"(%832, %7) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %837 = "llvm.shufflevector"(%832, %835) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %838 = "llvm.shl"(%837, %6) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %839 = "llvm.add"(%838, %836) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %840 = "llvm.mul"(%837, %5) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %841 = "llvm.add"(%839, %840) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %842 = "llvm.and"(%841, %4) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %843 = "llvm.lshr"(%841, %3) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %844 = "llvm.shufflevector"(%843, %19) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %845 = "llvm.call_intrinsic"(%842, %2, %844) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.br"(%845)[^bb24] : (vector<8xi64>) -> ()
^bb23:  // pred: ^bb11
  %846 = "llvm.load"(%151) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %847 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %848 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 1, 1, 1, 1, 1, 1, 1, 1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %849 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 2, 2, 2, 2, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %850 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 3, 3, 3, 3, 3, 3, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %851 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 4, 4, 4, 4, 4, 4, 4, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %852 = "llvm.shufflevector"(%213, %19) <{mask = array<i32: 5, 5, 5, 5, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %853 = "llvm.call_intrinsic"(%23, %847, %846) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %854 = "llvm.shl"(%853, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %855 = "llvm.call_intrinsic"(%854, %848, %846) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %856 = "llvm.call_intrinsic"(%23, %848, %846) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %857 = "llvm.shl"(%856, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %858 = "llvm.call_intrinsic"(%857, %849, %846) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %859 = "llvm.call_intrinsic"(%23, %849, %846) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %860 = "llvm.shl"(%859, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %861 = "llvm.call_intrinsic"(%860, %850, %846) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %862 = "llvm.call_intrinsic"(%23, %850, %846) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %863 = "llvm.shl"(%862, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %864 = "llvm.call_intrinsic"(%863, %851, %846) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %865 = "llvm.call_intrinsic"(%23, %851, %846) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %866 = "llvm.shl"(%865, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %867 = "llvm.call_intrinsic"(%866, %852, %846) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %868 = "llvm.call_intrinsic"(%23, %852, %846) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %869 = "llvm.shl"(%868, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %870 = "llvm.shufflevector"(%70, %855) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %871 = "llvm.shufflevector"(%86, %858) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %872 = "llvm.shufflevector"(%94, %861) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %873 = "llvm.shufflevector"(%861, %102) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %874 = "llvm.shufflevector"(%110, %864) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %875 = "llvm.shufflevector"(%864, %118) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %876 = "llvm.shufflevector"(%126, %867) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %877 = "llvm.shufflevector"(%867, %134) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %878 = "llvm.shufflevector"(%142, %869) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %879 = "llvm.shufflevector"(%869, %19) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %880 = "llvm.call_intrinsic"(%870, %847, %846) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %881 = "llvm.add"(%872, %871) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %882 = "llvm.add"(%881, %874) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %883 = "llvm.add"(%882, %876) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %884 = "llvm.add"(%883, %880) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %885 = "llvm.add"(%884, %878) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %886 = "llvm.add"(%875, %873) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %887 = "llvm.add"(%886, %877) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %888 = "llvm.add"(%887, %879) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %889 = "llvm.and"(%885, %7) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %890 = "llvm.shufflevector"(%885, %888) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %891 = "llvm.shl"(%890, %6) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %892 = "llvm.add"(%891, %889) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %893 = "llvm.mul"(%890, %5) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %894 = "llvm.add"(%892, %893) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %895 = "llvm.and"(%894, %4) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %896 = "llvm.lshr"(%894, %3) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %897 = "llvm.shufflevector"(%896, %19) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %898 = "llvm.call_intrinsic"(%895, %2, %897) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%898, %arg0) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%898, %147) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %899 = "llvm.add"(%153, %17) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  "llvm.store"(%899, %143) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "fd_r43x6_ge_decode", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 64>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 128>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 192>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 256>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 320>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 384>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 448>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 512>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 576>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 640>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 704>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 712>, <#llvm.tbaa_type_desc<id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 720>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 704>]}> : (i64, !llvm.ptr) -> ()
  "llvm.br"(%16, %15)[^bb25] : (i64, i64) -> ()
^bb24(%900: vector<8xi64>):  // 11 preds: ^bb12, ^bb13, ^bb14, ^bb15, ^bb16, ^bb17, ^bb18, ^bb19, ^bb20, ^bb21, ^bb22
  "llvm.store"(%900, %arg0) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%900, %147) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %901 = "llvm.add"(%153, %17) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  "llvm.store"(%901, %143) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "fd_r43x6_ge_decode", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 64>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 128>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 192>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 256>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 320>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 384>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 448>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 512>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 576>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 640>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 704>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 712>, <#llvm.tbaa_type_desc<id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 720>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 704>]}> : (i64, !llvm.ptr) -> ()
  %902 = "llvm.getelementptr"(%0, %901) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %903 = "llvm.load"(%902) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  "llvm.br"(%901, %903)[^bb25] : (i64, i64) -> ()
^bb25(%904: i64, %905: i64):  // 2 preds: ^bb23, ^bb24
  "llvm.store"(%905, %145) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "fd_r43x6_ge_decode", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 64>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 128>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 192>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 256>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 320>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 384>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 448>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 512>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 576>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 640>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 704>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 712>, <#llvm.tbaa_type_desc<id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 720>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 712>]}> : (i64, !llvm.ptr) -> ()
  %906 = "llvm.add"(%215, %28) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.br"(%904, %906)[^bb26] : (i64, i64) -> ()
^bb26(%907: i64, %908: i64):  // 2 preds: ^bb10, ^bb25
  %909 = "llvm.icmp"(%908, %15) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%909, %907, %908)[^bb27, ^bb2] <{loop_annotation = #llvm.loop_annotation<mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 2>}> : (i1, i64, i64) -> ()
^bb27:  // 4 preds: ^bb0, ^bb2, ^bb8, ^bb26
  "llvm.return"() : () -> ()
}) : () -> ()

    with
      @decode_stage.sqr_cnt := Firedancer.Lane.Mlir.decode_stage_sqr_cnt

end

end Firedancer.Lane.Mlir
