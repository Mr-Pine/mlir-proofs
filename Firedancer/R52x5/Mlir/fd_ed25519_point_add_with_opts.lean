module

-- ~/fd-pr9879/build/llvm23-production/mlir_canonicalized/avx512/op/fd_ed25519_point_add_with_opts.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.R52x5.Mlir.fd_r52x5_quad_mul_fast
public import Firedancer.R52x5.Mlir.wc_bcast_wide
public import Firedancer.R52x5.Mlir.wl_permute

meta import MLIR.Semantics.Func
meta import Firedancer.R52x5.Mlir.fd_r52x5_quad_mul_fast
meta import Firedancer.R52x5.Mlir.wc_bcast_wide
meta import Firedancer.R52x5.Mlir.wl_permute

namespace MLIR.Firedancer.R52x5

@[expose] public section

mlir_def fd_ed25519_point_add_with_opts :=
#tbaa_root = #llvm.tbaa_root<id = "Simple C/C++ TBAA">
#tbaa_type_desc = #llvm.tbaa_type_desc<id = "omnipotent char", members = {<#tbaa_root, 0>}>
#tbaa_tag = #llvm.tbaa_tag<base_type = #tbaa_type_desc, access_type = #tbaa_type_desc, offset = 0>
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nofree, llvm.noundef, llvm.returned, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.noundef, llvm.range = #llvm.constant_range<i32, 0, 2>}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<ptr (ptr, ptr, ptr, i32)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "256"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], res_attrs = [{llvm.noundef}], sym_name = "fd_ed25519_point_add_with_opts", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg127: !llvm.ptr, %arg128: !llvm.ptr, %arg129: !llvm.ptr, %arg130: i32):
  %3281 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %3282 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %3283 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %3284 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %3285 = "llvm.mlir.constant"() <{value = dense<72057594037927328> : vector<4xi64>}> : () -> vector<4xi64>
  %3286 = "llvm.mlir.constant"() <{value = dense<72057594037927904> : vector<4xi64>}> : () -> vector<4xi64>
  %3287 = "llvm.mlir.constant"() <{value = dense<51> : vector<4xi64>}> : () -> vector<4xi64>
  %3288 = "llvm.mlir.constant"() <{value = dense<2251799813685247> : vector<4xi64>}> : () -> vector<4xi64>
  %3289 = "llvm.mlir.constant"() <{value = dense<19> : vector<4xi64>}> : () -> vector<4xi64>
  %3290 = "llvm.mlir.constant"() <{value = dense<0> : vector<4xi64>}> : () -> vector<4xi64>
  %3291 = "llvm.mlir.constant"() <{value = dense<[121666, 121666, 243332, 243330]> : vector<4xi64>}> : () -> vector<4xi64>
  %3292 = "llvm.mlir.constant"() <{value = dense<1> : vector<4xi64>}> : () -> vector<4xi64>
  %3293 = "llvm.alloca"(%3281) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3294 = "llvm.alloca"(%3281) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3295 = "llvm.alloca"(%3281) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3296 = "llvm.alloca"(%3281) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3297 = "llvm.alloca"(%3281) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3298 = "llvm.alloca"(%3281) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3299 = "llvm.alloca"(%3281) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3300 = "llvm.alloca"(%3281) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3301 = "llvm.alloca"(%3281) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3302 = "llvm.alloca"(%3281) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3303 = "llvm.alloca"(%3281) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3304 = "llvm.alloca"(%3281) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3305 = "llvm.alloca"(%3281) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3306 = "llvm.alloca"(%3281) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3307 = "llvm.alloca"(%3281) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3308 = "llvm.alloca"(%3281) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3309 = "llvm.alloca"(%3281) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3310 = "llvm.alloca"(%3281) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3311 = "llvm.alloca"(%3281) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3312 = "llvm.alloca"(%3281) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %3313 = "llvm.icmp"(%arg130, %3282) <{predicate = 0 : i64}> : (i32, i32) -> i1
  %3314 = "llvm.call"(%3281, %3282, %3281, %3282) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wc_bcast_wide, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (i32, i32, i32, i32) -> vector<4xi64>
  "llvm.cond_br"(%3313)[^bb2, ^bb1] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb1:  // pred: ^bb0
  %3315 = "llvm.load"(%arg128) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %3316 = "llvm.call"(%3315, %3281, %3282, %3283, %3284) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3317 = "llvm.getelementptr"(%arg128) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %3318 = "llvm.load"(%3317) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %3319 = "llvm.call"(%3318, %3281, %3282, %3283, %3284) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3320 = "llvm.getelementptr"(%arg128) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %3321 = "llvm.load"(%3320) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %3322 = "llvm.call"(%3321, %3281, %3282, %3283, %3284) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3323 = "llvm.getelementptr"(%arg128) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %3324 = "llvm.load"(%3323) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %3325 = "llvm.call"(%3324, %3281, %3282, %3283, %3284) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3326 = "llvm.getelementptr"(%arg128) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %3327 = "llvm.load"(%3326) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %3328 = "llvm.call"(%3327, %3281, %3282, %3283, %3284) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3329 = "llvm.sub"(%3285, %3315) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3330 = "llvm.sub"(%3286, %3318) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3331 = "llvm.sub"(%3286, %3321) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3332 = "llvm.sub"(%3286, %3324) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3333 = "llvm.sub"(%3286, %3327) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3334 = "llvm.bitcast"(%3315) : (vector<4xi64>) -> vector<32xi8>
  %3335 = "llvm.bitcast"(%3329) : (vector<4xi64>) -> vector<32xi8>
  %3336 = "llvm.bitcast"(%3314) : (vector<4xi64>) -> vector<32xi8>
  %3337 = "llvm.call_intrinsic"(%3334, %3335, %3336) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3338 = "llvm.bitcast"(%3337) : (vector<32xi8>) -> vector<4xi64>
  %3339 = "llvm.bitcast"(%3318) : (vector<4xi64>) -> vector<32xi8>
  %3340 = "llvm.bitcast"(%3330) : (vector<4xi64>) -> vector<32xi8>
  %3341 = "llvm.call_intrinsic"(%3339, %3340, %3336) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3342 = "llvm.bitcast"(%3341) : (vector<32xi8>) -> vector<4xi64>
  %3343 = "llvm.bitcast"(%3321) : (vector<4xi64>) -> vector<32xi8>
  %3344 = "llvm.bitcast"(%3331) : (vector<4xi64>) -> vector<32xi8>
  %3345 = "llvm.call_intrinsic"(%3343, %3344, %3336) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3346 = "llvm.bitcast"(%3345) : (vector<32xi8>) -> vector<4xi64>
  %3347 = "llvm.bitcast"(%3324) : (vector<4xi64>) -> vector<32xi8>
  %3348 = "llvm.bitcast"(%3332) : (vector<4xi64>) -> vector<32xi8>
  %3349 = "llvm.call_intrinsic"(%3347, %3348, %3336) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3350 = "llvm.bitcast"(%3349) : (vector<32xi8>) -> vector<4xi64>
  %3351 = "llvm.bitcast"(%3327) : (vector<4xi64>) -> vector<32xi8>
  %3352 = "llvm.bitcast"(%3333) : (vector<4xi64>) -> vector<32xi8>
  %3353 = "llvm.call_intrinsic"(%3351, %3352, %3336) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3354 = "llvm.bitcast"(%3353) : (vector<32xi8>) -> vector<4xi64>
  %3355 = "llvm.add"(%3316, %3338) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3356 = "llvm.add"(%3319, %3342) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3357 = "llvm.add"(%3322, %3346) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3358 = "llvm.add"(%3325, %3350) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3359 = "llvm.add"(%3328, %3354) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3360 = "llvm.call"(%3281, %3281, %3282, %3282) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wc_bcast_wide, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (i32, i32, i32, i32) -> vector<4xi64>
  %3361 = "llvm.bitcast"(%3355) : (vector<4xi64>) -> vector<32xi8>
  %3362 = "llvm.bitcast"(%3360) : (vector<4xi64>) -> vector<32xi8>
  %3363 = "llvm.call_intrinsic"(%3334, %3361, %3362) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3364 = "llvm.bitcast"(%3363) : (vector<32xi8>) -> vector<4xi64>
  %3365 = "llvm.bitcast"(%3356) : (vector<4xi64>) -> vector<32xi8>
  %3366 = "llvm.call_intrinsic"(%3339, %3365, %3362) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3367 = "llvm.bitcast"(%3366) : (vector<32xi8>) -> vector<4xi64>
  %3368 = "llvm.bitcast"(%3357) : (vector<4xi64>) -> vector<32xi8>
  %3369 = "llvm.call_intrinsic"(%3343, %3368, %3362) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3370 = "llvm.bitcast"(%3369) : (vector<32xi8>) -> vector<4xi64>
  %3371 = "llvm.bitcast"(%3358) : (vector<4xi64>) -> vector<32xi8>
  %3372 = "llvm.call_intrinsic"(%3347, %3371, %3362) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3373 = "llvm.bitcast"(%3372) : (vector<32xi8>) -> vector<4xi64>
  %3374 = "llvm.bitcast"(%3359) : (vector<4xi64>) -> vector<32xi8>
  %3375 = "llvm.call_intrinsic"(%3351, %3374, %3362) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3376 = "llvm.bitcast"(%3375) : (vector<32xi8>) -> vector<4xi64>
  %3377 = "llvm.lshr"(%3364, %3287) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3378 = "llvm.lshr"(%3367, %3287) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3379 = "llvm.lshr"(%3370, %3287) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3380 = "llvm.lshr"(%3373, %3287) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3381 = "llvm.lshr"(%3376, %3287) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3382 = "llvm.bitcast"(%3363) : (vector<32xi8>) -> vector<4xi64>
  %3383 = "llvm.and"(%3382, %3288) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3384 = "llvm.call_intrinsic"(%3383, %3381, %3289) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3385 = "llvm.bitcast"(%3366) : (vector<32xi8>) -> vector<4xi64>
  %3386 = "llvm.and"(%3385, %3288) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3387 = "llvm.add"(%3386, %3377) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3388 = "llvm.bitcast"(%3369) : (vector<32xi8>) -> vector<4xi64>
  %3389 = "llvm.and"(%3388, %3288) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3390 = "llvm.add"(%3389, %3378) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3391 = "llvm.bitcast"(%3372) : (vector<32xi8>) -> vector<4xi64>
  %3392 = "llvm.and"(%3391, %3288) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3393 = "llvm.add"(%3392, %3379) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3394 = "llvm.bitcast"(%3375) : (vector<32xi8>) -> vector<4xi64>
  %3395 = "llvm.and"(%3394, %3288) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3396 = "llvm.add"(%3395, %3380) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%3293) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3294) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3295) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3296) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3297) : (!llvm.ptr) -> ()
  %3397 = "llvm.load"(%arg129) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %3398 = "llvm.getelementptr"(%arg129) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %3399 = "llvm.load"(%3398) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %3400 = "llvm.getelementptr"(%arg129) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %3401 = "llvm.load"(%3400) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %3402 = "llvm.getelementptr"(%arg129) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %3403 = "llvm.load"(%3402) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %3404 = "llvm.getelementptr"(%arg129) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %3405 = "llvm.load"(%3404) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.call"(%3293, %3294, %3295, %3296, %3297, %3384, %3387, %3390, %3393, %3396, %3397, %3399, %3401, %3403, %3405) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %3406 = "llvm.load"(%3293) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %3407 = "llvm.load"(%3294) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %3408 = "llvm.load"(%3295) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %3409 = "llvm.load"(%3296) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %3410 = "llvm.load"(%3297) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%3297) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3296) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3295) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3294) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3293) : (!llvm.ptr) -> ()
  %3411 = "llvm.call"(%3406, %3282, %3281, %3283, %3284) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3412 = "llvm.call"(%3407, %3282, %3281, %3283, %3284) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3413 = "llvm.call"(%3408, %3282, %3281, %3283, %3284) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3414 = "llvm.call"(%3409, %3282, %3281, %3283, %3284) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3415 = "llvm.call"(%3410, %3282, %3281, %3283, %3284) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3416 = "llvm.call"(%3411, %3281, %3282, %3283, %3284) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3417 = "llvm.call"(%3412, %3281, %3282, %3283, %3284) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3418 = "llvm.call"(%3413, %3281, %3282, %3283, %3284) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3419 = "llvm.call"(%3414, %3281, %3282, %3283, %3284) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3420 = "llvm.call"(%3415, %3281, %3282, %3283, %3284) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3421 = "llvm.sub"(%3285, %3411) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3422 = "llvm.sub"(%3286, %3412) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3423 = "llvm.sub"(%3286, %3413) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3424 = "llvm.sub"(%3286, %3414) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3425 = "llvm.sub"(%3286, %3415) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3426 = "llvm.bitcast"(%3411) : (vector<4xi64>) -> vector<32xi8>
  %3427 = "llvm.bitcast"(%3421) : (vector<4xi64>) -> vector<32xi8>
  %3428 = "llvm.call_intrinsic"(%3426, %3427, %3336) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3429 = "llvm.bitcast"(%3428) : (vector<32xi8>) -> vector<4xi64>
  %3430 = "llvm.bitcast"(%3412) : (vector<4xi64>) -> vector<32xi8>
  %3431 = "llvm.bitcast"(%3422) : (vector<4xi64>) -> vector<32xi8>
  %3432 = "llvm.call_intrinsic"(%3430, %3431, %3336) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3433 = "llvm.bitcast"(%3432) : (vector<32xi8>) -> vector<4xi64>
  %3434 = "llvm.bitcast"(%3413) : (vector<4xi64>) -> vector<32xi8>
  %3435 = "llvm.bitcast"(%3423) : (vector<4xi64>) -> vector<32xi8>
  %3436 = "llvm.call_intrinsic"(%3434, %3435, %3336) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3437 = "llvm.bitcast"(%3436) : (vector<32xi8>) -> vector<4xi64>
  %3438 = "llvm.bitcast"(%3414) : (vector<4xi64>) -> vector<32xi8>
  %3439 = "llvm.bitcast"(%3424) : (vector<4xi64>) -> vector<32xi8>
  %3440 = "llvm.call_intrinsic"(%3438, %3439, %3336) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3441 = "llvm.bitcast"(%3440) : (vector<32xi8>) -> vector<4xi64>
  %3442 = "llvm.bitcast"(%3415) : (vector<4xi64>) -> vector<32xi8>
  %3443 = "llvm.bitcast"(%3425) : (vector<4xi64>) -> vector<32xi8>
  %3444 = "llvm.call_intrinsic"(%3442, %3443, %3336) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3445 = "llvm.bitcast"(%3444) : (vector<32xi8>) -> vector<4xi64>
  %3446 = "llvm.add"(%3416, %3429) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3447 = "llvm.add"(%3417, %3433) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3448 = "llvm.add"(%3418, %3437) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3449 = "llvm.add"(%3419, %3441) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3450 = "llvm.add"(%3420, %3445) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3451 = "llvm.lshr"(%3446, %3287) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3452 = "llvm.lshr"(%3447, %3287) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3453 = "llvm.lshr"(%3448, %3287) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3454 = "llvm.lshr"(%3449, %3287) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3455 = "llvm.lshr"(%3450, %3287) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3456 = "llvm.and"(%3446, %3288) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3457 = "llvm.call_intrinsic"(%3456, %3455, %3289) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3458 = "llvm.and"(%3447, %3288) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3459 = "llvm.add"(%3458, %3451) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3460 = "llvm.and"(%3448, %3288) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3461 = "llvm.add"(%3460, %3452) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3462 = "llvm.and"(%3449, %3288) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3463 = "llvm.add"(%3462, %3453) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3464 = "llvm.and"(%3450, %3288) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3465 = "llvm.add"(%3464, %3454) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3466 = "llvm.call"(%3457, %3282, %3283, %3283, %3282) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3467 = "llvm.call"(%3459, %3282, %3283, %3283, %3282) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3468 = "llvm.call"(%3461, %3282, %3283, %3283, %3282) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3469 = "llvm.call"(%3463, %3282, %3283, %3283, %3282) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3470 = "llvm.call"(%3465, %3282, %3283, %3283, %3282) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3471 = "llvm.call"(%3457, %3284, %3281, %3284, %3281) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3472 = "llvm.call"(%3459, %3284, %3281, %3284, %3281) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3473 = "llvm.call"(%3461, %3284, %3281, %3284, %3281) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3474 = "llvm.call"(%3463, %3284, %3281, %3284, %3281) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3475 = "llvm.call"(%3465, %3284, %3281, %3284, %3281) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%3298) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3299) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3300) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3301) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3302) : (!llvm.ptr) -> ()
  "llvm.call"(%3298, %3299, %3300, %3301, %3302, %3466, %3467, %3468, %3469, %3470, %3471, %3472, %3473, %3474, %3475) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %3476 = "llvm.load"(%3298) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %3477 = "llvm.load"(%3299) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %3478 = "llvm.getelementptr"(%arg127) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %3479 = "llvm.load"(%3300) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %3480 = "llvm.getelementptr"(%arg127) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %3481 = "llvm.load"(%3301) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %3482 = "llvm.getelementptr"(%arg127) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %3483 = "llvm.load"(%3302) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %3484 = "llvm.getelementptr"(%arg127) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.lifetime.end"(%3302) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3301) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3300) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3299) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3298) : (!llvm.ptr) -> ()
  %3485 = "llvm.lshr"(%3476, %3287) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3486 = "llvm.lshr"(%3477, %3287) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3487 = "llvm.lshr"(%3479, %3287) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3488 = "llvm.lshr"(%3481, %3287) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3489 = "llvm.lshr"(%3483, %3287) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3490 = "llvm.and"(%3476, %3288) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3491 = "llvm.call_intrinsic"(%3490, %3489, %3289) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.store"(%3491, %arg127) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<4xi64>, !llvm.ptr) -> ()
  %3492 = "llvm.and"(%3477, %3288) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3493 = "llvm.add"(%3492, %3485) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.store"(%3493, %3478) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<4xi64>, !llvm.ptr) -> ()
  %3494 = "llvm.and"(%3479, %3288) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3495 = "llvm.add"(%3494, %3486) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.store"(%3495, %3480) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<4xi64>, !llvm.ptr) -> ()
  %3496 = "llvm.and"(%3481, %3288) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3497 = "llvm.add"(%3496, %3487) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.store"(%3497, %3482) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<4xi64>, !llvm.ptr) -> ()
  %3498 = "llvm.and"(%3483, %3288) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3499 = "llvm.add"(%3498, %3488) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.store"(%3499, %3484) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.br"()[^bb3] : () -> ()
^bb2:  // pred: ^bb0
  %3500 = "llvm.load"(%arg129) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %3501 = "llvm.call"(%3500, %3281, %3282, %3283, %3284) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3502 = "llvm.getelementptr"(%arg129) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %3503 = "llvm.load"(%3502) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %3504 = "llvm.call"(%3503, %3281, %3282, %3283, %3284) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3505 = "llvm.getelementptr"(%arg129) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %3506 = "llvm.load"(%3505) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %3507 = "llvm.call"(%3506, %3281, %3282, %3283, %3284) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3508 = "llvm.getelementptr"(%arg129) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %3509 = "llvm.load"(%3508) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %3510 = "llvm.call"(%3509, %3281, %3282, %3283, %3284) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3511 = "llvm.getelementptr"(%arg129) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %3512 = "llvm.load"(%3511) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %3513 = "llvm.call"(%3512, %3281, %3282, %3283, %3284) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3514 = "llvm.sub"(%3285, %3500) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3515 = "llvm.sub"(%3286, %3503) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3516 = "llvm.sub"(%3286, %3506) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3517 = "llvm.sub"(%3286, %3509) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3518 = "llvm.sub"(%3286, %3512) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3519 = "llvm.bitcast"(%3500) : (vector<4xi64>) -> vector<32xi8>
  %3520 = "llvm.bitcast"(%3514) : (vector<4xi64>) -> vector<32xi8>
  %3521 = "llvm.bitcast"(%3314) : (vector<4xi64>) -> vector<32xi8>
  %3522 = "llvm.call_intrinsic"(%3519, %3520, %3521) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3523 = "llvm.bitcast"(%3522) : (vector<32xi8>) -> vector<4xi64>
  %3524 = "llvm.bitcast"(%3503) : (vector<4xi64>) -> vector<32xi8>
  %3525 = "llvm.bitcast"(%3515) : (vector<4xi64>) -> vector<32xi8>
  %3526 = "llvm.call_intrinsic"(%3524, %3525, %3521) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3527 = "llvm.bitcast"(%3526) : (vector<32xi8>) -> vector<4xi64>
  %3528 = "llvm.bitcast"(%3506) : (vector<4xi64>) -> vector<32xi8>
  %3529 = "llvm.bitcast"(%3516) : (vector<4xi64>) -> vector<32xi8>
  %3530 = "llvm.call_intrinsic"(%3528, %3529, %3521) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3531 = "llvm.bitcast"(%3530) : (vector<32xi8>) -> vector<4xi64>
  %3532 = "llvm.bitcast"(%3509) : (vector<4xi64>) -> vector<32xi8>
  %3533 = "llvm.bitcast"(%3517) : (vector<4xi64>) -> vector<32xi8>
  %3534 = "llvm.call_intrinsic"(%3532, %3533, %3521) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3535 = "llvm.bitcast"(%3534) : (vector<32xi8>) -> vector<4xi64>
  %3536 = "llvm.bitcast"(%3512) : (vector<4xi64>) -> vector<32xi8>
  %3537 = "llvm.bitcast"(%3518) : (vector<4xi64>) -> vector<32xi8>
  %3538 = "llvm.call_intrinsic"(%3536, %3537, %3521) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3539 = "llvm.bitcast"(%3538) : (vector<32xi8>) -> vector<4xi64>
  %3540 = "llvm.add"(%3501, %3523) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3541 = "llvm.add"(%3504, %3527) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3542 = "llvm.add"(%3507, %3531) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3543 = "llvm.add"(%3510, %3535) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3544 = "llvm.add"(%3513, %3539) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3545 = "llvm.call"(%3281, %3281, %3282, %3282) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wc_bcast_wide, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (i32, i32, i32, i32) -> vector<4xi64>
  %3546 = "llvm.bitcast"(%3540) : (vector<4xi64>) -> vector<32xi8>
  %3547 = "llvm.bitcast"(%3545) : (vector<4xi64>) -> vector<32xi8>
  %3548 = "llvm.call_intrinsic"(%3519, %3546, %3547) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3549 = "llvm.bitcast"(%3548) : (vector<32xi8>) -> vector<4xi64>
  %3550 = "llvm.bitcast"(%3541) : (vector<4xi64>) -> vector<32xi8>
  %3551 = "llvm.call_intrinsic"(%3524, %3550, %3547) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3552 = "llvm.bitcast"(%3551) : (vector<32xi8>) -> vector<4xi64>
  %3553 = "llvm.bitcast"(%3542) : (vector<4xi64>) -> vector<32xi8>
  %3554 = "llvm.call_intrinsic"(%3528, %3553, %3547) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3555 = "llvm.bitcast"(%3554) : (vector<32xi8>) -> vector<4xi64>
  %3556 = "llvm.bitcast"(%3543) : (vector<4xi64>) -> vector<32xi8>
  %3557 = "llvm.call_intrinsic"(%3532, %3556, %3547) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3558 = "llvm.bitcast"(%3557) : (vector<32xi8>) -> vector<4xi64>
  %3559 = "llvm.bitcast"(%3544) : (vector<4xi64>) -> vector<32xi8>
  %3560 = "llvm.call_intrinsic"(%3536, %3559, %3547) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3561 = "llvm.bitcast"(%3560) : (vector<32xi8>) -> vector<4xi64>
  %3562 = "llvm.lshr"(%3549, %3287) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3563 = "llvm.lshr"(%3552, %3287) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3564 = "llvm.lshr"(%3555, %3287) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3565 = "llvm.lshr"(%3558, %3287) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3566 = "llvm.lshr"(%3561, %3287) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3567 = "llvm.bitcast"(%3548) : (vector<32xi8>) -> vector<4xi64>
  %3568 = "llvm.and"(%3567, %3288) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3569 = "llvm.call_intrinsic"(%3568, %3566, %3289) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3570 = "llvm.bitcast"(%3551) : (vector<32xi8>) -> vector<4xi64>
  %3571 = "llvm.and"(%3570, %3288) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3572 = "llvm.add"(%3571, %3562) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3573 = "llvm.bitcast"(%3554) : (vector<32xi8>) -> vector<4xi64>
  %3574 = "llvm.and"(%3573, %3288) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3575 = "llvm.add"(%3574, %3563) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3576 = "llvm.bitcast"(%3557) : (vector<32xi8>) -> vector<4xi64>
  %3577 = "llvm.and"(%3576, %3288) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3578 = "llvm.add"(%3577, %3564) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3579 = "llvm.bitcast"(%3560) : (vector<32xi8>) -> vector<4xi64>
  %3580 = "llvm.and"(%3579, %3288) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3581 = "llvm.add"(%3580, %3565) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3582 = "llvm.call_intrinsic"(%3290, %3291, %3569) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3583 = "llvm.call_intrinsic"(%3290, %3291, %3569) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3584 = "llvm.call_intrinsic"(%3290, %3291, %3572) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3585 = "llvm.call_intrinsic"(%3290, %3291, %3575) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3586 = "llvm.call_intrinsic"(%3290, %3291, %3578) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3587 = "llvm.call_intrinsic"(%3290, %3291, %3581) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3588 = "llvm.shl"(%3587, %3292) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3589 = "llvm.call_intrinsic"(%3582, %3588, %3289) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3590 = "llvm.call_intrinsic"(%3583, %3291, %3572) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3591 = "llvm.add"(%3590, %3583) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3592 = "llvm.call_intrinsic"(%3584, %3291, %3575) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3593 = "llvm.add"(%3592, %3584) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3594 = "llvm.call_intrinsic"(%3585, %3291, %3578) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3595 = "llvm.add"(%3594, %3585) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3596 = "llvm.call_intrinsic"(%3586, %3291, %3581) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3597 = "llvm.add"(%3596, %3586) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3598 = "llvm.sub"(%3285, %3589) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3599 = "llvm.sub"(%3286, %3591) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3600 = "llvm.sub"(%3286, %3593) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3601 = "llvm.sub"(%3286, %3595) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3602 = "llvm.sub"(%3286, %3597) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3603 = "llvm.call"(%3282, %3282, %3282, %3281) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wc_bcast_wide, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (i32, i32, i32, i32) -> vector<4xi64>
  %3604 = "llvm.bitcast"(%3589) : (vector<4xi64>) -> vector<32xi8>
  %3605 = "llvm.bitcast"(%3598) : (vector<4xi64>) -> vector<32xi8>
  %3606 = "llvm.bitcast"(%3603) : (vector<4xi64>) -> vector<32xi8>
  %3607 = "llvm.call_intrinsic"(%3604, %3605, %3606) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3608 = "llvm.bitcast"(%3607) : (vector<32xi8>) -> vector<4xi64>
  %3609 = "llvm.bitcast"(%3591) : (vector<4xi64>) -> vector<32xi8>
  %3610 = "llvm.bitcast"(%3599) : (vector<4xi64>) -> vector<32xi8>
  %3611 = "llvm.call_intrinsic"(%3609, %3610, %3606) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3612 = "llvm.bitcast"(%3611) : (vector<32xi8>) -> vector<4xi64>
  %3613 = "llvm.bitcast"(%3593) : (vector<4xi64>) -> vector<32xi8>
  %3614 = "llvm.bitcast"(%3600) : (vector<4xi64>) -> vector<32xi8>
  %3615 = "llvm.call_intrinsic"(%3613, %3614, %3606) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3616 = "llvm.bitcast"(%3615) : (vector<32xi8>) -> vector<4xi64>
  %3617 = "llvm.bitcast"(%3595) : (vector<4xi64>) -> vector<32xi8>
  %3618 = "llvm.bitcast"(%3601) : (vector<4xi64>) -> vector<32xi8>
  %3619 = "llvm.call_intrinsic"(%3617, %3618, %3606) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3620 = "llvm.bitcast"(%3619) : (vector<32xi8>) -> vector<4xi64>
  %3621 = "llvm.bitcast"(%3597) : (vector<4xi64>) -> vector<32xi8>
  %3622 = "llvm.bitcast"(%3602) : (vector<4xi64>) -> vector<32xi8>
  %3623 = "llvm.call_intrinsic"(%3621, %3622, %3606) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3624 = "llvm.bitcast"(%3623) : (vector<32xi8>) -> vector<4xi64>
  %3625 = "llvm.lshr"(%3608, %3287) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3626 = "llvm.lshr"(%3612, %3287) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3627 = "llvm.lshr"(%3616, %3287) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3628 = "llvm.lshr"(%3620, %3287) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3629 = "llvm.lshr"(%3624, %3287) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3630 = "llvm.bitcast"(%3607) : (vector<32xi8>) -> vector<4xi64>
  %3631 = "llvm.and"(%3630, %3288) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3632 = "llvm.call_intrinsic"(%3631, %3629, %3289) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3633 = "llvm.bitcast"(%3611) : (vector<32xi8>) -> vector<4xi64>
  %3634 = "llvm.and"(%3633, %3288) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3635 = "llvm.add"(%3634, %3625) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3636 = "llvm.bitcast"(%3615) : (vector<32xi8>) -> vector<4xi64>
  %3637 = "llvm.and"(%3636, %3288) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3638 = "llvm.add"(%3637, %3626) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3639 = "llvm.bitcast"(%3619) : (vector<32xi8>) -> vector<4xi64>
  %3640 = "llvm.and"(%3639, %3288) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3641 = "llvm.add"(%3640, %3627) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3642 = "llvm.bitcast"(%3623) : (vector<32xi8>) -> vector<4xi64>
  %3643 = "llvm.and"(%3642, %3288) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3644 = "llvm.add"(%3643, %3628) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3645 = "llvm.load"(%arg128) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %3646 = "llvm.call"(%3645, %3281, %3282, %3283, %3284) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3647 = "llvm.getelementptr"(%arg128) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %3648 = "llvm.load"(%3647) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %3649 = "llvm.call"(%3648, %3281, %3282, %3283, %3284) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3650 = "llvm.getelementptr"(%arg128) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %3651 = "llvm.load"(%3650) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %3652 = "llvm.call"(%3651, %3281, %3282, %3283, %3284) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3653 = "llvm.getelementptr"(%arg128) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %3654 = "llvm.load"(%3653) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %3655 = "llvm.call"(%3654, %3281, %3282, %3283, %3284) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3656 = "llvm.getelementptr"(%arg128) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %3657 = "llvm.load"(%3656) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %3658 = "llvm.call"(%3657, %3281, %3282, %3283, %3284) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3659 = "llvm.sub"(%3285, %3645) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3660 = "llvm.sub"(%3286, %3648) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3661 = "llvm.sub"(%3286, %3651) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3662 = "llvm.sub"(%3286, %3654) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3663 = "llvm.sub"(%3286, %3657) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3664 = "llvm.bitcast"(%3645) : (vector<4xi64>) -> vector<32xi8>
  %3665 = "llvm.bitcast"(%3659) : (vector<4xi64>) -> vector<32xi8>
  %3666 = "llvm.call_intrinsic"(%3664, %3665, %3521) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3667 = "llvm.bitcast"(%3666) : (vector<32xi8>) -> vector<4xi64>
  %3668 = "llvm.bitcast"(%3648) : (vector<4xi64>) -> vector<32xi8>
  %3669 = "llvm.bitcast"(%3660) : (vector<4xi64>) -> vector<32xi8>
  %3670 = "llvm.call_intrinsic"(%3668, %3669, %3521) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3671 = "llvm.bitcast"(%3670) : (vector<32xi8>) -> vector<4xi64>
  %3672 = "llvm.bitcast"(%3651) : (vector<4xi64>) -> vector<32xi8>
  %3673 = "llvm.bitcast"(%3661) : (vector<4xi64>) -> vector<32xi8>
  %3674 = "llvm.call_intrinsic"(%3672, %3673, %3521) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3675 = "llvm.bitcast"(%3674) : (vector<32xi8>) -> vector<4xi64>
  %3676 = "llvm.bitcast"(%3654) : (vector<4xi64>) -> vector<32xi8>
  %3677 = "llvm.bitcast"(%3662) : (vector<4xi64>) -> vector<32xi8>
  %3678 = "llvm.call_intrinsic"(%3676, %3677, %3521) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3679 = "llvm.bitcast"(%3678) : (vector<32xi8>) -> vector<4xi64>
  %3680 = "llvm.bitcast"(%3657) : (vector<4xi64>) -> vector<32xi8>
  %3681 = "llvm.bitcast"(%3663) : (vector<4xi64>) -> vector<32xi8>
  %3682 = "llvm.call_intrinsic"(%3680, %3681, %3521) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3683 = "llvm.bitcast"(%3682) : (vector<32xi8>) -> vector<4xi64>
  %3684 = "llvm.add"(%3646, %3667) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3685 = "llvm.add"(%3649, %3671) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3686 = "llvm.add"(%3652, %3675) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3687 = "llvm.add"(%3655, %3679) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3688 = "llvm.add"(%3658, %3683) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3689 = "llvm.bitcast"(%3684) : (vector<4xi64>) -> vector<32xi8>
  %3690 = "llvm.call_intrinsic"(%3664, %3689, %3547) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3691 = "llvm.bitcast"(%3690) : (vector<32xi8>) -> vector<4xi64>
  %3692 = "llvm.bitcast"(%3685) : (vector<4xi64>) -> vector<32xi8>
  %3693 = "llvm.call_intrinsic"(%3668, %3692, %3547) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3694 = "llvm.bitcast"(%3693) : (vector<32xi8>) -> vector<4xi64>
  %3695 = "llvm.bitcast"(%3686) : (vector<4xi64>) -> vector<32xi8>
  %3696 = "llvm.call_intrinsic"(%3672, %3695, %3547) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3697 = "llvm.bitcast"(%3696) : (vector<32xi8>) -> vector<4xi64>
  %3698 = "llvm.bitcast"(%3687) : (vector<4xi64>) -> vector<32xi8>
  %3699 = "llvm.call_intrinsic"(%3676, %3698, %3547) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3700 = "llvm.bitcast"(%3699) : (vector<32xi8>) -> vector<4xi64>
  %3701 = "llvm.bitcast"(%3688) : (vector<4xi64>) -> vector<32xi8>
  %3702 = "llvm.call_intrinsic"(%3680, %3701, %3547) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3703 = "llvm.bitcast"(%3702) : (vector<32xi8>) -> vector<4xi64>
  %3704 = "llvm.lshr"(%3691, %3287) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3705 = "llvm.lshr"(%3694, %3287) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3706 = "llvm.lshr"(%3697, %3287) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3707 = "llvm.lshr"(%3700, %3287) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3708 = "llvm.lshr"(%3703, %3287) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3709 = "llvm.bitcast"(%3690) : (vector<32xi8>) -> vector<4xi64>
  %3710 = "llvm.and"(%3709, %3288) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3711 = "llvm.call_intrinsic"(%3710, %3708, %3289) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3712 = "llvm.bitcast"(%3693) : (vector<32xi8>) -> vector<4xi64>
  %3713 = "llvm.and"(%3712, %3288) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3714 = "llvm.add"(%3713, %3704) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3715 = "llvm.bitcast"(%3696) : (vector<32xi8>) -> vector<4xi64>
  %3716 = "llvm.and"(%3715, %3288) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3717 = "llvm.add"(%3716, %3705) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3718 = "llvm.bitcast"(%3699) : (vector<32xi8>) -> vector<4xi64>
  %3719 = "llvm.and"(%3718, %3288) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3720 = "llvm.add"(%3719, %3706) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3721 = "llvm.bitcast"(%3702) : (vector<32xi8>) -> vector<4xi64>
  %3722 = "llvm.and"(%3721, %3288) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3723 = "llvm.add"(%3722, %3707) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%3303) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3304) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3305) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3306) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3307) : (!llvm.ptr) -> ()
  "llvm.call"(%3303, %3304, %3305, %3306, %3307, %3711, %3714, %3717, %3720, %3723, %3632, %3635, %3638, %3641, %3644) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %3724 = "llvm.load"(%3303) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %3725 = "llvm.load"(%3304) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %3726 = "llvm.load"(%3305) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %3727 = "llvm.load"(%3306) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %3728 = "llvm.load"(%3307) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%3307) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3306) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3305) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3304) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3303) : (!llvm.ptr) -> ()
  %3729 = "llvm.call"(%3724, %3282, %3281, %3283, %3284) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3730 = "llvm.call"(%3725, %3282, %3281, %3283, %3284) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3731 = "llvm.call"(%3726, %3282, %3281, %3283, %3284) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3732 = "llvm.call"(%3727, %3282, %3281, %3283, %3284) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3733 = "llvm.call"(%3728, %3282, %3281, %3283, %3284) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3734 = "llvm.call"(%3729, %3281, %3282, %3283, %3284) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3735 = "llvm.call"(%3730, %3281, %3282, %3283, %3284) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3736 = "llvm.call"(%3731, %3281, %3282, %3283, %3284) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3737 = "llvm.call"(%3732, %3281, %3282, %3283, %3284) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3738 = "llvm.call"(%3733, %3281, %3282, %3283, %3284) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3739 = "llvm.sub"(%3285, %3729) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3740 = "llvm.sub"(%3286, %3730) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3741 = "llvm.sub"(%3286, %3731) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3742 = "llvm.sub"(%3286, %3732) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3743 = "llvm.sub"(%3286, %3733) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3744 = "llvm.bitcast"(%3729) : (vector<4xi64>) -> vector<32xi8>
  %3745 = "llvm.bitcast"(%3739) : (vector<4xi64>) -> vector<32xi8>
  %3746 = "llvm.call_intrinsic"(%3744, %3745, %3521) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3747 = "llvm.bitcast"(%3746) : (vector<32xi8>) -> vector<4xi64>
  %3748 = "llvm.bitcast"(%3730) : (vector<4xi64>) -> vector<32xi8>
  %3749 = "llvm.bitcast"(%3740) : (vector<4xi64>) -> vector<32xi8>
  %3750 = "llvm.call_intrinsic"(%3748, %3749, %3521) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3751 = "llvm.bitcast"(%3750) : (vector<32xi8>) -> vector<4xi64>
  %3752 = "llvm.bitcast"(%3731) : (vector<4xi64>) -> vector<32xi8>
  %3753 = "llvm.bitcast"(%3741) : (vector<4xi64>) -> vector<32xi8>
  %3754 = "llvm.call_intrinsic"(%3752, %3753, %3521) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3755 = "llvm.bitcast"(%3754) : (vector<32xi8>) -> vector<4xi64>
  %3756 = "llvm.bitcast"(%3732) : (vector<4xi64>) -> vector<32xi8>
  %3757 = "llvm.bitcast"(%3742) : (vector<4xi64>) -> vector<32xi8>
  %3758 = "llvm.call_intrinsic"(%3756, %3757, %3521) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3759 = "llvm.bitcast"(%3758) : (vector<32xi8>) -> vector<4xi64>
  %3760 = "llvm.bitcast"(%3733) : (vector<4xi64>) -> vector<32xi8>
  %3761 = "llvm.bitcast"(%3743) : (vector<4xi64>) -> vector<32xi8>
  %3762 = "llvm.call_intrinsic"(%3760, %3761, %3521) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %3763 = "llvm.bitcast"(%3762) : (vector<32xi8>) -> vector<4xi64>
  %3764 = "llvm.add"(%3734, %3747) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3765 = "llvm.add"(%3735, %3751) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3766 = "llvm.add"(%3736, %3755) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3767 = "llvm.add"(%3737, %3759) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3768 = "llvm.add"(%3738, %3763) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3769 = "llvm.lshr"(%3764, %3287) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3770 = "llvm.lshr"(%3765, %3287) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3771 = "llvm.lshr"(%3766, %3287) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3772 = "llvm.lshr"(%3767, %3287) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3773 = "llvm.lshr"(%3768, %3287) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3774 = "llvm.and"(%3764, %3288) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3775 = "llvm.call_intrinsic"(%3774, %3773, %3289) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3776 = "llvm.and"(%3765, %3288) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3777 = "llvm.add"(%3776, %3769) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3778 = "llvm.and"(%3766, %3288) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3779 = "llvm.add"(%3778, %3770) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3780 = "llvm.and"(%3767, %3288) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3781 = "llvm.add"(%3780, %3771) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3782 = "llvm.and"(%3768, %3288) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3783 = "llvm.add"(%3782, %3772) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3784 = "llvm.call"(%3775, %3282, %3283, %3283, %3282) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3785 = "llvm.call"(%3777, %3282, %3283, %3283, %3282) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3786 = "llvm.call"(%3779, %3282, %3283, %3283, %3282) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3787 = "llvm.call"(%3781, %3282, %3283, %3283, %3282) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3788 = "llvm.call"(%3783, %3282, %3283, %3283, %3282) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3789 = "llvm.call"(%3775, %3284, %3281, %3284, %3281) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3790 = "llvm.call"(%3777, %3284, %3281, %3284, %3281) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3791 = "llvm.call"(%3779, %3284, %3281, %3284, %3281) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3792 = "llvm.call"(%3781, %3284, %3281, %3284, %3281) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %3793 = "llvm.call"(%3783, %3284, %3281, %3284, %3281) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%3308) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3309) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3310) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3311) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3312) : (!llvm.ptr) -> ()
  "llvm.call"(%3308, %3309, %3310, %3311, %3312, %3784, %3785, %3786, %3787, %3788, %3789, %3790, %3791, %3792, %3793) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %3794 = "llvm.load"(%3308) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %3795 = "llvm.load"(%3309) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %3796 = "llvm.getelementptr"(%arg127) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %3797 = "llvm.load"(%3310) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %3798 = "llvm.getelementptr"(%arg127) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %3799 = "llvm.load"(%3311) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %3800 = "llvm.getelementptr"(%arg127) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %3801 = "llvm.load"(%3312) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %3802 = "llvm.getelementptr"(%arg127) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.lifetime.end"(%3312) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3311) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3310) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3309) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3308) : (!llvm.ptr) -> ()
  %3803 = "llvm.lshr"(%3794, %3287) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3804 = "llvm.lshr"(%3795, %3287) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3805 = "llvm.lshr"(%3797, %3287) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3806 = "llvm.lshr"(%3799, %3287) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3807 = "llvm.lshr"(%3801, %3287) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3808 = "llvm.and"(%3794, %3288) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3809 = "llvm.call_intrinsic"(%3808, %3807, %3289) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.store"(%3809, %arg127) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<4xi64>, !llvm.ptr) -> ()
  %3810 = "llvm.and"(%3795, %3288) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3811 = "llvm.add"(%3810, %3803) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.store"(%3811, %3796) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<4xi64>, !llvm.ptr) -> ()
  %3812 = "llvm.and"(%3797, %3288) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3813 = "llvm.add"(%3812, %3804) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.store"(%3813, %3798) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<4xi64>, !llvm.ptr) -> ()
  %3814 = "llvm.and"(%3799, %3288) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3815 = "llvm.add"(%3814, %3805) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.store"(%3815, %3800) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<4xi64>, !llvm.ptr) -> ()
  %3816 = "llvm.and"(%3801, %3288) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3817 = "llvm.add"(%3816, %3806) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.store"(%3817, %3802) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.br"()[^bb3] : () -> ()
^bb3:  // 2 preds: ^bb1, ^bb2
  "llvm.return"(%arg127) : (!llvm.ptr) -> ()
}) : () -> ()
  with @fd_r52x5_quad_mul_fast := fd_r52x5_quad_mul_fast, @wc_bcast_wide := wc_bcast_wide,
    @wl_permute := wl_permute

end

end MLIR.Firedancer.R52x5
