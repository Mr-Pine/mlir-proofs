module

-- build/llvm23/mlir_canonicalized/ref/op/fd_ulong_rotate_right.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Firedancer.Ref

@[expose] public section

mlir_def fd_ulong_rotate_right :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.noundef}, {llvm.noundef, llvm.range = #llvm.constant_range<i32, 1, 62>}], dso_local, function_type = !llvm.func<i64 (i64, i32)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], sym_name = "fd_ulong_rotate_right", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg0: i64, %arg1: i32):
  %0 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %1 = "llvm.mlir.constant"() <{value = 63 : i32}> : () -> i32
  %2 = "llvm.zext"(%arg1) <{nonNeg}> : (i32) -> i64
  %3 = "llvm.lshr"(%arg0, %2) : (i64, i64) -> i64
  %4 = "llvm.sub"(%0, %arg1) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %5 = "llvm.and"(%4, %1) : (i32, i32) -> i32
  %6 = "llvm.zext"(%5) <{nonNeg}> : (i32) -> i64
  %7 = "llvm.shl"(%arg0, %6) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %8 = "llvm.or"(%7, %3) : (i64, i64) -> i64
  "llvm.return"(%8) : (i64) -> ()
}) : () -> ()

end

end MLIR.Firedancer.Ref
