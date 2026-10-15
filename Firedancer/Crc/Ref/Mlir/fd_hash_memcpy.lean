
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab



namespace MLIR.Firedancer.Crc.Ref

@[expose] public section

mlir_def fd_hash_memcpy := "llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.noundef}, {llvm.noalias, llvm.nocapture, llvm.nofree, llvm.noundef, llvm.writeonly}, {llvm.noalias, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.noundef}], function_type = !llvm.func<i64 (i64, ptr, ptr, i64)>, linkage = #llvm.linkage<external>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], sym_name = "fd_hash_memcpy", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: i64, %arg1: !llvm.ptr, %arg2: !llvm.ptr, %arg3: i64):
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
  %25 = "llvm.ptrtoint"(%arg2) : (!llvm.ptr) -> i64
  %26 = "llvm.getelementptr"(%arg2, %arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %27 = "llvm.icmp"(%arg3, %0) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%27)[^bb1, ^bb2] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb1:  // pred: ^bb0
  %28 = "llvm.add"(%arg0, %18) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.br"(%28, %arg2, %arg1)[^bb5] : (i64, !llvm.ptr, !llvm.ptr) -> ()
^bb2:  // pred: ^bb0
  %29 = "llvm.getelementptr"(%26) <{elem_type = i8, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -32>}> : (!llvm.ptr) -> !llvm.ptr
  %30 = "llvm.add"(%arg0, %1) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %31 = "llvm.add"(%arg0, %2) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %32 = "llvm.add"(%arg0, %3) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.br"(%32, %arg0, %31, %30, %arg2, %arg1)[^bb3] : (i64, i64, i64, i64, !llvm.ptr, !llvm.ptr) -> ()
^bb3(%33: i64, %34: i64, %35: i64, %36: i64, %37: !llvm.ptr, %38: !llvm.ptr):  // 2 preds: ^bb2, ^bb3
  %39 = "llvm.load"(%37) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %40 = "llvm.getelementptr"(%37) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %41 = "llvm.load"(%40) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %42 = "llvm.getelementptr"(%37) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %43 = "llvm.load"(%42) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %44 = "llvm.getelementptr"(%37) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %45 = "llvm.load"(%44) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %46 = "llvm.mul"(%39, %2) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %47 = "llvm.add"(%46, %36) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %48 = "llvm.intr.fshl"(%47, %47, %4) : (i64, i64, i64) -> i64
  %49 = "llvm.mul"(%48, %5) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %50 = "llvm.mul"(%41, %2) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %51 = "llvm.add"(%50, %35) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %52 = "llvm.intr.fshl"(%51, %51, %4) : (i64, i64, i64) -> i64
  %53 = "llvm.mul"(%52, %5) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %54 = "llvm.mul"(%43, %2) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %55 = "llvm.add"(%54, %34) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %56 = "llvm.intr.fshl"(%55, %55, %4) : (i64, i64, i64) -> i64
  %57 = "llvm.mul"(%56, %5) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %58 = "llvm.mul"(%45, %2) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %59 = "llvm.add"(%58, %33) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %60 = "llvm.intr.fshl"(%59, %59, %4) : (i64, i64, i64) -> i64
  %61 = "llvm.mul"(%60, %5) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%39, %38) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %62 = "llvm.getelementptr"(%38) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%41, %62) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %63 = "llvm.getelementptr"(%38) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%43, %63) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %64 = "llvm.getelementptr"(%38) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%45, %64) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %65 = "llvm.getelementptr"(%37) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %66 = "llvm.getelementptr"(%38) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %67 = "llvm.icmp"(%65, %29) <{predicate = 8 : i64}> : (!llvm.ptr, !llvm.ptr) -> i1
  "llvm.cond_br"(%67, %61, %57, %53, %49, %65, %66)[^bb4, ^bb3] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 6>}> : (i1, i64, i64, i64, i64, !llvm.ptr, !llvm.ptr) -> ()
^bb4:  // pred: ^bb3
  %68 = "llvm.mul"(%48, %6) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %69 = "llvm.lshr"(%49, %7) : (i64, i64) -> i64
  %70 = "llvm.mul"(%52, %8) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %71 = "llvm.lshr"(%53, %9) : (i64, i64) -> i64
  %72 = "llvm.mul"(%56, %10) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %73 = "llvm.lshr"(%57, %11) : (i64, i64) -> i64
  %74 = "llvm.mul"(%60, %12) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %75 = "llvm.lshr"(%61, %13) : (i64, i64) -> i64
  %76 = "llvm.or"(%69, %68) <{isDisjoint}> : (i64, i64) -> i64
  %77 = "llvm.add"(%76, %70) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %78 = "llvm.add"(%77, %71) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %79 = "llvm.add"(%78, %72) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %80 = "llvm.add"(%79, %73) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %81 = "llvm.add"(%80, %74) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %82 = "llvm.add"(%81, %75) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %83 = "llvm.mul"(%48, %14) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %84 = "llvm.mul"(%48, %15) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %85 = "llvm.lshr"(%83, %16) : (i64, i64) -> i64
  %86 = "llvm.or"(%85, %84) <{isDisjoint}> : (i64, i64) -> i64
  %87 = "llvm.mul"(%86, %5) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %88 = "llvm.xor"(%82, %87) : (i64, i64) -> i64
  %89 = "llvm.mul"(%88, %5) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %90 = "llvm.add"(%89, %17) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %91 = "llvm.mul"(%52, %14) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %92 = "llvm.mul"(%52, %15) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %93 = "llvm.lshr"(%91, %16) : (i64, i64) -> i64
  %94 = "llvm.or"(%93, %92) <{isDisjoint}> : (i64, i64) -> i64
  %95 = "llvm.mul"(%94, %5) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %96 = "llvm.xor"(%90, %95) : (i64, i64) -> i64
  %97 = "llvm.mul"(%96, %5) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %98 = "llvm.add"(%97, %17) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %99 = "llvm.mul"(%56, %14) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %100 = "llvm.mul"(%56, %15) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %101 = "llvm.lshr"(%99, %16) : (i64, i64) -> i64
  %102 = "llvm.or"(%101, %100) <{isDisjoint}> : (i64, i64) -> i64
  %103 = "llvm.mul"(%102, %5) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %104 = "llvm.xor"(%98, %103) : (i64, i64) -> i64
  %105 = "llvm.mul"(%104, %5) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %106 = "llvm.add"(%105, %17) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %107 = "llvm.mul"(%60, %14) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %108 = "llvm.mul"(%60, %15) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %109 = "llvm.lshr"(%107, %16) : (i64, i64) -> i64
  %110 = "llvm.or"(%109, %108) <{isDisjoint}> : (i64, i64) -> i64
  %111 = "llvm.mul"(%110, %5) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %112 = "llvm.xor"(%106, %111) : (i64, i64) -> i64
  %113 = "llvm.mul"(%112, %5) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %114 = "llvm.add"(%113, %17) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.br"(%114, %65, %66)[^bb5] : (i64, !llvm.ptr, !llvm.ptr) -> ()
^bb5(%115: i64, %116: !llvm.ptr, %117: !llvm.ptr):  // 2 preds: ^bb1, ^bb4
  %118 = "llvm.add"(%115, %arg3) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %119 = "llvm.getelementptr"(%116) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %120 = "llvm.icmp"(%119, %26) <{predicate = 8 : i64}> : (!llvm.ptr, !llvm.ptr) -> i1
  "llvm.cond_br"(%120, %118, %116, %117, %119, %117, %116, %118)[^bb7, ^bb6] <{operandSegmentSizes = array<i32: 1, 3, 4>}> : (i1, i64, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, i64) -> ()
^bb6(%121: !llvm.ptr, %122: !llvm.ptr, %123: !llvm.ptr, %124: i64):  // 2 preds: ^bb5, ^bb6
  %125 = "llvm.load"(%123) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %126 = "llvm.mul"(%125, %2) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %127 = "llvm.mul"(%125, %19) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %128 = "llvm.lshr"(%126, %16) : (i64, i64) -> i64
  %129 = "llvm.or"(%128, %127) <{isDisjoint}> : (i64, i64) -> i64
  %130 = "llvm.mul"(%129, %5) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %131 = "llvm.xor"(%130, %124) : (i64, i64) -> i64
  %132 = "llvm.intr.fshl"(%131, %131, %20) : (i64, i64, i64) -> i64
  %133 = "llvm.mul"(%132, %5) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %134 = "llvm.add"(%133, %17) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%125, %122) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %135 = "llvm.getelementptr"(%122) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %136 = "llvm.getelementptr"(%121) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %137 = "llvm.icmp"(%136, %26) <{predicate = 8 : i64}> : (!llvm.ptr, !llvm.ptr) -> i1
  "llvm.cond_br"(%137, %134, %121, %135, %136, %135, %121, %134)[^bb7, ^bb6] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 3, 4>}> : (i1, i64, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, i64) -> ()
^bb7(%138: i64, %139: !llvm.ptr, %140: !llvm.ptr):  // 2 preds: ^bb5, ^bb6
  %141 = "llvm.getelementptr"(%139) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4>}> : (!llvm.ptr) -> !llvm.ptr
  %142 = "llvm.icmp"(%141, %26) <{predicate = 8 : i64}> : (!llvm.ptr, !llvm.ptr) -> i1
  "llvm.cond_br"(%142, %138, %139, %140)[^bb9, ^bb8] <{operandSegmentSizes = array<i32: 1, 3, 0>}> : (i1, i64, !llvm.ptr, !llvm.ptr) -> ()
^bb8:  // pred: ^bb7
  %143 = "llvm.load"(%139) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %144 = "llvm.zext"(%143) : (i32) -> i64
  %145 = "llvm.mul"(%144, %5) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %146 = "llvm.xor"(%145, %138) : (i64, i64) -> i64
  %147 = "llvm.intr.fshl"(%146, %146, %21) : (i64, i64, i64) -> i64
  %148 = "llvm.mul"(%147, %2) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %149 = "llvm.add"(%148, %22) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%143, %140) <{alignment = 4 : i64, ordering = 0 : i64}> : (i32, !llvm.ptr) -> ()
  %150 = "llvm.getelementptr"(%140) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.br"(%149, %141, %150)[^bb9] : (i64, !llvm.ptr, !llvm.ptr) -> ()
^bb9(%151: i64, %152: !llvm.ptr, %153: !llvm.ptr):  // 2 preds: ^bb7, ^bb8
  %154 = "llvm.icmp"(%152, %26) <{predicate = 6 : i64}> : (!llvm.ptr, !llvm.ptr) -> i1
  "llvm.cond_br"(%154, %151)[^bb10, ^bb12] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb10:  // pred: ^bb9
  %155 = "llvm.ptrtoint"(%152) : (!llvm.ptr) -> i64
  %156 = "llvm.add"(%arg3, %25) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %157 = "llvm.sub"(%156, %155) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %158 = "llvm.getelementptr"(%152, %157) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.br"(%153, %152, %151)[^bb11] : (!llvm.ptr, !llvm.ptr, i64) -> ()
^bb11(%159: !llvm.ptr, %160: !llvm.ptr, %161: i64):  // 2 preds: ^bb10, ^bb11
  %162 = "llvm.load"(%160) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %163 = "llvm.zext"(%162) : (i8) -> i64
  %164 = "llvm.mul"(%163, %18) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %165 = "llvm.xor"(%164, %161) : (i64, i64) -> i64
  %166 = "llvm.intr.fshl"(%165, %165, %23) : (i64, i64, i64) -> i64
  %167 = "llvm.mul"(%166, %5) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%162, %159) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %168 = "llvm.getelementptr"(%160) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1>}> : (!llvm.ptr) -> !llvm.ptr
  %169 = "llvm.getelementptr"(%159) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1>}> : (!llvm.ptr) -> !llvm.ptr
  %170 = "llvm.icmp"(%168, %158) <{predicate = 0 : i64}> : (!llvm.ptr, !llvm.ptr) -> i1
  "llvm.cond_br"(%170, %167, %169, %168, %167)[^bb12, ^bb11] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 1, 3>}> : (i1, i64, !llvm.ptr, !llvm.ptr, i64) -> ()
^bb12(%171: i64):  // 2 preds: ^bb9, ^bb11
  %172 = "llvm.lshr"(%171, %16) : (i64, i64) -> i64
  %173 = "llvm.xor"(%172, %171) : (i64, i64) -> i64
  %174 = "llvm.mul"(%173, %2) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %175 = "llvm.lshr"(%174, %24) : (i64, i64) -> i64
  %176 = "llvm.xor"(%175, %174) : (i64, i64) -> i64
  %177 = "llvm.mul"(%176, %22) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %178 = "llvm.lshr"(%177, %0) : (i64, i64) -> i64
  %179 = "llvm.xor"(%178, %177) : (i64, i64) -> i64
  "llvm.return"(%179) : (i64) -> ()
}) : () -> ()

end

end MLIR.Firedancer.Crc.Ref
