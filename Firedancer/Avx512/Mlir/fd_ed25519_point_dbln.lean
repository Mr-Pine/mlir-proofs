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
^bb0(%arg137: !llvm.ptr, %arg138: !llvm.ptr, %arg139: i32):
  %3051 = "llvm.mlir.constant"() <{value = 1 : i8}> : () -> i8
  %3052 = "llvm.mlir.constant"() <{value = dense<[8796093022207, 8796093022207, 8796093022207, 8796093022207, 1099511627775, 1099511627775, 1099511627775, 1099511627775]> : vector<8xi64>}> : () -> vector<8xi64>
  %3053 = "llvm.mlir.constant"() <{value = dense<1048576> : vector<8xi64>}> : () -> vector<8xi64>
  %3054 = "llvm.mlir.constant"() <{value = dense<[159383552, 159383552, 159383552, 159383552, 1048576, 1048576, 1048576, 1048576]> : vector<8xi64>}> : () -> vector<8xi64>
  %3055 = "llvm.mlir.constant"() <{value = dense<8796093022207> : vector<8xi64>}> : () -> vector<8xi64>
  %3056 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %3057 = "llvm.mlir.constant"() <{value = dense<[43, 43, 43, 43, 40, 40, 40, 40]> : vector<8xi64>}> : () -> vector<8xi64>
  %3058 = "llvm.mlir.constant"() <{value = dense<43> : vector<8xi64>}> : () -> vector<8xi64>
  %3059 = "llvm.mlir.constant"() <{value = dense<-1048576> : vector<8xi64>}> : () -> vector<8xi64>
  %3060 = "llvm.mlir.constant"() <{value = dense<[-159383552, -159383552, -159383552, -159383552, -1048576, -1048576, -1048576, -1048576]> : vector<8xi64>}> : () -> vector<8xi64>
  %3061 = "llvm.mlir.constant"() <{value = 1099511627775 : i64}> : () -> i64
  %3062 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %3063 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %3064 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %3065 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %3066 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %3067 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %3068 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %3069 = "llvm.mlir.poison"() : () -> vector<8xi64>
  %3070 = "llvm.mlir.constant"() <{value = dense<[0, 0, 1, 0, 0, 0, 1, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %3071 = "llvm.mlir.poison"() : () -> i64
  %3072 = "llvm.mlir.constant"() <{value = 8796093022207 : i64}> : () -> i64
  %3073 = "llvm.mlir.constant"() <{value = 8796093022189 : i64}> : () -> i64
  %3074 = "llvm.mlir.undef"() : () -> vector<8xi64>
  %3075 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %3076 = "llvm.insertelement"(%3074, %3071, %3075) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3077 = "llvm.insertelement"(%3076, %3073, %3068) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3078 = "llvm.insertelement"(%3077, %3073, %3067) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3079 = "llvm.insertelement"(%3078, %3071, %3066) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3080 = "llvm.insertelement"(%3079, %3071, %3065) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3081 = "llvm.insertelement"(%3080, %3072, %3064) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3082 = "llvm.insertelement"(%3081, %3072, %3063) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3083 = "llvm.insertelement"(%3082, %3071, %3062) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3084 = "llvm.insertelement"(%3074, %3071, %3075) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3085 = "llvm.insertelement"(%3084, %3072, %3068) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3086 = "llvm.insertelement"(%3085, %3072, %3067) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3087 = "llvm.insertelement"(%3086, %3071, %3066) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3088 = "llvm.insertelement"(%3087, %3071, %3065) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3089 = "llvm.insertelement"(%3088, %3072, %3064) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3090 = "llvm.insertelement"(%3089, %3072, %3063) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3091 = "llvm.insertelement"(%3090, %3071, %3062) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3092 = "llvm.insertelement"(%3074, %3071, %3075) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3093 = "llvm.insertelement"(%3092, %3072, %3068) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3094 = "llvm.insertelement"(%3093, %3072, %3067) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3095 = "llvm.insertelement"(%3094, %3071, %3066) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3096 = "llvm.insertelement"(%3095, %3071, %3065) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3097 = "llvm.insertelement"(%3096, %3061, %3064) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3098 = "llvm.insertelement"(%3097, %3061, %3063) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3099 = "llvm.insertelement"(%3098, %3071, %3062) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3100 = "llvm.insertelement"(%3074, %3073, %3075) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3101 = "llvm.insertelement"(%3100, %3071, %3068) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3102 = "llvm.insertelement"(%3101, %3071, %3067) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3103 = "llvm.insertelement"(%3102, %3071, %3066) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3104 = "llvm.insertelement"(%3103, %3072, %3065) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3105 = "llvm.insertelement"(%3104, %3071, %3064) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3106 = "llvm.insertelement"(%3105, %3071, %3063) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3107 = "llvm.insertelement"(%3106, %3071, %3062) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3108 = "llvm.insertelement"(%3074, %3072, %3075) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3109 = "llvm.insertelement"(%3108, %3071, %3068) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3110 = "llvm.insertelement"(%3109, %3071, %3067) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3111 = "llvm.insertelement"(%3110, %3071, %3066) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3112 = "llvm.insertelement"(%3111, %3072, %3065) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3113 = "llvm.insertelement"(%3112, %3071, %3064) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3114 = "llvm.insertelement"(%3113, %3071, %3063) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3115 = "llvm.insertelement"(%3114, %3071, %3062) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3116 = "llvm.insertelement"(%3074, %3072, %3075) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3117 = "llvm.insertelement"(%3116, %3071, %3068) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3118 = "llvm.insertelement"(%3117, %3071, %3067) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3119 = "llvm.insertelement"(%3118, %3071, %3066) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3120 = "llvm.insertelement"(%3119, %3061, %3065) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3121 = "llvm.insertelement"(%3120, %3071, %3064) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3122 = "llvm.insertelement"(%3121, %3071, %3063) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3123 = "llvm.insertelement"(%3122, %3071, %3062) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3124 = "llvm.insertelement"(%3074, %3071, %3075) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3125 = "llvm.insertelement"(%3124, %3071, %3068) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3126 = "llvm.insertelement"(%3125, %3071, %3067) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3127 = "llvm.insertelement"(%3126, %3071, %3066) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3128 = "llvm.insertelement"(%3127, %3056, %3065) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3129 = "llvm.insertelement"(%3128, %3056, %3064) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3130 = "llvm.insertelement"(%3129, %3056, %3063) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3131 = "llvm.insertelement"(%3130, %3056, %3062) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %3132 = "llvm.alloca"(%3068) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %3133 = "llvm.alloca"(%3068) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %3134 = "llvm.alloca"(%3068) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %3135 = "llvm.alloca"(%3068) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %3136 = "llvm.alloca"(%3068) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %3137 = "llvm.alloca"(%3068) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %3138 = "llvm.alloca"(%3068) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %3139 = "llvm.alloca"(%3068) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %3140 = "llvm.alloca"(%3068) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %3141 = "llvm.alloca"(%3068) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %3142 = "llvm.alloca"(%3068) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %3143 = "llvm.alloca"(%3068) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %3144 = "llvm.load"(%arg138) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %3145 = "llvm.shufflevector"(%3144, %3069) <{mask = array<i32: 1, 1, 2, 0, 5, 5, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3146 = "llvm.getelementptr"(%arg138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %3147 = "llvm.load"(%3146) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %3148 = "llvm.shufflevector"(%3147, %3069) <{mask = array<i32: 1, 1, 2, 0, 5, 5, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3149 = "llvm.getelementptr"(%arg138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %3150 = "llvm.load"(%3149) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %3151 = "llvm.shufflevector"(%3150, %3069) <{mask = array<i32: 1, 1, 2, 0, 5, 5, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3152 = "llvm.add"(%3145, %3144) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3153 = "llvm.shufflevector"(%3152, %3145) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3154 = "llvm.add"(%3148, %3147) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3155 = "llvm.shufflevector"(%3154, %3148) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3156 = "llvm.add"(%3151, %3150) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3157 = "llvm.shufflevector"(%3156, %3151) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.intr.lifetime.start"(%3132) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3133) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3134) : (!llvm.ptr) -> ()
  "llvm.call"(%3132, %3133, %3134, %3153, %3155, %3157) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_quad_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 6, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
  %3158 = "llvm.load"(%3132) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %3159 = "llvm.load"(%3133) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %3160 = "llvm.load"(%3134) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.intr.lifetime.end"(%3134) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3133) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3132) : (!llvm.ptr) -> ()
  %3161 = "llvm.shl"(%3158, %3070) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3162 = "llvm.shl"(%3159, %3070) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3163 = "llvm.shl"(%3160, %3070) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3164 = "llvm.shufflevector"(%3161, %3069) <{mask = array<i32: 3, 3, 3, 3, 7, 7, 7, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3165 = "llvm.shufflevector"(%3162, %3069) <{mask = array<i32: 3, 3, 3, 3, 7, 7, 7, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3166 = "llvm.shufflevector"(%3163, %3069) <{mask = array<i32: 3, 3, 3, 3, 7, 7, 7, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3167 = "llvm.shufflevector"(%3161, %3069) <{mask = array<i32: 1, 1, 1, 1, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3168 = "llvm.shufflevector"(%3162, %3069) <{mask = array<i32: 1, 1, 1, 1, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3169 = "llvm.shufflevector"(%3163, %3069) <{mask = array<i32: 1, 1, 1, 1, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3170 = "llvm.add"(%3164, %3167) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3171 = "llvm.add"(%3165, %3168) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3172 = "llvm.add"(%3166, %3169) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3173 = "llvm.sub"(%3164, %3167) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3174 = "llvm.add"(%3173, %3083) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3175 = "llvm.shufflevector"(%3170, %3174) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3176 = "llvm.sub"(%3165, %3168) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3177 = "llvm.add"(%3176, %3091) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3178 = "llvm.shufflevector"(%3171, %3177) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3179 = "llvm.sub"(%3166, %3169) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3180 = "llvm.add"(%3179, %3099) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3181 = "llvm.shufflevector"(%3172, %3180) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3182 = "llvm.add"(%3175, %3161) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3183 = "llvm.shufflevector"(%3175, %3182) <{mask = array<i32: 0, 1, 10, 3, 4, 5, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3184 = "llvm.add"(%3178, %3162) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3185 = "llvm.shufflevector"(%3178, %3184) <{mask = array<i32: 0, 1, 10, 3, 4, 5, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3186 = "llvm.add"(%3181, %3163) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3187 = "llvm.shufflevector"(%3181, %3186) <{mask = array<i32: 0, 1, 10, 3, 4, 5, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3188 = "llvm.sub"(%3183, %3161) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3189 = "llvm.add"(%3188, %3107) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3190 = "llvm.shufflevector"(%3189, %3183) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3191 = "llvm.sub"(%3185, %3162) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3192 = "llvm.add"(%3191, %3115) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3193 = "llvm.shufflevector"(%3192, %3185) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3194 = "llvm.sub"(%3187, %3163) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3195 = "llvm.add"(%3194, %3123) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3196 = "llvm.shufflevector"(%3195, %3187) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3197 = "llvm.add"(%3190, %3060) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3198 = "llvm.add"(%3193, %3059) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3199 = "llvm.add"(%3196, %3059) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3200 = "llvm.ashr"(%3197, %3058) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3201 = "llvm.ashr"(%3198, %3058) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3202 = "llvm.ashr"(%3199, %3057) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3203 = "llvm.mul"(%3202, %3131) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3204 = "llvm.and"(%3197, %3055) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3205 = "llvm.shufflevector"(%3203, %3202) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3206 = "llvm.add"(%3204, %3054) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3207 = "llvm.add"(%3206, %3205) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3208 = "llvm.and"(%3198, %3055) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3209 = "llvm.add"(%3200, %3053) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3210 = "llvm.add"(%3209, %3208) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3211 = "llvm.and"(%3199, %3052) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3212 = "llvm.add"(%3201, %3053) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3213 = "llvm.add"(%3212, %3211) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3214 = "llvm.shufflevector"(%3207, %3069) <{mask = array<i32: 0, 1, 1, 0, 4, 5, 5, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3215 = "llvm.shufflevector"(%3210, %3069) <{mask = array<i32: 0, 1, 1, 0, 4, 5, 5, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3216 = "llvm.shufflevector"(%3213, %3069) <{mask = array<i32: 0, 1, 1, 0, 4, 5, 5, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3217 = "llvm.shufflevector"(%3207, %3069) <{mask = array<i32: 2, 3, 2, 3, 6, 7, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3218 = "llvm.shufflevector"(%3210, %3069) <{mask = array<i32: 2, 3, 2, 3, 6, 7, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3219 = "llvm.shufflevector"(%3213, %3069) <{mask = array<i32: 2, 3, 2, 3, 6, 7, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.intr.lifetime.start"(%3135) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3136) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3137) : (!llvm.ptr) -> ()
  "llvm.call"(%3135, %3136, %3137, %3214, %3215, %3216, %3217, %3218, %3219) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_quad_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 9, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
  %3220 = "llvm.load"(%3135) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %3221 = "llvm.load"(%3136) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %3222 = "llvm.load"(%3137) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.intr.lifetime.end"(%3137) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3136) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3135) : (!llvm.ptr) -> ()
  %3223 = "llvm.lshr"(%3220, %3058) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3224 = "llvm.lshr"(%3221, %3058) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3225 = "llvm.lshr"(%3222, %3057) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3226 = "llvm.mul"(%3225, %3131) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3227 = "llvm.and"(%3220, %3055) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3228 = "llvm.shufflevector"(%3226, %3225) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3229 = "llvm.add"(%3228, %3227) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%3229, %arg137) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3230 = "llvm.and"(%3221, %3055) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3231 = "llvm.add"(%3230, %3223) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3232 = "llvm.getelementptr"(%arg137) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3231, %3232) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3233 = "llvm.and"(%3222, %3052) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3234 = "llvm.add"(%3233, %3224) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3235 = "llvm.getelementptr"(%arg137) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3234, %3235) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3236 = "llvm.icmp"(%arg139, %3068) <{predicate = 4 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%3236, %3234, %3231, %3229, %3051)[^bb3, ^bb2] <{operandSegmentSizes = array<i32: 1, 4, 0>}> : (i1, vector<8xi64>, vector<8xi64>, vector<8xi64>, i8) -> ()
^bb1:  // pred: ^bb3
  "llvm.store"(%3321, %arg137) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%3323, %3232) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%3325, %3235) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.br"()[^bb2] : () -> ()
^bb2:  // 2 preds: ^bb0, ^bb1
  "llvm.return"(%arg137) : (!llvm.ptr) -> ()
^bb3(%3237: vector<8xi64>, %3238: vector<8xi64>, %3239: vector<8xi64>, %3240: i8):  // 2 preds: ^bb0, ^bb3
  %3241 = "llvm.shufflevector"(%3239, %3069) <{mask = array<i32: 1, 1, 2, 0, 5, 5, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3242 = "llvm.shufflevector"(%3238, %3069) <{mask = array<i32: 1, 1, 2, 0, 5, 5, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3243 = "llvm.shufflevector"(%3237, %3069) <{mask = array<i32: 1, 1, 2, 0, 5, 5, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3244 = "llvm.add"(%3241, %3239) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3245 = "llvm.shufflevector"(%3244, %3241) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3246 = "llvm.add"(%3242, %3238) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3247 = "llvm.shufflevector"(%3246, %3242) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3248 = "llvm.add"(%3243, %3237) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3249 = "llvm.shufflevector"(%3248, %3243) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.intr.lifetime.start"(%3138) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3139) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3140) : (!llvm.ptr) -> ()
  "llvm.call"(%3138, %3139, %3140, %3245, %3247, %3249) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_quad_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 6, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
  %3250 = "llvm.load"(%3138) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %3251 = "llvm.load"(%3139) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %3252 = "llvm.load"(%3140) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.intr.lifetime.end"(%3140) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3139) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3138) : (!llvm.ptr) -> ()
  %3253 = "llvm.shl"(%3250, %3070) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3254 = "llvm.shl"(%3251, %3070) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3255 = "llvm.shl"(%3252, %3070) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3256 = "llvm.shufflevector"(%3253, %3069) <{mask = array<i32: 3, 3, 3, 3, 7, 7, 7, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3257 = "llvm.shufflevector"(%3254, %3069) <{mask = array<i32: 3, 3, 3, 3, 7, 7, 7, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3258 = "llvm.shufflevector"(%3255, %3069) <{mask = array<i32: 3, 3, 3, 3, 7, 7, 7, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3259 = "llvm.shufflevector"(%3253, %3069) <{mask = array<i32: 1, 1, 1, 1, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3260 = "llvm.shufflevector"(%3254, %3069) <{mask = array<i32: 1, 1, 1, 1, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3261 = "llvm.shufflevector"(%3255, %3069) <{mask = array<i32: 1, 1, 1, 1, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3262 = "llvm.add"(%3256, %3259) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3263 = "llvm.add"(%3257, %3260) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3264 = "llvm.add"(%3258, %3261) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3265 = "llvm.sub"(%3256, %3259) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3266 = "llvm.add"(%3265, %3083) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3267 = "llvm.shufflevector"(%3262, %3266) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3268 = "llvm.sub"(%3257, %3260) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3269 = "llvm.add"(%3268, %3091) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3270 = "llvm.shufflevector"(%3263, %3269) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3271 = "llvm.sub"(%3258, %3261) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3272 = "llvm.add"(%3271, %3099) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3273 = "llvm.shufflevector"(%3264, %3272) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3274 = "llvm.add"(%3267, %3253) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3275 = "llvm.shufflevector"(%3267, %3274) <{mask = array<i32: 0, 1, 10, 3, 4, 5, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3276 = "llvm.add"(%3270, %3254) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3277 = "llvm.shufflevector"(%3270, %3276) <{mask = array<i32: 0, 1, 10, 3, 4, 5, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3278 = "llvm.add"(%3273, %3255) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3279 = "llvm.shufflevector"(%3273, %3278) <{mask = array<i32: 0, 1, 10, 3, 4, 5, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3280 = "llvm.sub"(%3275, %3253) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3281 = "llvm.add"(%3280, %3107) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3282 = "llvm.shufflevector"(%3281, %3275) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3283 = "llvm.sub"(%3277, %3254) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3284 = "llvm.add"(%3283, %3115) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3285 = "llvm.shufflevector"(%3284, %3277) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3286 = "llvm.sub"(%3279, %3255) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3287 = "llvm.add"(%3286, %3123) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3288 = "llvm.shufflevector"(%3287, %3279) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3289 = "llvm.add"(%3282, %3060) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3290 = "llvm.add"(%3285, %3059) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3291 = "llvm.add"(%3288, %3059) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3292 = "llvm.ashr"(%3289, %3058) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3293 = "llvm.ashr"(%3290, %3058) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3294 = "llvm.ashr"(%3291, %3057) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3295 = "llvm.mul"(%3294, %3131) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3296 = "llvm.and"(%3289, %3055) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3297 = "llvm.shufflevector"(%3295, %3294) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3298 = "llvm.add"(%3296, %3054) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3299 = "llvm.add"(%3298, %3297) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3300 = "llvm.and"(%3290, %3055) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3301 = "llvm.add"(%3292, %3053) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3302 = "llvm.add"(%3301, %3300) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3303 = "llvm.and"(%3291, %3052) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3304 = "llvm.add"(%3293, %3053) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3305 = "llvm.add"(%3304, %3303) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3306 = "llvm.shufflevector"(%3299, %3069) <{mask = array<i32: 0, 1, 1, 0, 4, 5, 5, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3307 = "llvm.shufflevector"(%3302, %3069) <{mask = array<i32: 0, 1, 1, 0, 4, 5, 5, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3308 = "llvm.shufflevector"(%3305, %3069) <{mask = array<i32: 0, 1, 1, 0, 4, 5, 5, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3309 = "llvm.shufflevector"(%3299, %3069) <{mask = array<i32: 2, 3, 2, 3, 6, 7, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3310 = "llvm.shufflevector"(%3302, %3069) <{mask = array<i32: 2, 3, 2, 3, 6, 7, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3311 = "llvm.shufflevector"(%3305, %3069) <{mask = array<i32: 2, 3, 2, 3, 6, 7, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.intr.lifetime.start"(%3141) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3142) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3143) : (!llvm.ptr) -> ()
  "llvm.call"(%3141, %3142, %3143, %3306, %3307, %3308, %3309, %3310, %3311) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_quad_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 9, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
  %3312 = "llvm.load"(%3141) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %3313 = "llvm.load"(%3142) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %3314 = "llvm.load"(%3143) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.intr.lifetime.end"(%3143) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3142) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3141) : (!llvm.ptr) -> ()
  %3315 = "llvm.lshr"(%3312, %3058) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3316 = "llvm.lshr"(%3313, %3058) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3317 = "llvm.lshr"(%3314, %3057) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3318 = "llvm.mul"(%3317, %3131) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3319 = "llvm.and"(%3312, %3055) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3320 = "llvm.shufflevector"(%3318, %3317) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3321 = "llvm.add"(%3320, %3319) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3322 = "llvm.and"(%3313, %3055) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3323 = "llvm.add"(%3322, %3315) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3324 = "llvm.and"(%3314, %3052) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3325 = "llvm.add"(%3324, %3316) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3326 = "llvm.add"(%3240, %3051) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  %3327 = "llvm.zext"(%3326) : (i8) -> i32
  %3328 = "llvm.icmp"(%arg139, %3327) <{predicate = 8 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%3328, %3325, %3323, %3321, %3326)[^bb3, ^bb1] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 4, 0>}> : (i1, vector<8xi64>, vector<8xi64>, vector<8xi64>, i8) -> ()
}) : () -> ()
  with @fd_r43x6_quad_mul_fast := fd_r43x6_quad_mul_fast,
    @fd_r43x6_quad_sqr_fast := fd_r43x6_quad_sqr_fast

end

end MLIR.Firedancer.Avx512
