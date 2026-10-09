module

-- build/llvm23/mlir_canonicalized/ref/op/fiat_25519_carry_mul.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Firedancer.Ref

@[expose] public section

mlir_def fiat_25519_carry_mul :=
#tbaa_root = #llvm.tbaa_root<id = "Simple C/C++ TBAA">
#tbaa_type_desc = #llvm.tbaa_type_desc<id = "omnipotent char", members = {<#tbaa_root, 0>}>
#tbaa_type_desc1 = #llvm.tbaa_type_desc<id = "long", members = {<#tbaa_type_desc, 0>}>
#tbaa_tag1 = #llvm.tbaa_tag<base_type = #tbaa_type_desc1, access_type = #tbaa_type_desc1, offset = 0>
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], sym_name = "fiat_25519_carry_mul", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg34: !llvm.ptr, %arg35: !llvm.ptr, %arg36: !llvm.ptr):
  %607 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %608 = "llvm.mlir.constant"() <{value = 51 : i128}> : () -> i128
  %609 = "llvm.mlir.constant"() <{value = 2251799813685247 : i64}> : () -> i64
  %610 = "llvm.mlir.constant"() <{value = 18446744073709551615 : i128}> : () -> i128
  %611 = "llvm.mlir.constant"() <{value = 51 : i64}> : () -> i64
  %612 = "llvm.getelementptr"(%arg35) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %613 = "llvm.load"(%612) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %614 = "llvm.zext"(%613) : (i64) -> i128
  %615 = "llvm.getelementptr"(%arg36) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %616 = "llvm.load"(%615) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %617 = "llvm.mul"(%616, %607) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %618 = "llvm.zext"(%617) : (i64) -> i128
  %619 = "llvm.mul"(%618, %614) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %620 = "llvm.getelementptr"(%arg36) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %621 = "llvm.load"(%620) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %622 = "llvm.mul"(%621, %607) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %623 = "llvm.zext"(%622) : (i64) -> i128
  %624 = "llvm.mul"(%623, %614) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %625 = "llvm.getelementptr"(%arg36) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %626 = "llvm.load"(%625) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %627 = "llvm.mul"(%626, %607) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %628 = "llvm.zext"(%627) : (i64) -> i128
  %629 = "llvm.mul"(%628, %614) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %630 = "llvm.getelementptr"(%arg36) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %631 = "llvm.load"(%630) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %632 = "llvm.mul"(%631, %607) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %633 = "llvm.zext"(%632) : (i64) -> i128
  %634 = "llvm.mul"(%633, %614) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %635 = "llvm.getelementptr"(%arg35) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %636 = "llvm.load"(%635) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %637 = "llvm.zext"(%636) : (i64) -> i128
  %638 = "llvm.mul"(%637, %618) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %639 = "llvm.mul"(%637, %623) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %640 = "llvm.mul"(%637, %628) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %641 = "llvm.getelementptr"(%arg35) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %642 = "llvm.load"(%641) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %643 = "llvm.zext"(%642) : (i64) -> i128
  %644 = "llvm.mul"(%643, %618) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %645 = "llvm.mul"(%643, %623) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %646 = "llvm.getelementptr"(%arg35) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %647 = "llvm.load"(%646) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %648 = "llvm.zext"(%647) : (i64) -> i128
  %649 = "llvm.mul"(%648, %618) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %650 = "llvm.load"(%arg36) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %651 = "llvm.zext"(%650) : (i64) -> i128
  %652 = "llvm.mul"(%651, %614) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %653 = "llvm.zext"(%631) : (i64) -> i128
  %654 = "llvm.mul"(%637, %653) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %655 = "llvm.mul"(%651, %637) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %656 = "llvm.zext"(%626) : (i64) -> i128
  %657 = "llvm.mul"(%643, %656) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %658 = "llvm.mul"(%643, %653) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %659 = "llvm.mul"(%651, %643) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %660 = "llvm.zext"(%621) : (i64) -> i128
  %661 = "llvm.mul"(%648, %660) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %662 = "llvm.mul"(%648, %656) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %663 = "llvm.mul"(%648, %653) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %664 = "llvm.mul"(%651, %648) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %665 = "llvm.load"(%arg35) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %666 = "llvm.zext"(%665) : (i64) -> i128
  %667 = "llvm.zext"(%616) : (i64) -> i128
  %668 = "llvm.mul"(%666, %667) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %669 = "llvm.mul"(%666, %660) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %670 = "llvm.mul"(%666, %656) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %671 = "llvm.mul"(%666, %653) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %672 = "llvm.mul"(%666, %651) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %673 = "llvm.add"(%640, %634) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %674 = "llvm.add"(%673, %645) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %675 = "llvm.add"(%674, %649) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %676 = "llvm.add"(%675, %672) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %677 = "llvm.lshr"(%676, %608) : (i128, i128) -> i128
  %678 = "llvm.trunc"(%676) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %679 = "llvm.and"(%678, %609) : (i64, i64) -> i64
  %680 = "llvm.add"(%638, %624) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %681 = "llvm.add"(%639, %629) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %682 = "llvm.add"(%681, %644) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %683 = "llvm.add"(%682, %664) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %684 = "llvm.add"(%683, %671) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %685 = "llvm.and"(%677, %610) : (i128, i128) -> i128
  %686 = "llvm.add"(%684, %685) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %687 = "llvm.lshr"(%686, %608) : (i128, i128) -> i128
  %688 = "llvm.trunc"(%686) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %689 = "llvm.and"(%688, %609) : (i64, i64) -> i64
  %690 = "llvm.and"(%687, %610) : (i128, i128) -> i128
  %691 = "llvm.add"(%680, %663) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %692 = "llvm.add"(%691, %659) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %693 = "llvm.add"(%692, %670) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %694 = "llvm.add"(%693, %690) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %695 = "llvm.lshr"(%694, %608) : (i128, i128) -> i128
  %696 = "llvm.trunc"(%694) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %697 = "llvm.and"(%696, %609) : (i64, i64) -> i64
  %698 = "llvm.and"(%695, %610) : (i128, i128) -> i128
  %699 = "llvm.add"(%658, %619) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %700 = "llvm.add"(%699, %662) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %701 = "llvm.add"(%700, %655) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %702 = "llvm.add"(%701, %669) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %703 = "llvm.add"(%702, %698) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %704 = "llvm.lshr"(%703, %608) : (i128, i128) -> i128
  %705 = "llvm.trunc"(%703) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %706 = "llvm.and"(%705, %609) : (i64, i64) -> i64
  %707 = "llvm.and"(%704, %610) : (i128, i128) -> i128
  %708 = "llvm.add"(%657, %654) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %709 = "llvm.add"(%708, %661) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %710 = "llvm.add"(%709, %652) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %711 = "llvm.add"(%710, %668) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %712 = "llvm.add"(%711, %707) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %713 = "llvm.lshr"(%712, %608) : (i128, i128) -> i128
  %714 = "llvm.trunc"(%713) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %715 = "llvm.trunc"(%712) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %716 = "llvm.and"(%715, %609) : (i64, i64) -> i64
  %717 = "llvm.mul"(%714, %607) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %718 = "llvm.add"(%717, %679) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %719 = "llvm.lshr"(%718, %611) : (i64, i64) -> i64
  %720 = "llvm.and"(%718, %609) : (i64, i64) -> i64
  %721 = "llvm.add"(%719, %689) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %722 = "llvm.lshr"(%721, %611) : (i64, i64) -> i64
  %723 = "llvm.and"(%721, %609) : (i64, i64) -> i64
  %724 = "llvm.add"(%722, %697) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  "llvm.store"(%720, %arg34) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  %725 = "llvm.getelementptr"(%arg34) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%723, %725) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  %726 = "llvm.getelementptr"(%arg34) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%724, %726) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  %727 = "llvm.getelementptr"(%arg34) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%706, %727) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  %728 = "llvm.getelementptr"(%arg34) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%716, %728) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end MLIR.Firedancer.Ref
