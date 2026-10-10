#loop_annotation = #llvm.loop_annotation<mustProgress = true>
"llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<i32 (ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "ssp", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], res_attrs = [{llvm.range = #llvm.constant_range<i32, 0, 2>}], sym_name = "sc25519_is_canonical", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg37: !llvm.ptr):
  %1522 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %1523 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %1524 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1525 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %1526 = "llvm.mlir.addressof"() <{global_name = @sc25519_is_canonical.L}> : () -> !llvm.ptr
  %1527 = "llvm.mlir.constant"() <{value = 8 : i32}> : () -> i32
  %1528 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
  %1529 = "llvm.mlir.constant"() <{value = -2 : i64}> : () -> i64
  %1530 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  "llvm.br"(%1522, %1523, %1524)[^bb1] : (i64, i32, i32) -> ()
^bb1(%1531: i64, %1532: i32, %1533: i32):  // 2 preds: ^bb0, ^bb1
  %1534 = "llvm.add"(%1531, %1525) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1535 = "llvm.getelementptr"(%arg37, %1534) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1536 = "llvm.load"(%1535) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1537 = "llvm.zext"(%1536) : (i8) -> i32
  %1538 = "llvm.getelementptr"(%1526, %1534) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1539 = "llvm.load"(%1538) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1540 = "llvm.zext"(%1539) : (i8) -> i32
  %1541 = "llvm.sub"(%1537, %1540) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %1542 = "llvm.ashr"(%1541, %1527) : (i32, i32) -> i32
  %1543 = "llvm.and"(%1542, %1533) : (i32, i32) -> i32
  %1544 = "llvm.or"(%1543, %1532) : (i32, i32) -> i32
  %1545 = "llvm.xor"(%1540, %1537) : (i32, i32) -> i32
  %1546 = "llvm.add"(%1545, %1528) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %1547 = "llvm.ashr"(%1546, %1527) : (i32, i32) -> i32
  %1548 = "llvm.and"(%1547, %1533) : (i32, i32) -> i32
  %1549 = "llvm.add"(%1531, %1529) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1550 = "llvm.getelementptr"(%arg37, %1549) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1551 = "llvm.load"(%1550) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1552 = "llvm.zext"(%1551) : (i8) -> i32
  %1553 = "llvm.getelementptr"(%1526, %1549) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1554 = "llvm.load"(%1553) <{alignment = 2 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1555 = "llvm.zext"(%1554) : (i8) -> i32
  %1556 = "llvm.sub"(%1552, %1555) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %1557 = "llvm.ashr"(%1556, %1527) : (i32, i32) -> i32
  %1558 = "llvm.and"(%1557, %1548) : (i32, i32) -> i32
  %1559 = "llvm.or"(%1558, %1544) : (i32, i32) -> i32
  %1560 = "llvm.xor"(%1555, %1552) : (i32, i32) -> i32
  %1561 = "llvm.add"(%1560, %1528) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %1562 = "llvm.ashr"(%1561, %1527) : (i32, i32) -> i32
  %1563 = "llvm.and"(%1562, %1548) : (i32, i32) -> i32
  %1564 = "llvm.icmp"(%1549, %1530) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1564, %1549, %1559, %1563)[^bb2, ^bb1] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 3>}> : (i1, i64, i32, i32) -> ()
^bb2:  // pred: ^bb1
  %1565 = "llvm.icmp"(%1559, %1523) <{predicate = 1 : i64}> : (i32, i32) -> i1
  %1566 = "llvm.zext"(%1565) : (i1) -> i32
  "llvm.return"(%1566) : (i32) -> ()
}) : () -> ()
