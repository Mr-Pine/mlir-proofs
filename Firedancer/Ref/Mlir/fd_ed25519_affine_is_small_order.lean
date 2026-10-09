module

-- build/llvm23/mlir_canonicalized/ref/op/fd_ed25519_affine_is_small_order.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Ref.Mlir.fd_ed25519_point_to
public import Firedancer.Ref.Mlir.fd_f25519_eq
public import Firedancer.Ref.Mlir.fd_f25519_is_zero
public import Firedancer.Ref.Mlir.fd_ed25519_order8_point_y0
public import Firedancer.Ref.Mlir.fd_ed25519_order8_point_y1

meta import MLIR.Semantics.Func
meta import Firedancer.Ref.Mlir.fd_ed25519_point_to
meta import Firedancer.Ref.Mlir.fd_f25519_eq
meta import Firedancer.Ref.Mlir.fd_f25519_is_zero
meta import Firedancer.Ref.Mlir.fd_ed25519_order8_point_y0
meta import Firedancer.Ref.Mlir.fd_ed25519_order8_point_y1

namespace MLIR.Firedancer.Ref

@[expose] public section

mlir_def fd_ed25519_affine_is_small_order :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<i32 (ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], res_attrs = [{llvm.range = #llvm.constant_range<i32, 0, 2>}], sym_name = "fd_ed25519_affine_is_small_order", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg51: !llvm.ptr):
  %736 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %737 = "llvm.mlir.addressof"() <{global_name = @fd_ed25519_order8_point_y0}> : () -> !llvm.ptr
  %738 = "llvm.mlir.addressof"() <{global_name = @fd_ed25519_order8_point_y1}> : () -> !llvm.ptr
  %739 = "llvm.alloca"(%736) <{alignment = 16 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>}> : (i32) -> !llvm.ptr
  %740 = "llvm.alloca"(%736) <{alignment = 16 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>}> : (i32) -> !llvm.ptr
  %741 = "llvm.alloca"(%736) <{alignment = 16 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>}> : (i32) -> !llvm.ptr
  %742 = "llvm.alloca"(%736) <{alignment = 16 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%739) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%740) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%741) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%742) : (!llvm.ptr) -> ()
  "llvm.call"(%739, %740, %741, %742, %arg51) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_ed25519_point_to, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  %743 = "llvm.call"(%739) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_f25519_is_zero, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i32
  %744 = "llvm.call"(%740) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_f25519_is_zero, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i32
  %745 = "llvm.or"(%744, %743) : (i32, i32) -> i32
  %746 = "llvm.call"(%740, %737) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_f25519_eq, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> i32
  %747 = "llvm.or"(%745, %746) : (i32, i32) -> i32
  %748 = "llvm.call"(%740, %738) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_f25519_eq, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> i32
  %749 = "llvm.or"(%747, %748) : (i32, i32) -> i32
  "llvm.intr.lifetime.end"(%742) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%741) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%740) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%739) : (!llvm.ptr) -> ()
  "llvm.return"(%749) : (i32) -> ()
}) : () -> ()
  with @fd_ed25519_point_to := fd_ed25519_point_to, @fd_f25519_eq := fd_f25519_eq,
    @fd_f25519_is_zero := fd_f25519_is_zero,
    @fd_ed25519_order8_point_y0 := fd_ed25519_order8_point_y0,
    @fd_ed25519_order8_point_y1 := fd_ed25519_order8_point_y1

end

end MLIR.Firedancer.Ref
