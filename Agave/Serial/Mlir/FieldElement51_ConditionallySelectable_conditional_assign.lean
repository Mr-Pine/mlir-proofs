module

-- agave-build/out/serial-noinline/op/_RNvXs7_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldNtB5_14FieldElement51NtCs3X6wZJE6GDg_6subtle23ConditionallySelectable18conditional_assign.mlir
-- <solana_ed25519[1fe0933b11699477]::backend::serial::u64::field::FieldElement51 as subtle[2e0bf2bcb38a7e1c]::ConditionallySelectable>::conditional_assign

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Agave.Serial

@[expose] public section

mlir_def FieldElement51_ConditionallySelectable_conditional_assign :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.noundef}], dso_local, function_type = !llvm.func<void (ptr, ptr, i8)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], sym_name = "_RNvXs7_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldNtB5_14FieldElement51NtCs3X6wZJE6GDg_6subtle23ConditionallySelectable18conditional_assign", target_cpu = "x86-64-v2", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg21: !llvm.ptr, %arg22: !llvm.ptr, %arg23: i8):
  %264 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %265 = "llvm.mlir.poison"() : () -> vector<2xi64>
  %266 = "llvm.zext"(%arg23) : (i8) -> i64
  %267 = "llvm.sub"(%264, %266) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %268 = "llvm.load"(%arg21) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  %269 = "llvm.load"(%arg22) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  %270 = "llvm.xor"(%269, %268) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %271 = "llvm.insertelement"(%265, %267, %264) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  %272 = "llvm.shufflevector"(%271, %265) <{mask = array<i32: 0, 0>}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %273 = "llvm.and"(%270, %272) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %274 = "llvm.xor"(%273, %268) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  "llvm.store"(%274, %arg21) <{alignment = 8 : i64, ordering = 0 : i64}> : (vector<2xi64>, !llvm.ptr) -> ()
  %275 = "llvm.getelementptr"(%arg21) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %276 = "llvm.getelementptr"(%arg22) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %277 = "llvm.load"(%275) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  %278 = "llvm.load"(%276) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  %279 = "llvm.xor"(%278, %277) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %280 = "llvm.and"(%279, %272) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %281 = "llvm.xor"(%280, %277) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  "llvm.store"(%281, %275) <{alignment = 8 : i64, ordering = 0 : i64}> : (vector<2xi64>, !llvm.ptr) -> ()
  %282 = "llvm.getelementptr"(%arg21) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %283 = "llvm.load"(%282) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %284 = "llvm.getelementptr"(%arg22) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %285 = "llvm.load"(%284) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %286 = "llvm.xor"(%285, %283) : (i64, i64) -> i64
  %287 = "llvm.and"(%286, %267) : (i64, i64) -> i64
  %288 = "llvm.xor"(%287, %283) : (i64, i64) -> i64
  "llvm.store"(%288, %282) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end MLIR.Agave.Serial
