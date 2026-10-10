"llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], dso_local, function_type = !llvm.func<i32 (ptr, ptr, i64)>, linkage = #llvm.linkage<internal>, no_inline, no_unwind, passthrough = ["mustprogress", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"], ["warn-stack-size", "25344"]], res_attrs = [{llvm.noundef}], sym_name = "_ZN4bssl17BCM_sha512_updateEP15sha512_state_stPKvm", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg12: !llvm.ptr, %arg13: !llvm.ptr, %arg14: i64):
  %82 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %83 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %84 = "llvm.mlir.constant"() <{value = 0 : i16}> : () -> i16
  %85 = "llvm.mlir.constant"() <{value = 128 : i64}> : () -> i64
  %86 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %87 = "llvm.mlir.constant"() <{value = 127 : i64}> : () -> i64
  %88 = "llvm.mlir.constant"() <{value = 7 : i64}> : () -> i64
  %89 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %90 = "llvm.getelementptr"(%arg12) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 80>}> : (!llvm.ptr) -> !llvm.ptr
  %91 = "llvm.icmp"(%arg14, %82) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%91)[^bb12, ^bb1] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb1:  // pred: ^bb0
  %92 = "llvm.getelementptr"(%arg12) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 72>}> : (!llvm.ptr) -> !llvm.ptr
  %93 = "llvm.load"(%92) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %94 = "llvm.add"(%93, %arg14) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%94, %92) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %95 = "llvm.icmp"(%94, %arg14) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%95)[^bb2, ^bb3] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb2:  // pred: ^bb1
  %96 = "llvm.getelementptr"(%arg12) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 68>}> : (!llvm.ptr) -> !llvm.ptr
  %97 = "llvm.load"(%96) <{alignment = 4 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %98 = "llvm.add"(%97, %83) <{overflowFlags = 0 : i32}> : (i32, i32) -> i32
  "llvm.store"(%98, %96) <{alignment = 4 : i64, ordering = 0 : i64}> : (i32, !llvm.ptr) -> ()
  "llvm.br"()[^bb3] : () -> ()
^bb3:  // 2 preds: ^bb1, ^bb2
  %99 = "llvm.getelementptr"(%arg12) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %100 = "llvm.load"(%99) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i16
  %101 = "llvm.icmp"(%100, %84) <{predicate = 0 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%101, %arg14, %arg13)[^bb7, ^bb4] <{operandSegmentSizes = array<i32: 1, 2, 0>}> : (i1, i64, !llvm.ptr) -> ()
^bb4:  // pred: ^bb3
  %102 = "llvm.zext"(%100) : (i16) -> i64
  %103 = "llvm.sub"(%85, %102) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %104 = "llvm.icmp"(%arg14, %103) <{predicate = 6 : i64}> : (i64, i64) -> i1
  %105 = "llvm.getelementptr"(%90, %102) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.cond_br"(%104)[^bb5, ^bb6] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb5:  // pred: ^bb4
  %106 = "llvm.call"(%105, %arg13, %arg14) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @_ZN4bssl14OPENSSL_memcpyEPvPKvm, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>, res_attrs = [{llvm.noundef}]}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %107 = "llvm.trunc"(%arg14) <{overflowFlags = 0 : i32}> : (i64) -> i16
  %108 = "llvm.load"(%99) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i16
  %109 = "llvm.add"(%108, %107) <{overflowFlags = 0 : i32}> : (i16, i16) -> i16
  "llvm.br"(%109)[^bb11] : (i16) -> ()
^bb6:  // pred: ^bb4
  %110 = "llvm.call"(%105, %arg13, %103) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @_ZN4bssl14OPENSSL_memcpyEPvPKvm, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>, res_attrs = [{llvm.noundef}]}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%84, %99) <{alignment = 8 : i64, ordering = 0 : i64}> : (i16, !llvm.ptr) -> ()
  %111 = "llvm.sub"(%arg14, %103) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %112 = "llvm.getelementptr"(%arg13, %103) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.call"(%arg12, %90, %86) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @_ZL23sha512_block_data_orderPmPKhm, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.br"(%111, %112)[^bb7] : (i64, !llvm.ptr) -> ()
^bb7(%113: i64, %114: !llvm.ptr):  // 2 preds: ^bb3, ^bb6
  %115 = "llvm.icmp"(%113, %87) <{predicate = 8 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%115, %113, %114)[^bb8, ^bb9] <{operandSegmentSizes = array<i32: 1, 0, 2>}> : (i1, i64, !llvm.ptr) -> ()
^bb8:  // pred: ^bb7
  %116 = "llvm.lshr"(%113, %88) : (i64, i64) -> i64
  "llvm.call"(%arg12, %114, %116) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @_ZL23sha512_block_data_orderPmPKhm, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %117 = "llvm.getelementptr"(%114, %113) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %118 = "llvm.and"(%113, %87) : (i64, i64) -> i64
  %119 = "llvm.sub"(%82, %118) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %120 = "llvm.getelementptr"(%117, %119) <{elem_type = i8, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.br"(%118, %120)[^bb9] : (i64, !llvm.ptr) -> ()
^bb9(%121: i64, %122: !llvm.ptr):  // 2 preds: ^bb7, ^bb8
  %123 = "llvm.icmp"(%121, %82) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%123)[^bb12, ^bb10] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb10:  // pred: ^bb9
  %124 = "llvm.call"(%90, %122, %121) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @_ZN4bssl14OPENSSL_memcpyEPvPKvm, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>, res_attrs = [{llvm.noundef}]}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %125 = "llvm.trunc"(%121) <{overflowFlags = 3 : i32}> : (i64) -> i16
  "llvm.br"(%125)[^bb11] : (i16) -> ()
^bb11(%126: i16):  // 2 preds: ^bb5, ^bb10
  "llvm.store"(%126, %99) <{alignment = 8 : i64, ordering = 0 : i64}> : (i16, !llvm.ptr) -> ()
  "llvm.br"()[^bb12] : () -> ()
^bb12:  // 3 preds: ^bb0, ^bb9, ^bb11
  "llvm.return"(%89) : (i32) -> ()
}) : () -> ()
