module

-- build/llvm23/mlir_canonicalized/ref/op/fd_ed25519_point_dbln.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Ref.Mlir.fd_ed25519_partial_dbl
public import Firedancer.Ref.Mlir.fd_ed25519_point_add_final_mul
public import Firedancer.Ref.Mlir.fd_ed25519_point_add_final_mul_projective

meta import MLIR.Semantics.Func
meta import Firedancer.Ref.Mlir.fd_ed25519_partial_dbl
meta import Firedancer.Ref.Mlir.fd_ed25519_point_add_final_mul
meta import Firedancer.Ref.Mlir.fd_ed25519_point_add_final_mul_projective

namespace MLIR.Firedancer.Ref

@[expose] public section

mlir_def fd_ed25519_point_dbln :=
#loop_unroll = #llvm.loop_unroll<disable = true>
#loop_annotation = #llvm.loop_annotation<unroll = #loop_unroll, mustProgress = true>
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nofree, llvm.noundef, llvm.returned}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.noundef}], dso_local, function_type = !llvm.func<ptr (ptr, ptr, i32)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], res_attrs = [{llvm.noundef}], sym_name = "fd_ed25519_point_dbln", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg126: !llvm.ptr, %arg127: !llvm.ptr, %arg128: i32):
  %2005 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %2006 = "llvm.mlir.constant"() <{value = 1 : i8}> : () -> i8
  %2007 = "llvm.alloca"(%2005) <{alignment = 16 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_curve25519_edwards", (array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>, array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>, array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>, array<1 x struct<"struct.fd_f25519", (array<5 x i64>)>>)>>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%2007) : (!llvm.ptr) -> ()
  %2008 = "llvm.call"(%2007, %arg127) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_partial_dbl, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %2009 = "llvm.icmp"(%arg128, %2005) <{predicate = 4 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2009, %2006)[^bb2, ^bb1] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i8) -> ()
^bb1:  // 2 preds: ^bb0, ^bb2
  %2010 = "llvm.call"(%arg126, %2007) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_final_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.intr.lifetime.end"(%2007) : (!llvm.ptr) -> ()
  "llvm.return"(%arg126) : (!llvm.ptr) -> ()
^bb2(%2011: i8):  // 2 preds: ^bb0, ^bb2
  %2012 = "llvm.call"(%arg126, %2007) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_final_mul_projective, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %2013 = "llvm.call"(%2007, %arg126) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_partial_dbl, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %2014 = "llvm.add"(%2011, %2006) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  %2015 = "llvm.zext"(%2014) : (i8) -> i32
  %2016 = "llvm.icmp"(%arg128, %2015) <{predicate = 8 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2016, %2014)[^bb2, ^bb1] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i8) -> ()
}) : () -> ()
  with @fd_ed25519_partial_dbl := fd_ed25519_partial_dbl,
    @fd_ed25519_point_add_final_mul := fd_ed25519_point_add_final_mul,
    @fd_ed25519_point_add_final_mul_projective := fd_ed25519_point_add_final_mul_projective

end

end MLIR.Firedancer.Ref
