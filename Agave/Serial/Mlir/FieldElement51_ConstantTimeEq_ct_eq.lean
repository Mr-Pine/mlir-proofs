module

-- agave-build/out/serial-noinline/op/_RNvXs0_NtCs2JGgYtL0Fal_14solana_ed255195fieldNtNtNtNtNtB7_7backend6serial3u645field14FieldElement51NtCs3X6wZJE6GDg_6subtle14ConstantTimeEq5ct_eq.mlir
-- <solana_ed25519[1fe0933b11699477]::backend::serial::u64::field::FieldElement51 as subtle[2e0bf2bcb38a7e1c]::ConstantTimeEq>::ct_eq

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Agave.Serial.Mlir.FieldElement51_to_bytes
public import Agave.Serial.Mlir.slice_u8_ConstantTimeEq_ct_eq

meta import MLIR.Semantics.Func
meta import Agave.Serial.Mlir.FieldElement51_to_bytes
meta import Agave.Serial.Mlir.slice_u8_ConstantTimeEq_ct_eq

namespace MLIR.Agave.Serial

@[expose] public section

mlir_def FieldElement51_ConstantTimeEq_ct_eq :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<i8 (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], res_attrs = [{llvm.noundef}], sym_name = "_RNvXs0_NtCs2JGgYtL0Fal_14solana_ed255195fieldNtNtNtNtNtB7_7backend6serial3u645field14FieldElement51NtCs3X6wZJE6GDg_6subtle14ConstantTimeEq5ct_eq", target_cpu = "x86-64-v2", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg38: !llvm.ptr, %arg39: !llvm.ptr):
  %1134 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1135 = "llvm.alloca"(%1134) <{alignment = 1 : i64, elem_type = !llvm.array<32 x i8>}> : (i32) -> !llvm.ptr
  %1136 = "llvm.alloca"(%1134) <{alignment = 1 : i64, elem_type = !llvm.array<32 x i8>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%1136) : (!llvm.ptr) -> ()
  "llvm.call"(%1136, %arg38) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 1 : i64, llvm.dereferenceable = 32 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvMs8_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldNtB5_14FieldElement518to_bytes, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1135) : (!llvm.ptr) -> ()
  "llvm.call"(%1135, %arg39) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 1 : i64, llvm.dereferenceable = 32 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvMs8_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldNtB5_14FieldElement518to_bytes, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %1137 = "llvm.call"(%1136, %1135) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvXs8_Cs3X6wZJE6GDg_6subtleShNtB5_14ConstantTimeEq5ct_eqCs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, inline_hint, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>, res_attrs = [{llvm.noundef}]}> : (!llvm.ptr, !llvm.ptr) -> i8
  "llvm.intr.lifetime.end"(%1135) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1136) : (!llvm.ptr) -> ()
  "llvm.return"(%1137) : (i8) -> ()
}) : () -> ()
  with
    @_RNvMs8_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldNtB5_14FieldElement518to_bytes := FieldElement51_to_bytes,
    @_RNvXs8_Cs3X6wZJE6GDg_6subtleShNtB5_14ConstantTimeEq5ct_eqCs2JGgYtL0Fal_14solana_ed25519 := slice_u8_ConstantTimeEq_ct_eq

end

end MLIR.Agave.Serial
