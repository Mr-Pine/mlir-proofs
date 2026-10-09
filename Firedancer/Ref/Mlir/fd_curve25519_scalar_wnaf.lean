module

-- build/llvm23/mlir_canonicalized/ref/op/fd_curve25519_scalar_wnaf.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Ref.Mlir.fd_ulong_find_lsb
public import Firedancer.Ref.Mlir.fd_ulong_load_8

meta import MLIR.Semantics.Func
meta import Firedancer.Ref.Mlir.fd_ulong_find_lsb
meta import Firedancer.Ref.Mlir.fd_ulong_load_8

namespace MLIR.Firedancer.Ref

@[expose] public section

mlir_def fd_curve25519_scalar_wnaf :=
#loop_unroll = #llvm.loop_unroll<disable = true>
#tbaa_root = #llvm.tbaa_root<id = "Simple C/C++ TBAA">
#loop_annotation = #llvm.loop_annotation<unroll = #loop_unroll, mustProgress = true>
#tbaa_type_desc = #llvm.tbaa_type_desc<id = "omnipotent char", members = {<#tbaa_root, 0>}>
#tbaa_type_desc1 = #llvm.tbaa_type_desc<id = "long", members = {<#tbaa_type_desc, 0>}>
#tbaa_type_desc2 = #llvm.tbaa_type_desc<id = "short", members = {<#tbaa_type_desc, 0>}>
#tbaa_tag1 = #llvm.tbaa_tag<base_type = #tbaa_type_desc1, access_type = #tbaa_type_desc1, offset = 0>
#tbaa_tag2 = #llvm.tbaa_tag<base_type = #tbaa_type_desc2, access_type = #tbaa_type_desc2, offset = 0>
"llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.noundef}], dso_local, function_type = !llvm.func<void (ptr, ptr, i32)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], sym_name = "fd_curve25519_scalar_wnaf", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg82: !llvm.ptr, %arg83: !llvm.ptr, %arg84: i32):
  %1678 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1679 = "llvm.mlir.constant"() <{value = 9223372036854775807 : i64}> : () -> i64
  %1680 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %1681 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %1682 = "llvm.mlir.constant"() <{value = 512 : i64}> : () -> i64
  %1683 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %1684 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %1685 = "llvm.mlir.constant"() <{value = 63 : i64}> : () -> i64
  %1686 = "llvm.mlir.constant"() <{value = 6 : i64}> : () -> i64
  %1687 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %1688 = "llvm.mlir.constant"() <{value = 64 : i64}> : () -> i64
  %1689 = "llvm.mlir.constant"() <{value = 320 : i64}> : () -> i64
  %1690 = "llvm.mlir.constant"() <{value = 4 : i64}> : () -> i64
  %1691 = "llvm.mlir.constant"() <{value = false}> : () -> i1
  %1692 = "llvm.mlir.constant"() <{value = 256 : i64}> : () -> i64
  %1693 = "llvm.alloca"(%1678) <{alignment = 16 : i64, elem_type = !llvm.array<5 x i64>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%1693) : (!llvm.ptr) -> ()
  %1694 = "llvm.call"(%arg83) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_ulong_load_8, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i64
  "llvm.store"(%1694, %1693) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  %1695 = "llvm.getelementptr"(%1693) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %1696 = "llvm.getelementptr"(%arg83) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %1697 = "llvm.call"(%1696) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @fd_ulong_load_8, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i64
  "llvm.store"(%1697, %1695) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  %1698 = "llvm.getelementptr"(%1693) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %1699 = "llvm.getelementptr"(%arg83) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %1700 = "llvm.call"(%1699) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @fd_ulong_load_8, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i64
  "llvm.store"(%1700, %1698) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  %1701 = "llvm.getelementptr"(%1693) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %1702 = "llvm.getelementptr"(%arg83) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %1703 = "llvm.call"(%1702) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @fd_ulong_load_8, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i64
  %1704 = "llvm.and"(%1703, %1679) : (i64, i64) -> i64
  "llvm.store"(%1704, %1701) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  %1705 = "llvm.getelementptr"(%1693) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1680, %1705) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  "llvm.intr.memset"(%arg82, %1681, %1682) <{arg_attrs = [{llvm.align = 2 : i64, llvm.dereferenceable = 512 : i64, llvm.nonnull, llvm.noundef}, {}, {}], isVolatile = false}> : (!llvm.ptr, i8, i64) -> ()
  %1706 = "llvm.sext"(%arg84) : (i32) -> i64
  %1707 = "llvm.add"(%1706, %1683) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1708 = "llvm.shl"(%1683, %1707) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %1709 = "llvm.add"(%1708, %1684) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1710 = "llvm.sub"(%1685, %1706) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  "llvm.br"(%1680)[^bb1] : (i64) -> ()
^bb1(%1711: i64):  // 2 preds: ^bb0, ^bb15
  %1712 = "llvm.lshr"(%1711, %1686) : (i64, i64) -> i64
  %1713 = "llvm.getelementptr"(%1693, %1712) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1714 = "llvm.load"(%1713) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %1715 = "llvm.and"(%1711, %1685) : (i64, i64) -> i64
  %1716 = "llvm.lshr"(%1714, %1715) : (i64, i64) -> i64
  %1717 = "llvm.icmp"(%1716, %1680) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1717, %1714, %1716, %1712, %1711)[^bb2, ^bb6] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 4>}> : (i1, i64, i64, i64, i64) -> ()
^bb2:  // pred: ^bb1
  %1718 = "llvm.icmp"(%1712, %1687) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1718, %1712)[^bb16, ^bb4] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb3:  // pred: ^bb4
  %1719 = "llvm.icmp"(%1721, %1687) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1719, %1721)[^bb16, ^bb4] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb4(%1720: i64):  // 2 preds: ^bb2, ^bb3
  %1721 = "llvm.add"(%1720, %1683) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1722 = "llvm.getelementptr"(%1693, %1721) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1723 = "llvm.load"(%1722) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %1724 = "llvm.icmp"(%1723, %1680) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1724)[^bb3, ^bb5] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb5:  // pred: ^bb4
  %1725 = "llvm.shl"(%1721, %1686) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  "llvm.br"(%1723, %1723, %1721, %1725)[^bb6] : (i64, i64, i64, i64) -> ()
^bb6(%1726: i64, %1727: i64, %1728: i64, %1729: i64):  // 2 preds: ^bb1, ^bb5
  %1730 = "llvm.call"(%1727) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_ulong_find_lsb, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (i64) -> i32
  %1731 = "llvm.sext"(%1730) : (i32) -> i64
  %1732 = "llvm.add"(%1729, %1731) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1733 = "llvm.and"(%1732, %1685) : (i64, i64) -> i64
  %1734 = "llvm.getelementptr"(%1693, %1728) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1735 = "llvm.lshr"(%1726, %1733) : (i64, i64) -> i64
  %1736 = "llvm.icmp"(%1733, %1680) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1736, %1735)[^bb8, ^bb7] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
^bb7:  // pred: ^bb6
  %1737 = "llvm.getelementptr"(%1734) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %1738 = "llvm.load"(%1737) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %1739 = "llvm.sub"(%1688, %1733) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1740 = "llvm.shl"(%1738, %1739) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1741 = "llvm.or"(%1740, %1735) <{isDisjoint}> : (i64, i64) -> i64
  "llvm.br"(%1741)[^bb8] : (i64) -> ()
^bb8(%1742: i64):  // 2 preds: ^bb6, ^bb7
  %1743 = "llvm.and"(%1742, %1709) : (i64, i64) -> i64
  %1744 = "llvm.shl"(%1709, %1733) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1745 = "llvm.xor"(%1744, %1684) : (i64, i64) -> i64
  %1746 = "llvm.and"(%1726, %1745) : (i64, i64) -> i64
  "llvm.store"(%1746, %1734) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  %1747 = "llvm.icmp"(%1733, %1710) <{predicate = 8 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1747)[^bb9, ^bb10] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb9:  // pred: ^bb8
  %1748 = "llvm.sub"(%1688, %1733) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1749 = "llvm.lshr"(%1709, %1748) : (i64, i64) -> i64
  %1750 = "llvm.xor"(%1749, %1684) : (i64, i64) -> i64
  %1751 = "llvm.getelementptr"(%1734) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %1752 = "llvm.load"(%1751) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %1753 = "llvm.and"(%1752, %1750) : (i64, i64) -> i64
  "llvm.store"(%1753, %1751) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  "llvm.br"()[^bb10] : () -> ()
^bb10:  // 2 preds: ^bb8, ^bb9
  %1754 = "llvm.lshr"(%1743, %1706) : (i64, i64) -> i64
  %1755 = "llvm.icmp"(%1754, %1680) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1755)[^bb11, ^bb12] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb11:  // pred: ^bb10
  %1756 = "llvm.trunc"(%1743) <{overflowFlags = 0 : i32}> : (i64) -> i16
  %1757 = "llvm.getelementptr"(%arg82, %1732) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%1756, %1757) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (i16, !llvm.ptr) -> ()
  %1758 = "llvm.add"(%1732, %1707) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.br"(%1758)[^bb15] : (i64) -> ()
^bb12:  // pred: ^bb10
  %1759 = "llvm.sub"(%1743, %1708) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1760 = "llvm.trunc"(%1759) <{overflowFlags = 0 : i32}> : (i64) -> i16
  %1761 = "llvm.getelementptr"(%arg82, %1732) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%1760, %1761) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (i16, !llvm.ptr) -> ()
  %1762 = "llvm.add"(%1732, %1707) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1763 = "llvm.icmp"(%1762, %1689) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1763)[^bb13, ^bb16] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb13:  // pred: ^bb12
  %1764 = "llvm.and"(%1762, %1685) : (i64, i64) -> i64
  %1765 = "llvm.lshr"(%1762, %1686) : (i64, i64) -> i64
  "llvm.br"(%1764, %1765)[^bb14] : (i64, i64) -> ()
^bb14(%1766: i64, %1767: i64):  // 2 preds: ^bb13, ^bb14
  %1768 = "llvm.getelementptr"(%1693, %1767) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1769 = "llvm.load"(%1768) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %1770 = "llvm.shl"(%1683, %1766) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %1771 = "llvm.add"(%1769, %1770) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%1771, %1768) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  %1772 = "llvm.icmp"(%1771, %1769) <{predicate = 6 : i64}> : (i64, i64) -> i1
  %1773 = "llvm.add"(%1767, %1683) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1774 = "llvm.icmp"(%1767, %1690) <{predicate = 6 : i64}> : (i64, i64) -> i1
  %1775 = "llvm.select"(%1772, %1774, %1691) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i1, i1) -> i1
  "llvm.cond_br"(%1775, %1680, %1773, %1762)[^bb14, ^bb15] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 2, 1>}> : (i1, i64, i64, i64) -> ()
^bb15(%1776: i64):  // 2 preds: ^bb11, ^bb14
  %1777 = "llvm.icmp"(%1776, %1692) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1777, %1776)[^bb1, ^bb16] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
^bb16:  // 4 preds: ^bb2, ^bb3, ^bb12, ^bb15
  "llvm.intr.lifetime.end"(%1693) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
  with @fd_ulong_find_lsb := fd_ulong_find_lsb, @fd_ulong_load_8 := fd_ulong_load_8

end

end MLIR.Firedancer.Ref
