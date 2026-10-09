module

-- build/llvm23/mlir_canonicalized/ref/op/fd_ulong_find_lsb.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Firedancer.Ref

@[expose] public section

mlir_def fd_ulong_find_lsb :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.noundef}], dso_local, function_type = !llvm.func<i32 (i64)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], res_attrs = [{llvm.range = #llvm.constant_range<i32, -1, 64>}], sym_name = "fd_ulong_find_lsb", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg73: i64):
  %1097 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %1098 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
  %1099 = "llvm.intr.cttz"(%arg73) <{is_zero_poison = true}> : (i64) -> i64
  %1100 = "llvm.icmp"(%arg73, %1097) <{predicate = 0 : i64}> : (i64, i64) -> i1
  %1101 = "llvm.trunc"(%1099) <{overflowFlags = 3 : i32}> : (i64) -> i32
  %1102 = "llvm.select"(%1100, %1098, %1101) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i32, i32) -> i32
  "llvm.return"(%1102) : (i32) -> ()
}) : () -> ()

end

end MLIR.Firedancer.Ref
