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
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef}], dso_local, function_type = !llvm.func<void (ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], sym_name = "fd_curve25519_into_precomputed", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg122: !llvm.ptr):
  %2820 = "llvm.mlir.constant"() <{value = dense<[0, 0, 0, 15037786634, 0, 0, 0, 309467527341]> : vector<8xi64>}> : () -> vector<8xi64>
  %2821 = "llvm.mlir.constant"() <{value = dense<[0, 0, 0, 507525298899, 0, 0, 0, 6596238350568]> : vector<8xi64>}> : () -> vector<8xi64>
  %2822 = "llvm.mlir.constant"() <{value = dense<[1, 1, 1, 3934839304537, 0, 0, 0, 521695520920]> : vector<8xi64>}> : () -> vector<8xi64>
  %2823 = "llvm.mlir.constant"() <{value = dense<[8796093022207, 8796093022207, 8796093022207, 8796093022207, 1099511627775, 1099511627775, 1099511627775, 1099511627775]> : vector<8xi64>}> : () -> vector<8xi64>
  %2824 = "llvm.mlir.constant"() <{value = dense<1048576> : vector<8xi64>}> : () -> vector<8xi64>
  %2825 = "llvm.mlir.constant"() <{value = dense<[159383552, 159383552, 159383552, 159383552, 1048576, 1048576, 1048576, 1048576]> : vector<8xi64>}> : () -> vector<8xi64>
  %2826 = "llvm.mlir.constant"() <{value = dense<8796093022207> : vector<8xi64>}> : () -> vector<8xi64>
  %2827 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %2828 = "llvm.mlir.constant"() <{value = dense<[43, 43, 43, 43, 40, 40, 40, 40]> : vector<8xi64>}> : () -> vector<8xi64>
  %2829 = "llvm.mlir.constant"() <{value = dense<43> : vector<8xi64>}> : () -> vector<8xi64>
  %2830 = "llvm.mlir.constant"() <{value = dense<-1048576> : vector<8xi64>}> : () -> vector<8xi64>
  %2831 = "llvm.mlir.constant"() <{value = dense<[-159383552, -159383552, -159383552, -159383552, -1048576, -1048576, -1048576, -1048576]> : vector<8xi64>}> : () -> vector<8xi64>
  %2832 = "llvm.mlir.constant"() <{value = 1099511627775 : i64}> : () -> i64
  %2833 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %2834 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %2835 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %2836 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %2837 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %2838 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %2839 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %2840 = "llvm.mlir.poison"() : () -> vector<8xi64>
  %2841 = "llvm.mlir.poison"() : () -> i64
  %2842 = "llvm.mlir.constant"() <{value = 8796093022207 : i64}> : () -> i64
  %2843 = "llvm.mlir.constant"() <{value = 8796093022189 : i64}> : () -> i64
  %2844 = "llvm.mlir.undef"() : () -> vector<8xi64>
  %2845 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %2846 = "llvm.insertelement"(%2844, %2843, %2845) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2847 = "llvm.insertelement"(%2846, %2841, %2839) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2848 = "llvm.insertelement"(%2847, %2841, %2838) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2849 = "llvm.insertelement"(%2848, %2841, %2837) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2850 = "llvm.insertelement"(%2849, %2842, %2836) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2851 = "llvm.insertelement"(%2850, %2841, %2835) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2852 = "llvm.insertelement"(%2851, %2841, %2834) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2853 = "llvm.insertelement"(%2852, %2841, %2833) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2854 = "llvm.insertelement"(%2844, %2842, %2845) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2855 = "llvm.insertelement"(%2854, %2841, %2839) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2856 = "llvm.insertelement"(%2855, %2841, %2838) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2857 = "llvm.insertelement"(%2856, %2841, %2837) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2858 = "llvm.insertelement"(%2857, %2842, %2836) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2859 = "llvm.insertelement"(%2858, %2841, %2835) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2860 = "llvm.insertelement"(%2859, %2841, %2834) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2861 = "llvm.insertelement"(%2860, %2841, %2833) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2862 = "llvm.insertelement"(%2844, %2842, %2845) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2863 = "llvm.insertelement"(%2862, %2841, %2839) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2864 = "llvm.insertelement"(%2863, %2841, %2838) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2865 = "llvm.insertelement"(%2864, %2841, %2837) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2866 = "llvm.insertelement"(%2865, %2832, %2836) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2867 = "llvm.insertelement"(%2866, %2841, %2835) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2868 = "llvm.insertelement"(%2867, %2841, %2834) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2869 = "llvm.insertelement"(%2868, %2841, %2833) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2870 = "llvm.insertelement"(%2844, %2841, %2845) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2871 = "llvm.insertelement"(%2870, %2841, %2839) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2872 = "llvm.insertelement"(%2871, %2841, %2838) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2873 = "llvm.insertelement"(%2872, %2841, %2837) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2874 = "llvm.insertelement"(%2873, %2827, %2836) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2875 = "llvm.insertelement"(%2874, %2827, %2835) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2876 = "llvm.insertelement"(%2875, %2827, %2834) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2877 = "llvm.insertelement"(%2876, %2827, %2833) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2878 = "llvm.alloca"(%2839) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %2879 = "llvm.alloca"(%2839) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %2880 = "llvm.alloca"(%2839) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %2881 = "llvm.load"(%arg122) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2882 = "llvm.shufflevector"(%2881, %2840) <{mask = array<i32: 1, -1, -1, -1, 5, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2883 = "llvm.getelementptr"(%arg122) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %2884 = "llvm.load"(%2883) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2885 = "llvm.shufflevector"(%2884, %2840) <{mask = array<i32: 1, -1, -1, -1, 5, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2886 = "llvm.getelementptr"(%arg122) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %2887 = "llvm.load"(%2886) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2888 = "llvm.shufflevector"(%2887, %2840) <{mask = array<i32: 1, -1, -1, -1, 5, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2889 = "llvm.sub"(%2882, %2881) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2890 = "llvm.add"(%2889, %2853) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2891 = "llvm.shufflevector"(%2890, %2881) <{mask = array<i32: 0, 8, 10, 11, 4, 12, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2892 = "llvm.sub"(%2885, %2884) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2893 = "llvm.add"(%2892, %2861) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2894 = "llvm.shufflevector"(%2893, %2884) <{mask = array<i32: 0, 8, 10, 11, 4, 12, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2895 = "llvm.sub"(%2888, %2887) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2896 = "llvm.add"(%2895, %2869) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2897 = "llvm.shufflevector"(%2896, %2887) <{mask = array<i32: 0, 8, 10, 11, 4, 12, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2898 = "llvm.add"(%2891, %2881) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2899 = "llvm.shufflevector"(%2891, %2898) <{mask = array<i32: 0, 9, 2, 3, 4, 13, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2900 = "llvm.add"(%2894, %2884) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2901 = "llvm.shufflevector"(%2894, %2900) <{mask = array<i32: 0, 9, 2, 3, 4, 13, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2902 = "llvm.add"(%2897, %2887) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2903 = "llvm.shufflevector"(%2897, %2902) <{mask = array<i32: 0, 9, 2, 3, 4, 13, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2904 = "llvm.add"(%2899, %2831) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2905 = "llvm.add"(%2901, %2830) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2906 = "llvm.add"(%2903, %2830) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2907 = "llvm.ashr"(%2904, %2829) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2908 = "llvm.ashr"(%2905, %2829) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2909 = "llvm.ashr"(%2906, %2828) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2910 = "llvm.mul"(%2909, %2877) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2911 = "llvm.and"(%2904, %2826) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2912 = "llvm.shufflevector"(%2910, %2909) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2913 = "llvm.add"(%2911, %2825) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2914 = "llvm.add"(%2913, %2912) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2915 = "llvm.and"(%2905, %2826) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2916 = "llvm.add"(%2907, %2824) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2917 = "llvm.add"(%2916, %2915) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2918 = "llvm.and"(%2906, %2823) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2919 = "llvm.add"(%2908, %2824) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2920 = "llvm.add"(%2919, %2918) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.intr.lifetime.start"(%2878) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2879) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2880) : (!llvm.ptr) -> ()
  "llvm.call"(%2878, %2879, %2880, %2914, %2917, %2920, %2822, %2821, %2820) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_quad_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 9, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
  %2921 = "llvm.load"(%2878) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2922 = "llvm.load"(%2879) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2923 = "llvm.load"(%2880) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.intr.lifetime.end"(%2880) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2879) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2878) : (!llvm.ptr) -> ()
  %2924 = "llvm.lshr"(%2921, %2829) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2925 = "llvm.lshr"(%2922, %2829) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2926 = "llvm.lshr"(%2923, %2828) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2927 = "llvm.mul"(%2926, %2877) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2928 = "llvm.and"(%2921, %2826) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2929 = "llvm.shufflevector"(%2927, %2926) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2930 = "llvm.add"(%2929, %2928) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%2930, %arg122) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2931 = "llvm.and"(%2922, %2826) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2932 = "llvm.add"(%2931, %2924) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%2932, %2883) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2933 = "llvm.and"(%2923, %2823) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2934 = "llvm.add"(%2933, %2925) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%2934, %2886) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
  with @fd_r43x6_quad_mul_fast := fd_r43x6_quad_mul_fast

end

end MLIR.Firedancer.Avx512
