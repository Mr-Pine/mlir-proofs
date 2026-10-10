module

-- boringssl-build/out/op/_ZL24fiat_25519_addcarryx_u51PmPhhmm.mlir
-- fiat_25519_addcarryx_u51(unsigned long*, unsigned char*, unsigned char, unsigned long, unsigned long)

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Boringssl

@[expose] public section

mlir_def fiat_25519_addcarryx_u51 :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.noundef, llvm.zeroext}, {llvm.noundef}, {llvm.noundef, llvm.range = #llvm.constant_range<i64, 0, 2251799813685248>}], dso_local, function_type = !llvm.func<void (ptr, ptr, i8, i64, i64)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"], ["warn-stack-size", "25344"]], sym_name = "_ZL24fiat_25519_addcarryx_u51PmPhhmm", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg145: !llvm.ptr, %arg146: !llvm.ptr, %arg147: i8, %arg148: i64, %arg149: i64):
  %1746 = "llvm.mlir.constant"() <{value = 2251799813685247 : i64}> : () -> i64
  %1747 = "llvm.mlir.constant"() <{value = 51 : i64}> : () -> i64
  %1748 = "llvm.zext"(%arg147) : (i8) -> i64
  %1749 = "llvm.add"(%arg148, %1748) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1750 = "llvm.add"(%1749, %arg149) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1751 = "llvm.and"(%1750, %1746) : (i64, i64) -> i64
  %1752 = "llvm.lshr"(%1750, %1747) : (i64, i64) -> i64
  %1753 = "llvm.trunc"(%1752) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%1751, %arg145) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.store"(%1753, %arg146) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end MLIR.Boringssl
