module

-- crc/out/mlirproofs/regions/verify/fd_r52x5_double_scalar_mul_base.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_odd_table
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_ge_add_table
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_ge_dbl
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_neg
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_wnaf
public import Firedancer.Crc.Ed25519.Avx512.Mlir.wl_permute
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_ed25519_r52x5_base_table

meta import MLIR.Semantics.Func
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_odd_table
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_ge_add_table
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_ge_dbl
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_neg
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_wnaf
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.wl_permute
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_ed25519_r52x5_base_table

namespace MLIR.Firedancer.Crc.Ed25519.Avx512

@[expose] public section

noncomputable mlir_def fd_r52x5_double_scalar_mul_base :=
#loop_annotation = #llvm.loop_annotation<mustProgress = true>
"llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nocapture, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.noundef, llvm.readonly}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "256"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], sym_name = "fd_r52x5_double_scalar_mul_base", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg175: !llvm.ptr, %arg176: !llvm.ptr, %arg177: !llvm.ptr, %arg178: !llvm.ptr):
  %1262 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %1263 = "llvm.mlir.poison"() : () -> vector<3xi64>
  %1264 = "llvm.mlir.poison"() : () -> vector<4xi64>
  %1265 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1266 = "llvm.mlir.constant"() <{value = 8 : i32}> : () -> i32
  %1267 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %1268 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %1269 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
  %1270 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %1271 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %1272 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %1273 = "llvm.mlir.constant"() <{value = dense<0> : vector<4xi64>}> : () -> vector<4xi64>
  %1274 = "llvm.mlir.constant"() <{value = dense<[0, 1, 1, 0]> : vector<4xi64>}> : () -> vector<4xi64>
  %1275 = "llvm.mlir.constant"() <{value = 0 : i16}> : () -> i16
  %1276 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %1277 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %1278 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %1279 = "llvm.mlir.addressof"() <{global_name = @fd_ed25519_r52x5_base_table}> : () -> !llvm.ptr
  %1280 = "llvm.mlir.constant"() <{value = -1 : i16}> : () -> i16
  %1281 = "llvm.mlir.constant"() <{value = 1 : i16}> : () -> i16
  %1282 = "llvm.mlir.poison"() : () -> i64
  %1283 = "llvm.mlir.undef"() : () -> vector<4xi64>
  %1284 = "llvm.insertelement"(%1283, %1282, %1276) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %1285 = "llvm.insertelement"(%1284, %1282, %1265) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %1286 = "llvm.insertelement"(%1285, %1270, %1277) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %1287 = "llvm.insertelement"(%1286, %1282, %1278) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %1288 = "llvm.alloca"(%1265) <{alignment = 32 : i64, elem_type = !llvm.array<8 x struct<"struct.fd_r52x5_ge", (vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>)>>}> : (i32) -> !llvm.ptr
  %1289 = "llvm.alloca"(%1265) <{alignment = 16 : i64, elem_type = !llvm.array<256 x i16>}> : (i32) -> !llvm.ptr
  %1290 = "llvm.alloca"(%1265) <{alignment = 16 : i64, elem_type = !llvm.array<256 x i16>}> : (i32) -> !llvm.ptr
  %1291 = "llvm.alloca"(%1265) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1292 = "llvm.alloca"(%1265) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1293 = "llvm.alloca"(%1265) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1294 = "llvm.alloca"(%1265) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1295 = "llvm.alloca"(%1265) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1296 = "llvm.alloca"(%1265) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1297 = "llvm.alloca"(%1265) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1298 = "llvm.alloca"(%1265) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1299 = "llvm.alloca"(%1265) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1300 = "llvm.alloca"(%1265) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1301 = "llvm.alloca"(%1265) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1302 = "llvm.alloca"(%1265) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1303 = "llvm.alloca"(%1265) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1304 = "llvm.alloca"(%1265) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1305 = "llvm.alloca"(%1265) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1306 = "llvm.alloca"(%1265) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1307 = "llvm.alloca"(%1265) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1308 = "llvm.alloca"(%1265) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1309 = "llvm.alloca"(%1265) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1310 = "llvm.alloca"(%1265) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1311 = "llvm.alloca"(%1265) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1312 = "llvm.alloca"(%1265) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1313 = "llvm.alloca"(%1265) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1314 = "llvm.alloca"(%1265) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1315 = "llvm.alloca"(%1265) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1316 = "llvm.alloca"(%1265) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1317 = "llvm.alloca"(%1265) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1318 = "llvm.alloca"(%1265) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1319 = "llvm.alloca"(%1265) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1320 = "llvm.alloca"(%1265) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1321 = "llvm.alloca"(%1265) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1322 = "llvm.alloca"(%1265) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1323 = "llvm.alloca"(%1265) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1324 = "llvm.alloca"(%1265) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1325 = "llvm.alloca"(%1265) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%1288) : (!llvm.ptr) -> ()
  "llvm.call"(%1288, %arg177, %1266) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_odd_table, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> ()
  "llvm.intr.lifetime.start"(%1289) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1290) : (!llvm.ptr) -> ()
  %1326 = "llvm.call"(%1289, %arg176, %1267) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_wnaf, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> i32
  %1327 = "llvm.call"(%1290, %arg178, %1266) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_wnaf, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> i32
  %1328 = "llvm.intr.smax"(%1326, %1327) : (i32, i32) -> i32
  %1329 = "llvm.icmp"(%1327, %1326) <{predicate = 4 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%1329)[^bb1, ^bb2] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb1:  // pred: ^bb0
  %1330 = "llvm.sext"(%1326) : (i32) -> i64
  %1331 = "llvm.shl"(%1330, %1268) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1332 = "llvm.getelementptr"(%1289, %1331) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1333 = "llvm.xor"(%1326, %1269) : (i32, i32) -> i32
  %1334 = "llvm.add"(%1328, %1333) <{overflowFlags = 0 : i32}> : (i32, i32) -> i32
  %1335 = "llvm.zext"(%1334) : (i32) -> i64
  %1336 = "llvm.shl"(%1335, %1268) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1337 = "llvm.add"(%1336, %1270) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  "llvm.intr.memset"(%1332, %1271, %1337) <{arg_attrs = [{llvm.align = 2 : i64, llvm.dereferenceable = 1 : i64, llvm.nonnull, llvm.noundef}, {}, {}], isVolatile = false}> : (!llvm.ptr, i8, i64) -> ()
  "llvm.br"()[^bb2] : () -> ()
^bb2:  // 2 preds: ^bb0, ^bb1
  %1338 = "llvm.icmp"(%1326, %1327) <{predicate = 4 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%1338)[^bb4, ^bb3] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb3:  // pred: ^bb2
  %1339 = "llvm.add"(%1328, %1269) <{overflowFlags = 0 : i32}> : (i32, i32) -> i32
  "llvm.br"(%1339)[^bb5] : (i32) -> ()
^bb4:  // pred: ^bb2
  %1340 = "llvm.sext"(%1327) : (i32) -> i64
  %1341 = "llvm.shl"(%1340, %1268) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1342 = "llvm.getelementptr"(%1290, %1341) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1343 = "llvm.add"(%1328, %1269) <{overflowFlags = 0 : i32}> : (i32, i32) -> i32
  %1344 = "llvm.sub"(%1343, %1327) <{overflowFlags = 0 : i32}> : (i32, i32) -> i32
  %1345 = "llvm.zext"(%1344) : (i32) -> i64
  %1346 = "llvm.shl"(%1345, %1268) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1347 = "llvm.add"(%1346, %1270) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  "llvm.intr.memset"(%1342, %1271, %1347) <{arg_attrs = [{llvm.align = 2 : i64, llvm.dereferenceable = 1 : i64, llvm.nonnull, llvm.noundef}, {}, {}], isVolatile = false}> : (!llvm.ptr, i8, i64) -> ()
  "llvm.br"(%1343)[^bb5] : (i32) -> ()
^bb5(%1348: i32):  // 2 preds: ^bb3, ^bb4
  %1349 = "llvm.icmp"(%1348, %1269) <{predicate = 4 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%1349, %1273, %1273, %1273, %1273, %1274)[^bb6, ^bb7] <{operandSegmentSizes = array<i32: 1, 0, 5>}> : (i1, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb6:  // pred: ^bb5
  %1350 = "llvm.zext"(%1348) <{nonNeg}> : (i32) -> i64
  "llvm.br"(%1350, %1274, %1273, %1273, %1273, %1273)[^bb8] : (i64, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb7(%1351: vector<4xi64>, %1352: vector<4xi64>, %1353: vector<4xi64>, %1354: vector<4xi64>, %1355: vector<4xi64>):  // 2 preds: ^bb5, ^bb16
  "llvm.store"(%1355, %arg175) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %1356 = "llvm.getelementptr"(%arg175) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1354, %1356) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %1357 = "llvm.getelementptr"(%arg175) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1353, %1357) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %1358 = "llvm.getelementptr"(%arg175) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1352, %1358) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %1359 = "llvm.getelementptr"(%arg175) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1351, %1359) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1290) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1289) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1288) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
^bb8(%1360: i64, %1361: vector<4xi64>, %1362: vector<4xi64>, %1363: vector<4xi64>, %1364: vector<4xi64>, %1365: vector<4xi64>):  // 2 preds: ^bb6, ^bb16
  "llvm.intr.lifetime.start"(%1291) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1292) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1293) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1294) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1295) : (!llvm.ptr) -> ()
  "llvm.call"(%1291, %1292, %1293, %1294, %1295, %1361, %1362, %1363, %1364, %1365) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_ge_dbl, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1366 = "llvm.load"(%1291) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1367 = "llvm.load"(%1292) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1368 = "llvm.load"(%1293) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1369 = "llvm.load"(%1294) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1370 = "llvm.load"(%1295) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1295) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1294) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1293) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1292) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1291) : (!llvm.ptr) -> ()
  %1371 = "llvm.getelementptr"(%1289, %1360) <{elem_type = i16, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1372 = "llvm.load"(%1371) <{alignment = 2 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i16
  %1373 = "llvm.sext"(%1372) : (i16) -> i32
  %1374 = "llvm.icmp"(%1372, %1275) <{predicate = 4 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%1374)[^bb9, ^bb10] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb9:  // pred: ^bb8
  %1375 = "llvm.add"(%1373, %1269) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %1376 = "llvm.lshr"(%1375, %1265) : (i32, i32) -> i32
  %1377 = "llvm.zext"(%1376) <{nonNeg}> : (i32) -> i64
  %1378 = "llvm.getelementptr"(%1288, %1377) <{elem_type = !llvm.struct<"struct.fd_r52x5_ge", (vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>)>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1379 = "llvm.load"(%1378) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1380 = "llvm.getelementptr"(%1378) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %1381 = "llvm.load"(%1380) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1382 = "llvm.getelementptr"(%1378) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %1383 = "llvm.load"(%1382) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1384 = "llvm.getelementptr"(%1378) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %1385 = "llvm.load"(%1384) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1386 = "llvm.getelementptr"(%1378) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %1387 = "llvm.load"(%1386) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%1296) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1297) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1298) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1299) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1300) : (!llvm.ptr) -> ()
  "llvm.call"(%1296, %1297, %1298, %1299, %1300, %1366, %1367, %1368, %1369, %1370, %1379, %1381, %1383, %1385, %1387) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_ge_add_table, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1388 = "llvm.load"(%1296) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1389 = "llvm.load"(%1297) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1390 = "llvm.load"(%1298) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1391 = "llvm.load"(%1299) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1392 = "llvm.load"(%1300) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1300) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1299) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1298) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1297) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1296) : (!llvm.ptr) -> ()
  "llvm.br"(%1392, %1391, %1390, %1389, %1388)[^bb12] : (vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb10:  // pred: ^bb8
  %1393 = "llvm.icmp"(%1372, %1275) <{predicate = 2 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%1393, %1370, %1369, %1368, %1367, %1366)[^bb11, ^bb12] <{operandSegmentSizes = array<i32: 1, 0, 5>}> : (i1, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb11:  // pred: ^bb10
  %1394 = "llvm.xor"(%1373, %1269) : (i32, i32) -> i32
  %1395 = "llvm.lshr"(%1394, %1265) : (i32, i32) -> i32
  %1396 = "llvm.zext"(%1395) <{nonNeg}> : (i32) -> i64
  %1397 = "llvm.getelementptr"(%1288, %1396) <{elem_type = !llvm.struct<"struct.fd_r52x5_ge", (vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>)>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1398 = "llvm.load"(%1397) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1399 = "llvm.getelementptr"(%1397) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %1400 = "llvm.load"(%1399) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1401 = "llvm.getelementptr"(%1397) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %1402 = "llvm.load"(%1401) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1403 = "llvm.getelementptr"(%1397) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %1404 = "llvm.load"(%1403) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1405 = "llvm.getelementptr"(%1397) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %1406 = "llvm.load"(%1405) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1407 = "llvm.call"(%1398, %1265, %1276, %1277, %1278) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1408 = "llvm.call"(%1400, %1265, %1276, %1277, %1278) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1409 = "llvm.call"(%1402, %1265, %1276, %1277, %1278) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1410 = "llvm.call"(%1404, %1265, %1276, %1277, %1278) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1411 = "llvm.call"(%1406, %1265, %1276, %1277, %1278) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%1301) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1302) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1303) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1304) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1305) : (!llvm.ptr) -> ()
  "llvm.call"(%1301, %1302, %1303, %1304, %1305, %1407, %1408, %1409, %1410, %1411) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_neg, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1412 = "llvm.load"(%1301) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1413 = "llvm.load"(%1302) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1414 = "llvm.load"(%1303) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1415 = "llvm.load"(%1304) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1416 = "llvm.load"(%1305) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1305) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1304) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1303) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1302) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1301) : (!llvm.ptr) -> ()
  %1417 = "llvm.shufflevector"(%1407, %1412) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1418 = "llvm.shufflevector"(%1408, %1413) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1419 = "llvm.shufflevector"(%1409, %1414) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1420 = "llvm.shufflevector"(%1410, %1415) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1421 = "llvm.shufflevector"(%1411, %1416) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%1306) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1307) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1308) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1309) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1310) : (!llvm.ptr) -> ()
  "llvm.call"(%1306, %1307, %1308, %1309, %1310, %1366, %1367, %1368, %1369, %1370, %1417, %1418, %1419, %1420, %1421) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_ge_add_table, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1422 = "llvm.load"(%1306) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1423 = "llvm.load"(%1307) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1424 = "llvm.load"(%1308) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1425 = "llvm.load"(%1309) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1426 = "llvm.load"(%1310) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1310) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1309) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1308) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1307) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1306) : (!llvm.ptr) -> ()
  "llvm.br"(%1426, %1425, %1424, %1423, %1422)[^bb12] : (vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb12(%1427: vector<4xi64>, %1428: vector<4xi64>, %1429: vector<4xi64>, %1430: vector<4xi64>, %1431: vector<4xi64>):  // 3 preds: ^bb9, ^bb10, ^bb11
  %1432 = "llvm.getelementptr"(%1290, %1360) <{elem_type = i16, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1433 = "llvm.load"(%1432) <{alignment = 2 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i16
  %1434 = "llvm.sext"(%1433) : (i16) -> i32
  %1435 = "llvm.icmp"(%1433, %1275) <{predicate = 4 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%1435)[^bb13, ^bb14] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb13:  // pred: ^bb12
  %1436 = "llvm.add"(%1434, %1269) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %1437 = "llvm.lshr"(%1436, %1265) : (i32, i32) -> i32
  %1438 = "llvm.zext"(%1437) <{nonNeg}> : (i32) -> i64
  %1439 = "llvm.getelementptr"(%1279, %1438) <{elem_type = !llvm.struct<"struct.fd_r52x5_tbl", (array<16 x i64>)>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1440 = "llvm.load"(%1439) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1441 = "llvm.zext"(%1437) <{nonNeg}> : (i32) -> i64
  %1442 = "llvm.getelementptr"(%1279, %1441) <{elem_type = !llvm.struct<"struct.fd_r52x5_tbl", (array<16 x i64>)>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1443 = "llvm.getelementptr"(%1442) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %1444 = "llvm.load"(%1443) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1445 = "llvm.getelementptr"(%1442) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 48>}> : (!llvm.ptr) -> !llvm.ptr
  %1446 = "llvm.load"(%1445) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1447 = "llvm.getelementptr"(%1442) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 72>}> : (!llvm.ptr) -> !llvm.ptr
  %1448 = "llvm.load"(%1447) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1449 = "llvm.getelementptr"(%1442) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %1450 = "llvm.load"(%1449) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<3xi64>
  %1451 = "llvm.shufflevector"(%1440, %1287) <{mask = array<i32: 0, 1, 6, 2>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1452 = "llvm.shufflevector"(%1444, %1264) <{mask = array<i32: 0, 1, -1, 2>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1453 = "llvm.insertelement"(%1452, %1272, %1270) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1454 = "llvm.shufflevector"(%1446, %1264) <{mask = array<i32: 0, 1, -1, 2>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1455 = "llvm.insertelement"(%1454, %1272, %1270) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1456 = "llvm.shufflevector"(%1448, %1264) <{mask = array<i32: 0, 1, -1, 2>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1457 = "llvm.insertelement"(%1456, %1272, %1270) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1458 = "llvm.shufflevector"(%1450, %1263) <{mask = array<i32: 0, 1, -1, 2>}> : (vector<3xi64>, vector<3xi64>) -> vector<4xi64>
  %1459 = "llvm.insertelement"(%1458, %1272, %1270) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%1311) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1312) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1313) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1314) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1315) : (!llvm.ptr) -> ()
  "llvm.call"(%1311, %1312, %1313, %1314, %1315, %1431, %1430, %1429, %1428, %1427, %1451, %1453, %1455, %1457, %1459) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_ge_add_table, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1460 = "llvm.load"(%1311) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1461 = "llvm.load"(%1312) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1462 = "llvm.load"(%1313) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1463 = "llvm.load"(%1314) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1464 = "llvm.load"(%1315) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1315) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1314) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1313) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1312) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1311) : (!llvm.ptr) -> ()
  "llvm.br"(%1464, %1463, %1462, %1461, %1460)[^bb16] : (vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb14:  // pred: ^bb12
  %1465 = "llvm.icmp"(%1433, %1275) <{predicate = 2 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%1465, %1427, %1428, %1429, %1430, %1431)[^bb15, ^bb16] <{operandSegmentSizes = array<i32: 1, 0, 5>}> : (i1, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb15:  // pred: ^bb14
  %1466 = "llvm.xor"(%1434, %1269) : (i32, i32) -> i32
  %1467 = "llvm.lshr"(%1466, %1265) : (i32, i32) -> i32
  %1468 = "llvm.zext"(%1467) <{nonNeg}> : (i32) -> i64
  %1469 = "llvm.getelementptr"(%1279, %1468) <{elem_type = !llvm.struct<"struct.fd_r52x5_tbl", (array<16 x i64>)>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1470 = "llvm.load"(%1469) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1471 = "llvm.xor"(%1433, %1280) : (i16, i16) -> i16
  %1472 = "llvm.lshr"(%1471, %1281) : (i16, i16) -> i16
  %1473 = "llvm.zext"(%1472) <{nonNeg}> : (i16) -> i64
  %1474 = "llvm.getelementptr"(%1279, %1473) <{elem_type = !llvm.struct<"struct.fd_r52x5_tbl", (array<16 x i64>)>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1475 = "llvm.getelementptr"(%1474) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %1476 = "llvm.load"(%1475) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1477 = "llvm.getelementptr"(%1474) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 48>}> : (!llvm.ptr) -> !llvm.ptr
  %1478 = "llvm.load"(%1477) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1479 = "llvm.getelementptr"(%1474) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 72>}> : (!llvm.ptr) -> !llvm.ptr
  %1480 = "llvm.load"(%1479) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1481 = "llvm.getelementptr"(%1474) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %1482 = "llvm.load"(%1481) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<3xi64>
  %1483 = "llvm.shufflevector"(%1470, %1287) <{mask = array<i32: 0, 1, 6, 2>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1484 = "llvm.shufflevector"(%1476, %1264) <{mask = array<i32: 0, 1, -1, 2>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1485 = "llvm.insertelement"(%1484, %1272, %1270) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1486 = "llvm.shufflevector"(%1478, %1264) <{mask = array<i32: 0, 1, -1, 2>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1487 = "llvm.insertelement"(%1486, %1272, %1270) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1488 = "llvm.shufflevector"(%1480, %1264) <{mask = array<i32: 0, 1, -1, 2>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1489 = "llvm.insertelement"(%1488, %1272, %1270) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1490 = "llvm.shufflevector"(%1482, %1263) <{mask = array<i32: 0, 1, -1, 2>}> : (vector<3xi64>, vector<3xi64>) -> vector<4xi64>
  %1491 = "llvm.insertelement"(%1490, %1272, %1270) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1492 = "llvm.call"(%1483, %1265, %1276, %1277, %1278) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1493 = "llvm.call"(%1485, %1265, %1276, %1277, %1278) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1494 = "llvm.call"(%1487, %1265, %1276, %1277, %1278) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1495 = "llvm.call"(%1489, %1265, %1276, %1277, %1278) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1496 = "llvm.call"(%1491, %1265, %1276, %1277, %1278) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%1316) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1317) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1318) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1319) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1320) : (!llvm.ptr) -> ()
  "llvm.call"(%1316, %1317, %1318, %1319, %1320, %1492, %1493, %1494, %1495, %1496) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_neg, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1497 = "llvm.load"(%1316) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1498 = "llvm.load"(%1317) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1499 = "llvm.load"(%1318) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1500 = "llvm.load"(%1319) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1501 = "llvm.load"(%1320) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1320) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1319) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1318) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1317) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1316) : (!llvm.ptr) -> ()
  %1502 = "llvm.shufflevector"(%1492, %1497) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1503 = "llvm.shufflevector"(%1493, %1498) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1504 = "llvm.shufflevector"(%1494, %1499) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1505 = "llvm.shufflevector"(%1495, %1500) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1506 = "llvm.shufflevector"(%1496, %1501) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%1321) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1322) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1323) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1324) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1325) : (!llvm.ptr) -> ()
  "llvm.call"(%1321, %1322, %1323, %1324, %1325, %1431, %1430, %1429, %1428, %1427, %1502, %1503, %1504, %1505, %1506) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_ge_add_table, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1507 = "llvm.load"(%1321) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1508 = "llvm.load"(%1322) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1509 = "llvm.load"(%1323) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1510 = "llvm.load"(%1324) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1511 = "llvm.load"(%1325) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1325) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1324) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1323) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1322) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1321) : (!llvm.ptr) -> ()
  "llvm.br"(%1511, %1510, %1509, %1508, %1507)[^bb16] : (vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb16(%1512: vector<4xi64>, %1513: vector<4xi64>, %1514: vector<4xi64>, %1515: vector<4xi64>, %1516: vector<4xi64>):  // 3 preds: ^bb13, ^bb14, ^bb15
  %1517 = "llvm.add"(%1360, %1262) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1518 = "llvm.icmp"(%1360, %1272) <{predicate = 4 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1518, %1517, %1516, %1515, %1514, %1513, %1512, %1512, %1513, %1514, %1515, %1516)[^bb8, ^bb7] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 6, 5>}> : (i1, i64, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
}) : () -> ()
  with @fd_r52x5_odd_table := fd_r52x5_odd_table,
    @fd_r52x5_quad_ge_add_table := fd_r52x5_quad_ge_add_table,
    @fd_r52x5_quad_ge_dbl := fd_r52x5_quad_ge_dbl, @fd_r52x5_quad_neg := fd_r52x5_quad_neg,
    @fd_r52x5_wnaf := fd_r52x5_wnaf, @wl_permute := wl_permute,
    @fd_ed25519_r52x5_base_table := fd_ed25519_r52x5_base_table

end

end MLIR.Firedancer.Crc.Ed25519.Avx512
