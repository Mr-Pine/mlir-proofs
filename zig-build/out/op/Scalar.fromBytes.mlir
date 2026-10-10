#alias_scope_domain6 = #llvm.alias_scope_domain<id = distinct[6]<>, description = "ScalarDouble.fromBytes32">
#alias_scope6 = #llvm.alias_scope<id = distinct[21]<>, domain = #alias_scope_domain6, description = "ScalarDouble.fromBytes32: argument 0">
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.noalias, llvm.nocapture, llvm.nonnull, llvm.sret = !llvm.struct<"Scalar", (array<5 x i64>)>, llvm.writeonly}, {llvm.align = 1 : i64, llvm.nocapture, llvm.nonnull, llvm.readonly}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, minsize, no_unwind, optsize, passthrough = ["nofree", "norecurse", "nosync", ["target-cpu", "x86-64"]], sym_name = "Scalar.fromBytes", target_cpu = "x86-64", target_features = #llvm.target_features<["+64bit", "+cmov", "+cx8", "+fxsr", "+idivq-to-divl", "+macrofusion", "+mmx", "+nopl", "+slow-3ops-lea", "+slow-incdec", "+vzeroupper", "+x87", "-16bit-mode", "-32bit-mode", "-adx", "-aes", "-allow-light-256-bit", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tf32", "-amx-tile", "-amx-transpose", "-avx", "-avx10.1-256", "-avx10.1-512", "-avx10.2-256", "-avx10.2-512", "-avx2", "-avx512bf16", "-avx512bitalg", "-avx512bw", "-avx512cd", "-avx512dq", "-avx512f", "-avx512fp16", "-avx512ifma", "-avx512vbmi", "-avx512vbmi2", "-avx512vl", "-avx512vnni", "-avx512vp2intersect", "-avx512vpopcntdq", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-bmi", "-bmi2", "-branch-hint", "-branchfusion", "-ccmp", "-cf", "-cldemote", "-clflushopt", "-clwb", "-clzero", "-cmpccxadd", "-crc32", "-cx16", "-egpr", "-enqcmd", "-ermsb", "-evex512", "-f16c", "-false-deps-getmant", "-false-deps-lzcnt-tzcnt", "-false-deps-mulc", "-false-deps-mullq", "-false-deps-perm", "-false-deps-popcnt", "-false-deps-range", "-fast-11bytenop", "-fast-15bytenop", "-fast-7bytenop", "-fast-bextr", "-fast-dpwssd", "-fast-gather", "-fast-hops", "-fast-imm16", "-fast-lzcnt", "-fast-movbe", "-fast-scalar-fsqrt", "-fast-scalar-shift-masks", "-fast-shld-rotate", "-fast-variable-crosslane-shuffle", "-fast-variable-perlane-shuffle", "-fast-vector-fsqrt", "-fast-vector-shift-masks", "-faster-shift-than-shuffle", "-fma", "-fma4", "-fsgsbase", "-fsrm", "-gfni", "-harden-sls-ijmp", "-harden-sls-ret", "-hreset", "-idivl-to-divb", "-inline-asm-use-gpr32", "-invpcid", "-kl", "-lea-sp", "-lea-uses-ag", "-lvi-cfi", "-lvi-load-hardening", "-lwp", "-lzcnt", "-movbe", "-movdir64b", "-movdiri", "-movrs", "-mwaitx", "-ndd", "-nf", "-no-bypass-delay", "-no-bypass-delay-blend", "-no-bypass-delay-mov", "-no-bypass-delay-shuffle", "-pad-short-functions", "-pclmul", "-pconfig", "-pku", "-popcnt", "-ppx", "-prefer-128-bit", "-prefer-256-bit", "-prefer-mask-registers", "-prefer-movmsk-over-vtest", "-prefer-no-gather", "-prefer-no-scatter", "-prefetchi", "-prfchw", "-ptwrite", "-push2pop2", "-raoint", "-rdpid", "-rdpru", "-rdrnd", "-rdseed", "-retpoline", "-retpoline-external-thunk", "-retpoline-indirect-branches", "-retpoline-indirect-calls", "-rtm", "-sahf", "-sbb-dep-breaking", "-serialize", "-seses", "-sgx", "-sha", "-sha512", "-shstk", "-slow-lea", "-slow-pmaddwd", "-slow-pmulld", "-slow-shld", "-slow-two-mem-ops", "-slow-unaligned-mem-16", "-slow-unaligned-mem-32", "-sm3", "-sm4", "-soft-float", "-sse", "-sse2", "-sse3", "-sse4.1", "-sse4.2", "-sse4a", "-sse-unaligned-mem", "-ssse3", "-tagged-globals", "-tbm", "-tsxldtrk", "-tuning-fast-imm-vector-shift", "-uintr", "-use-glm-div-sqrt-costs", "-use-slm-arith-costs", "-usermsr", "-vaes", "-vpclmulqdq", "-waitpkg", "-wbnoinvd", "-widekl", "-xop", "-xsave", "-xsavec", "-xsaveopt", "-xsaves", "-zu"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg38: !llvm.ptr, %arg39: !llvm.ptr):
  %915 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %916 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %917 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %918 = "llvm.mlir.constant"() <{value = 4 : i64}> : () -> i64
  %919 = "llvm.mlir.constant"() <{value = 7 : i64}> : () -> i64
  %920 = "llvm.mlir.constant"() <{value = 72057594037927935 : i64}> : () -> i64
  %921 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %922 = "llvm.mlir.constant"() <{value = 28 : i64}> : () -> i64
  %923 = "llvm.mlir.constant"() <{value = 24 : i64}> : () -> i64
  %924 = "llvm.mlir.constant"() <{value = 44162584779952923 : i128}> : () -> i128
  %925 = "llvm.mlir.constant"() <{value = 9390964836247533 : i128}> : () -> i128
  %926 = "llvm.mlir.constant"() <{value = 72057594036560134 : i128}> : () -> i128
  %927 = "llvm.mlir.constant"() <{value = 72057594037927935 : i128}> : () -> i128
  %928 = "llvm.mlir.constant"() <{value = 68719476735 : i128}> : () -> i128
  %929 = "llvm.mlir.constant"() <{value = 56 : i128}> : () -> i128
  %930 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
  %931 = "llvm.mlir.constant"() <{value = 5175514460705773 : i128}> : () -> i128
  %932 = "llvm.mlir.constant"() <{value = 70332060721272408 : i128}> : () -> i128
  %933 = "llvm.mlir.constant"() <{value = 18446744073709546274 : i128}> : () -> i128
  %934 = "llvm.mlir.constant"() <{value = 1099243192320 : i64}> : () -> i64
  %935 = "llvm.mlir.constant"() <{value = 63 : i64}> : () -> i64
  %936 = "llvm.mlir.constant"() <{value = 72057594037927936 : i64}> : () -> i64
  %937 = "llvm.mlir.constant"() <{value = 56 : i64}> : () -> i64
  %938 = "llvm.mlir.constant"() <{value = 1099511627776 : i64}> : () -> i64
  %939 = "llvm.mlir.constant"() <{value = -5175514460705773 : i64}> : () -> i64
  %940 = "llvm.mlir.constant"() <{value = 70332060721272408 : i64}> : () -> i64
  %941 = "llvm.mlir.constant"() <{value = 5342 : i64}> : () -> i64
  %942 = "llvm.mlir.constant"() <{value = 268435456 : i64}> : () -> i64
  %943 = "llvm.alloca"(%915) <{alignment = 8 : i64, elem_type = !llvm.array<10 x i64>}> : (i32) -> !llvm.ptr
  %944 = "llvm.alloca"(%915) <{alignment = 1 : i64, elem_type = !llvm.array<32 x i8>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%943) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%944) : (!llvm.ptr) -> ()
  "llvm.intr.memcpy"(%944, %arg39, %916) <{arg_attrs = [{llvm.align = 1 : i64, llvm.dereferenceable = 32 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 1 : i64, llvm.dereferenceable = 32 : i64, llvm.nonnull, llvm.noundef, llvm.readonly}, {}], isVolatile = false, noalias_scopes = [#alias_scope6]}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.br"(%917)[^bb1] : (i64) -> ()
^bb1(%945: i64):  // 2 preds: ^bb0, ^bb2
  %946 = "llvm.icmp"(%945, %918) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%946)[^bb3, ^bb2] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb2:  // pred: ^bb1
  %947 = "llvm.getelementptr"(%943, %945) <{elem_type = !llvm.array<10 x i64>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 0, -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %948 = "llvm.mul"(%945, %919) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %949 = "llvm.getelementptr"(%944, %948) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %950 = "llvm.load"(%949) <{alignment = 1 : i64, noalias_scopes = [#alias_scope6], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %951 = "llvm.and"(%950, %920) : (i64, i64) -> i64
  "llvm.store"(%951, %947) <{alignment = 8 : i64, noalias_scopes = [#alias_scope6], ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %952 = "llvm.add"(%945, %921) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  "llvm.br"(%952)[^bb1] : (i64) -> ()
^bb3:  // pred: ^bb1
  %953 = "llvm.getelementptr"(%944) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 28>}> : (!llvm.ptr) -> !llvm.ptr
  %954 = "llvm.load"(%953) <{alignment = 1 : i64, noalias_scopes = [#alias_scope6], ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %955 = "llvm.zext"(%954) : (i32) -> i64
  %956 = "llvm.load"(%943) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %957 = "llvm.getelementptr"(%943) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %958 = "llvm.load"(%957) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %959 = "llvm.getelementptr"(%943) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %960 = "llvm.load"(%959) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %961 = "llvm.getelementptr"(%943) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %962 = "llvm.load"(%961) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  "llvm.intr.lifetime.end"(%943) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%944) : (!llvm.ptr) -> ()
  %963 = "llvm.lshr"(%955, %923) : (i64, i64) -> i64
  %964 = "llvm.zext"(%963) <{nonNeg}> : (i64) -> i128
  %965 = "llvm.mul"(%964, %924) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %966 = "llvm.mul"(%964, %925) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %967 = "llvm.mul"(%964, %926) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %968 = "llvm.mul"(%964, %927) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %969 = "llvm.mul"(%964, %928) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %970 = "llvm.lshr"(%965, %929) : (i128, i128) -> i128
  %971 = "llvm.add"(%970, %966) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %972 = "llvm.lshr"(%971, %929) : (i128, i128) -> i128
  %973 = "llvm.add"(%972, %967) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %974 = "llvm.lshr"(%973, %929) : (i128, i128) -> i128
  %975 = "llvm.add"(%974, %968) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %976 = "llvm.lshr"(%975, %929) : (i128, i128) -> i128
  %977 = "llvm.add"(%976, %969) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %978 = "llvm.trunc"(%977) <{overflowFlags = 3 : i32}> : (i128) -> i64
  %979 = "llvm.lshr"(%978, %930) : (i64, i64) -> i64
  %980 = "llvm.zext"(%979) <{nonNeg}> : (i64) -> i128
  %981 = "llvm.mul"(%980, %931) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %982 = "llvm.mul"(%980, %932) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %983 = "llvm.mul"(%980, %933) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %984 = "llvm.shl"(%979, %922) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %985 = "llvm.lshr"(%981, %929) : (i128, i128) -> i128
  %986 = "llvm.trunc"(%981) <{overflowFlags = 3 : i32}> : (i128) -> i64
  %987 = "llvm.and"(%986, %920) : (i64, i64) -> i64
  %988 = "llvm.add"(%985, %982) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %989 = "llvm.lshr"(%988, %929) : (i128, i128) -> i128
  %990 = "llvm.trunc"(%988) <{overflowFlags = 3 : i32}> : (i128) -> i64
  %991 = "llvm.and"(%990, %920) : (i64, i64) -> i64
  %992 = "llvm.sub"(%983, %989) <{overflowFlags = 1 : i32}> : (i128, i128) -> i128
  %993 = "llvm.trunc"(%992) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %994 = "llvm.and"(%984, %934) : (i64, i64) -> i64
  %995 = "llvm.sub"(%956, %987) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %996 = "llvm.ashr"(%995, %935) : (i64, i64) -> i64
  %997 = "llvm.lshr"(%995, %919) : (i64, i64) -> i64
  %998 = "llvm.and"(%997, %936) : (i64, i64) -> i64
  %999 = "llvm.add"(%998, %995) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1000 = "llvm.add"(%996, %958) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1001 = "llvm.sub"(%1000, %991) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1002 = "llvm.ashr"(%1001, %935) : (i64, i64) -> i64
  %1003 = "llvm.lshr"(%1001, %919) : (i64, i64) -> i64
  %1004 = "llvm.and"(%1003, %936) : (i64, i64) -> i64
  %1005 = "llvm.add"(%1004, %1001) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1006 = "llvm.add"(%960, %993) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1007 = "llvm.add"(%1006, %1002) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1008 = "llvm.ashr"(%1007, %935) : (i64, i64) -> i64
  %1009 = "llvm.lshr"(%1007, %935) : (i64, i64) -> i64
  %1010 = "llvm.shl"(%1009, %937) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1011 = "llvm.add"(%1010, %1007) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1012 = "llvm.sub"(%962, %1009) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1013 = "llvm.lshr"(%1012, %935) : (i64, i64) -> i64
  %1014 = "llvm.shl"(%1013, %937) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1015 = "llvm.add"(%1008, %962) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1016 = "llvm.add"(%1015, %1014) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1017 = "llvm.or"(%1013, %994) <{isDisjoint}> : (i64, i64) -> i64
  %1018 = "llvm.icmp"(%1017, %955) <{predicate = 8 : i64}> : (i64, i64) -> i1
  %1019 = "llvm.select"(%1018, %938, %917) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %1020 = "llvm.or"(%1019, %955) <{isDisjoint}> : (i64, i64) -> i64
  %1021 = "llvm.sub"(%1020, %1017) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1022 = "llvm.add"(%999, %939) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1023 = "llvm.lshr"(%1022, %935) : (i64, i64) -> i64
  %1024 = "llvm.shl"(%1023, %937) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1025 = "llvm.add"(%1024, %1022) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1026 = "llvm.or"(%1023, %940) <{isDisjoint}> : (i64, i64) -> i64
  %1027 = "llvm.sub"(%1005, %1026) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1028 = "llvm.lshr"(%1027, %935) : (i64, i64) -> i64
  %1029 = "llvm.shl"(%1028, %937) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1030 = "llvm.add"(%1029, %1027) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1031 = "llvm.or"(%1028, %941) <{isDisjoint}> : (i64, i64) -> i64
  %1032 = "llvm.sub"(%1011, %1031) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1033 = "llvm.ashr"(%1032, %935) : (i64, i64) -> i64
  %1034 = "llvm.lshr"(%1032, %935) : (i64, i64) -> i64
  %1035 = "llvm.shl"(%1034, %937) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1036 = "llvm.add"(%1035, %1032) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1037 = "llvm.sub"(%1016, %1034) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1038 = "llvm.lshr"(%1037, %935) : (i64, i64) -> i64
  %1039 = "llvm.shl"(%1038, %937) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1040 = "llvm.add"(%1033, %1016) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1041 = "llvm.add"(%1040, %1039) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1042 = "llvm.or"(%1038, %942) <{isDisjoint}> : (i64, i64) -> i64
  %1043 = "llvm.icmp"(%1021, %1042) <{predicate = 2 : i64}> : (i64, i64) -> i1
  %1044 = "llvm.select"(%1043, %999, %1025) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %1045 = "llvm.select"(%1043, %1005, %1030) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %1046 = "llvm.select"(%1043, %1011, %1036) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %1047 = "llvm.select"(%1043, %1016, %1041) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %1048 = "llvm.select"(%1043, %917, %1042) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %1049 = "llvm.sub"(%1021, %1048) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  "llvm.store"(%1044, %arg38) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1050 = "llvm.getelementptr"(%arg38) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1045, %1050) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1051 = "llvm.getelementptr"(%arg38) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1046, %1051) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1052 = "llvm.getelementptr"(%arg38) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1047, %1052) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1053 = "llvm.getelementptr"(%arg38) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1049, %1053) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
