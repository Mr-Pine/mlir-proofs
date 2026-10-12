module

-- agave-build/out/serial-noinline-big/op/_RNvMsc_NtNtCs2JGgYtL0Fal_14solana_ed255197ed_sigs16verification_keyNtB5_15VerificationKey22verify_dalek_prehashed.mlir
-- <solana_ed25519[1fe0933b11699477]::ed_sigs::verification_key::VerificationKey>::verify_dalek_prehashed

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Agave.Serial.Mlir.black_box_u8
public import Agave.Serial.Mlir.FieldElement51_is_negative
public import Agave.Serial.Mlir.FieldElement51_pow22501
public import Agave.Serial.Mlir.CompressedEdwardsY_decompress
public import Agave.Serial.Mlir.FieldElement51_pow2k
public import Agave.Serial.Mlir.FieldElement51_to_bytes
public import Agave.Serial.Mlir.Scalar_reduce
public import Agave.Serial.Mlir.EdwardsPoint_is_small_order
public import Agave.Serial.Mlir.mul
public import Agave.Serial.Mlir.FieldElement51_Mul_mul
public import Agave.Serial.Mlir.slice_u8_ConstantTimeEq_ct_eq

meta import MLIR.Semantics.Func
meta import Agave.Serial.Mlir.black_box_u8
meta import Agave.Serial.Mlir.FieldElement51_is_negative
meta import Agave.Serial.Mlir.FieldElement51_pow22501
meta import Agave.Serial.Mlir.CompressedEdwardsY_decompress
meta import Agave.Serial.Mlir.FieldElement51_pow2k
meta import Agave.Serial.Mlir.FieldElement51_to_bytes
meta import Agave.Serial.Mlir.Scalar_reduce
meta import Agave.Serial.Mlir.EdwardsPoint_is_small_order
meta import Agave.Serial.Mlir.mul
meta import Agave.Serial.Mlir.FieldElement51_Mul_mul
meta import Agave.Serial.Mlir.slice_u8_ConstantTimeEq_ct_eq

namespace MLIR.Agave.Serial

@[expose] public section

mlir_def VerificationKey_verify_dalek_prehashed :=
#alias_scope_domain45 = #llvm.alias_scope_domain<id = distinct[45]<>, description = "_RNvMNtCs2JGgYtL0Fal_14solana_ed255196scalarNtB2_6Scalar20from_canonical_bytes">
#alias_scope_domain46 = #llvm.alias_scope_domain<id = distinct[46]<>, description = "_RNvMs2_NtCs2JGgYtL0Fal_14solana_ed255195fieldNtNtNtNtNtB7_7backend6serial3u645field14FieldElement516invert">
#alias_scope_domain47 = #llvm.alias_scope_domain<id = distinct[47]<>, description = "_RNvMsg_NtCs2JGgYtL0Fal_14solana_ed255197edwardsNtB5_12EdwardsPoint9to_affine">
#alias_scope_domain48 = #llvm.alias_scope_domain<id = distinct[48]<>, description = "_RNvMsg_NtCs2JGgYtL0Fal_14solana_ed255197edwardsNtB5_12EdwardsPoint8compress">
#alias_scope67 = #llvm.alias_scope<id = distinct[143]<>, domain = #alias_scope_domain45, description = "_RNvMNtCs2JGgYtL0Fal_14solana_ed255196scalarNtB2_6Scalar20from_canonical_bytes: argument 0">
#alias_scope68 = #llvm.alias_scope<id = distinct[144]<>, domain = #alias_scope_domain45, description = "_RNvMNtCs2JGgYtL0Fal_14solana_ed255196scalarNtB2_6Scalar20from_canonical_bytes: argument 1">
#alias_scope69 = #llvm.alias_scope<id = distinct[145]<>, domain = #alias_scope_domain46, description = "_RNvMs2_NtCs2JGgYtL0Fal_14solana_ed255195fieldNtNtNtNtNtB7_7backend6serial3u645field14FieldElement516invert: argument 0">
#alias_scope70 = #llvm.alias_scope<id = distinct[146]<>, domain = #alias_scope_domain47, description = "_RNvMsg_NtCs2JGgYtL0Fal_14solana_ed255197edwardsNtB5_12EdwardsPoint9to_affine: argument 0">
#alias_scope71 = #llvm.alias_scope<id = distinct[147]<>, domain = #alias_scope_domain48, description = "_RNvMsg_NtCs2JGgYtL0Fal_14solana_ed255197edwardsNtB5_12EdwardsPoint8compress: argument 0">
#alias_scope72 = #llvm.alias_scope<id = distinct[148]<>, domain = #alias_scope_domain46, description = "_RNvMs2_NtCs2JGgYtL0Fal_14solana_ed255195fieldNtNtNtNtNtB7_7backend6serial3u645field14FieldElement516invert: argument 1">
#alias_scope73 = #llvm.alias_scope<id = distinct[149]<>, domain = #alias_scope_domain48, description = "_RNvMsg_NtCs2JGgYtL0Fal_14solana_ed255197edwardsNtB5_12EdwardsPoint8compress: argument 1">
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 192 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.dereferenceable = 64 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.align = 1 : i64, llvm.dead_on_return = -1 : i64, llvm.dereferenceable = 32 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<i8 (ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, no_inline, passthrough = ["nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], res_attrs = [{llvm.noundef, llvm.range = #llvm.constant_range<i8, -1, 3>}], sym_name = "_RNvMsc_NtNtCs2JGgYtL0Fal_14solana_ed255197ed_sigs16verification_keyNtB5_15VerificationKey22verify_dalek_prehashed", target_cpu = "x86-64-v2", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg11: !llvm.ptr, %arg12: !llvm.ptr, %arg13: !llvm.ptr):
  %270 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %271 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %272 = "llvm.mlir.constant"() <{value = 2 : i8}> : () -> i8
  %273 = "llvm.mlir.constant"() <{value = 160 : i64}> : () -> i64
  %274 = "llvm.mlir.constant"() <{value = -1 : i8}> : () -> i8
  %275 = "llvm.mlir.constant"() <{value = 1 : i8}> : () -> i8
  %276 = "llvm.mlir.constant"() <{value = 31 : i64}> : () -> i64
  %277 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
  %278 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %279 = "llvm.mlir.constant"() <{value = 7 : i8}> : () -> i8
  %280 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %281 = "llvm.alloca"(%270) <{alignment = 8 : i64, elem_type = !llvm.array<40 x i8>}> : (i32) -> !llvm.ptr
  %282 = "llvm.alloca"(%270) <{alignment = 8 : i64, elem_type = !llvm.array<80 x i8>}> : (i32) -> !llvm.ptr
  %283 = "llvm.alloca"(%270) <{alignment = 8 : i64, elem_type = !llvm.array<40 x i8>}> : (i32) -> !llvm.ptr
  %284 = "llvm.alloca"(%270) <{alignment = 8 : i64, elem_type = !llvm.array<40 x i8>}> : (i32) -> !llvm.ptr
  %285 = "llvm.alloca"(%270) <{alignment = 8 : i64, elem_type = !llvm.array<40 x i8>}> : (i32) -> !llvm.ptr
  %286 = "llvm.alloca"(%270) <{alignment = 1 : i64, elem_type = !llvm.array<32 x i8>}> : (i32) -> !llvm.ptr
  %287 = "llvm.alloca"(%270) <{alignment = 8 : i64, elem_type = !llvm.array<80 x i8>}> : (i32) -> !llvm.ptr
  %288 = "llvm.alloca"(%270) <{alignment = 1 : i64, elem_type = !llvm.array<32 x i8>}> : (i32) -> !llvm.ptr
  %289 = "llvm.alloca"(%270) <{alignment = 8 : i64, elem_type = !llvm.array<160 x i8>}> : (i32) -> !llvm.ptr
  %290 = "llvm.alloca"(%270) <{alignment = 1 : i64, elem_type = !llvm.array<32 x i8>}> : (i32) -> !llvm.ptr
  %291 = "llvm.alloca"(%270) <{alignment = 8 : i64, elem_type = !llvm.array<168 x i8>}> : (i32) -> !llvm.ptr
  %292 = "llvm.alloca"(%270) <{alignment = 2 : i64, elem_type = !llvm.array<166 x i8>}> : (i32) -> !llvm.ptr
  %293 = "llvm.alloca"(%270) <{alignment = 2 : i64, elem_type = !llvm.array<166 x i8>}> : (i32) -> !llvm.ptr
  %294 = "llvm.alloca"(%270) <{alignment = 8 : i64, elem_type = !llvm.array<160 x i8>}> : (i32) -> !llvm.ptr
  %295 = "llvm.getelementptr"(%arg11) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %296 = "llvm.call"(%295) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvMsx_NtCs2JGgYtL0Fal_14solana_ed255197edwardsNtB5_12EdwardsPoint14is_small_order, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef, llvm.zeroext}]}> : (!llvm.ptr) -> i1
  "llvm.cond_br"(%296, %272)[^bb8, ^bb1] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i8) -> ()
^bb1:  // pred: ^bb0
  "llvm.intr.lifetime.start"(%294) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%293) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%292) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%291) : (!llvm.ptr) -> ()
  "llvm.call"(%291, %arg12) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 168 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.dereferenceable = 32 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvMs2_NtCs2JGgYtL0Fal_14solana_ed255197edwardsNtB5_18CompressedEdwardsY10decompress, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %297 = "llvm.load"(%291) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %298 = "llvm.trunc"(%297) <{overflowFlags = 2 : i32}> : (i64) -> i1
  "llvm.cond_br"(%298)[^bb2, ^bb3] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb2:  // pred: ^bb1
  %299 = "llvm.getelementptr"(%291) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %300 = "llvm.getelementptr"(%292) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memcpy"(%300, %299, %273) <{arg_attrs = [{llvm.align = 2 : i64, llvm.dereferenceable = 160 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 160 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.intr.lifetime.end"(%291) : (!llvm.ptr) -> ()
  %301 = "llvm.getelementptr"(%293) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memcpy"(%301, %300, %273) <{arg_attrs = [{llvm.align = 2 : i64, llvm.dereferenceable = 160 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 2 : i64, llvm.dereferenceable = 160 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.intr.lifetime.end"(%292) : (!llvm.ptr) -> ()
  "llvm.intr.memcpy"(%294, %301, %273) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 160 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 2 : i64, llvm.dereferenceable = 160 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.intr.lifetime.end"(%293) : (!llvm.ptr) -> ()
  %302 = "llvm.call"(%294) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvMsx_NtCs2JGgYtL0Fal_14solana_ed255197edwardsNtB5_12EdwardsPoint14is_small_order, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef, llvm.zeroext}]}> : (!llvm.ptr) -> i1
  "llvm.cond_br"(%302, %272)[^bb7, ^bb4] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i8) -> ()
^bb3:  // pred: ^bb1
  "llvm.intr.lifetime.end"(%291) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%292) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%293) : (!llvm.ptr) -> ()
  "llvm.br"(%272)[^bb7] : (i8) -> ()
^bb4:  // pred: ^bb2
  "llvm.intr.lifetime.start"(%290) : (!llvm.ptr) -> ()
  %303 = "llvm.getelementptr"(%arg12) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.experimental.noalias.scope.decl"() <{scope = #alias_scope67}> : () -> ()
  "llvm.intr.experimental.noalias.scope.decl"() <{scope = #alias_scope68}> : () -> ()
  %304 = "llvm.getelementptr"(%arg12) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 63>}> : (!llvm.ptr) -> !llvm.ptr
  %305 = "llvm.load"(%304) <{alias_scopes = [#alias_scope68], alignment = 1 : i64, noalias_scopes = [#alias_scope67], ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %306 = "llvm.icmp"(%305, %274) <{predicate = 4 : i64}> : (i8, i8) -> i1
  %307 = "llvm.zext"(%306) : (i1) -> i8
  %308 = "llvm.call"(%307) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  "llvm.intr.lifetime.start"(%288) : (!llvm.ptr) -> ()
  "llvm.call"(%288, %303) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 1 : i64, llvm.dereferenceable = 32 : i64, llvm.noalias, llvm.nofree, llvm.noundef}, {llvm.align = 1 : i64, llvm.dereferenceable = 32 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvMso_NtCs2JGgYtL0Fal_14solana_ed255196scalarNtB5_6Scalar6reduce, fastmathFlags = #llvm.fastmath<none>, noalias_scopes = [#alias_scope67], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %309 = "llvm.call"(%303, %288) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 1 : i64, llvm.dereferenceable = 32 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.dereferenceable = 32 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvXs8_Cs3X6wZJE6GDg_6subtleShNtB5_14ConstantTimeEq5ct_eqCs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, inline_hint, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope67], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>, res_attrs = [{llvm.noundef}]}> : (!llvm.ptr, !llvm.ptr) -> i8
  "llvm.intr.lifetime.end"(%288) : (!llvm.ptr) -> ()
  %310 = "llvm.and"(%309, %308) : (i8, i8) -> i8
  %311 = "llvm.call"(%310) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %312 = "llvm.icmp"(%311, %275) <{predicate = 0 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%312)[^bb5, ^bb6] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb5:  // pred: ^bb4
  %313 = "llvm.getelementptr"(%arg12) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 33>}> : (!llvm.ptr) -> !llvm.ptr
  %314 = "llvm.load"(%303) <{alias_scopes = [#alias_scope67, #alias_scope68], alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %315 = "llvm.getelementptr"(%290) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memcpy"(%315, %313, %276) <{arg_attrs = [{llvm.align = 1 : i64, llvm.dereferenceable = 31 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 1 : i64, llvm.dereferenceable = 31 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.store"(%314, %290) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%289) : (!llvm.ptr) -> ()
  "llvm.call"(%289, %arg13, %295, %290) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.dereferenceable = 32 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.dereferenceable = 32 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvNtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial10scalar_mul19vartime_double_base3mul, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%287) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%285) : (!llvm.ptr) -> ()
  %316 = "llvm.getelementptr"(%289) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 80>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%282) : (!llvm.ptr) -> ()
  "llvm.call"(%282, %316) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 80 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvMs2_NtCs2JGgYtL0Fal_14solana_ed255195fieldNtNtNtNtNtB7_7backend6serial3u645field14FieldElement518pow22501, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope69, #alias_scope70, #alias_scope71], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%284) : (!llvm.ptr) -> ()
  "llvm.intr.memcpy"(%284, %282, %277) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false, noalias_scopes = [#alias_scope69, #alias_scope72, #alias_scope70, #alias_scope71, #alias_scope73]}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.intr.lifetime.start"(%283) : (!llvm.ptr) -> ()
  %317 = "llvm.getelementptr"(%282) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memcpy"(%283, %317, %277) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false, noalias_scopes = [#alias_scope69, #alias_scope72, #alias_scope70, #alias_scope71, #alias_scope73]}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.intr.lifetime.end"(%282) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%281) : (!llvm.ptr) -> ()
  "llvm.call"(%281, %284, %278) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.noundef}], callee = @_RNvMs8_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldNtB5_14FieldElement515pow2k, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope69, #alias_scope72, #alias_scope70, #alias_scope71, #alias_scope73], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> ()
  "llvm.call"(%285, %281, %283) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvXs5_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldRNtB5_14FieldElement51NtNtNtCsgxBkk5gSRhY_4core3ops5arith3Mul3mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope72, #alias_scope70, #alias_scope71, #alias_scope73], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%281) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%283) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%284) : (!llvm.ptr) -> ()
  "llvm.call"(%287, %289, %285) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 80 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvXs5_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldRNtB5_14FieldElement51NtNtNtCsgxBkk5gSRhY_4core3ops5arith3Mul3mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope71], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  %318 = "llvm.getelementptr"(%289) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  %319 = "llvm.getelementptr"(%287) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%319, %318, %285) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvXs5_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldRNtB5_14FieldElement51NtNtNtCsgxBkk5gSRhY_4core3ops5arith3Mul3mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope71], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%285) : (!llvm.ptr) -> ()
  "llvm.call"(%286, %319) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 1 : i64, llvm.dereferenceable = 32 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvMs8_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldNtB5_14FieldElement518to_bytes, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %320 = "llvm.call"(%287) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvMs2_NtCs2JGgYtL0Fal_14solana_ed255195fieldNtNtNtNtNtB7_7backend6serial3u645field14FieldElement5111is_negative, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope71, #alias_scope73], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (!llvm.ptr) -> i8
  %321 = "llvm.shl"(%320, %279) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  %322 = "llvm.getelementptr"(%286) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 31>}> : (!llvm.ptr) -> !llvm.ptr
  %323 = "llvm.load"(%322) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %324 = "llvm.xor"(%323, %321) : (i8, i8) -> i8
  "llvm.store"(%324, %322) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%287) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%289) : (!llvm.ptr) -> ()
  %325 = "llvm.call"(%286, %arg12, %271) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.dereferenceable = 32 : i64, llvm.nonnull, llvm.noundef}, {llvm.dereferenceable = 32 : i64, llvm.nonnull, llvm.noundef}, {}], callee = @bcmp, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> i32
  %326 = "llvm.icmp"(%325, %280) <{predicate = 0 : i64}> : (i32, i32) -> i1
  %327 = "llvm.select"(%326, %274, %272) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i8, i8) -> i8
  "llvm.intr.lifetime.end"(%290) : (!llvm.ptr) -> ()
  "llvm.br"(%327)[^bb7] : (i8) -> ()
^bb6:  // pred: ^bb4
  "llvm.intr.lifetime.end"(%290) : (!llvm.ptr) -> ()
  "llvm.br"(%272)[^bb7] : (i8) -> ()
^bb7(%328: i8):  // 4 preds: ^bb2, ^bb3, ^bb5, ^bb6
  "llvm.intr.lifetime.end"(%294) : (!llvm.ptr) -> ()
  "llvm.br"(%328)[^bb8] : (i8) -> ()
^bb8(%329: i8):  // 2 preds: ^bb0, ^bb7
  "llvm.return"(%329) : (i8) -> ()
}) : () -> ()
  with @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519 := black_box_u8,
    @_RNvMs2_NtCs2JGgYtL0Fal_14solana_ed255195fieldNtNtNtNtNtB7_7backend6serial3u645field14FieldElement5111is_negative := FieldElement51_is_negative,
    @_RNvMs2_NtCs2JGgYtL0Fal_14solana_ed255195fieldNtNtNtNtNtB7_7backend6serial3u645field14FieldElement518pow22501 := FieldElement51_pow22501,
    @_RNvMs2_NtCs2JGgYtL0Fal_14solana_ed255197edwardsNtB5_18CompressedEdwardsY10decompress := CompressedEdwardsY_decompress,
    @_RNvMs8_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldNtB5_14FieldElement515pow2k := FieldElement51_pow2k,
    @_RNvMs8_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldNtB5_14FieldElement518to_bytes := FieldElement51_to_bytes,
    @_RNvMso_NtCs2JGgYtL0Fal_14solana_ed255196scalarNtB5_6Scalar6reduce := Scalar_reduce,
    @_RNvMsx_NtCs2JGgYtL0Fal_14solana_ed255197edwardsNtB5_12EdwardsPoint14is_small_order := EdwardsPoint_is_small_order,
    @_RNvNtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial10scalar_mul19vartime_double_base3mul := mul,
    @_RNvXs5_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldRNtB5_14FieldElement51NtNtNtCsgxBkk5gSRhY_4core3ops5arith3Mul3mul := FieldElement51_Mul_mul,
    @_RNvXs8_Cs3X6wZJE6GDg_6subtleShNtB5_14ConstantTimeEq5ct_eqCs2JGgYtL0Fal_14solana_ed25519 := slice_u8_ConstantTimeEq_ct_eq

end

end MLIR.Agave.Serial
