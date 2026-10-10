module

-- sodium-build/out/op/crypto_sign_ed25519_verify_detached.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Sodium.Mlir._crypto_sign_ed25519_verify_detached

meta import MLIR.Semantics.Func
meta import Sodium.Mlir._crypto_sign_ed25519_verify_detached

namespace MLIR.Sodium

@[expose] public section

mlir_def crypto_sign_ed25519_verify_detached :=
"llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}], dso_local, function_type = !llvm.func<i32 (ptr, ptr, i64, ptr)>, linkage = #llvm.linkage<external>, no_inline, no_unwind, passthrough = ["ssp", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], sym_name = "crypto_sign_ed25519_verify_detached", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg114: !llvm.ptr, %arg115: !llvm.ptr, %arg116: i64, %arg117: !llvm.ptr):
  %3286 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %3287 = "llvm.call"(%arg114, %arg115, %arg116, %arg117, %3286) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @_crypto_sign_ed25519_verify_detached, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (!llvm.ptr, !llvm.ptr, i64, !llvm.ptr, i32) -> i32
  "llvm.return"(%3287) : (i32) -> ()
}) : () -> ()
  with @_crypto_sign_ed25519_verify_detached := _crypto_sign_ed25519_verify_detached

end

end MLIR.Sodium
