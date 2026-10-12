module

-- agave-build/out/serial-noinline-big/op/_RNvMs8_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldNtB5_14FieldElement518to_bytes.mlir
-- <solana_ed25519[1fe0933b11699477]::backend::serial::u64::field::FieldElement51>::to_bytes

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Agave.Serial

@[expose] public section

mlir_def FieldElement51_to_bytes :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 1 : i64, llvm.dead_on_unwind, llvm.dereferenceable = 32 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writable, llvm.writeonly}, {llvm.align = 8 : i64, llvm.dead_on_return = -1 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], sym_name = "_RNvMs8_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldNtB5_14FieldElement518to_bytes", target_cpu = "x86-64-v2", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg78: !llvm.ptr, %arg79: !llvm.ptr):
  %1880 = "llvm.mlir.constant"() <{value = 8 : i64}> : () -> i64
  %1881 = "llvm.mlir.constant"() <{value = 16 : i64}> : () -> i64
  %1882 = "llvm.mlir.constant"() <{value = 24 : i64}> : () -> i64
  %1883 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %1884 = "llvm.mlir.constant"() <{value = 51 : i64}> : () -> i64
  %1885 = "llvm.mlir.constant"() <{value = 2251799813685247 : i64}> : () -> i64
  %1886 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %1887 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %1888 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %1889 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %1890 = "llvm.mlir.constant"() <{value = 4 : i64}> : () -> i64
  %1891 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
  %1892 = "llvm.mlir.constant"() <{value = 5 : i64}> : () -> i64
  %1893 = "llvm.mlir.constant"() <{value = 48 : i64}> : () -> i64
  %1894 = "llvm.mlir.constant"() <{value = 7 : i64}> : () -> i64
  %1895 = "llvm.mlir.constant"() <{value = 6 : i64}> : () -> i64
  %1896 = "llvm.mlir.constant"() <{value = 13 : i64}> : () -> i64
  %1897 = "llvm.mlir.constant"() <{value = 21 : i64}> : () -> i64
  %1898 = "llvm.mlir.constant"() <{value = 29 : i64}> : () -> i64
  %1899 = "llvm.mlir.constant"() <{value = 10 : i64}> : () -> i64
  %1900 = "llvm.mlir.constant"() <{value = 37 : i64}> : () -> i64
  %1901 = "llvm.mlir.constant"() <{value = 45 : i64}> : () -> i64
  %1902 = "llvm.mlir.constant"() <{value = 12 : i64}> : () -> i64
  %1903 = "llvm.mlir.constant"() <{value = 18 : i64}> : () -> i64
  %1904 = "llvm.mlir.constant"() <{value = 15 : i64}> : () -> i64
  %1905 = "llvm.mlir.constant"() <{value = 26 : i64}> : () -> i64
  %1906 = "llvm.mlir.constant"() <{value = 34 : i64}> : () -> i64
  %1907 = "llvm.mlir.constant"() <{value = 42 : i64}> : () -> i64
  %1908 = "llvm.mlir.constant"() <{value = 50 : i64}> : () -> i64
  %1909 = "llvm.mlir.constant"() <{value = 20 : i64}> : () -> i64
  %1910 = "llvm.mlir.constant"() <{value = 23 : i64}> : () -> i64
  %1911 = "llvm.mlir.constant"() <{value = 31 : i64}> : () -> i64
  %1912 = "llvm.mlir.constant"() <{value = 39 : i64}> : () -> i64
  %1913 = "llvm.mlir.constant"() <{value = 47 : i64}> : () -> i64
  %1914 = "llvm.mlir.constant"() <{value = 28 : i64}> : () -> i64
  %1915 = "llvm.mlir.constant"() <{value = 36 : i64}> : () -> i64
  %1916 = "llvm.mlir.constant"() <{value = 44 : i64}> : () -> i64
  %1917 = "llvm.load"(%arg79) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1918 = "llvm.getelementptr"(%arg79) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %1919 = "llvm.load"(%1918) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1920 = "llvm.getelementptr"(%arg79) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %1921 = "llvm.load"(%1920) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1922 = "llvm.getelementptr"(%arg79) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %1923 = "llvm.load"(%1922) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1924 = "llvm.getelementptr"(%arg79) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %1925 = "llvm.load"(%1924) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1926 = "llvm.lshr"(%1917, %1884) : (i64, i64) -> i64
  %1927 = "llvm.lshr"(%1919, %1884) : (i64, i64) -> i64
  %1928 = "llvm.lshr"(%1921, %1884) : (i64, i64) -> i64
  %1929 = "llvm.lshr"(%1923, %1884) : (i64, i64) -> i64
  %1930 = "llvm.lshr"(%1925, %1884) : (i64, i64) -> i64
  %1931 = "llvm.and"(%1917, %1885) : (i64, i64) -> i64
  %1932 = "llvm.and"(%1919, %1885) : (i64, i64) -> i64
  %1933 = "llvm.and"(%1921, %1885) : (i64, i64) -> i64
  %1934 = "llvm.and"(%1923, %1885) : (i64, i64) -> i64
  %1935 = "llvm.and"(%1925, %1885) : (i64, i64) -> i64
  %1936 = "llvm.mul"(%1930, %1886) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1937 = "llvm.add"(%1936, %1931) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1938 = "llvm.add"(%1932, %1926) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1939 = "llvm.add"(%1933, %1927) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1940 = "llvm.add"(%1934, %1928) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1941 = "llvm.add"(%1935, %1929) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1942 = "llvm.add"(%1937, %1886) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1943 = "llvm.lshr"(%1942, %1884) : (i64, i64) -> i64
  %1944 = "llvm.add"(%1943, %1938) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1945 = "llvm.lshr"(%1944, %1884) : (i64, i64) -> i64
  %1946 = "llvm.add"(%1945, %1939) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1947 = "llvm.lshr"(%1946, %1884) : (i64, i64) -> i64
  %1948 = "llvm.add"(%1947, %1940) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1949 = "llvm.lshr"(%1948, %1884) : (i64, i64) -> i64
  %1950 = "llvm.add"(%1949, %1941) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1951 = "llvm.lshr"(%1950, %1884) : (i64, i64) -> i64
  %1952 = "llvm.mul"(%1951, %1886) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1953 = "llvm.add"(%1952, %1937) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1954 = "llvm.lshr"(%1953, %1884) : (i64, i64) -> i64
  %1955 = "llvm.add"(%1954, %1938) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1956 = "llvm.lshr"(%1955, %1884) : (i64, i64) -> i64
  %1957 = "llvm.add"(%1956, %1939) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1958 = "llvm.and"(%1955, %1885) : (i64, i64) -> i64
  %1959 = "llvm.lshr"(%1957, %1884) : (i64, i64) -> i64
  %1960 = "llvm.add"(%1959, %1940) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1961 = "llvm.and"(%1957, %1885) : (i64, i64) -> i64
  %1962 = "llvm.lshr"(%1960, %1884) : (i64, i64) -> i64
  %1963 = "llvm.add"(%1962, %1941) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1964 = "llvm.and"(%1960, %1885) : (i64, i64) -> i64
  %1965 = "llvm.and"(%1963, %1885) : (i64, i64) -> i64
  %1966 = "llvm.trunc"(%1953) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%1966, %arg78) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1967 = "llvm.lshr"(%1953, %1880) : (i64, i64) -> i64
  %1968 = "llvm.getelementptr"(%arg78) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1>}> : (!llvm.ptr) -> !llvm.ptr
  %1969 = "llvm.trunc"(%1967) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%1969, %1968) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1970 = "llvm.lshr"(%1953, %1881) : (i64, i64) -> i64
  %1971 = "llvm.getelementptr"(%arg78) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2>}> : (!llvm.ptr) -> !llvm.ptr
  %1972 = "llvm.trunc"(%1970) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%1972, %1971) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1973 = "llvm.lshr"(%1953, %1882) : (i64, i64) -> i64
  %1974 = "llvm.getelementptr"(%arg78) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 3>}> : (!llvm.ptr) -> !llvm.ptr
  %1975 = "llvm.trunc"(%1973) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%1975, %1974) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1976 = "llvm.lshr"(%1953, %1883) : (i64, i64) -> i64
  %1977 = "llvm.getelementptr"(%arg78) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4>}> : (!llvm.ptr) -> !llvm.ptr
  %1978 = "llvm.trunc"(%1976) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%1978, %1977) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1979 = "llvm.lshr"(%1953, %1891) : (i64, i64) -> i64
  %1980 = "llvm.getelementptr"(%arg78) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 5>}> : (!llvm.ptr) -> !llvm.ptr
  %1981 = "llvm.trunc"(%1979) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%1981, %1980) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1982 = "llvm.lshr"(%1953, %1893) : (i64, i64) -> i64
  %1983 = "llvm.and"(%1982, %1894) : (i64, i64) -> i64
  %1984 = "llvm.shl"(%1958, %1889) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1985 = "llvm.or"(%1984, %1983) <{isDisjoint}> : (i64, i64) -> i64
  %1986 = "llvm.getelementptr"(%arg78) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6>}> : (!llvm.ptr) -> !llvm.ptr
  %1987 = "llvm.trunc"(%1985) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%1987, %1986) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1988 = "llvm.lshr"(%1955, %1892) : (i64, i64) -> i64
  %1989 = "llvm.getelementptr"(%arg78) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 7>}> : (!llvm.ptr) -> !llvm.ptr
  %1990 = "llvm.trunc"(%1988) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%1990, %1989) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1991 = "llvm.lshr"(%1955, %1896) : (i64, i64) -> i64
  %1992 = "llvm.getelementptr"(%arg78) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %1993 = "llvm.trunc"(%1991) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%1993, %1992) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1994 = "llvm.lshr"(%1955, %1897) : (i64, i64) -> i64
  %1995 = "llvm.getelementptr"(%arg78) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 9>}> : (!llvm.ptr) -> !llvm.ptr
  %1996 = "llvm.trunc"(%1994) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%1996, %1995) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1997 = "llvm.lshr"(%1955, %1898) : (i64, i64) -> i64
  %1998 = "llvm.getelementptr"(%arg78) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 10>}> : (!llvm.ptr) -> !llvm.ptr
  %1999 = "llvm.trunc"(%1997) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%1999, %1998) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2000 = "llvm.lshr"(%1955, %1900) : (i64, i64) -> i64
  %2001 = "llvm.getelementptr"(%arg78) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 11>}> : (!llvm.ptr) -> !llvm.ptr
  %2002 = "llvm.trunc"(%2000) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2002, %2001) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2003 = "llvm.lshr"(%1958, %1901) : (i64, i64) -> i64
  %2004 = "llvm.shl"(%1961, %1895) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2005 = "llvm.or"(%2004, %2003) <{isDisjoint}> : (i64, i64) -> i64
  %2006 = "llvm.getelementptr"(%arg78) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 12>}> : (!llvm.ptr) -> !llvm.ptr
  %2007 = "llvm.trunc"(%2005) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2007, %2006) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2008 = "llvm.lshr"(%1957, %1888) : (i64, i64) -> i64
  %2009 = "llvm.getelementptr"(%arg78) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 13>}> : (!llvm.ptr) -> !llvm.ptr
  %2010 = "llvm.trunc"(%2008) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2010, %2009) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2011 = "llvm.lshr"(%1957, %1899) : (i64, i64) -> i64
  %2012 = "llvm.getelementptr"(%arg78) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 14>}> : (!llvm.ptr) -> !llvm.ptr
  %2013 = "llvm.trunc"(%2011) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2013, %2012) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2014 = "llvm.lshr"(%1957, %1903) : (i64, i64) -> i64
  %2015 = "llvm.getelementptr"(%arg78) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 15>}> : (!llvm.ptr) -> !llvm.ptr
  %2016 = "llvm.trunc"(%2014) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2016, %2015) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2017 = "llvm.lshr"(%1957, %1905) : (i64, i64) -> i64
  %2018 = "llvm.getelementptr"(%arg78) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %2019 = "llvm.trunc"(%2017) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2019, %2018) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2020 = "llvm.lshr"(%1957, %1906) : (i64, i64) -> i64
  %2021 = "llvm.getelementptr"(%arg78) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 17>}> : (!llvm.ptr) -> !llvm.ptr
  %2022 = "llvm.trunc"(%2020) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2022, %2021) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2023 = "llvm.lshr"(%1957, %1907) : (i64, i64) -> i64
  %2024 = "llvm.getelementptr"(%arg78) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 18>}> : (!llvm.ptr) -> !llvm.ptr
  %2025 = "llvm.trunc"(%2023) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2025, %2024) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2026 = "llvm.lshr"(%1961, %1908) : (i64, i64) -> i64
  %2027 = "llvm.shl"(%1964, %1887) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2028 = "llvm.or"(%2027, %2026) <{isDisjoint}> : (i64, i64) -> i64
  %2029 = "llvm.getelementptr"(%arg78) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 19>}> : (!llvm.ptr) -> !llvm.ptr
  %2030 = "llvm.trunc"(%2028) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2030, %2029) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2031 = "llvm.lshr"(%1960, %1894) : (i64, i64) -> i64
  %2032 = "llvm.getelementptr"(%arg78) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 20>}> : (!llvm.ptr) -> !llvm.ptr
  %2033 = "llvm.trunc"(%2031) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2033, %2032) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2034 = "llvm.lshr"(%1960, %1904) : (i64, i64) -> i64
  %2035 = "llvm.getelementptr"(%arg78) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 21>}> : (!llvm.ptr) -> !llvm.ptr
  %2036 = "llvm.trunc"(%2034) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2036, %2035) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2037 = "llvm.lshr"(%1960, %1910) : (i64, i64) -> i64
  %2038 = "llvm.getelementptr"(%arg78) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 22>}> : (!llvm.ptr) -> !llvm.ptr
  %2039 = "llvm.trunc"(%2037) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2039, %2038) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2040 = "llvm.lshr"(%1960, %1911) : (i64, i64) -> i64
  %2041 = "llvm.getelementptr"(%arg78) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 23>}> : (!llvm.ptr) -> !llvm.ptr
  %2042 = "llvm.trunc"(%2040) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2042, %2041) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2043 = "llvm.lshr"(%1960, %1912) : (i64, i64) -> i64
  %2044 = "llvm.getelementptr"(%arg78) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %2045 = "llvm.trunc"(%2043) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2045, %2044) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2046 = "llvm.lshr"(%1964, %1913) : (i64, i64) -> i64
  %2047 = "llvm.shl"(%1965, %1890) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2048 = "llvm.or"(%2047, %2046) <{isDisjoint}> : (i64, i64) -> i64
  %2049 = "llvm.getelementptr"(%arg78) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 25>}> : (!llvm.ptr) -> !llvm.ptr
  %2050 = "llvm.trunc"(%2048) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2050, %2049) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2051 = "llvm.lshr"(%1963, %1890) : (i64, i64) -> i64
  %2052 = "llvm.getelementptr"(%arg78) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 26>}> : (!llvm.ptr) -> !llvm.ptr
  %2053 = "llvm.trunc"(%2051) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2053, %2052) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2054 = "llvm.lshr"(%1963, %1902) : (i64, i64) -> i64
  %2055 = "llvm.getelementptr"(%arg78) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 27>}> : (!llvm.ptr) -> !llvm.ptr
  %2056 = "llvm.trunc"(%2054) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2056, %2055) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2057 = "llvm.lshr"(%1963, %1909) : (i64, i64) -> i64
  %2058 = "llvm.getelementptr"(%arg78) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 28>}> : (!llvm.ptr) -> !llvm.ptr
  %2059 = "llvm.trunc"(%2057) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2059, %2058) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2060 = "llvm.lshr"(%1963, %1914) : (i64, i64) -> i64
  %2061 = "llvm.getelementptr"(%arg78) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 29>}> : (!llvm.ptr) -> !llvm.ptr
  %2062 = "llvm.trunc"(%2060) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2062, %2061) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2063 = "llvm.lshr"(%1963, %1915) : (i64, i64) -> i64
  %2064 = "llvm.getelementptr"(%arg78) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 30>}> : (!llvm.ptr) -> !llvm.ptr
  %2065 = "llvm.trunc"(%2063) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2065, %2064) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2066 = "llvm.lshr"(%1965, %1916) : (i64, i64) -> i64
  %2067 = "llvm.getelementptr"(%arg78) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 31>}> : (!llvm.ptr) -> !llvm.ptr
  %2068 = "llvm.trunc"(%2066) <{overflowFlags = 3 : i32}> : (i64) -> i8
  "llvm.store"(%2068, %2067) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end MLIR.Agave.Serial
