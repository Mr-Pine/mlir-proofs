module

-- boringssl-build/out/op/_ZL25fiat_25519_subborrowx_u51PmPhhmm.mlir
-- fiat_25519_subborrowx_u51(unsigned long*, unsigned char*, unsigned char, unsigned long, unsigned long)

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Boringssl

@[expose] public section

mlir_def fiat_25519_subborrowx_u51 :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.noundef, llvm.zeroext}, {llvm.noundef}, {llvm.noundef, llvm.range = #llvm.constant_range<i64, 2251799813685229, 2251799813685248>}], dso_local, function_type = !llvm.func<void (ptr, ptr, i8, i64, i64)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"], ["warn-stack-size", "25344"]], sym_name = "_ZL25fiat_25519_subborrowx_u51PmPhhmm", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg152: !llvm.ptr, %arg153: !llvm.ptr, %arg154: i8, %arg155: i64, %arg156: i64):
  %1757 = "llvm.mlir.constant"() <{value = 51 : i64}> : () -> i64
  %1758 = "llvm.mlir.constant"() <{value = 2251799813685247 : i64}> : () -> i64
  %1759 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %1760 = "llvm.zext"(%arg154) : (i8) -> i64
  %1761 = "llvm.add"(%arg156, %1760) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1762 = "llvm.sub"(%arg155, %1761) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1763 = "llvm.lshr"(%1762, %1757) : (i64, i64) -> i64
  %1764 = "llvm.trunc"(%1763) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1765 = "llvm.and"(%1762, %1758) : (i64, i64) -> i64
  "llvm.store"(%1765, %arg152) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1766 = "llvm.sub"(%1759, %1764) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  "llvm.store"(%1766, %arg153) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end MLIR.Boringssl
