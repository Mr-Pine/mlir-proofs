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
^bb0(%arg76: !llvm.ptr, %arg77: !llvm.ptr, %arg78: !llvm.ptr, %arg79: !llvm.ptr):
  %1589 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1590 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %1591 = "llvm.mlir.constant"() <{value = 8 : i32}> : () -> i32
  %1592 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %1593 = "llvm.mlir.constant"() <{value = 8 : i64}> : () -> i64
  %1594 = "llvm.mlir.constant"() <{value = 255 : i32}> : () -> i32
  %1595 = "llvm.mlir.constant"() <{value = 0 : i16}> : () -> i16
  %1596 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
  %1597 = "llvm.mlir.constant"() <{value = 1 : i16}> : () -> i16
  %1598 = "llvm.mlir.constant"() <{value = -1 : i16}> : () -> i16
  %1599 = "llvm.mlir.addressof"() <{global_name = @fd_ed25519_base_point_wnaf_table}> : () -> !llvm.ptr
  %1600 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %1601 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %1602 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %1603 = "llvm.alloca"(%1589) <{alignment = 16 : i64, elem_type = !llvm.array<256 x i16>}> : (i32) -> !llvm.ptr
  %1604 = "llvm.alloca"(%1589) <{alignment = 16 : i64, elem_type = !llvm.array<256 x i16>}> : (i32) -> !llvm.ptr
  %1605 = "llvm.alloca"(%1589) <{alignment = 16 : i64, elem_type = !llvm.array<8 x struct<"struct.fd_curve25519_edwards", (array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>, array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>, array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>, array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>)>>}> : (i32) -> !llvm.ptr
  %1606 = "llvm.alloca"(%1589) <{alignment = 16 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_curve25519_edwards", (array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>, array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>, array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>, array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>)>>}> : (i32) -> !llvm.ptr
  %1607 = "llvm.alloca"(%1589) <{alignment = 16 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_curve25519_edwards", (array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>, array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>, array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>, array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>)>>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%1603) : (!llvm.ptr) -> ()
  "llvm.call"(%1603, %arg77, %1590) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_curve25519_scalar_wnaf, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> ()
  "llvm.intr.lifetime.start"(%1604) : (!llvm.ptr) -> ()
  "llvm.call"(%1604, %arg79, %1591) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_curve25519_scalar_wnaf, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> ()
  "llvm.intr.lifetime.start"(%1605) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1606) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1607) : (!llvm.ptr) -> ()
  %1608 = "llvm.call"(%1605, %arg78) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_set, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %1609 = "llvm.call"(%1606, %arg78, %1589) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_dbln, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> !llvm.ptr
  "llvm.call"(%1605) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @fd_curve25519_into_precomputed, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> ()
  "llvm.br"(%1592)[^bb2] : (i64) -> ()
^bb1:  // pred: ^bb2
  %1610 = "llvm.call"(%arg76) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_ed25519_point_set_zero, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.br"(%1594)[^bb3] : (i32) -> ()
^bb2(%1611: i64):  // 2 preds: ^bb0, ^bb2
  %1612 = "llvm.getelementptr"(%1605, %1611) <{elem_type = !llvm.array<160 x i8>, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1613 = "llvm.getelementptr"(%1612) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -160>}> : (!llvm.ptr) -> !llvm.ptr
  %1614 = "llvm.icmp"(%1611, %1592) <{predicate = 0 : i64}> : (i64, i64) -> i1
  %1615 = "llvm.zext"(%1614) : (i1) -> i32
  %1616 = "llvm.call"(%1607, %1606, %1613, %1615, %1589, %1589) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_with_opts, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = readwrite, argMem = readwrite, inaccessibleMem = none, errnoMem = readwrite, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 6, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, i32, i32, i32) -> !llvm.ptr
  %1617 = "llvm.call"(%1612, %1607) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_final_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.call"(%1612) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @fd_curve25519_into_precomputed, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> ()
  %1618 = "llvm.add"(%1611, %1592) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1619 = "llvm.icmp"(%1618, %1593) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1619, %1618)[^bb1, ^bb2] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb3(%1620: i32):  // 2 preds: ^bb1, ^bb5
  %1621 = "llvm.zext"(%1620) <{nonNeg}> : (i32) -> i64
  %1622 = "llvm.getelementptr"(%1603, %1621) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1623 = "llvm.load"(%1622) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (!llvm.ptr) -> i16
  %1624 = "llvm.icmp"(%1623, %1595) <{predicate = 0 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%1624)[^bb4, ^bb6] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb4:  // pred: ^bb3
  %1625 = "llvm.getelementptr"(%1604, %1621) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1626 = "llvm.load"(%1625) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (!llvm.ptr) -> i16
  %1627 = "llvm.icmp"(%1626, %1595) <{predicate = 0 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%1627)[^bb5, ^bb6] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb5:  // pred: ^bb4
  %1628 = "llvm.add"(%1620, %1596) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %1629 = "llvm.icmp"(%1620, %1602) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%1629, %1628)[^bb19, ^bb3] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb6:  // 2 preds: ^bb3, ^bb4
  %1630 = "llvm.icmp"(%1620, %1596) <{predicate = 4 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%1630)[^bb7, ^bb19] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb7:  // pred: ^bb6
  %1631 = "llvm.zext"(%1620) <{nonNeg}> : (i32) -> i64
  "llvm.br"(%1631)[^bb8] : (i64) -> ()
^bb8(%1632: i64):  // 2 preds: ^bb7, ^bb18
  %1633 = "llvm.call"(%1607, %arg76) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_partial_dbl, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %1634 = "llvm.getelementptr"(%1603, %1632) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1635 = "llvm.load"(%1634) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (!llvm.ptr) -> i16
  %1636 = "llvm.icmp"(%1635, %1595) <{predicate = 4 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%1636)[^bb9, ^bb10] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb9:  // pred: ^bb8
  %1637 = "llvm.call"(%arg76, %1607) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_final_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %1638 = "llvm.lshr"(%1635, %1597) : (i16, i16) -> i16
  %1639 = "llvm.zext"(%1638) <{nonNeg}> : (i16) -> i64
  %1640 = "llvm.getelementptr"(%1605, %1639) <{elem_type = !llvm.array<160 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1641 = "llvm.icmp"(%1635, %1597) <{predicate = 0 : i64}> : (i16, i16) -> i1
  %1642 = "llvm.zext"(%1641) : (i1) -> i32
  %1643 = "llvm.call"(%1607, %arg76, %1640, %1642, %1589, %1589) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_with_opts, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = readwrite, argMem = readwrite, inaccessibleMem = none, errnoMem = readwrite, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 6, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, i32, i32, i32) -> !llvm.ptr
  "llvm.br"()[^bb12] : () -> ()
^bb10:  // pred: ^bb8
  %1644 = "llvm.icmp"(%1635, %1595) <{predicate = 2 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%1644)[^bb11, ^bb12] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb11:  // pred: ^bb10
  %1645 = "llvm.call"(%arg76, %1607) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_final_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %1646 = "llvm.sub"(%1595, %1635) <{overflowFlags = 0 : i32}> : (i16, i16) -> i16
  %1647 = "llvm.lshr"(%1646, %1597) : (i16, i16) -> i16
  %1648 = "llvm.zext"(%1647) <{nonNeg}> : (i16) -> i64
  %1649 = "llvm.getelementptr"(%1605, %1648) <{elem_type = !llvm.array<160 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1650 = "llvm.icmp"(%1635, %1598) <{predicate = 0 : i64}> : (i16, i16) -> i1
  %1651 = "llvm.zext"(%1650) : (i1) -> i32
  %1652 = "llvm.call"(%1607, %arg76, %1649, %1651, %1589, %1589) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_sub_with_opts, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = readwrite, argMem = readwrite, inaccessibleMem = none, errnoMem = readwrite, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 6, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, i32, i32, i32) -> !llvm.ptr
  "llvm.br"()[^bb12] : () -> ()
^bb12:  // 3 preds: ^bb9, ^bb10, ^bb11
  %1653 = "llvm.getelementptr"(%1604, %1632) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1654 = "llvm.load"(%1653) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (!llvm.ptr) -> i16
  %1655 = "llvm.icmp"(%1654, %1595) <{predicate = 4 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%1655)[^bb13, ^bb14] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb13:  // pred: ^bb12
  %1656 = "llvm.call"(%arg76, %1607) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_final_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %1657 = "llvm.lshr"(%1654, %1597) : (i16, i16) -> i16
  %1658 = "llvm.zext"(%1657) <{nonNeg}> : (i16) -> i64
  %1659 = "llvm.getelementptr"(%1599, %1658) <{elem_type = !llvm.array<160 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1660 = "llvm.call"(%1607, %arg76, %1659, %1589, %1589, %1589) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_with_opts, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = readwrite, argMem = readwrite, inaccessibleMem = none, errnoMem = readwrite, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 6, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, i32, i32, i32) -> !llvm.ptr
  "llvm.br"()[^bb16] : () -> ()
^bb14:  // pred: ^bb12
  %1661 = "llvm.icmp"(%1654, %1595) <{predicate = 2 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%1661)[^bb15, ^bb16] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb15:  // pred: ^bb14
  %1662 = "llvm.call"(%arg76, %1607) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_final_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %1663 = "llvm.sub"(%1595, %1654) <{overflowFlags = 0 : i32}> : (i16, i16) -> i16
  %1664 = "llvm.lshr"(%1663, %1597) : (i16, i16) -> i16
  %1665 = "llvm.zext"(%1664) <{nonNeg}> : (i16) -> i64
  %1666 = "llvm.getelementptr"(%1599, %1665) <{elem_type = !llvm.array<160 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1667 = "llvm.call"(%1607, %arg76, %1666, %1589, %1589, %1589) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_sub_with_opts, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = readwrite, argMem = readwrite, inaccessibleMem = none, errnoMem = readwrite, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 6, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, i32, i32, i32) -> !llvm.ptr
  "llvm.br"()[^bb16] : () -> ()
^bb16:  // 3 preds: ^bb13, ^bb14, ^bb15
  %1668 = "llvm.icmp"(%1632, %1600) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1668)[^bb17, ^bb18] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb17:  // pred: ^bb16
  %1669 = "llvm.call"(%arg76, %1607) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_final_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.br"()[^bb19] : () -> ()
^bb18:  // pred: ^bb16
  %1670 = "llvm.call"(%arg76, %1607) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_final_mul_projective, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %1671 = "llvm.add"(%1632, %1601) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1672 = "llvm.icmp"(%1632, %1600) <{predicate = 4 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1672, %1671)[^bb8, ^bb19] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
^bb19:  // 4 preds: ^bb5, ^bb6, ^bb17, ^bb18
  "llvm.intr.lifetime.end"(%1607) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1606) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1605) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1604) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1603) : (!llvm.ptr) -> ()
  "llvm.return"(%arg76) : (!llvm.ptr) -> ()
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
