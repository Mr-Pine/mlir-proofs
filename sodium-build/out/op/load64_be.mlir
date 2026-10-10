"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<i64 (ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "ssp", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], sym_name = "load64_be", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg24: !llvm.ptr):
  %311 = "llvm.mlir.constant"() <{value = 8 : i64}> : () -> i64
  %312 = "llvm.mlir.constant"() <{value = 16 : i64}> : () -> i64
  %313 = "llvm.mlir.constant"() <{value = 24 : i64}> : () -> i64
  %314 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %315 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
  %316 = "llvm.mlir.constant"() <{value = 48 : i64}> : () -> i64
  %317 = "llvm.mlir.constant"() <{value = 56 : i64}> : () -> i64
  %318 = "llvm.getelementptr"(%arg24) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 7>}> : (!llvm.ptr) -> !llvm.ptr
  %319 = "llvm.load"(%318) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %320 = "llvm.zext"(%319) : (i8) -> i64
  %321 = "llvm.getelementptr"(%arg24) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 6>}> : (!llvm.ptr) -> !llvm.ptr
  %322 = "llvm.load"(%321) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %323 = "llvm.zext"(%322) : (i8) -> i64
  %324 = "llvm.shl"(%323, %311) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %325 = "llvm.or"(%324, %320) <{isDisjoint}> : (i64, i64) -> i64
  %326 = "llvm.getelementptr"(%arg24) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 5>}> : (!llvm.ptr) -> !llvm.ptr
  %327 = "llvm.load"(%326) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %328 = "llvm.zext"(%327) : (i8) -> i64
  %329 = "llvm.shl"(%328, %312) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %330 = "llvm.or"(%325, %329) <{isDisjoint}> : (i64, i64) -> i64
  %331 = "llvm.getelementptr"(%arg24) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 4>}> : (!llvm.ptr) -> !llvm.ptr
  %332 = "llvm.load"(%331) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %333 = "llvm.zext"(%332) : (i8) -> i64
  %334 = "llvm.shl"(%333, %313) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %335 = "llvm.or"(%330, %334) <{isDisjoint}> : (i64, i64) -> i64
  %336 = "llvm.getelementptr"(%arg24) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 3>}> : (!llvm.ptr) -> !llvm.ptr
  %337 = "llvm.load"(%336) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %338 = "llvm.zext"(%337) : (i8) -> i64
  %339 = "llvm.shl"(%338, %314) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %340 = "llvm.or"(%335, %339) <{isDisjoint}> : (i64, i64) -> i64
  %341 = "llvm.getelementptr"(%arg24) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 2>}> : (!llvm.ptr) -> !llvm.ptr
  %342 = "llvm.load"(%341) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %343 = "llvm.zext"(%342) : (i8) -> i64
  %344 = "llvm.shl"(%343, %315) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %345 = "llvm.or"(%340, %344) : (i64, i64) -> i64
  %346 = "llvm.getelementptr"(%arg24) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 1>}> : (!llvm.ptr) -> !llvm.ptr
  %347 = "llvm.load"(%346) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %348 = "llvm.zext"(%347) : (i8) -> i64
  %349 = "llvm.shl"(%348, %316) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %350 = "llvm.or"(%345, %349) : (i64, i64) -> i64
  %351 = "llvm.load"(%arg24) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %352 = "llvm.zext"(%351) : (i8) -> i64
  %353 = "llvm.shl"(%352, %317) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %354 = "llvm.or"(%350, %353) : (i64, i64) -> i64
  "llvm.return"(%354) : (i64) -> ()
}) : () -> ()
