module

-- crc/out/mlirproofs/regions/verify/fd_r52x5_limbs_frombytes.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Firedancer.Crc.Verify

@[expose] public section

mlir_def fd_r52x5_limbs_frombytes :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.noundef, llvm.readonly}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], sym_name = "fd_r52x5_limbs_frombytes", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg30: !llvm.ptr, %arg31: !llvm.ptr):
  %53 = "llvm.mlir.constant"() <{value = 13 : i64}> : () -> i64
  %54 = "llvm.mlir.constant"() <{value = dense<[26, 39]> : vector<2xi64>}> : () -> vector<2xi64>
  %55 = "llvm.mlir.poison"() : () -> vector<4xi64>
  %56 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %57 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %58 = "llvm.mlir.poison"() : () -> vector<2xi64>
  %59 = "llvm.mlir.constant"() <{value = dense<2251799813685247> : vector<4xi64>}> : () -> vector<4xi64>
  %60 = "llvm.mlir.constant"() <{value = 12 : i64}> : () -> i64
  %61 = "llvm.mlir.constant"() <{value = 2251799813685247 : i64}> : () -> i64
  %62 = "llvm.load"(%arg31) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %63 = "llvm.getelementptr"(%arg31) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %64 = "llvm.getelementptr"(%arg31) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %65 = "llvm.getelementptr"(%arg31) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %66 = "llvm.load"(%63) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %67 = "llvm.load"(%63) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  %68 = "llvm.load"(%65) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %69 = "llvm.load"(%64) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  %70 = "llvm.intr.fshl"(%66, %62, %53) : (i64, i64, i64) -> i64
  %71 = "llvm.intr.fshl"(%69, %67, %54) : (vector<2xi64>, vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %72 = "llvm.insertelement"(%55, %62, %56) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %73 = "llvm.insertelement"(%72, %70, %57) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %74 = "llvm.shufflevector"(%71, %58) <{mask = array<i32: 0, 1, -1, -1>}> : (vector<2xi64>, vector<2xi64>) -> vector<4xi64>
  %75 = "llvm.shufflevector"(%73, %74) <{mask = array<i32: 0, 1, 4, 5>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %76 = "llvm.and"(%75, %59) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.store"(%76, %arg30) <{alignment = 8 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %77 = "llvm.lshr"(%68, %60) : (i64, i64) -> i64
  %78 = "llvm.and"(%77, %61) : (i64, i64) -> i64
  %79 = "llvm.getelementptr"(%arg30) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%78, %79) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end MLIR.Firedancer.Crc.Verify
