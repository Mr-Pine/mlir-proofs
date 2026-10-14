
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.Lane.Mlir.fd_ed25519_double_scalar_mul_base

namespace Firedancer.Lane.Mlir

@[expose] public section

noncomputable mlir_def fd_ed25519_verify_equation := "llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<i32 (ptr, ptr, ptr, ptr)>, inline_hint, linkage = #llvm.linkage<internal>, no_unwind, passthrough = ["sspstrong", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], res_attrs = [{llvm.range = #llvm.constant_range<i32, 0, 2>}], sym_name = "fd_ed25519_verify_equation", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: !llvm.ptr, %arg3: !llvm.ptr):
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
  %15 = "llvm.mlir.constant"() <{value = dense<24> : vector<8xi64>}> : () -> vector<8xi64>
  %16 = "llvm.mlir.constant"() <{value = dense<7> : vector<8xi64>}> : () -> vector<8xi64>
  %17 = "llvm.mlir.poison"() : () -> vector<8xi64>
  %18 = "llvm.mlir.constant"() <{value = dense<9> : vector<8xi64>}> : () -> vector<8xi64>
  %19 = "llvm.mlir.constant"() <{value = dense<0> : vector<8xi64>}> : () -> vector<8xi64>
  %20 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %21 = "llvm.mlir.poison"() : () -> vector<7xi64>
  %22 = "llvm.mlir.constant"() <{value = dense<[8796093022207, 8796093022207, 8796093022207, 8796093022207, 1099511627775, 1099511627775, 1099511627775, 1099511627775]> : vector<8xi64>}> : () -> vector<8xi64>
  %23 = "llvm.mlir.constant"() <{value = dense<8796093022207> : vector<8xi64>}> : () -> vector<8xi64>
  %24 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %25 = "llvm.mlir.constant"() <{value = dense<[43, 43, 43, 43, 40, 40, 40, 40]> : vector<8xi64>}> : () -> vector<8xi64>
  %26 = "llvm.mlir.constant"() <{value = dense<43> : vector<8xi64>}> : () -> vector<8xi64>
  %27 = "llvm.mlir.constant"() <{value = 2199023255550 : i64}> : () -> i64
  %28 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %29 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %30 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %31 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %32 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %33 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %34 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %35 = "llvm.mlir.constant"() <{value = 17592186044414 : i64}> : () -> i64
  %36 = "llvm.mlir.poison"() : () -> i64
  %37 = "llvm.mlir.constant"() <{value = 17592186044378 : i64}> : () -> i64
  %38 = "llvm.mlir.undef"() : () -> vector<8xi64>
  %39 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %40 = "llvm.insertelement"(%38, %37, %39) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %41 = "llvm.insertelement"(%40, %36, %34) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %42 = "llvm.insertelement"(%41, %36, %33) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %43 = "llvm.insertelement"(%42, %37, %32) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %44 = "llvm.insertelement"(%43, %35, %31) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %45 = "llvm.insertelement"(%44, %36, %30) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %46 = "llvm.insertelement"(%45, %36, %29) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %47 = "llvm.insertelement"(%46, %35, %28) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %48 = "llvm.insertelement"(%38, %35, %39) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %49 = "llvm.insertelement"(%48, %36, %34) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %50 = "llvm.insertelement"(%49, %36, %33) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %51 = "llvm.insertelement"(%50, %35, %32) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %52 = "llvm.insertelement"(%51, %35, %31) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %53 = "llvm.insertelement"(%52, %36, %30) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %54 = "llvm.insertelement"(%53, %36, %29) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %55 = "llvm.insertelement"(%54, %35, %28) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %56 = "llvm.insertelement"(%38, %35, %39) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %57 = "llvm.insertelement"(%56, %36, %34) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %58 = "llvm.insertelement"(%57, %36, %33) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %59 = "llvm.insertelement"(%58, %35, %32) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %60 = "llvm.insertelement"(%59, %27, %31) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %61 = "llvm.insertelement"(%60, %36, %30) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %62 = "llvm.insertelement"(%61, %36, %29) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %63 = "llvm.insertelement"(%62, %27, %28) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %64 = "llvm.insertelement"(%38, %36, %39) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %65 = "llvm.insertelement"(%64, %36, %34) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %66 = "llvm.insertelement"(%65, %36, %33) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %67 = "llvm.insertelement"(%66, %36, %32) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %68 = "llvm.insertelement"(%67, %24, %31) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %69 = "llvm.insertelement"(%68, %24, %30) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %70 = "llvm.insertelement"(%69, %24, %29) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %71 = "llvm.insertelement"(%70, %24, %28) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %72 = "llvm.insertelement"(%38, %20, %39) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %73 = "llvm.insertelement"(%72, %36, %34) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %74 = "llvm.insertelement"(%73, %20, %33) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %75 = "llvm.insertelement"(%74, %36, %32) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %76 = "llvm.insertelement"(%75, %20, %31) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %77 = "llvm.insertelement"(%76, %36, %30) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %78 = "llvm.insertelement"(%77, %20, %29) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %79 = "llvm.insertelement"(%78, %36, %28) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %80 = "llvm.insertelement"(%38, %36, %39) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %81 = "llvm.insertelement"(%80, %20, %34) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %82 = "llvm.insertelement"(%81, %36, %33) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %83 = "llvm.insertelement"(%82, %20, %32) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %84 = "llvm.insertelement"(%83, %36, %31) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %85 = "llvm.insertelement"(%84, %20, %30) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %86 = "llvm.insertelement"(%85, %36, %29) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %87 = "llvm.insertelement"(%86, %20, %28) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %88 = "llvm.insertelement"(%38, %12, %39) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %89 = "llvm.insertelement"(%88, %13, %34) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %90 = "llvm.insertelement"(%89, %13, %33) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %91 = "llvm.insertelement"(%90, %13, %32) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %92 = "llvm.insertelement"(%91, %13, %31) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %93 = "llvm.insertelement"(%92, %14, %30) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %94 = "llvm.insertelement"(%93, %36, %29) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %95 = "llvm.insertelement"(%94, %36, %28) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %96 = "llvm.alloca"(%34) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_curve25519_edwards", (vector<8xi64>, vector<8xi64>, vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%96) : (!llvm.ptr) -> ()
  %97 = "llvm.load"(%arg1) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %98 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %99 = "llvm.load"(%98) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %100 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %101 = "llvm.load"(%100) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %102 = "llvm.sub"(%47, %97) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %103 = "llvm.shufflevector"(%102, %97) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %104 = "llvm.sub"(%55, %99) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %105 = "llvm.shufflevector"(%104, %99) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %106 = "llvm.sub"(%63, %101) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %107 = "llvm.shufflevector"(%106, %101) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %108 = "llvm.lshr"(%103, %26) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %109 = "llvm.lshr"(%105, %26) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %110 = "llvm.lshr"(%107, %25) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %111 = "llvm.mul"(%110, %71) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %112 = "llvm.and"(%103, %23) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %113 = "llvm.shufflevector"(%111, %110) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %114 = "llvm.add"(%113, %112) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%114, %arg1) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %115 = "llvm.and"(%105, %23) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %116 = "llvm.add"(%115, %108) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%116, %98) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %117 = "llvm.and"(%107, %22) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %118 = "llvm.add"(%117, %109) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%118, %100) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %119 = "llvm.call"(%96, %arg0, %arg1, %arg2) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_ed25519_double_scalar_mul_base, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %120 = "llvm.load"(%96) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<7xi64>
  %121 = "llvm.getelementptr"(%96) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %122 = "llvm.load"(%121) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<7xi64>
  %123 = "llvm.getelementptr"(%96) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %124 = "llvm.load"(%123) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<7xi64>
  %125 = "llvm.load"(%arg3) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<7xi64>
  %126 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %127 = "llvm.load"(%126) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<7xi64>
  %128 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %129 = "llvm.load"(%128) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<7xi64>
  %130 = "llvm.shufflevector"(%125, %21) <{mask = array<i32: 0, 2, 1, 2, 4, 6, 5, 6>}> : (vector<7xi64>, vector<7xi64>) -> vector<8xi64>
  %131 = "llvm.shufflevector"(%127, %21) <{mask = array<i32: 0, 2, 1, 2, 4, 6, 5, 6>}> : (vector<7xi64>, vector<7xi64>) -> vector<8xi64>
  %132 = "llvm.shufflevector"(%129, %21) <{mask = array<i32: 0, 2, 1, 2, 4, 6, 5, 6>}> : (vector<7xi64>, vector<7xi64>) -> vector<8xi64>
  %133 = "llvm.shufflevector"(%120, %21) <{mask = array<i32: 2, 0, 2, 1, 2, 0, 2, 1>}> : (vector<7xi64>, vector<7xi64>) -> vector<8xi64>
  %134 = "llvm.shufflevector"(%122, %21) <{mask = array<i32: 2, 0, 2, 1, 2, 0, 2, 1>}> : (vector<7xi64>, vector<7xi64>) -> vector<8xi64>
  %135 = "llvm.shufflevector"(%124, %21) <{mask = array<i32: 2, 0, 2, 1, 2, 0, 2, 1>}> : (vector<7xi64>, vector<7xi64>) -> vector<8xi64>
  %136 = "llvm.shufflevector"(%120, %21) <{mask = array<i32: 6, 4, 6, 5, 6, 4, 6, 5>}> : (vector<7xi64>, vector<7xi64>) -> vector<8xi64>
  %137 = "llvm.shufflevector"(%122, %21) <{mask = array<i32: 6, 4, 6, 5, 6, 4, 6, 5>}> : (vector<7xi64>, vector<7xi64>) -> vector<8xi64>
  %138 = "llvm.shufflevector"(%124, %21) <{mask = array<i32: 6, 4, 6, 5, 6, 4, 6, 5>}> : (vector<7xi64>, vector<7xi64>) -> vector<8xi64>
  %139 = "llvm.call_intrinsic"(%19, %133, %130) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %140 = "llvm.call_intrinsic"(%19, %134, %130) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %141 = "llvm.call_intrinsic"(%140, %133, %131) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %142 = "llvm.call_intrinsic"(%19, %135, %130) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %143 = "llvm.call_intrinsic"(%142, %134, %131) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %144 = "llvm.call_intrinsic"(%143, %133, %132) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %145 = "llvm.call_intrinsic"(%19, %136, %130) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %146 = "llvm.call_intrinsic"(%145, %135, %131) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %147 = "llvm.call_intrinsic"(%146, %134, %132) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %148 = "llvm.call_intrinsic"(%19, %137, %130) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %149 = "llvm.call_intrinsic"(%148, %136, %131) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %150 = "llvm.call_intrinsic"(%149, %135, %132) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %151 = "llvm.call_intrinsic"(%19, %138, %130) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %152 = "llvm.call_intrinsic"(%151, %137, %131) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %153 = "llvm.call_intrinsic"(%152, %136, %132) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %154 = "llvm.call_intrinsic"(%19, %138, %131) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %155 = "llvm.call_intrinsic"(%154, %137, %132) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %156 = "llvm.call_intrinsic"(%19, %133, %130) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %157 = "llvm.shl"(%156, %18) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %158 = "llvm.add"(%157, %141) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %159 = "llvm.call_intrinsic"(%19, %134, %130) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %160 = "llvm.call_intrinsic"(%159, %133, %131) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %161 = "llvm.shl"(%160, %18) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %162 = "llvm.add"(%161, %144) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %163 = "llvm.call_intrinsic"(%19, %135, %130) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %164 = "llvm.call_intrinsic"(%163, %134, %131) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %165 = "llvm.call_intrinsic"(%164, %133, %132) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %166 = "llvm.shl"(%165, %18) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %167 = "llvm.add"(%166, %147) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %168 = "llvm.call_intrinsic"(%19, %136, %130) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %169 = "llvm.call_intrinsic"(%168, %135, %131) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %170 = "llvm.call_intrinsic"(%169, %134, %132) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %171 = "llvm.shl"(%170, %18) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %172 = "llvm.add"(%171, %150) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %173 = "llvm.call_intrinsic"(%19, %137, %130) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %174 = "llvm.call_intrinsic"(%173, %136, %131) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %175 = "llvm.call_intrinsic"(%174, %135, %132) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %176 = "llvm.shl"(%175, %18) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %177 = "llvm.add"(%176, %153) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %178 = "llvm.call_intrinsic"(%19, %138, %130) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %179 = "llvm.call_intrinsic"(%178, %137, %131) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %180 = "llvm.call_intrinsic"(%179, %136, %132) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %181 = "llvm.shl"(%180, %18) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %182 = "llvm.add"(%181, %155) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %183 = "llvm.call_intrinsic"(%19, %138, %131) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %184 = "llvm.call_intrinsic"(%183, %137, %132) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %185 = "llvm.shl"(%184, %18) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %186 = "llvm.call_intrinsic"(%185, %138, %132) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %187 = "llvm.call_intrinsic"(%19, %138, %132) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %188 = "llvm.shl"(%187, %18) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %189 = "llvm.shufflevector"(%167, %17) <{mask = array<i32: 4, 5, 6, 7, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %190 = "llvm.shufflevector"(%172, %17) <{mask = array<i32: 4, 5, 6, 7, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %191 = "llvm.shufflevector"(%177, %17) <{mask = array<i32: 4, 5, 6, 7, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %192 = "llvm.add"(%189, %139) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %193 = "llvm.shufflevector"(%139, %192) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %194 = "llvm.add"(%190, %158) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %195 = "llvm.shufflevector"(%158, %194) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %196 = "llvm.add"(%191, %162) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %197 = "llvm.shufflevector"(%162, %196) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %198 = "llvm.add"(%182, %189) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %199 = "llvm.shufflevector"(%198, %182) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %200 = "llvm.add"(%186, %190) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %201 = "llvm.shufflevector"(%200, %186) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %202 = "llvm.add"(%188, %191) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %203 = "llvm.shufflevector"(%202, %188) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %204 = "llvm.shl"(%199, %16) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %205 = "llvm.add"(%204, %193) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %206 = "llvm.mul"(%199, %15) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %207 = "llvm.add"(%205, %206) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %208 = "llvm.shl"(%201, %16) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %209 = "llvm.add"(%208, %195) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %210 = "llvm.mul"(%201, %15) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %211 = "llvm.add"(%209, %210) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %212 = "llvm.shl"(%203, %16) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %213 = "llvm.add"(%212, %197) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %214 = "llvm.mul"(%203, %15) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %215 = "llvm.add"(%213, %214) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %216 = "llvm.shufflevector"(%207, %211) <{mask = array<i32: 0, 8, 2, 10, 4, 12, 6, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %217 = "llvm.shufflevector"(%207, %211) <{mask = array<i32: 1, 9, 3, 11, 5, 13, 7, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %218 = "llvm.shufflevector"(%215, %79) <{mask = array<i32: 0, 8, 2, 10, 4, 12, 6, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %219 = "llvm.shufflevector"(%215, %87) <{mask = array<i32: 1, 9, 3, 11, 5, 13, 7, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %220 = "llvm.shufflevector"(%216, %218) <{mask = array<i32: 0, 1, 8, 4, 5, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %221 = "llvm.shufflevector"(%217, %219) <{mask = array<i32: 0, 1, 8, 4, 5, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %222 = "llvm.shufflevector"(%216, %218) <{mask = array<i32: 2, 3, 10, 6, 7, 14, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %223 = "llvm.shufflevector"(%217, %219) <{mask = array<i32: 2, 3, 10, 6, 7, 14, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %224 = "llvm.sub"(%221, %220) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %225 = "llvm.add"(%224, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %226 = "llvm.sub"(%223, %222) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %227 = "llvm.add"(%226, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %228 = "llvm.shufflevector"(%227, %225) <{mask = array<i32: 1, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<2xi64>
  %229 = "llvm.shufflevector"(%227, %225) <{mask = array<i32: 2, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<2xi64>
  %230 = "llvm.shufflevector"(%227, %225) <{mask = array<i32: 3, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<2xi64>
  %231 = "llvm.shufflevector"(%227, %225) <{mask = array<i32: 4, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<2xi64>
  %232 = "llvm.shufflevector"(%227, %225) <{mask = array<i32: 5, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<2xi64>
  %233 = "llvm.add"(%232, %11) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %234 = "llvm.and"(%233, %10) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %235 = "llvm.ashr"(%233, %9) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %236 = "llvm.mul"(%235, %8) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %237 = "llvm.shufflevector"(%227, %225) <{mask = array<i32: 0, 8>}> : (vector<8xi64>, vector<8xi64>) -> vector<2xi64>
  %238 = "llvm.add"(%236, %237) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %239 = "llvm.add"(%234, %7) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %240 = "llvm.ashr"(%238, %6) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %241 = "llvm.add"(%240, %228) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %242 = "llvm.ashr"(%241, %6) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %243 = "llvm.add"(%242, %229) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %244 = "llvm.ashr"(%243, %6) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %245 = "llvm.add"(%244, %230) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %246 = "llvm.ashr"(%245, %6) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %247 = "llvm.add"(%246, %231) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %248 = "llvm.and"(%238, %5) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %249 = "llvm.and"(%241, %5) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %250 = "llvm.and"(%243, %5) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %251 = "llvm.and"(%245, %5) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %252 = "llvm.ashr"(%247, %6) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %253 = "llvm.and"(%247, %5) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %254 = "llvm.add"(%248, %8) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %255 = "llvm.lshr"(%254, %6) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %256 = "llvm.and"(%254, %5) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %257 = "llvm.add"(%249, %255) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %258 = "llvm.lshr"(%257, %6) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %259 = "llvm.and"(%257, %5) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %260 = "llvm.add"(%250, %258) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %261 = "llvm.lshr"(%260, %6) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %262 = "llvm.and"(%260, %5) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %263 = "llvm.add"(%251, %261) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %264 = "llvm.lshr"(%263, %6) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %265 = "llvm.and"(%263, %5) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %266 = "llvm.add"(%253, %264) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %267 = "llvm.lshr"(%266, %6) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %268 = "llvm.and"(%266, %5) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %269 = "llvm.add"(%239, %252) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %270 = "llvm.add"(%269, %267) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %271 = "llvm.and"(%270, %10) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %272 = "llvm.icmp"(%270, %4) <{predicate = 6 : i64}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi1>
  %273 = "llvm.select"(%272, %3, %2) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<2xi1>, vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %274 = "llvm.add"(%273, %256) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %275 = "llvm.ashr"(%274, %6) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %276 = "llvm.add"(%275, %259) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %277 = "llvm.ashr"(%276, %6) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %278 = "llvm.add"(%277, %262) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %279 = "llvm.ashr"(%278, %6) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %280 = "llvm.add"(%279, %265) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %281 = "llvm.ashr"(%280, %6) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %282 = "llvm.add"(%281, %268) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %283 = "llvm.ashr"(%282, %6) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %284 = "llvm.add"(%283, %271) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %285 = "llvm.or"(%276, %274) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %286 = "llvm.or"(%285, %278) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %287 = "llvm.or"(%286, %280) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %288 = "llvm.or"(%287, %282) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %289 = "llvm.and"(%288, %5) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %290 = "llvm.or"(%289, %284) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %291 = "llvm.icmp"(%290, %2) <{predicate = 0 : i64}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi1>
  %292 = "llvm.extractelement"(%291, %20) : (vector<2xi1>, i64) -> i1
  %293 = "llvm.extractelement"(%291, %1) : (vector<2xi1>, i64) -> i1
  %294 = "llvm.select"(%292, %293, %0) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i1, i1) -> i1
  %295 = "llvm.zext"(%294) : (i1) -> i32
  "llvm.intr.lifetime.end"(%96) : (!llvm.ptr) -> ()
  "llvm.return"(%295) : (i32) -> ()
}) : () -> ()

    with
      @fd_ed25519_double_scalar_mul_base := Firedancer.Lane.Mlir.fd_ed25519_double_scalar_mul_base

end

end Firedancer.Lane.Mlir
