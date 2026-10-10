module

-- zig-build/out/op/Fe.sq.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Zig.Mlir.Fe_carry128

meta import MLIR.Semantics.Func
meta import Zig.Mlir.Fe_carry128

namespace MLIR.Zig

@[expose] public section

mlir_def Fe_sq :=
#alias_scope_domain14 = #llvm.alias_scope_domain<id = distinct[14]<>, description = "Fe._sq__anon_17901">
#alias_scope14 = #llvm.alias_scope<id = distinct[29]<>, domain = #alias_scope_domain14, description = "Fe._sq__anon_17901: argument 0">
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.noalias, llvm.nocapture, llvm.nonnull, llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>, llvm.writeonly}, {llvm.align = 8 : i64, llvm.nocapture, llvm.nonnull, llvm.readonly}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = write, errnoMem = none, targetMem0 = none, targetMem1 = none>, minsize, no_unwind, optsize, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["target-cpu", "x86-64"]], sym_name = "Fe.sq", target_cpu = "x86-64", target_features = #llvm.target_features<["+64bit", "+cmov", "+cx8", "+fxsr", "+idivq-to-divl", "+macrofusion", "+mmx", "+nopl", "+slow-3ops-lea", "+slow-incdec", "+vzeroupper", "+x87", "-16bit-mode", "-32bit-mode", "-adx", "-aes", "-allow-light-256-bit", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tf32", "-amx-tile", "-amx-transpose", "-avx", "-avx10.1-256", "-avx10.1-512", "-avx10.2-256", "-avx10.2-512", "-avx2", "-avx512bf16", "-avx512bitalg", "-avx512bw", "-avx512cd", "-avx512dq", "-avx512f", "-avx512fp16", "-avx512ifma", "-avx512vbmi", "-avx512vbmi2", "-avx512vl", "-avx512vnni", "-avx512vp2intersect", "-avx512vpopcntdq", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-bmi", "-bmi2", "-branch-hint", "-branchfusion", "-ccmp", "-cf", "-cldemote", "-clflushopt", "-clwb", "-clzero", "-cmpccxadd", "-crc32", "-cx16", "-egpr", "-enqcmd", "-ermsb", "-evex512", "-f16c", "-false-deps-getmant", "-false-deps-lzcnt-tzcnt", "-false-deps-mulc", "-false-deps-mullq", "-false-deps-perm", "-false-deps-popcnt", "-false-deps-range", "-fast-11bytenop", "-fast-15bytenop", "-fast-7bytenop", "-fast-bextr", "-fast-dpwssd", "-fast-gather", "-fast-hops", "-fast-imm16", "-fast-lzcnt", "-fast-movbe", "-fast-scalar-fsqrt", "-fast-scalar-shift-masks", "-fast-shld-rotate", "-fast-variable-crosslane-shuffle", "-fast-variable-perlane-shuffle", "-fast-vector-fsqrt", "-fast-vector-shift-masks", "-faster-shift-than-shuffle", "-fma", "-fma4", "-fsgsbase", "-fsrm", "-gfni", "-harden-sls-ijmp", "-harden-sls-ret", "-hreset", "-idivl-to-divb", "-inline-asm-use-gpr32", "-invpcid", "-kl", "-lea-sp", "-lea-uses-ag", "-lvi-cfi", "-lvi-load-hardening", "-lwp", "-lzcnt", "-movbe", "-movdir64b", "-movdiri", "-movrs", "-mwaitx", "-ndd", "-nf", "-no-bypass-delay", "-no-bypass-delay-blend", "-no-bypass-delay-mov", "-no-bypass-delay-shuffle", "-pad-short-functions", "-pclmul", "-pconfig", "-pku", "-popcnt", "-ppx", "-prefer-128-bit", "-prefer-256-bit", "-prefer-mask-registers", "-prefer-movmsk-over-vtest", "-prefer-no-gather", "-prefer-no-scatter", "-prefetchi", "-prfchw", "-ptwrite", "-push2pop2", "-raoint", "-rdpid", "-rdpru", "-rdrnd", "-rdseed", "-retpoline", "-retpoline-external-thunk", "-retpoline-indirect-branches", "-retpoline-indirect-calls", "-rtm", "-sahf", "-sbb-dep-breaking", "-serialize", "-seses", "-sgx", "-sha", "-sha512", "-shstk", "-slow-lea", "-slow-pmaddwd", "-slow-pmulld", "-slow-shld", "-slow-two-mem-ops", "-slow-unaligned-mem-16", "-slow-unaligned-mem-32", "-sm3", "-sm4", "-soft-float", "-sse", "-sse2", "-sse3", "-sse4.1", "-sse4.2", "-sse4a", "-sse-unaligned-mem", "-ssse3", "-tagged-globals", "-tbm", "-tsxldtrk", "-tuning-fast-imm-vector-shift", "-uintr", "-use-glm-div-sqrt-costs", "-use-slm-arith-costs", "-usermsr", "-vaes", "-vpclmulqdq", "-waitpkg", "-wbnoinvd", "-widekl", "-xop", "-xsave", "-xsavec", "-xsaveopt", "-xsaves", "-zu"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg19: !llvm.ptr, %arg20: !llvm.ptr):
  %449 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %450 = "llvm.mlir.constant"() <{value = 1 : i128}> : () -> i128
  %451 = "llvm.mlir.constant"() <{value = 38 : i128}> : () -> i128
  %452 = "llvm.mlir.constant"() <{value = 19 : i128}> : () -> i128
  %453 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
  %454 = "llvm.alloca"(%449) <{alignment = 16 : i64, elem_type = !llvm.array<5 x i128>}> : (i32) -> !llvm.ptr
  %455 = "llvm.alloca"(%449) <{alignment = 8 : i64, elem_type = !llvm.array<5 x i64>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%454) : (!llvm.ptr) -> ()
  %456 = "llvm.load"(%arg20) <{alignment = 8 : i64, noalias_scopes = [#alias_scope14], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %457 = "llvm.zext"(%456) : (i64) -> i128
  %458 = "llvm.getelementptr"(%arg20) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %459 = "llvm.load"(%458) <{alignment = 8 : i64, noalias_scopes = [#alias_scope14], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %460 = "llvm.zext"(%459) : (i64) -> i128
  %461 = "llvm.getelementptr"(%arg20) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %462 = "llvm.load"(%461) <{alignment = 8 : i64, noalias_scopes = [#alias_scope14], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %463 = "llvm.zext"(%462) : (i64) -> i128
  %464 = "llvm.getelementptr"(%arg20) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %465 = "llvm.load"(%464) <{alignment = 8 : i64, noalias_scopes = [#alias_scope14], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %466 = "llvm.zext"(%465) : (i64) -> i128
  %467 = "llvm.getelementptr"(%arg20) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %468 = "llvm.load"(%467) <{alignment = 8 : i64, noalias_scopes = [#alias_scope14], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %469 = "llvm.zext"(%468) : (i64) -> i128
  %470 = "llvm.shl"(%457, %450) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %471 = "llvm.shl"(%460, %450) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %472 = "llvm.mul"(%463, %451) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %473 = "llvm.mul"(%466, %452) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %474 = "llvm.mul"(%469, %452) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %475 = "llvm.mul"(%457, %457) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %476 = "llvm.mul"(%469, %451) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %477 = "llvm.mul"(%476, %460) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %478 = "llvm.mul"(%472, %466) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %479 = "llvm.add"(%478, %475) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %480 = "llvm.add"(%479, %477) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  "llvm.store"(%480, %454) <{alignment = 16 : i64, noalias_scopes = [#alias_scope14], ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
  %481 = "llvm.getelementptr"(%454) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %482 = "llvm.mul"(%470, %460) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %483 = "llvm.mul"(%472, %469) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %484 = "llvm.add"(%483, %482) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %485 = "llvm.mul"(%473, %466) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %486 = "llvm.add"(%484, %485) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  "llvm.store"(%486, %481) <{alignment = 16 : i64, noalias_scopes = [#alias_scope14], ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
  %487 = "llvm.getelementptr"(%454) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %488 = "llvm.mul"(%470, %463) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %489 = "llvm.mul"(%460, %460) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %490 = "llvm.add"(%488, %489) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %491 = "llvm.mul"(%476, %466) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %492 = "llvm.add"(%490, %491) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  "llvm.store"(%492, %487) <{alignment = 16 : i64, noalias_scopes = [#alias_scope14], ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
  %493 = "llvm.getelementptr"(%454) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 48>}> : (!llvm.ptr) -> !llvm.ptr
  %494 = "llvm.mul"(%470, %466) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %495 = "llvm.mul"(%471, %463) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %496 = "llvm.add"(%494, %495) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %497 = "llvm.mul"(%474, %469) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %498 = "llvm.add"(%496, %497) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  "llvm.store"(%498, %493) <{alignment = 16 : i64, noalias_scopes = [#alias_scope14], ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
  %499 = "llvm.getelementptr"(%454) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %500 = "llvm.mul"(%470, %469) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %501 = "llvm.mul"(%471, %466) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %502 = "llvm.mul"(%463, %463) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %503 = "llvm.add"(%501, %502) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %504 = "llvm.add"(%503, %500) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  "llvm.store"(%504, %499) <{alignment = 16 : i64, noalias_scopes = [#alias_scope14], ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
  "llvm.call"(%455, %454) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>}, {llvm.align = 16 : i64, llvm.nonnull}], callee = @Fe.carry128, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = write, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%454) : (!llvm.ptr) -> ()
  "llvm.intr.memcpy"(%arg19, %455, %453) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
  with @Fe.carry128 := Fe_carry128

end

end MLIR.Zig
