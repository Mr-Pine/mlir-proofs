module

-- agave-build/out/avx2-noinline-big/op/_RNvMso_NtCsh8hPzWUDumX_14solana_ed255196scalarNtB5_6Scalar17non_adjacent_form.mlir
-- <solana_ed25519[c79103de3f6f5451]::scalar::Scalar>::non_adjacent_form

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Agave.Avx2

@[expose] public section

mlir_def Scalar_non_adjacent_form :=
#alias_scope_domain72 = #llvm.alias_scope_domain<id = distinct[72]<>, description = "_RNvNtCsh8hPzWUDumX_14solana_ed255196scalar16read_le_u64_into">
#alias_scope107 = #llvm.alias_scope<id = distinct[236]<>, domain = #alias_scope_domain72, description = "_RNvNtCsh8hPzWUDumX_14solana_ed255196scalar16read_le_u64_into: argument 0">
#alias_scope108 = #llvm.alias_scope<id = distinct[237]<>, domain = #alias_scope_domain72, description = "_RNvNtCsh8hPzWUDumX_14solana_ed255196scalar16read_le_u64_into: argument 1">
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 1 : i64, llvm.dead_on_unwind, llvm.dereferenceable = 256 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writable, llvm.writeonly}, {llvm.dereferenceable = 32 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.noundef, llvm.range = #llvm.constant_range<i64, 5, 9>}], dso_local, function_type = !llvm.func<void (ptr, ptr, i64)>, linkage = #llvm.linkage<internal>, passthrough = ["nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], personality = @rust_eh_personality, sym_name = "_RNvMso_NtCsh8hPzWUDumX_14solana_ed255196scalarNtB5_6Scalar17non_adjacent_form", target_cpu = "x86-64-v2", target_features = #llvm.target_features<["+avx", "+avx2", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+crc32", "+ssse3"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg52: !llvm.ptr, %arg53: !llvm.ptr, %arg54: i64):
  %1627 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1628 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %1629 = "llvm.mlir.constant"() <{value = 256 : i64}> : () -> i64
  %1630 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
  %1631 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %1632 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %1633 = "llvm.mlir.constant"() <{value = 64 : i64}> : () -> i64
  %1634 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %1635 = "llvm.mlir.constant"() <{value = 6 : i64}> : () -> i64
  %1636 = "llvm.mlir.constant"() <{value = 63 : i64}> : () -> i64
  %1637 = "llvm.alloca"(%1627) <{alignment = 8 : i64, elem_type = !llvm.array<40 x i8>}> : (i32) -> !llvm.ptr
  "llvm.intr.memset"(%arg52, %1628, %1629) <{arg_attrs = [{llvm.align = 1 : i64, llvm.dereferenceable = 256 : i64, llvm.nonnull, llvm.noundef}, {}, {}], isVolatile = false}> : (!llvm.ptr, i8, i64) -> ()
  "llvm.intr.lifetime.start"(%1637) : (!llvm.ptr) -> ()
  "llvm.intr.memset"(%1637, %1628, %1630) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {}, {}], isVolatile = false}> : (!llvm.ptr, i8, i64) -> ()
  "llvm.intr.experimental.noalias.scope.decl"() <{scope = #alias_scope107}> : () -> ()
  "llvm.intr.experimental.noalias.scope.decl"() <{scope = #alias_scope108}> : () -> ()
  %1638 = "llvm.load"(%arg53) <{alias_scopes = [#alias_scope107], alignment = 1 : i64, noalias_scopes = [#alias_scope108], ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.store"(%1638, %1637) <{alias_scopes = [#alias_scope108], alignment = 8 : i64, noalias_scopes = [#alias_scope107], ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %1639 = "llvm.shl"(%1631, %arg54) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1640 = "llvm.add"(%1639, %1632) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1641 = "llvm.sub"(%1633, %arg54) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1642 = "llvm.lshr"(%1639, %1631) <{isExact}> : (i64, i64) -> i64
  %1643 = "llvm.trunc"(%1639) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.br"(%1634, %1634)[^bb1] : (i64, i64) -> ()
^bb1(%1644: i64, %1645: i64):  // 2 preds: ^bb0, ^bb7
  "llvm.br"(%1644)[^bb3] : (i64) -> ()
^bb2:  // 2 preds: ^bb6, ^bb7
  "llvm.intr.lifetime.end"(%1637) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
^bb3(%1646: i64):  // 2 preds: ^bb1, ^bb6
  %1647 = "llvm.lshr"(%1646, %1635) : (i64, i64) -> i64
  %1648 = "llvm.and"(%1646, %1636) : (i64, i64) -> i64
  %1649 = "llvm.icmp"(%1648, %1641) <{predicate = 6 : i64}> : (i64, i64) -> i1
  %1650 = "llvm.getelementptr"(%1637, %1647) <{elem_type = i64, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1651 = "llvm.load"(%1650) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1652 = "llvm.lshr"(%1651, %1648) : (i64, i64) -> i64
  "llvm.cond_br"(%1649, %1652)[^bb5, ^bb4] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
^bb4:  // pred: ^bb3
  %1653 = "llvm.getelementptr"(%1650) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %1654 = "llvm.load"(%1653) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1655 = "llvm.sub"(%1634, %1646) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1656 = "llvm.and"(%1655, %1636) : (i64, i64) -> i64
  %1657 = "llvm.shl"(%1654, %1656) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1658 = "llvm.or"(%1657, %1652) : (i64, i64) -> i64
  "llvm.br"(%1658)[^bb5] : (i64) -> ()
^bb5(%1659: i64):  // 2 preds: ^bb3, ^bb4
  %1660 = "llvm.and"(%1659, %1640) : (i64, i64) -> i64
  %1661 = "llvm.add"(%1660, %1645) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1662 = "llvm.and"(%1661, %1631) : (i64, i64) -> i64
  %1663 = "llvm.icmp"(%1662, %1634) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1663, %1661, %1646)[^bb6, ^bb7] <{operandSegmentSizes = array<i32: 1, 0, 2>}> : (i1, i64, i64) -> ()
^bb6:  // pred: ^bb5
  %1664 = "llvm.add"(%1646, %1631) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1665 = "llvm.icmp"(%1664, %1629) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1665, %1664)[^bb2, ^bb3] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb7(%1666: i64, %1667: i64):  // pred: ^bb5
  %1668 = "llvm.icmp"(%1666, %1642) <{predicate = 9 : i64}> : (i64, i64) -> i1
  %1669 = "llvm.trunc"(%1666) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1670 = "llvm.select"(%1668, %1643, %1628) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i8, i8) -> i8
  %1671 = "llvm.sub"(%1669, %1670) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  %1672 = "llvm.zext"(%1668) : (i1) -> i64
  %1673 = "llvm.getelementptr"(%arg52, %1667) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%1671, %1673) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1674 = "llvm.add"(%1667, %arg54) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %1675 = "llvm.icmp"(%1674, %1629) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1675, %1674, %1672)[^bb1, ^bb2] <{operandSegmentSizes = array<i32: 1, 2, 0>}> : (i1, i64, i64) -> ()
}) : () -> ()

end

end MLIR.Agave.Avx2
