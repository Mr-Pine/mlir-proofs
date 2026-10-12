#alias_scope_domain73 = #llvm.alias_scope_domain<id = distinct[73]<>, description = "_RNvXNvMsb_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx25fieldNtB8_18FieldElement2625x47shuffleB1a_NtB2_16___Impl_shuffle__13__impl_shuffle">
#alias_scope_domain74 = #llvm.alias_scope_domain<id = distinct[74]<>, description = "_RNvXNvMsb_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx25fieldNtB8_18FieldElement2625x47shuffleB1a_NtB2_16___Impl_shuffle__13__impl_shuffle">
#alias_scope109 = #llvm.alias_scope<id = distinct[238]<>, domain = #alias_scope_domain73, description = "_RNvXNvMsb_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx25fieldNtB8_18FieldElement2625x47shuffleB1a_NtB2_16___Impl_shuffle__13__impl_shuffle: argument 1">
#alias_scope110 = #llvm.alias_scope<id = distinct[239]<>, domain = #alias_scope_domain73, description = "_RNvXNvMsb_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx25fieldNtB8_18FieldElement2625x47shuffleB1a_NtB2_16___Impl_shuffle__13__impl_shuffle: argument 0">
#alias_scope111 = #llvm.alias_scope<id = distinct[240]<>, domain = #alias_scope_domain74, description = "_RNvXNvMsb_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx25fieldNtB8_18FieldElement2625x47shuffleB1a_NtB2_16___Impl_shuffle__13__impl_shuffle: argument 1">
#alias_scope112 = #llvm.alias_scope<id = distinct[241]<>, domain = #alias_scope_domain74, description = "_RNvXNvMsb_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx25fieldNtB8_18FieldElement2625x47shuffleB1a_NtB2_16___Impl_shuffle__13__impl_shuffle: argument 0">
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 32 : i64, llvm.dead_on_unwind, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writable, llvm.writeonly}, {llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], sym_name = "_RNvXNvMs7_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx27edwardsNtB8_13ExtendedPoint6doubleB1c_NtB2_15___Impl_double__12__impl_double", target_cpu = "x86-64-v2", target_features = #llvm.target_features<["+avx", "+avx2", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+crc32", "+ssse3", "+avx", "+avx2", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+crc32", "+ssse3"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg50: !llvm.ptr, %arg51: !llvm.ptr):
  %1463 = "llvm.mlir.constant"() <{value = 134217726 : i32}> : () -> i32
  %1464 = "llvm.mlir.constant"() <{value = 134217690 : i32}> : () -> i32
  %1465 = "llvm.mlir.constant"() <{value = 67108862 : i32}> : () -> i32
  %1466 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %1467 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %1468 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %1469 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %1470 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %1471 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %1472 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1473 = "llvm.mlir.poison"() : () -> vector<8xi32>
  %1474 = "llvm.mlir.constant"() <{value = dense<1> : vector<8xi32>}> : () -> vector<8xi32>
  %1475 = "llvm.mlir.poison"() : () -> i32
  %1476 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %1477 = "llvm.mlir.undef"() : () -> vector<8xi32>
  %1478 = "llvm.insertelement"(%1477, %1476, %1476) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1479 = "llvm.insertelement"(%1478, %1476, %1472) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1480 = "llvm.insertelement"(%1479, %1476, %1471) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1481 = "llvm.insertelement"(%1480, %1476, %1470) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1482 = "llvm.insertelement"(%1481, %1475, %1469) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1483 = "llvm.insertelement"(%1482, %1475, %1468) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1484 = "llvm.insertelement"(%1483, %1475, %1467) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1485 = "llvm.insertelement"(%1484, %1475, %1466) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1486 = "llvm.insertelement"(%1477, %1475, %1476) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1487 = "llvm.insertelement"(%1486, %1476, %1472) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1488 = "llvm.insertelement"(%1487, %1475, %1471) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1489 = "llvm.insertelement"(%1488, %1476, %1470) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1490 = "llvm.insertelement"(%1489, %1476, %1469) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1491 = "llvm.insertelement"(%1490, %1475, %1468) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1492 = "llvm.insertelement"(%1491, %1476, %1467) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1493 = "llvm.insertelement"(%1492, %1475, %1466) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1494 = "llvm.insertelement"(%1477, %1475, %1476) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1495 = "llvm.insertelement"(%1494, %1464, %1472) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1496 = "llvm.insertelement"(%1495, %1475, %1471) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1497 = "llvm.insertelement"(%1496, %1465, %1470) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1498 = "llvm.insertelement"(%1497, %1464, %1469) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1499 = "llvm.insertelement"(%1498, %1475, %1468) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1500 = "llvm.insertelement"(%1499, %1465, %1467) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1501 = "llvm.insertelement"(%1500, %1475, %1466) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1502 = "llvm.insertelement"(%1477, %1475, %1476) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1503 = "llvm.insertelement"(%1502, %1463, %1472) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1504 = "llvm.insertelement"(%1503, %1475, %1471) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1505 = "llvm.insertelement"(%1504, %1465, %1470) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1506 = "llvm.insertelement"(%1505, %1463, %1469) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1507 = "llvm.insertelement"(%1506, %1475, %1468) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1508 = "llvm.insertelement"(%1507, %1465, %1467) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1509 = "llvm.insertelement"(%1508, %1475, %1466) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1510 = "llvm.insertelement"(%1477, %1476, %1476) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1511 = "llvm.insertelement"(%1510, %1475, %1472) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1512 = "llvm.insertelement"(%1511, %1476, %1471) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1513 = "llvm.insertelement"(%1512, %1475, %1470) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1514 = "llvm.insertelement"(%1513, %1475, %1469) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1515 = "llvm.insertelement"(%1514, %1476, %1468) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1516 = "llvm.insertelement"(%1515, %1475, %1467) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1517 = "llvm.insertelement"(%1516, %1476, %1466) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1518 = "llvm.alloca"(%1472) <{alignment = 32 : i64, elem_type = !llvm.array<160 x i8>}> : (i32) -> !llvm.ptr
  %1519 = "llvm.alloca"(%1472) <{alignment = 32 : i64, elem_type = !llvm.array<160 x i8>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%1519) : (!llvm.ptr) -> ()
  %1520 = "llvm.load"(%arg51) <{alias_scopes = [#alias_scope109], alignment = 32 : i64, noalias_scopes = [#alias_scope110], ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %1521 = "llvm.getelementptr"(%arg51) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %1522 = "llvm.load"(%1521) <{alias_scopes = [#alias_scope109], alignment = 32 : i64, noalias_scopes = [#alias_scope110], ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %1523 = "llvm.getelementptr"(%arg51) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %1524 = "llvm.load"(%1523) <{alias_scopes = [#alias_scope109], alignment = 32 : i64, noalias_scopes = [#alias_scope110], ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %1525 = "llvm.getelementptr"(%arg51) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %1526 = "llvm.load"(%1525) <{alias_scopes = [#alias_scope109], alignment = 32 : i64, noalias_scopes = [#alias_scope110], ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %1527 = "llvm.shufflevector"(%1520, %1473) <{mask = array<i32: -1, -1, -1, -1, -1, 1, -1, 3>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1528 = "llvm.shufflevector"(%1522, %1473) <{mask = array<i32: -1, -1, -1, -1, -1, 1, -1, 3>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1529 = "llvm.shufflevector"(%1524, %1473) <{mask = array<i32: -1, -1, -1, -1, -1, 1, -1, 3>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1530 = "llvm.shufflevector"(%1526, %1473) <{mask = array<i32: -1, -1, -1, -1, -1, 1, -1, 3>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1531 = "llvm.getelementptr"(%arg51) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %1532 = "llvm.load"(%1531) <{alias_scopes = [#alias_scope109], alignment = 32 : i64, noalias_scopes = [#alias_scope110], ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %1533 = "llvm.shufflevector"(%1532, %1473) <{mask = array<i32: -1, -1, -1, -1, -1, 1, -1, 3>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1534 = "llvm.getelementptr"(%1519) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %1535 = "llvm.getelementptr"(%1519) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %1536 = "llvm.getelementptr"(%1519) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %1537 = "llvm.getelementptr"(%1519) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%1518) : (!llvm.ptr) -> ()
  %1538 = "llvm.shufflevector"(%1520, %1473) <{mask = array<i32: -1, -1, -1, -1, -1, 0, -1, 2>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1539 = "llvm.shufflevector"(%1522, %1473) <{mask = array<i32: -1, -1, -1, -1, -1, 0, -1, 2>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1540 = "llvm.shufflevector"(%1524, %1473) <{mask = array<i32: -1, -1, -1, -1, -1, 0, -1, 2>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1541 = "llvm.shufflevector"(%1526, %1473) <{mask = array<i32: -1, -1, -1, -1, -1, 0, -1, 2>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1542 = "llvm.shufflevector"(%1532, %1473) <{mask = array<i32: -1, -1, -1, -1, -1, 0, -1, 2>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1543 = "llvm.getelementptr"(%1518) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %1544 = "llvm.getelementptr"(%1518) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %1545 = "llvm.getelementptr"(%1518) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %1546 = "llvm.getelementptr"(%1518) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %1547 = "llvm.add"(%1538, %1527) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1548 = "llvm.add"(%1539, %1528) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1549 = "llvm.add"(%1540, %1529) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1550 = "llvm.add"(%1541, %1530) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1551 = "llvm.add"(%1542, %1533) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1552 = "llvm.shufflevector"(%1520, %1547) <{mask = array<i32: 0, 1, 2, 3, 4, 13, 6, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1553 = "llvm.shufflevector"(%1522, %1548) <{mask = array<i32: 0, 1, 2, 3, 4, 13, 6, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1554 = "llvm.shufflevector"(%1524, %1549) <{mask = array<i32: 0, 1, 2, 3, 4, 13, 6, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1555 = "llvm.shufflevector"(%1526, %1550) <{mask = array<i32: 0, 1, 2, 3, 4, 13, 6, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1556 = "llvm.shufflevector"(%1532, %1551) <{mask = array<i32: 0, 1, 2, 3, 4, 13, 6, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  "llvm.store"(%1552, %1519) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  "llvm.store"(%1553, %1534) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  "llvm.store"(%1554, %1535) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  "llvm.store"(%1555, %1536) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  "llvm.store"(%1556, %1537) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  "llvm.call"(%1518, %1519) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvXNvMsb_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx25fieldNtB8_18FieldElement2625x419square_and_negate_DB1a_NtB2_28___Impl_square_and_negate_D__25__impl_square_and_negate_D, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %1557 = "llvm.load"(%1518) <{alias_scopes = [#alias_scope111], alignment = 32 : i64, noalias_scopes = [#alias_scope112], ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %1558 = "llvm.load"(%1543) <{alias_scopes = [#alias_scope111], alignment = 32 : i64, noalias_scopes = [#alias_scope112], ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %1559 = "llvm.load"(%1544) <{alias_scopes = [#alias_scope111], alignment = 32 : i64, noalias_scopes = [#alias_scope112], ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %1560 = "llvm.load"(%1545) <{alias_scopes = [#alias_scope111], alignment = 32 : i64, noalias_scopes = [#alias_scope112], ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %1561 = "llvm.shufflevector"(%1557, %1473) <{mask = array<i32: 0, 0, 2, 2, 0, 0, 2, 2>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1562 = "llvm.shufflevector"(%1558, %1473) <{mask = array<i32: 0, 0, 2, 2, 0, 0, 2, 2>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1563 = "llvm.shufflevector"(%1559, %1473) <{mask = array<i32: 0, 0, 2, 2, 0, 0, 2, 2>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1564 = "llvm.shufflevector"(%1560, %1473) <{mask = array<i32: 0, 0, 2, 2, 0, 0, 2, 2>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1565 = "llvm.load"(%1546) <{alias_scopes = [#alias_scope111], alignment = 32 : i64, noalias_scopes = [#alias_scope112], ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %1566 = "llvm.shufflevector"(%1565, %1473) <{mask = array<i32: 0, 0, 2, 2, 0, 0, 2, 2>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1567 = "llvm.shufflevector"(%1557, %1473) <{mask = array<i32: 1, 1, 3, 3, 1, 1, 3, 3>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1568 = "llvm.shufflevector"(%1558, %1473) <{mask = array<i32: 1, 1, 3, 3, 1, 1, 3, 3>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1569 = "llvm.shufflevector"(%1559, %1473) <{mask = array<i32: 1, 1, 3, 3, 1, 1, 3, 3>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1570 = "llvm.shufflevector"(%1560, %1473) <{mask = array<i32: 1, 1, 3, 3, 1, 1, 3, 3>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1571 = "llvm.shufflevector"(%1565, %1473) <{mask = array<i32: 1, 1, 3, 3, 1, 1, 3, 3>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1572 = "llvm.shl"(%1557, %1474) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1573 = "llvm.shl"(%1558, %1474) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1574 = "llvm.shl"(%1559, %1474) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1575 = "llvm.shl"(%1560, %1474) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1576 = "llvm.shl"(%1565, %1474) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1577 = "llvm.shufflevector"(%1485, %1572) <{mask = array<i32: 0, 1, 2, 3, 12, -1, 14, -1>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1578 = "llvm.shufflevector"(%1485, %1573) <{mask = array<i32: 0, 1, 2, 3, 12, -1, 14, -1>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1579 = "llvm.shufflevector"(%1485, %1574) <{mask = array<i32: 0, 1, 2, 3, 12, -1, 14, -1>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1580 = "llvm.shufflevector"(%1485, %1575) <{mask = array<i32: 0, 1, 2, 3, 12, -1, 14, -1>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1581 = "llvm.shufflevector"(%1485, %1576) <{mask = array<i32: 0, 1, 2, 3, 12, -1, 14, -1>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1582 = "llvm.shufflevector"(%1577, %1557) <{mask = array<i32: 0, 1, 2, 3, 4, 13, 6, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1583 = "llvm.shufflevector"(%1578, %1558) <{mask = array<i32: 0, 1, 2, 3, 4, 13, 6, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1584 = "llvm.shufflevector"(%1579, %1559) <{mask = array<i32: 0, 1, 2, 3, 4, 13, 6, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1585 = "llvm.shufflevector"(%1580, %1560) <{mask = array<i32: 0, 1, 2, 3, 4, 13, 6, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1586 = "llvm.shufflevector"(%1581, %1565) <{mask = array<i32: 0, 1, 2, 3, 4, 13, 6, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1587 = "llvm.add"(%1582, %1561) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1588 = "llvm.add"(%1583, %1562) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1589 = "llvm.add"(%1584, %1563) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1590 = "llvm.add"(%1585, %1564) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1591 = "llvm.add"(%1586, %1566) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1592 = "llvm.shufflevector"(%1567, %1493) <{mask = array<i32: 0, 9, 2, 11, 12, 5, 14, 7>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1593 = "llvm.shufflevector"(%1568, %1493) <{mask = array<i32: 0, 9, 2, 11, 12, 5, 14, 7>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1594 = "llvm.shufflevector"(%1569, %1493) <{mask = array<i32: 0, 9, 2, 11, 12, 5, 14, 7>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1595 = "llvm.shufflevector"(%1570, %1493) <{mask = array<i32: 0, 9, 2, 11, 12, 5, 14, 7>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1596 = "llvm.shufflevector"(%1571, %1493) <{mask = array<i32: 0, 9, 2, 11, 12, 5, 14, 7>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1597 = "llvm.add"(%1587, %1592) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1598 = "llvm.add"(%1588, %1593) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1599 = "llvm.add"(%1589, %1594) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1600 = "llvm.add"(%1590, %1595) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1601 = "llvm.add"(%1591, %1596) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1602 = "llvm.sub"(%1501, %1567) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1603 = "llvm.sub"(%1509, %1568) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1604 = "llvm.sub"(%1509, %1569) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1605 = "llvm.sub"(%1509, %1570) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1606 = "llvm.sub"(%1509, %1571) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1607 = "llvm.shufflevector"(%1517, %1602) <{mask = array<i32: 0, 9, 2, 11, 12, 5, 14, 7>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1608 = "llvm.shufflevector"(%1517, %1603) <{mask = array<i32: 0, 9, 2, 11, 12, 5, 14, 7>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1609 = "llvm.shufflevector"(%1517, %1604) <{mask = array<i32: 0, 9, 2, 11, 12, 5, 14, 7>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1610 = "llvm.shufflevector"(%1517, %1605) <{mask = array<i32: 0, 9, 2, 11, 12, 5, 14, 7>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1611 = "llvm.shufflevector"(%1517, %1606) <{mask = array<i32: 0, 9, 2, 11, 12, 5, 14, 7>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1612 = "llvm.add"(%1597, %1607) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1613 = "llvm.add"(%1598, %1608) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1614 = "llvm.add"(%1599, %1609) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1615 = "llvm.add"(%1600, %1610) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1616 = "llvm.add"(%1601, %1611) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1617 = "llvm.shufflevector"(%1612, %1473) <{mask = array<i32: 5, 1, 7, 3, 1, 5, 3, 7>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1618 = "llvm.shufflevector"(%1613, %1473) <{mask = array<i32: 5, 1, 7, 3, 1, 5, 3, 7>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1619 = "llvm.shufflevector"(%1614, %1473) <{mask = array<i32: 5, 1, 7, 3, 1, 5, 3, 7>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1620 = "llvm.shufflevector"(%1615, %1473) <{mask = array<i32: 5, 1, 7, 3, 1, 5, 3, 7>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1621 = "llvm.shufflevector"(%1616, %1473) <{mask = array<i32: 5, 1, 7, 3, 1, 5, 3, 7>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  "llvm.store"(%1617, %1518) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  "llvm.store"(%1618, %1543) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  "llvm.store"(%1619, %1544) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  "llvm.store"(%1620, %1545) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  "llvm.store"(%1621, %1546) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  %1622 = "llvm.shufflevector"(%1612, %1473) <{mask = array<i32: 4, 0, 6, 2, 4, 0, 6, 2>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1623 = "llvm.shufflevector"(%1613, %1473) <{mask = array<i32: 4, 0, 6, 2, 4, 0, 6, 2>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1624 = "llvm.shufflevector"(%1614, %1473) <{mask = array<i32: 4, 0, 6, 2, 4, 0, 6, 2>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1625 = "llvm.shufflevector"(%1615, %1473) <{mask = array<i32: 4, 0, 6, 2, 4, 0, 6, 2>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1626 = "llvm.shufflevector"(%1616, %1473) <{mask = array<i32: 4, 0, 6, 2, 4, 0, 6, 2>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  "llvm.store"(%1622, %1519) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  "llvm.store"(%1623, %1534) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  "llvm.store"(%1624, %1535) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  "llvm.store"(%1625, %1536) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  "llvm.store"(%1626, %1537) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  "llvm.call"(%arg50, %1519, %1518) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvXNvXsf_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx25fieldRNtB8_18FieldElement2625x4NtNtNtCsgxBkk5gSRhY_4core3ops5arith3Mul3mulB1a_NtB2_12___Impl_mul__9__impl_mul, fastmathFlags = #llvm.fastmath<none>, inline_hint, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1518) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1519) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
