#alias_scope_domain37 = #llvm.alias_scope_domain<id = distinct[37]<>, description = "_RINvXNtCs3W1RDSGGXeA_12block_buffer6sealedNtB5_5EagerNtB3_6Sealed7set_posINtNtCsjV7382Ccq4g_7typenum4uint4UIntIB1a_IB1a_IB1a_IB1a_IB1a_IB1a_IB1a_NtB1c_5UTermNtNtB1e_3bit2B1ENtB2x_2B0EB2L_EB2L_EB2L_EB2L_EB2L_EB2L_EECs2JGgYtL0Fal_14solana_ed25519">
#alias_scope_domain38 = #llvm.alias_scope_domain<id = distinct[38]<>, description = "_RNCNvXsv_CsgIn12VVV7xy_4sha2NtB7_6Sha512NtCs1e9z9zBfBch_6digest6Update6update0Cs2JGgYtL0Fal_14solana_ed25519">
#alias_scope_domain39 = #llvm.alias_scope_domain<id = distinct[39]<>, description = "_RNCNvXsv_CsgIn12VVV7xy_4sha2NtB7_6Sha512NtCs1e9z9zBfBch_6digest6Update6update0Cs2JGgYtL0Fal_14solana_ed25519">
#alias_scope_domain40 = #llvm.alias_scope_domain<id = distinct[40]<>, description = "_RINvXNtCs3W1RDSGGXeA_12block_buffer6sealedNtB5_5EagerNtB3_6Sealed7set_posINtNtCsjV7382Ccq4g_7typenum4uint4UIntIB1a_IB1a_IB1a_IB1a_IB1a_IB1a_IB1a_NtB1c_5UTermNtNtB1e_3bit2B1ENtB2x_2B0EB2L_EB2L_EB2L_EB2L_EB2L_EB2L_EECs2JGgYtL0Fal_14solana_ed25519">
#alias_scope57 = #llvm.alias_scope<id = distinct[133]<>, domain = #alias_scope_domain37, description = "_RINvXNtCs3W1RDSGGXeA_12block_buffer6sealedNtB5_5EagerNtB3_6Sealed7set_posINtNtCsjV7382Ccq4g_7typenum4uint4UIntIB1a_IB1a_IB1a_IB1a_IB1a_IB1a_IB1a_NtB1c_5UTermNtNtB1e_3bit2B1ENtB2x_2B0EB2L_EB2L_EB2L_EB2L_EB2L_EB2L_EECs2JGgYtL0Fal_14solana_ed25519: argument 0">
#alias_scope58 = #llvm.alias_scope<id = distinct[134]<>, domain = #alias_scope_domain38, description = "_RNCNvXsv_CsgIn12VVV7xy_4sha2NtB7_6Sha512NtCs1e9z9zBfBch_6digest6Update6update0Cs2JGgYtL0Fal_14solana_ed25519: argument 0">
#alias_scope59 = #llvm.alias_scope<id = distinct[135]<>, domain = #alias_scope_domain39, description = "_RNCNvXsv_CsgIn12VVV7xy_4sha2NtB7_6Sha512NtCs1e9z9zBfBch_6digest6Update6update0Cs2JGgYtL0Fal_14solana_ed25519: argument 0">
#alias_scope60 = #llvm.alias_scope<id = distinct[136]<>, domain = #alias_scope_domain40, description = "_RINvXNtCs3W1RDSGGXeA_12block_buffer6sealedNtB5_5EagerNtB3_6Sealed7set_posINtNtCsjV7382Ccq4g_7typenum4uint4UIntIB1a_IB1a_IB1a_IB1a_IB1a_IB1a_IB1a_NtB1c_5UTermNtNtB1e_3bit2B1ENtB2x_2B0EB2L_EB2L_EB2L_EB2L_EB2L_EB2L_EECs2JGgYtL0Fal_14solana_ed25519: argument 0">
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.dereferenceable = 128 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.noundef, llvm.range = #llvm.constant_range<i64, 0, -9223372036854775808>}, {llvm.align = 16 : i64, llvm.dereferenceable = 80 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}], dso_local, function_type = !llvm.func<void (ptr, ptr, i64, ptr)>, inline_hint, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], personality = @rust_eh_personality, sym_name = "_RINvMs5_Cs3W1RDSGGXeA_12block_bufferINtB6_11BlockBufferINtNtCsjV7382Ccq4g_7typenum4uint4UIntIBS_IBS_IBS_IBS_IBS_IBS_IBS_NtBU_5UTermNtNtBW_3bit2B1ENtB27_2B0EB2k_EB2k_EB2k_EB2k_EB2k_EB2k_ENtB6_5EagerE13digest_blocksNCNvXsv_CsgIn12VVV7xy_4sha2NtB3x_6Sha512NtCs1e9z9zBfBch_6digest6Update6update0ECs2JGgYtL0Fal_14solana_ed25519", target_cpu = "x86-64-v2", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg26: !llvm.ptr, %arg27: !llvm.ptr, %arg28: i64, %arg29: !llvm.ptr):
  %378 = "llvm.mlir.constant"() <{value = 127 : i64}> : () -> i64
  %379 = "llvm.mlir.constant"() <{value = -1 : i8}> : () -> i8
  %380 = "llvm.mlir.constant"() <{value = 128 : i64}> : () -> i64
  %381 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %382 = "llvm.mlir.constant"() <{value = 1 : i128}> : () -> i128
  %383 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %384 = "llvm.mlir.constant"() <{value = 7 : i64}> : () -> i64
  %385 = "llvm.mlir.constant"() <{value = 9223372036854775680 : i64}> : () -> i64
  %386 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %387 = "llvm.getelementptr"(%arg26) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 127>}> : (!llvm.ptr) -> !llvm.ptr
  %388 = "llvm.load"(%387) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %389 = "llvm.zext"(%388) <{nonNeg}> : (i8) -> i64
  %390 = "llvm.icmp"(%388, %379) <{predicate = 4 : i64}> : (i8, i8) -> i1
  "llvm.intr.assume"(%390) <{op_bundle_sizes = array<i32>}> : (i1) -> ()
  %391 = "llvm.sub"(%380, %389) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %392 = "llvm.icmp"(%arg28, %391) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%392)[^bb2, ^bb1] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb1:  // pred: ^bb0
  %393 = "llvm.icmp"(%388, %381) <{predicate = 0 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%393, %arg28, %arg27)[^bb3, ^bb4] <{operandSegmentSizes = array<i32: 1, 2, 0>}> : (i1, i64, !llvm.ptr) -> ()
^bb2:  // pred: ^bb0
  %394 = "llvm.getelementptr"(%arg26, %389) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.intr.memcpy"(%394, %arg27, %arg28) <{arg_attrs = [{llvm.align = 1 : i64, llvm.nonnull}, {llvm.align = 1 : i64, llvm.nonnull}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %395 = "llvm.trunc"(%arg28) <{overflowFlags = 3 : i32}> : (i64) -> i8
  %396 = "llvm.add"(%388, %395) <{overflowFlags = 2 : i32}> : (i8, i8) -> i8
  "llvm.store"(%396, %387) <{alias_scopes = [#alias_scope57], alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.br"()[^bb7] : () -> ()
^bb3(%397: i64, %398: !llvm.ptr):  // 2 preds: ^bb1, ^bb4
  %399 = "llvm.lshr"(%397, %384) : (i64, i64) -> i64
  %400 = "llvm.and"(%397, %385) : (i64, i64) -> i64
  %401 = "llvm.and"(%397, %378) : (i64, i64) -> i64
  %402 = "llvm.getelementptr"(%398, %400) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %403 = "llvm.icmp"(%399, %386) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%403)[^bb6, ^bb5] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb4:  // pred: ^bb1
  %404 = "llvm.getelementptr"(%arg27, %391) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %405 = "llvm.sub"(%arg28, %391) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %406 = "llvm.getelementptr"(%arg26, %389) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.intr.memcpy"(%406, %arg27, %391) <{arg_attrs = [{llvm.align = 1 : i64, llvm.dereferenceable = 1 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 1 : i64, llvm.dereferenceable = 1 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %407 = "llvm.getelementptr"(%arg29) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %408 = "llvm.load"(%407) <{alignment = 16 : i64, noalias_scopes = [#alias_scope58], ordering = 0 : i64}> : (!llvm.ptr) -> i128
  %409 = "llvm.add"(%408, %382) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  "llvm.store"(%409, %407) <{alignment = 16 : i64, noalias_scopes = [#alias_scope58], ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
  "llvm.call"(%arg29, %arg26, %383) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 64 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.noundef}], callee = @_RNvNtCsgIn12VVV7xy_4sha26sha51211compress512, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.br"(%405, %404)[^bb3] : (i64, !llvm.ptr) -> ()
^bb5:  // pred: ^bb3
  %410 = "llvm.zext"(%399) <{nonNeg}> : (i64) -> i128
  %411 = "llvm.getelementptr"(%arg29) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %412 = "llvm.load"(%411) <{alignment = 16 : i64, noalias_scopes = [#alias_scope59], ordering = 0 : i64}> : (!llvm.ptr) -> i128
  %413 = "llvm.add"(%412, %410) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  "llvm.store"(%413, %411) <{alignment = 16 : i64, noalias_scopes = [#alias_scope59], ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
  "llvm.call"(%arg29, %398, %399) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 64 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.noundef, llvm.range = #llvm.constant_range<i64, 1, 72057594037927936>}], callee = @_RNvNtCsgIn12VVV7xy_4sha26sha51211compress512, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.br"()[^bb6] : () -> ()
^bb6:  // 2 preds: ^bb3, ^bb5
  %414 = "llvm.trunc"(%401) <{overflowFlags = 3 : i32}> : (i64) -> i8
  "llvm.store"(%414, %387) <{alias_scopes = [#alias_scope60], alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.intr.memcpy"(%arg26, %402, %401) <{arg_attrs = [{llvm.align = 1 : i64, llvm.nonnull}, {llvm.align = 1 : i64, llvm.nonnull}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.br"()[^bb7] : () -> ()
^bb7:  // 2 preds: ^bb2, ^bb6
  "llvm.return"() : () -> ()
}) : () -> ()
