module

-- agave-build/out/serial-noinline-big/op/_RNvXs6_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldRNtB5_14FieldElement51NtNtNtCsgxBkk5gSRhY_4core3ops5arith3Neg3neg.mlir
-- <&solana_ed25519[1fe0933b11699477]::backend::serial::u64::field::FieldElement51 as core[c0acaeba6ab4c2e0]::ops::arith::Neg>::neg

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Agave.Serial

@[expose] public section

mlir_def FieldElement51_Neg_neg :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 8 : i64, llvm.dead_on_unwind, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writable, llvm.writeonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], sym_name = "_RNvXs6_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldRNtB5_14FieldElement51NtNtNtCsgxBkk5gSRhY_4core3ops5arith3Neg3neg", target_cpu = "x86-64-v2", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg74: !llvm.ptr, %arg75: !llvm.ptr):
  %1592 = "llvm.mlir.constant"() <{value = dense<[36028797018963664, 36028797018963952]> : vector<2xi64>}> : () -> vector<2xi64>
  %1593 = "llvm.mlir.constant"() <{value = dense<36028797018963952> : vector<2xi64>}> : () -> vector<2xi64>
  %1594 = "llvm.mlir.constant"() <{value = dense<51> : vector<2xi64>}> : () -> vector<2xi64>
  %1595 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %1596 = "llvm.mlir.constant"() <{value = 2251799813685247 : i64}> : () -> i64
  %1597 = "llvm.mlir.constant"() <{value = dense<2251799813685247> : vector<2xi64>}> : () -> vector<2xi64>
  %1598 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %1599 = "llvm.mlir.constant"() <{value = 51 : i64}> : () -> i64
  %1600 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %1601 = "llvm.getelementptr"(%arg75) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %1602 = "llvm.getelementptr"(%arg75) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %1603 = "llvm.getelementptr"(%arg74) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %1604 = "llvm.load"(%arg75) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  %1605 = "llvm.load"(%1601) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  %1606 = "llvm.sub"(%1592, %1604) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1607 = "llvm.sub"(%1593, %1605) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1608 = "llvm.lshr"(%1606, %1594) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1609 = "llvm.extractelement"(%1606, %1595) : (vector<2xi64>, i64) -> i64
  %1610 = "llvm.and"(%1609, %1596) : (i64, i64) -> i64
  %1611 = "llvm.and"(%1607, %1597) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1612 = "llvm.add"(%1611, %1608) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  "llvm.store"(%1612, %1603) <{alignment = 8 : i64, ordering = 0 : i64}> : (vector<2xi64>, !llvm.ptr) -> ()
  %1613 = "llvm.getelementptr"(%arg74) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %1614 = "llvm.load"(%1602) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  %1615 = "llvm.sub"(%1593, %1614) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1616 = "llvm.extractelement"(%1615, %1598) : (vector<2xi64>, i64) -> i64
  %1617 = "llvm.lshr"(%1616, %1599) : (i64, i64) -> i64
  %1618 = "llvm.and"(%1615, %1597) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1619 = "llvm.mul"(%1617, %1600) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1620 = "llvm.shufflevector"(%1607, %1615) <{mask = array<i32: 1, 2>}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1621 = "llvm.lshr"(%1620, %1594) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1622 = "llvm.add"(%1619, %1610) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1623 = "llvm.add"(%1618, %1621) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  "llvm.store"(%1622, %arg74) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.store"(%1623, %1613) <{alignment = 8 : i64, ordering = 0 : i64}> : (vector<2xi64>, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end MLIR.Agave.Serial
