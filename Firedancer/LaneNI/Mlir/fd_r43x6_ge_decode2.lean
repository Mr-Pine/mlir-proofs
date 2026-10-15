
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.LaneNI.Mlir.fd_r43x6_unpack
public import Firedancer.LaneNI.Mlir.fd_r43x6_unpack
public import Firedancer.LaneNI.Mlir.fd_r43x6_sqr_fast
public import Firedancer.LaneNI.Mlir.fd_r43x6_sqr_fast
public import Firedancer.LaneNI.Mlir.fd_r43x6_mul_fast
public import Firedancer.LaneNI.Mlir.fd_r43x6_mul_fast
public import Firedancer.LaneNI.Mlir.fd_r43x6_sqr_fast
public import Firedancer.LaneNI.Mlir.fd_r43x6_sqr_fast
public import Firedancer.LaneNI.Mlir.fd_r43x6_sqr_fast
public import Firedancer.LaneNI.Mlir.fd_r43x6_sqr_fast
public import Firedancer.LaneNI.Mlir.fd_r43x6_mul_fast
public import Firedancer.LaneNI.Mlir.fd_r43x6_mul_fast
public import Firedancer.LaneNI.Mlir.fd_r43x6_mul_fast
public import Firedancer.LaneNI.Mlir.fd_r43x6_mul_fast
public import Firedancer.LaneNI.Mlir.fd_r43x6_mul_fast
public import Firedancer.LaneNI.Mlir.fd_r43x6_mul_fast
public import Firedancer.LaneNI.Mlir.fd_r43x6_pow22523_2
public import Firedancer.LaneNI.Mlir.fd_r43x6_mul_fast
public import Firedancer.LaneNI.Mlir.fd_r43x6_mul_fast
public import Firedancer.LaneNI.Mlir.fd_r43x6_sqr_fast
public import Firedancer.LaneNI.Mlir.fd_r43x6_sqr_fast
public import Firedancer.LaneNI.Mlir.fd_r43x6_mul_fast
public import Firedancer.LaneNI.Mlir.fd_r43x6_mul_fast
public import Firedancer.LaneNI.Mlir.fd_r43x6_is_nonzero
public import Firedancer.LaneNI.Mlir.fd_r43x6_is_nonzero
public import Firedancer.LaneNI.Mlir.fd_r43x6_is_nonzero
public import Firedancer.LaneNI.Mlir.fd_r43x6_is_nonzero
public import Firedancer.LaneNI.Mlir.fd_r43x6_mul_fast
public import Firedancer.LaneNI.Mlir.fd_r43x6_mul_fast
public import Firedancer.LaneNI.Mlir.fd_r43x6_diagnose
public import Firedancer.LaneNI.Mlir.fd_r43x6_diagnose
public import Firedancer.LaneNI.Mlir.fd_r43x6_mul_fast
public import Firedancer.LaneNI.Mlir.fd_r43x6_mul_fast

namespace Firedancer.LaneNI.Mlir

@[expose] public section

noncomputable mlir_def fd_r43x6_ge_decode2 := "llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.nofree, llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<i32 (ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr)>, linkage = #llvm.linkage<external>, no_inline, no_unwind, passthrough = ["sspstrong", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], res_attrs = [{llvm.range = #llvm.constant_range<i32, -2, 1>}], sym_name = "fd_r43x6_ge_decode2", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: !llvm.ptr, %arg3: !llvm.ptr, %arg4: !llvm.ptr, %arg5: !llvm.ptr, %arg6: !llvm.ptr, %arg7: !llvm.ptr):
  %0 = "llvm.mlir.constant"() <{value = dense<[8796093022207, 8796093022207, 8796093022207, 8796093022207, 1099511627775, 1099511627775, 1099511627775, 1099511627775]> : vector<8xi64>}> : () -> vector<8xi64>
  %1 = "llvm.mlir.constant"() <{value = dense<8796093022207> : vector<8xi64>}> : () -> vector<8xi64>
  %2 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %3 = "llvm.mlir.constant"() <{value = dense<[43, 43, 43, 43, 40, 40, 40, 40]> : vector<8xi64>}> : () -> vector<8xi64>
  %4 = "llvm.mlir.constant"() <{value = dense<43> : vector<8xi64>}> : () -> vector<8xi64>
  %5 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %6 = "llvm.mlir.constant"() <{value = dense<[3467281080496, 6582290652611, 5210002954932, 329084955603, 4526638806224, 373767602335, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %7 = "llvm.mlir.constant"() <{value = -1 : i8}> : () -> i8
  %8 = "llvm.mlir.constant"() <{value = -2 : i32}> : () -> i32
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
  %24 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %25 = "llvm.mlir.constant"() <{value = 63 : i64}> : () -> i64
  %26 = "llvm.mlir.constant"() <{value = 9223372036854775807 : i64}> : () -> i64
  %27 = "llvm.mlir.constant"() <{value = dense<[8796093022207, 8796093022207, 8796093022207, 8796093022207, 8796093022207, 1099511627775, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %28 = "llvm.mlir.constant"() <{value = dense<[43, 43, 43, 43, 43, 40, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %29 = "llvm.mlir.poison"() : () -> vector<8xi64>
  %30 = "llvm.mlir.constant"() <{value = dense<[19, 1, 1, 1, 1, 1, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %31 = "llvm.mlir.constant"() <{value = dense<[8795933638636, 8796091973631, 8796091973631, 8796091973631, 8796091973631, 1099510579199, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %32 = "llvm.mlir.poison"() : () -> i64
  %33 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %34 = "llvm.mlir.undef"() : () -> vector<8xi64>
  %35 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %36 = "llvm.insertelement"(%34, %33, %35) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %37 = "llvm.insertelement"(%36, %32, %23) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %38 = "llvm.insertelement"(%37, %32, %22) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %39 = "llvm.insertelement"(%38, %32, %21) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %40 = "llvm.insertelement"(%39, %32, %20) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %41 = "llvm.insertelement"(%40, %32, %19) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %42 = "llvm.insertelement"(%41, %32, %18) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %43 = "llvm.insertelement"(%42, %32, %17) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %44 = "llvm.insertelement"(%34, %5, %35) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %45 = "llvm.insertelement"(%44, %33, %23) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %46 = "llvm.insertelement"(%45, %32, %22) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %47 = "llvm.insertelement"(%46, %32, %21) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %48 = "llvm.insertelement"(%47, %33, %20) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %49 = "llvm.insertelement"(%48, %33, %19) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %50 = "llvm.insertelement"(%49, %32, %18) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %51 = "llvm.insertelement"(%50, %32, %17) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %52 = "llvm.insertelement"(%34, %32, %35) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %53 = "llvm.insertelement"(%52, %32, %23) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %54 = "llvm.insertelement"(%53, %33, %22) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %55 = "llvm.insertelement"(%54, %33, %21) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %56 = "llvm.insertelement"(%55, %33, %20) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %57 = "llvm.insertelement"(%56, %33, %19) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %58 = "llvm.insertelement"(%57, %32, %18) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %59 = "llvm.insertelement"(%58, %32, %17) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %60 = "llvm.insertelement"(%34, %32, %35) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %61 = "llvm.insertelement"(%60, %32, %23) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %62 = "llvm.insertelement"(%61, %32, %22) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %63 = "llvm.insertelement"(%62, %32, %21) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %64 = "llvm.insertelement"(%63, %2, %20) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %65 = "llvm.insertelement"(%64, %2, %19) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %66 = "llvm.insertelement"(%65, %2, %18) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %67 = "llvm.insertelement"(%66, %2, %17) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %68 = "llvm.alloca"(%23) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %69 = "llvm.alloca"(%23) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %70 = "llvm.load"(%arg3) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %71 = "llvm.load"(%arg7) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %72 = "llvm.extractelement"(%70, %24) : (vector<4xi64>, i64) -> i64
  %73 = "llvm.extractelement"(%71, %24) : (vector<4xi64>, i64) -> i64
  %74 = "llvm.lshr"(%72, %25) : (i64, i64) -> i64
  %75 = "llvm.trunc"(%74) <{overflowFlags = 3 : i32}> : (i64) -> i32
  %76 = "llvm.lshr"(%73, %25) : (i64, i64) -> i64
  %77 = "llvm.trunc"(%76) <{overflowFlags = 3 : i32}> : (i64) -> i32
  %78 = "llvm.and"(%72, %26) : (i64, i64) -> i64
  %79 = "llvm.and"(%73, %26) : (i64, i64) -> i64
  %80 = "llvm.insertelement"(%70, %78, %24) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %81 = "llvm.insertelement"(%71, %79, %24) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %82 = "llvm.call"(%80) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_unpack, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<4xi64>) -> vector<8xi64>
  %83 = "llvm.call"(%81) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_unpack, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<4xi64>) -> vector<8xi64>
  %84 = "llvm.call"(%82) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> vector<8xi64>
  %85 = "llvm.and"(%84, %27) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %86 = "llvm.lshr"(%84, %28) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %87 = "llvm.shufflevector"(%86, %29) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %88 = "llvm.call_intrinsic"(%85, %30, %87) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %89 = "llvm.call"(%83) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> vector<8xi64>
  %90 = "llvm.and"(%89, %27) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %91 = "llvm.lshr"(%89, %28) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %92 = "llvm.shufflevector"(%91, %29) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %93 = "llvm.call_intrinsic"(%90, %30, %92) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %94 = "llvm.add"(%88, %31) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %95 = "llvm.and"(%94, %27) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %96 = "llvm.ashr"(%94, %28) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %97 = "llvm.shufflevector"(%96, %43) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 8, 8>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %98 = "llvm.mul"(%97, %16) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %99 = "llvm.and"(%98, %15) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %100 = "llvm.add"(%97, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %101 = "llvm.add"(%100, %99) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %102 = "llvm.add"(%101, %14) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %103 = "llvm.add"(%93, %31) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %104 = "llvm.and"(%103, %27) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %105 = "llvm.ashr"(%103, %28) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %106 = "llvm.shufflevector"(%105, %43) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 8, 8>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %107 = "llvm.mul"(%106, %16) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %108 = "llvm.and"(%107, %15) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %109 = "llvm.add"(%106, %104) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %110 = "llvm.add"(%109, %108) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %111 = "llvm.add"(%110, %14) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %112 = "llvm.call"(%13, %88) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %113 = "llvm.and"(%112, %27) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %114 = "llvm.lshr"(%112, %28) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %115 = "llvm.shufflevector"(%114, %29) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %116 = "llvm.call_intrinsic"(%113, %30, %115) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %117 = "llvm.add"(%116, %12) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %118 = "llvm.call"(%13, %93) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %119 = "llvm.and"(%118, %27) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %120 = "llvm.lshr"(%118, %28) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %121 = "llvm.shufflevector"(%120, %29) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %122 = "llvm.call_intrinsic"(%119, %30, %121) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %123 = "llvm.add"(%122, %12) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %124 = "llvm.call"(%117) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> vector<8xi64>
  %125 = "llvm.and"(%124, %27) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %126 = "llvm.lshr"(%124, %28) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %127 = "llvm.shufflevector"(%126, %29) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %128 = "llvm.call_intrinsic"(%125, %30, %127) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %129 = "llvm.call"(%123) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> vector<8xi64>
  %130 = "llvm.and"(%129, %27) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %131 = "llvm.lshr"(%129, %28) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %132 = "llvm.shufflevector"(%131, %29) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %133 = "llvm.call_intrinsic"(%130, %30, %132) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %134 = "llvm.call"(%128) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> vector<8xi64>
  %135 = "llvm.and"(%134, %27) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %136 = "llvm.lshr"(%134, %28) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %137 = "llvm.shufflevector"(%136, %29) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %138 = "llvm.call_intrinsic"(%135, %30, %137) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %139 = "llvm.call"(%133) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> vector<8xi64>
  %140 = "llvm.and"(%139, %27) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %141 = "llvm.lshr"(%139, %28) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %142 = "llvm.shufflevector"(%141, %29) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %143 = "llvm.call_intrinsic"(%140, %30, %142) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %144 = "llvm.call"(%117, %128) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %145 = "llvm.and"(%144, %27) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %146 = "llvm.lshr"(%144, %28) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %147 = "llvm.shufflevector"(%146, %29) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %148 = "llvm.call_intrinsic"(%145, %30, %147) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %149 = "llvm.call"(%123, %133) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %150 = "llvm.and"(%149, %27) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %151 = "llvm.lshr"(%149, %28) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %152 = "llvm.shufflevector"(%151, %29) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %153 = "llvm.call_intrinsic"(%150, %30, %152) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %154 = "llvm.call"(%102, %148) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %155 = "llvm.and"(%154, %27) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %156 = "llvm.lshr"(%154, %28) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %157 = "llvm.shufflevector"(%156, %29) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %158 = "llvm.call_intrinsic"(%155, %30, %157) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %159 = "llvm.call"(%111, %153) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %160 = "llvm.and"(%159, %27) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %161 = "llvm.lshr"(%159, %28) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %162 = "llvm.shufflevector"(%161, %29) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %163 = "llvm.call_intrinsic"(%160, %30, %162) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %164 = "llvm.call"(%158, %138) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %165 = "llvm.and"(%164, %27) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %166 = "llvm.lshr"(%164, %28) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %167 = "llvm.shufflevector"(%166, %29) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %168 = "llvm.call_intrinsic"(%165, %30, %167) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %169 = "llvm.call"(%163, %143) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %170 = "llvm.and"(%169, %27) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %171 = "llvm.lshr"(%169, %28) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %172 = "llvm.shufflevector"(%171, %29) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %173 = "llvm.call_intrinsic"(%170, %30, %172) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.intr.lifetime.start"(%68) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%69) : (!llvm.ptr) -> ()
  "llvm.call"(%68, %168, %69, %173) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_pow22523_2, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, vector<8xi64>, !llvm.ptr, vector<8xi64>) -> ()
  %174 = "llvm.load"(%68) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %175 = "llvm.load"(%69) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.intr.lifetime.end"(%69) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%68) : (!llvm.ptr) -> ()
  %176 = "llvm.call"(%158, %174) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %177 = "llvm.and"(%176, %27) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %178 = "llvm.lshr"(%176, %28) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %179 = "llvm.shufflevector"(%178, %29) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %180 = "llvm.call_intrinsic"(%177, %30, %179) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %181 = "llvm.call"(%163, %175) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %182 = "llvm.and"(%181, %27) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %183 = "llvm.lshr"(%181, %28) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %184 = "llvm.shufflevector"(%183, %29) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %185 = "llvm.call_intrinsic"(%182, %30, %184) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %186 = "llvm.call"(%180) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> vector<8xi64>
  %187 = "llvm.and"(%186, %27) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %188 = "llvm.lshr"(%186, %28) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %189 = "llvm.shufflevector"(%188, %29) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %190 = "llvm.call_intrinsic"(%187, %30, %189) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %191 = "llvm.call"(%185) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> vector<8xi64>
  %192 = "llvm.and"(%191, %27) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %193 = "llvm.lshr"(%191, %28) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %194 = "llvm.shufflevector"(%193, %29) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %195 = "llvm.call_intrinsic"(%192, %30, %194) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %196 = "llvm.call"(%117, %190) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %197 = "llvm.and"(%196, %27) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %198 = "llvm.lshr"(%196, %28) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %199 = "llvm.shufflevector"(%198, %29) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %200 = "llvm.call_intrinsic"(%197, %30, %199) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %201 = "llvm.call"(%123, %195) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %202 = "llvm.and"(%201, %27) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %203 = "llvm.lshr"(%201, %28) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %204 = "llvm.shufflevector"(%203, %29) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %205 = "llvm.call_intrinsic"(%202, %30, %204) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %206 = "llvm.sub"(%200, %101) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %207 = "llvm.add"(%206, %11) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %208 = "llvm.sub"(%205, %110) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %209 = "llvm.add"(%208, %11) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %210 = "llvm.add"(%200, %102) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %211 = "llvm.call"(%207) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_is_nonzero, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> i32
  %212 = "llvm.call"(%209) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_is_nonzero, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> i32
  %213 = "llvm.call"(%210) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_is_nonzero, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> i32
  %214 = "llvm.and"(%213, %211) : (i32, i32) -> i32
  %215 = "llvm.icmp"(%214, %35) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%215)[^bb1, ^bb3] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb1:  // pred: ^bb0
  %216 = "llvm.add"(%205, %111) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %217 = "llvm.call"(%216) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_is_nonzero, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> i32
  %218 = "llvm.and"(%217, %212) : (i32, i32) -> i32
  %219 = "llvm.icmp"(%218, %35) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%219)[^bb2, ^bb4] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb2:  // pred: ^bb1
  %220 = "llvm.trunc"(%211) <{overflowFlags = 3 : i32}> : (i32) -> i8
  %221 = "llvm.add"(%220, %7) <{overflowFlags = 1 : i32}> : (i8, i8) -> i8
  %222 = "llvm.bitcast"(%221) : (i8) -> vector<8xi1>
  %223 = "llvm.select"(%222, %12, %6) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %224 = "llvm.trunc"(%212) <{overflowFlags = 3 : i32}> : (i32) -> i8
  %225 = "llvm.add"(%224, %7) <{overflowFlags = 1 : i32}> : (i8, i8) -> i8
  %226 = "llvm.bitcast"(%225) : (i8) -> vector<8xi1>
  %227 = "llvm.select"(%226, %12, %6) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %228 = "llvm.call"(%180, %223) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %229 = "llvm.and"(%228, %27) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %230 = "llvm.lshr"(%228, %28) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %231 = "llvm.shufflevector"(%230, %29) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %232 = "llvm.call_intrinsic"(%229, %30, %231) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %233 = "llvm.call"(%185, %227) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %234 = "llvm.and"(%233, %27) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %235 = "llvm.lshr"(%233, %28) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %236 = "llvm.shufflevector"(%235, %29) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %237 = "llvm.call_intrinsic"(%234, %30, %236) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %238 = "llvm.call"(%232) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_diagnose, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> i32
  %239 = "llvm.call"(%237) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_diagnose, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> i32
  %240 = "llvm.icmp"(%238, %75) <{predicate = 0 : i64}> : (i32, i32) -> i1
  %241 = "llvm.sext"(%240) : (i1) -> i8
  %242 = "llvm.sub"(%11, %232) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %243 = "llvm.and"(%242, %27) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %244 = "llvm.ashr"(%242, %28) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %245 = "llvm.shufflevector"(%244, %43) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 8, 8>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %246 = "llvm.mul"(%245, %16) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %247 = "llvm.and"(%246, %15) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %248 = "llvm.add"(%243, %14) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %249 = "llvm.add"(%248, %245) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %250 = "llvm.add"(%249, %247) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %251 = "llvm.bitcast"(%241) : (i8) -> vector<8xi1>
  %252 = "llvm.select"(%251, %232, %250) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %253 = "llvm.icmp"(%239, %77) <{predicate = 0 : i64}> : (i32, i32) -> i1
  %254 = "llvm.sext"(%253) : (i1) -> i8
  %255 = "llvm.sub"(%11, %237) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %256 = "llvm.and"(%255, %27) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %257 = "llvm.ashr"(%255, %28) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %258 = "llvm.shufflevector"(%257, %43) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 8, 8>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %259 = "llvm.mul"(%258, %16) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %260 = "llvm.and"(%259, %15) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %261 = "llvm.add"(%256, %14) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %262 = "llvm.add"(%261, %258) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %263 = "llvm.add"(%262, %260) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %264 = "llvm.bitcast"(%254) : (i8) -> vector<8xi1>
  %265 = "llvm.select"(%264, %237, %263) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %266 = "llvm.call"(%252, %82) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %267 = "llvm.and"(%266, %27) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %268 = "llvm.lshr"(%266, %28) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %269 = "llvm.shufflevector"(%268, %29) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %270 = "llvm.call_intrinsic"(%267, %30, %269) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %271 = "llvm.call"(%265, %83) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %272 = "llvm.and"(%271, %27) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %273 = "llvm.lshr"(%271, %28) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %274 = "llvm.shufflevector"(%273, %29) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %275 = "llvm.call_intrinsic"(%272, %30, %274) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %276 = "llvm.shufflevector"(%252, %51) <{mask = array<i32: 0, 1, 8, 9, 4, 5, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %277 = "llvm.shufflevector"(%82, %270) <{mask = array<i32: 0, 1, 8, 9, 4, 5, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %278 = "llvm.shufflevector"(%252, %59) <{mask = array<i32: 2, 3, 10, 11, 6, 7, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %279 = "llvm.shufflevector"(%82, %270) <{mask = array<i32: 2, 3, 10, 11, 6, 7, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %280 = "llvm.shufflevector"(%276, %277) <{mask = array<i32: 0, 8, 2, 10, -1, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %281 = "llvm.shufflevector"(%276, %277) <{mask = array<i32: -1, -1, -1, -1, 5, 13, 7, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %282 = "llvm.shufflevector"(%278, %279) <{mask = array<i32: 0, 8, 2, 10, -1, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %283 = "llvm.shufflevector"(%278, %279) <{mask = array<i32: 1, 9, 3, 11, -1, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %284 = "llvm.shufflevector"(%280, %283) <{mask = array<i32: 0, 1, 2, 3, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%284, %arg0) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %285 = "llvm.shufflevector"(%276, %277) <{mask = array<i32: 1, 9, 3, 11, 4, 12, 6, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%285, %arg1) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %286 = "llvm.shufflevector"(%282, %281) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%286, %arg2) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %287 = "llvm.shufflevector"(%265, %51) <{mask = array<i32: 0, 1, 8, 9, 4, 5, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %288 = "llvm.shufflevector"(%83, %275) <{mask = array<i32: 0, 1, 8, 9, 4, 5, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %289 = "llvm.shufflevector"(%265, %59) <{mask = array<i32: 2, 3, 10, 11, 6, 7, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %290 = "llvm.shufflevector"(%83, %275) <{mask = array<i32: 2, 3, 10, 11, 6, 7, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %291 = "llvm.shufflevector"(%287, %288) <{mask = array<i32: 0, 8, 2, 10, -1, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %292 = "llvm.shufflevector"(%287, %288) <{mask = array<i32: -1, -1, -1, -1, 5, 13, 7, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %293 = "llvm.shufflevector"(%289, %290) <{mask = array<i32: 0, 8, 2, 10, -1, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %294 = "llvm.shufflevector"(%289, %290) <{mask = array<i32: 1, 9, 3, 11, -1, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %295 = "llvm.shufflevector"(%291, %294) <{mask = array<i32: 0, 1, 2, 3, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%295, %arg4) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %296 = "llvm.shufflevector"(%287, %288) <{mask = array<i32: 1, 9, 3, 11, 4, 12, 6, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%296, %arg5) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %297 = "llvm.shufflevector"(%293, %292) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%297, %arg6) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %298 = "llvm.load"(%arg0) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %299 = "llvm.lshr"(%298, %4) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %300 = "llvm.load"(%arg1) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %301 = "llvm.lshr"(%300, %4) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %302 = "llvm.load"(%arg2) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %303 = "llvm.lshr"(%302, %3) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %304 = "llvm.mul"(%303, %67) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %305 = "llvm.and"(%298, %1) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %306 = "llvm.shufflevector"(%304, %303) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %307 = "llvm.add"(%306, %305) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%307, %arg0) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %308 = "llvm.load"(%arg1) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %309 = "llvm.and"(%308, %1) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %310 = "llvm.add"(%309, %299) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%310, %arg1) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %311 = "llvm.load"(%arg2) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %312 = "llvm.and"(%311, %0) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %313 = "llvm.add"(%312, %301) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%313, %arg2) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %314 = "llvm.load"(%arg4) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %315 = "llvm.lshr"(%314, %4) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %316 = "llvm.load"(%arg5) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %317 = "llvm.lshr"(%316, %4) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %318 = "llvm.load"(%arg6) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %319 = "llvm.lshr"(%318, %3) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %320 = "llvm.mul"(%319, %67) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %321 = "llvm.and"(%314, %1) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %322 = "llvm.shufflevector"(%320, %319) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %323 = "llvm.add"(%322, %321) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%323, %arg4) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %324 = "llvm.load"(%arg5) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %325 = "llvm.and"(%324, %1) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %326 = "llvm.add"(%325, %315) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%326, %arg5) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %327 = "llvm.load"(%arg6) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %328 = "llvm.and"(%327, %0) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %329 = "llvm.add"(%328, %317) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.br"(%329, %35)[^bb5] : (vector<8xi64>, i32) -> ()
^bb3:  // pred: ^bb0
  "llvm.store"(%10, %arg0) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%10, %arg4) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%10, %arg1) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%10, %arg5) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%10, %arg2) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.br"(%10, %9)[^bb5] : (vector<8xi64>, i32) -> ()
^bb4:  // pred: ^bb1
  "llvm.store"(%10, %arg0) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%10, %arg4) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%10, %arg1) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%10, %arg5) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%10, %arg2) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.br"(%10, %8)[^bb5] : (vector<8xi64>, i32) -> ()
^bb5(%330: vector<8xi64>, %331: i32):  // 3 preds: ^bb2, ^bb3, ^bb4
  "llvm.store"(%330, %arg6) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.return"(%331) : (i32) -> ()
}) : () -> ()

    with
      @fd_r43x6_unpack := Firedancer.LaneNI.Mlir.fd_r43x6_unpack,
      @fd_r43x6_unpack := Firedancer.LaneNI.Mlir.fd_r43x6_unpack,
      @fd_r43x6_sqr_fast := Firedancer.LaneNI.Mlir.fd_r43x6_sqr_fast,
      @fd_r43x6_sqr_fast := Firedancer.LaneNI.Mlir.fd_r43x6_sqr_fast,
      @fd_r43x6_mul_fast := Firedancer.LaneNI.Mlir.fd_r43x6_mul_fast,
      @fd_r43x6_mul_fast := Firedancer.LaneNI.Mlir.fd_r43x6_mul_fast,
      @fd_r43x6_sqr_fast := Firedancer.LaneNI.Mlir.fd_r43x6_sqr_fast,
      @fd_r43x6_sqr_fast := Firedancer.LaneNI.Mlir.fd_r43x6_sqr_fast,
      @fd_r43x6_sqr_fast := Firedancer.LaneNI.Mlir.fd_r43x6_sqr_fast,
      @fd_r43x6_sqr_fast := Firedancer.LaneNI.Mlir.fd_r43x6_sqr_fast,
      @fd_r43x6_mul_fast := Firedancer.LaneNI.Mlir.fd_r43x6_mul_fast,
      @fd_r43x6_mul_fast := Firedancer.LaneNI.Mlir.fd_r43x6_mul_fast,
      @fd_r43x6_mul_fast := Firedancer.LaneNI.Mlir.fd_r43x6_mul_fast,
      @fd_r43x6_mul_fast := Firedancer.LaneNI.Mlir.fd_r43x6_mul_fast,
      @fd_r43x6_mul_fast := Firedancer.LaneNI.Mlir.fd_r43x6_mul_fast,
      @fd_r43x6_mul_fast := Firedancer.LaneNI.Mlir.fd_r43x6_mul_fast,
      @fd_r43x6_pow22523_2 := Firedancer.LaneNI.Mlir.fd_r43x6_pow22523_2,
      @fd_r43x6_mul_fast := Firedancer.LaneNI.Mlir.fd_r43x6_mul_fast,
      @fd_r43x6_mul_fast := Firedancer.LaneNI.Mlir.fd_r43x6_mul_fast,
      @fd_r43x6_sqr_fast := Firedancer.LaneNI.Mlir.fd_r43x6_sqr_fast,
      @fd_r43x6_sqr_fast := Firedancer.LaneNI.Mlir.fd_r43x6_sqr_fast,
      @fd_r43x6_mul_fast := Firedancer.LaneNI.Mlir.fd_r43x6_mul_fast,
      @fd_r43x6_mul_fast := Firedancer.LaneNI.Mlir.fd_r43x6_mul_fast,
      @fd_r43x6_is_nonzero := Firedancer.LaneNI.Mlir.fd_r43x6_is_nonzero,
      @fd_r43x6_is_nonzero := Firedancer.LaneNI.Mlir.fd_r43x6_is_nonzero,
      @fd_r43x6_is_nonzero := Firedancer.LaneNI.Mlir.fd_r43x6_is_nonzero,
      @fd_r43x6_is_nonzero := Firedancer.LaneNI.Mlir.fd_r43x6_is_nonzero,
      @fd_r43x6_mul_fast := Firedancer.LaneNI.Mlir.fd_r43x6_mul_fast,
      @fd_r43x6_mul_fast := Firedancer.LaneNI.Mlir.fd_r43x6_mul_fast,
      @fd_r43x6_diagnose := Firedancer.LaneNI.Mlir.fd_r43x6_diagnose,
      @fd_r43x6_diagnose := Firedancer.LaneNI.Mlir.fd_r43x6_diagnose,
      @fd_r43x6_mul_fast := Firedancer.LaneNI.Mlir.fd_r43x6_mul_fast,
      @fd_r43x6_mul_fast := Firedancer.LaneNI.Mlir.fd_r43x6_mul_fast

end

end Firedancer.LaneNI.Mlir
