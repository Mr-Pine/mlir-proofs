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
^bb0(%arg144: !llvm.ptr, %arg145: !llvm.ptr, %arg146: !llvm.ptr):
  %3347 = "llvm.mlir.constant"() <{value = dense<[159383552, 1048576, 1048576, 1048576, 1048576, 1048576, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %3348 = "llvm.mlir.constant"() <{value = dense<[-1, 0, 0, 0, 0, 0, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %3349 = "llvm.mlir.constant"() <{value = dense<18> : vector<8xi64>}> : () -> vector<8xi64>
  %3350 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %3351 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %3352 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %3353 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %3354 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %3355 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %3356 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %3357 = "llvm.mlir.constant"() <{value = dense<[8795933638637, 8796091973631, 8796091973631, 8796091973631, 8796091973631, 1099510579199, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %3358 = "llvm.mlir.constant"() <{value = dense<[8796093022207, 8796093022207, 8796093022207, 8796093022207, 8796093022207, 1099511627775, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %3359 = "llvm.mlir.constant"() <{value = dense<[43, 43, 43, 43, 43, 40, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %3360 = "llvm.mlir.poison"() : () -> i64
  %3361 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %3362 = "llvm.mlir.undef"() : () -> vector<8xi64>
  %3363 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %3364 = "llvm.insertelement"(%3362, %3361, %3363) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3365 = "llvm.insertelement"(%3364, %3360, %3356) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3366 = "llvm.insertelement"(%3365, %3360, %3355) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3367 = "llvm.insertelement"(%3366, %3360, %3354) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3368 = "llvm.insertelement"(%3367, %3360, %3353) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3369 = "llvm.insertelement"(%3368, %3360, %3352) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3370 = "llvm.insertelement"(%3369, %3360, %3351) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3371 = "llvm.insertelement"(%3370, %3360, %3350) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3372 = "llvm.load"(%arg145) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %3373 = "llvm.load"(%arg146) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %3374 = "llvm.sub"(%3372, %3373) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3375 = "llvm.add"(%3374, %3357) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3376 = "llvm.and"(%3375, %3358) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3377 = "llvm.ashr"(%3375, %3359) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3378 = "llvm.shufflevector"(%3377, %3371) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 8, 8>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3379 = "llvm.mul"(%3378, %3349) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3380 = "llvm.and"(%3379, %3348) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3381 = "llvm.add"(%3376, %3347) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3382 = "llvm.add"(%3381, %3378) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3383 = "llvm.add"(%3382, %3380) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%3383, %arg144) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.return"(%arg144) : (!llvm.ptr) -> ()
}) : () -> ()

end

end MLIR.Firedancer.Avx512
