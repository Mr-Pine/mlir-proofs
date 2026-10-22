module

-- crc/out/mlirproofs/regions/verify/fd_r52x5_odd_table.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_ge_add
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_ge_dbl
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_to_table

meta import MLIR.Semantics.Func
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_ge_add
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_ge_dbl
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_to_table

namespace MLIR.Firedancer.Crc.Ed25519.Avx512

@[expose] public section

mlir_def fd_r52x5_odd_table :=
#loop_annotation = #llvm.loop_annotation<mustProgress = true>
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.noundef, llvm.readonly}, {llvm.noundef, llvm.range = #llvm.constant_range<i32, 4, 9>}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr, i32)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "256"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], sym_name = "fd_r52x5_odd_table", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg167: !llvm.ptr, %arg168: !llvm.ptr, %arg169: i32):
  %1182 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1183 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %1184 = "llvm.alloca"(%1182) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1185 = "llvm.alloca"(%1182) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1186 = "llvm.alloca"(%1182) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1187 = "llvm.alloca"(%1182) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1188 = "llvm.alloca"(%1182) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1189 = "llvm.alloca"(%1182) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1190 = "llvm.alloca"(%1182) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1191 = "llvm.alloca"(%1182) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1192 = "llvm.alloca"(%1182) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1193 = "llvm.alloca"(%1182) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1194 = "llvm.alloca"(%1182) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1195 = "llvm.alloca"(%1182) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1196 = "llvm.alloca"(%1182) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1197 = "llvm.alloca"(%1182) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1198 = "llvm.alloca"(%1182) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1199 = "llvm.alloca"(%1182) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1200 = "llvm.alloca"(%1182) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1201 = "llvm.alloca"(%1182) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1202 = "llvm.alloca"(%1182) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1203 = "llvm.alloca"(%1182) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1204 = "llvm.load"(%arg168) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1205 = "llvm.getelementptr"(%arg168) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %1206 = "llvm.load"(%1205) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1207 = "llvm.getelementptr"(%arg168) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %1208 = "llvm.load"(%1207) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1209 = "llvm.getelementptr"(%arg168) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %1210 = "llvm.load"(%1209) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1211 = "llvm.getelementptr"(%arg168) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %1212 = "llvm.load"(%1211) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%1184) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1185) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1186) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1187) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1188) : (!llvm.ptr) -> ()
  "llvm.call"(%1184, %1185, %1186, %1187, %1188, %1204, %1206, %1208, %1210, %1212) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_ge_dbl, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1213 = "llvm.load"(%1184) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1214 = "llvm.load"(%1185) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1215 = "llvm.load"(%1186) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1216 = "llvm.load"(%1187) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1217 = "llvm.load"(%1188) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1188) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1187) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1186) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1185) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1184) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1189) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1190) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1191) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1192) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1193) : (!llvm.ptr) -> ()
  "llvm.call"(%1189, %1190, %1191, %1192, %1193, %1204, %1206, %1208, %1210, %1212) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_to_table, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1218 = "llvm.load"(%1189) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1219 = "llvm.load"(%1190) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1220 = "llvm.load"(%1191) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1221 = "llvm.load"(%1192) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1222 = "llvm.load"(%1193) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1193) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1192) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1191) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1190) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1189) : (!llvm.ptr) -> ()
  "llvm.store"(%1218, %arg167) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %1223 = "llvm.getelementptr"(%arg167) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1219, %1223) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %1224 = "llvm.getelementptr"(%arg167) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1220, %1224) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %1225 = "llvm.getelementptr"(%arg167) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1221, %1225) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %1226 = "llvm.getelementptr"(%arg167) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1222, %1226) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %1227 = "llvm.zext"(%arg169) <{nonNeg}> : (i32) -> i64
  "llvm.br"(%1183, %1204, %1206, %1208, %1210, %1212)[^bb2] : (i64, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb1:  // pred: ^bb2
  "llvm.return"() : () -> ()
^bb2(%1228: i64, %1229: vector<4xi64>, %1230: vector<4xi64>, %1231: vector<4xi64>, %1232: vector<4xi64>, %1233: vector<4xi64>):  // 2 preds: ^bb0, ^bb2
  "llvm.intr.lifetime.start"(%1194) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1195) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1196) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1197) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1198) : (!llvm.ptr) -> ()
  "llvm.call"(%1194, %1195, %1196, %1197, %1198, %1229, %1230, %1231, %1232, %1233, %1213, %1214, %1215, %1216, %1217) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_ge_add, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1234 = "llvm.load"(%1194) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1235 = "llvm.load"(%1195) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1236 = "llvm.load"(%1196) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1237 = "llvm.load"(%1197) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1238 = "llvm.load"(%1198) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1198) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1197) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1196) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1195) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1194) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1199) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1200) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1201) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1202) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1203) : (!llvm.ptr) -> ()
  "llvm.call"(%1199, %1200, %1201, %1202, %1203, %1234, %1235, %1236, %1237, %1238) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_to_table, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1239 = "llvm.load"(%1199) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1240 = "llvm.load"(%1200) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1241 = "llvm.load"(%1201) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1242 = "llvm.load"(%1202) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1243 = "llvm.load"(%1203) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1203) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1202) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1201) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1200) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1199) : (!llvm.ptr) -> ()
  %1244 = "llvm.getelementptr"(%arg167, %1228) <{elem_type = !llvm.struct<"struct.fd_r52x5_ge", (vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>)>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%1239, %1244) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %1245 = "llvm.getelementptr"(%1244) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1240, %1245) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %1246 = "llvm.getelementptr"(%1244) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1241, %1246) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %1247 = "llvm.getelementptr"(%1244) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1242, %1247) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %1248 = "llvm.getelementptr"(%1244) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1243, %1248) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %1249 = "llvm.add"(%1228, %1183) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1250 = "llvm.icmp"(%1249, %1227) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1250, %1249, %1234, %1235, %1236, %1237, %1238)[^bb1, ^bb2] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 6>}> : (i1, i64, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
}) : () -> ()
  with @fd_r52x5_quad_ge_add := fd_r52x5_quad_ge_add, @fd_r52x5_quad_ge_dbl := fd_r52x5_quad_ge_dbl,
    @fd_r52x5_quad_to_table := fd_r52x5_quad_to_table

end

end MLIR.Firedancer.Crc.Ed25519.Avx512
