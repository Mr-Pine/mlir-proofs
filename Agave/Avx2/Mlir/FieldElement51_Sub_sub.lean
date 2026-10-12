module

-- agave-build/out/avx2-noinline-big/op/_RNvXs3_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u645fieldRNtB5_14FieldElement51NtNtNtCsgxBkk5gSRhY_4core3ops5arith3Sub3sub.mlir
-- <&solana_ed25519[c79103de3f6f5451]::backend::serial::u64::field::FieldElement51 as core[c0acaeba6ab4c2e0]::ops::arith::Sub>::sub

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Agave.Avx2

@[expose] public section

mlir_def FieldElement51_Sub_sub :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 8 : i64, llvm.dead_on_unwind, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writable, llvm.writeonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], sym_name = "_RNvXs3_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u645fieldRNtB5_14FieldElement51NtNtNtCsgxBkk5gSRhY_4core3ops5arith3Sub3sub", target_cpu = "x86-64-v2", target_features = #llvm.target_features<["+avx", "+avx2", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+crc32", "+ssse3"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg108: !llvm.ptr, %arg109: !llvm.ptr, %arg110: !llvm.ptr):
  %3769 = "llvm.mlir.constant"() <{value = dense<[36028797018963664, 36028797018963952, 36028797018963952, 36028797018963952]> : vector<4xi64>}> : () -> vector<4xi64>
  %3770 = "llvm.mlir.constant"() <{value = dense<36028797018963952> : vector<4xi64>}> : () -> vector<4xi64>
  %3771 = "llvm.mlir.constant"() <{value = dense<51> : vector<4xi64>}> : () -> vector<4xi64>
  %3772 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %3773 = "llvm.mlir.constant"() <{value = 51 : i64}> : () -> i64
  %3774 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %3775 = "llvm.mlir.constant"() <{value = 2251799813685247 : i64}> : () -> i64
  %3776 = "llvm.mlir.constant"() <{value = dense<2251799813685247> : vector<4xi64>}> : () -> vector<4xi64>
  %3777 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %3778 = "llvm.getelementptr"(%arg109) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %3779 = "llvm.getelementptr"(%arg110) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %3780 = "llvm.getelementptr"(%arg108) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %3781 = "llvm.load"(%arg109) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3782 = "llvm.load"(%3778) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3783 = "llvm.add"(%3781, %3769) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3784 = "llvm.load"(%arg110) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3785 = "llvm.add"(%3782, %3770) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3786 = "llvm.load"(%3779) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3787 = "llvm.sub"(%3783, %3784) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3788 = "llvm.sub"(%3785, %3786) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3789 = "llvm.lshr"(%3787, %3771) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3790 = "llvm.extractelement"(%3788, %3772) : (vector<4xi64>, i64) -> i64
  %3791 = "llvm.lshr"(%3790, %3773) : (i64, i64) -> i64
  %3792 = "llvm.extractelement"(%3787, %3774) : (vector<4xi64>, i64) -> i64
  %3793 = "llvm.and"(%3792, %3775) : (i64, i64) -> i64
  %3794 = "llvm.and"(%3788, %3776) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3795 = "llvm.mul"(%3791, %3777) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %3796 = "llvm.add"(%3795, %3793) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %3797 = "llvm.add"(%3794, %3789) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.store"(%3796, %arg108) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.store"(%3797, %3780) <{alignment = 8 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end MLIR.Agave.Avx2
