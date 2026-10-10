"llvm.func"() <{CConv = #llvm.cconv<ccc>, dso_local, function_type = !llvm.func<i32 ()>, linkage = #llvm.linkage<internal>, no_inline, no_unwind, passthrough = ["mustprogress", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"], ["warn-stack-size", "25344"]], res_attrs = [{llvm.noundef}], sym_name = "_ZN4bssl18sha512_avx_capableEv", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
  %127 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %128 = "llvm.call"() <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, callee = @_ZN4bssl21CRYPTO_is_AVX_capableEv, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 0, 0>, res_attrs = [{llvm.noundef}]}> : () -> i32
  %129 = "llvm.icmp"(%128, %127) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%129, %127)[^bb2, ^bb1] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i32) -> ()
^bb1:  // pred: ^bb0
  %130 = "llvm.call"() <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, callee = @_ZN4bssl19CRYPTO_is_intel_cpuEv, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 0, 0>, res_attrs = [{llvm.noundef}]}> : () -> i32
  %131 = "llvm.icmp"(%130, %127) <{predicate = 1 : i64}> : (i32, i32) -> i1
  %132 = "llvm.zext"(%131) : (i1) -> i32
  "llvm.br"(%132)[^bb2] : (i32) -> ()
^bb2(%133: i32):  // 2 preds: ^bb0, ^bb1
  "llvm.return"(%133) : (i32) -> ()
}) : () -> ()
