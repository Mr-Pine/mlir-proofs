module

-- crc/out/mlirproofs/regions/verify/fd_r52x5_quad_lane_canon.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_canon
public import Firedancer.Crc.Verify.Mlir.wl_extract_variable

meta import MLIR.Semantics.Func
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_canon
meta import Firedancer.Crc.Verify.Mlir.wl_extract_variable

namespace MLIR.Firedancer.Crc.Verify

@[expose] public section

mlir_def fd_r52x5_quad_lane_canon :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef, llvm.range = #llvm.constant_range<i32, 0, 3>}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, i32)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "256"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], sym_name = "fd_r52x5_quad_lane_canon", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg34: !llvm.ptr, %arg35: vector<4xi64>, %arg36: vector<4xi64>, %arg37: vector<4xi64>, %arg38: vector<4xi64>, %arg39: vector<4xi64>, %arg40: i32):
  %85 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %86 = "llvm.alloca"(%85) <{alignment = 16 : i64, elem_type = !llvm.array<5 x i64>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%86) : (!llvm.ptr) -> ()
  %87 = "llvm.call"(%arg35, %arg40) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @wl_extract_variable, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<4xi64>, i32) -> i64
  "llvm.store"(%87, %86) <{alignment = 16 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %88 = "llvm.getelementptr"(%86) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %89 = "llvm.call"(%arg36, %arg40) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @wl_extract_variable, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<4xi64>, i32) -> i64
  "llvm.store"(%89, %88) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %90 = "llvm.getelementptr"(%86) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %91 = "llvm.call"(%arg37, %arg40) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @wl_extract_variable, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<4xi64>, i32) -> i64
  "llvm.store"(%91, %90) <{alignment = 16 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %92 = "llvm.getelementptr"(%86) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %93 = "llvm.call"(%arg38, %arg40) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @wl_extract_variable, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<4xi64>, i32) -> i64
  "llvm.store"(%93, %92) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %94 = "llvm.getelementptr"(%86) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %95 = "llvm.call"(%arg39, %arg40) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @wl_extract_variable, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<4xi64>, i32) -> i64
  "llvm.store"(%95, %94) <{alignment = 16 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.call"(%arg34, %86) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_canon, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%86) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
  with @fd_r52x5_canon := fd_r52x5_canon, @wl_extract_variable := wl_extract_variable

end

end MLIR.Firedancer.Crc.Verify
