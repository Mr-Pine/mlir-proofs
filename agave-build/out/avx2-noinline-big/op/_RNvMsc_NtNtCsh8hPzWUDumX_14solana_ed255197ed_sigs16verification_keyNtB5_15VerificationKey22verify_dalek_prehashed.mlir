#alias_scope_domain96 = #llvm.alias_scope_domain<id = distinct[96]<>, description = "_RNvMNtCsh8hPzWUDumX_14solana_ed255196scalarNtB2_6Scalar20from_canonical_bytes">
#alias_scope_domain97 = #llvm.alias_scope_domain<id = distinct[97]<>, description = "_RNvMs2_NtCsh8hPzWUDumX_14solana_ed255195fieldNtNtNtNtNtB7_7backend6serial3u645field14FieldElement516invert">
#alias_scope_domain98 = #llvm.alias_scope_domain<id = distinct[98]<>, description = "_RNvMsg_NtCsh8hPzWUDumX_14solana_ed255197edwardsNtB5_12EdwardsPoint9to_affine">
#alias_scope_domain99 = #llvm.alias_scope_domain<id = distinct[99]<>, description = "_RNvMsg_NtCsh8hPzWUDumX_14solana_ed255197edwardsNtB5_12EdwardsPoint8compress">
#alias_scope146 = #llvm.alias_scope<id = distinct[275]<>, domain = #alias_scope_domain96, description = "_RNvMNtCsh8hPzWUDumX_14solana_ed255196scalarNtB2_6Scalar20from_canonical_bytes: argument 0">
#alias_scope147 = #llvm.alias_scope<id = distinct[276]<>, domain = #alias_scope_domain96, description = "_RNvMNtCsh8hPzWUDumX_14solana_ed255196scalarNtB2_6Scalar20from_canonical_bytes: argument 1">
#alias_scope148 = #llvm.alias_scope<id = distinct[277]<>, domain = #alias_scope_domain97, description = "_RNvMs2_NtCsh8hPzWUDumX_14solana_ed255195fieldNtNtNtNtNtB7_7backend6serial3u645field14FieldElement516invert: argument 0">
#alias_scope149 = #llvm.alias_scope<id = distinct[278]<>, domain = #alias_scope_domain98, description = "_RNvMsg_NtCsh8hPzWUDumX_14solana_ed255197edwardsNtB5_12EdwardsPoint9to_affine: argument 0">
#alias_scope150 = #llvm.alias_scope<id = distinct[279]<>, domain = #alias_scope_domain99, description = "_RNvMsg_NtCsh8hPzWUDumX_14solana_ed255197edwardsNtB5_12EdwardsPoint8compress: argument 0">
#alias_scope151 = #llvm.alias_scope<id = distinct[280]<>, domain = #alias_scope_domain97, description = "_RNvMs2_NtCsh8hPzWUDumX_14solana_ed255195fieldNtNtNtNtNtB7_7backend6serial3u645field14FieldElement516invert: argument 1">
#alias_scope152 = #llvm.alias_scope<id = distinct[281]<>, domain = #alias_scope_domain99, description = "_RNvMsg_NtCsh8hPzWUDumX_14solana_ed255197edwardsNtB5_12EdwardsPoint8compress: argument 1">
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 192 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.dereferenceable = 64 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.align = 1 : i64, llvm.dead_on_return = -1 : i64, llvm.dereferenceable = 32 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<i8 (ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, no_inline, passthrough = ["nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], res_attrs = [{llvm.noundef, llvm.range = #llvm.constant_range<i8, -1, 3>}], sym_name = "_RNvMsc_NtNtCsh8hPzWUDumX_14solana_ed255197ed_sigs16verification_keyNtB5_15VerificationKey22verify_dalek_prehashed", target_cpu = "x86-64-v2", target_features = #llvm.target_features<["+avx", "+avx2", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+crc32", "+ssse3"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg11: !llvm.ptr, %arg12: !llvm.ptr, %arg13: !llvm.ptr):
  %377 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %378 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %379 = "llvm.mlir.constant"() <{value = 2 : i8}> : () -> i8
  %380 = "llvm.mlir.constant"() <{value = 160 : i64}> : () -> i64
  %381 = "llvm.mlir.constant"() <{value = -1 : i8}> : () -> i8
  %382 = "llvm.mlir.constant"() <{value = 1 : i8}> : () -> i8
  %383 = "llvm.mlir.constant"() <{value = 31 : i64}> : () -> i64
  %384 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
  %385 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %386 = "llvm.mlir.constant"() <{value = 7 : i8}> : () -> i8
  %387 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %388 = "llvm.alloca"(%377) <{alignment = 8 : i64, elem_type = !llvm.array<40 x i8>}> : (i32) -> !llvm.ptr
  %389 = "llvm.alloca"(%377) <{alignment = 8 : i64, elem_type = !llvm.array<80 x i8>}> : (i32) -> !llvm.ptr
  %390 = "llvm.alloca"(%377) <{alignment = 8 : i64, elem_type = !llvm.array<40 x i8>}> : (i32) -> !llvm.ptr
  %391 = "llvm.alloca"(%377) <{alignment = 8 : i64, elem_type = !llvm.array<40 x i8>}> : (i32) -> !llvm.ptr
  %392 = "llvm.alloca"(%377) <{alignment = 8 : i64, elem_type = !llvm.array<40 x i8>}> : (i32) -> !llvm.ptr
  %393 = "llvm.alloca"(%377) <{alignment = 1 : i64, elem_type = !llvm.array<32 x i8>}> : (i32) -> !llvm.ptr
  %394 = "llvm.alloca"(%377) <{alignment = 8 : i64, elem_type = !llvm.array<80 x i8>}> : (i32) -> !llvm.ptr
  %395 = "llvm.alloca"(%377) <{alignment = 1 : i64, elem_type = !llvm.array<32 x i8>}> : (i32) -> !llvm.ptr
  %396 = "llvm.alloca"(%377) <{alignment = 8 : i64, elem_type = !llvm.array<160 x i8>}> : (i32) -> !llvm.ptr
  %397 = "llvm.alloca"(%377) <{alignment = 1 : i64, elem_type = !llvm.array<32 x i8>}> : (i32) -> !llvm.ptr
  %398 = "llvm.alloca"(%377) <{alignment = 8 : i64, elem_type = !llvm.array<168 x i8>}> : (i32) -> !llvm.ptr
  %399 = "llvm.alloca"(%377) <{alignment = 2 : i64, elem_type = !llvm.array<166 x i8>}> : (i32) -> !llvm.ptr
  %400 = "llvm.alloca"(%377) <{alignment = 2 : i64, elem_type = !llvm.array<166 x i8>}> : (i32) -> !llvm.ptr
  %401 = "llvm.alloca"(%377) <{alignment = 8 : i64, elem_type = !llvm.array<160 x i8>}> : (i32) -> !llvm.ptr
  %402 = "llvm.getelementptr"(%arg11) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %403 = "llvm.call"(%402) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvMsx_NtCsh8hPzWUDumX_14solana_ed255197edwardsNtB5_12EdwardsPoint14is_small_order, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef, llvm.zeroext}]}> : (!llvm.ptr) -> i1
  "llvm.cond_br"(%403, %379)[^bb8, ^bb1] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i8) -> ()
^bb1:  // pred: ^bb0
  "llvm.intr.lifetime.start"(%401) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%400) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%399) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%398) : (!llvm.ptr) -> ()
  "llvm.call"(%398, %arg12) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 168 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.dereferenceable = 32 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvMs2_NtCsh8hPzWUDumX_14solana_ed255197edwardsNtB5_18CompressedEdwardsY10decompress, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %404 = "llvm.load"(%398) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %405 = "llvm.trunc"(%404) <{overflowFlags = 2 : i32}> : (i64) -> i1
  "llvm.cond_br"(%405)[^bb2, ^bb3] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb2:  // pred: ^bb1
  %406 = "llvm.getelementptr"(%398) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %407 = "llvm.getelementptr"(%399) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memcpy"(%407, %406, %380) <{arg_attrs = [{llvm.align = 2 : i64, llvm.dereferenceable = 160 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 160 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.intr.lifetime.end"(%398) : (!llvm.ptr) -> ()
  %408 = "llvm.getelementptr"(%400) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memcpy"(%408, %407, %380) <{arg_attrs = [{llvm.align = 2 : i64, llvm.dereferenceable = 160 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 2 : i64, llvm.dereferenceable = 160 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.intr.lifetime.end"(%399) : (!llvm.ptr) -> ()
  "llvm.intr.memcpy"(%401, %408, %380) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 160 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 2 : i64, llvm.dereferenceable = 160 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.intr.lifetime.end"(%400) : (!llvm.ptr) -> ()
  %409 = "llvm.call"(%401) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvMsx_NtCsh8hPzWUDumX_14solana_ed255197edwardsNtB5_12EdwardsPoint14is_small_order, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef, llvm.zeroext}]}> : (!llvm.ptr) -> i1
  "llvm.cond_br"(%409, %379)[^bb7, ^bb4] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i8) -> ()
^bb3:  // pred: ^bb1
  "llvm.intr.lifetime.end"(%398) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%399) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%400) : (!llvm.ptr) -> ()
  "llvm.br"(%379)[^bb7] : (i8) -> ()
^bb4:  // pred: ^bb2
  "llvm.intr.lifetime.start"(%397) : (!llvm.ptr) -> ()
  %410 = "llvm.getelementptr"(%arg12) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.experimental.noalias.scope.decl"() <{scope = #alias_scope146}> : () -> ()
  "llvm.intr.experimental.noalias.scope.decl"() <{scope = #alias_scope147}> : () -> ()
  %411 = "llvm.getelementptr"(%arg12) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 63>}> : (!llvm.ptr) -> !llvm.ptr
  %412 = "llvm.load"(%411) <{alias_scopes = [#alias_scope147], alignment = 1 : i64, noalias_scopes = [#alias_scope146], ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %413 = "llvm.icmp"(%412, %381) <{predicate = 4 : i64}> : (i8, i8) -> i1
  %414 = "llvm.zext"(%413) : (i1) -> i8
  %415 = "llvm.call"(%414) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  "llvm.intr.lifetime.start"(%395) : (!llvm.ptr) -> ()
  "llvm.call"(%395, %410) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 1 : i64, llvm.dereferenceable = 32 : i64, llvm.noalias, llvm.nofree, llvm.noundef}, {llvm.align = 1 : i64, llvm.dereferenceable = 32 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvMso_NtCsh8hPzWUDumX_14solana_ed255196scalarNtB5_6Scalar6reduce, fastmathFlags = #llvm.fastmath<none>, noalias_scopes = [#alias_scope146], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %416 = "llvm.call"(%410, %395) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 1 : i64, llvm.dereferenceable = 32 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.dereferenceable = 32 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvXs8_Cs3X6wZJE6GDg_6subtleShNtB5_14ConstantTimeEq5ct_eqCsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, inline_hint, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope146], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>, res_attrs = [{llvm.noundef}]}> : (!llvm.ptr, !llvm.ptr) -> i8
  "llvm.intr.lifetime.end"(%395) : (!llvm.ptr) -> ()
  %417 = "llvm.and"(%416, %415) : (i8, i8) -> i8
  %418 = "llvm.call"(%417) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %419 = "llvm.icmp"(%418, %382) <{predicate = 0 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%419)[^bb5, ^bb6] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb5:  // pred: ^bb4
  %420 = "llvm.getelementptr"(%arg12) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 33>}> : (!llvm.ptr) -> !llvm.ptr
  %421 = "llvm.load"(%410) <{alias_scopes = [#alias_scope146, #alias_scope147], alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %422 = "llvm.getelementptr"(%397) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memcpy"(%422, %420, %383) <{arg_attrs = [{llvm.align = 1 : i64, llvm.dereferenceable = 31 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 1 : i64, llvm.dereferenceable = 31 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.store"(%421, %397) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%396) : (!llvm.ptr) -> ()
  "llvm.call"(%396, %arg13, %402, %397) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.dereferenceable = 32 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.dereferenceable = 32 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvNvNtNtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector10scalar_mul19vartime_double_base9spec_avx23mul9__impl_mul, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%394) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%392) : (!llvm.ptr) -> ()
  %423 = "llvm.getelementptr"(%396) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 80>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%389) : (!llvm.ptr) -> ()
  "llvm.call"(%389, %423) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 80 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvMs2_NtCsh8hPzWUDumX_14solana_ed255195fieldNtNtNtNtNtB7_7backend6serial3u645field14FieldElement518pow22501, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope148, #alias_scope149, #alias_scope150], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%391) : (!llvm.ptr) -> ()
  "llvm.intr.memcpy"(%391, %389, %384) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false, noalias_scopes = [#alias_scope148, #alias_scope151, #alias_scope149, #alias_scope150, #alias_scope152]}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.intr.lifetime.start"(%390) : (!llvm.ptr) -> ()
  %424 = "llvm.getelementptr"(%389) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memcpy"(%390, %424, %384) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false, noalias_scopes = [#alias_scope148, #alias_scope151, #alias_scope149, #alias_scope150, #alias_scope152]}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.intr.lifetime.end"(%389) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%388) : (!llvm.ptr) -> ()
  "llvm.call"(%388, %391, %385) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.noundef}], callee = @_RNvMs8_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u645fieldNtB5_14FieldElement515pow2k, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope148, #alias_scope151, #alias_scope149, #alias_scope150, #alias_scope152], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> ()
  "llvm.call"(%392, %388, %390) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvXs5_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u645fieldRNtB5_14FieldElement51NtNtNtCsgxBkk5gSRhY_4core3ops5arith3Mul3mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope151, #alias_scope149, #alias_scope150, #alias_scope152], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%388) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%390) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%391) : (!llvm.ptr) -> ()
  "llvm.call"(%394, %396, %392) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 80 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvXs5_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u645fieldRNtB5_14FieldElement51NtNtNtCsgxBkk5gSRhY_4core3ops5arith3Mul3mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope150], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  %425 = "llvm.getelementptr"(%396) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  %426 = "llvm.getelementptr"(%394) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%426, %425, %392) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvXs5_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u645fieldRNtB5_14FieldElement51NtNtNtCsgxBkk5gSRhY_4core3ops5arith3Mul3mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope150], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%392) : (!llvm.ptr) -> ()
  "llvm.call"(%393, %426) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 1 : i64, llvm.dereferenceable = 32 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvMs8_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u645fieldNtB5_14FieldElement518to_bytes, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %427 = "llvm.call"(%394) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvMs2_NtCsh8hPzWUDumX_14solana_ed255195fieldNtNtNtNtNtB7_7backend6serial3u645field14FieldElement5111is_negative, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope150, #alias_scope152], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (!llvm.ptr) -> i8
  %428 = "llvm.shl"(%427, %386) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  %429 = "llvm.getelementptr"(%393) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 31>}> : (!llvm.ptr) -> !llvm.ptr
  %430 = "llvm.load"(%429) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %431 = "llvm.xor"(%430, %428) : (i8, i8) -> i8
  "llvm.store"(%431, %429) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%394) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%396) : (!llvm.ptr) -> ()
  %432 = "llvm.call"(%393, %arg12, %378) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.dereferenceable = 32 : i64, llvm.nonnull, llvm.noundef}, {llvm.dereferenceable = 32 : i64, llvm.nonnull, llvm.noundef}, {}], callee = @bcmp, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> i32
  %433 = "llvm.icmp"(%432, %387) <{predicate = 0 : i64}> : (i32, i32) -> i1
  %434 = "llvm.select"(%433, %381, %379) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i8, i8) -> i8
  "llvm.intr.lifetime.end"(%397) : (!llvm.ptr) -> ()
  "llvm.br"(%434)[^bb7] : (i8) -> ()
^bb6:  // pred: ^bb4
  "llvm.intr.lifetime.end"(%397) : (!llvm.ptr) -> ()
  "llvm.br"(%379)[^bb7] : (i8) -> ()
^bb7(%435: i8):  // 4 preds: ^bb2, ^bb3, ^bb5, ^bb6
  "llvm.intr.lifetime.end"(%401) : (!llvm.ptr) -> ()
  "llvm.br"(%435)[^bb8] : (i8) -> ()
^bb8(%436: i8):  // 2 preds: ^bb0, ^bb7
  "llvm.return"(%436) : (i8) -> ()
}) : () -> ()
