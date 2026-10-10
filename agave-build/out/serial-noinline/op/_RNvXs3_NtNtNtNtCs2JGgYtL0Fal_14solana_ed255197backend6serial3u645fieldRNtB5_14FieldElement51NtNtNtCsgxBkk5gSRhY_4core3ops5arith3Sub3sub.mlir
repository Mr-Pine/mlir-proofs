"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 8 : i64, llvm.dead_on_unwind, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writable, llvm.writeonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], sym_name = "_RNvXs3_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldRNtB5_14FieldElement51NtNtNtCsgxBkk5gSRhY_4core3ops5arith3Sub3sub", target_cpu = "x86-64-v2", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg53: !llvm.ptr, %arg54: !llvm.ptr, %arg55: !llvm.ptr):
  %1403 = "llvm.mlir.constant"() <{value = dense<[36028797018963664, 36028797018963952]> : vector<2xi64>}> : () -> vector<2xi64>
  %1404 = "llvm.mlir.constant"() <{value = dense<36028797018963952> : vector<2xi64>}> : () -> vector<2xi64>
  %1405 = "llvm.mlir.constant"() <{value = dense<51> : vector<2xi64>}> : () -> vector<2xi64>
  %1406 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %1407 = "llvm.mlir.constant"() <{value = 2251799813685247 : i64}> : () -> i64
  %1408 = "llvm.mlir.constant"() <{value = dense<2251799813685247> : vector<2xi64>}> : () -> vector<2xi64>
  %1409 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %1410 = "llvm.mlir.constant"() <{value = 51 : i64}> : () -> i64
  %1411 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %1412 = "llvm.getelementptr"(%arg54) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %1413 = "llvm.getelementptr"(%arg55) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %1414 = "llvm.getelementptr"(%arg54) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %1415 = "llvm.getelementptr"(%arg55) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %1416 = "llvm.getelementptr"(%arg53) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %1417 = "llvm.load"(%arg54) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  %1418 = "llvm.load"(%1412) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  %1419 = "llvm.add"(%1417, %1403) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1420 = "llvm.load"(%arg55) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  %1421 = "llvm.add"(%1418, %1404) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1422 = "llvm.load"(%1413) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  %1423 = "llvm.sub"(%1419, %1420) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1424 = "llvm.sub"(%1421, %1422) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1425 = "llvm.lshr"(%1423, %1405) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1426 = "llvm.extractelement"(%1423, %1406) : (vector<2xi64>, i64) -> i64
  %1427 = "llvm.and"(%1426, %1407) : (i64, i64) -> i64
  %1428 = "llvm.and"(%1424, %1408) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1429 = "llvm.add"(%1428, %1425) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  "llvm.store"(%1429, %1416) <{alignment = 8 : i64, ordering = 0 : i64}> : (vector<2xi64>, !llvm.ptr) -> ()
  %1430 = "llvm.getelementptr"(%arg53) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %1431 = "llvm.load"(%1414) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  %1432 = "llvm.add"(%1431, %1404) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1433 = "llvm.load"(%1415) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  %1434 = "llvm.sub"(%1432, %1433) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1435 = "llvm.extractelement"(%1434, %1409) : (vector<2xi64>, i64) -> i64
  %1436 = "llvm.lshr"(%1435, %1410) : (i64, i64) -> i64
  %1437 = "llvm.and"(%1434, %1408) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1438 = "llvm.mul"(%1436, %1411) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1439 = "llvm.shufflevector"(%1424, %1434) <{mask = array<i32: 1, 2>}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1440 = "llvm.lshr"(%1439, %1405) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1441 = "llvm.add"(%1438, %1427) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1442 = "llvm.add"(%1437, %1440) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  "llvm.store"(%1441, %arg53) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.store"(%1442, %1430) <{alignment = 8 : i64, ordering = 0 : i64}> : (vector<2xi64>, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
