module

-- agave-build/out/avx2-noinline-big/op/_RNvMs1_Cs2NreSqHKWrm_16solana_signatureNtB5_9Signature14verify_verbose.mlir
-- <solana_signature[20954975793ced0a]::Signature>::verify_verbose

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Agave.Avx2.Mlir.Sha512_Update_chain_slice_u8
public import Agave.Avx2.Mlir.CompressedEdwardsY_decompress
public import Agave.Avx2.Mlir.VerificationKey_verify_dalek_prehashed
public import Agave.Avx2.Mlir.scalar_from_sha512
public import Agave.Avx2.Mlir.FieldElement51_Neg_neg
public import Agave.Serial.Mlir.anon_042b818bc72209407b52bd0e4d6c8368_139

meta import MLIR.Semantics.Func
meta import Agave.Avx2.Mlir.Sha512_Update_chain_slice_u8
meta import Agave.Avx2.Mlir.CompressedEdwardsY_decompress
meta import Agave.Avx2.Mlir.VerificationKey_verify_dalek_prehashed
meta import Agave.Avx2.Mlir.scalar_from_sha512
meta import Agave.Avx2.Mlir.FieldElement51_Neg_neg
meta import Agave.Serial.Mlir.anon_042b818bc72209407b52bd0e4d6c8368_139

namespace MLIR.Agave.Avx2

@[expose] public section

noncomputable mlir_def Signature_verify_verbose :=
#alias_scope_domain117 = #llvm.alias_scope_domain<id = distinct[117]<>, description = "_RNvXs9_NtNtCsh8hPzWUDumX_14solana_ed255197ed_sigs16verification_keyNtB5_15VerificationKeyINtNtCsgxBkk5gSRhY_4core7convert7TryFromRShE8try_from">
#alias_scope_domain118 = #llvm.alias_scope_domain<id = distinct[118]<>, description = "_RNvXs0_NtNtCsh8hPzWUDumX_14solana_ed255197ed_sigs16verification_keyNtB5_20VerificationKeyBytesINtNtCsgxBkk5gSRhY_4core7convert7TryFromRShE8try_from">
#alias_scope_domain119 = #llvm.alias_scope_domain<id = distinct[119]<>, description = "_RNvXs8_NtNtCsh8hPzWUDumX_14solana_ed255197ed_sigs16verification_keyNtB5_15VerificationKeyINtNtCsgxBkk5gSRhY_4core7convert7TryFromNtB5_20VerificationKeyBytesE8try_from">
#alias_scope_domain120 = #llvm.alias_scope_domain<id = distinct[120]<>, description = "_RNvXsn_NtCsh8hPzWUDumX_14solana_ed255197edwardsRNtB5_12EdwardsPointNtNtNtCsgxBkk5gSRhY_4core3ops5arith3Neg3neg">
#alias_scope_domain121 = #llvm.alias_scope_domain<id = distinct[121]<>, description = "_RNvXso_NtCsh8hPzWUDumX_14solana_ed255197edwardsNtB5_12EdwardsPointNtNtNtCsgxBkk5gSRhY_4core3ops5arith3Neg3neg">
#alias_scope_domain122 = #llvm.alias_scope_domain<id = distinct[122]<>, description = "_RINvNtCsgxBkk5gSRhY_4core5slice20copy_from_slice_implhECs70NsGw2SmwN_7ed25519">
#alias_scope_domain123 = #llvm.alias_scope_domain<id = distinct[123]<>, description = "_RNvMCs70NsGw2SmwN_7ed25519NtB2_9Signature10from_bytes">
#alias_scope_domain124 = #llvm.alias_scope_domain<id = distinct[124]<>, description = "_RNvXs2_Cs70NsGw2SmwN_7ed25519NtB5_9SignatureINtNtCsgxBkk5gSRhY_4core7convert4FromAhj40_E4from">
#alias_scope_domain125 = #llvm.alias_scope_domain<id = distinct[125]<>, description = "_RNvMCs70NsGw2SmwN_7ed25519NtB2_9Signature10from_slice">
#alias_scope_domain126 = #llvm.alias_scope_domain<id = distinct[126]<>, description = "_RNvMsc_NtNtCsh8hPzWUDumX_14solana_ed255197ed_sigs16verification_keyNtB5_15VerificationKey16challenge_scalar">
#alias_scope_domain127 = #llvm.alias_scope_domain<id = distinct[127]<>, description = "_RNvMsc_NtNtCsh8hPzWUDumX_14solana_ed255197ed_sigs16verification_keyNtB5_15VerificationKey12verify_dalek">
#alias_scope_domain128 = #llvm.alias_scope_domain<id = distinct[128]<>, description = "_RNvXsy_CsgIn12VVV7xy_4sha2NtB5_6Sha512NtNtCsgxBkk5gSRhY_4core7default7Default7default">
#alias_scope181 = #llvm.alias_scope<id = distinct[310]<>, domain = #alias_scope_domain117, description = "_RNvXs9_NtNtCsh8hPzWUDumX_14solana_ed255197ed_sigs16verification_keyNtB5_15VerificationKeyINtNtCsgxBkk5gSRhY_4core7convert7TryFromRShE8try_from: argument 1">
#alias_scope182 = #llvm.alias_scope<id = distinct[311]<>, domain = #alias_scope_domain118, description = "_RNvXs0_NtNtCsh8hPzWUDumX_14solana_ed255197ed_sigs16verification_keyNtB5_20VerificationKeyBytesINtNtCsgxBkk5gSRhY_4core7convert7TryFromRShE8try_from: argument 0">
#alias_scope183 = #llvm.alias_scope<id = distinct[312]<>, domain = #alias_scope_domain118, description = "_RNvXs0_NtNtCsh8hPzWUDumX_14solana_ed255197ed_sigs16verification_keyNtB5_20VerificationKeyBytesINtNtCsgxBkk5gSRhY_4core7convert7TryFromRShE8try_from: argument 1">
#alias_scope184 = #llvm.alias_scope<id = distinct[313]<>, domain = #alias_scope_domain117, description = "_RNvXs9_NtNtCsh8hPzWUDumX_14solana_ed255197ed_sigs16verification_keyNtB5_15VerificationKeyINtNtCsgxBkk5gSRhY_4core7convert7TryFromRShE8try_from: argument 0">
#alias_scope185 = #llvm.alias_scope<id = distinct[314]<>, domain = #alias_scope_domain119, description = "_RNvXs8_NtNtCsh8hPzWUDumX_14solana_ed255197ed_sigs16verification_keyNtB5_15VerificationKeyINtNtCsgxBkk5gSRhY_4core7convert7TryFromNtB5_20VerificationKeyBytesE8try_from: argument 0">
#alias_scope186 = #llvm.alias_scope<id = distinct[315]<>, domain = #alias_scope_domain119, description = "_RNvXs8_NtNtCsh8hPzWUDumX_14solana_ed255197ed_sigs16verification_keyNtB5_15VerificationKeyINtNtCsgxBkk5gSRhY_4core7convert7TryFromNtB5_20VerificationKeyBytesE8try_from: argument 1">
#alias_scope187 = #llvm.alias_scope<id = distinct[316]<>, domain = #alias_scope_domain120, description = "_RNvXsn_NtCsh8hPzWUDumX_14solana_ed255197edwardsRNtB5_12EdwardsPointNtNtNtCsgxBkk5gSRhY_4core3ops5arith3Neg3neg: argument 0">
#alias_scope188 = #llvm.alias_scope<id = distinct[317]<>, domain = #alias_scope_domain120, description = "_RNvXsn_NtCsh8hPzWUDumX_14solana_ed255197edwardsRNtB5_12EdwardsPointNtNtNtCsgxBkk5gSRhY_4core3ops5arith3Neg3neg: argument 1">
#alias_scope189 = #llvm.alias_scope<id = distinct[318]<>, domain = #alias_scope_domain121, description = "_RNvXso_NtCsh8hPzWUDumX_14solana_ed255197edwardsNtB5_12EdwardsPointNtNtNtCsgxBkk5gSRhY_4core3ops5arith3Neg3neg: argument 0">
#alias_scope190 = #llvm.alias_scope<id = distinct[319]<>, domain = #alias_scope_domain121, description = "_RNvXso_NtCsh8hPzWUDumX_14solana_ed255197edwardsNtB5_12EdwardsPointNtNtNtCsgxBkk5gSRhY_4core3ops5arith3Neg3neg: argument 1">
#alias_scope191 = #llvm.alias_scope<id = distinct[320]<>, domain = #alias_scope_domain122, description = "_RINvNtCsgxBkk5gSRhY_4core5slice20copy_from_slice_implhECs70NsGw2SmwN_7ed25519: argument 0">
#alias_scope192 = #llvm.alias_scope<id = distinct[321]<>, domain = #alias_scope_domain122, description = "_RINvNtCsgxBkk5gSRhY_4core5slice20copy_from_slice_implhECs70NsGw2SmwN_7ed25519: argument 1">
#alias_scope193 = #llvm.alias_scope<id = distinct[322]<>, domain = #alias_scope_domain123, description = "_RNvMCs70NsGw2SmwN_7ed25519NtB2_9Signature10from_bytes: argument 0">
#alias_scope194 = #llvm.alias_scope<id = distinct[323]<>, domain = #alias_scope_domain124, description = "_RNvXs2_Cs70NsGw2SmwN_7ed25519NtB5_9SignatureINtNtCsgxBkk5gSRhY_4core7convert4FromAhj40_E4from: argument 0">
#alias_scope195 = #llvm.alias_scope<id = distinct[324]<>, domain = #alias_scope_domain125, description = "_RNvMCs70NsGw2SmwN_7ed25519NtB2_9Signature10from_slice: argument 0">
#alias_scope196 = #llvm.alias_scope<id = distinct[325]<>, domain = #alias_scope_domain126, description = "_RNvMsc_NtNtCsh8hPzWUDumX_14solana_ed255197ed_sigs16verification_keyNtB5_15VerificationKey16challenge_scalar: argument 0">
#alias_scope197 = #llvm.alias_scope<id = distinct[326]<>, domain = #alias_scope_domain126, description = "_RNvMsc_NtNtCsh8hPzWUDumX_14solana_ed255197ed_sigs16verification_keyNtB5_15VerificationKey16challenge_scalar: argument 1">
#alias_scope198 = #llvm.alias_scope<id = distinct[327]<>, domain = #alias_scope_domain126, description = "_RNvMsc_NtNtCsh8hPzWUDumX_14solana_ed255197ed_sigs16verification_keyNtB5_15VerificationKey16challenge_scalar: argument 2">
#alias_scope199 = #llvm.alias_scope<id = distinct[328]<>, domain = #alias_scope_domain126, description = "_RNvMsc_NtNtCsh8hPzWUDumX_14solana_ed255197ed_sigs16verification_keyNtB5_15VerificationKey16challenge_scalar: argument 3">
#alias_scope200 = #llvm.alias_scope<id = distinct[329]<>, domain = #alias_scope_domain127, description = "_RNvMsc_NtNtCsh8hPzWUDumX_14solana_ed255197ed_sigs16verification_keyNtB5_15VerificationKey12verify_dalek: argument 0">
#alias_scope201 = #llvm.alias_scope<id = distinct[330]<>, domain = #alias_scope_domain127, description = "_RNvMsc_NtNtCsh8hPzWUDumX_14solana_ed255197ed_sigs16verification_keyNtB5_15VerificationKey12verify_dalek: argument 1">
#alias_scope202 = #llvm.alias_scope<id = distinct[331]<>, domain = #alias_scope_domain127, description = "_RNvMsc_NtNtCsh8hPzWUDumX_14solana_ed255197ed_sigs16verification_keyNtB5_15VerificationKey12verify_dalek: argument 2">
#alias_scope203 = #llvm.alias_scope<id = distinct[332]<>, domain = #alias_scope_domain128, description = "_RNvXsy_CsgIn12VVV7xy_4sha2NtB5_6Sha512NtNtCsgxBkk5gSRhY_4core7default7Default7default: argument 0">
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.dereferenceable = 64 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.noundef, llvm.range = #llvm.constant_range<i64, 0, -9223372036854775808>}], dso_local, function_type = !llvm.func<i8 (ptr, ptr, ptr, i64)>, linkage = #llvm.linkage<internal>, no_inline, passthrough = ["nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], personality = @rust_eh_personality, res_attrs = [{llvm.noundef, llvm.range = #llvm.constant_range<i8, -1, 3>}], sym_name = "_RNvMs1_Cs2NreSqHKWrm_16solana_signatureNtB5_9Signature14verify_verbose", target_cpu = "x86-64-v2", target_features = #llvm.target_features<["+avx", "+avx2", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+crc32", "+ssse3"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: !llvm.ptr, %arg3: i64):
  %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1 = "llvm.mlir.constant"() <{value = 31 : i64}> : () -> i64
  %2 = "llvm.mlir.constant"() <{value = 1 : i8}> : () -> i8
  %3 = "llvm.mlir.constant"() <{value = 160 : i64}> : () -> i64
  %4 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %5 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
  %6 = "llvm.mlir.constant"() <{value = 192 : i64}> : () -> i64
  %7 = "llvm.mlir.constant"() <{value = 63 : i64}> : () -> i64
  %8 = "llvm.mlir.addressof"() <{global_name = @anon.e79fcfe266c5706188f989b4d452749f.134}> : () -> !llvm.ptr
  %9 = "llvm.mlir.constant"() <{value = 64 : i64}> : () -> i64
  %10 = "llvm.mlir.constant"() <{value = 0 : i128}> : () -> i128
  %11 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %12 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.array<208 x i8>}> : (i32) -> !llvm.ptr
  %13 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.array<208 x i8>}> : (i32) -> !llvm.ptr
  %14 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.array<208 x i8>}> : (i32) -> !llvm.ptr
  %15 = "llvm.alloca"(%0) <{alignment = 16 : i64, elem_type = !llvm.array<208 x i8>}> : (i32) -> !llvm.ptr
  %16 = "llvm.alloca"(%0) <{alignment = 1 : i64, elem_type = !llvm.array<32 x i8>}> : (i32) -> !llvm.ptr
  %17 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.array<192 x i8>}> : (i32) -> !llvm.ptr
  %18 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.array<160 x i8>}> : (i32) -> !llvm.ptr
  %19 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.array<168 x i8>}> : (i32) -> !llvm.ptr
  %20 = "llvm.alloca"(%0) <{alignment = 2 : i64, elem_type = !llvm.array<166 x i8>}> : (i32) -> !llvm.ptr
  %21 = "llvm.alloca"(%0) <{alignment = 2 : i64, elem_type = !llvm.array<166 x i8>}> : (i32) -> !llvm.ptr
  %22 = "llvm.alloca"(%0) <{alignment = 1 : i64, elem_type = !llvm.array<32 x i8>}> : (i32) -> !llvm.ptr
  %23 = "llvm.alloca"(%0) <{alignment = 1 : i64, elem_type = !llvm.array<63 x i8>}> : (i32) -> !llvm.ptr
  %24 = "llvm.alloca"(%0) <{alignment = 1 : i64, elem_type = !llvm.array<64 x i8>}> : (i32) -> !llvm.ptr
  %25 = "llvm.alloca"(%0) <{alignment = 2 : i64, elem_type = !llvm.array<198 x i8>}> : (i32) -> !llvm.ptr
  %26 = "llvm.alloca"(%0) <{alignment = 2 : i64, elem_type = !llvm.array<198 x i8>}> : (i32) -> !llvm.ptr
  %27 = "llvm.alloca"(%0) <{alignment = 8 : i64, elem_type = !llvm.array<192 x i8>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%27) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%26) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%25) : (!llvm.ptr) -> ()
  "llvm.intr.experimental.noalias.scope.decl"() <{scope = #alias_scope181}> : () -> ()
  %28 = "llvm.load"(%arg1) <{alias_scopes = [#alias_scope182, #alias_scope183, #alias_scope181], alignment = 1 : i64, noalias_scopes = [#alias_scope184], ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %29 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1>}> : (!llvm.ptr) -> !llvm.ptr
  %30 = "llvm.getelementptr"(%22) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%22) : (!llvm.ptr) -> ()
  "llvm.intr.memcpy"(%30, %29, %1) <{arg_attrs = [{llvm.align = 1 : i64, llvm.dereferenceable = 31 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 1 : i64, llvm.dereferenceable = 31 : i64, llvm.nonnull, llvm.noundef, llvm.readonly}, {}], isVolatile = false, noalias_scopes = [#alias_scope184]}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.store"(%28, %22) <{alignment = 1 : i64, noalias_scopes = [#alias_scope184, #alias_scope181], ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%18) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%21) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%20) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%19) : (!llvm.ptr) -> ()
  "llvm.call"(%19, %22) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 168 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 1 : i64, llvm.dereferenceable = 32 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvMs2_NtCsh8hPzWUDumX_14solana_ed255197edwardsNtB5_18CompressedEdwardsY10decompress, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope185, #alias_scope184, #alias_scope181], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %31 = "llvm.load"(%19) <{alignment = 8 : i64, noalias_scopes = [#alias_scope185, #alias_scope186, #alias_scope184, #alias_scope181], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %32 = "llvm.trunc"(%31) <{overflowFlags = 2 : i32}> : (i64) -> i1
  "llvm.cond_br"(%32)[^bb2, ^bb1] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb1:  // pred: ^bb0
  "llvm.intr.lifetime.end"(%19) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%20) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%21) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%18) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%22) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%25) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%26) : (!llvm.ptr) -> ()
  "llvm.br"(%2)[^bb3] : (i8) -> ()
^bb2:  // pred: ^bb0
  %33 = "llvm.getelementptr"(%19) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %34 = "llvm.getelementptr"(%20) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memcpy"(%34, %33, %3) <{arg_attrs = [{llvm.align = 2 : i64, llvm.dereferenceable = 160 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 160 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false, noalias_scopes = [#alias_scope185, #alias_scope186, #alias_scope184, #alias_scope181]}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.intr.lifetime.end"(%19) : (!llvm.ptr) -> ()
  %35 = "llvm.getelementptr"(%21) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memcpy"(%35, %34, %3) <{arg_attrs = [{llvm.align = 2 : i64, llvm.dereferenceable = 160 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 2 : i64, llvm.dereferenceable = 160 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false, noalias_scopes = [#alias_scope185, #alias_scope186, #alias_scope184, #alias_scope181]}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.intr.lifetime.end"(%20) : (!llvm.ptr) -> ()
  "llvm.intr.memcpy"(%18, %35, %3) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 160 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 2 : i64, llvm.dereferenceable = 160 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false, noalias_scopes = [#alias_scope185, #alias_scope186, #alias_scope184, #alias_scope181]}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.intr.lifetime.end"(%21) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%17) : (!llvm.ptr) -> ()
  %36 = "llvm.getelementptr"(%17) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%36, %18) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, alias_scopes = [#alias_scope187, #alias_scope188, #alias_scope189, #alias_scope190], arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvXs6_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u645fieldRNtB5_14FieldElement51NtNtNtCsgxBkk5gSRhY_4core3ops5arith3Neg3neg, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope185, #alias_scope186, #alias_scope184, #alias_scope181], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %37 = "llvm.getelementptr"(%18) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  %38 = "llvm.getelementptr"(%17) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 72>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memcpy"(%38, %37, %5) <{alias_scopes = [#alias_scope187, #alias_scope188, #alias_scope189, #alias_scope190], arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef, llvm.readonly}, {}], isVolatile = false, noalias_scopes = [#alias_scope185, #alias_scope186, #alias_scope184, #alias_scope181]}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %39 = "llvm.getelementptr"(%18) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 80>}> : (!llvm.ptr) -> !llvm.ptr
  %40 = "llvm.getelementptr"(%17) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 112>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memcpy"(%40, %39, %5) <{alias_scopes = [#alias_scope187, #alias_scope188, #alias_scope189, #alias_scope190], arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef, llvm.readonly}, {}], isVolatile = false, noalias_scopes = [#alias_scope185, #alias_scope186, #alias_scope184, #alias_scope181]}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %41 = "llvm.getelementptr"(%18) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 120>}> : (!llvm.ptr) -> !llvm.ptr
  %42 = "llvm.getelementptr"(%17) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 152>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%42, %41) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, alias_scopes = [#alias_scope187, #alias_scope188, #alias_scope189, #alias_scope190], arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvXs6_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u645fieldRNtB5_14FieldElement51NtNtNtCsgxBkk5gSRhY_4core3ops5arith3Neg3neg, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope185, #alias_scope186, #alias_scope184, #alias_scope181], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.memcpy"(%17, %22, %4) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 32 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 1 : i64, llvm.dereferenceable = 32 : i64, llvm.nonnull, llvm.noundef, llvm.readonly}, {}], isVolatile = false, noalias_scopes = [#alias_scope185, #alias_scope184, #alias_scope181]}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %43 = "llvm.getelementptr"(%25) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memcpy"(%43, %17, %6) <{arg_attrs = [{llvm.align = 2 : i64, llvm.dereferenceable = 192 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 192 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false, noalias_scopes = [#alias_scope186, #alias_scope181]}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.intr.lifetime.end"(%17) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%18) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%22) : (!llvm.ptr) -> ()
  %44 = "llvm.getelementptr"(%26) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memcpy"(%44, %43, %6) <{arg_attrs = [{llvm.align = 2 : i64, llvm.dereferenceable = 192 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 2 : i64, llvm.dereferenceable = 192 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.intr.lifetime.end"(%25) : (!llvm.ptr) -> ()
  "llvm.intr.memcpy"(%27, %44, %6) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 192 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 2 : i64, llvm.dereferenceable = 192 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.intr.lifetime.end"(%26) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%24) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%23) : (!llvm.ptr) -> ()
  %45 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %46 = "llvm.load"(%arg0) <{alias_scopes = [#alias_scope191, #alias_scope192], alignment = 1 : i64, noalias_scopes = [#alias_scope193, #alias_scope194, #alias_scope195], ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %47 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memcpy"(%23, %47, %1) <{arg_attrs = [{llvm.align = 1 : i64, llvm.dereferenceable = 31 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 1 : i64, llvm.dereferenceable = 31 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false, noalias_scopes = []}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %48 = "llvm.getelementptr"(%23) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 31>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memcpy"(%48, %45, %4) <{arg_attrs = [{llvm.align = 1 : i64, llvm.dereferenceable = 32 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 1 : i64, llvm.dereferenceable = 32 : i64, llvm.nonnull, llvm.noundef, llvm.readonly}, {}], isVolatile = false, noalias_scopes = []}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %49 = "llvm.getelementptr"(%24) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memcpy"(%49, %23, %7) <{arg_attrs = [{llvm.align = 1 : i64, llvm.dereferenceable = 63 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 1 : i64, llvm.dereferenceable = 63 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.intr.lifetime.end"(%23) : (!llvm.ptr) -> ()
  "llvm.store"(%46, %24) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%16) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%15) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%14) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%13) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%12) : (!llvm.ptr) -> ()
  %50 = "llvm.getelementptr"(%12) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memcpy"(%50, %8, %9) <{arg_attrs = [{llvm.align = 16 : i64, llvm.dereferenceable = 64 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 16 : i64, llvm.dereferenceable = 64 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false, noalias_scopes = [#alias_scope196, #alias_scope197, #alias_scope198, #alias_scope199, #alias_scope200, #alias_scope201, #alias_scope202]}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %51 = "llvm.getelementptr"(%12) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 192>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%10, %51) <{alias_scopes = [#alias_scope203], alignment = 16 : i64, noalias_scopes = [#alias_scope196, #alias_scope197, #alias_scope198, #alias_scope199, #alias_scope200, #alias_scope201, #alias_scope202], ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
  %52 = "llvm.getelementptr"(%12) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 127>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%11, %52) <{alias_scopes = [#alias_scope203], alignment = 1 : i64, noalias_scopes = [#alias_scope196, #alias_scope197, #alias_scope198, #alias_scope199, #alias_scope200, #alias_scope201, #alias_scope202], ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.call"(%13, %12, %24, %4) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 16 : i64, llvm.dereferenceable = 208 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.noundef}, {llvm.align = 16 : i64, llvm.dereferenceable = 208 : i64, llvm.noalias, llvm.nofree, llvm.noundef}, {llvm.dereferenceable = 64 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.noundef}], callee = @_RINvYNtCsgIn12VVV7xy_4sha26Sha512NtCs1e9z9zBfBch_6digest6Update5chainRShECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope196, #alias_scope197, #alias_scope199, #alias_scope200, #alias_scope202], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.intr.lifetime.end"(%12) : (!llvm.ptr) -> ()
  "llvm.call"(%14, %13, %27, %4) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 16 : i64, llvm.dereferenceable = 208 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.noundef}, {llvm.align = 16 : i64, llvm.dereferenceable = 208 : i64, llvm.noalias, llvm.nofree, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 192 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.noundef}], callee = @_RINvYNtCsgIn12VVV7xy_4sha26Sha512NtCs1e9z9zBfBch_6digest6Update5chainRShECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope196, #alias_scope198, #alias_scope199, #alias_scope201, #alias_scope202], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.intr.lifetime.end"(%13) : (!llvm.ptr) -> ()
  "llvm.call"(%15, %14, %arg2, %arg3) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 16 : i64, llvm.dereferenceable = 208 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.noundef}, {llvm.align = 16 : i64, llvm.dereferenceable = 208 : i64, llvm.noalias, llvm.nofree, llvm.noundef}, {llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.noundef, llvm.range = #llvm.constant_range<i64, 0, -9223372036854775808>}], callee = @_RINvYNtCsgIn12VVV7xy_4sha26Sha512NtCs1e9z9zBfBch_6digest6Update5chainRShECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope196, #alias_scope197, #alias_scope198, #alias_scope200, #alias_scope201], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.intr.lifetime.end"(%14) : (!llvm.ptr) -> ()
  "llvm.call"(%16, %15) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 1 : i64, llvm.dereferenceable = 32 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 16 : i64, llvm.dereferenceable = 208 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef}], callee = @_RNvNtCsh8hPzWUDumX_14solana_ed255197ed_sigs18scalar_from_sha512, fastmathFlags = #llvm.fastmath<none>, noalias_scopes = [#alias_scope197, #alias_scope198, #alias_scope199, #alias_scope200, #alias_scope201, #alias_scope202], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%15) : (!llvm.ptr) -> ()
  %53 = "llvm.call"(%27, %24, %16) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 192 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.dereferenceable = 64 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.align = 1 : i64, llvm.dereferenceable = 32 : i64, llvm.noalias, llvm.nofree, llvm.noundef, llvm.readonly}], callee = @_RNvMsc_NtNtCsh8hPzWUDumX_14solana_ed255197ed_sigs16verification_keyNtB5_15VerificationKey22verify_dalek_prehashed, fastmathFlags = #llvm.fastmath<none>, noalias_scopes = [#alias_scope202], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>, res_attrs = [{llvm.noundef, llvm.range = #llvm.constant_range<i8, -1, 3>}]}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> i8
  "llvm.intr.lifetime.end"(%16) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%24) : (!llvm.ptr) -> ()
  "llvm.br"(%53)[^bb3] : (i8) -> ()
^bb3(%54: i8):  // 2 preds: ^bb1, ^bb2
  "llvm.intr.lifetime.end"(%27) : (!llvm.ptr) -> ()
  "llvm.return"(%54) : (i8) -> ()
}) : () -> ()
  with
    @_RINvYNtCsgIn12VVV7xy_4sha26Sha512NtCs1e9z9zBfBch_6digest6Update5chainRShECsh8hPzWUDumX_14solana_ed25519 := Sha512_Update_chain_slice_u8,
    @_RNvMs2_NtCsh8hPzWUDumX_14solana_ed255197edwardsNtB5_18CompressedEdwardsY10decompress := CompressedEdwardsY_decompress,
    @_RNvMsc_NtNtCsh8hPzWUDumX_14solana_ed255197ed_sigs16verification_keyNtB5_15VerificationKey22verify_dalek_prehashed := VerificationKey_verify_dalek_prehashed,
    @_RNvNtCsh8hPzWUDumX_14solana_ed255197ed_sigs18scalar_from_sha512 := scalar_from_sha512,
    @_RNvXs6_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u645fieldRNtB5_14FieldElement51NtNtNtCsgxBkk5gSRhY_4core3ops5arith3Neg3neg := FieldElement51_Neg_neg,
    @anon.e79fcfe266c5706188f989b4d452749f.134 := MLIR.Agave.Serial.anon_042b818bc72209407b52bd0e4d6c8368_139

end

end MLIR.Agave.Avx2
