module

-- build/llvm23/mlir_canonicalized/avx512/op/fd_f25519_sub.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Firedancer.Avx512

@[expose] public section

mlir_def fd_f25519_sub :=
#tbaa_root = #llvm.tbaa_root<id = "Simple C/C++ TBAA">
#tbaa_type_desc = #llvm.tbaa_type_desc<id = "omnipotent char", members = {<#tbaa_root, 0>}>
#tbaa_tag = #llvm.tbaa_tag<base_type = #tbaa_type_desc, access_type = #tbaa_type_desc, offset = 0>
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nofree, llvm.nonnull, llvm.noundef, llvm.returned, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<ptr (ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], res_attrs = [{llvm.nonnull, llvm.noundef}], sym_name = "fd_f25519_sub", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg141: !llvm.ptr, %arg142: !llvm.ptr, %arg143: !llvm.ptr):
  %3336 = "llvm.mlir.constant"() <{value = dense<[159383552, 1048576, 1048576, 1048576, 1048576, 1048576, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %3337 = "llvm.mlir.constant"() <{value = dense<[-1, 0, 0, 0, 0, 0, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %3338 = "llvm.mlir.constant"() <{value = dense<18> : vector<8xi64>}> : () -> vector<8xi64>
  %3339 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %3340 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %3341 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %3342 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %3343 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %3344 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %3345 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %3346 = "llvm.mlir.constant"() <{value = dense<[8795933638637, 8796091973631, 8796091973631, 8796091973631, 8796091973631, 1099510579199, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %3347 = "llvm.mlir.constant"() <{value = dense<[8796093022207, 8796093022207, 8796093022207, 8796093022207, 8796093022207, 1099511627775, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %3348 = "llvm.mlir.constant"() <{value = dense<[43, 43, 43, 43, 43, 40, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %3349 = "llvm.mlir.poison"() : () -> i64
  %3350 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %3351 = "llvm.mlir.undef"() : () -> vector<8xi64>
  %3352 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %3353 = "llvm.insertelement"(%3351, %3350, %3352) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3354 = "llvm.insertelement"(%3353, %3349, %3345) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3355 = "llvm.insertelement"(%3354, %3349, %3344) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3356 = "llvm.insertelement"(%3355, %3349, %3343) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3357 = "llvm.insertelement"(%3356, %3349, %3342) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3358 = "llvm.insertelement"(%3357, %3349, %3341) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3359 = "llvm.insertelement"(%3358, %3349, %3340) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3360 = "llvm.insertelement"(%3359, %3349, %3339) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3361 = "llvm.load"(%arg142) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %3362 = "llvm.load"(%arg143) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %3363 = "llvm.sub"(%3361, %3362) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3364 = "llvm.add"(%3363, %3346) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3365 = "llvm.and"(%3364, %3347) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3366 = "llvm.ashr"(%3364, %3348) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3367 = "llvm.shufflevector"(%3366, %3360) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 8, 8>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3368 = "llvm.mul"(%3367, %3338) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3369 = "llvm.and"(%3368, %3337) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3370 = "llvm.add"(%3365, %3336) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3371 = "llvm.add"(%3370, %3367) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3372 = "llvm.add"(%3371, %3369) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%3372, %arg141) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.return"(%arg141) : (!llvm.ptr) -> ()
}) : () -> ()

end

end MLIR.Firedancer.Avx512
