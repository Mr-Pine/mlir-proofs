module

-- build/llvm23/mlir_canonicalized/avx512/op/fd_r43x6_repsqr_mul2.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Avx512.Mlir.fd_r43x6_mul_fast
public import Firedancer.Avx512.Mlir.fd_r43x6_sqr_fast

meta import MLIR.Semantics.Func
meta import Firedancer.Avx512.Mlir.fd_r43x6_mul_fast
meta import Firedancer.Avx512.Mlir.fd_r43x6_sqr_fast

namespace MLIR.Firedancer.Avx512

@[expose] public section

mlir_def fd_r43x6_repsqr_mul2 :=
#loop_unroll = #llvm.loop_unroll<disable = true>
#tbaa_root = #llvm.tbaa_root<id = "Simple C/C++ TBAA">
#loop_annotation = #llvm.loop_annotation<unroll = #loop_unroll, mustProgress = true>
#tbaa_type_desc = #llvm.tbaa_type_desc<id = "omnipotent char", members = {<#tbaa_root, 0>}>
#tbaa_tag = #llvm.tbaa_tag<base_type = #tbaa_type_desc, access_type = #tbaa_type_desc, offset = 0>
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef, llvm.writeonly}, {llvm.noundef}, {llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.writeonly}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef, llvm.range = #llvm.constant_range<i64, 0, 101>}], dso_local, function_type = !llvm.func<void (ptr, vector<8xi64>, vector<8xi64>, ptr, vector<8xi64>, vector<8xi64>, i64)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], sym_name = "fd_r43x6_repsqr_mul2", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg28: !llvm.ptr, %arg29: vector<8xi64>, %arg30: vector<8xi64>, %arg31: !llvm.ptr, %arg32: vector<8xi64>, %arg33: vector<8xi64>, %arg34: i64):
  %443 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %444 = "llvm.mlir.constant"() <{value = dense<[8796093022207, 8796093022207, 8796093022207, 8796093022207, 8796093022207, 1099511627775, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %445 = "llvm.mlir.constant"() <{value = dense<[43, 43, 43, 43, 43, 40, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %446 = "llvm.mlir.poison"() : () -> vector<8xi64>
  %447 = "llvm.mlir.constant"() <{value = dense<[19, 1, 1, 1, 1, 1, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %448 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %449 = "llvm.icmp"(%arg34, %443) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%449, %arg32, %arg29, %arg29, %arg32, %arg34)[^bb2, ^bb1] <{operandSegmentSizes = array<i32: 1, 2, 3>}> : (i1, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, i64) -> ()
^bb1(%450: vector<8xi64>, %451: vector<8xi64>, %452: i64):  // 2 preds: ^bb0, ^bb1
  %453 = "llvm.call"(%450) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> vector<8xi64>
  %454 = "llvm.and"(%453, %444) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %455 = "llvm.lshr"(%453, %445) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %456 = "llvm.shufflevector"(%455, %446) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %457 = "llvm.call_intrinsic"(%454, %447, %456) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %458 = "llvm.call"(%451) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> vector<8xi64>
  %459 = "llvm.and"(%458, %444) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %460 = "llvm.lshr"(%458, %445) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %461 = "llvm.shufflevector"(%460, %446) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %462 = "llvm.call_intrinsic"(%459, %447, %461) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %463 = "llvm.add"(%452, %448) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %464 = "llvm.icmp"(%463, %443) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%464, %462, %457, %457, %462, %463)[^bb2, ^bb1] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 2, 3>}> : (i1, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, i64) -> ()
^bb2(%465: vector<8xi64>, %466: vector<8xi64>):  // 2 preds: ^bb0, ^bb1
  %467 = "llvm.call"(%466, %arg30) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %468 = "llvm.and"(%467, %444) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %469 = "llvm.lshr"(%467, %445) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %470 = "llvm.shufflevector"(%469, %446) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %471 = "llvm.call_intrinsic"(%468, %447, %470) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %472 = "llvm.call"(%465, %arg33) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %473 = "llvm.and"(%472, %444) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %474 = "llvm.lshr"(%472, %445) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %475 = "llvm.shufflevector"(%474, %446) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %476 = "llvm.call_intrinsic"(%473, %447, %475) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%471, %arg28) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%476, %arg31) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
  with @fd_r43x6_mul_fast := fd_r43x6_mul_fast, @fd_r43x6_sqr_fast := fd_r43x6_sqr_fast

end

end MLIR.Firedancer.Avx512
