module

-- zig-build/out/op/Edwards25519.fromBytes.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Zig.Mlir.Fe_add
public import Zig.Mlir.Fe_cMov
public import Zig.Mlir.Fe_isZero
public import Zig.Mlir.Fe_mul
public import Zig.Mlir.Fe_neg
public import Zig.Mlir.Fe_reduce
public import Zig.Mlir.Fe_sq
public import Zig.Mlir.Fe_sqn
public import Zig.Mlir.Fe_sub
public import Zig.Mlir.Edwards25519_fromBytes_invalid
public import Zig.Mlir.Fe_edwards25519d
public import Zig.Mlir.Fe_one
public import Zig.Mlir.Fe_sqrtm1

meta import MLIR.Semantics.Func
meta import Zig.Mlir.Fe_add
meta import Zig.Mlir.Fe_cMov
meta import Zig.Mlir.Fe_isZero
meta import Zig.Mlir.Fe_mul
meta import Zig.Mlir.Fe_neg
meta import Zig.Mlir.Fe_reduce
meta import Zig.Mlir.Fe_sq
meta import Zig.Mlir.Fe_sqn
meta import Zig.Mlir.Fe_sub
meta import Zig.Mlir.Edwards25519_fromBytes_invalid
meta import Zig.Mlir.Fe_edwards25519d
meta import Zig.Mlir.Fe_one
meta import Zig.Mlir.Fe_sqrtm1

namespace MLIR.Zig

@[expose] public section

mlir_def Edwards25519_fromBytes :=
#alias_scope_domain2 = #llvm.alias_scope_domain<id = distinct[2]<>, description = "Fe.fromBytes">
#alias_scope_domain3 = #llvm.alias_scope_domain<id = distinct[3]<>, description = "Fe.pow2523">
#alias_scope_domain4 = #llvm.alias_scope_domain<id = distinct[4]<>, description = "Fe.add">
#alias_scope_domain5 = #llvm.alias_scope_domain<id = distinct[5]<>, description = "Fe.toBytes">
#alias_scope2 = #llvm.alias_scope<id = distinct[17]<>, domain = #alias_scope_domain2, description = "Fe.fromBytes: argument 0">
#alias_scope3 = #llvm.alias_scope<id = distinct[18]<>, domain = #alias_scope_domain3, description = "Fe.pow2523: argument 0">
#alias_scope4 = #llvm.alias_scope<id = distinct[19]<>, domain = #alias_scope_domain4, description = "Fe.add: argument 0">
#alias_scope5 = #llvm.alias_scope<id = distinct[20]<>, domain = #alias_scope_domain5, description = "Fe.toBytes: argument 0">
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.noalias, llvm.nocapture, llvm.nonnull, llvm.sret = !llvm.struct<(struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>, i16, array<6 x i8>)>, llvm.writeonly}, {llvm.align = 1 : i64, llvm.nocapture, llvm.nonnull, llvm.readonly}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, minsize, no_unwind, optsize, passthrough = ["nofree", "norecurse", "nosync", ["target-cpu", "x86-64"]], sym_name = "Edwards25519.fromBytes", target_cpu = "x86-64", target_features = #llvm.target_features<["+64bit", "+cmov", "+cx8", "+fxsr", "+idivq-to-divl", "+macrofusion", "+mmx", "+nopl", "+slow-3ops-lea", "+slow-incdec", "+vzeroupper", "+x87", "-16bit-mode", "-32bit-mode", "-adx", "-aes", "-allow-light-256-bit", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tf32", "-amx-tile", "-amx-transpose", "-avx", "-avx10.1-256", "-avx10.1-512", "-avx10.2-256", "-avx10.2-512", "-avx2", "-avx512bf16", "-avx512bitalg", "-avx512bw", "-avx512cd", "-avx512dq", "-avx512f", "-avx512fp16", "-avx512ifma", "-avx512vbmi", "-avx512vbmi2", "-avx512vl", "-avx512vnni", "-avx512vp2intersect", "-avx512vpopcntdq", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-bmi", "-bmi2", "-branch-hint", "-branchfusion", "-ccmp", "-cf", "-cldemote", "-clflushopt", "-clwb", "-clzero", "-cmpccxadd", "-crc32", "-cx16", "-egpr", "-enqcmd", "-ermsb", "-evex512", "-f16c", "-false-deps-getmant", "-false-deps-lzcnt-tzcnt", "-false-deps-mulc", "-false-deps-mullq", "-false-deps-perm", "-false-deps-popcnt", "-false-deps-range", "-fast-11bytenop", "-fast-15bytenop", "-fast-7bytenop", "-fast-bextr", "-fast-dpwssd", "-fast-gather", "-fast-hops", "-fast-imm16", "-fast-lzcnt", "-fast-movbe", "-fast-scalar-fsqrt", "-fast-scalar-shift-masks", "-fast-shld-rotate", "-fast-variable-crosslane-shuffle", "-fast-variable-perlane-shuffle", "-fast-vector-fsqrt", "-fast-vector-shift-masks", "-faster-shift-than-shuffle", "-fma", "-fma4", "-fsgsbase", "-fsrm", "-gfni", "-harden-sls-ijmp", "-harden-sls-ret", "-hreset", "-idivl-to-divb", "-inline-asm-use-gpr32", "-invpcid", "-kl", "-lea-sp", "-lea-uses-ag", "-lvi-cfi", "-lvi-load-hardening", "-lwp", "-lzcnt", "-movbe", "-movdir64b", "-movdiri", "-movrs", "-mwaitx", "-ndd", "-nf", "-no-bypass-delay", "-no-bypass-delay-blend", "-no-bypass-delay-mov", "-no-bypass-delay-shuffle", "-pad-short-functions", "-pclmul", "-pconfig", "-pku", "-popcnt", "-ppx", "-prefer-128-bit", "-prefer-256-bit", "-prefer-mask-registers", "-prefer-movmsk-over-vtest", "-prefer-no-gather", "-prefer-no-scatter", "-prefetchi", "-prfchw", "-ptwrite", "-push2pop2", "-raoint", "-rdpid", "-rdpru", "-rdrnd", "-rdseed", "-retpoline", "-retpoline-external-thunk", "-retpoline-indirect-branches", "-retpoline-indirect-calls", "-rtm", "-sahf", "-sbb-dep-breaking", "-serialize", "-seses", "-sgx", "-sha", "-sha512", "-shstk", "-slow-lea", "-slow-pmaddwd", "-slow-pmulld", "-slow-shld", "-slow-two-mem-ops", "-slow-unaligned-mem-16", "-slow-unaligned-mem-32", "-sm3", "-sm4", "-soft-float", "-sse", "-sse2", "-sse3", "-sse4.1", "-sse4.2", "-sse4a", "-sse-unaligned-mem", "-ssse3", "-tagged-globals", "-tbm", "-tsxldtrk", "-tuning-fast-imm-vector-shift", "-uintr", "-use-glm-div-sqrt-costs", "-use-slm-arith-costs", "-usermsr", "-vaes", "-vpclmulqdq", "-waitpkg", "-wbnoinvd", "-widekl", "-xop", "-xsave", "-xsavec", "-xsaveopt", "-xsaves", "-zu"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg43: !llvm.ptr, %arg44: !llvm.ptr):
  %3309 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %3310 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %3311 = "llvm.mlir.constant"() <{value = 2251799813685247 : i64}> : () -> i64
  %3312 = "llvm.mlir.constant"() <{value = 6 : i64}> : () -> i64
  %3313 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %3314 = "llvm.mlir.constant"() <{value = 12 : i64}> : () -> i64
  %3315 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %3316 = "llvm.mlir.addressof"() <{global_name = @Fe.edwards25519d}> : () -> !llvm.ptr
  %3317 = "llvm.mlir.addressof"() <{global_name = @Fe.one}> : () -> !llvm.ptr
  %3318 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
  %3319 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %3320 = "llvm.mlir.constant"() <{value = 5 : i64}> : () -> i64
  %3321 = "llvm.mlir.constant"() <{value = 15 : i64}> : () -> i64
  %3322 = "llvm.mlir.constant"() <{value = 30 : i64}> : () -> i64
  %3323 = "llvm.mlir.constant"() <{value = 60 : i64}> : () -> i64
  %3324 = "llvm.mlir.constant"() <{value = 120 : i64}> : () -> i64
  %3325 = "llvm.mlir.constant"() <{value = 10 : i64}> : () -> i64
  %3326 = "llvm.mlir.addressof"() <{global_name = @Edwards25519.fromBytes.invalid}> : () -> !llvm.ptr
  %3327 = "llvm.mlir.constant"() <{value = 176 : i64}> : () -> i64
  %3328 = "llvm.mlir.addressof"() <{global_name = @Fe.sqrtm1}> : () -> !llvm.ptr
  %3329 = "llvm.mlir.constant"() <{value = true}> : () -> i1
  %3330 = "llvm.mlir.constant"() <{value = 7 : i8}> : () -> i8
  %3331 = "llvm.mlir.constant"() <{value = 1 : i8}> : () -> i8
  %3332 = "llvm.mlir.constant"() <{value = false}> : () -> i1
  %3333 = "llvm.mlir.constant"() <{value = 0 : i16}> : () -> i16
  %3334 = "llvm.mlir.constant"() <{value = 160 : i64}> : () -> i64
  %3335 = "llvm.alloca"(%3309) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %3336 = "llvm.alloca"(%3309) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %3337 = "llvm.alloca"(%3309) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %3338 = "llvm.alloca"(%3309) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %3339 = "llvm.alloca"(%3309) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %3340 = "llvm.alloca"(%3309) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %3341 = "llvm.alloca"(%3309) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %3342 = "llvm.alloca"(%3309) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %3343 = "llvm.alloca"(%3309) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %3344 = "llvm.alloca"(%3309) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %3345 = "llvm.alloca"(%3309) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %3346 = "llvm.alloca"(%3309) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %3347 = "llvm.alloca"(%3309) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %3348 = "llvm.alloca"(%3309) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %3349 = "llvm.alloca"(%3309) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %3350 = "llvm.alloca"(%3309) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %3351 = "llvm.alloca"(%3309) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %3352 = "llvm.alloca"(%3309) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %3353 = "llvm.alloca"(%3309) <{alignment = 8 : i64, elem_type = !llvm.array<32 x i8>}> : (i32) -> !llvm.ptr
  %3354 = "llvm.alloca"(%3309) <{alignment = 8 : i64, elem_type = !llvm.struct<(struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>)>}> : (i32) -> !llvm.ptr
  %3355 = "llvm.alloca"(%3309) <{alignment = 8 : i64, elem_type = i8}> : (i32) -> !llvm.ptr
  %3356 = "llvm.alloca"(%3309) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %3357 = "llvm.alloca"(%3309) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %3358 = "llvm.alloca"(%3309) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %3359 = "llvm.alloca"(%3309) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %3360 = "llvm.alloca"(%3309) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %3361 = "llvm.alloca"(%3309) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %3362 = "llvm.alloca"(%3309) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %3363 = "llvm.alloca"(%3309) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %3364 = "llvm.alloca"(%3309) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %3365 = "llvm.alloca"(%3309) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %3366 = "llvm.alloca"(%3309) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %3367 = "llvm.alloca"(%3309) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %3368 = "llvm.alloca"(%3309) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %3369 = "llvm.alloca"(%3309) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  "llvm.intr.experimental.noalias.scope.decl"() <{scope = #alias_scope2}> : () -> ()
  "llvm.intr.lifetime.start"(%3353) : (!llvm.ptr) -> ()
  "llvm.intr.memcpy"(%3353, %arg44, %3310) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 32 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 1 : i64, llvm.dereferenceable = 32 : i64, llvm.nonnull, llvm.noundef, llvm.readonly}, {}], isVolatile = false, noalias_scopes = [#alias_scope2]}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %3370 = "llvm.load"(%3353) <{alignment = 8 : i64, noalias_scopes = [#alias_scope2], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3371 = "llvm.and"(%3370, %3311) : (i64, i64) -> i64
  %3372 = "llvm.getelementptr"(%3353) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6>}> : (!llvm.ptr) -> !llvm.ptr
  %3373 = "llvm.load"(%3372) <{alignment = 2 : i64, noalias_scopes = [#alias_scope2], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3374 = "llvm.lshr"(%3373, %3313) : (i64, i64) -> i64
  %3375 = "llvm.and"(%3374, %3311) : (i64, i64) -> i64
  %3376 = "llvm.getelementptr"(%3353) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 12>}> : (!llvm.ptr) -> !llvm.ptr
  %3377 = "llvm.load"(%3376) <{alignment = 4 : i64, noalias_scopes = [#alias_scope2], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3378 = "llvm.lshr"(%3377, %3312) : (i64, i64) -> i64
  %3379 = "llvm.and"(%3378, %3311) : (i64, i64) -> i64
  %3380 = "llvm.getelementptr"(%3353) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 19>}> : (!llvm.ptr) -> !llvm.ptr
  %3381 = "llvm.load"(%3380) <{alignment = 1 : i64, noalias_scopes = [#alias_scope2], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3382 = "llvm.lshr"(%3381, %3315) : (i64, i64) -> i64
  %3383 = "llvm.and"(%3382, %3311) : (i64, i64) -> i64
  %3384 = "llvm.getelementptr"(%3353) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %3385 = "llvm.load"(%3384) <{alignment = 8 : i64, noalias_scopes = [#alias_scope2], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3386 = "llvm.lshr"(%3385, %3314) : (i64, i64) -> i64
  %3387 = "llvm.and"(%3386, %3311) : (i64, i64) -> i64
  "llvm.store"(%3371, %3369) <{alias_scopes = [#alias_scope2], alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %3388 = "llvm.getelementptr"(%3369) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3375, %3388) <{alias_scopes = [#alias_scope2], alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %3389 = "llvm.getelementptr"(%3369) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3379, %3389) <{alias_scopes = [#alias_scope2], alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %3390 = "llvm.getelementptr"(%3369) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3383, %3390) <{alias_scopes = [#alias_scope2], alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %3391 = "llvm.getelementptr"(%3369) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3387, %3391) <{alias_scopes = [#alias_scope2], alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3353) : (!llvm.ptr) -> ()
  "llvm.call"(%3368, %3369) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Fe.sq, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = write, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%3367, %3368, %3316) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Fe.mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = write, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%3366, %3368, %3317) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Fe.sub, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.memcpy"(%3368, %3366, %3318) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.call"(%3365, %3367, %3317) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Fe.add, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%3363, %3366, %3365) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Fe.mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = write, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3336) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3337) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3338) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3339) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3340) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3341) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3342) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3343) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3344) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3345) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3346) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3347) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3348) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3349) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3350) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3351) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3352) : (!llvm.ptr) -> ()
  "llvm.call"(%3351, %3363) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Fe.sq, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = write, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope3], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%3352, %3363, %3351) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Fe.mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = write, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope3], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%3349, %3352, %3319) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}, {}], callee = @Fe.sqn, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = write, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope3], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.call"(%3348, %3352, %3349) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Fe.mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = write, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope3], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%3347, %3348) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Fe.sq, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = write, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope3], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%3350, %3347, %3363) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Fe.mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = write, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope3], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%3346, %3350, %3320) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}, {}], callee = @Fe.sqn, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = write, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope3], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.call"(%3352, %3346, %3350) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Fe.mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = write, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope3], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%3344, %3352, %3320) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}, {}], callee = @Fe.sqn, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = write, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope3], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.call"(%3345, %3344, %3350) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Fe.mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = write, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope3], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%3343, %3345, %3321) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}, {}], callee = @Fe.sqn, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = write, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope3], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.call"(%3350, %3343, %3345) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Fe.mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = write, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope3], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%3342, %3350, %3322) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}, {}], callee = @Fe.sqn, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = write, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope3], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.call"(%3345, %3342, %3350) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Fe.mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = write, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope3], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%3341, %3345, %3323) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}, {}], callee = @Fe.sqn, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = write, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope3], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.call"(%3350, %3341, %3345) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Fe.mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = write, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope3], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%3340, %3350, %3324) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}, {}], callee = @Fe.sqn, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = write, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope3], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.call"(%3339, %3340, %3350) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Fe.mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = write, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope3], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%3338, %3339, %3325) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}, {}], callee = @Fe.sqn, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = write, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope3], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.call"(%3337, %3338, %3352) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Fe.mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = write, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope3], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%3336, %3337, %3319) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}, {}], callee = @Fe.sqn, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = write, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope3], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.call"(%3362, %3336, %3363) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Fe.mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = write, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3336) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3337) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3338) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3339) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3340) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3341) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3342) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3343) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3344) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3345) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3346) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3347) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3348) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3349) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3350) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3351) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3352) : (!llvm.ptr) -> ()
  "llvm.call"(%3364, %3362, %3366) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Fe.mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = write, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%3361, %3364) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Fe.sq, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = write, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%3360, %3361, %3365) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Fe.mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = write, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%3359, %3360, %3366) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Fe.sub, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  %3392 = "llvm.call"(%3359) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Fe.isZero, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i1
  %3393 = "llvm.load"(%3360) <{alignment = 8 : i64, noalias_scopes = [#alias_scope4], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3394 = "llvm.load"(%3368) <{alignment = 8 : i64, noalias_scopes = [#alias_scope4], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3395 = "llvm.add"(%3394, %3393) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %3396 = "llvm.getelementptr"(%3360) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %3397 = "llvm.load"(%3396) <{alignment = 8 : i64, noalias_scopes = [#alias_scope4], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3398 = "llvm.getelementptr"(%3368) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %3399 = "llvm.load"(%3398) <{alignment = 8 : i64, noalias_scopes = [#alias_scope4], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3400 = "llvm.add"(%3399, %3397) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %3401 = "llvm.getelementptr"(%3360) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %3402 = "llvm.load"(%3401) <{alignment = 8 : i64, noalias_scopes = [#alias_scope4], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3403 = "llvm.getelementptr"(%3368) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %3404 = "llvm.load"(%3403) <{alignment = 8 : i64, noalias_scopes = [#alias_scope4], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3405 = "llvm.add"(%3404, %3402) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %3406 = "llvm.getelementptr"(%3360) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %3407 = "llvm.load"(%3406) <{alignment = 8 : i64, noalias_scopes = [#alias_scope4], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3408 = "llvm.getelementptr"(%3368) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %3409 = "llvm.load"(%3408) <{alignment = 8 : i64, noalias_scopes = [#alias_scope4], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3410 = "llvm.add"(%3409, %3407) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %3411 = "llvm.getelementptr"(%3360) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %3412 = "llvm.load"(%3411) <{alignment = 8 : i64, noalias_scopes = [#alias_scope4], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3413 = "llvm.getelementptr"(%3368) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %3414 = "llvm.load"(%3413) <{alignment = 8 : i64, noalias_scopes = [#alias_scope4], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3415 = "llvm.add"(%3414, %3412) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  "llvm.store"(%3395, %3358) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %3416 = "llvm.getelementptr"(%3358) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3400, %3416) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %3417 = "llvm.getelementptr"(%3358) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3405, %3417) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %3418 = "llvm.getelementptr"(%3358) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3410, %3418) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %3419 = "llvm.getelementptr"(%3358) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3415, %3419) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %3420 = "llvm.call"(%3358) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Fe.isZero, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i1
  %3421 = "llvm.or"(%3392, %3420) : (i1, i1) -> i1
  "llvm.cond_br"(%3421)[^bb3, ^bb2] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb1:  // 2 preds: ^bb2, ^bb3
  "llvm.return"() : () -> ()
^bb2:  // pred: ^bb0
  "llvm.intr.memcpy"(%arg43, %3326, %3327) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 176 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 176 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.br"()[^bb1] : () -> ()
^bb3:  // pred: ^bb0
  "llvm.call"(%3357, %3364, %3328) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Fe.mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = write, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  %3422 = "llvm.xor"(%3392, %3329) : (i1, i1) -> i1
  %3423 = "llvm.zext"(%3422) : (i1) -> i64
  "llvm.call"(%3364, %3357, %3423) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.nonnull}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}, {}], callee = @Fe.cMov, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.call"(%3356, %3364) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Fe.neg, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3335) : (!llvm.ptr) -> ()
  "llvm.intr.memcpy"(%3335, %3364, %3318) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef, llvm.readonly}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.call"(%3335) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.nonnull}], callee = @Fe.reduce, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope5], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> ()
  %3424 = "llvm.load"(%3335) <{alignment = 8 : i64, noalias_scopes = [#alias_scope5], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  "llvm.intr.lifetime.end"(%3335) : (!llvm.ptr) -> ()
  %3425 = "llvm.getelementptr"(%arg44) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 31>}> : (!llvm.ptr) -> !llvm.ptr
  %3426 = "llvm.load"(%3425) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3427 = "llvm.lshr"(%3426, %3330) : (i8, i8) -> i8
  %3428 = "llvm.trunc"(%3424) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %3429 = "llvm.and"(%3428, %3331) : (i8, i8) -> i8
  %3430 = "llvm.xor"(%3427, %3429) : (i8, i8) -> i8
  %3431 = "llvm.zext"(%3430) <{nonNeg}> : (i8) -> i64
  "llvm.call"(%3364, %3356, %3431) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.nonnull}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}, {}], callee = @Fe.cMov, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %3432 = "llvm.getelementptr"(%3354) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 120>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%3432, %3364, %3369) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Fe.mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = write, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.memcpy"(%3354, %3364, %3318) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %3433 = "llvm.getelementptr"(%3354) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memcpy"(%3433, %3369, %3318) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %3434 = "llvm.getelementptr"(%3354) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 80>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memcpy"(%3434, %3317, %3318) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.store"(%3332, %3355) <{alignment = 8 : i64, ordering = 0 : i64}> : (i1, !llvm.ptr) -> ()
  %3435 = "llvm.getelementptr"(%arg43) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 168>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3333, %3435) <{alignment = 8 : i64, ordering = 0 : i64}> : (i16, !llvm.ptr) -> ()
  "llvm.intr.memcpy"(%arg43, %3354, %3334) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 160 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 160 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %3436 = "llvm.getelementptr"(%arg43) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 160>}> : (!llvm.ptr) -> !llvm.ptr
  %3437 = "llvm.load"(%3355) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  "llvm.store"(%3437, %3436) <{alignment = 8 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.br"()[^bb1] : () -> ()
}) : () -> ()
  with @Fe.add := Fe_add, @Fe.cMov := Fe_cMov, @Fe.isZero := Fe_isZero, @Fe.mul := Fe_mul,
    @Fe.neg := Fe_neg, @Fe.reduce := Fe_reduce, @Fe.sq := Fe_sq, @Fe.sqn := Fe_sqn,
    @Fe.sub := Fe_sub, @Edwards25519.fromBytes.invalid := Edwards25519_fromBytes_invalid,
    @Fe.edwards25519d := Fe_edwards25519d, @Fe.one := Fe_one, @Fe.sqrtm1 := Fe_sqrtm1

end

end MLIR.Zig
