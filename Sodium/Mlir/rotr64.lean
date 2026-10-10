module

-- sodium-build/out/op/rotr64.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Sodium

@[expose] public section

mlir_def rotr64 :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.noundef}, {llvm.noundef, llvm.range = #llvm.constant_range<i32, 1, 62>}], dso_local, function_type = !llvm.func<i64 (i64, i32)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "ssp", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], sym_name = "rotr64", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg25: i64, %arg26: i32):
  %355 = "llvm.mlir.constant"() <{value = 64 : i32}> : () -> i32
  %356 = "llvm.zext"(%arg26) <{nonNeg}> : (i32) -> i64
  %357 = "llvm.lshr"(%arg25, %356) : (i64, i64) -> i64
  %358 = "llvm.sub"(%355, %arg26) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %359 = "llvm.zext"(%358) <{nonNeg}> : (i32) -> i64
  %360 = "llvm.shl"(%arg25, %359) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %361 = "llvm.or"(%360, %357) : (i64, i64) -> i64
  "llvm.return"(%361) : (i64) -> ()
}) : () -> ()

end

end MLIR.Sodium
