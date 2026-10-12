module

-- agave-build/out/serial-noinline-big/op/_RNvMs2_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar528to_bytes.mlir
-- <solana_ed25519[1fe0933b11699477]::backend::serial::u64::scalar::Scalar52>::to_bytes

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Agave.Serial

@[expose] public section

mlir_def Scalar52_to_bytes :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 1 : i64, llvm.dead_on_unwind, llvm.dereferenceable = 32 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writable, llvm.writeonly}, {llvm.align = 8 : i64, llvm.dead_on_return = -1 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], sym_name = "_RNvMs2_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar528to_bytes", target_cpu = "x86-64-v2", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg66: !llvm.ptr, %arg67: !llvm.ptr):
  %1233 = "llvm.mlir.constant"() <{value = 8 : i64}> : () -> i64
  %1234 = "llvm.mlir.constant"() <{value = 16 : i64}> : () -> i64
  %1235 = "llvm.mlir.constant"() <{value = 24 : i64}> : () -> i64
  %1236 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %1237 = "llvm.mlir.constant"() <{value = 4 : i64}> : () -> i64
  %1238 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
  %1239 = "llvm.mlir.constant"() <{value = 48 : i64}> : () -> i64
  %1240 = "llvm.mlir.constant"() <{value = 12 : i64}> : () -> i64
  %1241 = "llvm.mlir.constant"() <{value = 20 : i64}> : () -> i64
  %1242 = "llvm.mlir.constant"() <{value = 28 : i64}> : () -> i64
  %1243 = "llvm.mlir.constant"() <{value = 36 : i64}> : () -> i64
  %1244 = "llvm.mlir.constant"() <{value = 44 : i64}> : () -> i64
  %1245 = "llvm.load"(%arg67) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1246 = "llvm.trunc"(%1245) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%1246, %arg66) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1247 = "llvm.lshr"(%1245, %1233) : (i64, i64) -> i64
  %1248 = "llvm.getelementptr"(%arg66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1>}> : (!llvm.ptr) -> !llvm.ptr
  %1249 = "llvm.trunc"(%1247) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%1249, %1248) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1250 = "llvm.lshr"(%1245, %1234) : (i64, i64) -> i64
  %1251 = "llvm.getelementptr"(%arg66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2>}> : (!llvm.ptr) -> !llvm.ptr
  %1252 = "llvm.trunc"(%1250) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%1252, %1251) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1253 = "llvm.lshr"(%1245, %1235) : (i64, i64) -> i64
  %1254 = "llvm.getelementptr"(%arg66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 3>}> : (!llvm.ptr) -> !llvm.ptr
  %1255 = "llvm.trunc"(%1253) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%1255, %1254) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1256 = "llvm.lshr"(%1245, %1236) : (i64, i64) -> i64
  %1257 = "llvm.getelementptr"(%arg66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4>}> : (!llvm.ptr) -> !llvm.ptr
  %1258 = "llvm.trunc"(%1256) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%1258, %1257) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1259 = "llvm.lshr"(%1245, %1238) : (i64, i64) -> i64
  %1260 = "llvm.getelementptr"(%arg66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 5>}> : (!llvm.ptr) -> !llvm.ptr
  %1261 = "llvm.trunc"(%1259) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%1261, %1260) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1262 = "llvm.lshr"(%1245, %1239) : (i64, i64) -> i64
  %1263 = "llvm.getelementptr"(%arg67) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %1264 = "llvm.load"(%1263) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1265 = "llvm.shl"(%1264, %1237) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1266 = "llvm.or"(%1265, %1262) : (i64, i64) -> i64
  %1267 = "llvm.getelementptr"(%arg66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6>}> : (!llvm.ptr) -> !llvm.ptr
  %1268 = "llvm.trunc"(%1266) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%1268, %1267) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1269 = "llvm.lshr"(%1264, %1237) : (i64, i64) -> i64
  %1270 = "llvm.getelementptr"(%arg66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 7>}> : (!llvm.ptr) -> !llvm.ptr
  %1271 = "llvm.trunc"(%1269) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%1271, %1270) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1272 = "llvm.lshr"(%1264, %1240) : (i64, i64) -> i64
  %1273 = "llvm.getelementptr"(%arg66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %1274 = "llvm.trunc"(%1272) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%1274, %1273) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1275 = "llvm.lshr"(%1264, %1241) : (i64, i64) -> i64
  %1276 = "llvm.getelementptr"(%arg66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 9>}> : (!llvm.ptr) -> !llvm.ptr
  %1277 = "llvm.trunc"(%1275) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%1277, %1276) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1278 = "llvm.lshr"(%1264, %1242) : (i64, i64) -> i64
  %1279 = "llvm.getelementptr"(%arg66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 10>}> : (!llvm.ptr) -> !llvm.ptr
  %1280 = "llvm.trunc"(%1278) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%1280, %1279) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1281 = "llvm.lshr"(%1264, %1243) : (i64, i64) -> i64
  %1282 = "llvm.getelementptr"(%arg66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 11>}> : (!llvm.ptr) -> !llvm.ptr
  %1283 = "llvm.trunc"(%1281) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%1283, %1282) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1284 = "llvm.lshr"(%1264, %1244) : (i64, i64) -> i64
  %1285 = "llvm.getelementptr"(%arg66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 12>}> : (!llvm.ptr) -> !llvm.ptr
  %1286 = "llvm.trunc"(%1284) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%1286, %1285) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1287 = "llvm.getelementptr"(%arg67) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %1288 = "llvm.load"(%1287) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1289 = "llvm.getelementptr"(%arg66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 13>}> : (!llvm.ptr) -> !llvm.ptr
  %1290 = "llvm.trunc"(%1288) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%1290, %1289) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1291 = "llvm.lshr"(%1288, %1233) : (i64, i64) -> i64
  %1292 = "llvm.getelementptr"(%arg66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 14>}> : (!llvm.ptr) -> !llvm.ptr
  %1293 = "llvm.trunc"(%1291) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%1293, %1292) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1294 = "llvm.lshr"(%1288, %1234) : (i64, i64) -> i64
  %1295 = "llvm.getelementptr"(%arg66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 15>}> : (!llvm.ptr) -> !llvm.ptr
  %1296 = "llvm.trunc"(%1294) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%1296, %1295) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1297 = "llvm.lshr"(%1288, %1235) : (i64, i64) -> i64
  %1298 = "llvm.getelementptr"(%arg66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %1299 = "llvm.trunc"(%1297) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%1299, %1298) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1300 = "llvm.lshr"(%1288, %1236) : (i64, i64) -> i64
  %1301 = "llvm.getelementptr"(%arg66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 17>}> : (!llvm.ptr) -> !llvm.ptr
  %1302 = "llvm.trunc"(%1300) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%1302, %1301) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1303 = "llvm.lshr"(%1288, %1238) : (i64, i64) -> i64
  %1304 = "llvm.getelementptr"(%arg66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 18>}> : (!llvm.ptr) -> !llvm.ptr
  %1305 = "llvm.trunc"(%1303) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%1305, %1304) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1306 = "llvm.lshr"(%1288, %1239) : (i64, i64) -> i64
  %1307 = "llvm.getelementptr"(%arg67) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %1308 = "llvm.load"(%1307) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1309 = "llvm.shl"(%1308, %1237) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1310 = "llvm.or"(%1309, %1306) : (i64, i64) -> i64
  %1311 = "llvm.getelementptr"(%arg66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 19>}> : (!llvm.ptr) -> !llvm.ptr
  %1312 = "llvm.trunc"(%1310) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%1312, %1311) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1313 = "llvm.lshr"(%1308, %1237) : (i64, i64) -> i64
  %1314 = "llvm.getelementptr"(%arg66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 20>}> : (!llvm.ptr) -> !llvm.ptr
  %1315 = "llvm.trunc"(%1313) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%1315, %1314) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1316 = "llvm.lshr"(%1308, %1240) : (i64, i64) -> i64
  %1317 = "llvm.getelementptr"(%arg66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 21>}> : (!llvm.ptr) -> !llvm.ptr
  %1318 = "llvm.trunc"(%1316) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%1318, %1317) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1319 = "llvm.lshr"(%1308, %1241) : (i64, i64) -> i64
  %1320 = "llvm.getelementptr"(%arg66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 22>}> : (!llvm.ptr) -> !llvm.ptr
  %1321 = "llvm.trunc"(%1319) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%1321, %1320) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1322 = "llvm.lshr"(%1308, %1242) : (i64, i64) -> i64
  %1323 = "llvm.getelementptr"(%arg66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 23>}> : (!llvm.ptr) -> !llvm.ptr
  %1324 = "llvm.trunc"(%1322) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%1324, %1323) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1325 = "llvm.lshr"(%1308, %1243) : (i64, i64) -> i64
  %1326 = "llvm.getelementptr"(%arg66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %1327 = "llvm.trunc"(%1325) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%1327, %1326) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1328 = "llvm.lshr"(%1308, %1244) : (i64, i64) -> i64
  %1329 = "llvm.getelementptr"(%arg66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 25>}> : (!llvm.ptr) -> !llvm.ptr
  %1330 = "llvm.trunc"(%1328) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%1330, %1329) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1331 = "llvm.getelementptr"(%arg67) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %1332 = "llvm.load"(%1331) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1333 = "llvm.getelementptr"(%arg66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 26>}> : (!llvm.ptr) -> !llvm.ptr
  %1334 = "llvm.trunc"(%1332) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%1334, %1333) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1335 = "llvm.lshr"(%1332, %1233) : (i64, i64) -> i64
  %1336 = "llvm.getelementptr"(%arg66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 27>}> : (!llvm.ptr) -> !llvm.ptr
  %1337 = "llvm.trunc"(%1335) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%1337, %1336) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1338 = "llvm.lshr"(%1332, %1234) : (i64, i64) -> i64
  %1339 = "llvm.getelementptr"(%arg66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 28>}> : (!llvm.ptr) -> !llvm.ptr
  %1340 = "llvm.trunc"(%1338) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%1340, %1339) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1341 = "llvm.lshr"(%1332, %1235) : (i64, i64) -> i64
  %1342 = "llvm.getelementptr"(%arg66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 29>}> : (!llvm.ptr) -> !llvm.ptr
  %1343 = "llvm.trunc"(%1341) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%1343, %1342) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1344 = "llvm.lshr"(%1332, %1236) : (i64, i64) -> i64
  %1345 = "llvm.getelementptr"(%arg66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 30>}> : (!llvm.ptr) -> !llvm.ptr
  %1346 = "llvm.trunc"(%1344) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%1346, %1345) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1347 = "llvm.lshr"(%1332, %1238) : (i64, i64) -> i64
  %1348 = "llvm.getelementptr"(%arg66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 31>}> : (!llvm.ptr) -> !llvm.ptr
  %1349 = "llvm.trunc"(%1347) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%1349, %1348) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end MLIR.Agave.Serial
