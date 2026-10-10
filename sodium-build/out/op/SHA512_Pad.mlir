"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], dso_local, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, no_inline, no_unwind, passthrough = ["norecurse", "ssp", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], sym_name = "SHA512_Pad", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg20: !llvm.ptr, %arg21: !llvm.ptr):
  %273 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %274 = "llvm.mlir.constant"() <{value = 127 : i32}> : () -> i32
  %275 = "llvm.mlir.constant"() <{value = 112 : i32}> : () -> i32
  %276 = "llvm.mlir.constant"() <{value = 128 : i32}> : () -> i32
  %277 = "llvm.mlir.addressof"() <{global_name = @PAD}> : () -> !llvm.ptr
  %278 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %279 = "llvm.mlir.constant"() <{value = 112 : i64}> : () -> i64
  %280 = "llvm.mlir.constant"() <{value = 16 : i64}> : () -> i64
  "llvm.fence"() <{ordering = 4 : i64}> : () -> ()
  %281 = "llvm.getelementptr"(%arg20) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 72>}> : (!llvm.ptr) -> !llvm.ptr
  %282 = "llvm.load"(%281) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %283 = "llvm.trunc"(%282) <{overflowFlags = 0 : i32}> : (i64) -> i32
  %284 = "llvm.lshr"(%283, %273) : (i32, i32) -> i32
  %285 = "llvm.and"(%284, %274) : (i32, i32) -> i32
  %286 = "llvm.icmp"(%285, %275) <{predicate = 6 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%286)[^bb2, ^bb1] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb1:  // pred: ^bb0
  %287 = "llvm.sub"(%276, %285) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %288 = "llvm.and"(%284, %274) : (i32, i32) -> i32
  %289 = "llvm.zext"(%288) <{nonNeg}> : (i32) -> i64
  %290 = "llvm.getelementptr"(%arg20, %289) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %291 = "llvm.getelementptr"(%290) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 80>}> : (!llvm.ptr) -> !llvm.ptr
  %292 = "llvm.zext"(%287) <{nonNeg}> : (i32) -> i64
  "llvm.intr.memcpy"(%291, %277, %292) <{arg_attrs = [{llvm.align = 1 : i64, llvm.dereferenceable = 1 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 16 : i64, llvm.dereferenceable = 1 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %293 = "llvm.getelementptr"(%arg20) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 80>}> : (!llvm.ptr) -> !llvm.ptr
  %294 = "llvm.getelementptr"(%arg21) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 640>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%arg20, %293, %arg21, %294) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @SHA512_Transform, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.memset"(%293, %278, %279) <{arg_attrs = [{llvm.align = 1 : i64, llvm.dereferenceable = 112 : i64, llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], isVolatile = false}> : (!llvm.ptr, i8, i64) -> ()
  "llvm.br"()[^bb3] : () -> ()
^bb2:  // pred: ^bb0
  %295 = "llvm.and"(%284, %274) : (i32, i32) -> i32
  %296 = "llvm.zext"(%295) <{nonNeg}> : (i32) -> i64
  %297 = "llvm.getelementptr"(%arg20, %296) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %298 = "llvm.getelementptr"(%297) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 80>}> : (!llvm.ptr) -> !llvm.ptr
  %299 = "llvm.sub"(%275, %285) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %300 = "llvm.zext"(%299) <{nonNeg}> : (i32) -> i64
  "llvm.intr.memcpy"(%298, %277, %300) <{arg_attrs = [{llvm.align = 1 : i64}, {llvm.align = 16 : i64, llvm.nonnull}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.br"()[^bb3] : () -> ()
^bb3:  // 2 preds: ^bb1, ^bb2
  %301 = "llvm.getelementptr"(%arg20) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %302 = "llvm.getelementptr"(%arg20) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 80>}> : (!llvm.ptr) -> !llvm.ptr
  %303 = "llvm.getelementptr"(%arg20) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 192>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%303, %301, %280) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @be64enc_vect, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %304 = "llvm.getelementptr"(%arg21) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 640>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%arg20, %302, %arg21, %304) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @SHA512_Transform, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
