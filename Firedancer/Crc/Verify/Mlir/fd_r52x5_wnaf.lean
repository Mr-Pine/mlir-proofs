module

-- crc/out/mlirproofs/regions/verify/fd_r52x5_wnaf.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Firedancer.Crc.Verify

@[expose] public section

mlir_def fd_r52x5_wnaf :=
#loop_annotation = #llvm.loop_annotation<mustProgress = true>
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.noundef, llvm.readonly}, {llvm.noundef, llvm.range = #llvm.constant_range<i32, 3, 9>}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<i32 (ptr, ptr, i32)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], sym_name = "fd_r52x5_wnaf", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg211: !llvm.ptr, %arg212: !llvm.ptr, %arg213: i32):
  %3132 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %3133 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %3134 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %3135 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %3136 = "llvm.mlir.poison"() : () -> vector<2xi64>
  %3137 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %3138 = "llvm.mlir.constant"() <{value = 0 : i16}> : () -> i16
  %3139 = "llvm.mlir.constant"() <{value = 63 : i64}> : () -> i64
  %3140 = "llvm.mlir.constant"() <{value = dense<63> : vector<2xi64>}> : () -> vector<2xi64>
  %3141 = "llvm.alloca"(%3132) <{alignment = 16 : i64, elem_type = !llvm.array<3 x i64>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%3141) : (!llvm.ptr) -> ()
  %3142 = "llvm.load"(%arg212) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3143 = "llvm.getelementptr"(%arg212) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %3144 = "llvm.getelementptr"(%arg212) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %3145 = "llvm.load"(%3143) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  %3146 = "llvm.extractelement"(%3145, %3133) : (vector<2xi64>, i64) -> i64
  "llvm.store"(%3146, %3141) <{alignment = 16 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %3147 = "llvm.load"(%3144) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  %3148 = "llvm.getelementptr"(%3141) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3147, %3148) <{alignment = 8 : i64, ordering = 0 : i64}> : (vector<2xi64>, !llvm.ptr) -> ()
  %3149 = "llvm.add"(%arg213, %3132) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %3150 = "llvm.zext"(%3149) <{nonNeg}> : (i32) -> i64
  %3151 = "llvm.shl"(%3134, %3150) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %3152 = "llvm.add"(%3151, %3135) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %3153 = "llvm.zext"(%arg213) <{nonNeg}> : (i32) -> i64
  %3154 = "llvm.shufflevector"(%3147, %3136) <{mask = array<i32: 1, -1>}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %3155 = "llvm.or"(%3147, %3154) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %3156 = "llvm.or"(%3155, %3145) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %3157 = "llvm.extractelement"(%3156, %3133) : (vector<2xi64>, i64) -> i64
  %3158 = "llvm.or"(%3157, %3142) : (i64, i64) -> i64
  %3159 = "llvm.icmp"(%3158, %3133) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%3159, %3137)[^bb14, ^bb1] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i32) -> ()
^bb1:  // pred: ^bb0
  %3160 = "llvm.getelementptr"(%3141) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %3161 = "llvm.getelementptr"(%3141) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %3162 = "llvm.getelementptr"(%3141) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %3163 = "llvm.getelementptr"(%3141) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %3164 = "llvm.getelementptr"(%3141) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %3165 = "llvm.getelementptr"(%3141) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %3166 = "llvm.getelementptr"(%3141) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %3167 = "llvm.getelementptr"(%3141) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %3168 = "llvm.getelementptr"(%3141) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %3169 = "llvm.getelementptr"(%3141) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.br"(%3137, %3142, %3147, %3145)[^bb2] : (i32, i64, vector<2xi64>, vector<2xi64>) -> ()
^bb2(%3170: i32, %3171: i64, %3172: vector<2xi64>, %3173: vector<2xi64>):  // 2 preds: ^bb1, ^bb13
  %3174 = "llvm.and"(%3171, %3134) : (i64, i64) -> i64
  %3175 = "llvm.icmp"(%3174, %3133) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%3175, %3171, %3138, %3172, %3173)[^bb13, ^bb3] <{operandSegmentSizes = array<i32: 1, 4, 0>}> : (i1, i64, i16, vector<2xi64>, vector<2xi64>) -> ()
^bb3:  // pred: ^bb2
  %3176 = "llvm.and"(%3171, %3152) : (i64, i64) -> i64
  %3177 = "llvm.lshr"(%3176, %3153) : (i64, i64) -> i64
  %3178 = "llvm.icmp"(%3177, %3133) <{predicate = 0 : i64}> : (i64, i64) -> i1
  %3179 = "llvm.select"(%3178, %3133, %3151) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %3180 = "llvm.sub"(%3176, %3179) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %3181 = "llvm.icmp"(%3180, %3133) <{predicate = 4 : i64}> : (i64, i64) -> i1
  %3182 = "llvm.icmp"(%3180, %3171) <{predicate = 8 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%3181)[^bb4, ^bb8] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb4:  // pred: ^bb3
  "llvm.cond_br"(%3182)[^bb5, ^bb12] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb5:  // pred: ^bb4
  %3183 = "llvm.load"(%3141) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3184 = "llvm.add"(%3183, %3135) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %3185 = "llvm.icmp"(%3183, %3133) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.store"(%3184, %3141) <{alignment = 16 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.cond_br"(%3185)[^bb6, ^bb12] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb6:  // pred: ^bb5
  %3186 = "llvm.load"(%3164) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3187 = "llvm.add"(%3186, %3135) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %3188 = "llvm.icmp"(%3186, %3133) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.store"(%3187, %3165) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.cond_br"(%3188)[^bb7, ^bb12] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb7:  // pred: ^bb6
  %3189 = "llvm.load"(%3166) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3190 = "llvm.add"(%3189, %3135) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%3190, %3167) <{alignment = 16 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.br"()[^bb12] : () -> ()
^bb8:  // pred: ^bb3
  "llvm.cond_br"(%3182)[^bb12, ^bb9] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb9:  // pred: ^bb8
  %3191 = "llvm.load"(%3141) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3192 = "llvm.add"(%3191, %3134) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %3193 = "llvm.icmp"(%3191, %3135) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.store"(%3192, %3141) <{alignment = 16 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.cond_br"(%3193)[^bb10, ^bb12] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb10:  // pred: ^bb9
  %3194 = "llvm.load"(%3160) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3195 = "llvm.add"(%3194, %3134) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %3196 = "llvm.icmp"(%3194, %3135) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.store"(%3195, %3161) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.cond_br"(%3196)[^bb11, ^bb12] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb11:  // pred: ^bb10
  %3197 = "llvm.load"(%3162) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3198 = "llvm.add"(%3197, %3134) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%3198, %3163) <{alignment = 16 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.br"()[^bb12] : () -> ()
^bb12:  // 8 preds: ^bb4, ^bb5, ^bb6, ^bb7, ^bb8, ^bb9, ^bb10, ^bb11
  %3199 = "llvm.sub"(%3171, %3180) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %3200 = "llvm.trunc"(%3180) <{overflowFlags = 1 : i32}> : (i64) -> i16
  %3201 = "llvm.load"(%3141) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  %3202 = "llvm.load"(%3168) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  "llvm.br"(%3199, %3200, %3202, %3201)[^bb13] : (i64, i16, vector<2xi64>, vector<2xi64>) -> ()
^bb13(%3203: i64, %3204: i16, %3205: vector<2xi64>, %3206: vector<2xi64>):  // 2 preds: ^bb2, ^bb12
  %3207 = "llvm.add"(%3170, %3132) <{overflowFlags = 0 : i32}> : (i32, i32) -> i32
  %3208 = "llvm.sext"(%3170) : (i32) -> i64
  %3209 = "llvm.getelementptr"(%arg211, %3208) <{elem_type = i16, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%3204, %3209) <{alignment = 2 : i64, ordering = 0 : i64}> : (i16, !llvm.ptr) -> ()
  %3210 = "llvm.extractelement"(%3206, %3133) : (vector<2xi64>, i64) -> i64
  %3211 = "llvm.intr.fshl"(%3210, %3203, %3139) : (i64, i64, i64) -> i64
  %3212 = "llvm.intr.fshl"(%3205, %3206, %3140) : (vector<2xi64>, vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  "llvm.store"(%3212, %3141) <{alignment = 16 : i64, ordering = 0 : i64}> : (vector<2xi64>, !llvm.ptr) -> ()
  %3213 = "llvm.extractelement"(%3205, %3134) : (vector<2xi64>, i64) -> i64
  %3214 = "llvm.lshr"(%3213, %3134) : (i64, i64) -> i64
  "llvm.store"(%3214, %3169) <{alignment = 16 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %3215 = "llvm.extractelement"(%3212, %3133) : (vector<2xi64>, i64) -> i64
  %3216 = "llvm.extractelement"(%3212, %3134) : (vector<2xi64>, i64) -> i64
  %3217 = "llvm.or"(%3215, %3216) : (i64, i64) -> i64
  %3218 = "llvm.or"(%3217, %3211) : (i64, i64) -> i64
  %3219 = "llvm.or"(%3218, %3214) : (i64, i64) -> i64
  %3220 = "llvm.icmp"(%3219, %3133) <{predicate = 0 : i64}> : (i64, i64) -> i1
  %3221 = "llvm.shufflevector"(%3212, %3136) <{mask = array<i32: 1, -1>}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %3222 = "llvm.insertelement"(%3221, %3214, %3134) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  "llvm.cond_br"(%3220, %3207, %3207, %3211, %3222, %3212)[^bb14, ^bb2] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 1, 4>}> : (i1, i32, i32, i64, vector<2xi64>, vector<2xi64>) -> ()
^bb14(%3223: i32):  // 2 preds: ^bb0, ^bb13
  "llvm.intr.lifetime.end"(%3141) : (!llvm.ptr) -> ()
  "llvm.return"(%3223) : (i32) -> ()
}) : () -> ()

end

end MLIR.Firedancer.Crc.Verify
