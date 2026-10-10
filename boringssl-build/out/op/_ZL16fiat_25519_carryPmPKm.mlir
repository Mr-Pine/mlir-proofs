"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"], ["warn-stack-size", "25344"]], sym_name = "_ZL16fiat_25519_carryPmPKm", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg94: !llvm.ptr, %arg95: !llvm.ptr):
  %1391 = "llvm.mlir.constant"() <{value = 51 : i64}> : () -> i64
  %1392 = "llvm.mlir.constant"() <{value = 2251799813685247 : i64}> : () -> i64
  %1393 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %1394 = "llvm.load"(%arg95) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1395 = "llvm.lshr"(%1394, %1391) : (i64, i64) -> i64
  %1396 = "llvm.getelementptr"(%arg95) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %1397 = "llvm.load"(%1396) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1398 = "llvm.add"(%1395, %1397) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1399 = "llvm.lshr"(%1398, %1391) : (i64, i64) -> i64
  %1400 = "llvm.getelementptr"(%arg95) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %1401 = "llvm.load"(%1400) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1402 = "llvm.add"(%1399, %1401) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1403 = "llvm.lshr"(%1402, %1391) : (i64, i64) -> i64
  %1404 = "llvm.getelementptr"(%arg95) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %1405 = "llvm.load"(%1404) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1406 = "llvm.add"(%1403, %1405) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1407 = "llvm.lshr"(%1406, %1391) : (i64, i64) -> i64
  %1408 = "llvm.getelementptr"(%arg95) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %1409 = "llvm.load"(%1408) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1410 = "llvm.add"(%1407, %1409) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1411 = "llvm.and"(%1394, %1392) : (i64, i64) -> i64
  %1412 = "llvm.lshr"(%1410, %1391) : (i64, i64) -> i64
  %1413 = "llvm.mul"(%1412, %1393) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1414 = "llvm.add"(%1413, %1411) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1415 = "llvm.lshr"(%1414, %1391) : (i64, i64) -> i64
  %1416 = "llvm.and"(%1398, %1392) : (i64, i64) -> i64
  %1417 = "llvm.add"(%1415, %1416) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1418 = "llvm.and"(%1414, %1392) : (i64, i64) -> i64
  %1419 = "llvm.and"(%1417, %1392) : (i64, i64) -> i64
  %1420 = "llvm.lshr"(%1417, %1391) : (i64, i64) -> i64
  %1421 = "llvm.and"(%1402, %1392) : (i64, i64) -> i64
  %1422 = "llvm.add"(%1420, %1421) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1423 = "llvm.and"(%1406, %1392) : (i64, i64) -> i64
  %1424 = "llvm.and"(%1410, %1392) : (i64, i64) -> i64
  "llvm.store"(%1418, %arg94) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1425 = "llvm.getelementptr"(%arg94) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1419, %1425) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1426 = "llvm.getelementptr"(%arg94) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1422, %1426) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1427 = "llvm.getelementptr"(%arg94) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1423, %1427) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1428 = "llvm.getelementptr"(%arg94) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1424, %1428) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
