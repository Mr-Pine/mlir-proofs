module

-- crc/out/mlirproofs/regions/verify/wl_permute.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Firedancer.Crc.Ed25519.Avx512

@[expose] public section

mlir_def wl_permute :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.noundef}, {llvm.noundef, llvm.range = #llvm.constant_range<i32, 0, 4>}, {llvm.noundef, llvm.range = #llvm.constant_range<i32, 0, 4>}, {llvm.noundef, llvm.range = #llvm.constant_range<i32, 0, 4>}, {llvm.noundef, llvm.range = #llvm.constant_range<i32, 0, 4>}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<vector<4xi64> (vector<4xi64>, i32, i32, i32, i32)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "256"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], sym_name = "wl_permute", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg134: vector<4xi64>, %arg135: i32, %arg136: i32, %arg137: i32, %arg138: i32):
  %672 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %673 = "llvm.mlir.poison"() : () -> vector<4xi64>
  %674 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %675 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %676 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %677 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %678 = "llvm.alloca"(%672) <{alignment = 32 : i64, elem_type = !llvm.struct<"union.anon.0", (array<1 x vector<4xi64>>)>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%678) : (!llvm.ptr) -> ()
  "llvm.store"(%arg134, %678) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %679 = "llvm.zext"(%arg135) <{nonNeg}> : (i32) -> i64
  %680 = "llvm.getelementptr"(%678, %679) <{elem_type = i64, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %681 = "llvm.load"(%680) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %682 = "llvm.insertelement"(%673, %681, %674) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %683 = "llvm.zext"(%arg136) <{nonNeg}> : (i32) -> i64
  %684 = "llvm.getelementptr"(%678, %683) <{elem_type = i64, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %685 = "llvm.load"(%684) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %686 = "llvm.insertelement"(%682, %685, %675) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %687 = "llvm.zext"(%arg137) <{nonNeg}> : (i32) -> i64
  %688 = "llvm.getelementptr"(%678, %687) <{elem_type = i64, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %689 = "llvm.load"(%688) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %690 = "llvm.insertelement"(%686, %689, %676) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %691 = "llvm.zext"(%arg138) <{nonNeg}> : (i32) -> i64
  %692 = "llvm.getelementptr"(%678, %691) <{elem_type = i64, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %693 = "llvm.load"(%692) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %694 = "llvm.insertelement"(%690, %693, %677) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%678) : (!llvm.ptr) -> ()
  "llvm.return"(%694) : (vector<4xi64>) -> ()
}) : () -> ()

end

end MLIR.Firedancer.Crc.Ed25519.Avx512
