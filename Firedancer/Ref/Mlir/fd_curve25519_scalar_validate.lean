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
^bb0(%arg52: !llvm.ptr):
  %750 = "llvm.mlir.constant"() <{value = 16 : i8}> : () -> i8
  %751 = "llvm.mlir.constant"() <{value = 32 : i8}> : () -> i8
  %752 = "llvm.mlir.zero"() : () -> !llvm.ptr
  %753 = "llvm.mlir.constant"() <{value = 6346243789798364141 : i64}> : () -> i64
  %754 = "llvm.mlir.constant"() <{value = 1503914060200516823 : i64}> : () -> i64
  %755 = "llvm.mlir.constant"() <{value = 1503914060200516822 : i64}> : () -> i64
  %756 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %757 = "llvm.mlir.constant"() <{value = 1152921504606846977 : i64}> : () -> i64
  %758 = "llvm.mlir.constant"() <{value = 1152921504606846976 : i64}> : () -> i64
  %759 = "llvm.getelementptr"(%arg52) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 31>}> : (!llvm.ptr) -> !llvm.ptr
  %760 = "llvm.load"(%759) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> i8
  %761 = "llvm.icmp"(%760, %750) <{predicate = 6 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%761, %arg52)[^bb3, ^bb1] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, !llvm.ptr) -> ()
^bb1:  // pred: ^bb0
  %762 = "llvm.icmp"(%760, %751) <{predicate = 6 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%762, %752)[^bb2, ^bb3] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, !llvm.ptr) -> ()
^bb2:  // pred: ^bb1
  %763 = "llvm.call"(%arg52) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @fd_ulong_load_8, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i64
  %764 = "llvm.getelementptr"(%arg52) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %765 = "llvm.call"(%764) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @fd_ulong_load_8, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i64
  %766 = "llvm.getelementptr"(%arg52) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %767 = "llvm.call"(%766) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @fd_ulong_load_8, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i64
  %768 = "llvm.getelementptr"(%arg52) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %769 = "llvm.call"(%768) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @fd_ulong_load_8, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i64
  %770 = "llvm.icmp"(%763, %753) <{predicate = 6 : i64}> : (i64, i64) -> i1
  %771 = "llvm.select"(%770, %754, %755) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %772 = "llvm.icmp"(%765, %771) <{predicate = 6 : i64}> : (i64, i64) -> i1
  %773 = "llvm.icmp"(%767, %756) <{predicate = 0 : i64}> : (i64, i64) -> i1
  %774 = "llvm.and"(%773, %772) : (i1, i1) -> i1
  %775 = "llvm.select"(%774, %757, %758) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %776 = "llvm.icmp"(%769, %775) <{predicate = 6 : i64}> : (i64, i64) -> i1
  %777 = "llvm.select"(%776, %arg52, %752) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.br"(%777)[^bb3] : (!llvm.ptr) -> ()
^bb3(%778: !llvm.ptr):  // 3 preds: ^bb0, ^bb1, ^bb2
  "llvm.return"(%778) : (!llvm.ptr) -> ()
}) : () -> ()
  with @fd_ulong_load_8 := fd_ulong_load_8

end

end MLIR.Firedancer.Ref
