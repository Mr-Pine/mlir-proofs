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
"llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nofree, llvm.noundef, llvm.returned, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<ptr (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], res_attrs = [{llvm.noundef}], sym_name = "fd_curve25519_scalar_reduce", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg74: !llvm.ptr, %arg75: !llvm.ptr):
  %1103 = "llvm.mlir.constant"() <{value = 16 : i64}> : () -> i64
  %1104 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
  %1105 = "llvm.mlir.constant"() <{value = 2097151 : i64}> : () -> i64
  %1106 = "llvm.mlir.constant"() <{value = 21 : i64}> : () -> i64
  %1107 = "llvm.mlir.constant"() <{value = 42 : i64}> : () -> i64
  %1108 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %1109 = "llvm.mlir.constant"() <{value = 20 : i64}> : () -> i64
  %1110 = "llvm.mlir.constant"() <{value = 41 : i64}> : () -> i64
  %1111 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %1112 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %1113 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %1114 = "llvm.mlir.constant"() <{value = 18 : i64}> : () -> i64
  %1115 = "llvm.mlir.constant"() <{value = 39 : i64}> : () -> i64
  %1116 = "llvm.mlir.constant"() <{value = 4 : i64}> : () -> i64
  %1117 = "llvm.mlir.constant"() <{value = 17 : i64}> : () -> i64
  %1118 = "llvm.mlir.constant"() <{value = 38 : i64}> : () -> i64
  %1119 = "llvm.mlir.constant"() <{value = 5 : i64}> : () -> i64
  %1120 = "llvm.mlir.constant"() <{value = 37 : i64}> : () -> i64
  %1121 = "llvm.mlir.constant"() <{value = 6 : i64}> : () -> i64
  %1122 = "llvm.mlir.constant"() <{value = 15 : i64}> : () -> i64
  %1123 = "llvm.mlir.constant"() <{value = 36 : i64}> : () -> i64
  %1124 = "llvm.mlir.constant"() <{value = 7 : i64}> : () -> i64
  %1125 = "llvm.mlir.constant"() <{value = 14 : i64}> : () -> i64
  %1126 = "llvm.mlir.constant"() <{value = 35 : i64}> : () -> i64
  %1127 = "llvm.mlir.constant"() <{value = 666643 : i64}> : () -> i64
  %1128 = "llvm.mlir.constant"() <{value = 470296 : i64}> : () -> i64
  %1129 = "llvm.mlir.constant"() <{value = 654183 : i64}> : () -> i64
  %1130 = "llvm.mlir.constant"() <{value = -997805 : i64}> : () -> i64
  %1131 = "llvm.mlir.constant"() <{value = 136657 : i64}> : () -> i64
  %1132 = "llvm.mlir.constant"() <{value = -683901 : i64}> : () -> i64
  %1133 = "llvm.mlir.constant"() <{value = 1048576 : i64}> : () -> i64
  %1134 = "llvm.mlir.constant"() <{value = 8796090925056 : i64}> : () -> i64
  %1135 = "llvm.mlir.constant"() <{value = 9223372036852678656 : i64}> : () -> i64
  %1136 = "llvm.mlir.constant"() <{value = -2097152 : i64}> : () -> i64
  %1137 = "llvm.mlir.constant"() <{value = 4398044413952 : i64}> : () -> i64
  %1138 = "llvm.mlir.constant"() <{value = 9223367638808264704 : i64}> : () -> i64
  %1139 = "llvm.mlir.constant"() <{value = 63 : i64}> : () -> i64
  %1140 = "llvm.mlir.constant"() <{value = 1048575 : i64}> : () -> i64
  %1141 = "llvm.mlir.constant"() <{value = 2199022206976 : i64}> : () -> i64
  %1142 = "llvm.mlir.constant"() <{value = 4611683819404132352 : i64}> : () -> i64
  %1143 = "llvm.mlir.constant"() <{value = 62 : i64}> : () -> i64
  %1144 = "llvm.mlir.constant"() <{value = 524287 : i64}> : () -> i64
  %1145 = "llvm.mlir.constant"() <{value = 1099511103488 : i64}> : () -> i64
  %1146 = "llvm.mlir.constant"() <{value = 2305841909702066176 : i64}> : () -> i64
  %1147 = "llvm.mlir.constant"() <{value = 61 : i64}> : () -> i64
  %1148 = "llvm.mlir.constant"() <{value = 262143 : i64}> : () -> i64
  %1149 = "llvm.mlir.constant"() <{value = 549755551744 : i64}> : () -> i64
  %1150 = "llvm.call"(%arg75) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_ulong_load_8, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i64
  %1151 = "llvm.getelementptr"(%arg75) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %1152 = "llvm.call"(%1151) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @fd_ulong_load_8, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i64
  %1153 = "llvm.getelementptr"(%arg75) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %1154 = "llvm.call"(%1153) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @fd_ulong_load_8, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i64
  %1155 = "llvm.getelementptr"(%arg75) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %1156 = "llvm.call"(%1155) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @fd_ulong_load_8, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i64
  %1157 = "llvm.getelementptr"(%arg75) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %1158 = "llvm.call"(%1157) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @fd_ulong_load_8, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i64
  %1159 = "llvm.getelementptr"(%arg75) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  %1160 = "llvm.call"(%1159) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @fd_ulong_load_8, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i64
  %1161 = "llvm.getelementptr"(%arg75) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 48>}> : (!llvm.ptr) -> !llvm.ptr
  %1162 = "llvm.call"(%1161) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @fd_ulong_load_8, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i64
  %1163 = "llvm.getelementptr"(%arg75) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 56>}> : (!llvm.ptr) -> !llvm.ptr
  %1164 = "llvm.call"(%1163) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @fd_ulong_load_8, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i64
  %1165 = "llvm.and"(%1150, %1105) : (i64, i64) -> i64
  %1166 = "llvm.lshr"(%1150, %1106) : (i64, i64) -> i64
  %1167 = "llvm.and"(%1166, %1105) : (i64, i64) -> i64
  %1168 = "llvm.lshr"(%1150, %1107) : (i64, i64) -> i64
  %1169 = "llvm.and"(%1168, %1105) : (i64, i64) -> i64
  %1170 = "llvm.intr.fshl"(%1152, %1150, %1108) : (i64, i64, i64) -> i64
  %1171 = "llvm.and"(%1170, %1105) : (i64, i64) -> i64
  %1172 = "llvm.lshr"(%1152, %1109) : (i64, i64) -> i64
  %1173 = "llvm.and"(%1172, %1105) : (i64, i64) -> i64
  %1174 = "llvm.lshr"(%1152, %1110) : (i64, i64) -> i64
  %1175 = "llvm.and"(%1174, %1105) : (i64, i64) -> i64
  %1176 = "llvm.intr.fshl"(%1154, %1152, %1111) : (i64, i64, i64) -> i64
  %1177 = "llvm.and"(%1176, %1105) : (i64, i64) -> i64
  %1178 = "llvm.lshr"(%1154, %1112) : (i64, i64) -> i64
  %1179 = "llvm.and"(%1178, %1105) : (i64, i64) -> i64
  %1180 = "llvm.lshr"(%1154, %1104) : (i64, i64) -> i64
  %1181 = "llvm.and"(%1180, %1105) : (i64, i64) -> i64
  %1182 = "llvm.intr.fshl"(%1156, %1154, %1113) : (i64, i64, i64) -> i64
  %1183 = "llvm.and"(%1182, %1105) : (i64, i64) -> i64
  %1184 = "llvm.lshr"(%1156, %1114) : (i64, i64) -> i64
  %1185 = "llvm.and"(%1184, %1105) : (i64, i64) -> i64
  %1186 = "llvm.lshr"(%1156, %1115) : (i64, i64) -> i64
  %1187 = "llvm.and"(%1186, %1105) : (i64, i64) -> i64
  %1188 = "llvm.intr.fshl"(%1158, %1156, %1116) : (i64, i64, i64) -> i64
  %1189 = "llvm.and"(%1188, %1105) : (i64, i64) -> i64
  %1190 = "llvm.lshr"(%1158, %1117) : (i64, i64) -> i64
  %1191 = "llvm.and"(%1190, %1105) : (i64, i64) -> i64
  %1192 = "llvm.lshr"(%1158, %1118) : (i64, i64) -> i64
  %1193 = "llvm.and"(%1192, %1105) : (i64, i64) -> i64
  %1194 = "llvm.intr.fshl"(%1160, %1158, %1119) : (i64, i64, i64) -> i64
  %1195 = "llvm.and"(%1194, %1105) : (i64, i64) -> i64
  %1196 = "llvm.lshr"(%1160, %1103) : (i64, i64) -> i64
  %1197 = "llvm.and"(%1196, %1105) : (i64, i64) -> i64
  %1198 = "llvm.lshr"(%1160, %1120) : (i64, i64) -> i64
  %1199 = "llvm.and"(%1198, %1105) : (i64, i64) -> i64
  %1200 = "llvm.intr.fshl"(%1162, %1160, %1121) : (i64, i64, i64) -> i64
  %1201 = "llvm.and"(%1200, %1105) : (i64, i64) -> i64
  %1202 = "llvm.lshr"(%1162, %1122) : (i64, i64) -> i64
  %1203 = "llvm.and"(%1202, %1105) : (i64, i64) -> i64
  %1204 = "llvm.lshr"(%1162, %1123) : (i64, i64) -> i64
  %1205 = "llvm.and"(%1204, %1105) : (i64, i64) -> i64
  %1206 = "llvm.intr.fshl"(%1164, %1162, %1124) : (i64, i64, i64) -> i64
  %1207 = "llvm.and"(%1206, %1105) : (i64, i64) -> i64
  %1208 = "llvm.lshr"(%1164, %1125) : (i64, i64) -> i64
  %1209 = "llvm.and"(%1208, %1105) : (i64, i64) -> i64
  %1210 = "llvm.lshr"(%1164, %1126) : (i64, i64) -> i64
  %1211 = "llvm.mul"(%1210, %1127) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1212 = "llvm.add"(%1211, %1187) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1213 = "llvm.mul"(%1210, %1128) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1214 = "llvm.add"(%1213, %1189) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1215 = "llvm.mul"(%1210, %1129) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1216 = "llvm.add"(%1215, %1191) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1217 = "llvm.mul"(%1210, %1130) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1218 = "llvm.add"(%1217, %1193) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1219 = "llvm.mul"(%1210, %1131) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1220 = "llvm.add"(%1219, %1195) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1221 = "llvm.mul"(%1210, %1132) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1222 = "llvm.add"(%1221, %1197) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1223 = "llvm.mul"(%1209, %1127) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1224 = "llvm.mul"(%1209, %1128) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1225 = "llvm.mul"(%1209, %1129) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1226 = "llvm.mul"(%1209, %1130) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1227 = "llvm.mul"(%1209, %1131) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1228 = "llvm.add"(%1218, %1227) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1229 = "llvm.mul"(%1209, %1132) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1230 = "llvm.add"(%1220, %1229) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1231 = "llvm.mul"(%1207, %1127) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1232 = "llvm.mul"(%1207, %1128) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1233 = "llvm.mul"(%1207, %1129) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1234 = "llvm.mul"(%1207, %1130) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1235 = "llvm.mul"(%1207, %1131) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1236 = "llvm.mul"(%1207, %1132) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1237 = "llvm.add"(%1228, %1236) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1238 = "llvm.mul"(%1205, %1127) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1239 = "llvm.add"(%1238, %1181) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1240 = "llvm.mul"(%1205, %1128) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1241 = "llvm.mul"(%1205, %1129) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1242 = "llvm.mul"(%1205, %1130) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1243 = "llvm.mul"(%1205, %1131) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1244 = "llvm.mul"(%1205, %1132) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1245 = "llvm.mul"(%1203, %1127) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1246 = "llvm.add"(%1245, %1179) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1247 = "llvm.mul"(%1203, %1128) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1248 = "llvm.add"(%1239, %1247) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1249 = "llvm.mul"(%1203, %1129) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1250 = "llvm.mul"(%1203, %1130) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1251 = "llvm.mul"(%1203, %1131) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1252 = "llvm.mul"(%1203, %1132) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1253 = "llvm.add"(%1214, %1243) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1254 = "llvm.add"(%1253, %1252) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1255 = "llvm.add"(%1254, %1225) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1256 = "llvm.add"(%1255, %1234) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1257 = "llvm.mul"(%1201, %1127) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1258 = "llvm.add"(%1257, %1177) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1259 = "llvm.mul"(%1201, %1128) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1260 = "llvm.add"(%1246, %1259) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1261 = "llvm.mul"(%1201, %1129) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1262 = "llvm.add"(%1248, %1261) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1263 = "llvm.mul"(%1201, %1130) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1264 = "llvm.mul"(%1201, %1131) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1265 = "llvm.add"(%1241, %1185) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1266 = "llvm.add"(%1265, %1250) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1267 = "llvm.add"(%1266, %1264) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1268 = "llvm.add"(%1267, %1223) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1269 = "llvm.add"(%1268, %1232) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1270 = "llvm.mul"(%1201, %1132) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1271 = "llvm.add"(%1258, %1133) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1272 = "llvm.lshr"(%1271, %1106) : (i64, i64) -> i64
  %1273 = "llvm.add"(%1260, %1272) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1274 = "llvm.and"(%1271, %1134) : (i64, i64) -> i64
  %1275 = "llvm.sub"(%1258, %1274) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1276 = "llvm.add"(%1262, %1133) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1277 = "llvm.lshr"(%1276, %1106) : (i64, i64) -> i64
  %1278 = "llvm.add"(%1240, %1183) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1279 = "llvm.add"(%1278, %1249) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1280 = "llvm.add"(%1279, %1263) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1281 = "llvm.add"(%1280, %1231) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1282 = "llvm.add"(%1281, %1277) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1283 = "llvm.and"(%1276, %1135) : (i64, i64) -> i64
  %1284 = "llvm.sub"(%1262, %1283) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1285 = "llvm.add"(%1269, %1133) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1286 = "llvm.ashr"(%1285, %1106) : (i64, i64) -> i64
  %1287 = "llvm.add"(%1212, %1242) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1288 = "llvm.add"(%1287, %1251) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1289 = "llvm.add"(%1288, %1270) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1290 = "llvm.add"(%1289, %1224) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1291 = "llvm.add"(%1290, %1233) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1292 = "llvm.add"(%1291, %1286) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1293 = "llvm.and"(%1285, %1136) : (i64, i64) -> i64
  %1294 = "llvm.add"(%1256, %1133) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1295 = "llvm.ashr"(%1294, %1106) : (i64, i64) -> i64
  %1296 = "llvm.add"(%1216, %1244) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1297 = "llvm.add"(%1296, %1226) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1298 = "llvm.add"(%1297, %1235) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1299 = "llvm.add"(%1298, %1295) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1300 = "llvm.and"(%1294, %1136) : (i64, i64) -> i64
  %1301 = "llvm.sub"(%1256, %1300) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1302 = "llvm.add"(%1237, %1133) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1303 = "llvm.ashr"(%1302, %1106) : (i64, i64) -> i64
  %1304 = "llvm.add"(%1230, %1303) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1305 = "llvm.and"(%1302, %1136) : (i64, i64) -> i64
  %1306 = "llvm.sub"(%1237, %1305) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1307 = "llvm.add"(%1222, %1133) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1308 = "llvm.ashr"(%1307, %1106) : (i64, i64) -> i64
  %1309 = "llvm.add"(%1308, %1199) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1310 = "llvm.and"(%1307, %1136) : (i64, i64) -> i64
  %1311 = "llvm.sub"(%1222, %1310) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1312 = "llvm.add"(%1273, %1133) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1313 = "llvm.lshr"(%1312, %1106) : (i64, i64) -> i64
  %1314 = "llvm.and"(%1312, %1135) : (i64, i64) -> i64
  %1315 = "llvm.add"(%1282, %1133) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1316 = "llvm.ashr"(%1315, %1106) : (i64, i64) -> i64
  %1317 = "llvm.and"(%1315, %1136) : (i64, i64) -> i64
  %1318 = "llvm.add"(%1292, %1133) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1319 = "llvm.ashr"(%1318, %1106) : (i64, i64) -> i64
  %1320 = "llvm.add"(%1319, %1301) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1321 = "llvm.and"(%1318, %1136) : (i64, i64) -> i64
  %1322 = "llvm.sub"(%1292, %1321) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1323 = "llvm.add"(%1299, %1133) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1324 = "llvm.ashr"(%1323, %1106) : (i64, i64) -> i64
  %1325 = "llvm.add"(%1324, %1306) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1326 = "llvm.and"(%1323, %1136) : (i64, i64) -> i64
  %1327 = "llvm.sub"(%1299, %1326) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1328 = "llvm.add"(%1304, %1133) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1329 = "llvm.ashr"(%1328, %1106) : (i64, i64) -> i64
  %1330 = "llvm.add"(%1329, %1311) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1331 = "llvm.and"(%1328, %1136) : (i64, i64) -> i64
  %1332 = "llvm.sub"(%1304, %1331) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1333 = "llvm.mul"(%1309, %1127) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1334 = "llvm.add"(%1333, %1175) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1335 = "llvm.mul"(%1309, %1128) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1336 = "llvm.add"(%1275, %1335) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1337 = "llvm.mul"(%1309, %1129) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1338 = "llvm.mul"(%1309, %1130) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1339 = "llvm.mul"(%1309, %1131) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1340 = "llvm.mul"(%1309, %1132) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1341 = "llvm.add"(%1269, %1340) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1342 = "llvm.sub"(%1341, %1293) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1343 = "llvm.add"(%1342, %1316) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1344 = "llvm.mul"(%1330, %1127) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1345 = "llvm.add"(%1344, %1173) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1346 = "llvm.mul"(%1330, %1128) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1347 = "llvm.add"(%1334, %1346) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1348 = "llvm.mul"(%1330, %1129) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1349 = "llvm.add"(%1336, %1348) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1350 = "llvm.mul"(%1330, %1130) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1351 = "llvm.mul"(%1330, %1131) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1352 = "llvm.mul"(%1330, %1132) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1353 = "llvm.mul"(%1332, %1127) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1354 = "llvm.add"(%1353, %1171) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1355 = "llvm.mul"(%1332, %1128) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1356 = "llvm.add"(%1345, %1355) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1357 = "llvm.mul"(%1332, %1129) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1358 = "llvm.add"(%1347, %1357) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1359 = "llvm.mul"(%1332, %1130) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1360 = "llvm.add"(%1349, %1359) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1361 = "llvm.mul"(%1332, %1131) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1362 = "llvm.mul"(%1332, %1132) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1363 = "llvm.add"(%1284, %1338) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1364 = "llvm.add"(%1363, %1313) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1365 = "llvm.add"(%1364, %1351) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1366 = "llvm.add"(%1365, %1362) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1367 = "llvm.mul"(%1325, %1127) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1368 = "llvm.add"(%1367, %1169) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1369 = "llvm.mul"(%1325, %1128) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1370 = "llvm.add"(%1354, %1369) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1371 = "llvm.mul"(%1325, %1129) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1372 = "llvm.add"(%1356, %1371) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1373 = "llvm.mul"(%1325, %1130) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1374 = "llvm.add"(%1358, %1373) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1375 = "llvm.mul"(%1325, %1131) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1376 = "llvm.add"(%1360, %1375) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1377 = "llvm.mul"(%1325, %1132) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1378 = "llvm.mul"(%1327, %1127) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1379 = "llvm.add"(%1378, %1167) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1380 = "llvm.mul"(%1327, %1128) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1381 = "llvm.add"(%1368, %1380) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1382 = "llvm.mul"(%1327, %1129) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1383 = "llvm.add"(%1370, %1382) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1384 = "llvm.mul"(%1327, %1130) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1385 = "llvm.add"(%1372, %1384) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1386 = "llvm.mul"(%1327, %1131) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1387 = "llvm.add"(%1374, %1386) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1388 = "llvm.mul"(%1327, %1132) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1389 = "llvm.add"(%1376, %1388) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1390 = "llvm.mul"(%1320, %1127) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1391 = "llvm.add"(%1390, %1165) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1392 = "llvm.mul"(%1320, %1128) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1393 = "llvm.add"(%1379, %1392) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1394 = "llvm.mul"(%1320, %1129) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1395 = "llvm.add"(%1381, %1394) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1396 = "llvm.mul"(%1320, %1130) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1397 = "llvm.add"(%1383, %1396) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1398 = "llvm.mul"(%1320, %1131) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1399 = "llvm.add"(%1385, %1398) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1400 = "llvm.mul"(%1320, %1132) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1401 = "llvm.add"(%1387, %1400) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1402 = "llvm.add"(%1391, %1133) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1403 = "llvm.ashr"(%1402, %1106) : (i64, i64) -> i64
  %1404 = "llvm.add"(%1393, %1403) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1405 = "llvm.and"(%1402, %1136) : (i64, i64) -> i64
  %1406 = "llvm.sub"(%1391, %1405) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1407 = "llvm.add"(%1395, %1133) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1408 = "llvm.ashr"(%1407, %1106) : (i64, i64) -> i64
  %1409 = "llvm.add"(%1397, %1408) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1410 = "llvm.and"(%1407, %1136) : (i64, i64) -> i64
  %1411 = "llvm.sub"(%1395, %1410) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1412 = "llvm.add"(%1399, %1133) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1413 = "llvm.ashr"(%1412, %1106) : (i64, i64) -> i64
  %1414 = "llvm.add"(%1401, %1413) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1415 = "llvm.and"(%1412, %1136) : (i64, i64) -> i64
  %1416 = "llvm.sub"(%1399, %1415) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1417 = "llvm.add"(%1389, %1133) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1418 = "llvm.ashr"(%1417, %1106) : (i64, i64) -> i64
  %1419 = "llvm.add"(%1337, %1273) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1420 = "llvm.sub"(%1419, %1314) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1421 = "llvm.add"(%1420, %1350) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1422 = "llvm.add"(%1421, %1361) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1423 = "llvm.add"(%1422, %1377) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1424 = "llvm.add"(%1423, %1418) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1425 = "llvm.and"(%1417, %1136) : (i64, i64) -> i64
  %1426 = "llvm.sub"(%1389, %1425) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1427 = "llvm.add"(%1366, %1133) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1428 = "llvm.ashr"(%1427, %1106) : (i64, i64) -> i64
  %1429 = "llvm.add"(%1282, %1339) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1430 = "llvm.sub"(%1429, %1317) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1431 = "llvm.add"(%1430, %1352) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1432 = "llvm.add"(%1431, %1428) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1433 = "llvm.and"(%1427, %1136) : (i64, i64) -> i64
  %1434 = "llvm.sub"(%1366, %1433) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1435 = "llvm.add"(%1343, %1133) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1436 = "llvm.ashr"(%1435, %1106) : (i64, i64) -> i64
  %1437 = "llvm.add"(%1436, %1322) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1438 = "llvm.and"(%1435, %1136) : (i64, i64) -> i64
  %1439 = "llvm.sub"(%1343, %1438) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1440 = "llvm.add"(%1404, %1133) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1441 = "llvm.ashr"(%1440, %1106) : (i64, i64) -> i64
  %1442 = "llvm.and"(%1440, %1136) : (i64, i64) -> i64
  %1443 = "llvm.add"(%1409, %1133) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1444 = "llvm.ashr"(%1443, %1106) : (i64, i64) -> i64
  %1445 = "llvm.and"(%1443, %1136) : (i64, i64) -> i64
  %1446 = "llvm.add"(%1414, %1133) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1447 = "llvm.ashr"(%1446, %1106) : (i64, i64) -> i64
  %1448 = "llvm.add"(%1426, %1447) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1449 = "llvm.and"(%1446, %1136) : (i64, i64) -> i64
  %1450 = "llvm.add"(%1424, %1133) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1451 = "llvm.ashr"(%1450, %1106) : (i64, i64) -> i64
  %1452 = "llvm.add"(%1434, %1451) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1453 = "llvm.and"(%1450, %1136) : (i64, i64) -> i64
  %1454 = "llvm.sub"(%1424, %1453) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1455 = "llvm.add"(%1432, %1133) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1456 = "llvm.ashr"(%1455, %1106) : (i64, i64) -> i64
  %1457 = "llvm.add"(%1439, %1456) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1458 = "llvm.and"(%1455, %1136) : (i64, i64) -> i64
  %1459 = "llvm.sub"(%1432, %1458) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1460 = "llvm.add"(%1437, %1133) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1461 = "llvm.ashr"(%1460, %1106) : (i64, i64) -> i64
  %1462 = "llvm.and"(%1460, %1136) : (i64, i64) -> i64
  %1463 = "llvm.sub"(%1437, %1462) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1464 = "llvm.mul"(%1461, %1127) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1465 = "llvm.add"(%1406, %1464) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1466 = "llvm.mul"(%1461, %1128) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1467 = "llvm.mul"(%1461, %1129) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1468 = "llvm.mul"(%1461, %1130) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1469 = "llvm.mul"(%1461, %1131) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1470 = "llvm.mul"(%1461, %1132) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1471 = "llvm.ashr"(%1465, %1106) : (i64, i64) -> i64
  %1472 = "llvm.add"(%1466, %1404) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1473 = "llvm.sub"(%1472, %1442) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1474 = "llvm.add"(%1473, %1471) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1475 = "llvm.and"(%1465, %1105) : (i64, i64) -> i64
  %1476 = "llvm.ashr"(%1474, %1106) : (i64, i64) -> i64
  %1477 = "llvm.add"(%1411, %1467) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1478 = "llvm.add"(%1477, %1441) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1479 = "llvm.add"(%1478, %1476) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1480 = "llvm.and"(%1474, %1105) : (i64, i64) -> i64
  %1481 = "llvm.ashr"(%1479, %1106) : (i64, i64) -> i64
  %1482 = "llvm.add"(%1409, %1468) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1483 = "llvm.sub"(%1482, %1445) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1484 = "llvm.add"(%1483, %1481) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1485 = "llvm.and"(%1479, %1105) : (i64, i64) -> i64
  %1486 = "llvm.ashr"(%1484, %1106) : (i64, i64) -> i64
  %1487 = "llvm.add"(%1416, %1469) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1488 = "llvm.add"(%1487, %1444) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1489 = "llvm.add"(%1488, %1486) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1490 = "llvm.and"(%1484, %1105) : (i64, i64) -> i64
  %1491 = "llvm.ashr"(%1489, %1106) : (i64, i64) -> i64
  %1492 = "llvm.add"(%1414, %1470) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1493 = "llvm.sub"(%1492, %1449) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1494 = "llvm.add"(%1493, %1491) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1495 = "llvm.and"(%1489, %1105) : (i64, i64) -> i64
  %1496 = "llvm.ashr"(%1494, %1106) : (i64, i64) -> i64
  %1497 = "llvm.add"(%1448, %1496) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1498 = "llvm.and"(%1494, %1105) : (i64, i64) -> i64
  %1499 = "llvm.ashr"(%1497, %1106) : (i64, i64) -> i64
  %1500 = "llvm.add"(%1499, %1454) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1501 = "llvm.and"(%1497, %1105) : (i64, i64) -> i64
  %1502 = "llvm.ashr"(%1500, %1106) : (i64, i64) -> i64
  %1503 = "llvm.add"(%1452, %1502) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1504 = "llvm.and"(%1500, %1105) : (i64, i64) -> i64
  %1505 = "llvm.ashr"(%1503, %1106) : (i64, i64) -> i64
  %1506 = "llvm.add"(%1505, %1459) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1507 = "llvm.and"(%1503, %1105) : (i64, i64) -> i64
  %1508 = "llvm.ashr"(%1506, %1106) : (i64, i64) -> i64
  %1509 = "llvm.add"(%1457, %1508) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1510 = "llvm.and"(%1506, %1105) : (i64, i64) -> i64
  %1511 = "llvm.ashr"(%1509, %1106) : (i64, i64) -> i64
  %1512 = "llvm.add"(%1511, %1463) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1513 = "llvm.and"(%1509, %1105) : (i64, i64) -> i64
  %1514 = "llvm.ashr"(%1512, %1106) : (i64, i64) -> i64
  %1515 = "llvm.and"(%1512, %1105) : (i64, i64) -> i64
  %1516 = "llvm.mul"(%1514, %1127) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1517 = "llvm.add"(%1516, %1475) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1518 = "llvm.mul"(%1514, %1128) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1519 = "llvm.add"(%1518, %1480) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1520 = "llvm.mul"(%1514, %1129) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1521 = "llvm.add"(%1520, %1485) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1522 = "llvm.mul"(%1514, %1130) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1523 = "llvm.add"(%1522, %1490) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1524 = "llvm.mul"(%1514, %1131) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1525 = "llvm.add"(%1524, %1495) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1526 = "llvm.mul"(%1514, %1132) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1527 = "llvm.add"(%1526, %1498) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1528 = "llvm.ashr"(%1517, %1106) : (i64, i64) -> i64
  %1529 = "llvm.add"(%1519, %1528) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1530 = "llvm.and"(%1517, %1105) : (i64, i64) -> i64
  %1531 = "llvm.ashr"(%1529, %1106) : (i64, i64) -> i64
  %1532 = "llvm.add"(%1521, %1531) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1533 = "llvm.ashr"(%1532, %1106) : (i64, i64) -> i64
  %1534 = "llvm.add"(%1523, %1533) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1535 = "llvm.ashr"(%1534, %1106) : (i64, i64) -> i64
  %1536 = "llvm.add"(%1525, %1535) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1537 = "llvm.ashr"(%1536, %1106) : (i64, i64) -> i64
  %1538 = "llvm.add"(%1527, %1537) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1539 = "llvm.ashr"(%1538, %1106) : (i64, i64) -> i64
  %1540 = "llvm.add"(%1539, %1501) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1541 = "llvm.ashr"(%1540, %1106) : (i64, i64) -> i64
  %1542 = "llvm.add"(%1541, %1504) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1543 = "llvm.ashr"(%1542, %1106) : (i64, i64) -> i64
  %1544 = "llvm.add"(%1543, %1507) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1545 = "llvm.ashr"(%1544, %1106) : (i64, i64) -> i64
  %1546 = "llvm.add"(%1545, %1510) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1547 = "llvm.ashr"(%1546, %1106) : (i64, i64) -> i64
  %1548 = "llvm.add"(%1547, %1513) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1549 = "llvm.lshr"(%1548, %1106) : (i64, i64) -> i64
  %1550 = "llvm.add"(%1549, %1515) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1551 = "llvm.shl"(%1529, %1106) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1552 = "llvm.and"(%1551, %1137) : (i64, i64) -> i64
  %1553 = "llvm.or"(%1552, %1530) <{isDisjoint}> : (i64, i64) -> i64
  %1554 = "llvm.shl"(%1532, %1107) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1555 = "llvm.and"(%1554, %1138) : (i64, i64) -> i64
  %1556 = "llvm.or"(%1553, %1555) <{isDisjoint}> : (i64, i64) -> i64
  %1557 = "llvm.shl"(%1534, %1139) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1558 = "llvm.or"(%1556, %1557) <{isDisjoint}> : (i64, i64) -> i64
  "llvm.store"(%1558, %arg74) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1559 = "llvm.lshr"(%1534, %1108) : (i64, i64) -> i64
  %1560 = "llvm.and"(%1559, %1140) : (i64, i64) -> i64
  %1561 = "llvm.shl"(%1536, %1109) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1562 = "llvm.and"(%1561, %1141) : (i64, i64) -> i64
  %1563 = "llvm.or"(%1562, %1560) <{isDisjoint}> : (i64, i64) -> i64
  %1564 = "llvm.shl"(%1538, %1110) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1565 = "llvm.and"(%1564, %1142) : (i64, i64) -> i64
  %1566 = "llvm.or"(%1563, %1565) <{isDisjoint}> : (i64, i64) -> i64
  %1567 = "llvm.shl"(%1540, %1143) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1568 = "llvm.or"(%1566, %1567) <{isDisjoint}> : (i64, i64) -> i64
  %1569 = "llvm.getelementptr"(%arg74) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1568, %1569) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1570 = "llvm.lshr"(%1540, %1111) : (i64, i64) -> i64
  %1571 = "llvm.and"(%1570, %1144) : (i64, i64) -> i64
  %1572 = "llvm.shl"(%1542, %1112) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1573 = "llvm.and"(%1572, %1145) : (i64, i64) -> i64
  %1574 = "llvm.or"(%1573, %1571) <{isDisjoint}> : (i64, i64) -> i64
  %1575 = "llvm.shl"(%1544, %1104) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1576 = "llvm.and"(%1575, %1146) : (i64, i64) -> i64
  %1577 = "llvm.or"(%1574, %1576) <{isDisjoint}> : (i64, i64) -> i64
  %1578 = "llvm.shl"(%1546, %1147) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1579 = "llvm.or"(%1577, %1578) <{isDisjoint}> : (i64, i64) -> i64
  %1580 = "llvm.getelementptr"(%arg74) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1579, %1580) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1581 = "llvm.lshr"(%1546, %1113) : (i64, i64) -> i64
  %1582 = "llvm.and"(%1581, %1148) : (i64, i64) -> i64
  %1583 = "llvm.shl"(%1548, %1114) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1584 = "llvm.and"(%1583, %1149) : (i64, i64) -> i64
  %1585 = "llvm.or"(%1582, %1584) <{isDisjoint}> : (i64, i64) -> i64
  %1586 = "llvm.shl"(%1550, %1115) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1587 = "llvm.or"(%1585, %1586) <{isDisjoint}> : (i64, i64) -> i64
  %1588 = "llvm.getelementptr"(%arg74) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1587, %1588) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.return"(%arg74) : (!llvm.ptr) -> ()
}) : () -> ()
  with @fd_ulong_load_8 := fd_ulong_load_8

end

end MLIR.Firedancer.Ref
