"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"], ["warn-stack-size", "25344"]], sym_name = "_ZL21fiat_25519_from_bytesPmPKh", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg81: !llvm.ptr, %arg82: !llvm.ptr):
  %1177 = "llvm.mlir.constant"() <{value = 31 : i64}> : () -> i64
  %1178 = "llvm.mlir.constant"() <{value = 44 : i64}> : () -> i64
  %1179 = "llvm.mlir.constant"() <{value = 36 : i64}> : () -> i64
  %1180 = "llvm.mlir.constant"() <{value = 29 : i64}> : () -> i64
  %1181 = "llvm.mlir.constant"() <{value = 28 : i64}> : () -> i64
  %1182 = "llvm.mlir.constant"() <{value = 20 : i64}> : () -> i64
  %1183 = "llvm.mlir.constant"() <{value = 12 : i64}> : () -> i64
  %1184 = "llvm.mlir.constant"() <{value = 26 : i64}> : () -> i64
  %1185 = "llvm.mlir.constant"() <{value = 4 : i64}> : () -> i64
  %1186 = "llvm.mlir.constant"() <{value = 47 : i64}> : () -> i64
  %1187 = "llvm.mlir.constant"() <{value = 39 : i64}> : () -> i64
  %1188 = "llvm.mlir.constant"() <{value = 23 : i64}> : () -> i64
  %1189 = "llvm.mlir.constant"() <{value = 21 : i64}> : () -> i64
  %1190 = "llvm.mlir.constant"() <{value = 15 : i64}> : () -> i64
  %1191 = "llvm.mlir.constant"() <{value = 7 : i64}> : () -> i64
  %1192 = "llvm.mlir.constant"() <{value = 50 : i64}> : () -> i64
  %1193 = "llvm.mlir.constant"() <{value = 18 : i64}> : () -> i64
  %1194 = "llvm.mlir.constant"() <{value = 42 : i64}> : () -> i64
  %1195 = "llvm.mlir.constant"() <{value = 34 : i64}> : () -> i64
  %1196 = "llvm.mlir.constant"() <{value = 10 : i64}> : () -> i64
  %1197 = "llvm.mlir.constant"() <{value = 13 : i64}> : () -> i64
  %1198 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %1199 = "llvm.mlir.constant"() <{value = 45 : i64}> : () -> i64
  %1200 = "llvm.mlir.constant"() <{value = 37 : i64}> : () -> i64
  %1201 = "llvm.mlir.constant"() <{value = 5 : i64}> : () -> i64
  %1202 = "llvm.mlir.constant"() <{value = 6 : i64}> : () -> i64
  %1203 = "llvm.mlir.constant"() <{value = 48 : i64}> : () -> i64
  %1204 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
  %1205 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %1206 = "llvm.mlir.constant"() <{value = 1970324836974592 : i64}> : () -> i64
  %1207 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %1208 = "llvm.mlir.constant"() <{value = 2216615441596416 : i64}> : () -> i64
  %1209 = "llvm.mlir.constant"() <{value = 2251799813685247 : i64}> : () -> i64
  %1210 = "llvm.mlir.constant"() <{value = 51 : i64}> : () -> i64
  %1211 = "llvm.getelementptr"(%arg82) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 31>}> : (!llvm.ptr) -> !llvm.ptr
  %1212 = "llvm.load"(%1211) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1213 = "llvm.zext"(%1212) : (i8) -> i64
  %1214 = "llvm.shl"(%1213, %1178) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1215 = "llvm.getelementptr"(%arg82) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 30>}> : (!llvm.ptr) -> !llvm.ptr
  %1216 = "llvm.load"(%1215) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1217 = "llvm.zext"(%1216) : (i8) -> i64
  %1218 = "llvm.shl"(%1217, %1179) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1219 = "llvm.getelementptr"(%arg82) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 29>}> : (!llvm.ptr) -> !llvm.ptr
  %1220 = "llvm.load"(%1219) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1221 = "llvm.zext"(%1220) : (i8) -> i64
  %1222 = "llvm.shl"(%1221, %1181) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1223 = "llvm.getelementptr"(%arg82) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 28>}> : (!llvm.ptr) -> !llvm.ptr
  %1224 = "llvm.load"(%1223) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1225 = "llvm.zext"(%1224) : (i8) -> i64
  %1226 = "llvm.shl"(%1225, %1182) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1227 = "llvm.getelementptr"(%arg82) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 27>}> : (!llvm.ptr) -> !llvm.ptr
  %1228 = "llvm.load"(%1227) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1229 = "llvm.zext"(%1228) : (i8) -> i64
  %1230 = "llvm.shl"(%1229, %1183) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1231 = "llvm.getelementptr"(%arg82) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 26>}> : (!llvm.ptr) -> !llvm.ptr
  %1232 = "llvm.load"(%1231) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1233 = "llvm.zext"(%1232) : (i8) -> i64
  %1234 = "llvm.shl"(%1233, %1185) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1235 = "llvm.getelementptr"(%arg82) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 25>}> : (!llvm.ptr) -> !llvm.ptr
  %1236 = "llvm.load"(%1235) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1237 = "llvm.zext"(%1236) : (i8) -> i64
  %1238 = "llvm.shl"(%1237, %1186) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1239 = "llvm.getelementptr"(%arg82) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %1240 = "llvm.load"(%1239) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1241 = "llvm.zext"(%1240) : (i8) -> i64
  %1242 = "llvm.shl"(%1241, %1187) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1243 = "llvm.getelementptr"(%arg82) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 23>}> : (!llvm.ptr) -> !llvm.ptr
  %1244 = "llvm.load"(%1243) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1245 = "llvm.zext"(%1244) : (i8) -> i64
  %1246 = "llvm.shl"(%1245, %1177) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1247 = "llvm.getelementptr"(%arg82) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 22>}> : (!llvm.ptr) -> !llvm.ptr
  %1248 = "llvm.load"(%1247) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1249 = "llvm.zext"(%1248) : (i8) -> i64
  %1250 = "llvm.shl"(%1249, %1188) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1251 = "llvm.getelementptr"(%arg82) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 21>}> : (!llvm.ptr) -> !llvm.ptr
  %1252 = "llvm.load"(%1251) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1253 = "llvm.zext"(%1252) : (i8) -> i64
  %1254 = "llvm.shl"(%1253, %1190) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1255 = "llvm.getelementptr"(%arg82) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 20>}> : (!llvm.ptr) -> !llvm.ptr
  %1256 = "llvm.load"(%1255) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1257 = "llvm.zext"(%1256) : (i8) -> i64
  %1258 = "llvm.shl"(%1257, %1191) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1259 = "llvm.getelementptr"(%arg82) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 19>}> : (!llvm.ptr) -> !llvm.ptr
  %1260 = "llvm.load"(%1259) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1261 = "llvm.zext"(%1260) : (i8) -> i64
  %1262 = "llvm.shl"(%1261, %1192) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1263 = "llvm.getelementptr"(%arg82) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 18>}> : (!llvm.ptr) -> !llvm.ptr
  %1264 = "llvm.load"(%1263) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1265 = "llvm.zext"(%1264) : (i8) -> i64
  %1266 = "llvm.shl"(%1265, %1194) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1267 = "llvm.getelementptr"(%arg82) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 17>}> : (!llvm.ptr) -> !llvm.ptr
  %1268 = "llvm.load"(%1267) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1269 = "llvm.zext"(%1268) : (i8) -> i64
  %1270 = "llvm.shl"(%1269, %1195) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1271 = "llvm.getelementptr"(%arg82) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %1272 = "llvm.load"(%1271) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1273 = "llvm.zext"(%1272) : (i8) -> i64
  %1274 = "llvm.shl"(%1273, %1184) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1275 = "llvm.getelementptr"(%arg82) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 15>}> : (!llvm.ptr) -> !llvm.ptr
  %1276 = "llvm.load"(%1275) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1277 = "llvm.zext"(%1276) : (i8) -> i64
  %1278 = "llvm.shl"(%1277, %1193) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1279 = "llvm.getelementptr"(%arg82) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 14>}> : (!llvm.ptr) -> !llvm.ptr
  %1280 = "llvm.load"(%1279) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1281 = "llvm.zext"(%1280) : (i8) -> i64
  %1282 = "llvm.shl"(%1281, %1196) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1283 = "llvm.getelementptr"(%arg82) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 13>}> : (!llvm.ptr) -> !llvm.ptr
  %1284 = "llvm.load"(%1283) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1285 = "llvm.zext"(%1284) : (i8) -> i64
  %1286 = "llvm.shl"(%1285, %1198) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1287 = "llvm.getelementptr"(%arg82) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 12>}> : (!llvm.ptr) -> !llvm.ptr
  %1288 = "llvm.load"(%1287) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1289 = "llvm.zext"(%1288) : (i8) -> i64
  %1290 = "llvm.shl"(%1289, %1199) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1291 = "llvm.getelementptr"(%arg82) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 11>}> : (!llvm.ptr) -> !llvm.ptr
  %1292 = "llvm.load"(%1291) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1293 = "llvm.zext"(%1292) : (i8) -> i64
  %1294 = "llvm.shl"(%1293, %1200) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1295 = "llvm.getelementptr"(%arg82) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 10>}> : (!llvm.ptr) -> !llvm.ptr
  %1296 = "llvm.load"(%1295) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1297 = "llvm.zext"(%1296) : (i8) -> i64
  %1298 = "llvm.shl"(%1297, %1180) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1299 = "llvm.getelementptr"(%arg82) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 9>}> : (!llvm.ptr) -> !llvm.ptr
  %1300 = "llvm.load"(%1299) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1301 = "llvm.zext"(%1300) : (i8) -> i64
  %1302 = "llvm.shl"(%1301, %1189) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1303 = "llvm.getelementptr"(%arg82) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %1304 = "llvm.load"(%1303) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1305 = "llvm.zext"(%1304) : (i8) -> i64
  %1306 = "llvm.shl"(%1305, %1197) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1307 = "llvm.getelementptr"(%arg82) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 7>}> : (!llvm.ptr) -> !llvm.ptr
  %1308 = "llvm.load"(%1307) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1309 = "llvm.zext"(%1308) : (i8) -> i64
  %1310 = "llvm.shl"(%1309, %1201) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1311 = "llvm.getelementptr"(%arg82) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6>}> : (!llvm.ptr) -> !llvm.ptr
  %1312 = "llvm.load"(%1311) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1313 = "llvm.zext"(%1312) : (i8) -> i64
  %1314 = "llvm.shl"(%1313, %1203) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1315 = "llvm.getelementptr"(%arg82) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 5>}> : (!llvm.ptr) -> !llvm.ptr
  %1316 = "llvm.load"(%1315) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1317 = "llvm.zext"(%1316) : (i8) -> i64
  %1318 = "llvm.shl"(%1317, %1204) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1319 = "llvm.getelementptr"(%arg82) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4>}> : (!llvm.ptr) -> !llvm.ptr
  %1320 = "llvm.load"(%1319) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1321 = "llvm.zext"(%1320) : (i8) -> i64
  %1322 = "llvm.shl"(%1321, %1205) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1323 = "llvm.load"(%arg82) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %1324 = "llvm.zext"(%1323) : (i32) -> i64
  %1325 = "llvm.or"(%1318, %1324) <{isDisjoint}> : (i64, i64) -> i64
  %1326 = "llvm.or"(%1325, %1322) <{isDisjoint}> : (i64, i64) -> i64
  %1327 = "llvm.and"(%1314, %1206) : (i64, i64) -> i64
  %1328 = "llvm.or"(%1326, %1327) <{isDisjoint}> : (i64, i64) -> i64
  %1329 = "llvm.lshr"(%1313, %1207) : (i64, i64) -> i64
  %1330 = "llvm.and"(%1290, %1208) : (i64, i64) -> i64
  %1331 = "llvm.or"(%1294, %1330) <{isDisjoint}> : (i64, i64) -> i64
  %1332 = "llvm.or"(%1331, %1298) <{isDisjoint}> : (i64, i64) -> i64
  %1333 = "llvm.or"(%1332, %1302) <{isDisjoint}> : (i64, i64) -> i64
  %1334 = "llvm.or"(%1333, %1306) <{isDisjoint}> : (i64, i64) -> i64
  %1335 = "llvm.or"(%1334, %1310) <{isDisjoint}> : (i64, i64) -> i64
  %1336 = "llvm.or"(%1335, %1329) <{isDisjoint}> : (i64, i64) -> i64
  %1337 = "llvm.lshr"(%1289, %1202) : (i64, i64) -> i64
  %1338 = "llvm.or"(%1266, %1262) <{isDisjoint}> : (i64, i64) -> i64
  %1339 = "llvm.or"(%1338, %1270) <{isDisjoint}> : (i64, i64) -> i64
  %1340 = "llvm.or"(%1339, %1274) <{isDisjoint}> : (i64, i64) -> i64
  %1341 = "llvm.or"(%1340, %1278) <{isDisjoint}> : (i64, i64) -> i64
  %1342 = "llvm.or"(%1341, %1282) <{isDisjoint}> : (i64, i64) -> i64
  %1343 = "llvm.or"(%1342, %1286) <{isDisjoint}> : (i64, i64) -> i64
  %1344 = "llvm.add"(%1343, %1337) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1345 = "llvm.and"(%1344, %1209) : (i64, i64) -> i64
  %1346 = "llvm.lshr"(%1344, %1210) : (i64, i64) -> i64
  %1347 = "llvm.or"(%1242, %1238) <{isDisjoint}> : (i64, i64) -> i64
  %1348 = "llvm.or"(%1347, %1246) <{isDisjoint}> : (i64, i64) -> i64
  %1349 = "llvm.or"(%1348, %1250) <{isDisjoint}> : (i64, i64) -> i64
  %1350 = "llvm.or"(%1349, %1254) <{isDisjoint}> : (i64, i64) -> i64
  %1351 = "llvm.or"(%1350, %1258) <{isDisjoint}> : (i64, i64) -> i64
  %1352 = "llvm.add"(%1351, %1346) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1353 = "llvm.and"(%1352, %1209) : (i64, i64) -> i64
  %1354 = "llvm.lshr"(%1352, %1210) : (i64, i64) -> i64
  %1355 = "llvm.or"(%1218, %1214) <{isDisjoint}> : (i64, i64) -> i64
  %1356 = "llvm.or"(%1355, %1222) <{isDisjoint}> : (i64, i64) -> i64
  %1357 = "llvm.or"(%1356, %1226) <{isDisjoint}> : (i64, i64) -> i64
  %1358 = "llvm.or"(%1357, %1230) <{isDisjoint}> : (i64, i64) -> i64
  %1359 = "llvm.or"(%1358, %1234) <{isDisjoint}> : (i64, i64) -> i64
  %1360 = "llvm.add"(%1359, %1354) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  "llvm.store"(%1328, %arg81) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1361 = "llvm.getelementptr"(%arg81) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1336, %1361) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1362 = "llvm.getelementptr"(%arg81) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1345, %1362) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1363 = "llvm.getelementptr"(%arg81) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1353, %1363) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1364 = "llvm.getelementptr"(%arg81) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1360, %1364) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
