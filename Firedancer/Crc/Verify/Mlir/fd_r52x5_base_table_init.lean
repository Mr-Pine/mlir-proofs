module

-- crc/out/mlirproofs/regions/verify/fd_r52x5_base_table_init.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_base_table_build
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_base_table_init__fd_once_block_state

meta import MLIR.Semantics.Func
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_base_table_build
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_base_table_init__fd_once_block_state

namespace MLIR.Firedancer.Crc.Verify

@[expose] public section

mlir_def fd_r52x5_base_table_init :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void ()>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = readwrite, argMem = readwrite, inaccessibleMem = none, errnoMem = readwrite, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], sym_name = "fd_r52x5_base_table_init", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
  %3224 = "llvm.mlir.addressof"() <{global_name = @fd_r52x5_base_table_init._fd_once_block_state}> : () -> !llvm.ptr
  %3225 = "llvm.mlir.constant"() <{value = true}> : () -> i1
  %3226 = "llvm.load"(%3224) <{alignment = 4 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i1
  "llvm.cond_br"(%3226)[^bb2, ^bb1] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb1:  // pred: ^bb0
  "llvm.call"() <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, callee = @fd_r52x5_base_table_build, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = readwrite, argMem = none, inaccessibleMem = none, errnoMem = readwrite, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
  "llvm.store"(%3225, %3224) <{alignment = 4 : i64, ordering = 0 : i64}> : (i1, !llvm.ptr) -> ()
  "llvm.br"()[^bb2] : () -> ()
^bb2:  // 2 preds: ^bb0, ^bb1
  "llvm.return"() : () -> ()
}) : () -> ()
  with @fd_r52x5_base_table_build := fd_r52x5_base_table_build,
    @fd_r52x5_base_table_init._fd_once_block_state := fd_r52x5_base_table_init__fd_once_block_state

end

end MLIR.Firedancer.Crc.Verify
