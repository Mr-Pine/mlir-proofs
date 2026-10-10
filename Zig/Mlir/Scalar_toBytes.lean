module

-- zig-build/out/op/Scalar.toBytes.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Zig

@[expose] public section

mlir_def Scalar_toBytes :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.noalias, llvm.nocapture, llvm.nonnull, llvm.sret = !llvm.array<32 x i8>, llvm.writeonly}, {llvm.align = 8 : i64, llvm.nocapture, llvm.nonnull, llvm.readonly}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = write, errnoMem = none, targetMem0 = none, targetMem1 = none>, minsize, no_unwind, optsize, passthrough = ["nofree", "norecurse", "nosync", ["target-cpu", "x86-64"]], sym_name = "Scalar.toBytes", target_cpu = "x86-64", target_features = #llvm.target_features<["+64bit", "+cmov", "+cx8", "+fxsr", "+idivq-to-divl", "+macrofusion", "+mmx", "+nopl", "+slow-3ops-lea", "+slow-incdec", "+vzeroupper", "+x87", "-16bit-mode", "-32bit-mode", "-adx", "-aes", "-allow-light-256-bit", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tf32", "-amx-tile", "-amx-transpose", "-avx", "-avx10.1-256", "-avx10.1-512", "-avx10.2-256", "-avx10.2-512", "-avx2", "-avx512bf16", "-avx512bitalg", "-avx512bw", "-avx512cd", "-avx512dq", "-avx512f", "-avx512fp16", "-avx512ifma", "-avx512vbmi", "-avx512vbmi2", "-avx512vl", "-avx512vnni", "-avx512vp2intersect", "-avx512vpopcntdq", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-bmi", "-bmi2", "-branch-hint", "-branchfusion", "-ccmp", "-cf", "-cldemote", "-clflushopt", "-clwb", "-clzero", "-cmpccxadd", "-crc32", "-cx16", "-egpr", "-enqcmd", "-ermsb", "-evex512", "-f16c", "-false-deps-getmant", "-false-deps-lzcnt-tzcnt", "-false-deps-mulc", "-false-deps-mullq", "-false-deps-perm", "-false-deps-popcnt", "-false-deps-range", "-fast-11bytenop", "-fast-15bytenop", "-fast-7bytenop", "-fast-bextr", "-fast-dpwssd", "-fast-gather", "-fast-hops", "-fast-imm16", "-fast-lzcnt", "-fast-movbe", "-fast-scalar-fsqrt", "-fast-scalar-shift-masks", "-fast-shld-rotate", "-fast-variable-crosslane-shuffle", "-fast-variable-perlane-shuffle", "-fast-vector-fsqrt", "-fast-vector-shift-masks", "-faster-shift-than-shuffle", "-fma", "-fma4", "-fsgsbase", "-fsrm", "-gfni", "-harden-sls-ijmp", "-harden-sls-ret", "-hreset", "-idivl-to-divb", "-inline-asm-use-gpr32", "-invpcid", "-kl", "-lea-sp", "-lea-uses-ag", "-lvi-cfi", "-lvi-load-hardening", "-lwp", "-lzcnt", "-movbe", "-movdir64b", "-movdiri", "-movrs", "-mwaitx", "-ndd", "-nf", "-no-bypass-delay", "-no-bypass-delay-blend", "-no-bypass-delay-mov", "-no-bypass-delay-shuffle", "-pad-short-functions", "-pclmul", "-pconfig", "-pku", "-popcnt", "-ppx", "-prefer-128-bit", "-prefer-256-bit", "-prefer-mask-registers", "-prefer-movmsk-over-vtest", "-prefer-no-gather", "-prefer-no-scatter", "-prefetchi", "-prfchw", "-ptwrite", "-push2pop2", "-raoint", "-rdpid", "-rdpru", "-rdrnd", "-rdseed", "-retpoline", "-retpoline-external-thunk", "-retpoline-indirect-branches", "-retpoline-indirect-calls", "-rtm", "-sahf", "-sbb-dep-breaking", "-serialize", "-seses", "-sgx", "-sha", "-sha512", "-shstk", "-slow-lea", "-slow-pmaddwd", "-slow-pmulld", "-slow-shld", "-slow-two-mem-ops", "-slow-unaligned-mem-16", "-slow-unaligned-mem-32", "-sm3", "-sm4", "-soft-float", "-sse", "-sse2", "-sse3", "-sse4.1", "-sse4.2", "-sse4a", "-sse-unaligned-mem", "-ssse3", "-tagged-globals", "-tbm", "-tsxldtrk", "-tuning-fast-imm-vector-shift", "-uintr", "-use-glm-div-sqrt-costs", "-use-slm-arith-costs", "-usermsr", "-vaes", "-vpclmulqdq", "-waitpkg", "-wbnoinvd", "-widekl", "-xop", "-xsave", "-xsavec", "-xsaveopt", "-xsaves", "-zu"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg33: !llvm.ptr, %arg34: !llvm.ptr):
  %800 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %801 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %802 = "llvm.mlir.constant"() <{value = 4 : i64}> : () -> i64
  %803 = "llvm.mlir.constant"() <{value = 7 : i64}> : () -> i64
  %804 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %805 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %806 = "llvm.mlir.constant"() <{value = 4294967296 : i64}> : () -> i64
  %807 = "llvm.alloca"(%800) <{alignment = 1 : i64, elem_type = !llvm.array<32 x i8>}> : (i32) -> !llvm.ptr
  "llvm.br"(%801)[^bb1] : (i64) -> ()
^bb1(%808: i64):  // 2 preds: ^bb0, ^bb2
  %809 = "llvm.icmp"(%808, %802) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%809)[^bb3, ^bb2] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb2:  // pred: ^bb1
  %810 = "llvm.mul"(%808, %803) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %811 = "llvm.getelementptr"(%807, %810) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %812 = "llvm.getelementptr"(%arg34, %808) <{elem_type = !llvm.array<5 x i64>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 0, -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %813 = "llvm.load"(%812) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  "llvm.store"(%813, %811) <{alignment = 1 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %814 = "llvm.add"(%808, %804) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  "llvm.br"(%814)[^bb1] : (i64) -> ()
^bb3:  // pred: ^bb1
  %815 = "llvm.getelementptr"(%807) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 28>}> : (!llvm.ptr) -> !llvm.ptr
  %816 = "llvm.getelementptr"(%arg34) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %817 = "llvm.load"(%816) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %818 = "llvm.icmp"(%817, %806) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.intr.assume"(%818) <{op_bundle_sizes = array<i32>}> : (i1) -> ()
  %819 = "llvm.trunc"(%817) <{overflowFlags = 2 : i32}> : (i64) -> i32
  "llvm.store"(%819, %815) <{alignment = 1 : i64, ordering = 0 : i64}> : (i32, !llvm.ptr) -> ()
  "llvm.intr.memcpy"(%arg33, %807, %805) <{arg_attrs = [{llvm.align = 1 : i64, llvm.dereferenceable = 32 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 1 : i64, llvm.dereferenceable = 32 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end MLIR.Zig
