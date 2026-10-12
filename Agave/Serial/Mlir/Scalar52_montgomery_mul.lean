module

-- agave-build/out/serial-noinline-big/op/_RNvMs2_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar5214montgomery_mul.mlir
-- <solana_ed25519[1fe0933b11699477]::backend::serial::u64::scalar::Scalar52>::montgomery_mul

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Agave.Serial.Mlir.Scalar52_sub

meta import MLIR.Semantics.Func
meta import Agave.Serial.Mlir.Scalar52_sub

namespace MLIR.Agave.Serial

@[expose] public section

mlir_def Scalar52_montgomery_mul :=
#alias_scope_domain21 = #llvm.alias_scope_domain<id = distinct[21]<>, description = "_RNvMs2_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar5212mul_internal">
#alias_scope_domain22 = #llvm.alias_scope_domain<id = distinct[22]<>, description = "_RNvMs2_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar5217montgomery_reduce">
#alias_scope_domain23 = #llvm.alias_scope_domain<id = distinct[23]<>, description = "_RNvXCshxoft6be3N1_7zeroizeoNtB2_7Zeroize7zeroizeCs2JGgYtL0Fal_14solana_ed25519">
#alias_scope_domain24 = #llvm.alias_scope_domain<id = distinct[24]<>, description = "_RNvXs4_Cshxoft6be3N1_7zeroizeINtNtNtCsgxBkk5gSRhY_4core5slice4iter7IterMutoENtB5_7Zeroize7zeroizeCs2JGgYtL0Fal_14solana_ed25519">
#alias_scope29 = #llvm.alias_scope<id = distinct[105]<>, domain = #alias_scope_domain21, description = "_RNvMs2_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar5212mul_internal: argument 0">
#alias_scope30 = #llvm.alias_scope<id = distinct[106]<>, domain = #alias_scope_domain21, description = "_RNvMs2_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar5212mul_internal: argument 1">
#alias_scope31 = #llvm.alias_scope<id = distinct[107]<>, domain = #alias_scope_domain21, description = "_RNvMs2_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar5212mul_internal: argument 2">
#alias_scope32 = #llvm.alias_scope<id = distinct[108]<>, domain = #alias_scope_domain22, description = "_RNvMs2_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar5217montgomery_reduce: argument 0">
#alias_scope33 = #llvm.alias_scope<id = distinct[109]<>, domain = #alias_scope_domain22, description = "_RNvMs2_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar5217montgomery_reduce: argument 1">
#alias_scope34 = #llvm.alias_scope<id = distinct[110]<>, domain = #alias_scope_domain23, description = "_RNvXCshxoft6be3N1_7zeroizeoNtB2_7Zeroize7zeroizeCs2JGgYtL0Fal_14solana_ed25519: argument 0">
#alias_scope35 = #llvm.alias_scope<id = distinct[111]<>, domain = #alias_scope_domain24, description = "_RNvXs4_Cshxoft6be3N1_7zeroizeINtNtNtCsgxBkk5gSRhY_4core5slice4iter7IterMutoENtB5_7Zeroize7zeroizeCs2JGgYtL0Fal_14solana_ed25519: argument 0">
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 8 : i64, llvm.dead_on_unwind, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writable, llvm.writeonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], sym_name = "_RNvMs2_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar5214montgomery_mul", target_cpu = "x86-64-v2", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg59: !llvm.ptr, %arg60: !llvm.ptr, %arg61: !llvm.ptr):
  %724 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %725 = "llvm.mlir.constant"() <{value = 1439961107955227 : i64}> : () -> i64
  %726 = "llvm.mlir.constant"() <{value = 4503599627370495 : i64}> : () -> i64
  %727 = "llvm.mlir.constant"() <{value = 671914833335277 : i128}> : () -> i128
  %728 = "llvm.mlir.constant"() <{value = 52 : i128}> : () -> i128
  %729 = "llvm.mlir.constant"() <{value = 3916664325105025 : i128}> : () -> i128
  %730 = "llvm.mlir.constant"() <{value = 1367801 : i128}> : () -> i128
  %731 = "llvm.mlir.constant"() <{value = 44 : i128}> : () -> i128
  %732 = "llvm.mlir.constant"() <{value = 0 : i128}> : () -> i128
  %733 = "llvm.alloca"(%724) <{alignment = 8 : i64, elem_type = !llvm.array<40 x i8>}> : (i32) -> !llvm.ptr
  %734 = "llvm.alloca"(%724) <{alignment = 16 : i64, elem_type = i128}> : (i32) -> !llvm.ptr
  %735 = "llvm.alloca"(%724) <{alignment = 16 : i64, elem_type = i128}> : (i32) -> !llvm.ptr
  %736 = "llvm.alloca"(%724) <{alignment = 16 : i64, elem_type = i128}> : (i32) -> !llvm.ptr
  %737 = "llvm.alloca"(%724) <{alignment = 16 : i64, elem_type = i128}> : (i32) -> !llvm.ptr
  %738 = "llvm.alloca"(%724) <{alignment = 16 : i64, elem_type = i128}> : (i32) -> !llvm.ptr
  %739 = "llvm.alloca"(%724) <{alignment = 16 : i64, elem_type = i128}> : (i32) -> !llvm.ptr
  %740 = "llvm.alloca"(%724) <{alignment = 16 : i64, elem_type = i128}> : (i32) -> !llvm.ptr
  %741 = "llvm.alloca"(%724) <{alignment = 16 : i64, elem_type = i128}> : (i32) -> !llvm.ptr
  %742 = "llvm.alloca"(%724) <{alignment = 16 : i64, elem_type = i128}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%734) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%735) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%736) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%737) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%738) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%739) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%740) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%741) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%742) : (!llvm.ptr) -> ()
  "llvm.intr.experimental.noalias.scope.decl"() <{scope = #alias_scope29}> : () -> ()
  "llvm.intr.experimental.noalias.scope.decl"() <{scope = #alias_scope30}> : () -> ()
  "llvm.intr.experimental.noalias.scope.decl"() <{scope = #alias_scope31}> : () -> ()
  %743 = "llvm.load"(%arg60) <{alias_scopes = [#alias_scope30], alignment = 8 : i64, noalias_scopes = [#alias_scope29, #alias_scope31], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %744 = "llvm.load"(%arg61) <{alias_scopes = [#alias_scope31], alignment = 8 : i64, noalias_scopes = [#alias_scope29, #alias_scope30], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %745 = "llvm.zext"(%743) : (i64) -> i128
  %746 = "llvm.zext"(%744) : (i64) -> i128
  %747 = "llvm.mul"(%746, %745) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %748 = "llvm.getelementptr"(%arg61) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %749 = "llvm.load"(%748) <{alias_scopes = [#alias_scope31], alignment = 8 : i64, noalias_scopes = [#alias_scope29, #alias_scope30], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %750 = "llvm.zext"(%749) : (i64) -> i128
  %751 = "llvm.mul"(%750, %745) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %752 = "llvm.getelementptr"(%arg60) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %753 = "llvm.load"(%752) <{alias_scopes = [#alias_scope30], alignment = 8 : i64, noalias_scopes = [#alias_scope29, #alias_scope31], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %754 = "llvm.zext"(%753) : (i64) -> i128
  %755 = "llvm.mul"(%754, %746) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %756 = "llvm.add"(%755, %751) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  "llvm.store"(%756, %735) <{alias_scopes = [#alias_scope29], alignment = 16 : i64, noalias_scopes = [#alias_scope30, #alias_scope31], ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
  %757 = "llvm.getelementptr"(%arg61) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %758 = "llvm.load"(%757) <{alias_scopes = [#alias_scope31], alignment = 8 : i64, noalias_scopes = [#alias_scope29, #alias_scope30], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %759 = "llvm.zext"(%758) : (i64) -> i128
  %760 = "llvm.mul"(%759, %745) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %761 = "llvm.mul"(%754, %750) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %762 = "llvm.add"(%760, %761) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %763 = "llvm.getelementptr"(%arg60) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %764 = "llvm.load"(%763) <{alias_scopes = [#alias_scope30], alignment = 8 : i64, noalias_scopes = [#alias_scope29, #alias_scope31], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %765 = "llvm.zext"(%764) : (i64) -> i128
  %766 = "llvm.mul"(%765, %746) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %767 = "llvm.add"(%762, %766) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  "llvm.store"(%767, %736) <{alias_scopes = [#alias_scope29], alignment = 16 : i64, noalias_scopes = [#alias_scope30, #alias_scope31], ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
  %768 = "llvm.getelementptr"(%arg61) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %769 = "llvm.load"(%768) <{alias_scopes = [#alias_scope31], alignment = 8 : i64, noalias_scopes = [#alias_scope29, #alias_scope30], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %770 = "llvm.zext"(%769) : (i64) -> i128
  %771 = "llvm.mul"(%770, %745) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %772 = "llvm.mul"(%759, %754) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %773 = "llvm.mul"(%765, %750) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %774 = "llvm.getelementptr"(%arg60) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %775 = "llvm.load"(%774) <{alias_scopes = [#alias_scope30], alignment = 8 : i64, noalias_scopes = [#alias_scope29, #alias_scope31], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %776 = "llvm.zext"(%775) : (i64) -> i128
  %777 = "llvm.mul"(%776, %746) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %778 = "llvm.add"(%773, %772) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %779 = "llvm.add"(%778, %771) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %780 = "llvm.add"(%779, %777) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  "llvm.store"(%780, %737) <{alias_scopes = [#alias_scope29], alignment = 16 : i64, noalias_scopes = [#alias_scope30, #alias_scope31], ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
  %781 = "llvm.getelementptr"(%arg61) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %782 = "llvm.load"(%781) <{alias_scopes = [#alias_scope31], alignment = 8 : i64, noalias_scopes = [#alias_scope29, #alias_scope30], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %783 = "llvm.zext"(%782) : (i64) -> i128
  %784 = "llvm.mul"(%783, %745) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %785 = "llvm.mul"(%770, %754) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %786 = "llvm.mul"(%765, %759) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %787 = "llvm.mul"(%776, %750) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %788 = "llvm.getelementptr"(%arg60) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %789 = "llvm.load"(%788) <{alias_scopes = [#alias_scope30], alignment = 8 : i64, noalias_scopes = [#alias_scope29, #alias_scope31], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %790 = "llvm.zext"(%789) : (i64) -> i128
  %791 = "llvm.mul"(%790, %746) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %792 = "llvm.add"(%785, %786) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %793 = "llvm.add"(%792, %787) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %794 = "llvm.add"(%793, %784) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %795 = "llvm.add"(%794, %791) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  "llvm.store"(%795, %738) <{alias_scopes = [#alias_scope29], alignment = 16 : i64, noalias_scopes = [#alias_scope30, #alias_scope31], ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
  %796 = "llvm.mul"(%783, %754) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %797 = "llvm.mul"(%770, %765) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %798 = "llvm.mul"(%776, %759) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %799 = "llvm.mul"(%790, %750) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %800 = "llvm.add"(%798, %797) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %801 = "llvm.add"(%800, %796) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %802 = "llvm.add"(%801, %799) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  "llvm.store"(%802, %739) <{alias_scopes = [#alias_scope29], alignment = 16 : i64, noalias_scopes = [#alias_scope30, #alias_scope31], ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
  %803 = "llvm.mul"(%783, %765) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %804 = "llvm.mul"(%776, %770) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %805 = "llvm.add"(%803, %804) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %806 = "llvm.mul"(%790, %759) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %807 = "llvm.add"(%805, %806) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  "llvm.store"(%807, %740) <{alias_scopes = [#alias_scope29], alignment = 16 : i64, noalias_scopes = [#alias_scope30, #alias_scope31], ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
  %808 = "llvm.mul"(%783, %776) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %809 = "llvm.mul"(%790, %770) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %810 = "llvm.add"(%809, %808) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  "llvm.store"(%810, %741) <{alias_scopes = [#alias_scope29], alignment = 16 : i64, noalias_scopes = [#alias_scope30, #alias_scope31], ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
  %811 = "llvm.mul"(%790, %783) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  "llvm.store"(%811, %742) <{alias_scopes = [#alias_scope29], alignment = 16 : i64, noalias_scopes = [#alias_scope30, #alias_scope31], ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
  %812 = "llvm.trunc"(%747) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %813 = "llvm.mul"(%812, %725) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %814 = "llvm.and"(%813, %726) : (i64, i64) -> i64
  %815 = "llvm.zext"(%814) <{nonNeg}> : (i64) -> i128
  %816 = "llvm.mul"(%815, %727) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %817 = "llvm.add"(%816, %747) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %818 = "llvm.lshr"(%817, %728) : (i128, i128) -> i128
  %819 = "llvm.mul"(%815, %729) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %820 = "llvm.add"(%819, %756) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %821 = "llvm.add"(%820, %818) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %822 = "llvm.trunc"(%821) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %823 = "llvm.mul"(%822, %725) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %824 = "llvm.and"(%823, %726) : (i64, i64) -> i64
  %825 = "llvm.zext"(%824) <{nonNeg}> : (i64) -> i128
  %826 = "llvm.mul"(%825, %727) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %827 = "llvm.add"(%826, %821) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %828 = "llvm.lshr"(%827, %728) : (i128, i128) -> i128
  %829 = "llvm.mul"(%815, %730) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %830 = "llvm.mul"(%825, %729) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %831 = "llvm.add"(%767, %829) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %832 = "llvm.add"(%831, %830) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %833 = "llvm.add"(%832, %828) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %834 = "llvm.trunc"(%833) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %835 = "llvm.mul"(%834, %725) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %836 = "llvm.and"(%835, %726) : (i64, i64) -> i64
  %837 = "llvm.zext"(%836) <{nonNeg}> : (i64) -> i128
  %838 = "llvm.mul"(%837, %727) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %839 = "llvm.add"(%838, %833) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %840 = "llvm.lshr"(%839, %728) : (i128, i128) -> i128
  %841 = "llvm.mul"(%825, %730) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %842 = "llvm.mul"(%837, %729) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %843 = "llvm.add"(%841, %780) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %844 = "llvm.add"(%843, %842) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %845 = "llvm.add"(%844, %840) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %846 = "llvm.trunc"(%845) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %847 = "llvm.mul"(%846, %725) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %848 = "llvm.and"(%847, %726) : (i64, i64) -> i64
  %849 = "llvm.zext"(%848) <{nonNeg}> : (i64) -> i128
  %850 = "llvm.mul"(%849, %727) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %851 = "llvm.add"(%850, %845) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %852 = "llvm.lshr"(%851, %728) : (i128, i128) -> i128
  %853 = "llvm.shl"(%815, %731) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %854 = "llvm.mul"(%837, %730) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %855 = "llvm.mul"(%849, %729) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %856 = "llvm.add"(%795, %853) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %857 = "llvm.add"(%856, %854) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %858 = "llvm.add"(%857, %855) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %859 = "llvm.add"(%858, %852) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %860 = "llvm.trunc"(%859) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %861 = "llvm.mul"(%860, %725) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %862 = "llvm.and"(%861, %726) : (i64, i64) -> i64
  %863 = "llvm.zext"(%862) <{nonNeg}> : (i64) -> i128
  %864 = "llvm.mul"(%863, %727) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %865 = "llvm.add"(%864, %859) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %866 = "llvm.lshr"(%865, %728) : (i128, i128) -> i128
  %867 = "llvm.shl"(%825, %731) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %868 = "llvm.mul"(%849, %730) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %869 = "llvm.mul"(%863, %729) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %870 = "llvm.add"(%867, %802) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %871 = "llvm.add"(%870, %868) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %872 = "llvm.add"(%871, %869) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %873 = "llvm.add"(%872, %866) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %874 = "llvm.trunc"(%873) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %875 = "llvm.and"(%874, %726) : (i64, i64) -> i64
  %876 = "llvm.lshr"(%873, %728) : (i128, i128) -> i128
  %877 = "llvm.shl"(%837, %731) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %878 = "llvm.mul"(%863, %730) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %879 = "llvm.add"(%877, %807) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %880 = "llvm.add"(%879, %878) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %881 = "llvm.add"(%880, %876) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %882 = "llvm.trunc"(%881) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %883 = "llvm.and"(%882, %726) : (i64, i64) -> i64
  %884 = "llvm.lshr"(%881, %728) : (i128, i128) -> i128
  %885 = "llvm.shl"(%849, %731) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %886 = "llvm.add"(%885, %810) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %887 = "llvm.add"(%886, %884) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %888 = "llvm.trunc"(%887) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %889 = "llvm.and"(%888, %726) : (i64, i64) -> i64
  %890 = "llvm.lshr"(%887, %728) : (i128, i128) -> i128
  %891 = "llvm.shl"(%863, %731) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %892 = "llvm.add"(%891, %811) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %893 = "llvm.add"(%892, %890) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %894 = "llvm.trunc"(%893) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %895 = "llvm.and"(%894, %726) : (i64, i64) -> i64
  %896 = "llvm.lshr"(%893, %728) : (i128, i128) -> i128
  %897 = "llvm.trunc"(%896) <{overflowFlags = 0 : i32}> : (i128) -> i64
  "llvm.intr.lifetime.start"(%733) : (!llvm.ptr) -> ()
  "llvm.store"(%875, %733) <{alignment = 8 : i64, noalias_scopes = [#alias_scope32, #alias_scope33], ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %898 = "llvm.getelementptr"(%733) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%883, %898) <{alignment = 8 : i64, noalias_scopes = [#alias_scope32, #alias_scope33], ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %899 = "llvm.getelementptr"(%733) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%889, %899) <{alignment = 8 : i64, noalias_scopes = [#alias_scope32, #alias_scope33], ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %900 = "llvm.getelementptr"(%733) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%895, %900) <{alignment = 8 : i64, noalias_scopes = [#alias_scope32, #alias_scope33], ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %901 = "llvm.getelementptr"(%733) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%897, %901) <{alignment = 8 : i64, noalias_scopes = [#alias_scope32, #alias_scope33], ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.call"(%arg59, %733) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvMs2_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar523sub, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%733) : (!llvm.ptr) -> ()
  "llvm.store"(%732, %734) <{alias_scopes = [#alias_scope34], alignment = 16 : i64, noalias_scopes = [#alias_scope35], ordering = 0 : i64, volatile_}> : (i128, !llvm.ptr) -> ()
  "llvm.fence"() <{ordering = 7 : i64, syncscope = "singlethread"}> : () -> ()
  "llvm.store"(%732, %735) <{alias_scopes = [#alias_scope34], alignment = 16 : i64, noalias_scopes = [#alias_scope35], ordering = 0 : i64, volatile_}> : (i128, !llvm.ptr) -> ()
  "llvm.fence"() <{ordering = 7 : i64, syncscope = "singlethread"}> : () -> ()
  "llvm.store"(%732, %736) <{alias_scopes = [#alias_scope34], alignment = 16 : i64, noalias_scopes = [#alias_scope35], ordering = 0 : i64, volatile_}> : (i128, !llvm.ptr) -> ()
  "llvm.fence"() <{ordering = 7 : i64, syncscope = "singlethread"}> : () -> ()
  "llvm.store"(%732, %737) <{alias_scopes = [#alias_scope34], alignment = 16 : i64, noalias_scopes = [#alias_scope35], ordering = 0 : i64, volatile_}> : (i128, !llvm.ptr) -> ()
  "llvm.fence"() <{ordering = 7 : i64, syncscope = "singlethread"}> : () -> ()
  "llvm.store"(%732, %738) <{alias_scopes = [#alias_scope34], alignment = 16 : i64, noalias_scopes = [#alias_scope35], ordering = 0 : i64, volatile_}> : (i128, !llvm.ptr) -> ()
  "llvm.fence"() <{ordering = 7 : i64, syncscope = "singlethread"}> : () -> ()
  "llvm.store"(%732, %739) <{alias_scopes = [#alias_scope34], alignment = 16 : i64, noalias_scopes = [#alias_scope35], ordering = 0 : i64, volatile_}> : (i128, !llvm.ptr) -> ()
  "llvm.fence"() <{ordering = 7 : i64, syncscope = "singlethread"}> : () -> ()
  "llvm.store"(%732, %740) <{alias_scopes = [#alias_scope34], alignment = 16 : i64, noalias_scopes = [#alias_scope35], ordering = 0 : i64, volatile_}> : (i128, !llvm.ptr) -> ()
  "llvm.fence"() <{ordering = 7 : i64, syncscope = "singlethread"}> : () -> ()
  "llvm.store"(%732, %741) <{alias_scopes = [#alias_scope34], alignment = 16 : i64, noalias_scopes = [#alias_scope35], ordering = 0 : i64, volatile_}> : (i128, !llvm.ptr) -> ()
  "llvm.fence"() <{ordering = 7 : i64, syncscope = "singlethread"}> : () -> ()
  "llvm.store"(%732, %742) <{alias_scopes = [#alias_scope34], alignment = 16 : i64, noalias_scopes = [#alias_scope35], ordering = 0 : i64, volatile_}> : (i128, !llvm.ptr) -> ()
  "llvm.fence"() <{ordering = 7 : i64, syncscope = "singlethread"}> : () -> ()
  "llvm.intr.lifetime.end"(%734) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%735) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%736) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%737) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%738) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%739) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%740) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%741) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%742) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
  with
    @_RNvMs2_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar523sub := Scalar52_sub

end

end MLIR.Agave.Serial
