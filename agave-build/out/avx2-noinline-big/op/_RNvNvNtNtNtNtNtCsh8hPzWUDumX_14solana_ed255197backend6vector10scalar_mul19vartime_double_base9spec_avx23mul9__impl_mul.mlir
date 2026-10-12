#alias_scope_domain107 = #llvm.alias_scope_domain<id = distinct[107]<>, description = "_RNvXs19_NtNtCsgxBkk5gSRhY_4core3cmp5implsaNtB8_3Ord3cmp">
#alias_scope_domain108 = #llvm.alias_scope_domain<id = distinct[108]<>, description = "_RNvXs19_NtNtCsgxBkk5gSRhY_4core3cmp5implsaNtB8_3Ord3cmp">
#alias_scope_domain109 = #llvm.alias_scope_domain<id = distinct[109]<>, description = "_RNvXNvXs3_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx27edwardsNtNtBg_7edwards12EdwardsPointINtNtCsgxBkk5gSRhY_4core7convert4FromNtB8_13ExtendedPointE4fromB1c_NtB2_13___Impl_from__10__impl_from">
#alias_scope_domain110 = #llvm.alias_scope_domain<id = distinct[110]<>, description = "_RNvXNvMsb_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx25fieldNtB8_18FieldElement2625x45splitB1a_NtB2_14___Impl_split__11__impl_split">
#alias_scope165 = #llvm.alias_scope<id = distinct[294]<>, domain = #alias_scope_domain107, description = "_RNvXs19_NtNtCsgxBkk5gSRhY_4core3cmp5implsaNtB8_3Ord3cmp: argument 0">
#alias_scope166 = #llvm.alias_scope<id = distinct[295]<>, domain = #alias_scope_domain108, description = "_RNvXs19_NtNtCsgxBkk5gSRhY_4core3cmp5implsaNtB8_3Ord3cmp: argument 0">
#alias_scope167 = #llvm.alias_scope<id = distinct[296]<>, domain = #alias_scope_domain109, description = "_RNvXNvXs3_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx27edwardsNtNtBg_7edwards12EdwardsPointINtNtCsgxBkk5gSRhY_4core7convert4FromNtB8_13ExtendedPointE4fromB1c_NtB2_13___Impl_from__10__impl_from: argument 1">
#alias_scope168 = #llvm.alias_scope<id = distinct[297]<>, domain = #alias_scope_domain110, description = "_RNvXNvMsb_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx25fieldNtB8_18FieldElement2625x45splitB1a_NtB2_14___Impl_split__11__impl_split: argument 1">
#alias_scope169 = #llvm.alias_scope<id = distinct[298]<>, domain = #alias_scope_domain110, description = "_RNvXNvMsb_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx25fieldNtB8_18FieldElement2625x45splitB1a_NtB2_14___Impl_split__11__impl_split: argument 0">
#alias_scope170 = #llvm.alias_scope<id = distinct[299]<>, domain = #alias_scope_domain109, description = "_RNvXNvXs3_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx27edwardsNtNtBg_7edwards12EdwardsPointINtNtCsgxBkk5gSRhY_4core7convert4FromNtB8_13ExtendedPointE4fromB1c_NtB2_13___Impl_from__10__impl_from: argument 0">
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 8 : i64, llvm.dead_on_unwind, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writable, llvm.writeonly}, {llvm.dereferenceable = 32 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.dereferenceable = 32 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, no_inline, passthrough = ["nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], sym_name = "_RNvNvNtNtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector10scalar_mul19vartime_double_base9spec_avx23mul9__impl_mul", target_cpu = "x86-64-v2", target_features = #llvm.target_features<["+avx", "+avx2", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+crc32", "+ssse3", "+avx", "+avx2", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+crc32", "+ssse3"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg6: !llvm.ptr, %arg7: !llvm.ptr, %arg8: !llvm.ptr, %arg9: !llvm.ptr):
  %133 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %134 = "llvm.mlir.constant"() <{value = 5 : i64}> : () -> i64
  %135 = "llvm.mlir.constant"() <{value = 8 : i64}> : () -> i64
  %136 = "llvm.mlir.constant"() <{value = 256 : i64}> : () -> i64
  %137 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %138 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %139 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %140 = "llvm.mlir.addressof"() <{global_name = @_RNvNtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx29constants22EXTENDEDPOINT_IDENTITY}> : () -> !llvm.ptr
  %141 = "llvm.mlir.constant"() <{value = 160 : i64}> : () -> i64
  %142 = "llvm.mlir.constant"() <{value = 26 : i64}> : () -> i64
  %143 = "llvm.mlir.poison"() : () -> vector<8xi32>
  %144 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %145 = "llvm.mlir.constant"() <{value = dense<26> : vector<2xi64>}> : () -> vector<2xi64>
  %146 = "llvm.alloca"(%133) <{alignment = 32 : i64, elem_type = !llvm.array<160 x i8>}> : (i32) -> !llvm.ptr
  %147 = "llvm.alloca"(%133) <{alignment = 32 : i64, elem_type = !llvm.array<160 x i8>}> : (i32) -> !llvm.ptr
  %148 = "llvm.alloca"(%133) <{alignment = 32 : i64, elem_type = !llvm.array<160 x i8>}> : (i32) -> !llvm.ptr
  %149 = "llvm.alloca"(%133) <{alignment = 32 : i64, elem_type = !llvm.array<160 x i8>}> : (i32) -> !llvm.ptr
  %150 = "llvm.alloca"(%133) <{alignment = 32 : i64, elem_type = !llvm.array<160 x i8>}> : (i32) -> !llvm.ptr
  %151 = "llvm.alloca"(%133) <{alignment = 32 : i64, elem_type = !llvm.array<160 x i8>}> : (i32) -> !llvm.ptr
  %152 = "llvm.alloca"(%133) <{alignment = 32 : i64, elem_type = !llvm.array<160 x i8>}> : (i32) -> !llvm.ptr
  %153 = "llvm.alloca"(%133) <{alignment = 32 : i64, elem_type = !llvm.array<160 x i8>}> : (i32) -> !llvm.ptr
  %154 = "llvm.alloca"(%133) <{alignment = 32 : i64, elem_type = !llvm.array<160 x i8>}> : (i32) -> !llvm.ptr
  %155 = "llvm.alloca"(%133) <{alignment = 32 : i64, elem_type = !llvm.array<160 x i8>}> : (i32) -> !llvm.ptr
  %156 = "llvm.alloca"(%133) <{alignment = 32 : i64, elem_type = !llvm.array<1280 x i8>}> : (i32) -> !llvm.ptr
  %157 = "llvm.alloca"(%133) <{alignment = 1 : i64, elem_type = !llvm.array<256 x i8>}> : (i32) -> !llvm.ptr
  %158 = "llvm.alloca"(%133) <{alignment = 1 : i64, elem_type = !llvm.array<256 x i8>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%158) : (!llvm.ptr) -> ()
  "llvm.call"(%158, %arg7, %134) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 1 : i64, llvm.dereferenceable = 256 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.dereferenceable = 32 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.noundef}], callee = @_RNvMso_NtCsh8hPzWUDumX_14solana_ed255196scalarNtB5_6Scalar17non_adjacent_form, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.intr.lifetime.start"(%157) : (!llvm.ptr) -> ()
  "llvm.call"(%157, %arg9, %135) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 1 : i64, llvm.dereferenceable = 256 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.dereferenceable = 32 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.noundef}], callee = @_RNvMso_NtCsh8hPzWUDumX_14solana_ed255196scalarNtB5_6Scalar17non_adjacent_form, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.br"(%136)[^bb2] : (i64) -> ()
^bb1(%159: i64):  // 2 preds: ^bb2, ^bb3
  "llvm.intr.lifetime.start"(%156) : (!llvm.ptr) -> ()
  "llvm.call"(%156, %arg8) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 32 : i64, llvm.dereferenceable = 1280 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvXNvXsk_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx27edwardsINtNtBg_6window15NafLookupTable5NtB8_11CachedPointEINtNtCsgxBkk5gSRhY_4core7convert4FromRNtNtBg_7edwards12EdwardsPointE4fromB1c_NtB2_13___Impl_from__10__impl_from, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.memcpy"(%155, %140, %141) <{arg_attrs = [{llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.br"(%159)[^bb4] : (i64) -> ()
^bb2(%160: i64):  // 2 preds: ^bb0, ^bb3
  %161 = "llvm.add"(%160, %137) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %162 = "llvm.getelementptr"(%158, %161) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %163 = "llvm.load"(%162) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %164 = "llvm.icmp"(%163, %138) <{predicate = 0 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%164, %161)[^bb3, ^bb1] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb3:  // pred: ^bb2
  %165 = "llvm.getelementptr"(%157, %161) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %166 = "llvm.load"(%165) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %167 = "llvm.icmp"(%166, %138) <{predicate = 1 : i64}> : (i8, i8) -> i1
  %168 = "llvm.icmp"(%161, %139) <{predicate = 0 : i64}> : (i64, i64) -> i1
  %169 = "llvm.or"(%167, %168) : (i1, i1) -> i1
  "llvm.cond_br"(%169, %161, %161)[^bb1, ^bb2] <{operandSegmentSizes = array<i32: 1, 1, 1>}> : (i1, i64, i64) -> ()
^bb4(%170: i64):  // 2 preds: ^bb1, ^bb10
  "llvm.intr.lifetime.start"(%154) : (!llvm.ptr) -> ()
  "llvm.call"(%154, %155) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvXNvMs7_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx27edwardsNtB8_13ExtendedPoint6doubleB1c_NtB2_15___Impl_double__12__impl_double, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.memcpy"(%155, %154, %141) <{arg_attrs = [{llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.intr.lifetime.end"(%154) : (!llvm.ptr) -> ()
  %171 = "llvm.getelementptr"(%158, %170) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %172 = "llvm.load"(%171) <{alias_scopes = [#alias_scope165], alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %173 = "llvm.intr.scmp"(%172, %138) : (i8, i8) -> i8
  "llvm.switch"(%173)[^bb5, ^bb6, ^bb8, ^bb7] <{case_operand_segments = array<i32: 0, 0, 0>, case_values = dense<[-1, 0, 1]> : vector<3xi8>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i8) -> ()
^bb5:  // 2 preds: ^bb4, ^bb8
  "llvm.unreachable"() : () -> ()
^bb6:  // pred: ^bb4
  "llvm.intr.lifetime.start"(%151) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%150) : (!llvm.ptr) -> ()
  %174 = "llvm.sub"(%138, %172) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  %175 = "llvm.sext"(%174) : (i8) -> i64
  "llvm.call"(%150, %156, %175) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.noundef}, {llvm.align = 32 : i64, llvm.dereferenceable = 1280 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.noundef}], callee = @_RNvMNtCsh8hPzWUDumX_14solana_ed255196windowINtB2_15NafLookupTable5NtNtNtNtNtB4_7backend6vector4avx27edwards11CachedPointE6selectB4_, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.call"(%151, %155, %150) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvXNvXsi_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx27edwardsRNtB8_13ExtendedPointINtNtNtCsgxBkk5gSRhY_4core3ops5arith3SubRNtB8_11CachedPointE3subB1c_NtB2_12___Impl_sub__9__impl_sub, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.memcpy"(%155, %151, %141) <{arg_attrs = [{llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.intr.lifetime.end"(%151) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%150) : (!llvm.ptr) -> ()
  "llvm.br"()[^bb8] : () -> ()
^bb7:  // pred: ^bb4
  "llvm.intr.lifetime.start"(%153) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%152) : (!llvm.ptr) -> ()
  %176 = "llvm.sext"(%172) : (i8) -> i64
  "llvm.call"(%152, %156, %176) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.noundef}, {llvm.align = 32 : i64, llvm.dereferenceable = 1280 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.noundef}], callee = @_RNvMNtCsh8hPzWUDumX_14solana_ed255196windowINtB2_15NafLookupTable5NtNtNtNtNtB4_7backend6vector4avx27edwards11CachedPointE6selectB4_, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.call"(%153, %155, %152) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvXNvXsh_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx27edwardsRNtB8_13ExtendedPointINtNtNtCsgxBkk5gSRhY_4core3ops5arith3AddRNtB8_11CachedPointE3addB1c_NtB2_12___Impl_add__9__impl_add, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.memcpy"(%155, %153, %141) <{arg_attrs = [{llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.intr.lifetime.end"(%153) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%152) : (!llvm.ptr) -> ()
  "llvm.br"()[^bb8] : () -> ()
^bb8:  // 3 preds: ^bb4, ^bb6, ^bb7
  %177 = "llvm.getelementptr"(%157, %170) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %178 = "llvm.load"(%177) <{alias_scopes = [#alias_scope166], alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %179 = "llvm.intr.scmp"(%178, %138) : (i8, i8) -> i8
  "llvm.switch"(%179)[^bb5, ^bb9, ^bb10, ^bb11] <{case_operand_segments = array<i32: 0, 0, 0>, case_values = dense<[-1, 0, 1]> : vector<3xi8>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i8) -> ()
^bb9:  // pred: ^bb8
  "llvm.intr.lifetime.start"(%147) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%146) : (!llvm.ptr) -> ()
  %180 = "llvm.sub"(%138, %178) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  %181 = "llvm.sext"(%180) : (i8) -> i64
  "llvm.call"(%146, %181) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.noundef}, {llvm.noundef}], callee = @_RNvMs2_NtCsh8hPzWUDumX_14solana_ed255196windowINtB5_15NafLookupTable8NtNtNtNtNtB7_7backend6vector4avx27edwards11CachedPointE6selectB7_, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, i64) -> ()
  "llvm.call"(%147, %155, %146) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvXNvXsi_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx27edwardsRNtB8_13ExtendedPointINtNtNtCsgxBkk5gSRhY_4core3ops5arith3SubRNtB8_11CachedPointE3subB1c_NtB2_12___Impl_sub__9__impl_sub, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.memcpy"(%155, %147, %141) <{arg_attrs = [{llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.intr.lifetime.end"(%147) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%146) : (!llvm.ptr) -> ()
  "llvm.br"()[^bb10] : () -> ()
^bb10:  // 3 preds: ^bb8, ^bb9, ^bb11
  %182 = "llvm.icmp"(%170, %139) <{predicate = 0 : i64}> : (i64, i64) -> i1
  %183 = "llvm.add"(%170, %137) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  "llvm.cond_br"(%182, %183)[^bb12, ^bb4] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb11:  // pred: ^bb8
  "llvm.intr.lifetime.start"(%149) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%148) : (!llvm.ptr) -> ()
  %184 = "llvm.sext"(%178) : (i8) -> i64
  "llvm.call"(%148, %184) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.noundef}, {llvm.noundef}], callee = @_RNvMs2_NtCsh8hPzWUDumX_14solana_ed255196windowINtB5_15NafLookupTable8NtNtNtNtNtB7_7backend6vector4avx27edwards11CachedPointE6selectB7_, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, i64) -> ()
  "llvm.call"(%149, %155, %148) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvXNvXsh_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx27edwardsRNtB8_13ExtendedPointINtNtNtCsgxBkk5gSRhY_4core3ops5arith3AddRNtB8_11CachedPointE3addB1c_NtB2_12___Impl_add__9__impl_add, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.memcpy"(%155, %149, %141) <{arg_attrs = [{llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.intr.lifetime.end"(%149) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%148) : (!llvm.ptr) -> ()
  "llvm.br"()[^bb10] : () -> ()
^bb12:  // pred: ^bb10
  "llvm.intr.experimental.noalias.scope.decl"() <{scope = #alias_scope167}> : () -> ()
  %185 = "llvm.load"(%155) <{alias_scopes = [#alias_scope168, #alias_scope167], alignment = 32 : i64, noalias_scopes = [#alias_scope169, #alias_scope170], ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %186 = "llvm.getelementptr"(%155) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %187 = "llvm.load"(%186) <{alias_scopes = [#alias_scope168, #alias_scope167], alignment = 32 : i64, noalias_scopes = [#alias_scope169, #alias_scope170], ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %188 = "llvm.getelementptr"(%155) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 36>}> : (!llvm.ptr) -> !llvm.ptr
  %189 = "llvm.load"(%188) <{alias_scopes = [#alias_scope168, #alias_scope167], alignment = 4 : i64, noalias_scopes = [#alias_scope169, #alias_scope170], ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %190 = "llvm.zext"(%189) : (i32) -> i64
  %191 = "llvm.getelementptr"(%155) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  %192 = "llvm.load"(%191) <{alias_scopes = [#alias_scope168, #alias_scope167], alignment = 8 : i64, noalias_scopes = [#alias_scope169, #alias_scope170], ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %193 = "llvm.getelementptr"(%155) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 44>}> : (!llvm.ptr) -> !llvm.ptr
  %194 = "llvm.load"(%193) <{alias_scopes = [#alias_scope168, #alias_scope167], alignment = 4 : i64, noalias_scopes = [#alias_scope169, #alias_scope170], ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %195 = "llvm.zext"(%194) : (i32) -> i64
  %196 = "llvm.getelementptr"(%155) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 48>}> : (!llvm.ptr) -> !llvm.ptr
  %197 = "llvm.load"(%196) <{alias_scopes = [#alias_scope168, #alias_scope167], alignment = 16 : i64, noalias_scopes = [#alias_scope169, #alias_scope170], ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %198 = "llvm.zext"(%197) : (i32) -> i64
  %199 = "llvm.getelementptr"(%155) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 52>}> : (!llvm.ptr) -> !llvm.ptr
  %200 = "llvm.load"(%199) <{alias_scopes = [#alias_scope168, #alias_scope167], alignment = 4 : i64, noalias_scopes = [#alias_scope169, #alias_scope170], ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %201 = "llvm.zext"(%200) : (i32) -> i64
  %202 = "llvm.getelementptr"(%155) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 56>}> : (!llvm.ptr) -> !llvm.ptr
  %203 = "llvm.load"(%202) <{alias_scopes = [#alias_scope168, #alias_scope167], alignment = 8 : i64, noalias_scopes = [#alias_scope169, #alias_scope170], ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %204 = "llvm.zext"(%203) : (i32) -> i64
  %205 = "llvm.getelementptr"(%155) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 60>}> : (!llvm.ptr) -> !llvm.ptr
  %206 = "llvm.load"(%205) <{alias_scopes = [#alias_scope168, #alias_scope167], alignment = 4 : i64, noalias_scopes = [#alias_scope169, #alias_scope170], ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %207 = "llvm.zext"(%206) : (i32) -> i64
  %208 = "llvm.shl"(%195, %142) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %209 = "llvm.add"(%208, %190) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %210 = "llvm.shl"(%204, %142) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %211 = "llvm.add"(%210, %198) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %212 = "llvm.shl"(%207, %142) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %213 = "llvm.add"(%212, %201) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %214 = "llvm.getelementptr"(%155) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %215 = "llvm.load"(%214) <{alias_scopes = [#alias_scope168, #alias_scope167], alignment = 32 : i64, noalias_scopes = [#alias_scope169, #alias_scope170], ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %216 = "llvm.zext"(%215) : (i32) -> i64
  %217 = "llvm.getelementptr"(%155) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 68>}> : (!llvm.ptr) -> !llvm.ptr
  %218 = "llvm.load"(%217) <{alias_scopes = [#alias_scope168, #alias_scope167], alignment = 4 : i64, noalias_scopes = [#alias_scope169, #alias_scope170], ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %219 = "llvm.zext"(%218) : (i32) -> i64
  %220 = "llvm.getelementptr"(%155) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 72>}> : (!llvm.ptr) -> !llvm.ptr
  %221 = "llvm.load"(%220) <{alias_scopes = [#alias_scope168, #alias_scope167], alignment = 8 : i64, noalias_scopes = [#alias_scope169, #alias_scope170], ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %222 = "llvm.zext"(%221) : (i32) -> i64
  %223 = "llvm.getelementptr"(%155) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 76>}> : (!llvm.ptr) -> !llvm.ptr
  %224 = "llvm.load"(%223) <{alias_scopes = [#alias_scope168, #alias_scope167], alignment = 4 : i64, noalias_scopes = [#alias_scope169, #alias_scope170], ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %225 = "llvm.zext"(%224) : (i32) -> i64
  %226 = "llvm.getelementptr"(%155) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 80>}> : (!llvm.ptr) -> !llvm.ptr
  %227 = "llvm.load"(%226) <{alias_scopes = [#alias_scope168, #alias_scope167], alignment = 16 : i64, noalias_scopes = [#alias_scope169, #alias_scope170], ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %228 = "llvm.zext"(%227) : (i32) -> i64
  %229 = "llvm.getelementptr"(%155) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 84>}> : (!llvm.ptr) -> !llvm.ptr
  %230 = "llvm.load"(%229) <{alias_scopes = [#alias_scope168, #alias_scope167], alignment = 4 : i64, noalias_scopes = [#alias_scope169, #alias_scope170], ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %231 = "llvm.zext"(%230) : (i32) -> i64
  %232 = "llvm.getelementptr"(%155) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 88>}> : (!llvm.ptr) -> !llvm.ptr
  %233 = "llvm.load"(%232) <{alias_scopes = [#alias_scope168, #alias_scope167], alignment = 8 : i64, noalias_scopes = [#alias_scope169, #alias_scope170], ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %234 = "llvm.zext"(%233) : (i32) -> i64
  %235 = "llvm.getelementptr"(%155) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 92>}> : (!llvm.ptr) -> !llvm.ptr
  %236 = "llvm.load"(%235) <{alias_scopes = [#alias_scope168, #alias_scope167], alignment = 4 : i64, noalias_scopes = [#alias_scope169, #alias_scope170], ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %237 = "llvm.zext"(%236) : (i32) -> i64
  %238 = "llvm.shl"(%222, %142) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %239 = "llvm.add"(%238, %216) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %240 = "llvm.shl"(%225, %142) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %241 = "llvm.add"(%240, %219) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %242 = "llvm.shl"(%234, %142) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %243 = "llvm.add"(%242, %228) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %244 = "llvm.shl"(%237, %142) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %245 = "llvm.add"(%244, %231) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %246 = "llvm.getelementptr"(%155) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %247 = "llvm.load"(%246) <{alias_scopes = [#alias_scope168, #alias_scope167], alignment = 32 : i64, noalias_scopes = [#alias_scope169, #alias_scope170], ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %248 = "llvm.zext"(%247) : (i32) -> i64
  %249 = "llvm.getelementptr"(%155) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 100>}> : (!llvm.ptr) -> !llvm.ptr
  %250 = "llvm.load"(%249) <{alias_scopes = [#alias_scope168, #alias_scope167], alignment = 4 : i64, noalias_scopes = [#alias_scope169, #alias_scope170], ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %251 = "llvm.zext"(%250) : (i32) -> i64
  %252 = "llvm.getelementptr"(%155) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 104>}> : (!llvm.ptr) -> !llvm.ptr
  %253 = "llvm.load"(%252) <{alias_scopes = [#alias_scope168, #alias_scope167], alignment = 8 : i64, noalias_scopes = [#alias_scope169, #alias_scope170], ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %254 = "llvm.zext"(%253) : (i32) -> i64
  %255 = "llvm.getelementptr"(%155) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 108>}> : (!llvm.ptr) -> !llvm.ptr
  %256 = "llvm.load"(%255) <{alias_scopes = [#alias_scope168, #alias_scope167], alignment = 4 : i64, noalias_scopes = [#alias_scope169, #alias_scope170], ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %257 = "llvm.zext"(%256) : (i32) -> i64
  %258 = "llvm.getelementptr"(%155) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 112>}> : (!llvm.ptr) -> !llvm.ptr
  %259 = "llvm.load"(%258) <{alias_scopes = [#alias_scope168, #alias_scope167], alignment = 16 : i64, noalias_scopes = [#alias_scope169, #alias_scope170], ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %260 = "llvm.zext"(%259) : (i32) -> i64
  %261 = "llvm.getelementptr"(%155) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 116>}> : (!llvm.ptr) -> !llvm.ptr
  %262 = "llvm.load"(%261) <{alias_scopes = [#alias_scope168, #alias_scope167], alignment = 4 : i64, noalias_scopes = [#alias_scope169, #alias_scope170], ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %263 = "llvm.zext"(%262) : (i32) -> i64
  %264 = "llvm.getelementptr"(%155) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 120>}> : (!llvm.ptr) -> !llvm.ptr
  %265 = "llvm.load"(%264) <{alias_scopes = [#alias_scope168, #alias_scope167], alignment = 8 : i64, noalias_scopes = [#alias_scope169, #alias_scope170], ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %266 = "llvm.zext"(%265) : (i32) -> i64
  %267 = "llvm.getelementptr"(%155) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 124>}> : (!llvm.ptr) -> !llvm.ptr
  %268 = "llvm.load"(%267) <{alias_scopes = [#alias_scope168, #alias_scope167], alignment = 4 : i64, noalias_scopes = [#alias_scope169, #alias_scope170], ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %269 = "llvm.zext"(%268) : (i32) -> i64
  %270 = "llvm.shl"(%254, %142) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %271 = "llvm.add"(%270, %248) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %272 = "llvm.shl"(%257, %142) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %273 = "llvm.add"(%272, %251) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %274 = "llvm.shl"(%266, %142) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %275 = "llvm.add"(%274, %260) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %276 = "llvm.shl"(%269, %142) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %277 = "llvm.add"(%276, %263) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %278 = "llvm.getelementptr"(%155) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %279 = "llvm.load"(%278) <{alias_scopes = [#alias_scope168, #alias_scope167], alignment = 32 : i64, noalias_scopes = [#alias_scope169, #alias_scope170], ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %280 = "llvm.getelementptr"(%155) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 132>}> : (!llvm.ptr) -> !llvm.ptr
  %281 = "llvm.load"(%280) <{alias_scopes = [#alias_scope168, #alias_scope167], alignment = 4 : i64, noalias_scopes = [#alias_scope169, #alias_scope170], ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %282 = "llvm.getelementptr"(%155) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 136>}> : (!llvm.ptr) -> !llvm.ptr
  %283 = "llvm.load"(%282) <{alias_scopes = [#alias_scope168, #alias_scope167], alignment = 8 : i64, noalias_scopes = [#alias_scope169, #alias_scope170], ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %284 = "llvm.getelementptr"(%155) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 140>}> : (!llvm.ptr) -> !llvm.ptr
  %285 = "llvm.load"(%284) <{alias_scopes = [#alias_scope168, #alias_scope167], alignment = 4 : i64, noalias_scopes = [#alias_scope169, #alias_scope170], ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %286 = "llvm.getelementptr"(%155) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 144>}> : (!llvm.ptr) -> !llvm.ptr
  %287 = "llvm.load"(%286) <{alias_scopes = [#alias_scope168, #alias_scope167], alignment = 16 : i64, noalias_scopes = [#alias_scope169, #alias_scope170], ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %288 = "llvm.getelementptr"(%155) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 148>}> : (!llvm.ptr) -> !llvm.ptr
  %289 = "llvm.load"(%288) <{alias_scopes = [#alias_scope168, #alias_scope167], alignment = 4 : i64, noalias_scopes = [#alias_scope169, #alias_scope170], ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %290 = "llvm.zext"(%289) : (i32) -> i64
  %291 = "llvm.getelementptr"(%155) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 152>}> : (!llvm.ptr) -> !llvm.ptr
  %292 = "llvm.load"(%291) <{alias_scopes = [#alias_scope168, #alias_scope167], alignment = 8 : i64, noalias_scopes = [#alias_scope169, #alias_scope170], ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %293 = "llvm.getelementptr"(%155) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 156>}> : (!llvm.ptr) -> !llvm.ptr
  %294 = "llvm.load"(%293) <{alias_scopes = [#alias_scope168, #alias_scope167], alignment = 4 : i64, noalias_scopes = [#alias_scope169, #alias_scope170], ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %295 = "llvm.zext"(%294) : (i32) -> i64
  %296 = "llvm.shl"(%295, %142) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %297 = "llvm.add"(%296, %290) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %298 = "llvm.shufflevector"(%185, %143) <{mask = array<i32: 0, 1>}> : (vector<8xi32>, vector<8xi32>) -> vector<2xi32>
  %299 = "llvm.insertelement"(%298, %187, %144) : (vector<2xi32>, i32, i64) -> vector<2xi32>
  %300 = "llvm.zext"(%299) : (vector<2xi32>) -> vector<2xi64>
  %301 = "llvm.shufflevector"(%185, %143) <{mask = array<i32: 2, 3>}> : (vector<8xi32>, vector<8xi32>) -> vector<2xi32>
  %302 = "llvm.insertelement"(%301, %192, %144) : (vector<2xi32>, i32, i64) -> vector<2xi32>
  %303 = "llvm.zext"(%302) : (vector<2xi32>) -> vector<2xi64>
  %304 = "llvm.shl"(%303, %145) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %305 = "llvm.add"(%304, %300) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  "llvm.store"(%305, %arg6) <{alignment = 8 : i64, noalias_scopes = [#alias_scope167], ordering = 0 : i64}> : (vector<2xi64>, !llvm.ptr) -> ()
  %306 = "llvm.getelementptr"(%arg6) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%239, %306) <{alignment = 8 : i64, noalias_scopes = [#alias_scope167], ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %307 = "llvm.getelementptr"(%arg6) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%271, %307) <{alignment = 8 : i64, noalias_scopes = [#alias_scope167], ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %308 = "llvm.getelementptr"(%arg6) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %309 = "llvm.insertelement"(%298, %279, %139) : (vector<2xi32>, i32, i64) -> vector<2xi32>
  %310 = "llvm.zext"(%309) : (vector<2xi32>) -> vector<2xi64>
  %311 = "llvm.insertelement"(%301, %283, %139) : (vector<2xi32>, i32, i64) -> vector<2xi32>
  %312 = "llvm.zext"(%311) : (vector<2xi32>) -> vector<2xi64>
  %313 = "llvm.shl"(%312, %145) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %314 = "llvm.add"(%313, %310) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  "llvm.store"(%314, %308) <{alignment = 8 : i64, noalias_scopes = [#alias_scope167], ordering = 0 : i64}> : (vector<2xi64>, !llvm.ptr) -> ()
  %315 = "llvm.getelementptr"(%arg6) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 48>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%209, %315) <{alignment = 8 : i64, noalias_scopes = [#alias_scope167], ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %316 = "llvm.getelementptr"(%arg6) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 56>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%241, %316) <{alignment = 8 : i64, noalias_scopes = [#alias_scope167], ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %317 = "llvm.getelementptr"(%arg6) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%273, %317) <{alignment = 8 : i64, noalias_scopes = [#alias_scope167], ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %318 = "llvm.getelementptr"(%arg6) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 72>}> : (!llvm.ptr) -> !llvm.ptr
  %319 = "llvm.shufflevector"(%185, %143) <{mask = array<i32: -1, 4>}> : (vector<8xi32>, vector<8xi32>) -> vector<2xi32>
  %320 = "llvm.insertelement"(%319, %281, %139) : (vector<2xi32>, i32, i64) -> vector<2xi32>
  %321 = "llvm.zext"(%320) : (vector<2xi32>) -> vector<2xi64>
  %322 = "llvm.shufflevector"(%185, %143) <{mask = array<i32: -1, 6>}> : (vector<8xi32>, vector<8xi32>) -> vector<2xi32>
  %323 = "llvm.insertelement"(%322, %285, %139) : (vector<2xi32>, i32, i64) -> vector<2xi32>
  %324 = "llvm.zext"(%323) : (vector<2xi32>) -> vector<2xi64>
  %325 = "llvm.shl"(%324, %145) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %326 = "llvm.add"(%325, %321) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  "llvm.store"(%326, %318) <{alignment = 8 : i64, noalias_scopes = [#alias_scope167], ordering = 0 : i64}> : (vector<2xi64>, !llvm.ptr) -> ()
  %327 = "llvm.getelementptr"(%arg6) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 88>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%211, %327) <{alignment = 8 : i64, noalias_scopes = [#alias_scope167], ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %328 = "llvm.getelementptr"(%arg6) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%243, %328) <{alignment = 8 : i64, noalias_scopes = [#alias_scope167], ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %329 = "llvm.getelementptr"(%arg6) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 104>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%275, %329) <{alignment = 8 : i64, noalias_scopes = [#alias_scope167], ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %330 = "llvm.getelementptr"(%arg6) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 112>}> : (!llvm.ptr) -> !llvm.ptr
  %331 = "llvm.shufflevector"(%185, %143) <{mask = array<i32: -1, 5>}> : (vector<8xi32>, vector<8xi32>) -> vector<2xi32>
  %332 = "llvm.insertelement"(%331, %287, %139) : (vector<2xi32>, i32, i64) -> vector<2xi32>
  %333 = "llvm.zext"(%332) : (vector<2xi32>) -> vector<2xi64>
  %334 = "llvm.shufflevector"(%185, %143) <{mask = array<i32: -1, 7>}> : (vector<8xi32>, vector<8xi32>) -> vector<2xi32>
  %335 = "llvm.insertelement"(%334, %292, %139) : (vector<2xi32>, i32, i64) -> vector<2xi32>
  %336 = "llvm.zext"(%335) : (vector<2xi32>) -> vector<2xi64>
  %337 = "llvm.shl"(%336, %145) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %338 = "llvm.add"(%337, %333) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  "llvm.store"(%338, %330) <{alignment = 8 : i64, noalias_scopes = [#alias_scope167], ordering = 0 : i64}> : (vector<2xi64>, !llvm.ptr) -> ()
  %339 = "llvm.getelementptr"(%arg6) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%213, %339) <{alignment = 8 : i64, noalias_scopes = [#alias_scope167], ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %340 = "llvm.getelementptr"(%arg6) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 136>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%245, %340) <{alignment = 8 : i64, noalias_scopes = [#alias_scope167], ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %341 = "llvm.getelementptr"(%arg6) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 144>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%277, %341) <{alignment = 8 : i64, noalias_scopes = [#alias_scope167], ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %342 = "llvm.getelementptr"(%arg6) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 152>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%297, %342) <{alignment = 8 : i64, noalias_scopes = [#alias_scope167], ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%156) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%157) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%158) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
