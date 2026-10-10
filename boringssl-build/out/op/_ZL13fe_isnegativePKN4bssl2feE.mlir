"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<i32 (ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"], ["warn-stack-size", "25344"]], res_attrs = [{llvm.noundef, llvm.range = #llvm.constant_range<i32, 0, 2>}], sym_name = "_ZL13fe_isnegativePKN4bssl2feE", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg159: !llvm.ptr):
  %1940 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1941 = "llvm.mlir.constant"() <{value = 1 : i8}> : () -> i8
  %1942 = "llvm.alloca"(%1940) <{alignment = 16 : i64, elem_type = !llvm.array<32 x i8>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%1942) : (!llvm.ptr) -> ()
  "llvm.call"(%1942, %arg159) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @_ZL10fe_tobytesPhPKN4bssl2feE, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %1943 = "llvm.load"(%1942) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1944 = "llvm.and"(%1943, %1941) : (i8, i8) -> i8
  %1945 = "llvm.zext"(%1944) <{nonNeg}> : (i8) -> i32
  "llvm.intr.lifetime.end"(%1942) : (!llvm.ptr) -> ()
  "llvm.return"(%1945) : (i32) -> ()
}) : () -> ()
