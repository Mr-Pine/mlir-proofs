"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 8 : i64, llvm.dead_on_unwind, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writable, llvm.writeonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], sym_name = "_RNvXs3_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldRNtB5_14FieldElement51NtNtNtCsgxBkk5gSRhY_4core3ops5arith3Sub3sub", target_cpu = "x86-64-v2", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg95: !llvm.ptr, %arg96: !llvm.ptr, %arg97: !llvm.ptr):
  %2338 = "llvm.mlir.constant"() <{value = dense<[36028797018963664, 36028797018963952]> : vector<2xi64>}> : () -> vector<2xi64>
  %2339 = "llvm.mlir.constant"() <{value = dense<36028797018963952> : vector<2xi64>}> : () -> vector<2xi64>
  %2340 = "llvm.mlir.constant"() <{value = dense<51> : vector<2xi64>}> : () -> vector<2xi64>
  %2341 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %2342 = "llvm.mlir.constant"() <{value = 2251799813685247 : i64}> : () -> i64
  %2343 = "llvm.mlir.constant"() <{value = dense<2251799813685247> : vector<2xi64>}> : () -> vector<2xi64>
  %2344 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %2345 = "llvm.mlir.constant"() <{value = 51 : i64}> : () -> i64
  %2346 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %2347 = "llvm.getelementptr"(%arg96) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %2348 = "llvm.getelementptr"(%arg97) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %2349 = "llvm.getelementptr"(%arg96) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %2350 = "llvm.getelementptr"(%arg97) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %2351 = "llvm.getelementptr"(%arg95) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %2352 = "llvm.load"(%arg96) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  %2353 = "llvm.load"(%2347) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  %2354 = "llvm.add"(%2352, %2338) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %2355 = "llvm.load"(%arg97) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  %2356 = "llvm.add"(%2353, %2339) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %2357 = "llvm.load"(%2348) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  %2358 = "llvm.sub"(%2354, %2355) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %2359 = "llvm.sub"(%2356, %2357) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %2360 = "llvm.lshr"(%2358, %2340) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %2361 = "llvm.extractelement"(%2358, %2341) : (vector<2xi64>, i64) -> i64
  %2362 = "llvm.and"(%2361, %2342) : (i64, i64) -> i64
  %2363 = "llvm.and"(%2359, %2343) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %2364 = "llvm.add"(%2363, %2360) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  "llvm.store"(%2364, %2351) <{alignment = 8 : i64, ordering = 0 : i64}> : (vector<2xi64>, !llvm.ptr) -> ()
  %2365 = "llvm.getelementptr"(%arg95) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %2366 = "llvm.load"(%2349) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  %2367 = "llvm.add"(%2366, %2339) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %2368 = "llvm.load"(%2350) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  %2369 = "llvm.sub"(%2367, %2368) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %2370 = "llvm.extractelement"(%2369, %2344) : (vector<2xi64>, i64) -> i64
  %2371 = "llvm.lshr"(%2370, %2345) : (i64, i64) -> i64
  %2372 = "llvm.and"(%2369, %2343) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %2373 = "llvm.mul"(%2371, %2346) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2374 = "llvm.shufflevector"(%2359, %2369) <{mask = array<i32: 1, 2>}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %2375 = "llvm.lshr"(%2374, %2340) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %2376 = "llvm.add"(%2373, %2362) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2377 = "llvm.add"(%2372, %2375) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  "llvm.store"(%2376, %arg95) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.store"(%2377, %2365) <{alignment = 8 : i64, ordering = 0 : i64}> : (vector<2xi64>, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
