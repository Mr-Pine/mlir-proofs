module

public import Boringssl.Common.Bounds
public import Boringssl.x25519_sc_reduce
public import MLIR.Run.Tactic
public import Sodium.Mlir.sc25519_reduce
public import Sodium.load_3
public import Sodium.load_4
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

/-! libsodium's `sc25519_reduce` is ref10's reduction, BoringSSL's `x25519_sc_reduce` with its
carries as `carry * (1 << 21)`: its spec is BoringSSL's, `s mod ℓ` by
`Boringssl.x25519_sc_reduce.spec_val`. The compiler folds those products into masks
(`(s + 2^20) & -2^21`), which `ir_eq_spec` turns back into shifted carries. -/

namespace MLIR.Sodium

open MLIR.Firedancer.Ref
open MLIR.Boringssl.x25519_sc_reduce (load3 load4)

/-! ## Bounds -/

/-- `load_3(s + k)`'s pointer does not wrap. -/
theorem sc25519_reduce.off3 {p : Pointer} (h : ¬p.offset.uaddOverflow 64#64) (k : Nat)
    (hk : k + 3 ≤ 64) : ¬(p.add (BitVec.ofNat 64 k)).offset.uaddOverflow 3#64 := by
  have e : (64#64).toNat = 64 := rfl
  simp only [BitVec.uaddOverflow, Pointer.add, e] at h ⊢
  simp at h ⊢
  rw [Nat.mod_eq_of_lt (by omega)]
  omega

/-- A 24-bit value shifted right by `3` fits the mask. -/
theorem sc25519_reduce.nomask3_3 (y : BitVec 24) :
    y.setWidth 64 >>> 3 = 2097151#64 &&& y.setWidth 64 >>> 3 := by bv_decide

/-- `shl nuw` by `k ≤ 7` of a value below `2^57` (`x * 2^7` does not wrap) loses no bits. -/
theorem sc25519_reduce.shl_nuw (x : BitVec 64) (k : Nat)
    (hk : k = 1 ∨ k = 2 ∨ k = 3 ∨ k = 4 ∨ k = 5 ∨ k = 6 ∨ k = 7)
    (h : x.umulOverflow 128#64 = false) : x <<< k >>> k = x := by
  have hlt : x.ult 144115188075855872#64 := by
    simp only [BitVec.umulOverflow, BitVec.toNat_ofNat] at h
    simp only [BitVec.ult_iff_lt, BitVec.lt_def, BitVec.toNat_ofNat]
    simp at h
    omega
  rcases hk with rfl | rfl | rfl | rfl | rfl | rfl | rfl <;> bv_decide

/-- `shl nsw` by `k ≤ 7` of a value in `[-2^56, 2^56)` (`x * 2^7` does not overflow) keeps its
sign bits. -/
theorem sc25519_reduce.shl_nsw (x : BitVec 64) (k : Nat)
    (hk : k = 1 ∨ k = 2 ∨ k = 3 ∨ k = 4 ∨ k = 5 ∨ k = 6 ∨ k = 7)
    (h : x.smulOverflow 128#64 = false) : (x <<< k).sshiftRight k = x := by
  have e : (128#64).toInt = 128 := by decide
  simp only [BitVec.smulOverflow, e] at h
  simp at h
  have h0 : (-72057594037927936#64).sle x := by
    rw [BitVec.sle_iff_toInt_le]; simp; omega
  have h3 : x.slt 72057594037927936#64 := by
    rw [BitVec.slt_iff_toInt_lt]; simp; omega
  rcases hk with rfl | rfl | rfl | rfl | rfl | rfl | rfl <;> bv_decide

/-- `or disjoint` of a limb shifted left by `k` and the next lower limb, below `2^21`, shifted right
by `21 - k`. -/
theorem sc25519_reduce.or_disj (x y : BitVec 64) (k : Nat)
    (hk : k = 1 ∨ k = 2 ∨ k = 3 ∨ k = 4 ∨ k = 5 ∨ k = 6 ∨ k = 7)
    (h : y.umulOverflow 8796093022208#64 = false) : x <<< k &&& y >>> (21 - k) = 0#64 := by
  have hlt : y.ult 2097152#64 := by
    simp only [BitVec.umulOverflow, BitVec.toNat_ofNat] at h
    simp only [BitVec.ult_iff_lt, BitVec.lt_def, BitVec.toNat_ofNat]
    simp at h
    omega
  rcases hk with rfl | rfl | rfl | rfl | rfl | rfl | rfl <;> bv_decide

/-- `or disjoint` of a limb shifted left by `5` and the next lower limb's bits `16 … 20`. -/
theorem sc25519_reduce.or_disj_mask (x y : BitVec 64) :
    x <<< 5 &&& (y >>> 16 &&& 31#64) = 0#64 := by bv_decide

/-! ## The compiled computation -/

section Compiled

/-- The 32 bytes the code stores, from the final limbs. -/
def sc25519_reduce.out
    (s0_5 s1_9 s2_10 s1_10 s3_11 s2_11 s4_12 s3_12 s5_13 s4_13 s6_12 s5_14 s7_13 s6_13 s8_13 s9_13
      s10_13 s9_14 s11_13 s10_14 : BitVec 64) :
    BitVec 256 :=
  (BitVec.setWidth 8 (s11_13 >>> 17)) ++
    ((BitVec.setWidth 8 (s11_13 >>> 9)) ++
      ((BitVec.setWidth 8 (s11_13 >>> 1)) ++
        ((BitVec.setWidth 8 s11_13 <<< 7 ||| BitVec.setWidth 8 (s10_14 >>> 14)) ++
          ((BitVec.setWidth 8 (s10_13 >>> 6)) ++
            ((BitVec.setWidth 8 s10_14 <<< 2 ||| BitVec.setWidth 8 (s9_14 >>> 19)) ++
              ((BitVec.setWidth 16 (s9_13 >>> 3)) ++
                ((BitVec.setWidth 8 s9_14 <<< 5 ||| BitVec.setWidth 8 (s8_13 >>> 16) &&& 31#8) ++
                  ((BitVec.setWidth 16 s8_13) ++
                    ((BitVec.setWidth 16 (s7_13 >>> 5)) ++
                      ((BitVec.setWidth 8 s7_13 <<< 3 ||| BitVec.setWidth 8 (s6_13 >>> 18)) ++
                        ((BitVec.setWidth 16 (s6_12 >>> 2)) ++
                          ((BitVec.setWidth 8 s6_13 <<< 6 ||| BitVec.setWidth 8 (s5_14 >>> 15)) ++
                            ((BitVec.setWidth 8 (s5_13 >>> 7)) ++
                              ((BitVec.setWidth 8 s5_14 <<< 1 |||
                                  BitVec.setWidth 8 (s4_13 >>> 20)) ++
                                ((BitVec.setWidth 16 (s4_12 >>> 4)) ++
                                  ((BitVec.setWidth 8 s4_13 <<< 4 |||
                                      BitVec.setWidth 8 (s3_12 >>> 17)) ++
                                    ((BitVec.setWidth 16 (s3_11 >>> 1)) ++
                                      ((BitVec.setWidth 8 s3_12 <<< 7 |||
                                          BitVec.setWidth 8 (s2_11 >>> 14)) ++
                                        ((BitVec.setWidth 8 (s2_10 >>> 6)) ++
                                          ((BitVec.setWidth 8 s2_11 <<< 2 |||
                                              BitVec.setWidth 8 (s1_10 >>> 19)) ++
                                            ((BitVec.setWidth 16 (s1_9 >>> 3)) ++
                                              ((BitVec.setWidth 8 s1_10 <<< 5 |||
                                                  BitVec.setWidth 8 (s0_5 >>> 16) &&& 31#8) ++
                                                ((BitVec.setWidth 16 s0_5))))))))))))))))))))))))

/-- The compiled code's computation, one `let` per value, on the 64 bytes `x`. -/
def sc25519_reduce.ir (x : BitVec 512) : BitVec 256 :=
  let t1595 := load3 x 0
  let t1596 := t1595 &&& 2097151#64
  let t1598 := load4 x 2
  let t1599 := t1598 >>> 5
  let t1600 := t1599 &&& 2097151#64
  let t1602 := load3 x 5
  let t1603 := t1602 >>> 2
  let t1604 := t1603 &&& 2097151#64
  let t1606 := load4 x 7
  let t1607 := t1606 >>> 7
  let t1608 := t1607 &&& 2097151#64
  let t1610 := load4 x 10
  let t1611 := t1610 >>> 4
  let t1612 := t1611 &&& 2097151#64
  let t1614 := load3 x 13
  let t1615 := t1614 >>> 1
  let t1616 := t1615 &&& 2097151#64
  let t1618 := load4 x 15
  let t1619 := t1618 >>> 6
  let t1620 := t1619 &&& 2097151#64
  let t1622 := load3 x 18
  let t1623 := t1622 >>> 3
  let t1625 := load3 x 21
  let t1626 := t1625 &&& 2097151#64
  let t1628 := load4 x 23
  let t1629 := t1628 >>> 5
  let t1630 := t1629 &&& 2097151#64
  let t1632 := load3 x 26
  let t1633 := t1632 >>> 2
  let t1634 := t1633 &&& 2097151#64
  let t1636 := load4 x 28
  let t1637 := t1636 >>> 7
  let t1638 := t1637 &&& 2097151#64
  let t1640 := load4 x 31
  let t1641 := t1640 >>> 4
  let t1642 := t1641 &&& 2097151#64
  let t1644 := load3 x 34
  let t1645 := t1644 >>> 1
  let t1646 := t1645 &&& 2097151#64
  let t1648 := load4 x 36
  let t1649 := t1648 >>> 6
  let t1650 := t1649 &&& 2097151#64
  let t1652 := load3 x 39
  let t1653 := t1652 >>> 3
  let t1655 := load3 x 42
  let t1656 := t1655 &&& 2097151#64
  let t1658 := load4 x 44
  let t1659 := t1658 >>> 5
  let t1660 := t1659 &&& 2097151#64
  let t1662 := load3 x 47
  let t1663 := t1662 >>> 2
  let t1664 := t1663 &&& 2097151#64
  let t1666 := load4 x 49
  let t1667 := t1666 >>> 7
  let t1668 := t1667 &&& 2097151#64
  let t1670 := load4 x 52
  let t1671 := t1670 >>> 4
  let t1672 := t1671 &&& 2097151#64
  let t1674 := load3 x 55
  let t1675 := t1674 >>> 1
  let t1676 := t1675 &&& 2097151#64
  let t1678 := load4 x 57
  let t1679 := t1678 >>> 6
  let t1680 := t1679 &&& 2097151#64
  let t1682 := load4 x 60
  let t1683 := t1682 >>> 3
  let t1684 := t1683 * 666643#64
  let t1685 := t1683 * 470296#64
  let t1686 := t1683 * 654183#64
  let t1687 := t1683 * 18446744073708553811#64
  let t1688 := t1683 * 136657#64
  let t1689 := t1688 + t1653
  let t1690 := t1683 * 18446744073708867715#64
  let t1691 := t1690 + t1656
  let t1692 := t1680 * 666643#64
  let t1693 := t1680 * 470296#64
  let t1694 := t1680 * 654183#64
  let t1695 := t1680 * 18446744073708553811#64
  let t1696 := t1680 * 136657#64
  let t1697 := t1680 * 18446744073708867715#64
  let t1698 := t1689 + t1697
  let t1699 := t1676 * 666643#64
  let t1700 := t1676 * 470296#64
  let t1701 := t1676 * 654183#64
  let t1702 := t1676 * 18446744073708553811#64
  let t1703 := t1676 * 136657#64
  let t1704 := t1676 * 18446744073708867715#64
  let t1705 := t1704 + t1650
  let t1706 := t1705 + t1687
  let t1707 := t1706 + t1696
  let t1708 := t1672 * 666643#64
  let t1709 := t1672 * 470296#64
  let t1710 := t1672 * 654183#64
  let t1711 := t1672 * 18446744073708553811#64
  let t1712 := t1672 * 136657#64
  let t1713 := t1672 * 18446744073708867715#64
  let t1714 := t1668 * 666643#64
  let t1715 := t1668 * 470296#64
  let t1716 := t1668 * 654183#64
  let t1717 := t1668 * 18446744073708553811#64
  let t1718 := t1668 * 136657#64
  let t1719 := t1668 * 18446744073708867715#64
  let t1720 := t1719 + t1642
  let t1721 := t1720 + t1712
  let t1722 := t1721 + t1702
  let t1723 := t1722 + t1685
  let t1724 := t1723 + t1694
  let t1725 := t1664 * 666643#64
  let t1726 := t1725 + t1620
  let t1727 := t1664 * 470296#64
  let t1728 := t1664 * 654183#64
  let t1729 := t1728 + t1626
  let t1730 := t1729 + t1715
  let t1731 := t1730 + t1708
  let t1732 := t1664 * 18446744073708553811#64
  let t1733 := t1664 * 136657#64
  let t1734 := t1733 + t1634
  let t1735 := t1734 + t1717
  let t1736 := t1735 + t1710
  let t1737 := t1736 + t1700
  let t1738 := t1737 + t1692
  let t1739 := t1664 * 18446744073708867715#64
  let t1740 := t1726 + 1048576#64
  let t1741 := t1740 >>> 21
  let t1742 := t1727 + t1623
  let t1743 := t1742 + t1714
  let t1744 := t1743 + t1741
  let t1745 := t1740 &&& 8796090925056#64
  let t1746 := t1726 - t1745
  let t1747 := t1731 + 1048576#64
  let t1748 := t1747 >>> 21
  let t1749 := t1732 + t1630
  let t1750 := t1749 + t1716
  let t1751 := t1750 + t1709
  let t1752 := t1751 + t1699
  let t1753 := t1752 + t1748
  let t1754 := t1747 &&& 9223372036852678656#64
  let t1755 := t1738 + 1048576#64
  let t1756 := t1755.sshiftRight 21
  let t1757 := t1739 + t1638
  let t1758 := t1757 + t1718
  let t1759 := t1758 + t1711
  let t1760 := t1759 + t1701
  let t1761 := t1760 + t1684
  let t1762 := t1761 + t1693
  let t1763 := t1762 + t1756
  let t1764 := t1755 &&& 18446744073707454464#64
  let t1765 := t1724 + 1048576#64
  let t1766 := t1765.sshiftRight 21
  let t1767 := t1713 + t1646
  let t1768 := t1767 + t1703
  let t1769 := t1768 + t1686
  let t1770 := t1769 + t1695
  let t1771 := t1770 + t1766
  let t1772 := t1765 &&& 18446744073707454464#64
  let t1773 := t1724 - t1772
  let t1774 := t1707 + 1048576#64
  let t1775 := t1774.sshiftRight 21
  let t1776 := t1698 + t1775
  let t1777 := t1774 &&& 18446744073707454464#64
  let t1778 := t1707 - t1777
  let t1779 := t1691 + 1048576#64
  let t1780 := t1779.sshiftRight 21
  let t1781 := t1780 + t1660
  let t1782 := t1779 &&& 18446744073707454464#64
  let t1783 := t1691 - t1782
  let t1784 := t1744 + 1048576#64
  let t1785 := t1784 >>> 21
  let t1786 := t1784 &&& 9223372036852678656#64
  let t1787 := t1744 - t1786
  let t1788 := t1753 + 1048576#64
  let t1789 := t1788.sshiftRight 21
  let t1790 := t1788 &&& 18446744073707454464#64
  let t1791 := t1763 + 1048576#64
  let t1792 := t1791.sshiftRight 21
  let t1793 := t1792 + t1773
  let t1794 := t1791 &&& 18446744073707454464#64
  let t1795 := t1763 - t1794
  let t1796 := t1771 + 1048576#64
  let t1797 := t1796.sshiftRight 21
  let t1798 := t1797 + t1778
  let t1799 := t1796 &&& 18446744073707454464#64
  let t1800 := t1771 - t1799
  let t1801 := t1776 + 1048576#64
  let t1802 := t1801.sshiftRight 21
  let t1803 := t1802 + t1783
  let t1804 := t1801 &&& 18446744073707454464#64
  let t1805 := t1776 - t1804
  let t1806 := t1781 * 666643#64
  let t1807 := t1806 + t1616
  let t1808 := t1781 * 470296#64
  let t1809 := t1746 + t1808
  let t1810 := t1781 * 654183#64
  let t1811 := t1787 + t1810
  let t1812 := t1781 * 18446744073708553811#64
  let t1813 := t1781 * 136657#64
  let t1814 := t1781 * 18446744073708867715#64
  let t1815 := t1814 + t1738
  let t1816 := t1815 + t1789
  let t1817 := t1816 - t1764
  let t1818 := t1803 * 666643#64
  let t1819 := t1818 + t1612
  let t1820 := t1803 * 470296#64
  let t1821 := t1807 + t1820
  let t1822 := t1803 * 654183#64
  let t1823 := t1809 + t1822
  let t1824 := t1803 * 18446744073708553811#64
  let t1825 := t1811 + t1824
  let t1826 := t1803 * 136657#64
  let t1827 := t1803 * 18446744073708867715#64
  let t1828 := t1805 * 666643#64
  let t1829 := t1828 + t1608
  let t1830 := t1805 * 470296#64
  let t1831 := t1819 + t1830
  let t1832 := t1805 * 654183#64
  let t1833 := t1821 + t1832
  let t1834 := t1805 * 18446744073708553811#64
  let t1835 := t1823 + t1834
  let t1836 := t1805 * 136657#64
  let t1837 := t1825 + t1836
  let t1838 := t1805 * 18446744073708867715#64
  let t1839 := t1785 + t1731
  let t1840 := t1839 - t1754
  let t1841 := t1840 + t1812
  let t1842 := t1841 + t1826
  let t1843 := t1842 + t1838
  let t1844 := t1798 * 666643#64
  let t1845 := t1844 + t1604
  let t1846 := t1798 * 470296#64
  let t1847 := t1829 + t1846
  let t1848 := t1798 * 654183#64
  let t1849 := t1831 + t1848
  let t1850 := t1798 * 18446744073708553811#64
  let t1851 := t1833 + t1850
  let t1852 := t1798 * 136657#64
  let t1853 := t1835 + t1852
  let t1854 := t1798 * 18446744073708867715#64
  let t1855 := t1837 + t1854
  let t1856 := t1800 * 666643#64
  let t1857 := t1856 + t1600
  let t1858 := t1800 * 470296#64
  let t1859 := t1845 + t1858
  let t1860 := t1800 * 654183#64
  let t1861 := t1847 + t1860
  let t1862 := t1800 * 18446744073708553811#64
  let t1863 := t1849 + t1862
  let t1864 := t1800 * 136657#64
  let t1865 := t1851 + t1864
  let t1866 := t1800 * 18446744073708867715#64
  let t1867 := t1853 + t1866
  let t1868 := t1793 * 666643#64
  let t1869 := t1868 + t1596
  let t1870 := t1793 * 470296#64
  let t1871 := t1857 + t1870
  let t1872 := t1793 * 654183#64
  let t1873 := t1859 + t1872
  let t1874 := t1793 * 18446744073708553811#64
  let t1875 := t1861 + t1874
  let t1876 := t1793 * 136657#64
  let t1877 := t1863 + t1876
  let t1878 := t1793 * 18446744073708867715#64
  let t1879 := t1865 + t1878
  let t1880 := t1869 + 1048576#64
  let t1881 := t1880.sshiftRight 21
  let t1882 := t1871 + t1881
  let t1883 := t1880 &&& 18446744073707454464#64
  let t1884 := t1869 - t1883
  let t1885 := t1873 + 1048576#64
  let t1886 := t1885.sshiftRight 21
  let t1887 := t1875 + t1886
  let t1888 := t1885 &&& 18446744073707454464#64
  let t1889 := t1877 + 1048576#64
  let t1890 := t1889.sshiftRight 21
  let t1891 := t1879 + t1890
  let t1892 := t1889 &&& 18446744073707454464#64
  let t1893 := t1867 + 1048576#64
  let t1894 := t1893.sshiftRight 21
  let t1895 := t1855 + t1894
  let t1896 := t1893 &&& 18446744073707454464#64
  let t1897 := t1867 - t1896
  let t1898 := t1843 + 1048576#64
  let t1899 := t1898.sshiftRight 21
  let t1900 := t1813 + t1753
  let t1901 := t1900 - t1790
  let t1902 := t1901 + t1827
  let t1903 := t1902 + t1899
  let t1904 := t1898 &&& 18446744073707454464#64
  let t1905 := t1843 - t1904
  let t1906 := t1817 + 1048576#64
  let t1907 := t1906.sshiftRight 21
  let t1908 := t1907 + t1795
  let t1909 := t1906 &&& 18446744073707454464#64
  let t1910 := t1817 - t1909
  let t1911 := t1882 + 1048576#64
  let t1912 := t1911.sshiftRight 21
  let t1913 := t1911 &&& 18446744073707454464#64
  let t1914 := t1887 + 1048576#64
  let t1915 := t1914.sshiftRight 21
  let t1916 := t1914 &&& 18446744073707454464#64
  let t1917 := t1891 + 1048576#64
  let t1918 := t1917.sshiftRight 21
  let t1919 := t1897 + t1918
  let t1920 := t1917 &&& 18446744073707454464#64
  let t1921 := t1895 + 1048576#64
  let t1922 := t1921.sshiftRight 21
  let t1923 := t1905 + t1922
  let t1924 := t1921 &&& 18446744073707454464#64
  let t1925 := t1895 - t1924
  let t1926 := t1903 + 1048576#64
  let t1927 := t1926.sshiftRight 21
  let t1928 := t1910 + t1927
  let t1929 := t1926 &&& 18446744073707454464#64
  let t1930 := t1903 - t1929
  let t1931 := t1908 + 1048576#64
  let t1932 := t1931.sshiftRight 21
  let t1933 := t1931 &&& 18446744073707454464#64
  let t1934 := t1908 - t1933
  let t1935 := t1932 * 666643#64
  let t1936 := t1884 + t1935
  let t1937 := t1932 * 470296#64
  let t1938 := t1932 * 654183#64
  let t1939 := t1932 * 18446744073708553811#64
  let t1940 := t1932 * 136657#64
  let t1941 := t1932 * 18446744073708867715#64
  let t1942 := t1936.sshiftRight 21
  let t1943 := t1937 + t1882
  let t1944 := t1943 - t1913
  let t1945 := t1944 + t1942
  let t1946 := t1936 &&& 2097151#64
  let t1947 := t1945.sshiftRight 21
  let t1948 := t1938 + t1873
  let t1949 := t1948 - t1888
  let t1950 := t1949 + t1912
  let t1951 := t1950 + t1947
  let t1952 := t1945 &&& 2097151#64
  let t1953 := t1951.sshiftRight 21
  let t1954 := t1887 + t1939
  let t1955 := t1954 - t1916
  let t1956 := t1955 + t1953
  let t1957 := t1951 &&& 2097151#64
  let t1958 := t1956.sshiftRight 21
  let t1959 := t1940 + t1877
  let t1960 := t1959 - t1892
  let t1961 := t1960 + t1915
  let t1962 := t1961 + t1958
  let t1963 := t1956 &&& 2097151#64
  let t1964 := t1962.sshiftRight 21
  let t1965 := t1891 + t1941
  let t1966 := t1965 - t1920
  let t1967 := t1966 + t1964
  let t1968 := t1962 &&& 2097151#64
  let t1969 := t1967.sshiftRight 21
  let t1970 := t1919 + t1969
  let t1971 := t1967 &&& 2097151#64
  let t1972 := t1970.sshiftRight 21
  let t1973 := t1972 + t1925
  let t1974 := t1970 &&& 2097151#64
  let t1975 := t1973.sshiftRight 21
  let t1976 := t1923 + t1975
  let t1977 := t1973 &&& 2097151#64
  let t1978 := t1976.sshiftRight 21
  let t1979 := t1978 + t1930
  let t1980 := t1976 &&& 2097151#64
  let t1981 := t1979.sshiftRight 21
  let t1982 := t1928 + t1981
  let t1983 := t1979 &&& 2097151#64
  let t1984 := t1982.sshiftRight 21
  let t1985 := t1984 + t1934
  let t1986 := t1982 &&& 2097151#64
  let t1987 := t1985.sshiftRight 21
  let t1988 := t1985 &&& 2097151#64
  let t1989 := t1987 * 666643#64
  let t1990 := t1989 + t1946
  let t1991 := t1987 * 470296#64
  let t1992 := t1991 + t1952
  let t1993 := t1987 * 654183#64
  let t1994 := t1993 + t1957
  let t1995 := t1987 * 18446744073708553811#64
  let t1996 := t1995 + t1963
  let t1997 := t1987 * 136657#64
  let t1998 := t1997 + t1968
  let t1999 := t1987 * 18446744073708867715#64
  let t2000 := t1999 + t1971
  let t2001 := t1990.sshiftRight 21
  let t2002 := t1992 + t2001
  let t2003 := t2002.sshiftRight 21
  let t2004 := t1994 + t2003
  let t2005 := t2002 &&& 2097151#64
  let t2006 := t2004.sshiftRight 21
  let t2007 := t1996 + t2006
  let t2008 := t2004 &&& 2097151#64
  let t2009 := t2007.sshiftRight 21
  let t2010 := t1998 + t2009
  let t2011 := t2007 &&& 2097151#64
  let t2012 := t2010.sshiftRight 21
  let t2013 := t2000 + t2012
  let t2014 := t2010 &&& 2097151#64
  let t2015 := t2013.sshiftRight 21
  let t2016 := t2015 + t1974
  let t2017 := t2013 &&& 2097151#64
  let t2018 := t2016.sshiftRight 21
  let t2019 := t2018 + t1977
  let t2020 := t2016 &&& 2097151#64
  let t2021 := t2019.sshiftRight 21
  let t2022 := t2021 + t1980
  let t2023 := t2022.sshiftRight 21
  let t2024 := t2023 + t1983
  let t2025 := t2024.sshiftRight 21
  let t2026 := t2025 + t1986
  let t2027 := t2024 &&& 2097151#64
  let t2028 := t2026.sshiftRight 21
  let t2029 := t2028 + t1988
  let t2030 := t2026 &&& 2097151#64
  sc25519_reduce.out t1990 t2002 t2004 t2005 t2007 t2008 t2010 t2011 t2013 t2014 t2016 t2017 t2019
    t2020 t2022 t2024 t2026 t2027 t2029 t2030

/-- `%1741` shifts a non-negative value: logically as arithmetically. -/
theorem sc25519_reduce.lshr1741 (x : BitVec 512) :
    ((((((load3 x 47) >>> 2) &&& (2097151#64)) * (666643#64)) +
            (((load4 x 15) >>> 6) &&& (2097151#64))) +
          (1048576#64)) >>>
        21 =
      ((((((load3 x 47) >>> 2) &&& (2097151#64)) * (666643#64)) +
              (((load4 x 15) >>> 6) &&& (2097151#64))) +
            (1048576#64)).sshiftRight
        21 := by
  unfold load3 load4
  bv_decide

/-- `carry6` as the C computes it is the compiled `%1741`. -/
theorem sc25519_reduce.bridge_carry6
    (t1725 t1726 t1740 t1741 t1664 t1620 s6_1 carry6 s6 s18 : BitVec 64)
    (ht1725 : t1725 = t1664 * 666643#64) (ht1726 : t1726 = t1725 + t1620)
    (ht1740 : t1740 = t1726 + 1048576#64) (ht1741 : t1741 = t1740.sshiftRight 21)
    (et1664 : t1664 = s18) (et1620 : t1620 = s6) (hs6_1 : s6_1 = s6 + s18 * 666643#64)
    (hcarry6 : carry6 = (s6_1 + 1048576#64).sshiftRight 21) : t1741 = carry6 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `%1745`'s mask, on a non-negative value, clears its low 21 bits. -/
theorem sc25519_reduce.mask1745 (x : BitVec 512) :
    ((((((load3 x 47) >>> 2) &&& (2097151#64)) * (666643#64)) +
            (((load4 x 15) >>> 6) &&& (2097151#64))) +
          (1048576#64)) &&&
        8796090925056#64 =
      ((((((load3 x 47) >>> 2) &&& (2097151#64)) * (666643#64)) +
              (((load4 x 15) >>> 6) &&& (2097151#64))) +
            (1048576#64)) >>>
          21 <<<
        21 := by
  unfold load3 load4
  bv_decide

/-- `%1748` shifts a non-negative value: logically as arithmetically. -/
theorem sc25519_reduce.lshr1748 (x : BitVec 512) :
    ((((((((load3 x 47) >>> 2) &&& (2097151#64)) * (654183#64)) + ((load3 x 21) &&& (2097151#64))) +
              ((((load4 x 49) >>> 7) &&& (2097151#64)) * (470296#64))) +
            ((((load4 x 52) >>> 4) &&& (2097151#64)) * (666643#64))) +
          (1048576#64)) >>>
        21 =
      ((((((((load3 x 47) >>> 2) &&& (2097151#64)) * (654183#64)) +
                  ((load3 x 21) &&& (2097151#64))) +
                ((((load4 x 49) >>> 7) &&& (2097151#64)) * (470296#64))) +
              ((((load4 x 52) >>> 4) &&& (2097151#64)) * (666643#64))) +
            (1048576#64)).sshiftRight
        21 := by
  unfold load3 load4
  bv_decide

/-- `carry8` as the C computes it is the compiled `%1748`. -/
theorem sc25519_reduce.bridge_carry8
    (t1708 t1715 t1728 t1729 t1730 t1731 t1747 t1748 t1664 t1626 t1668 t1672 s8_1 s8_2 s8_3 carry8
      s8 s18 s19 s20 : BitVec 64)
    (ht1708 : t1708 = t1672 * 666643#64) (ht1715 : t1715 = t1668 * 470296#64)
    (ht1728 : t1728 = t1664 * 654183#64) (ht1729 : t1729 = t1728 + t1626)
    (ht1730 : t1730 = t1729 + t1715) (ht1731 : t1731 = t1730 + t1708)
    (ht1747 : t1747 = t1731 + 1048576#64) (ht1748 : t1748 = t1747.sshiftRight 21)
    (et1664 : t1664 = s18) (et1626 : t1626 = s8) (et1668 : t1668 = s19) (et1672 : t1672 = s20)
    (hs8_1 : s8_1 = s8 + s20 * 666643#64) (hs8_2 : s8_2 = s8_1 + s19 * 470296#64)
    (hs8_3 : s8_3 = s8_2 + s18 * 654183#64)
    (hcarry8 : carry8 = (s8_3 + 1048576#64).sshiftRight 21) : t1748 = carry8 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `%1754`'s mask, on a non-negative value, clears its low 21 bits. -/
theorem sc25519_reduce.mask1754 (x : BitVec 512) :
    ((((((((load3 x 47) >>> 2) &&& (2097151#64)) * (654183#64)) + ((load3 x 21) &&& (2097151#64))) +
              ((((load4 x 49) >>> 7) &&& (2097151#64)) * (470296#64))) +
            ((((load4 x 52) >>> 4) &&& (2097151#64)) * (666643#64))) +
          (1048576#64)) &&&
        9223372036852678656#64 =
      ((((((((load3 x 47) >>> 2) &&& (2097151#64)) * (654183#64)) +
                  ((load3 x 21) &&& (2097151#64))) +
                ((((load4 x 49) >>> 7) &&& (2097151#64)) * (470296#64))) +
              ((((load4 x 52) >>> 4) &&& (2097151#64)) * (666643#64))) +
            (1048576#64)) >>>
          21 <<<
        21 := by
  unfold load3 load4
  bv_decide

/-- `carry10` as the C computes it is the compiled `%1756`. -/
theorem sc25519_reduce.bridge_carry10
    (t1692 t1700 t1710 t1717 t1733 t1734 t1735 t1736 t1737 t1738 t1755 t1756 t1664 t1634 t1668 t1672
      t1676 t1680 s10_1 s10_2 s10_3 s10_4 s10_5 carry10 s10 s18 s19 s20 s21 s22 : BitVec 64)
    (ht1692 : t1692 = t1680 * 666643#64) (ht1700 : t1700 = t1676 * 470296#64)
    (ht1710 : t1710 = t1672 * 654183#64) (ht1717 : t1717 = t1668 * 18446744073708553811#64)
    (ht1733 : t1733 = t1664 * 136657#64) (ht1734 : t1734 = t1733 + t1634)
    (ht1735 : t1735 = t1734 + t1717) (ht1736 : t1736 = t1735 + t1710)
    (ht1737 : t1737 = t1736 + t1700) (ht1738 : t1738 = t1737 + t1692)
    (ht1755 : t1755 = t1738 + 1048576#64) (ht1756 : t1756 = t1755.sshiftRight 21)
    (et1664 : t1664 = s18) (et1634 : t1634 = s10) (et1668 : t1668 = s19) (et1672 : t1672 = s20)
    (et1676 : t1676 = s21) (et1680 : t1680 = s22) (hs10_1 : s10_1 = s10 + s22 * 666643#64)
    (hs10_2 : s10_2 = s10_1 + s21 * 470296#64) (hs10_3 : s10_3 = s10_2 + s20 * 654183#64)
    (hs10_4 : s10_4 = s10_3 - s19 * 997805#64) (hs10_5 : s10_5 = s10_4 + s18 * 136657#64)
    (hcarry10 : carry10 = (s10_5 + 1048576#64).sshiftRight 21) : t1756 = carry10 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `carry12` as the C computes it is the compiled `%1766`. -/
theorem sc25519_reduce.bridge_carry12
    (t1685 t1694 t1702 t1712 t1719 t1720 t1721 t1722 t1723 t1724 t1765 t1766 t1668 t1642 t1672 t1676
      t1683 t1680 s12_1 s12_2 s12_3 s12_4 s12_5 carry12 s12 s19 s20 s21 s22 s23 : BitVec 64)
    (ht1685 : t1685 = t1683 * 470296#64) (ht1694 : t1694 = t1680 * 654183#64)
    (ht1702 : t1702 = t1676 * 18446744073708553811#64) (ht1712 : t1712 = t1672 * 136657#64)
    (ht1719 : t1719 = t1668 * 18446744073708867715#64) (ht1720 : t1720 = t1719 + t1642)
    (ht1721 : t1721 = t1720 + t1712) (ht1722 : t1722 = t1721 + t1702)
    (ht1723 : t1723 = t1722 + t1685) (ht1724 : t1724 = t1723 + t1694)
    (ht1765 : t1765 = t1724 + 1048576#64) (ht1766 : t1766 = t1765.sshiftRight 21)
    (et1668 : t1668 = s19) (et1642 : t1642 = s12) (et1672 : t1672 = s20) (et1676 : t1676 = s21)
    (et1683 : t1683 = s23) (et1680 : t1680 = s22) (hs12_1 : s12_1 = s12 + s23 * 470296#64)
    (hs12_2 : s12_2 = s12_1 + s22 * 654183#64) (hs12_3 : s12_3 = s12_2 - s21 * 997805#64)
    (hs12_4 : s12_4 = s12_3 + s20 * 136657#64) (hs12_5 : s12_5 = s12_4 - s19 * 683901#64)
    (hcarry12 : carry12 = (s12_5 + 1048576#64).sshiftRight 21) : t1766 = carry12 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `carry14` as the C computes it is the compiled `%1775`. -/
theorem sc25519_reduce.bridge_carry14
    (t1687 t1696 t1704 t1705 t1706 t1707 t1774 t1775 t1676 t1650 t1683 t1680 s14_1 s14_2 s14_3
      carry14 s14 s21 s22 s23 : BitVec 64)
    (ht1687 : t1687 = t1683 * 18446744073708553811#64) (ht1696 : t1696 = t1680 * 136657#64)
    (ht1704 : t1704 = t1676 * 18446744073708867715#64) (ht1705 : t1705 = t1704 + t1650)
    (ht1706 : t1706 = t1705 + t1687) (ht1707 : t1707 = t1706 + t1696)
    (ht1774 : t1774 = t1707 + 1048576#64) (ht1775 : t1775 = t1774.sshiftRight 21)
    (et1676 : t1676 = s21) (et1650 : t1650 = s14) (et1683 : t1683 = s23) (et1680 : t1680 = s22)
    (hs14_1 : s14_1 = s14 - s23 * 997805#64) (hs14_2 : s14_2 = s14_1 + s22 * 136657#64)
    (hs14_3 : s14_3 = s14_2 - s21 * 683901#64)
    (hcarry14 : carry14 = (s14_3 + 1048576#64).sshiftRight 21) : t1775 = carry14 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `carry16` as the C computes it is the compiled `%1780`. -/
theorem sc25519_reduce.bridge_carry16
    (t1690 t1691 t1779 t1780 t1683 t1656 s16_1 carry16 s16 s23 : BitVec 64)
    (ht1690 : t1690 = t1683 * 18446744073708867715#64) (ht1691 : t1691 = t1690 + t1656)
    (ht1779 : t1779 = t1691 + 1048576#64) (ht1780 : t1780 = t1779.sshiftRight 21)
    (et1683 : t1683 = s23) (et1656 : t1656 = s16) (hs16_1 : s16_1 = s16 - s23 * 683901#64)
    (hcarry16 : carry16 = (s16_1 + 1048576#64).sshiftRight 21) : t1780 = carry16 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `%1785` shifts a non-negative value: logically as arithmetically. -/
theorem sc25519_reduce.lshr1785 (x : BitVec 512) :
    ((((((((load3 x 47) >>> 2) &&& (2097151#64)) * (470296#64)) + ((load3 x 18) >>> 3)) +
              ((((load4 x 49) >>> 7) &&& (2097151#64)) * (666643#64))) +
            (((((((load3 x 47) >>> 2) &&& (2097151#64)) * (666643#64)) +
                  (((load4 x 15) >>> 6) &&& (2097151#64))) +
                (1048576#64)) >>>
              21)) +
          (1048576#64)) >>>
        21 =
      ((((((((load3 x 47) >>> 2) &&& (2097151#64)) * (470296#64)) + ((load3 x 18) >>> 3)) +
                ((((load4 x 49) >>> 7) &&& (2097151#64)) * (666643#64))) +
              (((((((load3 x 47) >>> 2) &&& (2097151#64)) * (666643#64)) +
                    (((load4 x 15) >>> 6) &&& (2097151#64))) +
                  (1048576#64)) >>>
                21)) +
            (1048576#64)).sshiftRight
        21 := by
  unfold load3 load4
  bv_decide

/-- `carry7` as the C computes it is the compiled `%1785`. -/
theorem sc25519_reduce.bridge_carry7
    (t1714 t1727 t1742 t1743 t1744 t1784 t1785 t1664 t1623 t1668 t1741 s7_1 s7_2 s7_3 carry7 s7 s18
      s19 carry6 : BitVec 64)
    (ht1714 : t1714 = t1668 * 666643#64) (ht1727 : t1727 = t1664 * 470296#64)
    (ht1742 : t1742 = t1727 + t1623) (ht1743 : t1743 = t1742 + t1714)
    (ht1744 : t1744 = t1743 + t1741) (ht1784 : t1784 = t1744 + 1048576#64)
    (ht1785 : t1785 = t1784.sshiftRight 21) (et1664 : t1664 = s18) (et1623 : t1623 = s7)
    (et1668 : t1668 = s19) (et1741 : t1741 = carry6) (hs7_1 : s7_1 = s7 + s19 * 666643#64)
    (hs7_2 : s7_2 = s7_1 + s18 * 470296#64) (hs7_3 : s7_3 = s7_2 + carry6)
    (hcarry7 : carry7 = (s7_3 + 1048576#64).sshiftRight 21) : t1785 = carry7 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `%1786`'s mask, on a non-negative value, clears its low 21 bits. -/
theorem sc25519_reduce.mask1786 (x : BitVec 512) :
    ((((((((load3 x 47) >>> 2) &&& (2097151#64)) * (470296#64)) + ((load3 x 18) >>> 3)) +
              ((((load4 x 49) >>> 7) &&& (2097151#64)) * (666643#64))) +
            (((((((load3 x 47) >>> 2) &&& (2097151#64)) * (666643#64)) +
                  (((load4 x 15) >>> 6) &&& (2097151#64))) +
                (1048576#64)) >>>
              21)) +
          (1048576#64)) &&&
        9223372036852678656#64 =
      ((((((((load3 x 47) >>> 2) &&& (2097151#64)) * (470296#64)) + ((load3 x 18) >>> 3)) +
                ((((load4 x 49) >>> 7) &&& (2097151#64)) * (666643#64))) +
              (((((((load3 x 47) >>> 2) &&& (2097151#64)) * (666643#64)) +
                    (((load4 x 15) >>> 6) &&& (2097151#64))) +
                  (1048576#64)) >>>
                21)) +
            (1048576#64)) >>>
          21 <<<
        21 := by
  unfold load3 load4
  bv_decide

/-- `carry9` as the C computes it is the compiled `%1789`. -/
theorem sc25519_reduce.bridge_carry9
    (t1699 t1709 t1716 t1732 t1749 t1750 t1751 t1752 t1753 t1788 t1789 t1664 t1630 t1668 t1672 t1676
      t1748 s9_1 s9_2 s9_3 s9_4 s9_5 carry9 s9 s18 s19 s20 s21 carry8 : BitVec 64)
    (ht1699 : t1699 = t1676 * 666643#64) (ht1709 : t1709 = t1672 * 470296#64)
    (ht1716 : t1716 = t1668 * 654183#64) (ht1732 : t1732 = t1664 * 18446744073708553811#64)
    (ht1749 : t1749 = t1732 + t1630) (ht1750 : t1750 = t1749 + t1716)
    (ht1751 : t1751 = t1750 + t1709) (ht1752 : t1752 = t1751 + t1699)
    (ht1753 : t1753 = t1752 + t1748) (ht1788 : t1788 = t1753 + 1048576#64)
    (ht1789 : t1789 = t1788.sshiftRight 21) (et1664 : t1664 = s18) (et1630 : t1630 = s9)
    (et1668 : t1668 = s19) (et1672 : t1672 = s20) (et1676 : t1676 = s21) (et1748 : t1748 = carry8)
    (hs9_1 : s9_1 = s9 + s21 * 666643#64) (hs9_2 : s9_2 = s9_1 + s20 * 470296#64)
    (hs9_3 : s9_3 = s9_2 + s19 * 654183#64) (hs9_4 : s9_4 = s9_3 - s18 * 997805#64)
    (hs9_5 : s9_5 = s9_4 + carry8) (hcarry9 : carry9 = (s9_5 + 1048576#64).sshiftRight 21) :
    t1789 = carry9 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `carry11` as the C computes it is the compiled `%1792`. -/
theorem sc25519_reduce.bridge_carry11
    (t1684 t1693 t1701 t1711 t1718 t1739 t1757 t1758 t1759 t1760 t1761 t1762 t1763 t1791 t1792 t1664
      t1638 t1668 t1672 t1676 t1683 t1680 t1756 s11_1 s11_2 s11_3 s11_4 s11_5 s11_6 s11_7 carry11
      s11 s18 s19 s20 s21 s22 s23 carry10 : BitVec 64)
    (ht1684 : t1684 = t1683 * 666643#64) (ht1693 : t1693 = t1680 * 470296#64)
    (ht1701 : t1701 = t1676 * 654183#64) (ht1711 : t1711 = t1672 * 18446744073708553811#64)
    (ht1718 : t1718 = t1668 * 136657#64) (ht1739 : t1739 = t1664 * 18446744073708867715#64)
    (ht1757 : t1757 = t1739 + t1638) (ht1758 : t1758 = t1757 + t1718)
    (ht1759 : t1759 = t1758 + t1711) (ht1760 : t1760 = t1759 + t1701)
    (ht1761 : t1761 = t1760 + t1684) (ht1762 : t1762 = t1761 + t1693)
    (ht1763 : t1763 = t1762 + t1756) (ht1791 : t1791 = t1763 + 1048576#64)
    (ht1792 : t1792 = t1791.sshiftRight 21) (et1664 : t1664 = s18) (et1638 : t1638 = s11)
    (et1668 : t1668 = s19) (et1672 : t1672 = s20) (et1676 : t1676 = s21) (et1683 : t1683 = s23)
    (et1680 : t1680 = s22) (et1756 : t1756 = carry10) (hs11_1 : s11_1 = s11 + s23 * 666643#64)
    (hs11_2 : s11_2 = s11_1 + s22 * 470296#64) (hs11_3 : s11_3 = s11_2 + s21 * 654183#64)
    (hs11_4 : s11_4 = s11_3 - s20 * 997805#64) (hs11_5 : s11_5 = s11_4 + s19 * 136657#64)
    (hs11_6 : s11_6 = s11_5 - s18 * 683901#64) (hs11_7 : s11_7 = s11_6 + carry10)
    (hcarry11 : carry11 = (s11_7 + 1048576#64).sshiftRight 21) : t1792 = carry11 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `carry13` as the C computes it is the compiled `%1797`. -/
theorem sc25519_reduce.bridge_carry13
    (t1686 t1695 t1703 t1713 t1767 t1768 t1769 t1770 t1771 t1796 t1797 t1672 t1646 t1676 t1683 t1680
      t1766 s13_1 s13_2 s13_3 s13_4 s13_5 carry13 s13 s20 s21 s22 s23 carry12 : BitVec 64)
    (ht1686 : t1686 = t1683 * 654183#64) (ht1695 : t1695 = t1680 * 18446744073708553811#64)
    (ht1703 : t1703 = t1676 * 136657#64) (ht1713 : t1713 = t1672 * 18446744073708867715#64)
    (ht1767 : t1767 = t1713 + t1646) (ht1768 : t1768 = t1767 + t1703)
    (ht1769 : t1769 = t1768 + t1686) (ht1770 : t1770 = t1769 + t1695)
    (ht1771 : t1771 = t1770 + t1766) (ht1796 : t1796 = t1771 + 1048576#64)
    (ht1797 : t1797 = t1796.sshiftRight 21) (et1672 : t1672 = s20) (et1646 : t1646 = s13)
    (et1676 : t1676 = s21) (et1683 : t1683 = s23) (et1680 : t1680 = s22) (et1766 : t1766 = carry12)
    (hs13_1 : s13_1 = s13 + s23 * 654183#64) (hs13_2 : s13_2 = s13_1 - s22 * 997805#64)
    (hs13_3 : s13_3 = s13_2 + s21 * 136657#64) (hs13_4 : s13_4 = s13_3 - s20 * 683901#64)
    (hs13_5 : s13_5 = s13_4 + carry12) (hcarry13 : carry13 = (s13_5 + 1048576#64).sshiftRight 21) :
    t1797 = carry13 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `carry15` as the C computes it is the compiled `%1802`. -/
theorem sc25519_reduce.bridge_carry15
    (t1688 t1689 t1697 t1698 t1776 t1801 t1802 t1683 t1653 t1680 t1775 s15_1 s15_2 s15_3 carry15 s15
      s22 s23 carry14 : BitVec 64)
    (ht1688 : t1688 = t1683 * 136657#64) (ht1689 : t1689 = t1688 + t1653)
    (ht1697 : t1697 = t1680 * 18446744073708867715#64) (ht1698 : t1698 = t1689 + t1697)
    (ht1776 : t1776 = t1698 + t1775) (ht1801 : t1801 = t1776 + 1048576#64)
    (ht1802 : t1802 = t1801.sshiftRight 21) (et1683 : t1683 = s23) (et1653 : t1653 = s15)
    (et1680 : t1680 = s22) (et1775 : t1775 = carry14) (hs15_1 : s15_1 = s15 + s23 * 136657#64)
    (hs15_2 : s15_2 = s15_1 - s22 * 683901#64) (hs15_3 : s15_3 = s15_2 + carry14)
    (hcarry15 : carry15 = (s15_3 + 1048576#64).sshiftRight 21) : t1802 = carry15 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `carry0` as the C computes it is the compiled `%1881`. -/
theorem sc25519_reduce.bridge_carry0
    (t1685 t1694 t1702 t1712 t1719 t1720 t1721 t1722 t1723 t1724 t1772 t1773 t1793 t1868 t1869 t1880
      t1881 t1792 t1668 t1642 t1672 t1676 t1683 t1680 t1766 t1596 s12_1 s12_2 s12_3 s12_4 s12_5
      s12_6 s12_7 s0_1 carry0 s0 s12 s19 s20 s21 s22 s23 carry12 carry11 : BitVec 64)
    (ht1685 : t1685 = t1683 * 470296#64) (ht1694 : t1694 = t1680 * 654183#64)
    (ht1702 : t1702 = t1676 * 18446744073708553811#64) (ht1712 : t1712 = t1672 * 136657#64)
    (ht1719 : t1719 = t1668 * 18446744073708867715#64) (ht1720 : t1720 = t1719 + t1642)
    (ht1721 : t1721 = t1720 + t1712) (ht1722 : t1722 = t1721 + t1702)
    (ht1723 : t1723 = t1722 + t1685) (ht1724 : t1724 = t1723 + t1694)
    (ht1772 : t1772 = t1766 <<< 21) (ht1773 : t1773 = t1724 - t1772)
    (ht1793 : t1793 = t1792 + t1773) (ht1868 : t1868 = t1793 * 666643#64)
    (ht1869 : t1869 = t1868 + t1596) (ht1880 : t1880 = t1869 + 1048576#64)
    (ht1881 : t1881 = t1880.sshiftRight 21) (et1792 : t1792 = carry11) (et1668 : t1668 = s19)
    (et1642 : t1642 = s12) (et1672 : t1672 = s20) (et1676 : t1676 = s21) (et1683 : t1683 = s23)
    (et1680 : t1680 = s22) (et1766 : t1766 = carry12) (et1596 : t1596 = s0)
    (hs12_1 : s12_1 = s12 + s23 * 470296#64) (hs12_2 : s12_2 = s12_1 + s22 * 654183#64)
    (hs12_3 : s12_3 = s12_2 - s21 * 997805#64) (hs12_4 : s12_4 = s12_3 + s20 * 136657#64)
    (hs12_5 : s12_5 = s12_4 - s19 * 683901#64) (hs12_6 : s12_6 = s12_5 - carry12 <<< 21)
    (hs12_7 : s12_7 = s12_6 + carry11) (hs0_1 : s0_1 = s0 + s12_7 * 666643#64)
    (hcarry0 : carry0 = (s0_1 + 1048576#64).sshiftRight 21) : t1881 = carry0 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `carry2` as the C computes it is the compiled `%1886`. -/
theorem sc25519_reduce.bridge_carry2
    (t1685 t1686 t1687 t1694 t1695 t1696 t1702 t1703 t1704 t1705 t1706 t1707 t1712 t1713 t1719 t1720
      t1721 t1722 t1723 t1724 t1767 t1768 t1769 t1770 t1771 t1772 t1773 t1777 t1778 t1793 t1798
      t1799 t1800 t1844 t1845 t1858 t1859 t1872 t1873 t1885 t1886 t1797 t1676 t1650 t1683 t1680
      t1775 t1604 t1672 t1646 t1766 t1792 t1668 t1642 s12_1 s13_1 s14_1 s12_2 s13_2 s14_2 s12_3
      s13_3 s14_3 s12_4 s13_4 s12_5 s13_5 s12_6 s14_4 s12_7 s14_5 s13_6 s2_1 s2_2 s2_3 carry2 s2 s12
      s13 s14 s19 s20 s21 s22 s23 carry12 carry14 carry11 carry13 : BitVec 64)
    (ht1685 : t1685 = t1683 * 470296#64) (ht1686 : t1686 = t1683 * 654183#64)
    (ht1687 : t1687 = t1683 * 18446744073708553811#64) (ht1694 : t1694 = t1680 * 654183#64)
    (ht1695 : t1695 = t1680 * 18446744073708553811#64) (ht1696 : t1696 = t1680 * 136657#64)
    (ht1702 : t1702 = t1676 * 18446744073708553811#64) (ht1703 : t1703 = t1676 * 136657#64)
    (ht1704 : t1704 = t1676 * 18446744073708867715#64) (ht1705 : t1705 = t1704 + t1650)
    (ht1706 : t1706 = t1705 + t1687) (ht1707 : t1707 = t1706 + t1696)
    (ht1712 : t1712 = t1672 * 136657#64) (ht1713 : t1713 = t1672 * 18446744073708867715#64)
    (ht1719 : t1719 = t1668 * 18446744073708867715#64) (ht1720 : t1720 = t1719 + t1642)
    (ht1721 : t1721 = t1720 + t1712) (ht1722 : t1722 = t1721 + t1702)
    (ht1723 : t1723 = t1722 + t1685) (ht1724 : t1724 = t1723 + t1694)
    (ht1767 : t1767 = t1713 + t1646) (ht1768 : t1768 = t1767 + t1703)
    (ht1769 : t1769 = t1768 + t1686) (ht1770 : t1770 = t1769 + t1695)
    (ht1771 : t1771 = t1770 + t1766) (ht1772 : t1772 = t1766 <<< 21)
    (ht1773 : t1773 = t1724 - t1772) (ht1777 : t1777 = t1775 <<< 21)
    (ht1778 : t1778 = t1707 - t1777) (ht1793 : t1793 = t1792 + t1773)
    (ht1798 : t1798 = t1797 + t1778) (ht1799 : t1799 = t1797 <<< 21)
    (ht1800 : t1800 = t1771 - t1799) (ht1844 : t1844 = t1798 * 666643#64)
    (ht1845 : t1845 = t1844 + t1604) (ht1858 : t1858 = t1800 * 470296#64)
    (ht1859 : t1859 = t1845 + t1858) (ht1872 : t1872 = t1793 * 654183#64)
    (ht1873 : t1873 = t1859 + t1872) (ht1885 : t1885 = t1873 + 1048576#64)
    (ht1886 : t1886 = t1885.sshiftRight 21) (et1797 : t1797 = carry13) (et1676 : t1676 = s21)
    (et1650 : t1650 = s14) (et1683 : t1683 = s23) (et1680 : t1680 = s22) (et1775 : t1775 = carry14)
    (et1604 : t1604 = s2) (et1672 : t1672 = s20) (et1646 : t1646 = s13) (et1766 : t1766 = carry12)
    (et1792 : t1792 = carry11) (et1668 : t1668 = s19) (et1642 : t1642 = s12)
    (hs12_1 : s12_1 = s12 + s23 * 470296#64) (hs13_1 : s13_1 = s13 + s23 * 654183#64)
    (hs14_1 : s14_1 = s14 - s23 * 997805#64) (hs12_2 : s12_2 = s12_1 + s22 * 654183#64)
    (hs13_2 : s13_2 = s13_1 - s22 * 997805#64) (hs14_2 : s14_2 = s14_1 + s22 * 136657#64)
    (hs12_3 : s12_3 = s12_2 - s21 * 997805#64) (hs13_3 : s13_3 = s13_2 + s21 * 136657#64)
    (hs14_3 : s14_3 = s14_2 - s21 * 683901#64) (hs12_4 : s12_4 = s12_3 + s20 * 136657#64)
    (hs13_4 : s13_4 = s13_3 - s20 * 683901#64) (hs12_5 : s12_5 = s12_4 - s19 * 683901#64)
    (hs13_5 : s13_5 = s13_4 + carry12) (hs12_6 : s12_6 = s12_5 - carry12 <<< 21)
    (hs14_4 : s14_4 = s14_3 - carry14 <<< 21) (hs12_7 : s12_7 = s12_6 + carry11)
    (hs14_5 : s14_5 = s14_4 + carry13) (hs13_6 : s13_6 = s13_5 - carry13 <<< 21)
    (hs2_1 : s2_1 = s2 + s14_5 * 666643#64) (hs2_2 : s2_2 = s2_1 + s13_6 * 470296#64)
    (hs2_3 : s2_3 = s2_2 + s12_7 * 654183#64)
    (hcarry2 : carry2 = (s2_3 + 1048576#64).sshiftRight 21) : t1886 = carry2 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `carry4` as the C computes it is the compiled `%1890`. -/
theorem sc25519_reduce.bridge_carry4
    (t1685 t1686 t1687 t1688 t1689 t1690 t1691 t1694 t1695 t1696 t1697 t1698 t1702 t1703 t1704 t1705
      t1706 t1707 t1712 t1713 t1719 t1720 t1721 t1722 t1723 t1724 t1767 t1768 t1769 t1770 t1771
      t1772 t1773 t1776 t1777 t1778 t1782 t1783 t1793 t1798 t1799 t1800 t1803 t1804 t1805 t1818
      t1819 t1830 t1831 t1848 t1849 t1862 t1863 t1876 t1877 t1889 t1890 t1802 t1683 t1656 t1780
      t1612 t1653 t1680 t1775 t1797 t1676 t1650 t1672 t1646 t1766 t1792 t1668 t1642 s12_1 s13_1
      s14_1 s15_1 s16_1 s12_2 s13_2 s14_2 s15_2 s12_3 s13_3 s14_3 s12_4 s13_4 s12_5 s13_5 s12_6
      s15_3 s14_4 s16_2 s12_7 s14_5 s13_6 s16_3 s15_4 s4_1 s4_2 s4_3 s4_4 s4_5 carry4 s4 s12 s13 s14
      s15 s16 s19 s20 s21 s22 s23 carry12 carry14 carry16 carry11 carry13 carry15 : BitVec 64)
    (ht1685 : t1685 = t1683 * 470296#64) (ht1686 : t1686 = t1683 * 654183#64)
    (ht1687 : t1687 = t1683 * 18446744073708553811#64) (ht1688 : t1688 = t1683 * 136657#64)
    (ht1689 : t1689 = t1688 + t1653) (ht1690 : t1690 = t1683 * 18446744073708867715#64)
    (ht1691 : t1691 = t1690 + t1656) (ht1694 : t1694 = t1680 * 654183#64)
    (ht1695 : t1695 = t1680 * 18446744073708553811#64) (ht1696 : t1696 = t1680 * 136657#64)
    (ht1697 : t1697 = t1680 * 18446744073708867715#64) (ht1698 : t1698 = t1689 + t1697)
    (ht1702 : t1702 = t1676 * 18446744073708553811#64) (ht1703 : t1703 = t1676 * 136657#64)
    (ht1704 : t1704 = t1676 * 18446744073708867715#64) (ht1705 : t1705 = t1704 + t1650)
    (ht1706 : t1706 = t1705 + t1687) (ht1707 : t1707 = t1706 + t1696)
    (ht1712 : t1712 = t1672 * 136657#64) (ht1713 : t1713 = t1672 * 18446744073708867715#64)
    (ht1719 : t1719 = t1668 * 18446744073708867715#64) (ht1720 : t1720 = t1719 + t1642)
    (ht1721 : t1721 = t1720 + t1712) (ht1722 : t1722 = t1721 + t1702)
    (ht1723 : t1723 = t1722 + t1685) (ht1724 : t1724 = t1723 + t1694)
    (ht1767 : t1767 = t1713 + t1646) (ht1768 : t1768 = t1767 + t1703)
    (ht1769 : t1769 = t1768 + t1686) (ht1770 : t1770 = t1769 + t1695)
    (ht1771 : t1771 = t1770 + t1766) (ht1772 : t1772 = t1766 <<< 21)
    (ht1773 : t1773 = t1724 - t1772) (ht1776 : t1776 = t1698 + t1775)
    (ht1777 : t1777 = t1775 <<< 21) (ht1778 : t1778 = t1707 - t1777) (ht1782 : t1782 = t1780 <<< 21)
    (ht1783 : t1783 = t1691 - t1782) (ht1793 : t1793 = t1792 + t1773)
    (ht1798 : t1798 = t1797 + t1778) (ht1799 : t1799 = t1797 <<< 21)
    (ht1800 : t1800 = t1771 - t1799) (ht1803 : t1803 = t1802 + t1783)
    (ht1804 : t1804 = t1802 <<< 21) (ht1805 : t1805 = t1776 - t1804)
    (ht1818 : t1818 = t1803 * 666643#64) (ht1819 : t1819 = t1818 + t1612)
    (ht1830 : t1830 = t1805 * 470296#64) (ht1831 : t1831 = t1819 + t1830)
    (ht1848 : t1848 = t1798 * 654183#64) (ht1849 : t1849 = t1831 + t1848)
    (ht1862 : t1862 = t1800 * 18446744073708553811#64) (ht1863 : t1863 = t1849 + t1862)
    (ht1876 : t1876 = t1793 * 136657#64) (ht1877 : t1877 = t1863 + t1876)
    (ht1889 : t1889 = t1877 + 1048576#64) (ht1890 : t1890 = t1889.sshiftRight 21)
    (et1802 : t1802 = carry15) (et1683 : t1683 = s23) (et1656 : t1656 = s16)
    (et1780 : t1780 = carry16) (et1612 : t1612 = s4) (et1653 : t1653 = s15) (et1680 : t1680 = s22)
    (et1775 : t1775 = carry14) (et1797 : t1797 = carry13) (et1676 : t1676 = s21)
    (et1650 : t1650 = s14) (et1672 : t1672 = s20) (et1646 : t1646 = s13) (et1766 : t1766 = carry12)
    (et1792 : t1792 = carry11) (et1668 : t1668 = s19) (et1642 : t1642 = s12)
    (hs12_1 : s12_1 = s12 + s23 * 470296#64) (hs13_1 : s13_1 = s13 + s23 * 654183#64)
    (hs14_1 : s14_1 = s14 - s23 * 997805#64) (hs15_1 : s15_1 = s15 + s23 * 136657#64)
    (hs16_1 : s16_1 = s16 - s23 * 683901#64) (hs12_2 : s12_2 = s12_1 + s22 * 654183#64)
    (hs13_2 : s13_2 = s13_1 - s22 * 997805#64) (hs14_2 : s14_2 = s14_1 + s22 * 136657#64)
    (hs15_2 : s15_2 = s15_1 - s22 * 683901#64) (hs12_3 : s12_3 = s12_2 - s21 * 997805#64)
    (hs13_3 : s13_3 = s13_2 + s21 * 136657#64) (hs14_3 : s14_3 = s14_2 - s21 * 683901#64)
    (hs12_4 : s12_4 = s12_3 + s20 * 136657#64) (hs13_4 : s13_4 = s13_3 - s20 * 683901#64)
    (hs12_5 : s12_5 = s12_4 - s19 * 683901#64) (hs13_5 : s13_5 = s13_4 + carry12)
    (hs12_6 : s12_6 = s12_5 - carry12 <<< 21) (hs15_3 : s15_3 = s15_2 + carry14)
    (hs14_4 : s14_4 = s14_3 - carry14 <<< 21) (hs16_2 : s16_2 = s16_1 - carry16 <<< 21)
    (hs12_7 : s12_7 = s12_6 + carry11) (hs14_5 : s14_5 = s14_4 + carry13)
    (hs13_6 : s13_6 = s13_5 - carry13 <<< 21) (hs16_3 : s16_3 = s16_2 + carry15)
    (hs15_4 : s15_4 = s15_3 - carry15 <<< 21) (hs4_1 : s4_1 = s4 + s16_3 * 666643#64)
    (hs4_2 : s4_2 = s4_1 + s15_4 * 470296#64) (hs4_3 : s4_3 = s4_2 + s14_5 * 654183#64)
    (hs4_4 : s4_4 = s4_3 - s13_6 * 997805#64) (hs4_5 : s4_5 = s4_4 + s12_7 * 136657#64)
    (hcarry4 : carry4 = (s4_5 + 1048576#64).sshiftRight 21) : t1890 = carry4 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `carry6_1` as the C computes it is the compiled `%1894`. -/
theorem sc25519_reduce.bridge_carry6_1
    (t1686 t1687 t1688 t1689 t1690 t1691 t1695 t1696 t1697 t1698 t1703 t1704 t1705 t1706 t1707 t1713
      t1725 t1726 t1745 t1746 t1767 t1768 t1769 t1770 t1771 t1776 t1777 t1778 t1781 t1782 t1783
      t1798 t1799 t1800 t1803 t1804 t1805 t1808 t1809 t1822 t1823 t1834 t1835 t1852 t1853 t1866
      t1867 t1893 t1894 t1664 t1620 t1741 t1780 t1660 t1802 t1683 t1656 t1653 t1680 t1775 t1797
      t1676 t1650 t1672 t1646 t1766 s13_1 s14_1 s15_1 s16_1 s13_2 s14_2 s15_2 s13_3 s14_3 s13_4 s6_1
      s6_2 s13_5 s15_3 s14_4 s17_1 s16_2 s14_5 s13_6 s16_3 s15_4 s6_3 s6_4 s6_5 s6_6 s6_7 carry6_1
      s6 s13 s14 s15 s16 s17 s18 s20 s21 s22 s23 carry6 carry12 carry14 carry16 carry13 carry15 :
      BitVec 64)
    (ht1686 : t1686 = t1683 * 654183#64) (ht1687 : t1687 = t1683 * 18446744073708553811#64)
    (ht1688 : t1688 = t1683 * 136657#64) (ht1689 : t1689 = t1688 + t1653)
    (ht1690 : t1690 = t1683 * 18446744073708867715#64) (ht1691 : t1691 = t1690 + t1656)
    (ht1695 : t1695 = t1680 * 18446744073708553811#64) (ht1696 : t1696 = t1680 * 136657#64)
    (ht1697 : t1697 = t1680 * 18446744073708867715#64) (ht1698 : t1698 = t1689 + t1697)
    (ht1703 : t1703 = t1676 * 136657#64) (ht1704 : t1704 = t1676 * 18446744073708867715#64)
    (ht1705 : t1705 = t1704 + t1650) (ht1706 : t1706 = t1705 + t1687)
    (ht1707 : t1707 = t1706 + t1696) (ht1713 : t1713 = t1672 * 18446744073708867715#64)
    (ht1725 : t1725 = t1664 * 666643#64) (ht1726 : t1726 = t1725 + t1620)
    (ht1745 : t1745 = t1741 <<< 21) (ht1746 : t1746 = t1726 - t1745)
    (ht1767 : t1767 = t1713 + t1646) (ht1768 : t1768 = t1767 + t1703)
    (ht1769 : t1769 = t1768 + t1686) (ht1770 : t1770 = t1769 + t1695)
    (ht1771 : t1771 = t1770 + t1766) (ht1776 : t1776 = t1698 + t1775)
    (ht1777 : t1777 = t1775 <<< 21) (ht1778 : t1778 = t1707 - t1777)
    (ht1781 : t1781 = t1780 + t1660) (ht1782 : t1782 = t1780 <<< 21)
    (ht1783 : t1783 = t1691 - t1782) (ht1798 : t1798 = t1797 + t1778)
    (ht1799 : t1799 = t1797 <<< 21) (ht1800 : t1800 = t1771 - t1799)
    (ht1803 : t1803 = t1802 + t1783) (ht1804 : t1804 = t1802 <<< 21)
    (ht1805 : t1805 = t1776 - t1804) (ht1808 : t1808 = t1781 * 470296#64)
    (ht1809 : t1809 = t1746 + t1808) (ht1822 : t1822 = t1803 * 654183#64)
    (ht1823 : t1823 = t1809 + t1822) (ht1834 : t1834 = t1805 * 18446744073708553811#64)
    (ht1835 : t1835 = t1823 + t1834) (ht1852 : t1852 = t1798 * 136657#64)
    (ht1853 : t1853 = t1835 + t1852) (ht1866 : t1866 = t1800 * 18446744073708867715#64)
    (ht1867 : t1867 = t1853 + t1866) (ht1893 : t1893 = t1867 + 1048576#64)
    (ht1894 : t1894 = t1893.sshiftRight 21) (et1664 : t1664 = s18) (et1620 : t1620 = s6)
    (et1741 : t1741 = carry6) (et1780 : t1780 = carry16) (et1660 : t1660 = s17)
    (et1802 : t1802 = carry15) (et1683 : t1683 = s23) (et1656 : t1656 = s16) (et1653 : t1653 = s15)
    (et1680 : t1680 = s22) (et1775 : t1775 = carry14) (et1797 : t1797 = carry13)
    (et1676 : t1676 = s21) (et1650 : t1650 = s14) (et1672 : t1672 = s20) (et1646 : t1646 = s13)
    (et1766 : t1766 = carry12) (hs13_1 : s13_1 = s13 + s23 * 654183#64)
    (hs14_1 : s14_1 = s14 - s23 * 997805#64) (hs15_1 : s15_1 = s15 + s23 * 136657#64)
    (hs16_1 : s16_1 = s16 - s23 * 683901#64) (hs13_2 : s13_2 = s13_1 - s22 * 997805#64)
    (hs14_2 : s14_2 = s14_1 + s22 * 136657#64) (hs15_2 : s15_2 = s15_1 - s22 * 683901#64)
    (hs13_3 : s13_3 = s13_2 + s21 * 136657#64) (hs14_3 : s14_3 = s14_2 - s21 * 683901#64)
    (hs13_4 : s13_4 = s13_3 - s20 * 683901#64) (hs6_1 : s6_1 = s6 + s18 * 666643#64)
    (hs6_2 : s6_2 = s6_1 - carry6 <<< 21) (hs13_5 : s13_5 = s13_4 + carry12)
    (hs15_3 : s15_3 = s15_2 + carry14) (hs14_4 : s14_4 = s14_3 - carry14 <<< 21)
    (hs17_1 : s17_1 = s17 + carry16) (hs16_2 : s16_2 = s16_1 - carry16 <<< 21)
    (hs14_5 : s14_5 = s14_4 + carry13) (hs13_6 : s13_6 = s13_5 - carry13 <<< 21)
    (hs16_3 : s16_3 = s16_2 + carry15) (hs15_4 : s15_4 = s15_3 - carry15 <<< 21)
    (hs6_3 : s6_3 = s6_2 + s17_1 * 470296#64) (hs6_4 : s6_4 = s6_3 + s16_3 * 654183#64)
    (hs6_5 : s6_5 = s6_4 - s15_4 * 997805#64) (hs6_6 : s6_6 = s6_5 + s14_5 * 136657#64)
    (hs6_7 : s6_7 = s6_6 - s13_6 * 683901#64)
    (hcarry6_1 : carry6_1 = (s6_7 + 1048576#64).sshiftRight 21) : t1894 = carry6_1 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `carry8_1` as the C computes it is the compiled `%1899`. -/
theorem sc25519_reduce.bridge_carry8_1
    (t1688 t1689 t1690 t1691 t1697 t1698 t1708 t1715 t1728 t1729 t1730 t1731 t1754 t1776 t1781 t1782
      t1783 t1803 t1804 t1805 t1812 t1826 t1838 t1839 t1840 t1841 t1842 t1843 t1898 t1899 t1785
      t1664 t1626 t1668 t1672 t1748 t1780 t1660 t1802 t1683 t1656 t1653 t1680 t1775 s15_1 s16_1
      s15_2 s8_1 s8_2 s8_3 s8_4 s15_3 s17_1 s16_2 s8_5 s16_3 s15_4 s8_6 s8_7 s8_8 carry8_1 s8 s15
      s16 s17 s18 s19 s20 s22 s23 carry8 carry14 carry16 carry7 carry15 : BitVec 64)
    (ht1688 : t1688 = t1683 * 136657#64) (ht1689 : t1689 = t1688 + t1653)
    (ht1690 : t1690 = t1683 * 18446744073708867715#64) (ht1691 : t1691 = t1690 + t1656)
    (ht1697 : t1697 = t1680 * 18446744073708867715#64) (ht1698 : t1698 = t1689 + t1697)
    (ht1708 : t1708 = t1672 * 666643#64) (ht1715 : t1715 = t1668 * 470296#64)
    (ht1728 : t1728 = t1664 * 654183#64) (ht1729 : t1729 = t1728 + t1626)
    (ht1730 : t1730 = t1729 + t1715) (ht1731 : t1731 = t1730 + t1708)
    (ht1754 : t1754 = t1748 <<< 21) (ht1776 : t1776 = t1698 + t1775)
    (ht1781 : t1781 = t1780 + t1660) (ht1782 : t1782 = t1780 <<< 21)
    (ht1783 : t1783 = t1691 - t1782) (ht1803 : t1803 = t1802 + t1783)
    (ht1804 : t1804 = t1802 <<< 21) (ht1805 : t1805 = t1776 - t1804)
    (ht1812 : t1812 = t1781 * 18446744073708553811#64) (ht1826 : t1826 = t1803 * 136657#64)
    (ht1838 : t1838 = t1805 * 18446744073708867715#64) (ht1839 : t1839 = t1785 + t1731)
    (ht1840 : t1840 = t1839 - t1754) (ht1841 : t1841 = t1840 + t1812)
    (ht1842 : t1842 = t1841 + t1826) (ht1843 : t1843 = t1842 + t1838)
    (ht1898 : t1898 = t1843 + 1048576#64) (ht1899 : t1899 = t1898.sshiftRight 21)
    (et1785 : t1785 = carry7) (et1664 : t1664 = s18) (et1626 : t1626 = s8) (et1668 : t1668 = s19)
    (et1672 : t1672 = s20) (et1748 : t1748 = carry8) (et1780 : t1780 = carry16)
    (et1660 : t1660 = s17) (et1802 : t1802 = carry15) (et1683 : t1683 = s23) (et1656 : t1656 = s16)
    (et1653 : t1653 = s15) (et1680 : t1680 = s22) (et1775 : t1775 = carry14)
    (hs15_1 : s15_1 = s15 + s23 * 136657#64) (hs16_1 : s16_1 = s16 - s23 * 683901#64)
    (hs15_2 : s15_2 = s15_1 - s22 * 683901#64) (hs8_1 : s8_1 = s8 + s20 * 666643#64)
    (hs8_2 : s8_2 = s8_1 + s19 * 470296#64) (hs8_3 : s8_3 = s8_2 + s18 * 654183#64)
    (hs8_4 : s8_4 = s8_3 - carry8 <<< 21) (hs15_3 : s15_3 = s15_2 + carry14)
    (hs17_1 : s17_1 = s17 + carry16) (hs16_2 : s16_2 = s16_1 - carry16 <<< 21)
    (hs8_5 : s8_5 = s8_4 + carry7) (hs16_3 : s16_3 = s16_2 + carry15)
    (hs15_4 : s15_4 = s15_3 - carry15 <<< 21) (hs8_6 : s8_6 = s8_5 - s17_1 * 997805#64)
    (hs8_7 : s8_7 = s8_6 + s16_3 * 136657#64) (hs8_8 : s8_8 = s8_7 - s15_4 * 683901#64)
    (hcarry8_1 : carry8_1 = (s8_8 + 1048576#64).sshiftRight 21) : t1899 = carry8_1 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `carry10_1` as the C computes it is the compiled `%1907`. -/
theorem sc25519_reduce.bridge_carry10_1
    (t1692 t1700 t1710 t1717 t1733 t1734 t1735 t1736 t1737 t1738 t1764 t1781 t1814 t1815 t1816 t1817
      t1906 t1907 t1780 t1660 t1664 t1634 t1668 t1672 t1676 t1680 t1789 t1756 s10_1 s10_2 s10_3
      s10_4 s10_5 s10_6 s17_1 s10_7 s10_8 carry10_1 s10 s17 s18 s19 s20 s21 s22 carry10 carry16
      carry9 : BitVec 64)
    (ht1692 : t1692 = t1680 * 666643#64) (ht1700 : t1700 = t1676 * 470296#64)
    (ht1710 : t1710 = t1672 * 654183#64) (ht1717 : t1717 = t1668 * 18446744073708553811#64)
    (ht1733 : t1733 = t1664 * 136657#64) (ht1734 : t1734 = t1733 + t1634)
    (ht1735 : t1735 = t1734 + t1717) (ht1736 : t1736 = t1735 + t1710)
    (ht1737 : t1737 = t1736 + t1700) (ht1738 : t1738 = t1737 + t1692)
    (ht1764 : t1764 = t1756 <<< 21) (ht1781 : t1781 = t1780 + t1660)
    (ht1814 : t1814 = t1781 * 18446744073708867715#64) (ht1815 : t1815 = t1814 + t1738)
    (ht1816 : t1816 = t1815 + t1789) (ht1817 : t1817 = t1816 - t1764)
    (ht1906 : t1906 = t1817 + 1048576#64) (ht1907 : t1907 = t1906.sshiftRight 21)
    (et1780 : t1780 = carry16) (et1660 : t1660 = s17) (et1664 : t1664 = s18) (et1634 : t1634 = s10)
    (et1668 : t1668 = s19) (et1672 : t1672 = s20) (et1676 : t1676 = s21) (et1680 : t1680 = s22)
    (et1789 : t1789 = carry9) (et1756 : t1756 = carry10) (hs10_1 : s10_1 = s10 + s22 * 666643#64)
    (hs10_2 : s10_2 = s10_1 + s21 * 470296#64) (hs10_3 : s10_3 = s10_2 + s20 * 654183#64)
    (hs10_4 : s10_4 = s10_3 - s19 * 997805#64) (hs10_5 : s10_5 = s10_4 + s18 * 136657#64)
    (hs10_6 : s10_6 = s10_5 - carry10 <<< 21) (hs17_1 : s17_1 = s17 + carry16)
    (hs10_7 : s10_7 = s10_6 + carry9) (hs10_8 : s10_8 = s10_7 - s17_1 * 683901#64)
    (hcarry10_1 : carry10_1 = (s10_8 + 1048576#64).sshiftRight 21) : t1907 = carry10_1 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `carry1` as the C computes it is the compiled `%1912`. -/
theorem sc25519_reduce.bridge_carry1
    (t1685 t1686 t1694 t1695 t1702 t1703 t1712 t1713 t1719 t1720 t1721 t1722 t1723 t1724 t1767 t1768
      t1769 t1770 t1771 t1772 t1773 t1793 t1799 t1800 t1856 t1857 t1870 t1871 t1882 t1911 t1912
      t1672 t1646 t1676 t1683 t1680 t1766 t1797 t1600 t1792 t1668 t1642 t1881 s12_1 s13_1 s12_2
      s13_2 s12_3 s13_3 s12_4 s13_4 s12_5 s13_5 s12_6 s12_7 s13_6 s1_1 s1_2 s1_3 carry1 s1 s12 s13
      s19 s20 s21 s22 s23 carry12 carry11 carry13 carry0 : BitVec 64)
    (ht1685 : t1685 = t1683 * 470296#64) (ht1686 : t1686 = t1683 * 654183#64)
    (ht1694 : t1694 = t1680 * 654183#64) (ht1695 : t1695 = t1680 * 18446744073708553811#64)
    (ht1702 : t1702 = t1676 * 18446744073708553811#64) (ht1703 : t1703 = t1676 * 136657#64)
    (ht1712 : t1712 = t1672 * 136657#64) (ht1713 : t1713 = t1672 * 18446744073708867715#64)
    (ht1719 : t1719 = t1668 * 18446744073708867715#64) (ht1720 : t1720 = t1719 + t1642)
    (ht1721 : t1721 = t1720 + t1712) (ht1722 : t1722 = t1721 + t1702)
    (ht1723 : t1723 = t1722 + t1685) (ht1724 : t1724 = t1723 + t1694)
    (ht1767 : t1767 = t1713 + t1646) (ht1768 : t1768 = t1767 + t1703)
    (ht1769 : t1769 = t1768 + t1686) (ht1770 : t1770 = t1769 + t1695)
    (ht1771 : t1771 = t1770 + t1766) (ht1772 : t1772 = t1766 <<< 21)
    (ht1773 : t1773 = t1724 - t1772) (ht1793 : t1793 = t1792 + t1773)
    (ht1799 : t1799 = t1797 <<< 21) (ht1800 : t1800 = t1771 - t1799)
    (ht1856 : t1856 = t1800 * 666643#64) (ht1857 : t1857 = t1856 + t1600)
    (ht1870 : t1870 = t1793 * 470296#64) (ht1871 : t1871 = t1857 + t1870)
    (ht1882 : t1882 = t1871 + t1881) (ht1911 : t1911 = t1882 + 1048576#64)
    (ht1912 : t1912 = t1911.sshiftRight 21) (et1672 : t1672 = s20) (et1646 : t1646 = s13)
    (et1676 : t1676 = s21) (et1683 : t1683 = s23) (et1680 : t1680 = s22) (et1766 : t1766 = carry12)
    (et1797 : t1797 = carry13) (et1600 : t1600 = s1) (et1792 : t1792 = carry11)
    (et1668 : t1668 = s19) (et1642 : t1642 = s12) (et1881 : t1881 = carry0)
    (hs12_1 : s12_1 = s12 + s23 * 470296#64) (hs13_1 : s13_1 = s13 + s23 * 654183#64)
    (hs12_2 : s12_2 = s12_1 + s22 * 654183#64) (hs13_2 : s13_2 = s13_1 - s22 * 997805#64)
    (hs12_3 : s12_3 = s12_2 - s21 * 997805#64) (hs13_3 : s13_3 = s13_2 + s21 * 136657#64)
    (hs12_4 : s12_4 = s12_3 + s20 * 136657#64) (hs13_4 : s13_4 = s13_3 - s20 * 683901#64)
    (hs12_5 : s12_5 = s12_4 - s19 * 683901#64) (hs13_5 : s13_5 = s13_4 + carry12)
    (hs12_6 : s12_6 = s12_5 - carry12 <<< 21) (hs12_7 : s12_7 = s12_6 + carry11)
    (hs13_6 : s13_6 = s13_5 - carry13 <<< 21) (hs1_1 : s1_1 = s1 + s13_6 * 666643#64)
    (hs1_2 : s1_2 = s1_1 + s12_7 * 470296#64) (hs1_3 : s1_3 = s1_2 + carry0)
    (hcarry1 : carry1 = (s1_3 + 1048576#64).sshiftRight 21) : t1912 = carry1 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `carry3` as the C computes it is the compiled `%1915`. -/
theorem sc25519_reduce.bridge_carry3
    (t1685 t1686 t1687 t1688 t1689 t1694 t1695 t1696 t1697 t1698 t1702 t1703 t1704 t1705 t1706 t1707
      t1712 t1713 t1719 t1720 t1721 t1722 t1723 t1724 t1767 t1768 t1769 t1770 t1771 t1772 t1773
      t1776 t1777 t1778 t1793 t1798 t1799 t1800 t1804 t1805 t1828 t1829 t1846 t1847 t1860 t1861
      t1874 t1875 t1887 t1914 t1915 t1683 t1653 t1680 t1775 t1802 t1608 t1797 t1676 t1650 t1672
      t1646 t1766 t1792 t1668 t1642 t1886 s12_1 s13_1 s14_1 s15_1 s12_2 s13_2 s14_2 s15_2 s12_3
      s13_3 s14_3 s12_4 s13_4 s12_5 s13_5 s12_6 s15_3 s14_4 s12_7 s14_5 s13_6 s15_4 s3_1 s3_2 s3_3
      s3_4 s3_5 carry3 s3 s12 s13 s14 s15 s19 s20 s21 s22 s23 carry12 carry14 carry11 carry13
      carry15 carry2 : BitVec 64)
    (ht1685 : t1685 = t1683 * 470296#64) (ht1686 : t1686 = t1683 * 654183#64)
    (ht1687 : t1687 = t1683 * 18446744073708553811#64) (ht1688 : t1688 = t1683 * 136657#64)
    (ht1689 : t1689 = t1688 + t1653) (ht1694 : t1694 = t1680 * 654183#64)
    (ht1695 : t1695 = t1680 * 18446744073708553811#64) (ht1696 : t1696 = t1680 * 136657#64)
    (ht1697 : t1697 = t1680 * 18446744073708867715#64) (ht1698 : t1698 = t1689 + t1697)
    (ht1702 : t1702 = t1676 * 18446744073708553811#64) (ht1703 : t1703 = t1676 * 136657#64)
    (ht1704 : t1704 = t1676 * 18446744073708867715#64) (ht1705 : t1705 = t1704 + t1650)
    (ht1706 : t1706 = t1705 + t1687) (ht1707 : t1707 = t1706 + t1696)
    (ht1712 : t1712 = t1672 * 136657#64) (ht1713 : t1713 = t1672 * 18446744073708867715#64)
    (ht1719 : t1719 = t1668 * 18446744073708867715#64) (ht1720 : t1720 = t1719 + t1642)
    (ht1721 : t1721 = t1720 + t1712) (ht1722 : t1722 = t1721 + t1702)
    (ht1723 : t1723 = t1722 + t1685) (ht1724 : t1724 = t1723 + t1694)
    (ht1767 : t1767 = t1713 + t1646) (ht1768 : t1768 = t1767 + t1703)
    (ht1769 : t1769 = t1768 + t1686) (ht1770 : t1770 = t1769 + t1695)
    (ht1771 : t1771 = t1770 + t1766) (ht1772 : t1772 = t1766 <<< 21)
    (ht1773 : t1773 = t1724 - t1772) (ht1776 : t1776 = t1698 + t1775)
    (ht1777 : t1777 = t1775 <<< 21) (ht1778 : t1778 = t1707 - t1777)
    (ht1793 : t1793 = t1792 + t1773) (ht1798 : t1798 = t1797 + t1778)
    (ht1799 : t1799 = t1797 <<< 21) (ht1800 : t1800 = t1771 - t1799) (ht1804 : t1804 = t1802 <<< 21)
    (ht1805 : t1805 = t1776 - t1804) (ht1828 : t1828 = t1805 * 666643#64)
    (ht1829 : t1829 = t1828 + t1608) (ht1846 : t1846 = t1798 * 470296#64)
    (ht1847 : t1847 = t1829 + t1846) (ht1860 : t1860 = t1800 * 654183#64)
    (ht1861 : t1861 = t1847 + t1860) (ht1874 : t1874 = t1793 * 18446744073708553811#64)
    (ht1875 : t1875 = t1861 + t1874) (ht1887 : t1887 = t1875 + t1886)
    (ht1914 : t1914 = t1887 + 1048576#64) (ht1915 : t1915 = t1914.sshiftRight 21)
    (et1683 : t1683 = s23) (et1653 : t1653 = s15) (et1680 : t1680 = s22) (et1775 : t1775 = carry14)
    (et1802 : t1802 = carry15) (et1608 : t1608 = s3) (et1797 : t1797 = carry13)
    (et1676 : t1676 = s21) (et1650 : t1650 = s14) (et1672 : t1672 = s20) (et1646 : t1646 = s13)
    (et1766 : t1766 = carry12) (et1792 : t1792 = carry11) (et1668 : t1668 = s19)
    (et1642 : t1642 = s12) (et1886 : t1886 = carry2) (hs12_1 : s12_1 = s12 + s23 * 470296#64)
    (hs13_1 : s13_1 = s13 + s23 * 654183#64) (hs14_1 : s14_1 = s14 - s23 * 997805#64)
    (hs15_1 : s15_1 = s15 + s23 * 136657#64) (hs12_2 : s12_2 = s12_1 + s22 * 654183#64)
    (hs13_2 : s13_2 = s13_1 - s22 * 997805#64) (hs14_2 : s14_2 = s14_1 + s22 * 136657#64)
    (hs15_2 : s15_2 = s15_1 - s22 * 683901#64) (hs12_3 : s12_3 = s12_2 - s21 * 997805#64)
    (hs13_3 : s13_3 = s13_2 + s21 * 136657#64) (hs14_3 : s14_3 = s14_2 - s21 * 683901#64)
    (hs12_4 : s12_4 = s12_3 + s20 * 136657#64) (hs13_4 : s13_4 = s13_3 - s20 * 683901#64)
    (hs12_5 : s12_5 = s12_4 - s19 * 683901#64) (hs13_5 : s13_5 = s13_4 + carry12)
    (hs12_6 : s12_6 = s12_5 - carry12 <<< 21) (hs15_3 : s15_3 = s15_2 + carry14)
    (hs14_4 : s14_4 = s14_3 - carry14 <<< 21) (hs12_7 : s12_7 = s12_6 + carry11)
    (hs14_5 : s14_5 = s14_4 + carry13) (hs13_6 : s13_6 = s13_5 - carry13 <<< 21)
    (hs15_4 : s15_4 = s15_3 - carry15 <<< 21) (hs3_1 : s3_1 = s3 + s15_4 * 666643#64)
    (hs3_2 : s3_2 = s3_1 + s14_5 * 470296#64) (hs3_3 : s3_3 = s3_2 + s13_6 * 654183#64)
    (hs3_4 : s3_4 = s3_3 - s12_7 * 997805#64) (hs3_5 : s3_5 = s3_4 + carry2)
    (hcarry3 : carry3 = (s3_5 + 1048576#64).sshiftRight 21) : t1915 = carry3 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `carry5` as the C computes it is the compiled `%1918`. -/
theorem sc25519_reduce.bridge_carry5
    (t1685 t1686 t1687 t1688 t1689 t1690 t1691 t1694 t1695 t1696 t1697 t1698 t1702 t1703 t1704 t1705
      t1706 t1707 t1712 t1713 t1719 t1720 t1721 t1722 t1723 t1724 t1767 t1768 t1769 t1770 t1771
      t1772 t1773 t1776 t1777 t1778 t1781 t1782 t1783 t1793 t1798 t1799 t1800 t1803 t1804 t1805
      t1806 t1807 t1820 t1821 t1832 t1833 t1850 t1851 t1864 t1865 t1878 t1879 t1891 t1917 t1918
      t1780 t1660 t1616 t1802 t1683 t1656 t1653 t1680 t1775 t1797 t1676 t1650 t1672 t1646 t1766
      t1792 t1668 t1642 t1890 s12_1 s13_1 s14_1 s15_1 s16_1 s12_2 s13_2 s14_2 s15_2 s12_3 s13_3
      s14_3 s12_4 s13_4 s12_5 s13_5 s12_6 s15_3 s14_4 s17_1 s16_2 s12_7 s14_5 s13_6 s16_3 s15_4 s5_1
      s5_2 s5_3 s5_4 s5_5 s5_6 s5_7 carry5 s5 s12 s13 s14 s15 s16 s17 s19 s20 s21 s22 s23 carry12
      carry14 carry16 carry11 carry13 carry15 carry4 : BitVec 64)
    (ht1685 : t1685 = t1683 * 470296#64) (ht1686 : t1686 = t1683 * 654183#64)
    (ht1687 : t1687 = t1683 * 18446744073708553811#64) (ht1688 : t1688 = t1683 * 136657#64)
    (ht1689 : t1689 = t1688 + t1653) (ht1690 : t1690 = t1683 * 18446744073708867715#64)
    (ht1691 : t1691 = t1690 + t1656) (ht1694 : t1694 = t1680 * 654183#64)
    (ht1695 : t1695 = t1680 * 18446744073708553811#64) (ht1696 : t1696 = t1680 * 136657#64)
    (ht1697 : t1697 = t1680 * 18446744073708867715#64) (ht1698 : t1698 = t1689 + t1697)
    (ht1702 : t1702 = t1676 * 18446744073708553811#64) (ht1703 : t1703 = t1676 * 136657#64)
    (ht1704 : t1704 = t1676 * 18446744073708867715#64) (ht1705 : t1705 = t1704 + t1650)
    (ht1706 : t1706 = t1705 + t1687) (ht1707 : t1707 = t1706 + t1696)
    (ht1712 : t1712 = t1672 * 136657#64) (ht1713 : t1713 = t1672 * 18446744073708867715#64)
    (ht1719 : t1719 = t1668 * 18446744073708867715#64) (ht1720 : t1720 = t1719 + t1642)
    (ht1721 : t1721 = t1720 + t1712) (ht1722 : t1722 = t1721 + t1702)
    (ht1723 : t1723 = t1722 + t1685) (ht1724 : t1724 = t1723 + t1694)
    (ht1767 : t1767 = t1713 + t1646) (ht1768 : t1768 = t1767 + t1703)
    (ht1769 : t1769 = t1768 + t1686) (ht1770 : t1770 = t1769 + t1695)
    (ht1771 : t1771 = t1770 + t1766) (ht1772 : t1772 = t1766 <<< 21)
    (ht1773 : t1773 = t1724 - t1772) (ht1776 : t1776 = t1698 + t1775)
    (ht1777 : t1777 = t1775 <<< 21) (ht1778 : t1778 = t1707 - t1777)
    (ht1781 : t1781 = t1780 + t1660) (ht1782 : t1782 = t1780 <<< 21)
    (ht1783 : t1783 = t1691 - t1782) (ht1793 : t1793 = t1792 + t1773)
    (ht1798 : t1798 = t1797 + t1778) (ht1799 : t1799 = t1797 <<< 21)
    (ht1800 : t1800 = t1771 - t1799) (ht1803 : t1803 = t1802 + t1783)
    (ht1804 : t1804 = t1802 <<< 21) (ht1805 : t1805 = t1776 - t1804)
    (ht1806 : t1806 = t1781 * 666643#64) (ht1807 : t1807 = t1806 + t1616)
    (ht1820 : t1820 = t1803 * 470296#64) (ht1821 : t1821 = t1807 + t1820)
    (ht1832 : t1832 = t1805 * 654183#64) (ht1833 : t1833 = t1821 + t1832)
    (ht1850 : t1850 = t1798 * 18446744073708553811#64) (ht1851 : t1851 = t1833 + t1850)
    (ht1864 : t1864 = t1800 * 136657#64) (ht1865 : t1865 = t1851 + t1864)
    (ht1878 : t1878 = t1793 * 18446744073708867715#64) (ht1879 : t1879 = t1865 + t1878)
    (ht1891 : t1891 = t1879 + t1890) (ht1917 : t1917 = t1891 + 1048576#64)
    (ht1918 : t1918 = t1917.sshiftRight 21) (et1780 : t1780 = carry16) (et1660 : t1660 = s17)
    (et1616 : t1616 = s5) (et1802 : t1802 = carry15) (et1683 : t1683 = s23) (et1656 : t1656 = s16)
    (et1653 : t1653 = s15) (et1680 : t1680 = s22) (et1775 : t1775 = carry14)
    (et1797 : t1797 = carry13) (et1676 : t1676 = s21) (et1650 : t1650 = s14) (et1672 : t1672 = s20)
    (et1646 : t1646 = s13) (et1766 : t1766 = carry12) (et1792 : t1792 = carry11)
    (et1668 : t1668 = s19) (et1642 : t1642 = s12) (et1890 : t1890 = carry4)
    (hs12_1 : s12_1 = s12 + s23 * 470296#64) (hs13_1 : s13_1 = s13 + s23 * 654183#64)
    (hs14_1 : s14_1 = s14 - s23 * 997805#64) (hs15_1 : s15_1 = s15 + s23 * 136657#64)
    (hs16_1 : s16_1 = s16 - s23 * 683901#64) (hs12_2 : s12_2 = s12_1 + s22 * 654183#64)
    (hs13_2 : s13_2 = s13_1 - s22 * 997805#64) (hs14_2 : s14_2 = s14_1 + s22 * 136657#64)
    (hs15_2 : s15_2 = s15_1 - s22 * 683901#64) (hs12_3 : s12_3 = s12_2 - s21 * 997805#64)
    (hs13_3 : s13_3 = s13_2 + s21 * 136657#64) (hs14_3 : s14_3 = s14_2 - s21 * 683901#64)
    (hs12_4 : s12_4 = s12_3 + s20 * 136657#64) (hs13_4 : s13_4 = s13_3 - s20 * 683901#64)
    (hs12_5 : s12_5 = s12_4 - s19 * 683901#64) (hs13_5 : s13_5 = s13_4 + carry12)
    (hs12_6 : s12_6 = s12_5 - carry12 <<< 21) (hs15_3 : s15_3 = s15_2 + carry14)
    (hs14_4 : s14_4 = s14_3 - carry14 <<< 21) (hs17_1 : s17_1 = s17 + carry16)
    (hs16_2 : s16_2 = s16_1 - carry16 <<< 21) (hs12_7 : s12_7 = s12_6 + carry11)
    (hs14_5 : s14_5 = s14_4 + carry13) (hs13_6 : s13_6 = s13_5 - carry13 <<< 21)
    (hs16_3 : s16_3 = s16_2 + carry15) (hs15_4 : s15_4 = s15_3 - carry15 <<< 21)
    (hs5_1 : s5_1 = s5 + s17_1 * 666643#64) (hs5_2 : s5_2 = s5_1 + s16_3 * 470296#64)
    (hs5_3 : s5_3 = s5_2 + s15_4 * 654183#64) (hs5_4 : s5_4 = s5_3 - s14_5 * 997805#64)
    (hs5_5 : s5_5 = s5_4 + s13_6 * 136657#64) (hs5_6 : s5_6 = s5_5 - s12_7 * 683901#64)
    (hs5_7 : s5_7 = s5_6 + carry4) (hcarry5 : carry5 = (s5_7 + 1048576#64).sshiftRight 21) :
    t1918 = carry5 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `carry7_1` as the C computes it is the compiled `%1922`. -/
theorem sc25519_reduce.bridge_carry7_1
    (t1687 t1688 t1689 t1690 t1691 t1696 t1697 t1698 t1704 t1705 t1706 t1707 t1714 t1727 t1742 t1743
      t1744 t1776 t1777 t1778 t1781 t1782 t1783 t1786 t1787 t1798 t1803 t1804 t1805 t1810 t1811
      t1824 t1825 t1836 t1837 t1854 t1855 t1895 t1921 t1922 t1664 t1623 t1668 t1741 t1785 t1780
      t1660 t1802 t1683 t1656 t1653 t1680 t1775 t1797 t1676 t1650 t1894 s14_1 s15_1 s16_1 s14_2
      s15_2 s14_3 s7_1 s7_2 s7_3 s15_3 s14_4 s17_1 s16_2 s7_4 s14_5 s16_3 s15_4 s7_5 s7_6 s7_7 s7_8
      s7_9 carry7_1 s7 s14 s15 s16 s17 s18 s19 s21 s22 s23 carry6 carry14 carry16 carry7 carry13
      carry15 carry6_1 : BitVec 64)
    (ht1687 : t1687 = t1683 * 18446744073708553811#64) (ht1688 : t1688 = t1683 * 136657#64)
    (ht1689 : t1689 = t1688 + t1653) (ht1690 : t1690 = t1683 * 18446744073708867715#64)
    (ht1691 : t1691 = t1690 + t1656) (ht1696 : t1696 = t1680 * 136657#64)
    (ht1697 : t1697 = t1680 * 18446744073708867715#64) (ht1698 : t1698 = t1689 + t1697)
    (ht1704 : t1704 = t1676 * 18446744073708867715#64) (ht1705 : t1705 = t1704 + t1650)
    (ht1706 : t1706 = t1705 + t1687) (ht1707 : t1707 = t1706 + t1696)
    (ht1714 : t1714 = t1668 * 666643#64) (ht1727 : t1727 = t1664 * 470296#64)
    (ht1742 : t1742 = t1727 + t1623) (ht1743 : t1743 = t1742 + t1714)
    (ht1744 : t1744 = t1743 + t1741) (ht1776 : t1776 = t1698 + t1775)
    (ht1777 : t1777 = t1775 <<< 21) (ht1778 : t1778 = t1707 - t1777)
    (ht1781 : t1781 = t1780 + t1660) (ht1782 : t1782 = t1780 <<< 21)
    (ht1783 : t1783 = t1691 - t1782) (ht1786 : t1786 = t1785 <<< 21)
    (ht1787 : t1787 = t1744 - t1786) (ht1798 : t1798 = t1797 + t1778)
    (ht1803 : t1803 = t1802 + t1783) (ht1804 : t1804 = t1802 <<< 21)
    (ht1805 : t1805 = t1776 - t1804) (ht1810 : t1810 = t1781 * 654183#64)
    (ht1811 : t1811 = t1787 + t1810) (ht1824 : t1824 = t1803 * 18446744073708553811#64)
    (ht1825 : t1825 = t1811 + t1824) (ht1836 : t1836 = t1805 * 136657#64)
    (ht1837 : t1837 = t1825 + t1836) (ht1854 : t1854 = t1798 * 18446744073708867715#64)
    (ht1855 : t1855 = t1837 + t1854) (ht1895 : t1895 = t1855 + t1894)
    (ht1921 : t1921 = t1895 + 1048576#64) (ht1922 : t1922 = t1921.sshiftRight 21)
    (et1664 : t1664 = s18) (et1623 : t1623 = s7) (et1668 : t1668 = s19) (et1741 : t1741 = carry6)
    (et1785 : t1785 = carry7) (et1780 : t1780 = carry16) (et1660 : t1660 = s17)
    (et1802 : t1802 = carry15) (et1683 : t1683 = s23) (et1656 : t1656 = s16) (et1653 : t1653 = s15)
    (et1680 : t1680 = s22) (et1775 : t1775 = carry14) (et1797 : t1797 = carry13)
    (et1676 : t1676 = s21) (et1650 : t1650 = s14) (et1894 : t1894 = carry6_1)
    (hs14_1 : s14_1 = s14 - s23 * 997805#64) (hs15_1 : s15_1 = s15 + s23 * 136657#64)
    (hs16_1 : s16_1 = s16 - s23 * 683901#64) (hs14_2 : s14_2 = s14_1 + s22 * 136657#64)
    (hs15_2 : s15_2 = s15_1 - s22 * 683901#64) (hs14_3 : s14_3 = s14_2 - s21 * 683901#64)
    (hs7_1 : s7_1 = s7 + s19 * 666643#64) (hs7_2 : s7_2 = s7_1 + s18 * 470296#64)
    (hs7_3 : s7_3 = s7_2 + carry6) (hs15_3 : s15_3 = s15_2 + carry14)
    (hs14_4 : s14_4 = s14_3 - carry14 <<< 21) (hs17_1 : s17_1 = s17 + carry16)
    (hs16_2 : s16_2 = s16_1 - carry16 <<< 21) (hs7_4 : s7_4 = s7_3 - carry7 <<< 21)
    (hs14_5 : s14_5 = s14_4 + carry13) (hs16_3 : s16_3 = s16_2 + carry15)
    (hs15_4 : s15_4 = s15_3 - carry15 <<< 21) (hs7_5 : s7_5 = s7_4 + s17_1 * 654183#64)
    (hs7_6 : s7_6 = s7_5 - s16_3 * 997805#64) (hs7_7 : s7_7 = s7_6 + s15_4 * 136657#64)
    (hs7_8 : s7_8 = s7_7 - s14_5 * 683901#64) (hs7_9 : s7_9 = s7_8 + carry6_1)
    (hcarry7_1 : carry7_1 = (s7_9 + 1048576#64).sshiftRight 21) : t1922 = carry7_1 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `carry9_1` as the C computes it is the compiled `%1927`. -/
theorem sc25519_reduce.bridge_carry9_1
    (t1690 t1691 t1699 t1709 t1716 t1732 t1749 t1750 t1751 t1752 t1753 t1781 t1782 t1783 t1790 t1803
      t1813 t1827 t1900 t1901 t1902 t1903 t1926 t1927 t1780 t1660 t1664 t1630 t1668 t1672 t1676
      t1748 t1789 t1802 t1683 t1656 t1899 s16_1 s9_1 s9_2 s9_3 s9_4 s9_5 s17_1 s16_2 s9_6 s16_3 s9_7
      s9_8 s9_9 carry9_1 s9 s16 s17 s18 s19 s20 s21 s23 carry8 carry16 carry9 carry15 carry8_1 :
      BitVec 64)
    (ht1690 : t1690 = t1683 * 18446744073708867715#64) (ht1691 : t1691 = t1690 + t1656)
    (ht1699 : t1699 = t1676 * 666643#64) (ht1709 : t1709 = t1672 * 470296#64)
    (ht1716 : t1716 = t1668 * 654183#64) (ht1732 : t1732 = t1664 * 18446744073708553811#64)
    (ht1749 : t1749 = t1732 + t1630) (ht1750 : t1750 = t1749 + t1716)
    (ht1751 : t1751 = t1750 + t1709) (ht1752 : t1752 = t1751 + t1699)
    (ht1753 : t1753 = t1752 + t1748) (ht1781 : t1781 = t1780 + t1660)
    (ht1782 : t1782 = t1780 <<< 21) (ht1783 : t1783 = t1691 - t1782) (ht1790 : t1790 = t1789 <<< 21)
    (ht1803 : t1803 = t1802 + t1783) (ht1813 : t1813 = t1781 * 136657#64)
    (ht1827 : t1827 = t1803 * 18446744073708867715#64) (ht1900 : t1900 = t1813 + t1753)
    (ht1901 : t1901 = t1900 - t1790) (ht1902 : t1902 = t1901 + t1827)
    (ht1903 : t1903 = t1902 + t1899) (ht1926 : t1926 = t1903 + 1048576#64)
    (ht1927 : t1927 = t1926.sshiftRight 21) (et1780 : t1780 = carry16) (et1660 : t1660 = s17)
    (et1664 : t1664 = s18) (et1630 : t1630 = s9) (et1668 : t1668 = s19) (et1672 : t1672 = s20)
    (et1676 : t1676 = s21) (et1748 : t1748 = carry8) (et1789 : t1789 = carry9)
    (et1802 : t1802 = carry15) (et1683 : t1683 = s23) (et1656 : t1656 = s16)
    (et1899 : t1899 = carry8_1) (hs16_1 : s16_1 = s16 - s23 * 683901#64)
    (hs9_1 : s9_1 = s9 + s21 * 666643#64) (hs9_2 : s9_2 = s9_1 + s20 * 470296#64)
    (hs9_3 : s9_3 = s9_2 + s19 * 654183#64) (hs9_4 : s9_4 = s9_3 - s18 * 997805#64)
    (hs9_5 : s9_5 = s9_4 + carry8) (hs17_1 : s17_1 = s17 + carry16)
    (hs16_2 : s16_2 = s16_1 - carry16 <<< 21) (hs9_6 : s9_6 = s9_5 - carry9 <<< 21)
    (hs16_3 : s16_3 = s16_2 + carry15) (hs9_7 : s9_7 = s9_6 + s17_1 * 136657#64)
    (hs9_8 : s9_8 = s9_7 - s16_3 * 683901#64) (hs9_9 : s9_9 = s9_8 + carry8_1)
    (hcarry9_1 : carry9_1 = (s9_9 + 1048576#64).sshiftRight 21) : t1927 = carry9_1 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `carry11_1` as the C computes it is the compiled `%1932`. -/
theorem sc25519_reduce.bridge_carry11_1
    (t1684 t1693 t1701 t1711 t1718 t1739 t1757 t1758 t1759 t1760 t1761 t1762 t1763 t1794 t1795 t1908
      t1931 t1932 t1907 t1664 t1638 t1668 t1672 t1676 t1683 t1680 t1756 t1792 s11_1 s11_2 s11_3
      s11_4 s11_5 s11_6 s11_7 s11_8 s11_9 carry11_1 s11 s18 s19 s20 s21 s22 s23 carry10 carry11
      carry10_1 : BitVec 64)
    (ht1684 : t1684 = t1683 * 666643#64) (ht1693 : t1693 = t1680 * 470296#64)
    (ht1701 : t1701 = t1676 * 654183#64) (ht1711 : t1711 = t1672 * 18446744073708553811#64)
    (ht1718 : t1718 = t1668 * 136657#64) (ht1739 : t1739 = t1664 * 18446744073708867715#64)
    (ht1757 : t1757 = t1739 + t1638) (ht1758 : t1758 = t1757 + t1718)
    (ht1759 : t1759 = t1758 + t1711) (ht1760 : t1760 = t1759 + t1701)
    (ht1761 : t1761 = t1760 + t1684) (ht1762 : t1762 = t1761 + t1693)
    (ht1763 : t1763 = t1762 + t1756) (ht1794 : t1794 = t1792 <<< 21)
    (ht1795 : t1795 = t1763 - t1794) (ht1908 : t1908 = t1907 + t1795)
    (ht1931 : t1931 = t1908 + 1048576#64) (ht1932 : t1932 = t1931.sshiftRight 21)
    (et1907 : t1907 = carry10_1) (et1664 : t1664 = s18) (et1638 : t1638 = s11)
    (et1668 : t1668 = s19) (et1672 : t1672 = s20) (et1676 : t1676 = s21) (et1683 : t1683 = s23)
    (et1680 : t1680 = s22) (et1756 : t1756 = carry10) (et1792 : t1792 = carry11)
    (hs11_1 : s11_1 = s11 + s23 * 666643#64) (hs11_2 : s11_2 = s11_1 + s22 * 470296#64)
    (hs11_3 : s11_3 = s11_2 + s21 * 654183#64) (hs11_4 : s11_4 = s11_3 - s20 * 997805#64)
    (hs11_5 : s11_5 = s11_4 + s19 * 136657#64) (hs11_6 : s11_6 = s11_5 - s18 * 683901#64)
    (hs11_7 : s11_7 = s11_6 + carry10) (hs11_8 : s11_8 = s11_7 - carry11 <<< 21)
    (hs11_9 : s11_9 = s11_8 + carry10_1)
    (hcarry11_1 : carry11_1 = (s11_9 + 1048576#64).sshiftRight 21) : t1932 = carry11_1 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `carry0_1` as the C computes it is the compiled `%1942`. -/
theorem sc25519_reduce.bridge_carry0_1
    (t1685 t1694 t1702 t1712 t1719 t1720 t1721 t1722 t1723 t1724 t1772 t1773 t1793 t1868 t1869 t1883
      t1884 t1935 t1936 t1942 t1792 t1668 t1642 t1672 t1676 t1683 t1680 t1766 t1596 t1881 t1932
      s12_1 s12_2 s12_3 s12_4 s12_5 s12_6 s12_7 s0_1 s12_8 s0_2 s12_9 s0_3 carry0_1 s0 s12 s19 s20
      s21 s22 s23 carry12 carry11 carry0 carry11_1 : BitVec 64)
    (ht1685 : t1685 = t1683 * 470296#64) (ht1694 : t1694 = t1680 * 654183#64)
    (ht1702 : t1702 = t1676 * 18446744073708553811#64) (ht1712 : t1712 = t1672 * 136657#64)
    (ht1719 : t1719 = t1668 * 18446744073708867715#64) (ht1720 : t1720 = t1719 + t1642)
    (ht1721 : t1721 = t1720 + t1712) (ht1722 : t1722 = t1721 + t1702)
    (ht1723 : t1723 = t1722 + t1685) (ht1724 : t1724 = t1723 + t1694)
    (ht1772 : t1772 = t1766 <<< 21) (ht1773 : t1773 = t1724 - t1772)
    (ht1793 : t1793 = t1792 + t1773) (ht1868 : t1868 = t1793 * 666643#64)
    (ht1869 : t1869 = t1868 + t1596) (ht1883 : t1883 = t1881 <<< 21)
    (ht1884 : t1884 = t1869 - t1883) (ht1935 : t1935 = t1932 * 666643#64)
    (ht1936 : t1936 = t1884 + t1935) (ht1942 : t1942 = t1936.sshiftRight 21)
    (et1792 : t1792 = carry11) (et1668 : t1668 = s19) (et1642 : t1642 = s12) (et1672 : t1672 = s20)
    (et1676 : t1676 = s21) (et1683 : t1683 = s23) (et1680 : t1680 = s22) (et1766 : t1766 = carry12)
    (et1596 : t1596 = s0) (et1881 : t1881 = carry0) (et1932 : t1932 = carry11_1)
    (hs12_1 : s12_1 = s12 + s23 * 470296#64) (hs12_2 : s12_2 = s12_1 + s22 * 654183#64)
    (hs12_3 : s12_3 = s12_2 - s21 * 997805#64) (hs12_4 : s12_4 = s12_3 + s20 * 136657#64)
    (hs12_5 : s12_5 = s12_4 - s19 * 683901#64) (hs12_6 : s12_6 = s12_5 - carry12 <<< 21)
    (hs12_7 : s12_7 = s12_6 + carry11) (hs0_1 : s0_1 = s0 + s12_7 * 666643#64)
    (hs12_8 : s12_8 = 0#64) (hs0_2 : s0_2 = s0_1 - carry0 <<< 21)
    (hs12_9 : s12_9 = s12_8 + carry11_1) (hs0_3 : s0_3 = s0_2 + s12_9 * 666643#64)
    (hcarry0_1 : carry0_1 = s0_3.sshiftRight 21) : t1942 = carry0_1 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `carry1_1` as the C computes it is the compiled `%1947`. -/
theorem sc25519_reduce.bridge_carry1_1
    (t1685 t1686 t1694 t1695 t1702 t1703 t1712 t1713 t1719 t1720 t1721 t1722 t1723 t1724 t1767 t1768
      t1769 t1770 t1771 t1772 t1773 t1793 t1799 t1800 t1856 t1857 t1870 t1871 t1882 t1913 t1937
      t1943 t1944 t1945 t1947 t1932 t1672 t1646 t1676 t1683 t1680 t1766 t1797 t1600 t1792 t1668
      t1642 t1881 t1912 t1942 s12_1 s13_1 s12_2 s13_2 s12_3 s13_3 s12_4 s13_4 s12_5 s13_5 s12_6
      s12_7 s13_6 s1_1 s1_2 s12_8 s1_3 s1_4 s12_9 s1_5 s1_6 carry1_1 s1 s12 s13 s19 s20 s21 s22 s23
      carry12 carry11 carry13 carry0 carry1 carry11_1 carry0_1 : BitVec 64)
    (ht1685 : t1685 = t1683 * 470296#64) (ht1686 : t1686 = t1683 * 654183#64)
    (ht1694 : t1694 = t1680 * 654183#64) (ht1695 : t1695 = t1680 * 18446744073708553811#64)
    (ht1702 : t1702 = t1676 * 18446744073708553811#64) (ht1703 : t1703 = t1676 * 136657#64)
    (ht1712 : t1712 = t1672 * 136657#64) (ht1713 : t1713 = t1672 * 18446744073708867715#64)
    (ht1719 : t1719 = t1668 * 18446744073708867715#64) (ht1720 : t1720 = t1719 + t1642)
    (ht1721 : t1721 = t1720 + t1712) (ht1722 : t1722 = t1721 + t1702)
    (ht1723 : t1723 = t1722 + t1685) (ht1724 : t1724 = t1723 + t1694)
    (ht1767 : t1767 = t1713 + t1646) (ht1768 : t1768 = t1767 + t1703)
    (ht1769 : t1769 = t1768 + t1686) (ht1770 : t1770 = t1769 + t1695)
    (ht1771 : t1771 = t1770 + t1766) (ht1772 : t1772 = t1766 <<< 21)
    (ht1773 : t1773 = t1724 - t1772) (ht1793 : t1793 = t1792 + t1773)
    (ht1799 : t1799 = t1797 <<< 21) (ht1800 : t1800 = t1771 - t1799)
    (ht1856 : t1856 = t1800 * 666643#64) (ht1857 : t1857 = t1856 + t1600)
    (ht1870 : t1870 = t1793 * 470296#64) (ht1871 : t1871 = t1857 + t1870)
    (ht1882 : t1882 = t1871 + t1881) (ht1913 : t1913 = t1912 <<< 21)
    (ht1937 : t1937 = t1932 * 470296#64) (ht1943 : t1943 = t1937 + t1882)
    (ht1944 : t1944 = t1943 - t1913) (ht1945 : t1945 = t1944 + t1942)
    (ht1947 : t1947 = t1945.sshiftRight 21) (et1932 : t1932 = carry11_1) (et1672 : t1672 = s20)
    (et1646 : t1646 = s13) (et1676 : t1676 = s21) (et1683 : t1683 = s23) (et1680 : t1680 = s22)
    (et1766 : t1766 = carry12) (et1797 : t1797 = carry13) (et1600 : t1600 = s1)
    (et1792 : t1792 = carry11) (et1668 : t1668 = s19) (et1642 : t1642 = s12)
    (et1881 : t1881 = carry0) (et1912 : t1912 = carry1) (et1942 : t1942 = carry0_1)
    (hs12_1 : s12_1 = s12 + s23 * 470296#64) (hs13_1 : s13_1 = s13 + s23 * 654183#64)
    (hs12_2 : s12_2 = s12_1 + s22 * 654183#64) (hs13_2 : s13_2 = s13_1 - s22 * 997805#64)
    (hs12_3 : s12_3 = s12_2 - s21 * 997805#64) (hs13_3 : s13_3 = s13_2 + s21 * 136657#64)
    (hs12_4 : s12_4 = s12_3 + s20 * 136657#64) (hs13_4 : s13_4 = s13_3 - s20 * 683901#64)
    (hs12_5 : s12_5 = s12_4 - s19 * 683901#64) (hs13_5 : s13_5 = s13_4 + carry12)
    (hs12_6 : s12_6 = s12_5 - carry12 <<< 21) (hs12_7 : s12_7 = s12_6 + carry11)
    (hs13_6 : s13_6 = s13_5 - carry13 <<< 21) (hs1_1 : s1_1 = s1 + s13_6 * 666643#64)
    (hs1_2 : s1_2 = s1_1 + s12_7 * 470296#64) (hs12_8 : s12_8 = 0#64) (hs1_3 : s1_3 = s1_2 + carry0)
    (hs1_4 : s1_4 = s1_3 - carry1 <<< 21) (hs12_9 : s12_9 = s12_8 + carry11_1)
    (hs1_5 : s1_5 = s1_4 + s12_9 * 470296#64) (hs1_6 : s1_6 = s1_5 + carry0_1)
    (hcarry1_1 : carry1_1 = s1_6.sshiftRight 21) : t1947 = carry1_1 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `carry2_1` as the C computes it is the compiled `%1953`. -/
theorem sc25519_reduce.bridge_carry2_1
    (t1685 t1686 t1687 t1694 t1695 t1696 t1702 t1703 t1704 t1705 t1706 t1707 t1712 t1713 t1719 t1720
      t1721 t1722 t1723 t1724 t1767 t1768 t1769 t1770 t1771 t1772 t1773 t1777 t1778 t1793 t1798
      t1799 t1800 t1844 t1845 t1858 t1859 t1872 t1873 t1888 t1938 t1948 t1949 t1950 t1951 t1953
      t1932 t1797 t1676 t1650 t1683 t1680 t1775 t1604 t1672 t1646 t1766 t1792 t1668 t1642 t1886
      t1912 t1947 s12_1 s13_1 s14_1 s12_2 s13_2 s14_2 s12_3 s13_3 s14_3 s12_4 s13_4 s12_5 s13_5
      s12_6 s14_4 s12_7 s14_5 s13_6 s2_1 s2_2 s2_3 s12_8 s2_4 s2_5 s12_9 s2_6 s2_7 carry2_1 s2 s12
      s13 s14 s19 s20 s21 s22 s23 carry12 carry14 carry11 carry13 carry2 carry1 carry11_1 carry1_1 :
      BitVec 64)
    (ht1685 : t1685 = t1683 * 470296#64) (ht1686 : t1686 = t1683 * 654183#64)
    (ht1687 : t1687 = t1683 * 18446744073708553811#64) (ht1694 : t1694 = t1680 * 654183#64)
    (ht1695 : t1695 = t1680 * 18446744073708553811#64) (ht1696 : t1696 = t1680 * 136657#64)
    (ht1702 : t1702 = t1676 * 18446744073708553811#64) (ht1703 : t1703 = t1676 * 136657#64)
    (ht1704 : t1704 = t1676 * 18446744073708867715#64) (ht1705 : t1705 = t1704 + t1650)
    (ht1706 : t1706 = t1705 + t1687) (ht1707 : t1707 = t1706 + t1696)
    (ht1712 : t1712 = t1672 * 136657#64) (ht1713 : t1713 = t1672 * 18446744073708867715#64)
    (ht1719 : t1719 = t1668 * 18446744073708867715#64) (ht1720 : t1720 = t1719 + t1642)
    (ht1721 : t1721 = t1720 + t1712) (ht1722 : t1722 = t1721 + t1702)
    (ht1723 : t1723 = t1722 + t1685) (ht1724 : t1724 = t1723 + t1694)
    (ht1767 : t1767 = t1713 + t1646) (ht1768 : t1768 = t1767 + t1703)
    (ht1769 : t1769 = t1768 + t1686) (ht1770 : t1770 = t1769 + t1695)
    (ht1771 : t1771 = t1770 + t1766) (ht1772 : t1772 = t1766 <<< 21)
    (ht1773 : t1773 = t1724 - t1772) (ht1777 : t1777 = t1775 <<< 21)
    (ht1778 : t1778 = t1707 - t1777) (ht1793 : t1793 = t1792 + t1773)
    (ht1798 : t1798 = t1797 + t1778) (ht1799 : t1799 = t1797 <<< 21)
    (ht1800 : t1800 = t1771 - t1799) (ht1844 : t1844 = t1798 * 666643#64)
    (ht1845 : t1845 = t1844 + t1604) (ht1858 : t1858 = t1800 * 470296#64)
    (ht1859 : t1859 = t1845 + t1858) (ht1872 : t1872 = t1793 * 654183#64)
    (ht1873 : t1873 = t1859 + t1872) (ht1888 : t1888 = t1886 <<< 21)
    (ht1938 : t1938 = t1932 * 654183#64) (ht1948 : t1948 = t1938 + t1873)
    (ht1949 : t1949 = t1948 - t1888) (ht1950 : t1950 = t1949 + t1912)
    (ht1951 : t1951 = t1950 + t1947) (ht1953 : t1953 = t1951.sshiftRight 21)
    (et1932 : t1932 = carry11_1) (et1797 : t1797 = carry13) (et1676 : t1676 = s21)
    (et1650 : t1650 = s14) (et1683 : t1683 = s23) (et1680 : t1680 = s22) (et1775 : t1775 = carry14)
    (et1604 : t1604 = s2) (et1672 : t1672 = s20) (et1646 : t1646 = s13) (et1766 : t1766 = carry12)
    (et1792 : t1792 = carry11) (et1668 : t1668 = s19) (et1642 : t1642 = s12)
    (et1886 : t1886 = carry2) (et1912 : t1912 = carry1) (et1947 : t1947 = carry1_1)
    (hs12_1 : s12_1 = s12 + s23 * 470296#64) (hs13_1 : s13_1 = s13 + s23 * 654183#64)
    (hs14_1 : s14_1 = s14 - s23 * 997805#64) (hs12_2 : s12_2 = s12_1 + s22 * 654183#64)
    (hs13_2 : s13_2 = s13_1 - s22 * 997805#64) (hs14_2 : s14_2 = s14_1 + s22 * 136657#64)
    (hs12_3 : s12_3 = s12_2 - s21 * 997805#64) (hs13_3 : s13_3 = s13_2 + s21 * 136657#64)
    (hs14_3 : s14_3 = s14_2 - s21 * 683901#64) (hs12_4 : s12_4 = s12_3 + s20 * 136657#64)
    (hs13_4 : s13_4 = s13_3 - s20 * 683901#64) (hs12_5 : s12_5 = s12_4 - s19 * 683901#64)
    (hs13_5 : s13_5 = s13_4 + carry12) (hs12_6 : s12_6 = s12_5 - carry12 <<< 21)
    (hs14_4 : s14_4 = s14_3 - carry14 <<< 21) (hs12_7 : s12_7 = s12_6 + carry11)
    (hs14_5 : s14_5 = s14_4 + carry13) (hs13_6 : s13_6 = s13_5 - carry13 <<< 21)
    (hs2_1 : s2_1 = s2 + s14_5 * 666643#64) (hs2_2 : s2_2 = s2_1 + s13_6 * 470296#64)
    (hs2_3 : s2_3 = s2_2 + s12_7 * 654183#64) (hs12_8 : s12_8 = 0#64)
    (hs2_4 : s2_4 = s2_3 - carry2 <<< 21) (hs2_5 : s2_5 = s2_4 + carry1)
    (hs12_9 : s12_9 = s12_8 + carry11_1) (hs2_6 : s2_6 = s2_5 + s12_9 * 654183#64)
    (hs2_7 : s2_7 = s2_6 + carry1_1) (hcarry2_1 : carry2_1 = s2_7.sshiftRight 21) :
    t1953 = carry2_1 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `carry3_1` as the C computes it is the compiled `%1958`. -/
theorem sc25519_reduce.bridge_carry3_1
    (t1685 t1686 t1687 t1688 t1689 t1694 t1695 t1696 t1697 t1698 t1702 t1703 t1704 t1705 t1706 t1707
      t1712 t1713 t1719 t1720 t1721 t1722 t1723 t1724 t1767 t1768 t1769 t1770 t1771 t1772 t1773
      t1776 t1777 t1778 t1793 t1798 t1799 t1800 t1804 t1805 t1828 t1829 t1846 t1847 t1860 t1861
      t1874 t1875 t1887 t1916 t1939 t1954 t1955 t1956 t1958 t1683 t1653 t1680 t1775 t1802 t1608
      t1797 t1676 t1650 t1672 t1646 t1766 t1792 t1668 t1642 t1886 t1932 t1915 t1953 s12_1 s13_1
      s14_1 s15_1 s12_2 s13_2 s14_2 s15_2 s12_3 s13_3 s14_3 s12_4 s13_4 s12_5 s13_5 s12_6 s15_3
      s14_4 s12_7 s14_5 s13_6 s15_4 s3_1 s3_2 s3_3 s3_4 s12_8 s3_5 s3_6 s12_9 s3_7 s3_8 carry3_1 s3
      s12 s13 s14 s15 s19 s20 s21 s22 s23 carry12 carry14 carry11 carry13 carry15 carry2 carry3
      carry11_1 carry2_1 : BitVec 64)
    (ht1685 : t1685 = t1683 * 470296#64) (ht1686 : t1686 = t1683 * 654183#64)
    (ht1687 : t1687 = t1683 * 18446744073708553811#64) (ht1688 : t1688 = t1683 * 136657#64)
    (ht1689 : t1689 = t1688 + t1653) (ht1694 : t1694 = t1680 * 654183#64)
    (ht1695 : t1695 = t1680 * 18446744073708553811#64) (ht1696 : t1696 = t1680 * 136657#64)
    (ht1697 : t1697 = t1680 * 18446744073708867715#64) (ht1698 : t1698 = t1689 + t1697)
    (ht1702 : t1702 = t1676 * 18446744073708553811#64) (ht1703 : t1703 = t1676 * 136657#64)
    (ht1704 : t1704 = t1676 * 18446744073708867715#64) (ht1705 : t1705 = t1704 + t1650)
    (ht1706 : t1706 = t1705 + t1687) (ht1707 : t1707 = t1706 + t1696)
    (ht1712 : t1712 = t1672 * 136657#64) (ht1713 : t1713 = t1672 * 18446744073708867715#64)
    (ht1719 : t1719 = t1668 * 18446744073708867715#64) (ht1720 : t1720 = t1719 + t1642)
    (ht1721 : t1721 = t1720 + t1712) (ht1722 : t1722 = t1721 + t1702)
    (ht1723 : t1723 = t1722 + t1685) (ht1724 : t1724 = t1723 + t1694)
    (ht1767 : t1767 = t1713 + t1646) (ht1768 : t1768 = t1767 + t1703)
    (ht1769 : t1769 = t1768 + t1686) (ht1770 : t1770 = t1769 + t1695)
    (ht1771 : t1771 = t1770 + t1766) (ht1772 : t1772 = t1766 <<< 21)
    (ht1773 : t1773 = t1724 - t1772) (ht1776 : t1776 = t1698 + t1775)
    (ht1777 : t1777 = t1775 <<< 21) (ht1778 : t1778 = t1707 - t1777)
    (ht1793 : t1793 = t1792 + t1773) (ht1798 : t1798 = t1797 + t1778)
    (ht1799 : t1799 = t1797 <<< 21) (ht1800 : t1800 = t1771 - t1799) (ht1804 : t1804 = t1802 <<< 21)
    (ht1805 : t1805 = t1776 - t1804) (ht1828 : t1828 = t1805 * 666643#64)
    (ht1829 : t1829 = t1828 + t1608) (ht1846 : t1846 = t1798 * 470296#64)
    (ht1847 : t1847 = t1829 + t1846) (ht1860 : t1860 = t1800 * 654183#64)
    (ht1861 : t1861 = t1847 + t1860) (ht1874 : t1874 = t1793 * 18446744073708553811#64)
    (ht1875 : t1875 = t1861 + t1874) (ht1887 : t1887 = t1875 + t1886)
    (ht1916 : t1916 = t1915 <<< 21) (ht1939 : t1939 = t1932 * 18446744073708553811#64)
    (ht1954 : t1954 = t1887 + t1939) (ht1955 : t1955 = t1954 - t1916)
    (ht1956 : t1956 = t1955 + t1953) (ht1958 : t1958 = t1956.sshiftRight 21) (et1683 : t1683 = s23)
    (et1653 : t1653 = s15) (et1680 : t1680 = s22) (et1775 : t1775 = carry14)
    (et1802 : t1802 = carry15) (et1608 : t1608 = s3) (et1797 : t1797 = carry13)
    (et1676 : t1676 = s21) (et1650 : t1650 = s14) (et1672 : t1672 = s20) (et1646 : t1646 = s13)
    (et1766 : t1766 = carry12) (et1792 : t1792 = carry11) (et1668 : t1668 = s19)
    (et1642 : t1642 = s12) (et1886 : t1886 = carry2) (et1932 : t1932 = carry11_1)
    (et1915 : t1915 = carry3) (et1953 : t1953 = carry2_1) (hs12_1 : s12_1 = s12 + s23 * 470296#64)
    (hs13_1 : s13_1 = s13 + s23 * 654183#64) (hs14_1 : s14_1 = s14 - s23 * 997805#64)
    (hs15_1 : s15_1 = s15 + s23 * 136657#64) (hs12_2 : s12_2 = s12_1 + s22 * 654183#64)
    (hs13_2 : s13_2 = s13_1 - s22 * 997805#64) (hs14_2 : s14_2 = s14_1 + s22 * 136657#64)
    (hs15_2 : s15_2 = s15_1 - s22 * 683901#64) (hs12_3 : s12_3 = s12_2 - s21 * 997805#64)
    (hs13_3 : s13_3 = s13_2 + s21 * 136657#64) (hs14_3 : s14_3 = s14_2 - s21 * 683901#64)
    (hs12_4 : s12_4 = s12_3 + s20 * 136657#64) (hs13_4 : s13_4 = s13_3 - s20 * 683901#64)
    (hs12_5 : s12_5 = s12_4 - s19 * 683901#64) (hs13_5 : s13_5 = s13_4 + carry12)
    (hs12_6 : s12_6 = s12_5 - carry12 <<< 21) (hs15_3 : s15_3 = s15_2 + carry14)
    (hs14_4 : s14_4 = s14_3 - carry14 <<< 21) (hs12_7 : s12_7 = s12_6 + carry11)
    (hs14_5 : s14_5 = s14_4 + carry13) (hs13_6 : s13_6 = s13_5 - carry13 <<< 21)
    (hs15_4 : s15_4 = s15_3 - carry15 <<< 21) (hs3_1 : s3_1 = s3 + s15_4 * 666643#64)
    (hs3_2 : s3_2 = s3_1 + s14_5 * 470296#64) (hs3_3 : s3_3 = s3_2 + s13_6 * 654183#64)
    (hs3_4 : s3_4 = s3_3 - s12_7 * 997805#64) (hs12_8 : s12_8 = 0#64) (hs3_5 : s3_5 = s3_4 + carry2)
    (hs3_6 : s3_6 = s3_5 - carry3 <<< 21) (hs12_9 : s12_9 = s12_8 + carry11_1)
    (hs3_7 : s3_7 = s3_6 - s12_9 * 997805#64) (hs3_8 : s3_8 = s3_7 + carry2_1)
    (hcarry3_1 : carry3_1 = s3_8.sshiftRight 21) : t1958 = carry3_1 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `carry4_1` as the C computes it is the compiled `%1964`. -/
theorem sc25519_reduce.bridge_carry4_1
    (t1685 t1686 t1687 t1688 t1689 t1690 t1691 t1694 t1695 t1696 t1697 t1698 t1702 t1703 t1704 t1705
      t1706 t1707 t1712 t1713 t1719 t1720 t1721 t1722 t1723 t1724 t1767 t1768 t1769 t1770 t1771
      t1772 t1773 t1776 t1777 t1778 t1782 t1783 t1793 t1798 t1799 t1800 t1803 t1804 t1805 t1818
      t1819 t1830 t1831 t1848 t1849 t1862 t1863 t1876 t1877 t1892 t1940 t1959 t1960 t1961 t1962
      t1964 t1932 t1802 t1683 t1656 t1780 t1612 t1653 t1680 t1775 t1797 t1676 t1650 t1672 t1646
      t1766 t1792 t1668 t1642 t1890 t1915 t1958 s12_1 s13_1 s14_1 s15_1 s16_1 s12_2 s13_2 s14_2
      s15_2 s12_3 s13_3 s14_3 s12_4 s13_4 s12_5 s13_5 s12_6 s15_3 s14_4 s16_2 s12_7 s14_5 s13_6
      s16_3 s15_4 s4_1 s4_2 s4_3 s4_4 s4_5 s12_8 s4_6 s4_7 s12_9 s4_8 s4_9 carry4_1 s4 s12 s13 s14
      s15 s16 s19 s20 s21 s22 s23 carry12 carry14 carry16 carry11 carry13 carry15 carry4 carry3
      carry11_1 carry3_1 : BitVec 64)
    (ht1685 : t1685 = t1683 * 470296#64) (ht1686 : t1686 = t1683 * 654183#64)
    (ht1687 : t1687 = t1683 * 18446744073708553811#64) (ht1688 : t1688 = t1683 * 136657#64)
    (ht1689 : t1689 = t1688 + t1653) (ht1690 : t1690 = t1683 * 18446744073708867715#64)
    (ht1691 : t1691 = t1690 + t1656) (ht1694 : t1694 = t1680 * 654183#64)
    (ht1695 : t1695 = t1680 * 18446744073708553811#64) (ht1696 : t1696 = t1680 * 136657#64)
    (ht1697 : t1697 = t1680 * 18446744073708867715#64) (ht1698 : t1698 = t1689 + t1697)
    (ht1702 : t1702 = t1676 * 18446744073708553811#64) (ht1703 : t1703 = t1676 * 136657#64)
    (ht1704 : t1704 = t1676 * 18446744073708867715#64) (ht1705 : t1705 = t1704 + t1650)
    (ht1706 : t1706 = t1705 + t1687) (ht1707 : t1707 = t1706 + t1696)
    (ht1712 : t1712 = t1672 * 136657#64) (ht1713 : t1713 = t1672 * 18446744073708867715#64)
    (ht1719 : t1719 = t1668 * 18446744073708867715#64) (ht1720 : t1720 = t1719 + t1642)
    (ht1721 : t1721 = t1720 + t1712) (ht1722 : t1722 = t1721 + t1702)
    (ht1723 : t1723 = t1722 + t1685) (ht1724 : t1724 = t1723 + t1694)
    (ht1767 : t1767 = t1713 + t1646) (ht1768 : t1768 = t1767 + t1703)
    (ht1769 : t1769 = t1768 + t1686) (ht1770 : t1770 = t1769 + t1695)
    (ht1771 : t1771 = t1770 + t1766) (ht1772 : t1772 = t1766 <<< 21)
    (ht1773 : t1773 = t1724 - t1772) (ht1776 : t1776 = t1698 + t1775)
    (ht1777 : t1777 = t1775 <<< 21) (ht1778 : t1778 = t1707 - t1777) (ht1782 : t1782 = t1780 <<< 21)
    (ht1783 : t1783 = t1691 - t1782) (ht1793 : t1793 = t1792 + t1773)
    (ht1798 : t1798 = t1797 + t1778) (ht1799 : t1799 = t1797 <<< 21)
    (ht1800 : t1800 = t1771 - t1799) (ht1803 : t1803 = t1802 + t1783)
    (ht1804 : t1804 = t1802 <<< 21) (ht1805 : t1805 = t1776 - t1804)
    (ht1818 : t1818 = t1803 * 666643#64) (ht1819 : t1819 = t1818 + t1612)
    (ht1830 : t1830 = t1805 * 470296#64) (ht1831 : t1831 = t1819 + t1830)
    (ht1848 : t1848 = t1798 * 654183#64) (ht1849 : t1849 = t1831 + t1848)
    (ht1862 : t1862 = t1800 * 18446744073708553811#64) (ht1863 : t1863 = t1849 + t1862)
    (ht1876 : t1876 = t1793 * 136657#64) (ht1877 : t1877 = t1863 + t1876)
    (ht1892 : t1892 = t1890 <<< 21) (ht1940 : t1940 = t1932 * 136657#64)
    (ht1959 : t1959 = t1940 + t1877) (ht1960 : t1960 = t1959 - t1892)
    (ht1961 : t1961 = t1960 + t1915) (ht1962 : t1962 = t1961 + t1958)
    (ht1964 : t1964 = t1962.sshiftRight 21) (et1932 : t1932 = carry11_1) (et1802 : t1802 = carry15)
    (et1683 : t1683 = s23) (et1656 : t1656 = s16) (et1780 : t1780 = carry16) (et1612 : t1612 = s4)
    (et1653 : t1653 = s15) (et1680 : t1680 = s22) (et1775 : t1775 = carry14)
    (et1797 : t1797 = carry13) (et1676 : t1676 = s21) (et1650 : t1650 = s14) (et1672 : t1672 = s20)
    (et1646 : t1646 = s13) (et1766 : t1766 = carry12) (et1792 : t1792 = carry11)
    (et1668 : t1668 = s19) (et1642 : t1642 = s12) (et1890 : t1890 = carry4)
    (et1915 : t1915 = carry3) (et1958 : t1958 = carry3_1) (hs12_1 : s12_1 = s12 + s23 * 470296#64)
    (hs13_1 : s13_1 = s13 + s23 * 654183#64) (hs14_1 : s14_1 = s14 - s23 * 997805#64)
    (hs15_1 : s15_1 = s15 + s23 * 136657#64) (hs16_1 : s16_1 = s16 - s23 * 683901#64)
    (hs12_2 : s12_2 = s12_1 + s22 * 654183#64) (hs13_2 : s13_2 = s13_1 - s22 * 997805#64)
    (hs14_2 : s14_2 = s14_1 + s22 * 136657#64) (hs15_2 : s15_2 = s15_1 - s22 * 683901#64)
    (hs12_3 : s12_3 = s12_2 - s21 * 997805#64) (hs13_3 : s13_3 = s13_2 + s21 * 136657#64)
    (hs14_3 : s14_3 = s14_2 - s21 * 683901#64) (hs12_4 : s12_4 = s12_3 + s20 * 136657#64)
    (hs13_4 : s13_4 = s13_3 - s20 * 683901#64) (hs12_5 : s12_5 = s12_4 - s19 * 683901#64)
    (hs13_5 : s13_5 = s13_4 + carry12) (hs12_6 : s12_6 = s12_5 - carry12 <<< 21)
    (hs15_3 : s15_3 = s15_2 + carry14) (hs14_4 : s14_4 = s14_3 - carry14 <<< 21)
    (hs16_2 : s16_2 = s16_1 - carry16 <<< 21) (hs12_7 : s12_7 = s12_6 + carry11)
    (hs14_5 : s14_5 = s14_4 + carry13) (hs13_6 : s13_6 = s13_5 - carry13 <<< 21)
    (hs16_3 : s16_3 = s16_2 + carry15) (hs15_4 : s15_4 = s15_3 - carry15 <<< 21)
    (hs4_1 : s4_1 = s4 + s16_3 * 666643#64) (hs4_2 : s4_2 = s4_1 + s15_4 * 470296#64)
    (hs4_3 : s4_3 = s4_2 + s14_5 * 654183#64) (hs4_4 : s4_4 = s4_3 - s13_6 * 997805#64)
    (hs4_5 : s4_5 = s4_4 + s12_7 * 136657#64) (hs12_8 : s12_8 = 0#64)
    (hs4_6 : s4_6 = s4_5 - carry4 <<< 21) (hs4_7 : s4_7 = s4_6 + carry3)
    (hs12_9 : s12_9 = s12_8 + carry11_1) (hs4_8 : s4_8 = s4_7 + s12_9 * 136657#64)
    (hs4_9 : s4_9 = s4_8 + carry3_1) (hcarry4_1 : carry4_1 = s4_9.sshiftRight 21) :
    t1964 = carry4_1 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `carry5_1` as the C computes it is the compiled `%1969`. -/
theorem sc25519_reduce.bridge_carry5_1
    (t1685 t1686 t1687 t1688 t1689 t1690 t1691 t1694 t1695 t1696 t1697 t1698 t1702 t1703 t1704 t1705
      t1706 t1707 t1712 t1713 t1719 t1720 t1721 t1722 t1723 t1724 t1767 t1768 t1769 t1770 t1771
      t1772 t1773 t1776 t1777 t1778 t1781 t1782 t1783 t1793 t1798 t1799 t1800 t1803 t1804 t1805
      t1806 t1807 t1820 t1821 t1832 t1833 t1850 t1851 t1864 t1865 t1878 t1879 t1891 t1920 t1941
      t1965 t1966 t1967 t1969 t1780 t1660 t1616 t1802 t1683 t1656 t1653 t1680 t1775 t1797 t1676
      t1650 t1672 t1646 t1766 t1792 t1668 t1642 t1890 t1932 t1918 t1964 s12_1 s13_1 s14_1 s15_1
      s16_1 s12_2 s13_2 s14_2 s15_2 s12_3 s13_3 s14_3 s12_4 s13_4 s12_5 s13_5 s12_6 s15_3 s14_4
      s17_1 s16_2 s12_7 s14_5 s13_6 s16_3 s15_4 s5_1 s5_2 s5_3 s5_4 s5_5 s5_6 s12_8 s5_7 s5_8 s12_9
      s5_9 s5_10 carry5_1 s5 s12 s13 s14 s15 s16 s17 s19 s20 s21 s22 s23 carry12 carry14 carry16
      carry11 carry13 carry15 carry4 carry5 carry11_1 carry4_1 : BitVec 64)
    (ht1685 : t1685 = t1683 * 470296#64) (ht1686 : t1686 = t1683 * 654183#64)
    (ht1687 : t1687 = t1683 * 18446744073708553811#64) (ht1688 : t1688 = t1683 * 136657#64)
    (ht1689 : t1689 = t1688 + t1653) (ht1690 : t1690 = t1683 * 18446744073708867715#64)
    (ht1691 : t1691 = t1690 + t1656) (ht1694 : t1694 = t1680 * 654183#64)
    (ht1695 : t1695 = t1680 * 18446744073708553811#64) (ht1696 : t1696 = t1680 * 136657#64)
    (ht1697 : t1697 = t1680 * 18446744073708867715#64) (ht1698 : t1698 = t1689 + t1697)
    (ht1702 : t1702 = t1676 * 18446744073708553811#64) (ht1703 : t1703 = t1676 * 136657#64)
    (ht1704 : t1704 = t1676 * 18446744073708867715#64) (ht1705 : t1705 = t1704 + t1650)
    (ht1706 : t1706 = t1705 + t1687) (ht1707 : t1707 = t1706 + t1696)
    (ht1712 : t1712 = t1672 * 136657#64) (ht1713 : t1713 = t1672 * 18446744073708867715#64)
    (ht1719 : t1719 = t1668 * 18446744073708867715#64) (ht1720 : t1720 = t1719 + t1642)
    (ht1721 : t1721 = t1720 + t1712) (ht1722 : t1722 = t1721 + t1702)
    (ht1723 : t1723 = t1722 + t1685) (ht1724 : t1724 = t1723 + t1694)
    (ht1767 : t1767 = t1713 + t1646) (ht1768 : t1768 = t1767 + t1703)
    (ht1769 : t1769 = t1768 + t1686) (ht1770 : t1770 = t1769 + t1695)
    (ht1771 : t1771 = t1770 + t1766) (ht1772 : t1772 = t1766 <<< 21)
    (ht1773 : t1773 = t1724 - t1772) (ht1776 : t1776 = t1698 + t1775)
    (ht1777 : t1777 = t1775 <<< 21) (ht1778 : t1778 = t1707 - t1777)
    (ht1781 : t1781 = t1780 + t1660) (ht1782 : t1782 = t1780 <<< 21)
    (ht1783 : t1783 = t1691 - t1782) (ht1793 : t1793 = t1792 + t1773)
    (ht1798 : t1798 = t1797 + t1778) (ht1799 : t1799 = t1797 <<< 21)
    (ht1800 : t1800 = t1771 - t1799) (ht1803 : t1803 = t1802 + t1783)
    (ht1804 : t1804 = t1802 <<< 21) (ht1805 : t1805 = t1776 - t1804)
    (ht1806 : t1806 = t1781 * 666643#64) (ht1807 : t1807 = t1806 + t1616)
    (ht1820 : t1820 = t1803 * 470296#64) (ht1821 : t1821 = t1807 + t1820)
    (ht1832 : t1832 = t1805 * 654183#64) (ht1833 : t1833 = t1821 + t1832)
    (ht1850 : t1850 = t1798 * 18446744073708553811#64) (ht1851 : t1851 = t1833 + t1850)
    (ht1864 : t1864 = t1800 * 136657#64) (ht1865 : t1865 = t1851 + t1864)
    (ht1878 : t1878 = t1793 * 18446744073708867715#64) (ht1879 : t1879 = t1865 + t1878)
    (ht1891 : t1891 = t1879 + t1890) (ht1920 : t1920 = t1918 <<< 21)
    (ht1941 : t1941 = t1932 * 18446744073708867715#64) (ht1965 : t1965 = t1891 + t1941)
    (ht1966 : t1966 = t1965 - t1920) (ht1967 : t1967 = t1966 + t1964)
    (ht1969 : t1969 = t1967.sshiftRight 21) (et1780 : t1780 = carry16) (et1660 : t1660 = s17)
    (et1616 : t1616 = s5) (et1802 : t1802 = carry15) (et1683 : t1683 = s23) (et1656 : t1656 = s16)
    (et1653 : t1653 = s15) (et1680 : t1680 = s22) (et1775 : t1775 = carry14)
    (et1797 : t1797 = carry13) (et1676 : t1676 = s21) (et1650 : t1650 = s14) (et1672 : t1672 = s20)
    (et1646 : t1646 = s13) (et1766 : t1766 = carry12) (et1792 : t1792 = carry11)
    (et1668 : t1668 = s19) (et1642 : t1642 = s12) (et1890 : t1890 = carry4)
    (et1932 : t1932 = carry11_1) (et1918 : t1918 = carry5) (et1964 : t1964 = carry4_1)
    (hs12_1 : s12_1 = s12 + s23 * 470296#64) (hs13_1 : s13_1 = s13 + s23 * 654183#64)
    (hs14_1 : s14_1 = s14 - s23 * 997805#64) (hs15_1 : s15_1 = s15 + s23 * 136657#64)
    (hs16_1 : s16_1 = s16 - s23 * 683901#64) (hs12_2 : s12_2 = s12_1 + s22 * 654183#64)
    (hs13_2 : s13_2 = s13_1 - s22 * 997805#64) (hs14_2 : s14_2 = s14_1 + s22 * 136657#64)
    (hs15_2 : s15_2 = s15_1 - s22 * 683901#64) (hs12_3 : s12_3 = s12_2 - s21 * 997805#64)
    (hs13_3 : s13_3 = s13_2 + s21 * 136657#64) (hs14_3 : s14_3 = s14_2 - s21 * 683901#64)
    (hs12_4 : s12_4 = s12_3 + s20 * 136657#64) (hs13_4 : s13_4 = s13_3 - s20 * 683901#64)
    (hs12_5 : s12_5 = s12_4 - s19 * 683901#64) (hs13_5 : s13_5 = s13_4 + carry12)
    (hs12_6 : s12_6 = s12_5 - carry12 <<< 21) (hs15_3 : s15_3 = s15_2 + carry14)
    (hs14_4 : s14_4 = s14_3 - carry14 <<< 21) (hs17_1 : s17_1 = s17 + carry16)
    (hs16_2 : s16_2 = s16_1 - carry16 <<< 21) (hs12_7 : s12_7 = s12_6 + carry11)
    (hs14_5 : s14_5 = s14_4 + carry13) (hs13_6 : s13_6 = s13_5 - carry13 <<< 21)
    (hs16_3 : s16_3 = s16_2 + carry15) (hs15_4 : s15_4 = s15_3 - carry15 <<< 21)
    (hs5_1 : s5_1 = s5 + s17_1 * 666643#64) (hs5_2 : s5_2 = s5_1 + s16_3 * 470296#64)
    (hs5_3 : s5_3 = s5_2 + s15_4 * 654183#64) (hs5_4 : s5_4 = s5_3 - s14_5 * 997805#64)
    (hs5_5 : s5_5 = s5_4 + s13_6 * 136657#64) (hs5_6 : s5_6 = s5_5 - s12_7 * 683901#64)
    (hs12_8 : s12_8 = 0#64) (hs5_7 : s5_7 = s5_6 + carry4) (hs5_8 : s5_8 = s5_7 - carry5 <<< 21)
    (hs12_9 : s12_9 = s12_8 + carry11_1) (hs5_9 : s5_9 = s5_8 - s12_9 * 683901#64)
    (hs5_10 : s5_10 = s5_9 + carry4_1) (hcarry5_1 : carry5_1 = s5_10.sshiftRight 21) :
    t1969 = carry5_1 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `carry6_2` as the C computes it is the compiled `%1972`. -/
theorem sc25519_reduce.bridge_carry6_2
    (t1686 t1687 t1688 t1689 t1690 t1691 t1695 t1696 t1697 t1698 t1703 t1704 t1705 t1706 t1707 t1713
      t1725 t1726 t1745 t1746 t1767 t1768 t1769 t1770 t1771 t1776 t1777 t1778 t1781 t1782 t1783
      t1798 t1799 t1800 t1803 t1804 t1805 t1808 t1809 t1822 t1823 t1834 t1835 t1852 t1853 t1866
      t1867 t1896 t1897 t1919 t1970 t1972 t1664 t1620 t1741 t1780 t1660 t1802 t1683 t1656 t1653
      t1680 t1775 t1797 t1676 t1650 t1672 t1646 t1766 t1894 t1918 t1969 s13_1 s14_1 s15_1 s16_1
      s13_2 s14_2 s15_2 s13_3 s14_3 s13_4 s6_1 s6_2 s13_5 s15_3 s14_4 s17_1 s16_2 s14_5 s13_6 s16_3
      s15_4 s6_3 s6_4 s6_5 s6_6 s6_7 s6_8 s6_9 s6_10 carry6_2 s6 s13 s14 s15 s16 s17 s18 s20 s21 s22
      s23 carry6 carry12 carry14 carry16 carry13 carry15 carry6_1 carry5 carry5_1 : BitVec 64)
    (ht1686 : t1686 = t1683 * 654183#64) (ht1687 : t1687 = t1683 * 18446744073708553811#64)
    (ht1688 : t1688 = t1683 * 136657#64) (ht1689 : t1689 = t1688 + t1653)
    (ht1690 : t1690 = t1683 * 18446744073708867715#64) (ht1691 : t1691 = t1690 + t1656)
    (ht1695 : t1695 = t1680 * 18446744073708553811#64) (ht1696 : t1696 = t1680 * 136657#64)
    (ht1697 : t1697 = t1680 * 18446744073708867715#64) (ht1698 : t1698 = t1689 + t1697)
    (ht1703 : t1703 = t1676 * 136657#64) (ht1704 : t1704 = t1676 * 18446744073708867715#64)
    (ht1705 : t1705 = t1704 + t1650) (ht1706 : t1706 = t1705 + t1687)
    (ht1707 : t1707 = t1706 + t1696) (ht1713 : t1713 = t1672 * 18446744073708867715#64)
    (ht1725 : t1725 = t1664 * 666643#64) (ht1726 : t1726 = t1725 + t1620)
    (ht1745 : t1745 = t1741 <<< 21) (ht1746 : t1746 = t1726 - t1745)
    (ht1767 : t1767 = t1713 + t1646) (ht1768 : t1768 = t1767 + t1703)
    (ht1769 : t1769 = t1768 + t1686) (ht1770 : t1770 = t1769 + t1695)
    (ht1771 : t1771 = t1770 + t1766) (ht1776 : t1776 = t1698 + t1775)
    (ht1777 : t1777 = t1775 <<< 21) (ht1778 : t1778 = t1707 - t1777)
    (ht1781 : t1781 = t1780 + t1660) (ht1782 : t1782 = t1780 <<< 21)
    (ht1783 : t1783 = t1691 - t1782) (ht1798 : t1798 = t1797 + t1778)
    (ht1799 : t1799 = t1797 <<< 21) (ht1800 : t1800 = t1771 - t1799)
    (ht1803 : t1803 = t1802 + t1783) (ht1804 : t1804 = t1802 <<< 21)
    (ht1805 : t1805 = t1776 - t1804) (ht1808 : t1808 = t1781 * 470296#64)
    (ht1809 : t1809 = t1746 + t1808) (ht1822 : t1822 = t1803 * 654183#64)
    (ht1823 : t1823 = t1809 + t1822) (ht1834 : t1834 = t1805 * 18446744073708553811#64)
    (ht1835 : t1835 = t1823 + t1834) (ht1852 : t1852 = t1798 * 136657#64)
    (ht1853 : t1853 = t1835 + t1852) (ht1866 : t1866 = t1800 * 18446744073708867715#64)
    (ht1867 : t1867 = t1853 + t1866) (ht1896 : t1896 = t1894 <<< 21)
    (ht1897 : t1897 = t1867 - t1896) (ht1919 : t1919 = t1897 + t1918)
    (ht1970 : t1970 = t1919 + t1969) (ht1972 : t1972 = t1970.sshiftRight 21) (et1664 : t1664 = s18)
    (et1620 : t1620 = s6) (et1741 : t1741 = carry6) (et1780 : t1780 = carry16)
    (et1660 : t1660 = s17) (et1802 : t1802 = carry15) (et1683 : t1683 = s23) (et1656 : t1656 = s16)
    (et1653 : t1653 = s15) (et1680 : t1680 = s22) (et1775 : t1775 = carry14)
    (et1797 : t1797 = carry13) (et1676 : t1676 = s21) (et1650 : t1650 = s14) (et1672 : t1672 = s20)
    (et1646 : t1646 = s13) (et1766 : t1766 = carry12) (et1894 : t1894 = carry6_1)
    (et1918 : t1918 = carry5) (et1969 : t1969 = carry5_1) (hs13_1 : s13_1 = s13 + s23 * 654183#64)
    (hs14_1 : s14_1 = s14 - s23 * 997805#64) (hs15_1 : s15_1 = s15 + s23 * 136657#64)
    (hs16_1 : s16_1 = s16 - s23 * 683901#64) (hs13_2 : s13_2 = s13_1 - s22 * 997805#64)
    (hs14_2 : s14_2 = s14_1 + s22 * 136657#64) (hs15_2 : s15_2 = s15_1 - s22 * 683901#64)
    (hs13_3 : s13_3 = s13_2 + s21 * 136657#64) (hs14_3 : s14_3 = s14_2 - s21 * 683901#64)
    (hs13_4 : s13_4 = s13_3 - s20 * 683901#64) (hs6_1 : s6_1 = s6 + s18 * 666643#64)
    (hs6_2 : s6_2 = s6_1 - carry6 <<< 21) (hs13_5 : s13_5 = s13_4 + carry12)
    (hs15_3 : s15_3 = s15_2 + carry14) (hs14_4 : s14_4 = s14_3 - carry14 <<< 21)
    (hs17_1 : s17_1 = s17 + carry16) (hs16_2 : s16_2 = s16_1 - carry16 <<< 21)
    (hs14_5 : s14_5 = s14_4 + carry13) (hs13_6 : s13_6 = s13_5 - carry13 <<< 21)
    (hs16_3 : s16_3 = s16_2 + carry15) (hs15_4 : s15_4 = s15_3 - carry15 <<< 21)
    (hs6_3 : s6_3 = s6_2 + s17_1 * 470296#64) (hs6_4 : s6_4 = s6_3 + s16_3 * 654183#64)
    (hs6_5 : s6_5 = s6_4 - s15_4 * 997805#64) (hs6_6 : s6_6 = s6_5 + s14_5 * 136657#64)
    (hs6_7 : s6_7 = s6_6 - s13_6 * 683901#64) (hs6_8 : s6_8 = s6_7 - carry6_1 <<< 21)
    (hs6_9 : s6_9 = s6_8 + carry5) (hs6_10 : s6_10 = s6_9 + carry5_1)
    (hcarry6_2 : carry6_2 = s6_10.sshiftRight 21) : t1972 = carry6_2 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `carry7_2` as the C computes it is the compiled `%1975`. -/
theorem sc25519_reduce.bridge_carry7_2
    (t1687 t1688 t1689 t1690 t1691 t1696 t1697 t1698 t1704 t1705 t1706 t1707 t1714 t1727 t1742 t1743
      t1744 t1776 t1777 t1778 t1781 t1782 t1783 t1786 t1787 t1798 t1803 t1804 t1805 t1810 t1811
      t1824 t1825 t1836 t1837 t1854 t1855 t1895 t1924 t1925 t1973 t1975 t1972 t1664 t1623 t1668
      t1741 t1785 t1780 t1660 t1802 t1683 t1656 t1653 t1680 t1775 t1797 t1676 t1650 t1894 t1922
      s14_1 s15_1 s16_1 s14_2 s15_2 s14_3 s7_1 s7_2 s7_3 s15_3 s14_4 s17_1 s16_2 s7_4 s14_5 s16_3
      s15_4 s7_5 s7_6 s7_7 s7_8 s7_9 s7_10 s7_11 carry7_2 s7 s14 s15 s16 s17 s18 s19 s21 s22 s23
      carry6 carry14 carry16 carry7 carry13 carry15 carry6_1 carry7_1 carry6_2 : BitVec 64)
    (ht1687 : t1687 = t1683 * 18446744073708553811#64) (ht1688 : t1688 = t1683 * 136657#64)
    (ht1689 : t1689 = t1688 + t1653) (ht1690 : t1690 = t1683 * 18446744073708867715#64)
    (ht1691 : t1691 = t1690 + t1656) (ht1696 : t1696 = t1680 * 136657#64)
    (ht1697 : t1697 = t1680 * 18446744073708867715#64) (ht1698 : t1698 = t1689 + t1697)
    (ht1704 : t1704 = t1676 * 18446744073708867715#64) (ht1705 : t1705 = t1704 + t1650)
    (ht1706 : t1706 = t1705 + t1687) (ht1707 : t1707 = t1706 + t1696)
    (ht1714 : t1714 = t1668 * 666643#64) (ht1727 : t1727 = t1664 * 470296#64)
    (ht1742 : t1742 = t1727 + t1623) (ht1743 : t1743 = t1742 + t1714)
    (ht1744 : t1744 = t1743 + t1741) (ht1776 : t1776 = t1698 + t1775)
    (ht1777 : t1777 = t1775 <<< 21) (ht1778 : t1778 = t1707 - t1777)
    (ht1781 : t1781 = t1780 + t1660) (ht1782 : t1782 = t1780 <<< 21)
    (ht1783 : t1783 = t1691 - t1782) (ht1786 : t1786 = t1785 <<< 21)
    (ht1787 : t1787 = t1744 - t1786) (ht1798 : t1798 = t1797 + t1778)
    (ht1803 : t1803 = t1802 + t1783) (ht1804 : t1804 = t1802 <<< 21)
    (ht1805 : t1805 = t1776 - t1804) (ht1810 : t1810 = t1781 * 654183#64)
    (ht1811 : t1811 = t1787 + t1810) (ht1824 : t1824 = t1803 * 18446744073708553811#64)
    (ht1825 : t1825 = t1811 + t1824) (ht1836 : t1836 = t1805 * 136657#64)
    (ht1837 : t1837 = t1825 + t1836) (ht1854 : t1854 = t1798 * 18446744073708867715#64)
    (ht1855 : t1855 = t1837 + t1854) (ht1895 : t1895 = t1855 + t1894)
    (ht1924 : t1924 = t1922 <<< 21) (ht1925 : t1925 = t1895 - t1924)
    (ht1973 : t1973 = t1972 + t1925) (ht1975 : t1975 = t1973.sshiftRight 21)
    (et1972 : t1972 = carry6_2) (et1664 : t1664 = s18) (et1623 : t1623 = s7) (et1668 : t1668 = s19)
    (et1741 : t1741 = carry6) (et1785 : t1785 = carry7) (et1780 : t1780 = carry16)
    (et1660 : t1660 = s17) (et1802 : t1802 = carry15) (et1683 : t1683 = s23) (et1656 : t1656 = s16)
    (et1653 : t1653 = s15) (et1680 : t1680 = s22) (et1775 : t1775 = carry14)
    (et1797 : t1797 = carry13) (et1676 : t1676 = s21) (et1650 : t1650 = s14)
    (et1894 : t1894 = carry6_1) (et1922 : t1922 = carry7_1) (hs14_1 : s14_1 = s14 - s23 * 997805#64)
    (hs15_1 : s15_1 = s15 + s23 * 136657#64) (hs16_1 : s16_1 = s16 - s23 * 683901#64)
    (hs14_2 : s14_2 = s14_1 + s22 * 136657#64) (hs15_2 : s15_2 = s15_1 - s22 * 683901#64)
    (hs14_3 : s14_3 = s14_2 - s21 * 683901#64) (hs7_1 : s7_1 = s7 + s19 * 666643#64)
    (hs7_2 : s7_2 = s7_1 + s18 * 470296#64) (hs7_3 : s7_3 = s7_2 + carry6)
    (hs15_3 : s15_3 = s15_2 + carry14) (hs14_4 : s14_4 = s14_3 - carry14 <<< 21)
    (hs17_1 : s17_1 = s17 + carry16) (hs16_2 : s16_2 = s16_1 - carry16 <<< 21)
    (hs7_4 : s7_4 = s7_3 - carry7 <<< 21) (hs14_5 : s14_5 = s14_4 + carry13)
    (hs16_3 : s16_3 = s16_2 + carry15) (hs15_4 : s15_4 = s15_3 - carry15 <<< 21)
    (hs7_5 : s7_5 = s7_4 + s17_1 * 654183#64) (hs7_6 : s7_6 = s7_5 - s16_3 * 997805#64)
    (hs7_7 : s7_7 = s7_6 + s15_4 * 136657#64) (hs7_8 : s7_8 = s7_7 - s14_5 * 683901#64)
    (hs7_9 : s7_9 = s7_8 + carry6_1) (hs7_10 : s7_10 = s7_9 - carry7_1 <<< 21)
    (hs7_11 : s7_11 = s7_10 + carry6_2) (hcarry7_2 : carry7_2 = s7_11.sshiftRight 21) :
    t1975 = carry7_2 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `carry8_2` as the C computes it is the compiled `%1978`. -/
theorem sc25519_reduce.bridge_carry8_2
    (t1688 t1689 t1690 t1691 t1697 t1698 t1708 t1715 t1728 t1729 t1730 t1731 t1754 t1776 t1781 t1782
      t1783 t1803 t1804 t1805 t1812 t1826 t1838 t1839 t1840 t1841 t1842 t1843 t1904 t1905 t1923
      t1976 t1978 t1785 t1664 t1626 t1668 t1672 t1748 t1780 t1660 t1802 t1683 t1656 t1653 t1680
      t1775 t1899 t1922 t1975 s15_1 s16_1 s15_2 s8_1 s8_2 s8_3 s8_4 s15_3 s17_1 s16_2 s8_5 s16_3
      s15_4 s8_6 s8_7 s8_8 s8_9 s8_10 s8_11 carry8_2 s8 s15 s16 s17 s18 s19 s20 s22 s23 carry8
      carry14 carry16 carry7 carry15 carry8_1 carry7_1 carry7_2 : BitVec 64)
    (ht1688 : t1688 = t1683 * 136657#64) (ht1689 : t1689 = t1688 + t1653)
    (ht1690 : t1690 = t1683 * 18446744073708867715#64) (ht1691 : t1691 = t1690 + t1656)
    (ht1697 : t1697 = t1680 * 18446744073708867715#64) (ht1698 : t1698 = t1689 + t1697)
    (ht1708 : t1708 = t1672 * 666643#64) (ht1715 : t1715 = t1668 * 470296#64)
    (ht1728 : t1728 = t1664 * 654183#64) (ht1729 : t1729 = t1728 + t1626)
    (ht1730 : t1730 = t1729 + t1715) (ht1731 : t1731 = t1730 + t1708)
    (ht1754 : t1754 = t1748 <<< 21) (ht1776 : t1776 = t1698 + t1775)
    (ht1781 : t1781 = t1780 + t1660) (ht1782 : t1782 = t1780 <<< 21)
    (ht1783 : t1783 = t1691 - t1782) (ht1803 : t1803 = t1802 + t1783)
    (ht1804 : t1804 = t1802 <<< 21) (ht1805 : t1805 = t1776 - t1804)
    (ht1812 : t1812 = t1781 * 18446744073708553811#64) (ht1826 : t1826 = t1803 * 136657#64)
    (ht1838 : t1838 = t1805 * 18446744073708867715#64) (ht1839 : t1839 = t1785 + t1731)
    (ht1840 : t1840 = t1839 - t1754) (ht1841 : t1841 = t1840 + t1812)
    (ht1842 : t1842 = t1841 + t1826) (ht1843 : t1843 = t1842 + t1838)
    (ht1904 : t1904 = t1899 <<< 21) (ht1905 : t1905 = t1843 - t1904)
    (ht1923 : t1923 = t1905 + t1922) (ht1976 : t1976 = t1923 + t1975)
    (ht1978 : t1978 = t1976.sshiftRight 21) (et1785 : t1785 = carry7) (et1664 : t1664 = s18)
    (et1626 : t1626 = s8) (et1668 : t1668 = s19) (et1672 : t1672 = s20) (et1748 : t1748 = carry8)
    (et1780 : t1780 = carry16) (et1660 : t1660 = s17) (et1802 : t1802 = carry15)
    (et1683 : t1683 = s23) (et1656 : t1656 = s16) (et1653 : t1653 = s15) (et1680 : t1680 = s22)
    (et1775 : t1775 = carry14) (et1899 : t1899 = carry8_1) (et1922 : t1922 = carry7_1)
    (et1975 : t1975 = carry7_2) (hs15_1 : s15_1 = s15 + s23 * 136657#64)
    (hs16_1 : s16_1 = s16 - s23 * 683901#64) (hs15_2 : s15_2 = s15_1 - s22 * 683901#64)
    (hs8_1 : s8_1 = s8 + s20 * 666643#64) (hs8_2 : s8_2 = s8_1 + s19 * 470296#64)
    (hs8_3 : s8_3 = s8_2 + s18 * 654183#64) (hs8_4 : s8_4 = s8_3 - carry8 <<< 21)
    (hs15_3 : s15_3 = s15_2 + carry14) (hs17_1 : s17_1 = s17 + carry16)
    (hs16_2 : s16_2 = s16_1 - carry16 <<< 21) (hs8_5 : s8_5 = s8_4 + carry7)
    (hs16_3 : s16_3 = s16_2 + carry15) (hs15_4 : s15_4 = s15_3 - carry15 <<< 21)
    (hs8_6 : s8_6 = s8_5 - s17_1 * 997805#64) (hs8_7 : s8_7 = s8_6 + s16_3 * 136657#64)
    (hs8_8 : s8_8 = s8_7 - s15_4 * 683901#64) (hs8_9 : s8_9 = s8_8 - carry8_1 <<< 21)
    (hs8_10 : s8_10 = s8_9 + carry7_1) (hs8_11 : s8_11 = s8_10 + carry7_2)
    (hcarry8_2 : carry8_2 = s8_11.sshiftRight 21) : t1978 = carry8_2 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `carry9_2` as the C computes it is the compiled `%1981`. -/
theorem sc25519_reduce.bridge_carry9_2
    (t1690 t1691 t1699 t1709 t1716 t1732 t1749 t1750 t1751 t1752 t1753 t1781 t1782 t1783 t1790 t1803
      t1813 t1827 t1900 t1901 t1902 t1903 t1929 t1930 t1979 t1981 t1978 t1780 t1660 t1664 t1630
      t1668 t1672 t1676 t1748 t1789 t1802 t1683 t1656 t1899 t1927 s16_1 s9_1 s9_2 s9_3 s9_4 s9_5
      s17_1 s16_2 s9_6 s16_3 s9_7 s9_8 s9_9 s9_10 s9_11 carry9_2 s9 s16 s17 s18 s19 s20 s21 s23
      carry8 carry16 carry9 carry15 carry8_1 carry9_1 carry8_2 : BitVec 64)
    (ht1690 : t1690 = t1683 * 18446744073708867715#64) (ht1691 : t1691 = t1690 + t1656)
    (ht1699 : t1699 = t1676 * 666643#64) (ht1709 : t1709 = t1672 * 470296#64)
    (ht1716 : t1716 = t1668 * 654183#64) (ht1732 : t1732 = t1664 * 18446744073708553811#64)
    (ht1749 : t1749 = t1732 + t1630) (ht1750 : t1750 = t1749 + t1716)
    (ht1751 : t1751 = t1750 + t1709) (ht1752 : t1752 = t1751 + t1699)
    (ht1753 : t1753 = t1752 + t1748) (ht1781 : t1781 = t1780 + t1660)
    (ht1782 : t1782 = t1780 <<< 21) (ht1783 : t1783 = t1691 - t1782) (ht1790 : t1790 = t1789 <<< 21)
    (ht1803 : t1803 = t1802 + t1783) (ht1813 : t1813 = t1781 * 136657#64)
    (ht1827 : t1827 = t1803 * 18446744073708867715#64) (ht1900 : t1900 = t1813 + t1753)
    (ht1901 : t1901 = t1900 - t1790) (ht1902 : t1902 = t1901 + t1827)
    (ht1903 : t1903 = t1902 + t1899) (ht1929 : t1929 = t1927 <<< 21)
    (ht1930 : t1930 = t1903 - t1929) (ht1979 : t1979 = t1978 + t1930)
    (ht1981 : t1981 = t1979.sshiftRight 21) (et1978 : t1978 = carry8_2) (et1780 : t1780 = carry16)
    (et1660 : t1660 = s17) (et1664 : t1664 = s18) (et1630 : t1630 = s9) (et1668 : t1668 = s19)
    (et1672 : t1672 = s20) (et1676 : t1676 = s21) (et1748 : t1748 = carry8)
    (et1789 : t1789 = carry9) (et1802 : t1802 = carry15) (et1683 : t1683 = s23)
    (et1656 : t1656 = s16) (et1899 : t1899 = carry8_1) (et1927 : t1927 = carry9_1)
    (hs16_1 : s16_1 = s16 - s23 * 683901#64) (hs9_1 : s9_1 = s9 + s21 * 666643#64)
    (hs9_2 : s9_2 = s9_1 + s20 * 470296#64) (hs9_3 : s9_3 = s9_2 + s19 * 654183#64)
    (hs9_4 : s9_4 = s9_3 - s18 * 997805#64) (hs9_5 : s9_5 = s9_4 + carry8)
    (hs17_1 : s17_1 = s17 + carry16) (hs16_2 : s16_2 = s16_1 - carry16 <<< 21)
    (hs9_6 : s9_6 = s9_5 - carry9 <<< 21) (hs16_3 : s16_3 = s16_2 + carry15)
    (hs9_7 : s9_7 = s9_6 + s17_1 * 136657#64) (hs9_8 : s9_8 = s9_7 - s16_3 * 683901#64)
    (hs9_9 : s9_9 = s9_8 + carry8_1) (hs9_10 : s9_10 = s9_9 - carry9_1 <<< 21)
    (hs9_11 : s9_11 = s9_10 + carry8_2) (hcarry9_2 : carry9_2 = s9_11.sshiftRight 21) :
    t1981 = carry9_2 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `carry10_2` as the C computes it is the compiled `%1984`. -/
theorem sc25519_reduce.bridge_carry10_2
    (t1692 t1700 t1710 t1717 t1733 t1734 t1735 t1736 t1737 t1738 t1764 t1781 t1814 t1815 t1816 t1817
      t1909 t1910 t1928 t1982 t1984 t1780 t1660 t1664 t1634 t1668 t1672 t1676 t1680 t1789 t1756
      t1907 t1927 t1981 s10_1 s10_2 s10_3 s10_4 s10_5 s10_6 s17_1 s10_7 s10_8 s10_9 s10_10 s10_11
      carry10_2 s10 s17 s18 s19 s20 s21 s22 carry10 carry16 carry9 carry10_1 carry9_1 carry9_2 :
      BitVec 64)
    (ht1692 : t1692 = t1680 * 666643#64) (ht1700 : t1700 = t1676 * 470296#64)
    (ht1710 : t1710 = t1672 * 654183#64) (ht1717 : t1717 = t1668 * 18446744073708553811#64)
    (ht1733 : t1733 = t1664 * 136657#64) (ht1734 : t1734 = t1733 + t1634)
    (ht1735 : t1735 = t1734 + t1717) (ht1736 : t1736 = t1735 + t1710)
    (ht1737 : t1737 = t1736 + t1700) (ht1738 : t1738 = t1737 + t1692)
    (ht1764 : t1764 = t1756 <<< 21) (ht1781 : t1781 = t1780 + t1660)
    (ht1814 : t1814 = t1781 * 18446744073708867715#64) (ht1815 : t1815 = t1814 + t1738)
    (ht1816 : t1816 = t1815 + t1789) (ht1817 : t1817 = t1816 - t1764)
    (ht1909 : t1909 = t1907 <<< 21) (ht1910 : t1910 = t1817 - t1909)
    (ht1928 : t1928 = t1910 + t1927) (ht1982 : t1982 = t1928 + t1981)
    (ht1984 : t1984 = t1982.sshiftRight 21) (et1780 : t1780 = carry16) (et1660 : t1660 = s17)
    (et1664 : t1664 = s18) (et1634 : t1634 = s10) (et1668 : t1668 = s19) (et1672 : t1672 = s20)
    (et1676 : t1676 = s21) (et1680 : t1680 = s22) (et1789 : t1789 = carry9)
    (et1756 : t1756 = carry10) (et1907 : t1907 = carry10_1) (et1927 : t1927 = carry9_1)
    (et1981 : t1981 = carry9_2) (hs10_1 : s10_1 = s10 + s22 * 666643#64)
    (hs10_2 : s10_2 = s10_1 + s21 * 470296#64) (hs10_3 : s10_3 = s10_2 + s20 * 654183#64)
    (hs10_4 : s10_4 = s10_3 - s19 * 997805#64) (hs10_5 : s10_5 = s10_4 + s18 * 136657#64)
    (hs10_6 : s10_6 = s10_5 - carry10 <<< 21) (hs17_1 : s17_1 = s17 + carry16)
    (hs10_7 : s10_7 = s10_6 + carry9) (hs10_8 : s10_8 = s10_7 - s17_1 * 683901#64)
    (hs10_9 : s10_9 = s10_8 - carry10_1 <<< 21) (hs10_10 : s10_10 = s10_9 + carry9_1)
    (hs10_11 : s10_11 = s10_10 + carry9_2) (hcarry10_2 : carry10_2 = s10_11.sshiftRight 21) :
    t1984 = carry10_2 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `carry11_2` as the C computes it is the compiled `%1987`. -/
theorem sc25519_reduce.bridge_carry11_2
    (t1684 t1693 t1701 t1711 t1718 t1739 t1757 t1758 t1759 t1760 t1761 t1762 t1763 t1794 t1795 t1908
      t1933 t1934 t1985 t1987 t1984 t1907 t1664 t1638 t1668 t1672 t1676 t1683 t1680 t1756 t1792
      t1932 s11_1 s11_2 s11_3 s11_4 s11_5 s11_6 s11_7 s11_8 s11_9 s11_10 s11_11 carry11_2 s11 s18
      s19 s20 s21 s22 s23 carry10 carry11 carry10_1 carry11_1 carry10_2 : BitVec 64)
    (ht1684 : t1684 = t1683 * 666643#64) (ht1693 : t1693 = t1680 * 470296#64)
    (ht1701 : t1701 = t1676 * 654183#64) (ht1711 : t1711 = t1672 * 18446744073708553811#64)
    (ht1718 : t1718 = t1668 * 136657#64) (ht1739 : t1739 = t1664 * 18446744073708867715#64)
    (ht1757 : t1757 = t1739 + t1638) (ht1758 : t1758 = t1757 + t1718)
    (ht1759 : t1759 = t1758 + t1711) (ht1760 : t1760 = t1759 + t1701)
    (ht1761 : t1761 = t1760 + t1684) (ht1762 : t1762 = t1761 + t1693)
    (ht1763 : t1763 = t1762 + t1756) (ht1794 : t1794 = t1792 <<< 21)
    (ht1795 : t1795 = t1763 - t1794) (ht1908 : t1908 = t1907 + t1795)
    (ht1933 : t1933 = t1932 <<< 21) (ht1934 : t1934 = t1908 - t1933)
    (ht1985 : t1985 = t1984 + t1934) (ht1987 : t1987 = t1985.sshiftRight 21)
    (et1984 : t1984 = carry10_2) (et1907 : t1907 = carry10_1) (et1664 : t1664 = s18)
    (et1638 : t1638 = s11) (et1668 : t1668 = s19) (et1672 : t1672 = s20) (et1676 : t1676 = s21)
    (et1683 : t1683 = s23) (et1680 : t1680 = s22) (et1756 : t1756 = carry10)
    (et1792 : t1792 = carry11) (et1932 : t1932 = carry11_1) (hs11_1 : s11_1 = s11 + s23 * 666643#64)
    (hs11_2 : s11_2 = s11_1 + s22 * 470296#64) (hs11_3 : s11_3 = s11_2 + s21 * 654183#64)
    (hs11_4 : s11_4 = s11_3 - s20 * 997805#64) (hs11_5 : s11_5 = s11_4 + s19 * 136657#64)
    (hs11_6 : s11_6 = s11_5 - s18 * 683901#64) (hs11_7 : s11_7 = s11_6 + carry10)
    (hs11_8 : s11_8 = s11_7 - carry11 <<< 21) (hs11_9 : s11_9 = s11_8 + carry10_1)
    (hs11_10 : s11_10 = s11_9 - carry11_1 <<< 21) (hs11_11 : s11_11 = s11_10 + carry10_2)
    (hcarry11_2 : carry11_2 = s11_11.sshiftRight 21) : t1987 = carry11_2 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `s0_5` as the C computes it is the compiled `%1990`. -/
theorem sc25519_reduce.bridge_s0_5
    (t1685 t1694 t1702 t1712 t1719 t1720 t1721 t1722 t1723 t1724 t1772 t1773 t1793 t1868 t1869 t1883
      t1884 t1935 t1936 t1946 t1989 t1990 t1987 t1792 t1668 t1642 t1672 t1676 t1683 t1680 t1766
      t1596 t1881 t1932 t1942 s12_1 s12_2 s12_3 s12_4 s12_5 s12_6 s12_7 s0_1 s12_8 s0_2 s12_9 s0_3
      s12_10 s0_4 s12_11 s0_5 s0 s12 s19 s20 s21 s22 s23 carry12 carry11 carry0 carry11_1 carry0_1
      carry11_2 : BitVec 64)
    (ht1685 : t1685 = t1683 * 470296#64) (ht1694 : t1694 = t1680 * 654183#64)
    (ht1702 : t1702 = t1676 * 18446744073708553811#64) (ht1712 : t1712 = t1672 * 136657#64)
    (ht1719 : t1719 = t1668 * 18446744073708867715#64) (ht1720 : t1720 = t1719 + t1642)
    (ht1721 : t1721 = t1720 + t1712) (ht1722 : t1722 = t1721 + t1702)
    (ht1723 : t1723 = t1722 + t1685) (ht1724 : t1724 = t1723 + t1694)
    (ht1772 : t1772 = t1766 <<< 21) (ht1773 : t1773 = t1724 - t1772)
    (ht1793 : t1793 = t1792 + t1773) (ht1868 : t1868 = t1793 * 666643#64)
    (ht1869 : t1869 = t1868 + t1596) (ht1883 : t1883 = t1881 <<< 21)
    (ht1884 : t1884 = t1869 - t1883) (ht1935 : t1935 = t1932 * 666643#64)
    (ht1936 : t1936 = t1884 + t1935) (ht1946 : t1946 = t1936 - t1942 <<< 21)
    (ht1989 : t1989 = t1987 * 666643#64) (ht1990 : t1990 = t1989 + t1946)
    (et1987 : t1987 = carry11_2) (et1792 : t1792 = carry11) (et1668 : t1668 = s19)
    (et1642 : t1642 = s12) (et1672 : t1672 = s20) (et1676 : t1676 = s21) (et1683 : t1683 = s23)
    (et1680 : t1680 = s22) (et1766 : t1766 = carry12) (et1596 : t1596 = s0)
    (et1881 : t1881 = carry0) (et1932 : t1932 = carry11_1) (et1942 : t1942 = carry0_1)
    (hs12_1 : s12_1 = s12 + s23 * 470296#64) (hs12_2 : s12_2 = s12_1 + s22 * 654183#64)
    (hs12_3 : s12_3 = s12_2 - s21 * 997805#64) (hs12_4 : s12_4 = s12_3 + s20 * 136657#64)
    (hs12_5 : s12_5 = s12_4 - s19 * 683901#64) (hs12_6 : s12_6 = s12_5 - carry12 <<< 21)
    (hs12_7 : s12_7 = s12_6 + carry11) (hs0_1 : s0_1 = s0 + s12_7 * 666643#64)
    (hs12_8 : s12_8 = 0#64) (hs0_2 : s0_2 = s0_1 - carry0 <<< 21)
    (hs12_9 : s12_9 = s12_8 + carry11_1) (hs0_3 : s0_3 = s0_2 + s12_9 * 666643#64)
    (hs12_10 : s12_10 = 0#64) (hs0_4 : s0_4 = s0_3 - carry0_1 <<< 21)
    (hs12_11 : s12_11 = s12_10 + carry11_2) (hs0_5 : s0_5 = s0_4 + s12_11 * 666643#64) :
    t1990 = s0_5 := by
  subst_vars
  grind

/-- `carry0_2` as the C computes it is the compiled `%2001`. -/
theorem sc25519_reduce.bridge_carry0_2
    (t1685 t1694 t1702 t1712 t1719 t1720 t1721 t1722 t1723 t1724 t1772 t1773 t1793 t1868 t1869 t1883
      t1884 t1935 t1936 t1946 t1989 t1990 t2001 t1987 t1792 t1668 t1642 t1672 t1676 t1683 t1680
      t1766 t1596 t1881 t1932 t1942 s12_1 s12_2 s12_3 s12_4 s12_5 s12_6 s12_7 s0_1 s12_8 s0_2 s12_9
      s0_3 s12_10 s0_4 s12_11 s0_5 carry0_2 s0 s12 s19 s20 s21 s22 s23 carry12 carry11 carry0
      carry11_1 carry0_1 carry11_2 : BitVec 64)
    (ht1685 : t1685 = t1683 * 470296#64) (ht1694 : t1694 = t1680 * 654183#64)
    (ht1702 : t1702 = t1676 * 18446744073708553811#64) (ht1712 : t1712 = t1672 * 136657#64)
    (ht1719 : t1719 = t1668 * 18446744073708867715#64) (ht1720 : t1720 = t1719 + t1642)
    (ht1721 : t1721 = t1720 + t1712) (ht1722 : t1722 = t1721 + t1702)
    (ht1723 : t1723 = t1722 + t1685) (ht1724 : t1724 = t1723 + t1694)
    (ht1772 : t1772 = t1766 <<< 21) (ht1773 : t1773 = t1724 - t1772)
    (ht1793 : t1793 = t1792 + t1773) (ht1868 : t1868 = t1793 * 666643#64)
    (ht1869 : t1869 = t1868 + t1596) (ht1883 : t1883 = t1881 <<< 21)
    (ht1884 : t1884 = t1869 - t1883) (ht1935 : t1935 = t1932 * 666643#64)
    (ht1936 : t1936 = t1884 + t1935) (ht1946 : t1946 = t1936 - t1942 <<< 21)
    (ht1989 : t1989 = t1987 * 666643#64) (ht1990 : t1990 = t1989 + t1946)
    (ht2001 : t2001 = t1990.sshiftRight 21) (et1987 : t1987 = carry11_2) (et1792 : t1792 = carry11)
    (et1668 : t1668 = s19) (et1642 : t1642 = s12) (et1672 : t1672 = s20) (et1676 : t1676 = s21)
    (et1683 : t1683 = s23) (et1680 : t1680 = s22) (et1766 : t1766 = carry12) (et1596 : t1596 = s0)
    (et1881 : t1881 = carry0) (et1932 : t1932 = carry11_1) (et1942 : t1942 = carry0_1)
    (hs12_1 : s12_1 = s12 + s23 * 470296#64) (hs12_2 : s12_2 = s12_1 + s22 * 654183#64)
    (hs12_3 : s12_3 = s12_2 - s21 * 997805#64) (hs12_4 : s12_4 = s12_3 + s20 * 136657#64)
    (hs12_5 : s12_5 = s12_4 - s19 * 683901#64) (hs12_6 : s12_6 = s12_5 - carry12 <<< 21)
    (hs12_7 : s12_7 = s12_6 + carry11) (hs0_1 : s0_1 = s0 + s12_7 * 666643#64)
    (hs12_8 : s12_8 = 0#64) (hs0_2 : s0_2 = s0_1 - carry0 <<< 21)
    (hs12_9 : s12_9 = s12_8 + carry11_1) (hs0_3 : s0_3 = s0_2 + s12_9 * 666643#64)
    (hs12_10 : s12_10 = 0#64) (hs0_4 : s0_4 = s0_3 - carry0_1 <<< 21)
    (hs12_11 : s12_11 = s12_10 + carry11_2) (hs0_5 : s0_5 = s0_4 + s12_11 * 666643#64)
    (hcarry0_2 : carry0_2 = s0_5.sshiftRight 21) : t2001 = carry0_2 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `s1_9` as the C computes it is the compiled `%2002`. -/
theorem sc25519_reduce.bridge_s1_9
    (t1685 t1686 t1694 t1695 t1702 t1703 t1712 t1713 t1719 t1720 t1721 t1722 t1723 t1724 t1767 t1768
      t1769 t1770 t1771 t1772 t1773 t1793 t1799 t1800 t1856 t1857 t1870 t1871 t1882 t1913 t1937
      t1943 t1944 t1945 t1952 t1991 t1992 t2002 t1987 t1932 t1672 t1646 t1676 t1683 t1680 t1766
      t1797 t1600 t1792 t1668 t1642 t1881 t1912 t1942 t1947 t2001 s12_1 s13_1 s12_2 s13_2 s12_3
      s13_3 s12_4 s13_4 s12_5 s13_5 s12_6 s12_7 s13_6 s1_1 s1_2 s12_8 s1_3 s1_4 s12_9 s1_5 s12_10
      s1_6 s1_7 s12_11 s1_8 s1_9 s1 s12 s13 s19 s20 s21 s22 s23 carry12 carry11 carry13 carry0
      carry1 carry11_1 carry0_1 carry1_1 carry11_2 carry0_2 : BitVec 64)
    (ht1685 : t1685 = t1683 * 470296#64) (ht1686 : t1686 = t1683 * 654183#64)
    (ht1694 : t1694 = t1680 * 654183#64) (ht1695 : t1695 = t1680 * 18446744073708553811#64)
    (ht1702 : t1702 = t1676 * 18446744073708553811#64) (ht1703 : t1703 = t1676 * 136657#64)
    (ht1712 : t1712 = t1672 * 136657#64) (ht1713 : t1713 = t1672 * 18446744073708867715#64)
    (ht1719 : t1719 = t1668 * 18446744073708867715#64) (ht1720 : t1720 = t1719 + t1642)
    (ht1721 : t1721 = t1720 + t1712) (ht1722 : t1722 = t1721 + t1702)
    (ht1723 : t1723 = t1722 + t1685) (ht1724 : t1724 = t1723 + t1694)
    (ht1767 : t1767 = t1713 + t1646) (ht1768 : t1768 = t1767 + t1703)
    (ht1769 : t1769 = t1768 + t1686) (ht1770 : t1770 = t1769 + t1695)
    (ht1771 : t1771 = t1770 + t1766) (ht1772 : t1772 = t1766 <<< 21)
    (ht1773 : t1773 = t1724 - t1772) (ht1793 : t1793 = t1792 + t1773)
    (ht1799 : t1799 = t1797 <<< 21) (ht1800 : t1800 = t1771 - t1799)
    (ht1856 : t1856 = t1800 * 666643#64) (ht1857 : t1857 = t1856 + t1600)
    (ht1870 : t1870 = t1793 * 470296#64) (ht1871 : t1871 = t1857 + t1870)
    (ht1882 : t1882 = t1871 + t1881) (ht1913 : t1913 = t1912 <<< 21)
    (ht1937 : t1937 = t1932 * 470296#64) (ht1943 : t1943 = t1937 + t1882)
    (ht1944 : t1944 = t1943 - t1913) (ht1945 : t1945 = t1944 + t1942)
    (ht1952 : t1952 = t1945 - t1947 <<< 21) (ht1991 : t1991 = t1987 * 470296#64)
    (ht1992 : t1992 = t1991 + t1952) (ht2002 : t2002 = t1992 + t2001) (et1987 : t1987 = carry11_2)
    (et1932 : t1932 = carry11_1) (et1672 : t1672 = s20) (et1646 : t1646 = s13)
    (et1676 : t1676 = s21) (et1683 : t1683 = s23) (et1680 : t1680 = s22) (et1766 : t1766 = carry12)
    (et1797 : t1797 = carry13) (et1600 : t1600 = s1) (et1792 : t1792 = carry11)
    (et1668 : t1668 = s19) (et1642 : t1642 = s12) (et1881 : t1881 = carry0)
    (et1912 : t1912 = carry1) (et1942 : t1942 = carry0_1) (et1947 : t1947 = carry1_1)
    (et2001 : t2001 = carry0_2) (hs12_1 : s12_1 = s12 + s23 * 470296#64)
    (hs13_1 : s13_1 = s13 + s23 * 654183#64) (hs12_2 : s12_2 = s12_1 + s22 * 654183#64)
    (hs13_2 : s13_2 = s13_1 - s22 * 997805#64) (hs12_3 : s12_3 = s12_2 - s21 * 997805#64)
    (hs13_3 : s13_3 = s13_2 + s21 * 136657#64) (hs12_4 : s12_4 = s12_3 + s20 * 136657#64)
    (hs13_4 : s13_4 = s13_3 - s20 * 683901#64) (hs12_5 : s12_5 = s12_4 - s19 * 683901#64)
    (hs13_5 : s13_5 = s13_4 + carry12) (hs12_6 : s12_6 = s12_5 - carry12 <<< 21)
    (hs12_7 : s12_7 = s12_6 + carry11) (hs13_6 : s13_6 = s13_5 - carry13 <<< 21)
    (hs1_1 : s1_1 = s1 + s13_6 * 666643#64) (hs1_2 : s1_2 = s1_1 + s12_7 * 470296#64)
    (hs12_8 : s12_8 = 0#64) (hs1_3 : s1_3 = s1_2 + carry0) (hs1_4 : s1_4 = s1_3 - carry1 <<< 21)
    (hs12_9 : s12_9 = s12_8 + carry11_1) (hs1_5 : s1_5 = s1_4 + s12_9 * 470296#64)
    (hs12_10 : s12_10 = 0#64) (hs1_6 : s1_6 = s1_5 + carry0_1)
    (hs1_7 : s1_7 = s1_6 - carry1_1 <<< 21) (hs12_11 : s12_11 = s12_10 + carry11_2)
    (hs1_8 : s1_8 = s1_7 + s12_11 * 470296#64) (hs1_9 : s1_9 = s1_8 + carry0_2) : t2002 = s1_9 := by
  subst_vars
  grind

/-- `carry1_2` as the C computes it is the compiled `%2003`. -/
theorem sc25519_reduce.bridge_carry1_2
    (t1685 t1686 t1694 t1695 t1702 t1703 t1712 t1713 t1719 t1720 t1721 t1722 t1723 t1724 t1767 t1768
      t1769 t1770 t1771 t1772 t1773 t1793 t1799 t1800 t1856 t1857 t1870 t1871 t1882 t1913 t1937
      t1943 t1944 t1945 t1952 t1991 t1992 t2002 t2003 t1987 t1932 t1672 t1646 t1676 t1683 t1680
      t1766 t1797 t1600 t1792 t1668 t1642 t1881 t1912 t1942 t1947 t2001 s12_1 s13_1 s12_2 s13_2
      s12_3 s13_3 s12_4 s13_4 s12_5 s13_5 s12_6 s12_7 s13_6 s1_1 s1_2 s12_8 s1_3 s1_4 s12_9 s1_5
      s12_10 s1_6 s1_7 s12_11 s1_8 s1_9 carry1_2 s1 s12 s13 s19 s20 s21 s22 s23 carry12 carry11
      carry13 carry0 carry1 carry11_1 carry0_1 carry1_1 carry11_2 carry0_2 : BitVec 64)
    (ht1685 : t1685 = t1683 * 470296#64) (ht1686 : t1686 = t1683 * 654183#64)
    (ht1694 : t1694 = t1680 * 654183#64) (ht1695 : t1695 = t1680 * 18446744073708553811#64)
    (ht1702 : t1702 = t1676 * 18446744073708553811#64) (ht1703 : t1703 = t1676 * 136657#64)
    (ht1712 : t1712 = t1672 * 136657#64) (ht1713 : t1713 = t1672 * 18446744073708867715#64)
    (ht1719 : t1719 = t1668 * 18446744073708867715#64) (ht1720 : t1720 = t1719 + t1642)
    (ht1721 : t1721 = t1720 + t1712) (ht1722 : t1722 = t1721 + t1702)
    (ht1723 : t1723 = t1722 + t1685) (ht1724 : t1724 = t1723 + t1694)
    (ht1767 : t1767 = t1713 + t1646) (ht1768 : t1768 = t1767 + t1703)
    (ht1769 : t1769 = t1768 + t1686) (ht1770 : t1770 = t1769 + t1695)
    (ht1771 : t1771 = t1770 + t1766) (ht1772 : t1772 = t1766 <<< 21)
    (ht1773 : t1773 = t1724 - t1772) (ht1793 : t1793 = t1792 + t1773)
    (ht1799 : t1799 = t1797 <<< 21) (ht1800 : t1800 = t1771 - t1799)
    (ht1856 : t1856 = t1800 * 666643#64) (ht1857 : t1857 = t1856 + t1600)
    (ht1870 : t1870 = t1793 * 470296#64) (ht1871 : t1871 = t1857 + t1870)
    (ht1882 : t1882 = t1871 + t1881) (ht1913 : t1913 = t1912 <<< 21)
    (ht1937 : t1937 = t1932 * 470296#64) (ht1943 : t1943 = t1937 + t1882)
    (ht1944 : t1944 = t1943 - t1913) (ht1945 : t1945 = t1944 + t1942)
    (ht1952 : t1952 = t1945 - t1947 <<< 21) (ht1991 : t1991 = t1987 * 470296#64)
    (ht1992 : t1992 = t1991 + t1952) (ht2002 : t2002 = t1992 + t2001)
    (ht2003 : t2003 = t2002.sshiftRight 21) (et1987 : t1987 = carry11_2)
    (et1932 : t1932 = carry11_1) (et1672 : t1672 = s20) (et1646 : t1646 = s13)
    (et1676 : t1676 = s21) (et1683 : t1683 = s23) (et1680 : t1680 = s22) (et1766 : t1766 = carry12)
    (et1797 : t1797 = carry13) (et1600 : t1600 = s1) (et1792 : t1792 = carry11)
    (et1668 : t1668 = s19) (et1642 : t1642 = s12) (et1881 : t1881 = carry0)
    (et1912 : t1912 = carry1) (et1942 : t1942 = carry0_1) (et1947 : t1947 = carry1_1)
    (et2001 : t2001 = carry0_2) (hs12_1 : s12_1 = s12 + s23 * 470296#64)
    (hs13_1 : s13_1 = s13 + s23 * 654183#64) (hs12_2 : s12_2 = s12_1 + s22 * 654183#64)
    (hs13_2 : s13_2 = s13_1 - s22 * 997805#64) (hs12_3 : s12_3 = s12_2 - s21 * 997805#64)
    (hs13_3 : s13_3 = s13_2 + s21 * 136657#64) (hs12_4 : s12_4 = s12_3 + s20 * 136657#64)
    (hs13_4 : s13_4 = s13_3 - s20 * 683901#64) (hs12_5 : s12_5 = s12_4 - s19 * 683901#64)
    (hs13_5 : s13_5 = s13_4 + carry12) (hs12_6 : s12_6 = s12_5 - carry12 <<< 21)
    (hs12_7 : s12_7 = s12_6 + carry11) (hs13_6 : s13_6 = s13_5 - carry13 <<< 21)
    (hs1_1 : s1_1 = s1 + s13_6 * 666643#64) (hs1_2 : s1_2 = s1_1 + s12_7 * 470296#64)
    (hs12_8 : s12_8 = 0#64) (hs1_3 : s1_3 = s1_2 + carry0) (hs1_4 : s1_4 = s1_3 - carry1 <<< 21)
    (hs12_9 : s12_9 = s12_8 + carry11_1) (hs1_5 : s1_5 = s1_4 + s12_9 * 470296#64)
    (hs12_10 : s12_10 = 0#64) (hs1_6 : s1_6 = s1_5 + carry0_1)
    (hs1_7 : s1_7 = s1_6 - carry1_1 <<< 21) (hs12_11 : s12_11 = s12_10 + carry11_2)
    (hs1_8 : s1_8 = s1_7 + s12_11 * 470296#64) (hs1_9 : s1_9 = s1_8 + carry0_2)
    (hcarry1_2 : carry1_2 = s1_9.sshiftRight 21) : t2003 = carry1_2 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `s2_10` as the C computes it is the compiled `%2004`. -/
theorem sc25519_reduce.bridge_s2_10
    (t1685 t1686 t1687 t1694 t1695 t1696 t1702 t1703 t1704 t1705 t1706 t1707 t1712 t1713 t1719 t1720
      t1721 t1722 t1723 t1724 t1767 t1768 t1769 t1770 t1771 t1772 t1773 t1777 t1778 t1793 t1798
      t1799 t1800 t1844 t1845 t1858 t1859 t1872 t1873 t1888 t1938 t1948 t1949 t1950 t1951 t1957
      t1993 t1994 t2004 t1987 t1932 t1797 t1676 t1650 t1683 t1680 t1775 t1604 t1672 t1646 t1766
      t1792 t1668 t1642 t1886 t1912 t1947 t1953 t2003 s12_1 s13_1 s14_1 s12_2 s13_2 s14_2 s12_3
      s13_3 s14_3 s12_4 s13_4 s12_5 s13_5 s12_6 s14_4 s12_7 s14_5 s13_6 s2_1 s2_2 s2_3 s12_8 s2_4
      s2_5 s12_9 s2_6 s12_10 s2_7 s2_8 s12_11 s2_9 s2_10 s2 s12 s13 s14 s19 s20 s21 s22 s23 carry12
      carry14 carry11 carry13 carry2 carry1 carry11_1 carry1_1 carry2_1 carry11_2 carry1_2 :
      BitVec 64)
    (ht1685 : t1685 = t1683 * 470296#64) (ht1686 : t1686 = t1683 * 654183#64)
    (ht1687 : t1687 = t1683 * 18446744073708553811#64) (ht1694 : t1694 = t1680 * 654183#64)
    (ht1695 : t1695 = t1680 * 18446744073708553811#64) (ht1696 : t1696 = t1680 * 136657#64)
    (ht1702 : t1702 = t1676 * 18446744073708553811#64) (ht1703 : t1703 = t1676 * 136657#64)
    (ht1704 : t1704 = t1676 * 18446744073708867715#64) (ht1705 : t1705 = t1704 + t1650)
    (ht1706 : t1706 = t1705 + t1687) (ht1707 : t1707 = t1706 + t1696)
    (ht1712 : t1712 = t1672 * 136657#64) (ht1713 : t1713 = t1672 * 18446744073708867715#64)
    (ht1719 : t1719 = t1668 * 18446744073708867715#64) (ht1720 : t1720 = t1719 + t1642)
    (ht1721 : t1721 = t1720 + t1712) (ht1722 : t1722 = t1721 + t1702)
    (ht1723 : t1723 = t1722 + t1685) (ht1724 : t1724 = t1723 + t1694)
    (ht1767 : t1767 = t1713 + t1646) (ht1768 : t1768 = t1767 + t1703)
    (ht1769 : t1769 = t1768 + t1686) (ht1770 : t1770 = t1769 + t1695)
    (ht1771 : t1771 = t1770 + t1766) (ht1772 : t1772 = t1766 <<< 21)
    (ht1773 : t1773 = t1724 - t1772) (ht1777 : t1777 = t1775 <<< 21)
    (ht1778 : t1778 = t1707 - t1777) (ht1793 : t1793 = t1792 + t1773)
    (ht1798 : t1798 = t1797 + t1778) (ht1799 : t1799 = t1797 <<< 21)
    (ht1800 : t1800 = t1771 - t1799) (ht1844 : t1844 = t1798 * 666643#64)
    (ht1845 : t1845 = t1844 + t1604) (ht1858 : t1858 = t1800 * 470296#64)
    (ht1859 : t1859 = t1845 + t1858) (ht1872 : t1872 = t1793 * 654183#64)
    (ht1873 : t1873 = t1859 + t1872) (ht1888 : t1888 = t1886 <<< 21)
    (ht1938 : t1938 = t1932 * 654183#64) (ht1948 : t1948 = t1938 + t1873)
    (ht1949 : t1949 = t1948 - t1888) (ht1950 : t1950 = t1949 + t1912)
    (ht1951 : t1951 = t1950 + t1947) (ht1957 : t1957 = t1951 - t1953 <<< 21)
    (ht1993 : t1993 = t1987 * 654183#64) (ht1994 : t1994 = t1993 + t1957)
    (ht2004 : t2004 = t1994 + t2003) (et1987 : t1987 = carry11_2) (et1932 : t1932 = carry11_1)
    (et1797 : t1797 = carry13) (et1676 : t1676 = s21) (et1650 : t1650 = s14) (et1683 : t1683 = s23)
    (et1680 : t1680 = s22) (et1775 : t1775 = carry14) (et1604 : t1604 = s2) (et1672 : t1672 = s20)
    (et1646 : t1646 = s13) (et1766 : t1766 = carry12) (et1792 : t1792 = carry11)
    (et1668 : t1668 = s19) (et1642 : t1642 = s12) (et1886 : t1886 = carry2)
    (et1912 : t1912 = carry1) (et1947 : t1947 = carry1_1) (et1953 : t1953 = carry2_1)
    (et2003 : t2003 = carry1_2) (hs12_1 : s12_1 = s12 + s23 * 470296#64)
    (hs13_1 : s13_1 = s13 + s23 * 654183#64) (hs14_1 : s14_1 = s14 - s23 * 997805#64)
    (hs12_2 : s12_2 = s12_1 + s22 * 654183#64) (hs13_2 : s13_2 = s13_1 - s22 * 997805#64)
    (hs14_2 : s14_2 = s14_1 + s22 * 136657#64) (hs12_3 : s12_3 = s12_2 - s21 * 997805#64)
    (hs13_3 : s13_3 = s13_2 + s21 * 136657#64) (hs14_3 : s14_3 = s14_2 - s21 * 683901#64)
    (hs12_4 : s12_4 = s12_3 + s20 * 136657#64) (hs13_4 : s13_4 = s13_3 - s20 * 683901#64)
    (hs12_5 : s12_5 = s12_4 - s19 * 683901#64) (hs13_5 : s13_5 = s13_4 + carry12)
    (hs12_6 : s12_6 = s12_5 - carry12 <<< 21) (hs14_4 : s14_4 = s14_3 - carry14 <<< 21)
    (hs12_7 : s12_7 = s12_6 + carry11) (hs14_5 : s14_5 = s14_4 + carry13)
    (hs13_6 : s13_6 = s13_5 - carry13 <<< 21) (hs2_1 : s2_1 = s2 + s14_5 * 666643#64)
    (hs2_2 : s2_2 = s2_1 + s13_6 * 470296#64) (hs2_3 : s2_3 = s2_2 + s12_7 * 654183#64)
    (hs12_8 : s12_8 = 0#64) (hs2_4 : s2_4 = s2_3 - carry2 <<< 21) (hs2_5 : s2_5 = s2_4 + carry1)
    (hs12_9 : s12_9 = s12_8 + carry11_1) (hs2_6 : s2_6 = s2_5 + s12_9 * 654183#64)
    (hs12_10 : s12_10 = 0#64) (hs2_7 : s2_7 = s2_6 + carry1_1)
    (hs2_8 : s2_8 = s2_7 - carry2_1 <<< 21) (hs12_11 : s12_11 = s12_10 + carry11_2)
    (hs2_9 : s2_9 = s2_8 + s12_11 * 654183#64) (hs2_10 : s2_10 = s2_9 + carry1_2) :
    t2004 = s2_10 := by
  subst_vars
  grind

/-- `s1_10` as the C computes it is the compiled `%2005`. -/
theorem sc25519_reduce.bridge_s1_10
    (t1685 t1686 t1694 t1695 t1702 t1703 t1712 t1713 t1719 t1720 t1721 t1722 t1723 t1724 t1767 t1768
      t1769 t1770 t1771 t1772 t1773 t1793 t1799 t1800 t1856 t1857 t1870 t1871 t1882 t1913 t1937
      t1943 t1944 t1945 t1952 t1991 t1992 t2002 t2005 t1987 t1932 t1672 t1646 t1676 t1683 t1680
      t1766 t1797 t1600 t1792 t1668 t1642 t1881 t1912 t1942 t1947 t2001 t2003 s12_1 s13_1 s12_2
      s13_2 s12_3 s13_3 s12_4 s13_4 s12_5 s13_5 s12_6 s12_7 s13_6 s1_1 s1_2 s12_8 s1_3 s1_4 s12_9
      s1_5 s12_10 s1_6 s1_7 s12_11 s1_8 s1_9 s1_10 s1 s12 s13 s19 s20 s21 s22 s23 carry12 carry11
      carry13 carry0 carry1 carry11_1 carry0_1 carry1_1 carry11_2 carry0_2 carry1_2 : BitVec 64)
    (ht1685 : t1685 = t1683 * 470296#64) (ht1686 : t1686 = t1683 * 654183#64)
    (ht1694 : t1694 = t1680 * 654183#64) (ht1695 : t1695 = t1680 * 18446744073708553811#64)
    (ht1702 : t1702 = t1676 * 18446744073708553811#64) (ht1703 : t1703 = t1676 * 136657#64)
    (ht1712 : t1712 = t1672 * 136657#64) (ht1713 : t1713 = t1672 * 18446744073708867715#64)
    (ht1719 : t1719 = t1668 * 18446744073708867715#64) (ht1720 : t1720 = t1719 + t1642)
    (ht1721 : t1721 = t1720 + t1712) (ht1722 : t1722 = t1721 + t1702)
    (ht1723 : t1723 = t1722 + t1685) (ht1724 : t1724 = t1723 + t1694)
    (ht1767 : t1767 = t1713 + t1646) (ht1768 : t1768 = t1767 + t1703)
    (ht1769 : t1769 = t1768 + t1686) (ht1770 : t1770 = t1769 + t1695)
    (ht1771 : t1771 = t1770 + t1766) (ht1772 : t1772 = t1766 <<< 21)
    (ht1773 : t1773 = t1724 - t1772) (ht1793 : t1793 = t1792 + t1773)
    (ht1799 : t1799 = t1797 <<< 21) (ht1800 : t1800 = t1771 - t1799)
    (ht1856 : t1856 = t1800 * 666643#64) (ht1857 : t1857 = t1856 + t1600)
    (ht1870 : t1870 = t1793 * 470296#64) (ht1871 : t1871 = t1857 + t1870)
    (ht1882 : t1882 = t1871 + t1881) (ht1913 : t1913 = t1912 <<< 21)
    (ht1937 : t1937 = t1932 * 470296#64) (ht1943 : t1943 = t1937 + t1882)
    (ht1944 : t1944 = t1943 - t1913) (ht1945 : t1945 = t1944 + t1942)
    (ht1952 : t1952 = t1945 - t1947 <<< 21) (ht1991 : t1991 = t1987 * 470296#64)
    (ht1992 : t1992 = t1991 + t1952) (ht2002 : t2002 = t1992 + t2001)
    (ht2005 : t2005 = t2002 - t2003 <<< 21) (et1987 : t1987 = carry11_2)
    (et1932 : t1932 = carry11_1) (et1672 : t1672 = s20) (et1646 : t1646 = s13)
    (et1676 : t1676 = s21) (et1683 : t1683 = s23) (et1680 : t1680 = s22) (et1766 : t1766 = carry12)
    (et1797 : t1797 = carry13) (et1600 : t1600 = s1) (et1792 : t1792 = carry11)
    (et1668 : t1668 = s19) (et1642 : t1642 = s12) (et1881 : t1881 = carry0)
    (et1912 : t1912 = carry1) (et1942 : t1942 = carry0_1) (et1947 : t1947 = carry1_1)
    (et2001 : t2001 = carry0_2) (et2003 : t2003 = carry1_2) (hs12_1 : s12_1 = s12 + s23 * 470296#64)
    (hs13_1 : s13_1 = s13 + s23 * 654183#64) (hs12_2 : s12_2 = s12_1 + s22 * 654183#64)
    (hs13_2 : s13_2 = s13_1 - s22 * 997805#64) (hs12_3 : s12_3 = s12_2 - s21 * 997805#64)
    (hs13_3 : s13_3 = s13_2 + s21 * 136657#64) (hs12_4 : s12_4 = s12_3 + s20 * 136657#64)
    (hs13_4 : s13_4 = s13_3 - s20 * 683901#64) (hs12_5 : s12_5 = s12_4 - s19 * 683901#64)
    (hs13_5 : s13_5 = s13_4 + carry12) (hs12_6 : s12_6 = s12_5 - carry12 <<< 21)
    (hs12_7 : s12_7 = s12_6 + carry11) (hs13_6 : s13_6 = s13_5 - carry13 <<< 21)
    (hs1_1 : s1_1 = s1 + s13_6 * 666643#64) (hs1_2 : s1_2 = s1_1 + s12_7 * 470296#64)
    (hs12_8 : s12_8 = 0#64) (hs1_3 : s1_3 = s1_2 + carry0) (hs1_4 : s1_4 = s1_3 - carry1 <<< 21)
    (hs12_9 : s12_9 = s12_8 + carry11_1) (hs1_5 : s1_5 = s1_4 + s12_9 * 470296#64)
    (hs12_10 : s12_10 = 0#64) (hs1_6 : s1_6 = s1_5 + carry0_1)
    (hs1_7 : s1_7 = s1_6 - carry1_1 <<< 21) (hs12_11 : s12_11 = s12_10 + carry11_2)
    (hs1_8 : s1_8 = s1_7 + s12_11 * 470296#64) (hs1_9 : s1_9 = s1_8 + carry0_2)
    (hs1_10 : s1_10 = s1_9 - carry1_2 <<< 21) : t2005 = s1_10 := by
  subst_vars
  grind

/-- `carry2_2` as the C computes it is the compiled `%2006`. -/
theorem sc25519_reduce.bridge_carry2_2
    (t1685 t1686 t1687 t1694 t1695 t1696 t1702 t1703 t1704 t1705 t1706 t1707 t1712 t1713 t1719 t1720
      t1721 t1722 t1723 t1724 t1767 t1768 t1769 t1770 t1771 t1772 t1773 t1777 t1778 t1793 t1798
      t1799 t1800 t1844 t1845 t1858 t1859 t1872 t1873 t1888 t1938 t1948 t1949 t1950 t1951 t1957
      t1993 t1994 t2004 t2006 t1987 t1932 t1797 t1676 t1650 t1683 t1680 t1775 t1604 t1672 t1646
      t1766 t1792 t1668 t1642 t1886 t1912 t1947 t1953 t2003 s12_1 s13_1 s14_1 s12_2 s13_2 s14_2
      s12_3 s13_3 s14_3 s12_4 s13_4 s12_5 s13_5 s12_6 s14_4 s12_7 s14_5 s13_6 s2_1 s2_2 s2_3 s12_8
      s2_4 s2_5 s12_9 s2_6 s12_10 s2_7 s2_8 s12_11 s2_9 s2_10 carry2_2 s2 s12 s13 s14 s19 s20 s21
      s22 s23 carry12 carry14 carry11 carry13 carry2 carry1 carry11_1 carry1_1 carry2_1 carry11_2
      carry1_2 : BitVec 64)
    (ht1685 : t1685 = t1683 * 470296#64) (ht1686 : t1686 = t1683 * 654183#64)
    (ht1687 : t1687 = t1683 * 18446744073708553811#64) (ht1694 : t1694 = t1680 * 654183#64)
    (ht1695 : t1695 = t1680 * 18446744073708553811#64) (ht1696 : t1696 = t1680 * 136657#64)
    (ht1702 : t1702 = t1676 * 18446744073708553811#64) (ht1703 : t1703 = t1676 * 136657#64)
    (ht1704 : t1704 = t1676 * 18446744073708867715#64) (ht1705 : t1705 = t1704 + t1650)
    (ht1706 : t1706 = t1705 + t1687) (ht1707 : t1707 = t1706 + t1696)
    (ht1712 : t1712 = t1672 * 136657#64) (ht1713 : t1713 = t1672 * 18446744073708867715#64)
    (ht1719 : t1719 = t1668 * 18446744073708867715#64) (ht1720 : t1720 = t1719 + t1642)
    (ht1721 : t1721 = t1720 + t1712) (ht1722 : t1722 = t1721 + t1702)
    (ht1723 : t1723 = t1722 + t1685) (ht1724 : t1724 = t1723 + t1694)
    (ht1767 : t1767 = t1713 + t1646) (ht1768 : t1768 = t1767 + t1703)
    (ht1769 : t1769 = t1768 + t1686) (ht1770 : t1770 = t1769 + t1695)
    (ht1771 : t1771 = t1770 + t1766) (ht1772 : t1772 = t1766 <<< 21)
    (ht1773 : t1773 = t1724 - t1772) (ht1777 : t1777 = t1775 <<< 21)
    (ht1778 : t1778 = t1707 - t1777) (ht1793 : t1793 = t1792 + t1773)
    (ht1798 : t1798 = t1797 + t1778) (ht1799 : t1799 = t1797 <<< 21)
    (ht1800 : t1800 = t1771 - t1799) (ht1844 : t1844 = t1798 * 666643#64)
    (ht1845 : t1845 = t1844 + t1604) (ht1858 : t1858 = t1800 * 470296#64)
    (ht1859 : t1859 = t1845 + t1858) (ht1872 : t1872 = t1793 * 654183#64)
    (ht1873 : t1873 = t1859 + t1872) (ht1888 : t1888 = t1886 <<< 21)
    (ht1938 : t1938 = t1932 * 654183#64) (ht1948 : t1948 = t1938 + t1873)
    (ht1949 : t1949 = t1948 - t1888) (ht1950 : t1950 = t1949 + t1912)
    (ht1951 : t1951 = t1950 + t1947) (ht1957 : t1957 = t1951 - t1953 <<< 21)
    (ht1993 : t1993 = t1987 * 654183#64) (ht1994 : t1994 = t1993 + t1957)
    (ht2004 : t2004 = t1994 + t2003) (ht2006 : t2006 = t2004.sshiftRight 21)
    (et1987 : t1987 = carry11_2) (et1932 : t1932 = carry11_1) (et1797 : t1797 = carry13)
    (et1676 : t1676 = s21) (et1650 : t1650 = s14) (et1683 : t1683 = s23) (et1680 : t1680 = s22)
    (et1775 : t1775 = carry14) (et1604 : t1604 = s2) (et1672 : t1672 = s20) (et1646 : t1646 = s13)
    (et1766 : t1766 = carry12) (et1792 : t1792 = carry11) (et1668 : t1668 = s19)
    (et1642 : t1642 = s12) (et1886 : t1886 = carry2) (et1912 : t1912 = carry1)
    (et1947 : t1947 = carry1_1) (et1953 : t1953 = carry2_1) (et2003 : t2003 = carry1_2)
    (hs12_1 : s12_1 = s12 + s23 * 470296#64) (hs13_1 : s13_1 = s13 + s23 * 654183#64)
    (hs14_1 : s14_1 = s14 - s23 * 997805#64) (hs12_2 : s12_2 = s12_1 + s22 * 654183#64)
    (hs13_2 : s13_2 = s13_1 - s22 * 997805#64) (hs14_2 : s14_2 = s14_1 + s22 * 136657#64)
    (hs12_3 : s12_3 = s12_2 - s21 * 997805#64) (hs13_3 : s13_3 = s13_2 + s21 * 136657#64)
    (hs14_3 : s14_3 = s14_2 - s21 * 683901#64) (hs12_4 : s12_4 = s12_3 + s20 * 136657#64)
    (hs13_4 : s13_4 = s13_3 - s20 * 683901#64) (hs12_5 : s12_5 = s12_4 - s19 * 683901#64)
    (hs13_5 : s13_5 = s13_4 + carry12) (hs12_6 : s12_6 = s12_5 - carry12 <<< 21)
    (hs14_4 : s14_4 = s14_3 - carry14 <<< 21) (hs12_7 : s12_7 = s12_6 + carry11)
    (hs14_5 : s14_5 = s14_4 + carry13) (hs13_6 : s13_6 = s13_5 - carry13 <<< 21)
    (hs2_1 : s2_1 = s2 + s14_5 * 666643#64) (hs2_2 : s2_2 = s2_1 + s13_6 * 470296#64)
    (hs2_3 : s2_3 = s2_2 + s12_7 * 654183#64) (hs12_8 : s12_8 = 0#64)
    (hs2_4 : s2_4 = s2_3 - carry2 <<< 21) (hs2_5 : s2_5 = s2_4 + carry1)
    (hs12_9 : s12_9 = s12_8 + carry11_1) (hs2_6 : s2_6 = s2_5 + s12_9 * 654183#64)
    (hs12_10 : s12_10 = 0#64) (hs2_7 : s2_7 = s2_6 + carry1_1)
    (hs2_8 : s2_8 = s2_7 - carry2_1 <<< 21) (hs12_11 : s12_11 = s12_10 + carry11_2)
    (hs2_9 : s2_9 = s2_8 + s12_11 * 654183#64) (hs2_10 : s2_10 = s2_9 + carry1_2)
    (hcarry2_2 : carry2_2 = s2_10.sshiftRight 21) : t2006 = carry2_2 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `s3_11` as the C computes it is the compiled `%2007`. -/
theorem sc25519_reduce.bridge_s3_11
    (t1685 t1686 t1687 t1688 t1689 t1694 t1695 t1696 t1697 t1698 t1702 t1703 t1704 t1705 t1706 t1707
      t1712 t1713 t1719 t1720 t1721 t1722 t1723 t1724 t1767 t1768 t1769 t1770 t1771 t1772 t1773
      t1776 t1777 t1778 t1793 t1798 t1799 t1800 t1804 t1805 t1828 t1829 t1846 t1847 t1860 t1861
      t1874 t1875 t1887 t1916 t1939 t1954 t1955 t1956 t1963 t1995 t1996 t2007 t1987 t1683 t1653
      t1680 t1775 t1802 t1608 t1797 t1676 t1650 t1672 t1646 t1766 t1792 t1668 t1642 t1886 t1932
      t1915 t1953 t1958 t2006 s12_1 s13_1 s14_1 s15_1 s12_2 s13_2 s14_2 s15_2 s12_3 s13_3 s14_3
      s12_4 s13_4 s12_5 s13_5 s12_6 s15_3 s14_4 s12_7 s14_5 s13_6 s15_4 s3_1 s3_2 s3_3 s3_4 s12_8
      s3_5 s3_6 s12_9 s3_7 s12_10 s3_8 s3_9 s12_11 s3_10 s3_11 s3 s12 s13 s14 s15 s19 s20 s21 s22
      s23 carry12 carry14 carry11 carry13 carry15 carry2 carry3 carry11_1 carry2_1 carry3_1
      carry11_2 carry2_2 : BitVec 64)
    (ht1685 : t1685 = t1683 * 470296#64) (ht1686 : t1686 = t1683 * 654183#64)
    (ht1687 : t1687 = t1683 * 18446744073708553811#64) (ht1688 : t1688 = t1683 * 136657#64)
    (ht1689 : t1689 = t1688 + t1653) (ht1694 : t1694 = t1680 * 654183#64)
    (ht1695 : t1695 = t1680 * 18446744073708553811#64) (ht1696 : t1696 = t1680 * 136657#64)
    (ht1697 : t1697 = t1680 * 18446744073708867715#64) (ht1698 : t1698 = t1689 + t1697)
    (ht1702 : t1702 = t1676 * 18446744073708553811#64) (ht1703 : t1703 = t1676 * 136657#64)
    (ht1704 : t1704 = t1676 * 18446744073708867715#64) (ht1705 : t1705 = t1704 + t1650)
    (ht1706 : t1706 = t1705 + t1687) (ht1707 : t1707 = t1706 + t1696)
    (ht1712 : t1712 = t1672 * 136657#64) (ht1713 : t1713 = t1672 * 18446744073708867715#64)
    (ht1719 : t1719 = t1668 * 18446744073708867715#64) (ht1720 : t1720 = t1719 + t1642)
    (ht1721 : t1721 = t1720 + t1712) (ht1722 : t1722 = t1721 + t1702)
    (ht1723 : t1723 = t1722 + t1685) (ht1724 : t1724 = t1723 + t1694)
    (ht1767 : t1767 = t1713 + t1646) (ht1768 : t1768 = t1767 + t1703)
    (ht1769 : t1769 = t1768 + t1686) (ht1770 : t1770 = t1769 + t1695)
    (ht1771 : t1771 = t1770 + t1766) (ht1772 : t1772 = t1766 <<< 21)
    (ht1773 : t1773 = t1724 - t1772) (ht1776 : t1776 = t1698 + t1775)
    (ht1777 : t1777 = t1775 <<< 21) (ht1778 : t1778 = t1707 - t1777)
    (ht1793 : t1793 = t1792 + t1773) (ht1798 : t1798 = t1797 + t1778)
    (ht1799 : t1799 = t1797 <<< 21) (ht1800 : t1800 = t1771 - t1799) (ht1804 : t1804 = t1802 <<< 21)
    (ht1805 : t1805 = t1776 - t1804) (ht1828 : t1828 = t1805 * 666643#64)
    (ht1829 : t1829 = t1828 + t1608) (ht1846 : t1846 = t1798 * 470296#64)
    (ht1847 : t1847 = t1829 + t1846) (ht1860 : t1860 = t1800 * 654183#64)
    (ht1861 : t1861 = t1847 + t1860) (ht1874 : t1874 = t1793 * 18446744073708553811#64)
    (ht1875 : t1875 = t1861 + t1874) (ht1887 : t1887 = t1875 + t1886)
    (ht1916 : t1916 = t1915 <<< 21) (ht1939 : t1939 = t1932 * 18446744073708553811#64)
    (ht1954 : t1954 = t1887 + t1939) (ht1955 : t1955 = t1954 - t1916)
    (ht1956 : t1956 = t1955 + t1953) (ht1963 : t1963 = t1956 - t1958 <<< 21)
    (ht1995 : t1995 = t1987 * 18446744073708553811#64) (ht1996 : t1996 = t1995 + t1963)
    (ht2007 : t2007 = t1996 + t2006) (et1987 : t1987 = carry11_2) (et1683 : t1683 = s23)
    (et1653 : t1653 = s15) (et1680 : t1680 = s22) (et1775 : t1775 = carry14)
    (et1802 : t1802 = carry15) (et1608 : t1608 = s3) (et1797 : t1797 = carry13)
    (et1676 : t1676 = s21) (et1650 : t1650 = s14) (et1672 : t1672 = s20) (et1646 : t1646 = s13)
    (et1766 : t1766 = carry12) (et1792 : t1792 = carry11) (et1668 : t1668 = s19)
    (et1642 : t1642 = s12) (et1886 : t1886 = carry2) (et1932 : t1932 = carry11_1)
    (et1915 : t1915 = carry3) (et1953 : t1953 = carry2_1) (et1958 : t1958 = carry3_1)
    (et2006 : t2006 = carry2_2) (hs12_1 : s12_1 = s12 + s23 * 470296#64)
    (hs13_1 : s13_1 = s13 + s23 * 654183#64) (hs14_1 : s14_1 = s14 - s23 * 997805#64)
    (hs15_1 : s15_1 = s15 + s23 * 136657#64) (hs12_2 : s12_2 = s12_1 + s22 * 654183#64)
    (hs13_2 : s13_2 = s13_1 - s22 * 997805#64) (hs14_2 : s14_2 = s14_1 + s22 * 136657#64)
    (hs15_2 : s15_2 = s15_1 - s22 * 683901#64) (hs12_3 : s12_3 = s12_2 - s21 * 997805#64)
    (hs13_3 : s13_3 = s13_2 + s21 * 136657#64) (hs14_3 : s14_3 = s14_2 - s21 * 683901#64)
    (hs12_4 : s12_4 = s12_3 + s20 * 136657#64) (hs13_4 : s13_4 = s13_3 - s20 * 683901#64)
    (hs12_5 : s12_5 = s12_4 - s19 * 683901#64) (hs13_5 : s13_5 = s13_4 + carry12)
    (hs12_6 : s12_6 = s12_5 - carry12 <<< 21) (hs15_3 : s15_3 = s15_2 + carry14)
    (hs14_4 : s14_4 = s14_3 - carry14 <<< 21) (hs12_7 : s12_7 = s12_6 + carry11)
    (hs14_5 : s14_5 = s14_4 + carry13) (hs13_6 : s13_6 = s13_5 - carry13 <<< 21)
    (hs15_4 : s15_4 = s15_3 - carry15 <<< 21) (hs3_1 : s3_1 = s3 + s15_4 * 666643#64)
    (hs3_2 : s3_2 = s3_1 + s14_5 * 470296#64) (hs3_3 : s3_3 = s3_2 + s13_6 * 654183#64)
    (hs3_4 : s3_4 = s3_3 - s12_7 * 997805#64) (hs12_8 : s12_8 = 0#64) (hs3_5 : s3_5 = s3_4 + carry2)
    (hs3_6 : s3_6 = s3_5 - carry3 <<< 21) (hs12_9 : s12_9 = s12_8 + carry11_1)
    (hs3_7 : s3_7 = s3_6 - s12_9 * 997805#64) (hs12_10 : s12_10 = 0#64)
    (hs3_8 : s3_8 = s3_7 + carry2_1) (hs3_9 : s3_9 = s3_8 - carry3_1 <<< 21)
    (hs12_11 : s12_11 = s12_10 + carry11_2) (hs3_10 : s3_10 = s3_9 - s12_11 * 997805#64)
    (hs3_11 : s3_11 = s3_10 + carry2_2) : t2007 = s3_11 := by
  subst_vars
  grind

/-- `s2_11` as the C computes it is the compiled `%2008`. -/
theorem sc25519_reduce.bridge_s2_11
    (t1685 t1686 t1687 t1694 t1695 t1696 t1702 t1703 t1704 t1705 t1706 t1707 t1712 t1713 t1719 t1720
      t1721 t1722 t1723 t1724 t1767 t1768 t1769 t1770 t1771 t1772 t1773 t1777 t1778 t1793 t1798
      t1799 t1800 t1844 t1845 t1858 t1859 t1872 t1873 t1888 t1938 t1948 t1949 t1950 t1951 t1957
      t1993 t1994 t2004 t2008 t1987 t1932 t1797 t1676 t1650 t1683 t1680 t1775 t1604 t1672 t1646
      t1766 t1792 t1668 t1642 t1886 t1912 t1947 t1953 t2003 t2006 s12_1 s13_1 s14_1 s12_2 s13_2
      s14_2 s12_3 s13_3 s14_3 s12_4 s13_4 s12_5 s13_5 s12_6 s14_4 s12_7 s14_5 s13_6 s2_1 s2_2 s2_3
      s12_8 s2_4 s2_5 s12_9 s2_6 s12_10 s2_7 s2_8 s12_11 s2_9 s2_10 s2_11 s2 s12 s13 s14 s19 s20 s21
      s22 s23 carry12 carry14 carry11 carry13 carry2 carry1 carry11_1 carry1_1 carry2_1 carry11_2
      carry1_2 carry2_2 : BitVec 64)
    (ht1685 : t1685 = t1683 * 470296#64) (ht1686 : t1686 = t1683 * 654183#64)
    (ht1687 : t1687 = t1683 * 18446744073708553811#64) (ht1694 : t1694 = t1680 * 654183#64)
    (ht1695 : t1695 = t1680 * 18446744073708553811#64) (ht1696 : t1696 = t1680 * 136657#64)
    (ht1702 : t1702 = t1676 * 18446744073708553811#64) (ht1703 : t1703 = t1676 * 136657#64)
    (ht1704 : t1704 = t1676 * 18446744073708867715#64) (ht1705 : t1705 = t1704 + t1650)
    (ht1706 : t1706 = t1705 + t1687) (ht1707 : t1707 = t1706 + t1696)
    (ht1712 : t1712 = t1672 * 136657#64) (ht1713 : t1713 = t1672 * 18446744073708867715#64)
    (ht1719 : t1719 = t1668 * 18446744073708867715#64) (ht1720 : t1720 = t1719 + t1642)
    (ht1721 : t1721 = t1720 + t1712) (ht1722 : t1722 = t1721 + t1702)
    (ht1723 : t1723 = t1722 + t1685) (ht1724 : t1724 = t1723 + t1694)
    (ht1767 : t1767 = t1713 + t1646) (ht1768 : t1768 = t1767 + t1703)
    (ht1769 : t1769 = t1768 + t1686) (ht1770 : t1770 = t1769 + t1695)
    (ht1771 : t1771 = t1770 + t1766) (ht1772 : t1772 = t1766 <<< 21)
    (ht1773 : t1773 = t1724 - t1772) (ht1777 : t1777 = t1775 <<< 21)
    (ht1778 : t1778 = t1707 - t1777) (ht1793 : t1793 = t1792 + t1773)
    (ht1798 : t1798 = t1797 + t1778) (ht1799 : t1799 = t1797 <<< 21)
    (ht1800 : t1800 = t1771 - t1799) (ht1844 : t1844 = t1798 * 666643#64)
    (ht1845 : t1845 = t1844 + t1604) (ht1858 : t1858 = t1800 * 470296#64)
    (ht1859 : t1859 = t1845 + t1858) (ht1872 : t1872 = t1793 * 654183#64)
    (ht1873 : t1873 = t1859 + t1872) (ht1888 : t1888 = t1886 <<< 21)
    (ht1938 : t1938 = t1932 * 654183#64) (ht1948 : t1948 = t1938 + t1873)
    (ht1949 : t1949 = t1948 - t1888) (ht1950 : t1950 = t1949 + t1912)
    (ht1951 : t1951 = t1950 + t1947) (ht1957 : t1957 = t1951 - t1953 <<< 21)
    (ht1993 : t1993 = t1987 * 654183#64) (ht1994 : t1994 = t1993 + t1957)
    (ht2004 : t2004 = t1994 + t2003) (ht2008 : t2008 = t2004 - t2006 <<< 21)
    (et1987 : t1987 = carry11_2) (et1932 : t1932 = carry11_1) (et1797 : t1797 = carry13)
    (et1676 : t1676 = s21) (et1650 : t1650 = s14) (et1683 : t1683 = s23) (et1680 : t1680 = s22)
    (et1775 : t1775 = carry14) (et1604 : t1604 = s2) (et1672 : t1672 = s20) (et1646 : t1646 = s13)
    (et1766 : t1766 = carry12) (et1792 : t1792 = carry11) (et1668 : t1668 = s19)
    (et1642 : t1642 = s12) (et1886 : t1886 = carry2) (et1912 : t1912 = carry1)
    (et1947 : t1947 = carry1_1) (et1953 : t1953 = carry2_1) (et2003 : t2003 = carry1_2)
    (et2006 : t2006 = carry2_2) (hs12_1 : s12_1 = s12 + s23 * 470296#64)
    (hs13_1 : s13_1 = s13 + s23 * 654183#64) (hs14_1 : s14_1 = s14 - s23 * 997805#64)
    (hs12_2 : s12_2 = s12_1 + s22 * 654183#64) (hs13_2 : s13_2 = s13_1 - s22 * 997805#64)
    (hs14_2 : s14_2 = s14_1 + s22 * 136657#64) (hs12_3 : s12_3 = s12_2 - s21 * 997805#64)
    (hs13_3 : s13_3 = s13_2 + s21 * 136657#64) (hs14_3 : s14_3 = s14_2 - s21 * 683901#64)
    (hs12_4 : s12_4 = s12_3 + s20 * 136657#64) (hs13_4 : s13_4 = s13_3 - s20 * 683901#64)
    (hs12_5 : s12_5 = s12_4 - s19 * 683901#64) (hs13_5 : s13_5 = s13_4 + carry12)
    (hs12_6 : s12_6 = s12_5 - carry12 <<< 21) (hs14_4 : s14_4 = s14_3 - carry14 <<< 21)
    (hs12_7 : s12_7 = s12_6 + carry11) (hs14_5 : s14_5 = s14_4 + carry13)
    (hs13_6 : s13_6 = s13_5 - carry13 <<< 21) (hs2_1 : s2_1 = s2 + s14_5 * 666643#64)
    (hs2_2 : s2_2 = s2_1 + s13_6 * 470296#64) (hs2_3 : s2_3 = s2_2 + s12_7 * 654183#64)
    (hs12_8 : s12_8 = 0#64) (hs2_4 : s2_4 = s2_3 - carry2 <<< 21) (hs2_5 : s2_5 = s2_4 + carry1)
    (hs12_9 : s12_9 = s12_8 + carry11_1) (hs2_6 : s2_6 = s2_5 + s12_9 * 654183#64)
    (hs12_10 : s12_10 = 0#64) (hs2_7 : s2_7 = s2_6 + carry1_1)
    (hs2_8 : s2_8 = s2_7 - carry2_1 <<< 21) (hs12_11 : s12_11 = s12_10 + carry11_2)
    (hs2_9 : s2_9 = s2_8 + s12_11 * 654183#64) (hs2_10 : s2_10 = s2_9 + carry1_2)
    (hs2_11 : s2_11 = s2_10 - carry2_2 <<< 21) : t2008 = s2_11 := by
  subst_vars
  grind

/-- `carry3_2` as the C computes it is the compiled `%2009`. -/
theorem sc25519_reduce.bridge_carry3_2
    (t1685 t1686 t1687 t1688 t1689 t1694 t1695 t1696 t1697 t1698 t1702 t1703 t1704 t1705 t1706 t1707
      t1712 t1713 t1719 t1720 t1721 t1722 t1723 t1724 t1767 t1768 t1769 t1770 t1771 t1772 t1773
      t1776 t1777 t1778 t1793 t1798 t1799 t1800 t1804 t1805 t1828 t1829 t1846 t1847 t1860 t1861
      t1874 t1875 t1887 t1916 t1939 t1954 t1955 t1956 t1963 t1995 t1996 t2007 t2009 t1987 t1683
      t1653 t1680 t1775 t1802 t1608 t1797 t1676 t1650 t1672 t1646 t1766 t1792 t1668 t1642 t1886
      t1932 t1915 t1953 t1958 t2006 s12_1 s13_1 s14_1 s15_1 s12_2 s13_2 s14_2 s15_2 s12_3 s13_3
      s14_3 s12_4 s13_4 s12_5 s13_5 s12_6 s15_3 s14_4 s12_7 s14_5 s13_6 s15_4 s3_1 s3_2 s3_3 s3_4
      s12_8 s3_5 s3_6 s12_9 s3_7 s12_10 s3_8 s3_9 s12_11 s3_10 s3_11 carry3_2 s3 s12 s13 s14 s15 s19
      s20 s21 s22 s23 carry12 carry14 carry11 carry13 carry15 carry2 carry3 carry11_1 carry2_1
      carry3_1 carry11_2 carry2_2 : BitVec 64)
    (ht1685 : t1685 = t1683 * 470296#64) (ht1686 : t1686 = t1683 * 654183#64)
    (ht1687 : t1687 = t1683 * 18446744073708553811#64) (ht1688 : t1688 = t1683 * 136657#64)
    (ht1689 : t1689 = t1688 + t1653) (ht1694 : t1694 = t1680 * 654183#64)
    (ht1695 : t1695 = t1680 * 18446744073708553811#64) (ht1696 : t1696 = t1680 * 136657#64)
    (ht1697 : t1697 = t1680 * 18446744073708867715#64) (ht1698 : t1698 = t1689 + t1697)
    (ht1702 : t1702 = t1676 * 18446744073708553811#64) (ht1703 : t1703 = t1676 * 136657#64)
    (ht1704 : t1704 = t1676 * 18446744073708867715#64) (ht1705 : t1705 = t1704 + t1650)
    (ht1706 : t1706 = t1705 + t1687) (ht1707 : t1707 = t1706 + t1696)
    (ht1712 : t1712 = t1672 * 136657#64) (ht1713 : t1713 = t1672 * 18446744073708867715#64)
    (ht1719 : t1719 = t1668 * 18446744073708867715#64) (ht1720 : t1720 = t1719 + t1642)
    (ht1721 : t1721 = t1720 + t1712) (ht1722 : t1722 = t1721 + t1702)
    (ht1723 : t1723 = t1722 + t1685) (ht1724 : t1724 = t1723 + t1694)
    (ht1767 : t1767 = t1713 + t1646) (ht1768 : t1768 = t1767 + t1703)
    (ht1769 : t1769 = t1768 + t1686) (ht1770 : t1770 = t1769 + t1695)
    (ht1771 : t1771 = t1770 + t1766) (ht1772 : t1772 = t1766 <<< 21)
    (ht1773 : t1773 = t1724 - t1772) (ht1776 : t1776 = t1698 + t1775)
    (ht1777 : t1777 = t1775 <<< 21) (ht1778 : t1778 = t1707 - t1777)
    (ht1793 : t1793 = t1792 + t1773) (ht1798 : t1798 = t1797 + t1778)
    (ht1799 : t1799 = t1797 <<< 21) (ht1800 : t1800 = t1771 - t1799) (ht1804 : t1804 = t1802 <<< 21)
    (ht1805 : t1805 = t1776 - t1804) (ht1828 : t1828 = t1805 * 666643#64)
    (ht1829 : t1829 = t1828 + t1608) (ht1846 : t1846 = t1798 * 470296#64)
    (ht1847 : t1847 = t1829 + t1846) (ht1860 : t1860 = t1800 * 654183#64)
    (ht1861 : t1861 = t1847 + t1860) (ht1874 : t1874 = t1793 * 18446744073708553811#64)
    (ht1875 : t1875 = t1861 + t1874) (ht1887 : t1887 = t1875 + t1886)
    (ht1916 : t1916 = t1915 <<< 21) (ht1939 : t1939 = t1932 * 18446744073708553811#64)
    (ht1954 : t1954 = t1887 + t1939) (ht1955 : t1955 = t1954 - t1916)
    (ht1956 : t1956 = t1955 + t1953) (ht1963 : t1963 = t1956 - t1958 <<< 21)
    (ht1995 : t1995 = t1987 * 18446744073708553811#64) (ht1996 : t1996 = t1995 + t1963)
    (ht2007 : t2007 = t1996 + t2006) (ht2009 : t2009 = t2007.sshiftRight 21)
    (et1987 : t1987 = carry11_2) (et1683 : t1683 = s23) (et1653 : t1653 = s15)
    (et1680 : t1680 = s22) (et1775 : t1775 = carry14) (et1802 : t1802 = carry15)
    (et1608 : t1608 = s3) (et1797 : t1797 = carry13) (et1676 : t1676 = s21) (et1650 : t1650 = s14)
    (et1672 : t1672 = s20) (et1646 : t1646 = s13) (et1766 : t1766 = carry12)
    (et1792 : t1792 = carry11) (et1668 : t1668 = s19) (et1642 : t1642 = s12)
    (et1886 : t1886 = carry2) (et1932 : t1932 = carry11_1) (et1915 : t1915 = carry3)
    (et1953 : t1953 = carry2_1) (et1958 : t1958 = carry3_1) (et2006 : t2006 = carry2_2)
    (hs12_1 : s12_1 = s12 + s23 * 470296#64) (hs13_1 : s13_1 = s13 + s23 * 654183#64)
    (hs14_1 : s14_1 = s14 - s23 * 997805#64) (hs15_1 : s15_1 = s15 + s23 * 136657#64)
    (hs12_2 : s12_2 = s12_1 + s22 * 654183#64) (hs13_2 : s13_2 = s13_1 - s22 * 997805#64)
    (hs14_2 : s14_2 = s14_1 + s22 * 136657#64) (hs15_2 : s15_2 = s15_1 - s22 * 683901#64)
    (hs12_3 : s12_3 = s12_2 - s21 * 997805#64) (hs13_3 : s13_3 = s13_2 + s21 * 136657#64)
    (hs14_3 : s14_3 = s14_2 - s21 * 683901#64) (hs12_4 : s12_4 = s12_3 + s20 * 136657#64)
    (hs13_4 : s13_4 = s13_3 - s20 * 683901#64) (hs12_5 : s12_5 = s12_4 - s19 * 683901#64)
    (hs13_5 : s13_5 = s13_4 + carry12) (hs12_6 : s12_6 = s12_5 - carry12 <<< 21)
    (hs15_3 : s15_3 = s15_2 + carry14) (hs14_4 : s14_4 = s14_3 - carry14 <<< 21)
    (hs12_7 : s12_7 = s12_6 + carry11) (hs14_5 : s14_5 = s14_4 + carry13)
    (hs13_6 : s13_6 = s13_5 - carry13 <<< 21) (hs15_4 : s15_4 = s15_3 - carry15 <<< 21)
    (hs3_1 : s3_1 = s3 + s15_4 * 666643#64) (hs3_2 : s3_2 = s3_1 + s14_5 * 470296#64)
    (hs3_3 : s3_3 = s3_2 + s13_6 * 654183#64) (hs3_4 : s3_4 = s3_3 - s12_7 * 997805#64)
    (hs12_8 : s12_8 = 0#64) (hs3_5 : s3_5 = s3_4 + carry2) (hs3_6 : s3_6 = s3_5 - carry3 <<< 21)
    (hs12_9 : s12_9 = s12_8 + carry11_1) (hs3_7 : s3_7 = s3_6 - s12_9 * 997805#64)
    (hs12_10 : s12_10 = 0#64) (hs3_8 : s3_8 = s3_7 + carry2_1)
    (hs3_9 : s3_9 = s3_8 - carry3_1 <<< 21) (hs12_11 : s12_11 = s12_10 + carry11_2)
    (hs3_10 : s3_10 = s3_9 - s12_11 * 997805#64) (hs3_11 : s3_11 = s3_10 + carry2_2)
    (hcarry3_2 : carry3_2 = s3_11.sshiftRight 21) : t2009 = carry3_2 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `s4_12` as the C computes it is the compiled `%2010`. -/
theorem sc25519_reduce.bridge_s4_12
    (t1685 t1686 t1687 t1688 t1689 t1690 t1691 t1694 t1695 t1696 t1697 t1698 t1702 t1703 t1704 t1705
      t1706 t1707 t1712 t1713 t1719 t1720 t1721 t1722 t1723 t1724 t1767 t1768 t1769 t1770 t1771
      t1772 t1773 t1776 t1777 t1778 t1782 t1783 t1793 t1798 t1799 t1800 t1803 t1804 t1805 t1818
      t1819 t1830 t1831 t1848 t1849 t1862 t1863 t1876 t1877 t1892 t1940 t1959 t1960 t1961 t1962
      t1968 t1997 t1998 t2010 t1987 t1932 t1802 t1683 t1656 t1780 t1612 t1653 t1680 t1775 t1797
      t1676 t1650 t1672 t1646 t1766 t1792 t1668 t1642 t1890 t1915 t1958 t1964 t2009 s12_1 s13_1
      s14_1 s15_1 s16_1 s12_2 s13_2 s14_2 s15_2 s12_3 s13_3 s14_3 s12_4 s13_4 s12_5 s13_5 s12_6
      s15_3 s14_4 s16_2 s12_7 s14_5 s13_6 s16_3 s15_4 s4_1 s4_2 s4_3 s4_4 s4_5 s12_8 s4_6 s4_7 s12_9
      s4_8 s12_10 s4_9 s4_10 s12_11 s4_11 s4_12 s4 s12 s13 s14 s15 s16 s19 s20 s21 s22 s23 carry12
      carry14 carry16 carry11 carry13 carry15 carry4 carry3 carry11_1 carry3_1 carry4_1 carry11_2
      carry3_2 : BitVec 64)
    (ht1685 : t1685 = t1683 * 470296#64) (ht1686 : t1686 = t1683 * 654183#64)
    (ht1687 : t1687 = t1683 * 18446744073708553811#64) (ht1688 : t1688 = t1683 * 136657#64)
    (ht1689 : t1689 = t1688 + t1653) (ht1690 : t1690 = t1683 * 18446744073708867715#64)
    (ht1691 : t1691 = t1690 + t1656) (ht1694 : t1694 = t1680 * 654183#64)
    (ht1695 : t1695 = t1680 * 18446744073708553811#64) (ht1696 : t1696 = t1680 * 136657#64)
    (ht1697 : t1697 = t1680 * 18446744073708867715#64) (ht1698 : t1698 = t1689 + t1697)
    (ht1702 : t1702 = t1676 * 18446744073708553811#64) (ht1703 : t1703 = t1676 * 136657#64)
    (ht1704 : t1704 = t1676 * 18446744073708867715#64) (ht1705 : t1705 = t1704 + t1650)
    (ht1706 : t1706 = t1705 + t1687) (ht1707 : t1707 = t1706 + t1696)
    (ht1712 : t1712 = t1672 * 136657#64) (ht1713 : t1713 = t1672 * 18446744073708867715#64)
    (ht1719 : t1719 = t1668 * 18446744073708867715#64) (ht1720 : t1720 = t1719 + t1642)
    (ht1721 : t1721 = t1720 + t1712) (ht1722 : t1722 = t1721 + t1702)
    (ht1723 : t1723 = t1722 + t1685) (ht1724 : t1724 = t1723 + t1694)
    (ht1767 : t1767 = t1713 + t1646) (ht1768 : t1768 = t1767 + t1703)
    (ht1769 : t1769 = t1768 + t1686) (ht1770 : t1770 = t1769 + t1695)
    (ht1771 : t1771 = t1770 + t1766) (ht1772 : t1772 = t1766 <<< 21)
    (ht1773 : t1773 = t1724 - t1772) (ht1776 : t1776 = t1698 + t1775)
    (ht1777 : t1777 = t1775 <<< 21) (ht1778 : t1778 = t1707 - t1777) (ht1782 : t1782 = t1780 <<< 21)
    (ht1783 : t1783 = t1691 - t1782) (ht1793 : t1793 = t1792 + t1773)
    (ht1798 : t1798 = t1797 + t1778) (ht1799 : t1799 = t1797 <<< 21)
    (ht1800 : t1800 = t1771 - t1799) (ht1803 : t1803 = t1802 + t1783)
    (ht1804 : t1804 = t1802 <<< 21) (ht1805 : t1805 = t1776 - t1804)
    (ht1818 : t1818 = t1803 * 666643#64) (ht1819 : t1819 = t1818 + t1612)
    (ht1830 : t1830 = t1805 * 470296#64) (ht1831 : t1831 = t1819 + t1830)
    (ht1848 : t1848 = t1798 * 654183#64) (ht1849 : t1849 = t1831 + t1848)
    (ht1862 : t1862 = t1800 * 18446744073708553811#64) (ht1863 : t1863 = t1849 + t1862)
    (ht1876 : t1876 = t1793 * 136657#64) (ht1877 : t1877 = t1863 + t1876)
    (ht1892 : t1892 = t1890 <<< 21) (ht1940 : t1940 = t1932 * 136657#64)
    (ht1959 : t1959 = t1940 + t1877) (ht1960 : t1960 = t1959 - t1892)
    (ht1961 : t1961 = t1960 + t1915) (ht1962 : t1962 = t1961 + t1958)
    (ht1968 : t1968 = t1962 - t1964 <<< 21) (ht1997 : t1997 = t1987 * 136657#64)
    (ht1998 : t1998 = t1997 + t1968) (ht2010 : t2010 = t1998 + t2009) (et1987 : t1987 = carry11_2)
    (et1932 : t1932 = carry11_1) (et1802 : t1802 = carry15) (et1683 : t1683 = s23)
    (et1656 : t1656 = s16) (et1780 : t1780 = carry16) (et1612 : t1612 = s4) (et1653 : t1653 = s15)
    (et1680 : t1680 = s22) (et1775 : t1775 = carry14) (et1797 : t1797 = carry13)
    (et1676 : t1676 = s21) (et1650 : t1650 = s14) (et1672 : t1672 = s20) (et1646 : t1646 = s13)
    (et1766 : t1766 = carry12) (et1792 : t1792 = carry11) (et1668 : t1668 = s19)
    (et1642 : t1642 = s12) (et1890 : t1890 = carry4) (et1915 : t1915 = carry3)
    (et1958 : t1958 = carry3_1) (et1964 : t1964 = carry4_1) (et2009 : t2009 = carry3_2)
    (hs12_1 : s12_1 = s12 + s23 * 470296#64) (hs13_1 : s13_1 = s13 + s23 * 654183#64)
    (hs14_1 : s14_1 = s14 - s23 * 997805#64) (hs15_1 : s15_1 = s15 + s23 * 136657#64)
    (hs16_1 : s16_1 = s16 - s23 * 683901#64) (hs12_2 : s12_2 = s12_1 + s22 * 654183#64)
    (hs13_2 : s13_2 = s13_1 - s22 * 997805#64) (hs14_2 : s14_2 = s14_1 + s22 * 136657#64)
    (hs15_2 : s15_2 = s15_1 - s22 * 683901#64) (hs12_3 : s12_3 = s12_2 - s21 * 997805#64)
    (hs13_3 : s13_3 = s13_2 + s21 * 136657#64) (hs14_3 : s14_3 = s14_2 - s21 * 683901#64)
    (hs12_4 : s12_4 = s12_3 + s20 * 136657#64) (hs13_4 : s13_4 = s13_3 - s20 * 683901#64)
    (hs12_5 : s12_5 = s12_4 - s19 * 683901#64) (hs13_5 : s13_5 = s13_4 + carry12)
    (hs12_6 : s12_6 = s12_5 - carry12 <<< 21) (hs15_3 : s15_3 = s15_2 + carry14)
    (hs14_4 : s14_4 = s14_3 - carry14 <<< 21) (hs16_2 : s16_2 = s16_1 - carry16 <<< 21)
    (hs12_7 : s12_7 = s12_6 + carry11) (hs14_5 : s14_5 = s14_4 + carry13)
    (hs13_6 : s13_6 = s13_5 - carry13 <<< 21) (hs16_3 : s16_3 = s16_2 + carry15)
    (hs15_4 : s15_4 = s15_3 - carry15 <<< 21) (hs4_1 : s4_1 = s4 + s16_3 * 666643#64)
    (hs4_2 : s4_2 = s4_1 + s15_4 * 470296#64) (hs4_3 : s4_3 = s4_2 + s14_5 * 654183#64)
    (hs4_4 : s4_4 = s4_3 - s13_6 * 997805#64) (hs4_5 : s4_5 = s4_4 + s12_7 * 136657#64)
    (hs12_8 : s12_8 = 0#64) (hs4_6 : s4_6 = s4_5 - carry4 <<< 21) (hs4_7 : s4_7 = s4_6 + carry3)
    (hs12_9 : s12_9 = s12_8 + carry11_1) (hs4_8 : s4_8 = s4_7 + s12_9 * 136657#64)
    (hs12_10 : s12_10 = 0#64) (hs4_9 : s4_9 = s4_8 + carry3_1)
    (hs4_10 : s4_10 = s4_9 - carry4_1 <<< 21) (hs12_11 : s12_11 = s12_10 + carry11_2)
    (hs4_11 : s4_11 = s4_10 + s12_11 * 136657#64) (hs4_12 : s4_12 = s4_11 + carry3_2) :
    t2010 = s4_12 := by
  subst_vars
  grind

/-- `s3_12` as the C computes it is the compiled `%2011`. -/
theorem sc25519_reduce.bridge_s3_12
    (t1685 t1686 t1687 t1688 t1689 t1694 t1695 t1696 t1697 t1698 t1702 t1703 t1704 t1705 t1706 t1707
      t1712 t1713 t1719 t1720 t1721 t1722 t1723 t1724 t1767 t1768 t1769 t1770 t1771 t1772 t1773
      t1776 t1777 t1778 t1793 t1798 t1799 t1800 t1804 t1805 t1828 t1829 t1846 t1847 t1860 t1861
      t1874 t1875 t1887 t1916 t1939 t1954 t1955 t1956 t1963 t1995 t1996 t2007 t2011 t1987 t1683
      t1653 t1680 t1775 t1802 t1608 t1797 t1676 t1650 t1672 t1646 t1766 t1792 t1668 t1642 t1886
      t1932 t1915 t1953 t1958 t2006 t2009 s12_1 s13_1 s14_1 s15_1 s12_2 s13_2 s14_2 s15_2 s12_3
      s13_3 s14_3 s12_4 s13_4 s12_5 s13_5 s12_6 s15_3 s14_4 s12_7 s14_5 s13_6 s15_4 s3_1 s3_2 s3_3
      s3_4 s12_8 s3_5 s3_6 s12_9 s3_7 s12_10 s3_8 s3_9 s12_11 s3_10 s3_11 s3_12 s3 s12 s13 s14 s15
      s19 s20 s21 s22 s23 carry12 carry14 carry11 carry13 carry15 carry2 carry3 carry11_1 carry2_1
      carry3_1 carry11_2 carry2_2 carry3_2 : BitVec 64)
    (ht1685 : t1685 = t1683 * 470296#64) (ht1686 : t1686 = t1683 * 654183#64)
    (ht1687 : t1687 = t1683 * 18446744073708553811#64) (ht1688 : t1688 = t1683 * 136657#64)
    (ht1689 : t1689 = t1688 + t1653) (ht1694 : t1694 = t1680 * 654183#64)
    (ht1695 : t1695 = t1680 * 18446744073708553811#64) (ht1696 : t1696 = t1680 * 136657#64)
    (ht1697 : t1697 = t1680 * 18446744073708867715#64) (ht1698 : t1698 = t1689 + t1697)
    (ht1702 : t1702 = t1676 * 18446744073708553811#64) (ht1703 : t1703 = t1676 * 136657#64)
    (ht1704 : t1704 = t1676 * 18446744073708867715#64) (ht1705 : t1705 = t1704 + t1650)
    (ht1706 : t1706 = t1705 + t1687) (ht1707 : t1707 = t1706 + t1696)
    (ht1712 : t1712 = t1672 * 136657#64) (ht1713 : t1713 = t1672 * 18446744073708867715#64)
    (ht1719 : t1719 = t1668 * 18446744073708867715#64) (ht1720 : t1720 = t1719 + t1642)
    (ht1721 : t1721 = t1720 + t1712) (ht1722 : t1722 = t1721 + t1702)
    (ht1723 : t1723 = t1722 + t1685) (ht1724 : t1724 = t1723 + t1694)
    (ht1767 : t1767 = t1713 + t1646) (ht1768 : t1768 = t1767 + t1703)
    (ht1769 : t1769 = t1768 + t1686) (ht1770 : t1770 = t1769 + t1695)
    (ht1771 : t1771 = t1770 + t1766) (ht1772 : t1772 = t1766 <<< 21)
    (ht1773 : t1773 = t1724 - t1772) (ht1776 : t1776 = t1698 + t1775)
    (ht1777 : t1777 = t1775 <<< 21) (ht1778 : t1778 = t1707 - t1777)
    (ht1793 : t1793 = t1792 + t1773) (ht1798 : t1798 = t1797 + t1778)
    (ht1799 : t1799 = t1797 <<< 21) (ht1800 : t1800 = t1771 - t1799) (ht1804 : t1804 = t1802 <<< 21)
    (ht1805 : t1805 = t1776 - t1804) (ht1828 : t1828 = t1805 * 666643#64)
    (ht1829 : t1829 = t1828 + t1608) (ht1846 : t1846 = t1798 * 470296#64)
    (ht1847 : t1847 = t1829 + t1846) (ht1860 : t1860 = t1800 * 654183#64)
    (ht1861 : t1861 = t1847 + t1860) (ht1874 : t1874 = t1793 * 18446744073708553811#64)
    (ht1875 : t1875 = t1861 + t1874) (ht1887 : t1887 = t1875 + t1886)
    (ht1916 : t1916 = t1915 <<< 21) (ht1939 : t1939 = t1932 * 18446744073708553811#64)
    (ht1954 : t1954 = t1887 + t1939) (ht1955 : t1955 = t1954 - t1916)
    (ht1956 : t1956 = t1955 + t1953) (ht1963 : t1963 = t1956 - t1958 <<< 21)
    (ht1995 : t1995 = t1987 * 18446744073708553811#64) (ht1996 : t1996 = t1995 + t1963)
    (ht2007 : t2007 = t1996 + t2006) (ht2011 : t2011 = t2007 - t2009 <<< 21)
    (et1987 : t1987 = carry11_2) (et1683 : t1683 = s23) (et1653 : t1653 = s15)
    (et1680 : t1680 = s22) (et1775 : t1775 = carry14) (et1802 : t1802 = carry15)
    (et1608 : t1608 = s3) (et1797 : t1797 = carry13) (et1676 : t1676 = s21) (et1650 : t1650 = s14)
    (et1672 : t1672 = s20) (et1646 : t1646 = s13) (et1766 : t1766 = carry12)
    (et1792 : t1792 = carry11) (et1668 : t1668 = s19) (et1642 : t1642 = s12)
    (et1886 : t1886 = carry2) (et1932 : t1932 = carry11_1) (et1915 : t1915 = carry3)
    (et1953 : t1953 = carry2_1) (et1958 : t1958 = carry3_1) (et2006 : t2006 = carry2_2)
    (et2009 : t2009 = carry3_2) (hs12_1 : s12_1 = s12 + s23 * 470296#64)
    (hs13_1 : s13_1 = s13 + s23 * 654183#64) (hs14_1 : s14_1 = s14 - s23 * 997805#64)
    (hs15_1 : s15_1 = s15 + s23 * 136657#64) (hs12_2 : s12_2 = s12_1 + s22 * 654183#64)
    (hs13_2 : s13_2 = s13_1 - s22 * 997805#64) (hs14_2 : s14_2 = s14_1 + s22 * 136657#64)
    (hs15_2 : s15_2 = s15_1 - s22 * 683901#64) (hs12_3 : s12_3 = s12_2 - s21 * 997805#64)
    (hs13_3 : s13_3 = s13_2 + s21 * 136657#64) (hs14_3 : s14_3 = s14_2 - s21 * 683901#64)
    (hs12_4 : s12_4 = s12_3 + s20 * 136657#64) (hs13_4 : s13_4 = s13_3 - s20 * 683901#64)
    (hs12_5 : s12_5 = s12_4 - s19 * 683901#64) (hs13_5 : s13_5 = s13_4 + carry12)
    (hs12_6 : s12_6 = s12_5 - carry12 <<< 21) (hs15_3 : s15_3 = s15_2 + carry14)
    (hs14_4 : s14_4 = s14_3 - carry14 <<< 21) (hs12_7 : s12_7 = s12_6 + carry11)
    (hs14_5 : s14_5 = s14_4 + carry13) (hs13_6 : s13_6 = s13_5 - carry13 <<< 21)
    (hs15_4 : s15_4 = s15_3 - carry15 <<< 21) (hs3_1 : s3_1 = s3 + s15_4 * 666643#64)
    (hs3_2 : s3_2 = s3_1 + s14_5 * 470296#64) (hs3_3 : s3_3 = s3_2 + s13_6 * 654183#64)
    (hs3_4 : s3_4 = s3_3 - s12_7 * 997805#64) (hs12_8 : s12_8 = 0#64) (hs3_5 : s3_5 = s3_4 + carry2)
    (hs3_6 : s3_6 = s3_5 - carry3 <<< 21) (hs12_9 : s12_9 = s12_8 + carry11_1)
    (hs3_7 : s3_7 = s3_6 - s12_9 * 997805#64) (hs12_10 : s12_10 = 0#64)
    (hs3_8 : s3_8 = s3_7 + carry2_1) (hs3_9 : s3_9 = s3_8 - carry3_1 <<< 21)
    (hs12_11 : s12_11 = s12_10 + carry11_2) (hs3_10 : s3_10 = s3_9 - s12_11 * 997805#64)
    (hs3_11 : s3_11 = s3_10 + carry2_2) (hs3_12 : s3_12 = s3_11 - carry3_2 <<< 21) :
    t2011 = s3_12 := by
  subst_vars
  grind

/-- `carry4_2` as the C computes it is the compiled `%2012`. -/
theorem sc25519_reduce.bridge_carry4_2
    (t1685 t1686 t1687 t1688 t1689 t1690 t1691 t1694 t1695 t1696 t1697 t1698 t1702 t1703 t1704 t1705
      t1706 t1707 t1712 t1713 t1719 t1720 t1721 t1722 t1723 t1724 t1767 t1768 t1769 t1770 t1771
      t1772 t1773 t1776 t1777 t1778 t1782 t1783 t1793 t1798 t1799 t1800 t1803 t1804 t1805 t1818
      t1819 t1830 t1831 t1848 t1849 t1862 t1863 t1876 t1877 t1892 t1940 t1959 t1960 t1961 t1962
      t1968 t1997 t1998 t2010 t2012 t1987 t1932 t1802 t1683 t1656 t1780 t1612 t1653 t1680 t1775
      t1797 t1676 t1650 t1672 t1646 t1766 t1792 t1668 t1642 t1890 t1915 t1958 t1964 t2009 s12_1
      s13_1 s14_1 s15_1 s16_1 s12_2 s13_2 s14_2 s15_2 s12_3 s13_3 s14_3 s12_4 s13_4 s12_5 s13_5
      s12_6 s15_3 s14_4 s16_2 s12_7 s14_5 s13_6 s16_3 s15_4 s4_1 s4_2 s4_3 s4_4 s4_5 s12_8 s4_6 s4_7
      s12_9 s4_8 s12_10 s4_9 s4_10 s12_11 s4_11 s4_12 carry4_2 s4 s12 s13 s14 s15 s16 s19 s20 s21
      s22 s23 carry12 carry14 carry16 carry11 carry13 carry15 carry4 carry3 carry11_1 carry3_1
      carry4_1 carry11_2 carry3_2 : BitVec 64)
    (ht1685 : t1685 = t1683 * 470296#64) (ht1686 : t1686 = t1683 * 654183#64)
    (ht1687 : t1687 = t1683 * 18446744073708553811#64) (ht1688 : t1688 = t1683 * 136657#64)
    (ht1689 : t1689 = t1688 + t1653) (ht1690 : t1690 = t1683 * 18446744073708867715#64)
    (ht1691 : t1691 = t1690 + t1656) (ht1694 : t1694 = t1680 * 654183#64)
    (ht1695 : t1695 = t1680 * 18446744073708553811#64) (ht1696 : t1696 = t1680 * 136657#64)
    (ht1697 : t1697 = t1680 * 18446744073708867715#64) (ht1698 : t1698 = t1689 + t1697)
    (ht1702 : t1702 = t1676 * 18446744073708553811#64) (ht1703 : t1703 = t1676 * 136657#64)
    (ht1704 : t1704 = t1676 * 18446744073708867715#64) (ht1705 : t1705 = t1704 + t1650)
    (ht1706 : t1706 = t1705 + t1687) (ht1707 : t1707 = t1706 + t1696)
    (ht1712 : t1712 = t1672 * 136657#64) (ht1713 : t1713 = t1672 * 18446744073708867715#64)
    (ht1719 : t1719 = t1668 * 18446744073708867715#64) (ht1720 : t1720 = t1719 + t1642)
    (ht1721 : t1721 = t1720 + t1712) (ht1722 : t1722 = t1721 + t1702)
    (ht1723 : t1723 = t1722 + t1685) (ht1724 : t1724 = t1723 + t1694)
    (ht1767 : t1767 = t1713 + t1646) (ht1768 : t1768 = t1767 + t1703)
    (ht1769 : t1769 = t1768 + t1686) (ht1770 : t1770 = t1769 + t1695)
    (ht1771 : t1771 = t1770 + t1766) (ht1772 : t1772 = t1766 <<< 21)
    (ht1773 : t1773 = t1724 - t1772) (ht1776 : t1776 = t1698 + t1775)
    (ht1777 : t1777 = t1775 <<< 21) (ht1778 : t1778 = t1707 - t1777) (ht1782 : t1782 = t1780 <<< 21)
    (ht1783 : t1783 = t1691 - t1782) (ht1793 : t1793 = t1792 + t1773)
    (ht1798 : t1798 = t1797 + t1778) (ht1799 : t1799 = t1797 <<< 21)
    (ht1800 : t1800 = t1771 - t1799) (ht1803 : t1803 = t1802 + t1783)
    (ht1804 : t1804 = t1802 <<< 21) (ht1805 : t1805 = t1776 - t1804)
    (ht1818 : t1818 = t1803 * 666643#64) (ht1819 : t1819 = t1818 + t1612)
    (ht1830 : t1830 = t1805 * 470296#64) (ht1831 : t1831 = t1819 + t1830)
    (ht1848 : t1848 = t1798 * 654183#64) (ht1849 : t1849 = t1831 + t1848)
    (ht1862 : t1862 = t1800 * 18446744073708553811#64) (ht1863 : t1863 = t1849 + t1862)
    (ht1876 : t1876 = t1793 * 136657#64) (ht1877 : t1877 = t1863 + t1876)
    (ht1892 : t1892 = t1890 <<< 21) (ht1940 : t1940 = t1932 * 136657#64)
    (ht1959 : t1959 = t1940 + t1877) (ht1960 : t1960 = t1959 - t1892)
    (ht1961 : t1961 = t1960 + t1915) (ht1962 : t1962 = t1961 + t1958)
    (ht1968 : t1968 = t1962 - t1964 <<< 21) (ht1997 : t1997 = t1987 * 136657#64)
    (ht1998 : t1998 = t1997 + t1968) (ht2010 : t2010 = t1998 + t2009)
    (ht2012 : t2012 = t2010.sshiftRight 21) (et1987 : t1987 = carry11_2)
    (et1932 : t1932 = carry11_1) (et1802 : t1802 = carry15) (et1683 : t1683 = s23)
    (et1656 : t1656 = s16) (et1780 : t1780 = carry16) (et1612 : t1612 = s4) (et1653 : t1653 = s15)
    (et1680 : t1680 = s22) (et1775 : t1775 = carry14) (et1797 : t1797 = carry13)
    (et1676 : t1676 = s21) (et1650 : t1650 = s14) (et1672 : t1672 = s20) (et1646 : t1646 = s13)
    (et1766 : t1766 = carry12) (et1792 : t1792 = carry11) (et1668 : t1668 = s19)
    (et1642 : t1642 = s12) (et1890 : t1890 = carry4) (et1915 : t1915 = carry3)
    (et1958 : t1958 = carry3_1) (et1964 : t1964 = carry4_1) (et2009 : t2009 = carry3_2)
    (hs12_1 : s12_1 = s12 + s23 * 470296#64) (hs13_1 : s13_1 = s13 + s23 * 654183#64)
    (hs14_1 : s14_1 = s14 - s23 * 997805#64) (hs15_1 : s15_1 = s15 + s23 * 136657#64)
    (hs16_1 : s16_1 = s16 - s23 * 683901#64) (hs12_2 : s12_2 = s12_1 + s22 * 654183#64)
    (hs13_2 : s13_2 = s13_1 - s22 * 997805#64) (hs14_2 : s14_2 = s14_1 + s22 * 136657#64)
    (hs15_2 : s15_2 = s15_1 - s22 * 683901#64) (hs12_3 : s12_3 = s12_2 - s21 * 997805#64)
    (hs13_3 : s13_3 = s13_2 + s21 * 136657#64) (hs14_3 : s14_3 = s14_2 - s21 * 683901#64)
    (hs12_4 : s12_4 = s12_3 + s20 * 136657#64) (hs13_4 : s13_4 = s13_3 - s20 * 683901#64)
    (hs12_5 : s12_5 = s12_4 - s19 * 683901#64) (hs13_5 : s13_5 = s13_4 + carry12)
    (hs12_6 : s12_6 = s12_5 - carry12 <<< 21) (hs15_3 : s15_3 = s15_2 + carry14)
    (hs14_4 : s14_4 = s14_3 - carry14 <<< 21) (hs16_2 : s16_2 = s16_1 - carry16 <<< 21)
    (hs12_7 : s12_7 = s12_6 + carry11) (hs14_5 : s14_5 = s14_4 + carry13)
    (hs13_6 : s13_6 = s13_5 - carry13 <<< 21) (hs16_3 : s16_3 = s16_2 + carry15)
    (hs15_4 : s15_4 = s15_3 - carry15 <<< 21) (hs4_1 : s4_1 = s4 + s16_3 * 666643#64)
    (hs4_2 : s4_2 = s4_1 + s15_4 * 470296#64) (hs4_3 : s4_3 = s4_2 + s14_5 * 654183#64)
    (hs4_4 : s4_4 = s4_3 - s13_6 * 997805#64) (hs4_5 : s4_5 = s4_4 + s12_7 * 136657#64)
    (hs12_8 : s12_8 = 0#64) (hs4_6 : s4_6 = s4_5 - carry4 <<< 21) (hs4_7 : s4_7 = s4_6 + carry3)
    (hs12_9 : s12_9 = s12_8 + carry11_1) (hs4_8 : s4_8 = s4_7 + s12_9 * 136657#64)
    (hs12_10 : s12_10 = 0#64) (hs4_9 : s4_9 = s4_8 + carry3_1)
    (hs4_10 : s4_10 = s4_9 - carry4_1 <<< 21) (hs12_11 : s12_11 = s12_10 + carry11_2)
    (hs4_11 : s4_11 = s4_10 + s12_11 * 136657#64) (hs4_12 : s4_12 = s4_11 + carry3_2)
    (hcarry4_2 : carry4_2 = s4_12.sshiftRight 21) : t2012 = carry4_2 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `s5_13` as the C computes it is the compiled `%2013`. -/
theorem sc25519_reduce.bridge_s5_13
    (t1685 t1686 t1687 t1688 t1689 t1690 t1691 t1694 t1695 t1696 t1697 t1698 t1702 t1703 t1704 t1705
      t1706 t1707 t1712 t1713 t1719 t1720 t1721 t1722 t1723 t1724 t1767 t1768 t1769 t1770 t1771
      t1772 t1773 t1776 t1777 t1778 t1781 t1782 t1783 t1793 t1798 t1799 t1800 t1803 t1804 t1805
      t1806 t1807 t1820 t1821 t1832 t1833 t1850 t1851 t1864 t1865 t1878 t1879 t1891 t1920 t1941
      t1965 t1966 t1967 t1971 t1999 t2000 t2013 t1987 t1780 t1660 t1616 t1802 t1683 t1656 t1653
      t1680 t1775 t1797 t1676 t1650 t1672 t1646 t1766 t1792 t1668 t1642 t1890 t1932 t1918 t1964
      t1969 t2012 s12_1 s13_1 s14_1 s15_1 s16_1 s12_2 s13_2 s14_2 s15_2 s12_3 s13_3 s14_3 s12_4
      s13_4 s12_5 s13_5 s12_6 s15_3 s14_4 s17_1 s16_2 s12_7 s14_5 s13_6 s16_3 s15_4 s5_1 s5_2 s5_3
      s5_4 s5_5 s5_6 s12_8 s5_7 s5_8 s12_9 s5_9 s12_10 s5_10 s5_11 s12_11 s5_12 s5_13 s5 s12 s13 s14
      s15 s16 s17 s19 s20 s21 s22 s23 carry12 carry14 carry16 carry11 carry13 carry15 carry4 carry5
      carry11_1 carry4_1 carry5_1 carry11_2 carry4_2 : BitVec 64)
    (ht1685 : t1685 = t1683 * 470296#64) (ht1686 : t1686 = t1683 * 654183#64)
    (ht1687 : t1687 = t1683 * 18446744073708553811#64) (ht1688 : t1688 = t1683 * 136657#64)
    (ht1689 : t1689 = t1688 + t1653) (ht1690 : t1690 = t1683 * 18446744073708867715#64)
    (ht1691 : t1691 = t1690 + t1656) (ht1694 : t1694 = t1680 * 654183#64)
    (ht1695 : t1695 = t1680 * 18446744073708553811#64) (ht1696 : t1696 = t1680 * 136657#64)
    (ht1697 : t1697 = t1680 * 18446744073708867715#64) (ht1698 : t1698 = t1689 + t1697)
    (ht1702 : t1702 = t1676 * 18446744073708553811#64) (ht1703 : t1703 = t1676 * 136657#64)
    (ht1704 : t1704 = t1676 * 18446744073708867715#64) (ht1705 : t1705 = t1704 + t1650)
    (ht1706 : t1706 = t1705 + t1687) (ht1707 : t1707 = t1706 + t1696)
    (ht1712 : t1712 = t1672 * 136657#64) (ht1713 : t1713 = t1672 * 18446744073708867715#64)
    (ht1719 : t1719 = t1668 * 18446744073708867715#64) (ht1720 : t1720 = t1719 + t1642)
    (ht1721 : t1721 = t1720 + t1712) (ht1722 : t1722 = t1721 + t1702)
    (ht1723 : t1723 = t1722 + t1685) (ht1724 : t1724 = t1723 + t1694)
    (ht1767 : t1767 = t1713 + t1646) (ht1768 : t1768 = t1767 + t1703)
    (ht1769 : t1769 = t1768 + t1686) (ht1770 : t1770 = t1769 + t1695)
    (ht1771 : t1771 = t1770 + t1766) (ht1772 : t1772 = t1766 <<< 21)
    (ht1773 : t1773 = t1724 - t1772) (ht1776 : t1776 = t1698 + t1775)
    (ht1777 : t1777 = t1775 <<< 21) (ht1778 : t1778 = t1707 - t1777)
    (ht1781 : t1781 = t1780 + t1660) (ht1782 : t1782 = t1780 <<< 21)
    (ht1783 : t1783 = t1691 - t1782) (ht1793 : t1793 = t1792 + t1773)
    (ht1798 : t1798 = t1797 + t1778) (ht1799 : t1799 = t1797 <<< 21)
    (ht1800 : t1800 = t1771 - t1799) (ht1803 : t1803 = t1802 + t1783)
    (ht1804 : t1804 = t1802 <<< 21) (ht1805 : t1805 = t1776 - t1804)
    (ht1806 : t1806 = t1781 * 666643#64) (ht1807 : t1807 = t1806 + t1616)
    (ht1820 : t1820 = t1803 * 470296#64) (ht1821 : t1821 = t1807 + t1820)
    (ht1832 : t1832 = t1805 * 654183#64) (ht1833 : t1833 = t1821 + t1832)
    (ht1850 : t1850 = t1798 * 18446744073708553811#64) (ht1851 : t1851 = t1833 + t1850)
    (ht1864 : t1864 = t1800 * 136657#64) (ht1865 : t1865 = t1851 + t1864)
    (ht1878 : t1878 = t1793 * 18446744073708867715#64) (ht1879 : t1879 = t1865 + t1878)
    (ht1891 : t1891 = t1879 + t1890) (ht1920 : t1920 = t1918 <<< 21)
    (ht1941 : t1941 = t1932 * 18446744073708867715#64) (ht1965 : t1965 = t1891 + t1941)
    (ht1966 : t1966 = t1965 - t1920) (ht1967 : t1967 = t1966 + t1964)
    (ht1971 : t1971 = t1967 - t1969 <<< 21) (ht1999 : t1999 = t1987 * 18446744073708867715#64)
    (ht2000 : t2000 = t1999 + t1971) (ht2013 : t2013 = t2000 + t2012) (et1987 : t1987 = carry11_2)
    (et1780 : t1780 = carry16) (et1660 : t1660 = s17) (et1616 : t1616 = s5)
    (et1802 : t1802 = carry15) (et1683 : t1683 = s23) (et1656 : t1656 = s16) (et1653 : t1653 = s15)
    (et1680 : t1680 = s22) (et1775 : t1775 = carry14) (et1797 : t1797 = carry13)
    (et1676 : t1676 = s21) (et1650 : t1650 = s14) (et1672 : t1672 = s20) (et1646 : t1646 = s13)
    (et1766 : t1766 = carry12) (et1792 : t1792 = carry11) (et1668 : t1668 = s19)
    (et1642 : t1642 = s12) (et1890 : t1890 = carry4) (et1932 : t1932 = carry11_1)
    (et1918 : t1918 = carry5) (et1964 : t1964 = carry4_1) (et1969 : t1969 = carry5_1)
    (et2012 : t2012 = carry4_2) (hs12_1 : s12_1 = s12 + s23 * 470296#64)
    (hs13_1 : s13_1 = s13 + s23 * 654183#64) (hs14_1 : s14_1 = s14 - s23 * 997805#64)
    (hs15_1 : s15_1 = s15 + s23 * 136657#64) (hs16_1 : s16_1 = s16 - s23 * 683901#64)
    (hs12_2 : s12_2 = s12_1 + s22 * 654183#64) (hs13_2 : s13_2 = s13_1 - s22 * 997805#64)
    (hs14_2 : s14_2 = s14_1 + s22 * 136657#64) (hs15_2 : s15_2 = s15_1 - s22 * 683901#64)
    (hs12_3 : s12_3 = s12_2 - s21 * 997805#64) (hs13_3 : s13_3 = s13_2 + s21 * 136657#64)
    (hs14_3 : s14_3 = s14_2 - s21 * 683901#64) (hs12_4 : s12_4 = s12_3 + s20 * 136657#64)
    (hs13_4 : s13_4 = s13_3 - s20 * 683901#64) (hs12_5 : s12_5 = s12_4 - s19 * 683901#64)
    (hs13_5 : s13_5 = s13_4 + carry12) (hs12_6 : s12_6 = s12_5 - carry12 <<< 21)
    (hs15_3 : s15_3 = s15_2 + carry14) (hs14_4 : s14_4 = s14_3 - carry14 <<< 21)
    (hs17_1 : s17_1 = s17 + carry16) (hs16_2 : s16_2 = s16_1 - carry16 <<< 21)
    (hs12_7 : s12_7 = s12_6 + carry11) (hs14_5 : s14_5 = s14_4 + carry13)
    (hs13_6 : s13_6 = s13_5 - carry13 <<< 21) (hs16_3 : s16_3 = s16_2 + carry15)
    (hs15_4 : s15_4 = s15_3 - carry15 <<< 21) (hs5_1 : s5_1 = s5 + s17_1 * 666643#64)
    (hs5_2 : s5_2 = s5_1 + s16_3 * 470296#64) (hs5_3 : s5_3 = s5_2 + s15_4 * 654183#64)
    (hs5_4 : s5_4 = s5_3 - s14_5 * 997805#64) (hs5_5 : s5_5 = s5_4 + s13_6 * 136657#64)
    (hs5_6 : s5_6 = s5_5 - s12_7 * 683901#64) (hs12_8 : s12_8 = 0#64) (hs5_7 : s5_7 = s5_6 + carry4)
    (hs5_8 : s5_8 = s5_7 - carry5 <<< 21) (hs12_9 : s12_9 = s12_8 + carry11_1)
    (hs5_9 : s5_9 = s5_8 - s12_9 * 683901#64) (hs12_10 : s12_10 = 0#64)
    (hs5_10 : s5_10 = s5_9 + carry4_1) (hs5_11 : s5_11 = s5_10 - carry5_1 <<< 21)
    (hs12_11 : s12_11 = s12_10 + carry11_2) (hs5_12 : s5_12 = s5_11 - s12_11 * 683901#64)
    (hs5_13 : s5_13 = s5_12 + carry4_2) : t2013 = s5_13 := by
  subst_vars
  grind

/-- `s4_13` as the C computes it is the compiled `%2014`. -/
theorem sc25519_reduce.bridge_s4_13
    (t1685 t1686 t1687 t1688 t1689 t1690 t1691 t1694 t1695 t1696 t1697 t1698 t1702 t1703 t1704 t1705
      t1706 t1707 t1712 t1713 t1719 t1720 t1721 t1722 t1723 t1724 t1767 t1768 t1769 t1770 t1771
      t1772 t1773 t1776 t1777 t1778 t1782 t1783 t1793 t1798 t1799 t1800 t1803 t1804 t1805 t1818
      t1819 t1830 t1831 t1848 t1849 t1862 t1863 t1876 t1877 t1892 t1940 t1959 t1960 t1961 t1962
      t1968 t1997 t1998 t2010 t2014 t1987 t1932 t1802 t1683 t1656 t1780 t1612 t1653 t1680 t1775
      t1797 t1676 t1650 t1672 t1646 t1766 t1792 t1668 t1642 t1890 t1915 t1958 t1964 t2009 t2012
      s12_1 s13_1 s14_1 s15_1 s16_1 s12_2 s13_2 s14_2 s15_2 s12_3 s13_3 s14_3 s12_4 s13_4 s12_5
      s13_5 s12_6 s15_3 s14_4 s16_2 s12_7 s14_5 s13_6 s16_3 s15_4 s4_1 s4_2 s4_3 s4_4 s4_5 s12_8
      s4_6 s4_7 s12_9 s4_8 s12_10 s4_9 s4_10 s12_11 s4_11 s4_12 s4_13 s4 s12 s13 s14 s15 s16 s19 s20
      s21 s22 s23 carry12 carry14 carry16 carry11 carry13 carry15 carry4 carry3 carry11_1 carry3_1
      carry4_1 carry11_2 carry3_2 carry4_2 : BitVec 64)
    (ht1685 : t1685 = t1683 * 470296#64) (ht1686 : t1686 = t1683 * 654183#64)
    (ht1687 : t1687 = t1683 * 18446744073708553811#64) (ht1688 : t1688 = t1683 * 136657#64)
    (ht1689 : t1689 = t1688 + t1653) (ht1690 : t1690 = t1683 * 18446744073708867715#64)
    (ht1691 : t1691 = t1690 + t1656) (ht1694 : t1694 = t1680 * 654183#64)
    (ht1695 : t1695 = t1680 * 18446744073708553811#64) (ht1696 : t1696 = t1680 * 136657#64)
    (ht1697 : t1697 = t1680 * 18446744073708867715#64) (ht1698 : t1698 = t1689 + t1697)
    (ht1702 : t1702 = t1676 * 18446744073708553811#64) (ht1703 : t1703 = t1676 * 136657#64)
    (ht1704 : t1704 = t1676 * 18446744073708867715#64) (ht1705 : t1705 = t1704 + t1650)
    (ht1706 : t1706 = t1705 + t1687) (ht1707 : t1707 = t1706 + t1696)
    (ht1712 : t1712 = t1672 * 136657#64) (ht1713 : t1713 = t1672 * 18446744073708867715#64)
    (ht1719 : t1719 = t1668 * 18446744073708867715#64) (ht1720 : t1720 = t1719 + t1642)
    (ht1721 : t1721 = t1720 + t1712) (ht1722 : t1722 = t1721 + t1702)
    (ht1723 : t1723 = t1722 + t1685) (ht1724 : t1724 = t1723 + t1694)
    (ht1767 : t1767 = t1713 + t1646) (ht1768 : t1768 = t1767 + t1703)
    (ht1769 : t1769 = t1768 + t1686) (ht1770 : t1770 = t1769 + t1695)
    (ht1771 : t1771 = t1770 + t1766) (ht1772 : t1772 = t1766 <<< 21)
    (ht1773 : t1773 = t1724 - t1772) (ht1776 : t1776 = t1698 + t1775)
    (ht1777 : t1777 = t1775 <<< 21) (ht1778 : t1778 = t1707 - t1777) (ht1782 : t1782 = t1780 <<< 21)
    (ht1783 : t1783 = t1691 - t1782) (ht1793 : t1793 = t1792 + t1773)
    (ht1798 : t1798 = t1797 + t1778) (ht1799 : t1799 = t1797 <<< 21)
    (ht1800 : t1800 = t1771 - t1799) (ht1803 : t1803 = t1802 + t1783)
    (ht1804 : t1804 = t1802 <<< 21) (ht1805 : t1805 = t1776 - t1804)
    (ht1818 : t1818 = t1803 * 666643#64) (ht1819 : t1819 = t1818 + t1612)
    (ht1830 : t1830 = t1805 * 470296#64) (ht1831 : t1831 = t1819 + t1830)
    (ht1848 : t1848 = t1798 * 654183#64) (ht1849 : t1849 = t1831 + t1848)
    (ht1862 : t1862 = t1800 * 18446744073708553811#64) (ht1863 : t1863 = t1849 + t1862)
    (ht1876 : t1876 = t1793 * 136657#64) (ht1877 : t1877 = t1863 + t1876)
    (ht1892 : t1892 = t1890 <<< 21) (ht1940 : t1940 = t1932 * 136657#64)
    (ht1959 : t1959 = t1940 + t1877) (ht1960 : t1960 = t1959 - t1892)
    (ht1961 : t1961 = t1960 + t1915) (ht1962 : t1962 = t1961 + t1958)
    (ht1968 : t1968 = t1962 - t1964 <<< 21) (ht1997 : t1997 = t1987 * 136657#64)
    (ht1998 : t1998 = t1997 + t1968) (ht2010 : t2010 = t1998 + t2009)
    (ht2014 : t2014 = t2010 - t2012 <<< 21) (et1987 : t1987 = carry11_2)
    (et1932 : t1932 = carry11_1) (et1802 : t1802 = carry15) (et1683 : t1683 = s23)
    (et1656 : t1656 = s16) (et1780 : t1780 = carry16) (et1612 : t1612 = s4) (et1653 : t1653 = s15)
    (et1680 : t1680 = s22) (et1775 : t1775 = carry14) (et1797 : t1797 = carry13)
    (et1676 : t1676 = s21) (et1650 : t1650 = s14) (et1672 : t1672 = s20) (et1646 : t1646 = s13)
    (et1766 : t1766 = carry12) (et1792 : t1792 = carry11) (et1668 : t1668 = s19)
    (et1642 : t1642 = s12) (et1890 : t1890 = carry4) (et1915 : t1915 = carry3)
    (et1958 : t1958 = carry3_1) (et1964 : t1964 = carry4_1) (et2009 : t2009 = carry3_2)
    (et2012 : t2012 = carry4_2) (hs12_1 : s12_1 = s12 + s23 * 470296#64)
    (hs13_1 : s13_1 = s13 + s23 * 654183#64) (hs14_1 : s14_1 = s14 - s23 * 997805#64)
    (hs15_1 : s15_1 = s15 + s23 * 136657#64) (hs16_1 : s16_1 = s16 - s23 * 683901#64)
    (hs12_2 : s12_2 = s12_1 + s22 * 654183#64) (hs13_2 : s13_2 = s13_1 - s22 * 997805#64)
    (hs14_2 : s14_2 = s14_1 + s22 * 136657#64) (hs15_2 : s15_2 = s15_1 - s22 * 683901#64)
    (hs12_3 : s12_3 = s12_2 - s21 * 997805#64) (hs13_3 : s13_3 = s13_2 + s21 * 136657#64)
    (hs14_3 : s14_3 = s14_2 - s21 * 683901#64) (hs12_4 : s12_4 = s12_3 + s20 * 136657#64)
    (hs13_4 : s13_4 = s13_3 - s20 * 683901#64) (hs12_5 : s12_5 = s12_4 - s19 * 683901#64)
    (hs13_5 : s13_5 = s13_4 + carry12) (hs12_6 : s12_6 = s12_5 - carry12 <<< 21)
    (hs15_3 : s15_3 = s15_2 + carry14) (hs14_4 : s14_4 = s14_3 - carry14 <<< 21)
    (hs16_2 : s16_2 = s16_1 - carry16 <<< 21) (hs12_7 : s12_7 = s12_6 + carry11)
    (hs14_5 : s14_5 = s14_4 + carry13) (hs13_6 : s13_6 = s13_5 - carry13 <<< 21)
    (hs16_3 : s16_3 = s16_2 + carry15) (hs15_4 : s15_4 = s15_3 - carry15 <<< 21)
    (hs4_1 : s4_1 = s4 + s16_3 * 666643#64) (hs4_2 : s4_2 = s4_1 + s15_4 * 470296#64)
    (hs4_3 : s4_3 = s4_2 + s14_5 * 654183#64) (hs4_4 : s4_4 = s4_3 - s13_6 * 997805#64)
    (hs4_5 : s4_5 = s4_4 + s12_7 * 136657#64) (hs12_8 : s12_8 = 0#64)
    (hs4_6 : s4_6 = s4_5 - carry4 <<< 21) (hs4_7 : s4_7 = s4_6 + carry3)
    (hs12_9 : s12_9 = s12_8 + carry11_1) (hs4_8 : s4_8 = s4_7 + s12_9 * 136657#64)
    (hs12_10 : s12_10 = 0#64) (hs4_9 : s4_9 = s4_8 + carry3_1)
    (hs4_10 : s4_10 = s4_9 - carry4_1 <<< 21) (hs12_11 : s12_11 = s12_10 + carry11_2)
    (hs4_11 : s4_11 = s4_10 + s12_11 * 136657#64) (hs4_12 : s4_12 = s4_11 + carry3_2)
    (hs4_13 : s4_13 = s4_12 - carry4_2 <<< 21) : t2014 = s4_13 := by
  subst_vars
  grind

/-- `carry5_2` as the C computes it is the compiled `%2015`. -/
theorem sc25519_reduce.bridge_carry5_2
    (t1685 t1686 t1687 t1688 t1689 t1690 t1691 t1694 t1695 t1696 t1697 t1698 t1702 t1703 t1704 t1705
      t1706 t1707 t1712 t1713 t1719 t1720 t1721 t1722 t1723 t1724 t1767 t1768 t1769 t1770 t1771
      t1772 t1773 t1776 t1777 t1778 t1781 t1782 t1783 t1793 t1798 t1799 t1800 t1803 t1804 t1805
      t1806 t1807 t1820 t1821 t1832 t1833 t1850 t1851 t1864 t1865 t1878 t1879 t1891 t1920 t1941
      t1965 t1966 t1967 t1971 t1999 t2000 t2013 t2015 t1987 t1780 t1660 t1616 t1802 t1683 t1656
      t1653 t1680 t1775 t1797 t1676 t1650 t1672 t1646 t1766 t1792 t1668 t1642 t1890 t1932 t1918
      t1964 t1969 t2012 s12_1 s13_1 s14_1 s15_1 s16_1 s12_2 s13_2 s14_2 s15_2 s12_3 s13_3 s14_3
      s12_4 s13_4 s12_5 s13_5 s12_6 s15_3 s14_4 s17_1 s16_2 s12_7 s14_5 s13_6 s16_3 s15_4 s5_1 s5_2
      s5_3 s5_4 s5_5 s5_6 s12_8 s5_7 s5_8 s12_9 s5_9 s12_10 s5_10 s5_11 s12_11 s5_12 s5_13 carry5_2
      s5 s12 s13 s14 s15 s16 s17 s19 s20 s21 s22 s23 carry12 carry14 carry16 carry11 carry13 carry15
      carry4 carry5 carry11_1 carry4_1 carry5_1 carry11_2 carry4_2 : BitVec 64)
    (ht1685 : t1685 = t1683 * 470296#64) (ht1686 : t1686 = t1683 * 654183#64)
    (ht1687 : t1687 = t1683 * 18446744073708553811#64) (ht1688 : t1688 = t1683 * 136657#64)
    (ht1689 : t1689 = t1688 + t1653) (ht1690 : t1690 = t1683 * 18446744073708867715#64)
    (ht1691 : t1691 = t1690 + t1656) (ht1694 : t1694 = t1680 * 654183#64)
    (ht1695 : t1695 = t1680 * 18446744073708553811#64) (ht1696 : t1696 = t1680 * 136657#64)
    (ht1697 : t1697 = t1680 * 18446744073708867715#64) (ht1698 : t1698 = t1689 + t1697)
    (ht1702 : t1702 = t1676 * 18446744073708553811#64) (ht1703 : t1703 = t1676 * 136657#64)
    (ht1704 : t1704 = t1676 * 18446744073708867715#64) (ht1705 : t1705 = t1704 + t1650)
    (ht1706 : t1706 = t1705 + t1687) (ht1707 : t1707 = t1706 + t1696)
    (ht1712 : t1712 = t1672 * 136657#64) (ht1713 : t1713 = t1672 * 18446744073708867715#64)
    (ht1719 : t1719 = t1668 * 18446744073708867715#64) (ht1720 : t1720 = t1719 + t1642)
    (ht1721 : t1721 = t1720 + t1712) (ht1722 : t1722 = t1721 + t1702)
    (ht1723 : t1723 = t1722 + t1685) (ht1724 : t1724 = t1723 + t1694)
    (ht1767 : t1767 = t1713 + t1646) (ht1768 : t1768 = t1767 + t1703)
    (ht1769 : t1769 = t1768 + t1686) (ht1770 : t1770 = t1769 + t1695)
    (ht1771 : t1771 = t1770 + t1766) (ht1772 : t1772 = t1766 <<< 21)
    (ht1773 : t1773 = t1724 - t1772) (ht1776 : t1776 = t1698 + t1775)
    (ht1777 : t1777 = t1775 <<< 21) (ht1778 : t1778 = t1707 - t1777)
    (ht1781 : t1781 = t1780 + t1660) (ht1782 : t1782 = t1780 <<< 21)
    (ht1783 : t1783 = t1691 - t1782) (ht1793 : t1793 = t1792 + t1773)
    (ht1798 : t1798 = t1797 + t1778) (ht1799 : t1799 = t1797 <<< 21)
    (ht1800 : t1800 = t1771 - t1799) (ht1803 : t1803 = t1802 + t1783)
    (ht1804 : t1804 = t1802 <<< 21) (ht1805 : t1805 = t1776 - t1804)
    (ht1806 : t1806 = t1781 * 666643#64) (ht1807 : t1807 = t1806 + t1616)
    (ht1820 : t1820 = t1803 * 470296#64) (ht1821 : t1821 = t1807 + t1820)
    (ht1832 : t1832 = t1805 * 654183#64) (ht1833 : t1833 = t1821 + t1832)
    (ht1850 : t1850 = t1798 * 18446744073708553811#64) (ht1851 : t1851 = t1833 + t1850)
    (ht1864 : t1864 = t1800 * 136657#64) (ht1865 : t1865 = t1851 + t1864)
    (ht1878 : t1878 = t1793 * 18446744073708867715#64) (ht1879 : t1879 = t1865 + t1878)
    (ht1891 : t1891 = t1879 + t1890) (ht1920 : t1920 = t1918 <<< 21)
    (ht1941 : t1941 = t1932 * 18446744073708867715#64) (ht1965 : t1965 = t1891 + t1941)
    (ht1966 : t1966 = t1965 - t1920) (ht1967 : t1967 = t1966 + t1964)
    (ht1971 : t1971 = t1967 - t1969 <<< 21) (ht1999 : t1999 = t1987 * 18446744073708867715#64)
    (ht2000 : t2000 = t1999 + t1971) (ht2013 : t2013 = t2000 + t2012)
    (ht2015 : t2015 = t2013.sshiftRight 21) (et1987 : t1987 = carry11_2) (et1780 : t1780 = carry16)
    (et1660 : t1660 = s17) (et1616 : t1616 = s5) (et1802 : t1802 = carry15) (et1683 : t1683 = s23)
    (et1656 : t1656 = s16) (et1653 : t1653 = s15) (et1680 : t1680 = s22) (et1775 : t1775 = carry14)
    (et1797 : t1797 = carry13) (et1676 : t1676 = s21) (et1650 : t1650 = s14) (et1672 : t1672 = s20)
    (et1646 : t1646 = s13) (et1766 : t1766 = carry12) (et1792 : t1792 = carry11)
    (et1668 : t1668 = s19) (et1642 : t1642 = s12) (et1890 : t1890 = carry4)
    (et1932 : t1932 = carry11_1) (et1918 : t1918 = carry5) (et1964 : t1964 = carry4_1)
    (et1969 : t1969 = carry5_1) (et2012 : t2012 = carry4_2) (hs12_1 : s12_1 = s12 + s23 * 470296#64)
    (hs13_1 : s13_1 = s13 + s23 * 654183#64) (hs14_1 : s14_1 = s14 - s23 * 997805#64)
    (hs15_1 : s15_1 = s15 + s23 * 136657#64) (hs16_1 : s16_1 = s16 - s23 * 683901#64)
    (hs12_2 : s12_2 = s12_1 + s22 * 654183#64) (hs13_2 : s13_2 = s13_1 - s22 * 997805#64)
    (hs14_2 : s14_2 = s14_1 + s22 * 136657#64) (hs15_2 : s15_2 = s15_1 - s22 * 683901#64)
    (hs12_3 : s12_3 = s12_2 - s21 * 997805#64) (hs13_3 : s13_3 = s13_2 + s21 * 136657#64)
    (hs14_3 : s14_3 = s14_2 - s21 * 683901#64) (hs12_4 : s12_4 = s12_3 + s20 * 136657#64)
    (hs13_4 : s13_4 = s13_3 - s20 * 683901#64) (hs12_5 : s12_5 = s12_4 - s19 * 683901#64)
    (hs13_5 : s13_5 = s13_4 + carry12) (hs12_6 : s12_6 = s12_5 - carry12 <<< 21)
    (hs15_3 : s15_3 = s15_2 + carry14) (hs14_4 : s14_4 = s14_3 - carry14 <<< 21)
    (hs17_1 : s17_1 = s17 + carry16) (hs16_2 : s16_2 = s16_1 - carry16 <<< 21)
    (hs12_7 : s12_7 = s12_6 + carry11) (hs14_5 : s14_5 = s14_4 + carry13)
    (hs13_6 : s13_6 = s13_5 - carry13 <<< 21) (hs16_3 : s16_3 = s16_2 + carry15)
    (hs15_4 : s15_4 = s15_3 - carry15 <<< 21) (hs5_1 : s5_1 = s5 + s17_1 * 666643#64)
    (hs5_2 : s5_2 = s5_1 + s16_3 * 470296#64) (hs5_3 : s5_3 = s5_2 + s15_4 * 654183#64)
    (hs5_4 : s5_4 = s5_3 - s14_5 * 997805#64) (hs5_5 : s5_5 = s5_4 + s13_6 * 136657#64)
    (hs5_6 : s5_6 = s5_5 - s12_7 * 683901#64) (hs12_8 : s12_8 = 0#64) (hs5_7 : s5_7 = s5_6 + carry4)
    (hs5_8 : s5_8 = s5_7 - carry5 <<< 21) (hs12_9 : s12_9 = s12_8 + carry11_1)
    (hs5_9 : s5_9 = s5_8 - s12_9 * 683901#64) (hs12_10 : s12_10 = 0#64)
    (hs5_10 : s5_10 = s5_9 + carry4_1) (hs5_11 : s5_11 = s5_10 - carry5_1 <<< 21)
    (hs12_11 : s12_11 = s12_10 + carry11_2) (hs5_12 : s5_12 = s5_11 - s12_11 * 683901#64)
    (hs5_13 : s5_13 = s5_12 + carry4_2) (hcarry5_2 : carry5_2 = s5_13.sshiftRight 21) :
    t2015 = carry5_2 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `s6_12` as the C computes it is the compiled `%2016`. -/
theorem sc25519_reduce.bridge_s6_12
    (t1686 t1687 t1688 t1689 t1690 t1691 t1695 t1696 t1697 t1698 t1703 t1704 t1705 t1706 t1707 t1713
      t1725 t1726 t1745 t1746 t1767 t1768 t1769 t1770 t1771 t1776 t1777 t1778 t1781 t1782 t1783
      t1798 t1799 t1800 t1803 t1804 t1805 t1808 t1809 t1822 t1823 t1834 t1835 t1852 t1853 t1866
      t1867 t1896 t1897 t1919 t1970 t1974 t2016 t2015 t1664 t1620 t1741 t1780 t1660 t1802 t1683
      t1656 t1653 t1680 t1775 t1797 t1676 t1650 t1672 t1646 t1766 t1894 t1918 t1969 t1972 s13_1
      s14_1 s15_1 s16_1 s13_2 s14_2 s15_2 s13_3 s14_3 s13_4 s6_1 s6_2 s13_5 s15_3 s14_4 s17_1 s16_2
      s14_5 s13_6 s16_3 s15_4 s6_3 s6_4 s6_5 s6_6 s6_7 s6_8 s6_9 s6_10 s6_11 s6_12 s6 s13 s14 s15
      s16 s17 s18 s20 s21 s22 s23 carry6 carry12 carry14 carry16 carry13 carry15 carry6_1 carry5
      carry5_1 carry6_2 carry5_2 : BitVec 64)
    (ht1686 : t1686 = t1683 * 654183#64) (ht1687 : t1687 = t1683 * 18446744073708553811#64)
    (ht1688 : t1688 = t1683 * 136657#64) (ht1689 : t1689 = t1688 + t1653)
    (ht1690 : t1690 = t1683 * 18446744073708867715#64) (ht1691 : t1691 = t1690 + t1656)
    (ht1695 : t1695 = t1680 * 18446744073708553811#64) (ht1696 : t1696 = t1680 * 136657#64)
    (ht1697 : t1697 = t1680 * 18446744073708867715#64) (ht1698 : t1698 = t1689 + t1697)
    (ht1703 : t1703 = t1676 * 136657#64) (ht1704 : t1704 = t1676 * 18446744073708867715#64)
    (ht1705 : t1705 = t1704 + t1650) (ht1706 : t1706 = t1705 + t1687)
    (ht1707 : t1707 = t1706 + t1696) (ht1713 : t1713 = t1672 * 18446744073708867715#64)
    (ht1725 : t1725 = t1664 * 666643#64) (ht1726 : t1726 = t1725 + t1620)
    (ht1745 : t1745 = t1741 <<< 21) (ht1746 : t1746 = t1726 - t1745)
    (ht1767 : t1767 = t1713 + t1646) (ht1768 : t1768 = t1767 + t1703)
    (ht1769 : t1769 = t1768 + t1686) (ht1770 : t1770 = t1769 + t1695)
    (ht1771 : t1771 = t1770 + t1766) (ht1776 : t1776 = t1698 + t1775)
    (ht1777 : t1777 = t1775 <<< 21) (ht1778 : t1778 = t1707 - t1777)
    (ht1781 : t1781 = t1780 + t1660) (ht1782 : t1782 = t1780 <<< 21)
    (ht1783 : t1783 = t1691 - t1782) (ht1798 : t1798 = t1797 + t1778)
    (ht1799 : t1799 = t1797 <<< 21) (ht1800 : t1800 = t1771 - t1799)
    (ht1803 : t1803 = t1802 + t1783) (ht1804 : t1804 = t1802 <<< 21)
    (ht1805 : t1805 = t1776 - t1804) (ht1808 : t1808 = t1781 * 470296#64)
    (ht1809 : t1809 = t1746 + t1808) (ht1822 : t1822 = t1803 * 654183#64)
    (ht1823 : t1823 = t1809 + t1822) (ht1834 : t1834 = t1805 * 18446744073708553811#64)
    (ht1835 : t1835 = t1823 + t1834) (ht1852 : t1852 = t1798 * 136657#64)
    (ht1853 : t1853 = t1835 + t1852) (ht1866 : t1866 = t1800 * 18446744073708867715#64)
    (ht1867 : t1867 = t1853 + t1866) (ht1896 : t1896 = t1894 <<< 21)
    (ht1897 : t1897 = t1867 - t1896) (ht1919 : t1919 = t1897 + t1918)
    (ht1970 : t1970 = t1919 + t1969) (ht1974 : t1974 = t1970 - t1972 <<< 21)
    (ht2016 : t2016 = t2015 + t1974) (et2015 : t2015 = carry5_2) (et1664 : t1664 = s18)
    (et1620 : t1620 = s6) (et1741 : t1741 = carry6) (et1780 : t1780 = carry16)
    (et1660 : t1660 = s17) (et1802 : t1802 = carry15) (et1683 : t1683 = s23) (et1656 : t1656 = s16)
    (et1653 : t1653 = s15) (et1680 : t1680 = s22) (et1775 : t1775 = carry14)
    (et1797 : t1797 = carry13) (et1676 : t1676 = s21) (et1650 : t1650 = s14) (et1672 : t1672 = s20)
    (et1646 : t1646 = s13) (et1766 : t1766 = carry12) (et1894 : t1894 = carry6_1)
    (et1918 : t1918 = carry5) (et1969 : t1969 = carry5_1) (et1972 : t1972 = carry6_2)
    (hs13_1 : s13_1 = s13 + s23 * 654183#64) (hs14_1 : s14_1 = s14 - s23 * 997805#64)
    (hs15_1 : s15_1 = s15 + s23 * 136657#64) (hs16_1 : s16_1 = s16 - s23 * 683901#64)
    (hs13_2 : s13_2 = s13_1 - s22 * 997805#64) (hs14_2 : s14_2 = s14_1 + s22 * 136657#64)
    (hs15_2 : s15_2 = s15_1 - s22 * 683901#64) (hs13_3 : s13_3 = s13_2 + s21 * 136657#64)
    (hs14_3 : s14_3 = s14_2 - s21 * 683901#64) (hs13_4 : s13_4 = s13_3 - s20 * 683901#64)
    (hs6_1 : s6_1 = s6 + s18 * 666643#64) (hs6_2 : s6_2 = s6_1 - carry6 <<< 21)
    (hs13_5 : s13_5 = s13_4 + carry12) (hs15_3 : s15_3 = s15_2 + carry14)
    (hs14_4 : s14_4 = s14_3 - carry14 <<< 21) (hs17_1 : s17_1 = s17 + carry16)
    (hs16_2 : s16_2 = s16_1 - carry16 <<< 21) (hs14_5 : s14_5 = s14_4 + carry13)
    (hs13_6 : s13_6 = s13_5 - carry13 <<< 21) (hs16_3 : s16_3 = s16_2 + carry15)
    (hs15_4 : s15_4 = s15_3 - carry15 <<< 21) (hs6_3 : s6_3 = s6_2 + s17_1 * 470296#64)
    (hs6_4 : s6_4 = s6_3 + s16_3 * 654183#64) (hs6_5 : s6_5 = s6_4 - s15_4 * 997805#64)
    (hs6_6 : s6_6 = s6_5 + s14_5 * 136657#64) (hs6_7 : s6_7 = s6_6 - s13_6 * 683901#64)
    (hs6_8 : s6_8 = s6_7 - carry6_1 <<< 21) (hs6_9 : s6_9 = s6_8 + carry5)
    (hs6_10 : s6_10 = s6_9 + carry5_1) (hs6_11 : s6_11 = s6_10 - carry6_2 <<< 21)
    (hs6_12 : s6_12 = s6_11 + carry5_2) : t2016 = s6_12 := by
  subst_vars
  grind

/-- `s5_14` as the C computes it is the compiled `%2017`. -/
theorem sc25519_reduce.bridge_s5_14
    (t1685 t1686 t1687 t1688 t1689 t1690 t1691 t1694 t1695 t1696 t1697 t1698 t1702 t1703 t1704 t1705
      t1706 t1707 t1712 t1713 t1719 t1720 t1721 t1722 t1723 t1724 t1767 t1768 t1769 t1770 t1771
      t1772 t1773 t1776 t1777 t1778 t1781 t1782 t1783 t1793 t1798 t1799 t1800 t1803 t1804 t1805
      t1806 t1807 t1820 t1821 t1832 t1833 t1850 t1851 t1864 t1865 t1878 t1879 t1891 t1920 t1941
      t1965 t1966 t1967 t1971 t1999 t2000 t2013 t2017 t1987 t1780 t1660 t1616 t1802 t1683 t1656
      t1653 t1680 t1775 t1797 t1676 t1650 t1672 t1646 t1766 t1792 t1668 t1642 t1890 t1932 t1918
      t1964 t1969 t2012 t2015 s12_1 s13_1 s14_1 s15_1 s16_1 s12_2 s13_2 s14_2 s15_2 s12_3 s13_3
      s14_3 s12_4 s13_4 s12_5 s13_5 s12_6 s15_3 s14_4 s17_1 s16_2 s12_7 s14_5 s13_6 s16_3 s15_4 s5_1
      s5_2 s5_3 s5_4 s5_5 s5_6 s12_8 s5_7 s5_8 s12_9 s5_9 s12_10 s5_10 s5_11 s12_11 s5_12 s5_13
      s5_14 s5 s12 s13 s14 s15 s16 s17 s19 s20 s21 s22 s23 carry12 carry14 carry16 carry11 carry13
      carry15 carry4 carry5 carry11_1 carry4_1 carry5_1 carry11_2 carry4_2 carry5_2 : BitVec 64)
    (ht1685 : t1685 = t1683 * 470296#64) (ht1686 : t1686 = t1683 * 654183#64)
    (ht1687 : t1687 = t1683 * 18446744073708553811#64) (ht1688 : t1688 = t1683 * 136657#64)
    (ht1689 : t1689 = t1688 + t1653) (ht1690 : t1690 = t1683 * 18446744073708867715#64)
    (ht1691 : t1691 = t1690 + t1656) (ht1694 : t1694 = t1680 * 654183#64)
    (ht1695 : t1695 = t1680 * 18446744073708553811#64) (ht1696 : t1696 = t1680 * 136657#64)
    (ht1697 : t1697 = t1680 * 18446744073708867715#64) (ht1698 : t1698 = t1689 + t1697)
    (ht1702 : t1702 = t1676 * 18446744073708553811#64) (ht1703 : t1703 = t1676 * 136657#64)
    (ht1704 : t1704 = t1676 * 18446744073708867715#64) (ht1705 : t1705 = t1704 + t1650)
    (ht1706 : t1706 = t1705 + t1687) (ht1707 : t1707 = t1706 + t1696)
    (ht1712 : t1712 = t1672 * 136657#64) (ht1713 : t1713 = t1672 * 18446744073708867715#64)
    (ht1719 : t1719 = t1668 * 18446744073708867715#64) (ht1720 : t1720 = t1719 + t1642)
    (ht1721 : t1721 = t1720 + t1712) (ht1722 : t1722 = t1721 + t1702)
    (ht1723 : t1723 = t1722 + t1685) (ht1724 : t1724 = t1723 + t1694)
    (ht1767 : t1767 = t1713 + t1646) (ht1768 : t1768 = t1767 + t1703)
    (ht1769 : t1769 = t1768 + t1686) (ht1770 : t1770 = t1769 + t1695)
    (ht1771 : t1771 = t1770 + t1766) (ht1772 : t1772 = t1766 <<< 21)
    (ht1773 : t1773 = t1724 - t1772) (ht1776 : t1776 = t1698 + t1775)
    (ht1777 : t1777 = t1775 <<< 21) (ht1778 : t1778 = t1707 - t1777)
    (ht1781 : t1781 = t1780 + t1660) (ht1782 : t1782 = t1780 <<< 21)
    (ht1783 : t1783 = t1691 - t1782) (ht1793 : t1793 = t1792 + t1773)
    (ht1798 : t1798 = t1797 + t1778) (ht1799 : t1799 = t1797 <<< 21)
    (ht1800 : t1800 = t1771 - t1799) (ht1803 : t1803 = t1802 + t1783)
    (ht1804 : t1804 = t1802 <<< 21) (ht1805 : t1805 = t1776 - t1804)
    (ht1806 : t1806 = t1781 * 666643#64) (ht1807 : t1807 = t1806 + t1616)
    (ht1820 : t1820 = t1803 * 470296#64) (ht1821 : t1821 = t1807 + t1820)
    (ht1832 : t1832 = t1805 * 654183#64) (ht1833 : t1833 = t1821 + t1832)
    (ht1850 : t1850 = t1798 * 18446744073708553811#64) (ht1851 : t1851 = t1833 + t1850)
    (ht1864 : t1864 = t1800 * 136657#64) (ht1865 : t1865 = t1851 + t1864)
    (ht1878 : t1878 = t1793 * 18446744073708867715#64) (ht1879 : t1879 = t1865 + t1878)
    (ht1891 : t1891 = t1879 + t1890) (ht1920 : t1920 = t1918 <<< 21)
    (ht1941 : t1941 = t1932 * 18446744073708867715#64) (ht1965 : t1965 = t1891 + t1941)
    (ht1966 : t1966 = t1965 - t1920) (ht1967 : t1967 = t1966 + t1964)
    (ht1971 : t1971 = t1967 - t1969 <<< 21) (ht1999 : t1999 = t1987 * 18446744073708867715#64)
    (ht2000 : t2000 = t1999 + t1971) (ht2013 : t2013 = t2000 + t2012)
    (ht2017 : t2017 = t2013 - t2015 <<< 21) (et1987 : t1987 = carry11_2) (et1780 : t1780 = carry16)
    (et1660 : t1660 = s17) (et1616 : t1616 = s5) (et1802 : t1802 = carry15) (et1683 : t1683 = s23)
    (et1656 : t1656 = s16) (et1653 : t1653 = s15) (et1680 : t1680 = s22) (et1775 : t1775 = carry14)
    (et1797 : t1797 = carry13) (et1676 : t1676 = s21) (et1650 : t1650 = s14) (et1672 : t1672 = s20)
    (et1646 : t1646 = s13) (et1766 : t1766 = carry12) (et1792 : t1792 = carry11)
    (et1668 : t1668 = s19) (et1642 : t1642 = s12) (et1890 : t1890 = carry4)
    (et1932 : t1932 = carry11_1) (et1918 : t1918 = carry5) (et1964 : t1964 = carry4_1)
    (et1969 : t1969 = carry5_1) (et2012 : t2012 = carry4_2) (et2015 : t2015 = carry5_2)
    (hs12_1 : s12_1 = s12 + s23 * 470296#64) (hs13_1 : s13_1 = s13 + s23 * 654183#64)
    (hs14_1 : s14_1 = s14 - s23 * 997805#64) (hs15_1 : s15_1 = s15 + s23 * 136657#64)
    (hs16_1 : s16_1 = s16 - s23 * 683901#64) (hs12_2 : s12_2 = s12_1 + s22 * 654183#64)
    (hs13_2 : s13_2 = s13_1 - s22 * 997805#64) (hs14_2 : s14_2 = s14_1 + s22 * 136657#64)
    (hs15_2 : s15_2 = s15_1 - s22 * 683901#64) (hs12_3 : s12_3 = s12_2 - s21 * 997805#64)
    (hs13_3 : s13_3 = s13_2 + s21 * 136657#64) (hs14_3 : s14_3 = s14_2 - s21 * 683901#64)
    (hs12_4 : s12_4 = s12_3 + s20 * 136657#64) (hs13_4 : s13_4 = s13_3 - s20 * 683901#64)
    (hs12_5 : s12_5 = s12_4 - s19 * 683901#64) (hs13_5 : s13_5 = s13_4 + carry12)
    (hs12_6 : s12_6 = s12_5 - carry12 <<< 21) (hs15_3 : s15_3 = s15_2 + carry14)
    (hs14_4 : s14_4 = s14_3 - carry14 <<< 21) (hs17_1 : s17_1 = s17 + carry16)
    (hs16_2 : s16_2 = s16_1 - carry16 <<< 21) (hs12_7 : s12_7 = s12_6 + carry11)
    (hs14_5 : s14_5 = s14_4 + carry13) (hs13_6 : s13_6 = s13_5 - carry13 <<< 21)
    (hs16_3 : s16_3 = s16_2 + carry15) (hs15_4 : s15_4 = s15_3 - carry15 <<< 21)
    (hs5_1 : s5_1 = s5 + s17_1 * 666643#64) (hs5_2 : s5_2 = s5_1 + s16_3 * 470296#64)
    (hs5_3 : s5_3 = s5_2 + s15_4 * 654183#64) (hs5_4 : s5_4 = s5_3 - s14_5 * 997805#64)
    (hs5_5 : s5_5 = s5_4 + s13_6 * 136657#64) (hs5_6 : s5_6 = s5_5 - s12_7 * 683901#64)
    (hs12_8 : s12_8 = 0#64) (hs5_7 : s5_7 = s5_6 + carry4) (hs5_8 : s5_8 = s5_7 - carry5 <<< 21)
    (hs12_9 : s12_9 = s12_8 + carry11_1) (hs5_9 : s5_9 = s5_8 - s12_9 * 683901#64)
    (hs12_10 : s12_10 = 0#64) (hs5_10 : s5_10 = s5_9 + carry4_1)
    (hs5_11 : s5_11 = s5_10 - carry5_1 <<< 21) (hs12_11 : s12_11 = s12_10 + carry11_2)
    (hs5_12 : s5_12 = s5_11 - s12_11 * 683901#64) (hs5_13 : s5_13 = s5_12 + carry4_2)
    (hs5_14 : s5_14 = s5_13 - carry5_2 <<< 21) : t2017 = s5_14 := by
  subst_vars
  grind

/-- `carry6_3` as the C computes it is the compiled `%2018`. -/
theorem sc25519_reduce.bridge_carry6_3
    (t1686 t1687 t1688 t1689 t1690 t1691 t1695 t1696 t1697 t1698 t1703 t1704 t1705 t1706 t1707 t1713
      t1725 t1726 t1745 t1746 t1767 t1768 t1769 t1770 t1771 t1776 t1777 t1778 t1781 t1782 t1783
      t1798 t1799 t1800 t1803 t1804 t1805 t1808 t1809 t1822 t1823 t1834 t1835 t1852 t1853 t1866
      t1867 t1896 t1897 t1919 t1970 t1974 t2016 t2018 t2015 t1664 t1620 t1741 t1780 t1660 t1802
      t1683 t1656 t1653 t1680 t1775 t1797 t1676 t1650 t1672 t1646 t1766 t1894 t1918 t1969 t1972
      s13_1 s14_1 s15_1 s16_1 s13_2 s14_2 s15_2 s13_3 s14_3 s13_4 s6_1 s6_2 s13_5 s15_3 s14_4 s17_1
      s16_2 s14_5 s13_6 s16_3 s15_4 s6_3 s6_4 s6_5 s6_6 s6_7 s6_8 s6_9 s6_10 s6_11 s6_12 carry6_3 s6
      s13 s14 s15 s16 s17 s18 s20 s21 s22 s23 carry6 carry12 carry14 carry16 carry13 carry15
      carry6_1 carry5 carry5_1 carry6_2 carry5_2 : BitVec 64)
    (ht1686 : t1686 = t1683 * 654183#64) (ht1687 : t1687 = t1683 * 18446744073708553811#64)
    (ht1688 : t1688 = t1683 * 136657#64) (ht1689 : t1689 = t1688 + t1653)
    (ht1690 : t1690 = t1683 * 18446744073708867715#64) (ht1691 : t1691 = t1690 + t1656)
    (ht1695 : t1695 = t1680 * 18446744073708553811#64) (ht1696 : t1696 = t1680 * 136657#64)
    (ht1697 : t1697 = t1680 * 18446744073708867715#64) (ht1698 : t1698 = t1689 + t1697)
    (ht1703 : t1703 = t1676 * 136657#64) (ht1704 : t1704 = t1676 * 18446744073708867715#64)
    (ht1705 : t1705 = t1704 + t1650) (ht1706 : t1706 = t1705 + t1687)
    (ht1707 : t1707 = t1706 + t1696) (ht1713 : t1713 = t1672 * 18446744073708867715#64)
    (ht1725 : t1725 = t1664 * 666643#64) (ht1726 : t1726 = t1725 + t1620)
    (ht1745 : t1745 = t1741 <<< 21) (ht1746 : t1746 = t1726 - t1745)
    (ht1767 : t1767 = t1713 + t1646) (ht1768 : t1768 = t1767 + t1703)
    (ht1769 : t1769 = t1768 + t1686) (ht1770 : t1770 = t1769 + t1695)
    (ht1771 : t1771 = t1770 + t1766) (ht1776 : t1776 = t1698 + t1775)
    (ht1777 : t1777 = t1775 <<< 21) (ht1778 : t1778 = t1707 - t1777)
    (ht1781 : t1781 = t1780 + t1660) (ht1782 : t1782 = t1780 <<< 21)
    (ht1783 : t1783 = t1691 - t1782) (ht1798 : t1798 = t1797 + t1778)
    (ht1799 : t1799 = t1797 <<< 21) (ht1800 : t1800 = t1771 - t1799)
    (ht1803 : t1803 = t1802 + t1783) (ht1804 : t1804 = t1802 <<< 21)
    (ht1805 : t1805 = t1776 - t1804) (ht1808 : t1808 = t1781 * 470296#64)
    (ht1809 : t1809 = t1746 + t1808) (ht1822 : t1822 = t1803 * 654183#64)
    (ht1823 : t1823 = t1809 + t1822) (ht1834 : t1834 = t1805 * 18446744073708553811#64)
    (ht1835 : t1835 = t1823 + t1834) (ht1852 : t1852 = t1798 * 136657#64)
    (ht1853 : t1853 = t1835 + t1852) (ht1866 : t1866 = t1800 * 18446744073708867715#64)
    (ht1867 : t1867 = t1853 + t1866) (ht1896 : t1896 = t1894 <<< 21)
    (ht1897 : t1897 = t1867 - t1896) (ht1919 : t1919 = t1897 + t1918)
    (ht1970 : t1970 = t1919 + t1969) (ht1974 : t1974 = t1970 - t1972 <<< 21)
    (ht2016 : t2016 = t2015 + t1974) (ht2018 : t2018 = t2016.sshiftRight 21)
    (et2015 : t2015 = carry5_2) (et1664 : t1664 = s18) (et1620 : t1620 = s6)
    (et1741 : t1741 = carry6) (et1780 : t1780 = carry16) (et1660 : t1660 = s17)
    (et1802 : t1802 = carry15) (et1683 : t1683 = s23) (et1656 : t1656 = s16) (et1653 : t1653 = s15)
    (et1680 : t1680 = s22) (et1775 : t1775 = carry14) (et1797 : t1797 = carry13)
    (et1676 : t1676 = s21) (et1650 : t1650 = s14) (et1672 : t1672 = s20) (et1646 : t1646 = s13)
    (et1766 : t1766 = carry12) (et1894 : t1894 = carry6_1) (et1918 : t1918 = carry5)
    (et1969 : t1969 = carry5_1) (et1972 : t1972 = carry6_2) (hs13_1 : s13_1 = s13 + s23 * 654183#64)
    (hs14_1 : s14_1 = s14 - s23 * 997805#64) (hs15_1 : s15_1 = s15 + s23 * 136657#64)
    (hs16_1 : s16_1 = s16 - s23 * 683901#64) (hs13_2 : s13_2 = s13_1 - s22 * 997805#64)
    (hs14_2 : s14_2 = s14_1 + s22 * 136657#64) (hs15_2 : s15_2 = s15_1 - s22 * 683901#64)
    (hs13_3 : s13_3 = s13_2 + s21 * 136657#64) (hs14_3 : s14_3 = s14_2 - s21 * 683901#64)
    (hs13_4 : s13_4 = s13_3 - s20 * 683901#64) (hs6_1 : s6_1 = s6 + s18 * 666643#64)
    (hs6_2 : s6_2 = s6_1 - carry6 <<< 21) (hs13_5 : s13_5 = s13_4 + carry12)
    (hs15_3 : s15_3 = s15_2 + carry14) (hs14_4 : s14_4 = s14_3 - carry14 <<< 21)
    (hs17_1 : s17_1 = s17 + carry16) (hs16_2 : s16_2 = s16_1 - carry16 <<< 21)
    (hs14_5 : s14_5 = s14_4 + carry13) (hs13_6 : s13_6 = s13_5 - carry13 <<< 21)
    (hs16_3 : s16_3 = s16_2 + carry15) (hs15_4 : s15_4 = s15_3 - carry15 <<< 21)
    (hs6_3 : s6_3 = s6_2 + s17_1 * 470296#64) (hs6_4 : s6_4 = s6_3 + s16_3 * 654183#64)
    (hs6_5 : s6_5 = s6_4 - s15_4 * 997805#64) (hs6_6 : s6_6 = s6_5 + s14_5 * 136657#64)
    (hs6_7 : s6_7 = s6_6 - s13_6 * 683901#64) (hs6_8 : s6_8 = s6_7 - carry6_1 <<< 21)
    (hs6_9 : s6_9 = s6_8 + carry5) (hs6_10 : s6_10 = s6_9 + carry5_1)
    (hs6_11 : s6_11 = s6_10 - carry6_2 <<< 21) (hs6_12 : s6_12 = s6_11 + carry5_2)
    (hcarry6_3 : carry6_3 = s6_12.sshiftRight 21) : t2018 = carry6_3 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `s7_13` as the C computes it is the compiled `%2019`. -/
theorem sc25519_reduce.bridge_s7_13
    (t1687 t1688 t1689 t1690 t1691 t1696 t1697 t1698 t1704 t1705 t1706 t1707 t1714 t1727 t1742 t1743
      t1744 t1776 t1777 t1778 t1781 t1782 t1783 t1786 t1787 t1798 t1803 t1804 t1805 t1810 t1811
      t1824 t1825 t1836 t1837 t1854 t1855 t1895 t1924 t1925 t1973 t1977 t2019 t2018 t1972 t1664
      t1623 t1668 t1741 t1785 t1780 t1660 t1802 t1683 t1656 t1653 t1680 t1775 t1797 t1676 t1650
      t1894 t1922 t1975 s14_1 s15_1 s16_1 s14_2 s15_2 s14_3 s7_1 s7_2 s7_3 s15_3 s14_4 s17_1 s16_2
      s7_4 s14_5 s16_3 s15_4 s7_5 s7_6 s7_7 s7_8 s7_9 s7_10 s7_11 s7_12 s7_13 s7 s14 s15 s16 s17 s18
      s19 s21 s22 s23 carry6 carry14 carry16 carry7 carry13 carry15 carry6_1 carry7_1 carry6_2
      carry7_2 carry6_3 : BitVec 64)
    (ht1687 : t1687 = t1683 * 18446744073708553811#64) (ht1688 : t1688 = t1683 * 136657#64)
    (ht1689 : t1689 = t1688 + t1653) (ht1690 : t1690 = t1683 * 18446744073708867715#64)
    (ht1691 : t1691 = t1690 + t1656) (ht1696 : t1696 = t1680 * 136657#64)
    (ht1697 : t1697 = t1680 * 18446744073708867715#64) (ht1698 : t1698 = t1689 + t1697)
    (ht1704 : t1704 = t1676 * 18446744073708867715#64) (ht1705 : t1705 = t1704 + t1650)
    (ht1706 : t1706 = t1705 + t1687) (ht1707 : t1707 = t1706 + t1696)
    (ht1714 : t1714 = t1668 * 666643#64) (ht1727 : t1727 = t1664 * 470296#64)
    (ht1742 : t1742 = t1727 + t1623) (ht1743 : t1743 = t1742 + t1714)
    (ht1744 : t1744 = t1743 + t1741) (ht1776 : t1776 = t1698 + t1775)
    (ht1777 : t1777 = t1775 <<< 21) (ht1778 : t1778 = t1707 - t1777)
    (ht1781 : t1781 = t1780 + t1660) (ht1782 : t1782 = t1780 <<< 21)
    (ht1783 : t1783 = t1691 - t1782) (ht1786 : t1786 = t1785 <<< 21)
    (ht1787 : t1787 = t1744 - t1786) (ht1798 : t1798 = t1797 + t1778)
    (ht1803 : t1803 = t1802 + t1783) (ht1804 : t1804 = t1802 <<< 21)
    (ht1805 : t1805 = t1776 - t1804) (ht1810 : t1810 = t1781 * 654183#64)
    (ht1811 : t1811 = t1787 + t1810) (ht1824 : t1824 = t1803 * 18446744073708553811#64)
    (ht1825 : t1825 = t1811 + t1824) (ht1836 : t1836 = t1805 * 136657#64)
    (ht1837 : t1837 = t1825 + t1836) (ht1854 : t1854 = t1798 * 18446744073708867715#64)
    (ht1855 : t1855 = t1837 + t1854) (ht1895 : t1895 = t1855 + t1894)
    (ht1924 : t1924 = t1922 <<< 21) (ht1925 : t1925 = t1895 - t1924)
    (ht1973 : t1973 = t1972 + t1925) (ht1977 : t1977 = t1973 - t1975 <<< 21)
    (ht2019 : t2019 = t2018 + t1977) (et2018 : t2018 = carry6_3) (et1972 : t1972 = carry6_2)
    (et1664 : t1664 = s18) (et1623 : t1623 = s7) (et1668 : t1668 = s19) (et1741 : t1741 = carry6)
    (et1785 : t1785 = carry7) (et1780 : t1780 = carry16) (et1660 : t1660 = s17)
    (et1802 : t1802 = carry15) (et1683 : t1683 = s23) (et1656 : t1656 = s16) (et1653 : t1653 = s15)
    (et1680 : t1680 = s22) (et1775 : t1775 = carry14) (et1797 : t1797 = carry13)
    (et1676 : t1676 = s21) (et1650 : t1650 = s14) (et1894 : t1894 = carry6_1)
    (et1922 : t1922 = carry7_1) (et1975 : t1975 = carry7_2) (hs14_1 : s14_1 = s14 - s23 * 997805#64)
    (hs15_1 : s15_1 = s15 + s23 * 136657#64) (hs16_1 : s16_1 = s16 - s23 * 683901#64)
    (hs14_2 : s14_2 = s14_1 + s22 * 136657#64) (hs15_2 : s15_2 = s15_1 - s22 * 683901#64)
    (hs14_3 : s14_3 = s14_2 - s21 * 683901#64) (hs7_1 : s7_1 = s7 + s19 * 666643#64)
    (hs7_2 : s7_2 = s7_1 + s18 * 470296#64) (hs7_3 : s7_3 = s7_2 + carry6)
    (hs15_3 : s15_3 = s15_2 + carry14) (hs14_4 : s14_4 = s14_3 - carry14 <<< 21)
    (hs17_1 : s17_1 = s17 + carry16) (hs16_2 : s16_2 = s16_1 - carry16 <<< 21)
    (hs7_4 : s7_4 = s7_3 - carry7 <<< 21) (hs14_5 : s14_5 = s14_4 + carry13)
    (hs16_3 : s16_3 = s16_2 + carry15) (hs15_4 : s15_4 = s15_3 - carry15 <<< 21)
    (hs7_5 : s7_5 = s7_4 + s17_1 * 654183#64) (hs7_6 : s7_6 = s7_5 - s16_3 * 997805#64)
    (hs7_7 : s7_7 = s7_6 + s15_4 * 136657#64) (hs7_8 : s7_8 = s7_7 - s14_5 * 683901#64)
    (hs7_9 : s7_9 = s7_8 + carry6_1) (hs7_10 : s7_10 = s7_9 - carry7_1 <<< 21)
    (hs7_11 : s7_11 = s7_10 + carry6_2) (hs7_12 : s7_12 = s7_11 - carry7_2 <<< 21)
    (hs7_13 : s7_13 = s7_12 + carry6_3) : t2019 = s7_13 := by
  subst_vars
  grind

/-- `s6_13` as the C computes it is the compiled `%2020`. -/
theorem sc25519_reduce.bridge_s6_13
    (t1686 t1687 t1688 t1689 t1690 t1691 t1695 t1696 t1697 t1698 t1703 t1704 t1705 t1706 t1707 t1713
      t1725 t1726 t1745 t1746 t1767 t1768 t1769 t1770 t1771 t1776 t1777 t1778 t1781 t1782 t1783
      t1798 t1799 t1800 t1803 t1804 t1805 t1808 t1809 t1822 t1823 t1834 t1835 t1852 t1853 t1866
      t1867 t1896 t1897 t1919 t1970 t1974 t2016 t2020 t2015 t1664 t1620 t1741 t1780 t1660 t1802
      t1683 t1656 t1653 t1680 t1775 t1797 t1676 t1650 t1672 t1646 t1766 t1894 t1918 t1969 t1972
      t2018 s13_1 s14_1 s15_1 s16_1 s13_2 s14_2 s15_2 s13_3 s14_3 s13_4 s6_1 s6_2 s13_5 s15_3 s14_4
      s17_1 s16_2 s14_5 s13_6 s16_3 s15_4 s6_3 s6_4 s6_5 s6_6 s6_7 s6_8 s6_9 s6_10 s6_11 s6_12 s6_13
      s6 s13 s14 s15 s16 s17 s18 s20 s21 s22 s23 carry6 carry12 carry14 carry16 carry13 carry15
      carry6_1 carry5 carry5_1 carry6_2 carry5_2 carry6_3 : BitVec 64)
    (ht1686 : t1686 = t1683 * 654183#64) (ht1687 : t1687 = t1683 * 18446744073708553811#64)
    (ht1688 : t1688 = t1683 * 136657#64) (ht1689 : t1689 = t1688 + t1653)
    (ht1690 : t1690 = t1683 * 18446744073708867715#64) (ht1691 : t1691 = t1690 + t1656)
    (ht1695 : t1695 = t1680 * 18446744073708553811#64) (ht1696 : t1696 = t1680 * 136657#64)
    (ht1697 : t1697 = t1680 * 18446744073708867715#64) (ht1698 : t1698 = t1689 + t1697)
    (ht1703 : t1703 = t1676 * 136657#64) (ht1704 : t1704 = t1676 * 18446744073708867715#64)
    (ht1705 : t1705 = t1704 + t1650) (ht1706 : t1706 = t1705 + t1687)
    (ht1707 : t1707 = t1706 + t1696) (ht1713 : t1713 = t1672 * 18446744073708867715#64)
    (ht1725 : t1725 = t1664 * 666643#64) (ht1726 : t1726 = t1725 + t1620)
    (ht1745 : t1745 = t1741 <<< 21) (ht1746 : t1746 = t1726 - t1745)
    (ht1767 : t1767 = t1713 + t1646) (ht1768 : t1768 = t1767 + t1703)
    (ht1769 : t1769 = t1768 + t1686) (ht1770 : t1770 = t1769 + t1695)
    (ht1771 : t1771 = t1770 + t1766) (ht1776 : t1776 = t1698 + t1775)
    (ht1777 : t1777 = t1775 <<< 21) (ht1778 : t1778 = t1707 - t1777)
    (ht1781 : t1781 = t1780 + t1660) (ht1782 : t1782 = t1780 <<< 21)
    (ht1783 : t1783 = t1691 - t1782) (ht1798 : t1798 = t1797 + t1778)
    (ht1799 : t1799 = t1797 <<< 21) (ht1800 : t1800 = t1771 - t1799)
    (ht1803 : t1803 = t1802 + t1783) (ht1804 : t1804 = t1802 <<< 21)
    (ht1805 : t1805 = t1776 - t1804) (ht1808 : t1808 = t1781 * 470296#64)
    (ht1809 : t1809 = t1746 + t1808) (ht1822 : t1822 = t1803 * 654183#64)
    (ht1823 : t1823 = t1809 + t1822) (ht1834 : t1834 = t1805 * 18446744073708553811#64)
    (ht1835 : t1835 = t1823 + t1834) (ht1852 : t1852 = t1798 * 136657#64)
    (ht1853 : t1853 = t1835 + t1852) (ht1866 : t1866 = t1800 * 18446744073708867715#64)
    (ht1867 : t1867 = t1853 + t1866) (ht1896 : t1896 = t1894 <<< 21)
    (ht1897 : t1897 = t1867 - t1896) (ht1919 : t1919 = t1897 + t1918)
    (ht1970 : t1970 = t1919 + t1969) (ht1974 : t1974 = t1970 - t1972 <<< 21)
    (ht2016 : t2016 = t2015 + t1974) (ht2020 : t2020 = t2016 - t2018 <<< 21)
    (et2015 : t2015 = carry5_2) (et1664 : t1664 = s18) (et1620 : t1620 = s6)
    (et1741 : t1741 = carry6) (et1780 : t1780 = carry16) (et1660 : t1660 = s17)
    (et1802 : t1802 = carry15) (et1683 : t1683 = s23) (et1656 : t1656 = s16) (et1653 : t1653 = s15)
    (et1680 : t1680 = s22) (et1775 : t1775 = carry14) (et1797 : t1797 = carry13)
    (et1676 : t1676 = s21) (et1650 : t1650 = s14) (et1672 : t1672 = s20) (et1646 : t1646 = s13)
    (et1766 : t1766 = carry12) (et1894 : t1894 = carry6_1) (et1918 : t1918 = carry5)
    (et1969 : t1969 = carry5_1) (et1972 : t1972 = carry6_2) (et2018 : t2018 = carry6_3)
    (hs13_1 : s13_1 = s13 + s23 * 654183#64) (hs14_1 : s14_1 = s14 - s23 * 997805#64)
    (hs15_1 : s15_1 = s15 + s23 * 136657#64) (hs16_1 : s16_1 = s16 - s23 * 683901#64)
    (hs13_2 : s13_2 = s13_1 - s22 * 997805#64) (hs14_2 : s14_2 = s14_1 + s22 * 136657#64)
    (hs15_2 : s15_2 = s15_1 - s22 * 683901#64) (hs13_3 : s13_3 = s13_2 + s21 * 136657#64)
    (hs14_3 : s14_3 = s14_2 - s21 * 683901#64) (hs13_4 : s13_4 = s13_3 - s20 * 683901#64)
    (hs6_1 : s6_1 = s6 + s18 * 666643#64) (hs6_2 : s6_2 = s6_1 - carry6 <<< 21)
    (hs13_5 : s13_5 = s13_4 + carry12) (hs15_3 : s15_3 = s15_2 + carry14)
    (hs14_4 : s14_4 = s14_3 - carry14 <<< 21) (hs17_1 : s17_1 = s17 + carry16)
    (hs16_2 : s16_2 = s16_1 - carry16 <<< 21) (hs14_5 : s14_5 = s14_4 + carry13)
    (hs13_6 : s13_6 = s13_5 - carry13 <<< 21) (hs16_3 : s16_3 = s16_2 + carry15)
    (hs15_4 : s15_4 = s15_3 - carry15 <<< 21) (hs6_3 : s6_3 = s6_2 + s17_1 * 470296#64)
    (hs6_4 : s6_4 = s6_3 + s16_3 * 654183#64) (hs6_5 : s6_5 = s6_4 - s15_4 * 997805#64)
    (hs6_6 : s6_6 = s6_5 + s14_5 * 136657#64) (hs6_7 : s6_7 = s6_6 - s13_6 * 683901#64)
    (hs6_8 : s6_8 = s6_7 - carry6_1 <<< 21) (hs6_9 : s6_9 = s6_8 + carry5)
    (hs6_10 : s6_10 = s6_9 + carry5_1) (hs6_11 : s6_11 = s6_10 - carry6_2 <<< 21)
    (hs6_12 : s6_12 = s6_11 + carry5_2) (hs6_13 : s6_13 = s6_12 - carry6_3 <<< 21) :
    t2020 = s6_13 := by
  subst_vars
  grind

/-- `carry7_3` as the C computes it is the compiled `%2021`. -/
theorem sc25519_reduce.bridge_carry7_3
    (t1687 t1688 t1689 t1690 t1691 t1696 t1697 t1698 t1704 t1705 t1706 t1707 t1714 t1727 t1742 t1743
      t1744 t1776 t1777 t1778 t1781 t1782 t1783 t1786 t1787 t1798 t1803 t1804 t1805 t1810 t1811
      t1824 t1825 t1836 t1837 t1854 t1855 t1895 t1924 t1925 t1973 t1977 t2019 t2021 t2018 t1972
      t1664 t1623 t1668 t1741 t1785 t1780 t1660 t1802 t1683 t1656 t1653 t1680 t1775 t1797 t1676
      t1650 t1894 t1922 t1975 s14_1 s15_1 s16_1 s14_2 s15_2 s14_3 s7_1 s7_2 s7_3 s15_3 s14_4 s17_1
      s16_2 s7_4 s14_5 s16_3 s15_4 s7_5 s7_6 s7_7 s7_8 s7_9 s7_10 s7_11 s7_12 s7_13 carry7_3 s7 s14
      s15 s16 s17 s18 s19 s21 s22 s23 carry6 carry14 carry16 carry7 carry13 carry15 carry6_1
      carry7_1 carry6_2 carry7_2 carry6_3 : BitVec 64)
    (ht1687 : t1687 = t1683 * 18446744073708553811#64) (ht1688 : t1688 = t1683 * 136657#64)
    (ht1689 : t1689 = t1688 + t1653) (ht1690 : t1690 = t1683 * 18446744073708867715#64)
    (ht1691 : t1691 = t1690 + t1656) (ht1696 : t1696 = t1680 * 136657#64)
    (ht1697 : t1697 = t1680 * 18446744073708867715#64) (ht1698 : t1698 = t1689 + t1697)
    (ht1704 : t1704 = t1676 * 18446744073708867715#64) (ht1705 : t1705 = t1704 + t1650)
    (ht1706 : t1706 = t1705 + t1687) (ht1707 : t1707 = t1706 + t1696)
    (ht1714 : t1714 = t1668 * 666643#64) (ht1727 : t1727 = t1664 * 470296#64)
    (ht1742 : t1742 = t1727 + t1623) (ht1743 : t1743 = t1742 + t1714)
    (ht1744 : t1744 = t1743 + t1741) (ht1776 : t1776 = t1698 + t1775)
    (ht1777 : t1777 = t1775 <<< 21) (ht1778 : t1778 = t1707 - t1777)
    (ht1781 : t1781 = t1780 + t1660) (ht1782 : t1782 = t1780 <<< 21)
    (ht1783 : t1783 = t1691 - t1782) (ht1786 : t1786 = t1785 <<< 21)
    (ht1787 : t1787 = t1744 - t1786) (ht1798 : t1798 = t1797 + t1778)
    (ht1803 : t1803 = t1802 + t1783) (ht1804 : t1804 = t1802 <<< 21)
    (ht1805 : t1805 = t1776 - t1804) (ht1810 : t1810 = t1781 * 654183#64)
    (ht1811 : t1811 = t1787 + t1810) (ht1824 : t1824 = t1803 * 18446744073708553811#64)
    (ht1825 : t1825 = t1811 + t1824) (ht1836 : t1836 = t1805 * 136657#64)
    (ht1837 : t1837 = t1825 + t1836) (ht1854 : t1854 = t1798 * 18446744073708867715#64)
    (ht1855 : t1855 = t1837 + t1854) (ht1895 : t1895 = t1855 + t1894)
    (ht1924 : t1924 = t1922 <<< 21) (ht1925 : t1925 = t1895 - t1924)
    (ht1973 : t1973 = t1972 + t1925) (ht1977 : t1977 = t1973 - t1975 <<< 21)
    (ht2019 : t2019 = t2018 + t1977) (ht2021 : t2021 = t2019.sshiftRight 21)
    (et2018 : t2018 = carry6_3) (et1972 : t1972 = carry6_2) (et1664 : t1664 = s18)
    (et1623 : t1623 = s7) (et1668 : t1668 = s19) (et1741 : t1741 = carry6) (et1785 : t1785 = carry7)
    (et1780 : t1780 = carry16) (et1660 : t1660 = s17) (et1802 : t1802 = carry15)
    (et1683 : t1683 = s23) (et1656 : t1656 = s16) (et1653 : t1653 = s15) (et1680 : t1680 = s22)
    (et1775 : t1775 = carry14) (et1797 : t1797 = carry13) (et1676 : t1676 = s21)
    (et1650 : t1650 = s14) (et1894 : t1894 = carry6_1) (et1922 : t1922 = carry7_1)
    (et1975 : t1975 = carry7_2) (hs14_1 : s14_1 = s14 - s23 * 997805#64)
    (hs15_1 : s15_1 = s15 + s23 * 136657#64) (hs16_1 : s16_1 = s16 - s23 * 683901#64)
    (hs14_2 : s14_2 = s14_1 + s22 * 136657#64) (hs15_2 : s15_2 = s15_1 - s22 * 683901#64)
    (hs14_3 : s14_3 = s14_2 - s21 * 683901#64) (hs7_1 : s7_1 = s7 + s19 * 666643#64)
    (hs7_2 : s7_2 = s7_1 + s18 * 470296#64) (hs7_3 : s7_3 = s7_2 + carry6)
    (hs15_3 : s15_3 = s15_2 + carry14) (hs14_4 : s14_4 = s14_3 - carry14 <<< 21)
    (hs17_1 : s17_1 = s17 + carry16) (hs16_2 : s16_2 = s16_1 - carry16 <<< 21)
    (hs7_4 : s7_4 = s7_3 - carry7 <<< 21) (hs14_5 : s14_5 = s14_4 + carry13)
    (hs16_3 : s16_3 = s16_2 + carry15) (hs15_4 : s15_4 = s15_3 - carry15 <<< 21)
    (hs7_5 : s7_5 = s7_4 + s17_1 * 654183#64) (hs7_6 : s7_6 = s7_5 - s16_3 * 997805#64)
    (hs7_7 : s7_7 = s7_6 + s15_4 * 136657#64) (hs7_8 : s7_8 = s7_7 - s14_5 * 683901#64)
    (hs7_9 : s7_9 = s7_8 + carry6_1) (hs7_10 : s7_10 = s7_9 - carry7_1 <<< 21)
    (hs7_11 : s7_11 = s7_10 + carry6_2) (hs7_12 : s7_12 = s7_11 - carry7_2 <<< 21)
    (hs7_13 : s7_13 = s7_12 + carry6_3) (hcarry7_3 : carry7_3 = s7_13.sshiftRight 21) :
    t2021 = carry7_3 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `s8_13` as the C computes it is the compiled `%2022`. -/
theorem sc25519_reduce.bridge_s8_13
    (t1688 t1689 t1690 t1691 t1697 t1698 t1708 t1715 t1728 t1729 t1730 t1731 t1754 t1776 t1781 t1782
      t1783 t1803 t1804 t1805 t1812 t1826 t1838 t1839 t1840 t1841 t1842 t1843 t1904 t1905 t1923
      t1976 t1980 t2022 t2021 t1785 t1664 t1626 t1668 t1672 t1748 t1780 t1660 t1802 t1683 t1656
      t1653 t1680 t1775 t1899 t1922 t1975 t1978 s15_1 s16_1 s15_2 s8_1 s8_2 s8_3 s8_4 s15_3 s17_1
      s16_2 s8_5 s16_3 s15_4 s8_6 s8_7 s8_8 s8_9 s8_10 s8_11 s8_12 s8_13 s8 s15 s16 s17 s18 s19 s20
      s22 s23 carry8 carry14 carry16 carry7 carry15 carry8_1 carry7_1 carry7_2 carry8_2 carry7_3 :
      BitVec 64)
    (ht1688 : t1688 = t1683 * 136657#64) (ht1689 : t1689 = t1688 + t1653)
    (ht1690 : t1690 = t1683 * 18446744073708867715#64) (ht1691 : t1691 = t1690 + t1656)
    (ht1697 : t1697 = t1680 * 18446744073708867715#64) (ht1698 : t1698 = t1689 + t1697)
    (ht1708 : t1708 = t1672 * 666643#64) (ht1715 : t1715 = t1668 * 470296#64)
    (ht1728 : t1728 = t1664 * 654183#64) (ht1729 : t1729 = t1728 + t1626)
    (ht1730 : t1730 = t1729 + t1715) (ht1731 : t1731 = t1730 + t1708)
    (ht1754 : t1754 = t1748 <<< 21) (ht1776 : t1776 = t1698 + t1775)
    (ht1781 : t1781 = t1780 + t1660) (ht1782 : t1782 = t1780 <<< 21)
    (ht1783 : t1783 = t1691 - t1782) (ht1803 : t1803 = t1802 + t1783)
    (ht1804 : t1804 = t1802 <<< 21) (ht1805 : t1805 = t1776 - t1804)
    (ht1812 : t1812 = t1781 * 18446744073708553811#64) (ht1826 : t1826 = t1803 * 136657#64)
    (ht1838 : t1838 = t1805 * 18446744073708867715#64) (ht1839 : t1839 = t1785 + t1731)
    (ht1840 : t1840 = t1839 - t1754) (ht1841 : t1841 = t1840 + t1812)
    (ht1842 : t1842 = t1841 + t1826) (ht1843 : t1843 = t1842 + t1838)
    (ht1904 : t1904 = t1899 <<< 21) (ht1905 : t1905 = t1843 - t1904)
    (ht1923 : t1923 = t1905 + t1922) (ht1976 : t1976 = t1923 + t1975)
    (ht1980 : t1980 = t1976 - t1978 <<< 21) (ht2022 : t2022 = t2021 + t1980)
    (et2021 : t2021 = carry7_3) (et1785 : t1785 = carry7) (et1664 : t1664 = s18)
    (et1626 : t1626 = s8) (et1668 : t1668 = s19) (et1672 : t1672 = s20) (et1748 : t1748 = carry8)
    (et1780 : t1780 = carry16) (et1660 : t1660 = s17) (et1802 : t1802 = carry15)
    (et1683 : t1683 = s23) (et1656 : t1656 = s16) (et1653 : t1653 = s15) (et1680 : t1680 = s22)
    (et1775 : t1775 = carry14) (et1899 : t1899 = carry8_1) (et1922 : t1922 = carry7_1)
    (et1975 : t1975 = carry7_2) (et1978 : t1978 = carry8_2) (hs15_1 : s15_1 = s15 + s23 * 136657#64)
    (hs16_1 : s16_1 = s16 - s23 * 683901#64) (hs15_2 : s15_2 = s15_1 - s22 * 683901#64)
    (hs8_1 : s8_1 = s8 + s20 * 666643#64) (hs8_2 : s8_2 = s8_1 + s19 * 470296#64)
    (hs8_3 : s8_3 = s8_2 + s18 * 654183#64) (hs8_4 : s8_4 = s8_3 - carry8 <<< 21)
    (hs15_3 : s15_3 = s15_2 + carry14) (hs17_1 : s17_1 = s17 + carry16)
    (hs16_2 : s16_2 = s16_1 - carry16 <<< 21) (hs8_5 : s8_5 = s8_4 + carry7)
    (hs16_3 : s16_3 = s16_2 + carry15) (hs15_4 : s15_4 = s15_3 - carry15 <<< 21)
    (hs8_6 : s8_6 = s8_5 - s17_1 * 997805#64) (hs8_7 : s8_7 = s8_6 + s16_3 * 136657#64)
    (hs8_8 : s8_8 = s8_7 - s15_4 * 683901#64) (hs8_9 : s8_9 = s8_8 - carry8_1 <<< 21)
    (hs8_10 : s8_10 = s8_9 + carry7_1) (hs8_11 : s8_11 = s8_10 + carry7_2)
    (hs8_12 : s8_12 = s8_11 - carry8_2 <<< 21) (hs8_13 : s8_13 = s8_12 + carry7_3) :
    t2022 = s8_13 := by
  subst_vars
  grind

/-- `carry8_3` as the C computes it is the compiled `%2023`. -/
theorem sc25519_reduce.bridge_carry8_3
    (t1688 t1689 t1690 t1691 t1697 t1698 t1708 t1715 t1728 t1729 t1730 t1731 t1754 t1776 t1781 t1782
      t1783 t1803 t1804 t1805 t1812 t1826 t1838 t1839 t1840 t1841 t1842 t1843 t1904 t1905 t1923
      t1976 t1980 t2022 t2023 t2021 t1785 t1664 t1626 t1668 t1672 t1748 t1780 t1660 t1802 t1683
      t1656 t1653 t1680 t1775 t1899 t1922 t1975 t1978 s15_1 s16_1 s15_2 s8_1 s8_2 s8_3 s8_4 s15_3
      s17_1 s16_2 s8_5 s16_3 s15_4 s8_6 s8_7 s8_8 s8_9 s8_10 s8_11 s8_12 s8_13 carry8_3 s8 s15 s16
      s17 s18 s19 s20 s22 s23 carry8 carry14 carry16 carry7 carry15 carry8_1 carry7_1 carry7_2
      carry8_2 carry7_3 : BitVec 64)
    (ht1688 : t1688 = t1683 * 136657#64) (ht1689 : t1689 = t1688 + t1653)
    (ht1690 : t1690 = t1683 * 18446744073708867715#64) (ht1691 : t1691 = t1690 + t1656)
    (ht1697 : t1697 = t1680 * 18446744073708867715#64) (ht1698 : t1698 = t1689 + t1697)
    (ht1708 : t1708 = t1672 * 666643#64) (ht1715 : t1715 = t1668 * 470296#64)
    (ht1728 : t1728 = t1664 * 654183#64) (ht1729 : t1729 = t1728 + t1626)
    (ht1730 : t1730 = t1729 + t1715) (ht1731 : t1731 = t1730 + t1708)
    (ht1754 : t1754 = t1748 <<< 21) (ht1776 : t1776 = t1698 + t1775)
    (ht1781 : t1781 = t1780 + t1660) (ht1782 : t1782 = t1780 <<< 21)
    (ht1783 : t1783 = t1691 - t1782) (ht1803 : t1803 = t1802 + t1783)
    (ht1804 : t1804 = t1802 <<< 21) (ht1805 : t1805 = t1776 - t1804)
    (ht1812 : t1812 = t1781 * 18446744073708553811#64) (ht1826 : t1826 = t1803 * 136657#64)
    (ht1838 : t1838 = t1805 * 18446744073708867715#64) (ht1839 : t1839 = t1785 + t1731)
    (ht1840 : t1840 = t1839 - t1754) (ht1841 : t1841 = t1840 + t1812)
    (ht1842 : t1842 = t1841 + t1826) (ht1843 : t1843 = t1842 + t1838)
    (ht1904 : t1904 = t1899 <<< 21) (ht1905 : t1905 = t1843 - t1904)
    (ht1923 : t1923 = t1905 + t1922) (ht1976 : t1976 = t1923 + t1975)
    (ht1980 : t1980 = t1976 - t1978 <<< 21) (ht2022 : t2022 = t2021 + t1980)
    (ht2023 : t2023 = t2022.sshiftRight 21) (et2021 : t2021 = carry7_3) (et1785 : t1785 = carry7)
    (et1664 : t1664 = s18) (et1626 : t1626 = s8) (et1668 : t1668 = s19) (et1672 : t1672 = s20)
    (et1748 : t1748 = carry8) (et1780 : t1780 = carry16) (et1660 : t1660 = s17)
    (et1802 : t1802 = carry15) (et1683 : t1683 = s23) (et1656 : t1656 = s16) (et1653 : t1653 = s15)
    (et1680 : t1680 = s22) (et1775 : t1775 = carry14) (et1899 : t1899 = carry8_1)
    (et1922 : t1922 = carry7_1) (et1975 : t1975 = carry7_2) (et1978 : t1978 = carry8_2)
    (hs15_1 : s15_1 = s15 + s23 * 136657#64) (hs16_1 : s16_1 = s16 - s23 * 683901#64)
    (hs15_2 : s15_2 = s15_1 - s22 * 683901#64) (hs8_1 : s8_1 = s8 + s20 * 666643#64)
    (hs8_2 : s8_2 = s8_1 + s19 * 470296#64) (hs8_3 : s8_3 = s8_2 + s18 * 654183#64)
    (hs8_4 : s8_4 = s8_3 - carry8 <<< 21) (hs15_3 : s15_3 = s15_2 + carry14)
    (hs17_1 : s17_1 = s17 + carry16) (hs16_2 : s16_2 = s16_1 - carry16 <<< 21)
    (hs8_5 : s8_5 = s8_4 + carry7) (hs16_3 : s16_3 = s16_2 + carry15)
    (hs15_4 : s15_4 = s15_3 - carry15 <<< 21) (hs8_6 : s8_6 = s8_5 - s17_1 * 997805#64)
    (hs8_7 : s8_7 = s8_6 + s16_3 * 136657#64) (hs8_8 : s8_8 = s8_7 - s15_4 * 683901#64)
    (hs8_9 : s8_9 = s8_8 - carry8_1 <<< 21) (hs8_10 : s8_10 = s8_9 + carry7_1)
    (hs8_11 : s8_11 = s8_10 + carry7_2) (hs8_12 : s8_12 = s8_11 - carry8_2 <<< 21)
    (hs8_13 : s8_13 = s8_12 + carry7_3) (hcarry8_3 : carry8_3 = s8_13.sshiftRight 21) :
    t2023 = carry8_3 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `s9_13` as the C computes it is the compiled `%2024`. -/
theorem sc25519_reduce.bridge_s9_13
    (t1690 t1691 t1699 t1709 t1716 t1732 t1749 t1750 t1751 t1752 t1753 t1781 t1782 t1783 t1790 t1803
      t1813 t1827 t1900 t1901 t1902 t1903 t1929 t1930 t1979 t1983 t2024 t2023 t1978 t1780 t1660
      t1664 t1630 t1668 t1672 t1676 t1748 t1789 t1802 t1683 t1656 t1899 t1927 t1981 s16_1 s9_1 s9_2
      s9_3 s9_4 s9_5 s17_1 s16_2 s9_6 s16_3 s9_7 s9_8 s9_9 s9_10 s9_11 s9_12 s9_13 s9 s16 s17 s18
      s19 s20 s21 s23 carry8 carry16 carry9 carry15 carry8_1 carry9_1 carry8_2 carry9_2 carry8_3 :
      BitVec 64)
    (ht1690 : t1690 = t1683 * 18446744073708867715#64) (ht1691 : t1691 = t1690 + t1656)
    (ht1699 : t1699 = t1676 * 666643#64) (ht1709 : t1709 = t1672 * 470296#64)
    (ht1716 : t1716 = t1668 * 654183#64) (ht1732 : t1732 = t1664 * 18446744073708553811#64)
    (ht1749 : t1749 = t1732 + t1630) (ht1750 : t1750 = t1749 + t1716)
    (ht1751 : t1751 = t1750 + t1709) (ht1752 : t1752 = t1751 + t1699)
    (ht1753 : t1753 = t1752 + t1748) (ht1781 : t1781 = t1780 + t1660)
    (ht1782 : t1782 = t1780 <<< 21) (ht1783 : t1783 = t1691 - t1782) (ht1790 : t1790 = t1789 <<< 21)
    (ht1803 : t1803 = t1802 + t1783) (ht1813 : t1813 = t1781 * 136657#64)
    (ht1827 : t1827 = t1803 * 18446744073708867715#64) (ht1900 : t1900 = t1813 + t1753)
    (ht1901 : t1901 = t1900 - t1790) (ht1902 : t1902 = t1901 + t1827)
    (ht1903 : t1903 = t1902 + t1899) (ht1929 : t1929 = t1927 <<< 21)
    (ht1930 : t1930 = t1903 - t1929) (ht1979 : t1979 = t1978 + t1930)
    (ht1983 : t1983 = t1979 - t1981 <<< 21) (ht2024 : t2024 = t2023 + t1983)
    (et2023 : t2023 = carry8_3) (et1978 : t1978 = carry8_2) (et1780 : t1780 = carry16)
    (et1660 : t1660 = s17) (et1664 : t1664 = s18) (et1630 : t1630 = s9) (et1668 : t1668 = s19)
    (et1672 : t1672 = s20) (et1676 : t1676 = s21) (et1748 : t1748 = carry8)
    (et1789 : t1789 = carry9) (et1802 : t1802 = carry15) (et1683 : t1683 = s23)
    (et1656 : t1656 = s16) (et1899 : t1899 = carry8_1) (et1927 : t1927 = carry9_1)
    (et1981 : t1981 = carry9_2) (hs16_1 : s16_1 = s16 - s23 * 683901#64)
    (hs9_1 : s9_1 = s9 + s21 * 666643#64) (hs9_2 : s9_2 = s9_1 + s20 * 470296#64)
    (hs9_3 : s9_3 = s9_2 + s19 * 654183#64) (hs9_4 : s9_4 = s9_3 - s18 * 997805#64)
    (hs9_5 : s9_5 = s9_4 + carry8) (hs17_1 : s17_1 = s17 + carry16)
    (hs16_2 : s16_2 = s16_1 - carry16 <<< 21) (hs9_6 : s9_6 = s9_5 - carry9 <<< 21)
    (hs16_3 : s16_3 = s16_2 + carry15) (hs9_7 : s9_7 = s9_6 + s17_1 * 136657#64)
    (hs9_8 : s9_8 = s9_7 - s16_3 * 683901#64) (hs9_9 : s9_9 = s9_8 + carry8_1)
    (hs9_10 : s9_10 = s9_9 - carry9_1 <<< 21) (hs9_11 : s9_11 = s9_10 + carry8_2)
    (hs9_12 : s9_12 = s9_11 - carry9_2 <<< 21) (hs9_13 : s9_13 = s9_12 + carry8_3) :
    t2024 = s9_13 := by
  subst_vars
  grind

/-- `carry9_3` as the C computes it is the compiled `%2025`. -/
theorem sc25519_reduce.bridge_carry9_3
    (t1690 t1691 t1699 t1709 t1716 t1732 t1749 t1750 t1751 t1752 t1753 t1781 t1782 t1783 t1790 t1803
      t1813 t1827 t1900 t1901 t1902 t1903 t1929 t1930 t1979 t1983 t2024 t2025 t2023 t1978 t1780
      t1660 t1664 t1630 t1668 t1672 t1676 t1748 t1789 t1802 t1683 t1656 t1899 t1927 t1981 s16_1 s9_1
      s9_2 s9_3 s9_4 s9_5 s17_1 s16_2 s9_6 s16_3 s9_7 s9_8 s9_9 s9_10 s9_11 s9_12 s9_13 carry9_3 s9
      s16 s17 s18 s19 s20 s21 s23 carry8 carry16 carry9 carry15 carry8_1 carry9_1 carry8_2 carry9_2
      carry8_3 : BitVec 64)
    (ht1690 : t1690 = t1683 * 18446744073708867715#64) (ht1691 : t1691 = t1690 + t1656)
    (ht1699 : t1699 = t1676 * 666643#64) (ht1709 : t1709 = t1672 * 470296#64)
    (ht1716 : t1716 = t1668 * 654183#64) (ht1732 : t1732 = t1664 * 18446744073708553811#64)
    (ht1749 : t1749 = t1732 + t1630) (ht1750 : t1750 = t1749 + t1716)
    (ht1751 : t1751 = t1750 + t1709) (ht1752 : t1752 = t1751 + t1699)
    (ht1753 : t1753 = t1752 + t1748) (ht1781 : t1781 = t1780 + t1660)
    (ht1782 : t1782 = t1780 <<< 21) (ht1783 : t1783 = t1691 - t1782) (ht1790 : t1790 = t1789 <<< 21)
    (ht1803 : t1803 = t1802 + t1783) (ht1813 : t1813 = t1781 * 136657#64)
    (ht1827 : t1827 = t1803 * 18446744073708867715#64) (ht1900 : t1900 = t1813 + t1753)
    (ht1901 : t1901 = t1900 - t1790) (ht1902 : t1902 = t1901 + t1827)
    (ht1903 : t1903 = t1902 + t1899) (ht1929 : t1929 = t1927 <<< 21)
    (ht1930 : t1930 = t1903 - t1929) (ht1979 : t1979 = t1978 + t1930)
    (ht1983 : t1983 = t1979 - t1981 <<< 21) (ht2024 : t2024 = t2023 + t1983)
    (ht2025 : t2025 = t2024.sshiftRight 21) (et2023 : t2023 = carry8_3) (et1978 : t1978 = carry8_2)
    (et1780 : t1780 = carry16) (et1660 : t1660 = s17) (et1664 : t1664 = s18) (et1630 : t1630 = s9)
    (et1668 : t1668 = s19) (et1672 : t1672 = s20) (et1676 : t1676 = s21) (et1748 : t1748 = carry8)
    (et1789 : t1789 = carry9) (et1802 : t1802 = carry15) (et1683 : t1683 = s23)
    (et1656 : t1656 = s16) (et1899 : t1899 = carry8_1) (et1927 : t1927 = carry9_1)
    (et1981 : t1981 = carry9_2) (hs16_1 : s16_1 = s16 - s23 * 683901#64)
    (hs9_1 : s9_1 = s9 + s21 * 666643#64) (hs9_2 : s9_2 = s9_1 + s20 * 470296#64)
    (hs9_3 : s9_3 = s9_2 + s19 * 654183#64) (hs9_4 : s9_4 = s9_3 - s18 * 997805#64)
    (hs9_5 : s9_5 = s9_4 + carry8) (hs17_1 : s17_1 = s17 + carry16)
    (hs16_2 : s16_2 = s16_1 - carry16 <<< 21) (hs9_6 : s9_6 = s9_5 - carry9 <<< 21)
    (hs16_3 : s16_3 = s16_2 + carry15) (hs9_7 : s9_7 = s9_6 + s17_1 * 136657#64)
    (hs9_8 : s9_8 = s9_7 - s16_3 * 683901#64) (hs9_9 : s9_9 = s9_8 + carry8_1)
    (hs9_10 : s9_10 = s9_9 - carry9_1 <<< 21) (hs9_11 : s9_11 = s9_10 + carry8_2)
    (hs9_12 : s9_12 = s9_11 - carry9_2 <<< 21) (hs9_13 : s9_13 = s9_12 + carry8_3)
    (hcarry9_3 : carry9_3 = s9_13.sshiftRight 21) : t2025 = carry9_3 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `s10_13` as the C computes it is the compiled `%2026`. -/
theorem sc25519_reduce.bridge_s10_13
    (t1692 t1700 t1710 t1717 t1733 t1734 t1735 t1736 t1737 t1738 t1764 t1781 t1814 t1815 t1816 t1817
      t1909 t1910 t1928 t1982 t1986 t2026 t2025 t1780 t1660 t1664 t1634 t1668 t1672 t1676 t1680
      t1789 t1756 t1907 t1927 t1981 t1984 s10_1 s10_2 s10_3 s10_4 s10_5 s10_6 s17_1 s10_7 s10_8
      s10_9 s10_10 s10_11 s10_12 s10_13 s10 s17 s18 s19 s20 s21 s22 carry10 carry16 carry9 carry10_1
      carry9_1 carry9_2 carry10_2 carry9_3 : BitVec 64)
    (ht1692 : t1692 = t1680 * 666643#64) (ht1700 : t1700 = t1676 * 470296#64)
    (ht1710 : t1710 = t1672 * 654183#64) (ht1717 : t1717 = t1668 * 18446744073708553811#64)
    (ht1733 : t1733 = t1664 * 136657#64) (ht1734 : t1734 = t1733 + t1634)
    (ht1735 : t1735 = t1734 + t1717) (ht1736 : t1736 = t1735 + t1710)
    (ht1737 : t1737 = t1736 + t1700) (ht1738 : t1738 = t1737 + t1692)
    (ht1764 : t1764 = t1756 <<< 21) (ht1781 : t1781 = t1780 + t1660)
    (ht1814 : t1814 = t1781 * 18446744073708867715#64) (ht1815 : t1815 = t1814 + t1738)
    (ht1816 : t1816 = t1815 + t1789) (ht1817 : t1817 = t1816 - t1764)
    (ht1909 : t1909 = t1907 <<< 21) (ht1910 : t1910 = t1817 - t1909)
    (ht1928 : t1928 = t1910 + t1927) (ht1982 : t1982 = t1928 + t1981)
    (ht1986 : t1986 = t1982 - t1984 <<< 21) (ht2026 : t2026 = t2025 + t1986)
    (et2025 : t2025 = carry9_3) (et1780 : t1780 = carry16) (et1660 : t1660 = s17)
    (et1664 : t1664 = s18) (et1634 : t1634 = s10) (et1668 : t1668 = s19) (et1672 : t1672 = s20)
    (et1676 : t1676 = s21) (et1680 : t1680 = s22) (et1789 : t1789 = carry9)
    (et1756 : t1756 = carry10) (et1907 : t1907 = carry10_1) (et1927 : t1927 = carry9_1)
    (et1981 : t1981 = carry9_2) (et1984 : t1984 = carry10_2)
    (hs10_1 : s10_1 = s10 + s22 * 666643#64) (hs10_2 : s10_2 = s10_1 + s21 * 470296#64)
    (hs10_3 : s10_3 = s10_2 + s20 * 654183#64) (hs10_4 : s10_4 = s10_3 - s19 * 997805#64)
    (hs10_5 : s10_5 = s10_4 + s18 * 136657#64) (hs10_6 : s10_6 = s10_5 - carry10 <<< 21)
    (hs17_1 : s17_1 = s17 + carry16) (hs10_7 : s10_7 = s10_6 + carry9)
    (hs10_8 : s10_8 = s10_7 - s17_1 * 683901#64) (hs10_9 : s10_9 = s10_8 - carry10_1 <<< 21)
    (hs10_10 : s10_10 = s10_9 + carry9_1) (hs10_11 : s10_11 = s10_10 + carry9_2)
    (hs10_12 : s10_12 = s10_11 - carry10_2 <<< 21) (hs10_13 : s10_13 = s10_12 + carry9_3) :
    t2026 = s10_13 := by
  subst_vars
  grind

/-- `s9_14` as the C computes it is the compiled `%2027`. -/
theorem sc25519_reduce.bridge_s9_14
    (t1690 t1691 t1699 t1709 t1716 t1732 t1749 t1750 t1751 t1752 t1753 t1781 t1782 t1783 t1790 t1803
      t1813 t1827 t1900 t1901 t1902 t1903 t1929 t1930 t1979 t1983 t2024 t2027 t2023 t1978 t1780
      t1660 t1664 t1630 t1668 t1672 t1676 t1748 t1789 t1802 t1683 t1656 t1899 t1927 t1981 t2025
      s16_1 s9_1 s9_2 s9_3 s9_4 s9_5 s17_1 s16_2 s9_6 s16_3 s9_7 s9_8 s9_9 s9_10 s9_11 s9_12 s9_13
      s9_14 s9 s16 s17 s18 s19 s20 s21 s23 carry8 carry16 carry9 carry15 carry8_1 carry9_1 carry8_2
      carry9_2 carry8_3 carry9_3 : BitVec 64)
    (ht1690 : t1690 = t1683 * 18446744073708867715#64) (ht1691 : t1691 = t1690 + t1656)
    (ht1699 : t1699 = t1676 * 666643#64) (ht1709 : t1709 = t1672 * 470296#64)
    (ht1716 : t1716 = t1668 * 654183#64) (ht1732 : t1732 = t1664 * 18446744073708553811#64)
    (ht1749 : t1749 = t1732 + t1630) (ht1750 : t1750 = t1749 + t1716)
    (ht1751 : t1751 = t1750 + t1709) (ht1752 : t1752 = t1751 + t1699)
    (ht1753 : t1753 = t1752 + t1748) (ht1781 : t1781 = t1780 + t1660)
    (ht1782 : t1782 = t1780 <<< 21) (ht1783 : t1783 = t1691 - t1782) (ht1790 : t1790 = t1789 <<< 21)
    (ht1803 : t1803 = t1802 + t1783) (ht1813 : t1813 = t1781 * 136657#64)
    (ht1827 : t1827 = t1803 * 18446744073708867715#64) (ht1900 : t1900 = t1813 + t1753)
    (ht1901 : t1901 = t1900 - t1790) (ht1902 : t1902 = t1901 + t1827)
    (ht1903 : t1903 = t1902 + t1899) (ht1929 : t1929 = t1927 <<< 21)
    (ht1930 : t1930 = t1903 - t1929) (ht1979 : t1979 = t1978 + t1930)
    (ht1983 : t1983 = t1979 - t1981 <<< 21) (ht2024 : t2024 = t2023 + t1983)
    (ht2027 : t2027 = t2024 - t2025 <<< 21) (et2023 : t2023 = carry8_3) (et1978 : t1978 = carry8_2)
    (et1780 : t1780 = carry16) (et1660 : t1660 = s17) (et1664 : t1664 = s18) (et1630 : t1630 = s9)
    (et1668 : t1668 = s19) (et1672 : t1672 = s20) (et1676 : t1676 = s21) (et1748 : t1748 = carry8)
    (et1789 : t1789 = carry9) (et1802 : t1802 = carry15) (et1683 : t1683 = s23)
    (et1656 : t1656 = s16) (et1899 : t1899 = carry8_1) (et1927 : t1927 = carry9_1)
    (et1981 : t1981 = carry9_2) (et2025 : t2025 = carry9_3) (hs16_1 : s16_1 = s16 - s23 * 683901#64)
    (hs9_1 : s9_1 = s9 + s21 * 666643#64) (hs9_2 : s9_2 = s9_1 + s20 * 470296#64)
    (hs9_3 : s9_3 = s9_2 + s19 * 654183#64) (hs9_4 : s9_4 = s9_3 - s18 * 997805#64)
    (hs9_5 : s9_5 = s9_4 + carry8) (hs17_1 : s17_1 = s17 + carry16)
    (hs16_2 : s16_2 = s16_1 - carry16 <<< 21) (hs9_6 : s9_6 = s9_5 - carry9 <<< 21)
    (hs16_3 : s16_3 = s16_2 + carry15) (hs9_7 : s9_7 = s9_6 + s17_1 * 136657#64)
    (hs9_8 : s9_8 = s9_7 - s16_3 * 683901#64) (hs9_9 : s9_9 = s9_8 + carry8_1)
    (hs9_10 : s9_10 = s9_9 - carry9_1 <<< 21) (hs9_11 : s9_11 = s9_10 + carry8_2)
    (hs9_12 : s9_12 = s9_11 - carry9_2 <<< 21) (hs9_13 : s9_13 = s9_12 + carry8_3)
    (hs9_14 : s9_14 = s9_13 - carry9_3 <<< 21) : t2027 = s9_14 := by
  subst_vars
  grind

/-- `carry10_3` as the C computes it is the compiled `%2028`. -/
theorem sc25519_reduce.bridge_carry10_3
    (t1692 t1700 t1710 t1717 t1733 t1734 t1735 t1736 t1737 t1738 t1764 t1781 t1814 t1815 t1816 t1817
      t1909 t1910 t1928 t1982 t1986 t2026 t2028 t2025 t1780 t1660 t1664 t1634 t1668 t1672 t1676
      t1680 t1789 t1756 t1907 t1927 t1981 t1984 s10_1 s10_2 s10_3 s10_4 s10_5 s10_6 s17_1 s10_7
      s10_8 s10_9 s10_10 s10_11 s10_12 s10_13 carry10_3 s10 s17 s18 s19 s20 s21 s22 carry10 carry16
      carry9 carry10_1 carry9_1 carry9_2 carry10_2 carry9_3 : BitVec 64)
    (ht1692 : t1692 = t1680 * 666643#64) (ht1700 : t1700 = t1676 * 470296#64)
    (ht1710 : t1710 = t1672 * 654183#64) (ht1717 : t1717 = t1668 * 18446744073708553811#64)
    (ht1733 : t1733 = t1664 * 136657#64) (ht1734 : t1734 = t1733 + t1634)
    (ht1735 : t1735 = t1734 + t1717) (ht1736 : t1736 = t1735 + t1710)
    (ht1737 : t1737 = t1736 + t1700) (ht1738 : t1738 = t1737 + t1692)
    (ht1764 : t1764 = t1756 <<< 21) (ht1781 : t1781 = t1780 + t1660)
    (ht1814 : t1814 = t1781 * 18446744073708867715#64) (ht1815 : t1815 = t1814 + t1738)
    (ht1816 : t1816 = t1815 + t1789) (ht1817 : t1817 = t1816 - t1764)
    (ht1909 : t1909 = t1907 <<< 21) (ht1910 : t1910 = t1817 - t1909)
    (ht1928 : t1928 = t1910 + t1927) (ht1982 : t1982 = t1928 + t1981)
    (ht1986 : t1986 = t1982 - t1984 <<< 21) (ht2026 : t2026 = t2025 + t1986)
    (ht2028 : t2028 = t2026.sshiftRight 21) (et2025 : t2025 = carry9_3) (et1780 : t1780 = carry16)
    (et1660 : t1660 = s17) (et1664 : t1664 = s18) (et1634 : t1634 = s10) (et1668 : t1668 = s19)
    (et1672 : t1672 = s20) (et1676 : t1676 = s21) (et1680 : t1680 = s22) (et1789 : t1789 = carry9)
    (et1756 : t1756 = carry10) (et1907 : t1907 = carry10_1) (et1927 : t1927 = carry9_1)
    (et1981 : t1981 = carry9_2) (et1984 : t1984 = carry10_2)
    (hs10_1 : s10_1 = s10 + s22 * 666643#64) (hs10_2 : s10_2 = s10_1 + s21 * 470296#64)
    (hs10_3 : s10_3 = s10_2 + s20 * 654183#64) (hs10_4 : s10_4 = s10_3 - s19 * 997805#64)
    (hs10_5 : s10_5 = s10_4 + s18 * 136657#64) (hs10_6 : s10_6 = s10_5 - carry10 <<< 21)
    (hs17_1 : s17_1 = s17 + carry16) (hs10_7 : s10_7 = s10_6 + carry9)
    (hs10_8 : s10_8 = s10_7 - s17_1 * 683901#64) (hs10_9 : s10_9 = s10_8 - carry10_1 <<< 21)
    (hs10_10 : s10_10 = s10_9 + carry9_1) (hs10_11 : s10_11 = s10_10 + carry9_2)
    (hs10_12 : s10_12 = s10_11 - carry10_2 <<< 21) (hs10_13 : s10_13 = s10_12 + carry9_3)
    (hcarry10_3 : carry10_3 = s10_13.sshiftRight 21) : t2028 = carry10_3 := by
  subst_vars
  refine congrArg (BitVec.sshiftRight · 21) ?_
  grind

/-- `s11_13` as the C computes it is the compiled `%2029`. -/
theorem sc25519_reduce.bridge_s11_13
    (t1684 t1693 t1701 t1711 t1718 t1739 t1757 t1758 t1759 t1760 t1761 t1762 t1763 t1794 t1795 t1908
      t1933 t1934 t1985 t1988 t2029 t2028 t1984 t1907 t1664 t1638 t1668 t1672 t1676 t1683 t1680
      t1756 t1792 t1932 t1987 s11_1 s11_2 s11_3 s11_4 s11_5 s11_6 s11_7 s11_8 s11_9 s11_10 s11_11
      s11_12 s11_13 s11 s18 s19 s20 s21 s22 s23 carry10 carry11 carry10_1 carry11_1 carry10_2
      carry11_2 carry10_3 : BitVec 64)
    (ht1684 : t1684 = t1683 * 666643#64) (ht1693 : t1693 = t1680 * 470296#64)
    (ht1701 : t1701 = t1676 * 654183#64) (ht1711 : t1711 = t1672 * 18446744073708553811#64)
    (ht1718 : t1718 = t1668 * 136657#64) (ht1739 : t1739 = t1664 * 18446744073708867715#64)
    (ht1757 : t1757 = t1739 + t1638) (ht1758 : t1758 = t1757 + t1718)
    (ht1759 : t1759 = t1758 + t1711) (ht1760 : t1760 = t1759 + t1701)
    (ht1761 : t1761 = t1760 + t1684) (ht1762 : t1762 = t1761 + t1693)
    (ht1763 : t1763 = t1762 + t1756) (ht1794 : t1794 = t1792 <<< 21)
    (ht1795 : t1795 = t1763 - t1794) (ht1908 : t1908 = t1907 + t1795)
    (ht1933 : t1933 = t1932 <<< 21) (ht1934 : t1934 = t1908 - t1933)
    (ht1985 : t1985 = t1984 + t1934) (ht1988 : t1988 = t1985 - t1987 <<< 21)
    (ht2029 : t2029 = t2028 + t1988) (et2028 : t2028 = carry10_3) (et1984 : t1984 = carry10_2)
    (et1907 : t1907 = carry10_1) (et1664 : t1664 = s18) (et1638 : t1638 = s11)
    (et1668 : t1668 = s19) (et1672 : t1672 = s20) (et1676 : t1676 = s21) (et1683 : t1683 = s23)
    (et1680 : t1680 = s22) (et1756 : t1756 = carry10) (et1792 : t1792 = carry11)
    (et1932 : t1932 = carry11_1) (et1987 : t1987 = carry11_2)
    (hs11_1 : s11_1 = s11 + s23 * 666643#64) (hs11_2 : s11_2 = s11_1 + s22 * 470296#64)
    (hs11_3 : s11_3 = s11_2 + s21 * 654183#64) (hs11_4 : s11_4 = s11_3 - s20 * 997805#64)
    (hs11_5 : s11_5 = s11_4 + s19 * 136657#64) (hs11_6 : s11_6 = s11_5 - s18 * 683901#64)
    (hs11_7 : s11_7 = s11_6 + carry10) (hs11_8 : s11_8 = s11_7 - carry11 <<< 21)
    (hs11_9 : s11_9 = s11_8 + carry10_1) (hs11_10 : s11_10 = s11_9 - carry11_1 <<< 21)
    (hs11_11 : s11_11 = s11_10 + carry10_2) (hs11_12 : s11_12 = s11_11 - carry11_2 <<< 21)
    (hs11_13 : s11_13 = s11_12 + carry10_3) : t2029 = s11_13 := by
  subst_vars
  grind

/-- `s10_14` as the C computes it is the compiled `%2030`. -/
theorem sc25519_reduce.bridge_s10_14
    (t1692 t1700 t1710 t1717 t1733 t1734 t1735 t1736 t1737 t1738 t1764 t1781 t1814 t1815 t1816 t1817
      t1909 t1910 t1928 t1982 t1986 t2026 t2030 t2025 t1780 t1660 t1664 t1634 t1668 t1672 t1676
      t1680 t1789 t1756 t1907 t1927 t1981 t1984 t2028 s10_1 s10_2 s10_3 s10_4 s10_5 s10_6 s17_1
      s10_7 s10_8 s10_9 s10_10 s10_11 s10_12 s10_13 s10_14 s10 s17 s18 s19 s20 s21 s22 carry10
      carry16 carry9 carry10_1 carry9_1 carry9_2 carry10_2 carry9_3 carry10_3 : BitVec 64)
    (ht1692 : t1692 = t1680 * 666643#64) (ht1700 : t1700 = t1676 * 470296#64)
    (ht1710 : t1710 = t1672 * 654183#64) (ht1717 : t1717 = t1668 * 18446744073708553811#64)
    (ht1733 : t1733 = t1664 * 136657#64) (ht1734 : t1734 = t1733 + t1634)
    (ht1735 : t1735 = t1734 + t1717) (ht1736 : t1736 = t1735 + t1710)
    (ht1737 : t1737 = t1736 + t1700) (ht1738 : t1738 = t1737 + t1692)
    (ht1764 : t1764 = t1756 <<< 21) (ht1781 : t1781 = t1780 + t1660)
    (ht1814 : t1814 = t1781 * 18446744073708867715#64) (ht1815 : t1815 = t1814 + t1738)
    (ht1816 : t1816 = t1815 + t1789) (ht1817 : t1817 = t1816 - t1764)
    (ht1909 : t1909 = t1907 <<< 21) (ht1910 : t1910 = t1817 - t1909)
    (ht1928 : t1928 = t1910 + t1927) (ht1982 : t1982 = t1928 + t1981)
    (ht1986 : t1986 = t1982 - t1984 <<< 21) (ht2026 : t2026 = t2025 + t1986)
    (ht2030 : t2030 = t2026 - t2028 <<< 21) (et2025 : t2025 = carry9_3) (et1780 : t1780 = carry16)
    (et1660 : t1660 = s17) (et1664 : t1664 = s18) (et1634 : t1634 = s10) (et1668 : t1668 = s19)
    (et1672 : t1672 = s20) (et1676 : t1676 = s21) (et1680 : t1680 = s22) (et1789 : t1789 = carry9)
    (et1756 : t1756 = carry10) (et1907 : t1907 = carry10_1) (et1927 : t1927 = carry9_1)
    (et1981 : t1981 = carry9_2) (et1984 : t1984 = carry10_2) (et2028 : t2028 = carry10_3)
    (hs10_1 : s10_1 = s10 + s22 * 666643#64) (hs10_2 : s10_2 = s10_1 + s21 * 470296#64)
    (hs10_3 : s10_3 = s10_2 + s20 * 654183#64) (hs10_4 : s10_4 = s10_3 - s19 * 997805#64)
    (hs10_5 : s10_5 = s10_4 + s18 * 136657#64) (hs10_6 : s10_6 = s10_5 - carry10 <<< 21)
    (hs17_1 : s17_1 = s17 + carry16) (hs10_7 : s10_7 = s10_6 + carry9)
    (hs10_8 : s10_8 = s10_7 - s17_1 * 683901#64) (hs10_9 : s10_9 = s10_8 - carry10_1 <<< 21)
    (hs10_10 : s10_10 = s10_9 + carry9_1) (hs10_11 : s10_11 = s10_10 + carry9_2)
    (hs10_12 : s10_12 = s10_11 - carry10_2 <<< 21) (hs10_13 : s10_13 = s10_12 + carry9_3)
    (hs10_14 : s10_14 = s10_13 - carry10_3 <<< 21) : t2030 = s10_14 := by
  subst_vars
  grind

/-- The stored bytes, from the C's limbs, are the spec's. -/
theorem sc25519_reduce.out_eq
    {t1990 t2002 t2004 t2005 t2007 t2008 t2010 t2011 t2013 t2014 t2016 t2017 t2019 t2020 t2022 t2024
      t2026 t2027 t2029 t2030 s0_5 s1_9 s2_10 s1_10 s3_11 s2_11 s4_12 s3_12 s5_13 s4_13 s6_12 s5_14
      s7_13 s6_13 s8_13 s9_13 s10_13 s9_14 s11_13 s10_14 carry0_2 s0_6 carry1_2 carry2_2 carry3_2
      carry4_2 carry5_2 carry6_3 carry7_3 s7_14 carry8_3 s8_14 carry9_3 carry10_3 : BitVec 64}
    (e0 : t1990 = s0_5) (e1 : t2002 = s1_9) (e2 : t2004 = s2_10) (e3 : t2005 = s1_10)
    (e4 : t2007 = s3_11) (e5 : t2008 = s2_11) (e6 : t2010 = s4_12) (e7 : t2011 = s3_12)
    (e8 : t2013 = s5_13) (e9 : t2014 = s4_13) (e10 : t2016 = s6_12) (e11 : t2017 = s5_14)
    (e12 : t2019 = s7_13) (e13 : t2020 = s6_13) (e14 : t2022 = s8_13) (e15 : t2024 = s9_13)
    (e16 : t2026 = s10_13) (e17 : t2027 = s9_14) (e18 : t2029 = s11_13) (e19 : t2030 = s10_14)
    (hcarry0_2 : carry0_2 = s0_5.sshiftRight 21) (hs0_6 : s0_6 = s0_5 - carry0_2 <<< 21)
    (hcarry1_2 : carry1_2 = s1_9.sshiftRight 21) (hs1_10 : s1_10 = s1_9 - carry1_2 <<< 21)
    (hcarry2_2 : carry2_2 = s2_10.sshiftRight 21) (hs2_11 : s2_11 = s2_10 - carry2_2 <<< 21)
    (hcarry3_2 : carry3_2 = s3_11.sshiftRight 21) (hs3_12 : s3_12 = s3_11 - carry3_2 <<< 21)
    (hcarry4_2 : carry4_2 = s4_12.sshiftRight 21) (hs4_13 : s4_13 = s4_12 - carry4_2 <<< 21)
    (hcarry5_2 : carry5_2 = s5_13.sshiftRight 21) (hs5_14 : s5_14 = s5_13 - carry5_2 <<< 21)
    (hcarry6_3 : carry6_3 = s6_12.sshiftRight 21) (hs6_13 : s6_13 = s6_12 - carry6_3 <<< 21)
    (hcarry7_3 : carry7_3 = s7_13.sshiftRight 21) (hs7_14 : s7_14 = s7_13 - carry7_3 <<< 21)
    (hcarry8_3 : carry8_3 = s8_13.sshiftRight 21) (hs8_14 : s8_14 = s8_13 - carry8_3 <<< 21)
    (hcarry9_3 : carry9_3 = s9_13.sshiftRight 21) (hs9_14 : s9_14 = s9_13 - carry9_3 <<< 21)
    (hcarry10_3 : carry10_3 = s10_13.sshiftRight 21)
    (hs10_14 : s10_14 = s10_13 - carry10_3 <<< 21) :
    sc25519_reduce.out t1990 t2002 t2004 t2005 t2007 t2008 t2010 t2011 t2013 t2014 t2016 t2017 t2019
        t2020 t2022 t2024 t2026 t2027 t2029 t2030 =
      (s11_13.sshiftRight 17).setWidth 8 ++ (s11_13.sshiftRight 9).setWidth 8 ++
        (s11_13.sshiftRight 1).setWidth 8 ++
        (s10_14.sshiftRight 14 ||| s11_13 <<< 7).setWidth 8 ++
        (s10_14.sshiftRight 6).setWidth 8 ++
        (s9_14.sshiftRight 19 ||| s10_14 <<< 2).setWidth 8 ++
        (s9_14.sshiftRight 11).setWidth 8 ++
        (s9_14.sshiftRight 3).setWidth 8 ++
        (s8_14.sshiftRight 16 ||| s9_14 <<< 5).setWidth 8 ++
        (s8_14.sshiftRight 8).setWidth 8 ++
        s8_14.setWidth 8 ++
        (s7_14.sshiftRight 13).setWidth 8 ++
        (s7_14.sshiftRight 5).setWidth 8 ++
        (s6_13.sshiftRight 18 ||| s7_14 <<< 3).setWidth 8 ++
        (s6_13.sshiftRight 10).setWidth 8 ++
        (s6_13.sshiftRight 2).setWidth 8 ++
        (s5_14.sshiftRight 15 ||| s6_13 <<< 6).setWidth 8 ++
        (s5_14.sshiftRight 7).setWidth 8 ++
        (s4_13.sshiftRight 20 ||| s5_14 <<< 1).setWidth 8 ++
        (s4_13.sshiftRight 12).setWidth 8 ++
        (s4_13.sshiftRight 4).setWidth 8 ++
        (s3_12.sshiftRight 17 ||| s4_13 <<< 4).setWidth 8 ++
        (s3_12.sshiftRight 9).setWidth 8 ++
        (s3_12.sshiftRight 1).setWidth 8 ++
        (s2_11.sshiftRight 14 ||| s3_12 <<< 7).setWidth 8 ++
        (s2_11.sshiftRight 6).setWidth 8 ++
        (s1_10.sshiftRight 19 ||| s2_11 <<< 2).setWidth 8 ++
        (s1_10.sshiftRight 11).setWidth 8 ++
        (s1_10.sshiftRight 3).setWidth 8 ++
        (s0_6.sshiftRight 16 ||| s1_10 <<< 5).setWidth 8 ++
        (s0_6.sshiftRight 8).setWidth 8 ++
        s0_6.setWidth 8 := by
  subst_vars
  unfold sc25519_reduce.out
  bv_decide

/-- The compiled computation is BoringSSL's spec. -/
theorem sc25519_reduce.ir_eq_spec (x : BitVec 512) :
    sc25519_reduce.ir x = Boringssl.x25519_sc_reduce.spec x := by
  unfold sc25519_reduce.ir Boringssl.x25519_sc_reduce.spec
  lift_lets -merge
  intro t1595 t1596 t1598 t1599 t1600 t1602 t1603 t1604 t1606 t1607 t1608 t1610 t1611 t1612 t1614
    t1615 t1616 t1618 t1619 t1620 t1622 t1623 t1625 t1626 t1628 t1629 t1630 t1632 t1633 t1634 t1636
    t1637 t1638 t1640 t1641 t1642 t1644 t1645 t1646 t1648 t1649 t1650 t1652 t1653 t1655 t1656 t1658
    t1659 t1660 t1662 t1663 t1664 t1666 t1667 t1668 t1670 t1671 t1672 t1674 t1675 t1676 t1678 t1679
    t1680 t1682 t1683 t1684 t1685 t1686 t1687 t1688 t1689 t1690 t1691 t1692 t1693 t1694 t1695 t1696
    t1697 t1698 t1699 t1700 t1701 t1702 t1703 t1704 t1705 t1706 t1707 t1708 t1709 t1710 t1711 t1712
    t1713 t1714 t1715 t1716 t1717 t1718 t1719 t1720 t1721 t1722 t1723 t1724 t1725 t1726 t1727 t1728
    t1729 t1730 t1731 t1732 t1733 t1734 t1735 t1736 t1737 t1738 t1739 t1740 t1741 t1742 t1743 t1744
    t1745 t1746 t1747 t1748 t1749 t1750 t1751 t1752 t1753 t1754 t1755 t1756 t1757 t1758 t1759 t1760
    t1761 t1762 t1763 t1764 t1765 t1766 t1767 t1768 t1769 t1770 t1771 t1772 t1773 t1774 t1775 t1776
    t1777 t1778 t1779 t1780 t1781 t1782 t1783 t1784 t1785 t1786 t1787 t1788 t1789 t1790 t1791 t1792
    t1793 t1794 t1795 t1796 t1797 t1798 t1799 t1800 t1801 t1802 t1803 t1804 t1805 t1806 t1807 t1808
    t1809 t1810 t1811 t1812 t1813 t1814 t1815 t1816 t1817 t1818 t1819 t1820 t1821 t1822 t1823 t1824
    t1825 t1826 t1827 t1828 t1829 t1830 t1831 t1832 t1833 t1834 t1835 t1836 t1837 t1838 t1839 t1840
    t1841 t1842 t1843 t1844 t1845 t1846 t1847 t1848 t1849 t1850 t1851 t1852 t1853 t1854 t1855 t1856
    t1857 t1858 t1859 t1860 t1861 t1862 t1863 t1864 t1865 t1866 t1867 t1868 t1869 t1870 t1871 t1872
    t1873 t1874 t1875 t1876 t1877 t1878 t1879 t1880 t1881 t1882 t1883 t1884 t1885 t1886 t1887 t1888
    t1889 t1890 t1891 t1892 t1893 t1894 t1895 t1896 t1897 t1898 t1899 t1900 t1901 t1902 t1903 t1904
    t1905 t1906 t1907 t1908 t1909 t1910 t1911 t1912 t1913 t1914 t1915 t1916 t1917 t1918 t1919 t1920
    t1921 t1922 t1923 t1924 t1925 t1926 t1927 t1928 t1929 t1930 t1931 t1932 t1933 t1934 t1935 t1936
    t1937 t1938 t1939 t1940 t1941 t1942 t1943 t1944 t1945 t1946 t1947 t1948 t1949 t1950 t1951 t1952
    t1953 t1954 t1955 t1956 t1957 t1958 t1959 t1960 t1961 t1962 t1963 t1964 t1965 t1966 t1967 t1968
    t1969 t1970 t1971 t1972 t1973 t1974 t1975 t1976 t1977 t1978 t1979 t1980 t1981 t1982 t1983 t1984
    t1985 t1986 t1987 t1988 t1989 t1990 t1991 t1992 t1993 t1994 t1995 t1996 t1997 t1998 t1999 t2000
    t2001 t2002 t2003 t2004 t2005 t2006 t2007 t2008 t2009 t2010 t2011 t2012 t2013 t2014 t2015 t2016
    t2017 t2018 t2019 t2020 t2021 t2022 t2023 t2024 t2025 t2026 t2027 t2028 t2029 t2030 s0 s1 s2 s3
    s4 s5 s6 s7 s8 s9 s10 s11 s12 s13 s14 s15 s16 s17 s18 s19 s20 s21 s22 s23 s11_1 s12_1 s13_1
    s14_1 s15_1 s16_1 s10_1 s11_2 s12_2 s13_2 s14_2 s15_2 s9_1 s10_2 s11_3 s12_3 s13_3 s14_3 s8_1
    s9_2 s10_3 s11_4 s12_4 s13_4 s7_1 s8_2 s9_3 s10_4 s11_5 s12_5 s6_1 s7_2 s8_3 s9_4 s10_5 s11_6
    carry6 s7_3 s6_2 carry8 s9_5 s8_4 carry10 s11_7 s10_6 carry12 s13_5 s12_6 carry14 s15_3 s14_4
    carry16 s17_1 s16_2 carry7 s8_5 s7_4 carry9 s10_7 s9_6 carry11 s12_7 s11_8 carry13 s14_5 s13_6
    carry15 s16_3 s15_4 s5_1 s6_3 s7_5 s8_6 s9_7 s10_8 s4_1 s5_2 s6_4 s7_6 s8_7 s9_8 s3_1 s4_2 s5_3
    s6_5 s7_7 s8_8 s2_1 s3_2 s4_3 s5_4 s6_6 s7_8 s1_1 s2_2 s3_3 s4_4 s5_5 s6_7 s0_1 s1_2 s2_3 s3_4
    s4_5 s5_6 s12_8 carry0 s1_3 s0_2 carry2 s3_5 s2_4 carry4 s5_7 s4_6 carry6_1 s7_9 s6_8 carry8_1
    s9_9 s8_9 carry10_1 s11_9 s10_9 carry1 s2_5 s1_4 carry3 s4_7 s3_6 carry5 s6_9 s5_8 carry7_1
    s8_10 s7_10 carry9_1 s10_10 s9_10 carry11_1 s12_9 s11_10 s0_3 s1_5 s2_6 s3_7 s4_8 s5_9 s12_10
    carry0_1 s1_6 s0_4 carry1_1 s2_7 s1_7 carry2_1 s3_8 s2_8 carry3_1 s4_9 s3_9 carry4_1 s5_10 s4_10
    carry5_1 s6_10 s5_11 carry6_2 s7_11 s6_11 carry7_2 s8_11 s7_12 carry8_2 s9_11 s8_12 carry9_2
    s10_11 s9_12 carry10_2 s11_11 s10_12 carry11_2 s12_11 s11_12 s0_5 s1_8 s2_9 s3_10 s4_11 s5_12
    carry0_2 s1_9 s0_6 carry1_2 s2_10 s1_10 carry2_2 s3_11 s2_11 carry3_2 s4_12 s3_12 carry4_2 s5_13
    s4_13 carry5_2 s6_12 s5_14 carry6_3 s7_13 s6_13 carry7_3 s8_13 s7_14 carry8_3 s9_13 s8_14
    carry9_3 s10_13 s9_14 carry10_3 s11_13 s10_14 b0 b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13 b14
    b15 b16 b17 b18 b19 b20 b21 b22 b23 b24 b25 b26 b27 b28 b29 b30 b31
  have e1596 : t1596 = s0 := BitVec.and_comm _ _
  have e1600 : t1600 = s1 := BitVec.and_comm _ _
  have e1604 : t1604 = s2 := BitVec.and_comm _ _
  have e1608 : t1608 = s3 := BitVec.and_comm _ _
  have e1612 : t1612 = s4 := BitVec.and_comm _ _
  have e1616 : t1616 = s5 := BitVec.and_comm _ _
  have e1620 : t1620 = s6 := BitVec.and_comm _ _
  have e1623 : t1623 = s7 := nomask3_3 _
  have e1626 : t1626 = s8 := BitVec.and_comm _ _
  have e1630 : t1630 = s9 := BitVec.and_comm _ _
  have e1634 : t1634 = s10 := BitVec.and_comm _ _
  have e1638 : t1638 = s11 := BitVec.and_comm _ _
  have e1642 : t1642 = s12 := BitVec.and_comm _ _
  have e1646 : t1646 = s13 := BitVec.and_comm _ _
  have e1650 : t1650 = s14 := BitVec.and_comm _ _
  have e1653 : t1653 = s15 := nomask3_3 _
  have e1656 : t1656 = s16 := BitVec.and_comm _ _
  have e1660 : t1660 = s17 := BitVec.and_comm _ _
  have e1664 : t1664 = s18 := BitVec.and_comm _ _
  have e1668 : t1668 = s19 := BitVec.and_comm _ _
  have e1672 : t1672 = s20 := BitVec.and_comm _ _
  have e1676 : t1676 = s21 := BitVec.and_comm _ _
  have e1680 : t1680 = s22 := BitVec.and_comm _ _
  have e1683 : t1683 = s23 := rfl
  have n1741 : t1741 = t1740.sshiftRight 21 := sc25519_reduce.lshr1741 x
  have e1741 :=
    sc25519_reduce.bridge_carry6 t1725 t1726 t1740 t1741 t1664 t1620 s6_1 carry6 s6 s18 rfl rfl rfl
      n1741 e1664 e1620 rfl rfl
  have m1745 : t1745 = t1741 <<< 21 := sc25519_reduce.mask1745 x
  have n1748 : t1748 = t1747.sshiftRight 21 := sc25519_reduce.lshr1748 x
  have e1748 :=
    sc25519_reduce.bridge_carry8 t1708 t1715 t1728 t1729 t1730 t1731 t1747 t1748 t1664 t1626 t1668
      t1672 s8_1 s8_2 s8_3 carry8 s8 s18 s19 s20 rfl rfl rfl rfl rfl rfl rfl n1748 e1664 e1626 e1668
      e1672 rfl rfl rfl rfl
  have m1754 : t1754 = t1748 <<< 21 := sc25519_reduce.mask1754 x
  have e1756 :=
    sc25519_reduce.bridge_carry10 t1692 t1700 t1710 t1717 t1733 t1734 t1735 t1736 t1737 t1738 t1755
      t1756 t1664 t1634 t1668 t1672 t1676 t1680 s10_1 s10_2 s10_3 s10_4 s10_5 carry10 s10 s18 s19
      s20 s21 s22 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl e1664 e1634 e1668 e1672 e1676
      e1680 rfl rfl rfl rfl rfl rfl
  have m1764 : t1764 = t1756 <<< 21 := Bnd.and_neg_shift _
  have e1766 :=
    sc25519_reduce.bridge_carry12 t1685 t1694 t1702 t1712 t1719 t1720 t1721 t1722 t1723 t1724 t1765
      t1766 t1668 t1642 t1672 t1676 t1683 t1680 s12_1 s12_2 s12_3 s12_4 s12_5 carry12 s12 s19 s20
      s21 s22 s23 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl e1668 e1642 e1672 e1676 e1683
      e1680 rfl rfl rfl rfl rfl rfl
  have m1772 : t1772 = t1766 <<< 21 := Bnd.and_neg_shift _
  have e1775 :=
    sc25519_reduce.bridge_carry14 t1687 t1696 t1704 t1705 t1706 t1707 t1774 t1775 t1676 t1650 t1683
      t1680 s14_1 s14_2 s14_3 carry14 s14 s21 s22 s23 rfl rfl rfl rfl rfl rfl rfl rfl e1676 e1650
      e1683 e1680 rfl rfl rfl rfl
  have m1777 : t1777 = t1775 <<< 21 := Bnd.and_neg_shift _
  have e1780 :=
    sc25519_reduce.bridge_carry16 t1690 t1691 t1779 t1780 t1683 t1656 s16_1 carry16 s16 s23 rfl rfl
      rfl rfl e1683 e1656 rfl rfl
  have m1782 : t1782 = t1780 <<< 21 := Bnd.and_neg_shift _
  have n1785 : t1785 = t1784.sshiftRight 21 := sc25519_reduce.lshr1785 x
  have e1785 :=
    sc25519_reduce.bridge_carry7 t1714 t1727 t1742 t1743 t1744 t1784 t1785 t1664 t1623 t1668 t1741
      s7_1 s7_2 s7_3 carry7 s7 s18 s19 carry6 rfl rfl rfl rfl rfl rfl n1785 e1664 e1623 e1668 e1741
      rfl rfl rfl rfl
  have m1786 : t1786 = t1785 <<< 21 := sc25519_reduce.mask1786 x
  have e1789 :=
    sc25519_reduce.bridge_carry9 t1699 t1709 t1716 t1732 t1749 t1750 t1751 t1752 t1753 t1788 t1789
      t1664 t1630 t1668 t1672 t1676 t1748 s9_1 s9_2 s9_3 s9_4 s9_5 carry9 s9 s18 s19 s20 s21 carry8
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl e1664 e1630 e1668 e1672 e1676 e1748 rfl rfl rfl
      rfl rfl rfl
  have m1790 : t1790 = t1789 <<< 21 := Bnd.and_neg_shift _
  have e1792 :=
    sc25519_reduce.bridge_carry11 t1684 t1693 t1701 t1711 t1718 t1739 t1757 t1758 t1759 t1760 t1761
      t1762 t1763 t1791 t1792 t1664 t1638 t1668 t1672 t1676 t1683 t1680 t1756 s11_1 s11_2 s11_3
      s11_4 s11_5 s11_6 s11_7 carry11 s11 s18 s19 s20 s21 s22 s23 carry10 rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl e1664 e1638 e1668 e1672 e1676 e1683 e1680 e1756 rfl rfl
      rfl rfl rfl rfl rfl rfl
  have m1794 : t1794 = t1792 <<< 21 := Bnd.and_neg_shift _
  have e1797 :=
    sc25519_reduce.bridge_carry13 t1686 t1695 t1703 t1713 t1767 t1768 t1769 t1770 t1771 t1796 t1797
      t1672 t1646 t1676 t1683 t1680 t1766 s13_1 s13_2 s13_3 s13_4 s13_5 carry13 s13 s20 s21 s22 s23
      carry12 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl e1672 e1646 e1676 e1683 e1680 e1766 rfl
      rfl rfl rfl rfl rfl
  have m1799 : t1799 = t1797 <<< 21 := Bnd.and_neg_shift _
  have e1802 :=
    sc25519_reduce.bridge_carry15 t1688 t1689 t1697 t1698 t1776 t1801 t1802 t1683 t1653 t1680 t1775
      s15_1 s15_2 s15_3 carry15 s15 s22 s23 carry14 rfl rfl rfl rfl rfl rfl rfl e1683 e1653 e1680
      e1775 rfl rfl rfl rfl
  have m1804 : t1804 = t1802 <<< 21 := Bnd.and_neg_shift _
  have e1881 :=
    sc25519_reduce.bridge_carry0 t1685 t1694 t1702 t1712 t1719 t1720 t1721 t1722 t1723 t1724 t1772
      t1773 t1793 t1868 t1869 t1880 t1881 t1792 t1668 t1642 t1672 t1676 t1683 t1680 t1766 t1596
      s12_1 s12_2 s12_3 s12_4 s12_5 s12_6 s12_7 s0_1 carry0 s0 s12 s19 s20 s21 s22 s23 carry12
      carry11 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl m1772 rfl rfl rfl rfl rfl rfl e1792 e1668
      e1642 e1672 e1676 e1683 e1680 e1766 e1596 rfl rfl rfl rfl rfl rfl rfl rfl rfl
  have m1883 : t1883 = t1881 <<< 21 := Bnd.and_neg_shift _
  have e1886 :=
    sc25519_reduce.bridge_carry2 t1685 t1686 t1687 t1694 t1695 t1696 t1702 t1703 t1704 t1705 t1706
      t1707 t1712 t1713 t1719 t1720 t1721 t1722 t1723 t1724 t1767 t1768 t1769 t1770 t1771 t1772
      t1773 t1777 t1778 t1793 t1798 t1799 t1800 t1844 t1845 t1858 t1859 t1872 t1873 t1885 t1886
      t1797 t1676 t1650 t1683 t1680 t1775 t1604 t1672 t1646 t1766 t1792 t1668 t1642 s12_1 s13_1
      s14_1 s12_2 s13_2 s14_2 s12_3 s13_3 s14_3 s12_4 s13_4 s12_5 s13_5 s12_6 s14_4 s12_7 s14_5
      s13_6 s2_1 s2_2 s2_3 carry2 s2 s12 s13 s14 s19 s20 s21 s22 s23 carry12 carry14 carry11 carry13
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl m1772 rfl m1777 rfl rfl rfl m1799 rfl rfl rfl rfl rfl rfl rfl rfl rfl e1797 e1676
      e1650 e1683 e1680 e1775 e1604 e1672 e1646 e1766 e1792 e1668 e1642 rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
  have m1888 : t1888 = t1886 <<< 21 := Bnd.and_neg_shift _
  have e1890 :=
    sc25519_reduce.bridge_carry4 t1685 t1686 t1687 t1688 t1689 t1690 t1691 t1694 t1695 t1696 t1697
      t1698 t1702 t1703 t1704 t1705 t1706 t1707 t1712 t1713 t1719 t1720 t1721 t1722 t1723 t1724
      t1767 t1768 t1769 t1770 t1771 t1772 t1773 t1776 t1777 t1778 t1782 t1783 t1793 t1798 t1799
      t1800 t1803 t1804 t1805 t1818 t1819 t1830 t1831 t1848 t1849 t1862 t1863 t1876 t1877 t1889
      t1890 t1802 t1683 t1656 t1780 t1612 t1653 t1680 t1775 t1797 t1676 t1650 t1672 t1646 t1766
      t1792 t1668 t1642 s12_1 s13_1 s14_1 s15_1 s16_1 s12_2 s13_2 s14_2 s15_2 s12_3 s13_3 s14_3
      s12_4 s13_4 s12_5 s13_5 s12_6 s15_3 s14_4 s16_2 s12_7 s14_5 s13_6 s16_3 s15_4 s4_1 s4_2 s4_3
      s4_4 s4_5 carry4 s4 s12 s13 s14 s15 s16 s19 s20 s21 s22 s23 carry12 carry14 carry16 carry11
      carry13 carry15 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl m1772 rfl rfl m1777 rfl m1782 rfl rfl rfl
      m1799 rfl rfl m1804 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl e1802 e1683 e1656
      e1780 e1612 e1653 e1680 e1775 e1797 e1676 e1650 e1672 e1646 e1766 e1792 e1668 e1642 rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl
  have m1892 : t1892 = t1890 <<< 21 := Bnd.and_neg_shift _
  have e1894 :=
    sc25519_reduce.bridge_carry6_1 t1686 t1687 t1688 t1689 t1690 t1691 t1695 t1696 t1697 t1698 t1703
      t1704 t1705 t1706 t1707 t1713 t1725 t1726 t1745 t1746 t1767 t1768 t1769 t1770 t1771 t1776
      t1777 t1778 t1781 t1782 t1783 t1798 t1799 t1800 t1803 t1804 t1805 t1808 t1809 t1822 t1823
      t1834 t1835 t1852 t1853 t1866 t1867 t1893 t1894 t1664 t1620 t1741 t1780 t1660 t1802 t1683
      t1656 t1653 t1680 t1775 t1797 t1676 t1650 t1672 t1646 t1766 s13_1 s14_1 s15_1 s16_1 s13_2
      s14_2 s15_2 s13_3 s14_3 s13_4 s6_1 s6_2 s13_5 s15_3 s14_4 s17_1 s16_2 s14_5 s13_6 s16_3 s15_4
      s6_3 s6_4 s6_5 s6_6 s6_7 carry6_1 s6 s13 s14 s15 s16 s17 s18 s20 s21 s22 s23 carry6 carry12
      carry14 carry16 carry13 carry15 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl m1745 rfl rfl rfl rfl rfl rfl rfl m1777 rfl rfl m1782 rfl rfl m1799 rfl rfl m1804
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl e1664 e1620 e1741 e1780 e1660 e1802 e1683
      e1656 e1653 e1680 e1775 e1797 e1676 e1650 e1672 e1646 e1766 rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
  have m1896 : t1896 = t1894 <<< 21 := Bnd.and_neg_shift _
  have e1899 :=
    sc25519_reduce.bridge_carry8_1 t1688 t1689 t1690 t1691 t1697 t1698 t1708 t1715 t1728 t1729 t1730
      t1731 t1754 t1776 t1781 t1782 t1783 t1803 t1804 t1805 t1812 t1826 t1838 t1839 t1840 t1841
      t1842 t1843 t1898 t1899 t1785 t1664 t1626 t1668 t1672 t1748 t1780 t1660 t1802 t1683 t1656
      t1653 t1680 t1775 s15_1 s16_1 s15_2 s8_1 s8_2 s8_3 s8_4 s15_3 s17_1 s16_2 s8_5 s16_3 s15_4
      s8_6 s8_7 s8_8 carry8_1 s8 s15 s16 s17 s18 s19 s20 s22 s23 carry8 carry14 carry16 carry7
      carry15 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl m1754 rfl rfl m1782 rfl rfl m1804 rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl e1785 e1664 e1626 e1668 e1672 e1748 e1780 e1660 e1802
      e1683 e1656 e1653 e1680 e1775 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl
  have m1904 : t1904 = t1899 <<< 21 := Bnd.and_neg_shift _
  have e1907 :=
    sc25519_reduce.bridge_carry10_1 t1692 t1700 t1710 t1717 t1733 t1734 t1735 t1736 t1737 t1738
      t1764 t1781 t1814 t1815 t1816 t1817 t1906 t1907 t1780 t1660 t1664 t1634 t1668 t1672 t1676
      t1680 t1789 t1756 s10_1 s10_2 s10_3 s10_4 s10_5 s10_6 s17_1 s10_7 s10_8 carry10_1 s10 s17 s18
      s19 s20 s21 s22 carry10 carry16 carry9 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl m1764 rfl rfl
      rfl rfl rfl rfl rfl e1780 e1660 e1664 e1634 e1668 e1672 e1676 e1680 e1789 e1756 rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl
  have m1909 : t1909 = t1907 <<< 21 := Bnd.and_neg_shift _
  have e1912 :=
    sc25519_reduce.bridge_carry1 t1685 t1686 t1694 t1695 t1702 t1703 t1712 t1713 t1719 t1720 t1721
      t1722 t1723 t1724 t1767 t1768 t1769 t1770 t1771 t1772 t1773 t1793 t1799 t1800 t1856 t1857
      t1870 t1871 t1882 t1911 t1912 t1672 t1646 t1676 t1683 t1680 t1766 t1797 t1600 t1792 t1668
      t1642 t1881 s12_1 s13_1 s12_2 s13_2 s12_3 s13_3 s12_4 s13_4 s12_5 s13_5 s12_6 s12_7 s13_6 s1_1
      s1_2 s1_3 carry1 s1 s12 s13 s19 s20 s21 s22 s23 carry12 carry11 carry13 carry0 rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl m1772 rfl rfl m1799 rfl rfl rfl
      rfl rfl rfl rfl rfl e1672 e1646 e1676 e1683 e1680 e1766 e1797 e1600 e1792 e1668 e1642 e1881
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
  have m1913 : t1913 = t1912 <<< 21 := Bnd.and_neg_shift _
  have e1915 :=
    sc25519_reduce.bridge_carry3 t1685 t1686 t1687 t1688 t1689 t1694 t1695 t1696 t1697 t1698 t1702
      t1703 t1704 t1705 t1706 t1707 t1712 t1713 t1719 t1720 t1721 t1722 t1723 t1724 t1767 t1768
      t1769 t1770 t1771 t1772 t1773 t1776 t1777 t1778 t1793 t1798 t1799 t1800 t1804 t1805 t1828
      t1829 t1846 t1847 t1860 t1861 t1874 t1875 t1887 t1914 t1915 t1683 t1653 t1680 t1775 t1802
      t1608 t1797 t1676 t1650 t1672 t1646 t1766 t1792 t1668 t1642 t1886 s12_1 s13_1 s14_1 s15_1
      s12_2 s13_2 s14_2 s15_2 s12_3 s13_3 s14_3 s12_4 s13_4 s12_5 s13_5 s12_6 s15_3 s14_4 s12_7
      s14_5 s13_6 s15_4 s3_1 s3_2 s3_3 s3_4 s3_5 carry3 s3 s12 s13 s14 s15 s19 s20 s21 s22 s23
      carry12 carry14 carry11 carry13 carry15 carry2 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl m1772 rfl rfl m1777 rfl
      rfl rfl m1799 rfl m1804 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl e1683 e1653 e1680
      e1775 e1802 e1608 e1797 e1676 e1650 e1672 e1646 e1766 e1792 e1668 e1642 e1886 rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl
  have m1916 : t1916 = t1915 <<< 21 := Bnd.and_neg_shift _
  have e1918 :=
    sc25519_reduce.bridge_carry5 t1685 t1686 t1687 t1688 t1689 t1690 t1691 t1694 t1695 t1696 t1697
      t1698 t1702 t1703 t1704 t1705 t1706 t1707 t1712 t1713 t1719 t1720 t1721 t1722 t1723 t1724
      t1767 t1768 t1769 t1770 t1771 t1772 t1773 t1776 t1777 t1778 t1781 t1782 t1783 t1793 t1798
      t1799 t1800 t1803 t1804 t1805 t1806 t1807 t1820 t1821 t1832 t1833 t1850 t1851 t1864 t1865
      t1878 t1879 t1891 t1917 t1918 t1780 t1660 t1616 t1802 t1683 t1656 t1653 t1680 t1775 t1797
      t1676 t1650 t1672 t1646 t1766 t1792 t1668 t1642 t1890 s12_1 s13_1 s14_1 s15_1 s16_1 s12_2
      s13_2 s14_2 s15_2 s12_3 s13_3 s14_3 s12_4 s13_4 s12_5 s13_5 s12_6 s15_3 s14_4 s17_1 s16_2
      s12_7 s14_5 s13_6 s16_3 s15_4 s5_1 s5_2 s5_3 s5_4 s5_5 s5_6 s5_7 carry5 s5 s12 s13 s14 s15 s16
      s17 s19 s20 s21 s22 s23 carry12 carry14 carry16 carry11 carry13 carry15 carry4 rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl m1772 rfl rfl m1777 rfl rfl m1782 rfl rfl rfl m1799 rfl rfl m1804 rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl e1780 e1660 e1616 e1802 e1683 e1656 e1653
      e1680 e1775 e1797 e1676 e1650 e1672 e1646 e1766 e1792 e1668 e1642 e1890 rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl
  have m1920 : t1920 = t1918 <<< 21 := Bnd.and_neg_shift _
  have e1922 :=
    sc25519_reduce.bridge_carry7_1 t1687 t1688 t1689 t1690 t1691 t1696 t1697 t1698 t1704 t1705 t1706
      t1707 t1714 t1727 t1742 t1743 t1744 t1776 t1777 t1778 t1781 t1782 t1783 t1786 t1787 t1798
      t1803 t1804 t1805 t1810 t1811 t1824 t1825 t1836 t1837 t1854 t1855 t1895 t1921 t1922 t1664
      t1623 t1668 t1741 t1785 t1780 t1660 t1802 t1683 t1656 t1653 t1680 t1775 t1797 t1676 t1650
      t1894 s14_1 s15_1 s16_1 s14_2 s15_2 s14_3 s7_1 s7_2 s7_3 s15_3 s14_4 s17_1 s16_2 s7_4 s14_5
      s16_3 s15_4 s7_5 s7_6 s7_7 s7_8 s7_9 carry7_1 s7 s14 s15 s16 s17 s18 s19 s21 s22 s23 carry6
      carry14 carry16 carry7 carry13 carry15 carry6_1 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl m1777 rfl rfl m1782 rfl m1786 rfl rfl rfl m1804 rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl e1664 e1623 e1668 e1741 e1785 e1780 e1660 e1802 e1683 e1656
      e1653 e1680 e1775 e1797 e1676 e1650 e1894 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
  have m1924 : t1924 = t1922 <<< 21 := Bnd.and_neg_shift _
  have e1927 :=
    sc25519_reduce.bridge_carry9_1 t1690 t1691 t1699 t1709 t1716 t1732 t1749 t1750 t1751 t1752 t1753
      t1781 t1782 t1783 t1790 t1803 t1813 t1827 t1900 t1901 t1902 t1903 t1926 t1927 t1780 t1660
      t1664 t1630 t1668 t1672 t1676 t1748 t1789 t1802 t1683 t1656 t1899 s16_1 s9_1 s9_2 s9_3 s9_4
      s9_5 s17_1 s16_2 s9_6 s16_3 s9_7 s9_8 s9_9 carry9_1 s9 s16 s17 s18 s19 s20 s21 s23 carry8
      carry16 carry9 carry15 carry8_1 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl m1782 rfl
      m1790 rfl rfl rfl rfl rfl rfl rfl rfl rfl e1780 e1660 e1664 e1630 e1668 e1672 e1676 e1748
      e1789 e1802 e1683 e1656 e1899 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
  have m1929 : t1929 = t1927 <<< 21 := Bnd.and_neg_shift _
  have e1932 :=
    sc25519_reduce.bridge_carry11_1 t1684 t1693 t1701 t1711 t1718 t1739 t1757 t1758 t1759 t1760
      t1761 t1762 t1763 t1794 t1795 t1908 t1931 t1932 t1907 t1664 t1638 t1668 t1672 t1676 t1683
      t1680 t1756 t1792 s11_1 s11_2 s11_3 s11_4 s11_5 s11_6 s11_7 s11_8 s11_9 carry11_1 s11 s18 s19
      s20 s21 s22 s23 carry10 carry11 carry10_1 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      m1794 rfl rfl rfl rfl e1907 e1664 e1638 e1668 e1672 e1676 e1683 e1680 e1756 e1792 rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl
  have m1933 : t1933 = t1932 <<< 21 := Bnd.and_neg_shift _
  have e1942 :=
    sc25519_reduce.bridge_carry0_1 t1685 t1694 t1702 t1712 t1719 t1720 t1721 t1722 t1723 t1724 t1772
      t1773 t1793 t1868 t1869 t1883 t1884 t1935 t1936 t1942 t1792 t1668 t1642 t1672 t1676 t1683
      t1680 t1766 t1596 t1881 t1932 s12_1 s12_2 s12_3 s12_4 s12_5 s12_6 s12_7 s0_1 s12_8 s0_2 s12_9
      s0_3 carry0_1 s0 s12 s19 s20 s21 s22 s23 carry12 carry11 carry0 carry11_1 rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl m1772 rfl rfl rfl rfl m1883 rfl rfl rfl rfl e1792 e1668 e1642 e1672 e1676
      e1683 e1680 e1766 e1596 e1881 e1932 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
  have m1946 : t1946 = t1936 - t1942 <<< 21 := Bnd.and_mask_sub _
  have e1947 :=
    sc25519_reduce.bridge_carry1_1 t1685 t1686 t1694 t1695 t1702 t1703 t1712 t1713 t1719 t1720 t1721
      t1722 t1723 t1724 t1767 t1768 t1769 t1770 t1771 t1772 t1773 t1793 t1799 t1800 t1856 t1857
      t1870 t1871 t1882 t1913 t1937 t1943 t1944 t1945 t1947 t1932 t1672 t1646 t1676 t1683 t1680
      t1766 t1797 t1600 t1792 t1668 t1642 t1881 t1912 t1942 s12_1 s13_1 s12_2 s13_2 s12_3 s13_3
      s12_4 s13_4 s12_5 s13_5 s12_6 s12_7 s13_6 s1_1 s1_2 s12_8 s1_3 s1_4 s12_9 s1_5 s1_6 carry1_1
      s1 s12 s13 s19 s20 s21 s22 s23 carry12 carry11 carry13 carry0 carry1 carry11_1 carry0_1 rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl m1772 rfl rfl m1799
      rfl rfl rfl rfl rfl rfl m1913 rfl rfl rfl rfl rfl e1932 e1672 e1646 e1676 e1683 e1680 e1766
      e1797 e1600 e1792 e1668 e1642 e1881 e1912 e1942 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
  have m1952 : t1952 = t1945 - t1947 <<< 21 := Bnd.and_mask_sub _
  have e1953 :=
    sc25519_reduce.bridge_carry2_1 t1685 t1686 t1687 t1694 t1695 t1696 t1702 t1703 t1704 t1705 t1706
      t1707 t1712 t1713 t1719 t1720 t1721 t1722 t1723 t1724 t1767 t1768 t1769 t1770 t1771 t1772
      t1773 t1777 t1778 t1793 t1798 t1799 t1800 t1844 t1845 t1858 t1859 t1872 t1873 t1888 t1938
      t1948 t1949 t1950 t1951 t1953 t1932 t1797 t1676 t1650 t1683 t1680 t1775 t1604 t1672 t1646
      t1766 t1792 t1668 t1642 t1886 t1912 t1947 s12_1 s13_1 s14_1 s12_2 s13_2 s14_2 s12_3 s13_3
      s14_3 s12_4 s13_4 s12_5 s13_5 s12_6 s14_4 s12_7 s14_5 s13_6 s2_1 s2_2 s2_3 s12_8 s2_4 s2_5
      s12_9 s2_6 s2_7 carry2_1 s2 s12 s13 s14 s19 s20 s21 s22 s23 carry12 carry14 carry11 carry13
      carry2 carry1 carry11_1 carry1_1 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl m1772 rfl m1777 rfl rfl rfl m1799 rfl rfl rfl rfl rfl
      rfl rfl m1888 rfl rfl rfl rfl rfl rfl e1932 e1797 e1676 e1650 e1683 e1680 e1775 e1604 e1672
      e1646 e1766 e1792 e1668 e1642 e1886 e1912 e1947 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
  have m1957 : t1957 = t1951 - t1953 <<< 21 := Bnd.and_mask_sub _
  have e1958 :=
    sc25519_reduce.bridge_carry3_1 t1685 t1686 t1687 t1688 t1689 t1694 t1695 t1696 t1697 t1698 t1702
      t1703 t1704 t1705 t1706 t1707 t1712 t1713 t1719 t1720 t1721 t1722 t1723 t1724 t1767 t1768
      t1769 t1770 t1771 t1772 t1773 t1776 t1777 t1778 t1793 t1798 t1799 t1800 t1804 t1805 t1828
      t1829 t1846 t1847 t1860 t1861 t1874 t1875 t1887 t1916 t1939 t1954 t1955 t1956 t1958 t1683
      t1653 t1680 t1775 t1802 t1608 t1797 t1676 t1650 t1672 t1646 t1766 t1792 t1668 t1642 t1886
      t1932 t1915 t1953 s12_1 s13_1 s14_1 s15_1 s12_2 s13_2 s14_2 s15_2 s12_3 s13_3 s14_3 s12_4
      s13_4 s12_5 s13_5 s12_6 s15_3 s14_4 s12_7 s14_5 s13_6 s15_4 s3_1 s3_2 s3_3 s3_4 s12_8 s3_5
      s3_6 s12_9 s3_7 s3_8 carry3_1 s3 s12 s13 s14 s15 s19 s20 s21 s22 s23 carry12 carry14 carry11
      carry13 carry15 carry2 carry3 carry11_1 carry2_1 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl m1772 rfl rfl m1777
      rfl rfl rfl m1799 rfl m1804 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl m1916 rfl rfl rfl rfl rfl
      e1683 e1653 e1680 e1775 e1802 e1608 e1797 e1676 e1650 e1672 e1646 e1766 e1792 e1668 e1642
      e1886 e1932 e1915 e1953 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
  have m1963 : t1963 = t1956 - t1958 <<< 21 := Bnd.and_mask_sub _
  have e1964 :=
    sc25519_reduce.bridge_carry4_1 t1685 t1686 t1687 t1688 t1689 t1690 t1691 t1694 t1695 t1696 t1697
      t1698 t1702 t1703 t1704 t1705 t1706 t1707 t1712 t1713 t1719 t1720 t1721 t1722 t1723 t1724
      t1767 t1768 t1769 t1770 t1771 t1772 t1773 t1776 t1777 t1778 t1782 t1783 t1793 t1798 t1799
      t1800 t1803 t1804 t1805 t1818 t1819 t1830 t1831 t1848 t1849 t1862 t1863 t1876 t1877 t1892
      t1940 t1959 t1960 t1961 t1962 t1964 t1932 t1802 t1683 t1656 t1780 t1612 t1653 t1680 t1775
      t1797 t1676 t1650 t1672 t1646 t1766 t1792 t1668 t1642 t1890 t1915 t1958 s12_1 s13_1 s14_1
      s15_1 s16_1 s12_2 s13_2 s14_2 s15_2 s12_3 s13_3 s14_3 s12_4 s13_4 s12_5 s13_5 s12_6 s15_3
      s14_4 s16_2 s12_7 s14_5 s13_6 s16_3 s15_4 s4_1 s4_2 s4_3 s4_4 s4_5 s12_8 s4_6 s4_7 s12_9 s4_8
      s4_9 carry4_1 s4 s12 s13 s14 s15 s16 s19 s20 s21 s22 s23 carry12 carry14 carry16 carry11
      carry13 carry15 carry4 carry3 carry11_1 carry3_1 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl m1772 rfl rfl
      m1777 rfl m1782 rfl rfl rfl m1799 rfl rfl m1804 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      m1892 rfl rfl rfl rfl rfl rfl e1932 e1802 e1683 e1656 e1780 e1612 e1653 e1680 e1775 e1797
      e1676 e1650 e1672 e1646 e1766 e1792 e1668 e1642 e1890 e1915 e1958 rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl
  have m1968 : t1968 = t1962 - t1964 <<< 21 := Bnd.and_mask_sub _
  have e1969 :=
    sc25519_reduce.bridge_carry5_1 t1685 t1686 t1687 t1688 t1689 t1690 t1691 t1694 t1695 t1696 t1697
      t1698 t1702 t1703 t1704 t1705 t1706 t1707 t1712 t1713 t1719 t1720 t1721 t1722 t1723 t1724
      t1767 t1768 t1769 t1770 t1771 t1772 t1773 t1776 t1777 t1778 t1781 t1782 t1783 t1793 t1798
      t1799 t1800 t1803 t1804 t1805 t1806 t1807 t1820 t1821 t1832 t1833 t1850 t1851 t1864 t1865
      t1878 t1879 t1891 t1920 t1941 t1965 t1966 t1967 t1969 t1780 t1660 t1616 t1802 t1683 t1656
      t1653 t1680 t1775 t1797 t1676 t1650 t1672 t1646 t1766 t1792 t1668 t1642 t1890 t1932 t1918
      t1964 s12_1 s13_1 s14_1 s15_1 s16_1 s12_2 s13_2 s14_2 s15_2 s12_3 s13_3 s14_3 s12_4 s13_4
      s12_5 s13_5 s12_6 s15_3 s14_4 s17_1 s16_2 s12_7 s14_5 s13_6 s16_3 s15_4 s5_1 s5_2 s5_3 s5_4
      s5_5 s5_6 s12_8 s5_7 s5_8 s12_9 s5_9 s5_10 carry5_1 s5 s12 s13 s14 s15 s16 s17 s19 s20 s21 s22
      s23 carry12 carry14 carry16 carry11 carry13 carry15 carry4 carry5 carry11_1 carry4_1 rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl m1772 rfl rfl m1777 rfl rfl m1782 rfl rfl rfl m1799 rfl rfl m1804 rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl m1920 rfl rfl rfl rfl rfl e1780 e1660
      e1616 e1802 e1683 e1656 e1653 e1680 e1775 e1797 e1676 e1650 e1672 e1646 e1766 e1792 e1668
      e1642 e1890 e1932 e1918 e1964 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
  have m1971 : t1971 = t1967 - t1969 <<< 21 := Bnd.and_mask_sub _
  have e1972 :=
    sc25519_reduce.bridge_carry6_2 t1686 t1687 t1688 t1689 t1690 t1691 t1695 t1696 t1697 t1698 t1703
      t1704 t1705 t1706 t1707 t1713 t1725 t1726 t1745 t1746 t1767 t1768 t1769 t1770 t1771 t1776
      t1777 t1778 t1781 t1782 t1783 t1798 t1799 t1800 t1803 t1804 t1805 t1808 t1809 t1822 t1823
      t1834 t1835 t1852 t1853 t1866 t1867 t1896 t1897 t1919 t1970 t1972 t1664 t1620 t1741 t1780
      t1660 t1802 t1683 t1656 t1653 t1680 t1775 t1797 t1676 t1650 t1672 t1646 t1766 t1894 t1918
      t1969 s13_1 s14_1 s15_1 s16_1 s13_2 s14_2 s15_2 s13_3 s14_3 s13_4 s6_1 s6_2 s13_5 s15_3 s14_4
      s17_1 s16_2 s14_5 s13_6 s16_3 s15_4 s6_3 s6_4 s6_5 s6_6 s6_7 s6_8 s6_9 s6_10 carry6_2 s6 s13
      s14 s15 s16 s17 s18 s20 s21 s22 s23 carry6 carry12 carry14 carry16 carry13 carry15 carry6_1
      carry5 carry5_1 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl m1745
      rfl rfl rfl rfl rfl rfl rfl m1777 rfl rfl m1782 rfl rfl m1799 rfl rfl m1804 rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl m1896 rfl rfl rfl rfl e1664 e1620 e1741 e1780 e1660 e1802 e1683
      e1656 e1653 e1680 e1775 e1797 e1676 e1650 e1672 e1646 e1766 e1894 e1918 e1969 rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl
  have m1974 : t1974 = t1970 - t1972 <<< 21 := Bnd.and_mask_sub _
  have e1975 :=
    sc25519_reduce.bridge_carry7_2 t1687 t1688 t1689 t1690 t1691 t1696 t1697 t1698 t1704 t1705 t1706
      t1707 t1714 t1727 t1742 t1743 t1744 t1776 t1777 t1778 t1781 t1782 t1783 t1786 t1787 t1798
      t1803 t1804 t1805 t1810 t1811 t1824 t1825 t1836 t1837 t1854 t1855 t1895 t1924 t1925 t1973
      t1975 t1972 t1664 t1623 t1668 t1741 t1785 t1780 t1660 t1802 t1683 t1656 t1653 t1680 t1775
      t1797 t1676 t1650 t1894 t1922 s14_1 s15_1 s16_1 s14_2 s15_2 s14_3 s7_1 s7_2 s7_3 s15_3 s14_4
      s17_1 s16_2 s7_4 s14_5 s16_3 s15_4 s7_5 s7_6 s7_7 s7_8 s7_9 s7_10 s7_11 carry7_2 s7 s14 s15
      s16 s17 s18 s19 s21 s22 s23 carry6 carry14 carry16 carry7 carry13 carry15 carry6_1 carry7_1
      carry6_2 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl m1777 rfl rfl
      m1782 rfl m1786 rfl rfl rfl m1804 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl m1924 rfl rfl rfl
      e1972 e1664 e1623 e1668 e1741 e1785 e1780 e1660 e1802 e1683 e1656 e1653 e1680 e1775 e1797
      e1676 e1650 e1894 e1922 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl
  have m1977 : t1977 = t1973 - t1975 <<< 21 := Bnd.and_mask_sub _
  have e1978 :=
    sc25519_reduce.bridge_carry8_2 t1688 t1689 t1690 t1691 t1697 t1698 t1708 t1715 t1728 t1729 t1730
      t1731 t1754 t1776 t1781 t1782 t1783 t1803 t1804 t1805 t1812 t1826 t1838 t1839 t1840 t1841
      t1842 t1843 t1904 t1905 t1923 t1976 t1978 t1785 t1664 t1626 t1668 t1672 t1748 t1780 t1660
      t1802 t1683 t1656 t1653 t1680 t1775 t1899 t1922 t1975 s15_1 s16_1 s15_2 s8_1 s8_2 s8_3 s8_4
      s15_3 s17_1 s16_2 s8_5 s16_3 s15_4 s8_6 s8_7 s8_8 s8_9 s8_10 s8_11 carry8_2 s8 s15 s16 s17 s18
      s19 s20 s22 s23 carry8 carry14 carry16 carry7 carry15 carry8_1 carry7_1 carry7_2 rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl m1754 rfl rfl m1782 rfl rfl m1804 rfl rfl rfl rfl rfl rfl
      rfl rfl rfl m1904 rfl rfl rfl rfl e1785 e1664 e1626 e1668 e1672 e1748 e1780 e1660 e1802 e1683
      e1656 e1653 e1680 e1775 e1899 e1922 e1975 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl
  have m1980 : t1980 = t1976 - t1978 <<< 21 := Bnd.and_mask_sub _
  have e1981 :=
    sc25519_reduce.bridge_carry9_2 t1690 t1691 t1699 t1709 t1716 t1732 t1749 t1750 t1751 t1752 t1753
      t1781 t1782 t1783 t1790 t1803 t1813 t1827 t1900 t1901 t1902 t1903 t1929 t1930 t1979 t1981
      t1978 t1780 t1660 t1664 t1630 t1668 t1672 t1676 t1748 t1789 t1802 t1683 t1656 t1899 t1927
      s16_1 s9_1 s9_2 s9_3 s9_4 s9_5 s17_1 s16_2 s9_6 s16_3 s9_7 s9_8 s9_9 s9_10 s9_11 carry9_2 s9
      s16 s17 s18 s19 s20 s21 s23 carry8 carry16 carry9 carry15 carry8_1 carry9_1 carry8_2 rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl m1782 rfl m1790 rfl rfl rfl rfl rfl rfl rfl m1929 rfl
      rfl rfl e1978 e1780 e1660 e1664 e1630 e1668 e1672 e1676 e1748 e1789 e1802 e1683 e1656 e1899
      e1927 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
  have m1983 : t1983 = t1979 - t1981 <<< 21 := Bnd.and_mask_sub _
  have e1984 :=
    sc25519_reduce.bridge_carry10_2 t1692 t1700 t1710 t1717 t1733 t1734 t1735 t1736 t1737 t1738
      t1764 t1781 t1814 t1815 t1816 t1817 t1909 t1910 t1928 t1982 t1984 t1780 t1660 t1664 t1634
      t1668 t1672 t1676 t1680 t1789 t1756 t1907 t1927 t1981 s10_1 s10_2 s10_3 s10_4 s10_5 s10_6
      s17_1 s10_7 s10_8 s10_9 s10_10 s10_11 carry10_2 s10 s17 s18 s19 s20 s21 s22 carry10 carry16
      carry9 carry10_1 carry9_1 carry9_2 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl m1764 rfl rfl rfl
      rfl rfl m1909 rfl rfl rfl rfl e1780 e1660 e1664 e1634 e1668 e1672 e1676 e1680 e1789 e1756
      e1907 e1927 e1981 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
  have m1986 : t1986 = t1982 - t1984 <<< 21 := Bnd.and_mask_sub _
  have e1987 :=
    sc25519_reduce.bridge_carry11_2 t1684 t1693 t1701 t1711 t1718 t1739 t1757 t1758 t1759 t1760
      t1761 t1762 t1763 t1794 t1795 t1908 t1933 t1934 t1985 t1987 t1984 t1907 t1664 t1638 t1668
      t1672 t1676 t1683 t1680 t1756 t1792 t1932 s11_1 s11_2 s11_3 s11_4 s11_5 s11_6 s11_7 s11_8
      s11_9 s11_10 s11_11 carry11_2 s11 s18 s19 s20 s21 s22 s23 carry10 carry11 carry10_1 carry11_1
      carry10_2 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl m1794 rfl rfl m1933 rfl rfl rfl
      e1984 e1907 e1664 e1638 e1668 e1672 e1676 e1683 e1680 e1756 e1792 e1932 rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl
  have m1988 : t1988 = t1985 - t1987 <<< 21 := Bnd.and_mask_sub _
  have e1990 :=
    sc25519_reduce.bridge_s0_5 t1685 t1694 t1702 t1712 t1719 t1720 t1721 t1722 t1723 t1724 t1772
      t1773 t1793 t1868 t1869 t1883 t1884 t1935 t1936 t1946 t1989 t1990 t1987 t1792 t1668 t1642
      t1672 t1676 t1683 t1680 t1766 t1596 t1881 t1932 t1942 s12_1 s12_2 s12_3 s12_4 s12_5 s12_6
      s12_7 s0_1 s12_8 s0_2 s12_9 s0_3 s12_10 s0_4 s12_11 s0_5 s0 s12 s19 s20 s21 s22 s23 carry12
      carry11 carry0 carry11_1 carry0_1 carry11_2 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl m1772 rfl
      rfl rfl rfl m1883 rfl rfl rfl m1946 rfl rfl e1987 e1792 e1668 e1642 e1672 e1676 e1683 e1680
      e1766 e1596 e1881 e1932 e1942 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
  have e2001 :=
    sc25519_reduce.bridge_carry0_2 t1685 t1694 t1702 t1712 t1719 t1720 t1721 t1722 t1723 t1724 t1772
      t1773 t1793 t1868 t1869 t1883 t1884 t1935 t1936 t1946 t1989 t1990 t2001 t1987 t1792 t1668
      t1642 t1672 t1676 t1683 t1680 t1766 t1596 t1881 t1932 t1942 s12_1 s12_2 s12_3 s12_4 s12_5
      s12_6 s12_7 s0_1 s12_8 s0_2 s12_9 s0_3 s12_10 s0_4 s12_11 s0_5 carry0_2 s0 s12 s19 s20 s21 s22
      s23 carry12 carry11 carry0 carry11_1 carry0_1 carry11_2 rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl m1772 rfl rfl rfl rfl m1883 rfl rfl rfl m1946 rfl rfl rfl e1987 e1792 e1668 e1642 e1672
      e1676 e1683 e1680 e1766 e1596 e1881 e1932 e1942 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl
  have e2002 :=
    sc25519_reduce.bridge_s1_9 t1685 t1686 t1694 t1695 t1702 t1703 t1712 t1713 t1719 t1720 t1721
      t1722 t1723 t1724 t1767 t1768 t1769 t1770 t1771 t1772 t1773 t1793 t1799 t1800 t1856 t1857
      t1870 t1871 t1882 t1913 t1937 t1943 t1944 t1945 t1952 t1991 t1992 t2002 t1987 t1932 t1672
      t1646 t1676 t1683 t1680 t1766 t1797 t1600 t1792 t1668 t1642 t1881 t1912 t1942 t1947 t2001
      s12_1 s13_1 s12_2 s13_2 s12_3 s13_3 s12_4 s13_4 s12_5 s13_5 s12_6 s12_7 s13_6 s1_1 s1_2 s12_8
      s1_3 s1_4 s12_9 s1_5 s12_10 s1_6 s1_7 s12_11 s1_8 s1_9 s1 s12 s13 s19 s20 s21 s22 s23 carry12
      carry11 carry13 carry0 carry1 carry11_1 carry0_1 carry1_1 carry11_2 carry0_2 rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl m1772 rfl rfl m1799 rfl rfl rfl
      rfl rfl rfl m1913 rfl rfl rfl rfl m1952 rfl rfl rfl e1987 e1932 e1672 e1646 e1676 e1683 e1680
      e1766 e1797 e1600 e1792 e1668 e1642 e1881 e1912 e1942 e1947 e2001 rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
  have e2003 :=
    sc25519_reduce.bridge_carry1_2 t1685 t1686 t1694 t1695 t1702 t1703 t1712 t1713 t1719 t1720 t1721
      t1722 t1723 t1724 t1767 t1768 t1769 t1770 t1771 t1772 t1773 t1793 t1799 t1800 t1856 t1857
      t1870 t1871 t1882 t1913 t1937 t1943 t1944 t1945 t1952 t1991 t1992 t2002 t2003 t1987 t1932
      t1672 t1646 t1676 t1683 t1680 t1766 t1797 t1600 t1792 t1668 t1642 t1881 t1912 t1942 t1947
      t2001 s12_1 s13_1 s12_2 s13_2 s12_3 s13_3 s12_4 s13_4 s12_5 s13_5 s12_6 s12_7 s13_6 s1_1 s1_2
      s12_8 s1_3 s1_4 s12_9 s1_5 s12_10 s1_6 s1_7 s12_11 s1_8 s1_9 carry1_2 s1 s12 s13 s19 s20 s21
      s22 s23 carry12 carry11 carry13 carry0 carry1 carry11_1 carry0_1 carry1_1 carry11_2 carry0_2
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl m1772 rfl rfl
      m1799 rfl rfl rfl rfl rfl rfl m1913 rfl rfl rfl rfl m1952 rfl rfl rfl rfl e1987 e1932 e1672
      e1646 e1676 e1683 e1680 e1766 e1797 e1600 e1792 e1668 e1642 e1881 e1912 e1942 e1947 e2001 rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl
  have e2004 :=
    sc25519_reduce.bridge_s2_10 t1685 t1686 t1687 t1694 t1695 t1696 t1702 t1703 t1704 t1705 t1706
      t1707 t1712 t1713 t1719 t1720 t1721 t1722 t1723 t1724 t1767 t1768 t1769 t1770 t1771 t1772
      t1773 t1777 t1778 t1793 t1798 t1799 t1800 t1844 t1845 t1858 t1859 t1872 t1873 t1888 t1938
      t1948 t1949 t1950 t1951 t1957 t1993 t1994 t2004 t1987 t1932 t1797 t1676 t1650 t1683 t1680
      t1775 t1604 t1672 t1646 t1766 t1792 t1668 t1642 t1886 t1912 t1947 t1953 t2003 s12_1 s13_1
      s14_1 s12_2 s13_2 s14_2 s12_3 s13_3 s14_3 s12_4 s13_4 s12_5 s13_5 s12_6 s14_4 s12_7 s14_5
      s13_6 s2_1 s2_2 s2_3 s12_8 s2_4 s2_5 s12_9 s2_6 s12_10 s2_7 s2_8 s12_11 s2_9 s2_10 s2 s12 s13
      s14 s19 s20 s21 s22 s23 carry12 carry14 carry11 carry13 carry2 carry1 carry11_1 carry1_1
      carry2_1 carry11_2 carry1_2 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl m1772 rfl m1777 rfl rfl rfl m1799 rfl rfl rfl rfl rfl rfl
      rfl m1888 rfl rfl rfl rfl rfl m1957 rfl rfl rfl e1987 e1932 e1797 e1676 e1650 e1683 e1680
      e1775 e1604 e1672 e1646 e1766 e1792 e1668 e1642 e1886 e1912 e1947 e1953 e2003 rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl
  have m2005 : t2005 = t2002 - t2003 <<< 21 := Bnd.and_mask_sub _
  have e2005 :=
    sc25519_reduce.bridge_s1_10 t1685 t1686 t1694 t1695 t1702 t1703 t1712 t1713 t1719 t1720 t1721
      t1722 t1723 t1724 t1767 t1768 t1769 t1770 t1771 t1772 t1773 t1793 t1799 t1800 t1856 t1857
      t1870 t1871 t1882 t1913 t1937 t1943 t1944 t1945 t1952 t1991 t1992 t2002 t2005 t1987 t1932
      t1672 t1646 t1676 t1683 t1680 t1766 t1797 t1600 t1792 t1668 t1642 t1881 t1912 t1942 t1947
      t2001 t2003 s12_1 s13_1 s12_2 s13_2 s12_3 s13_3 s12_4 s13_4 s12_5 s13_5 s12_6 s12_7 s13_6 s1_1
      s1_2 s12_8 s1_3 s1_4 s12_9 s1_5 s12_10 s1_6 s1_7 s12_11 s1_8 s1_9 s1_10 s1 s12 s13 s19 s20 s21
      s22 s23 carry12 carry11 carry13 carry0 carry1 carry11_1 carry0_1 carry1_1 carry11_2 carry0_2
      carry1_2 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl m1772 rfl
      rfl m1799 rfl rfl rfl rfl rfl rfl m1913 rfl rfl rfl rfl m1952 rfl rfl rfl m2005 e1987 e1932
      e1672 e1646 e1676 e1683 e1680 e1766 e1797 e1600 e1792 e1668 e1642 e1881 e1912 e1942 e1947
      e2001 e2003 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl
  have e2006 :=
    sc25519_reduce.bridge_carry2_2 t1685 t1686 t1687 t1694 t1695 t1696 t1702 t1703 t1704 t1705 t1706
      t1707 t1712 t1713 t1719 t1720 t1721 t1722 t1723 t1724 t1767 t1768 t1769 t1770 t1771 t1772
      t1773 t1777 t1778 t1793 t1798 t1799 t1800 t1844 t1845 t1858 t1859 t1872 t1873 t1888 t1938
      t1948 t1949 t1950 t1951 t1957 t1993 t1994 t2004 t2006 t1987 t1932 t1797 t1676 t1650 t1683
      t1680 t1775 t1604 t1672 t1646 t1766 t1792 t1668 t1642 t1886 t1912 t1947 t1953 t2003 s12_1
      s13_1 s14_1 s12_2 s13_2 s14_2 s12_3 s13_3 s14_3 s12_4 s13_4 s12_5 s13_5 s12_6 s14_4 s12_7
      s14_5 s13_6 s2_1 s2_2 s2_3 s12_8 s2_4 s2_5 s12_9 s2_6 s12_10 s2_7 s2_8 s12_11 s2_9 s2_10
      carry2_2 s2 s12 s13 s14 s19 s20 s21 s22 s23 carry12 carry14 carry11 carry13 carry2 carry1
      carry11_1 carry1_1 carry2_1 carry11_2 carry1_2 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl m1772 rfl m1777 rfl rfl rfl m1799 rfl rfl
      rfl rfl rfl rfl rfl m1888 rfl rfl rfl rfl rfl m1957 rfl rfl rfl rfl e1987 e1932 e1797 e1676
      e1650 e1683 e1680 e1775 e1604 e1672 e1646 e1766 e1792 e1668 e1642 e1886 e1912 e1947 e1953
      e2003 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
  have e2007 :=
    sc25519_reduce.bridge_s3_11 t1685 t1686 t1687 t1688 t1689 t1694 t1695 t1696 t1697 t1698 t1702
      t1703 t1704 t1705 t1706 t1707 t1712 t1713 t1719 t1720 t1721 t1722 t1723 t1724 t1767 t1768
      t1769 t1770 t1771 t1772 t1773 t1776 t1777 t1778 t1793 t1798 t1799 t1800 t1804 t1805 t1828
      t1829 t1846 t1847 t1860 t1861 t1874 t1875 t1887 t1916 t1939 t1954 t1955 t1956 t1963 t1995
      t1996 t2007 t1987 t1683 t1653 t1680 t1775 t1802 t1608 t1797 t1676 t1650 t1672 t1646 t1766
      t1792 t1668 t1642 t1886 t1932 t1915 t1953 t1958 t2006 s12_1 s13_1 s14_1 s15_1 s12_2 s13_2
      s14_2 s15_2 s12_3 s13_3 s14_3 s12_4 s13_4 s12_5 s13_5 s12_6 s15_3 s14_4 s12_7 s14_5 s13_6
      s15_4 s3_1 s3_2 s3_3 s3_4 s12_8 s3_5 s3_6 s12_9 s3_7 s12_10 s3_8 s3_9 s12_11 s3_10 s3_11 s3
      s12 s13 s14 s15 s19 s20 s21 s22 s23 carry12 carry14 carry11 carry13 carry15 carry2 carry3
      carry11_1 carry2_1 carry3_1 carry11_2 carry2_2 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl m1772 rfl rfl m1777 rfl
      rfl rfl m1799 rfl m1804 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl m1916 rfl rfl rfl rfl m1963
      rfl rfl rfl e1987 e1683 e1653 e1680 e1775 e1802 e1608 e1797 e1676 e1650 e1672 e1646 e1766
      e1792 e1668 e1642 e1886 e1932 e1915 e1953 e1958 e2006 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl
  have m2008 : t2008 = t2004 - t2006 <<< 21 := Bnd.and_mask_sub _
  have e2008 :=
    sc25519_reduce.bridge_s2_11 t1685 t1686 t1687 t1694 t1695 t1696 t1702 t1703 t1704 t1705 t1706
      t1707 t1712 t1713 t1719 t1720 t1721 t1722 t1723 t1724 t1767 t1768 t1769 t1770 t1771 t1772
      t1773 t1777 t1778 t1793 t1798 t1799 t1800 t1844 t1845 t1858 t1859 t1872 t1873 t1888 t1938
      t1948 t1949 t1950 t1951 t1957 t1993 t1994 t2004 t2008 t1987 t1932 t1797 t1676 t1650 t1683
      t1680 t1775 t1604 t1672 t1646 t1766 t1792 t1668 t1642 t1886 t1912 t1947 t1953 t2003 t2006
      s12_1 s13_1 s14_1 s12_2 s13_2 s14_2 s12_3 s13_3 s14_3 s12_4 s13_4 s12_5 s13_5 s12_6 s14_4
      s12_7 s14_5 s13_6 s2_1 s2_2 s2_3 s12_8 s2_4 s2_5 s12_9 s2_6 s12_10 s2_7 s2_8 s12_11 s2_9 s2_10
      s2_11 s2 s12 s13 s14 s19 s20 s21 s22 s23 carry12 carry14 carry11 carry13 carry2 carry1
      carry11_1 carry1_1 carry2_1 carry11_2 carry1_2 carry2_2 rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl m1772 rfl m1777 rfl rfl rfl
      m1799 rfl rfl rfl rfl rfl rfl rfl m1888 rfl rfl rfl rfl rfl m1957 rfl rfl rfl m2008 e1987
      e1932 e1797 e1676 e1650 e1683 e1680 e1775 e1604 e1672 e1646 e1766 e1792 e1668 e1642 e1886
      e1912 e1947 e1953 e2003 e2006 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
  have e2009 :=
    sc25519_reduce.bridge_carry3_2 t1685 t1686 t1687 t1688 t1689 t1694 t1695 t1696 t1697 t1698 t1702
      t1703 t1704 t1705 t1706 t1707 t1712 t1713 t1719 t1720 t1721 t1722 t1723 t1724 t1767 t1768
      t1769 t1770 t1771 t1772 t1773 t1776 t1777 t1778 t1793 t1798 t1799 t1800 t1804 t1805 t1828
      t1829 t1846 t1847 t1860 t1861 t1874 t1875 t1887 t1916 t1939 t1954 t1955 t1956 t1963 t1995
      t1996 t2007 t2009 t1987 t1683 t1653 t1680 t1775 t1802 t1608 t1797 t1676 t1650 t1672 t1646
      t1766 t1792 t1668 t1642 t1886 t1932 t1915 t1953 t1958 t2006 s12_1 s13_1 s14_1 s15_1 s12_2
      s13_2 s14_2 s15_2 s12_3 s13_3 s14_3 s12_4 s13_4 s12_5 s13_5 s12_6 s15_3 s14_4 s12_7 s14_5
      s13_6 s15_4 s3_1 s3_2 s3_3 s3_4 s12_8 s3_5 s3_6 s12_9 s3_7 s12_10 s3_8 s3_9 s12_11 s3_10 s3_11
      carry3_2 s3 s12 s13 s14 s15 s19 s20 s21 s22 s23 carry12 carry14 carry11 carry13 carry15 carry2
      carry3 carry11_1 carry2_1 carry3_1 carry11_2 carry2_2 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl m1772 rfl rfl
      m1777 rfl rfl rfl m1799 rfl m1804 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl m1916 rfl rfl rfl
      rfl m1963 rfl rfl rfl rfl e1987 e1683 e1653 e1680 e1775 e1802 e1608 e1797 e1676 e1650 e1672
      e1646 e1766 e1792 e1668 e1642 e1886 e1932 e1915 e1953 e1958 e2006 rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl
  have e2010 :=
    sc25519_reduce.bridge_s4_12 t1685 t1686 t1687 t1688 t1689 t1690 t1691 t1694 t1695 t1696 t1697
      t1698 t1702 t1703 t1704 t1705 t1706 t1707 t1712 t1713 t1719 t1720 t1721 t1722 t1723 t1724
      t1767 t1768 t1769 t1770 t1771 t1772 t1773 t1776 t1777 t1778 t1782 t1783 t1793 t1798 t1799
      t1800 t1803 t1804 t1805 t1818 t1819 t1830 t1831 t1848 t1849 t1862 t1863 t1876 t1877 t1892
      t1940 t1959 t1960 t1961 t1962 t1968 t1997 t1998 t2010 t1987 t1932 t1802 t1683 t1656 t1780
      t1612 t1653 t1680 t1775 t1797 t1676 t1650 t1672 t1646 t1766 t1792 t1668 t1642 t1890 t1915
      t1958 t1964 t2009 s12_1 s13_1 s14_1 s15_1 s16_1 s12_2 s13_2 s14_2 s15_2 s12_3 s13_3 s14_3
      s12_4 s13_4 s12_5 s13_5 s12_6 s15_3 s14_4 s16_2 s12_7 s14_5 s13_6 s16_3 s15_4 s4_1 s4_2 s4_3
      s4_4 s4_5 s12_8 s4_6 s4_7 s12_9 s4_8 s12_10 s4_9 s4_10 s12_11 s4_11 s4_12 s4 s12 s13 s14 s15
      s16 s19 s20 s21 s22 s23 carry12 carry14 carry16 carry11 carry13 carry15 carry4 carry3
      carry11_1 carry3_1 carry4_1 carry11_2 carry3_2 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl m1772 rfl rfl
      m1777 rfl m1782 rfl rfl rfl m1799 rfl rfl m1804 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      m1892 rfl rfl rfl rfl rfl m1968 rfl rfl rfl e1987 e1932 e1802 e1683 e1656 e1780 e1612 e1653
      e1680 e1775 e1797 e1676 e1650 e1672 e1646 e1766 e1792 e1668 e1642 e1890 e1915 e1958 e1964
      e2009 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
  have m2011 : t2011 = t2007 - t2009 <<< 21 := Bnd.and_mask_sub _
  have e2011 :=
    sc25519_reduce.bridge_s3_12 t1685 t1686 t1687 t1688 t1689 t1694 t1695 t1696 t1697 t1698 t1702
      t1703 t1704 t1705 t1706 t1707 t1712 t1713 t1719 t1720 t1721 t1722 t1723 t1724 t1767 t1768
      t1769 t1770 t1771 t1772 t1773 t1776 t1777 t1778 t1793 t1798 t1799 t1800 t1804 t1805 t1828
      t1829 t1846 t1847 t1860 t1861 t1874 t1875 t1887 t1916 t1939 t1954 t1955 t1956 t1963 t1995
      t1996 t2007 t2011 t1987 t1683 t1653 t1680 t1775 t1802 t1608 t1797 t1676 t1650 t1672 t1646
      t1766 t1792 t1668 t1642 t1886 t1932 t1915 t1953 t1958 t2006 t2009 s12_1 s13_1 s14_1 s15_1
      s12_2 s13_2 s14_2 s15_2 s12_3 s13_3 s14_3 s12_4 s13_4 s12_5 s13_5 s12_6 s15_3 s14_4 s12_7
      s14_5 s13_6 s15_4 s3_1 s3_2 s3_3 s3_4 s12_8 s3_5 s3_6 s12_9 s3_7 s12_10 s3_8 s3_9 s12_11 s3_10
      s3_11 s3_12 s3 s12 s13 s14 s15 s19 s20 s21 s22 s23 carry12 carry14 carry11 carry13 carry15
      carry2 carry3 carry11_1 carry2_1 carry3_1 carry11_2 carry2_2 carry3_2 rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      m1772 rfl rfl m1777 rfl rfl rfl m1799 rfl m1804 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl m1916
      rfl rfl rfl rfl m1963 rfl rfl rfl m2011 e1987 e1683 e1653 e1680 e1775 e1802 e1608 e1797 e1676
      e1650 e1672 e1646 e1766 e1792 e1668 e1642 e1886 e1932 e1915 e1953 e1958 e2006 e2009 rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
  have e2012 :=
    sc25519_reduce.bridge_carry4_2 t1685 t1686 t1687 t1688 t1689 t1690 t1691 t1694 t1695 t1696 t1697
      t1698 t1702 t1703 t1704 t1705 t1706 t1707 t1712 t1713 t1719 t1720 t1721 t1722 t1723 t1724
      t1767 t1768 t1769 t1770 t1771 t1772 t1773 t1776 t1777 t1778 t1782 t1783 t1793 t1798 t1799
      t1800 t1803 t1804 t1805 t1818 t1819 t1830 t1831 t1848 t1849 t1862 t1863 t1876 t1877 t1892
      t1940 t1959 t1960 t1961 t1962 t1968 t1997 t1998 t2010 t2012 t1987 t1932 t1802 t1683 t1656
      t1780 t1612 t1653 t1680 t1775 t1797 t1676 t1650 t1672 t1646 t1766 t1792 t1668 t1642 t1890
      t1915 t1958 t1964 t2009 s12_1 s13_1 s14_1 s15_1 s16_1 s12_2 s13_2 s14_2 s15_2 s12_3 s13_3
      s14_3 s12_4 s13_4 s12_5 s13_5 s12_6 s15_3 s14_4 s16_2 s12_7 s14_5 s13_6 s16_3 s15_4 s4_1 s4_2
      s4_3 s4_4 s4_5 s12_8 s4_6 s4_7 s12_9 s4_8 s12_10 s4_9 s4_10 s12_11 s4_11 s4_12 carry4_2 s4 s12
      s13 s14 s15 s16 s19 s20 s21 s22 s23 carry12 carry14 carry16 carry11 carry13 carry15 carry4
      carry3 carry11_1 carry3_1 carry4_1 carry11_2 carry3_2 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl m1772 rfl
      rfl m1777 rfl m1782 rfl rfl rfl m1799 rfl rfl m1804 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl m1892 rfl rfl rfl rfl rfl m1968 rfl rfl rfl rfl e1987 e1932 e1802 e1683 e1656 e1780 e1612
      e1653 e1680 e1775 e1797 e1676 e1650 e1672 e1646 e1766 e1792 e1668 e1642 e1890 e1915 e1958
      e1964 e2009 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
  have e2013 :=
    sc25519_reduce.bridge_s5_13 t1685 t1686 t1687 t1688 t1689 t1690 t1691 t1694 t1695 t1696 t1697
      t1698 t1702 t1703 t1704 t1705 t1706 t1707 t1712 t1713 t1719 t1720 t1721 t1722 t1723 t1724
      t1767 t1768 t1769 t1770 t1771 t1772 t1773 t1776 t1777 t1778 t1781 t1782 t1783 t1793 t1798
      t1799 t1800 t1803 t1804 t1805 t1806 t1807 t1820 t1821 t1832 t1833 t1850 t1851 t1864 t1865
      t1878 t1879 t1891 t1920 t1941 t1965 t1966 t1967 t1971 t1999 t2000 t2013 t1987 t1780 t1660
      t1616 t1802 t1683 t1656 t1653 t1680 t1775 t1797 t1676 t1650 t1672 t1646 t1766 t1792 t1668
      t1642 t1890 t1932 t1918 t1964 t1969 t2012 s12_1 s13_1 s14_1 s15_1 s16_1 s12_2 s13_2 s14_2
      s15_2 s12_3 s13_3 s14_3 s12_4 s13_4 s12_5 s13_5 s12_6 s15_3 s14_4 s17_1 s16_2 s12_7 s14_5
      s13_6 s16_3 s15_4 s5_1 s5_2 s5_3 s5_4 s5_5 s5_6 s12_8 s5_7 s5_8 s12_9 s5_9 s12_10 s5_10 s5_11
      s12_11 s5_12 s5_13 s5 s12 s13 s14 s15 s16 s17 s19 s20 s21 s22 s23 carry12 carry14 carry16
      carry11 carry13 carry15 carry4 carry5 carry11_1 carry4_1 carry5_1 carry11_2 carry4_2 rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl m1772 rfl rfl m1777 rfl rfl m1782 rfl rfl rfl m1799 rfl rfl m1804 rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl m1920 rfl rfl rfl rfl m1971 rfl rfl rfl
      e1987 e1780 e1660 e1616 e1802 e1683 e1656 e1653 e1680 e1775 e1797 e1676 e1650 e1672 e1646
      e1766 e1792 e1668 e1642 e1890 e1932 e1918 e1964 e1969 e2012 rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
  have m2014 : t2014 = t2010 - t2012 <<< 21 := Bnd.and_mask_sub _
  have e2014 :=
    sc25519_reduce.bridge_s4_13 t1685 t1686 t1687 t1688 t1689 t1690 t1691 t1694 t1695 t1696 t1697
      t1698 t1702 t1703 t1704 t1705 t1706 t1707 t1712 t1713 t1719 t1720 t1721 t1722 t1723 t1724
      t1767 t1768 t1769 t1770 t1771 t1772 t1773 t1776 t1777 t1778 t1782 t1783 t1793 t1798 t1799
      t1800 t1803 t1804 t1805 t1818 t1819 t1830 t1831 t1848 t1849 t1862 t1863 t1876 t1877 t1892
      t1940 t1959 t1960 t1961 t1962 t1968 t1997 t1998 t2010 t2014 t1987 t1932 t1802 t1683 t1656
      t1780 t1612 t1653 t1680 t1775 t1797 t1676 t1650 t1672 t1646 t1766 t1792 t1668 t1642 t1890
      t1915 t1958 t1964 t2009 t2012 s12_1 s13_1 s14_1 s15_1 s16_1 s12_2 s13_2 s14_2 s15_2 s12_3
      s13_3 s14_3 s12_4 s13_4 s12_5 s13_5 s12_6 s15_3 s14_4 s16_2 s12_7 s14_5 s13_6 s16_3 s15_4 s4_1
      s4_2 s4_3 s4_4 s4_5 s12_8 s4_6 s4_7 s12_9 s4_8 s12_10 s4_9 s4_10 s12_11 s4_11 s4_12 s4_13 s4
      s12 s13 s14 s15 s16 s19 s20 s21 s22 s23 carry12 carry14 carry16 carry11 carry13 carry15 carry4
      carry3 carry11_1 carry3_1 carry4_1 carry11_2 carry3_2 carry4_2 rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      m1772 rfl rfl m1777 rfl m1782 rfl rfl rfl m1799 rfl rfl m1804 rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl m1892 rfl rfl rfl rfl rfl m1968 rfl rfl rfl m2014 e1987 e1932 e1802 e1683 e1656
      e1780 e1612 e1653 e1680 e1775 e1797 e1676 e1650 e1672 e1646 e1766 e1792 e1668 e1642 e1890
      e1915 e1958 e1964 e2009 e2012 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl
  have e2015 :=
    sc25519_reduce.bridge_carry5_2 t1685 t1686 t1687 t1688 t1689 t1690 t1691 t1694 t1695 t1696 t1697
      t1698 t1702 t1703 t1704 t1705 t1706 t1707 t1712 t1713 t1719 t1720 t1721 t1722 t1723 t1724
      t1767 t1768 t1769 t1770 t1771 t1772 t1773 t1776 t1777 t1778 t1781 t1782 t1783 t1793 t1798
      t1799 t1800 t1803 t1804 t1805 t1806 t1807 t1820 t1821 t1832 t1833 t1850 t1851 t1864 t1865
      t1878 t1879 t1891 t1920 t1941 t1965 t1966 t1967 t1971 t1999 t2000 t2013 t2015 t1987 t1780
      t1660 t1616 t1802 t1683 t1656 t1653 t1680 t1775 t1797 t1676 t1650 t1672 t1646 t1766 t1792
      t1668 t1642 t1890 t1932 t1918 t1964 t1969 t2012 s12_1 s13_1 s14_1 s15_1 s16_1 s12_2 s13_2
      s14_2 s15_2 s12_3 s13_3 s14_3 s12_4 s13_4 s12_5 s13_5 s12_6 s15_3 s14_4 s17_1 s16_2 s12_7
      s14_5 s13_6 s16_3 s15_4 s5_1 s5_2 s5_3 s5_4 s5_5 s5_6 s12_8 s5_7 s5_8 s12_9 s5_9 s12_10 s5_10
      s5_11 s12_11 s5_12 s5_13 carry5_2 s5 s12 s13 s14 s15 s16 s17 s19 s20 s21 s22 s23 carry12
      carry14 carry16 carry11 carry13 carry15 carry4 carry5 carry11_1 carry4_1 carry5_1 carry11_2
      carry4_2 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl m1772 rfl rfl m1777 rfl rfl m1782 rfl rfl rfl m1799
      rfl rfl m1804 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl m1920 rfl rfl rfl rfl
      m1971 rfl rfl rfl rfl e1987 e1780 e1660 e1616 e1802 e1683 e1656 e1653 e1680 e1775 e1797 e1676
      e1650 e1672 e1646 e1766 e1792 e1668 e1642 e1890 e1932 e1918 e1964 e1969 e2012 rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
  have e2016 :=
    sc25519_reduce.bridge_s6_12 t1686 t1687 t1688 t1689 t1690 t1691 t1695 t1696 t1697 t1698 t1703
      t1704 t1705 t1706 t1707 t1713 t1725 t1726 t1745 t1746 t1767 t1768 t1769 t1770 t1771 t1776
      t1777 t1778 t1781 t1782 t1783 t1798 t1799 t1800 t1803 t1804 t1805 t1808 t1809 t1822 t1823
      t1834 t1835 t1852 t1853 t1866 t1867 t1896 t1897 t1919 t1970 t1974 t2016 t2015 t1664 t1620
      t1741 t1780 t1660 t1802 t1683 t1656 t1653 t1680 t1775 t1797 t1676 t1650 t1672 t1646 t1766
      t1894 t1918 t1969 t1972 s13_1 s14_1 s15_1 s16_1 s13_2 s14_2 s15_2 s13_3 s14_3 s13_4 s6_1 s6_2
      s13_5 s15_3 s14_4 s17_1 s16_2 s14_5 s13_6 s16_3 s15_4 s6_3 s6_4 s6_5 s6_6 s6_7 s6_8 s6_9 s6_10
      s6_11 s6_12 s6 s13 s14 s15 s16 s17 s18 s20 s21 s22 s23 carry6 carry12 carry14 carry16 carry13
      carry15 carry6_1 carry5 carry5_1 carry6_2 carry5_2 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl m1745 rfl rfl rfl rfl rfl rfl rfl m1777 rfl rfl m1782 rfl rfl
      m1799 rfl rfl m1804 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl m1896 rfl rfl rfl m1974 rfl
      e2015 e1664 e1620 e1741 e1780 e1660 e1802 e1683 e1656 e1653 e1680 e1775 e1797 e1676 e1650
      e1672 e1646 e1766 e1894 e1918 e1969 e1972 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
  have m2017 : t2017 = t2013 - t2015 <<< 21 := Bnd.and_mask_sub _
  have e2017 :=
    sc25519_reduce.bridge_s5_14 t1685 t1686 t1687 t1688 t1689 t1690 t1691 t1694 t1695 t1696 t1697
      t1698 t1702 t1703 t1704 t1705 t1706 t1707 t1712 t1713 t1719 t1720 t1721 t1722 t1723 t1724
      t1767 t1768 t1769 t1770 t1771 t1772 t1773 t1776 t1777 t1778 t1781 t1782 t1783 t1793 t1798
      t1799 t1800 t1803 t1804 t1805 t1806 t1807 t1820 t1821 t1832 t1833 t1850 t1851 t1864 t1865
      t1878 t1879 t1891 t1920 t1941 t1965 t1966 t1967 t1971 t1999 t2000 t2013 t2017 t1987 t1780
      t1660 t1616 t1802 t1683 t1656 t1653 t1680 t1775 t1797 t1676 t1650 t1672 t1646 t1766 t1792
      t1668 t1642 t1890 t1932 t1918 t1964 t1969 t2012 t2015 s12_1 s13_1 s14_1 s15_1 s16_1 s12_2
      s13_2 s14_2 s15_2 s12_3 s13_3 s14_3 s12_4 s13_4 s12_5 s13_5 s12_6 s15_3 s14_4 s17_1 s16_2
      s12_7 s14_5 s13_6 s16_3 s15_4 s5_1 s5_2 s5_3 s5_4 s5_5 s5_6 s12_8 s5_7 s5_8 s12_9 s5_9 s12_10
      s5_10 s5_11 s12_11 s5_12 s5_13 s5_14 s5 s12 s13 s14 s15 s16 s17 s19 s20 s21 s22 s23 carry12
      carry14 carry16 carry11 carry13 carry15 carry4 carry5 carry11_1 carry4_1 carry5_1 carry11_2
      carry4_2 carry5_2 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl m1772 rfl rfl m1777 rfl rfl m1782 rfl rfl rfl
      m1799 rfl rfl m1804 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl m1920 rfl rfl rfl
      rfl m1971 rfl rfl rfl m2017 e1987 e1780 e1660 e1616 e1802 e1683 e1656 e1653 e1680 e1775 e1797
      e1676 e1650 e1672 e1646 e1766 e1792 e1668 e1642 e1890 e1932 e1918 e1964 e1969 e2012 e2015 rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
  have e2018 :=
    sc25519_reduce.bridge_carry6_3 t1686 t1687 t1688 t1689 t1690 t1691 t1695 t1696 t1697 t1698 t1703
      t1704 t1705 t1706 t1707 t1713 t1725 t1726 t1745 t1746 t1767 t1768 t1769 t1770 t1771 t1776
      t1777 t1778 t1781 t1782 t1783 t1798 t1799 t1800 t1803 t1804 t1805 t1808 t1809 t1822 t1823
      t1834 t1835 t1852 t1853 t1866 t1867 t1896 t1897 t1919 t1970 t1974 t2016 t2018 t2015 t1664
      t1620 t1741 t1780 t1660 t1802 t1683 t1656 t1653 t1680 t1775 t1797 t1676 t1650 t1672 t1646
      t1766 t1894 t1918 t1969 t1972 s13_1 s14_1 s15_1 s16_1 s13_2 s14_2 s15_2 s13_3 s14_3 s13_4 s6_1
      s6_2 s13_5 s15_3 s14_4 s17_1 s16_2 s14_5 s13_6 s16_3 s15_4 s6_3 s6_4 s6_5 s6_6 s6_7 s6_8 s6_9
      s6_10 s6_11 s6_12 carry6_3 s6 s13 s14 s15 s16 s17 s18 s20 s21 s22 s23 carry6 carry12 carry14
      carry16 carry13 carry15 carry6_1 carry5 carry5_1 carry6_2 carry5_2 rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl m1745 rfl rfl rfl rfl rfl rfl rfl m1777 rfl rfl
      m1782 rfl rfl m1799 rfl rfl m1804 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl m1896 rfl rfl
      rfl m1974 rfl rfl e2015 e1664 e1620 e1741 e1780 e1660 e1802 e1683 e1656 e1653 e1680 e1775
      e1797 e1676 e1650 e1672 e1646 e1766 e1894 e1918 e1969 e1972 rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl
  have e2019 :=
    sc25519_reduce.bridge_s7_13 t1687 t1688 t1689 t1690 t1691 t1696 t1697 t1698 t1704 t1705 t1706
      t1707 t1714 t1727 t1742 t1743 t1744 t1776 t1777 t1778 t1781 t1782 t1783 t1786 t1787 t1798
      t1803 t1804 t1805 t1810 t1811 t1824 t1825 t1836 t1837 t1854 t1855 t1895 t1924 t1925 t1973
      t1977 t2019 t2018 t1972 t1664 t1623 t1668 t1741 t1785 t1780 t1660 t1802 t1683 t1656 t1653
      t1680 t1775 t1797 t1676 t1650 t1894 t1922 t1975 s14_1 s15_1 s16_1 s14_2 s15_2 s14_3 s7_1 s7_2
      s7_3 s15_3 s14_4 s17_1 s16_2 s7_4 s14_5 s16_3 s15_4 s7_5 s7_6 s7_7 s7_8 s7_9 s7_10 s7_11 s7_12
      s7_13 s7 s14 s15 s16 s17 s18 s19 s21 s22 s23 carry6 carry14 carry16 carry7 carry13 carry15
      carry6_1 carry7_1 carry6_2 carry7_2 carry6_3 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl m1777 rfl rfl m1782 rfl m1786 rfl rfl rfl m1804 rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl m1924 rfl rfl m1977 rfl e2018 e1972 e1664 e1623 e1668 e1741 e1785 e1780
      e1660 e1802 e1683 e1656 e1653 e1680 e1775 e1797 e1676 e1650 e1894 e1922 e1975 rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
  have m2020 : t2020 = t2016 - t2018 <<< 21 := Bnd.and_mask_sub _
  have e2020 :=
    sc25519_reduce.bridge_s6_13 t1686 t1687 t1688 t1689 t1690 t1691 t1695 t1696 t1697 t1698 t1703
      t1704 t1705 t1706 t1707 t1713 t1725 t1726 t1745 t1746 t1767 t1768 t1769 t1770 t1771 t1776
      t1777 t1778 t1781 t1782 t1783 t1798 t1799 t1800 t1803 t1804 t1805 t1808 t1809 t1822 t1823
      t1834 t1835 t1852 t1853 t1866 t1867 t1896 t1897 t1919 t1970 t1974 t2016 t2020 t2015 t1664
      t1620 t1741 t1780 t1660 t1802 t1683 t1656 t1653 t1680 t1775 t1797 t1676 t1650 t1672 t1646
      t1766 t1894 t1918 t1969 t1972 t2018 s13_1 s14_1 s15_1 s16_1 s13_2 s14_2 s15_2 s13_3 s14_3
      s13_4 s6_1 s6_2 s13_5 s15_3 s14_4 s17_1 s16_2 s14_5 s13_6 s16_3 s15_4 s6_3 s6_4 s6_5 s6_6 s6_7
      s6_8 s6_9 s6_10 s6_11 s6_12 s6_13 s6 s13 s14 s15 s16 s17 s18 s20 s21 s22 s23 carry6 carry12
      carry14 carry16 carry13 carry15 carry6_1 carry5 carry5_1 carry6_2 carry5_2 carry6_3 rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl m1745 rfl rfl rfl rfl rfl rfl
      rfl m1777 rfl rfl m1782 rfl rfl m1799 rfl rfl m1804 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl m1896 rfl rfl rfl m1974 rfl m2020 e2015 e1664 e1620 e1741 e1780 e1660 e1802 e1683 e1656
      e1653 e1680 e1775 e1797 e1676 e1650 e1672 e1646 e1766 e1894 e1918 e1969 e1972 e2018 rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl
  have e2021 :=
    sc25519_reduce.bridge_carry7_3 t1687 t1688 t1689 t1690 t1691 t1696 t1697 t1698 t1704 t1705 t1706
      t1707 t1714 t1727 t1742 t1743 t1744 t1776 t1777 t1778 t1781 t1782 t1783 t1786 t1787 t1798
      t1803 t1804 t1805 t1810 t1811 t1824 t1825 t1836 t1837 t1854 t1855 t1895 t1924 t1925 t1973
      t1977 t2019 t2021 t2018 t1972 t1664 t1623 t1668 t1741 t1785 t1780 t1660 t1802 t1683 t1656
      t1653 t1680 t1775 t1797 t1676 t1650 t1894 t1922 t1975 s14_1 s15_1 s16_1 s14_2 s15_2 s14_3 s7_1
      s7_2 s7_3 s15_3 s14_4 s17_1 s16_2 s7_4 s14_5 s16_3 s15_4 s7_5 s7_6 s7_7 s7_8 s7_9 s7_10 s7_11
      s7_12 s7_13 carry7_3 s7 s14 s15 s16 s17 s18 s19 s21 s22 s23 carry6 carry14 carry16 carry7
      carry13 carry15 carry6_1 carry7_1 carry6_2 carry7_2 carry6_3 rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl m1777 rfl rfl m1782 rfl m1786 rfl rfl rfl m1804 rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl m1924 rfl rfl m1977 rfl rfl e2018 e1972 e1664 e1623 e1668
      e1741 e1785 e1780 e1660 e1802 e1683 e1656 e1653 e1680 e1775 e1797 e1676 e1650 e1894 e1922
      e1975 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl
  have e2022 :=
    sc25519_reduce.bridge_s8_13 t1688 t1689 t1690 t1691 t1697 t1698 t1708 t1715 t1728 t1729 t1730
      t1731 t1754 t1776 t1781 t1782 t1783 t1803 t1804 t1805 t1812 t1826 t1838 t1839 t1840 t1841
      t1842 t1843 t1904 t1905 t1923 t1976 t1980 t2022 t2021 t1785 t1664 t1626 t1668 t1672 t1748
      t1780 t1660 t1802 t1683 t1656 t1653 t1680 t1775 t1899 t1922 t1975 t1978 s15_1 s16_1 s15_2 s8_1
      s8_2 s8_3 s8_4 s15_3 s17_1 s16_2 s8_5 s16_3 s15_4 s8_6 s8_7 s8_8 s8_9 s8_10 s8_11 s8_12 s8_13
      s8 s15 s16 s17 s18 s19 s20 s22 s23 carry8 carry14 carry16 carry7 carry15 carry8_1 carry7_1
      carry7_2 carry8_2 carry7_3 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl m1754 rfl rfl m1782
      rfl rfl m1804 rfl rfl rfl rfl rfl rfl rfl rfl rfl m1904 rfl rfl rfl m1980 rfl e2021 e1785
      e1664 e1626 e1668 e1672 e1748 e1780 e1660 e1802 e1683 e1656 e1653 e1680 e1775 e1899 e1922
      e1975 e1978 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl
  have e2023 :=
    sc25519_reduce.bridge_carry8_3 t1688 t1689 t1690 t1691 t1697 t1698 t1708 t1715 t1728 t1729 t1730
      t1731 t1754 t1776 t1781 t1782 t1783 t1803 t1804 t1805 t1812 t1826 t1838 t1839 t1840 t1841
      t1842 t1843 t1904 t1905 t1923 t1976 t1980 t2022 t2023 t2021 t1785 t1664 t1626 t1668 t1672
      t1748 t1780 t1660 t1802 t1683 t1656 t1653 t1680 t1775 t1899 t1922 t1975 t1978 s15_1 s16_1
      s15_2 s8_1 s8_2 s8_3 s8_4 s15_3 s17_1 s16_2 s8_5 s16_3 s15_4 s8_6 s8_7 s8_8 s8_9 s8_10 s8_11
      s8_12 s8_13 carry8_3 s8 s15 s16 s17 s18 s19 s20 s22 s23 carry8 carry14 carry16 carry7 carry15
      carry8_1 carry7_1 carry7_2 carry8_2 carry7_3 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      m1754 rfl rfl m1782 rfl rfl m1804 rfl rfl rfl rfl rfl rfl rfl rfl rfl m1904 rfl rfl rfl m1980
      rfl rfl e2021 e1785 e1664 e1626 e1668 e1672 e1748 e1780 e1660 e1802 e1683 e1656 e1653 e1680
      e1775 e1899 e1922 e1975 e1978 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl
  have e2024 :=
    sc25519_reduce.bridge_s9_13 t1690 t1691 t1699 t1709 t1716 t1732 t1749 t1750 t1751 t1752 t1753
      t1781 t1782 t1783 t1790 t1803 t1813 t1827 t1900 t1901 t1902 t1903 t1929 t1930 t1979 t1983
      t2024 t2023 t1978 t1780 t1660 t1664 t1630 t1668 t1672 t1676 t1748 t1789 t1802 t1683 t1656
      t1899 t1927 t1981 s16_1 s9_1 s9_2 s9_3 s9_4 s9_5 s17_1 s16_2 s9_6 s16_3 s9_7 s9_8 s9_9 s9_10
      s9_11 s9_12 s9_13 s9 s16 s17 s18 s19 s20 s21 s23 carry8 carry16 carry9 carry15 carry8_1
      carry9_1 carry8_2 carry9_2 carry8_3 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl m1782 rfl
      m1790 rfl rfl rfl rfl rfl rfl rfl m1929 rfl rfl m1983 rfl e2023 e1978 e1780 e1660 e1664 e1630
      e1668 e1672 e1676 e1748 e1789 e1802 e1683 e1656 e1899 e1927 e1981 rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
  have e2025 :=
    sc25519_reduce.bridge_carry9_3 t1690 t1691 t1699 t1709 t1716 t1732 t1749 t1750 t1751 t1752 t1753
      t1781 t1782 t1783 t1790 t1803 t1813 t1827 t1900 t1901 t1902 t1903 t1929 t1930 t1979 t1983
      t2024 t2025 t2023 t1978 t1780 t1660 t1664 t1630 t1668 t1672 t1676 t1748 t1789 t1802 t1683
      t1656 t1899 t1927 t1981 s16_1 s9_1 s9_2 s9_3 s9_4 s9_5 s17_1 s16_2 s9_6 s16_3 s9_7 s9_8 s9_9
      s9_10 s9_11 s9_12 s9_13 carry9_3 s9 s16 s17 s18 s19 s20 s21 s23 carry8 carry16 carry9 carry15
      carry8_1 carry9_1 carry8_2 carry9_2 carry8_3 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      m1782 rfl m1790 rfl rfl rfl rfl rfl rfl rfl m1929 rfl rfl m1983 rfl rfl e2023 e1978 e1780
      e1660 e1664 e1630 e1668 e1672 e1676 e1748 e1789 e1802 e1683 e1656 e1899 e1927 e1981 rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
  have e2026 :=
    sc25519_reduce.bridge_s10_13 t1692 t1700 t1710 t1717 t1733 t1734 t1735 t1736 t1737 t1738 t1764
      t1781 t1814 t1815 t1816 t1817 t1909 t1910 t1928 t1982 t1986 t2026 t2025 t1780 t1660 t1664
      t1634 t1668 t1672 t1676 t1680 t1789 t1756 t1907 t1927 t1981 t1984 s10_1 s10_2 s10_3 s10_4
      s10_5 s10_6 s17_1 s10_7 s10_8 s10_9 s10_10 s10_11 s10_12 s10_13 s10 s17 s18 s19 s20 s21 s22
      carry10 carry16 carry9 carry10_1 carry9_1 carry9_2 carry10_2 carry9_3 rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl m1764 rfl rfl rfl rfl rfl m1909 rfl rfl rfl m1986 rfl e2025 e1780 e1660 e1664
      e1634 e1668 e1672 e1676 e1680 e1789 e1756 e1907 e1927 e1981 e1984 rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl
  have m2027 : t2027 = t2024 - t2025 <<< 21 := Bnd.and_mask_sub _
  have e2027 :=
    sc25519_reduce.bridge_s9_14 t1690 t1691 t1699 t1709 t1716 t1732 t1749 t1750 t1751 t1752 t1753
      t1781 t1782 t1783 t1790 t1803 t1813 t1827 t1900 t1901 t1902 t1903 t1929 t1930 t1979 t1983
      t2024 t2027 t2023 t1978 t1780 t1660 t1664 t1630 t1668 t1672 t1676 t1748 t1789 t1802 t1683
      t1656 t1899 t1927 t1981 t2025 s16_1 s9_1 s9_2 s9_3 s9_4 s9_5 s17_1 s16_2 s9_6 s16_3 s9_7 s9_8
      s9_9 s9_10 s9_11 s9_12 s9_13 s9_14 s9 s16 s17 s18 s19 s20 s21 s23 carry8 carry16 carry9
      carry15 carry8_1 carry9_1 carry8_2 carry9_2 carry8_3 carry9_3 rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl m1782 rfl m1790 rfl rfl rfl rfl rfl rfl rfl m1929 rfl rfl m1983 rfl m2027
      e2023 e1978 e1780 e1660 e1664 e1630 e1668 e1672 e1676 e1748 e1789 e1802 e1683 e1656 e1899
      e1927 e1981 e2025 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
  have e2028 :=
    sc25519_reduce.bridge_carry10_3 t1692 t1700 t1710 t1717 t1733 t1734 t1735 t1736 t1737 t1738
      t1764 t1781 t1814 t1815 t1816 t1817 t1909 t1910 t1928 t1982 t1986 t2026 t2028 t2025 t1780
      t1660 t1664 t1634 t1668 t1672 t1676 t1680 t1789 t1756 t1907 t1927 t1981 t1984 s10_1 s10_2
      s10_3 s10_4 s10_5 s10_6 s17_1 s10_7 s10_8 s10_9 s10_10 s10_11 s10_12 s10_13 carry10_3 s10 s17
      s18 s19 s20 s21 s22 carry10 carry16 carry9 carry10_1 carry9_1 carry9_2 carry10_2 carry9_3 rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl m1764 rfl rfl rfl rfl rfl m1909 rfl rfl rfl m1986 rfl rfl
      e2025 e1780 e1660 e1664 e1634 e1668 e1672 e1676 e1680 e1789 e1756 e1907 e1927 e1981 e1984 rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
  have e2029 :=
    sc25519_reduce.bridge_s11_13 t1684 t1693 t1701 t1711 t1718 t1739 t1757 t1758 t1759 t1760 t1761
      t1762 t1763 t1794 t1795 t1908 t1933 t1934 t1985 t1988 t2029 t2028 t1984 t1907 t1664 t1638
      t1668 t1672 t1676 t1683 t1680 t1756 t1792 t1932 t1987 s11_1 s11_2 s11_3 s11_4 s11_5 s11_6
      s11_7 s11_8 s11_9 s11_10 s11_11 s11_12 s11_13 s11 s18 s19 s20 s21 s22 s23 carry10 carry11
      carry10_1 carry11_1 carry10_2 carry11_2 carry10_3 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl m1794 rfl rfl m1933 rfl rfl m1988 rfl e2028 e1984 e1907 e1664 e1638 e1668 e1672 e1676
      e1683 e1680 e1756 e1792 e1932 e1987 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
  have m2030 : t2030 = t2026 - t2028 <<< 21 := Bnd.and_mask_sub _
  have e2030 :=
    sc25519_reduce.bridge_s10_14 t1692 t1700 t1710 t1717 t1733 t1734 t1735 t1736 t1737 t1738 t1764
      t1781 t1814 t1815 t1816 t1817 t1909 t1910 t1928 t1982 t1986 t2026 t2030 t2025 t1780 t1660
      t1664 t1634 t1668 t1672 t1676 t1680 t1789 t1756 t1907 t1927 t1981 t1984 t2028 s10_1 s10_2
      s10_3 s10_4 s10_5 s10_6 s17_1 s10_7 s10_8 s10_9 s10_10 s10_11 s10_12 s10_13 s10_14 s10 s17 s18
      s19 s20 s21 s22 carry10 carry16 carry9 carry10_1 carry9_1 carry9_2 carry10_2 carry9_3
      carry10_3 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl m1764 rfl rfl rfl rfl rfl m1909 rfl rfl rfl
      m1986 rfl m2030 e2025 e1780 e1660 e1664 e1634 e1668 e1672 e1676 e1680 e1789 e1756 e1907 e1927
      e1981 e1984 e2028 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
  exact
    sc25519_reduce.out_eq e1990 e2002 e2004 e2005 e2007 e2008 e2010 e2011 e2013 e2014 e2016 e2017
      e2019 e2020 e2022 e2024 e2026 e2027 e2029 e2030 rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl
      rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl rfl

end Compiled

/-! ## Proof -/

section Proof

/-- The constants the code reads. -/
abbrev sc25519_reduce.Consts (E : ⟪sc25519_reduce.Γ⟫) : Prop :=
  E ⊨ [%1567 := 2097151#64, %1568 := 2#64, %1569 := 5#64, %1570 := 7#64, %1571 := 4#64, %1572 :=
    1#64, %1573 := 15#64, %1574 := 6#64, %1575 := 18#64, %1576 := 3#64, %1577 := 21#64, %1578 :=
    31#64, %1579 := 666643#64, %1580 := 470296#64, %1581 := 654183#64, %1582 :=
    18446744073708553811#64, %1583 := 136657#64, %1584 := 18446744073708867715#64, %1585 :=
    1048576#64, %1586 := 8796090925056#64, %1587 := 9223372036852678656#64, %1588 :=
    18446744073707454464#64, %1589 := 16#64, %1590 := 19#64, %1591 := 14#64, %1592 := 17#64,
    %1593 := 20#64, %1594 := 9#64]

/-- `^bb0` from instruction 0 to 60: its values named, with their forms and bounds. -/
theorem sc25519_reduce.run0 {β : Type} {p : Pointer}
    {blk : BasicBlock sc25519_reduce.Γ [] sc25519_reduce.blockTys}
    (hbody : blk.body.drop 0 = sc25519_reduce.entry.body.drop 0) {E : ⟪sc25519_reduce.Γ⟫}
    {S : GlobalState} {g : ⟪sc25519_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hArgs : E.args = (sc25519_reduce.args (.value p)).get) (hwf : S.WF)
    (hp : Fits S.mem p (8 * 64)) (hp_off : ¬p.offset.uaddOverflow 64#64)
    (hK :
      ∀ (E' : ⟪sc25519_reduce.Γ⟫)
        (t1595 s0 t1598 t1599 s1 t1602 t1603 s2 t1606 t1607 s3 t1610 t1611 s4 t1614 t1615 s5 t1618
          t1619 s6 t1622 s7 t1625 s8 : BitVec 64),
        (hArgs : E'.args = (sc25519_reduce.args (.value p)).get) →
          (hc : sc25519_reduce.Consts E') →
          (hR :
            E' ⊨ [%1596 := s0, %1600 := s1, %1604 := s2, %1608 := s3, %1612 := s4, %1616 := s5,
              %1620 := s6, %1623 := s7, %1626 := s8, %1597 := p.add 2#64, %1601 := p.add 5#64,
              %1605 := p.add 7#64, %1609 := p.add 10#64, %1613 := p.add 13#64, %1617 := p.add 15#64,
              %1621 := p.add 18#64, %1624 := p.add 21#64]) →
          (ht1595 : t1595 = load3 (S.mem.readAt p 512) 0) →
          (hs0 : s0 = t1595 &&& 2097151#64) →
          (ht1598 : t1598 = load4 (S.mem.readAt p 512) 2) →
          (ht1599 : t1599 = t1598 >>> 5) →
          (hs1 : s1 = t1599 &&& 2097151#64) →
          (ht1602 : t1602 = load3 (S.mem.readAt p 512) 5) →
          (ht1603 : t1603 = t1602 >>> 2) →
          (hs2 : s2 = t1603 &&& 2097151#64) →
          (ht1606 : t1606 = load4 (S.mem.readAt p 512) 7) →
          (ht1607 : t1607 = t1606 >>> 7) →
          (hs3 : s3 = t1607 &&& 2097151#64) →
          (ht1610 : t1610 = load4 (S.mem.readAt p 512) 10) →
          (ht1611 : t1611 = t1610 >>> 4) →
          (hs4 : s4 = t1611 &&& 2097151#64) →
          (ht1614 : t1614 = load3 (S.mem.readAt p 512) 13) →
          (ht1615 : t1615 = t1614 >>> 1) →
          (hs5 : s5 = t1615 &&& 2097151#64) →
          (ht1618 : t1618 = load4 (S.mem.readAt p 512) 15) →
          (ht1619 : t1619 = t1618 >>> 6) →
          (hs6 : s6 = t1619 &&& 2097151#64) →
          (ht1622 : t1622 = load3 (S.mem.readAt p 512) 18) →
          (hs7 : s7 = t1622 >>> 3) →
          (ht1625 : t1625 = load3 (S.mem.readAt p 512) 21) →
          (hs8 : s8 = t1625 &&& 2097151#64) →
          (hbs5 : Bnd s5 0 2097151) →
          (hbs6 : Bnd s6 0 2097151) →
          (hbs7 : Bnd s7 0 2097151) →
          (hbs8 : Bnd s8 0 2097151) → (blk.runBodyFrom E' 60 S >>= g) = K) :
    (blk.runBodyFrom E 0 S >>= g) = K := by
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_call using (load_3.call_eq (hp_off := BitVec.not_uaddOverflow_of_le hp_off (by decide))) with
    t1595
  step_pure with s0
  step_pure
  step_call using load_4.call_eq with t1598
  step_pure with t1599
  step_pure with s1
  step_pure
  step_call using (load_3.call_eq (hp_off := off3 hp_off 5 (by decide))) with t1602
  step_pure with t1603
  step_pure with s2
  step_pure
  step_call using load_4.call_eq with t1606
  step_pure with t1607
  step_pure with s3
  step_pure
  step_call using load_4.call_eq with t1610
  step_pure with t1611
  step_pure with s4
  step_pure
  step_call using (load_3.call_eq (hp_off := off3 hp_off 13 (by decide))) with t1614
  step_pure with t1615
  step_pure with s5
  bnd_ext s5
  step_pure
  step_call using load_4.call_eq with t1618
  step_pure with t1619
  step_pure with s6
  bnd_ext s6
  step_pure
  step_call using (load_3.call_eq (hp_off := off3 hp_off 18 (by decide))) with t1622
  bnd_ext t1622
  step_pure with s7
  bnd_ext s7
  step_pure
  step_call using (load_3.call_eq (hp_off := off3 hp_off 21 (by decide))) with t1625
  step_pure with s8
  bnd_ext s8
  subst hS
  exact
    hK _ t1595 s0 t1598 t1599 s1 t1602 t1603 s2 t1606 t1607 s3 t1610 t1611 s4 t1614 t1615 s5 t1618
      t1619 s6 t1622 s7 t1625 s8 hArgs
      (by
        unfold sc25519_reduce.Consts; env_reads)
      (by env_reads) (ht1595.trans (Boringssl.x25519_sc_reduce.setWidth_load3 _)) hs0 ht1598 ht1599
      hs1 ht1602 ht1603 hs2 ht1606 ht1607 hs3 ht1610 ht1611 hs4 ht1614 ht1615 hs5 ht1618 ht1619 hs6
      ht1622 hs7 ht1625 hs8 hbs5 hbs6 hbs7 hbs8

/-- `^bb0` from instruction 60 to 116: its values named, with their forms and bounds. -/
theorem sc25519_reduce.run60 {β : Type} {p : Pointer}
    {blk : BasicBlock sc25519_reduce.Γ [] sc25519_reduce.blockTys}
    (hbody : blk.body.drop 60 = sc25519_reduce.entry.body.drop 60) {E : ⟪sc25519_reduce.Γ⟫}
    {S : GlobalState} {g : ⟪sc25519_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0 s1 s2 s3 s4 s5 s6 s7 s8 : BitVec 64} (hArgs : E.args = (sc25519_reduce.args (.value p)).get)
    (hwf : S.WF) (hp : Fits S.mem p (8 * 64)) (hp_off : ¬p.offset.uaddOverflow 64#64)
    (hc : sc25519_reduce.Consts E)
    (hR :
      E ⊨ [%1596 := s0, %1600 := s1, %1604 := s2, %1608 := s3, %1612 := s4, %1616 := s5, %1620 :=
        s6, %1623 := s7, %1626 := s8, %1597 := p.add 2#64, %1601 := p.add 5#64, %1605 := p.add 7#64,
        %1609 := p.add 10#64, %1613 := p.add 13#64, %1617 := p.add 15#64, %1621 := p.add 18#64,
        %1624 := p.add 21#64])
    (hK :
      ∀ (E' : ⟪sc25519_reduce.Γ⟫)
        (t1628 t1629 s9 t1632 t1633 s10 t1636 t1637 s11 t1640 t1641 s12 t1644 t1645 s13 t1648 t1649
          s14 t1652 s15 t1655 s16 t1658 t1659 s17 t1662 t1663 s18 t1666 t1667 s19 t1670 t1671 s20
          t1674 t1675 s21 t1678 t1679 s22 t1682 : BitVec 64),
        (hArgs : E'.args = (sc25519_reduce.args (.value p)).get) →
          (hc : sc25519_reduce.Consts E') →
          (hR :
            E' ⊨ [%1596 := s0, %1600 := s1, %1604 := s2, %1608 := s3, %1612 := s4, %1616 := s5,
              %1620 := s6, %1623 := s7, %1626 := s8, %1630 := s9, %1634 := s10, %1638 := s11,
              %1642 := s12, %1646 := s13, %1650 := s14, %1653 := s15, %1656 := s16, %1660 := s17,
              %1664 := s18, %1668 := s19, %1672 := s20, %1676 := s21, %1680 := s22, %1682 := t1682,
              %1597 := p.add 2#64, %1601 := p.add 5#64, %1605 := p.add 7#64, %1609 := p.add 10#64,
              %1613 := p.add 13#64, %1617 := p.add 15#64, %1621 := p.add 18#64, %1624 :=
              p.add 21#64, %1627 := p.add 23#64, %1631 := p.add 26#64, %1635 := p.add 28#64,
              %1639 := p.add 31#64]) →
          (ht1628 : t1628 = load4 (S.mem.readAt p 512) 23) →
          (ht1629 : t1629 = t1628 >>> 5) →
          (hs9 : s9 = t1629 &&& 2097151#64) →
          (ht1632 : t1632 = load3 (S.mem.readAt p 512) 26) →
          (ht1633 : t1633 = t1632 >>> 2) →
          (hs10 : s10 = t1633 &&& 2097151#64) →
          (ht1636 : t1636 = load4 (S.mem.readAt p 512) 28) →
          (ht1637 : t1637 = t1636 >>> 7) →
          (hs11 : s11 = t1637 &&& 2097151#64) →
          (ht1640 : t1640 = load4 (S.mem.readAt p 512) 31) →
          (ht1641 : t1641 = t1640 >>> 4) →
          (hs12 : s12 = t1641 &&& 2097151#64) →
          (ht1644 : t1644 = load3 (S.mem.readAt p 512) 34) →
          (ht1645 : t1645 = t1644 >>> 1) →
          (hs13 : s13 = t1645 &&& 2097151#64) →
          (ht1648 : t1648 = load4 (S.mem.readAt p 512) 36) →
          (ht1649 : t1649 = t1648 >>> 6) →
          (hs14 : s14 = t1649 &&& 2097151#64) →
          (ht1652 : t1652 = load3 (S.mem.readAt p 512) 39) →
          (hs15 : s15 = t1652 >>> 3) →
          (ht1655 : t1655 = load3 (S.mem.readAt p 512) 42) →
          (hs16 : s16 = t1655 &&& 2097151#64) →
          (ht1658 : t1658 = load4 (S.mem.readAt p 512) 44) →
          (ht1659 : t1659 = t1658 >>> 5) →
          (hs17 : s17 = t1659 &&& 2097151#64) →
          (ht1662 : t1662 = load3 (S.mem.readAt p 512) 47) →
          (ht1663 : t1663 = t1662 >>> 2) →
          (hs18 : s18 = t1663 &&& 2097151#64) →
          (ht1666 : t1666 = load4 (S.mem.readAt p 512) 49) →
          (ht1667 : t1667 = t1666 >>> 7) →
          (hs19 : s19 = t1667 &&& 2097151#64) →
          (ht1670 : t1670 = load4 (S.mem.readAt p 512) 52) →
          (ht1671 : t1671 = t1670 >>> 4) →
          (hs20 : s20 = t1671 &&& 2097151#64) →
          (ht1674 : t1674 = load3 (S.mem.readAt p 512) 55) →
          (ht1675 : t1675 = t1674 >>> 1) →
          (hs21 : s21 = t1675 &&& 2097151#64) →
          (ht1678 : t1678 = load4 (S.mem.readAt p 512) 57) →
          (ht1679 : t1679 = t1678 >>> 6) →
          (hs22 : s22 = t1679 &&& 2097151#64) →
          (ht1682 : t1682 = load4 (S.mem.readAt p 512) 60) →
          (hbs9 : Bnd s9 0 2097151) →
          (hbs10 : Bnd s10 0 2097151) →
          (hbs11 : Bnd s11 0 2097151) →
          (hbs12 : Bnd s12 0 2097151) →
          (hbs13 : Bnd s13 0 2097151) →
          (hbs14 : Bnd s14 0 2097151) →
          (hbs15 : Bnd s15 0 2097151) →
          (hbs16 : Bnd s16 0 2097151) →
          (hbs17 : Bnd s17 0 2097151) →
          (hbs18 : Bnd s18 0 2097151) →
          (hbs19 : Bnd s19 0 2097151) →
          (hbs20 : Bnd s20 0 2097151) →
          (hbs21 : Bnd s21 0 2097151) →
          (hbs22 : Bnd s22 0 2097151) →
          (hbt1682 : Bnd t1682 0 4294967295) → (blk.runBodyFrom E' 116 S >>= g) = K) :
    (blk.runBodyFrom E 60 S >>= g) = K := by
  step_pure
  step_call using load_4.call_eq with t1628
  step_pure with t1629
  step_pure with s9
  bnd_ext s9
  step_pure
  step_call using (load_3.call_eq (hp_off := off3 hp_off 26 (by decide))) with t1632
  step_pure with t1633
  step_pure with s10
  bnd_ext s10
  step_pure
  step_call using load_4.call_eq with t1636
  step_pure with t1637
  step_pure with s11
  bnd_ext s11
  step_pure
  step_call using load_4.call_eq with t1640
  step_pure with t1641
  step_pure with s12
  bnd_ext s12
  step_pure
  step_call using (load_3.call_eq (hp_off := off3 hp_off 34 (by decide))) with t1644
  step_pure with t1645
  step_pure with s13
  bnd_ext s13
  step_pure
  step_call using load_4.call_eq with t1648
  step_pure with t1649
  step_pure with s14
  bnd_ext s14
  step_pure
  step_call using (load_3.call_eq (hp_off := off3 hp_off 39 (by decide))) with t1652
  bnd_ext t1652
  step_pure with s15
  bnd_ext s15
  step_pure
  step_call using (load_3.call_eq (hp_off := off3 hp_off 42 (by decide))) with t1655
  step_pure with s16
  bnd_ext s16
  step_pure
  step_call using load_4.call_eq with t1658
  step_pure with t1659
  step_pure with s17
  bnd_ext s17
  step_pure
  step_call using (load_3.call_eq (hp_off := off3 hp_off 47 (by decide))) with t1662
  step_pure with t1663
  step_pure with s18
  bnd_ext s18
  step_pure
  step_call using load_4.call_eq with t1666
  step_pure with t1667
  step_pure with s19
  bnd_ext s19
  step_pure
  step_call using load_4.call_eq with t1670
  step_pure with t1671
  step_pure with s20
  bnd_ext s20
  step_pure
  step_call using (load_3.call_eq (hp_off := off3 hp_off 55 (by decide))) with t1674
  step_pure with t1675
  step_pure with s21
  bnd_ext s21
  step_pure
  step_call using load_4.call_eq with t1678
  step_pure with t1679
  step_pure with s22
  bnd_ext s22
  step_pure
  step_call using load_4.call_eq with t1682
  bnd_ext t1682
  subst hS
  exact
    hK _ t1628 t1629 s9 t1632 t1633 s10 t1636 t1637 s11 t1640 t1641 s12 t1644 t1645 s13 t1648 t1649
      s14 t1652 s15 t1655 s16 t1658 t1659 s17 t1662 t1663 s18 t1666 t1667 s19 t1670 t1671 s20 t1674
      t1675 s21 t1678 t1679 s22 t1682 hArgs
      (by
        unfold sc25519_reduce.Consts; env_reads)
      (by env_reads) ht1628 ht1629 hs9 ht1632 ht1633 hs10 ht1636 ht1637 hs11 ht1640 ht1641 hs12
      ht1644 ht1645 hs13 ht1648 ht1649 hs14 ht1652 hs15 ht1655 hs16 ht1658 ht1659 hs17 ht1662 ht1663
      hs18 ht1666 ht1667 hs19 ht1670 ht1671 hs20 ht1674 ht1675 hs21 ht1678 ht1679 hs22 ht1682 hbs9
      hbs10 hbs11 hbs12 hbs13 hbs14 hbs15 hbs16 hbs17 hbs18 hbs19 hbs20 hbs21 hbs22 hbt1682

/-- `^bb0` from instruction 116 to 160: its values named, with their forms and bounds. -/
theorem sc25519_reduce.run116 {β : Type} {p : Pointer}
    {blk : BasicBlock sc25519_reduce.Γ [] sc25519_reduce.blockTys}
    (hbody : blk.body.drop 116 = sc25519_reduce.entry.body.drop 116) {E : ⟪sc25519_reduce.Γ⟫}
    {S : GlobalState} {g : ⟪sc25519_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0 s1 s2 s3 s4 s5 s6 s7 s8 s9 s10 s11 s12 s13 s14 s15 s16 s17 s18 s19 s20 s21 s22 t1682 :
      BitVec 64}
    (hArgs : E.args = (sc25519_reduce.args (.value p)).get) (hc : sc25519_reduce.Consts E)
    (hR :
      E ⊨ [%1596 := s0, %1600 := s1, %1604 := s2, %1608 := s3, %1612 := s4, %1616 := s5, %1620 :=
        s6, %1623 := s7, %1626 := s8, %1630 := s9, %1634 := s10, %1638 := s11, %1642 := s12,
        %1646 := s13, %1650 := s14, %1653 := s15, %1656 := s16, %1660 := s17, %1664 := s18, %1668 :=
        s19, %1672 := s20, %1676 := s21, %1680 := s22, %1682 := t1682, %1597 := p.add 2#64, %1601 :=
        p.add 5#64, %1605 := p.add 7#64, %1609 := p.add 10#64, %1613 := p.add 13#64, %1617 :=
        p.add 15#64, %1621 := p.add 18#64, %1624 := p.add 21#64, %1627 := p.add 23#64, %1631 :=
        p.add 26#64, %1635 := p.add 28#64, %1639 := p.add 31#64])
    (hbs6 : Bnd s6 0 2097151) (hbs12 : Bnd s12 0 2097151) (hbs14 : Bnd s14 0 2097151)
    (hbs15 : Bnd s15 0 2097151) (hbs16 : Bnd s16 0 2097151) (hbs18 : Bnd s18 0 2097151)
    (hbs19 : Bnd s19 0 2097151) (hbs20 : Bnd s20 0 2097151) (hbs21 : Bnd s21 0 2097151)
    (hbs22 : Bnd s22 0 2097151) (hbt1682 : Bnd t1682 0 4294967295)
    (hK :
      ∀ (E' : ⟪sc25519_reduce.Γ⟫)
        (s23 t1684 t1685 t1686 t1687 t1688 s15_1 t1690 s16_1 t1692 t1693 t1694 t1695 t1696 t1697
          s15_2 t1699 t1700 t1701 t1702 t1703 t1704 t1705 t1706 s14_3 t1708 t1709 t1710 t1711 t1712
          t1713 t1714 t1715 t1716 t1717 t1718 t1719 t1720 t1721 t1722 t1723 s12_5 t1725 s6_1 :
          BitVec 64),
        (hArgs : E'.args = (sc25519_reduce.args (.value p)).get) →
          (hc : sc25519_reduce.Consts E') →
          (hR :
            E' ⊨ [%1596 := s0, %1600 := s1, %1604 := s2, %1608 := s3, %1612 := s4, %1616 := s5,
              %1623 := s7, %1626 := s8, %1630 := s9, %1634 := s10, %1638 := s11, %1646 := s13,
              %1660 := s17, %1664 := s18, %1684 := t1684, %1686 := t1686, %1691 := s16_1, %1692 :=
              t1692, %1693 := t1693, %1695 := t1695, %1698 := s15_2, %1699 := t1699, %1700 := t1700,
              %1701 := t1701, %1703 := t1703, %1707 := s14_3, %1708 := t1708, %1709 := t1709,
              %1710 := t1710, %1711 := t1711, %1713 := t1713, %1714 := t1714, %1715 := t1715,
              %1716 := t1716, %1717 := t1717, %1718 := t1718, %1724 := s12_5, %1726 := s6_1,
              %1597 := p.add 2#64, %1601 := p.add 5#64, %1605 := p.add 7#64, %1609 := p.add 10#64,
              %1613 := p.add 13#64, %1617 := p.add 15#64, %1621 := p.add 18#64, %1624 :=
              p.add 21#64, %1627 := p.add 23#64, %1631 := p.add 26#64, %1635 := p.add 28#64,
              %1639 := p.add 31#64]) →
          (hs23 : s23 = t1682 >>> 3) →
          (ht1684 : t1684 = s23 * 666643#64) →
          (ht1685 : t1685 = s23 * 470296#64) →
          (ht1686 : t1686 = s23 * 654183#64) →
          (ht1687 : t1687 = s23 * 18446744073708553811#64) →
          (ht1688 : t1688 = s23 * 136657#64) →
          (hs15_1 : s15_1 = t1688 + s15) →
          (ht1690 : t1690 = s23 * 18446744073708867715#64) →
          (hs16_1 : s16_1 = t1690 + s16) →
          (ht1692 : t1692 = s22 * 666643#64) →
          (ht1693 : t1693 = s22 * 470296#64) →
          (ht1694 : t1694 = s22 * 654183#64) →
          (ht1695 : t1695 = s22 * 18446744073708553811#64) →
          (ht1696 : t1696 = s22 * 136657#64) →
          (ht1697 : t1697 = s22 * 18446744073708867715#64) →
          (hs15_2 : s15_2 = s15_1 + t1697) →
          (ht1699 : t1699 = s21 * 666643#64) →
          (ht1700 : t1700 = s21 * 470296#64) →
          (ht1701 : t1701 = s21 * 654183#64) →
          (ht1702 : t1702 = s21 * 18446744073708553811#64) →
          (ht1703 : t1703 = s21 * 136657#64) →
          (ht1704 : t1704 = s21 * 18446744073708867715#64) →
          (ht1705 : t1705 = t1704 + s14) →
          (ht1706 : t1706 = t1705 + t1687) →
          (hs14_3 : s14_3 = t1706 + t1696) →
          (ht1708 : t1708 = s20 * 666643#64) →
          (ht1709 : t1709 = s20 * 470296#64) →
          (ht1710 : t1710 = s20 * 654183#64) →
          (ht1711 : t1711 = s20 * 18446744073708553811#64) →
          (ht1712 : t1712 = s20 * 136657#64) →
          (ht1713 : t1713 = s20 * 18446744073708867715#64) →
          (ht1714 : t1714 = s19 * 666643#64) →
          (ht1715 : t1715 = s19 * 470296#64) →
          (ht1716 : t1716 = s19 * 654183#64) →
          (ht1717 : t1717 = s19 * 18446744073708553811#64) →
          (ht1718 : t1718 = s19 * 136657#64) →
          (ht1719 : t1719 = s19 * 18446744073708867715#64) →
          (ht1720 : t1720 = t1719 + s12) →
          (ht1721 : t1721 = t1720 + t1712) →
          (ht1722 : t1722 = t1721 + t1702) →
          (ht1723 : t1723 = t1722 + t1685) →
          (hs12_5 : s12_5 = t1723 + t1694) →
          (ht1725 : t1725 = s18 * 666643#64) →
          (hs6_1 : s6_1 = t1725 + s6) →
          (hbt1684 : Bnd t1684 0 357901234721773) →
          (hbt1686 : Bnd t1686 0 351211823170713) →
          (hbs16_1 : Bnd s16_1 (-367166552903811) 2097151) →
          (hbt1692 : Bnd t1692 0 1398051034093) →
          (hbt1693 : Bnd t1693 0 986281726696) →
          (hbt1695 : Bnd t1695 (-2092547753555) 0) →
          (hbs15_2 : Bnd s15_2 (-1434243666051) 73367170181678) →
          (hbt1699 : Bnd t1699 0 1398051034093) →
          (hbt1700 : Bnd t1700 0 986281726696) →
          (hbt1701 : Bnd t1701 0 1371920532633) →
          (hbt1703 : Bnd t1703 0 286590364207) →
          (hbs14_3 : Bnd s14_3 (-537126723016406) 286592461358) →
          (hbt1708 : Bnd t1708 0 1398051034093) →
          (hbt1709 : Bnd t1709 0 986281726696) →
          (hbt1710 : Bnd t1710 0 1371920532633) →
          (hbt1711 : Bnd t1711 (-2092547753555) 0) →
          (hbt1713 : Bnd t1713 (-1434243666051) 0) →
          (hbt1714 : Bnd t1714 0 1398051034093) →
          (hbt1715 : Bnd t1715 0 986281726696) →
          (hbt1716 : Bnd t1716 0 1371920532633) →
          (hbt1717 : Bnd t1717 (-2092547753555) 0) →
          (hbt1718 : Bnd t1718 0 286590364207) →
          (hbs12_5 : Bnd s12_5 (-3526791419606) 254146754953647) →
          (hbs6_1 : Bnd s6_1 0 1398053131244) → (blk.runBodyFrom E' 160 S >>= g) = K) :
    (blk.runBodyFrom E 116 S >>= g) = K := by
  step_pure with s23
  bnd_ext s23
  step_pure [nswMul, nuwMul] with t1684
  bnd_ext t1684
  step_pure [nswMul, nuwMul] with t1685
  bnd_ext t1685
  step_pure [nswMul, nuwMul] with t1686
  bnd_ext t1686
  step_pure [nswMul] with t1687
  bnd_ext t1687
  step_pure [nswMul, nuwMul] with t1688
  bnd_ext t1688
  step_pure [nswAdd, nuwAdd] with s15_1
  bnd_ext s15_1
  step_pure [nswMul] with t1690
  bnd_ext t1690
  step_pure [nswAdd] with s16_1
  bnd_ext s16_1
  step_pure [nswMul, nuwMul] with t1692
  bnd_ext t1692
  step_pure [nswMul, nuwMul] with t1693
  bnd_ext t1693
  step_pure [nswMul, nuwMul] with t1694
  bnd_ext t1694
  step_pure [nswMul] with t1695
  bnd_ext t1695
  step_pure [nswMul, nuwMul] with t1696
  bnd_ext t1696
  step_pure [nswMul] with t1697
  bnd_ext t1697
  step_pure [nswAdd] with s15_2
  bnd_ext s15_2
  step_pure [nswMul, nuwMul] with t1699
  bnd_ext t1699
  step_pure [nswMul, nuwMul] with t1700
  bnd_ext t1700
  step_pure [nswMul, nuwMul] with t1701
  bnd_ext t1701
  step_pure [nswMul] with t1702
  bnd_ext t1702
  step_pure [nswMul, nuwMul] with t1703
  bnd_ext t1703
  step_pure [nswMul] with t1704
  bnd_ext t1704
  step_pure [nswAdd] with t1705
  bnd_ext t1705
  step_pure [nswAdd] with t1706
  bnd_ext t1706
  step_pure [nswAdd] with s14_3
  bnd_ext s14_3
  step_pure [nswMul, nuwMul] with t1708
  bnd_ext t1708
  step_pure [nswMul, nuwMul] with t1709
  bnd_ext t1709
  step_pure [nswMul, nuwMul] with t1710
  bnd_ext t1710
  step_pure [nswMul] with t1711
  bnd_ext t1711
  step_pure [nswMul, nuwMul] with t1712
  bnd_ext t1712
  step_pure [nswMul] with t1713
  bnd_ext t1713
  step_pure [nswMul, nuwMul] with t1714
  bnd_ext t1714
  step_pure [nswMul, nuwMul] with t1715
  bnd_ext t1715
  step_pure [nswMul, nuwMul] with t1716
  bnd_ext t1716
  step_pure [nswMul] with t1717
  bnd_ext t1717
  step_pure [nswMul, nuwMul] with t1718
  bnd_ext t1718
  step_pure [nswMul] with t1719
  bnd_ext t1719
  step_pure [nswAdd] with t1720
  bnd_ext t1720
  step_pure [nswAdd] with t1721
  bnd_ext t1721
  step_pure [nswAdd] with t1722
  bnd_ext t1722
  step_pure [nswAdd] with t1723
  bnd_ext t1723
  step_pure [nswAdd] with s12_5
  bnd_ext s12_5
  step_pure [nswMul, nuwMul] with t1725
  bnd_ext t1725
  step_pure [nswAdd, nuwAdd] with s6_1
  bnd_ext s6_1
  exact
    hK _ s23 t1684 t1685 t1686 t1687 t1688 s15_1 t1690 s16_1 t1692 t1693 t1694 t1695 t1696 t1697
      s15_2 t1699 t1700 t1701 t1702 t1703 t1704 t1705 t1706 s14_3 t1708 t1709 t1710 t1711 t1712
      t1713 t1714 t1715 t1716 t1717 t1718 t1719 t1720 t1721 t1722 t1723 s12_5 t1725 s6_1 hArgs
      (by
        unfold sc25519_reduce.Consts; env_reads)
      (by env_reads) hs23 ht1684 ht1685 ht1686 ht1687 ht1688 hs15_1 ht1690 hs16_1 ht1692 ht1693
      ht1694 ht1695 ht1696 ht1697 hs15_2 ht1699 ht1700 ht1701 ht1702 ht1703 ht1704 ht1705 ht1706
      hs14_3 ht1708 ht1709 ht1710 ht1711 ht1712 ht1713 ht1714 ht1715 ht1716 ht1717 ht1718 ht1719
      ht1720 ht1721 ht1722 ht1723 hs12_5 ht1725 hs6_1 hbt1684 hbt1686 hbs16_1 hbt1692 hbt1693
      hbt1695 hbs15_2 hbt1699 hbt1700 hbt1701 hbt1703 hbs14_3 hbt1708 hbt1709 hbt1710 hbt1711
      hbt1713 hbt1714 hbt1715 hbt1716 hbt1717 hbt1718 hbs12_5 hbs6_1

/-- `^bb0` from instruction 160 to 205: its values named, with their forms and bounds. -/
theorem sc25519_reduce.run160 {β : Type} {p : Pointer}
    {blk : BasicBlock sc25519_reduce.Γ [] sc25519_reduce.blockTys}
    (hbody : blk.body.drop 160 = sc25519_reduce.entry.body.drop 160) {E : ⟪sc25519_reduce.Γ⟫}
    {S : GlobalState} {g : ⟪sc25519_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0 s1 s2 s3 s4 s5 s7 s8 s9 s10 s11 s13 s17 s18 t1684 t1686 s16_1 t1692 t1693 t1695 s15_2 t1699
      t1700 t1701 t1703 s14_3 t1708 t1709 t1710 t1711 t1713 t1714 t1715 t1716 t1717 t1718 s12_5
      s6_1 : BitVec 64}
    (hArgs : E.args = (sc25519_reduce.args (.value p)).get) (hc : sc25519_reduce.Consts E)
    (hR :
      E ⊨ [%1596 := s0, %1600 := s1, %1604 := s2, %1608 := s3, %1612 := s4, %1616 := s5, %1623 :=
        s7, %1626 := s8, %1630 := s9, %1634 := s10, %1638 := s11, %1646 := s13, %1660 := s17,
        %1664 := s18, %1684 := t1684, %1686 := t1686, %1691 := s16_1, %1692 := t1692, %1693 :=
        t1693, %1695 := t1695, %1698 := s15_2, %1699 := t1699, %1700 := t1700, %1701 := t1701,
        %1703 := t1703, %1707 := s14_3, %1708 := t1708, %1709 := t1709, %1710 := t1710, %1711 :=
        t1711, %1713 := t1713, %1714 := t1714, %1715 := t1715, %1716 := t1716, %1717 := t1717,
        %1718 := t1718, %1724 := s12_5, %1726 := s6_1, %1597 := p.add 2#64, %1601 := p.add 5#64,
        %1605 := p.add 7#64, %1609 := p.add 10#64, %1613 := p.add 13#64, %1617 := p.add 15#64,
        %1621 := p.add 18#64, %1624 := p.add 21#64, %1627 := p.add 23#64, %1631 := p.add 26#64,
        %1635 := p.add 28#64, %1639 := p.add 31#64])
    (hbs7 : Bnd s7 0 2097151) (hbs8 : Bnd s8 0 2097151) (hbs9 : Bnd s9 0 2097151)
    (hbs10 : Bnd s10 0 2097151) (hbs11 : Bnd s11 0 2097151) (hbs13 : Bnd s13 0 2097151)
    (hbs18 : Bnd s18 0 2097151) (hbt1684 : Bnd t1684 0 357901234721773)
    (hbt1686 : Bnd t1686 0 351211823170713) (hbt1692 : Bnd t1692 0 1398051034093)
    (hbt1693 : Bnd t1693 0 986281726696) (hbt1695 : Bnd t1695 (-2092547753555) 0)
    (hbt1699 : Bnd t1699 0 1398051034093) (hbt1700 : Bnd t1700 0 986281726696)
    (hbt1701 : Bnd t1701 0 1371920532633) (hbt1703 : Bnd t1703 0 286590364207)
    (hbt1708 : Bnd t1708 0 1398051034093) (hbt1709 : Bnd t1709 0 986281726696)
    (hbt1710 : Bnd t1710 0 1371920532633) (hbt1711 : Bnd t1711 (-2092547753555) 0)
    (hbt1713 : Bnd t1713 (-1434243666051) 0) (hbt1714 : Bnd t1714 0 1398051034093)
    (hbt1715 : Bnd t1715 0 986281726696) (hbt1716 : Bnd t1716 0 1371920532633)
    (hbt1717 : Bnd t1717 (-2092547753555) 0) (hbt1718 : Bnd t1718 0 286590364207)
    (hbs12_5 : Bnd s12_5 (-3526791419606) 254146754953647) (hbs6_1 : Bnd s6_1 0 1398053131244)
    (hK :
      ∀ (E' : ⟪sc25519_reduce.Γ⟫)
        (t1727 t1728 t1729 t1730 s8_3 t1732 t1733 t1734 t1735 t1736 t1737 s10_5 t1739 t1740 carry6
          t1742 s7_2 s7_3 t1745 s6_2 t1747 carry8 t1749 t1750 t1751 s9_4 s9_5 t1754 t1755 carry10
          t1757 t1758 t1759 t1760 t1761 s11_6 s11_7 t1764 t1765 carry12 t1767 t1768 t1769 s13_4
          s13_5 : BitVec 64),
        (hArgs : E'.args = (sc25519_reduce.args (.value p)).get) →
          (hc : sc25519_reduce.Consts E') →
          (hR :
            E' ⊨ [%1596 := s0, %1600 := s1, %1604 := s2, %1608 := s3, %1612 := s4, %1616 := s5,
              %1660 := s17, %1691 := s16_1, %1698 := s15_2, %1707 := s14_3, %1724 := s12_5, %1731 :=
              s8_3, %1738 := s10_5, %1744 := s7_3, %1746 := s6_2, %1753 := s9_5, %1754 := t1754,
              %1763 := s11_7, %1764 := t1764, %1765 := t1765, %1771 := s13_5, %1597 := p.add 2#64,
              %1601 := p.add 5#64, %1605 := p.add 7#64, %1609 := p.add 10#64, %1613 := p.add 13#64,
              %1617 := p.add 15#64, %1621 := p.add 18#64, %1624 := p.add 21#64, %1627 :=
              p.add 23#64, %1631 := p.add 26#64, %1635 := p.add 28#64, %1639 := p.add 31#64]) →
          (ht1727 : t1727 = s18 * 470296#64) →
          (ht1728 : t1728 = s18 * 654183#64) →
          (ht1729 : t1729 = t1728 + s8) →
          (ht1730 : t1730 = t1729 + t1715) →
          (hs8_3 : s8_3 = t1730 + t1708) →
          (ht1732 : t1732 = s18 * 18446744073708553811#64) →
          (ht1733 : t1733 = s18 * 136657#64) →
          (ht1734 : t1734 = t1733 + s10) →
          (ht1735 : t1735 = t1734 + t1717) →
          (ht1736 : t1736 = t1735 + t1710) →
          (ht1737 : t1737 = t1736 + t1700) →
          (hs10_5 : s10_5 = t1737 + t1692) →
          (ht1739 : t1739 = s18 * 18446744073708867715#64) →
          (ht1740 : t1740 = s6_1 + 1048576#64) →
          (hcarry6 : carry6 = t1740 >>> 21) →
          (ht1742 : t1742 = t1727 + s7) →
          (hs7_2 : s7_2 = t1742 + t1714) →
          (hs7_3 : s7_3 = s7_2 + carry6) →
          (ht1745 : t1745 = t1740 &&& 8796090925056#64) →
          (hs6_2 : s6_2 = s6_1 - t1745) →
          (ht1747 : t1747 = s8_3 + 1048576#64) →
          (hcarry8 : carry8 = t1747 >>> 21) →
          (ht1749 : t1749 = t1732 + s9) →
          (ht1750 : t1750 = t1749 + t1716) →
          (ht1751 : t1751 = t1750 + t1709) →
          (hs9_4 : s9_4 = t1751 + t1699) →
          (hs9_5 : s9_5 = s9_4 + carry8) →
          (ht1754 : t1754 = t1747 &&& 9223372036852678656#64) →
          (ht1755 : t1755 = s10_5 + 1048576#64) →
          (hcarry10 : carry10 = t1755.sshiftRight 21) →
          (ht1757 : t1757 = t1739 + s11) →
          (ht1758 : t1758 = t1757 + t1718) →
          (ht1759 : t1759 = t1758 + t1711) →
          (ht1760 : t1760 = t1759 + t1701) →
          (ht1761 : t1761 = t1760 + t1684) →
          (hs11_6 : s11_6 = t1761 + t1693) →
          (hs11_7 : s11_7 = s11_6 + carry10) →
          (ht1764 : t1764 = t1755 &&& 18446744073707454464#64) →
          (ht1765 : t1765 = s12_5 + 1048576#64) →
          (hcarry12 : carry12 = t1765.sshiftRight 21) →
          (ht1767 : t1767 = t1713 + s13) →
          (ht1768 : t1768 = t1767 + t1703) →
          (ht1769 : t1769 = t1768 + t1686) →
          (hs13_4 : s13_4 = t1769 + t1695) →
          (hs13_5 : s13_5 = s13_4 + carry12) →
          (hbs8_3 : Bnd s8_3 0 3756255390573) →
          (hbs10_5 : Bnd s10_5 (-2092547753555) 4042845754780) →
          (hbs7_3 : Bnd s7_3 0 2384335524584) →
          (hbs6_2 : Bnd s6_2 (-8796090925056) 1398053131244) →
          (hbs9_5 : Bnd s9_5 (-2092547753555) 3756257181695) →
          (hbt1754 : Bnd t1754 0 3756255084544) →
          (hbs11_7 : Bnd s11_7 (-3526792417411) 360546031370239) →
          (hbt1764 : Bnd t1764 (-2092548751360) 4042845585408) →
          (hbt1765 : Bnd t1765 (-3526790371030) 254146756002223) →
          (hbs13_5 : Bnd s13_5 (-3526793101311) 351498536818687) →
          (blk.runBodyFrom E' 205 S >>= g) = K) :
    (blk.runBodyFrom E 160 S >>= g) = K := by
  step_pure [nswMul, nuwMul] with t1727
  bnd_ext t1727
  step_pure [nswMul, nuwMul] with t1728
  bnd_ext t1728
  step_pure [nswAdd, nuwAdd] with t1729
  bnd_ext t1729
  step_pure [nswAdd, nuwAdd] with t1730
  bnd_ext t1730
  step_pure [nswAdd, nuwAdd] with s8_3
  bnd_ext s8_3
  step_pure [nswMul] with t1732
  bnd_ext t1732
  step_pure [nswMul, nuwMul] with t1733
  bnd_ext t1733
  step_pure [nswAdd, nuwAdd] with t1734
  bnd_ext t1734
  step_pure [nswAdd] with t1735
  bnd_ext t1735
  step_pure [nswAdd] with t1736
  bnd_ext t1736
  step_pure [nswAdd] with t1737
  bnd_ext t1737
  step_pure [nswAdd] with s10_5
  bnd_ext s10_5
  step_pure [nswMul] with t1739
  bnd_ext t1739
  step_pure [nswAdd, nuwAdd] with t1740
  bnd_ext t1740
  step_pure with carry6
  bnd_ext carry6
  step_pure [nswAdd, nuwAdd] with t1742
  bnd_ext t1742
  step_pure [nswAdd, nuwAdd] with s7_2
  bnd_ext s7_2
  step_pure [nswAdd, nuwAdd] with s7_3
  bnd_ext s7_3
  step_pure with t1745
  bnd_ext t1745
  step_pure [nswSub] with s6_2
  bnd_ext s6_2
  step_pure [nswAdd, nuwAdd] with t1747
  bnd_ext t1747
  step_pure with carry8
  bnd_ext carry8
  step_pure [nswAdd] with t1749
  bnd_ext t1749
  step_pure [nswAdd] with t1750
  bnd_ext t1750
  step_pure [nswAdd] with t1751
  bnd_ext t1751
  step_pure [nswAdd] with s9_4
  bnd_ext s9_4
  step_pure [nswAdd] with s9_5
  bnd_ext s9_5
  step_pure with t1754
  bnd_ext t1754
  step_pure [nswAdd] with t1755
  bnd_ext t1755
  step_pure with carry10
  bnd_ext carry10
  step_pure [nswAdd] with t1757
  bnd_ext t1757
  step_pure [nswAdd] with t1758
  bnd_ext t1758
  step_pure [nswAdd] with t1759
  bnd_ext t1759
  step_pure [nswAdd] with t1760
  bnd_ext t1760
  step_pure [nswAdd] with t1761
  bnd_ext t1761
  step_pure [nswAdd] with s11_6
  bnd_ext s11_6
  step_pure [nswAdd] with s11_7
  bnd_ext s11_7
  step_pure with t1764
  bnd_ext t1764
  step_pure [nswAdd] with t1765
  bnd_ext t1765
  step_pure with carry12
  bnd_ext carry12
  step_pure [nswAdd] with t1767
  bnd_ext t1767
  step_pure [nswAdd] with t1768
  bnd_ext t1768
  step_pure [nswAdd] with t1769
  bnd_ext t1769
  step_pure [nswAdd] with s13_4
  bnd_ext s13_4
  step_pure [nswAdd] with s13_5
  bnd_ext s13_5
  exact
    hK _ t1727 t1728 t1729 t1730 s8_3 t1732 t1733 t1734 t1735 t1736 t1737 s10_5 t1739 t1740 carry6
      t1742 s7_2 s7_3 t1745 s6_2 t1747 carry8 t1749 t1750 t1751 s9_4 s9_5 t1754 t1755 carry10 t1757
      t1758 t1759 t1760 t1761 s11_6 s11_7 t1764 t1765 carry12 t1767 t1768 t1769 s13_4 s13_5 hArgs
      (by
        unfold sc25519_reduce.Consts; env_reads)
      (by env_reads) ht1727 ht1728 ht1729 ht1730 hs8_3 ht1732 ht1733 ht1734 ht1735 ht1736 ht1737
      hs10_5 ht1739 ht1740 hcarry6 ht1742 hs7_2 hs7_3 ht1745 hs6_2 ht1747 hcarry8 ht1749 ht1750
      ht1751 hs9_4 hs9_5 ht1754 ht1755 hcarry10 ht1757 ht1758 ht1759 ht1760 ht1761 hs11_6 hs11_7
      ht1764 ht1765 hcarry12 ht1767 ht1768 ht1769 hs13_4 hs13_5 hbs8_3 hbs10_5 hbs7_3 hbs6_2 hbs9_5
      hbt1754 hbs11_7 hbt1764 hbt1765 hbs13_5

/-- `^bb0` from instruction 205 to 250: its values named, with their forms and bounds. -/
theorem sc25519_reduce.run205 {β : Type} {p : Pointer}
    {blk : BasicBlock sc25519_reduce.Γ [] sc25519_reduce.blockTys}
    (hbody : blk.body.drop 205 = sc25519_reduce.entry.body.drop 205) {E : ⟪sc25519_reduce.Γ⟫}
    {S : GlobalState} {g : ⟪sc25519_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0 s1 s2 s3 s4 s5 s17 s16_1 s15_2 s14_3 s12_5 s8_3 s10_5 s7_3 s6_2 s9_5 t1754 s11_7 t1764 t1765
      s13_5 : BitVec 64}
    (hArgs : E.args = (sc25519_reduce.args (.value p)).get) (hc : sc25519_reduce.Consts E)
    (hR :
      E ⊨ [%1596 := s0, %1600 := s1, %1604 := s2, %1608 := s3, %1612 := s4, %1616 := s5, %1660 :=
        s17, %1691 := s16_1, %1698 := s15_2, %1707 := s14_3, %1724 := s12_5, %1731 := s8_3, %1738 :=
        s10_5, %1744 := s7_3, %1746 := s6_2, %1753 := s9_5, %1754 := t1754, %1763 := s11_7, %1764 :=
        t1764, %1765 := t1765, %1771 := s13_5, %1597 := p.add 2#64, %1601 := p.add 5#64, %1605 :=
        p.add 7#64, %1609 := p.add 10#64, %1613 := p.add 13#64, %1617 := p.add 15#64, %1621 :=
        p.add 18#64, %1624 := p.add 21#64, %1627 := p.add 23#64, %1631 := p.add 26#64, %1635 :=
        p.add 28#64, %1639 := p.add 31#64])
    (hbs5 : Bnd s5 0 2097151) (hbs17 : Bnd s17 0 2097151)
    (hbs16_1 : Bnd s16_1 (-367166552903811) 2097151)
    (hbs15_2 : Bnd s15_2 (-1434243666051) 73367170181678)
    (hbs14_3 : Bnd s14_3 (-537126723016406) 286592461358)
    (hbs12_5 : Bnd s12_5 (-3526791419606) 254146754953647)
    (hbs10_5 : Bnd s10_5 (-2092547753555) 4042845754780) (hbs7_3 : Bnd s7_3 0 2384335524584)
    (hbs6_2 : Bnd s6_2 (-8796090925056) 1398053131244)
    (hbs9_5 : Bnd s9_5 (-2092547753555) 3756257181695)
    (hbs11_7 : Bnd s11_7 (-3526792417411) 360546031370239)
    (hbt1765 : Bnd t1765 (-3526790371030) 254146756002223)
    (hbs13_5 : Bnd s13_5 (-3526793101311) 351498536818687)
    (hK :
      ∀ (E' : ⟪sc25519_reduce.Γ⟫)
        (t1772 s12_6 t1774 carry14 s15_3 t1777 s14_4 t1779 carry16 s17_1 t1782 s16_2 t1784 carry7
          t1786 s7_4 t1788 carry9 t1790 t1791 carry11 s12_7 t1794 s11_8 t1796 carry13 s14_5 t1799
          s13_6 t1801 carry15 s16_3 t1804 s15_4 t1806 s5_1 t1808 s6_3 t1810 s7_5 t1812 t1813 t1814
          t1815 t1816 : BitVec 64),
        (hArgs : E'.args = (sc25519_reduce.args (.value p)).get) →
          (hc : sc25519_reduce.Consts E') →
          (hR :
            E' ⊨ [%1596 := s0, %1600 := s1, %1604 := s2, %1608 := s3, %1612 := s4, %1731 := s8_3,
              %1753 := s9_5, %1754 := t1754, %1764 := t1764, %1785 := carry7, %1790 := t1790,
              %1793 := s12_7, %1795 := s11_8, %1798 := s14_5, %1800 := s13_6, %1803 := s16_3,
              %1805 := s15_4, %1807 := s5_1, %1809 := s6_3, %1811 := s7_5, %1812 := t1812, %1813 :=
              t1813, %1816 := t1816, %1597 := p.add 2#64, %1601 := p.add 5#64, %1605 := p.add 7#64,
              %1609 := p.add 10#64, %1613 := p.add 13#64, %1617 := p.add 15#64, %1621 :=
              p.add 18#64, %1624 := p.add 21#64, %1627 := p.add 23#64, %1631 := p.add 26#64,
              %1635 := p.add 28#64, %1639 := p.add 31#64]) →
          (ht1772 : t1772 = t1765 &&& 18446744073707454464#64) →
          (hs12_6 : s12_6 = s12_5 - t1772) →
          (ht1774 : t1774 = s14_3 + 1048576#64) →
          (hcarry14 : carry14 = t1774.sshiftRight 21) →
          (hs15_3 : s15_3 = s15_2 + carry14) →
          (ht1777 : t1777 = t1774 &&& 18446744073707454464#64) →
          (hs14_4 : s14_4 = s14_3 - t1777) →
          (ht1779 : t1779 = s16_1 + 1048576#64) →
          (hcarry16 : carry16 = t1779.sshiftRight 21) →
          (hs17_1 : s17_1 = carry16 + s17) →
          (ht1782 : t1782 = t1779 &&& 18446744073707454464#64) →
          (hs16_2 : s16_2 = s16_1 - t1782) →
          (ht1784 : t1784 = s7_3 + 1048576#64) →
          (hcarry7 : carry7 = t1784 >>> 21) →
          (ht1786 : t1786 = t1784 &&& 9223372036852678656#64) →
          (hs7_4 : s7_4 = s7_3 - t1786) →
          (ht1788 : t1788 = s9_5 + 1048576#64) →
          (hcarry9 : carry9 = t1788.sshiftRight 21) →
          (ht1790 : t1790 = t1788 &&& 18446744073707454464#64) →
          (ht1791 : t1791 = s11_7 + 1048576#64) →
          (hcarry11 : carry11 = t1791.sshiftRight 21) →
          (hs12_7 : s12_7 = carry11 + s12_6) →
          (ht1794 : t1794 = t1791 &&& 18446744073707454464#64) →
          (hs11_8 : s11_8 = s11_7 - t1794) →
          (ht1796 : t1796 = s13_5 + 1048576#64) →
          (hcarry13 : carry13 = t1796.sshiftRight 21) →
          (hs14_5 : s14_5 = carry13 + s14_4) →
          (ht1799 : t1799 = t1796 &&& 18446744073707454464#64) →
          (hs13_6 : s13_6 = s13_5 - t1799) →
          (ht1801 : t1801 = s15_3 + 1048576#64) →
          (hcarry15 : carry15 = t1801.sshiftRight 21) →
          (hs16_3 : s16_3 = carry15 + s16_2) →
          (ht1804 : t1804 = t1801 &&& 18446744073707454464#64) →
          (hs15_4 : s15_4 = s15_3 - t1804) →
          (ht1806 : t1806 = s17_1 * 666643#64) →
          (hs5_1 : s5_1 = t1806 + s5) →
          (ht1808 : t1808 = s17_1 * 470296#64) →
          (hs6_3 : s6_3 = s6_2 + t1808) →
          (ht1810 : t1810 = s17_1 * 654183#64) →
          (hs7_5 : s7_5 = s7_4 + t1810) →
          (ht1812 : t1812 = s17_1 * 18446744073708553811#64) →
          (ht1813 : t1813 = s17_1 * 136657#64) →
          (ht1814 : t1814 = s17_1 * 18446744073708867715#64) →
          (ht1815 : t1815 = t1814 + s10_5) →
          (ht1816 : t1816 = t1815 + carry9) →
          (hbcarry7 : Bnd carry7 0 1136940) →
          (hbs11_8 : Bnd s11_8 (-364072823787651) 364072824471551) →
          (hbt1812 : Bnd t1812 (-2092548751360) 174694358350080) →
          (hbt1813 : Bnd t1813 (-23925723892992) 286590500864) →
          (hbt1816 : Bnd t1816 (-3526793101312) 123779315462959) →
          (blk.runBodyFrom E' 250 S >>= g) = K) :
    (blk.runBodyFrom E 205 S >>= g) = K := by
  step_pure with t1772
  bnd_ext t1772
  step_pure [nswSub] with s12_6
  bnd_ext s12_6
  step_pure [nswAdd] with t1774
  bnd_ext t1774
  step_pure with carry14
  bnd_ext carry14
  step_pure [nswAdd] with s15_3
  bnd_ext s15_3
  step_pure with t1777
  bnd_ext t1777
  step_pure [nswSub] with s14_4
  bnd_ext s14_4
  step_pure [nswAdd] with t1779
  bnd_ext t1779
  step_pure with carry16
  bnd_ext carry16
  step_pure [nswAdd] with s17_1
  bnd_ext s17_1
  step_pure with t1782
  bnd_ext t1782
  step_pure [nswSub] with s16_2
  bnd_ext s16_2
  step_pure [nswAdd, nuwAdd] with t1784
  bnd_ext t1784
  step_pure with carry7
  bnd_ext carry7
  step_pure with t1786
  bnd_ext t1786
  step_pure [nswSub] with s7_4
  bnd_ext s7_4
  step_pure [nswAdd] with t1788
  bnd_ext t1788
  step_pure with carry9
  bnd_ext carry9
  step_pure with t1790
  step_pure [nswAdd] with t1791
  bnd_ext t1791
  step_pure with carry11
  bnd_ext carry11
  step_pure [nswAdd] with s12_7
  step_pure with t1794
  bnd_ext t1794
  step_pure [nswSub] with s11_8
  bnd_ext s11_8
  step_pure [nswAdd] with t1796
  bnd_ext t1796
  step_pure with carry13
  bnd_ext carry13
  step_pure [nswAdd] with s14_5
  step_pure with t1799
  bnd_ext t1799
  step_pure [nswSub] with s13_6
  step_pure [nswAdd] with t1801
  bnd_ext t1801
  step_pure with carry15
  bnd_ext carry15
  step_pure [nswAdd] with s16_3
  step_pure with t1804
  bnd_ext t1804
  step_pure [nswSub] with s15_4
  step_pure [nswMul] with t1806
  bnd_ext t1806
  step_pure [nswAdd] with s5_1
  step_pure [nswMul] with t1808
  bnd_ext t1808
  step_pure [nswAdd] with s6_3
  step_pure [nswMul] with t1810
  bnd_ext t1810
  step_pure [nswAdd] with s7_5
  step_pure [nswMul] with t1812
  bnd_ext t1812
  step_pure [nswMul] with t1813
  bnd_ext t1813
  step_pure [nswMul] with t1814
  bnd_ext t1814
  step_pure [nswAdd] with t1815
  bnd_ext t1815
  step_pure [nswAdd] with t1816
  bnd_ext t1816
  exact
    hK _ t1772 s12_6 t1774 carry14 s15_3 t1777 s14_4 t1779 carry16 s17_1 t1782 s16_2 t1784 carry7
      t1786 s7_4 t1788 carry9 t1790 t1791 carry11 s12_7 t1794 s11_8 t1796 carry13 s14_5 t1799 s13_6
      t1801 carry15 s16_3 t1804 s15_4 t1806 s5_1 t1808 s6_3 t1810 s7_5 t1812 t1813 t1814 t1815 t1816
      hArgs
      (by
        unfold sc25519_reduce.Consts; env_reads)
      (by env_reads) ht1772 hs12_6 ht1774 hcarry14 hs15_3 ht1777 hs14_4 ht1779 hcarry16 hs17_1
      ht1782 hs16_2 ht1784 hcarry7 ht1786 hs7_4 ht1788 hcarry9 ht1790 ht1791 hcarry11 hs12_7 ht1794
      hs11_8 ht1796 hcarry13 hs14_5 ht1799 hs13_6 ht1801 hcarry15 hs16_3 ht1804 hs15_4 ht1806 hs5_1
      ht1808 hs6_3 ht1810 hs7_5 ht1812 ht1813 ht1814 ht1815 ht1816 hbcarry7 hbs11_8 hbt1812 hbt1813
      hbt1816

/-- `^bb0` from instruction 250 to 295: its values named, with their forms and bounds. -/
theorem sc25519_reduce.run250 {β : Type} {p : Pointer}
    {blk : BasicBlock sc25519_reduce.Γ [] sc25519_reduce.blockTys}
    (hbody : blk.body.drop 250 = sc25519_reduce.entry.body.drop 250) {E : ⟪sc25519_reduce.Γ⟫}
    {S : GlobalState} {g : ⟪sc25519_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0 s1 s2 s3 s4 s8_3 s9_5 t1754 t1764 carry7 t1790 s12_7 s11_8 s14_5 s13_6 s16_3 s15_4 s5_1 s6_3
      s7_5 t1812 t1813 t1816 : BitVec 64}
    (hArgs : E.args = (sc25519_reduce.args (.value p)).get) (hc : sc25519_reduce.Consts E)
    (hR :
      E ⊨ [%1596 := s0, %1600 := s1, %1604 := s2, %1608 := s3, %1612 := s4, %1731 := s8_3, %1753 :=
        s9_5, %1754 := t1754, %1764 := t1764, %1785 := carry7, %1790 := t1790, %1793 := s12_7,
        %1795 := s11_8, %1798 := s14_5, %1800 := s13_6, %1803 := s16_3, %1805 := s15_4, %1807 :=
        s5_1, %1809 := s6_3, %1811 := s7_5, %1812 := t1812, %1813 := t1813, %1816 := t1816, %1597 :=
        p.add 2#64, %1601 := p.add 5#64, %1605 := p.add 7#64, %1609 := p.add 10#64, %1613 :=
        p.add 13#64, %1617 := p.add 15#64, %1621 := p.add 18#64, %1624 := p.add 21#64, %1627 :=
        p.add 23#64, %1631 := p.add 26#64, %1635 := p.add 28#64, %1639 := p.add 31#64])
    (hbs8_3 : Bnd s8_3 0 3756255390573) (hbt1754 : Bnd t1754 0 3756255084544)
    (hbt1764 : Bnd t1764 (-2092548751360) 4042845585408) (hbcarry7 : Bnd carry7 0 1136940)
    (hbt1812 : Bnd t1812 (-2092548751360) 174694358350080)
    (hbt1816 : Bnd t1816 (-3526793101312) 123779315462959)
    (hK :
      ∀ (E' : ⟪sc25519_reduce.Γ⟫)
        (s10_8 t1818 s4_1 t1820 s5_2 t1822 s6_4 t1824 s7_6 t1826 t1827 t1828 s3_1 t1830 s4_2 t1832
          s5_3 t1834 s6_5 t1836 s7_7 t1838 t1839 s8_5 s8_6 s8_7 s8_8 t1844 s2_1 t1846 s3_2 t1848
          s4_3 t1850 s5_4 t1852 s6_6 t1854 s7_8 t1856 s1_1 t1858 s2_2 t1860 s3_3 : BitVec 64),
        (hArgs : E'.args = (sc25519_reduce.args (.value p)).get) →
          (hc : sc25519_reduce.Consts E') →
          (hR :
            E' ⊨ [%1596 := s0, %1753 := s9_5, %1790 := t1790, %1793 := s12_7, %1795 := s11_8,
              %1800 := s13_6, %1813 := t1813, %1817 := s10_8, %1827 := t1827, %1843 := s8_8,
              %1849 := s4_3, %1851 := s5_4, %1853 := s6_6, %1855 := s7_8, %1857 := s1_1, %1859 :=
              s2_2, %1861 := s3_3, %1597 := p.add 2#64, %1601 := p.add 5#64, %1605 := p.add 7#64,
              %1609 := p.add 10#64, %1613 := p.add 13#64, %1617 := p.add 15#64, %1621 :=
              p.add 18#64, %1624 := p.add 21#64, %1627 := p.add 23#64, %1631 := p.add 26#64,
              %1635 := p.add 28#64, %1639 := p.add 31#64]) →
          (hs10_8 : s10_8 = t1816 - t1764) →
          (ht1818 : t1818 = s16_3 * 666643#64) →
          (hs4_1 : s4_1 = t1818 + s4) →
          (ht1820 : t1820 = s16_3 * 470296#64) →
          (hs5_2 : s5_2 = s5_1 + t1820) →
          (ht1822 : t1822 = s16_3 * 654183#64) →
          (hs6_4 : s6_4 = s6_3 + t1822) →
          (ht1824 : t1824 = s16_3 * 18446744073708553811#64) →
          (hs7_6 : s7_6 = s7_5 + t1824) →
          (ht1826 : t1826 = s16_3 * 136657#64) →
          (ht1827 : t1827 = s16_3 * 18446744073708867715#64) →
          (ht1828 : t1828 = s15_4 * 666643#64) →
          (hs3_1 : s3_1 = t1828 + s3) →
          (ht1830 : t1830 = s15_4 * 470296#64) →
          (hs4_2 : s4_2 = s4_1 + t1830) →
          (ht1832 : t1832 = s15_4 * 654183#64) →
          (hs5_3 : s5_3 = s5_2 + t1832) →
          (ht1834 : t1834 = s15_4 * 18446744073708553811#64) →
          (hs6_5 : s6_5 = s6_4 + t1834) →
          (ht1836 : t1836 = s15_4 * 136657#64) →
          (hs7_7 : s7_7 = s7_6 + t1836) →
          (ht1838 : t1838 = s15_4 * 18446744073708867715#64) →
          (ht1839 : t1839 = carry7 + s8_3) →
          (hs8_5 : s8_5 = t1839 - t1754) →
          (hs8_6 : s8_6 = s8_5 + t1812) →
          (hs8_7 : s8_7 = s8_6 + t1826) →
          (hs8_8 : s8_8 = s8_7 + t1838) →
          (ht1844 : t1844 = s14_5 * 666643#64) →
          (hs2_1 : s2_1 = t1844 + s2) →
          (ht1846 : t1846 = s14_5 * 470296#64) →
          (hs3_2 : s3_2 = s3_1 + t1846) →
          (ht1848 : t1848 = s14_5 * 654183#64) →
          (hs4_3 : s4_3 = s4_2 + t1848) →
          (ht1850 : t1850 = s14_5 * 18446744073708553811#64) →
          (hs5_4 : s5_4 = s5_3 + t1850) →
          (ht1852 : t1852 = s14_5 * 136657#64) →
          (hs6_6 : s6_6 = s6_5 + t1852) →
          (ht1854 : t1854 = s14_5 * 18446744073708867715#64) →
          (hs7_8 : s7_8 = s7_7 + t1854) →
          (ht1856 : t1856 = s13_6 * 666643#64) →
          (hs1_1 : s1_1 = t1856 + s1) →
          (ht1858 : t1858 = s13_6 * 470296#64) →
          (hs2_2 : s2_2 = s2_1 + t1858) →
          (ht1860 : t1860 = s13_6 * 654183#64) →
          (hs3_3 : s3_3 = s3_2 + t1860) →
          (hbs10_8 : Bnd s10_8 (-7569638686720) 125871864214319) →
          (blk.runBodyFrom E' 295 S >>= g) = K) :
    (blk.runBodyFrom E 250 S >>= g) = K := by
  step_pure with s10_8
  bnd_ext s10_8
  step_pure with t1818
  step_pure with s4_1
  step_pure with t1820
  step_pure with s5_2
  step_pure with t1822
  step_pure with s6_4
  step_pure with t1824
  step_pure with s7_6
  step_pure with t1826
  step_pure with t1827
  step_pure with t1828
  step_pure with s3_1
  step_pure with t1830
  step_pure with s4_2
  step_pure with t1832
  step_pure with s5_3
  step_pure with t1834
  step_pure with s6_5
  step_pure with t1836
  step_pure with s7_7
  step_pure with t1838
  step_pure [nswAdd, nuwAdd] with t1839
  bnd_ext t1839
  step_pure [nswSub] with s8_5
  bnd_ext s8_5
  step_pure [nswAdd] with s8_6
  step_pure with s8_7
  step_pure with s8_8
  step_pure with t1844
  step_pure with s2_1
  step_pure with t1846
  step_pure with s3_2
  step_pure with t1848
  step_pure with s4_3
  step_pure with t1850
  step_pure with s5_4
  step_pure with t1852
  step_pure with s6_6
  step_pure with t1854
  step_pure with s7_8
  step_pure with t1856
  step_pure with s1_1
  step_pure with t1858
  step_pure with s2_2
  step_pure with t1860
  step_pure with s3_3
  exact
    hK _ s10_8 t1818 s4_1 t1820 s5_2 t1822 s6_4 t1824 s7_6 t1826 t1827 t1828 s3_1 t1830 s4_2 t1832
      s5_3 t1834 s6_5 t1836 s7_7 t1838 t1839 s8_5 s8_6 s8_7 s8_8 t1844 s2_1 t1846 s3_2 t1848 s4_3
      t1850 s5_4 t1852 s6_6 t1854 s7_8 t1856 s1_1 t1858 s2_2 t1860 s3_3 hArgs
      (by
        unfold sc25519_reduce.Consts; env_reads)
      (by env_reads) hs10_8 ht1818 hs4_1 ht1820 hs5_2 ht1822 hs6_4 ht1824 hs7_6 ht1826 ht1827 ht1828
      hs3_1 ht1830 hs4_2 ht1832 hs5_3 ht1834 hs6_5 ht1836 hs7_7 ht1838 ht1839 hs8_5 hs8_6 hs8_7
      hs8_8 ht1844 hs2_1 ht1846 hs3_2 ht1848 hs4_3 ht1850 hs5_4 ht1852 hs6_6 ht1854 hs7_8 ht1856
      hs1_1 ht1858 hs2_2 ht1860 hs3_3 hbs10_8

/-- `^bb0` from instruction 295 to 340: its values named, with their forms and bounds. -/
theorem sc25519_reduce.run295 {β : Type} {p : Pointer}
    {blk : BasicBlock sc25519_reduce.Γ [] sc25519_reduce.blockTys}
    (hbody : blk.body.drop 295 = sc25519_reduce.entry.body.drop 295) {E : ⟪sc25519_reduce.Γ⟫}
    {S : GlobalState} {g : ⟪sc25519_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0 s9_5 t1790 s12_7 s11_8 s13_6 t1813 s10_8 t1827 s8_8 s4_3 s5_4 s6_6 s7_8 s1_1 s2_2 s3_3 :
      BitVec 64}
    (hArgs : E.args = (sc25519_reduce.args (.value p)).get) (hc : sc25519_reduce.Consts E)
    (hR :
      E ⊨ [%1596 := s0, %1753 := s9_5, %1790 := t1790, %1793 := s12_7, %1795 := s11_8, %1800 :=
        s13_6, %1813 := t1813, %1817 := s10_8, %1827 := t1827, %1843 := s8_8, %1849 := s4_3,
        %1851 := s5_4, %1853 := s6_6, %1855 := s7_8, %1857 := s1_1, %1859 := s2_2, %1861 := s3_3,
        %1597 := p.add 2#64, %1601 := p.add 5#64, %1605 := p.add 7#64, %1609 := p.add 10#64,
        %1613 := p.add 13#64, %1617 := p.add 15#64, %1621 := p.add 18#64, %1624 := p.add 21#64,
        %1627 := p.add 23#64, %1631 := p.add 26#64, %1635 := p.add 28#64, %1639 := p.add 31#64])
    (hbs9_5 : Bnd s9_5 (-2092547753555) 3756257181695)
    (hbt1813 : Bnd t1813 (-23925723892992) 286590500864)
    (hbs10_8 : Bnd s10_8 (-7569638686720) 125871864214319)
    (hK :
      ∀ (E' : ⟪sc25519_reduce.Γ⟫)
        (t1862 s4_4 t1864 s5_5 t1866 s6_7 t1868 s0_1 t1870 s1_2 t1872 s2_3 t1874 s3_4 t1876 s4_5
          t1878 s5_6 t1880 carry0 s1_3 t1883 s0_2 t1885 carry2 s3_5 t1888 t1889 carry4 s5_7 t1892
          t1893 carry6_1 s7_9 t1896 s6_8 t1898 carry8_1 t1900 s9_7 s9_8 s9_9 t1904 s8_9 t1906 :
          BitVec 64),
        (hArgs : E'.args = (sc25519_reduce.args (.value p)).get) →
          (hc : sc25519_reduce.Consts E') →
          (hR :
            E' ⊨ [%1795 := s11_8, %1817 := s10_8, %1873 := s2_3, %1877 := s4_5, %1882 := s1_3,
              %1884 := s0_2, %1887 := s3_5, %1888 := t1888, %1891 := s5_7, %1892 := t1892, %1895 :=
              s7_9, %1897 := s6_8, %1903 := s9_9, %1905 := s8_9, %1906 := t1906, %1597 :=
              p.add 2#64, %1601 := p.add 5#64, %1605 := p.add 7#64, %1609 := p.add 10#64, %1613 :=
              p.add 13#64, %1617 := p.add 15#64, %1621 := p.add 18#64, %1624 := p.add 21#64,
              %1627 := p.add 23#64, %1631 := p.add 26#64, %1635 := p.add 28#64, %1639 :=
              p.add 31#64]) →
          (ht1862 : t1862 = s13_6 * 18446744073708553811#64) →
          (hs4_4 : s4_4 = s4_3 + t1862) →
          (ht1864 : t1864 = s13_6 * 136657#64) →
          (hs5_5 : s5_5 = s5_4 + t1864) →
          (ht1866 : t1866 = s13_6 * 18446744073708867715#64) →
          (hs6_7 : s6_7 = s6_6 + t1866) →
          (ht1868 : t1868 = s12_7 * 666643#64) →
          (hs0_1 : s0_1 = t1868 + s0) →
          (ht1870 : t1870 = s12_7 * 470296#64) →
          (hs1_2 : s1_2 = s1_1 + t1870) →
          (ht1872 : t1872 = s12_7 * 654183#64) →
          (hs2_3 : s2_3 = s2_2 + t1872) →
          (ht1874 : t1874 = s12_7 * 18446744073708553811#64) →
          (hs3_4 : s3_4 = s3_3 + t1874) →
          (ht1876 : t1876 = s12_7 * 136657#64) →
          (hs4_5 : s4_5 = s4_4 + t1876) →
          (ht1878 : t1878 = s12_7 * 18446744073708867715#64) →
          (hs5_6 : s5_6 = s5_5 + t1878) →
          (ht1880 : t1880 = s0_1 + 1048576#64) →
          (hcarry0 : carry0 = t1880.sshiftRight 21) →
          (hs1_3 : s1_3 = s1_2 + carry0) →
          (ht1883 : t1883 = t1880 &&& 18446744073707454464#64) →
          (hs0_2 : s0_2 = s0_1 - t1883) →
          (ht1885 : t1885 = s2_3 + 1048576#64) →
          (hcarry2 : carry2 = t1885.sshiftRight 21) →
          (hs3_5 : s3_5 = s3_4 + carry2) →
          (ht1888 : t1888 = t1885 &&& 18446744073707454464#64) →
          (ht1889 : t1889 = s4_5 + 1048576#64) →
          (hcarry4 : carry4 = t1889.sshiftRight 21) →
          (hs5_7 : s5_7 = s5_6 + carry4) →
          (ht1892 : t1892 = t1889 &&& 18446744073707454464#64) →
          (ht1893 : t1893 = s6_7 + 1048576#64) →
          (hcarry6_1 : carry6_1 = t1893.sshiftRight 21) →
          (hs7_9 : s7_9 = s7_8 + carry6_1) →
          (ht1896 : t1896 = t1893 &&& 18446744073707454464#64) →
          (hs6_8 : s6_8 = s6_7 - t1896) →
          (ht1898 : t1898 = s8_8 + 1048576#64) →
          (hcarry8_1 : carry8_1 = t1898.sshiftRight 21) →
          (ht1900 : t1900 = t1813 + s9_5) →
          (hs9_7 : s9_7 = t1900 - t1790) →
          (hs9_8 : s9_8 = s9_7 + t1827) →
          (hs9_9 : s9_9 = s9_8 + carry8_1) →
          (ht1904 : t1904 = t1898 &&& 18446744073707454464#64) →
          (hs8_9 : s8_9 = s8_8 - t1904) →
          (ht1906 : t1906 = s10_8 + 1048576#64) →
          (hbt1906 : Bnd t1906 (-7569637638144) 125871865262895) →
          (blk.runBodyFrom E' 340 S >>= g) = K) :
    (blk.runBodyFrom E 295 S >>= g) = K := by
  step_pure with t1862
  step_pure with s4_4
  step_pure with t1864
  step_pure with s5_5
  step_pure with t1866
  step_pure with s6_7
  step_pure with t1868
  step_pure with s0_1
  step_pure with t1870
  step_pure with s1_2
  step_pure with t1872
  step_pure with s2_3
  step_pure with t1874
  step_pure with s3_4
  step_pure with t1876
  step_pure with s4_5
  step_pure with t1878
  step_pure with s5_6
  step_pure with t1880
  step_pure with carry0
  step_pure with s1_3
  step_pure with t1883
  step_pure with s0_2
  step_pure with t1885
  step_pure with carry2
  step_pure with s3_5
  step_pure with t1888
  step_pure with t1889
  step_pure with carry4
  step_pure with s5_7
  step_pure with t1892
  step_pure with t1893
  step_pure with carry6_1
  step_pure with s7_9
  step_pure with t1896
  step_pure with s6_8
  step_pure with t1898
  step_pure with carry8_1
  step_pure [nswAdd] with t1900
  step_pure with s9_7
  step_pure with s9_8
  step_pure with s9_9
  step_pure with t1904
  step_pure with s8_9
  step_pure [nswAdd] with t1906
  bnd_ext t1906
  exact
    hK _ t1862 s4_4 t1864 s5_5 t1866 s6_7 t1868 s0_1 t1870 s1_2 t1872 s2_3 t1874 s3_4 t1876 s4_5
      t1878 s5_6 t1880 carry0 s1_3 t1883 s0_2 t1885 carry2 s3_5 t1888 t1889 carry4 s5_7 t1892 t1893
      carry6_1 s7_9 t1896 s6_8 t1898 carry8_1 t1900 s9_7 s9_8 s9_9 t1904 s8_9 t1906 hArgs
      (by
        unfold sc25519_reduce.Consts; env_reads)
      (by env_reads) ht1862 hs4_4 ht1864 hs5_5 ht1866 hs6_7 ht1868 hs0_1 ht1870 hs1_2 ht1872 hs2_3
      ht1874 hs3_4 ht1876 hs4_5 ht1878 hs5_6 ht1880 hcarry0 hs1_3 ht1883 hs0_2 ht1885 hcarry2 hs3_5
      ht1888 ht1889 hcarry4 hs5_7 ht1892 ht1893 hcarry6_1 hs7_9 ht1896 hs6_8 ht1898 hcarry8_1 ht1900
      hs9_7 hs9_8 hs9_9 ht1904 hs8_9 ht1906 hbt1906

/-- `^bb0` from instruction 340 to 385: its values named, with their forms and bounds. -/
theorem sc25519_reduce.run340 {β : Type} {p : Pointer}
    {blk : BasicBlock sc25519_reduce.Γ [] sc25519_reduce.blockTys}
    (hbody : blk.body.drop 340 = sc25519_reduce.entry.body.drop 340) {E : ⟪sc25519_reduce.Γ⟫}
    {S : GlobalState} {g : ⟪sc25519_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s11_8 s10_8 s2_3 s4_5 s1_3 s0_2 s3_5 t1888 s5_7 t1892 s7_9 s6_8 s9_9 s8_9 t1906 : BitVec 64}
    (hArgs : E.args = (sc25519_reduce.args (.value p)).get) (hc : sc25519_reduce.Consts E)
    (hR :
      E ⊨ [%1795 := s11_8, %1817 := s10_8, %1873 := s2_3, %1877 := s4_5, %1882 := s1_3, %1884 :=
        s0_2, %1887 := s3_5, %1888 := t1888, %1891 := s5_7, %1892 := t1892, %1895 := s7_9, %1897 :=
        s6_8, %1903 := s9_9, %1905 := s8_9, %1906 := t1906, %1597 := p.add 2#64, %1601 :=
        p.add 5#64, %1605 := p.add 7#64, %1609 := p.add 10#64, %1613 := p.add 13#64, %1617 :=
        p.add 15#64, %1621 := p.add 18#64, %1624 := p.add 21#64, %1627 := p.add 23#64, %1631 :=
        p.add 26#64, %1635 := p.add 28#64, %1639 := p.add 31#64])
    (hbs11_8 : Bnd s11_8 (-364072823787651) 364072824471551)
    (hbs10_8 : Bnd s10_8 (-7569638686720) 125871864214319)
    (hbt1906 : Bnd t1906 (-7569637638144) 125871865262895)
    (hK :
      ∀ (E' : ⟪sc25519_reduce.Γ⟫)
        (carry10_1 s11_9 t1909 s10_9 t1911 carry1 t1913 t1914 carry3 t1916 t1917 carry5 s6_9 t1920
          t1921 carry7_1 s8_10 t1924 s7_10 t1926 carry9_1 s10_10 t1929 s9_10 t1931 carry11_1 t1933
          s11_10 t1935 s0_3 t1937 t1938 t1939 t1940 t1941 carry0_1 t1943 s1_5 s1_6 s0_4 carry1_1
          t1948 t1949 s2_6 s2_7 : BitVec 64),
        (hArgs : E'.args = (sc25519_reduce.args (.value p)).get) →
          (hc : sc25519_reduce.Consts E') →
          (hR :
            E' ⊨ [%1877 := s4_5, %1887 := s3_5, %1891 := s5_7, %1892 := t1892, %1915 := carry3,
              %1916 := t1916, %1919 := s6_9, %1920 := t1920, %1923 := s8_10, %1925 := s7_10,
              %1928 := s10_10, %1930 := s9_10, %1934 := s11_10, %1939 := t1939, %1940 := t1940,
              %1941 := t1941, %1945 := s1_6, %1946 := s0_4, %1951 := s2_7, %1597 := p.add 2#64,
              %1601 := p.add 5#64, %1605 := p.add 7#64, %1609 := p.add 10#64, %1613 := p.add 13#64,
              %1617 := p.add 15#64, %1621 := p.add 18#64, %1624 := p.add 21#64, %1627 :=
              p.add 23#64, %1631 := p.add 26#64, %1635 := p.add 28#64, %1639 := p.add 31#64]) →
          (hcarry10_1 : carry10_1 = t1906.sshiftRight 21) →
          (hs11_9 : s11_9 = carry10_1 + s11_8) →
          (ht1909 : t1909 = t1906 &&& 18446744073707454464#64) →
          (hs10_9 : s10_9 = s10_8 - t1909) →
          (ht1911 : t1911 = s1_3 + 1048576#64) →
          (hcarry1 : carry1 = t1911.sshiftRight 21) →
          (ht1913 : t1913 = t1911 &&& 18446744073707454464#64) →
          (ht1914 : t1914 = s3_5 + 1048576#64) →
          (hcarry3 : carry3 = t1914.sshiftRight 21) →
          (ht1916 : t1916 = t1914 &&& 18446744073707454464#64) →
          (ht1917 : t1917 = s5_7 + 1048576#64) →
          (hcarry5 : carry5 = t1917.sshiftRight 21) →
          (hs6_9 : s6_9 = s6_8 + carry5) →
          (ht1920 : t1920 = t1917 &&& 18446744073707454464#64) →
          (ht1921 : t1921 = s7_9 + 1048576#64) →
          (hcarry7_1 : carry7_1 = t1921.sshiftRight 21) →
          (hs8_10 : s8_10 = s8_9 + carry7_1) →
          (ht1924 : t1924 = t1921 &&& 18446744073707454464#64) →
          (hs7_10 : s7_10 = s7_9 - t1924) →
          (ht1926 : t1926 = s9_9 + 1048576#64) →
          (hcarry9_1 : carry9_1 = t1926.sshiftRight 21) →
          (hs10_10 : s10_10 = s10_9 + carry9_1) →
          (ht1929 : t1929 = t1926 &&& 18446744073707454464#64) →
          (hs9_10 : s9_10 = s9_9 - t1929) →
          (ht1931 : t1931 = s11_9 + 1048576#64) →
          (hcarry11_1 : carry11_1 = t1931.sshiftRight 21) →
          (ht1933 : t1933 = t1931 &&& 18446744073707454464#64) →
          (hs11_10 : s11_10 = s11_9 - t1933) →
          (ht1935 : t1935 = carry11_1 * 666643#64) →
          (hs0_3 : s0_3 = s0_2 + t1935) →
          (ht1937 : t1937 = carry11_1 * 470296#64) →
          (ht1938 : t1938 = carry11_1 * 654183#64) →
          (ht1939 : t1939 = carry11_1 * 18446744073708553811#64) →
          (ht1940 : t1940 = carry11_1 * 136657#64) →
          (ht1941 : t1941 = carry11_1 * 18446744073708867715#64) →
          (hcarry0_1 : carry0_1 = s0_3.sshiftRight 21) →
          (ht1943 : t1943 = t1937 + s1_3) →
          (hs1_5 : s1_5 = t1943 - t1913) →
          (hs1_6 : s1_6 = s1_5 + carry0_1) →
          (hs0_4 : s0_4 = s0_3 &&& 2097151#64) →
          (hcarry1_1 : carry1_1 = s1_6.sshiftRight 21) →
          (ht1948 : t1948 = t1938 + s2_3) →
          (ht1949 : t1949 = t1948 - t1888) →
          (hs2_6 : s2_6 = t1949 + carry1) →
          (hs2_7 : s2_7 = s2_6 + carry1_1) →
          (hbs10_10 : Bnd s10_10 (-137839549349888) 137839549412142) →
          (hbs11_10 : Bnd s11_10 (-728145712686096) 728145711060637) →
          (hbs0_4 : Bnd s0_4 0 2097151) → (blk.runBodyFrom E' 385 S >>= g) = K) :
    (blk.runBodyFrom E 340 S >>= g) = K := by
  step_pure with carry10_1
  bnd_ext carry10_1
  step_pure [nswAdd] with s11_9
  bnd_ext s11_9
  step_pure with t1909
  bnd_ext t1909
  step_pure with s10_9
  bnd_ext s10_9
  step_pure with t1911
  step_pure with carry1
  step_pure with t1913
  step_pure with t1914
  step_pure with carry3
  step_pure with t1916
  step_pure with t1917
  step_pure with carry5
  step_pure with s6_9
  step_pure with t1920
  step_pure with t1921
  step_pure with carry7_1
  step_pure with s8_10
  step_pure with t1924
  step_pure with s7_10
  step_pure with t1926
  bnd_ext t1926
  step_pure with carry9_1
  bnd_ext carry9_1
  step_pure [nswAdd] with s10_10
  bnd_ext s10_10
  step_pure with t1929
  step_pure with s9_10
  step_pure [nswAdd] with t1931
  bnd_ext t1931
  step_pure with carry11_1
  bnd_ext carry11_1
  step_pure with t1933
  bnd_ext t1933
  step_pure [nswSub] with s11_10
  bnd_ext s11_10
  step_pure [nswMul] with t1935
  step_pure with s0_3
  step_pure [nswMul] with t1937
  step_pure [nswMul] with t1938
  step_pure [nswMul] with t1939
  step_pure [nswMul] with t1940
  step_pure [nswMul] with t1941
  step_pure with carry0_1
  step_pure with t1943
  step_pure with s1_5
  step_pure with s1_6
  step_pure with s0_4
  bnd_ext s0_4
  step_pure with carry1_1
  step_pure with t1948
  step_pure with t1949
  step_pure with s2_6
  step_pure with s2_7
  exact
    hK _ carry10_1 s11_9 t1909 s10_9 t1911 carry1 t1913 t1914 carry3 t1916 t1917 carry5 s6_9 t1920
      t1921 carry7_1 s8_10 t1924 s7_10 t1926 carry9_1 s10_10 t1929 s9_10 t1931 carry11_1 t1933
      s11_10 t1935 s0_3 t1937 t1938 t1939 t1940 t1941 carry0_1 t1943 s1_5 s1_6 s0_4 carry1_1 t1948
      t1949 s2_6 s2_7 hArgs
      (by
        unfold sc25519_reduce.Consts; env_reads)
      (by env_reads) hcarry10_1 hs11_9 ht1909 hs10_9 ht1911 hcarry1 ht1913 ht1914 hcarry3 ht1916
      ht1917 hcarry5 hs6_9 ht1920 ht1921 hcarry7_1 hs8_10 ht1924 hs7_10 ht1926 hcarry9_1 hs10_10
      ht1929 hs9_10 ht1931 hcarry11_1 ht1933 hs11_10 ht1935 hs0_3 ht1937 ht1938 ht1939 ht1940 ht1941
      hcarry0_1 ht1943 hs1_5 hs1_6 hs0_4 hcarry1_1 ht1948 ht1949 hs2_6 hs2_7 hbs10_10 hbs11_10
      hbs0_4

/-- `^bb0` from instruction 385 to 425: its values named, with their forms and bounds. -/
theorem sc25519_reduce.run385 {β : Type} {p : Pointer}
    {blk : BasicBlock sc25519_reduce.Γ [] sc25519_reduce.blockTys}
    (hbody : blk.body.drop 385 = sc25519_reduce.entry.body.drop 385) {E : ⟪sc25519_reduce.Γ⟫}
    {S : GlobalState} {g : ⟪sc25519_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s4_5 s3_5 s5_7 t1892 carry3 t1916 s6_9 t1920 s8_10 s7_10 s10_10 s9_10 s11_10 t1939 t1940 t1941
      s1_6 s0_4 s2_7 : BitVec 64}
    (hArgs : E.args = (sc25519_reduce.args (.value p)).get) (hc : sc25519_reduce.Consts E)
    (hR :
      E ⊨ [%1877 := s4_5, %1887 := s3_5, %1891 := s5_7, %1892 := t1892, %1915 := carry3, %1916 :=
        t1916, %1919 := s6_9, %1920 := t1920, %1923 := s8_10, %1925 := s7_10, %1928 := s10_10,
        %1930 := s9_10, %1934 := s11_10, %1939 := t1939, %1940 := t1940, %1941 := t1941, %1945 :=
        s1_6, %1946 := s0_4, %1951 := s2_7, %1597 := p.add 2#64, %1601 := p.add 5#64, %1605 :=
        p.add 7#64, %1609 := p.add 10#64, %1613 := p.add 13#64, %1617 := p.add 15#64, %1621 :=
        p.add 18#64, %1624 := p.add 21#64, %1627 := p.add 23#64, %1631 := p.add 26#64, %1635 :=
        p.add 28#64, %1639 := p.add 31#64])
    (hbs10_10 : Bnd s10_10 (-137839549349888) 137839549412142)
    (hbs11_10 : Bnd s11_10 (-728145712686096) 728145711060637) (hbs0_4 : Bnd s0_4 0 2097151)
    (hK :
      ∀ (E' : ⟪sc25519_reduce.Γ⟫)
        (s1_7 carry2_1 t1954 s3_7 s3_8 s2_8 carry3_1 t1959 t1960 s4_8 s4_9 s3_9 carry4_1 t1965 s5_9
          s5_10 s4_10 carry5_1 s6_10 s5_11 carry6_2 s7_11 s6_11 carry7_2 s8_11 s7_12 carry8_2 s9_11
          s8_12 carry9_2 s10_11 s9_12 carry10_2 s11_11 s10_12 carry11_2 s11_12 t1989 s0_5 t1991 :
          BitVec 64),
        (hArgs : E'.args = (sc25519_reduce.args (.value p)).get) →
          (hc : sc25519_reduce.Consts E') →
          (hR :
            E' ⊨ [%1952 := s1_7, %1957 := s2_8, %1963 := s3_9, %1968 := s4_10, %1971 := s5_11,
              %1974 := s6_11, %1977 := s7_12, %1980 := s8_12, %1983 := s9_12, %1986 := s10_12,
              %1987 := carry11_2, %1988 := s11_12, %1990 := s0_5, %1991 := t1991, %1597 :=
              p.add 2#64, %1601 := p.add 5#64, %1605 := p.add 7#64, %1609 := p.add 10#64, %1613 :=
              p.add 13#64, %1617 := p.add 15#64, %1621 := p.add 18#64, %1624 := p.add 21#64,
              %1627 := p.add 23#64, %1631 := p.add 26#64, %1635 := p.add 28#64, %1639 :=
              p.add 31#64]) →
          (hs1_7 : s1_7 = s1_6 &&& 2097151#64) →
          (hcarry2_1 : carry2_1 = s2_7.sshiftRight 21) →
          (ht1954 : t1954 = s3_5 + t1939) →
          (hs3_7 : s3_7 = t1954 - t1916) →
          (hs3_8 : s3_8 = s3_7 + carry2_1) →
          (hs2_8 : s2_8 = s2_7 &&& 2097151#64) →
          (hcarry3_1 : carry3_1 = s3_8.sshiftRight 21) →
          (ht1959 : t1959 = t1940 + s4_5) →
          (ht1960 : t1960 = t1959 - t1892) →
          (hs4_8 : s4_8 = t1960 + carry3) →
          (hs4_9 : s4_9 = s4_8 + carry3_1) →
          (hs3_9 : s3_9 = s3_8 &&& 2097151#64) →
          (hcarry4_1 : carry4_1 = s4_9.sshiftRight 21) →
          (ht1965 : t1965 = s5_7 + t1941) →
          (hs5_9 : s5_9 = t1965 - t1920) →
          (hs5_10 : s5_10 = s5_9 + carry4_1) →
          (hs4_10 : s4_10 = s4_9 &&& 2097151#64) →
          (hcarry5_1 : carry5_1 = s5_10.sshiftRight 21) →
          (hs6_10 : s6_10 = s6_9 + carry5_1) →
          (hs5_11 : s5_11 = s5_10 &&& 2097151#64) →
          (hcarry6_2 : carry6_2 = s6_10.sshiftRight 21) →
          (hs7_11 : s7_11 = carry6_2 + s7_10) →
          (hs6_11 : s6_11 = s6_10 &&& 2097151#64) →
          (hcarry7_2 : carry7_2 = s7_11.sshiftRight 21) →
          (hs8_11 : s8_11 = s8_10 + carry7_2) →
          (hs7_12 : s7_12 = s7_11 &&& 2097151#64) →
          (hcarry8_2 : carry8_2 = s8_11.sshiftRight 21) →
          (hs9_11 : s9_11 = carry8_2 + s9_10) →
          (hs8_12 : s8_12 = s8_11 &&& 2097151#64) →
          (hcarry9_2 : carry9_2 = s9_11.sshiftRight 21) →
          (hs10_11 : s10_11 = s10_10 + carry9_2) →
          (hs9_12 : s9_12 = s9_11 &&& 2097151#64) →
          (hcarry10_2 : carry10_2 = s10_11.sshiftRight 21) →
          (hs11_11 : s11_11 = carry10_2 + s11_10) →
          (hs10_12 : s10_12 = s10_11 &&& 2097151#64) →
          (hcarry11_2 : carry11_2 = s11_11.sshiftRight 21) →
          (hs11_12 : s11_12 = s11_11 &&& 2097151#64) →
          (ht1989 : t1989 = carry11_2 * 666643#64) →
          (hs0_5 : s0_5 = t1989 + s0_4) →
          (ht1991 : t1991 = carry11_2 * 470296#64) →
          (hbs1_7 : Bnd s1_7 0 2097151) →
          (hbs2_8 : Bnd s2_8 0 2097151) →
          (hbs3_9 : Bnd s3_9 0 2097151) →
          (hbs4_10 : Bnd s4_10 0 2097151) →
          (hbs5_11 : Bnd s5_11 0 2097151) →
          (hbs6_11 : Bnd s6_11 0 2097151) →
          (hbs7_12 : Bnd s7_12 0 2097151) →
          (hbs8_12 : Bnd s8_12 0 2097151) →
          (hbs9_12 : Bnd s9_12 0 2097151) →
          (hbs10_12 : Bnd s10_12 0 2097151) →
          (hbcarry11_2 : Bnd carry11_2 (-347206965) 347206963) →
          (hbs11_12 : Bnd s11_12 0 2097151) →
          (hbs0_5 : Bnd s0_5 (-231463092768495) 231463093532360) →
          (hbt1991 : Bnd t1991 (-163290046811640) 163290045871048) →
          (blk.runBodyFrom E' 425 S >>= g) = K) :
    (blk.runBodyFrom E 385 S >>= g) = K := by
  step_pure with s1_7
  bnd_ext s1_7
  step_pure with carry2_1
  step_pure with t1954
  step_pure with s3_7
  step_pure with s3_8
  step_pure with s2_8
  bnd_ext s2_8
  step_pure with carry3_1
  step_pure with t1959
  step_pure with t1960
  step_pure with s4_8
  step_pure with s4_9
  step_pure with s3_9
  bnd_ext s3_9
  step_pure with carry4_1
  step_pure with t1965
  step_pure with s5_9
  step_pure with s5_10
  step_pure with s4_10
  bnd_ext s4_10
  step_pure with carry5_1
  step_pure with s6_10
  step_pure with s5_11
  bnd_ext s5_11
  step_pure with carry6_2
  step_pure with s7_11
  step_pure with s6_11
  bnd_ext s6_11
  step_pure with carry7_2
  step_pure with s8_11
  step_pure with s7_12
  bnd_ext s7_12
  step_pure with carry8_2
  step_pure with s9_11
  bnd_ext s9_11
  step_pure with s8_12
  bnd_ext s8_12
  step_pure with carry9_2
  bnd_ext carry9_2
  step_pure [nswAdd] with s10_11
  bnd_ext s10_11
  step_pure with s9_12
  bnd_ext s9_12
  step_pure with carry10_2
  bnd_ext carry10_2
  step_pure [nswAdd] with s11_11
  bnd_ext s11_11
  step_pure with s10_12
  bnd_ext s10_12
  step_pure with carry11_2
  bnd_ext carry11_2
  step_pure with s11_12
  bnd_ext s11_12
  step_pure [nswMul] with t1989
  bnd_ext t1989
  step_pure [nswAdd] with s0_5
  bnd_ext s0_5
  step_pure [nswMul] with t1991
  bnd_ext t1991
  exact
    hK _ s1_7 carry2_1 t1954 s3_7 s3_8 s2_8 carry3_1 t1959 t1960 s4_8 s4_9 s3_9 carry4_1 t1965 s5_9
      s5_10 s4_10 carry5_1 s6_10 s5_11 carry6_2 s7_11 s6_11 carry7_2 s8_11 s7_12 carry8_2 s9_11
      s8_12 carry9_2 s10_11 s9_12 carry10_2 s11_11 s10_12 carry11_2 s11_12 t1989 s0_5 t1991 hArgs
      (by
        unfold sc25519_reduce.Consts; env_reads)
      (by env_reads) hs1_7 hcarry2_1 ht1954 hs3_7 hs3_8 hs2_8 hcarry3_1 ht1959 ht1960 hs4_8 hs4_9
      hs3_9 hcarry4_1 ht1965 hs5_9 hs5_10 hs4_10 hcarry5_1 hs6_10 hs5_11 hcarry6_2 hs7_11 hs6_11
      hcarry7_2 hs8_11 hs7_12 hcarry8_2 hs9_11 hs8_12 hcarry9_2 hs10_11 hs9_12 hcarry10_2 hs11_11
      hs10_12 hcarry11_2 hs11_12 ht1989 hs0_5 ht1991 hbs1_7 hbs2_8 hbs3_9 hbs4_10 hbs5_11 hbs6_11
      hbs7_12 hbs8_12 hbs9_12 hbs10_12 hbcarry11_2 hbs11_12 hbs0_5 hbt1991

/-- `^bb0` from instruction 425 to 464: its values named, with their forms and bounds. -/
theorem sc25519_reduce.run425 {β : Type} {p : Pointer}
    {blk : BasicBlock sc25519_reduce.Γ [] sc25519_reduce.blockTys}
    (hbody : blk.body.drop 425 = sc25519_reduce.entry.body.drop 425) {E : ⟪sc25519_reduce.Γ⟫}
    {S : GlobalState} {g : ⟪sc25519_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s1_7 s2_8 s3_9 s4_10 s5_11 s6_11 s7_12 s8_12 s9_12 s10_12 carry11_2 s11_12 s0_5 t1991 :
      BitVec 64}
    (hArgs : E.args = (sc25519_reduce.args (.value p)).get) (hc : sc25519_reduce.Consts E)
    (hR :
      E ⊨ [%1952 := s1_7, %1957 := s2_8, %1963 := s3_9, %1968 := s4_10, %1971 := s5_11, %1974 :=
        s6_11, %1977 := s7_12, %1980 := s8_12, %1983 := s9_12, %1986 := s10_12, %1987 := carry11_2,
        %1988 := s11_12, %1990 := s0_5, %1991 := t1991, %1597 := p.add 2#64, %1601 := p.add 5#64,
        %1605 := p.add 7#64, %1609 := p.add 10#64, %1613 := p.add 13#64, %1617 := p.add 15#64,
        %1621 := p.add 18#64, %1624 := p.add 21#64, %1627 := p.add 23#64, %1631 := p.add 26#64,
        %1635 := p.add 28#64, %1639 := p.add 31#64])
    (hbs1_7 : Bnd s1_7 0 2097151) (hbs2_8 : Bnd s2_8 0 2097151) (hbs3_9 : Bnd s3_9 0 2097151)
    (hbs4_10 : Bnd s4_10 0 2097151) (hbs5_11 : Bnd s5_11 0 2097151) (hbs6_11 : Bnd s6_11 0 2097151)
    (hbs7_12 : Bnd s7_12 0 2097151) (hbs8_12 : Bnd s8_12 0 2097151) (hbs9_12 : Bnd s9_12 0 2097151)
    (hbs10_12 : Bnd s10_12 0 2097151) (hbcarry11_2 : Bnd carry11_2 (-347206965) 347206963)
    (hbs11_12 : Bnd s11_12 0 2097151) (hbs0_5 : Bnd s0_5 (-231463092768495) 231463093532360)
    (hbt1991 : Bnd t1991 (-163290046811640) 163290045871048)
    (hK :
      ∀ (E' : ⟪sc25519_reduce.Γ⟫)
        (s1_8 t1993 s2_9 t1995 s3_10 t1997 s4_11 t1999 s5_12 carry0_2 s1_9 carry1_2 s2_10 s1_10
          carry2_2 s3_11 s2_11 carry3_2 s4_12 s3_12 carry4_2 s5_13 s4_13 carry5_2 s6_12 s5_14
          carry6_3 s7_13 s6_13 carry7_3 s8_13 carry8_3 s9_13 carry9_3 s10_13 s9_14 carry10_3 s11_13
          s10_14 : BitVec 64),
        (hArgs : E'.args = (sc25519_reduce.args (.value p)).get) →
          (hc : sc25519_reduce.Consts E') →
          (hR :
            E' ⊨ [%1990 := s0_5, %2002 := s1_9, %2004 := s2_10, %2005 := s1_10, %2007 := s3_11,
              %2008 := s2_11, %2010 := s4_12, %2011 := s3_12, %2013 := s5_13, %2014 := s4_13,
              %2016 := s6_12, %2017 := s5_14, %2019 := s7_13, %2020 := s6_13, %2022 := s8_13,
              %2024 := s9_13, %2026 := s10_13, %2027 := s9_14, %2029 := s11_13, %2030 := s10_14,
              %1597 := p.add 2#64, %1601 := p.add 5#64, %1605 := p.add 7#64, %1609 := p.add 10#64,
              %1613 := p.add 13#64, %1617 := p.add 15#64, %1621 := p.add 18#64, %1624 :=
              p.add 21#64, %1627 := p.add 23#64, %1631 := p.add 26#64, %1635 := p.add 28#64,
              %1639 := p.add 31#64]) →
          (hs1_8 : s1_8 = t1991 + s1_7) →
          (ht1993 : t1993 = carry11_2 * 654183#64) →
          (hs2_9 : s2_9 = t1993 + s2_8) →
          (ht1995 : t1995 = carry11_2 * 18446744073708553811#64) →
          (hs3_10 : s3_10 = t1995 + s3_9) →
          (ht1997 : t1997 = carry11_2 * 136657#64) →
          (hs4_11 : s4_11 = t1997 + s4_10) →
          (ht1999 : t1999 = carry11_2 * 18446744073708867715#64) →
          (hs5_12 : s5_12 = t1999 + s5_11) →
          (hcarry0_2 : carry0_2 = s0_5.sshiftRight 21) →
          (hs1_9 : s1_9 = s1_8 + carry0_2) →
          (hcarry1_2 : carry1_2 = s1_9.sshiftRight 21) →
          (hs2_10 : s2_10 = s2_9 + carry1_2) →
          (hs1_10 : s1_10 = s1_9 &&& 2097151#64) →
          (hcarry2_2 : carry2_2 = s2_10.sshiftRight 21) →
          (hs3_11 : s3_11 = s3_10 + carry2_2) →
          (hs2_11 : s2_11 = s2_10 &&& 2097151#64) →
          (hcarry3_2 : carry3_2 = s3_11.sshiftRight 21) →
          (hs4_12 : s4_12 = s4_11 + carry3_2) →
          (hs3_12 : s3_12 = s3_11 &&& 2097151#64) →
          (hcarry4_2 : carry4_2 = s4_12.sshiftRight 21) →
          (hs5_13 : s5_13 = s5_12 + carry4_2) →
          (hs4_13 : s4_13 = s4_12 &&& 2097151#64) →
          (hcarry5_2 : carry5_2 = s5_13.sshiftRight 21) →
          (hs6_12 : s6_12 = carry5_2 + s6_11) →
          (hs5_14 : s5_14 = s5_13 &&& 2097151#64) →
          (hcarry6_3 : carry6_3 = s6_12.sshiftRight 21) →
          (hs7_13 : s7_13 = carry6_3 + s7_12) →
          (hs6_13 : s6_13 = s6_12 &&& 2097151#64) →
          (hcarry7_3 : carry7_3 = s7_13.sshiftRight 21) →
          (hs8_13 : s8_13 = carry7_3 + s8_12) →
          (hcarry8_3 : carry8_3 = s8_13.sshiftRight 21) →
          (hs9_13 : s9_13 = carry8_3 + s9_12) →
          (hcarry9_3 : carry9_3 = s9_13.sshiftRight 21) →
          (hs10_13 : s10_13 = carry9_3 + s10_12) →
          (hs9_14 : s9_14 = s9_13 &&& 2097151#64) →
          (hcarry10_3 : carry10_3 = s10_13.sshiftRight 21) →
          (hs11_13 : s11_13 = carry10_3 + s11_12) →
          (hs10_14 : s10_14 = s10_13 &&& 2097151#64) →
          (hbs1_10 : Bnd s1_10 0 2097151) →
          (hbs2_11 : Bnd s2_11 0 2097151) →
          (hbs3_12 : Bnd s3_12 0 2097151) →
          (hbs4_13 : Bnd s4_13 0 2097151) →
          (hbs5_14 : Bnd s5_14 0 2097151) →
          (hbs7_13 : Bnd s7_13 (-54) 2097205) →
          (hbs6_13 : Bnd s6_13 0 2097151) →
          (hbs9_14 : Bnd s9_14 0 2097151) →
          (hbs11_13 : Bnd s11_13 (-1) 2097152) →
          (hbs10_14 : Bnd s10_14 0 2097151) → (blk.runBodyFrom E' 464 S >>= g) = K) :
    (blk.runBodyFrom E 425 S >>= g) = K := by
  step_pure [nswAdd] with s1_8
  bnd_ext s1_8
  step_pure [nswMul] with t1993
  bnd_ext t1993
  step_pure [nswAdd] with s2_9
  bnd_ext s2_9
  step_pure [nswMul] with t1995
  bnd_ext t1995
  step_pure [nswAdd] with s3_10
  bnd_ext s3_10
  step_pure [nswMul] with t1997
  bnd_ext t1997
  step_pure [nswAdd] with s4_11
  bnd_ext s4_11
  step_pure [nswMul] with t1999
  bnd_ext t1999
  step_pure [nswAdd] with s5_12
  bnd_ext s5_12
  step_pure with carry0_2
  bnd_ext carry0_2
  step_pure [nswAdd] with s1_9
  bnd_ext s1_9
  step_pure with carry1_2
  bnd_ext carry1_2
  step_pure [nswAdd] with s2_10
  bnd_ext s2_10
  step_pure with s1_10
  bnd_ext s1_10
  step_pure with carry2_2
  bnd_ext carry2_2
  step_pure [nswAdd] with s3_11
  bnd_ext s3_11
  step_pure with s2_11
  bnd_ext s2_11
  step_pure with carry3_2
  bnd_ext carry3_2
  step_pure [nswAdd] with s4_12
  bnd_ext s4_12
  step_pure with s3_12
  bnd_ext s3_12
  step_pure with carry4_2
  bnd_ext carry4_2
  step_pure [nswAdd] with s5_13
  bnd_ext s5_13
  step_pure with s4_13
  bnd_ext s4_13
  step_pure with carry5_2
  bnd_ext carry5_2
  step_pure [nswAdd] with s6_12
  bnd_ext s6_12
  step_pure with s5_14
  bnd_ext s5_14
  step_pure with carry6_3
  bnd_ext carry6_3
  step_pure [nswAdd] with s7_13
  bnd_ext s7_13
  step_pure with s6_13
  bnd_ext s6_13
  step_pure with carry7_3
  bnd_ext carry7_3
  step_pure [nswAdd] with s8_13
  bnd_ext s8_13
  step_pure with carry8_3
  bnd_ext carry8_3
  step_pure [nswAdd] with s9_13
  bnd_ext s9_13
  step_pure with carry9_3
  bnd_ext carry9_3
  step_pure [nswAdd] with s10_13
  bnd_ext s10_13
  step_pure with s9_14
  bnd_ext s9_14
  step_pure with carry10_3
  bnd_ext carry10_3
  step_pure [nswAdd] with s11_13
  bnd_ext s11_13
  step_pure with s10_14
  bnd_ext s10_14
  exact
    hK _ s1_8 t1993 s2_9 t1995 s3_10 t1997 s4_11 t1999 s5_12 carry0_2 s1_9 carry1_2 s2_10 s1_10
      carry2_2 s3_11 s2_11 carry3_2 s4_12 s3_12 carry4_2 s5_13 s4_13 carry5_2 s6_12 s5_14 carry6_3
      s7_13 s6_13 carry7_3 s8_13 carry8_3 s9_13 carry9_3 s10_13 s9_14 carry10_3 s11_13 s10_14 hArgs
      (by
        unfold sc25519_reduce.Consts; env_reads)
      (by env_reads) hs1_8 ht1993 hs2_9 ht1995 hs3_10 ht1997 hs4_11 ht1999 hs5_12 hcarry0_2 hs1_9
      hcarry1_2 hs2_10 hs1_10 hcarry2_2 hs3_11 hs2_11 hcarry3_2 hs4_12 hs3_12 hcarry4_2 hs5_13
      hs4_13 hcarry5_2 hs6_12 hs5_14 hcarry6_3 hs7_13 hs6_13 hcarry7_3 hs8_13 hcarry8_3 hs9_13
      hcarry9_3 hs10_13 hs9_14 hcarry10_3 hs11_13 hs10_14 hbs1_10 hbs2_11 hbs3_12 hbs4_13 hbs5_14
      hbs7_13 hbs6_13 hbs9_14 hbs11_13 hbs10_14

-- 24 stores, merged into one at the end: past the default budget
set_option maxHeartbeats 1000000 in
/-- `^bb0` from instruction 464 to 567: its values named, with their forms and bounds. -/
theorem sc25519_reduce.run464 {β : Type} {p : Pointer}
    {blk : BasicBlock sc25519_reduce.Γ [] sc25519_reduce.blockTys}
    (hbody : blk.body.drop 464 = sc25519_reduce.entry.body.drop 464) {E : ⟪sc25519_reduce.Γ⟫}
    {S : GlobalState} {g : ⟪sc25519_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0_5 s1_9 s2_10 s1_10 s3_11 s2_11 s4_12 s3_12 s5_13 s4_13 s6_12 s5_14 s7_13 s6_13 s8_13 s9_13
      s10_13 s9_14 s11_13 s10_14 : BitVec 64}
    (hArgs : E.args = (sc25519_reduce.args (.value p)).get) (hp : Fits S.mem p (8 * 64))
    (hp_off : ¬p.offset.uaddOverflow 64#64) (hc : sc25519_reduce.Consts E)
    (hR :
      E ⊨ [%1990 := s0_5, %2002 := s1_9, %2004 := s2_10, %2005 := s1_10, %2007 := s3_11, %2008 :=
        s2_11, %2010 := s4_12, %2011 := s3_12, %2013 := s5_13, %2014 := s4_13, %2016 := s6_12,
        %2017 := s5_14, %2019 := s7_13, %2020 := s6_13, %2022 := s8_13, %2024 := s9_13, %2026 :=
        s10_13, %2027 := s9_14, %2029 := s11_13, %2030 := s10_14, %1597 := p.add 2#64, %1601 :=
        p.add 5#64, %1605 := p.add 7#64, %1609 := p.add 10#64, %1613 := p.add 13#64, %1617 :=
        p.add 15#64, %1621 := p.add 18#64, %1624 := p.add 21#64, %1627 := p.add 23#64, %1631 :=
        p.add 26#64, %1635 := p.add 28#64, %1639 := p.add 31#64])
    (hbs1_10 : Bnd s1_10 0 2097151) (hbs2_11 : Bnd s2_11 0 2097151) (hbs3_12 : Bnd s3_12 0 2097151)
    (hbs4_13 : Bnd s4_13 0 2097151) (hbs5_14 : Bnd s5_14 0 2097151)
    (hbs7_13 : Bnd s7_13 (-54) 2097205) (hbs6_13 : Bnd s6_13 0 2097151)
    (hbs9_14 : Bnd s9_14 0 2097151) (hbs11_13 : Bnd s11_13 (-1) 2097152)
    (hbs10_14 : Bnd s10_14 0 2097151)
    (hK :
      ∀ (E' : ⟪sc25519_reduce.Γ⟫),
        (hArgs : E'.args = (sc25519_reduce.args (.value p)).get) →
          (hc : sc25519_reduce.Consts E') →
          (blk.runBodyFrom E' 567
                { S with
                  mem :=
                    S.mem.storeAt p
                      (sc25519_reduce.out s0_5 s1_9 s2_10 s1_10 s3_11 s2_11 s4_12 s3_12 s5_13 s4_13
                        s6_12 s5_14 s7_13 s6_13 s8_13 s9_13 s10_13 s9_14 s11_13 s10_14) } >>=
              g) =
            K) :
    (blk.runBodyFrom E 464 S >>= g) = K := by
  step_pure
  step_store
  step_pure
  step_pure
  step_pure [sc25519_reduce.shl_nuw s1_10 5 (by decide)
        (Bnd.umulOverflow _ _ _ hbs1_10 128#64 (by decide)),
    sc25519_reduce.shl_nsw s1_10 5 (by decide) (Bnd.smulOverflow _ _ _ hbs1_10 128#64 (by decide))]
  step_pure [sc25519_reduce.or_disj_mask s1_10 s0_5]
  step_pure
  step_store
  step_pure
  step_pure
  step_pure
  step_store
  step_pure
  step_pure [sc25519_reduce.shl_nuw s2_11 2 (by decide)
        (Bnd.umulOverflow _ _ _ hbs2_11 128#64 (by decide)),
    sc25519_reduce.shl_nsw s2_11 2 (by decide) (Bnd.smulOverflow _ _ _ hbs2_11 128#64 (by decide))]
  step_pure [sc25519_reduce.or_disj s2_11 s1_10 2 (by decide)
        (Bnd.umulOverflow _ _ _ hbs1_10 8796093022208#64 (by decide))]
  step_pure
  step_store
  step_pure
  step_pure
  step_pure
  step_store
  step_pure
  step_pure [sc25519_reduce.shl_nuw s3_12 7 (by decide)
        (Bnd.umulOverflow _ _ _ hbs3_12 128#64 (by decide)),
    sc25519_reduce.shl_nsw s3_12 7 (by decide) (Bnd.smulOverflow _ _ _ hbs3_12 128#64 (by decide))]
  step_pure [sc25519_reduce.or_disj s3_12 s2_11 7 (by decide)
        (Bnd.umulOverflow _ _ _ hbs2_11 8796093022208#64 (by decide))]
  step_pure
  step_store
  step_pure
  step_pure
  step_pure
  step_store
  step_pure
  step_pure [sc25519_reduce.shl_nuw s4_13 4 (by decide)
        (Bnd.umulOverflow _ _ _ hbs4_13 128#64 (by decide)),
    sc25519_reduce.shl_nsw s4_13 4 (by decide) (Bnd.smulOverflow _ _ _ hbs4_13 128#64 (by decide))]
  step_pure [sc25519_reduce.or_disj s4_13 s3_12 4 (by decide)
        (Bnd.umulOverflow _ _ _ hbs3_12 8796093022208#64 (by decide))]
  step_pure
  step_store
  step_pure
  step_pure
  step_pure
  step_store
  step_pure
  step_pure [sc25519_reduce.shl_nuw s5_14 1 (by decide)
        (Bnd.umulOverflow _ _ _ hbs5_14 128#64 (by decide)),
    sc25519_reduce.shl_nsw s5_14 1 (by decide) (Bnd.smulOverflow _ _ _ hbs5_14 128#64 (by decide))]
  step_pure [sc25519_reduce.or_disj s5_14 s4_13 1 (by decide)
        (Bnd.umulOverflow _ _ _ hbs4_13 8796093022208#64 (by decide))]
  step_pure
  step_store
  step_pure
  step_pure
  step_pure
  step_store
  step_pure
  step_pure [sc25519_reduce.shl_nuw s6_13 6 (by decide)
        (Bnd.umulOverflow _ _ _ hbs6_13 128#64 (by decide)),
    sc25519_reduce.shl_nsw s6_13 6 (by decide) (Bnd.smulOverflow _ _ _ hbs6_13 128#64 (by decide))]
  step_pure [sc25519_reduce.or_disj s6_13 s5_14 6 (by decide)
        (Bnd.umulOverflow _ _ _ hbs5_14 8796093022208#64 (by decide))]
  step_pure
  step_store
  step_pure
  step_pure
  step_pure
  step_store
  step_pure
  step_pure [sc25519_reduce.shl_nsw s7_13 3 (by decide)
        (Bnd.smulOverflow _ _ _ hbs7_13 128#64 (by decide))]
  step_pure [sc25519_reduce.or_disj s7_13 s6_13 3 (by decide)
        (Bnd.umulOverflow _ _ _ hbs6_13 8796093022208#64 (by decide))]
  step_pure
  step_store
  step_pure
  step_pure
  step_pure
  step_store
  step_pure
  step_store
  step_pure
  step_pure
  step_pure [sc25519_reduce.shl_nuw s9_14 5 (by decide)
        (Bnd.umulOverflow _ _ _ hbs9_14 128#64 (by decide)),
    sc25519_reduce.shl_nsw s9_14 5 (by decide) (Bnd.smulOverflow _ _ _ hbs9_14 128#64 (by decide))]
  step_pure [sc25519_reduce.or_disj_mask s9_14 s8_13]
  step_pure
  step_store
  step_pure
  step_pure
  step_pure
  step_store
  step_pure
  step_pure [sc25519_reduce.shl_nuw s10_14 2 (by decide)
        (Bnd.umulOverflow _ _ _ hbs10_14 128#64 (by decide)),
    sc25519_reduce.shl_nsw s10_14 2 (by decide)
        (Bnd.smulOverflow _ _ _ hbs10_14 128#64 (by decide))]
  step_pure [sc25519_reduce.or_disj s10_14 s9_14 2 (by decide)
        (Bnd.umulOverflow _ _ _ hbs9_14 8796093022208#64 (by decide))]
  step_pure
  step_store
  step_pure
  step_pure
  step_pure
  step_store
  step_pure
  step_pure [sc25519_reduce.shl_nsw s11_13 7 (by decide)
        (Bnd.smulOverflow _ _ _ hbs11_13 128#64 (by decide))]
  step_pure [sc25519_reduce.or_disj s11_13 s10_14 7 (by decide)
        (Bnd.umulOverflow _ _ _ hbs10_14 8796093022208#64 (by decide))]
  step_pure
  step_store
  step_pure
  step_pure
  step_pure
  step_store
  step_pure
  step_pure
  step_pure
  step_store
  step_pure
  step_pure
  step_store
  subst hS
  rw [MemoryState.storeAt_storeAt_add (a := 16) (k := 2)
      (BitVec.not_uaddOverflow_of_le hp_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_add (a := 24) (k := 3)
      (BitVec.not_uaddOverflow_of_le hp_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_add (a := 40) (k := 5)
      (BitVec.not_uaddOverflow_of_le hp_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_add (a := 48) (k := 6)
      (BitVec.not_uaddOverflow_of_le hp_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_add (a := 56) (k := 7)
      (BitVec.not_uaddOverflow_of_le hp_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_add (a := 64) (k := 8)
      (BitVec.not_uaddOverflow_of_le hp_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_add (a := 80) (k := 10)
      (BitVec.not_uaddOverflow_of_le hp_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_add (a := 88) (k := 11)
      (BitVec.not_uaddOverflow_of_le hp_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_add (a := 104) (k := 13)
      (BitVec.not_uaddOverflow_of_le hp_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_add (a := 112) (k := 14)
      (BitVec.not_uaddOverflow_of_le hp_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_add (a := 120) (k := 15)
      (BitVec.not_uaddOverflow_of_le hp_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_add (a := 128) (k := 16)
      (BitVec.not_uaddOverflow_of_le hp_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_add (a := 144) (k := 18)
      (BitVec.not_uaddOverflow_of_le hp_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_add (a := 152) (k := 19)
      (BitVec.not_uaddOverflow_of_le hp_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_add (a := 168) (k := 21)
      (BitVec.not_uaddOverflow_of_le hp_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_add (a := 184) (k := 23)
      (BitVec.not_uaddOverflow_of_le hp_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_add (a := 192) (k := 24)
      (BitVec.not_uaddOverflow_of_le hp_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_add (a := 208) (k := 26)
      (BitVec.not_uaddOverflow_of_le hp_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_add (a := 216) (k := 27)
      (BitVec.not_uaddOverflow_of_le hp_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_add (a := 224) (k := 28)
      (BitVec.not_uaddOverflow_of_le hp_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_add (a := 232) (k := 29)
      (BitVec.not_uaddOverflow_of_le hp_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_add (a := 240) (k := 30)
      (BitVec.not_uaddOverflow_of_le hp_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_add (a := 248) (k := 31)
      (BitVec.not_uaddOverflow_of_le hp_off (by decide)) rfl (by decide)]
  exact
    hK _ hArgs
      (by
        unfold sc25519_reduce.Consts; env_reads)

/-- `sc25519_reduce` stores BoringSSL's `x25519_sc_reduce.spec` of the 64 bytes at `p` as the 32
bytes at `p`. -/
public theorem sc25519_reduce.call_eq (p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hp : Fits s.mem p (8 * 64)) (hp_off : ¬p.offset.uaddOverflow 64#64) :
    sc25519_reduce.call (sc25519_reduce.args (.value p)) s =
      .value
        (.nil,
          { s with
            mem := s.mem.storeAt p (Boringssl.x25519_sc_reduce.spec (s.mem.readAt p 512)) }) := by
  generalize hres : Boringssl.x25519_sc_reduce.spec (s.mem.readAt p 512) = res
  func_init
  have hp₀ : Fits S₀.mem p (8 * 64) := hS ▸ hp
  block_init
  step_pattern using sc25519_reduce.run0
  step_pattern using sc25519_reduce.run60
  step_pattern using sc25519_reduce.run116
  step_pattern using sc25519_reduce.run160
  step_pattern using sc25519_reduce.run205
  step_pattern using sc25519_reduce.run250
  step_pattern using sc25519_reduce.run295
  step_pattern using sc25519_reduce.run340
  step_pattern using sc25519_reduce.run385
  step_pattern using sc25519_reduce.run425
  clear hwf hp
  step_pattern using sc25519_reduce.run464
  finish_block
  rw [hS]
  subst hres
  rw [← sc25519_reduce.ir_eq_spec]
  keep_eqs
  subst_vars
  rfl

end Proof

end MLIR.Sodium
