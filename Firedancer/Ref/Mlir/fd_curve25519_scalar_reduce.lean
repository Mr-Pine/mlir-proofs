module

-- build/llvm23/mlir_canonicalized/ref/op/fd_curve25519_scalar_reduce.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Ref.Mlir.fd_ulong_load_8

meta import MLIR.Semantics.Func
meta import Firedancer.Ref.Mlir.fd_ulong_load_8

namespace MLIR.Firedancer.Ref

@[expose] public section

mlir_def fd_curve25519_scalar_reduce :=
#tbaa_root = #llvm.tbaa_root<id = "Simple C/C++ TBAA">
#tbaa_type_desc = #llvm.tbaa_type_desc<id = "omnipotent char", members = {<#tbaa_root, 0>}>
#tbaa_type_desc1 = #llvm.tbaa_type_desc<id = "long", members = {<#tbaa_type_desc, 0>}>
#tbaa_tag1 = #llvm.tbaa_tag<base_type = #tbaa_type_desc1, access_type = #tbaa_type_desc1, offset = 0>
"llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nofree, llvm.noundef, llvm.returned, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<ptr (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], res_attrs = [{llvm.noundef}], sym_name = "fd_curve25519_scalar_reduce", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg71: !llvm.ptr, %arg72: !llvm.ptr):
  %1096 = "llvm.mlir.constant"() <{value = 16 : i64}> : () -> i64
  %1097 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
  %1098 = "llvm.mlir.constant"() <{value = 2097151 : i64}> : () -> i64
  %1099 = "llvm.mlir.constant"() <{value = 21 : i64}> : () -> i64
  %1100 = "llvm.mlir.constant"() <{value = 42 : i64}> : () -> i64
  %1101 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %1102 = "llvm.mlir.constant"() <{value = 20 : i64}> : () -> i64
  %1103 = "llvm.mlir.constant"() <{value = 41 : i64}> : () -> i64
  %1104 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %1105 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %1106 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %1107 = "llvm.mlir.constant"() <{value = 18 : i64}> : () -> i64
  %1108 = "llvm.mlir.constant"() <{value = 39 : i64}> : () -> i64
  %1109 = "llvm.mlir.constant"() <{value = 4 : i64}> : () -> i64
  %1110 = "llvm.mlir.constant"() <{value = 17 : i64}> : () -> i64
  %1111 = "llvm.mlir.constant"() <{value = 38 : i64}> : () -> i64
  %1112 = "llvm.mlir.constant"() <{value = 5 : i64}> : () -> i64
  %1113 = "llvm.mlir.constant"() <{value = 37 : i64}> : () -> i64
  %1114 = "llvm.mlir.constant"() <{value = 6 : i64}> : () -> i64
  %1115 = "llvm.mlir.constant"() <{value = 15 : i64}> : () -> i64
  %1116 = "llvm.mlir.constant"() <{value = 36 : i64}> : () -> i64
  %1117 = "llvm.mlir.constant"() <{value = 7 : i64}> : () -> i64
  %1118 = "llvm.mlir.constant"() <{value = 14 : i64}> : () -> i64
  %1119 = "llvm.mlir.constant"() <{value = 35 : i64}> : () -> i64
  %1120 = "llvm.mlir.constant"() <{value = 666643 : i64}> : () -> i64
  %1121 = "llvm.mlir.constant"() <{value = 470296 : i64}> : () -> i64
  %1122 = "llvm.mlir.constant"() <{value = 654183 : i64}> : () -> i64
  %1123 = "llvm.mlir.constant"() <{value = -997805 : i64}> : () -> i64
  %1124 = "llvm.mlir.constant"() <{value = 136657 : i64}> : () -> i64
  %1125 = "llvm.mlir.constant"() <{value = -683901 : i64}> : () -> i64
  %1126 = "llvm.mlir.constant"() <{value = 1048576 : i64}> : () -> i64
  %1127 = "llvm.mlir.constant"() <{value = 8796090925056 : i64}> : () -> i64
  %1128 = "llvm.mlir.constant"() <{value = 9223372036852678656 : i64}> : () -> i64
  %1129 = "llvm.mlir.constant"() <{value = -2097152 : i64}> : () -> i64
  %1130 = "llvm.mlir.constant"() <{value = 4398044413952 : i64}> : () -> i64
  %1131 = "llvm.mlir.constant"() <{value = 9223367638808264704 : i64}> : () -> i64
  %1132 = "llvm.mlir.constant"() <{value = 63 : i64}> : () -> i64
  %1133 = "llvm.mlir.constant"() <{value = 1048575 : i64}> : () -> i64
  %1134 = "llvm.mlir.constant"() <{value = 2199022206976 : i64}> : () -> i64
  %1135 = "llvm.mlir.constant"() <{value = 4611683819404132352 : i64}> : () -> i64
  %1136 = "llvm.mlir.constant"() <{value = 62 : i64}> : () -> i64
  %1137 = "llvm.mlir.constant"() <{value = 524287 : i64}> : () -> i64
  %1138 = "llvm.mlir.constant"() <{value = 1099511103488 : i64}> : () -> i64
  %1139 = "llvm.mlir.constant"() <{value = 2305841909702066176 : i64}> : () -> i64
  %1140 = "llvm.mlir.constant"() <{value = 61 : i64}> : () -> i64
  %1141 = "llvm.mlir.constant"() <{value = 262143 : i64}> : () -> i64
  %1142 = "llvm.mlir.constant"() <{value = 549755551744 : i64}> : () -> i64
  %1143 = "llvm.call"(%arg72) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_ulong_load_8, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i64
  %1144 = "llvm.getelementptr"(%arg72) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %1145 = "llvm.call"(%1144) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @fd_ulong_load_8, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i64
  %1146 = "llvm.getelementptr"(%arg72) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %1147 = "llvm.call"(%1146) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @fd_ulong_load_8, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i64
  %1148 = "llvm.getelementptr"(%arg72) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %1149 = "llvm.call"(%1148) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @fd_ulong_load_8, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i64
  %1150 = "llvm.getelementptr"(%arg72) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %1151 = "llvm.call"(%1150) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @fd_ulong_load_8, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i64
  %1152 = "llvm.getelementptr"(%arg72) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  %1153 = "llvm.call"(%1152) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @fd_ulong_load_8, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i64
  %1154 = "llvm.getelementptr"(%arg72) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 48>}> : (!llvm.ptr) -> !llvm.ptr
  %1155 = "llvm.call"(%1154) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @fd_ulong_load_8, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i64
  %1156 = "llvm.getelementptr"(%arg72) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 56>}> : (!llvm.ptr) -> !llvm.ptr
  %1157 = "llvm.call"(%1156) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @fd_ulong_load_8, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i64
  %1158 = "llvm.and"(%1143, %1098) : (i64, i64) -> i64
  %1159 = "llvm.lshr"(%1143, %1099) : (i64, i64) -> i64
  %1160 = "llvm.and"(%1159, %1098) : (i64, i64) -> i64
  %1161 = "llvm.lshr"(%1143, %1100) : (i64, i64) -> i64
  %1162 = "llvm.and"(%1161, %1098) : (i64, i64) -> i64
  %1163 = "llvm.intr.fshl"(%1145, %1143, %1101) : (i64, i64, i64) -> i64
  %1164 = "llvm.and"(%1163, %1098) : (i64, i64) -> i64
  %1165 = "llvm.lshr"(%1145, %1102) : (i64, i64) -> i64
  %1166 = "llvm.and"(%1165, %1098) : (i64, i64) -> i64
  %1167 = "llvm.lshr"(%1145, %1103) : (i64, i64) -> i64
  %1168 = "llvm.and"(%1167, %1098) : (i64, i64) -> i64
  %1169 = "llvm.intr.fshl"(%1147, %1145, %1104) : (i64, i64, i64) -> i64
  %1170 = "llvm.and"(%1169, %1098) : (i64, i64) -> i64
  %1171 = "llvm.lshr"(%1147, %1105) : (i64, i64) -> i64
  %1172 = "llvm.and"(%1171, %1098) : (i64, i64) -> i64
  %1173 = "llvm.lshr"(%1147, %1097) : (i64, i64) -> i64
  %1174 = "llvm.and"(%1173, %1098) : (i64, i64) -> i64
  %1175 = "llvm.intr.fshl"(%1149, %1147, %1106) : (i64, i64, i64) -> i64
  %1176 = "llvm.and"(%1175, %1098) : (i64, i64) -> i64
  %1177 = "llvm.lshr"(%1149, %1107) : (i64, i64) -> i64
  %1178 = "llvm.and"(%1177, %1098) : (i64, i64) -> i64
  %1179 = "llvm.lshr"(%1149, %1108) : (i64, i64) -> i64
  %1180 = "llvm.and"(%1179, %1098) : (i64, i64) -> i64
  %1181 = "llvm.intr.fshl"(%1151, %1149, %1109) : (i64, i64, i64) -> i64
  %1182 = "llvm.and"(%1181, %1098) : (i64, i64) -> i64
  %1183 = "llvm.lshr"(%1151, %1110) : (i64, i64) -> i64
  %1184 = "llvm.and"(%1183, %1098) : (i64, i64) -> i64
  %1185 = "llvm.lshr"(%1151, %1111) : (i64, i64) -> i64
  %1186 = "llvm.and"(%1185, %1098) : (i64, i64) -> i64
  %1187 = "llvm.intr.fshl"(%1153, %1151, %1112) : (i64, i64, i64) -> i64
  %1188 = "llvm.and"(%1187, %1098) : (i64, i64) -> i64
  %1189 = "llvm.lshr"(%1153, %1096) : (i64, i64) -> i64
  %1190 = "llvm.and"(%1189, %1098) : (i64, i64) -> i64
  %1191 = "llvm.lshr"(%1153, %1113) : (i64, i64) -> i64
  %1192 = "llvm.and"(%1191, %1098) : (i64, i64) -> i64
  %1193 = "llvm.intr.fshl"(%1155, %1153, %1114) : (i64, i64, i64) -> i64
  %1194 = "llvm.and"(%1193, %1098) : (i64, i64) -> i64
  %1195 = "llvm.lshr"(%1155, %1115) : (i64, i64) -> i64
  %1196 = "llvm.and"(%1195, %1098) : (i64, i64) -> i64
  %1197 = "llvm.lshr"(%1155, %1116) : (i64, i64) -> i64
  %1198 = "llvm.and"(%1197, %1098) : (i64, i64) -> i64
  %1199 = "llvm.intr.fshl"(%1157, %1155, %1117) : (i64, i64, i64) -> i64
  %1200 = "llvm.and"(%1199, %1098) : (i64, i64) -> i64
  %1201 = "llvm.lshr"(%1157, %1118) : (i64, i64) -> i64
  %1202 = "llvm.and"(%1201, %1098) : (i64, i64) -> i64
  %1203 = "llvm.lshr"(%1157, %1119) : (i64, i64) -> i64
  %1204 = "llvm.mul"(%1203, %1120) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1205 = "llvm.add"(%1204, %1180) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1206 = "llvm.mul"(%1203, %1121) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1207 = "llvm.add"(%1206, %1182) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1208 = "llvm.mul"(%1203, %1122) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1209 = "llvm.add"(%1208, %1184) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1210 = "llvm.mul"(%1203, %1123) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1211 = "llvm.add"(%1210, %1186) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1212 = "llvm.mul"(%1203, %1124) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1213 = "llvm.add"(%1212, %1188) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1214 = "llvm.mul"(%1203, %1125) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1215 = "llvm.add"(%1214, %1190) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1216 = "llvm.mul"(%1202, %1120) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1217 = "llvm.mul"(%1202, %1121) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1218 = "llvm.mul"(%1202, %1122) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1219 = "llvm.mul"(%1202, %1123) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1220 = "llvm.mul"(%1202, %1124) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1221 = "llvm.add"(%1211, %1220) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1222 = "llvm.mul"(%1202, %1125) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1223 = "llvm.add"(%1213, %1222) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1224 = "llvm.mul"(%1200, %1120) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1225 = "llvm.mul"(%1200, %1121) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1226 = "llvm.mul"(%1200, %1122) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1227 = "llvm.mul"(%1200, %1123) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1228 = "llvm.mul"(%1200, %1124) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1229 = "llvm.mul"(%1200, %1125) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1230 = "llvm.add"(%1221, %1229) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1231 = "llvm.mul"(%1198, %1120) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1232 = "llvm.add"(%1231, %1174) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1233 = "llvm.mul"(%1198, %1121) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1234 = "llvm.mul"(%1198, %1122) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1235 = "llvm.mul"(%1198, %1123) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1236 = "llvm.mul"(%1198, %1124) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1237 = "llvm.mul"(%1198, %1125) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1238 = "llvm.mul"(%1196, %1120) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1239 = "llvm.add"(%1238, %1172) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1240 = "llvm.mul"(%1196, %1121) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1241 = "llvm.add"(%1232, %1240) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1242 = "llvm.mul"(%1196, %1122) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1243 = "llvm.mul"(%1196, %1123) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1244 = "llvm.mul"(%1196, %1124) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1245 = "llvm.mul"(%1196, %1125) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1246 = "llvm.add"(%1207, %1236) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1247 = "llvm.add"(%1246, %1245) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1248 = "llvm.add"(%1247, %1218) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1249 = "llvm.add"(%1248, %1227) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1250 = "llvm.mul"(%1194, %1120) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1251 = "llvm.add"(%1250, %1170) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1252 = "llvm.mul"(%1194, %1121) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1253 = "llvm.add"(%1239, %1252) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1254 = "llvm.mul"(%1194, %1122) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1255 = "llvm.add"(%1241, %1254) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1256 = "llvm.mul"(%1194, %1123) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1257 = "llvm.mul"(%1194, %1124) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1258 = "llvm.add"(%1234, %1178) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1259 = "llvm.add"(%1258, %1243) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1260 = "llvm.add"(%1259, %1257) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1261 = "llvm.add"(%1260, %1216) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1262 = "llvm.add"(%1261, %1225) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1263 = "llvm.mul"(%1194, %1125) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1264 = "llvm.add"(%1251, %1126) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1265 = "llvm.lshr"(%1264, %1099) : (i64, i64) -> i64
  %1266 = "llvm.add"(%1253, %1265) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1267 = "llvm.and"(%1264, %1127) : (i64, i64) -> i64
  %1268 = "llvm.sub"(%1251, %1267) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1269 = "llvm.add"(%1255, %1126) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1270 = "llvm.lshr"(%1269, %1099) : (i64, i64) -> i64
  %1271 = "llvm.add"(%1233, %1176) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1272 = "llvm.add"(%1271, %1242) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1273 = "llvm.add"(%1272, %1256) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1274 = "llvm.add"(%1273, %1224) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1275 = "llvm.add"(%1274, %1270) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1276 = "llvm.and"(%1269, %1128) : (i64, i64) -> i64
  %1277 = "llvm.sub"(%1255, %1276) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1278 = "llvm.add"(%1262, %1126) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1279 = "llvm.ashr"(%1278, %1099) : (i64, i64) -> i64
  %1280 = "llvm.add"(%1205, %1235) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1281 = "llvm.add"(%1280, %1244) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1282 = "llvm.add"(%1281, %1263) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1283 = "llvm.add"(%1282, %1217) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1284 = "llvm.add"(%1283, %1226) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1285 = "llvm.add"(%1284, %1279) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1286 = "llvm.and"(%1278, %1129) : (i64, i64) -> i64
  %1287 = "llvm.add"(%1249, %1126) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1288 = "llvm.ashr"(%1287, %1099) : (i64, i64) -> i64
  %1289 = "llvm.add"(%1209, %1237) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1290 = "llvm.add"(%1289, %1219) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1291 = "llvm.add"(%1290, %1228) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1292 = "llvm.add"(%1291, %1288) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1293 = "llvm.and"(%1287, %1129) : (i64, i64) -> i64
  %1294 = "llvm.sub"(%1249, %1293) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1295 = "llvm.add"(%1230, %1126) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1296 = "llvm.ashr"(%1295, %1099) : (i64, i64) -> i64
  %1297 = "llvm.add"(%1223, %1296) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1298 = "llvm.and"(%1295, %1129) : (i64, i64) -> i64
  %1299 = "llvm.sub"(%1230, %1298) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1300 = "llvm.add"(%1215, %1126) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1301 = "llvm.ashr"(%1300, %1099) : (i64, i64) -> i64
  %1302 = "llvm.add"(%1301, %1192) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1303 = "llvm.and"(%1300, %1129) : (i64, i64) -> i64
  %1304 = "llvm.sub"(%1215, %1303) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1305 = "llvm.add"(%1266, %1126) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1306 = "llvm.lshr"(%1305, %1099) : (i64, i64) -> i64
  %1307 = "llvm.and"(%1305, %1128) : (i64, i64) -> i64
  %1308 = "llvm.add"(%1275, %1126) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1309 = "llvm.ashr"(%1308, %1099) : (i64, i64) -> i64
  %1310 = "llvm.and"(%1308, %1129) : (i64, i64) -> i64
  %1311 = "llvm.add"(%1285, %1126) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1312 = "llvm.ashr"(%1311, %1099) : (i64, i64) -> i64
  %1313 = "llvm.add"(%1312, %1294) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1314 = "llvm.and"(%1311, %1129) : (i64, i64) -> i64
  %1315 = "llvm.sub"(%1285, %1314) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1316 = "llvm.add"(%1292, %1126) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1317 = "llvm.ashr"(%1316, %1099) : (i64, i64) -> i64
  %1318 = "llvm.add"(%1317, %1299) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1319 = "llvm.and"(%1316, %1129) : (i64, i64) -> i64
  %1320 = "llvm.sub"(%1292, %1319) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1321 = "llvm.add"(%1297, %1126) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1322 = "llvm.ashr"(%1321, %1099) : (i64, i64) -> i64
  %1323 = "llvm.add"(%1322, %1304) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1324 = "llvm.and"(%1321, %1129) : (i64, i64) -> i64
  %1325 = "llvm.sub"(%1297, %1324) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1326 = "llvm.mul"(%1302, %1120) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1327 = "llvm.add"(%1326, %1168) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1328 = "llvm.mul"(%1302, %1121) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1329 = "llvm.add"(%1268, %1328) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1330 = "llvm.mul"(%1302, %1122) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1331 = "llvm.mul"(%1302, %1123) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1332 = "llvm.mul"(%1302, %1124) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1333 = "llvm.mul"(%1302, %1125) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1334 = "llvm.add"(%1262, %1333) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1335 = "llvm.sub"(%1334, %1286) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1336 = "llvm.add"(%1335, %1309) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1337 = "llvm.mul"(%1323, %1120) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1338 = "llvm.add"(%1337, %1166) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1339 = "llvm.mul"(%1323, %1121) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1340 = "llvm.add"(%1327, %1339) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1341 = "llvm.mul"(%1323, %1122) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1342 = "llvm.add"(%1329, %1341) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1343 = "llvm.mul"(%1323, %1123) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1344 = "llvm.mul"(%1323, %1124) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1345 = "llvm.mul"(%1323, %1125) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1346 = "llvm.mul"(%1325, %1120) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1347 = "llvm.add"(%1346, %1164) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1348 = "llvm.mul"(%1325, %1121) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1349 = "llvm.add"(%1338, %1348) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1350 = "llvm.mul"(%1325, %1122) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1351 = "llvm.add"(%1340, %1350) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1352 = "llvm.mul"(%1325, %1123) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1353 = "llvm.add"(%1342, %1352) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1354 = "llvm.mul"(%1325, %1124) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1355 = "llvm.mul"(%1325, %1125) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1356 = "llvm.add"(%1277, %1331) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1357 = "llvm.add"(%1356, %1306) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1358 = "llvm.add"(%1357, %1344) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1359 = "llvm.add"(%1358, %1355) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1360 = "llvm.mul"(%1318, %1120) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1361 = "llvm.add"(%1360, %1162) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1362 = "llvm.mul"(%1318, %1121) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1363 = "llvm.add"(%1347, %1362) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1364 = "llvm.mul"(%1318, %1122) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1365 = "llvm.add"(%1349, %1364) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1366 = "llvm.mul"(%1318, %1123) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1367 = "llvm.add"(%1351, %1366) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1368 = "llvm.mul"(%1318, %1124) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1369 = "llvm.add"(%1353, %1368) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1370 = "llvm.mul"(%1318, %1125) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1371 = "llvm.mul"(%1320, %1120) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1372 = "llvm.add"(%1371, %1160) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1373 = "llvm.mul"(%1320, %1121) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1374 = "llvm.add"(%1361, %1373) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1375 = "llvm.mul"(%1320, %1122) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1376 = "llvm.add"(%1363, %1375) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1377 = "llvm.mul"(%1320, %1123) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1378 = "llvm.add"(%1365, %1377) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1379 = "llvm.mul"(%1320, %1124) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1380 = "llvm.add"(%1367, %1379) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1381 = "llvm.mul"(%1320, %1125) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1382 = "llvm.add"(%1369, %1381) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1383 = "llvm.mul"(%1313, %1120) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1384 = "llvm.add"(%1383, %1158) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1385 = "llvm.mul"(%1313, %1121) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1386 = "llvm.add"(%1372, %1385) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1387 = "llvm.mul"(%1313, %1122) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1388 = "llvm.add"(%1374, %1387) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1389 = "llvm.mul"(%1313, %1123) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1390 = "llvm.add"(%1376, %1389) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1391 = "llvm.mul"(%1313, %1124) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1392 = "llvm.add"(%1378, %1391) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1393 = "llvm.mul"(%1313, %1125) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1394 = "llvm.add"(%1380, %1393) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1395 = "llvm.add"(%1384, %1126) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1396 = "llvm.ashr"(%1395, %1099) : (i64, i64) -> i64
  %1397 = "llvm.add"(%1386, %1396) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1398 = "llvm.and"(%1395, %1129) : (i64, i64) -> i64
  %1399 = "llvm.sub"(%1384, %1398) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1400 = "llvm.add"(%1388, %1126) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1401 = "llvm.ashr"(%1400, %1099) : (i64, i64) -> i64
  %1402 = "llvm.add"(%1390, %1401) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1403 = "llvm.and"(%1400, %1129) : (i64, i64) -> i64
  %1404 = "llvm.sub"(%1388, %1403) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1405 = "llvm.add"(%1392, %1126) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1406 = "llvm.ashr"(%1405, %1099) : (i64, i64) -> i64
  %1407 = "llvm.add"(%1394, %1406) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1408 = "llvm.and"(%1405, %1129) : (i64, i64) -> i64
  %1409 = "llvm.sub"(%1392, %1408) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1410 = "llvm.add"(%1382, %1126) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1411 = "llvm.ashr"(%1410, %1099) : (i64, i64) -> i64
  %1412 = "llvm.add"(%1330, %1266) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1413 = "llvm.sub"(%1412, %1307) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1414 = "llvm.add"(%1413, %1343) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1415 = "llvm.add"(%1414, %1354) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1416 = "llvm.add"(%1415, %1370) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1417 = "llvm.add"(%1416, %1411) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1418 = "llvm.and"(%1410, %1129) : (i64, i64) -> i64
  %1419 = "llvm.sub"(%1382, %1418) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1420 = "llvm.add"(%1359, %1126) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1421 = "llvm.ashr"(%1420, %1099) : (i64, i64) -> i64
  %1422 = "llvm.add"(%1275, %1332) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1423 = "llvm.sub"(%1422, %1310) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1424 = "llvm.add"(%1423, %1345) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1425 = "llvm.add"(%1424, %1421) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1426 = "llvm.and"(%1420, %1129) : (i64, i64) -> i64
  %1427 = "llvm.sub"(%1359, %1426) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1428 = "llvm.add"(%1336, %1126) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1429 = "llvm.ashr"(%1428, %1099) : (i64, i64) -> i64
  %1430 = "llvm.add"(%1429, %1315) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1431 = "llvm.and"(%1428, %1129) : (i64, i64) -> i64
  %1432 = "llvm.sub"(%1336, %1431) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1433 = "llvm.add"(%1397, %1126) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1434 = "llvm.ashr"(%1433, %1099) : (i64, i64) -> i64
  %1435 = "llvm.and"(%1433, %1129) : (i64, i64) -> i64
  %1436 = "llvm.add"(%1402, %1126) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1437 = "llvm.ashr"(%1436, %1099) : (i64, i64) -> i64
  %1438 = "llvm.and"(%1436, %1129) : (i64, i64) -> i64
  %1439 = "llvm.add"(%1407, %1126) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1440 = "llvm.ashr"(%1439, %1099) : (i64, i64) -> i64
  %1441 = "llvm.add"(%1419, %1440) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1442 = "llvm.and"(%1439, %1129) : (i64, i64) -> i64
  %1443 = "llvm.add"(%1417, %1126) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1444 = "llvm.ashr"(%1443, %1099) : (i64, i64) -> i64
  %1445 = "llvm.add"(%1427, %1444) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1446 = "llvm.and"(%1443, %1129) : (i64, i64) -> i64
  %1447 = "llvm.sub"(%1417, %1446) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1448 = "llvm.add"(%1425, %1126) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1449 = "llvm.ashr"(%1448, %1099) : (i64, i64) -> i64
  %1450 = "llvm.add"(%1432, %1449) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1451 = "llvm.and"(%1448, %1129) : (i64, i64) -> i64
  %1452 = "llvm.sub"(%1425, %1451) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1453 = "llvm.add"(%1430, %1126) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1454 = "llvm.ashr"(%1453, %1099) : (i64, i64) -> i64
  %1455 = "llvm.and"(%1453, %1129) : (i64, i64) -> i64
  %1456 = "llvm.sub"(%1430, %1455) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1457 = "llvm.mul"(%1454, %1120) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1458 = "llvm.add"(%1399, %1457) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1459 = "llvm.mul"(%1454, %1121) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1460 = "llvm.mul"(%1454, %1122) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1461 = "llvm.mul"(%1454, %1123) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1462 = "llvm.mul"(%1454, %1124) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1463 = "llvm.mul"(%1454, %1125) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1464 = "llvm.ashr"(%1458, %1099) : (i64, i64) -> i64
  %1465 = "llvm.add"(%1459, %1397) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1466 = "llvm.sub"(%1465, %1435) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1467 = "llvm.add"(%1466, %1464) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1468 = "llvm.and"(%1458, %1098) : (i64, i64) -> i64
  %1469 = "llvm.ashr"(%1467, %1099) : (i64, i64) -> i64
  %1470 = "llvm.add"(%1404, %1460) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1471 = "llvm.add"(%1470, %1434) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1472 = "llvm.add"(%1471, %1469) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1473 = "llvm.and"(%1467, %1098) : (i64, i64) -> i64
  %1474 = "llvm.ashr"(%1472, %1099) : (i64, i64) -> i64
  %1475 = "llvm.add"(%1402, %1461) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1476 = "llvm.sub"(%1475, %1438) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1477 = "llvm.add"(%1476, %1474) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1478 = "llvm.and"(%1472, %1098) : (i64, i64) -> i64
  %1479 = "llvm.ashr"(%1477, %1099) : (i64, i64) -> i64
  %1480 = "llvm.add"(%1409, %1462) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1481 = "llvm.add"(%1480, %1437) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1482 = "llvm.add"(%1481, %1479) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1483 = "llvm.and"(%1477, %1098) : (i64, i64) -> i64
  %1484 = "llvm.ashr"(%1482, %1099) : (i64, i64) -> i64
  %1485 = "llvm.add"(%1407, %1463) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1486 = "llvm.sub"(%1485, %1442) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1487 = "llvm.add"(%1486, %1484) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1488 = "llvm.and"(%1482, %1098) : (i64, i64) -> i64
  %1489 = "llvm.ashr"(%1487, %1099) : (i64, i64) -> i64
  %1490 = "llvm.add"(%1441, %1489) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1491 = "llvm.and"(%1487, %1098) : (i64, i64) -> i64
  %1492 = "llvm.ashr"(%1490, %1099) : (i64, i64) -> i64
  %1493 = "llvm.add"(%1492, %1447) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1494 = "llvm.and"(%1490, %1098) : (i64, i64) -> i64
  %1495 = "llvm.ashr"(%1493, %1099) : (i64, i64) -> i64
  %1496 = "llvm.add"(%1445, %1495) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1497 = "llvm.and"(%1493, %1098) : (i64, i64) -> i64
  %1498 = "llvm.ashr"(%1496, %1099) : (i64, i64) -> i64
  %1499 = "llvm.add"(%1498, %1452) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1500 = "llvm.and"(%1496, %1098) : (i64, i64) -> i64
  %1501 = "llvm.ashr"(%1499, %1099) : (i64, i64) -> i64
  %1502 = "llvm.add"(%1450, %1501) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1503 = "llvm.and"(%1499, %1098) : (i64, i64) -> i64
  %1504 = "llvm.ashr"(%1502, %1099) : (i64, i64) -> i64
  %1505 = "llvm.add"(%1504, %1456) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1506 = "llvm.and"(%1502, %1098) : (i64, i64) -> i64
  %1507 = "llvm.ashr"(%1505, %1099) : (i64, i64) -> i64
  %1508 = "llvm.and"(%1505, %1098) : (i64, i64) -> i64
  %1509 = "llvm.mul"(%1507, %1120) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1510 = "llvm.add"(%1509, %1468) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1511 = "llvm.mul"(%1507, %1121) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1512 = "llvm.add"(%1511, %1473) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1513 = "llvm.mul"(%1507, %1122) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1514 = "llvm.add"(%1513, %1478) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1515 = "llvm.mul"(%1507, %1123) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1516 = "llvm.add"(%1515, %1483) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1517 = "llvm.mul"(%1507, %1124) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1518 = "llvm.add"(%1517, %1488) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1519 = "llvm.mul"(%1507, %1125) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1520 = "llvm.add"(%1519, %1491) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1521 = "llvm.ashr"(%1510, %1099) : (i64, i64) -> i64
  %1522 = "llvm.add"(%1512, %1521) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1523 = "llvm.and"(%1510, %1098) : (i64, i64) -> i64
  %1524 = "llvm.ashr"(%1522, %1099) : (i64, i64) -> i64
  %1525 = "llvm.add"(%1514, %1524) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1526 = "llvm.ashr"(%1525, %1099) : (i64, i64) -> i64
  %1527 = "llvm.add"(%1516, %1526) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1528 = "llvm.ashr"(%1527, %1099) : (i64, i64) -> i64
  %1529 = "llvm.add"(%1518, %1528) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1530 = "llvm.ashr"(%1529, %1099) : (i64, i64) -> i64
  %1531 = "llvm.add"(%1520, %1530) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1532 = "llvm.ashr"(%1531, %1099) : (i64, i64) -> i64
  %1533 = "llvm.add"(%1532, %1494) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1534 = "llvm.ashr"(%1533, %1099) : (i64, i64) -> i64
  %1535 = "llvm.add"(%1534, %1497) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1536 = "llvm.ashr"(%1535, %1099) : (i64, i64) -> i64
  %1537 = "llvm.add"(%1536, %1500) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1538 = "llvm.ashr"(%1537, %1099) : (i64, i64) -> i64
  %1539 = "llvm.add"(%1538, %1503) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1540 = "llvm.ashr"(%1539, %1099) : (i64, i64) -> i64
  %1541 = "llvm.add"(%1540, %1506) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1542 = "llvm.lshr"(%1541, %1099) : (i64, i64) -> i64
  %1543 = "llvm.add"(%1542, %1508) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1544 = "llvm.shl"(%1522, %1099) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1545 = "llvm.and"(%1544, %1130) : (i64, i64) -> i64
  %1546 = "llvm.or"(%1545, %1523) <{isDisjoint}> : (i64, i64) -> i64
  %1547 = "llvm.shl"(%1525, %1100) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1548 = "llvm.and"(%1547, %1131) : (i64, i64) -> i64
  %1549 = "llvm.or"(%1546, %1548) <{isDisjoint}> : (i64, i64) -> i64
  %1550 = "llvm.shl"(%1527, %1132) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1551 = "llvm.or"(%1549, %1550) <{isDisjoint}> : (i64, i64) -> i64
  "llvm.store"(%1551, %arg71) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  %1552 = "llvm.lshr"(%1527, %1101) : (i64, i64) -> i64
  %1553 = "llvm.and"(%1552, %1133) : (i64, i64) -> i64
  %1554 = "llvm.shl"(%1529, %1102) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1555 = "llvm.and"(%1554, %1134) : (i64, i64) -> i64
  %1556 = "llvm.or"(%1555, %1553) <{isDisjoint}> : (i64, i64) -> i64
  %1557 = "llvm.shl"(%1531, %1103) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1558 = "llvm.and"(%1557, %1135) : (i64, i64) -> i64
  %1559 = "llvm.or"(%1556, %1558) <{isDisjoint}> : (i64, i64) -> i64
  %1560 = "llvm.shl"(%1533, %1136) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1561 = "llvm.or"(%1559, %1560) <{isDisjoint}> : (i64, i64) -> i64
  %1562 = "llvm.getelementptr"(%arg71) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1561, %1562) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  %1563 = "llvm.lshr"(%1533, %1104) : (i64, i64) -> i64
  %1564 = "llvm.and"(%1563, %1137) : (i64, i64) -> i64
  %1565 = "llvm.shl"(%1535, %1105) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1566 = "llvm.and"(%1565, %1138) : (i64, i64) -> i64
  %1567 = "llvm.or"(%1566, %1564) <{isDisjoint}> : (i64, i64) -> i64
  %1568 = "llvm.shl"(%1537, %1097) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1569 = "llvm.and"(%1568, %1139) : (i64, i64) -> i64
  %1570 = "llvm.or"(%1567, %1569) <{isDisjoint}> : (i64, i64) -> i64
  %1571 = "llvm.shl"(%1539, %1140) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1572 = "llvm.or"(%1570, %1571) <{isDisjoint}> : (i64, i64) -> i64
  %1573 = "llvm.getelementptr"(%arg71) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1572, %1573) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  %1574 = "llvm.lshr"(%1539, %1106) : (i64, i64) -> i64
  %1575 = "llvm.and"(%1574, %1141) : (i64, i64) -> i64
  %1576 = "llvm.shl"(%1541, %1107) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1577 = "llvm.and"(%1576, %1142) : (i64, i64) -> i64
  %1578 = "llvm.or"(%1575, %1577) <{isDisjoint}> : (i64, i64) -> i64
  %1579 = "llvm.shl"(%1543, %1108) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1580 = "llvm.or"(%1578, %1579) <{isDisjoint}> : (i64, i64) -> i64
  %1581 = "llvm.getelementptr"(%arg71) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1580, %1581) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  "llvm.return"(%arg71) : (!llvm.ptr) -> ()
}) : () -> ()
  with @fd_ulong_load_8 := fd_ulong_load_8

end

end MLIR.Firedancer.Ref
