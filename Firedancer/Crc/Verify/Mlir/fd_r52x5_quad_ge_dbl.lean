module

-- crc/out/mlirproofs/regions/verify/fd_r52x5_quad_ge_dbl.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_add_nc
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_mul
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_negate_lazy
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_reduce
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_sqr
public import Firedancer.Crc.Verify.Mlir.wl_permute

meta import MLIR.Semantics.Func
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_add_nc
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_mul
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_negate_lazy
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_reduce
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_sqr
meta import Firedancer.Crc.Verify.Mlir.wl_permute

namespace MLIR.Firedancer.Crc.Verify

@[expose] public section

mlir_def fd_r52x5_quad_ge_dbl :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr, ptr, ptr, ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "256"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], sym_name = "fd_r52x5_quad_ge_dbl", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg201: !llvm.ptr, %arg202: !llvm.ptr, %arg203: !llvm.ptr, %arg204: !llvm.ptr, %arg205: !llvm.ptr, %arg206: vector<4xi64>, %arg207: vector<4xi64>, %arg208: vector<4xi64>, %arg209: vector<4xi64>, %arg210: vector<4xi64>):
  %2861 = "llvm.mlir.undef"() : () -> vector<4xi64>
  %2862 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %2863 = "llvm.mlir.poison"() : () -> i64
  %2864 = "llvm.mlir.constant"() <{value = 31 : i32}> : () -> i32
  %2865 = "llvm.mlir.constant"() <{value = 30 : i32}> : () -> i32
  %2866 = "llvm.mlir.constant"() <{value = 29 : i32}> : () -> i32
  %2867 = "llvm.mlir.constant"() <{value = 28 : i32}> : () -> i32
  %2868 = "llvm.mlir.constant"() <{value = 27 : i32}> : () -> i32
  %2869 = "llvm.mlir.constant"() <{value = 26 : i32}> : () -> i32
  %2870 = "llvm.mlir.constant"() <{value = 25 : i32}> : () -> i32
  %2871 = "llvm.mlir.constant"() <{value = 24 : i32}> : () -> i32
  %2872 = "llvm.mlir.constant"() <{value = 23 : i32}> : () -> i32
  %2873 = "llvm.mlir.constant"() <{value = 22 : i32}> : () -> i32
  %2874 = "llvm.mlir.constant"() <{value = 21 : i32}> : () -> i32
  %2875 = "llvm.mlir.constant"() <{value = 20 : i32}> : () -> i32
  %2876 = "llvm.mlir.constant"() <{value = 19 : i32}> : () -> i32
  %2877 = "llvm.mlir.constant"() <{value = 18 : i32}> : () -> i32
  %2878 = "llvm.mlir.constant"() <{value = 17 : i32}> : () -> i32
  %2879 = "llvm.mlir.constant"() <{value = 16 : i32}> : () -> i32
  %2880 = "llvm.mlir.constant"() <{value = 15 : i32}> : () -> i32
  %2881 = "llvm.mlir.constant"() <{value = 14 : i32}> : () -> i32
  %2882 = "llvm.mlir.constant"() <{value = 13 : i32}> : () -> i32
  %2883 = "llvm.mlir.constant"() <{value = 12 : i32}> : () -> i32
  %2884 = "llvm.mlir.constant"() <{value = 11 : i32}> : () -> i32
  %2885 = "llvm.mlir.constant"() <{value = 10 : i32}> : () -> i32
  %2886 = "llvm.mlir.constant"() <{value = 9 : i32}> : () -> i32
  %2887 = "llvm.mlir.constant"() <{value = 8 : i32}> : () -> i32
  %2888 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %2889 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %2890 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %2891 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %2892 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %2893 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %2894 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %2895 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %2896 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %2897 = "llvm.mlir.poison"() : () -> i8
  %2898 = "llvm.mlir.undef"() : () -> vector<32xi8>
  %2899 = "llvm.insertelement"(%2898, %2896, %2893) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2900 = "llvm.insertelement"(%2899, %2896, %2892) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2901 = "llvm.insertelement"(%2900, %2896, %2895) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2902 = "llvm.insertelement"(%2901, %2896, %2894) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2903 = "llvm.insertelement"(%2902, %2896, %2891) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2904 = "llvm.insertelement"(%2903, %2896, %2890) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2905 = "llvm.insertelement"(%2904, %2896, %2889) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2906 = "llvm.insertelement"(%2905, %2896, %2888) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2907 = "llvm.insertelement"(%2906, %2896, %2887) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2908 = "llvm.insertelement"(%2907, %2896, %2886) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2909 = "llvm.insertelement"(%2908, %2896, %2885) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2910 = "llvm.insertelement"(%2909, %2896, %2884) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2911 = "llvm.insertelement"(%2910, %2896, %2883) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2912 = "llvm.insertelement"(%2911, %2896, %2882) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2913 = "llvm.insertelement"(%2912, %2896, %2881) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2914 = "llvm.insertelement"(%2913, %2896, %2880) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2915 = "llvm.insertelement"(%2914, %2897, %2879) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2916 = "llvm.insertelement"(%2915, %2897, %2878) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2917 = "llvm.insertelement"(%2916, %2897, %2877) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2918 = "llvm.insertelement"(%2917, %2897, %2876) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2919 = "llvm.insertelement"(%2918, %2897, %2875) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2920 = "llvm.insertelement"(%2919, %2897, %2874) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2921 = "llvm.insertelement"(%2920, %2897, %2873) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2922 = "llvm.insertelement"(%2921, %2897, %2872) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2923 = "llvm.insertelement"(%2922, %2896, %2871) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2924 = "llvm.insertelement"(%2923, %2896, %2870) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2925 = "llvm.insertelement"(%2924, %2896, %2869) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2926 = "llvm.insertelement"(%2925, %2896, %2868) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2927 = "llvm.insertelement"(%2926, %2896, %2867) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2928 = "llvm.insertelement"(%2927, %2896, %2866) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2929 = "llvm.insertelement"(%2928, %2896, %2865) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2930 = "llvm.insertelement"(%2929, %2896, %2864) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2931 = "llvm.insertelement"(%2861, %2863, %2893) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %2932 = "llvm.insertelement"(%2931, %2862, %2892) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %2933 = "llvm.insertelement"(%2932, %2862, %2895) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %2934 = "llvm.insertelement"(%2933, %2863, %2894) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %2935 = "llvm.insertelement"(%2898, %2896, %2893) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2936 = "llvm.insertelement"(%2935, %2896, %2892) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2937 = "llvm.insertelement"(%2936, %2896, %2895) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2938 = "llvm.insertelement"(%2937, %2896, %2894) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2939 = "llvm.insertelement"(%2938, %2896, %2891) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2940 = "llvm.insertelement"(%2939, %2896, %2890) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2941 = "llvm.insertelement"(%2940, %2896, %2889) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2942 = "llvm.insertelement"(%2941, %2896, %2888) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2943 = "llvm.insertelement"(%2942, %2897, %2887) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2944 = "llvm.insertelement"(%2943, %2897, %2886) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2945 = "llvm.insertelement"(%2944, %2897, %2885) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2946 = "llvm.insertelement"(%2945, %2897, %2884) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2947 = "llvm.insertelement"(%2946, %2897, %2883) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2948 = "llvm.insertelement"(%2947, %2897, %2882) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2949 = "llvm.insertelement"(%2948, %2897, %2881) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2950 = "llvm.insertelement"(%2949, %2897, %2880) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2951 = "llvm.insertelement"(%2950, %2897, %2879) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2952 = "llvm.insertelement"(%2951, %2897, %2878) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2953 = "llvm.insertelement"(%2952, %2897, %2877) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2954 = "llvm.insertelement"(%2953, %2897, %2876) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2955 = "llvm.insertelement"(%2954, %2897, %2875) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2956 = "llvm.insertelement"(%2955, %2897, %2874) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2957 = "llvm.insertelement"(%2956, %2897, %2873) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2958 = "llvm.insertelement"(%2957, %2897, %2872) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2959 = "llvm.insertelement"(%2958, %2897, %2871) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2960 = "llvm.insertelement"(%2959, %2897, %2870) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2961 = "llvm.insertelement"(%2960, %2897, %2869) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2962 = "llvm.insertelement"(%2961, %2897, %2868) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2963 = "llvm.insertelement"(%2962, %2897, %2867) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2964 = "llvm.insertelement"(%2963, %2897, %2866) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2965 = "llvm.insertelement"(%2964, %2897, %2865) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2966 = "llvm.insertelement"(%2965, %2897, %2864) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %2967 = "llvm.alloca"(%2892) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2968 = "llvm.alloca"(%2892) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2969 = "llvm.alloca"(%2892) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2970 = "llvm.alloca"(%2892) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2971 = "llvm.alloca"(%2892) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2972 = "llvm.alloca"(%2892) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2973 = "llvm.alloca"(%2892) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2974 = "llvm.alloca"(%2892) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2975 = "llvm.alloca"(%2892) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2976 = "llvm.alloca"(%2892) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2977 = "llvm.alloca"(%2892) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2978 = "llvm.alloca"(%2892) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2979 = "llvm.alloca"(%2892) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2980 = "llvm.alloca"(%2892) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2981 = "llvm.alloca"(%2892) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2982 = "llvm.alloca"(%2892) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2983 = "llvm.alloca"(%2892) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2984 = "llvm.alloca"(%2892) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2985 = "llvm.alloca"(%2892) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2986 = "llvm.alloca"(%2892) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2987 = "llvm.alloca"(%2892) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2988 = "llvm.alloca"(%2892) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2989 = "llvm.alloca"(%2892) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2990 = "llvm.alloca"(%2892) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2991 = "llvm.alloca"(%2892) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2992 = "llvm.alloca"(%2892) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2993 = "llvm.alloca"(%2892) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2994 = "llvm.alloca"(%2892) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2995 = "llvm.alloca"(%2892) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2996 = "llvm.alloca"(%2892) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2997 = "llvm.alloca"(%2892) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2998 = "llvm.alloca"(%2892) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2999 = "llvm.alloca"(%2892) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3000 = "llvm.alloca"(%2892) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3001 = "llvm.alloca"(%2892) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3002 = "llvm.alloca"(%2892) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3003 = "llvm.alloca"(%2892) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3004 = "llvm.alloca"(%2892) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3005 = "llvm.alloca"(%2892) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3006 = "llvm.alloca"(%2892) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3007 = "llvm.alloca"(%2892) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3008 = "llvm.alloca"(%2892) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3009 = "llvm.alloca"(%2892) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3010 = "llvm.alloca"(%2892) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3011 = "llvm.alloca"(%2892) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3012 = "llvm.alloca"(%2892) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3013 = "llvm.alloca"(%2892) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3014 = "llvm.alloca"(%2892) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3015 = "llvm.alloca"(%2892) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3016 = "llvm.alloca"(%2892) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3017 = "llvm.call"(%arg206, %2892, %2893, %2894, %2895) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3018 = "llvm.call"(%arg207, %2892, %2893, %2894, %2895) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3019 = "llvm.call"(%arg208, %2892, %2893, %2894, %2895) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3020 = "llvm.call"(%arg209, %2892, %2893, %2894, %2895) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3021 = "llvm.call"(%arg210, %2892, %2893, %2894, %2895) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%2967) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2968) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2969) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2970) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2971) : (!llvm.ptr) -> ()
  "llvm.call"(%2967, %2968, %2969, %2970, %2971, %3017, %3018, %3019, %3020, %3021, %arg206, %arg207, %arg208, %arg209, %arg210) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_add_nc, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %3022 = "llvm.load"(%2967) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3023 = "llvm.load"(%2968) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3024 = "llvm.load"(%2969) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3025 = "llvm.load"(%2970) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3026 = "llvm.load"(%2971) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2971) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2970) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2969) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2968) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2967) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2972) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2973) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2974) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2975) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2976) : (!llvm.ptr) -> ()
  "llvm.call"(%2972, %2973, %2974, %2975, %2976, %3022, %3023, %3024, %3025, %3026) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_reduce, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %3027 = "llvm.load"(%2972) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3028 = "llvm.load"(%2973) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3029 = "llvm.load"(%2974) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3030 = "llvm.load"(%2975) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3031 = "llvm.load"(%2976) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2976) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2975) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2974) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2973) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2972) : (!llvm.ptr) -> ()
  %3032 = "llvm.call"(%3027, %2893, %2892, %2893, %2892) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3033 = "llvm.call"(%3028, %2893, %2892, %2893, %2892) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3034 = "llvm.call"(%3029, %2893, %2892, %2893, %2892) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3035 = "llvm.call"(%3030, %2893, %2892, %2893, %2892) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3036 = "llvm.call"(%3031, %2893, %2892, %2893, %2892) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3037 = "llvm.shufflevector"(%arg206, %3032) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3038 = "llvm.shufflevector"(%arg207, %3033) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3039 = "llvm.shufflevector"(%arg208, %3034) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3040 = "llvm.shufflevector"(%arg209, %3035) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3041 = "llvm.shufflevector"(%arg210, %3036) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%2977) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2978) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2979) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2980) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2981) : (!llvm.ptr) -> ()
  "llvm.call"(%2977, %2978, %2979, %2980, %2981, %3037, %3038, %3039, %3040, %3041) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %3042 = "llvm.load"(%2977) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3043 = "llvm.load"(%2978) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3044 = "llvm.load"(%2979) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3045 = "llvm.load"(%2980) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3046 = "llvm.load"(%2981) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2981) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2980) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2979) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2978) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2977) : (!llvm.ptr) -> ()
  %3047 = "llvm.call"(%3042, %2893, %2893, %2893, %2893) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3048 = "llvm.call"(%3043, %2893, %2893, %2893, %2893) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3049 = "llvm.call"(%3044, %2893, %2893, %2893, %2893) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3050 = "llvm.call"(%3045, %2893, %2893, %2893, %2893) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3051 = "llvm.call"(%3046, %2893, %2893, %2893, %2893) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3052 = "llvm.call"(%3042, %2892, %2892, %2892, %2892) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3053 = "llvm.call"(%3043, %2892, %2892, %2892, %2892) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3054 = "llvm.call"(%3044, %2892, %2892, %2892, %2892) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3055 = "llvm.call"(%3045, %2892, %2892, %2892, %2892) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3056 = "llvm.call"(%3046, %2892, %2892, %2892, %2892) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3057 = "llvm.shufflevector"(%3052, %3042) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3058 = "llvm.shufflevector"(%3053, %3043) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3059 = "llvm.shufflevector"(%3054, %3044) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3060 = "llvm.shufflevector"(%3055, %3045) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3061 = "llvm.shufflevector"(%3056, %3046) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%2982) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2983) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2984) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2985) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2986) : (!llvm.ptr) -> ()
  "llvm.call"(%2982, %2983, %2984, %2985, %2986, %3057, %3058, %3059, %3060, %3061) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_negate_lazy, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %3062 = "llvm.load"(%2982) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<32xi8>
  %3063 = "llvm.load"(%2983) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<32xi8>
  %3064 = "llvm.load"(%2984) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<32xi8>
  %3065 = "llvm.load"(%2985) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<32xi8>
  %3066 = "llvm.load"(%2986) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<32xi8>
  "llvm.intr.lifetime.end"(%2986) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2985) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2984) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2983) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2982) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2987) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2988) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2989) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2990) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2991) : (!llvm.ptr) -> ()
  "llvm.call"(%2987, %2988, %2989, %2990, %2991, %3042, %3043, %3044, %3045, %3046, %3042, %3043, %3044, %3045, %3046) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_add_nc, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %3067 = "llvm.load"(%2987) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<32xi8>
  %3068 = "llvm.load"(%2988) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<32xi8>
  %3069 = "llvm.load"(%2989) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<32xi8>
  %3070 = "llvm.load"(%2990) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<32xi8>
  %3071 = "llvm.load"(%2991) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<32xi8>
  "llvm.intr.lifetime.end"(%2991) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2990) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2989) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2988) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2987) : (!llvm.ptr) -> ()
  %3072 = "llvm.shufflevector"(%2930, %3067) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 48, 49, 50, 51, 52, 53, 54, 55, 24, 25, 26, 27, 28, 29, 30, 31>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3073 = "llvm.bitcast"(%3072) : (vector<32xi8>) -> vector<4xi64>
  %3074 = "llvm.shufflevector"(%2930, %3068) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 48, 49, 50, 51, 52, 53, 54, 55, 24, 25, 26, 27, 28, 29, 30, 31>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3075 = "llvm.bitcast"(%3074) : (vector<32xi8>) -> vector<4xi64>
  %3076 = "llvm.shufflevector"(%2930, %3069) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 48, 49, 50, 51, 52, 53, 54, 55, 24, 25, 26, 27, 28, 29, 30, 31>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3077 = "llvm.bitcast"(%3076) : (vector<32xi8>) -> vector<4xi64>
  %3078 = "llvm.shufflevector"(%2930, %3070) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 48, 49, 50, 51, 52, 53, 54, 55, 24, 25, 26, 27, 28, 29, 30, 31>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3079 = "llvm.bitcast"(%3078) : (vector<32xi8>) -> vector<4xi64>
  %3080 = "llvm.shufflevector"(%2930, %3071) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 48, 49, 50, 51, 52, 53, 54, 55, 24, 25, 26, 27, 28, 29, 30, 31>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3081 = "llvm.bitcast"(%3080) : (vector<32xi8>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%2992) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2993) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2994) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2995) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2996) : (!llvm.ptr) -> ()
  "llvm.call"(%2992, %2993, %2994, %2995, %2996, %3047, %3048, %3049, %3050, %3051, %3073, %3075, %3077, %3079, %3081) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_add_nc, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %3082 = "llvm.load"(%2992) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3083 = "llvm.load"(%2993) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3084 = "llvm.load"(%2994) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3085 = "llvm.load"(%2995) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3086 = "llvm.load"(%2996) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2996) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2995) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2994) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2993) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2992) : (!llvm.ptr) -> ()
  %3087 = "llvm.shufflevector"(%3052, %2934) <{mask = array<i32: 0, 5, 6, 3>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3088 = "llvm.shufflevector"(%3053, %2934) <{mask = array<i32: 0, 5, 6, 3>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3089 = "llvm.shufflevector"(%3054, %2934) <{mask = array<i32: 0, 5, 6, 3>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3090 = "llvm.shufflevector"(%3055, %2934) <{mask = array<i32: 0, 5, 6, 3>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3091 = "llvm.shufflevector"(%3056, %2934) <{mask = array<i32: 0, 5, 6, 3>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%2997) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2998) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2999) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3000) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3001) : (!llvm.ptr) -> ()
  "llvm.call"(%2997, %2998, %2999, %3000, %3001, %3082, %3083, %3084, %3085, %3086, %3087, %3088, %3089, %3090, %3091) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_add_nc, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %3092 = "llvm.load"(%2997) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3093 = "llvm.load"(%2998) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3094 = "llvm.load"(%2999) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3095 = "llvm.load"(%3000) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3096 = "llvm.load"(%3001) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%3001) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3000) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2999) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2998) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2997) : (!llvm.ptr) -> ()
  %3097 = "llvm.shufflevector"(%2966, %3062) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3098 = "llvm.bitcast"(%3097) : (vector<32xi8>) -> vector<4xi64>
  %3099 = "llvm.shufflevector"(%2966, %3063) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3100 = "llvm.bitcast"(%3099) : (vector<32xi8>) -> vector<4xi64>
  %3101 = "llvm.shufflevector"(%2966, %3064) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3102 = "llvm.bitcast"(%3101) : (vector<32xi8>) -> vector<4xi64>
  %3103 = "llvm.shufflevector"(%2966, %3065) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3104 = "llvm.bitcast"(%3103) : (vector<32xi8>) -> vector<4xi64>
  %3105 = "llvm.shufflevector"(%2966, %3066) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3106 = "llvm.bitcast"(%3105) : (vector<32xi8>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%3002) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3003) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3004) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3005) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3006) : (!llvm.ptr) -> ()
  "llvm.call"(%3002, %3003, %3004, %3005, %3006, %3092, %3093, %3094, %3095, %3096, %3098, %3100, %3102, %3104, %3106) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_add_nc, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %3107 = "llvm.load"(%3002) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3108 = "llvm.load"(%3003) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3109 = "llvm.load"(%3004) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3110 = "llvm.load"(%3005) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3111 = "llvm.load"(%3006) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%3006) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3005) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3004) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3003) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3002) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3007) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3008) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3009) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3010) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3011) : (!llvm.ptr) -> ()
  "llvm.call"(%3007, %3008, %3009, %3010, %3011, %3107, %3108, %3109, %3110, %3111) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_reduce, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %3112 = "llvm.load"(%3007) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3113 = "llvm.load"(%3008) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3114 = "llvm.load"(%3009) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3115 = "llvm.load"(%3010) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3116 = "llvm.load"(%3011) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%3011) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3010) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3009) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3008) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3007) : (!llvm.ptr) -> ()
  %3117 = "llvm.call"(%3112, %2894, %2892, %2892, %2894) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3118 = "llvm.call"(%3113, %2894, %2892, %2892, %2894) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3119 = "llvm.call"(%3114, %2894, %2892, %2892, %2894) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3120 = "llvm.call"(%3115, %2894, %2892, %2892, %2894) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3121 = "llvm.call"(%3116, %2894, %2892, %2892, %2894) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3122 = "llvm.call"(%3112, %2895, %2893, %2895, %2893) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3123 = "llvm.call"(%3113, %2895, %2893, %2895, %2893) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3124 = "llvm.call"(%3114, %2895, %2893, %2895, %2893) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3125 = "llvm.call"(%3115, %2895, %2893, %2895, %2893) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3126 = "llvm.call"(%3116, %2895, %2893, %2895, %2893) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%3012) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3013) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3014) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3015) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3016) : (!llvm.ptr) -> ()
  "llvm.call"(%3012, %3013, %3014, %3015, %3016, %3117, %3118, %3119, %3120, %3121, %3122, %3123, %3124, %3125, %3126) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %3127 = "llvm.load"(%3012) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3128 = "llvm.load"(%3013) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3129 = "llvm.load"(%3014) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3130 = "llvm.load"(%3015) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3131 = "llvm.load"(%3016) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%3016) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3015) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3014) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3013) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3012) : (!llvm.ptr) -> ()
  "llvm.store"(%3127, %arg201) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.store"(%3128, %arg202) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.store"(%3129, %arg203) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.store"(%3130, %arg204) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.store"(%3131, %arg205) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
  with @fd_r52x5_quad_add_nc := fd_r52x5_quad_add_nc, @fd_r52x5_quad_mul := fd_r52x5_quad_mul,
    @fd_r52x5_quad_negate_lazy := fd_r52x5_quad_negate_lazy,
    @fd_r52x5_quad_reduce := fd_r52x5_quad_reduce, @fd_r52x5_quad_sqr := fd_r52x5_quad_sqr,
    @wl_permute := wl_permute

end

end MLIR.Firedancer.Crc.Verify
