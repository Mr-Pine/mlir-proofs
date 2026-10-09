module

-- build/llvm23/mlir_canonicalized/ref/op/fd_ed25519_verify.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Ref.Mlir.fd_curve25519_scalar_reduce
public import Firedancer.Ref.Mlir.fd_curve25519_scalar_validate
public import Firedancer.Ref.Mlir.fd_ed25519_affine_is_small_order
public import Firedancer.Ref.Mlir.fd_ed25519_point_frombytes_2x
public import Firedancer.Ref.Mlir.fd_ed25519_verify_equation
public import Firedancer.Ref.Mlir.fd_sha512_append
public import Firedancer.Ref.Mlir.fd_sha512_fini
public import Firedancer.Ref.Mlir.fd_sha512_init

meta import MLIR.Semantics.Func
meta import Firedancer.Ref.Mlir.fd_curve25519_scalar_reduce
meta import Firedancer.Ref.Mlir.fd_curve25519_scalar_validate
meta import Firedancer.Ref.Mlir.fd_ed25519_affine_is_small_order
meta import Firedancer.Ref.Mlir.fd_ed25519_point_frombytes_2x
meta import Firedancer.Ref.Mlir.fd_ed25519_verify_equation
meta import Firedancer.Ref.Mlir.fd_sha512_append
meta import Firedancer.Ref.Mlir.fd_sha512_fini
meta import Firedancer.Ref.Mlir.fd_sha512_init

namespace MLIR.Firedancer.Ref

@[expose] public section

noncomputable mlir_def fd_ed25519_verify :=
"llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.noundef}, {llvm.align = 1 : i64, llvm.dereferenceable = 64 : i64, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.align = 1 : i64, llvm.dereferenceable = 32 : i64, llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.nofree, llvm.noundef}], dso_local, function_type = !llvm.func<i32 (ptr, i64, ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = readwrite, argMem = readwrite, inaccessibleMem = none, errnoMem = readwrite, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], res_attrs = [{llvm.range = #llvm.constant_range<i32, -3, 1>}], sym_name = "fd_ed25519_verify", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg53: !llvm.ptr, %arg54: i64, %arg55: !llvm.ptr, %arg56: !llvm.ptr, %arg57: !llvm.ptr):
  %779 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %780 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %781 = "llvm.mlir.zero"() : () -> !llvm.ptr
  %782 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
  %783 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %784 = "llvm.mlir.constant"() <{value = -2 : i32}> : () -> i32
  %785 = "llvm.mlir.constant"() <{value = -3 : i32}> : () -> i32
  %786 = "llvm.alloca"(%779) <{alignment = 16 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_curve25519_edwards", (array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>, array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>, array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>, array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>)>>}> : (i32) -> !llvm.ptr
  %787 = "llvm.alloca"(%779) <{alignment = 16 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_curve25519_edwards", (array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>, array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>, array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>, array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>)>>}> : (i32) -> !llvm.ptr
  %788 = "llvm.alloca"(%779) <{alignment = 16 : i64, elem_type = !llvm.array<64 x i8>}> : (i32) -> !llvm.ptr
  %789 = "llvm.getelementptr"(%arg55) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %790 = "llvm.call"(%789) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_curve25519_scalar_validate, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> !llvm.ptr
  %791 = "llvm.icmp"(%790, %781) <{predicate = 0 : i64}> : (!llvm.ptr, !llvm.ptr) -> i1
  "llvm.cond_br"(%791, %782)[^bb7, ^bb1] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i32) -> ()
^bb1:  // pred: ^bb0
  "llvm.intr.lifetime.start"(%786) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%787) : (!llvm.ptr) -> ()
  %792 = "llvm.call"(%786, %arg56, %787, %arg55) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_ed25519_point_frombytes_2x, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> i32
  %793 = "llvm.icmp"(%792, %783) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%793)[^bb3, ^bb2] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb2:  // pred: ^bb1
  %794 = "llvm.icmp"(%792, %782) <{predicate = 0 : i64}> : (i32, i32) -> i1
  %795 = "llvm.select"(%794, %784, %782) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i32, i32) -> i32
  "llvm.br"(%795)[^bb6] : (i32) -> ()
^bb3:  // pred: ^bb1
  %796 = "llvm.call"(%786) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_ed25519_affine_is_small_order, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i32
  %797 = "llvm.icmp"(%796, %783) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%797, %784)[^bb4, ^bb6] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb4:  // pred: ^bb3
  %798 = "llvm.call"(%787) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_ed25519_affine_is_small_order, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i32
  %799 = "llvm.icmp"(%798, %783) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%799, %782)[^bb5, ^bb6] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb5:  // pred: ^bb4
  "llvm.intr.lifetime.start"(%788) : (!llvm.ptr) -> ()
  %800 = "llvm.call"(%arg57) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_sha512_init, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> !llvm.ptr
  %801 = "llvm.call"(%arg57, %arg55, %780) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_append, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %802 = "llvm.call"(%arg57, %arg56, %780) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_append, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %803 = "llvm.call"(%arg57, %arg53, %arg54) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_append, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %804 = "llvm.call"(%arg57, %788) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_sha512_fini, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %805 = "llvm.call"(%788, %788) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_curve25519_scalar_reduce, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %806 = "llvm.call"(%788, %786, %789, %787) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_verify_equation, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = readwrite, argMem = readwrite, inaccessibleMem = none, errnoMem = readwrite, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> i32
  %807 = "llvm.icmp"(%806, %783) <{predicate = 0 : i64}> : (i32, i32) -> i1
  %808 = "llvm.select"(%807, %785, %783) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i32, i32) -> i32
  "llvm.intr.lifetime.end"(%788) : (!llvm.ptr) -> ()
  "llvm.br"(%808)[^bb6] : (i32) -> ()
^bb6(%809: i32):  // 4 preds: ^bb2, ^bb3, ^bb4, ^bb5
  "llvm.intr.lifetime.end"(%787) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%786) : (!llvm.ptr) -> ()
  "llvm.br"(%809)[^bb7] : (i32) -> ()
^bb7(%810: i32):  // 2 preds: ^bb0, ^bb6
  "llvm.return"(%810) : (i32) -> ()
}) : () -> ()
  with @fd_curve25519_scalar_reduce := fd_curve25519_scalar_reduce,
    @fd_curve25519_scalar_validate := fd_curve25519_scalar_validate,
    @fd_ed25519_affine_is_small_order := fd_ed25519_affine_is_small_order,
    @fd_ed25519_point_frombytes_2x := fd_ed25519_point_frombytes_2x,
    @fd_ed25519_verify_equation := fd_ed25519_verify_equation,
    @fd_sha512_append := fd_sha512_append, @fd_sha512_fini := fd_sha512_fini,
    @fd_sha512_init := fd_sha512_init

end

end MLIR.Firedancer.Ref
