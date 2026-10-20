module

-- crc/out/mlirproofs/regions/verify/fd_r52x5_quad_negate_lazy.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Firedancer.Crc.Verify

@[expose] public section

mlir_def fd_r52x5_quad_negate_lazy :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr, ptr, ptr, ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "256"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], sym_name = "fd_r52x5_quad_negate_lazy", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg99: !llvm.ptr, %arg100: !llvm.ptr, %arg101: !llvm.ptr, %arg102: !llvm.ptr, %arg103: !llvm.ptr, %arg104: vector<4xi64>, %arg105: vector<4xi64>, %arg106: vector<4xi64>, %arg107: vector<4xi64>, %arg108: vector<4xi64>):
  %437 = "llvm.mlir.constant"() <{value = dense<72057594037927328> : vector<4xi64>}> : () -> vector<4xi64>
  %438 = "llvm.mlir.constant"() <{value = dense<72057594037927904> : vector<4xi64>}> : () -> vector<4xi64>
  %439 = "llvm.sub"(%437, %arg104) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %440 = "llvm.sub"(%438, %arg105) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %441 = "llvm.sub"(%438, %arg106) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %442 = "llvm.sub"(%438, %arg107) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %443 = "llvm.sub"(%438, %arg108) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.store"(%439, %arg99) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.store"(%440, %arg100) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.store"(%441, %arg101) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.store"(%442, %arg102) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.store"(%443, %arg103) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end MLIR.Firedancer.Crc.Verify
