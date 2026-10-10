module

-- boringssl-build/out/op/_ZL23fiat_25519_carry_squarePmPKm.mlir
-- fiat_25519_carry_square(unsigned long*, unsigned long const*)

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Boringssl

@[expose] public section

mlir_def fiat_25519_carry_square :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"], ["warn-stack-size", "25344"]], sym_name = "_ZL23fiat_25519_carry_squarePmPKm", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg126: !llvm.ptr, %arg127: !llvm.ptr):
  %1515 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %1516 = "llvm.mlir.constant"() <{value = 38 : i64}> : () -> i64
  %1517 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %1518 = "llvm.mlir.constant"() <{value = 51 : i128}> : () -> i128
  %1519 = "llvm.mlir.constant"() <{value = 2251799813685247 : i64}> : () -> i64
  %1520 = "llvm.mlir.constant"() <{value = 18446744073709551615 : i128}> : () -> i128
  %1521 = "llvm.mlir.constant"() <{value = 51 : i64}> : () -> i64
  %1522 = "llvm.getelementptr"(%arg127) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %1523 = "llvm.load"(%1522) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1524 = "llvm.mul"(%1523, %1515) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1525 = "llvm.mul"(%1523, %1516) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1526 = "llvm.shl"(%1523, %1517) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1527 = "llvm.getelementptr"(%arg127) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %1528 = "llvm.load"(%1527) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1529 = "llvm.mul"(%1528, %1515) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1530 = "llvm.mul"(%1528, %1516) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1531 = "llvm.shl"(%1528, %1517) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1532 = "llvm.getelementptr"(%arg127) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %1533 = "llvm.load"(%1532) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1534 = "llvm.shl"(%1533, %1517) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1535 = "llvm.getelementptr"(%arg127) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %1536 = "llvm.load"(%1535) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1537 = "llvm.shl"(%1536, %1517) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1538 = "llvm.zext"(%1523) : (i64) -> i128
  %1539 = "llvm.zext"(%1524) : (i64) -> i128
  %1540 = "llvm.mul"(%1539, %1538) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1541 = "llvm.zext"(%1528) : (i64) -> i128
  %1542 = "llvm.zext"(%1525) : (i64) -> i128
  %1543 = "llvm.mul"(%1541, %1542) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1544 = "llvm.zext"(%1529) : (i64) -> i128
  %1545 = "llvm.mul"(%1544, %1541) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1546 = "llvm.zext"(%1533) : (i64) -> i128
  %1547 = "llvm.mul"(%1546, %1542) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1548 = "llvm.zext"(%1530) : (i64) -> i128
  %1549 = "llvm.mul"(%1546, %1548) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1550 = "llvm.mul"(%1546, %1546) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1551 = "llvm.zext"(%1536) : (i64) -> i128
  %1552 = "llvm.mul"(%1551, %1542) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1553 = "llvm.zext"(%1531) : (i64) -> i128
  %1554 = "llvm.mul"(%1551, %1553) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1555 = "llvm.zext"(%1534) : (i64) -> i128
  %1556 = "llvm.mul"(%1551, %1555) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1557 = "llvm.mul"(%1551, %1551) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1558 = "llvm.load"(%arg127) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1559 = "llvm.zext"(%1558) : (i64) -> i128
  %1560 = "llvm.zext"(%1526) : (i64) -> i128
  %1561 = "llvm.mul"(%1559, %1560) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1562 = "llvm.mul"(%1559, %1553) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1563 = "llvm.mul"(%1559, %1555) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1564 = "llvm.zext"(%1537) : (i64) -> i128
  %1565 = "llvm.mul"(%1559, %1564) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1566 = "llvm.mul"(%1559, %1559) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1567 = "llvm.add"(%1552, %1549) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1568 = "llvm.add"(%1567, %1566) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1569 = "llvm.lshr"(%1568, %1518) : (i128, i128) -> i128
  %1570 = "llvm.trunc"(%1568) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %1571 = "llvm.and"(%1570, %1519) : (i64, i64) -> i64
  %1572 = "llvm.add"(%1554, %1550) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1573 = "llvm.add"(%1572, %1561) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1574 = "llvm.add"(%1556, %1540) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1575 = "llvm.add"(%1574, %1562) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1576 = "llvm.add"(%1557, %1543) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1577 = "llvm.add"(%1576, %1563) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1578 = "llvm.add"(%1547, %1545) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1579 = "llvm.add"(%1578, %1565) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1580 = "llvm.and"(%1569, %1520) : (i128, i128) -> i128
  %1581 = "llvm.add"(%1579, %1580) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1582 = "llvm.lshr"(%1581, %1518) : (i128, i128) -> i128
  %1583 = "llvm.trunc"(%1581) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %1584 = "llvm.and"(%1583, %1519) : (i64, i64) -> i64
  %1585 = "llvm.and"(%1582, %1520) : (i128, i128) -> i128
  %1586 = "llvm.add"(%1577, %1585) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1587 = "llvm.lshr"(%1586, %1518) : (i128, i128) -> i128
  %1588 = "llvm.trunc"(%1586) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %1589 = "llvm.and"(%1588, %1519) : (i64, i64) -> i64
  %1590 = "llvm.and"(%1587, %1520) : (i128, i128) -> i128
  %1591 = "llvm.add"(%1575, %1590) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1592 = "llvm.lshr"(%1591, %1518) : (i128, i128) -> i128
  %1593 = "llvm.trunc"(%1591) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %1594 = "llvm.and"(%1593, %1519) : (i64, i64) -> i64
  %1595 = "llvm.and"(%1592, %1520) : (i128, i128) -> i128
  %1596 = "llvm.add"(%1573, %1595) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1597 = "llvm.lshr"(%1596, %1518) : (i128, i128) -> i128
  %1598 = "llvm.trunc"(%1597) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %1599 = "llvm.trunc"(%1596) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %1600 = "llvm.and"(%1599, %1519) : (i64, i64) -> i64
  %1601 = "llvm.mul"(%1598, %1515) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1602 = "llvm.add"(%1601, %1571) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1603 = "llvm.lshr"(%1602, %1521) : (i64, i64) -> i64
  %1604 = "llvm.and"(%1602, %1519) : (i64, i64) -> i64
  %1605 = "llvm.add"(%1603, %1584) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1606 = "llvm.lshr"(%1605, %1521) : (i64, i64) -> i64
  %1607 = "llvm.and"(%1605, %1519) : (i64, i64) -> i64
  %1608 = "llvm.add"(%1606, %1589) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  "llvm.store"(%1604, %arg126) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1609 = "llvm.getelementptr"(%arg126) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1607, %1609) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1610 = "llvm.getelementptr"(%arg126) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1608, %1610) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1611 = "llvm.getelementptr"(%arg126) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1594, %1611) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1612 = "llvm.getelementptr"(%arg126) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1600, %1612) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end MLIR.Boringssl
