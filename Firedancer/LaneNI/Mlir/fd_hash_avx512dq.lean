
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab



namespace Firedancer.LaneNI.Mlir

@[expose] public section

mlir_def fd_hash_avx512dq := "llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.noundef}, {llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.noundef}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<i64 (i64, ptr, i64)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "256"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], sym_name = "fd_hash_avx512dq", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: i64, %arg1: !llvm.ptr, %arg2: i64):
  %0 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %1 = "llvm.mlir.poison"() : () -> vector<4xi64>
  %2 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %3 = "llvm.mlir.constant"() <{value = dense<[6983438078262162902, -4417276706812531889, 0, 7046029288634856825]> : vector<4xi64>}> : () -> vector<4xi64>
  %4 = "llvm.mlir.constant"() <{value = dense<-4417276706812531889> : vector<4xi64>}> : () -> vector<4xi64>
  %5 = "llvm.mlir.constant"() <{value = dense<31> : vector<4xi64>}> : () -> vector<4xi64>
  %6 = "llvm.mlir.constant"() <{value = dense<-7046029288634856825> : vector<4xi64>}> : () -> vector<4xi64>
  %7 = "llvm.mlir.constant"() <{value = dense<[1, 7, 12, 18]> : vector<4xi64>}> : () -> vector<4xi64>
  %8 = "llvm.mlir.constant"() <{value = dense<-2381459717836149591> : vector<4xi64>}> : () -> vector<4xi64>
  %9 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %10 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %11 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %12 = "llvm.mlir.constant"() <{value = -7046029288634856825 : i64}> : () -> i64
  %13 = "llvm.mlir.constant"() <{value = -8796714831421723037 : i64}> : () -> i64
  %14 = "llvm.mlir.constant"() <{value = 2870177450012600261 : i64}> : () -> i64
  %15 = "llvm.mlir.constant"() <{value = -4417276706812531889 : i64}> : () -> i64
  %16 = "llvm.mlir.constant"() <{value = -7788283243316379648 : i64}> : () -> i64
  %17 = "llvm.mlir.constant"() <{value = 33 : i64}> : () -> i64
  %18 = "llvm.mlir.constant"() <{value = 27 : i64}> : () -> i64
  %19 = "llvm.mlir.constant"() <{value = 23 : i64}> : () -> i64
  %20 = "llvm.mlir.constant"() <{value = 1609587929392839161 : i64}> : () -> i64
  %21 = "llvm.mlir.constant"() <{value = 11 : i64}> : () -> i64
  %22 = "llvm.mlir.constant"() <{value = 29 : i64}> : () -> i64
  %23 = "llvm.ptrtoint"(%arg1) : (!llvm.ptr) -> i64
  %24 = "llvm.getelementptr"(%arg1, %arg2) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %25 = "llvm.icmp"(%arg2, %0) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%25)[^bb1, ^bb2] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb1:  // pred: ^bb0
  %26 = "llvm.add"(%arg0, %14) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.br"(%26, %arg1)[^bb5] : (i64, !llvm.ptr) -> ()
^bb2:  // pred: ^bb0
  %27 = "llvm.getelementptr"(%24) <{elem_type = i8, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -32>}> : (!llvm.ptr) -> !llvm.ptr
  %28 = "llvm.insertelement"(%1, %arg0, %2) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %29 = "llvm.shufflevector"(%28, %1) <{mask = array<i32: 0, 0, 0, 0>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %30 = "llvm.add"(%29, %3) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.br"(%30, %arg1)[^bb3] : (vector<4xi64>, !llvm.ptr) -> ()
^bb3(%31: vector<4xi64>, %32: !llvm.ptr):  // 2 preds: ^bb2, ^bb3
  %33 = "llvm.load"(%32) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<4xi64>
  %34 = "llvm.mul"(%33, %4) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %35 = "llvm.add"(%34, %31) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %36 = "llvm.intr.fshl"(%35, %35, %5) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %37 = "llvm.mul"(%36, %6) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %38 = "llvm.getelementptr"(%32) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %39 = "llvm.icmp"(%38, %27) <{predicate = 8 : i64}> : (!llvm.ptr, !llvm.ptr) -> i1
  "llvm.cond_br"(%39, %37, %38)[^bb4, ^bb3] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 2>}> : (i1, vector<4xi64>, !llvm.ptr) -> ()
^bb4:  // pred: ^bb3
  %40 = "llvm.intr.fshl"(%37, %37, %7) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %41 = "llvm.shufflevector"(%40, %1) <{mask = array<i32: 1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %42 = "llvm.add"(%40, %41) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %43 = "llvm.shufflevector"(%40, %1) <{mask = array<i32: 2, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %44 = "llvm.add"(%42, %43) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %45 = "llvm.shufflevector"(%40, %1) <{mask = array<i32: 3, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %46 = "llvm.add"(%44, %45) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %47 = "llvm.mul"(%36, %8) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %48 = "llvm.intr.fshl"(%47, %47, %5) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %49 = "llvm.mul"(%48, %6) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %50 = "llvm.extractelement"(%49, %9) : (vector<4xi64>, i64) -> i64
  %51 = "llvm.extractelement"(%49, %10) : (vector<4xi64>, i64) -> i64
  %52 = "llvm.extractelement"(%49, %11) : (vector<4xi64>, i64) -> i64
  %53 = "llvm.xor"(%46, %49) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %54 = "llvm.extractelement"(%53, %2) : (vector<4xi64>, i64) -> i64
  %55 = "llvm.mul"(%54, %12) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %56 = "llvm.add"(%55, %13) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %57 = "llvm.xor"(%56, %50) : (i64, i64) -> i64
  %58 = "llvm.mul"(%57, %12) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %59 = "llvm.add"(%58, %13) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %60 = "llvm.xor"(%59, %51) : (i64, i64) -> i64
  %61 = "llvm.mul"(%60, %12) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %62 = "llvm.add"(%61, %13) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %63 = "llvm.xor"(%62, %52) : (i64, i64) -> i64
  %64 = "llvm.mul"(%63, %12) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %65 = "llvm.add"(%64, %13) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.br"(%65, %38)[^bb5] : (i64, !llvm.ptr) -> ()
^bb5(%66: i64, %67: !llvm.ptr):  // 2 preds: ^bb1, ^bb4
  %68 = "llvm.add"(%66, %arg2) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %69 = "llvm.getelementptr"(%67) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %70 = "llvm.icmp"(%69, %24) <{predicate = 8 : i64}> : (!llvm.ptr, !llvm.ptr) -> i1
  "llvm.cond_br"(%70, %68, %67, %69, %67, %68)[^bb7, ^bb6] <{operandSegmentSizes = array<i32: 1, 2, 3>}> : (i1, i64, !llvm.ptr, !llvm.ptr, !llvm.ptr, i64) -> ()
^bb6(%71: !llvm.ptr, %72: !llvm.ptr, %73: i64):  // 2 preds: ^bb5, ^bb6
  %74 = "llvm.load"(%72) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %75 = "llvm.mul"(%74, %15) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %76 = "llvm.mul"(%74, %16) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %77 = "llvm.lshr"(%75, %17) : (i64, i64) -> i64
  %78 = "llvm.or"(%77, %76) <{isDisjoint}> : (i64, i64) -> i64
  %79 = "llvm.mul"(%78, %12) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %80 = "llvm.xor"(%79, %73) : (i64, i64) -> i64
  %81 = "llvm.intr.fshl"(%80, %80, %18) : (i64, i64, i64) -> i64
  %82 = "llvm.mul"(%81, %12) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %83 = "llvm.add"(%82, %13) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %84 = "llvm.getelementptr"(%71) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %85 = "llvm.icmp"(%84, %24) <{predicate = 8 : i64}> : (!llvm.ptr, !llvm.ptr) -> i1
  "llvm.cond_br"(%85, %83, %71, %84, %71, %83)[^bb7, ^bb6] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 2, 3>}> : (i1, i64, !llvm.ptr, !llvm.ptr, !llvm.ptr, i64) -> ()
^bb7(%86: i64, %87: !llvm.ptr):  // 2 preds: ^bb5, ^bb6
  %88 = "llvm.getelementptr"(%87) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4>}> : (!llvm.ptr) -> !llvm.ptr
  %89 = "llvm.icmp"(%88, %24) <{predicate = 8 : i64}> : (!llvm.ptr, !llvm.ptr) -> i1
  "llvm.cond_br"(%89, %86, %87)[^bb9, ^bb8] <{operandSegmentSizes = array<i32: 1, 2, 0>}> : (i1, i64, !llvm.ptr) -> ()
^bb8:  // pred: ^bb7
  %90 = "llvm.load"(%87) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %91 = "llvm.zext"(%90) : (i32) -> i64
  %92 = "llvm.mul"(%91, %12) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %93 = "llvm.xor"(%92, %86) : (i64, i64) -> i64
  %94 = "llvm.intr.fshl"(%93, %93, %19) : (i64, i64, i64) -> i64
  %95 = "llvm.mul"(%94, %15) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %96 = "llvm.add"(%95, %20) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.br"(%96, %88)[^bb9] : (i64, !llvm.ptr) -> ()
^bb9(%97: i64, %98: !llvm.ptr):  // 2 preds: ^bb7, ^bb8
  %99 = "llvm.icmp"(%98, %24) <{predicate = 6 : i64}> : (!llvm.ptr, !llvm.ptr) -> i1
  "llvm.cond_br"(%99, %97)[^bb10, ^bb12] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb10:  // pred: ^bb9
  %100 = "llvm.ptrtoint"(%98) : (!llvm.ptr) -> i64
  %101 = "llvm.add"(%arg2, %23) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %102 = "llvm.sub"(%101, %100) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %103 = "llvm.getelementptr"(%98, %102) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.br"(%98, %97)[^bb11] : (!llvm.ptr, i64) -> ()
^bb11(%104: !llvm.ptr, %105: i64):  // 2 preds: ^bb10, ^bb11
  %106 = "llvm.load"(%104) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %107 = "llvm.zext"(%106) : (i8) -> i64
  %108 = "llvm.mul"(%107, %14) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %109 = "llvm.xor"(%108, %105) : (i64, i64) -> i64
  %110 = "llvm.intr.fshl"(%109, %109, %21) : (i64, i64, i64) -> i64
  %111 = "llvm.mul"(%110, %12) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %112 = "llvm.getelementptr"(%104) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1>}> : (!llvm.ptr) -> !llvm.ptr
  %113 = "llvm.icmp"(%112, %103) <{predicate = 0 : i64}> : (!llvm.ptr, !llvm.ptr) -> i1
  "llvm.cond_br"(%113, %111, %112, %111)[^bb12, ^bb11] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 1, 2>}> : (i1, i64, !llvm.ptr, i64) -> ()
^bb12(%114: i64):  // 2 preds: ^bb9, ^bb11
  %115 = "llvm.lshr"(%114, %17) : (i64, i64) -> i64
  %116 = "llvm.xor"(%115, %114) : (i64, i64) -> i64
  %117 = "llvm.mul"(%116, %15) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %118 = "llvm.lshr"(%117, %22) : (i64, i64) -> i64
  %119 = "llvm.xor"(%118, %117) : (i64, i64) -> i64
  %120 = "llvm.mul"(%119, %20) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %121 = "llvm.lshr"(%120, %0) : (i64, i64) -> i64
  %122 = "llvm.xor"(%121, %120) : (i64, i64) -> i64
  "llvm.return"(%122) : (i64) -> ()
}) : () -> ()

end

end Firedancer.LaneNI.Mlir
