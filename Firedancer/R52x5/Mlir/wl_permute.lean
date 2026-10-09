module

-- ~/fd-pr9879/build/llvm23-production/mlir_canonicalized/avx512/op/wl_permute.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Firedancer.R52x5

@[expose] public section

mlir_def wl_permute :=
#tbaa_root = #llvm.tbaa_root<id = "Simple C/C++ TBAA">
#tbaa_type_desc = #llvm.tbaa_type_desc<id = "omnipotent char", members = {<#tbaa_root, 0>}>
#tbaa_tag = #llvm.tbaa_tag<base_type = #tbaa_type_desc, access_type = #tbaa_type_desc, offset = 0>
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.noundef}, {llvm.noundef, llvm.range = #llvm.constant_range<i32, 0, 4>}, {llvm.noundef, llvm.range = #llvm.constant_range<i32, 0, 4>}, {llvm.noundef, llvm.range = #llvm.constant_range<i32, 0, 4>}, {llvm.noundef, llvm.range = #llvm.constant_range<i32, 0, 4>}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<vector<4xi64> (vector<4xi64>, i32, i32, i32, i32)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "256"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], sym_name = "wl_permute", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg118: vector<4xi64>, %arg119: i32, %arg120: i32, %arg121: i32, %arg122: i32):
  %3250 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %3251 = "llvm.mlir.poison"() : () -> vector<4xi64>
  %3252 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %3253 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %3254 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %3255 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %3256 = "llvm.alloca"(%3250) <{alignment = 32 : i64, elem_type = !llvm.struct<"union.anon", (array<1 x vector<4xi64>>)>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%3256) : (!llvm.ptr) -> ()
  "llvm.store"(%arg118, %3256) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<4xi64>, !llvm.ptr) -> ()
  %3257 = "llvm.zext"(%arg119) <{nonNeg}> : (i32) -> i64
  %3258 = "llvm.getelementptr"(%3256, %3257) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %3259 = "llvm.load"(%3258) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> i64
  %3260 = "llvm.insertelement"(%3251, %3259, %3252) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %3261 = "llvm.zext"(%arg120) <{nonNeg}> : (i32) -> i64
  %3262 = "llvm.getelementptr"(%3256, %3261) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %3263 = "llvm.load"(%3262) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> i64
  %3264 = "llvm.insertelement"(%3260, %3263, %3253) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %3265 = "llvm.zext"(%arg121) <{nonNeg}> : (i32) -> i64
  %3266 = "llvm.getelementptr"(%3256, %3265) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %3267 = "llvm.load"(%3266) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> i64
  %3268 = "llvm.insertelement"(%3264, %3267, %3254) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %3269 = "llvm.zext"(%arg122) <{nonNeg}> : (i32) -> i64
  %3270 = "llvm.getelementptr"(%3256, %3269) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %3271 = "llvm.load"(%3270) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> i64
  %3272 = "llvm.insertelement"(%3268, %3271, %3255) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%3256) : (!llvm.ptr) -> ()
  "llvm.return"(%3272) : (vector<4xi64>) -> ()
}) : () -> ()

end

end MLIR.Firedancer.R52x5
