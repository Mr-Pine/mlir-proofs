module

-- build/llvm23/mlir_canonicalized/ref/op/fd_f25519_if.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Ref.Mlir.fiat_25519_selectznz

meta import MLIR.Semantics.Func
meta import Firedancer.Ref.Mlir.fiat_25519_selectznz

namespace MLIR.Firedancer.Ref

@[expose] public section

mlir_def fd_f25519_if :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nofree, llvm.noundef, llvm.returned, llvm.writeonly}, {llvm.noundef, llvm.range = #llvm.constant_range<i32, 0, 256>}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<ptr (ptr, i32, ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], res_attrs = [{llvm.noundef}], sym_name = "fd_f25519_if", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg166: !llvm.ptr, %arg167: i32, %arg168: !llvm.ptr, %arg169: !llvm.ptr):
  %2153 = "llvm.trunc"(%arg167) <{overflowFlags = 2 : i32}> : (i32) -> i8
  "llvm.call"(%arg166, %2153, %arg169, %arg168) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef, llvm.zeroext}, {llvm.noundef}, {llvm.noundef}], callee = @fiat_25519_selectznz, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, i8, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.return"(%arg166) : (!llvm.ptr) -> ()
}) : () -> ()
  with @fiat_25519_selectznz := fiat_25519_selectznz

end

end MLIR.Firedancer.Ref
