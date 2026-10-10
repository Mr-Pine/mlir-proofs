module

-- boringssl-build/out/op/SHA512_Update.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Boringssl.Mlir.BCM_sha512_update

meta import MLIR.Semantics.Func
meta import Boringssl.Mlir.BCM_sha512_update

namespace MLIR.Boringssl

@[expose] public section

noncomputable mlir_def SHA512_Update :=
"llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], dso_local, function_type = !llvm.func<i32 (ptr, ptr, i64)>, linkage = #llvm.linkage<internal>, no_inline, no_unwind, passthrough = ["mustprogress", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"], ["warn-stack-size", "25344"]], res_attrs = [{llvm.noundef}], sym_name = "SHA512_Update", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg5: !llvm.ptr, %arg6: !llvm.ptr, %arg7: i64):
  %51 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %52 = "llvm.call"(%arg5, %arg6, %arg7) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @_ZN4bssl17BCM_sha512_updateEP15sha512_state_stPKvm, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>, res_attrs = [{llvm.noundef}]}> : (!llvm.ptr, !llvm.ptr, i64) -> i32
  "llvm.return"(%51) : (i32) -> ()
}) : () -> ()
  with @_ZN4bssl17BCM_sha512_updateEP15sha512_state_stPKvm := BCM_sha512_update

end

end MLIR.Boringssl
