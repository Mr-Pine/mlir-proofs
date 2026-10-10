module

-- sodium-build/out/op/fe25519_sq.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Sodium

@[expose] public section

mlir_def fe25519_sq :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "ssp", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], sym_name = "fe25519_sq", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg99: !llvm.ptr, %arg100: !llvm.ptr):
  %3026 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %3027 = "llvm.mlir.constant"() <{value = 38 : i64}> : () -> i64
  %3028 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %3029 = "llvm.mlir.constant"() <{value = 2251799813685247 : i64}> : () -> i64
  %3030 = "llvm.mlir.constant"() <{value = 51 : i128}> : () -> i128
  %3031 = "llvm.mlir.constant"() <{value = 51 : i64}> : () -> i64
  %3032 = "llvm.load"(%arg100) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3033 = "llvm.getelementptr"(%arg100) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %3034 = "llvm.load"(%3033) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3035 = "llvm.getelementptr"(%arg100) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %3036 = "llvm.load"(%3035) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3037 = "llvm.getelementptr"(%arg100) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %3038 = "llvm.load"(%3037) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3039 = "llvm.getelementptr"(%arg100) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %3040 = "llvm.load"(%3039) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3041 = "llvm.shl"(%3032, %3026) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %3042 = "llvm.shl"(%3034, %3026) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %3043 = "llvm.mul"(%3034, %3027) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %3044 = "llvm.mul"(%3036, %3027) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %3045 = "llvm.mul"(%3038, %3027) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %3046 = "llvm.mul"(%3038, %3028) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %3047 = "llvm.mul"(%3040, %3028) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %3048 = "llvm.zext"(%3032) : (i64) -> i128
  %3049 = "llvm.mul"(%3048, %3048) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %3050 = "llvm.zext"(%3043) : (i64) -> i128
  %3051 = "llvm.zext"(%3040) : (i64) -> i128
  %3052 = "llvm.mul"(%3051, %3050) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %3053 = "llvm.zext"(%3044) : (i64) -> i128
  %3054 = "llvm.zext"(%3038) : (i64) -> i128
  %3055 = "llvm.mul"(%3053, %3054) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %3056 = "llvm.add"(%3055, %3049) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3057 = "llvm.add"(%3056, %3052) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3058 = "llvm.zext"(%3041) : (i64) -> i128
  %3059 = "llvm.zext"(%3034) : (i64) -> i128
  %3060 = "llvm.mul"(%3058, %3059) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %3061 = "llvm.mul"(%3051, %3053) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %3062 = "llvm.add"(%3061, %3060) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3063 = "llvm.zext"(%3046) : (i64) -> i128
  %3064 = "llvm.mul"(%3063, %3054) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %3065 = "llvm.add"(%3062, %3064) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3066 = "llvm.zext"(%3036) : (i64) -> i128
  %3067 = "llvm.mul"(%3066, %3058) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %3068 = "llvm.mul"(%3059, %3059) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %3069 = "llvm.add"(%3067, %3068) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3070 = "llvm.zext"(%3045) : (i64) -> i128
  %3071 = "llvm.mul"(%3070, %3051) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %3072 = "llvm.add"(%3069, %3071) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3073 = "llvm.mul"(%3054, %3058) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %3074 = "llvm.zext"(%3042) : (i64) -> i128
  %3075 = "llvm.mul"(%3074, %3066) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %3076 = "llvm.add"(%3073, %3075) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3077 = "llvm.zext"(%3047) : (i64) -> i128
  %3078 = "llvm.mul"(%3077, %3051) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %3079 = "llvm.add"(%3076, %3078) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3080 = "llvm.mul"(%3051, %3058) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %3081 = "llvm.mul"(%3054, %3074) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %3082 = "llvm.mul"(%3066, %3066) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %3083 = "llvm.trunc"(%3057) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %3084 = "llvm.and"(%3083, %3029) : (i64, i64) -> i64
  %3085 = "llvm.lshr"(%3057, %3030) : (i128, i128) -> i128
  %3086 = "llvm.add"(%3065, %3085) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3087 = "llvm.trunc"(%3086) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %3088 = "llvm.and"(%3087, %3029) : (i64, i64) -> i64
  %3089 = "llvm.lshr"(%3086, %3030) : (i128, i128) -> i128
  %3090 = "llvm.add"(%3072, %3089) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3091 = "llvm.trunc"(%3090) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %3092 = "llvm.and"(%3091, %3029) : (i64, i64) -> i64
  %3093 = "llvm.lshr"(%3090, %3030) : (i128, i128) -> i128
  %3094 = "llvm.add"(%3079, %3093) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3095 = "llvm.trunc"(%3094) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %3096 = "llvm.and"(%3095, %3029) : (i64, i64) -> i64
  %3097 = "llvm.lshr"(%3094, %3030) : (i128, i128) -> i128
  %3098 = "llvm.add"(%3081, %3082) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3099 = "llvm.add"(%3098, %3080) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3100 = "llvm.add"(%3099, %3097) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3101 = "llvm.trunc"(%3100) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %3102 = "llvm.and"(%3101, %3029) : (i64, i64) -> i64
  %3103 = "llvm.lshr"(%3100, %3030) : (i128, i128) -> i128
  %3104 = "llvm.trunc"(%3103) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %3105 = "llvm.mul"(%3104, %3028) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %3106 = "llvm.add"(%3105, %3084) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %3107 = "llvm.lshr"(%3106, %3031) : (i64, i64) -> i64
  %3108 = "llvm.and"(%3106, %3029) : (i64, i64) -> i64
  %3109 = "llvm.add"(%3107, %3088) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %3110 = "llvm.lshr"(%3109, %3031) : (i64, i64) -> i64
  %3111 = "llvm.and"(%3109, %3029) : (i64, i64) -> i64
  %3112 = "llvm.add"(%3110, %3092) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  "llvm.store"(%3108, %arg99) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %3113 = "llvm.getelementptr"(%arg99) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3111, %3113) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %3114 = "llvm.getelementptr"(%arg99) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3112, %3114) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %3115 = "llvm.getelementptr"(%arg99) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3096, %3115) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %3116 = "llvm.getelementptr"(%arg99) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3102, %3116) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end MLIR.Sodium
