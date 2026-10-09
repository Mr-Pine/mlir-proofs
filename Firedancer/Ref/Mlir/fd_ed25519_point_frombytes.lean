module

-- build/llvm23/mlir_canonicalized/ref/op/fd_ed25519_point_frombytes.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Ref.Mlir.fd_ed25519_point_from
public import Firedancer.Ref.Mlir.fd_f25519_add
public import Firedancer.Ref.Mlir.fd_f25519_frombytes
public import Firedancer.Ref.Mlir.fd_f25519_mul
public import Firedancer.Ref.Mlir.fd_f25519_neg
public import Firedancer.Ref.Mlir.fd_f25519_sgn
public import Firedancer.Ref.Mlir.fd_f25519_sqr
public import Firedancer.Ref.Mlir.fd_f25519_sqrt_ratio
public import Firedancer.Ref.Mlir.fd_f25519_sub
public import Firedancer.Ref.Mlir.fd_f25519_d
public import Firedancer.Ref.Mlir.fd_f25519_one

meta import MLIR.Semantics.Func
meta import Firedancer.Ref.Mlir.fd_ed25519_point_from
meta import Firedancer.Ref.Mlir.fd_f25519_add
meta import Firedancer.Ref.Mlir.fd_f25519_frombytes
meta import Firedancer.Ref.Mlir.fd_f25519_mul
meta import Firedancer.Ref.Mlir.fd_f25519_neg
meta import Firedancer.Ref.Mlir.fd_f25519_sgn
meta import Firedancer.Ref.Mlir.fd_f25519_sqr
meta import Firedancer.Ref.Mlir.fd_f25519_sqrt_ratio
meta import Firedancer.Ref.Mlir.fd_f25519_sub
meta import Firedancer.Ref.Mlir.fd_f25519_d
meta import Firedancer.Ref.Mlir.fd_f25519_one

namespace MLIR.Firedancer.Ref

@[expose] public section

mlir_def fd_ed25519_point_frombytes :=
#tbaa_root = #llvm.tbaa_root<id = "Simple C/C++ TBAA">
#tbaa_type_desc = #llvm.tbaa_type_desc<id = "omnipotent char", members = {<#tbaa_root, 0>}>
#tbaa_tag = #llvm.tbaa_tag<base_type = #tbaa_type_desc, access_type = #tbaa_type_desc, offset = 0>
"llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nofree, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<ptr (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], res_attrs = [{llvm.noundef}], sym_name = "fd_ed25519_point_frombytes", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg88: !llvm.ptr, %arg89: !llvm.ptr):
  %1777 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1778 = "llvm.mlir.addressof"() <{global_name = @fd_f25519_d}> : () -> !llvm.ptr
  %1779 = "llvm.mlir.addressof"() <{global_name = @fd_f25519_one}> : () -> !llvm.ptr
  %1780 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %1781 = "llvm.mlir.zero"() : () -> !llvm.ptr
  %1782 = "llvm.mlir.constant"() <{value = 7 : i8}> : () -> i8
  %1783 = "llvm.alloca"(%1777) <{alignment = 16 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>}> : (i32) -> !llvm.ptr
  %1784 = "llvm.alloca"(%1777) <{alignment = 16 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>}> : (i32) -> !llvm.ptr
  %1785 = "llvm.alloca"(%1777) <{alignment = 16 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>}> : (i32) -> !llvm.ptr
  %1786 = "llvm.alloca"(%1777) <{alignment = 16 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>}> : (i32) -> !llvm.ptr
  %1787 = "llvm.alloca"(%1777) <{alignment = 16 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%1783) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1784) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1785) : (!llvm.ptr) -> ()
  %1788 = "llvm.call"(%1784, %arg89) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_f25519_frombytes, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %1789 = "llvm.getelementptr"(%arg89) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 31>}> : (!llvm.ptr) -> !llvm.ptr
  %1790 = "llvm.load"(%1789) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> i8
  "llvm.intr.lifetime.start"(%1786) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1787) : (!llvm.ptr) -> ()
  %1791 = "llvm.call"(%1786, %1784) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_f25519_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %1792 = "llvm.call"(%1787, %1786, %1778) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_f25519_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %1793 = "llvm.call"(%1786, %1786, %1779) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_f25519_sub, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %1794 = "llvm.call"(%1787, %1787, %1779) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_f25519_add, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %1795 = "llvm.call"(%1783, %1786, %1787) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_f25519_sqrt_ratio, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> i32
  %1796 = "llvm.icmp"(%1795, %1780) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%1796, %1781)[^bb4, ^bb1] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, !llvm.ptr) -> ()
^bb1:  // pred: ^bb0
  %1797 = "llvm.lshr"(%1790, %1782) : (i8, i8) -> i8
  %1798 = "llvm.call"(%1783) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @fd_f25519_sgn, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i32
  %1799 = "llvm.zext"(%1797) <{nonNeg}> : (i8) -> i32
  %1800 = "llvm.icmp"(%1798, %1799) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%1800)[^bb3, ^bb2] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb2:  // pred: ^bb1
  %1801 = "llvm.call"(%1783, %1783) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_f25519_neg, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.br"()[^bb3] : () -> ()
^bb3:  // 2 preds: ^bb1, ^bb2
  %1802 = "llvm.call"(%1785, %1783, %1784) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_f25519_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %1803 = "llvm.call"(%arg88, %1783, %1784, %1779, %1785) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_ed25519_point_from, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.br"(%arg88)[^bb4] : (!llvm.ptr) -> ()
^bb4(%1804: !llvm.ptr):  // 2 preds: ^bb0, ^bb3
  "llvm.intr.lifetime.end"(%1787) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1786) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1785) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1784) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1783) : (!llvm.ptr) -> ()
  "llvm.return"(%1804) : (!llvm.ptr) -> ()
}) : () -> ()
  with @fd_ed25519_point_from := fd_ed25519_point_from, @fd_f25519_add := fd_f25519_add,
    @fd_f25519_frombytes := fd_f25519_frombytes, @fd_f25519_mul := fd_f25519_mul,
    @fd_f25519_neg := fd_f25519_neg, @fd_f25519_sgn := fd_f25519_sgn,
    @fd_f25519_sqr := fd_f25519_sqr, @fd_f25519_sqrt_ratio := fd_f25519_sqrt_ratio,
    @fd_f25519_sub := fd_f25519_sub, @fd_f25519_d := fd_f25519_d, @fd_f25519_one := fd_f25519_one

end

end MLIR.Firedancer.Ref
