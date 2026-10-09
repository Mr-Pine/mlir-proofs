module

-- ~/fd-pr9879/build/llvm23-production/mlir_canonicalized/avx512/op/fd_f25519_frombytes.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.R52x5.Mlir.fd_ulong_load_8

meta import MLIR.Semantics.Func
meta import Firedancer.R52x5.Mlir.fd_ulong_load_8

namespace MLIR.Firedancer.R52x5

@[expose] public section

mlir_def fd_f25519_frombytes :=
#tbaa_root = #llvm.tbaa_root<id = "Simple C/C++ TBAA">
#tbaa_type_desc = #llvm.tbaa_type_desc<id = "omnipotent char", members = {<#tbaa_root, 0>}>
#tbaa_tag = #llvm.tbaa_tag<base_type = #tbaa_type_desc, access_type = #tbaa_type_desc, offset = 0>
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nofree, llvm.noundef, llvm.returned, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<ptr (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], res_attrs = [{llvm.noundef}], sym_name = "fd_f25519_frombytes", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg171: !llvm.ptr, %arg172: !llvm.ptr):
  %4820 = "llvm.mlir.constant"() <{value = 4 : i64}> : () -> i64
  %4821 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %4822 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %4823 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %4824 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %4825 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %4826 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %4827 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %4828 = "llvm.mlir.constant"() <{value = 12 : i64}> : () -> i64
  %4829 = "llvm.mlir.poison"() : () -> vector<4xi64>
  %4830 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %4831 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %4832 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %4833 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %4834 = "llvm.mlir.constant"() <{value = dense<[0, 3, 6, 1]> : vector<4xi64>}> : () -> vector<4xi64>
  %4835 = "llvm.mlir.constant"() <{value = dense<2251799813685247> : vector<4xi64>}> : () -> vector<4xi64>
  %4836 = "llvm.mlir.constant"() <{value = 2251799813685247 : i64}> : () -> i64
  %4837 = "llvm.mlir.poison"() : () -> i64
  %4838 = "llvm.mlir.undef"() : () -> vector<8xi64>
  %4839 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %4840 = "llvm.insertelement"(%4838, %4837, %4839) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4841 = "llvm.insertelement"(%4840, %4837, %4827) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4842 = "llvm.insertelement"(%4841, %4837, %4826) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4843 = "llvm.insertelement"(%4842, %4837, %4825) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4844 = "llvm.insertelement"(%4843, %4837, %4824) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4845 = "llvm.insertelement"(%4844, %4830, %4823) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4846 = "llvm.insertelement"(%4845, %4830, %4822) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4847 = "llvm.insertelement"(%4846, %4830, %4821) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4848 = "llvm.getelementptr"(%arg172) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6>}> : (!llvm.ptr) -> !llvm.ptr
  %4849 = "llvm.call"(%4848) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @fd_ulong_load_8, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i64
  %4850 = "llvm.getelementptr"(%arg172) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 12>}> : (!llvm.ptr) -> !llvm.ptr
  %4851 = "llvm.call"(%4850) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @fd_ulong_load_8, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i64
  %4852 = "llvm.getelementptr"(%arg172) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 19>}> : (!llvm.ptr) -> !llvm.ptr
  %4853 = "llvm.call"(%4852) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @fd_ulong_load_8, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i64
  %4854 = "llvm.call"(%arg172) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_ulong_load_8, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i64
  %4855 = "llvm.insertelement"(%4829, %4854, %4830) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %4856 = "llvm.insertelement"(%4855, %4849, %4831) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %4857 = "llvm.insertelement"(%4856, %4851, %4832) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %4858 = "llvm.insertelement"(%4857, %4853, %4833) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %4859 = "llvm.lshr"(%4858, %4834) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4860 = "llvm.and"(%4859, %4835) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %4861 = "llvm.getelementptr"(%arg172) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %4862 = "llvm.call"(%4861) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @fd_ulong_load_8, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i64
  %4863 = "llvm.lshr"(%4862, %4828) : (i64, i64) -> i64
  %4864 = "llvm.and"(%4863, %4836) : (i64, i64) -> i64
  %4865 = "llvm.shufflevector"(%4860, %4829) <{mask = array<i32: 0, 1, 2, 3, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %4866 = "llvm.shufflevector"(%4865, %4847) <{mask = array<i32: 0, 1, 2, 3, -1, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4867 = "llvm.insertelement"(%4866, %4864, %4820) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  "llvm.store"(%4867, %arg171) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.return"(%arg171) : (!llvm.ptr) -> ()
}) : () -> ()
  with @fd_ulong_load_8 := fd_ulong_load_8

end

end MLIR.Firedancer.R52x5
