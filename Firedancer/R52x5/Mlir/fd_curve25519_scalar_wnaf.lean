module

-- ~/fd-pr9879/build/llvm23-production/mlir_canonicalized/avx512/op/fd_curve25519_scalar_wnaf.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.R52x5.Mlir.fd_int_min

meta import MLIR.Semantics.Func
meta import Firedancer.R52x5.Mlir.fd_int_min

namespace MLIR.Firedancer.R52x5

@[expose] public section

mlir_def fd_curve25519_scalar_wnaf :=
#loop_annotation = #llvm.loop_annotation<mustProgress = true>
#tbaa_root = #llvm.tbaa_root<id = "Simple C/C++ TBAA">
#tbaa_type_desc = #llvm.tbaa_type_desc<id = "omnipotent char", members = {<#tbaa_root, 0>}>
#tbaa_tag = #llvm.tbaa_tag<base_type = #tbaa_type_desc, access_type = #tbaa_type_desc, offset = 0>
#tbaa_type_desc2 = #llvm.tbaa_type_desc<id = "short", members = {<#tbaa_type_desc, 0>}>
#tbaa_tag2 = #llvm.tbaa_tag<base_type = #tbaa_type_desc2, access_type = #tbaa_type_desc2, offset = 0>
"llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.noundef}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr, i32)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], sym_name = "fd_curve25519_scalar_wnaf", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg62: !llvm.ptr, %arg63: !llvm.ptr, %arg64: i32):
  %1302 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %1303 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %1304 = "llvm.mlir.constant"() <{value = 536870911 : i64}> : () -> i64
  %1305 = "llvm.mlir.constant"() <{value = 7 : i16}> : () -> i16
  %1306 = "llvm.mlir.constant"() <{value = 1 : i16}> : () -> i16
  %1307 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %1308 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %1309 = "llvm.mlir.constant"() <{value = 4 : i64}> : () -> i64
  %1310 = "llvm.mlir.constant"() <{value = 5 : i64}> : () -> i64
  %1311 = "llvm.mlir.constant"() <{value = 255 : i64}> : () -> i64
  %1312 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
  %1313 = "llvm.mlir.constant"() <{value = 0 : i16}> : () -> i16
  %1314 = "llvm.mlir.constant"() <{value = 6 : i64}> : () -> i64
  %1315 = "llvm.mlir.constant"() <{value = 7 : i64}> : () -> i64
  %1316 = "llvm.mlir.constant"() <{value = 256 : i64}> : () -> i64
  %1317 = "llvm.mlir.constant"() <{value = 16 : i32}> : () -> i32
  %1318 = "llvm.mlir.constant"() <{value = 15 : i32}> : () -> i32
  %1319 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %1320 = "llvm.mlir.constant"() <{value = 255 : i32}> : () -> i32
  %1321 = "llvm.mlir.constant"() <{value = 65536 : i32}> : () -> i32
  %1322 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %1323 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1324 = "llvm.mlir.constant"() <{value = 256 : i32}> : () -> i32
  %1325 = "llvm.mlir.constant"() <{value = 8 : i64}> : () -> i64
  "llvm.br"(%1302)[^bb2] : (i64) -> ()
^bb1:  // pred: ^bb2
  %1326 = "llvm.shl"(%1312, %arg64) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %1327 = "llvm.xor"(%1326, %1312) : (i32, i32) -> i32
  %1328 = "llvm.getelementptr"(%arg62) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 510>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1313, %1328) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (i16, !llvm.ptr) -> ()
  "llvm.br"(%1302)[^bb3] : (i64) -> ()
^bb2(%1329: i64):  // 2 preds: ^bb0, ^bb2
  %1330 = "llvm.trunc"(%1329) <{overflowFlags = 0 : i32}> : (i64) -> i16
  %1331 = "llvm.lshr"(%1329, %1303) : (i64, i64) -> i64
  %1332 = "llvm.and"(%1331, %1304) : (i64, i64) -> i64
  %1333 = "llvm.getelementptr"(%arg63, %1332) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1334 = "llvm.load"(%1333) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> i8
  %1335 = "llvm.zext"(%1334) : (i8) -> i16
  %1336 = "llvm.and"(%1330, %1305) : (i16, i16) -> i16
  %1337 = "llvm.lshr"(%1335, %1336) : (i16, i16) -> i16
  %1338 = "llvm.and"(%1337, %1306) : (i16, i16) -> i16
  %1339 = "llvm.getelementptr"(%arg62, %1329) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%1338, %1339) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (i16, !llvm.ptr) -> ()
  %1340 = "llvm.add"(%1329, %1307) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1341 = "llvm.trunc"(%1340) <{overflowFlags = 0 : i32}> : (i64) -> i16
  %1342 = "llvm.lshr"(%1340, %1303) : (i64, i64) -> i64
  %1343 = "llvm.and"(%1342, %1304) : (i64, i64) -> i64
  %1344 = "llvm.getelementptr"(%arg63, %1343) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1345 = "llvm.load"(%1344) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> i8
  %1346 = "llvm.zext"(%1345) : (i8) -> i16
  %1347 = "llvm.and"(%1341, %1305) : (i16, i16) -> i16
  %1348 = "llvm.lshr"(%1346, %1347) : (i16, i16) -> i16
  %1349 = "llvm.and"(%1348, %1306) : (i16, i16) -> i16
  %1350 = "llvm.getelementptr"(%arg62, %1340) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%1349, %1350) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (i16, !llvm.ptr) -> ()
  %1351 = "llvm.add"(%1329, %1308) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1352 = "llvm.trunc"(%1351) <{overflowFlags = 0 : i32}> : (i64) -> i16
  %1353 = "llvm.lshr"(%1351, %1303) : (i64, i64) -> i64
  %1354 = "llvm.and"(%1353, %1304) : (i64, i64) -> i64
  %1355 = "llvm.getelementptr"(%arg63, %1354) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1356 = "llvm.load"(%1355) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> i8
  %1357 = "llvm.zext"(%1356) : (i8) -> i16
  %1358 = "llvm.and"(%1352, %1305) : (i16, i16) -> i16
  %1359 = "llvm.lshr"(%1357, %1358) : (i16, i16) -> i16
  %1360 = "llvm.and"(%1359, %1306) : (i16, i16) -> i16
  %1361 = "llvm.getelementptr"(%arg62, %1351) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%1360, %1361) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (i16, !llvm.ptr) -> ()
  %1362 = "llvm.add"(%1329, %1303) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1363 = "llvm.trunc"(%1362) <{overflowFlags = 0 : i32}> : (i64) -> i16
  %1364 = "llvm.lshr"(%1362, %1303) : (i64, i64) -> i64
  %1365 = "llvm.and"(%1364, %1304) : (i64, i64) -> i64
  %1366 = "llvm.getelementptr"(%arg63, %1365) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1367 = "llvm.load"(%1366) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> i8
  %1368 = "llvm.zext"(%1367) : (i8) -> i16
  %1369 = "llvm.and"(%1363, %1305) : (i16, i16) -> i16
  %1370 = "llvm.lshr"(%1368, %1369) : (i16, i16) -> i16
  %1371 = "llvm.and"(%1370, %1306) : (i16, i16) -> i16
  %1372 = "llvm.getelementptr"(%arg62, %1362) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%1371, %1372) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (i16, !llvm.ptr) -> ()
  %1373 = "llvm.add"(%1329, %1309) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1374 = "llvm.trunc"(%1373) <{overflowFlags = 0 : i32}> : (i64) -> i16
  %1375 = "llvm.lshr"(%1373, %1303) : (i64, i64) -> i64
  %1376 = "llvm.and"(%1375, %1304) : (i64, i64) -> i64
  %1377 = "llvm.getelementptr"(%arg63, %1376) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1378 = "llvm.load"(%1377) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> i8
  %1379 = "llvm.zext"(%1378) : (i8) -> i16
  %1380 = "llvm.and"(%1374, %1305) : (i16, i16) -> i16
  %1381 = "llvm.lshr"(%1379, %1380) : (i16, i16) -> i16
  %1382 = "llvm.and"(%1381, %1306) : (i16, i16) -> i16
  %1383 = "llvm.getelementptr"(%arg62, %1373) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%1382, %1383) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (i16, !llvm.ptr) -> ()
  %1384 = "llvm.add"(%1329, %1310) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1385 = "llvm.icmp"(%1384, %1311) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1385, %1384)[^bb1, ^bb2] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb3(%1386: i64):  // 2 preds: ^bb1, ^bb11
  %1387 = "llvm.getelementptr"(%arg62, %1386) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1388 = "llvm.load"(%1387) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (!llvm.ptr) -> i16
  %1389 = "llvm.icmp"(%1388, %1313) <{predicate = 0 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%1389, %1386)[^bb4, ^bb12] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb4:  // pred: ^bb3
  %1390 = "llvm.or"(%1386, %1307) <{isDisjoint}> : (i64, i64) -> i64
  %1391 = "llvm.getelementptr"(%arg62, %1390) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1392 = "llvm.load"(%1391) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (!llvm.ptr) -> i16
  %1393 = "llvm.icmp"(%1392, %1313) <{predicate = 0 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%1393, %1390)[^bb5, ^bb12] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb5:  // pred: ^bb4
  %1394 = "llvm.or"(%1386, %1308) <{isDisjoint}> : (i64, i64) -> i64
  %1395 = "llvm.getelementptr"(%arg62, %1394) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1396 = "llvm.load"(%1395) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (!llvm.ptr) -> i16
  %1397 = "llvm.icmp"(%1396, %1313) <{predicate = 0 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%1397, %1394)[^bb6, ^bb12] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb6:  // pred: ^bb5
  %1398 = "llvm.or"(%1386, %1303) <{isDisjoint}> : (i64, i64) -> i64
  %1399 = "llvm.getelementptr"(%arg62, %1398) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1400 = "llvm.load"(%1399) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (!llvm.ptr) -> i16
  %1401 = "llvm.icmp"(%1400, %1313) <{predicate = 0 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%1401, %1398)[^bb7, ^bb12] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb7:  // pred: ^bb6
  %1402 = "llvm.or"(%1386, %1309) <{isDisjoint}> : (i64, i64) -> i64
  %1403 = "llvm.getelementptr"(%arg62, %1402) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1404 = "llvm.load"(%1403) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (!llvm.ptr) -> i16
  %1405 = "llvm.icmp"(%1404, %1313) <{predicate = 0 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%1405, %1402)[^bb8, ^bb12] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb8:  // pred: ^bb7
  %1406 = "llvm.or"(%1386, %1310) <{isDisjoint}> : (i64, i64) -> i64
  %1407 = "llvm.getelementptr"(%arg62, %1406) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1408 = "llvm.load"(%1407) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (!llvm.ptr) -> i16
  %1409 = "llvm.icmp"(%1408, %1313) <{predicate = 0 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%1409, %1406)[^bb9, ^bb12] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb9:  // pred: ^bb8
  %1410 = "llvm.or"(%1386, %1314) <{isDisjoint}> : (i64, i64) -> i64
  %1411 = "llvm.getelementptr"(%arg62, %1410) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1412 = "llvm.load"(%1411) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (!llvm.ptr) -> i16
  %1413 = "llvm.icmp"(%1412, %1313) <{predicate = 0 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%1413, %1410)[^bb10, ^bb12] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb10:  // pred: ^bb9
  %1414 = "llvm.or"(%1386, %1315) <{isDisjoint}> : (i64, i64) -> i64
  %1415 = "llvm.getelementptr"(%arg62, %1414) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1416 = "llvm.load"(%1415) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (!llvm.ptr) -> i16
  %1417 = "llvm.icmp"(%1416, %1313) <{predicate = 0 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%1417, %1414)[^bb11, ^bb12] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb11:  // pred: ^bb10
  %1418 = "llvm.add"(%1386, %1325) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1419 = "llvm.icmp"(%1418, %1316) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1419, %1418)[^bb27, ^bb3] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb12(%1420: i64):  // 8 preds: ^bb3, ^bb4, ^bb5, ^bb6, ^bb7, ^bb8, ^bb9, ^bb10
  %1421 = "llvm.icmp"(%1420, %1316) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1421)[^bb13, ^bb27] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb13:  // pred: ^bb12
  %1422 = "llvm.trunc"(%1420) <{overflowFlags = 3 : i32}> : (i64) -> i32
  %1423 = "llvm.shl"(%1327, %1317) <{overflowFlags = 0 : i32}> : (i32, i32) -> i32
  %1424 = "llvm.ashr"(%1423, %1317) <{isExact}> : (i32, i32) -> i32
  %1425 = "llvm.ashr"(%1423, %1318) <{isExact}> : (i32, i32) -> i32
  %1426 = "llvm.sub"(%1319, %1424) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  "llvm.br"(%1422)[^bb14] : (i32) -> ()
^bb14(%1427: i32):  // 2 preds: ^bb13, ^bb26
  %1428 = "llvm.icmp"(%1427, %1320) <{predicate = 2 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%1428, %1311, %1306)[^bb15, ^bb25] <{operandSegmentSizes = array<i32: 1, 0, 2>}> : (i1, i64, i16) -> ()
^bb15:  // pred: ^bb14
  %1429 = "llvm.sext"(%1427) : (i32) -> i64
  "llvm.br"(%1429, %1306)[^bb16] : (i64, i16) -> ()
^bb16(%1430: i64, %1431: i16):  // 2 preds: ^bb15, ^bb24
  %1432 = "llvm.add"(%1430, %1307) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1433 = "llvm.getelementptr"(%arg62, %1432) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1434 = "llvm.load"(%1433) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (!llvm.ptr) -> i16
  %1435 = "llvm.icmp"(%1434, %1313) <{predicate = 0 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%1435, %1431)[^bb24, ^bb17] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i16) -> ()
^bb17:  // pred: ^bb16
  %1436 = "llvm.trunc"(%1432) <{overflowFlags = 1 : i32}> : (i64) -> i32
  %1437 = "llvm.sub"(%1436, %1427) <{overflowFlags = 0 : i32}> : (i32, i32) -> i32
  %1438 = "llvm.call"(%1437) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_int_min, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (i32) -> i32
  %1439 = "llvm.shl"(%1321, %1438) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %1440 = "llvm.lshr"(%1439, %1317) <{isExact}> : (i32, i32) -> i32
  %1441 = "llvm.icmp"(%1440, %1425) <{predicate = 4 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%1441, %1436, %1431)[^bb26, ^bb18] <{operandSegmentSizes = array<i32: 1, 2, 0>}> : (i1, i32, i16) -> ()
^bb18:  // pred: ^bb17
  %1442 = "llvm.trunc"(%1440) <{overflowFlags = 3 : i32}> : (i32) -> i16
  %1443 = "llvm.add"(%1431, %1442) <{overflowFlags = 0 : i32}> : (i16, i16) -> i16
  %1444 = "llvm.sext"(%1443) : (i16) -> i32
  %1445 = "llvm.icmp"(%1424, %1444) <{predicate = 2 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%1445)[^bb20, ^bb19] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb19:  // pred: ^bb18
  "llvm.store"(%1313, %1433) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (i16, !llvm.ptr) -> ()
  "llvm.br"(%1443)[^bb24] : (i16) -> ()
^bb20:  // pred: ^bb18
  %1446 = "llvm.sub"(%1431, %1442) <{overflowFlags = 0 : i32}> : (i16, i16) -> i16
  %1447 = "llvm.sext"(%1446) : (i16) -> i32
  %1448 = "llvm.icmp"(%1447, %1426) <{predicate = 2 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%1448, %1436, %1431)[^bb26, ^bb21] <{operandSegmentSizes = array<i32: 1, 2, 0>}> : (i1, i32, i16) -> ()
^bb21:  // pred: ^bb20
  %1449 = "llvm.trunc"(%1430) <{overflowFlags = 1 : i32}> : (i64) -> i32
  "llvm.store"(%1313, %1433) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (i16, !llvm.ptr) -> ()
  %1450 = "llvm.add"(%1449, %1322) <{overflowFlags = 0 : i32}> : (i32, i32) -> i32
  %1451 = "llvm.sext"(%1450) : (i32) -> i64
  %1452 = "llvm.getelementptr"(%arg62, %1451) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1453 = "llvm.load"(%1452) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (!llvm.ptr) -> i16
  %1454 = "llvm.icmp"(%1453, %1313) <{predicate = 0 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%1454, %1450, %1452, %1452, %1450)[^bb22, ^bb23] <{operandSegmentSizes = array<i32: 1, 2, 2>}> : (i1, i32, !llvm.ptr, !llvm.ptr, i32) -> ()
^bb22(%1455: i32, %1456: !llvm.ptr):  // 2 preds: ^bb21, ^bb23
  "llvm.store"(%1306, %1456) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (i16, !llvm.ptr) -> ()
  "llvm.br"(%1455, %1446)[^bb26] : (i32, i16) -> ()
^bb23(%1457: !llvm.ptr, %1458: i32):  // 2 preds: ^bb21, ^bb23
  "llvm.store"(%1313, %1457) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (i16, !llvm.ptr) -> ()
  %1459 = "llvm.add"(%1458, %1323) <{overflowFlags = 0 : i32}> : (i32, i32) -> i32
  %1460 = "llvm.sext"(%1459) : (i32) -> i64
  %1461 = "llvm.getelementptr"(%arg62, %1460) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1462 = "llvm.load"(%1461) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (!llvm.ptr) -> i16
  %1463 = "llvm.icmp"(%1462, %1313) <{predicate = 0 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%1463, %1459, %1461, %1461, %1459)[^bb22, ^bb23] <{operandSegmentSizes = array<i32: 1, 2, 2>}> : (i1, i32, !llvm.ptr, !llvm.ptr, i32) -> ()
^bb24(%1464: i16):  // 2 preds: ^bb16, ^bb19
  %1465 = "llvm.icmp"(%1432, %1311) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1465, %1429, %1464, %1432, %1464)[^bb25, ^bb16] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 2, 2>}> : (i1, i64, i16, i64, i16) -> ()
^bb25(%1466: i64, %1467: i16):  // 2 preds: ^bb14, ^bb24
  %1468 = "llvm.getelementptr"(%arg62, %1466) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%1467, %1468) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (i16, !llvm.ptr) -> ()
  "llvm.br"()[^bb27] : () -> ()
^bb26(%1469: i32, %1470: i16):  // 3 preds: ^bb17, ^bb20, ^bb22
  %1471 = "llvm.getelementptr"(%arg62, %1429) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%1470, %1471) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag2]}> : (i16, !llvm.ptr) -> ()
  %1472 = "llvm.icmp"(%1469, %1324) <{predicate = 2 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%1472, %1469)[^bb14, ^bb27] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i32) -> ()
^bb27:  // 4 preds: ^bb11, ^bb12, ^bb25, ^bb26
  "llvm.return"() : () -> ()
}) : () -> ()
  with @fd_int_min := fd_int_min

end

end MLIR.Firedancer.R52x5
