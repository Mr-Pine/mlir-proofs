module

-- zig-build/out/op/Edwards25519.mulDoubleBasePublic.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Zig.Mlir.Edwards25519_add
public import Zig.Mlir.Edwards25519_dbl
public import Zig.Mlir.Edwards25519_precompute
public import Zig.Mlir.Edwards25519_rejectIdentity
public import Zig.Mlir.Edwards25519_slide
public import Zig.Mlir.Edwards25519_sub
public import Zig.Mlir.Edwards25519_basePointPc
public import Zig.Mlir.Edwards25519_identityElement
public import Zig.Mlir.Edwards25519_mulDoubleBasePublic_weak

meta import MLIR.Semantics.Func
meta import Zig.Mlir.Edwards25519_add
meta import Zig.Mlir.Edwards25519_dbl
meta import Zig.Mlir.Edwards25519_precompute
meta import Zig.Mlir.Edwards25519_rejectIdentity
meta import Zig.Mlir.Edwards25519_slide
meta import Zig.Mlir.Edwards25519_sub
meta import Zig.Mlir.Edwards25519_basePointPc
meta import Zig.Mlir.Edwards25519_identityElement
meta import Zig.Mlir.Edwards25519_mulDoubleBasePublic_weak

namespace MLIR.Zig

@[expose] public section

noncomputable mlir_def Edwards25519_mulDoubleBasePublic :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.noalias, llvm.nocapture, llvm.nonnull, llvm.sret = !llvm.struct<(struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>, i16, array<6 x i8>)>, llvm.writeonly}, {llvm.align = 1 : i64, llvm.nocapture, llvm.nonnull, llvm.readonly}, {llvm.align = 8 : i64, llvm.nocapture, llvm.nonnull, llvm.readonly}, {llvm.align = 1 : i64, llvm.nocapture, llvm.nonnull, llvm.readonly}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = read, argMem = readwrite, inaccessibleMem = readwrite, errnoMem = read, targetMem0 = read, targetMem1 = read>, minsize, no_inline, no_unwind, optsize, passthrough = ["nofree", "norecurse", "nosync", ["target-cpu", "x86-64"]], sym_name = "Edwards25519.mulDoubleBasePublic", target_cpu = "x86-64", target_features = #llvm.target_features<["+64bit", "+cmov", "+cx8", "+fxsr", "+idivq-to-divl", "+macrofusion", "+mmx", "+nopl", "+slow-3ops-lea", "+slow-incdec", "+vzeroupper", "+x87", "-16bit-mode", "-32bit-mode", "-adx", "-aes", "-allow-light-256-bit", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tf32", "-amx-tile", "-amx-transpose", "-avx", "-avx10.1-256", "-avx10.1-512", "-avx10.2-256", "-avx10.2-512", "-avx2", "-avx512bf16", "-avx512bitalg", "-avx512bw", "-avx512cd", "-avx512dq", "-avx512f", "-avx512fp16", "-avx512ifma", "-avx512vbmi", "-avx512vbmi2", "-avx512vl", "-avx512vnni", "-avx512vp2intersect", "-avx512vpopcntdq", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-bmi", "-bmi2", "-branch-hint", "-branchfusion", "-ccmp", "-cf", "-cldemote", "-clflushopt", "-clwb", "-clzero", "-cmpccxadd", "-crc32", "-cx16", "-egpr", "-enqcmd", "-ermsb", "-evex512", "-f16c", "-false-deps-getmant", "-false-deps-lzcnt-tzcnt", "-false-deps-mulc", "-false-deps-mullq", "-false-deps-perm", "-false-deps-popcnt", "-false-deps-range", "-fast-11bytenop", "-fast-15bytenop", "-fast-7bytenop", "-fast-bextr", "-fast-dpwssd", "-fast-gather", "-fast-hops", "-fast-imm16", "-fast-lzcnt", "-fast-movbe", "-fast-scalar-fsqrt", "-fast-scalar-shift-masks", "-fast-shld-rotate", "-fast-variable-crosslane-shuffle", "-fast-variable-perlane-shuffle", "-fast-vector-fsqrt", "-fast-vector-shift-masks", "-faster-shift-than-shuffle", "-fma", "-fma4", "-fsgsbase", "-fsrm", "-gfni", "-harden-sls-ijmp", "-harden-sls-ret", "-hreset", "-idivl-to-divb", "-inline-asm-use-gpr32", "-invpcid", "-kl", "-lea-sp", "-lea-uses-ag", "-lvi-cfi", "-lvi-load-hardening", "-lwp", "-lzcnt", "-movbe", "-movdir64b", "-movdiri", "-movrs", "-mwaitx", "-ndd", "-nf", "-no-bypass-delay", "-no-bypass-delay-blend", "-no-bypass-delay-mov", "-no-bypass-delay-shuffle", "-pad-short-functions", "-pclmul", "-pconfig", "-pku", "-popcnt", "-ppx", "-prefer-128-bit", "-prefer-256-bit", "-prefer-mask-registers", "-prefer-movmsk-over-vtest", "-prefer-no-gather", "-prefer-no-scatter", "-prefetchi", "-prfchw", "-ptwrite", "-push2pop2", "-raoint", "-rdpid", "-rdpru", "-rdrnd", "-rdseed", "-retpoline", "-retpoline-external-thunk", "-retpoline-indirect-branches", "-retpoline-indirect-calls", "-rtm", "-sahf", "-sbb-dep-breaking", "-serialize", "-seses", "-sgx", "-sha", "-sha512", "-shstk", "-slow-lea", "-slow-pmaddwd", "-slow-pmulld", "-slow-shld", "-slow-two-mem-ops", "-slow-unaligned-mem-16", "-slow-unaligned-mem-32", "-sm3", "-sm4", "-soft-float", "-sse", "-sse2", "-sse3", "-sse4.1", "-sse4.2", "-sse4a", "-sse-unaligned-mem", "-ssse3", "-tagged-globals", "-tbm", "-tsxldtrk", "-tuning-fast-imm-vector-shift", "-uintr", "-use-glm-div-sqrt-costs", "-use-slm-arith-costs", "-usermsr", "-vaes", "-vpclmulqdq", "-waitpkg", "-wbnoinvd", "-widekl", "-xop", "-xsave", "-xsavec", "-xsaveopt", "-xsaves", "-zu"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg50: !llvm.ptr, %arg51: !llvm.ptr, %arg52: !llvm.ptr, %arg53: !llvm.ptr):
  %3483 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %3484 = "llvm.mlir.addressof"() <{global_name = @Edwards25519.basePointPc}> : () -> !llvm.ptr
  %3485 = "llvm.mlir.constant"() <{value = 0 : i16}> : () -> i16
  %3486 = "llvm.mlir.addressof"() <{global_name = @Edwards25519.mulDoubleBasePublic.weak}> : () -> !llvm.ptr
  %3487 = "llvm.mlir.constant"() <{value = 176 : i64}> : () -> i64
  %3488 = "llvm.mlir.addressof"() <{global_name = @Edwards25519.identityElement}> : () -> !llvm.ptr
  %3489 = "llvm.mlir.constant"() <{value = 168 : i64}> : () -> i64
  %3490 = "llvm.mlir.constant"() <{value = 63 : i64}> : () -> i64
  %3491 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %3492 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %3493 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %3494 = "llvm.alloca"(%3483) <{alignment = 8 : i64, elem_type = !llvm.struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>}> : (i32) -> !llvm.ptr
  %3495 = "llvm.alloca"(%3483) <{alignment = 8 : i64, elem_type = !llvm.struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>}> : (i32) -> !llvm.ptr
  %3496 = "llvm.alloca"(%3483) <{alignment = 8 : i64, elem_type = !llvm.struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>}> : (i32) -> !llvm.ptr
  %3497 = "llvm.alloca"(%3483) <{alignment = 8 : i64, elem_type = !llvm.struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>}> : (i32) -> !llvm.ptr
  %3498 = "llvm.alloca"(%3483) <{alignment = 8 : i64, elem_type = !llvm.struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>}> : (i32) -> !llvm.ptr
  %3499 = "llvm.alloca"(%3483) <{alignment = 8 : i64, elem_type = !llvm.struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>}> : (i32) -> !llvm.ptr
  %3500 = "llvm.alloca"(%3483) <{alignment = 8 : i64, elem_type = !llvm.struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>}> : (i32) -> !llvm.ptr
  %3501 = "llvm.alloca"(%3483) <{alignment = 8 : i64, elem_type = !llvm.struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>}> : (i32) -> !llvm.ptr
  %3502 = "llvm.alloca"(%3483) <{alignment = 1 : i64, elem_type = !llvm.array<64 x i8>}> : (i32) -> !llvm.ptr
  %3503 = "llvm.alloca"(%3483) <{alignment = 1 : i64, elem_type = !llvm.array<64 x i8>}> : (i32) -> !llvm.ptr
  %3504 = "llvm.alloca"(%3483) <{alignment = 8 : i64, elem_type = !llvm.array<9 x struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>>}> : (i32) -> !llvm.ptr
  %3505 = "llvm.getelementptr"(%arg52) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 160>}> : (!llvm.ptr) -> !llvm.ptr
  %3506 = "llvm.load"(%3505) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i1
  "llvm.cond_br"(%3506, %3484)[^bb2, ^bb3] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, !llvm.ptr) -> ()
^bb1:  // 2 preds: ^bb4, ^bb16
  "llvm.return"() : () -> ()
^bb2(%3507: !llvm.ptr):  // 2 preds: ^bb0, ^bb3
  "llvm.call"(%3503, %arg51) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.array<64 x i8>}, {llvm.align = 1 : i64, llvm.nonnull, llvm.readonly}], callee = @Edwards25519.slide, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = read, argMem = readwrite, inaccessibleMem = write, errnoMem = read, targetMem0 = read, targetMem1 = read>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%3502, %arg53) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.array<64 x i8>}, {llvm.align = 1 : i64, llvm.nonnull, llvm.readonly}], callee = @Edwards25519.slide, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = read, argMem = readwrite, inaccessibleMem = write, errnoMem = read, targetMem0 = read, targetMem1 = read>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.memcpy"(%3501, %3488, %3489) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 168 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 168 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.br"(%3490)[^bb5] : (i64) -> ()
^bb3:  // pred: ^bb0
  "llvm.call"(%3504, %arg52) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.array<9 x struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Edwards25519.precompute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %3508 = "llvm.getelementptr"(%3504) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 672>}> : (!llvm.ptr) -> !llvm.ptr
  %3509 = "llvm.call"(%3508) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Edwards25519.rejectIdentity, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i16
  %3510 = "llvm.icmp"(%3509, %3485) <{predicate = 0 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%3510, %3504)[^bb2, ^bb4] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, !llvm.ptr) -> ()
^bb4:  // pred: ^bb3
  "llvm.intr.memcpy"(%arg50, %3486, %3487) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 176 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 176 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.br"()[^bb1] : () -> ()
^bb5(%3511: i64):  // 2 preds: ^bb2, ^bb17
  %3512 = "llvm.getelementptr"(%3503, %3511) <{elem_type = !llvm.array<64 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: 0, -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %3513 = "llvm.load"(%3512) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3514 = "llvm.icmp"(%3513, %3492) <{predicate = 4 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%3514)[^bb8, ^bb9] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb6(%3515: !llvm.ptr):  // 2 preds: ^bb8, ^bb10
  "llvm.intr.memcpy"(%3501, %3515, %3489) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 168 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 168 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.br"()[^bb7] : () -> ()
^bb7:  // 2 preds: ^bb6, ^bb9
  %3516 = "llvm.getelementptr"(%3502, %3511) <{elem_type = !llvm.array<64 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: 0, -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %3517 = "llvm.load"(%3516) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3518 = "llvm.icmp"(%3517, %3492) <{predicate = 4 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%3518)[^bb13, ^bb14] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb8:  // pred: ^bb5
  %3519 = "llvm.zext"(%3513) <{nonNeg}> : (i8) -> i64
  %3520 = "llvm.getelementptr"(%3484, %3519) <{elem_type = !llvm.array<9 x struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 0, -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.call"(%3500, %3501, %3520) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Edwards25519.add, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.br"(%3500)[^bb6] : (!llvm.ptr) -> ()
^bb9:  // pred: ^bb5
  %3521 = "llvm.icmp"(%3513, %3492) <{predicate = 2 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%3521)[^bb10, ^bb7] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb10:  // pred: ^bb9
  %3522 = "llvm.sub"(%3492, %3513) <{overflowFlags = 1 : i32}> : (i8, i8) -> i8
  %3523 = "llvm.zext"(%3522) <{nonNeg}> : (i8) -> i64
  %3524 = "llvm.getelementptr"(%3484, %3523) <{elem_type = !llvm.array<9 x struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 0, -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.call"(%3499, %3501, %3524) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Edwards25519.sub, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.br"(%3499)[^bb6] : (!llvm.ptr) -> ()
^bb11(%3525: !llvm.ptr):  // 2 preds: ^bb13, ^bb15
  "llvm.intr.memcpy"(%3501, %3525, %3489) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 168 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 168 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.br"()[^bb12] : () -> ()
^bb12:  // 2 preds: ^bb11, ^bb14
  %3526 = "llvm.icmp"(%3511, %3491) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%3526)[^bb16, ^bb17] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb13:  // pred: ^bb7
  %3527 = "llvm.zext"(%3517) <{nonNeg}> : (i8) -> i64
  %3528 = "llvm.getelementptr"(%3507, %3527) <{elem_type = !llvm.array<9 x struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 0, -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.call"(%3498, %3501, %3528) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Edwards25519.add, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.br"(%3498)[^bb11] : (!llvm.ptr) -> ()
^bb14:  // pred: ^bb7
  %3529 = "llvm.icmp"(%3517, %3492) <{predicate = 2 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%3529)[^bb15, ^bb12] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb15:  // pred: ^bb14
  %3530 = "llvm.sub"(%3492, %3517) <{overflowFlags = 1 : i32}> : (i8, i8) -> i8
  %3531 = "llvm.zext"(%3530) <{nonNeg}> : (i8) -> i64
  %3532 = "llvm.getelementptr"(%3507, %3531) <{elem_type = !llvm.array<9 x struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 0, -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.call"(%3497, %3501, %3532) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Edwards25519.sub, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.br"(%3497)[^bb11] : (!llvm.ptr) -> ()
^bb16:  // pred: ^bb12
  %3533 = "llvm.getelementptr"(%arg50) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 168>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3485, %3533) <{alignment = 8 : i64, ordering = 0 : i64}> : (i16, !llvm.ptr) -> ()
  "llvm.intr.memcpy"(%arg50, %3501, %3489) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 168 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 168 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.br"()[^bb1] : () -> ()
^bb17:  // pred: ^bb12
  "llvm.call"(%3496, %3501) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Edwards25519.dbl, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%3495, %3496) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Edwards25519.dbl, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%3494, %3495) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Edwards25519.dbl, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%3501, %3494) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Edwards25519.dbl, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %3534 = "llvm.add"(%3511, %3493) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  "llvm.br"(%3534)[^bb5] : (i64) -> ()
}) : () -> ()
  with @Edwards25519.add := Edwards25519_add, @Edwards25519.dbl := Edwards25519_dbl,
    @Edwards25519.precompute := Edwards25519_precompute,
    @Edwards25519.rejectIdentity := Edwards25519_rejectIdentity,
    @Edwards25519.slide := Edwards25519_slide, @Edwards25519.sub := Edwards25519_sub,
    @Edwards25519.basePointPc := Edwards25519_basePointPc,
    @Edwards25519.identityElement := Edwards25519_identityElement,
    @Edwards25519.mulDoubleBasePublic.weak := Edwards25519_mulDoubleBasePublic_weak

end

end MLIR.Zig
