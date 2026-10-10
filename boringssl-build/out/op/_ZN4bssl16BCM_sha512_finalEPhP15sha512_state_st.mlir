"llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], dso_local, function_type = !llvm.func<i32 (ptr, ptr)>, linkage = #llvm.linkage<internal>, no_inline, no_unwind, passthrough = ["mustprogress", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"], ["warn-stack-size", "25344"]], res_attrs = [{llvm.noundef}], sym_name = "_ZN4bssl16BCM_sha512_finalEPhP15sha512_state_st", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg10: !llvm.ptr, %arg11: !llvm.ptr):
  %78 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %79 = "llvm.getelementptr"(%arg11) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 66>}> : (!llvm.ptr) -> !llvm.ptr
  %80 = "llvm.load"(%79) <{alignment = 2 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i16
  %81 = "llvm.zext"(%80) : (i16) -> i64
  "llvm.call"(%arg10, %81, %arg11) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @_ZL17sha512_final_implPhmP15sha512_state_st, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, i64, !llvm.ptr) -> ()
  "llvm.return"(%78) : (i32) -> ()
}) : () -> ()
