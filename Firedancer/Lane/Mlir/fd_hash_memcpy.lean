
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab



namespace Firedancer.Lane.Mlir

@[expose] public section

mlir_def fd_hash_memcpy := "llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.noundef}, {llvm.noalias, llvm.nocapture, llvm.nofree, llvm.noundef, llvm.writeonly}, {llvm.noalias, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.noundef}], frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<i64 (i64, ptr, ptr, i64)>, linkage = #llvm.linkage<external>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], sym_name = "fd_hash_memcpy", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
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
  %23 = "llvm.mlir.constant"() <{value = 7 : i64}> : () -> i64
  %24 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %25 = "llvm.mlir.poison"() : () -> i64
  %26 = "llvm.mlir.constant"() <{value = 11 : i64}> : () -> i64
  %27 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %28 = "llvm.mlir.constant"() <{value = -8 : i64}> : () -> i64
  %29 = "llvm.mlir.constant"() <{value = 29 : i64}> : () -> i64
  %30 = "llvm.ptrtoint"(%arg2) : (!llvm.ptr) -> i64
  %31 = "llvm.getelementptr"(%arg2, %arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %32 = "llvm.icmp"(%arg3, %0) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%32)[^bb1, ^bb2] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb1:  // pred: ^bb0
  %33 = "llvm.add"(%arg0, %18) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.br"(%33, %arg2, %arg1)[^bb5] : (i64, !llvm.ptr, !llvm.ptr) -> ()
^bb2:  // pred: ^bb0
  %34 = "llvm.getelementptr"(%31) <{elem_type = i8, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -32>}> : (!llvm.ptr) -> !llvm.ptr
  %35 = "llvm.add"(%arg0, %1) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %36 = "llvm.add"(%arg0, %2) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %37 = "llvm.add"(%arg0, %3) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.br"(%37, %arg0, %36, %35, %arg2, %arg1)[^bb3] : (i64, i64, i64, i64, !llvm.ptr, !llvm.ptr) -> ()
^bb3(%38: i64, %39: i64, %40: i64, %41: i64, %42: !llvm.ptr, %43: !llvm.ptr):  // 2 preds: ^bb2, ^bb3
  %44 = "llvm.load"(%42) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %45 = "llvm.getelementptr"(%42) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %46 = "llvm.load"(%45) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %47 = "llvm.getelementptr"(%42) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %48 = "llvm.load"(%47) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %49 = "llvm.getelementptr"(%42) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %50 = "llvm.load"(%49) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %51 = "llvm.mul"(%44, %2) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %52 = "llvm.add"(%51, %41) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %53 = "llvm.intr.fshl"(%52, %52, %4) : (i64, i64, i64) -> i64
  %54 = "llvm.mul"(%53, %5) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %55 = "llvm.mul"(%46, %2) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %56 = "llvm.add"(%55, %40) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %57 = "llvm.intr.fshl"(%56, %56, %4) : (i64, i64, i64) -> i64
  %58 = "llvm.mul"(%57, %5) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %59 = "llvm.mul"(%48, %2) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %60 = "llvm.add"(%59, %39) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %61 = "llvm.intr.fshl"(%60, %60, %4) : (i64, i64, i64) -> i64
  %62 = "llvm.mul"(%61, %5) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %63 = "llvm.mul"(%50, %2) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %64 = "llvm.add"(%63, %38) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %65 = "llvm.intr.fshl"(%64, %64, %4) : (i64, i64, i64) -> i64
  %66 = "llvm.mul"(%65, %5) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%44, %43) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %67 = "llvm.getelementptr"(%43) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%46, %67) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %68 = "llvm.getelementptr"(%43) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%48, %68) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %69 = "llvm.getelementptr"(%43) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%50, %69) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %70 = "llvm.getelementptr"(%42) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %71 = "llvm.getelementptr"(%43) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %72 = "llvm.icmp"(%70, %34) <{predicate = 8 : i64}> : (!llvm.ptr, !llvm.ptr) -> i1
  "llvm.cond_br"(%72, %66, %62, %58, %54, %70, %71)[^bb4, ^bb3] <{loop_annotation = #llvm.loop_annotation<mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 6>}> : (i1, i64, i64, i64, i64, !llvm.ptr, !llvm.ptr) -> ()
^bb4:  // pred: ^bb3
  %73 = "llvm.mul"(%53, %6) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %74 = "llvm.lshr"(%54, %7) : (i64, i64) -> i64
  %75 = "llvm.mul"(%57, %8) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %76 = "llvm.lshr"(%58, %9) : (i64, i64) -> i64
  %77 = "llvm.mul"(%61, %10) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %78 = "llvm.lshr"(%62, %11) : (i64, i64) -> i64
  %79 = "llvm.mul"(%65, %12) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %80 = "llvm.lshr"(%66, %13) : (i64, i64) -> i64
  %81 = "llvm.or"(%74, %73) <{isDisjoint}> : (i64, i64) -> i64
  %82 = "llvm.add"(%81, %75) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %83 = "llvm.add"(%82, %76) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %84 = "llvm.add"(%83, %77) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %85 = "llvm.add"(%84, %78) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %86 = "llvm.add"(%85, %79) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %87 = "llvm.add"(%86, %80) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %88 = "llvm.mul"(%53, %14) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %89 = "llvm.mul"(%53, %15) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %90 = "llvm.lshr"(%88, %16) : (i64, i64) -> i64
  %91 = "llvm.or"(%90, %89) <{isDisjoint}> : (i64, i64) -> i64
  %92 = "llvm.mul"(%91, %5) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %93 = "llvm.xor"(%87, %92) : (i64, i64) -> i64
  %94 = "llvm.mul"(%93, %5) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %95 = "llvm.add"(%94, %17) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %96 = "llvm.mul"(%57, %14) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %97 = "llvm.mul"(%57, %15) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %98 = "llvm.lshr"(%96, %16) : (i64, i64) -> i64
  %99 = "llvm.or"(%98, %97) <{isDisjoint}> : (i64, i64) -> i64
  %100 = "llvm.mul"(%99, %5) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %101 = "llvm.xor"(%95, %100) : (i64, i64) -> i64
  %102 = "llvm.mul"(%101, %5) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %103 = "llvm.add"(%102, %17) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %104 = "llvm.mul"(%61, %14) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %105 = "llvm.mul"(%61, %15) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %106 = "llvm.lshr"(%104, %16) : (i64, i64) -> i64
  %107 = "llvm.or"(%106, %105) <{isDisjoint}> : (i64, i64) -> i64
  %108 = "llvm.mul"(%107, %5) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %109 = "llvm.xor"(%103, %108) : (i64, i64) -> i64
  %110 = "llvm.mul"(%109, %5) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %111 = "llvm.add"(%110, %17) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %112 = "llvm.mul"(%65, %14) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %113 = "llvm.mul"(%65, %15) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %114 = "llvm.lshr"(%112, %16) : (i64, i64) -> i64
  %115 = "llvm.or"(%114, %113) <{isDisjoint}> : (i64, i64) -> i64
  %116 = "llvm.mul"(%115, %5) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %117 = "llvm.xor"(%111, %116) : (i64, i64) -> i64
  %118 = "llvm.mul"(%117, %5) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %119 = "llvm.add"(%118, %17) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.br"(%119, %70, %71)[^bb5] : (i64, !llvm.ptr, !llvm.ptr) -> ()
^bb5(%120: i64, %121: !llvm.ptr, %122: !llvm.ptr):  // 2 preds: ^bb1, ^bb4
  %123 = "llvm.add"(%120, %arg3) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %124 = "llvm.getelementptr"(%121) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %125 = "llvm.icmp"(%124, %31) <{predicate = 8 : i64}> : (!llvm.ptr, !llvm.ptr) -> i1
  "llvm.cond_br"(%125, %123, %121, %122, %124, %122, %121, %123)[^bb7, ^bb6] <{operandSegmentSizes = array<i32: 1, 3, 4>}> : (i1, i64, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, i64) -> ()
^bb6(%126: !llvm.ptr, %127: !llvm.ptr, %128: !llvm.ptr, %129: i64):  // 2 preds: ^bb5, ^bb6
  %130 = "llvm.load"(%128) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %131 = "llvm.mul"(%130, %2) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %132 = "llvm.mul"(%130, %19) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %133 = "llvm.lshr"(%131, %16) : (i64, i64) -> i64
  %134 = "llvm.or"(%133, %132) <{isDisjoint}> : (i64, i64) -> i64
  %135 = "llvm.mul"(%134, %5) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %136 = "llvm.xor"(%135, %129) : (i64, i64) -> i64
  %137 = "llvm.intr.fshl"(%136, %136, %20) : (i64, i64, i64) -> i64
  %138 = "llvm.mul"(%137, %5) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %139 = "llvm.add"(%138, %17) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%130, %127) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %140 = "llvm.getelementptr"(%127) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %141 = "llvm.getelementptr"(%126) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %142 = "llvm.icmp"(%141, %31) <{predicate = 8 : i64}> : (!llvm.ptr, !llvm.ptr) -> i1
  "llvm.cond_br"(%142, %139, %126, %140, %141, %140, %126, %139)[^bb7, ^bb6] <{loop_annotation = #llvm.loop_annotation<mustProgress = true>, operandSegmentSizes = array<i32: 1, 3, 4>}> : (i1, i64, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, i64) -> ()
^bb7(%143: i64, %144: !llvm.ptr, %145: !llvm.ptr):  // 2 preds: ^bb5, ^bb6
  %146 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4>}> : (!llvm.ptr) -> !llvm.ptr
  %147 = "llvm.icmp"(%146, %31) <{predicate = 8 : i64}> : (!llvm.ptr, !llvm.ptr) -> i1
  "llvm.cond_br"(%147, %143, %144, %145)[^bb9, ^bb8] <{operandSegmentSizes = array<i32: 1, 3, 0>}> : (i1, i64, !llvm.ptr, !llvm.ptr) -> ()
^bb8:  // pred: ^bb7
  %148 = "llvm.load"(%144) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %149 = "llvm.zext"(%148) : (i32) -> i64
  %150 = "llvm.mul"(%149, %5) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %151 = "llvm.xor"(%150, %143) : (i64, i64) -> i64
  %152 = "llvm.intr.fshl"(%151, %151, %21) : (i64, i64, i64) -> i64
  %153 = "llvm.mul"(%152, %2) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %154 = "llvm.add"(%153, %22) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%148, %145) <{alignment = 4 : i64, ordering = 0 : i64}> : (i32, !llvm.ptr) -> ()
  %155 = "llvm.getelementptr"(%145) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.br"(%154, %146, %155)[^bb9] : (i64, !llvm.ptr, !llvm.ptr) -> ()
^bb9(%156: i64, %157: !llvm.ptr, %158: !llvm.ptr):  // 2 preds: ^bb7, ^bb8
  %159 = "llvm.icmp"(%157, %31) <{predicate = 6 : i64}> : (!llvm.ptr, !llvm.ptr) -> i1
  "llvm.cond_br"(%159, %156)[^bb10, ^bb14] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb10:  // pred: ^bb9
  %160 = "llvm.ptrtoint"(%157) : (!llvm.ptr) -> i64
  %161 = "llvm.add"(%arg3, %30) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %162 = "llvm.sub"(%161, %160) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %163 = "llvm.getelementptr"(%157, %162) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %164 = "llvm.and"(%162, %23) : (i64, i64) -> i64
  %165 = "llvm.icmp"(%164, %24) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%165, %25, %158, %157, %156, %158, %157, %156, %24)[^bb12, ^bb11] <{operandSegmentSizes = array<i32: 1, 4, 4>}> : (i1, i64, !llvm.ptr, !llvm.ptr, i64, !llvm.ptr, !llvm.ptr, i64, i64) -> ()
^bb11(%166: !llvm.ptr, %167: !llvm.ptr, %168: i64, %169: i64):  // 2 preds: ^bb10, ^bb11
  %170 = "llvm.load"(%167) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %171 = "llvm.zext"(%170) : (i8) -> i64
  %172 = "llvm.mul"(%171, %18) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %173 = "llvm.xor"(%172, %168) : (i64, i64) -> i64
  %174 = "llvm.intr.fshl"(%173, %173, %26) : (i64, i64, i64) -> i64
  %175 = "llvm.mul"(%174, %5) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%170, %166) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %176 = "llvm.getelementptr"(%167) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1>}> : (!llvm.ptr) -> !llvm.ptr
  %177 = "llvm.getelementptr"(%166) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1>}> : (!llvm.ptr) -> !llvm.ptr
  %178 = "llvm.add"(%169, %27) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %179 = "llvm.icmp"(%178, %164) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%179, %175, %177, %176, %175, %177, %176, %175, %178)[^bb12, ^bb11] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>>, operandSegmentSizes = array<i32: 1, 4, 4>}> : (i1, i64, !llvm.ptr, !llvm.ptr, i64, !llvm.ptr, !llvm.ptr, i64, i64) -> ()
^bb12(%180: i64, %181: !llvm.ptr, %182: !llvm.ptr, %183: i64):  // 2 preds: ^bb10, ^bb11
  %184 = "llvm.sub"(%160, %161) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %185 = "llvm.icmp"(%184, %28) <{predicate = 8 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%185, %180, %181, %182, %183)[^bb14, ^bb13] <{operandSegmentSizes = array<i32: 1, 1, 3>}> : (i1, i64, !llvm.ptr, !llvm.ptr, i64) -> ()
^bb13(%186: !llvm.ptr, %187: !llvm.ptr, %188: i64):  // 2 preds: ^bb12, ^bb13
  %189 = "llvm.load"(%187) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %190 = "llvm.zext"(%189) : (i8) -> i64
  %191 = "llvm.mul"(%190, %18) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %192 = "llvm.xor"(%191, %188) : (i64, i64) -> i64
  %193 = "llvm.intr.fshl"(%192, %192, %26) : (i64, i64, i64) -> i64
  %194 = "llvm.mul"(%193, %5) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%189, %186) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %195 = "llvm.getelementptr"(%187) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1>}> : (!llvm.ptr) -> !llvm.ptr
  %196 = "llvm.getelementptr"(%186) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1>}> : (!llvm.ptr) -> !llvm.ptr
  %197 = "llvm.load"(%195) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %198 = "llvm.zext"(%197) : (i8) -> i64
  %199 = "llvm.mul"(%198, %18) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %200 = "llvm.xor"(%199, %194) : (i64, i64) -> i64
  %201 = "llvm.intr.fshl"(%200, %200, %26) : (i64, i64, i64) -> i64
  %202 = "llvm.mul"(%201, %5) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%197, %196) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %203 = "llvm.getelementptr"(%187) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2>}> : (!llvm.ptr) -> !llvm.ptr
  %204 = "llvm.getelementptr"(%186) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2>}> : (!llvm.ptr) -> !llvm.ptr
  %205 = "llvm.load"(%203) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %206 = "llvm.zext"(%205) : (i8) -> i64
  %207 = "llvm.mul"(%206, %18) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %208 = "llvm.xor"(%207, %202) : (i64, i64) -> i64
  %209 = "llvm.intr.fshl"(%208, %208, %26) : (i64, i64, i64) -> i64
  %210 = "llvm.mul"(%209, %5) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%205, %204) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %211 = "llvm.getelementptr"(%187) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 3>}> : (!llvm.ptr) -> !llvm.ptr
  %212 = "llvm.getelementptr"(%186) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 3>}> : (!llvm.ptr) -> !llvm.ptr
  %213 = "llvm.load"(%211) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %214 = "llvm.zext"(%213) : (i8) -> i64
  %215 = "llvm.mul"(%214, %18) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %216 = "llvm.xor"(%215, %210) : (i64, i64) -> i64
  %217 = "llvm.intr.fshl"(%216, %216, %26) : (i64, i64, i64) -> i64
  %218 = "llvm.mul"(%217, %5) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%213, %212) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %219 = "llvm.getelementptr"(%187) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4>}> : (!llvm.ptr) -> !llvm.ptr
  %220 = "llvm.getelementptr"(%186) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4>}> : (!llvm.ptr) -> !llvm.ptr
  %221 = "llvm.load"(%219) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %222 = "llvm.zext"(%221) : (i8) -> i64
  %223 = "llvm.mul"(%222, %18) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %224 = "llvm.xor"(%223, %218) : (i64, i64) -> i64
  %225 = "llvm.intr.fshl"(%224, %224, %26) : (i64, i64, i64) -> i64
  %226 = "llvm.mul"(%225, %5) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%221, %220) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %227 = "llvm.getelementptr"(%187) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 5>}> : (!llvm.ptr) -> !llvm.ptr
  %228 = "llvm.getelementptr"(%186) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 5>}> : (!llvm.ptr) -> !llvm.ptr
  %229 = "llvm.load"(%227) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %230 = "llvm.zext"(%229) : (i8) -> i64
  %231 = "llvm.mul"(%230, %18) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %232 = "llvm.xor"(%231, %226) : (i64, i64) -> i64
  %233 = "llvm.intr.fshl"(%232, %232, %26) : (i64, i64, i64) -> i64
  %234 = "llvm.mul"(%233, %5) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%229, %228) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %235 = "llvm.getelementptr"(%187) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6>}> : (!llvm.ptr) -> !llvm.ptr
  %236 = "llvm.getelementptr"(%186) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6>}> : (!llvm.ptr) -> !llvm.ptr
  %237 = "llvm.load"(%235) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %238 = "llvm.zext"(%237) : (i8) -> i64
  %239 = "llvm.mul"(%238, %18) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %240 = "llvm.xor"(%239, %234) : (i64, i64) -> i64
  %241 = "llvm.intr.fshl"(%240, %240, %26) : (i64, i64, i64) -> i64
  %242 = "llvm.mul"(%241, %5) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%237, %236) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %243 = "llvm.getelementptr"(%187) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 7>}> : (!llvm.ptr) -> !llvm.ptr
  %244 = "llvm.getelementptr"(%186) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 7>}> : (!llvm.ptr) -> !llvm.ptr
  %245 = "llvm.load"(%243) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %246 = "llvm.zext"(%245) : (i8) -> i64
  %247 = "llvm.mul"(%246, %18) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %248 = "llvm.xor"(%247, %242) : (i64, i64) -> i64
  %249 = "llvm.intr.fshl"(%248, %248, %26) : (i64, i64, i64) -> i64
  %250 = "llvm.mul"(%249, %5) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%245, %244) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %251 = "llvm.getelementptr"(%187) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %252 = "llvm.getelementptr"(%186) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %253 = "llvm.icmp"(%251, %163) <{predicate = 0 : i64}> : (!llvm.ptr, !llvm.ptr) -> i1
  "llvm.cond_br"(%253, %250, %252, %251, %250)[^bb14, ^bb13] <{loop_annotation = #llvm.loop_annotation<mustProgress = true>, operandSegmentSizes = array<i32: 1, 1, 3>}> : (i1, i64, !llvm.ptr, !llvm.ptr, i64) -> ()
^bb14(%254: i64):  // 3 preds: ^bb9, ^bb12, ^bb13
  %255 = "llvm.lshr"(%254, %16) : (i64, i64) -> i64
  %256 = "llvm.xor"(%255, %254) : (i64, i64) -> i64
  %257 = "llvm.mul"(%256, %2) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %258 = "llvm.lshr"(%257, %29) : (i64, i64) -> i64
  %259 = "llvm.xor"(%258, %257) : (i64, i64) -> i64
  %260 = "llvm.mul"(%259, %22) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %261 = "llvm.lshr"(%260, %0) : (i64, i64) -> i64
  %262 = "llvm.xor"(%261, %260) : (i64, i64) -> i64
  "llvm.return"(%262) : (i64) -> ()
}) : () -> ()

end

end Firedancer.Lane.Mlir
