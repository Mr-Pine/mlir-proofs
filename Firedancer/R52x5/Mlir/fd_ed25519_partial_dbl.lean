module

-- ~/fd-pr9879/build/llvm23-production/mlir_canonicalized/avx512/op/fd_ed25519_partial_dbl.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.R52x5.Mlir.fd_r52x5_quad_mul_fast
public import Firedancer.R52x5.Mlir.fd_r52x5_quad_sqr_fast
public import Firedancer.R52x5.Mlir.wc_bcast_wide
public import Firedancer.R52x5.Mlir.wl_permute

meta import MLIR.Semantics.Func
meta import Firedancer.R52x5.Mlir.fd_r52x5_quad_mul_fast
meta import Firedancer.R52x5.Mlir.fd_r52x5_quad_sqr_fast
meta import Firedancer.R52x5.Mlir.wc_bcast_wide
meta import Firedancer.R52x5.Mlir.wl_permute

namespace MLIR.Firedancer.R52x5

@[expose] public section

mlir_def fd_ed25519_partial_dbl :=
#tbaa_root = #llvm.tbaa_root<id = "Simple C/C++ TBAA">
#tbaa_type_desc = #llvm.tbaa_type_desc<id = "omnipotent char", members = {<#tbaa_root, 0>}>
#tbaa_tag = #llvm.tbaa_tag<base_type = #tbaa_type_desc, access_type = #tbaa_type_desc, offset = 0>
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nofree, llvm.nonnull, llvm.noundef, llvm.returned, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<ptr (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "256"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], res_attrs = [{llvm.nonnull, llvm.noundef}], sym_name = "fd_ed25519_partial_dbl", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg58: !llvm.ptr, %arg59: !llvm.ptr):
  %1059 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1060 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %1061 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %1062 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %1063 = "llvm.mlir.constant"() <{value = dense<51> : vector<4xi64>}> : () -> vector<4xi64>
  %1064 = "llvm.mlir.constant"() <{value = dense<2251799813685247> : vector<4xi64>}> : () -> vector<4xi64>
  %1065 = "llvm.mlir.constant"() <{value = dense<19> : vector<4xi64>}> : () -> vector<4xi64>
  %1066 = "llvm.mlir.constant"() <{value = dense<72057594037927328> : vector<4xi64>}> : () -> vector<4xi64>
  %1067 = "llvm.mlir.constant"() <{value = dense<72057594037927904> : vector<4xi64>}> : () -> vector<4xi64>
  %1068 = "llvm.mlir.constant"() <{value = dense<1> : vector<4xi64>}> : () -> vector<4xi64>
  %1069 = "llvm.mlir.constant"() <{value = dense<0> : vector<32xi8>}> : () -> vector<32xi8>
  %1070 = "llvm.alloca"(%1059) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1071 = "llvm.alloca"(%1059) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1072 = "llvm.alloca"(%1059) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1073 = "llvm.alloca"(%1059) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1074 = "llvm.alloca"(%1059) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1075 = "llvm.alloca"(%1059) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1076 = "llvm.alloca"(%1059) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1077 = "llvm.alloca"(%1059) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1078 = "llvm.alloca"(%1059) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1079 = "llvm.alloca"(%1059) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %1080 = "llvm.load"(%arg59) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %1081 = "llvm.call"(%1080, %1059, %1060, %1061, %1062) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1082 = "llvm.getelementptr"(%arg59) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %1083 = "llvm.load"(%1082) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %1084 = "llvm.call"(%1083, %1059, %1060, %1061, %1062) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1085 = "llvm.getelementptr"(%arg59) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %1086 = "llvm.load"(%1085) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %1087 = "llvm.call"(%1086, %1059, %1060, %1061, %1062) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1088 = "llvm.getelementptr"(%arg59) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %1089 = "llvm.load"(%1088) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %1090 = "llvm.call"(%1089, %1059, %1060, %1061, %1062) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1091 = "llvm.getelementptr"(%arg59) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %1092 = "llvm.load"(%1091) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %1093 = "llvm.call"(%1092, %1059, %1060, %1061, %1062) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1094 = "llvm.add"(%1081, %1080) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1095 = "llvm.add"(%1084, %1083) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1096 = "llvm.add"(%1087, %1086) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1097 = "llvm.add"(%1090, %1089) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1098 = "llvm.add"(%1093, %1092) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1099 = "llvm.call"(%1094, %1060, %1059, %1060, %1059) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1100 = "llvm.call"(%1095, %1060, %1059, %1060, %1059) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1101 = "llvm.call"(%1096, %1060, %1059, %1060, %1059) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1102 = "llvm.call"(%1097, %1060, %1059, %1060, %1059) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1103 = "llvm.call"(%1098, %1060, %1059, %1060, %1059) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1104 = "llvm.call"(%1060, %1060, %1060, %1059) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wc_bcast_wide, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (i32, i32, i32, i32) -> vector<4xi64>
  %1105 = "llvm.bitcast"(%1080) : (vector<4xi64>) -> vector<32xi8>
  %1106 = "llvm.bitcast"(%1099) : (vector<4xi64>) -> vector<32xi8>
  %1107 = "llvm.bitcast"(%1104) : (vector<4xi64>) -> vector<32xi8>
  %1108 = "llvm.call_intrinsic"(%1105, %1106, %1107) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1109 = "llvm.bitcast"(%1108) : (vector<32xi8>) -> vector<4xi64>
  %1110 = "llvm.bitcast"(%1083) : (vector<4xi64>) -> vector<32xi8>
  %1111 = "llvm.bitcast"(%1100) : (vector<4xi64>) -> vector<32xi8>
  %1112 = "llvm.call_intrinsic"(%1110, %1111, %1107) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1113 = "llvm.bitcast"(%1112) : (vector<32xi8>) -> vector<4xi64>
  %1114 = "llvm.bitcast"(%1086) : (vector<4xi64>) -> vector<32xi8>
  %1115 = "llvm.bitcast"(%1101) : (vector<4xi64>) -> vector<32xi8>
  %1116 = "llvm.call_intrinsic"(%1114, %1115, %1107) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1117 = "llvm.bitcast"(%1116) : (vector<32xi8>) -> vector<4xi64>
  %1118 = "llvm.bitcast"(%1089) : (vector<4xi64>) -> vector<32xi8>
  %1119 = "llvm.bitcast"(%1102) : (vector<4xi64>) -> vector<32xi8>
  %1120 = "llvm.call_intrinsic"(%1118, %1119, %1107) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1121 = "llvm.bitcast"(%1120) : (vector<32xi8>) -> vector<4xi64>
  %1122 = "llvm.bitcast"(%1092) : (vector<4xi64>) -> vector<32xi8>
  %1123 = "llvm.bitcast"(%1103) : (vector<4xi64>) -> vector<32xi8>
  %1124 = "llvm.call_intrinsic"(%1122, %1123, %1107) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1125 = "llvm.bitcast"(%1124) : (vector<32xi8>) -> vector<4xi64>
  %1126 = "llvm.lshr"(%1109, %1063) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1127 = "llvm.lshr"(%1113, %1063) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1128 = "llvm.lshr"(%1117, %1063) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1129 = "llvm.lshr"(%1121, %1063) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1130 = "llvm.lshr"(%1125, %1063) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1131 = "llvm.bitcast"(%1108) : (vector<32xi8>) -> vector<4xi64>
  %1132 = "llvm.and"(%1131, %1064) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1133 = "llvm.call_intrinsic"(%1132, %1130, %1065) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1134 = "llvm.bitcast"(%1112) : (vector<32xi8>) -> vector<4xi64>
  %1135 = "llvm.and"(%1134, %1064) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1136 = "llvm.add"(%1135, %1126) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1137 = "llvm.bitcast"(%1116) : (vector<32xi8>) -> vector<4xi64>
  %1138 = "llvm.and"(%1137, %1064) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1139 = "llvm.add"(%1138, %1127) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1140 = "llvm.bitcast"(%1120) : (vector<32xi8>) -> vector<4xi64>
  %1141 = "llvm.and"(%1140, %1064) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1142 = "llvm.add"(%1141, %1128) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1143 = "llvm.bitcast"(%1124) : (vector<32xi8>) -> vector<4xi64>
  %1144 = "llvm.and"(%1143, %1064) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1145 = "llvm.add"(%1144, %1129) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%1070) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1071) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1072) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1073) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1074) : (!llvm.ptr) -> ()
  "llvm.call"(%1070, %1071, %1072, %1073, %1074, %1133, %1136, %1139, %1142, %1145) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1146 = "llvm.load"(%1070) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %1147 = "llvm.load"(%1071) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %1148 = "llvm.load"(%1072) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %1149 = "llvm.load"(%1073) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %1150 = "llvm.load"(%1074) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%1074) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1073) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1072) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1071) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1070) : (!llvm.ptr) -> ()
  %1151 = "llvm.call"(%1146, %1060, %1060, %1060, %1060) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1152 = "llvm.call"(%1147, %1060, %1060, %1060, %1060) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1153 = "llvm.call"(%1148, %1060, %1060, %1060, %1060) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1154 = "llvm.call"(%1149, %1060, %1060, %1060, %1060) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1155 = "llvm.call"(%1150, %1060, %1060, %1060, %1060) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1156 = "llvm.call"(%1146, %1059, %1059, %1059, %1059) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1157 = "llvm.call"(%1147, %1059, %1059, %1059, %1059) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1158 = "llvm.call"(%1148, %1059, %1059, %1059, %1059) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1159 = "llvm.call"(%1149, %1059, %1059, %1059, %1059) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1160 = "llvm.call"(%1150, %1059, %1059, %1059, %1059) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1161 = "llvm.bitcast"(%1156) : (vector<4xi64>) -> vector<32xi8>
  %1162 = "llvm.bitcast"(%1146) : (vector<4xi64>) -> vector<32xi8>
  %1163 = "llvm.call_intrinsic"(%1161, %1162, %1107) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1164 = "llvm.bitcast"(%1163) : (vector<32xi8>) -> vector<4xi64>
  %1165 = "llvm.bitcast"(%1157) : (vector<4xi64>) -> vector<32xi8>
  %1166 = "llvm.bitcast"(%1147) : (vector<4xi64>) -> vector<32xi8>
  %1167 = "llvm.call_intrinsic"(%1165, %1166, %1107) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1168 = "llvm.bitcast"(%1167) : (vector<32xi8>) -> vector<4xi64>
  %1169 = "llvm.bitcast"(%1158) : (vector<4xi64>) -> vector<32xi8>
  %1170 = "llvm.bitcast"(%1148) : (vector<4xi64>) -> vector<32xi8>
  %1171 = "llvm.call_intrinsic"(%1169, %1170, %1107) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1172 = "llvm.bitcast"(%1171) : (vector<32xi8>) -> vector<4xi64>
  %1173 = "llvm.bitcast"(%1159) : (vector<4xi64>) -> vector<32xi8>
  %1174 = "llvm.bitcast"(%1149) : (vector<4xi64>) -> vector<32xi8>
  %1175 = "llvm.call_intrinsic"(%1173, %1174, %1107) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1176 = "llvm.bitcast"(%1175) : (vector<32xi8>) -> vector<4xi64>
  %1177 = "llvm.bitcast"(%1160) : (vector<4xi64>) -> vector<32xi8>
  %1178 = "llvm.bitcast"(%1150) : (vector<4xi64>) -> vector<32xi8>
  %1179 = "llvm.call_intrinsic"(%1177, %1178, %1107) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1180 = "llvm.bitcast"(%1179) : (vector<32xi8>) -> vector<4xi64>
  %1181 = "llvm.sub"(%1066, %1164) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1182 = "llvm.sub"(%1067, %1168) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1183 = "llvm.sub"(%1067, %1172) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1184 = "llvm.sub"(%1067, %1176) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1185 = "llvm.sub"(%1067, %1180) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1186 = "llvm.shl"(%1146, %1068) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1187 = "llvm.shl"(%1147, %1068) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1188 = "llvm.shl"(%1148, %1068) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1189 = "llvm.shl"(%1149, %1068) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1190 = "llvm.shl"(%1150, %1068) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1191 = "llvm.call"(%1060, %1060, %1059, %1060) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wc_bcast_wide, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (i32, i32, i32, i32) -> vector<4xi64>
  %1192 = "llvm.bitcast"(%1186) : (vector<4xi64>) -> vector<32xi8>
  %1193 = "llvm.bitcast"(%1191) : (vector<4xi64>) -> vector<32xi8>
  %1194 = "llvm.call_intrinsic"(%1069, %1192, %1193) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1195 = "llvm.bitcast"(%1194) : (vector<32xi8>) -> vector<4xi64>
  %1196 = "llvm.bitcast"(%1187) : (vector<4xi64>) -> vector<32xi8>
  %1197 = "llvm.call_intrinsic"(%1069, %1196, %1193) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1198 = "llvm.bitcast"(%1197) : (vector<32xi8>) -> vector<4xi64>
  %1199 = "llvm.bitcast"(%1188) : (vector<4xi64>) -> vector<32xi8>
  %1200 = "llvm.call_intrinsic"(%1069, %1199, %1193) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1201 = "llvm.bitcast"(%1200) : (vector<32xi8>) -> vector<4xi64>
  %1202 = "llvm.bitcast"(%1189) : (vector<4xi64>) -> vector<32xi8>
  %1203 = "llvm.call_intrinsic"(%1069, %1202, %1193) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1204 = "llvm.bitcast"(%1203) : (vector<32xi8>) -> vector<4xi64>
  %1205 = "llvm.bitcast"(%1190) : (vector<4xi64>) -> vector<32xi8>
  %1206 = "llvm.call_intrinsic"(%1069, %1205, %1193) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1207 = "llvm.bitcast"(%1206) : (vector<32xi8>) -> vector<4xi64>
  %1208 = "llvm.add"(%1151, %1195) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1209 = "llvm.add"(%1152, %1198) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1210 = "llvm.add"(%1153, %1201) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1211 = "llvm.add"(%1154, %1204) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1212 = "llvm.add"(%1155, %1207) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1213 = "llvm.call"(%1059, %1060, %1060, %1059) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wc_bcast_wide, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (i32, i32, i32, i32) -> vector<4xi64>
  %1214 = "llvm.bitcast"(%1213) : (vector<4xi64>) -> vector<32xi8>
  %1215 = "llvm.call_intrinsic"(%1069, %1161, %1214) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1216 = "llvm.bitcast"(%1215) : (vector<32xi8>) -> vector<4xi64>
  %1217 = "llvm.call_intrinsic"(%1069, %1165, %1214) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1218 = "llvm.bitcast"(%1217) : (vector<32xi8>) -> vector<4xi64>
  %1219 = "llvm.call_intrinsic"(%1069, %1169, %1214) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1220 = "llvm.bitcast"(%1219) : (vector<32xi8>) -> vector<4xi64>
  %1221 = "llvm.call_intrinsic"(%1069, %1173, %1214) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1222 = "llvm.bitcast"(%1221) : (vector<32xi8>) -> vector<4xi64>
  %1223 = "llvm.call_intrinsic"(%1069, %1177, %1214) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1224 = "llvm.bitcast"(%1223) : (vector<32xi8>) -> vector<4xi64>
  %1225 = "llvm.add"(%1208, %1216) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1226 = "llvm.add"(%1209, %1218) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1227 = "llvm.add"(%1210, %1220) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1228 = "llvm.add"(%1211, %1222) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1229 = "llvm.add"(%1212, %1224) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1230 = "llvm.call"(%1060, %1059, %1059, %1059) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wc_bcast_wide, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (i32, i32, i32, i32) -> vector<4xi64>
  %1231 = "llvm.bitcast"(%1181) : (vector<4xi64>) -> vector<32xi8>
  %1232 = "llvm.bitcast"(%1230) : (vector<4xi64>) -> vector<32xi8>
  %1233 = "llvm.call_intrinsic"(%1069, %1231, %1232) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1234 = "llvm.bitcast"(%1233) : (vector<32xi8>) -> vector<4xi64>
  %1235 = "llvm.bitcast"(%1182) : (vector<4xi64>) -> vector<32xi8>
  %1236 = "llvm.call_intrinsic"(%1069, %1235, %1232) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1237 = "llvm.bitcast"(%1236) : (vector<32xi8>) -> vector<4xi64>
  %1238 = "llvm.bitcast"(%1183) : (vector<4xi64>) -> vector<32xi8>
  %1239 = "llvm.call_intrinsic"(%1069, %1238, %1232) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1240 = "llvm.bitcast"(%1239) : (vector<32xi8>) -> vector<4xi64>
  %1241 = "llvm.bitcast"(%1184) : (vector<4xi64>) -> vector<32xi8>
  %1242 = "llvm.call_intrinsic"(%1069, %1241, %1232) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1243 = "llvm.bitcast"(%1242) : (vector<32xi8>) -> vector<4xi64>
  %1244 = "llvm.bitcast"(%1185) : (vector<4xi64>) -> vector<32xi8>
  %1245 = "llvm.call_intrinsic"(%1069, %1244, %1232) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx2.pblendvb", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<32xi8>, vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1246 = "llvm.bitcast"(%1245) : (vector<32xi8>) -> vector<4xi64>
  %1247 = "llvm.add"(%1225, %1234) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1248 = "llvm.add"(%1226, %1237) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1249 = "llvm.add"(%1227, %1240) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1250 = "llvm.add"(%1228, %1243) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1251 = "llvm.add"(%1229, %1246) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1252 = "llvm.lshr"(%1247, %1063) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1253 = "llvm.lshr"(%1248, %1063) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1254 = "llvm.lshr"(%1249, %1063) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1255 = "llvm.lshr"(%1250, %1063) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1256 = "llvm.lshr"(%1251, %1063) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1257 = "llvm.and"(%1247, %1064) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1258 = "llvm.call_intrinsic"(%1257, %1256, %1065) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1259 = "llvm.and"(%1248, %1064) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1260 = "llvm.add"(%1259, %1252) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1261 = "llvm.and"(%1249, %1064) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1262 = "llvm.add"(%1261, %1253) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1263 = "llvm.and"(%1250, %1064) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1264 = "llvm.add"(%1263, %1254) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1265 = "llvm.and"(%1251, %1064) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1266 = "llvm.add"(%1265, %1255) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1267 = "llvm.call"(%1258, %1061, %1059, %1059, %1061) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1268 = "llvm.call"(%1260, %1061, %1059, %1059, %1061) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1269 = "llvm.call"(%1262, %1061, %1059, %1059, %1061) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1270 = "llvm.call"(%1264, %1061, %1059, %1059, %1061) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1271 = "llvm.call"(%1266, %1061, %1059, %1059, %1061) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1272 = "llvm.call"(%1258, %1062, %1060, %1062, %1060) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1273 = "llvm.call"(%1260, %1062, %1060, %1062, %1060) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1274 = "llvm.call"(%1262, %1062, %1060, %1062, %1060) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1275 = "llvm.call"(%1264, %1062, %1060, %1062, %1060) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1276 = "llvm.call"(%1266, %1062, %1060, %1062, %1060) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%1075) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1076) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1077) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1078) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1079) : (!llvm.ptr) -> ()
  "llvm.call"(%1075, %1076, %1077, %1078, %1079, %1272, %1273, %1274, %1275, %1276, %1267, %1268, %1269, %1270, %1271) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1277 = "llvm.load"(%1075) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %1278 = "llvm.load"(%1076) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %1279 = "llvm.getelementptr"(%arg58) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %1280 = "llvm.load"(%1077) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %1281 = "llvm.getelementptr"(%arg58) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %1282 = "llvm.load"(%1078) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %1283 = "llvm.getelementptr"(%arg58) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %1284 = "llvm.load"(%1079) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %1285 = "llvm.getelementptr"(%arg58) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.lifetime.end"(%1079) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1078) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1077) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1076) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1075) : (!llvm.ptr) -> ()
  %1286 = "llvm.lshr"(%1277, %1063) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1287 = "llvm.lshr"(%1278, %1063) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1288 = "llvm.lshr"(%1280, %1063) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1289 = "llvm.lshr"(%1282, %1063) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1290 = "llvm.lshr"(%1284, %1063) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1291 = "llvm.and"(%1277, %1064) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1292 = "llvm.call_intrinsic"(%1291, %1290, %1065) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.store"(%1292, %arg58) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<4xi64>, !llvm.ptr) -> ()
  %1293 = "llvm.and"(%1278, %1064) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1294 = "llvm.add"(%1293, %1286) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.store"(%1294, %1279) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<4xi64>, !llvm.ptr) -> ()
  %1295 = "llvm.and"(%1280, %1064) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1296 = "llvm.add"(%1295, %1287) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.store"(%1296, %1281) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<4xi64>, !llvm.ptr) -> ()
  %1297 = "llvm.and"(%1282, %1064) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1298 = "llvm.add"(%1297, %1288) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.store"(%1298, %1283) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<4xi64>, !llvm.ptr) -> ()
  %1299 = "llvm.and"(%1284, %1064) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1300 = "llvm.add"(%1299, %1289) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.store"(%1300, %1285) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.return"(%arg58) : (!llvm.ptr) -> ()
}) : () -> ()
  with @fd_r52x5_quad_mul_fast := fd_r52x5_quad_mul_fast,
    @fd_r52x5_quad_sqr_fast := fd_r52x5_quad_sqr_fast, @wc_bcast_wide := wc_bcast_wide,
    @wl_permute := wl_permute

end

end MLIR.Firedancer.R52x5
