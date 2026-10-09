module

-- build/llvm23/mlir_canonicalized/avx512/op/fd_ed25519_point_dbln.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Avx512.Mlir.fd_r43x6_quad_mul_fast
public import Firedancer.Avx512.Mlir.fd_r43x6_quad_sqr_fast

meta import MLIR.Semantics.Func
meta import Firedancer.Avx512.Mlir.fd_r43x6_quad_mul_fast
meta import Firedancer.Avx512.Mlir.fd_r43x6_quad_sqr_fast

namespace MLIR.Firedancer.Avx512

@[expose] public section

mlir_def fd_ed25519_point_dbln :=
#loop_unroll = #llvm.loop_unroll<disable = true>
#tbaa_root = #llvm.tbaa_root<id = "Simple C/C++ TBAA">
#loop_annotation = #llvm.loop_annotation<unroll = #loop_unroll, mustProgress = true>
#tbaa_type_desc = #llvm.tbaa_type_desc<id = "omnipotent char", members = {<#tbaa_root, 0>}>
#tbaa_tag = #llvm.tbaa_tag<base_type = #tbaa_type_desc, access_type = #tbaa_type_desc, offset = 0>
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nofree, llvm.noundef, llvm.returned, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.noundef}], dso_local, function_type = !llvm.func<ptr (ptr, ptr, i32)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], res_attrs = [{llvm.noundef}], sym_name = "fd_ed25519_point_dbln", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg135: !llvm.ptr, %arg136: !llvm.ptr, %arg137: i32):
  %3041 = "llvm.mlir.constant"() <{value = 1 : i8}> : () -> i8
  %3042 = "llvm.mlir.constant"() <{value = dense<[8796093022207, 8796093022207, 8796093022207, 8796093022207, 1099511627775, 1099511627775, 1099511627775, 1099511627775]> : vector<8xi64>}> : () -> vector<8xi64>
  %3043 = "llvm.mlir.constant"() <{value = dense<1048576> : vector<8xi64>}> : () -> vector<8xi64>
  %3044 = "llvm.mlir.constant"() <{value = dense<[159383552, 159383552, 159383552, 159383552, 1048576, 1048576, 1048576, 1048576]> : vector<8xi64>}> : () -> vector<8xi64>
  %3045 = "llvm.mlir.constant"() <{value = dense<8796093022207> : vector<8xi64>}> : () -> vector<8xi64>
  %3046 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %3047 = "llvm.mlir.constant"() <{value = dense<[43, 43, 43, 43, 40, 40, 40, 40]> : vector<8xi64>}> : () -> vector<8xi64>
  %3048 = "llvm.mlir.constant"() <{value = dense<43> : vector<8xi64>}> : () -> vector<8xi64>
  %3049 = "llvm.mlir.constant"() <{value = dense<-1048576> : vector<8xi64>}> : () -> vector<8xi64>
  %3050 = "llvm.mlir.constant"() <{value = dense<[-159383552, -159383552, -159383552, -159383552, -1048576, -1048576, -1048576, -1048576]> : vector<8xi64>}> : () -> vector<8xi64>
  %3051 = "llvm.mlir.constant"() <{value = 1099511627775 : i64}> : () -> i64
  %3052 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %3053 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %3054 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %3055 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %3056 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %3057 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %3058 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %3059 = "llvm.mlir.poison"() : () -> vector<8xi64>
  %3060 = "llvm.mlir.constant"() <{value = dense<[0, 0, 1, 0, 0, 0, 1, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %3061 = "llvm.mlir.poison"() : () -> i64
  %3062 = "llvm.mlir.constant"() <{value = 8796093022207 : i64}> : () -> i64
  %3063 = "llvm.mlir.constant"() <{value = 8796093022189 : i64}> : () -> i64
  %3064 = "llvm.mlir.undef"() : () -> vector<8xi64>
  %3065 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %3066 = "llvm.insertelement"(%3064, %3061, %3065) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3067 = "llvm.insertelement"(%3066, %3063, %3058) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3068 = "llvm.insertelement"(%3067, %3063, %3057) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3069 = "llvm.insertelement"(%3068, %3061, %3056) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3070 = "llvm.insertelement"(%3069, %3061, %3055) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3071 = "llvm.insertelement"(%3070, %3062, %3054) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3072 = "llvm.insertelement"(%3071, %3062, %3053) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3073 = "llvm.insertelement"(%3072, %3061, %3052) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3074 = "llvm.insertelement"(%3064, %3061, %3065) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3075 = "llvm.insertelement"(%3074, %3062, %3058) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3076 = "llvm.insertelement"(%3075, %3062, %3057) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3077 = "llvm.insertelement"(%3076, %3061, %3056) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3078 = "llvm.insertelement"(%3077, %3061, %3055) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3079 = "llvm.insertelement"(%3078, %3062, %3054) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3080 = "llvm.insertelement"(%3079, %3062, %3053) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3081 = "llvm.insertelement"(%3080, %3061, %3052) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3082 = "llvm.insertelement"(%3064, %3061, %3065) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3083 = "llvm.insertelement"(%3082, %3062, %3058) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3084 = "llvm.insertelement"(%3083, %3062, %3057) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3085 = "llvm.insertelement"(%3084, %3061, %3056) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3086 = "llvm.insertelement"(%3085, %3061, %3055) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3087 = "llvm.insertelement"(%3086, %3051, %3054) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3088 = "llvm.insertelement"(%3087, %3051, %3053) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3089 = "llvm.insertelement"(%3088, %3061, %3052) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3090 = "llvm.insertelement"(%3064, %3063, %3065) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3091 = "llvm.insertelement"(%3090, %3061, %3058) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3092 = "llvm.insertelement"(%3091, %3061, %3057) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3093 = "llvm.insertelement"(%3092, %3061, %3056) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3094 = "llvm.insertelement"(%3093, %3062, %3055) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3095 = "llvm.insertelement"(%3094, %3061, %3054) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3096 = "llvm.insertelement"(%3095, %3061, %3053) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3097 = "llvm.insertelement"(%3096, %3061, %3052) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3098 = "llvm.insertelement"(%3064, %3062, %3065) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3099 = "llvm.insertelement"(%3098, %3061, %3058) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3100 = "llvm.insertelement"(%3099, %3061, %3057) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3101 = "llvm.insertelement"(%3100, %3061, %3056) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3102 = "llvm.insertelement"(%3101, %3062, %3055) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3103 = "llvm.insertelement"(%3102, %3061, %3054) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3104 = "llvm.insertelement"(%3103, %3061, %3053) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3105 = "llvm.insertelement"(%3104, %3061, %3052) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3106 = "llvm.insertelement"(%3064, %3062, %3065) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3107 = "llvm.insertelement"(%3106, %3061, %3058) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3108 = "llvm.insertelement"(%3107, %3061, %3057) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3109 = "llvm.insertelement"(%3108, %3061, %3056) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3110 = "llvm.insertelement"(%3109, %3051, %3055) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3111 = "llvm.insertelement"(%3110, %3061, %3054) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3112 = "llvm.insertelement"(%3111, %3061, %3053) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3113 = "llvm.insertelement"(%3112, %3061, %3052) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3114 = "llvm.insertelement"(%3064, %3061, %3065) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3115 = "llvm.insertelement"(%3114, %3061, %3058) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3116 = "llvm.insertelement"(%3115, %3061, %3057) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3117 = "llvm.insertelement"(%3116, %3061, %3056) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3118 = "llvm.insertelement"(%3117, %3046, %3055) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3119 = "llvm.insertelement"(%3118, %3046, %3054) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3120 = "llvm.insertelement"(%3119, %3046, %3053) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3121 = "llvm.insertelement"(%3120, %3046, %3052) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3122 = "llvm.alloca"(%3058) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %3123 = "llvm.alloca"(%3058) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %3124 = "llvm.alloca"(%3058) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %3125 = "llvm.alloca"(%3058) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %3126 = "llvm.alloca"(%3058) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %3127 = "llvm.alloca"(%3058) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %3128 = "llvm.alloca"(%3058) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %3129 = "llvm.alloca"(%3058) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %3130 = "llvm.alloca"(%3058) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %3131 = "llvm.alloca"(%3058) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %3132 = "llvm.alloca"(%3058) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %3133 = "llvm.alloca"(%3058) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %3134 = "llvm.load"(%arg136) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %3135 = "llvm.shufflevector"(%3134, %3059) <{mask = array<i32: 1, 1, 2, 0, 5, 5, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3136 = "llvm.getelementptr"(%arg136) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %3137 = "llvm.load"(%3136) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %3138 = "llvm.shufflevector"(%3137, %3059) <{mask = array<i32: 1, 1, 2, 0, 5, 5, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3139 = "llvm.getelementptr"(%arg136) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %3140 = "llvm.load"(%3139) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %3141 = "llvm.shufflevector"(%3140, %3059) <{mask = array<i32: 1, 1, 2, 0, 5, 5, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3142 = "llvm.add"(%3135, %3134) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3143 = "llvm.shufflevector"(%3142, %3135) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3144 = "llvm.add"(%3138, %3137) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3145 = "llvm.shufflevector"(%3144, %3138) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3146 = "llvm.add"(%3141, %3140) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3147 = "llvm.shufflevector"(%3146, %3141) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.intr.lifetime.start"(%3122) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3123) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3124) : (!llvm.ptr) -> ()
  "llvm.call"(%3122, %3123, %3124, %3143, %3145, %3147) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_quad_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 6, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
  %3148 = "llvm.load"(%3122) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %3149 = "llvm.load"(%3123) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %3150 = "llvm.load"(%3124) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.intr.lifetime.end"(%3124) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3123) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3122) : (!llvm.ptr) -> ()
  %3151 = "llvm.shl"(%3148, %3060) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3152 = "llvm.shl"(%3149, %3060) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3153 = "llvm.shl"(%3150, %3060) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3154 = "llvm.shufflevector"(%3151, %3059) <{mask = array<i32: 3, 3, 3, 3, 7, 7, 7, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3155 = "llvm.shufflevector"(%3152, %3059) <{mask = array<i32: 3, 3, 3, 3, 7, 7, 7, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3156 = "llvm.shufflevector"(%3153, %3059) <{mask = array<i32: 3, 3, 3, 3, 7, 7, 7, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3157 = "llvm.shufflevector"(%3151, %3059) <{mask = array<i32: 1, 1, 1, 1, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3158 = "llvm.shufflevector"(%3152, %3059) <{mask = array<i32: 1, 1, 1, 1, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3159 = "llvm.shufflevector"(%3153, %3059) <{mask = array<i32: 1, 1, 1, 1, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3160 = "llvm.add"(%3154, %3157) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3161 = "llvm.add"(%3155, %3158) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3162 = "llvm.add"(%3156, %3159) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3163 = "llvm.sub"(%3154, %3157) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3164 = "llvm.add"(%3163, %3073) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3165 = "llvm.shufflevector"(%3160, %3164) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3166 = "llvm.sub"(%3155, %3158) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3167 = "llvm.add"(%3166, %3081) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3168 = "llvm.shufflevector"(%3161, %3167) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3169 = "llvm.sub"(%3156, %3159) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3170 = "llvm.add"(%3169, %3089) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3171 = "llvm.shufflevector"(%3162, %3170) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3172 = "llvm.add"(%3165, %3151) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3173 = "llvm.shufflevector"(%3165, %3172) <{mask = array<i32: 0, 1, 10, 3, 4, 5, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3174 = "llvm.add"(%3168, %3152) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3175 = "llvm.shufflevector"(%3168, %3174) <{mask = array<i32: 0, 1, 10, 3, 4, 5, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3176 = "llvm.add"(%3171, %3153) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3177 = "llvm.shufflevector"(%3171, %3176) <{mask = array<i32: 0, 1, 10, 3, 4, 5, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3178 = "llvm.sub"(%3173, %3151) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3179 = "llvm.add"(%3178, %3097) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3180 = "llvm.shufflevector"(%3179, %3173) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3181 = "llvm.sub"(%3175, %3152) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3182 = "llvm.add"(%3181, %3105) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3183 = "llvm.shufflevector"(%3182, %3175) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3184 = "llvm.sub"(%3177, %3153) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3185 = "llvm.add"(%3184, %3113) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3186 = "llvm.shufflevector"(%3185, %3177) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3187 = "llvm.add"(%3180, %3050) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3188 = "llvm.add"(%3183, %3049) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3189 = "llvm.add"(%3186, %3049) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3190 = "llvm.ashr"(%3187, %3048) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3191 = "llvm.ashr"(%3188, %3048) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3192 = "llvm.ashr"(%3189, %3047) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3193 = "llvm.mul"(%3192, %3121) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3194 = "llvm.and"(%3187, %3045) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3195 = "llvm.shufflevector"(%3193, %3192) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3196 = "llvm.add"(%3194, %3044) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3197 = "llvm.add"(%3196, %3195) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3198 = "llvm.and"(%3188, %3045) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3199 = "llvm.add"(%3190, %3043) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3200 = "llvm.add"(%3199, %3198) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3201 = "llvm.and"(%3189, %3042) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3202 = "llvm.add"(%3191, %3043) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3203 = "llvm.add"(%3202, %3201) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3204 = "llvm.shufflevector"(%3197, %3059) <{mask = array<i32: 0, 1, 1, 0, 4, 5, 5, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3205 = "llvm.shufflevector"(%3200, %3059) <{mask = array<i32: 0, 1, 1, 0, 4, 5, 5, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3206 = "llvm.shufflevector"(%3203, %3059) <{mask = array<i32: 0, 1, 1, 0, 4, 5, 5, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3207 = "llvm.shufflevector"(%3197, %3059) <{mask = array<i32: 2, 3, 2, 3, 6, 7, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3208 = "llvm.shufflevector"(%3200, %3059) <{mask = array<i32: 2, 3, 2, 3, 6, 7, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3209 = "llvm.shufflevector"(%3203, %3059) <{mask = array<i32: 2, 3, 2, 3, 6, 7, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.intr.lifetime.start"(%3125) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3126) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3127) : (!llvm.ptr) -> ()
  "llvm.call"(%3125, %3126, %3127, %3204, %3205, %3206, %3207, %3208, %3209) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_quad_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 9, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
  %3210 = "llvm.load"(%3125) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %3211 = "llvm.load"(%3126) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %3212 = "llvm.load"(%3127) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.intr.lifetime.end"(%3127) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3126) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3125) : (!llvm.ptr) -> ()
  %3213 = "llvm.lshr"(%3210, %3048) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3214 = "llvm.lshr"(%3211, %3048) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3215 = "llvm.lshr"(%3212, %3047) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3216 = "llvm.mul"(%3215, %3121) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3217 = "llvm.and"(%3210, %3045) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3218 = "llvm.shufflevector"(%3216, %3215) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3219 = "llvm.add"(%3218, %3217) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%3219, %arg135) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3220 = "llvm.and"(%3211, %3045) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3221 = "llvm.add"(%3220, %3213) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3222 = "llvm.getelementptr"(%arg135) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3221, %3222) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3223 = "llvm.and"(%3212, %3042) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3224 = "llvm.add"(%3223, %3214) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3225 = "llvm.getelementptr"(%arg135) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3224, %3225) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3226 = "llvm.icmp"(%arg137, %3058) <{predicate = 4 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%3226, %3224, %3221, %3219, %3041)[^bb3, ^bb2] <{operandSegmentSizes = array<i32: 1, 4, 0>}> : (i1, vector<8xi64>, vector<8xi64>, vector<8xi64>, i8) -> ()
^bb1:  // pred: ^bb3
  "llvm.store"(%3311, %arg135) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%3313, %3222) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%3315, %3225) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.br"()[^bb2] : () -> ()
^bb2:  // 2 preds: ^bb0, ^bb1
  "llvm.return"(%arg135) : (!llvm.ptr) -> ()
^bb3(%3227: vector<8xi64>, %3228: vector<8xi64>, %3229: vector<8xi64>, %3230: i8):  // 2 preds: ^bb0, ^bb3
  %3231 = "llvm.shufflevector"(%3229, %3059) <{mask = array<i32: 1, 1, 2, 0, 5, 5, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3232 = "llvm.shufflevector"(%3228, %3059) <{mask = array<i32: 1, 1, 2, 0, 5, 5, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3233 = "llvm.shufflevector"(%3227, %3059) <{mask = array<i32: 1, 1, 2, 0, 5, 5, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3234 = "llvm.add"(%3231, %3229) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3235 = "llvm.shufflevector"(%3234, %3231) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3236 = "llvm.add"(%3232, %3228) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3237 = "llvm.shufflevector"(%3236, %3232) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3238 = "llvm.add"(%3233, %3227) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3239 = "llvm.shufflevector"(%3238, %3233) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.intr.lifetime.start"(%3128) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3129) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3130) : (!llvm.ptr) -> ()
  "llvm.call"(%3128, %3129, %3130, %3235, %3237, %3239) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_quad_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 6, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
  %3240 = "llvm.load"(%3128) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %3241 = "llvm.load"(%3129) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %3242 = "llvm.load"(%3130) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.intr.lifetime.end"(%3130) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3129) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3128) : (!llvm.ptr) -> ()
  %3243 = "llvm.shl"(%3240, %3060) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3244 = "llvm.shl"(%3241, %3060) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3245 = "llvm.shl"(%3242, %3060) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3246 = "llvm.shufflevector"(%3243, %3059) <{mask = array<i32: 3, 3, 3, 3, 7, 7, 7, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3247 = "llvm.shufflevector"(%3244, %3059) <{mask = array<i32: 3, 3, 3, 3, 7, 7, 7, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3248 = "llvm.shufflevector"(%3245, %3059) <{mask = array<i32: 3, 3, 3, 3, 7, 7, 7, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3249 = "llvm.shufflevector"(%3243, %3059) <{mask = array<i32: 1, 1, 1, 1, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3250 = "llvm.shufflevector"(%3244, %3059) <{mask = array<i32: 1, 1, 1, 1, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3251 = "llvm.shufflevector"(%3245, %3059) <{mask = array<i32: 1, 1, 1, 1, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3252 = "llvm.add"(%3246, %3249) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3253 = "llvm.add"(%3247, %3250) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3254 = "llvm.add"(%3248, %3251) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3255 = "llvm.sub"(%3246, %3249) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3256 = "llvm.add"(%3255, %3073) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3257 = "llvm.shufflevector"(%3252, %3256) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3258 = "llvm.sub"(%3247, %3250) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3259 = "llvm.add"(%3258, %3081) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3260 = "llvm.shufflevector"(%3253, %3259) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3261 = "llvm.sub"(%3248, %3251) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3262 = "llvm.add"(%3261, %3089) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3263 = "llvm.shufflevector"(%3254, %3262) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3264 = "llvm.add"(%3257, %3243) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3265 = "llvm.shufflevector"(%3257, %3264) <{mask = array<i32: 0, 1, 10, 3, 4, 5, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3266 = "llvm.add"(%3260, %3244) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3267 = "llvm.shufflevector"(%3260, %3266) <{mask = array<i32: 0, 1, 10, 3, 4, 5, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3268 = "llvm.add"(%3263, %3245) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3269 = "llvm.shufflevector"(%3263, %3268) <{mask = array<i32: 0, 1, 10, 3, 4, 5, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3270 = "llvm.sub"(%3265, %3243) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3271 = "llvm.add"(%3270, %3097) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3272 = "llvm.shufflevector"(%3271, %3265) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3273 = "llvm.sub"(%3267, %3244) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3274 = "llvm.add"(%3273, %3105) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3275 = "llvm.shufflevector"(%3274, %3267) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3276 = "llvm.sub"(%3269, %3245) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3277 = "llvm.add"(%3276, %3113) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3278 = "llvm.shufflevector"(%3277, %3269) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3279 = "llvm.add"(%3272, %3050) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3280 = "llvm.add"(%3275, %3049) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3281 = "llvm.add"(%3278, %3049) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3282 = "llvm.ashr"(%3279, %3048) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3283 = "llvm.ashr"(%3280, %3048) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3284 = "llvm.ashr"(%3281, %3047) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3285 = "llvm.mul"(%3284, %3121) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3286 = "llvm.and"(%3279, %3045) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3287 = "llvm.shufflevector"(%3285, %3284) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3288 = "llvm.add"(%3286, %3044) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3289 = "llvm.add"(%3288, %3287) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3290 = "llvm.and"(%3280, %3045) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3291 = "llvm.add"(%3282, %3043) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3292 = "llvm.add"(%3291, %3290) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3293 = "llvm.and"(%3281, %3042) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3294 = "llvm.add"(%3283, %3043) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3295 = "llvm.add"(%3294, %3293) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3296 = "llvm.shufflevector"(%3289, %3059) <{mask = array<i32: 0, 1, 1, 0, 4, 5, 5, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3297 = "llvm.shufflevector"(%3292, %3059) <{mask = array<i32: 0, 1, 1, 0, 4, 5, 5, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3298 = "llvm.shufflevector"(%3295, %3059) <{mask = array<i32: 0, 1, 1, 0, 4, 5, 5, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3299 = "llvm.shufflevector"(%3289, %3059) <{mask = array<i32: 2, 3, 2, 3, 6, 7, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3300 = "llvm.shufflevector"(%3292, %3059) <{mask = array<i32: 2, 3, 2, 3, 6, 7, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3301 = "llvm.shufflevector"(%3295, %3059) <{mask = array<i32: 2, 3, 2, 3, 6, 7, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.intr.lifetime.start"(%3131) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3132) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3133) : (!llvm.ptr) -> ()
  "llvm.call"(%3131, %3132, %3133, %3296, %3297, %3298, %3299, %3300, %3301) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_quad_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 9, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
  %3302 = "llvm.load"(%3131) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %3303 = "llvm.load"(%3132) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %3304 = "llvm.load"(%3133) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.intr.lifetime.end"(%3133) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3132) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3131) : (!llvm.ptr) -> ()
  %3305 = "llvm.lshr"(%3302, %3048) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3306 = "llvm.lshr"(%3303, %3048) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3307 = "llvm.lshr"(%3304, %3047) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3308 = "llvm.mul"(%3307, %3121) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3309 = "llvm.and"(%3302, %3045) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3310 = "llvm.shufflevector"(%3308, %3307) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3311 = "llvm.add"(%3310, %3309) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3312 = "llvm.and"(%3303, %3045) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3313 = "llvm.add"(%3312, %3305) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3314 = "llvm.and"(%3304, %3042) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3315 = "llvm.add"(%3314, %3306) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3316 = "llvm.add"(%3230, %3041) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  %3317 = "llvm.zext"(%3316) : (i8) -> i32
  %3318 = "llvm.icmp"(%arg137, %3317) <{predicate = 8 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%3318, %3315, %3313, %3311, %3316)[^bb3, ^bb1] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 4, 0>}> : (i1, vector<8xi64>, vector<8xi64>, vector<8xi64>, i8) -> ()
}) : () -> ()
  with @fd_r43x6_quad_mul_fast := fd_r43x6_quad_mul_fast,
    @fd_r43x6_quad_sqr_fast := fd_r43x6_quad_sqr_fast

end

end MLIR.Firedancer.Avx512
