module

-- boringssl-build/out/op/_ZL20fiat_25519_carry_mulPmPKmS1_.mlir
-- fiat_25519_carry_mul(unsigned long*, unsigned long const*, unsigned long const*)

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Boringssl

@[expose] public section

mlir_def fiat_25519_carry_mul :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"], ["warn-stack-size", "25344"]], sym_name = "_ZL20fiat_25519_carry_mulPmPKmS1_", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg139: !llvm.ptr, %arg140: !llvm.ptr, %arg141: !llvm.ptr):
  %1624 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %1625 = "llvm.mlir.constant"() <{value = 51 : i128}> : () -> i128
  %1626 = "llvm.mlir.constant"() <{value = 2251799813685247 : i64}> : () -> i64
  %1627 = "llvm.mlir.constant"() <{value = 18446744073709551615 : i128}> : () -> i128
  %1628 = "llvm.mlir.constant"() <{value = 51 : i64}> : () -> i64
  %1629 = "llvm.getelementptr"(%arg140) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %1630 = "llvm.load"(%1629) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1631 = "llvm.zext"(%1630) : (i64) -> i128
  %1632 = "llvm.getelementptr"(%arg141) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %1633 = "llvm.load"(%1632) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1634 = "llvm.mul"(%1633, %1624) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1635 = "llvm.zext"(%1634) : (i64) -> i128
  %1636 = "llvm.mul"(%1635, %1631) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1637 = "llvm.getelementptr"(%arg141) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %1638 = "llvm.load"(%1637) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1639 = "llvm.mul"(%1638, %1624) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1640 = "llvm.zext"(%1639) : (i64) -> i128
  %1641 = "llvm.mul"(%1640, %1631) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1642 = "llvm.getelementptr"(%arg141) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %1643 = "llvm.load"(%1642) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1644 = "llvm.mul"(%1643, %1624) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1645 = "llvm.zext"(%1644) : (i64) -> i128
  %1646 = "llvm.mul"(%1645, %1631) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1647 = "llvm.getelementptr"(%arg141) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %1648 = "llvm.load"(%1647) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1649 = "llvm.mul"(%1648, %1624) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1650 = "llvm.zext"(%1649) : (i64) -> i128
  %1651 = "llvm.mul"(%1650, %1631) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1652 = "llvm.getelementptr"(%arg140) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %1653 = "llvm.load"(%1652) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1654 = "llvm.zext"(%1653) : (i64) -> i128
  %1655 = "llvm.mul"(%1654, %1635) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1656 = "llvm.mul"(%1654, %1640) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1657 = "llvm.mul"(%1654, %1645) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1658 = "llvm.getelementptr"(%arg140) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %1659 = "llvm.load"(%1658) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1660 = "llvm.zext"(%1659) : (i64) -> i128
  %1661 = "llvm.mul"(%1660, %1635) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1662 = "llvm.mul"(%1660, %1640) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1663 = "llvm.getelementptr"(%arg140) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %1664 = "llvm.load"(%1663) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1665 = "llvm.zext"(%1664) : (i64) -> i128
  %1666 = "llvm.mul"(%1665, %1635) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1667 = "llvm.load"(%arg141) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1668 = "llvm.zext"(%1667) : (i64) -> i128
  %1669 = "llvm.mul"(%1668, %1631) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1670 = "llvm.zext"(%1648) : (i64) -> i128
  %1671 = "llvm.mul"(%1654, %1670) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1672 = "llvm.mul"(%1668, %1654) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1673 = "llvm.zext"(%1643) : (i64) -> i128
  %1674 = "llvm.mul"(%1660, %1673) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1675 = "llvm.mul"(%1660, %1670) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1676 = "llvm.mul"(%1668, %1660) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1677 = "llvm.zext"(%1638) : (i64) -> i128
  %1678 = "llvm.mul"(%1665, %1677) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1679 = "llvm.mul"(%1665, %1673) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1680 = "llvm.mul"(%1665, %1670) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1681 = "llvm.mul"(%1668, %1665) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1682 = "llvm.load"(%arg140) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1683 = "llvm.zext"(%1682) : (i64) -> i128
  %1684 = "llvm.zext"(%1633) : (i64) -> i128
  %1685 = "llvm.mul"(%1683, %1684) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1686 = "llvm.mul"(%1683, %1677) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1687 = "llvm.mul"(%1683, %1673) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1688 = "llvm.mul"(%1683, %1670) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1689 = "llvm.mul"(%1683, %1668) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1690 = "llvm.add"(%1657, %1651) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1691 = "llvm.add"(%1690, %1662) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1692 = "llvm.add"(%1691, %1666) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1693 = "llvm.add"(%1692, %1689) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1694 = "llvm.lshr"(%1693, %1625) : (i128, i128) -> i128
  %1695 = "llvm.trunc"(%1693) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %1696 = "llvm.and"(%1695, %1626) : (i64, i64) -> i64
  %1697 = "llvm.add"(%1655, %1641) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1698 = "llvm.add"(%1656, %1646) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1699 = "llvm.add"(%1698, %1661) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1700 = "llvm.add"(%1699, %1681) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1701 = "llvm.add"(%1700, %1688) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1702 = "llvm.and"(%1694, %1627) : (i128, i128) -> i128
  %1703 = "llvm.add"(%1701, %1702) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1704 = "llvm.lshr"(%1703, %1625) : (i128, i128) -> i128
  %1705 = "llvm.trunc"(%1703) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %1706 = "llvm.and"(%1705, %1626) : (i64, i64) -> i64
  %1707 = "llvm.and"(%1704, %1627) : (i128, i128) -> i128
  %1708 = "llvm.add"(%1697, %1680) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1709 = "llvm.add"(%1708, %1676) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1710 = "llvm.add"(%1709, %1687) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1711 = "llvm.add"(%1710, %1707) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1712 = "llvm.lshr"(%1711, %1625) : (i128, i128) -> i128
  %1713 = "llvm.trunc"(%1711) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %1714 = "llvm.and"(%1713, %1626) : (i64, i64) -> i64
  %1715 = "llvm.and"(%1712, %1627) : (i128, i128) -> i128
  %1716 = "llvm.add"(%1675, %1636) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1717 = "llvm.add"(%1716, %1679) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1718 = "llvm.add"(%1717, %1672) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1719 = "llvm.add"(%1718, %1686) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1720 = "llvm.add"(%1719, %1715) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1721 = "llvm.lshr"(%1720, %1625) : (i128, i128) -> i128
  %1722 = "llvm.trunc"(%1720) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %1723 = "llvm.and"(%1722, %1626) : (i64, i64) -> i64
  %1724 = "llvm.and"(%1721, %1627) : (i128, i128) -> i128
  %1725 = "llvm.add"(%1674, %1671) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1726 = "llvm.add"(%1725, %1678) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1727 = "llvm.add"(%1726, %1669) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1728 = "llvm.add"(%1727, %1685) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1729 = "llvm.add"(%1728, %1724) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1730 = "llvm.lshr"(%1729, %1625) : (i128, i128) -> i128
  %1731 = "llvm.trunc"(%1730) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %1732 = "llvm.trunc"(%1729) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %1733 = "llvm.and"(%1732, %1626) : (i64, i64) -> i64
  %1734 = "llvm.mul"(%1731, %1624) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1735 = "llvm.add"(%1734, %1696) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1736 = "llvm.lshr"(%1735, %1628) : (i64, i64) -> i64
  %1737 = "llvm.and"(%1735, %1626) : (i64, i64) -> i64
  %1738 = "llvm.add"(%1736, %1706) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1739 = "llvm.lshr"(%1738, %1628) : (i64, i64) -> i64
  %1740 = "llvm.and"(%1738, %1626) : (i64, i64) -> i64
  %1741 = "llvm.add"(%1739, %1714) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  "llvm.store"(%1737, %arg139) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1742 = "llvm.getelementptr"(%arg139) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1740, %1742) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1743 = "llvm.getelementptr"(%arg139) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1741, %1743) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1744 = "llvm.getelementptr"(%arg139) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1723, %1744) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1745 = "llvm.getelementptr"(%arg139) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1733, %1745) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end MLIR.Boringssl
