module

-- ~/fd-pr9879/build/llvm23-production/mlir_canonicalized/avx512/op/fd_sha512_append.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.R52x5.Mlir.fd_memcpy
public import Firedancer.R52x5.Extern.fd_sha512_core_avx2

meta import MLIR.Semantics.Func
meta import Firedancer.R52x5.Mlir.fd_memcpy
meta import Firedancer.R52x5.Extern.fd_sha512_core_avx2

namespace MLIR.Firedancer.R52x5

@[expose] public section

noncomputable mlir_def fd_sha512_append :=
#tbaa_root = #llvm.tbaa_root<id = "Simple C/C++ TBAA">
#tbaa_type_desc = #llvm.tbaa_type_desc<id = "omnipotent char", members = {<#tbaa_root, 0>}>
#tbaa_type_desc1 = #llvm.tbaa_type_desc<id = "long", members = {<#tbaa_type_desc, 0>}>
#tbaa_type_desc3 = #llvm.tbaa_type_desc<id = "fd_sha512_private", members = {<#tbaa_type_desc, 0>, <#tbaa_type_desc, 128>, <#tbaa_type_desc1, 192>, <#tbaa_type_desc1, 200>, <#tbaa_type_desc1, 208>, <#tbaa_type_desc1, 216>}>
#tbaa_tag3 = #llvm.tbaa_tag<base_type = #tbaa_type_desc3, access_type = #tbaa_type_desc1, offset = 200>
#tbaa_tag4 = #llvm.tbaa_tag<base_type = #tbaa_type_desc3, access_type = #tbaa_type_desc1, offset = 208>
#tbaa_tag5 = #llvm.tbaa_tag<base_type = #tbaa_type_desc3, access_type = #tbaa_type_desc1, offset = 216>
"llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.noundef, llvm.returned}, {llvm.noundef}, {llvm.noundef}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<ptr (ptr, ptr, i64)>, linkage = #llvm.linkage<internal>, no_inline, no_unwind, passthrough = ["sspstrong", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], res_attrs = [{llvm.noundef}], sym_name = "fd_sha512_append", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg42: !llvm.ptr, %arg43: !llvm.ptr, %arg44: i64):
  %388 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %389 = "llvm.mlir.constant"() <{value = 128 : i64}> : () -> i64
  %390 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %391 = "llvm.mlir.constant"() <{value = 61 : i64}> : () -> i64
  %392 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %393 = "llvm.mlir.constant"() <{value = 7 : i64}> : () -> i64
  %394 = "llvm.mlir.constant"() <{value = 127 : i64}> : () -> i64
  %395 = "llvm.mlir.constant"() <{value = -128 : i64}> : () -> i64
  %396 = "llvm.icmp"(%arg44, %388) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%396)[^bb10, ^bb1] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb1:  // pred: ^bb0
  %397 = "llvm.getelementptr"(%arg42) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %398 = "llvm.getelementptr"(%arg42) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 200>}> : (!llvm.ptr) -> !llvm.ptr
  %399 = "llvm.load"(%398) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag3]}> : (!llvm.ptr) -> i64
  %400 = "llvm.getelementptr"(%arg42) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 208>}> : (!llvm.ptr) -> !llvm.ptr
  %401 = "llvm.load"(%400) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag4]}> : (!llvm.ptr) -> i64
  %402 = "llvm.getelementptr"(%arg42) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 216>}> : (!llvm.ptr) -> !llvm.ptr
  %403 = "llvm.load"(%402) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag5]}> : (!llvm.ptr) -> i64
  %404 = "llvm.shl"(%arg44, %390) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %405 = "llvm.add"(%401, %404) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %406 = "llvm.lshr"(%arg44, %391) : (i64, i64) -> i64
  %407 = "llvm.add"(%403, %406) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %408 = "llvm.icmp"(%405, %401) <{predicate = 6 : i64}> : (i64, i64) -> i1
  %409 = "llvm.zext"(%408) : (i1) -> i64
  %410 = "llvm.add"(%407, %409) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%405, %400) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag4]}> : (i64, !llvm.ptr) -> ()
  "llvm.store"(%410, %402) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag5]}> : (i64, !llvm.ptr) -> ()
  %411 = "llvm.icmp"(%399, %388) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%411, %arg43, %arg44)[^bb5, ^bb2] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 2, 0>}> : (i1, !llvm.ptr, i64) -> ()
^bb2:  // pred: ^bb1
  %412 = "llvm.sub"(%389, %399) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %413 = "llvm.icmp"(%arg44, %412) <{predicate = 6 : i64}> : (i64, i64) -> i1
  %414 = "llvm.getelementptr"(%arg42, %399) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.cond_br"(%413)[^bb3, ^bb4] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb3:  // pred: ^bb2
  "llvm.call"(%414, %arg43, %arg44) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_memcpy, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %415 = "llvm.add"(%399, %arg44) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.br"(%415)[^bb9] : (i64) -> ()
^bb4:  // pred: ^bb2
  "llvm.call"(%414, %arg43, %412) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_memcpy, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %416 = "llvm.getelementptr"(%arg43, %412) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %417 = "llvm.sub"(%arg44, %412) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  "llvm.call"(%397, %arg42, %392) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_core_avx2, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.store"(%388, %398) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag3]}> : (i64, !llvm.ptr) -> ()
  "llvm.br"(%416, %417)[^bb5] : (!llvm.ptr, i64) -> ()
^bb5(%418: !llvm.ptr, %419: i64):  // 2 preds: ^bb1, ^bb4
  %420 = "llvm.lshr"(%419, %393) : (i64, i64) -> i64
  %421 = "llvm.icmp"(%420, %388) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%421)[^bb7, ^bb6] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb6:  // pred: ^bb5
  "llvm.call"(%397, %418, %420) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_core_avx2, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.br"()[^bb7] : () -> ()
^bb7:  // 2 preds: ^bb5, ^bb6
  %422 = "llvm.and"(%419, %394) : (i64, i64) -> i64
  %423 = "llvm.icmp"(%422, %388) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%423)[^bb10, ^bb8] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb8:  // pred: ^bb7
  %424 = "llvm.and"(%419, %395) : (i64, i64) -> i64
  %425 = "llvm.getelementptr"(%418, %424) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.call"(%arg42, %425, %422) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_memcpy, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.br"(%422)[^bb9] : (i64) -> ()
^bb9(%426: i64):  // 2 preds: ^bb3, ^bb8
  "llvm.store"(%426, %398) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag3]}> : (i64, !llvm.ptr) -> ()
  "llvm.br"()[^bb10] : () -> ()
^bb10:  // 3 preds: ^bb0, ^bb7, ^bb9
  "llvm.return"(%arg42) : (!llvm.ptr) -> ()
}) : () -> ()
  with @fd_memcpy := fd_memcpy, @fd_sha512_core_avx2 := fd_sha512_core_avx2

end

end MLIR.Firedancer.R52x5
