module

-- crc/out/mlirproofs/regions/verify/fd_r52x5_limbs_frombytes.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Firedancer.Crc.Ed25519.Avx512

@[expose] public section

mlir_def fd_r52x5_limbs_frombytes :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.noundef, llvm.readonly}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], sym_name = "fd_r52x5_limbs_frombytes", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg90: !llvm.ptr, %arg91: !llvm.ptr):
  %331 = "llvm.mlir.constant"() <{value = 13 : i64}> : () -> i64
  %332 = "llvm.mlir.constant"() <{value = dense<[26, 39]> : vector<2xi64>}> : () -> vector<2xi64>
  %333 = "llvm.mlir.poison"() : () -> vector<4xi64>
  %334 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %335 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %336 = "llvm.mlir.poison"() : () -> vector<2xi64>
  %337 = "llvm.mlir.constant"() <{value = dense<2251799813685247> : vector<4xi64>}> : () -> vector<4xi64>
  %338 = "llvm.mlir.constant"() <{value = 12 : i64}> : () -> i64
  %339 = "llvm.mlir.constant"() <{value = 2251799813685247 : i64}> : () -> i64
  %340 = "llvm.load"(%arg91) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %341 = "llvm.getelementptr"(%arg91) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %342 = "llvm.getelementptr"(%arg91) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %343 = "llvm.getelementptr"(%arg91) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %344 = "llvm.load"(%341) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %345 = "llvm.load"(%341) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  %346 = "llvm.load"(%343) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %347 = "llvm.load"(%342) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  %348 = "llvm.intr.fshl"(%344, %340, %331) : (i64, i64, i64) -> i64
  %349 = "llvm.intr.fshl"(%347, %345, %332) : (vector<2xi64>, vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %350 = "llvm.insertelement"(%333, %340, %334) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %351 = "llvm.insertelement"(%350, %348, %335) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %352 = "llvm.shufflevector"(%349, %336) <{mask = array<i32: 0, 1, -1, -1>}> : (vector<2xi64>, vector<2xi64>) -> vector<4xi64>
  %353 = "llvm.shufflevector"(%351, %352) <{mask = array<i32: 0, 1, 4, 5>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %354 = "llvm.and"(%353, %337) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.store"(%354, %arg90) <{alignment = 8 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %355 = "llvm.lshr"(%346, %338) : (i64, i64) -> i64
  %356 = "llvm.and"(%355, %339) : (i64, i64) -> i64
  %357 = "llvm.getelementptr"(%arg90) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%356, %357) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end MLIR.Firedancer.Crc.Ed25519.Avx512
