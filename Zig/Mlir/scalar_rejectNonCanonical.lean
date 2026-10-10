module

-- zig-build/out/op/scalar.rejectNonCanonical.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Zig.Mlir.scalar_field_order_s

meta import MLIR.Semantics.Func
meta import Zig.Mlir.scalar_field_order_s

namespace MLIR.Zig

@[expose] public section

mlir_def scalar_rejectNonCanonical :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 1 : i64, llvm.nocapture, llvm.nonnull, llvm.readonly}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<i16 (ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, minsize, no_inline, no_unwind, optsize, passthrough = ["nofree", "norecurse", "nosync", ["target-cpu", "x86-64"]], res_attrs = [{llvm.range = #llvm.constant_range<i16, 0, 2>}], sym_name = "scalar.rejectNonCanonical", target_cpu = "x86-64", target_features = #llvm.target_features<["+64bit", "+cmov", "+cx8", "+fxsr", "+idivq-to-divl", "+macrofusion", "+mmx", "+nopl", "+slow-3ops-lea", "+slow-incdec", "+vzeroupper", "+x87", "-16bit-mode", "-32bit-mode", "-adx", "-aes", "-allow-light-256-bit", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tf32", "-amx-tile", "-amx-transpose", "-avx", "-avx10.1-256", "-avx10.1-512", "-avx10.2-256", "-avx10.2-512", "-avx2", "-avx512bf16", "-avx512bitalg", "-avx512bw", "-avx512cd", "-avx512dq", "-avx512f", "-avx512fp16", "-avx512ifma", "-avx512vbmi", "-avx512vbmi2", "-avx512vl", "-avx512vnni", "-avx512vp2intersect", "-avx512vpopcntdq", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-bmi", "-bmi2", "-branch-hint", "-branchfusion", "-ccmp", "-cf", "-cldemote", "-clflushopt", "-clwb", "-clzero", "-cmpccxadd", "-crc32", "-cx16", "-egpr", "-enqcmd", "-ermsb", "-evex512", "-f16c", "-false-deps-getmant", "-false-deps-lzcnt-tzcnt", "-false-deps-mulc", "-false-deps-mullq", "-false-deps-perm", "-false-deps-popcnt", "-false-deps-range", "-fast-11bytenop", "-fast-15bytenop", "-fast-7bytenop", "-fast-bextr", "-fast-dpwssd", "-fast-gather", "-fast-hops", "-fast-imm16", "-fast-lzcnt", "-fast-movbe", "-fast-scalar-fsqrt", "-fast-scalar-shift-masks", "-fast-shld-rotate", "-fast-variable-crosslane-shuffle", "-fast-variable-perlane-shuffle", "-fast-vector-fsqrt", "-fast-vector-shift-masks", "-faster-shift-than-shuffle", "-fma", "-fma4", "-fsgsbase", "-fsrm", "-gfni", "-harden-sls-ijmp", "-harden-sls-ret", "-hreset", "-idivl-to-divb", "-inline-asm-use-gpr32", "-invpcid", "-kl", "-lea-sp", "-lea-uses-ag", "-lvi-cfi", "-lvi-load-hardening", "-lwp", "-lzcnt", "-movbe", "-movdir64b", "-movdiri", "-movrs", "-mwaitx", "-ndd", "-nf", "-no-bypass-delay", "-no-bypass-delay-blend", "-no-bypass-delay-mov", "-no-bypass-delay-shuffle", "-pad-short-functions", "-pclmul", "-pconfig", "-pku", "-popcnt", "-ppx", "-prefer-128-bit", "-prefer-256-bit", "-prefer-mask-registers", "-prefer-movmsk-over-vtest", "-prefer-no-gather", "-prefer-no-scatter", "-prefetchi", "-prfchw", "-ptwrite", "-push2pop2", "-raoint", "-rdpid", "-rdpru", "-rdrnd", "-rdseed", "-retpoline", "-retpoline-external-thunk", "-retpoline-indirect-branches", "-retpoline-indirect-calls", "-rtm", "-sahf", "-sbb-dep-breaking", "-serialize", "-seses", "-sgx", "-sha", "-sha512", "-shstk", "-slow-lea", "-slow-pmaddwd", "-slow-pmulld", "-slow-shld", "-slow-two-mem-ops", "-slow-unaligned-mem-16", "-slow-unaligned-mem-32", "-sm3", "-sm4", "-soft-float", "-sse", "-sse2", "-sse3", "-sse4.1", "-sse4.2", "-sse4a", "-sse-unaligned-mem", "-ssse3", "-tagged-globals", "-tbm", "-tsxldtrk", "-tuning-fast-imm-vector-shift", "-uintr", "-use-glm-div-sqrt-costs", "-use-slm-arith-costs", "-usermsr", "-vaes", "-vpclmulqdq", "-waitpkg", "-wbnoinvd", "-widekl", "-xop", "-xsave", "-xsavec", "-xsaveopt", "-xsaves", "-zu"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg45: !llvm.ptr):
  %3438 = "llvm.mlir.constant"() <{value = 31 : i64}> : () -> i64
  %3439 = "llvm.mlir.constant"() <{value = 1 : i8}> : () -> i8
  %3440 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %3441 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %3442 = "llvm.mlir.addressof"() <{global_name = @scalar.field_order_s}> : () -> !llvm.ptr
  %3443 = "llvm.mlir.constant"() <{value = 8 : i16}> : () -> i16
  %3444 = "llvm.mlir.constant"() <{value = -1 : i16}> : () -> i16
  %3445 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  "llvm.br"(%3438, %3439, %3440)[^bb1] : (i64, i8, i8) -> ()
^bb1(%3446: i64, %3447: i8, %3448: i8):  // 2 preds: ^bb0, ^bb3
  %3449 = "llvm.getelementptr"(%arg45, %3446) <{elem_type = !llvm.array<32 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: 0, -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %3450 = "llvm.load"(%3449) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3451 = "llvm.zext"(%3450) : (i8) -> i16
  %3452 = "llvm.getelementptr"(%3442, %3446) <{elem_type = !llvm.array<32 x i8>, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: 0, -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %3453 = "llvm.load"(%3452) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3454 = "llvm.zext"(%3453) : (i8) -> i16
  %3455 = "llvm.sub"(%3451, %3454) <{overflowFlags = 1 : i32}> : (i16, i16) -> i16
  %3456 = "llvm.lshr"(%3455, %3443) : (i16, i16) -> i16
  %3457 = "llvm.trunc"(%3456) <{overflowFlags = 2 : i32}> : (i16) -> i8
  %3458 = "llvm.and"(%3447, %3457) : (i8, i8) -> i8
  %3459 = "llvm.or"(%3458, %3448) : (i8, i8) -> i8
  %3460 = "llvm.icmp"(%3446, %3441) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%3460)[^bb2, ^bb3] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb2:  // pred: ^bb1
  %3461 = "llvm.icmp"(%3459, %3440) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %3462 = "llvm.zext"(%3461) : (i1) -> i16
  "llvm.return"(%3462) : (i16) -> ()
^bb3:  // pred: ^bb1
  %3463 = "llvm.xor"(%3454, %3451) : (i16, i16) -> i16
  %3464 = "llvm.add"(%3463, %3444) <{overflowFlags = 1 : i32}> : (i16, i16) -> i16
  %3465 = "llvm.lshr"(%3464, %3443) : (i16, i16) -> i16
  %3466 = "llvm.trunc"(%3465) <{overflowFlags = 2 : i32}> : (i16) -> i8
  %3467 = "llvm.and"(%3447, %3466) : (i8, i8) -> i8
  %3468 = "llvm.add"(%3446, %3445) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  "llvm.br"(%3468, %3467, %3459)[^bb1] : (i64, i8, i8) -> ()
}) : () -> ()
  with @scalar.field_order_s := scalar_field_order_s

end

end MLIR.Zig
