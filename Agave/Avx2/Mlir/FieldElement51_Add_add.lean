module

-- agave-build/out/avx2-noinline/op/_RNvXs1_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u645fieldRNtB5_14FieldElement51NtNtNtCsgxBkk5gSRhY_4core3ops5arith3Add3add.mlir
-- <&solana_ed25519[c79103de3f6f5451]::backend::serial::u64::field::FieldElement51 as core[c0acaeba6ab4c2e0]::ops::arith::Add>::add

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Agave.Avx2

@[expose] public section

mlir_def FieldElement51_Add_add :=
#alias_scope_domain102 = #llvm.alias_scope_domain<id = distinct[102]<>, description = "_RNvXs0_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u645fieldNtB5_14FieldElement51INtNtNtCsgxBkk5gSRhY_4core3ops5arith9AddAssignRB16_E10add_assign">
#alias_scope175 = #llvm.alias_scope<id = distinct[317]<>, domain = #alias_scope_domain102, description = "_RNvXs0_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u645fieldNtB5_14FieldElement51INtNtNtCsgxBkk5gSRhY_4core3ops5arith9AddAssignRB16_E10add_assign: argument 1">
#alias_scope176 = #llvm.alias_scope<id = distinct[318]<>, domain = #alias_scope_domain102, description = "_RNvXs0_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u645fieldNtB5_14FieldElement51INtNtNtCsgxBkk5gSRhY_4core3ops5arith9AddAssignRB16_E10add_assign: argument 0">
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 8 : i64, llvm.dead_on_unwind, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writable, llvm.writeonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], sym_name = "_RNvXs1_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u645fieldRNtB5_14FieldElement51NtNtNtCsgxBkk5gSRhY_4core3ops5arith3Add3add", target_cpu = "x86-64-v2", target_features = #llvm.target_features<["+avx", "+avx2", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+crc32", "+ssse3"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg56: !llvm.ptr, %arg57: !llvm.ptr, %arg58: !llvm.ptr):
  %2521 = "llvm.getelementptr"(%arg57) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %2522 = "llvm.load"(%2521) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2523 = "llvm.getelementptr"(%arg58) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %2524 = "llvm.load"(%2523) <{alias_scopes = [#alias_scope175], alignment = 8 : i64, noalias_scopes = [#alias_scope176], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2525 = "llvm.add"(%2522, %2524) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2526 = "llvm.load"(%arg57) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2527 = "llvm.load"(%arg58) <{alias_scopes = [#alias_scope175], alignment = 8 : i64, noalias_scopes = [#alias_scope176], ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2528 = "llvm.add"(%2526, %2527) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.store"(%2528, %arg56) <{alignment = 8 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %2529 = "llvm.getelementptr"(%arg56) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2525, %2529) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end MLIR.Agave.Avx2
