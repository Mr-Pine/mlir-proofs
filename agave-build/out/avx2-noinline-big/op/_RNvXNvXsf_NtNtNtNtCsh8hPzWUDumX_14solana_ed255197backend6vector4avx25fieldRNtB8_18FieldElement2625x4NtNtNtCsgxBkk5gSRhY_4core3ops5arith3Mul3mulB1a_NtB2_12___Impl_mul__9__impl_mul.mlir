"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 32 : i64, llvm.dead_on_unwind, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writable, llvm.writeonly}, {llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr, ptr)>, inline_hint, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], sym_name = "_RNvXNvXsf_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx25fieldRNtB8_18FieldElement2625x4NtNtNtCsgxBkk5gSRhY_4core3ops5arith3Mul3mulB1a_NtB2_12___Impl_mul__9__impl_mul", target_cpu = "x86-64-v2", target_features = #llvm.target_features<["+avx", "+avx2", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+crc32", "+ssse3", "+avx", "+avx2", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+crc32", "+ssse3"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg41: !llvm.ptr, %arg42: !llvm.ptr, %arg43: !llvm.ptr):
  %773 = "llvm.mlir.constant"() <{value = dense<4294967295> : vector<4xi64>}> : () -> vector<4xi64>
  %774 = "llvm.mlir.constant"() <{value = dense<1> : vector<8xi32>}> : () -> vector<8xi32>
  %775 = "llvm.mlir.constant"() <{value = dense<19> : vector<4xi64>}> : () -> vector<4xi64>
  %776 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %777 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %778 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %779 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %780 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %781 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %782 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %783 = "llvm.mlir.poison"() : () -> i32
  %784 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %785 = "llvm.mlir.undef"() : () -> vector<8xi32>
  %786 = "llvm.insertelement"(%785, %784, %784) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %787 = "llvm.insertelement"(%786, %784, %782) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %788 = "llvm.insertelement"(%787, %783, %781) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %789 = "llvm.insertelement"(%788, %783, %780) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %790 = "llvm.insertelement"(%789, %784, %779) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %791 = "llvm.insertelement"(%790, %784, %778) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %792 = "llvm.insertelement"(%791, %783, %777) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %793 = "llvm.insertelement"(%792, %783, %776) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %794 = "llvm.insertelement"(%785, %783, %784) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %795 = "llvm.insertelement"(%794, %783, %782) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %796 = "llvm.insertelement"(%795, %784, %781) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %797 = "llvm.insertelement"(%796, %784, %780) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %798 = "llvm.insertelement"(%797, %783, %779) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %799 = "llvm.insertelement"(%798, %783, %778) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %800 = "llvm.insertelement"(%799, %784, %777) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %801 = "llvm.insertelement"(%800, %784, %776) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %802 = "llvm.alloca"(%782) <{alignment = 32 : i64, elem_type = !llvm.array<320 x i8>}> : (i32) -> !llvm.ptr
  %803 = "llvm.load"(%arg42) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %804 = "llvm.shufflevector"(%803, %793) <{mask = array<i32: 0, 8, 1, 9, 4, 12, 5, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %805 = "llvm.shufflevector"(%803, %801) <{mask = array<i32: 2, 10, 3, 11, 6, 14, 7, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %806 = "llvm.bitcast"(%804) : (vector<8xi32>) -> vector<4xi64>
  %807 = "llvm.bitcast"(%805) : (vector<8xi32>) -> vector<4xi64>
  %808 = "llvm.getelementptr"(%arg42) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %809 = "llvm.load"(%808) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %810 = "llvm.shufflevector"(%809, %793) <{mask = array<i32: 0, 8, 1, 9, 4, 12, 5, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %811 = "llvm.shufflevector"(%809, %801) <{mask = array<i32: 2, 10, 3, 11, 6, 14, 7, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %812 = "llvm.bitcast"(%810) : (vector<8xi32>) -> vector<4xi64>
  %813 = "llvm.bitcast"(%811) : (vector<8xi32>) -> vector<4xi64>
  %814 = "llvm.getelementptr"(%arg42) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %815 = "llvm.load"(%814) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %816 = "llvm.shufflevector"(%815, %793) <{mask = array<i32: 0, 8, 1, 9, 4, 12, 5, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %817 = "llvm.shufflevector"(%815, %801) <{mask = array<i32: 2, 10, 3, 11, 6, 14, 7, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %818 = "llvm.bitcast"(%816) : (vector<8xi32>) -> vector<4xi64>
  %819 = "llvm.bitcast"(%817) : (vector<8xi32>) -> vector<4xi64>
  %820 = "llvm.getelementptr"(%arg42) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %821 = "llvm.load"(%820) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %822 = "llvm.shufflevector"(%821, %793) <{mask = array<i32: 0, 8, 1, 9, 4, 12, 5, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %823 = "llvm.shufflevector"(%821, %801) <{mask = array<i32: 2, 10, 3, 11, 6, 14, 7, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %824 = "llvm.bitcast"(%822) : (vector<8xi32>) -> vector<4xi64>
  %825 = "llvm.bitcast"(%823) : (vector<8xi32>) -> vector<4xi64>
  %826 = "llvm.getelementptr"(%arg42) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %827 = "llvm.load"(%826) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %828 = "llvm.shufflevector"(%827, %793) <{mask = array<i32: 0, 8, 1, 9, 4, 12, 5, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %829 = "llvm.shufflevector"(%827, %801) <{mask = array<i32: 2, 10, 3, 11, 6, 14, 7, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %830 = "llvm.bitcast"(%828) : (vector<8xi32>) -> vector<4xi64>
  %831 = "llvm.bitcast"(%829) : (vector<8xi32>) -> vector<4xi64>
  %832 = "llvm.load"(%arg43) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %833 = "llvm.shufflevector"(%832, %793) <{mask = array<i32: 0, 8, 1, 9, 4, 12, 5, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %834 = "llvm.shufflevector"(%832, %801) <{mask = array<i32: 2, 10, 3, 11, 6, 14, 7, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %835 = "llvm.bitcast"(%833) : (vector<8xi32>) -> vector<4xi64>
  %836 = "llvm.bitcast"(%834) : (vector<8xi32>) -> vector<4xi64>
  %837 = "llvm.getelementptr"(%arg43) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %838 = "llvm.load"(%837) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %839 = "llvm.shufflevector"(%838, %793) <{mask = array<i32: 0, 8, 1, 9, 4, 12, 5, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %840 = "llvm.shufflevector"(%838, %801) <{mask = array<i32: 2, 10, 3, 11, 6, 14, 7, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %841 = "llvm.bitcast"(%839) : (vector<8xi32>) -> vector<4xi64>
  %842 = "llvm.bitcast"(%840) : (vector<8xi32>) -> vector<4xi64>
  %843 = "llvm.getelementptr"(%arg43) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %844 = "llvm.load"(%843) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %845 = "llvm.shufflevector"(%844, %793) <{mask = array<i32: 0, 8, 1, 9, 4, 12, 5, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %846 = "llvm.shufflevector"(%844, %801) <{mask = array<i32: 2, 10, 3, 11, 6, 14, 7, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %847 = "llvm.bitcast"(%845) : (vector<8xi32>) -> vector<4xi64>
  %848 = "llvm.bitcast"(%846) : (vector<8xi32>) -> vector<4xi64>
  %849 = "llvm.getelementptr"(%arg43) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %850 = "llvm.load"(%849) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %851 = "llvm.shufflevector"(%850, %793) <{mask = array<i32: 0, 8, 1, 9, 4, 12, 5, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %852 = "llvm.shufflevector"(%850, %801) <{mask = array<i32: 2, 10, 3, 11, 6, 14, 7, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %853 = "llvm.bitcast"(%851) : (vector<8xi32>) -> vector<4xi64>
  %854 = "llvm.bitcast"(%852) : (vector<8xi32>) -> vector<4xi64>
  %855 = "llvm.getelementptr"(%arg43) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %856 = "llvm.load"(%855) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %857 = "llvm.shufflevector"(%856, %793) <{mask = array<i32: 0, 8, 1, 9, 4, 12, 5, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %858 = "llvm.shufflevector"(%856, %801) <{mask = array<i32: 2, 10, 3, 11, 6, 14, 7, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %859 = "llvm.bitcast"(%857) : (vector<8xi32>) -> vector<4xi64>
  %860 = "llvm.bitcast"(%858) : (vector<8xi32>) -> vector<4xi64>
  %861 = "llvm.mul"(%836, %775) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %862 = "llvm.mul"(%841, %775) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %863 = "llvm.mul"(%842, %775) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %864 = "llvm.mul"(%847, %775) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %865 = "llvm.mul"(%848, %775) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %866 = "llvm.mul"(%853, %775) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %867 = "llvm.mul"(%854, %775) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %868 = "llvm.mul"(%859, %775) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %869 = "llvm.mul"(%860, %775) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %870 = "llvm.mul"(%835, %806) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %871 = "llvm.shl"(%805, %774) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %872 = "llvm.bitcast"(%871) : (vector<8xi32>) -> vector<4xi64>
  %873 = "llvm.and"(%869, %773) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %874 = "llvm.mul"(%873, %872) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %875 = "llvm.and"(%868, %773) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %876 = "llvm.mul"(%875, %812) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %877 = "llvm.shl"(%811, %774) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %878 = "llvm.bitcast"(%877) : (vector<8xi32>) -> vector<4xi64>
  %879 = "llvm.and"(%867, %773) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %880 = "llvm.mul"(%879, %878) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %881 = "llvm.and"(%866, %773) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %882 = "llvm.mul"(%881, %818) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %883 = "llvm.shl"(%817, %774) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %884 = "llvm.bitcast"(%883) : (vector<8xi32>) -> vector<4xi64>
  %885 = "llvm.and"(%865, %773) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %886 = "llvm.mul"(%885, %884) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %887 = "llvm.and"(%864, %773) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %888 = "llvm.mul"(%887, %824) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %889 = "llvm.shl"(%823, %774) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %890 = "llvm.bitcast"(%889) : (vector<8xi32>) -> vector<4xi64>
  %891 = "llvm.and"(%863, %773) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %892 = "llvm.mul"(%891, %890) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %893 = "llvm.and"(%862, %773) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %894 = "llvm.mul"(%893, %830) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %895 = "llvm.shl"(%829, %774) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %896 = "llvm.bitcast"(%895) : (vector<8xi32>) -> vector<4xi64>
  %897 = "llvm.and"(%861, %773) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %898 = "llvm.mul"(%897, %896) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %899 = "llvm.add"(%898, %870) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %900 = "llvm.add"(%899, %894) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %901 = "llvm.add"(%900, %892) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %902 = "llvm.add"(%901, %888) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %903 = "llvm.add"(%902, %886) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %904 = "llvm.add"(%903, %882) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %905 = "llvm.add"(%904, %880) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %906 = "llvm.add"(%905, %876) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %907 = "llvm.add"(%906, %874) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %908 = "llvm.mul"(%836, %806) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %909 = "llvm.mul"(%835, %807) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %910 = "llvm.mul"(%873, %812) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %911 = "llvm.mul"(%875, %813) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %912 = "llvm.mul"(%879, %818) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %913 = "llvm.mul"(%881, %819) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %914 = "llvm.mul"(%885, %824) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %915 = "llvm.mul"(%887, %825) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %916 = "llvm.mul"(%891, %830) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %917 = "llvm.mul"(%893, %831) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %918 = "llvm.add"(%909, %908) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %919 = "llvm.add"(%918, %916) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %920 = "llvm.add"(%919, %917) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %921 = "llvm.add"(%920, %914) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %922 = "llvm.add"(%921, %915) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %923 = "llvm.add"(%922, %912) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %924 = "llvm.add"(%923, %913) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %925 = "llvm.add"(%924, %910) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %926 = "llvm.add"(%925, %911) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %927 = "llvm.mul"(%841, %806) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %928 = "llvm.mul"(%836, %872) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %929 = "llvm.mul"(%835, %812) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %930 = "llvm.mul"(%873, %878) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %931 = "llvm.mul"(%875, %818) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %932 = "llvm.mul"(%879, %884) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %933 = "llvm.mul"(%881, %824) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %934 = "llvm.mul"(%885, %890) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %935 = "llvm.mul"(%887, %830) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %936 = "llvm.mul"(%891, %896) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %937 = "llvm.add"(%929, %928) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %938 = "llvm.add"(%937, %927) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %939 = "llvm.add"(%938, %936) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %940 = "llvm.add"(%939, %935) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %941 = "llvm.add"(%940, %934) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %942 = "llvm.add"(%941, %933) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %943 = "llvm.add"(%942, %932) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %944 = "llvm.add"(%943, %931) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %945 = "llvm.add"(%944, %930) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %946 = "llvm.mul"(%842, %806) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %947 = "llvm.mul"(%841, %807) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %948 = "llvm.mul"(%836, %812) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %949 = "llvm.mul"(%835, %813) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %950 = "llvm.mul"(%873, %818) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %951 = "llvm.mul"(%875, %819) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %952 = "llvm.mul"(%879, %824) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %953 = "llvm.mul"(%881, %825) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %954 = "llvm.mul"(%885, %830) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %955 = "llvm.mul"(%887, %831) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %956 = "llvm.add"(%949, %948) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %957 = "llvm.add"(%956, %946) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %958 = "llvm.add"(%957, %947) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %959 = "llvm.add"(%958, %954) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %960 = "llvm.add"(%959, %955) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %961 = "llvm.add"(%960, %952) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %962 = "llvm.add"(%961, %953) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %963 = "llvm.add"(%962, %950) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %964 = "llvm.add"(%963, %951) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %965 = "llvm.mul"(%847, %806) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %966 = "llvm.mul"(%842, %872) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %967 = "llvm.mul"(%841, %812) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %968 = "llvm.mul"(%836, %878) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %969 = "llvm.mul"(%835, %818) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %970 = "llvm.mul"(%873, %884) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %971 = "llvm.mul"(%875, %824) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %972 = "llvm.mul"(%879, %890) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %973 = "llvm.mul"(%881, %830) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %974 = "llvm.mul"(%885, %896) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %975 = "llvm.add"(%969, %968) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %976 = "llvm.add"(%975, %967) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %977 = "llvm.add"(%976, %966) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %978 = "llvm.add"(%977, %965) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %979 = "llvm.add"(%978, %974) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %980 = "llvm.add"(%979, %973) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %981 = "llvm.add"(%980, %972) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %982 = "llvm.add"(%981, %971) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %983 = "llvm.add"(%982, %970) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %984 = "llvm.mul"(%848, %806) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %985 = "llvm.mul"(%847, %807) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %986 = "llvm.mul"(%842, %812) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %987 = "llvm.mul"(%841, %813) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %988 = "llvm.mul"(%836, %818) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %989 = "llvm.mul"(%835, %819) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %990 = "llvm.mul"(%873, %824) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %991 = "llvm.mul"(%875, %825) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %992 = "llvm.mul"(%879, %830) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %993 = "llvm.mul"(%881, %831) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %994 = "llvm.add"(%989, %988) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %995 = "llvm.add"(%994, %986) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %996 = "llvm.add"(%995, %987) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %997 = "llvm.add"(%996, %984) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %998 = "llvm.add"(%997, %985) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %999 = "llvm.add"(%998, %992) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1000 = "llvm.add"(%999, %993) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1001 = "llvm.add"(%1000, %990) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1002 = "llvm.add"(%1001, %991) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1003 = "llvm.mul"(%853, %806) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1004 = "llvm.mul"(%848, %872) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1005 = "llvm.mul"(%847, %812) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1006 = "llvm.mul"(%842, %878) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1007 = "llvm.mul"(%841, %818) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1008 = "llvm.mul"(%836, %884) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1009 = "llvm.mul"(%835, %824) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1010 = "llvm.mul"(%873, %890) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1011 = "llvm.mul"(%875, %830) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1012 = "llvm.mul"(%879, %896) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1013 = "llvm.add"(%1009, %1008) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1014 = "llvm.add"(%1013, %1006) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1015 = "llvm.add"(%1014, %1007) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1016 = "llvm.add"(%1015, %1005) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1017 = "llvm.add"(%1016, %1004) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1018 = "llvm.add"(%1017, %1003) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1019 = "llvm.add"(%1018, %1012) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1020 = "llvm.add"(%1019, %1011) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1021 = "llvm.add"(%1020, %1010) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1022 = "llvm.mul"(%854, %806) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1023 = "llvm.mul"(%853, %807) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1024 = "llvm.mul"(%848, %812) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1025 = "llvm.mul"(%847, %813) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1026 = "llvm.mul"(%842, %818) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1027 = "llvm.mul"(%841, %819) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1028 = "llvm.mul"(%836, %824) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1029 = "llvm.mul"(%835, %825) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1030 = "llvm.mul"(%873, %830) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1031 = "llvm.mul"(%875, %831) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1032 = "llvm.add"(%1029, %1028) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1033 = "llvm.add"(%1032, %1026) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1034 = "llvm.add"(%1033, %1027) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1035 = "llvm.add"(%1034, %1024) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1036 = "llvm.add"(%1035, %1025) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1037 = "llvm.add"(%1036, %1022) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1038 = "llvm.add"(%1037, %1023) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1039 = "llvm.add"(%1038, %1030) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1040 = "llvm.add"(%1039, %1031) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1041 = "llvm.mul"(%859, %806) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1042 = "llvm.mul"(%854, %872) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1043 = "llvm.mul"(%853, %812) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1044 = "llvm.mul"(%848, %878) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1045 = "llvm.mul"(%847, %818) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1046 = "llvm.mul"(%842, %884) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1047 = "llvm.mul"(%841, %824) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1048 = "llvm.mul"(%836, %890) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1049 = "llvm.mul"(%835, %830) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1050 = "llvm.mul"(%873, %896) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1051 = "llvm.add"(%1048, %1049) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1052 = "llvm.add"(%1051, %1047) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1053 = "llvm.add"(%1052, %1046) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1054 = "llvm.add"(%1053, %1045) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1055 = "llvm.add"(%1054, %1044) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1056 = "llvm.add"(%1055, %1043) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1057 = "llvm.add"(%1056, %1042) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1058 = "llvm.add"(%1057, %1041) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1059 = "llvm.add"(%1058, %1050) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1060 = "llvm.mul"(%860, %806) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1061 = "llvm.mul"(%859, %807) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1062 = "llvm.mul"(%854, %812) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1063 = "llvm.mul"(%853, %813) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1064 = "llvm.mul"(%848, %818) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1065 = "llvm.mul"(%847, %819) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1066 = "llvm.mul"(%842, %824) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1067 = "llvm.mul"(%841, %825) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1068 = "llvm.mul"(%836, %830) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1069 = "llvm.mul"(%835, %831) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1070 = "llvm.add"(%1069, %1068) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1071 = "llvm.add"(%1070, %1066) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1072 = "llvm.add"(%1071, %1067) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1073 = "llvm.add"(%1072, %1064) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1074 = "llvm.add"(%1073, %1065) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1075 = "llvm.add"(%1074, %1062) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1076 = "llvm.add"(%1075, %1063) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1077 = "llvm.add"(%1076, %1060) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1078 = "llvm.add"(%1077, %1061) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%802) : (!llvm.ptr) -> ()
  "llvm.store"(%907, %802) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %1079 = "llvm.getelementptr"(%802) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%926, %1079) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %1080 = "llvm.getelementptr"(%802) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%945, %1080) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %1081 = "llvm.getelementptr"(%802) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%964, %1081) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %1082 = "llvm.getelementptr"(%802) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%983, %1082) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %1083 = "llvm.getelementptr"(%802) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 160>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1002, %1083) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %1084 = "llvm.getelementptr"(%802) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 192>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1021, %1084) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %1085 = "llvm.getelementptr"(%802) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 224>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1040, %1085) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %1086 = "llvm.getelementptr"(%802) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 256>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1059, %1086) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %1087 = "llvm.getelementptr"(%802) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 288>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1078, %1087) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.call"(%arg41, %802) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 32 : i64, llvm.dereferenceable = 320 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef}], callee = @_RNvXNvMsb_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx25fieldNtB8_18FieldElement2625x48reduce64B1a_NtB2_17___Impl_reduce64__14__impl_reduce64, fastmathFlags = #llvm.fastmath<none>, inline_hint, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%802) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
