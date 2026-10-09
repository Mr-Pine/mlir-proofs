module

-- ~/fd-pr9879/build/llvm23-production/mlir_canonicalized/avx512/op/fd_r52x5_ge_decode2.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.R52x5.Mlir.fd_f25519_add
public import Firedancer.R52x5.Mlir.fd_f25519_frombytes
public import Firedancer.R52x5.Mlir.fd_f25519_if
public import Firedancer.R52x5.Mlir.fd_f25519_is_nonzero
public import Firedancer.R52x5.Mlir.fd_f25519_mul2
public import Firedancer.R52x5.Mlir.fd_f25519_neg
public import Firedancer.R52x5.Mlir.fd_f25519_sgn
public import Firedancer.R52x5.Mlir.fd_f25519_sqr2
public import Firedancer.R52x5.Mlir.fd_f25519_sub
public import Firedancer.R52x5.Mlir.fd_memcpy
public import Firedancer.R52x5.Mlir.fd_r52x5_quad_mul_fast
public import Firedancer.R52x5.Mlir.fd_r52x5_quad_sqr_fast
public import Firedancer.R52x5.Mlir.wwl_st
public import Firedancer.R52x5.Mlir.fd_f25519_d
public import Firedancer.R52x5.Mlir.fd_f25519_one
public import Firedancer.R52x5.Mlir.fd_f25519_sqrtm1

meta import MLIR.Semantics.Func
meta import Firedancer.R52x5.Mlir.fd_f25519_add
meta import Firedancer.R52x5.Mlir.fd_f25519_frombytes
meta import Firedancer.R52x5.Mlir.fd_f25519_if
meta import Firedancer.R52x5.Mlir.fd_f25519_is_nonzero
meta import Firedancer.R52x5.Mlir.fd_f25519_mul2
meta import Firedancer.R52x5.Mlir.fd_f25519_neg
meta import Firedancer.R52x5.Mlir.fd_f25519_sgn
meta import Firedancer.R52x5.Mlir.fd_f25519_sqr2
meta import Firedancer.R52x5.Mlir.fd_f25519_sub
meta import Firedancer.R52x5.Mlir.fd_memcpy
meta import Firedancer.R52x5.Mlir.fd_r52x5_quad_mul_fast
meta import Firedancer.R52x5.Mlir.fd_r52x5_quad_sqr_fast
meta import Firedancer.R52x5.Mlir.wwl_st
meta import Firedancer.R52x5.Mlir.fd_f25519_d
meta import Firedancer.R52x5.Mlir.fd_f25519_one
meta import Firedancer.R52x5.Mlir.fd_f25519_sqrtm1

namespace MLIR.Firedancer.R52x5

@[expose] public section

mlir_def fd_r52x5_ge_decode2 :=
#loop_annotation = #llvm.loop_annotation<mustProgress = true>
#tbaa_root = #llvm.tbaa_root<id = "Simple C/C++ TBAA">
#tbaa_type_desc = #llvm.tbaa_type_desc<id = "omnipotent char", members = {<#tbaa_root, 0>}>
#tbaa_tag = #llvm.tbaa_tag<base_type = #tbaa_type_desc, access_type = #tbaa_type_desc, offset = 0>
#tbaa_type_desc1 = #llvm.tbaa_type_desc<id = "long", members = {<#tbaa_type_desc, 0>}>
#tbaa_tag1 = #llvm.tbaa_tag<base_type = #tbaa_type_desc1, access_type = #tbaa_type_desc1, offset = 0>
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<i32 (ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], res_attrs = [{llvm.range = #llvm.constant_range<i32, -2, 1>}], sym_name = "fd_r52x5_ge_decode2", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg73: !llvm.ptr, %arg74: !llvm.ptr, %arg75: !llvm.ptr, %arg76: !llvm.ptr, %arg77: !llvm.ptr, %arg78: !llvm.ptr, %arg79: !llvm.ptr, %arg80: !llvm.ptr, %arg81: !llvm.ptr, %arg82: !llvm.ptr, %arg83: !llvm.ptr, %arg84: !llvm.ptr):
  %1547 = "llvm.mlir.constant"() <{value = dense<[1, 0, 0, 0, 0, 0, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %1548 = "llvm.mlir.addressof"() <{global_name = @fd_f25519_sqrtm1}> : () -> !llvm.ptr
  %1549 = "llvm.mlir.constant"() <{value = -2 : i32}> : () -> i32
  %1550 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
  %1551 = "llvm.mlir.constant"() <{value = dense<0> : vector<4xi64>}> : () -> vector<4xi64>
  %1552 = "llvm.mlir.constant"() <{value = dense<[0, 1, 1, 0]> : vector<4xi64>}> : () -> vector<4xi64>
  %1553 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %1554 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %1555 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %1556 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %1557 = "llvm.mlir.undef"() : () -> vector<8xi64>
  %1558 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %1559 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %1560 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1561 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %1562 = "llvm.mlir.constant"() <{value = 127 : i8}> : () -> i8
  %1563 = "llvm.mlir.addressof"() <{global_name = @fd_f25519_one}> : () -> !llvm.ptr
  %1564 = "llvm.mlir.addressof"() <{global_name = @fd_f25519_d}> : () -> !llvm.ptr
  %1565 = "llvm.mlir.poison"() : () -> vector<4xi64>
  %1566 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %1567 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %1568 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %1569 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %1570 = "llvm.mlir.constant"() <{value = dense<51> : vector<4xi64>}> : () -> vector<4xi64>
  %1571 = "llvm.mlir.constant"() <{value = dense<2251799813685247> : vector<4xi64>}> : () -> vector<4xi64>
  %1572 = "llvm.mlir.constant"() <{value = dense<19> : vector<4xi64>}> : () -> vector<4xi64>
  %1573 = "llvm.mlir.constant"() <{value = 20 : i32}> : () -> i32
  %1574 = "llvm.mlir.constant"() <{value = 50 : i32}> : () -> i32
  %1575 = "llvm.mlir.constant"() <{value = 100 : i32}> : () -> i32
  %1576 = "llvm.mlir.constant"() <{value = 7 : i8}> : () -> i8
  %1577 = "llvm.mlir.poison"() : () -> i64
  %1578 = "llvm.mlir.constant"() <{value = 2251799813685247 : i64}> : () -> i64
  %1579 = "llvm.mlir.undef"() : () -> vector<4xi64>
  %1580 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %1581 = "llvm.insertelement"(%1579, %1578, %1580) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %1582 = "llvm.insertelement"(%1581, %1578, %1560) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %1583 = "llvm.insertelement"(%1582, %1577, %1559) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %1584 = "llvm.insertelement"(%1583, %1577, %1558) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %1585 = "llvm.insertelement"(%1557, %1577, %1580) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1586 = "llvm.insertelement"(%1585, %1577, %1560) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1587 = "llvm.insertelement"(%1586, %1577, %1559) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1588 = "llvm.insertelement"(%1587, %1577, %1558) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1589 = "llvm.insertelement"(%1588, %1577, %1556) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1590 = "llvm.insertelement"(%1589, %1566, %1555) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1591 = "llvm.insertelement"(%1590, %1566, %1554) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1592 = "llvm.insertelement"(%1591, %1566, %1553) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1593 = "llvm.alloca"(%1560) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %1594 = "llvm.alloca"(%1560) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %1595 = "llvm.alloca"(%1560) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %1596 = "llvm.alloca"(%1560) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %1597 = "llvm.alloca"(%1560) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %1598 = "llvm.alloca"(%1560) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %1599 = "llvm.alloca"(%1560) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %1600 = "llvm.alloca"(%1560) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %1601 = "llvm.alloca"(%1560) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %1602 = "llvm.alloca"(%1560) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %1603 = "llvm.alloca"(%1560) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %1604 = "llvm.alloca"(%1560) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %1605 = "llvm.alloca"(%1560) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %1606 = "llvm.alloca"(%1560) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %1607 = "llvm.alloca"(%1560) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %1608 = "llvm.alloca"(%1560) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %1609 = "llvm.alloca"(%1560) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %1610 = "llvm.alloca"(%1560) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %1611 = "llvm.alloca"(%1560) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %1612 = "llvm.alloca"(%1560) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %1613 = "llvm.alloca"(%1560) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %1614 = "llvm.alloca"(%1560) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %1615 = "llvm.alloca"(%1560) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %1616 = "llvm.alloca"(%1560) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %1617 = "llvm.alloca"(%1560) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %1618 = "llvm.alloca"(%1560) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %1619 = "llvm.alloca"(%1560) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %1620 = "llvm.alloca"(%1560) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %1621 = "llvm.alloca"(%1560) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %1622 = "llvm.alloca"(%1560) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %1623 = "llvm.alloca"(%1560) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %1624 = "llvm.alloca"(%1560) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %1625 = "llvm.alloca"(%1560) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %1626 = "llvm.alloca"(%1560) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %1627 = "llvm.alloca"(%1560) <{alignment = 16 : i64, elem_type = !llvm.array<32 x i8>}> : (i32) -> !llvm.ptr
  %1628 = "llvm.alloca"(%1560) <{alignment = 16 : i64, elem_type = !llvm.array<32 x i8>}> : (i32) -> !llvm.ptr
  %1629 = "llvm.alloca"(%1560) <{alignment = 64 : i64, elem_type = !llvm.array<8 x i64>}> : (i32) -> !llvm.ptr
  %1630 = "llvm.alloca"(%1560) <{alignment = 64 : i64, elem_type = !llvm.array<8 x i64>}> : (i32) -> !llvm.ptr
  %1631 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1632 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1633 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1634 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1635 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1636 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1637 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1638 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1639 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1640 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1641 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1642 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1643 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1644 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1645 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1646 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1647 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1648 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1649 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1650 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1651 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1652 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1653 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1654 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1655 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1656 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1657 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1658 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1659 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1660 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1661 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1662 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1663 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1664 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1665 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1666 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1667 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1668 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1669 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1670 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1671 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1672 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1673 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1674 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1675 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1676 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1677 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1678 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1679 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1680 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1681 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1682 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1683 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1684 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1685 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1686 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1687 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1688 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1689 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1690 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1691 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1692 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1693 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1694 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1695 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1696 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1697 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1698 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1699 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1700 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1701 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1702 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1703 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1704 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1705 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1706 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1707 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1708 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1709 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1710 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1711 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1712 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1713 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1714 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1715 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1716 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1717 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1718 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1719 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1720 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1721 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1722 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1723 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1724 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1725 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1726 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1727 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1728 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1729 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1730 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1731 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1732 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1733 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1734 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1735 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1736 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1737 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1738 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1739 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1740 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1741 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1742 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1743 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1744 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1745 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1746 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1747 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1748 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1749 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1750 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1751 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1752 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1753 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1754 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1755 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1756 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1757 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1758 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1759 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1760 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1761 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1762 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1763 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1764 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1765 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1766 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1767 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1768 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1769 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1770 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1771 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1772 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1773 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1774 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1775 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1776 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1777 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1778 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1779 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1780 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1781 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1782 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1783 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1784 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1785 = "llvm.alloca"(%1560) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1786 = "llvm.alloca"(%1560) <{alignment = 64 : i64, elem_type = !llvm.array<8 x i64>}> : (i32) -> !llvm.ptr
  %1787 = "llvm.alloca"(%1560) <{alignment = 64 : i64, elem_type = !llvm.array<8 x i64>}> : (i32) -> !llvm.ptr
  %1788 = "llvm.alloca"(%1560) <{alignment = 64 : i64, elem_type = !llvm.array<8 x i64>}> : (i32) -> !llvm.ptr
  %1789 = "llvm.alloca"(%1560) <{alignment = 64 : i64, elem_type = !llvm.array<8 x i64>}> : (i32) -> !llvm.ptr
  %1790 = "llvm.alloca"(%1560) <{alignment = 64 : i64, elem_type = !llvm.array<8 x i64>}> : (i32) -> !llvm.ptr
  %1791 = "llvm.alloca"(%1560) <{alignment = 64 : i64, elem_type = !llvm.array<8 x i64>}> : (i32) -> !llvm.ptr
  %1792 = "llvm.alloca"(%1560) <{alignment = 64 : i64, elem_type = !llvm.array<8 x i64>}> : (i32) -> !llvm.ptr
  %1793 = "llvm.alloca"(%1560) <{alignment = 64 : i64, elem_type = !llvm.array<8 x i64>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%1593) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1594) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1595) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1596) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1597) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1598) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1599) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1600) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1601) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1602) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1603) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1604) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1605) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1606) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1607) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1608) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1609) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1610) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1611) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1612) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1613) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1614) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1615) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1616) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1617) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1618) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1619) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1620) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1621) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1622) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1623) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1624) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1625) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1626) : (!llvm.ptr) -> ()
  %1794 = "llvm.getelementptr"(%arg78) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 31>}> : (!llvm.ptr) -> !llvm.ptr
  %1795 = "llvm.load"(%1794) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> i8
  %1796 = "llvm.getelementptr"(%arg84) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 31>}> : (!llvm.ptr) -> !llvm.ptr
  %1797 = "llvm.load"(%1796) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> i8
  "llvm.intr.lifetime.start"(%1627) : (!llvm.ptr) -> ()
  "llvm.call"(%1627, %arg78, %1561) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_memcpy, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %1798 = "llvm.getelementptr"(%1627) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 31>}> : (!llvm.ptr) -> !llvm.ptr
  %1799 = "llvm.load"(%1798) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> i8
  %1800 = "llvm.and"(%1799, %1562) : (i8, i8) -> i8
  "llvm.store"(%1800, %1798) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (i8, !llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1628) : (!llvm.ptr) -> ()
  "llvm.call"(%1628, %arg84, %1561) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_memcpy, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %1801 = "llvm.getelementptr"(%1628) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 31>}> : (!llvm.ptr) -> !llvm.ptr
  %1802 = "llvm.load"(%1801) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> i8
  %1803 = "llvm.and"(%1802, %1562) : (i8, i8) -> i8
  "llvm.store"(%1803, %1801) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (i8, !llvm.ptr) -> ()
  %1804 = "llvm.call"(%1593, %1627) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_f25519_frombytes, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %1805 = "llvm.call"(%1602, %1628) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_f25519_frombytes, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.call"(%1596, %1593, %1605, %1602) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_f25519_sqr2, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  %1806 = "llvm.call"(%1594, %1596, %1563) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_f25519_sub, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %1807 = "llvm.call"(%1603, %1605, %1563) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_f25519_sub, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.call"(%1595, %1564, %1596, %1604, %1564, %1605) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_f25519_mul2, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 6, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  %1808 = "llvm.call"(%1595, %1595, %1563) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_f25519_add, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %1809 = "llvm.call"(%1604, %1604, %1563) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_f25519_add, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.call"(%1597, %1595, %1606, %1604) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_f25519_sqr2, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%1599, %1597, %1608, %1606) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_f25519_sqr2, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%1598, %1595, %1597, %1607, %1604, %1606) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_f25519_mul2, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 6, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%1600, %1594, %1598, %1609, %1603, %1607) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_f25519_mul2, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 6, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%1601, %1600, %1599, %1610, %1609, %1608) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_f25519_mul2, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 6, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1629) : (!llvm.ptr) -> ()
  %1810 = "llvm.load"(%1601) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.call"(%1629, %1810) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @wwl_st, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> ()
  "llvm.intr.lifetime.start"(%1630) : (!llvm.ptr) -> ()
  %1811 = "llvm.load"(%1610) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.call"(%1630, %1811) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @wwl_st, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> ()
  %1812 = "llvm.load"(%1629) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %1813 = "llvm.load"(%1630) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %1814 = "llvm.insertelement"(%1565, %1812, %1566) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1815 = "llvm.insertelement"(%1814, %1813, %1567) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1816 = "llvm.insertelement"(%1815, %1812, %1568) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1817 = "llvm.insertelement"(%1816, %1813, %1569) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1818 = "llvm.getelementptr"(%1629) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %1819 = "llvm.load"(%1818) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %1820 = "llvm.getelementptr"(%1630) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %1821 = "llvm.load"(%1820) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %1822 = "llvm.insertelement"(%1565, %1819, %1566) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1823 = "llvm.insertelement"(%1822, %1821, %1567) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1824 = "llvm.insertelement"(%1823, %1819, %1568) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1825 = "llvm.insertelement"(%1824, %1821, %1569) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1826 = "llvm.getelementptr"(%1629) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %1827 = "llvm.load"(%1826) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %1828 = "llvm.getelementptr"(%1630) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %1829 = "llvm.load"(%1828) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %1830 = "llvm.insertelement"(%1565, %1827, %1566) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1831 = "llvm.insertelement"(%1830, %1829, %1567) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1832 = "llvm.insertelement"(%1831, %1827, %1568) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1833 = "llvm.insertelement"(%1832, %1829, %1569) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1834 = "llvm.getelementptr"(%1629) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %1835 = "llvm.load"(%1834) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %1836 = "llvm.getelementptr"(%1630) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %1837 = "llvm.load"(%1836) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %1838 = "llvm.insertelement"(%1565, %1835, %1566) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1839 = "llvm.insertelement"(%1838, %1837, %1567) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1840 = "llvm.insertelement"(%1839, %1835, %1568) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1841 = "llvm.insertelement"(%1840, %1837, %1569) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1842 = "llvm.getelementptr"(%1629) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %1843 = "llvm.load"(%1842) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %1844 = "llvm.getelementptr"(%1630) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %1845 = "llvm.load"(%1844) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %1846 = "llvm.insertelement"(%1565, %1843, %1566) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1847 = "llvm.insertelement"(%1846, %1845, %1567) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1848 = "llvm.insertelement"(%1847, %1843, %1568) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1849 = "llvm.insertelement"(%1848, %1845, %1569) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%1631) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1632) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1633) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1634) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1635) : (!llvm.ptr) -> ()
  "llvm.call"(%1631, %1632, %1633, %1634, %1635, %1817, %1825, %1833, %1841, %1849) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1850 = "llvm.load"(%1631) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %1851 = "llvm.load"(%1632) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %1852 = "llvm.load"(%1633) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %1853 = "llvm.load"(%1634) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %1854 = "llvm.load"(%1635) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1635) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1634) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1633) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1632) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1631) : (!llvm.ptr) -> ()
  %1855 = "llvm.lshr"(%1850, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1856 = "llvm.lshr"(%1851, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1857 = "llvm.lshr"(%1852, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1858 = "llvm.lshr"(%1853, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1859 = "llvm.lshr"(%1854, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1860 = "llvm.and"(%1850, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1861 = "llvm.call_intrinsic"(%1860, %1859, %1572) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1862 = "llvm.and"(%1851, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1863 = "llvm.add"(%1862, %1855) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1864 = "llvm.and"(%1852, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1865 = "llvm.add"(%1864, %1856) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1866 = "llvm.and"(%1853, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1867 = "llvm.add"(%1866, %1857) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1868 = "llvm.and"(%1854, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1869 = "llvm.add"(%1868, %1858) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%1636) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1637) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1638) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1639) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1640) : (!llvm.ptr) -> ()
  "llvm.call"(%1636, %1637, %1638, %1639, %1640, %1861, %1863, %1865, %1867, %1869) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1870 = "llvm.load"(%1636) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %1871 = "llvm.load"(%1637) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %1872 = "llvm.load"(%1638) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %1873 = "llvm.load"(%1639) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %1874 = "llvm.load"(%1640) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1640) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1639) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1638) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1637) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1636) : (!llvm.ptr) -> ()
  %1875 = "llvm.lshr"(%1870, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1876 = "llvm.lshr"(%1871, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1877 = "llvm.lshr"(%1872, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1878 = "llvm.lshr"(%1873, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1879 = "llvm.lshr"(%1874, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1880 = "llvm.and"(%1870, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1881 = "llvm.call_intrinsic"(%1880, %1879, %1572) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1882 = "llvm.and"(%1871, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1883 = "llvm.add"(%1882, %1875) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1884 = "llvm.and"(%1872, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1885 = "llvm.add"(%1884, %1876) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1886 = "llvm.and"(%1873, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1887 = "llvm.add"(%1886, %1877) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1888 = "llvm.and"(%1874, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1889 = "llvm.add"(%1888, %1878) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%1641) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1642) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1643) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1644) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1645) : (!llvm.ptr) -> ()
  "llvm.call"(%1641, %1642, %1643, %1644, %1645, %1881, %1883, %1885, %1887, %1889) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1890 = "llvm.load"(%1641) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %1891 = "llvm.load"(%1642) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %1892 = "llvm.load"(%1643) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %1893 = "llvm.load"(%1644) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %1894 = "llvm.load"(%1645) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1645) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1644) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1643) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1642) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1641) : (!llvm.ptr) -> ()
  %1895 = "llvm.lshr"(%1890, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1896 = "llvm.lshr"(%1891, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1897 = "llvm.lshr"(%1892, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1898 = "llvm.lshr"(%1893, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1899 = "llvm.lshr"(%1894, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1900 = "llvm.and"(%1890, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1901 = "llvm.call_intrinsic"(%1900, %1899, %1572) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1902 = "llvm.and"(%1891, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1903 = "llvm.add"(%1902, %1895) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1904 = "llvm.and"(%1892, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1905 = "llvm.add"(%1904, %1896) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1906 = "llvm.and"(%1893, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1907 = "llvm.add"(%1906, %1897) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1908 = "llvm.and"(%1894, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1909 = "llvm.add"(%1908, %1898) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%1646) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1647) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1648) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1649) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1650) : (!llvm.ptr) -> ()
  "llvm.call"(%1646, %1647, %1648, %1649, %1650, %1817, %1825, %1833, %1841, %1849, %1901, %1903, %1905, %1907, %1909) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1910 = "llvm.load"(%1646) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %1911 = "llvm.load"(%1647) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %1912 = "llvm.load"(%1648) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %1913 = "llvm.load"(%1649) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %1914 = "llvm.load"(%1650) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1650) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1649) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1648) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1647) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1646) : (!llvm.ptr) -> ()
  %1915 = "llvm.lshr"(%1910, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1916 = "llvm.lshr"(%1911, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1917 = "llvm.lshr"(%1912, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1918 = "llvm.lshr"(%1913, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1919 = "llvm.lshr"(%1914, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1920 = "llvm.and"(%1910, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1921 = "llvm.call_intrinsic"(%1920, %1919, %1572) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1922 = "llvm.and"(%1911, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1923 = "llvm.add"(%1922, %1915) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1924 = "llvm.and"(%1912, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1925 = "llvm.add"(%1924, %1916) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1926 = "llvm.and"(%1913, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1927 = "llvm.add"(%1926, %1917) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1928 = "llvm.and"(%1914, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1929 = "llvm.add"(%1928, %1918) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%1651) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1652) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1653) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1654) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1655) : (!llvm.ptr) -> ()
  "llvm.call"(%1651, %1652, %1653, %1654, %1655, %1861, %1863, %1865, %1867, %1869, %1921, %1923, %1925, %1927, %1929) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1930 = "llvm.load"(%1651) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %1931 = "llvm.load"(%1652) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %1932 = "llvm.load"(%1653) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %1933 = "llvm.load"(%1654) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %1934 = "llvm.load"(%1655) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1655) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1654) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1653) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1652) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1651) : (!llvm.ptr) -> ()
  %1935 = "llvm.lshr"(%1930, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1936 = "llvm.lshr"(%1931, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1937 = "llvm.lshr"(%1932, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1938 = "llvm.lshr"(%1933, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1939 = "llvm.lshr"(%1934, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1940 = "llvm.and"(%1930, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1941 = "llvm.call_intrinsic"(%1940, %1939, %1572) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1942 = "llvm.and"(%1931, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1943 = "llvm.add"(%1942, %1935) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1944 = "llvm.and"(%1932, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1945 = "llvm.add"(%1944, %1936) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1946 = "llvm.and"(%1933, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1947 = "llvm.add"(%1946, %1937) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1948 = "llvm.and"(%1934, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1949 = "llvm.add"(%1948, %1938) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%1656) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1657) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1658) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1659) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1660) : (!llvm.ptr) -> ()
  "llvm.call"(%1656, %1657, %1658, %1659, %1660, %1941, %1943, %1945, %1947, %1949) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1950 = "llvm.load"(%1656) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %1951 = "llvm.load"(%1657) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %1952 = "llvm.load"(%1658) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %1953 = "llvm.load"(%1659) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %1954 = "llvm.load"(%1660) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1660) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1659) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1658) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1657) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1656) : (!llvm.ptr) -> ()
  %1955 = "llvm.lshr"(%1950, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1956 = "llvm.lshr"(%1951, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1957 = "llvm.lshr"(%1952, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1958 = "llvm.lshr"(%1953, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1959 = "llvm.lshr"(%1954, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1960 = "llvm.and"(%1950, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1961 = "llvm.call_intrinsic"(%1960, %1959, %1572) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1962 = "llvm.and"(%1951, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1963 = "llvm.add"(%1962, %1955) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1964 = "llvm.and"(%1952, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1965 = "llvm.add"(%1964, %1956) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1966 = "llvm.and"(%1953, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1967 = "llvm.add"(%1966, %1957) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1968 = "llvm.and"(%1954, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1969 = "llvm.add"(%1968, %1958) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%1661) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1662) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1663) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1664) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1665) : (!llvm.ptr) -> ()
  "llvm.call"(%1661, %1662, %1663, %1664, %1665, %1921, %1923, %1925, %1927, %1929, %1961, %1963, %1965, %1967, %1969) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1970 = "llvm.load"(%1661) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %1971 = "llvm.load"(%1662) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %1972 = "llvm.load"(%1663) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %1973 = "llvm.load"(%1664) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %1974 = "llvm.load"(%1665) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1665) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1664) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1663) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1662) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1661) : (!llvm.ptr) -> ()
  %1975 = "llvm.lshr"(%1970, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1976 = "llvm.lshr"(%1971, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1977 = "llvm.lshr"(%1972, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1978 = "llvm.lshr"(%1973, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1979 = "llvm.lshr"(%1974, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1980 = "llvm.and"(%1970, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1981 = "llvm.call_intrinsic"(%1980, %1979, %1572) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1982 = "llvm.and"(%1971, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1983 = "llvm.add"(%1982, %1975) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1984 = "llvm.and"(%1972, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1985 = "llvm.add"(%1984, %1976) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1986 = "llvm.and"(%1973, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1987 = "llvm.add"(%1986, %1977) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1988 = "llvm.and"(%1974, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1989 = "llvm.add"(%1988, %1978) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%1666) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1667) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1668) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1669) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1670) : (!llvm.ptr) -> ()
  "llvm.call"(%1666, %1667, %1668, %1669, %1670, %1981, %1983, %1985, %1987, %1989) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1990 = "llvm.load"(%1666) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %1991 = "llvm.load"(%1667) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %1992 = "llvm.load"(%1668) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %1993 = "llvm.load"(%1669) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %1994 = "llvm.load"(%1670) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1670) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1669) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1668) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1667) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1666) : (!llvm.ptr) -> ()
  %1995 = "llvm.lshr"(%1990, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1996 = "llvm.lshr"(%1991, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1997 = "llvm.lshr"(%1992, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1998 = "llvm.lshr"(%1993, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1999 = "llvm.lshr"(%1994, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2000 = "llvm.and"(%1990, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2001 = "llvm.call_intrinsic"(%2000, %1999, %1572) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2002 = "llvm.and"(%1991, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2003 = "llvm.add"(%2002, %1995) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2004 = "llvm.and"(%1992, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2005 = "llvm.add"(%2004, %1996) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2006 = "llvm.and"(%1993, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2007 = "llvm.add"(%2006, %1997) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2008 = "llvm.and"(%1994, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2009 = "llvm.add"(%2008, %1998) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%1671) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1672) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1673) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1674) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1675) : (!llvm.ptr) -> ()
  "llvm.call"(%1671, %1672, %1673, %1674, %1675, %2001, %2003, %2005, %2007, %2009) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2010 = "llvm.load"(%1671) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2011 = "llvm.load"(%1672) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2012 = "llvm.load"(%1673) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2013 = "llvm.load"(%1674) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2014 = "llvm.load"(%1675) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1675) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1674) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1673) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1672) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1671) : (!llvm.ptr) -> ()
  %2015 = "llvm.lshr"(%2010, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2016 = "llvm.lshr"(%2011, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2017 = "llvm.lshr"(%2012, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2018 = "llvm.lshr"(%2013, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2019 = "llvm.lshr"(%2014, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2020 = "llvm.and"(%2010, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2021 = "llvm.call_intrinsic"(%2020, %2019, %1572) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2022 = "llvm.and"(%2011, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2023 = "llvm.add"(%2022, %2015) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2024 = "llvm.and"(%2012, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2025 = "llvm.add"(%2024, %2016) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2026 = "llvm.and"(%2013, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2027 = "llvm.add"(%2026, %2017) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2028 = "llvm.and"(%2014, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2029 = "llvm.add"(%2028, %2018) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%1671) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1672) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1673) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1674) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1675) : (!llvm.ptr) -> ()
  "llvm.call"(%1671, %1672, %1673, %1674, %1675, %2021, %2023, %2025, %2027, %2029) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2030 = "llvm.load"(%1671) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2031 = "llvm.load"(%1672) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2032 = "llvm.load"(%1673) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2033 = "llvm.load"(%1674) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2034 = "llvm.load"(%1675) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1675) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1674) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1673) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1672) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1671) : (!llvm.ptr) -> ()
  %2035 = "llvm.lshr"(%2030, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2036 = "llvm.lshr"(%2031, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2037 = "llvm.lshr"(%2032, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2038 = "llvm.lshr"(%2033, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2039 = "llvm.lshr"(%2034, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2040 = "llvm.and"(%2030, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2041 = "llvm.call_intrinsic"(%2040, %2039, %1572) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2042 = "llvm.and"(%2031, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2043 = "llvm.add"(%2042, %2035) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2044 = "llvm.and"(%2032, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2045 = "llvm.add"(%2044, %2036) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2046 = "llvm.and"(%2033, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2047 = "llvm.add"(%2046, %2037) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2048 = "llvm.and"(%2034, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2049 = "llvm.add"(%2048, %2038) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%1671) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1672) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1673) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1674) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1675) : (!llvm.ptr) -> ()
  "llvm.call"(%1671, %1672, %1673, %1674, %1675, %2041, %2043, %2045, %2047, %2049) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2050 = "llvm.load"(%1671) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2051 = "llvm.load"(%1672) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2052 = "llvm.load"(%1673) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2053 = "llvm.load"(%1674) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2054 = "llvm.load"(%1675) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1675) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1674) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1673) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1672) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1671) : (!llvm.ptr) -> ()
  %2055 = "llvm.lshr"(%2050, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2056 = "llvm.lshr"(%2051, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2057 = "llvm.lshr"(%2052, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2058 = "llvm.lshr"(%2053, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2059 = "llvm.lshr"(%2054, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2060 = "llvm.and"(%2050, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2061 = "llvm.call_intrinsic"(%2060, %2059, %1572) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2062 = "llvm.and"(%2051, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2063 = "llvm.add"(%2062, %2055) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2064 = "llvm.and"(%2052, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2065 = "llvm.add"(%2064, %2056) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2066 = "llvm.and"(%2053, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2067 = "llvm.add"(%2066, %2057) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2068 = "llvm.and"(%2054, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2069 = "llvm.add"(%2068, %2058) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%1671) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1672) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1673) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1674) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1675) : (!llvm.ptr) -> ()
  "llvm.call"(%1671, %1672, %1673, %1674, %1675, %2061, %2063, %2065, %2067, %2069) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2070 = "llvm.load"(%1671) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2071 = "llvm.load"(%1672) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2072 = "llvm.load"(%1673) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2073 = "llvm.load"(%1674) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2074 = "llvm.load"(%1675) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1675) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1674) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1673) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1672) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1671) : (!llvm.ptr) -> ()
  %2075 = "llvm.lshr"(%2070, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2076 = "llvm.lshr"(%2071, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2077 = "llvm.lshr"(%2072, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2078 = "llvm.lshr"(%2073, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2079 = "llvm.lshr"(%2074, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2080 = "llvm.and"(%2070, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2081 = "llvm.call_intrinsic"(%2080, %2079, %1572) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2082 = "llvm.and"(%2071, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2083 = "llvm.add"(%2082, %2075) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2084 = "llvm.and"(%2072, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2085 = "llvm.add"(%2084, %2076) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2086 = "llvm.and"(%2073, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2087 = "llvm.add"(%2086, %2077) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2088 = "llvm.and"(%2074, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2089 = "llvm.add"(%2088, %2078) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%1676) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1677) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1678) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1679) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1680) : (!llvm.ptr) -> ()
  "llvm.call"(%1676, %1677, %1678, %1679, %1680, %2081, %2083, %2085, %2087, %2089, %1981, %1983, %1985, %1987, %1989) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2090 = "llvm.load"(%1676) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2091 = "llvm.load"(%1677) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2092 = "llvm.load"(%1678) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2093 = "llvm.load"(%1679) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2094 = "llvm.load"(%1680) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1680) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1679) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1678) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1677) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1676) : (!llvm.ptr) -> ()
  %2095 = "llvm.lshr"(%2090, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2096 = "llvm.lshr"(%2091, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2097 = "llvm.lshr"(%2092, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2098 = "llvm.lshr"(%2093, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2099 = "llvm.lshr"(%2094, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2100 = "llvm.and"(%2090, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2101 = "llvm.call_intrinsic"(%2100, %2099, %1572) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2102 = "llvm.and"(%2091, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2103 = "llvm.add"(%2102, %2095) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2104 = "llvm.and"(%2092, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2105 = "llvm.add"(%2104, %2096) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2106 = "llvm.and"(%2093, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2107 = "llvm.add"(%2106, %2097) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2108 = "llvm.and"(%2094, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2109 = "llvm.add"(%2108, %2098) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%1681) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1682) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1683) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1684) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1685) : (!llvm.ptr) -> ()
  "llvm.call"(%1681, %1682, %1683, %1684, %1685, %2101, %2103, %2105, %2107, %2109) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2110 = "llvm.load"(%1681) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2111 = "llvm.load"(%1682) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2112 = "llvm.load"(%1683) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2113 = "llvm.load"(%1684) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2114 = "llvm.load"(%1685) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1685) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1684) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1683) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1682) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1681) : (!llvm.ptr) -> ()
  %2115 = "llvm.lshr"(%2110, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2116 = "llvm.lshr"(%2111, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2117 = "llvm.lshr"(%2112, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2118 = "llvm.lshr"(%2113, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2119 = "llvm.lshr"(%2114, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2120 = "llvm.and"(%2110, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2121 = "llvm.call_intrinsic"(%2120, %2119, %1572) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2122 = "llvm.and"(%2111, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2123 = "llvm.add"(%2122, %2115) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2124 = "llvm.and"(%2112, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2125 = "llvm.add"(%2124, %2116) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2126 = "llvm.and"(%2113, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2127 = "llvm.add"(%2126, %2117) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2128 = "llvm.and"(%2114, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2129 = "llvm.add"(%2128, %2118) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%1686) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1687) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1688) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1689) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1690) : (!llvm.ptr) -> ()
  "llvm.call"(%1686, %1687, %1688, %1689, %1690, %2121, %2123, %2125, %2127, %2129) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2130 = "llvm.load"(%1686) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2131 = "llvm.load"(%1687) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2132 = "llvm.load"(%1688) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2133 = "llvm.load"(%1689) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2134 = "llvm.load"(%1690) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1690) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1689) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1688) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1687) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1686) : (!llvm.ptr) -> ()
  %2135 = "llvm.lshr"(%2130, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2136 = "llvm.lshr"(%2131, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2137 = "llvm.lshr"(%2132, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2138 = "llvm.lshr"(%2133, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2139 = "llvm.lshr"(%2134, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2140 = "llvm.and"(%2130, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2141 = "llvm.call_intrinsic"(%2140, %2139, %1572) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2142 = "llvm.and"(%2131, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2143 = "llvm.add"(%2142, %2135) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2144 = "llvm.and"(%2132, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2145 = "llvm.add"(%2144, %2136) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2146 = "llvm.and"(%2133, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2147 = "llvm.add"(%2146, %2137) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2148 = "llvm.and"(%2134, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2149 = "llvm.add"(%2148, %2138) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%1686) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1687) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1688) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1689) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1690) : (!llvm.ptr) -> ()
  "llvm.call"(%1686, %1687, %1688, %1689, %1690, %2141, %2143, %2145, %2147, %2149) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2150 = "llvm.load"(%1686) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2151 = "llvm.load"(%1687) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2152 = "llvm.load"(%1688) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2153 = "llvm.load"(%1689) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2154 = "llvm.load"(%1690) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1690) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1689) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1688) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1687) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1686) : (!llvm.ptr) -> ()
  %2155 = "llvm.lshr"(%2150, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2156 = "llvm.lshr"(%2151, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2157 = "llvm.lshr"(%2152, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2158 = "llvm.lshr"(%2153, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2159 = "llvm.lshr"(%2154, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2160 = "llvm.and"(%2150, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2161 = "llvm.call_intrinsic"(%2160, %2159, %1572) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2162 = "llvm.and"(%2151, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2163 = "llvm.add"(%2162, %2155) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2164 = "llvm.and"(%2152, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2165 = "llvm.add"(%2164, %2156) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2166 = "llvm.and"(%2153, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2167 = "llvm.add"(%2166, %2157) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2168 = "llvm.and"(%2154, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2169 = "llvm.add"(%2168, %2158) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%1686) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1687) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1688) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1689) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1690) : (!llvm.ptr) -> ()
  "llvm.call"(%1686, %1687, %1688, %1689, %1690, %2161, %2163, %2165, %2167, %2169) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2170 = "llvm.load"(%1686) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2171 = "llvm.load"(%1687) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2172 = "llvm.load"(%1688) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2173 = "llvm.load"(%1689) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2174 = "llvm.load"(%1690) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1690) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1689) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1688) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1687) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1686) : (!llvm.ptr) -> ()
  %2175 = "llvm.lshr"(%2170, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2176 = "llvm.lshr"(%2171, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2177 = "llvm.lshr"(%2172, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2178 = "llvm.lshr"(%2173, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2179 = "llvm.lshr"(%2174, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2180 = "llvm.and"(%2170, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2181 = "llvm.call_intrinsic"(%2180, %2179, %1572) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2182 = "llvm.and"(%2171, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2183 = "llvm.add"(%2182, %2175) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2184 = "llvm.and"(%2172, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2185 = "llvm.add"(%2184, %2176) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2186 = "llvm.and"(%2173, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2187 = "llvm.add"(%2186, %2177) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2188 = "llvm.and"(%2174, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2189 = "llvm.add"(%2188, %2178) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%1686) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1687) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1688) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1689) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1690) : (!llvm.ptr) -> ()
  "llvm.call"(%1686, %1687, %1688, %1689, %1690, %2181, %2183, %2185, %2187, %2189) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2190 = "llvm.load"(%1686) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2191 = "llvm.load"(%1687) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2192 = "llvm.load"(%1688) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2193 = "llvm.load"(%1689) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2194 = "llvm.load"(%1690) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1690) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1689) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1688) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1687) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1686) : (!llvm.ptr) -> ()
  %2195 = "llvm.lshr"(%2190, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2196 = "llvm.lshr"(%2191, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2197 = "llvm.lshr"(%2192, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2198 = "llvm.lshr"(%2193, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2199 = "llvm.lshr"(%2194, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2200 = "llvm.and"(%2190, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2201 = "llvm.call_intrinsic"(%2200, %2199, %1572) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2202 = "llvm.and"(%2191, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2203 = "llvm.add"(%2202, %2195) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2204 = "llvm.and"(%2192, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2205 = "llvm.add"(%2204, %2196) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2206 = "llvm.and"(%2193, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2207 = "llvm.add"(%2206, %2197) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2208 = "llvm.and"(%2194, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2209 = "llvm.add"(%2208, %2198) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%1686) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1687) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1688) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1689) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1690) : (!llvm.ptr) -> ()
  "llvm.call"(%1686, %1687, %1688, %1689, %1690, %2201, %2203, %2205, %2207, %2209) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2210 = "llvm.load"(%1686) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2211 = "llvm.load"(%1687) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2212 = "llvm.load"(%1688) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2213 = "llvm.load"(%1689) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2214 = "llvm.load"(%1690) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1690) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1689) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1688) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1687) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1686) : (!llvm.ptr) -> ()
  %2215 = "llvm.lshr"(%2210, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2216 = "llvm.lshr"(%2211, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2217 = "llvm.lshr"(%2212, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2218 = "llvm.lshr"(%2213, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2219 = "llvm.lshr"(%2214, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2220 = "llvm.and"(%2210, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2221 = "llvm.call_intrinsic"(%2220, %2219, %1572) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2222 = "llvm.and"(%2211, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2223 = "llvm.add"(%2222, %2215) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2224 = "llvm.and"(%2212, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2225 = "llvm.add"(%2224, %2216) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2226 = "llvm.and"(%2213, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2227 = "llvm.add"(%2226, %2217) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2228 = "llvm.and"(%2214, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2229 = "llvm.add"(%2228, %2218) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%1686) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1687) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1688) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1689) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1690) : (!llvm.ptr) -> ()
  "llvm.call"(%1686, %1687, %1688, %1689, %1690, %2221, %2223, %2225, %2227, %2229) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2230 = "llvm.load"(%1686) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2231 = "llvm.load"(%1687) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2232 = "llvm.load"(%1688) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2233 = "llvm.load"(%1689) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2234 = "llvm.load"(%1690) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1690) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1689) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1688) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1687) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1686) : (!llvm.ptr) -> ()
  %2235 = "llvm.lshr"(%2230, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2236 = "llvm.lshr"(%2231, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2237 = "llvm.lshr"(%2232, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2238 = "llvm.lshr"(%2233, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2239 = "llvm.lshr"(%2234, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2240 = "llvm.and"(%2230, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2241 = "llvm.call_intrinsic"(%2240, %2239, %1572) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2242 = "llvm.and"(%2231, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2243 = "llvm.add"(%2242, %2235) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2244 = "llvm.and"(%2232, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2245 = "llvm.add"(%2244, %2236) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2246 = "llvm.and"(%2233, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2247 = "llvm.add"(%2246, %2237) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2248 = "llvm.and"(%2234, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2249 = "llvm.add"(%2248, %2238) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%1686) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1687) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1688) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1689) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1690) : (!llvm.ptr) -> ()
  "llvm.call"(%1686, %1687, %1688, %1689, %1690, %2241, %2243, %2245, %2247, %2249) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2250 = "llvm.load"(%1686) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2251 = "llvm.load"(%1687) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2252 = "llvm.load"(%1688) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2253 = "llvm.load"(%1689) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2254 = "llvm.load"(%1690) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1690) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1689) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1688) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1687) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1686) : (!llvm.ptr) -> ()
  %2255 = "llvm.lshr"(%2250, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2256 = "llvm.lshr"(%2251, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2257 = "llvm.lshr"(%2252, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2258 = "llvm.lshr"(%2253, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2259 = "llvm.lshr"(%2254, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2260 = "llvm.and"(%2250, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2261 = "llvm.call_intrinsic"(%2260, %2259, %1572) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2262 = "llvm.and"(%2251, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2263 = "llvm.add"(%2262, %2255) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2264 = "llvm.and"(%2252, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2265 = "llvm.add"(%2264, %2256) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2266 = "llvm.and"(%2253, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2267 = "llvm.add"(%2266, %2257) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2268 = "llvm.and"(%2254, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2269 = "llvm.add"(%2268, %2258) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%1686) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1687) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1688) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1689) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1690) : (!llvm.ptr) -> ()
  "llvm.call"(%1686, %1687, %1688, %1689, %1690, %2261, %2263, %2265, %2267, %2269) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2270 = "llvm.load"(%1686) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2271 = "llvm.load"(%1687) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2272 = "llvm.load"(%1688) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2273 = "llvm.load"(%1689) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2274 = "llvm.load"(%1690) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1690) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1689) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1688) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1687) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1686) : (!llvm.ptr) -> ()
  %2275 = "llvm.lshr"(%2270, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2276 = "llvm.lshr"(%2271, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2277 = "llvm.lshr"(%2272, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2278 = "llvm.lshr"(%2273, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2279 = "llvm.lshr"(%2274, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2280 = "llvm.and"(%2270, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2281 = "llvm.call_intrinsic"(%2280, %2279, %1572) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2282 = "llvm.and"(%2271, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2283 = "llvm.add"(%2282, %2275) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2284 = "llvm.and"(%2272, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2285 = "llvm.add"(%2284, %2276) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2286 = "llvm.and"(%2273, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2287 = "llvm.add"(%2286, %2277) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2288 = "llvm.and"(%2274, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2289 = "llvm.add"(%2288, %2278) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%1686) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1687) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1688) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1689) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1690) : (!llvm.ptr) -> ()
  "llvm.call"(%1686, %1687, %1688, %1689, %1690, %2281, %2283, %2285, %2287, %2289) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2290 = "llvm.load"(%1686) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2291 = "llvm.load"(%1687) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2292 = "llvm.load"(%1688) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2293 = "llvm.load"(%1689) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2294 = "llvm.load"(%1690) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1690) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1689) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1688) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1687) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1686) : (!llvm.ptr) -> ()
  %2295 = "llvm.lshr"(%2290, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2296 = "llvm.lshr"(%2291, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2297 = "llvm.lshr"(%2292, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2298 = "llvm.lshr"(%2293, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2299 = "llvm.lshr"(%2294, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2300 = "llvm.and"(%2290, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2301 = "llvm.call_intrinsic"(%2300, %2299, %1572) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2302 = "llvm.and"(%2291, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2303 = "llvm.add"(%2302, %2295) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2304 = "llvm.and"(%2292, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2305 = "llvm.add"(%2304, %2296) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2306 = "llvm.and"(%2293, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2307 = "llvm.add"(%2306, %2297) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2308 = "llvm.and"(%2294, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2309 = "llvm.add"(%2308, %2298) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%1691) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1692) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1693) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1694) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1695) : (!llvm.ptr) -> ()
  "llvm.call"(%1691, %1692, %1693, %1694, %1695, %2301, %2303, %2305, %2307, %2309, %2101, %2103, %2105, %2107, %2109) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2310 = "llvm.load"(%1691) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2311 = "llvm.load"(%1692) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2312 = "llvm.load"(%1693) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2313 = "llvm.load"(%1694) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2314 = "llvm.load"(%1695) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1695) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1694) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1693) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1692) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1691) : (!llvm.ptr) -> ()
  %2315 = "llvm.lshr"(%2310, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2316 = "llvm.lshr"(%2311, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2317 = "llvm.lshr"(%2312, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2318 = "llvm.lshr"(%2313, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2319 = "llvm.lshr"(%2314, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2320 = "llvm.and"(%2310, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2321 = "llvm.call_intrinsic"(%2320, %2319, %1572) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2322 = "llvm.and"(%2311, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2323 = "llvm.add"(%2322, %2315) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2324 = "llvm.and"(%2312, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2325 = "llvm.add"(%2324, %2316) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2326 = "llvm.and"(%2313, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2327 = "llvm.add"(%2326, %2317) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2328 = "llvm.and"(%2314, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2329 = "llvm.add"(%2328, %2318) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%1696) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1697) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1698) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1699) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1700) : (!llvm.ptr) -> ()
  "llvm.call"(%1696, %1697, %1698, %1699, %1700, %2321, %2323, %2325, %2327, %2329) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2330 = "llvm.load"(%1696) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2331 = "llvm.load"(%1697) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2332 = "llvm.load"(%1698) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2333 = "llvm.load"(%1699) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2334 = "llvm.load"(%1700) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1700) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1699) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1698) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1697) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1696) : (!llvm.ptr) -> ()
  %2335 = "llvm.lshr"(%2330, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2336 = "llvm.lshr"(%2331, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2337 = "llvm.lshr"(%2332, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2338 = "llvm.lshr"(%2333, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2339 = "llvm.lshr"(%2334, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2340 = "llvm.and"(%2330, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2341 = "llvm.call_intrinsic"(%2340, %2339, %1572) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2342 = "llvm.and"(%2331, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2343 = "llvm.add"(%2342, %2335) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2344 = "llvm.and"(%2332, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2345 = "llvm.add"(%2344, %2336) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2346 = "llvm.and"(%2333, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2347 = "llvm.add"(%2346, %2337) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2348 = "llvm.and"(%2334, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2349 = "llvm.add"(%2348, %2338) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.br"(%2341, %2343, %2345, %2347, %2349, %1560)[^bb2] : (vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, i32) -> ()
^bb1:  // pred: ^bb2
  "llvm.intr.lifetime.start"(%1706) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1707) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1708) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1709) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1710) : (!llvm.ptr) -> ()
  "llvm.call"(%1706, %1707, %1708, %1709, %1710, %2627, %2629, %2631, %2633, %2635, %2321, %2323, %2325, %2327, %2329) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2350 = "llvm.load"(%1706) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2351 = "llvm.load"(%1707) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2352 = "llvm.load"(%1708) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2353 = "llvm.load"(%1709) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2354 = "llvm.load"(%1710) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1710) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1709) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1708) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1707) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1706) : (!llvm.ptr) -> ()
  %2355 = "llvm.lshr"(%2350, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2356 = "llvm.lshr"(%2351, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2357 = "llvm.lshr"(%2352, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2358 = "llvm.lshr"(%2353, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2359 = "llvm.lshr"(%2354, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2360 = "llvm.and"(%2350, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2361 = "llvm.call_intrinsic"(%2360, %2359, %1572) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2362 = "llvm.and"(%2351, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2363 = "llvm.add"(%2362, %2355) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2364 = "llvm.and"(%2352, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2365 = "llvm.add"(%2364, %2356) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2366 = "llvm.and"(%2353, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2367 = "llvm.add"(%2366, %2357) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2368 = "llvm.and"(%2354, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2369 = "llvm.add"(%2368, %2358) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%1711) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1712) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1713) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1714) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1715) : (!llvm.ptr) -> ()
  "llvm.call"(%1711, %1712, %1713, %1714, %1715, %2361, %2363, %2365, %2367, %2369) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2370 = "llvm.load"(%1711) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2371 = "llvm.load"(%1712) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2372 = "llvm.load"(%1713) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2373 = "llvm.load"(%1714) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2374 = "llvm.load"(%1715) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1715) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1714) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1713) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1712) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1711) : (!llvm.ptr) -> ()
  %2375 = "llvm.lshr"(%2370, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2376 = "llvm.lshr"(%2371, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2377 = "llvm.lshr"(%2372, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2378 = "llvm.lshr"(%2373, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2379 = "llvm.lshr"(%2374, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2380 = "llvm.and"(%2370, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2381 = "llvm.call_intrinsic"(%2380, %2379, %1572) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2382 = "llvm.and"(%2371, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2383 = "llvm.add"(%2382, %2375) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2384 = "llvm.and"(%2372, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2385 = "llvm.add"(%2384, %2376) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2386 = "llvm.and"(%2373, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2387 = "llvm.add"(%2386, %2377) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2388 = "llvm.and"(%2374, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2389 = "llvm.add"(%2388, %2378) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%1716) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1717) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1718) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1719) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1720) : (!llvm.ptr) -> ()
  "llvm.call"(%1716, %1717, %1718, %1719, %1720, %2381, %2383, %2385, %2387, %2389) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2390 = "llvm.load"(%1716) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2391 = "llvm.load"(%1717) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2392 = "llvm.load"(%1718) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2393 = "llvm.load"(%1719) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2394 = "llvm.load"(%1720) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1720) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1719) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1718) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1717) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1716) : (!llvm.ptr) -> ()
  %2395 = "llvm.lshr"(%2390, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2396 = "llvm.lshr"(%2391, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2397 = "llvm.lshr"(%2392, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2398 = "llvm.lshr"(%2393, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2399 = "llvm.lshr"(%2394, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2400 = "llvm.and"(%2390, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2401 = "llvm.call_intrinsic"(%2400, %2399, %1572) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2402 = "llvm.and"(%2391, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2403 = "llvm.add"(%2402, %2395) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2404 = "llvm.and"(%2392, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2405 = "llvm.add"(%2404, %2396) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2406 = "llvm.and"(%2393, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2407 = "llvm.add"(%2406, %2397) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2408 = "llvm.and"(%2394, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2409 = "llvm.add"(%2408, %2398) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%1716) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1717) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1718) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1719) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1720) : (!llvm.ptr) -> ()
  "llvm.call"(%1716, %1717, %1718, %1719, %1720, %2401, %2403, %2405, %2407, %2409) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2410 = "llvm.load"(%1716) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2411 = "llvm.load"(%1717) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2412 = "llvm.load"(%1718) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2413 = "llvm.load"(%1719) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2414 = "llvm.load"(%1720) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1720) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1719) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1718) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1717) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1716) : (!llvm.ptr) -> ()
  %2415 = "llvm.lshr"(%2410, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2416 = "llvm.lshr"(%2411, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2417 = "llvm.lshr"(%2412, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2418 = "llvm.lshr"(%2413, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2419 = "llvm.lshr"(%2414, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2420 = "llvm.and"(%2410, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2421 = "llvm.call_intrinsic"(%2420, %2419, %1572) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2422 = "llvm.and"(%2411, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2423 = "llvm.add"(%2422, %2415) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2424 = "llvm.and"(%2412, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2425 = "llvm.add"(%2424, %2416) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2426 = "llvm.and"(%2413, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2427 = "llvm.add"(%2426, %2417) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2428 = "llvm.and"(%2414, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2429 = "llvm.add"(%2428, %2418) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%1716) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1717) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1718) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1719) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1720) : (!llvm.ptr) -> ()
  "llvm.call"(%1716, %1717, %1718, %1719, %1720, %2421, %2423, %2425, %2427, %2429) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2430 = "llvm.load"(%1716) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2431 = "llvm.load"(%1717) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2432 = "llvm.load"(%1718) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2433 = "llvm.load"(%1719) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2434 = "llvm.load"(%1720) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1720) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1719) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1718) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1717) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1716) : (!llvm.ptr) -> ()
  %2435 = "llvm.lshr"(%2430, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2436 = "llvm.lshr"(%2431, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2437 = "llvm.lshr"(%2432, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2438 = "llvm.lshr"(%2433, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2439 = "llvm.lshr"(%2434, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2440 = "llvm.and"(%2430, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2441 = "llvm.call_intrinsic"(%2440, %2439, %1572) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2442 = "llvm.and"(%2431, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2443 = "llvm.add"(%2442, %2435) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2444 = "llvm.and"(%2432, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2445 = "llvm.add"(%2444, %2436) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2446 = "llvm.and"(%2433, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2447 = "llvm.add"(%2446, %2437) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2448 = "llvm.and"(%2434, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2449 = "llvm.add"(%2448, %2438) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%1716) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1717) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1718) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1719) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1720) : (!llvm.ptr) -> ()
  "llvm.call"(%1716, %1717, %1718, %1719, %1720, %2441, %2443, %2445, %2447, %2449) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2450 = "llvm.load"(%1716) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2451 = "llvm.load"(%1717) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2452 = "llvm.load"(%1718) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2453 = "llvm.load"(%1719) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2454 = "llvm.load"(%1720) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1720) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1719) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1718) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1717) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1716) : (!llvm.ptr) -> ()
  %2455 = "llvm.lshr"(%2450, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2456 = "llvm.lshr"(%2451, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2457 = "llvm.lshr"(%2452, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2458 = "llvm.lshr"(%2453, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2459 = "llvm.lshr"(%2454, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2460 = "llvm.and"(%2450, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2461 = "llvm.call_intrinsic"(%2460, %2459, %1572) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2462 = "llvm.and"(%2451, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2463 = "llvm.add"(%2462, %2455) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2464 = "llvm.and"(%2452, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2465 = "llvm.add"(%2464, %2456) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2466 = "llvm.and"(%2453, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2467 = "llvm.add"(%2466, %2457) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2468 = "llvm.and"(%2454, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2469 = "llvm.add"(%2468, %2458) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%1716) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1717) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1718) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1719) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1720) : (!llvm.ptr) -> ()
  "llvm.call"(%1716, %1717, %1718, %1719, %1720, %2461, %2463, %2465, %2467, %2469) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2470 = "llvm.load"(%1716) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2471 = "llvm.load"(%1717) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2472 = "llvm.load"(%1718) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2473 = "llvm.load"(%1719) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2474 = "llvm.load"(%1720) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1720) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1719) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1718) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1717) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1716) : (!llvm.ptr) -> ()
  %2475 = "llvm.lshr"(%2470, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2476 = "llvm.lshr"(%2471, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2477 = "llvm.lshr"(%2472, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2478 = "llvm.lshr"(%2473, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2479 = "llvm.lshr"(%2474, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2480 = "llvm.and"(%2470, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2481 = "llvm.call_intrinsic"(%2480, %2479, %1572) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2482 = "llvm.and"(%2471, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2483 = "llvm.add"(%2482, %2475) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2484 = "llvm.and"(%2472, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2485 = "llvm.add"(%2484, %2476) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2486 = "llvm.and"(%2473, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2487 = "llvm.add"(%2486, %2477) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2488 = "llvm.and"(%2474, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2489 = "llvm.add"(%2488, %2478) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%1716) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1717) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1718) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1719) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1720) : (!llvm.ptr) -> ()
  "llvm.call"(%1716, %1717, %1718, %1719, %1720, %2481, %2483, %2485, %2487, %2489) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2490 = "llvm.load"(%1716) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2491 = "llvm.load"(%1717) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2492 = "llvm.load"(%1718) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2493 = "llvm.load"(%1719) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2494 = "llvm.load"(%1720) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1720) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1719) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1718) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1717) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1716) : (!llvm.ptr) -> ()
  %2495 = "llvm.lshr"(%2490, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2496 = "llvm.lshr"(%2491, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2497 = "llvm.lshr"(%2492, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2498 = "llvm.lshr"(%2493, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2499 = "llvm.lshr"(%2494, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2500 = "llvm.and"(%2490, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2501 = "llvm.call_intrinsic"(%2500, %2499, %1572) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2502 = "llvm.and"(%2491, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2503 = "llvm.add"(%2502, %2495) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2504 = "llvm.and"(%2492, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2505 = "llvm.add"(%2504, %2496) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2506 = "llvm.and"(%2493, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2507 = "llvm.add"(%2506, %2497) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2508 = "llvm.and"(%2494, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2509 = "llvm.add"(%2508, %2498) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%1716) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1717) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1718) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1719) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1720) : (!llvm.ptr) -> ()
  "llvm.call"(%1716, %1717, %1718, %1719, %1720, %2501, %2503, %2505, %2507, %2509) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2510 = "llvm.load"(%1716) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2511 = "llvm.load"(%1717) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2512 = "llvm.load"(%1718) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2513 = "llvm.load"(%1719) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2514 = "llvm.load"(%1720) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1720) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1719) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1718) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1717) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1716) : (!llvm.ptr) -> ()
  %2515 = "llvm.lshr"(%2510, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2516 = "llvm.lshr"(%2511, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2517 = "llvm.lshr"(%2512, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2518 = "llvm.lshr"(%2513, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2519 = "llvm.lshr"(%2514, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2520 = "llvm.and"(%2510, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2521 = "llvm.call_intrinsic"(%2520, %2519, %1572) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2522 = "llvm.and"(%2511, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2523 = "llvm.add"(%2522, %2515) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2524 = "llvm.and"(%2512, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2525 = "llvm.add"(%2524, %2516) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2526 = "llvm.and"(%2513, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2527 = "llvm.add"(%2526, %2517) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2528 = "llvm.and"(%2514, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2529 = "llvm.add"(%2528, %2518) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%1716) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1717) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1718) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1719) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1720) : (!llvm.ptr) -> ()
  "llvm.call"(%1716, %1717, %1718, %1719, %1720, %2521, %2523, %2525, %2527, %2529) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2530 = "llvm.load"(%1716) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2531 = "llvm.load"(%1717) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2532 = "llvm.load"(%1718) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2533 = "llvm.load"(%1719) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2534 = "llvm.load"(%1720) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1720) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1719) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1718) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1717) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1716) : (!llvm.ptr) -> ()
  %2535 = "llvm.lshr"(%2530, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2536 = "llvm.lshr"(%2531, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2537 = "llvm.lshr"(%2532, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2538 = "llvm.lshr"(%2533, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2539 = "llvm.lshr"(%2534, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2540 = "llvm.and"(%2530, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2541 = "llvm.call_intrinsic"(%2540, %2539, %1572) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2542 = "llvm.and"(%2531, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2543 = "llvm.add"(%2542, %2535) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2544 = "llvm.and"(%2532, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2545 = "llvm.add"(%2544, %2536) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2546 = "llvm.and"(%2533, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2547 = "llvm.add"(%2546, %2537) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2548 = "llvm.and"(%2534, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2549 = "llvm.add"(%2548, %2538) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%1716) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1717) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1718) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1719) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1720) : (!llvm.ptr) -> ()
  "llvm.call"(%1716, %1717, %1718, %1719, %1720, %2541, %2543, %2545, %2547, %2549) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2550 = "llvm.load"(%1716) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2551 = "llvm.load"(%1717) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2552 = "llvm.load"(%1718) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2553 = "llvm.load"(%1719) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2554 = "llvm.load"(%1720) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1720) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1719) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1718) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1717) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1716) : (!llvm.ptr) -> ()
  %2555 = "llvm.lshr"(%2550, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2556 = "llvm.lshr"(%2551, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2557 = "llvm.lshr"(%2552, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2558 = "llvm.lshr"(%2553, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2559 = "llvm.lshr"(%2554, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2560 = "llvm.and"(%2550, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2561 = "llvm.call_intrinsic"(%2560, %2559, %1572) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2562 = "llvm.and"(%2551, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2563 = "llvm.add"(%2562, %2555) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2564 = "llvm.and"(%2552, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2565 = "llvm.add"(%2564, %2556) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2566 = "llvm.and"(%2553, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2567 = "llvm.add"(%2566, %2557) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2568 = "llvm.and"(%2554, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2569 = "llvm.add"(%2568, %2558) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%1721) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1722) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1723) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1724) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1725) : (!llvm.ptr) -> ()
  "llvm.call"(%1721, %1722, %1723, %1724, %1725, %2561, %2563, %2565, %2567, %2569, %2101, %2103, %2105, %2107, %2109) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2570 = "llvm.load"(%1721) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2571 = "llvm.load"(%1722) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2572 = "llvm.load"(%1723) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2573 = "llvm.load"(%1724) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2574 = "llvm.load"(%1725) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1725) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1724) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1723) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1722) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1721) : (!llvm.ptr) -> ()
  %2575 = "llvm.lshr"(%2570, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2576 = "llvm.lshr"(%2571, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2577 = "llvm.lshr"(%2572, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2578 = "llvm.lshr"(%2573, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2579 = "llvm.lshr"(%2574, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2580 = "llvm.and"(%2570, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2581 = "llvm.call_intrinsic"(%2580, %2579, %1572) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2582 = "llvm.and"(%2571, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2583 = "llvm.add"(%2582, %2575) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2584 = "llvm.and"(%2572, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2585 = "llvm.add"(%2584, %2576) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2586 = "llvm.and"(%2573, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2587 = "llvm.add"(%2586, %2577) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2588 = "llvm.and"(%2574, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2589 = "llvm.add"(%2588, %2578) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%1726) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1727) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1728) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1729) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1730) : (!llvm.ptr) -> ()
  "llvm.call"(%1726, %1727, %1728, %1729, %1730, %2581, %2583, %2585, %2587, %2589) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2590 = "llvm.load"(%1726) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2591 = "llvm.load"(%1727) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2592 = "llvm.load"(%1728) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2593 = "llvm.load"(%1729) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2594 = "llvm.load"(%1730) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1730) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1729) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1728) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1727) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1726) : (!llvm.ptr) -> ()
  %2595 = "llvm.lshr"(%2590, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2596 = "llvm.lshr"(%2591, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2597 = "llvm.lshr"(%2592, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2598 = "llvm.lshr"(%2593, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2599 = "llvm.lshr"(%2594, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2600 = "llvm.and"(%2590, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2601 = "llvm.call_intrinsic"(%2600, %2599, %1572) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2602 = "llvm.and"(%2591, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2603 = "llvm.add"(%2602, %2595) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2604 = "llvm.and"(%2592, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2605 = "llvm.add"(%2604, %2596) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2606 = "llvm.and"(%2593, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2607 = "llvm.add"(%2606, %2597) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2608 = "llvm.and"(%2594, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2609 = "llvm.add"(%2608, %2598) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.br"(%2601, %2603, %2605, %2607, %2609, %1560)[^bb4] : (vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, i32) -> ()
^bb2(%2610: vector<4xi64>, %2611: vector<4xi64>, %2612: vector<4xi64>, %2613: vector<4xi64>, %2614: vector<4xi64>, %2615: i32):  // 2 preds: ^bb0, ^bb2
  "llvm.intr.lifetime.start"(%1701) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1702) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1703) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1704) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1705) : (!llvm.ptr) -> ()
  "llvm.call"(%1701, %1702, %1703, %1704, %1705, %2610, %2611, %2612, %2613, %2614) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2616 = "llvm.load"(%1701) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2617 = "llvm.load"(%1702) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2618 = "llvm.load"(%1703) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2619 = "llvm.load"(%1704) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2620 = "llvm.load"(%1705) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1705) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1704) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1703) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1702) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1701) : (!llvm.ptr) -> ()
  %2621 = "llvm.lshr"(%2616, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2622 = "llvm.lshr"(%2617, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2623 = "llvm.lshr"(%2618, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2624 = "llvm.lshr"(%2619, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2625 = "llvm.lshr"(%2620, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2626 = "llvm.and"(%2616, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2627 = "llvm.call_intrinsic"(%2626, %2625, %1572) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2628 = "llvm.and"(%2617, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2629 = "llvm.add"(%2628, %2621) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2630 = "llvm.and"(%2618, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2631 = "llvm.add"(%2630, %2622) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2632 = "llvm.and"(%2619, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2633 = "llvm.add"(%2632, %2623) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2634 = "llvm.and"(%2620, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2635 = "llvm.add"(%2634, %2624) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2636 = "llvm.add"(%2615, %1560) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %2637 = "llvm.icmp"(%2636, %1573) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2637, %2627, %2629, %2631, %2633, %2635, %2636)[^bb1, ^bb2] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 6>}> : (i1, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, i32) -> ()
^bb3:  // pred: ^bb4
  "llvm.intr.lifetime.start"(%1736) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1737) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1738) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1739) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1740) : (!llvm.ptr) -> ()
  "llvm.call"(%1736, %1737, %1738, %1739, %1740, %2695, %2697, %2699, %2701, %2703, %2581, %2583, %2585, %2587, %2589) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2638 = "llvm.load"(%1736) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2639 = "llvm.load"(%1737) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2640 = "llvm.load"(%1738) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2641 = "llvm.load"(%1739) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2642 = "llvm.load"(%1740) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1740) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1739) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1738) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1737) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1736) : (!llvm.ptr) -> ()
  %2643 = "llvm.lshr"(%2638, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2644 = "llvm.lshr"(%2639, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2645 = "llvm.lshr"(%2640, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2646 = "llvm.lshr"(%2641, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2647 = "llvm.lshr"(%2642, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2648 = "llvm.and"(%2638, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2649 = "llvm.call_intrinsic"(%2648, %2647, %1572) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2650 = "llvm.and"(%2639, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2651 = "llvm.add"(%2650, %2643) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2652 = "llvm.and"(%2640, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2653 = "llvm.add"(%2652, %2644) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2654 = "llvm.and"(%2641, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2655 = "llvm.add"(%2654, %2645) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2656 = "llvm.and"(%2642, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2657 = "llvm.add"(%2656, %2646) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%1741) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1742) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1743) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1744) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1745) : (!llvm.ptr) -> ()
  "llvm.call"(%1741, %1742, %1743, %1744, %1745, %2649, %2651, %2653, %2655, %2657) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2658 = "llvm.load"(%1741) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2659 = "llvm.load"(%1742) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2660 = "llvm.load"(%1743) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2661 = "llvm.load"(%1744) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2662 = "llvm.load"(%1745) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1745) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1744) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1743) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1742) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1741) : (!llvm.ptr) -> ()
  %2663 = "llvm.lshr"(%2658, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2664 = "llvm.lshr"(%2659, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2665 = "llvm.lshr"(%2660, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2666 = "llvm.lshr"(%2661, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2667 = "llvm.lshr"(%2662, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2668 = "llvm.and"(%2658, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2669 = "llvm.call_intrinsic"(%2668, %2667, %1572) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2670 = "llvm.and"(%2659, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2671 = "llvm.add"(%2670, %2663) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2672 = "llvm.and"(%2660, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2673 = "llvm.add"(%2672, %2664) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2674 = "llvm.and"(%2661, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2675 = "llvm.add"(%2674, %2665) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2676 = "llvm.and"(%2662, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2677 = "llvm.add"(%2676, %2666) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.br"(%2669, %2671, %2673, %2675, %2677, %1560)[^bb6] : (vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, i32) -> ()
^bb4(%2678: vector<4xi64>, %2679: vector<4xi64>, %2680: vector<4xi64>, %2681: vector<4xi64>, %2682: vector<4xi64>, %2683: i32):  // 2 preds: ^bb1, ^bb4
  "llvm.intr.lifetime.start"(%1731) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1732) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1733) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1734) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1735) : (!llvm.ptr) -> ()
  "llvm.call"(%1731, %1732, %1733, %1734, %1735, %2678, %2679, %2680, %2681, %2682) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2684 = "llvm.load"(%1731) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2685 = "llvm.load"(%1732) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2686 = "llvm.load"(%1733) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2687 = "llvm.load"(%1734) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2688 = "llvm.load"(%1735) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1735) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1734) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1733) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1732) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1731) : (!llvm.ptr) -> ()
  %2689 = "llvm.lshr"(%2684, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2690 = "llvm.lshr"(%2685, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2691 = "llvm.lshr"(%2686, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2692 = "llvm.lshr"(%2687, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2693 = "llvm.lshr"(%2688, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2694 = "llvm.and"(%2684, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2695 = "llvm.call_intrinsic"(%2694, %2693, %1572) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2696 = "llvm.and"(%2685, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2697 = "llvm.add"(%2696, %2689) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2698 = "llvm.and"(%2686, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2699 = "llvm.add"(%2698, %2690) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2700 = "llvm.and"(%2687, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2701 = "llvm.add"(%2700, %2691) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2702 = "llvm.and"(%2688, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2703 = "llvm.add"(%2702, %2692) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2704 = "llvm.add"(%2683, %1560) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %2705 = "llvm.icmp"(%2704, %1574) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2705, %2695, %2697, %2699, %2701, %2703, %2704)[^bb3, ^bb4] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 6>}> : (i1, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, i32) -> ()
^bb5:  // pred: ^bb6
  "llvm.intr.lifetime.start"(%1751) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1752) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1753) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1754) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1755) : (!llvm.ptr) -> ()
  "llvm.call"(%1751, %1752, %1753, %1754, %1755, %2763, %2765, %2767, %2769, %2771, %2649, %2651, %2653, %2655, %2657) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2706 = "llvm.load"(%1751) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2707 = "llvm.load"(%1752) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2708 = "llvm.load"(%1753) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2709 = "llvm.load"(%1754) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2710 = "llvm.load"(%1755) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1755) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1754) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1753) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1752) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1751) : (!llvm.ptr) -> ()
  %2711 = "llvm.lshr"(%2706, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2712 = "llvm.lshr"(%2707, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2713 = "llvm.lshr"(%2708, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2714 = "llvm.lshr"(%2709, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2715 = "llvm.lshr"(%2710, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2716 = "llvm.and"(%2706, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2717 = "llvm.call_intrinsic"(%2716, %2715, %1572) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2718 = "llvm.and"(%2707, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2719 = "llvm.add"(%2718, %2711) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2720 = "llvm.and"(%2708, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2721 = "llvm.add"(%2720, %2712) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2722 = "llvm.and"(%2709, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2723 = "llvm.add"(%2722, %2713) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2724 = "llvm.and"(%2710, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2725 = "llvm.add"(%2724, %2714) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%1756) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1757) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1758) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1759) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1760) : (!llvm.ptr) -> ()
  "llvm.call"(%1756, %1757, %1758, %1759, %1760, %2717, %2719, %2721, %2723, %2725) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2726 = "llvm.load"(%1756) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2727 = "llvm.load"(%1757) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2728 = "llvm.load"(%1758) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2729 = "llvm.load"(%1759) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2730 = "llvm.load"(%1760) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1760) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1759) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1758) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1757) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1756) : (!llvm.ptr) -> ()
  %2731 = "llvm.lshr"(%2726, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2732 = "llvm.lshr"(%2727, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2733 = "llvm.lshr"(%2728, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2734 = "llvm.lshr"(%2729, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2735 = "llvm.lshr"(%2730, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2736 = "llvm.and"(%2726, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2737 = "llvm.call_intrinsic"(%2736, %2735, %1572) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2738 = "llvm.and"(%2727, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2739 = "llvm.add"(%2738, %2731) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2740 = "llvm.and"(%2728, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2741 = "llvm.add"(%2740, %2732) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2742 = "llvm.and"(%2729, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2743 = "llvm.add"(%2742, %2733) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2744 = "llvm.and"(%2730, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2745 = "llvm.add"(%2744, %2734) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.br"(%2737, %2739, %2741, %2743, %2745, %1560)[^bb8] : (vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, i32) -> ()
^bb6(%2746: vector<4xi64>, %2747: vector<4xi64>, %2748: vector<4xi64>, %2749: vector<4xi64>, %2750: vector<4xi64>, %2751: i32):  // 2 preds: ^bb3, ^bb6
  "llvm.intr.lifetime.start"(%1746) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1747) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1748) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1749) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1750) : (!llvm.ptr) -> ()
  "llvm.call"(%1746, %1747, %1748, %1749, %1750, %2746, %2747, %2748, %2749, %2750) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2752 = "llvm.load"(%1746) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2753 = "llvm.load"(%1747) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2754 = "llvm.load"(%1748) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2755 = "llvm.load"(%1749) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2756 = "llvm.load"(%1750) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1750) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1749) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1748) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1747) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1746) : (!llvm.ptr) -> ()
  %2757 = "llvm.lshr"(%2752, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2758 = "llvm.lshr"(%2753, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2759 = "llvm.lshr"(%2754, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2760 = "llvm.lshr"(%2755, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2761 = "llvm.lshr"(%2756, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2762 = "llvm.and"(%2752, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2763 = "llvm.call_intrinsic"(%2762, %2761, %1572) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2764 = "llvm.and"(%2753, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2765 = "llvm.add"(%2764, %2757) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2766 = "llvm.and"(%2754, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2767 = "llvm.add"(%2766, %2758) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2768 = "llvm.and"(%2755, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2769 = "llvm.add"(%2768, %2759) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2770 = "llvm.and"(%2756, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2771 = "llvm.add"(%2770, %2760) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2772 = "llvm.add"(%2751, %1560) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %2773 = "llvm.icmp"(%2772, %1575) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2773, %2763, %2765, %2767, %2769, %2771, %2772)[^bb5, ^bb6] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 6>}> : (i1, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, i32) -> ()
^bb7:  // pred: ^bb8
  %2774 = "llvm.lshr"(%1795, %1576) : (i8, i8) -> i8
  %2775 = "llvm.zext"(%2774) <{nonNeg}> : (i8) -> i32
  %2776 = "llvm.lshr"(%1797, %1576) : (i8, i8) -> i8
  %2777 = "llvm.zext"(%2776) <{nonNeg}> : (i8) -> i32
  "llvm.intr.lifetime.start"(%1766) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1767) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1768) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1769) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1770) : (!llvm.ptr) -> ()
  "llvm.call"(%1766, %1767, %1768, %1769, %1770, %2905, %2907, %2909, %2911, %2913, %2581, %2583, %2585, %2587, %2589) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2778 = "llvm.load"(%1766) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2779 = "llvm.load"(%1767) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2780 = "llvm.load"(%1768) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2781 = "llvm.load"(%1769) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2782 = "llvm.load"(%1770) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1770) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1769) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1768) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1767) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1766) : (!llvm.ptr) -> ()
  %2783 = "llvm.lshr"(%2778, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2784 = "llvm.lshr"(%2779, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2785 = "llvm.lshr"(%2780, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2786 = "llvm.lshr"(%2781, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2787 = "llvm.lshr"(%2782, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2788 = "llvm.and"(%2778, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2789 = "llvm.call_intrinsic"(%2788, %2787, %1572) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2790 = "llvm.and"(%2779, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2791 = "llvm.add"(%2790, %2783) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2792 = "llvm.and"(%2780, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2793 = "llvm.add"(%2792, %2784) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2794 = "llvm.and"(%2781, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2795 = "llvm.add"(%2794, %2785) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2796 = "llvm.and"(%2782, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2797 = "llvm.add"(%2796, %2786) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%1771) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1772) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1773) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1774) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1775) : (!llvm.ptr) -> ()
  "llvm.call"(%1771, %1772, %1773, %1774, %1775, %2789, %2791, %2793, %2795, %2797) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2798 = "llvm.load"(%1771) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2799 = "llvm.load"(%1772) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2800 = "llvm.load"(%1773) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2801 = "llvm.load"(%1774) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2802 = "llvm.load"(%1775) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1775) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1774) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1773) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1772) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1771) : (!llvm.ptr) -> ()
  %2803 = "llvm.lshr"(%2798, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2804 = "llvm.lshr"(%2799, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2805 = "llvm.lshr"(%2800, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2806 = "llvm.lshr"(%2801, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2807 = "llvm.lshr"(%2802, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2808 = "llvm.and"(%2798, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2809 = "llvm.call_intrinsic"(%2808, %2807, %1572) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2810 = "llvm.and"(%2799, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2811 = "llvm.add"(%2810, %2803) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2812 = "llvm.and"(%2800, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2813 = "llvm.add"(%2812, %2804) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2814 = "llvm.and"(%2801, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2815 = "llvm.add"(%2814, %2805) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2816 = "llvm.and"(%2802, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2817 = "llvm.add"(%2816, %2806) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%1776) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1777) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1778) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1779) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1780) : (!llvm.ptr) -> ()
  "llvm.call"(%1776, %1777, %1778, %1779, %1780, %2809, %2811, %2813, %2815, %2817) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2818 = "llvm.load"(%1776) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2819 = "llvm.load"(%1777) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2820 = "llvm.load"(%1778) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2821 = "llvm.load"(%1779) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2822 = "llvm.load"(%1780) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1780) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1779) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1778) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1777) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1776) : (!llvm.ptr) -> ()
  %2823 = "llvm.lshr"(%2818, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2824 = "llvm.lshr"(%2819, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2825 = "llvm.lshr"(%2820, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2826 = "llvm.lshr"(%2821, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2827 = "llvm.lshr"(%2822, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2828 = "llvm.and"(%2818, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2829 = "llvm.call_intrinsic"(%2828, %2827, %1572) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2830 = "llvm.and"(%2819, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2831 = "llvm.add"(%2830, %2823) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2832 = "llvm.and"(%2820, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2833 = "llvm.add"(%2832, %2824) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2834 = "llvm.and"(%2821, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2835 = "llvm.add"(%2834, %2825) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2836 = "llvm.and"(%2822, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2837 = "llvm.add"(%2836, %2826) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%1781) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1782) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1783) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1784) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1785) : (!llvm.ptr) -> ()
  "llvm.call"(%1781, %1782, %1783, %1784, %1785, %2829, %2831, %2833, %2835, %2837, %1817, %1825, %1833, %1841, %1849) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2838 = "llvm.load"(%1781) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2839 = "llvm.load"(%1782) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2840 = "llvm.load"(%1783) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2841 = "llvm.load"(%1784) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2842 = "llvm.load"(%1785) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1785) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1784) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1783) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1782) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1781) : (!llvm.ptr) -> ()
  %2843 = "llvm.lshr"(%2838, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2844 = "llvm.lshr"(%2839, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2845 = "llvm.lshr"(%2840, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2846 = "llvm.lshr"(%2841, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2847 = "llvm.lshr"(%2842, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2848 = "llvm.and"(%2838, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2849 = "llvm.call_intrinsic"(%2848, %2847, %1572) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2850 = "llvm.shufflevector"(%2849, %1565) <{mask = array<i32: -1, 1, -1, -1, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %2851 = "llvm.shufflevector"(%2849, %1565) <{mask = array<i32: 0, -1, -1, -1, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %2852 = "llvm.and"(%2839, %1584) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2853 = "llvm.add"(%2852, %2843) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2854 = "llvm.shufflevector"(%2853, %1565) <{mask = array<i32: -1, 1, -1, -1, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %2855 = "llvm.shufflevector"(%2853, %1565) <{mask = array<i32: 0, -1, -1, -1, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %2856 = "llvm.and"(%2840, %1584) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2857 = "llvm.add"(%2856, %2844) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2858 = "llvm.shufflevector"(%2857, %1565) <{mask = array<i32: -1, 1, -1, -1, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %2859 = "llvm.shufflevector"(%2857, %1565) <{mask = array<i32: 0, -1, -1, -1, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %2860 = "llvm.and"(%2841, %1584) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2861 = "llvm.add"(%2860, %2845) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2862 = "llvm.shufflevector"(%2861, %1565) <{mask = array<i32: -1, 1, -1, -1, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %2863 = "llvm.shufflevector"(%2861, %1565) <{mask = array<i32: 0, -1, -1, -1, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %2864 = "llvm.and"(%2842, %1584) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2865 = "llvm.add"(%2864, %2846) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2866 = "llvm.shufflevector"(%2865, %1565) <{mask = array<i32: -1, 1, -1, -1, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %2867 = "llvm.shufflevector"(%2865, %1565) <{mask = array<i32: 0, -1, -1, -1, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %2868 = "llvm.shufflevector"(%2851, %1592) <{mask = array<i32: 0, -1, -1, -1, -1, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2869 = "llvm.shufflevector"(%2868, %2855) <{mask = array<i32: 0, 8, -1, -1, -1, 5, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2870 = "llvm.shufflevector"(%2869, %2859) <{mask = array<i32: 0, 1, 8, -1, -1, 5, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2871 = "llvm.shufflevector"(%2870, %2863) <{mask = array<i32: 0, 1, 2, 8, -1, 5, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2872 = "llvm.shufflevector"(%2871, %2867) <{mask = array<i32: 0, 1, 2, 3, 8, 5, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%2872, %1611) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2873 = "llvm.shufflevector"(%1592, %2850) <{mask = array<i32: 9, -1, -1, -1, -1, 5, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2874 = "llvm.shufflevector"(%2873, %2854) <{mask = array<i32: 0, 9, -1, -1, -1, 5, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2875 = "llvm.shufflevector"(%2874, %2858) <{mask = array<i32: 0, 1, 9, -1, -1, 5, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2876 = "llvm.shufflevector"(%2875, %2862) <{mask = array<i32: 0, 1, 2, 9, -1, 5, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2877 = "llvm.shufflevector"(%2876, %2866) <{mask = array<i32: 0, 1, 2, 3, 9, 5, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%2877, %1619) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1630) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1629) : (!llvm.ptr) -> ()
  "llvm.call"(%1611, %1611, %1600, %1619, %1619, %1609) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_f25519_mul2, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 6, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%1612, %1611, %1620, %1619) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_f25519_sqr2, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%1613, %1595, %1612, %1621, %1604, %1620) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_f25519_mul2, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 6, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  %2878 = "llvm.call"(%1614, %1613, %1594) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_f25519_sub, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %2879 = "llvm.call"(%1615, %1613, %1594) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_f25519_add, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %2880 = "llvm.call"(%1622, %1621, %1603) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_f25519_sub, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %2881 = "llvm.call"(%1623, %1621, %1603) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_f25519_add, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %2882 = "llvm.call"(%1614) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_f25519_is_nonzero, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i32
  %2883 = "llvm.call"(%1615) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_f25519_is_nonzero, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i32
  %2884 = "llvm.call"(%1622) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_f25519_is_nonzero, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i32
  %2885 = "llvm.call"(%1623) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_f25519_is_nonzero, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i32
  %2886 = "llvm.and"(%2883, %2882) : (i32, i32) -> i32
  %2887 = "llvm.icmp"(%2886, %1580) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2887)[^bb10, ^bb9] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb8(%2888: vector<4xi64>, %2889: vector<4xi64>, %2890: vector<4xi64>, %2891: vector<4xi64>, %2892: vector<4xi64>, %2893: i32):  // 2 preds: ^bb5, ^bb8
  "llvm.intr.lifetime.start"(%1761) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1762) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1763) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1764) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1765) : (!llvm.ptr) -> ()
  "llvm.call"(%1761, %1762, %1763, %1764, %1765, %2888, %2889, %2890, %2891, %2892) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2894 = "llvm.load"(%1761) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2895 = "llvm.load"(%1762) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2896 = "llvm.load"(%1763) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2897 = "llvm.load"(%1764) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %2898 = "llvm.load"(%1765) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1765) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1764) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1763) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1762) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1761) : (!llvm.ptr) -> ()
  %2899 = "llvm.lshr"(%2894, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2900 = "llvm.lshr"(%2895, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2901 = "llvm.lshr"(%2896, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2902 = "llvm.lshr"(%2897, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2903 = "llvm.lshr"(%2898, %1570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2904 = "llvm.and"(%2894, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2905 = "llvm.call_intrinsic"(%2904, %2903, %1572) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2906 = "llvm.and"(%2895, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2907 = "llvm.add"(%2906, %2899) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2908 = "llvm.and"(%2896, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2909 = "llvm.add"(%2908, %2900) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2910 = "llvm.and"(%2897, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2911 = "llvm.add"(%2910, %2901) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2912 = "llvm.and"(%2898, %1571) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2913 = "llvm.add"(%2912, %2902) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2914 = "llvm.add"(%2893, %1560) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %2915 = "llvm.icmp"(%2914, %1574) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2915, %2905, %2907, %2909, %2911, %2913, %2914)[^bb7, ^bb8] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 6>}> : (i1, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, i32) -> ()
^bb9:  // pred: ^bb7
  "llvm.store"(%1552, %arg79) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.store"(%1551, %arg80) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.store"(%1551, %arg81) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.store"(%1551, %arg82) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.store"(%1551, %arg83) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.br"(%1550)[^bb13] : (i32) -> ()
^bb10:  // pred: ^bb7
  %2916 = "llvm.and"(%2885, %2884) : (i32, i32) -> i32
  %2917 = "llvm.icmp"(%2916, %1580) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2917)[^bb12, ^bb11] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb11:  // pred: ^bb10
  "llvm.store"(%1552, %arg79) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.store"(%1551, %arg80) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.store"(%1551, %arg81) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.store"(%1551, %arg82) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.store"(%1551, %arg83) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.br"(%1549)[^bb13] : (i32) -> ()
^bb12:  // pred: ^bb10
  %2918 = "llvm.call"(%1616, %2882, %1548, %1563) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_f25519_if, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, i32, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %2919 = "llvm.call"(%1624, %2884, %1548, %1563) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_f25519_if, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, i32, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.call"(%1611, %1611, %1616, %1619, %1619, %1624) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_f25519_mul2, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 6, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  %2920 = "llvm.call"(%1611) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @fd_f25519_sgn, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i32
  %2921 = "llvm.call"(%1619) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @fd_f25519_sgn, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i32
  %2922 = "llvm.call"(%1618, %1611) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_f25519_neg, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %2923 = "llvm.call"(%1626, %1619) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_f25519_neg, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %2924 = "llvm.icmp"(%2920, %2775) <{predicate = 1 : i64}> : (i32, i32) -> i1
  %2925 = "llvm.zext"(%2924) : (i1) -> i32
  %2926 = "llvm.call"(%1611, %2925, %1618, %1611) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_f25519_if, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, i32, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %2927 = "llvm.icmp"(%2921, %2777) <{predicate = 1 : i64}> : (i32, i32) -> i1
  %2928 = "llvm.zext"(%2927) : (i1) -> i32
  %2929 = "llvm.call"(%1619, %2928, %1626, %1619) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_f25519_if, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, i32, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.call"(%1617, %1611, %1593, %1625, %1619, %1602) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_f25519_mul2, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 6, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1786) : (!llvm.ptr) -> ()
  %2930 = "llvm.load"(%1611) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.call"(%1786, %2930) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @wwl_st, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> ()
  "llvm.intr.lifetime.start"(%1787) : (!llvm.ptr) -> ()
  %2931 = "llvm.load"(%1593) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.call"(%1787, %2931) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @wwl_st, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> ()
  "llvm.intr.lifetime.start"(%1788) : (!llvm.ptr) -> ()
  "llvm.call"(%1788, %1547) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @wwl_st, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> ()
  "llvm.intr.lifetime.start"(%1789) : (!llvm.ptr) -> ()
  %2932 = "llvm.load"(%1617) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.call"(%1789, %2932) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @wwl_st, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> ()
  %2933 = "llvm.load"(%1786) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2934 = "llvm.load"(%1787) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %2935 = "llvm.load"(%1788) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %2936 = "llvm.load"(%1789) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %2937 = "llvm.insertelement"(%2933, %2934, %1567) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %2938 = "llvm.insertelement"(%2937, %2935, %1568) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %2939 = "llvm.insertelement"(%2938, %2936, %1569) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  "llvm.store"(%2939, %arg73) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<4xi64>, !llvm.ptr) -> ()
  %2940 = "llvm.getelementptr"(%1786) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %2941 = "llvm.load"(%2940) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2942 = "llvm.getelementptr"(%1787) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %2943 = "llvm.load"(%2942) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %2944 = "llvm.getelementptr"(%1788) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %2945 = "llvm.load"(%2944) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %2946 = "llvm.getelementptr"(%1789) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %2947 = "llvm.load"(%2946) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %2948 = "llvm.insertelement"(%2941, %2943, %1567) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %2949 = "llvm.insertelement"(%2948, %2945, %1568) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %2950 = "llvm.insertelement"(%2949, %2947, %1569) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  "llvm.store"(%2950, %arg74) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<4xi64>, !llvm.ptr) -> ()
  %2951 = "llvm.getelementptr"(%1786) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %2952 = "llvm.load"(%2951) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2953 = "llvm.getelementptr"(%1787) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %2954 = "llvm.load"(%2953) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %2955 = "llvm.getelementptr"(%1788) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %2956 = "llvm.load"(%2955) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %2957 = "llvm.getelementptr"(%1789) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %2958 = "llvm.load"(%2957) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %2959 = "llvm.insertelement"(%2952, %2954, %1567) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %2960 = "llvm.insertelement"(%2959, %2956, %1568) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %2961 = "llvm.insertelement"(%2960, %2958, %1569) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  "llvm.store"(%2961, %arg75) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<4xi64>, !llvm.ptr) -> ()
  %2962 = "llvm.getelementptr"(%1786) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %2963 = "llvm.load"(%2962) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2964 = "llvm.getelementptr"(%1787) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %2965 = "llvm.load"(%2964) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %2966 = "llvm.getelementptr"(%1788) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %2967 = "llvm.load"(%2966) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %2968 = "llvm.getelementptr"(%1789) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %2969 = "llvm.load"(%2968) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %2970 = "llvm.insertelement"(%2963, %2965, %1567) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %2971 = "llvm.insertelement"(%2970, %2967, %1568) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %2972 = "llvm.insertelement"(%2971, %2969, %1569) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  "llvm.store"(%2972, %arg76) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<4xi64>, !llvm.ptr) -> ()
  %2973 = "llvm.getelementptr"(%1786) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %2974 = "llvm.load"(%2973) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2975 = "llvm.getelementptr"(%1787) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %2976 = "llvm.load"(%2975) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %2977 = "llvm.getelementptr"(%1788) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %2978 = "llvm.load"(%2977) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %2979 = "llvm.getelementptr"(%1789) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %2980 = "llvm.load"(%2979) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %2981 = "llvm.insertelement"(%2974, %2976, %1567) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %2982 = "llvm.insertelement"(%2981, %2978, %1568) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %2983 = "llvm.insertelement"(%2982, %2980, %1569) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  "llvm.store"(%2983, %arg77) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1789) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1788) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1787) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1786) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1790) : (!llvm.ptr) -> ()
  %2984 = "llvm.load"(%1619) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.call"(%1790, %2984) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @wwl_st, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> ()
  "llvm.intr.lifetime.start"(%1791) : (!llvm.ptr) -> ()
  %2985 = "llvm.load"(%1602) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.call"(%1791, %2985) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @wwl_st, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> ()
  "llvm.intr.lifetime.start"(%1792) : (!llvm.ptr) -> ()
  "llvm.call"(%1792, %1547) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @wwl_st, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> ()
  "llvm.intr.lifetime.start"(%1793) : (!llvm.ptr) -> ()
  %2986 = "llvm.load"(%1625) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.call"(%1793, %2986) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @wwl_st, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> ()
  %2987 = "llvm.load"(%1790) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2988 = "llvm.load"(%1791) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %2989 = "llvm.load"(%1792) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %2990 = "llvm.load"(%1793) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %2991 = "llvm.insertelement"(%2987, %2988, %1567) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %2992 = "llvm.insertelement"(%2991, %2989, %1568) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %2993 = "llvm.insertelement"(%2992, %2990, %1569) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  "llvm.store"(%2993, %arg79) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<4xi64>, !llvm.ptr) -> ()
  %2994 = "llvm.getelementptr"(%1790) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %2995 = "llvm.load"(%2994) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2996 = "llvm.getelementptr"(%1791) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %2997 = "llvm.load"(%2996) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %2998 = "llvm.getelementptr"(%1792) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %2999 = "llvm.load"(%2998) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %3000 = "llvm.getelementptr"(%1793) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %3001 = "llvm.load"(%3000) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %3002 = "llvm.insertelement"(%2995, %2997, %1567) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %3003 = "llvm.insertelement"(%3002, %2999, %1568) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %3004 = "llvm.insertelement"(%3003, %3001, %1569) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  "llvm.store"(%3004, %arg80) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<4xi64>, !llvm.ptr) -> ()
  %3005 = "llvm.getelementptr"(%1790) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %3006 = "llvm.load"(%3005) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3007 = "llvm.getelementptr"(%1791) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %3008 = "llvm.load"(%3007) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %3009 = "llvm.getelementptr"(%1792) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %3010 = "llvm.load"(%3009) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %3011 = "llvm.getelementptr"(%1793) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %3012 = "llvm.load"(%3011) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %3013 = "llvm.insertelement"(%3006, %3008, %1567) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %3014 = "llvm.insertelement"(%3013, %3010, %1568) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %3015 = "llvm.insertelement"(%3014, %3012, %1569) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  "llvm.store"(%3015, %arg81) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<4xi64>, !llvm.ptr) -> ()
  %3016 = "llvm.getelementptr"(%1790) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %3017 = "llvm.load"(%3016) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3018 = "llvm.getelementptr"(%1791) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %3019 = "llvm.load"(%3018) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %3020 = "llvm.getelementptr"(%1792) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %3021 = "llvm.load"(%3020) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %3022 = "llvm.getelementptr"(%1793) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %3023 = "llvm.load"(%3022) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %3024 = "llvm.insertelement"(%3017, %3019, %1567) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %3025 = "llvm.insertelement"(%3024, %3021, %1568) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %3026 = "llvm.insertelement"(%3025, %3023, %1569) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  "llvm.store"(%3026, %arg82) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<4xi64>, !llvm.ptr) -> ()
  %3027 = "llvm.getelementptr"(%1790) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %3028 = "llvm.load"(%3027) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3029 = "llvm.getelementptr"(%1791) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %3030 = "llvm.load"(%3029) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %3031 = "llvm.getelementptr"(%1792) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %3032 = "llvm.load"(%3031) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %3033 = "llvm.getelementptr"(%1793) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %3034 = "llvm.load"(%3033) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %3035 = "llvm.insertelement"(%3028, %3030, %1567) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %3036 = "llvm.insertelement"(%3035, %3032, %1568) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %3037 = "llvm.insertelement"(%3036, %3034, %1569) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  "llvm.store"(%3037, %arg83) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1793) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1792) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1791) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1790) : (!llvm.ptr) -> ()
  "llvm.br"(%1580)[^bb13] : (i32) -> ()
^bb13(%3038: i32):  // 3 preds: ^bb9, ^bb11, ^bb12
  "llvm.intr.lifetime.end"(%1628) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1627) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1626) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1625) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1624) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1623) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1622) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1621) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1620) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1619) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1618) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1617) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1616) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1615) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1614) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1613) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1612) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1611) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1610) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1609) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1608) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1607) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1606) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1605) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1604) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1603) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1602) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1601) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1600) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1599) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1598) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1597) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1596) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1595) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1594) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1593) : (!llvm.ptr) -> ()
  "llvm.return"(%3038) : (i32) -> ()
}) : () -> ()
  with @fd_f25519_add := fd_f25519_add, @fd_f25519_frombytes := fd_f25519_frombytes,
    @fd_f25519_if := fd_f25519_if, @fd_f25519_is_nonzero := fd_f25519_is_nonzero,
    @fd_f25519_mul2 := fd_f25519_mul2, @fd_f25519_neg := fd_f25519_neg,
    @fd_f25519_sgn := fd_f25519_sgn, @fd_f25519_sqr2 := fd_f25519_sqr2,
    @fd_f25519_sub := fd_f25519_sub, @fd_memcpy := fd_memcpy,
    @fd_r52x5_quad_mul_fast := fd_r52x5_quad_mul_fast,
    @fd_r52x5_quad_sqr_fast := fd_r52x5_quad_sqr_fast, @wwl_st := wwl_st,
    @fd_f25519_d := fd_f25519_d, @fd_f25519_one := fd_f25519_one,
    @fd_f25519_sqrtm1 := fd_f25519_sqrtm1

end

end MLIR.Firedancer.R52x5
