module

-- boringssl-build/out/op/_ZL7fe_copyPN4bssl2feEPKS0_.mlir
-- fe_copy(bssl::fe*, bssl::fe const*)

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Boringssl.Mlir.OPENSSL_memmove

meta import MLIR.Semantics.Func
meta import Boringssl.Mlir.OPENSSL_memmove

namespace MLIR.Boringssl

@[expose] public section

mlir_def fe_copy :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}], dso_local, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, no_inline, no_unwind, passthrough = ["mustprogress", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"], ["warn-stack-size", "25344"]], sym_name = "_ZL7fe_copyPN4bssl2feEPKS0_", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg49: !llvm.ptr, %arg50: !llvm.ptr):
  %1096 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
  %1097 = "llvm.call"(%arg49, %arg50, %1096) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @_ZN4bssl15OPENSSL_memmoveEPvPKvm, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>, res_attrs = [{llvm.noundef}]}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  "llvm.return"() : () -> ()
}) : () -> ()
  with @_ZN4bssl15OPENSSL_memmoveEPvPKvm := OPENSSL_memmove

end

end MLIR.Boringssl
