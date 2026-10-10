"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], dso_local, function_type = !llvm.func<i32 (ptr, i64, ptr, i64, ptr, ptr)>, linkage = #llvm.linkage<internal>, no_inline, no_unwind, passthrough = ["mustprogress", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"], ["warn-stack-size", "25344"]], res_attrs = [{llvm.noundef, llvm.range = #llvm.constant_range<i32, 0, 2>}], sym_name = "_ZL14ed25519_verifyPKhmS0_mS0_S0_", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg34: !llvm.ptr, %arg35: i64, %arg36: !llvm.ptr, %arg37: i64, %arg38: !llvm.ptr, %arg39: !llvm.ptr):
  %465 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %466 = "llvm.mlir.constant"() <{value = 32 : i8}> : () -> i8
  %467 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %468 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %469 = "llvm.mlir.constant"() <{value = 1152921504606846976 : i64}> : () -> i64
  %470 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %471 = "llvm.mlir.constant"() <{value = 1503914060200516822 : i64}> : () -> i64
  %472 = "llvm.mlir.constant"() <{value = 6346243789798364140 : i64}> : () -> i64
  %473 = "llvm.alloca"(%465) <{alignment = 8 : i64, elem_type = !llvm.struct<"struct.bssl::ge_cached", (struct<"struct.bssl::fe", (array<5 x i64>)>, struct<"struct.bssl::fe", (array<5 x i64>)>, struct<"struct.bssl::fe", (array<5 x i64>)>, struct<"struct.bssl::fe", (array<5 x i64>)>)>}> : (i32) -> !llvm.ptr
  %474 = "llvm.alloca"(%465) <{alignment = 8 : i64, elem_type = !llvm.struct<"struct.bssl::fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %475 = "llvm.alloca"(%465) <{alignment = 16 : i64, elem_type = !llvm.array<32 x i8>}> : (i32) -> !llvm.ptr
  %476 = "llvm.alloca"(%465) <{alignment = 16 : i64, elem_type = !llvm.array<32 x i8>}> : (i32) -> !llvm.ptr
  %477 = "llvm.alloca"(%465) <{alignment = 16 : i64, elem_type = !llvm.array<32 x i8>}> : (i32) -> !llvm.ptr
  %478 = "llvm.alloca"(%465) <{alignment = 8 : i64, elem_type = !llvm.struct<"struct.sha512_state_st", (array<8 x i64>, i16, i16, i32, i64, array<128 x i8>)>}> : (i32) -> !llvm.ptr
  %479 = "llvm.alloca"(%465) <{alignment = 16 : i64, elem_type = !llvm.array<64 x i8>}> : (i32) -> !llvm.ptr
  %480 = "llvm.alloca"(%465) <{alignment = 8 : i64, elem_type = !llvm.struct<"struct.bssl::ge_precomp", (struct<"struct.bssl::fe", (array<5 x i64>)>, struct<"struct.bssl::fe", (array<5 x i64>)>, struct<"struct.bssl::fe", (array<5 x i64>)>)>}> : (i32) -> !llvm.ptr
  %481 = "llvm.alloca"(%465) <{alignment = 16 : i64, elem_type = !llvm.array<32 x i8>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%473) : (!llvm.ptr) -> ()
  %482 = "llvm.getelementptr"(%arg38) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 63>}> : (!llvm.ptr) -> !llvm.ptr
  %483 = "llvm.load"(%482) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %484 = "llvm.icmp"(%483, %466) <{predicate = 6 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%484, %467)[^bb1, ^bb10] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb1:  // pred: ^bb0
  %485 = "llvm.call"(%473, %arg39) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @_ZN4bssl27x25519_ge_frombytes_vartimeEPNS_5ge_p3EPKh, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>, res_attrs = [{llvm.noundef}]}> : (!llvm.ptr, !llvm.ptr) -> i32
  %486 = "llvm.icmp"(%485, %467) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%486, %467)[^bb10, ^bb2] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i32) -> ()
^bb2:  // pred: ^bb1
  "llvm.intr.lifetime.start"(%474) : (!llvm.ptr) -> ()
  "llvm.call"(%474, %473) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZL6fe_negPN4bssl8fe_looseEPKNS_2feE, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%473, %474) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZL8fe_carryPN4bssl2feEPKNS_8fe_looseE, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %487 = "llvm.getelementptr"(%473) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 120>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%474, %487) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZL6fe_negPN4bssl8fe_looseEPKNS_2feE, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%487, %474) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZL8fe_carryPN4bssl2feEPKNS_8fe_looseE, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%475) : (!llvm.ptr) -> ()
  %488 = "llvm.call"(%475, %arg39, %468) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @_ZN4bssl14OPENSSL_memcpyEPvPKvm, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>, res_attrs = [{llvm.noundef}]}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%476) : (!llvm.ptr) -> ()
  %489 = "llvm.call"(%476, %arg38, %468) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @_ZN4bssl14OPENSSL_memcpyEPvPKvm, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>, res_attrs = [{llvm.noundef}]}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%477) : (!llvm.ptr) -> ()
  %490 = "llvm.getelementptr"(%arg38) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %491 = "llvm.call"(%477, %490, %468) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @_ZN4bssl14OPENSSL_memcpyEPvPKvm, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>, res_attrs = [{llvm.noundef}]}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %492 = "llvm.getelementptr"(%477) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %493 = "llvm.call"(%492) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @_ZN4bssl18CRYPTO_load_u64_leEPKv, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (!llvm.ptr) -> i64
  %494 = "llvm.icmp"(%493, %469) <{predicate = 8 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%494, %467)[^bb9, ^bb3] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i32) -> ()
^bb3:  // pred: ^bb2
  %495 = "llvm.icmp"(%493, %469) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%495)[^bb7, ^bb8] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb4:  // pred: ^bb7
  %496 = "llvm.getelementptr"(%477) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %497 = "llvm.call"(%496) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @_ZN4bssl18CRYPTO_load_u64_leEPKv, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (!llvm.ptr) -> i64
  %498 = "llvm.icmp"(%497, %471) <{predicate = 8 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%498, %467)[^bb9, ^bb5] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i32) -> ()
^bb5:  // pred: ^bb4
  %499 = "llvm.icmp"(%497, %471) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%499)[^bb6, ^bb8] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb6:  // pred: ^bb5
  %500 = "llvm.call"(%477) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @_ZN4bssl18CRYPTO_load_u64_leEPKv, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (!llvm.ptr) -> i64
  %501 = "llvm.icmp"(%500, %472) <{predicate = 8 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%501, %467)[^bb9, ^bb8] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i32) -> ()
^bb7:  // pred: ^bb3
  %502 = "llvm.getelementptr"(%477) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %503 = "llvm.call"(%502) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @_ZN4bssl18CRYPTO_load_u64_leEPKv, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (!llvm.ptr) -> i64
  %504 = "llvm.icmp"(%503, %470) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%504, %467)[^bb4, ^bb9] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb8:  // 3 preds: ^bb3, ^bb5, ^bb6
  "llvm.intr.lifetime.start"(%478) : (!llvm.ptr) -> ()
  %505 = "llvm.call"(%478) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @SHA512_Init, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i32
  %506 = "llvm.call"(%478, %arg34, %arg35) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @SHA512_Update, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> i32
  %507 = "llvm.call"(%478, %arg38, %468) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @SHA512_Update, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> i32
  %508 = "llvm.call"(%478, %arg39, %468) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @SHA512_Update, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> i32
  %509 = "llvm.call"(%478, %arg36, %arg37) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @SHA512_Update, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> i32
  "llvm.intr.lifetime.start"(%479) : (!llvm.ptr) -> ()
  %510 = "llvm.call"(%479, %478) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @SHA512_Final, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> i32
  "llvm.call"(%479) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @_ZN4bssl16x25519_sc_reduceEPh, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%480) : (!llvm.ptr) -> ()
  "llvm.call"(%480, %479, %473, %477) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @_ZL28ge_double_scalarmult_vartimePN4bssl5ge_p2EPKhPKNS_5ge_p3ES3_, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%481) : (!llvm.ptr) -> ()
  "llvm.call"(%481, %480) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZN4bssl17x25519_ge_tobytesEPhPKNS_5ge_p2E, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %511 = "llvm.call"(%481, %476, %468) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @CRYPTO_memcmp, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> i32
  %512 = "llvm.icmp"(%511, %467) <{predicate = 0 : i64}> : (i32, i32) -> i1
  %513 = "llvm.zext"(%512) : (i1) -> i32
  "llvm.intr.lifetime.end"(%481) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%480) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%479) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%478) : (!llvm.ptr) -> ()
  "llvm.br"(%513)[^bb9] : (i32) -> ()
^bb9(%514: i32):  // 5 preds: ^bb2, ^bb4, ^bb6, ^bb7, ^bb8
  "llvm.intr.lifetime.end"(%477) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%476) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%475) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%474) : (!llvm.ptr) -> ()
  "llvm.br"(%514)[^bb10] : (i32) -> ()
^bb10(%515: i32):  // 3 preds: ^bb0, ^bb1, ^bb9
  "llvm.intr.lifetime.end"(%473) : (!llvm.ptr) -> ()
  "llvm.return"(%515) : (i32) -> ()
}) : () -> ()
