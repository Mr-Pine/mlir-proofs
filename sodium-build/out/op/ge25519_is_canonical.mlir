"llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<i32 (ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "ssp", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], res_attrs = [{llvm.range = #llvm.constant_range<i32, 0, 2>}], sym_name = "ge25519_is_canonical", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg42: !llvm.ptr):
  %2307 = "llvm.mlir.constant"() <{value = 127 : i8}> : () -> i8
  %2308 = "llvm.mlir.poison"() : () -> vector<8xi8>
  %2309 = "llvm.mlir.poison"() : () -> vector<4xi8>
  %2310 = "llvm.mlir.constant"() <{value = -1 : i8}> : () -> i8
  %2311 = "llvm.mlir.constant"() <{value = 511 : i32}> : () -> i32
  %2312 = "llvm.mlir.constant"() <{value = 236 : i32}> : () -> i32
  %2313 = "llvm.mlir.constant"() <{value = 8 : i32}> : () -> i32
  %2314 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %2315 = "llvm.getelementptr"(%arg42) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 31>}> : (!llvm.ptr) -> !llvm.ptr
  %2316 = "llvm.load"(%2315) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2317 = "llvm.and"(%2316, %2307) : (i8, i8) -> i8
  %2318 = "llvm.xor"(%2317, %2307) : (i8, i8) -> i8
  %2319 = "llvm.getelementptr"(%arg42) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 15>}> : (!llvm.ptr) -> !llvm.ptr
  %2320 = "llvm.load"(%2319) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<16xi8>
  %2321 = "llvm.getelementptr"(%arg42) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 7>}> : (!llvm.ptr) -> !llvm.ptr
  %2322 = "llvm.load"(%2321) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi8>
  %2323 = "llvm.getelementptr"(%arg42) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 3>}> : (!llvm.ptr) -> !llvm.ptr
  %2324 = "llvm.load"(%2323) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi8>
  %2325 = "llvm.getelementptr"(%arg42) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 2>}> : (!llvm.ptr) -> !llvm.ptr
  %2326 = "llvm.load"(%2325) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2327 = "llvm.getelementptr"(%arg42) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 1>}> : (!llvm.ptr) -> !llvm.ptr
  %2328 = "llvm.load"(%2327) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2329 = "llvm.shufflevector"(%2322, %2308) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, -1, -1, -1, -1, -1, -1, -1, -1>}> : (vector<8xi8>, vector<8xi8>) -> vector<16xi8>
  %2330 = "llvm.and"(%2320, %2329) : (vector<16xi8>, vector<16xi8>) -> vector<16xi8>
  %2331 = "llvm.shufflevector"(%2330, %2320) <{mask = array<i32: -1, -1, -1, -1, 4, 5, 6, 7, 24, 25, 26, 27, 28, 29, 30, 31>}> : (vector<16xi8>, vector<16xi8>) -> vector<16xi8>
  %2332 = "llvm.shufflevector"(%2324, %2309) <{mask = array<i32: 0, 1, 2, 3, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1>}> : (vector<4xi8>, vector<4xi8>) -> vector<16xi8>
  %2333 = "llvm.and"(%2330, %2332) : (vector<16xi8>, vector<16xi8>) -> vector<16xi8>
  %2334 = "llvm.shufflevector"(%2333, %2331) <{mask = array<i32: 0, 1, 2, 3, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31>}> : (vector<16xi8>, vector<16xi8>) -> vector<16xi8>
  %2335 = "llvm.intr.vector.reduce.and"(%2334) : (vector<16xi8>) -> i8
  %2336 = "llvm.and"(%2335, %2326) : (i8, i8) -> i8
  %2337 = "llvm.and"(%2336, %2328) : (i8, i8) -> i8
  %2338 = "llvm.xor"(%2337, %2310) : (i8, i8) -> i8
  %2339 = "llvm.or"(%2318, %2338) : (i8, i8) -> i8
  %2340 = "llvm.zext"(%2339) : (i8) -> i32
  %2341 = "llvm.add"(%2340, %2311) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %2342 = "llvm.load"(%arg42) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2343 = "llvm.zext"(%2342) : (i8) -> i32
  %2344 = "llvm.sub"(%2312, %2343) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %2345 = "llvm.and"(%2344, %2341) : (i32, i32) -> i32
  %2346 = "llvm.lshr"(%2345, %2313) : (i32, i32) -> i32
  %2347 = "llvm.and"(%2346, %2314) : (i32, i32) -> i32
  %2348 = "llvm.xor"(%2347, %2314) : (i32, i32) -> i32
  "llvm.return"(%2348) : (i32) -> ()
}) : () -> ()
