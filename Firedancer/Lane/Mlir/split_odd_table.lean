
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.Lane.Mlir.fd_ed25519_point_dbln
public import Firedancer.Lane.Mlir.fd_ed25519_point_add_with_opts

namespace Firedancer.Lane.Mlir

@[expose] public section

mlir_def split_odd_table := "llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.noundef, llvm.range = #llvm.constant_range<i32, 4, 129>}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr, i32)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], sym_name = "split_odd_table", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: i32):
  %0 = "llvm.mlir.constant"() <{value = dense<24> : vector<8xi64>}> : () -> vector<8xi64>
  %1 = "llvm.mlir.constant"() <{value = dense<7> : vector<8xi64>}> : () -> vector<8xi64>
  %2 = "llvm.mlir.constant"() <{value = dense<9> : vector<8xi64>}> : () -> vector<8xi64>
  %3 = "llvm.mlir.constant"() <{value = dense<[0, 0, 0, 15037786634, 0, 0, 0, 309467527341]> : vector<8xi64>}> : () -> vector<8xi64>
  %4 = "llvm.mlir.constant"() <{value = dense<[0, 0, 0, 507525298899, 0, 0, 0, 6596238350568]> : vector<8xi64>}> : () -> vector<8xi64>
  %5 = "llvm.mlir.constant"() <{value = dense<[1, 1, 1, 3934839304537, 0, 0, 0, 521695520920]> : vector<8xi64>}> : () -> vector<8xi64>
  %6 = "llvm.mlir.constant"() <{value = dense<0> : vector<8xi64>}> : () -> vector<8xi64>
  %7 = "llvm.mlir.constant"() <{value = dense<[8796093022207, 8796093022207, 8796093022207, 8796093022207, 1099511627775, 1099511627775, 1099511627775, 1099511627775]> : vector<8xi64>}> : () -> vector<8xi64>
  %8 = "llvm.mlir.constant"() <{value = dense<1048576> : vector<8xi64>}> : () -> vector<8xi64>
  %9 = "llvm.mlir.constant"() <{value = dense<[159383552, 159383552, 159383552, 159383552, 1048576, 1048576, 1048576, 1048576]> : vector<8xi64>}> : () -> vector<8xi64>
  %10 = "llvm.mlir.constant"() <{value = dense<8796093022207> : vector<8xi64>}> : () -> vector<8xi64>
  %11 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %12 = "llvm.mlir.constant"() <{value = dense<[43, 43, 43, 43, 40, 40, 40, 40]> : vector<8xi64>}> : () -> vector<8xi64>
  %13 = "llvm.mlir.constant"() <{value = dense<43> : vector<8xi64>}> : () -> vector<8xi64>
  %14 = "llvm.mlir.constant"() <{value = dense<-1048576> : vector<8xi64>}> : () -> vector<8xi64>
  %15 = "llvm.mlir.constant"() <{value = dense<[-159383552, -159383552, -159383552, -159383552, -1048576, -1048576, -1048576, -1048576]> : vector<8xi64>}> : () -> vector<8xi64>
  %16 = "llvm.mlir.constant"() <{value = 1099511627775 : i64}> : () -> i64
  %17 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %18 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %19 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %20 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %21 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %22 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %23 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %24 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %25 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %26 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %27 = "llvm.mlir.poison"() : () -> vector<8xi64>
  %28 = "llvm.mlir.poison"() : () -> i64
  %29 = "llvm.mlir.constant"() <{value = 8796093022207 : i64}> : () -> i64
  %30 = "llvm.mlir.constant"() <{value = 8796093022189 : i64}> : () -> i64
  %31 = "llvm.mlir.undef"() : () -> vector<8xi64>
  %32 = "llvm.insertelement"(%31, %30, %25) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %33 = "llvm.insertelement"(%32, %28, %23) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %34 = "llvm.insertelement"(%33, %28, %22) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %35 = "llvm.insertelement"(%34, %28, %21) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %36 = "llvm.insertelement"(%35, %29, %20) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %37 = "llvm.insertelement"(%36, %28, %19) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %38 = "llvm.insertelement"(%37, %28, %18) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %39 = "llvm.insertelement"(%38, %28, %17) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %40 = "llvm.insertelement"(%31, %29, %25) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %41 = "llvm.insertelement"(%40, %28, %23) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %42 = "llvm.insertelement"(%41, %28, %22) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %43 = "llvm.insertelement"(%42, %28, %21) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %44 = "llvm.insertelement"(%43, %29, %20) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %45 = "llvm.insertelement"(%44, %28, %19) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %46 = "llvm.insertelement"(%45, %28, %18) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %47 = "llvm.insertelement"(%46, %28, %17) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %48 = "llvm.insertelement"(%31, %29, %25) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %49 = "llvm.insertelement"(%48, %28, %23) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %50 = "llvm.insertelement"(%49, %28, %22) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %51 = "llvm.insertelement"(%50, %28, %21) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %52 = "llvm.insertelement"(%51, %16, %20) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %53 = "llvm.insertelement"(%52, %28, %19) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %54 = "llvm.insertelement"(%53, %28, %18) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %55 = "llvm.insertelement"(%54, %28, %17) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %56 = "llvm.insertelement"(%31, %28, %25) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %57 = "llvm.insertelement"(%56, %28, %23) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %58 = "llvm.insertelement"(%57, %28, %22) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %59 = "llvm.insertelement"(%58, %28, %21) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %60 = "llvm.insertelement"(%59, %11, %20) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %61 = "llvm.insertelement"(%60, %11, %19) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %62 = "llvm.insertelement"(%61, %11, %18) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %63 = "llvm.insertelement"(%62, %11, %17) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %64 = "llvm.alloca"(%23) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_curve25519_edwards", (vector<8xi64>, vector<8xi64>, vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%64) : (!llvm.ptr) -> ()
  %65 = "llvm.load"(%arg1) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.store"(%65, %arg0) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %66 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %67 = "llvm.load"(%66) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %68 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%67, %68) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %69 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %70 = "llvm.load"(%69) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %71 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%70, %71) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %72 = "llvm.call"(%64, %arg1, %23) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_dbln, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> !llvm.ptr
  %73 = "llvm.zext"(%arg2) <{nonNeg}> : (i32) -> i64
  "llvm.br"(%24)[^bb1] : (i64) -> ()
^bb1(%74: i64):  // 2 preds: ^bb0, ^bb1
  %75 = "llvm.getelementptr"(%arg0, %74) <{elem_type = !llvm.array<192 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %76 = "llvm.getelementptr"(%75) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -192>}> : (!llvm.ptr) -> !llvm.ptr
  %77 = "llvm.call"(%75, %64, %76, %25) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.noundef, llvm.readonly}, {llvm.noundef}], callee = @fd_ed25519_point_add_with_opts, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, i32) -> !llvm.ptr
  %78 = "llvm.add"(%74, %24) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %79 = "llvm.icmp"(%78, %73) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%79, %26, %78)[^bb3, ^bb1] <{loop_annotation = #llvm.loop_annotation<mustProgress = true>, operandSegmentSizes = array<i32: 1, 1, 1>}> : (i1, i64, i64) -> ()
^bb2:  // pred: ^bb3
  "llvm.intr.lifetime.end"(%64) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
^bb3(%80: i64):  // 2 preds: ^bb1, ^bb3
  %81 = "llvm.getelementptr"(%arg0, %80) <{elem_type = !llvm.array<192 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %82 = "llvm.load"(%81) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %83 = "llvm.shufflevector"(%82, %27) <{mask = array<i32: 1, -1, -1, -1, 5, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %84 = "llvm.getelementptr"(%81) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %85 = "llvm.load"(%84) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %86 = "llvm.shufflevector"(%85, %27) <{mask = array<i32: 1, -1, -1, -1, 5, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %87 = "llvm.getelementptr"(%81) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %88 = "llvm.load"(%87) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %89 = "llvm.shufflevector"(%88, %27) <{mask = array<i32: 1, -1, -1, -1, 5, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %90 = "llvm.sub"(%83, %82) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %91 = "llvm.add"(%90, %39) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %92 = "llvm.shufflevector"(%91, %82) <{mask = array<i32: 0, 8, 10, 11, 4, 12, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %93 = "llvm.sub"(%86, %85) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %94 = "llvm.add"(%93, %47) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %95 = "llvm.shufflevector"(%94, %85) <{mask = array<i32: 0, 8, 10, 11, 4, 12, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %96 = "llvm.sub"(%89, %88) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %97 = "llvm.add"(%96, %55) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %98 = "llvm.shufflevector"(%97, %88) <{mask = array<i32: 0, 8, 10, 11, 4, 12, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %99 = "llvm.add"(%92, %82) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %100 = "llvm.shufflevector"(%92, %99) <{mask = array<i32: 0, 9, 2, 3, 4, 13, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %101 = "llvm.add"(%95, %85) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %102 = "llvm.shufflevector"(%95, %101) <{mask = array<i32: 0, 9, 2, 3, 4, 13, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %103 = "llvm.add"(%98, %88) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %104 = "llvm.shufflevector"(%98, %103) <{mask = array<i32: 0, 9, 2, 3, 4, 13, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %105 = "llvm.add"(%100, %15) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %106 = "llvm.add"(%102, %14) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %107 = "llvm.add"(%104, %14) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %108 = "llvm.ashr"(%105, %13) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %109 = "llvm.ashr"(%106, %13) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %110 = "llvm.ashr"(%107, %12) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %111 = "llvm.mul"(%110, %63) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %112 = "llvm.and"(%105, %10) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %113 = "llvm.shufflevector"(%111, %110) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %114 = "llvm.add"(%112, %9) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %115 = "llvm.add"(%114, %113) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %116 = "llvm.and"(%106, %10) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %117 = "llvm.add"(%108, %8) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %118 = "llvm.add"(%117, %116) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %119 = "llvm.and"(%107, %7) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %120 = "llvm.add"(%109, %8) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %121 = "llvm.add"(%120, %119) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %122 = "llvm.shufflevector"(%115, %27) <{mask = array<i32: 0, 1, 2, 3, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %123 = "llvm.shufflevector"(%118, %27) <{mask = array<i32: 0, 1, 2, 3, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %124 = "llvm.shufflevector"(%121, %27) <{mask = array<i32: 0, 1, 2, 3, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %125 = "llvm.shufflevector"(%115, %27) <{mask = array<i32: 4, 5, 6, 7, 4, 5, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %126 = "llvm.shufflevector"(%118, %27) <{mask = array<i32: 4, 5, 6, 7, 4, 5, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %127 = "llvm.shufflevector"(%121, %27) <{mask = array<i32: 4, 5, 6, 7, 4, 5, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %128 = "llvm.call_intrinsic"(%6, %122, %5) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %129 = "llvm.call_intrinsic"(%6, %123, %5) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %130 = "llvm.call_intrinsic"(%129, %122, %4) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %131 = "llvm.call_intrinsic"(%6, %124, %5) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %132 = "llvm.call_intrinsic"(%131, %123, %4) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %133 = "llvm.call_intrinsic"(%132, %122, %3) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %134 = "llvm.call_intrinsic"(%6, %125, %5) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %135 = "llvm.call_intrinsic"(%134, %124, %4) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %136 = "llvm.call_intrinsic"(%135, %123, %3) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %137 = "llvm.call_intrinsic"(%6, %126, %5) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %138 = "llvm.call_intrinsic"(%137, %125, %4) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %139 = "llvm.call_intrinsic"(%138, %124, %3) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %140 = "llvm.call_intrinsic"(%6, %127, %5) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %141 = "llvm.call_intrinsic"(%140, %126, %4) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %142 = "llvm.call_intrinsic"(%141, %125, %3) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %143 = "llvm.call_intrinsic"(%6, %127, %4) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %144 = "llvm.call_intrinsic"(%143, %126, %3) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %145 = "llvm.call_intrinsic"(%6, %122, %5) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %146 = "llvm.shl"(%145, %2) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %147 = "llvm.add"(%146, %130) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %148 = "llvm.call_intrinsic"(%6, %123, %5) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %149 = "llvm.call_intrinsic"(%148, %122, %4) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %150 = "llvm.shl"(%149, %2) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %151 = "llvm.add"(%150, %133) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %152 = "llvm.call_intrinsic"(%6, %124, %5) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %153 = "llvm.call_intrinsic"(%152, %123, %4) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %154 = "llvm.call_intrinsic"(%153, %122, %3) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %155 = "llvm.shl"(%154, %2) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %156 = "llvm.add"(%155, %136) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %157 = "llvm.call_intrinsic"(%6, %125, %5) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %158 = "llvm.call_intrinsic"(%157, %124, %4) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %159 = "llvm.call_intrinsic"(%158, %123, %3) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %160 = "llvm.shl"(%159, %2) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %161 = "llvm.add"(%160, %139) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %162 = "llvm.call_intrinsic"(%6, %126, %5) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %163 = "llvm.call_intrinsic"(%162, %125, %4) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %164 = "llvm.call_intrinsic"(%163, %124, %3) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %165 = "llvm.shl"(%164, %2) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %166 = "llvm.add"(%165, %142) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %167 = "llvm.call_intrinsic"(%6, %127, %5) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %168 = "llvm.call_intrinsic"(%167, %126, %4) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %169 = "llvm.call_intrinsic"(%168, %125, %3) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %170 = "llvm.shl"(%169, %2) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %171 = "llvm.add"(%170, %144) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %172 = "llvm.call_intrinsic"(%6, %127, %4) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %173 = "llvm.call_intrinsic"(%172, %126, %3) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %174 = "llvm.shl"(%173, %2) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %175 = "llvm.call_intrinsic"(%174, %127, %3) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %176 = "llvm.call_intrinsic"(%6, %127, %3) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %177 = "llvm.shl"(%176, %2) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %178 = "llvm.shufflevector"(%156, %27) <{mask = array<i32: 4, 5, 6, 7, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %179 = "llvm.shufflevector"(%161, %27) <{mask = array<i32: 4, 5, 6, 7, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %180 = "llvm.shufflevector"(%166, %27) <{mask = array<i32: 4, 5, 6, 7, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %181 = "llvm.add"(%178, %128) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %182 = "llvm.shufflevector"(%128, %181) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %183 = "llvm.add"(%179, %147) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %184 = "llvm.shufflevector"(%147, %183) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %185 = "llvm.add"(%180, %151) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %186 = "llvm.shufflevector"(%151, %185) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %187 = "llvm.add"(%171, %178) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %188 = "llvm.shufflevector"(%187, %171) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %189 = "llvm.add"(%175, %179) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %190 = "llvm.shufflevector"(%189, %175) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %191 = "llvm.add"(%177, %180) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %192 = "llvm.shufflevector"(%191, %177) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %193 = "llvm.shl"(%188, %1) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %194 = "llvm.add"(%193, %182) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %195 = "llvm.mul"(%188, %0) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %196 = "llvm.add"(%194, %195) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %197 = "llvm.shl"(%190, %1) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %198 = "llvm.add"(%197, %184) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %199 = "llvm.mul"(%190, %0) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %200 = "llvm.add"(%198, %199) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %201 = "llvm.shl"(%192, %1) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %202 = "llvm.add"(%201, %186) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %203 = "llvm.mul"(%192, %0) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %204 = "llvm.add"(%202, %203) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %205 = "llvm.lshr"(%196, %13) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %206 = "llvm.lshr"(%200, %13) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %207 = "llvm.lshr"(%204, %12) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %208 = "llvm.mul"(%207, %63) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %209 = "llvm.and"(%196, %10) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %210 = "llvm.shufflevector"(%208, %207) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %211 = "llvm.add"(%210, %209) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%211, %81) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %212 = "llvm.and"(%200, %10) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %213 = "llvm.add"(%212, %205) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%213, %84) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %214 = "llvm.and"(%204, %7) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %215 = "llvm.add"(%214, %206) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%215, %87) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %216 = "llvm.add"(%80, %24) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %217 = "llvm.icmp"(%216, %73) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%217, %216)[^bb2, ^bb3] <{loop_annotation = #llvm.loop_annotation<mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
}) : () -> ()

    with
      @fd_ed25519_point_dbln := Firedancer.Lane.Mlir.fd_ed25519_point_dbln,
      @fd_ed25519_point_add_with_opts := Firedancer.Lane.Mlir.fd_ed25519_point_add_with_opts

end

end Firedancer.Lane.Mlir
