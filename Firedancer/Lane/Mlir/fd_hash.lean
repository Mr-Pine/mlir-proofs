
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab



namespace Firedancer.Lane.Mlir

@[expose] public section

mlir_def fd_hash := "llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<i64 (i64, ptr, i64)>, linkage = #llvm.linkage<external>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "256"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], sym_name = "fd_hash", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
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
  %21 = "llvm.mlir.constant"() <{value = 7 : i64}> : () -> i64
  %22 = "llvm.mlir.poison"() : () -> i64
  %23 = "llvm.mlir.constant"() <{value = 11 : i64}> : () -> i64
  %24 = "llvm.mlir.constant"() <{value = -8 : i64}> : () -> i64
  %25 = "llvm.mlir.constant"() <{value = 29 : i64}> : () -> i64
  %26 = "llvm.ptrtoint"(%arg1) : (!llvm.ptr) -> i64
  %27 = "llvm.getelementptr"(%arg1, %arg2) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %28 = "llvm.icmp"(%arg2, %0) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%28)[^bb1, ^bb2] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb1:  // pred: ^bb0
  %29 = "llvm.add"(%arg0, %14) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.br"(%29, %arg1)[^bb5] : (i64, !llvm.ptr) -> ()
^bb2:  // pred: ^bb0
  %30 = "llvm.getelementptr"(%27) <{elem_type = i8, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -32>}> : (!llvm.ptr) -> !llvm.ptr
  %31 = "llvm.insertelement"(%1, %arg0, %2) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %32 = "llvm.shufflevector"(%31, %1) <{mask = array<i32: 0, 0, 0, 0>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %33 = "llvm.add"(%32, %3) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.br"(%33, %arg1)[^bb3] : (vector<4xi64>, !llvm.ptr) -> ()
^bb3(%34: vector<4xi64>, %35: !llvm.ptr):  // 2 preds: ^bb2, ^bb3
  %36 = "llvm.load"(%35) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<4xi64>
  %37 = "llvm.mul"(%36, %4) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %38 = "llvm.add"(%37, %34) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %39 = "llvm.intr.fshl"(%38, %38, %5) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %40 = "llvm.mul"(%39, %6) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %41 = "llvm.getelementptr"(%35) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %42 = "llvm.icmp"(%41, %30) <{predicate = 8 : i64}> : (!llvm.ptr, !llvm.ptr) -> i1
  "llvm.cond_br"(%42, %40, %41)[^bb4, ^bb3] <{loop_annotation = #llvm.loop_annotation<mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 2>}> : (i1, vector<4xi64>, !llvm.ptr) -> ()
^bb4:  // pred: ^bb3
  %43 = "llvm.intr.fshl"(%40, %40, %7) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %44 = "llvm.shufflevector"(%43, %1) <{mask = array<i32: 1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %45 = "llvm.add"(%43, %44) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %46 = "llvm.shufflevector"(%43, %1) <{mask = array<i32: 2, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %47 = "llvm.add"(%45, %46) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %48 = "llvm.shufflevector"(%43, %1) <{mask = array<i32: 3, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %49 = "llvm.add"(%47, %48) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %50 = "llvm.mul"(%39, %8) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %51 = "llvm.intr.fshl"(%50, %50, %5) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %52 = "llvm.mul"(%51, %6) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %53 = "llvm.extractelement"(%52, %9) : (vector<4xi64>, i64) -> i64
  %54 = "llvm.extractelement"(%52, %10) : (vector<4xi64>, i64) -> i64
  %55 = "llvm.extractelement"(%52, %11) : (vector<4xi64>, i64) -> i64
  %56 = "llvm.xor"(%49, %52) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %57 = "llvm.extractelement"(%56, %2) : (vector<4xi64>, i64) -> i64
  %58 = "llvm.mul"(%57, %12) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %59 = "llvm.add"(%58, %13) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %60 = "llvm.xor"(%59, %53) : (i64, i64) -> i64
  %61 = "llvm.mul"(%60, %12) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %62 = "llvm.add"(%61, %13) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %63 = "llvm.xor"(%62, %54) : (i64, i64) -> i64
  %64 = "llvm.mul"(%63, %12) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %65 = "llvm.add"(%64, %13) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %66 = "llvm.xor"(%65, %55) : (i64, i64) -> i64
  %67 = "llvm.mul"(%66, %12) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %68 = "llvm.add"(%67, %13) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.br"(%68, %41)[^bb5] : (i64, !llvm.ptr) -> ()
^bb5(%69: i64, %70: !llvm.ptr):  // 2 preds: ^bb1, ^bb4
  %71 = "llvm.add"(%69, %arg2) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %72 = "llvm.getelementptr"(%70) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %73 = "llvm.icmp"(%72, %27) <{predicate = 8 : i64}> : (!llvm.ptr, !llvm.ptr) -> i1
  "llvm.cond_br"(%73, %71, %70, %72, %70, %71)[^bb7, ^bb6] <{operandSegmentSizes = array<i32: 1, 2, 3>}> : (i1, i64, !llvm.ptr, !llvm.ptr, !llvm.ptr, i64) -> ()
^bb6(%74: !llvm.ptr, %75: !llvm.ptr, %76: i64):  // 2 preds: ^bb5, ^bb6
  %77 = "llvm.load"(%75) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %78 = "llvm.mul"(%77, %15) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %79 = "llvm.mul"(%77, %16) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %80 = "llvm.lshr"(%78, %17) : (i64, i64) -> i64
  %81 = "llvm.or"(%80, %79) <{isDisjoint}> : (i64, i64) -> i64
  %82 = "llvm.mul"(%81, %12) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %83 = "llvm.xor"(%82, %76) : (i64, i64) -> i64
  %84 = "llvm.intr.fshl"(%83, %83, %18) : (i64, i64, i64) -> i64
  %85 = "llvm.mul"(%84, %12) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %86 = "llvm.add"(%85, %13) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %87 = "llvm.getelementptr"(%74) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %88 = "llvm.icmp"(%87, %27) <{predicate = 8 : i64}> : (!llvm.ptr, !llvm.ptr) -> i1
  "llvm.cond_br"(%88, %86, %74, %87, %74, %86)[^bb7, ^bb6] <{loop_annotation = #llvm.loop_annotation<mustProgress = true>, operandSegmentSizes = array<i32: 1, 2, 3>}> : (i1, i64, !llvm.ptr, !llvm.ptr, !llvm.ptr, i64) -> ()
^bb7(%89: i64, %90: !llvm.ptr):  // 2 preds: ^bb5, ^bb6
  %91 = "llvm.getelementptr"(%90) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4>}> : (!llvm.ptr) -> !llvm.ptr
  %92 = "llvm.icmp"(%91, %27) <{predicate = 8 : i64}> : (!llvm.ptr, !llvm.ptr) -> i1
  "llvm.cond_br"(%92, %89, %90)[^bb9, ^bb8] <{operandSegmentSizes = array<i32: 1, 2, 0>}> : (i1, i64, !llvm.ptr) -> ()
^bb8:  // pred: ^bb7
  %93 = "llvm.load"(%90) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %94 = "llvm.zext"(%93) : (i32) -> i64
  %95 = "llvm.mul"(%94, %12) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %96 = "llvm.xor"(%95, %89) : (i64, i64) -> i64
  %97 = "llvm.intr.fshl"(%96, %96, %19) : (i64, i64, i64) -> i64
  %98 = "llvm.mul"(%97, %15) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %99 = "llvm.add"(%98, %20) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.br"(%99, %91)[^bb9] : (i64, !llvm.ptr) -> ()
^bb9(%100: i64, %101: !llvm.ptr):  // 2 preds: ^bb7, ^bb8
  %102 = "llvm.icmp"(%101, %27) <{predicate = 6 : i64}> : (!llvm.ptr, !llvm.ptr) -> i1
  "llvm.cond_br"(%102, %100)[^bb10, ^bb14] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb10:  // pred: ^bb9
  %103 = "llvm.ptrtoint"(%101) : (!llvm.ptr) -> i64
  %104 = "llvm.add"(%arg2, %26) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %105 = "llvm.sub"(%104, %103) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %106 = "llvm.getelementptr"(%101, %105) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %107 = "llvm.and"(%105, %21) : (i64, i64) -> i64
  %108 = "llvm.icmp"(%107, %2) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%108, %22, %101, %100, %101, %100, %2)[^bb12, ^bb11] <{operandSegmentSizes = array<i32: 1, 3, 3>}> : (i1, i64, !llvm.ptr, i64, !llvm.ptr, i64, i64) -> ()
^bb11(%109: !llvm.ptr, %110: i64, %111: i64):  // 2 preds: ^bb10, ^bb11
  %112 = "llvm.load"(%109) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %113 = "llvm.zext"(%112) : (i8) -> i64
  %114 = "llvm.mul"(%113, %14) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %115 = "llvm.xor"(%114, %110) : (i64, i64) -> i64
  %116 = "llvm.intr.fshl"(%115, %115, %23) : (i64, i64, i64) -> i64
  %117 = "llvm.mul"(%116, %12) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %118 = "llvm.getelementptr"(%109) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1>}> : (!llvm.ptr) -> !llvm.ptr
  %119 = "llvm.add"(%111, %9) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %120 = "llvm.icmp"(%119, %107) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%120, %117, %118, %117, %118, %117, %119)[^bb12, ^bb11] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>>, operandSegmentSizes = array<i32: 1, 3, 3>}> : (i1, i64, !llvm.ptr, i64, !llvm.ptr, i64, i64) -> ()
^bb12(%121: i64, %122: !llvm.ptr, %123: i64):  // 2 preds: ^bb10, ^bb11
  %124 = "llvm.sub"(%103, %104) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %125 = "llvm.icmp"(%124, %24) <{predicate = 8 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%125, %121, %122, %123)[^bb14, ^bb13] <{operandSegmentSizes = array<i32: 1, 1, 2>}> : (i1, i64, !llvm.ptr, i64) -> ()
^bb13(%126: !llvm.ptr, %127: i64):  // 2 preds: ^bb12, ^bb13
  %128 = "llvm.load"(%126) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %129 = "llvm.zext"(%128) : (i8) -> i64
  %130 = "llvm.mul"(%129, %14) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %131 = "llvm.xor"(%130, %127) : (i64, i64) -> i64
  %132 = "llvm.intr.fshl"(%131, %131, %23) : (i64, i64, i64) -> i64
  %133 = "llvm.mul"(%132, %12) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %134 = "llvm.getelementptr"(%126) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1>}> : (!llvm.ptr) -> !llvm.ptr
  %135 = "llvm.load"(%134) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %136 = "llvm.zext"(%135) : (i8) -> i64
  %137 = "llvm.mul"(%136, %14) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %138 = "llvm.xor"(%137, %133) : (i64, i64) -> i64
  %139 = "llvm.intr.fshl"(%138, %138, %23) : (i64, i64, i64) -> i64
  %140 = "llvm.mul"(%139, %12) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %141 = "llvm.getelementptr"(%126) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2>}> : (!llvm.ptr) -> !llvm.ptr
  %142 = "llvm.load"(%141) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %143 = "llvm.zext"(%142) : (i8) -> i64
  %144 = "llvm.mul"(%143, %14) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %145 = "llvm.xor"(%144, %140) : (i64, i64) -> i64
  %146 = "llvm.intr.fshl"(%145, %145, %23) : (i64, i64, i64) -> i64
  %147 = "llvm.mul"(%146, %12) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %148 = "llvm.getelementptr"(%126) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 3>}> : (!llvm.ptr) -> !llvm.ptr
  %149 = "llvm.load"(%148) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %150 = "llvm.zext"(%149) : (i8) -> i64
  %151 = "llvm.mul"(%150, %14) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %152 = "llvm.xor"(%151, %147) : (i64, i64) -> i64
  %153 = "llvm.intr.fshl"(%152, %152, %23) : (i64, i64, i64) -> i64
  %154 = "llvm.mul"(%153, %12) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %155 = "llvm.getelementptr"(%126) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4>}> : (!llvm.ptr) -> !llvm.ptr
  %156 = "llvm.load"(%155) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %157 = "llvm.zext"(%156) : (i8) -> i64
  %158 = "llvm.mul"(%157, %14) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %159 = "llvm.xor"(%158, %154) : (i64, i64) -> i64
  %160 = "llvm.intr.fshl"(%159, %159, %23) : (i64, i64, i64) -> i64
  %161 = "llvm.mul"(%160, %12) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %162 = "llvm.getelementptr"(%126) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 5>}> : (!llvm.ptr) -> !llvm.ptr
  %163 = "llvm.load"(%162) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %164 = "llvm.zext"(%163) : (i8) -> i64
  %165 = "llvm.mul"(%164, %14) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %166 = "llvm.xor"(%165, %161) : (i64, i64) -> i64
  %167 = "llvm.intr.fshl"(%166, %166, %23) : (i64, i64, i64) -> i64
  %168 = "llvm.mul"(%167, %12) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %169 = "llvm.getelementptr"(%126) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6>}> : (!llvm.ptr) -> !llvm.ptr
  %170 = "llvm.load"(%169) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %171 = "llvm.zext"(%170) : (i8) -> i64
  %172 = "llvm.mul"(%171, %14) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %173 = "llvm.xor"(%172, %168) : (i64, i64) -> i64
  %174 = "llvm.intr.fshl"(%173, %173, %23) : (i64, i64, i64) -> i64
  %175 = "llvm.mul"(%174, %12) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %176 = "llvm.getelementptr"(%126) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 7>}> : (!llvm.ptr) -> !llvm.ptr
  %177 = "llvm.load"(%176) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %178 = "llvm.zext"(%177) : (i8) -> i64
  %179 = "llvm.mul"(%178, %14) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %180 = "llvm.xor"(%179, %175) : (i64, i64) -> i64
  %181 = "llvm.intr.fshl"(%180, %180, %23) : (i64, i64, i64) -> i64
  %182 = "llvm.mul"(%181, %12) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %183 = "llvm.getelementptr"(%126) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %184 = "llvm.icmp"(%183, %106) <{predicate = 0 : i64}> : (!llvm.ptr, !llvm.ptr) -> i1
  "llvm.cond_br"(%184, %182, %183, %182)[^bb14, ^bb13] <{loop_annotation = #llvm.loop_annotation<mustProgress = true>, operandSegmentSizes = array<i32: 1, 1, 2>}> : (i1, i64, !llvm.ptr, i64) -> ()
^bb14(%185: i64):  // 3 preds: ^bb9, ^bb12, ^bb13
  %186 = "llvm.lshr"(%185, %17) : (i64, i64) -> i64
  %187 = "llvm.xor"(%186, %185) : (i64, i64) -> i64
  %188 = "llvm.mul"(%187, %15) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %189 = "llvm.lshr"(%188, %25) : (i64, i64) -> i64
  %190 = "llvm.xor"(%189, %188) : (i64, i64) -> i64
  %191 = "llvm.mul"(%190, %20) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %192 = "llvm.lshr"(%191, %0) : (i64, i64) -> i64
  %193 = "llvm.xor"(%192, %191) : (i64, i64) -> i64
  "llvm.return"(%193) : (i64) -> ()
}) : () -> ()

end

end Firedancer.Lane.Mlir
