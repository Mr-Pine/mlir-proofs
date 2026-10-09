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
^bb0(%arg91: !llvm.ptr, %arg92: !llvm.ptr):
  %1792 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1793 = "llvm.mlir.addressof"() <{global_name = @fd_f25519_d}> : () -> !llvm.ptr
  %1794 = "llvm.mlir.addressof"() <{global_name = @fd_f25519_one}> : () -> !llvm.ptr
  %1795 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %1796 = "llvm.mlir.zero"() : () -> !llvm.ptr
  %1797 = "llvm.mlir.constant"() <{value = 7 : i8}> : () -> i8
  %1798 = "llvm.alloca"(%1792) <{alignment = 16 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>}> : (i32) -> !llvm.ptr
  %1799 = "llvm.alloca"(%1792) <{alignment = 16 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>}> : (i32) -> !llvm.ptr
  %1800 = "llvm.alloca"(%1792) <{alignment = 16 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>}> : (i32) -> !llvm.ptr
  %1801 = "llvm.alloca"(%1792) <{alignment = 16 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>}> : (i32) -> !llvm.ptr
  %1802 = "llvm.alloca"(%1792) <{alignment = 16 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%1798) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1799) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1800) : (!llvm.ptr) -> ()
  %1803 = "llvm.call"(%1799, %arg92) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_f25519_frombytes, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %1804 = "llvm.getelementptr"(%arg92) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 31>}> : (!llvm.ptr) -> !llvm.ptr
  %1805 = "llvm.load"(%1804) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> i8
  "llvm.intr.lifetime.start"(%1801) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1802) : (!llvm.ptr) -> ()
  %1806 = "llvm.call"(%1801, %1799) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_f25519_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %1807 = "llvm.call"(%1802, %1801, %1793) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_f25519_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %1808 = "llvm.call"(%1801, %1801, %1794) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_f25519_sub, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %1809 = "llvm.call"(%1802, %1802, %1794) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_f25519_add, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %1810 = "llvm.call"(%1798, %1801, %1802) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_f25519_sqrt_ratio, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> i32
  %1811 = "llvm.icmp"(%1810, %1795) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%1811, %1796)[^bb4, ^bb1] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, !llvm.ptr) -> ()
^bb1:  // pred: ^bb0
  %1812 = "llvm.lshr"(%1805, %1797) : (i8, i8) -> i8
  %1813 = "llvm.call"(%1798) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @fd_f25519_sgn, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i32
  %1814 = "llvm.zext"(%1812) <{nonNeg}> : (i8) -> i32
  %1815 = "llvm.icmp"(%1813, %1814) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%1815)[^bb3, ^bb2] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb2:  // pred: ^bb1
  %1816 = "llvm.call"(%1798, %1798) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_f25519_neg, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.br"()[^bb3] : () -> ()
^bb3:  // 2 preds: ^bb1, ^bb2
  %1817 = "llvm.call"(%1800, %1798, %1799) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_f25519_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %1818 = "llvm.call"(%arg91, %1798, %1799, %1794, %1800) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_ed25519_point_from, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.br"(%arg91)[^bb4] : (!llvm.ptr) -> ()
^bb4(%1819: !llvm.ptr):  // 2 preds: ^bb0, ^bb3
  "llvm.intr.lifetime.end"(%1802) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1801) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1800) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1799) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1798) : (!llvm.ptr) -> ()
  "llvm.return"(%1819) : (!llvm.ptr) -> ()
}) : () -> ()
  with @fd_ed25519_point_from := fd_ed25519_point_from, @fd_f25519_add := fd_f25519_add,
    @fd_f25519_frombytes := fd_f25519_frombytes, @fd_f25519_mul := fd_f25519_mul,
    @fd_f25519_neg := fd_f25519_neg, @fd_f25519_sgn := fd_f25519_sgn,
    @fd_f25519_sqr := fd_f25519_sqr, @fd_f25519_sqrt_ratio := fd_f25519_sqrt_ratio,
    @fd_f25519_sub := fd_f25519_sub, @fd_f25519_d := fd_f25519_d, @fd_f25519_one := fd_f25519_one

end

end MLIR.Firedancer.Ref
