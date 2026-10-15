
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.LaneNI.Mlir.fd_r43x6_quad_mul_fast_125
public import Firedancer.LaneNI.Mlir.fd_r43x6_is_nonzero_126
public import Firedancer.LaneNI.Mlir.fd_r43x6_is_nonzero_126

namespace Firedancer.LaneNI.Mlir

@[expose] public section

mlir_def fd_r43x6_ge_is_eq := "llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<i32 (vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], res_attrs = [{llvm.range = #llvm.constant_range<i32, 0, 2>}], sym_name = "fd_r43x6_ge_is_eq", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg0: vector<8xi64>, %arg1: vector<8xi64>, %arg2: vector<8xi64>, %arg3: vector<8xi64>, %arg4: vector<8xi64>, %arg5: vector<8xi64>):
  %0 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
  %1 = "llvm.mlir.constant"() <{value = dense<[8796093022189, 8796093022207, 8796093022207, 8796093022207, 8796093022207, 1099511627775, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %2 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %3 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %4 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %5 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %6 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %7 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %8 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %9 = "llvm.mlir.poison"() : () -> vector<8xi64>
  %10 = "llvm.mlir.poison"() : () -> i64
  %11 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %12 = "llvm.mlir.undef"() : () -> vector<8xi64>
  %13 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %14 = "llvm.insertelement"(%12, %11, %13) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %15 = "llvm.insertelement"(%14, %10, %8) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %16 = "llvm.insertelement"(%15, %11, %7) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %17 = "llvm.insertelement"(%16, %10, %6) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %18 = "llvm.insertelement"(%17, %11, %5) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %19 = "llvm.insertelement"(%18, %10, %4) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %20 = "llvm.insertelement"(%19, %11, %3) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %21 = "llvm.insertelement"(%20, %10, %2) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %22 = "llvm.insertelement"(%12, %10, %13) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %23 = "llvm.insertelement"(%22, %11, %8) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %24 = "llvm.insertelement"(%23, %10, %7) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %25 = "llvm.insertelement"(%24, %11, %6) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %26 = "llvm.insertelement"(%25, %10, %5) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %27 = "llvm.insertelement"(%26, %11, %4) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %28 = "llvm.insertelement"(%27, %10, %3) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %29 = "llvm.insertelement"(%28, %11, %2) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %30 = "llvm.alloca"(%8) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %31 = "llvm.alloca"(%8) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %32 = "llvm.alloca"(%8) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %33 = "llvm.shufflevector"(%arg0, %9) <{mask = array<i32: 2, 0, 2, 1, 6, 4, 6, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %34 = "llvm.shufflevector"(%arg1, %9) <{mask = array<i32: 2, 0, 2, 1, 6, 4, 6, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %35 = "llvm.shufflevector"(%arg2, %9) <{mask = array<i32: 2, 0, 2, 1, 6, 4, 6, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %36 = "llvm.shufflevector"(%arg3, %9) <{mask = array<i32: 0, 2, 1, 2, 4, 6, 5, 6>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %37 = "llvm.shufflevector"(%arg4, %9) <{mask = array<i32: 0, 2, 1, 2, 4, 6, 5, 6>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %38 = "llvm.shufflevector"(%arg5, %9) <{mask = array<i32: 0, 2, 1, 2, 4, 6, 5, 6>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.intr.lifetime.start"(%30) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%31) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%32) : (!llvm.ptr) -> ()
  "llvm.call"(%30, %31, %32, %33, %34, %35, %36, %37, %38) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_quad_mul_fast.125, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 9, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
  %39 = "llvm.load"(%30) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %40 = "llvm.load"(%31) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %41 = "llvm.load"(%32) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.intr.lifetime.end"(%32) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%31) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%30) : (!llvm.ptr) -> ()
  %42 = "llvm.shufflevector"(%39, %40) <{mask = array<i32: 0, 8, 2, 10, 4, 12, 6, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %43 = "llvm.shufflevector"(%39, %40) <{mask = array<i32: 1, 9, 3, 11, 5, 13, 7, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %44 = "llvm.shufflevector"(%41, %21) <{mask = array<i32: 0, 8, 2, 10, 4, 12, 6, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %45 = "llvm.shufflevector"(%41, %29) <{mask = array<i32: 1, 9, 3, 11, 5, 13, 7, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %46 = "llvm.shufflevector"(%42, %44) <{mask = array<i32: 0, 1, 8, 4, 5, 12, 9, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %47 = "llvm.shufflevector"(%43, %45) <{mask = array<i32: 0, 1, 8, 4, 5, 12, 9, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %48 = "llvm.shufflevector"(%42, %44) <{mask = array<i32: 2, 3, 10, 6, 7, 14, 9, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %49 = "llvm.shufflevector"(%43, %45) <{mask = array<i32: 2, 3, 10, 6, 7, 14, 9, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %50 = "llvm.sub"(%47, %46) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %51 = "llvm.add"(%50, %1) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %52 = "llvm.call"(%51) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_is_nonzero.126, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> i32
  %53 = "llvm.xor"(%52, %0) : (i32, i32) -> i32
  %54 = "llvm.sub"(%49, %48) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %55 = "llvm.add"(%54, %1) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %56 = "llvm.call"(%55) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_is_nonzero.126, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> i32
  %57 = "llvm.xor"(%56, %8) : (i32, i32) -> i32
  %58 = "llvm.and"(%57, %53) : (i32, i32) -> i32
  "llvm.return"(%58) : (i32) -> ()
}) : () -> ()

    with
      @fd_r43x6_quad_mul_fast.125 := Firedancer.LaneNI.Mlir.fd_r43x6_quad_mul_fast_125,
      @fd_r43x6_is_nonzero.126 := Firedancer.LaneNI.Mlir.fd_r43x6_is_nonzero_126,
      @fd_r43x6_is_nonzero.126 := Firedancer.LaneNI.Mlir.fd_r43x6_is_nonzero_126

end

end Firedancer.LaneNI.Mlir
