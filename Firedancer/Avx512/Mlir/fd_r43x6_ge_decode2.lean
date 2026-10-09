module

-- build/llvm23/mlir_canonicalized/avx512/op/fd_r43x6_ge_decode2.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Avx512.Mlir.fd_r43x6_diagnose
public import Firedancer.Avx512.Mlir.fd_r43x6_is_nonzero
public import Firedancer.Avx512.Mlir.fd_r43x6_mul_fast
public import Firedancer.Avx512.Mlir.fd_r43x6_pow22523_2
public import Firedancer.Avx512.Mlir.fd_r43x6_sqr_fast
public import Firedancer.Avx512.Mlir.fd_r43x6_unpack
public import Firedancer.Avx512.Mlir.wv_ld

meta import MLIR.Semantics.Func
meta import Firedancer.Avx512.Mlir.fd_r43x6_diagnose
meta import Firedancer.Avx512.Mlir.fd_r43x6_is_nonzero
meta import Firedancer.Avx512.Mlir.fd_r43x6_mul_fast
meta import Firedancer.Avx512.Mlir.fd_r43x6_pow22523_2
meta import Firedancer.Avx512.Mlir.fd_r43x6_sqr_fast
meta import Firedancer.Avx512.Mlir.fd_r43x6_unpack
meta import Firedancer.Avx512.Mlir.wv_ld

namespace MLIR.Firedancer.Avx512

@[expose] public section

mlir_def fd_r43x6_ge_decode2 :=
#tbaa_root = #llvm.tbaa_root<id = "Simple C/C++ TBAA">
#tbaa_type_desc = #llvm.tbaa_type_desc<id = "omnipotent char", members = {<#tbaa_root, 0>}>
#tbaa_tag = #llvm.tbaa_tag<base_type = #tbaa_type_desc, access_type = #tbaa_type_desc, offset = 0>
#tbaa_type_desc1 = #llvm.tbaa_type_desc<id = "long", members = {<#tbaa_type_desc, 0>}>
#tbaa_tag1 = #llvm.tbaa_tag<base_type = #tbaa_type_desc1, access_type = #tbaa_type_desc1, offset = 0>
"llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.nofree, llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<i32 (ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], res_attrs = [{llvm.range = #llvm.constant_range<i32, -2, 1>}], sym_name = "fd_r43x6_ge_decode2", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg85: !llvm.ptr, %arg86: !llvm.ptr, %arg87: !llvm.ptr, %arg88: !llvm.ptr, %arg89: !llvm.ptr, %arg90: !llvm.ptr, %arg91: !llvm.ptr, %arg92: !llvm.ptr):
  %1899 = "llvm.mlir.constant"() <{value = dense<[8796093022207, 8796093022207, 8796093022207, 8796093022207, 1099511627775, 1099511627775, 1099511627775, 1099511627775]> : vector<8xi64>}> : () -> vector<8xi64>
  %1900 = "llvm.mlir.constant"() <{value = dense<8796093022207> : vector<8xi64>}> : () -> vector<8xi64>
  %1901 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %1902 = "llvm.mlir.constant"() <{value = dense<[43, 43, 43, 43, 40, 40, 40, 40]> : vector<8xi64>}> : () -> vector<8xi64>
  %1903 = "llvm.mlir.constant"() <{value = dense<43> : vector<8xi64>}> : () -> vector<8xi64>
  %1904 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %1905 = "llvm.mlir.constant"() <{value = dense<[3467281080496, 6582290652611, 5210002954932, 329084955603, 4526638806224, 373767602335, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %1906 = "llvm.mlir.constant"() <{value = -1 : i8}> : () -> i8
  %1907 = "llvm.mlir.constant"() <{value = -2 : i32}> : () -> i32
  %1908 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
  %1909 = "llvm.mlir.constant"() <{value = dense<0> : vector<8xi64>}> : () -> vector<8xi64>
  %1910 = "llvm.mlir.constant"() <{value = dense<[8795933638637, 8796091973631, 8796091973631, 8796091973631, 8796091973631, 1099510579199, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %1911 = "llvm.mlir.constant"() <{value = dense<[1, 0, 0, 0, 0, 0, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %1912 = "llvm.mlir.constant"() <{value = dense<[6365466163363, 253762649449, 7518893317, 260847760460, 7696165686388, 704489577558, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %1913 = "llvm.mlir.constant"() <{value = dense<[159383552, 1048576, 1048576, 1048576, 1048576, 1048576, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %1914 = "llvm.mlir.constant"() <{value = dense<[-1, 0, 0, 0, 0, 0, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %1915 = "llvm.mlir.constant"() <{value = dense<18> : vector<8xi64>}> : () -> vector<8xi64>
  %1916 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %1917 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %1918 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %1919 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %1920 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %1921 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %1922 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1923 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %1924 = "llvm.mlir.constant"() <{value = 63 : i64}> : () -> i64
  %1925 = "llvm.mlir.constant"() <{value = 9223372036854775807 : i64}> : () -> i64
  %1926 = "llvm.mlir.constant"() <{value = dense<[8796093022207, 8796093022207, 8796093022207, 8796093022207, 8796093022207, 1099511627775, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %1927 = "llvm.mlir.constant"() <{value = dense<[43, 43, 43, 43, 43, 40, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %1928 = "llvm.mlir.poison"() : () -> vector<8xi64>
  %1929 = "llvm.mlir.constant"() <{value = dense<[19, 1, 1, 1, 1, 1, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %1930 = "llvm.mlir.constant"() <{value = dense<[8795933638636, 8796091973631, 8796091973631, 8796091973631, 8796091973631, 1099510579199, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %1931 = "llvm.mlir.poison"() : () -> i64
  %1932 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %1933 = "llvm.mlir.undef"() : () -> vector<8xi64>
  %1934 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %1935 = "llvm.insertelement"(%1933, %1932, %1934) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1936 = "llvm.insertelement"(%1935, %1931, %1922) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1937 = "llvm.insertelement"(%1936, %1931, %1921) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1938 = "llvm.insertelement"(%1937, %1931, %1920) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1939 = "llvm.insertelement"(%1938, %1931, %1919) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1940 = "llvm.insertelement"(%1939, %1931, %1918) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1941 = "llvm.insertelement"(%1940, %1931, %1917) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1942 = "llvm.insertelement"(%1941, %1931, %1916) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1943 = "llvm.insertelement"(%1933, %1904, %1934) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1944 = "llvm.insertelement"(%1943, %1932, %1922) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1945 = "llvm.insertelement"(%1944, %1931, %1921) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1946 = "llvm.insertelement"(%1945, %1931, %1920) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1947 = "llvm.insertelement"(%1946, %1932, %1919) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1948 = "llvm.insertelement"(%1947, %1932, %1918) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1949 = "llvm.insertelement"(%1948, %1931, %1917) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1950 = "llvm.insertelement"(%1949, %1931, %1916) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1951 = "llvm.insertelement"(%1933, %1931, %1934) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1952 = "llvm.insertelement"(%1951, %1931, %1922) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1953 = "llvm.insertelement"(%1952, %1932, %1921) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1954 = "llvm.insertelement"(%1953, %1932, %1920) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1955 = "llvm.insertelement"(%1954, %1932, %1919) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1956 = "llvm.insertelement"(%1955, %1932, %1918) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1957 = "llvm.insertelement"(%1956, %1931, %1917) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1958 = "llvm.insertelement"(%1957, %1931, %1916) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1959 = "llvm.insertelement"(%1933, %1931, %1934) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1960 = "llvm.insertelement"(%1959, %1931, %1922) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1961 = "llvm.insertelement"(%1960, %1931, %1921) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1962 = "llvm.insertelement"(%1961, %1931, %1920) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1963 = "llvm.insertelement"(%1962, %1901, %1919) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1964 = "llvm.insertelement"(%1963, %1901, %1918) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1965 = "llvm.insertelement"(%1964, %1901, %1917) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1966 = "llvm.insertelement"(%1965, %1901, %1916) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1967 = "llvm.alloca"(%1922) <{alignment = 32 : i64, elem_type = !llvm.array<4 x i64>}> : (i32) -> !llvm.ptr
  %1968 = "llvm.alloca"(%1922) <{alignment = 32 : i64, elem_type = !llvm.array<4 x i64>}> : (i32) -> !llvm.ptr
  %1969 = "llvm.alloca"(%1922) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %1970 = "llvm.alloca"(%1922) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%1967) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1968) : (!llvm.ptr) -> ()
  "llvm.intr.memcpy"(%1967, %arg88, %1923) <{arg_attrs = [{llvm.align = 32 : i64, llvm.dereferenceable = 32 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 1 : i64, llvm.dereferenceable = 32 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.intr.memcpy"(%1968, %arg92, %1923) <{arg_attrs = [{llvm.align = 32 : i64, llvm.dereferenceable = 32 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 1 : i64, llvm.dereferenceable = 32 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %1971 = "llvm.getelementptr"(%1967) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %1972 = "llvm.load"(%1971) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %1973 = "llvm.getelementptr"(%1968) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %1974 = "llvm.load"(%1973) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %1975 = "llvm.lshr"(%1972, %1924) : (i64, i64) -> i64
  %1976 = "llvm.trunc"(%1975) <{overflowFlags = 3 : i32}> : (i64) -> i32
  %1977 = "llvm.lshr"(%1974, %1924) : (i64, i64) -> i64
  %1978 = "llvm.trunc"(%1977) <{overflowFlags = 3 : i32}> : (i64) -> i32
  %1979 = "llvm.and"(%1972, %1925) : (i64, i64) -> i64
  %1980 = "llvm.and"(%1974, %1925) : (i64, i64) -> i64
  "llvm.store"(%1979, %1971) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  "llvm.store"(%1980, %1973) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  %1981 = "llvm.call"(%1967) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @wv_ld, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> vector<4xi64>
  %1982 = "llvm.call"(%1981) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_unpack, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<4xi64>) -> vector<8xi64>
  %1983 = "llvm.call"(%1968) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @wv_ld, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> vector<4xi64>
  %1984 = "llvm.call"(%1983) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_unpack, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<4xi64>) -> vector<8xi64>
  %1985 = "llvm.call"(%1982) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> vector<8xi64>
  %1986 = "llvm.and"(%1985, %1926) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1987 = "llvm.lshr"(%1985, %1927) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1988 = "llvm.shufflevector"(%1987, %1928) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1989 = "llvm.call_intrinsic"(%1986, %1929, %1988) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1990 = "llvm.call"(%1984) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> vector<8xi64>
  %1991 = "llvm.and"(%1990, %1926) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1992 = "llvm.lshr"(%1990, %1927) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1993 = "llvm.shufflevector"(%1992, %1928) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1994 = "llvm.call_intrinsic"(%1991, %1929, %1993) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1995 = "llvm.add"(%1989, %1930) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1996 = "llvm.and"(%1995, %1926) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1997 = "llvm.ashr"(%1995, %1927) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1998 = "llvm.shufflevector"(%1997, %1942) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 8, 8>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1999 = "llvm.mul"(%1998, %1915) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2000 = "llvm.and"(%1999, %1914) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2001 = "llvm.add"(%1998, %1996) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2002 = "llvm.add"(%2001, %2000) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2003 = "llvm.add"(%2002, %1913) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2004 = "llvm.add"(%1994, %1930) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2005 = "llvm.and"(%2004, %1926) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2006 = "llvm.ashr"(%2004, %1927) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2007 = "llvm.shufflevector"(%2006, %1942) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 8, 8>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2008 = "llvm.mul"(%2007, %1915) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2009 = "llvm.and"(%2008, %1914) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2010 = "llvm.add"(%2007, %2005) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2011 = "llvm.add"(%2010, %2009) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2012 = "llvm.add"(%2011, %1913) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2013 = "llvm.call"(%1912, %1989) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2014 = "llvm.and"(%2013, %1926) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2015 = "llvm.lshr"(%2013, %1927) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2016 = "llvm.shufflevector"(%2015, %1928) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2017 = "llvm.call_intrinsic"(%2014, %1929, %2016) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2018 = "llvm.add"(%2017, %1911) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2019 = "llvm.call"(%1912, %1994) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2020 = "llvm.and"(%2019, %1926) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2021 = "llvm.lshr"(%2019, %1927) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2022 = "llvm.shufflevector"(%2021, %1928) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2023 = "llvm.call_intrinsic"(%2020, %1929, %2022) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2024 = "llvm.add"(%2023, %1911) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2025 = "llvm.call"(%2018) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> vector<8xi64>
  %2026 = "llvm.and"(%2025, %1926) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2027 = "llvm.lshr"(%2025, %1927) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2028 = "llvm.shufflevector"(%2027, %1928) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2029 = "llvm.call_intrinsic"(%2026, %1929, %2028) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2030 = "llvm.call"(%2024) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> vector<8xi64>
  %2031 = "llvm.and"(%2030, %1926) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2032 = "llvm.lshr"(%2030, %1927) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2033 = "llvm.shufflevector"(%2032, %1928) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2034 = "llvm.call_intrinsic"(%2031, %1929, %2033) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2035 = "llvm.call"(%2029) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> vector<8xi64>
  %2036 = "llvm.and"(%2035, %1926) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2037 = "llvm.lshr"(%2035, %1927) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2038 = "llvm.shufflevector"(%2037, %1928) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2039 = "llvm.call_intrinsic"(%2036, %1929, %2038) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2040 = "llvm.call"(%2034) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> vector<8xi64>
  %2041 = "llvm.and"(%2040, %1926) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2042 = "llvm.lshr"(%2040, %1927) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2043 = "llvm.shufflevector"(%2042, %1928) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2044 = "llvm.call_intrinsic"(%2041, %1929, %2043) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2045 = "llvm.call"(%2018, %2029) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2046 = "llvm.and"(%2045, %1926) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2047 = "llvm.lshr"(%2045, %1927) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2048 = "llvm.shufflevector"(%2047, %1928) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2049 = "llvm.call_intrinsic"(%2046, %1929, %2048) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2050 = "llvm.call"(%2024, %2034) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2051 = "llvm.and"(%2050, %1926) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2052 = "llvm.lshr"(%2050, %1927) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2053 = "llvm.shufflevector"(%2052, %1928) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2054 = "llvm.call_intrinsic"(%2051, %1929, %2053) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2055 = "llvm.call"(%2003, %2049) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2056 = "llvm.and"(%2055, %1926) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2057 = "llvm.lshr"(%2055, %1927) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2058 = "llvm.shufflevector"(%2057, %1928) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2059 = "llvm.call_intrinsic"(%2056, %1929, %2058) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2060 = "llvm.call"(%2012, %2054) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2061 = "llvm.and"(%2060, %1926) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2062 = "llvm.lshr"(%2060, %1927) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2063 = "llvm.shufflevector"(%2062, %1928) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2064 = "llvm.call_intrinsic"(%2061, %1929, %2063) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2065 = "llvm.call"(%2059, %2039) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2066 = "llvm.and"(%2065, %1926) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2067 = "llvm.lshr"(%2065, %1927) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2068 = "llvm.shufflevector"(%2067, %1928) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2069 = "llvm.call_intrinsic"(%2066, %1929, %2068) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2070 = "llvm.call"(%2064, %2044) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2071 = "llvm.and"(%2070, %1926) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2072 = "llvm.lshr"(%2070, %1927) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2073 = "llvm.shufflevector"(%2072, %1928) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2074 = "llvm.call_intrinsic"(%2071, %1929, %2073) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.intr.lifetime.start"(%1969) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1970) : (!llvm.ptr) -> ()
  "llvm.call"(%1969, %2069, %1970, %2074) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_pow22523_2, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, vector<8xi64>, !llvm.ptr, vector<8xi64>) -> ()
  %2075 = "llvm.load"(%1969) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2076 = "llvm.load"(%1970) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.intr.lifetime.end"(%1970) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1969) : (!llvm.ptr) -> ()
  %2077 = "llvm.call"(%2059, %2075) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2078 = "llvm.and"(%2077, %1926) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2079 = "llvm.lshr"(%2077, %1927) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2080 = "llvm.shufflevector"(%2079, %1928) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2081 = "llvm.call_intrinsic"(%2078, %1929, %2080) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2082 = "llvm.call"(%2064, %2076) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2083 = "llvm.and"(%2082, %1926) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2084 = "llvm.lshr"(%2082, %1927) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2085 = "llvm.shufflevector"(%2084, %1928) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2086 = "llvm.call_intrinsic"(%2083, %1929, %2085) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2087 = "llvm.call"(%2081) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> vector<8xi64>
  %2088 = "llvm.and"(%2087, %1926) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2089 = "llvm.lshr"(%2087, %1927) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2090 = "llvm.shufflevector"(%2089, %1928) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2091 = "llvm.call_intrinsic"(%2088, %1929, %2090) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2092 = "llvm.call"(%2086) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> vector<8xi64>
  %2093 = "llvm.and"(%2092, %1926) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2094 = "llvm.lshr"(%2092, %1927) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2095 = "llvm.shufflevector"(%2094, %1928) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2096 = "llvm.call_intrinsic"(%2093, %1929, %2095) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2097 = "llvm.call"(%2018, %2091) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2098 = "llvm.and"(%2097, %1926) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2099 = "llvm.lshr"(%2097, %1927) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2100 = "llvm.shufflevector"(%2099, %1928) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2101 = "llvm.call_intrinsic"(%2098, %1929, %2100) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2102 = "llvm.call"(%2024, %2096) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2103 = "llvm.and"(%2102, %1926) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2104 = "llvm.lshr"(%2102, %1927) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2105 = "llvm.shufflevector"(%2104, %1928) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2106 = "llvm.call_intrinsic"(%2103, %1929, %2105) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2107 = "llvm.sub"(%2101, %2002) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2108 = "llvm.add"(%2107, %1910) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2109 = "llvm.sub"(%2106, %2011) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2110 = "llvm.add"(%2109, %1910) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2111 = "llvm.add"(%2101, %2003) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2112 = "llvm.call"(%2108) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_is_nonzero, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> i32
  %2113 = "llvm.call"(%2110) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_is_nonzero, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> i32
  %2114 = "llvm.call"(%2111) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_is_nonzero, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> i32
  %2115 = "llvm.and"(%2114, %2112) : (i32, i32) -> i32
  %2116 = "llvm.icmp"(%2115, %1934) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2116)[^bb1, ^bb3] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb1:  // pred: ^bb0
  %2117 = "llvm.add"(%2106, %2012) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2118 = "llvm.call"(%2117) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_is_nonzero, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> i32
  %2119 = "llvm.and"(%2118, %2113) : (i32, i32) -> i32
  %2120 = "llvm.icmp"(%2119, %1934) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2120)[^bb2, ^bb4] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb2:  // pred: ^bb1
  %2121 = "llvm.trunc"(%2112) <{overflowFlags = 3 : i32}> : (i32) -> i8
  %2122 = "llvm.add"(%2121, %1906) <{overflowFlags = 1 : i32}> : (i8, i8) -> i8
  %2123 = "llvm.bitcast"(%2122) : (i8) -> vector<8xi1>
  %2124 = "llvm.select"(%2123, %1911, %1905) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2125 = "llvm.trunc"(%2113) <{overflowFlags = 3 : i32}> : (i32) -> i8
  %2126 = "llvm.add"(%2125, %1906) <{overflowFlags = 1 : i32}> : (i8, i8) -> i8
  %2127 = "llvm.bitcast"(%2126) : (i8) -> vector<8xi1>
  %2128 = "llvm.select"(%2127, %1911, %1905) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2129 = "llvm.call"(%2081, %2124) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2130 = "llvm.and"(%2129, %1926) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2131 = "llvm.lshr"(%2129, %1927) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2132 = "llvm.shufflevector"(%2131, %1928) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2133 = "llvm.call_intrinsic"(%2130, %1929, %2132) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2134 = "llvm.call"(%2086, %2128) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2135 = "llvm.and"(%2134, %1926) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2136 = "llvm.lshr"(%2134, %1927) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2137 = "llvm.shufflevector"(%2136, %1928) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2138 = "llvm.call_intrinsic"(%2135, %1929, %2137) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2139 = "llvm.call"(%2133) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_diagnose, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> i32
  %2140 = "llvm.call"(%2138) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_diagnose, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> i32
  %2141 = "llvm.icmp"(%2139, %1976) <{predicate = 0 : i64}> : (i32, i32) -> i1
  %2142 = "llvm.sext"(%2141) : (i1) -> i8
  %2143 = "llvm.sub"(%1910, %2133) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2144 = "llvm.and"(%2143, %1926) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2145 = "llvm.ashr"(%2143, %1927) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2146 = "llvm.shufflevector"(%2145, %1942) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 8, 8>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2147 = "llvm.mul"(%2146, %1915) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2148 = "llvm.and"(%2147, %1914) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2149 = "llvm.add"(%2144, %1913) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2150 = "llvm.add"(%2149, %2146) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2151 = "llvm.add"(%2150, %2148) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2152 = "llvm.bitcast"(%2142) : (i8) -> vector<8xi1>
  %2153 = "llvm.select"(%2152, %2133, %2151) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2154 = "llvm.icmp"(%2140, %1978) <{predicate = 0 : i64}> : (i32, i32) -> i1
  %2155 = "llvm.sext"(%2154) : (i1) -> i8
  %2156 = "llvm.sub"(%1910, %2138) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2157 = "llvm.and"(%2156, %1926) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2158 = "llvm.ashr"(%2156, %1927) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2159 = "llvm.shufflevector"(%2158, %1942) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 8, 8>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2160 = "llvm.mul"(%2159, %1915) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2161 = "llvm.and"(%2160, %1914) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2162 = "llvm.add"(%2157, %1913) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2163 = "llvm.add"(%2162, %2159) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2164 = "llvm.add"(%2163, %2161) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2165 = "llvm.bitcast"(%2155) : (i8) -> vector<8xi1>
  %2166 = "llvm.select"(%2165, %2138, %2164) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2167 = "llvm.call"(%2153, %1982) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2168 = "llvm.and"(%2167, %1926) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2169 = "llvm.lshr"(%2167, %1927) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2170 = "llvm.shufflevector"(%2169, %1928) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2171 = "llvm.call_intrinsic"(%2168, %1929, %2170) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2172 = "llvm.call"(%2166, %1984) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2173 = "llvm.and"(%2172, %1926) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2174 = "llvm.lshr"(%2172, %1927) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2175 = "llvm.shufflevector"(%2174, %1928) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2176 = "llvm.call_intrinsic"(%2173, %1929, %2175) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2177 = "llvm.shufflevector"(%2153, %1950) <{mask = array<i32: 0, 1, 8, 9, 4, 5, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2178 = "llvm.shufflevector"(%1982, %2171) <{mask = array<i32: 0, 1, 8, 9, 4, 5, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2179 = "llvm.shufflevector"(%2153, %1958) <{mask = array<i32: 2, 3, 10, 11, 6, 7, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2180 = "llvm.shufflevector"(%1982, %2171) <{mask = array<i32: 2, 3, 10, 11, 6, 7, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2181 = "llvm.shufflevector"(%2177, %2178) <{mask = array<i32: 0, 8, 2, 10, -1, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2182 = "llvm.shufflevector"(%2177, %2178) <{mask = array<i32: -1, -1, -1, -1, 5, 13, 7, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2183 = "llvm.shufflevector"(%2179, %2180) <{mask = array<i32: 0, 8, 2, 10, -1, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2184 = "llvm.shufflevector"(%2179, %2180) <{mask = array<i32: 1, 9, 3, 11, -1, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2185 = "llvm.shufflevector"(%2181, %2184) <{mask = array<i32: 0, 1, 2, 3, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%2185, %arg85) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2186 = "llvm.shufflevector"(%2177, %2178) <{mask = array<i32: 1, 9, 3, 11, 4, 12, 6, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%2186, %arg86) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2187 = "llvm.shufflevector"(%2183, %2182) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%2187, %arg87) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2188 = "llvm.shufflevector"(%2166, %1950) <{mask = array<i32: 0, 1, 8, 9, 4, 5, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2189 = "llvm.shufflevector"(%1984, %2176) <{mask = array<i32: 0, 1, 8, 9, 4, 5, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2190 = "llvm.shufflevector"(%2166, %1958) <{mask = array<i32: 2, 3, 10, 11, 6, 7, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2191 = "llvm.shufflevector"(%1984, %2176) <{mask = array<i32: 2, 3, 10, 11, 6, 7, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2192 = "llvm.shufflevector"(%2188, %2189) <{mask = array<i32: 0, 8, 2, 10, -1, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2193 = "llvm.shufflevector"(%2188, %2189) <{mask = array<i32: -1, -1, -1, -1, 5, 13, 7, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2194 = "llvm.shufflevector"(%2190, %2191) <{mask = array<i32: 0, 8, 2, 10, -1, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2195 = "llvm.shufflevector"(%2190, %2191) <{mask = array<i32: 1, 9, 3, 11, -1, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2196 = "llvm.shufflevector"(%2192, %2195) <{mask = array<i32: 0, 1, 2, 3, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%2196, %arg89) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2197 = "llvm.shufflevector"(%2188, %2189) <{mask = array<i32: 1, 9, 3, 11, 4, 12, 6, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%2197, %arg90) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2198 = "llvm.shufflevector"(%2194, %2193) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%2198, %arg91) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2199 = "llvm.load"(%arg85) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2200 = "llvm.lshr"(%2199, %1903) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2201 = "llvm.load"(%arg86) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2202 = "llvm.lshr"(%2201, %1903) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2203 = "llvm.load"(%arg87) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2204 = "llvm.lshr"(%2203, %1902) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2205 = "llvm.mul"(%2204, %1966) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2206 = "llvm.and"(%2199, %1900) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2207 = "llvm.shufflevector"(%2205, %2204) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2208 = "llvm.add"(%2207, %2206) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%2208, %arg85) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2209 = "llvm.load"(%arg86) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2210 = "llvm.and"(%2209, %1900) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2211 = "llvm.add"(%2210, %2200) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%2211, %arg86) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2212 = "llvm.load"(%arg87) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2213 = "llvm.and"(%2212, %1899) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2214 = "llvm.add"(%2213, %2202) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%2214, %arg87) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2215 = "llvm.load"(%arg89) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2216 = "llvm.lshr"(%2215, %1903) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2217 = "llvm.load"(%arg90) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2218 = "llvm.lshr"(%2217, %1903) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2219 = "llvm.load"(%arg91) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2220 = "llvm.lshr"(%2219, %1902) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2221 = "llvm.mul"(%2220, %1966) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2222 = "llvm.and"(%2215, %1900) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2223 = "llvm.shufflevector"(%2221, %2220) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2224 = "llvm.add"(%2223, %2222) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%2224, %arg89) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2225 = "llvm.load"(%arg90) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2226 = "llvm.and"(%2225, %1900) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2227 = "llvm.add"(%2226, %2216) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%2227, %arg90) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2228 = "llvm.load"(%arg91) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2229 = "llvm.and"(%2228, %1899) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2230 = "llvm.add"(%2229, %2218) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.br"(%2230, %1934)[^bb5] : (vector<8xi64>, i32) -> ()
^bb3:  // pred: ^bb0
  "llvm.store"(%1909, %arg85) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%1909, %arg89) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%1909, %arg86) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%1909, %arg90) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%1909, %arg87) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.br"(%1909, %1908)[^bb5] : (vector<8xi64>, i32) -> ()
^bb4:  // pred: ^bb1
  "llvm.store"(%1909, %arg85) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%1909, %arg89) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%1909, %arg86) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%1909, %arg90) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%1909, %arg87) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.br"(%1909, %1907)[^bb5] : (vector<8xi64>, i32) -> ()
^bb5(%2231: vector<8xi64>, %2232: i32):  // 3 preds: ^bb2, ^bb3, ^bb4
  "llvm.store"(%2231, %arg91) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1968) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1967) : (!llvm.ptr) -> ()
  "llvm.return"(%2232) : (i32) -> ()
}) : () -> ()
  with @fd_r43x6_diagnose := fd_r43x6_diagnose, @fd_r43x6_is_nonzero := fd_r43x6_is_nonzero,
    @fd_r43x6_mul_fast := fd_r43x6_mul_fast, @fd_r43x6_pow22523_2 := fd_r43x6_pow22523_2,
    @fd_r43x6_sqr_fast := fd_r43x6_sqr_fast, @fd_r43x6_unpack := fd_r43x6_unpack, @wv_ld := wv_ld

end

end MLIR.Firedancer.Avx512
