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
^bb0(%arg87: !llvm.ptr, %arg88: !llvm.ptr, %arg89: !llvm.ptr, %arg90: !llvm.ptr, %arg91: !llvm.ptr, %arg92: !llvm.ptr, %arg93: !llvm.ptr, %arg94: !llvm.ptr):
  %1909 = "llvm.mlir.constant"() <{value = dense<[8796093022207, 8796093022207, 8796093022207, 8796093022207, 1099511627775, 1099511627775, 1099511627775, 1099511627775]> : vector<8xi64>}> : () -> vector<8xi64>
  %1910 = "llvm.mlir.constant"() <{value = dense<8796093022207> : vector<8xi64>}> : () -> vector<8xi64>
  %1911 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %1912 = "llvm.mlir.constant"() <{value = dense<[43, 43, 43, 43, 40, 40, 40, 40]> : vector<8xi64>}> : () -> vector<8xi64>
  %1913 = "llvm.mlir.constant"() <{value = dense<43> : vector<8xi64>}> : () -> vector<8xi64>
  %1914 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %1915 = "llvm.mlir.constant"() <{value = dense<[3467281080496, 6582290652611, 5210002954932, 329084955603, 4526638806224, 373767602335, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %1916 = "llvm.mlir.constant"() <{value = -1 : i8}> : () -> i8
  %1917 = "llvm.mlir.constant"() <{value = -2 : i32}> : () -> i32
  %1918 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
  %1919 = "llvm.mlir.constant"() <{value = dense<0> : vector<8xi64>}> : () -> vector<8xi64>
  %1920 = "llvm.mlir.constant"() <{value = dense<[8795933638637, 8796091973631, 8796091973631, 8796091973631, 8796091973631, 1099510579199, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %1921 = "llvm.mlir.constant"() <{value = dense<[1, 0, 0, 0, 0, 0, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %1922 = "llvm.mlir.constant"() <{value = dense<[6365466163363, 253762649449, 7518893317, 260847760460, 7696165686388, 704489577558, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %1923 = "llvm.mlir.constant"() <{value = dense<[159383552, 1048576, 1048576, 1048576, 1048576, 1048576, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %1924 = "llvm.mlir.constant"() <{value = dense<[-1, 0, 0, 0, 0, 0, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %1925 = "llvm.mlir.constant"() <{value = dense<18> : vector<8xi64>}> : () -> vector<8xi64>
  %1926 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %1927 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %1928 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %1929 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %1930 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %1931 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %1932 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1933 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %1934 = "llvm.mlir.constant"() <{value = 63 : i64}> : () -> i64
  %1935 = "llvm.mlir.constant"() <{value = 9223372036854775807 : i64}> : () -> i64
  %1936 = "llvm.mlir.constant"() <{value = dense<[8796093022207, 8796093022207, 8796093022207, 8796093022207, 8796093022207, 1099511627775, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %1937 = "llvm.mlir.constant"() <{value = dense<[43, 43, 43, 43, 43, 40, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %1938 = "llvm.mlir.poison"() : () -> vector<8xi64>
  %1939 = "llvm.mlir.constant"() <{value = dense<[19, 1, 1, 1, 1, 1, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %1940 = "llvm.mlir.constant"() <{value = dense<[8795933638636, 8796091973631, 8796091973631, 8796091973631, 8796091973631, 1099510579199, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %1941 = "llvm.mlir.poison"() : () -> i64
  %1942 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %1943 = "llvm.mlir.undef"() : () -> vector<8xi64>
  %1944 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %1945 = "llvm.insertelement"(%1943, %1942, %1944) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1946 = "llvm.insertelement"(%1945, %1941, %1932) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1947 = "llvm.insertelement"(%1946, %1941, %1931) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1948 = "llvm.insertelement"(%1947, %1941, %1930) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1949 = "llvm.insertelement"(%1948, %1941, %1929) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1950 = "llvm.insertelement"(%1949, %1941, %1928) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1951 = "llvm.insertelement"(%1950, %1941, %1927) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1952 = "llvm.insertelement"(%1951, %1941, %1926) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1953 = "llvm.insertelement"(%1943, %1914, %1944) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1954 = "llvm.insertelement"(%1953, %1942, %1932) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1955 = "llvm.insertelement"(%1954, %1941, %1931) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1956 = "llvm.insertelement"(%1955, %1941, %1930) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1957 = "llvm.insertelement"(%1956, %1942, %1929) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1958 = "llvm.insertelement"(%1957, %1942, %1928) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1959 = "llvm.insertelement"(%1958, %1941, %1927) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1960 = "llvm.insertelement"(%1959, %1941, %1926) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1961 = "llvm.insertelement"(%1943, %1941, %1944) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1962 = "llvm.insertelement"(%1961, %1941, %1932) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1963 = "llvm.insertelement"(%1962, %1942, %1931) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1964 = "llvm.insertelement"(%1963, %1942, %1930) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1965 = "llvm.insertelement"(%1964, %1942, %1929) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1966 = "llvm.insertelement"(%1965, %1942, %1928) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1967 = "llvm.insertelement"(%1966, %1941, %1927) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1968 = "llvm.insertelement"(%1967, %1941, %1926) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1969 = "llvm.insertelement"(%1943, %1941, %1944) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1970 = "llvm.insertelement"(%1969, %1941, %1932) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1971 = "llvm.insertelement"(%1970, %1941, %1931) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1972 = "llvm.insertelement"(%1971, %1941, %1930) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1973 = "llvm.insertelement"(%1972, %1911, %1929) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1974 = "llvm.insertelement"(%1973, %1911, %1928) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1975 = "llvm.insertelement"(%1974, %1911, %1927) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1976 = "llvm.insertelement"(%1975, %1911, %1926) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1977 = "llvm.alloca"(%1932) <{alignment = 32 : i64, elem_type = !llvm.array<4 x i64>}> : (i32) -> !llvm.ptr
  %1978 = "llvm.alloca"(%1932) <{alignment = 32 : i64, elem_type = !llvm.array<4 x i64>}> : (i32) -> !llvm.ptr
  %1979 = "llvm.alloca"(%1932) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %1980 = "llvm.alloca"(%1932) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%1977) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1978) : (!llvm.ptr) -> ()
  "llvm.intr.memcpy"(%1977, %arg90, %1933) <{arg_attrs = [{llvm.align = 32 : i64, llvm.dereferenceable = 32 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 1 : i64, llvm.dereferenceable = 32 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.intr.memcpy"(%1978, %arg94, %1933) <{arg_attrs = [{llvm.align = 32 : i64, llvm.dereferenceable = 32 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 1 : i64, llvm.dereferenceable = 32 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %1981 = "llvm.getelementptr"(%1977) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %1982 = "llvm.load"(%1981) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %1983 = "llvm.getelementptr"(%1978) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %1984 = "llvm.load"(%1983) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %1985 = "llvm.lshr"(%1982, %1934) : (i64, i64) -> i64
  %1986 = "llvm.trunc"(%1985) <{overflowFlags = 3 : i32}> : (i64) -> i32
  %1987 = "llvm.lshr"(%1984, %1934) : (i64, i64) -> i64
  %1988 = "llvm.trunc"(%1987) <{overflowFlags = 3 : i32}> : (i64) -> i32
  %1989 = "llvm.and"(%1982, %1935) : (i64, i64) -> i64
  %1990 = "llvm.and"(%1984, %1935) : (i64, i64) -> i64
  "llvm.store"(%1989, %1981) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  "llvm.store"(%1990, %1983) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  %1991 = "llvm.call"(%1977) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @wv_ld, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> vector<4xi64>
  %1992 = "llvm.call"(%1991) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_unpack, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<4xi64>) -> vector<8xi64>
  %1993 = "llvm.call"(%1978) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @wv_ld, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> vector<4xi64>
  %1994 = "llvm.call"(%1993) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_unpack, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<4xi64>) -> vector<8xi64>
  %1995 = "llvm.call"(%1992) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> vector<8xi64>
  %1996 = "llvm.and"(%1995, %1936) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1997 = "llvm.lshr"(%1995, %1937) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1998 = "llvm.shufflevector"(%1997, %1938) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1999 = "llvm.call_intrinsic"(%1996, %1939, %1998) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2000 = "llvm.call"(%1994) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> vector<8xi64>
  %2001 = "llvm.and"(%2000, %1936) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2002 = "llvm.lshr"(%2000, %1937) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2003 = "llvm.shufflevector"(%2002, %1938) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2004 = "llvm.call_intrinsic"(%2001, %1939, %2003) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2005 = "llvm.add"(%1999, %1940) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2006 = "llvm.and"(%2005, %1936) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2007 = "llvm.ashr"(%2005, %1937) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2008 = "llvm.shufflevector"(%2007, %1952) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 8, 8>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2009 = "llvm.mul"(%2008, %1925) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2010 = "llvm.and"(%2009, %1924) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2011 = "llvm.add"(%2008, %2006) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2012 = "llvm.add"(%2011, %2010) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2013 = "llvm.add"(%2012, %1923) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2014 = "llvm.add"(%2004, %1940) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2015 = "llvm.and"(%2014, %1936) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2016 = "llvm.ashr"(%2014, %1937) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2017 = "llvm.shufflevector"(%2016, %1952) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 8, 8>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2018 = "llvm.mul"(%2017, %1925) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2019 = "llvm.and"(%2018, %1924) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2020 = "llvm.add"(%2017, %2015) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2021 = "llvm.add"(%2020, %2019) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2022 = "llvm.add"(%2021, %1923) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2023 = "llvm.call"(%1922, %1999) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2024 = "llvm.and"(%2023, %1936) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2025 = "llvm.lshr"(%2023, %1937) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2026 = "llvm.shufflevector"(%2025, %1938) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2027 = "llvm.call_intrinsic"(%2024, %1939, %2026) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2028 = "llvm.add"(%2027, %1921) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2029 = "llvm.call"(%1922, %2004) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2030 = "llvm.and"(%2029, %1936) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2031 = "llvm.lshr"(%2029, %1937) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2032 = "llvm.shufflevector"(%2031, %1938) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2033 = "llvm.call_intrinsic"(%2030, %1939, %2032) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2034 = "llvm.add"(%2033, %1921) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2035 = "llvm.call"(%2028) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> vector<8xi64>
  %2036 = "llvm.and"(%2035, %1936) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2037 = "llvm.lshr"(%2035, %1937) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2038 = "llvm.shufflevector"(%2037, %1938) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2039 = "llvm.call_intrinsic"(%2036, %1939, %2038) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2040 = "llvm.call"(%2034) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> vector<8xi64>
  %2041 = "llvm.and"(%2040, %1936) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2042 = "llvm.lshr"(%2040, %1937) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2043 = "llvm.shufflevector"(%2042, %1938) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2044 = "llvm.call_intrinsic"(%2041, %1939, %2043) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2045 = "llvm.call"(%2039) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> vector<8xi64>
  %2046 = "llvm.and"(%2045, %1936) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2047 = "llvm.lshr"(%2045, %1937) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2048 = "llvm.shufflevector"(%2047, %1938) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2049 = "llvm.call_intrinsic"(%2046, %1939, %2048) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2050 = "llvm.call"(%2044) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> vector<8xi64>
  %2051 = "llvm.and"(%2050, %1936) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2052 = "llvm.lshr"(%2050, %1937) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2053 = "llvm.shufflevector"(%2052, %1938) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2054 = "llvm.call_intrinsic"(%2051, %1939, %2053) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2055 = "llvm.call"(%2028, %2039) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2056 = "llvm.and"(%2055, %1936) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2057 = "llvm.lshr"(%2055, %1937) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2058 = "llvm.shufflevector"(%2057, %1938) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2059 = "llvm.call_intrinsic"(%2056, %1939, %2058) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2060 = "llvm.call"(%2034, %2044) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2061 = "llvm.and"(%2060, %1936) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2062 = "llvm.lshr"(%2060, %1937) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2063 = "llvm.shufflevector"(%2062, %1938) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2064 = "llvm.call_intrinsic"(%2061, %1939, %2063) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2065 = "llvm.call"(%2013, %2059) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2066 = "llvm.and"(%2065, %1936) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2067 = "llvm.lshr"(%2065, %1937) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2068 = "llvm.shufflevector"(%2067, %1938) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2069 = "llvm.call_intrinsic"(%2066, %1939, %2068) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2070 = "llvm.call"(%2022, %2064) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2071 = "llvm.and"(%2070, %1936) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2072 = "llvm.lshr"(%2070, %1937) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2073 = "llvm.shufflevector"(%2072, %1938) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2074 = "llvm.call_intrinsic"(%2071, %1939, %2073) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2075 = "llvm.call"(%2069, %2049) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2076 = "llvm.and"(%2075, %1936) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2077 = "llvm.lshr"(%2075, %1937) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2078 = "llvm.shufflevector"(%2077, %1938) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2079 = "llvm.call_intrinsic"(%2076, %1939, %2078) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2080 = "llvm.call"(%2074, %2054) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2081 = "llvm.and"(%2080, %1936) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2082 = "llvm.lshr"(%2080, %1937) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2083 = "llvm.shufflevector"(%2082, %1938) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2084 = "llvm.call_intrinsic"(%2081, %1939, %2083) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.intr.lifetime.start"(%1979) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1980) : (!llvm.ptr) -> ()
  "llvm.call"(%1979, %2079, %1980, %2084) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_pow22523_2, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, vector<8xi64>, !llvm.ptr, vector<8xi64>) -> ()
  %2085 = "llvm.load"(%1979) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2086 = "llvm.load"(%1980) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.intr.lifetime.end"(%1980) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1979) : (!llvm.ptr) -> ()
  %2087 = "llvm.call"(%2069, %2085) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2088 = "llvm.and"(%2087, %1936) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2089 = "llvm.lshr"(%2087, %1937) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2090 = "llvm.shufflevector"(%2089, %1938) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2091 = "llvm.call_intrinsic"(%2088, %1939, %2090) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2092 = "llvm.call"(%2074, %2086) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2093 = "llvm.and"(%2092, %1936) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2094 = "llvm.lshr"(%2092, %1937) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2095 = "llvm.shufflevector"(%2094, %1938) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2096 = "llvm.call_intrinsic"(%2093, %1939, %2095) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2097 = "llvm.call"(%2091) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> vector<8xi64>
  %2098 = "llvm.and"(%2097, %1936) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2099 = "llvm.lshr"(%2097, %1937) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2100 = "llvm.shufflevector"(%2099, %1938) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2101 = "llvm.call_intrinsic"(%2098, %1939, %2100) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2102 = "llvm.call"(%2096) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> vector<8xi64>
  %2103 = "llvm.and"(%2102, %1936) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2104 = "llvm.lshr"(%2102, %1937) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2105 = "llvm.shufflevector"(%2104, %1938) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2106 = "llvm.call_intrinsic"(%2103, %1939, %2105) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2107 = "llvm.call"(%2028, %2101) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2108 = "llvm.and"(%2107, %1936) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2109 = "llvm.lshr"(%2107, %1937) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2110 = "llvm.shufflevector"(%2109, %1938) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2111 = "llvm.call_intrinsic"(%2108, %1939, %2110) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2112 = "llvm.call"(%2034, %2106) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2113 = "llvm.and"(%2112, %1936) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2114 = "llvm.lshr"(%2112, %1937) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2115 = "llvm.shufflevector"(%2114, %1938) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2116 = "llvm.call_intrinsic"(%2113, %1939, %2115) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2117 = "llvm.sub"(%2111, %2012) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2118 = "llvm.add"(%2117, %1920) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2119 = "llvm.sub"(%2116, %2021) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2120 = "llvm.add"(%2119, %1920) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2121 = "llvm.add"(%2111, %2013) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2122 = "llvm.call"(%2118) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_is_nonzero, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> i32
  %2123 = "llvm.call"(%2120) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_is_nonzero, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> i32
  %2124 = "llvm.call"(%2121) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_is_nonzero, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> i32
  %2125 = "llvm.and"(%2124, %2122) : (i32, i32) -> i32
  %2126 = "llvm.icmp"(%2125, %1944) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2126)[^bb1, ^bb3] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb1:  // pred: ^bb0
  %2127 = "llvm.add"(%2116, %2022) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2128 = "llvm.call"(%2127) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_is_nonzero, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> i32
  %2129 = "llvm.and"(%2128, %2123) : (i32, i32) -> i32
  %2130 = "llvm.icmp"(%2129, %1944) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2130)[^bb2, ^bb4] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb2:  // pred: ^bb1
  %2131 = "llvm.trunc"(%2122) <{overflowFlags = 3 : i32}> : (i32) -> i8
  %2132 = "llvm.add"(%2131, %1916) <{overflowFlags = 1 : i32}> : (i8, i8) -> i8
  %2133 = "llvm.bitcast"(%2132) : (i8) -> vector<8xi1>
  %2134 = "llvm.select"(%2133, %1921, %1915) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2135 = "llvm.trunc"(%2123) <{overflowFlags = 3 : i32}> : (i32) -> i8
  %2136 = "llvm.add"(%2135, %1916) <{overflowFlags = 1 : i32}> : (i8, i8) -> i8
  %2137 = "llvm.bitcast"(%2136) : (i8) -> vector<8xi1>
  %2138 = "llvm.select"(%2137, %1921, %1915) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2139 = "llvm.call"(%2091, %2134) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2140 = "llvm.and"(%2139, %1936) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2141 = "llvm.lshr"(%2139, %1937) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2142 = "llvm.shufflevector"(%2141, %1938) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2143 = "llvm.call_intrinsic"(%2140, %1939, %2142) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2144 = "llvm.call"(%2096, %2138) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2145 = "llvm.and"(%2144, %1936) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2146 = "llvm.lshr"(%2144, %1937) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2147 = "llvm.shufflevector"(%2146, %1938) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2148 = "llvm.call_intrinsic"(%2145, %1939, %2147) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2149 = "llvm.call"(%2143) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_diagnose, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> i32
  %2150 = "llvm.call"(%2148) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_diagnose, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> i32
  %2151 = "llvm.icmp"(%2149, %1986) <{predicate = 0 : i64}> : (i32, i32) -> i1
  %2152 = "llvm.sext"(%2151) : (i1) -> i8
  %2153 = "llvm.sub"(%1920, %2143) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2154 = "llvm.and"(%2153, %1936) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2155 = "llvm.ashr"(%2153, %1937) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2156 = "llvm.shufflevector"(%2155, %1952) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 8, 8>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2157 = "llvm.mul"(%2156, %1925) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2158 = "llvm.and"(%2157, %1924) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2159 = "llvm.add"(%2154, %1923) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2160 = "llvm.add"(%2159, %2156) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2161 = "llvm.add"(%2160, %2158) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2162 = "llvm.bitcast"(%2152) : (i8) -> vector<8xi1>
  %2163 = "llvm.select"(%2162, %2143, %2161) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2164 = "llvm.icmp"(%2150, %1988) <{predicate = 0 : i64}> : (i32, i32) -> i1
  %2165 = "llvm.sext"(%2164) : (i1) -> i8
  %2166 = "llvm.sub"(%1920, %2148) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2167 = "llvm.and"(%2166, %1936) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2168 = "llvm.ashr"(%2166, %1937) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2169 = "llvm.shufflevector"(%2168, %1952) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 8, 8>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2170 = "llvm.mul"(%2169, %1925) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2171 = "llvm.and"(%2170, %1924) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2172 = "llvm.add"(%2167, %1923) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2173 = "llvm.add"(%2172, %2169) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2174 = "llvm.add"(%2173, %2171) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2175 = "llvm.bitcast"(%2165) : (i8) -> vector<8xi1>
  %2176 = "llvm.select"(%2175, %2148, %2174) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2177 = "llvm.call"(%2163, %1992) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2178 = "llvm.and"(%2177, %1936) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2179 = "llvm.lshr"(%2177, %1937) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2180 = "llvm.shufflevector"(%2179, %1938) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2181 = "llvm.call_intrinsic"(%2178, %1939, %2180) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2182 = "llvm.call"(%2176, %1994) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2183 = "llvm.and"(%2182, %1936) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2184 = "llvm.lshr"(%2182, %1937) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2185 = "llvm.shufflevector"(%2184, %1938) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2186 = "llvm.call_intrinsic"(%2183, %1939, %2185) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2187 = "llvm.shufflevector"(%2163, %1960) <{mask = array<i32: 0, 1, 8, 9, 4, 5, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2188 = "llvm.shufflevector"(%1992, %2181) <{mask = array<i32: 0, 1, 8, 9, 4, 5, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2189 = "llvm.shufflevector"(%2163, %1968) <{mask = array<i32: 2, 3, 10, 11, 6, 7, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2190 = "llvm.shufflevector"(%1992, %2181) <{mask = array<i32: 2, 3, 10, 11, 6, 7, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2191 = "llvm.shufflevector"(%2187, %2188) <{mask = array<i32: 0, 8, 2, 10, -1, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2192 = "llvm.shufflevector"(%2187, %2188) <{mask = array<i32: -1, -1, -1, -1, 5, 13, 7, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2193 = "llvm.shufflevector"(%2189, %2190) <{mask = array<i32: 0, 8, 2, 10, -1, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2194 = "llvm.shufflevector"(%2189, %2190) <{mask = array<i32: 1, 9, 3, 11, -1, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2195 = "llvm.shufflevector"(%2191, %2194) <{mask = array<i32: 0, 1, 2, 3, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%2195, %arg87) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2196 = "llvm.shufflevector"(%2187, %2188) <{mask = array<i32: 1, 9, 3, 11, 4, 12, 6, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%2196, %arg88) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2197 = "llvm.shufflevector"(%2193, %2192) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%2197, %arg89) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2198 = "llvm.shufflevector"(%2176, %1960) <{mask = array<i32: 0, 1, 8, 9, 4, 5, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2199 = "llvm.shufflevector"(%1994, %2186) <{mask = array<i32: 0, 1, 8, 9, 4, 5, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2200 = "llvm.shufflevector"(%2176, %1968) <{mask = array<i32: 2, 3, 10, 11, 6, 7, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2201 = "llvm.shufflevector"(%1994, %2186) <{mask = array<i32: 2, 3, 10, 11, 6, 7, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2202 = "llvm.shufflevector"(%2198, %2199) <{mask = array<i32: 0, 8, 2, 10, -1, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2203 = "llvm.shufflevector"(%2198, %2199) <{mask = array<i32: -1, -1, -1, -1, 5, 13, 7, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2204 = "llvm.shufflevector"(%2200, %2201) <{mask = array<i32: 0, 8, 2, 10, -1, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2205 = "llvm.shufflevector"(%2200, %2201) <{mask = array<i32: 1, 9, 3, 11, -1, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2206 = "llvm.shufflevector"(%2202, %2205) <{mask = array<i32: 0, 1, 2, 3, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%2206, %arg91) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2207 = "llvm.shufflevector"(%2198, %2199) <{mask = array<i32: 1, 9, 3, 11, 4, 12, 6, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%2207, %arg92) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2208 = "llvm.shufflevector"(%2204, %2203) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%2208, %arg93) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2209 = "llvm.load"(%arg87) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2210 = "llvm.lshr"(%2209, %1913) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2211 = "llvm.load"(%arg88) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2212 = "llvm.lshr"(%2211, %1913) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2213 = "llvm.load"(%arg89) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2214 = "llvm.lshr"(%2213, %1912) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2215 = "llvm.mul"(%2214, %1976) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2216 = "llvm.and"(%2209, %1910) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2217 = "llvm.shufflevector"(%2215, %2214) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2218 = "llvm.add"(%2217, %2216) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%2218, %arg87) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2219 = "llvm.load"(%arg88) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2220 = "llvm.and"(%2219, %1910) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2221 = "llvm.add"(%2220, %2210) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%2221, %arg88) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2222 = "llvm.load"(%arg89) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2223 = "llvm.and"(%2222, %1909) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2224 = "llvm.add"(%2223, %2212) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%2224, %arg89) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2225 = "llvm.load"(%arg91) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2226 = "llvm.lshr"(%2225, %1913) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2227 = "llvm.load"(%arg92) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2228 = "llvm.lshr"(%2227, %1913) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2229 = "llvm.load"(%arg93) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2230 = "llvm.lshr"(%2229, %1912) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2231 = "llvm.mul"(%2230, %1976) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2232 = "llvm.and"(%2225, %1910) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2233 = "llvm.shufflevector"(%2231, %2230) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2234 = "llvm.add"(%2233, %2232) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%2234, %arg91) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2235 = "llvm.load"(%arg92) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2236 = "llvm.and"(%2235, %1910) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2237 = "llvm.add"(%2236, %2226) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%2237, %arg92) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2238 = "llvm.load"(%arg93) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2239 = "llvm.and"(%2238, %1909) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2240 = "llvm.add"(%2239, %2228) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.br"(%2240, %1944)[^bb5] : (vector<8xi64>, i32) -> ()
^bb3:  // pred: ^bb0
  "llvm.store"(%1919, %arg87) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%1919, %arg91) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%1919, %arg88) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%1919, %arg92) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%1919, %arg89) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.br"(%1919, %1918)[^bb5] : (vector<8xi64>, i32) -> ()
^bb4:  // pred: ^bb1
  "llvm.store"(%1919, %arg87) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%1919, %arg91) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%1919, %arg88) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%1919, %arg92) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%1919, %arg89) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.br"(%1919, %1917)[^bb5] : (vector<8xi64>, i32) -> ()
^bb5(%2241: vector<8xi64>, %2242: i32):  // 3 preds: ^bb2, ^bb3, ^bb4
  "llvm.store"(%2241, %arg93) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1978) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1977) : (!llvm.ptr) -> ()
  "llvm.return"(%2242) : (i32) -> ()
}) : () -> ()
  with @fd_r43x6_diagnose := fd_r43x6_diagnose, @fd_r43x6_is_nonzero := fd_r43x6_is_nonzero,
    @fd_r43x6_mul_fast := fd_r43x6_mul_fast, @fd_r43x6_pow22523_2 := fd_r43x6_pow22523_2,
    @fd_r43x6_sqr_fast := fd_r43x6_sqr_fast, @fd_r43x6_unpack := fd_r43x6_unpack, @wv_ld := wv_ld

end

end MLIR.Firedancer.Avx512
