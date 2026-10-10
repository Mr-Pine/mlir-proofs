module

-- zig-build/out/op/Fe.reduce.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Zig

@[expose] public section

mlir_def Fe_reduce :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 8 : i64, llvm.nocapture, llvm.nonnull}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, minsize, no_unwind, optsize, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["target-cpu", "x86-64"]], sym_name = "Fe.reduce", target_cpu = "x86-64", target_features = #llvm.target_features<["+64bit", "+cmov", "+cx8", "+fxsr", "+idivq-to-divl", "+macrofusion", "+mmx", "+nopl", "+slow-3ops-lea", "+slow-incdec", "+vzeroupper", "+x87", "-16bit-mode", "-32bit-mode", "-adx", "-aes", "-allow-light-256-bit", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tf32", "-amx-tile", "-amx-transpose", "-avx", "-avx10.1-256", "-avx10.1-512", "-avx10.2-256", "-avx10.2-512", "-avx2", "-avx512bf16", "-avx512bitalg", "-avx512bw", "-avx512cd", "-avx512dq", "-avx512f", "-avx512fp16", "-avx512ifma", "-avx512vbmi", "-avx512vbmi2", "-avx512vl", "-avx512vnni", "-avx512vp2intersect", "-avx512vpopcntdq", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-bmi", "-bmi2", "-branch-hint", "-branchfusion", "-ccmp", "-cf", "-cldemote", "-clflushopt", "-clwb", "-clzero", "-cmpccxadd", "-crc32", "-cx16", "-egpr", "-enqcmd", "-ermsb", "-evex512", "-f16c", "-false-deps-getmant", "-false-deps-lzcnt-tzcnt", "-false-deps-mulc", "-false-deps-mullq", "-false-deps-perm", "-false-deps-popcnt", "-false-deps-range", "-fast-11bytenop", "-fast-15bytenop", "-fast-7bytenop", "-fast-bextr", "-fast-dpwssd", "-fast-gather", "-fast-hops", "-fast-imm16", "-fast-lzcnt", "-fast-movbe", "-fast-scalar-fsqrt", "-fast-scalar-shift-masks", "-fast-shld-rotate", "-fast-variable-crosslane-shuffle", "-fast-variable-perlane-shuffle", "-fast-vector-fsqrt", "-fast-vector-shift-masks", "-faster-shift-than-shuffle", "-fma", "-fma4", "-fsgsbase", "-fsrm", "-gfni", "-harden-sls-ijmp", "-harden-sls-ret", "-hreset", "-idivl-to-divb", "-inline-asm-use-gpr32", "-invpcid", "-kl", "-lea-sp", "-lea-uses-ag", "-lvi-cfi", "-lvi-load-hardening", "-lwp", "-lzcnt", "-movbe", "-movdir64b", "-movdiri", "-movrs", "-mwaitx", "-ndd", "-nf", "-no-bypass-delay", "-no-bypass-delay-blend", "-no-bypass-delay-mov", "-no-bypass-delay-shuffle", "-pad-short-functions", "-pclmul", "-pconfig", "-pku", "-popcnt", "-ppx", "-prefer-128-bit", "-prefer-256-bit", "-prefer-mask-registers", "-prefer-movmsk-over-vtest", "-prefer-no-gather", "-prefer-no-scatter", "-prefetchi", "-prfchw", "-ptwrite", "-push2pop2", "-raoint", "-rdpid", "-rdpru", "-rdrnd", "-rdseed", "-retpoline", "-retpoline-external-thunk", "-retpoline-indirect-branches", "-retpoline-indirect-calls", "-rtm", "-sahf", "-sbb-dep-breaking", "-serialize", "-seses", "-sgx", "-sha", "-sha512", "-shstk", "-slow-lea", "-slow-pmaddwd", "-slow-pmulld", "-slow-shld", "-slow-two-mem-ops", "-slow-unaligned-mem-16", "-slow-unaligned-mem-32", "-sm3", "-sm4", "-soft-float", "-sse", "-sse2", "-sse3", "-sse4.1", "-sse4.2", "-sse4a", "-sse-unaligned-mem", "-ssse3", "-tagged-globals", "-tbm", "-tsxldtrk", "-tuning-fast-imm-vector-shift", "-uintr", "-use-glm-div-sqrt-costs", "-use-slm-arith-costs", "-usermsr", "-vaes", "-vpclmulqdq", "-waitpkg", "-wbnoinvd", "-widekl", "-xop", "-xsave", "-xsavec", "-xsaveopt", "-xsaves", "-zu"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg5: !llvm.ptr):
  %60 = "llvm.mlir.constant"() <{value = 51 : i64}> : () -> i64
  %61 = "llvm.mlir.constant"() <{value = 2251799813685247 : i64}> : () -> i64
  %62 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %63 = "llvm.mlir.constant"() <{value = 2251799813685229 : i64}> : () -> i64
  %64 = "llvm.getelementptr"(%arg5) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %65 = "llvm.load"(%64) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %66 = "llvm.load"(%arg5) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %67 = "llvm.lshr"(%66, %60) : (i64, i64) -> i64
  %68 = "llvm.add"(%67, %65) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %69 = "llvm.and"(%66, %61) : (i64, i64) -> i64
  %70 = "llvm.getelementptr"(%arg5) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %71 = "llvm.load"(%70) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %72 = "llvm.lshr"(%68, %60) : (i64, i64) -> i64
  %73 = "llvm.add"(%71, %72) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %74 = "llvm.and"(%68, %61) : (i64, i64) -> i64
  %75 = "llvm.getelementptr"(%arg5) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %76 = "llvm.load"(%75) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %77 = "llvm.lshr"(%73, %60) : (i64, i64) -> i64
  %78 = "llvm.add"(%76, %77) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %79 = "llvm.and"(%73, %61) : (i64, i64) -> i64
  %80 = "llvm.getelementptr"(%arg5) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %81 = "llvm.load"(%80) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %82 = "llvm.lshr"(%78, %60) : (i64, i64) -> i64
  %83 = "llvm.add"(%81, %82) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %84 = "llvm.and"(%78, %61) : (i64, i64) -> i64
  %85 = "llvm.lshr"(%83, %60) : (i64, i64) -> i64
  %86 = "llvm.mul"(%85, %62) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %87 = "llvm.add"(%86, %69) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %88 = "llvm.and"(%83, %61) : (i64, i64) -> i64
  %89 = "llvm.lshr"(%87, %60) : (i64, i64) -> i64
  %90 = "llvm.add"(%89, %74) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %91 = "llvm.and"(%87, %61) : (i64, i64) -> i64
  %92 = "llvm.lshr"(%90, %60) : (i64, i64) -> i64
  %93 = "llvm.add"(%92, %79) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %94 = "llvm.and"(%90, %61) : (i64, i64) -> i64
  %95 = "llvm.lshr"(%93, %60) : (i64, i64) -> i64
  %96 = "llvm.add"(%95, %84) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %97 = "llvm.and"(%93, %61) : (i64, i64) -> i64
  %98 = "llvm.lshr"(%96, %60) : (i64, i64) -> i64
  %99 = "llvm.add"(%98, %88) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %100 = "llvm.and"(%96, %61) : (i64, i64) -> i64
  %101 = "llvm.lshr"(%99, %60) : (i64, i64) -> i64
  %102 = "llvm.mul"(%101, %62) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %103 = "llvm.add"(%102, %91) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %104 = "llvm.and"(%99, %61) : (i64, i64) -> i64
  %105 = "llvm.add"(%103, %62) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %106 = "llvm.lshr"(%105, %60) : (i64, i64) -> i64
  %107 = "llvm.add"(%106, %94) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %108 = "llvm.and"(%105, %61) : (i64, i64) -> i64
  %109 = "llvm.lshr"(%107, %60) : (i64, i64) -> i64
  %110 = "llvm.add"(%109, %97) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %111 = "llvm.and"(%107, %61) : (i64, i64) -> i64
  %112 = "llvm.lshr"(%110, %60) : (i64, i64) -> i64
  %113 = "llvm.add"(%112, %100) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %114 = "llvm.and"(%110, %61) : (i64, i64) -> i64
  %115 = "llvm.lshr"(%113, %60) : (i64, i64) -> i64
  %116 = "llvm.add"(%115, %104) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %117 = "llvm.and"(%113, %61) : (i64, i64) -> i64
  %118 = "llvm.lshr"(%116, %60) : (i64, i64) -> i64
  %119 = "llvm.mul"(%118, %62) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %120 = "llvm.add"(%119, %108) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %121 = "llvm.add"(%120, %63) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %122 = "llvm.add"(%111, %61) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %123 = "llvm.add"(%114, %61) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %124 = "llvm.add"(%117, %61) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %125 = "llvm.add"(%116, %61) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %126 = "llvm.lshr"(%121, %60) : (i64, i64) -> i64
  %127 = "llvm.add"(%126, %122) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %128 = "llvm.and"(%121, %61) : (i64, i64) -> i64
  "llvm.store"(%128, %arg5) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %129 = "llvm.lshr"(%127, %60) : (i64, i64) -> i64
  %130 = "llvm.add"(%129, %123) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %131 = "llvm.and"(%127, %61) : (i64, i64) -> i64
  "llvm.store"(%131, %64) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %132 = "llvm.lshr"(%130, %60) : (i64, i64) -> i64
  %133 = "llvm.add"(%132, %124) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %134 = "llvm.and"(%130, %61) : (i64, i64) -> i64
  "llvm.store"(%134, %70) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %135 = "llvm.lshr"(%133, %60) : (i64, i64) -> i64
  %136 = "llvm.add"(%135, %125) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %137 = "llvm.and"(%133, %61) : (i64, i64) -> i64
  "llvm.store"(%137, %75) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %138 = "llvm.and"(%136, %61) : (i64, i64) -> i64
  "llvm.store"(%138, %80) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end MLIR.Zig
