module

-- build/llvm23/mlir_canonicalized/ref/op/fd_sha512_append.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Ref.Mlir.fd_memcpy
public import Firedancer.Ref.Mlir.fd_sha512_core_ref

meta import MLIR.Semantics.Func
meta import Firedancer.Ref.Mlir.fd_memcpy
meta import Firedancer.Ref.Mlir.fd_sha512_core_ref

namespace MLIR.Firedancer.Ref

@[expose] public section

mlir_def fd_sha512_append :=
#tbaa_root = #llvm.tbaa_root<id = "Simple C/C++ TBAA">
#tbaa_type_desc = #llvm.tbaa_type_desc<id = "omnipotent char", members = {<#tbaa_root, 0>}>
#tbaa_type_desc1 = #llvm.tbaa_type_desc<id = "long", members = {<#tbaa_type_desc, 0>}>
#tbaa_type_desc3 = #llvm.tbaa_type_desc<id = "fd_sha512_private", members = {<#tbaa_type_desc, 0>, <#tbaa_type_desc, 128>, <#tbaa_type_desc1, 192>, <#tbaa_type_desc1, 200>, <#tbaa_type_desc1, 208>, <#tbaa_type_desc1, 216>}>
#tbaa_tag3 = #llvm.tbaa_tag<base_type = #tbaa_type_desc3, access_type = #tbaa_type_desc1, offset = 200>
#tbaa_tag4 = #llvm.tbaa_tag<base_type = #tbaa_type_desc3, access_type = #tbaa_type_desc1, offset = 208>
#tbaa_tag5 = #llvm.tbaa_tag<base_type = #tbaa_type_desc3, access_type = #tbaa_type_desc1, offset = 216>
"llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nofree, llvm.noundef, llvm.returned}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.noundef}], dso_local, function_type = !llvm.func<ptr (ptr, ptr, i64)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], res_attrs = [{llvm.noundef}], sym_name = "fd_sha512_append", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg63: !llvm.ptr, %arg64: !llvm.ptr, %arg65: i64):
  %1031 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %1032 = "llvm.mlir.constant"() <{value = 128 : i64}> : () -> i64
  %1033 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %1034 = "llvm.mlir.constant"() <{value = 61 : i64}> : () -> i64
  %1035 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %1036 = "llvm.mlir.constant"() <{value = 7 : i64}> : () -> i64
  %1037 = "llvm.mlir.constant"() <{value = 127 : i64}> : () -> i64
  %1038 = "llvm.mlir.constant"() <{value = -128 : i64}> : () -> i64
  %1039 = "llvm.icmp"(%arg65, %1031) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1039)[^bb10, ^bb1] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb1:  // pred: ^bb0
  %1040 = "llvm.getelementptr"(%arg63) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %1041 = "llvm.getelementptr"(%arg63) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 200>}> : (!llvm.ptr) -> !llvm.ptr
  %1042 = "llvm.load"(%1041) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag3]}> : (!llvm.ptr) -> i64
  %1043 = "llvm.getelementptr"(%arg63) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 208>}> : (!llvm.ptr) -> !llvm.ptr
  %1044 = "llvm.load"(%1043) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag4]}> : (!llvm.ptr) -> i64
  %1045 = "llvm.getelementptr"(%arg63) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 216>}> : (!llvm.ptr) -> !llvm.ptr
  %1046 = "llvm.load"(%1045) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag5]}> : (!llvm.ptr) -> i64
  %1047 = "llvm.shl"(%arg65, %1033) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1048 = "llvm.add"(%1044, %1047) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1049 = "llvm.lshr"(%arg65, %1034) : (i64, i64) -> i64
  %1050 = "llvm.add"(%1046, %1049) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1051 = "llvm.icmp"(%1048, %1044) <{predicate = 6 : i64}> : (i64, i64) -> i1
  %1052 = "llvm.zext"(%1051) : (i1) -> i64
  %1053 = "llvm.add"(%1050, %1052) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%1048, %1043) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag4]}> : (i64, !llvm.ptr) -> ()
  "llvm.store"(%1053, %1045) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag5]}> : (i64, !llvm.ptr) -> ()
  %1054 = "llvm.icmp"(%1042, %1031) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1054, %arg64, %arg65)[^bb5, ^bb2] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 2, 0>}> : (i1, !llvm.ptr, i64) -> ()
^bb2:  // pred: ^bb1
  %1055 = "llvm.sub"(%1032, %1042) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1056 = "llvm.icmp"(%arg65, %1055) <{predicate = 6 : i64}> : (i64, i64) -> i1
  %1057 = "llvm.getelementptr"(%arg63, %1042) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.cond_br"(%1056)[^bb3, ^bb4] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb3:  // pred: ^bb2
  %1058 = "llvm.call"(%1057, %arg64, %arg65) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_memcpy, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %1059 = "llvm.add"(%1042, %arg65) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.br"(%1059)[^bb9] : (i64) -> ()
^bb4:  // pred: ^bb2
  %1060 = "llvm.call"(%1057, %arg64, %1055) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_memcpy, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %1061 = "llvm.getelementptr"(%arg64, %1055) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1062 = "llvm.sub"(%arg65, %1055) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  "llvm.call"(%1040, %arg63, %1035) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_core_ref, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.store"(%1031, %1041) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag3]}> : (i64, !llvm.ptr) -> ()
  "llvm.br"(%1061, %1062)[^bb5] : (!llvm.ptr, i64) -> ()
^bb5(%1063: !llvm.ptr, %1064: i64):  // 2 preds: ^bb1, ^bb4
  %1065 = "llvm.lshr"(%1064, %1036) : (i64, i64) -> i64
  %1066 = "llvm.icmp"(%1065, %1031) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1066)[^bb7, ^bb6] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb6:  // pred: ^bb5
  "llvm.call"(%1040, %1063, %1065) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_core_ref, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.br"()[^bb7] : () -> ()
^bb7:  // 2 preds: ^bb5, ^bb6
  %1067 = "llvm.and"(%1064, %1037) : (i64, i64) -> i64
  %1068 = "llvm.icmp"(%1067, %1031) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1068)[^bb10, ^bb8] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb8:  // pred: ^bb7
  %1069 = "llvm.and"(%1064, %1038) : (i64, i64) -> i64
  %1070 = "llvm.getelementptr"(%1063, %1069) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1071 = "llvm.call"(%arg63, %1070, %1067) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_memcpy, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  "llvm.br"(%1067)[^bb9] : (i64) -> ()
^bb9(%1072: i64):  // 2 preds: ^bb3, ^bb8
  "llvm.store"(%1072, %1041) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag3]}> : (i64, !llvm.ptr) -> ()
  "llvm.br"()[^bb10] : () -> ()
^bb10:  // 3 preds: ^bb0, ^bb7, ^bb9
  "llvm.return"(%arg63) : (!llvm.ptr) -> ()
}) : () -> ()
  with @fd_memcpy := fd_memcpy, @fd_sha512_core_ref := fd_sha512_core_ref

end

end MLIR.Firedancer.Ref
