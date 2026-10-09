module

-- build/llvm23/mlir_canonicalized/ref/op/fd_ed25519_point_frombytes_2x.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Ref.Mlir.fd_ed25519_point_frombytes

meta import MLIR.Semantics.Func
meta import Firedancer.Ref.Mlir.fd_ed25519_point_frombytes

namespace MLIR.Firedancer.Ref

@[expose] public section

mlir_def fd_ed25519_point_frombytes_2x :=
"llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nofree, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.nofree, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<i32 (ptr, ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], res_attrs = [{llvm.range = #llvm.constant_range<i32, -2, 1>}], sym_name = "fd_ed25519_point_frombytes_2x", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg93: !llvm.ptr, %arg94: !llvm.ptr, %arg95: !llvm.ptr, %arg96: !llvm.ptr):
  %1820 = "llvm.mlir.zero"() : () -> !llvm.ptr
  %1821 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
  %1822 = "llvm.mlir.constant"() <{value = -2 : i32}> : () -> i32
  %1823 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %1824 = "llvm.call"(%arg93, %arg94) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_frombytes, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %1825 = "llvm.icmp"(%1824, %1820) <{predicate = 0 : i64}> : (!llvm.ptr, !llvm.ptr) -> i1
  "llvm.cond_br"(%1825, %1821)[^bb2, ^bb1] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i32) -> ()
^bb1:  // pred: ^bb0
  %1826 = "llvm.call"(%arg95, %arg96) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_frombytes, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %1827 = "llvm.icmp"(%1826, %1820) <{predicate = 0 : i64}> : (!llvm.ptr, !llvm.ptr) -> i1
  %1828 = "llvm.select"(%1827, %1822, %1823) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i32, i32) -> i32
  "llvm.br"(%1828)[^bb2] : (i32) -> ()
^bb2(%1829: i32):  // 2 preds: ^bb0, ^bb1
  "llvm.return"(%1829) : (i32) -> ()
}) : () -> ()
  with @fd_ed25519_point_frombytes := fd_ed25519_point_frombytes

end

end MLIR.Firedancer.Ref
