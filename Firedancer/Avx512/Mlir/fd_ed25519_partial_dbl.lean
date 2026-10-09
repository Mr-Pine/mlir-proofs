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
^bb0(%arg73: !llvm.ptr, %arg74: !llvm.ptr):
  %1588 = "llvm.mlir.constant"() <{value = dense<[8796093022207, 8796093022207, 8796093022207, 8796093022207, 1099511627775, 1099511627775, 1099511627775, 1099511627775]> : vector<8xi64>}> : () -> vector<8xi64>
  %1589 = "llvm.mlir.constant"() <{value = dense<1048576> : vector<8xi64>}> : () -> vector<8xi64>
  %1590 = "llvm.mlir.constant"() <{value = dense<[159383552, 159383552, 159383552, 159383552, 1048576, 1048576, 1048576, 1048576]> : vector<8xi64>}> : () -> vector<8xi64>
  %1591 = "llvm.mlir.constant"() <{value = dense<8796093022207> : vector<8xi64>}> : () -> vector<8xi64>
  %1592 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %1593 = "llvm.mlir.constant"() <{value = dense<[43, 43, 43, 43, 40, 40, 40, 40]> : vector<8xi64>}> : () -> vector<8xi64>
  %1594 = "llvm.mlir.constant"() <{value = dense<43> : vector<8xi64>}> : () -> vector<8xi64>
  %1595 = "llvm.mlir.constant"() <{value = dense<-1048576> : vector<8xi64>}> : () -> vector<8xi64>
  %1596 = "llvm.mlir.constant"() <{value = dense<[-159383552, -159383552, -159383552, -159383552, -1048576, -1048576, -1048576, -1048576]> : vector<8xi64>}> : () -> vector<8xi64>
  %1597 = "llvm.mlir.constant"() <{value = 1099511627775 : i64}> : () -> i64
  %1598 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %1599 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %1600 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %1601 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %1602 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %1603 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %1604 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1605 = "llvm.mlir.poison"() : () -> vector<8xi64>
  %1606 = "llvm.mlir.constant"() <{value = dense<[0, 0, 1, 0, 0, 0, 1, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %1607 = "llvm.mlir.poison"() : () -> i64
  %1608 = "llvm.mlir.constant"() <{value = 8796093022207 : i64}> : () -> i64
  %1609 = "llvm.mlir.constant"() <{value = 8796093022189 : i64}> : () -> i64
  %1610 = "llvm.mlir.undef"() : () -> vector<8xi64>
  %1611 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %1612 = "llvm.insertelement"(%1610, %1607, %1611) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1613 = "llvm.insertelement"(%1612, %1609, %1604) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1614 = "llvm.insertelement"(%1613, %1609, %1603) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1615 = "llvm.insertelement"(%1614, %1607, %1602) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1616 = "llvm.insertelement"(%1615, %1607, %1601) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1617 = "llvm.insertelement"(%1616, %1608, %1600) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1618 = "llvm.insertelement"(%1617, %1608, %1599) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1619 = "llvm.insertelement"(%1618, %1607, %1598) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1620 = "llvm.insertelement"(%1610, %1607, %1611) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1621 = "llvm.insertelement"(%1620, %1608, %1604) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1622 = "llvm.insertelement"(%1621, %1608, %1603) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1623 = "llvm.insertelement"(%1622, %1607, %1602) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1624 = "llvm.insertelement"(%1623, %1607, %1601) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1625 = "llvm.insertelement"(%1624, %1608, %1600) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1626 = "llvm.insertelement"(%1625, %1608, %1599) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1627 = "llvm.insertelement"(%1626, %1607, %1598) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1628 = "llvm.insertelement"(%1610, %1607, %1611) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1629 = "llvm.insertelement"(%1628, %1608, %1604) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1630 = "llvm.insertelement"(%1629, %1608, %1603) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1631 = "llvm.insertelement"(%1630, %1607, %1602) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1632 = "llvm.insertelement"(%1631, %1607, %1601) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1633 = "llvm.insertelement"(%1632, %1597, %1600) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1634 = "llvm.insertelement"(%1633, %1597, %1599) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1635 = "llvm.insertelement"(%1634, %1607, %1598) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1636 = "llvm.insertelement"(%1610, %1609, %1611) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1637 = "llvm.insertelement"(%1636, %1607, %1604) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1638 = "llvm.insertelement"(%1637, %1607, %1603) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1639 = "llvm.insertelement"(%1638, %1607, %1602) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1640 = "llvm.insertelement"(%1639, %1608, %1601) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1641 = "llvm.insertelement"(%1640, %1607, %1600) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1642 = "llvm.insertelement"(%1641, %1607, %1599) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1643 = "llvm.insertelement"(%1642, %1607, %1598) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1644 = "llvm.insertelement"(%1610, %1608, %1611) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1645 = "llvm.insertelement"(%1644, %1607, %1604) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1646 = "llvm.insertelement"(%1645, %1607, %1603) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1647 = "llvm.insertelement"(%1646, %1607, %1602) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1648 = "llvm.insertelement"(%1647, %1608, %1601) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1649 = "llvm.insertelement"(%1648, %1607, %1600) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1650 = "llvm.insertelement"(%1649, %1607, %1599) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1651 = "llvm.insertelement"(%1650, %1607, %1598) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1652 = "llvm.insertelement"(%1610, %1608, %1611) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1653 = "llvm.insertelement"(%1652, %1607, %1604) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1654 = "llvm.insertelement"(%1653, %1607, %1603) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1655 = "llvm.insertelement"(%1654, %1607, %1602) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1656 = "llvm.insertelement"(%1655, %1597, %1601) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1657 = "llvm.insertelement"(%1656, %1607, %1600) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1658 = "llvm.insertelement"(%1657, %1607, %1599) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1659 = "llvm.insertelement"(%1658, %1607, %1598) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1660 = "llvm.insertelement"(%1610, %1607, %1611) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1661 = "llvm.insertelement"(%1660, %1607, %1604) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1662 = "llvm.insertelement"(%1661, %1607, %1603) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1663 = "llvm.insertelement"(%1662, %1607, %1602) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1664 = "llvm.insertelement"(%1663, %1592, %1601) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1665 = "llvm.insertelement"(%1664, %1592, %1600) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1666 = "llvm.insertelement"(%1665, %1592, %1599) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1667 = "llvm.insertelement"(%1666, %1592, %1598) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1668 = "llvm.alloca"(%1604) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %1669 = "llvm.alloca"(%1604) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %1670 = "llvm.alloca"(%1604) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %1671 = "llvm.alloca"(%1604) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %1672 = "llvm.alloca"(%1604) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %1673 = "llvm.alloca"(%1604) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %1674 = "llvm.load"(%arg74) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %1675 = "llvm.shufflevector"(%1674, %1605) <{mask = array<i32: 1, 1, 2, 0, 5, 5, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1676 = "llvm.getelementptr"(%arg74) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %1677 = "llvm.load"(%1676) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %1678 = "llvm.shufflevector"(%1677, %1605) <{mask = array<i32: 1, 1, 2, 0, 5, 5, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1679 = "llvm.getelementptr"(%arg74) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %1680 = "llvm.load"(%1679) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %1681 = "llvm.shufflevector"(%1680, %1605) <{mask = array<i32: 1, 1, 2, 0, 5, 5, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1682 = "llvm.add"(%1675, %1674) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1683 = "llvm.shufflevector"(%1682, %1675) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1684 = "llvm.add"(%1678, %1677) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1685 = "llvm.shufflevector"(%1684, %1678) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1686 = "llvm.add"(%1681, %1680) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1687 = "llvm.shufflevector"(%1686, %1681) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.intr.lifetime.start"(%1668) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1669) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1670) : (!llvm.ptr) -> ()
  "llvm.call"(%1668, %1669, %1670, %1683, %1685, %1687) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_quad_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 6, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
  %1688 = "llvm.load"(%1668) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %1689 = "llvm.load"(%1669) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %1690 = "llvm.load"(%1670) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.intr.lifetime.end"(%1670) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1669) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1668) : (!llvm.ptr) -> ()
  %1691 = "llvm.shl"(%1688, %1606) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1692 = "llvm.shl"(%1689, %1606) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1693 = "llvm.shl"(%1690, %1606) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1694 = "llvm.shufflevector"(%1691, %1605) <{mask = array<i32: 3, 3, 3, 3, 7, 7, 7, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1695 = "llvm.shufflevector"(%1692, %1605) <{mask = array<i32: 3, 3, 3, 3, 7, 7, 7, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1696 = "llvm.shufflevector"(%1693, %1605) <{mask = array<i32: 3, 3, 3, 3, 7, 7, 7, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1697 = "llvm.shufflevector"(%1691, %1605) <{mask = array<i32: 1, 1, 1, 1, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1698 = "llvm.shufflevector"(%1692, %1605) <{mask = array<i32: 1, 1, 1, 1, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1699 = "llvm.shufflevector"(%1693, %1605) <{mask = array<i32: 1, 1, 1, 1, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1700 = "llvm.add"(%1694, %1697) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1701 = "llvm.add"(%1695, %1698) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1702 = "llvm.add"(%1696, %1699) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1703 = "llvm.sub"(%1694, %1697) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1704 = "llvm.add"(%1703, %1619) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1705 = "llvm.shufflevector"(%1700, %1704) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1706 = "llvm.sub"(%1695, %1698) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1707 = "llvm.add"(%1706, %1627) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1708 = "llvm.shufflevector"(%1701, %1707) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1709 = "llvm.sub"(%1696, %1699) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1710 = "llvm.add"(%1709, %1635) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1711 = "llvm.shufflevector"(%1702, %1710) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1712 = "llvm.add"(%1705, %1691) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1713 = "llvm.shufflevector"(%1705, %1712) <{mask = array<i32: 0, 1, 10, 3, 4, 5, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1714 = "llvm.add"(%1708, %1692) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1715 = "llvm.shufflevector"(%1708, %1714) <{mask = array<i32: 0, 1, 10, 3, 4, 5, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1716 = "llvm.add"(%1711, %1693) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1717 = "llvm.shufflevector"(%1711, %1716) <{mask = array<i32: 0, 1, 10, 3, 4, 5, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1718 = "llvm.sub"(%1713, %1691) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1719 = "llvm.add"(%1718, %1643) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1720 = "llvm.shufflevector"(%1719, %1713) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1721 = "llvm.sub"(%1715, %1692) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1722 = "llvm.add"(%1721, %1651) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1723 = "llvm.shufflevector"(%1722, %1715) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1724 = "llvm.sub"(%1717, %1693) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1725 = "llvm.add"(%1724, %1659) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1726 = "llvm.shufflevector"(%1725, %1717) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1727 = "llvm.add"(%1720, %1596) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1728 = "llvm.add"(%1723, %1595) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1729 = "llvm.add"(%1726, %1595) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1730 = "llvm.ashr"(%1727, %1594) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1731 = "llvm.ashr"(%1728, %1594) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1732 = "llvm.ashr"(%1729, %1593) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1733 = "llvm.mul"(%1732, %1667) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1734 = "llvm.and"(%1727, %1591) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1735 = "llvm.shufflevector"(%1733, %1732) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1736 = "llvm.add"(%1734, %1590) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1737 = "llvm.add"(%1736, %1735) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1738 = "llvm.and"(%1728, %1591) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1739 = "llvm.add"(%1730, %1589) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1740 = "llvm.add"(%1739, %1738) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1741 = "llvm.and"(%1729, %1588) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1742 = "llvm.add"(%1731, %1589) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1743 = "llvm.add"(%1742, %1741) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1744 = "llvm.shufflevector"(%1737, %1605) <{mask = array<i32: 0, 1, 1, 0, 4, 5, 5, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1745 = "llvm.shufflevector"(%1740, %1605) <{mask = array<i32: 0, 1, 1, 0, 4, 5, 5, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1746 = "llvm.shufflevector"(%1743, %1605) <{mask = array<i32: 0, 1, 1, 0, 4, 5, 5, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1747 = "llvm.shufflevector"(%1737, %1605) <{mask = array<i32: 2, 3, 2, 3, 6, 7, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1748 = "llvm.shufflevector"(%1740, %1605) <{mask = array<i32: 2, 3, 2, 3, 6, 7, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1749 = "llvm.shufflevector"(%1743, %1605) <{mask = array<i32: 2, 3, 2, 3, 6, 7, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.intr.lifetime.start"(%1671) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1672) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1673) : (!llvm.ptr) -> ()
  "llvm.call"(%1671, %1672, %1673, %1744, %1745, %1746, %1747, %1748, %1749) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_quad_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 9, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
  %1750 = "llvm.load"(%1671) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %1751 = "llvm.load"(%1672) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %1752 = "llvm.load"(%1673) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.intr.lifetime.end"(%1673) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1672) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1671) : (!llvm.ptr) -> ()
  %1753 = "llvm.lshr"(%1750, %1594) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1754 = "llvm.lshr"(%1751, %1594) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1755 = "llvm.lshr"(%1752, %1593) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1756 = "llvm.mul"(%1755, %1667) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1757 = "llvm.and"(%1750, %1591) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1758 = "llvm.shufflevector"(%1756, %1755) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1759 = "llvm.add"(%1758, %1757) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1759, %arg73) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1760 = "llvm.and"(%1751, %1591) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1761 = "llvm.add"(%1760, %1753) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1762 = "llvm.getelementptr"(%arg73) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1761, %1762) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1763 = "llvm.and"(%1752, %1588) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1764 = "llvm.add"(%1763, %1754) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1765 = "llvm.getelementptr"(%arg73) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1764, %1765) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.return"(%arg73) : (!llvm.ptr) -> ()
}) : () -> ()
  with @fd_r43x6_quad_mul_fast := fd_r43x6_quad_mul_fast,
    @fd_r43x6_quad_sqr_fast := fd_r43x6_quad_sqr_fast

end

end MLIR.Firedancer.Avx512
