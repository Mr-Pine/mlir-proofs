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
^bb0(%arg67: !llvm.ptr, %arg68: !llvm.ptr, %arg69: i64):
  %1035 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %1036 = "llvm.mlir.constant"() <{value = 128 : i64}> : () -> i64
  %1037 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %1038 = "llvm.mlir.constant"() <{value = 61 : i64}> : () -> i64
  %1039 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %1040 = "llvm.mlir.constant"() <{value = 7 : i64}> : () -> i64
  %1041 = "llvm.mlir.constant"() <{value = 127 : i64}> : () -> i64
  %1042 = "llvm.mlir.constant"() <{value = -128 : i64}> : () -> i64
  %1043 = "llvm.icmp"(%arg69, %1035) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1043)[^bb10, ^bb1] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb1:  // pred: ^bb0
  %1044 = "llvm.getelementptr"(%arg67) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %1045 = "llvm.getelementptr"(%arg67) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 200>}> : (!llvm.ptr) -> !llvm.ptr
  %1046 = "llvm.load"(%1045) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag3]}> : (!llvm.ptr) -> i64
  %1047 = "llvm.getelementptr"(%arg67) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 208>}> : (!llvm.ptr) -> !llvm.ptr
  %1048 = "llvm.load"(%1047) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag4]}> : (!llvm.ptr) -> i64
  %1049 = "llvm.getelementptr"(%arg67) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 216>}> : (!llvm.ptr) -> !llvm.ptr
  %1050 = "llvm.load"(%1049) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag5]}> : (!llvm.ptr) -> i64
  %1051 = "llvm.shl"(%arg69, %1037) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1052 = "llvm.add"(%1048, %1051) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1053 = "llvm.lshr"(%arg69, %1038) : (i64, i64) -> i64
  %1054 = "llvm.add"(%1050, %1053) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1055 = "llvm.icmp"(%1052, %1048) <{predicate = 6 : i64}> : (i64, i64) -> i1
  %1056 = "llvm.zext"(%1055) : (i1) -> i64
  %1057 = "llvm.add"(%1054, %1056) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%1052, %1047) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag4]}> : (i64, !llvm.ptr) -> ()
  "llvm.store"(%1057, %1049) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag5]}> : (i64, !llvm.ptr) -> ()
  %1058 = "llvm.icmp"(%1046, %1035) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1058, %arg68, %arg69)[^bb5, ^bb2] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 2, 0>}> : (i1, !llvm.ptr, i64) -> ()
^bb2:  // pred: ^bb1
  %1059 = "llvm.sub"(%1036, %1046) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1060 = "llvm.icmp"(%arg69, %1059) <{predicate = 6 : i64}> : (i64, i64) -> i1
  %1061 = "llvm.getelementptr"(%arg67, %1046) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.cond_br"(%1060)[^bb3, ^bb4] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb3:  // pred: ^bb2
  %1062 = "llvm.call"(%1061, %arg68, %arg69) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_memcpy, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %1063 = "llvm.add"(%1046, %arg69) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.br"(%1063)[^bb9] : (i64) -> ()
^bb4:  // pred: ^bb2
  %1064 = "llvm.call"(%1061, %arg68, %1059) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_memcpy, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %1065 = "llvm.getelementptr"(%arg68, %1059) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1066 = "llvm.sub"(%arg69, %1059) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  "llvm.call"(%1044, %arg67, %1039) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_core_ref, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.store"(%1035, %1045) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag3]}> : (i64, !llvm.ptr) -> ()
  "llvm.br"(%1065, %1066)[^bb5] : (!llvm.ptr, i64) -> ()
^bb5(%1067: !llvm.ptr, %1068: i64):  // 2 preds: ^bb1, ^bb4
  %1069 = "llvm.lshr"(%1068, %1040) : (i64, i64) -> i64
  %1070 = "llvm.icmp"(%1069, %1035) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1070)[^bb7, ^bb6] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb6:  // pred: ^bb5
  "llvm.call"(%1044, %1067, %1069) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_core_ref, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.br"()[^bb7] : () -> ()
^bb7:  // 2 preds: ^bb5, ^bb6
  %1071 = "llvm.and"(%1068, %1041) : (i64, i64) -> i64
  %1072 = "llvm.icmp"(%1071, %1035) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1072)[^bb10, ^bb8] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb8:  // pred: ^bb7
  %1073 = "llvm.and"(%1068, %1042) : (i64, i64) -> i64
  %1074 = "llvm.getelementptr"(%1067, %1073) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1075 = "llvm.call"(%arg67, %1074, %1071) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_memcpy, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  "llvm.br"(%1071)[^bb9] : (i64) -> ()
^bb9(%1076: i64):  // 2 preds: ^bb3, ^bb8
  "llvm.store"(%1076, %1045) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag3]}> : (i64, !llvm.ptr) -> ()
  "llvm.br"()[^bb10] : () -> ()
^bb10:  // 3 preds: ^bb0, ^bb7, ^bb9
  "llvm.return"(%arg67) : (!llvm.ptr) -> ()
}) : () -> ()
  with @fd_memcpy := fd_memcpy, @fd_sha512_core_ref := fd_sha512_core_ref

end

end MLIR.Firedancer.Ref
