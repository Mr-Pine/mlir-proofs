module

-- crc/out/mlirproofs/regions/verify/fd_r52x5_double_scalar_mul_base.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_base_table_init
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_odd_table
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_ge_add_table
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_ge_dbl
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_neg
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_wnaf
public import Firedancer.Crc.Verify.Mlir.wl_permute
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_base_table

meta import MLIR.Semantics.Func
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_base_table_init
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_odd_table
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_ge_add_table
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_ge_dbl
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_neg
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_wnaf
meta import Firedancer.Crc.Verify.Mlir.wl_permute
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_base_table

namespace MLIR.Firedancer.Crc.Verify

@[expose] public section

mlir_def fd_r52x5_double_scalar_mul_base :=
#loop_annotation = #llvm.loop_annotation<mustProgress = true>
"llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nocapture, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.noundef, llvm.readonly}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = readwrite, argMem = readwrite, inaccessibleMem = none, errnoMem = readwrite, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "256"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], sym_name = "fd_r52x5_double_scalar_mul_base", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg214: !llvm.ptr, %arg215: !llvm.ptr, %arg216: !llvm.ptr, %arg217: !llvm.ptr):
  %3227 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %3228 = "llvm.mlir.constant"() <{value = 8 : i32}> : () -> i32
  %3229 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %3230 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %3231 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
  %3232 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %3233 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %3234 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %3235 = "llvm.mlir.constant"() <{value = dense<0> : vector<4xi64>}> : () -> vector<4xi64>
  %3236 = "llvm.mlir.constant"() <{value = dense<[0, 1, 1, 0]> : vector<4xi64>}> : () -> vector<4xi64>
  %3237 = "llvm.mlir.constant"() <{value = 0 : i16}> : () -> i16
  %3238 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %3239 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %3240 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %3241 = "llvm.mlir.addressof"() <{global_name = @fd_r52x5_base_table}> : () -> !llvm.ptr
  %3242 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %3243 = "llvm.alloca"(%3227) <{alignment = 64 : i64, elem_type = !llvm.array<8 x struct<"struct.fd_r52x5_ge", (vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, array<32 x i8>)>>}> : (i32) -> !llvm.ptr
  %3244 = "llvm.alloca"(%3227) <{alignment = 16 : i64, elem_type = !llvm.array<256 x i16>}> : (i32) -> !llvm.ptr
  %3245 = "llvm.alloca"(%3227) <{alignment = 16 : i64, elem_type = !llvm.array<256 x i16>}> : (i32) -> !llvm.ptr
  %3246 = "llvm.alloca"(%3227) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3247 = "llvm.alloca"(%3227) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3248 = "llvm.alloca"(%3227) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3249 = "llvm.alloca"(%3227) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3250 = "llvm.alloca"(%3227) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3251 = "llvm.alloca"(%3227) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3252 = "llvm.alloca"(%3227) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3253 = "llvm.alloca"(%3227) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3254 = "llvm.alloca"(%3227) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3255 = "llvm.alloca"(%3227) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3256 = "llvm.alloca"(%3227) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3257 = "llvm.alloca"(%3227) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3258 = "llvm.alloca"(%3227) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3259 = "llvm.alloca"(%3227) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3260 = "llvm.alloca"(%3227) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3261 = "llvm.alloca"(%3227) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3262 = "llvm.alloca"(%3227) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3263 = "llvm.alloca"(%3227) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3264 = "llvm.alloca"(%3227) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3265 = "llvm.alloca"(%3227) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3266 = "llvm.alloca"(%3227) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3267 = "llvm.alloca"(%3227) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3268 = "llvm.alloca"(%3227) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3269 = "llvm.alloca"(%3227) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3270 = "llvm.alloca"(%3227) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3271 = "llvm.alloca"(%3227) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3272 = "llvm.alloca"(%3227) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3273 = "llvm.alloca"(%3227) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3274 = "llvm.alloca"(%3227) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3275 = "llvm.alloca"(%3227) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3276 = "llvm.alloca"(%3227) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3277 = "llvm.alloca"(%3227) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3278 = "llvm.alloca"(%3227) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3279 = "llvm.alloca"(%3227) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3280 = "llvm.alloca"(%3227) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  "llvm.call"() <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, callee = @fd_r52x5_base_table_init, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = readwrite, argMem = readwrite, inaccessibleMem = none, errnoMem = readwrite, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
  "llvm.intr.lifetime.start"(%3243) : (!llvm.ptr) -> ()
  "llvm.call"(%3243, %arg216, %3228) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_odd_table, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> ()
  "llvm.intr.lifetime.start"(%3244) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3245) : (!llvm.ptr) -> ()
  %3281 = "llvm.call"(%3244, %arg215, %3229) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_wnaf, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> i32
  %3282 = "llvm.call"(%3245, %arg217, %3228) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_wnaf, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> i32
  %3283 = "llvm.intr.smax"(%3281, %3282) : (i32, i32) -> i32
  %3284 = "llvm.icmp"(%3282, %3281) <{predicate = 4 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%3284)[^bb1, ^bb2] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb1:  // pred: ^bb0
  %3285 = "llvm.sext"(%3281) : (i32) -> i64
  %3286 = "llvm.shl"(%3285, %3230) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %3287 = "llvm.getelementptr"(%3244, %3286) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %3288 = "llvm.xor"(%3281, %3231) : (i32, i32) -> i32
  %3289 = "llvm.add"(%3283, %3288) <{overflowFlags = 0 : i32}> : (i32, i32) -> i32
  %3290 = "llvm.zext"(%3289) : (i32) -> i64
  %3291 = "llvm.shl"(%3290, %3230) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %3292 = "llvm.add"(%3291, %3232) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  "llvm.intr.memset"(%3287, %3233, %3292) <{arg_attrs = [{llvm.align = 2 : i64, llvm.dereferenceable = 1 : i64, llvm.nonnull, llvm.noundef}, {}, {}], isVolatile = false}> : (!llvm.ptr, i8, i64) -> ()
  "llvm.br"()[^bb2] : () -> ()
^bb2:  // 2 preds: ^bb0, ^bb1
  %3293 = "llvm.icmp"(%3281, %3282) <{predicate = 4 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%3293)[^bb4, ^bb3] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb3:  // pred: ^bb2
  %3294 = "llvm.add"(%3283, %3231) <{overflowFlags = 0 : i32}> : (i32, i32) -> i32
  "llvm.br"(%3294)[^bb5] : (i32) -> ()
^bb4:  // pred: ^bb2
  %3295 = "llvm.sext"(%3282) : (i32) -> i64
  %3296 = "llvm.shl"(%3295, %3230) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %3297 = "llvm.getelementptr"(%3245, %3296) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %3298 = "llvm.add"(%3283, %3231) <{overflowFlags = 0 : i32}> : (i32, i32) -> i32
  %3299 = "llvm.sub"(%3298, %3282) <{overflowFlags = 0 : i32}> : (i32, i32) -> i32
  %3300 = "llvm.zext"(%3299) : (i32) -> i64
  %3301 = "llvm.shl"(%3300, %3230) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %3302 = "llvm.add"(%3301, %3232) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  "llvm.intr.memset"(%3297, %3233, %3302) <{arg_attrs = [{llvm.align = 2 : i64, llvm.dereferenceable = 1 : i64, llvm.nonnull, llvm.noundef}, {}, {}], isVolatile = false}> : (!llvm.ptr, i8, i64) -> ()
  "llvm.br"(%3298)[^bb5] : (i32) -> ()
^bb5(%3303: i32):  // 2 preds: ^bb3, ^bb4
  %3304 = "llvm.icmp"(%3303, %3231) <{predicate = 4 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%3304, %3235, %3235, %3235, %3235, %3236)[^bb6, ^bb7] <{operandSegmentSizes = array<i32: 1, 0, 5>}> : (i1, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb6:  // pred: ^bb5
  %3305 = "llvm.zext"(%3303) <{nonNeg}> : (i32) -> i64
  "llvm.br"(%3305, %3236, %3235, %3235, %3235, %3235)[^bb8] : (i64, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb7(%3306: vector<4xi64>, %3307: vector<4xi64>, %3308: vector<4xi64>, %3309: vector<4xi64>, %3310: vector<4xi64>):  // 2 preds: ^bb5, ^bb16
  "llvm.store"(%3310, %arg214) <{alignment = 64 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %3311 = "llvm.getelementptr"(%arg214) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3309, %3311) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %3312 = "llvm.getelementptr"(%arg214) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3308, %3312) <{alignment = 64 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %3313 = "llvm.getelementptr"(%arg214) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3307, %3313) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %3314 = "llvm.getelementptr"(%arg214) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3306, %3314) <{alignment = 64 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3245) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3244) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3243) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
^bb8(%3315: i64, %3316: vector<4xi64>, %3317: vector<4xi64>, %3318: vector<4xi64>, %3319: vector<4xi64>, %3320: vector<4xi64>):  // 2 preds: ^bb6, ^bb16
  "llvm.intr.lifetime.start"(%3246) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3247) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3248) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3249) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3250) : (!llvm.ptr) -> ()
  "llvm.call"(%3246, %3247, %3248, %3249, %3250, %3316, %3317, %3318, %3319, %3320) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_ge_dbl, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %3321 = "llvm.load"(%3246) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3322 = "llvm.load"(%3247) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3323 = "llvm.load"(%3248) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3324 = "llvm.load"(%3249) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3325 = "llvm.load"(%3250) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%3250) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3249) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3248) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3247) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3246) : (!llvm.ptr) -> ()
  %3326 = "llvm.getelementptr"(%3244, %3315) <{elem_type = i16, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %3327 = "llvm.load"(%3326) <{alignment = 2 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i16
  %3328 = "llvm.sext"(%3327) : (i16) -> i32
  %3329 = "llvm.icmp"(%3327, %3237) <{predicate = 4 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%3329)[^bb9, ^bb10] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb9:  // pred: ^bb8
  %3330 = "llvm.add"(%3328, %3231) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %3331 = "llvm.lshr"(%3330, %3227) : (i32, i32) -> i32
  %3332 = "llvm.zext"(%3331) <{nonNeg}> : (i32) -> i64
  %3333 = "llvm.getelementptr"(%3243, %3332) <{elem_type = !llvm.struct<"struct.fd_r52x5_ge", (vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, array<32 x i8>)>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %3334 = "llvm.load"(%3333) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3335 = "llvm.getelementptr"(%3333) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %3336 = "llvm.load"(%3335) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3337 = "llvm.getelementptr"(%3333) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %3338 = "llvm.load"(%3337) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3339 = "llvm.getelementptr"(%3333) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %3340 = "llvm.load"(%3339) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3341 = "llvm.getelementptr"(%3333) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %3342 = "llvm.load"(%3341) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%3251) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3252) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3253) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3254) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3255) : (!llvm.ptr) -> ()
  "llvm.call"(%3251, %3252, %3253, %3254, %3255, %3321, %3322, %3323, %3324, %3325, %3334, %3336, %3338, %3340, %3342) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_ge_add_table, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %3343 = "llvm.load"(%3251) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3344 = "llvm.load"(%3252) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3345 = "llvm.load"(%3253) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3346 = "llvm.load"(%3254) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3347 = "llvm.load"(%3255) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%3255) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3254) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3253) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3252) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3251) : (!llvm.ptr) -> ()
  "llvm.br"(%3347, %3346, %3345, %3344, %3343)[^bb12] : (vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb10:  // pred: ^bb8
  %3348 = "llvm.icmp"(%3327, %3237) <{predicate = 2 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%3348, %3325, %3324, %3323, %3322, %3321)[^bb11, ^bb12] <{operandSegmentSizes = array<i32: 1, 0, 5>}> : (i1, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb11:  // pred: ^bb10
  %3349 = "llvm.xor"(%3328, %3231) : (i32, i32) -> i32
  %3350 = "llvm.lshr"(%3349, %3227) : (i32, i32) -> i32
  %3351 = "llvm.zext"(%3350) <{nonNeg}> : (i32) -> i64
  %3352 = "llvm.getelementptr"(%3243, %3351) <{elem_type = !llvm.struct<"struct.fd_r52x5_ge", (vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, array<32 x i8>)>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %3353 = "llvm.load"(%3352) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3354 = "llvm.getelementptr"(%3352) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %3355 = "llvm.load"(%3354) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3356 = "llvm.getelementptr"(%3352) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %3357 = "llvm.load"(%3356) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3358 = "llvm.getelementptr"(%3352) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %3359 = "llvm.load"(%3358) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3360 = "llvm.getelementptr"(%3352) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %3361 = "llvm.load"(%3360) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3362 = "llvm.call"(%3353, %3227, %3238, %3239, %3240) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3363 = "llvm.call"(%3355, %3227, %3238, %3239, %3240) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3364 = "llvm.call"(%3357, %3227, %3238, %3239, %3240) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3365 = "llvm.call"(%3359, %3227, %3238, %3239, %3240) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3366 = "llvm.call"(%3361, %3227, %3238, %3239, %3240) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%3256) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3257) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3258) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3259) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3260) : (!llvm.ptr) -> ()
  "llvm.call"(%3256, %3257, %3258, %3259, %3260, %3362, %3363, %3364, %3365, %3366) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_neg, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %3367 = "llvm.load"(%3256) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3368 = "llvm.load"(%3257) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3369 = "llvm.load"(%3258) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3370 = "llvm.load"(%3259) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3371 = "llvm.load"(%3260) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%3260) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3259) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3258) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3257) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3256) : (!llvm.ptr) -> ()
  %3372 = "llvm.shufflevector"(%3362, %3367) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3373 = "llvm.shufflevector"(%3363, %3368) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3374 = "llvm.shufflevector"(%3364, %3369) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3375 = "llvm.shufflevector"(%3365, %3370) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3376 = "llvm.shufflevector"(%3366, %3371) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%3261) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3262) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3263) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3264) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3265) : (!llvm.ptr) -> ()
  "llvm.call"(%3261, %3262, %3263, %3264, %3265, %3321, %3322, %3323, %3324, %3325, %3372, %3373, %3374, %3375, %3376) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_ge_add_table, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %3377 = "llvm.load"(%3261) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3378 = "llvm.load"(%3262) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3379 = "llvm.load"(%3263) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3380 = "llvm.load"(%3264) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3381 = "llvm.load"(%3265) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%3265) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3264) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3263) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3262) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3261) : (!llvm.ptr) -> ()
  "llvm.br"(%3381, %3380, %3379, %3378, %3377)[^bb12] : (vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb12(%3382: vector<4xi64>, %3383: vector<4xi64>, %3384: vector<4xi64>, %3385: vector<4xi64>, %3386: vector<4xi64>):  // 3 preds: ^bb9, ^bb10, ^bb11
  %3387 = "llvm.getelementptr"(%3245, %3315) <{elem_type = i16, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %3388 = "llvm.load"(%3387) <{alignment = 2 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i16
  %3389 = "llvm.sext"(%3388) : (i16) -> i32
  %3390 = "llvm.icmp"(%3388, %3237) <{predicate = 4 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%3390)[^bb13, ^bb14] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb13:  // pred: ^bb12
  %3391 = "llvm.add"(%3389, %3231) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %3392 = "llvm.lshr"(%3391, %3227) : (i32, i32) -> i32
  %3393 = "llvm.zext"(%3392) <{nonNeg}> : (i32) -> i64
  %3394 = "llvm.getelementptr"(%3241, %3393) <{elem_type = !llvm.struct<"struct.fd_r52x5_ge", (vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, array<32 x i8>)>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %3395 = "llvm.load"(%3394) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3396 = "llvm.getelementptr"(%3394) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %3397 = "llvm.load"(%3396) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3398 = "llvm.getelementptr"(%3394) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %3399 = "llvm.load"(%3398) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3400 = "llvm.getelementptr"(%3394) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %3401 = "llvm.load"(%3400) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3402 = "llvm.getelementptr"(%3394) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %3403 = "llvm.load"(%3402) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%3266) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3267) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3268) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3269) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3270) : (!llvm.ptr) -> ()
  "llvm.call"(%3266, %3267, %3268, %3269, %3270, %3386, %3385, %3384, %3383, %3382, %3395, %3397, %3399, %3401, %3403) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_ge_add_table, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %3404 = "llvm.load"(%3266) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3405 = "llvm.load"(%3267) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3406 = "llvm.load"(%3268) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3407 = "llvm.load"(%3269) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3408 = "llvm.load"(%3270) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%3270) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3269) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3268) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3267) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3266) : (!llvm.ptr) -> ()
  "llvm.br"(%3408, %3407, %3406, %3405, %3404)[^bb16] : (vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb14:  // pred: ^bb12
  %3409 = "llvm.icmp"(%3388, %3237) <{predicate = 2 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%3409, %3382, %3383, %3384, %3385, %3386)[^bb15, ^bb16] <{operandSegmentSizes = array<i32: 1, 0, 5>}> : (i1, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb15:  // pred: ^bb14
  %3410 = "llvm.xor"(%3389, %3231) : (i32, i32) -> i32
  %3411 = "llvm.lshr"(%3410, %3227) : (i32, i32) -> i32
  %3412 = "llvm.zext"(%3411) <{nonNeg}> : (i32) -> i64
  %3413 = "llvm.getelementptr"(%3241, %3412) <{elem_type = !llvm.struct<"struct.fd_r52x5_ge", (vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, array<32 x i8>)>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %3414 = "llvm.load"(%3413) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3415 = "llvm.getelementptr"(%3413) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %3416 = "llvm.load"(%3415) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3417 = "llvm.getelementptr"(%3413) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %3418 = "llvm.load"(%3417) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3419 = "llvm.getelementptr"(%3413) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %3420 = "llvm.load"(%3419) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3421 = "llvm.getelementptr"(%3413) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %3422 = "llvm.load"(%3421) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3423 = "llvm.call"(%3414, %3227, %3238, %3239, %3240) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3424 = "llvm.call"(%3416, %3227, %3238, %3239, %3240) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3425 = "llvm.call"(%3418, %3227, %3238, %3239, %3240) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3426 = "llvm.call"(%3420, %3227, %3238, %3239, %3240) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3427 = "llvm.call"(%3422, %3227, %3238, %3239, %3240) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%3271) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3272) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3273) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3274) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3275) : (!llvm.ptr) -> ()
  "llvm.call"(%3271, %3272, %3273, %3274, %3275, %3423, %3424, %3425, %3426, %3427) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_neg, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %3428 = "llvm.load"(%3271) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3429 = "llvm.load"(%3272) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3430 = "llvm.load"(%3273) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3431 = "llvm.load"(%3274) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3432 = "llvm.load"(%3275) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%3275) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3274) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3273) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3272) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3271) : (!llvm.ptr) -> ()
  %3433 = "llvm.shufflevector"(%3423, %3428) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3434 = "llvm.shufflevector"(%3424, %3429) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3435 = "llvm.shufflevector"(%3425, %3430) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3436 = "llvm.shufflevector"(%3426, %3431) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3437 = "llvm.shufflevector"(%3427, %3432) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%3276) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3277) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3278) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3279) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3280) : (!llvm.ptr) -> ()
  "llvm.call"(%3276, %3277, %3278, %3279, %3280, %3386, %3385, %3384, %3383, %3382, %3433, %3434, %3435, %3436, %3437) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_ge_add_table, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %3438 = "llvm.load"(%3276) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3439 = "llvm.load"(%3277) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3440 = "llvm.load"(%3278) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3441 = "llvm.load"(%3279) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3442 = "llvm.load"(%3280) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%3280) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3279) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3278) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3277) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3276) : (!llvm.ptr) -> ()
  "llvm.br"(%3442, %3441, %3440, %3439, %3438)[^bb16] : (vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb16(%3443: vector<4xi64>, %3444: vector<4xi64>, %3445: vector<4xi64>, %3446: vector<4xi64>, %3447: vector<4xi64>):  // 3 preds: ^bb13, ^bb14, ^bb15
  %3448 = "llvm.add"(%3315, %3242) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %3449 = "llvm.icmp"(%3315, %3234) <{predicate = 4 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%3449, %3448, %3447, %3446, %3445, %3444, %3443, %3443, %3444, %3445, %3446, %3447)[^bb8, ^bb7] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 6, 5>}> : (i1, i64, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
}) : () -> ()
  with @fd_r52x5_base_table_init := fd_r52x5_base_table_init,
    @fd_r52x5_odd_table := fd_r52x5_odd_table,
    @fd_r52x5_quad_ge_add_table := fd_r52x5_quad_ge_add_table,
    @fd_r52x5_quad_ge_dbl := fd_r52x5_quad_ge_dbl, @fd_r52x5_quad_neg := fd_r52x5_quad_neg,
    @fd_r52x5_wnaf := fd_r52x5_wnaf, @wl_permute := wl_permute,
    @fd_r52x5_base_table := fd_r52x5_base_table

end

end MLIR.Firedancer.Crc.Verify
