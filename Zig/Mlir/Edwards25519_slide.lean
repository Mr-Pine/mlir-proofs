module

-- zig-build/out/op/Edwards25519.slide.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Zig.Mlir.Scalar_fromBytes
public import Zig.Mlir.Scalar_toBytes

meta import MLIR.Semantics.Func
meta import Zig.Mlir.Scalar_fromBytes
meta import Zig.Mlir.Scalar_toBytes

namespace MLIR.Zig

@[expose] public section

mlir_def Edwards25519_slide :=
#alias_scope_domain10 = #llvm.alias_scope_domain<id = distinct[10]<>, description = "reduce">
#alias_scope10 = #llvm.alias_scope<id = distinct[25]<>, domain = #alias_scope_domain10, description = "reduce: argument 0">
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.noalias, llvm.nocapture, llvm.nonnull, llvm.sret = !llvm.array<64 x i8>, llvm.writeonly}, {llvm.align = 1 : i64, llvm.nocapture, llvm.nonnull, llvm.readonly}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = read, argMem = readwrite, inaccessibleMem = write, errnoMem = read, targetMem0 = read, targetMem1 = read>, minsize, no_unwind, optsize, passthrough = ["nofree", "norecurse", "nosync", ["target-cpu", "x86-64"]], sym_name = "Edwards25519.slide", target_cpu = "x86-64", target_features = #llvm.target_features<["+64bit", "+cmov", "+cx8", "+fxsr", "+idivq-to-divl", "+macrofusion", "+mmx", "+nopl", "+slow-3ops-lea", "+slow-incdec", "+vzeroupper", "+x87", "-16bit-mode", "-32bit-mode", "-adx", "-aes", "-allow-light-256-bit", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tf32", "-amx-tile", "-amx-transpose", "-avx", "-avx10.1-256", "-avx10.1-512", "-avx10.2-256", "-avx10.2-512", "-avx2", "-avx512bf16", "-avx512bitalg", "-avx512bw", "-avx512cd", "-avx512dq", "-avx512f", "-avx512fp16", "-avx512ifma", "-avx512vbmi", "-avx512vbmi2", "-avx512vl", "-avx512vnni", "-avx512vp2intersect", "-avx512vpopcntdq", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-bmi", "-bmi2", "-branch-hint", "-branchfusion", "-ccmp", "-cf", "-cldemote", "-clflushopt", "-clwb", "-clzero", "-cmpccxadd", "-crc32", "-cx16", "-egpr", "-enqcmd", "-ermsb", "-evex512", "-f16c", "-false-deps-getmant", "-false-deps-lzcnt-tzcnt", "-false-deps-mulc", "-false-deps-mullq", "-false-deps-perm", "-false-deps-popcnt", "-false-deps-range", "-fast-11bytenop", "-fast-15bytenop", "-fast-7bytenop", "-fast-bextr", "-fast-dpwssd", "-fast-gather", "-fast-hops", "-fast-imm16", "-fast-lzcnt", "-fast-movbe", "-fast-scalar-fsqrt", "-fast-scalar-shift-masks", "-fast-shld-rotate", "-fast-variable-crosslane-shuffle", "-fast-variable-perlane-shuffle", "-fast-vector-fsqrt", "-fast-vector-shift-masks", "-faster-shift-than-shuffle", "-fma", "-fma4", "-fsgsbase", "-fsrm", "-gfni", "-harden-sls-ijmp", "-harden-sls-ret", "-hreset", "-idivl-to-divb", "-inline-asm-use-gpr32", "-invpcid", "-kl", "-lea-sp", "-lea-uses-ag", "-lvi-cfi", "-lvi-load-hardening", "-lwp", "-lzcnt", "-movbe", "-movdir64b", "-movdiri", "-movrs", "-mwaitx", "-ndd", "-nf", "-no-bypass-delay", "-no-bypass-delay-blend", "-no-bypass-delay-mov", "-no-bypass-delay-shuffle", "-pad-short-functions", "-pclmul", "-pconfig", "-pku", "-popcnt", "-ppx", "-prefer-128-bit", "-prefer-256-bit", "-prefer-mask-registers", "-prefer-movmsk-over-vtest", "-prefer-no-gather", "-prefer-no-scatter", "-prefetchi", "-prfchw", "-ptwrite", "-push2pop2", "-raoint", "-rdpid", "-rdpru", "-rdrnd", "-rdseed", "-retpoline", "-retpoline-external-thunk", "-retpoline-indirect-branches", "-retpoline-indirect-calls", "-rtm", "-sahf", "-sbb-dep-breaking", "-serialize", "-seses", "-sgx", "-sha", "-sha512", "-shstk", "-slow-lea", "-slow-pmaddwd", "-slow-pmulld", "-slow-shld", "-slow-two-mem-ops", "-slow-unaligned-mem-16", "-slow-unaligned-mem-32", "-sm3", "-sm4", "-soft-float", "-sse", "-sse2", "-sse3", "-sse4.1", "-sse4.2", "-sse4a", "-sse-unaligned-mem", "-ssse3", "-tagged-globals", "-tbm", "-tsxldtrk", "-tuning-fast-imm-vector-shift", "-uintr", "-use-glm-div-sqrt-costs", "-use-slm-arith-costs", "-usermsr", "-vaes", "-vpclmulqdq", "-waitpkg", "-wbnoinvd", "-widekl", "-xop", "-xsave", "-xsavec", "-xsaveopt", "-xsaves", "-zu"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg25: !llvm.ptr, %arg26: !llvm.ptr):
  %619 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %620 = "llvm.mlir.constant"() <{value = -1 : i8}> : () -> i8
  %621 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %622 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %623 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %624 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %625 = "llvm.mlir.constant"() <{value = 15 : i8}> : () -> i8
  %626 = "llvm.mlir.constant"() <{value = 4 : i8}> : () -> i8
  %627 = "llvm.mlir.constant"() <{value = 63 : i64}> : () -> i64
  %628 = "llvm.mlir.constant"() <{value = 8 : i8}> : () -> i8
  %629 = "llvm.mlir.constant"() <{value = -16 : i8}> : () -> i8
  %630 = "llvm.mlir.constant"() <{value = 64 : i64}> : () -> i64
  %631 = "llvm.alloca"(%619) <{alignment = 8 : i64, elem_type = !llvm.struct<"Scalar", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %632 = "llvm.alloca"(%619) <{alignment = 1 : i64, elem_type = !llvm.array<64 x i8>}> : (i32) -> !llvm.ptr
  %633 = "llvm.alloca"(%619) <{alignment = 1 : i64, elem_type = !llvm.array<32 x i8>}> : (i32) -> !llvm.ptr
  %634 = "llvm.getelementptr"(%arg26) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 31>}> : (!llvm.ptr) -> !llvm.ptr
  %635 = "llvm.load"(%634) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %636 = "llvm.icmp"(%635, %620) <{predicate = 4 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%636, %arg26)[^bb1, ^bb2] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, !llvm.ptr) -> ()
^bb1(%637: !llvm.ptr):  // 2 preds: ^bb0, ^bb2
  "llvm.br"(%621)[^bb3] : (i64) -> ()
^bb2:  // pred: ^bb0
  "llvm.intr.lifetime.start"(%631) : (!llvm.ptr) -> ()
  "llvm.call"(%631, %arg26) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Scalar", (array<5 x i64>)>}, {llvm.align = 1 : i64, llvm.nonnull, llvm.readonly}], callee = @Scalar.fromBytes, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, noalias_scopes = [#alias_scope10], op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%633, %631) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.array<32 x i8>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Scalar.toBytes, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = write, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%631) : (!llvm.ptr) -> ()
  "llvm.br"(%633)[^bb1] : (!llvm.ptr) -> ()
^bb3(%638: i64):  // 2 preds: ^bb1, ^bb4
  %639 = "llvm.icmp"(%638, %622) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%639, %621, %623)[^bb5, ^bb4] <{operandSegmentSizes = array<i32: 1, 2, 0>}> : (i1, i64, i8) -> ()
^bb4:  // pred: ^bb3
  %640 = "llvm.getelementptr"(%637, %638) <{elem_type = !llvm.array<32 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 0, -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %641 = "llvm.load"(%640) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %642 = "llvm.shl"(%638, %624) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %643 = "llvm.getelementptr"(%632, %642) <{elem_type = !llvm.array<64 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 0, -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %644 = "llvm.and"(%641, %625) : (i8, i8) -> i8
  "llvm.store"(%644, %643) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %645 = "llvm.or"(%642, %624) <{isDisjoint}> : (i64, i64) -> i64
  %646 = "llvm.getelementptr"(%632, %645) <{elem_type = !llvm.array<64 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 0, -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %647 = "llvm.lshr"(%641, %626) : (i8, i8) -> i8
  "llvm.store"(%647, %646) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %648 = "llvm.add"(%638, %624) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  "llvm.br"(%648)[^bb3] : (i64) -> ()
^bb5(%649: i64, %650: i8):  // 2 preds: ^bb3, ^bb6
  %651 = "llvm.icmp"(%649, %627) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%651)[^bb7, ^bb6] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb6:  // pred: ^bb5
  %652 = "llvm.getelementptr"(%632, %649) <{elem_type = !llvm.array<63 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 0, -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %653 = "llvm.load"(%652) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %654 = "llvm.add"(%653, %650) <{overflowFlags = 1 : i32}> : (i8, i8) -> i8
  %655 = "llvm.add"(%654, %628) <{overflowFlags = 1 : i32}> : (i8, i8) -> i8
  %656 = "llvm.ashr"(%655, %626) : (i8, i8) -> i8
  %657 = "llvm.and"(%655, %629) : (i8, i8) -> i8
  %658 = "llvm.sub"(%654, %657) <{overflowFlags = 1 : i32}> : (i8, i8) -> i8
  "llvm.store"(%658, %652) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %659 = "llvm.add"(%649, %624) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  "llvm.br"(%659, %656)[^bb5] : (i64, i8) -> ()
^bb7:  // pred: ^bb5
  %660 = "llvm.getelementptr"(%632) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 63>}> : (!llvm.ptr) -> !llvm.ptr
  %661 = "llvm.load"(%660) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %662 = "llvm.add"(%661, %650) <{overflowFlags = 1 : i32}> : (i8, i8) -> i8
  "llvm.store"(%662, %660) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.intr.memcpy"(%arg25, %632, %630) <{arg_attrs = [{llvm.align = 1 : i64, llvm.dereferenceable = 64 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 1 : i64, llvm.dereferenceable = 64 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
  with @Scalar.fromBytes := Scalar_fromBytes, @Scalar.toBytes := Scalar_toBytes

end

end MLIR.Zig
