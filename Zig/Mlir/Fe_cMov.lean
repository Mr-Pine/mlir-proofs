module

-- zig-build/out/op/Fe.cMov.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Zig

@[expose] public section

mlir_def Fe_cMov :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 8 : i64, llvm.nocapture, llvm.nonnull}, {llvm.align = 8 : i64, llvm.nocapture, llvm.nonnull, llvm.readonly}, {llvm.range = #llvm.constant_range<i64, 0, 2>}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr, i64)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, minsize, no_unwind, optsize, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["target-cpu", "x86-64"]], sym_name = "Fe.cMov", target_cpu = "x86-64", target_features = #llvm.target_features<["+64bit", "+cmov", "+cx8", "+fxsr", "+idivq-to-divl", "+macrofusion", "+mmx", "+nopl", "+slow-3ops-lea", "+slow-incdec", "+vzeroupper", "+x87", "-16bit-mode", "-32bit-mode", "-adx", "-aes", "-allow-light-256-bit", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tf32", "-amx-tile", "-amx-transpose", "-avx", "-avx10.1-256", "-avx10.1-512", "-avx10.2-256", "-avx10.2-512", "-avx2", "-avx512bf16", "-avx512bitalg", "-avx512bw", "-avx512cd", "-avx512dq", "-avx512f", "-avx512fp16", "-avx512ifma", "-avx512vbmi", "-avx512vbmi2", "-avx512vl", "-avx512vnni", "-avx512vp2intersect", "-avx512vpopcntdq", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-bmi", "-bmi2", "-branch-hint", "-branchfusion", "-ccmp", "-cf", "-cldemote", "-clflushopt", "-clwb", "-clzero", "-cmpccxadd", "-crc32", "-cx16", "-egpr", "-enqcmd", "-ermsb", "-evex512", "-f16c", "-false-deps-getmant", "-false-deps-lzcnt-tzcnt", "-false-deps-mulc", "-false-deps-mullq", "-false-deps-perm", "-false-deps-popcnt", "-false-deps-range", "-fast-11bytenop", "-fast-15bytenop", "-fast-7bytenop", "-fast-bextr", "-fast-dpwssd", "-fast-gather", "-fast-hops", "-fast-imm16", "-fast-lzcnt", "-fast-movbe", "-fast-scalar-fsqrt", "-fast-scalar-shift-masks", "-fast-shld-rotate", "-fast-variable-crosslane-shuffle", "-fast-variable-perlane-shuffle", "-fast-vector-fsqrt", "-fast-vector-shift-masks", "-faster-shift-than-shuffle", "-fma", "-fma4", "-fsgsbase", "-fsrm", "-gfni", "-harden-sls-ijmp", "-harden-sls-ret", "-hreset", "-idivl-to-divb", "-inline-asm-use-gpr32", "-invpcid", "-kl", "-lea-sp", "-lea-uses-ag", "-lvi-cfi", "-lvi-load-hardening", "-lwp", "-lzcnt", "-movbe", "-movdir64b", "-movdiri", "-movrs", "-mwaitx", "-ndd", "-nf", "-no-bypass-delay", "-no-bypass-delay-blend", "-no-bypass-delay-mov", "-no-bypass-delay-shuffle", "-pad-short-functions", "-pclmul", "-pconfig", "-pku", "-popcnt", "-ppx", "-prefer-128-bit", "-prefer-256-bit", "-prefer-mask-registers", "-prefer-movmsk-over-vtest", "-prefer-no-gather", "-prefer-no-scatter", "-prefetchi", "-prfchw", "-ptwrite", "-push2pop2", "-raoint", "-rdpid", "-rdpru", "-rdrnd", "-rdseed", "-retpoline", "-retpoline-external-thunk", "-retpoline-indirect-branches", "-retpoline-indirect-calls", "-rtm", "-sahf", "-sbb-dep-breaking", "-serialize", "-seses", "-sgx", "-sha", "-sha512", "-shstk", "-slow-lea", "-slow-pmaddwd", "-slow-pmulld", "-slow-shld", "-slow-two-mem-ops", "-slow-unaligned-mem-16", "-slow-unaligned-mem-32", "-sm3", "-sm4", "-soft-float", "-sse", "-sse2", "-sse3", "-sse4.1", "-sse4.2", "-sse4a", "-sse-unaligned-mem", "-ssse3", "-tagged-globals", "-tbm", "-tsxldtrk", "-tuning-fast-imm-vector-shift", "-uintr", "-use-glm-div-sqrt-costs", "-use-slm-arith-costs", "-usermsr", "-vaes", "-vpclmulqdq", "-waitpkg", "-wbnoinvd", "-widekl", "-xop", "-xsave", "-xsavec", "-xsaveopt", "-xsaves", "-zu"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg7: !llvm.ptr, %arg8: !llvm.ptr, %arg9: i64):
  %248 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %249 = "llvm.sub"(%248, %arg9) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %250 = "llvm.load"(%arg7) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %251 = "llvm.getelementptr"(%arg7) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %252 = "llvm.load"(%251) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %253 = "llvm.getelementptr"(%arg7) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %254 = "llvm.load"(%253) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %255 = "llvm.getelementptr"(%arg7) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %256 = "llvm.load"(%255) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %257 = "llvm.getelementptr"(%arg7) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %258 = "llvm.load"(%257) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %259 = "llvm.load"(%arg8) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %260 = "llvm.xor"(%259, %250) : (i64, i64) -> i64
  %261 = "llvm.getelementptr"(%arg8) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %262 = "llvm.load"(%261) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %263 = "llvm.xor"(%262, %252) : (i64, i64) -> i64
  %264 = "llvm.getelementptr"(%arg8) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %265 = "llvm.load"(%264) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %266 = "llvm.xor"(%265, %254) : (i64, i64) -> i64
  %267 = "llvm.getelementptr"(%arg8) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %268 = "llvm.load"(%267) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %269 = "llvm.xor"(%268, %256) : (i64, i64) -> i64
  %270 = "llvm.getelementptr"(%arg8) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %271 = "llvm.load"(%270) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %272 = "llvm.xor"(%271, %258) : (i64, i64) -> i64
  %273 = "llvm.and"(%260, %249) : (i64, i64) -> i64
  %274 = "llvm.and"(%263, %249) : (i64, i64) -> i64
  %275 = "llvm.and"(%266, %249) : (i64, i64) -> i64
  %276 = "llvm.and"(%269, %249) : (i64, i64) -> i64
  %277 = "llvm.and"(%272, %249) : (i64, i64) -> i64
  %278 = "llvm.xor"(%273, %250) : (i64, i64) -> i64
  "llvm.store"(%278, %arg7) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %279 = "llvm.xor"(%274, %252) : (i64, i64) -> i64
  "llvm.store"(%279, %251) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %280 = "llvm.xor"(%275, %254) : (i64, i64) -> i64
  "llvm.store"(%280, %253) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %281 = "llvm.xor"(%276, %256) : (i64, i64) -> i64
  "llvm.store"(%281, %255) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %282 = "llvm.xor"(%277, %258) : (i64, i64) -> i64
  "llvm.store"(%282, %257) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end MLIR.Zig
