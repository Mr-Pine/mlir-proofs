"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 8 : i64, llvm.dead_on_unwind, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writable, llvm.writeonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], sym_name = "_RNvXs5_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u645fieldRNtB5_14FieldElement51NtNtNtCsgxBkk5gSRhY_4core3ops5arith3Mul3mul", target_cpu = "x86-64-v2", target_features = #llvm.target_features<["+avx", "+avx2", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+crc32", "+ssse3"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg105: !llvm.ptr, %arg106: !llvm.ptr, %arg107: !llvm.ptr):
  %3650 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %3651 = "llvm.mlir.constant"() <{value = 51 : i128}> : () -> i128
  %3652 = "llvm.mlir.constant"() <{value = 18446744073709551615 : i128}> : () -> i128
  %3653 = "llvm.mlir.constant"() <{value = 2251799813685247 : i64}> : () -> i64
  %3654 = "llvm.mlir.constant"() <{value = 51 : i64}> : () -> i64
  %3655 = "llvm.getelementptr"(%arg107) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %3656 = "llvm.load"(%3655) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3657 = "llvm.mul"(%3656, %3650) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %3658 = "llvm.getelementptr"(%arg107) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %3659 = "llvm.load"(%3658) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3660 = "llvm.mul"(%3659, %3650) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %3661 = "llvm.getelementptr"(%arg107) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %3662 = "llvm.load"(%3661) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3663 = "llvm.mul"(%3662, %3650) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %3664 = "llvm.getelementptr"(%arg107) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %3665 = "llvm.load"(%3664) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3666 = "llvm.mul"(%3665, %3650) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %3667 = "llvm.load"(%arg106) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3668 = "llvm.load"(%arg107) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3669 = "llvm.zext"(%3667) : (i64) -> i128
  %3670 = "llvm.zext"(%3668) : (i64) -> i128
  %3671 = "llvm.mul"(%3670, %3669) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %3672 = "llvm.getelementptr"(%arg106) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %3673 = "llvm.load"(%3672) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3674 = "llvm.zext"(%3673) : (i64) -> i128
  %3675 = "llvm.zext"(%3657) : (i64) -> i128
  %3676 = "llvm.mul"(%3674, %3675) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %3677 = "llvm.add"(%3676, %3671) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3678 = "llvm.getelementptr"(%arg106) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %3679 = "llvm.load"(%3678) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3680 = "llvm.zext"(%3679) : (i64) -> i128
  %3681 = "llvm.zext"(%3660) : (i64) -> i128
  %3682 = "llvm.mul"(%3680, %3681) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %3683 = "llvm.add"(%3677, %3682) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3684 = "llvm.getelementptr"(%arg106) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %3685 = "llvm.load"(%3684) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3686 = "llvm.zext"(%3685) : (i64) -> i128
  %3687 = "llvm.zext"(%3663) : (i64) -> i128
  %3688 = "llvm.mul"(%3686, %3687) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %3689 = "llvm.add"(%3683, %3688) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3690 = "llvm.getelementptr"(%arg106) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %3691 = "llvm.load"(%3690) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3692 = "llvm.zext"(%3691) : (i64) -> i128
  %3693 = "llvm.zext"(%3666) : (i64) -> i128
  %3694 = "llvm.mul"(%3692, %3693) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %3695 = "llvm.add"(%3689, %3694) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3696 = "llvm.mul"(%3692, %3670) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %3697 = "llvm.zext"(%3656) : (i64) -> i128
  %3698 = "llvm.mul"(%3669, %3697) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %3699 = "llvm.mul"(%3674, %3681) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %3700 = "llvm.mul"(%3680, %3687) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %3701 = "llvm.mul"(%3686, %3693) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %3702 = "llvm.mul"(%3686, %3670) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %3703 = "llvm.mul"(%3692, %3697) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %3704 = "llvm.zext"(%3659) : (i64) -> i128
  %3705 = "llvm.mul"(%3669, %3704) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %3706 = "llvm.mul"(%3674, %3687) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %3707 = "llvm.mul"(%3680, %3693) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %3708 = "llvm.mul"(%3680, %3670) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %3709 = "llvm.mul"(%3686, %3697) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %3710 = "llvm.mul"(%3692, %3704) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %3711 = "llvm.zext"(%3662) : (i64) -> i128
  %3712 = "llvm.mul"(%3669, %3711) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %3713 = "llvm.mul"(%3674, %3693) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %3714 = "llvm.mul"(%3674, %3670) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %3715 = "llvm.mul"(%3680, %3697) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %3716 = "llvm.mul"(%3686, %3704) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %3717 = "llvm.mul"(%3692, %3711) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %3718 = "llvm.zext"(%3665) : (i64) -> i128
  %3719 = "llvm.mul"(%3669, %3718) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %3720 = "llvm.lshr"(%3695, %3651) : (i128, i128) -> i128
  %3721 = "llvm.and"(%3720, %3652) : (i128, i128) -> i128
  %3722 = "llvm.add"(%3699, %3698) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3723 = "llvm.add"(%3722, %3700) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3724 = "llvm.add"(%3723, %3701) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3725 = "llvm.add"(%3724, %3696) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3726 = "llvm.add"(%3725, %3721) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3727 = "llvm.trunc"(%3695) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %3728 = "llvm.and"(%3727, %3653) : (i64, i64) -> i64
  %3729 = "llvm.lshr"(%3726, %3651) : (i128, i128) -> i128
  %3730 = "llvm.and"(%3729, %3652) : (i128, i128) -> i128
  %3731 = "llvm.add"(%3706, %3705) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3732 = "llvm.add"(%3731, %3707) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3733 = "llvm.add"(%3732, %3702) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3734 = "llvm.add"(%3733, %3703) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3735 = "llvm.add"(%3734, %3730) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3736 = "llvm.trunc"(%3726) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %3737 = "llvm.and"(%3736, %3653) : (i64, i64) -> i64
  %3738 = "llvm.lshr"(%3735, %3651) : (i128, i128) -> i128
  %3739 = "llvm.and"(%3738, %3652) : (i128, i128) -> i128
  %3740 = "llvm.add"(%3713, %3712) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3741 = "llvm.add"(%3740, %3708) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3742 = "llvm.add"(%3741, %3709) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3743 = "llvm.add"(%3742, %3710) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3744 = "llvm.add"(%3743, %3739) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3745 = "llvm.trunc"(%3735) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %3746 = "llvm.and"(%3745, %3653) : (i64, i64) -> i64
  %3747 = "llvm.lshr"(%3744, %3651) : (i128, i128) -> i128
  %3748 = "llvm.and"(%3747, %3652) : (i128, i128) -> i128
  %3749 = "llvm.add"(%3714, %3719) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3750 = "llvm.add"(%3749, %3715) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3751 = "llvm.add"(%3750, %3716) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3752 = "llvm.add"(%3751, %3717) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3753 = "llvm.add"(%3752, %3748) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %3754 = "llvm.trunc"(%3744) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %3755 = "llvm.and"(%3754, %3653) : (i64, i64) -> i64
  %3756 = "llvm.lshr"(%3753, %3651) : (i128, i128) -> i128
  %3757 = "llvm.trunc"(%3756) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %3758 = "llvm.trunc"(%3753) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %3759 = "llvm.and"(%3758, %3653) : (i64, i64) -> i64
  %3760 = "llvm.mul"(%3757, %3650) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %3761 = "llvm.add"(%3760, %3728) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %3762 = "llvm.lshr"(%3761, %3654) : (i64, i64) -> i64
  %3763 = "llvm.add"(%3762, %3737) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %3764 = "llvm.and"(%3761, %3653) : (i64, i64) -> i64
  "llvm.store"(%3764, %arg105) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %3765 = "llvm.getelementptr"(%arg105) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3763, %3765) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %3766 = "llvm.getelementptr"(%arg105) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3746, %3766) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %3767 = "llvm.getelementptr"(%arg105) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3755, %3767) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %3768 = "llvm.getelementptr"(%arg105) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3759, %3768) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
