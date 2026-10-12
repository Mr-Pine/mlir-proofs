"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 8 : i64, llvm.dead_on_unwind, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writable, llvm.writeonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], sym_name = "_RNvMs2_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar523add", target_cpu = "x86-64-v2", target_features = #llvm.target_features<["+avx", "+avx2", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+crc32", "+ssse3"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg69: !llvm.ptr, %arg70: !llvm.ptr, %arg71: !llvm.ptr):
  %2125 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %2126 = "llvm.mlir.constant"() <{value = 4503599627370495 : i64}> : () -> i64
  %2127 = "llvm.mlir.constant"() <{value = 52 : i64}> : () -> i64
  %2128 = "llvm.alloca"(%2125) <{alignment = 8 : i64, elem_type = !llvm.array<40 x i8>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%2128) : (!llvm.ptr) -> ()
  %2129 = "llvm.load"(%arg70) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2130 = "llvm.load"(%arg71) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2131 = "llvm.add"(%2129, %2130) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2132 = "llvm.and"(%2131, %2126) : (i64, i64) -> i64
  "llvm.store"(%2132, %2128) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %2133 = "llvm.getelementptr"(%arg70) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %2134 = "llvm.load"(%2133) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2135 = "llvm.getelementptr"(%arg71) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %2136 = "llvm.load"(%2135) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2137 = "llvm.lshr"(%2131, %2127) : (i64, i64) -> i64
  %2138 = "llvm.add"(%2134, %2137) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2139 = "llvm.add"(%2138, %2136) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2140 = "llvm.getelementptr"(%2128) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %2141 = "llvm.and"(%2139, %2126) : (i64, i64) -> i64
  "llvm.store"(%2141, %2140) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %2142 = "llvm.getelementptr"(%arg70) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %2143 = "llvm.load"(%2142) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2144 = "llvm.getelementptr"(%arg71) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %2145 = "llvm.load"(%2144) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2146 = "llvm.lshr"(%2139, %2127) : (i64, i64) -> i64
  %2147 = "llvm.add"(%2143, %2146) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2148 = "llvm.add"(%2147, %2145) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2149 = "llvm.getelementptr"(%2128) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %2150 = "llvm.and"(%2148, %2126) : (i64, i64) -> i64
  "llvm.store"(%2150, %2149) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %2151 = "llvm.getelementptr"(%arg70) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %2152 = "llvm.load"(%2151) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2153 = "llvm.getelementptr"(%arg71) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %2154 = "llvm.load"(%2153) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2155 = "llvm.lshr"(%2148, %2127) : (i64, i64) -> i64
  %2156 = "llvm.add"(%2152, %2155) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2157 = "llvm.add"(%2156, %2154) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2158 = "llvm.getelementptr"(%2128) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %2159 = "llvm.and"(%2157, %2126) : (i64, i64) -> i64
  "llvm.store"(%2159, %2158) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %2160 = "llvm.getelementptr"(%arg70) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %2161 = "llvm.load"(%2160) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2162 = "llvm.getelementptr"(%arg71) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %2163 = "llvm.load"(%2162) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2164 = "llvm.lshr"(%2157, %2127) : (i64, i64) -> i64
  %2165 = "llvm.add"(%2161, %2164) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2166 = "llvm.add"(%2165, %2163) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2167 = "llvm.getelementptr"(%2128) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %2168 = "llvm.and"(%2166, %2126) : (i64, i64) -> i64
  "llvm.store"(%2168, %2167) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.call"(%arg69, %2128) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvMs2_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar523sub, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2128) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
