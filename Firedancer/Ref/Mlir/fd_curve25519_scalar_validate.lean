module

-- build/llvm23/mlir_canonicalized/ref/op/fd_curve25519_scalar_validate.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Ref.Mlir.fd_ulong_load_8

meta import MLIR.Semantics.Func
meta import Firedancer.Ref.Mlir.fd_ulong_load_8

namespace MLIR.Firedancer.Ref

@[expose] public section

mlir_def fd_curve25519_scalar_validate :=
#tbaa_root = #llvm.tbaa_root<id = "Simple C/C++ TBAA">
#tbaa_type_desc = #llvm.tbaa_type_desc<id = "omnipotent char", members = {<#tbaa_root, 0>}>
#tbaa_tag = #llvm.tbaa_tag<base_type = #tbaa_type_desc, access_type = #tbaa_type_desc, offset = 0>
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<ptr (ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], sym_name = "fd_curve25519_scalar_validate", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg48: !llvm.ptr):
  %745 = "llvm.mlir.constant"() <{value = 16 : i8}> : () -> i8
  %746 = "llvm.mlir.constant"() <{value = 32 : i8}> : () -> i8
  %747 = "llvm.mlir.zero"() : () -> !llvm.ptr
  %748 = "llvm.mlir.constant"() <{value = 6346243789798364141 : i64}> : () -> i64
  %749 = "llvm.mlir.constant"() <{value = 1503914060200516823 : i64}> : () -> i64
  %750 = "llvm.mlir.constant"() <{value = 1503914060200516822 : i64}> : () -> i64
  %751 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %752 = "llvm.mlir.constant"() <{value = 1152921504606846977 : i64}> : () -> i64
  %753 = "llvm.mlir.constant"() <{value = 1152921504606846976 : i64}> : () -> i64
  %754 = "llvm.getelementptr"(%arg48) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 31>}> : (!llvm.ptr) -> !llvm.ptr
  %755 = "llvm.load"(%754) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> i8
  %756 = "llvm.icmp"(%755, %745) <{predicate = 6 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%756, %arg48)[^bb3, ^bb1] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, !llvm.ptr) -> ()
^bb1:  // pred: ^bb0
  %757 = "llvm.icmp"(%755, %746) <{predicate = 6 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%757, %747)[^bb2, ^bb3] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, !llvm.ptr) -> ()
^bb2:  // pred: ^bb1
  %758 = "llvm.call"(%arg48) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @fd_ulong_load_8, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i64
  %759 = "llvm.getelementptr"(%arg48) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %760 = "llvm.call"(%759) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @fd_ulong_load_8, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i64
  %761 = "llvm.getelementptr"(%arg48) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %762 = "llvm.call"(%761) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @fd_ulong_load_8, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i64
  %763 = "llvm.getelementptr"(%arg48) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %764 = "llvm.call"(%763) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @fd_ulong_load_8, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i64
  %765 = "llvm.icmp"(%758, %748) <{predicate = 6 : i64}> : (i64, i64) -> i1
  %766 = "llvm.select"(%765, %749, %750) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %767 = "llvm.icmp"(%760, %766) <{predicate = 6 : i64}> : (i64, i64) -> i1
  %768 = "llvm.icmp"(%762, %751) <{predicate = 0 : i64}> : (i64, i64) -> i1
  %769 = "llvm.and"(%768, %767) : (i1, i1) -> i1
  %770 = "llvm.select"(%769, %752, %753) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %771 = "llvm.icmp"(%764, %770) <{predicate = 6 : i64}> : (i64, i64) -> i1
  %772 = "llvm.select"(%771, %arg48, %747) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.br"(%772)[^bb3] : (!llvm.ptr) -> ()
^bb3(%773: !llvm.ptr):  // 3 preds: ^bb0, ^bb1, ^bb2
  "llvm.return"(%773) : (!llvm.ptr) -> ()
}) : () -> ()
  with @fd_ulong_load_8 := fd_ulong_load_8

end

end MLIR.Firedancer.Ref
