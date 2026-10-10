module

-- agave-build/out/avx2-noinline/op/_RNvMs2_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar5214montgomery_mul.mlir
-- <solana_ed25519[c79103de3f6f5451]::backend::serial::u64::scalar::Scalar52>::montgomery_mul

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Agave.Avx2.Mlir.Scalar52_sub

meta import MLIR.Semantics.Func
meta import Agave.Avx2.Mlir.Scalar52_sub

namespace MLIR.Agave.Avx2

@[expose] public section

mlir_def Scalar52_montgomery_mul :=
#alias_scope_domain104 = #llvm.alias_scope_domain<id = distinct[104]<>, description = "_RNvMs2_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar5212mul_internal">
#alias_scope_domain105 = #llvm.alias_scope_domain<id = distinct[105]<>, description = "_RNvMs2_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar5217montgomery_reduce">
#alias_scope_domain106 = #llvm.alias_scope_domain<id = distinct[106]<>, description = "_RNvXCshxoft6be3N1_7zeroizeoNtB2_7Zeroize7zeroizeCsh8hPzWUDumX_14solana_ed25519">
#alias_scope_domain107 = #llvm.alias_scope_domain<id = distinct[107]<>, description = "_RNvXs4_Cshxoft6be3N1_7zeroizeINtNtNtCsgxBkk5gSRhY_4core5slice4iter7IterMutoENtB5_7Zeroize7zeroizeCsh8hPzWUDumX_14solana_ed25519">
#alias_scope179 = #llvm.alias_scope<id = distinct[321]<>, domain = #alias_scope_domain104, description = "_RNvMs2_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar5212mul_internal: argument 0">
#alias_scope180 = #llvm.alias_scope<id = distinct[322]<>, domain = #alias_scope_domain104, description = "_RNvMs2_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar5212mul_internal: argument 1">
#alias_scope181 = #llvm.alias_scope<id = distinct[323]<>, domain = #alias_scope_domain104, description = "_RNvMs2_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar5212mul_internal: argument 2">
#alias_scope182 = #llvm.alias_scope<id = distinct[324]<>, domain = #alias_scope_domain105, description = "_RNvMs2_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar5217montgomery_reduce: argument 0">
#alias_scope183 = #llvm.alias_scope<id = distinct[325]<>, domain = #alias_scope_domain105, description = "_RNvMs2_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar5217montgomery_reduce: argument 1">
#alias_scope184 = #llvm.alias_scope<id = distinct[326]<>, domain = #alias_scope_domain106, description = "_RNvXCshxoft6be3N1_7zeroizeoNtB2_7Zeroize7zeroizeCsh8hPzWUDumX_14solana_ed25519: argument 0">
#alias_scope185 = #llvm.alias_scope<id = distinct[327]<>, domain = #alias_scope_domain107, description = "_RNvXs4_Cshxoft6be3N1_7zeroizeINtNtNtCsgxBkk5gSRhY_4core5slice4iter7IterMutoENtB5_7Zeroize7zeroizeCsh8hPzWUDumX_14solana_ed25519: argument 0">
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 8 : i64, llvm.dead_on_unwind, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writable, llvm.writeonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], sym_name = "_RNvMs2_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar5214montgomery_mul", target_cpu = "x86-64-v2", target_features = #llvm.target_features<["+avx", "+avx2", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+crc32", "+ssse3"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg34: !llvm.ptr, %arg35: !llvm.ptr, %arg36: !llvm.ptr):
  %1555 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1556 = "llvm.mlir.constant"() <{value = 1439961107955227 : i64}> : () -> i64
  %1557 = "llvm.mlir.constant"() <{value = 4503599627370495 : i64}> : () -> i64
  %1558 = "llvm.mlir.constant"() <{value = 671914833335277 : i128}> : () -> i128
  %1559 = "llvm.mlir.constant"() <{value = 52 : i128}> : () -> i128
  %1560 = "llvm.mlir.constant"() <{value = 3916664325105025 : i128}> : () -> i128
  %1561 = "llvm.mlir.constant"() <{value = 1367801 : i128}> : () -> i128
  %1562 = "llvm.mlir.constant"() <{value = 44 : i128}> : () -> i128
  %1563 = "llvm.mlir.constant"() <{value = 0 : i128}> : () -> i128
  %1564 = "llvm.alloca"(%1555) <{alignment = 8 : i64, elem_type = !llvm.array<40 x i8>}> : (i32) -> !llvm.ptr
  %1565 = "llvm.alloca"(%1555) <{alignment = 16 : i64, elem_type = i128}> : (i32) -> !llvm.ptr
  %1566 = "llvm.alloca"(%1555) <{alignment = 16 : i64, elem_type = i128}> : (i32) -> !llvm.ptr
  %1567 = "llvm.alloca"(%1555) <{alignment = 16 : i64, elem_type = i128}> : (i32) -> !llvm.ptr
  %1568 = "llvm.alloca"(%1555) <{alignment = 16 : i64, elem_type = i128}> : (i32) -> !llvm.ptr
  %1569 = "llvm.alloca"(%1555) <{alignment = 16 : i64, elem_type = i128}> : (i32) -> !llvm.ptr
  %1570 = "llvm.alloca"(%1555) <{alignment = 16 : i64, elem_type = i128}> : (i32) -> !llvm.ptr
  %1571 = "llvm.alloca"(%1555) <{alignment = 16 : i64, elem_type = i128}> : (i32) -> !llvm.ptr
  %1572 = "llvm.alloca"(%1555) <{alignment = 16 : i64, elem_type = i128}> : (i32) -> !llvm.ptr
  %1573 = "llvm.alloca"(%1555) <{alignment = 16 : i64, elem_type = i128}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%1565) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1566) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1567) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1568) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1569) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1570) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1571) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1572) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1573) : (!llvm.ptr) -> ()
  "llvm.intr.experimental.noalias.scope.decl"() <{scope = #alias_scope179}> : () -> ()
  "llvm.intr.experimental.noalias.scope.decl"() <{scope = #alias_scope180}> : () -> ()
  "llvm.intr.experimental.noalias.scope.decl"() <{scope = #alias_scope181}> : () -> ()
  %1574 = "llvm.load"(%arg35) <{alias_scopes = [#alias_scope180], alignment = 8 : i64, noalias_scopes = [#alias_scope179, #alias_scope181], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1575 = "llvm.load"(%arg36) <{alias_scopes = [#alias_scope181], alignment = 8 : i64, noalias_scopes = [#alias_scope179, #alias_scope180], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1576 = "llvm.zext"(%1574) : (i64) -> i128
  %1577 = "llvm.zext"(%1575) : (i64) -> i128
  %1578 = "llvm.mul"(%1577, %1576) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1579 = "llvm.getelementptr"(%arg36) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %1580 = "llvm.load"(%1579) <{alias_scopes = [#alias_scope181], alignment = 8 : i64, noalias_scopes = [#alias_scope179, #alias_scope180], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1581 = "llvm.zext"(%1580) : (i64) -> i128
  %1582 = "llvm.mul"(%1581, %1576) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1583 = "llvm.getelementptr"(%arg35) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %1584 = "llvm.load"(%1583) <{alias_scopes = [#alias_scope180], alignment = 8 : i64, noalias_scopes = [#alias_scope179, #alias_scope181], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1585 = "llvm.zext"(%1584) : (i64) -> i128
  %1586 = "llvm.mul"(%1585, %1577) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1587 = "llvm.add"(%1586, %1582) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  "llvm.store"(%1587, %1566) <{alias_scopes = [#alias_scope179], alignment = 16 : i64, noalias_scopes = [#alias_scope180, #alias_scope181], ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
  %1588 = "llvm.getelementptr"(%arg36) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %1589 = "llvm.load"(%1588) <{alias_scopes = [#alias_scope181], alignment = 8 : i64, noalias_scopes = [#alias_scope179, #alias_scope180], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1590 = "llvm.zext"(%1589) : (i64) -> i128
  %1591 = "llvm.mul"(%1590, %1576) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1592 = "llvm.mul"(%1585, %1581) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1593 = "llvm.add"(%1591, %1592) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1594 = "llvm.getelementptr"(%arg35) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %1595 = "llvm.load"(%1594) <{alias_scopes = [#alias_scope180], alignment = 8 : i64, noalias_scopes = [#alias_scope179, #alias_scope181], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1596 = "llvm.zext"(%1595) : (i64) -> i128
  %1597 = "llvm.mul"(%1596, %1577) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1598 = "llvm.add"(%1593, %1597) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  "llvm.store"(%1598, %1567) <{alias_scopes = [#alias_scope179], alignment = 16 : i64, noalias_scopes = [#alias_scope180, #alias_scope181], ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
  %1599 = "llvm.getelementptr"(%arg36) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %1600 = "llvm.load"(%1599) <{alias_scopes = [#alias_scope181], alignment = 8 : i64, noalias_scopes = [#alias_scope179, #alias_scope180], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1601 = "llvm.zext"(%1600) : (i64) -> i128
  %1602 = "llvm.mul"(%1601, %1576) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1603 = "llvm.mul"(%1590, %1585) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1604 = "llvm.mul"(%1596, %1581) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1605 = "llvm.getelementptr"(%arg35) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %1606 = "llvm.load"(%1605) <{alias_scopes = [#alias_scope180], alignment = 8 : i64, noalias_scopes = [#alias_scope179, #alias_scope181], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1607 = "llvm.zext"(%1606) : (i64) -> i128
  %1608 = "llvm.mul"(%1607, %1577) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1609 = "llvm.add"(%1604, %1603) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1610 = "llvm.add"(%1609, %1602) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1611 = "llvm.add"(%1610, %1608) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  "llvm.store"(%1611, %1568) <{alias_scopes = [#alias_scope179], alignment = 16 : i64, noalias_scopes = [#alias_scope180, #alias_scope181], ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
  %1612 = "llvm.getelementptr"(%arg36) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %1613 = "llvm.load"(%1612) <{alias_scopes = [#alias_scope181], alignment = 8 : i64, noalias_scopes = [#alias_scope179, #alias_scope180], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1614 = "llvm.zext"(%1613) : (i64) -> i128
  %1615 = "llvm.mul"(%1614, %1576) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1616 = "llvm.mul"(%1601, %1585) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1617 = "llvm.mul"(%1596, %1590) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1618 = "llvm.mul"(%1607, %1581) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1619 = "llvm.getelementptr"(%arg35) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %1620 = "llvm.load"(%1619) <{alias_scopes = [#alias_scope180], alignment = 8 : i64, noalias_scopes = [#alias_scope179, #alias_scope181], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1621 = "llvm.zext"(%1620) : (i64) -> i128
  %1622 = "llvm.mul"(%1621, %1577) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1623 = "llvm.add"(%1616, %1617) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1624 = "llvm.add"(%1623, %1618) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1625 = "llvm.add"(%1624, %1615) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1626 = "llvm.add"(%1625, %1622) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  "llvm.store"(%1626, %1569) <{alias_scopes = [#alias_scope179], alignment = 16 : i64, noalias_scopes = [#alias_scope180, #alias_scope181], ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
  %1627 = "llvm.mul"(%1614, %1585) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1628 = "llvm.mul"(%1601, %1596) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1629 = "llvm.mul"(%1607, %1590) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1630 = "llvm.mul"(%1621, %1581) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1631 = "llvm.add"(%1629, %1628) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1632 = "llvm.add"(%1631, %1627) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1633 = "llvm.add"(%1632, %1630) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  "llvm.store"(%1633, %1570) <{alias_scopes = [#alias_scope179], alignment = 16 : i64, noalias_scopes = [#alias_scope180, #alias_scope181], ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
  %1634 = "llvm.mul"(%1614, %1596) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1635 = "llvm.mul"(%1607, %1601) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1636 = "llvm.add"(%1634, %1635) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1637 = "llvm.mul"(%1621, %1590) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1638 = "llvm.add"(%1636, %1637) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  "llvm.store"(%1638, %1571) <{alias_scopes = [#alias_scope179], alignment = 16 : i64, noalias_scopes = [#alias_scope180, #alias_scope181], ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
  %1639 = "llvm.mul"(%1614, %1607) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1640 = "llvm.mul"(%1621, %1601) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1641 = "llvm.add"(%1640, %1639) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  "llvm.store"(%1641, %1572) <{alias_scopes = [#alias_scope179], alignment = 16 : i64, noalias_scopes = [#alias_scope180, #alias_scope181], ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
  %1642 = "llvm.mul"(%1621, %1614) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  "llvm.store"(%1642, %1573) <{alias_scopes = [#alias_scope179], alignment = 16 : i64, noalias_scopes = [#alias_scope180, #alias_scope181], ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
  %1643 = "llvm.trunc"(%1578) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %1644 = "llvm.mul"(%1643, %1556) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1645 = "llvm.and"(%1644, %1557) : (i64, i64) -> i64
  %1646 = "llvm.zext"(%1645) <{nonNeg}> : (i64) -> i128
  %1647 = "llvm.mul"(%1646, %1558) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %1648 = "llvm.add"(%1647, %1578) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1649 = "llvm.lshr"(%1648, %1559) : (i128, i128) -> i128
  %1650 = "llvm.mul"(%1646, %1560) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %1651 = "llvm.add"(%1650, %1587) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1652 = "llvm.add"(%1651, %1649) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1653 = "llvm.trunc"(%1652) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %1654 = "llvm.mul"(%1653, %1556) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1655 = "llvm.and"(%1654, %1557) : (i64, i64) -> i64
  %1656 = "llvm.zext"(%1655) <{nonNeg}> : (i64) -> i128
  %1657 = "llvm.mul"(%1656, %1558) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %1658 = "llvm.add"(%1657, %1652) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1659 = "llvm.lshr"(%1658, %1559) : (i128, i128) -> i128
  %1660 = "llvm.mul"(%1646, %1561) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %1661 = "llvm.mul"(%1656, %1560) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %1662 = "llvm.add"(%1598, %1660) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1663 = "llvm.add"(%1662, %1661) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1664 = "llvm.add"(%1663, %1659) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1665 = "llvm.trunc"(%1664) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %1666 = "llvm.mul"(%1665, %1556) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1667 = "llvm.and"(%1666, %1557) : (i64, i64) -> i64
  %1668 = "llvm.zext"(%1667) <{nonNeg}> : (i64) -> i128
  %1669 = "llvm.mul"(%1668, %1558) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %1670 = "llvm.add"(%1669, %1664) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1671 = "llvm.lshr"(%1670, %1559) : (i128, i128) -> i128
  %1672 = "llvm.mul"(%1656, %1561) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %1673 = "llvm.mul"(%1668, %1560) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %1674 = "llvm.add"(%1672, %1611) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1675 = "llvm.add"(%1674, %1673) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1676 = "llvm.add"(%1675, %1671) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1677 = "llvm.trunc"(%1676) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %1678 = "llvm.mul"(%1677, %1556) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1679 = "llvm.and"(%1678, %1557) : (i64, i64) -> i64
  %1680 = "llvm.zext"(%1679) <{nonNeg}> : (i64) -> i128
  %1681 = "llvm.mul"(%1680, %1558) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %1682 = "llvm.add"(%1681, %1676) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1683 = "llvm.lshr"(%1682, %1559) : (i128, i128) -> i128
  %1684 = "llvm.shl"(%1646, %1562) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %1685 = "llvm.mul"(%1668, %1561) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %1686 = "llvm.mul"(%1680, %1560) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %1687 = "llvm.add"(%1626, %1684) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1688 = "llvm.add"(%1687, %1685) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1689 = "llvm.add"(%1688, %1686) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1690 = "llvm.add"(%1689, %1683) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1691 = "llvm.trunc"(%1690) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %1692 = "llvm.mul"(%1691, %1556) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1693 = "llvm.and"(%1692, %1557) : (i64, i64) -> i64
  %1694 = "llvm.zext"(%1693) <{nonNeg}> : (i64) -> i128
  %1695 = "llvm.mul"(%1694, %1558) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %1696 = "llvm.add"(%1695, %1690) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1697 = "llvm.lshr"(%1696, %1559) : (i128, i128) -> i128
  %1698 = "llvm.shl"(%1656, %1562) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %1699 = "llvm.mul"(%1680, %1561) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %1700 = "llvm.mul"(%1694, %1560) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %1701 = "llvm.add"(%1698, %1633) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1702 = "llvm.add"(%1701, %1699) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1703 = "llvm.add"(%1702, %1700) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1704 = "llvm.add"(%1703, %1697) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1705 = "llvm.trunc"(%1704) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %1706 = "llvm.and"(%1705, %1557) : (i64, i64) -> i64
  %1707 = "llvm.lshr"(%1704, %1559) : (i128, i128) -> i128
  %1708 = "llvm.shl"(%1668, %1562) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %1709 = "llvm.mul"(%1694, %1561) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %1710 = "llvm.add"(%1708, %1638) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1711 = "llvm.add"(%1710, %1709) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1712 = "llvm.add"(%1711, %1707) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1713 = "llvm.trunc"(%1712) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %1714 = "llvm.and"(%1713, %1557) : (i64, i64) -> i64
  %1715 = "llvm.lshr"(%1712, %1559) : (i128, i128) -> i128
  %1716 = "llvm.shl"(%1680, %1562) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %1717 = "llvm.add"(%1716, %1641) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1718 = "llvm.add"(%1717, %1715) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1719 = "llvm.trunc"(%1718) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %1720 = "llvm.and"(%1719, %1557) : (i64, i64) -> i64
  %1721 = "llvm.lshr"(%1718, %1559) : (i128, i128) -> i128
  %1722 = "llvm.shl"(%1694, %1562) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %1723 = "llvm.add"(%1722, %1642) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1724 = "llvm.add"(%1723, %1721) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1725 = "llvm.trunc"(%1724) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %1726 = "llvm.and"(%1725, %1557) : (i64, i64) -> i64
  %1727 = "llvm.lshr"(%1724, %1559) : (i128, i128) -> i128
  %1728 = "llvm.trunc"(%1727) <{overflowFlags = 0 : i32}> : (i128) -> i64
  "llvm.intr.lifetime.start"(%1564) : (!llvm.ptr) -> ()
  "llvm.store"(%1706, %1564) <{alignment = 8 : i64, noalias_scopes = [#alias_scope182, #alias_scope183], ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1729 = "llvm.getelementptr"(%1564) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1714, %1729) <{alignment = 8 : i64, noalias_scopes = [#alias_scope182, #alias_scope183], ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1730 = "llvm.getelementptr"(%1564) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1720, %1730) <{alignment = 8 : i64, noalias_scopes = [#alias_scope182, #alias_scope183], ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1731 = "llvm.getelementptr"(%1564) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1726, %1731) <{alignment = 8 : i64, noalias_scopes = [#alias_scope182, #alias_scope183], ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1732 = "llvm.getelementptr"(%1564) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1728, %1732) <{alignment = 8 : i64, noalias_scopes = [#alias_scope182, #alias_scope183], ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.call"(%arg34, %1564) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvMs2_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar523sub, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1564) : (!llvm.ptr) -> ()
  "llvm.store"(%1563, %1565) <{alias_scopes = [#alias_scope184], alignment = 16 : i64, noalias_scopes = [#alias_scope185], ordering = 0 : i64, volatile_}> : (i128, !llvm.ptr) -> ()
  "llvm.fence"() <{ordering = 7 : i64, syncscope = "singlethread"}> : () -> ()
  "llvm.store"(%1563, %1566) <{alias_scopes = [#alias_scope184], alignment = 16 : i64, noalias_scopes = [#alias_scope185], ordering = 0 : i64, volatile_}> : (i128, !llvm.ptr) -> ()
  "llvm.fence"() <{ordering = 7 : i64, syncscope = "singlethread"}> : () -> ()
  "llvm.store"(%1563, %1567) <{alias_scopes = [#alias_scope184], alignment = 16 : i64, noalias_scopes = [#alias_scope185], ordering = 0 : i64, volatile_}> : (i128, !llvm.ptr) -> ()
  "llvm.fence"() <{ordering = 7 : i64, syncscope = "singlethread"}> : () -> ()
  "llvm.store"(%1563, %1568) <{alias_scopes = [#alias_scope184], alignment = 16 : i64, noalias_scopes = [#alias_scope185], ordering = 0 : i64, volatile_}> : (i128, !llvm.ptr) -> ()
  "llvm.fence"() <{ordering = 7 : i64, syncscope = "singlethread"}> : () -> ()
  "llvm.store"(%1563, %1569) <{alias_scopes = [#alias_scope184], alignment = 16 : i64, noalias_scopes = [#alias_scope185], ordering = 0 : i64, volatile_}> : (i128, !llvm.ptr) -> ()
  "llvm.fence"() <{ordering = 7 : i64, syncscope = "singlethread"}> : () -> ()
  "llvm.store"(%1563, %1570) <{alias_scopes = [#alias_scope184], alignment = 16 : i64, noalias_scopes = [#alias_scope185], ordering = 0 : i64, volatile_}> : (i128, !llvm.ptr) -> ()
  "llvm.fence"() <{ordering = 7 : i64, syncscope = "singlethread"}> : () -> ()
  "llvm.store"(%1563, %1571) <{alias_scopes = [#alias_scope184], alignment = 16 : i64, noalias_scopes = [#alias_scope185], ordering = 0 : i64, volatile_}> : (i128, !llvm.ptr) -> ()
  "llvm.fence"() <{ordering = 7 : i64, syncscope = "singlethread"}> : () -> ()
  "llvm.store"(%1563, %1572) <{alias_scopes = [#alias_scope184], alignment = 16 : i64, noalias_scopes = [#alias_scope185], ordering = 0 : i64, volatile_}> : (i128, !llvm.ptr) -> ()
  "llvm.fence"() <{ordering = 7 : i64, syncscope = "singlethread"}> : () -> ()
  "llvm.store"(%1563, %1573) <{alias_scopes = [#alias_scope184], alignment = 16 : i64, noalias_scopes = [#alias_scope185], ordering = 0 : i64, volatile_}> : (i128, !llvm.ptr) -> ()
  "llvm.fence"() <{ordering = 7 : i64, syncscope = "singlethread"}> : () -> ()
  "llvm.intr.lifetime.end"(%1565) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1566) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1567) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1568) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1569) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1570) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1571) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1572) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1573) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
  with
    @_RNvMs2_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar523sub := Scalar52_sub

end

end MLIR.Agave.Avx2
