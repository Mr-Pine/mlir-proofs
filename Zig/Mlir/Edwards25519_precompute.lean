module

-- zig-build/out/op/Edwards25519.precompute.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Zig.Mlir.Edwards25519_add
public import Zig.Mlir.Edwards25519_dbl
public import Zig.Mlir.Edwards25519_identityElement

meta import MLIR.Semantics.Func
meta import Zig.Mlir.Edwards25519_add
meta import Zig.Mlir.Edwards25519_dbl
meta import Zig.Mlir.Edwards25519_identityElement

namespace MLIR.Zig

@[expose] public section

mlir_def Edwards25519_precompute :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.noalias, llvm.nocapture, llvm.nonnull, llvm.sret = !llvm.array<9 x struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>>, llvm.writeonly}, {llvm.align = 8 : i64, llvm.nocapture, llvm.nonnull, llvm.readonly}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, minsize, no_inline, no_unwind, optsize, passthrough = ["nofree", "norecurse", "nosync", ["target-cpu", "x86-64"]], sym_name = "Edwards25519.precompute", target_cpu = "x86-64", target_features = #llvm.target_features<["+64bit", "+cmov", "+cx8", "+fxsr", "+idivq-to-divl", "+macrofusion", "+mmx", "+nopl", "+slow-3ops-lea", "+slow-incdec", "+vzeroupper", "+x87", "-16bit-mode", "-32bit-mode", "-adx", "-aes", "-allow-light-256-bit", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tf32", "-amx-tile", "-amx-transpose", "-avx", "-avx10.1-256", "-avx10.1-512", "-avx10.2-256", "-avx10.2-512", "-avx2", "-avx512bf16", "-avx512bitalg", "-avx512bw", "-avx512cd", "-avx512dq", "-avx512f", "-avx512fp16", "-avx512ifma", "-avx512vbmi", "-avx512vbmi2", "-avx512vl", "-avx512vnni", "-avx512vp2intersect", "-avx512vpopcntdq", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-bmi", "-bmi2", "-branch-hint", "-branchfusion", "-ccmp", "-cf", "-cldemote", "-clflushopt", "-clwb", "-clzero", "-cmpccxadd", "-crc32", "-cx16", "-egpr", "-enqcmd", "-ermsb", "-evex512", "-f16c", "-false-deps-getmant", "-false-deps-lzcnt-tzcnt", "-false-deps-mulc", "-false-deps-mullq", "-false-deps-perm", "-false-deps-popcnt", "-false-deps-range", "-fast-11bytenop", "-fast-15bytenop", "-fast-7bytenop", "-fast-bextr", "-fast-dpwssd", "-fast-gather", "-fast-hops", "-fast-imm16", "-fast-lzcnt", "-fast-movbe", "-fast-scalar-fsqrt", "-fast-scalar-shift-masks", "-fast-shld-rotate", "-fast-variable-crosslane-shuffle", "-fast-variable-perlane-shuffle", "-fast-vector-fsqrt", "-fast-vector-shift-masks", "-faster-shift-than-shuffle", "-fma", "-fma4", "-fsgsbase", "-fsrm", "-gfni", "-harden-sls-ijmp", "-harden-sls-ret", "-hreset", "-idivl-to-divb", "-inline-asm-use-gpr32", "-invpcid", "-kl", "-lea-sp", "-lea-uses-ag", "-lvi-cfi", "-lvi-load-hardening", "-lwp", "-lzcnt", "-movbe", "-movdir64b", "-movdiri", "-movrs", "-mwaitx", "-ndd", "-nf", "-no-bypass-delay", "-no-bypass-delay-blend", "-no-bypass-delay-mov", "-no-bypass-delay-shuffle", "-pad-short-functions", "-pclmul", "-pconfig", "-pku", "-popcnt", "-ppx", "-prefer-128-bit", "-prefer-256-bit", "-prefer-mask-registers", "-prefer-movmsk-over-vtest", "-prefer-no-gather", "-prefer-no-scatter", "-prefetchi", "-prfchw", "-ptwrite", "-push2pop2", "-raoint", "-rdpid", "-rdpru", "-rdrnd", "-rdseed", "-retpoline", "-retpoline-external-thunk", "-retpoline-indirect-branches", "-retpoline-indirect-calls", "-rtm", "-sahf", "-sbb-dep-breaking", "-serialize", "-seses", "-sgx", "-sha", "-sha512", "-shstk", "-slow-lea", "-slow-pmaddwd", "-slow-pmulld", "-slow-shld", "-slow-two-mem-ops", "-slow-unaligned-mem-16", "-slow-unaligned-mem-32", "-sm3", "-sm4", "-soft-float", "-sse", "-sse2", "-sse3", "-sse4.1", "-sse4.2", "-sse4a", "-sse-unaligned-mem", "-ssse3", "-tagged-globals", "-tbm", "-tsxldtrk", "-tuning-fast-imm-vector-shift", "-uintr", "-use-glm-div-sqrt-costs", "-use-slm-arith-costs", "-usermsr", "-vaes", "-vpclmulqdq", "-waitpkg", "-wbnoinvd", "-widekl", "-xop", "-xsave", "-xsavec", "-xsaveopt", "-xsaves", "-zu"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg27: !llvm.ptr, %arg28: !llvm.ptr):
  %663 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %664 = "llvm.mlir.addressof"() <{global_name = @Edwards25519.identityElement}> : () -> !llvm.ptr
  %665 = "llvm.mlir.constant"() <{value = 168 : i64}> : () -> i64
  %666 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %667 = "llvm.mlir.constant"() <{value = 9 : i64}> : () -> i64
  %668 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %669 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %670 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %671 = "llvm.mlir.constant"() <{value = 1512 : i64}> : () -> i64
  %672 = "llvm.alloca"(%663) <{alignment = 8 : i64, elem_type = !llvm.struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>}> : (i32) -> !llvm.ptr
  %673 = "llvm.alloca"(%663) <{alignment = 8 : i64, elem_type = !llvm.struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>}> : (i32) -> !llvm.ptr
  %674 = "llvm.alloca"(%663) <{alignment = 8 : i64, elem_type = !llvm.array<9 x struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>>}> : (i32) -> !llvm.ptr
  "llvm.intr.memcpy"(%674, %664, %665) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 168 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 168 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %675 = "llvm.getelementptr"(%674) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 168>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memcpy"(%675, %arg28, %665) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 168 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 168 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.br"(%666)[^bb1] : (i64) -> ()
^bb1(%676: i64):  // 2 preds: ^bb0, ^bb4
  %677 = "llvm.icmp"(%676, %667) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%677)[^bb3, ^bb2] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb2:  // pred: ^bb1
  %678 = "llvm.getelementptr"(%674, %676) <{elem_type = !llvm.array<9 x struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 0, -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %679 = "llvm.and"(%676, %669) : (i64, i64) -> i64
  %680 = "llvm.icmp"(%679, %668) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%680)[^bb5, ^bb6] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb3:  // pred: ^bb1
  "llvm.intr.memcpy"(%arg27, %674, %671) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 1512 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 1512 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.return"() : () -> ()
^bb4(%681: !llvm.ptr):  // 2 preds: ^bb5, ^bb6
  "llvm.intr.memcpy"(%678, %681, %665) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 168 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 168 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %682 = "llvm.add"(%676, %669) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  "llvm.br"(%682)[^bb1] : (i64) -> ()
^bb5:  // pred: ^bb2
  %683 = "llvm.lshr"(%676, %669) <{isExact}> : (i64, i64) -> i64
  %684 = "llvm.getelementptr"(%674, %683) <{elem_type = !llvm.array<9 x struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 0, -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.call"(%673, %684) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Edwards25519.dbl, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.br"(%673)[^bb4] : (!llvm.ptr) -> ()
^bb6:  // pred: ^bb2
  %685 = "llvm.add"(%676, %670) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %686 = "llvm.getelementptr"(%674, %685) <{elem_type = !llvm.array<9 x struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 0, -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.call"(%672, %686, %arg28) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Edwards25519.add, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.br"(%672)[^bb4] : (!llvm.ptr) -> ()
}) : () -> ()
  with @Edwards25519.add := Edwards25519_add, @Edwards25519.dbl := Edwards25519_dbl,
    @Edwards25519.identityElement := Edwards25519_identityElement

end

end MLIR.Zig
