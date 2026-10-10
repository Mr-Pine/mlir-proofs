module

-- agave-build/out/avx2-noinline/op/_RNvMs2_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar523sub.mlir
-- <solana_ed25519[c79103de3f6f5451]::backend::serial::u64::scalar::Scalar52>::sub

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Agave.Avx2.Mlir.black_box_u8

meta import MLIR.Semantics.Func
meta import Agave.Avx2.Mlir.black_box_u8

namespace MLIR.Agave.Avx2

@[expose] public section

mlir_def Scalar52_sub :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 8 : i64, llvm.dead_on_unwind, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writable, llvm.writeonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], sym_name = "_RNvMs2_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar523sub", target_cpu = "x86-64-v2", target_features = #llvm.target_features<["+avx", "+avx2", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+crc32", "+ssse3"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg39: !llvm.ptr, %arg40: !llvm.ptr):
  %1850 = "llvm.mlir.constant"() <{value = -671914833335277 : i64}> : () -> i64
  %1851 = "llvm.mlir.constant"() <{value = 4503599627370495 : i64}> : () -> i64
  %1852 = "llvm.mlir.constant"() <{value = 63 : i64}> : () -> i64
  %1853 = "llvm.mlir.constant"() <{value = -3916664325105025 : i64}> : () -> i64
  %1854 = "llvm.mlir.constant"() <{value = -1367801 : i64}> : () -> i64
  %1855 = "llvm.mlir.constant"() <{value = -17592186044416 : i64}> : () -> i64
  %1856 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %1857 = "llvm.mlir.constant"() <{value = 671914833335277 : i64}> : () -> i64
  %1858 = "llvm.mlir.constant"() <{value = 3916664325105025 : i64}> : () -> i64
  %1859 = "llvm.mlir.constant"() <{value = 52 : i64}> : () -> i64
  %1860 = "llvm.mlir.constant"() <{value = 1367801 : i64}> : () -> i64
  %1861 = "llvm.mlir.constant"() <{value = 17592186044416 : i64}> : () -> i64
  %1862 = "llvm.load"(%arg40) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1863 = "llvm.add"(%1862, %1850) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1864 = "llvm.and"(%1863, %1851) : (i64, i64) -> i64
  %1865 = "llvm.getelementptr"(%arg40) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %1866 = "llvm.load"(%1865) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1867 = "llvm.ashr"(%1863, %1852) : (i64, i64) -> i64
  %1868 = "llvm.add"(%1866, %1867) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1869 = "llvm.add"(%1868, %1853) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1870 = "llvm.and"(%1869, %1851) : (i64, i64) -> i64
  %1871 = "llvm.getelementptr"(%arg40) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %1872 = "llvm.load"(%1871) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1873 = "llvm.ashr"(%1869, %1852) : (i64, i64) -> i64
  %1874 = "llvm.add"(%1872, %1873) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1875 = "llvm.add"(%1874, %1854) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1876 = "llvm.and"(%1875, %1851) : (i64, i64) -> i64
  %1877 = "llvm.getelementptr"(%arg40) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %1878 = "llvm.load"(%1877) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1879 = "llvm.ashr"(%1875, %1852) : (i64, i64) -> i64
  %1880 = "llvm.add"(%1878, %1879) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1881 = "llvm.and"(%1880, %1851) : (i64, i64) -> i64
  %1882 = "llvm.getelementptr"(%arg40) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %1883 = "llvm.load"(%1882) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1884 = "llvm.ashr"(%1880, %1852) : (i64, i64) -> i64
  %1885 = "llvm.add"(%1883, %1884) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1886 = "llvm.add"(%1885, %1855) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1887 = "llvm.lshr"(%1886, %1852) : (i64, i64) -> i64
  %1888 = "llvm.trunc"(%1887) <{overflowFlags = 3 : i32}> : (i64) -> i8
  %1889 = "llvm.call"(%1888) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %1890 = "llvm.zext"(%1889) : (i8) -> i64
  %1891 = "llvm.sub"(%1856, %1890) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1892 = "llvm.and"(%1891, %1857) : (i64, i64) -> i64
  %1893 = "llvm.add"(%1864, %1892) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1894 = "llvm.and"(%1893, %1851) : (i64, i64) -> i64
  %1895 = "llvm.and"(%1891, %1858) : (i64, i64) -> i64
  %1896 = "llvm.lshr"(%1893, %1859) : (i64, i64) -> i64
  %1897 = "llvm.add"(%1870, %1896) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1898 = "llvm.add"(%1897, %1895) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1899 = "llvm.and"(%1898, %1851) : (i64, i64) -> i64
  %1900 = "llvm.and"(%1891, %1860) : (i64, i64) -> i64
  %1901 = "llvm.lshr"(%1898, %1859) : (i64, i64) -> i64
  %1902 = "llvm.add"(%1876, %1901) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1903 = "llvm.add"(%1902, %1900) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1904 = "llvm.and"(%1903, %1851) : (i64, i64) -> i64
  %1905 = "llvm.lshr"(%1903, %1859) : (i64, i64) -> i64
  %1906 = "llvm.add"(%1881, %1905) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1907 = "llvm.and"(%1906, %1851) : (i64, i64) -> i64
  %1908 = "llvm.and"(%1891, %1861) : (i64, i64) -> i64
  %1909 = "llvm.lshr"(%1906, %1859) : (i64, i64) -> i64
  %1910 = "llvm.add"(%1886, %1909) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1911 = "llvm.add"(%1910, %1908) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1912 = "llvm.and"(%1911, %1851) : (i64, i64) -> i64
  "llvm.store"(%1894, %arg39) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1913 = "llvm.getelementptr"(%arg39) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1899, %1913) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1914 = "llvm.getelementptr"(%arg39) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1904, %1914) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1915 = "llvm.getelementptr"(%arg39) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1907, %1915) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1916 = "llvm.getelementptr"(%arg39) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1912, %1916) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
  with @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519 := black_box_u8

end

end MLIR.Agave.Avx2
