module

-- agave-build/out/avx2-noinline/op/_RNvMs2_NtCsh8hPzWUDumX_14solana_ed255195fieldNtNtNtNtNtB7_7backend6serial3u645field14FieldElement5111is_negative.mlir
-- <solana_ed25519[c79103de3f6f5451]::backend::serial::u64::field::FieldElement51>::is_negative

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Agave.Avx2.Mlir.black_box_u8
public import Agave.Avx2.Mlir.FieldElement51_to_bytes

meta import MLIR.Semantics.Func
meta import Agave.Avx2.Mlir.black_box_u8
meta import Agave.Avx2.Mlir.FieldElement51_to_bytes

namespace MLIR.Agave.Avx2

@[expose] public section

mlir_def FieldElement51_is_negative :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<i8 (ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], res_attrs = [{llvm.noundef}], sym_name = "_RNvMs2_NtCsh8hPzWUDumX_14solana_ed255195fieldNtNtNtNtNtB7_7backend6serial3u645field14FieldElement5111is_negative", target_cpu = "x86-64-v2", target_features = #llvm.target_features<["+avx", "+avx2", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+crc32", "+ssse3"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg33: !llvm.ptr):
  %1549 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1550 = "llvm.mlir.constant"() <{value = 1 : i8}> : () -> i8
  %1551 = "llvm.alloca"(%1549) <{alignment = 1 : i64, elem_type = !llvm.array<32 x i8>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%1551) : (!llvm.ptr) -> ()
  "llvm.call"(%1551, %arg33) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 1 : i64, llvm.dereferenceable = 32 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvMs8_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u645fieldNtB5_14FieldElement518to_bytes, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %1552 = "llvm.load"(%1551) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1553 = "llvm.and"(%1552, %1550) : (i8, i8) -> i8
  %1554 = "llvm.call"(%1553) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  "llvm.intr.lifetime.end"(%1551) : (!llvm.ptr) -> ()
  "llvm.return"(%1554) : (i8) -> ()
}) : () -> ()
  with @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519 := black_box_u8,
    @_RNvMs8_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u645fieldNtB5_14FieldElement518to_bytes := FieldElement51_to_bytes

end

end MLIR.Agave.Avx2
