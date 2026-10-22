module

-- crc/out/mlirproofs/regions/verify/fd_r52x5_ge_decode2.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_limbs_eq
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_limbs_frombytes
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_add
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_lane_canon
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_mul
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_neg
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_sqr
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_sub
public import Firedancer.Crc.Ed25519.Avx512.Mlir.wl_permute

meta import MLIR.Semantics.Func
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_limbs_eq
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_limbs_frombytes
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_add
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_lane_canon
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_mul
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_neg
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_sqr
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_sub
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.wl_permute

namespace MLIR.Firedancer.Crc.Ed25519.Avx512

@[expose] public section

mlir_def fd_r52x5_ge_decode2 :=
#loop_annotation = #llvm.loop_annotation<mustProgress = true>
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.noundef, llvm.readonly}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<i32 (ptr, ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "256"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], res_attrs = [{llvm.range = #llvm.constant_range<i32, 0, 4>}], sym_name = "fd_r52x5_ge_decode2", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg189: !llvm.ptr, %arg190: !llvm.ptr, %arg191: !llvm.ptr, %arg192: !llvm.ptr):
  %1544 = "llvm.mlir.constant"() <{value = 31 : i32}> : () -> i32
  %1545 = "llvm.mlir.constant"() <{value = 30 : i32}> : () -> i32
  %1546 = "llvm.mlir.constant"() <{value = 29 : i32}> : () -> i32
  %1547 = "llvm.mlir.constant"() <{value = 28 : i32}> : () -> i32
  %1548 = "llvm.mlir.constant"() <{value = 27 : i32}> : () -> i32
  %1549 = "llvm.mlir.constant"() <{value = 26 : i32}> : () -> i32
  %1550 = "llvm.mlir.constant"() <{value = 25 : i32}> : () -> i32
  %1551 = "llvm.mlir.constant"() <{value = 24 : i32}> : () -> i32
  %1552 = "llvm.mlir.constant"() <{value = 23 : i32}> : () -> i32
  %1553 = "llvm.mlir.constant"() <{value = 22 : i32}> : () -> i32
  %1554 = "llvm.mlir.constant"() <{value = 21 : i32}> : () -> i32
  %1555 = "llvm.mlir.constant"() <{value = 19 : i32}> : () -> i32
  %1556 = "llvm.mlir.constant"() <{value = 18 : i32}> : () -> i32
  %1557 = "llvm.mlir.constant"() <{value = 17 : i32}> : () -> i32
  %1558 = "llvm.mlir.constant"() <{value = 16 : i32}> : () -> i32
  %1559 = "llvm.mlir.constant"() <{value = 15 : i32}> : () -> i32
  %1560 = "llvm.mlir.constant"() <{value = 14 : i32}> : () -> i32
  %1561 = "llvm.mlir.constant"() <{value = 13 : i32}> : () -> i32
  %1562 = "llvm.mlir.constant"() <{value = 12 : i32}> : () -> i32
  %1563 = "llvm.mlir.constant"() <{value = 11 : i32}> : () -> i32
  %1564 = "llvm.mlir.constant"() <{value = 10 : i32}> : () -> i32
  %1565 = "llvm.mlir.constant"() <{value = 9 : i32}> : () -> i32
  %1566 = "llvm.mlir.constant"() <{value = 8 : i32}> : () -> i32
  %1567 = "llvm.mlir.undef"() : () -> vector<32xi8>
  %1568 = "llvm.mlir.constant"() <{value = 1 : i8}> : () -> i8
  %1569 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %1570 = "llvm.mlir.poison"() : () -> i8
  %1571 = "llvm.mlir.constant"() <{value = dense<7> : vector<2xi8>}> : () -> vector<2xi8>
  %1572 = "llvm.mlir.poison"() : () -> vector<2xi8>
  %1573 = "llvm.mlir.constant"() <{value = dense<1> : vector<2xi32>}> : () -> vector<2xi32>
  %1574 = "llvm.mlir.poison"() : () -> vector<2xi32>
  %1575 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %1576 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %1577 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %1578 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %1579 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %1580 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %1581 = "llvm.mlir.undef"() : () -> vector<8xi32>
  %1582 = "llvm.mlir.poison"() : () -> i32
  %1583 = "llvm.mlir.constant"() <{value = dense<765476049583133> : vector<4xi64>}> : () -> vector<4xi64>
  %1584 = "llvm.mlir.constant"() <{value = dense<2117202627021982> : vector<4xi64>}> : () -> vector<4xi64>
  %1585 = "llvm.mlir.constant"() <{value = dense<2233514472574048> : vector<4xi64>}> : () -> vector<4xi64>
  %1586 = "llvm.mlir.constant"() <{value = dense<234908883556509> : vector<4xi64>}> : () -> vector<4xi64>
  %1587 = "llvm.mlir.constant"() <{value = dense<1718705420411056> : vector<4xi64>}> : () -> vector<4xi64>
  %1588 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
  %1589 = "llvm.mlir.constant"() <{value = 100 : i32}> : () -> i32
  %1590 = "llvm.mlir.constant"() <{value = 50 : i32}> : () -> i32
  %1591 = "llvm.mlir.constant"() <{value = 20 : i32}> : () -> i32
  %1592 = "llvm.mlir.constant"() <{value = dense<1442794654840575> : vector<4xi64>}> : () -> vector<4xi64>
  %1593 = "llvm.mlir.constant"() <{value = dense<2033849074728123> : vector<4xi64>}> : () -> vector<4xi64>
  %1594 = "llvm.mlir.constant"() <{value = dense<1662059464998953> : vector<4xi64>}> : () -> vector<4xi64>
  %1595 = "llvm.mlir.constant"() <{value = dense<466365720129213> : vector<4xi64>}> : () -> vector<4xi64>
  %1596 = "llvm.mlir.constant"() <{value = dense<929955233495203> : vector<4xi64>}> : () -> vector<4xi64>
  %1597 = "llvm.mlir.constant"() <{value = dense<0> : vector<4xi64>}> : () -> vector<4xi64>
  %1598 = "llvm.mlir.constant"() <{value = dense<1> : vector<4xi64>}> : () -> vector<4xi64>
  %1599 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %1600 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %1601 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %1602 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1603 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %1604 = "llvm.mlir.poison"() : () -> i64
  %1605 = "llvm.mlir.undef"() : () -> vector<4xi64>
  %1606 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %1607 = "llvm.insertelement"(%1605, %1604, %1606) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %1608 = "llvm.insertelement"(%1607, %1604, %1602) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %1609 = "llvm.insertelement"(%1608, %1603, %1601) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %1610 = "llvm.insertelement"(%1609, %1603, %1600) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %1611 = "llvm.insertelement"(%1581, %1582, %1606) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1612 = "llvm.insertelement"(%1611, %1582, %1602) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1613 = "llvm.insertelement"(%1612, %1582, %1601) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1614 = "llvm.insertelement"(%1613, %1582, %1600) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1615 = "llvm.insertelement"(%1614, %1606, %1580) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1616 = "llvm.insertelement"(%1615, %1606, %1579) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1617 = "llvm.insertelement"(%1616, %1606, %1578) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1618 = "llvm.insertelement"(%1617, %1606, %1577) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1619 = "llvm.insertelement"(%1567, %1570, %1606) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1620 = "llvm.insertelement"(%1619, %1570, %1602) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1621 = "llvm.insertelement"(%1620, %1570, %1601) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1622 = "llvm.insertelement"(%1621, %1570, %1600) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1623 = "llvm.insertelement"(%1622, %1570, %1580) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1624 = "llvm.insertelement"(%1623, %1570, %1579) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1625 = "llvm.insertelement"(%1624, %1570, %1578) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1626 = "llvm.insertelement"(%1625, %1570, %1577) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1627 = "llvm.insertelement"(%1626, %1570, %1566) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1628 = "llvm.insertelement"(%1627, %1570, %1565) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1629 = "llvm.insertelement"(%1628, %1570, %1564) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1630 = "llvm.insertelement"(%1629, %1570, %1563) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1631 = "llvm.insertelement"(%1630, %1570, %1562) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1632 = "llvm.insertelement"(%1631, %1570, %1561) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1633 = "llvm.insertelement"(%1632, %1570, %1560) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1634 = "llvm.insertelement"(%1633, %1570, %1559) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1635 = "llvm.insertelement"(%1634, %1568, %1558) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1636 = "llvm.insertelement"(%1635, %1569, %1557) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1637 = "llvm.insertelement"(%1636, %1569, %1556) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1638 = "llvm.insertelement"(%1637, %1569, %1555) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1639 = "llvm.insertelement"(%1638, %1569, %1591) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1640 = "llvm.insertelement"(%1639, %1569, %1554) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1641 = "llvm.insertelement"(%1640, %1569, %1553) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1642 = "llvm.insertelement"(%1641, %1569, %1552) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1643 = "llvm.insertelement"(%1642, %1570, %1551) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1644 = "llvm.insertelement"(%1643, %1570, %1550) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1645 = "llvm.insertelement"(%1644, %1570, %1549) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1646 = "llvm.insertelement"(%1645, %1570, %1548) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1647 = "llvm.insertelement"(%1646, %1570, %1547) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1648 = "llvm.insertelement"(%1647, %1570, %1546) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1649 = "llvm.insertelement"(%1648, %1570, %1545) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1650 = "llvm.insertelement"(%1649, %1570, %1544) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1651 = "llvm.insertelement"(%1567, %1570, %1606) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1652 = "llvm.insertelement"(%1651, %1570, %1602) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1653 = "llvm.insertelement"(%1652, %1570, %1601) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1654 = "llvm.insertelement"(%1653, %1570, %1600) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1655 = "llvm.insertelement"(%1654, %1570, %1580) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1656 = "llvm.insertelement"(%1655, %1570, %1579) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1657 = "llvm.insertelement"(%1656, %1570, %1578) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1658 = "llvm.insertelement"(%1657, %1570, %1577) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1659 = "llvm.insertelement"(%1658, %1570, %1566) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1660 = "llvm.insertelement"(%1659, %1570, %1565) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1661 = "llvm.insertelement"(%1660, %1570, %1564) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1662 = "llvm.insertelement"(%1661, %1570, %1563) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1663 = "llvm.insertelement"(%1662, %1570, %1562) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1664 = "llvm.insertelement"(%1663, %1570, %1561) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1665 = "llvm.insertelement"(%1664, %1570, %1560) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1666 = "llvm.insertelement"(%1665, %1570, %1559) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1667 = "llvm.insertelement"(%1666, %1569, %1558) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1668 = "llvm.insertelement"(%1667, %1569, %1557) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1669 = "llvm.insertelement"(%1668, %1569, %1556) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1670 = "llvm.insertelement"(%1669, %1569, %1555) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1671 = "llvm.insertelement"(%1670, %1569, %1591) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1672 = "llvm.insertelement"(%1671, %1569, %1554) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1673 = "llvm.insertelement"(%1672, %1569, %1553) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1674 = "llvm.insertelement"(%1673, %1569, %1552) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1675 = "llvm.insertelement"(%1674, %1570, %1551) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1676 = "llvm.insertelement"(%1675, %1570, %1550) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1677 = "llvm.insertelement"(%1676, %1570, %1549) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1678 = "llvm.insertelement"(%1677, %1570, %1548) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1679 = "llvm.insertelement"(%1678, %1570, %1547) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1680 = "llvm.insertelement"(%1679, %1570, %1546) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1681 = "llvm.insertelement"(%1680, %1570, %1545) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1682 = "llvm.insertelement"(%1681, %1570, %1544) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %1683 = "llvm.alloca"(%1602) <{alignment = 16 : i64, elem_type = !llvm.array<5 x i64>}> : (i32) -> !llvm.ptr
  %1684 = "llvm.alloca"(%1602) <{alignment = 16 : i64, elem_type = !llvm.array<5 x i64>}> : (i32) -> !llvm.ptr
  %1685 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1686 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1687 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1688 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1689 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1690 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1691 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1692 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1693 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1694 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1695 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1696 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1697 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1698 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1699 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1700 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1701 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1702 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1703 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1704 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1705 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1706 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1707 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1708 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1709 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1710 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1711 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1712 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1713 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1714 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1715 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1716 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1717 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1718 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1719 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1720 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1721 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1722 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1723 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1724 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1725 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1726 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1727 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1728 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1729 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1730 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1731 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1732 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1733 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1734 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1735 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1736 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1737 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1738 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1739 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1740 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1741 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1742 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1743 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1744 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1745 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1746 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1747 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1748 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1749 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1750 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1751 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1752 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1753 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1754 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1755 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1756 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1757 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1758 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1759 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1760 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1761 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1762 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1763 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1764 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1765 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1766 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1767 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1768 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1769 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1770 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1771 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1772 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1773 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1774 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1775 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1776 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1777 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1778 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1779 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1780 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1781 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1782 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1783 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1784 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1785 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1786 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1787 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1788 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1789 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1790 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1791 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1792 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1793 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1794 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1795 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1796 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1797 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1798 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1799 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1800 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1801 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1802 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1803 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1804 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1805 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1806 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1807 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1808 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1809 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1810 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1811 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1812 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1813 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1814 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1815 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1816 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1817 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1818 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1819 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1820 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1821 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1822 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1823 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1824 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1825 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1826 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1827 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1828 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1829 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1830 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1831 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1832 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1833 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1834 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1835 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1836 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1837 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1838 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1839 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1840 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1841 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1842 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1843 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1844 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1845 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1846 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1847 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1848 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1849 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1850 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1851 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1852 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1853 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1854 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1855 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1856 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1857 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1858 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1859 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1860 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1861 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1862 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1863 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1864 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1865 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1866 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1867 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1868 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1869 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1870 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1871 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1872 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1873 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1874 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1875 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1876 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1877 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1878 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1879 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1880 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1881 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1882 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1883 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1884 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1885 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1886 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1887 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1888 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1889 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1890 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1891 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1892 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1893 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1894 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1895 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1896 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1897 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1898 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1899 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1900 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1901 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1902 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1903 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1904 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1905 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1906 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1907 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1908 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1909 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1910 = "llvm.alloca"(%1602) <{alignment = 16 : i64, elem_type = !llvm.array<5 x i64>}> : (i32) -> !llvm.ptr
  %1911 = "llvm.alloca"(%1602) <{alignment = 16 : i64, elem_type = !llvm.array<5 x i64>}> : (i32) -> !llvm.ptr
  %1912 = "llvm.alloca"(%1602) <{alignment = 16 : i64, elem_type = !llvm.array<5 x i64>}> : (i32) -> !llvm.ptr
  %1913 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1914 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1915 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1916 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1917 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1918 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1919 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1920 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1921 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1922 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1923 = "llvm.alloca"(%1602) <{alignment = 16 : i64, elem_type = !llvm.array<5 x i64>}> : (i32) -> !llvm.ptr
  %1924 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1925 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1926 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1927 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1928 = "llvm.alloca"(%1602) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%1683) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1684) : (!llvm.ptr) -> ()
  "llvm.call"(%1683, %arg190) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_limbs_frombytes, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%1684, %arg192) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_limbs_frombytes, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %1929 = "llvm.load"(%1683) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1930 = "llvm.load"(%1684) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1931 = "llvm.insertelement"(%1610, %1929, %1603) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1932 = "llvm.insertelement"(%1931, %1930, %1599) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1933 = "llvm.getelementptr"(%1683) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %1934 = "llvm.load"(%1933) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1935 = "llvm.getelementptr"(%1684) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %1936 = "llvm.load"(%1935) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1937 = "llvm.insertelement"(%1610, %1934, %1603) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1938 = "llvm.insertelement"(%1937, %1936, %1599) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1939 = "llvm.getelementptr"(%1683) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %1940 = "llvm.load"(%1939) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1941 = "llvm.getelementptr"(%1684) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %1942 = "llvm.load"(%1941) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1943 = "llvm.insertelement"(%1610, %1940, %1603) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1944 = "llvm.insertelement"(%1943, %1942, %1599) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1945 = "llvm.getelementptr"(%1683) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %1946 = "llvm.load"(%1945) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1947 = "llvm.getelementptr"(%1684) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %1948 = "llvm.load"(%1947) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1949 = "llvm.insertelement"(%1610, %1946, %1603) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1950 = "llvm.insertelement"(%1949, %1948, %1599) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1951 = "llvm.getelementptr"(%1683) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %1952 = "llvm.load"(%1951) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1953 = "llvm.getelementptr"(%1684) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %1954 = "llvm.load"(%1953) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1955 = "llvm.insertelement"(%1610, %1952, %1603) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1956 = "llvm.insertelement"(%1955, %1954, %1599) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%1685) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1686) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1687) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1688) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1689) : (!llvm.ptr) -> ()
  "llvm.call"(%1685, %1686, %1687, %1688, %1689, %1932, %1938, %1944, %1950, %1956) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1957 = "llvm.load"(%1685) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1958 = "llvm.load"(%1686) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1959 = "llvm.load"(%1687) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1960 = "llvm.load"(%1688) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1961 = "llvm.load"(%1689) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1689) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1688) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1687) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1686) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1685) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1690) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1691) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1692) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1693) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1694) : (!llvm.ptr) -> ()
  "llvm.call"(%1690, %1691, %1692, %1693, %1694, %1957, %1958, %1959, %1960, %1961, %1598, %1597, %1597, %1597, %1597) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sub, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1962 = "llvm.load"(%1690) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1963 = "llvm.load"(%1691) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1964 = "llvm.load"(%1692) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1965 = "llvm.load"(%1693) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1966 = "llvm.load"(%1694) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1694) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1693) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1692) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1691) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1690) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1695) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1696) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1697) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1698) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1699) : (!llvm.ptr) -> ()
  "llvm.call"(%1695, %1696, %1697, %1698, %1699, %1957, %1958, %1959, %1960, %1961, %1596, %1595, %1594, %1593, %1592) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1967 = "llvm.load"(%1695) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1968 = "llvm.load"(%1696) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1969 = "llvm.load"(%1697) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1970 = "llvm.load"(%1698) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1971 = "llvm.load"(%1699) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1699) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1698) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1697) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1696) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1695) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1700) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1701) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1702) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1703) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1704) : (!llvm.ptr) -> ()
  "llvm.call"(%1700, %1701, %1702, %1703, %1704, %1967, %1968, %1969, %1970, %1971, %1598, %1597, %1597, %1597, %1597) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_add, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1972 = "llvm.load"(%1700) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1973 = "llvm.load"(%1701) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1974 = "llvm.load"(%1702) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1975 = "llvm.load"(%1703) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1976 = "llvm.load"(%1704) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1704) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1703) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1702) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1701) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1700) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1705) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1706) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1707) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1708) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1709) : (!llvm.ptr) -> ()
  "llvm.call"(%1705, %1706, %1707, %1708, %1709, %1972, %1973, %1974, %1975, %1976) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1977 = "llvm.load"(%1705) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1978 = "llvm.load"(%1706) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1979 = "llvm.load"(%1707) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1980 = "llvm.load"(%1708) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1981 = "llvm.load"(%1709) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1709) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1708) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1707) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1706) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1705) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1710) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1711) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1712) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1713) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1714) : (!llvm.ptr) -> ()
  "llvm.call"(%1710, %1711, %1712, %1713, %1714, %1977, %1978, %1979, %1980, %1981, %1972, %1973, %1974, %1975, %1976) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1982 = "llvm.load"(%1710) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1983 = "llvm.load"(%1711) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1984 = "llvm.load"(%1712) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1985 = "llvm.load"(%1713) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1986 = "llvm.load"(%1714) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1714) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1713) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1712) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1711) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1710) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1715) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1716) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1717) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1718) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1719) : (!llvm.ptr) -> ()
  "llvm.call"(%1715, %1716, %1717, %1718, %1719, %1982, %1983, %1984, %1985, %1986) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1987 = "llvm.load"(%1715) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1988 = "llvm.load"(%1716) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1989 = "llvm.load"(%1717) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1990 = "llvm.load"(%1718) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1991 = "llvm.load"(%1719) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1719) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1718) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1717) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1716) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1715) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1720) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1721) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1722) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1723) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1724) : (!llvm.ptr) -> ()
  "llvm.call"(%1720, %1721, %1722, %1723, %1724, %1987, %1988, %1989, %1990, %1991, %1972, %1973, %1974, %1975, %1976) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1992 = "llvm.load"(%1720) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1993 = "llvm.load"(%1721) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1994 = "llvm.load"(%1722) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1995 = "llvm.load"(%1723) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1996 = "llvm.load"(%1724) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1724) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1723) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1722) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1721) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1720) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1725) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1726) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1727) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1728) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1729) : (!llvm.ptr) -> ()
  "llvm.call"(%1725, %1726, %1727, %1728, %1729, %1962, %1963, %1964, %1965, %1966, %1992, %1993, %1994, %1995, %1996) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1997 = "llvm.load"(%1725) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1998 = "llvm.load"(%1726) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1999 = "llvm.load"(%1727) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2000 = "llvm.load"(%1728) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2001 = "llvm.load"(%1729) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1729) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1728) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1727) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1726) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1725) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1730) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1731) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1732) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1733) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1734) : (!llvm.ptr) -> ()
  "llvm.call"(%1730, %1731, %1732, %1733, %1734, %1997, %1998, %1999, %2000, %2001) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2002 = "llvm.load"(%1730) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2003 = "llvm.load"(%1731) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2004 = "llvm.load"(%1732) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2005 = "llvm.load"(%1733) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2006 = "llvm.load"(%1734) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1734) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1733) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1732) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1731) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1730) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1735) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1736) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1737) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1738) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1739) : (!llvm.ptr) -> ()
  "llvm.call"(%1735, %1736, %1737, %1738, %1739, %2002, %2003, %2004, %2005, %2006) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2007 = "llvm.load"(%1735) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2008 = "llvm.load"(%1736) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2009 = "llvm.load"(%1737) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2010 = "llvm.load"(%1738) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2011 = "llvm.load"(%1739) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1739) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1738) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1737) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1736) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1735) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1740) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1741) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1742) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1743) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1744) : (!llvm.ptr) -> ()
  "llvm.call"(%1740, %1741, %1742, %1743, %1744, %2007, %2008, %2009, %2010, %2011) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2012 = "llvm.load"(%1740) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2013 = "llvm.load"(%1741) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2014 = "llvm.load"(%1742) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2015 = "llvm.load"(%1743) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2016 = "llvm.load"(%1744) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1744) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1743) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1742) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1741) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1740) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1745) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1746) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1747) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1748) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1749) : (!llvm.ptr) -> ()
  "llvm.call"(%1745, %1746, %1747, %1748, %1749, %1997, %1998, %1999, %2000, %2001, %2012, %2013, %2014, %2015, %2016) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2017 = "llvm.load"(%1745) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2018 = "llvm.load"(%1746) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2019 = "llvm.load"(%1747) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2020 = "llvm.load"(%1748) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2021 = "llvm.load"(%1749) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1749) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1748) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1747) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1746) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1745) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1750) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1751) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1752) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1753) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1754) : (!llvm.ptr) -> ()
  "llvm.call"(%1750, %1751, %1752, %1753, %1754, %2002, %2003, %2004, %2005, %2006, %2017, %2018, %2019, %2020, %2021) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2022 = "llvm.load"(%1750) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2023 = "llvm.load"(%1751) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2024 = "llvm.load"(%1752) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2025 = "llvm.load"(%1753) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2026 = "llvm.load"(%1754) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1754) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1753) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1752) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1751) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1750) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1755) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1756) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1757) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1758) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1759) : (!llvm.ptr) -> ()
  "llvm.call"(%1755, %1756, %1757, %1758, %1759, %2022, %2023, %2024, %2025, %2026) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2027 = "llvm.load"(%1755) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2028 = "llvm.load"(%1756) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2029 = "llvm.load"(%1757) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2030 = "llvm.load"(%1758) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2031 = "llvm.load"(%1759) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1759) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1758) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1757) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1756) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1755) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1760) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1761) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1762) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1763) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1764) : (!llvm.ptr) -> ()
  "llvm.call"(%1760, %1761, %1762, %1763, %1764, %2017, %2018, %2019, %2020, %2021, %2027, %2028, %2029, %2030, %2031) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2032 = "llvm.load"(%1760) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2033 = "llvm.load"(%1761) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2034 = "llvm.load"(%1762) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2035 = "llvm.load"(%1763) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2036 = "llvm.load"(%1764) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1764) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1763) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1762) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1761) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1760) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1765) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1766) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1767) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1768) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1769) : (!llvm.ptr) -> ()
  "llvm.call"(%1765, %1766, %1767, %1768, %1769, %2032, %2033, %2034, %2035, %2036) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2037 = "llvm.load"(%1765) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2038 = "llvm.load"(%1766) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2039 = "llvm.load"(%1767) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2040 = "llvm.load"(%1768) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2041 = "llvm.load"(%1769) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1769) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1768) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1767) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1766) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1765) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1770) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1771) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1772) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1773) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1774) : (!llvm.ptr) -> ()
  "llvm.call"(%1770, %1771, %1772, %1773, %1774, %2037, %2038, %2039, %2040, %2041) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2042 = "llvm.load"(%1770) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2043 = "llvm.load"(%1771) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2044 = "llvm.load"(%1772) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2045 = "llvm.load"(%1773) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2046 = "llvm.load"(%1774) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1774) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1773) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1772) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1771) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1770) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1770) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1771) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1772) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1773) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1774) : (!llvm.ptr) -> ()
  "llvm.call"(%1770, %1771, %1772, %1773, %1774, %2042, %2043, %2044, %2045, %2046) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2047 = "llvm.load"(%1770) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2048 = "llvm.load"(%1771) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2049 = "llvm.load"(%1772) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2050 = "llvm.load"(%1773) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2051 = "llvm.load"(%1774) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1774) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1773) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1772) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1771) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1770) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1770) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1771) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1772) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1773) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1774) : (!llvm.ptr) -> ()
  "llvm.call"(%1770, %1771, %1772, %1773, %1774, %2047, %2048, %2049, %2050, %2051) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2052 = "llvm.load"(%1770) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2053 = "llvm.load"(%1771) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2054 = "llvm.load"(%1772) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2055 = "llvm.load"(%1773) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2056 = "llvm.load"(%1774) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1774) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1773) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1772) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1771) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1770) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1770) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1771) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1772) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1773) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1774) : (!llvm.ptr) -> ()
  "llvm.call"(%1770, %1771, %1772, %1773, %1774, %2052, %2053, %2054, %2055, %2056) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2057 = "llvm.load"(%1770) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2058 = "llvm.load"(%1771) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2059 = "llvm.load"(%1772) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2060 = "llvm.load"(%1773) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2061 = "llvm.load"(%1774) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1774) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1773) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1772) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1771) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1770) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1775) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1776) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1777) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1778) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1779) : (!llvm.ptr) -> ()
  "llvm.call"(%1775, %1776, %1777, %1778, %1779, %2057, %2058, %2059, %2060, %2061, %2032, %2033, %2034, %2035, %2036) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2062 = "llvm.load"(%1775) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2063 = "llvm.load"(%1776) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2064 = "llvm.load"(%1777) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2065 = "llvm.load"(%1778) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2066 = "llvm.load"(%1779) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1779) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1778) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1777) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1776) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1775) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1780) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1781) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1782) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1783) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1784) : (!llvm.ptr) -> ()
  "llvm.call"(%1780, %1781, %1782, %1783, %1784, %2062, %2063, %2064, %2065, %2066) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2067 = "llvm.load"(%1780) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2068 = "llvm.load"(%1781) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2069 = "llvm.load"(%1782) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2070 = "llvm.load"(%1783) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2071 = "llvm.load"(%1784) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1784) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1783) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1782) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1781) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1780) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1785) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1786) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1787) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1788) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1789) : (!llvm.ptr) -> ()
  "llvm.call"(%1785, %1786, %1787, %1788, %1789, %2067, %2068, %2069, %2070, %2071) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2072 = "llvm.load"(%1785) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2073 = "llvm.load"(%1786) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2074 = "llvm.load"(%1787) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2075 = "llvm.load"(%1788) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2076 = "llvm.load"(%1789) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1789) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1788) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1787) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1786) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1785) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1785) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1786) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1787) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1788) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1789) : (!llvm.ptr) -> ()
  "llvm.call"(%1785, %1786, %1787, %1788, %1789, %2072, %2073, %2074, %2075, %2076) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2077 = "llvm.load"(%1785) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2078 = "llvm.load"(%1786) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2079 = "llvm.load"(%1787) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2080 = "llvm.load"(%1788) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2081 = "llvm.load"(%1789) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1789) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1788) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1787) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1786) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1785) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1785) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1786) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1787) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1788) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1789) : (!llvm.ptr) -> ()
  "llvm.call"(%1785, %1786, %1787, %1788, %1789, %2077, %2078, %2079, %2080, %2081) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2082 = "llvm.load"(%1785) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2083 = "llvm.load"(%1786) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2084 = "llvm.load"(%1787) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2085 = "llvm.load"(%1788) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2086 = "llvm.load"(%1789) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1789) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1788) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1787) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1786) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1785) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1785) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1786) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1787) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1788) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1789) : (!llvm.ptr) -> ()
  "llvm.call"(%1785, %1786, %1787, %1788, %1789, %2082, %2083, %2084, %2085, %2086) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2087 = "llvm.load"(%1785) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2088 = "llvm.load"(%1786) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2089 = "llvm.load"(%1787) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2090 = "llvm.load"(%1788) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2091 = "llvm.load"(%1789) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1789) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1788) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1787) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1786) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1785) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1785) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1786) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1787) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1788) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1789) : (!llvm.ptr) -> ()
  "llvm.call"(%1785, %1786, %1787, %1788, %1789, %2087, %2088, %2089, %2090, %2091) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2092 = "llvm.load"(%1785) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2093 = "llvm.load"(%1786) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2094 = "llvm.load"(%1787) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2095 = "llvm.load"(%1788) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2096 = "llvm.load"(%1789) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1789) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1788) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1787) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1786) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1785) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1785) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1786) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1787) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1788) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1789) : (!llvm.ptr) -> ()
  "llvm.call"(%1785, %1786, %1787, %1788, %1789, %2092, %2093, %2094, %2095, %2096) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2097 = "llvm.load"(%1785) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2098 = "llvm.load"(%1786) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2099 = "llvm.load"(%1787) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2100 = "llvm.load"(%1788) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2101 = "llvm.load"(%1789) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1789) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1788) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1787) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1786) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1785) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1785) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1786) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1787) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1788) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1789) : (!llvm.ptr) -> ()
  "llvm.call"(%1785, %1786, %1787, %1788, %1789, %2097, %2098, %2099, %2100, %2101) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2102 = "llvm.load"(%1785) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2103 = "llvm.load"(%1786) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2104 = "llvm.load"(%1787) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2105 = "llvm.load"(%1788) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2106 = "llvm.load"(%1789) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1789) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1788) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1787) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1786) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1785) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1785) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1786) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1787) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1788) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1789) : (!llvm.ptr) -> ()
  "llvm.call"(%1785, %1786, %1787, %1788, %1789, %2102, %2103, %2104, %2105, %2106) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2107 = "llvm.load"(%1785) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2108 = "llvm.load"(%1786) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2109 = "llvm.load"(%1787) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2110 = "llvm.load"(%1788) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2111 = "llvm.load"(%1789) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1789) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1788) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1787) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1786) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1785) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1785) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1786) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1787) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1788) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1789) : (!llvm.ptr) -> ()
  "llvm.call"(%1785, %1786, %1787, %1788, %1789, %2107, %2108, %2109, %2110, %2111) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2112 = "llvm.load"(%1785) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2113 = "llvm.load"(%1786) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2114 = "llvm.load"(%1787) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2115 = "llvm.load"(%1788) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2116 = "llvm.load"(%1789) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1789) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1788) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1787) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1786) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1785) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1790) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1791) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1792) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1793) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1794) : (!llvm.ptr) -> ()
  "llvm.call"(%1790, %1791, %1792, %1793, %1794, %2112, %2113, %2114, %2115, %2116, %2062, %2063, %2064, %2065, %2066) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2117 = "llvm.load"(%1790) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2118 = "llvm.load"(%1791) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2119 = "llvm.load"(%1792) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2120 = "llvm.load"(%1793) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2121 = "llvm.load"(%1794) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1794) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1793) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1792) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1791) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1790) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1795) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1796) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1797) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1798) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1799) : (!llvm.ptr) -> ()
  "llvm.call"(%1795, %1796, %1797, %1798, %1799, %2117, %2118, %2119, %2120, %2121) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2122 = "llvm.load"(%1795) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2123 = "llvm.load"(%1796) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2124 = "llvm.load"(%1797) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2125 = "llvm.load"(%1798) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2126 = "llvm.load"(%1799) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1799) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1798) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1797) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1796) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1795) : (!llvm.ptr) -> ()
  "llvm.br"(%2122, %2123, %2124, %2125, %2126, %1602)[^bb2] : (vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, i32) -> ()
^bb1:  // pred: ^bb2
  "llvm.intr.lifetime.start"(%1805) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1806) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1807) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1808) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1809) : (!llvm.ptr) -> ()
  "llvm.call"(%1805, %1806, %1807, %1808, %1809, %2198, %2199, %2200, %2201, %2202, %2117, %2118, %2119, %2120, %2121) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2127 = "llvm.load"(%1805) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2128 = "llvm.load"(%1806) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2129 = "llvm.load"(%1807) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2130 = "llvm.load"(%1808) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2131 = "llvm.load"(%1809) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1809) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1808) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1807) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1806) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1805) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1810) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1811) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1812) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1813) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1814) : (!llvm.ptr) -> ()
  "llvm.call"(%1810, %1811, %1812, %1813, %1814, %2127, %2128, %2129, %2130, %2131) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2132 = "llvm.load"(%1810) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2133 = "llvm.load"(%1811) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2134 = "llvm.load"(%1812) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2135 = "llvm.load"(%1813) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2136 = "llvm.load"(%1814) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1814) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1813) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1812) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1811) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1810) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1815) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1816) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1817) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1818) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1819) : (!llvm.ptr) -> ()
  "llvm.call"(%1815, %1816, %1817, %1818, %1819, %2132, %2133, %2134, %2135, %2136) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2137 = "llvm.load"(%1815) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2138 = "llvm.load"(%1816) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2139 = "llvm.load"(%1817) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2140 = "llvm.load"(%1818) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2141 = "llvm.load"(%1819) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1819) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1818) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1817) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1816) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1815) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1815) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1816) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1817) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1818) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1819) : (!llvm.ptr) -> ()
  "llvm.call"(%1815, %1816, %1817, %1818, %1819, %2137, %2138, %2139, %2140, %2141) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2142 = "llvm.load"(%1815) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2143 = "llvm.load"(%1816) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2144 = "llvm.load"(%1817) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2145 = "llvm.load"(%1818) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2146 = "llvm.load"(%1819) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1819) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1818) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1817) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1816) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1815) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1815) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1816) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1817) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1818) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1819) : (!llvm.ptr) -> ()
  "llvm.call"(%1815, %1816, %1817, %1818, %1819, %2142, %2143, %2144, %2145, %2146) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2147 = "llvm.load"(%1815) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2148 = "llvm.load"(%1816) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2149 = "llvm.load"(%1817) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2150 = "llvm.load"(%1818) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2151 = "llvm.load"(%1819) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1819) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1818) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1817) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1816) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1815) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1815) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1816) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1817) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1818) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1819) : (!llvm.ptr) -> ()
  "llvm.call"(%1815, %1816, %1817, %1818, %1819, %2147, %2148, %2149, %2150, %2151) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2152 = "llvm.load"(%1815) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2153 = "llvm.load"(%1816) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2154 = "llvm.load"(%1817) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2155 = "llvm.load"(%1818) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2156 = "llvm.load"(%1819) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1819) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1818) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1817) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1816) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1815) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1815) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1816) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1817) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1818) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1819) : (!llvm.ptr) -> ()
  "llvm.call"(%1815, %1816, %1817, %1818, %1819, %2152, %2153, %2154, %2155, %2156) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2157 = "llvm.load"(%1815) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2158 = "llvm.load"(%1816) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2159 = "llvm.load"(%1817) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2160 = "llvm.load"(%1818) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2161 = "llvm.load"(%1819) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1819) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1818) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1817) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1816) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1815) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1815) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1816) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1817) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1818) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1819) : (!llvm.ptr) -> ()
  "llvm.call"(%1815, %1816, %1817, %1818, %1819, %2157, %2158, %2159, %2160, %2161) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2162 = "llvm.load"(%1815) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2163 = "llvm.load"(%1816) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2164 = "llvm.load"(%1817) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2165 = "llvm.load"(%1818) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2166 = "llvm.load"(%1819) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1819) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1818) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1817) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1816) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1815) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1815) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1816) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1817) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1818) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1819) : (!llvm.ptr) -> ()
  "llvm.call"(%1815, %1816, %1817, %1818, %1819, %2162, %2163, %2164, %2165, %2166) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2167 = "llvm.load"(%1815) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2168 = "llvm.load"(%1816) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2169 = "llvm.load"(%1817) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2170 = "llvm.load"(%1818) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2171 = "llvm.load"(%1819) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1819) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1818) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1817) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1816) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1815) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1815) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1816) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1817) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1818) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1819) : (!llvm.ptr) -> ()
  "llvm.call"(%1815, %1816, %1817, %1818, %1819, %2167, %2168, %2169, %2170, %2171) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2172 = "llvm.load"(%1815) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2173 = "llvm.load"(%1816) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2174 = "llvm.load"(%1817) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2175 = "llvm.load"(%1818) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2176 = "llvm.load"(%1819) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1819) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1818) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1817) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1816) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1815) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1815) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1816) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1817) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1818) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1819) : (!llvm.ptr) -> ()
  "llvm.call"(%1815, %1816, %1817, %1818, %1819, %2172, %2173, %2174, %2175, %2176) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2177 = "llvm.load"(%1815) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2178 = "llvm.load"(%1816) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2179 = "llvm.load"(%1817) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2180 = "llvm.load"(%1818) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2181 = "llvm.load"(%1819) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1819) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1818) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1817) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1816) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1815) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1820) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1821) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1822) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1823) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1824) : (!llvm.ptr) -> ()
  "llvm.call"(%1820, %1821, %1822, %1823, %1824, %2177, %2178, %2179, %2180, %2181, %2062, %2063, %2064, %2065, %2066) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2182 = "llvm.load"(%1820) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2183 = "llvm.load"(%1821) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2184 = "llvm.load"(%1822) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2185 = "llvm.load"(%1823) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2186 = "llvm.load"(%1824) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1824) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1823) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1822) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1821) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1820) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1825) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1826) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1827) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1828) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1829) : (!llvm.ptr) -> ()
  "llvm.call"(%1825, %1826, %1827, %1828, %1829, %2182, %2183, %2184, %2185, %2186) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2187 = "llvm.load"(%1825) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2188 = "llvm.load"(%1826) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2189 = "llvm.load"(%1827) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2190 = "llvm.load"(%1828) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2191 = "llvm.load"(%1829) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1829) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1828) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1827) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1826) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1825) : (!llvm.ptr) -> ()
  "llvm.br"(%2187, %2188, %2189, %2190, %2191, %1602)[^bb4] : (vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, i32) -> ()
^bb2(%2192: vector<4xi64>, %2193: vector<4xi64>, %2194: vector<4xi64>, %2195: vector<4xi64>, %2196: vector<4xi64>, %2197: i32):  // 2 preds: ^bb0, ^bb2
  "llvm.intr.lifetime.start"(%1800) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1801) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1802) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1803) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1804) : (!llvm.ptr) -> ()
  "llvm.call"(%1800, %1801, %1802, %1803, %1804, %2192, %2193, %2194, %2195, %2196) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2198 = "llvm.load"(%1800) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2199 = "llvm.load"(%1801) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2200 = "llvm.load"(%1802) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2201 = "llvm.load"(%1803) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2202 = "llvm.load"(%1804) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1804) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1803) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1802) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1801) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1800) : (!llvm.ptr) -> ()
  %2203 = "llvm.add"(%2197, %1602) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %2204 = "llvm.icmp"(%2203, %1591) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2204, %2198, %2199, %2200, %2201, %2202, %2203)[^bb1, ^bb2] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 6>}> : (i1, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, i32) -> ()
^bb3:  // pred: ^bb4
  "llvm.intr.lifetime.start"(%1835) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1836) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1837) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1838) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1839) : (!llvm.ptr) -> ()
  "llvm.call"(%1835, %1836, %1837, %1838, %1839, %2221, %2222, %2223, %2224, %2225, %2182, %2183, %2184, %2185, %2186) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2205 = "llvm.load"(%1835) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2206 = "llvm.load"(%1836) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2207 = "llvm.load"(%1837) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2208 = "llvm.load"(%1838) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2209 = "llvm.load"(%1839) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1839) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1838) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1837) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1836) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1835) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1840) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1841) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1842) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1843) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1844) : (!llvm.ptr) -> ()
  "llvm.call"(%1840, %1841, %1842, %1843, %1844, %2205, %2206, %2207, %2208, %2209) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2210 = "llvm.load"(%1840) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2211 = "llvm.load"(%1841) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2212 = "llvm.load"(%1842) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2213 = "llvm.load"(%1843) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2214 = "llvm.load"(%1844) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1844) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1843) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1842) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1841) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1840) : (!llvm.ptr) -> ()
  "llvm.br"(%2210, %2211, %2212, %2213, %2214, %1602)[^bb6] : (vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, i32) -> ()
^bb4(%2215: vector<4xi64>, %2216: vector<4xi64>, %2217: vector<4xi64>, %2218: vector<4xi64>, %2219: vector<4xi64>, %2220: i32):  // 2 preds: ^bb1, ^bb4
  "llvm.intr.lifetime.start"(%1830) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1831) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1832) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1833) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1834) : (!llvm.ptr) -> ()
  "llvm.call"(%1830, %1831, %1832, %1833, %1834, %2215, %2216, %2217, %2218, %2219) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2221 = "llvm.load"(%1830) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2222 = "llvm.load"(%1831) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2223 = "llvm.load"(%1832) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2224 = "llvm.load"(%1833) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2225 = "llvm.load"(%1834) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1834) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1833) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1832) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1831) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1830) : (!llvm.ptr) -> ()
  %2226 = "llvm.add"(%2220, %1602) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %2227 = "llvm.icmp"(%2226, %1590) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2227, %2221, %2222, %2223, %2224, %2225, %2226)[^bb3, ^bb4] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 6>}> : (i1, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, i32) -> ()
^bb5:  // pred: ^bb6
  "llvm.intr.lifetime.start"(%1850) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1851) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1852) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1853) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1854) : (!llvm.ptr) -> ()
  "llvm.call"(%1850, %1851, %1852, %1853, %1854, %2244, %2245, %2246, %2247, %2248, %2205, %2206, %2207, %2208, %2209) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2228 = "llvm.load"(%1850) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2229 = "llvm.load"(%1851) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2230 = "llvm.load"(%1852) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2231 = "llvm.load"(%1853) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2232 = "llvm.load"(%1854) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1854) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1853) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1852) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1851) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1850) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1855) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1856) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1857) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1858) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1859) : (!llvm.ptr) -> ()
  "llvm.call"(%1855, %1856, %1857, %1858, %1859, %2228, %2229, %2230, %2231, %2232) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2233 = "llvm.load"(%1855) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2234 = "llvm.load"(%1856) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2235 = "llvm.load"(%1857) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2236 = "llvm.load"(%1858) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2237 = "llvm.load"(%1859) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1859) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1858) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1857) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1856) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1855) : (!llvm.ptr) -> ()
  "llvm.br"(%2233, %2234, %2235, %2236, %2237, %1602)[^bb8] : (vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, i32) -> ()
^bb6(%2238: vector<4xi64>, %2239: vector<4xi64>, %2240: vector<4xi64>, %2241: vector<4xi64>, %2242: vector<4xi64>, %2243: i32):  // 2 preds: ^bb3, ^bb6
  "llvm.intr.lifetime.start"(%1845) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1846) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1847) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1848) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1849) : (!llvm.ptr) -> ()
  "llvm.call"(%1845, %1846, %1847, %1848, %1849, %2238, %2239, %2240, %2241, %2242) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2244 = "llvm.load"(%1845) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2245 = "llvm.load"(%1846) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2246 = "llvm.load"(%1847) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2247 = "llvm.load"(%1848) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2248 = "llvm.load"(%1849) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1849) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1848) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1847) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1846) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1845) : (!llvm.ptr) -> ()
  %2249 = "llvm.add"(%2243, %1602) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %2250 = "llvm.icmp"(%2249, %1589) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2250, %2244, %2245, %2246, %2247, %2248, %2249)[^bb5, ^bb6] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 6>}> : (i1, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, i32) -> ()
^bb7:  // pred: ^bb8
  "llvm.intr.lifetime.start"(%1865) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1866) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1867) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1868) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1869) : (!llvm.ptr) -> ()
  "llvm.call"(%1865, %1866, %1867, %1868, %1869, %2304, %2305, %2306, %2307, %2308, %2182, %2183, %2184, %2185, %2186) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2251 = "llvm.load"(%1865) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2252 = "llvm.load"(%1866) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2253 = "llvm.load"(%1867) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2254 = "llvm.load"(%1868) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2255 = "llvm.load"(%1869) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1869) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1868) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1867) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1866) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1865) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1870) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1871) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1872) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1873) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1874) : (!llvm.ptr) -> ()
  "llvm.call"(%1870, %1871, %1872, %1873, %1874, %2251, %2252, %2253, %2254, %2255) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2256 = "llvm.load"(%1870) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2257 = "llvm.load"(%1871) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2258 = "llvm.load"(%1872) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2259 = "llvm.load"(%1873) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2260 = "llvm.load"(%1874) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1874) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1873) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1872) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1871) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1870) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1875) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1876) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1877) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1878) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1879) : (!llvm.ptr) -> ()
  "llvm.call"(%1875, %1876, %1877, %1878, %1879, %2256, %2257, %2258, %2259, %2260) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2261 = "llvm.load"(%1875) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2262 = "llvm.load"(%1876) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2263 = "llvm.load"(%1877) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2264 = "llvm.load"(%1878) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2265 = "llvm.load"(%1879) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1879) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1878) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1877) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1876) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1875) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1880) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1881) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1882) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1883) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1884) : (!llvm.ptr) -> ()
  "llvm.call"(%1880, %1881, %1882, %1883, %1884, %2261, %2262, %2263, %2264, %2265, %1997, %1998, %1999, %2000, %2001) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2266 = "llvm.load"(%1880) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2267 = "llvm.load"(%1881) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2268 = "llvm.load"(%1882) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2269 = "llvm.load"(%1883) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2270 = "llvm.load"(%1884) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1884) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1883) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1882) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1881) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1880) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1885) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1886) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1887) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1888) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1889) : (!llvm.ptr) -> ()
  "llvm.call"(%1885, %1886, %1887, %1888, %1889, %1962, %1963, %1964, %1965, %1966, %1982, %1983, %1984, %1985, %1986) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2271 = "llvm.load"(%1885) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2272 = "llvm.load"(%1886) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2273 = "llvm.load"(%1887) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2274 = "llvm.load"(%1888) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2275 = "llvm.load"(%1889) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1889) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1888) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1887) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1886) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1885) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1890) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1891) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1892) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1893) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1894) : (!llvm.ptr) -> ()
  "llvm.call"(%1890, %1891, %1892, %1893, %1894, %2271, %2272, %2273, %2274, %2275, %2266, %2267, %2268, %2269, %2270) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2276 = "llvm.load"(%1890) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2277 = "llvm.load"(%1891) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2278 = "llvm.load"(%1892) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2279 = "llvm.load"(%1893) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2280 = "llvm.load"(%1894) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1894) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1893) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1892) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1891) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1890) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1895) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1896) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1897) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1898) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1899) : (!llvm.ptr) -> ()
  "llvm.call"(%1895, %1896, %1897, %1898, %1899, %2276, %2277, %2278, %2279, %2280) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2281 = "llvm.load"(%1895) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2282 = "llvm.load"(%1896) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2283 = "llvm.load"(%1897) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2284 = "llvm.load"(%1898) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2285 = "llvm.load"(%1899) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1899) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1898) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1897) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1896) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1895) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1900) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1901) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1902) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1903) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1904) : (!llvm.ptr) -> ()
  "llvm.call"(%1900, %1901, %1902, %1903, %1904, %1972, %1973, %1974, %1975, %1976, %2281, %2282, %2283, %2284, %2285) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2286 = "llvm.load"(%1900) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2287 = "llvm.load"(%1901) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2288 = "llvm.load"(%1902) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2289 = "llvm.load"(%1903) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2290 = "llvm.load"(%1904) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1904) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1903) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1902) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1901) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1900) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1905) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1906) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1907) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1908) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1909) : (!llvm.ptr) -> ()
  "llvm.call"(%1905, %1906, %1907, %1908, %1909, %1962, %1963, %1964, %1965, %1966) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_neg, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2291 = "llvm.load"(%1905) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2292 = "llvm.load"(%1906) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2293 = "llvm.load"(%1907) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2294 = "llvm.load"(%1908) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2295 = "llvm.load"(%1909) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1909) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1908) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1907) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1906) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1905) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1910) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1911) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1912) : (!llvm.ptr) -> ()
  "llvm.call"(%1910, %2286, %2287, %2288, %2289, %2290, %1606) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_lane_canon, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 7, 0>}> : (!llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, i32) -> ()
  "llvm.call"(%1911, %1962, %1963, %1964, %1965, %1966, %1606) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_lane_canon, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 7, 0>}> : (!llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, i32) -> ()
  "llvm.call"(%1912, %2291, %2292, %2293, %2294, %2295, %1606) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_lane_canon, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 7, 0>}> : (!llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, i32) -> ()
  %2296 = "llvm.call"(%1910, %1911) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_r52x5_limbs_eq, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> i32
  %2297 = "llvm.icmp"(%2296, %1606) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2297, %1606, %1602)[^bb9, ^bb10] <{operandSegmentSizes = array<i32: 1, 0, 2>}> : (i1, i32, i32) -> ()
^bb8(%2298: vector<4xi64>, %2299: vector<4xi64>, %2300: vector<4xi64>, %2301: vector<4xi64>, %2302: vector<4xi64>, %2303: i32):  // 2 preds: ^bb5, ^bb8
  "llvm.intr.lifetime.start"(%1860) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1861) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1862) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1863) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1864) : (!llvm.ptr) -> ()
  "llvm.call"(%1860, %1861, %1862, %1863, %1864, %2298, %2299, %2300, %2301, %2302) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2304 = "llvm.load"(%1860) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2305 = "llvm.load"(%1861) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2306 = "llvm.load"(%1862) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2307 = "llvm.load"(%1863) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2308 = "llvm.load"(%1864) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1864) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1863) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1862) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1861) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1860) : (!llvm.ptr) -> ()
  %2309 = "llvm.add"(%2303, %1602) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %2310 = "llvm.icmp"(%2309, %1590) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2310, %2304, %2305, %2306, %2307, %2308, %2309)[^bb7, ^bb8] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 6>}> : (i1, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, i32) -> ()
^bb9:  // pred: ^bb7
  %2311 = "llvm.call"(%1910, %1912) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_r52x5_limbs_eq, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> i32
  %2312 = "llvm.sub"(%1606, %2311) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  "llvm.br"(%2312, %2311)[^bb10] : (i32, i32) -> ()
^bb10(%2313: i32, %2314: i32):  // 2 preds: ^bb7, ^bb9
  "llvm.intr.lifetime.end"(%1912) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1911) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1910) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1910) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1911) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1912) : (!llvm.ptr) -> ()
  "llvm.call"(%1910, %2286, %2287, %2288, %2289, %2290, %1602) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_lane_canon, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 7, 0>}> : (!llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, i32) -> ()
  "llvm.call"(%1911, %1962, %1963, %1964, %1965, %1966, %1602) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_lane_canon, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 7, 0>}> : (!llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, i32) -> ()
  "llvm.call"(%1912, %2291, %2292, %2293, %2294, %2295, %1602) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_lane_canon, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 7, 0>}> : (!llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, i32) -> ()
  %2315 = "llvm.call"(%1910, %1911) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_r52x5_limbs_eq, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> i32
  %2316 = "llvm.icmp"(%2315, %1606) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2316, %1606)[^bb11, ^bb13] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb11:  // pred: ^bb10
  %2317 = "llvm.call"(%1910, %1912) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_r52x5_limbs_eq, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> i32
  %2318 = "llvm.icmp"(%2317, %1606) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2318, %1588)[^bb12, ^bb13] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb12:  // pred: ^bb11
  "llvm.intr.lifetime.end"(%1912) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1911) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1910) : (!llvm.ptr) -> ()
  "llvm.br"(%2314)[^bb15] : (i32) -> ()
^bb13(%2319: i32):  // 2 preds: ^bb10, ^bb11
  "llvm.intr.lifetime.end"(%1912) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1911) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1910) : (!llvm.ptr) -> ()
  %2320 = "llvm.icmp"(%2314, %1606) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2320, %1601)[^bb15, ^bb14] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i32) -> ()
^bb14:  // pred: ^bb13
  "llvm.intr.lifetime.start"(%1913) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1914) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1915) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1916) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1917) : (!llvm.ptr) -> ()
  "llvm.call"(%1913, %1914, %1915, %1916, %1917, %2276, %2277, %2278, %2279, %2280, %1587, %1586, %1585, %1584, %1583) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2321 = "llvm.load"(%1913) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<32xi8>
  %2322 = "llvm.load"(%1914) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<32xi8>
  %2323 = "llvm.load"(%1915) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<32xi8>
  %2324 = "llvm.load"(%1916) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<32xi8>
  %2325 = "llvm.load"(%1917) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<32xi8>
  "llvm.intr.lifetime.end"(%1917) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1916) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1915) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1914) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1913) : (!llvm.ptr) -> ()
  %2326 = "llvm.insertelement"(%1618, %2313, %1603) : (vector<8xi32>, i32, i64) -> vector<8xi32>
  %2327 = "llvm.insertelement"(%2326, %2313, %1599) : (vector<8xi32>, i32, i64) -> vector<8xi32>
  %2328 = "llvm.insertelement"(%2327, %2319, %1576) : (vector<8xi32>, i32, i64) -> vector<8xi32>
  %2329 = "llvm.insertelement"(%2328, %2319, %1575) : (vector<8xi32>, i32, i64) -> vector<8xi32>
  %2330 = "llvm.bitcast"(%2276) : (vector<4xi64>) -> vector<32xi8>
  %2331 = "llvm.bitcast"(%2329) : (vector<8xi32>) -> vector<32xi8>
  %2332 = "llvm.call_intrinsic"(%2330, %2321, %2331) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %2333 = "llvm.bitcast"(%2332) : (vector<32xi8>) -> vector<4xi64>
  %2334 = "llvm.bitcast"(%2277) : (vector<4xi64>) -> vector<32xi8>
  %2335 = "llvm.call_intrinsic"(%2334, %2322, %2331) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %2336 = "llvm.bitcast"(%2335) : (vector<32xi8>) -> vector<4xi64>
  %2337 = "llvm.bitcast"(%2278) : (vector<4xi64>) -> vector<32xi8>
  %2338 = "llvm.call_intrinsic"(%2337, %2323, %2331) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %2339 = "llvm.bitcast"(%2338) : (vector<32xi8>) -> vector<4xi64>
  %2340 = "llvm.bitcast"(%2279) : (vector<4xi64>) -> vector<32xi8>
  %2341 = "llvm.call_intrinsic"(%2340, %2324, %2331) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %2342 = "llvm.bitcast"(%2341) : (vector<32xi8>) -> vector<4xi64>
  %2343 = "llvm.bitcast"(%2280) : (vector<4xi64>) -> vector<32xi8>
  %2344 = "llvm.call_intrinsic"(%2343, %2325, %2331) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %2345 = "llvm.bitcast"(%2344) : (vector<32xi8>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%1918) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1919) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1920) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1921) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1922) : (!llvm.ptr) -> ()
  "llvm.call"(%1918, %1919, %1920, %1921, %1922, %2333, %2336, %2339, %2342, %2345) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_neg, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2346 = "llvm.load"(%1918) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<32xi8>
  %2347 = "llvm.load"(%1919) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<32xi8>
  %2348 = "llvm.load"(%1920) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<32xi8>
  %2349 = "llvm.load"(%1921) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<32xi8>
  %2350 = "llvm.load"(%1922) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<32xi8>
  "llvm.intr.lifetime.end"(%1922) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1921) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1920) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1919) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1918) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1923) : (!llvm.ptr) -> ()
  "llvm.call"(%1923, %2333, %2336, %2339, %2342, %2345, %1606) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_lane_canon, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 7, 0>}> : (!llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, i32) -> ()
  %2351 = "llvm.load"(%1923) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2352 = "llvm.getelementptr"(%arg190) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 31>}> : (!llvm.ptr) -> !llvm.ptr
  %2353 = "llvm.load"(%2352) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  "llvm.intr.lifetime.end"(%1923) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1923) : (!llvm.ptr) -> ()
  "llvm.call"(%1923, %2333, %2336, %2339, %2342, %2345, %1602) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_lane_canon, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 7, 0>}> : (!llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, i32) -> ()
  %2354 = "llvm.load"(%1923) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2355 = "llvm.getelementptr"(%arg192) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 31>}> : (!llvm.ptr) -> !llvm.ptr
  %2356 = "llvm.load"(%2355) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  "llvm.intr.lifetime.end"(%1923) : (!llvm.ptr) -> ()
  %2357 = "llvm.trunc"(%2351) <{overflowFlags = 0 : i32}> : (i64) -> i32
  %2358 = "llvm.insertelement"(%1574, %2357, %1603) : (vector<2xi32>, i32, i64) -> vector<2xi32>
  %2359 = "llvm.trunc"(%2354) <{overflowFlags = 0 : i32}> : (i64) -> i32
  %2360 = "llvm.insertelement"(%2358, %2359, %1599) : (vector<2xi32>, i32, i64) -> vector<2xi32>
  %2361 = "llvm.and"(%2360, %1573) : (vector<2xi32>, vector<2xi32>) -> vector<2xi32>
  %2362 = "llvm.insertelement"(%1572, %2353, %1603) : (vector<2xi8>, i8, i64) -> vector<2xi8>
  %2363 = "llvm.insertelement"(%2362, %2356, %1599) : (vector<2xi8>, i8, i64) -> vector<2xi8>
  %2364 = "llvm.lshr"(%2363, %1571) : (vector<2xi8>, vector<2xi8>) -> vector<2xi8>
  %2365 = "llvm.zext"(%2364) <{nonNeg}> : (vector<2xi8>) -> vector<2xi32>
  %2366 = "llvm.icmp"(%2361, %2365) <{predicate = 1 : i64}> : (vector<2xi32>, vector<2xi32>) -> vector<2xi1>
  %2367 = "llvm.sext"(%2366) : (vector<2xi1>) -> vector<2xi32>
  %2368 = "llvm.shufflevector"(%2367, %1574) <{mask = array<i32: 0, 1, -1, -1, -1, -1, -1, -1>}> : (vector<2xi32>, vector<2xi32>) -> vector<8xi32>
  %2369 = "llvm.shufflevector"(%2368, %1618) <{mask = array<i32: 0, -1, -1, -1, 12, 13, 14, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %2370 = "llvm.sext"(%2366) : (vector<2xi1>) -> vector<2xi32>
  %2371 = "llvm.shufflevector"(%2370, %1574) <{mask = array<i32: 0, 1, -1, -1, -1, -1, -1, -1>}> : (vector<2xi32>, vector<2xi32>) -> vector<8xi32>
  %2372 = "llvm.shufflevector"(%2369, %2371) <{mask = array<i32: 0, 8, 9, -1, 4, 5, 6, 7>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %2373 = "llvm.shufflevector"(%2372, %2368) <{mask = array<i32: 0, 1, 2, 9, 4, 5, 6, 7>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %2374 = "llvm.bitcast"(%2373) : (vector<8xi32>) -> vector<32xi8>
  %2375 = "llvm.call_intrinsic"(%2332, %2346, %2374) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %2376 = "llvm.bitcast"(%2375) : (vector<32xi8>) -> vector<4xi64>
  %2377 = "llvm.call_intrinsic"(%2335, %2347, %2374) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %2378 = "llvm.bitcast"(%2377) : (vector<32xi8>) -> vector<4xi64>
  %2379 = "llvm.call_intrinsic"(%2338, %2348, %2374) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %2380 = "llvm.bitcast"(%2379) : (vector<32xi8>) -> vector<4xi64>
  %2381 = "llvm.call_intrinsic"(%2341, %2349, %2374) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %2382 = "llvm.bitcast"(%2381) : (vector<32xi8>) -> vector<4xi64>
  %2383 = "llvm.call_intrinsic"(%2344, %2350, %2374) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %2384 = "llvm.bitcast"(%2383) : (vector<32xi8>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%1924) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1925) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1926) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1927) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1928) : (!llvm.ptr) -> ()
  "llvm.call"(%1924, %1925, %1926, %1927, %1928, %2376, %2378, %2380, %2382, %2384, %1932, %1938, %1944, %1950, %1956) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2385 = "llvm.load"(%1924) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2386 = "llvm.load"(%1925) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2387 = "llvm.load"(%1926) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2388 = "llvm.load"(%1927) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2389 = "llvm.load"(%1928) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1928) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1927) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1926) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1925) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1924) : (!llvm.ptr) -> ()
  %2390 = "llvm.call"(%2376, %1606, %1606, %1606, %1606) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2391 = "llvm.call"(%2378, %1606, %1606, %1606, %1606) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2392 = "llvm.call"(%2380, %1606, %1606, %1606, %1606) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2393 = "llvm.call"(%2382, %1606, %1606, %1606, %1606) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2394 = "llvm.call"(%2384, %1606, %1606, %1606, %1606) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2395 = "llvm.call"(%1932, %1606, %1606, %1606, %1606) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2396 = "llvm.call"(%1938, %1606, %1606, %1606, %1606) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2397 = "llvm.call"(%1944, %1606, %1606, %1606, %1606) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2398 = "llvm.call"(%1950, %1606, %1606, %1606, %1606) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2399 = "llvm.call"(%1956, %1606, %1606, %1606, %1606) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2400 = "llvm.shufflevector"(%2390, %2395) <{mask = array<i32: 0, 5, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2401 = "llvm.bitcast"(%2400) : (vector<4xi64>) -> vector<32xi8>
  %2402 = "llvm.shufflevector"(%2391, %2396) <{mask = array<i32: 0, 5, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2403 = "llvm.bitcast"(%2402) : (vector<4xi64>) -> vector<32xi8>
  %2404 = "llvm.shufflevector"(%2392, %2397) <{mask = array<i32: 0, 5, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2405 = "llvm.bitcast"(%2404) : (vector<4xi64>) -> vector<32xi8>
  %2406 = "llvm.shufflevector"(%2393, %2398) <{mask = array<i32: 0, 5, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2407 = "llvm.bitcast"(%2406) : (vector<4xi64>) -> vector<32xi8>
  %2408 = "llvm.shufflevector"(%2394, %2399) <{mask = array<i32: 0, 5, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2409 = "llvm.bitcast"(%2408) : (vector<4xi64>) -> vector<32xi8>
  %2410 = "llvm.shufflevector"(%2401, %1650) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 48, 49, 50, 51, 52, 53, 54, 55, -1, -1, -1, -1, -1, -1, -1, -1>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %2411 = "llvm.shufflevector"(%2403, %1682) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 48, 49, 50, 51, 52, 53, 54, 55, -1, -1, -1, -1, -1, -1, -1, -1>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %2412 = "llvm.shufflevector"(%2405, %1682) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 48, 49, 50, 51, 52, 53, 54, 55, -1, -1, -1, -1, -1, -1, -1, -1>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %2413 = "llvm.shufflevector"(%2407, %1682) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 48, 49, 50, 51, 52, 53, 54, 55, -1, -1, -1, -1, -1, -1, -1, -1>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %2414 = "llvm.shufflevector"(%2409, %1682) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 48, 49, 50, 51, 52, 53, 54, 55, -1, -1, -1, -1, -1, -1, -1, -1>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %2415 = "llvm.call"(%2385, %1606, %1606, %1606, %1606) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2416 = "llvm.call"(%2386, %1606, %1606, %1606, %1606) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2417 = "llvm.call"(%2387, %1606, %1606, %1606, %1606) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2418 = "llvm.call"(%2388, %1606, %1606, %1606, %1606) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2419 = "llvm.call"(%2389, %1606, %1606, %1606, %1606) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2420 = "llvm.bitcast"(%2415) : (vector<4xi64>) -> vector<32xi8>
  %2421 = "llvm.shufflevector"(%2410, %2420) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 56, 57, 58, 59, 60, 61, 62, 63>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %2422 = "llvm.bitcast"(%2416) : (vector<4xi64>) -> vector<32xi8>
  %2423 = "llvm.shufflevector"(%2411, %2422) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 56, 57, 58, 59, 60, 61, 62, 63>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %2424 = "llvm.bitcast"(%2417) : (vector<4xi64>) -> vector<32xi8>
  %2425 = "llvm.shufflevector"(%2412, %2424) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 56, 57, 58, 59, 60, 61, 62, 63>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %2426 = "llvm.bitcast"(%2418) : (vector<4xi64>) -> vector<32xi8>
  %2427 = "llvm.shufflevector"(%2413, %2426) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 56, 57, 58, 59, 60, 61, 62, 63>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %2428 = "llvm.bitcast"(%2419) : (vector<4xi64>) -> vector<32xi8>
  %2429 = "llvm.shufflevector"(%2414, %2428) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 56, 57, 58, 59, 60, 61, 62, 63>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %2430 = "llvm.call"(%2376, %1602, %1602, %1602, %1602) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2431 = "llvm.call"(%2378, %1602, %1602, %1602, %1602) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2432 = "llvm.call"(%2380, %1602, %1602, %1602, %1602) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2433 = "llvm.call"(%2382, %1602, %1602, %1602, %1602) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2434 = "llvm.call"(%2384, %1602, %1602, %1602, %1602) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2435 = "llvm.call"(%1932, %1602, %1602, %1602, %1602) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2436 = "llvm.call"(%1938, %1602, %1602, %1602, %1602) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2437 = "llvm.call"(%1944, %1602, %1602, %1602, %1602) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2438 = "llvm.call"(%1950, %1602, %1602, %1602, %1602) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2439 = "llvm.call"(%1956, %1602, %1602, %1602, %1602) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2440 = "llvm.shufflevector"(%2430, %2435) <{mask = array<i32: 0, 5, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2441 = "llvm.bitcast"(%2440) : (vector<4xi64>) -> vector<32xi8>
  %2442 = "llvm.shufflevector"(%2431, %2436) <{mask = array<i32: 0, 5, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2443 = "llvm.bitcast"(%2442) : (vector<4xi64>) -> vector<32xi8>
  %2444 = "llvm.shufflevector"(%2432, %2437) <{mask = array<i32: 0, 5, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2445 = "llvm.bitcast"(%2444) : (vector<4xi64>) -> vector<32xi8>
  %2446 = "llvm.shufflevector"(%2433, %2438) <{mask = array<i32: 0, 5, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2447 = "llvm.bitcast"(%2446) : (vector<4xi64>) -> vector<32xi8>
  %2448 = "llvm.shufflevector"(%2434, %2439) <{mask = array<i32: 0, 5, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2449 = "llvm.bitcast"(%2448) : (vector<4xi64>) -> vector<32xi8>
  %2450 = "llvm.shufflevector"(%2441, %1650) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 48, 49, 50, 51, 52, 53, 54, 55, -1, -1, -1, -1, -1, -1, -1, -1>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %2451 = "llvm.shufflevector"(%2443, %1682) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 48, 49, 50, 51, 52, 53, 54, 55, -1, -1, -1, -1, -1, -1, -1, -1>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %2452 = "llvm.shufflevector"(%2445, %1682) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 48, 49, 50, 51, 52, 53, 54, 55, -1, -1, -1, -1, -1, -1, -1, -1>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %2453 = "llvm.shufflevector"(%2447, %1682) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 48, 49, 50, 51, 52, 53, 54, 55, -1, -1, -1, -1, -1, -1, -1, -1>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %2454 = "llvm.shufflevector"(%2449, %1682) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 48, 49, 50, 51, 52, 53, 54, 55, -1, -1, -1, -1, -1, -1, -1, -1>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %2455 = "llvm.call"(%2385, %1602, %1602, %1602, %1602) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2456 = "llvm.call"(%2386, %1602, %1602, %1602, %1602) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2457 = "llvm.call"(%2387, %1602, %1602, %1602, %1602) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2458 = "llvm.call"(%2388, %1602, %1602, %1602, %1602) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2459 = "llvm.call"(%2389, %1602, %1602, %1602, %1602) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2460 = "llvm.bitcast"(%2455) : (vector<4xi64>) -> vector<32xi8>
  %2461 = "llvm.shufflevector"(%2450, %2460) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 56, 57, 58, 59, 60, 61, 62, 63>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %2462 = "llvm.bitcast"(%2456) : (vector<4xi64>) -> vector<32xi8>
  %2463 = "llvm.shufflevector"(%2451, %2462) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 56, 57, 58, 59, 60, 61, 62, 63>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %2464 = "llvm.bitcast"(%2457) : (vector<4xi64>) -> vector<32xi8>
  %2465 = "llvm.shufflevector"(%2452, %2464) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 56, 57, 58, 59, 60, 61, 62, 63>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %2466 = "llvm.bitcast"(%2458) : (vector<4xi64>) -> vector<32xi8>
  %2467 = "llvm.shufflevector"(%2453, %2466) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 56, 57, 58, 59, 60, 61, 62, 63>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %2468 = "llvm.bitcast"(%2459) : (vector<4xi64>) -> vector<32xi8>
  %2469 = "llvm.shufflevector"(%2454, %2468) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 56, 57, 58, 59, 60, 61, 62, 63>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  "llvm.store"(%2421, %arg189) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<32xi8>, !llvm.ptr) -> ()
  %2470 = "llvm.getelementptr"(%arg189) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2423, %2470) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<32xi8>, !llvm.ptr) -> ()
  %2471 = "llvm.getelementptr"(%arg189) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2425, %2471) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<32xi8>, !llvm.ptr) -> ()
  %2472 = "llvm.getelementptr"(%arg189) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2427, %2472) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<32xi8>, !llvm.ptr) -> ()
  %2473 = "llvm.getelementptr"(%arg189) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2429, %2473) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<32xi8>, !llvm.ptr) -> ()
  "llvm.store"(%2461, %arg191) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<32xi8>, !llvm.ptr) -> ()
  %2474 = "llvm.getelementptr"(%arg191) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2463, %2474) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<32xi8>, !llvm.ptr) -> ()
  %2475 = "llvm.getelementptr"(%arg191) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2465, %2475) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<32xi8>, !llvm.ptr) -> ()
  %2476 = "llvm.getelementptr"(%arg191) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2467, %2476) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<32xi8>, !llvm.ptr) -> ()
  %2477 = "llvm.getelementptr"(%arg191) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2469, %2477) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<32xi8>, !llvm.ptr) -> ()
  "llvm.br"(%1600)[^bb15] : (i32) -> ()
^bb15(%2478: i32):  // 3 preds: ^bb12, ^bb13, ^bb14
  "llvm.intr.lifetime.end"(%1684) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1683) : (!llvm.ptr) -> ()
  "llvm.return"(%2478) : (i32) -> ()
}) : () -> ()
  with @fd_r52x5_limbs_eq := fd_r52x5_limbs_eq,
    @fd_r52x5_limbs_frombytes := fd_r52x5_limbs_frombytes, @fd_r52x5_quad_add := fd_r52x5_quad_add,
    @fd_r52x5_quad_lane_canon := fd_r52x5_quad_lane_canon, @fd_r52x5_quad_mul := fd_r52x5_quad_mul,
    @fd_r52x5_quad_neg := fd_r52x5_quad_neg, @fd_r52x5_quad_sqr := fd_r52x5_quad_sqr,
    @fd_r52x5_quad_sub := fd_r52x5_quad_sub, @wl_permute := wl_permute

end

end MLIR.Firedancer.Crc.Ed25519.Avx512
