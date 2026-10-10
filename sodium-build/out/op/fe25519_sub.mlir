"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "ssp", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], sym_name = "fe25519_sub", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg87: !llvm.ptr, %arg88: !llvm.ptr, %arg89: !llvm.ptr):
  %2831 = "llvm.mlir.constant"() <{value = 51 : i64}> : () -> i64
  %2832 = "llvm.mlir.constant"() <{value = 2251799813685247 : i64}> : () -> i64
  %2833 = "llvm.mlir.constant"() <{value = 4503599627370458 : i64}> : () -> i64
  %2834 = "llvm.mlir.poison"() : () -> vector<2xi64>
  %2835 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %2836 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %2837 = "llvm.mlir.constant"() <{value = dense<2251799813685247> : vector<2xi64>}> : () -> vector<2xi64>
  %2838 = "llvm.mlir.constant"() <{value = dense<4503599627370494> : vector<2xi64>}> : () -> vector<2xi64>
  %2839 = "llvm.mlir.constant"() <{value = dense<[0, 4503599627370494]> : vector<2xi64>}> : () -> vector<2xi64>
  %2840 = "llvm.mlir.constant"() <{value = -19 : i64}> : () -> i64
  %2841 = "llvm.mlir.constant"() <{value = dense<[4503599627370494, 0]> : vector<2xi64>}> : () -> vector<2xi64>
  %2842 = "llvm.load"(%arg89) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2843 = "llvm.getelementptr"(%arg89) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %2844 = "llvm.load"(%2843) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2845 = "llvm.getelementptr"(%arg89) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %2846 = "llvm.load"(%2845) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2847 = "llvm.getelementptr"(%arg89) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %2848 = "llvm.load"(%2847) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2849 = "llvm.getelementptr"(%arg89) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %2850 = "llvm.load"(%2849) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2851 = "llvm.lshr"(%2842, %2831) : (i64, i64) -> i64
  %2852 = "llvm.and"(%2842, %2832) : (i64, i64) -> i64
  %2853 = "llvm.load"(%arg88) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2854 = "llvm.sub"(%2853, %2852) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2855 = "llvm.add"(%2854, %2833) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2856 = "llvm.getelementptr"(%arg88) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %2857 = "llvm.getelementptr"(%arg88) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %2858 = "llvm.getelementptr"(%arg87) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %2859 = "llvm.add"(%2844, %2851) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2860 = "llvm.lshr"(%2859, %2831) : (i64, i64) -> i64
  %2861 = "llvm.add"(%2860, %2846) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2862 = "llvm.lshr"(%2861, %2831) : (i64, i64) -> i64
  %2863 = "llvm.insertelement"(%2834, %2859, %2835) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  %2864 = "llvm.insertelement"(%2863, %2861, %2836) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  %2865 = "llvm.and"(%2864, %2837) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %2866 = "llvm.load"(%2856) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  %2867 = "llvm.sub"(%2866, %2865) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %2868 = "llvm.add"(%2867, %2838) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %2869 = "llvm.getelementptr"(%arg87) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %2870 = "llvm.load"(%2857) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  %2871 = "llvm.add"(%2870, %2839) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %2872 = "llvm.add"(%2862, %2848) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2873 = "llvm.lshr"(%2872, %2831) : (i64, i64) -> i64
  %2874 = "llvm.add"(%2873, %2850) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2875 = "llvm.lshr"(%2874, %2831) : (i64, i64) -> i64
  %2876 = "llvm.insertelement"(%2834, %2872, %2835) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  %2877 = "llvm.insertelement"(%2876, %2874, %2836) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  %2878 = "llvm.and"(%2877, %2837) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %2879 = "llvm.mul"(%2875, %2840) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %2880 = "llvm.add"(%2855, %2879) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2881 = "llvm.sub"(%2871, %2878) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %2882 = "llvm.add"(%2881, %2841) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  "llvm.store"(%2880, %arg87) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.store"(%2868, %2858) <{alignment = 8 : i64, ordering = 0 : i64}> : (vector<2xi64>, !llvm.ptr) -> ()
  "llvm.store"(%2882, %2869) <{alignment = 8 : i64, ordering = 0 : i64}> : (vector<2xi64>, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
