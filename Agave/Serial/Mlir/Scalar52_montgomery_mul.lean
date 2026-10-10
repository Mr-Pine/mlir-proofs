module

-- agave-build/out/serial-noinline/op/_RNvMs2_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar5214montgomery_mul.mlir
-- <solana_ed25519[1fe0933b11699477]::backend::serial::u64::scalar::Scalar52>::montgomery_mul

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Agave.Serial.Mlir.Scalar52_sub

meta import MLIR.Semantics.Func
meta import Agave.Serial.Mlir.Scalar52_sub

namespace MLIR.Agave.Serial

@[expose] public section

mlir_def Scalar52_montgomery_mul :=
#alias_scope_domain69 = #llvm.alias_scope_domain<id = distinct[69]<>, description = "_RNvMs2_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar5212mul_internal">
#alias_scope_domain70 = #llvm.alias_scope_domain<id = distinct[70]<>, description = "_RNvMs2_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar5217montgomery_reduce">
#alias_scope_domain71 = #llvm.alias_scope_domain<id = distinct[71]<>, description = "_RNvXCshxoft6be3N1_7zeroizeoNtB2_7Zeroize7zeroizeCs2JGgYtL0Fal_14solana_ed25519">
#alias_scope_domain72 = #llvm.alias_scope_domain<id = distinct[72]<>, description = "_RNvXs4_Cshxoft6be3N1_7zeroizeINtNtNtCsgxBkk5gSRhY_4core5slice4iter7IterMutoENtB5_7Zeroize7zeroizeCs2JGgYtL0Fal_14solana_ed25519">
#alias_scope133 = #llvm.alias_scope<id = distinct[229]<>, domain = #alias_scope_domain69, description = "_RNvMs2_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar5212mul_internal: argument 0">
#alias_scope134 = #llvm.alias_scope<id = distinct[230]<>, domain = #alias_scope_domain69, description = "_RNvMs2_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar5212mul_internal: argument 1">
#alias_scope135 = #llvm.alias_scope<id = distinct[231]<>, domain = #alias_scope_domain69, description = "_RNvMs2_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar5212mul_internal: argument 2">
#alias_scope136 = #llvm.alias_scope<id = distinct[232]<>, domain = #alias_scope_domain70, description = "_RNvMs2_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar5217montgomery_reduce: argument 0">
#alias_scope137 = #llvm.alias_scope<id = distinct[233]<>, domain = #alias_scope_domain70, description = "_RNvMs2_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar5217montgomery_reduce: argument 1">
#alias_scope138 = #llvm.alias_scope<id = distinct[234]<>, domain = #alias_scope_domain71, description = "_RNvXCshxoft6be3N1_7zeroizeoNtB2_7Zeroize7zeroizeCs2JGgYtL0Fal_14solana_ed25519: argument 0">
#alias_scope139 = #llvm.alias_scope<id = distinct[235]<>, domain = #alias_scope_domain72, description = "_RNvXs4_Cshxoft6be3N1_7zeroizeINtNtNtCsgxBkk5gSRhY_4core5slice4iter7IterMutoENtB5_7Zeroize7zeroizeCs2JGgYtL0Fal_14solana_ed25519: argument 0">
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 8 : i64, llvm.dead_on_unwind, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writable, llvm.writeonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], sym_name = "_RNvMs2_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar5214montgomery_mul", target_cpu = "x86-64-v2", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg25: !llvm.ptr, %arg26: !llvm.ptr, %arg27: !llvm.ptr):
  %295 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %296 = "llvm.mlir.constant"() <{value = 1439961107955227 : i64}> : () -> i64
  %297 = "llvm.mlir.constant"() <{value = 4503599627370495 : i64}> : () -> i64
  %298 = "llvm.mlir.constant"() <{value = 671914833335277 : i128}> : () -> i128
  %299 = "llvm.mlir.constant"() <{value = 52 : i128}> : () -> i128
  %300 = "llvm.mlir.constant"() <{value = 3916664325105025 : i128}> : () -> i128
  %301 = "llvm.mlir.constant"() <{value = 1367801 : i128}> : () -> i128
  %302 = "llvm.mlir.constant"() <{value = 44 : i128}> : () -> i128
  %303 = "llvm.mlir.constant"() <{value = 0 : i128}> : () -> i128
  %304 = "llvm.alloca"(%295) <{alignment = 8 : i64, elem_type = !llvm.array<40 x i8>}> : (i32) -> !llvm.ptr
  %305 = "llvm.alloca"(%295) <{alignment = 16 : i64, elem_type = i128}> : (i32) -> !llvm.ptr
  %306 = "llvm.alloca"(%295) <{alignment = 16 : i64, elem_type = i128}> : (i32) -> !llvm.ptr
  %307 = "llvm.alloca"(%295) <{alignment = 16 : i64, elem_type = i128}> : (i32) -> !llvm.ptr
  %308 = "llvm.alloca"(%295) <{alignment = 16 : i64, elem_type = i128}> : (i32) -> !llvm.ptr
  %309 = "llvm.alloca"(%295) <{alignment = 16 : i64, elem_type = i128}> : (i32) -> !llvm.ptr
  %310 = "llvm.alloca"(%295) <{alignment = 16 : i64, elem_type = i128}> : (i32) -> !llvm.ptr
  %311 = "llvm.alloca"(%295) <{alignment = 16 : i64, elem_type = i128}> : (i32) -> !llvm.ptr
  %312 = "llvm.alloca"(%295) <{alignment = 16 : i64, elem_type = i128}> : (i32) -> !llvm.ptr
  %313 = "llvm.alloca"(%295) <{alignment = 16 : i64, elem_type = i128}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%305) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%306) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%307) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%308) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%309) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%310) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%311) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%312) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%313) : (!llvm.ptr) -> ()
  "llvm.intr.experimental.noalias.scope.decl"() <{scope = #alias_scope133}> : () -> ()
  "llvm.intr.experimental.noalias.scope.decl"() <{scope = #alias_scope134}> : () -> ()
  "llvm.intr.experimental.noalias.scope.decl"() <{scope = #alias_scope135}> : () -> ()
  %314 = "llvm.load"(%arg26) <{alias_scopes = [#alias_scope134], alignment = 8 : i64, noalias_scopes = [#alias_scope133, #alias_scope135], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %315 = "llvm.load"(%arg27) <{alias_scopes = [#alias_scope135], alignment = 8 : i64, noalias_scopes = [#alias_scope133, #alias_scope134], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %316 = "llvm.zext"(%314) : (i64) -> i128
  %317 = "llvm.zext"(%315) : (i64) -> i128
  %318 = "llvm.mul"(%317, %316) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %319 = "llvm.getelementptr"(%arg27) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %320 = "llvm.load"(%319) <{alias_scopes = [#alias_scope135], alignment = 8 : i64, noalias_scopes = [#alias_scope133, #alias_scope134], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %321 = "llvm.zext"(%320) : (i64) -> i128
  %322 = "llvm.mul"(%321, %316) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %323 = "llvm.getelementptr"(%arg26) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %324 = "llvm.load"(%323) <{alias_scopes = [#alias_scope134], alignment = 8 : i64, noalias_scopes = [#alias_scope133, #alias_scope135], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %325 = "llvm.zext"(%324) : (i64) -> i128
  %326 = "llvm.mul"(%325, %317) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %327 = "llvm.add"(%326, %322) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  "llvm.store"(%327, %306) <{alias_scopes = [#alias_scope133], alignment = 16 : i64, noalias_scopes = [#alias_scope134, #alias_scope135], ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
  %328 = "llvm.getelementptr"(%arg27) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %329 = "llvm.load"(%328) <{alias_scopes = [#alias_scope135], alignment = 8 : i64, noalias_scopes = [#alias_scope133, #alias_scope134], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %330 = "llvm.zext"(%329) : (i64) -> i128
  %331 = "llvm.mul"(%330, %316) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %332 = "llvm.mul"(%325, %321) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %333 = "llvm.add"(%331, %332) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %334 = "llvm.getelementptr"(%arg26) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %335 = "llvm.load"(%334) <{alias_scopes = [#alias_scope134], alignment = 8 : i64, noalias_scopes = [#alias_scope133, #alias_scope135], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %336 = "llvm.zext"(%335) : (i64) -> i128
  %337 = "llvm.mul"(%336, %317) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %338 = "llvm.add"(%333, %337) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  "llvm.store"(%338, %307) <{alias_scopes = [#alias_scope133], alignment = 16 : i64, noalias_scopes = [#alias_scope134, #alias_scope135], ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
  %339 = "llvm.getelementptr"(%arg27) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %340 = "llvm.load"(%339) <{alias_scopes = [#alias_scope135], alignment = 8 : i64, noalias_scopes = [#alias_scope133, #alias_scope134], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %341 = "llvm.zext"(%340) : (i64) -> i128
  %342 = "llvm.mul"(%341, %316) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %343 = "llvm.mul"(%330, %325) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %344 = "llvm.mul"(%336, %321) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %345 = "llvm.getelementptr"(%arg26) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %346 = "llvm.load"(%345) <{alias_scopes = [#alias_scope134], alignment = 8 : i64, noalias_scopes = [#alias_scope133, #alias_scope135], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %347 = "llvm.zext"(%346) : (i64) -> i128
  %348 = "llvm.mul"(%347, %317) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %349 = "llvm.add"(%344, %343) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %350 = "llvm.add"(%349, %342) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %351 = "llvm.add"(%350, %348) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  "llvm.store"(%351, %308) <{alias_scopes = [#alias_scope133], alignment = 16 : i64, noalias_scopes = [#alias_scope134, #alias_scope135], ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
  %352 = "llvm.getelementptr"(%arg27) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %353 = "llvm.load"(%352) <{alias_scopes = [#alias_scope135], alignment = 8 : i64, noalias_scopes = [#alias_scope133, #alias_scope134], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %354 = "llvm.zext"(%353) : (i64) -> i128
  %355 = "llvm.mul"(%354, %316) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %356 = "llvm.mul"(%341, %325) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %357 = "llvm.mul"(%336, %330) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %358 = "llvm.mul"(%347, %321) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %359 = "llvm.getelementptr"(%arg26) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %360 = "llvm.load"(%359) <{alias_scopes = [#alias_scope134], alignment = 8 : i64, noalias_scopes = [#alias_scope133, #alias_scope135], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %361 = "llvm.zext"(%360) : (i64) -> i128
  %362 = "llvm.mul"(%361, %317) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %363 = "llvm.add"(%356, %357) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %364 = "llvm.add"(%363, %358) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %365 = "llvm.add"(%364, %355) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %366 = "llvm.add"(%365, %362) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  "llvm.store"(%366, %309) <{alias_scopes = [#alias_scope133], alignment = 16 : i64, noalias_scopes = [#alias_scope134, #alias_scope135], ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
  %367 = "llvm.mul"(%354, %325) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %368 = "llvm.mul"(%341, %336) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %369 = "llvm.mul"(%347, %330) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %370 = "llvm.mul"(%361, %321) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %371 = "llvm.add"(%369, %368) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %372 = "llvm.add"(%371, %367) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %373 = "llvm.add"(%372, %370) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  "llvm.store"(%373, %310) <{alias_scopes = [#alias_scope133], alignment = 16 : i64, noalias_scopes = [#alias_scope134, #alias_scope135], ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
  %374 = "llvm.mul"(%354, %336) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %375 = "llvm.mul"(%347, %341) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %376 = "llvm.add"(%374, %375) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %377 = "llvm.mul"(%361, %330) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %378 = "llvm.add"(%376, %377) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  "llvm.store"(%378, %311) <{alias_scopes = [#alias_scope133], alignment = 16 : i64, noalias_scopes = [#alias_scope134, #alias_scope135], ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
  %379 = "llvm.mul"(%354, %347) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %380 = "llvm.mul"(%361, %341) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %381 = "llvm.add"(%380, %379) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  "llvm.store"(%381, %312) <{alias_scopes = [#alias_scope133], alignment = 16 : i64, noalias_scopes = [#alias_scope134, #alias_scope135], ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
  %382 = "llvm.mul"(%361, %354) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  "llvm.store"(%382, %313) <{alias_scopes = [#alias_scope133], alignment = 16 : i64, noalias_scopes = [#alias_scope134, #alias_scope135], ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
  %383 = "llvm.trunc"(%318) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %384 = "llvm.mul"(%383, %296) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %385 = "llvm.and"(%384, %297) : (i64, i64) -> i64
  %386 = "llvm.zext"(%385) <{nonNeg}> : (i64) -> i128
  %387 = "llvm.mul"(%386, %298) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %388 = "llvm.add"(%387, %318) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %389 = "llvm.lshr"(%388, %299) : (i128, i128) -> i128
  %390 = "llvm.mul"(%386, %300) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %391 = "llvm.add"(%390, %327) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %392 = "llvm.add"(%391, %389) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %393 = "llvm.trunc"(%392) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %394 = "llvm.mul"(%393, %296) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %395 = "llvm.and"(%394, %297) : (i64, i64) -> i64
  %396 = "llvm.zext"(%395) <{nonNeg}> : (i64) -> i128
  %397 = "llvm.mul"(%396, %298) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %398 = "llvm.add"(%397, %392) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %399 = "llvm.lshr"(%398, %299) : (i128, i128) -> i128
  %400 = "llvm.mul"(%386, %301) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %401 = "llvm.mul"(%396, %300) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %402 = "llvm.add"(%338, %400) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %403 = "llvm.add"(%402, %401) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %404 = "llvm.add"(%403, %399) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %405 = "llvm.trunc"(%404) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %406 = "llvm.mul"(%405, %296) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %407 = "llvm.and"(%406, %297) : (i64, i64) -> i64
  %408 = "llvm.zext"(%407) <{nonNeg}> : (i64) -> i128
  %409 = "llvm.mul"(%408, %298) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %410 = "llvm.add"(%409, %404) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %411 = "llvm.lshr"(%410, %299) : (i128, i128) -> i128
  %412 = "llvm.mul"(%396, %301) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %413 = "llvm.mul"(%408, %300) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %414 = "llvm.add"(%412, %351) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %415 = "llvm.add"(%414, %413) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %416 = "llvm.add"(%415, %411) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %417 = "llvm.trunc"(%416) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %418 = "llvm.mul"(%417, %296) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %419 = "llvm.and"(%418, %297) : (i64, i64) -> i64
  %420 = "llvm.zext"(%419) <{nonNeg}> : (i64) -> i128
  %421 = "llvm.mul"(%420, %298) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %422 = "llvm.add"(%421, %416) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %423 = "llvm.lshr"(%422, %299) : (i128, i128) -> i128
  %424 = "llvm.shl"(%386, %302) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %425 = "llvm.mul"(%408, %301) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %426 = "llvm.mul"(%420, %300) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %427 = "llvm.add"(%366, %424) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %428 = "llvm.add"(%427, %425) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %429 = "llvm.add"(%428, %426) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %430 = "llvm.add"(%429, %423) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %431 = "llvm.trunc"(%430) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %432 = "llvm.mul"(%431, %296) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %433 = "llvm.and"(%432, %297) : (i64, i64) -> i64
  %434 = "llvm.zext"(%433) <{nonNeg}> : (i64) -> i128
  %435 = "llvm.mul"(%434, %298) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %436 = "llvm.add"(%435, %430) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %437 = "llvm.lshr"(%436, %299) : (i128, i128) -> i128
  %438 = "llvm.shl"(%396, %302) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %439 = "llvm.mul"(%420, %301) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %440 = "llvm.mul"(%434, %300) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %441 = "llvm.add"(%438, %373) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %442 = "llvm.add"(%441, %439) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %443 = "llvm.add"(%442, %440) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %444 = "llvm.add"(%443, %437) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %445 = "llvm.trunc"(%444) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %446 = "llvm.and"(%445, %297) : (i64, i64) -> i64
  %447 = "llvm.lshr"(%444, %299) : (i128, i128) -> i128
  %448 = "llvm.shl"(%408, %302) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %449 = "llvm.mul"(%434, %301) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %450 = "llvm.add"(%448, %378) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %451 = "llvm.add"(%450, %449) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %452 = "llvm.add"(%451, %447) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %453 = "llvm.trunc"(%452) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %454 = "llvm.and"(%453, %297) : (i64, i64) -> i64
  %455 = "llvm.lshr"(%452, %299) : (i128, i128) -> i128
  %456 = "llvm.shl"(%420, %302) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %457 = "llvm.add"(%456, %381) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %458 = "llvm.add"(%457, %455) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %459 = "llvm.trunc"(%458) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %460 = "llvm.and"(%459, %297) : (i64, i64) -> i64
  %461 = "llvm.lshr"(%458, %299) : (i128, i128) -> i128
  %462 = "llvm.shl"(%434, %302) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %463 = "llvm.add"(%462, %382) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %464 = "llvm.add"(%463, %461) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %465 = "llvm.trunc"(%464) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %466 = "llvm.and"(%465, %297) : (i64, i64) -> i64
  %467 = "llvm.lshr"(%464, %299) : (i128, i128) -> i128
  %468 = "llvm.trunc"(%467) <{overflowFlags = 0 : i32}> : (i128) -> i64
  "llvm.intr.lifetime.start"(%304) : (!llvm.ptr) -> ()
  "llvm.store"(%446, %304) <{alignment = 8 : i64, noalias_scopes = [#alias_scope136, #alias_scope137], ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %469 = "llvm.getelementptr"(%304) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%454, %469) <{alignment = 8 : i64, noalias_scopes = [#alias_scope136, #alias_scope137], ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %470 = "llvm.getelementptr"(%304) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%460, %470) <{alignment = 8 : i64, noalias_scopes = [#alias_scope136, #alias_scope137], ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %471 = "llvm.getelementptr"(%304) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%466, %471) <{alignment = 8 : i64, noalias_scopes = [#alias_scope136, #alias_scope137], ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %472 = "llvm.getelementptr"(%304) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%468, %472) <{alignment = 8 : i64, noalias_scopes = [#alias_scope136, #alias_scope137], ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.call"(%arg25, %304) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvMs2_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar523sub, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%304) : (!llvm.ptr) -> ()
  "llvm.store"(%303, %305) <{alias_scopes = [#alias_scope138], alignment = 16 : i64, noalias_scopes = [#alias_scope139], ordering = 0 : i64, volatile_}> : (i128, !llvm.ptr) -> ()
  "llvm.fence"() <{ordering = 7 : i64, syncscope = "singlethread"}> : () -> ()
  "llvm.store"(%303, %306) <{alias_scopes = [#alias_scope138], alignment = 16 : i64, noalias_scopes = [#alias_scope139], ordering = 0 : i64, volatile_}> : (i128, !llvm.ptr) -> ()
  "llvm.fence"() <{ordering = 7 : i64, syncscope = "singlethread"}> : () -> ()
  "llvm.store"(%303, %307) <{alias_scopes = [#alias_scope138], alignment = 16 : i64, noalias_scopes = [#alias_scope139], ordering = 0 : i64, volatile_}> : (i128, !llvm.ptr) -> ()
  "llvm.fence"() <{ordering = 7 : i64, syncscope = "singlethread"}> : () -> ()
  "llvm.store"(%303, %308) <{alias_scopes = [#alias_scope138], alignment = 16 : i64, noalias_scopes = [#alias_scope139], ordering = 0 : i64, volatile_}> : (i128, !llvm.ptr) -> ()
  "llvm.fence"() <{ordering = 7 : i64, syncscope = "singlethread"}> : () -> ()
  "llvm.store"(%303, %309) <{alias_scopes = [#alias_scope138], alignment = 16 : i64, noalias_scopes = [#alias_scope139], ordering = 0 : i64, volatile_}> : (i128, !llvm.ptr) -> ()
  "llvm.fence"() <{ordering = 7 : i64, syncscope = "singlethread"}> : () -> ()
  "llvm.store"(%303, %310) <{alias_scopes = [#alias_scope138], alignment = 16 : i64, noalias_scopes = [#alias_scope139], ordering = 0 : i64, volatile_}> : (i128, !llvm.ptr) -> ()
  "llvm.fence"() <{ordering = 7 : i64, syncscope = "singlethread"}> : () -> ()
  "llvm.store"(%303, %311) <{alias_scopes = [#alias_scope138], alignment = 16 : i64, noalias_scopes = [#alias_scope139], ordering = 0 : i64, volatile_}> : (i128, !llvm.ptr) -> ()
  "llvm.fence"() <{ordering = 7 : i64, syncscope = "singlethread"}> : () -> ()
  "llvm.store"(%303, %312) <{alias_scopes = [#alias_scope138], alignment = 16 : i64, noalias_scopes = [#alias_scope139], ordering = 0 : i64, volatile_}> : (i128, !llvm.ptr) -> ()
  "llvm.fence"() <{ordering = 7 : i64, syncscope = "singlethread"}> : () -> ()
  "llvm.store"(%303, %313) <{alias_scopes = [#alias_scope138], alignment = 16 : i64, noalias_scopes = [#alias_scope139], ordering = 0 : i64, volatile_}> : (i128, !llvm.ptr) -> ()
  "llvm.fence"() <{ordering = 7 : i64, syncscope = "singlethread"}> : () -> ()
  "llvm.intr.lifetime.end"(%305) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%306) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%307) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%308) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%309) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%310) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%311) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%312) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%313) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
  with
    @_RNvMs2_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar523sub := Scalar52_sub

end

end MLIR.Agave.Serial
