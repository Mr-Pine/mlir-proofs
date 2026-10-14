
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab



namespace Firedancer.Lane.Mlir

@[expose] public section

mlir_def fd_ed25519_point_dbln := "llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nofree, llvm.noundef, llvm.returned, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.noundef}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<ptr (ptr, ptr, i32)>, inline_hint, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], res_attrs = [{llvm.noundef}], sym_name = "fd_ed25519_point_dbln", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: i32):
  %0 = "llvm.mlir.constant"() <{value = 1 : i8}> : () -> i8
  %1 = "llvm.mlir.constant"() <{value = dense<[8796093022207, 8796093022207, 8796093022207, 8796093022207, 1099511627775, 1099511627775, 1099511627775, 1099511627775]> : vector<8xi64>}> : () -> vector<8xi64>
  %2 = "llvm.mlir.constant"() <{value = dense<1048576> : vector<8xi64>}> : () -> vector<8xi64>
  %3 = "llvm.mlir.constant"() <{value = dense<[159383552, 159383552, 159383552, 159383552, 1048576, 1048576, 1048576, 1048576]> : vector<8xi64>}> : () -> vector<8xi64>
  %4 = "llvm.mlir.constant"() <{value = dense<8796093022207> : vector<8xi64>}> : () -> vector<8xi64>
  %5 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %6 = "llvm.mlir.constant"() <{value = dense<[43, 43, 43, 43, 40, 40, 40, 40]> : vector<8xi64>}> : () -> vector<8xi64>
  %7 = "llvm.mlir.constant"() <{value = dense<43> : vector<8xi64>}> : () -> vector<8xi64>
  %8 = "llvm.mlir.constant"() <{value = dense<-1048576> : vector<8xi64>}> : () -> vector<8xi64>
  %9 = "llvm.mlir.constant"() <{value = dense<[-159383552, -159383552, -159383552, -159383552, -1048576, -1048576, -1048576, -1048576]> : vector<8xi64>}> : () -> vector<8xi64>
  %10 = "llvm.mlir.constant"() <{value = 1099511627775 : i64}> : () -> i64
  %11 = "llvm.mlir.constant"() <{value = 8796093022189 : i64}> : () -> i64
  %12 = "llvm.mlir.constant"() <{value = 8796093022207 : i64}> : () -> i64
  %13 = "llvm.mlir.constant"() <{value = dense<[0, 0, 1, 0, 0, 0, 1, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %14 = "llvm.mlir.constant"() <{value = dense<24> : vector<8xi64>}> : () -> vector<8xi64>
  %15 = "llvm.mlir.constant"() <{value = dense<7> : vector<8xi64>}> : () -> vector<8xi64>
  %16 = "llvm.mlir.constant"() <{value = dense<9> : vector<8xi64>}> : () -> vector<8xi64>
  %17 = "llvm.mlir.constant"() <{value = dense<0> : vector<8xi64>}> : () -> vector<8xi64>
  %18 = "llvm.mlir.constant"() <{value = dense<1> : vector<8xi64>}> : () -> vector<8xi64>
  %19 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %20 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %21 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %22 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %23 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %24 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %25 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %26 = "llvm.mlir.poison"() : () -> vector<8xi64>
  %27 = "llvm.mlir.poison"() : () -> i64
  %28 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %29 = "llvm.mlir.undef"() : () -> vector<8xi64>
  %30 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %31 = "llvm.insertelement"(%29, %28, %30) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %32 = "llvm.insertelement"(%31, %28, %25) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %33 = "llvm.insertelement"(%32, %28, %24) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %34 = "llvm.insertelement"(%33, %28, %23) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %35 = "llvm.insertelement"(%34, %27, %22) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %36 = "llvm.insertelement"(%35, %27, %21) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %37 = "llvm.insertelement"(%36, %27, %20) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %38 = "llvm.insertelement"(%37, %27, %19) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %39 = "llvm.insertelement"(%29, %27, %30) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %40 = "llvm.insertelement"(%39, %27, %25) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %41 = "llvm.insertelement"(%40, %27, %24) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %42 = "llvm.insertelement"(%41, %27, %23) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %43 = "llvm.insertelement"(%42, %28, %22) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %44 = "llvm.insertelement"(%43, %28, %21) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %45 = "llvm.insertelement"(%44, %28, %20) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %46 = "llvm.insertelement"(%45, %28, %19) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %47 = "llvm.insertelement"(%29, %27, %30) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %48 = "llvm.insertelement"(%47, %11, %25) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %49 = "llvm.insertelement"(%48, %11, %24) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %50 = "llvm.insertelement"(%49, %27, %23) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %51 = "llvm.insertelement"(%50, %27, %22) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %52 = "llvm.insertelement"(%51, %12, %21) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %53 = "llvm.insertelement"(%52, %12, %20) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %54 = "llvm.insertelement"(%53, %27, %19) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %55 = "llvm.insertelement"(%29, %27, %30) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %56 = "llvm.insertelement"(%55, %12, %25) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %57 = "llvm.insertelement"(%56, %12, %24) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %58 = "llvm.insertelement"(%57, %27, %23) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %59 = "llvm.insertelement"(%58, %27, %22) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %60 = "llvm.insertelement"(%59, %12, %21) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %61 = "llvm.insertelement"(%60, %12, %20) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %62 = "llvm.insertelement"(%61, %27, %19) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %63 = "llvm.insertelement"(%29, %27, %30) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %64 = "llvm.insertelement"(%63, %12, %25) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %65 = "llvm.insertelement"(%64, %12, %24) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %66 = "llvm.insertelement"(%65, %27, %23) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %67 = "llvm.insertelement"(%66, %27, %22) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %68 = "llvm.insertelement"(%67, %10, %21) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %69 = "llvm.insertelement"(%68, %10, %20) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %70 = "llvm.insertelement"(%69, %27, %19) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %71 = "llvm.insertelement"(%29, %11, %30) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %72 = "llvm.insertelement"(%71, %27, %25) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %73 = "llvm.insertelement"(%72, %27, %24) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %74 = "llvm.insertelement"(%73, %27, %23) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %75 = "llvm.insertelement"(%74, %12, %22) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %76 = "llvm.insertelement"(%75, %27, %21) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %77 = "llvm.insertelement"(%76, %27, %20) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %78 = "llvm.insertelement"(%77, %27, %19) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %79 = "llvm.insertelement"(%29, %12, %30) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %80 = "llvm.insertelement"(%79, %27, %25) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %81 = "llvm.insertelement"(%80, %27, %24) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %82 = "llvm.insertelement"(%81, %27, %23) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %83 = "llvm.insertelement"(%82, %12, %22) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %84 = "llvm.insertelement"(%83, %27, %21) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %85 = "llvm.insertelement"(%84, %27, %20) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %86 = "llvm.insertelement"(%85, %27, %19) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %87 = "llvm.insertelement"(%29, %12, %30) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %88 = "llvm.insertelement"(%87, %27, %25) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %89 = "llvm.insertelement"(%88, %27, %24) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %90 = "llvm.insertelement"(%89, %27, %23) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %91 = "llvm.insertelement"(%90, %10, %22) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %92 = "llvm.insertelement"(%91, %27, %21) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %93 = "llvm.insertelement"(%92, %27, %20) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %94 = "llvm.insertelement"(%93, %27, %19) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %95 = "llvm.insertelement"(%29, %27, %30) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %96 = "llvm.insertelement"(%95, %27, %25) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %97 = "llvm.insertelement"(%96, %27, %24) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %98 = "llvm.insertelement"(%97, %27, %23) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %99 = "llvm.insertelement"(%98, %5, %22) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %100 = "llvm.insertelement"(%99, %5, %21) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %101 = "llvm.insertelement"(%100, %5, %20) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %102 = "llvm.insertelement"(%101, %5, %19) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %103 = "llvm.load"(%arg1) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %104 = "llvm.shufflevector"(%103, %26) <{mask = array<i32: 1, 1, 2, 0, 5, 5, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %105 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %106 = "llvm.load"(%105) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %107 = "llvm.shufflevector"(%106, %26) <{mask = array<i32: 1, 1, 2, 0, 5, 5, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %108 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %109 = "llvm.load"(%108) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %110 = "llvm.shufflevector"(%109, %26) <{mask = array<i32: 1, 1, 2, 0, 5, 5, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %111 = "llvm.add"(%104, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %112 = "llvm.shufflevector"(%111, %104) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %113 = "llvm.add"(%107, %106) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %114 = "llvm.shufflevector"(%113, %107) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %115 = "llvm.add"(%110, %109) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %116 = "llvm.shufflevector"(%115, %110) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %117 = "llvm.shufflevector"(%112, %116) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %118 = "llvm.shufflevector"(%114, %116) <{mask = array<i32: 0, 1, 2, 3, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %119 = "llvm.shufflevector"(%112, %114) <{mask = array<i32: 4, 5, 6, 7, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %120 = "llvm.shufflevector"(%114, %26) <{mask = array<i32: 4, 5, 6, 7, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %121 = "llvm.shufflevector"(%116, %112) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %122 = "llvm.shufflevector"(%116, %26) <{mask = array<i32: 4, 5, 6, 7, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %123 = "llvm.shufflevector"(%114, %38) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %124 = "llvm.shl"(%112, %18) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %125 = "llvm.shl"(%114, %18) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %126 = "llvm.shl"(%117, %18) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %127 = "llvm.shl"(%118, %18) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %128 = "llvm.call_intrinsic"(%17, %117, %117) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %129 = "llvm.call_intrinsic"(%17, %126, %114) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %130 = "llvm.call_intrinsic"(%17, %114, %114) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %131 = "llvm.call_intrinsic"(%130, %124, %116) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %132 = "llvm.call_intrinsic"(%17, %124, %119) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %133 = "llvm.call_intrinsic"(%132, %127, %116) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %134 = "llvm.call_intrinsic"(%17, %121, %121) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %135 = "llvm.call_intrinsic"(%134, %126, %120) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %136 = "llvm.call_intrinsic"(%135, %127, %119) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %137 = "llvm.call_intrinsic"(%17, %124, %122) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %138 = "llvm.call_intrinsic"(%137, %125, %123) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %139 = "llvm.call_intrinsic"(%17, %117, %117) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %140 = "llvm.shl"(%139, %16) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %141 = "llvm.call_intrinsic"(%17, %126, %114) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %142 = "llvm.shl"(%141, %16) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %143 = "llvm.call_intrinsic"(%17, %114, %114) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %144 = "llvm.call_intrinsic"(%143, %124, %116) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %145 = "llvm.shl"(%144, %16) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %146 = "llvm.call_intrinsic"(%17, %124, %119) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %147 = "llvm.call_intrinsic"(%146, %127, %116) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %148 = "llvm.shl"(%147, %16) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %149 = "llvm.call_intrinsic"(%17, %121, %121) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %150 = "llvm.call_intrinsic"(%149, %126, %120) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %151 = "llvm.call_intrinsic"(%150, %127, %119) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %152 = "llvm.shl"(%151, %16) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %153 = "llvm.call_intrinsic"(%17, %124, %122) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %154 = "llvm.call_intrinsic"(%153, %125, %123) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %155 = "llvm.shl"(%154, %16) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %156 = "llvm.shufflevector"(%128, %133) <{mask = array<i32: 0, 1, 2, 3, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %157 = "llvm.shufflevector"(%38, %145) <{mask = array<i32: 0, 1, 2, 3, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %158 = "llvm.add"(%157, %156) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %159 = "llvm.shufflevector"(%129, %136) <{mask = array<i32: 0, 1, 2, 3, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %160 = "llvm.shufflevector"(%140, %148) <{mask = array<i32: 0, 1, 2, 3, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %161 = "llvm.add"(%160, %159) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %162 = "llvm.shufflevector"(%131, %138) <{mask = array<i32: 0, 1, 2, 3, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %163 = "llvm.shufflevector"(%142, %152) <{mask = array<i32: 0, 1, 2, 3, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %164 = "llvm.shufflevector"(%38, %138) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %165 = "llvm.shufflevector"(%136, %129) <{mask = array<i32: 4, 5, 6, 7, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %166 = "llvm.shufflevector"(%155, %145) <{mask = array<i32: 4, 5, 6, 7, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %167 = "llvm.add"(%166, %165) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %168 = "llvm.shufflevector"(%155, %46) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %169 = "llvm.add"(%167, %168) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %170 = "llvm.shufflevector"(%133, %128) <{mask = array<i32: 4, 5, 6, 7, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %171 = "llvm.shufflevector"(%152, %142) <{mask = array<i32: 4, 5, 6, 7, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %172 = "llvm.add"(%171, %170) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %173 = "llvm.shufflevector"(%131, %46) <{mask = array<i32: 4, 5, 6, 7, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %174 = "llvm.shufflevector"(%148, %140) <{mask = array<i32: 4, 5, 6, 7, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %175 = "llvm.add"(%174, %173) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %176 = "llvm.shl"(%169, %15) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %177 = "llvm.add"(%158, %176) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %178 = "llvm.mul"(%169, %14) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %179 = "llvm.add"(%177, %178) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %180 = "llvm.shl"(%172, %15) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %181 = "llvm.add"(%161, %180) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %182 = "llvm.mul"(%172, %14) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %183 = "llvm.add"(%181, %182) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %184 = "llvm.shl"(%175, %15) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %185 = "llvm.mul"(%175, %14) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %186 = "llvm.add"(%164, %162) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %187 = "llvm.add"(%186, %184) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %188 = "llvm.add"(%187, %185) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %189 = "llvm.add"(%188, %163) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %190 = "llvm.shl"(%179, %13) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %191 = "llvm.shl"(%183, %13) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %192 = "llvm.shl"(%189, %13) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %193 = "llvm.shufflevector"(%190, %26) <{mask = array<i32: 3, 3, 3, 3, 7, 7, 7, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %194 = "llvm.shufflevector"(%191, %26) <{mask = array<i32: 3, 3, 3, 3, 7, 7, 7, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %195 = "llvm.shufflevector"(%192, %26) <{mask = array<i32: 3, 3, 3, 3, 7, 7, 7, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %196 = "llvm.shufflevector"(%190, %26) <{mask = array<i32: 1, 1, 1, 1, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %197 = "llvm.shufflevector"(%191, %26) <{mask = array<i32: 1, 1, 1, 1, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %198 = "llvm.shufflevector"(%192, %26) <{mask = array<i32: 1, 1, 1, 1, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %199 = "llvm.add"(%193, %196) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %200 = "llvm.add"(%194, %197) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %201 = "llvm.add"(%195, %198) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %202 = "llvm.sub"(%193, %196) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %203 = "llvm.add"(%202, %54) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %204 = "llvm.shufflevector"(%199, %203) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %205 = "llvm.sub"(%194, %197) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %206 = "llvm.add"(%205, %62) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %207 = "llvm.shufflevector"(%200, %206) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %208 = "llvm.sub"(%195, %198) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %209 = "llvm.add"(%208, %70) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %210 = "llvm.shufflevector"(%201, %209) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %211 = "llvm.add"(%204, %190) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %212 = "llvm.shufflevector"(%204, %211) <{mask = array<i32: 0, 1, 10, 3, 4, 5, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %213 = "llvm.add"(%207, %191) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %214 = "llvm.shufflevector"(%207, %213) <{mask = array<i32: 0, 1, 10, 3, 4, 5, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %215 = "llvm.add"(%210, %192) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %216 = "llvm.shufflevector"(%210, %215) <{mask = array<i32: 0, 1, 10, 3, 4, 5, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %217 = "llvm.sub"(%212, %190) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %218 = "llvm.add"(%217, %78) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %219 = "llvm.shufflevector"(%218, %212) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %220 = "llvm.sub"(%214, %191) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %221 = "llvm.add"(%220, %86) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %222 = "llvm.shufflevector"(%221, %214) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %223 = "llvm.sub"(%216, %192) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %224 = "llvm.add"(%223, %94) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %225 = "llvm.shufflevector"(%224, %216) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %226 = "llvm.add"(%219, %9) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %227 = "llvm.add"(%222, %8) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %228 = "llvm.add"(%225, %8) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %229 = "llvm.ashr"(%226, %7) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %230 = "llvm.ashr"(%227, %7) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %231 = "llvm.ashr"(%228, %6) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %232 = "llvm.mul"(%231, %102) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %233 = "llvm.and"(%226, %4) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %234 = "llvm.shufflevector"(%232, %231) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %235 = "llvm.add"(%234, %3) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %236 = "llvm.add"(%235, %233) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %237 = "llvm.and"(%227, %4) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %238 = "llvm.add"(%237, %2) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %239 = "llvm.add"(%238, %229) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %240 = "llvm.and"(%228, %1) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %241 = "llvm.add"(%240, %2) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %242 = "llvm.add"(%241, %230) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %243 = "llvm.shufflevector"(%236, %26) <{mask = array<i32: 2, 3, 2, 3, 6, 7, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %244 = "llvm.shufflevector"(%239, %26) <{mask = array<i32: 2, 3, 2, 3, 6, 7, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %245 = "llvm.shufflevector"(%242, %26) <{mask = array<i32: 2, 3, 2, 3, 6, 7, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %246 = "llvm.shufflevector"(%236, %26) <{mask = array<i32: 0, 1, 1, 0, 0, 1, 1, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %247 = "llvm.shufflevector"(%239, %26) <{mask = array<i32: 0, 1, 1, 0, 0, 1, 1, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %248 = "llvm.shufflevector"(%242, %26) <{mask = array<i32: 0, 1, 1, 0, 0, 1, 1, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %249 = "llvm.shufflevector"(%236, %26) <{mask = array<i32: 4, 5, 5, 4, 4, 5, 5, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %250 = "llvm.shufflevector"(%239, %26) <{mask = array<i32: 4, 5, 5, 4, 4, 5, 5, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %251 = "llvm.shufflevector"(%242, %26) <{mask = array<i32: 4, 5, 5, 4, 4, 5, 5, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %252 = "llvm.call_intrinsic"(%17, %246, %243) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %253 = "llvm.call_intrinsic"(%17, %247, %243) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %254 = "llvm.call_intrinsic"(%253, %246, %244) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %255 = "llvm.call_intrinsic"(%17, %248, %243) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %256 = "llvm.call_intrinsic"(%255, %247, %244) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %257 = "llvm.call_intrinsic"(%256, %246, %245) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %258 = "llvm.call_intrinsic"(%17, %249, %243) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %259 = "llvm.call_intrinsic"(%258, %248, %244) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %260 = "llvm.call_intrinsic"(%259, %247, %245) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %261 = "llvm.call_intrinsic"(%17, %250, %243) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %262 = "llvm.call_intrinsic"(%261, %249, %244) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %263 = "llvm.call_intrinsic"(%262, %248, %245) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %264 = "llvm.call_intrinsic"(%17, %251, %243) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %265 = "llvm.call_intrinsic"(%264, %250, %244) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %266 = "llvm.call_intrinsic"(%265, %249, %245) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %267 = "llvm.call_intrinsic"(%17, %251, %244) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %268 = "llvm.call_intrinsic"(%267, %250, %245) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %269 = "llvm.call_intrinsic"(%17, %246, %243) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %270 = "llvm.shl"(%269, %16) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %271 = "llvm.add"(%270, %254) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %272 = "llvm.call_intrinsic"(%17, %247, %243) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %273 = "llvm.call_intrinsic"(%272, %246, %244) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %274 = "llvm.shl"(%273, %16) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %275 = "llvm.add"(%274, %257) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %276 = "llvm.call_intrinsic"(%17, %248, %243) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %277 = "llvm.call_intrinsic"(%276, %247, %244) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %278 = "llvm.call_intrinsic"(%277, %246, %245) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %279 = "llvm.shl"(%278, %16) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %280 = "llvm.add"(%279, %260) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %281 = "llvm.call_intrinsic"(%17, %249, %243) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %282 = "llvm.call_intrinsic"(%281, %248, %244) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %283 = "llvm.call_intrinsic"(%282, %247, %245) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %284 = "llvm.shl"(%283, %16) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %285 = "llvm.add"(%284, %263) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %286 = "llvm.call_intrinsic"(%17, %250, %243) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %287 = "llvm.call_intrinsic"(%286, %249, %244) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %288 = "llvm.call_intrinsic"(%287, %248, %245) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %289 = "llvm.shl"(%288, %16) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %290 = "llvm.add"(%289, %266) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %291 = "llvm.call_intrinsic"(%17, %251, %243) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %292 = "llvm.call_intrinsic"(%291, %250, %244) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %293 = "llvm.call_intrinsic"(%292, %249, %245) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %294 = "llvm.shl"(%293, %16) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %295 = "llvm.add"(%294, %268) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %296 = "llvm.call_intrinsic"(%17, %251, %244) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %297 = "llvm.call_intrinsic"(%296, %250, %245) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %298 = "llvm.shl"(%297, %16) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %299 = "llvm.call_intrinsic"(%298, %251, %245) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %300 = "llvm.call_intrinsic"(%17, %251, %245) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %301 = "llvm.shl"(%300, %16) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %302 = "llvm.shufflevector"(%280, %26) <{mask = array<i32: 4, 5, 6, 7, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %303 = "llvm.shufflevector"(%285, %26) <{mask = array<i32: 4, 5, 6, 7, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %304 = "llvm.shufflevector"(%290, %26) <{mask = array<i32: 4, 5, 6, 7, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %305 = "llvm.add"(%302, %252) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %306 = "llvm.shufflevector"(%252, %305) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %307 = "llvm.add"(%303, %271) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %308 = "llvm.shufflevector"(%271, %307) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %309 = "llvm.add"(%304, %275) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %310 = "llvm.shufflevector"(%275, %309) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %311 = "llvm.add"(%295, %302) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %312 = "llvm.shufflevector"(%311, %295) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %313 = "llvm.add"(%299, %303) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %314 = "llvm.shufflevector"(%313, %299) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %315 = "llvm.add"(%301, %304) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %316 = "llvm.shufflevector"(%315, %301) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %317 = "llvm.shl"(%312, %15) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %318 = "llvm.add"(%317, %306) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %319 = "llvm.mul"(%312, %14) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %320 = "llvm.add"(%318, %319) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %321 = "llvm.shl"(%314, %15) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %322 = "llvm.add"(%321, %308) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %323 = "llvm.mul"(%314, %14) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %324 = "llvm.add"(%322, %323) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %325 = "llvm.shl"(%316, %15) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %326 = "llvm.add"(%325, %310) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %327 = "llvm.mul"(%316, %14) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %328 = "llvm.add"(%326, %327) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %329 = "llvm.lshr"(%320, %7) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %330 = "llvm.lshr"(%324, %7) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %331 = "llvm.lshr"(%328, %6) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %332 = "llvm.mul"(%331, %102) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %333 = "llvm.and"(%320, %4) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %334 = "llvm.shufflevector"(%332, %331) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %335 = "llvm.add"(%334, %333) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%335, %arg0) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %336 = "llvm.and"(%324, %4) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %337 = "llvm.add"(%336, %329) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %338 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%337, %338) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %339 = "llvm.and"(%328, %1) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %340 = "llvm.add"(%339, %330) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %341 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%340, %341) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %342 = "llvm.icmp"(%arg2, %25) <{predicate = 4 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%342, %340, %337, %335, %0)[^bb3, ^bb2] <{operandSegmentSizes = array<i32: 1, 4, 0>}> : (i1, vector<8xi64>, vector<8xi64>, vector<8xi64>, i8) -> ()
^bb1:  // pred: ^bb3
  "llvm.store"(%574, %arg0) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%576, %338) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%578, %341) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.br"()[^bb2] : () -> ()
^bb2:  // 2 preds: ^bb0, ^bb1
  "llvm.return"(%arg0) : (!llvm.ptr) -> ()
^bb3(%343: vector<8xi64>, %344: vector<8xi64>, %345: vector<8xi64>, %346: i8):  // 2 preds: ^bb0, ^bb3
  %347 = "llvm.shufflevector"(%345, %26) <{mask = array<i32: 1, 1, 2, 0, 5, 5, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %348 = "llvm.shufflevector"(%344, %26) <{mask = array<i32: 1, 1, 2, 0, 5, 5, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %349 = "llvm.shufflevector"(%343, %26) <{mask = array<i32: 1, 1, 2, 0, 5, 5, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %350 = "llvm.add"(%347, %345) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %351 = "llvm.shufflevector"(%350, %347) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %352 = "llvm.add"(%348, %344) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %353 = "llvm.shufflevector"(%352, %348) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %354 = "llvm.add"(%349, %343) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %355 = "llvm.shufflevector"(%354, %349) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %356 = "llvm.shufflevector"(%351, %355) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %357 = "llvm.shufflevector"(%353, %355) <{mask = array<i32: 0, 1, 2, 3, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %358 = "llvm.shufflevector"(%351, %353) <{mask = array<i32: 4, 5, 6, 7, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %359 = "llvm.shufflevector"(%353, %26) <{mask = array<i32: 4, 5, 6, 7, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %360 = "llvm.shufflevector"(%355, %351) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %361 = "llvm.shufflevector"(%355, %26) <{mask = array<i32: 4, 5, 6, 7, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %362 = "llvm.shufflevector"(%353, %38) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %363 = "llvm.shl"(%351, %18) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %364 = "llvm.shl"(%353, %18) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %365 = "llvm.shl"(%356, %18) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %366 = "llvm.shl"(%357, %18) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %367 = "llvm.call_intrinsic"(%17, %356, %356) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %368 = "llvm.call_intrinsic"(%17, %365, %353) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %369 = "llvm.call_intrinsic"(%17, %353, %353) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %370 = "llvm.call_intrinsic"(%369, %363, %355) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %371 = "llvm.call_intrinsic"(%17, %363, %358) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %372 = "llvm.call_intrinsic"(%371, %366, %355) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %373 = "llvm.call_intrinsic"(%17, %360, %360) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %374 = "llvm.call_intrinsic"(%373, %365, %359) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %375 = "llvm.call_intrinsic"(%374, %366, %358) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %376 = "llvm.call_intrinsic"(%17, %363, %361) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %377 = "llvm.call_intrinsic"(%376, %364, %362) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %378 = "llvm.call_intrinsic"(%17, %356, %356) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %379 = "llvm.shl"(%378, %16) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %380 = "llvm.call_intrinsic"(%17, %365, %353) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %381 = "llvm.shl"(%380, %16) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %382 = "llvm.call_intrinsic"(%17, %353, %353) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %383 = "llvm.call_intrinsic"(%382, %363, %355) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %384 = "llvm.shl"(%383, %16) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %385 = "llvm.call_intrinsic"(%17, %363, %358) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %386 = "llvm.call_intrinsic"(%385, %366, %355) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %387 = "llvm.shl"(%386, %16) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %388 = "llvm.call_intrinsic"(%17, %360, %360) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %389 = "llvm.call_intrinsic"(%388, %365, %359) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %390 = "llvm.call_intrinsic"(%389, %366, %358) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %391 = "llvm.shl"(%390, %16) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %392 = "llvm.call_intrinsic"(%17, %363, %361) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %393 = "llvm.call_intrinsic"(%392, %364, %362) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %394 = "llvm.shl"(%393, %16) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %395 = "llvm.shufflevector"(%367, %372) <{mask = array<i32: 0, 1, 2, 3, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %396 = "llvm.shufflevector"(%38, %384) <{mask = array<i32: 0, 1, 2, 3, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %397 = "llvm.add"(%396, %395) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %398 = "llvm.shufflevector"(%368, %375) <{mask = array<i32: 0, 1, 2, 3, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %399 = "llvm.shufflevector"(%379, %387) <{mask = array<i32: 0, 1, 2, 3, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %400 = "llvm.add"(%399, %398) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %401 = "llvm.shufflevector"(%370, %377) <{mask = array<i32: 0, 1, 2, 3, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %402 = "llvm.shufflevector"(%381, %391) <{mask = array<i32: 0, 1, 2, 3, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %403 = "llvm.shufflevector"(%38, %377) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %404 = "llvm.shufflevector"(%375, %368) <{mask = array<i32: 4, 5, 6, 7, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %405 = "llvm.shufflevector"(%394, %384) <{mask = array<i32: 4, 5, 6, 7, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %406 = "llvm.add"(%405, %404) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %407 = "llvm.shufflevector"(%394, %46) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %408 = "llvm.add"(%406, %407) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %409 = "llvm.shufflevector"(%372, %367) <{mask = array<i32: 4, 5, 6, 7, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %410 = "llvm.shufflevector"(%391, %381) <{mask = array<i32: 4, 5, 6, 7, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %411 = "llvm.add"(%410, %409) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %412 = "llvm.shufflevector"(%370, %46) <{mask = array<i32: 4, 5, 6, 7, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %413 = "llvm.shufflevector"(%387, %379) <{mask = array<i32: 4, 5, 6, 7, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %414 = "llvm.add"(%413, %412) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %415 = "llvm.shl"(%408, %15) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %416 = "llvm.add"(%397, %415) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %417 = "llvm.mul"(%408, %14) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %418 = "llvm.add"(%416, %417) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %419 = "llvm.shl"(%411, %15) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %420 = "llvm.add"(%400, %419) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %421 = "llvm.mul"(%411, %14) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %422 = "llvm.add"(%420, %421) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %423 = "llvm.shl"(%414, %15) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %424 = "llvm.mul"(%414, %14) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %425 = "llvm.add"(%403, %401) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %426 = "llvm.add"(%425, %423) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %427 = "llvm.add"(%426, %424) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %428 = "llvm.add"(%427, %402) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %429 = "llvm.shl"(%418, %13) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %430 = "llvm.shl"(%422, %13) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %431 = "llvm.shl"(%428, %13) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %432 = "llvm.shufflevector"(%429, %26) <{mask = array<i32: 3, 3, 3, 3, 7, 7, 7, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %433 = "llvm.shufflevector"(%430, %26) <{mask = array<i32: 3, 3, 3, 3, 7, 7, 7, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %434 = "llvm.shufflevector"(%431, %26) <{mask = array<i32: 3, 3, 3, 3, 7, 7, 7, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %435 = "llvm.shufflevector"(%429, %26) <{mask = array<i32: 1, 1, 1, 1, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %436 = "llvm.shufflevector"(%430, %26) <{mask = array<i32: 1, 1, 1, 1, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %437 = "llvm.shufflevector"(%431, %26) <{mask = array<i32: 1, 1, 1, 1, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %438 = "llvm.add"(%432, %435) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %439 = "llvm.add"(%433, %436) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %440 = "llvm.add"(%434, %437) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %441 = "llvm.sub"(%432, %435) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %442 = "llvm.add"(%441, %54) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %443 = "llvm.shufflevector"(%438, %442) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %444 = "llvm.sub"(%433, %436) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %445 = "llvm.add"(%444, %62) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %446 = "llvm.shufflevector"(%439, %445) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %447 = "llvm.sub"(%434, %437) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %448 = "llvm.add"(%447, %70) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %449 = "llvm.shufflevector"(%440, %448) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %450 = "llvm.add"(%443, %429) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %451 = "llvm.shufflevector"(%443, %450) <{mask = array<i32: 0, 1, 10, 3, 4, 5, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %452 = "llvm.add"(%446, %430) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %453 = "llvm.shufflevector"(%446, %452) <{mask = array<i32: 0, 1, 10, 3, 4, 5, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %454 = "llvm.add"(%449, %431) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %455 = "llvm.shufflevector"(%449, %454) <{mask = array<i32: 0, 1, 10, 3, 4, 5, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %456 = "llvm.sub"(%451, %429) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %457 = "llvm.add"(%456, %78) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %458 = "llvm.shufflevector"(%457, %451) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %459 = "llvm.sub"(%453, %430) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %460 = "llvm.add"(%459, %86) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %461 = "llvm.shufflevector"(%460, %453) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %462 = "llvm.sub"(%455, %431) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %463 = "llvm.add"(%462, %94) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %464 = "llvm.shufflevector"(%463, %455) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %465 = "llvm.add"(%458, %9) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %466 = "llvm.add"(%461, %8) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %467 = "llvm.add"(%464, %8) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %468 = "llvm.ashr"(%465, %7) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %469 = "llvm.ashr"(%466, %7) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %470 = "llvm.ashr"(%467, %6) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %471 = "llvm.mul"(%470, %102) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %472 = "llvm.and"(%465, %4) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %473 = "llvm.shufflevector"(%471, %470) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %474 = "llvm.add"(%473, %3) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %475 = "llvm.add"(%474, %472) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %476 = "llvm.and"(%466, %4) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %477 = "llvm.add"(%476, %2) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %478 = "llvm.add"(%477, %468) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %479 = "llvm.and"(%467, %1) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %480 = "llvm.add"(%479, %2) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %481 = "llvm.add"(%480, %469) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %482 = "llvm.shufflevector"(%475, %26) <{mask = array<i32: 2, 3, 2, 3, 6, 7, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %483 = "llvm.shufflevector"(%478, %26) <{mask = array<i32: 2, 3, 2, 3, 6, 7, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %484 = "llvm.shufflevector"(%481, %26) <{mask = array<i32: 2, 3, 2, 3, 6, 7, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %485 = "llvm.shufflevector"(%475, %26) <{mask = array<i32: 0, 1, 1, 0, 0, 1, 1, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %486 = "llvm.shufflevector"(%478, %26) <{mask = array<i32: 0, 1, 1, 0, 0, 1, 1, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %487 = "llvm.shufflevector"(%481, %26) <{mask = array<i32: 0, 1, 1, 0, 0, 1, 1, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %488 = "llvm.shufflevector"(%475, %26) <{mask = array<i32: 4, 5, 5, 4, 4, 5, 5, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %489 = "llvm.shufflevector"(%478, %26) <{mask = array<i32: 4, 5, 5, 4, 4, 5, 5, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %490 = "llvm.shufflevector"(%481, %26) <{mask = array<i32: 4, 5, 5, 4, 4, 5, 5, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %491 = "llvm.call_intrinsic"(%17, %485, %482) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %492 = "llvm.call_intrinsic"(%17, %486, %482) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %493 = "llvm.call_intrinsic"(%492, %485, %483) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %494 = "llvm.call_intrinsic"(%17, %487, %482) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %495 = "llvm.call_intrinsic"(%494, %486, %483) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %496 = "llvm.call_intrinsic"(%495, %485, %484) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %497 = "llvm.call_intrinsic"(%17, %488, %482) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %498 = "llvm.call_intrinsic"(%497, %487, %483) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %499 = "llvm.call_intrinsic"(%498, %486, %484) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %500 = "llvm.call_intrinsic"(%17, %489, %482) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %501 = "llvm.call_intrinsic"(%500, %488, %483) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %502 = "llvm.call_intrinsic"(%501, %487, %484) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %503 = "llvm.call_intrinsic"(%17, %490, %482) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %504 = "llvm.call_intrinsic"(%503, %489, %483) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %505 = "llvm.call_intrinsic"(%504, %488, %484) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %506 = "llvm.call_intrinsic"(%17, %490, %483) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %507 = "llvm.call_intrinsic"(%506, %489, %484) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %508 = "llvm.call_intrinsic"(%17, %485, %482) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %509 = "llvm.shl"(%508, %16) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %510 = "llvm.add"(%509, %493) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %511 = "llvm.call_intrinsic"(%17, %486, %482) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %512 = "llvm.call_intrinsic"(%511, %485, %483) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %513 = "llvm.shl"(%512, %16) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %514 = "llvm.add"(%513, %496) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %515 = "llvm.call_intrinsic"(%17, %487, %482) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %516 = "llvm.call_intrinsic"(%515, %486, %483) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %517 = "llvm.call_intrinsic"(%516, %485, %484) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %518 = "llvm.shl"(%517, %16) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %519 = "llvm.add"(%518, %499) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %520 = "llvm.call_intrinsic"(%17, %488, %482) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %521 = "llvm.call_intrinsic"(%520, %487, %483) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %522 = "llvm.call_intrinsic"(%521, %486, %484) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %523 = "llvm.shl"(%522, %16) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %524 = "llvm.add"(%523, %502) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %525 = "llvm.call_intrinsic"(%17, %489, %482) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %526 = "llvm.call_intrinsic"(%525, %488, %483) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %527 = "llvm.call_intrinsic"(%526, %487, %484) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %528 = "llvm.shl"(%527, %16) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %529 = "llvm.add"(%528, %505) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %530 = "llvm.call_intrinsic"(%17, %490, %482) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %531 = "llvm.call_intrinsic"(%530, %489, %483) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %532 = "llvm.call_intrinsic"(%531, %488, %484) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %533 = "llvm.shl"(%532, %16) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %534 = "llvm.add"(%533, %507) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %535 = "llvm.call_intrinsic"(%17, %490, %483) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %536 = "llvm.call_intrinsic"(%535, %489, %484) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %537 = "llvm.shl"(%536, %16) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %538 = "llvm.call_intrinsic"(%537, %490, %484) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %539 = "llvm.call_intrinsic"(%17, %490, %484) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %540 = "llvm.shl"(%539, %16) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %541 = "llvm.shufflevector"(%519, %26) <{mask = array<i32: 4, 5, 6, 7, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %542 = "llvm.shufflevector"(%524, %26) <{mask = array<i32: 4, 5, 6, 7, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %543 = "llvm.shufflevector"(%529, %26) <{mask = array<i32: 4, 5, 6, 7, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %544 = "llvm.add"(%541, %491) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %545 = "llvm.shufflevector"(%491, %544) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %546 = "llvm.add"(%542, %510) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %547 = "llvm.shufflevector"(%510, %546) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %548 = "llvm.add"(%543, %514) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %549 = "llvm.shufflevector"(%514, %548) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %550 = "llvm.add"(%534, %541) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %551 = "llvm.shufflevector"(%550, %534) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %552 = "llvm.add"(%538, %542) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %553 = "llvm.shufflevector"(%552, %538) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %554 = "llvm.add"(%540, %543) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %555 = "llvm.shufflevector"(%554, %540) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %556 = "llvm.shl"(%551, %15) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %557 = "llvm.add"(%556, %545) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %558 = "llvm.mul"(%551, %14) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %559 = "llvm.add"(%557, %558) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %560 = "llvm.shl"(%553, %15) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %561 = "llvm.add"(%560, %547) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %562 = "llvm.mul"(%553, %14) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %563 = "llvm.add"(%561, %562) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %564 = "llvm.shl"(%555, %15) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %565 = "llvm.add"(%564, %549) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %566 = "llvm.mul"(%555, %14) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %567 = "llvm.add"(%565, %566) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %568 = "llvm.lshr"(%559, %7) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %569 = "llvm.lshr"(%563, %7) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %570 = "llvm.lshr"(%567, %6) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %571 = "llvm.mul"(%570, %102) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %572 = "llvm.and"(%559, %4) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %573 = "llvm.shufflevector"(%571, %570) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %574 = "llvm.add"(%573, %572) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %575 = "llvm.and"(%563, %4) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %576 = "llvm.add"(%575, %568) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %577 = "llvm.and"(%567, %1) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %578 = "llvm.add"(%577, %569) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %579 = "llvm.add"(%346, %0) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  %580 = "llvm.zext"(%579) : (i8) -> i32
  %581 = "llvm.icmp"(%arg2, %580) <{predicate = 8 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%581, %578, %576, %574, %579)[^bb3, ^bb1] <{loop_annotation = #llvm.loop_annotation<mustProgress = true>, operandSegmentSizes = array<i32: 1, 4, 0>}> : (i1, vector<8xi64>, vector<8xi64>, vector<8xi64>, i8) -> ()
}) : () -> ()

end

end Firedancer.Lane.Mlir
