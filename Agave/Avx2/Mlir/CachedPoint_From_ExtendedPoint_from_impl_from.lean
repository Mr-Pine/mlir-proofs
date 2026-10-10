module

-- agave-build/out/avx2-noinline/op/_RNvXNvXsc_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx27edwardsNtB8_11CachedPointINtNtCsgxBkk5gSRhY_4core7convert4FromNtB8_13ExtendedPointE4fromB1c_NtB2_13___Impl_from__10__impl_from.mlir
-- <solana_ed25519[c79103de3f6f5451]::backend::vector::avx2::edwards::CachedPoint as <solana_ed25519[c79103de3f6f5451]::backend::vector::avx2::edwards::CachedPoint as core[c0acaeba6ab4c2e0]::convert::From<solana_ed25519[c79103de3f6f5451]::backend::vector::avx2::edwards::ExtendedPoint>>::from::__Impl_from__>::_impl_from

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Agave.Avx2

@[expose] public section

mlir_def CachedPoint_From_ExtendedPoint_from_impl_from :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 32 : i64, llvm.dead_on_unwind, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writable, llvm.writeonly}, {llvm.align = 32 : i64, llvm.dead_on_return = -1 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], sym_name = "_RNvXNvXsc_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx27edwardsNtB8_11CachedPointINtNtCsgxBkk5gSRhY_4core7convert4FromNtB8_13ExtendedPointE4fromB1c_NtB2_13___Impl_from__10__impl_from", target_cpu = "x86-64-v2", target_features = #llvm.target_features<["+avx", "+avx2", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+crc32", "+ssse3", "+avx", "+avx2", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+crc32", "+ssse3"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg26: !llvm.ptr, %arg27: !llvm.ptr):
  %1189 = "llvm.mlir.undef"() : () -> vector<4xi64>
  %1190 = "llvm.mlir.poison"() : () -> i64
  %1191 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %1192 = "llvm.mlir.constant"() <{value = 15 : i32}> : () -> i32
  %1193 = "llvm.mlir.constant"() <{value = 5 : i64}> : () -> i64
  %1194 = "llvm.mlir.constant"() <{value = dense<[26, 26, 25, 25, 26, 26, 25, 25]> : vector<8xi32>}> : () -> vector<8xi32>
  %1195 = "llvm.mlir.constant"() <{value = dense<[1073741808, 1073741808, 536870896, 536870896, 1073741808, 1073741808, 536870896, 536870896]> : vector<8xi32>}> : () -> vector<8xi32>
  %1196 = "llvm.mlir.constant"() <{value = dense<[1073741520, 1073741520, 536870896, 536870896, 1073741520, 1073741520, 536870896, 536870896]> : vector<8xi32>}> : () -> vector<8xi32>
  %1197 = "llvm.mlir.constant"() <{value = 33554431 : i32}> : () -> i32
  %1198 = "llvm.mlir.constant"() <{value = 67108863 : i32}> : () -> i32
  %1199 = "llvm.mlir.constant"() <{value = dense<19> : vector<4xi64>}> : () -> vector<4xi64>
  %1200 = "llvm.mlir.constant"() <{value = dense<33554431> : vector<4xi64>}> : () -> vector<4xi64>
  %1201 = "llvm.mlir.constant"() <{value = dense<25> : vector<4xi64>}> : () -> vector<4xi64>
  %1202 = "llvm.mlir.constant"() <{value = dense<67108862> : vector<4xi64>}> : () -> vector<4xi64>
  %1203 = "llvm.mlir.constant"() <{value = dense<26> : vector<4xi64>}> : () -> vector<4xi64>
  %1204 = "llvm.mlir.constant"() <{value = dense<[121666, 121666, 243332, 243330]> : vector<4xi64>}> : () -> vector<4xi64>
  %1205 = "llvm.mlir.constant"() <{value = 134217726 : i32}> : () -> i32
  %1206 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %1207 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %1208 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %1209 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %1210 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %1211 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %1212 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1213 = "llvm.mlir.poison"() : () -> vector<8xi32>
  %1214 = "llvm.mlir.poison"() : () -> i32
  %1215 = "llvm.mlir.constant"() <{value = 67108862 : i32}> : () -> i32
  %1216 = "llvm.mlir.constant"() <{value = 134217690 : i32}> : () -> i32
  %1217 = "llvm.mlir.undef"() : () -> vector<8xi32>
  %1218 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %1219 = "llvm.insertelement"(%1217, %1216, %1218) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1220 = "llvm.insertelement"(%1219, %1214, %1212) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1221 = "llvm.insertelement"(%1220, %1215, %1211) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1222 = "llvm.insertelement"(%1221, %1214, %1210) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1223 = "llvm.insertelement"(%1222, %1214, %1209) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1224 = "llvm.insertelement"(%1223, %1214, %1208) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1225 = "llvm.insertelement"(%1224, %1214, %1207) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1226 = "llvm.insertelement"(%1225, %1214, %1206) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1227 = "llvm.insertelement"(%1217, %1205, %1218) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1228 = "llvm.insertelement"(%1227, %1214, %1212) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1229 = "llvm.insertelement"(%1228, %1215, %1211) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1230 = "llvm.insertelement"(%1229, %1214, %1210) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1231 = "llvm.insertelement"(%1230, %1214, %1209) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1232 = "llvm.insertelement"(%1231, %1214, %1208) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1233 = "llvm.insertelement"(%1232, %1214, %1207) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1234 = "llvm.insertelement"(%1233, %1214, %1206) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1235 = "llvm.insertelement"(%1217, %1218, %1218) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1236 = "llvm.insertelement"(%1235, %1218, %1212) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1237 = "llvm.insertelement"(%1236, %1214, %1211) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1238 = "llvm.insertelement"(%1237, %1214, %1210) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1239 = "llvm.insertelement"(%1238, %1218, %1209) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1240 = "llvm.insertelement"(%1239, %1218, %1208) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1241 = "llvm.insertelement"(%1240, %1214, %1207) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1242 = "llvm.insertelement"(%1241, %1214, %1206) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1243 = "llvm.insertelement"(%1217, %1214, %1218) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1244 = "llvm.insertelement"(%1243, %1214, %1212) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1245 = "llvm.insertelement"(%1244, %1218, %1211) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1246 = "llvm.insertelement"(%1245, %1218, %1210) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1247 = "llvm.insertelement"(%1246, %1214, %1209) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1248 = "llvm.insertelement"(%1247, %1214, %1208) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1249 = "llvm.insertelement"(%1248, %1218, %1207) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1250 = "llvm.insertelement"(%1249, %1218, %1206) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1251 = "llvm.insertelement"(%1217, %1198, %1218) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1252 = "llvm.insertelement"(%1251, %1214, %1212) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1253 = "llvm.insertelement"(%1252, %1198, %1211) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1254 = "llvm.insertelement"(%1253, %1214, %1210) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1255 = "llvm.insertelement"(%1254, %1198, %1209) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1256 = "llvm.insertelement"(%1255, %1214, %1208) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1257 = "llvm.insertelement"(%1256, %1198, %1207) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1258 = "llvm.insertelement"(%1257, %1214, %1206) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1259 = "llvm.insertelement"(%1217, %1197, %1218) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1260 = "llvm.insertelement"(%1259, %1214, %1212) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1261 = "llvm.insertelement"(%1260, %1197, %1211) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1262 = "llvm.insertelement"(%1261, %1214, %1210) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1263 = "llvm.insertelement"(%1262, %1197, %1209) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1264 = "llvm.insertelement"(%1263, %1214, %1208) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1265 = "llvm.insertelement"(%1264, %1197, %1207) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1266 = "llvm.insertelement"(%1265, %1214, %1206) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1267 = "llvm.insertelement"(%1217, %1214, %1218) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1268 = "llvm.insertelement"(%1267, %1214, %1212) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1269 = "llvm.insertelement"(%1268, %1214, %1211) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1270 = "llvm.insertelement"(%1269, %1214, %1210) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1271 = "llvm.insertelement"(%1270, %1214, %1209) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1272 = "llvm.insertelement"(%1271, %1198, %1208) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1273 = "llvm.insertelement"(%1272, %1214, %1207) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1274 = "llvm.insertelement"(%1273, %1197, %1206) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1275 = "llvm.insertelement"(%1217, %1214, %1218) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1276 = "llvm.insertelement"(%1275, %1214, %1212) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1277 = "llvm.insertelement"(%1276, %1214, %1211) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1278 = "llvm.insertelement"(%1277, %1214, %1210) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1279 = "llvm.insertelement"(%1278, %1214, %1209) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1280 = "llvm.insertelement"(%1279, %1218, %1208) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1281 = "llvm.insertelement"(%1280, %1214, %1207) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1282 = "llvm.insertelement"(%1281, %1192, %1206) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1283 = "llvm.insertelement"(%1189, %1190, %1218) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %1284 = "llvm.insertelement"(%1283, %1190, %1212) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %1285 = "llvm.insertelement"(%1284, %1190, %1211) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %1286 = "llvm.insertelement"(%1285, %1191, %1210) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %1287 = "llvm.load"(%arg27) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %1288 = "llvm.getelementptr"(%arg27) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %1289 = "llvm.load"(%1288) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %1290 = "llvm.getelementptr"(%arg27) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %1291 = "llvm.load"(%1290) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %1292 = "llvm.getelementptr"(%arg27) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %1293 = "llvm.load"(%1292) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %1294 = "llvm.getelementptr"(%arg27) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %1295 = "llvm.load"(%1294) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %1296 = "llvm.shufflevector"(%1287, %1213) <{mask = array<i32: 1, 0, 3, 2, -1, -1, -1, -1>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1297 = "llvm.shufflevector"(%1289, %1213) <{mask = array<i32: 1, 0, 3, 2, -1, -1, -1, -1>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1298 = "llvm.shufflevector"(%1291, %1213) <{mask = array<i32: 1, 0, 3, 2, -1, -1, -1, -1>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1299 = "llvm.shufflevector"(%1293, %1213) <{mask = array<i32: 1, 0, 3, 2, -1, -1, -1, -1>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1300 = "llvm.shufflevector"(%1295, %1213) <{mask = array<i32: 1, 0, 3, 2, -1, -1, -1, -1>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1301 = "llvm.sub"(%1226, %1287) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1302 = "llvm.sub"(%1234, %1289) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1303 = "llvm.sub"(%1234, %1291) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1304 = "llvm.sub"(%1234, %1293) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1305 = "llvm.sub"(%1234, %1295) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1306 = "llvm.shufflevector"(%1301, %1287) <{mask = array<i32: 0, 9, 2, 11, -1, -1, -1, -1>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1307 = "llvm.shufflevector"(%1302, %1289) <{mask = array<i32: 0, 9, 2, 11, -1, -1, -1, -1>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1308 = "llvm.shufflevector"(%1303, %1291) <{mask = array<i32: 0, 9, 2, 11, -1, -1, -1, -1>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1309 = "llvm.shufflevector"(%1304, %1293) <{mask = array<i32: 0, 9, 2, 11, -1, -1, -1, -1>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1310 = "llvm.shufflevector"(%1305, %1295) <{mask = array<i32: 0, 9, 2, 11, -1, -1, -1, -1>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1311 = "llvm.add"(%1306, %1296) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1312 = "llvm.add"(%1307, %1297) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1313 = "llvm.add"(%1308, %1298) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1314 = "llvm.add"(%1309, %1299) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1315 = "llvm.add"(%1310, %1300) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1316 = "llvm.shufflevector"(%1311, %1287) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1317 = "llvm.shufflevector"(%1312, %1289) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1318 = "llvm.shufflevector"(%1313, %1291) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1319 = "llvm.shufflevector"(%1314, %1293) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1320 = "llvm.shufflevector"(%1315, %1295) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1321 = "llvm.shufflevector"(%1316, %1242) <{mask = array<i32: 0, 8, 1, 9, 4, 12, 5, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1322 = "llvm.shufflevector"(%1316, %1250) <{mask = array<i32: 2, 10, 3, 11, 6, 14, 7, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1323 = "llvm.bitcast"(%1321) : (vector<8xi32>) -> vector<4xi64>
  %1324 = "llvm.bitcast"(%1322) : (vector<8xi32>) -> vector<4xi64>
  %1325 = "llvm.shufflevector"(%1317, %1242) <{mask = array<i32: 0, 8, 1, 9, 4, 12, 5, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1326 = "llvm.shufflevector"(%1317, %1250) <{mask = array<i32: 2, 10, 3, 11, 6, 14, 7, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1327 = "llvm.bitcast"(%1325) : (vector<8xi32>) -> vector<4xi64>
  %1328 = "llvm.bitcast"(%1326) : (vector<8xi32>) -> vector<4xi64>
  %1329 = "llvm.shufflevector"(%1318, %1242) <{mask = array<i32: 0, 8, 1, 9, 4, 12, 5, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1330 = "llvm.shufflevector"(%1318, %1250) <{mask = array<i32: 2, 10, 3, 11, 6, 14, 7, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1331 = "llvm.bitcast"(%1329) : (vector<8xi32>) -> vector<4xi64>
  %1332 = "llvm.bitcast"(%1330) : (vector<8xi32>) -> vector<4xi64>
  %1333 = "llvm.shufflevector"(%1319, %1242) <{mask = array<i32: 0, 8, 1, 9, 4, 12, 5, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1334 = "llvm.shufflevector"(%1319, %1250) <{mask = array<i32: 2, 10, 3, 11, 6, 14, 7, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1335 = "llvm.bitcast"(%1333) : (vector<8xi32>) -> vector<4xi64>
  %1336 = "llvm.bitcast"(%1334) : (vector<8xi32>) -> vector<4xi64>
  %1337 = "llvm.shufflevector"(%1320, %1242) <{mask = array<i32: 0, 8, 1, 9, 4, 12, 5, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1338 = "llvm.shufflevector"(%1320, %1250) <{mask = array<i32: 2, 10, 3, 11, 6, 14, 7, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1339 = "llvm.bitcast"(%1337) : (vector<8xi32>) -> vector<4xi64>
  %1340 = "llvm.bitcast"(%1338) : (vector<8xi32>) -> vector<4xi64>
  %1341 = "llvm.mul"(%1323, %1204) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1342 = "llvm.mul"(%1324, %1204) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1343 = "llvm.mul"(%1327, %1204) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1344 = "llvm.mul"(%1328, %1204) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1345 = "llvm.mul"(%1331, %1204) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1346 = "llvm.mul"(%1332, %1204) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1347 = "llvm.mul"(%1335, %1204) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1348 = "llvm.mul"(%1336, %1204) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1349 = "llvm.mul"(%1339, %1204) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1350 = "llvm.mul"(%1340, %1204) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1351 = "llvm.lshr"(%1341, %1203) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1352 = "llvm.add"(%1351, %1342) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1353 = "llvm.and"(%1341, %1202) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1354 = "llvm.lshr"(%1345, %1203) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1355 = "llvm.add"(%1354, %1346) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1356 = "llvm.and"(%1345, %1202) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1357 = "llvm.lshr"(%1352, %1201) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1358 = "llvm.add"(%1357, %1343) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1359 = "llvm.and"(%1352, %1200) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1360 = "llvm.lshr"(%1355, %1201) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1361 = "llvm.add"(%1360, %1347) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1362 = "llvm.and"(%1355, %1200) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1363 = "llvm.lshr"(%1358, %1203) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1364 = "llvm.add"(%1363, %1344) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1365 = "llvm.lshr"(%1361, %1203) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1366 = "llvm.add"(%1365, %1348) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1367 = "llvm.lshr"(%1364, %1201) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1368 = "llvm.add"(%1367, %1356) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1369 = "llvm.lshr"(%1366, %1201) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1370 = "llvm.add"(%1369, %1349) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1371 = "llvm.lshr"(%1368, %1203) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1372 = "llvm.add"(%1371, %1362) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1373 = "llvm.lshr"(%1370, %1203) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1374 = "llvm.add"(%1373, %1350) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1375 = "llvm.lshr"(%1374, %1201) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1376 = "llvm.mul"(%1375, %1199) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1377 = "llvm.add"(%1376, %1353) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1378 = "llvm.lshr"(%1377, %1203) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1379 = "llvm.add"(%1378, %1359) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1380 = "llvm.bitcast"(%1377) : (vector<4xi64>) -> vector<8xi32>
  %1381 = "llvm.and"(%1380, %1258) : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1382 = "llvm.bitcast"(%1379) : (vector<4xi64>) -> vector<8xi32>
  %1383 = "llvm.shufflevector"(%1381, %1382) <{mask = array<i32: 0, 2, 8, 10, 4, 6, 12, 14>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1384 = "llvm.bitcast"(%1358) : (vector<4xi64>) -> vector<8xi32>
  %1385 = "llvm.and"(%1384, %1258) : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1386 = "llvm.bitcast"(%1364) : (vector<4xi64>) -> vector<8xi32>
  %1387 = "llvm.and"(%1386, %1266) : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1388 = "llvm.shufflevector"(%1385, %1387) <{mask = array<i32: 0, 2, 8, 10, 4, 6, 12, 14>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1389 = "llvm.bitcast"(%1372) : (vector<4xi64>) -> vector<8xi32>
  %1390 = "llvm.bitcast"(%1368) : (vector<4xi64>) -> vector<8xi32>
  %1391 = "llvm.and"(%1390, %1258) : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1392 = "llvm.shufflevector"(%1391, %1389) <{mask = array<i32: 0, 2, 8, 10, 4, 6, 12, 14>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1393 = "llvm.bitcast"(%1361) : (vector<4xi64>) -> vector<8xi32>
  %1394 = "llvm.and"(%1393, %1258) : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1395 = "llvm.bitcast"(%1366) : (vector<4xi64>) -> vector<8xi32>
  %1396 = "llvm.and"(%1395, %1266) : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1397 = "llvm.shufflevector"(%1394, %1396) <{mask = array<i32: 0, 2, 8, 10, 4, 6, 12, 14>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1398 = "llvm.bitcast"(%1370) : (vector<4xi64>) -> vector<8xi32>
  %1399 = "llvm.and"(%1398, %1258) : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1400 = "llvm.bitcast"(%1374) : (vector<4xi64>) -> vector<8xi32>
  %1401 = "llvm.and"(%1400, %1266) : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1402 = "llvm.shufflevector"(%1399, %1401) <{mask = array<i32: 0, 2, 8, 10, 4, 6, 12, 14>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1403 = "llvm.sub"(%1196, %1383) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1404 = "llvm.sub"(%1195, %1388) <{overflowFlags = 3 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1405 = "llvm.sub"(%1195, %1392) <{overflowFlags = 3 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1406 = "llvm.sub"(%1195, %1397) <{overflowFlags = 3 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1407 = "llvm.sub"(%1195, %1402) <{overflowFlags = 3 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1408 = "llvm.lshr"(%1403, %1194) : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1409 = "llvm.shufflevector"(%1408, %1213) <{mask = array<i32: -1, -1, -1, -1, -1, -1, -1, 5>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1410 = "llvm.insertelement"(%1409, %1218, %1193) : (vector<8xi32>, i32, i64) -> vector<8xi32>
  %1411 = "llvm.and"(%1403, %1274) : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1412 = "llvm.add"(%1410, %1411) <{overflowFlags = 3 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1413 = "llvm.lshr"(%1404, %1194) : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1414 = "llvm.shufflevector"(%1408, %1413) <{mask = array<i32: -1, -1, -1, -1, -1, 7, -1, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1415 = "llvm.and"(%1404, %1274) : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1416 = "llvm.add"(%1414, %1415) <{overflowFlags = 3 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1417 = "llvm.lshr"(%1405, %1194) : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1418 = "llvm.shufflevector"(%1413, %1417) <{mask = array<i32: -1, -1, -1, -1, -1, 7, -1, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1419 = "llvm.and"(%1405, %1274) : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1420 = "llvm.add"(%1418, %1419) <{overflowFlags = 3 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1421 = "llvm.lshr"(%1406, %1194) : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1422 = "llvm.shufflevector"(%1417, %1421) <{mask = array<i32: -1, -1, -1, -1, -1, 7, -1, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1423 = "llvm.and"(%1406, %1274) : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1424 = "llvm.add"(%1422, %1423) <{overflowFlags = 3 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1425 = "llvm.lshr"(%1407, %1194) : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1426 = "llvm.shufflevector"(%1421, %1425) <{mask = array<i32: -1, -1, -1, -1, -1, 7, -1, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1427 = "llvm.and"(%1407, %1274) : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1428 = "llvm.add"(%1426, %1427) <{overflowFlags = 3 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1429 = "llvm.and"(%1425, %1282) : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1430 = "llvm.shufflevector"(%1429, %1213) <{mask = array<i32: -1, -1, -1, -1, -1, -1, 7, 5>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1431 = "llvm.bitcast"(%1430) : (vector<8xi32>) -> vector<4xi64>
  %1432 = "llvm.mul"(%1431, %1286) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1433 = "llvm.bitcast"(%1432) : (vector<4xi64>) -> vector<8xi32>
  %1434 = "llvm.shufflevector"(%1433, %1213) <{mask = array<i32: -1, -1, -1, -1, -1, 6, -1, 7>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1435 = "llvm.add"(%1412, %1434) <{overflowFlags = 3 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1436 = "llvm.shufflevector"(%1383, %1435) <{mask = array<i32: 0, 1, 2, 3, 4, 13, 6, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1437 = "llvm.shufflevector"(%1388, %1416) <{mask = array<i32: 0, 1, 2, 3, 4, 13, 6, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1438 = "llvm.shufflevector"(%1392, %1420) <{mask = array<i32: 0, 1, 2, 3, 4, 13, 6, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1439 = "llvm.shufflevector"(%1397, %1424) <{mask = array<i32: 0, 1, 2, 3, 4, 13, 6, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1440 = "llvm.shufflevector"(%1402, %1428) <{mask = array<i32: 0, 1, 2, 3, 4, 13, 6, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  "llvm.store"(%1436, %arg26) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  %1441 = "llvm.getelementptr"(%arg26) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1437, %1441) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  %1442 = "llvm.getelementptr"(%arg26) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1438, %1442) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  %1443 = "llvm.getelementptr"(%arg26) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1439, %1443) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  %1444 = "llvm.getelementptr"(%arg26) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1440, %1444) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end MLIR.Agave.Avx2
