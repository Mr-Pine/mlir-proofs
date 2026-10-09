module

-- build/llvm23/mlir_canonicalized/ref/op/fd_ed25519_double_scalar_mul_base.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Ref.Mlir.fd_curve25519_into_precomputed
public import Firedancer.Ref.Mlir.fd_curve25519_scalar_wnaf
public import Firedancer.Ref.Mlir.fd_ed25519_partial_dbl
public import Firedancer.Ref.Mlir.fd_ed25519_point_add_final_mul
public import Firedancer.Ref.Mlir.fd_ed25519_point_add_final_mul_projective
public import Firedancer.Ref.Mlir.fd_ed25519_point_add_with_opts
public import Firedancer.Ref.Mlir.fd_ed25519_point_dbln
public import Firedancer.Ref.Mlir.fd_ed25519_point_set
public import Firedancer.Ref.Mlir.fd_ed25519_point_set_zero
public import Firedancer.Ref.Mlir.fd_ed25519_point_sub_with_opts
public import Firedancer.Ref.Mlir.fd_ed25519_base_point_wnaf_table

meta import MLIR.Semantics.Func
meta import Firedancer.Ref.Mlir.fd_curve25519_into_precomputed
meta import Firedancer.Ref.Mlir.fd_curve25519_scalar_wnaf
meta import Firedancer.Ref.Mlir.fd_ed25519_partial_dbl
meta import Firedancer.Ref.Mlir.fd_ed25519_point_add_final_mul
meta import Firedancer.Ref.Mlir.fd_ed25519_point_add_final_mul_projective
meta import Firedancer.Ref.Mlir.fd_ed25519_point_add_with_opts
meta import Firedancer.Ref.Mlir.fd_ed25519_point_dbln
meta import Firedancer.Ref.Mlir.fd_ed25519_point_set
meta import Firedancer.Ref.Mlir.fd_ed25519_point_set_zero
meta import Firedancer.Ref.Mlir.fd_ed25519_point_sub_with_opts
meta import Firedancer.Ref.Mlir.fd_ed25519_base_point_wnaf_table

namespace MLIR.Firedancer.Ref

@[expose] public section

noncomputable mlir_def fd_ed25519_double_scalar_mul_base :=
#loop_unroll = #llvm.loop_unroll<disable = true>
#tbaa_root = #llvm.tbaa_root<id = "Simple C/C++ TBAA">
#loop_annotation = #llvm.loop_annotation<unroll = #loop_unroll, mustProgress = true>
#tbaa_type_desc = #llvm.tbaa_type_desc<id = "omnipotent char", members = {<#tbaa_root, 0>}>
#tbaa_type_desc2 = #llvm.tbaa_type_desc<id = "short", members = {<#tbaa_type_desc, 0>}>
#tbaa_tag2 = #llvm.tbaa_tag<base_type = #tbaa_type_desc2, access_type = #tbaa_type_desc2, offset = 0>
"llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nofree, llvm.noundef, llvm.returned}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<ptr (ptr, ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = readwrite, argMem = readwrite, inaccessibleMem = none, errnoMem = readwrite, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], res_attrs = [{llvm.noundef}], sym_name = "fd_ed25519_double_scalar_mul_base", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg73: !llvm.ptr, %arg74: !llvm.ptr, %arg75: !llvm.ptr, %arg76: !llvm.ptr):
  %1582 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1583 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %1584 = "llvm.mlir.constant"() <{value = 8 : i32}> : () -> i32
  %1585 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %1586 = "llvm.mlir.constant"() <{value = 8 : i64}> : () -> i64
  %1587 = "llvm.mlir.constant"() <{value = 255 : i32}> : () -> i32
  %1588 = "llvm.mlir.constant"() <{value = 0 : i16}> : () -> i16
  %1589 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
  %1590 = "llvm.mlir.constant"() <{value = 1 : i16}> : () -> i16
  %1591 = "llvm.mlir.constant"() <{value = -1 : i16}> : () -> i16
  %1592 = "llvm.mlir.addressof"() <{global_name = @fd_ed25519_base_point_wnaf_table}> : () -> !llvm.ptr
  %1593 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %1594 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %1595 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %1596 = "llvm.alloca"(%1582) <{alignment = 16 : i64, elem_type = !llvm.array<256 x i16>}> : (i32) -> !llvm.ptr
  %1597 = "llvm.alloca"(%1582) <{alignment = 16 : i64, elem_type = !llvm.array<256 x i16>}> : (i32) -> !llvm.ptr
  %1598 = "llvm.alloca"(%1582) <{alignment = 16 : i64, elem_type = !llvm.array<8 x struct<"struct.fd_curve25519_edwards", (array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>, array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>, array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>, array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>)>>}> : (i32) -> !llvm.ptr
  %1599 = "llvm.alloca"(%1582) <{alignment = 16 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_curve25519_edwards", (array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>, array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>, array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>, array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>)>>}> : (i32) -> !llvm.ptr
  %1600 = "llvm.alloca"(%1582) <{alignment = 16 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_curve25519_edwards", (array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>, array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>, array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>, array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>)>>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%1596) : (!llvm.ptr) -> ()
  "llvm.call"(%1596, %arg74, %1583) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_curve25519_scalar_wnaf, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> ()
  "llvm.intr.lifetime.start"(%1597) : (!llvm.ptr) -> ()
  "llvm.call"(%1597, %arg76, %1584) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_curve25519_scalar_wnaf, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> ()
  "llvm.intr.lifetime.start"(%1598) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1599) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1600) : (!llvm.ptr) -> ()
  %1601 = "llvm.call"(%1598, %arg75) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_set, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %1602 = "llvm.call"(%1599, %arg75, %1582) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_dbln, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> !llvm.ptr
  "llvm.call"(%1598) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_curve25519_into_precomputed, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> ()
  "llvm.br"(%1585)[^bb2] : (i64) -> ()
^bb1:  // pred: ^bb2
  %1603 = "llvm.call"(%arg73) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_ed25519_point_set_zero, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.br"(%1587)[^bb3] : (i32) -> ()
^bb2(%1604: i64):  // 2 preds: ^bb0, ^bb2
  %1605 = "llvm.getelementptr"(%1598, %1604) <{elem_type = !llvm.array<160 x i8>, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1606 = "llvm.getelementptr"(%1605) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -160>}> : (!llvm.ptr) -> !llvm.ptr
  %1607 = "llvm.icmp"(%1604, %1585) <{predicate = 0 : i64}> : (i64, i64) -> i1
  %1608 = "llvm.zext"(%1607) : (i1) -> i32
  %1609 = "llvm.call"(%1600, %1599, %1606, %1608, %1582, %1582) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_with_opts, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = readwrite, argMem = readwrite, inaccessibleMem = none, errnoMem = readwrite, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 6, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, i32, i32, i32) -> !llvm.ptr
  %1610 = "llvm.call"(%1605, %1600) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_final_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.call"(%1605) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_curve25519_into_precomputed, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> ()
  %1611 = "llvm.add"(%1604, %1585) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1612 = "llvm.icmp"(%1611, %1586) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1612, %1611)[^bb1, ^bb2] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb3(%1613: i32):  // 2 preds: ^bb1, ^bb5
  %1614 = "llvm.zext"(%1613) <{nonNeg}> : (i32) -> i64
  %1615 = "llvm.getelementptr"(%1596, %1614) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1616 = "llvm.load"(%1615) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (!llvm.ptr) -> i16
  %1617 = "llvm.icmp"(%1616, %1588) <{predicate = 0 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%1617)[^bb4, ^bb6] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb4:  // pred: ^bb3
  %1618 = "llvm.getelementptr"(%1597, %1614) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1619 = "llvm.load"(%1618) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (!llvm.ptr) -> i16
  %1620 = "llvm.icmp"(%1619, %1588) <{predicate = 0 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%1620)[^bb5, ^bb6] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb5:  // pred: ^bb4
  %1621 = "llvm.add"(%1613, %1589) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %1622 = "llvm.icmp"(%1613, %1595) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%1622, %1621)[^bb19, ^bb3] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb6:  // 2 preds: ^bb3, ^bb4
  %1623 = "llvm.icmp"(%1613, %1589) <{predicate = 4 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%1623)[^bb7, ^bb19] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb7:  // pred: ^bb6
  %1624 = "llvm.zext"(%1613) <{nonNeg}> : (i32) -> i64
  "llvm.br"(%1624)[^bb8] : (i64) -> ()
^bb8(%1625: i64):  // 2 preds: ^bb7, ^bb18
  %1626 = "llvm.call"(%1600, %arg73) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_partial_dbl, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %1627 = "llvm.getelementptr"(%1596, %1625) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1628 = "llvm.load"(%1627) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (!llvm.ptr) -> i16
  %1629 = "llvm.icmp"(%1628, %1588) <{predicate = 4 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%1629)[^bb9, ^bb10] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb9:  // pred: ^bb8
  %1630 = "llvm.call"(%arg73, %1600) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_final_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %1631 = "llvm.lshr"(%1628, %1590) : (i16, i16) -> i16
  %1632 = "llvm.zext"(%1631) <{nonNeg}> : (i16) -> i64
  %1633 = "llvm.getelementptr"(%1598, %1632) <{elem_type = !llvm.array<160 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1634 = "llvm.icmp"(%1628, %1590) <{predicate = 0 : i64}> : (i16, i16) -> i1
  %1635 = "llvm.zext"(%1634) : (i1) -> i32
  %1636 = "llvm.call"(%1600, %arg73, %1633, %1635, %1582, %1582) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_with_opts, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = readwrite, argMem = readwrite, inaccessibleMem = none, errnoMem = readwrite, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 6, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, i32, i32, i32) -> !llvm.ptr
  "llvm.br"()[^bb12] : () -> ()
^bb10:  // pred: ^bb8
  %1637 = "llvm.icmp"(%1628, %1588) <{predicate = 2 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%1637)[^bb11, ^bb12] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb11:  // pred: ^bb10
  %1638 = "llvm.call"(%arg73, %1600) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_final_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %1639 = "llvm.sub"(%1588, %1628) <{overflowFlags = 0 : i32}> : (i16, i16) -> i16
  %1640 = "llvm.lshr"(%1639, %1590) : (i16, i16) -> i16
  %1641 = "llvm.zext"(%1640) <{nonNeg}> : (i16) -> i64
  %1642 = "llvm.getelementptr"(%1598, %1641) <{elem_type = !llvm.array<160 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1643 = "llvm.icmp"(%1628, %1591) <{predicate = 0 : i64}> : (i16, i16) -> i1
  %1644 = "llvm.zext"(%1643) : (i1) -> i32
  %1645 = "llvm.call"(%1600, %arg73, %1642, %1644, %1582, %1582) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_sub_with_opts, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = readwrite, argMem = readwrite, inaccessibleMem = none, errnoMem = readwrite, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 6, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, i32, i32, i32) -> !llvm.ptr
  "llvm.br"()[^bb12] : () -> ()
^bb12:  // 3 preds: ^bb9, ^bb10, ^bb11
  %1646 = "llvm.getelementptr"(%1597, %1625) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1647 = "llvm.load"(%1646) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (!llvm.ptr) -> i16
  %1648 = "llvm.icmp"(%1647, %1588) <{predicate = 4 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%1648)[^bb13, ^bb14] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb13:  // pred: ^bb12
  %1649 = "llvm.call"(%arg73, %1600) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_final_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %1650 = "llvm.lshr"(%1647, %1590) : (i16, i16) -> i16
  %1651 = "llvm.zext"(%1650) <{nonNeg}> : (i16) -> i64
  %1652 = "llvm.getelementptr"(%1592, %1651) <{elem_type = !llvm.array<160 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1653 = "llvm.call"(%1600, %arg73, %1652, %1582, %1582, %1582) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_with_opts, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = readwrite, argMem = readwrite, inaccessibleMem = none, errnoMem = readwrite, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 6, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, i32, i32, i32) -> !llvm.ptr
  "llvm.br"()[^bb16] : () -> ()
^bb14:  // pred: ^bb12
  %1654 = "llvm.icmp"(%1647, %1588) <{predicate = 2 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%1654)[^bb15, ^bb16] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb15:  // pred: ^bb14
  %1655 = "llvm.call"(%arg73, %1600) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_final_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %1656 = "llvm.sub"(%1588, %1647) <{overflowFlags = 0 : i32}> : (i16, i16) -> i16
  %1657 = "llvm.lshr"(%1656, %1590) : (i16, i16) -> i16
  %1658 = "llvm.zext"(%1657) <{nonNeg}> : (i16) -> i64
  %1659 = "llvm.getelementptr"(%1592, %1658) <{elem_type = !llvm.array<160 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1660 = "llvm.call"(%1600, %arg73, %1659, %1582, %1582, %1582) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_sub_with_opts, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = readwrite, argMem = readwrite, inaccessibleMem = none, errnoMem = readwrite, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 6, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, i32, i32, i32) -> !llvm.ptr
  "llvm.br"()[^bb16] : () -> ()
^bb16:  // 3 preds: ^bb13, ^bb14, ^bb15
  %1661 = "llvm.icmp"(%1625, %1593) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1661)[^bb17, ^bb18] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb17:  // pred: ^bb16
  %1662 = "llvm.call"(%arg73, %1600) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_final_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.br"()[^bb19] : () -> ()
^bb18:  // pred: ^bb16
  %1663 = "llvm.call"(%arg73, %1600) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_final_mul_projective, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %1664 = "llvm.add"(%1625, %1594) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1665 = "llvm.icmp"(%1625, %1593) <{predicate = 4 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1665, %1664)[^bb8, ^bb19] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
^bb19:  // 4 preds: ^bb5, ^bb6, ^bb17, ^bb18
  "llvm.intr.lifetime.end"(%1600) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1599) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1598) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1597) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1596) : (!llvm.ptr) -> ()
  "llvm.return"(%arg73) : (!llvm.ptr) -> ()
}) : () -> ()
  with @fd_curve25519_into_precomputed := fd_curve25519_into_precomputed,
    @fd_curve25519_scalar_wnaf := fd_curve25519_scalar_wnaf,
    @fd_ed25519_partial_dbl := fd_ed25519_partial_dbl,
    @fd_ed25519_point_add_final_mul := fd_ed25519_point_add_final_mul,
    @fd_ed25519_point_add_final_mul_projective := fd_ed25519_point_add_final_mul_projective,
    @fd_ed25519_point_add_with_opts := fd_ed25519_point_add_with_opts,
    @fd_ed25519_point_dbln := fd_ed25519_point_dbln, @fd_ed25519_point_set := fd_ed25519_point_set,
    @fd_ed25519_point_set_zero := fd_ed25519_point_set_zero,
    @fd_ed25519_point_sub_with_opts := fd_ed25519_point_sub_with_opts,
    @fd_ed25519_base_point_wnaf_table := fd_ed25519_base_point_wnaf_table

end

end MLIR.Firedancer.Ref
