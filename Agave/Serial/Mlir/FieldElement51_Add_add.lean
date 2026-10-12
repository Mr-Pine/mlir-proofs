module

-- agave-build/out/serial-noinline-big/op/_RNvXs1_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldRNtB5_14FieldElement51NtNtNtCsgxBkk5gSRhY_4core3ops5arith3Add3add.mlir
-- <&solana_ed25519[1fe0933b11699477]::backend::serial::u64::field::FieldElement51 as core[c0acaeba6ab4c2e0]::ops::arith::Add>::add

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Agave.Serial

@[expose] public section

mlir_def FieldElement51_Add_add :=
#alias_scope_domain4 = #llvm.alias_scope_domain<id = distinct[4]<>, description = "_RNvXs0_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldNtB5_14FieldElement51INtNtNtCsgxBkk5gSRhY_4core3ops5arith9AddAssignRB16_E10add_assign">
#alias_scope8 = #llvm.alias_scope<id = distinct[84]<>, domain = #alias_scope_domain4, description = "_RNvXs0_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldNtB5_14FieldElement51INtNtNtCsgxBkk5gSRhY_4core3ops5arith9AddAssignRB16_E10add_assign: argument 1">
#alias_scope9 = #llvm.alias_scope<id = distinct[85]<>, domain = #alias_scope_domain4, description = "_RNvXs0_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldNtB5_14FieldElement51INtNtNtCsgxBkk5gSRhY_4core3ops5arith9AddAssignRB16_E10add_assign: argument 0">
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 8 : i64, llvm.dead_on_unwind, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writable, llvm.writeonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], sym_name = "_RNvXs1_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldRNtB5_14FieldElement51NtNtNtCsgxBkk5gSRhY_4core3ops5arith3Add3add", target_cpu = "x86-64-v2", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg89: !llvm.ptr, %arg90: !llvm.ptr, %arg91: !llvm.ptr):
  %2204 = "llvm.getelementptr"(%arg90) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %2205 = "llvm.getelementptr"(%arg90) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %2206 = "llvm.load"(%2205) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2207 = "llvm.getelementptr"(%arg91) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %2208 = "llvm.getelementptr"(%arg91) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %2209 = "llvm.load"(%2208) <{alias_scopes = [#alias_scope8], alignment = 8 : i64, noalias_scopes = [#alias_scope9], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2210 = "llvm.add"(%2206, %2209) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2211 = "llvm.load"(%arg90) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  %2212 = "llvm.load"(%arg91) <{alias_scopes = [#alias_scope8], alignment = 8 : i64, noalias_scopes = [#alias_scope9], ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  %2213 = "llvm.add"(%2211, %2212) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  "llvm.store"(%2213, %arg89) <{alignment = 8 : i64, ordering = 0 : i64}> : (vector<2xi64>, !llvm.ptr) -> ()
  %2214 = "llvm.getelementptr"(%arg89) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %2215 = "llvm.load"(%2204) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  %2216 = "llvm.load"(%2207) <{alias_scopes = [#alias_scope8], alignment = 8 : i64, noalias_scopes = [#alias_scope9], ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  %2217 = "llvm.add"(%2215, %2216) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  "llvm.store"(%2217, %2214) <{alignment = 8 : i64, ordering = 0 : i64}> : (vector<2xi64>, !llvm.ptr) -> ()
  %2218 = "llvm.getelementptr"(%arg89) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2210, %2218) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end MLIR.Agave.Serial
