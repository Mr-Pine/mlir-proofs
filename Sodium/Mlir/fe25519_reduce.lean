module

-- sodium-build/out/op/fe25519_reduce.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Sodium

@[expose] public section

mlir_def fe25519_reduce :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "ssp", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], sym_name = "fe25519_reduce", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg105: !llvm.ptr, %arg106: !llvm.ptr):
  %3126 = "llvm.mlir.constant"() <{value = 51 : i128}> : () -> i128
  %3127 = "llvm.mlir.constant"() <{value = 2251799813685247 : i128}> : () -> i128
  %3128 = "llvm.mlir.constant"() <{value = 19 : i128}> : () -> i128
  %3129 = "llvm.mlir.constant"() <{value = 2251799813685229 : i128}> : () -> i128
  %3130 = "llvm.mlir.constant"() <{value = 2251799813685247 : i64}> : () -> i64
  %3131 = "llvm.load"(%arg106) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3132 = "llvm.zext"(%3131) : (i64) -> i128
  %3133 = "llvm.getelementptr"(%arg106) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %3134 = "llvm.load"(%3133) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3135 = "llvm.zext"(%3134) : (i64) -> i128
  %3136 = "llvm.getelementptr"(%arg106) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %3137 = "llvm.load"(%3136) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3138 = "llvm.zext"(%3137) : (i64) -> i128
  %3139 = "llvm.getelementptr"(%arg106) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %3140 = "llvm.load"(%3139) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3141 = "llvm.zext"(%3140) : (i64) -> i128
  %3142 = "llvm.getelementptr"(%arg106) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %3143 = "llvm.load"(%3142) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3144 = "llvm.zext"(%3143) : (i64) -> i128
  %3145 = "llvm.lshr"(%3132, %3126) : (i128, i128) -> i128
  %3146 = "llvm.add"(%3145, %3135) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3147 = "llvm.and"(%3132, %3127) : (i128, i128) -> i128
  %3148 = "llvm.lshr"(%3146, %3126) : (i128, i128) -> i128
  %3149 = "llvm.add"(%3148, %3138) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3150 = "llvm.and"(%3146, %3127) : (i128, i128) -> i128
  %3151 = "llvm.lshr"(%3149, %3126) : (i128, i128) -> i128
  %3152 = "llvm.add"(%3151, %3141) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3153 = "llvm.and"(%3149, %3127) : (i128, i128) -> i128
  %3154 = "llvm.lshr"(%3152, %3126) : (i128, i128) -> i128
  %3155 = "llvm.add"(%3154, %3144) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3156 = "llvm.and"(%3152, %3127) : (i128, i128) -> i128
  %3157 = "llvm.lshr"(%3155, %3126) : (i128, i128) -> i128
  %3158 = "llvm.mul"(%3157, %3128) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3159 = "llvm.add"(%3158, %3147) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3160 = "llvm.and"(%3155, %3127) : (i128, i128) -> i128
  %3161 = "llvm.lshr"(%3159, %3126) : (i128, i128) -> i128
  %3162 = "llvm.add"(%3161, %3150) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3163 = "llvm.and"(%3159, %3127) : (i128, i128) -> i128
  %3164 = "llvm.lshr"(%3162, %3126) : (i128, i128) -> i128
  %3165 = "llvm.add"(%3164, %3153) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3166 = "llvm.and"(%3162, %3127) : (i128, i128) -> i128
  %3167 = "llvm.lshr"(%3165, %3126) : (i128, i128) -> i128
  %3168 = "llvm.add"(%3167, %3156) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3169 = "llvm.and"(%3165, %3127) : (i128, i128) -> i128
  %3170 = "llvm.lshr"(%3168, %3126) : (i128, i128) -> i128
  %3171 = "llvm.add"(%3170, %3160) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3172 = "llvm.and"(%3168, %3127) : (i128, i128) -> i128
  %3173 = "llvm.lshr"(%3171, %3126) : (i128, i128) -> i128
  %3174 = "llvm.mul"(%3173, %3128) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3175 = "llvm.and"(%3171, %3127) : (i128, i128) -> i128
  %3176 = "llvm.add"(%3163, %3128) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3177 = "llvm.add"(%3176, %3174) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3178 = "llvm.lshr"(%3177, %3126) : (i128, i128) -> i128
  %3179 = "llvm.add"(%3178, %3166) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3180 = "llvm.and"(%3177, %3127) : (i128, i128) -> i128
  %3181 = "llvm.lshr"(%3179, %3126) : (i128, i128) -> i128
  %3182 = "llvm.add"(%3181, %3169) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3183 = "llvm.and"(%3179, %3127) : (i128, i128) -> i128
  %3184 = "llvm.lshr"(%3182, %3126) : (i128, i128) -> i128
  %3185 = "llvm.add"(%3184, %3172) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3186 = "llvm.and"(%3182, %3127) : (i128, i128) -> i128
  %3187 = "llvm.lshr"(%3185, %3126) : (i128, i128) -> i128
  %3188 = "llvm.add"(%3187, %3175) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3189 = "llvm.and"(%3185, %3127) : (i128, i128) -> i128
  %3190 = "llvm.lshr"(%3188, %3126) : (i128, i128) -> i128
  %3191 = "llvm.mul"(%3190, %3128) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3192 = "llvm.add"(%3180, %3129) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3193 = "llvm.add"(%3192, %3191) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3194 = "llvm.add"(%3183, %3127) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3195 = "llvm.add"(%3186, %3127) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3196 = "llvm.add"(%3189, %3127) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3197 = "llvm.add"(%3188, %3127) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3198 = "llvm.lshr"(%3193, %3126) : (i128, i128) -> i128
  %3199 = "llvm.add"(%3194, %3198) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3200 = "llvm.lshr"(%3199, %3126) : (i128, i128) -> i128
  %3201 = "llvm.add"(%3195, %3200) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3202 = "llvm.lshr"(%3201, %3126) : (i128, i128) -> i128
  %3203 = "llvm.add"(%3196, %3202) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3204 = "llvm.lshr"(%3203, %3126) : (i128, i128) -> i128
  %3205 = "llvm.add"(%3197, %3204) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3206 = "llvm.trunc"(%3193) <{overflowFlags = 3 : i32}> : (i128) -> i64
  %3207 = "llvm.and"(%3206, %3130) : (i64, i64) -> i64
  "llvm.store"(%3207, %arg105) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %3208 = "llvm.trunc"(%3199) <{overflowFlags = 3 : i32}> : (i128) -> i64
  %3209 = "llvm.and"(%3208, %3130) : (i64, i64) -> i64
  %3210 = "llvm.getelementptr"(%arg105) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3209, %3210) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %3211 = "llvm.trunc"(%3201) <{overflowFlags = 3 : i32}> : (i128) -> i64
  %3212 = "llvm.and"(%3211, %3130) : (i64, i64) -> i64
  %3213 = "llvm.getelementptr"(%arg105) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3212, %3213) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %3214 = "llvm.trunc"(%3203) <{overflowFlags = 3 : i32}> : (i128) -> i64
  %3215 = "llvm.and"(%3214, %3130) : (i64, i64) -> i64
  %3216 = "llvm.getelementptr"(%arg105) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3215, %3216) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %3217 = "llvm.trunc"(%3205) <{overflowFlags = 3 : i32}> : (i128) -> i64
  %3218 = "llvm.and"(%3217, %3130) : (i64, i64) -> i64
  %3219 = "llvm.getelementptr"(%arg105) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3218, %3219) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end MLIR.Sodium
