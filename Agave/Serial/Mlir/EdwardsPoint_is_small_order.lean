module

-- agave-build/out/serial-noinline/op/_RNvMsx_NtCs2JGgYtL0Fal_14solana_ed255197edwardsNtB5_12EdwardsPoint14is_small_order.mlir
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
#alias_scope_domain91 = #llvm.alias_scope_domain<id = distinct[91]<>, description = "_RNvMsx_NtCs2JGgYtL0Fal_14solana_ed255197edwardsNtB5_12EdwardsPoint12mul_by_pow_2">
#alias_scope_domain92 = #llvm.alias_scope_domain<id = distinct[92]<>, description = "_RNvMsx_NtCs2JGgYtL0Fal_14solana_ed255197edwardsNtB5_12EdwardsPoint15mul_by_cofactor">
#alias_scope_domain93 = #llvm.alias_scope_domain<id = distinct[93]<>, description = "_RNvXs7_NtCs2JGgYtL0Fal_14solana_ed255197edwardsNtB5_12EdwardsPointNtNtB7_6traits8Identity8identity">
#alias_scope_domain94 = #llvm.alias_scope_domain<id = distinct[94]<>, description = "_RNvXNtCs2JGgYtL0Fal_14solana_ed255196traitsNtNtB4_7edwards12EdwardsPointNtB2_10IsIdentity11is_identityB4_">
#alias_scope_domain95 = #llvm.alias_scope_domain<id = distinct[95]<>, description = "_RNvXsd_NtCs2JGgYtL0Fal_14solana_ed255197edwardsNtB5_12EdwardsPointNtCs3X6wZJE6GDg_6subtle14ConstantTimeEq5ct_eq">
#alias_scope171 = #llvm.alias_scope<id = distinct[267]<>, domain = #alias_scope_domain91, description = "_RNvMsx_NtCs2JGgYtL0Fal_14solana_ed255197edwardsNtB5_12EdwardsPoint12mul_by_pow_2: argument 0">
#alias_scope172 = #llvm.alias_scope<id = distinct[268]<>, domain = #alias_scope_domain92, description = "_RNvMsx_NtCs2JGgYtL0Fal_14solana_ed255197edwardsNtB5_12EdwardsPoint15mul_by_cofactor: argument 0">
#alias_scope173 = #llvm.alias_scope<id = distinct[269]<>, domain = #alias_scope_domain91, description = "_RNvMsx_NtCs2JGgYtL0Fal_14solana_ed255197edwardsNtB5_12EdwardsPoint12mul_by_pow_2: argument 1">
#alias_scope174 = #llvm.alias_scope<id = distinct[270]<>, domain = #alias_scope_domain92, description = "_RNvMsx_NtCs2JGgYtL0Fal_14solana_ed255197edwardsNtB5_12EdwardsPoint15mul_by_cofactor: argument 1">
#alias_scope175 = #llvm.alias_scope<id = distinct[271]<>, domain = #alias_scope_domain93, description = "_RNvXs7_NtCs2JGgYtL0Fal_14solana_ed255197edwardsNtB5_12EdwardsPointNtNtB7_6traits8Identity8identity: argument 0">
#alias_scope176 = #llvm.alias_scope<id = distinct[272]<>, domain = #alias_scope_domain94, description = "_RNvXNtCs2JGgYtL0Fal_14solana_ed255196traitsNtNtB4_7edwards12EdwardsPointNtB2_10IsIdentity11is_identityB4_: argument 0">
#alias_scope177 = #llvm.alias_scope<id = distinct[273]<>, domain = #alias_scope_domain95, description = "_RNvXsd_NtCs2JGgYtL0Fal_14solana_ed255197edwardsNtB5_12EdwardsPointNtCs3X6wZJE6GDg_6subtle14ConstantTimeEq5ct_eq: argument 0">
#alias_scope178 = #llvm.alias_scope<id = distinct[274]<>, domain = #alias_scope_domain95, description = "_RNvXsd_NtCs2JGgYtL0Fal_14solana_ed255197edwardsNtB5_12EdwardsPointNtCs3X6wZJE6GDg_6subtle14ConstantTimeEq5ct_eq: argument 1">
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<i1 (ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["nofree", "norecurse", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], personality = @rust_eh_personality, res_attrs = [{llvm.noundef, llvm.zeroext}], sym_name = "_RNvMsx_NtCs2JGgYtL0Fal_14solana_ed255197edwardsNtB5_12EdwardsPoint14is_small_order", target_cpu = "x86-64-v2", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr):
  %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
  %2 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %3 = "llvm.mlir.addressof"() <{global_name = @anon.042b818bc72209407b52bd0e4d6c8368.1}> : () -> !llvm.ptr
  %4 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.array<40 x i8>}> : (i32) -> !llvm.ptr
  %5 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.array<40 x i8>}> : (i32) -> !llvm.ptr
  %6 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.array<40 x i8>}> : (i32) -> !llvm.ptr
  %7 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.array<40 x i8>}> : (i32) -> !llvm.ptr
  %8 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.array<160 x i8>}> : (i32) -> !llvm.ptr
  %9 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.array<160 x i8>}> : (i32) -> !llvm.ptr
  %10 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.array<120 x i8>}> : (i32) -> !llvm.ptr
  %11 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.array<160 x i8>}> : (i32) -> !llvm.ptr
  %12 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.array<160 x i8>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%12) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%11) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%10) : (!llvm.ptr) -> ()
  %13 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  %14 = "llvm.getelementptr"(%10) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memcpy"(%14, %13, %1) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef, llvm.readonly}, {}], isVolatile = false, noalias_scopes = [#alias_scope171, #alias_scope172]}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %15 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 80>}> : (!llvm.ptr) -> !llvm.ptr
  %16 = "llvm.getelementptr"(%10) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 80>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memcpy"(%16, %15, %1) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef, llvm.readonly}, {}], isVolatile = false, noalias_scopes = [#alias_scope171, #alias_scope172]}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.intr.memcpy"(%10, %arg0, %1) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 160 : i64, llvm.nonnull, llvm.noundef, llvm.readonly}, {}], isVolatile = false, noalias_scopes = [#alias_scope171, #alias_scope172]}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.call"(%11, %10) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 120 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvMsa_NtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial12curve_modelsNtB5_15ProjectivePoint6double, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope171, #alias_scope173, #alias_scope172, #alias_scope174], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%10, %11) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 120 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvMs9_NtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial12curve_modelsNtB5_14CompletedPoint13as_projective, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope171, #alias_scope173, #alias_scope172, #alias_scope174], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%11, %10) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 120 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvMsa_NtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial12curve_modelsNtB5_15ProjectivePoint6double, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope171, #alias_scope173, #alias_scope172, #alias_scope174], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%10, %11) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 120 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvMs9_NtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial12curve_modelsNtB5_14CompletedPoint13as_projective, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope171, #alias_scope173, #alias_scope172, #alias_scope174], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%9) : (!llvm.ptr) -> ()
  "llvm.call"(%9, %10) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 120 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvMsa_NtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial12curve_modelsNtB5_15ProjectivePoint6double, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope171, #alias_scope173, #alias_scope172, #alias_scope174], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%12, %9) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvMs9_NtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial12curve_modelsNtB5_14CompletedPoint11as_extended, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope173, #alias_scope174], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%9) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%10) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%11) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%8) : (!llvm.ptr) -> ()
  "llvm.intr.memset"(%8, %2, %1) <{alias_scopes = [#alias_scope175], arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 160 : i64, llvm.nonnull, llvm.noundef}, {}, {}], isVolatile = false, noalias_scopes = [#alias_scope176]}> : (!llvm.ptr, i8, i64) -> ()
  %17 = "llvm.getelementptr"(%8) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memcpy"(%17, %3, %1) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false, noalias_scopes = [#alias_scope176]}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %18 = "llvm.getelementptr"(%8) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 80>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memcpy"(%18, %3, %1) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false, noalias_scopes = [#alias_scope176]}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %19 = "llvm.getelementptr"(%8) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 120>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memset"(%19, %2, %1) <{alias_scopes = [#alias_scope175], arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {}, {}], isVolatile = false, noalias_scopes = [#alias_scope176]}> : (!llvm.ptr, i8, i64) -> ()
  "llvm.intr.lifetime.start"(%7) : (!llvm.ptr) -> ()
  "llvm.call"(%7, %12, %18) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvXs5_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldRNtB5_14FieldElement51NtNtNtCsgxBkk5gSRhY_4core3ops5arith3Mul3mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%6) : (!llvm.ptr) -> ()
  %20 = "llvm.getelementptr"(%12) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 80>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%6, %8, %20) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvXs5_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldRNtB5_14FieldElement51NtNtNtCsgxBkk5gSRhY_4core3ops5arith3Mul3mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  %21 = "llvm.call"(%7, %6) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvXs0_NtCs2JGgYtL0Fal_14solana_ed255195fieldNtNtNtNtNtB7_7backend6serial3u645field14FieldElement51NtCs3X6wZJE6GDg_6subtle14ConstantTimeEq5ct_eq, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope177, #alias_scope178, #alias_scope176], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>, res_attrs = [{llvm.noundef}]}> : (!llvm.ptr, !llvm.ptr) -> i8
  "llvm.intr.lifetime.start"(%5) : (!llvm.ptr) -> ()
  %22 = "llvm.getelementptr"(%12) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%5, %22, %18) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvXs5_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldRNtB5_14FieldElement51NtNtNtCsgxBkk5gSRhY_4core3ops5arith3Mul3mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%4) : (!llvm.ptr) -> ()
  "llvm.call"(%4, %17, %20) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvXs5_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldRNtB5_14FieldElement51NtNtNtCsgxBkk5gSRhY_4core3ops5arith3Mul3mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  %23 = "llvm.call"(%5, %4) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvXs0_NtCs2JGgYtL0Fal_14solana_ed255195fieldNtNtNtNtNtB7_7backend6serial3u645field14FieldElement51NtCs3X6wZJE6GDg_6subtle14ConstantTimeEq5ct_eq, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope177, #alias_scope178, #alias_scope176], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>, res_attrs = [{llvm.noundef}]}> : (!llvm.ptr, !llvm.ptr) -> i8
  %24 = "llvm.and"(%23, %21) : (i8, i8) -> i8
  %25 = "llvm.call"(%24) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  "llvm.intr.lifetime.end"(%4) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%5) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%6) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%7) : (!llvm.ptr) -> ()
  %26 = "llvm.icmp"(%25, %2) <{predicate = 1 : i64}> : (i8, i8) -> i1
  "llvm.intr.lifetime.end"(%8) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%12) : (!llvm.ptr) -> ()
  "llvm.return"(%26) : (i1) -> ()
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
