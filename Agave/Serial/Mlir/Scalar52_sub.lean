module

-- agave-build/out/serial-noinline/op/_RNvMs2_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar523sub.mlir
-- <solana_ed25519[1fe0933b11699477]::backend::serial::u64::scalar::Scalar52>::sub

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Agave.Serial.Mlir.black_box_u8

meta import MLIR.Semantics.Func
meta import Agave.Serial.Mlir.black_box_u8

namespace MLIR.Agave.Serial

@[expose] public section

mlir_def Scalar52_sub :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 8 : i64, llvm.dead_on_unwind, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writable, llvm.writeonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], sym_name = "_RNvMs2_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar523sub", target_cpu = "x86-64-v2", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg30: !llvm.ptr, %arg31: !llvm.ptr):
  %590 = "llvm.mlir.constant"() <{value = -671914833335277 : i64}> : () -> i64
  %591 = "llvm.mlir.constant"() <{value = 4503599627370495 : i64}> : () -> i64
  %592 = "llvm.mlir.constant"() <{value = 63 : i64}> : () -> i64
  %593 = "llvm.mlir.constant"() <{value = -3916664325105025 : i64}> : () -> i64
  %594 = "llvm.mlir.constant"() <{value = -1367801 : i64}> : () -> i64
  %595 = "llvm.mlir.constant"() <{value = -17592186044416 : i64}> : () -> i64
  %596 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %597 = "llvm.mlir.constant"() <{value = 671914833335277 : i64}> : () -> i64
  %598 = "llvm.mlir.constant"() <{value = 3916664325105025 : i64}> : () -> i64
  %599 = "llvm.mlir.constant"() <{value = 52 : i64}> : () -> i64
  %600 = "llvm.mlir.constant"() <{value = 1367801 : i64}> : () -> i64
  %601 = "llvm.mlir.constant"() <{value = 17592186044416 : i64}> : () -> i64
  %602 = "llvm.load"(%arg31) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %603 = "llvm.add"(%602, %590) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %604 = "llvm.and"(%603, %591) : (i64, i64) -> i64
  %605 = "llvm.getelementptr"(%arg31) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %606 = "llvm.load"(%605) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %607 = "llvm.ashr"(%603, %592) : (i64, i64) -> i64
  %608 = "llvm.add"(%606, %607) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %609 = "llvm.add"(%608, %593) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %610 = "llvm.and"(%609, %591) : (i64, i64) -> i64
  %611 = "llvm.getelementptr"(%arg31) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %612 = "llvm.load"(%611) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %613 = "llvm.ashr"(%609, %592) : (i64, i64) -> i64
  %614 = "llvm.add"(%612, %613) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %615 = "llvm.add"(%614, %594) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %616 = "llvm.and"(%615, %591) : (i64, i64) -> i64
  %617 = "llvm.getelementptr"(%arg31) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %618 = "llvm.load"(%617) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %619 = "llvm.ashr"(%615, %592) : (i64, i64) -> i64
  %620 = "llvm.add"(%618, %619) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %621 = "llvm.and"(%620, %591) : (i64, i64) -> i64
  %622 = "llvm.getelementptr"(%arg31) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %623 = "llvm.load"(%622) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %624 = "llvm.ashr"(%620, %592) : (i64, i64) -> i64
  %625 = "llvm.add"(%623, %624) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %626 = "llvm.add"(%625, %595) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %627 = "llvm.lshr"(%626, %592) : (i64, i64) -> i64
  %628 = "llvm.trunc"(%627) <{overflowFlags = 3 : i32}> : (i64) -> i8
  %629 = "llvm.call"(%628) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %630 = "llvm.zext"(%629) : (i8) -> i64
  %631 = "llvm.sub"(%596, %630) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %632 = "llvm.and"(%631, %597) : (i64, i64) -> i64
  %633 = "llvm.add"(%604, %632) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %634 = "llvm.and"(%633, %591) : (i64, i64) -> i64
  %635 = "llvm.and"(%631, %598) : (i64, i64) -> i64
  %636 = "llvm.lshr"(%633, %599) : (i64, i64) -> i64
  %637 = "llvm.add"(%610, %636) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %638 = "llvm.add"(%637, %635) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %639 = "llvm.and"(%638, %591) : (i64, i64) -> i64
  %640 = "llvm.and"(%631, %600) : (i64, i64) -> i64
  %641 = "llvm.lshr"(%638, %599) : (i64, i64) -> i64
  %642 = "llvm.add"(%616, %641) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %643 = "llvm.add"(%642, %640) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %644 = "llvm.and"(%643, %591) : (i64, i64) -> i64
  %645 = "llvm.lshr"(%643, %599) : (i64, i64) -> i64
  %646 = "llvm.add"(%621, %645) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %647 = "llvm.and"(%646, %591) : (i64, i64) -> i64
  %648 = "llvm.and"(%631, %601) : (i64, i64) -> i64
  %649 = "llvm.lshr"(%646, %599) : (i64, i64) -> i64
  %650 = "llvm.add"(%626, %649) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %651 = "llvm.add"(%650, %648) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %652 = "llvm.and"(%651, %591) : (i64, i64) -> i64
  "llvm.store"(%634, %arg30) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %653 = "llvm.getelementptr"(%arg30) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%639, %653) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %654 = "llvm.getelementptr"(%arg30) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%644, %654) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %655 = "llvm.getelementptr"(%arg30) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%647, %655) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %656 = "llvm.getelementptr"(%arg30) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%652, %656) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
  with @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519 := black_box_u8

end

end MLIR.Agave.Serial
