"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<i8 (ptr, ptr)>, inline_hint, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], personality = @rust_eh_personality, res_attrs = [{llvm.noundef}], sym_name = "_RNvXs8_Cs3X6wZJE6GDg_6subtleShNtB5_14ConstantTimeEq5ct_eqCsh8hPzWUDumX_14solana_ed25519", target_cpu = "x86-64-v2", target_features = #llvm.target_features<["+avx", "+avx2", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+crc32", "+ssse3"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg43: !llvm.ptr, %arg44: !llvm.ptr):
  %1941 = "llvm.mlir.constant"() <{value = 1 : i8}> : () -> i8
  %1942 = "llvm.load"(%arg43) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1943 = "llvm.load"(%arg44) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1944 = "llvm.icmp"(%1942, %1943) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %1945 = "llvm.zext"(%1944) : (i1) -> i8
  %1946 = "llvm.call"(%1945) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %1947 = "llvm.and"(%1946, %1941) : (i8, i8) -> i8
  %1948 = "llvm.getelementptr"(%arg43) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1>}> : (!llvm.ptr) -> !llvm.ptr
  %1949 = "llvm.getelementptr"(%arg44) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1>}> : (!llvm.ptr) -> !llvm.ptr
  %1950 = "llvm.load"(%1948) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1951 = "llvm.load"(%1949) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1952 = "llvm.icmp"(%1950, %1951) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %1953 = "llvm.zext"(%1952) : (i1) -> i8
  %1954 = "llvm.call"(%1953) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %1955 = "llvm.and"(%1954, %1947) : (i8, i8) -> i8
  %1956 = "llvm.getelementptr"(%arg43) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2>}> : (!llvm.ptr) -> !llvm.ptr
  %1957 = "llvm.getelementptr"(%arg44) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2>}> : (!llvm.ptr) -> !llvm.ptr
  %1958 = "llvm.load"(%1956) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1959 = "llvm.load"(%1957) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1960 = "llvm.icmp"(%1958, %1959) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %1961 = "llvm.zext"(%1960) : (i1) -> i8
  %1962 = "llvm.call"(%1961) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %1963 = "llvm.and"(%1962, %1955) : (i8, i8) -> i8
  %1964 = "llvm.getelementptr"(%arg43) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 3>}> : (!llvm.ptr) -> !llvm.ptr
  %1965 = "llvm.getelementptr"(%arg44) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 3>}> : (!llvm.ptr) -> !llvm.ptr
  %1966 = "llvm.load"(%1964) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1967 = "llvm.load"(%1965) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1968 = "llvm.icmp"(%1966, %1967) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %1969 = "llvm.zext"(%1968) : (i1) -> i8
  %1970 = "llvm.call"(%1969) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %1971 = "llvm.and"(%1970, %1963) : (i8, i8) -> i8
  %1972 = "llvm.getelementptr"(%arg43) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4>}> : (!llvm.ptr) -> !llvm.ptr
  %1973 = "llvm.getelementptr"(%arg44) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4>}> : (!llvm.ptr) -> !llvm.ptr
  %1974 = "llvm.load"(%1972) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1975 = "llvm.load"(%1973) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1976 = "llvm.icmp"(%1974, %1975) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %1977 = "llvm.zext"(%1976) : (i1) -> i8
  %1978 = "llvm.call"(%1977) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %1979 = "llvm.and"(%1978, %1971) : (i8, i8) -> i8
  %1980 = "llvm.getelementptr"(%arg43) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 5>}> : (!llvm.ptr) -> !llvm.ptr
  %1981 = "llvm.getelementptr"(%arg44) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 5>}> : (!llvm.ptr) -> !llvm.ptr
  %1982 = "llvm.load"(%1980) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1983 = "llvm.load"(%1981) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1984 = "llvm.icmp"(%1982, %1983) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %1985 = "llvm.zext"(%1984) : (i1) -> i8
  %1986 = "llvm.call"(%1985) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %1987 = "llvm.and"(%1986, %1979) : (i8, i8) -> i8
  %1988 = "llvm.getelementptr"(%arg43) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6>}> : (!llvm.ptr) -> !llvm.ptr
  %1989 = "llvm.getelementptr"(%arg44) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6>}> : (!llvm.ptr) -> !llvm.ptr
  %1990 = "llvm.load"(%1988) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1991 = "llvm.load"(%1989) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1992 = "llvm.icmp"(%1990, %1991) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %1993 = "llvm.zext"(%1992) : (i1) -> i8
  %1994 = "llvm.call"(%1993) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %1995 = "llvm.and"(%1994, %1987) : (i8, i8) -> i8
  %1996 = "llvm.getelementptr"(%arg43) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 7>}> : (!llvm.ptr) -> !llvm.ptr
  %1997 = "llvm.getelementptr"(%arg44) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 7>}> : (!llvm.ptr) -> !llvm.ptr
  %1998 = "llvm.load"(%1996) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1999 = "llvm.load"(%1997) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2000 = "llvm.icmp"(%1998, %1999) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %2001 = "llvm.zext"(%2000) : (i1) -> i8
  %2002 = "llvm.call"(%2001) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %2003 = "llvm.and"(%2002, %1995) : (i8, i8) -> i8
  %2004 = "llvm.getelementptr"(%arg43) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %2005 = "llvm.getelementptr"(%arg44) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %2006 = "llvm.load"(%2004) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2007 = "llvm.load"(%2005) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2008 = "llvm.icmp"(%2006, %2007) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %2009 = "llvm.zext"(%2008) : (i1) -> i8
  %2010 = "llvm.call"(%2009) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %2011 = "llvm.and"(%2010, %2003) : (i8, i8) -> i8
  %2012 = "llvm.getelementptr"(%arg43) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 9>}> : (!llvm.ptr) -> !llvm.ptr
  %2013 = "llvm.getelementptr"(%arg44) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 9>}> : (!llvm.ptr) -> !llvm.ptr
  %2014 = "llvm.load"(%2012) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2015 = "llvm.load"(%2013) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2016 = "llvm.icmp"(%2014, %2015) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %2017 = "llvm.zext"(%2016) : (i1) -> i8
  %2018 = "llvm.call"(%2017) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %2019 = "llvm.and"(%2018, %2011) : (i8, i8) -> i8
  %2020 = "llvm.getelementptr"(%arg43) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 10>}> : (!llvm.ptr) -> !llvm.ptr
  %2021 = "llvm.getelementptr"(%arg44) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 10>}> : (!llvm.ptr) -> !llvm.ptr
  %2022 = "llvm.load"(%2020) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2023 = "llvm.load"(%2021) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2024 = "llvm.icmp"(%2022, %2023) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %2025 = "llvm.zext"(%2024) : (i1) -> i8
  %2026 = "llvm.call"(%2025) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %2027 = "llvm.and"(%2026, %2019) : (i8, i8) -> i8
  %2028 = "llvm.getelementptr"(%arg43) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 11>}> : (!llvm.ptr) -> !llvm.ptr
  %2029 = "llvm.getelementptr"(%arg44) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 11>}> : (!llvm.ptr) -> !llvm.ptr
  %2030 = "llvm.load"(%2028) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2031 = "llvm.load"(%2029) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2032 = "llvm.icmp"(%2030, %2031) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %2033 = "llvm.zext"(%2032) : (i1) -> i8
  %2034 = "llvm.call"(%2033) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %2035 = "llvm.and"(%2034, %2027) : (i8, i8) -> i8
  %2036 = "llvm.getelementptr"(%arg43) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 12>}> : (!llvm.ptr) -> !llvm.ptr
  %2037 = "llvm.getelementptr"(%arg44) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 12>}> : (!llvm.ptr) -> !llvm.ptr
  %2038 = "llvm.load"(%2036) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2039 = "llvm.load"(%2037) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2040 = "llvm.icmp"(%2038, %2039) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %2041 = "llvm.zext"(%2040) : (i1) -> i8
  %2042 = "llvm.call"(%2041) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %2043 = "llvm.and"(%2042, %2035) : (i8, i8) -> i8
  %2044 = "llvm.getelementptr"(%arg43) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 13>}> : (!llvm.ptr) -> !llvm.ptr
  %2045 = "llvm.getelementptr"(%arg44) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 13>}> : (!llvm.ptr) -> !llvm.ptr
  %2046 = "llvm.load"(%2044) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2047 = "llvm.load"(%2045) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2048 = "llvm.icmp"(%2046, %2047) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %2049 = "llvm.zext"(%2048) : (i1) -> i8
  %2050 = "llvm.call"(%2049) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %2051 = "llvm.and"(%2050, %2043) : (i8, i8) -> i8
  %2052 = "llvm.getelementptr"(%arg43) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 14>}> : (!llvm.ptr) -> !llvm.ptr
  %2053 = "llvm.getelementptr"(%arg44) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 14>}> : (!llvm.ptr) -> !llvm.ptr
  %2054 = "llvm.load"(%2052) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2055 = "llvm.load"(%2053) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2056 = "llvm.icmp"(%2054, %2055) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %2057 = "llvm.zext"(%2056) : (i1) -> i8
  %2058 = "llvm.call"(%2057) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %2059 = "llvm.and"(%2058, %2051) : (i8, i8) -> i8
  %2060 = "llvm.getelementptr"(%arg43) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 15>}> : (!llvm.ptr) -> !llvm.ptr
  %2061 = "llvm.getelementptr"(%arg44) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 15>}> : (!llvm.ptr) -> !llvm.ptr
  %2062 = "llvm.load"(%2060) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2063 = "llvm.load"(%2061) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2064 = "llvm.icmp"(%2062, %2063) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %2065 = "llvm.zext"(%2064) : (i1) -> i8
  %2066 = "llvm.call"(%2065) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %2067 = "llvm.and"(%2066, %2059) : (i8, i8) -> i8
  %2068 = "llvm.getelementptr"(%arg43) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %2069 = "llvm.getelementptr"(%arg44) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %2070 = "llvm.load"(%2068) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2071 = "llvm.load"(%2069) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2072 = "llvm.icmp"(%2070, %2071) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %2073 = "llvm.zext"(%2072) : (i1) -> i8
  %2074 = "llvm.call"(%2073) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %2075 = "llvm.and"(%2074, %2067) : (i8, i8) -> i8
  %2076 = "llvm.getelementptr"(%arg43) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 17>}> : (!llvm.ptr) -> !llvm.ptr
  %2077 = "llvm.getelementptr"(%arg44) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 17>}> : (!llvm.ptr) -> !llvm.ptr
  %2078 = "llvm.load"(%2076) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2079 = "llvm.load"(%2077) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2080 = "llvm.icmp"(%2078, %2079) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %2081 = "llvm.zext"(%2080) : (i1) -> i8
  %2082 = "llvm.call"(%2081) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %2083 = "llvm.and"(%2082, %2075) : (i8, i8) -> i8
  %2084 = "llvm.getelementptr"(%arg43) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 18>}> : (!llvm.ptr) -> !llvm.ptr
  %2085 = "llvm.getelementptr"(%arg44) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 18>}> : (!llvm.ptr) -> !llvm.ptr
  %2086 = "llvm.load"(%2084) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2087 = "llvm.load"(%2085) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2088 = "llvm.icmp"(%2086, %2087) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %2089 = "llvm.zext"(%2088) : (i1) -> i8
  %2090 = "llvm.call"(%2089) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %2091 = "llvm.and"(%2090, %2083) : (i8, i8) -> i8
  %2092 = "llvm.getelementptr"(%arg43) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 19>}> : (!llvm.ptr) -> !llvm.ptr
  %2093 = "llvm.getelementptr"(%arg44) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 19>}> : (!llvm.ptr) -> !llvm.ptr
  %2094 = "llvm.load"(%2092) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2095 = "llvm.load"(%2093) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2096 = "llvm.icmp"(%2094, %2095) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %2097 = "llvm.zext"(%2096) : (i1) -> i8
  %2098 = "llvm.call"(%2097) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %2099 = "llvm.and"(%2098, %2091) : (i8, i8) -> i8
  %2100 = "llvm.getelementptr"(%arg43) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 20>}> : (!llvm.ptr) -> !llvm.ptr
  %2101 = "llvm.getelementptr"(%arg44) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 20>}> : (!llvm.ptr) -> !llvm.ptr
  %2102 = "llvm.load"(%2100) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2103 = "llvm.load"(%2101) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2104 = "llvm.icmp"(%2102, %2103) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %2105 = "llvm.zext"(%2104) : (i1) -> i8
  %2106 = "llvm.call"(%2105) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %2107 = "llvm.and"(%2106, %2099) : (i8, i8) -> i8
  %2108 = "llvm.getelementptr"(%arg43) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 21>}> : (!llvm.ptr) -> !llvm.ptr
  %2109 = "llvm.getelementptr"(%arg44) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 21>}> : (!llvm.ptr) -> !llvm.ptr
  %2110 = "llvm.load"(%2108) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2111 = "llvm.load"(%2109) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2112 = "llvm.icmp"(%2110, %2111) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %2113 = "llvm.zext"(%2112) : (i1) -> i8
  %2114 = "llvm.call"(%2113) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %2115 = "llvm.and"(%2114, %2107) : (i8, i8) -> i8
  %2116 = "llvm.getelementptr"(%arg43) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 22>}> : (!llvm.ptr) -> !llvm.ptr
  %2117 = "llvm.getelementptr"(%arg44) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 22>}> : (!llvm.ptr) -> !llvm.ptr
  %2118 = "llvm.load"(%2116) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2119 = "llvm.load"(%2117) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2120 = "llvm.icmp"(%2118, %2119) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %2121 = "llvm.zext"(%2120) : (i1) -> i8
  %2122 = "llvm.call"(%2121) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %2123 = "llvm.and"(%2122, %2115) : (i8, i8) -> i8
  %2124 = "llvm.getelementptr"(%arg43) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 23>}> : (!llvm.ptr) -> !llvm.ptr
  %2125 = "llvm.getelementptr"(%arg44) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 23>}> : (!llvm.ptr) -> !llvm.ptr
  %2126 = "llvm.load"(%2124) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2127 = "llvm.load"(%2125) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2128 = "llvm.icmp"(%2126, %2127) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %2129 = "llvm.zext"(%2128) : (i1) -> i8
  %2130 = "llvm.call"(%2129) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %2131 = "llvm.and"(%2130, %2123) : (i8, i8) -> i8
  %2132 = "llvm.getelementptr"(%arg43) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %2133 = "llvm.getelementptr"(%arg44) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %2134 = "llvm.load"(%2132) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2135 = "llvm.load"(%2133) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2136 = "llvm.icmp"(%2134, %2135) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %2137 = "llvm.zext"(%2136) : (i1) -> i8
  %2138 = "llvm.call"(%2137) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %2139 = "llvm.and"(%2138, %2131) : (i8, i8) -> i8
  %2140 = "llvm.getelementptr"(%arg43) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 25>}> : (!llvm.ptr) -> !llvm.ptr
  %2141 = "llvm.getelementptr"(%arg44) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 25>}> : (!llvm.ptr) -> !llvm.ptr
  %2142 = "llvm.load"(%2140) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2143 = "llvm.load"(%2141) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2144 = "llvm.icmp"(%2142, %2143) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %2145 = "llvm.zext"(%2144) : (i1) -> i8
  %2146 = "llvm.call"(%2145) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %2147 = "llvm.and"(%2146, %2139) : (i8, i8) -> i8
  %2148 = "llvm.getelementptr"(%arg43) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 26>}> : (!llvm.ptr) -> !llvm.ptr
  %2149 = "llvm.getelementptr"(%arg44) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 26>}> : (!llvm.ptr) -> !llvm.ptr
  %2150 = "llvm.load"(%2148) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2151 = "llvm.load"(%2149) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2152 = "llvm.icmp"(%2150, %2151) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %2153 = "llvm.zext"(%2152) : (i1) -> i8
  %2154 = "llvm.call"(%2153) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %2155 = "llvm.and"(%2154, %2147) : (i8, i8) -> i8
  %2156 = "llvm.getelementptr"(%arg43) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 27>}> : (!llvm.ptr) -> !llvm.ptr
  %2157 = "llvm.getelementptr"(%arg44) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 27>}> : (!llvm.ptr) -> !llvm.ptr
  %2158 = "llvm.load"(%2156) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2159 = "llvm.load"(%2157) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2160 = "llvm.icmp"(%2158, %2159) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %2161 = "llvm.zext"(%2160) : (i1) -> i8
  %2162 = "llvm.call"(%2161) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %2163 = "llvm.and"(%2162, %2155) : (i8, i8) -> i8
  %2164 = "llvm.getelementptr"(%arg43) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 28>}> : (!llvm.ptr) -> !llvm.ptr
  %2165 = "llvm.getelementptr"(%arg44) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 28>}> : (!llvm.ptr) -> !llvm.ptr
  %2166 = "llvm.load"(%2164) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2167 = "llvm.load"(%2165) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2168 = "llvm.icmp"(%2166, %2167) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %2169 = "llvm.zext"(%2168) : (i1) -> i8
  %2170 = "llvm.call"(%2169) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %2171 = "llvm.and"(%2170, %2163) : (i8, i8) -> i8
  %2172 = "llvm.getelementptr"(%arg43) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 29>}> : (!llvm.ptr) -> !llvm.ptr
  %2173 = "llvm.getelementptr"(%arg44) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 29>}> : (!llvm.ptr) -> !llvm.ptr
  %2174 = "llvm.load"(%2172) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2175 = "llvm.load"(%2173) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2176 = "llvm.icmp"(%2174, %2175) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %2177 = "llvm.zext"(%2176) : (i1) -> i8
  %2178 = "llvm.call"(%2177) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %2179 = "llvm.and"(%2178, %2171) : (i8, i8) -> i8
  %2180 = "llvm.getelementptr"(%arg43) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 30>}> : (!llvm.ptr) -> !llvm.ptr
  %2181 = "llvm.getelementptr"(%arg44) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 30>}> : (!llvm.ptr) -> !llvm.ptr
  %2182 = "llvm.load"(%2180) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2183 = "llvm.load"(%2181) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2184 = "llvm.icmp"(%2182, %2183) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %2185 = "llvm.zext"(%2184) : (i1) -> i8
  %2186 = "llvm.call"(%2185) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %2187 = "llvm.and"(%2186, %2179) : (i8, i8) -> i8
  %2188 = "llvm.getelementptr"(%arg43) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 31>}> : (!llvm.ptr) -> !llvm.ptr
  %2189 = "llvm.getelementptr"(%arg44) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 31>}> : (!llvm.ptr) -> !llvm.ptr
  %2190 = "llvm.load"(%2188) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2191 = "llvm.load"(%2189) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2192 = "llvm.icmp"(%2190, %2191) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %2193 = "llvm.zext"(%2192) : (i1) -> i8
  %2194 = "llvm.call"(%2193) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %2195 = "llvm.and"(%2194, %2187) : (i8, i8) -> i8
  %2196 = "llvm.call"(%2195) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  "llvm.return"(%2196) : (i8) -> ()
}) : () -> ()
