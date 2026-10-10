"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.noalias, llvm.nocapture, llvm.nonnull, llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>, llvm.writeonly}, {llvm.align = 16 : i64, llvm.nocapture, llvm.nonnull}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = write, errnoMem = none, targetMem0 = none, targetMem1 = none>, minsize, no_unwind, optsize, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["target-cpu", "x86-64"]], sym_name = "Fe.carry128", target_cpu = "x86-64", target_features = #llvm.target_features<["+64bit", "+cmov", "+cx8", "+fxsr", "+idivq-to-divl", "+macrofusion", "+mmx", "+nopl", "+slow-3ops-lea", "+slow-incdec", "+vzeroupper", "+x87", "-16bit-mode", "-32bit-mode", "-adx", "-aes", "-allow-light-256-bit", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tf32", "-amx-tile", "-amx-transpose", "-avx", "-avx10.1-256", "-avx10.1-512", "-avx10.2-256", "-avx10.2-512", "-avx2", "-avx512bf16", "-avx512bitalg", "-avx512bw", "-avx512cd", "-avx512dq", "-avx512f", "-avx512fp16", "-avx512ifma", "-avx512vbmi", "-avx512vbmi2", "-avx512vl", "-avx512vnni", "-avx512vp2intersect", "-avx512vpopcntdq", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-bmi", "-bmi2", "-branch-hint", "-branchfusion", "-ccmp", "-cf", "-cldemote", "-clflushopt", "-clwb", "-clzero", "-cmpccxadd", "-crc32", "-cx16", "-egpr", "-enqcmd", "-ermsb", "-evex512", "-f16c", "-false-deps-getmant", "-false-deps-lzcnt-tzcnt", "-false-deps-mulc", "-false-deps-mullq", "-false-deps-perm", "-false-deps-popcnt", "-false-deps-range", "-fast-11bytenop", "-fast-15bytenop", "-fast-7bytenop", "-fast-bextr", "-fast-dpwssd", "-fast-gather", "-fast-hops", "-fast-imm16", "-fast-lzcnt", "-fast-movbe", "-fast-scalar-fsqrt", "-fast-scalar-shift-masks", "-fast-shld-rotate", "-fast-variable-crosslane-shuffle", "-fast-variable-perlane-shuffle", "-fast-vector-fsqrt", "-fast-vector-shift-masks", "-faster-shift-than-shuffle", "-fma", "-fma4", "-fsgsbase", "-fsrm", "-gfni", "-harden-sls-ijmp", "-harden-sls-ret", "-hreset", "-idivl-to-divb", "-inline-asm-use-gpr32", "-invpcid", "-kl", "-lea-sp", "-lea-uses-ag", "-lvi-cfi", "-lvi-load-hardening", "-lwp", "-lzcnt", "-movbe", "-movdir64b", "-movdiri", "-movrs", "-mwaitx", "-ndd", "-nf", "-no-bypass-delay", "-no-bypass-delay-blend", "-no-bypass-delay-mov", "-no-bypass-delay-shuffle", "-pad-short-functions", "-pclmul", "-pconfig", "-pku", "-popcnt", "-ppx", "-prefer-128-bit", "-prefer-256-bit", "-prefer-mask-registers", "-prefer-movmsk-over-vtest", "-prefer-no-gather", "-prefer-no-scatter", "-prefetchi", "-prfchw", "-ptwrite", "-push2pop2", "-raoint", "-rdpid", "-rdpru", "-rdrnd", "-rdseed", "-retpoline", "-retpoline-external-thunk", "-retpoline-indirect-branches", "-retpoline-indirect-calls", "-rtm", "-sahf", "-sbb-dep-breaking", "-serialize", "-seses", "-sgx", "-sha", "-sha512", "-shstk", "-slow-lea", "-slow-pmaddwd", "-slow-pmulld", "-slow-shld", "-slow-two-mem-ops", "-slow-unaligned-mem-16", "-slow-unaligned-mem-32", "-sm3", "-sm4", "-soft-float", "-sse", "-sse2", "-sse3", "-sse4.1", "-sse4.2", "-sse4a", "-sse-unaligned-mem", "-ssse3", "-tagged-globals", "-tbm", "-tsxldtrk", "-tuning-fast-imm-vector-shift", "-uintr", "-use-glm-div-sqrt-costs", "-use-slm-arith-costs", "-usermsr", "-vaes", "-vpclmulqdq", "-waitpkg", "-wbnoinvd", "-widekl", "-xop", "-xsave", "-xsavec", "-xsaveopt", "-xsaves", "-zu"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg3: !llvm.ptr, %arg4: !llvm.ptr):
  %9 = "llvm.mlir.constant"() <{value = 2251799813685247 : i64}> : () -> i64
  %10 = "llvm.mlir.constant"() <{value = 51 : i128}> : () -> i128
  %11 = "llvm.mlir.constant"() <{value = 41538374868278621028243970633760768 : i128}> : () -> i128
  %12 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %13 = "llvm.mlir.constant"() <{value = 51 : i64}> : () -> i64
  %14 = "llvm.load"(%arg4) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i128
  %15 = "llvm.trunc"(%14) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %16 = "llvm.and"(%15, %9) : (i64, i64) -> i64
  %17 = "llvm.getelementptr"(%arg4) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %18 = "llvm.load"(%17) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i128
  %19 = "llvm.lshr"(%14, %10) : (i128, i128) -> i128
  %20 = "llvm.icmp"(%14, %11) <{predicate = 6 : i64}> : (i128, i128) -> i1
  "llvm.intr.assume"(%20) <{op_bundle_sizes = array<i32>}> : (i1) -> ()
  %21 = "llvm.add"(%18, %19) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  "llvm.store"(%21, %17) <{alignment = 16 : i64, ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
  %22 = "llvm.trunc"(%21) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %23 = "llvm.and"(%22, %9) : (i64, i64) -> i64
  %24 = "llvm.getelementptr"(%arg4) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %25 = "llvm.load"(%24) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i128
  %26 = "llvm.lshr"(%21, %10) : (i128, i128) -> i128
  %27 = "llvm.icmp"(%21, %11) <{predicate = 6 : i64}> : (i128, i128) -> i1
  "llvm.intr.assume"(%27) <{op_bundle_sizes = array<i32>}> : (i1) -> ()
  %28 = "llvm.add"(%25, %26) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  "llvm.store"(%28, %24) <{alignment = 16 : i64, ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
  %29 = "llvm.trunc"(%28) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %30 = "llvm.and"(%29, %9) : (i64, i64) -> i64
  %31 = "llvm.getelementptr"(%arg4) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 48>}> : (!llvm.ptr) -> !llvm.ptr
  %32 = "llvm.load"(%31) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i128
  %33 = "llvm.lshr"(%28, %10) : (i128, i128) -> i128
  %34 = "llvm.icmp"(%28, %11) <{predicate = 6 : i64}> : (i128, i128) -> i1
  "llvm.intr.assume"(%34) <{op_bundle_sizes = array<i32>}> : (i1) -> ()
  %35 = "llvm.add"(%32, %33) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  "llvm.store"(%35, %31) <{alignment = 16 : i64, ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
  %36 = "llvm.trunc"(%35) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %37 = "llvm.and"(%36, %9) : (i64, i64) -> i64
  %38 = "llvm.getelementptr"(%arg4) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %39 = "llvm.load"(%38) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i128
  %40 = "llvm.lshr"(%35, %10) : (i128, i128) -> i128
  %41 = "llvm.icmp"(%35, %11) <{predicate = 6 : i64}> : (i128, i128) -> i1
  "llvm.intr.assume"(%41) <{op_bundle_sizes = array<i32>}> : (i1) -> ()
  %42 = "llvm.add"(%39, %40) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  "llvm.store"(%42, %38) <{alignment = 16 : i64, ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
  %43 = "llvm.trunc"(%42) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %44 = "llvm.and"(%43, %9) : (i64, i64) -> i64
  %45 = "llvm.lshr"(%42, %10) : (i128, i128) -> i128
  %46 = "llvm.icmp"(%42, %11) <{predicate = 6 : i64}> : (i128, i128) -> i1
  "llvm.intr.assume"(%46) <{op_bundle_sizes = array<i32>}> : (i1) -> ()
  %47 = "llvm.trunc"(%45) <{overflowFlags = 2 : i32}> : (i128) -> i64
  %48 = "llvm.mul"(%47, %12) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %49 = "llvm.add"(%48, %16) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %50 = "llvm.lshr"(%49, %13) : (i64, i64) -> i64
  %51 = "llvm.and"(%49, %9) : (i64, i64) -> i64
  %52 = "llvm.add"(%50, %23) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %53 = "llvm.lshr"(%52, %13) : (i64, i64) -> i64
  %54 = "llvm.and"(%52, %9) : (i64, i64) -> i64
  %55 = "llvm.add"(%53, %30) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  "llvm.store"(%51, %arg3) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %56 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%54, %56) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %57 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%55, %57) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %58 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%37, %58) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %59 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%44, %59) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
