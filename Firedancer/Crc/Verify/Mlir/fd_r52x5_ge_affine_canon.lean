module

-- crc/out/mlirproofs/regions/verify/fd_r52x5_ge_affine_canon.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_inv_propose
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_limbs_is_one
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_lane_canon
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_mul
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_sqr
public import Firedancer.Crc.Verify.Mlir.wl_permute

meta import MLIR.Semantics.Func
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_inv_propose
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_limbs_is_one
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_lane_canon
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_mul
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_sqr
meta import Firedancer.Crc.Verify.Mlir.wl_permute

namespace MLIR.Firedancer.Crc.Verify

@[expose] public section

noncomputable mlir_def fd_r52x5_ge_affine_canon :=
#loop_annotation = #llvm.loop_annotation<mustProgress = true>
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, no_inline, no_unwind, passthrough = ["sspstrong", ["min-legal-vector-width", "256"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], sym_name = "fd_r52x5_ge_affine_canon", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg148: !llvm.ptr, %arg149: !llvm.ptr, %arg150: !llvm.ptr):
  %1723 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1724 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %1725 = "llvm.mlir.poison"() : () -> vector<1xi64>
  %1726 = "llvm.mlir.poison"() : () -> vector<4xi64>
  %1727 = "llvm.mlir.constant"() <{value = 64 : i256}> : () -> i256
  %1728 = "llvm.mlir.poison"() : () -> vector<2xi64>
  %1729 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %1730 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %1731 = "llvm.mlir.constant"() <{value = 20 : i32}> : () -> i32
  %1732 = "llvm.mlir.constant"() <{value = 50 : i32}> : () -> i32
  %1733 = "llvm.mlir.constant"() <{value = 100 : i32}> : () -> i32
  %1734 = "llvm.alloca"(%1723) <{alignment = 16 : i64, elem_type = !llvm.array<5 x i64>}> : (i32) -> !llvm.ptr
  %1735 = "llvm.alloca"(%1723) <{alignment = 16 : i64, elem_type = !llvm.array<5 x i64>}> : (i32) -> !llvm.ptr
  %1736 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1737 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1738 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1739 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1740 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1741 = "llvm.alloca"(%1723) <{alignment = 16 : i64, elem_type = !llvm.array<5 x i64>}> : (i32) -> !llvm.ptr
  %1742 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1743 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1744 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1745 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1746 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1747 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1748 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1749 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1750 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1751 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1752 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1753 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1754 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1755 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1756 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1757 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1758 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1759 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1760 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1761 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1762 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1763 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1764 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1765 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1766 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1767 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1768 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1769 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1770 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1771 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1772 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1773 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1774 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1775 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1776 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1777 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1778 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1779 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1780 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1781 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1782 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1783 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1784 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1785 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1786 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1787 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1788 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1789 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1790 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1791 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1792 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1793 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1794 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1795 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1796 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1797 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1798 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1799 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1800 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1801 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1802 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1803 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1804 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1805 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1806 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1807 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1808 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1809 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1810 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1811 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1812 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1813 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1814 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1815 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1816 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1817 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1818 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1819 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1820 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1821 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1822 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1823 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1824 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1825 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1826 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1827 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1828 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1829 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1830 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1831 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1832 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1833 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1834 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1835 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1836 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1837 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1838 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1839 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1840 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1841 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1842 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1843 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1844 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1845 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1846 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1847 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1848 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1849 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1850 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1851 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1852 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1853 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1854 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1855 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1856 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1857 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1858 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1859 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1860 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1861 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1862 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1863 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1864 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1865 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1866 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1867 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1868 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1869 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1870 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1871 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1872 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1873 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1874 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1875 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1876 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1877 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1878 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1879 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1880 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1881 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1882 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1883 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1884 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1885 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1886 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1887 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1888 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1889 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1890 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1891 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1892 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1893 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1894 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1895 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1896 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1897 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1898 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1899 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1900 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1901 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1902 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1903 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1904 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1905 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1906 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1907 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1908 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1909 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1910 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1911 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1912 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1913 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1914 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1915 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1916 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1917 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1918 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1919 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1920 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1921 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1922 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1923 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1924 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1925 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1926 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1927 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1928 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1929 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1930 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1931 = "llvm.alloca"(%1723) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1932 = "llvm.load"(%arg150) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1933 = "llvm.getelementptr"(%arg150) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %1934 = "llvm.load"(%1933) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1935 = "llvm.getelementptr"(%arg150) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %1936 = "llvm.load"(%1935) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1937 = "llvm.getelementptr"(%arg150) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %1938 = "llvm.load"(%1937) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1939 = "llvm.getelementptr"(%arg150) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %1940 = "llvm.load"(%1939) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%1734) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1735) : (!llvm.ptr) -> ()
  "llvm.call"(%1734, %1932, %1934, %1936, %1938, %1940, %1724) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_lane_canon, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 7, 0>}> : (!llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, i32) -> ()
  "llvm.call"(%1735, %1734) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_inv_propose, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %1941 = "llvm.load"(%1735) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<1xi64>
  %1942 = "llvm.shufflevector"(%1941, %1725) <{mask = array<i32: 0, 0, 0, 0>}> : (vector<1xi64>, vector<1xi64>) -> vector<4xi64>
  %1943 = "llvm.getelementptr"(%1735) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %1944 = "llvm.load"(%1943) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1945 = "llvm.shufflevector"(%1944, %1726) <{mask = array<i32: 0, 0, 0, 0>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1946 = "llvm.bitcast"(%1944) : (vector<4xi64>) -> i256
  %1947 = "llvm.lshr"(%1946, %1727) : (i256, i256) -> i256
  %1948 = "llvm.trunc"(%1947) <{overflowFlags = 0 : i32}> : (i256) -> i128
  %1949 = "llvm.bitcast"(%1948) : (i128) -> vector<2xi64>
  %1950 = "llvm.shufflevector"(%1949, %1728) <{mask = array<i32: 0, 0, 0, 0>}> : (vector<2xi64>, vector<2xi64>) -> vector<4xi64>
  %1951 = "llvm.bitcast"(%1944) : (vector<4xi64>) -> vector<2xi128>
  %1952 = "llvm.extractelement"(%1951, %1729) : (vector<2xi128>, i64) -> i128
  %1953 = "llvm.bitcast"(%1952) : (i128) -> vector<2xi64>
  %1954 = "llvm.shufflevector"(%1953, %1728) <{mask = array<i32: 0, 0, 0, 0>}> : (vector<2xi64>, vector<2xi64>) -> vector<4xi64>
  %1955 = "llvm.shufflevector"(%1944, %1726) <{mask = array<i32: 3, 3, 3, 3>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%1736) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1737) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1738) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1739) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1740) : (!llvm.ptr) -> ()
  "llvm.call"(%1736, %1737, %1738, %1739, %1740, %1932, %1934, %1936, %1938, %1940, %1942, %1945, %1950, %1954, %1955) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1956 = "llvm.load"(%1736) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1957 = "llvm.load"(%1737) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1958 = "llvm.load"(%1738) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1959 = "llvm.load"(%1739) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1960 = "llvm.load"(%1740) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1740) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1739) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1738) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1737) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1736) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1741) : (!llvm.ptr) -> ()
  "llvm.call"(%1741, %1956, %1957, %1958, %1959, %1960, %1724) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_lane_canon, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 7, 0>}> : (!llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, i32) -> ()
  %1961 = "llvm.call"(%1741) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_r52x5_limbs_is_one, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i32
  %1962 = "llvm.icmp"(%1961, %1730) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%1962, %1960, %1959, %1958, %1957, %1956)[^bb1, ^bb10] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 5>}> : (i1, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb1:  // pred: ^bb0
  %1963 = "llvm.call"(%1932, %1724, %1724, %1724, %1724) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1964 = "llvm.call"(%1934, %1724, %1724, %1724, %1724) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1965 = "llvm.call"(%1936, %1724, %1724, %1724, %1724) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1966 = "llvm.call"(%1938, %1724, %1724, %1724, %1724) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1967 = "llvm.call"(%1940, %1724, %1724, %1724, %1724) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%1742) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1743) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1744) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1745) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1746) : (!llvm.ptr) -> ()
  "llvm.call"(%1742, %1743, %1744, %1745, %1746, %1963, %1964, %1965, %1966, %1967) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1968 = "llvm.load"(%1742) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1969 = "llvm.load"(%1743) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1970 = "llvm.load"(%1744) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1971 = "llvm.load"(%1745) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1972 = "llvm.load"(%1746) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1746) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1745) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1744) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1743) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1742) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1747) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1748) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1749) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1750) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1751) : (!llvm.ptr) -> ()
  "llvm.call"(%1747, %1748, %1749, %1750, %1751, %1968, %1969, %1970, %1971, %1972) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1973 = "llvm.load"(%1747) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1974 = "llvm.load"(%1748) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1975 = "llvm.load"(%1749) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1976 = "llvm.load"(%1750) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1977 = "llvm.load"(%1751) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1751) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1750) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1749) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1748) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1747) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1752) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1753) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1754) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1755) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1756) : (!llvm.ptr) -> ()
  "llvm.call"(%1752, %1753, %1754, %1755, %1756, %1973, %1974, %1975, %1976, %1977) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1978 = "llvm.load"(%1752) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1979 = "llvm.load"(%1753) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1980 = "llvm.load"(%1754) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1981 = "llvm.load"(%1755) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1982 = "llvm.load"(%1756) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1756) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1755) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1754) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1753) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1752) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1757) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1758) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1759) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1760) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1761) : (!llvm.ptr) -> ()
  "llvm.call"(%1757, %1758, %1759, %1760, %1761, %1963, %1964, %1965, %1966, %1967, %1978, %1979, %1980, %1981, %1982) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1983 = "llvm.load"(%1757) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1984 = "llvm.load"(%1758) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1985 = "llvm.load"(%1759) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1986 = "llvm.load"(%1760) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1987 = "llvm.load"(%1761) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1761) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1760) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1759) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1758) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1757) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1762) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1763) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1764) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1765) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1766) : (!llvm.ptr) -> ()
  "llvm.call"(%1762, %1763, %1764, %1765, %1766, %1968, %1969, %1970, %1971, %1972, %1983, %1984, %1985, %1986, %1987) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1988 = "llvm.load"(%1762) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1989 = "llvm.load"(%1763) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1990 = "llvm.load"(%1764) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1991 = "llvm.load"(%1765) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1992 = "llvm.load"(%1766) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1766) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1765) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1764) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1763) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1762) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1767) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1768) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1769) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1770) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1771) : (!llvm.ptr) -> ()
  "llvm.call"(%1767, %1768, %1769, %1770, %1771, %1988, %1989, %1990, %1991, %1992) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1993 = "llvm.load"(%1767) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1994 = "llvm.load"(%1768) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1995 = "llvm.load"(%1769) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1996 = "llvm.load"(%1770) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1997 = "llvm.load"(%1771) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1771) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1770) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1769) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1768) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1767) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1772) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1773) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1774) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1775) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1776) : (!llvm.ptr) -> ()
  "llvm.call"(%1772, %1773, %1774, %1775, %1776, %1983, %1984, %1985, %1986, %1987, %1993, %1994, %1995, %1996, %1997) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1998 = "llvm.load"(%1772) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1999 = "llvm.load"(%1773) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2000 = "llvm.load"(%1774) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2001 = "llvm.load"(%1775) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2002 = "llvm.load"(%1776) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1776) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1775) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1774) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1773) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1772) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1777) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1778) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1779) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1780) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1781) : (!llvm.ptr) -> ()
  "llvm.call"(%1777, %1778, %1779, %1780, %1781, %1998, %1999, %2000, %2001, %2002) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2003 = "llvm.load"(%1777) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2004 = "llvm.load"(%1778) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2005 = "llvm.load"(%1779) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2006 = "llvm.load"(%1780) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2007 = "llvm.load"(%1781) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1781) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1780) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1779) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1778) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1777) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1782) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1783) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1784) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1785) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1786) : (!llvm.ptr) -> ()
  "llvm.call"(%1782, %1783, %1784, %1785, %1786, %2003, %2004, %2005, %2006, %2007) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2008 = "llvm.load"(%1782) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2009 = "llvm.load"(%1783) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2010 = "llvm.load"(%1784) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2011 = "llvm.load"(%1785) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2012 = "llvm.load"(%1786) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1786) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1785) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1784) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1783) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1782) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1782) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1783) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1784) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1785) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1786) : (!llvm.ptr) -> ()
  "llvm.call"(%1782, %1783, %1784, %1785, %1786, %2008, %2009, %2010, %2011, %2012) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2013 = "llvm.load"(%1782) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2014 = "llvm.load"(%1783) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2015 = "llvm.load"(%1784) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2016 = "llvm.load"(%1785) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2017 = "llvm.load"(%1786) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1786) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1785) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1784) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1783) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1782) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1782) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1783) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1784) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1785) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1786) : (!llvm.ptr) -> ()
  "llvm.call"(%1782, %1783, %1784, %1785, %1786, %2013, %2014, %2015, %2016, %2017) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2018 = "llvm.load"(%1782) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2019 = "llvm.load"(%1783) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2020 = "llvm.load"(%1784) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2021 = "llvm.load"(%1785) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2022 = "llvm.load"(%1786) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1786) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1785) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1784) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1783) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1782) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1782) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1783) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1784) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1785) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1786) : (!llvm.ptr) -> ()
  "llvm.call"(%1782, %1783, %1784, %1785, %1786, %2018, %2019, %2020, %2021, %2022) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2023 = "llvm.load"(%1782) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2024 = "llvm.load"(%1783) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2025 = "llvm.load"(%1784) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2026 = "llvm.load"(%1785) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2027 = "llvm.load"(%1786) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1786) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1785) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1784) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1783) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1782) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1787) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1788) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1789) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1790) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1791) : (!llvm.ptr) -> ()
  "llvm.call"(%1787, %1788, %1789, %1790, %1791, %2023, %2024, %2025, %2026, %2027, %1998, %1999, %2000, %2001, %2002) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2028 = "llvm.load"(%1787) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2029 = "llvm.load"(%1788) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2030 = "llvm.load"(%1789) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2031 = "llvm.load"(%1790) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2032 = "llvm.load"(%1791) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1791) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1790) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1789) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1788) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1787) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1792) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1793) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1794) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1795) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1796) : (!llvm.ptr) -> ()
  "llvm.call"(%1792, %1793, %1794, %1795, %1796, %2028, %2029, %2030, %2031, %2032) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2033 = "llvm.load"(%1792) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2034 = "llvm.load"(%1793) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2035 = "llvm.load"(%1794) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2036 = "llvm.load"(%1795) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2037 = "llvm.load"(%1796) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1796) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1795) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1794) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1793) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1792) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1797) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1798) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1799) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1800) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1801) : (!llvm.ptr) -> ()
  "llvm.call"(%1797, %1798, %1799, %1800, %1801, %2033, %2034, %2035, %2036, %2037) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2038 = "llvm.load"(%1797) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2039 = "llvm.load"(%1798) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2040 = "llvm.load"(%1799) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2041 = "llvm.load"(%1800) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2042 = "llvm.load"(%1801) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1801) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1800) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1799) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1798) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1797) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1797) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1798) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1799) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1800) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1801) : (!llvm.ptr) -> ()
  "llvm.call"(%1797, %1798, %1799, %1800, %1801, %2038, %2039, %2040, %2041, %2042) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2043 = "llvm.load"(%1797) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2044 = "llvm.load"(%1798) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2045 = "llvm.load"(%1799) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2046 = "llvm.load"(%1800) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2047 = "llvm.load"(%1801) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1801) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1800) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1799) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1798) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1797) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1797) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1798) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1799) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1800) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1801) : (!llvm.ptr) -> ()
  "llvm.call"(%1797, %1798, %1799, %1800, %1801, %2043, %2044, %2045, %2046, %2047) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2048 = "llvm.load"(%1797) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2049 = "llvm.load"(%1798) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2050 = "llvm.load"(%1799) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2051 = "llvm.load"(%1800) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2052 = "llvm.load"(%1801) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1801) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1800) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1799) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1798) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1797) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1797) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1798) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1799) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1800) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1801) : (!llvm.ptr) -> ()
  "llvm.call"(%1797, %1798, %1799, %1800, %1801, %2048, %2049, %2050, %2051, %2052) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2053 = "llvm.load"(%1797) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2054 = "llvm.load"(%1798) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2055 = "llvm.load"(%1799) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2056 = "llvm.load"(%1800) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2057 = "llvm.load"(%1801) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1801) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1800) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1799) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1798) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1797) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1797) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1798) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1799) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1800) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1801) : (!llvm.ptr) -> ()
  "llvm.call"(%1797, %1798, %1799, %1800, %1801, %2053, %2054, %2055, %2056, %2057) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2058 = "llvm.load"(%1797) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2059 = "llvm.load"(%1798) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2060 = "llvm.load"(%1799) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2061 = "llvm.load"(%1800) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2062 = "llvm.load"(%1801) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1801) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1800) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1799) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1798) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1797) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1797) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1798) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1799) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1800) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1801) : (!llvm.ptr) -> ()
  "llvm.call"(%1797, %1798, %1799, %1800, %1801, %2058, %2059, %2060, %2061, %2062) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2063 = "llvm.load"(%1797) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2064 = "llvm.load"(%1798) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2065 = "llvm.load"(%1799) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2066 = "llvm.load"(%1800) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2067 = "llvm.load"(%1801) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1801) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1800) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1799) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1798) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1797) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1797) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1798) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1799) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1800) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1801) : (!llvm.ptr) -> ()
  "llvm.call"(%1797, %1798, %1799, %1800, %1801, %2063, %2064, %2065, %2066, %2067) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2068 = "llvm.load"(%1797) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2069 = "llvm.load"(%1798) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2070 = "llvm.load"(%1799) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2071 = "llvm.load"(%1800) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2072 = "llvm.load"(%1801) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1801) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1800) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1799) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1798) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1797) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1797) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1798) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1799) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1800) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1801) : (!llvm.ptr) -> ()
  "llvm.call"(%1797, %1798, %1799, %1800, %1801, %2068, %2069, %2070, %2071, %2072) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2073 = "llvm.load"(%1797) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2074 = "llvm.load"(%1798) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2075 = "llvm.load"(%1799) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2076 = "llvm.load"(%1800) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2077 = "llvm.load"(%1801) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1801) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1800) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1799) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1798) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1797) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1797) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1798) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1799) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1800) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1801) : (!llvm.ptr) -> ()
  "llvm.call"(%1797, %1798, %1799, %1800, %1801, %2073, %2074, %2075, %2076, %2077) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2078 = "llvm.load"(%1797) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2079 = "llvm.load"(%1798) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2080 = "llvm.load"(%1799) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2081 = "llvm.load"(%1800) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2082 = "llvm.load"(%1801) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1801) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1800) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1799) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1798) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1797) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1802) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1803) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1804) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1805) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1806) : (!llvm.ptr) -> ()
  "llvm.call"(%1802, %1803, %1804, %1805, %1806, %2078, %2079, %2080, %2081, %2082, %2028, %2029, %2030, %2031, %2032) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2083 = "llvm.load"(%1802) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2084 = "llvm.load"(%1803) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2085 = "llvm.load"(%1804) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2086 = "llvm.load"(%1805) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2087 = "llvm.load"(%1806) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1806) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1805) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1804) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1803) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1802) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1807) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1808) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1809) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1810) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1811) : (!llvm.ptr) -> ()
  "llvm.call"(%1807, %1808, %1809, %1810, %1811, %2083, %2084, %2085, %2086, %2087) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2088 = "llvm.load"(%1807) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2089 = "llvm.load"(%1808) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2090 = "llvm.load"(%1809) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2091 = "llvm.load"(%1810) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2092 = "llvm.load"(%1811) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1811) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1810) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1809) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1808) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1807) : (!llvm.ptr) -> ()
  "llvm.br"(%1723, %2092, %2091, %2090, %2089, %2088)[^bb3] : (i32, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb2:  // pred: ^bb3
  "llvm.intr.lifetime.start"(%1817) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1818) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1819) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1820) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1821) : (!llvm.ptr) -> ()
  "llvm.call"(%1817, %1818, %1819, %1820, %1821, %2164, %2165, %2166, %2167, %2168, %2083, %2084, %2085, %2086, %2087) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2093 = "llvm.load"(%1817) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2094 = "llvm.load"(%1818) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2095 = "llvm.load"(%1819) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2096 = "llvm.load"(%1820) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2097 = "llvm.load"(%1821) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1821) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1820) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1819) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1818) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1817) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1822) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1823) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1824) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1825) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1826) : (!llvm.ptr) -> ()
  "llvm.call"(%1822, %1823, %1824, %1825, %1826, %2093, %2094, %2095, %2096, %2097) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2098 = "llvm.load"(%1822) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2099 = "llvm.load"(%1823) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2100 = "llvm.load"(%1824) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2101 = "llvm.load"(%1825) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2102 = "llvm.load"(%1826) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1826) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1825) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1824) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1823) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1822) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1827) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1828) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1829) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1830) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1831) : (!llvm.ptr) -> ()
  "llvm.call"(%1827, %1828, %1829, %1830, %1831, %2098, %2099, %2100, %2101, %2102) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2103 = "llvm.load"(%1827) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2104 = "llvm.load"(%1828) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2105 = "llvm.load"(%1829) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2106 = "llvm.load"(%1830) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2107 = "llvm.load"(%1831) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1831) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1830) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1829) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1828) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1827) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1827) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1828) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1829) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1830) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1831) : (!llvm.ptr) -> ()
  "llvm.call"(%1827, %1828, %1829, %1830, %1831, %2103, %2104, %2105, %2106, %2107) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2108 = "llvm.load"(%1827) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2109 = "llvm.load"(%1828) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2110 = "llvm.load"(%1829) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2111 = "llvm.load"(%1830) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2112 = "llvm.load"(%1831) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1831) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1830) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1829) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1828) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1827) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1827) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1828) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1829) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1830) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1831) : (!llvm.ptr) -> ()
  "llvm.call"(%1827, %1828, %1829, %1830, %1831, %2108, %2109, %2110, %2111, %2112) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2113 = "llvm.load"(%1827) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2114 = "llvm.load"(%1828) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2115 = "llvm.load"(%1829) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2116 = "llvm.load"(%1830) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2117 = "llvm.load"(%1831) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1831) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1830) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1829) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1828) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1827) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1827) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1828) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1829) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1830) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1831) : (!llvm.ptr) -> ()
  "llvm.call"(%1827, %1828, %1829, %1830, %1831, %2113, %2114, %2115, %2116, %2117) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2118 = "llvm.load"(%1827) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2119 = "llvm.load"(%1828) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2120 = "llvm.load"(%1829) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2121 = "llvm.load"(%1830) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2122 = "llvm.load"(%1831) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1831) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1830) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1829) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1828) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1827) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1827) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1828) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1829) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1830) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1831) : (!llvm.ptr) -> ()
  "llvm.call"(%1827, %1828, %1829, %1830, %1831, %2118, %2119, %2120, %2121, %2122) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2123 = "llvm.load"(%1827) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2124 = "llvm.load"(%1828) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2125 = "llvm.load"(%1829) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2126 = "llvm.load"(%1830) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2127 = "llvm.load"(%1831) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1831) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1830) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1829) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1828) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1827) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1827) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1828) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1829) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1830) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1831) : (!llvm.ptr) -> ()
  "llvm.call"(%1827, %1828, %1829, %1830, %1831, %2123, %2124, %2125, %2126, %2127) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2128 = "llvm.load"(%1827) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2129 = "llvm.load"(%1828) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2130 = "llvm.load"(%1829) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2131 = "llvm.load"(%1830) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2132 = "llvm.load"(%1831) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1831) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1830) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1829) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1828) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1827) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1827) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1828) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1829) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1830) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1831) : (!llvm.ptr) -> ()
  "llvm.call"(%1827, %1828, %1829, %1830, %1831, %2128, %2129, %2130, %2131, %2132) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2133 = "llvm.load"(%1827) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2134 = "llvm.load"(%1828) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2135 = "llvm.load"(%1829) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2136 = "llvm.load"(%1830) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2137 = "llvm.load"(%1831) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1831) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1830) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1829) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1828) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1827) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1827) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1828) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1829) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1830) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1831) : (!llvm.ptr) -> ()
  "llvm.call"(%1827, %1828, %1829, %1830, %1831, %2133, %2134, %2135, %2136, %2137) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2138 = "llvm.load"(%1827) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2139 = "llvm.load"(%1828) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2140 = "llvm.load"(%1829) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2141 = "llvm.load"(%1830) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2142 = "llvm.load"(%1831) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1831) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1830) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1829) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1828) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1827) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1827) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1828) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1829) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1830) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1831) : (!llvm.ptr) -> ()
  "llvm.call"(%1827, %1828, %1829, %1830, %1831, %2138, %2139, %2140, %2141, %2142) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2143 = "llvm.load"(%1827) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2144 = "llvm.load"(%1828) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2145 = "llvm.load"(%1829) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2146 = "llvm.load"(%1830) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2147 = "llvm.load"(%1831) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1831) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1830) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1829) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1828) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1827) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1832) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1833) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1834) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1835) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1836) : (!llvm.ptr) -> ()
  "llvm.call"(%1832, %1833, %1834, %1835, %1836, %2143, %2144, %2145, %2146, %2147, %2028, %2029, %2030, %2031, %2032) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2148 = "llvm.load"(%1832) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2149 = "llvm.load"(%1833) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2150 = "llvm.load"(%1834) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2151 = "llvm.load"(%1835) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2152 = "llvm.load"(%1836) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1836) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1835) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1834) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1833) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1832) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1837) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1838) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1839) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1840) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1841) : (!llvm.ptr) -> ()
  "llvm.call"(%1837, %1838, %1839, %1840, %1841, %2148, %2149, %2150, %2151, %2152) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2153 = "llvm.load"(%1837) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2154 = "llvm.load"(%1838) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2155 = "llvm.load"(%1839) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2156 = "llvm.load"(%1840) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2157 = "llvm.load"(%1841) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1841) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1840) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1839) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1838) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1837) : (!llvm.ptr) -> ()
  "llvm.br"(%1723, %2157, %2156, %2155, %2154, %2153)[^bb5] : (i32, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb3(%2158: i32, %2159: vector<4xi64>, %2160: vector<4xi64>, %2161: vector<4xi64>, %2162: vector<4xi64>, %2163: vector<4xi64>):  // 2 preds: ^bb1, ^bb3
  "llvm.intr.lifetime.start"(%1812) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1813) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1814) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1815) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1816) : (!llvm.ptr) -> ()
  "llvm.call"(%1812, %1813, %1814, %1815, %1816, %2163, %2162, %2161, %2160, %2159) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2164 = "llvm.load"(%1812) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2165 = "llvm.load"(%1813) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2166 = "llvm.load"(%1814) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2167 = "llvm.load"(%1815) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2168 = "llvm.load"(%1816) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1816) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1815) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1814) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1813) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1812) : (!llvm.ptr) -> ()
  %2169 = "llvm.add"(%2158, %1723) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %2170 = "llvm.icmp"(%2169, %1731) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2170, %2169, %2168, %2167, %2166, %2165, %2164)[^bb2, ^bb3] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 6>}> : (i1, i32, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb4:  // pred: ^bb5
  "llvm.intr.lifetime.start"(%1847) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1848) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1849) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1850) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1851) : (!llvm.ptr) -> ()
  "llvm.call"(%1847, %1848, %1849, %1850, %1851, %2187, %2188, %2189, %2190, %2191, %2148, %2149, %2150, %2151, %2152) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2171 = "llvm.load"(%1847) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2172 = "llvm.load"(%1848) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2173 = "llvm.load"(%1849) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2174 = "llvm.load"(%1850) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2175 = "llvm.load"(%1851) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1851) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1850) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1849) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1848) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1847) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1852) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1853) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1854) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1855) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1856) : (!llvm.ptr) -> ()
  "llvm.call"(%1852, %1853, %1854, %1855, %1856, %2171, %2172, %2173, %2174, %2175) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2176 = "llvm.load"(%1852) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2177 = "llvm.load"(%1853) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2178 = "llvm.load"(%1854) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2179 = "llvm.load"(%1855) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2180 = "llvm.load"(%1856) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1856) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1855) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1854) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1853) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1852) : (!llvm.ptr) -> ()
  "llvm.br"(%1723, %2180, %2179, %2178, %2177, %2176)[^bb7] : (i32, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb5(%2181: i32, %2182: vector<4xi64>, %2183: vector<4xi64>, %2184: vector<4xi64>, %2185: vector<4xi64>, %2186: vector<4xi64>):  // 2 preds: ^bb2, ^bb5
  "llvm.intr.lifetime.start"(%1842) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1843) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1844) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1845) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1846) : (!llvm.ptr) -> ()
  "llvm.call"(%1842, %1843, %1844, %1845, %1846, %2186, %2185, %2184, %2183, %2182) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2187 = "llvm.load"(%1842) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2188 = "llvm.load"(%1843) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2189 = "llvm.load"(%1844) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2190 = "llvm.load"(%1845) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2191 = "llvm.load"(%1846) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1846) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1845) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1844) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1843) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1842) : (!llvm.ptr) -> ()
  %2192 = "llvm.add"(%2181, %1723) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %2193 = "llvm.icmp"(%2192, %1732) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2193, %2192, %2191, %2190, %2189, %2188, %2187)[^bb4, ^bb5] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 6>}> : (i1, i32, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb6:  // pred: ^bb7
  "llvm.intr.lifetime.start"(%1862) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1863) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1864) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1865) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1866) : (!llvm.ptr) -> ()
  "llvm.call"(%1862, %1863, %1864, %1865, %1866, %2210, %2211, %2212, %2213, %2214, %2171, %2172, %2173, %2174, %2175) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2194 = "llvm.load"(%1862) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2195 = "llvm.load"(%1863) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2196 = "llvm.load"(%1864) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2197 = "llvm.load"(%1865) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2198 = "llvm.load"(%1866) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1866) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1865) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1864) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1863) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1862) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1867) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1868) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1869) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1870) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1871) : (!llvm.ptr) -> ()
  "llvm.call"(%1867, %1868, %1869, %1870, %1871, %2194, %2195, %2196, %2197, %2198) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2199 = "llvm.load"(%1867) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2200 = "llvm.load"(%1868) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2201 = "llvm.load"(%1869) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2202 = "llvm.load"(%1870) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2203 = "llvm.load"(%1871) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1871) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1870) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1869) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1868) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1867) : (!llvm.ptr) -> ()
  "llvm.br"(%1723, %2203, %2202, %2201, %2200, %2199)[^bb9] : (i32, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb7(%2204: i32, %2205: vector<4xi64>, %2206: vector<4xi64>, %2207: vector<4xi64>, %2208: vector<4xi64>, %2209: vector<4xi64>):  // 2 preds: ^bb4, ^bb7
  "llvm.intr.lifetime.start"(%1857) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1858) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1859) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1860) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1861) : (!llvm.ptr) -> ()
  "llvm.call"(%1857, %1858, %1859, %1860, %1861, %2209, %2208, %2207, %2206, %2205) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2210 = "llvm.load"(%1857) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2211 = "llvm.load"(%1858) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2212 = "llvm.load"(%1859) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2213 = "llvm.load"(%1860) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2214 = "llvm.load"(%1861) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1861) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1860) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1859) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1858) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1857) : (!llvm.ptr) -> ()
  %2215 = "llvm.add"(%2204, %1723) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %2216 = "llvm.icmp"(%2215, %1733) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2216, %2215, %2214, %2213, %2212, %2211, %2210)[^bb6, ^bb7] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 6>}> : (i1, i32, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb8:  // pred: ^bb9
  "llvm.intr.lifetime.start"(%1877) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1878) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1879) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1880) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1881) : (!llvm.ptr) -> ()
  "llvm.call"(%1877, %1878, %1879, %1880, %1881, %2278, %2279, %2280, %2281, %2282, %2148, %2149, %2150, %2151, %2152) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2217 = "llvm.load"(%1877) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2218 = "llvm.load"(%1878) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2219 = "llvm.load"(%1879) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2220 = "llvm.load"(%1880) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2221 = "llvm.load"(%1881) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1881) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1880) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1879) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1878) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1877) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1882) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1883) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1884) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1885) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1886) : (!llvm.ptr) -> ()
  "llvm.call"(%1882, %1883, %1884, %1885, %1886, %2217, %2218, %2219, %2220, %2221) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2222 = "llvm.load"(%1882) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2223 = "llvm.load"(%1883) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2224 = "llvm.load"(%1884) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2225 = "llvm.load"(%1885) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2226 = "llvm.load"(%1886) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1886) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1885) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1884) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1883) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1882) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1887) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1888) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1889) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1890) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1891) : (!llvm.ptr) -> ()
  "llvm.call"(%1887, %1888, %1889, %1890, %1891, %2222, %2223, %2224, %2225, %2226) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2227 = "llvm.load"(%1887) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2228 = "llvm.load"(%1888) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2229 = "llvm.load"(%1889) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2230 = "llvm.load"(%1890) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2231 = "llvm.load"(%1891) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1891) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1890) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1889) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1888) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1887) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1892) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1893) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1894) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1895) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1896) : (!llvm.ptr) -> ()
  "llvm.call"(%1892, %1893, %1894, %1895, %1896, %2227, %2228, %2229, %2230, %2231, %1963, %1964, %1965, %1966, %1967) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2232 = "llvm.load"(%1892) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2233 = "llvm.load"(%1893) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2234 = "llvm.load"(%1894) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2235 = "llvm.load"(%1895) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2236 = "llvm.load"(%1896) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1896) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1895) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1894) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1893) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1892) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1897) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1898) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1899) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1900) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1901) : (!llvm.ptr) -> ()
  "llvm.call"(%1897, %1898, %1899, %1900, %1901, %2232, %2233, %2234, %2235, %2236) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2237 = "llvm.load"(%1897) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2238 = "llvm.load"(%1898) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2239 = "llvm.load"(%1899) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2240 = "llvm.load"(%1900) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2241 = "llvm.load"(%1901) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1901) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1900) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1899) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1898) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1897) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1902) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1903) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1904) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1905) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1906) : (!llvm.ptr) -> ()
  "llvm.call"(%1902, %1903, %1904, %1905, %1906, %2237, %2238, %2239, %2240, %2241) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2242 = "llvm.load"(%1902) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2243 = "llvm.load"(%1903) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2244 = "llvm.load"(%1904) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2245 = "llvm.load"(%1905) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2246 = "llvm.load"(%1906) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1906) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1905) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1904) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1903) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1902) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1907) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1908) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1909) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1910) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1911) : (!llvm.ptr) -> ()
  "llvm.call"(%1907, %1908, %1909, %1910, %1911, %2242, %2243, %2244, %2245, %2246) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2247 = "llvm.load"(%1907) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2248 = "llvm.load"(%1908) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2249 = "llvm.load"(%1909) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2250 = "llvm.load"(%1910) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2251 = "llvm.load"(%1911) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1911) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1910) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1909) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1908) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1907) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1912) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1913) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1914) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1915) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1916) : (!llvm.ptr) -> ()
  "llvm.call"(%1912, %1913, %1914, %1915, %1916, %1963, %1964, %1965, %1966, %1967) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2252 = "llvm.load"(%1912) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2253 = "llvm.load"(%1913) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2254 = "llvm.load"(%1914) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2255 = "llvm.load"(%1915) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2256 = "llvm.load"(%1916) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1916) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1915) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1914) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1913) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1912) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1917) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1918) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1919) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1920) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1921) : (!llvm.ptr) -> ()
  "llvm.call"(%1917, %1918, %1919, %1920, %1921, %2252, %2253, %2254, %2255, %2256, %1963, %1964, %1965, %1966, %1967) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2257 = "llvm.load"(%1917) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2258 = "llvm.load"(%1918) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2259 = "llvm.load"(%1919) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2260 = "llvm.load"(%1920) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2261 = "llvm.load"(%1921) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1921) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1920) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1919) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1918) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1917) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1922) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1923) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1924) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1925) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1926) : (!llvm.ptr) -> ()
  "llvm.call"(%1922, %1923, %1924, %1925, %1926, %2247, %2248, %2249, %2250, %2251, %2257, %2258, %2259, %2260, %2261) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2262 = "llvm.load"(%1922) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2263 = "llvm.load"(%1923) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2264 = "llvm.load"(%1924) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2265 = "llvm.load"(%1925) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2266 = "llvm.load"(%1926) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1926) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1925) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1924) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1923) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1922) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1927) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1928) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1929) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1930) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1931) : (!llvm.ptr) -> ()
  "llvm.call"(%1927, %1928, %1929, %1930, %1931, %1932, %1934, %1936, %1938, %1940, %2262, %2263, %2264, %2265, %2266) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2267 = "llvm.load"(%1927) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2268 = "llvm.load"(%1928) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2269 = "llvm.load"(%1929) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2270 = "llvm.load"(%1930) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2271 = "llvm.load"(%1931) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1931) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1930) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1929) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1928) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1927) : (!llvm.ptr) -> ()
  "llvm.br"(%2271, %2270, %2269, %2268, %2267)[^bb10] : (vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb9(%2272: i32, %2273: vector<4xi64>, %2274: vector<4xi64>, %2275: vector<4xi64>, %2276: vector<4xi64>, %2277: vector<4xi64>):  // 2 preds: ^bb6, ^bb9
  "llvm.intr.lifetime.start"(%1872) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1873) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1874) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1875) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1876) : (!llvm.ptr) -> ()
  "llvm.call"(%1872, %1873, %1874, %1875, %1876, %2277, %2276, %2275, %2274, %2273) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2278 = "llvm.load"(%1872) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2279 = "llvm.load"(%1873) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2280 = "llvm.load"(%1874) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2281 = "llvm.load"(%1875) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2282 = "llvm.load"(%1876) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1876) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1875) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1874) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1873) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1872) : (!llvm.ptr) -> ()
  %2283 = "llvm.add"(%2272, %1723) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %2284 = "llvm.icmp"(%2283, %1732) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2284, %2283, %2282, %2281, %2280, %2279, %2278)[^bb8, ^bb9] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 6>}> : (i1, i32, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb10(%2285: vector<4xi64>, %2286: vector<4xi64>, %2287: vector<4xi64>, %2288: vector<4xi64>, %2289: vector<4xi64>):  // 2 preds: ^bb0, ^bb8
  "llvm.call"(%arg148, %2289, %2288, %2287, %2286, %2285, %1730) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_lane_canon, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 7, 0>}> : (!llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, i32) -> ()
  "llvm.call"(%arg149, %2289, %2288, %2287, %2286, %2285, %1723) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_lane_canon, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 7, 0>}> : (!llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, i32) -> ()
  "llvm.intr.lifetime.end"(%1741) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1735) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1734) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
  with @fd_r52x5_inv_propose := fd_r52x5_inv_propose,
    @fd_r52x5_limbs_is_one := fd_r52x5_limbs_is_one,
    @fd_r52x5_quad_lane_canon := fd_r52x5_quad_lane_canon, @fd_r52x5_quad_mul := fd_r52x5_quad_mul,
    @fd_r52x5_quad_sqr := fd_r52x5_quad_sqr, @wl_permute := wl_permute

end

end MLIR.Firedancer.Crc.Verify
