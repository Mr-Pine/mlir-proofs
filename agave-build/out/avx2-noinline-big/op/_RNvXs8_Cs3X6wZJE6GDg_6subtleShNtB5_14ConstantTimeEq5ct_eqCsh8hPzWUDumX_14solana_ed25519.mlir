"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<i8 (ptr, ptr)>, inline_hint, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], personality = @rust_eh_personality, res_attrs = [{llvm.noundef}], sym_name = "_RNvXs8_Cs3X6wZJE6GDg_6subtleShNtB5_14ConstantTimeEq5ct_eqCsh8hPzWUDumX_14solana_ed25519", target_cpu = "x86-64-v2", target_features = #llvm.target_features<["+avx", "+avx2", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+crc32", "+ssse3"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg89: !llvm.ptr, %arg90: !llvm.ptr):
  %3061 = "llvm.mlir.constant"() <{value = 1 : i8}> : () -> i8
  %3062 = "llvm.load"(%arg89) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3063 = "llvm.load"(%arg90) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3064 = "llvm.icmp"(%3062, %3063) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %3065 = "llvm.zext"(%3064) : (i1) -> i8
  %3066 = "llvm.call"(%3065) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %3067 = "llvm.and"(%3066, %3061) : (i8, i8) -> i8
  %3068 = "llvm.getelementptr"(%arg89) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1>}> : (!llvm.ptr) -> !llvm.ptr
  %3069 = "llvm.getelementptr"(%arg90) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1>}> : (!llvm.ptr) -> !llvm.ptr
  %3070 = "llvm.load"(%3068) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3071 = "llvm.load"(%3069) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3072 = "llvm.icmp"(%3070, %3071) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %3073 = "llvm.zext"(%3072) : (i1) -> i8
  %3074 = "llvm.call"(%3073) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %3075 = "llvm.and"(%3074, %3067) : (i8, i8) -> i8
  %3076 = "llvm.getelementptr"(%arg89) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2>}> : (!llvm.ptr) -> !llvm.ptr
  %3077 = "llvm.getelementptr"(%arg90) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2>}> : (!llvm.ptr) -> !llvm.ptr
  %3078 = "llvm.load"(%3076) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3079 = "llvm.load"(%3077) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3080 = "llvm.icmp"(%3078, %3079) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %3081 = "llvm.zext"(%3080) : (i1) -> i8
  %3082 = "llvm.call"(%3081) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %3083 = "llvm.and"(%3082, %3075) : (i8, i8) -> i8
  %3084 = "llvm.getelementptr"(%arg89) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 3>}> : (!llvm.ptr) -> !llvm.ptr
  %3085 = "llvm.getelementptr"(%arg90) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 3>}> : (!llvm.ptr) -> !llvm.ptr
  %3086 = "llvm.load"(%3084) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3087 = "llvm.load"(%3085) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3088 = "llvm.icmp"(%3086, %3087) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %3089 = "llvm.zext"(%3088) : (i1) -> i8
  %3090 = "llvm.call"(%3089) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %3091 = "llvm.and"(%3090, %3083) : (i8, i8) -> i8
  %3092 = "llvm.getelementptr"(%arg89) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4>}> : (!llvm.ptr) -> !llvm.ptr
  %3093 = "llvm.getelementptr"(%arg90) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4>}> : (!llvm.ptr) -> !llvm.ptr
  %3094 = "llvm.load"(%3092) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3095 = "llvm.load"(%3093) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3096 = "llvm.icmp"(%3094, %3095) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %3097 = "llvm.zext"(%3096) : (i1) -> i8
  %3098 = "llvm.call"(%3097) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %3099 = "llvm.and"(%3098, %3091) : (i8, i8) -> i8
  %3100 = "llvm.getelementptr"(%arg89) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 5>}> : (!llvm.ptr) -> !llvm.ptr
  %3101 = "llvm.getelementptr"(%arg90) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 5>}> : (!llvm.ptr) -> !llvm.ptr
  %3102 = "llvm.load"(%3100) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3103 = "llvm.load"(%3101) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3104 = "llvm.icmp"(%3102, %3103) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %3105 = "llvm.zext"(%3104) : (i1) -> i8
  %3106 = "llvm.call"(%3105) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %3107 = "llvm.and"(%3106, %3099) : (i8, i8) -> i8
  %3108 = "llvm.getelementptr"(%arg89) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6>}> : (!llvm.ptr) -> !llvm.ptr
  %3109 = "llvm.getelementptr"(%arg90) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6>}> : (!llvm.ptr) -> !llvm.ptr
  %3110 = "llvm.load"(%3108) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3111 = "llvm.load"(%3109) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3112 = "llvm.icmp"(%3110, %3111) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %3113 = "llvm.zext"(%3112) : (i1) -> i8
  %3114 = "llvm.call"(%3113) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %3115 = "llvm.and"(%3114, %3107) : (i8, i8) -> i8
  %3116 = "llvm.getelementptr"(%arg89) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 7>}> : (!llvm.ptr) -> !llvm.ptr
  %3117 = "llvm.getelementptr"(%arg90) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 7>}> : (!llvm.ptr) -> !llvm.ptr
  %3118 = "llvm.load"(%3116) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3119 = "llvm.load"(%3117) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3120 = "llvm.icmp"(%3118, %3119) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %3121 = "llvm.zext"(%3120) : (i1) -> i8
  %3122 = "llvm.call"(%3121) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %3123 = "llvm.and"(%3122, %3115) : (i8, i8) -> i8
  %3124 = "llvm.getelementptr"(%arg89) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %3125 = "llvm.getelementptr"(%arg90) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %3126 = "llvm.load"(%3124) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3127 = "llvm.load"(%3125) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3128 = "llvm.icmp"(%3126, %3127) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %3129 = "llvm.zext"(%3128) : (i1) -> i8
  %3130 = "llvm.call"(%3129) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %3131 = "llvm.and"(%3130, %3123) : (i8, i8) -> i8
  %3132 = "llvm.getelementptr"(%arg89) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 9>}> : (!llvm.ptr) -> !llvm.ptr
  %3133 = "llvm.getelementptr"(%arg90) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 9>}> : (!llvm.ptr) -> !llvm.ptr
  %3134 = "llvm.load"(%3132) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3135 = "llvm.load"(%3133) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3136 = "llvm.icmp"(%3134, %3135) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %3137 = "llvm.zext"(%3136) : (i1) -> i8
  %3138 = "llvm.call"(%3137) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %3139 = "llvm.and"(%3138, %3131) : (i8, i8) -> i8
  %3140 = "llvm.getelementptr"(%arg89) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 10>}> : (!llvm.ptr) -> !llvm.ptr
  %3141 = "llvm.getelementptr"(%arg90) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 10>}> : (!llvm.ptr) -> !llvm.ptr
  %3142 = "llvm.load"(%3140) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3143 = "llvm.load"(%3141) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3144 = "llvm.icmp"(%3142, %3143) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %3145 = "llvm.zext"(%3144) : (i1) -> i8
  %3146 = "llvm.call"(%3145) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %3147 = "llvm.and"(%3146, %3139) : (i8, i8) -> i8
  %3148 = "llvm.getelementptr"(%arg89) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 11>}> : (!llvm.ptr) -> !llvm.ptr
  %3149 = "llvm.getelementptr"(%arg90) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 11>}> : (!llvm.ptr) -> !llvm.ptr
  %3150 = "llvm.load"(%3148) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3151 = "llvm.load"(%3149) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3152 = "llvm.icmp"(%3150, %3151) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %3153 = "llvm.zext"(%3152) : (i1) -> i8
  %3154 = "llvm.call"(%3153) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %3155 = "llvm.and"(%3154, %3147) : (i8, i8) -> i8
  %3156 = "llvm.getelementptr"(%arg89) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 12>}> : (!llvm.ptr) -> !llvm.ptr
  %3157 = "llvm.getelementptr"(%arg90) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 12>}> : (!llvm.ptr) -> !llvm.ptr
  %3158 = "llvm.load"(%3156) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3159 = "llvm.load"(%3157) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3160 = "llvm.icmp"(%3158, %3159) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %3161 = "llvm.zext"(%3160) : (i1) -> i8
  %3162 = "llvm.call"(%3161) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %3163 = "llvm.and"(%3162, %3155) : (i8, i8) -> i8
  %3164 = "llvm.getelementptr"(%arg89) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 13>}> : (!llvm.ptr) -> !llvm.ptr
  %3165 = "llvm.getelementptr"(%arg90) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 13>}> : (!llvm.ptr) -> !llvm.ptr
  %3166 = "llvm.load"(%3164) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3167 = "llvm.load"(%3165) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3168 = "llvm.icmp"(%3166, %3167) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %3169 = "llvm.zext"(%3168) : (i1) -> i8
  %3170 = "llvm.call"(%3169) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %3171 = "llvm.and"(%3170, %3163) : (i8, i8) -> i8
  %3172 = "llvm.getelementptr"(%arg89) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 14>}> : (!llvm.ptr) -> !llvm.ptr
  %3173 = "llvm.getelementptr"(%arg90) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 14>}> : (!llvm.ptr) -> !llvm.ptr
  %3174 = "llvm.load"(%3172) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3175 = "llvm.load"(%3173) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3176 = "llvm.icmp"(%3174, %3175) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %3177 = "llvm.zext"(%3176) : (i1) -> i8
  %3178 = "llvm.call"(%3177) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %3179 = "llvm.and"(%3178, %3171) : (i8, i8) -> i8
  %3180 = "llvm.getelementptr"(%arg89) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 15>}> : (!llvm.ptr) -> !llvm.ptr
  %3181 = "llvm.getelementptr"(%arg90) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 15>}> : (!llvm.ptr) -> !llvm.ptr
  %3182 = "llvm.load"(%3180) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3183 = "llvm.load"(%3181) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3184 = "llvm.icmp"(%3182, %3183) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %3185 = "llvm.zext"(%3184) : (i1) -> i8
  %3186 = "llvm.call"(%3185) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %3187 = "llvm.and"(%3186, %3179) : (i8, i8) -> i8
  %3188 = "llvm.getelementptr"(%arg89) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %3189 = "llvm.getelementptr"(%arg90) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %3190 = "llvm.load"(%3188) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3191 = "llvm.load"(%3189) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3192 = "llvm.icmp"(%3190, %3191) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %3193 = "llvm.zext"(%3192) : (i1) -> i8
  %3194 = "llvm.call"(%3193) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %3195 = "llvm.and"(%3194, %3187) : (i8, i8) -> i8
  %3196 = "llvm.getelementptr"(%arg89) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 17>}> : (!llvm.ptr) -> !llvm.ptr
  %3197 = "llvm.getelementptr"(%arg90) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 17>}> : (!llvm.ptr) -> !llvm.ptr
  %3198 = "llvm.load"(%3196) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3199 = "llvm.load"(%3197) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3200 = "llvm.icmp"(%3198, %3199) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %3201 = "llvm.zext"(%3200) : (i1) -> i8
  %3202 = "llvm.call"(%3201) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %3203 = "llvm.and"(%3202, %3195) : (i8, i8) -> i8
  %3204 = "llvm.getelementptr"(%arg89) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 18>}> : (!llvm.ptr) -> !llvm.ptr
  %3205 = "llvm.getelementptr"(%arg90) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 18>}> : (!llvm.ptr) -> !llvm.ptr
  %3206 = "llvm.load"(%3204) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3207 = "llvm.load"(%3205) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3208 = "llvm.icmp"(%3206, %3207) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %3209 = "llvm.zext"(%3208) : (i1) -> i8
  %3210 = "llvm.call"(%3209) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %3211 = "llvm.and"(%3210, %3203) : (i8, i8) -> i8
  %3212 = "llvm.getelementptr"(%arg89) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 19>}> : (!llvm.ptr) -> !llvm.ptr
  %3213 = "llvm.getelementptr"(%arg90) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 19>}> : (!llvm.ptr) -> !llvm.ptr
  %3214 = "llvm.load"(%3212) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3215 = "llvm.load"(%3213) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3216 = "llvm.icmp"(%3214, %3215) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %3217 = "llvm.zext"(%3216) : (i1) -> i8
  %3218 = "llvm.call"(%3217) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %3219 = "llvm.and"(%3218, %3211) : (i8, i8) -> i8
  %3220 = "llvm.getelementptr"(%arg89) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 20>}> : (!llvm.ptr) -> !llvm.ptr
  %3221 = "llvm.getelementptr"(%arg90) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 20>}> : (!llvm.ptr) -> !llvm.ptr
  %3222 = "llvm.load"(%3220) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3223 = "llvm.load"(%3221) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3224 = "llvm.icmp"(%3222, %3223) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %3225 = "llvm.zext"(%3224) : (i1) -> i8
  %3226 = "llvm.call"(%3225) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %3227 = "llvm.and"(%3226, %3219) : (i8, i8) -> i8
  %3228 = "llvm.getelementptr"(%arg89) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 21>}> : (!llvm.ptr) -> !llvm.ptr
  %3229 = "llvm.getelementptr"(%arg90) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 21>}> : (!llvm.ptr) -> !llvm.ptr
  %3230 = "llvm.load"(%3228) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3231 = "llvm.load"(%3229) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3232 = "llvm.icmp"(%3230, %3231) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %3233 = "llvm.zext"(%3232) : (i1) -> i8
  %3234 = "llvm.call"(%3233) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %3235 = "llvm.and"(%3234, %3227) : (i8, i8) -> i8
  %3236 = "llvm.getelementptr"(%arg89) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 22>}> : (!llvm.ptr) -> !llvm.ptr
  %3237 = "llvm.getelementptr"(%arg90) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 22>}> : (!llvm.ptr) -> !llvm.ptr
  %3238 = "llvm.load"(%3236) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3239 = "llvm.load"(%3237) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3240 = "llvm.icmp"(%3238, %3239) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %3241 = "llvm.zext"(%3240) : (i1) -> i8
  %3242 = "llvm.call"(%3241) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %3243 = "llvm.and"(%3242, %3235) : (i8, i8) -> i8
  %3244 = "llvm.getelementptr"(%arg89) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 23>}> : (!llvm.ptr) -> !llvm.ptr
  %3245 = "llvm.getelementptr"(%arg90) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 23>}> : (!llvm.ptr) -> !llvm.ptr
  %3246 = "llvm.load"(%3244) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3247 = "llvm.load"(%3245) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3248 = "llvm.icmp"(%3246, %3247) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %3249 = "llvm.zext"(%3248) : (i1) -> i8
  %3250 = "llvm.call"(%3249) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %3251 = "llvm.and"(%3250, %3243) : (i8, i8) -> i8
  %3252 = "llvm.getelementptr"(%arg89) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %3253 = "llvm.getelementptr"(%arg90) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %3254 = "llvm.load"(%3252) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3255 = "llvm.load"(%3253) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3256 = "llvm.icmp"(%3254, %3255) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %3257 = "llvm.zext"(%3256) : (i1) -> i8
  %3258 = "llvm.call"(%3257) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %3259 = "llvm.and"(%3258, %3251) : (i8, i8) -> i8
  %3260 = "llvm.getelementptr"(%arg89) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 25>}> : (!llvm.ptr) -> !llvm.ptr
  %3261 = "llvm.getelementptr"(%arg90) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 25>}> : (!llvm.ptr) -> !llvm.ptr
  %3262 = "llvm.load"(%3260) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3263 = "llvm.load"(%3261) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3264 = "llvm.icmp"(%3262, %3263) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %3265 = "llvm.zext"(%3264) : (i1) -> i8
  %3266 = "llvm.call"(%3265) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %3267 = "llvm.and"(%3266, %3259) : (i8, i8) -> i8
  %3268 = "llvm.getelementptr"(%arg89) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 26>}> : (!llvm.ptr) -> !llvm.ptr
  %3269 = "llvm.getelementptr"(%arg90) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 26>}> : (!llvm.ptr) -> !llvm.ptr
  %3270 = "llvm.load"(%3268) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3271 = "llvm.load"(%3269) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3272 = "llvm.icmp"(%3270, %3271) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %3273 = "llvm.zext"(%3272) : (i1) -> i8
  %3274 = "llvm.call"(%3273) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %3275 = "llvm.and"(%3274, %3267) : (i8, i8) -> i8
  %3276 = "llvm.getelementptr"(%arg89) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 27>}> : (!llvm.ptr) -> !llvm.ptr
  %3277 = "llvm.getelementptr"(%arg90) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 27>}> : (!llvm.ptr) -> !llvm.ptr
  %3278 = "llvm.load"(%3276) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3279 = "llvm.load"(%3277) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3280 = "llvm.icmp"(%3278, %3279) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %3281 = "llvm.zext"(%3280) : (i1) -> i8
  %3282 = "llvm.call"(%3281) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %3283 = "llvm.and"(%3282, %3275) : (i8, i8) -> i8
  %3284 = "llvm.getelementptr"(%arg89) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 28>}> : (!llvm.ptr) -> !llvm.ptr
  %3285 = "llvm.getelementptr"(%arg90) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 28>}> : (!llvm.ptr) -> !llvm.ptr
  %3286 = "llvm.load"(%3284) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3287 = "llvm.load"(%3285) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3288 = "llvm.icmp"(%3286, %3287) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %3289 = "llvm.zext"(%3288) : (i1) -> i8
  %3290 = "llvm.call"(%3289) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %3291 = "llvm.and"(%3290, %3283) : (i8, i8) -> i8
  %3292 = "llvm.getelementptr"(%arg89) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 29>}> : (!llvm.ptr) -> !llvm.ptr
  %3293 = "llvm.getelementptr"(%arg90) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 29>}> : (!llvm.ptr) -> !llvm.ptr
  %3294 = "llvm.load"(%3292) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3295 = "llvm.load"(%3293) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3296 = "llvm.icmp"(%3294, %3295) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %3297 = "llvm.zext"(%3296) : (i1) -> i8
  %3298 = "llvm.call"(%3297) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %3299 = "llvm.and"(%3298, %3291) : (i8, i8) -> i8
  %3300 = "llvm.getelementptr"(%arg89) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 30>}> : (!llvm.ptr) -> !llvm.ptr
  %3301 = "llvm.getelementptr"(%arg90) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 30>}> : (!llvm.ptr) -> !llvm.ptr
  %3302 = "llvm.load"(%3300) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3303 = "llvm.load"(%3301) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3304 = "llvm.icmp"(%3302, %3303) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %3305 = "llvm.zext"(%3304) : (i1) -> i8
  %3306 = "llvm.call"(%3305) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %3307 = "llvm.and"(%3306, %3299) : (i8, i8) -> i8
  %3308 = "llvm.getelementptr"(%arg89) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 31>}> : (!llvm.ptr) -> !llvm.ptr
  %3309 = "llvm.getelementptr"(%arg90) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 31>}> : (!llvm.ptr) -> !llvm.ptr
  %3310 = "llvm.load"(%3308) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3311 = "llvm.load"(%3309) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3312 = "llvm.icmp"(%3310, %3311) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %3313 = "llvm.zext"(%3312) : (i1) -> i8
  %3314 = "llvm.call"(%3313) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %3315 = "llvm.and"(%3314, %3307) : (i8, i8) -> i8
  %3316 = "llvm.call"(%3315) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  "llvm.return"(%3316) : (i8) -> ()
}) : () -> ()
