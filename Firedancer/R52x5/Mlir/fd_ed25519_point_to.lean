module

-- ~/fd-pr9879/build/llvm23-production/mlir_canonicalized/avx512/op/fd_ed25519_point_to.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Firedancer.R52x5

@[expose] public section

mlir_def fd_ed25519_point_to :=
#tbaa_root = #llvm.tbaa_root<id = "Simple C/C++ TBAA">
#tbaa_type_desc = #llvm.tbaa_type_desc<id = "omnipotent char", members = {<#tbaa_root, 0>}>
#tbaa_tag = #llvm.tbaa_tag<base_type = #tbaa_type_desc, access_type = #tbaa_type_desc, offset = 0>
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr, ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], sym_name = "fd_ed25519_point_to", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg66: !llvm.ptr, %arg67: !llvm.ptr, %arg68: !llvm.ptr, %arg69: !llvm.ptr, %arg70: !llvm.ptr):
  %1478 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %1479 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %1480 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %1481 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %1482 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %1483 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %1484 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1485 = "llvm.mlir.poison"() : () -> vector<4xi64>
  %1486 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %1487 = "llvm.mlir.poison"() : () -> i64
  %1488 = "llvm.mlir.undef"() : () -> vector<8xi64>
  %1489 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %1490 = "llvm.insertelement"(%1488, %1487, %1489) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1491 = "llvm.insertelement"(%1490, %1487, %1484) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1492 = "llvm.insertelement"(%1491, %1487, %1483) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1493 = "llvm.insertelement"(%1492, %1487, %1482) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1494 = "llvm.insertelement"(%1493, %1487, %1481) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1495 = "llvm.insertelement"(%1494, %1486, %1480) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1496 = "llvm.insertelement"(%1495, %1486, %1479) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1497 = "llvm.insertelement"(%1496, %1486, %1478) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1498 = "llvm.load"(%arg70) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %1499 = "llvm.shufflevector"(%1498, %1485) <{mask = array<i32: -1, -1, -1, 3, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %1500 = "llvm.shufflevector"(%1498, %1485) <{mask = array<i32: -1, -1, 2, -1, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %1501 = "llvm.shufflevector"(%1498, %1485) <{mask = array<i32: -1, 1, -1, -1, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %1502 = "llvm.shufflevector"(%1498, %1485) <{mask = array<i32: 0, -1, -1, -1, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %1503 = "llvm.getelementptr"(%arg70) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %1504 = "llvm.load"(%1503) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %1505 = "llvm.shufflevector"(%1504, %1485) <{mask = array<i32: -1, -1, -1, 3, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %1506 = "llvm.shufflevector"(%1504, %1485) <{mask = array<i32: -1, -1, 2, -1, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %1507 = "llvm.shufflevector"(%1504, %1485) <{mask = array<i32: -1, 1, -1, -1, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %1508 = "llvm.shufflevector"(%1504, %1485) <{mask = array<i32: 0, -1, -1, -1, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %1509 = "llvm.getelementptr"(%arg70) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %1510 = "llvm.load"(%1509) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %1511 = "llvm.shufflevector"(%1510, %1485) <{mask = array<i32: -1, -1, -1, 3, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %1512 = "llvm.shufflevector"(%1510, %1485) <{mask = array<i32: -1, -1, 2, -1, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %1513 = "llvm.shufflevector"(%1510, %1485) <{mask = array<i32: -1, 1, -1, -1, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %1514 = "llvm.shufflevector"(%1510, %1485) <{mask = array<i32: 0, -1, -1, -1, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %1515 = "llvm.getelementptr"(%arg70) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %1516 = "llvm.load"(%1515) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %1517 = "llvm.shufflevector"(%1516, %1485) <{mask = array<i32: -1, -1, -1, 3, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %1518 = "llvm.shufflevector"(%1516, %1485) <{mask = array<i32: -1, -1, 2, -1, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %1519 = "llvm.shufflevector"(%1516, %1485) <{mask = array<i32: -1, 1, -1, -1, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %1520 = "llvm.shufflevector"(%1516, %1485) <{mask = array<i32: 0, -1, -1, -1, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %1521 = "llvm.getelementptr"(%arg70) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %1522 = "llvm.load"(%1521) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %1523 = "llvm.shufflevector"(%1522, %1485) <{mask = array<i32: -1, -1, -1, 3, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %1524 = "llvm.shufflevector"(%1522, %1485) <{mask = array<i32: -1, -1, 2, -1, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %1525 = "llvm.shufflevector"(%1522, %1485) <{mask = array<i32: -1, 1, -1, -1, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %1526 = "llvm.shufflevector"(%1522, %1485) <{mask = array<i32: 0, -1, -1, -1, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %1527 = "llvm.shufflevector"(%1502, %1497) <{mask = array<i32: 0, -1, -1, -1, -1, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1528 = "llvm.shufflevector"(%1527, %1508) <{mask = array<i32: 0, 8, -1, -1, -1, 5, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1529 = "llvm.shufflevector"(%1528, %1514) <{mask = array<i32: 0, 1, 8, -1, -1, 5, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1530 = "llvm.shufflevector"(%1529, %1520) <{mask = array<i32: 0, 1, 2, 8, -1, 5, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1531 = "llvm.shufflevector"(%1530, %1526) <{mask = array<i32: 0, 1, 2, 3, 8, 5, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1531, %arg66) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1532 = "llvm.shufflevector"(%1497, %1501) <{mask = array<i32: 9, -1, -1, -1, -1, 5, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1533 = "llvm.shufflevector"(%1532, %1507) <{mask = array<i32: 0, 9, -1, -1, -1, 5, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1534 = "llvm.shufflevector"(%1533, %1513) <{mask = array<i32: 0, 1, 9, -1, -1, 5, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1535 = "llvm.shufflevector"(%1534, %1519) <{mask = array<i32: 0, 1, 2, 9, -1, 5, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1536 = "llvm.shufflevector"(%1535, %1525) <{mask = array<i32: 0, 1, 2, 3, 9, 5, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1536, %arg67) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1537 = "llvm.shufflevector"(%1497, %1500) <{mask = array<i32: 10, -1, -1, -1, -1, 5, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1538 = "llvm.shufflevector"(%1537, %1506) <{mask = array<i32: 0, 10, -1, -1, -1, 5, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1539 = "llvm.shufflevector"(%1538, %1512) <{mask = array<i32: 0, 1, 10, -1, -1, 5, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1540 = "llvm.shufflevector"(%1539, %1518) <{mask = array<i32: 0, 1, 2, 10, -1, 5, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1541 = "llvm.shufflevector"(%1540, %1524) <{mask = array<i32: 0, 1, 2, 3, 10, 5, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1541, %arg68) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1542 = "llvm.shufflevector"(%1497, %1499) <{mask = array<i32: 11, -1, -1, -1, -1, 5, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1543 = "llvm.shufflevector"(%1542, %1505) <{mask = array<i32: 0, 11, -1, -1, -1, 5, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1544 = "llvm.shufflevector"(%1543, %1511) <{mask = array<i32: 0, 1, 11, -1, -1, 5, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1545 = "llvm.shufflevector"(%1544, %1517) <{mask = array<i32: 0, 1, 2, 11, -1, 5, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1546 = "llvm.shufflevector"(%1545, %1523) <{mask = array<i32: 0, 1, 2, 3, 11, 5, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1546, %arg69) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end MLIR.Firedancer.R52x5
