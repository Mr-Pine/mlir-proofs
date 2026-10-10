"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 8 : i64, llvm.dead_on_unwind, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writable, llvm.writeonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.noundef, llvm.range = #llvm.constant_range<i32, 1, 101>}], dso_local, function_type = !llvm.func<void (ptr, ptr, i32)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], sym_name = "_RNvMs8_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldNtB5_14FieldElement515pow2k", target_cpu = "x86-64-v2", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg42: !llvm.ptr, %arg43: !llvm.ptr, %arg44: i32):
  %1139 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %1140 = "llvm.mlir.constant"() <{value = 1 : i128}> : () -> i128
  %1141 = "llvm.mlir.constant"() <{value = 51 : i128}> : () -> i128
  %1142 = "llvm.mlir.constant"() <{value = 18446744073709551615 : i128}> : () -> i128
  %1143 = "llvm.mlir.constant"() <{value = 2251799813685247 : i64}> : () -> i64
  %1144 = "llvm.mlir.constant"() <{value = 51 : i64}> : () -> i64
  %1145 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
  %1146 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %1147 = "llvm.load"(%arg43) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1148 = "llvm.getelementptr"(%arg43) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %1149 = "llvm.load"(%1148) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1150 = "llvm.getelementptr"(%arg43) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %1151 = "llvm.load"(%1150) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1152 = "llvm.getelementptr"(%arg43) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %1153 = "llvm.load"(%1152) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1154 = "llvm.getelementptr"(%arg43) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %1155 = "llvm.load"(%1154) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  "llvm.br"(%1155, %1153, %1151, %1149, %1147, %arg44)[^bb1] : (i64, i64, i64, i64, i64, i32) -> ()
^bb1(%1156: i64, %1157: i64, %1158: i64, %1159: i64, %1160: i64, %1161: i32):  // 2 preds: ^bb0, ^bb1
  %1162 = "llvm.mul"(%1157, %1139) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1163 = "llvm.mul"(%1156, %1139) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1164 = "llvm.zext"(%1160) : (i64) -> i128
  %1165 = "llvm.mul"(%1164, %1164) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1166 = "llvm.zext"(%1159) : (i64) -> i128
  %1167 = "llvm.zext"(%1163) : (i64) -> i128
  %1168 = "llvm.mul"(%1166, %1167) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1169 = "llvm.zext"(%1158) : (i64) -> i128
  %1170 = "llvm.zext"(%1162) : (i64) -> i128
  %1171 = "llvm.mul"(%1169, %1170) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1172 = "llvm.add"(%1168, %1171) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1173 = "llvm.shl"(%1172, %1140) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1174 = "llvm.add"(%1173, %1165) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1175 = "llvm.zext"(%1157) : (i64) -> i128
  %1176 = "llvm.mul"(%1170, %1175) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1177 = "llvm.mul"(%1164, %1166) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1178 = "llvm.mul"(%1169, %1167) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1179 = "llvm.add"(%1177, %1178) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1180 = "llvm.shl"(%1179, %1140) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1181 = "llvm.add"(%1180, %1176) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1182 = "llvm.mul"(%1166, %1166) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1183 = "llvm.mul"(%1164, %1169) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1184 = "llvm.zext"(%1156) : (i64) -> i128
  %1185 = "llvm.mul"(%1170, %1184) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1186 = "llvm.add"(%1183, %1185) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1187 = "llvm.shl"(%1186, %1140) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1188 = "llvm.add"(%1187, %1182) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1189 = "llvm.mul"(%1167, %1184) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1190 = "llvm.mul"(%1164, %1175) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1191 = "llvm.mul"(%1166, %1169) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1192 = "llvm.add"(%1190, %1191) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1193 = "llvm.shl"(%1192, %1140) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1194 = "llvm.add"(%1193, %1189) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1195 = "llvm.mul"(%1169, %1169) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1196 = "llvm.mul"(%1164, %1184) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1197 = "llvm.mul"(%1166, %1175) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1198 = "llvm.add"(%1196, %1197) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1199 = "llvm.shl"(%1198, %1140) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1200 = "llvm.add"(%1199, %1195) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1201 = "llvm.lshr"(%1174, %1141) : (i128, i128) -> i128
  %1202 = "llvm.and"(%1201, %1142) : (i128, i128) -> i128
  %1203 = "llvm.add"(%1181, %1202) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1204 = "llvm.trunc"(%1174) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %1205 = "llvm.and"(%1204, %1143) : (i64, i64) -> i64
  %1206 = "llvm.lshr"(%1203, %1141) : (i128, i128) -> i128
  %1207 = "llvm.and"(%1206, %1142) : (i128, i128) -> i128
  %1208 = "llvm.add"(%1188, %1207) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1209 = "llvm.trunc"(%1203) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %1210 = "llvm.and"(%1209, %1143) : (i64, i64) -> i64
  %1211 = "llvm.lshr"(%1208, %1141) : (i128, i128) -> i128
  %1212 = "llvm.and"(%1211, %1142) : (i128, i128) -> i128
  %1213 = "llvm.add"(%1194, %1212) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1214 = "llvm.trunc"(%1208) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %1215 = "llvm.and"(%1214, %1143) : (i64, i64) -> i64
  %1216 = "llvm.lshr"(%1213, %1141) : (i128, i128) -> i128
  %1217 = "llvm.and"(%1216, %1142) : (i128, i128) -> i128
  %1218 = "llvm.add"(%1200, %1217) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1219 = "llvm.trunc"(%1213) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %1220 = "llvm.and"(%1219, %1143) : (i64, i64) -> i64
  %1221 = "llvm.lshr"(%1218, %1141) : (i128, i128) -> i128
  %1222 = "llvm.trunc"(%1221) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %1223 = "llvm.trunc"(%1218) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %1224 = "llvm.and"(%1223, %1143) : (i64, i64) -> i64
  %1225 = "llvm.mul"(%1222, %1139) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1226 = "llvm.add"(%1225, %1205) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1227 = "llvm.lshr"(%1226, %1144) : (i64, i64) -> i64
  %1228 = "llvm.add"(%1227, %1210) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1229 = "llvm.and"(%1226, %1143) : (i64, i64) -> i64
  %1230 = "llvm.add"(%1161, %1145) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %1231 = "llvm.icmp"(%1230, %1146) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%1231, %1215, %1220, %1224, %1228, %1229, %1224, %1220, %1215, %1228, %1229, %1230)[^bb2, ^bb1] <{operandSegmentSizes = array<i32: 1, 5, 6>}> : (i1, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i32) -> ()
^bb2(%1232: i64, %1233: i64, %1234: i64, %1235: i64, %1236: i64):  // pred: ^bb1
  "llvm.store"(%1236, %arg42) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1237 = "llvm.getelementptr"(%arg42) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1235, %1237) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1238 = "llvm.getelementptr"(%arg42) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1232, %1238) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1239 = "llvm.getelementptr"(%arg42) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1233, %1239) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1240 = "llvm.getelementptr"(%arg42) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1234, %1240) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
