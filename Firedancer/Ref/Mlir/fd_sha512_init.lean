module

-- build/llvm23/mlir_canonicalized/ref/op/fd_sha512_init.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Firedancer.Ref

@[expose] public section

mlir_def fd_sha512_init :=
#tbaa_root = #llvm.tbaa_root<id = "Simple C/C++ TBAA">
#tbaa_type_desc = #llvm.tbaa_type_desc<id = "omnipotent char", members = {<#tbaa_root, 0>}>
#tbaa_type_desc1 = #llvm.tbaa_type_desc<id = "long", members = {<#tbaa_type_desc, 0>}>
#tbaa_tag1 = #llvm.tbaa_tag<base_type = #tbaa_type_desc1, access_type = #tbaa_type_desc1, offset = 0>
"llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nofree, llvm.noundef, llvm.returned, llvm.writeonly}], dso_local, function_type = !llvm.func<ptr (ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], res_attrs = [{llvm.noundef}], sym_name = "fd_sha512_init", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg66: !llvm.ptr):
  %1073 = "llvm.mlir.constant"() <{value = 7640891576956012808 : i64}> : () -> i64
  %1074 = "llvm.mlir.constant"() <{value = -4942790177534073029 : i64}> : () -> i64
  %1075 = "llvm.mlir.constant"() <{value = 4354685564936845355 : i64}> : () -> i64
  %1076 = "llvm.mlir.constant"() <{value = -6534734903238641935 : i64}> : () -> i64
  %1077 = "llvm.mlir.constant"() <{value = 5840696475078001361 : i64}> : () -> i64
  %1078 = "llvm.mlir.constant"() <{value = -7276294671716946913 : i64}> : () -> i64
  %1079 = "llvm.mlir.constant"() <{value = 2270897969802886507 : i64}> : () -> i64
  %1080 = "llvm.mlir.constant"() <{value = 6620516959819538809 : i64}> : () -> i64
  %1081 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %1082 = "llvm.mlir.constant"() <{value = 24 : i64}> : () -> i64
  %1083 = "llvm.getelementptr"(%arg66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1073, %1083) <{alignment = 128 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  %1084 = "llvm.getelementptr"(%arg66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 136>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1074, %1084) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  %1085 = "llvm.getelementptr"(%arg66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 144>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1075, %1085) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  %1086 = "llvm.getelementptr"(%arg66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 152>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1076, %1086) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  %1087 = "llvm.getelementptr"(%arg66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 160>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1077, %1087) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  %1088 = "llvm.getelementptr"(%arg66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 168>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1078, %1088) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  %1089 = "llvm.getelementptr"(%arg66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 176>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1079, %1089) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  %1090 = "llvm.getelementptr"(%arg66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 184>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1080, %1090) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  %1091 = "llvm.getelementptr"(%arg66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 200>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memset"(%1091, %1081, %1082) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 24 : i64, llvm.nonnull, llvm.noundef}, {}, {}], isVolatile = false}> : (!llvm.ptr, i8, i64) -> ()
  "llvm.return"(%arg66) : (!llvm.ptr) -> ()
}) : () -> ()

end

end MLIR.Firedancer.Ref
