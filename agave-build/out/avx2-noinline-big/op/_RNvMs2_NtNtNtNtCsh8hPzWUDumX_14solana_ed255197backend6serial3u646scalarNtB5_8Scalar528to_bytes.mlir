"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 1 : i64, llvm.dead_on_unwind, llvm.dereferenceable = 32 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writable, llvm.writeonly}, {llvm.align = 8 : i64, llvm.dead_on_return = -1 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], sym_name = "_RNvMs2_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar528to_bytes", target_cpu = "x86-64-v2", target_features = #llvm.target_features<["+avx", "+avx2", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+crc32", "+ssse3"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg79: !llvm.ptr, %arg80: !llvm.ptr):
  %2678 = "llvm.mlir.constant"() <{value = 8 : i64}> : () -> i64
  %2679 = "llvm.mlir.constant"() <{value = 16 : i64}> : () -> i64
  %2680 = "llvm.mlir.constant"() <{value = 24 : i64}> : () -> i64
  %2681 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %2682 = "llvm.mlir.constant"() <{value = 4 : i64}> : () -> i64
  %2683 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
  %2684 = "llvm.mlir.constant"() <{value = 48 : i64}> : () -> i64
  %2685 = "llvm.mlir.constant"() <{value = 12 : i64}> : () -> i64
  %2686 = "llvm.mlir.constant"() <{value = 20 : i64}> : () -> i64
  %2687 = "llvm.mlir.constant"() <{value = 28 : i64}> : () -> i64
  %2688 = "llvm.mlir.constant"() <{value = 36 : i64}> : () -> i64
  %2689 = "llvm.mlir.constant"() <{value = 44 : i64}> : () -> i64
  %2690 = "llvm.load"(%arg80) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2691 = "llvm.trunc"(%2690) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2691, %arg79) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2692 = "llvm.lshr"(%2690, %2678) : (i64, i64) -> i64
  %2693 = "llvm.getelementptr"(%arg79) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1>}> : (!llvm.ptr) -> !llvm.ptr
  %2694 = "llvm.trunc"(%2692) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2694, %2693) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2695 = "llvm.lshr"(%2690, %2679) : (i64, i64) -> i64
  %2696 = "llvm.getelementptr"(%arg79) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2>}> : (!llvm.ptr) -> !llvm.ptr
  %2697 = "llvm.trunc"(%2695) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2697, %2696) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2698 = "llvm.lshr"(%2690, %2680) : (i64, i64) -> i64
  %2699 = "llvm.getelementptr"(%arg79) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 3>}> : (!llvm.ptr) -> !llvm.ptr
  %2700 = "llvm.trunc"(%2698) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2700, %2699) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2701 = "llvm.lshr"(%2690, %2681) : (i64, i64) -> i64
  %2702 = "llvm.getelementptr"(%arg79) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4>}> : (!llvm.ptr) -> !llvm.ptr
  %2703 = "llvm.trunc"(%2701) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2703, %2702) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2704 = "llvm.lshr"(%2690, %2683) : (i64, i64) -> i64
  %2705 = "llvm.getelementptr"(%arg79) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 5>}> : (!llvm.ptr) -> !llvm.ptr
  %2706 = "llvm.trunc"(%2704) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2706, %2705) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2707 = "llvm.lshr"(%2690, %2684) : (i64, i64) -> i64
  %2708 = "llvm.getelementptr"(%arg80) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %2709 = "llvm.load"(%2708) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2710 = "llvm.shl"(%2709, %2682) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2711 = "llvm.or"(%2710, %2707) : (i64, i64) -> i64
  %2712 = "llvm.getelementptr"(%arg79) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6>}> : (!llvm.ptr) -> !llvm.ptr
  %2713 = "llvm.trunc"(%2711) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2713, %2712) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2714 = "llvm.lshr"(%2709, %2682) : (i64, i64) -> i64
  %2715 = "llvm.getelementptr"(%arg79) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 7>}> : (!llvm.ptr) -> !llvm.ptr
  %2716 = "llvm.trunc"(%2714) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2716, %2715) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2717 = "llvm.lshr"(%2709, %2685) : (i64, i64) -> i64
  %2718 = "llvm.getelementptr"(%arg79) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %2719 = "llvm.trunc"(%2717) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2719, %2718) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2720 = "llvm.lshr"(%2709, %2686) : (i64, i64) -> i64
  %2721 = "llvm.getelementptr"(%arg79) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 9>}> : (!llvm.ptr) -> !llvm.ptr
  %2722 = "llvm.trunc"(%2720) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2722, %2721) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2723 = "llvm.lshr"(%2709, %2687) : (i64, i64) -> i64
  %2724 = "llvm.getelementptr"(%arg79) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 10>}> : (!llvm.ptr) -> !llvm.ptr
  %2725 = "llvm.trunc"(%2723) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2725, %2724) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2726 = "llvm.lshr"(%2709, %2688) : (i64, i64) -> i64
  %2727 = "llvm.getelementptr"(%arg79) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 11>}> : (!llvm.ptr) -> !llvm.ptr
  %2728 = "llvm.trunc"(%2726) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2728, %2727) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2729 = "llvm.lshr"(%2709, %2689) : (i64, i64) -> i64
  %2730 = "llvm.getelementptr"(%arg79) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 12>}> : (!llvm.ptr) -> !llvm.ptr
  %2731 = "llvm.trunc"(%2729) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2731, %2730) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2732 = "llvm.getelementptr"(%arg80) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %2733 = "llvm.load"(%2732) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2734 = "llvm.getelementptr"(%arg79) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 13>}> : (!llvm.ptr) -> !llvm.ptr
  %2735 = "llvm.trunc"(%2733) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2735, %2734) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2736 = "llvm.lshr"(%2733, %2678) : (i64, i64) -> i64
  %2737 = "llvm.getelementptr"(%arg79) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 14>}> : (!llvm.ptr) -> !llvm.ptr
  %2738 = "llvm.trunc"(%2736) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2738, %2737) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2739 = "llvm.lshr"(%2733, %2679) : (i64, i64) -> i64
  %2740 = "llvm.getelementptr"(%arg79) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 15>}> : (!llvm.ptr) -> !llvm.ptr
  %2741 = "llvm.trunc"(%2739) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2741, %2740) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2742 = "llvm.lshr"(%2733, %2680) : (i64, i64) -> i64
  %2743 = "llvm.getelementptr"(%arg79) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %2744 = "llvm.trunc"(%2742) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2744, %2743) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2745 = "llvm.lshr"(%2733, %2681) : (i64, i64) -> i64
  %2746 = "llvm.getelementptr"(%arg79) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 17>}> : (!llvm.ptr) -> !llvm.ptr
  %2747 = "llvm.trunc"(%2745) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2747, %2746) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2748 = "llvm.lshr"(%2733, %2683) : (i64, i64) -> i64
  %2749 = "llvm.getelementptr"(%arg79) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 18>}> : (!llvm.ptr) -> !llvm.ptr
  %2750 = "llvm.trunc"(%2748) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2750, %2749) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2751 = "llvm.lshr"(%2733, %2684) : (i64, i64) -> i64
  %2752 = "llvm.getelementptr"(%arg80) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %2753 = "llvm.load"(%2752) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2754 = "llvm.shl"(%2753, %2682) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2755 = "llvm.or"(%2754, %2751) : (i64, i64) -> i64
  %2756 = "llvm.getelementptr"(%arg79) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 19>}> : (!llvm.ptr) -> !llvm.ptr
  %2757 = "llvm.trunc"(%2755) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2757, %2756) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2758 = "llvm.lshr"(%2753, %2682) : (i64, i64) -> i64
  %2759 = "llvm.getelementptr"(%arg79) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 20>}> : (!llvm.ptr) -> !llvm.ptr
  %2760 = "llvm.trunc"(%2758) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2760, %2759) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2761 = "llvm.lshr"(%2753, %2685) : (i64, i64) -> i64
  %2762 = "llvm.getelementptr"(%arg79) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 21>}> : (!llvm.ptr) -> !llvm.ptr
  %2763 = "llvm.trunc"(%2761) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2763, %2762) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2764 = "llvm.lshr"(%2753, %2686) : (i64, i64) -> i64
  %2765 = "llvm.getelementptr"(%arg79) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 22>}> : (!llvm.ptr) -> !llvm.ptr
  %2766 = "llvm.trunc"(%2764) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2766, %2765) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2767 = "llvm.lshr"(%2753, %2687) : (i64, i64) -> i64
  %2768 = "llvm.getelementptr"(%arg79) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 23>}> : (!llvm.ptr) -> !llvm.ptr
  %2769 = "llvm.trunc"(%2767) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2769, %2768) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2770 = "llvm.lshr"(%2753, %2688) : (i64, i64) -> i64
  %2771 = "llvm.getelementptr"(%arg79) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %2772 = "llvm.trunc"(%2770) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2772, %2771) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2773 = "llvm.lshr"(%2753, %2689) : (i64, i64) -> i64
  %2774 = "llvm.getelementptr"(%arg79) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 25>}> : (!llvm.ptr) -> !llvm.ptr
  %2775 = "llvm.trunc"(%2773) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2775, %2774) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2776 = "llvm.getelementptr"(%arg80) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %2777 = "llvm.load"(%2776) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2778 = "llvm.getelementptr"(%arg79) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 26>}> : (!llvm.ptr) -> !llvm.ptr
  %2779 = "llvm.trunc"(%2777) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2779, %2778) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2780 = "llvm.lshr"(%2777, %2678) : (i64, i64) -> i64
  %2781 = "llvm.getelementptr"(%arg79) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 27>}> : (!llvm.ptr) -> !llvm.ptr
  %2782 = "llvm.trunc"(%2780) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2782, %2781) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2783 = "llvm.lshr"(%2777, %2679) : (i64, i64) -> i64
  %2784 = "llvm.getelementptr"(%arg79) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 28>}> : (!llvm.ptr) -> !llvm.ptr
  %2785 = "llvm.trunc"(%2783) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2785, %2784) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2786 = "llvm.lshr"(%2777, %2680) : (i64, i64) -> i64
  %2787 = "llvm.getelementptr"(%arg79) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 29>}> : (!llvm.ptr) -> !llvm.ptr
  %2788 = "llvm.trunc"(%2786) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2788, %2787) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2789 = "llvm.lshr"(%2777, %2681) : (i64, i64) -> i64
  %2790 = "llvm.getelementptr"(%arg79) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 30>}> : (!llvm.ptr) -> !llvm.ptr
  %2791 = "llvm.trunc"(%2789) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2791, %2790) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2792 = "llvm.lshr"(%2777, %2683) : (i64, i64) -> i64
  %2793 = "llvm.getelementptr"(%arg79) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 31>}> : (!llvm.ptr) -> !llvm.ptr
  %2794 = "llvm.trunc"(%2792) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2794, %2793) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
