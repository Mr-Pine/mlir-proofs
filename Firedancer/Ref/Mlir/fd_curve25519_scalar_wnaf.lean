module

-- build/llvm23/mlir_canonicalized/ref/op/fd_curve25519_scalar_wnaf.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Ref.Mlir.fd_int_min

meta import MLIR.Semantics.Func
meta import Firedancer.Ref.Mlir.fd_int_min

namespace MLIR.Firedancer.Ref

@[expose] public section

mlir_def fd_curve25519_scalar_wnaf :=
#loop_unroll = #llvm.loop_unroll<disable = true>
#tbaa_root = #llvm.tbaa_root<id = "Simple C/C++ TBAA">
#loop_annotation = #llvm.loop_annotation<unroll = #loop_unroll, mustProgress = true>
#loop_annotation1 = #llvm.loop_annotation<unroll = #loop_unroll>
#tbaa_type_desc = #llvm.tbaa_type_desc<id = "omnipotent char", members = {<#tbaa_root, 0>}>
#tbaa_tag = #llvm.tbaa_tag<base_type = #tbaa_type_desc, access_type = #tbaa_type_desc, offset = 0>
#tbaa_type_desc2 = #llvm.tbaa_type_desc<id = "short", members = {<#tbaa_type_desc, 0>}>
#tbaa_tag2 = #llvm.tbaa_tag<base_type = #tbaa_type_desc2, access_type = #tbaa_type_desc2, offset = 0>
"llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.noundef}], dso_local, function_type = !llvm.func<void (ptr, ptr, i32)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], sym_name = "fd_curve25519_scalar_wnaf", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg79: !llvm.ptr, %arg80: !llvm.ptr, %arg81: i32):
  %1671 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %1672 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %1673 = "llvm.mlir.constant"() <{value = 536870911 : i64}> : () -> i64
  %1674 = "llvm.mlir.constant"() <{value = 7 : i16}> : () -> i16
  %1675 = "llvm.mlir.constant"() <{value = 1 : i16}> : () -> i16
  %1676 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %1677 = "llvm.mlir.constant"() <{value = 255 : i64}> : () -> i64
  %1678 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
  %1679 = "llvm.mlir.constant"() <{value = 0 : i16}> : () -> i16
  %1680 = "llvm.mlir.constant"() <{value = 256 : i64}> : () -> i64
  %1681 = "llvm.mlir.constant"() <{value = 16 : i32}> : () -> i32
  %1682 = "llvm.mlir.constant"() <{value = 15 : i32}> : () -> i32
  %1683 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %1684 = "llvm.mlir.constant"() <{value = 255 : i32}> : () -> i32
  %1685 = "llvm.mlir.constant"() <{value = 65536 : i32}> : () -> i32
  %1686 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %1687 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1688 = "llvm.mlir.constant"() <{value = 256 : i32}> : () -> i32
  "llvm.br"(%1671)[^bb2] : (i64) -> ()
^bb1:  // pred: ^bb2
  %1689 = "llvm.shl"(%1678, %arg81) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %1690 = "llvm.xor"(%1689, %1678) : (i32, i32) -> i32
  %1691 = "llvm.getelementptr"(%arg79) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 510>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1679, %1691) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (i16, !llvm.ptr) -> ()
  "llvm.br"(%1671)[^bb3] : (i64) -> ()
^bb2(%1692: i64):  // 2 preds: ^bb0, ^bb2
  %1693 = "llvm.trunc"(%1692) <{overflowFlags = 0 : i32}> : (i64) -> i16
  %1694 = "llvm.lshr"(%1692, %1672) : (i64, i64) -> i64
  %1695 = "llvm.and"(%1694, %1673) : (i64, i64) -> i64
  %1696 = "llvm.getelementptr"(%arg80, %1695) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1697 = "llvm.load"(%1696) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> i8
  %1698 = "llvm.zext"(%1697) : (i8) -> i16
  %1699 = "llvm.and"(%1693, %1674) : (i16, i16) -> i16
  %1700 = "llvm.lshr"(%1698, %1699) : (i16, i16) -> i16
  %1701 = "llvm.and"(%1700, %1675) : (i16, i16) -> i16
  %1702 = "llvm.getelementptr"(%arg79, %1692) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%1701, %1702) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (i16, !llvm.ptr) -> ()
  %1703 = "llvm.add"(%1692, %1676) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1704 = "llvm.icmp"(%1703, %1677) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1704, %1703)[^bb1, ^bb2] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb3(%1705: i64):  // 2 preds: ^bb1, ^bb4
  %1706 = "llvm.getelementptr"(%arg79, %1705) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1707 = "llvm.load"(%1706) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (!llvm.ptr) -> i16
  %1708 = "llvm.icmp"(%1707, %1679) <{predicate = 0 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%1708)[^bb4, ^bb5] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb4:  // pred: ^bb3
  %1709 = "llvm.add"(%1705, %1676) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1710 = "llvm.icmp"(%1709, %1680) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1710, %1709)[^bb20, ^bb3] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb5:  // pred: ^bb3
  %1711 = "llvm.icmp"(%1705, %1680) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1711)[^bb6, ^bb20] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb6:  // pred: ^bb5
  %1712 = "llvm.trunc"(%1705) <{overflowFlags = 3 : i32}> : (i64) -> i32
  %1713 = "llvm.shl"(%1690, %1681) <{overflowFlags = 0 : i32}> : (i32, i32) -> i32
  %1714 = "llvm.ashr"(%1713, %1681) <{isExact}> : (i32, i32) -> i32
  %1715 = "llvm.ashr"(%1713, %1682) <{isExact}> : (i32, i32) -> i32
  %1716 = "llvm.sub"(%1683, %1714) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  "llvm.br"(%1712)[^bb7] : (i32) -> ()
^bb7(%1717: i32):  // 2 preds: ^bb6, ^bb19
  %1718 = "llvm.icmp"(%1717, %1684) <{predicate = 2 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%1718, %1677, %1675)[^bb8, ^bb18] <{operandSegmentSizes = array<i32: 1, 0, 2>}> : (i1, i64, i16) -> ()
^bb8:  // pred: ^bb7
  %1719 = "llvm.sext"(%1717) : (i32) -> i64
  "llvm.br"(%1719, %1675)[^bb9] : (i64, i16) -> ()
^bb9(%1720: i64, %1721: i16):  // 2 preds: ^bb8, ^bb17
  %1722 = "llvm.add"(%1720, %1676) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1723 = "llvm.getelementptr"(%arg79, %1722) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1724 = "llvm.load"(%1723) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (!llvm.ptr) -> i16
  %1725 = "llvm.icmp"(%1724, %1679) <{predicate = 0 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%1725, %1721)[^bb17, ^bb10] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i16) -> ()
^bb10:  // pred: ^bb9
  %1726 = "llvm.trunc"(%1722) <{overflowFlags = 1 : i32}> : (i64) -> i32
  %1727 = "llvm.sub"(%1726, %1717) <{overflowFlags = 0 : i32}> : (i32, i32) -> i32
  %1728 = "llvm.call"(%1727) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_int_min, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (i32) -> i32
  %1729 = "llvm.shl"(%1685, %1728) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %1730 = "llvm.lshr"(%1729, %1681) <{isExact}> : (i32, i32) -> i32
  %1731 = "llvm.icmp"(%1730, %1715) <{predicate = 4 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%1731, %1726, %1721)[^bb19, ^bb11] <{operandSegmentSizes = array<i32: 1, 2, 0>}> : (i1, i32, i16) -> ()
^bb11:  // pred: ^bb10
  %1732 = "llvm.trunc"(%1730) <{overflowFlags = 3 : i32}> : (i32) -> i16
  %1733 = "llvm.add"(%1721, %1732) <{overflowFlags = 0 : i32}> : (i16, i16) -> i16
  %1734 = "llvm.sext"(%1733) : (i16) -> i32
  %1735 = "llvm.icmp"(%1714, %1734) <{predicate = 2 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%1735)[^bb13, ^bb12] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb12:  // pred: ^bb11
  "llvm.store"(%1679, %1723) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (i16, !llvm.ptr) -> ()
  "llvm.br"(%1733)[^bb17] : (i16) -> ()
^bb13:  // pred: ^bb11
  %1736 = "llvm.sub"(%1721, %1732) <{overflowFlags = 0 : i32}> : (i16, i16) -> i16
  %1737 = "llvm.sext"(%1736) : (i16) -> i32
  %1738 = "llvm.icmp"(%1737, %1716) <{predicate = 2 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%1738, %1726, %1721)[^bb19, ^bb14] <{operandSegmentSizes = array<i32: 1, 2, 0>}> : (i1, i32, i16) -> ()
^bb14:  // pred: ^bb13
  %1739 = "llvm.trunc"(%1720) <{overflowFlags = 1 : i32}> : (i64) -> i32
  "llvm.store"(%1679, %1723) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (i16, !llvm.ptr) -> ()
  %1740 = "llvm.add"(%1739, %1686) <{overflowFlags = 0 : i32}> : (i32, i32) -> i32
  %1741 = "llvm.sext"(%1740) : (i32) -> i64
  %1742 = "llvm.getelementptr"(%arg79, %1741) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1743 = "llvm.load"(%1742) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (!llvm.ptr) -> i16
  %1744 = "llvm.icmp"(%1743, %1679) <{predicate = 0 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%1744, %1740, %1742, %1742, %1740)[^bb15, ^bb16] <{operandSegmentSizes = array<i32: 1, 2, 2>}> : (i1, i32, !llvm.ptr, !llvm.ptr, i32) -> ()
^bb15(%1745: i32, %1746: !llvm.ptr):  // 2 preds: ^bb14, ^bb16
  "llvm.store"(%1675, %1746) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (i16, !llvm.ptr) -> ()
  "llvm.br"(%1745, %1736)[^bb19] : (i32, i16) -> ()
^bb16(%1747: !llvm.ptr, %1748: i32):  // 2 preds: ^bb14, ^bb16
  "llvm.store"(%1679, %1747) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (i16, !llvm.ptr) -> ()
  %1749 = "llvm.add"(%1748, %1687) <{overflowFlags = 0 : i32}> : (i32, i32) -> i32
  %1750 = "llvm.sext"(%1749) : (i32) -> i64
  %1751 = "llvm.getelementptr"(%arg79, %1750) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1752 = "llvm.load"(%1751) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (!llvm.ptr) -> i16
  %1753 = "llvm.icmp"(%1752, %1679) <{predicate = 0 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%1753, %1749, %1751, %1751, %1749)[^bb15, ^bb16] <{loop_annotation = #loop_annotation1, operandSegmentSizes = array<i32: 1, 2, 2>}> : (i1, i32, !llvm.ptr, !llvm.ptr, i32) -> ()
^bb17(%1754: i16):  // 2 preds: ^bb9, ^bb12
  %1755 = "llvm.icmp"(%1722, %1677) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1755, %1719, %1754, %1722, %1754)[^bb18, ^bb9] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 2, 2>}> : (i1, i64, i16, i64, i16) -> ()
^bb18(%1756: i64, %1757: i16):  // 2 preds: ^bb7, ^bb17
  %1758 = "llvm.getelementptr"(%arg79, %1756) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%1757, %1758) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (i16, !llvm.ptr) -> ()
  "llvm.br"()[^bb20] : () -> ()
^bb19(%1759: i32, %1760: i16):  // 3 preds: ^bb10, ^bb13, ^bb15
  %1761 = "llvm.getelementptr"(%arg79, %1719) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%1760, %1761) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (i16, !llvm.ptr) -> ()
  %1762 = "llvm.icmp"(%1759, %1688) <{predicate = 2 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%1762, %1759)[^bb7, ^bb20] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i32) -> ()
^bb20:  // 4 preds: ^bb4, ^bb5, ^bb18, ^bb19
  "llvm.return"() : () -> ()
}) : () -> ()
  with @fd_int_min := fd_int_min

end

end MLIR.Firedancer.Ref
