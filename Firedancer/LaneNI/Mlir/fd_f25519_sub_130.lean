
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab



namespace Firedancer.LaneNI.Mlir

@[expose] public section

mlir_def fd_f25519_sub_130 := "llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nofree, llvm.nonnull, llvm.noundef, llvm.returned, llvm.writeonly}, {}, {}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<ptr (ptr, vector<8xi64>, vector<8xi64>)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], res_attrs = [{llvm.nonnull, llvm.noundef}], sym_name = "fd_f25519_sub.130", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg0: !llvm.ptr, %arg1: vector<8xi64>, %arg2: vector<8xi64>):
  %0 = "llvm.mlir.constant"() <{value = dense<[159383552, 1048576, 1048576, 1048576, 1048576, 1048576, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %1 = "llvm.mlir.constant"() <{value = dense<[-1, 0, 0, 0, 0, 0, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %2 = "llvm.mlir.constant"() <{value = dense<18> : vector<8xi64>}> : () -> vector<8xi64>
  %3 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %4 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %5 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %6 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %7 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %8 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %9 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %10 = "llvm.mlir.constant"() <{value = dense<[8795933638637, 8796091973631, 8796091973631, 8796091973631, 8796091973631, 1099510579199, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %11 = "llvm.mlir.constant"() <{value = dense<[8796093022207, 8796093022207, 8796093022207, 8796093022207, 8796093022207, 1099511627775, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %12 = "llvm.mlir.constant"() <{value = dense<[43, 43, 43, 43, 43, 40, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %13 = "llvm.mlir.poison"() : () -> i64
  %14 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %15 = "llvm.mlir.undef"() : () -> vector<8xi64>
  %16 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %17 = "llvm.insertelement"(%15, %14, %16) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %18 = "llvm.insertelement"(%17, %13, %9) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %19 = "llvm.insertelement"(%18, %13, %8) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %20 = "llvm.insertelement"(%19, %13, %7) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %21 = "llvm.insertelement"(%20, %13, %6) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %22 = "llvm.insertelement"(%21, %13, %5) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %23 = "llvm.insertelement"(%22, %13, %4) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %24 = "llvm.insertelement"(%23, %13, %3) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %25 = "llvm.sub"(%arg1, %arg2) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %26 = "llvm.add"(%25, %10) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %27 = "llvm.and"(%26, %11) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %28 = "llvm.ashr"(%26, %12) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %29 = "llvm.shufflevector"(%28, %24) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 8, 8>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %30 = "llvm.mul"(%29, %2) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %31 = "llvm.and"(%30, %1) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %32 = "llvm.add"(%27, %0) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %33 = "llvm.add"(%32, %29) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %34 = "llvm.add"(%33, %31) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%34, %arg0) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.return"(%arg0) : (!llvm.ptr) -> ()
}) : () -> ()

end

end Firedancer.LaneNI.Mlir
