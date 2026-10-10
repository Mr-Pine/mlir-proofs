module

-- boringssl-build/out/op/_ZL8fe_carryPN4bssl2feEPKNS_8fe_looseE.mlir
-- fe_carry(bssl::fe*, bssl::fe_loose const*)

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Ref.Mlir.fiat_25519_carry

meta import MLIR.Semantics.Func
meta import Firedancer.Ref.Mlir.fiat_25519_carry

namespace MLIR.Boringssl

@[expose] public section

mlir_def fe_carry :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"], ["warn-stack-size", "25344"]], sym_name = "_ZL8fe_carryPN4bssl2feEPKNS_8fe_looseE", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg113: !llvm.ptr, %arg114: !llvm.ptr):
  "llvm.call"(%arg113, %arg114) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @_ZL16fiat_25519_carryPmPKm, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
  with @_ZL16fiat_25519_carryPmPKm := MLIR.Firedancer.Ref.fiat_25519_carry

end

end MLIR.Boringssl
