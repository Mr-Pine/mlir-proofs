module

-- crc/out/mlirproofs/regions/verify/fd_r52x5_base_table_build.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_ge_dbln
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_odd_table
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_base_split_table
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_base_table

meta import MLIR.Semantics.Func
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_ge_dbln
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_odd_table
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_base_split_table
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_base_table

namespace MLIR.Firedancer.Crc.Verify

@[expose] public section

mlir_def fd_r52x5_base_table_build :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void ()>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = readwrite, argMem = none, inaccessibleMem = none, errnoMem = readwrite, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "256"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], sym_name = "fd_r52x5_base_table_build", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
  %299 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %300 = "llvm.mlir.constant"() <{value = dense<[1738742601995546, 1801439850948184, 1, 1841354044333475]> : vector<4xi64>}> : () -> vector<4xi64>
  %301 = "llvm.mlir.constant"() <{value = dense<[1146398526822698, 1351079888211148, 0, 16398895984059]> : vector<4xi64>}> : () -> vector<4xi64>
  %302 = "llvm.mlir.constant"() <{value = dense<[2070867633025821, 450359962737049, 0, 755974180946558]> : vector<4xi64>}> : () -> vector<4xi64>
  %303 = "llvm.mlir.constant"() <{value = dense<[562264141797630, 900719925474099, 0, 900171276175154]> : vector<4xi64>}> : () -> vector<4xi64>
  %304 = "llvm.mlir.constant"() <{value = dense<[587772402128613, 1801439850948198, 0, 1821297809914039]> : vector<4xi64>}> : () -> vector<4xi64>
  %305 = "llvm.mlir.addressof"() <{global_name = @fd_r52x5_base_table}> : () -> !llvm.ptr
  %306 = "llvm.mlir.constant"() <{value = 128 : i32}> : () -> i32
  %307 = "llvm.mlir.addressof"() <{global_name = @fd_r52x5_base_split_table}> : () -> !llvm.ptr
  %308 = "llvm.getelementptr"(%307) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24576>}> : (!llvm.ptr) -> !llvm.ptr
  %309 = "llvm.getelementptr"(%307) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 49152>}> : (!llvm.ptr) -> !llvm.ptr
  %310 = "llvm.getelementptr"(%307) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 73728>}> : (!llvm.ptr) -> !llvm.ptr
  %311 = "llvm.getelementptr"(%307) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 98304>}> : (!llvm.ptr) -> !llvm.ptr
  %312 = "llvm.getelementptr"(%307) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 122880>}> : (!llvm.ptr) -> !llvm.ptr
  %313 = "llvm.getelementptr"(%307) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 147456>}> : (!llvm.ptr) -> !llvm.ptr
  %314 = "llvm.alloca"(%299) <{alignment = 64 : i64, elem_type = !llvm.struct<"struct.fd_r52x5_ge", (vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, array<32 x i8>)>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%314) : (!llvm.ptr) -> ()
  "llvm.store"(%300, %314) <{alignment = 64 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %315 = "llvm.getelementptr"(%314) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%301, %315) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %316 = "llvm.getelementptr"(%314) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%302, %316) <{alignment = 64 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %317 = "llvm.getelementptr"(%314) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%303, %317) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %318 = "llvm.getelementptr"(%314) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%304, %318) <{alignment = 64 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.call"(%305, %314, %306) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_odd_table, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> ()
  "llvm.call"(%314, %314) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_ge_dbln, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%307, %314, %306) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_odd_table, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> ()
  "llvm.call"(%314, %314) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_ge_dbln, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%308, %314, %306) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_odd_table, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> ()
  "llvm.call"(%314, %314) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_ge_dbln, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%309, %314, %306) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_odd_table, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> ()
  "llvm.call"(%314, %314) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_ge_dbln, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%310, %314, %306) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_odd_table, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> ()
  "llvm.call"(%314, %314) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_ge_dbln, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%311, %314, %306) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_odd_table, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> ()
  "llvm.call"(%314, %314) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_ge_dbln, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%312, %314, %306) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_odd_table, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> ()
  "llvm.call"(%314, %314) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_ge_dbln, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%313, %314, %306) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_odd_table, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> ()
  "llvm.intr.lifetime.end"(%314) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
  with @fd_r52x5_ge_dbln := fd_r52x5_ge_dbln, @fd_r52x5_odd_table := fd_r52x5_odd_table,
    @fd_r52x5_base_split_table := fd_r52x5_base_split_table,
    @fd_r52x5_base_table := fd_r52x5_base_table

end

end MLIR.Firedancer.Crc.Verify
