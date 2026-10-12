"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 32 : i64, llvm.dead_on_unwind, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writable, llvm.writeonly}, {llvm.noundef, llvm.range = #llvm.constant_range<i64, -128, 128>}], dso_local, function_type = !llvm.func<void (ptr, i64)>, linkage = #llvm.linkage<internal>, passthrough = ["nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], sym_name = "_RNvMs2_NtCsh8hPzWUDumX_14solana_ed255196windowINtB5_15NafLookupTable8NtNtNtNtNtB7_7backend6vector4avx27edwards11CachedPointE6selectB7_", target_cpu = "x86-64-v2", target_features = #llvm.target_features<["+avx", "+avx2", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+crc32", "+ssse3"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg14: !llvm.ptr, %arg15: i64):
  %437 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %438 = "llvm.mlir.constant"() <{value = 128 : i64}> : () -> i64
  %439 = "llvm.mlir.constant"() <{value = 64 : i64}> : () -> i64
  %440 = "llvm.mlir.addressof"() <{global_name = @anon.e79fcfe266c5706188f989b4d452749f.38}> : () -> !llvm.ptr
  %441 = "llvm.mlir.addressof"() <{global_name = @_RNvNtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx29constants26BASEPOINT_ODD_LOOKUP_TABLE}> : () -> !llvm.ptr
  %442 = "llvm.mlir.constant"() <{value = 160 : i64}> : () -> i64
  %443 = "llvm.lshr"(%arg15, %437) : (i64, i64) -> i64
  %444 = "llvm.icmp"(%arg15, %438) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%444)[^bb1, ^bb2] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb1:  // pred: ^bb0
  %445 = "llvm.getelementptr"(%441, %443) <{elem_type = !llvm.struct<(struct<(array<5 x vector<4xi64>>)>)>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.intr.memcpy"(%arg14, %445, %442) <{arg_attrs = [{llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.return"() : () -> ()
^bb2:  // pred: ^bb0
  "llvm.call"(%443, %439, %440) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 24 : i64, llvm.noalias, llvm.nofree, llvm.noundef, llvm.readonly}], callee = @_RNvNtCsgxBkk5gSRhY_4core9panicking18panic_bounds_check, fastmathFlags = #llvm.fastmath<none>, no_inline, noreturn, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i64, i64, !llvm.ptr) -> ()
  "llvm.unreachable"() : () -> ()
}) : () -> ()
