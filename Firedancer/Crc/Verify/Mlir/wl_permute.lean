module

-- crc/out/mlirproofs/regions/verify/wl_permute.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Firedancer.Crc.Verify

@[expose] public section

mlir_def wl_permute :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.noundef}, {llvm.noundef, llvm.range = #llvm.constant_range<i32, 0, 4>}, {llvm.noundef, llvm.range = #llvm.constant_range<i32, 0, 4>}, {llvm.noundef, llvm.range = #llvm.constant_range<i32, 0, 4>}, {llvm.noundef, llvm.range = #llvm.constant_range<i32, 0, 4>}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<vector<4xi64> (vector<4xi64>, i32, i32, i32, i32)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "256"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], sym_name = "wl_permute", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg181: vector<4xi64>, %arg182: i32, %arg183: i32, %arg184: i32, %arg185: i32):
  %2714 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %2715 = "llvm.mlir.poison"() : () -> vector<4xi64>
  %2716 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %2717 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %2718 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %2719 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %2720 = "llvm.alloca"(%2714) <{alignment = 32 : i64, elem_type = !llvm.struct<"union.anon", (array<1 x vector<4xi64>>)>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%2720) : (!llvm.ptr) -> ()
  "llvm.store"(%arg181, %2720) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %2721 = "llvm.zext"(%arg182) <{nonNeg}> : (i32) -> i64
  %2722 = "llvm.getelementptr"(%2720, %2721) <{elem_type = i64, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %2723 = "llvm.load"(%2722) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2724 = "llvm.insertelement"(%2715, %2723, %2716) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %2725 = "llvm.zext"(%arg183) <{nonNeg}> : (i32) -> i64
  %2726 = "llvm.getelementptr"(%2720, %2725) <{elem_type = i64, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %2727 = "llvm.load"(%2726) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2728 = "llvm.insertelement"(%2724, %2727, %2717) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %2729 = "llvm.zext"(%arg184) <{nonNeg}> : (i32) -> i64
  %2730 = "llvm.getelementptr"(%2720, %2729) <{elem_type = i64, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %2731 = "llvm.load"(%2730) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2732 = "llvm.insertelement"(%2728, %2731, %2718) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %2733 = "llvm.zext"(%arg185) <{nonNeg}> : (i32) -> i64
  %2734 = "llvm.getelementptr"(%2720, %2733) <{elem_type = i64, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %2735 = "llvm.load"(%2734) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2736 = "llvm.insertelement"(%2732, %2735, %2719) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2720) : (!llvm.ptr) -> ()
  "llvm.return"(%2736) : (vector<4xi64>) -> ()
}) : () -> ()

end

end MLIR.Firedancer.Crc.Verify
