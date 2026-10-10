module

-- boringssl-build/out/op/_ZN4bssl14OPENSSL_memcpyEPvPKvm.mlir
-- bssl::OPENSSL_memcpy(void*, void const*, unsigned long)

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Boringssl

@[expose] public section

mlir_def OPENSSL_memcpy :=
"llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], dso_local, function_type = !llvm.func<ptr (ptr, ptr, i64)>, linkage = #llvm.linkage<internal>, no_inline, no_unwind, passthrough = ["mustprogress", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"], ["warn-stack-size", "25344"]], res_attrs = [{llvm.noundef}], sym_name = "_ZN4bssl14OPENSSL_memcpyEPvPKvm", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg85: !llvm.ptr, %arg86: !llvm.ptr, %arg87: i64):
  %1365 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %1366 = "llvm.icmp"(%arg87, %1365) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1366)[^bb2, ^bb1] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb1:  // pred: ^bb0
  "llvm.intr.memcpy"(%arg85, %arg86, %arg87) <{arg_attrs = [{llvm.align = 1 : i64}, {llvm.align = 1 : i64}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.br"()[^bb2] : () -> ()
^bb2:  // 2 preds: ^bb0, ^bb1
  "llvm.return"(%arg85) : (!llvm.ptr) -> ()
}) : () -> ()

end

end MLIR.Boringssl
