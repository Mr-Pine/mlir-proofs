module

-- crc/out/mlirproofs/regions/verify/fd_r52x5_quad_sub.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Firedancer.Crc.Verify

@[expose] public section

mlir_def fd_r52x5_quad_sub :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr, ptr, ptr, ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "256"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], sym_name = "fd_r52x5_quad_sub", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg15: !llvm.ptr, %arg16: !llvm.ptr, %arg17: !llvm.ptr, %arg18: !llvm.ptr, %arg19: !llvm.ptr, %arg20: vector<4xi64>, %arg21: vector<4xi64>, %arg22: vector<4xi64>, %arg23: vector<4xi64>, %arg24: vector<4xi64>, %arg25: vector<4xi64>, %arg26: vector<4xi64>, %arg27: vector<4xi64>, %arg28: vector<4xi64>, %arg29: vector<4xi64>):
  %23 = "llvm.mlir.constant"() <{value = dense<36028797018963664> : vector<4xi64>}> : () -> vector<4xi64>
  %24 = "llvm.mlir.constant"() <{value = dense<2251799813685247> : vector<4xi64>}> : () -> vector<4xi64>
  %25 = "llvm.mlir.constant"() <{value = dense<36028797018963952> : vector<4xi64>}> : () -> vector<4xi64>
  %26 = "llvm.mlir.constant"() <{value = dense<51> : vector<4xi64>}> : () -> vector<4xi64>
  %27 = "llvm.mlir.constant"() <{value = dense<19> : vector<4xi64>}> : () -> vector<4xi64>
  %28 = "llvm.sub"(%arg20, %arg25) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %29 = "llvm.add"(%28, %23) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %30 = "llvm.and"(%29, %24) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %31 = "llvm.sub"(%arg24, %arg29) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %32 = "llvm.add"(%31, %25) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %33 = "llvm.lshr"(%32, %26) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %34 = "llvm.call_intrinsic"(%30, %27, %33) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %35 = "llvm.lshr"(%29, %26) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %36 = "llvm.sub"(%arg21, %arg26) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %37 = "llvm.add"(%36, %25) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %38 = "llvm.and"(%37, %24) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %39 = "llvm.add"(%38, %35) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %40 = "llvm.lshr"(%37, %26) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %41 = "llvm.sub"(%arg22, %arg27) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %42 = "llvm.add"(%41, %25) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %43 = "llvm.and"(%42, %24) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %44 = "llvm.add"(%43, %40) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %45 = "llvm.lshr"(%42, %26) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %46 = "llvm.sub"(%arg23, %arg28) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %47 = "llvm.add"(%46, %25) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %48 = "llvm.and"(%47, %24) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %49 = "llvm.add"(%48, %45) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %50 = "llvm.lshr"(%47, %26) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %51 = "llvm.and"(%32, %24) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %52 = "llvm.add"(%51, %50) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.store"(%34, %arg15) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.store"(%39, %arg16) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.store"(%44, %arg17) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.store"(%49, %arg18) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.store"(%52, %arg19) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end MLIR.Firedancer.Crc.Verify
