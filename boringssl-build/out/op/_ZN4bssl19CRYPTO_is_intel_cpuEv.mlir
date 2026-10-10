"llvm.func"() <{CConv = #llvm.cconv<ccc>, dso_local, function_type = !llvm.func<i32 ()>, linkage = #llvm.linkage<internal>, no_inline, no_unwind, passthrough = ["mustprogress", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"], ["warn-stack-size", "25344"]], res_attrs = [{llvm.noundef}], sym_name = "_ZN4bssl19CRYPTO_is_intel_cpuEv", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
  %177 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %178 = "llvm.mlir.constant"() <{value = 30 : i32}> : () -> i32
  %179 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %180 = "llvm.call"(%177) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_ZN4bssl19OPENSSL_get_ia32capEi, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}], will_return}> : (i32) -> i32
  %181 = "llvm.lshr"(%180, %178) : (i32, i32) -> i32
  %182 = "llvm.and"(%181, %179) : (i32, i32) -> i32
  "llvm.return"(%182) : (i32) -> ()
}) : () -> ()
