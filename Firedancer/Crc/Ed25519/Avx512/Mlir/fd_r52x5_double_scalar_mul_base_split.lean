module

-- crc/out/mlirproofs/regions/verify/fd_r52x5_double_scalar_mul_base_split.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_ge_add_table
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_ge_dbl
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_neg
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_wnaf
public import Firedancer.Crc.Ed25519.Avx512.Mlir.wl_permute
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_ed25519_r52x5_base_table

meta import MLIR.Semantics.Func
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_ge_add_table
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_ge_dbl
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_neg
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_wnaf
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.wl_permute
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_ed25519_r52x5_base_table

namespace MLIR.Firedancer.Crc.Ed25519.Avx512

@[expose] public section

noncomputable mlir_def fd_r52x5_double_scalar_mul_base_split :=
#loop_annotation = #llvm.loop_annotation<mustProgress = true>
"llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nocapture, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.noundef, llvm.readonly}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "256"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], sym_name = "fd_r52x5_double_scalar_mul_base_split", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg205: !llvm.ptr, %arg206: !llvm.ptr, %arg207: !llvm.ptr, %arg208: !llvm.ptr):
  %3149 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %3150 = "llvm.mlir.constant"() <{value = 8 : i64}> : () -> i64
  %3151 = "llvm.mlir.poison"() : () -> vector<3xi64>
  %3152 = "llvm.mlir.poison"() : () -> vector<4xi64>
  %3153 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %3154 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %3155 = "llvm.mlir.constant"() <{value = 8 : i32}> : () -> i32
  %3156 = "llvm.mlir.constant"() <{value = 264 : i32}> : () -> i32
  %3157 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %3158 = "llvm.mlir.constant"() <{value = 263 : i32}> : () -> i32
  %3159 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %3160 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %3161 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %3162 = "llvm.mlir.constant"() <{value = dense<[0, 1, 1, 0]> : vector<4xi64>}> : () -> vector<4xi64>
  %3163 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %3164 = "llvm.mlir.constant"() <{value = dense<0> : vector<4xi64>}> : () -> vector<4xi64>
  %3165 = "llvm.mlir.constant"() <{value = 33 : i64}> : () -> i64
  %3166 = "llvm.mlir.constant"() <{value = 640 : i64}> : () -> i64
  %3167 = "llvm.mlir.addressof"() <{global_name = @fd_ed25519_r52x5_base_table}> : () -> !llvm.ptr
  %3168 = "llvm.mlir.constant"() <{value = 0 : i16}> : () -> i16
  %3169 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
  %3170 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %3171 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %3172 = "llvm.mlir.poison"() : () -> i64
  %3173 = "llvm.mlir.undef"() : () -> vector<4xi64>
  %3174 = "llvm.insertelement"(%3173, %3172, %3170) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %3175 = "llvm.insertelement"(%3174, %3172, %3153) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %3176 = "llvm.insertelement"(%3175, %3159, %3171) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %3177 = "llvm.insertelement"(%3176, %3172, %3154) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %3178 = "llvm.alloca"(%3153) <{alignment = 16 : i64, elem_type = !llvm.array<264 x i16>}> : (i32) -> !llvm.ptr
  %3179 = "llvm.alloca"(%3153) <{alignment = 16 : i64, elem_type = !llvm.array<264 x i16>}> : (i32) -> !llvm.ptr
  %3180 = "llvm.alloca"(%3153) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3181 = "llvm.alloca"(%3153) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3182 = "llvm.alloca"(%3153) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3183 = "llvm.alloca"(%3153) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3184 = "llvm.alloca"(%3153) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3185 = "llvm.alloca"(%3153) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3186 = "llvm.alloca"(%3153) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3187 = "llvm.alloca"(%3153) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3188 = "llvm.alloca"(%3153) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3189 = "llvm.alloca"(%3153) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3190 = "llvm.alloca"(%3153) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3191 = "llvm.alloca"(%3153) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3192 = "llvm.alloca"(%3153) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3193 = "llvm.alloca"(%3153) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3194 = "llvm.alloca"(%3153) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3195 = "llvm.alloca"(%3153) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3196 = "llvm.alloca"(%3153) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3197 = "llvm.alloca"(%3153) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3198 = "llvm.alloca"(%3153) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3199 = "llvm.alloca"(%3153) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3200 = "llvm.alloca"(%3153) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3201 = "llvm.alloca"(%3153) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3202 = "llvm.alloca"(%3153) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3203 = "llvm.alloca"(%3153) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3204 = "llvm.alloca"(%3153) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3205 = "llvm.alloca"(%3153) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3206 = "llvm.alloca"(%3153) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3207 = "llvm.alloca"(%3153) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3208 = "llvm.alloca"(%3153) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3209 = "llvm.alloca"(%3153) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3210 = "llvm.alloca"(%3153) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3211 = "llvm.alloca"(%3153) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3212 = "llvm.alloca"(%3153) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3213 = "llvm.alloca"(%3153) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3214 = "llvm.alloca"(%3153) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%3178) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3179) : (!llvm.ptr) -> ()
  %3215 = "llvm.call"(%3178, %arg206, %3154) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_wnaf, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> i32
  %3216 = "llvm.call"(%3179, %arg208, %3155) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_wnaf, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> i32
  %3217 = "llvm.icmp"(%3215, %3156) <{predicate = 2 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%3217)[^bb1, ^bb2] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb1:  // pred: ^bb0
  %3218 = "llvm.sext"(%3215) : (i32) -> i64
  %3219 = "llvm.shl"(%3218, %3157) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %3220 = "llvm.getelementptr"(%3178, %3219) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %3221 = "llvm.sub"(%3158, %3215) <{overflowFlags = 0 : i32}> : (i32, i32) -> i32
  %3222 = "llvm.zext"(%3221) : (i32) -> i64
  %3223 = "llvm.shl"(%3222, %3157) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %3224 = "llvm.add"(%3223, %3159) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  "llvm.intr.memset"(%3220, %3160, %3224) <{arg_attrs = [{llvm.align = 2 : i64, llvm.dereferenceable = 1 : i64, llvm.nonnull, llvm.noundef}, {}, {}], isVolatile = false}> : (!llvm.ptr, i8, i64) -> ()
  "llvm.br"()[^bb2] : () -> ()
^bb2:  // 2 preds: ^bb0, ^bb1
  %3225 = "llvm.icmp"(%3216, %3156) <{predicate = 2 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%3225)[^bb4, ^bb3] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb3:  // 2 preds: ^bb2, ^bb4
  "llvm.br"(%3161, %3162, %3164, %3164, %3164, %3164)[^bb6] : (i64, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb4:  // pred: ^bb2
  %3226 = "llvm.sext"(%3216) : (i32) -> i64
  %3227 = "llvm.shl"(%3226, %3157) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %3228 = "llvm.getelementptr"(%3179, %3227) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %3229 = "llvm.sub"(%3158, %3216) <{overflowFlags = 0 : i32}> : (i32, i32) -> i32
  %3230 = "llvm.zext"(%3229) : (i32) -> i64
  %3231 = "llvm.shl"(%3230, %3157) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %3232 = "llvm.add"(%3231, %3159) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  "llvm.intr.memset"(%3228, %3160, %3232) <{arg_attrs = [{llvm.align = 2 : i64, llvm.dereferenceable = 1 : i64, llvm.nonnull, llvm.noundef}, {}, {}], isVolatile = false}> : (!llvm.ptr, i8, i64) -> ()
  "llvm.br"()[^bb3] : () -> ()
^bb5:  // pred: ^bb7
  "llvm.store"(%3400, %arg205) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %3233 = "llvm.getelementptr"(%arg205) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3399, %3233) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %3234 = "llvm.getelementptr"(%arg205) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3398, %3234) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %3235 = "llvm.getelementptr"(%arg205) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3397, %3235) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %3236 = "llvm.getelementptr"(%arg205) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3396, %3236) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3179) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3178) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
^bb6(%3237: i64, %3238: vector<4xi64>, %3239: vector<4xi64>, %3240: vector<4xi64>, %3241: vector<4xi64>, %3242: vector<4xi64>):  // 2 preds: ^bb3, ^bb7
  "llvm.intr.lifetime.start"(%3180) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3181) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3182) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3183) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3184) : (!llvm.ptr) -> ()
  "llvm.call"(%3180, %3181, %3182, %3183, %3184, %3238, %3239, %3240, %3241, %3242) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_ge_dbl, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %3243 = "llvm.load"(%3180) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3244 = "llvm.load"(%3181) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3245 = "llvm.load"(%3182) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3246 = "llvm.load"(%3183) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3247 = "llvm.load"(%3184) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%3184) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3183) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3182) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3181) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3180) : (!llvm.ptr) -> ()
  "llvm.br"(%3163, %3243, %3244, %3245, %3246, %3247)[^bb8] : (i64, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb7:  // pred: ^bb16
  %3248 = "llvm.add"(%3237, %3149) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %3249 = "llvm.icmp"(%3237, %3163) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%3249, %3248, %3400, %3399, %3398, %3397, %3396)[^bb5, ^bb6] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 6>}> : (i1, i64, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb8(%3250: i64, %3251: vector<4xi64>, %3252: vector<4xi64>, %3253: vector<4xi64>, %3254: vector<4xi64>, %3255: vector<4xi64>):  // 2 preds: ^bb6, ^bb16
  %3256 = "llvm.mul"(%3250, %3165) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %3257 = "llvm.add"(%3256, %3237) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %3258 = "llvm.getelementptr"(%3178, %3257) <{elem_type = i16, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %3259 = "llvm.load"(%3258) <{alignment = 2 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i16
  %3260 = "llvm.getelementptr"(%3179, %3257) <{elem_type = i16, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %3261 = "llvm.load"(%3260) <{alignment = 2 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i16
  %3262 = "llvm.mul"(%3250, %3166) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %3263 = "llvm.getelementptr"(%arg207, %3262) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %3264 = "llvm.getelementptr"(%3167, %3250) <{elem_type = !llvm.array<128 x struct<"struct.fd_r52x5_tbl", (array<16 x i64>)>>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %3265 = "llvm.sext"(%3259) : (i16) -> i32
  %3266 = "llvm.icmp"(%3259, %3168) <{predicate = 4 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%3266)[^bb9, ^bb10] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb9:  // pred: ^bb8
  %3267 = "llvm.add"(%3265, %3169) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %3268 = "llvm.lshr"(%3267, %3153) : (i32, i32) -> i32
  %3269 = "llvm.zext"(%3268) <{nonNeg}> : (i32) -> i64
  %3270 = "llvm.getelementptr"(%3263, %3269) <{elem_type = !llvm.struct<"struct.fd_r52x5_ge", (vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>)>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %3271 = "llvm.load"(%3270) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3272 = "llvm.getelementptr"(%3270) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %3273 = "llvm.load"(%3272) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3274 = "llvm.getelementptr"(%3270) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %3275 = "llvm.load"(%3274) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3276 = "llvm.getelementptr"(%3270) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %3277 = "llvm.load"(%3276) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3278 = "llvm.getelementptr"(%3270) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %3279 = "llvm.load"(%3278) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%3185) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3186) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3187) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3188) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3189) : (!llvm.ptr) -> ()
  "llvm.call"(%3185, %3186, %3187, %3188, %3189, %3251, %3252, %3253, %3254, %3255, %3271, %3273, %3275, %3277, %3279) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_ge_add_table, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %3280 = "llvm.load"(%3185) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3281 = "llvm.load"(%3186) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3282 = "llvm.load"(%3187) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3283 = "llvm.load"(%3188) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3284 = "llvm.load"(%3189) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%3189) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3188) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3187) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3186) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3185) : (!llvm.ptr) -> ()
  "llvm.br"(%3284, %3283, %3282, %3281, %3280)[^bb12] : (vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb10:  // pred: ^bb8
  %3285 = "llvm.icmp"(%3259, %3168) <{predicate = 2 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%3285, %3255, %3254, %3253, %3252, %3251)[^bb11, ^bb12] <{operandSegmentSizes = array<i32: 1, 0, 5>}> : (i1, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb11:  // pred: ^bb10
  %3286 = "llvm.xor"(%3265, %3169) : (i32, i32) -> i32
  %3287 = "llvm.lshr"(%3286, %3153) : (i32, i32) -> i32
  %3288 = "llvm.zext"(%3287) <{nonNeg}> : (i32) -> i64
  %3289 = "llvm.getelementptr"(%3263, %3288) <{elem_type = !llvm.struct<"struct.fd_r52x5_ge", (vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>)>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %3290 = "llvm.load"(%3289) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3291 = "llvm.getelementptr"(%3289) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %3292 = "llvm.load"(%3291) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3293 = "llvm.getelementptr"(%3289) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %3294 = "llvm.load"(%3293) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3295 = "llvm.getelementptr"(%3289) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %3296 = "llvm.load"(%3295) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3297 = "llvm.getelementptr"(%3289) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %3298 = "llvm.load"(%3297) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3299 = "llvm.call"(%3290, %3153, %3170, %3171, %3154) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3300 = "llvm.call"(%3292, %3153, %3170, %3171, %3154) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3301 = "llvm.call"(%3294, %3153, %3170, %3171, %3154) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3302 = "llvm.call"(%3296, %3153, %3170, %3171, %3154) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3303 = "llvm.call"(%3298, %3153, %3170, %3171, %3154) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%3190) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3191) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3192) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3193) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3194) : (!llvm.ptr) -> ()
  "llvm.call"(%3190, %3191, %3192, %3193, %3194, %3299, %3300, %3301, %3302, %3303) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_neg, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %3304 = "llvm.load"(%3190) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3305 = "llvm.load"(%3191) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3306 = "llvm.load"(%3192) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3307 = "llvm.load"(%3193) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3308 = "llvm.load"(%3194) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%3194) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3193) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3192) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3191) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3190) : (!llvm.ptr) -> ()
  %3309 = "llvm.shufflevector"(%3299, %3304) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3310 = "llvm.shufflevector"(%3300, %3305) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3311 = "llvm.shufflevector"(%3301, %3306) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3312 = "llvm.shufflevector"(%3302, %3307) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3313 = "llvm.shufflevector"(%3303, %3308) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%3195) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3196) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3197) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3198) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3199) : (!llvm.ptr) -> ()
  "llvm.call"(%3195, %3196, %3197, %3198, %3199, %3251, %3252, %3253, %3254, %3255, %3309, %3310, %3311, %3312, %3313) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_ge_add_table, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %3314 = "llvm.load"(%3195) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3315 = "llvm.load"(%3196) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3316 = "llvm.load"(%3197) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3317 = "llvm.load"(%3198) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3318 = "llvm.load"(%3199) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%3199) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3198) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3197) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3196) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3195) : (!llvm.ptr) -> ()
  "llvm.br"(%3318, %3317, %3316, %3315, %3314)[^bb12] : (vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb12(%3319: vector<4xi64>, %3320: vector<4xi64>, %3321: vector<4xi64>, %3322: vector<4xi64>, %3323: vector<4xi64>):  // 3 preds: ^bb9, ^bb10, ^bb11
  %3324 = "llvm.sext"(%3261) : (i16) -> i32
  %3325 = "llvm.icmp"(%3261, %3168) <{predicate = 4 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%3325)[^bb13, ^bb14] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb13:  // pred: ^bb12
  %3326 = "llvm.add"(%3324, %3169) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %3327 = "llvm.lshr"(%3326, %3153) : (i32, i32) -> i32
  %3328 = "llvm.zext"(%3327) <{nonNeg}> : (i32) -> i64
  %3329 = "llvm.getelementptr"(%3264, %3328) <{elem_type = !llvm.struct<"struct.fd_r52x5_tbl", (array<16 x i64>)>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %3330 = "llvm.load"(%3329) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3331 = "llvm.getelementptr"(%3329) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %3332 = "llvm.load"(%3331) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3333 = "llvm.getelementptr"(%3329) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 48>}> : (!llvm.ptr) -> !llvm.ptr
  %3334 = "llvm.load"(%3333) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3335 = "llvm.getelementptr"(%3329) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 72>}> : (!llvm.ptr) -> !llvm.ptr
  %3336 = "llvm.load"(%3335) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3337 = "llvm.getelementptr"(%3329) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %3338 = "llvm.load"(%3337) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<3xi64>
  %3339 = "llvm.shufflevector"(%3330, %3177) <{mask = array<i32: 0, 1, 6, 2>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3340 = "llvm.shufflevector"(%3332, %3152) <{mask = array<i32: 0, 1, -1, 2>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3341 = "llvm.insertelement"(%3340, %3163, %3159) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %3342 = "llvm.shufflevector"(%3334, %3152) <{mask = array<i32: 0, 1, -1, 2>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3343 = "llvm.insertelement"(%3342, %3163, %3159) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %3344 = "llvm.shufflevector"(%3336, %3152) <{mask = array<i32: 0, 1, -1, 2>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3345 = "llvm.insertelement"(%3344, %3163, %3159) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %3346 = "llvm.shufflevector"(%3338, %3151) <{mask = array<i32: 0, 1, -1, 2>}> : (vector<3xi64>, vector<3xi64>) -> vector<4xi64>
  %3347 = "llvm.insertelement"(%3346, %3163, %3159) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%3200) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3201) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3202) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3203) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3204) : (!llvm.ptr) -> ()
  "llvm.call"(%3200, %3201, %3202, %3203, %3204, %3323, %3322, %3321, %3320, %3319, %3339, %3341, %3343, %3345, %3347) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_ge_add_table, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %3348 = "llvm.load"(%3200) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3349 = "llvm.load"(%3201) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3350 = "llvm.load"(%3202) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3351 = "llvm.load"(%3203) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3352 = "llvm.load"(%3204) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%3204) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3203) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3202) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3201) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3200) : (!llvm.ptr) -> ()
  "llvm.br"(%3352, %3351, %3350, %3349, %3348)[^bb16] : (vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb14:  // pred: ^bb12
  %3353 = "llvm.icmp"(%3261, %3168) <{predicate = 2 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%3353, %3319, %3320, %3321, %3322, %3323)[^bb15, ^bb16] <{operandSegmentSizes = array<i32: 1, 0, 5>}> : (i1, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb15:  // pred: ^bb14
  %3354 = "llvm.xor"(%3324, %3169) : (i32, i32) -> i32
  %3355 = "llvm.lshr"(%3354, %3153) : (i32, i32) -> i32
  %3356 = "llvm.zext"(%3355) <{nonNeg}> : (i32) -> i64
  %3357 = "llvm.getelementptr"(%3264, %3356) <{elem_type = !llvm.struct<"struct.fd_r52x5_tbl", (array<16 x i64>)>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %3358 = "llvm.load"(%3357) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3359 = "llvm.getelementptr"(%3357) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %3360 = "llvm.load"(%3359) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3361 = "llvm.getelementptr"(%3357) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 48>}> : (!llvm.ptr) -> !llvm.ptr
  %3362 = "llvm.load"(%3361) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3363 = "llvm.getelementptr"(%3357) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 72>}> : (!llvm.ptr) -> !llvm.ptr
  %3364 = "llvm.load"(%3363) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3365 = "llvm.getelementptr"(%3357) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %3366 = "llvm.load"(%3365) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<3xi64>
  %3367 = "llvm.shufflevector"(%3358, %3177) <{mask = array<i32: 0, 1, 6, 2>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3368 = "llvm.shufflevector"(%3360, %3152) <{mask = array<i32: 0, 1, -1, 2>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3369 = "llvm.insertelement"(%3368, %3163, %3159) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %3370 = "llvm.shufflevector"(%3362, %3152) <{mask = array<i32: 0, 1, -1, 2>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3371 = "llvm.insertelement"(%3370, %3163, %3159) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %3372 = "llvm.shufflevector"(%3364, %3152) <{mask = array<i32: 0, 1, -1, 2>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3373 = "llvm.insertelement"(%3372, %3163, %3159) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %3374 = "llvm.shufflevector"(%3366, %3151) <{mask = array<i32: 0, 1, -1, 2>}> : (vector<3xi64>, vector<3xi64>) -> vector<4xi64>
  %3375 = "llvm.insertelement"(%3374, %3163, %3159) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %3376 = "llvm.call"(%3367, %3153, %3170, %3171, %3154) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3377 = "llvm.call"(%3369, %3153, %3170, %3171, %3154) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3378 = "llvm.call"(%3371, %3153, %3170, %3171, %3154) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3379 = "llvm.call"(%3373, %3153, %3170, %3171, %3154) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3380 = "llvm.call"(%3375, %3153, %3170, %3171, %3154) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%3205) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3206) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3207) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3208) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3209) : (!llvm.ptr) -> ()
  "llvm.call"(%3205, %3206, %3207, %3208, %3209, %3376, %3377, %3378, %3379, %3380) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_neg, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %3381 = "llvm.load"(%3205) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3382 = "llvm.load"(%3206) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3383 = "llvm.load"(%3207) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3384 = "llvm.load"(%3208) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3385 = "llvm.load"(%3209) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%3209) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3208) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3207) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3206) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3205) : (!llvm.ptr) -> ()
  %3386 = "llvm.shufflevector"(%3376, %3381) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3387 = "llvm.shufflevector"(%3377, %3382) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3388 = "llvm.shufflevector"(%3378, %3383) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3389 = "llvm.shufflevector"(%3379, %3384) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3390 = "llvm.shufflevector"(%3380, %3385) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%3210) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3211) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3212) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3213) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3214) : (!llvm.ptr) -> ()
  "llvm.call"(%3210, %3211, %3212, %3213, %3214, %3323, %3322, %3321, %3320, %3319, %3386, %3387, %3388, %3389, %3390) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_ge_add_table, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %3391 = "llvm.load"(%3210) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3392 = "llvm.load"(%3211) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3393 = "llvm.load"(%3212) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3394 = "llvm.load"(%3213) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3395 = "llvm.load"(%3214) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%3214) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3213) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3212) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3211) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3210) : (!llvm.ptr) -> ()
  "llvm.br"(%3395, %3394, %3393, %3392, %3391)[^bb16] : (vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb16(%3396: vector<4xi64>, %3397: vector<4xi64>, %3398: vector<4xi64>, %3399: vector<4xi64>, %3400: vector<4xi64>):  // 3 preds: ^bb13, ^bb14, ^bb15
  %3401 = "llvm.add"(%3250, %3157) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %3402 = "llvm.icmp"(%3401, %3150) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%3402, %3401, %3400, %3399, %3398, %3397, %3396)[^bb7, ^bb8] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 6>}> : (i1, i64, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
}) : () -> ()
  with @fd_r52x5_quad_ge_add_table := fd_r52x5_quad_ge_add_table,
    @fd_r52x5_quad_ge_dbl := fd_r52x5_quad_ge_dbl, @fd_r52x5_quad_neg := fd_r52x5_quad_neg,
    @fd_r52x5_wnaf := fd_r52x5_wnaf, @wl_permute := wl_permute,
    @fd_ed25519_r52x5_base_table := fd_ed25519_r52x5_base_table

end

end MLIR.Firedancer.Crc.Ed25519.Avx512
