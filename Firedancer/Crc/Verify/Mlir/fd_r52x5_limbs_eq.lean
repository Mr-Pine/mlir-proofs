module

-- crc/out/mlirproofs/regions/verify/fd_r52x5_limbs_eq.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Firedancer.Crc.Verify

@[expose] public section

mlir_def fd_r52x5_limbs_eq :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.noundef, llvm.readonly}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<i32 (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], res_attrs = [{llvm.range = #llvm.constant_range<i32, 0, 2>}], sym_name = "fd_r52x5_limbs_eq", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg41: !llvm.ptr, %arg42: !llvm.ptr):
  %96 = "llvm.mlir.constant"() <{value = 0 : i4}> : () -> i4
  %97 = "llvm.getelementptr"(%arg41) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %98 = "llvm.load"(%97) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %99 = "llvm.getelementptr"(%arg42) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %100 = "llvm.load"(%99) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %101 = "llvm.load"(%arg41) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %102 = "llvm.load"(%arg42) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %103 = "llvm.icmp"(%98, %100) <{predicate = 0 : i64}> : (i64, i64) -> i1
  %104 = "llvm.icmp"(%101, %102) <{predicate = 1 : i64}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi1>
  %105 = "llvm.bitcast"(%104) : (vector<4xi1>) -> i4
  %106 = "llvm.icmp"(%105, %96) <{predicate = 0 : i64}> : (i4, i4) -> i1
  %107 = "llvm.and"(%106, %103) : (i1, i1) -> i1
  %108 = "llvm.zext"(%107) : (i1) -> i32
  "llvm.return"(%108) : (i32) -> ()
}) : () -> ()

end

end MLIR.Firedancer.Crc.Verify
