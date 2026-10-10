module

-- boringssl-build/out/op/_ZN4bssl27x25519_ge_frombytes_vartimeEPNS_5ge_p3EPKh.mlir
-- bssl::x25519_ge_frombytes_vartime(bssl::ge_p3*, unsigned char const*)

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Boringssl.Mlir.fe_mul_ttl
public import Boringssl.Mlir.fe_mul_ttt
public import Boringssl.Mlir.fe_pow22523
public import Boringssl.Mlir.fe_frombytes
public import Boringssl.Mlir.fe_isnonzero_fe_loose
public import Boringssl.Mlir.fe_isnegative
public import Boringssl.Mlir.fe_1
public import Boringssl.Mlir.fe_add
public import Boringssl.Mlir.fe_neg
public import Boringssl.Mlir.fe_sub
public import Boringssl.Mlir.fe_carry
public import Boringssl.Mlir.fe_sq_tt
public import Boringssl.Mlir.d
public import Boringssl.Mlir.sqrtm1

meta import MLIR.Semantics.Func
meta import Boringssl.Mlir.fe_mul_ttl
meta import Boringssl.Mlir.fe_mul_ttt
meta import Boringssl.Mlir.fe_pow22523
meta import Boringssl.Mlir.fe_frombytes
meta import Boringssl.Mlir.fe_isnonzero_fe_loose
meta import Boringssl.Mlir.fe_isnegative
meta import Boringssl.Mlir.fe_1
meta import Boringssl.Mlir.fe_add
meta import Boringssl.Mlir.fe_neg
meta import Boringssl.Mlir.fe_sub
meta import Boringssl.Mlir.fe_carry
meta import Boringssl.Mlir.fe_sq_tt
meta import Boringssl.Mlir.d
meta import Boringssl.Mlir.sqrtm1

namespace MLIR.Boringssl

@[expose] public section

mlir_def x25519_ge_frombytes_vartime :=
"llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], dso_local, function_type = !llvm.func<i32 (ptr, ptr)>, linkage = #llvm.linkage<internal>, no_inline, no_unwind, passthrough = ["mustprogress", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"], ["warn-stack-size", "25344"]], res_attrs = [{llvm.noundef, llvm.range = #llvm.constant_range<i32, 0, 2>}], sym_name = "_ZN4bssl27x25519_ge_frombytes_vartimeEPNS_5ge_p3EPKh", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg121: !llvm.ptr, %arg122: !llvm.ptr):
  %1488 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1489 = "llvm.mlir.addressof"() <{global_name = @_ZL1d}> : () -> !llvm.ptr
  %1490 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %1491 = "llvm.mlir.addressof"() <{global_name = @_ZL6sqrtm1}> : () -> !llvm.ptr
  %1492 = "llvm.mlir.constant"() <{value = 7 : i8}> : () -> i8
  %1493 = "llvm.alloca"(%1488) <{alignment = 8 : i64, elem_type = !llvm.struct<"struct.bssl::fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %1494 = "llvm.alloca"(%1488) <{alignment = 8 : i64, elem_type = !llvm.struct<"struct.bssl::fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %1495 = "llvm.alloca"(%1488) <{alignment = 8 : i64, elem_type = !llvm.struct<"struct.bssl::fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %1496 = "llvm.alloca"(%1488) <{alignment = 8 : i64, elem_type = !llvm.struct<"struct.bssl::fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %1497 = "llvm.alloca"(%1488) <{alignment = 8 : i64, elem_type = !llvm.struct<"struct.bssl::fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %1498 = "llvm.alloca"(%1488) <{alignment = 8 : i64, elem_type = !llvm.struct<"struct.bssl::fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%1493) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1494) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1495) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1496) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1497) : (!llvm.ptr) -> ()
  %1499 = "llvm.getelementptr"(%arg121) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%1499, %arg122) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @_ZL12fe_frombytesPN4bssl2feEPKh, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %1500 = "llvm.getelementptr"(%arg121) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 80>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%1500) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @_ZL4fe_1PN4bssl2feE, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> ()
  "llvm.call"(%1495, %1499) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZL8fe_sq_ttPN4bssl2feEPKS0_, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%1496, %1495, %1489) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZL10fe_mul_tttPN4bssl2feEPKS0_S3_, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%1494, %1495, %1500) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZL6fe_subPN4bssl8fe_looseEPKNS_2feES4_, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%1493, %1494) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZL8fe_carryPN4bssl2feEPKNS_8fe_looseE, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%1494, %1496, %1500) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZL6fe_addPN4bssl8fe_looseEPKNS_2feES4_, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%1495, %1493, %1494) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZL10fe_mul_ttlPN4bssl2feEPKS0_PKNS_8fe_looseE, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%arg121, %1495) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @_ZL11fe_pow22523PN4bssl2feEPKS0_, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%arg121, %arg121, %1493) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZL10fe_mul_tttPN4bssl2feEPKS0_S3_, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%1496, %arg121) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @_ZL8fe_sq_ttPN4bssl2feEPKS0_, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%1496, %1496, %1494) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZL10fe_mul_ttlPN4bssl2feEPKS0_PKNS_8fe_looseE, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%1497, %1496, %1493) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZL6fe_subPN4bssl8fe_looseEPKNS_2feES4_, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  %1501 = "llvm.call"(%1497) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @_ZL12fe_isnonzeroPKN4bssl8fe_looseE, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (!llvm.ptr) -> i32
  %1502 = "llvm.icmp"(%1501, %1490) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%1502)[^bb3, ^bb1] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb1:  // pred: ^bb0
  "llvm.call"(%1497, %1496, %1493) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZL6fe_addPN4bssl8fe_looseEPKNS_2feES4_, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  %1503 = "llvm.call"(%1497) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @_ZL12fe_isnonzeroPKN4bssl8fe_looseE, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (!llvm.ptr) -> i32
  %1504 = "llvm.icmp"(%1503, %1490) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%1504, %1490)[^bb2, ^bb6] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb2:  // pred: ^bb1
  "llvm.call"(%arg121, %arg121, %1491) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZL10fe_mul_tttPN4bssl2feEPKS0_S3_, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.br"()[^bb3] : () -> ()
^bb3:  // 2 preds: ^bb0, ^bb2
  %1505 = "llvm.call"(%arg121) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @_ZL13fe_isnegativePKN4bssl2feE, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (!llvm.ptr) -> i32
  %1506 = "llvm.getelementptr"(%arg122) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 31>}> : (!llvm.ptr) -> !llvm.ptr
  %1507 = "llvm.load"(%1506) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1508 = "llvm.lshr"(%1507, %1492) : (i8, i8) -> i8
  %1509 = "llvm.zext"(%1508) <{nonNeg}> : (i8) -> i32
  %1510 = "llvm.icmp"(%1505, %1509) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%1510)[^bb5, ^bb4] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb4:  // pred: ^bb3
  "llvm.intr.lifetime.start"(%1498) : (!llvm.ptr) -> ()
  "llvm.call"(%1498, %arg121) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZL6fe_negPN4bssl8fe_looseEPKNS_2feE, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%arg121, %1498) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZL8fe_carryPN4bssl2feEPKNS_8fe_looseE, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1498) : (!llvm.ptr) -> ()
  "llvm.br"()[^bb5] : () -> ()
^bb5:  // 2 preds: ^bb3, ^bb4
  %1511 = "llvm.getelementptr"(%arg121) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 120>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%1511, %arg121, %1499) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZL10fe_mul_tttPN4bssl2feEPKS0_S3_, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.br"(%1488)[^bb6] : (i32) -> ()
^bb6(%1512: i32):  // 2 preds: ^bb1, ^bb5
  "llvm.intr.lifetime.end"(%1497) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1496) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1495) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1494) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1493) : (!llvm.ptr) -> ()
  "llvm.return"(%1512) : (i32) -> ()
}) : () -> ()
  with @_ZL10fe_mul_ttlPN4bssl2feEPKS0_PKNS_8fe_looseE := fe_mul_ttl,
    @_ZL10fe_mul_tttPN4bssl2feEPKS0_S3_ := fe_mul_ttt,
    @_ZL11fe_pow22523PN4bssl2feEPKS0_ := fe_pow22523,
    @_ZL12fe_frombytesPN4bssl2feEPKh := fe_frombytes,
    @_ZL12fe_isnonzeroPKN4bssl8fe_looseE := fe_isnonzero_fe_loose,
    @_ZL13fe_isnegativePKN4bssl2feE := fe_isnegative, @_ZL4fe_1PN4bssl2feE := fe_1,
    @_ZL6fe_addPN4bssl8fe_looseEPKNS_2feES4_ := fe_add,
    @_ZL6fe_negPN4bssl8fe_looseEPKNS_2feE := fe_neg,
    @_ZL6fe_subPN4bssl8fe_looseEPKNS_2feES4_ := fe_sub,
    @_ZL8fe_carryPN4bssl2feEPKNS_8fe_looseE := fe_carry, @_ZL8fe_sq_ttPN4bssl2feEPKS0_ := fe_sq_tt,
    @_ZL1d := d, @_ZL6sqrtm1 := sqrtm1

end

end MLIR.Boringssl
