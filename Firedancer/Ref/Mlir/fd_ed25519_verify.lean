module

-- build/llvm23/mlir_canonicalized/ref/op/fd_ed25519_verify.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Ref.Mlir.fd_curve25519_scalar_reduce
public import Firedancer.Ref.Mlir.fd_curve25519_scalar_validate
public import Firedancer.Ref.Mlir.fd_ed25519_affine_is_small_order
public import Firedancer.Ref.Mlir.fd_ed25519_double_scalar_mul_base
public import Firedancer.Ref.Mlir.fd_ed25519_point_eq_z1
public import Firedancer.Ref.Mlir.fd_ed25519_point_frombytes_2x
public import Firedancer.Ref.Mlir.fd_ed25519_point_neg
public import Firedancer.Ref.Mlir.fd_sha512_append
public import Firedancer.Ref.Mlir.fd_sha512_fini
public import Firedancer.Ref.Mlir.fd_sha512_init

meta import MLIR.Semantics.Func
meta import Firedancer.Ref.Mlir.fd_curve25519_scalar_reduce
meta import Firedancer.Ref.Mlir.fd_curve25519_scalar_validate
meta import Firedancer.Ref.Mlir.fd_ed25519_affine_is_small_order
meta import Firedancer.Ref.Mlir.fd_ed25519_double_scalar_mul_base
meta import Firedancer.Ref.Mlir.fd_ed25519_point_eq_z1
meta import Firedancer.Ref.Mlir.fd_ed25519_point_frombytes_2x
meta import Firedancer.Ref.Mlir.fd_ed25519_point_neg
meta import Firedancer.Ref.Mlir.fd_sha512_append
meta import Firedancer.Ref.Mlir.fd_sha512_fini
meta import Firedancer.Ref.Mlir.fd_sha512_init

namespace MLIR.Firedancer.Ref

@[expose] public section

noncomputable mlir_def fd_ed25519_verify :=
"llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.noundef}, {llvm.align = 1 : i64, llvm.dereferenceable = 64 : i64, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.align = 1 : i64, llvm.dereferenceable = 32 : i64, llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.nofree, llvm.noundef}], dso_local, function_type = !llvm.func<i32 (ptr, i64, ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = readwrite, argMem = readwrite, inaccessibleMem = none, errnoMem = readwrite, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], res_attrs = [{llvm.range = #llvm.constant_range<i32, -3, 1>}], sym_name = "fd_ed25519_verify", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg49: !llvm.ptr, %arg50: i64, %arg51: !llvm.ptr, %arg52: !llvm.ptr, %arg53: !llvm.ptr):
  %774 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %775 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %776 = "llvm.mlir.zero"() : () -> !llvm.ptr
  %777 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
  %778 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %779 = "llvm.mlir.constant"() <{value = -2 : i32}> : () -> i32
  %780 = "llvm.mlir.constant"() <{value = -3 : i32}> : () -> i32
  %781 = "llvm.alloca"(%774) <{alignment = 16 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_curve25519_edwards", (array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>, array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>, array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>, array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>)>>}> : (i32) -> !llvm.ptr
  %782 = "llvm.alloca"(%774) <{alignment = 16 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_curve25519_edwards", (array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>, array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>, array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>, array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>)>>}> : (i32) -> !llvm.ptr
  %783 = "llvm.alloca"(%774) <{alignment = 16 : i64, elem_type = !llvm.array<64 x i8>}> : (i32) -> !llvm.ptr
  %784 = "llvm.alloca"(%774) <{alignment = 16 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_curve25519_edwards", (array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>, array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>, array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>, array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>)>>}> : (i32) -> !llvm.ptr
  %785 = "llvm.getelementptr"(%arg51) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %786 = "llvm.call"(%785) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_curve25519_scalar_validate, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> !llvm.ptr
  %787 = "llvm.icmp"(%786, %776) <{predicate = 0 : i64}> : (!llvm.ptr, !llvm.ptr) -> i1
  "llvm.cond_br"(%787, %777)[^bb7, ^bb1] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i32) -> ()
^bb1:  // pred: ^bb0
  "llvm.intr.lifetime.start"(%781) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%782) : (!llvm.ptr) -> ()
  %788 = "llvm.call"(%781, %arg52, %782, %arg51) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_ed25519_point_frombytes_2x, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> i32
  %789 = "llvm.icmp"(%788, %778) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%789)[^bb3, ^bb2] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb2:  // pred: ^bb1
  %790 = "llvm.icmp"(%788, %777) <{predicate = 0 : i64}> : (i32, i32) -> i1
  %791 = "llvm.select"(%790, %779, %777) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i32, i32) -> i32
  "llvm.br"(%791)[^bb6] : (i32) -> ()
^bb3:  // pred: ^bb1
  %792 = "llvm.call"(%781) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_ed25519_affine_is_small_order, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i32
  %793 = "llvm.icmp"(%792, %778) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%793, %779)[^bb4, ^bb6] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb4:  // pred: ^bb3
  %794 = "llvm.call"(%782) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_ed25519_affine_is_small_order, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i32
  %795 = "llvm.icmp"(%794, %778) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%795, %777)[^bb5, ^bb6] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb5:  // pred: ^bb4
  "llvm.intr.lifetime.start"(%783) : (!llvm.ptr) -> ()
  %796 = "llvm.call"(%arg53) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_sha512_init, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> !llvm.ptr
  %797 = "llvm.call"(%arg53, %arg51, %775) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_append, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %798 = "llvm.call"(%arg53, %arg52, %775) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_append, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %799 = "llvm.call"(%arg53, %arg49, %arg50) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_append, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %800 = "llvm.call"(%arg53, %783) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_sha512_fini, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %801 = "llvm.call"(%783, %783) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_curve25519_scalar_reduce, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%784) : (!llvm.ptr) -> ()
  %802 = "llvm.call"(%781, %781) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_neg, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %803 = "llvm.call"(%784, %783, %781, %785) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_ed25519_double_scalar_mul_base, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = readwrite, argMem = readwrite, inaccessibleMem = none, errnoMem = readwrite, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %804 = "llvm.call"(%784, %782) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_eq_z1, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> i32
  %805 = "llvm.icmp"(%804, %778) <{predicate = 0 : i64}> : (i32, i32) -> i1
  %806 = "llvm.select"(%805, %780, %778) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i32, i32) -> i32
  "llvm.intr.lifetime.end"(%784) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%783) : (!llvm.ptr) -> ()
  "llvm.br"(%806)[^bb6] : (i32) -> ()
^bb6(%807: i32):  // 4 preds: ^bb2, ^bb3, ^bb4, ^bb5
  "llvm.intr.lifetime.end"(%782) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%781) : (!llvm.ptr) -> ()
  "llvm.br"(%807)[^bb7] : (i32) -> ()
^bb7(%808: i32):  // 2 preds: ^bb0, ^bb6
  "llvm.return"(%808) : (i32) -> ()
}) : () -> ()
  with @fd_curve25519_scalar_reduce := fd_curve25519_scalar_reduce,
    @fd_curve25519_scalar_validate := fd_curve25519_scalar_validate,
    @fd_ed25519_affine_is_small_order := fd_ed25519_affine_is_small_order,
    @fd_ed25519_double_scalar_mul_base := fd_ed25519_double_scalar_mul_base,
    @fd_ed25519_point_eq_z1 := fd_ed25519_point_eq_z1,
    @fd_ed25519_point_frombytes_2x := fd_ed25519_point_frombytes_2x,
    @fd_ed25519_point_neg := fd_ed25519_point_neg, @fd_sha512_append := fd_sha512_append,
    @fd_sha512_fini := fd_sha512_fini, @fd_sha512_init := fd_sha512_init

end

end MLIR.Firedancer.Ref
