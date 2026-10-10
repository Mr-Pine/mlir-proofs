module

-- boringssl-build/out/op/SHA512_Final.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Boringssl.Mlir.BCM_sha512_final

meta import MLIR.Semantics.Func
meta import Boringssl.Mlir.BCM_sha512_final

namespace MLIR.Boringssl

@[expose] public section

noncomputable mlir_def SHA512_Final :=
"llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], dso_local, function_type = !llvm.func<i32 (ptr, ptr)>, linkage = #llvm.linkage<internal>, no_inline, no_unwind, passthrough = ["mustprogress", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"], ["warn-stack-size", "25344"]], res_attrs = [{llvm.range = #llvm.constant_range<i32, 0, 2>}], sym_name = "SHA512_Final", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg3: !llvm.ptr, %arg4: !llvm.ptr):
  %45 = "llvm.mlir.zero"() : () -> !llvm.ptr
  %46 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %47 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %48 = "llvm.icmp"(%arg3, %45) <{predicate = 0 : i64}> : (!llvm.ptr, !llvm.ptr) -> i1
  "llvm.cond_br"(%48, %46)[^bb2, ^bb1] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i32) -> ()
^bb1:  // pred: ^bb0
  %49 = "llvm.call"(%arg3, %arg4) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @_ZN4bssl16BCM_sha512_finalEPhP15sha512_state_st, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>, res_attrs = [{llvm.noundef}]}> : (!llvm.ptr, !llvm.ptr) -> i32
  "llvm.br"(%47)[^bb2] : (i32) -> ()
^bb2(%50: i32):  // 2 preds: ^bb0, ^bb1
  "llvm.return"(%50) : (i32) -> ()
}) : () -> ()
  with @_ZN4bssl16BCM_sha512_finalEPhP15sha512_state_st := BCM_sha512_final

end

end MLIR.Boringssl
