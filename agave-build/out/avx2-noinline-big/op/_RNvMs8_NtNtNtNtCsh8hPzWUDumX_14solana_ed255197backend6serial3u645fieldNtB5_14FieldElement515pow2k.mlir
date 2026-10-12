"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 8 : i64, llvm.dead_on_unwind, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writable, llvm.writeonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.noundef, llvm.range = #llvm.constant_range<i32, 1, 101>}], dso_local, function_type = !llvm.func<void (ptr, ptr, i32)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], sym_name = "_RNvMs8_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u645fieldNtB5_14FieldElement515pow2k", target_cpu = "x86-64-v2", target_features = #llvm.target_features<["+avx", "+avx2", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+crc32", "+ssse3"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg97: !llvm.ptr, %arg98: !llvm.ptr, %arg99: i32):
  %3511 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %3512 = "llvm.mlir.constant"() <{value = 1 : i128}> : () -> i128
  %3513 = "llvm.mlir.constant"() <{value = 51 : i128}> : () -> i128
  %3514 = "llvm.mlir.constant"() <{value = 18446744073709551615 : i128}> : () -> i128
  %3515 = "llvm.mlir.constant"() <{value = 2251799813685247 : i64}> : () -> i64
  %3516 = "llvm.mlir.constant"() <{value = 51 : i64}> : () -> i64
  %3517 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
  %3518 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %3519 = "llvm.load"(%arg98) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3520 = "llvm.getelementptr"(%arg98) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %3521 = "llvm.load"(%3520) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3522 = "llvm.getelementptr"(%arg98) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %3523 = "llvm.load"(%3522) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3524 = "llvm.getelementptr"(%arg98) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %3525 = "llvm.load"(%3524) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3526 = "llvm.getelementptr"(%arg98) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %3527 = "llvm.load"(%3526) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  "llvm.br"(%3527, %3525, %3523, %3521, %3519, %arg99)[^bb1] : (i64, i64, i64, i64, i64, i32) -> ()
^bb1(%3528: i64, %3529: i64, %3530: i64, %3531: i64, %3532: i64, %3533: i32):  // 2 preds: ^bb0, ^bb1
  %3534 = "llvm.mul"(%3529, %3511) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %3535 = "llvm.mul"(%3528, %3511) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %3536 = "llvm.zext"(%3532) : (i64) -> i128
  %3537 = "llvm.mul"(%3536, %3536) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %3538 = "llvm.zext"(%3531) : (i64) -> i128
  %3539 = "llvm.zext"(%3535) : (i64) -> i128
  %3540 = "llvm.mul"(%3538, %3539) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %3541 = "llvm.zext"(%3530) : (i64) -> i128
  %3542 = "llvm.zext"(%3534) : (i64) -> i128
  %3543 = "llvm.mul"(%3541, %3542) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %3544 = "llvm.add"(%3540, %3543) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3545 = "llvm.shl"(%3544, %3512) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3546 = "llvm.add"(%3545, %3537) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3547 = "llvm.zext"(%3529) : (i64) -> i128
  %3548 = "llvm.mul"(%3542, %3547) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %3549 = "llvm.mul"(%3536, %3538) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %3550 = "llvm.mul"(%3541, %3539) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %3551 = "llvm.add"(%3549, %3550) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3552 = "llvm.shl"(%3551, %3512) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3553 = "llvm.add"(%3552, %3548) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3554 = "llvm.mul"(%3538, %3538) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %3555 = "llvm.mul"(%3536, %3541) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %3556 = "llvm.zext"(%3528) : (i64) -> i128
  %3557 = "llvm.mul"(%3542, %3556) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %3558 = "llvm.add"(%3555, %3557) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3559 = "llvm.shl"(%3558, %3512) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3560 = "llvm.add"(%3559, %3554) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3561 = "llvm.mul"(%3539, %3556) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %3562 = "llvm.mul"(%3536, %3547) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %3563 = "llvm.mul"(%3538, %3541) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %3564 = "llvm.add"(%3562, %3563) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3565 = "llvm.shl"(%3564, %3512) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3566 = "llvm.add"(%3565, %3561) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3567 = "llvm.mul"(%3541, %3541) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %3568 = "llvm.mul"(%3536, %3556) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %3569 = "llvm.mul"(%3538, %3547) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %3570 = "llvm.add"(%3568, %3569) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3571 = "llvm.shl"(%3570, %3512) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3572 = "llvm.add"(%3571, %3567) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3573 = "llvm.lshr"(%3546, %3513) : (i128, i128) -> i128
  %3574 = "llvm.and"(%3573, %3514) : (i128, i128) -> i128
  %3575 = "llvm.add"(%3553, %3574) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3576 = "llvm.trunc"(%3546) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %3577 = "llvm.and"(%3576, %3515) : (i64, i64) -> i64
  %3578 = "llvm.lshr"(%3575, %3513) : (i128, i128) -> i128
  %3579 = "llvm.and"(%3578, %3514) : (i128, i128) -> i128
  %3580 = "llvm.add"(%3560, %3579) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3581 = "llvm.trunc"(%3575) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %3582 = "llvm.and"(%3581, %3515) : (i64, i64) -> i64
  %3583 = "llvm.lshr"(%3580, %3513) : (i128, i128) -> i128
  %3584 = "llvm.and"(%3583, %3514) : (i128, i128) -> i128
  %3585 = "llvm.add"(%3566, %3584) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3586 = "llvm.trunc"(%3580) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %3587 = "llvm.and"(%3586, %3515) : (i64, i64) -> i64
  %3588 = "llvm.lshr"(%3585, %3513) : (i128, i128) -> i128
  %3589 = "llvm.and"(%3588, %3514) : (i128, i128) -> i128
  %3590 = "llvm.add"(%3572, %3589) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3591 = "llvm.trunc"(%3585) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %3592 = "llvm.and"(%3591, %3515) : (i64, i64) -> i64
  %3593 = "llvm.lshr"(%3590, %3513) : (i128, i128) -> i128
  %3594 = "llvm.trunc"(%3593) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %3595 = "llvm.trunc"(%3590) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %3596 = "llvm.and"(%3595, %3515) : (i64, i64) -> i64
  %3597 = "llvm.mul"(%3594, %3511) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %3598 = "llvm.add"(%3597, %3577) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %3599 = "llvm.lshr"(%3598, %3516) : (i64, i64) -> i64
  %3600 = "llvm.add"(%3599, %3582) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %3601 = "llvm.and"(%3598, %3515) : (i64, i64) -> i64
  %3602 = "llvm.add"(%3533, %3517) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %3603 = "llvm.icmp"(%3602, %3518) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%3603, %3587, %3592, %3596, %3600, %3601, %3596, %3592, %3587, %3600, %3601, %3602)[^bb2, ^bb1] <{operandSegmentSizes = array<i32: 1, 5, 6>}> : (i1, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i32) -> ()
^bb2(%3604: i64, %3605: i64, %3606: i64, %3607: i64, %3608: i64):  // pred: ^bb1
  "llvm.store"(%3608, %arg97) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %3609 = "llvm.getelementptr"(%arg97) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3607, %3609) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %3610 = "llvm.getelementptr"(%arg97) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3604, %3610) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %3611 = "llvm.getelementptr"(%arg97) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3605, %3611) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %3612 = "llvm.getelementptr"(%arg97) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3606, %3612) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
