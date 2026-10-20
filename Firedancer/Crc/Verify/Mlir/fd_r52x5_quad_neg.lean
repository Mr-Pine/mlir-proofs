module

-- crc/out/mlirproofs/regions/verify/fd_r52x5_quad_neg.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Firedancer.Crc.Verify

@[expose] public section

mlir_def fd_r52x5_quad_neg :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr, ptr, ptr, ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "256"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], sym_name = "fd_r52x5_quad_neg", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg171: !llvm.ptr, %arg172: !llvm.ptr, %arg173: !llvm.ptr, %arg174: !llvm.ptr, %arg175: !llvm.ptr, %arg176: vector<4xi64>, %arg177: vector<4xi64>, %arg178: vector<4xi64>, %arg179: vector<4xi64>, %arg180: vector<4xi64>):
  %2689 = "llvm.mlir.constant"() <{value = dense<36028797018963664> : vector<4xi64>}> : () -> vector<4xi64>
  %2690 = "llvm.mlir.constant"() <{value = dense<2251799813685247> : vector<4xi64>}> : () -> vector<4xi64>
  %2691 = "llvm.mlir.constant"() <{value = dense<36028797018963952> : vector<4xi64>}> : () -> vector<4xi64>
  %2692 = "llvm.mlir.constant"() <{value = dense<51> : vector<4xi64>}> : () -> vector<4xi64>
  %2693 = "llvm.mlir.constant"() <{value = dense<19> : vector<4xi64>}> : () -> vector<4xi64>
  %2694 = "llvm.sub"(%2689, %arg176) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2695 = "llvm.and"(%2694, %2690) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2696 = "llvm.sub"(%2691, %arg180) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2697 = "llvm.lshr"(%2696, %2692) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2698 = "llvm.call_intrinsic"(%2695, %2693, %2697) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2699 = "llvm.lshr"(%2694, %2692) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2700 = "llvm.sub"(%2691, %arg177) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2701 = "llvm.and"(%2700, %2690) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2702 = "llvm.add"(%2701, %2699) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2703 = "llvm.lshr"(%2700, %2692) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2704 = "llvm.sub"(%2691, %arg178) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2705 = "llvm.and"(%2704, %2690) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2706 = "llvm.add"(%2705, %2703) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2707 = "llvm.lshr"(%2704, %2692) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2708 = "llvm.sub"(%2691, %arg179) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2709 = "llvm.and"(%2708, %2690) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2710 = "llvm.add"(%2709, %2707) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2711 = "llvm.lshr"(%2708, %2692) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2712 = "llvm.and"(%2696, %2690) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2713 = "llvm.add"(%2712, %2711) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.store"(%2698, %arg171) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.store"(%2702, %arg172) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.store"(%2706, %arg173) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.store"(%2710, %arg174) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.store"(%2713, %arg175) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end MLIR.Firedancer.Crc.Verify
