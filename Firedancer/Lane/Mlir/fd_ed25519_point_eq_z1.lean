
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab



namespace Firedancer.Lane.Mlir

@[expose] public section

mlir_def fd_ed25519_point_eq_z1 := "llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<i32 (ptr, ptr)>, inline_hint, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], res_attrs = [{llvm.range = #llvm.constant_range<i32, 0, 2>}], sym_name = "fd_ed25519_point_eq_z1", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr):
  %0 = "llvm.mlir.constant"() <{value = false}> : () -> i1
  %1 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %2 = "llvm.mlir.constant"() <{value = dense<0> : vector<2xi64>}> : () -> vector<2xi64>
  %3 = "llvm.mlir.constant"() <{value = dense<-19> : vector<2xi64>}> : () -> vector<2xi64>
  %4 = "llvm.mlir.constant"() <{value = dense<1099511627776> : vector<2xi64>}> : () -> vector<2xi64>
  %5 = "llvm.mlir.constant"() <{value = dense<8796093022207> : vector<2xi64>}> : () -> vector<2xi64>
  %6 = "llvm.mlir.constant"() <{value = dense<43> : vector<2xi64>}> : () -> vector<2xi64>
  %7 = "llvm.mlir.constant"() <{value = dense<1048576> : vector<2xi64>}> : () -> vector<2xi64>
  %8 = "llvm.mlir.constant"() <{value = dense<19> : vector<2xi64>}> : () -> vector<2xi64>
  %9 = "llvm.mlir.constant"() <{value = dense<40> : vector<2xi64>}> : () -> vector<2xi64>
  %10 = "llvm.mlir.constant"() <{value = dense<1099511627775> : vector<2xi64>}> : () -> vector<2xi64>
  %11 = "llvm.mlir.constant"() <{value = dense<-1048576> : vector<2xi64>}> : () -> vector<2xi64>
  %12 = "llvm.mlir.constant"() <{value = 8796093022189 : i64}> : () -> i64
  %13 = "llvm.mlir.constant"() <{value = 8796093022207 : i64}> : () -> i64
  %14 = "llvm.mlir.constant"() <{value = 1099511627775 : i64}> : () -> i64
  %15 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %16 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %17 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %18 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %19 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %20 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %21 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %22 = "llvm.mlir.poison"() : () -> vector<7xi64>
  %23 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %24 = "llvm.mlir.constant"() <{value = dense<0> : vector<8xi64>}> : () -> vector<8xi64>
  %25 = "llvm.mlir.constant"() <{value = dense<9> : vector<8xi64>}> : () -> vector<8xi64>
  %26 = "llvm.mlir.poison"() : () -> vector<8xi64>
  %27 = "llvm.mlir.constant"() <{value = dense<7> : vector<8xi64>}> : () -> vector<8xi64>
  %28 = "llvm.mlir.constant"() <{value = dense<24> : vector<8xi64>}> : () -> vector<8xi64>
  %29 = "llvm.mlir.poison"() : () -> i64
  %30 = "llvm.mlir.undef"() : () -> vector<8xi64>
  %31 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %32 = "llvm.insertelement"(%30, %23, %31) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %33 = "llvm.insertelement"(%32, %29, %21) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %34 = "llvm.insertelement"(%33, %23, %20) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %35 = "llvm.insertelement"(%34, %29, %19) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %36 = "llvm.insertelement"(%35, %23, %18) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %37 = "llvm.insertelement"(%36, %29, %17) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %38 = "llvm.insertelement"(%37, %23, %16) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %39 = "llvm.insertelement"(%38, %29, %15) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %40 = "llvm.insertelement"(%30, %29, %31) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %41 = "llvm.insertelement"(%40, %23, %21) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %42 = "llvm.insertelement"(%41, %29, %20) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %43 = "llvm.insertelement"(%42, %23, %19) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %44 = "llvm.insertelement"(%43, %29, %18) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %45 = "llvm.insertelement"(%44, %23, %17) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %46 = "llvm.insertelement"(%45, %29, %16) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %47 = "llvm.insertelement"(%46, %23, %15) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %48 = "llvm.insertelement"(%30, %12, %31) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %49 = "llvm.insertelement"(%48, %13, %21) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %50 = "llvm.insertelement"(%49, %13, %20) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %51 = "llvm.insertelement"(%50, %13, %19) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %52 = "llvm.insertelement"(%51, %13, %18) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %53 = "llvm.insertelement"(%52, %14, %17) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %54 = "llvm.insertelement"(%53, %29, %16) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %55 = "llvm.insertelement"(%54, %29, %15) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %56 = "llvm.load"(%arg0) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<7xi64>
  %57 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %58 = "llvm.load"(%57) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<7xi64>
  %59 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %60 = "llvm.load"(%59) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<7xi64>
  %61 = "llvm.load"(%arg1) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<7xi64>
  %62 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %63 = "llvm.load"(%62) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<7xi64>
  %64 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %65 = "llvm.load"(%64) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<7xi64>
  %66 = "llvm.shufflevector"(%61, %22) <{mask = array<i32: 0, 2, 1, 2, 4, 6, 5, 6>}> : (vector<7xi64>, vector<7xi64>) -> vector<8xi64>
  %67 = "llvm.shufflevector"(%63, %22) <{mask = array<i32: 0, 2, 1, 2, 4, 6, 5, 6>}> : (vector<7xi64>, vector<7xi64>) -> vector<8xi64>
  %68 = "llvm.shufflevector"(%65, %22) <{mask = array<i32: 0, 2, 1, 2, 4, 6, 5, 6>}> : (vector<7xi64>, vector<7xi64>) -> vector<8xi64>
  %69 = "llvm.shufflevector"(%56, %22) <{mask = array<i32: 2, 0, 2, 1, 2, 0, 2, 1>}> : (vector<7xi64>, vector<7xi64>) -> vector<8xi64>
  %70 = "llvm.shufflevector"(%58, %22) <{mask = array<i32: 2, 0, 2, 1, 2, 0, 2, 1>}> : (vector<7xi64>, vector<7xi64>) -> vector<8xi64>
  %71 = "llvm.shufflevector"(%60, %22) <{mask = array<i32: 2, 0, 2, 1, 2, 0, 2, 1>}> : (vector<7xi64>, vector<7xi64>) -> vector<8xi64>
  %72 = "llvm.shufflevector"(%56, %22) <{mask = array<i32: 6, 4, 6, 5, 6, 4, 6, 5>}> : (vector<7xi64>, vector<7xi64>) -> vector<8xi64>
  %73 = "llvm.shufflevector"(%58, %22) <{mask = array<i32: 6, 4, 6, 5, 6, 4, 6, 5>}> : (vector<7xi64>, vector<7xi64>) -> vector<8xi64>
  %74 = "llvm.shufflevector"(%60, %22) <{mask = array<i32: 6, 4, 6, 5, 6, 4, 6, 5>}> : (vector<7xi64>, vector<7xi64>) -> vector<8xi64>
  %75 = "llvm.call_intrinsic"(%24, %69, %66) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %76 = "llvm.call_intrinsic"(%24, %70, %66) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %77 = "llvm.call_intrinsic"(%76, %69, %67) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %78 = "llvm.call_intrinsic"(%24, %71, %66) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %79 = "llvm.call_intrinsic"(%78, %70, %67) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %80 = "llvm.call_intrinsic"(%79, %69, %68) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %81 = "llvm.call_intrinsic"(%24, %72, %66) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %82 = "llvm.call_intrinsic"(%81, %71, %67) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %83 = "llvm.call_intrinsic"(%82, %70, %68) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %84 = "llvm.call_intrinsic"(%24, %73, %66) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %85 = "llvm.call_intrinsic"(%84, %72, %67) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %86 = "llvm.call_intrinsic"(%85, %71, %68) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %87 = "llvm.call_intrinsic"(%24, %74, %66) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %88 = "llvm.call_intrinsic"(%87, %73, %67) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %89 = "llvm.call_intrinsic"(%88, %72, %68) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %90 = "llvm.call_intrinsic"(%24, %74, %67) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %91 = "llvm.call_intrinsic"(%90, %73, %68) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %92 = "llvm.call_intrinsic"(%24, %69, %66) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %93 = "llvm.shl"(%92, %25) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %94 = "llvm.add"(%93, %77) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %95 = "llvm.call_intrinsic"(%24, %70, %66) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %96 = "llvm.call_intrinsic"(%95, %69, %67) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %97 = "llvm.shl"(%96, %25) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %98 = "llvm.add"(%97, %80) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %99 = "llvm.call_intrinsic"(%24, %71, %66) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %100 = "llvm.call_intrinsic"(%99, %70, %67) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %101 = "llvm.call_intrinsic"(%100, %69, %68) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %102 = "llvm.shl"(%101, %25) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %103 = "llvm.add"(%102, %83) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %104 = "llvm.call_intrinsic"(%24, %72, %66) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %105 = "llvm.call_intrinsic"(%104, %71, %67) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %106 = "llvm.call_intrinsic"(%105, %70, %68) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %107 = "llvm.shl"(%106, %25) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %108 = "llvm.add"(%107, %86) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %109 = "llvm.call_intrinsic"(%24, %73, %66) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %110 = "llvm.call_intrinsic"(%109, %72, %67) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %111 = "llvm.call_intrinsic"(%110, %71, %68) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %112 = "llvm.shl"(%111, %25) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %113 = "llvm.add"(%112, %89) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %114 = "llvm.call_intrinsic"(%24, %74, %66) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %115 = "llvm.call_intrinsic"(%114, %73, %67) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %116 = "llvm.call_intrinsic"(%115, %72, %68) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %117 = "llvm.shl"(%116, %25) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %118 = "llvm.add"(%117, %91) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %119 = "llvm.call_intrinsic"(%24, %74, %67) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %120 = "llvm.call_intrinsic"(%119, %73, %68) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %121 = "llvm.shl"(%120, %25) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %122 = "llvm.call_intrinsic"(%121, %74, %68) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %123 = "llvm.call_intrinsic"(%24, %74, %68) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %124 = "llvm.shl"(%123, %25) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %125 = "llvm.shufflevector"(%103, %26) <{mask = array<i32: 4, 5, 6, 7, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %126 = "llvm.shufflevector"(%108, %26) <{mask = array<i32: 4, 5, 6, 7, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %127 = "llvm.shufflevector"(%113, %26) <{mask = array<i32: 4, 5, 6, 7, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %128 = "llvm.add"(%125, %75) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %129 = "llvm.shufflevector"(%75, %128) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %130 = "llvm.add"(%126, %94) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %131 = "llvm.shufflevector"(%94, %130) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %132 = "llvm.add"(%127, %98) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %133 = "llvm.shufflevector"(%98, %132) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %134 = "llvm.add"(%118, %125) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %135 = "llvm.shufflevector"(%134, %118) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %136 = "llvm.add"(%122, %126) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %137 = "llvm.shufflevector"(%136, %122) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %138 = "llvm.add"(%124, %127) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %139 = "llvm.shufflevector"(%138, %124) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %140 = "llvm.shl"(%135, %27) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %141 = "llvm.add"(%140, %129) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %142 = "llvm.mul"(%135, %28) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %143 = "llvm.add"(%141, %142) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %144 = "llvm.shl"(%137, %27) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %145 = "llvm.add"(%144, %131) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %146 = "llvm.mul"(%137, %28) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %147 = "llvm.add"(%145, %146) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %148 = "llvm.shl"(%139, %27) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %149 = "llvm.add"(%148, %133) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %150 = "llvm.mul"(%139, %28) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %151 = "llvm.add"(%149, %150) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %152 = "llvm.shufflevector"(%143, %147) <{mask = array<i32: 0, 8, 2, 10, 4, 12, 6, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %153 = "llvm.shufflevector"(%143, %147) <{mask = array<i32: 1, 9, 3, 11, 5, 13, 7, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %154 = "llvm.shufflevector"(%151, %39) <{mask = array<i32: 0, 8, 2, 10, 4, 12, 6, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %155 = "llvm.shufflevector"(%151, %47) <{mask = array<i32: 1, 9, 3, 11, 5, 13, 7, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %156 = "llvm.shufflevector"(%152, %154) <{mask = array<i32: 0, 1, 8, 4, 5, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %157 = "llvm.shufflevector"(%153, %155) <{mask = array<i32: 0, 1, 8, 4, 5, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %158 = "llvm.shufflevector"(%152, %154) <{mask = array<i32: 2, 3, 10, 6, 7, 14, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %159 = "llvm.shufflevector"(%153, %155) <{mask = array<i32: 2, 3, 10, 6, 7, 14, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %160 = "llvm.sub"(%157, %156) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %161 = "llvm.add"(%160, %55) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %162 = "llvm.sub"(%159, %158) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %163 = "llvm.add"(%162, %55) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %164 = "llvm.shufflevector"(%163, %161) <{mask = array<i32: 1, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<2xi64>
  %165 = "llvm.shufflevector"(%163, %161) <{mask = array<i32: 2, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<2xi64>
  %166 = "llvm.shufflevector"(%163, %161) <{mask = array<i32: 3, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<2xi64>
  %167 = "llvm.shufflevector"(%163, %161) <{mask = array<i32: 4, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<2xi64>
  %168 = "llvm.shufflevector"(%163, %161) <{mask = array<i32: 5, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<2xi64>
  %169 = "llvm.add"(%168, %11) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %170 = "llvm.and"(%169, %10) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %171 = "llvm.ashr"(%169, %9) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %172 = "llvm.mul"(%171, %8) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %173 = "llvm.shufflevector"(%163, %161) <{mask = array<i32: 0, 8>}> : (vector<8xi64>, vector<8xi64>) -> vector<2xi64>
  %174 = "llvm.add"(%172, %173) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %175 = "llvm.add"(%170, %7) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %176 = "llvm.ashr"(%174, %6) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %177 = "llvm.add"(%176, %164) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %178 = "llvm.ashr"(%177, %6) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %179 = "llvm.add"(%178, %165) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %180 = "llvm.ashr"(%179, %6) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %181 = "llvm.add"(%180, %166) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %182 = "llvm.ashr"(%181, %6) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %183 = "llvm.add"(%182, %167) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %184 = "llvm.and"(%174, %5) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %185 = "llvm.and"(%177, %5) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %186 = "llvm.and"(%179, %5) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %187 = "llvm.and"(%181, %5) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %188 = "llvm.ashr"(%183, %6) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %189 = "llvm.and"(%183, %5) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %190 = "llvm.add"(%184, %8) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %191 = "llvm.lshr"(%190, %6) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %192 = "llvm.and"(%190, %5) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %193 = "llvm.add"(%185, %191) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %194 = "llvm.lshr"(%193, %6) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %195 = "llvm.and"(%193, %5) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %196 = "llvm.add"(%186, %194) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %197 = "llvm.lshr"(%196, %6) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %198 = "llvm.and"(%196, %5) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %199 = "llvm.add"(%187, %197) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %200 = "llvm.lshr"(%199, %6) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %201 = "llvm.and"(%199, %5) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %202 = "llvm.add"(%189, %200) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %203 = "llvm.lshr"(%202, %6) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %204 = "llvm.and"(%202, %5) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %205 = "llvm.add"(%175, %188) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %206 = "llvm.add"(%205, %203) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %207 = "llvm.and"(%206, %10) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %208 = "llvm.icmp"(%206, %4) <{predicate = 6 : i64}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi1>
  %209 = "llvm.select"(%208, %3, %2) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<2xi1>, vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %210 = "llvm.add"(%209, %192) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %211 = "llvm.ashr"(%210, %6) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %212 = "llvm.add"(%211, %195) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %213 = "llvm.ashr"(%212, %6) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %214 = "llvm.add"(%213, %198) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %215 = "llvm.ashr"(%214, %6) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %216 = "llvm.add"(%215, %201) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %217 = "llvm.ashr"(%216, %6) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %218 = "llvm.add"(%217, %204) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %219 = "llvm.ashr"(%218, %6) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %220 = "llvm.add"(%219, %207) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %221 = "llvm.or"(%212, %210) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %222 = "llvm.or"(%221, %214) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %223 = "llvm.or"(%222, %216) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %224 = "llvm.or"(%223, %218) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %225 = "llvm.and"(%224, %5) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %226 = "llvm.or"(%225, %220) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %227 = "llvm.icmp"(%226, %2) <{predicate = 0 : i64}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi1>
  %228 = "llvm.extractelement"(%227, %23) : (vector<2xi1>, i64) -> i1
  %229 = "llvm.extractelement"(%227, %1) : (vector<2xi1>, i64) -> i1
  %230 = "llvm.select"(%228, %229, %0) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i1, i1) -> i1
  %231 = "llvm.zext"(%230) : (i1) -> i32
  "llvm.return"(%231) : (i32) -> ()
}) : () -> ()

end

end Firedancer.Lane.Mlir
