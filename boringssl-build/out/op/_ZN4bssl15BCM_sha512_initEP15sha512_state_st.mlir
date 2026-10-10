"llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef, llvm.writeonly}], dso_local, function_type = !llvm.func<i32 (ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"], ["warn-stack-size", "25344"]], res_attrs = [{llvm.noundef}], sym_name = "_ZN4bssl15BCM_sha512_initEP15sha512_state_st", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg9: !llvm.ptr):
  %55 = "llvm.mlir.constant"() <{value = 7640891576956012808 : i64}> : () -> i64
  %56 = "llvm.mlir.constant"() <{value = -4942790177534073029 : i64}> : () -> i64
  %57 = "llvm.mlir.constant"() <{value = 4354685564936845355 : i64}> : () -> i64
  %58 = "llvm.mlir.constant"() <{value = -6534734903238641935 : i64}> : () -> i64
  %59 = "llvm.mlir.constant"() <{value = 5840696475078001361 : i64}> : () -> i64
  %60 = "llvm.mlir.constant"() <{value = -7276294671716946913 : i64}> : () -> i64
  %61 = "llvm.mlir.constant"() <{value = 2270897969802886507 : i64}> : () -> i64
  %62 = "llvm.mlir.constant"() <{value = 6620516959819538809 : i64}> : () -> i64
  %63 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %64 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %65 = "llvm.mlir.constant"() <{value = 0 : i16}> : () -> i16
  %66 = "llvm.mlir.constant"() <{value = 64 : i16}> : () -> i16
  "llvm.store"(%55, %arg9) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %67 = "llvm.getelementptr"(%arg9) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%56, %67) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %68 = "llvm.getelementptr"(%arg9) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%57, %68) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %69 = "llvm.getelementptr"(%arg9) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%58, %69) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %70 = "llvm.getelementptr"(%arg9) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%59, %70) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %71 = "llvm.getelementptr"(%arg9) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%60, %71) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %72 = "llvm.getelementptr"(%arg9) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 48>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%61, %72) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %73 = "llvm.getelementptr"(%arg9) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 56>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%62, %73) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %74 = "llvm.getelementptr"(%arg9) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 72>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%63, %74) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %75 = "llvm.getelementptr"(%arg9) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 68>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%64, %75) <{alignment = 4 : i64, ordering = 0 : i64}> : (i32, !llvm.ptr) -> ()
  %76 = "llvm.getelementptr"(%arg9) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%65, %76) <{alignment = 8 : i64, ordering = 0 : i64}> : (i16, !llvm.ptr) -> ()
  %77 = "llvm.getelementptr"(%arg9) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 66>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%66, %77) <{alignment = 2 : i64, ordering = 0 : i64}> : (i16, !llvm.ptr) -> ()
  "llvm.return"(%64) : (i32) -> ()
}) : () -> ()
