"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<i64 (ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "ssp", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], res_attrs = [{llvm.range = #llvm.constant_range<i64, 0, 16777216>}], sym_name = "load_3", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg40: !llvm.ptr):
  %2112 = "llvm.mlir.constant"() <{value = 16 : i64}> : () -> i64
  %2113 = "llvm.load"(%arg40) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i16
  %2114 = "llvm.zext"(%2113) : (i16) -> i64
  %2115 = "llvm.getelementptr"(%arg40) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 2>}> : (!llvm.ptr) -> !llvm.ptr
  %2116 = "llvm.load"(%2115) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2117 = "llvm.zext"(%2116) : (i8) -> i64
  %2118 = "llvm.shl"(%2117, %2112) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2119 = "llvm.or"(%2118, %2114) <{isDisjoint}> : (i64, i64) -> i64
  "llvm.return"(%2119) : (i64) -> ()
}) : () -> ()
