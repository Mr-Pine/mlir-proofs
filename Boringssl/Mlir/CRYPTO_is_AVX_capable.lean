module

-- boringssl-build/out/op/_ZN4bssl21CRYPTO_is_AVX_capableEv.mlir
-- bssl::CRYPTO_is_AVX_capable()

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Boringssl.Extern.OPENSSL_get_ia32cap

meta import MLIR.Semantics.Func
meta import Boringssl.Extern.OPENSSL_get_ia32cap

namespace MLIR.Boringssl

@[expose] public section

noncomputable mlir_def CRYPTO_is_AVX_capable :=
"llvm.func"() <{CConv = #llvm.cconv<ccc>, dso_local, function_type = !llvm.func<i32 ()>, linkage = #llvm.linkage<internal>, no_inline, no_unwind, passthrough = ["mustprogress", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"], ["warn-stack-size", "25344"]], res_attrs = [{llvm.noundef}], sym_name = "_ZN4bssl21CRYPTO_is_AVX_capableEv", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
  %189 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %190 = "llvm.mlir.constant"() <{value = 28 : i32}> : () -> i32
  %191 = "llvm.call"(%189) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_ZN4bssl19OPENSSL_get_ia32capEi, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}], will_return}> : (i32) -> i32
  %192 = "llvm.lshr"(%191, %190) : (i32, i32) -> i32
  %193 = "llvm.and"(%192, %189) : (i32, i32) -> i32
  "llvm.return"(%193) : (i32) -> ()
}) : () -> ()
  with @_ZN4bssl19OPENSSL_get_ia32capEi := OPENSSL_get_ia32cap

end

end MLIR.Boringssl
