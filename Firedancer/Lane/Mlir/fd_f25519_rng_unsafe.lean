
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab



namespace Firedancer.Lane.Mlir

@[expose] public section

mlir_def fd_f25519_rng_unsafe := "llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nofree, llvm.noundef, llvm.returned, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef}], frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<ptr (ptr, ptr)>, linkage = #llvm.linkage<external>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], res_attrs = [{llvm.noundef}], sym_name = "fd_f25519_rng_unsafe", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr):
  %0 = "llvm.mlir.poison"() : () -> vector<32xi64>
  %1 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %2 = "llvm.mlir.constant"() <{value = dense<[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]> : vector<32xi64>}> : () -> vector<32xi64>
  %3 = "llvm.mlir.constant"() <{value = dense<33> : vector<32xi64>}> : () -> vector<32xi64>
  %4 = "llvm.mlir.constant"() <{value = dense<-49064778989728563> : vector<32xi64>}> : () -> vector<32xi64>
  %5 = "llvm.mlir.constant"() <{value = dense<-4265267296055464877> : vector<32xi64>}> : () -> vector<32xi64>
  %6 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %7 = "llvm.mlir.constant"() <{value = dense<[-1, -1, -1, 9223372036854775807]> : vector<4xi64>}> : () -> vector<4xi64>
  %8 = "llvm.mlir.poison"() : () -> vector<4xi64>
  %9 = "llvm.mlir.constant"() <{value = 7 : i64}> : () -> i64
  %10 = "llvm.mlir.poison"() : () -> vector<64xi8>
  %11 = "llvm.mlir.constant"() <{value = dense<[0, 3, 6, 1, 4, 7, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %12 = "llvm.mlir.constant"() <{value = dense<8796093022207> : vector<8xi64>}> : () -> vector<8xi64>
  %13 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %14 = "llvm.load"(%13) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "fd_rng_private", members = {<#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 8>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 8>]}> : (!llvm.ptr) -> i64
  %15 = "llvm.insertelement"(%0, %14, %1) : (vector<32xi64>, i64, i64) -> vector<32xi64>
  %16 = "llvm.shufflevector"(%15, %0) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<32xi64>, vector<32xi64>) -> vector<32xi64>
  %17 = "llvm.add"(%16, %2) <{overflowFlags = 0 : i32}> : (vector<32xi64>, vector<32xi64>) -> vector<32xi64>
  %18 = "llvm.load"(%arg1) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "fd_rng_private", members = {<#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 8>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %19 = "llvm.insertelement"(%0, %18, %1) : (vector<32xi64>, i64, i64) -> vector<32xi64>
  %20 = "llvm.shufflevector"(%19, %0) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<32xi64>, vector<32xi64>) -> vector<32xi64>
  %21 = "llvm.xor"(%17, %20) : (vector<32xi64>, vector<32xi64>) -> vector<32xi64>
  %22 = "llvm.lshr"(%21, %3) : (vector<32xi64>, vector<32xi64>) -> vector<32xi64>
  %23 = "llvm.xor"(%22, %21) : (vector<32xi64>, vector<32xi64>) -> vector<32xi64>
  %24 = "llvm.mul"(%23, %4) <{overflowFlags = 0 : i32}> : (vector<32xi64>, vector<32xi64>) -> vector<32xi64>
  %25 = "llvm.lshr"(%24, %3) : (vector<32xi64>, vector<32xi64>) -> vector<32xi64>
  %26 = "llvm.xor"(%25, %24) : (vector<32xi64>, vector<32xi64>) -> vector<32xi64>
  %27 = "llvm.mul"(%26, %5) <{overflowFlags = 0 : i32}> : (vector<32xi64>, vector<32xi64>) -> vector<32xi64>
  %28 = "llvm.lshr"(%27, %3) : (vector<32xi64>, vector<32xi64>) -> vector<32xi64>
  %29 = "llvm.xor"(%28, %27) : (vector<32xi64>, vector<32xi64>) -> vector<32xi64>
  %30 = "llvm.trunc"(%29) <{overflowFlags = 0 : i32}> : (vector<32xi64>) -> vector<32xi8>
  %31 = "llvm.add"(%14, %6) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%31, %13) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "fd_rng_private", members = {<#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 8>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 8>]}> : (i64, !llvm.ptr) -> ()
  %32 = "llvm.bitcast"(%30) : (vector<32xi8>) -> vector<4xi64>
  %33 = "llvm.and"(%32, %7) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %34 = "llvm.shufflevector"(%33, %8) <{mask = array<i32: 0, 1, 2, 3, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %35 = "llvm.insertelement"(%34, %1, %9) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %36 = "llvm.bitcast"(%35) : (vector<8xi64>) -> vector<64xi8>
  %37 = "llvm.shufflevector"(%36, %10) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 63, 63, 5, 6, 7, 8, 9, 10, 63, 63, 10, 11, 12, 13, 14, 15, 16, 63, 16, 17, 18, 19, 20, 21, 63, 63, 21, 22, 23, 24, 25, 26, 63, 63, 26, 27, 28, 29, 30, 31, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %38 = "llvm.bitcast"(%37) : (vector<64xi8>) -> vector<8xi64>
  %39 = "llvm.lshr"(%38, %11) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %40 = "llvm.and"(%39, %12) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%40, %arg0) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.return"(%arg0) : (!llvm.ptr) -> ()
}) : () -> ()

end

end Firedancer.Lane.Mlir
