#alias_scope_domain13 = #llvm.alias_scope_domain<id = distinct[13]<>, description = "_RNvXCshxoft6be3N1_7zeroizeyNtB2_7Zeroize7zeroizeCs2JGgYtL0Fal_14solana_ed25519">
#alias_scope_domain14 = #llvm.alias_scope_domain<id = distinct[14]<>, description = "_RNvXs4_Cshxoft6be3N1_7zeroizeINtNtNtCsgxBkk5gSRhY_4core5slice4iter7IterMutyENtB5_7Zeroize7zeroizeCs2JGgYtL0Fal_14solana_ed25519">
#alias_scope21 = #llvm.alias_scope<id = distinct[97]<>, domain = #alias_scope_domain13, description = "_RNvXCshxoft6be3N1_7zeroizeyNtB2_7Zeroize7zeroizeCs2JGgYtL0Fal_14solana_ed25519: argument 0">
#alias_scope22 = #llvm.alias_scope<id = distinct[98]<>, domain = #alias_scope_domain14, description = "_RNvXs4_Cshxoft6be3N1_7zeroizeINtNtNtCsgxBkk5gSRhY_4core5slice4iter7IterMutyENtB5_7Zeroize7zeroizeCs2JGgYtL0Fal_14solana_ed25519: argument 0">
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 8 : i64, llvm.dead_on_unwind, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writable, llvm.writeonly}, {llvm.dereferenceable = 32 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], sym_name = "_RNvMs2_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar5210from_bytes", target_cpu = "x86-64-v2", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg64: !llvm.ptr, %arg65: !llvm.ptr):
  %1143 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1144 = "llvm.mlir.constant"() <{value = 8 : i64}> : () -> i64
  %1145 = "llvm.mlir.constant"() <{value = 12 : i64}> : () -> i64
  %1146 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %1147 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
  %1148 = "llvm.mlir.constant"() <{value = 48 : i64}> : () -> i64
  %1149 = "llvm.mlir.constant"() <{value = 16 : i64}> : () -> i64
  %1150 = "llvm.mlir.constant"() <{value = 24 : i64}> : () -> i64
  %1151 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %1152 = "llvm.mlir.constant"() <{value = 36 : i64}> : () -> i64
  %1153 = "llvm.mlir.constant"() <{value = 4503599627370495 : i64}> : () -> i64
  %1154 = "llvm.alloca"(%1143) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %1155 = "llvm.alloca"(%1143) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %1156 = "llvm.alloca"(%1143) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %1157 = "llvm.alloca"(%1143) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%1154) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1155) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1156) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1157) : (!llvm.ptr) -> ()
  %1158 = "llvm.load"(%arg65) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1159 = "llvm.getelementptr"(%arg65) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %1160 = "llvm.load"(%1159) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %1161 = "llvm.zext"(%1160) : (i32) -> i64
  %1162 = "llvm.getelementptr"(%arg65) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 12>}> : (!llvm.ptr) -> !llvm.ptr
  %1163 = "llvm.load"(%1162) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1164 = "llvm.zext"(%1163) : (i8) -> i64
  %1165 = "llvm.shl"(%1164, %1146) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1166 = "llvm.or"(%1165, %1161) <{isDisjoint}> : (i64, i64) -> i64
  %1167 = "llvm.getelementptr"(%arg65) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 13>}> : (!llvm.ptr) -> !llvm.ptr
  %1168 = "llvm.load"(%1167) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1169 = "llvm.zext"(%1168) : (i8) -> i64
  %1170 = "llvm.shl"(%1169, %1147) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1171 = "llvm.getelementptr"(%arg65) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 14>}> : (!llvm.ptr) -> !llvm.ptr
  %1172 = "llvm.load"(%1171) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i16
  %1173 = "llvm.zext"(%1172) : (i16) -> i64
  %1174 = "llvm.shl"(%1173, %1148) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %1175 = "llvm.or"(%1170, %1174) <{isDisjoint}> : (i64, i64) -> i64
  %1176 = "llvm.or"(%1175, %1166) <{isDisjoint}> : (i64, i64) -> i64
  "llvm.store"(%1176, %1155) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1177 = "llvm.getelementptr"(%arg65) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %1178 = "llvm.load"(%1177) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i16
  %1179 = "llvm.zext"(%1178) : (i16) -> i64
  %1180 = "llvm.getelementptr"(%arg65) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 18>}> : (!llvm.ptr) -> !llvm.ptr
  %1181 = "llvm.load"(%1180) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1182 = "llvm.zext"(%1181) : (i8) -> i64
  %1183 = "llvm.shl"(%1182, %1149) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1184 = "llvm.or"(%1183, %1179) <{isDisjoint}> : (i64, i64) -> i64
  %1185 = "llvm.getelementptr"(%arg65) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 19>}> : (!llvm.ptr) -> !llvm.ptr
  %1186 = "llvm.load"(%1185) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1187 = "llvm.zext"(%1186) : (i8) -> i64
  %1188 = "llvm.shl"(%1187, %1150) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1189 = "llvm.or"(%1188, %1184) <{isDisjoint}> : (i64, i64) -> i64
  %1190 = "llvm.getelementptr"(%arg65) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 20>}> : (!llvm.ptr) -> !llvm.ptr
  %1191 = "llvm.load"(%1190) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i16
  %1192 = "llvm.zext"(%1191) : (i16) -> i64
  %1193 = "llvm.shl"(%1192, %1146) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1194 = "llvm.getelementptr"(%arg65) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 22>}> : (!llvm.ptr) -> !llvm.ptr
  %1195 = "llvm.load"(%1194) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i16
  %1196 = "llvm.zext"(%1195) : (i16) -> i64
  %1197 = "llvm.shl"(%1196, %1148) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %1198 = "llvm.or"(%1193, %1197) <{isDisjoint}> : (i64, i64) -> i64
  %1199 = "llvm.or"(%1198, %1189) <{isDisjoint}> : (i64, i64) -> i64
  "llvm.store"(%1199, %1156) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1200 = "llvm.getelementptr"(%arg65) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %1201 = "llvm.load"(%1200) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1202 = "llvm.zext"(%1201) : (i8) -> i64
  %1203 = "llvm.getelementptr"(%arg65) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 25>}> : (!llvm.ptr) -> !llvm.ptr
  %1204 = "llvm.load"(%1203) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1205 = "llvm.zext"(%1204) : (i8) -> i64
  %1206 = "llvm.shl"(%1205, %1144) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1207 = "llvm.or"(%1206, %1202) <{isDisjoint}> : (i64, i64) -> i64
  %1208 = "llvm.getelementptr"(%arg65) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 26>}> : (!llvm.ptr) -> !llvm.ptr
  %1209 = "llvm.load"(%1208) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i16
  %1210 = "llvm.zext"(%1209) : (i16) -> i64
  %1211 = "llvm.shl"(%1210, %1149) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1212 = "llvm.getelementptr"(%arg65) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 28>}> : (!llvm.ptr) -> !llvm.ptr
  %1213 = "llvm.load"(%1212) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i16
  %1214 = "llvm.zext"(%1213) : (i16) -> i64
  %1215 = "llvm.shl"(%1214, %1146) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1216 = "llvm.or"(%1211, %1215) <{isDisjoint}> : (i64, i64) -> i64
  %1217 = "llvm.getelementptr"(%arg65) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 30>}> : (!llvm.ptr) -> !llvm.ptr
  %1218 = "llvm.load"(%1217) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i16
  %1219 = "llvm.zext"(%1218) : (i16) -> i64
  %1220 = "llvm.shl"(%1219, %1148) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %1221 = "llvm.or"(%1216, %1220) <{isDisjoint}> : (i64, i64) -> i64
  %1222 = "llvm.or"(%1221, %1207) <{isDisjoint}> : (i64, i64) -> i64
  "llvm.store"(%1222, %1157) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.store"(%1151, %1154) <{alias_scopes = [#alias_scope21], alignment = 8 : i64, noalias_scopes = [#alias_scope22], ordering = 0 : i64, volatile_}> : (i64, !llvm.ptr) -> ()
  "llvm.fence"() <{ordering = 7 : i64, syncscope = "singlethread"}> : () -> ()
  "llvm.store"(%1151, %1155) <{alias_scopes = [#alias_scope21], alignment = 8 : i64, noalias_scopes = [#alias_scope22], ordering = 0 : i64, volatile_}> : (i64, !llvm.ptr) -> ()
  "llvm.fence"() <{ordering = 7 : i64, syncscope = "singlethread"}> : () -> ()
  "llvm.store"(%1151, %1156) <{alias_scopes = [#alias_scope21], alignment = 8 : i64, noalias_scopes = [#alias_scope22], ordering = 0 : i64, volatile_}> : (i64, !llvm.ptr) -> ()
  "llvm.fence"() <{ordering = 7 : i64, syncscope = "singlethread"}> : () -> ()
  "llvm.store"(%1151, %1157) <{alias_scopes = [#alias_scope21], alignment = 8 : i64, noalias_scopes = [#alias_scope22], ordering = 0 : i64, volatile_}> : (i64, !llvm.ptr) -> ()
  "llvm.fence"() <{ordering = 7 : i64, syncscope = "singlethread"}> : () -> ()
  %1223 = "llvm.lshr"(%1221, %1149) <{isExact}> : (i64, i64) -> i64
  %1224 = "llvm.intr.fshl"(%1207, %1199, %1152) : (i64, i64, i64) -> i64
  %1225 = "llvm.intr.fshl"(%1189, %1175, %1150) : (i64, i64, i64) -> i64
  %1226 = "llvm.and"(%1225, %1153) : (i64, i64) -> i64
  %1227 = "llvm.intr.fshl"(%1166, %1158, %1145) : (i64, i64, i64) -> i64
  %1228 = "llvm.and"(%1158, %1153) : (i64, i64) -> i64
  "llvm.store"(%1228, %arg64) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1229 = "llvm.getelementptr"(%arg64) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1227, %1229) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1230 = "llvm.getelementptr"(%arg64) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1226, %1230) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1231 = "llvm.getelementptr"(%arg64) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1224, %1231) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1232 = "llvm.getelementptr"(%arg64) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1223, %1232) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1154) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1155) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1156) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1157) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
