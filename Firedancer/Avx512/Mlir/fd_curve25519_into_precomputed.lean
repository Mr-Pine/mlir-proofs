module

-- build/llvm23/mlir_canonicalized/avx512/op/fd_curve25519_into_precomputed.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Avx512.Mlir.fd_r43x6_quad_mul_fast

meta import MLIR.Semantics.Func
meta import Firedancer.Avx512.Mlir.fd_r43x6_quad_mul_fast

namespace MLIR.Firedancer.Avx512

@[expose] public section

mlir_def fd_curve25519_into_precomputed :=
#tbaa_root = #llvm.tbaa_root<id = "Simple C/C++ TBAA">
#tbaa_type_desc = #llvm.tbaa_type_desc<id = "omnipotent char", members = {<#tbaa_root, 0>}>
#tbaa_tag = #llvm.tbaa_tag<base_type = #tbaa_type_desc, access_type = #tbaa_type_desc, offset = 0>
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}], dso_local, function_type = !llvm.func<void (ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], sym_name = "fd_curve25519_into_precomputed", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg120: !llvm.ptr):
  %2810 = "llvm.mlir.constant"() <{value = dense<[0, 0, 0, 15037786634, 0, 0, 0, 309467527341]> : vector<8xi64>}> : () -> vector<8xi64>
  %2811 = "llvm.mlir.constant"() <{value = dense<[0, 0, 0, 507525298899, 0, 0, 0, 6596238350568]> : vector<8xi64>}> : () -> vector<8xi64>
  %2812 = "llvm.mlir.constant"() <{value = dense<[1, 1, 1, 3934839304537, 0, 0, 0, 521695520920]> : vector<8xi64>}> : () -> vector<8xi64>
  %2813 = "llvm.mlir.constant"() <{value = dense<[8796093022207, 8796093022207, 8796093022207, 8796093022207, 1099511627775, 1099511627775, 1099511627775, 1099511627775]> : vector<8xi64>}> : () -> vector<8xi64>
  %2814 = "llvm.mlir.constant"() <{value = dense<1048576> : vector<8xi64>}> : () -> vector<8xi64>
  %2815 = "llvm.mlir.constant"() <{value = dense<[159383552, 159383552, 159383552, 159383552, 1048576, 1048576, 1048576, 1048576]> : vector<8xi64>}> : () -> vector<8xi64>
  %2816 = "llvm.mlir.constant"() <{value = dense<8796093022207> : vector<8xi64>}> : () -> vector<8xi64>
  %2817 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %2818 = "llvm.mlir.constant"() <{value = dense<[43, 43, 43, 43, 40, 40, 40, 40]> : vector<8xi64>}> : () -> vector<8xi64>
  %2819 = "llvm.mlir.constant"() <{value = dense<43> : vector<8xi64>}> : () -> vector<8xi64>
  %2820 = "llvm.mlir.constant"() <{value = dense<-1048576> : vector<8xi64>}> : () -> vector<8xi64>
  %2821 = "llvm.mlir.constant"() <{value = dense<[-159383552, -159383552, -159383552, -159383552, -1048576, -1048576, -1048576, -1048576]> : vector<8xi64>}> : () -> vector<8xi64>
  %2822 = "llvm.mlir.constant"() <{value = 1099511627775 : i64}> : () -> i64
  %2823 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %2824 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %2825 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %2826 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %2827 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %2828 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %2829 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %2830 = "llvm.mlir.poison"() : () -> vector<8xi64>
  %2831 = "llvm.mlir.poison"() : () -> i64
  %2832 = "llvm.mlir.constant"() <{value = 8796093022207 : i64}> : () -> i64
  %2833 = "llvm.mlir.constant"() <{value = 8796093022189 : i64}> : () -> i64
  %2834 = "llvm.mlir.undef"() : () -> vector<8xi64>
  %2835 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %2836 = "llvm.insertelement"(%2834, %2833, %2835) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2837 = "llvm.insertelement"(%2836, %2831, %2829) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2838 = "llvm.insertelement"(%2837, %2831, %2828) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2839 = "llvm.insertelement"(%2838, %2831, %2827) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2840 = "llvm.insertelement"(%2839, %2832, %2826) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2841 = "llvm.insertelement"(%2840, %2831, %2825) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2842 = "llvm.insertelement"(%2841, %2831, %2824) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2843 = "llvm.insertelement"(%2842, %2831, %2823) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2844 = "llvm.insertelement"(%2834, %2832, %2835) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2845 = "llvm.insertelement"(%2844, %2831, %2829) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2846 = "llvm.insertelement"(%2845, %2831, %2828) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2847 = "llvm.insertelement"(%2846, %2831, %2827) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2848 = "llvm.insertelement"(%2847, %2832, %2826) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2849 = "llvm.insertelement"(%2848, %2831, %2825) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2850 = "llvm.insertelement"(%2849, %2831, %2824) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2851 = "llvm.insertelement"(%2850, %2831, %2823) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2852 = "llvm.insertelement"(%2834, %2832, %2835) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2853 = "llvm.insertelement"(%2852, %2831, %2829) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2854 = "llvm.insertelement"(%2853, %2831, %2828) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2855 = "llvm.insertelement"(%2854, %2831, %2827) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2856 = "llvm.insertelement"(%2855, %2822, %2826) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2857 = "llvm.insertelement"(%2856, %2831, %2825) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2858 = "llvm.insertelement"(%2857, %2831, %2824) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2859 = "llvm.insertelement"(%2858, %2831, %2823) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2860 = "llvm.insertelement"(%2834, %2831, %2835) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2861 = "llvm.insertelement"(%2860, %2831, %2829) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2862 = "llvm.insertelement"(%2861, %2831, %2828) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2863 = "llvm.insertelement"(%2862, %2831, %2827) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2864 = "llvm.insertelement"(%2863, %2817, %2826) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2865 = "llvm.insertelement"(%2864, %2817, %2825) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2866 = "llvm.insertelement"(%2865, %2817, %2824) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2867 = "llvm.insertelement"(%2866, %2817, %2823) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2868 = "llvm.alloca"(%2829) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %2869 = "llvm.alloca"(%2829) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %2870 = "llvm.alloca"(%2829) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %2871 = "llvm.load"(%arg120) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2872 = "llvm.shufflevector"(%2871, %2830) <{mask = array<i32: 1, -1, -1, -1, 5, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2873 = "llvm.getelementptr"(%arg120) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %2874 = "llvm.load"(%2873) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2875 = "llvm.shufflevector"(%2874, %2830) <{mask = array<i32: 1, -1, -1, -1, 5, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2876 = "llvm.getelementptr"(%arg120) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %2877 = "llvm.load"(%2876) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2878 = "llvm.shufflevector"(%2877, %2830) <{mask = array<i32: 1, -1, -1, -1, 5, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2879 = "llvm.sub"(%2872, %2871) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2880 = "llvm.add"(%2879, %2843) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2881 = "llvm.shufflevector"(%2880, %2871) <{mask = array<i32: 0, 8, 10, 11, 4, 12, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2882 = "llvm.sub"(%2875, %2874) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2883 = "llvm.add"(%2882, %2851) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2884 = "llvm.shufflevector"(%2883, %2874) <{mask = array<i32: 0, 8, 10, 11, 4, 12, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2885 = "llvm.sub"(%2878, %2877) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2886 = "llvm.add"(%2885, %2859) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2887 = "llvm.shufflevector"(%2886, %2877) <{mask = array<i32: 0, 8, 10, 11, 4, 12, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2888 = "llvm.add"(%2881, %2871) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2889 = "llvm.shufflevector"(%2881, %2888) <{mask = array<i32: 0, 9, 2, 3, 4, 13, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2890 = "llvm.add"(%2884, %2874) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2891 = "llvm.shufflevector"(%2884, %2890) <{mask = array<i32: 0, 9, 2, 3, 4, 13, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2892 = "llvm.add"(%2887, %2877) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2893 = "llvm.shufflevector"(%2887, %2892) <{mask = array<i32: 0, 9, 2, 3, 4, 13, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2894 = "llvm.add"(%2889, %2821) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2895 = "llvm.add"(%2891, %2820) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2896 = "llvm.add"(%2893, %2820) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2897 = "llvm.ashr"(%2894, %2819) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2898 = "llvm.ashr"(%2895, %2819) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2899 = "llvm.ashr"(%2896, %2818) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2900 = "llvm.mul"(%2899, %2867) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2901 = "llvm.and"(%2894, %2816) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2902 = "llvm.shufflevector"(%2900, %2899) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2903 = "llvm.add"(%2901, %2815) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2904 = "llvm.add"(%2903, %2902) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2905 = "llvm.and"(%2895, %2816) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2906 = "llvm.add"(%2897, %2814) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2907 = "llvm.add"(%2906, %2905) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2908 = "llvm.and"(%2896, %2813) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2909 = "llvm.add"(%2898, %2814) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2910 = "llvm.add"(%2909, %2908) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.intr.lifetime.start"(%2868) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2869) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2870) : (!llvm.ptr) -> ()
  "llvm.call"(%2868, %2869, %2870, %2904, %2907, %2910, %2812, %2811, %2810) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_quad_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 9, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
  %2911 = "llvm.load"(%2868) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2912 = "llvm.load"(%2869) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2913 = "llvm.load"(%2870) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.intr.lifetime.end"(%2870) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2869) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2868) : (!llvm.ptr) -> ()
  %2914 = "llvm.lshr"(%2911, %2819) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2915 = "llvm.lshr"(%2912, %2819) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2916 = "llvm.lshr"(%2913, %2818) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2917 = "llvm.mul"(%2916, %2867) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2918 = "llvm.and"(%2911, %2816) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2919 = "llvm.shufflevector"(%2917, %2916) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2920 = "llvm.add"(%2919, %2918) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%2920, %arg120) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2921 = "llvm.and"(%2912, %2816) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2922 = "llvm.add"(%2921, %2914) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%2922, %2873) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2923 = "llvm.and"(%2913, %2813) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2924 = "llvm.add"(%2923, %2915) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%2924, %2876) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
  with @fd_r43x6_quad_mul_fast := fd_r43x6_quad_mul_fast

end

end MLIR.Firedancer.Avx512
