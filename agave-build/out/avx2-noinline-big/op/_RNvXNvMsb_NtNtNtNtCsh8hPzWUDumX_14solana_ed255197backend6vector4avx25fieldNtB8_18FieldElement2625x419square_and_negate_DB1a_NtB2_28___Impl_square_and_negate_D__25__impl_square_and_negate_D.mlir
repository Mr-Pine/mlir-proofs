"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 32 : i64, llvm.dead_on_unwind, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writable, llvm.writeonly}, {llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], sym_name = "_RNvXNvMsb_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx25fieldNtB8_18FieldElement2625x419square_and_negate_DB1a_NtB2_28___Impl_square_and_negate_D__25__impl_square_and_negate_D", target_cpu = "x86-64-v2", target_features = #llvm.target_features<["+avx", "+avx2", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+crc32", "+ssse3", "+avx", "+avx2", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+crc32", "+ssse3"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg44: !llvm.ptr, %arg45: !llvm.ptr):
  %1088 = "llvm.mlir.constant"() <{value = 9223371899415822336 : i64}> : () -> i64
  %1089 = "llvm.mlir.constant"() <{value = 4611685880988434432 : i64}> : () -> i64
  %1090 = "llvm.mlir.undef"() : () -> vector<4xi64>
  %1091 = "llvm.mlir.poison"() : () -> i64
  %1092 = "llvm.mlir.constant"() <{value = 9223369425514659840 : i64}> : () -> i64
  %1093 = "llvm.mlir.constant"() <{value = dense<1> : vector<4xi64>}> : () -> vector<4xi64>
  %1094 = "llvm.mlir.constant"() <{value = dense<4294967295> : vector<4xi64>}> : () -> vector<4xi64>
  %1095 = "llvm.mlir.constant"() <{value = dense<19> : vector<4xi64>}> : () -> vector<4xi64>
  %1096 = "llvm.mlir.constant"() <{value = dense<1> : vector<8xi32>}> : () -> vector<8xi32>
  %1097 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %1098 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %1099 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %1100 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %1101 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %1102 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %1103 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1104 = "llvm.mlir.poison"() : () -> i32
  %1105 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %1106 = "llvm.mlir.undef"() : () -> vector<8xi32>
  %1107 = "llvm.insertelement"(%1106, %1105, %1105) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1108 = "llvm.insertelement"(%1107, %1105, %1103) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1109 = "llvm.insertelement"(%1108, %1104, %1102) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1110 = "llvm.insertelement"(%1109, %1104, %1101) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1111 = "llvm.insertelement"(%1110, %1105, %1100) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1112 = "llvm.insertelement"(%1111, %1105, %1099) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1113 = "llvm.insertelement"(%1112, %1104, %1098) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1114 = "llvm.insertelement"(%1113, %1104, %1097) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1115 = "llvm.insertelement"(%1106, %1104, %1105) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1116 = "llvm.insertelement"(%1115, %1104, %1103) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1117 = "llvm.insertelement"(%1116, %1105, %1102) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1118 = "llvm.insertelement"(%1117, %1105, %1101) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1119 = "llvm.insertelement"(%1118, %1104, %1100) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1120 = "llvm.insertelement"(%1119, %1104, %1099) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1121 = "llvm.insertelement"(%1120, %1105, %1098) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1122 = "llvm.insertelement"(%1121, %1105, %1097) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1123 = "llvm.insertelement"(%1090, %1091, %1105) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %1124 = "llvm.insertelement"(%1123, %1091, %1103) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %1125 = "llvm.insertelement"(%1124, %1091, %1102) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %1126 = "llvm.insertelement"(%1125, %1092, %1101) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %1127 = "llvm.insertelement"(%1090, %1091, %1105) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %1128 = "llvm.insertelement"(%1127, %1091, %1103) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %1129 = "llvm.insertelement"(%1128, %1091, %1102) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %1130 = "llvm.insertelement"(%1129, %1089, %1101) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %1131 = "llvm.insertelement"(%1090, %1091, %1105) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %1132 = "llvm.insertelement"(%1131, %1091, %1103) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %1133 = "llvm.insertelement"(%1132, %1091, %1102) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %1134 = "llvm.insertelement"(%1133, %1088, %1101) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %1135 = "llvm.alloca"(%1103) <{alignment = 32 : i64, elem_type = !llvm.array<320 x i8>}> : (i32) -> !llvm.ptr
  %1136 = "llvm.load"(%arg45) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %1137 = "llvm.shufflevector"(%1136, %1114) <{mask = array<i32: 0, 8, 1, 9, 4, 12, 5, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1138 = "llvm.shufflevector"(%1136, %1122) <{mask = array<i32: 2, 10, 3, 11, 6, 14, 7, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1139 = "llvm.bitcast"(%1137) : (vector<8xi32>) -> vector<4xi64>
  %1140 = "llvm.bitcast"(%1138) : (vector<8xi32>) -> vector<4xi64>
  %1141 = "llvm.getelementptr"(%arg45) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %1142 = "llvm.load"(%1141) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %1143 = "llvm.shufflevector"(%1142, %1114) <{mask = array<i32: 0, 8, 1, 9, 4, 12, 5, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1144 = "llvm.shufflevector"(%1142, %1122) <{mask = array<i32: 2, 10, 3, 11, 6, 14, 7, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1145 = "llvm.bitcast"(%1143) : (vector<8xi32>) -> vector<4xi64>
  %1146 = "llvm.bitcast"(%1144) : (vector<8xi32>) -> vector<4xi64>
  %1147 = "llvm.getelementptr"(%arg45) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %1148 = "llvm.load"(%1147) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %1149 = "llvm.shufflevector"(%1148, %1114) <{mask = array<i32: 0, 8, 1, 9, 4, 12, 5, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1150 = "llvm.shufflevector"(%1148, %1122) <{mask = array<i32: 2, 10, 3, 11, 6, 14, 7, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1151 = "llvm.bitcast"(%1149) : (vector<8xi32>) -> vector<4xi64>
  %1152 = "llvm.bitcast"(%1150) : (vector<8xi32>) -> vector<4xi64>
  %1153 = "llvm.getelementptr"(%arg45) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %1154 = "llvm.load"(%1153) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %1155 = "llvm.shufflevector"(%1154, %1114) <{mask = array<i32: 0, 8, 1, 9, 4, 12, 5, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1156 = "llvm.shufflevector"(%1154, %1122) <{mask = array<i32: 2, 10, 3, 11, 6, 14, 7, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1157 = "llvm.bitcast"(%1155) : (vector<8xi32>) -> vector<4xi64>
  %1158 = "llvm.bitcast"(%1156) : (vector<8xi32>) -> vector<4xi64>
  %1159 = "llvm.getelementptr"(%arg45) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %1160 = "llvm.load"(%1159) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %1161 = "llvm.shufflevector"(%1160, %1114) <{mask = array<i32: 0, 8, 1, 9, 4, 12, 5, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1162 = "llvm.shufflevector"(%1160, %1122) <{mask = array<i32: 2, 10, 3, 11, 6, 14, 7, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1163 = "llvm.bitcast"(%1161) : (vector<8xi32>) -> vector<4xi64>
  %1164 = "llvm.bitcast"(%1162) : (vector<8xi32>) -> vector<4xi64>
  %1165 = "llvm.shl"(%1137, %1096) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1166 = "llvm.bitcast"(%1165) : (vector<8xi32>) -> vector<4xi64>
  %1167 = "llvm.shl"(%1138, %1096) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1168 = "llvm.bitcast"(%1167) : (vector<8xi32>) -> vector<4xi64>
  %1169 = "llvm.shl"(%1143, %1096) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1170 = "llvm.bitcast"(%1169) : (vector<8xi32>) -> vector<4xi64>
  %1171 = "llvm.shl"(%1144, %1096) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1172 = "llvm.bitcast"(%1171) : (vector<8xi32>) -> vector<4xi64>
  %1173 = "llvm.shl"(%1149, %1096) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1174 = "llvm.bitcast"(%1173) : (vector<8xi32>) -> vector<4xi64>
  %1175 = "llvm.shl"(%1150, %1096) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1176 = "llvm.bitcast"(%1175) : (vector<8xi32>) -> vector<4xi64>
  %1177 = "llvm.shl"(%1155, %1096) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1178 = "llvm.bitcast"(%1177) : (vector<8xi32>) -> vector<4xi64>
  %1179 = "llvm.shl"(%1156, %1096) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1180 = "llvm.bitcast"(%1179) : (vector<8xi32>) -> vector<4xi64>
  %1181 = "llvm.mul"(%1152, %1095) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1182 = "llvm.mul"(%1157, %1095) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1183 = "llvm.mul"(%1158, %1095) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1184 = "llvm.mul"(%1163, %1095) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1185 = "llvm.mul"(%1164, %1095) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1186 = "llvm.mul"(%1139, %1139) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1187 = "llvm.and"(%1184, %1094) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1188 = "llvm.mul"(%1187, %1170) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1189 = "llvm.and"(%1182, %1094) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1190 = "llvm.mul"(%1189, %1174) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1191 = "llvm.and"(%1185, %1094) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1192 = "llvm.mul"(%1191, %1168) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1193 = "llvm.and"(%1183, %1094) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1194 = "llvm.mul"(%1193, %1172) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1195 = "llvm.and"(%1181, %1094) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1196 = "llvm.mul"(%1195, %1152) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1197 = "llvm.add"(%1194, %1196) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1198 = "llvm.add"(%1197, %1192) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1199 = "llvm.shl"(%1198, %1093) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1200 = "llvm.add"(%1190, %1186) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1201 = "llvm.add"(%1200, %1188) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1202 = "llvm.add"(%1201, %1199) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1203 = "llvm.mul"(%1166, %1140) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1204 = "llvm.mul"(%1187, %1172) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1205 = "llvm.mul"(%1189, %1176) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1206 = "llvm.mul"(%1191, %1145) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1207 = "llvm.mul"(%1193, %1151) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1208 = "llvm.add"(%1206, %1207) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1209 = "llvm.shl"(%1208, %1093) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1210 = "llvm.add"(%1205, %1203) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1211 = "llvm.add"(%1210, %1204) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1212 = "llvm.add"(%1211, %1209) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1213 = "llvm.mul"(%1145, %1166) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1214 = "llvm.mul"(%1168, %1140) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1215 = "llvm.add"(%1214, %1213) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1216 = "llvm.mul"(%1187, %1174) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1217 = "llvm.mul"(%1189, %1157) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1218 = "llvm.mul"(%1191, %1172) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1219 = "llvm.mul"(%1193, %1176) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1220 = "llvm.add"(%1218, %1219) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1221 = "llvm.shl"(%1220, %1093) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1222 = "llvm.add"(%1215, %1217) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1223 = "llvm.add"(%1222, %1216) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1224 = "llvm.add"(%1223, %1221) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1225 = "llvm.mul"(%1146, %1166) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1226 = "llvm.mul"(%1145, %1168) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1227 = "llvm.add"(%1226, %1225) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1228 = "llvm.mul"(%1187, %1176) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1229 = "llvm.add"(%1227, %1228) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1230 = "llvm.mul"(%1191, %1151) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1231 = "llvm.mul"(%1193, %1157) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1232 = "llvm.add"(%1230, %1231) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1233 = "llvm.shl"(%1232, %1093) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1234 = "llvm.add"(%1229, %1233) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1235 = "llvm.mul"(%1151, %1166) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1236 = "llvm.mul"(%1172, %1168) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1237 = "llvm.mul"(%1145, %1145) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1238 = "llvm.mul"(%1187, %1178) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1239 = "llvm.mul"(%1191, %1176) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1240 = "llvm.mul"(%1193, %1158) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1241 = "llvm.add"(%1239, %1240) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1242 = "llvm.shl"(%1241, %1093) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1243 = "llvm.add"(%1235, %1237) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1244 = "llvm.add"(%1243, %1236) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1245 = "llvm.add"(%1244, %1238) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1246 = "llvm.add"(%1245, %1242) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1247 = "llvm.mul"(%1152, %1166) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1248 = "llvm.mul"(%1151, %1168) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1249 = "llvm.add"(%1248, %1247) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1250 = "llvm.mul"(%1170, %1146) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1251 = "llvm.add"(%1249, %1250) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1252 = "llvm.mul"(%1187, %1180) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1253 = "llvm.add"(%1251, %1252) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1254 = "llvm.mul"(%1191, %1157) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1255 = "llvm.shl"(%1254, %1093) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1256 = "llvm.add"(%1253, %1255) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1257 = "llvm.mul"(%1157, %1166) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1258 = "llvm.mul"(%1176, %1168) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1259 = "llvm.mul"(%1151, %1170) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1260 = "llvm.mul"(%1172, %1146) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1261 = "llvm.mul"(%1187, %1163) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1262 = "llvm.mul"(%1191, %1180) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1263 = "llvm.shl"(%1262, %1093) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1264 = "llvm.add"(%1260, %1259) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1265 = "llvm.add"(%1264, %1257) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1266 = "llvm.add"(%1265, %1258) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1267 = "llvm.add"(%1266, %1261) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1268 = "llvm.add"(%1267, %1263) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1269 = "llvm.mul"(%1158, %1166) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1270 = "llvm.mul"(%1157, %1168) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1271 = "llvm.mul"(%1152, %1170) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1272 = "llvm.mul"(%1151, %1172) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1273 = "llvm.mul"(%1191, %1163) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1274 = "llvm.shl"(%1273, %1093) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1275 = "llvm.add"(%1272, %1271) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1276 = "llvm.add"(%1275, %1269) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1277 = "llvm.add"(%1276, %1270) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1278 = "llvm.add"(%1277, %1274) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1279 = "llvm.mul"(%1163, %1166) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1280 = "llvm.mul"(%1180, %1168) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1281 = "llvm.mul"(%1157, %1170) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1282 = "llvm.mul"(%1176, %1172) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1283 = "llvm.mul"(%1151, %1151) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1284 = "llvm.mul"(%1191, %1164) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1285 = "llvm.shl"(%1284, %1093) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1286 = "llvm.add"(%1281, %1283) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1287 = "llvm.add"(%1286, %1282) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1288 = "llvm.add"(%1287, %1279) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1289 = "llvm.add"(%1288, %1280) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1290 = "llvm.add"(%1289, %1285) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1291 = "llvm.mul"(%1164, %1166) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1292 = "llvm.mul"(%1163, %1168) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1293 = "llvm.mul"(%1158, %1170) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1294 = "llvm.mul"(%1157, %1172) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1295 = "llvm.mul"(%1174, %1152) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1296 = "llvm.add"(%1294, %1293) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1297 = "llvm.add"(%1296, %1295) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1298 = "llvm.add"(%1297, %1291) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1299 = "llvm.add"(%1298, %1292) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1300 = "llvm.sub"(%1126, %1202) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1301 = "llvm.shufflevector"(%1202, %1300) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1302 = "llvm.sub"(%1130, %1212) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1303 = "llvm.shufflevector"(%1212, %1302) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1304 = "llvm.sub"(%1134, %1224) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1305 = "llvm.shufflevector"(%1224, %1304) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1306 = "llvm.sub"(%1130, %1234) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1307 = "llvm.shufflevector"(%1234, %1306) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1308 = "llvm.sub"(%1134, %1246) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1309 = "llvm.shufflevector"(%1246, %1308) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1310 = "llvm.sub"(%1130, %1256) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1311 = "llvm.shufflevector"(%1256, %1310) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1312 = "llvm.sub"(%1134, %1268) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1313 = "llvm.shufflevector"(%1268, %1312) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1314 = "llvm.sub"(%1130, %1278) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1315 = "llvm.shufflevector"(%1278, %1314) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1316 = "llvm.sub"(%1134, %1290) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1317 = "llvm.shufflevector"(%1290, %1316) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1318 = "llvm.sub"(%1130, %1299) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1319 = "llvm.shufflevector"(%1299, %1318) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%1135) : (!llvm.ptr) -> ()
  "llvm.store"(%1301, %1135) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %1320 = "llvm.getelementptr"(%1135) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1303, %1320) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %1321 = "llvm.getelementptr"(%1135) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1305, %1321) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %1322 = "llvm.getelementptr"(%1135) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1307, %1322) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %1323 = "llvm.getelementptr"(%1135) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1309, %1323) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %1324 = "llvm.getelementptr"(%1135) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 160>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1311, %1324) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %1325 = "llvm.getelementptr"(%1135) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 192>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1313, %1325) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %1326 = "llvm.getelementptr"(%1135) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 224>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1315, %1326) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %1327 = "llvm.getelementptr"(%1135) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 256>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1317, %1327) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %1328 = "llvm.getelementptr"(%1135) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 288>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1319, %1328) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.call"(%arg44, %1135) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 32 : i64, llvm.dereferenceable = 320 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef}], callee = @_RNvXNvMsb_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx25fieldNtB8_18FieldElement2625x48reduce64B1a_NtB2_17___Impl_reduce64__14__impl_reduce64, fastmathFlags = #llvm.fastmath<none>, inline_hint, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1135) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
