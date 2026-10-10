module

-- zig-build/out/op/Verifier.init.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Zig.Mlir.Edwards25519_fromBytes
public import Zig.Mlir.Edwards25519_rejectIdentity
public import Zig.Mlir.Fe_rejectNonCanonical
public import Zig.Mlir.Sha512_update
public import Zig.Mlir.scalar_rejectNonCanonical
public import Zig.Mlir.Sha512_iv

meta import MLIR.Semantics.Func
meta import Zig.Mlir.Edwards25519_fromBytes
meta import Zig.Mlir.Edwards25519_rejectIdentity
meta import Zig.Mlir.Fe_rejectNonCanonical
meta import Zig.Mlir.Sha512_update
meta import Zig.Mlir.scalar_rejectNonCanonical
meta import Zig.Mlir.Sha512_iv

namespace MLIR.Zig

@[expose] public section

noncomputable mlir_def Verifier_init :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.noalias, llvm.nocapture, llvm.nonnull, llvm.sret = !llvm.struct<(struct<"Verifier", (struct<"Sha512", (i128, array<8 x i64>, array<128 x i8>, i8, array<15 x i8>)>, struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>, struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>, array<32 x i8>)>, i16, array<14 x i8>)>, llvm.writeonly}, {llvm.align = 1 : i64, llvm.nocapture, llvm.nonnull, llvm.readonly}, {llvm.align = 1 : i64, llvm.nocapture, llvm.nonnull, llvm.readonly}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, minsize, no_inline, no_unwind, optsize, passthrough = ["nofree", "norecurse", "nosync", ["target-cpu", "x86-64"]], sym_name = "Verifier.init", target_cpu = "x86-64", target_features = #llvm.target_features<["+64bit", "+cmov", "+cx8", "+fxsr", "+idivq-to-divl", "+macrofusion", "+mmx", "+nopl", "+slow-3ops-lea", "+slow-incdec", "+vzeroupper", "+x87", "-16bit-mode", "-32bit-mode", "-adx", "-aes", "-allow-light-256-bit", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tf32", "-amx-tile", "-amx-transpose", "-avx", "-avx10.1-256", "-avx10.1-512", "-avx10.2-256", "-avx10.2-512", "-avx2", "-avx512bf16", "-avx512bitalg", "-avx512bw", "-avx512cd", "-avx512dq", "-avx512f", "-avx512fp16", "-avx512ifma", "-avx512vbmi", "-avx512vbmi2", "-avx512vl", "-avx512vnni", "-avx512vp2intersect", "-avx512vpopcntdq", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-bmi", "-bmi2", "-branch-hint", "-branchfusion", "-ccmp", "-cf", "-cldemote", "-clflushopt", "-clwb", "-clzero", "-cmpccxadd", "-crc32", "-cx16", "-egpr", "-enqcmd", "-ermsb", "-evex512", "-f16c", "-false-deps-getmant", "-false-deps-lzcnt-tzcnt", "-false-deps-mulc", "-false-deps-mullq", "-false-deps-perm", "-false-deps-popcnt", "-false-deps-range", "-fast-11bytenop", "-fast-15bytenop", "-fast-7bytenop", "-fast-bextr", "-fast-dpwssd", "-fast-gather", "-fast-hops", "-fast-imm16", "-fast-lzcnt", "-fast-movbe", "-fast-scalar-fsqrt", "-fast-scalar-shift-masks", "-fast-shld-rotate", "-fast-variable-crosslane-shuffle", "-fast-variable-perlane-shuffle", "-fast-vector-fsqrt", "-fast-vector-shift-masks", "-faster-shift-than-shuffle", "-fma", "-fma4", "-fsgsbase", "-fsrm", "-gfni", "-harden-sls-ijmp", "-harden-sls-ret", "-hreset", "-idivl-to-divb", "-inline-asm-use-gpr32", "-invpcid", "-kl", "-lea-sp", "-lea-uses-ag", "-lvi-cfi", "-lvi-load-hardening", "-lwp", "-lzcnt", "-movbe", "-movdir64b", "-movdiri", "-movrs", "-mwaitx", "-ndd", "-nf", "-no-bypass-delay", "-no-bypass-delay-blend", "-no-bypass-delay-mov", "-no-bypass-delay-shuffle", "-pad-short-functions", "-pclmul", "-pconfig", "-pku", "-popcnt", "-ppx", "-prefer-128-bit", "-prefer-256-bit", "-prefer-mask-registers", "-prefer-movmsk-over-vtest", "-prefer-no-gather", "-prefer-no-scatter", "-prefetchi", "-prfchw", "-ptwrite", "-push2pop2", "-raoint", "-rdpid", "-rdpru", "-rdrnd", "-rdseed", "-retpoline", "-retpoline-external-thunk", "-retpoline-indirect-branches", "-retpoline-indirect-calls", "-rtm", "-sahf", "-sbb-dep-breaking", "-serialize", "-seses", "-sgx", "-sha", "-sha512", "-shstk", "-slow-lea", "-slow-pmaddwd", "-slow-pmulld", "-slow-shld", "-slow-two-mem-ops", "-slow-unaligned-mem-16", "-slow-unaligned-mem-32", "-sm3", "-sm4", "-soft-float", "-sse", "-sse2", "-sse3", "-sse4.1", "-sse4.2", "-sse4a", "-sse-unaligned-mem", "-ssse3", "-tagged-globals", "-tbm", "-tsxldtrk", "-tuning-fast-imm-vector-shift", "-uintr", "-use-glm-div-sqrt-costs", "-use-slm-arith-costs", "-usermsr", "-vaes", "-vpclmulqdq", "-waitpkg", "-wbnoinvd", "-widekl", "-xop", "-xsave", "-xsavec", "-xsaveopt", "-xsaves", "-zu"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg67: !llvm.ptr, %arg68: !llvm.ptr, %arg69: !llvm.ptr):
  %3925 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %3926 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %3927 = "llvm.mlir.constant"() <{value = 0 : i16}> : () -> i16
  %3928 = "llvm.mlir.constant"() <{value = 592 : i64}> : () -> i64
  %3929 = "llvm.mlir.constant"() <{value = 168 : i64}> : () -> i64
  %3930 = "llvm.mlir.addressof"() <{global_name = @Sha512.iv}> : () -> !llvm.ptr
  %3931 = "llvm.mlir.constant"() <{value = 224 : i64}> : () -> i64
  %3932 = "llvm.alloca"(%3925) <{alignment = 16 : i64, elem_type = !llvm.struct<"Verifier", (struct<"Sha512", (i128, array<8 x i64>, array<128 x i8>, i8, array<15 x i8>)>, struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>, struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>, array<32 x i8>)>}> : (i32) -> !llvm.ptr
  %3933 = "llvm.alloca"(%3925) <{alignment = 16 : i64, elem_type = !llvm.struct<"Sha512", (i128, array<8 x i64>, array<128 x i8>, i8, array<15 x i8>)>}> : (i32) -> !llvm.ptr
  %3934 = "llvm.alloca"(%3925) <{alignment = 8 : i64, elem_type = !llvm.struct<(struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>, i16, array<6 x i8>)>}> : (i32) -> !llvm.ptr
  %3935 = "llvm.alloca"(%3925) <{alignment = 8 : i64, elem_type = !llvm.struct<(struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>, i16, array<6 x i8>)>}> : (i32) -> !llvm.ptr
  %3936 = "llvm.alloca"(%3925) <{alignment = 1 : i64, elem_type = !llvm.array<32 x i8>}> : (i32) -> !llvm.ptr
  "llvm.intr.memcpy"(%3936, %arg68, %3926) <{arg_attrs = [{llvm.align = 1 : i64, llvm.dereferenceable = 32 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 1 : i64, llvm.dereferenceable = 32 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %3937 = "llvm.getelementptr"(%arg68) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %3938 = "llvm.call"(%3937) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.align = 1 : i64, llvm.nonnull, llvm.readonly}], callee = @scalar.rejectNonCanonical, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i16
  %3939 = "llvm.icmp"(%3938, %3927) <{predicate = 0 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%3939)[^bb3, ^bb2] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb1:  // 7 preds: ^bb2, ^bb4, ^bb6, ^bb8, ^bb10, ^bb12, ^bb13
  "llvm.return"() : () -> ()
^bb2:  // pred: ^bb0
  %3940 = "llvm.getelementptr"(%arg67) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 592>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3938, %3940) <{alignment = 16 : i64, ordering = 0 : i64}> : (i16, !llvm.ptr) -> ()
  "llvm.br"()[^bb1] : () -> ()
^bb3:  // pred: ^bb0
  "llvm.call"(%3935, %arg69) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<(struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>, i16, array<6 x i8>)>}, {llvm.align = 1 : i64, llvm.nonnull, llvm.readonly}], callee = @Edwards25519.fromBytes, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %3941 = "llvm.getelementptr"(%3935) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 168>}> : (!llvm.ptr) -> !llvm.ptr
  %3942 = "llvm.load"(%3941) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i16
  %3943 = "llvm.icmp"(%3942, %3927) <{predicate = 0 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%3943)[^bb5, ^bb4] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb4:  // pred: ^bb3
  %3944 = "llvm.getelementptr"(%arg67) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 592>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3942, %3944) <{alignment = 16 : i64, ordering = 0 : i64}> : (i16, !llvm.ptr) -> ()
  "llvm.br"()[^bb1] : () -> ()
^bb5:  // pred: ^bb3
  %3945 = "llvm.call"(%3935) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Edwards25519.rejectIdentity, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i16
  %3946 = "llvm.icmp"(%3945, %3927) <{predicate = 0 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%3946)[^bb7, ^bb6] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb6:  // pred: ^bb5
  %3947 = "llvm.getelementptr"(%arg67) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 592>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3945, %3947) <{alignment = 16 : i64, ordering = 0 : i64}> : (i16, !llvm.ptr) -> ()
  "llvm.br"()[^bb1] : () -> ()
^bb7:  // pred: ^bb5
  %3948 = "llvm.call"(%3936) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 1 : i64, llvm.nonnull, llvm.readonly}], callee = @Fe.rejectNonCanonical, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.range = #llvm.constant_range<i16, 0, 2>}]}> : (!llvm.ptr) -> i16
  %3949 = "llvm.icmp"(%3948, %3927) <{predicate = 0 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%3949)[^bb9, ^bb8] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb8:  // pred: ^bb7
  %3950 = "llvm.getelementptr"(%arg67) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 592>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3948, %3950) <{alignment = 16 : i64, ordering = 0 : i64}> : (i16, !llvm.ptr) -> ()
  "llvm.br"()[^bb1] : () -> ()
^bb9:  // pred: ^bb7
  "llvm.call"(%3934, %arg68) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<(struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>, i16, array<6 x i8>)>}, {llvm.align = 1 : i64, llvm.nonnull, llvm.readonly}], callee = @Edwards25519.fromBytes, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %3951 = "llvm.getelementptr"(%3934) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 168>}> : (!llvm.ptr) -> !llvm.ptr
  %3952 = "llvm.load"(%3951) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i16
  %3953 = "llvm.icmp"(%3952, %3927) <{predicate = 0 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%3953)[^bb11, ^bb10] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb10:  // pred: ^bb9
  %3954 = "llvm.getelementptr"(%arg67) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 592>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3952, %3954) <{alignment = 16 : i64, ordering = 0 : i64}> : (i16, !llvm.ptr) -> ()
  "llvm.br"()[^bb1] : () -> ()
^bb11:  // pred: ^bb9
  %3955 = "llvm.call"(%3934) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Edwards25519.rejectIdentity, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i16
  %3956 = "llvm.icmp"(%3955, %3927) <{predicate = 0 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%3956)[^bb13, ^bb12] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb12:  // pred: ^bb11
  %3957 = "llvm.getelementptr"(%arg67) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 592>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3955, %3957) <{alignment = 16 : i64, ordering = 0 : i64}> : (i16, !llvm.ptr) -> ()
  "llvm.br"()[^bb1] : () -> ()
^bb13:  // pred: ^bb11
  "llvm.intr.memcpy"(%3933, %3930, %3931) <{arg_attrs = [{llvm.align = 16 : i64, llvm.dereferenceable = 224 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 16 : i64, llvm.dereferenceable = 224 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.call"(%3933, %arg68, %3926) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 16 : i64, llvm.nonnull}, {llvm.align = 1 : i64, llvm.nonnull, llvm.readonly}, {}], callee = @Sha512.update, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = write, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.call"(%3933, %arg69, %3926) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 16 : i64, llvm.nonnull}, {llvm.align = 1 : i64, llvm.nonnull, llvm.readonly}, {}], callee = @Sha512.update, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = write, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.intr.memcpy"(%3932, %3933, %3931) <{arg_attrs = [{llvm.align = 16 : i64, llvm.dereferenceable = 224 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 16 : i64, llvm.dereferenceable = 224 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %3958 = "llvm.getelementptr"(%3932) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 560>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memcpy"(%3958, %3937, %3926) <{arg_attrs = [{llvm.align = 16 : i64, llvm.dereferenceable = 32 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 1 : i64, llvm.dereferenceable = 32 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %3959 = "llvm.getelementptr"(%3932) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 224>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memcpy"(%3959, %3935, %3929) <{arg_attrs = [{llvm.align = 16 : i64, llvm.dereferenceable = 168 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 168 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %3960 = "llvm.getelementptr"(%3932) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 392>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memcpy"(%3960, %3934, %3929) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 168 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 168 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %3961 = "llvm.getelementptr"(%arg67) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 592>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3927, %3961) <{alignment = 16 : i64, ordering = 0 : i64}> : (i16, !llvm.ptr) -> ()
  "llvm.intr.memcpy"(%arg67, %3932, %3928) <{arg_attrs = [{llvm.align = 16 : i64, llvm.dereferenceable = 592 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 16 : i64, llvm.dereferenceable = 592 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.br"()[^bb1] : () -> ()
}) : () -> ()
  with @Edwards25519.fromBytes := Edwards25519_fromBytes,
    @Edwards25519.rejectIdentity := Edwards25519_rejectIdentity,
    @Fe.rejectNonCanonical := Fe_rejectNonCanonical, @Sha512.update := Sha512_update,
    @scalar.rejectNonCanonical := scalar_rejectNonCanonical, @Sha512.iv := Sha512_iv

end

end MLIR.Zig
