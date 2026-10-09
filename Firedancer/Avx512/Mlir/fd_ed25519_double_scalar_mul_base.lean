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
^bb0(%arg67: !llvm.ptr, %arg68: !llvm.ptr, %arg69: !llvm.ptr, %arg70: !llvm.ptr):
  %1510 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1511 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %1512 = "llvm.mlir.constant"() <{value = 8 : i32}> : () -> i32
  %1513 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %1514 = "llvm.mlir.constant"() <{value = 8 : i64}> : () -> i64
  %1515 = "llvm.mlir.constant"() <{value = 255 : i32}> : () -> i32
  %1516 = "llvm.mlir.constant"() <{value = 0 : i16}> : () -> i16
  %1517 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
  %1518 = "llvm.mlir.constant"() <{value = 1 : i16}> : () -> i16
  %1519 = "llvm.mlir.addressof"() <{global_name = @fd_ed25519_base_point_wnaf_table}> : () -> !llvm.ptr
  %1520 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %1521 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %1522 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %1523 = "llvm.alloca"(%1510) <{alignment = 16 : i64, elem_type = !llvm.array<256 x i16>}> : (i32) -> !llvm.ptr
  %1524 = "llvm.alloca"(%1510) <{alignment = 16 : i64, elem_type = !llvm.array<256 x i16>}> : (i32) -> !llvm.ptr
  %1525 = "llvm.alloca"(%1510) <{alignment = 64 : i64, elem_type = !llvm.array<8 x struct<"struct.fd_curve25519_edwards", (vector<8xi64>, vector<8xi64>, vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %1526 = "llvm.alloca"(%1510) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_curve25519_edwards", (vector<8xi64>, vector<8xi64>, vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %1527 = "llvm.alloca"(%1510) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_curve25519_edwards", (vector<8xi64>, vector<8xi64>, vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%1523) : (!llvm.ptr) -> ()
  "llvm.call"(%1523, %arg68, %1511) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_curve25519_scalar_wnaf, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> ()
  "llvm.intr.lifetime.start"(%1524) : (!llvm.ptr) -> ()
  "llvm.call"(%1524, %arg70, %1512) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_curve25519_scalar_wnaf, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> ()
  "llvm.intr.lifetime.start"(%1525) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1526) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1527) : (!llvm.ptr) -> ()
  %1528 = "llvm.call"(%1525, %arg69) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_set, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %1529 = "llvm.call"(%1526, %arg69, %1510) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_dbln, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> !llvm.ptr
  "llvm.call"(%1525) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_curve25519_into_precomputed, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> ()
  "llvm.br"(%1513)[^bb2] : (i64) -> ()
^bb1:  // pred: ^bb2
  %1530 = "llvm.call"(%arg67) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_ed25519_point_set_zero, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.br"(%1515)[^bb3] : (i32) -> ()
^bb2(%1531: i64):  // 2 preds: ^bb0, ^bb2
  %1532 = "llvm.getelementptr"(%1525, %1531) <{elem_type = !llvm.array<192 x i8>, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1533 = "llvm.getelementptr"(%1532) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -192>}> : (!llvm.ptr) -> !llvm.ptr
  %1534 = "llvm.call"(%1527, %1526, %1533, %1510) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_with_opts, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, i32) -> !llvm.ptr
  %1535 = "llvm.call"(%1532, %1527) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_final_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.call"(%1532) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_curve25519_into_precomputed, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> ()
  %1536 = "llvm.add"(%1531, %1513) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1537 = "llvm.icmp"(%1536, %1514) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1537, %1536)[^bb1, ^bb2] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb3(%1538: i32):  // 2 preds: ^bb1, ^bb5
  %1539 = "llvm.zext"(%1538) <{nonNeg}> : (i32) -> i64
  %1540 = "llvm.getelementptr"(%1523, %1539) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1541 = "llvm.load"(%1540) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (!llvm.ptr) -> i16
  %1542 = "llvm.icmp"(%1541, %1516) <{predicate = 0 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%1542)[^bb4, ^bb6] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb4:  // pred: ^bb3
  %1543 = "llvm.getelementptr"(%1524, %1539) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1544 = "llvm.load"(%1543) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (!llvm.ptr) -> i16
  %1545 = "llvm.icmp"(%1544, %1516) <{predicate = 0 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%1545)[^bb5, ^bb6] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb5:  // pred: ^bb4
  %1546 = "llvm.add"(%1538, %1517) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %1547 = "llvm.icmp"(%1538, %1522) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%1547, %1546)[^bb19, ^bb3] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb6:  // 2 preds: ^bb3, ^bb4
  %1548 = "llvm.icmp"(%1538, %1517) <{predicate = 4 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%1548)[^bb7, ^bb19] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb7:  // pred: ^bb6
  %1549 = "llvm.zext"(%1538) <{nonNeg}> : (i32) -> i64
  "llvm.br"(%1549)[^bb8] : (i64) -> ()
^bb8(%1550: i64):  // 2 preds: ^bb7, ^bb18
  %1551 = "llvm.call"(%1527, %arg67) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_partial_dbl, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %1552 = "llvm.getelementptr"(%1523, %1550) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1553 = "llvm.load"(%1552) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (!llvm.ptr) -> i16
  %1554 = "llvm.icmp"(%1553, %1516) <{predicate = 4 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%1554)[^bb9, ^bb10] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb9:  // pred: ^bb8
  %1555 = "llvm.call"(%arg67, %1527) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_final_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %1556 = "llvm.lshr"(%1553, %1518) : (i16, i16) -> i16
  %1557 = "llvm.zext"(%1556) <{nonNeg}> : (i16) -> i64
  %1558 = "llvm.getelementptr"(%1525, %1557) <{elem_type = !llvm.array<192 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1559 = "llvm.call"(%1527, %arg67, %1558, %1510) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_with_opts, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, i32) -> !llvm.ptr
  "llvm.br"()[^bb12] : () -> ()
^bb10:  // pred: ^bb8
  %1560 = "llvm.icmp"(%1553, %1516) <{predicate = 2 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%1560)[^bb11, ^bb12] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb11:  // pred: ^bb10
  %1561 = "llvm.call"(%arg67, %1527) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_final_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %1562 = "llvm.sub"(%1516, %1553) <{overflowFlags = 0 : i32}> : (i16, i16) -> i16
  %1563 = "llvm.lshr"(%1562, %1518) : (i16, i16) -> i16
  %1564 = "llvm.zext"(%1563) <{nonNeg}> : (i16) -> i64
  %1565 = "llvm.getelementptr"(%1525, %1564) <{elem_type = !llvm.array<192 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1566 = "llvm.call"(%1527, %arg67, %1565, %1510) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_sub_with_opts, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, i32) -> !llvm.ptr
  "llvm.br"()[^bb12] : () -> ()
^bb12:  // 3 preds: ^bb9, ^bb10, ^bb11
  %1567 = "llvm.getelementptr"(%1524, %1550) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1568 = "llvm.load"(%1567) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (!llvm.ptr) -> i16
  %1569 = "llvm.icmp"(%1568, %1516) <{predicate = 4 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%1569)[^bb13, ^bb14] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb13:  // pred: ^bb12
  %1570 = "llvm.call"(%arg67, %1527) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_final_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %1571 = "llvm.lshr"(%1568, %1518) : (i16, i16) -> i16
  %1572 = "llvm.zext"(%1571) <{nonNeg}> : (i16) -> i64
  %1573 = "llvm.getelementptr"(%1519, %1572) <{elem_type = !llvm.array<192 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1574 = "llvm.call"(%1527, %arg67, %1573, %1510) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_with_opts, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, i32) -> !llvm.ptr
  "llvm.br"()[^bb16] : () -> ()
^bb14:  // pred: ^bb12
  %1575 = "llvm.icmp"(%1568, %1516) <{predicate = 2 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%1575)[^bb15, ^bb16] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb15:  // pred: ^bb14
  %1576 = "llvm.call"(%arg67, %1527) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_final_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %1577 = "llvm.sub"(%1516, %1568) <{overflowFlags = 0 : i32}> : (i16, i16) -> i16
  %1578 = "llvm.lshr"(%1577, %1518) : (i16, i16) -> i16
  %1579 = "llvm.zext"(%1578) <{nonNeg}> : (i16) -> i64
  %1580 = "llvm.getelementptr"(%1519, %1579) <{elem_type = !llvm.array<192 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1581 = "llvm.call"(%1527, %arg67, %1580, %1510) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_sub_with_opts, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, i32) -> !llvm.ptr
  "llvm.br"()[^bb16] : () -> ()
^bb16:  // 3 preds: ^bb13, ^bb14, ^bb15
  %1582 = "llvm.icmp"(%1550, %1520) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1582)[^bb17, ^bb18] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb17:  // pred: ^bb16
  %1583 = "llvm.call"(%arg67, %1527) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_final_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.br"()[^bb19] : () -> ()
^bb18:  // pred: ^bb16
  %1584 = "llvm.call"(%arg67, %1527) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_final_mul_projective, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %1585 = "llvm.add"(%1550, %1521) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1586 = "llvm.icmp"(%1550, %1520) <{predicate = 4 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1586, %1585)[^bb8, ^bb19] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
^bb19:  // 4 preds: ^bb5, ^bb6, ^bb17, ^bb18
  "llvm.intr.lifetime.end"(%1527) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1526) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1525) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1524) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1523) : (!llvm.ptr) -> ()
  "llvm.return"(%arg67) : (!llvm.ptr) -> ()
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
