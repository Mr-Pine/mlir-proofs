module

-- agave-build/out/serial-noinline-big/op/agave_ed25519_verify.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Agave.Serial.Mlir.Signature_verify_verbose

meta import MLIR.Semantics.Func
meta import Agave.Serial.Mlir.Signature_verify_verbose

namespace MLIR.Agave.Serial

@[expose] public section

noncomputable mlir_def agave_ed25519_verify :=
"llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.dereferenceable = 32 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.dereferenceable = 64 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.noundef}], function_type = !llvm.func<i1 (ptr, ptr, ptr, i64)>, linkage = #llvm.linkage<external>, passthrough = ["nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], res_attrs = [{llvm.noundef, llvm.zeroext}], sym_name = "agave_ed25519_verify", target_cpu = "x86-64-v2", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg102: !llvm.ptr, %arg103: !llvm.ptr, %arg104: !llvm.ptr, %arg105: i64):
  %5477 = "llvm.mlir.constant"() <{value = -1 : i8}> : () -> i8
  %5478 = "llvm.call"(%arg103, %arg102, %arg104, %arg105) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.dereferenceable = 64 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.noundef, llvm.range = #llvm.constant_range<i64, 0, -9223372036854775808>}], callee = @_RNvMs1_Cs4F9oMC2dMu5_16solana_signatureNtB5_9Signature14verify_verbose, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>, res_attrs = [{llvm.noundef}]}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, i64) -> i8
  %5479 = "llvm.icmp"(%5478, %5477) <{predicate = 0 : i64}> : (i8, i8) -> i1
  "llvm.return"(%5479) : (i1) -> ()
}) : () -> ()
  with
    @_RNvMs1_Cs4F9oMC2dMu5_16solana_signatureNtB5_9Signature14verify_verbose := Signature_verify_verbose

end

end MLIR.Agave.Serial
