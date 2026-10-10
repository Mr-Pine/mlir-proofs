#alias_scope_domain103 = #llvm.alias_scope_domain<id = distinct[103]<>, description = "_RNvMs2_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar528to_bytes">
#alias_scope177 = #llvm.alias_scope<id = distinct[319]<>, domain = #alias_scope_domain103, description = "_RNvMs2_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar528to_bytes: argument 1">
#alias_scope178 = #llvm.alias_scope<id = distinct[320]<>, domain = #alias_scope_domain103, description = "_RNvMs2_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar528to_bytes: argument 0">
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 1 : i64, llvm.dead_on_unwind, llvm.dereferenceable = 32 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writable, llvm.writeonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], sym_name = "_RNvMsp_NtCsh8hPzWUDumX_14solana_ed255196scalarNtNtNtNtNtB7_7backend6serial3u646scalar8Scalar524pack", target_cpu = "x86-64-v2", target_features = #llvm.target_features<["+avx", "+avx2", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+crc32", "+ssse3"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg37: !llvm.ptr, %arg38: !llvm.ptr):
  %1733 = "llvm.mlir.constant"() <{value = 8 : i64}> : () -> i64
  %1734 = "llvm.mlir.constant"() <{value = 16 : i64}> : () -> i64
  %1735 = "llvm.mlir.constant"() <{value = 24 : i64}> : () -> i64
  %1736 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %1737 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
  %1738 = "llvm.mlir.constant"() <{value = 48 : i64}> : () -> i64
  %1739 = "llvm.mlir.constant"() <{value = 4 : i64}> : () -> i64
  %1740 = "llvm.mlir.constant"() <{value = 12 : i64}> : () -> i64
  %1741 = "llvm.mlir.constant"() <{value = 20 : i64}> : () -> i64
  %1742 = "llvm.mlir.constant"() <{value = 28 : i64}> : () -> i64
  %1743 = "llvm.mlir.constant"() <{value = 36 : i64}> : () -> i64
  %1744 = "llvm.mlir.constant"() <{value = 44 : i64}> : () -> i64
  %1745 = "llvm.load"(%arg38) <{alias_scopes = [#alias_scope177], alignment = 8 : i64, noalias_scopes = [#alias_scope178], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1746 = "llvm.trunc"(%1745) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1747 = "llvm.lshr"(%1745, %1733) : (i64, i64) -> i64
  %1748 = "llvm.trunc"(%1747) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1749 = "llvm.lshr"(%1745, %1734) : (i64, i64) -> i64
  %1750 = "llvm.trunc"(%1749) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1751 = "llvm.lshr"(%1745, %1735) : (i64, i64) -> i64
  %1752 = "llvm.trunc"(%1751) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1753 = "llvm.lshr"(%1745, %1736) : (i64, i64) -> i64
  %1754 = "llvm.trunc"(%1753) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1755 = "llvm.lshr"(%1745, %1737) : (i64, i64) -> i64
  %1756 = "llvm.trunc"(%1755) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1757 = "llvm.lshr"(%1745, %1738) : (i64, i64) -> i64
  %1758 = "llvm.getelementptr"(%arg38) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %1759 = "llvm.load"(%1758) <{alias_scopes = [#alias_scope177], alignment = 8 : i64, noalias_scopes = [#alias_scope178], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1760 = "llvm.shl"(%1759, %1739) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1761 = "llvm.or"(%1760, %1757) : (i64, i64) -> i64
  %1762 = "llvm.trunc"(%1761) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1763 = "llvm.lshr"(%1759, %1739) : (i64, i64) -> i64
  %1764 = "llvm.trunc"(%1763) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1765 = "llvm.lshr"(%1759, %1740) : (i64, i64) -> i64
  %1766 = "llvm.trunc"(%1765) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1767 = "llvm.lshr"(%1759, %1741) : (i64, i64) -> i64
  %1768 = "llvm.trunc"(%1767) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1769 = "llvm.lshr"(%1759, %1742) : (i64, i64) -> i64
  %1770 = "llvm.trunc"(%1769) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1771 = "llvm.lshr"(%1759, %1743) : (i64, i64) -> i64
  %1772 = "llvm.trunc"(%1771) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1773 = "llvm.lshr"(%1759, %1744) : (i64, i64) -> i64
  %1774 = "llvm.trunc"(%1773) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1775 = "llvm.getelementptr"(%arg38) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %1776 = "llvm.load"(%1775) <{alias_scopes = [#alias_scope177], alignment = 8 : i64, noalias_scopes = [#alias_scope178], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1777 = "llvm.trunc"(%1776) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1778 = "llvm.lshr"(%1776, %1733) : (i64, i64) -> i64
  %1779 = "llvm.trunc"(%1778) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1780 = "llvm.lshr"(%1776, %1734) : (i64, i64) -> i64
  %1781 = "llvm.trunc"(%1780) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1782 = "llvm.lshr"(%1776, %1735) : (i64, i64) -> i64
  %1783 = "llvm.trunc"(%1782) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1784 = "llvm.lshr"(%1776, %1736) : (i64, i64) -> i64
  %1785 = "llvm.trunc"(%1784) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1786 = "llvm.lshr"(%1776, %1737) : (i64, i64) -> i64
  %1787 = "llvm.trunc"(%1786) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1788 = "llvm.lshr"(%1776, %1738) : (i64, i64) -> i64
  %1789 = "llvm.getelementptr"(%arg38) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %1790 = "llvm.load"(%1789) <{alias_scopes = [#alias_scope177], alignment = 8 : i64, noalias_scopes = [#alias_scope178], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1791 = "llvm.shl"(%1790, %1739) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1792 = "llvm.or"(%1791, %1788) : (i64, i64) -> i64
  %1793 = "llvm.trunc"(%1792) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1794 = "llvm.lshr"(%1790, %1739) : (i64, i64) -> i64
  %1795 = "llvm.trunc"(%1794) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1796 = "llvm.lshr"(%1790, %1740) : (i64, i64) -> i64
  %1797 = "llvm.trunc"(%1796) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1798 = "llvm.lshr"(%1790, %1741) : (i64, i64) -> i64
  %1799 = "llvm.trunc"(%1798) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1800 = "llvm.lshr"(%1790, %1742) : (i64, i64) -> i64
  %1801 = "llvm.trunc"(%1800) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1802 = "llvm.lshr"(%1790, %1743) : (i64, i64) -> i64
  %1803 = "llvm.trunc"(%1802) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1804 = "llvm.lshr"(%1790, %1744) : (i64, i64) -> i64
  %1805 = "llvm.trunc"(%1804) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1806 = "llvm.getelementptr"(%arg38) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %1807 = "llvm.load"(%1806) <{alias_scopes = [#alias_scope177], alignment = 8 : i64, noalias_scopes = [#alias_scope178], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1808 = "llvm.trunc"(%1807) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1809 = "llvm.lshr"(%1807, %1733) : (i64, i64) -> i64
  %1810 = "llvm.trunc"(%1809) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1811 = "llvm.lshr"(%1807, %1734) : (i64, i64) -> i64
  %1812 = "llvm.trunc"(%1811) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1813 = "llvm.lshr"(%1807, %1735) : (i64, i64) -> i64
  %1814 = "llvm.trunc"(%1813) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1815 = "llvm.lshr"(%1807, %1736) : (i64, i64) -> i64
  %1816 = "llvm.trunc"(%1815) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1817 = "llvm.lshr"(%1807, %1737) : (i64, i64) -> i64
  %1818 = "llvm.trunc"(%1817) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%1746, %arg37) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1819 = "llvm.getelementptr"(%arg37) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1748, %1819) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1820 = "llvm.getelementptr"(%arg37) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1750, %1820) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1821 = "llvm.getelementptr"(%arg37) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 3>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1752, %1821) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1822 = "llvm.getelementptr"(%arg37) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1754, %1822) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1823 = "llvm.getelementptr"(%arg37) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 5>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1756, %1823) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1824 = "llvm.getelementptr"(%arg37) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1762, %1824) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1825 = "llvm.getelementptr"(%arg37) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 7>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1764, %1825) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1826 = "llvm.getelementptr"(%arg37) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1766, %1826) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1827 = "llvm.getelementptr"(%arg37) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 9>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1768, %1827) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1828 = "llvm.getelementptr"(%arg37) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 10>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1770, %1828) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1829 = "llvm.getelementptr"(%arg37) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 11>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1772, %1829) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1830 = "llvm.getelementptr"(%arg37) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 12>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1774, %1830) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1831 = "llvm.getelementptr"(%arg37) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 13>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1777, %1831) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1832 = "llvm.getelementptr"(%arg37) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 14>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1779, %1832) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1833 = "llvm.getelementptr"(%arg37) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 15>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1781, %1833) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1834 = "llvm.getelementptr"(%arg37) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1783, %1834) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1835 = "llvm.getelementptr"(%arg37) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 17>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1785, %1835) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1836 = "llvm.getelementptr"(%arg37) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 18>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1787, %1836) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1837 = "llvm.getelementptr"(%arg37) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 19>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1793, %1837) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1838 = "llvm.getelementptr"(%arg37) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 20>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1795, %1838) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1839 = "llvm.getelementptr"(%arg37) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 21>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1797, %1839) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1840 = "llvm.getelementptr"(%arg37) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 22>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1799, %1840) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1841 = "llvm.getelementptr"(%arg37) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 23>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1801, %1841) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1842 = "llvm.getelementptr"(%arg37) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1803, %1842) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1843 = "llvm.getelementptr"(%arg37) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 25>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1805, %1843) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1844 = "llvm.getelementptr"(%arg37) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 26>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1808, %1844) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1845 = "llvm.getelementptr"(%arg37) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 27>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1810, %1845) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1846 = "llvm.getelementptr"(%arg37) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 28>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1812, %1846) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1847 = "llvm.getelementptr"(%arg37) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 29>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1814, %1847) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1848 = "llvm.getelementptr"(%arg37) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 30>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1816, %1848) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1849 = "llvm.getelementptr"(%arg37) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 31>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1818, %1849) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
