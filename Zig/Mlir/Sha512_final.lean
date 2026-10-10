module

-- zig-build/out/op/Sha512.final.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Zig.Mlir.Sha512_round

meta import MLIR.Semantics.Func
meta import Zig.Mlir.Sha512_round

namespace MLIR.Zig

@[expose] public section

noncomputable mlir_def Sha512_final :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 16 : i64, llvm.nocapture, llvm.nonnull}, {llvm.align = 1 : i64, llvm.nocapture, llvm.nonnull, llvm.writeonly}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, minsize, no_inline, no_unwind, optsize, passthrough = ["nofree", "norecurse", "nosync", ["target-cpu", "x86-64"]], sym_name = "Sha512.final", target_cpu = "x86-64", target_features = #llvm.target_features<["+64bit", "+cmov", "+cx8", "+fxsr", "+idivq-to-divl", "+macrofusion", "+mmx", "+nopl", "+slow-3ops-lea", "+slow-incdec", "+vzeroupper", "+x87", "-16bit-mode", "-32bit-mode", "-adx", "-aes", "-allow-light-256-bit", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tf32", "-amx-tile", "-amx-transpose", "-avx", "-avx10.1-256", "-avx10.1-512", "-avx10.2-256", "-avx10.2-512", "-avx2", "-avx512bf16", "-avx512bitalg", "-avx512bw", "-avx512cd", "-avx512dq", "-avx512f", "-avx512fp16", "-avx512ifma", "-avx512vbmi", "-avx512vbmi2", "-avx512vl", "-avx512vnni", "-avx512vp2intersect", "-avx512vpopcntdq", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-bmi", "-bmi2", "-branch-hint", "-branchfusion", "-ccmp", "-cf", "-cldemote", "-clflushopt", "-clwb", "-clzero", "-cmpccxadd", "-crc32", "-cx16", "-egpr", "-enqcmd", "-ermsb", "-evex512", "-f16c", "-false-deps-getmant", "-false-deps-lzcnt-tzcnt", "-false-deps-mulc", "-false-deps-mullq", "-false-deps-perm", "-false-deps-popcnt", "-false-deps-range", "-fast-11bytenop", "-fast-15bytenop", "-fast-7bytenop", "-fast-bextr", "-fast-dpwssd", "-fast-gather", "-fast-hops", "-fast-imm16", "-fast-lzcnt", "-fast-movbe", "-fast-scalar-fsqrt", "-fast-scalar-shift-masks", "-fast-shld-rotate", "-fast-variable-crosslane-shuffle", "-fast-variable-perlane-shuffle", "-fast-vector-fsqrt", "-fast-vector-shift-masks", "-faster-shift-than-shuffle", "-fma", "-fma4", "-fsgsbase", "-fsrm", "-gfni", "-harden-sls-ijmp", "-harden-sls-ret", "-hreset", "-idivl-to-divb", "-inline-asm-use-gpr32", "-invpcid", "-kl", "-lea-sp", "-lea-uses-ag", "-lvi-cfi", "-lvi-load-hardening", "-lwp", "-lzcnt", "-movbe", "-movdir64b", "-movdiri", "-movrs", "-mwaitx", "-ndd", "-nf", "-no-bypass-delay", "-no-bypass-delay-blend", "-no-bypass-delay-mov", "-no-bypass-delay-shuffle", "-pad-short-functions", "-pclmul", "-pconfig", "-pku", "-popcnt", "-ppx", "-prefer-128-bit", "-prefer-256-bit", "-prefer-mask-registers", "-prefer-movmsk-over-vtest", "-prefer-no-gather", "-prefer-no-scatter", "-prefetchi", "-prfchw", "-ptwrite", "-push2pop2", "-raoint", "-rdpid", "-rdpru", "-rdrnd", "-rdseed", "-retpoline", "-retpoline-external-thunk", "-retpoline-indirect-branches", "-retpoline-indirect-calls", "-rtm", "-sahf", "-sbb-dep-breaking", "-serialize", "-seses", "-sgx", "-sha", "-sha512", "-shstk", "-slow-lea", "-slow-pmaddwd", "-slow-pmulld", "-slow-shld", "-slow-two-mem-ops", "-slow-unaligned-mem-16", "-slow-unaligned-mem-32", "-sm3", "-sm4", "-soft-float", "-sse", "-sse2", "-sse3", "-sse4.1", "-sse4.2", "-sse4a", "-sse-unaligned-mem", "-ssse3", "-tagged-globals", "-tbm", "-tsxldtrk", "-tuning-fast-imm-vector-shift", "-uintr", "-use-glm-div-sqrt-costs", "-use-slm-arith-costs", "-usermsr", "-vaes", "-vpclmulqdq", "-waitpkg", "-wbnoinvd", "-widekl", "-xop", "-xsave", "-xsavec", "-xsaveopt", "-xsaves", "-zu"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg62: !llvm.ptr, %arg63: !llvm.ptr):
  %3844 = "llvm.mlir.constant"() <{value = 128 : i64}> : () -> i64
  %3845 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %3846 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %3847 = "llvm.mlir.constant"() <{value = -128 : i8}> : () -> i8
  %3848 = "llvm.mlir.constant"() <{value = 1 : i8}> : () -> i8
  %3849 = "llvm.mlir.constant"() <{value = 111 : i8}> : () -> i8
  %3850 = "llvm.mlir.constant"() <{value = 5 : i128}> : () -> i128
  %3851 = "llvm.mlir.constant"() <{value = 3 : i8}> : () -> i8
  %3852 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %3853 = "llvm.mlir.constant"() <{value = 16 : i64}> : () -> i64
  %3854 = "llvm.mlir.constant"() <{value = 127 : i64}> : () -> i64
  %3855 = "llvm.mlir.constant"() <{value = 8 : i128}> : () -> i128
  %3856 = "llvm.mlir.constant"() <{value = 8 : i64}> : () -> i64
  %3857 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %3858 = "llvm.getelementptr"(%arg62) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 80>}> : (!llvm.ptr) -> !llvm.ptr
  %3859 = "llvm.getelementptr"(%arg62) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 208>}> : (!llvm.ptr) -> !llvm.ptr
  %3860 = "llvm.load"(%3859) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3861 = "llvm.zext"(%3860) : (i8) -> i64
  %3862 = "llvm.getelementptr"(%3858, %3861) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %3863 = "llvm.sub"(%3844, %3861) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  "llvm.intr.memset"(%3862, %3845, %3863) <{arg_attrs = [{llvm.align = 1 : i64, llvm.nonnull}, {}, {}], isVolatile = false}> : (!llvm.ptr, i8, i64) -> ()
  %3864 = "llvm.load"(%3859) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3865 = "llvm.zext"(%3864) : (i8) -> i64
  %3866 = "llvm.getelementptr"(%3858, %3865) <{elem_type = !llvm.array<128 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 0, -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%3847, %3866) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %3867 = "llvm.load"(%3859) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3868 = "llvm.add"(%3867, %3848) <{overflowFlags = 2 : i32}> : (i8, i8) -> i8
  "llvm.store"(%3868, %3859) <{alignment = 16 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %3869 = "llvm.icmp"(%3867, %3849) <{predicate = 8 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%3869)[^bb2, ^bb1] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb1:  // 2 preds: ^bb0, ^bb2
  %3870 = "llvm.load"(%arg62) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i128
  %3871 = "llvm.lshr"(%3870, %3850) : (i128, i128) -> i128
  %3872 = "llvm.getelementptr"(%arg62) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 207>}> : (!llvm.ptr) -> !llvm.ptr
  %3873 = "llvm.trunc"(%3870) <{overflowFlags = 0 : i32}> : (i128) -> i8
  %3874 = "llvm.shl"(%3873, %3851) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  "llvm.store"(%3874, %3872) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.br"(%3852, %3871)[^bb3] : (i64, i128) -> ()
^bb2:  // pred: ^bb0
  "llvm.call"(%arg62, %3858) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.align = 16 : i64, llvm.nonnull}, {llvm.align = 1 : i64, llvm.nonnull, llvm.readonly}], callee = @Sha512.round, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.memset"(%3858, %3845, %3844) <{arg_attrs = [{llvm.align = 16 : i64, llvm.dereferenceable = 128 : i64, llvm.nonnull, llvm.noundef}, {}, {}], isVolatile = false}> : (!llvm.ptr, i8, i64) -> ()
  "llvm.br"()[^bb1] : () -> ()
^bb3(%3875: i64, %3876: i128):  // 2 preds: ^bb1, ^bb4
  %3877 = "llvm.icmp"(%3875, %3853) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%3877)[^bb5, ^bb4] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb4:  // pred: ^bb3
  %3878 = "llvm.sub"(%3854, %3875) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %3879 = "llvm.getelementptr"(%3858, %3878) <{elem_type = !llvm.array<128 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 0, -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %3880 = "llvm.trunc"(%3876) <{overflowFlags = 0 : i32}> : (i128) -> i8
  "llvm.store"(%3880, %3879) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %3881 = "llvm.lshr"(%3876, %3855) : (i128, i128) -> i128
  %3882 = "llvm.add"(%3875, %3852) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  "llvm.br"(%3882, %3881)[^bb3] : (i64, i128) -> ()
^bb5:  // pred: ^bb3
  "llvm.call"(%arg62, %3858) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.align = 16 : i64, llvm.nonnull}, {llvm.align = 1 : i64, llvm.nonnull, llvm.readonly}], callee = @Sha512.round, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %3883 = "llvm.getelementptr"(%arg62) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.br"(%3846)[^bb6] : (i64) -> ()
^bb6(%3884: i64):  // 2 preds: ^bb5, ^bb7
  %3885 = "llvm.icmp"(%3884, %3856) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%3885)[^bb8, ^bb7] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb7:  // pred: ^bb6
  %3886 = "llvm.getelementptr"(%3883, %3884) <{elem_type = !llvm.array<8 x i64>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 0, -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %3887 = "llvm.load"(%3886) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3888 = "llvm.shl"(%3884, %3857) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %3889 = "llvm.getelementptr"(%arg63, %3888) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %3890 = "llvm.intr.bswap"(%3887) : (i64) -> i64
  "llvm.store"(%3890, %3889) <{alignment = 1 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %3891 = "llvm.add"(%3884, %3852) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  "llvm.br"(%3891)[^bb6] : (i64) -> ()
^bb8:  // pred: ^bb6
  "llvm.return"() : () -> ()
}) : () -> ()
  with @Sha512.round := Sha512_round

end

end MLIR.Zig
