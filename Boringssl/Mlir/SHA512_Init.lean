module

-- boringssl-build/out/op/SHA512_Init.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Boringssl.Mlir.BCM_sha512_init

meta import MLIR.Semantics.Func
meta import Boringssl.Mlir.BCM_sha512_init

namespace MLIR.Boringssl

@[expose] public section

mlir_def SHA512_Init :=
"llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.noundef}], dso_local, function_type = !llvm.func<i32 (ptr)>, linkage = #llvm.linkage<internal>, no_inline, no_unwind, passthrough = ["mustprogress", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"], ["warn-stack-size", "25344"]], res_attrs = [{llvm.noundef}], sym_name = "SHA512_Init", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg8: !llvm.ptr):
  %53 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %54 = "llvm.call"(%arg8) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_ZN4bssl15BCM_sha512_initEP15sha512_state_st, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (!llvm.ptr) -> i32
  "llvm.return"(%53) : (i32) -> ()
}) : () -> ()
  with @_ZN4bssl15BCM_sha512_initEP15sha512_state_st := BCM_sha512_init

end

end MLIR.Boringssl
