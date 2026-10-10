#alias_scope_domain7 = #llvm.alias_scope_domain<id = distinct[7]<>, description = "Fe.add">
#alias_scope_domain8 = #llvm.alias_scope_domain<id = distinct[8]<>, description = "Fe._sq__anon_17953">
#alias_scope_domain9 = #llvm.alias_scope_domain<id = distinct[9]<>, description = "Fe.sq2">
#alias_scope7 = #llvm.alias_scope<id = distinct[22]<>, domain = #alias_scope_domain7, description = "Fe.add: argument 0">
#alias_scope8 = #llvm.alias_scope<id = distinct[23]<>, domain = #alias_scope_domain8, description = "Fe._sq__anon_17953: argument 0">
#alias_scope9 = #llvm.alias_scope<id = distinct[24]<>, domain = #alias_scope_domain9, description = "Fe.sq2: argument 0">
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.noalias, llvm.nocapture, llvm.nonnull, llvm.sret = !llvm.struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>, llvm.writeonly}, {llvm.align = 8 : i64, llvm.nocapture, llvm.nonnull, llvm.readonly}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, minsize, no_unwind, optsize, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["target-cpu", "x86-64"]], sym_name = "Edwards25519.dbl", target_cpu = "x86-64", target_features = #llvm.target_features<["+64bit", "+cmov", "+cx8", "+fxsr", "+idivq-to-divl", "+macrofusion", "+mmx", "+nopl", "+slow-3ops-lea", "+slow-incdec", "+vzeroupper", "+x87", "-16bit-mode", "-32bit-mode", "-adx", "-aes", "-allow-light-256-bit", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tf32", "-amx-tile", "-amx-transpose", "-avx", "-avx10.1-256", "-avx10.1-512", "-avx10.2-256", "-avx10.2-512", "-avx2", "-avx512bf16", "-avx512bitalg", "-avx512bw", "-avx512cd", "-avx512dq", "-avx512f", "-avx512fp16", "-avx512ifma", "-avx512vbmi", "-avx512vbmi2", "-avx512vl", "-avx512vnni", "-avx512vp2intersect", "-avx512vpopcntdq", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-bmi", "-bmi2", "-branch-hint", "-branchfusion", "-ccmp", "-cf", "-cldemote", "-clflushopt", "-clwb", "-clzero", "-cmpccxadd", "-crc32", "-cx16", "-egpr", "-enqcmd", "-ermsb", "-evex512", "-f16c", "-false-deps-getmant", "-false-deps-lzcnt-tzcnt", "-false-deps-mulc", "-false-deps-mullq", "-false-deps-perm", "-false-deps-popcnt", "-false-deps-range", "-fast-11bytenop", "-fast-15bytenop", "-fast-7bytenop", "-fast-bextr", "-fast-dpwssd", "-fast-gather", "-fast-hops", "-fast-imm16", "-fast-lzcnt", "-fast-movbe", "-fast-scalar-fsqrt", "-fast-scalar-shift-masks", "-fast-shld-rotate", "-fast-variable-crosslane-shuffle", "-fast-variable-perlane-shuffle", "-fast-vector-fsqrt", "-fast-vector-shift-masks", "-faster-shift-than-shuffle", "-fma", "-fma4", "-fsgsbase", "-fsrm", "-gfni", "-harden-sls-ijmp", "-harden-sls-ret", "-hreset", "-idivl-to-divb", "-inline-asm-use-gpr32", "-invpcid", "-kl", "-lea-sp", "-lea-uses-ag", "-lvi-cfi", "-lvi-load-hardening", "-lwp", "-lzcnt", "-movbe", "-movdir64b", "-movdiri", "-movrs", "-mwaitx", "-ndd", "-nf", "-no-bypass-delay", "-no-bypass-delay-blend", "-no-bypass-delay-mov", "-no-bypass-delay-shuffle", "-pad-short-functions", "-pclmul", "-pconfig", "-pku", "-popcnt", "-ppx", "-prefer-128-bit", "-prefer-256-bit", "-prefer-mask-registers", "-prefer-movmsk-over-vtest", "-prefer-no-gather", "-prefer-no-scatter", "-prefetchi", "-prfchw", "-ptwrite", "-push2pop2", "-raoint", "-rdpid", "-rdpru", "-rdrnd", "-rdseed", "-retpoline", "-retpoline-external-thunk", "-retpoline-indirect-branches", "-retpoline-indirect-calls", "-rtm", "-sahf", "-sbb-dep-breaking", "-serialize", "-seses", "-sgx", "-sha", "-sha512", "-shstk", "-slow-lea", "-slow-pmaddwd", "-slow-pmulld", "-slow-shld", "-slow-two-mem-ops", "-slow-unaligned-mem-16", "-slow-unaligned-mem-32", "-sm3", "-sm4", "-soft-float", "-sse", "-sse2", "-sse3", "-sse4.1", "-sse4.2", "-sse4a", "-sse-unaligned-mem", "-ssse3", "-tagged-globals", "-tbm", "-tsxldtrk", "-tuning-fast-imm-vector-shift", "-uintr", "-use-glm-div-sqrt-costs", "-use-slm-arith-costs", "-usermsr", "-vaes", "-vpclmulqdq", "-waitpkg", "-wbnoinvd", "-widekl", "-xop", "-xsave", "-xsavec", "-xsaveopt", "-xsaves", "-zu"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg31: !llvm.ptr, %arg32: !llvm.ptr):
  %691 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %692 = "llvm.mlir.constant"() <{value = 168 : i64}> : () -> i64
  %693 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
  %694 = "llvm.mlir.constant"() <{value = 1 : i128}> : () -> i128
  %695 = "llvm.mlir.constant"() <{value = 38 : i128}> : () -> i128
  %696 = "llvm.mlir.constant"() <{value = 19 : i128}> : () -> i128
  %697 = "llvm.mlir.constant"() <{value = false}> : () -> i1
  %698 = "llvm.alloca"(%691) <{alignment = 16 : i64, elem_type = !llvm.array<5 x i128>}> : (i32) -> !llvm.ptr
  %699 = "llvm.alloca"(%691) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %700 = "llvm.alloca"(%691) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %701 = "llvm.alloca"(%691) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %702 = "llvm.alloca"(%691) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %703 = "llvm.alloca"(%691) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %704 = "llvm.alloca"(%691) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %705 = "llvm.alloca"(%691) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %706 = "llvm.alloca"(%691) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %707 = "llvm.alloca"(%691) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %708 = "llvm.alloca"(%691) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %709 = "llvm.alloca"(%691) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %710 = "llvm.alloca"(%691) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %711 = "llvm.alloca"(%691) <{alignment = 8 : i64, elem_type = !llvm.struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>}> : (i32) -> !llvm.ptr
  "llvm.intr.memcpy"(%711, %arg32, %692) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 168 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 168 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %712 = "llvm.getelementptr"(%arg32) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%710, %arg32, %712) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Fe.add, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%709, %710) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Fe.sq, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = write, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%708, %arg32) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Fe.sq, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = write, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %713 = "llvm.getelementptr"(%711) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%707, %713) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Fe.sq, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = write, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.experimental.noalias.scope.decl"() <{scope = #alias_scope7}> : () -> ()
  %714 = "llvm.load"(%707) <{alignment = 8 : i64, noalias_scopes = [#alias_scope7], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %715 = "llvm.load"(%708) <{alignment = 8 : i64, noalias_scopes = [#alias_scope7], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %716 = "llvm.add"(%715, %714) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %717 = "llvm.getelementptr"(%707) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %718 = "llvm.load"(%717) <{alignment = 8 : i64, noalias_scopes = [#alias_scope7], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %719 = "llvm.getelementptr"(%708) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %720 = "llvm.load"(%719) <{alignment = 8 : i64, noalias_scopes = [#alias_scope7], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %721 = "llvm.add"(%720, %718) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %722 = "llvm.getelementptr"(%707) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %723 = "llvm.load"(%722) <{alignment = 8 : i64, noalias_scopes = [#alias_scope7], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %724 = "llvm.getelementptr"(%708) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %725 = "llvm.load"(%724) <{alignment = 8 : i64, noalias_scopes = [#alias_scope7], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %726 = "llvm.add"(%725, %723) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %727 = "llvm.getelementptr"(%707) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %728 = "llvm.load"(%727) <{alignment = 8 : i64, noalias_scopes = [#alias_scope7], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %729 = "llvm.getelementptr"(%708) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %730 = "llvm.load"(%729) <{alignment = 8 : i64, noalias_scopes = [#alias_scope7], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %731 = "llvm.add"(%730, %728) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %732 = "llvm.getelementptr"(%707) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %733 = "llvm.load"(%732) <{alignment = 8 : i64, noalias_scopes = [#alias_scope7], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %734 = "llvm.getelementptr"(%708) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %735 = "llvm.load"(%734) <{alignment = 8 : i64, noalias_scopes = [#alias_scope7], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %736 = "llvm.add"(%735, %733) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  "llvm.store"(%716, %706) <{alias_scopes = [#alias_scope7], alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %737 = "llvm.getelementptr"(%706) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%721, %737) <{alias_scopes = [#alias_scope7], alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %738 = "llvm.getelementptr"(%706) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%726, %738) <{alias_scopes = [#alias_scope7], alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %739 = "llvm.getelementptr"(%706) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%731, %739) <{alias_scopes = [#alias_scope7], alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %740 = "llvm.getelementptr"(%706) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%736, %740) <{alias_scopes = [#alias_scope7], alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.call"(%705, %707, %708) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Fe.sub, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%708, %709, %706) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Fe.sub, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  %741 = "llvm.getelementptr"(%711) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 80>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%698) : (!llvm.ptr) -> ()
  %742 = "llvm.load"(%741) <{alignment = 8 : i64, noalias_scopes = [#alias_scope8, #alias_scope9], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %743 = "llvm.zext"(%742) : (i64) -> i128
  %744 = "llvm.getelementptr"(%711) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 88>}> : (!llvm.ptr) -> !llvm.ptr
  %745 = "llvm.load"(%744) <{alignment = 8 : i64, noalias_scopes = [#alias_scope8, #alias_scope9], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %746 = "llvm.zext"(%745) : (i64) -> i128
  %747 = "llvm.getelementptr"(%711) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %748 = "llvm.load"(%747) <{alignment = 8 : i64, noalias_scopes = [#alias_scope8, #alias_scope9], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %749 = "llvm.zext"(%748) : (i64) -> i128
  %750 = "llvm.getelementptr"(%711) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 104>}> : (!llvm.ptr) -> !llvm.ptr
  %751 = "llvm.load"(%750) <{alignment = 8 : i64, noalias_scopes = [#alias_scope8, #alias_scope9], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %752 = "llvm.zext"(%751) : (i64) -> i128
  %753 = "llvm.getelementptr"(%711) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 112>}> : (!llvm.ptr) -> !llvm.ptr
  %754 = "llvm.load"(%753) <{alignment = 8 : i64, noalias_scopes = [#alias_scope8, #alias_scope9], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %755 = "llvm.zext"(%754) : (i64) -> i128
  %756 = "llvm.shl"(%743, %694) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %757 = "llvm.shl"(%746, %694) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %758 = "llvm.mul"(%749, %695) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %759 = "llvm.mul"(%752, %696) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %760 = "llvm.mul"(%755, %696) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %761 = "llvm.mul"(%743, %743) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %762 = "llvm.mul"(%755, %695) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %763 = "llvm.mul"(%762, %746) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %764 = "llvm.mul"(%758, %752) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %765 = "llvm.add"(%764, %761) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %766 = "llvm.add"(%765, %763) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %767 = "llvm.getelementptr"(%698) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %768 = "llvm.mul"(%756, %746) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %769 = "llvm.mul"(%758, %755) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %770 = "llvm.add"(%769, %768) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %771 = "llvm.mul"(%759, %752) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %772 = "llvm.add"(%770, %771) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %773 = "llvm.getelementptr"(%698) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %774 = "llvm.mul"(%756, %749) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %775 = "llvm.mul"(%746, %746) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %776 = "llvm.add"(%774, %775) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %777 = "llvm.mul"(%762, %752) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %778 = "llvm.add"(%776, %777) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %779 = "llvm.getelementptr"(%698) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 48>}> : (!llvm.ptr) -> !llvm.ptr
  %780 = "llvm.mul"(%756, %752) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %781 = "llvm.mul"(%757, %749) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %782 = "llvm.add"(%780, %781) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %783 = "llvm.mul"(%760, %755) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %784 = "llvm.add"(%782, %783) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %785 = "llvm.getelementptr"(%698) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %786 = "llvm.mul"(%756, %755) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %787 = "llvm.mul"(%757, %752) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %788 = "llvm.mul"(%749, %749) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %789 = "llvm.add"(%787, %788) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %790 = "llvm.add"(%789, %786) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %791 = "llvm.shl"(%766, %694) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  "llvm.store"(%791, %698) <{alignment = 16 : i64, noalias_scopes = [#alias_scope8, #alias_scope9], ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
  %792 = "llvm.shl"(%772, %694) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  "llvm.store"(%792, %767) <{alignment = 16 : i64, noalias_scopes = [#alias_scope8, #alias_scope9], ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
  %793 = "llvm.shl"(%778, %694) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  "llvm.store"(%793, %773) <{alignment = 16 : i64, noalias_scopes = [#alias_scope8, #alias_scope9], ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
  %794 = "llvm.shl"(%784, %694) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  "llvm.store"(%794, %779) <{alignment = 16 : i64, noalias_scopes = [#alias_scope8, #alias_scope9], ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
  %795 = "llvm.shl"(%790, %694) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  "llvm.store"(%795, %785) <{alignment = 16 : i64, noalias_scopes = [#alias_scope8, #alias_scope9], ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
  "llvm.call"(%704, %698) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>}, {llvm.align = 16 : i64, llvm.nonnull}], callee = @Fe.carry128, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = write, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%698) : (!llvm.ptr) -> ()
  "llvm.call"(%703, %704, %705) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Fe.sub, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%702, %708, %703) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Fe.mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = write, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.memcpy"(%arg31, %702, %693) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %796 = "llvm.getelementptr"(%arg31) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%701, %706, %705) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Fe.mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = write, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.memcpy"(%796, %701, %693) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %797 = "llvm.getelementptr"(%arg31) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 80>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%700, %705, %703) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Fe.mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = write, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.memcpy"(%797, %700, %693) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %798 = "llvm.getelementptr"(%arg31) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 120>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%699, %708, %706) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Fe.mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = write, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.memcpy"(%798, %699, %693) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %799 = "llvm.getelementptr"(%arg31) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 160>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%697, %799) <{alignment = 8 : i64, ordering = 0 : i64}> : (i1, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
