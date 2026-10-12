module

-- agave-build/out/serial-noinline-big/op/_RNvMs8_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldNtB5_14FieldElement516square.mlir
-- <solana_ed25519[1fe0933b11699477]::backend::serial::u64::field::FieldElement51>::square

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Agave.Serial.Mlir.FieldElement51_pow2k

meta import MLIR.Semantics.Func
meta import Agave.Serial.Mlir.FieldElement51_pow2k

namespace MLIR.Agave.Serial

@[expose] public section

mlir_def FieldElement51_square :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 8 : i64, llvm.dead_on_unwind, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writable, llvm.writeonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], sym_name = "_RNvMs8_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldNtB5_14FieldElement516square", target_cpu = "x86-64-v2", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg82: !llvm.ptr, %arg83: !llvm.ptr):
  %2073 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  "llvm.call"(%arg82, %arg83, %2073) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.noundef}], callee = @_RNvMs8_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldNtB5_14FieldElement515pow2k, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
  with
    @_RNvMs8_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldNtB5_14FieldElement515pow2k := FieldElement51_pow2k

end

end MLIR.Agave.Serial
