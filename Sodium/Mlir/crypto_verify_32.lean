module

-- sodium-build/out/op/crypto_verify_32.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Sodium.Mlir.crypto_verify_n

meta import MLIR.Semantics.Func
meta import Sodium.Mlir.crypto_verify_n

namespace MLIR.Sodium

@[expose] public section

mlir_def crypto_verify_32 :=
"llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], dso_local, function_type = !llvm.func<i32 (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = read, argMem = read, inaccessibleMem = readwrite, errnoMem = read, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "ssp", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], res_attrs = [{llvm.range = #llvm.constant_range<i32, -1, 65535>}], sym_name = "crypto_verify_32", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg10: !llvm.ptr, %arg11: !llvm.ptr):
  %159 = "llvm.mlir.constant"() <{value = 32 : i32}> : () -> i32
  %160 = "llvm.call"(%arg10, %arg11, %159) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crypto_verify_n, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = read, argMem = read, inaccessibleMem = readwrite, errnoMem = read, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> i32
  "llvm.return"(%160) : (i32) -> ()
}) : () -> ()
  with @crypto_verify_n := crypto_verify_n

end

end MLIR.Sodium
