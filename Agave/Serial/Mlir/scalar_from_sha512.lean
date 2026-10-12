module

-- agave-build/out/serial-noinline-big/op/_RNvNtCs2JGgYtL0Fal_14solana_ed255197ed_sigs18scalar_from_sha512.mlir
-- solana_ed25519[1fe0933b11699477]::ed_sigs::scalar_from_sha512

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Agave.Serial.Mlir.Scalar52_from_bytes_wide
public import Agave.Serial.Mlir.Scalar52_pack
public import Agave.Serial.Mlir.IterMut_u8_Zeroize_zeroize
public import Agave.Serial.Mlir.Sha512VarCore_VariableOutputCore_finalize_variable_core

meta import MLIR.Semantics.Func
meta import Agave.Serial.Mlir.Scalar52_from_bytes_wide
meta import Agave.Serial.Mlir.Scalar52_pack
meta import Agave.Serial.Mlir.IterMut_u8_Zeroize_zeroize
meta import Agave.Serial.Mlir.Sha512VarCore_VariableOutputCore_finalize_variable_core

namespace MLIR.Agave.Serial

@[expose] public section

noncomputable mlir_def scalar_from_sha512 :=
#alias_scope_domain58 = #llvm.alias_scope_domain<id = distinct[58]<>, description = "_RNvYNtCsgIn12VVV7xy_4sha26Sha512NtCs1e9z9zBfBch_6digest11FixedOutput14finalize_fixedCs2JGgYtL0Fal_14solana_ed25519">
#alias_scope_domain59 = #llvm.alias_scope_domain<id = distinct[59]<>, description = "_RINvNtCsgxBkk5gSRhY_4core5slice20copy_from_slice_implhECs2JGgYtL0Fal_14solana_ed25519">
#alias_scope_domain60 = #llvm.alias_scope_domain<id = distinct[60]<>, description = "_RNvMNtCs2JGgYtL0Fal_14solana_ed255196scalarNtB2_6Scalar25from_bytes_mod_order_wide">
#alias_scope_domain61 = #llvm.alias_scope_domain<id = distinct[61]<>, description = "_RNvXs6_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar52NtNtCsgxBkk5gSRhY_4core7default7Default7default">
#alias_scope_domain62 = #llvm.alias_scope_domain<id = distinct[62]<>, description = "_RNvXCshxoft6be3N1_7zeroizeNtNtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u646scalar8Scalar52NtB2_7Zeroize7zeroizeBy_">
#alias_scope_domain63 = #llvm.alias_scope_domain<id = distinct[63]<>, description = "_RNvXs9_Cshxoft6be3N1_7zeroizeShNtB5_7Zeroize7zeroizeCs2JGgYtL0Fal_14solana_ed25519">
#alias_scope93 = #llvm.alias_scope<id = distinct[169]<>, domain = #alias_scope_domain58, description = "_RNvYNtCsgIn12VVV7xy_4sha26Sha512NtCs1e9z9zBfBch_6digest11FixedOutput14finalize_fixedCs2JGgYtL0Fal_14solana_ed25519: argument 0">
#alias_scope94 = #llvm.alias_scope<id = distinct[170]<>, domain = #alias_scope_domain58, description = "_RNvYNtCsgIn12VVV7xy_4sha26Sha512NtCs1e9z9zBfBch_6digest11FixedOutput14finalize_fixedCs2JGgYtL0Fal_14solana_ed25519: argument 1">
#alias_scope95 = #llvm.alias_scope<id = distinct[171]<>, domain = #alias_scope_domain59, description = "_RINvNtCsgxBkk5gSRhY_4core5slice20copy_from_slice_implhECs2JGgYtL0Fal_14solana_ed25519: argument 0">
#alias_scope96 = #llvm.alias_scope<id = distinct[172]<>, domain = #alias_scope_domain59, description = "_RINvNtCsgxBkk5gSRhY_4core5slice20copy_from_slice_implhECs2JGgYtL0Fal_14solana_ed25519: argument 1">
#alias_scope97 = #llvm.alias_scope<id = distinct[173]<>, domain = #alias_scope_domain59, description = "_RINvNtCsgxBkk5gSRhY_4core5slice20copy_from_slice_implhECs2JGgYtL0Fal_14solana_ed25519: argument 2">
#alias_scope98 = #llvm.alias_scope<id = distinct[174]<>, domain = #alias_scope_domain60, description = "_RNvMNtCs2JGgYtL0Fal_14solana_ed255196scalarNtB2_6Scalar25from_bytes_mod_order_wide: argument 0">
#alias_scope99 = #llvm.alias_scope<id = distinct[175]<>, domain = #alias_scope_domain60, description = "_RNvMNtCs2JGgYtL0Fal_14solana_ed255196scalarNtB2_6Scalar25from_bytes_mod_order_wide: argument 1">
#alias_scope100 = #llvm.alias_scope<id = distinct[176]<>, domain = #alias_scope_domain61, description = "_RNvXs6_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar52NtNtCsgxBkk5gSRhY_4core7default7Default7default: argument 0">
#alias_scope101 = #llvm.alias_scope<id = distinct[177]<>, domain = #alias_scope_domain62, description = "_RNvXCshxoft6be3N1_7zeroizeNtNtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u646scalar8Scalar52NtB2_7Zeroize7zeroizeBy_: argument 0">
#alias_scope102 = #llvm.alias_scope<id = distinct[178]<>, domain = #alias_scope_domain63, description = "_RNvXs9_Cshxoft6be3N1_7zeroizeShNtB5_7Zeroize7zeroizeCs2JGgYtL0Fal_14solana_ed25519: argument 0">
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 1 : i64, llvm.dead_on_unwind, llvm.dereferenceable = 32 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writable, llvm.writeonly}, {llvm.align = 16 : i64, llvm.dead_on_return = -1 : i64, llvm.dereferenceable = 208 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, no_inline, passthrough = ["nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], personality = @rust_eh_personality, sym_name = "_RNvNtCs2JGgYtL0Fal_14solana_ed255197ed_sigs18scalar_from_sha512", target_cpu = "x86-64-v2", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg4: !llvm.ptr, %arg5: !llvm.ptr):
  %55 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %56 = "llvm.mlir.constant"() <{value = 208 : i64}> : () -> i64
  %57 = "llvm.mlir.constant"() <{value = 64 : i64}> : () -> i64
  %58 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %59 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
  %60 = "llvm.alloca"(%55) <{alignment = 8 : i64, elem_type = !llvm.array<40 x i8>}> : (i32) -> !llvm.ptr
  %61 = "llvm.alloca"(%55) <{alignment = 8 : i64, elem_type = !llvm.array<40 x i8>}> : (i32) -> !llvm.ptr
  %62 = "llvm.alloca"(%55) <{alignment = 1 : i64, elem_type = !llvm.array<64 x i8>}> : (i32) -> !llvm.ptr
  %63 = "llvm.alloca"(%55) <{alignment = 16 : i64, elem_type = !llvm.array<208 x i8>}> : (i32) -> !llvm.ptr
  %64 = "llvm.alloca"(%55) <{alignment = 8 : i64, elem_type = !llvm.array<16 x i8>}> : (i32) -> !llvm.ptr
  %65 = "llvm.alloca"(%55) <{alignment = 1 : i64, elem_type = !llvm.array<64 x i8>}> : (i32) -> !llvm.ptr
  %66 = "llvm.alloca"(%55) <{alignment = 1 : i64, elem_type = !llvm.array<64 x i8>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%66) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%62) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%63) : (!llvm.ptr) -> ()
  "llvm.intr.memcpy"(%63, %arg5, %56) <{arg_attrs = [{llvm.align = 16 : i64, llvm.dereferenceable = 208 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 16 : i64, llvm.dereferenceable = 208 : i64, llvm.nonnull, llvm.noundef, llvm.readonly}, {}], isVolatile = false, noalias_scopes = [#alias_scope93]}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %67 = "llvm.getelementptr"(%63) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%67, %63, %62) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 16 : i64, llvm.dereferenceable = 80 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 16 : i64, llvm.dereferenceable = 208 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.dereferenceable = 64 : i64, llvm.noalias, llvm.nofree, llvm.noundef}], callee = @_RNvXsd_NtCsgIn12VVV7xy_4sha29block_apiNtB5_13Sha512VarCoreNtNtCs1e9z9zBfBch_6digest9block_api18VariableOutputCore22finalize_variable_core, fastmathFlags = #llvm.fastmath<none>, noalias_scopes = [#alias_scope93, #alias_scope94], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%63) : (!llvm.ptr) -> ()
  "llvm.intr.memcpy"(%66, %62, %57) <{arg_attrs = [{llvm.align = 1 : i64, llvm.dereferenceable = 64 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 1 : i64, llvm.dereferenceable = 64 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false, noalias_scopes = [#alias_scope94]}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.intr.lifetime.end"(%62) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%65) : (!llvm.ptr) -> ()
  "llvm.intr.memcpy"(%65, %66, %57) <{alias_scopes = [#alias_scope95, #alias_scope96], arg_attrs = [{llvm.align = 1 : i64, llvm.dereferenceable = 64 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 1 : i64, llvm.dereferenceable = 64 : i64, llvm.nonnull, llvm.noundef, llvm.readonly}, {}], isVolatile = false, noalias_scopes = [#alias_scope97]}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.intr.lifetime.start"(%61) : (!llvm.ptr) -> ()
  "llvm.call"(%61, %66) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.noundef}, {llvm.dereferenceable = 64 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvMs2_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar5215from_bytes_wide, fastmathFlags = #llvm.fastmath<none>, noalias_scopes = [#alias_scope98], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%arg4, %61) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 1 : i64, llvm.dereferenceable = 32 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.noundef, llvm.readonly}], callee = @_RNvMsp_NtCs2JGgYtL0Fal_14solana_ed255196scalarNtNtNtNtNtB7_7backend6serial3u646scalar8Scalar524pack, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope99], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%60) : (!llvm.ptr) -> ()
  "llvm.intr.memset"(%60, %58, %59) <{alias_scopes = [#alias_scope100], arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {}, {}], isVolatile = false, noalias_scopes = [#alias_scope101, #alias_scope98, #alias_scope99]}> : (!llvm.ptr, i8, i64) -> ()
  "llvm.intr.memcpy"(%61, %60, %59) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull}, {llvm.align = 8 : i64, llvm.nonnull}, {}], isVolatile = true, noalias_scopes = [#alias_scope98, #alias_scope99]}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.intr.lifetime.end"(%60) : (!llvm.ptr) -> ()
  "llvm.fence"() <{ordering = 7 : i64, syncscope = "singlethread"}> : () -> ()
  "llvm.intr.lifetime.end"(%61) : (!llvm.ptr) -> ()
  "llvm.store"(%58, %66) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %68 = "llvm.getelementptr"(%66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %68) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %69 = "llvm.getelementptr"(%66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %69) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %70 = "llvm.getelementptr"(%66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 3>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %70) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %71 = "llvm.getelementptr"(%66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %71) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %72 = "llvm.getelementptr"(%66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 5>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %72) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %73 = "llvm.getelementptr"(%66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %73) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %74 = "llvm.getelementptr"(%66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 7>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %74) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %75 = "llvm.getelementptr"(%66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %75) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %76 = "llvm.getelementptr"(%66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 9>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %76) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %77 = "llvm.getelementptr"(%66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 10>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %77) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %78 = "llvm.getelementptr"(%66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 11>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %78) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %79 = "llvm.getelementptr"(%66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 12>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %79) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %80 = "llvm.getelementptr"(%66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 13>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %80) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %81 = "llvm.getelementptr"(%66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 14>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %81) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %82 = "llvm.getelementptr"(%66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 15>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %82) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %83 = "llvm.getelementptr"(%66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %83) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %84 = "llvm.getelementptr"(%66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 17>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %84) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %85 = "llvm.getelementptr"(%66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 18>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %85) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %86 = "llvm.getelementptr"(%66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 19>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %86) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %87 = "llvm.getelementptr"(%66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 20>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %87) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %88 = "llvm.getelementptr"(%66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 21>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %88) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %89 = "llvm.getelementptr"(%66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 22>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %89) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %90 = "llvm.getelementptr"(%66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 23>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %90) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %91 = "llvm.getelementptr"(%66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %91) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %92 = "llvm.getelementptr"(%66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 25>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %92) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %93 = "llvm.getelementptr"(%66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 26>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %93) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %94 = "llvm.getelementptr"(%66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 27>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %94) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %95 = "llvm.getelementptr"(%66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 28>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %95) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %96 = "llvm.getelementptr"(%66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 29>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %96) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %97 = "llvm.getelementptr"(%66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 30>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %97) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %98 = "llvm.getelementptr"(%66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 31>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %98) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %99 = "llvm.getelementptr"(%66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %99) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %100 = "llvm.getelementptr"(%66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 33>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %100) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %101 = "llvm.getelementptr"(%66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 34>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %101) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %102 = "llvm.getelementptr"(%66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 35>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %102) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %103 = "llvm.getelementptr"(%66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 36>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %103) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %104 = "llvm.getelementptr"(%66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 37>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %104) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %105 = "llvm.getelementptr"(%66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 38>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %105) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %106 = "llvm.getelementptr"(%66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 39>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %106) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %107 = "llvm.getelementptr"(%66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %107) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %108 = "llvm.getelementptr"(%66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 41>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %108) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %109 = "llvm.getelementptr"(%66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 42>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %109) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %110 = "llvm.getelementptr"(%66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 43>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %110) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %111 = "llvm.getelementptr"(%66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 44>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %111) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %112 = "llvm.getelementptr"(%66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 45>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %112) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %113 = "llvm.getelementptr"(%66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 46>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %113) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %114 = "llvm.getelementptr"(%66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 47>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %114) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %115 = "llvm.getelementptr"(%66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 48>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %115) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %116 = "llvm.getelementptr"(%66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 49>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %116) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %117 = "llvm.getelementptr"(%66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 50>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %117) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %118 = "llvm.getelementptr"(%66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 51>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %118) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %119 = "llvm.getelementptr"(%66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 52>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %119) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %120 = "llvm.getelementptr"(%66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 53>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %120) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %121 = "llvm.getelementptr"(%66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 54>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %121) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %122 = "llvm.getelementptr"(%66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 55>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %122) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %123 = "llvm.getelementptr"(%66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 56>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %123) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %124 = "llvm.getelementptr"(%66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 57>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %124) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %125 = "llvm.getelementptr"(%66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 58>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %125) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %126 = "llvm.getelementptr"(%66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 59>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %126) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %127 = "llvm.getelementptr"(%66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 60>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %127) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %128 = "llvm.getelementptr"(%66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 61>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %128) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %129 = "llvm.getelementptr"(%66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 62>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %129) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %130 = "llvm.getelementptr"(%66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 63>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %130) <{alias_scopes = [#alias_scope102], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  "llvm.fence"() <{ordering = 7 : i64, syncscope = "singlethread"}> : () -> ()
  "llvm.intr.lifetime.start"(%64) : (!llvm.ptr) -> ()
  %131 = "llvm.getelementptr"(%65) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%65, %64) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr, !llvm.ptr) -> ()
  %132 = "llvm.getelementptr"(%64) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%131, %132) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%64) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 16 : i64, llvm.noalias, llvm.nofree, llvm.noundef}], callee = @_RNvXs4_Cshxoft6be3N1_7zeroizeINtNtNtCsgxBkk5gSRhY_4core5slice4iter7IterMuthENtB5_7Zeroize7zeroizeCs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%64) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%65) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%66) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
  with
    @_RNvMs2_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar5215from_bytes_wide := Scalar52_from_bytes_wide,
    @_RNvMsp_NtCs2JGgYtL0Fal_14solana_ed255196scalarNtNtNtNtNtB7_7backend6serial3u646scalar8Scalar524pack := Scalar52_pack,
    @_RNvXs4_Cshxoft6be3N1_7zeroizeINtNtNtCsgxBkk5gSRhY_4core5slice4iter7IterMuthENtB5_7Zeroize7zeroizeCs2JGgYtL0Fal_14solana_ed25519 := IterMut_u8_Zeroize_zeroize,
    @_RNvXsd_NtCsgIn12VVV7xy_4sha29block_apiNtB5_13Sha512VarCoreNtNtCs1e9z9zBfBch_6digest9block_api18VariableOutputCore22finalize_variable_core := Sha512VarCore_VariableOutputCore_finalize_variable_core

end

end MLIR.Agave.Serial
