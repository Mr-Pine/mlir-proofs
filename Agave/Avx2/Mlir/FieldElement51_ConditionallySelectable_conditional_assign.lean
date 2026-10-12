module

-- agave-build/out/avx2-noinline-big/op/_RNvXs7_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u645fieldNtB5_14FieldElement51NtCs3X6wZJE6GDg_6subtle23ConditionallySelectable18conditional_assign.mlir
-- <solana_ed25519[c79103de3f6f5451]::backend::serial::u64::field::FieldElement51 as subtle[2e0bf2bcb38a7e1c]::ConditionallySelectable>::conditional_assign

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Agave.Avx2

@[expose] public section

mlir_def FieldElement51_ConditionallySelectable_conditional_assign :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.noundef}], dso_local, function_type = !llvm.func<void (ptr, ptr, i8)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], sym_name = "_RNvXs7_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u645fieldNtB5_14FieldElement51NtCs3X6wZJE6GDg_6subtle23ConditionallySelectable18conditional_assign", target_cpu = "x86-64-v2", target_features = #llvm.target_features<["+avx", "+avx2", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+crc32", "+ssse3"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg62: !llvm.ptr, %arg63: !llvm.ptr, %arg64: i8):
  %2070 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %2071 = "llvm.mlir.poison"() : () -> vector<4xi64>
  %2072 = "llvm.zext"(%arg64) : (i8) -> i64
  %2073 = "llvm.sub"(%2070, %2072) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %2074 = "llvm.load"(%arg62) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2075 = "llvm.load"(%arg63) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2076 = "llvm.xor"(%2075, %2074) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2077 = "llvm.insertelement"(%2071, %2073, %2070) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %2078 = "llvm.shufflevector"(%2077, %2071) <{mask = array<i32: 0, 0, 0, 0>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2079 = "llvm.and"(%2076, %2078) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2080 = "llvm.xor"(%2079, %2074) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.store"(%2080, %arg62) <{alignment = 8 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %2081 = "llvm.getelementptr"(%arg62) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %2082 = "llvm.load"(%2081) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2083 = "llvm.getelementptr"(%arg63) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %2084 = "llvm.load"(%2083) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2085 = "llvm.xor"(%2084, %2082) : (i64, i64) -> i64
  %2086 = "llvm.and"(%2085, %2073) : (i64, i64) -> i64
  %2087 = "llvm.xor"(%2086, %2082) : (i64, i64) -> i64
  "llvm.store"(%2087, %2081) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end MLIR.Agave.Avx2
