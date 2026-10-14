
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab



namespace Firedancer.Lane.Mlir

@[expose] public section

mlir_def fd_ed25519_affine_is_small_order := "llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<i32 (ptr)>, inline_hint, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], res_attrs = [{llvm.range = #llvm.constant_range<i32, 0, 2>}], sym_name = "fd_ed25519_affine_is_small_order", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg0: !llvm.ptr):
  %0 = "llvm.mlir.constant"() <{value = dense<[3034496493606, 7251660506358, 8531477514791, 3751700492266, 152656122684, 51415276304, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %1 = "llvm.mlir.constant"() <{value = dense<[159383552, 1048576, 1048576, 1048576, 1048576, 1048576, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %2 = "llvm.mlir.constant"() <{value = dense<[-1, 0, 0, 0, 0, 0, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %3 = "llvm.mlir.constant"() <{value = dense<18> : vector<8xi64>}> : () -> vector<8xi64>
  %4 = "llvm.mlir.constant"() <{value = dense<[43, 43, 43, 43, 43, 40, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %5 = "llvm.mlir.constant"() <{value = dense<[8796093022207, 8796093022207, 8796093022207, 8796093022207, 8796093022207, 1099511627775, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %6 = "llvm.mlir.constant"() <{value = dense<[5761277761479, 1544430418697, 264613410264, 5044390432789, 8643434802371, 1048094254319, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %7 = "llvm.mlir.constant"() <{value = true}> : () -> i1
  %8 = "llvm.mlir.constant"() <{value = dense<[8796093022189, 8796093022207, 8796093022207, 8796093022207, 8796093022207, 1099511627775, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %9 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %10 = "llvm.mlir.constant"() <{value = dense<0> : vector<8xi64>}> : () -> vector<8xi64>
  %11 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %12 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %13 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %14 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %15 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %16 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %17 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %18 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %19 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %20 = "llvm.mlir.poison"() : () -> i64
  %21 = "llvm.mlir.undef"() : () -> vector<8xi64>
  %22 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %23 = "llvm.insertelement"(%21, %20, %22) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %24 = "llvm.insertelement"(%23, %18, %17) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %25 = "llvm.insertelement"(%24, %20, %16) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %26 = "llvm.insertelement"(%25, %20, %15) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %27 = "llvm.insertelement"(%26, %20, %14) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %28 = "llvm.insertelement"(%27, %20, %13) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %29 = "llvm.insertelement"(%28, %20, %12) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %30 = "llvm.insertelement"(%29, %20, %11) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %31 = "llvm.insertelement"(%21, %18, %22) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %32 = "llvm.insertelement"(%31, %20, %17) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %33 = "llvm.insertelement"(%32, %20, %16) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %34 = "llvm.insertelement"(%33, %20, %15) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %35 = "llvm.insertelement"(%34, %20, %14) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %36 = "llvm.insertelement"(%35, %20, %13) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %37 = "llvm.insertelement"(%36, %20, %12) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %38 = "llvm.insertelement"(%37, %20, %11) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %39 = "llvm.load"(%arg0) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %40 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %41 = "llvm.load"(%40) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %42 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %43 = "llvm.load"(%42) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %44 = "llvm.shufflevector"(%39, %41) <{mask = array<i32: 0, 8, -1, -1, 4, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %45 = "llvm.shufflevector"(%39, %41) <{mask = array<i32: 1, 9, -1, -1, 5, 13, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %46 = "llvm.insertelement"(%43, %18, %19) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %47 = "llvm.shufflevector"(%43, %30) <{mask = array<i32: 1, 9, -1, -1, 5, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %48 = "llvm.shufflevector"(%44, %46) <{mask = array<i32: 0, 1, 8, 4, 5, 12, 9, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %49 = "llvm.shufflevector"(%45, %47) <{mask = array<i32: 0, 1, 8, 4, 5, 12, 9, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %50 = "llvm.icmp"(%48, %10) <{predicate = 1 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %51 = "llvm.bitcast"(%50) : (vector<8xi1>) -> i8
  %52 = "llvm.icmp"(%51, %9) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %53 = "llvm.icmp"(%48, %8) <{predicate = 1 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %54 = "llvm.bitcast"(%53) : (vector<8xi1>) -> i8
  %55 = "llvm.icmp"(%54, %9) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %56 = "llvm.select"(%52, %7, %55) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i1, i1) -> i1
  %57 = "llvm.icmp"(%49, %10) <{predicate = 1 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %58 = "llvm.bitcast"(%57) : (vector<8xi1>) -> i8
  %59 = "llvm.icmp"(%58, %9) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %60 = "llvm.icmp"(%49, %8) <{predicate = 1 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %61 = "llvm.bitcast"(%60) : (vector<8xi1>) -> i8
  %62 = "llvm.icmp"(%61, %9) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %63 = "llvm.select"(%59, %7, %62) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i1, i1) -> i1
  %64 = "llvm.or"(%56, %63) : (i1, i1) -> i1
  %65 = "llvm.add"(%49, %6) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %66 = "llvm.and"(%65, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %67 = "llvm.ashr"(%65, %4) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %68 = "llvm.shufflevector"(%67, %38) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 8, 8>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %69 = "llvm.mul"(%68, %3) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %70 = "llvm.and"(%69, %2) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %71 = "llvm.add"(%66, %1) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %72 = "llvm.add"(%71, %68) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %73 = "llvm.add"(%72, %70) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %74 = "llvm.icmp"(%73, %10) <{predicate = 1 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %75 = "llvm.bitcast"(%74) : (vector<8xi1>) -> i8
  %76 = "llvm.icmp"(%75, %9) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %77 = "llvm.icmp"(%73, %8) <{predicate = 1 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %78 = "llvm.bitcast"(%77) : (vector<8xi1>) -> i8
  %79 = "llvm.icmp"(%78, %9) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %80 = "llvm.select"(%76, %7, %79) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i1, i1) -> i1
  %81 = "llvm.or"(%64, %80) : (i1, i1) -> i1
  %82 = "llvm.add"(%49, %0) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %83 = "llvm.and"(%82, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %84 = "llvm.ashr"(%82, %4) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %85 = "llvm.shufflevector"(%84, %38) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 8, 8>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %86 = "llvm.mul"(%85, %3) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %87 = "llvm.and"(%86, %2) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %88 = "llvm.add"(%83, %1) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %89 = "llvm.add"(%88, %85) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %90 = "llvm.add"(%89, %87) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %91 = "llvm.icmp"(%90, %10) <{predicate = 1 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %92 = "llvm.bitcast"(%91) : (vector<8xi1>) -> i8
  %93 = "llvm.icmp"(%92, %9) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %94 = "llvm.icmp"(%90, %8) <{predicate = 1 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %95 = "llvm.bitcast"(%94) : (vector<8xi1>) -> i8
  %96 = "llvm.icmp"(%95, %9) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %97 = "llvm.select"(%93, %7, %96) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i1, i1) -> i1
  %98 = "llvm.or"(%97, %81) : (i1, i1) -> i1
  %99 = "llvm.zext"(%98) : (i1) -> i32
  "llvm.return"(%99) : (i32) -> ()
}) : () -> ()

end

end Firedancer.Lane.Mlir
