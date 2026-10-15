
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.LaneNI.Mlir.fd_r43x6_unpack
public import Firedancer.LaneNI.Mlir.fd_r43x6_sqr_fast
public import Firedancer.LaneNI.Mlir.fd_r43x6_mul_fast
public import Firedancer.LaneNI.Mlir.fd_r43x6_sqr_fast
public import Firedancer.LaneNI.Mlir.fd_r43x6_sqr_fast
public import Firedancer.LaneNI.Mlir.fd_r43x6_mul_fast
public import Firedancer.LaneNI.Mlir.fd_r43x6_mul_fast
public import Firedancer.LaneNI.Mlir.fd_r43x6_mul_fast
public import Firedancer.LaneNI.Mlir.fd_r43x6_pow22523
public import Firedancer.LaneNI.Mlir.fd_r43x6_mul_fast
public import Firedancer.LaneNI.Mlir.fd_r43x6_sqr_fast
public import Firedancer.LaneNI.Mlir.fd_r43x6_mul_fast
public import Firedancer.LaneNI.Mlir.fd_r43x6_is_nonzero
public import Firedancer.LaneNI.Mlir.fd_r43x6_is_nonzero
public import Firedancer.LaneNI.Mlir.fd_r43x6_mul_fast
public import Firedancer.LaneNI.Mlir.fd_r43x6_diagnose
public import Firedancer.LaneNI.Mlir.fd_r43x6_mul_fast

namespace Firedancer.LaneNI.Mlir

@[expose] public section

mlir_def fd_r43x6_ge_decode := "llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<i32 (ptr, ptr, ptr, ptr)>, linkage = #llvm.linkage<external>, no_inline, no_unwind, passthrough = ["sspstrong", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], res_attrs = [{llvm.range = #llvm.constant_range<i32, -1, 1>}], sym_name = "fd_r43x6_ge_decode", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: !llvm.ptr, %arg3: !llvm.ptr):
  %0 = "llvm.mlir.constant"() <{value = dense<[8796093022207, 8796093022207, 8796093022207, 8796093022207, 1099511627775, 1099511627775, 1099511627775, 1099511627775]> : vector<8xi64>}> : () -> vector<8xi64>
  %1 = "llvm.mlir.constant"() <{value = dense<8796093022207> : vector<8xi64>}> : () -> vector<8xi64>
  %2 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %3 = "llvm.mlir.constant"() <{value = dense<[43, 43, 43, 43, 40, 40, 40, 40]> : vector<8xi64>}> : () -> vector<8xi64>
  %4 = "llvm.mlir.constant"() <{value = dense<43> : vector<8xi64>}> : () -> vector<8xi64>
  %5 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %6 = "llvm.mlir.constant"() <{value = dense<[3467281080496, 6582290652611, 5210002954932, 329084955603, 4526638806224, 373767602335, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %7 = "llvm.mlir.constant"() <{value = -1 : i8}> : () -> i8
  %8 = "llvm.mlir.constant"() <{value = 63 : i64}> : () -> i64
  %9 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
  %10 = "llvm.mlir.constant"() <{value = dense<0> : vector<8xi64>}> : () -> vector<8xi64>
  %11 = "llvm.mlir.constant"() <{value = dense<[8795933638637, 8796091973631, 8796091973631, 8796091973631, 8796091973631, 1099510579199, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %12 = "llvm.mlir.constant"() <{value = dense<[1, 0, 0, 0, 0, 0, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %13 = "llvm.mlir.constant"() <{value = dense<[6365466163363, 253762649449, 7518893317, 260847760460, 7696165686388, 704489577558, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %14 = "llvm.mlir.constant"() <{value = dense<[159383552, 1048576, 1048576, 1048576, 1048576, 1048576, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %15 = "llvm.mlir.constant"() <{value = dense<[-1, 0, 0, 0, 0, 0, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %16 = "llvm.mlir.constant"() <{value = dense<18> : vector<8xi64>}> : () -> vector<8xi64>
  %17 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %18 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %19 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %20 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %21 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %22 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %23 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %24 = "llvm.mlir.constant"() <{value = dense<[-1, -1, -1, 9223372036854775807]> : vector<4xi64>}> : () -> vector<4xi64>
  %25 = "llvm.mlir.constant"() <{value = dense<[8796093022207, 8796093022207, 8796093022207, 8796093022207, 8796093022207, 1099511627775, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %26 = "llvm.mlir.constant"() <{value = dense<[43, 43, 43, 43, 43, 40, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %27 = "llvm.mlir.poison"() : () -> vector<8xi64>
  %28 = "llvm.mlir.constant"() <{value = dense<[19, 1, 1, 1, 1, 1, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %29 = "llvm.mlir.constant"() <{value = dense<[8795933638636, 8796091973631, 8796091973631, 8796091973631, 8796091973631, 1099510579199, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %30 = "llvm.mlir.poison"() : () -> i64
  %31 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %32 = "llvm.mlir.undef"() : () -> vector<8xi64>
  %33 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %34 = "llvm.insertelement"(%32, %31, %33) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %35 = "llvm.insertelement"(%34, %30, %23) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %36 = "llvm.insertelement"(%35, %30, %22) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %37 = "llvm.insertelement"(%36, %30, %21) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %38 = "llvm.insertelement"(%37, %30, %20) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %39 = "llvm.insertelement"(%38, %30, %19) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %40 = "llvm.insertelement"(%39, %30, %18) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %41 = "llvm.insertelement"(%40, %30, %17) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %42 = "llvm.insertelement"(%32, %5, %33) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %43 = "llvm.insertelement"(%42, %31, %23) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %44 = "llvm.insertelement"(%43, %30, %22) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %45 = "llvm.insertelement"(%44, %30, %21) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %46 = "llvm.insertelement"(%45, %31, %20) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %47 = "llvm.insertelement"(%46, %31, %19) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %48 = "llvm.insertelement"(%47, %30, %18) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %49 = "llvm.insertelement"(%48, %30, %17) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %50 = "llvm.insertelement"(%32, %30, %33) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %51 = "llvm.insertelement"(%50, %30, %23) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %52 = "llvm.insertelement"(%51, %31, %22) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %53 = "llvm.insertelement"(%52, %31, %21) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %54 = "llvm.insertelement"(%53, %31, %20) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %55 = "llvm.insertelement"(%54, %31, %19) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %56 = "llvm.insertelement"(%55, %30, %18) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %57 = "llvm.insertelement"(%56, %30, %17) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %58 = "llvm.insertelement"(%32, %30, %33) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %59 = "llvm.insertelement"(%58, %30, %23) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %60 = "llvm.insertelement"(%59, %30, %22) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %61 = "llvm.insertelement"(%60, %30, %21) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %62 = "llvm.insertelement"(%61, %2, %20) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %63 = "llvm.insertelement"(%62, %2, %19) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %64 = "llvm.insertelement"(%63, %2, %18) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %65 = "llvm.insertelement"(%64, %2, %17) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %66 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %67 = "llvm.load"(%66) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %68 = "llvm.load"(%arg3) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %69 = "llvm.and"(%68, %24) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %70 = "llvm.call"(%69) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_unpack, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<4xi64>) -> vector<8xi64>
  %71 = "llvm.call"(%70) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> vector<8xi64>
  %72 = "llvm.and"(%71, %25) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %73 = "llvm.lshr"(%71, %26) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %74 = "llvm.shufflevector"(%73, %27) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %75 = "llvm.call_intrinsic"(%72, %28, %74) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %76 = "llvm.add"(%75, %29) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %77 = "llvm.and"(%76, %25) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %78 = "llvm.ashr"(%76, %26) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %79 = "llvm.shufflevector"(%78, %41) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 8, 8>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %80 = "llvm.mul"(%79, %16) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %81 = "llvm.and"(%80, %15) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %82 = "llvm.add"(%79, %77) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %83 = "llvm.add"(%82, %81) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %84 = "llvm.add"(%83, %14) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %85 = "llvm.call"(%13, %75) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %86 = "llvm.and"(%85, %25) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %87 = "llvm.lshr"(%85, %26) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %88 = "llvm.shufflevector"(%87, %27) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %89 = "llvm.call_intrinsic"(%86, %28, %88) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %90 = "llvm.add"(%89, %12) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %91 = "llvm.call"(%90) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> vector<8xi64>
  %92 = "llvm.and"(%91, %25) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %93 = "llvm.lshr"(%91, %26) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %94 = "llvm.shufflevector"(%93, %27) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %95 = "llvm.call_intrinsic"(%92, %28, %94) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %96 = "llvm.call"(%95) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> vector<8xi64>
  %97 = "llvm.and"(%96, %25) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %98 = "llvm.lshr"(%96, %26) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %99 = "llvm.shufflevector"(%98, %27) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %100 = "llvm.call_intrinsic"(%97, %28, %99) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %101 = "llvm.call"(%90, %95) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %102 = "llvm.and"(%101, %25) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %103 = "llvm.lshr"(%101, %26) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %104 = "llvm.shufflevector"(%103, %27) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %105 = "llvm.call_intrinsic"(%102, %28, %104) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %106 = "llvm.call"(%84, %105) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %107 = "llvm.and"(%106, %25) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %108 = "llvm.lshr"(%106, %26) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %109 = "llvm.shufflevector"(%108, %27) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %110 = "llvm.call_intrinsic"(%107, %28, %109) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %111 = "llvm.call"(%110, %100) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %112 = "llvm.and"(%111, %25) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %113 = "llvm.lshr"(%111, %26) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %114 = "llvm.shufflevector"(%113, %27) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %115 = "llvm.call_intrinsic"(%112, %28, %114) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %116 = "llvm.call"(%115) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_pow22523, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> vector<8xi64>
  %117 = "llvm.call"(%110, %116) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %118 = "llvm.and"(%117, %25) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %119 = "llvm.lshr"(%117, %26) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %120 = "llvm.shufflevector"(%119, %27) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %121 = "llvm.call_intrinsic"(%118, %28, %120) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %122 = "llvm.call"(%121) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> vector<8xi64>
  %123 = "llvm.and"(%122, %25) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %124 = "llvm.lshr"(%122, %26) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %125 = "llvm.shufflevector"(%124, %27) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %126 = "llvm.call_intrinsic"(%123, %28, %125) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %127 = "llvm.call"(%90, %126) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %128 = "llvm.and"(%127, %25) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %129 = "llvm.lshr"(%127, %26) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %130 = "llvm.shufflevector"(%129, %27) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %131 = "llvm.call_intrinsic"(%128, %28, %130) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %132 = "llvm.sub"(%131, %83) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %133 = "llvm.add"(%132, %11) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %134 = "llvm.add"(%131, %84) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %135 = "llvm.call"(%133) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_is_nonzero, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> i32
  %136 = "llvm.call"(%134) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_is_nonzero, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> i32
  %137 = "llvm.and"(%136, %135) : (i32, i32) -> i32
  %138 = "llvm.icmp"(%137, %33) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%138)[^bb1, ^bb2] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb1:  // pred: ^bb0
  %139 = "llvm.lshr"(%67, %8) : (i64, i64) -> i64
  %140 = "llvm.trunc"(%139) <{overflowFlags = 3 : i32}> : (i64) -> i32
  %141 = "llvm.trunc"(%135) <{overflowFlags = 3 : i32}> : (i32) -> i8
  %142 = "llvm.add"(%141, %7) <{overflowFlags = 1 : i32}> : (i8, i8) -> i8
  %143 = "llvm.bitcast"(%142) : (i8) -> vector<8xi1>
  %144 = "llvm.select"(%143, %12, %6) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %145 = "llvm.call"(%121, %144) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %146 = "llvm.and"(%145, %25) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %147 = "llvm.lshr"(%145, %26) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %148 = "llvm.shufflevector"(%147, %27) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %149 = "llvm.call_intrinsic"(%146, %28, %148) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %150 = "llvm.call"(%149) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_diagnose, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> i32
  %151 = "llvm.icmp"(%150, %140) <{predicate = 0 : i64}> : (i32, i32) -> i1
  %152 = "llvm.sext"(%151) : (i1) -> i8
  %153 = "llvm.sub"(%11, %149) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %154 = "llvm.and"(%153, %25) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %155 = "llvm.ashr"(%153, %26) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %156 = "llvm.shufflevector"(%155, %41) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 8, 8>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %157 = "llvm.mul"(%156, %16) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %158 = "llvm.and"(%157, %15) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %159 = "llvm.add"(%154, %14) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %160 = "llvm.add"(%159, %156) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %161 = "llvm.add"(%160, %158) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %162 = "llvm.bitcast"(%152) : (i8) -> vector<8xi1>
  %163 = "llvm.select"(%162, %149, %161) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %164 = "llvm.call"(%163, %70) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %165 = "llvm.and"(%164, %25) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %166 = "llvm.lshr"(%164, %26) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %167 = "llvm.shufflevector"(%166, %27) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %168 = "llvm.call_intrinsic"(%165, %28, %167) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %169 = "llvm.shufflevector"(%163, %49) <{mask = array<i32: 0, 1, 8, 9, 4, 5, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %170 = "llvm.shufflevector"(%70, %168) <{mask = array<i32: 0, 1, 8, 9, 4, 5, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %171 = "llvm.shufflevector"(%163, %57) <{mask = array<i32: 2, 3, 10, 11, 6, 7, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %172 = "llvm.shufflevector"(%70, %168) <{mask = array<i32: 2, 3, 10, 11, 6, 7, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %173 = "llvm.shufflevector"(%169, %170) <{mask = array<i32: 0, 8, 2, 10, -1, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %174 = "llvm.shufflevector"(%169, %170) <{mask = array<i32: -1, -1, -1, -1, 5, 13, 7, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %175 = "llvm.shufflevector"(%171, %172) <{mask = array<i32: 0, 8, 2, 10, -1, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %176 = "llvm.shufflevector"(%171, %172) <{mask = array<i32: 1, 9, 3, 11, -1, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %177 = "llvm.shufflevector"(%173, %176) <{mask = array<i32: 0, 1, 2, 3, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%177, %arg0) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %178 = "llvm.shufflevector"(%169, %170) <{mask = array<i32: 1, 9, 3, 11, 4, 12, 6, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%178, %arg1) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %179 = "llvm.shufflevector"(%175, %174) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%179, %arg2) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %180 = "llvm.load"(%arg0) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %181 = "llvm.lshr"(%180, %4) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %182 = "llvm.load"(%arg1) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %183 = "llvm.lshr"(%182, %4) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %184 = "llvm.lshr"(%179, %3) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %185 = "llvm.mul"(%184, %65) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %186 = "llvm.and"(%180, %1) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %187 = "llvm.shufflevector"(%185, %184) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %188 = "llvm.add"(%187, %186) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%188, %arg0) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %189 = "llvm.load"(%arg1) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %190 = "llvm.and"(%189, %1) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %191 = "llvm.add"(%190, %181) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%191, %arg1) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %192 = "llvm.load"(%arg2) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %193 = "llvm.and"(%192, %0) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %194 = "llvm.add"(%193, %183) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.br"(%194, %33)[^bb3] : (vector<8xi64>, i32) -> ()
^bb2:  // pred: ^bb0
  "llvm.store"(%10, %arg0) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%10, %arg1) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.br"(%10, %9)[^bb3] : (vector<8xi64>, i32) -> ()
^bb3(%195: vector<8xi64>, %196: i32):  // 2 preds: ^bb1, ^bb2
  "llvm.store"(%195, %arg2) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.return"(%196) : (i32) -> ()
}) : () -> ()

    with
      @fd_r43x6_unpack := Firedancer.LaneNI.Mlir.fd_r43x6_unpack,
      @fd_r43x6_sqr_fast := Firedancer.LaneNI.Mlir.fd_r43x6_sqr_fast,
      @fd_r43x6_mul_fast := Firedancer.LaneNI.Mlir.fd_r43x6_mul_fast,
      @fd_r43x6_sqr_fast := Firedancer.LaneNI.Mlir.fd_r43x6_sqr_fast,
      @fd_r43x6_sqr_fast := Firedancer.LaneNI.Mlir.fd_r43x6_sqr_fast,
      @fd_r43x6_mul_fast := Firedancer.LaneNI.Mlir.fd_r43x6_mul_fast,
      @fd_r43x6_mul_fast := Firedancer.LaneNI.Mlir.fd_r43x6_mul_fast,
      @fd_r43x6_mul_fast := Firedancer.LaneNI.Mlir.fd_r43x6_mul_fast,
      @fd_r43x6_pow22523 := Firedancer.LaneNI.Mlir.fd_r43x6_pow22523,
      @fd_r43x6_mul_fast := Firedancer.LaneNI.Mlir.fd_r43x6_mul_fast,
      @fd_r43x6_sqr_fast := Firedancer.LaneNI.Mlir.fd_r43x6_sqr_fast,
      @fd_r43x6_mul_fast := Firedancer.LaneNI.Mlir.fd_r43x6_mul_fast,
      @fd_r43x6_is_nonzero := Firedancer.LaneNI.Mlir.fd_r43x6_is_nonzero,
      @fd_r43x6_is_nonzero := Firedancer.LaneNI.Mlir.fd_r43x6_is_nonzero,
      @fd_r43x6_mul_fast := Firedancer.LaneNI.Mlir.fd_r43x6_mul_fast,
      @fd_r43x6_diagnose := Firedancer.LaneNI.Mlir.fd_r43x6_diagnose,
      @fd_r43x6_mul_fast := Firedancer.LaneNI.Mlir.fd_r43x6_mul_fast

end

end Firedancer.LaneNI.Mlir
