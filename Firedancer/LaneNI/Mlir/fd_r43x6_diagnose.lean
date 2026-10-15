
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.LaneNI.Mlir.fd_int_if

namespace Firedancer.LaneNI.Mlir

@[expose] public section

mlir_def fd_r43x6_diagnose := "llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.noundef}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<i32 (vector<8xi64>)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], res_attrs = [{llvm.noundef, llvm.range = #llvm.constant_range<i32, -1, 2>}], sym_name = "fd_r43x6_diagnose", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg0: vector<8xi64>):
  %0 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %1 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %2 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %3 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %4 = "llvm.mlir.constant"() <{value = 4 : i64}> : () -> i64
  %5 = "llvm.mlir.constant"() <{value = 5 : i64}> : () -> i64
  %6 = "llvm.mlir.constant"() <{value = -1048576 : i64}> : () -> i64
  %7 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
  %8 = "llvm.mlir.constant"() <{value = 1099511627775 : i64}> : () -> i64
  %9 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %10 = "llvm.mlir.constant"() <{value = 43 : i64}> : () -> i64
  %11 = "llvm.mlir.constant"() <{value = 8796093022207 : i64}> : () -> i64
  %12 = "llvm.mlir.constant"() <{value = 1048576 : i64}> : () -> i64
  %13 = "llvm.mlir.constant"() <{value = 1099511627776 : i64}> : () -> i64
  %14 = "llvm.mlir.constant"() <{value = -19 : i64}> : () -> i64
  %15 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %16 = "llvm.extractelement"(%arg0, %0) : (vector<8xi64>, i64) -> i64
  %17 = "llvm.extractelement"(%arg0, %1) : (vector<8xi64>, i64) -> i64
  %18 = "llvm.extractelement"(%arg0, %2) : (vector<8xi64>, i64) -> i64
  %19 = "llvm.extractelement"(%arg0, %3) : (vector<8xi64>, i64) -> i64
  %20 = "llvm.extractelement"(%arg0, %4) : (vector<8xi64>, i64) -> i64
  %21 = "llvm.extractelement"(%arg0, %5) : (vector<8xi64>, i64) -> i64
  %22 = "llvm.add"(%21, %6) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %23 = "llvm.ashr"(%22, %7) : (i64, i64) -> i64
  %24 = "llvm.and"(%22, %8) : (i64, i64) -> i64
  %25 = "llvm.mul"(%23, %9) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %26 = "llvm.add"(%25, %16) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %27 = "llvm.ashr"(%26, %10) : (i64, i64) -> i64
  %28 = "llvm.and"(%26, %11) : (i64, i64) -> i64
  %29 = "llvm.add"(%27, %17) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %30 = "llvm.ashr"(%29, %10) : (i64, i64) -> i64
  %31 = "llvm.and"(%29, %11) : (i64, i64) -> i64
  %32 = "llvm.add"(%30, %18) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %33 = "llvm.ashr"(%32, %10) : (i64, i64) -> i64
  %34 = "llvm.and"(%32, %11) : (i64, i64) -> i64
  %35 = "llvm.add"(%33, %19) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %36 = "llvm.ashr"(%35, %10) : (i64, i64) -> i64
  %37 = "llvm.and"(%35, %11) : (i64, i64) -> i64
  %38 = "llvm.add"(%36, %20) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %39 = "llvm.ashr"(%38, %10) : (i64, i64) -> i64
  %40 = "llvm.and"(%38, %11) : (i64, i64) -> i64
  %41 = "llvm.add"(%28, %9) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %42 = "llvm.lshr"(%41, %10) : (i64, i64) -> i64
  %43 = "llvm.and"(%41, %11) : (i64, i64) -> i64
  %44 = "llvm.add"(%31, %42) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %45 = "llvm.lshr"(%44, %10) : (i64, i64) -> i64
  %46 = "llvm.and"(%44, %11) : (i64, i64) -> i64
  %47 = "llvm.add"(%34, %45) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %48 = "llvm.lshr"(%47, %10) : (i64, i64) -> i64
  %49 = "llvm.and"(%47, %11) : (i64, i64) -> i64
  %50 = "llvm.add"(%37, %48) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %51 = "llvm.lshr"(%50, %10) : (i64, i64) -> i64
  %52 = "llvm.and"(%50, %11) : (i64, i64) -> i64
  %53 = "llvm.add"(%40, %51) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %54 = "llvm.lshr"(%53, %10) : (i64, i64) -> i64
  %55 = "llvm.and"(%53, %11) : (i64, i64) -> i64
  %56 = "llvm.add"(%24, %12) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %57 = "llvm.add"(%56, %39) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %58 = "llvm.add"(%57, %54) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %59 = "llvm.and"(%58, %8) : (i64, i64) -> i64
  %60 = "llvm.icmp"(%58, %13) <{predicate = 6 : i64}> : (i64, i64) -> i1
  %61 = "llvm.select"(%60, %14, %0) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %62 = "llvm.add"(%61, %43) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %63 = "llvm.ashr"(%62, %10) : (i64, i64) -> i64
  %64 = "llvm.add"(%63, %46) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %65 = "llvm.ashr"(%64, %10) : (i64, i64) -> i64
  %66 = "llvm.add"(%65, %49) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %67 = "llvm.ashr"(%66, %10) : (i64, i64) -> i64
  %68 = "llvm.add"(%67, %52) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %69 = "llvm.ashr"(%68, %10) : (i64, i64) -> i64
  %70 = "llvm.add"(%69, %55) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %71 = "llvm.ashr"(%70, %10) : (i64, i64) -> i64
  %72 = "llvm.add"(%71, %59) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %73 = "llvm.or"(%64, %62) : (i64, i64) -> i64
  %74 = "llvm.or"(%73, %66) : (i64, i64) -> i64
  %75 = "llvm.or"(%74, %68) : (i64, i64) -> i64
  %76 = "llvm.or"(%75, %70) : (i64, i64) -> i64
  %77 = "llvm.and"(%76, %11) : (i64, i64) -> i64
  %78 = "llvm.or"(%77, %72) : (i64, i64) -> i64
  %79 = "llvm.icmp"(%78, %0) <{predicate = 0 : i64}> : (i64, i64) -> i1
  %80 = "llvm.zext"(%79) : (i1) -> i32
  %81 = "llvm.trunc"(%62) <{overflowFlags = 0 : i32}> : (i64) -> i32
  %82 = "llvm.and"(%81, %15) : (i32, i32) -> i32
  %83 = "llvm.call"(%80, %82) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_int_if, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (i32, i32) -> i32
  "llvm.return"(%83) : (i32) -> ()
}) : () -> ()

    with
      @fd_int_if := Firedancer.LaneNI.Mlir.fd_int_if

end

end Firedancer.LaneNI.Mlir
