module

-- crc/out/mlirproofs/regions/verify/wl_extract_variable.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Firedancer.Crc.Ed25519.Avx512

@[expose] public section

mlir_def wl_extract_variable :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.noundef}, {llvm.noundef, llvm.range = #llvm.constant_range<i32, 0, 3>}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<i64 (vector<4xi64>, i32)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "256"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], sym_name = "wl_extract_variable", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg122: vector<4xi64>, %arg123: i32):
  %635 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %636 = "llvm.alloca"(%635) <{alignment = 32 : i64, elem_type = !llvm.array<1 x struct<"union.anon", (array<1 x vector<4xi64>>)>>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%636) : (!llvm.ptr) -> ()
  "llvm.store"(%arg122, %636) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %637 = "llvm.zext"(%arg123) <{nonNeg}> : (i32) -> i64
  %638 = "llvm.getelementptr"(%636, %637) <{elem_type = i64, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %639 = "llvm.load"(%638) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  "llvm.intr.lifetime.end"(%636) : (!llvm.ptr) -> ()
  "llvm.return"(%639) : (i64) -> ()
}) : () -> ()

end

end MLIR.Firedancer.Crc.Ed25519.Avx512
