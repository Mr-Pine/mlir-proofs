#loop_annotation = #llvm.loop_annotation<mustProgress = true>
#loop_annotation1 = #llvm.loop_annotation<mustProgress = true, isVectorized = true>
#loop_unroll = #llvm.loop_unroll<runtimeDisable = true>
#loop_unroll1 = #llvm.loop_unroll<disable = true>
#loop_annotation2 = #llvm.loop_annotation<unroll = #loop_unroll, mustProgress = true, isVectorized = true>
#loop_annotation3 = #llvm.loop_annotation<unroll = #loop_unroll1>
"llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.noundef}], dso_local, function_type = !llvm.func<i32 (ptr, ptr, i64)>, linkage = #llvm.linkage<internal>, no_inline, no_unwind, passthrough = ["ssp", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], res_attrs = [{llvm.noundef}], sym_name = "crypto_hash_sha512_update", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg33: !llvm.ptr, %arg34: !llvm.ptr, %arg35: i64):
  %1209 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1210 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %1211 = "llvm.mlir.constant"() <{value = 64 : i64}> : () -> i64
  %1212 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %1213 = "llvm.mlir.constant"() <{value = 127 : i64}> : () -> i64
  %1214 = "llvm.mlir.constant"() <{value = 61 : i64}> : () -> i64
  %1215 = "llvm.mlir.constant"() <{value = 128 : i64}> : () -> i64
  %1216 = "llvm.mlir.constant"() <{value = 80 : i64}> : () -> i64
  %1217 = "llvm.mlir.constant"() <{value = 124 : i64}> : () -> i64
  %1218 = "llvm.mlir.constant"() <{value = 79 : i64}> : () -> i64
  %1219 = "llvm.mlir.constant"() <{value = 31 : i64}> : () -> i64
  %1220 = "llvm.mlir.constant"() <{value = 96 : i64}> : () -> i64
  %1221 = "llvm.mlir.constant"() <{value = 28 : i64}> : () -> i64
  %1222 = "llvm.mlir.constant"() <{value = 224 : i64}> : () -> i64
  %1223 = "llvm.mlir.constant"() <{value = 16 : i64}> : () -> i64
  %1224 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %1225 = "llvm.mlir.constant"() <{value = 48 : i64}> : () -> i64
  %1226 = "llvm.mlir.constant"() <{value = 112 : i64}> : () -> i64
  %1227 = "llvm.mlir.constant"() <{value = 252 : i64}> : () -> i64
  %1228 = "llvm.mlir.constant"() <{value = 4 : i64}> : () -> i64
  %1229 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %1230 = "llvm.mlir.constant"() <{value = -125 : i64}> : () -> i64
  %1231 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %1232 = "llvm.mlir.constant"() <{value = -128 : i64}> : () -> i64
  %1233 = "llvm.mlir.constant"() <{value = 15 : i64}> : () -> i64
  %1234 = "llvm.mlir.constant"() <{value = 12 : i64}> : () -> i64
  %1235 = "llvm.mlir.constant"() <{value = -4 : i64}> : () -> i64
  %1236 = "llvm.mlir.constant"() <{value = 704 : i64}> : () -> i64
  %1237 = "llvm.mlir.constant"() <{value = -32 : i64}> : () -> i64
  %1238 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %1239 = "llvm.ptrtoaddr"(%arg34) : (!llvm.ptr) -> i64
  %1240 = "llvm.ptrtoaddr"(%arg33) : (!llvm.ptr) -> i64
  %1241 = "llvm.alloca"(%1209) <{alignment = 16 : i64, elem_type = !llvm.array<88 x i64>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%1241) : (!llvm.ptr) -> ()
  %1242 = "llvm.icmp"(%arg35, %1210) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1242)[^bb56, ^bb1] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb1:  // pred: ^bb0
  "llvm.fence"() <{ordering = 4 : i64}> : () -> ()
  %1243 = "llvm.getelementptr"(%arg33) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %1244 = "llvm.getelementptr"(%arg33) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 72>}> : (!llvm.ptr) -> !llvm.ptr
  %1245 = "llvm.load"(%1244) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1246 = "llvm.lshr"(%1245, %1212) : (i64, i64) -> i64
  %1247 = "llvm.and"(%1246, %1213) : (i64, i64) -> i64
  %1248 = "llvm.shl"(%arg35, %1212) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1249 = "llvm.lshr"(%arg35, %1214) : (i64, i64) -> i64
  %1250 = "llvm.add"(%1245, %1248) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%1250, %1244) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1251 = "llvm.icmp"(%1250, %1248) <{predicate = 6 : i64}> : (i64, i64) -> i1
  %1252 = "llvm.load"(%1243) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1253 = "llvm.zext"(%1251) : (i1) -> i64
  %1254 = "llvm.add"(%1252, %1253) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1255 = "llvm.add"(%1254, %1249) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%1255, %1243) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1256 = "llvm.sub"(%1215, %1247) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1257 = "llvm.icmp"(%arg35, %1256) <{predicate = 6 : i64}> : (i64, i64) -> i1
  %1258 = "llvm.getelementptr"(%arg33) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 80>}> : (!llvm.ptr) -> !llvm.ptr
  %1259 = "llvm.getelementptr"(%1258, %1247) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.cond_br"(%1257)[^bb17, ^bb2] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb2:  // pred: ^bb1
  %1260 = "llvm.icmp"(%1247, %1217) <{predicate = 8 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1260, %1210)[^bb14, ^bb3] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
^bb3:  // pred: ^bb2
  %1261 = "llvm.add"(%1247, %1240) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1262 = "llvm.sub"(%1261, %1239) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1263 = "llvm.add"(%1262, %1218) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1264 = "llvm.icmp"(%1263, %1219) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1264, %1210)[^bb14, ^bb4] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
^bb4:  // pred: ^bb3
  %1265 = "llvm.icmp"(%1247, %1220) <{predicate = 8 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1265, %1210)[^bb11, ^bb5] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
^bb5:  // pred: ^bb4
  %1266 = "llvm.and"(%1256, %1221) : (i64, i64) -> i64
  %1267 = "llvm.and"(%1256, %1222) : (i64, i64) -> i64
  %1268 = "llvm.getelementptr"(%arg34) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %1269 = "llvm.load"(%arg34) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<16xi8>
  %1270 = "llvm.load"(%1268) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<16xi8>
  %1271 = "llvm.getelementptr"(%1259) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1269, %1259) <{alignment = 1 : i64, ordering = 0 : i64}> : (vector<16xi8>, !llvm.ptr) -> ()
  "llvm.store"(%1270, %1271) <{alignment = 1 : i64, ordering = 0 : i64}> : (vector<16xi8>, !llvm.ptr) -> ()
  %1272 = "llvm.icmp"(%1267, %1224) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1272)[^bb9, ^bb6] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb6:  // pred: ^bb5
  %1273 = "llvm.getelementptr"(%arg34) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %1274 = "llvm.getelementptr"(%arg34) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 48>}> : (!llvm.ptr) -> !llvm.ptr
  %1275 = "llvm.load"(%1273) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<16xi8>
  %1276 = "llvm.load"(%1274) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<16xi8>
  %1277 = "llvm.getelementptr"(%1259) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %1278 = "llvm.getelementptr"(%1259) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 48>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1275, %1277) <{alignment = 1 : i64, ordering = 0 : i64}> : (vector<16xi8>, !llvm.ptr) -> ()
  "llvm.store"(%1276, %1278) <{alignment = 1 : i64, ordering = 0 : i64}> : (vector<16xi8>, !llvm.ptr) -> ()
  %1279 = "llvm.icmp"(%1267, %1211) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1279)[^bb9, ^bb7] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb7:  // pred: ^bb6
  %1280 = "llvm.getelementptr"(%arg34) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %1281 = "llvm.getelementptr"(%arg34) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 80>}> : (!llvm.ptr) -> !llvm.ptr
  %1282 = "llvm.load"(%1280) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<16xi8>
  %1283 = "llvm.load"(%1281) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<16xi8>
  %1284 = "llvm.getelementptr"(%1259) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %1285 = "llvm.getelementptr"(%1259) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 80>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1282, %1284) <{alignment = 1 : i64, ordering = 0 : i64}> : (vector<16xi8>, !llvm.ptr) -> ()
  "llvm.store"(%1283, %1285) <{alignment = 1 : i64, ordering = 0 : i64}> : (vector<16xi8>, !llvm.ptr) -> ()
  %1286 = "llvm.icmp"(%1267, %1220) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1286)[^bb9, ^bb8] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb8:  // pred: ^bb7
  %1287 = "llvm.getelementptr"(%arg34) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %1288 = "llvm.getelementptr"(%arg34) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 112>}> : (!llvm.ptr) -> !llvm.ptr
  %1289 = "llvm.load"(%1287) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<16xi8>
  %1290 = "llvm.load"(%1288) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<16xi8>
  %1291 = "llvm.getelementptr"(%1259) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %1292 = "llvm.getelementptr"(%1259) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 112>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1289, %1291) <{alignment = 1 : i64, ordering = 0 : i64}> : (vector<16xi8>, !llvm.ptr) -> ()
  "llvm.store"(%1290, %1292) <{alignment = 1 : i64, ordering = 0 : i64}> : (vector<16xi8>, !llvm.ptr) -> ()
  "llvm.br"()[^bb9] : () -> ()
^bb9:  // 4 preds: ^bb5, ^bb6, ^bb7, ^bb8
  %1293 = "llvm.icmp"(%1256, %1267) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1293)[^bb33, ^bb10] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb10:  // pred: ^bb9
  %1294 = "llvm.icmp"(%1266, %1210) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1294, %1267, %1267)[^bb14, ^bb11] <{branch_weights = array<i32: 4, 28>, operandSegmentSizes = array<i32: 1, 1, 1>}> : (i1, i64, i64) -> ()
^bb11(%1295: i64):  // 2 preds: ^bb4, ^bb10
  %1296 = "llvm.and"(%1256, %1227) : (i64, i64) -> i64
  "llvm.br"(%1295)[^bb12] : (i64) -> ()
^bb12(%1297: i64):  // 2 preds: ^bb11, ^bb12
  %1298 = "llvm.getelementptr"(%arg34, %1297) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1299 = "llvm.load"(%1298) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi8>
  %1300 = "llvm.getelementptr"(%1259, %1297) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%1299, %1300) <{alignment = 1 : i64, ordering = 0 : i64}> : (vector<4xi8>, !llvm.ptr) -> ()
  %1301 = "llvm.add"(%1297, %1228) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %1302 = "llvm.icmp"(%1301, %1296) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1302, %1301)[^bb13, ^bb12] <{loop_annotation = #loop_annotation2, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb13:  // pred: ^bb12
  %1303 = "llvm.icmp"(%1256, %1296) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1303, %1296)[^bb33, ^bb14] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb14(%1304: i64):  // 4 preds: ^bb2, ^bb3, ^bb10, ^bb13
  %1305 = "llvm.sub"(%1210, %1246) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1306 = "llvm.add"(%1304, %1247) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1307 = "llvm.and"(%1305, %1212) : (i64, i64) -> i64
  %1308 = "llvm.icmp"(%1307, %1210) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1308, %1304, %1304, %1210)[^bb16, ^bb15] <{operandSegmentSizes = array<i32: 1, 1, 2>}> : (i1, i64, i64, i64) -> ()
^bb15(%1309: i64, %1310: i64):  // 2 preds: ^bb14, ^bb15
  %1311 = "llvm.getelementptr"(%arg34, %1309) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1312 = "llvm.load"(%1311) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1313 = "llvm.getelementptr"(%1259, %1309) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%1312, %1313) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1314 = "llvm.add"(%1309, %1229) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1315 = "llvm.add"(%1310, %1229) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1316 = "llvm.icmp"(%1315, %1307) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1316, %1314, %1314, %1315)[^bb16, ^bb15] <{loop_annotation = #loop_annotation3, operandSegmentSizes = array<i32: 1, 1, 2>}> : (i1, i64, i64, i64) -> ()
^bb16(%1317: i64):  // 2 preds: ^bb14, ^bb15
  %1318 = "llvm.add"(%1306, %1230) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1319 = "llvm.icmp"(%1318, %1212) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1319, %1317)[^bb33, ^bb32] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb17:  // pred: ^bb1
  %1320 = "llvm.icmp"(%arg35, %1228) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1320, %1210)[^bb28, ^bb18] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
^bb18:  // pred: ^bb17
  %1321 = "llvm.add"(%1247, %1240) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1322 = "llvm.sub"(%1321, %1239) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1323 = "llvm.add"(%1322, %1218) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1324 = "llvm.icmp"(%1323, %1219) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1324, %1210)[^bb28, ^bb19] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
^bb19:  // pred: ^bb18
  %1325 = "llvm.icmp"(%arg35, %1224) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1325, %1210)[^bb25, ^bb20] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
^bb20:  // pred: ^bb19
  %1326 = "llvm.and"(%arg35, %1221) : (i64, i64) -> i64
  %1327 = "llvm.and"(%arg35, %1237) : (i64, i64) -> i64
  %1328 = "llvm.getelementptr"(%arg34) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %1329 = "llvm.load"(%arg34) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<16xi8>
  %1330 = "llvm.load"(%1328) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<16xi8>
  %1331 = "llvm.getelementptr"(%1259) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1329, %1259) <{alignment = 1 : i64, ordering = 0 : i64}> : (vector<16xi8>, !llvm.ptr) -> ()
  "llvm.store"(%1330, %1331) <{alignment = 1 : i64, ordering = 0 : i64}> : (vector<16xi8>, !llvm.ptr) -> ()
  %1332 = "llvm.icmp"(%1327, %1224) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1332)[^bb23, ^bb21] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb21:  // pred: ^bb20
  %1333 = "llvm.getelementptr"(%arg34) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %1334 = "llvm.getelementptr"(%arg34) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 48>}> : (!llvm.ptr) -> !llvm.ptr
  %1335 = "llvm.load"(%1333) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<16xi8>
  %1336 = "llvm.load"(%1334) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<16xi8>
  %1337 = "llvm.getelementptr"(%1259) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %1338 = "llvm.getelementptr"(%1259) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 48>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1335, %1337) <{alignment = 1 : i64, ordering = 0 : i64}> : (vector<16xi8>, !llvm.ptr) -> ()
  "llvm.store"(%1336, %1338) <{alignment = 1 : i64, ordering = 0 : i64}> : (vector<16xi8>, !llvm.ptr) -> ()
  %1339 = "llvm.icmp"(%1327, %1211) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1339)[^bb23, ^bb22] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb22:  // pred: ^bb21
  %1340 = "llvm.getelementptr"(%arg34) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %1341 = "llvm.getelementptr"(%arg34) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 80>}> : (!llvm.ptr) -> !llvm.ptr
  %1342 = "llvm.load"(%1340) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<16xi8>
  %1343 = "llvm.load"(%1341) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<16xi8>
  %1344 = "llvm.getelementptr"(%1259) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %1345 = "llvm.getelementptr"(%1259) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 80>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1342, %1344) <{alignment = 1 : i64, ordering = 0 : i64}> : (vector<16xi8>, !llvm.ptr) -> ()
  "llvm.store"(%1343, %1345) <{alignment = 1 : i64, ordering = 0 : i64}> : (vector<16xi8>, !llvm.ptr) -> ()
  "llvm.br"()[^bb23] : () -> ()
^bb23:  // 3 preds: ^bb20, ^bb21, ^bb22
  %1346 = "llvm.icmp"(%arg35, %1327) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1346)[^bb56, ^bb24] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb24:  // pred: ^bb23
  %1347 = "llvm.icmp"(%1326, %1210) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1347, %1327, %1327)[^bb28, ^bb25] <{branch_weights = array<i32: 4, 28>, operandSegmentSizes = array<i32: 1, 1, 1>}> : (i1, i64, i64) -> ()
^bb25(%1348: i64):  // 2 preds: ^bb19, ^bb24
  %1349 = "llvm.and"(%arg35, %1235) : (i64, i64) -> i64
  "llvm.br"(%1348)[^bb26] : (i64) -> ()
^bb26(%1350: i64):  // 2 preds: ^bb25, ^bb26
  %1351 = "llvm.getelementptr"(%arg34, %1350) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1352 = "llvm.load"(%1351) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi8>
  %1353 = "llvm.getelementptr"(%1259, %1350) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%1352, %1353) <{alignment = 1 : i64, ordering = 0 : i64}> : (vector<4xi8>, !llvm.ptr) -> ()
  %1354 = "llvm.add"(%1350, %1228) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %1355 = "llvm.icmp"(%1354, %1349) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1355, %1354)[^bb27, ^bb26] <{loop_annotation = #loop_annotation2, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb27:  // pred: ^bb26
  %1356 = "llvm.icmp"(%arg35, %1349) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1356, %1349)[^bb56, ^bb28] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb28(%1357: i64):  // 4 preds: ^bb17, ^bb18, ^bb24, ^bb27
  %1358 = "llvm.and"(%arg35, %1212) : (i64, i64) -> i64
  %1359 = "llvm.icmp"(%1358, %1210) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1359, %1357, %1357, %1210)[^bb30, ^bb29] <{operandSegmentSizes = array<i32: 1, 1, 2>}> : (i1, i64, i64, i64) -> ()
^bb29(%1360: i64, %1361: i64):  // 2 preds: ^bb28, ^bb29
  %1362 = "llvm.getelementptr"(%arg34, %1360) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1363 = "llvm.load"(%1362) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1364 = "llvm.getelementptr"(%1259, %1360) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%1363, %1364) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1365 = "llvm.add"(%1360, %1229) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1366 = "llvm.add"(%1361, %1229) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1367 = "llvm.icmp"(%1366, %1358) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1367, %1365, %1365, %1366)[^bb30, ^bb29] <{loop_annotation = #loop_annotation3, operandSegmentSizes = array<i32: 1, 1, 2>}> : (i1, i64, i64, i64) -> ()
^bb30(%1368: i64):  // 2 preds: ^bb28, ^bb29
  %1369 = "llvm.sub"(%1357, %arg35) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1370 = "llvm.icmp"(%1369, %1235) <{predicate = 8 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1370, %1368)[^bb56, ^bb31] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb31(%1371: i64):  // 2 preds: ^bb30, ^bb31
  %1372 = "llvm.getelementptr"(%arg34, %1371) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1373 = "llvm.load"(%1372) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1374 = "llvm.getelementptr"(%1259, %1371) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%1373, %1374) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1375 = "llvm.add"(%1371, %1229) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1376 = "llvm.getelementptr"(%arg34, %1375) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1377 = "llvm.load"(%1376) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1378 = "llvm.getelementptr"(%1259, %1375) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%1377, %1378) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1379 = "llvm.add"(%1371, %1231) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1380 = "llvm.getelementptr"(%arg34, %1379) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1381 = "llvm.load"(%1380) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1382 = "llvm.getelementptr"(%1259, %1379) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%1381, %1382) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1383 = "llvm.add"(%1371, %1212) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1384 = "llvm.getelementptr"(%arg34, %1383) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1385 = "llvm.load"(%1384) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1386 = "llvm.getelementptr"(%1259, %1383) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%1385, %1386) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1387 = "llvm.add"(%1371, %1228) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1388 = "llvm.icmp"(%1387, %arg35) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1388, %1387)[^bb56, ^bb31] <{loop_annotation = #loop_annotation1, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb32(%1389: i64):  // 2 preds: ^bb16, ^bb32
  %1390 = "llvm.getelementptr"(%arg34, %1389) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1391 = "llvm.load"(%1390) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1392 = "llvm.getelementptr"(%1259, %1389) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%1391, %1392) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1393 = "llvm.add"(%1389, %1229) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1394 = "llvm.getelementptr"(%arg34, %1393) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1395 = "llvm.load"(%1394) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1396 = "llvm.getelementptr"(%1259, %1393) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%1395, %1396) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1397 = "llvm.add"(%1389, %1231) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1398 = "llvm.getelementptr"(%arg34, %1397) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1399 = "llvm.load"(%1398) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1400 = "llvm.getelementptr"(%1259, %1397) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%1399, %1400) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1401 = "llvm.add"(%1389, %1212) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1402 = "llvm.getelementptr"(%arg34, %1401) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1403 = "llvm.load"(%1402) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1404 = "llvm.getelementptr"(%1259, %1401) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%1403, %1404) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1405 = "llvm.add"(%1389, %1228) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1406 = "llvm.icmp"(%1405, %1256) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1406, %1405)[^bb33, ^bb32] <{loop_annotation = #loop_annotation1, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb33:  // 4 preds: ^bb9, ^bb13, ^bb16, ^bb32
  %1407 = "llvm.getelementptr"(%1241) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 640>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%arg33, %1258, %1241, %1407) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @SHA512_Transform, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  %1408 = "llvm.getelementptr"(%arg34, %1256) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1409 = "llvm.sub"(%arg35, %1256) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1410 = "llvm.icmp"(%1409, %1213) <{predicate = 8 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1410, %1408, %1409, %1409, %1408)[^bb53, ^bb34] <{operandSegmentSizes = array<i32: 1, 2, 2>}> : (i1, !llvm.ptr, i64, i64, !llvm.ptr) -> ()
^bb34(%1411: i64, %1412: !llvm.ptr):  // 2 preds: ^bb33, ^bb53
  %1413 = "llvm.ptrtoaddr"(%1412) : (!llvm.ptr) -> i64
  %1414 = "llvm.icmp"(%1411, %1210) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1414)[^bb55, ^bb35] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb35:  // pred: ^bb34
  %1415 = "llvm.icmp"(%1411, %1228) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1415, %1210)[^bb50, ^bb36] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
^bb36:  // pred: ^bb35
  %1416 = "llvm.sub"(%1240, %1413) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1417 = "llvm.add"(%1416, %1218) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1418 = "llvm.icmp"(%1417, %1233) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1418, %1210)[^bb50, ^bb37] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
^bb37:  // pred: ^bb36
  %1419 = "llvm.icmp"(%1411, %1223) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1419, %1210)[^bb47, ^bb38] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
^bb38:  // pred: ^bb37
  %1420 = "llvm.and"(%1411, %1234) : (i64, i64) -> i64
  %1421 = "llvm.and"(%1411, %1226) : (i64, i64) -> i64
  %1422 = "llvm.getelementptr"(%1412) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %1423 = "llvm.load"(%1412) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi8>
  %1424 = "llvm.load"(%1422) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi8>
  %1425 = "llvm.getelementptr"(%arg33) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 88>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1423, %1258) <{alignment = 8 : i64, ordering = 0 : i64}> : (vector<8xi8>, !llvm.ptr) -> ()
  "llvm.store"(%1424, %1425) <{alignment = 8 : i64, ordering = 0 : i64}> : (vector<8xi8>, !llvm.ptr) -> ()
  %1426 = "llvm.icmp"(%1421, %1223) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1426)[^bb45, ^bb39] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb39:  // pred: ^bb38
  %1427 = "llvm.getelementptr"(%1412) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %1428 = "llvm.getelementptr"(%1412) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %1429 = "llvm.load"(%1427) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi8>
  %1430 = "llvm.load"(%1428) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi8>
  %1431 = "llvm.getelementptr"(%arg33) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %1432 = "llvm.getelementptr"(%arg33) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 104>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1429, %1431) <{alignment = 8 : i64, ordering = 0 : i64}> : (vector<8xi8>, !llvm.ptr) -> ()
  "llvm.store"(%1430, %1432) <{alignment = 8 : i64, ordering = 0 : i64}> : (vector<8xi8>, !llvm.ptr) -> ()
  %1433 = "llvm.icmp"(%1421, %1224) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1433)[^bb45, ^bb40] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb40:  // pred: ^bb39
  %1434 = "llvm.getelementptr"(%1412) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %1435 = "llvm.getelementptr"(%1412) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  %1436 = "llvm.load"(%1434) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi8>
  %1437 = "llvm.load"(%1435) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi8>
  %1438 = "llvm.getelementptr"(%arg33) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 112>}> : (!llvm.ptr) -> !llvm.ptr
  %1439 = "llvm.getelementptr"(%arg33) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 120>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1436, %1438) <{alignment = 8 : i64, ordering = 0 : i64}> : (vector<8xi8>, !llvm.ptr) -> ()
  "llvm.store"(%1437, %1439) <{alignment = 8 : i64, ordering = 0 : i64}> : (vector<8xi8>, !llvm.ptr) -> ()
  %1440 = "llvm.icmp"(%1421, %1225) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1440)[^bb45, ^bb41] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb41:  // pred: ^bb40
  %1441 = "llvm.getelementptr"(%1412) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 48>}> : (!llvm.ptr) -> !llvm.ptr
  %1442 = "llvm.getelementptr"(%1412) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 56>}> : (!llvm.ptr) -> !llvm.ptr
  %1443 = "llvm.load"(%1441) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi8>
  %1444 = "llvm.load"(%1442) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi8>
  %1445 = "llvm.getelementptr"(%arg33) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %1446 = "llvm.getelementptr"(%arg33) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 136>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1443, %1445) <{alignment = 8 : i64, ordering = 0 : i64}> : (vector<8xi8>, !llvm.ptr) -> ()
  "llvm.store"(%1444, %1446) <{alignment = 8 : i64, ordering = 0 : i64}> : (vector<8xi8>, !llvm.ptr) -> ()
  %1447 = "llvm.icmp"(%1421, %1211) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1447)[^bb45, ^bb42] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb42:  // pred: ^bb41
  %1448 = "llvm.getelementptr"(%1412) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %1449 = "llvm.getelementptr"(%1412) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 72>}> : (!llvm.ptr) -> !llvm.ptr
  %1450 = "llvm.load"(%1448) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi8>
  %1451 = "llvm.load"(%1449) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi8>
  %1452 = "llvm.getelementptr"(%arg33) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 144>}> : (!llvm.ptr) -> !llvm.ptr
  %1453 = "llvm.getelementptr"(%arg33) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 152>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1450, %1452) <{alignment = 8 : i64, ordering = 0 : i64}> : (vector<8xi8>, !llvm.ptr) -> ()
  "llvm.store"(%1451, %1453) <{alignment = 8 : i64, ordering = 0 : i64}> : (vector<8xi8>, !llvm.ptr) -> ()
  %1454 = "llvm.icmp"(%1421, %1216) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1454)[^bb45, ^bb43] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb43:  // pred: ^bb42
  %1455 = "llvm.getelementptr"(%1412) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 80>}> : (!llvm.ptr) -> !llvm.ptr
  %1456 = "llvm.getelementptr"(%1412) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 88>}> : (!llvm.ptr) -> !llvm.ptr
  %1457 = "llvm.load"(%1455) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi8>
  %1458 = "llvm.load"(%1456) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi8>
  %1459 = "llvm.getelementptr"(%arg33) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 160>}> : (!llvm.ptr) -> !llvm.ptr
  %1460 = "llvm.getelementptr"(%arg33) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 168>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1457, %1459) <{alignment = 8 : i64, ordering = 0 : i64}> : (vector<8xi8>, !llvm.ptr) -> ()
  "llvm.store"(%1458, %1460) <{alignment = 8 : i64, ordering = 0 : i64}> : (vector<8xi8>, !llvm.ptr) -> ()
  %1461 = "llvm.icmp"(%1421, %1220) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1461)[^bb45, ^bb44] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb44:  // pred: ^bb43
  %1462 = "llvm.getelementptr"(%1412) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %1463 = "llvm.getelementptr"(%1412) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 104>}> : (!llvm.ptr) -> !llvm.ptr
  %1464 = "llvm.load"(%1462) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi8>
  %1465 = "llvm.load"(%1463) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi8>
  %1466 = "llvm.getelementptr"(%arg33) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 176>}> : (!llvm.ptr) -> !llvm.ptr
  %1467 = "llvm.getelementptr"(%arg33) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 184>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1464, %1466) <{alignment = 8 : i64, ordering = 0 : i64}> : (vector<8xi8>, !llvm.ptr) -> ()
  "llvm.store"(%1465, %1467) <{alignment = 8 : i64, ordering = 0 : i64}> : (vector<8xi8>, !llvm.ptr) -> ()
  "llvm.br"()[^bb45] : () -> ()
^bb45:  // 7 preds: ^bb38, ^bb39, ^bb40, ^bb41, ^bb42, ^bb43, ^bb44
  %1468 = "llvm.icmp"(%1411, %1421) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1468)[^bb55, ^bb46] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb46:  // pred: ^bb45
  %1469 = "llvm.icmp"(%1420, %1210) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1469, %1421, %1421)[^bb50, ^bb47] <{branch_weights = array<i32: 4, 12>, operandSegmentSizes = array<i32: 1, 1, 1>}> : (i1, i64, i64) -> ()
^bb47(%1470: i64):  // 2 preds: ^bb37, ^bb46
  %1471 = "llvm.and"(%1411, %1217) : (i64, i64) -> i64
  "llvm.br"(%1470)[^bb48] : (i64) -> ()
^bb48(%1472: i64):  // 2 preds: ^bb47, ^bb48
  %1473 = "llvm.getelementptr"(%1412, %1472) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1474 = "llvm.load"(%1473) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi8>
  %1475 = "llvm.getelementptr"(%1258, %1472) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%1474, %1475) <{alignment = 1 : i64, ordering = 0 : i64}> : (vector<4xi8>, !llvm.ptr) -> ()
  %1476 = "llvm.add"(%1472, %1228) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %1477 = "llvm.icmp"(%1476, %1471) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1477, %1476)[^bb49, ^bb48] <{loop_annotation = #loop_annotation2, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb49:  // pred: ^bb48
  %1478 = "llvm.icmp"(%1411, %1471) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1478, %1471)[^bb55, ^bb50] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb50(%1479: i64):  // 4 preds: ^bb35, ^bb36, ^bb46, ^bb49
  %1480 = "llvm.and"(%1411, %1212) : (i64, i64) -> i64
  %1481 = "llvm.icmp"(%1480, %1210) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1481, %1479, %1479, %1210)[^bb52, ^bb51] <{operandSegmentSizes = array<i32: 1, 1, 2>}> : (i1, i64, i64, i64) -> ()
^bb51(%1482: i64, %1483: i64):  // 2 preds: ^bb50, ^bb51
  %1484 = "llvm.getelementptr"(%1412, %1482) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1485 = "llvm.load"(%1484) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1486 = "llvm.getelementptr"(%1258, %1482) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%1485, %1486) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1487 = "llvm.add"(%1482, %1229) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1488 = "llvm.add"(%1483, %1229) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1489 = "llvm.icmp"(%1488, %1480) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1489, %1487, %1487, %1488)[^bb52, ^bb51] <{loop_annotation = #loop_annotation3, operandSegmentSizes = array<i32: 1, 1, 2>}> : (i1, i64, i64, i64) -> ()
^bb52(%1490: i64):  // 2 preds: ^bb50, ^bb51
  %1491 = "llvm.sub"(%1479, %1411) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1492 = "llvm.icmp"(%1491, %1235) <{predicate = 8 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1492, %1490)[^bb55, ^bb54] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb53(%1493: !llvm.ptr, %1494: i64):  // 2 preds: ^bb33, ^bb53
  "llvm.call"(%arg33, %1493, %1241, %1407) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @SHA512_Transform, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  %1495 = "llvm.getelementptr"(%1493) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %1496 = "llvm.add"(%1494, %1232) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1497 = "llvm.icmp"(%1496, %1213) <{predicate = 8 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1497, %1495, %1496, %1496, %1495)[^bb53, ^bb34] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 2, 2>}> : (i1, !llvm.ptr, i64, i64, !llvm.ptr) -> ()
^bb54(%1498: i64):  // 2 preds: ^bb52, ^bb54
  %1499 = "llvm.getelementptr"(%1412, %1498) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1500 = "llvm.load"(%1499) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1501 = "llvm.getelementptr"(%1258, %1498) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%1500, %1501) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1502 = "llvm.add"(%1498, %1229) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1503 = "llvm.getelementptr"(%1412, %1502) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1504 = "llvm.load"(%1503) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1505 = "llvm.getelementptr"(%1258, %1502) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%1504, %1505) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1506 = "llvm.add"(%1498, %1231) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1507 = "llvm.getelementptr"(%1412, %1506) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1508 = "llvm.load"(%1507) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1509 = "llvm.getelementptr"(%1258, %1506) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%1508, %1509) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1510 = "llvm.add"(%1498, %1212) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1511 = "llvm.getelementptr"(%1412, %1510) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1512 = "llvm.load"(%1511) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1513 = "llvm.getelementptr"(%1258, %1510) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%1512, %1513) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1514 = "llvm.add"(%1498, %1228) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1515 = "llvm.icmp"(%1514, %1411) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1515, %1514)[^bb55, ^bb54] <{loop_annotation = #loop_annotation1, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb55:  // 5 preds: ^bb34, ^bb45, ^bb49, ^bb52, ^bb54
  "llvm.call"(%1241, %1236) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @sodium_memzero, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, i64) -> ()
  "llvm.br"()[^bb56] : () -> ()
^bb56:  // 6 preds: ^bb0, ^bb23, ^bb27, ^bb30, ^bb31, ^bb55
  "llvm.intr.lifetime.end"(%1241) : (!llvm.ptr) -> ()
  "llvm.return"(%1238) : (i32) -> ()
}) : () -> ()
