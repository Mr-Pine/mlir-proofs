module

-- zig-build/out/op/Edwards25519.add.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Zig.Mlir.Fe_add
public import Zig.Mlir.Fe_mul
public import Zig.Mlir.Fe_sub
public import Zig.Mlir.Fe_edwards25519d2

meta import MLIR.Semantics.Func
meta import Zig.Mlir.Fe_add
meta import Zig.Mlir.Fe_mul
meta import Zig.Mlir.Fe_sub
meta import Zig.Mlir.Fe_edwards25519d2

namespace MLIR.Zig

@[expose] public section

mlir_def Edwards25519_add :=
#alias_scope_domain11 = #llvm.alias_scope_domain<id = distinct[11]<>, description = "Fe.add">
#alias_scope_domain12 = #llvm.alias_scope_domain<id = distinct[12]<>, description = "Fe.add">
#alias_scope_domain13 = #llvm.alias_scope_domain<id = distinct[13]<>, description = "Fe.add">
#alias_scope11 = #llvm.alias_scope<id = distinct[26]<>, domain = #alias_scope_domain11, description = "Fe.add: argument 0">
#alias_scope12 = #llvm.alias_scope<id = distinct[27]<>, domain = #alias_scope_domain12, description = "Fe.add: argument 0">
#alias_scope13 = #llvm.alias_scope<id = distinct[28]<>, domain = #alias_scope_domain13, description = "Fe.add: argument 0">
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.noalias, llvm.nocapture, llvm.nonnull, llvm.sret = !llvm.struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>, llvm.writeonly}, {llvm.align = 8 : i64, llvm.nocapture, llvm.nonnull, llvm.readonly}, {llvm.align = 8 : i64, llvm.nocapture, llvm.nonnull, llvm.readonly}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, minsize, no_unwind, optsize, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["target-cpu", "x86-64"]], sym_name = "Edwards25519.add", target_cpu = "x86-64", target_features = #llvm.target_features<["+64bit", "+cmov", "+cx8", "+fxsr", "+idivq-to-divl", "+macrofusion", "+mmx", "+nopl", "+slow-3ops-lea", "+slow-incdec", "+vzeroupper", "+x87", "-16bit-mode", "-32bit-mode", "-adx", "-aes", "-allow-light-256-bit", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tf32", "-amx-tile", "-amx-transpose", "-avx", "-avx10.1-256", "-avx10.1-512", "-avx10.2-256", "-avx10.2-512", "-avx2", "-avx512bf16", "-avx512bitalg", "-avx512bw", "-avx512cd", "-avx512dq", "-avx512f", "-avx512fp16", "-avx512ifma", "-avx512vbmi", "-avx512vbmi2", "-avx512vl", "-avx512vnni", "-avx512vp2intersect", "-avx512vpopcntdq", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-bmi", "-bmi2", "-branch-hint", "-branchfusion", "-ccmp", "-cf", "-cldemote", "-clflushopt", "-clwb", "-clzero", "-cmpccxadd", "-crc32", "-cx16", "-egpr", "-enqcmd", "-ermsb", "-evex512", "-f16c", "-false-deps-getmant", "-false-deps-lzcnt-tzcnt", "-false-deps-mulc", "-false-deps-mullq", "-false-deps-perm", "-false-deps-popcnt", "-false-deps-range", "-fast-11bytenop", "-fast-15bytenop", "-fast-7bytenop", "-fast-bextr", "-fast-dpwssd", "-fast-gather", "-fast-hops", "-fast-imm16", "-fast-lzcnt", "-fast-movbe", "-fast-scalar-fsqrt", "-fast-scalar-shift-masks", "-fast-shld-rotate", "-fast-variable-crosslane-shuffle", "-fast-variable-perlane-shuffle", "-fast-vector-fsqrt", "-fast-vector-shift-masks", "-faster-shift-than-shuffle", "-fma", "-fma4", "-fsgsbase", "-fsrm", "-gfni", "-harden-sls-ijmp", "-harden-sls-ret", "-hreset", "-idivl-to-divb", "-inline-asm-use-gpr32", "-invpcid", "-kl", "-lea-sp", "-lea-uses-ag", "-lvi-cfi", "-lvi-load-hardening", "-lwp", "-lzcnt", "-movbe", "-movdir64b", "-movdiri", "-movrs", "-mwaitx", "-ndd", "-nf", "-no-bypass-delay", "-no-bypass-delay-blend", "-no-bypass-delay-mov", "-no-bypass-delay-shuffle", "-pad-short-functions", "-pclmul", "-pconfig", "-pku", "-popcnt", "-ppx", "-prefer-128-bit", "-prefer-256-bit", "-prefer-mask-registers", "-prefer-movmsk-over-vtest", "-prefer-no-gather", "-prefer-no-scatter", "-prefetchi", "-prfchw", "-ptwrite", "-push2pop2", "-raoint", "-rdpid", "-rdpru", "-rdrnd", "-rdseed", "-retpoline", "-retpoline-external-thunk", "-retpoline-indirect-branches", "-retpoline-indirect-calls", "-rtm", "-sahf", "-sbb-dep-breaking", "-serialize", "-seses", "-sgx", "-sha", "-sha512", "-shstk", "-slow-lea", "-slow-pmaddwd", "-slow-pmulld", "-slow-shld", "-slow-two-mem-ops", "-slow-unaligned-mem-16", "-slow-unaligned-mem-32", "-sm3", "-sm4", "-soft-float", "-sse", "-sse2", "-sse3", "-sse4.1", "-sse4.2", "-sse4a", "-sse-unaligned-mem", "-ssse3", "-tagged-globals", "-tbm", "-tsxldtrk", "-tuning-fast-imm-vector-shift", "-uintr", "-use-glm-div-sqrt-costs", "-use-slm-arith-costs", "-usermsr", "-vaes", "-vpclmulqdq", "-waitpkg", "-wbnoinvd", "-widekl", "-xop", "-xsave", "-xsavec", "-xsaveopt", "-xsaves", "-zu"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg22: !llvm.ptr, %arg23: !llvm.ptr, %arg24: !llvm.ptr):
  %523 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %524 = "llvm.mlir.constant"() <{value = 168 : i64}> : () -> i64
  %525 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
  %526 = "llvm.mlir.addressof"() <{global_name = @Fe.edwards25519d2}> : () -> !llvm.ptr
  %527 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %528 = "llvm.mlir.constant"() <{value = false}> : () -> i1
  %529 = "llvm.alloca"(%523) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %530 = "llvm.alloca"(%523) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %531 = "llvm.alloca"(%523) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %532 = "llvm.alloca"(%523) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %533 = "llvm.alloca"(%523) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %534 = "llvm.alloca"(%523) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %535 = "llvm.alloca"(%523) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %536 = "llvm.alloca"(%523) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %537 = "llvm.alloca"(%523) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %538 = "llvm.alloca"(%523) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %539 = "llvm.alloca"(%523) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %540 = "llvm.alloca"(%523) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %541 = "llvm.alloca"(%523) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %542 = "llvm.alloca"(%523) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %543 = "llvm.alloca"(%523) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %544 = "llvm.alloca"(%523) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %545 = "llvm.alloca"(%523) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %546 = "llvm.alloca"(%523) <{alignment = 8 : i64, elem_type = !llvm.struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>}> : (i32) -> !llvm.ptr
  %547 = "llvm.alloca"(%523) <{alignment = 8 : i64, elem_type = !llvm.struct<"Edwards25519", (struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, struct<"Fe", (array<5 x i64>)>, i1, array<7 x i8>)>}> : (i32) -> !llvm.ptr
  "llvm.intr.memcpy"(%547, %arg23, %524) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 168 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 168 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.intr.memcpy"(%546, %arg24, %524) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 168 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 168 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %548 = "llvm.getelementptr"(%547) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%545, %548, %arg23) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Fe.sub, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  %549 = "llvm.getelementptr"(%546) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%544, %549, %arg24) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Fe.sub, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%543, %545, %544) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Fe.mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = write, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  %550 = "llvm.getelementptr"(%arg23) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%542, %arg23, %550) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Fe.add, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  %551 = "llvm.getelementptr"(%arg24) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%541, %arg24, %551) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Fe.add, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%540, %542, %541) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Fe.mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = write, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  %552 = "llvm.getelementptr"(%547) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 120>}> : (!llvm.ptr) -> !llvm.ptr
  %553 = "llvm.getelementptr"(%arg24) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 120>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%539, %552, %553) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Fe.mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = write, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%538, %539, %526) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Fe.mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = write, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  %554 = "llvm.getelementptr"(%547) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 80>}> : (!llvm.ptr) -> !llvm.ptr
  %555 = "llvm.getelementptr"(%arg24) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 80>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%537, %554, %555) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Fe.mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = write, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  %556 = "llvm.load"(%537) <{alignment = 8 : i64, noalias_scopes = [#alias_scope11], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %557 = "llvm.shl"(%556, %527) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %558 = "llvm.getelementptr"(%537) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %559 = "llvm.load"(%558) <{alignment = 8 : i64, noalias_scopes = [#alias_scope11], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %560 = "llvm.shl"(%559, %527) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %561 = "llvm.getelementptr"(%537) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %562 = "llvm.load"(%561) <{alignment = 8 : i64, noalias_scopes = [#alias_scope11], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %563 = "llvm.shl"(%562, %527) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %564 = "llvm.getelementptr"(%537) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %565 = "llvm.load"(%564) <{alignment = 8 : i64, noalias_scopes = [#alias_scope11], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %566 = "llvm.shl"(%565, %527) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %567 = "llvm.getelementptr"(%537) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %568 = "llvm.load"(%567) <{alignment = 8 : i64, noalias_scopes = [#alias_scope11], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %569 = "llvm.shl"(%568, %527) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  "llvm.store"(%557, %537) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.store"(%560, %558) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.store"(%563, %561) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.store"(%566, %564) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.store"(%569, %567) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.call"(%536, %540, %543) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Fe.sub, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.experimental.noalias.scope.decl"() <{scope = #alias_scope12}> : () -> ()
  %570 = "llvm.load"(%540) <{alignment = 8 : i64, noalias_scopes = [#alias_scope12], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %571 = "llvm.load"(%543) <{alignment = 8 : i64, noalias_scopes = [#alias_scope12], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %572 = "llvm.add"(%571, %570) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %573 = "llvm.getelementptr"(%540) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %574 = "llvm.load"(%573) <{alignment = 8 : i64, noalias_scopes = [#alias_scope12], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %575 = "llvm.getelementptr"(%543) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %576 = "llvm.load"(%575) <{alignment = 8 : i64, noalias_scopes = [#alias_scope12], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %577 = "llvm.add"(%576, %574) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %578 = "llvm.getelementptr"(%540) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %579 = "llvm.load"(%578) <{alignment = 8 : i64, noalias_scopes = [#alias_scope12], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %580 = "llvm.getelementptr"(%543) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %581 = "llvm.load"(%580) <{alignment = 8 : i64, noalias_scopes = [#alias_scope12], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %582 = "llvm.add"(%581, %579) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %583 = "llvm.getelementptr"(%540) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %584 = "llvm.load"(%583) <{alignment = 8 : i64, noalias_scopes = [#alias_scope12], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %585 = "llvm.getelementptr"(%543) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %586 = "llvm.load"(%585) <{alignment = 8 : i64, noalias_scopes = [#alias_scope12], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %587 = "llvm.add"(%586, %584) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %588 = "llvm.getelementptr"(%540) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %589 = "llvm.load"(%588) <{alignment = 8 : i64, noalias_scopes = [#alias_scope12], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %590 = "llvm.getelementptr"(%543) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %591 = "llvm.load"(%590) <{alignment = 8 : i64, noalias_scopes = [#alias_scope12], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %592 = "llvm.add"(%591, %589) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  "llvm.store"(%572, %535) <{alias_scopes = [#alias_scope12], alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %593 = "llvm.getelementptr"(%535) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%577, %593) <{alias_scopes = [#alias_scope12], alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %594 = "llvm.getelementptr"(%535) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%582, %594) <{alias_scopes = [#alias_scope12], alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %595 = "llvm.getelementptr"(%535) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%587, %595) <{alias_scopes = [#alias_scope12], alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %596 = "llvm.getelementptr"(%535) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%592, %596) <{alias_scopes = [#alias_scope12], alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.intr.experimental.noalias.scope.decl"() <{scope = #alias_scope13}> : () -> ()
  %597 = "llvm.load"(%538) <{alignment = 8 : i64, noalias_scopes = [#alias_scope13], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %598 = "llvm.add"(%597, %557) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %599 = "llvm.getelementptr"(%538) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %600 = "llvm.load"(%599) <{alignment = 8 : i64, noalias_scopes = [#alias_scope13], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %601 = "llvm.add"(%600, %560) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %602 = "llvm.getelementptr"(%538) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %603 = "llvm.load"(%602) <{alignment = 8 : i64, noalias_scopes = [#alias_scope13], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %604 = "llvm.add"(%603, %563) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %605 = "llvm.getelementptr"(%538) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %606 = "llvm.load"(%605) <{alignment = 8 : i64, noalias_scopes = [#alias_scope13], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %607 = "llvm.add"(%606, %566) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %608 = "llvm.getelementptr"(%538) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %609 = "llvm.load"(%608) <{alignment = 8 : i64, noalias_scopes = [#alias_scope13], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %610 = "llvm.add"(%609, %569) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  "llvm.store"(%598, %534) <{alias_scopes = [#alias_scope13], alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %611 = "llvm.getelementptr"(%534) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%601, %611) <{alias_scopes = [#alias_scope13], alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %612 = "llvm.getelementptr"(%534) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%604, %612) <{alias_scopes = [#alias_scope13], alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %613 = "llvm.getelementptr"(%534) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%607, %613) <{alias_scopes = [#alias_scope13], alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %614 = "llvm.getelementptr"(%534) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%610, %614) <{alias_scopes = [#alias_scope13], alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.call"(%533, %537, %538) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Fe.sub, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%532, %536, %533) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Fe.mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = write, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.memcpy"(%arg22, %532, %525) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %615 = "llvm.getelementptr"(%arg22) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%531, %535, %534) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Fe.mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = write, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.memcpy"(%615, %531, %525) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %616 = "llvm.getelementptr"(%arg22) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 80>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%530, %534, %533) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Fe.mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = write, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.memcpy"(%616, %530, %525) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %617 = "llvm.getelementptr"(%arg22) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 120>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%529, %536, %535) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Fe.mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = write, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.memcpy"(%617, %529, %525) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %618 = "llvm.getelementptr"(%arg22) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 160>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%528, %618) <{alignment = 8 : i64, ordering = 0 : i64}> : (i1, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
  with @Fe.add := Fe_add, @Fe.mul := Fe_mul, @Fe.sub := Fe_sub,
    @Fe.edwards25519d2 := Fe_edwards25519d2

end

end MLIR.Zig
