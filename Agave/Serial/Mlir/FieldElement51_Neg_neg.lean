module

-- agave-build/out/serial-noinline/op/_RNvXs6_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldRNtB5_14FieldElement51NtNtNtCsgxBkk5gSRhY_4core3ops5arith3Neg3neg.mlir
-- <&solana_ed25519[1fe0933b11699477]::backend::serial::u64::field::FieldElement51 as core[c0acaeba6ab4c2e0]::ops::arith::Neg>::neg

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Agave.Serial

@[expose] public section

mlir_def FieldElement51_Neg_neg :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 8 : i64, llvm.dead_on_unwind, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writable, llvm.writeonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], sym_name = "_RNvXs6_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldRNtB5_14FieldElement51NtNtNtCsgxBkk5gSRhY_4core3ops5arith3Neg3neg", target_cpu = "x86-64-v2", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg32: !llvm.ptr, %arg33: !llvm.ptr):
  %657 = "llvm.mlir.constant"() <{value = dense<[36028797018963664, 36028797018963952]> : vector<2xi64>}> : () -> vector<2xi64>
  %658 = "llvm.mlir.constant"() <{value = dense<36028797018963952> : vector<2xi64>}> : () -> vector<2xi64>
  %659 = "llvm.mlir.constant"() <{value = dense<51> : vector<2xi64>}> : () -> vector<2xi64>
  %660 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %661 = "llvm.mlir.constant"() <{value = 2251799813685247 : i64}> : () -> i64
  %662 = "llvm.mlir.constant"() <{value = dense<2251799813685247> : vector<2xi64>}> : () -> vector<2xi64>
  %663 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %664 = "llvm.mlir.constant"() <{value = 51 : i64}> : () -> i64
  %665 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %666 = "llvm.getelementptr"(%arg33) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %667 = "llvm.getelementptr"(%arg33) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %668 = "llvm.getelementptr"(%arg32) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %669 = "llvm.load"(%arg33) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  %670 = "llvm.load"(%666) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  %671 = "llvm.sub"(%657, %669) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %672 = "llvm.sub"(%658, %670) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %673 = "llvm.lshr"(%671, %659) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %674 = "llvm.extractelement"(%671, %660) : (vector<2xi64>, i64) -> i64
  %675 = "llvm.and"(%674, %661) : (i64, i64) -> i64
  %676 = "llvm.and"(%672, %662) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %677 = "llvm.add"(%676, %673) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  "llvm.store"(%677, %668) <{alignment = 8 : i64, ordering = 0 : i64}> : (vector<2xi64>, !llvm.ptr) -> ()
  %678 = "llvm.getelementptr"(%arg32) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %679 = "llvm.load"(%667) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  %680 = "llvm.sub"(%658, %679) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %681 = "llvm.extractelement"(%680, %663) : (vector<2xi64>, i64) -> i64
  %682 = "llvm.lshr"(%681, %664) : (i64, i64) -> i64
  %683 = "llvm.and"(%680, %662) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %684 = "llvm.mul"(%682, %665) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %685 = "llvm.shufflevector"(%672, %680) <{mask = array<i32: 1, 2>}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %686 = "llvm.lshr"(%685, %659) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %687 = "llvm.add"(%684, %675) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %688 = "llvm.add"(%683, %686) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  "llvm.store"(%687, %arg32) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.store"(%688, %678) <{alignment = 8 : i64, ordering = 0 : i64}> : (vector<2xi64>, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end MLIR.Agave.Serial
