
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab



namespace Firedancer.LaneNI.Mlir

@[expose] public section

mlir_def fd_ed25519_point_neg_if := "llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.noundef, llvm.zeroext}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr, i8)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], sym_name = "fd_ed25519_point_neg_if", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return, zero_call_used_regs = "all"}> ({
^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: i8):
  %0 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %1 = "llvm.mlir.constant"() <{value = 1099511627775 : i64}> : () -> i64
  %2 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %3 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %4 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %5 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %6 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %7 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %8 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %9 = "llvm.mlir.constant"() <{value = 8796093022207 : i64}> : () -> i64
  %10 = "llvm.mlir.poison"() : () -> i64
  %11 = "llvm.mlir.constant"() <{value = 8796093022189 : i64}> : () -> i64
  %12 = "llvm.mlir.undef"() : () -> vector<8xi64>
  %13 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %14 = "llvm.insertelement"(%12, %10, %13) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %15 = "llvm.insertelement"(%14, %10, %8) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %16 = "llvm.insertelement"(%15, %10, %7) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %17 = "llvm.insertelement"(%16, %11, %6) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %18 = "llvm.insertelement"(%17, %10, %5) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %19 = "llvm.insertelement"(%18, %10, %4) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %20 = "llvm.insertelement"(%19, %10, %3) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %21 = "llvm.insertelement"(%20, %9, %2) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %22 = "llvm.insertelement"(%12, %10, %13) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %23 = "llvm.insertelement"(%22, %10, %8) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %24 = "llvm.insertelement"(%23, %10, %7) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %25 = "llvm.insertelement"(%24, %9, %6) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %26 = "llvm.insertelement"(%25, %10, %5) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %27 = "llvm.insertelement"(%26, %10, %4) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %28 = "llvm.insertelement"(%27, %10, %3) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %29 = "llvm.insertelement"(%28, %9, %2) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %30 = "llvm.insertelement"(%12, %10, %13) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %31 = "llvm.insertelement"(%30, %10, %8) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %32 = "llvm.insertelement"(%31, %10, %7) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %33 = "llvm.insertelement"(%32, %9, %6) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %34 = "llvm.insertelement"(%33, %10, %5) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %35 = "llvm.insertelement"(%34, %10, %4) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %36 = "llvm.insertelement"(%35, %10, %3) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %37 = "llvm.insertelement"(%36, %1, %2) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %38 = "llvm.load"(%arg1) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %39 = "llvm.sub"(%21, %38) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %40 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %41 = "llvm.load"(%40) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %42 = "llvm.sub"(%29, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %43 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %44 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %45 = "llvm.load"(%44) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %46 = "llvm.sub"(%37, %45) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %47 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %48 = "llvm.shufflevector"(%38, %39) <{mask = array<i32: 1, 0, 2, 11, 5, 4, 6, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %49 = "llvm.shufflevector"(%41, %42) <{mask = array<i32: 1, 0, 2, 11, 5, 4, 6, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %50 = "llvm.shufflevector"(%45, %46) <{mask = array<i32: 1, 0, 2, 11, 5, 4, 6, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %51 = "llvm.sub"(%0, %arg2) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  %52 = "llvm.bitcast"(%51) : (i8) -> vector<8xi1>
  %53 = "llvm.select"(%52, %48, %38) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%53, %arg0) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %54 = "llvm.select"(%52, %49, %41) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%54, %43) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %55 = "llvm.select"(%52, %50, %45) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%55, %47) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end Firedancer.LaneNI.Mlir
