module

-- agave-build/out/avx2-noinline/op/_RNvXNvXsh_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx27edwardsRNtB8_13ExtendedPointINtNtNtCsgxBkk5gSRhY_4core3ops5arith3AddRNtB8_11CachedPointE3addB1c_NtB2_12___Impl_add__9__impl_add.mlir
-- <&solana_ed25519[c79103de3f6f5451]::backend::vector::avx2::edwards::ExtendedPoint as <&solana_ed25519[c79103de3f6f5451]::backend::vector::avx2::edwards::ExtendedPoint as core[c0acaeba6ab4c2e0]::ops::arith::Add<&solana_ed25519[c79103de3f6f5451]::backend::vector::avx2::edwards::CachedPoint>>::add::__Impl_add__>::_impl_add

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Agave.Avx2.Mlir.FieldElement2625x4_Mul_mul_impl_mul

meta import MLIR.Semantics.Func
meta import Agave.Avx2.Mlir.FieldElement2625x4_Mul_mul_impl_mul

namespace MLIR.Agave.Avx2

@[expose] public section

mlir_def ExtendedPoint_Add_CachedPoint_add_impl_add :=
#alias_scope_domain118 = #llvm.alias_scope_domain<id = distinct[118]<>, description = "_RNvXNvMsb_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx25fieldNtB8_18FieldElement2625x47shuffleB1a_NtB2_16___Impl_shuffle__13__impl_shuffle">
#alias_scope_domain119 = #llvm.alias_scope_domain<id = distinct[119]<>, description = "_RNvXNvMsb_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx25fieldNtB8_18FieldElement2625x48diff_sumB1a_NtB2_17___Impl_diff_sum__14__impl_diff_sum">
#alias_scope_domain120 = #llvm.alias_scope_domain<id = distinct[120]<>, description = "_RNvXNvMsb_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx25fieldNtB8_18FieldElement2625x47shuffleB1a_NtB2_16___Impl_shuffle__13__impl_shuffle">
#alias_scope_domain121 = #llvm.alias_scope_domain<id = distinct[121]<>, description = "_RNvXNvMsb_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx25fieldNtB8_18FieldElement2625x47shuffleB1a_NtB2_16___Impl_shuffle__13__impl_shuffle">
#alias_scope_domain122 = #llvm.alias_scope_domain<id = distinct[122]<>, description = "_RNvXNvMsb_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx25fieldNtB8_18FieldElement2625x47shuffleB1a_NtB2_16___Impl_shuffle__13__impl_shuffle">
#alias_scope204 = #llvm.alias_scope<id = distinct[346]<>, domain = #alias_scope_domain118, description = "_RNvXNvMsb_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx25fieldNtB8_18FieldElement2625x47shuffleB1a_NtB2_16___Impl_shuffle__13__impl_shuffle: argument 1">
#alias_scope205 = #llvm.alias_scope<id = distinct[347]<>, domain = #alias_scope_domain119, description = "_RNvXNvMsb_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx25fieldNtB8_18FieldElement2625x48diff_sumB1a_NtB2_17___Impl_diff_sum__14__impl_diff_sum: argument 1">
#alias_scope206 = #llvm.alias_scope<id = distinct[348]<>, domain = #alias_scope_domain118, description = "_RNvXNvMsb_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx25fieldNtB8_18FieldElement2625x47shuffleB1a_NtB2_16___Impl_shuffle__13__impl_shuffle: argument 0">
#alias_scope207 = #llvm.alias_scope<id = distinct[349]<>, domain = #alias_scope_domain119, description = "_RNvXNvMsb_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx25fieldNtB8_18FieldElement2625x48diff_sumB1a_NtB2_17___Impl_diff_sum__14__impl_diff_sum: argument 0">
#alias_scope208 = #llvm.alias_scope<id = distinct[350]<>, domain = #alias_scope_domain120, description = "_RNvXNvMsb_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx25fieldNtB8_18FieldElement2625x47shuffleB1a_NtB2_16___Impl_shuffle__13__impl_shuffle: argument 1">
#alias_scope209 = #llvm.alias_scope<id = distinct[351]<>, domain = #alias_scope_domain120, description = "_RNvXNvMsb_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx25fieldNtB8_18FieldElement2625x47shuffleB1a_NtB2_16___Impl_shuffle__13__impl_shuffle: argument 0">
#alias_scope210 = #llvm.alias_scope<id = distinct[352]<>, domain = #alias_scope_domain121, description = "_RNvXNvMsb_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx25fieldNtB8_18FieldElement2625x47shuffleB1a_NtB2_16___Impl_shuffle__13__impl_shuffle: argument 0">
#alias_scope211 = #llvm.alias_scope<id = distinct[353]<>, domain = #alias_scope_domain121, description = "_RNvXNvMsb_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx25fieldNtB8_18FieldElement2625x47shuffleB1a_NtB2_16___Impl_shuffle__13__impl_shuffle: argument 1">
#alias_scope212 = #llvm.alias_scope<id = distinct[354]<>, domain = #alias_scope_domain122, description = "_RNvXNvMsb_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx25fieldNtB8_18FieldElement2625x47shuffleB1a_NtB2_16___Impl_shuffle__13__impl_shuffle: argument 0">
#alias_scope213 = #llvm.alias_scope<id = distinct[355]<>, domain = #alias_scope_domain122, description = "_RNvXNvMsb_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx25fieldNtB8_18FieldElement2625x47shuffleB1a_NtB2_16___Impl_shuffle__13__impl_shuffle: argument 1">
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 32 : i64, llvm.dead_on_unwind, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writable, llvm.writeonly}, {llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], sym_name = "_RNvXNvXsh_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx27edwardsRNtB8_13ExtendedPointINtNtNtCsgxBkk5gSRhY_4core3ops5arith3AddRNtB8_11CachedPointE3addB1c_NtB2_12___Impl_add__9__impl_add", target_cpu = "x86-64-v2", target_features = #llvm.target_features<["+avx", "+avx2", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+crc32", "+ssse3", "+avx", "+avx2", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+crc32", "+ssse3"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg23: !llvm.ptr, %arg24: !llvm.ptr, %arg25: !llvm.ptr):
  %1056 = "llvm.mlir.constant"() <{value = 134217726 : i32}> : () -> i32
  %1057 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %1058 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %1059 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %1060 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %1061 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %1062 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %1063 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1064 = "llvm.mlir.constant"() <{value = 160 : i64}> : () -> i64
  %1065 = "llvm.mlir.poison"() : () -> vector<8xi32>
  %1066 = "llvm.mlir.poison"() : () -> i32
  %1067 = "llvm.mlir.constant"() <{value = 67108862 : i32}> : () -> i32
  %1068 = "llvm.mlir.constant"() <{value = 134217690 : i32}> : () -> i32
  %1069 = "llvm.mlir.undef"() : () -> vector<8xi32>
  %1070 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %1071 = "llvm.insertelement"(%1069, %1068, %1070) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1072 = "llvm.insertelement"(%1071, %1066, %1063) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1073 = "llvm.insertelement"(%1072, %1067, %1062) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1074 = "llvm.insertelement"(%1073, %1066, %1061) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1075 = "llvm.insertelement"(%1074, %1066, %1060) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1076 = "llvm.insertelement"(%1075, %1066, %1059) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1077 = "llvm.insertelement"(%1076, %1066, %1058) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1078 = "llvm.insertelement"(%1077, %1066, %1057) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1079 = "llvm.insertelement"(%1069, %1056, %1070) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1080 = "llvm.insertelement"(%1079, %1066, %1063) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1081 = "llvm.insertelement"(%1080, %1067, %1062) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1082 = "llvm.insertelement"(%1081, %1066, %1061) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1083 = "llvm.insertelement"(%1082, %1066, %1060) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1084 = "llvm.insertelement"(%1083, %1066, %1059) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1085 = "llvm.insertelement"(%1084, %1066, %1058) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1086 = "llvm.insertelement"(%1085, %1066, %1057) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1087 = "llvm.insertelement"(%1069, %1068, %1070) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1088 = "llvm.insertelement"(%1087, %1066, %1063) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1089 = "llvm.insertelement"(%1088, %1067, %1062) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1090 = "llvm.insertelement"(%1089, %1066, %1061) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1091 = "llvm.insertelement"(%1090, %1068, %1060) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1092 = "llvm.insertelement"(%1091, %1066, %1059) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1093 = "llvm.insertelement"(%1092, %1067, %1058) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1094 = "llvm.insertelement"(%1093, %1066, %1057) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1095 = "llvm.insertelement"(%1069, %1056, %1070) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1096 = "llvm.insertelement"(%1095, %1066, %1063) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1097 = "llvm.insertelement"(%1096, %1067, %1062) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1098 = "llvm.insertelement"(%1097, %1066, %1061) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1099 = "llvm.insertelement"(%1098, %1056, %1060) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1100 = "llvm.insertelement"(%1099, %1066, %1059) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1101 = "llvm.insertelement"(%1100, %1067, %1058) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1102 = "llvm.insertelement"(%1101, %1066, %1057) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %1103 = "llvm.alloca"(%1063) <{alignment = 32 : i64, elem_type = !llvm.array<160 x i8>}> : (i32) -> !llvm.ptr
  %1104 = "llvm.alloca"(%1063) <{alignment = 32 : i64, elem_type = !llvm.array<160 x i8>}> : (i32) -> !llvm.ptr
  %1105 = "llvm.alloca"(%1063) <{alignment = 32 : i64, elem_type = !llvm.array<160 x i8>}> : (i32) -> !llvm.ptr
  %1106 = "llvm.alloca"(%1063) <{alignment = 32 : i64, elem_type = !llvm.array<160 x i8>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%1106) : (!llvm.ptr) -> ()
  "llvm.intr.memcpy"(%1106, %arg24, %1064) <{arg_attrs = [{llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %1107 = "llvm.load"(%1106) <{alias_scopes = [#alias_scope204, #alias_scope205], alignment = 32 : i64, noalias_scopes = [#alias_scope206, #alias_scope207], ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %1108 = "llvm.getelementptr"(%1106) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %1109 = "llvm.load"(%1108) <{alias_scopes = [#alias_scope204, #alias_scope205], alignment = 32 : i64, noalias_scopes = [#alias_scope206, #alias_scope207], ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %1110 = "llvm.getelementptr"(%1106) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %1111 = "llvm.load"(%1110) <{alias_scopes = [#alias_scope204, #alias_scope205], alignment = 32 : i64, noalias_scopes = [#alias_scope206, #alias_scope207], ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %1112 = "llvm.getelementptr"(%1106) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %1113 = "llvm.load"(%1112) <{alias_scopes = [#alias_scope204, #alias_scope205], alignment = 32 : i64, noalias_scopes = [#alias_scope206, #alias_scope207], ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %1114 = "llvm.shufflevector"(%1107, %1065) <{mask = array<i32: 1, 0, 3, 2, -1, -1, -1, -1>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1115 = "llvm.shufflevector"(%1109, %1065) <{mask = array<i32: 1, 0, 3, 2, -1, -1, -1, -1>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1116 = "llvm.shufflevector"(%1111, %1065) <{mask = array<i32: 1, 0, 3, 2, -1, -1, -1, -1>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1117 = "llvm.shufflevector"(%1113, %1065) <{mask = array<i32: 1, 0, 3, 2, -1, -1, -1, -1>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1118 = "llvm.getelementptr"(%1106) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %1119 = "llvm.load"(%1118) <{alias_scopes = [#alias_scope204, #alias_scope205], alignment = 32 : i64, noalias_scopes = [#alias_scope206, #alias_scope207], ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %1120 = "llvm.shufflevector"(%1119, %1065) <{mask = array<i32: 1, 0, 3, 2, -1, -1, -1, -1>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1121 = "llvm.sub"(%1078, %1107) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1122 = "llvm.sub"(%1086, %1109) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1123 = "llvm.sub"(%1086, %1111) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1124 = "llvm.sub"(%1086, %1113) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1125 = "llvm.sub"(%1086, %1119) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1126 = "llvm.shufflevector"(%1121, %1107) <{mask = array<i32: 0, 9, 2, 11, -1, -1, -1, -1>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1127 = "llvm.shufflevector"(%1122, %1109) <{mask = array<i32: 0, 9, 2, 11, -1, -1, -1, -1>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1128 = "llvm.shufflevector"(%1123, %1111) <{mask = array<i32: 0, 9, 2, 11, -1, -1, -1, -1>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1129 = "llvm.shufflevector"(%1124, %1113) <{mask = array<i32: 0, 9, 2, 11, -1, -1, -1, -1>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1130 = "llvm.shufflevector"(%1125, %1119) <{mask = array<i32: 0, 9, 2, 11, -1, -1, -1, -1>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1131 = "llvm.add"(%1126, %1114) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1132 = "llvm.add"(%1127, %1115) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1133 = "llvm.add"(%1128, %1116) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1134 = "llvm.add"(%1129, %1117) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1135 = "llvm.add"(%1130, %1120) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1136 = "llvm.shufflevector"(%1131, %1107) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1137 = "llvm.shufflevector"(%1132, %1109) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1138 = "llvm.shufflevector"(%1133, %1111) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1139 = "llvm.shufflevector"(%1134, %1113) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1140 = "llvm.shufflevector"(%1135, %1119) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  "llvm.store"(%1136, %1106) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  "llvm.store"(%1137, %1108) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  "llvm.store"(%1138, %1110) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  "llvm.store"(%1139, %1112) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  "llvm.store"(%1140, %1118) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1105) : (!llvm.ptr) -> ()
  "llvm.call"(%1105, %1106, %arg25) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvXNvXsf_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx25fieldRNtB8_18FieldElement2625x4NtNtNtCsgxBkk5gSRhY_4core3ops5arith3Mul3mulB1a_NtB2_12___Impl_mul__9__impl_mul, fastmathFlags = #llvm.fastmath<none>, inline_hint, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.memcpy"(%1106, %1105, %1064) <{arg_attrs = [{llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.intr.lifetime.end"(%1105) : (!llvm.ptr) -> ()
  %1141 = "llvm.load"(%1106) <{alias_scopes = [#alias_scope208], alignment = 32 : i64, noalias_scopes = [#alias_scope209], ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %1142 = "llvm.load"(%1108) <{alias_scopes = [#alias_scope208], alignment = 32 : i64, noalias_scopes = [#alias_scope209], ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %1143 = "llvm.load"(%1110) <{alias_scopes = [#alias_scope208], alignment = 32 : i64, noalias_scopes = [#alias_scope209], ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %1144 = "llvm.load"(%1112) <{alias_scopes = [#alias_scope208], alignment = 32 : i64, noalias_scopes = [#alias_scope209], ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %1145 = "llvm.shufflevector"(%1141, %1065) <{mask = array<i32: 0, 1, 2, 3, 5, 4, 7, 6>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1146 = "llvm.shufflevector"(%1142, %1065) <{mask = array<i32: 0, 1, 2, 3, 5, 4, 7, 6>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1147 = "llvm.shufflevector"(%1143, %1065) <{mask = array<i32: 0, 1, 2, 3, 5, 4, 7, 6>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1148 = "llvm.shufflevector"(%1144, %1065) <{mask = array<i32: 0, 1, 2, 3, 5, 4, 7, 6>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1149 = "llvm.load"(%1118) <{alias_scopes = [#alias_scope208], alignment = 32 : i64, noalias_scopes = [#alias_scope209], ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %1150 = "llvm.shufflevector"(%1149, %1065) <{mask = array<i32: 0, 1, 2, 3, 5, 4, 7, 6>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1151 = "llvm.shufflevector"(%1141, %1065) <{mask = array<i32: 1, 0, 3, 2, 4, 5, 6, 7>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1152 = "llvm.shufflevector"(%1142, %1065) <{mask = array<i32: 1, 0, 3, 2, 4, 5, 6, 7>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1153 = "llvm.shufflevector"(%1143, %1065) <{mask = array<i32: 1, 0, 3, 2, 4, 5, 6, 7>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1154 = "llvm.shufflevector"(%1144, %1065) <{mask = array<i32: 1, 0, 3, 2, 4, 5, 6, 7>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1155 = "llvm.shufflevector"(%1149, %1065) <{mask = array<i32: 1, 0, 3, 2, 4, 5, 6, 7>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1156 = "llvm.sub"(%1094, %1145) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1157 = "llvm.sub"(%1102, %1146) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1158 = "llvm.sub"(%1102, %1147) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1159 = "llvm.sub"(%1102, %1148) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1160 = "llvm.sub"(%1102, %1150) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1161 = "llvm.shufflevector"(%1156, %1145) <{mask = array<i32: 0, 9, 2, 11, 4, 13, 6, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1162 = "llvm.shufflevector"(%1157, %1146) <{mask = array<i32: 0, 9, 2, 11, 4, 13, 6, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1163 = "llvm.shufflevector"(%1158, %1147) <{mask = array<i32: 0, 9, 2, 11, 4, 13, 6, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1164 = "llvm.shufflevector"(%1159, %1148) <{mask = array<i32: 0, 9, 2, 11, 4, 13, 6, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1165 = "llvm.shufflevector"(%1160, %1150) <{mask = array<i32: 0, 9, 2, 11, 4, 13, 6, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1166 = "llvm.add"(%1161, %1151) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1167 = "llvm.add"(%1162, %1152) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1168 = "llvm.add"(%1163, %1153) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1169 = "llvm.add"(%1164, %1154) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1170 = "llvm.add"(%1165, %1155) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  "llvm.intr.lifetime.start"(%1104) : (!llvm.ptr) -> ()
  %1171 = "llvm.shufflevector"(%1166, %1065) <{mask = array<i32: 0, 5, 2, 7, 5, 0, 7, 2>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1172 = "llvm.shufflevector"(%1167, %1065) <{mask = array<i32: 0, 5, 2, 7, 5, 0, 7, 2>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1173 = "llvm.shufflevector"(%1168, %1065) <{mask = array<i32: 0, 5, 2, 7, 5, 0, 7, 2>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1174 = "llvm.shufflevector"(%1169, %1065) <{mask = array<i32: 0, 5, 2, 7, 5, 0, 7, 2>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1175 = "llvm.shufflevector"(%1170, %1065) <{mask = array<i32: 0, 5, 2, 7, 5, 0, 7, 2>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  "llvm.store"(%1171, %1104) <{alias_scopes = [#alias_scope210], alignment = 32 : i64, noalias_scopes = [#alias_scope211], ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  %1176 = "llvm.getelementptr"(%1104) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1172, %1176) <{alias_scopes = [#alias_scope210], alignment = 32 : i64, noalias_scopes = [#alias_scope211], ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  %1177 = "llvm.getelementptr"(%1104) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1173, %1177) <{alias_scopes = [#alias_scope210], alignment = 32 : i64, noalias_scopes = [#alias_scope211], ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  %1178 = "llvm.getelementptr"(%1104) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1174, %1178) <{alias_scopes = [#alias_scope210], alignment = 32 : i64, noalias_scopes = [#alias_scope211], ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  %1179 = "llvm.getelementptr"(%1104) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1175, %1179) <{alias_scopes = [#alias_scope210], alignment = 32 : i64, noalias_scopes = [#alias_scope211], ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1103) : (!llvm.ptr) -> ()
  %1180 = "llvm.shufflevector"(%1166, %1065) <{mask = array<i32: 4, 1, 6, 3, 4, 1, 6, 3>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1181 = "llvm.shufflevector"(%1167, %1065) <{mask = array<i32: 4, 1, 6, 3, 4, 1, 6, 3>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1182 = "llvm.shufflevector"(%1168, %1065) <{mask = array<i32: 4, 1, 6, 3, 4, 1, 6, 3>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1183 = "llvm.shufflevector"(%1169, %1065) <{mask = array<i32: 4, 1, 6, 3, 4, 1, 6, 3>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1184 = "llvm.shufflevector"(%1170, %1065) <{mask = array<i32: 4, 1, 6, 3, 4, 1, 6, 3>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  "llvm.store"(%1180, %1103) <{alias_scopes = [#alias_scope212], alignment = 32 : i64, noalias_scopes = [#alias_scope213], ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  %1185 = "llvm.getelementptr"(%1103) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1181, %1185) <{alias_scopes = [#alias_scope212], alignment = 32 : i64, noalias_scopes = [#alias_scope213], ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  %1186 = "llvm.getelementptr"(%1103) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1182, %1186) <{alias_scopes = [#alias_scope212], alignment = 32 : i64, noalias_scopes = [#alias_scope213], ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  %1187 = "llvm.getelementptr"(%1103) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1183, %1187) <{alias_scopes = [#alias_scope212], alignment = 32 : i64, noalias_scopes = [#alias_scope213], ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  %1188 = "llvm.getelementptr"(%1103) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1184, %1188) <{alias_scopes = [#alias_scope212], alignment = 32 : i64, noalias_scopes = [#alias_scope213], ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  "llvm.call"(%arg23, %1104, %1103) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvXNvXsf_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx25fieldRNtB8_18FieldElement2625x4NtNtNtCsgxBkk5gSRhY_4core3ops5arith3Mul3mulB1a_NtB2_12___Impl_mul__9__impl_mul, fastmathFlags = #llvm.fastmath<none>, inline_hint, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1103) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1104) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1106) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
  with
    @_RNvXNvXsf_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx25fieldRNtB8_18FieldElement2625x4NtNtNtCsgxBkk5gSRhY_4core3ops5arith3Mul3mulB1a_NtB2_12___Impl_mul__9__impl_mul := FieldElement2625x4_Mul_mul_impl_mul

end

end MLIR.Agave.Avx2
