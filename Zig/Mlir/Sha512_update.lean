module

-- zig-build/out/op/Sha512.update.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Zig.Mlir.Sha512_round

meta import MLIR.Semantics.Func
meta import Zig.Mlir.Sha512_round

namespace MLIR.Zig

@[expose] public section

noncomputable mlir_def Sha512_update :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 16 : i64, llvm.nocapture, llvm.nonnull}, {llvm.align = 1 : i64, llvm.nocapture, llvm.nonnull, llvm.readonly}, {}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr, i64)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = write, errnoMem = none, targetMem0 = none, targetMem1 = none>, minsize, no_unwind, optsize, passthrough = ["nofree", "norecurse", "nosync", ["target-cpu", "x86-64"]], sym_name = "Sha512.update", target_cpu = "x86-64", target_features = #llvm.target_features<["+64bit", "+cmov", "+cx8", "+fxsr", "+idivq-to-divl", "+macrofusion", "+mmx", "+nopl", "+slow-3ops-lea", "+slow-incdec", "+vzeroupper", "+x87", "-16bit-mode", "-32bit-mode", "-adx", "-aes", "-allow-light-256-bit", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tf32", "-amx-tile", "-amx-transpose", "-avx", "-avx10.1-256", "-avx10.1-512", "-avx10.2-256", "-avx10.2-512", "-avx2", "-avx512bf16", "-avx512bitalg", "-avx512bw", "-avx512cd", "-avx512dq", "-avx512f", "-avx512fp16", "-avx512ifma", "-avx512vbmi", "-avx512vbmi2", "-avx512vl", "-avx512vnni", "-avx512vp2intersect", "-avx512vpopcntdq", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-bmi", "-bmi2", "-branch-hint", "-branchfusion", "-ccmp", "-cf", "-cldemote", "-clflushopt", "-clwb", "-clzero", "-cmpccxadd", "-crc32", "-cx16", "-egpr", "-enqcmd", "-ermsb", "-evex512", "-f16c", "-false-deps-getmant", "-false-deps-lzcnt-tzcnt", "-false-deps-mulc", "-false-deps-mullq", "-false-deps-perm", "-false-deps-popcnt", "-false-deps-range", "-fast-11bytenop", "-fast-15bytenop", "-fast-7bytenop", "-fast-bextr", "-fast-dpwssd", "-fast-gather", "-fast-hops", "-fast-imm16", "-fast-lzcnt", "-fast-movbe", "-fast-scalar-fsqrt", "-fast-scalar-shift-masks", "-fast-shld-rotate", "-fast-variable-crosslane-shuffle", "-fast-variable-perlane-shuffle", "-fast-vector-fsqrt", "-fast-vector-shift-masks", "-faster-shift-than-shuffle", "-fma", "-fma4", "-fsgsbase", "-fsrm", "-gfni", "-harden-sls-ijmp", "-harden-sls-ret", "-hreset", "-idivl-to-divb", "-inline-asm-use-gpr32", "-invpcid", "-kl", "-lea-sp", "-lea-uses-ag", "-lvi-cfi", "-lvi-load-hardening", "-lwp", "-lzcnt", "-movbe", "-movdir64b", "-movdiri", "-movrs", "-mwaitx", "-ndd", "-nf", "-no-bypass-delay", "-no-bypass-delay-blend", "-no-bypass-delay-mov", "-no-bypass-delay-shuffle", "-pad-short-functions", "-pclmul", "-pconfig", "-pku", "-popcnt", "-ppx", "-prefer-128-bit", "-prefer-256-bit", "-prefer-mask-registers", "-prefer-movmsk-over-vtest", "-prefer-no-gather", "-prefer-no-scatter", "-prefetchi", "-prfchw", "-ptwrite", "-push2pop2", "-raoint", "-rdpid", "-rdpru", "-rdrnd", "-rdseed", "-retpoline", "-retpoline-external-thunk", "-retpoline-indirect-branches", "-retpoline-indirect-calls", "-rtm", "-sahf", "-sbb-dep-breaking", "-serialize", "-seses", "-sgx", "-sha", "-sha512", "-shstk", "-slow-lea", "-slow-pmaddwd", "-slow-pmulld", "-slow-shld", "-slow-two-mem-ops", "-slow-unaligned-mem-16", "-slow-unaligned-mem-32", "-sm3", "-sm4", "-soft-float", "-sse", "-sse2", "-sse3", "-sse4.1", "-sse4.2", "-sse4a", "-sse-unaligned-mem", "-ssse3", "-tagged-globals", "-tbm", "-tsxldtrk", "-tuning-fast-imm-vector-shift", "-uintr", "-use-glm-div-sqrt-costs", "-use-slm-arith-costs", "-usermsr", "-vaes", "-vpclmulqdq", "-waitpkg", "-wbnoinvd", "-widekl", "-xop", "-xsave", "-xsavec", "-xsaveopt", "-xsaves", "-zu"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg64: !llvm.ptr, %arg65: !llvm.ptr, %arg66: i64):
  %3892 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %3893 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %3894 = "llvm.mlir.constant"() <{value = 127 : i64}> : () -> i64
  %3895 = "llvm.mlir.constant"() <{value = -128 : i8}> : () -> i8
  %3896 = "llvm.mlir.constant"() <{value = 128 : i64}> : () -> i64
  %3897 = "llvm.mlir.constant"() <{value = 256 : i64}> : () -> i64
  %3898 = "llvm.getelementptr"(%arg64) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 208>}> : (!llvm.ptr) -> !llvm.ptr
  %3899 = "llvm.load"(%3898) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3900 = "llvm.icmp"(%3899, %3892) <{predicate = 0 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%3900, %3893)[^bb3, ^bb1] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
^bb1:  // pred: ^bb0
  %3901 = "llvm.zext"(%3899) : (i8) -> i64
  %3902 = "llvm.add"(%arg66, %3901) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %3903 = "llvm.icmp"(%3902, %3894) <{predicate = 8 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%3903, %3893)[^bb2, ^bb3] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb2:  // pred: ^bb1
  %3904 = "llvm.sub"(%3895, %3899) <{overflowFlags = 2 : i32}> : (i8, i8) -> i8
  %3905 = "llvm.zext"(%3904) <{nonNeg}> : (i8) -> i64
  %3906 = "llvm.getelementptr"(%arg64) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 80>}> : (!llvm.ptr) -> !llvm.ptr
  %3907 = "llvm.getelementptr"(%3906, %3901) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.intr.memcpy"(%3907, %arg65, %3905) <{arg_attrs = [{llvm.align = 1 : i64, llvm.nonnull}, {llvm.align = 1 : i64, llvm.nonnull}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.call"(%arg64, %3906) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.align = 16 : i64, llvm.nonnull}, {llvm.align = 1 : i64, llvm.nonnull, llvm.readonly}], callee = @Sha512.round, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.store"(%3892, %3898) <{alignment = 16 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.br"(%3905)[^bb3] : (i64) -> ()
^bb3(%3908: i64):  // 3 preds: ^bb0, ^bb1, ^bb2
  "llvm.br"(%3908)[^bb4] : (i64) -> ()
^bb4(%3909: i64):  // 2 preds: ^bb3, ^bb5
  %3910 = "llvm.add"(%3909, %3896) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %3911 = "llvm.icmp"(%3910, %arg66) <{predicate = 8 : i64}> : (i64, i64) -> i1
  %3912 = "llvm.getelementptr"(%arg65, %3909) <{elem_type = i8, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.cond_br"(%3911)[^bb6, ^bb5] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb5:  // pred: ^bb4
  "llvm.call"(%arg64, %3912) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.align = 16 : i64, llvm.nonnull}, {llvm.align = 1 : i64, llvm.nonnull, llvm.readonly}], callee = @Sha512.round, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.br"(%3910)[^bb4] : (i64) -> ()
^bb6:  // pred: ^bb4
  %3913 = "llvm.sub"(%arg66, %3909) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %3914 = "llvm.getelementptr"(%arg64) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 80>}> : (!llvm.ptr) -> !llvm.ptr
  %3915 = "llvm.load"(%3898) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3916 = "llvm.zext"(%3915) : (i8) -> i64
  %3917 = "llvm.getelementptr"(%3914, %3916) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.intr.memcpy"(%3917, %3912, %3913) <{arg_attrs = [{llvm.align = 1 : i64, llvm.nonnull}, {llvm.align = 1 : i64, llvm.nonnull}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %3918 = "llvm.load"(%3898) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3919 = "llvm.icmp"(%3913, %3897) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.intr.assume"(%3919) <{op_bundle_sizes = array<i32>}> : (i1) -> ()
  %3920 = "llvm.trunc"(%3913) <{overflowFlags = 2 : i32}> : (i64) -> i8
  %3921 = "llvm.add"(%3918, %3920) <{overflowFlags = 2 : i32}> : (i8, i8) -> i8
  "llvm.store"(%3921, %3898) <{alignment = 16 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %3922 = "llvm.load"(%arg64) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i128
  %3923 = "llvm.zext"(%arg66) : (i64) -> i128
  %3924 = "llvm.add"(%3922, %3923) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  "llvm.store"(%3924, %arg64) <{alignment = 16 : i64, ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
  with @Sha512.round := Sha512_round

end

end MLIR.Zig
