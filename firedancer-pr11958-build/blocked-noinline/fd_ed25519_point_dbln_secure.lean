
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.LaneNI.Mlir.fd_r43x6_quad_sqr_fast
public import Firedancer.LaneNI.Mlir.fd_r43x6_quad_mul_fast
public import Firedancer.LaneNI.Mlir.fd_r43x6_quad_sqr_fast
public import Firedancer.LaneNI.Mlir.fd_r43x6_quad_mul_fast

namespace Firedancer.LaneNI.Mlir

@[expose] public section

mlir_def fd_ed25519_point_dbln_secure := "llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writeonly}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], sym_name = "fd_ed25519_point_dbln_secure", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, zero_call_used_regs = "all"}> ({
^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: !llvm.ptr, %arg3: !llvm.ptr):
  %0 = "llvm.mlir.constant"() <{value = 4 : i8}> : () -> i8
  %1 = "llvm.mlir.constant"() <{value = 1 : i8}> : () -> i8
  %2 = "llvm.mlir.constant"() <{value = dense<[8796093022207, 8796093022207, 8796093022207, 8796093022207, 1099511627775, 1099511627775, 1099511627775, 1099511627775]> : vector<8xi64>}> : () -> vector<8xi64>
  %3 = "llvm.mlir.constant"() <{value = dense<1048576> : vector<8xi64>}> : () -> vector<8xi64>
  %4 = "llvm.mlir.constant"() <{value = dense<[159383552, 159383552, 159383552, 159383552, 1048576, 1048576, 1048576, 1048576]> : vector<8xi64>}> : () -> vector<8xi64>
  %5 = "llvm.mlir.constant"() <{value = dense<8796093022207> : vector<8xi64>}> : () -> vector<8xi64>
  %6 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %7 = "llvm.mlir.constant"() <{value = dense<[43, 43, 43, 43, 40, 40, 40, 40]> : vector<8xi64>}> : () -> vector<8xi64>
  %8 = "llvm.mlir.constant"() <{value = dense<43> : vector<8xi64>}> : () -> vector<8xi64>
  %9 = "llvm.mlir.constant"() <{value = dense<-1048576> : vector<8xi64>}> : () -> vector<8xi64>
  %10 = "llvm.mlir.constant"() <{value = dense<[-159383552, -159383552, -159383552, -159383552, -1048576, -1048576, -1048576, -1048576]> : vector<8xi64>}> : () -> vector<8xi64>
  %11 = "llvm.mlir.constant"() <{value = 1099511627775 : i64}> : () -> i64
  %12 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %13 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %14 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %15 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %16 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %17 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %18 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %19 = "llvm.mlir.poison"() : () -> vector<8xi64>
  %20 = "llvm.mlir.constant"() <{value = dense<[0, 0, 1, 0, 0, 0, 1, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %21 = "llvm.mlir.poison"() : () -> i64
  %22 = "llvm.mlir.constant"() <{value = 8796093022207 : i64}> : () -> i64
  %23 = "llvm.mlir.constant"() <{value = 8796093022189 : i64}> : () -> i64
  %24 = "llvm.mlir.undef"() : () -> vector<8xi64>
  %25 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %26 = "llvm.insertelement"(%24, %23, %25) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %27 = "llvm.insertelement"(%26, %21, %18) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %28 = "llvm.insertelement"(%27, %21, %17) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %29 = "llvm.insertelement"(%28, %21, %16) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %30 = "llvm.insertelement"(%29, %22, %15) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %31 = "llvm.insertelement"(%30, %21, %14) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %32 = "llvm.insertelement"(%31, %21, %13) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %33 = "llvm.insertelement"(%32, %21, %12) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %34 = "llvm.insertelement"(%24, %22, %25) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %35 = "llvm.insertelement"(%34, %21, %18) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %36 = "llvm.insertelement"(%35, %21, %17) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %37 = "llvm.insertelement"(%36, %21, %16) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %38 = "llvm.insertelement"(%37, %22, %15) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %39 = "llvm.insertelement"(%38, %21, %14) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %40 = "llvm.insertelement"(%39, %21, %13) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %41 = "llvm.insertelement"(%40, %21, %12) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %42 = "llvm.insertelement"(%24, %22, %25) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %43 = "llvm.insertelement"(%42, %21, %18) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %44 = "llvm.insertelement"(%43, %21, %17) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %45 = "llvm.insertelement"(%44, %21, %16) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %46 = "llvm.insertelement"(%45, %11, %15) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %47 = "llvm.insertelement"(%46, %21, %14) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %48 = "llvm.insertelement"(%47, %21, %13) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %49 = "llvm.insertelement"(%48, %21, %12) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %50 = "llvm.insertelement"(%24, %21, %25) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %51 = "llvm.insertelement"(%50, %23, %18) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %52 = "llvm.insertelement"(%51, %23, %17) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %53 = "llvm.insertelement"(%52, %21, %16) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %54 = "llvm.insertelement"(%53, %21, %15) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %55 = "llvm.insertelement"(%54, %22, %14) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %56 = "llvm.insertelement"(%55, %22, %13) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %57 = "llvm.insertelement"(%56, %21, %12) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %58 = "llvm.insertelement"(%24, %21, %25) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %59 = "llvm.insertelement"(%58, %22, %18) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %60 = "llvm.insertelement"(%59, %22, %17) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %61 = "llvm.insertelement"(%60, %21, %16) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %62 = "llvm.insertelement"(%61, %21, %15) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %63 = "llvm.insertelement"(%62, %22, %14) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %64 = "llvm.insertelement"(%63, %22, %13) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %65 = "llvm.insertelement"(%64, %21, %12) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %66 = "llvm.insertelement"(%24, %21, %25) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %67 = "llvm.insertelement"(%66, %22, %18) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %68 = "llvm.insertelement"(%67, %22, %17) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %69 = "llvm.insertelement"(%68, %21, %16) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %70 = "llvm.insertelement"(%69, %21, %15) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %71 = "llvm.insertelement"(%70, %11, %14) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %72 = "llvm.insertelement"(%71, %11, %13) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %73 = "llvm.insertelement"(%72, %21, %12) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %74 = "llvm.insertelement"(%24, %21, %25) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %75 = "llvm.insertelement"(%74, %21, %18) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %76 = "llvm.insertelement"(%75, %21, %17) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %77 = "llvm.insertelement"(%76, %21, %16) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %78 = "llvm.insertelement"(%77, %6, %15) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %79 = "llvm.insertelement"(%78, %6, %14) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %80 = "llvm.insertelement"(%79, %6, %13) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %81 = "llvm.insertelement"(%80, %6, %12) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %82 = "llvm.alloca"(%18) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %83 = "llvm.alloca"(%18) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %84 = "llvm.alloca"(%18) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %85 = "llvm.alloca"(%18) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %86 = "llvm.alloca"(%18) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %87 = "llvm.alloca"(%18) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %88 = "llvm.alloca"(%18) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %89 = "llvm.alloca"(%18) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %90 = "llvm.alloca"(%18) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %91 = "llvm.alloca"(%18) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %92 = "llvm.alloca"(%18) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %93 = "llvm.alloca"(%18) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %94 = "llvm.load"(%arg1) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %95 = "llvm.shufflevector"(%94, %19) <{mask = array<i32: 1, 1, 2, 0, 5, 5, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %96 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %97 = "llvm.load"(%96) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %98 = "llvm.shufflevector"(%97, %19) <{mask = array<i32: 1, 1, 2, 0, 5, 5, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %99 = "llvm.getelementptr"(%arg2) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %100 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %101 = "llvm.load"(%100) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %102 = "llvm.shufflevector"(%101, %19) <{mask = array<i32: 1, 1, 2, 0, 5, 5, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %103 = "llvm.getelementptr"(%arg2) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %104 = "llvm.add"(%95, %94) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %105 = "llvm.shufflevector"(%104, %95) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %106 = "llvm.add"(%98, %97) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %107 = "llvm.shufflevector"(%106, %98) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %108 = "llvm.add"(%102, %101) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %109 = "llvm.shufflevector"(%108, %102) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.intr.lifetime.start"(%82) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%83) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%84) : (!llvm.ptr) -> ()
  "llvm.call"(%82, %83, %84, %105, %107, %109) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_quad_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 6, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
  %110 = "llvm.load"(%82) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %111 = "llvm.load"(%83) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %112 = "llvm.load"(%84) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.intr.lifetime.end"(%84) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%83) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%82) : (!llvm.ptr) -> ()
  %113 = "llvm.shl"(%110, %20) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %114 = "llvm.shl"(%111, %20) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %115 = "llvm.shl"(%112, %20) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %116 = "llvm.shufflevector"(%113, %19) <{mask = array<i32: 3, 3, 3, 3, 7, 7, 7, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %117 = "llvm.shufflevector"(%114, %19) <{mask = array<i32: 3, 3, 3, 3, 7, 7, 7, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %118 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %119 = "llvm.shufflevector"(%115, %19) <{mask = array<i32: 3, 3, 3, 3, 7, 7, 7, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %120 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %121 = "llvm.add"(%116, %113) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %122 = "llvm.shufflevector"(%116, %121) <{mask = array<i32: 0, 1, 10, 3, 4, 5, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %123 = "llvm.add"(%117, %114) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %124 = "llvm.shufflevector"(%117, %123) <{mask = array<i32: 0, 1, 10, 3, 4, 5, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %125 = "llvm.add"(%119, %115) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %126 = "llvm.shufflevector"(%119, %125) <{mask = array<i32: 0, 1, 10, 3, 4, 5, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %127 = "llvm.sub"(%122, %113) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %128 = "llvm.add"(%127, %33) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %129 = "llvm.shufflevector"(%128, %122) <{mask = array<i32: 0, -1, -1, 11, 4, -1, -1, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %130 = "llvm.sub"(%124, %114) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %131 = "llvm.add"(%130, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %132 = "llvm.shufflevector"(%131, %124) <{mask = array<i32: 0, -1, -1, 11, 4, -1, -1, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %133 = "llvm.sub"(%126, %115) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %134 = "llvm.add"(%133, %49) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %135 = "llvm.shufflevector"(%134, %126) <{mask = array<i32: 0, -1, -1, 11, 4, -1, -1, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %136 = "llvm.shufflevector"(%113, %19) <{mask = array<i32: 1, 1, 1, 1, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %137 = "llvm.shufflevector"(%114, %19) <{mask = array<i32: 1, 1, 1, 1, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %138 = "llvm.shufflevector"(%115, %19) <{mask = array<i32: 1, 1, 1, 1, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %139 = "llvm.add"(%129, %136) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %140 = "llvm.add"(%132, %137) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %141 = "llvm.add"(%135, %138) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %142 = "llvm.sub"(%122, %136) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %143 = "llvm.add"(%142, %57) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %144 = "llvm.shufflevector"(%139, %143) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %145 = "llvm.sub"(%124, %137) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %146 = "llvm.add"(%145, %65) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %147 = "llvm.shufflevector"(%140, %146) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %148 = "llvm.sub"(%126, %138) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %149 = "llvm.add"(%148, %73) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %150 = "llvm.shufflevector"(%141, %149) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %151 = "llvm.add"(%144, %10) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %152 = "llvm.add"(%147, %9) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %153 = "llvm.add"(%150, %9) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %154 = "llvm.ashr"(%151, %8) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %155 = "llvm.ashr"(%152, %8) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %156 = "llvm.ashr"(%153, %7) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %157 = "llvm.mul"(%156, %81) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %158 = "llvm.and"(%151, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %159 = "llvm.shufflevector"(%157, %156) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %160 = "llvm.add"(%158, %4) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %161 = "llvm.add"(%160, %159) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %162 = "llvm.and"(%152, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %163 = "llvm.add"(%154, %3) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %164 = "llvm.add"(%163, %162) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %165 = "llvm.and"(%153, %2) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %166 = "llvm.add"(%155, %3) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %167 = "llvm.add"(%166, %165) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %168 = "llvm.shufflevector"(%161, %19) <{mask = array<i32: 0, 1, 1, 0, 4, 5, 5, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %169 = "llvm.shufflevector"(%164, %19) <{mask = array<i32: 0, 1, 1, 0, 4, 5, 5, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %170 = "llvm.shufflevector"(%167, %19) <{mask = array<i32: 0, 1, 1, 0, 4, 5, 5, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %171 = "llvm.shufflevector"(%161, %19) <{mask = array<i32: 2, 3, 2, 3, 6, 7, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%171, %arg3) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %172 = "llvm.shufflevector"(%164, %19) <{mask = array<i32: 2, 3, 2, 3, 6, 7, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%172, %118) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %173 = "llvm.shufflevector"(%167, %19) <{mask = array<i32: 2, 3, 2, 3, 6, 7, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%173, %120) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%85) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%86) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%87) : (!llvm.ptr) -> ()
  "llvm.call"(%85, %86, %87, %168, %169, %170, %171, %172, %173) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_quad_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 9, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
  %174 = "llvm.load"(%85) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.store"(%174, %arg2) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %175 = "llvm.load"(%86) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.store"(%175, %99) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %176 = "llvm.load"(%87) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.store"(%176, %103) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%87) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%86) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%85) : (!llvm.ptr) -> ()
  %177 = "llvm.lshr"(%174, %8) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %178 = "llvm.lshr"(%175, %8) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %179 = "llvm.lshr"(%176, %7) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %180 = "llvm.mul"(%179, %81) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %181 = "llvm.and"(%174, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %182 = "llvm.shufflevector"(%180, %179) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %183 = "llvm.add"(%182, %181) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%183, %arg0) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %184 = "llvm.and"(%175, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %185 = "llvm.add"(%184, %177) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %186 = "llvm.and"(%176, %2) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %187 = "llvm.add"(%186, %178) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.br"(%1, %183, %185, %187)[^bb2] : (i8, vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
^bb1:  // pred: ^bb2
  %188 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %189 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%274, %arg0) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%265, %arg2) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%276, %189) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%266, %99) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%278, %188) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%267, %103) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%262, %arg3) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%263, %118) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%264, %120) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
^bb2(%190: i8, %191: vector<8xi64>, %192: vector<8xi64>, %193: vector<8xi64>):  // 2 preds: ^bb0, ^bb2
  %194 = "llvm.shufflevector"(%191, %19) <{mask = array<i32: 1, 1, 2, 0, 5, 5, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %195 = "llvm.shufflevector"(%192, %19) <{mask = array<i32: 1, 1, 2, 0, 5, 5, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %196 = "llvm.shufflevector"(%193, %19) <{mask = array<i32: 1, 1, 2, 0, 5, 5, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %197 = "llvm.add"(%194, %191) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %198 = "llvm.shufflevector"(%197, %194) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %199 = "llvm.add"(%195, %192) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %200 = "llvm.shufflevector"(%199, %195) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %201 = "llvm.add"(%196, %193) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %202 = "llvm.shufflevector"(%201, %196) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.intr.lifetime.start"(%88) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%89) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%90) : (!llvm.ptr) -> ()
  "llvm.call"(%88, %89, %90, %198, %200, %202) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_quad_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 6, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
  %203 = "llvm.load"(%88) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %204 = "llvm.load"(%89) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %205 = "llvm.load"(%90) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.intr.lifetime.end"(%90) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%89) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%88) : (!llvm.ptr) -> ()
  %206 = "llvm.shl"(%203, %20) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %207 = "llvm.shl"(%204, %20) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %208 = "llvm.shl"(%205, %20) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %209 = "llvm.shufflevector"(%206, %19) <{mask = array<i32: 3, 3, 3, 3, 7, 7, 7, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %210 = "llvm.shufflevector"(%207, %19) <{mask = array<i32: 3, 3, 3, 3, 7, 7, 7, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %211 = "llvm.shufflevector"(%208, %19) <{mask = array<i32: 3, 3, 3, 3, 7, 7, 7, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %212 = "llvm.add"(%209, %206) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %213 = "llvm.shufflevector"(%209, %212) <{mask = array<i32: 0, 1, 10, 3, 4, 5, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %214 = "llvm.add"(%210, %207) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %215 = "llvm.shufflevector"(%210, %214) <{mask = array<i32: 0, 1, 10, 3, 4, 5, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %216 = "llvm.add"(%211, %208) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %217 = "llvm.shufflevector"(%211, %216) <{mask = array<i32: 0, 1, 10, 3, 4, 5, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %218 = "llvm.sub"(%213, %206) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %219 = "llvm.add"(%218, %33) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %220 = "llvm.shufflevector"(%219, %213) <{mask = array<i32: 0, -1, -1, 11, 4, -1, -1, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %221 = "llvm.sub"(%215, %207) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %222 = "llvm.add"(%221, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %223 = "llvm.shufflevector"(%222, %215) <{mask = array<i32: 0, -1, -1, 11, 4, -1, -1, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %224 = "llvm.sub"(%217, %208) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %225 = "llvm.add"(%224, %49) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %226 = "llvm.shufflevector"(%225, %217) <{mask = array<i32: 0, -1, -1, 11, 4, -1, -1, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %227 = "llvm.shufflevector"(%206, %19) <{mask = array<i32: 1, 1, 1, 1, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %228 = "llvm.shufflevector"(%207, %19) <{mask = array<i32: 1, 1, 1, 1, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %229 = "llvm.shufflevector"(%208, %19) <{mask = array<i32: 1, 1, 1, 1, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %230 = "llvm.add"(%220, %227) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %231 = "llvm.add"(%223, %228) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %232 = "llvm.add"(%226, %229) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %233 = "llvm.sub"(%213, %227) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %234 = "llvm.add"(%233, %57) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %235 = "llvm.shufflevector"(%230, %234) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %236 = "llvm.sub"(%215, %228) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %237 = "llvm.add"(%236, %65) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %238 = "llvm.shufflevector"(%231, %237) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %239 = "llvm.sub"(%217, %229) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %240 = "llvm.add"(%239, %73) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %241 = "llvm.shufflevector"(%232, %240) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %242 = "llvm.add"(%235, %10) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %243 = "llvm.add"(%238, %9) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %244 = "llvm.add"(%241, %9) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %245 = "llvm.ashr"(%242, %8) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %246 = "llvm.ashr"(%243, %8) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %247 = "llvm.ashr"(%244, %7) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %248 = "llvm.mul"(%247, %81) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %249 = "llvm.and"(%242, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %250 = "llvm.shufflevector"(%248, %247) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %251 = "llvm.add"(%249, %4) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %252 = "llvm.add"(%251, %250) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %253 = "llvm.and"(%243, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %254 = "llvm.add"(%245, %3) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %255 = "llvm.add"(%254, %253) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %256 = "llvm.and"(%244, %2) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %257 = "llvm.add"(%246, %3) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %258 = "llvm.add"(%257, %256) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %259 = "llvm.shufflevector"(%252, %19) <{mask = array<i32: 0, 1, 1, 0, 4, 5, 5, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %260 = "llvm.shufflevector"(%255, %19) <{mask = array<i32: 0, 1, 1, 0, 4, 5, 5, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %261 = "llvm.shufflevector"(%258, %19) <{mask = array<i32: 0, 1, 1, 0, 4, 5, 5, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %262 = "llvm.shufflevector"(%252, %19) <{mask = array<i32: 2, 3, 2, 3, 6, 7, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %263 = "llvm.shufflevector"(%255, %19) <{mask = array<i32: 2, 3, 2, 3, 6, 7, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %264 = "llvm.shufflevector"(%258, %19) <{mask = array<i32: 2, 3, 2, 3, 6, 7, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.intr.lifetime.start"(%91) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%92) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%93) : (!llvm.ptr) -> ()
  "llvm.call"(%91, %92, %93, %259, %260, %261, %262, %263, %264) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_quad_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 9, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
  %265 = "llvm.load"(%91) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %266 = "llvm.load"(%92) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %267 = "llvm.load"(%93) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.intr.lifetime.end"(%93) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%92) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%91) : (!llvm.ptr) -> ()
  %268 = "llvm.lshr"(%265, %8) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %269 = "llvm.lshr"(%266, %8) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %270 = "llvm.lshr"(%267, %7) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %271 = "llvm.mul"(%270, %81) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %272 = "llvm.and"(%265, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %273 = "llvm.shufflevector"(%271, %270) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %274 = "llvm.add"(%273, %272) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %275 = "llvm.and"(%266, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %276 = "llvm.add"(%275, %268) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %277 = "llvm.and"(%267, %2) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %278 = "llvm.add"(%277, %269) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %279 = "llvm.add"(%190, %1) <{overflowFlags = 3 : i32}> : (i8, i8) -> i8
  %280 = "llvm.icmp"(%279, %0) <{predicate = 0 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%280, %279, %274, %276, %278)[^bb1, ^bb2] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 4>}> : (i1, i8, vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
}) : () -> ()

    with
      @fd_r43x6_quad_sqr_fast := Firedancer.LaneNI.Mlir.fd_r43x6_quad_sqr_fast,
      @fd_r43x6_quad_mul_fast := Firedancer.LaneNI.Mlir.fd_r43x6_quad_mul_fast,
      @fd_r43x6_quad_sqr_fast := Firedancer.LaneNI.Mlir.fd_r43x6_quad_sqr_fast,
      @fd_r43x6_quad_mul_fast := Firedancer.LaneNI.Mlir.fd_r43x6_quad_mul_fast

end

end Firedancer.LaneNI.Mlir
