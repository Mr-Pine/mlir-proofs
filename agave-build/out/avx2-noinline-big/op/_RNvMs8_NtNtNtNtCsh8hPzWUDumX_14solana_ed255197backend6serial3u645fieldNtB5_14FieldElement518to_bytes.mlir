"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 1 : i64, llvm.dead_on_unwind, llvm.dereferenceable = 32 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writable, llvm.writeonly}, {llvm.align = 8 : i64, llvm.dead_on_return = -1 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], sym_name = "_RNvMs8_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u645fieldNtB5_14FieldElement518to_bytes", target_cpu = "x86-64-v2", target_features = #llvm.target_features<["+avx", "+avx2", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+crc32", "+ssse3"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg91: !llvm.ptr, %arg92: !llvm.ptr):
  %3317 = "llvm.mlir.constant"() <{value = 8 : i64}> : () -> i64
  %3318 = "llvm.mlir.constant"() <{value = 16 : i64}> : () -> i64
  %3319 = "llvm.mlir.constant"() <{value = 24 : i64}> : () -> i64
  %3320 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %3321 = "llvm.mlir.constant"() <{value = 51 : i64}> : () -> i64
  %3322 = "llvm.mlir.constant"() <{value = 2251799813685247 : i64}> : () -> i64
  %3323 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %3324 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %3325 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %3326 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %3327 = "llvm.mlir.constant"() <{value = 4 : i64}> : () -> i64
  %3328 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
  %3329 = "llvm.mlir.constant"() <{value = 5 : i64}> : () -> i64
  %3330 = "llvm.mlir.constant"() <{value = 48 : i64}> : () -> i64
  %3331 = "llvm.mlir.constant"() <{value = 7 : i64}> : () -> i64
  %3332 = "llvm.mlir.constant"() <{value = 6 : i64}> : () -> i64
  %3333 = "llvm.mlir.constant"() <{value = 13 : i64}> : () -> i64
  %3334 = "llvm.mlir.constant"() <{value = 21 : i64}> : () -> i64
  %3335 = "llvm.mlir.constant"() <{value = 29 : i64}> : () -> i64
  %3336 = "llvm.mlir.constant"() <{value = 10 : i64}> : () -> i64
  %3337 = "llvm.mlir.constant"() <{value = 37 : i64}> : () -> i64
  %3338 = "llvm.mlir.constant"() <{value = 45 : i64}> : () -> i64
  %3339 = "llvm.mlir.constant"() <{value = 12 : i64}> : () -> i64
  %3340 = "llvm.mlir.constant"() <{value = 18 : i64}> : () -> i64
  %3341 = "llvm.mlir.constant"() <{value = 15 : i64}> : () -> i64
  %3342 = "llvm.mlir.constant"() <{value = 26 : i64}> : () -> i64
  %3343 = "llvm.mlir.constant"() <{value = 34 : i64}> : () -> i64
  %3344 = "llvm.mlir.constant"() <{value = 42 : i64}> : () -> i64
  %3345 = "llvm.mlir.constant"() <{value = 50 : i64}> : () -> i64
  %3346 = "llvm.mlir.constant"() <{value = 20 : i64}> : () -> i64
  %3347 = "llvm.mlir.constant"() <{value = 23 : i64}> : () -> i64
  %3348 = "llvm.mlir.constant"() <{value = 31 : i64}> : () -> i64
  %3349 = "llvm.mlir.constant"() <{value = 39 : i64}> : () -> i64
  %3350 = "llvm.mlir.constant"() <{value = 47 : i64}> : () -> i64
  %3351 = "llvm.mlir.constant"() <{value = 28 : i64}> : () -> i64
  %3352 = "llvm.mlir.constant"() <{value = 36 : i64}> : () -> i64
  %3353 = "llvm.mlir.constant"() <{value = 44 : i64}> : () -> i64
  %3354 = "llvm.load"(%arg92) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3355 = "llvm.getelementptr"(%arg92) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %3356 = "llvm.load"(%3355) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3357 = "llvm.getelementptr"(%arg92) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %3358 = "llvm.load"(%3357) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3359 = "llvm.getelementptr"(%arg92) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %3360 = "llvm.load"(%3359) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3361 = "llvm.getelementptr"(%arg92) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %3362 = "llvm.load"(%3361) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3363 = "llvm.lshr"(%3354, %3321) : (i64, i64) -> i64
  %3364 = "llvm.lshr"(%3356, %3321) : (i64, i64) -> i64
  %3365 = "llvm.lshr"(%3358, %3321) : (i64, i64) -> i64
  %3366 = "llvm.lshr"(%3360, %3321) : (i64, i64) -> i64
  %3367 = "llvm.lshr"(%3362, %3321) : (i64, i64) -> i64
  %3368 = "llvm.and"(%3354, %3322) : (i64, i64) -> i64
  %3369 = "llvm.and"(%3356, %3322) : (i64, i64) -> i64
  %3370 = "llvm.and"(%3358, %3322) : (i64, i64) -> i64
  %3371 = "llvm.and"(%3360, %3322) : (i64, i64) -> i64
  %3372 = "llvm.and"(%3362, %3322) : (i64, i64) -> i64
  %3373 = "llvm.mul"(%3367, %3323) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %3374 = "llvm.add"(%3373, %3368) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %3375 = "llvm.add"(%3369, %3363) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %3376 = "llvm.add"(%3370, %3364) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %3377 = "llvm.add"(%3371, %3365) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %3378 = "llvm.add"(%3372, %3366) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %3379 = "llvm.add"(%3374, %3323) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %3380 = "llvm.lshr"(%3379, %3321) : (i64, i64) -> i64
  %3381 = "llvm.add"(%3380, %3375) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %3382 = "llvm.lshr"(%3381, %3321) : (i64, i64) -> i64
  %3383 = "llvm.add"(%3382, %3376) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %3384 = "llvm.lshr"(%3383, %3321) : (i64, i64) -> i64
  %3385 = "llvm.add"(%3384, %3377) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %3386 = "llvm.lshr"(%3385, %3321) : (i64, i64) -> i64
  %3387 = "llvm.add"(%3386, %3378) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %3388 = "llvm.lshr"(%3387, %3321) : (i64, i64) -> i64
  %3389 = "llvm.mul"(%3388, %3323) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %3390 = "llvm.add"(%3389, %3374) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %3391 = "llvm.lshr"(%3390, %3321) : (i64, i64) -> i64
  %3392 = "llvm.add"(%3391, %3375) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %3393 = "llvm.lshr"(%3392, %3321) : (i64, i64) -> i64
  %3394 = "llvm.add"(%3393, %3376) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %3395 = "llvm.and"(%3392, %3322) : (i64, i64) -> i64
  %3396 = "llvm.lshr"(%3394, %3321) : (i64, i64) -> i64
  %3397 = "llvm.add"(%3396, %3377) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %3398 = "llvm.and"(%3394, %3322) : (i64, i64) -> i64
  %3399 = "llvm.lshr"(%3397, %3321) : (i64, i64) -> i64
  %3400 = "llvm.add"(%3399, %3378) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %3401 = "llvm.and"(%3397, %3322) : (i64, i64) -> i64
  %3402 = "llvm.and"(%3400, %3322) : (i64, i64) -> i64
  %3403 = "llvm.trunc"(%3390) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%3403, %arg91) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %3404 = "llvm.lshr"(%3390, %3317) : (i64, i64) -> i64
  %3405 = "llvm.getelementptr"(%arg91) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1>}> : (!llvm.ptr) -> !llvm.ptr
  %3406 = "llvm.trunc"(%3404) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%3406, %3405) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %3407 = "llvm.lshr"(%3390, %3318) : (i64, i64) -> i64
  %3408 = "llvm.getelementptr"(%arg91) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2>}> : (!llvm.ptr) -> !llvm.ptr
  %3409 = "llvm.trunc"(%3407) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%3409, %3408) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %3410 = "llvm.lshr"(%3390, %3319) : (i64, i64) -> i64
  %3411 = "llvm.getelementptr"(%arg91) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 3>}> : (!llvm.ptr) -> !llvm.ptr
  %3412 = "llvm.trunc"(%3410) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%3412, %3411) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %3413 = "llvm.lshr"(%3390, %3320) : (i64, i64) -> i64
  %3414 = "llvm.getelementptr"(%arg91) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4>}> : (!llvm.ptr) -> !llvm.ptr
  %3415 = "llvm.trunc"(%3413) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%3415, %3414) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %3416 = "llvm.lshr"(%3390, %3328) : (i64, i64) -> i64
  %3417 = "llvm.getelementptr"(%arg91) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 5>}> : (!llvm.ptr) -> !llvm.ptr
  %3418 = "llvm.trunc"(%3416) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%3418, %3417) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %3419 = "llvm.lshr"(%3390, %3330) : (i64, i64) -> i64
  %3420 = "llvm.and"(%3419, %3331) : (i64, i64) -> i64
  %3421 = "llvm.shl"(%3395, %3326) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %3422 = "llvm.or"(%3421, %3420) <{isDisjoint}> : (i64, i64) -> i64
  %3423 = "llvm.getelementptr"(%arg91) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6>}> : (!llvm.ptr) -> !llvm.ptr
  %3424 = "llvm.trunc"(%3422) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%3424, %3423) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %3425 = "llvm.lshr"(%3392, %3329) : (i64, i64) -> i64
  %3426 = "llvm.getelementptr"(%arg91) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 7>}> : (!llvm.ptr) -> !llvm.ptr
  %3427 = "llvm.trunc"(%3425) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%3427, %3426) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %3428 = "llvm.lshr"(%3392, %3333) : (i64, i64) -> i64
  %3429 = "llvm.getelementptr"(%arg91) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %3430 = "llvm.trunc"(%3428) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%3430, %3429) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %3431 = "llvm.lshr"(%3392, %3334) : (i64, i64) -> i64
  %3432 = "llvm.getelementptr"(%arg91) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 9>}> : (!llvm.ptr) -> !llvm.ptr
  %3433 = "llvm.trunc"(%3431) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%3433, %3432) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %3434 = "llvm.lshr"(%3392, %3335) : (i64, i64) -> i64
  %3435 = "llvm.getelementptr"(%arg91) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 10>}> : (!llvm.ptr) -> !llvm.ptr
  %3436 = "llvm.trunc"(%3434) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%3436, %3435) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %3437 = "llvm.lshr"(%3392, %3337) : (i64, i64) -> i64
  %3438 = "llvm.getelementptr"(%arg91) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 11>}> : (!llvm.ptr) -> !llvm.ptr
  %3439 = "llvm.trunc"(%3437) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%3439, %3438) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %3440 = "llvm.lshr"(%3395, %3338) : (i64, i64) -> i64
  %3441 = "llvm.shl"(%3398, %3332) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %3442 = "llvm.or"(%3441, %3440) <{isDisjoint}> : (i64, i64) -> i64
  %3443 = "llvm.getelementptr"(%arg91) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 12>}> : (!llvm.ptr) -> !llvm.ptr
  %3444 = "llvm.trunc"(%3442) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%3444, %3443) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %3445 = "llvm.lshr"(%3394, %3325) : (i64, i64) -> i64
  %3446 = "llvm.getelementptr"(%arg91) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 13>}> : (!llvm.ptr) -> !llvm.ptr
  %3447 = "llvm.trunc"(%3445) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%3447, %3446) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %3448 = "llvm.lshr"(%3394, %3336) : (i64, i64) -> i64
  %3449 = "llvm.getelementptr"(%arg91) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 14>}> : (!llvm.ptr) -> !llvm.ptr
  %3450 = "llvm.trunc"(%3448) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%3450, %3449) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %3451 = "llvm.lshr"(%3394, %3340) : (i64, i64) -> i64
  %3452 = "llvm.getelementptr"(%arg91) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 15>}> : (!llvm.ptr) -> !llvm.ptr
  %3453 = "llvm.trunc"(%3451) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%3453, %3452) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %3454 = "llvm.lshr"(%3394, %3342) : (i64, i64) -> i64
  %3455 = "llvm.getelementptr"(%arg91) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %3456 = "llvm.trunc"(%3454) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%3456, %3455) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %3457 = "llvm.lshr"(%3394, %3343) : (i64, i64) -> i64
  %3458 = "llvm.getelementptr"(%arg91) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 17>}> : (!llvm.ptr) -> !llvm.ptr
  %3459 = "llvm.trunc"(%3457) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%3459, %3458) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %3460 = "llvm.lshr"(%3394, %3344) : (i64, i64) -> i64
  %3461 = "llvm.getelementptr"(%arg91) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 18>}> : (!llvm.ptr) -> !llvm.ptr
  %3462 = "llvm.trunc"(%3460) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%3462, %3461) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %3463 = "llvm.lshr"(%3398, %3345) : (i64, i64) -> i64
  %3464 = "llvm.shl"(%3401, %3324) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %3465 = "llvm.or"(%3464, %3463) <{isDisjoint}> : (i64, i64) -> i64
  %3466 = "llvm.getelementptr"(%arg91) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 19>}> : (!llvm.ptr) -> !llvm.ptr
  %3467 = "llvm.trunc"(%3465) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%3467, %3466) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %3468 = "llvm.lshr"(%3397, %3331) : (i64, i64) -> i64
  %3469 = "llvm.getelementptr"(%arg91) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 20>}> : (!llvm.ptr) -> !llvm.ptr
  %3470 = "llvm.trunc"(%3468) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%3470, %3469) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %3471 = "llvm.lshr"(%3397, %3341) : (i64, i64) -> i64
  %3472 = "llvm.getelementptr"(%arg91) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 21>}> : (!llvm.ptr) -> !llvm.ptr
  %3473 = "llvm.trunc"(%3471) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%3473, %3472) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %3474 = "llvm.lshr"(%3397, %3347) : (i64, i64) -> i64
  %3475 = "llvm.getelementptr"(%arg91) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 22>}> : (!llvm.ptr) -> !llvm.ptr
  %3476 = "llvm.trunc"(%3474) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%3476, %3475) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %3477 = "llvm.lshr"(%3397, %3348) : (i64, i64) -> i64
  %3478 = "llvm.getelementptr"(%arg91) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 23>}> : (!llvm.ptr) -> !llvm.ptr
  %3479 = "llvm.trunc"(%3477) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%3479, %3478) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %3480 = "llvm.lshr"(%3397, %3349) : (i64, i64) -> i64
  %3481 = "llvm.getelementptr"(%arg91) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %3482 = "llvm.trunc"(%3480) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%3482, %3481) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %3483 = "llvm.lshr"(%3401, %3350) : (i64, i64) -> i64
  %3484 = "llvm.shl"(%3402, %3327) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %3485 = "llvm.or"(%3484, %3483) <{isDisjoint}> : (i64, i64) -> i64
  %3486 = "llvm.getelementptr"(%arg91) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 25>}> : (!llvm.ptr) -> !llvm.ptr
  %3487 = "llvm.trunc"(%3485) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%3487, %3486) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %3488 = "llvm.lshr"(%3400, %3327) : (i64, i64) -> i64
  %3489 = "llvm.getelementptr"(%arg91) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 26>}> : (!llvm.ptr) -> !llvm.ptr
  %3490 = "llvm.trunc"(%3488) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%3490, %3489) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %3491 = "llvm.lshr"(%3400, %3339) : (i64, i64) -> i64
  %3492 = "llvm.getelementptr"(%arg91) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 27>}> : (!llvm.ptr) -> !llvm.ptr
  %3493 = "llvm.trunc"(%3491) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%3493, %3492) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %3494 = "llvm.lshr"(%3400, %3346) : (i64, i64) -> i64
  %3495 = "llvm.getelementptr"(%arg91) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 28>}> : (!llvm.ptr) -> !llvm.ptr
  %3496 = "llvm.trunc"(%3494) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%3496, %3495) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %3497 = "llvm.lshr"(%3400, %3351) : (i64, i64) -> i64
  %3498 = "llvm.getelementptr"(%arg91) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 29>}> : (!llvm.ptr) -> !llvm.ptr
  %3499 = "llvm.trunc"(%3497) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%3499, %3498) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %3500 = "llvm.lshr"(%3400, %3352) : (i64, i64) -> i64
  %3501 = "llvm.getelementptr"(%arg91) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 30>}> : (!llvm.ptr) -> !llvm.ptr
  %3502 = "llvm.trunc"(%3500) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%3502, %3501) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %3503 = "llvm.lshr"(%3402, %3353) : (i64, i64) -> i64
  %3504 = "llvm.getelementptr"(%arg91) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 31>}> : (!llvm.ptr) -> !llvm.ptr
  %3505 = "llvm.trunc"(%3503) <{overflowFlags = 3 : i32}> : (i64) -> i8
  "llvm.store"(%3505, %3504) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
