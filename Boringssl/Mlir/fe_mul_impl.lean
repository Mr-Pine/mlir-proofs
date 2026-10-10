module

-- boringssl-build/out/op/_ZL11fe_mul_implPmPKmS1_.mlir
-- fe_mul_impl(unsigned long*, unsigned long const*, unsigned long const*)

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Boringssl.Mlir.fiat_25519_carry_mul

meta import MLIR.Semantics.Func
meta import Boringssl.Mlir.fiat_25519_carry_mul

namespace MLIR.Boringssl

@[expose] public section

mlir_def fe_mul_impl :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"], ["warn-stack-size", "25344"]], sym_name = "_ZL11fe_mul_implPmPKmS1_", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg142: !llvm.ptr, %arg143: !llvm.ptr, %arg144: !llvm.ptr):
  "llvm.call"(%arg142, %arg143, %arg144) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @_ZL20fiat_25519_carry_mulPmPKmS1_, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
  with @_ZL20fiat_25519_carry_mulPmPKmS1_ := fiat_25519_carry_mul

end

end MLIR.Boringssl
