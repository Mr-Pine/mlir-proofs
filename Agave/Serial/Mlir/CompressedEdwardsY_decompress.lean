module

-- agave-build/out/serial-noinline-big/op/_RNvMs2_NtCs2JGgYtL0Fal_14solana_ed255197edwardsNtB5_18CompressedEdwardsY10decompress.mlir
-- <solana_ed25519[1fe0933b11699477]::edwards::CompressedEdwardsY>::decompress

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Agave.Serial.Mlir.black_box_u8
public import Agave.Serial.Mlir.FieldElement51_sqrt_ratio_i
public import Agave.Serial.Mlir.FieldElement51_square
public import Agave.Serial.Mlir.FieldElement51_Add_add
public import Agave.Serial.Mlir.FieldElement51_Sub_sub
public import Agave.Serial.Mlir.FieldElement51_Mul_mul
public import Agave.Serial.Mlir.FieldElement51_Neg_neg
public import Agave.Serial.Mlir.FieldElement51_ConditionallySelectable_conditional_assign
public import Agave.Serial.Mlir.anon_042b818bc72209407b52bd0e4d6c8368_1
public import Agave.Serial.Mlir.anon_042b818bc72209407b52bd0e4d6c8368_26

meta import MLIR.Semantics.Func
meta import Agave.Serial.Mlir.black_box_u8
meta import Agave.Serial.Mlir.FieldElement51_sqrt_ratio_i
meta import Agave.Serial.Mlir.FieldElement51_square
meta import Agave.Serial.Mlir.FieldElement51_Add_add
meta import Agave.Serial.Mlir.FieldElement51_Sub_sub
meta import Agave.Serial.Mlir.FieldElement51_Mul_mul
meta import Agave.Serial.Mlir.FieldElement51_Neg_neg
meta import Agave.Serial.Mlir.FieldElement51_ConditionallySelectable_conditional_assign
meta import Agave.Serial.Mlir.anon_042b818bc72209407b52bd0e4d6c8368_1
meta import Agave.Serial.Mlir.anon_042b818bc72209407b52bd0e4d6c8368_26

namespace MLIR.Agave.Serial

@[expose] public section

mlir_def CompressedEdwardsY_decompress :=
#alias_scope_domain26 = #llvm.alias_scope_domain<id = distinct[26]<>, description = "_RNvMs8_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldNtB5_14FieldElement5110from_bytes">
#alias_scope_domain27 = #llvm.alias_scope_domain<id = distinct[27]<>, description = "_RNvNvMs8_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldNtB7_14FieldElement5110from_bytes8load8_at">
#alias_scope_domain28 = #llvm.alias_scope_domain<id = distinct[28]<>, description = "_RNvNtNtCs2JGgYtL0Fal_14solana_ed255197edwards10decompress6step_1">
#alias_scope_domain29 = #llvm.alias_scope_domain<id = distinct[29]<>, description = "_RNvNvMs8_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldNtB7_14FieldElement5110from_bytes8load8_at">
#alias_scope_domain30 = #llvm.alias_scope_domain<id = distinct[30]<>, description = "_RNvNvMs8_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldNtB7_14FieldElement5110from_bytes8load8_at">
#alias_scope_domain31 = #llvm.alias_scope_domain<id = distinct[31]<>, description = "_RNvNvMs8_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldNtB7_14FieldElement5110from_bytes8load8_at">
#alias_scope_domain32 = #llvm.alias_scope_domain<id = distinct[32]<>, description = "_RNvNtNtCs2JGgYtL0Fal_14solana_ed255197edwards10decompress6step_2">
#alias_scope38 = #llvm.alias_scope<id = distinct[114]<>, domain = #alias_scope_domain26, description = "_RNvMs8_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldNtB5_14FieldElement5110from_bytes: argument 0">
#alias_scope39 = #llvm.alias_scope<id = distinct[115]<>, domain = #alias_scope_domain26, description = "_RNvMs8_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldNtB5_14FieldElement5110from_bytes: argument 1">
#alias_scope40 = #llvm.alias_scope<id = distinct[116]<>, domain = #alias_scope_domain27, description = "_RNvNvMs8_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldNtB7_14FieldElement5110from_bytes8load8_at: argument 0">
#alias_scope41 = #llvm.alias_scope<id = distinct[117]<>, domain = #alias_scope_domain28, description = "_RNvNtNtCs2JGgYtL0Fal_14solana_ed255197edwards10decompress6step_1: argument 0">
#alias_scope42 = #llvm.alias_scope<id = distinct[118]<>, domain = #alias_scope_domain29, description = "_RNvNvMs8_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldNtB7_14FieldElement5110from_bytes8load8_at: argument 0">
#alias_scope43 = #llvm.alias_scope<id = distinct[119]<>, domain = #alias_scope_domain30, description = "_RNvNvMs8_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldNtB7_14FieldElement5110from_bytes8load8_at: argument 0">
#alias_scope44 = #llvm.alias_scope<id = distinct[120]<>, domain = #alias_scope_domain31, description = "_RNvNvMs8_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldNtB7_14FieldElement5110from_bytes8load8_at: argument 0">
#alias_scope45 = #llvm.alias_scope<id = distinct[121]<>, domain = #alias_scope_domain28, description = "_RNvNtNtCs2JGgYtL0Fal_14solana_ed255197edwards10decompress6step_1: argument 1">
#alias_scope46 = #llvm.alias_scope<id = distinct[122]<>, domain = #alias_scope_domain32, description = "_RNvNtNtCs2JGgYtL0Fal_14solana_ed255197edwards10decompress6step_2: argument 0">
#alias_scope47 = #llvm.alias_scope<id = distinct[123]<>, domain = #alias_scope_domain32, description = "_RNvNtNtCs2JGgYtL0Fal_14solana_ed255197edwards10decompress6step_2: argument 1">
#alias_scope48 = #llvm.alias_scope<id = distinct[124]<>, domain = #alias_scope_domain32, description = "_RNvNtNtCs2JGgYtL0Fal_14solana_ed255197edwards10decompress6step_2: argument 2">
#alias_scope49 = #llvm.alias_scope<id = distinct[125]<>, domain = #alias_scope_domain32, description = "_RNvNtNtCs2JGgYtL0Fal_14solana_ed255197edwards10decompress6step_2: argument 3">
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 8 : i64, llvm.dead_on_unwind, llvm.dereferenceable = 168 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writable, llvm.writeonly}, {llvm.dereferenceable = 32 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["nofree", "norecurse", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], sym_name = "_RNvMs2_NtCs2JGgYtL0Fal_14solana_ed255197edwardsNtB5_18CompressedEdwardsY10decompress", target_cpu = "x86-64-v2", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg45: !llvm.ptr, %arg46: !llvm.ptr):
  %554 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %555 = "llvm.mlir.constant"() <{value = 2251799813685247 : i64}> : () -> i64
  %556 = "llvm.mlir.constant"() <{value = 6 : i64}> : () -> i64
  %557 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %558 = "llvm.mlir.constant"() <{value = 12 : i64}> : () -> i64
  %559 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %560 = "llvm.mlir.addressof"() <{global_name = @anon.042b818bc72209407b52bd0e4d6c8368.1}> : () -> !llvm.ptr
  %561 = "llvm.mlir.addressof"() <{global_name = @anon.042b818bc72209407b52bd0e4d6c8368.26}> : () -> !llvm.ptr
  %562 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
  %563 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %564 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %565 = "llvm.mlir.constant"() <{value = 63 : i64}> : () -> i64
  %566 = "llvm.mlir.constant"() <{value = 160 : i64}> : () -> i64
  %567 = "llvm.alloca"(%554) <{alignment = 8 : i64, elem_type = !llvm.array<40 x i8>}> : (i32) -> !llvm.ptr
  %568 = "llvm.alloca"(%554) <{alignment = 8 : i64, elem_type = !llvm.array<48 x i8>}> : (i32) -> !llvm.ptr
  %569 = "llvm.alloca"(%554) <{alignment = 8 : i64, elem_type = !llvm.array<40 x i8>}> : (i32) -> !llvm.ptr
  %570 = "llvm.alloca"(%554) <{alignment = 8 : i64, elem_type = !llvm.array<40 x i8>}> : (i32) -> !llvm.ptr
  %571 = "llvm.alloca"(%554) <{alignment = 8 : i64, elem_type = !llvm.array<40 x i8>}> : (i32) -> !llvm.ptr
  %572 = "llvm.alloca"(%554) <{alignment = 8 : i64, elem_type = !llvm.array<40 x i8>}> : (i32) -> !llvm.ptr
  %573 = "llvm.alloca"(%554) <{alignment = 8 : i64, elem_type = !llvm.array<40 x i8>}> : (i32) -> !llvm.ptr
  %574 = "llvm.alloca"(%554) <{alignment = 8 : i64, elem_type = !llvm.array<160 x i8>}> : (i32) -> !llvm.ptr
  %575 = "llvm.alloca"(%554) <{alignment = 8 : i64, elem_type = !llvm.array<80 x i8>}> : (i32) -> !llvm.ptr
  %576 = "llvm.alloca"(%554) <{alignment = 8 : i64, elem_type = !llvm.array<40 x i8>}> : (i32) -> !llvm.ptr
  %577 = "llvm.alloca"(%554) <{alignment = 8 : i64, elem_type = !llvm.array<40 x i8>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%575) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%573) : (!llvm.ptr) -> ()
  "llvm.intr.experimental.noalias.scope.decl"() <{scope = #alias_scope38}> : () -> ()
  "llvm.intr.experimental.noalias.scope.decl"() <{scope = #alias_scope39}> : () -> ()
  %578 = "llvm.load"(%arg46) <{alias_scopes = [#alias_scope40, #alias_scope39], alignment = 1 : i64, noalias_scopes = [#alias_scope38, #alias_scope41], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %579 = "llvm.and"(%578, %555) : (i64, i64) -> i64
  %580 = "llvm.getelementptr"(%arg46) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6>}> : (!llvm.ptr) -> !llvm.ptr
  %581 = "llvm.load"(%580) <{alias_scopes = [#alias_scope42, #alias_scope39], alignment = 1 : i64, noalias_scopes = [#alias_scope38, #alias_scope41], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %582 = "llvm.lshr"(%581, %557) : (i64, i64) -> i64
  %583 = "llvm.and"(%582, %555) : (i64, i64) -> i64
  %584 = "llvm.getelementptr"(%arg46) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 12>}> : (!llvm.ptr) -> !llvm.ptr
  %585 = "llvm.load"(%584) <{alias_scopes = [#alias_scope43, #alias_scope39], alignment = 1 : i64, noalias_scopes = [#alias_scope38, #alias_scope41], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %586 = "llvm.lshr"(%585, %556) : (i64, i64) -> i64
  %587 = "llvm.and"(%586, %555) : (i64, i64) -> i64
  %588 = "llvm.getelementptr"(%arg46) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 19>}> : (!llvm.ptr) -> !llvm.ptr
  %589 = "llvm.load"(%588) <{alias_scopes = [#alias_scope44, #alias_scope39], alignment = 1 : i64, noalias_scopes = [#alias_scope38, #alias_scope41], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %590 = "llvm.lshr"(%589, %559) : (i64, i64) -> i64
  %591 = "llvm.and"(%590, %555) : (i64, i64) -> i64
  %592 = "llvm.getelementptr"(%arg46) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %593 = "llvm.load"(%592) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %594 = "llvm.lshr"(%593, %558) : (i64, i64) -> i64
  %595 = "llvm.and"(%594, %555) : (i64, i64) -> i64
  "llvm.store"(%579, %573) <{alias_scopes = [#alias_scope38], alignment = 8 : i64, noalias_scopes = [#alias_scope39, #alias_scope41], ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %596 = "llvm.getelementptr"(%573) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%583, %596) <{alias_scopes = [#alias_scope38], alignment = 8 : i64, noalias_scopes = [#alias_scope39, #alias_scope41], ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %597 = "llvm.getelementptr"(%573) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%587, %597) <{alias_scopes = [#alias_scope38], alignment = 8 : i64, noalias_scopes = [#alias_scope39, #alias_scope41], ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %598 = "llvm.getelementptr"(%573) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%591, %598) <{alias_scopes = [#alias_scope38], alignment = 8 : i64, noalias_scopes = [#alias_scope39, #alias_scope41], ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %599 = "llvm.getelementptr"(%573) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%595, %599) <{alias_scopes = [#alias_scope38], alignment = 8 : i64, noalias_scopes = [#alias_scope39, #alias_scope41], ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%572) : (!llvm.ptr) -> ()
  "llvm.call"(%572, %573) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvMs8_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldNtB5_14FieldElement516square, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope41, #alias_scope45], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%571) : (!llvm.ptr) -> ()
  "llvm.call"(%571, %572, %560) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.noundef, llvm.readonly}], callee = @_RNvXs3_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldRNtB5_14FieldElement51NtNtNtCsgxBkk5gSRhY_4core3ops5arith3Sub3sub, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope41, #alias_scope45], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%570) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%569) : (!llvm.ptr) -> ()
  "llvm.call"(%569, %572, %561) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.noundef, llvm.readonly}], callee = @_RNvXs5_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldRNtB5_14FieldElement51NtNtNtCsgxBkk5gSRhY_4core3ops5arith3Mul3mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope41, #alias_scope45], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%570, %569, %560) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvXs1_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldRNtB5_14FieldElement51NtNtNtCsgxBkk5gSRhY_4core3ops5arith3Add3add, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope41, #alias_scope45], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%569) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%568) : (!llvm.ptr) -> ()
  "llvm.call"(%568, %571, %570) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 48 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.noundef, llvm.readonly}], callee = @_RNvMs2_NtCs2JGgYtL0Fal_14solana_ed255195fieldNtNtNtNtNtB7_7backend6serial3u645field14FieldElement5112sqrt_ratio_i, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope41, #alias_scope45], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  %600 = "llvm.load"(%568) <{alignment = 8 : i64, noalias_scopes = [#alias_scope41, #alias_scope45], ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %601 = "llvm.getelementptr"(%568) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memcpy"(%575, %601, %562) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false, noalias_scopes = [#alias_scope45]}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.intr.lifetime.end"(%568) : (!llvm.ptr) -> ()
  %602 = "llvm.getelementptr"(%575) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memcpy"(%602, %573, %562) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false, noalias_scopes = [#alias_scope45]}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.intr.lifetime.end"(%570) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%571) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%572) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%573) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%577) : (!llvm.ptr) -> ()
  "llvm.intr.memcpy"(%577, %575, %562) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.intr.lifetime.start"(%576) : (!llvm.ptr) -> ()
  "llvm.intr.memcpy"(%576, %602, %562) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.intr.lifetime.end"(%575) : (!llvm.ptr) -> ()
  %603 = "llvm.icmp"(%600, %563) <{predicate = 0 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%603, %564)[^bb2, ^bb1] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
^bb1:  // pred: ^bb0
  "llvm.intr.lifetime.start"(%574) : (!llvm.ptr) -> ()
  "llvm.intr.experimental.noalias.scope.decl"() <{scope = #alias_scope46}> : () -> ()
  "llvm.intr.experimental.noalias.scope.decl"() <{scope = #alias_scope47}> : () -> ()
  "llvm.intr.experimental.noalias.scope.decl"() <{scope = #alias_scope48}> : () -> ()
  %604 = "llvm.lshr"(%593, %565) : (i64, i64) -> i64
  %605 = "llvm.trunc"(%604) <{overflowFlags = 3 : i32}> : (i64) -> i8
  %606 = "llvm.call"(%605) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  "llvm.intr.lifetime.start"(%567) : (!llvm.ptr) -> ()
  "llvm.call"(%567, %577) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvXs6_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldRNtB5_14FieldElement51NtNtNtCsgxBkk5gSRhY_4core3ops5arith3Neg3neg, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope46, #alias_scope48, #alias_scope49], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%577, %567, %606) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.noundef}], callee = @_RNvXs7_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldNtB5_14FieldElement51NtCs3X6wZJE6GDg_6subtle23ConditionallySelectable18conditional_assign, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope46, #alias_scope48, #alias_scope49], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i8) -> ()
  "llvm.intr.lifetime.end"(%567) : (!llvm.ptr) -> ()
  "llvm.intr.memcpy"(%574, %577, %562) <{alias_scopes = [#alias_scope46, #alias_scope47], arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 160 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false, noalias_scopes = [#alias_scope48, #alias_scope49]}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %607 = "llvm.getelementptr"(%574) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 120>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%607, %577, %576) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, alias_scopes = [#alias_scope46, #alias_scope47, #alias_scope48], arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvXs5_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldRNtB5_14FieldElement51NtNtNtCsgxBkk5gSRhY_4core3ops5arith3Mul3mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope49], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  %608 = "llvm.getelementptr"(%574) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memcpy"(%608, %576, %562) <{alias_scopes = [#alias_scope46, #alias_scope48], arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef, llvm.readonly}, {}], isVolatile = false, noalias_scopes = [#alias_scope47, #alias_scope49]}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %609 = "llvm.getelementptr"(%574) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 80>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memcpy"(%609, %560, %562) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %610 = "llvm.getelementptr"(%arg45) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memcpy"(%610, %574, %566) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 160 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 160 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.intr.lifetime.end"(%574) : (!llvm.ptr) -> ()
  "llvm.br"(%559)[^bb2] : (i64) -> ()
^bb2(%611: i64):  // 2 preds: ^bb0, ^bb1
  "llvm.store"(%611, %arg45) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%576) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%577) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
  with @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519 := black_box_u8,
    @_RNvMs2_NtCs2JGgYtL0Fal_14solana_ed255195fieldNtNtNtNtNtB7_7backend6serial3u645field14FieldElement5112sqrt_ratio_i := FieldElement51_sqrt_ratio_i,
    @_RNvMs8_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldNtB5_14FieldElement516square := FieldElement51_square,
    @_RNvXs1_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldRNtB5_14FieldElement51NtNtNtCsgxBkk5gSRhY_4core3ops5arith3Add3add := FieldElement51_Add_add,
    @_RNvXs3_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldRNtB5_14FieldElement51NtNtNtCsgxBkk5gSRhY_4core3ops5arith3Sub3sub := FieldElement51_Sub_sub,
    @_RNvXs5_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldRNtB5_14FieldElement51NtNtNtCsgxBkk5gSRhY_4core3ops5arith3Mul3mul := FieldElement51_Mul_mul,
    @_RNvXs6_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldRNtB5_14FieldElement51NtNtNtCsgxBkk5gSRhY_4core3ops5arith3Neg3neg := FieldElement51_Neg_neg,
    @_RNvXs7_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldNtB5_14FieldElement51NtCs3X6wZJE6GDg_6subtle23ConditionallySelectable18conditional_assign := FieldElement51_ConditionallySelectable_conditional_assign,
    @anon.042b818bc72209407b52bd0e4d6c8368.1 := anon_042b818bc72209407b52bd0e4d6c8368_1,
    @anon.042b818bc72209407b52bd0e4d6c8368.26 := anon_042b818bc72209407b52bd0e4d6c8368_26

end

end MLIR.Agave.Serial
