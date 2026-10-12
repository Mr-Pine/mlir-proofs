"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 8 : i64, llvm.dead_on_unwind, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writable, llvm.writeonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], sym_name = "_RNvMs2_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar523sub", target_cpu = "x86-64-v2", target_features = #llvm.target_features<["+avx", "+avx2", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+crc32", "+ssse3"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg83: !llvm.ptr, %arg84: !llvm.ptr):
  %2795 = "llvm.mlir.constant"() <{value = -671914833335277 : i64}> : () -> i64
  %2796 = "llvm.mlir.constant"() <{value = 4503599627370495 : i64}> : () -> i64
  %2797 = "llvm.mlir.constant"() <{value = 63 : i64}> : () -> i64
  %2798 = "llvm.mlir.constant"() <{value = -3916664325105025 : i64}> : () -> i64
  %2799 = "llvm.mlir.constant"() <{value = -1367801 : i64}> : () -> i64
  %2800 = "llvm.mlir.constant"() <{value = -17592186044416 : i64}> : () -> i64
  %2801 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %2802 = "llvm.mlir.constant"() <{value = 671914833335277 : i64}> : () -> i64
  %2803 = "llvm.mlir.constant"() <{value = 3916664325105025 : i64}> : () -> i64
  %2804 = "llvm.mlir.constant"() <{value = 52 : i64}> : () -> i64
  %2805 = "llvm.mlir.constant"() <{value = 1367801 : i64}> : () -> i64
  %2806 = "llvm.mlir.constant"() <{value = 17592186044416 : i64}> : () -> i64
  %2807 = "llvm.load"(%arg84) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2808 = "llvm.add"(%2807, %2795) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2809 = "llvm.and"(%2808, %2796) : (i64, i64) -> i64
  %2810 = "llvm.getelementptr"(%arg84) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %2811 = "llvm.load"(%2810) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2812 = "llvm.ashr"(%2808, %2797) : (i64, i64) -> i64
  %2813 = "llvm.add"(%2811, %2812) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2814 = "llvm.add"(%2813, %2798) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2815 = "llvm.and"(%2814, %2796) : (i64, i64) -> i64
  %2816 = "llvm.getelementptr"(%arg84) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %2817 = "llvm.load"(%2816) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2818 = "llvm.ashr"(%2814, %2797) : (i64, i64) -> i64
  %2819 = "llvm.add"(%2817, %2818) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2820 = "llvm.add"(%2819, %2799) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2821 = "llvm.and"(%2820, %2796) : (i64, i64) -> i64
  %2822 = "llvm.getelementptr"(%arg84) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %2823 = "llvm.load"(%2822) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2824 = "llvm.ashr"(%2820, %2797) : (i64, i64) -> i64
  %2825 = "llvm.add"(%2823, %2824) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2826 = "llvm.and"(%2825, %2796) : (i64, i64) -> i64
  %2827 = "llvm.getelementptr"(%arg84) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %2828 = "llvm.load"(%2827) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2829 = "llvm.ashr"(%2825, %2797) : (i64, i64) -> i64
  %2830 = "llvm.add"(%2828, %2829) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2831 = "llvm.add"(%2830, %2800) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2832 = "llvm.lshr"(%2831, %2797) : (i64, i64) -> i64
  %2833 = "llvm.trunc"(%2832) <{overflowFlags = 3 : i32}> : (i64) -> i8
  %2834 = "llvm.call"(%2833) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %2835 = "llvm.zext"(%2834) : (i8) -> i64
  %2836 = "llvm.sub"(%2801, %2835) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %2837 = "llvm.and"(%2836, %2802) : (i64, i64) -> i64
  %2838 = "llvm.add"(%2809, %2837) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2839 = "llvm.and"(%2838, %2796) : (i64, i64) -> i64
  %2840 = "llvm.and"(%2836, %2803) : (i64, i64) -> i64
  %2841 = "llvm.lshr"(%2838, %2804) : (i64, i64) -> i64
  %2842 = "llvm.add"(%2815, %2841) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2843 = "llvm.add"(%2842, %2840) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2844 = "llvm.and"(%2843, %2796) : (i64, i64) -> i64
  %2845 = "llvm.and"(%2836, %2805) : (i64, i64) -> i64
  %2846 = "llvm.lshr"(%2843, %2804) : (i64, i64) -> i64
  %2847 = "llvm.add"(%2821, %2846) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2848 = "llvm.add"(%2847, %2845) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2849 = "llvm.and"(%2848, %2796) : (i64, i64) -> i64
  %2850 = "llvm.lshr"(%2848, %2804) : (i64, i64) -> i64
  %2851 = "llvm.add"(%2826, %2850) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2852 = "llvm.and"(%2851, %2796) : (i64, i64) -> i64
  %2853 = "llvm.and"(%2836, %2806) : (i64, i64) -> i64
  %2854 = "llvm.lshr"(%2851, %2804) : (i64, i64) -> i64
  %2855 = "llvm.add"(%2831, %2854) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2856 = "llvm.add"(%2855, %2853) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2857 = "llvm.and"(%2856, %2796) : (i64, i64) -> i64
  "llvm.store"(%2839, %arg83) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %2858 = "llvm.getelementptr"(%arg83) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2844, %2858) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %2859 = "llvm.getelementptr"(%arg83) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2849, %2859) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %2860 = "llvm.getelementptr"(%arg83) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2852, %2860) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %2861 = "llvm.getelementptr"(%arg83) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2857, %2861) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
