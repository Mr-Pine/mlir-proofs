module

-- zig-build/out/op/Fe.sub.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Zig

@[expose] public section

mlir_def Fe_sub :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.noalias, llvm.nocapture, llvm.nonnull, llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>, llvm.writeonly}, {llvm.align = 8 : i64, llvm.nocapture, llvm.nonnull, llvm.readonly}, {llvm.align = 8 : i64, llvm.nocapture, llvm.nonnull, llvm.readonly}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, minsize, no_unwind, optsize, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["target-cpu", "x86-64"]], sym_name = "Fe.sub", target_cpu = "x86-64", target_features = #llvm.target_features<["+64bit", "+cmov", "+cx8", "+fxsr", "+idivq-to-divl", "+macrofusion", "+mmx", "+nopl", "+slow-3ops-lea", "+slow-incdec", "+vzeroupper", "+x87", "-16bit-mode", "-32bit-mode", "-adx", "-aes", "-allow-light-256-bit", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tf32", "-amx-tile", "-amx-transpose", "-avx", "-avx10.1-256", "-avx10.1-512", "-avx10.2-256", "-avx10.2-512", "-avx2", "-avx512bf16", "-avx512bitalg", "-avx512bw", "-avx512cd", "-avx512dq", "-avx512f", "-avx512fp16", "-avx512ifma", "-avx512vbmi", "-avx512vbmi2", "-avx512vl", "-avx512vnni", "-avx512vp2intersect", "-avx512vpopcntdq", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-bmi", "-bmi2", "-branch-hint", "-branchfusion", "-ccmp", "-cf", "-cldemote", "-clflushopt", "-clwb", "-clzero", "-cmpccxadd", "-crc32", "-cx16", "-egpr", "-enqcmd", "-ermsb", "-evex512", "-f16c", "-false-deps-getmant", "-false-deps-lzcnt-tzcnt", "-false-deps-mulc", "-false-deps-mullq", "-false-deps-perm", "-false-deps-popcnt", "-false-deps-range", "-fast-11bytenop", "-fast-15bytenop", "-fast-7bytenop", "-fast-bextr", "-fast-dpwssd", "-fast-gather", "-fast-hops", "-fast-imm16", "-fast-lzcnt", "-fast-movbe", "-fast-scalar-fsqrt", "-fast-scalar-shift-masks", "-fast-shld-rotate", "-fast-variable-crosslane-shuffle", "-fast-variable-perlane-shuffle", "-fast-vector-fsqrt", "-fast-vector-shift-masks", "-faster-shift-than-shuffle", "-fma", "-fma4", "-fsgsbase", "-fsrm", "-gfni", "-harden-sls-ijmp", "-harden-sls-ret", "-hreset", "-idivl-to-divb", "-inline-asm-use-gpr32", "-invpcid", "-kl", "-lea-sp", "-lea-uses-ag", "-lvi-cfi", "-lvi-load-hardening", "-lwp", "-lzcnt", "-movbe", "-movdir64b", "-movdiri", "-movrs", "-mwaitx", "-ndd", "-nf", "-no-bypass-delay", "-no-bypass-delay-blend", "-no-bypass-delay-mov", "-no-bypass-delay-shuffle", "-pad-short-functions", "-pclmul", "-pconfig", "-pku", "-popcnt", "-ppx", "-prefer-128-bit", "-prefer-256-bit", "-prefer-mask-registers", "-prefer-movmsk-over-vtest", "-prefer-no-gather", "-prefer-no-scatter", "-prefetchi", "-prfchw", "-ptwrite", "-push2pop2", "-raoint", "-rdpid", "-rdpru", "-rdrnd", "-rdseed", "-retpoline", "-retpoline-external-thunk", "-retpoline-indirect-branches", "-retpoline-indirect-calls", "-rtm", "-sahf", "-sbb-dep-breaking", "-serialize", "-seses", "-sgx", "-sha", "-sha512", "-shstk", "-slow-lea", "-slow-pmaddwd", "-slow-pmulld", "-slow-shld", "-slow-two-mem-ops", "-slow-unaligned-mem-16", "-slow-unaligned-mem-32", "-sm3", "-sm4", "-soft-float", "-sse", "-sse2", "-sse3", "-sse4.1", "-sse4.2", "-sse4a", "-sse-unaligned-mem", "-ssse3", "-tagged-globals", "-tbm", "-tsxldtrk", "-tuning-fast-imm-vector-shift", "-uintr", "-use-glm-div-sqrt-costs", "-use-slm-arith-costs", "-usermsr", "-vaes", "-vpclmulqdq", "-waitpkg", "-wbnoinvd", "-widekl", "-xop", "-xsave", "-xsavec", "-xsaveopt", "-xsaves", "-zu"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg13: !llvm.ptr, %arg14: !llvm.ptr, %arg15: !llvm.ptr):
  %310 = "llvm.mlir.constant"() <{value = 51 : i64}> : () -> i64
  %311 = "llvm.mlir.constant"() <{value = 2251799813685247 : i64}> : () -> i64
  %312 = "llvm.mlir.constant"() <{value = -19 : i64}> : () -> i64
  %313 = "llvm.mlir.constant"() <{value = 4503599627370458 : i64}> : () -> i64
  %314 = "llvm.mlir.constant"() <{value = 4503599627370494 : i64}> : () -> i64
  %315 = "llvm.load"(%arg15) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %316 = "llvm.getelementptr"(%arg15) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %317 = "llvm.load"(%316) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %318 = "llvm.getelementptr"(%arg15) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %319 = "llvm.load"(%318) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %320 = "llvm.getelementptr"(%arg15) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %321 = "llvm.load"(%320) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %322 = "llvm.getelementptr"(%arg15) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %323 = "llvm.load"(%322) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %324 = "llvm.lshr"(%315, %310) : (i64, i64) -> i64
  %325 = "llvm.add"(%317, %324) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %326 = "llvm.and"(%315, %311) : (i64, i64) -> i64
  %327 = "llvm.lshr"(%325, %310) : (i64, i64) -> i64
  %328 = "llvm.add"(%327, %319) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %329 = "llvm.and"(%325, %311) : (i64, i64) -> i64
  %330 = "llvm.lshr"(%328, %310) : (i64, i64) -> i64
  %331 = "llvm.add"(%330, %321) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %332 = "llvm.and"(%328, %311) : (i64, i64) -> i64
  %333 = "llvm.lshr"(%331, %310) : (i64, i64) -> i64
  %334 = "llvm.add"(%333, %323) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %335 = "llvm.and"(%331, %311) : (i64, i64) -> i64
  %336 = "llvm.lshr"(%334, %310) : (i64, i64) -> i64
  %337 = "llvm.and"(%334, %311) : (i64, i64) -> i64
  %338 = "llvm.load"(%arg14) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %339 = "llvm.mul"(%336, %312) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %340 = "llvm.sub"(%338, %326) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %341 = "llvm.add"(%340, %313) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %342 = "llvm.add"(%341, %339) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %343 = "llvm.getelementptr"(%arg14) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %344 = "llvm.load"(%343) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %345 = "llvm.sub"(%344, %329) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %346 = "llvm.add"(%345, %314) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %347 = "llvm.getelementptr"(%arg14) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %348 = "llvm.load"(%347) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %349 = "llvm.sub"(%348, %332) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %350 = "llvm.add"(%349, %314) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %351 = "llvm.getelementptr"(%arg14) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %352 = "llvm.load"(%351) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %353 = "llvm.sub"(%352, %335) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %354 = "llvm.add"(%353, %314) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %355 = "llvm.getelementptr"(%arg14) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %356 = "llvm.load"(%355) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %357 = "llvm.add"(%356, %314) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %358 = "llvm.sub"(%357, %337) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  "llvm.store"(%342, %arg13) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %359 = "llvm.getelementptr"(%arg13) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%346, %359) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %360 = "llvm.getelementptr"(%arg13) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%350, %360) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %361 = "llvm.getelementptr"(%arg13) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%354, %361) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %362 = "llvm.getelementptr"(%arg13) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%358, %362) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end MLIR.Zig
