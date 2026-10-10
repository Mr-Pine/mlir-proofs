module

-- sodium-build/out/op/fe25519_0.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Sodium

@[expose] public section

mlir_def fe25519_0 :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.noundef}], dso_local, function_type = !llvm.func<void (ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "ssp", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], sym_name = "fe25519_0", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg79: !llvm.ptr):
  %2805 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %2806 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
  "llvm.intr.memset"(%arg79, %2805, %2806) <{arg_attrs = [{llvm.align = 1 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], isVolatile = false}> : (!llvm.ptr, i8, i64) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end MLIR.Sodium
