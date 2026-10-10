#loop_annotation = #llvm.loop_annotation<mustProgress = true>
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.nonnull, llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, no_inline, no_unwind, passthrough = ["mustprogress", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"], ["warn-stack-size", "25344"]], sym_name = "_ZL28ge_double_scalarmult_vartimePN4bssl5ge_p2EPKhPKNS_5ge_p3ES3_", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg29: !llvm.ptr, %arg30: !llvm.ptr, %arg31: !llvm.ptr, %arg32: !llvm.ptr):
  %391 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %392 = "llvm.mlir.constant"() <{value = 255 : i32}> : () -> i32
  %393 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %394 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
  %395 = "llvm.mlir.constant"() <{value = 1 : i8}> : () -> i8
  %396 = "llvm.mlir.addressof"() <{global_name = @_ZL2Bi}> : () -> !llvm.ptr
  %397 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %398 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %399 = "llvm.mlir.constant"() <{value = -2 : i32}> : () -> i32
  %400 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %401 = "llvm.alloca"(%391) <{alignment = 16 : i64, elem_type = !llvm.array<256 x i8>}> : (i32) -> !llvm.ptr
  %402 = "llvm.alloca"(%391) <{alignment = 16 : i64, elem_type = !llvm.array<256 x i8>}> : (i32) -> !llvm.ptr
  %403 = "llvm.alloca"(%391) <{alignment = 16 : i64, elem_type = !llvm.array<8 x struct<"struct.bssl::ge_cached", (struct<"struct.bssl::fe", (array<5 x i64>)>, struct<"struct.bssl::fe", (array<5 x i64>)>, struct<"struct.bssl::fe", (array<5 x i64>)>, struct<"struct.bssl::fe", (array<5 x i64>)>)>>}> : (i32) -> !llvm.ptr
  %404 = "llvm.alloca"(%391) <{alignment = 8 : i64, elem_type = !llvm.struct<"struct.bssl::ge_cached", (struct<"struct.bssl::fe", (array<5 x i64>)>, struct<"struct.bssl::fe", (array<5 x i64>)>, struct<"struct.bssl::fe", (array<5 x i64>)>, struct<"struct.bssl::fe", (array<5 x i64>)>)>}> : (i32) -> !llvm.ptr
  %405 = "llvm.alloca"(%391) <{alignment = 8 : i64, elem_type = !llvm.struct<"struct.bssl::ge_cached", (struct<"struct.bssl::fe", (array<5 x i64>)>, struct<"struct.bssl::fe", (array<5 x i64>)>, struct<"struct.bssl::fe", (array<5 x i64>)>, struct<"struct.bssl::fe", (array<5 x i64>)>)>}> : (i32) -> !llvm.ptr
  %406 = "llvm.alloca"(%391) <{alignment = 8 : i64, elem_type = !llvm.struct<"struct.bssl::ge_cached", (struct<"struct.bssl::fe", (array<5 x i64>)>, struct<"struct.bssl::fe", (array<5 x i64>)>, struct<"struct.bssl::fe", (array<5 x i64>)>, struct<"struct.bssl::fe", (array<5 x i64>)>)>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%401) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%402) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%403) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%404) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%405) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%406) : (!llvm.ptr) -> ()
  "llvm.call"(%401, %arg30) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @_ZL5slidePaPKh, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%402, %arg32) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @_ZL5slidePaPKh, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%403, %arg31) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZN4bssl22x25519_ge_p3_to_cachedEPNS_9ge_cachedEPKNS_5ge_p3E, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%404, %arg31) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZL9ge_p3_dblPN4bssl7ge_p1p1EPKNS_5ge_p3E, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%406, %404) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZN4bssl20x25519_ge_p1p1_to_p3EPNS_5ge_p3EPKNS_7ge_p1p1E, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%404, %406, %403) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZN4bssl13x25519_ge_addEPNS_7ge_p1p1EPKNS_5ge_p3EPKNS_9ge_cachedE, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%405, %404) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZN4bssl20x25519_ge_p1p1_to_p3EPNS_5ge_p3EPKNS_7ge_p1p1E, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %407 = "llvm.getelementptr"(%403) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 160>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%407, %405) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZN4bssl22x25519_ge_p3_to_cachedEPNS_9ge_cachedEPKNS_5ge_p3E, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%404, %406, %407) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZN4bssl13x25519_ge_addEPNS_7ge_p1p1EPKNS_5ge_p3EPKNS_9ge_cachedE, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%405, %404) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZN4bssl20x25519_ge_p1p1_to_p3EPNS_5ge_p3EPKNS_7ge_p1p1E, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %408 = "llvm.getelementptr"(%403) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 320>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%408, %405) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZN4bssl22x25519_ge_p3_to_cachedEPNS_9ge_cachedEPKNS_5ge_p3E, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%404, %406, %408) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZN4bssl13x25519_ge_addEPNS_7ge_p1p1EPKNS_5ge_p3EPKNS_9ge_cachedE, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%405, %404) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZN4bssl20x25519_ge_p1p1_to_p3EPNS_5ge_p3EPKNS_7ge_p1p1E, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %409 = "llvm.getelementptr"(%403) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 480>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%409, %405) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZN4bssl22x25519_ge_p3_to_cachedEPNS_9ge_cachedEPKNS_5ge_p3E, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%404, %406, %409) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZN4bssl13x25519_ge_addEPNS_7ge_p1p1EPKNS_5ge_p3EPKNS_9ge_cachedE, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%405, %404) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZN4bssl20x25519_ge_p1p1_to_p3EPNS_5ge_p3EPKNS_7ge_p1p1E, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %410 = "llvm.getelementptr"(%403) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 640>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%410, %405) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZN4bssl22x25519_ge_p3_to_cachedEPNS_9ge_cachedEPKNS_5ge_p3E, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%404, %406, %410) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZN4bssl13x25519_ge_addEPNS_7ge_p1p1EPKNS_5ge_p3EPKNS_9ge_cachedE, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%405, %404) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZN4bssl20x25519_ge_p1p1_to_p3EPNS_5ge_p3EPKNS_7ge_p1p1E, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %411 = "llvm.getelementptr"(%403) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 800>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%411, %405) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZN4bssl22x25519_ge_p3_to_cachedEPNS_9ge_cachedEPKNS_5ge_p3E, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%404, %406, %411) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZN4bssl13x25519_ge_addEPNS_7ge_p1p1EPKNS_5ge_p3EPKNS_9ge_cachedE, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%405, %404) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZN4bssl20x25519_ge_p1p1_to_p3EPNS_5ge_p3EPKNS_7ge_p1p1E, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %412 = "llvm.getelementptr"(%403) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 960>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%412, %405) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZN4bssl22x25519_ge_p3_to_cachedEPNS_9ge_cachedEPKNS_5ge_p3E, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%404, %406, %412) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZN4bssl13x25519_ge_addEPNS_7ge_p1p1EPKNS_5ge_p3EPKNS_9ge_cachedE, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%405, %404) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZN4bssl20x25519_ge_p1p1_to_p3EPNS_5ge_p3EPKNS_7ge_p1p1E, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %413 = "llvm.getelementptr"(%403) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1120>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%413, %405) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZN4bssl22x25519_ge_p3_to_cachedEPNS_9ge_cachedEPKNS_5ge_p3E, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%arg29) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @_ZL7ge_p2_0PN4bssl5ge_p2E, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> ()
  "llvm.br"(%392)[^bb1] : (i32) -> ()
^bb1(%414: i32):  // 2 preds: ^bb0, ^bb5
  %415 = "llvm.zext"(%414) <{nonNeg}> : (i32) -> i64
  %416 = "llvm.getelementptr"(%401, %415) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %417 = "llvm.load"(%416) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %418 = "llvm.icmp"(%417, %393) <{predicate = 0 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%418, %414)[^bb2, ^bb6] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb2:  // pred: ^bb1
  %419 = "llvm.getelementptr"(%402, %415) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %420 = "llvm.load"(%419) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %421 = "llvm.icmp"(%420, %393) <{predicate = 0 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%421, %414)[^bb3, ^bb6] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb3:  // pred: ^bb2
  %422 = "llvm.add"(%414, %394) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %423 = "llvm.zext"(%422) <{nonNeg}> : (i32) -> i64
  %424 = "llvm.getelementptr"(%401, %423) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %425 = "llvm.load"(%424) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %426 = "llvm.icmp"(%425, %393) <{predicate = 0 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%426, %422)[^bb4, ^bb6] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb4:  // pred: ^bb3
  %427 = "llvm.getelementptr"(%402, %423) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %428 = "llvm.load"(%427) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %429 = "llvm.icmp"(%428, %393) <{predicate = 0 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%429, %422)[^bb5, ^bb6] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb5:  // pred: ^bb4
  %430 = "llvm.add"(%414, %399) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %431 = "llvm.icmp"(%422, %400) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%431, %430)[^bb17, ^bb1] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb6(%432: i32):  // 4 preds: ^bb1, ^bb2, ^bb3, ^bb4
  %433 = "llvm.icmp"(%432, %394) <{predicate = 4 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%433)[^bb7, ^bb17] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb7:  // pred: ^bb6
  %434 = "llvm.zext"(%432) <{nonNeg}> : (i32) -> i64
  "llvm.br"(%434)[^bb8] : (i64) -> ()
^bb8(%435: i64):  // 2 preds: ^bb7, ^bb16
  "llvm.call"(%404, %arg29) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZL9ge_p2_dblPN4bssl7ge_p1p1EPKNS_5ge_p2E, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %436 = "llvm.getelementptr"(%401, %435) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %437 = "llvm.load"(%436) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %438 = "llvm.icmp"(%437, %393) <{predicate = 4 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%438)[^bb9, ^bb10] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb9:  // pred: ^bb8
  "llvm.call"(%405, %404) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZN4bssl20x25519_ge_p1p1_to_p3EPNS_5ge_p3EPKNS_7ge_p1p1E, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %439 = "llvm.lshr"(%437, %395) : (i8, i8) -> i8
  %440 = "llvm.zext"(%439) <{nonNeg}> : (i8) -> i64
  %441 = "llvm.getelementptr"(%403, %440) <{elem_type = !llvm.array<160 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.call"(%404, %405, %441) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZN4bssl13x25519_ge_addEPNS_7ge_p1p1EPKNS_5ge_p3EPKNS_9ge_cachedE, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.br"()[^bb12] : () -> ()
^bb10:  // pred: ^bb8
  %442 = "llvm.icmp"(%437, %393) <{predicate = 2 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%442)[^bb11, ^bb12] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb11:  // pred: ^bb10
  "llvm.call"(%405, %404) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZN4bssl20x25519_ge_p1p1_to_p3EPNS_5ge_p3EPKNS_7ge_p1p1E, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %443 = "llvm.sub"(%393, %437) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  %444 = "llvm.lshr"(%443, %395) : (i8, i8) -> i8
  %445 = "llvm.zext"(%444) <{nonNeg}> : (i8) -> i64
  %446 = "llvm.getelementptr"(%403, %445) <{elem_type = !llvm.array<160 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.call"(%404, %405, %446) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZN4bssl13x25519_ge_subEPNS_7ge_p1p1EPKNS_5ge_p3EPKNS_9ge_cachedE, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.br"()[^bb12] : () -> ()
^bb12:  // 3 preds: ^bb9, ^bb10, ^bb11
  %447 = "llvm.getelementptr"(%402, %435) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %448 = "llvm.load"(%447) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %449 = "llvm.icmp"(%448, %393) <{predicate = 4 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%449)[^bb13, ^bb14] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb13:  // pred: ^bb12
  "llvm.call"(%405, %404) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZN4bssl20x25519_ge_p1p1_to_p3EPNS_5ge_p3EPKNS_7ge_p1p1E, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %450 = "llvm.lshr"(%448, %395) : (i8, i8) -> i8
  %451 = "llvm.zext"(%450) <{nonNeg}> : (i8) -> i64
  %452 = "llvm.getelementptr"(%396, %451) <{elem_type = !llvm.array<120 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.call"(%404, %405, %452) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZL7ge_maddPN4bssl7ge_p1p1EPKNS_5ge_p3EPKNS_10ge_precompE, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.br"()[^bb16] : () -> ()
^bb14:  // pred: ^bb12
  %453 = "llvm.icmp"(%448, %393) <{predicate = 2 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%453)[^bb15, ^bb16] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb15:  // pred: ^bb14
  "llvm.call"(%405, %404) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZN4bssl20x25519_ge_p1p1_to_p3EPNS_5ge_p3EPKNS_7ge_p1p1E, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %454 = "llvm.sub"(%393, %448) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  %455 = "llvm.lshr"(%454, %395) : (i8, i8) -> i8
  %456 = "llvm.zext"(%455) <{nonNeg}> : (i8) -> i64
  %457 = "llvm.getelementptr"(%396, %456) <{elem_type = !llvm.array<120 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.call"(%404, %405, %457) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZL7ge_msubPN4bssl7ge_p1p1EPKNS_5ge_p3EPKNS_10ge_precompE, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.br"()[^bb16] : () -> ()
^bb16:  // 3 preds: ^bb13, ^bb14, ^bb15
  "llvm.call"(%arg29, %404) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZN4bssl20x25519_ge_p1p1_to_p2EPNS_5ge_p2EPKNS_7ge_p1p1E, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %458 = "llvm.add"(%435, %397) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %459 = "llvm.icmp"(%435, %398) <{predicate = 4 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%459, %458)[^bb8, ^bb17] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
^bb17:  // 3 preds: ^bb5, ^bb6, ^bb16
  "llvm.intr.lifetime.end"(%406) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%405) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%404) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%403) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%402) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%401) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
