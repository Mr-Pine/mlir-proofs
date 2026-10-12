module

-- agave-build/out/avx2-noinline-big/op/_RNvXNvXsc_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx27edwardsNtB8_11CachedPointINtNtCsgxBkk5gSRhY_4core7convert4FromNtB8_13ExtendedPointE4fromB1c_NtB2_13___Impl_from__10__impl_from.mlir
-- <solana_ed25519[c79103de3f6f5451]::backend::vector::avx2::edwards::CachedPoint as <solana_ed25519[c79103de3f6f5451]::backend::vector::avx2::edwards::CachedPoint as core[c0acaeba6ab4c2e0]::convert::From<solana_ed25519[c79103de3f6f5451]::backend::vector::avx2::edwards::ExtendedPoint>>::from::__Impl_from__>::_impl_from

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Agave.Avx2.Mlir.FieldElement2625x4_reduce64_impl_reduce64

meta import MLIR.Semantics.Func
meta import Agave.Avx2.Mlir.FieldElement2625x4_reduce64_impl_reduce64

namespace MLIR.Agave.Avx2

@[expose] public section

mlir_def CachedPoint_From_ExtendedPoint_from_impl_from :=
#alias_scope_domain66 = #llvm.alias_scope_domain<id = distinct[66]<>, description = "_RNvXNvXse_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx25fieldNtB8_18FieldElement2625x4INtNtNtCsgxBkk5gSRhY_4core3ops5arith3MulTmmmmEE3mulB1a_NtB2_12___Impl_mul__9__impl_mul">
#alias_scope94 = #llvm.alias_scope<id = distinct[223]<>, domain = #alias_scope_domain66, description = "_RNvXNvXse_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx25fieldNtB8_18FieldElement2625x4INtNtNtCsgxBkk5gSRhY_4core3ops5arith3MulTmmmmEE3mulB1a_NtB2_12___Impl_mul__9__impl_mul: argument 0">
#alias_scope95 = #llvm.alias_scope<id = distinct[224]<>, domain = #alias_scope_domain66, description = "_RNvXNvXse_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx25fieldNtB8_18FieldElement2625x4INtNtNtCsgxBkk5gSRhY_4core3ops5arith3MulTmmmmEE3mulB1a_NtB2_12___Impl_mul__9__impl_mul: argument 1">
#alias_scope96 = #llvm.alias_scope<id = distinct[225]<>, domain = #alias_scope_domain66, description = "_RNvXNvXse_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx25fieldNtB8_18FieldElement2625x4INtNtNtCsgxBkk5gSRhY_4core3ops5arith3MulTmmmmEE3mulB1a_NtB2_12___Impl_mul__9__impl_mul: argument 2">
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 32 : i64, llvm.dead_on_unwind, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writable, llvm.writeonly}, {llvm.align = 32 : i64, llvm.dead_on_return = -1 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], sym_name = "_RNvXNvXsc_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx27edwardsNtB8_11CachedPointINtNtCsgxBkk5gSRhY_4core7convert4FromNtB8_13ExtendedPointE4fromB1c_NtB2_13___Impl_from__10__impl_from", target_cpu = "x86-64-v2", target_features = #llvm.target_features<["+avx", "+avx2", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+crc32", "+ssse3", "+avx", "+avx2", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+crc32", "+ssse3"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg58: !llvm.ptr, %arg59: !llvm.ptr):
  %1809 = "llvm.mlir.undef"() : () -> vector<4xi64>
  %1810 = "llvm.mlir.poison"() : () -> i64
  %1811 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %1812 = "llvm.mlir.constant"() <{value = 127 : i32}> : () -> i32
  %1813 = "llvm.mlir.constant"() <{value = 67108863 : i32}> : () -> i32
  %1814 = "llvm.mlir.constant"() <{value = 33554431 : i32}> : () -> i32
  %1815 = "llvm.mlir.constant"() <{value = 5 : i64}> : () -> i64
  %1816 = "llvm.mlir.constant"() <{value = dense<[26, 26, 25, 25, 26, 26, 25, 25]> : vector<8xi32>}> : () -> vector<8xi32>
  %1817 = "llvm.mlir.constant"() <{value = dense<[1073741808, 1073741808, 536870896, 536870896, 1073741808, 1073741808, 536870896, 536870896]> : vector<8xi32>}> : () -> vector<8xi32>
  %1818 = "llvm.mlir.constant"() <{value = dense<[1073741520, 1073741520, 536870896, 536870896, 1073741520, 1073741520, 536870896, 536870896]> : vector<8xi32>}> : () -> vector<8xi32>
  %1819 = "llvm.mlir.constant"() <{value = dense<[121666, 121666, 243332, 243330]> : vector<4xi64>}> : () -> vector<4xi64>
  %1820 = "llvm.mlir.constant"() <{value = 134217726 : i32}> : () -> i32
  %1821 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %1822 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %1823 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %1824 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %1825 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %1826 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %1827 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1828 = "llvm.mlir.poison"() : () -> vector<8xi32>
  %1829 = "llvm.mlir.poison"() : () -> i32
  %1830 = "llvm.mlir.constant"() <{value = 67108862 : i32}> : () -> i32
  %1831 = "llvm.mlir.constant"() <{value = 134217690 : i32}> : () -> i32
  %1832 = "llvm.mlir.undef"() : () -> vector<8xi32>
  %1833 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %1834 = "llvm.insertelement"(%1832, %1831, %1833) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1835 = "llvm.insertelement"(%1834, %1829, %1827) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1836 = "llvm.insertelement"(%1835, %1830, %1826) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1837 = "llvm.insertelement"(%1836, %1829, %1825) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1838 = "llvm.insertelement"(%1837, %1829, %1824) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1839 = "llvm.insertelement"(%1838, %1829, %1823) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1840 = "llvm.insertelement"(%1839, %1829, %1822) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1841 = "llvm.insertelement"(%1840, %1829, %1821) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1842 = "llvm.insertelement"(%1832, %1820, %1833) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1843 = "llvm.insertelement"(%1842, %1829, %1827) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1844 = "llvm.insertelement"(%1843, %1830, %1826) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1845 = "llvm.insertelement"(%1844, %1829, %1825) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1846 = "llvm.insertelement"(%1845, %1829, %1824) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1847 = "llvm.insertelement"(%1846, %1829, %1823) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1848 = "llvm.insertelement"(%1847, %1829, %1822) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1849 = "llvm.insertelement"(%1848, %1829, %1821) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1850 = "llvm.insertelement"(%1832, %1833, %1833) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1851 = "llvm.insertelement"(%1850, %1833, %1827) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1852 = "llvm.insertelement"(%1851, %1829, %1826) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1853 = "llvm.insertelement"(%1852, %1829, %1825) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1854 = "llvm.insertelement"(%1853, %1833, %1824) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1855 = "llvm.insertelement"(%1854, %1833, %1823) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1856 = "llvm.insertelement"(%1855, %1829, %1822) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1857 = "llvm.insertelement"(%1856, %1829, %1821) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1858 = "llvm.insertelement"(%1832, %1829, %1833) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1859 = "llvm.insertelement"(%1858, %1829, %1827) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1860 = "llvm.insertelement"(%1859, %1833, %1826) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1861 = "llvm.insertelement"(%1860, %1833, %1825) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1862 = "llvm.insertelement"(%1861, %1829, %1824) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1863 = "llvm.insertelement"(%1862, %1829, %1823) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1864 = "llvm.insertelement"(%1863, %1833, %1822) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1865 = "llvm.insertelement"(%1864, %1833, %1821) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1866 = "llvm.insertelement"(%1832, %1829, %1833) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1867 = "llvm.insertelement"(%1866, %1829, %1827) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1868 = "llvm.insertelement"(%1867, %1829, %1826) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1869 = "llvm.insertelement"(%1868, %1829, %1825) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1870 = "llvm.insertelement"(%1869, %1829, %1824) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1871 = "llvm.insertelement"(%1870, %1813, %1823) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1872 = "llvm.insertelement"(%1871, %1829, %1822) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1873 = "llvm.insertelement"(%1872, %1814, %1821) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1874 = "llvm.insertelement"(%1832, %1829, %1833) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1875 = "llvm.insertelement"(%1874, %1829, %1827) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1876 = "llvm.insertelement"(%1875, %1829, %1826) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1877 = "llvm.insertelement"(%1876, %1829, %1825) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1878 = "llvm.insertelement"(%1877, %1829, %1824) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1879 = "llvm.insertelement"(%1878, %1833, %1823) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1880 = "llvm.insertelement"(%1879, %1829, %1822) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1881 = "llvm.insertelement"(%1880, %1812, %1821) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1882 = "llvm.insertelement"(%1809, %1810, %1833) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %1883 = "llvm.insertelement"(%1882, %1810, %1827) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %1884 = "llvm.insertelement"(%1883, %1810, %1826) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %1885 = "llvm.insertelement"(%1884, %1811, %1825) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %1886 = "llvm.alloca"(%1827) <{alignment = 32 : i64, elem_type = !llvm.array<320 x i8>}> : (i32) -> !llvm.ptr
  %1887 = "llvm.alloca"(%1827) <{alignment = 32 : i64, elem_type = !llvm.array<160 x i8>}> : (i32) -> !llvm.ptr
  %1888 = "llvm.load"(%arg59) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %1889 = "llvm.getelementptr"(%arg59) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %1890 = "llvm.load"(%1889) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %1891 = "llvm.getelementptr"(%arg59) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %1892 = "llvm.load"(%1891) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %1893 = "llvm.getelementptr"(%arg59) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %1894 = "llvm.load"(%1893) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %1895 = "llvm.getelementptr"(%arg59) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %1896 = "llvm.load"(%1895) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %1897 = "llvm.shufflevector"(%1888, %1828) <{mask = array<i32: 1, 0, 3, 2, -1, -1, -1, -1>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1898 = "llvm.shufflevector"(%1890, %1828) <{mask = array<i32: 1, 0, 3, 2, -1, -1, -1, -1>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1899 = "llvm.shufflevector"(%1892, %1828) <{mask = array<i32: 1, 0, 3, 2, -1, -1, -1, -1>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1900 = "llvm.shufflevector"(%1894, %1828) <{mask = array<i32: 1, 0, 3, 2, -1, -1, -1, -1>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1901 = "llvm.shufflevector"(%1896, %1828) <{mask = array<i32: 1, 0, 3, 2, -1, -1, -1, -1>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1902 = "llvm.sub"(%1841, %1888) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1903 = "llvm.sub"(%1849, %1890) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1904 = "llvm.sub"(%1849, %1892) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1905 = "llvm.sub"(%1849, %1894) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1906 = "llvm.sub"(%1849, %1896) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1907 = "llvm.shufflevector"(%1902, %1888) <{mask = array<i32: 0, 9, 2, 11, -1, -1, -1, -1>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1908 = "llvm.shufflevector"(%1903, %1890) <{mask = array<i32: 0, 9, 2, 11, -1, -1, -1, -1>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1909 = "llvm.shufflevector"(%1904, %1892) <{mask = array<i32: 0, 9, 2, 11, -1, -1, -1, -1>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1910 = "llvm.shufflevector"(%1905, %1894) <{mask = array<i32: 0, 9, 2, 11, -1, -1, -1, -1>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1911 = "llvm.shufflevector"(%1906, %1896) <{mask = array<i32: 0, 9, 2, 11, -1, -1, -1, -1>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1912 = "llvm.add"(%1907, %1897) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1913 = "llvm.add"(%1908, %1898) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1914 = "llvm.add"(%1909, %1899) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1915 = "llvm.add"(%1910, %1900) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1916 = "llvm.add"(%1911, %1901) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1917 = "llvm.shufflevector"(%1912, %1888) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1918 = "llvm.shufflevector"(%1913, %1890) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1919 = "llvm.shufflevector"(%1914, %1892) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1920 = "llvm.shufflevector"(%1915, %1894) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1921 = "llvm.shufflevector"(%1916, %1896) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  "llvm.intr.lifetime.start"(%1887) : (!llvm.ptr) -> ()
  %1922 = "llvm.shufflevector"(%1917, %1857) <{mask = array<i32: 0, 8, 1, 9, 4, 12, 5, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1923 = "llvm.shufflevector"(%1917, %1865) <{mask = array<i32: 2, 10, 3, 11, 6, 14, 7, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1924 = "llvm.bitcast"(%1922) : (vector<8xi32>) -> vector<4xi64>
  %1925 = "llvm.bitcast"(%1923) : (vector<8xi32>) -> vector<4xi64>
  %1926 = "llvm.shufflevector"(%1918, %1857) <{mask = array<i32: 0, 8, 1, 9, 4, 12, 5, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1927 = "llvm.shufflevector"(%1918, %1865) <{mask = array<i32: 2, 10, 3, 11, 6, 14, 7, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1928 = "llvm.bitcast"(%1926) : (vector<8xi32>) -> vector<4xi64>
  %1929 = "llvm.bitcast"(%1927) : (vector<8xi32>) -> vector<4xi64>
  %1930 = "llvm.shufflevector"(%1919, %1857) <{mask = array<i32: 0, 8, 1, 9, 4, 12, 5, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1931 = "llvm.shufflevector"(%1919, %1865) <{mask = array<i32: 2, 10, 3, 11, 6, 14, 7, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1932 = "llvm.bitcast"(%1930) : (vector<8xi32>) -> vector<4xi64>
  %1933 = "llvm.bitcast"(%1931) : (vector<8xi32>) -> vector<4xi64>
  %1934 = "llvm.shufflevector"(%1920, %1857) <{mask = array<i32: 0, 8, 1, 9, 4, 12, 5, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1935 = "llvm.shufflevector"(%1920, %1865) <{mask = array<i32: 2, 10, 3, 11, 6, 14, 7, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1936 = "llvm.bitcast"(%1934) : (vector<8xi32>) -> vector<4xi64>
  %1937 = "llvm.bitcast"(%1935) : (vector<8xi32>) -> vector<4xi64>
  %1938 = "llvm.shufflevector"(%1921, %1857) <{mask = array<i32: 0, 8, 1, 9, 4, 12, 5, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1939 = "llvm.shufflevector"(%1921, %1865) <{mask = array<i32: 2, 10, 3, 11, 6, 14, 7, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1940 = "llvm.bitcast"(%1938) : (vector<8xi32>) -> vector<4xi64>
  %1941 = "llvm.bitcast"(%1939) : (vector<8xi32>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%1886) : (!llvm.ptr) -> ()
  %1942 = "llvm.mul"(%1924, %1819) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1943 = "llvm.mul"(%1925, %1819) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1944 = "llvm.mul"(%1928, %1819) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1945 = "llvm.mul"(%1929, %1819) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1946 = "llvm.mul"(%1932, %1819) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1947 = "llvm.mul"(%1933, %1819) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1948 = "llvm.mul"(%1936, %1819) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1949 = "llvm.mul"(%1937, %1819) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1950 = "llvm.mul"(%1940, %1819) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1951 = "llvm.mul"(%1941, %1819) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.store"(%1942, %1886) <{alignment = 32 : i64, noalias_scopes = [#alias_scope94, #alias_scope95, #alias_scope96], ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %1952 = "llvm.getelementptr"(%1886) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1943, %1952) <{alignment = 32 : i64, noalias_scopes = [#alias_scope94, #alias_scope95, #alias_scope96], ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %1953 = "llvm.getelementptr"(%1886) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1944, %1953) <{alignment = 32 : i64, noalias_scopes = [#alias_scope94, #alias_scope95, #alias_scope96], ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %1954 = "llvm.getelementptr"(%1886) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1945, %1954) <{alignment = 32 : i64, noalias_scopes = [#alias_scope94, #alias_scope95, #alias_scope96], ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %1955 = "llvm.getelementptr"(%1886) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1946, %1955) <{alignment = 32 : i64, noalias_scopes = [#alias_scope94, #alias_scope95, #alias_scope96], ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %1956 = "llvm.getelementptr"(%1886) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 160>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1947, %1956) <{alignment = 32 : i64, noalias_scopes = [#alias_scope94, #alias_scope95, #alias_scope96], ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %1957 = "llvm.getelementptr"(%1886) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 192>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1948, %1957) <{alignment = 32 : i64, noalias_scopes = [#alias_scope94, #alias_scope95, #alias_scope96], ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %1958 = "llvm.getelementptr"(%1886) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 224>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1949, %1958) <{alignment = 32 : i64, noalias_scopes = [#alias_scope94, #alias_scope95, #alias_scope96], ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %1959 = "llvm.getelementptr"(%1886) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 256>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1950, %1959) <{alignment = 32 : i64, noalias_scopes = [#alias_scope94, #alias_scope95, #alias_scope96], ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %1960 = "llvm.getelementptr"(%1886) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 288>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1951, %1960) <{alignment = 32 : i64, noalias_scopes = [#alias_scope94, #alias_scope95, #alias_scope96], ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.call"(%1887, %1886) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 32 : i64, llvm.dereferenceable = 320 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef}], callee = @_RNvXNvMsb_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx25fieldNtB8_18FieldElement2625x48reduce64B1a_NtB2_17___Impl_reduce64__14__impl_reduce64, fastmathFlags = #llvm.fastmath<none>, inline_hint, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope95, #alias_scope96], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1886) : (!llvm.ptr) -> ()
  %1961 = "llvm.load"(%1887) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %1962 = "llvm.getelementptr"(%1887) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %1963 = "llvm.load"(%1962) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %1964 = "llvm.getelementptr"(%1887) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %1965 = "llvm.load"(%1964) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %1966 = "llvm.getelementptr"(%1887) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %1967 = "llvm.load"(%1966) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %1968 = "llvm.getelementptr"(%1887) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %1969 = "llvm.load"(%1968) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  "llvm.intr.lifetime.end"(%1887) : (!llvm.ptr) -> ()
  %1970 = "llvm.sub"(%1818, %1961) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1971 = "llvm.sub"(%1817, %1963) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1972 = "llvm.sub"(%1817, %1965) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1973 = "llvm.sub"(%1817, %1967) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1974 = "llvm.sub"(%1817, %1969) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1975 = "llvm.lshr"(%1970, %1816) : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1976 = "llvm.shufflevector"(%1975, %1828) <{mask = array<i32: -1, -1, -1, -1, -1, -1, -1, 5>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1977 = "llvm.insertelement"(%1976, %1833, %1815) : (vector<8xi32>, i32, i64) -> vector<8xi32>
  %1978 = "llvm.and"(%1970, %1873) : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1979 = "llvm.add"(%1977, %1978) <{overflowFlags = 3 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1980 = "llvm.lshr"(%1971, %1816) : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1981 = "llvm.shufflevector"(%1975, %1980) <{mask = array<i32: -1, -1, -1, -1, -1, 7, -1, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1982 = "llvm.and"(%1971, %1873) : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1983 = "llvm.add"(%1981, %1982) <{overflowFlags = 3 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1984 = "llvm.lshr"(%1972, %1816) : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1985 = "llvm.shufflevector"(%1980, %1984) <{mask = array<i32: -1, -1, -1, -1, -1, 7, -1, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1986 = "llvm.and"(%1972, %1873) : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1987 = "llvm.add"(%1985, %1986) <{overflowFlags = 3 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1988 = "llvm.lshr"(%1973, %1816) : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1989 = "llvm.shufflevector"(%1984, %1988) <{mask = array<i32: -1, -1, -1, -1, -1, 7, -1, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1990 = "llvm.and"(%1973, %1873) : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1991 = "llvm.add"(%1989, %1990) <{overflowFlags = 3 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1992 = "llvm.lshr"(%1974, %1816) : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1993 = "llvm.shufflevector"(%1988, %1992) <{mask = array<i32: -1, -1, -1, -1, -1, 7, -1, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1994 = "llvm.and"(%1974, %1873) : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1995 = "llvm.add"(%1993, %1994) <{overflowFlags = 3 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1996 = "llvm.and"(%1992, %1881) : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1997 = "llvm.shufflevector"(%1996, %1828) <{mask = array<i32: -1, -1, -1, -1, -1, -1, 7, 5>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1998 = "llvm.bitcast"(%1997) : (vector<8xi32>) -> vector<4xi64>
  %1999 = "llvm.mul"(%1998, %1885) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2000 = "llvm.bitcast"(%1999) : (vector<4xi64>) -> vector<8xi32>
  %2001 = "llvm.shufflevector"(%2000, %1828) <{mask = array<i32: -1, -1, -1, -1, -1, 6, -1, 7>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %2002 = "llvm.add"(%1979, %2001) <{overflowFlags = 3 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %2003 = "llvm.shufflevector"(%1961, %2002) <{mask = array<i32: 0, 1, 2, 3, 4, 13, 6, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %2004 = "llvm.shufflevector"(%1963, %1983) <{mask = array<i32: 0, 1, 2, 3, 4, 13, 6, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %2005 = "llvm.shufflevector"(%1965, %1987) <{mask = array<i32: 0, 1, 2, 3, 4, 13, 6, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %2006 = "llvm.shufflevector"(%1967, %1991) <{mask = array<i32: 0, 1, 2, 3, 4, 13, 6, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %2007 = "llvm.shufflevector"(%1969, %1995) <{mask = array<i32: 0, 1, 2, 3, 4, 13, 6, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  "llvm.store"(%2003, %arg58) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  %2008 = "llvm.getelementptr"(%arg58) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2004, %2008) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  %2009 = "llvm.getelementptr"(%arg58) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2005, %2009) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  %2010 = "llvm.getelementptr"(%arg58) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2006, %2010) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  %2011 = "llvm.getelementptr"(%arg58) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2007, %2011) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
  with
    @_RNvXNvMsb_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx25fieldNtB8_18FieldElement2625x48reduce64B1a_NtB2_17___Impl_reduce64__14__impl_reduce64 := FieldElement2625x4_reduce64_impl_reduce64

end

end MLIR.Agave.Avx2
