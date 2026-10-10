"llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], dso_local, function_type = !llvm.func<ptr (ptr, i32, i64)>, linkage = #llvm.linkage<internal>, no_inline, no_unwind, passthrough = ["mustprogress", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"], ["warn-stack-size", "25344"]], res_attrs = [{llvm.noundef}], sym_name = "_ZN4bssl14OPENSSL_memsetEPvim", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg88: !llvm.ptr, %arg89: i32, %arg90: i64):
  %1367 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %1368 = "llvm.icmp"(%arg90, %1367) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1368)[^bb2, ^bb1] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb1:  // pred: ^bb0
  %1369 = "llvm.trunc"(%arg89) <{overflowFlags = 0 : i32}> : (i32) -> i8
  "llvm.intr.memset"(%arg88, %1369, %arg90) <{arg_attrs = [{llvm.align = 1 : i64}, {}, {}], isVolatile = false}> : (!llvm.ptr, i8, i64) -> ()
  "llvm.br"()[^bb2] : () -> ()
^bb2:  // 2 preds: ^bb0, ^bb1
  "llvm.return"(%arg88) : (!llvm.ptr) -> ()
}) : () -> ()
