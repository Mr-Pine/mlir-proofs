module

-- agave-build/out/serial-noinline-big/op/_RNvXs8_Cs3X6wZJE6GDg_6subtleShNtB5_14ConstantTimeEq5ct_eqCs2JGgYtL0Fal_14solana_ed25519.mlir
-- <[u8] as subtle[2e0bf2bcb38a7e1c]::ConstantTimeEq>::ct_eq

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Agave.Serial.Mlir.black_box_u8

meta import MLIR.Semantics.Func
meta import Agave.Serial.Mlir.black_box_u8

namespace MLIR.Agave.Serial

@[expose] public section

mlir_def slice_u8_ConstantTimeEq_ct_eq :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<i8 (ptr, ptr)>, inline_hint, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], personality = @rust_eh_personality, res_attrs = [{llvm.noundef}], sym_name = "_RNvXs8_Cs3X6wZJE6GDg_6subtleShNtB5_14ConstantTimeEq5ct_eqCs2JGgYtL0Fal_14solana_ed25519", target_cpu = "x86-64-v2", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg76: !llvm.ptr, %arg77: !llvm.ptr):
  %1624 = "llvm.mlir.constant"() <{value = 1 : i8}> : () -> i8
  %1625 = "llvm.load"(%arg76) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1626 = "llvm.load"(%arg77) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1627 = "llvm.icmp"(%1625, %1626) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %1628 = "llvm.zext"(%1627) : (i1) -> i8
  %1629 = "llvm.call"(%1628) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %1630 = "llvm.and"(%1629, %1624) : (i8, i8) -> i8
  %1631 = "llvm.getelementptr"(%arg76) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1>}> : (!llvm.ptr) -> !llvm.ptr
  %1632 = "llvm.getelementptr"(%arg77) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1>}> : (!llvm.ptr) -> !llvm.ptr
  %1633 = "llvm.load"(%1631) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1634 = "llvm.load"(%1632) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1635 = "llvm.icmp"(%1633, %1634) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %1636 = "llvm.zext"(%1635) : (i1) -> i8
  %1637 = "llvm.call"(%1636) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %1638 = "llvm.and"(%1637, %1630) : (i8, i8) -> i8
  %1639 = "llvm.getelementptr"(%arg76) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2>}> : (!llvm.ptr) -> !llvm.ptr
  %1640 = "llvm.getelementptr"(%arg77) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2>}> : (!llvm.ptr) -> !llvm.ptr
  %1641 = "llvm.load"(%1639) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1642 = "llvm.load"(%1640) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1643 = "llvm.icmp"(%1641, %1642) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %1644 = "llvm.zext"(%1643) : (i1) -> i8
  %1645 = "llvm.call"(%1644) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %1646 = "llvm.and"(%1645, %1638) : (i8, i8) -> i8
  %1647 = "llvm.getelementptr"(%arg76) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 3>}> : (!llvm.ptr) -> !llvm.ptr
  %1648 = "llvm.getelementptr"(%arg77) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 3>}> : (!llvm.ptr) -> !llvm.ptr
  %1649 = "llvm.load"(%1647) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1650 = "llvm.load"(%1648) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1651 = "llvm.icmp"(%1649, %1650) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %1652 = "llvm.zext"(%1651) : (i1) -> i8
  %1653 = "llvm.call"(%1652) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %1654 = "llvm.and"(%1653, %1646) : (i8, i8) -> i8
  %1655 = "llvm.getelementptr"(%arg76) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4>}> : (!llvm.ptr) -> !llvm.ptr
  %1656 = "llvm.getelementptr"(%arg77) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4>}> : (!llvm.ptr) -> !llvm.ptr
  %1657 = "llvm.load"(%1655) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1658 = "llvm.load"(%1656) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1659 = "llvm.icmp"(%1657, %1658) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %1660 = "llvm.zext"(%1659) : (i1) -> i8
  %1661 = "llvm.call"(%1660) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %1662 = "llvm.and"(%1661, %1654) : (i8, i8) -> i8
  %1663 = "llvm.getelementptr"(%arg76) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 5>}> : (!llvm.ptr) -> !llvm.ptr
  %1664 = "llvm.getelementptr"(%arg77) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 5>}> : (!llvm.ptr) -> !llvm.ptr
  %1665 = "llvm.load"(%1663) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1666 = "llvm.load"(%1664) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1667 = "llvm.icmp"(%1665, %1666) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %1668 = "llvm.zext"(%1667) : (i1) -> i8
  %1669 = "llvm.call"(%1668) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %1670 = "llvm.and"(%1669, %1662) : (i8, i8) -> i8
  %1671 = "llvm.getelementptr"(%arg76) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6>}> : (!llvm.ptr) -> !llvm.ptr
  %1672 = "llvm.getelementptr"(%arg77) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6>}> : (!llvm.ptr) -> !llvm.ptr
  %1673 = "llvm.load"(%1671) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1674 = "llvm.load"(%1672) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1675 = "llvm.icmp"(%1673, %1674) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %1676 = "llvm.zext"(%1675) : (i1) -> i8
  %1677 = "llvm.call"(%1676) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %1678 = "llvm.and"(%1677, %1670) : (i8, i8) -> i8
  %1679 = "llvm.getelementptr"(%arg76) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 7>}> : (!llvm.ptr) -> !llvm.ptr
  %1680 = "llvm.getelementptr"(%arg77) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 7>}> : (!llvm.ptr) -> !llvm.ptr
  %1681 = "llvm.load"(%1679) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1682 = "llvm.load"(%1680) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1683 = "llvm.icmp"(%1681, %1682) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %1684 = "llvm.zext"(%1683) : (i1) -> i8
  %1685 = "llvm.call"(%1684) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %1686 = "llvm.and"(%1685, %1678) : (i8, i8) -> i8
  %1687 = "llvm.getelementptr"(%arg76) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %1688 = "llvm.getelementptr"(%arg77) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %1689 = "llvm.load"(%1687) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1690 = "llvm.load"(%1688) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1691 = "llvm.icmp"(%1689, %1690) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %1692 = "llvm.zext"(%1691) : (i1) -> i8
  %1693 = "llvm.call"(%1692) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %1694 = "llvm.and"(%1693, %1686) : (i8, i8) -> i8
  %1695 = "llvm.getelementptr"(%arg76) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 9>}> : (!llvm.ptr) -> !llvm.ptr
  %1696 = "llvm.getelementptr"(%arg77) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 9>}> : (!llvm.ptr) -> !llvm.ptr
  %1697 = "llvm.load"(%1695) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1698 = "llvm.load"(%1696) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1699 = "llvm.icmp"(%1697, %1698) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %1700 = "llvm.zext"(%1699) : (i1) -> i8
  %1701 = "llvm.call"(%1700) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %1702 = "llvm.and"(%1701, %1694) : (i8, i8) -> i8
  %1703 = "llvm.getelementptr"(%arg76) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 10>}> : (!llvm.ptr) -> !llvm.ptr
  %1704 = "llvm.getelementptr"(%arg77) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 10>}> : (!llvm.ptr) -> !llvm.ptr
  %1705 = "llvm.load"(%1703) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1706 = "llvm.load"(%1704) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1707 = "llvm.icmp"(%1705, %1706) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %1708 = "llvm.zext"(%1707) : (i1) -> i8
  %1709 = "llvm.call"(%1708) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %1710 = "llvm.and"(%1709, %1702) : (i8, i8) -> i8
  %1711 = "llvm.getelementptr"(%arg76) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 11>}> : (!llvm.ptr) -> !llvm.ptr
  %1712 = "llvm.getelementptr"(%arg77) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 11>}> : (!llvm.ptr) -> !llvm.ptr
  %1713 = "llvm.load"(%1711) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1714 = "llvm.load"(%1712) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1715 = "llvm.icmp"(%1713, %1714) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %1716 = "llvm.zext"(%1715) : (i1) -> i8
  %1717 = "llvm.call"(%1716) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %1718 = "llvm.and"(%1717, %1710) : (i8, i8) -> i8
  %1719 = "llvm.getelementptr"(%arg76) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 12>}> : (!llvm.ptr) -> !llvm.ptr
  %1720 = "llvm.getelementptr"(%arg77) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 12>}> : (!llvm.ptr) -> !llvm.ptr
  %1721 = "llvm.load"(%1719) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1722 = "llvm.load"(%1720) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1723 = "llvm.icmp"(%1721, %1722) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %1724 = "llvm.zext"(%1723) : (i1) -> i8
  %1725 = "llvm.call"(%1724) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %1726 = "llvm.and"(%1725, %1718) : (i8, i8) -> i8
  %1727 = "llvm.getelementptr"(%arg76) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 13>}> : (!llvm.ptr) -> !llvm.ptr
  %1728 = "llvm.getelementptr"(%arg77) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 13>}> : (!llvm.ptr) -> !llvm.ptr
  %1729 = "llvm.load"(%1727) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1730 = "llvm.load"(%1728) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1731 = "llvm.icmp"(%1729, %1730) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %1732 = "llvm.zext"(%1731) : (i1) -> i8
  %1733 = "llvm.call"(%1732) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %1734 = "llvm.and"(%1733, %1726) : (i8, i8) -> i8
  %1735 = "llvm.getelementptr"(%arg76) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 14>}> : (!llvm.ptr) -> !llvm.ptr
  %1736 = "llvm.getelementptr"(%arg77) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 14>}> : (!llvm.ptr) -> !llvm.ptr
  %1737 = "llvm.load"(%1735) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1738 = "llvm.load"(%1736) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1739 = "llvm.icmp"(%1737, %1738) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %1740 = "llvm.zext"(%1739) : (i1) -> i8
  %1741 = "llvm.call"(%1740) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %1742 = "llvm.and"(%1741, %1734) : (i8, i8) -> i8
  %1743 = "llvm.getelementptr"(%arg76) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 15>}> : (!llvm.ptr) -> !llvm.ptr
  %1744 = "llvm.getelementptr"(%arg77) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 15>}> : (!llvm.ptr) -> !llvm.ptr
  %1745 = "llvm.load"(%1743) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1746 = "llvm.load"(%1744) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1747 = "llvm.icmp"(%1745, %1746) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %1748 = "llvm.zext"(%1747) : (i1) -> i8
  %1749 = "llvm.call"(%1748) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %1750 = "llvm.and"(%1749, %1742) : (i8, i8) -> i8
  %1751 = "llvm.getelementptr"(%arg76) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %1752 = "llvm.getelementptr"(%arg77) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %1753 = "llvm.load"(%1751) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1754 = "llvm.load"(%1752) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1755 = "llvm.icmp"(%1753, %1754) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %1756 = "llvm.zext"(%1755) : (i1) -> i8
  %1757 = "llvm.call"(%1756) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %1758 = "llvm.and"(%1757, %1750) : (i8, i8) -> i8
  %1759 = "llvm.getelementptr"(%arg76) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 17>}> : (!llvm.ptr) -> !llvm.ptr
  %1760 = "llvm.getelementptr"(%arg77) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 17>}> : (!llvm.ptr) -> !llvm.ptr
  %1761 = "llvm.load"(%1759) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1762 = "llvm.load"(%1760) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1763 = "llvm.icmp"(%1761, %1762) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %1764 = "llvm.zext"(%1763) : (i1) -> i8
  %1765 = "llvm.call"(%1764) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %1766 = "llvm.and"(%1765, %1758) : (i8, i8) -> i8
  %1767 = "llvm.getelementptr"(%arg76) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 18>}> : (!llvm.ptr) -> !llvm.ptr
  %1768 = "llvm.getelementptr"(%arg77) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 18>}> : (!llvm.ptr) -> !llvm.ptr
  %1769 = "llvm.load"(%1767) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1770 = "llvm.load"(%1768) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1771 = "llvm.icmp"(%1769, %1770) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %1772 = "llvm.zext"(%1771) : (i1) -> i8
  %1773 = "llvm.call"(%1772) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %1774 = "llvm.and"(%1773, %1766) : (i8, i8) -> i8
  %1775 = "llvm.getelementptr"(%arg76) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 19>}> : (!llvm.ptr) -> !llvm.ptr
  %1776 = "llvm.getelementptr"(%arg77) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 19>}> : (!llvm.ptr) -> !llvm.ptr
  %1777 = "llvm.load"(%1775) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1778 = "llvm.load"(%1776) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1779 = "llvm.icmp"(%1777, %1778) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %1780 = "llvm.zext"(%1779) : (i1) -> i8
  %1781 = "llvm.call"(%1780) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %1782 = "llvm.and"(%1781, %1774) : (i8, i8) -> i8
  %1783 = "llvm.getelementptr"(%arg76) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 20>}> : (!llvm.ptr) -> !llvm.ptr
  %1784 = "llvm.getelementptr"(%arg77) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 20>}> : (!llvm.ptr) -> !llvm.ptr
  %1785 = "llvm.load"(%1783) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1786 = "llvm.load"(%1784) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1787 = "llvm.icmp"(%1785, %1786) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %1788 = "llvm.zext"(%1787) : (i1) -> i8
  %1789 = "llvm.call"(%1788) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %1790 = "llvm.and"(%1789, %1782) : (i8, i8) -> i8
  %1791 = "llvm.getelementptr"(%arg76) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 21>}> : (!llvm.ptr) -> !llvm.ptr
  %1792 = "llvm.getelementptr"(%arg77) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 21>}> : (!llvm.ptr) -> !llvm.ptr
  %1793 = "llvm.load"(%1791) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1794 = "llvm.load"(%1792) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1795 = "llvm.icmp"(%1793, %1794) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %1796 = "llvm.zext"(%1795) : (i1) -> i8
  %1797 = "llvm.call"(%1796) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %1798 = "llvm.and"(%1797, %1790) : (i8, i8) -> i8
  %1799 = "llvm.getelementptr"(%arg76) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 22>}> : (!llvm.ptr) -> !llvm.ptr
  %1800 = "llvm.getelementptr"(%arg77) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 22>}> : (!llvm.ptr) -> !llvm.ptr
  %1801 = "llvm.load"(%1799) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1802 = "llvm.load"(%1800) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1803 = "llvm.icmp"(%1801, %1802) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %1804 = "llvm.zext"(%1803) : (i1) -> i8
  %1805 = "llvm.call"(%1804) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %1806 = "llvm.and"(%1805, %1798) : (i8, i8) -> i8
  %1807 = "llvm.getelementptr"(%arg76) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 23>}> : (!llvm.ptr) -> !llvm.ptr
  %1808 = "llvm.getelementptr"(%arg77) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 23>}> : (!llvm.ptr) -> !llvm.ptr
  %1809 = "llvm.load"(%1807) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1810 = "llvm.load"(%1808) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1811 = "llvm.icmp"(%1809, %1810) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %1812 = "llvm.zext"(%1811) : (i1) -> i8
  %1813 = "llvm.call"(%1812) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %1814 = "llvm.and"(%1813, %1806) : (i8, i8) -> i8
  %1815 = "llvm.getelementptr"(%arg76) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %1816 = "llvm.getelementptr"(%arg77) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %1817 = "llvm.load"(%1815) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1818 = "llvm.load"(%1816) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1819 = "llvm.icmp"(%1817, %1818) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %1820 = "llvm.zext"(%1819) : (i1) -> i8
  %1821 = "llvm.call"(%1820) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %1822 = "llvm.and"(%1821, %1814) : (i8, i8) -> i8
  %1823 = "llvm.getelementptr"(%arg76) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 25>}> : (!llvm.ptr) -> !llvm.ptr
  %1824 = "llvm.getelementptr"(%arg77) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 25>}> : (!llvm.ptr) -> !llvm.ptr
  %1825 = "llvm.load"(%1823) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1826 = "llvm.load"(%1824) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1827 = "llvm.icmp"(%1825, %1826) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %1828 = "llvm.zext"(%1827) : (i1) -> i8
  %1829 = "llvm.call"(%1828) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %1830 = "llvm.and"(%1829, %1822) : (i8, i8) -> i8
  %1831 = "llvm.getelementptr"(%arg76) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 26>}> : (!llvm.ptr) -> !llvm.ptr
  %1832 = "llvm.getelementptr"(%arg77) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 26>}> : (!llvm.ptr) -> !llvm.ptr
  %1833 = "llvm.load"(%1831) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1834 = "llvm.load"(%1832) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1835 = "llvm.icmp"(%1833, %1834) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %1836 = "llvm.zext"(%1835) : (i1) -> i8
  %1837 = "llvm.call"(%1836) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %1838 = "llvm.and"(%1837, %1830) : (i8, i8) -> i8
  %1839 = "llvm.getelementptr"(%arg76) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 27>}> : (!llvm.ptr) -> !llvm.ptr
  %1840 = "llvm.getelementptr"(%arg77) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 27>}> : (!llvm.ptr) -> !llvm.ptr
  %1841 = "llvm.load"(%1839) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1842 = "llvm.load"(%1840) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1843 = "llvm.icmp"(%1841, %1842) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %1844 = "llvm.zext"(%1843) : (i1) -> i8
  %1845 = "llvm.call"(%1844) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %1846 = "llvm.and"(%1845, %1838) : (i8, i8) -> i8
  %1847 = "llvm.getelementptr"(%arg76) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 28>}> : (!llvm.ptr) -> !llvm.ptr
  %1848 = "llvm.getelementptr"(%arg77) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 28>}> : (!llvm.ptr) -> !llvm.ptr
  %1849 = "llvm.load"(%1847) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1850 = "llvm.load"(%1848) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1851 = "llvm.icmp"(%1849, %1850) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %1852 = "llvm.zext"(%1851) : (i1) -> i8
  %1853 = "llvm.call"(%1852) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %1854 = "llvm.and"(%1853, %1846) : (i8, i8) -> i8
  %1855 = "llvm.getelementptr"(%arg76) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 29>}> : (!llvm.ptr) -> !llvm.ptr
  %1856 = "llvm.getelementptr"(%arg77) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 29>}> : (!llvm.ptr) -> !llvm.ptr
  %1857 = "llvm.load"(%1855) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1858 = "llvm.load"(%1856) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1859 = "llvm.icmp"(%1857, %1858) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %1860 = "llvm.zext"(%1859) : (i1) -> i8
  %1861 = "llvm.call"(%1860) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %1862 = "llvm.and"(%1861, %1854) : (i8, i8) -> i8
  %1863 = "llvm.getelementptr"(%arg76) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 30>}> : (!llvm.ptr) -> !llvm.ptr
  %1864 = "llvm.getelementptr"(%arg77) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 30>}> : (!llvm.ptr) -> !llvm.ptr
  %1865 = "llvm.load"(%1863) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1866 = "llvm.load"(%1864) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1867 = "llvm.icmp"(%1865, %1866) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %1868 = "llvm.zext"(%1867) : (i1) -> i8
  %1869 = "llvm.call"(%1868) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %1870 = "llvm.and"(%1869, %1862) : (i8, i8) -> i8
  %1871 = "llvm.getelementptr"(%arg76) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 31>}> : (!llvm.ptr) -> !llvm.ptr
  %1872 = "llvm.getelementptr"(%arg77) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 31>}> : (!llvm.ptr) -> !llvm.ptr
  %1873 = "llvm.load"(%1871) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1874 = "llvm.load"(%1872) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1875 = "llvm.icmp"(%1873, %1874) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %1876 = "llvm.zext"(%1875) : (i1) -> i8
  %1877 = "llvm.call"(%1876) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %1878 = "llvm.and"(%1877, %1870) : (i8, i8) -> i8
  %1879 = "llvm.call"(%1878) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  "llvm.return"(%1879) : (i8) -> ()
}) : () -> ()
  with @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519 := black_box_u8

end

end MLIR.Agave.Serial
