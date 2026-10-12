"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 8 : i64, llvm.dead_on_unwind, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writable, llvm.writeonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], sym_name = "_RNvMs2_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar523sub", target_cpu = "x86-64-v2", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg70: !llvm.ptr, %arg71: !llvm.ptr):
  %1350 = "llvm.mlir.constant"() <{value = -671914833335277 : i64}> : () -> i64
  %1351 = "llvm.mlir.constant"() <{value = 4503599627370495 : i64}> : () -> i64
  %1352 = "llvm.mlir.constant"() <{value = 63 : i64}> : () -> i64
  %1353 = "llvm.mlir.constant"() <{value = -3916664325105025 : i64}> : () -> i64
  %1354 = "llvm.mlir.constant"() <{value = -1367801 : i64}> : () -> i64
  %1355 = "llvm.mlir.constant"() <{value = -17592186044416 : i64}> : () -> i64
  %1356 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %1357 = "llvm.mlir.constant"() <{value = 671914833335277 : i64}> : () -> i64
  %1358 = "llvm.mlir.constant"() <{value = 3916664325105025 : i64}> : () -> i64
  %1359 = "llvm.mlir.constant"() <{value = 52 : i64}> : () -> i64
  %1360 = "llvm.mlir.constant"() <{value = 1367801 : i64}> : () -> i64
  %1361 = "llvm.mlir.constant"() <{value = 17592186044416 : i64}> : () -> i64
  %1362 = "llvm.load"(%arg71) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1363 = "llvm.add"(%1362, %1350) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1364 = "llvm.and"(%1363, %1351) : (i64, i64) -> i64
  %1365 = "llvm.getelementptr"(%arg71) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %1366 = "llvm.load"(%1365) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1367 = "llvm.ashr"(%1363, %1352) : (i64, i64) -> i64
  %1368 = "llvm.add"(%1366, %1367) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1369 = "llvm.add"(%1368, %1353) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1370 = "llvm.and"(%1369, %1351) : (i64, i64) -> i64
  %1371 = "llvm.getelementptr"(%arg71) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %1372 = "llvm.load"(%1371) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1373 = "llvm.ashr"(%1369, %1352) : (i64, i64) -> i64
  %1374 = "llvm.add"(%1372, %1373) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1375 = "llvm.add"(%1374, %1354) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1376 = "llvm.and"(%1375, %1351) : (i64, i64) -> i64
  %1377 = "llvm.getelementptr"(%arg71) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %1378 = "llvm.load"(%1377) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1379 = "llvm.ashr"(%1375, %1352) : (i64, i64) -> i64
  %1380 = "llvm.add"(%1378, %1379) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1381 = "llvm.and"(%1380, %1351) : (i64, i64) -> i64
  %1382 = "llvm.getelementptr"(%arg71) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %1383 = "llvm.load"(%1382) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1384 = "llvm.ashr"(%1380, %1352) : (i64, i64) -> i64
  %1385 = "llvm.add"(%1383, %1384) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1386 = "llvm.add"(%1385, %1355) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1387 = "llvm.lshr"(%1386, %1352) : (i64, i64) -> i64
  %1388 = "llvm.trunc"(%1387) <{overflowFlags = 3 : i32}> : (i64) -> i8
  %1389 = "llvm.call"(%1388) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %1390 = "llvm.zext"(%1389) : (i8) -> i64
  %1391 = "llvm.sub"(%1356, %1390) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1392 = "llvm.and"(%1391, %1357) : (i64, i64) -> i64
  %1393 = "llvm.add"(%1364, %1392) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1394 = "llvm.and"(%1393, %1351) : (i64, i64) -> i64
  %1395 = "llvm.and"(%1391, %1358) : (i64, i64) -> i64
  %1396 = "llvm.lshr"(%1393, %1359) : (i64, i64) -> i64
  %1397 = "llvm.add"(%1370, %1396) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1398 = "llvm.add"(%1397, %1395) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1399 = "llvm.and"(%1398, %1351) : (i64, i64) -> i64
  %1400 = "llvm.and"(%1391, %1360) : (i64, i64) -> i64
  %1401 = "llvm.lshr"(%1398, %1359) : (i64, i64) -> i64
  %1402 = "llvm.add"(%1376, %1401) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1403 = "llvm.add"(%1402, %1400) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1404 = "llvm.and"(%1403, %1351) : (i64, i64) -> i64
  %1405 = "llvm.lshr"(%1403, %1359) : (i64, i64) -> i64
  %1406 = "llvm.add"(%1381, %1405) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1407 = "llvm.and"(%1406, %1351) : (i64, i64) -> i64
  %1408 = "llvm.and"(%1391, %1361) : (i64, i64) -> i64
  %1409 = "llvm.lshr"(%1406, %1359) : (i64, i64) -> i64
  %1410 = "llvm.add"(%1386, %1409) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1411 = "llvm.add"(%1410, %1408) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1412 = "llvm.and"(%1411, %1351) : (i64, i64) -> i64
  "llvm.store"(%1394, %arg70) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1413 = "llvm.getelementptr"(%arg70) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1399, %1413) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1414 = "llvm.getelementptr"(%arg70) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1404, %1414) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1415 = "llvm.getelementptr"(%arg70) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1407, %1415) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1416 = "llvm.getelementptr"(%arg70) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1412, %1416) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
