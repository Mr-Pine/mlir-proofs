module

-- agave-build/out/serial-noinline-big/op/_RNvMs2_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar523add.mlir
-- <solana_ed25519[1fe0933b11699477]::backend::serial::u64::scalar::Scalar52>::add

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Agave.Serial.Mlir.Scalar52_sub

meta import MLIR.Semantics.Func
meta import Agave.Serial.Mlir.Scalar52_sub

namespace MLIR.Agave.Serial

@[expose] public section

mlir_def Scalar52_add :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 8 : i64, llvm.dead_on_unwind, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writable, llvm.writeonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], sym_name = "_RNvMs2_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar523add", target_cpu = "x86-64-v2", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg56: !llvm.ptr, %arg57: !llvm.ptr, %arg58: !llvm.ptr):
  %680 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %681 = "llvm.mlir.constant"() <{value = 4503599627370495 : i64}> : () -> i64
  %682 = "llvm.mlir.constant"() <{value = 52 : i64}> : () -> i64
  %683 = "llvm.alloca"(%680) <{alignment = 8 : i64, elem_type = !llvm.array<40 x i8>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%683) : (!llvm.ptr) -> ()
  %684 = "llvm.load"(%arg57) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %685 = "llvm.load"(%arg58) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %686 = "llvm.add"(%684, %685) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %687 = "llvm.and"(%686, %681) : (i64, i64) -> i64
  "llvm.store"(%687, %683) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %688 = "llvm.getelementptr"(%arg57) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %689 = "llvm.load"(%688) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %690 = "llvm.getelementptr"(%arg58) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %691 = "llvm.load"(%690) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %692 = "llvm.lshr"(%686, %682) : (i64, i64) -> i64
  %693 = "llvm.add"(%689, %692) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %694 = "llvm.add"(%693, %691) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %695 = "llvm.getelementptr"(%683) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %696 = "llvm.and"(%694, %681) : (i64, i64) -> i64
  "llvm.store"(%696, %695) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %697 = "llvm.getelementptr"(%arg57) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %698 = "llvm.load"(%697) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %699 = "llvm.getelementptr"(%arg58) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %700 = "llvm.load"(%699) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %701 = "llvm.lshr"(%694, %682) : (i64, i64) -> i64
  %702 = "llvm.add"(%698, %701) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %703 = "llvm.add"(%702, %700) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %704 = "llvm.getelementptr"(%683) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %705 = "llvm.and"(%703, %681) : (i64, i64) -> i64
  "llvm.store"(%705, %704) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %706 = "llvm.getelementptr"(%arg57) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %707 = "llvm.load"(%706) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %708 = "llvm.getelementptr"(%arg58) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %709 = "llvm.load"(%708) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %710 = "llvm.lshr"(%703, %682) : (i64, i64) -> i64
  %711 = "llvm.add"(%707, %710) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %712 = "llvm.add"(%711, %709) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %713 = "llvm.getelementptr"(%683) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %714 = "llvm.and"(%712, %681) : (i64, i64) -> i64
  "llvm.store"(%714, %713) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %715 = "llvm.getelementptr"(%arg57) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %716 = "llvm.load"(%715) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %717 = "llvm.getelementptr"(%arg58) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %718 = "llvm.load"(%717) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %719 = "llvm.lshr"(%712, %682) : (i64, i64) -> i64
  %720 = "llvm.add"(%716, %719) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %721 = "llvm.add"(%720, %718) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %722 = "llvm.getelementptr"(%683) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %723 = "llvm.and"(%721, %681) : (i64, i64) -> i64
  "llvm.store"(%723, %722) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.call"(%arg56, %683) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvMs2_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar523sub, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%683) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
  with
    @_RNvMs2_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar523sub := Scalar52_sub

end

end MLIR.Agave.Serial
