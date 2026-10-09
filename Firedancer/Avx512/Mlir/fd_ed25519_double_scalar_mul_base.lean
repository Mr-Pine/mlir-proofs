module

-- build/llvm23/mlir_canonicalized/avx512/op/fd_ed25519_double_scalar_mul_base.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Avx512.Mlir.fd_curve25519_into_precomputed
public import Firedancer.Ref.Mlir.fd_curve25519_scalar_wnaf
public import Firedancer.Avx512.Mlir.fd_ed25519_partial_dbl
public import Firedancer.Avx512.Mlir.fd_ed25519_point_add_final_mul
public import Firedancer.Avx512.Mlir.fd_ed25519_point_add_final_mul_projective
public import Firedancer.Avx512.Mlir.fd_ed25519_point_add_with_opts
public import Firedancer.Avx512.Mlir.fd_ed25519_point_dbln
public import Firedancer.Avx512.Mlir.fd_ed25519_point_set
public import Firedancer.Avx512.Mlir.fd_ed25519_point_set_zero
public import Firedancer.Avx512.Mlir.fd_ed25519_point_sub_with_opts
public import Firedancer.Avx512.Mlir.fd_ed25519_base_point_wnaf_table

meta import MLIR.Semantics.Func
meta import Firedancer.Avx512.Mlir.fd_curve25519_into_precomputed
meta import Firedancer.Ref.Mlir.fd_curve25519_scalar_wnaf
meta import Firedancer.Avx512.Mlir.fd_ed25519_partial_dbl
meta import Firedancer.Avx512.Mlir.fd_ed25519_point_add_final_mul
meta import Firedancer.Avx512.Mlir.fd_ed25519_point_add_final_mul_projective
meta import Firedancer.Avx512.Mlir.fd_ed25519_point_add_with_opts
meta import Firedancer.Avx512.Mlir.fd_ed25519_point_dbln
meta import Firedancer.Avx512.Mlir.fd_ed25519_point_set
meta import Firedancer.Avx512.Mlir.fd_ed25519_point_set_zero
meta import Firedancer.Avx512.Mlir.fd_ed25519_point_sub_with_opts
meta import Firedancer.Avx512.Mlir.fd_ed25519_base_point_wnaf_table

namespace MLIR.Firedancer.Avx512

@[expose] public section

noncomputable mlir_def fd_ed25519_double_scalar_mul_base :=
#loop_unroll = #llvm.loop_unroll<disable = true>
#tbaa_root = #llvm.tbaa_root<id = "Simple C/C++ TBAA">
#loop_annotation = #llvm.loop_annotation<unroll = #loop_unroll, mustProgress = true>
#tbaa_type_desc = #llvm.tbaa_type_desc<id = "omnipotent char", members = {<#tbaa_root, 0>}>
#tbaa_type_desc2 = #llvm.tbaa_type_desc<id = "short", members = {<#tbaa_type_desc, 0>}>
#tbaa_tag2 = #llvm.tbaa_tag<base_type = #tbaa_type_desc2, access_type = #tbaa_type_desc2, offset = 0>
"llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nofree, llvm.noundef, llvm.returned}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<ptr (ptr, ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], res_attrs = [{llvm.noundef}], sym_name = "fd_ed25519_double_scalar_mul_base", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg69: !llvm.ptr, %arg70: !llvm.ptr, %arg71: !llvm.ptr, %arg72: !llvm.ptr):
  %1512 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1513 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %1514 = "llvm.mlir.constant"() <{value = 8 : i32}> : () -> i32
  %1515 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %1516 = "llvm.mlir.constant"() <{value = 8 : i64}> : () -> i64
  %1517 = "llvm.mlir.constant"() <{value = 255 : i32}> : () -> i32
  %1518 = "llvm.mlir.constant"() <{value = 0 : i16}> : () -> i16
  %1519 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
  %1520 = "llvm.mlir.constant"() <{value = 1 : i16}> : () -> i16
  %1521 = "llvm.mlir.addressof"() <{global_name = @fd_ed25519_base_point_wnaf_table}> : () -> !llvm.ptr
  %1522 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %1523 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %1524 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %1525 = "llvm.alloca"(%1512) <{alignment = 16 : i64, elem_type = !llvm.array<256 x i16>}> : (i32) -> !llvm.ptr
  %1526 = "llvm.alloca"(%1512) <{alignment = 16 : i64, elem_type = !llvm.array<256 x i16>}> : (i32) -> !llvm.ptr
  %1527 = "llvm.alloca"(%1512) <{alignment = 64 : i64, elem_type = !llvm.array<8 x struct<"struct.fd_curve25519_edwards", (vector<8xi64>, vector<8xi64>, vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %1528 = "llvm.alloca"(%1512) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_curve25519_edwards", (vector<8xi64>, vector<8xi64>, vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %1529 = "llvm.alloca"(%1512) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_curve25519_edwards", (vector<8xi64>, vector<8xi64>, vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%1525) : (!llvm.ptr) -> ()
  "llvm.call"(%1525, %arg70, %1513) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_curve25519_scalar_wnaf, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> ()
  "llvm.intr.lifetime.start"(%1526) : (!llvm.ptr) -> ()
  "llvm.call"(%1526, %arg72, %1514) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_curve25519_scalar_wnaf, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> ()
  "llvm.intr.lifetime.start"(%1527) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1528) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1529) : (!llvm.ptr) -> ()
  %1530 = "llvm.call"(%1527, %arg71) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_set, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %1531 = "llvm.call"(%1528, %arg71, %1512) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_dbln, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> !llvm.ptr
  "llvm.call"(%1527) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @fd_curve25519_into_precomputed, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> ()
  "llvm.br"(%1515)[^bb2] : (i64) -> ()
^bb1:  // pred: ^bb2
  %1532 = "llvm.call"(%arg69) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_ed25519_point_set_zero, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.br"(%1517)[^bb3] : (i32) -> ()
^bb2(%1533: i64):  // 2 preds: ^bb0, ^bb2
  %1534 = "llvm.getelementptr"(%1527, %1533) <{elem_type = !llvm.array<192 x i8>, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1535 = "llvm.getelementptr"(%1534) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -192>}> : (!llvm.ptr) -> !llvm.ptr
  %1536 = "llvm.call"(%1529, %1528, %1535, %1512) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_with_opts, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, i32) -> !llvm.ptr
  %1537 = "llvm.call"(%1534, %1529) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_final_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.call"(%1534) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @fd_curve25519_into_precomputed, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> ()
  %1538 = "llvm.add"(%1533, %1515) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1539 = "llvm.icmp"(%1538, %1516) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1539, %1538)[^bb1, ^bb2] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb3(%1540: i32):  // 2 preds: ^bb1, ^bb5
  %1541 = "llvm.zext"(%1540) <{nonNeg}> : (i32) -> i64
  %1542 = "llvm.getelementptr"(%1525, %1541) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1543 = "llvm.load"(%1542) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (!llvm.ptr) -> i16
  %1544 = "llvm.icmp"(%1543, %1518) <{predicate = 0 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%1544)[^bb4, ^bb6] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb4:  // pred: ^bb3
  %1545 = "llvm.getelementptr"(%1526, %1541) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1546 = "llvm.load"(%1545) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (!llvm.ptr) -> i16
  %1547 = "llvm.icmp"(%1546, %1518) <{predicate = 0 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%1547)[^bb5, ^bb6] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb5:  // pred: ^bb4
  %1548 = "llvm.add"(%1540, %1519) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %1549 = "llvm.icmp"(%1540, %1524) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%1549, %1548)[^bb19, ^bb3] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb6:  // 2 preds: ^bb3, ^bb4
  %1550 = "llvm.icmp"(%1540, %1519) <{predicate = 4 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%1550)[^bb7, ^bb19] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb7:  // pred: ^bb6
  %1551 = "llvm.zext"(%1540) <{nonNeg}> : (i32) -> i64
  "llvm.br"(%1551)[^bb8] : (i64) -> ()
^bb8(%1552: i64):  // 2 preds: ^bb7, ^bb18
  %1553 = "llvm.call"(%1529, %arg69) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_partial_dbl, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %1554 = "llvm.getelementptr"(%1525, %1552) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1555 = "llvm.load"(%1554) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (!llvm.ptr) -> i16
  %1556 = "llvm.icmp"(%1555, %1518) <{predicate = 4 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%1556)[^bb9, ^bb10] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb9:  // pred: ^bb8
  %1557 = "llvm.call"(%arg69, %1529) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_final_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %1558 = "llvm.lshr"(%1555, %1520) : (i16, i16) -> i16
  %1559 = "llvm.zext"(%1558) <{nonNeg}> : (i16) -> i64
  %1560 = "llvm.getelementptr"(%1527, %1559) <{elem_type = !llvm.array<192 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1561 = "llvm.call"(%1529, %arg69, %1560, %1512) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_with_opts, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, i32) -> !llvm.ptr
  "llvm.br"()[^bb12] : () -> ()
^bb10:  // pred: ^bb8
  %1562 = "llvm.icmp"(%1555, %1518) <{predicate = 2 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%1562)[^bb11, ^bb12] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb11:  // pred: ^bb10
  %1563 = "llvm.call"(%arg69, %1529) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_final_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %1564 = "llvm.sub"(%1518, %1555) <{overflowFlags = 0 : i32}> : (i16, i16) -> i16
  %1565 = "llvm.lshr"(%1564, %1520) : (i16, i16) -> i16
  %1566 = "llvm.zext"(%1565) <{nonNeg}> : (i16) -> i64
  %1567 = "llvm.getelementptr"(%1527, %1566) <{elem_type = !llvm.array<192 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1568 = "llvm.call"(%1529, %arg69, %1567, %1512) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_sub_with_opts, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, i32) -> !llvm.ptr
  "llvm.br"()[^bb12] : () -> ()
^bb12:  // 3 preds: ^bb9, ^bb10, ^bb11
  %1569 = "llvm.getelementptr"(%1526, %1552) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1570 = "llvm.load"(%1569) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (!llvm.ptr) -> i16
  %1571 = "llvm.icmp"(%1570, %1518) <{predicate = 4 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%1571)[^bb13, ^bb14] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb13:  // pred: ^bb12
  %1572 = "llvm.call"(%arg69, %1529) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_final_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %1573 = "llvm.lshr"(%1570, %1520) : (i16, i16) -> i16
  %1574 = "llvm.zext"(%1573) <{nonNeg}> : (i16) -> i64
  %1575 = "llvm.getelementptr"(%1521, %1574) <{elem_type = !llvm.array<192 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1576 = "llvm.call"(%1529, %arg69, %1575, %1512) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_with_opts, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, i32) -> !llvm.ptr
  "llvm.br"()[^bb16] : () -> ()
^bb14:  // pred: ^bb12
  %1577 = "llvm.icmp"(%1570, %1518) <{predicate = 2 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%1577)[^bb15, ^bb16] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb15:  // pred: ^bb14
  %1578 = "llvm.call"(%arg69, %1529) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_final_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %1579 = "llvm.sub"(%1518, %1570) <{overflowFlags = 0 : i32}> : (i16, i16) -> i16
  %1580 = "llvm.lshr"(%1579, %1520) : (i16, i16) -> i16
  %1581 = "llvm.zext"(%1580) <{nonNeg}> : (i16) -> i64
  %1582 = "llvm.getelementptr"(%1521, %1581) <{elem_type = !llvm.array<192 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1583 = "llvm.call"(%1529, %arg69, %1582, %1512) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_sub_with_opts, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, i32) -> !llvm.ptr
  "llvm.br"()[^bb16] : () -> ()
^bb16:  // 3 preds: ^bb13, ^bb14, ^bb15
  %1584 = "llvm.icmp"(%1552, %1522) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1584)[^bb17, ^bb18] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb17:  // pred: ^bb16
  %1585 = "llvm.call"(%arg69, %1529) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_final_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.br"()[^bb19] : () -> ()
^bb18:  // pred: ^bb16
  %1586 = "llvm.call"(%arg69, %1529) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_final_mul_projective, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %1587 = "llvm.add"(%1552, %1523) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1588 = "llvm.icmp"(%1552, %1522) <{predicate = 4 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1588, %1587)[^bb8, ^bb19] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
^bb19:  // 4 preds: ^bb5, ^bb6, ^bb17, ^bb18
  "llvm.intr.lifetime.end"(%1529) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1528) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1527) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1526) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1525) : (!llvm.ptr) -> ()
  "llvm.return"(%arg69) : (!llvm.ptr) -> ()
}) : () -> ()
  with @fd_curve25519_into_precomputed := fd_curve25519_into_precomputed,
    @fd_curve25519_scalar_wnaf := Ref.fd_curve25519_scalar_wnaf,
    @fd_ed25519_partial_dbl := fd_ed25519_partial_dbl,
    @fd_ed25519_point_add_final_mul := fd_ed25519_point_add_final_mul,
    @fd_ed25519_point_add_final_mul_projective := fd_ed25519_point_add_final_mul_projective,
    @fd_ed25519_point_add_with_opts := fd_ed25519_point_add_with_opts,
    @fd_ed25519_point_dbln := fd_ed25519_point_dbln, @fd_ed25519_point_set := fd_ed25519_point_set,
    @fd_ed25519_point_set_zero := fd_ed25519_point_set_zero,
    @fd_ed25519_point_sub_with_opts := fd_ed25519_point_sub_with_opts,
    @fd_ed25519_base_point_wnaf_table := fd_ed25519_base_point_wnaf_table

end

end MLIR.Firedancer.Avx512
