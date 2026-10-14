
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab



namespace Firedancer.Lane.Mlir

@[expose] public section

mlir_def fd_ed25519_lane_bcast_fe := "llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writeonly}, {}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, vector<8xi64>)>, inline_hint, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], sym_name = "fd_ed25519_lane_bcast_fe", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr, %arg1: vector<8xi64>):
  %0 = "llvm.mlir.constant"() <{value = 12 : i64}> : () -> i64
  %1 = "llvm.mlir.constant"() <{value = 153 : i256}> : () -> i256
  %2 = "llvm.mlir.constant"() <{value = 102 : i256}> : () -> i256
  %3 = "llvm.mlir.constant"() <{value = 51 : i256}> : () -> i256
  %4 = "llvm.mlir.constant"() <{value = 2251799813685247 : i64}> : () -> i64
  %5 = "llvm.mlir.constant"() <{value = 44 : i64}> : () -> i64
  %6 = "llvm.mlir.constant"() <{value = 22 : i64}> : () -> i64
  %7 = "llvm.mlir.constant"() <{value = 23 : i64}> : () -> i64
  %8 = "llvm.mlir.poison"() : () -> vector<8xi64>
  %9 = "llvm.mlir.constant"() <{value = 21 : i64}> : () -> i64
  %10 = "llvm.mlir.constant"() <{value = 42 : i64}> : () -> i64
  %11 = "llvm.mlir.constant"() <{value = 20 : i64}> : () -> i64
  %12 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %13 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %14 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %15 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %16 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %17 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %18 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %19 = "llvm.mlir.constant"() <{value = 320 : i64}> : () -> i64
  %20 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %21 = "llvm.mlir.constant"() <{value = 8 : i64}> : () -> i64
  %22 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
  %23 = "llvm.mlir.constant"() <{value = 8796093022207 : i64}> : () -> i64
  %24 = "llvm.mlir.constant"() <{value = 43 : i64}> : () -> i64
  %25 = "llvm.mlir.constant"() <{value = 1099511627775 : i64}> : () -> i64
  %26 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %27 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %28 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %29 = "llvm.mlir.constant"() <{value = 1099511627776 : i64}> : () -> i64
  %30 = "llvm.mlir.constant"() <{value = -19 : i64}> : () -> i64
  %31 = "llvm.mlir.poison"() : () -> vector<4xi64>
  %32 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %33 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %34 = "llvm.mlir.constant"() <{value = dense<8796093022207> : vector<4xi64>}> : () -> vector<4xi64>
  %35 = "llvm.mlir.poison"() : () -> vector<2xi64>
  %36 = "llvm.mlir.constant"() <{value = dense<[8796093022207, -1]> : vector<2xi64>}> : () -> vector<2xi64>
  %37 = "llvm.mlir.poison"() : () -> i64
  %38 = "llvm.mlir.undef"() : () -> vector<8xi64>
  %39 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %40 = "llvm.insertelement"(%38, %37, %39) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %41 = "llvm.insertelement"(%40, %37, %18) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %42 = "llvm.insertelement"(%41, %37, %17) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %43 = "llvm.insertelement"(%42, %37, %16) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %44 = "llvm.insertelement"(%43, %37, %15) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %45 = "llvm.insertelement"(%44, %37, %14) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %46 = "llvm.insertelement"(%45, %20, %13) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %47 = "llvm.insertelement"(%46, %20, %12) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %48 = "llvm.insertelement"(%38, %20, %39) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %49 = "llvm.insertelement"(%48, %9, %18) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %50 = "llvm.insertelement"(%49, %10, %17) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %51 = "llvm.insertelement"(%50, %37, %16) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %52 = "llvm.insertelement"(%51, %11, %15) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %53 = "llvm.insertelement"(%52, %37, %14) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %54 = "llvm.insertelement"(%53, %37, %13) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %55 = "llvm.insertelement"(%54, %37, %12) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %56 = "llvm.insertelement"(%38, %20, %39) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %57 = "llvm.insertelement"(%56, %24, %18) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %58 = "llvm.insertelement"(%57, %6, %17) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %59 = "llvm.insertelement"(%58, %28, %16) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %60 = "llvm.insertelement"(%59, %37, %15) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %61 = "llvm.insertelement"(%60, %7, %14) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %62 = "llvm.insertelement"(%61, %37, %13) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %63 = "llvm.insertelement"(%62, %37, %12) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %64 = "llvm.insertelement"(%38, %20, %39) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %65 = "llvm.insertelement"(%64, %24, %18) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %66 = "llvm.insertelement"(%65, %6, %17) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %67 = "llvm.insertelement"(%66, %37, %16) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %68 = "llvm.insertelement"(%67, %5, %15) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %69 = "llvm.insertelement"(%68, %7, %14) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %70 = "llvm.insertelement"(%69, %37, %13) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %71 = "llvm.insertelement"(%70, %37, %12) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %72 = "llvm.alloca"(%18) <{alignment = 16 : i64, elem_type = !llvm.array<5 x array<8 x i64>>}> : (i32) -> !llvm.ptr
  %73 = "llvm.alloca"(%18) <{alignment = 64 : i64, elem_type = !llvm.array<8 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%73) : (!llvm.ptr) -> ()
  "llvm.store"(%arg1, %73) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %74 = "llvm.getelementptr"(%73) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%arg1, %74) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %75 = "llvm.getelementptr"(%73) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%arg1, %75) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %76 = "llvm.getelementptr"(%73) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 192>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%arg1, %76) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %77 = "llvm.getelementptr"(%73) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 256>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%arg1, %77) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %78 = "llvm.getelementptr"(%73) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 320>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%arg1, %78) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %79 = "llvm.getelementptr"(%73) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 384>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%arg1, %79) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %80 = "llvm.getelementptr"(%73) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 448>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%arg1, %80) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%72) : (!llvm.ptr) -> ()
  %81 = "llvm.getelementptr"(%72) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %82 = "llvm.getelementptr"(%72) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %83 = "llvm.getelementptr"(%72) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 192>}> : (!llvm.ptr) -> !llvm.ptr
  %84 = "llvm.getelementptr"(%72) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 256>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.br"(%20)[^bb1] : (i64) -> ()
^bb1(%85: i64):  // 2 preds: ^bb0, ^bb1
  %86 = "llvm.getelementptr"(%73, %85) <{elem_type = !llvm.array<64 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %87 = "llvm.load"(%86) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %88 = "llvm.getelementptr"(%86) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %89 = "llvm.load"(%88) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %90 = "llvm.getelementptr"(%86) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %91 = "llvm.load"(%90) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %92 = "llvm.getelementptr"(%86) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %93 = "llvm.load"(%92) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %94 = "llvm.getelementptr"(%86) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %95 = "llvm.load"(%94) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %96 = "llvm.getelementptr"(%86) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  %97 = "llvm.load"(%96) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %98 = "llvm.and"(%87, %23) : (i64, i64) -> i64
  %99 = "llvm.ashr"(%97, %22) : (i64, i64) -> i64
  %100 = "llvm.and"(%89, %23) : (i64, i64) -> i64
  %101 = "llvm.ashr"(%87, %24) : (i64, i64) -> i64
  %102 = "llvm.add"(%100, %101) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %103 = "llvm.and"(%91, %23) : (i64, i64) -> i64
  %104 = "llvm.ashr"(%89, %24) : (i64, i64) -> i64
  %105 = "llvm.add"(%103, %104) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %106 = "llvm.and"(%93, %23) : (i64, i64) -> i64
  %107 = "llvm.ashr"(%91, %24) : (i64, i64) -> i64
  %108 = "llvm.add"(%106, %107) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %109 = "llvm.and"(%95, %23) : (i64, i64) -> i64
  %110 = "llvm.ashr"(%93, %24) : (i64, i64) -> i64
  %111 = "llvm.add"(%109, %110) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %112 = "llvm.and"(%97, %25) : (i64, i64) -> i64
  %113 = "llvm.ashr"(%95, %24) : (i64, i64) -> i64
  %114 = "llvm.add"(%113, %26) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %115 = "llvm.add"(%114, %112) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %116 = "llvm.ashr"(%115, %22) : (i64, i64) -> i64
  %117 = "llvm.and"(%115, %25) : (i64, i64) -> i64
  %118 = "llvm.add"(%116, %99) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %119 = "llvm.mul"(%118, %27) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %120 = "llvm.add"(%119, %98) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %121 = "llvm.ashr"(%120, %24) : (i64, i64) -> i64
  %122 = "llvm.and"(%120, %23) : (i64, i64) -> i64
  %123 = "llvm.add"(%102, %121) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %124 = "llvm.ashr"(%123, %24) : (i64, i64) -> i64
  %125 = "llvm.and"(%123, %23) : (i64, i64) -> i64
  %126 = "llvm.add"(%105, %124) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %127 = "llvm.ashr"(%126, %24) : (i64, i64) -> i64
  %128 = "llvm.and"(%126, %23) : (i64, i64) -> i64
  %129 = "llvm.add"(%108, %127) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %130 = "llvm.ashr"(%129, %24) : (i64, i64) -> i64
  %131 = "llvm.and"(%129, %23) : (i64, i64) -> i64
  %132 = "llvm.add"(%111, %130) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %133 = "llvm.ashr"(%132, %24) : (i64, i64) -> i64
  %134 = "llvm.and"(%132, %23) : (i64, i64) -> i64
  %135 = "llvm.add"(%122, %27) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %136 = "llvm.lshr"(%135, %24) : (i64, i64) -> i64
  %137 = "llvm.and"(%135, %23) : (i64, i64) -> i64
  %138 = "llvm.add"(%125, %136) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %139 = "llvm.lshr"(%138, %24) : (i64, i64) -> i64
  %140 = "llvm.and"(%138, %23) : (i64, i64) -> i64
  %141 = "llvm.add"(%128, %139) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %142 = "llvm.lshr"(%141, %24) : (i64, i64) -> i64
  %143 = "llvm.and"(%141, %23) : (i64, i64) -> i64
  %144 = "llvm.add"(%131, %142) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %145 = "llvm.lshr"(%144, %24) : (i64, i64) -> i64
  %146 = "llvm.and"(%144, %23) : (i64, i64) -> i64
  %147 = "llvm.add"(%134, %145) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %148 = "llvm.lshr"(%147, %24) : (i64, i64) -> i64
  %149 = "llvm.and"(%147, %23) : (i64, i64) -> i64
  %150 = "llvm.add"(%117, %28) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %151 = "llvm.add"(%150, %133) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %152 = "llvm.add"(%151, %148) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %153 = "llvm.and"(%152, %25) : (i64, i64) -> i64
  %154 = "llvm.icmp"(%152, %29) <{predicate = 6 : i64}> : (i64, i64) -> i1
  %155 = "llvm.select"(%154, %30, %20) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %156 = "llvm.add"(%155, %137) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %157 = "llvm.ashr"(%156, %24) : (i64, i64) -> i64
  %158 = "llvm.add"(%157, %140) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %159 = "llvm.ashr"(%158, %24) : (i64, i64) -> i64
  %160 = "llvm.add"(%159, %143) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %161 = "llvm.ashr"(%160, %24) : (i64, i64) -> i64
  %162 = "llvm.add"(%161, %146) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %163 = "llvm.ashr"(%162, %24) : (i64, i64) -> i64
  %164 = "llvm.insertelement"(%31, %156, %20) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %165 = "llvm.insertelement"(%164, %158, %28) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %166 = "llvm.insertelement"(%165, %160, %32) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %167 = "llvm.insertelement"(%166, %162, %33) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %168 = "llvm.and"(%167, %34) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %169 = "llvm.add"(%163, %149) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %170 = "llvm.ashr"(%169, %24) : (i64, i64) -> i64
  %171 = "llvm.add"(%170, %153) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %172 = "llvm.insertelement"(%35, %169, %20) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  %173 = "llvm.insertelement"(%172, %171, %28) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  %174 = "llvm.and"(%173, %36) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %175 = "llvm.shufflevector"(%168, %31) <{mask = array<i32: 0, 1, 2, 3, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %176 = "llvm.shufflevector"(%175, %47) <{mask = array<i32: 0, 1, 2, 3, -1, -1, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %177 = "llvm.shufflevector"(%174, %35) <{mask = array<i32: 0, 1, -1, -1, -1, -1, -1, -1>}> : (vector<2xi64>, vector<2xi64>) -> vector<8xi64>
  %178 = "llvm.shufflevector"(%176, %177) <{mask = array<i32: 0, 1, 2, 3, 8, 9, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %179 = "llvm.lshr"(%178, %55) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %180 = "llvm.shufflevector"(%179, %8) <{mask = array<i32: 0, 1, 2, 4, -1, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %181 = "llvm.shl"(%178, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %182 = "llvm.shufflevector"(%181, %8) <{mask = array<i32: 1, 2, 3, 5, -1, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %183 = "llvm.shl"(%178, %71) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %184 = "llvm.shufflevector"(%183, %8) <{mask = array<i32: 1, 2, 4, 5, -1, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %185 = "llvm.or"(%180, %182) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %186 = "llvm.or"(%185, %184) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %187 = "llvm.bitcast"(%186) : (vector<8xi64>) -> vector<2xi256>
  %188 = "llvm.extractelement"(%187, %20) : (vector<2xi256>, i64) -> i256
  %189 = "llvm.trunc"(%188) <{overflowFlags = 0 : i32}> : (i256) -> i64
  %190 = "llvm.and"(%189, %4) : (i64, i64) -> i64
  %191 = "llvm.getelementptr"(%72, %85) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%190, %191) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %192 = "llvm.lshr"(%188, %3) : (i256, i256) -> i256
  %193 = "llvm.trunc"(%192) <{overflowFlags = 0 : i32}> : (i256) -> i64
  %194 = "llvm.and"(%193, %4) : (i64, i64) -> i64
  %195 = "llvm.getelementptr"(%81, %85) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%194, %195) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %196 = "llvm.lshr"(%188, %2) : (i256, i256) -> i256
  %197 = "llvm.trunc"(%196) <{overflowFlags = 0 : i32}> : (i256) -> i64
  %198 = "llvm.and"(%197, %4) : (i64, i64) -> i64
  %199 = "llvm.getelementptr"(%82, %85) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%198, %199) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %200 = "llvm.lshr"(%188, %1) : (i256, i256) -> i256
  %201 = "llvm.trunc"(%200) <{overflowFlags = 0 : i32}> : (i256) -> i64
  %202 = "llvm.and"(%201, %4) : (i64, i64) -> i64
  %203 = "llvm.getelementptr"(%83, %85) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%202, %203) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %204 = "llvm.extractelement"(%186, %33) : (vector<8xi64>, i64) -> i64
  %205 = "llvm.lshr"(%204, %0) : (i64, i64) -> i64
  %206 = "llvm.and"(%205, %4) : (i64, i64) -> i64
  %207 = "llvm.getelementptr"(%84, %85) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%206, %207) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %208 = "llvm.add"(%85, %28) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %209 = "llvm.icmp"(%208, %21) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%209, %208)[^bb2, ^bb1] <{loop_annotation = #llvm.loop_annotation<mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb2:  // pred: ^bb1
  "llvm.intr.memcpy"(%arg0, %72, %19) <{arg_attrs = [{llvm.align = 64 : i64, llvm.dereferenceable = 320 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 16 : i64, llvm.dereferenceable = 320 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.intr.lifetime.end"(%72) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%73) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end Firedancer.Lane.Mlir
