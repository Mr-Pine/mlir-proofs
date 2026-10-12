#alias_scope_domain95 = #llvm.alias_scope_domain<id = distinct[95]<>, description = "_RINvMs7_Cs3W1RDSGGXeA_12block_bufferINtB6_11BlockBufferINtNtCsjV7382Ccq4g_7typenum4uint4UIntIBS_IBS_IBS_IBS_IBS_IBS_IBS_NtBU_5UTermNtNtBW_3bit2B1ENtB27_2B0EB2k_EB2k_EB2k_EB2k_EB2k_EB2k_ENtB6_5EagerE10digest_padNCNvXsd_NtCsgIn12VVV7xy_4sha29block_apiNtB3u_13Sha512VarCoreNtNtCs1e9z9zBfBch_6digest9block_api18VariableOutputCore22finalize_variable_core0ECsh8hPzWUDumX_14solana_ed25519">
#alias_scope143 = #llvm.alias_scope<id = distinct[272]<>, domain = #alias_scope_domain95, description = "_RINvMs7_Cs3W1RDSGGXeA_12block_bufferINtB6_11BlockBufferINtNtCsjV7382Ccq4g_7typenum4uint4UIntIBS_IBS_IBS_IBS_IBS_IBS_IBS_NtBU_5UTermNtNtBW_3bit2B1ENtB27_2B0EB2k_EB2k_EB2k_EB2k_EB2k_EB2k_ENtB6_5EagerE10digest_padNCNvXsd_NtCsgIn12VVV7xy_4sha29block_apiNtB3u_13Sha512VarCoreNtNtCs1e9z9zBfBch_6digest9block_api18VariableOutputCore22finalize_variable_core0ECsh8hPzWUDumX_14solana_ed25519: argument 0">
#alias_scope144 = #llvm.alias_scope<id = distinct[273]<>, domain = #alias_scope_domain95, description = "_RINvMs7_Cs3W1RDSGGXeA_12block_bufferINtB6_11BlockBufferINtNtCsjV7382Ccq4g_7typenum4uint4UIntIBS_IBS_IBS_IBS_IBS_IBS_IBS_NtBU_5UTermNtNtBW_3bit2B1ENtB27_2B0EB2k_EB2k_EB2k_EB2k_EB2k_EB2k_ENtB6_5EagerE10digest_padNCNvXsd_NtCsgIn12VVV7xy_4sha29block_apiNtB3u_13Sha512VarCoreNtNtCs1e9z9zBfBch_6digest9block_api18VariableOutputCore22finalize_variable_core0ECsh8hPzWUDumX_14solana_ed25519: argument 1">
#alias_scope145 = #llvm.alias_scope<id = distinct[274]<>, domain = #alias_scope_domain95, description = "_RINvMs7_Cs3W1RDSGGXeA_12block_bufferINtB6_11BlockBufferINtNtCsjV7382Ccq4g_7typenum4uint4UIntIBS_IBS_IBS_IBS_IBS_IBS_IBS_NtBU_5UTermNtNtBW_3bit2B1ENtB27_2B0EB2k_EB2k_EB2k_EB2k_EB2k_EB2k_ENtB6_5EagerE10digest_padNCNvXsd_NtCsgIn12VVV7xy_4sha29block_apiNtB3u_13Sha512VarCoreNtNtCs1e9z9zBfBch_6digest9block_api18VariableOutputCore22finalize_variable_core0ECsh8hPzWUDumX_14solana_ed25519: argument 2">
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 16 : i64, llvm.dereferenceable = 80 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.dereferenceable = 128 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.dereferenceable = 64 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writeonly}], dso_local, function_type = !llvm.func<void (ptr, ptr, ptr)>, inline_hint, linkage = #llvm.linkage<internal>, no_inline, passthrough = ["nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], personality = @rust_eh_personality, sym_name = "_RNvXsd_NtCsgIn12VVV7xy_4sha29block_apiNtB5_13Sha512VarCoreNtNtCs1e9z9zBfBch_6digest9block_api18VariableOutputCore22finalize_variable_core", target_cpu = "x86-64-v2", target_features = #llvm.target_features<["+avx", "+avx2", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+crc32", "+ssse3"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg28: !llvm.ptr, %arg29: !llvm.ptr, %arg30: !llvm.ptr):
  %457 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %458 = "llvm.mlir.constant"() <{value = -1 : i8}> : () -> i8
  %459 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %460 = "llvm.mlir.constant"() <{value = 128 : i64}> : () -> i64
  %461 = "llvm.mlir.addressof"() <{global_name = @anon.e79fcfe266c5706188f989b4d452749f.44}> : () -> !llvm.ptr
  %462 = "llvm.mlir.constant"() <{value = -128 : i8}> : () -> i8
  %463 = "llvm.mlir.constant"() <{value = 112 : i64}> : () -> i64
  %464 = "llvm.mlir.constant"() <{value = 16 : i64}> : () -> i64
  %465 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %466 = "llvm.mlir.constant"() <{value = 10 : i128}> : () -> i128
  %467 = "llvm.mlir.constant"() <{value = 3 : i128}> : () -> i128
  %468 = "llvm.alloca"(%457) <{alignment = 1 : i64, elem_type = !llvm.array<128 x i8>}> : (i32) -> !llvm.ptr
  %469 = "llvm.getelementptr"(%arg29) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 127>}> : (!llvm.ptr) -> !llvm.ptr
  %470 = "llvm.load"(%469) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %471 = "llvm.icmp"(%470, %458) <{predicate = 4 : i64}> : (i8, i8) -> i1
  "llvm.intr.assume"(%471) <{op_bundle_sizes = array<i32>}> : (i1) -> ()
  %472 = "llvm.getelementptr"(%arg28) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %473 = "llvm.load"(%472) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i128
  "llvm.intr.memset"(%468, %459, %460) <{arg_attrs = [{llvm.align = 1 : i64, llvm.dereferenceable = 128 : i64, llvm.nonnull, llvm.noundef}, {}, {}], isVolatile = false}> : (!llvm.ptr, i8, i64) -> ()
  %474 = "llvm.zext"(%470) <{nonNeg}> : (i8) -> i64
  "llvm.call"(%468, %474, %arg29, %474, %461) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.dereferenceable = 128 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 24 : i64, llvm.noalias, llvm.nofree, llvm.noundef, llvm.readonly}], callee = @_RINvNtCsgxBkk5gSRhY_4core5slice20copy_from_slice_implhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (!llvm.ptr, i64, !llvm.ptr, i64, !llvm.ptr) -> ()
  %475 = "llvm.getelementptr"(%468, %474) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%462, %475) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %476 = "llvm.xor"(%474, %463) : (i64, i64) -> i64
  %477 = "llvm.icmp"(%476, %464) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%477)[^bb1, ^bb2] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb1:  // pred: ^bb0
  "llvm.call"(%arg28, %468, %465) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 64 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.noundef}], callee = @_RNvNtCsgIn12VVV7xy_4sha26sha51211compress512, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.intr.memset"(%468, %459, %463) <{arg_attrs = [{llvm.align = 1 : i64, llvm.dereferenceable = 128 : i64, llvm.nonnull, llvm.noundef}, {}, {}], isVolatile = false}> : (!llvm.ptr, i8, i64) -> ()
  "llvm.br"()[^bb2] : () -> ()
^bb2:  // 2 preds: ^bb0, ^bb1
  %478 = "llvm.shl"(%473, %466) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %479 = "llvm.zext"(%470) <{nonNeg}> : (i8) -> i128
  %480 = "llvm.shl"(%479, %467) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %481 = "llvm.or"(%478, %480) <{isDisjoint}> : (i128, i128) -> i128
  %482 = "llvm.intr.bswap"(%481) : (i128) -> i128
  %483 = "llvm.getelementptr"(%468) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 112>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%482, %483) <{alignment = 1 : i64, ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
  "llvm.call"(%arg28, %468, %465) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 64 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.noundef}], callee = @_RNvNtCsgIn12VVV7xy_4sha26sha51211compress512, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.store"(%459, %469) <{alias_scopes = [#alias_scope143], alignment = 1 : i64, noalias_scopes = [#alias_scope144, #alias_scope145], ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %484 = "llvm.load"(%arg28) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %485 = "llvm.intr.bswap"(%484) : (vector<4xi64>) -> vector<4xi64>
  "llvm.store"(%485, %arg30) <{alignment = 1 : i64, noalias_scopes = [], ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %486 = "llvm.getelementptr"(%arg30) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %487 = "llvm.getelementptr"(%arg28) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %488 = "llvm.load"(%487) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %489 = "llvm.intr.bswap"(%488) : (vector<4xi64>) -> vector<4xi64>
  "llvm.store"(%489, %486) <{alignment = 1 : i64, noalias_scopes = [], ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
