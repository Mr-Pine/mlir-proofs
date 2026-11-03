module

-- crc/out/mlirproofs/regions/verify/fd_r52x5_limbs_eq.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Firedancer.Crc.Ed25519.Avx512

@[expose] public section

mlir_def fd_r52x5_limbs_eq :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.noundef, llvm.readonly}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<i32 (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], res_attrs = [{llvm.range = #llvm.constant_range<i32, 0, 2>}], sym_name = "fd_r52x5_limbs_eq", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg124: !llvm.ptr, %arg125: !llvm.ptr):
  %640 = "llvm.mlir.constant"() <{value = 0 : i4}> : () -> i4
  %641 = "llvm.getelementptr"(%arg124) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %642 = "llvm.load"(%641) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %643 = "llvm.getelementptr"(%arg125) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %644 = "llvm.load"(%643) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %645 = "llvm.load"(%arg124) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %646 = "llvm.load"(%arg125) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %647 = "llvm.icmp"(%642, %644) <{predicate = 0 : i64}> : (i64, i64) -> i1
  %648 = "llvm.icmp"(%645, %646) <{predicate = 1 : i64}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi1>
  %649 = "llvm.bitcast"(%648) : (vector<4xi1>) -> i4
  %650 = "llvm.icmp"(%649, %640) <{predicate = 0 : i64}> : (i4, i4) -> i1
  %651 = "llvm.and"(%650, %647) : (i1, i1) -> i1
  %652 = "llvm.zext"(%651) : (i1) -> i32
  "llvm.return"(%652) : (i32) -> ()
}) : () -> ()

end

end MLIR.Firedancer.Crc.Ed25519.Avx512
