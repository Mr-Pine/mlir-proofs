module

-- agave-build/out/avx2-noinline/op/_RNvXs7_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u645fieldNtB5_14FieldElement51NtCs3X6wZJE6GDg_6subtle23ConditionallySelectable18conditional_assign.mlir
-- <solana_ed25519[c79103de3f6f5451]::backend::serial::u64::field::FieldElement51 as subtle[2e0bf2bcb38a7e1c]::ConditionallySelectable>::conditional_assign

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Agave.Avx2

@[expose] public section

mlir_def FieldElement51_ConditionallySelectable_conditional_assign :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.noundef}], dso_local, function_type = !llvm.func<void (ptr, ptr, i8)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], sym_name = "_RNvXs7_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u645fieldNtB5_14FieldElement51NtCs3X6wZJE6GDg_6subtle23ConditionallySelectable18conditional_assign", target_cpu = "x86-64-v2", target_features = #llvm.target_features<["+avx", "+avx2", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+crc32", "+ssse3"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg30: !llvm.ptr, %arg31: !llvm.ptr, %arg32: i8):
  %1531 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %1532 = "llvm.mlir.poison"() : () -> vector<4xi64>
  %1533 = "llvm.zext"(%arg32) : (i8) -> i64
  %1534 = "llvm.sub"(%1531, %1533) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1535 = "llvm.load"(%arg30) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1536 = "llvm.load"(%arg31) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1537 = "llvm.xor"(%1536, %1535) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1538 = "llvm.insertelement"(%1532, %1534, %1531) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1539 = "llvm.shufflevector"(%1538, %1532) <{mask = array<i32: 0, 0, 0, 0>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1540 = "llvm.and"(%1537, %1539) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1541 = "llvm.xor"(%1540, %1535) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.store"(%1541, %arg30) <{alignment = 8 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %1542 = "llvm.getelementptr"(%arg30) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %1543 = "llvm.load"(%1542) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1544 = "llvm.getelementptr"(%arg31) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %1545 = "llvm.load"(%1544) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1546 = "llvm.xor"(%1545, %1543) : (i64, i64) -> i64
  %1547 = "llvm.and"(%1546, %1534) : (i64, i64) -> i64
  %1548 = "llvm.xor"(%1547, %1543) : (i64, i64) -> i64
  "llvm.store"(%1548, %1542) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end MLIR.Agave.Avx2
