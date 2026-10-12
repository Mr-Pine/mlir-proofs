"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 32 : i64, llvm.dead_on_unwind, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writable, llvm.writeonly}, {llvm.align = 32 : i64, llvm.dereferenceable = 1280 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.noundef, llvm.range = #llvm.constant_range<i64, -128, 128>}], dso_local, function_type = !llvm.func<void (ptr, ptr, i64)>, linkage = #llvm.linkage<internal>, passthrough = ["nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], sym_name = "_RNvMNtCsh8hPzWUDumX_14solana_ed255196windowINtB2_15NafLookupTable5NtNtNtNtNtB4_7backend6vector4avx27edwards11CachedPointE6selectB4_", target_cpu = "x86-64-v2", target_features = #llvm.target_features<["+avx", "+avx2", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+crc32", "+ssse3"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg16: !llvm.ptr, %arg17: !llvm.ptr, %arg18: i64):
  %446 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %447 = "llvm.mlir.constant"() <{value = 16 : i64}> : () -> i64
  %448 = "llvm.mlir.constant"() <{value = 8 : i64}> : () -> i64
  %449 = "llvm.mlir.addressof"() <{global_name = @anon.e79fcfe266c5706188f989b4d452749f.25}> : () -> !llvm.ptr
  %450 = "llvm.mlir.constant"() <{value = 160 : i64}> : () -> i64
  %451 = "llvm.lshr"(%arg18, %446) : (i64, i64) -> i64
  %452 = "llvm.icmp"(%arg18, %447) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%452)[^bb1, ^bb2] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb1:  // pred: ^bb0
  %453 = "llvm.getelementptr"(%arg17, %451) <{elem_type = !llvm.struct<(struct<(array<5 x vector<4xi64>>)>)>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.intr.memcpy"(%arg16, %453, %450) <{arg_attrs = [{llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.return"() : () -> ()
^bb2:  // pred: ^bb0
  "llvm.call"(%451, %448, %449) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 24 : i64, llvm.noalias, llvm.nofree, llvm.noundef, llvm.readonly}], callee = @_RNvNtCsgxBkk5gSRhY_4core9panicking18panic_bounds_check, fastmathFlags = #llvm.fastmath<none>, no_inline, noreturn, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i64, i64, !llvm.ptr) -> ()
  "llvm.unreachable"() : () -> ()
}) : () -> ()
