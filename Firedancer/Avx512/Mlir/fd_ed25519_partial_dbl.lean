module

-- build/llvm23/mlir_canonicalized/avx512/op/fd_ed25519_partial_dbl.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Avx512.Mlir.fd_r43x6_quad_mul_fast
public import Firedancer.Avx512.Mlir.fd_r43x6_quad_sqr_fast

meta import MLIR.Semantics.Func
meta import Firedancer.Avx512.Mlir.fd_r43x6_quad_mul_fast
meta import Firedancer.Avx512.Mlir.fd_r43x6_quad_sqr_fast

namespace MLIR.Firedancer.Avx512

@[expose] public section

mlir_def fd_ed25519_partial_dbl :=
#tbaa_root = #llvm.tbaa_root<id = "Simple C/C++ TBAA">
#tbaa_type_desc = #llvm.tbaa_type_desc<id = "omnipotent char", members = {<#tbaa_root, 0>}>
#tbaa_tag = #llvm.tbaa_tag<base_type = #tbaa_type_desc, access_type = #tbaa_type_desc, offset = 0>
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nofree, llvm.nonnull, llvm.noundef, llvm.returned, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<ptr (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], res_attrs = [{llvm.nonnull, llvm.noundef}], sym_name = "fd_ed25519_partial_dbl", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg75: !llvm.ptr, %arg76: !llvm.ptr):
  %1590 = "llvm.mlir.constant"() <{value = dense<[8796093022207, 8796093022207, 8796093022207, 8796093022207, 1099511627775, 1099511627775, 1099511627775, 1099511627775]> : vector<8xi64>}> : () -> vector<8xi64>
  %1591 = "llvm.mlir.constant"() <{value = dense<1048576> : vector<8xi64>}> : () -> vector<8xi64>
  %1592 = "llvm.mlir.constant"() <{value = dense<[159383552, 159383552, 159383552, 159383552, 1048576, 1048576, 1048576, 1048576]> : vector<8xi64>}> : () -> vector<8xi64>
  %1593 = "llvm.mlir.constant"() <{value = dense<8796093022207> : vector<8xi64>}> : () -> vector<8xi64>
  %1594 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %1595 = "llvm.mlir.constant"() <{value = dense<[43, 43, 43, 43, 40, 40, 40, 40]> : vector<8xi64>}> : () -> vector<8xi64>
  %1596 = "llvm.mlir.constant"() <{value = dense<43> : vector<8xi64>}> : () -> vector<8xi64>
  %1597 = "llvm.mlir.constant"() <{value = dense<-1048576> : vector<8xi64>}> : () -> vector<8xi64>
  %1598 = "llvm.mlir.constant"() <{value = dense<[-159383552, -159383552, -159383552, -159383552, -1048576, -1048576, -1048576, -1048576]> : vector<8xi64>}> : () -> vector<8xi64>
  %1599 = "llvm.mlir.constant"() <{value = 1099511627775 : i64}> : () -> i64
  %1600 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %1601 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %1602 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %1603 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %1604 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %1605 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %1606 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1607 = "llvm.mlir.poison"() : () -> vector<8xi64>
  %1608 = "llvm.mlir.constant"() <{value = dense<[0, 0, 1, 0, 0, 0, 1, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %1609 = "llvm.mlir.poison"() : () -> i64
  %1610 = "llvm.mlir.constant"() <{value = 8796093022207 : i64}> : () -> i64
  %1611 = "llvm.mlir.constant"() <{value = 8796093022189 : i64}> : () -> i64
  %1612 = "llvm.mlir.undef"() : () -> vector<8xi64>
  %1613 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %1614 = "llvm.insertelement"(%1612, %1609, %1613) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1615 = "llvm.insertelement"(%1614, %1611, %1606) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1616 = "llvm.insertelement"(%1615, %1611, %1605) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1617 = "llvm.insertelement"(%1616, %1609, %1604) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1618 = "llvm.insertelement"(%1617, %1609, %1603) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1619 = "llvm.insertelement"(%1618, %1610, %1602) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1620 = "llvm.insertelement"(%1619, %1610, %1601) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1621 = "llvm.insertelement"(%1620, %1609, %1600) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1622 = "llvm.insertelement"(%1612, %1609, %1613) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1623 = "llvm.insertelement"(%1622, %1610, %1606) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1624 = "llvm.insertelement"(%1623, %1610, %1605) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1625 = "llvm.insertelement"(%1624, %1609, %1604) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1626 = "llvm.insertelement"(%1625, %1609, %1603) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1627 = "llvm.insertelement"(%1626, %1610, %1602) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1628 = "llvm.insertelement"(%1627, %1610, %1601) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1629 = "llvm.insertelement"(%1628, %1609, %1600) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1630 = "llvm.insertelement"(%1612, %1609, %1613) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1631 = "llvm.insertelement"(%1630, %1610, %1606) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1632 = "llvm.insertelement"(%1631, %1610, %1605) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1633 = "llvm.insertelement"(%1632, %1609, %1604) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1634 = "llvm.insertelement"(%1633, %1609, %1603) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1635 = "llvm.insertelement"(%1634, %1599, %1602) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1636 = "llvm.insertelement"(%1635, %1599, %1601) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1637 = "llvm.insertelement"(%1636, %1609, %1600) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1638 = "llvm.insertelement"(%1612, %1611, %1613) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1639 = "llvm.insertelement"(%1638, %1609, %1606) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1640 = "llvm.insertelement"(%1639, %1609, %1605) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1641 = "llvm.insertelement"(%1640, %1609, %1604) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1642 = "llvm.insertelement"(%1641, %1610, %1603) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1643 = "llvm.insertelement"(%1642, %1609, %1602) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1644 = "llvm.insertelement"(%1643, %1609, %1601) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1645 = "llvm.insertelement"(%1644, %1609, %1600) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1646 = "llvm.insertelement"(%1612, %1610, %1613) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1647 = "llvm.insertelement"(%1646, %1609, %1606) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1648 = "llvm.insertelement"(%1647, %1609, %1605) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1649 = "llvm.insertelement"(%1648, %1609, %1604) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1650 = "llvm.insertelement"(%1649, %1610, %1603) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1651 = "llvm.insertelement"(%1650, %1609, %1602) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1652 = "llvm.insertelement"(%1651, %1609, %1601) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1653 = "llvm.insertelement"(%1652, %1609, %1600) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1654 = "llvm.insertelement"(%1612, %1610, %1613) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1655 = "llvm.insertelement"(%1654, %1609, %1606) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1656 = "llvm.insertelement"(%1655, %1609, %1605) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1657 = "llvm.insertelement"(%1656, %1609, %1604) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1658 = "llvm.insertelement"(%1657, %1599, %1603) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1659 = "llvm.insertelement"(%1658, %1609, %1602) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1660 = "llvm.insertelement"(%1659, %1609, %1601) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1661 = "llvm.insertelement"(%1660, %1609, %1600) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1662 = "llvm.insertelement"(%1612, %1609, %1613) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1663 = "llvm.insertelement"(%1662, %1609, %1606) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1664 = "llvm.insertelement"(%1663, %1609, %1605) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1665 = "llvm.insertelement"(%1664, %1609, %1604) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1666 = "llvm.insertelement"(%1665, %1594, %1603) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1667 = "llvm.insertelement"(%1666, %1594, %1602) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1668 = "llvm.insertelement"(%1667, %1594, %1601) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1669 = "llvm.insertelement"(%1668, %1594, %1600) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1670 = "llvm.alloca"(%1606) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %1671 = "llvm.alloca"(%1606) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %1672 = "llvm.alloca"(%1606) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %1673 = "llvm.alloca"(%1606) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %1674 = "llvm.alloca"(%1606) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %1675 = "llvm.alloca"(%1606) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %1676 = "llvm.load"(%arg76) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %1677 = "llvm.shufflevector"(%1676, %1607) <{mask = array<i32: 1, 1, 2, 0, 5, 5, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1678 = "llvm.getelementptr"(%arg76) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %1679 = "llvm.load"(%1678) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %1680 = "llvm.shufflevector"(%1679, %1607) <{mask = array<i32: 1, 1, 2, 0, 5, 5, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1681 = "llvm.getelementptr"(%arg76) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %1682 = "llvm.load"(%1681) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %1683 = "llvm.shufflevector"(%1682, %1607) <{mask = array<i32: 1, 1, 2, 0, 5, 5, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1684 = "llvm.add"(%1677, %1676) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1685 = "llvm.shufflevector"(%1684, %1677) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1686 = "llvm.add"(%1680, %1679) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1687 = "llvm.shufflevector"(%1686, %1680) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1688 = "llvm.add"(%1683, %1682) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1689 = "llvm.shufflevector"(%1688, %1683) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.intr.lifetime.start"(%1670) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1671) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1672) : (!llvm.ptr) -> ()
  "llvm.call"(%1670, %1671, %1672, %1685, %1687, %1689) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_quad_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 6, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
  %1690 = "llvm.load"(%1670) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %1691 = "llvm.load"(%1671) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %1692 = "llvm.load"(%1672) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.intr.lifetime.end"(%1672) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1671) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1670) : (!llvm.ptr) -> ()
  %1693 = "llvm.shl"(%1690, %1608) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1694 = "llvm.shl"(%1691, %1608) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1695 = "llvm.shl"(%1692, %1608) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1696 = "llvm.shufflevector"(%1693, %1607) <{mask = array<i32: 3, 3, 3, 3, 7, 7, 7, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1697 = "llvm.shufflevector"(%1694, %1607) <{mask = array<i32: 3, 3, 3, 3, 7, 7, 7, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1698 = "llvm.shufflevector"(%1695, %1607) <{mask = array<i32: 3, 3, 3, 3, 7, 7, 7, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1699 = "llvm.shufflevector"(%1693, %1607) <{mask = array<i32: 1, 1, 1, 1, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1700 = "llvm.shufflevector"(%1694, %1607) <{mask = array<i32: 1, 1, 1, 1, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1701 = "llvm.shufflevector"(%1695, %1607) <{mask = array<i32: 1, 1, 1, 1, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1702 = "llvm.add"(%1696, %1699) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1703 = "llvm.add"(%1697, %1700) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1704 = "llvm.add"(%1698, %1701) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1705 = "llvm.sub"(%1696, %1699) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1706 = "llvm.add"(%1705, %1621) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1707 = "llvm.shufflevector"(%1702, %1706) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1708 = "llvm.sub"(%1697, %1700) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1709 = "llvm.add"(%1708, %1629) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1710 = "llvm.shufflevector"(%1703, %1709) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1711 = "llvm.sub"(%1698, %1701) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1712 = "llvm.add"(%1711, %1637) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1713 = "llvm.shufflevector"(%1704, %1712) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1714 = "llvm.add"(%1707, %1693) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1715 = "llvm.shufflevector"(%1707, %1714) <{mask = array<i32: 0, 1, 10, 3, 4, 5, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1716 = "llvm.add"(%1710, %1694) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1717 = "llvm.shufflevector"(%1710, %1716) <{mask = array<i32: 0, 1, 10, 3, 4, 5, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1718 = "llvm.add"(%1713, %1695) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1719 = "llvm.shufflevector"(%1713, %1718) <{mask = array<i32: 0, 1, 10, 3, 4, 5, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1720 = "llvm.sub"(%1715, %1693) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1721 = "llvm.add"(%1720, %1645) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1722 = "llvm.shufflevector"(%1721, %1715) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1723 = "llvm.sub"(%1717, %1694) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1724 = "llvm.add"(%1723, %1653) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1725 = "llvm.shufflevector"(%1724, %1717) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1726 = "llvm.sub"(%1719, %1695) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1727 = "llvm.add"(%1726, %1661) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1728 = "llvm.shufflevector"(%1727, %1719) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1729 = "llvm.add"(%1722, %1598) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1730 = "llvm.add"(%1725, %1597) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1731 = "llvm.add"(%1728, %1597) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1732 = "llvm.ashr"(%1729, %1596) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1733 = "llvm.ashr"(%1730, %1596) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1734 = "llvm.ashr"(%1731, %1595) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1735 = "llvm.mul"(%1734, %1669) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1736 = "llvm.and"(%1729, %1593) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1737 = "llvm.shufflevector"(%1735, %1734) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1738 = "llvm.add"(%1736, %1592) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1739 = "llvm.add"(%1738, %1737) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1740 = "llvm.and"(%1730, %1593) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1741 = "llvm.add"(%1732, %1591) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1742 = "llvm.add"(%1741, %1740) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1743 = "llvm.and"(%1731, %1590) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1744 = "llvm.add"(%1733, %1591) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1745 = "llvm.add"(%1744, %1743) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1746 = "llvm.shufflevector"(%1739, %1607) <{mask = array<i32: 0, 1, 1, 0, 4, 5, 5, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1747 = "llvm.shufflevector"(%1742, %1607) <{mask = array<i32: 0, 1, 1, 0, 4, 5, 5, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1748 = "llvm.shufflevector"(%1745, %1607) <{mask = array<i32: 0, 1, 1, 0, 4, 5, 5, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1749 = "llvm.shufflevector"(%1739, %1607) <{mask = array<i32: 2, 3, 2, 3, 6, 7, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1750 = "llvm.shufflevector"(%1742, %1607) <{mask = array<i32: 2, 3, 2, 3, 6, 7, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1751 = "llvm.shufflevector"(%1745, %1607) <{mask = array<i32: 2, 3, 2, 3, 6, 7, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.intr.lifetime.start"(%1673) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1674) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1675) : (!llvm.ptr) -> ()
  "llvm.call"(%1673, %1674, %1675, %1746, %1747, %1748, %1749, %1750, %1751) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_quad_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 9, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
  %1752 = "llvm.load"(%1673) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %1753 = "llvm.load"(%1674) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %1754 = "llvm.load"(%1675) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.intr.lifetime.end"(%1675) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1674) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1673) : (!llvm.ptr) -> ()
  %1755 = "llvm.lshr"(%1752, %1596) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1756 = "llvm.lshr"(%1753, %1596) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1757 = "llvm.lshr"(%1754, %1595) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1758 = "llvm.mul"(%1757, %1669) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1759 = "llvm.and"(%1752, %1593) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1760 = "llvm.shufflevector"(%1758, %1757) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1761 = "llvm.add"(%1760, %1759) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1761, %arg75) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1762 = "llvm.and"(%1753, %1593) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1763 = "llvm.add"(%1762, %1755) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1764 = "llvm.getelementptr"(%arg75) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1763, %1764) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1765 = "llvm.and"(%1754, %1590) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1766 = "llvm.add"(%1765, %1756) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1767 = "llvm.getelementptr"(%arg75) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1766, %1767) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.return"(%arg75) : (!llvm.ptr) -> ()
}) : () -> ()
  with @fd_r43x6_quad_mul_fast := fd_r43x6_quad_mul_fast,
    @fd_r43x6_quad_sqr_fast := fd_r43x6_quad_sqr_fast

end

end MLIR.Firedancer.Avx512
