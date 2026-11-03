module

-- crc/out/mlirproofs/regions/verify/fd_r52x5_wnaf.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Firedancer.Crc.Ed25519.Avx512

@[expose] public section

mlir_def fd_r52x5_wnaf :=
#loop_annotation = #llvm.loop_annotation<mustProgress = true>
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.noundef, llvm.readonly}, {llvm.noundef, llvm.range = #llvm.constant_range<i32, 3, 9>}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<i32 (ptr, ptr, i32)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], sym_name = "fd_r52x5_wnaf", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg164: !llvm.ptr, %arg165: !llvm.ptr, %arg166: i32):
  %1090 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1091 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %1092 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %1093 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %1094 = "llvm.mlir.poison"() : () -> vector<2xi64>
  %1095 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %1096 = "llvm.mlir.constant"() <{value = 0 : i16}> : () -> i16
  %1097 = "llvm.mlir.constant"() <{value = 63 : i64}> : () -> i64
  %1098 = "llvm.mlir.constant"() <{value = dense<63> : vector<2xi64>}> : () -> vector<2xi64>
  %1099 = "llvm.alloca"(%1090) <{alignment = 16 : i64, elem_type = !llvm.array<3 x i64>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%1099) : (!llvm.ptr) -> ()
  %1100 = "llvm.load"(%arg165) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1101 = "llvm.getelementptr"(%arg165) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %1102 = "llvm.getelementptr"(%arg165) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %1103 = "llvm.load"(%1101) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  %1104 = "llvm.extractelement"(%1103, %1091) : (vector<2xi64>, i64) -> i64
  "llvm.store"(%1104, %1099) <{alignment = 16 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1105 = "llvm.load"(%1102) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  %1106 = "llvm.getelementptr"(%1099) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1105, %1106) <{alignment = 8 : i64, ordering = 0 : i64}> : (vector<2xi64>, !llvm.ptr) -> ()
  %1107 = "llvm.add"(%arg166, %1090) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %1108 = "llvm.zext"(%1107) <{nonNeg}> : (i32) -> i64
  %1109 = "llvm.shl"(%1092, %1108) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1110 = "llvm.add"(%1109, %1093) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1111 = "llvm.zext"(%arg166) <{nonNeg}> : (i32) -> i64
  %1112 = "llvm.shufflevector"(%1105, %1094) <{mask = array<i32: 1, -1>}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1113 = "llvm.or"(%1105, %1112) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1114 = "llvm.or"(%1113, %1103) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1115 = "llvm.extractelement"(%1114, %1091) : (vector<2xi64>, i64) -> i64
  %1116 = "llvm.or"(%1115, %1100) : (i64, i64) -> i64
  %1117 = "llvm.icmp"(%1116, %1091) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1117, %1095)[^bb14, ^bb1] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i32) -> ()
^bb1:  // pred: ^bb0
  %1118 = "llvm.getelementptr"(%1099) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %1119 = "llvm.getelementptr"(%1099) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %1120 = "llvm.getelementptr"(%1099) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %1121 = "llvm.getelementptr"(%1099) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %1122 = "llvm.getelementptr"(%1099) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %1123 = "llvm.getelementptr"(%1099) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %1124 = "llvm.getelementptr"(%1099) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %1125 = "llvm.getelementptr"(%1099) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %1126 = "llvm.getelementptr"(%1099) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %1127 = "llvm.getelementptr"(%1099) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.br"(%1095, %1100, %1105, %1103)[^bb2] : (i32, i64, vector<2xi64>, vector<2xi64>) -> ()
^bb2(%1128: i32, %1129: i64, %1130: vector<2xi64>, %1131: vector<2xi64>):  // 2 preds: ^bb1, ^bb13
  %1132 = "llvm.and"(%1129, %1092) : (i64, i64) -> i64
  %1133 = "llvm.icmp"(%1132, %1091) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1133, %1129, %1096, %1130, %1131)[^bb13, ^bb3] <{operandSegmentSizes = array<i32: 1, 4, 0>}> : (i1, i64, i16, vector<2xi64>, vector<2xi64>) -> ()
^bb3:  // pred: ^bb2
  %1134 = "llvm.and"(%1129, %1110) : (i64, i64) -> i64
  %1135 = "llvm.lshr"(%1134, %1111) : (i64, i64) -> i64
  %1136 = "llvm.icmp"(%1135, %1091) <{predicate = 0 : i64}> : (i64, i64) -> i1
  %1137 = "llvm.select"(%1136, %1091, %1109) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %1138 = "llvm.sub"(%1134, %1137) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1139 = "llvm.icmp"(%1138, %1091) <{predicate = 4 : i64}> : (i64, i64) -> i1
  %1140 = "llvm.icmp"(%1138, %1129) <{predicate = 8 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1139)[^bb4, ^bb8] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb4:  // pred: ^bb3
  "llvm.cond_br"(%1140)[^bb5, ^bb12] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb5:  // pred: ^bb4
  %1141 = "llvm.load"(%1099) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1142 = "llvm.add"(%1141, %1093) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1143 = "llvm.icmp"(%1141, %1091) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.store"(%1142, %1099) <{alignment = 16 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.cond_br"(%1143)[^bb6, ^bb12] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb6:  // pred: ^bb5
  %1144 = "llvm.load"(%1122) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1145 = "llvm.add"(%1144, %1093) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1146 = "llvm.icmp"(%1144, %1091) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.store"(%1145, %1123) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.cond_br"(%1146)[^bb7, ^bb12] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb7:  // pred: ^bb6
  %1147 = "llvm.load"(%1124) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1148 = "llvm.add"(%1147, %1093) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%1148, %1125) <{alignment = 16 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.br"()[^bb12] : () -> ()
^bb8:  // pred: ^bb3
  "llvm.cond_br"(%1140)[^bb12, ^bb9] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb9:  // pred: ^bb8
  %1149 = "llvm.load"(%1099) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1150 = "llvm.add"(%1149, %1092) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1151 = "llvm.icmp"(%1149, %1093) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.store"(%1150, %1099) <{alignment = 16 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.cond_br"(%1151)[^bb10, ^bb12] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb10:  // pred: ^bb9
  %1152 = "llvm.load"(%1118) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1153 = "llvm.add"(%1152, %1092) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1154 = "llvm.icmp"(%1152, %1093) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.store"(%1153, %1119) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.cond_br"(%1154)[^bb11, ^bb12] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb11:  // pred: ^bb10
  %1155 = "llvm.load"(%1120) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1156 = "llvm.add"(%1155, %1092) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%1156, %1121) <{alignment = 16 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.br"()[^bb12] : () -> ()
^bb12:  // 8 preds: ^bb4, ^bb5, ^bb6, ^bb7, ^bb8, ^bb9, ^bb10, ^bb11
  %1157 = "llvm.sub"(%1129, %1138) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1158 = "llvm.trunc"(%1138) <{overflowFlags = 1 : i32}> : (i64) -> i16
  %1159 = "llvm.load"(%1099) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  %1160 = "llvm.load"(%1126) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  "llvm.br"(%1157, %1158, %1160, %1159)[^bb13] : (i64, i16, vector<2xi64>, vector<2xi64>) -> ()
^bb13(%1161: i64, %1162: i16, %1163: vector<2xi64>, %1164: vector<2xi64>):  // 2 preds: ^bb2, ^bb12
  %1165 = "llvm.add"(%1128, %1090) <{overflowFlags = 0 : i32}> : (i32, i32) -> i32
  %1166 = "llvm.sext"(%1128) : (i32) -> i64
  %1167 = "llvm.getelementptr"(%arg164, %1166) <{elem_type = i16, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%1162, %1167) <{alignment = 2 : i64, ordering = 0 : i64}> : (i16, !llvm.ptr) -> ()
  %1168 = "llvm.extractelement"(%1164, %1091) : (vector<2xi64>, i64) -> i64
  %1169 = "llvm.intr.fshl"(%1168, %1161, %1097) : (i64, i64, i64) -> i64
  %1170 = "llvm.intr.fshl"(%1163, %1164, %1098) : (vector<2xi64>, vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  "llvm.store"(%1170, %1099) <{alignment = 16 : i64, ordering = 0 : i64}> : (vector<2xi64>, !llvm.ptr) -> ()
  %1171 = "llvm.extractelement"(%1163, %1092) : (vector<2xi64>, i64) -> i64
  %1172 = "llvm.lshr"(%1171, %1092) : (i64, i64) -> i64
  "llvm.store"(%1172, %1127) <{alignment = 16 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1173 = "llvm.extractelement"(%1170, %1091) : (vector<2xi64>, i64) -> i64
  %1174 = "llvm.extractelement"(%1170, %1092) : (vector<2xi64>, i64) -> i64
  %1175 = "llvm.or"(%1173, %1174) : (i64, i64) -> i64
  %1176 = "llvm.or"(%1175, %1169) : (i64, i64) -> i64
  %1177 = "llvm.or"(%1176, %1172) : (i64, i64) -> i64
  %1178 = "llvm.icmp"(%1177, %1091) <{predicate = 0 : i64}> : (i64, i64) -> i1
  %1179 = "llvm.shufflevector"(%1170, %1094) <{mask = array<i32: 1, -1>}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1180 = "llvm.insertelement"(%1179, %1172, %1092) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  "llvm.cond_br"(%1178, %1165, %1165, %1169, %1180, %1170)[^bb14, ^bb2] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 1, 4>}> : (i1, i32, i32, i64, vector<2xi64>, vector<2xi64>) -> ()
^bb14(%1181: i32):  // 2 preds: ^bb0, ^bb13
  "llvm.intr.lifetime.end"(%1099) : (!llvm.ptr) -> ()
  "llvm.return"(%1181) : (i32) -> ()
}) : () -> ()

end

end MLIR.Firedancer.Crc.Ed25519.Avx512
