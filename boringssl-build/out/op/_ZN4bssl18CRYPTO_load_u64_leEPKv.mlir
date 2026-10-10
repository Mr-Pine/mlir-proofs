"llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.noundef}], dso_local, function_type = !llvm.func<i64 (ptr)>, linkage = #llvm.linkage<internal>, no_inline, no_unwind, passthrough = ["mustprogress", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"], ["warn-stack-size", "25344"]], res_attrs = [{llvm.noundef}], sym_name = "_ZN4bssl18CRYPTO_load_u64_leEPKv", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg33: !llvm.ptr):
  %460 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %461 = "llvm.mlir.constant"() <{value = 8 : i64}> : () -> i64
  %462 = "llvm.alloca"(%460) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%462) : (!llvm.ptr) -> ()
  %463 = "llvm.call"(%462, %arg33, %461) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @_ZN4bssl14OPENSSL_memcpyEPvPKvm, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>, res_attrs = [{llvm.noundef}]}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %464 = "llvm.load"(%462) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  "llvm.intr.lifetime.end"(%462) : (!llvm.ptr) -> ()
  "llvm.return"(%464) : (i64) -> ()
}) : () -> ()
