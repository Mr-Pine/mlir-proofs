module

-- sodium-build/out/op/fe25519_mul.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Sodium

@[expose] public section

mlir_def fe25519_mul :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "ssp", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], sym_name = "fe25519_mul", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg96: !llvm.ptr, %arg97: !llvm.ptr, %arg98: !llvm.ptr):
  %2909 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %2910 = "llvm.mlir.constant"() <{value = 2251799813685247 : i64}> : () -> i64
  %2911 = "llvm.mlir.constant"() <{value = 51 : i128}> : () -> i128
  %2912 = "llvm.mlir.constant"() <{value = 51 : i64}> : () -> i64
  %2913 = "llvm.load"(%arg97) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2914 = "llvm.getelementptr"(%arg97) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %2915 = "llvm.load"(%2914) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2916 = "llvm.getelementptr"(%arg97) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %2917 = "llvm.load"(%2916) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2918 = "llvm.getelementptr"(%arg97) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %2919 = "llvm.load"(%2918) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2920 = "llvm.getelementptr"(%arg97) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %2921 = "llvm.load"(%2920) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2922 = "llvm.load"(%arg98) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2923 = "llvm.getelementptr"(%arg98) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %2924 = "llvm.load"(%2923) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2925 = "llvm.getelementptr"(%arg98) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %2926 = "llvm.load"(%2925) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2927 = "llvm.getelementptr"(%arg98) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %2928 = "llvm.load"(%2927) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2929 = "llvm.getelementptr"(%arg98) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %2930 = "llvm.load"(%2929) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2931 = "llvm.mul"(%2915, %2909) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2932 = "llvm.mul"(%2917, %2909) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2933 = "llvm.mul"(%2919, %2909) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2934 = "llvm.mul"(%2921, %2909) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2935 = "llvm.zext"(%2913) : (i64) -> i128
  %2936 = "llvm.zext"(%2922) : (i64) -> i128
  %2937 = "llvm.mul"(%2936, %2935) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2938 = "llvm.zext"(%2931) : (i64) -> i128
  %2939 = "llvm.zext"(%2930) : (i64) -> i128
  %2940 = "llvm.mul"(%2939, %2938) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2941 = "llvm.zext"(%2932) : (i64) -> i128
  %2942 = "llvm.zext"(%2928) : (i64) -> i128
  %2943 = "llvm.mul"(%2942, %2941) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2944 = "llvm.zext"(%2933) : (i64) -> i128
  %2945 = "llvm.zext"(%2926) : (i64) -> i128
  %2946 = "llvm.mul"(%2945, %2944) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2947 = "llvm.zext"(%2934) : (i64) -> i128
  %2948 = "llvm.zext"(%2924) : (i64) -> i128
  %2949 = "llvm.mul"(%2948, %2947) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2950 = "llvm.add"(%2949, %2937) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2951 = "llvm.add"(%2950, %2946) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2952 = "llvm.add"(%2951, %2943) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2953 = "llvm.add"(%2952, %2940) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2954 = "llvm.mul"(%2948, %2935) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2955 = "llvm.zext"(%2915) : (i64) -> i128
  %2956 = "llvm.mul"(%2936, %2955) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2957 = "llvm.add"(%2954, %2956) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2958 = "llvm.mul"(%2939, %2941) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2959 = "llvm.mul"(%2942, %2944) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2960 = "llvm.mul"(%2945, %2947) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2961 = "llvm.mul"(%2945, %2935) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2962 = "llvm.mul"(%2948, %2955) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2963 = "llvm.zext"(%2917) : (i64) -> i128
  %2964 = "llvm.mul"(%2936, %2963) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2965 = "llvm.mul"(%2939, %2944) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2966 = "llvm.mul"(%2942, %2947) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2967 = "llvm.mul"(%2942, %2935) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2968 = "llvm.mul"(%2945, %2955) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2969 = "llvm.mul"(%2948, %2963) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2970 = "llvm.zext"(%2919) : (i64) -> i128
  %2971 = "llvm.mul"(%2936, %2970) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2972 = "llvm.mul"(%2939, %2947) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2973 = "llvm.mul"(%2939, %2935) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2974 = "llvm.mul"(%2942, %2955) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2975 = "llvm.mul"(%2945, %2963) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2976 = "llvm.mul"(%2948, %2970) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2977 = "llvm.zext"(%2921) : (i64) -> i128
  %2978 = "llvm.mul"(%2936, %2977) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2979 = "llvm.trunc"(%2953) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %2980 = "llvm.and"(%2979, %2910) : (i64, i64) -> i64
  %2981 = "llvm.lshr"(%2953, %2911) : (i128, i128) -> i128
  %2982 = "llvm.add"(%2957, %2960) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2983 = "llvm.add"(%2982, %2959) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2984 = "llvm.add"(%2983, %2958) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2985 = "llvm.add"(%2984, %2981) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2986 = "llvm.trunc"(%2985) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %2987 = "llvm.and"(%2986, %2910) : (i64, i64) -> i64
  %2988 = "llvm.lshr"(%2985, %2911) : (i128, i128) -> i128
  %2989 = "llvm.add"(%2962, %2964) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2990 = "llvm.add"(%2989, %2961) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2991 = "llvm.add"(%2990, %2966) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2992 = "llvm.add"(%2991, %2965) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2993 = "llvm.add"(%2992, %2988) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2994 = "llvm.trunc"(%2993) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %2995 = "llvm.and"(%2994, %2910) : (i64, i64) -> i64
  %2996 = "llvm.lshr"(%2993, %2911) : (i128, i128) -> i128
  %2997 = "llvm.add"(%2969, %2971) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2998 = "llvm.add"(%2997, %2968) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2999 = "llvm.add"(%2998, %2967) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3000 = "llvm.add"(%2999, %2972) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3001 = "llvm.add"(%3000, %2996) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3002 = "llvm.trunc"(%3001) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %3003 = "llvm.and"(%3002, %2910) : (i64, i64) -> i64
  %3004 = "llvm.lshr"(%3001, %2911) : (i128, i128) -> i128
  %3005 = "llvm.add"(%2976, %2978) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3006 = "llvm.add"(%3005, %2975) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3007 = "llvm.add"(%3006, %2974) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3008 = "llvm.add"(%3007, %2973) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3009 = "llvm.add"(%3008, %3004) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3010 = "llvm.trunc"(%3009) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %3011 = "llvm.and"(%3010, %2910) : (i64, i64) -> i64
  %3012 = "llvm.lshr"(%3009, %2911) : (i128, i128) -> i128
  %3013 = "llvm.trunc"(%3012) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %3014 = "llvm.mul"(%3013, %2909) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %3015 = "llvm.add"(%3014, %2980) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %3016 = "llvm.lshr"(%3015, %2912) : (i64, i64) -> i64
  %3017 = "llvm.and"(%3015, %2910) : (i64, i64) -> i64
  %3018 = "llvm.add"(%3016, %2987) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %3019 = "llvm.lshr"(%3018, %2912) : (i64, i64) -> i64
  %3020 = "llvm.and"(%3018, %2910) : (i64, i64) -> i64
  %3021 = "llvm.add"(%3019, %2995) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  "llvm.store"(%3017, %arg96) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %3022 = "llvm.getelementptr"(%arg96) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3020, %3022) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %3023 = "llvm.getelementptr"(%arg96) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3021, %3023) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %3024 = "llvm.getelementptr"(%arg96) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3003, %3024) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %3025 = "llvm.getelementptr"(%arg96) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3011, %3025) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end MLIR.Sodium
