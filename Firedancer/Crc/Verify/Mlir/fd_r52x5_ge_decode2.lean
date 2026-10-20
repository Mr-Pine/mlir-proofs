module

-- crc/out/mlirproofs/regions/verify/fd_r52x5_ge_decode2.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_limbs_eq
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_limbs_frombytes
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_add
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_lane_canon
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_mul
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_neg
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_sqr
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_sub
public import Firedancer.Crc.Verify.Mlir.wl_permute

meta import MLIR.Semantics.Func
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_limbs_eq
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_limbs_frombytes
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_add
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_lane_canon
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_mul
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_neg
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_sqr
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_sub
meta import Firedancer.Crc.Verify.Mlir.wl_permute

namespace MLIR.Firedancer.Crc.Verify

@[expose] public section

mlir_def fd_r52x5_ge_decode2 :=
#loop_annotation = #llvm.loop_annotation<mustProgress = true>
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.noundef, llvm.readonly}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<i32 (ptr, ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "256"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], res_attrs = [{llvm.range = #llvm.constant_range<i32, 0, 4>}], sym_name = "fd_r52x5_ge_decode2", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg139: !llvm.ptr, %arg140: !llvm.ptr, %arg141: !llvm.ptr, %arg142: !llvm.ptr):
  %703 = "llvm.mlir.constant"() <{value = 31 : i32}> : () -> i32
  %704 = "llvm.mlir.constant"() <{value = 30 : i32}> : () -> i32
  %705 = "llvm.mlir.constant"() <{value = 29 : i32}> : () -> i32
  %706 = "llvm.mlir.constant"() <{value = 28 : i32}> : () -> i32
  %707 = "llvm.mlir.constant"() <{value = 27 : i32}> : () -> i32
  %708 = "llvm.mlir.constant"() <{value = 26 : i32}> : () -> i32
  %709 = "llvm.mlir.constant"() <{value = 25 : i32}> : () -> i32
  %710 = "llvm.mlir.constant"() <{value = 24 : i32}> : () -> i32
  %711 = "llvm.mlir.constant"() <{value = 23 : i32}> : () -> i32
  %712 = "llvm.mlir.constant"() <{value = 22 : i32}> : () -> i32
  %713 = "llvm.mlir.constant"() <{value = 21 : i32}> : () -> i32
  %714 = "llvm.mlir.constant"() <{value = 19 : i32}> : () -> i32
  %715 = "llvm.mlir.constant"() <{value = 18 : i32}> : () -> i32
  %716 = "llvm.mlir.constant"() <{value = 17 : i32}> : () -> i32
  %717 = "llvm.mlir.constant"() <{value = 16 : i32}> : () -> i32
  %718 = "llvm.mlir.constant"() <{value = 15 : i32}> : () -> i32
  %719 = "llvm.mlir.constant"() <{value = 14 : i32}> : () -> i32
  %720 = "llvm.mlir.constant"() <{value = 13 : i32}> : () -> i32
  %721 = "llvm.mlir.constant"() <{value = 12 : i32}> : () -> i32
  %722 = "llvm.mlir.constant"() <{value = 11 : i32}> : () -> i32
  %723 = "llvm.mlir.constant"() <{value = 10 : i32}> : () -> i32
  %724 = "llvm.mlir.constant"() <{value = 9 : i32}> : () -> i32
  %725 = "llvm.mlir.constant"() <{value = 8 : i32}> : () -> i32
  %726 = "llvm.mlir.undef"() : () -> vector<32xi8>
  %727 = "llvm.mlir.constant"() <{value = 1 : i8}> : () -> i8
  %728 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %729 = "llvm.mlir.poison"() : () -> i8
  %730 = "llvm.mlir.constant"() <{value = dense<7> : vector<2xi8>}> : () -> vector<2xi8>
  %731 = "llvm.mlir.poison"() : () -> vector<2xi8>
  %732 = "llvm.mlir.constant"() <{value = dense<1> : vector<2xi32>}> : () -> vector<2xi32>
  %733 = "llvm.mlir.poison"() : () -> vector<2xi32>
  %734 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %735 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %736 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %737 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %738 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %739 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %740 = "llvm.mlir.undef"() : () -> vector<8xi32>
  %741 = "llvm.mlir.poison"() : () -> i32
  %742 = "llvm.mlir.constant"() <{value = dense<765476049583133> : vector<4xi64>}> : () -> vector<4xi64>
  %743 = "llvm.mlir.constant"() <{value = dense<2117202627021982> : vector<4xi64>}> : () -> vector<4xi64>
  %744 = "llvm.mlir.constant"() <{value = dense<2233514472574048> : vector<4xi64>}> : () -> vector<4xi64>
  %745 = "llvm.mlir.constant"() <{value = dense<234908883556509> : vector<4xi64>}> : () -> vector<4xi64>
  %746 = "llvm.mlir.constant"() <{value = dense<1718705420411056> : vector<4xi64>}> : () -> vector<4xi64>
  %747 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
  %748 = "llvm.mlir.constant"() <{value = 100 : i32}> : () -> i32
  %749 = "llvm.mlir.constant"() <{value = 50 : i32}> : () -> i32
  %750 = "llvm.mlir.constant"() <{value = 20 : i32}> : () -> i32
  %751 = "llvm.mlir.constant"() <{value = dense<1442794654840575> : vector<4xi64>}> : () -> vector<4xi64>
  %752 = "llvm.mlir.constant"() <{value = dense<2033849074728123> : vector<4xi64>}> : () -> vector<4xi64>
  %753 = "llvm.mlir.constant"() <{value = dense<1662059464998953> : vector<4xi64>}> : () -> vector<4xi64>
  %754 = "llvm.mlir.constant"() <{value = dense<466365720129213> : vector<4xi64>}> : () -> vector<4xi64>
  %755 = "llvm.mlir.constant"() <{value = dense<929955233495203> : vector<4xi64>}> : () -> vector<4xi64>
  %756 = "llvm.mlir.constant"() <{value = dense<0> : vector<4xi64>}> : () -> vector<4xi64>
  %757 = "llvm.mlir.constant"() <{value = dense<1> : vector<4xi64>}> : () -> vector<4xi64>
  %758 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %759 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %760 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %761 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %762 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %763 = "llvm.mlir.poison"() : () -> i64
  %764 = "llvm.mlir.undef"() : () -> vector<4xi64>
  %765 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %766 = "llvm.insertelement"(%764, %763, %765) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %767 = "llvm.insertelement"(%766, %763, %761) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %768 = "llvm.insertelement"(%767, %762, %760) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %769 = "llvm.insertelement"(%768, %762, %759) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %770 = "llvm.insertelement"(%740, %741, %765) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %771 = "llvm.insertelement"(%770, %741, %761) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %772 = "llvm.insertelement"(%771, %741, %760) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %773 = "llvm.insertelement"(%772, %741, %759) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %774 = "llvm.insertelement"(%773, %765, %739) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %775 = "llvm.insertelement"(%774, %765, %738) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %776 = "llvm.insertelement"(%775, %765, %737) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %777 = "llvm.insertelement"(%776, %765, %736) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %778 = "llvm.insertelement"(%726, %729, %765) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %779 = "llvm.insertelement"(%778, %729, %761) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %780 = "llvm.insertelement"(%779, %729, %760) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %781 = "llvm.insertelement"(%780, %729, %759) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %782 = "llvm.insertelement"(%781, %729, %739) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %783 = "llvm.insertelement"(%782, %729, %738) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %784 = "llvm.insertelement"(%783, %729, %737) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %785 = "llvm.insertelement"(%784, %729, %736) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %786 = "llvm.insertelement"(%785, %729, %725) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %787 = "llvm.insertelement"(%786, %729, %724) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %788 = "llvm.insertelement"(%787, %729, %723) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %789 = "llvm.insertelement"(%788, %729, %722) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %790 = "llvm.insertelement"(%789, %729, %721) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %791 = "llvm.insertelement"(%790, %729, %720) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %792 = "llvm.insertelement"(%791, %729, %719) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %793 = "llvm.insertelement"(%792, %729, %718) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %794 = "llvm.insertelement"(%793, %727, %717) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %795 = "llvm.insertelement"(%794, %728, %716) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %796 = "llvm.insertelement"(%795, %728, %715) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %797 = "llvm.insertelement"(%796, %728, %714) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %798 = "llvm.insertelement"(%797, %728, %750) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %799 = "llvm.insertelement"(%798, %728, %713) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %800 = "llvm.insertelement"(%799, %728, %712) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %801 = "llvm.insertelement"(%800, %728, %711) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %802 = "llvm.insertelement"(%801, %729, %710) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %803 = "llvm.insertelement"(%802, %729, %709) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %804 = "llvm.insertelement"(%803, %729, %708) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %805 = "llvm.insertelement"(%804, %729, %707) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %806 = "llvm.insertelement"(%805, %729, %706) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %807 = "llvm.insertelement"(%806, %729, %705) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %808 = "llvm.insertelement"(%807, %729, %704) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %809 = "llvm.insertelement"(%808, %729, %703) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %810 = "llvm.insertelement"(%726, %729, %765) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %811 = "llvm.insertelement"(%810, %729, %761) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %812 = "llvm.insertelement"(%811, %729, %760) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %813 = "llvm.insertelement"(%812, %729, %759) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %814 = "llvm.insertelement"(%813, %729, %739) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %815 = "llvm.insertelement"(%814, %729, %738) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %816 = "llvm.insertelement"(%815, %729, %737) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %817 = "llvm.insertelement"(%816, %729, %736) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %818 = "llvm.insertelement"(%817, %729, %725) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %819 = "llvm.insertelement"(%818, %729, %724) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %820 = "llvm.insertelement"(%819, %729, %723) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %821 = "llvm.insertelement"(%820, %729, %722) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %822 = "llvm.insertelement"(%821, %729, %721) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %823 = "llvm.insertelement"(%822, %729, %720) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %824 = "llvm.insertelement"(%823, %729, %719) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %825 = "llvm.insertelement"(%824, %729, %718) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %826 = "llvm.insertelement"(%825, %728, %717) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %827 = "llvm.insertelement"(%826, %728, %716) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %828 = "llvm.insertelement"(%827, %728, %715) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %829 = "llvm.insertelement"(%828, %728, %714) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %830 = "llvm.insertelement"(%829, %728, %750) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %831 = "llvm.insertelement"(%830, %728, %713) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %832 = "llvm.insertelement"(%831, %728, %712) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %833 = "llvm.insertelement"(%832, %728, %711) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %834 = "llvm.insertelement"(%833, %729, %710) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %835 = "llvm.insertelement"(%834, %729, %709) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %836 = "llvm.insertelement"(%835, %729, %708) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %837 = "llvm.insertelement"(%836, %729, %707) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %838 = "llvm.insertelement"(%837, %729, %706) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %839 = "llvm.insertelement"(%838, %729, %705) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %840 = "llvm.insertelement"(%839, %729, %704) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %841 = "llvm.insertelement"(%840, %729, %703) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %842 = "llvm.alloca"(%761) <{alignment = 16 : i64, elem_type = !llvm.array<5 x i64>}> : (i32) -> !llvm.ptr
  %843 = "llvm.alloca"(%761) <{alignment = 16 : i64, elem_type = !llvm.array<5 x i64>}> : (i32) -> !llvm.ptr
  %844 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %845 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %846 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %847 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %848 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %849 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %850 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %851 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %852 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %853 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %854 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %855 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %856 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %857 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %858 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %859 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %860 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %861 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %862 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %863 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %864 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %865 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %866 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %867 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %868 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %869 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %870 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %871 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %872 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %873 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %874 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %875 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %876 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %877 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %878 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %879 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %880 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %881 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %882 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %883 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %884 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %885 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %886 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %887 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %888 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %889 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %890 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %891 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %892 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %893 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %894 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %895 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %896 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %897 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %898 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %899 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %900 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %901 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %902 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %903 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %904 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %905 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %906 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %907 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %908 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %909 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %910 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %911 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %912 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %913 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %914 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %915 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %916 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %917 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %918 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %919 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %920 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %921 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %922 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %923 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %924 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %925 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %926 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %927 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %928 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %929 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %930 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %931 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %932 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %933 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %934 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %935 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %936 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %937 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %938 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %939 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %940 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %941 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %942 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %943 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %944 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %945 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %946 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %947 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %948 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %949 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %950 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %951 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %952 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %953 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %954 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %955 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %956 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %957 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %958 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %959 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %960 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %961 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %962 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %963 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %964 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %965 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %966 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %967 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %968 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %969 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %970 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %971 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %972 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %973 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %974 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %975 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %976 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %977 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %978 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %979 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %980 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %981 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %982 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %983 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %984 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %985 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %986 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %987 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %988 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %989 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %990 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %991 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %992 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %993 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %994 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %995 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %996 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %997 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %998 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %999 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1000 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1001 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1002 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1003 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1004 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1005 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1006 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1007 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1008 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1009 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1010 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1011 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1012 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1013 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1014 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1015 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1016 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1017 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1018 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1019 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1020 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1021 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1022 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1023 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1024 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1025 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1026 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1027 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1028 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1029 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1030 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1031 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1032 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1033 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1034 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1035 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1036 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1037 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1038 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1039 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1040 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1041 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1042 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1043 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1044 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1045 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1046 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1047 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1048 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1049 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1050 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1051 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1052 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1053 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1054 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1055 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1056 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1057 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1058 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1059 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1060 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1061 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1062 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1063 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1064 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1065 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1066 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1067 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1068 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1069 = "llvm.alloca"(%761) <{alignment = 16 : i64, elem_type = !llvm.array<5 x i64>}> : (i32) -> !llvm.ptr
  %1070 = "llvm.alloca"(%761) <{alignment = 16 : i64, elem_type = !llvm.array<5 x i64>}> : (i32) -> !llvm.ptr
  %1071 = "llvm.alloca"(%761) <{alignment = 16 : i64, elem_type = !llvm.array<5 x i64>}> : (i32) -> !llvm.ptr
  %1072 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1073 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1074 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1075 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1076 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1077 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1078 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1079 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1080 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1081 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1082 = "llvm.alloca"(%761) <{alignment = 16 : i64, elem_type = !llvm.array<5 x i64>}> : (i32) -> !llvm.ptr
  %1083 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1084 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1085 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1086 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1087 = "llvm.alloca"(%761) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%842) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%843) : (!llvm.ptr) -> ()
  "llvm.call"(%842, %arg140) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_limbs_frombytes, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%843, %arg142) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_limbs_frombytes, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %1088 = "llvm.load"(%842) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1089 = "llvm.load"(%843) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1090 = "llvm.insertelement"(%769, %1088, %762) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1091 = "llvm.insertelement"(%1090, %1089, %758) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1092 = "llvm.getelementptr"(%842) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %1093 = "llvm.load"(%1092) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1094 = "llvm.getelementptr"(%843) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %1095 = "llvm.load"(%1094) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1096 = "llvm.insertelement"(%769, %1093, %762) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1097 = "llvm.insertelement"(%1096, %1095, %758) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1098 = "llvm.getelementptr"(%842) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %1099 = "llvm.load"(%1098) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1100 = "llvm.getelementptr"(%843) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %1101 = "llvm.load"(%1100) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1102 = "llvm.insertelement"(%769, %1099, %762) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1103 = "llvm.insertelement"(%1102, %1101, %758) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1104 = "llvm.getelementptr"(%842) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %1105 = "llvm.load"(%1104) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1106 = "llvm.getelementptr"(%843) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %1107 = "llvm.load"(%1106) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1108 = "llvm.insertelement"(%769, %1105, %762) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1109 = "llvm.insertelement"(%1108, %1107, %758) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1110 = "llvm.getelementptr"(%842) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %1111 = "llvm.load"(%1110) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1112 = "llvm.getelementptr"(%843) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %1113 = "llvm.load"(%1112) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1114 = "llvm.insertelement"(%769, %1111, %762) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1115 = "llvm.insertelement"(%1114, %1113, %758) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%844) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%845) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%846) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%847) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%848) : (!llvm.ptr) -> ()
  "llvm.call"(%844, %845, %846, %847, %848, %1091, %1097, %1103, %1109, %1115) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1116 = "llvm.load"(%844) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1117 = "llvm.load"(%845) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1118 = "llvm.load"(%846) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1119 = "llvm.load"(%847) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1120 = "llvm.load"(%848) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%848) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%847) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%846) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%845) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%844) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%849) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%850) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%851) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%852) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%853) : (!llvm.ptr) -> ()
  "llvm.call"(%849, %850, %851, %852, %853, %1116, %1117, %1118, %1119, %1120, %757, %756, %756, %756, %756) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sub, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1121 = "llvm.load"(%849) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1122 = "llvm.load"(%850) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1123 = "llvm.load"(%851) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1124 = "llvm.load"(%852) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1125 = "llvm.load"(%853) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%853) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%852) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%851) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%850) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%849) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%854) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%855) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%856) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%857) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%858) : (!llvm.ptr) -> ()
  "llvm.call"(%854, %855, %856, %857, %858, %1116, %1117, %1118, %1119, %1120, %755, %754, %753, %752, %751) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1126 = "llvm.load"(%854) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1127 = "llvm.load"(%855) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1128 = "llvm.load"(%856) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1129 = "llvm.load"(%857) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1130 = "llvm.load"(%858) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%858) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%857) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%856) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%855) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%854) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%859) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%860) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%861) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%862) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%863) : (!llvm.ptr) -> ()
  "llvm.call"(%859, %860, %861, %862, %863, %1126, %1127, %1128, %1129, %1130, %757, %756, %756, %756, %756) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_add, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1131 = "llvm.load"(%859) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1132 = "llvm.load"(%860) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1133 = "llvm.load"(%861) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1134 = "llvm.load"(%862) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1135 = "llvm.load"(%863) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%863) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%862) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%861) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%860) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%859) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%864) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%865) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%866) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%867) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%868) : (!llvm.ptr) -> ()
  "llvm.call"(%864, %865, %866, %867, %868, %1131, %1132, %1133, %1134, %1135) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1136 = "llvm.load"(%864) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1137 = "llvm.load"(%865) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1138 = "llvm.load"(%866) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1139 = "llvm.load"(%867) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1140 = "llvm.load"(%868) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%868) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%867) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%866) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%865) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%864) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%869) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%870) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%871) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%872) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%873) : (!llvm.ptr) -> ()
  "llvm.call"(%869, %870, %871, %872, %873, %1136, %1137, %1138, %1139, %1140, %1131, %1132, %1133, %1134, %1135) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1141 = "llvm.load"(%869) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1142 = "llvm.load"(%870) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1143 = "llvm.load"(%871) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1144 = "llvm.load"(%872) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1145 = "llvm.load"(%873) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%873) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%872) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%871) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%870) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%869) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%874) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%875) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%876) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%877) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%878) : (!llvm.ptr) -> ()
  "llvm.call"(%874, %875, %876, %877, %878, %1141, %1142, %1143, %1144, %1145) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1146 = "llvm.load"(%874) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1147 = "llvm.load"(%875) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1148 = "llvm.load"(%876) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1149 = "llvm.load"(%877) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1150 = "llvm.load"(%878) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%878) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%877) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%876) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%875) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%874) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%879) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%880) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%881) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%882) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%883) : (!llvm.ptr) -> ()
  "llvm.call"(%879, %880, %881, %882, %883, %1146, %1147, %1148, %1149, %1150, %1131, %1132, %1133, %1134, %1135) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1151 = "llvm.load"(%879) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1152 = "llvm.load"(%880) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1153 = "llvm.load"(%881) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1154 = "llvm.load"(%882) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1155 = "llvm.load"(%883) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%883) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%882) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%881) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%880) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%879) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%884) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%885) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%886) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%887) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%888) : (!llvm.ptr) -> ()
  "llvm.call"(%884, %885, %886, %887, %888, %1121, %1122, %1123, %1124, %1125, %1151, %1152, %1153, %1154, %1155) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1156 = "llvm.load"(%884) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1157 = "llvm.load"(%885) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1158 = "llvm.load"(%886) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1159 = "llvm.load"(%887) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1160 = "llvm.load"(%888) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%888) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%887) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%886) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%885) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%884) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%889) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%890) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%891) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%892) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%893) : (!llvm.ptr) -> ()
  "llvm.call"(%889, %890, %891, %892, %893, %1156, %1157, %1158, %1159, %1160) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1161 = "llvm.load"(%889) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1162 = "llvm.load"(%890) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1163 = "llvm.load"(%891) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1164 = "llvm.load"(%892) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1165 = "llvm.load"(%893) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%893) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%892) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%891) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%890) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%889) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%894) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%895) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%896) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%897) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%898) : (!llvm.ptr) -> ()
  "llvm.call"(%894, %895, %896, %897, %898, %1161, %1162, %1163, %1164, %1165) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1166 = "llvm.load"(%894) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1167 = "llvm.load"(%895) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1168 = "llvm.load"(%896) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1169 = "llvm.load"(%897) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1170 = "llvm.load"(%898) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%898) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%897) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%896) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%895) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%894) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%899) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%900) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%901) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%902) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%903) : (!llvm.ptr) -> ()
  "llvm.call"(%899, %900, %901, %902, %903, %1166, %1167, %1168, %1169, %1170) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1171 = "llvm.load"(%899) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1172 = "llvm.load"(%900) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1173 = "llvm.load"(%901) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1174 = "llvm.load"(%902) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1175 = "llvm.load"(%903) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%903) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%902) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%901) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%900) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%899) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%904) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%905) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%906) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%907) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%908) : (!llvm.ptr) -> ()
  "llvm.call"(%904, %905, %906, %907, %908, %1156, %1157, %1158, %1159, %1160, %1171, %1172, %1173, %1174, %1175) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1176 = "llvm.load"(%904) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1177 = "llvm.load"(%905) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1178 = "llvm.load"(%906) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1179 = "llvm.load"(%907) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1180 = "llvm.load"(%908) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%908) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%907) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%906) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%905) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%904) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%909) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%910) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%911) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%912) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%913) : (!llvm.ptr) -> ()
  "llvm.call"(%909, %910, %911, %912, %913, %1161, %1162, %1163, %1164, %1165, %1176, %1177, %1178, %1179, %1180) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1181 = "llvm.load"(%909) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1182 = "llvm.load"(%910) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1183 = "llvm.load"(%911) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1184 = "llvm.load"(%912) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1185 = "llvm.load"(%913) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%913) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%912) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%911) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%910) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%909) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%914) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%915) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%916) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%917) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%918) : (!llvm.ptr) -> ()
  "llvm.call"(%914, %915, %916, %917, %918, %1181, %1182, %1183, %1184, %1185) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1186 = "llvm.load"(%914) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1187 = "llvm.load"(%915) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1188 = "llvm.load"(%916) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1189 = "llvm.load"(%917) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1190 = "llvm.load"(%918) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%918) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%917) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%916) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%915) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%914) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%919) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%920) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%921) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%922) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%923) : (!llvm.ptr) -> ()
  "llvm.call"(%919, %920, %921, %922, %923, %1176, %1177, %1178, %1179, %1180, %1186, %1187, %1188, %1189, %1190) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1191 = "llvm.load"(%919) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1192 = "llvm.load"(%920) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1193 = "llvm.load"(%921) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1194 = "llvm.load"(%922) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1195 = "llvm.load"(%923) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%923) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%922) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%921) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%920) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%919) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%924) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%925) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%926) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%927) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%928) : (!llvm.ptr) -> ()
  "llvm.call"(%924, %925, %926, %927, %928, %1191, %1192, %1193, %1194, %1195) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1196 = "llvm.load"(%924) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1197 = "llvm.load"(%925) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1198 = "llvm.load"(%926) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1199 = "llvm.load"(%927) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1200 = "llvm.load"(%928) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%928) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%927) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%926) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%925) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%924) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%929) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%930) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%931) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%932) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%933) : (!llvm.ptr) -> ()
  "llvm.call"(%929, %930, %931, %932, %933, %1196, %1197, %1198, %1199, %1200) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1201 = "llvm.load"(%929) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1202 = "llvm.load"(%930) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1203 = "llvm.load"(%931) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1204 = "llvm.load"(%932) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1205 = "llvm.load"(%933) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%933) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%932) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%931) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%930) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%929) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%929) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%930) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%931) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%932) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%933) : (!llvm.ptr) -> ()
  "llvm.call"(%929, %930, %931, %932, %933, %1201, %1202, %1203, %1204, %1205) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1206 = "llvm.load"(%929) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1207 = "llvm.load"(%930) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1208 = "llvm.load"(%931) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1209 = "llvm.load"(%932) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1210 = "llvm.load"(%933) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%933) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%932) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%931) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%930) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%929) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%929) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%930) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%931) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%932) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%933) : (!llvm.ptr) -> ()
  "llvm.call"(%929, %930, %931, %932, %933, %1206, %1207, %1208, %1209, %1210) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1211 = "llvm.load"(%929) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1212 = "llvm.load"(%930) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1213 = "llvm.load"(%931) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1214 = "llvm.load"(%932) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1215 = "llvm.load"(%933) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%933) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%932) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%931) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%930) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%929) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%929) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%930) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%931) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%932) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%933) : (!llvm.ptr) -> ()
  "llvm.call"(%929, %930, %931, %932, %933, %1211, %1212, %1213, %1214, %1215) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1216 = "llvm.load"(%929) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1217 = "llvm.load"(%930) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1218 = "llvm.load"(%931) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1219 = "llvm.load"(%932) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1220 = "llvm.load"(%933) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%933) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%932) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%931) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%930) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%929) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%934) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%935) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%936) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%937) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%938) : (!llvm.ptr) -> ()
  "llvm.call"(%934, %935, %936, %937, %938, %1216, %1217, %1218, %1219, %1220, %1191, %1192, %1193, %1194, %1195) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1221 = "llvm.load"(%934) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1222 = "llvm.load"(%935) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1223 = "llvm.load"(%936) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1224 = "llvm.load"(%937) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1225 = "llvm.load"(%938) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%938) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%937) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%936) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%935) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%934) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%939) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%940) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%941) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%942) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%943) : (!llvm.ptr) -> ()
  "llvm.call"(%939, %940, %941, %942, %943, %1221, %1222, %1223, %1224, %1225) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1226 = "llvm.load"(%939) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1227 = "llvm.load"(%940) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1228 = "llvm.load"(%941) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1229 = "llvm.load"(%942) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1230 = "llvm.load"(%943) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%943) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%942) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%941) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%940) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%939) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%944) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%945) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%946) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%947) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%948) : (!llvm.ptr) -> ()
  "llvm.call"(%944, %945, %946, %947, %948, %1226, %1227, %1228, %1229, %1230) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1231 = "llvm.load"(%944) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1232 = "llvm.load"(%945) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1233 = "llvm.load"(%946) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1234 = "llvm.load"(%947) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1235 = "llvm.load"(%948) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%948) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%947) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%946) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%945) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%944) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%944) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%945) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%946) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%947) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%948) : (!llvm.ptr) -> ()
  "llvm.call"(%944, %945, %946, %947, %948, %1231, %1232, %1233, %1234, %1235) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1236 = "llvm.load"(%944) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1237 = "llvm.load"(%945) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1238 = "llvm.load"(%946) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1239 = "llvm.load"(%947) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1240 = "llvm.load"(%948) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%948) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%947) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%946) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%945) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%944) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%944) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%945) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%946) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%947) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%948) : (!llvm.ptr) -> ()
  "llvm.call"(%944, %945, %946, %947, %948, %1236, %1237, %1238, %1239, %1240) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1241 = "llvm.load"(%944) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1242 = "llvm.load"(%945) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1243 = "llvm.load"(%946) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1244 = "llvm.load"(%947) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1245 = "llvm.load"(%948) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%948) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%947) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%946) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%945) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%944) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%944) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%945) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%946) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%947) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%948) : (!llvm.ptr) -> ()
  "llvm.call"(%944, %945, %946, %947, %948, %1241, %1242, %1243, %1244, %1245) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1246 = "llvm.load"(%944) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1247 = "llvm.load"(%945) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1248 = "llvm.load"(%946) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1249 = "llvm.load"(%947) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1250 = "llvm.load"(%948) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%948) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%947) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%946) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%945) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%944) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%944) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%945) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%946) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%947) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%948) : (!llvm.ptr) -> ()
  "llvm.call"(%944, %945, %946, %947, %948, %1246, %1247, %1248, %1249, %1250) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1251 = "llvm.load"(%944) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1252 = "llvm.load"(%945) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1253 = "llvm.load"(%946) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1254 = "llvm.load"(%947) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1255 = "llvm.load"(%948) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%948) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%947) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%946) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%945) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%944) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%944) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%945) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%946) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%947) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%948) : (!llvm.ptr) -> ()
  "llvm.call"(%944, %945, %946, %947, %948, %1251, %1252, %1253, %1254, %1255) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1256 = "llvm.load"(%944) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1257 = "llvm.load"(%945) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1258 = "llvm.load"(%946) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1259 = "llvm.load"(%947) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1260 = "llvm.load"(%948) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%948) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%947) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%946) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%945) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%944) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%944) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%945) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%946) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%947) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%948) : (!llvm.ptr) -> ()
  "llvm.call"(%944, %945, %946, %947, %948, %1256, %1257, %1258, %1259, %1260) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1261 = "llvm.load"(%944) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1262 = "llvm.load"(%945) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1263 = "llvm.load"(%946) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1264 = "llvm.load"(%947) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1265 = "llvm.load"(%948) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%948) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%947) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%946) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%945) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%944) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%944) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%945) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%946) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%947) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%948) : (!llvm.ptr) -> ()
  "llvm.call"(%944, %945, %946, %947, %948, %1261, %1262, %1263, %1264, %1265) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1266 = "llvm.load"(%944) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1267 = "llvm.load"(%945) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1268 = "llvm.load"(%946) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1269 = "llvm.load"(%947) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1270 = "llvm.load"(%948) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%948) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%947) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%946) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%945) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%944) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%944) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%945) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%946) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%947) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%948) : (!llvm.ptr) -> ()
  "llvm.call"(%944, %945, %946, %947, %948, %1266, %1267, %1268, %1269, %1270) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1271 = "llvm.load"(%944) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1272 = "llvm.load"(%945) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1273 = "llvm.load"(%946) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1274 = "llvm.load"(%947) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1275 = "llvm.load"(%948) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%948) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%947) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%946) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%945) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%944) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%949) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%950) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%951) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%952) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%953) : (!llvm.ptr) -> ()
  "llvm.call"(%949, %950, %951, %952, %953, %1271, %1272, %1273, %1274, %1275, %1221, %1222, %1223, %1224, %1225) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1276 = "llvm.load"(%949) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1277 = "llvm.load"(%950) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1278 = "llvm.load"(%951) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1279 = "llvm.load"(%952) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1280 = "llvm.load"(%953) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%953) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%952) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%951) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%950) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%949) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%954) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%955) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%956) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%957) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%958) : (!llvm.ptr) -> ()
  "llvm.call"(%954, %955, %956, %957, %958, %1276, %1277, %1278, %1279, %1280) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1281 = "llvm.load"(%954) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1282 = "llvm.load"(%955) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1283 = "llvm.load"(%956) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1284 = "llvm.load"(%957) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1285 = "llvm.load"(%958) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%958) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%957) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%956) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%955) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%954) : (!llvm.ptr) -> ()
  "llvm.br"(%1281, %1282, %1283, %1284, %1285, %761)[^bb2] : (vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, i32) -> ()
^bb1:  // pred: ^bb2
  "llvm.intr.lifetime.start"(%964) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%965) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%966) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%967) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%968) : (!llvm.ptr) -> ()
  "llvm.call"(%964, %965, %966, %967, %968, %1357, %1358, %1359, %1360, %1361, %1276, %1277, %1278, %1279, %1280) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1286 = "llvm.load"(%964) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1287 = "llvm.load"(%965) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1288 = "llvm.load"(%966) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1289 = "llvm.load"(%967) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1290 = "llvm.load"(%968) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%968) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%967) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%966) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%965) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%964) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%969) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%970) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%971) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%972) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%973) : (!llvm.ptr) -> ()
  "llvm.call"(%969, %970, %971, %972, %973, %1286, %1287, %1288, %1289, %1290) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1291 = "llvm.load"(%969) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1292 = "llvm.load"(%970) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1293 = "llvm.load"(%971) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1294 = "llvm.load"(%972) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1295 = "llvm.load"(%973) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%973) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%972) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%971) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%970) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%969) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%974) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%975) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%976) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%977) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%978) : (!llvm.ptr) -> ()
  "llvm.call"(%974, %975, %976, %977, %978, %1291, %1292, %1293, %1294, %1295) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1296 = "llvm.load"(%974) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1297 = "llvm.load"(%975) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1298 = "llvm.load"(%976) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1299 = "llvm.load"(%977) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1300 = "llvm.load"(%978) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%978) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%977) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%976) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%975) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%974) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%974) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%975) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%976) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%977) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%978) : (!llvm.ptr) -> ()
  "llvm.call"(%974, %975, %976, %977, %978, %1296, %1297, %1298, %1299, %1300) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1301 = "llvm.load"(%974) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1302 = "llvm.load"(%975) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1303 = "llvm.load"(%976) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1304 = "llvm.load"(%977) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1305 = "llvm.load"(%978) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%978) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%977) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%976) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%975) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%974) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%974) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%975) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%976) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%977) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%978) : (!llvm.ptr) -> ()
  "llvm.call"(%974, %975, %976, %977, %978, %1301, %1302, %1303, %1304, %1305) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1306 = "llvm.load"(%974) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1307 = "llvm.load"(%975) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1308 = "llvm.load"(%976) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1309 = "llvm.load"(%977) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1310 = "llvm.load"(%978) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%978) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%977) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%976) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%975) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%974) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%974) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%975) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%976) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%977) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%978) : (!llvm.ptr) -> ()
  "llvm.call"(%974, %975, %976, %977, %978, %1306, %1307, %1308, %1309, %1310) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1311 = "llvm.load"(%974) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1312 = "llvm.load"(%975) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1313 = "llvm.load"(%976) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1314 = "llvm.load"(%977) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1315 = "llvm.load"(%978) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%978) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%977) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%976) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%975) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%974) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%974) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%975) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%976) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%977) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%978) : (!llvm.ptr) -> ()
  "llvm.call"(%974, %975, %976, %977, %978, %1311, %1312, %1313, %1314, %1315) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1316 = "llvm.load"(%974) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1317 = "llvm.load"(%975) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1318 = "llvm.load"(%976) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1319 = "llvm.load"(%977) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1320 = "llvm.load"(%978) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%978) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%977) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%976) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%975) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%974) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%974) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%975) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%976) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%977) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%978) : (!llvm.ptr) -> ()
  "llvm.call"(%974, %975, %976, %977, %978, %1316, %1317, %1318, %1319, %1320) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1321 = "llvm.load"(%974) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1322 = "llvm.load"(%975) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1323 = "llvm.load"(%976) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1324 = "llvm.load"(%977) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1325 = "llvm.load"(%978) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%978) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%977) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%976) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%975) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%974) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%974) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%975) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%976) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%977) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%978) : (!llvm.ptr) -> ()
  "llvm.call"(%974, %975, %976, %977, %978, %1321, %1322, %1323, %1324, %1325) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1326 = "llvm.load"(%974) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1327 = "llvm.load"(%975) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1328 = "llvm.load"(%976) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1329 = "llvm.load"(%977) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1330 = "llvm.load"(%978) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%978) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%977) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%976) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%975) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%974) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%974) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%975) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%976) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%977) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%978) : (!llvm.ptr) -> ()
  "llvm.call"(%974, %975, %976, %977, %978, %1326, %1327, %1328, %1329, %1330) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1331 = "llvm.load"(%974) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1332 = "llvm.load"(%975) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1333 = "llvm.load"(%976) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1334 = "llvm.load"(%977) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1335 = "llvm.load"(%978) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%978) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%977) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%976) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%975) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%974) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%974) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%975) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%976) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%977) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%978) : (!llvm.ptr) -> ()
  "llvm.call"(%974, %975, %976, %977, %978, %1331, %1332, %1333, %1334, %1335) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1336 = "llvm.load"(%974) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1337 = "llvm.load"(%975) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1338 = "llvm.load"(%976) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1339 = "llvm.load"(%977) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1340 = "llvm.load"(%978) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%978) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%977) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%976) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%975) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%974) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%979) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%980) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%981) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%982) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%983) : (!llvm.ptr) -> ()
  "llvm.call"(%979, %980, %981, %982, %983, %1336, %1337, %1338, %1339, %1340, %1221, %1222, %1223, %1224, %1225) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1341 = "llvm.load"(%979) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1342 = "llvm.load"(%980) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1343 = "llvm.load"(%981) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1344 = "llvm.load"(%982) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1345 = "llvm.load"(%983) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%983) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%982) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%981) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%980) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%979) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%984) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%985) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%986) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%987) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%988) : (!llvm.ptr) -> ()
  "llvm.call"(%984, %985, %986, %987, %988, %1341, %1342, %1343, %1344, %1345) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1346 = "llvm.load"(%984) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1347 = "llvm.load"(%985) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1348 = "llvm.load"(%986) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1349 = "llvm.load"(%987) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1350 = "llvm.load"(%988) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%988) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%987) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%986) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%985) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%984) : (!llvm.ptr) -> ()
  "llvm.br"(%1346, %1347, %1348, %1349, %1350, %761)[^bb4] : (vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, i32) -> ()
^bb2(%1351: vector<4xi64>, %1352: vector<4xi64>, %1353: vector<4xi64>, %1354: vector<4xi64>, %1355: vector<4xi64>, %1356: i32):  // 2 preds: ^bb0, ^bb2
  "llvm.intr.lifetime.start"(%959) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%960) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%961) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%962) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%963) : (!llvm.ptr) -> ()
  "llvm.call"(%959, %960, %961, %962, %963, %1351, %1352, %1353, %1354, %1355) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1357 = "llvm.load"(%959) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1358 = "llvm.load"(%960) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1359 = "llvm.load"(%961) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1360 = "llvm.load"(%962) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1361 = "llvm.load"(%963) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%963) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%962) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%961) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%960) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%959) : (!llvm.ptr) -> ()
  %1362 = "llvm.add"(%1356, %761) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %1363 = "llvm.icmp"(%1362, %750) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%1363, %1357, %1358, %1359, %1360, %1361, %1362)[^bb1, ^bb2] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 6>}> : (i1, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, i32) -> ()
^bb3:  // pred: ^bb4
  "llvm.intr.lifetime.start"(%994) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%995) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%996) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%997) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%998) : (!llvm.ptr) -> ()
  "llvm.call"(%994, %995, %996, %997, %998, %1380, %1381, %1382, %1383, %1384, %1341, %1342, %1343, %1344, %1345) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1364 = "llvm.load"(%994) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1365 = "llvm.load"(%995) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1366 = "llvm.load"(%996) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1367 = "llvm.load"(%997) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1368 = "llvm.load"(%998) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%998) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%997) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%996) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%995) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%994) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%999) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1000) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1001) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1002) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1003) : (!llvm.ptr) -> ()
  "llvm.call"(%999, %1000, %1001, %1002, %1003, %1364, %1365, %1366, %1367, %1368) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1369 = "llvm.load"(%999) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1370 = "llvm.load"(%1000) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1371 = "llvm.load"(%1001) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1372 = "llvm.load"(%1002) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1373 = "llvm.load"(%1003) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1003) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1002) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1001) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1000) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%999) : (!llvm.ptr) -> ()
  "llvm.br"(%1369, %1370, %1371, %1372, %1373, %761)[^bb6] : (vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, i32) -> ()
^bb4(%1374: vector<4xi64>, %1375: vector<4xi64>, %1376: vector<4xi64>, %1377: vector<4xi64>, %1378: vector<4xi64>, %1379: i32):  // 2 preds: ^bb1, ^bb4
  "llvm.intr.lifetime.start"(%989) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%990) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%991) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%992) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%993) : (!llvm.ptr) -> ()
  "llvm.call"(%989, %990, %991, %992, %993, %1374, %1375, %1376, %1377, %1378) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1380 = "llvm.load"(%989) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1381 = "llvm.load"(%990) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1382 = "llvm.load"(%991) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1383 = "llvm.load"(%992) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1384 = "llvm.load"(%993) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%993) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%992) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%991) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%990) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%989) : (!llvm.ptr) -> ()
  %1385 = "llvm.add"(%1379, %761) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %1386 = "llvm.icmp"(%1385, %749) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%1386, %1380, %1381, %1382, %1383, %1384, %1385)[^bb3, ^bb4] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 6>}> : (i1, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, i32) -> ()
^bb5:  // pred: ^bb6
  "llvm.intr.lifetime.start"(%1009) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1010) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1011) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1012) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1013) : (!llvm.ptr) -> ()
  "llvm.call"(%1009, %1010, %1011, %1012, %1013, %1403, %1404, %1405, %1406, %1407, %1364, %1365, %1366, %1367, %1368) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1387 = "llvm.load"(%1009) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1388 = "llvm.load"(%1010) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1389 = "llvm.load"(%1011) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1390 = "llvm.load"(%1012) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1391 = "llvm.load"(%1013) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1013) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1012) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1011) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1010) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1009) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1014) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1015) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1016) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1017) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1018) : (!llvm.ptr) -> ()
  "llvm.call"(%1014, %1015, %1016, %1017, %1018, %1387, %1388, %1389, %1390, %1391) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1392 = "llvm.load"(%1014) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1393 = "llvm.load"(%1015) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1394 = "llvm.load"(%1016) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1395 = "llvm.load"(%1017) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1396 = "llvm.load"(%1018) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1018) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1017) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1016) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1015) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1014) : (!llvm.ptr) -> ()
  "llvm.br"(%1392, %1393, %1394, %1395, %1396, %761)[^bb8] : (vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, i32) -> ()
^bb6(%1397: vector<4xi64>, %1398: vector<4xi64>, %1399: vector<4xi64>, %1400: vector<4xi64>, %1401: vector<4xi64>, %1402: i32):  // 2 preds: ^bb3, ^bb6
  "llvm.intr.lifetime.start"(%1004) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1005) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1006) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1007) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1008) : (!llvm.ptr) -> ()
  "llvm.call"(%1004, %1005, %1006, %1007, %1008, %1397, %1398, %1399, %1400, %1401) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1403 = "llvm.load"(%1004) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1404 = "llvm.load"(%1005) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1405 = "llvm.load"(%1006) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1406 = "llvm.load"(%1007) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1407 = "llvm.load"(%1008) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1008) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1007) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1006) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1005) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1004) : (!llvm.ptr) -> ()
  %1408 = "llvm.add"(%1402, %761) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %1409 = "llvm.icmp"(%1408, %748) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%1409, %1403, %1404, %1405, %1406, %1407, %1408)[^bb5, ^bb6] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 6>}> : (i1, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, i32) -> ()
^bb7:  // pred: ^bb8
  "llvm.intr.lifetime.start"(%1024) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1025) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1026) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1027) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1028) : (!llvm.ptr) -> ()
  "llvm.call"(%1024, %1025, %1026, %1027, %1028, %1463, %1464, %1465, %1466, %1467, %1341, %1342, %1343, %1344, %1345) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1410 = "llvm.load"(%1024) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1411 = "llvm.load"(%1025) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1412 = "llvm.load"(%1026) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1413 = "llvm.load"(%1027) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1414 = "llvm.load"(%1028) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1028) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1027) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1026) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1025) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1024) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1029) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1030) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1031) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1032) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1033) : (!llvm.ptr) -> ()
  "llvm.call"(%1029, %1030, %1031, %1032, %1033, %1410, %1411, %1412, %1413, %1414) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1415 = "llvm.load"(%1029) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1416 = "llvm.load"(%1030) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1417 = "llvm.load"(%1031) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1418 = "llvm.load"(%1032) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1419 = "llvm.load"(%1033) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1033) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1032) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1031) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1030) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1029) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1034) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1035) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1036) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1037) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1038) : (!llvm.ptr) -> ()
  "llvm.call"(%1034, %1035, %1036, %1037, %1038, %1415, %1416, %1417, %1418, %1419) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1420 = "llvm.load"(%1034) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1421 = "llvm.load"(%1035) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1422 = "llvm.load"(%1036) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1423 = "llvm.load"(%1037) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1424 = "llvm.load"(%1038) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1038) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1037) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1036) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1035) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1034) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1039) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1040) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1041) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1042) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1043) : (!llvm.ptr) -> ()
  "llvm.call"(%1039, %1040, %1041, %1042, %1043, %1420, %1421, %1422, %1423, %1424, %1156, %1157, %1158, %1159, %1160) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1425 = "llvm.load"(%1039) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1426 = "llvm.load"(%1040) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1427 = "llvm.load"(%1041) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1428 = "llvm.load"(%1042) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1429 = "llvm.load"(%1043) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1043) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1042) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1041) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1040) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1039) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1044) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1045) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1046) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1047) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1048) : (!llvm.ptr) -> ()
  "llvm.call"(%1044, %1045, %1046, %1047, %1048, %1121, %1122, %1123, %1124, %1125, %1141, %1142, %1143, %1144, %1145) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1430 = "llvm.load"(%1044) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1431 = "llvm.load"(%1045) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1432 = "llvm.load"(%1046) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1433 = "llvm.load"(%1047) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1434 = "llvm.load"(%1048) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1048) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1047) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1046) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1045) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1044) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1049) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1050) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1051) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1052) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1053) : (!llvm.ptr) -> ()
  "llvm.call"(%1049, %1050, %1051, %1052, %1053, %1430, %1431, %1432, %1433, %1434, %1425, %1426, %1427, %1428, %1429) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1435 = "llvm.load"(%1049) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1436 = "llvm.load"(%1050) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1437 = "llvm.load"(%1051) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1438 = "llvm.load"(%1052) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1439 = "llvm.load"(%1053) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1053) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1052) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1051) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1050) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1049) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1054) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1055) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1056) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1057) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1058) : (!llvm.ptr) -> ()
  "llvm.call"(%1054, %1055, %1056, %1057, %1058, %1435, %1436, %1437, %1438, %1439) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1440 = "llvm.load"(%1054) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1441 = "llvm.load"(%1055) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1442 = "llvm.load"(%1056) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1443 = "llvm.load"(%1057) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1444 = "llvm.load"(%1058) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1058) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1057) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1056) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1055) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1054) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1059) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1060) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1061) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1062) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1063) : (!llvm.ptr) -> ()
  "llvm.call"(%1059, %1060, %1061, %1062, %1063, %1131, %1132, %1133, %1134, %1135, %1440, %1441, %1442, %1443, %1444) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1445 = "llvm.load"(%1059) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1446 = "llvm.load"(%1060) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1447 = "llvm.load"(%1061) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1448 = "llvm.load"(%1062) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1449 = "llvm.load"(%1063) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1063) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1062) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1061) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1060) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1059) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1064) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1065) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1066) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1067) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1068) : (!llvm.ptr) -> ()
  "llvm.call"(%1064, %1065, %1066, %1067, %1068, %1121, %1122, %1123, %1124, %1125) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_neg, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1450 = "llvm.load"(%1064) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1451 = "llvm.load"(%1065) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1452 = "llvm.load"(%1066) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1453 = "llvm.load"(%1067) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1454 = "llvm.load"(%1068) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1068) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1067) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1066) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1065) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1064) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1069) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1070) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1071) : (!llvm.ptr) -> ()
  "llvm.call"(%1069, %1445, %1446, %1447, %1448, %1449, %765) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_lane_canon, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 7, 0>}> : (!llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, i32) -> ()
  "llvm.call"(%1070, %1121, %1122, %1123, %1124, %1125, %765) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_lane_canon, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 7, 0>}> : (!llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, i32) -> ()
  "llvm.call"(%1071, %1450, %1451, %1452, %1453, %1454, %765) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_lane_canon, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 7, 0>}> : (!llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, i32) -> ()
  %1455 = "llvm.call"(%1069, %1070) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_r52x5_limbs_eq, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> i32
  %1456 = "llvm.icmp"(%1455, %765) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%1456, %765, %761)[^bb9, ^bb10] <{operandSegmentSizes = array<i32: 1, 0, 2>}> : (i1, i32, i32) -> ()
^bb8(%1457: vector<4xi64>, %1458: vector<4xi64>, %1459: vector<4xi64>, %1460: vector<4xi64>, %1461: vector<4xi64>, %1462: i32):  // 2 preds: ^bb5, ^bb8
  "llvm.intr.lifetime.start"(%1019) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1020) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1021) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1022) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1023) : (!llvm.ptr) -> ()
  "llvm.call"(%1019, %1020, %1021, %1022, %1023, %1457, %1458, %1459, %1460, %1461) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1463 = "llvm.load"(%1019) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1464 = "llvm.load"(%1020) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1465 = "llvm.load"(%1021) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1466 = "llvm.load"(%1022) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1467 = "llvm.load"(%1023) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1023) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1022) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1021) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1020) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1019) : (!llvm.ptr) -> ()
  %1468 = "llvm.add"(%1462, %761) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %1469 = "llvm.icmp"(%1468, %749) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%1469, %1463, %1464, %1465, %1466, %1467, %1468)[^bb7, ^bb8] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 6>}> : (i1, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, i32) -> ()
^bb9:  // pred: ^bb7
  %1470 = "llvm.call"(%1069, %1071) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_r52x5_limbs_eq, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> i32
  %1471 = "llvm.sub"(%765, %1470) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  "llvm.br"(%1471, %1470)[^bb10] : (i32, i32) -> ()
^bb10(%1472: i32, %1473: i32):  // 2 preds: ^bb7, ^bb9
  "llvm.intr.lifetime.end"(%1071) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1070) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1069) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1069) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1070) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1071) : (!llvm.ptr) -> ()
  "llvm.call"(%1069, %1445, %1446, %1447, %1448, %1449, %761) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_lane_canon, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 7, 0>}> : (!llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, i32) -> ()
  "llvm.call"(%1070, %1121, %1122, %1123, %1124, %1125, %761) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_lane_canon, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 7, 0>}> : (!llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, i32) -> ()
  "llvm.call"(%1071, %1450, %1451, %1452, %1453, %1454, %761) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_lane_canon, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 7, 0>}> : (!llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, i32) -> ()
  %1474 = "llvm.call"(%1069, %1070) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_r52x5_limbs_eq, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> i32
  %1475 = "llvm.icmp"(%1474, %765) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%1475, %765)[^bb11, ^bb13] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb11:  // pred: ^bb10
  %1476 = "llvm.call"(%1069, %1071) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_r52x5_limbs_eq, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> i32
  %1477 = "llvm.icmp"(%1476, %765) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%1477, %747)[^bb12, ^bb13] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb12:  // pred: ^bb11
  "llvm.intr.lifetime.end"(%1071) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1070) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1069) : (!llvm.ptr) -> ()
  "llvm.br"(%1473)[^bb15] : (i32) -> ()
^bb13(%1478: i32):  // 2 preds: ^bb10, ^bb11
  "llvm.intr.lifetime.end"(%1071) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1070) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1069) : (!llvm.ptr) -> ()
  %1479 = "llvm.icmp"(%1473, %765) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%1479, %760)[^bb15, ^bb14] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i32) -> ()
^bb14:  // pred: ^bb13
  "llvm.intr.lifetime.start"(%1072) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1073) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1074) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1075) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1076) : (!llvm.ptr) -> ()
  "llvm.call"(%1072, %1073, %1074, %1075, %1076, %1435, %1436, %1437, %1438, %1439, %746, %745, %744, %743, %742) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1480 = "llvm.load"(%1072) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<32xi8>
  %1481 = "llvm.load"(%1073) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<32xi8>
  %1482 = "llvm.load"(%1074) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<32xi8>
  %1483 = "llvm.load"(%1075) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<32xi8>
  %1484 = "llvm.load"(%1076) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<32xi8>
  "llvm.intr.lifetime.end"(%1076) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1075) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1074) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1073) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1072) : (!llvm.ptr) -> ()
  %1485 = "llvm.insertelement"(%777, %1472, %762) : (vector<8xi32>, i32, i64) -> vector<8xi32>
  %1486 = "llvm.insertelement"(%1485, %1472, %758) : (vector<8xi32>, i32, i64) -> vector<8xi32>
  %1487 = "llvm.insertelement"(%1486, %1478, %735) : (vector<8xi32>, i32, i64) -> vector<8xi32>
  %1488 = "llvm.insertelement"(%1487, %1478, %734) : (vector<8xi32>, i32, i64) -> vector<8xi32>
  %1489 = "llvm.bitcast"(%1435) : (vector<4xi64>) -> vector<32xi8>
  %1490 = "llvm.bitcast"(%1488) : (vector<8xi32>) -> vector<32xi8>
  %1491 = "llvm.call_intrinsic"(%1489, %1480, %1490) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1492 = "llvm.bitcast"(%1491) : (vector<32xi8>) -> vector<4xi64>
  %1493 = "llvm.bitcast"(%1436) : (vector<4xi64>) -> vector<32xi8>
  %1494 = "llvm.call_intrinsic"(%1493, %1481, %1490) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1495 = "llvm.bitcast"(%1494) : (vector<32xi8>) -> vector<4xi64>
  %1496 = "llvm.bitcast"(%1437) : (vector<4xi64>) -> vector<32xi8>
  %1497 = "llvm.call_intrinsic"(%1496, %1482, %1490) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1498 = "llvm.bitcast"(%1497) : (vector<32xi8>) -> vector<4xi64>
  %1499 = "llvm.bitcast"(%1438) : (vector<4xi64>) -> vector<32xi8>
  %1500 = "llvm.call_intrinsic"(%1499, %1483, %1490) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1501 = "llvm.bitcast"(%1500) : (vector<32xi8>) -> vector<4xi64>
  %1502 = "llvm.bitcast"(%1439) : (vector<4xi64>) -> vector<32xi8>
  %1503 = "llvm.call_intrinsic"(%1502, %1484, %1490) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1504 = "llvm.bitcast"(%1503) : (vector<32xi8>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%1077) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1078) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1079) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1080) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1081) : (!llvm.ptr) -> ()
  "llvm.call"(%1077, %1078, %1079, %1080, %1081, %1492, %1495, %1498, %1501, %1504) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_neg, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1505 = "llvm.load"(%1077) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<32xi8>
  %1506 = "llvm.load"(%1078) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<32xi8>
  %1507 = "llvm.load"(%1079) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<32xi8>
  %1508 = "llvm.load"(%1080) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<32xi8>
  %1509 = "llvm.load"(%1081) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<32xi8>
  "llvm.intr.lifetime.end"(%1081) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1080) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1079) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1078) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1077) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1082) : (!llvm.ptr) -> ()
  "llvm.call"(%1082, %1492, %1495, %1498, %1501, %1504, %765) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_lane_canon, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 7, 0>}> : (!llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, i32) -> ()
  %1510 = "llvm.load"(%1082) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1511 = "llvm.getelementptr"(%arg140) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 31>}> : (!llvm.ptr) -> !llvm.ptr
  %1512 = "llvm.load"(%1511) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  "llvm.intr.lifetime.end"(%1082) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1082) : (!llvm.ptr) -> ()
  "llvm.call"(%1082, %1492, %1495, %1498, %1501, %1504, %761) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_lane_canon, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 7, 0>}> : (!llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, i32) -> ()
  %1513 = "llvm.load"(%1082) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1514 = "llvm.getelementptr"(%arg142) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 31>}> : (!llvm.ptr) -> !llvm.ptr
  %1515 = "llvm.load"(%1514) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  "llvm.intr.lifetime.end"(%1082) : (!llvm.ptr) -> ()
  %1516 = "llvm.trunc"(%1510) <{overflowFlags = 0 : i32}> : (i64) -> i32
  %1517 = "llvm.insertelement"(%733, %1516, %762) : (vector<2xi32>, i32, i64) -> vector<2xi32>
  %1518 = "llvm.trunc"(%1513) <{overflowFlags = 0 : i32}> : (i64) -> i32
  %1519 = "llvm.insertelement"(%1517, %1518, %758) : (vector<2xi32>, i32, i64) -> vector<2xi32>
  %1520 = "llvm.and"(%1519, %732) : (vector<2xi32>, vector<2xi32>) -> vector<2xi32>
  %1521 = "llvm.insertelement"(%731, %1512, %762) : (vector<2xi8>, i8, i64) -> vector<2xi8>
  %1522 = "llvm.insertelement"(%1521, %1515, %758) : (vector<2xi8>, i8, i64) -> vector<2xi8>
  %1523 = "llvm.lshr"(%1522, %730) : (vector<2xi8>, vector<2xi8>) -> vector<2xi8>
  %1524 = "llvm.zext"(%1523) <{nonNeg}> : (vector<2xi8>) -> vector<2xi32>
  %1525 = "llvm.icmp"(%1520, %1524) <{predicate = 1 : i64}> : (vector<2xi32>, vector<2xi32>) -> vector<2xi1>
  %1526 = "llvm.sext"(%1525) : (vector<2xi1>) -> vector<2xi32>
  %1527 = "llvm.shufflevector"(%1526, %733) <{mask = array<i32: 0, 1, -1, -1, -1, -1, -1, -1>}> : (vector<2xi32>, vector<2xi32>) -> vector<8xi32>
  %1528 = "llvm.shufflevector"(%1527, %777) <{mask = array<i32: 0, -1, -1, -1, 12, 13, 14, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1529 = "llvm.sext"(%1525) : (vector<2xi1>) -> vector<2xi32>
  %1530 = "llvm.shufflevector"(%1529, %733) <{mask = array<i32: 0, 1, -1, -1, -1, -1, -1, -1>}> : (vector<2xi32>, vector<2xi32>) -> vector<8xi32>
  %1531 = "llvm.shufflevector"(%1528, %1530) <{mask = array<i32: 0, 8, 9, -1, 4, 5, 6, 7>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1532 = "llvm.shufflevector"(%1531, %1527) <{mask = array<i32: 0, 1, 2, 9, 4, 5, 6, 7>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1533 = "llvm.bitcast"(%1532) : (vector<8xi32>) -> vector<32xi8>
  %1534 = "llvm.call_intrinsic"(%1491, %1505, %1533) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1535 = "llvm.bitcast"(%1534) : (vector<32xi8>) -> vector<4xi64>
  %1536 = "llvm.call_intrinsic"(%1494, %1506, %1533) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1537 = "llvm.bitcast"(%1536) : (vector<32xi8>) -> vector<4xi64>
  %1538 = "llvm.call_intrinsic"(%1497, %1507, %1533) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1539 = "llvm.bitcast"(%1538) : (vector<32xi8>) -> vector<4xi64>
  %1540 = "llvm.call_intrinsic"(%1500, %1508, %1533) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1541 = "llvm.bitcast"(%1540) : (vector<32xi8>) -> vector<4xi64>
  %1542 = "llvm.call_intrinsic"(%1503, %1509, %1533) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1543 = "llvm.bitcast"(%1542) : (vector<32xi8>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%1083) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1084) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1085) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1086) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1087) : (!llvm.ptr) -> ()
  "llvm.call"(%1083, %1084, %1085, %1086, %1087, %1535, %1537, %1539, %1541, %1543, %1091, %1097, %1103, %1109, %1115) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1544 = "llvm.load"(%1083) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1545 = "llvm.load"(%1084) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1546 = "llvm.load"(%1085) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1547 = "llvm.load"(%1086) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1548 = "llvm.load"(%1087) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1087) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1086) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1085) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1084) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1083) : (!llvm.ptr) -> ()
  %1549 = "llvm.call"(%1535, %765, %765, %765, %765) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1550 = "llvm.call"(%1537, %765, %765, %765, %765) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1551 = "llvm.call"(%1539, %765, %765, %765, %765) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1552 = "llvm.call"(%1541, %765, %765, %765, %765) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1553 = "llvm.call"(%1543, %765, %765, %765, %765) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1554 = "llvm.call"(%1091, %765, %765, %765, %765) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1555 = "llvm.call"(%1097, %765, %765, %765, %765) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1556 = "llvm.call"(%1103, %765, %765, %765, %765) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1557 = "llvm.call"(%1109, %765, %765, %765, %765) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1558 = "llvm.call"(%1115, %765, %765, %765, %765) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1559 = "llvm.shufflevector"(%1549, %1554) <{mask = array<i32: 0, 5, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1560 = "llvm.bitcast"(%1559) : (vector<4xi64>) -> vector<32xi8>
  %1561 = "llvm.shufflevector"(%1550, %1555) <{mask = array<i32: 0, 5, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1562 = "llvm.bitcast"(%1561) : (vector<4xi64>) -> vector<32xi8>
  %1563 = "llvm.shufflevector"(%1551, %1556) <{mask = array<i32: 0, 5, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1564 = "llvm.bitcast"(%1563) : (vector<4xi64>) -> vector<32xi8>
  %1565 = "llvm.shufflevector"(%1552, %1557) <{mask = array<i32: 0, 5, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1566 = "llvm.bitcast"(%1565) : (vector<4xi64>) -> vector<32xi8>
  %1567 = "llvm.shufflevector"(%1553, %1558) <{mask = array<i32: 0, 5, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1568 = "llvm.bitcast"(%1567) : (vector<4xi64>) -> vector<32xi8>
  %1569 = "llvm.shufflevector"(%1560, %809) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 48, 49, 50, 51, 52, 53, 54, 55, -1, -1, -1, -1, -1, -1, -1, -1>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1570 = "llvm.shufflevector"(%1562, %841) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 48, 49, 50, 51, 52, 53, 54, 55, -1, -1, -1, -1, -1, -1, -1, -1>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1571 = "llvm.shufflevector"(%1564, %841) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 48, 49, 50, 51, 52, 53, 54, 55, -1, -1, -1, -1, -1, -1, -1, -1>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1572 = "llvm.shufflevector"(%1566, %841) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 48, 49, 50, 51, 52, 53, 54, 55, -1, -1, -1, -1, -1, -1, -1, -1>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1573 = "llvm.shufflevector"(%1568, %841) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 48, 49, 50, 51, 52, 53, 54, 55, -1, -1, -1, -1, -1, -1, -1, -1>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1574 = "llvm.call"(%1544, %765, %765, %765, %765) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1575 = "llvm.call"(%1545, %765, %765, %765, %765) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1576 = "llvm.call"(%1546, %765, %765, %765, %765) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1577 = "llvm.call"(%1547, %765, %765, %765, %765) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1578 = "llvm.call"(%1548, %765, %765, %765, %765) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1579 = "llvm.bitcast"(%1574) : (vector<4xi64>) -> vector<32xi8>
  %1580 = "llvm.shufflevector"(%1569, %1579) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 56, 57, 58, 59, 60, 61, 62, 63>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1581 = "llvm.bitcast"(%1575) : (vector<4xi64>) -> vector<32xi8>
  %1582 = "llvm.shufflevector"(%1570, %1581) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 56, 57, 58, 59, 60, 61, 62, 63>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1583 = "llvm.bitcast"(%1576) : (vector<4xi64>) -> vector<32xi8>
  %1584 = "llvm.shufflevector"(%1571, %1583) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 56, 57, 58, 59, 60, 61, 62, 63>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1585 = "llvm.bitcast"(%1577) : (vector<4xi64>) -> vector<32xi8>
  %1586 = "llvm.shufflevector"(%1572, %1585) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 56, 57, 58, 59, 60, 61, 62, 63>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1587 = "llvm.bitcast"(%1578) : (vector<4xi64>) -> vector<32xi8>
  %1588 = "llvm.shufflevector"(%1573, %1587) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 56, 57, 58, 59, 60, 61, 62, 63>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1589 = "llvm.call"(%1535, %761, %761, %761, %761) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1590 = "llvm.call"(%1537, %761, %761, %761, %761) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1591 = "llvm.call"(%1539, %761, %761, %761, %761) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1592 = "llvm.call"(%1541, %761, %761, %761, %761) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1593 = "llvm.call"(%1543, %761, %761, %761, %761) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1594 = "llvm.call"(%1091, %761, %761, %761, %761) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1595 = "llvm.call"(%1097, %761, %761, %761, %761) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1596 = "llvm.call"(%1103, %761, %761, %761, %761) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1597 = "llvm.call"(%1109, %761, %761, %761, %761) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1598 = "llvm.call"(%1115, %761, %761, %761, %761) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1599 = "llvm.shufflevector"(%1589, %1594) <{mask = array<i32: 0, 5, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1600 = "llvm.bitcast"(%1599) : (vector<4xi64>) -> vector<32xi8>
  %1601 = "llvm.shufflevector"(%1590, %1595) <{mask = array<i32: 0, 5, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1602 = "llvm.bitcast"(%1601) : (vector<4xi64>) -> vector<32xi8>
  %1603 = "llvm.shufflevector"(%1591, %1596) <{mask = array<i32: 0, 5, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1604 = "llvm.bitcast"(%1603) : (vector<4xi64>) -> vector<32xi8>
  %1605 = "llvm.shufflevector"(%1592, %1597) <{mask = array<i32: 0, 5, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1606 = "llvm.bitcast"(%1605) : (vector<4xi64>) -> vector<32xi8>
  %1607 = "llvm.shufflevector"(%1593, %1598) <{mask = array<i32: 0, 5, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1608 = "llvm.bitcast"(%1607) : (vector<4xi64>) -> vector<32xi8>
  %1609 = "llvm.shufflevector"(%1600, %809) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 48, 49, 50, 51, 52, 53, 54, 55, -1, -1, -1, -1, -1, -1, -1, -1>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1610 = "llvm.shufflevector"(%1602, %841) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 48, 49, 50, 51, 52, 53, 54, 55, -1, -1, -1, -1, -1, -1, -1, -1>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1611 = "llvm.shufflevector"(%1604, %841) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 48, 49, 50, 51, 52, 53, 54, 55, -1, -1, -1, -1, -1, -1, -1, -1>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1612 = "llvm.shufflevector"(%1606, %841) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 48, 49, 50, 51, 52, 53, 54, 55, -1, -1, -1, -1, -1, -1, -1, -1>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1613 = "llvm.shufflevector"(%1608, %841) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 48, 49, 50, 51, 52, 53, 54, 55, -1, -1, -1, -1, -1, -1, -1, -1>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1614 = "llvm.call"(%1544, %761, %761, %761, %761) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1615 = "llvm.call"(%1545, %761, %761, %761, %761) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1616 = "llvm.call"(%1546, %761, %761, %761, %761) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1617 = "llvm.call"(%1547, %761, %761, %761, %761) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1618 = "llvm.call"(%1548, %761, %761, %761, %761) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1619 = "llvm.bitcast"(%1614) : (vector<4xi64>) -> vector<32xi8>
  %1620 = "llvm.shufflevector"(%1609, %1619) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 56, 57, 58, 59, 60, 61, 62, 63>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1621 = "llvm.bitcast"(%1615) : (vector<4xi64>) -> vector<32xi8>
  %1622 = "llvm.shufflevector"(%1610, %1621) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 56, 57, 58, 59, 60, 61, 62, 63>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1623 = "llvm.bitcast"(%1616) : (vector<4xi64>) -> vector<32xi8>
  %1624 = "llvm.shufflevector"(%1611, %1623) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 56, 57, 58, 59, 60, 61, 62, 63>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1625 = "llvm.bitcast"(%1617) : (vector<4xi64>) -> vector<32xi8>
  %1626 = "llvm.shufflevector"(%1612, %1625) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 56, 57, 58, 59, 60, 61, 62, 63>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1627 = "llvm.bitcast"(%1618) : (vector<4xi64>) -> vector<32xi8>
  %1628 = "llvm.shufflevector"(%1613, %1627) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 56, 57, 58, 59, 60, 61, 62, 63>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  "llvm.store"(%1580, %arg139) <{alignment = 64 : i64, ordering = 0 : i64}> : (vector<32xi8>, !llvm.ptr) -> ()
  %1629 = "llvm.getelementptr"(%arg139) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1582, %1629) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<32xi8>, !llvm.ptr) -> ()
  %1630 = "llvm.getelementptr"(%arg139) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1584, %1630) <{alignment = 64 : i64, ordering = 0 : i64}> : (vector<32xi8>, !llvm.ptr) -> ()
  %1631 = "llvm.getelementptr"(%arg139) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1586, %1631) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<32xi8>, !llvm.ptr) -> ()
  %1632 = "llvm.getelementptr"(%arg139) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1588, %1632) <{alignment = 64 : i64, ordering = 0 : i64}> : (vector<32xi8>, !llvm.ptr) -> ()
  "llvm.store"(%1620, %arg141) <{alignment = 64 : i64, ordering = 0 : i64}> : (vector<32xi8>, !llvm.ptr) -> ()
  %1633 = "llvm.getelementptr"(%arg141) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1622, %1633) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<32xi8>, !llvm.ptr) -> ()
  %1634 = "llvm.getelementptr"(%arg141) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1624, %1634) <{alignment = 64 : i64, ordering = 0 : i64}> : (vector<32xi8>, !llvm.ptr) -> ()
  %1635 = "llvm.getelementptr"(%arg141) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1626, %1635) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<32xi8>, !llvm.ptr) -> ()
  %1636 = "llvm.getelementptr"(%arg141) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1628, %1636) <{alignment = 64 : i64, ordering = 0 : i64}> : (vector<32xi8>, !llvm.ptr) -> ()
  "llvm.br"(%759)[^bb15] : (i32) -> ()
^bb15(%1637: i32):  // 3 preds: ^bb12, ^bb13, ^bb14
  "llvm.intr.lifetime.end"(%843) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%842) : (!llvm.ptr) -> ()
  "llvm.return"(%1637) : (i32) -> ()
}) : () -> ()
  with @fd_r52x5_limbs_eq := fd_r52x5_limbs_eq,
    @fd_r52x5_limbs_frombytes := fd_r52x5_limbs_frombytes, @fd_r52x5_quad_add := fd_r52x5_quad_add,
    @fd_r52x5_quad_lane_canon := fd_r52x5_quad_lane_canon, @fd_r52x5_quad_mul := fd_r52x5_quad_mul,
    @fd_r52x5_quad_neg := fd_r52x5_quad_neg, @fd_r52x5_quad_sqr := fd_r52x5_quad_sqr,
    @fd_r52x5_quad_sub := fd_r52x5_quad_sub, @wl_permute := wl_permute

end

end MLIR.Firedancer.Crc.Verify
