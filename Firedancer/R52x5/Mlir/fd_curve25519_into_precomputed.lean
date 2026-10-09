module

-- ~/fd-pr9879/build/llvm23-production/mlir_canonicalized/avx512/op/fd_curve25519_into_precomputed.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.R52x5.Mlir.wc_bcast_wide
public import Firedancer.R52x5.Mlir.wl_permute

meta import MLIR.Semantics.Func
meta import Firedancer.R52x5.Mlir.wc_bcast_wide
meta import Firedancer.R52x5.Mlir.wl_permute

namespace MLIR.Firedancer.R52x5

@[expose] public section

mlir_def fd_curve25519_into_precomputed :=
#tbaa_root = #llvm.tbaa_root<id = "Simple C/C++ TBAA">
#tbaa_type_desc = #llvm.tbaa_type_desc<id = "omnipotent char", members = {<#tbaa_root, 0>}>
#tbaa_tag = #llvm.tbaa_tag<base_type = #tbaa_type_desc, access_type = #tbaa_type_desc, offset = 0>
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "256"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], sym_name = "fd_curve25519_into_precomputed", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg131: !llvm.ptr):
  %3818 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %3819 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %3820 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %3821 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %3822 = "llvm.mlir.constant"() <{value = dense<72057594037927328> : vector<4xi64>}> : () -> vector<4xi64>
  %3823 = "llvm.mlir.constant"() <{value = dense<72057594037927904> : vector<4xi64>}> : () -> vector<4xi64>
  %3824 = "llvm.mlir.constant"() <{value = dense<51> : vector<4xi64>}> : () -> vector<4xi64>
  %3825 = "llvm.mlir.constant"() <{value = dense<2251799813685247> : vector<4xi64>}> : () -> vector<4xi64>
  %3826 = "llvm.mlir.constant"() <{value = dense<19> : vector<4xi64>}> : () -> vector<4xi64>
  %3827 = "llvm.mlir.constant"() <{value = dense<0> : vector<4xi64>}> : () -> vector<4xi64>
  %3828 = "llvm.mlir.constant"() <{value = dense<[121666, 121666, 243332, 243330]> : vector<4xi64>}> : () -> vector<4xi64>
  %3829 = "llvm.mlir.constant"() <{value = dense<1> : vector<4xi64>}> : () -> vector<4xi64>
  %3830 = "llvm.load"(%arg131) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %3831 = "llvm.call"(%3830, %3818, %3819, %3820, %3821) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3832 = "llvm.getelementptr"(%arg131) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %3833 = "llvm.load"(%3832) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %3834 = "llvm.call"(%3833, %3818, %3819, %3820, %3821) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3835 = "llvm.getelementptr"(%arg131) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %3836 = "llvm.load"(%3835) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %3837 = "llvm.call"(%3836, %3818, %3819, %3820, %3821) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3838 = "llvm.getelementptr"(%arg131) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %3839 = "llvm.load"(%3838) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %3840 = "llvm.call"(%3839, %3818, %3819, %3820, %3821) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3841 = "llvm.getelementptr"(%arg131) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %3842 = "llvm.load"(%3841) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %3843 = "llvm.call"(%3842, %3818, %3819, %3820, %3821) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3844 = "llvm.sub"(%3822, %3830) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3845 = "llvm.sub"(%3823, %3833) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3846 = "llvm.sub"(%3823, %3836) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3847 = "llvm.sub"(%3823, %3839) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3848 = "llvm.sub"(%3823, %3842) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3849 = "llvm.call"(%3818, %3819, %3818, %3819) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wc_bcast_wide, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (i32, i32, i32, i32) -> vector<4xi64>
  %3850 = "llvm.bitcast"(%3830) : (vector<4xi64>) -> vector<32xi8>
  %3851 = "llvm.bitcast"(%3844) : (vector<4xi64>) -> vector<32xi8>
  %3852 = "llvm.bitcast"(%3849) : (vector<4xi64>) -> vector<32xi8>
  %3853 = "llvm.call_intrinsic"(%3850, %3851, %3852) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3854 = "llvm.bitcast"(%3853) : (vector<32xi8>) -> vector<4xi64>
  %3855 = "llvm.bitcast"(%3833) : (vector<4xi64>) -> vector<32xi8>
  %3856 = "llvm.bitcast"(%3845) : (vector<4xi64>) -> vector<32xi8>
  %3857 = "llvm.call_intrinsic"(%3855, %3856, %3852) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3858 = "llvm.bitcast"(%3857) : (vector<32xi8>) -> vector<4xi64>
  %3859 = "llvm.bitcast"(%3836) : (vector<4xi64>) -> vector<32xi8>
  %3860 = "llvm.bitcast"(%3846) : (vector<4xi64>) -> vector<32xi8>
  %3861 = "llvm.call_intrinsic"(%3859, %3860, %3852) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3862 = "llvm.bitcast"(%3861) : (vector<32xi8>) -> vector<4xi64>
  %3863 = "llvm.bitcast"(%3839) : (vector<4xi64>) -> vector<32xi8>
  %3864 = "llvm.bitcast"(%3847) : (vector<4xi64>) -> vector<32xi8>
  %3865 = "llvm.call_intrinsic"(%3863, %3864, %3852) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3866 = "llvm.bitcast"(%3865) : (vector<32xi8>) -> vector<4xi64>
  %3867 = "llvm.bitcast"(%3842) : (vector<4xi64>) -> vector<32xi8>
  %3868 = "llvm.bitcast"(%3848) : (vector<4xi64>) -> vector<32xi8>
  %3869 = "llvm.call_intrinsic"(%3867, %3868, %3852) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3870 = "llvm.bitcast"(%3869) : (vector<32xi8>) -> vector<4xi64>
  %3871 = "llvm.add"(%3831, %3854) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3872 = "llvm.add"(%3834, %3858) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3873 = "llvm.add"(%3837, %3862) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3874 = "llvm.add"(%3840, %3866) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3875 = "llvm.add"(%3843, %3870) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3876 = "llvm.call"(%3818, %3818, %3819, %3819) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wc_bcast_wide, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (i32, i32, i32, i32) -> vector<4xi64>
  %3877 = "llvm.bitcast"(%3871) : (vector<4xi64>) -> vector<32xi8>
  %3878 = "llvm.bitcast"(%3876) : (vector<4xi64>) -> vector<32xi8>
  %3879 = "llvm.call_intrinsic"(%3850, %3877, %3878) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3880 = "llvm.bitcast"(%3879) : (vector<32xi8>) -> vector<4xi64>
  %3881 = "llvm.bitcast"(%3872) : (vector<4xi64>) -> vector<32xi8>
  %3882 = "llvm.call_intrinsic"(%3855, %3881, %3878) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3883 = "llvm.bitcast"(%3882) : (vector<32xi8>) -> vector<4xi64>
  %3884 = "llvm.bitcast"(%3873) : (vector<4xi64>) -> vector<32xi8>
  %3885 = "llvm.call_intrinsic"(%3859, %3884, %3878) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3886 = "llvm.bitcast"(%3885) : (vector<32xi8>) -> vector<4xi64>
  %3887 = "llvm.bitcast"(%3874) : (vector<4xi64>) -> vector<32xi8>
  %3888 = "llvm.call_intrinsic"(%3863, %3887, %3878) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3889 = "llvm.bitcast"(%3888) : (vector<32xi8>) -> vector<4xi64>
  %3890 = "llvm.bitcast"(%3875) : (vector<4xi64>) -> vector<32xi8>
  %3891 = "llvm.call_intrinsic"(%3867, %3890, %3878) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3892 = "llvm.bitcast"(%3891) : (vector<32xi8>) -> vector<4xi64>
  %3893 = "llvm.lshr"(%3880, %3824) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3894 = "llvm.lshr"(%3883, %3824) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3895 = "llvm.lshr"(%3886, %3824) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3896 = "llvm.lshr"(%3889, %3824) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3897 = "llvm.lshr"(%3892, %3824) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3898 = "llvm.bitcast"(%3879) : (vector<32xi8>) -> vector<4xi64>
  %3899 = "llvm.and"(%3898, %3825) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3900 = "llvm.call_intrinsic"(%3899, %3897, %3826) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3901 = "llvm.bitcast"(%3882) : (vector<32xi8>) -> vector<4xi64>
  %3902 = "llvm.and"(%3901, %3825) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3903 = "llvm.add"(%3902, %3893) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3904 = "llvm.bitcast"(%3885) : (vector<32xi8>) -> vector<4xi64>
  %3905 = "llvm.and"(%3904, %3825) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3906 = "llvm.add"(%3905, %3894) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3907 = "llvm.bitcast"(%3888) : (vector<32xi8>) -> vector<4xi64>
  %3908 = "llvm.and"(%3907, %3825) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3909 = "llvm.add"(%3908, %3895) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3910 = "llvm.bitcast"(%3891) : (vector<32xi8>) -> vector<4xi64>
  %3911 = "llvm.and"(%3910, %3825) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3912 = "llvm.add"(%3911, %3896) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3913 = "llvm.call_intrinsic"(%3827, %3828, %3900) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3914 = "llvm.call_intrinsic"(%3827, %3828, %3900) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3915 = "llvm.call_intrinsic"(%3827, %3828, %3903) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3916 = "llvm.call_intrinsic"(%3827, %3828, %3906) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3917 = "llvm.call_intrinsic"(%3827, %3828, %3909) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3918 = "llvm.call_intrinsic"(%3827, %3828, %3912) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3919 = "llvm.shl"(%3918, %3829) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3920 = "llvm.call_intrinsic"(%3913, %3919, %3826) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3921 = "llvm.call_intrinsic"(%3914, %3828, %3903) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3922 = "llvm.add"(%3921, %3914) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3923 = "llvm.call_intrinsic"(%3915, %3828, %3906) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3924 = "llvm.add"(%3923, %3915) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3925 = "llvm.call_intrinsic"(%3916, %3828, %3909) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3926 = "llvm.add"(%3925, %3916) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3927 = "llvm.call_intrinsic"(%3917, %3828, %3912) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3928 = "llvm.add"(%3927, %3917) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3929 = "llvm.sub"(%3822, %3920) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3930 = "llvm.sub"(%3823, %3922) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3931 = "llvm.sub"(%3823, %3924) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3932 = "llvm.sub"(%3823, %3926) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3933 = "llvm.sub"(%3823, %3928) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3934 = "llvm.call"(%3819, %3819, %3819, %3818) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wc_bcast_wide, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (i32, i32, i32, i32) -> vector<4xi64>
  %3935 = "llvm.bitcast"(%3920) : (vector<4xi64>) -> vector<32xi8>
  %3936 = "llvm.bitcast"(%3929) : (vector<4xi64>) -> vector<32xi8>
  %3937 = "llvm.bitcast"(%3934) : (vector<4xi64>) -> vector<32xi8>
  %3938 = "llvm.call_intrinsic"(%3935, %3936, %3937) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3939 = "llvm.bitcast"(%3938) : (vector<32xi8>) -> vector<4xi64>
  %3940 = "llvm.bitcast"(%3922) : (vector<4xi64>) -> vector<32xi8>
  %3941 = "llvm.bitcast"(%3930) : (vector<4xi64>) -> vector<32xi8>
  %3942 = "llvm.call_intrinsic"(%3940, %3941, %3937) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3943 = "llvm.bitcast"(%3942) : (vector<32xi8>) -> vector<4xi64>
  %3944 = "llvm.bitcast"(%3924) : (vector<4xi64>) -> vector<32xi8>
  %3945 = "llvm.bitcast"(%3931) : (vector<4xi64>) -> vector<32xi8>
  %3946 = "llvm.call_intrinsic"(%3944, %3945, %3937) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3947 = "llvm.bitcast"(%3946) : (vector<32xi8>) -> vector<4xi64>
  %3948 = "llvm.bitcast"(%3926) : (vector<4xi64>) -> vector<32xi8>
  %3949 = "llvm.bitcast"(%3932) : (vector<4xi64>) -> vector<32xi8>
  %3950 = "llvm.call_intrinsic"(%3948, %3949, %3937) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3951 = "llvm.bitcast"(%3950) : (vector<32xi8>) -> vector<4xi64>
  %3952 = "llvm.bitcast"(%3928) : (vector<4xi64>) -> vector<32xi8>
  %3953 = "llvm.bitcast"(%3933) : (vector<4xi64>) -> vector<32xi8>
  %3954 = "llvm.call_intrinsic"(%3952, %3953, %3937) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3955 = "llvm.bitcast"(%3954) : (vector<32xi8>) -> vector<4xi64>
  %3956 = "llvm.lshr"(%3939, %3824) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3957 = "llvm.lshr"(%3943, %3824) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3958 = "llvm.lshr"(%3947, %3824) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3959 = "llvm.lshr"(%3951, %3824) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3960 = "llvm.lshr"(%3955, %3824) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3961 = "llvm.bitcast"(%3938) : (vector<32xi8>) -> vector<4xi64>
  %3962 = "llvm.and"(%3961, %3825) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3963 = "llvm.call_intrinsic"(%3962, %3960, %3826) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.store"(%3963, %arg131) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<4xi64>, !llvm.ptr) -> ()
  %3964 = "llvm.bitcast"(%3942) : (vector<32xi8>) -> vector<4xi64>
  %3965 = "llvm.and"(%3964, %3825) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3966 = "llvm.add"(%3965, %3956) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.store"(%3966, %3832) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<4xi64>, !llvm.ptr) -> ()
  %3967 = "llvm.bitcast"(%3946) : (vector<32xi8>) -> vector<4xi64>
  %3968 = "llvm.and"(%3967, %3825) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3969 = "llvm.add"(%3968, %3957) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.store"(%3969, %3835) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<4xi64>, !llvm.ptr) -> ()
  %3970 = "llvm.bitcast"(%3950) : (vector<32xi8>) -> vector<4xi64>
  %3971 = "llvm.and"(%3970, %3825) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3972 = "llvm.add"(%3971, %3958) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.store"(%3972, %3838) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<4xi64>, !llvm.ptr) -> ()
  %3973 = "llvm.bitcast"(%3954) : (vector<32xi8>) -> vector<4xi64>
  %3974 = "llvm.and"(%3973, %3825) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3975 = "llvm.add"(%3974, %3959) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.store"(%3975, %3841) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
  with @wc_bcast_wide := wc_bcast_wide, @wl_permute := wl_permute

end

end MLIR.Firedancer.R52x5
