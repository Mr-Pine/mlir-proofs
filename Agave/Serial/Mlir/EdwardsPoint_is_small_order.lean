module

-- agave-build/out/serial-noinline-big/op/_RNvMsx_NtCs2JGgYtL0Fal_14solana_ed255197edwardsNtB5_12EdwardsPoint14is_small_order.mlir
-- <solana_ed25519[1fe0933b11699477]::edwards::EdwardsPoint>::is_small_order

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Agave.Serial.Mlir.black_box_u8
public import Agave.Serial.Mlir.CompletedPoint_as_extended
public import Agave.Serial.Mlir.CompletedPoint_as_projective
public import Agave.Serial.Mlir.ProjectivePoint_double
public import Agave.Serial.Mlir.FieldElement51_ConstantTimeEq_ct_eq
public import Agave.Serial.Mlir.FieldElement51_Mul_mul
public import Agave.Serial.Mlir.anon_042b818bc72209407b52bd0e4d6c8368_1

meta import MLIR.Semantics.Func
meta import Agave.Serial.Mlir.black_box_u8
meta import Agave.Serial.Mlir.CompletedPoint_as_extended
meta import Agave.Serial.Mlir.CompletedPoint_as_projective
meta import Agave.Serial.Mlir.ProjectivePoint_double
meta import Agave.Serial.Mlir.FieldElement51_ConstantTimeEq_ct_eq
meta import Agave.Serial.Mlir.FieldElement51_Mul_mul
meta import Agave.Serial.Mlir.anon_042b818bc72209407b52bd0e4d6c8368_1

namespace MLIR.Agave.Serial

@[expose] public section

mlir_def EdwardsPoint_is_small_order :=
#alias_scope_domain49 = #llvm.alias_scope_domain<id = distinct[49]<>, description = "_RNvMsx_NtCs2JGgYtL0Fal_14solana_ed255197edwardsNtB5_12EdwardsPoint12mul_by_pow_2">
#alias_scope_domain50 = #llvm.alias_scope_domain<id = distinct[50]<>, description = "_RNvMsx_NtCs2JGgYtL0Fal_14solana_ed255197edwardsNtB5_12EdwardsPoint15mul_by_cofactor">
#alias_scope_domain51 = #llvm.alias_scope_domain<id = distinct[51]<>, description = "_RNvXs7_NtCs2JGgYtL0Fal_14solana_ed255197edwardsNtB5_12EdwardsPointNtNtB7_6traits8Identity8identity">
#alias_scope_domain52 = #llvm.alias_scope_domain<id = distinct[52]<>, description = "_RNvXNtCs2JGgYtL0Fal_14solana_ed255196traitsNtNtB4_7edwards12EdwardsPointNtB2_10IsIdentity11is_identityB4_">
#alias_scope_domain53 = #llvm.alias_scope_domain<id = distinct[53]<>, description = "_RNvXsd_NtCs2JGgYtL0Fal_14solana_ed255197edwardsNtB5_12EdwardsPointNtCs3X6wZJE6GDg_6subtle14ConstantTimeEq5ct_eq">
#alias_scope74 = #llvm.alias_scope<id = distinct[150]<>, domain = #alias_scope_domain49, description = "_RNvMsx_NtCs2JGgYtL0Fal_14solana_ed255197edwardsNtB5_12EdwardsPoint12mul_by_pow_2: argument 0">
#alias_scope75 = #llvm.alias_scope<id = distinct[151]<>, domain = #alias_scope_domain50, description = "_RNvMsx_NtCs2JGgYtL0Fal_14solana_ed255197edwardsNtB5_12EdwardsPoint15mul_by_cofactor: argument 0">
#alias_scope76 = #llvm.alias_scope<id = distinct[152]<>, domain = #alias_scope_domain49, description = "_RNvMsx_NtCs2JGgYtL0Fal_14solana_ed255197edwardsNtB5_12EdwardsPoint12mul_by_pow_2: argument 1">
#alias_scope77 = #llvm.alias_scope<id = distinct[153]<>, domain = #alias_scope_domain50, description = "_RNvMsx_NtCs2JGgYtL0Fal_14solana_ed255197edwardsNtB5_12EdwardsPoint15mul_by_cofactor: argument 1">
#alias_scope78 = #llvm.alias_scope<id = distinct[154]<>, domain = #alias_scope_domain51, description = "_RNvXs7_NtCs2JGgYtL0Fal_14solana_ed255197edwardsNtB5_12EdwardsPointNtNtB7_6traits8Identity8identity: argument 0">
#alias_scope79 = #llvm.alias_scope<id = distinct[155]<>, domain = #alias_scope_domain52, description = "_RNvXNtCs2JGgYtL0Fal_14solana_ed255196traitsNtNtB4_7edwards12EdwardsPointNtB2_10IsIdentity11is_identityB4_: argument 0">
#alias_scope80 = #llvm.alias_scope<id = distinct[156]<>, domain = #alias_scope_domain53, description = "_RNvXsd_NtCs2JGgYtL0Fal_14solana_ed255197edwardsNtB5_12EdwardsPointNtCs3X6wZJE6GDg_6subtle14ConstantTimeEq5ct_eq: argument 0">
#alias_scope81 = #llvm.alias_scope<id = distinct[157]<>, domain = #alias_scope_domain53, description = "_RNvXsd_NtCs2JGgYtL0Fal_14solana_ed255197edwardsNtB5_12EdwardsPointNtCs3X6wZJE6GDg_6subtle14ConstantTimeEq5ct_eq: argument 1">
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<i1 (ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["nofree", "norecurse", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], personality = @rust_eh_personality, res_attrs = [{llvm.noundef, llvm.zeroext}], sym_name = "_RNvMsx_NtCs2JGgYtL0Fal_14solana_ed255197edwardsNtB5_12EdwardsPoint14is_small_order", target_cpu = "x86-64-v2", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg10: !llvm.ptr):
  %243 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %244 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
  %245 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %246 = "llvm.mlir.addressof"() <{global_name = @anon.042b818bc72209407b52bd0e4d6c8368.1}> : () -> !llvm.ptr
  %247 = "llvm.alloca"(%243) <{alignment = 8 : i64, elem_type = !llvm.array<40 x i8>}> : (i32) -> !llvm.ptr
  %248 = "llvm.alloca"(%243) <{alignment = 8 : i64, elem_type = !llvm.array<40 x i8>}> : (i32) -> !llvm.ptr
  %249 = "llvm.alloca"(%243) <{alignment = 8 : i64, elem_type = !llvm.array<40 x i8>}> : (i32) -> !llvm.ptr
  %250 = "llvm.alloca"(%243) <{alignment = 8 : i64, elem_type = !llvm.array<40 x i8>}> : (i32) -> !llvm.ptr
  %251 = "llvm.alloca"(%243) <{alignment = 8 : i64, elem_type = !llvm.array<160 x i8>}> : (i32) -> !llvm.ptr
  %252 = "llvm.alloca"(%243) <{alignment = 8 : i64, elem_type = !llvm.array<160 x i8>}> : (i32) -> !llvm.ptr
  %253 = "llvm.alloca"(%243) <{alignment = 8 : i64, elem_type = !llvm.array<120 x i8>}> : (i32) -> !llvm.ptr
  %254 = "llvm.alloca"(%243) <{alignment = 8 : i64, elem_type = !llvm.array<160 x i8>}> : (i32) -> !llvm.ptr
  %255 = "llvm.alloca"(%243) <{alignment = 8 : i64, elem_type = !llvm.array<160 x i8>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%255) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%254) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%253) : (!llvm.ptr) -> ()
  %256 = "llvm.getelementptr"(%arg10) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  %257 = "llvm.getelementptr"(%253) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memcpy"(%257, %256, %244) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef, llvm.readonly}, {}], isVolatile = false, noalias_scopes = [#alias_scope74, #alias_scope75]}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %258 = "llvm.getelementptr"(%arg10) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 80>}> : (!llvm.ptr) -> !llvm.ptr
  %259 = "llvm.getelementptr"(%253) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 80>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memcpy"(%259, %258, %244) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef, llvm.readonly}, {}], isVolatile = false, noalias_scopes = [#alias_scope74, #alias_scope75]}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.intr.memcpy"(%253, %arg10, %244) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 160 : i64, llvm.nonnull, llvm.noundef, llvm.readonly}, {}], isVolatile = false, noalias_scopes = [#alias_scope74, #alias_scope75]}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.call"(%254, %253) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 120 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvMsa_NtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial12curve_modelsNtB5_15ProjectivePoint6double, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope74, #alias_scope76, #alias_scope75, #alias_scope77], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%253, %254) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 120 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvMs9_NtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial12curve_modelsNtB5_14CompletedPoint13as_projective, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope74, #alias_scope76, #alias_scope75, #alias_scope77], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%254, %253) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 120 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvMsa_NtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial12curve_modelsNtB5_15ProjectivePoint6double, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope74, #alias_scope76, #alias_scope75, #alias_scope77], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%253, %254) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 120 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvMs9_NtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial12curve_modelsNtB5_14CompletedPoint13as_projective, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope74, #alias_scope76, #alias_scope75, #alias_scope77], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%252) : (!llvm.ptr) -> ()
  "llvm.call"(%252, %253) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 120 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvMsa_NtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial12curve_modelsNtB5_15ProjectivePoint6double, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope74, #alias_scope76, #alias_scope75, #alias_scope77], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%255, %252) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvMs9_NtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial12curve_modelsNtB5_14CompletedPoint11as_extended, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope76, #alias_scope77], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%252) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%253) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%254) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%251) : (!llvm.ptr) -> ()
  "llvm.intr.memset"(%251, %245, %244) <{alias_scopes = [#alias_scope78], arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 160 : i64, llvm.nonnull, llvm.noundef}, {}, {}], isVolatile = false, noalias_scopes = [#alias_scope79]}> : (!llvm.ptr, i8, i64) -> ()
  %260 = "llvm.getelementptr"(%251) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memcpy"(%260, %246, %244) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false, noalias_scopes = [#alias_scope79]}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %261 = "llvm.getelementptr"(%251) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 80>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memcpy"(%261, %246, %244) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false, noalias_scopes = [#alias_scope79]}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %262 = "llvm.getelementptr"(%251) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 120>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memset"(%262, %245, %244) <{alias_scopes = [#alias_scope78], arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {}, {}], isVolatile = false, noalias_scopes = [#alias_scope79]}> : (!llvm.ptr, i8, i64) -> ()
  "llvm.intr.lifetime.start"(%250) : (!llvm.ptr) -> ()
  "llvm.call"(%250, %255, %261) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvXs5_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldRNtB5_14FieldElement51NtNtNtCsgxBkk5gSRhY_4core3ops5arith3Mul3mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%249) : (!llvm.ptr) -> ()
  %263 = "llvm.getelementptr"(%255) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 80>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%249, %251, %263) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvXs5_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldRNtB5_14FieldElement51NtNtNtCsgxBkk5gSRhY_4core3ops5arith3Mul3mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  %264 = "llvm.call"(%250, %249) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvXs0_NtCs2JGgYtL0Fal_14solana_ed255195fieldNtNtNtNtNtB7_7backend6serial3u645field14FieldElement51NtCs3X6wZJE6GDg_6subtle14ConstantTimeEq5ct_eq, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope80, #alias_scope81, #alias_scope79], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>, res_attrs = [{llvm.noundef}]}> : (!llvm.ptr, !llvm.ptr) -> i8
  "llvm.intr.lifetime.start"(%248) : (!llvm.ptr) -> ()
  %265 = "llvm.getelementptr"(%255) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%248, %265, %261) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvXs5_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldRNtB5_14FieldElement51NtNtNtCsgxBkk5gSRhY_4core3ops5arith3Mul3mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%247) : (!llvm.ptr) -> ()
  "llvm.call"(%247, %260, %263) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvXs5_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldRNtB5_14FieldElement51NtNtNtCsgxBkk5gSRhY_4core3ops5arith3Mul3mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  %266 = "llvm.call"(%248, %247) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvXs0_NtCs2JGgYtL0Fal_14solana_ed255195fieldNtNtNtNtNtB7_7backend6serial3u645field14FieldElement51NtCs3X6wZJE6GDg_6subtle14ConstantTimeEq5ct_eq, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope80, #alias_scope81, #alias_scope79], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>, res_attrs = [{llvm.noundef}]}> : (!llvm.ptr, !llvm.ptr) -> i8
  %267 = "llvm.and"(%266, %264) : (i8, i8) -> i8
  %268 = "llvm.call"(%267) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  "llvm.intr.lifetime.end"(%247) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%248) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%249) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%250) : (!llvm.ptr) -> ()
  %269 = "llvm.icmp"(%268, %245) <{predicate = 1 : i64}> : (i8, i8) -> i1
  "llvm.intr.lifetime.end"(%251) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%255) : (!llvm.ptr) -> ()
  "llvm.return"(%269) : (i1) -> ()
}) : () -> ()
  with @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519 := black_box_u8,
    @_RNvMs9_NtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial12curve_modelsNtB5_14CompletedPoint11as_extended := CompletedPoint_as_extended,
    @_RNvMs9_NtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial12curve_modelsNtB5_14CompletedPoint13as_projective := CompletedPoint_as_projective,
    @_RNvMsa_NtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial12curve_modelsNtB5_15ProjectivePoint6double := ProjectivePoint_double,
    @_RNvXs0_NtCs2JGgYtL0Fal_14solana_ed255195fieldNtNtNtNtNtB7_7backend6serial3u645field14FieldElement51NtCs3X6wZJE6GDg_6subtle14ConstantTimeEq5ct_eq := FieldElement51_ConstantTimeEq_ct_eq,
    @_RNvXs5_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldRNtB5_14FieldElement51NtNtNtCsgxBkk5gSRhY_4core3ops5arith3Mul3mul := FieldElement51_Mul_mul,
    @anon.042b818bc72209407b52bd0e4d6c8368.1 := anon_042b818bc72209407b52bd0e4d6c8368_1

end

end MLIR.Agave.Serial
