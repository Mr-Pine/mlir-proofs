module

-- build/llvm23/mlir_canonicalized/avx512/op/fd_long_if.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Firedancer.Avx512

@[expose] public section

mlir_def fd_long_if :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.noundef, llvm.range = #llvm.constant_range<i32, 0, 2>}], dso_local, function_type = !llvm.func<i64 (i32)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], res_attrs = [{llvm.noundef, llvm.range = #llvm.constant_range<i64, 0, 20>}], sym_name = "fd_long_if", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg26: i32):
  %306 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %307 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %308 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %309 = "llvm.icmp"(%arg26, %306) <{predicate = 0 : i64}> : (i32, i32) -> i1
  %310 = "llvm.select"(%309, %307, %308) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  "llvm.return"(%310) : (i64) -> ()
}) : () -> ()

end

end MLIR.Firedancer.Avx512
