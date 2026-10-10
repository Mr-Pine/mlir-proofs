module

-- sodium-build/out/op/ge25519_double_scalarmult_vartime.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Sodium.Mlir.ge25519_add
public import Sodium.Mlir.ge25519_madd
public import Sodium.Mlir.ge25519_msub
public import Sodium.Mlir.ge25519_p1p1_to_p2
public import Sodium.Mlir.ge25519_p1p1_to_p3
public import Sodium.Mlir.ge25519_p2_0
public import Sodium.Mlir.ge25519_p2_dbl
public import Sodium.Mlir.ge25519_p3_dbl
public import Sodium.Mlir.ge25519_p3_to_cached
public import Sodium.Mlir.ge25519_sub
public import Sodium.Mlir.slide_vartime
public import Sodium.Mlir.ge25519_double_scalarmult_vartime_Bi

meta import MLIR.Semantics.Func
meta import Sodium.Mlir.ge25519_add
meta import Sodium.Mlir.ge25519_madd
meta import Sodium.Mlir.ge25519_msub
meta import Sodium.Mlir.ge25519_p1p1_to_p2
meta import Sodium.Mlir.ge25519_p1p1_to_p3
meta import Sodium.Mlir.ge25519_p2_0
meta import Sodium.Mlir.ge25519_p2_dbl
meta import Sodium.Mlir.ge25519_p3_dbl
meta import Sodium.Mlir.ge25519_p3_to_cached
meta import Sodium.Mlir.ge25519_sub
meta import Sodium.Mlir.slide_vartime
meta import Sodium.Mlir.ge25519_double_scalarmult_vartime_Bi

namespace MLIR.Sodium

@[expose] public section

mlir_def ge25519_double_scalarmult_vartime :=
#loop_annotation = #llvm.loop_annotation<mustProgress = true>
"llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "ssp", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], sym_name = "ge25519_double_scalarmult_vartime", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg60: !llvm.ptr, %arg61: !llvm.ptr, %arg62: !llvm.ptr, %arg63: !llvm.ptr):
  %2667 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %2668 = "llvm.mlir.constant"() <{value = 255 : i32}> : () -> i32
  %2669 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %2670 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
  %2671 = "llvm.mlir.constant"() <{value = 1 : i8}> : () -> i8
  %2672 = "llvm.mlir.addressof"() <{global_name = @ge25519_double_scalarmult_vartime.Bi}> : () -> !llvm.ptr
  %2673 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %2674 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %2675 = "llvm.mlir.constant"() <{value = -2 : i32}> : () -> i32
  %2676 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %2677 = "llvm.alloca"(%2667) <{alignment = 16 : i64, elem_type = !llvm.array<256 x i8>}> : (i32) -> !llvm.ptr
  %2678 = "llvm.alloca"(%2667) <{alignment = 16 : i64, elem_type = !llvm.array<256 x i8>}> : (i32) -> !llvm.ptr
  %2679 = "llvm.alloca"(%2667) <{alignment = 16 : i64, elem_type = !llvm.array<8 x struct<"struct.ge25519_p3", (array<5 x i64>, array<5 x i64>, array<5 x i64>, array<5 x i64>)>>}> : (i32) -> !llvm.ptr
  %2680 = "llvm.alloca"(%2667) <{alignment = 8 : i64, elem_type = !llvm.struct<"struct.ge25519_p3", (array<5 x i64>, array<5 x i64>, array<5 x i64>, array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %2681 = "llvm.alloca"(%2667) <{alignment = 8 : i64, elem_type = !llvm.struct<"struct.ge25519_p3", (array<5 x i64>, array<5 x i64>, array<5 x i64>, array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %2682 = "llvm.alloca"(%2667) <{alignment = 8 : i64, elem_type = !llvm.struct<"struct.ge25519_p3", (array<5 x i64>, array<5 x i64>, array<5 x i64>, array<5 x i64>)>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%2677) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2678) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2679) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2680) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2681) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2682) : (!llvm.ptr) -> ()
  "llvm.call"(%2677, %arg61) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @slide_vartime, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%2678, %arg63) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @slide_vartime, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%2679, %arg62) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @ge25519_p3_to_cached, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%2680, %arg62) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @ge25519_p3_dbl, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%2682, %2680) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @ge25519_p1p1_to_p3, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%2680, %2682, %2679) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @ge25519_add, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%2681, %2680) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @ge25519_p1p1_to_p3, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %2683 = "llvm.getelementptr"(%2679) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 160>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%2683, %2681) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @ge25519_p3_to_cached, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%2680, %2682, %2683) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @ge25519_add, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%2681, %2680) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @ge25519_p1p1_to_p3, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %2684 = "llvm.getelementptr"(%2679) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 320>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%2684, %2681) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @ge25519_p3_to_cached, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%2680, %2682, %2684) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @ge25519_add, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%2681, %2680) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @ge25519_p1p1_to_p3, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %2685 = "llvm.getelementptr"(%2679) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 480>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%2685, %2681) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @ge25519_p3_to_cached, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%2680, %2682, %2685) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @ge25519_add, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%2681, %2680) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @ge25519_p1p1_to_p3, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %2686 = "llvm.getelementptr"(%2679) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 640>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%2686, %2681) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @ge25519_p3_to_cached, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%2680, %2682, %2686) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @ge25519_add, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%2681, %2680) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @ge25519_p1p1_to_p3, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %2687 = "llvm.getelementptr"(%2679) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 800>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%2687, %2681) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @ge25519_p3_to_cached, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%2680, %2682, %2687) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @ge25519_add, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%2681, %2680) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @ge25519_p1p1_to_p3, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %2688 = "llvm.getelementptr"(%2679) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 960>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%2688, %2681) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @ge25519_p3_to_cached, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%2680, %2682, %2688) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @ge25519_add, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%2681, %2680) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @ge25519_p1p1_to_p3, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %2689 = "llvm.getelementptr"(%2679) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1120>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%2689, %2681) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @ge25519_p3_to_cached, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%arg60) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @ge25519_p2_0, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> ()
  "llvm.br"(%2668)[^bb1] : (i32) -> ()
^bb1(%2690: i32):  // 2 preds: ^bb0, ^bb5
  %2691 = "llvm.zext"(%2690) <{nonNeg}> : (i32) -> i64
  %2692 = "llvm.getelementptr"(%2677, %2691) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %2693 = "llvm.load"(%2692) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2694 = "llvm.icmp"(%2693, %2669) <{predicate = 0 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%2694, %2690)[^bb2, ^bb6] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb2:  // pred: ^bb1
  %2695 = "llvm.getelementptr"(%2678, %2691) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %2696 = "llvm.load"(%2695) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2697 = "llvm.icmp"(%2696, %2669) <{predicate = 0 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%2697, %2690)[^bb3, ^bb6] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb3:  // pred: ^bb2
  %2698 = "llvm.add"(%2690, %2670) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %2699 = "llvm.zext"(%2698) <{nonNeg}> : (i32) -> i64
  %2700 = "llvm.getelementptr"(%2677, %2699) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %2701 = "llvm.load"(%2700) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2702 = "llvm.icmp"(%2701, %2669) <{predicate = 0 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%2702, %2698)[^bb4, ^bb6] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb4:  // pred: ^bb3
  %2703 = "llvm.getelementptr"(%2678, %2699) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %2704 = "llvm.load"(%2703) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2705 = "llvm.icmp"(%2704, %2669) <{predicate = 0 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%2705, %2698)[^bb5, ^bb6] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb5:  // pred: ^bb4
  %2706 = "llvm.add"(%2690, %2675) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %2707 = "llvm.icmp"(%2698, %2676) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2707, %2706)[^bb17, ^bb1] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb6(%2708: i32):  // 4 preds: ^bb1, ^bb2, ^bb3, ^bb4
  %2709 = "llvm.icmp"(%2708, %2670) <{predicate = 4 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2709)[^bb7, ^bb17] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb7:  // pred: ^bb6
  %2710 = "llvm.zext"(%2708) <{nonNeg}> : (i32) -> i64
  "llvm.br"(%2710)[^bb8] : (i64) -> ()
^bb8(%2711: i64):  // 2 preds: ^bb7, ^bb16
  "llvm.call"(%2680, %arg60) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @ge25519_p2_dbl, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %2712 = "llvm.getelementptr"(%2677, %2711) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %2713 = "llvm.load"(%2712) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2714 = "llvm.icmp"(%2713, %2669) <{predicate = 4 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%2714)[^bb9, ^bb10] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb9:  // pred: ^bb8
  "llvm.call"(%2681, %2680) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @ge25519_p1p1_to_p3, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %2715 = "llvm.lshr"(%2713, %2671) : (i8, i8) -> i8
  %2716 = "llvm.zext"(%2715) <{nonNeg}> : (i8) -> i64
  %2717 = "llvm.getelementptr"(%2679, %2716) <{elem_type = !llvm.array<160 x i8>, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.call"(%2680, %2681, %2717) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @ge25519_add, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.br"()[^bb12] : () -> ()
^bb10:  // pred: ^bb8
  %2718 = "llvm.icmp"(%2713, %2669) <{predicate = 2 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%2718)[^bb11, ^bb12] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb11:  // pred: ^bb10
  "llvm.call"(%2681, %2680) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @ge25519_p1p1_to_p3, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %2719 = "llvm.sub"(%2669, %2713) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  %2720 = "llvm.lshr"(%2719, %2671) : (i8, i8) -> i8
  %2721 = "llvm.zext"(%2720) <{nonNeg}> : (i8) -> i64
  %2722 = "llvm.getelementptr"(%2679, %2721) <{elem_type = !llvm.array<160 x i8>, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.call"(%2680, %2681, %2722) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @ge25519_sub, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.br"()[^bb12] : () -> ()
^bb12:  // 3 preds: ^bb9, ^bb10, ^bb11
  %2723 = "llvm.getelementptr"(%2678, %2711) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %2724 = "llvm.load"(%2723) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2725 = "llvm.icmp"(%2724, %2669) <{predicate = 4 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%2725)[^bb13, ^bb14] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb13:  // pred: ^bb12
  "llvm.call"(%2681, %2680) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @ge25519_p1p1_to_p3, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %2726 = "llvm.lshr"(%2724, %2671) : (i8, i8) -> i8
  %2727 = "llvm.zext"(%2726) <{nonNeg}> : (i8) -> i64
  %2728 = "llvm.getelementptr"(%2672, %2727) <{elem_type = !llvm.array<120 x i8>, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.call"(%2680, %2681, %2728) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @ge25519_madd, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.br"()[^bb16] : () -> ()
^bb14:  // pred: ^bb12
  %2729 = "llvm.icmp"(%2724, %2669) <{predicate = 2 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%2729)[^bb15, ^bb16] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb15:  // pred: ^bb14
  "llvm.call"(%2681, %2680) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @ge25519_p1p1_to_p3, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %2730 = "llvm.sub"(%2669, %2724) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  %2731 = "llvm.lshr"(%2730, %2671) : (i8, i8) -> i8
  %2732 = "llvm.zext"(%2731) <{nonNeg}> : (i8) -> i64
  %2733 = "llvm.getelementptr"(%2672, %2732) <{elem_type = !llvm.array<120 x i8>, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.call"(%2680, %2681, %2733) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @ge25519_msub, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.br"()[^bb16] : () -> ()
^bb16:  // 3 preds: ^bb13, ^bb14, ^bb15
  "llvm.call"(%arg60, %2680) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @ge25519_p1p1_to_p2, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %2734 = "llvm.add"(%2711, %2673) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %2735 = "llvm.icmp"(%2711, %2674) <{predicate = 4 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%2735, %2734)[^bb8, ^bb17] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
^bb17:  // 3 preds: ^bb5, ^bb6, ^bb16
  "llvm.intr.lifetime.end"(%2682) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2681) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2680) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2679) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2678) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2677) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
  with @ge25519_add := ge25519_add, @ge25519_madd := ge25519_madd, @ge25519_msub := ge25519_msub,
    @ge25519_p1p1_to_p2 := ge25519_p1p1_to_p2, @ge25519_p1p1_to_p3 := ge25519_p1p1_to_p3,
    @ge25519_p2_0 := ge25519_p2_0, @ge25519_p2_dbl := ge25519_p2_dbl,
    @ge25519_p3_dbl := ge25519_p3_dbl, @ge25519_p3_to_cached := ge25519_p3_to_cached,
    @ge25519_sub := ge25519_sub, @slide_vartime := slide_vartime,
    @ge25519_double_scalarmult_vartime.Bi := ge25519_double_scalarmult_vartime_Bi

end

end MLIR.Sodium
