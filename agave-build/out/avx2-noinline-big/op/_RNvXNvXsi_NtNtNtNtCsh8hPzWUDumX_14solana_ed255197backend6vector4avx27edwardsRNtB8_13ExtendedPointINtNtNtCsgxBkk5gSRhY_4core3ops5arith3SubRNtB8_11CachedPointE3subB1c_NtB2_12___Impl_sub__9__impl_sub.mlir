#alias_scope_domain88 = #llvm.alias_scope_domain<id = distinct[88]<>, description = "_RNvXNvXsg_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx27edwardsRNtB8_11CachedPointNtNtNtCsgxBkk5gSRhY_4core3ops5arith3Neg3negB1c_NtB2_12___Impl_neg__9__impl_neg">
#alias_scope_domain89 = #llvm.alias_scope_domain<id = distinct[89]<>, description = "_RNvXNvMsb_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx25fieldNtB8_18FieldElement2625x47shuffleB1a_NtB2_16___Impl_shuffle__13__impl_shuffle">
#alias_scope134 = #llvm.alias_scope<id = distinct[263]<>, domain = #alias_scope_domain88, description = "_RNvXNvXsg_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx27edwardsRNtB8_11CachedPointNtNtNtCsgxBkk5gSRhY_4core3ops5arith3Neg3negB1c_NtB2_12___Impl_neg__9__impl_neg: argument 0">
#alias_scope135 = #llvm.alias_scope<id = distinct[264]<>, domain = #alias_scope_domain88, description = "_RNvXNvXsg_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx27edwardsRNtB8_11CachedPointNtNtNtCsgxBkk5gSRhY_4core3ops5arith3Neg3negB1c_NtB2_12___Impl_neg__9__impl_neg: argument 1">
#alias_scope136 = #llvm.alias_scope<id = distinct[265]<>, domain = #alias_scope_domain89, description = "_RNvXNvMsb_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx25fieldNtB8_18FieldElement2625x47shuffleB1a_NtB2_16___Impl_shuffle__13__impl_shuffle: argument 1">
#alias_scope137 = #llvm.alias_scope<id = distinct[266]<>, domain = #alias_scope_domain89, description = "_RNvXNvMsb_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx25fieldNtB8_18FieldElement2625x47shuffleB1a_NtB2_16___Impl_shuffle__13__impl_shuffle: argument 0">
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 32 : i64, llvm.dead_on_unwind, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writable, llvm.writeonly}, {llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], sym_name = "_RNvXNvXsi_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx27edwardsRNtB8_13ExtendedPointINtNtNtCsgxBkk5gSRhY_4core3ops5arith3SubRNtB8_11CachedPointE3subB1c_NtB2_12___Impl_sub__9__impl_sub", target_cpu = "x86-64-v2", target_features = #llvm.target_features<["+avx", "+avx2", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+crc32", "+ssse3", "+avx", "+avx2", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+crc32", "+ssse3"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg36: !llvm.ptr, %arg37: !llvm.ptr, %arg38: !llvm.ptr):
  %537 = "llvm.mlir.constant"() <{value = 134217726 : i32}> : () -> i32
  %538 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %539 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %540 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %541 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %542 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %543 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %544 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %545 = "llvm.mlir.poison"() : () -> vector<8xi32>
  %546 = "llvm.mlir.constant"() <{value = 67108862 : i32}> : () -> i32
  %547 = "llvm.mlir.poison"() : () -> i32
  %548 = "llvm.mlir.constant"() <{value = 134217690 : i32}> : () -> i32
  %549 = "llvm.mlir.undef"() : () -> vector<8xi32>
  %550 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %551 = "llvm.insertelement"(%549, %547, %550) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %552 = "llvm.insertelement"(%551, %547, %544) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %553 = "llvm.insertelement"(%552, %547, %543) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %554 = "llvm.insertelement"(%553, %547, %542) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %555 = "llvm.insertelement"(%554, %547, %541) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %556 = "llvm.insertelement"(%555, %548, %540) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %557 = "llvm.insertelement"(%556, %547, %539) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %558 = "llvm.insertelement"(%557, %546, %538) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %559 = "llvm.insertelement"(%549, %547, %550) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %560 = "llvm.insertelement"(%559, %547, %544) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %561 = "llvm.insertelement"(%560, %547, %543) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %562 = "llvm.insertelement"(%561, %547, %542) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %563 = "llvm.insertelement"(%562, %547, %541) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %564 = "llvm.insertelement"(%563, %537, %540) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %565 = "llvm.insertelement"(%564, %547, %539) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %566 = "llvm.insertelement"(%565, %546, %538) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %567 = "llvm.alloca"(%544) <{alignment = 32 : i64, elem_type = !llvm.array<160 x i8>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%567) : (!llvm.ptr) -> ()
  "llvm.intr.experimental.noalias.scope.decl"() <{scope = #alias_scope134}> : () -> ()
  "llvm.intr.experimental.noalias.scope.decl"() <{scope = #alias_scope135}> : () -> ()
  %568 = "llvm.load"(%arg38) <{alias_scopes = [#alias_scope136, #alias_scope135], alignment = 32 : i64, noalias_scopes = [#alias_scope137, #alias_scope134], ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %569 = "llvm.getelementptr"(%arg38) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %570 = "llvm.load"(%569) <{alias_scopes = [#alias_scope136, #alias_scope135], alignment = 32 : i64, noalias_scopes = [#alias_scope137, #alias_scope134], ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %571 = "llvm.getelementptr"(%arg38) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %572 = "llvm.load"(%571) <{alias_scopes = [#alias_scope136, #alias_scope135], alignment = 32 : i64, noalias_scopes = [#alias_scope137, #alias_scope134], ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %573 = "llvm.getelementptr"(%arg38) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %574 = "llvm.load"(%573) <{alias_scopes = [#alias_scope136, #alias_scope135], alignment = 32 : i64, noalias_scopes = [#alias_scope137, #alias_scope134], ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %575 = "llvm.shufflevector"(%568, %545) <{mask = array<i32: 1, 0, 3, 2, 4, 5, 6, 7>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %576 = "llvm.shufflevector"(%570, %545) <{mask = array<i32: 1, 0, 3, 2, 4, 5, 6, 7>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %577 = "llvm.shufflevector"(%572, %545) <{mask = array<i32: 1, 0, 3, 2, 4, 5, 6, 7>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %578 = "llvm.shufflevector"(%574, %545) <{mask = array<i32: 1, 0, 3, 2, 4, 5, 6, 7>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %579 = "llvm.getelementptr"(%arg38) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %580 = "llvm.load"(%579) <{alias_scopes = [#alias_scope136, #alias_scope135], alignment = 32 : i64, noalias_scopes = [#alias_scope137, #alias_scope134], ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %581 = "llvm.shufflevector"(%580, %545) <{mask = array<i32: 1, 0, 3, 2, 4, 5, 6, 7>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %582 = "llvm.sub"(%558, %575) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %583 = "llvm.sub"(%566, %576) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %584 = "llvm.sub"(%566, %577) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %585 = "llvm.sub"(%566, %578) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %586 = "llvm.sub"(%566, %581) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %587 = "llvm.shufflevector"(%575, %582) <{mask = array<i32: 0, 1, 2, 3, 4, 13, 6, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %588 = "llvm.shufflevector"(%576, %583) <{mask = array<i32: 0, 1, 2, 3, 4, 13, 6, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %589 = "llvm.shufflevector"(%577, %584) <{mask = array<i32: 0, 1, 2, 3, 4, 13, 6, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %590 = "llvm.shufflevector"(%578, %585) <{mask = array<i32: 0, 1, 2, 3, 4, 13, 6, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %591 = "llvm.shufflevector"(%581, %586) <{mask = array<i32: 0, 1, 2, 3, 4, 13, 6, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  "llvm.store"(%587, %567) <{alias_scopes = [#alias_scope134], alignment = 32 : i64, noalias_scopes = [#alias_scope135], ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  %592 = "llvm.getelementptr"(%567) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%588, %592) <{alias_scopes = [#alias_scope134], alignment = 32 : i64, noalias_scopes = [#alias_scope135], ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  %593 = "llvm.getelementptr"(%567) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%589, %593) <{alias_scopes = [#alias_scope134], alignment = 32 : i64, noalias_scopes = [#alias_scope135], ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  %594 = "llvm.getelementptr"(%567) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%590, %594) <{alias_scopes = [#alias_scope134], alignment = 32 : i64, noalias_scopes = [#alias_scope135], ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  %595 = "llvm.getelementptr"(%567) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%591, %595) <{alias_scopes = [#alias_scope134], alignment = 32 : i64, noalias_scopes = [#alias_scope135], ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  "llvm.call"(%arg36, %arg37, %567) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvXNvXsh_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx27edwardsRNtB8_13ExtendedPointINtNtNtCsgxBkk5gSRhY_4core3ops5arith3AddRNtB8_11CachedPointE3addB1c_NtB2_12___Impl_add__9__impl_add, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%567) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
