module

-- agave-build/out/serial-noinline/op/_RNvXs5_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldRNtB5_14FieldElement51NtNtNtCsgxBkk5gSRhY_4core3ops5arith3Mul3mul.mlir
-- <&solana_ed25519[1fe0933b11699477]::backend::serial::u64::field::FieldElement51 as core[c0acaeba6ab4c2e0]::ops::arith::Mul>::mul

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Agave.Serial

@[expose] public section

mlir_def FieldElement51_Mul_mul :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 8 : i64, llvm.dead_on_unwind, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writable, llvm.writeonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], sym_name = "_RNvXs5_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldRNtB5_14FieldElement51NtNtNtCsgxBkk5gSRhY_4core3ops5arith3Mul3mul", target_cpu = "x86-64-v2", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg50: !llvm.ptr, %arg51: !llvm.ptr, %arg52: !llvm.ptr):
  %1284 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %1285 = "llvm.mlir.constant"() <{value = 51 : i128}> : () -> i128
  %1286 = "llvm.mlir.constant"() <{value = 18446744073709551615 : i128}> : () -> i128
  %1287 = "llvm.mlir.constant"() <{value = 2251799813685247 : i64}> : () -> i64
  %1288 = "llvm.mlir.constant"() <{value = 51 : i64}> : () -> i64
  %1289 = "llvm.getelementptr"(%arg52) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %1290 = "llvm.load"(%1289) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1291 = "llvm.mul"(%1290, %1284) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1292 = "llvm.getelementptr"(%arg52) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %1293 = "llvm.load"(%1292) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1294 = "llvm.mul"(%1293, %1284) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1295 = "llvm.getelementptr"(%arg52) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %1296 = "llvm.load"(%1295) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1297 = "llvm.mul"(%1296, %1284) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1298 = "llvm.getelementptr"(%arg52) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %1299 = "llvm.load"(%1298) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1300 = "llvm.mul"(%1299, %1284) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1301 = "llvm.load"(%arg51) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1302 = "llvm.load"(%arg52) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1303 = "llvm.zext"(%1301) : (i64) -> i128
  %1304 = "llvm.zext"(%1302) : (i64) -> i128
  %1305 = "llvm.mul"(%1304, %1303) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1306 = "llvm.getelementptr"(%arg51) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %1307 = "llvm.load"(%1306) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1308 = "llvm.zext"(%1307) : (i64) -> i128
  %1309 = "llvm.zext"(%1291) : (i64) -> i128
  %1310 = "llvm.mul"(%1308, %1309) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1311 = "llvm.add"(%1310, %1305) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1312 = "llvm.getelementptr"(%arg51) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %1313 = "llvm.load"(%1312) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1314 = "llvm.zext"(%1313) : (i64) -> i128
  %1315 = "llvm.zext"(%1294) : (i64) -> i128
  %1316 = "llvm.mul"(%1314, %1315) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1317 = "llvm.add"(%1311, %1316) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1318 = "llvm.getelementptr"(%arg51) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %1319 = "llvm.load"(%1318) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1320 = "llvm.zext"(%1319) : (i64) -> i128
  %1321 = "llvm.zext"(%1297) : (i64) -> i128
  %1322 = "llvm.mul"(%1320, %1321) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1323 = "llvm.add"(%1317, %1322) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1324 = "llvm.getelementptr"(%arg51) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %1325 = "llvm.load"(%1324) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1326 = "llvm.zext"(%1325) : (i64) -> i128
  %1327 = "llvm.zext"(%1300) : (i64) -> i128
  %1328 = "llvm.mul"(%1326, %1327) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1329 = "llvm.add"(%1323, %1328) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1330 = "llvm.mul"(%1326, %1304) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1331 = "llvm.zext"(%1290) : (i64) -> i128
  %1332 = "llvm.mul"(%1303, %1331) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1333 = "llvm.mul"(%1308, %1315) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1334 = "llvm.mul"(%1314, %1321) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1335 = "llvm.mul"(%1320, %1327) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1336 = "llvm.mul"(%1320, %1304) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1337 = "llvm.mul"(%1326, %1331) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1338 = "llvm.zext"(%1293) : (i64) -> i128
  %1339 = "llvm.mul"(%1303, %1338) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1340 = "llvm.mul"(%1308, %1321) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1341 = "llvm.mul"(%1314, %1327) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1342 = "llvm.mul"(%1314, %1304) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1343 = "llvm.mul"(%1320, %1331) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1344 = "llvm.mul"(%1326, %1338) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1345 = "llvm.zext"(%1296) : (i64) -> i128
  %1346 = "llvm.mul"(%1303, %1345) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1347 = "llvm.mul"(%1308, %1327) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1348 = "llvm.mul"(%1308, %1304) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1349 = "llvm.mul"(%1314, %1331) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1350 = "llvm.mul"(%1320, %1338) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1351 = "llvm.mul"(%1326, %1345) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1352 = "llvm.zext"(%1299) : (i64) -> i128
  %1353 = "llvm.mul"(%1303, %1352) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %1354 = "llvm.lshr"(%1329, %1285) : (i128, i128) -> i128
  %1355 = "llvm.and"(%1354, %1286) : (i128, i128) -> i128
  %1356 = "llvm.add"(%1333, %1332) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1357 = "llvm.add"(%1356, %1334) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1358 = "llvm.add"(%1357, %1335) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1359 = "llvm.add"(%1358, %1330) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1360 = "llvm.add"(%1359, %1355) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1361 = "llvm.trunc"(%1329) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %1362 = "llvm.and"(%1361, %1287) : (i64, i64) -> i64
  %1363 = "llvm.lshr"(%1360, %1285) : (i128, i128) -> i128
  %1364 = "llvm.and"(%1363, %1286) : (i128, i128) -> i128
  %1365 = "llvm.add"(%1340, %1339) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1366 = "llvm.add"(%1365, %1341) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1367 = "llvm.add"(%1366, %1336) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1368 = "llvm.add"(%1367, %1337) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1369 = "llvm.add"(%1368, %1364) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1370 = "llvm.trunc"(%1360) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %1371 = "llvm.and"(%1370, %1287) : (i64, i64) -> i64
  %1372 = "llvm.lshr"(%1369, %1285) : (i128, i128) -> i128
  %1373 = "llvm.and"(%1372, %1286) : (i128, i128) -> i128
  %1374 = "llvm.add"(%1347, %1346) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1375 = "llvm.add"(%1374, %1342) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1376 = "llvm.add"(%1375, %1343) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1377 = "llvm.add"(%1376, %1344) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1378 = "llvm.add"(%1377, %1373) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1379 = "llvm.trunc"(%1369) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %1380 = "llvm.and"(%1379, %1287) : (i64, i64) -> i64
  %1381 = "llvm.lshr"(%1378, %1285) : (i128, i128) -> i128
  %1382 = "llvm.and"(%1381, %1286) : (i128, i128) -> i128
  %1383 = "llvm.add"(%1348, %1353) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1384 = "llvm.add"(%1383, %1349) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1385 = "llvm.add"(%1384, %1350) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1386 = "llvm.add"(%1385, %1351) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1387 = "llvm.add"(%1386, %1382) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %1388 = "llvm.trunc"(%1378) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %1389 = "llvm.and"(%1388, %1287) : (i64, i64) -> i64
  %1390 = "llvm.lshr"(%1387, %1285) : (i128, i128) -> i128
  %1391 = "llvm.trunc"(%1390) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %1392 = "llvm.trunc"(%1387) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %1393 = "llvm.and"(%1392, %1287) : (i64, i64) -> i64
  %1394 = "llvm.mul"(%1391, %1284) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1395 = "llvm.add"(%1394, %1362) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1396 = "llvm.lshr"(%1395, %1288) : (i64, i64) -> i64
  %1397 = "llvm.add"(%1396, %1371) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1398 = "llvm.and"(%1395, %1287) : (i64, i64) -> i64
  "llvm.store"(%1398, %arg50) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1399 = "llvm.getelementptr"(%arg50) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1397, %1399) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1400 = "llvm.getelementptr"(%arg50) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1380, %1400) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1401 = "llvm.getelementptr"(%arg50) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1389, %1401) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1402 = "llvm.getelementptr"(%arg50) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1393, %1402) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end MLIR.Agave.Serial
