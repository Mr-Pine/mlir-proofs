module

-- agave-build/out/avx2-noinline/op/_RNvXs3_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u645fieldRNtB5_14FieldElement51NtNtNtCsgxBkk5gSRhY_4core3ops5arith3Sub3sub.mlir
-- <&solana_ed25519[c79103de3f6f5451]::backend::serial::u64::field::FieldElement51 as core[c0acaeba6ab4c2e0]::ops::arith::Sub>::sub

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Agave.Avx2

@[expose] public section

mlir_def FieldElement51_Sub_sub :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 8 : i64, llvm.dead_on_unwind, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writable, llvm.writeonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], sym_name = "_RNvXs3_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u645fieldRNtB5_14FieldElement51NtNtNtCsgxBkk5gSRhY_4core3ops5arith3Sub3sub", target_cpu = "x86-64-v2", target_features = #llvm.target_features<["+avx", "+avx2", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+crc32", "+ssse3"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg62: !llvm.ptr, %arg63: !llvm.ptr, %arg64: !llvm.ptr):
  %2649 = "llvm.mlir.constant"() <{value = dense<[36028797018963664, 36028797018963952, 36028797018963952, 36028797018963952]> : vector<4xi64>}> : () -> vector<4xi64>
  %2650 = "llvm.mlir.constant"() <{value = dense<36028797018963952> : vector<4xi64>}> : () -> vector<4xi64>
  %2651 = "llvm.mlir.constant"() <{value = dense<51> : vector<4xi64>}> : () -> vector<4xi64>
  %2652 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %2653 = "llvm.mlir.constant"() <{value = 51 : i64}> : () -> i64
  %2654 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %2655 = "llvm.mlir.constant"() <{value = 2251799813685247 : i64}> : () -> i64
  %2656 = "llvm.mlir.constant"() <{value = dense<2251799813685247> : vector<4xi64>}> : () -> vector<4xi64>
  %2657 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %2658 = "llvm.getelementptr"(%arg63) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %2659 = "llvm.getelementptr"(%arg64) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %2660 = "llvm.getelementptr"(%arg62) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %2661 = "llvm.load"(%arg63) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2662 = "llvm.load"(%2658) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2663 = "llvm.add"(%2661, %2649) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2664 = "llvm.load"(%arg64) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2665 = "llvm.add"(%2662, %2650) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2666 = "llvm.load"(%2659) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2667 = "llvm.sub"(%2663, %2664) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2668 = "llvm.sub"(%2665, %2666) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2669 = "llvm.lshr"(%2667, %2651) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2670 = "llvm.extractelement"(%2668, %2652) : (vector<4xi64>, i64) -> i64
  %2671 = "llvm.lshr"(%2670, %2653) : (i64, i64) -> i64
  %2672 = "llvm.extractelement"(%2667, %2654) : (vector<4xi64>, i64) -> i64
  %2673 = "llvm.and"(%2672, %2655) : (i64, i64) -> i64
  %2674 = "llvm.and"(%2668, %2656) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2675 = "llvm.mul"(%2671, %2657) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2676 = "llvm.add"(%2675, %2673) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2677 = "llvm.add"(%2674, %2669) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.store"(%2676, %arg62) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.store"(%2677, %2660) <{alignment = 8 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end MLIR.Agave.Avx2
