
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.Lane.Mlir.fd_f25519_one
public import Firedancer.Lane.Mlir.fd_f25519_sqrt_ratio

namespace Firedancer.Lane.Mlir

@[expose] public section

mlir_def fd_f25519_is_square_var := "llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<i32 (ptr)>, linkage = #llvm.linkage<external>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], res_attrs = [{llvm.range = #llvm.constant_range<i32, 0, 2>}], sym_name = "fd_f25519_is_square_var", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr):
  %0 = "llvm.mlir.addressof"() <{global_name = @fd_f25519_one}> : () -> !llvm.ptr
  %1 = "llvm.mlir.constant"() <{value = 25 : i32}> : () -> i32
  %2 = "llvm.mlir.constant"() <{value = -8 : i64}> : () -> i64
  %3 = "llvm.mlir.constant"() <{value = dense<0> : vector<8xi64>}> : () -> vector<8xi64>
  %4 = "llvm.mlir.constant"() <{value = -32 : i64}> : () -> i64
  %5 = "llvm.mlir.constant"() <{value = 33 : i32}> : () -> i32
  %6 = "llvm.mlir.constant"() <{value = 9 : i32}> : () -> i32
  %7 = "llvm.mlir.constant"() <{value = 4 : i64}> : () -> i64
  %8 = "llvm.mlir.constant"() <{value = 4611686018427387903 : i64}> : () -> i64
  %9 = "llvm.mlir.constant"() <{value = -4 : i64}> : () -> i64
  %10 = "llvm.mlir.constant"() <{value = -2 : i32}> : () -> i32
  %11 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
  %12 = "llvm.mlir.constant"() <{value = 62 : i128}> : () -> i128
  %13 = "llvm.mlir.constant"() <{value = 63 : i64}> : () -> i64
  %14 = "llvm.mlir.constant"() <{value = 15 : i64}> : () -> i64
  %15 = "llvm.mlir.constant"() <{value = 64 : i32}> : () -> i32
  %16 = "llvm.mlir.constant"() <{value = 62 : i32}> : () -> i32
  %17 = "llvm.mlir.constant"() <{value = 4611686018427387904 : i64}> : () -> i64
  %18 = "llvm.mlir.constant"() <{value = 62 : i64}> : () -> i64
  %19 = "llvm.mlir.constant"() <{value = -4611686018427387904 : i64}> : () -> i64
  %20 = "llvm.mlir.constant"() <{value = 4611686018427387885 : i64}> : () -> i64
  %21 = "llvm.mlir.constant"() <{value = dense<4611686018427387903> : vector<4xi64>}> : () -> vector<4xi64>
  %22 = "llvm.mlir.constant"() <{value = 127 : i64}> : () -> i64
  %23 = "llvm.mlir.constant"() <{value = dense<[4611686018427387885, 4611686018427387903, 4611686018427387903, 4611686018427387903]> : vector<4xi64>}> : () -> vector<4xi64>
  %24 = "llvm.mlir.constant"() <{value = 56 : i64}> : () -> i64
  %25 = "llvm.mlir.constant"() <{value = dense<[4, 6]> : vector<2xi64>}> : () -> vector<2xi64>
  %26 = "llvm.mlir.constant"() <{value = 44 : i64}> : () -> i64
  %27 = "llvm.mlir.constant"() <{value = 22 : i64}> : () -> i64
  %28 = "llvm.mlir.constant"() <{value = 23 : i64}> : () -> i64
  %29 = "llvm.mlir.poison"() : () -> vector<8xi64>
  %30 = "llvm.mlir.constant"() <{value = 21 : i64}> : () -> i64
  %31 = "llvm.mlir.constant"() <{value = 42 : i64}> : () -> i64
  %32 = "llvm.mlir.constant"() <{value = 20 : i64}> : () -> i64
  %33 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %34 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %35 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %36 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %37 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %38 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %39 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %40 = "llvm.mlir.constant"() <{value = 8 : i64}> : () -> i64
  %41 = "llvm.mlir.constant"() <{value = 24 : i64}> : () -> i64
  %42 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %43 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
  %44 = "llvm.mlir.constant"() <{value = 8796093022207 : i64}> : () -> i64
  %45 = "llvm.mlir.constant"() <{value = 43 : i64}> : () -> i64
  %46 = "llvm.mlir.constant"() <{value = 1099511627775 : i64}> : () -> i64
  %47 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %48 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %49 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %50 = "llvm.mlir.constant"() <{value = 1099511627776 : i64}> : () -> i64
  %51 = "llvm.mlir.constant"() <{value = -19 : i64}> : () -> i64
  %52 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %53 = "llvm.mlir.poison"() : () -> vector<4xi64>
  %54 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %55 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %56 = "llvm.mlir.constant"() <{value = dense<8796093022207> : vector<4xi64>}> : () -> vector<4xi64>
  %57 = "llvm.mlir.poison"() : () -> vector<2xi64>
  %58 = "llvm.mlir.constant"() <{value = dense<[8796093022207, -1]> : vector<2xi64>}> : () -> vector<2xi64>
  %59 = "llvm.mlir.poison"() : () -> i64
  %60 = "llvm.mlir.undef"() : () -> vector<8xi64>
  %61 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %62 = "llvm.insertelement"(%60, %59, %61) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %63 = "llvm.insertelement"(%62, %59, %39) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %64 = "llvm.insertelement"(%63, %59, %38) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %65 = "llvm.insertelement"(%64, %59, %37) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %66 = "llvm.insertelement"(%65, %59, %36) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %67 = "llvm.insertelement"(%66, %59, %35) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %68 = "llvm.insertelement"(%67, %52, %34) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %69 = "llvm.insertelement"(%68, %52, %33) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %70 = "llvm.insertelement"(%60, %52, %61) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %71 = "llvm.insertelement"(%70, %30, %39) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %72 = "llvm.insertelement"(%71, %31, %38) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %73 = "llvm.insertelement"(%72, %59, %37) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %74 = "llvm.insertelement"(%73, %32, %36) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %75 = "llvm.insertelement"(%74, %59, %35) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %76 = "llvm.insertelement"(%75, %59, %34) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %77 = "llvm.insertelement"(%76, %59, %33) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %78 = "llvm.insertelement"(%60, %52, %61) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %79 = "llvm.insertelement"(%78, %45, %39) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %80 = "llvm.insertelement"(%79, %27, %38) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %81 = "llvm.insertelement"(%80, %49, %37) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %82 = "llvm.insertelement"(%81, %59, %36) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %83 = "llvm.insertelement"(%82, %28, %35) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %84 = "llvm.insertelement"(%83, %59, %34) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %85 = "llvm.insertelement"(%84, %59, %33) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %86 = "llvm.insertelement"(%60, %52, %61) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %87 = "llvm.insertelement"(%86, %45, %39) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %88 = "llvm.insertelement"(%87, %27, %38) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %89 = "llvm.insertelement"(%88, %59, %37) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %90 = "llvm.insertelement"(%89, %26, %36) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %91 = "llvm.insertelement"(%90, %28, %35) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %92 = "llvm.insertelement"(%91, %59, %34) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %93 = "llvm.insertelement"(%92, %59, %33) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %94 = "llvm.insertelement"(%60, %59, %61) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %95 = "llvm.insertelement"(%94, %52, %39) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %96 = "llvm.insertelement"(%95, %52, %38) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %97 = "llvm.insertelement"(%96, %52, %37) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %98 = "llvm.insertelement"(%97, %52, %36) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %99 = "llvm.insertelement"(%98, %52, %35) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %100 = "llvm.insertelement"(%99, %52, %34) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %101 = "llvm.insertelement"(%100, %52, %33) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %102 = "llvm.alloca"(%39) <{alignment = 16 : i64, elem_type = !llvm.array<5 x i64>}> : (i32) -> !llvm.ptr
  %103 = "llvm.alloca"(%39) <{alignment = 16 : i64, elem_type = !llvm.array<5 x i64>}> : (i32) -> !llvm.ptr
  %104 = "llvm.alloca"(%39) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %105 = "llvm.load"(%arg0) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %106 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %107 = "llvm.load"(%106) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %108 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %109 = "llvm.load"(%108) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %110 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %111 = "llvm.load"(%110) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %112 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %113 = "llvm.load"(%112) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %114 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  %115 = "llvm.load"(%114) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %116 = "llvm.and"(%105, %44) : (i64, i64) -> i64
  %117 = "llvm.ashr"(%115, %43) : (i64, i64) -> i64
  %118 = "llvm.and"(%107, %44) : (i64, i64) -> i64
  %119 = "llvm.ashr"(%105, %45) : (i64, i64) -> i64
  %120 = "llvm.add"(%118, %119) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %121 = "llvm.and"(%109, %44) : (i64, i64) -> i64
  %122 = "llvm.ashr"(%107, %45) : (i64, i64) -> i64
  %123 = "llvm.add"(%121, %122) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %124 = "llvm.and"(%111, %44) : (i64, i64) -> i64
  %125 = "llvm.ashr"(%109, %45) : (i64, i64) -> i64
  %126 = "llvm.add"(%124, %125) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %127 = "llvm.and"(%113, %44) : (i64, i64) -> i64
  %128 = "llvm.ashr"(%111, %45) : (i64, i64) -> i64
  %129 = "llvm.add"(%127, %128) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %130 = "llvm.and"(%115, %46) : (i64, i64) -> i64
  %131 = "llvm.ashr"(%113, %45) : (i64, i64) -> i64
  %132 = "llvm.add"(%131, %47) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %133 = "llvm.add"(%132, %130) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %134 = "llvm.ashr"(%133, %43) : (i64, i64) -> i64
  %135 = "llvm.and"(%133, %46) : (i64, i64) -> i64
  %136 = "llvm.add"(%134, %117) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %137 = "llvm.mul"(%136, %48) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %138 = "llvm.add"(%137, %116) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %139 = "llvm.ashr"(%138, %45) : (i64, i64) -> i64
  %140 = "llvm.and"(%138, %44) : (i64, i64) -> i64
  %141 = "llvm.add"(%120, %139) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %142 = "llvm.ashr"(%141, %45) : (i64, i64) -> i64
  %143 = "llvm.and"(%141, %44) : (i64, i64) -> i64
  %144 = "llvm.add"(%123, %142) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %145 = "llvm.ashr"(%144, %45) : (i64, i64) -> i64
  %146 = "llvm.and"(%144, %44) : (i64, i64) -> i64
  %147 = "llvm.add"(%126, %145) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %148 = "llvm.ashr"(%147, %45) : (i64, i64) -> i64
  %149 = "llvm.and"(%147, %44) : (i64, i64) -> i64
  %150 = "llvm.add"(%129, %148) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %151 = "llvm.ashr"(%150, %45) : (i64, i64) -> i64
  %152 = "llvm.and"(%150, %44) : (i64, i64) -> i64
  %153 = "llvm.add"(%140, %48) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %154 = "llvm.lshr"(%153, %45) : (i64, i64) -> i64
  %155 = "llvm.and"(%153, %44) : (i64, i64) -> i64
  %156 = "llvm.add"(%143, %154) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %157 = "llvm.lshr"(%156, %45) : (i64, i64) -> i64
  %158 = "llvm.and"(%156, %44) : (i64, i64) -> i64
  %159 = "llvm.add"(%146, %157) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %160 = "llvm.lshr"(%159, %45) : (i64, i64) -> i64
  %161 = "llvm.and"(%159, %44) : (i64, i64) -> i64
  %162 = "llvm.add"(%149, %160) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %163 = "llvm.lshr"(%162, %45) : (i64, i64) -> i64
  %164 = "llvm.and"(%162, %44) : (i64, i64) -> i64
  %165 = "llvm.add"(%152, %163) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %166 = "llvm.lshr"(%165, %45) : (i64, i64) -> i64
  %167 = "llvm.and"(%165, %44) : (i64, i64) -> i64
  %168 = "llvm.add"(%135, %49) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %169 = "llvm.add"(%168, %151) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %170 = "llvm.add"(%169, %166) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %171 = "llvm.and"(%170, %46) : (i64, i64) -> i64
  %172 = "llvm.icmp"(%170, %50) <{predicate = 6 : i64}> : (i64, i64) -> i1
  %173 = "llvm.select"(%172, %51, %52) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %174 = "llvm.add"(%173, %155) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %175 = "llvm.ashr"(%174, %45) : (i64, i64) -> i64
  %176 = "llvm.add"(%175, %158) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %177 = "llvm.ashr"(%176, %45) : (i64, i64) -> i64
  %178 = "llvm.add"(%177, %161) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %179 = "llvm.ashr"(%178, %45) : (i64, i64) -> i64
  %180 = "llvm.add"(%179, %164) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %181 = "llvm.ashr"(%180, %45) : (i64, i64) -> i64
  %182 = "llvm.insertelement"(%53, %174, %52) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %183 = "llvm.insertelement"(%182, %176, %49) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %184 = "llvm.insertelement"(%183, %178, %54) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %185 = "llvm.insertelement"(%184, %180, %55) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %186 = "llvm.and"(%185, %56) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %187 = "llvm.add"(%181, %167) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %188 = "llvm.ashr"(%187, %45) : (i64, i64) -> i64
  %189 = "llvm.add"(%188, %171) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %190 = "llvm.insertelement"(%57, %187, %52) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  %191 = "llvm.insertelement"(%190, %189, %49) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  %192 = "llvm.and"(%191, %58) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %193 = "llvm.shufflevector"(%186, %53) <{mask = array<i32: 0, 1, 2, 3, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %194 = "llvm.shufflevector"(%193, %69) <{mask = array<i32: 0, 1, 2, 3, -1, -1, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %195 = "llvm.shufflevector"(%192, %57) <{mask = array<i32: 0, 1, -1, -1, -1, -1, -1, -1>}> : (vector<2xi64>, vector<2xi64>) -> vector<8xi64>
  %196 = "llvm.shufflevector"(%194, %195) <{mask = array<i32: 0, 1, 2, 3, 8, 9, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %197 = "llvm.lshr"(%196, %77) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %198 = "llvm.shufflevector"(%197, %29) <{mask = array<i32: 0, 1, 2, 4, -1, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %199 = "llvm.shl"(%196, %85) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %200 = "llvm.shufflevector"(%199, %29) <{mask = array<i32: 1, 2, 3, 5, -1, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %201 = "llvm.shl"(%196, %93) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %202 = "llvm.shufflevector"(%201, %29) <{mask = array<i32: 1, 2, 4, 5, -1, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %203 = "llvm.or"(%198, %200) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %204 = "llvm.or"(%203, %202) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %205 = "llvm.extractelement"(%204, %52) : (vector<8xi64>, i64) -> i64
  %206 = "llvm.extractelement"(%204, %49) : (vector<8xi64>, i64) -> i64
  %207 = "llvm.extractelement"(%204, %54) : (vector<8xi64>, i64) -> i64
  %208 = "llvm.extractelement"(%204, %55) : (vector<8xi64>, i64) -> i64
  %209 = "llvm.or"(%206, %207) : (i64, i64) -> i64
  %210 = "llvm.or"(%209, %205) : (i64, i64) -> i64
  %211 = "llvm.or"(%210, %208) : (i64, i64) -> i64
  %212 = "llvm.icmp"(%211, %52) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%212, %39)[^bb34, ^bb1] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i32) -> ()
^bb1:  // pred: ^bb0
  %213 = "llvm.intr.fshl"(%206, %205, %54) : (i64, i64, i64) -> i64
  %214 = "llvm.shufflevector"(%204, %29) <{mask = array<i32: 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<2xi64>
  %215 = "llvm.shufflevector"(%204, %29) <{mask = array<i32: 1, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<2xi64>
  %216 = "llvm.intr.fshl"(%214, %215, %25) : (vector<2xi64>, vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %217 = "llvm.lshr"(%208, %24) : (i64, i64) -> i64
  "llvm.intr.lifetime.start"(%102) : (!llvm.ptr) -> ()
  %218 = "llvm.getelementptr"(%102) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%23, %102) <{alignment = 16 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %219 = "llvm.getelementptr"(%102) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%22, %219) <{alignment = 16 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%103) : (!llvm.ptr) -> ()
  %220 = "llvm.getelementptr"(%103) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %221 = "llvm.shufflevector"(%204, %29) <{mask = array<i32: 0, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<4xi64>
  %222 = "llvm.insertelement"(%221, %213, %49) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %223 = "llvm.shufflevector"(%216, %57) <{mask = array<i32: 0, 1, -1, -1>}> : (vector<2xi64>, vector<2xi64>) -> vector<4xi64>
  %224 = "llvm.shufflevector"(%222, %223) <{mask = array<i32: 0, 1, 4, 5>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %225 = "llvm.and"(%224, %21) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.store"(%225, %103) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (vector<4xi64>, !llvm.ptr) -> ()
  %226 = "llvm.getelementptr"(%103) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%217, %226) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  "llvm.br"(%20, %61, %47, %35, %61)[^bb2] : (i64, i32, i64, i32, i32) -> ()
^bb2(%227: i64, %228: i32, %229: i64, %230: i32, %231: i32):  // 2 preds: ^bb1, ^bb31
  %232 = "llvm.load"(%103) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %233 = "llvm.or"(%232, %19) : (i64, i64) -> i64
  %234 = "llvm.intr.cttz"(%233) <{is_zero_poison = true}> : (i64) -> i64
  %235 = "llvm.sub"(%229, %234) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %236 = "llvm.lshr"(%227, %49) : (i64, i64) -> i64
  %237 = "llvm.lshr"(%227, %54) : (i64, i64) -> i64
  %238 = "llvm.xor"(%236, %237) : (i64, i64) -> i64
  %239 = "llvm.and"(%234, %238) : (i64, i64) -> i64
  %240 = "llvm.trunc"(%239) <{overflowFlags = 3 : i32}> : (i64) -> i32
  %241 = "llvm.xor"(%231, %240) : (i32, i32) -> i32
  %242 = "llvm.icmp"(%234, %18) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%242, %52, %49, %17, %52, %235, %241)[^bb8, ^bb3] <{operandSegmentSizes = array<i32: 1, 6, 0>}> : (i1, i64, i64, i64, i64, i64, i32) -> ()
^bb3:  // pred: ^bb2
  %243 = "llvm.load"(%218) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %244 = "llvm.shl"(%243, %18) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %245 = "llvm.or"(%244, %227) : (i64, i64) -> i64
  %246 = "llvm.load"(%220) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %247 = "llvm.shl"(%246, %18) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %248 = "llvm.or"(%247, %232) : (i64, i64) -> i64
  %249 = "llvm.shl"(%49, %234) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %250 = "llvm.trunc"(%234) <{overflowFlags = 3 : i32}> : (i64) -> i32
  %251 = "llvm.sub"(%16, %250) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %252 = "llvm.lshr"(%248, %234) : (i64, i64) -> i64
  "llvm.br"(%241, %251, %235, %52, %249, %252, %245, %49, %52)[^bb4] : (i32, i32, i64, i64, i64, i64, i64, i64, i64) -> ()
^bb4(%253: i32, %254: i32, %255: i64, %256: i64, %257: i64, %258: i64, %259: i64, %260: i64, %261: i64):  // 2 preds: ^bb3, ^bb7
  %262 = "llvm.icmp"(%255, %52) <{predicate = 2 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%262)[^bb5, ^bb6] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb5:  // pred: ^bb4
  %263 = "llvm.sub"(%52, %255) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %264 = "llvm.and"(%259, %258) : (i64, i64) -> i64
  %265 = "llvm.lshr"(%264, %49) : (i64, i64) -> i64
  %266 = "llvm.trunc"(%265) <{overflowFlags = 0 : i32}> : (i64) -> i32
  %267 = "llvm.xor"(%253, %266) : (i32, i32) -> i32
  %268 = "llvm.trunc"(%263) <{overflowFlags = 0 : i32}> : (i64) -> i32
  %269 = "llvm.add"(%268, %39) <{overflowFlags = 0 : i32}> : (i32, i32) -> i32
  %270 = "llvm.intr.smin"(%269, %254) : (i32, i32) -> i32
  %271 = "llvm.sub"(%15, %270) <{overflowFlags = 0 : i32}> : (i32, i32) -> i32
  %272 = "llvm.zext"(%271) <{nonNeg}> : (i32) -> i64
  %273 = "llvm.lshr"(%47, %272) : (i64, i64) -> i64
  %274 = "llvm.mul"(%259, %258) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %275 = "llvm.mul"(%258, %258) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %276 = "llvm.add"(%275, %18) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %277 = "llvm.mul"(%274, %276) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %278 = "llvm.and"(%277, %13) : (i64, i64) -> i64
  %279 = "llvm.and"(%278, %273) : (i64, i64) -> i64
  "llvm.br"(%260, %257, %256, %258, %259, %267, %261, %279, %263)[^bb7] : (i64, i64, i64, i64, i64, i32, i64, i64, i64) -> ()
^bb6:  // pred: ^bb4
  %280 = "llvm.trunc"(%255) <{overflowFlags = 0 : i32}> : (i64) -> i32
  %281 = "llvm.add"(%280, %39) <{overflowFlags = 0 : i32}> : (i32, i32) -> i32
  %282 = "llvm.intr.smin"(%281, %254) : (i32, i32) -> i32
  %283 = "llvm.sub"(%15, %282) <{overflowFlags = 0 : i32}> : (i32, i32) -> i32
  %284 = "llvm.zext"(%283) <{nonNeg}> : (i32) -> i64
  %285 = "llvm.lshr"(%47, %284) : (i64, i64) -> i64
  %286 = "llvm.shl"(%259, %49) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %287 = "llvm.add"(%286, %54) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %288 = "llvm.and"(%287, %40) : (i64, i64) -> i64
  %289 = "llvm.add"(%288, %259) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %290 = "llvm.mul"(%258, %289) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %291 = "llvm.sub"(%52, %290) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %292 = "llvm.and"(%285, %14) : (i64, i64) -> i64
  %293 = "llvm.and"(%292, %291) : (i64, i64) -> i64
  "llvm.br"(%256, %261, %260, %259, %258, %253, %257, %293, %255)[^bb7] : (i64, i64, i64, i64, i64, i32, i64, i64, i64) -> ()
^bb7(%294: i64, %295: i64, %296: i64, %297: i64, %298: i64, %299: i32, %300: i64, %301: i64, %302: i64):  // 2 preds: ^bb5, ^bb6
  %303 = "llvm.mul"(%301, %297) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %304 = "llvm.add"(%303, %298) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %305 = "llvm.mul"(%301, %300) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %306 = "llvm.add"(%305, %295) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %307 = "llvm.mul"(%301, %294) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %308 = "llvm.add"(%307, %296) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %309 = "llvm.zext"(%254) <{nonNeg}> : (i32) -> i64
  %310 = "llvm.shl"(%47, %309) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %311 = "llvm.or"(%304, %310) : (i64, i64) -> i64
  %312 = "llvm.intr.cttz"(%311) <{is_zero_poison = true}> : (i64) -> i64
  %313 = "llvm.trunc"(%312) <{overflowFlags = 3 : i32}> : (i64) -> i32
  %314 = "llvm.lshr"(%304, %312) : (i64, i64) -> i64
  %315 = "llvm.shl"(%300, %312) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %316 = "llvm.shl"(%294, %312) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %317 = "llvm.sub"(%302, %312) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %318 = "llvm.sub"(%254, %313) <{overflowFlags = 0 : i32}> : (i32, i32) -> i32
  %319 = "llvm.lshr"(%297, %49) : (i64, i64) -> i64
  %320 = "llvm.lshr"(%297, %54) : (i64, i64) -> i64
  %321 = "llvm.xor"(%319, %320) : (i64, i64) -> i64
  %322 = "llvm.and"(%312, %321) : (i64, i64) -> i64
  %323 = "llvm.trunc"(%322) <{overflowFlags = 3 : i32}> : (i64) -> i32
  %324 = "llvm.xor"(%299, %323) : (i32, i32) -> i32
  %325 = "llvm.icmp"(%318, %61) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%325, %306, %308, %315, %316, %317, %324, %324, %318, %317, %316, %315, %314, %297, %308, %306)[^bb8, ^bb4] <{operandSegmentSizes = array<i32: 1, 6, 9>}> : (i1, i64, i64, i64, i64, i64, i32, i32, i32, i64, i64, i64, i64, i64, i64, i64) -> ()
^bb8(%326: i64, %327: i64, %328: i64, %329: i64, %330: i64, %331: i32):  // 2 preds: ^bb2, ^bb7
  %332 = "llvm.sext"(%328) : (i64) -> i128
  %333 = "llvm.sext"(%227) : (i64) -> i128
  %334 = "llvm.mul"(%332, %333) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %335 = "llvm.sext"(%329) : (i64) -> i128
  %336 = "llvm.sext"(%232) : (i64) -> i128
  %337 = "llvm.mul"(%335, %336) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %338 = "llvm.add"(%337, %334) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %339 = "llvm.sext"(%326) : (i64) -> i128
  %340 = "llvm.mul"(%339, %333) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %341 = "llvm.sext"(%327) : (i64) -> i128
  %342 = "llvm.mul"(%341, %336) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %343 = "llvm.add"(%342, %340) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %344 = "llvm.ashr"(%343, %12) : (i128, i128) -> i128
  %345 = "llvm.ashr"(%338, %12) : (i128, i128) -> i128
  %346 = "llvm.icmp"(%230, %39) <{predicate = 4 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%346)[^bb9, ^bb27] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb9:  // pred: ^bb8
  %347 = "llvm.zext"(%230) <{nonNeg}> : (i32) -> i64
  %348 = "llvm.add"(%347, %47) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %349 = "llvm.and"(%348, %55) : (i64, i64) -> i64
  %350 = "llvm.add"(%230, %10) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %351 = "llvm.icmp"(%350, %37) <{predicate = 6 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%351, %49, %345, %344)[^bb13, ^bb10] <{operandSegmentSizes = array<i32: 1, 3, 0>}> : (i1, i64, i128, i128) -> ()
^bb10:  // pred: ^bb9
  %352 = "llvm.and"(%348, %9) : (i64, i64) -> i64
  "llvm.br"(%49, %345, %344, %52)[^bb11] : (i64, i128, i128, i64) -> ()
^bb11(%353: i64, %354: i128, %355: i128, %356: i64):  // 2 preds: ^bb10, ^bb11
  %357 = "llvm.getelementptr"(%102, %353) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %358 = "llvm.load"(%357) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %359 = "llvm.sext"(%358) : (i64) -> i128
  %360 = "llvm.mul"(%359, %332) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %361 = "llvm.getelementptr"(%103, %353) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %362 = "llvm.load"(%361) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %363 = "llvm.sext"(%362) : (i64) -> i128
  %364 = "llvm.mul"(%363, %335) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %365 = "llvm.add"(%360, %354) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %366 = "llvm.add"(%365, %364) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %367 = "llvm.mul"(%359, %339) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %368 = "llvm.mul"(%363, %341) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %369 = "llvm.add"(%367, %355) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %370 = "llvm.add"(%369, %368) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %371 = "llvm.trunc"(%366) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %372 = "llvm.and"(%371, %8) : (i64, i64) -> i64
  %373 = "llvm.add"(%353, %47) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %374 = "llvm.getelementptr"(%102, %373) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%372, %374) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %375 = "llvm.trunc"(%370) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %376 = "llvm.and"(%375, %8) : (i64, i64) -> i64
  %377 = "llvm.getelementptr"(%103, %373) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%376, %377) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %378 = "llvm.add"(%353, %49) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %379 = "llvm.ashr"(%370, %12) : (i128, i128) -> i128
  %380 = "llvm.ashr"(%366, %12) : (i128, i128) -> i128
  %381 = "llvm.getelementptr"(%102, %378) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %382 = "llvm.load"(%381) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %383 = "llvm.sext"(%382) : (i64) -> i128
  %384 = "llvm.mul"(%383, %332) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %385 = "llvm.getelementptr"(%103, %378) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %386 = "llvm.load"(%385) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %387 = "llvm.sext"(%386) : (i64) -> i128
  %388 = "llvm.mul"(%387, %335) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %389 = "llvm.add"(%384, %380) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %390 = "llvm.add"(%389, %388) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %391 = "llvm.mul"(%383, %339) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %392 = "llvm.mul"(%387, %341) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %393 = "llvm.add"(%391, %379) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %394 = "llvm.add"(%393, %392) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %395 = "llvm.trunc"(%390) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %396 = "llvm.and"(%395, %8) : (i64, i64) -> i64
  %397 = "llvm.getelementptr"(%102, %353) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%396, %397) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %398 = "llvm.trunc"(%394) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %399 = "llvm.and"(%398, %8) : (i64, i64) -> i64
  %400 = "llvm.getelementptr"(%103, %353) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%399, %400) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %401 = "llvm.add"(%353, %54) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %402 = "llvm.ashr"(%394, %12) : (i128, i128) -> i128
  %403 = "llvm.ashr"(%390, %12) : (i128, i128) -> i128
  %404 = "llvm.getelementptr"(%102, %401) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %405 = "llvm.load"(%404) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %406 = "llvm.sext"(%405) : (i64) -> i128
  %407 = "llvm.mul"(%406, %332) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %408 = "llvm.getelementptr"(%103, %401) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %409 = "llvm.load"(%408) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %410 = "llvm.sext"(%409) : (i64) -> i128
  %411 = "llvm.mul"(%410, %335) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %412 = "llvm.add"(%407, %403) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %413 = "llvm.add"(%412, %411) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %414 = "llvm.mul"(%406, %339) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %415 = "llvm.mul"(%410, %341) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %416 = "llvm.add"(%414, %402) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %417 = "llvm.add"(%416, %415) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %418 = "llvm.trunc"(%413) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %419 = "llvm.and"(%418, %8) : (i64, i64) -> i64
  %420 = "llvm.add"(%353, %49) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %421 = "llvm.getelementptr"(%102, %420) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%419, %421) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %422 = "llvm.trunc"(%417) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %423 = "llvm.and"(%422, %8) : (i64, i64) -> i64
  %424 = "llvm.getelementptr"(%103, %420) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%423, %424) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %425 = "llvm.add"(%353, %55) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %426 = "llvm.ashr"(%417, %12) : (i128, i128) -> i128
  %427 = "llvm.ashr"(%413, %12) : (i128, i128) -> i128
  %428 = "llvm.getelementptr"(%102, %425) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %429 = "llvm.load"(%428) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %430 = "llvm.sext"(%429) : (i64) -> i128
  %431 = "llvm.mul"(%430, %332) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %432 = "llvm.getelementptr"(%103, %425) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %433 = "llvm.load"(%432) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %434 = "llvm.sext"(%433) : (i64) -> i128
  %435 = "llvm.mul"(%434, %335) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %436 = "llvm.add"(%431, %427) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %437 = "llvm.add"(%436, %435) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %438 = "llvm.mul"(%430, %339) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %439 = "llvm.mul"(%434, %341) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %440 = "llvm.add"(%438, %426) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %441 = "llvm.add"(%440, %439) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %442 = "llvm.trunc"(%437) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %443 = "llvm.and"(%442, %8) : (i64, i64) -> i64
  %444 = "llvm.add"(%353, %54) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %445 = "llvm.getelementptr"(%102, %444) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%443, %445) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %446 = "llvm.trunc"(%441) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %447 = "llvm.and"(%446, %8) : (i64, i64) -> i64
  %448 = "llvm.getelementptr"(%103, %444) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%447, %448) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %449 = "llvm.add"(%353, %7) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %450 = "llvm.ashr"(%441, %12) : (i128, i128) -> i128
  %451 = "llvm.ashr"(%437, %12) : (i128, i128) -> i128
  %452 = "llvm.add"(%356, %7) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %453 = "llvm.icmp"(%452, %352) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%453, %449, %451, %450, %452)[^bb12, ^bb11] <{loop_annotation = #llvm.loop_annotation<mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 4>}> : (i1, i64, i128, i128, i64) -> ()
^bb12:  // pred: ^bb11
  %454 = "llvm.icmp"(%349, %52) <{predicate = 0 : i64}> : (i64, i64) -> i1
  %455 = "llvm.trunc"(%450) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %456 = "llvm.trunc"(%451) <{overflowFlags = 0 : i32}> : (i128) -> i64
  "llvm.cond_br"(%454, %455, %456, %449, %451, %450)[^bb16, ^bb13] <{operandSegmentSizes = array<i32: 1, 2, 3>}> : (i1, i64, i64, i64, i128, i128) -> ()
^bb13(%457: i64, %458: i128, %459: i128):  // 2 preds: ^bb9, ^bb12
  %460 = "llvm.icmp"(%349, %52) <{predicate = 1 : i64}> : (i64, i64) -> i1
  "llvm.intr.assume"(%460) <{op_bundle_sizes = array<i32>}> : (i1) -> ()
  "llvm.br"(%457, %458, %459, %52)[^bb14] : (i64, i128, i128, i64) -> ()
^bb14(%461: i64, %462: i128, %463: i128, %464: i64):  // 2 preds: ^bb13, ^bb14
  %465 = "llvm.getelementptr"(%102, %461) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %466 = "llvm.load"(%465) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %467 = "llvm.sext"(%466) : (i64) -> i128
  %468 = "llvm.mul"(%467, %332) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %469 = "llvm.getelementptr"(%103, %461) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %470 = "llvm.load"(%469) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %471 = "llvm.sext"(%470) : (i64) -> i128
  %472 = "llvm.mul"(%471, %335) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %473 = "llvm.add"(%468, %462) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %474 = "llvm.add"(%473, %472) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %475 = "llvm.mul"(%467, %339) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %476 = "llvm.mul"(%471, %341) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %477 = "llvm.add"(%475, %463) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %478 = "llvm.add"(%477, %476) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %479 = "llvm.trunc"(%474) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %480 = "llvm.and"(%479, %8) : (i64, i64) -> i64
  %481 = "llvm.add"(%461, %47) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %482 = "llvm.getelementptr"(%102, %481) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%480, %482) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %483 = "llvm.trunc"(%478) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %484 = "llvm.and"(%483, %8) : (i64, i64) -> i64
  %485 = "llvm.getelementptr"(%103, %481) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%484, %485) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %486 = "llvm.add"(%461, %49) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %487 = "llvm.ashr"(%478, %12) : (i128, i128) -> i128
  %488 = "llvm.ashr"(%474, %12) : (i128, i128) -> i128
  %489 = "llvm.add"(%464, %49) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %490 = "llvm.icmp"(%489, %349) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%490, %486, %488, %487, %489)[^bb15, ^bb14] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>>, operandSegmentSizes = array<i32: 1, 0, 4>}> : (i1, i64, i128, i128, i64) -> ()
^bb15:  // pred: ^bb14
  %491 = "llvm.trunc"(%487) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %492 = "llvm.trunc"(%488) <{overflowFlags = 0 : i32}> : (i128) -> i64
  "llvm.br"(%491, %492)[^bb16] : (i64, i64) -> ()
^bb16(%493: i64, %494: i64):  // 2 preds: ^bb12, ^bb15
  %495 = "llvm.add"(%230, %11) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %496 = "llvm.zext"(%495) <{nonNeg}> : (i32) -> i64
  %497 = "llvm.getelementptr"(%102, %496) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%494, %497) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %498 = "llvm.getelementptr"(%103, %496) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%493, %498) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %499 = "llvm.load"(%102) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %500 = "llvm.icmp"(%499, %49) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%500)[^bb17, ^bb30] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb17:  // pred: ^bb16
  %501 = "llvm.add"(%347, %47) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %502 = "llvm.icmp"(%230, %6) <{predicate = 6 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%502, %49, %52)[^bb26, ^bb18] <{operandSegmentSizes = array<i32: 1, 2, 0>}> : (i1, i64, i64) -> ()
^bb18:  // pred: ^bb17
  %503 = "llvm.icmp"(%230, %5) <{predicate = 6 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%503, %52, %52)[^bb23, ^bb19] <{operandSegmentSizes = array<i32: 1, 2, 0>}> : (i1, i64, i64) -> ()
^bb19:  // pred: ^bb18
  %504 = "llvm.and"(%501, %41) : (i64, i64) -> i64
  %505 = "llvm.and"(%501, %4) : (i64, i64) -> i64
  %506 = "llvm.or"(%505, %49) <{isDisjoint}> : (i64, i64) -> i64
  "llvm.br"(%52, %3, %3, %3, %3)[^bb20] : (i64, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
^bb20(%507: i64, %508: vector<8xi64>, %509: vector<8xi64>, %510: vector<8xi64>, %511: vector<8xi64>):  // 2 preds: ^bb19, ^bb20
  %512 = "llvm.getelementptr"(%102, %507) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %513 = "llvm.getelementptr"(%512) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %514 = "llvm.getelementptr"(%512) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 72>}> : (!llvm.ptr) -> !llvm.ptr
  %515 = "llvm.getelementptr"(%512) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 136>}> : (!llvm.ptr) -> !llvm.ptr
  %516 = "llvm.getelementptr"(%512) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 200>}> : (!llvm.ptr) -> !llvm.ptr
  %517 = "llvm.load"(%513) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %518 = "llvm.load"(%514) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %519 = "llvm.load"(%515) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %520 = "llvm.load"(%516) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %521 = "llvm.or"(%517, %508) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %522 = "llvm.or"(%518, %509) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %523 = "llvm.or"(%519, %510) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %524 = "llvm.or"(%520, %511) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %525 = "llvm.add"(%507, %42) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %526 = "llvm.icmp"(%525, %505) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%526, %525, %521, %522, %523, %524)[^bb21, ^bb20] <{loop_annotation = #llvm.loop_annotation<unroll = <runtimeDisable = true>, mustProgress = true, isVectorized = true>, operandSegmentSizes = array<i32: 1, 0, 5>}> : (i1, i64, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
^bb21:  // pred: ^bb20
  %527 = "llvm.or"(%522, %521) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %528 = "llvm.or"(%523, %527) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %529 = "llvm.or"(%524, %528) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %530 = "llvm.intr.vector.reduce.or"(%529) : (vector<8xi64>) -> i64
  %531 = "llvm.icmp"(%501, %505) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%531, %530)[^bb28, ^bb22] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
^bb22:  // pred: ^bb21
  %532 = "llvm.icmp"(%504, %52) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%532, %506, %530, %505, %530)[^bb26, ^bb23] <{branch_weights = array<i32: 8, 24>, operandSegmentSizes = array<i32: 1, 2, 2>}> : (i1, i64, i64, i64, i64) -> ()
^bb23(%533: i64, %534: i64):  // 2 preds: ^bb18, ^bb22
  %535 = "llvm.and"(%501, %2) : (i64, i64) -> i64
  %536 = "llvm.or"(%535, %49) <{isDisjoint}> : (i64, i64) -> i64
  %537 = "llvm.insertelement"(%101, %534, %52) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  "llvm.br"(%533, %537)[^bb24] : (i64, vector<8xi64>) -> ()
^bb24(%538: i64, %539: vector<8xi64>):  // 2 preds: ^bb23, ^bb24
  %540 = "llvm.getelementptr"(%102, %538) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %541 = "llvm.getelementptr"(%540) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %542 = "llvm.load"(%541) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %543 = "llvm.or"(%542, %539) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %544 = "llvm.add"(%538, %40) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %545 = "llvm.icmp"(%544, %535) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%545, %544, %543)[^bb25, ^bb24] <{loop_annotation = #llvm.loop_annotation<unroll = <runtimeDisable = true>, mustProgress = true, isVectorized = true>, operandSegmentSizes = array<i32: 1, 0, 2>}> : (i1, i64, vector<8xi64>) -> ()
^bb25:  // pred: ^bb24
  %546 = "llvm.intr.vector.reduce.or"(%543) : (vector<8xi64>) -> i64
  %547 = "llvm.icmp"(%501, %535) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%547, %546, %536, %546)[^bb28, ^bb26] <{operandSegmentSizes = array<i32: 1, 1, 2>}> : (i1, i64, i64, i64) -> ()
^bb26(%548: i64, %549: i64):  // 3 preds: ^bb17, ^bb22, ^bb25
  "llvm.br"(%548, %549)[^bb29] : (i64, i64) -> ()
^bb27:  // pred: ^bb8
  %550 = "llvm.trunc"(%345) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %551 = "llvm.trunc"(%344) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %552 = "llvm.add"(%230, %11) <{overflowFlags = 0 : i32}> : (i32, i32) -> i32
  %553 = "llvm.sext"(%552) : (i32) -> i64
  %554 = "llvm.getelementptr"(%102, %553) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%550, %554) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %555 = "llvm.getelementptr"(%103, %553) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%551, %555) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %556 = "llvm.load"(%102) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %557 = "llvm.icmp"(%556, %49) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%557, %556, %230)[^bb33, ^bb31] <{operandSegmentSizes = array<i32: 1, 0, 2>}> : (i1, i64, i32) -> ()
^bb28(%558: i64):  // 3 preds: ^bb21, ^bb25, ^bb29
  %559 = "llvm.icmp"(%558, %52) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%559)[^bb33, ^bb30] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb29(%560: i64, %561: i64):  // 2 preds: ^bb26, ^bb29
  %562 = "llvm.getelementptr"(%102, %560) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %563 = "llvm.load"(%562) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %564 = "llvm.or"(%563, %561) : (i64, i64) -> i64
  %565 = "llvm.add"(%560, %49) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %566 = "llvm.icmp"(%565, %347) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%566, %564, %565, %564)[^bb28, ^bb29] <{loop_annotation = #llvm.loop_annotation<unroll = <runtimeDisable = true>, mustProgress = true, isVectorized = true>, operandSegmentSizes = array<i32: 1, 1, 2>}> : (i1, i64, i64, i64) -> ()
^bb30:  // 2 preds: ^bb16, ^bb28
  %567 = "llvm.or"(%493, %494) : (i64, i64) -> i64
  %568 = "llvm.icmp"(%567, %52) <{predicate = 0 : i64}> : (i64, i64) -> i1
  %569 = "llvm.select"(%568, %495, %230) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i32, i32) -> i32
  "llvm.br"(%499, %569)[^bb31] : (i64, i32) -> ()
^bb31(%570: i64, %571: i32):  // 2 preds: ^bb27, ^bb30
  %572 = "llvm.add"(%228, %39) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %573 = "llvm.icmp"(%572, %1) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%573, %570, %572, %330, %571, %331)[^bb32, ^bb2] <{loop_annotation = #llvm.loop_annotation<mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 5>}> : (i1, i64, i32, i64, i32, i32) -> ()
^bb32:  // pred: ^bb31
  "llvm.intr.lifetime.end"(%103) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%102) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%104) : (!llvm.ptr) -> ()
  %574 = "llvm.call"(%104, %arg0, %0) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_f25519_sqrt_ratio, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> i32
  "llvm.intr.lifetime.end"(%104) : (!llvm.ptr) -> ()
  "llvm.br"(%574)[^bb34] : (i32) -> ()
^bb33:  // 2 preds: ^bb27, ^bb28
  "llvm.intr.lifetime.end"(%103) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%102) : (!llvm.ptr) -> ()
  %575 = "llvm.and"(%331, %39) : (i32, i32) -> i32
  %576 = "llvm.xor"(%575, %39) : (i32, i32) -> i32
  "llvm.br"(%576)[^bb34] : (i32) -> ()
^bb34(%577: i32):  // 3 preds: ^bb0, ^bb32, ^bb33
  "llvm.return"(%577) : (i32) -> ()
}) : () -> ()

    with
      @fd_f25519_one := Firedancer.Lane.Mlir.fd_f25519_one,
      @fd_f25519_sqrt_ratio := Firedancer.Lane.Mlir.fd_f25519_sqrt_ratio

end

end Firedancer.Lane.Mlir
