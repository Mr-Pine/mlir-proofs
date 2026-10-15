
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab



namespace MLIR.Firedancer.Crc.Ref

@[expose] public section

mlir_def fd_hash_generic := "llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.noundef}, {llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.noundef}], dso_local, function_type = !llvm.func<i64 (i64, ptr, i64)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], sym_name = "fd_hash_generic", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: i64, %arg1: !llvm.ptr, %arg2: i64):
  %0 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %1 = "llvm.mlir.constant"() <{value = 6983438078262162902 : i64}> : () -> i64
  %2 = "llvm.mlir.constant"() <{value = -4417276706812531889 : i64}> : () -> i64
  %3 = "llvm.mlir.constant"() <{value = 7046029288634856825 : i64}> : () -> i64
  %4 = "llvm.mlir.constant"() <{value = 31 : i64}> : () -> i64
  %5 = "llvm.mlir.constant"() <{value = -7046029288634856825 : i64}> : () -> i64
  %6 = "llvm.mlir.constant"() <{value = 4354685496439837966 : i64}> : () -> i64
  %7 = "llvm.mlir.constant"() <{value = 63 : i64}> : () -> i64
  %8 = "llvm.mlir.constant"() <{value = 1998710666506355584 : i64}> : () -> i64
  %9 = "llvm.mlir.constant"() <{value = 57 : i64}> : () -> i64
  %10 = "llvm.mlir.constant"() <{value = 8618509107074723840 : i64}> : () -> i64
  %11 = "llvm.mlir.constant"() <{value = 52 : i64}> : () -> i64
  %12 = "llvm.mlir.constant"() <{value = -1817739358504222720 : i64}> : () -> i64
  %13 = "llvm.mlir.constant"() <{value = 46 : i64}> : () -> i64
  %14 = "llvm.mlir.constant"() <{value = -2381459717836149591 : i64}> : () -> i64
  %15 = "llvm.mlir.constant"() <{value = -8665851108926685184 : i64}> : () -> i64
  %16 = "llvm.mlir.constant"() <{value = 33 : i64}> : () -> i64
  %17 = "llvm.mlir.constant"() <{value = -8796714831421723037 : i64}> : () -> i64
  %18 = "llvm.mlir.constant"() <{value = 2870177450012600261 : i64}> : () -> i64
  %19 = "llvm.mlir.constant"() <{value = -7788283243316379648 : i64}> : () -> i64
  %20 = "llvm.mlir.constant"() <{value = 27 : i64}> : () -> i64
  %21 = "llvm.mlir.constant"() <{value = 23 : i64}> : () -> i64
  %22 = "llvm.mlir.constant"() <{value = 1609587929392839161 : i64}> : () -> i64
  %23 = "llvm.mlir.constant"() <{value = 11 : i64}> : () -> i64
  %24 = "llvm.mlir.constant"() <{value = 29 : i64}> : () -> i64
  %25 = "llvm.ptrtoint"(%arg1) : (!llvm.ptr) -> i64
  %26 = "llvm.getelementptr"(%arg1, %arg2) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %27 = "llvm.icmp"(%arg2, %0) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%27)[^bb1, ^bb2] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb1:  // pred: ^bb0
  %28 = "llvm.add"(%arg0, %18) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.br"(%28, %arg1)[^bb5] : (i64, !llvm.ptr) -> ()
^bb2:  // pred: ^bb0
  %29 = "llvm.getelementptr"(%26) <{elem_type = i8, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -32>}> : (!llvm.ptr) -> !llvm.ptr
  %30 = "llvm.add"(%arg0, %1) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %31 = "llvm.add"(%arg0, %2) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %32 = "llvm.add"(%arg0, %3) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.br"(%32, %arg0, %31, %30, %arg1)[^bb3] : (i64, i64, i64, i64, !llvm.ptr) -> ()
^bb3(%33: i64, %34: i64, %35: i64, %36: i64, %37: !llvm.ptr):  // 2 preds: ^bb2, ^bb3
  %38 = "llvm.load"(%37) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %39 = "llvm.mul"(%38, %2) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %40 = "llvm.add"(%39, %36) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %41 = "llvm.intr.fshl"(%40, %40, %4) : (i64, i64, i64) -> i64
  %42 = "llvm.mul"(%41, %5) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %43 = "llvm.getelementptr"(%37) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %44 = "llvm.load"(%43) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %45 = "llvm.mul"(%44, %2) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %46 = "llvm.add"(%45, %35) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %47 = "llvm.intr.fshl"(%46, %46, %4) : (i64, i64, i64) -> i64
  %48 = "llvm.mul"(%47, %5) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %49 = "llvm.getelementptr"(%37) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %50 = "llvm.load"(%49) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %51 = "llvm.mul"(%50, %2) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %52 = "llvm.add"(%51, %34) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %53 = "llvm.intr.fshl"(%52, %52, %4) : (i64, i64, i64) -> i64
  %54 = "llvm.mul"(%53, %5) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %55 = "llvm.getelementptr"(%37) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %56 = "llvm.load"(%55) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %57 = "llvm.mul"(%56, %2) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %58 = "llvm.add"(%57, %33) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %59 = "llvm.intr.fshl"(%58, %58, %4) : (i64, i64, i64) -> i64
  %60 = "llvm.mul"(%59, %5) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %61 = "llvm.getelementptr"(%37) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %62 = "llvm.icmp"(%61, %29) <{predicate = 8 : i64}> : (!llvm.ptr, !llvm.ptr) -> i1
  "llvm.cond_br"(%62, %60, %54, %48, %42, %61)[^bb4, ^bb3] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 5>}> : (i1, i64, i64, i64, i64, !llvm.ptr) -> ()
^bb4:  // pred: ^bb3
  %63 = "llvm.mul"(%41, %6) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %64 = "llvm.lshr"(%42, %7) : (i64, i64) -> i64
  %65 = "llvm.mul"(%47, %8) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %66 = "llvm.lshr"(%48, %9) : (i64, i64) -> i64
  %67 = "llvm.mul"(%53, %10) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %68 = "llvm.lshr"(%54, %11) : (i64, i64) -> i64
  %69 = "llvm.mul"(%59, %12) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %70 = "llvm.lshr"(%60, %13) : (i64, i64) -> i64
  %71 = "llvm.or"(%64, %63) <{isDisjoint}> : (i64, i64) -> i64
  %72 = "llvm.add"(%71, %65) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %73 = "llvm.add"(%72, %66) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %74 = "llvm.add"(%73, %67) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %75 = "llvm.add"(%74, %68) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %76 = "llvm.add"(%75, %69) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %77 = "llvm.add"(%76, %70) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %78 = "llvm.mul"(%41, %14) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %79 = "llvm.mul"(%41, %15) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %80 = "llvm.lshr"(%78, %16) : (i64, i64) -> i64
  %81 = "llvm.or"(%80, %79) <{isDisjoint}> : (i64, i64) -> i64
  %82 = "llvm.mul"(%81, %5) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %83 = "llvm.xor"(%77, %82) : (i64, i64) -> i64
  %84 = "llvm.mul"(%83, %5) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %85 = "llvm.add"(%84, %17) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %86 = "llvm.mul"(%47, %14) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %87 = "llvm.mul"(%47, %15) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %88 = "llvm.lshr"(%86, %16) : (i64, i64) -> i64
  %89 = "llvm.or"(%88, %87) <{isDisjoint}> : (i64, i64) -> i64
  %90 = "llvm.mul"(%89, %5) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %91 = "llvm.xor"(%85, %90) : (i64, i64) -> i64
  %92 = "llvm.mul"(%91, %5) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %93 = "llvm.add"(%92, %17) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %94 = "llvm.mul"(%53, %14) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %95 = "llvm.mul"(%53, %15) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %96 = "llvm.lshr"(%94, %16) : (i64, i64) -> i64
  %97 = "llvm.or"(%96, %95) <{isDisjoint}> : (i64, i64) -> i64
  %98 = "llvm.mul"(%97, %5) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %99 = "llvm.xor"(%93, %98) : (i64, i64) -> i64
  %100 = "llvm.mul"(%99, %5) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %101 = "llvm.add"(%100, %17) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %102 = "llvm.mul"(%59, %14) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %103 = "llvm.mul"(%59, %15) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %104 = "llvm.lshr"(%102, %16) : (i64, i64) -> i64
  %105 = "llvm.or"(%104, %103) <{isDisjoint}> : (i64, i64) -> i64
  %106 = "llvm.mul"(%105, %5) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %107 = "llvm.xor"(%101, %106) : (i64, i64) -> i64
  %108 = "llvm.mul"(%107, %5) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %109 = "llvm.add"(%108, %17) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.br"(%109, %61)[^bb5] : (i64, !llvm.ptr) -> ()
^bb5(%110: i64, %111: !llvm.ptr):  // 2 preds: ^bb1, ^bb4
  %112 = "llvm.add"(%110, %arg2) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %113 = "llvm.getelementptr"(%111) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %114 = "llvm.icmp"(%113, %26) <{predicate = 8 : i64}> : (!llvm.ptr, !llvm.ptr) -> i1
  "llvm.cond_br"(%114, %112, %111, %113, %111, %112)[^bb7, ^bb6] <{operandSegmentSizes = array<i32: 1, 2, 3>}> : (i1, i64, !llvm.ptr, !llvm.ptr, !llvm.ptr, i64) -> ()
^bb6(%115: !llvm.ptr, %116: !llvm.ptr, %117: i64):  // 2 preds: ^bb5, ^bb6
  %118 = "llvm.load"(%116) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %119 = "llvm.mul"(%118, %2) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %120 = "llvm.mul"(%118, %19) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %121 = "llvm.lshr"(%119, %16) : (i64, i64) -> i64
  %122 = "llvm.or"(%121, %120) <{isDisjoint}> : (i64, i64) -> i64
  %123 = "llvm.mul"(%122, %5) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %124 = "llvm.xor"(%123, %117) : (i64, i64) -> i64
  %125 = "llvm.intr.fshl"(%124, %124, %20) : (i64, i64, i64) -> i64
  %126 = "llvm.mul"(%125, %5) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %127 = "llvm.add"(%126, %17) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %128 = "llvm.getelementptr"(%115) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %129 = "llvm.icmp"(%128, %26) <{predicate = 8 : i64}> : (!llvm.ptr, !llvm.ptr) -> i1
  "llvm.cond_br"(%129, %127, %115, %128, %115, %127)[^bb7, ^bb6] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 2, 3>}> : (i1, i64, !llvm.ptr, !llvm.ptr, !llvm.ptr, i64) -> ()
^bb7(%130: i64, %131: !llvm.ptr):  // 2 preds: ^bb5, ^bb6
  %132 = "llvm.getelementptr"(%131) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4>}> : (!llvm.ptr) -> !llvm.ptr
  %133 = "llvm.icmp"(%132, %26) <{predicate = 8 : i64}> : (!llvm.ptr, !llvm.ptr) -> i1
  "llvm.cond_br"(%133, %130, %131)[^bb9, ^bb8] <{operandSegmentSizes = array<i32: 1, 2, 0>}> : (i1, i64, !llvm.ptr) -> ()
^bb8:  // pred: ^bb7
  %134 = "llvm.load"(%131) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %135 = "llvm.zext"(%134) : (i32) -> i64
  %136 = "llvm.mul"(%135, %5) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %137 = "llvm.xor"(%136, %130) : (i64, i64) -> i64
  %138 = "llvm.intr.fshl"(%137, %137, %21) : (i64, i64, i64) -> i64
  %139 = "llvm.mul"(%138, %2) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %140 = "llvm.add"(%139, %22) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.br"(%140, %132)[^bb9] : (i64, !llvm.ptr) -> ()
^bb9(%141: i64, %142: !llvm.ptr):  // 2 preds: ^bb7, ^bb8
  %143 = "llvm.icmp"(%142, %26) <{predicate = 6 : i64}> : (!llvm.ptr, !llvm.ptr) -> i1
  "llvm.cond_br"(%143, %141)[^bb10, ^bb12] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb10:  // pred: ^bb9
  %144 = "llvm.ptrtoint"(%142) : (!llvm.ptr) -> i64
  %145 = "llvm.add"(%arg2, %25) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %146 = "llvm.sub"(%145, %144) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %147 = "llvm.getelementptr"(%142, %146) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.br"(%142, %141)[^bb11] : (!llvm.ptr, i64) -> ()
^bb11(%148: !llvm.ptr, %149: i64):  // 2 preds: ^bb10, ^bb11
  %150 = "llvm.load"(%148) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %151 = "llvm.zext"(%150) : (i8) -> i64
  %152 = "llvm.mul"(%151, %18) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %153 = "llvm.xor"(%152, %149) : (i64, i64) -> i64
  %154 = "llvm.intr.fshl"(%153, %153, %23) : (i64, i64, i64) -> i64
  %155 = "llvm.mul"(%154, %5) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %156 = "llvm.getelementptr"(%148) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1>}> : (!llvm.ptr) -> !llvm.ptr
  %157 = "llvm.icmp"(%156, %147) <{predicate = 0 : i64}> : (!llvm.ptr, !llvm.ptr) -> i1
  "llvm.cond_br"(%157, %155, %156, %155)[^bb12, ^bb11] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 1, 2>}> : (i1, i64, !llvm.ptr, i64) -> ()
^bb12(%158: i64):  // 2 preds: ^bb9, ^bb11
  %159 = "llvm.lshr"(%158, %16) : (i64, i64) -> i64
  %160 = "llvm.xor"(%159, %158) : (i64, i64) -> i64
  %161 = "llvm.mul"(%160, %2) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %162 = "llvm.lshr"(%161, %24) : (i64, i64) -> i64
  %163 = "llvm.xor"(%162, %161) : (i64, i64) -> i64
  %164 = "llvm.mul"(%163, %22) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %165 = "llvm.lshr"(%164, %0) : (i64, i64) -> i64
  %166 = "llvm.xor"(%165, %164) : (i64, i64) -> i64
  "llvm.return"(%166) : (i64) -> ()
}) : () -> ()

end

end MLIR.Firedancer.Crc.Ref
