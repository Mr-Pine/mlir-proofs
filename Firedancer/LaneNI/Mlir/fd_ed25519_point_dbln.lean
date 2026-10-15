
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.LaneNI.Mlir.fd_r43x6_quad_sqr_fast
public import Firedancer.LaneNI.Mlir.fd_r43x6_quad_mul_fast
public import Firedancer.LaneNI.Mlir.fd_r43x6_quad_sqr_fast
public import Firedancer.LaneNI.Mlir.fd_r43x6_quad_mul_fast

namespace Firedancer.LaneNI.Mlir

@[expose] public section

mlir_def fd_ed25519_point_dbln := "llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nofree, llvm.noundef, llvm.returned, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.noundef}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<ptr (ptr, ptr, i32)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], res_attrs = [{llvm.noundef}], sym_name = "fd_ed25519_point_dbln", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
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
  %11 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %12 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %13 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %14 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %15 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %16 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %17 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %18 = "llvm.mlir.poison"() : () -> vector<8xi64>
  %19 = "llvm.mlir.constant"() <{value = dense<[0, 0, 1, 0, 0, 0, 1, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %20 = "llvm.mlir.poison"() : () -> i64
  %21 = "llvm.mlir.constant"() <{value = 8796093022207 : i64}> : () -> i64
  %22 = "llvm.mlir.constant"() <{value = 8796093022189 : i64}> : () -> i64
  %23 = "llvm.mlir.undef"() : () -> vector<8xi64>
  %24 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %25 = "llvm.insertelement"(%23, %20, %24) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %26 = "llvm.insertelement"(%25, %22, %17) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %27 = "llvm.insertelement"(%26, %22, %16) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %28 = "llvm.insertelement"(%27, %20, %15) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %29 = "llvm.insertelement"(%28, %20, %14) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %30 = "llvm.insertelement"(%29, %21, %13) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %31 = "llvm.insertelement"(%30, %21, %12) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %32 = "llvm.insertelement"(%31, %20, %11) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %33 = "llvm.insertelement"(%23, %20, %24) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %34 = "llvm.insertelement"(%33, %21, %17) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %35 = "llvm.insertelement"(%34, %21, %16) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %36 = "llvm.insertelement"(%35, %20, %15) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %37 = "llvm.insertelement"(%36, %20, %14) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %38 = "llvm.insertelement"(%37, %21, %13) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %39 = "llvm.insertelement"(%38, %21, %12) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %40 = "llvm.insertelement"(%39, %20, %11) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %41 = "llvm.insertelement"(%23, %20, %24) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %42 = "llvm.insertelement"(%41, %21, %17) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %43 = "llvm.insertelement"(%42, %21, %16) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %44 = "llvm.insertelement"(%43, %20, %15) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %45 = "llvm.insertelement"(%44, %20, %14) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %46 = "llvm.insertelement"(%45, %10, %13) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %47 = "llvm.insertelement"(%46, %10, %12) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %48 = "llvm.insertelement"(%47, %20, %11) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %49 = "llvm.insertelement"(%23, %22, %24) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %50 = "llvm.insertelement"(%49, %20, %17) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %51 = "llvm.insertelement"(%50, %20, %16) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %52 = "llvm.insertelement"(%51, %20, %15) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %53 = "llvm.insertelement"(%52, %21, %14) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %54 = "llvm.insertelement"(%53, %20, %13) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %55 = "llvm.insertelement"(%54, %20, %12) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %56 = "llvm.insertelement"(%55, %20, %11) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %57 = "llvm.insertelement"(%23, %21, %24) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %58 = "llvm.insertelement"(%57, %20, %17) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %59 = "llvm.insertelement"(%58, %20, %16) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %60 = "llvm.insertelement"(%59, %20, %15) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %61 = "llvm.insertelement"(%60, %21, %14) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %62 = "llvm.insertelement"(%61, %20, %13) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %63 = "llvm.insertelement"(%62, %20, %12) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %64 = "llvm.insertelement"(%63, %20, %11) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %65 = "llvm.insertelement"(%23, %21, %24) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %66 = "llvm.insertelement"(%65, %20, %17) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %67 = "llvm.insertelement"(%66, %20, %16) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %68 = "llvm.insertelement"(%67, %20, %15) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %69 = "llvm.insertelement"(%68, %10, %14) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %70 = "llvm.insertelement"(%69, %20, %13) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %71 = "llvm.insertelement"(%70, %20, %12) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %72 = "llvm.insertelement"(%71, %20, %11) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %73 = "llvm.insertelement"(%23, %20, %24) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %74 = "llvm.insertelement"(%73, %20, %17) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %75 = "llvm.insertelement"(%74, %20, %16) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %76 = "llvm.insertelement"(%75, %20, %15) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %77 = "llvm.insertelement"(%76, %5, %14) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %78 = "llvm.insertelement"(%77, %5, %13) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %79 = "llvm.insertelement"(%78, %5, %12) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %80 = "llvm.insertelement"(%79, %5, %11) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %81 = "llvm.alloca"(%17) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %82 = "llvm.alloca"(%17) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %83 = "llvm.alloca"(%17) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %84 = "llvm.alloca"(%17) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %85 = "llvm.alloca"(%17) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %86 = "llvm.alloca"(%17) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %87 = "llvm.alloca"(%17) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %88 = "llvm.alloca"(%17) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %89 = "llvm.alloca"(%17) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %90 = "llvm.alloca"(%17) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %91 = "llvm.alloca"(%17) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %92 = "llvm.alloca"(%17) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %93 = "llvm.load"(%arg1) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %94 = "llvm.shufflevector"(%93, %18) <{mask = array<i32: 1, 1, 2, 0, 5, 5, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %95 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %96 = "llvm.load"(%95) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %97 = "llvm.shufflevector"(%96, %18) <{mask = array<i32: 1, 1, 2, 0, 5, 5, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %98 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %99 = "llvm.load"(%98) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %100 = "llvm.shufflevector"(%99, %18) <{mask = array<i32: 1, 1, 2, 0, 5, 5, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %101 = "llvm.add"(%94, %93) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %102 = "llvm.shufflevector"(%101, %94) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %103 = "llvm.add"(%97, %96) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %104 = "llvm.shufflevector"(%103, %97) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %105 = "llvm.add"(%100, %99) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %106 = "llvm.shufflevector"(%105, %100) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.intr.lifetime.start"(%81) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%82) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%83) : (!llvm.ptr) -> ()
  "llvm.call"(%81, %82, %83, %102, %104, %106) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_quad_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 6, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
  %107 = "llvm.load"(%81) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %108 = "llvm.load"(%82) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %109 = "llvm.load"(%83) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.intr.lifetime.end"(%83) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%82) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%81) : (!llvm.ptr) -> ()
  %110 = "llvm.shl"(%107, %19) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %111 = "llvm.shl"(%108, %19) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %112 = "llvm.shl"(%109, %19) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %113 = "llvm.shufflevector"(%110, %18) <{mask = array<i32: 3, 3, 3, 3, 7, 7, 7, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %114 = "llvm.shufflevector"(%111, %18) <{mask = array<i32: 3, 3, 3, 3, 7, 7, 7, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %115 = "llvm.shufflevector"(%112, %18) <{mask = array<i32: 3, 3, 3, 3, 7, 7, 7, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %116 = "llvm.shufflevector"(%110, %18) <{mask = array<i32: 1, 1, 1, 1, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %117 = "llvm.shufflevector"(%111, %18) <{mask = array<i32: 1, 1, 1, 1, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %118 = "llvm.shufflevector"(%112, %18) <{mask = array<i32: 1, 1, 1, 1, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %119 = "llvm.add"(%113, %116) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %120 = "llvm.add"(%114, %117) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %121 = "llvm.add"(%115, %118) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %122 = "llvm.sub"(%113, %116) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %123 = "llvm.add"(%122, %32) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %124 = "llvm.shufflevector"(%119, %123) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %125 = "llvm.sub"(%114, %117) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %126 = "llvm.add"(%125, %40) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %127 = "llvm.shufflevector"(%120, %126) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %128 = "llvm.sub"(%115, %118) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %129 = "llvm.add"(%128, %48) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %130 = "llvm.shufflevector"(%121, %129) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %131 = "llvm.add"(%124, %110) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %132 = "llvm.shufflevector"(%124, %131) <{mask = array<i32: 0, 1, 10, 3, 4, 5, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %133 = "llvm.add"(%127, %111) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %134 = "llvm.shufflevector"(%127, %133) <{mask = array<i32: 0, 1, 10, 3, 4, 5, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %135 = "llvm.add"(%130, %112) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %136 = "llvm.shufflevector"(%130, %135) <{mask = array<i32: 0, 1, 10, 3, 4, 5, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %137 = "llvm.sub"(%132, %110) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %138 = "llvm.add"(%137, %56) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %139 = "llvm.shufflevector"(%138, %132) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %140 = "llvm.sub"(%134, %111) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %141 = "llvm.add"(%140, %64) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %142 = "llvm.shufflevector"(%141, %134) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %143 = "llvm.sub"(%136, %112) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %144 = "llvm.add"(%143, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %145 = "llvm.shufflevector"(%144, %136) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %146 = "llvm.add"(%139, %9) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %147 = "llvm.add"(%142, %8) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %148 = "llvm.add"(%145, %8) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %149 = "llvm.ashr"(%146, %7) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %150 = "llvm.ashr"(%147, %7) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %151 = "llvm.ashr"(%148, %6) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %152 = "llvm.mul"(%151, %80) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %153 = "llvm.and"(%146, %4) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %154 = "llvm.shufflevector"(%152, %151) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %155 = "llvm.add"(%153, %3) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %156 = "llvm.add"(%155, %154) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %157 = "llvm.and"(%147, %4) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %158 = "llvm.add"(%149, %2) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %159 = "llvm.add"(%158, %157) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %160 = "llvm.and"(%148, %1) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %161 = "llvm.add"(%150, %2) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %162 = "llvm.add"(%161, %160) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %163 = "llvm.shufflevector"(%156, %18) <{mask = array<i32: 0, 1, 1, 0, 4, 5, 5, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %164 = "llvm.shufflevector"(%159, %18) <{mask = array<i32: 0, 1, 1, 0, 4, 5, 5, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %165 = "llvm.shufflevector"(%162, %18) <{mask = array<i32: 0, 1, 1, 0, 4, 5, 5, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %166 = "llvm.shufflevector"(%156, %18) <{mask = array<i32: 2, 3, 2, 3, 6, 7, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %167 = "llvm.shufflevector"(%159, %18) <{mask = array<i32: 2, 3, 2, 3, 6, 7, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %168 = "llvm.shufflevector"(%162, %18) <{mask = array<i32: 2, 3, 2, 3, 6, 7, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.intr.lifetime.start"(%84) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%85) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%86) : (!llvm.ptr) -> ()
  "llvm.call"(%84, %85, %86, %163, %164, %165, %166, %167, %168) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_quad_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 9, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
  %169 = "llvm.load"(%84) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %170 = "llvm.load"(%85) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %171 = "llvm.load"(%86) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.intr.lifetime.end"(%86) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%85) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%84) : (!llvm.ptr) -> ()
  %172 = "llvm.lshr"(%169, %7) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %173 = "llvm.lshr"(%170, %7) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %174 = "llvm.lshr"(%171, %6) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %175 = "llvm.mul"(%174, %80) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %176 = "llvm.and"(%169, %4) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %177 = "llvm.shufflevector"(%175, %174) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %178 = "llvm.add"(%177, %176) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%178, %arg0) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %179 = "llvm.and"(%170, %4) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %180 = "llvm.add"(%179, %172) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %181 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%180, %181) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %182 = "llvm.and"(%171, %1) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %183 = "llvm.add"(%182, %173) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %184 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%183, %184) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %185 = "llvm.icmp"(%arg2, %17) <{predicate = 4 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%185, %183, %180, %178, %0)[^bb3, ^bb2] <{operandSegmentSizes = array<i32: 1, 4, 0>}> : (i1, vector<8xi64>, vector<8xi64>, vector<8xi64>, i8) -> ()
^bb1:  // pred: ^bb3
  "llvm.store"(%270, %arg0) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%272, %181) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%274, %184) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.br"()[^bb2] : () -> ()
^bb2:  // 2 preds: ^bb0, ^bb1
  "llvm.return"(%arg0) : (!llvm.ptr) -> ()
^bb3(%186: vector<8xi64>, %187: vector<8xi64>, %188: vector<8xi64>, %189: i8):  // 2 preds: ^bb0, ^bb3
  %190 = "llvm.shufflevector"(%188, %18) <{mask = array<i32: 1, 1, 2, 0, 5, 5, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %191 = "llvm.shufflevector"(%187, %18) <{mask = array<i32: 1, 1, 2, 0, 5, 5, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %192 = "llvm.shufflevector"(%186, %18) <{mask = array<i32: 1, 1, 2, 0, 5, 5, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %193 = "llvm.add"(%190, %188) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %194 = "llvm.shufflevector"(%193, %190) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %195 = "llvm.add"(%191, %187) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %196 = "llvm.shufflevector"(%195, %191) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %197 = "llvm.add"(%192, %186) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %198 = "llvm.shufflevector"(%197, %192) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.intr.lifetime.start"(%87) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%88) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%89) : (!llvm.ptr) -> ()
  "llvm.call"(%87, %88, %89, %194, %196, %198) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_quad_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 6, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
  %199 = "llvm.load"(%87) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %200 = "llvm.load"(%88) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %201 = "llvm.load"(%89) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.intr.lifetime.end"(%89) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%88) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%87) : (!llvm.ptr) -> ()
  %202 = "llvm.shl"(%199, %19) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %203 = "llvm.shl"(%200, %19) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %204 = "llvm.shl"(%201, %19) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %205 = "llvm.shufflevector"(%202, %18) <{mask = array<i32: 3, 3, 3, 3, 7, 7, 7, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %206 = "llvm.shufflevector"(%203, %18) <{mask = array<i32: 3, 3, 3, 3, 7, 7, 7, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %207 = "llvm.shufflevector"(%204, %18) <{mask = array<i32: 3, 3, 3, 3, 7, 7, 7, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %208 = "llvm.shufflevector"(%202, %18) <{mask = array<i32: 1, 1, 1, 1, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %209 = "llvm.shufflevector"(%203, %18) <{mask = array<i32: 1, 1, 1, 1, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %210 = "llvm.shufflevector"(%204, %18) <{mask = array<i32: 1, 1, 1, 1, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %211 = "llvm.add"(%205, %208) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %212 = "llvm.add"(%206, %209) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %213 = "llvm.add"(%207, %210) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %214 = "llvm.sub"(%205, %208) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %215 = "llvm.add"(%214, %32) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %216 = "llvm.shufflevector"(%211, %215) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %217 = "llvm.sub"(%206, %209) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %218 = "llvm.add"(%217, %40) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %219 = "llvm.shufflevector"(%212, %218) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %220 = "llvm.sub"(%207, %210) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %221 = "llvm.add"(%220, %48) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %222 = "llvm.shufflevector"(%213, %221) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %223 = "llvm.add"(%216, %202) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %224 = "llvm.shufflevector"(%216, %223) <{mask = array<i32: 0, 1, 10, 3, 4, 5, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %225 = "llvm.add"(%219, %203) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %226 = "llvm.shufflevector"(%219, %225) <{mask = array<i32: 0, 1, 10, 3, 4, 5, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %227 = "llvm.add"(%222, %204) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %228 = "llvm.shufflevector"(%222, %227) <{mask = array<i32: 0, 1, 10, 3, 4, 5, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %229 = "llvm.sub"(%224, %202) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %230 = "llvm.add"(%229, %56) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %231 = "llvm.shufflevector"(%230, %224) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %232 = "llvm.sub"(%226, %203) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %233 = "llvm.add"(%232, %64) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %234 = "llvm.shufflevector"(%233, %226) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %235 = "llvm.sub"(%228, %204) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %236 = "llvm.add"(%235, %72) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %237 = "llvm.shufflevector"(%236, %228) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %238 = "llvm.add"(%231, %9) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %239 = "llvm.add"(%234, %8) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %240 = "llvm.add"(%237, %8) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %241 = "llvm.ashr"(%238, %7) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %242 = "llvm.ashr"(%239, %7) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %243 = "llvm.ashr"(%240, %6) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %244 = "llvm.mul"(%243, %80) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %245 = "llvm.and"(%238, %4) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %246 = "llvm.shufflevector"(%244, %243) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %247 = "llvm.add"(%245, %3) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %248 = "llvm.add"(%247, %246) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %249 = "llvm.and"(%239, %4) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %250 = "llvm.add"(%241, %2) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %251 = "llvm.add"(%250, %249) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %252 = "llvm.and"(%240, %1) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %253 = "llvm.add"(%242, %2) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %254 = "llvm.add"(%253, %252) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %255 = "llvm.shufflevector"(%248, %18) <{mask = array<i32: 0, 1, 1, 0, 4, 5, 5, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %256 = "llvm.shufflevector"(%251, %18) <{mask = array<i32: 0, 1, 1, 0, 4, 5, 5, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %257 = "llvm.shufflevector"(%254, %18) <{mask = array<i32: 0, 1, 1, 0, 4, 5, 5, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %258 = "llvm.shufflevector"(%248, %18) <{mask = array<i32: 2, 3, 2, 3, 6, 7, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %259 = "llvm.shufflevector"(%251, %18) <{mask = array<i32: 2, 3, 2, 3, 6, 7, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %260 = "llvm.shufflevector"(%254, %18) <{mask = array<i32: 2, 3, 2, 3, 6, 7, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.intr.lifetime.start"(%90) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%91) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%92) : (!llvm.ptr) -> ()
  "llvm.call"(%90, %91, %92, %255, %256, %257, %258, %259, %260) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_quad_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 9, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
  %261 = "llvm.load"(%90) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %262 = "llvm.load"(%91) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %263 = "llvm.load"(%92) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.intr.lifetime.end"(%92) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%91) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%90) : (!llvm.ptr) -> ()
  %264 = "llvm.lshr"(%261, %7) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %265 = "llvm.lshr"(%262, %7) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %266 = "llvm.lshr"(%263, %6) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %267 = "llvm.mul"(%266, %80) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %268 = "llvm.and"(%261, %4) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %269 = "llvm.shufflevector"(%267, %266) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %270 = "llvm.add"(%269, %268) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %271 = "llvm.and"(%262, %4) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %272 = "llvm.add"(%271, %264) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %273 = "llvm.and"(%263, %1) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %274 = "llvm.add"(%273, %265) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %275 = "llvm.add"(%189, %0) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  %276 = "llvm.zext"(%275) : (i8) -> i32
  %277 = "llvm.icmp"(%arg2, %276) <{predicate = 8 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%277, %274, %272, %270, %275)[^bb3, ^bb1] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 4, 0>}> : (i1, vector<8xi64>, vector<8xi64>, vector<8xi64>, i8) -> ()
}) : () -> ()

    with
      @fd_r43x6_quad_sqr_fast := Firedancer.LaneNI.Mlir.fd_r43x6_quad_sqr_fast,
      @fd_r43x6_quad_mul_fast := Firedancer.LaneNI.Mlir.fd_r43x6_quad_mul_fast,
      @fd_r43x6_quad_sqr_fast := Firedancer.LaneNI.Mlir.fd_r43x6_quad_sqr_fast,
      @fd_r43x6_quad_mul_fast := Firedancer.LaneNI.Mlir.fd_r43x6_quad_mul_fast

end

end Firedancer.LaneNI.Mlir
