module

-- zig-build/out/op/scalar.reduce64.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Zig.Mlir.Scalar_toBytes

meta import MLIR.Semantics.Func
meta import Zig.Mlir.Scalar_toBytes

namespace MLIR.Zig

@[expose] public section

mlir_def scalar_reduce64 :=
#alias_scope_domain = #llvm.alias_scope_domain<id = distinct[0]<>, description = "ScalarDouble.fromBytes64">
#alias_scope_domain1 = #llvm.alias_scope_domain<id = distinct[1]<>, description = "ScalarDouble.toBytes">
#alias_scope = #llvm.alias_scope<id = distinct[15]<>, domain = #alias_scope_domain, description = "ScalarDouble.fromBytes64: argument 0">
#alias_scope1 = #llvm.alias_scope<id = distinct[16]<>, domain = #alias_scope_domain1, description = "ScalarDouble.toBytes: argument 0">
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.noalias, llvm.nocapture, llvm.nonnull, llvm.sret = !llvm.array<32 x i8>, llvm.writeonly}, {llvm.align = 1 : i64, llvm.nocapture, llvm.nonnull, llvm.readonly}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = write, errnoMem = none, targetMem0 = none, targetMem1 = none>, minsize, no_inline, no_unwind, optsize, passthrough = ["nofree", "norecurse", "nosync", ["target-cpu", "x86-64"]], sym_name = "scalar.reduce64", target_cpu = "x86-64", target_features = #llvm.target_features<["+64bit", "+cmov", "+cx8", "+fxsr", "+idivq-to-divl", "+macrofusion", "+mmx", "+nopl", "+slow-3ops-lea", "+slow-incdec", "+vzeroupper", "+x87", "-16bit-mode", "-32bit-mode", "-adx", "-aes", "-allow-light-256-bit", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tf32", "-amx-tile", "-amx-transpose", "-avx", "-avx10.1-256", "-avx10.1-512", "-avx10.2-256", "-avx10.2-512", "-avx2", "-avx512bf16", "-avx512bitalg", "-avx512bw", "-avx512cd", "-avx512dq", "-avx512f", "-avx512fp16", "-avx512ifma", "-avx512vbmi", "-avx512vbmi2", "-avx512vl", "-avx512vnni", "-avx512vp2intersect", "-avx512vpopcntdq", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-bmi", "-bmi2", "-branch-hint", "-branchfusion", "-ccmp", "-cf", "-cldemote", "-clflushopt", "-clwb", "-clzero", "-cmpccxadd", "-crc32", "-cx16", "-egpr", "-enqcmd", "-ermsb", "-evex512", "-f16c", "-false-deps-getmant", "-false-deps-lzcnt-tzcnt", "-false-deps-mulc", "-false-deps-mullq", "-false-deps-perm", "-false-deps-popcnt", "-false-deps-range", "-fast-11bytenop", "-fast-15bytenop", "-fast-7bytenop", "-fast-bextr", "-fast-dpwssd", "-fast-gather", "-fast-hops", "-fast-imm16", "-fast-lzcnt", "-fast-movbe", "-fast-scalar-fsqrt", "-fast-scalar-shift-masks", "-fast-shld-rotate", "-fast-variable-crosslane-shuffle", "-fast-variable-perlane-shuffle", "-fast-vector-fsqrt", "-fast-vector-shift-masks", "-faster-shift-than-shuffle", "-fma", "-fma4", "-fsgsbase", "-fsrm", "-gfni", "-harden-sls-ijmp", "-harden-sls-ret", "-hreset", "-idivl-to-divb", "-inline-asm-use-gpr32", "-invpcid", "-kl", "-lea-sp", "-lea-uses-ag", "-lvi-cfi", "-lvi-load-hardening", "-lwp", "-lzcnt", "-movbe", "-movdir64b", "-movdiri", "-movrs", "-mwaitx", "-ndd", "-nf", "-no-bypass-delay", "-no-bypass-delay-blend", "-no-bypass-delay-mov", "-no-bypass-delay-shuffle", "-pad-short-functions", "-pclmul", "-pconfig", "-pku", "-popcnt", "-ppx", "-prefer-128-bit", "-prefer-256-bit", "-prefer-mask-registers", "-prefer-movmsk-over-vtest", "-prefer-no-gather", "-prefer-no-scatter", "-prefetchi", "-prfchw", "-ptwrite", "-push2pop2", "-raoint", "-rdpid", "-rdpru", "-rdrnd", "-rdseed", "-retpoline", "-retpoline-external-thunk", "-retpoline-indirect-branches", "-retpoline-indirect-calls", "-rtm", "-sahf", "-sbb-dep-breaking", "-serialize", "-seses", "-sgx", "-sha", "-sha512", "-shstk", "-slow-lea", "-slow-pmaddwd", "-slow-pmulld", "-slow-shld", "-slow-two-mem-ops", "-slow-unaligned-mem-16", "-slow-unaligned-mem-32", "-sm3", "-sm4", "-soft-float", "-sse", "-sse2", "-sse3", "-sse4.1", "-sse4.2", "-sse4a", "-sse-unaligned-mem", "-ssse3", "-tagged-globals", "-tbm", "-tsxldtrk", "-tuning-fast-imm-vector-shift", "-uintr", "-use-glm-div-sqrt-costs", "-use-slm-arith-costs", "-usermsr", "-vaes", "-vpclmulqdq", "-waitpkg", "-wbnoinvd", "-widekl", "-xop", "-xsave", "-xsavec", "-xsaveopt", "-xsaves", "-zu"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg60: !llvm.ptr, %arg61: !llvm.ptr):
  %3560 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %3561 = "llvm.mlir.constant"() <{value = 64 : i64}> : () -> i64
  %3562 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %3563 = "llvm.mlir.constant"() <{value = 9 : i64}> : () -> i64
  %3564 = "llvm.mlir.constant"() <{value = 7 : i64}> : () -> i64
  %3565 = "llvm.mlir.constant"() <{value = 72057594037927935 : i64}> : () -> i64
  %3566 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %3567 = "llvm.mlir.constant"() <{value = 63 : i64}> : () -> i64
  %3568 = "llvm.mlir.constant"() <{value = 16 : i64}> : () -> i64
  %3569 = "llvm.mlir.constant"() <{value = 24 : i64}> : () -> i64
  %3570 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %3571 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
  %3572 = "llvm.mlir.constant"() <{value = 56 : i64}> : () -> i64
  %3573 = "llvm.mlir.constant"() <{value = 72057589742960640 : i64}> : () -> i64
  %3574 = "llvm.mlir.constant"() <{value = 44162584779952923 : i128}> : () -> i128
  %3575 = "llvm.mlir.constant"() <{value = 9390964836247533 : i128}> : () -> i128
  %3576 = "llvm.mlir.constant"() <{value = 72057594036560134 : i128}> : () -> i128
  %3577 = "llvm.mlir.constant"() <{value = 72057594037927935 : i128}> : () -> i128
  %3578 = "llvm.mlir.constant"() <{value = 68719476735 : i128}> : () -> i128
  %3579 = "llvm.mlir.constant"() <{value = 56 : i128}> : () -> i128
  %3580 = "llvm.mlir.constant"() <{value = 72057594037862400 : i64}> : () -> i64
  %3581 = "llvm.mlir.constant"() <{value = 65535 : i64}> : () -> i64
  %3582 = "llvm.mlir.constant"() <{value = 40 : i128}> : () -> i128
  %3583 = "llvm.mlir.constant"() <{value = 1099511627775 : i64}> : () -> i64
  %3584 = "llvm.mlir.constant"() <{value = 5175514460705773 : i128}> : () -> i128
  %3585 = "llvm.mlir.constant"() <{value = 70332060721272408 : i128}> : () -> i128
  %3586 = "llvm.mlir.constant"() <{value = 5342 : i128}> : () -> i128
  %3587 = "llvm.mlir.constant"() <{value = 28 : i128}> : () -> i128
  %3588 = "llvm.mlir.constant"() <{value = 699938952792 : i128}> : () -> i128
  %3589 = "llvm.mlir.constant"() <{value = 113228764141 : i128}> : () -> i128
  %3590 = "llvm.mlir.constant"() <{value = 72057594037927936 : i64}> : () -> i64
  %3591 = "llvm.mlir.constant"() <{value = 1099511627776 : i64}> : () -> i64
  %3592 = "llvm.mlir.constant"() <{value = -5175514460705773 : i64}> : () -> i64
  %3593 = "llvm.mlir.constant"() <{value = 70332060721272408 : i64}> : () -> i64
  %3594 = "llvm.mlir.constant"() <{value = 5342 : i64}> : () -> i64
  %3595 = "llvm.mlir.constant"() <{value = 268435456 : i64}> : () -> i64
  %3596 = "llvm.alloca"(%3560) <{alignment = 8 : i64, elem_type = !llvm.struct<"Scalar", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %3597 = "llvm.alloca"(%3560) <{alignment = 8 : i64, elem_type = !llvm.array<10 x i64>}> : (i32) -> !llvm.ptr
  %3598 = "llvm.alloca"(%3560) <{alignment = 1 : i64, elem_type = !llvm.array<64 x i8>}> : (i32) -> !llvm.ptr
  %3599 = "llvm.alloca"(%3560) <{alignment = 1 : i64, elem_type = !llvm.array<32 x i8>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%3597) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3598) : (!llvm.ptr) -> ()
  "llvm.intr.memcpy"(%3598, %arg61, %3561) <{arg_attrs = [{llvm.align = 1 : i64, llvm.dereferenceable = 64 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 1 : i64, llvm.dereferenceable = 64 : i64, llvm.nonnull, llvm.noundef, llvm.readonly}, {}], isVolatile = false, noalias_scopes = [#alias_scope]}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.br"(%3562)[^bb1] : (i64) -> ()
^bb1(%3600: i64):  // 2 preds: ^bb0, ^bb2
  %3601 = "llvm.icmp"(%3600, %3563) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%3601)[^bb3, ^bb2] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb2:  // pred: ^bb1
  %3602 = "llvm.getelementptr"(%3597, %3600) <{elem_type = !llvm.array<10 x i64>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 0, -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %3603 = "llvm.mul"(%3600, %3564) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %3604 = "llvm.getelementptr"(%3598, %3603) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %3605 = "llvm.load"(%3604) <{alignment = 1 : i64, noalias_scopes = [#alias_scope], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3606 = "llvm.and"(%3605, %3565) : (i64, i64) -> i64
  "llvm.store"(%3606, %3602) <{alignment = 8 : i64, noalias_scopes = [#alias_scope], ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %3607 = "llvm.add"(%3600, %3566) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  "llvm.br"(%3607)[^bb1] : (i64) -> ()
^bb3:  // pred: ^bb1
  %3608 = "llvm.getelementptr"(%arg61) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 63>}> : (!llvm.ptr) -> !llvm.ptr
  %3609 = "llvm.load"(%3608) <{alignment = 1 : i64, noalias_scopes = [#alias_scope], ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %3610 = "llvm.zext"(%3609) : (i8) -> i64
  %3611 = "llvm.load"(%3597) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3612 = "llvm.getelementptr"(%3597) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %3613 = "llvm.load"(%3612) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3614 = "llvm.getelementptr"(%3597) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %3615 = "llvm.load"(%3614) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3616 = "llvm.getelementptr"(%3597) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %3617 = "llvm.load"(%3616) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3618 = "llvm.getelementptr"(%3597) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %3619 = "llvm.load"(%3618) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3620 = "llvm.getelementptr"(%3597) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  %3621 = "llvm.load"(%3620) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3622 = "llvm.getelementptr"(%3597) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 48>}> : (!llvm.ptr) -> !llvm.ptr
  %3623 = "llvm.load"(%3622) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3624 = "llvm.getelementptr"(%3597) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 56>}> : (!llvm.ptr) -> !llvm.ptr
  %3625 = "llvm.load"(%3624) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3626 = "llvm.getelementptr"(%3597) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %3627 = "llvm.load"(%3626) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  "llvm.intr.lifetime.end"(%3597) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3598) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3596) : (!llvm.ptr) -> ()
  %3628 = "llvm.shl"(%3621, %3570) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %3629 = "llvm.and"(%3628, %3573) : (i64, i64) -> i64
  %3630 = "llvm.lshr"(%3619, %3569) : (i64, i64) -> i64
  %3631 = "llvm.or"(%3629, %3630) : (i64, i64) -> i64
  %3632 = "llvm.shl"(%3623, %3570) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %3633 = "llvm.and"(%3632, %3573) : (i64, i64) -> i64
  %3634 = "llvm.lshr"(%3621, %3569) : (i64, i64) -> i64
  %3635 = "llvm.or"(%3633, %3634) : (i64, i64) -> i64
  %3636 = "llvm.shl"(%3625, %3570) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %3637 = "llvm.and"(%3636, %3573) : (i64, i64) -> i64
  %3638 = "llvm.lshr"(%3623, %3569) : (i64, i64) -> i64
  %3639 = "llvm.or"(%3637, %3638) : (i64, i64) -> i64
  %3640 = "llvm.shl"(%3627, %3570) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %3641 = "llvm.and"(%3640, %3573) : (i64, i64) -> i64
  %3642 = "llvm.lshr"(%3625, %3569) : (i64, i64) -> i64
  %3643 = "llvm.or"(%3641, %3642) : (i64, i64) -> i64
  %3644 = "llvm.shl"(%3610, %3570) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %3645 = "llvm.lshr"(%3627, %3569) : (i64, i64) -> i64
  %3646 = "llvm.or"(%3645, %3644) : (i64, i64) -> i64
  %3647 = "llvm.zext"(%3631) <{nonNeg}> : (i64) -> i128
  %3648 = "llvm.mul"(%3647, %3574) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3649 = "llvm.mul"(%3647, %3575) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3650 = "llvm.mul"(%3647, %3576) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3651 = "llvm.mul"(%3647, %3577) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3652 = "llvm.mul"(%3647, %3578) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3653 = "llvm.zext"(%3635) <{nonNeg}> : (i64) -> i128
  %3654 = "llvm.mul"(%3653, %3574) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3655 = "llvm.mul"(%3653, %3575) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3656 = "llvm.mul"(%3653, %3576) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3657 = "llvm.mul"(%3653, %3577) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3658 = "llvm.mul"(%3653, %3578) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3659 = "llvm.zext"(%3639) <{nonNeg}> : (i64) -> i128
  %3660 = "llvm.mul"(%3659, %3574) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3661 = "llvm.mul"(%3659, %3575) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3662 = "llvm.mul"(%3659, %3576) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3663 = "llvm.mul"(%3659, %3577) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3664 = "llvm.mul"(%3659, %3578) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3665 = "llvm.zext"(%3643) <{nonNeg}> : (i64) -> i128
  %3666 = "llvm.mul"(%3665, %3574) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3667 = "llvm.mul"(%3665, %3575) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3668 = "llvm.mul"(%3665, %3576) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3669 = "llvm.mul"(%3665, %3577) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3670 = "llvm.mul"(%3665, %3578) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3671 = "llvm.zext"(%3646) <{nonNeg}> : (i64) -> i128
  %3672 = "llvm.mul"(%3671, %3574) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3673 = "llvm.mul"(%3671, %3575) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3674 = "llvm.mul"(%3671, %3576) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3675 = "llvm.mul"(%3671, %3577) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3676 = "llvm.mul"(%3671, %3578) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3677 = "llvm.add"(%3654, %3649) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3678 = "llvm.add"(%3655, %3650) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3679 = "llvm.add"(%3678, %3660) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3680 = "llvm.add"(%3656, %3651) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3681 = "llvm.add"(%3680, %3661) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3682 = "llvm.add"(%3681, %3666) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3683 = "llvm.add"(%3657, %3652) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3684 = "llvm.add"(%3683, %3662) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3685 = "llvm.add"(%3663, %3658) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3686 = "llvm.add"(%3670, %3675) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3687 = "llvm.lshr"(%3648, %3579) : (i128, i128) -> i128
  %3688 = "llvm.add"(%3677, %3687) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3689 = "llvm.lshr"(%3688, %3579) : (i128, i128) -> i128
  %3690 = "llvm.add"(%3679, %3689) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3691 = "llvm.lshr"(%3690, %3579) : (i128, i128) -> i128
  %3692 = "llvm.add"(%3682, %3691) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3693 = "llvm.lshr"(%3692, %3579) : (i128, i128) -> i128
  %3694 = "llvm.add"(%3684, %3672) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3695 = "llvm.add"(%3694, %3667) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3696 = "llvm.add"(%3695, %3693) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3697 = "llvm.lshr"(%3696, %3579) : (i128, i128) -> i128
  %3698 = "llvm.trunc"(%3696) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %3699 = "llvm.add"(%3685, %3673) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3700 = "llvm.add"(%3699, %3668) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3701 = "llvm.add"(%3700, %3697) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3702 = "llvm.lshr"(%3701, %3579) : (i128, i128) -> i128
  %3703 = "llvm.trunc"(%3701) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %3704 = "llvm.add"(%3674, %3664) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3705 = "llvm.add"(%3704, %3669) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3706 = "llvm.add"(%3705, %3702) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3707 = "llvm.lshr"(%3706, %3579) : (i128, i128) -> i128
  %3708 = "llvm.trunc"(%3706) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %3709 = "llvm.add"(%3686, %3707) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3710 = "llvm.lshr"(%3709, %3579) : (i128, i128) -> i128
  %3711 = "llvm.trunc"(%3709) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %3712 = "llvm.add"(%3710, %3676) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3713 = "llvm.trunc"(%3712) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %3714 = "llvm.shl"(%3703, %3568) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %3715 = "llvm.and"(%3714, %3580) : (i64, i64) -> i64
  %3716 = "llvm.lshr"(%3698, %3571) : (i64, i64) -> i64
  %3717 = "llvm.and"(%3716, %3581) : (i64, i64) -> i64
  %3718 = "llvm.or"(%3715, %3717) <{isDisjoint}> : (i64, i64) -> i64
  %3719 = "llvm.shl"(%3708, %3568) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %3720 = "llvm.and"(%3719, %3580) : (i64, i64) -> i64
  %3721 = "llvm.lshr"(%3703, %3571) : (i64, i64) -> i64
  %3722 = "llvm.and"(%3721, %3581) : (i64, i64) -> i64
  %3723 = "llvm.or"(%3720, %3722) <{isDisjoint}> : (i64, i64) -> i64
  %3724 = "llvm.shl"(%3711, %3568) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %3725 = "llvm.and"(%3724, %3580) : (i64, i64) -> i64
  %3726 = "llvm.lshr"(%3708, %3571) : (i64, i64) -> i64
  %3727 = "llvm.and"(%3726, %3581) : (i64, i64) -> i64
  %3728 = "llvm.or"(%3725, %3727) <{isDisjoint}> : (i64, i64) -> i64
  %3729 = "llvm.shl"(%3713, %3568) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %3730 = "llvm.and"(%3729, %3580) : (i64, i64) -> i64
  %3731 = "llvm.lshr"(%3711, %3571) : (i64, i64) -> i64
  %3732 = "llvm.and"(%3731, %3581) : (i64, i64) -> i64
  %3733 = "llvm.or"(%3730, %3732) <{isDisjoint}> : (i64, i64) -> i64
  %3734 = "llvm.lshr"(%3712, %3582) : (i128, i128) -> i128
  %3735 = "llvm.trunc"(%3734) <{overflowFlags = 3 : i32}> : (i128) -> i64
  %3736 = "llvm.and"(%3735, %3580) : (i64, i64) -> i64
  %3737 = "llvm.lshr"(%3713, %3571) : (i64, i64) -> i64
  %3738 = "llvm.and"(%3737, %3581) : (i64, i64) -> i64
  %3739 = "llvm.or"(%3738, %3736) <{isDisjoint}> : (i64, i64) -> i64
  %3740 = "llvm.and"(%3619, %3583) : (i64, i64) -> i64
  %3741 = "llvm.zext"(%3718) <{nonNeg}> : (i64) -> i128
  %3742 = "llvm.mul"(%3741, %3584) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3743 = "llvm.mul"(%3741, %3585) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3744 = "llvm.mul"(%3741, %3586) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3745 = "llvm.shl"(%3741, %3587) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3746 = "llvm.zext"(%3723) <{nonNeg}> : (i64) -> i128
  %3747 = "llvm.mul"(%3746, %3584) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3748 = "llvm.mul"(%3746, %3585) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3749 = "llvm.mul"(%3746, %3586) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3750 = "llvm.zext"(%3728) <{nonNeg}> : (i64) -> i128
  %3751 = "llvm.mul"(%3750, %3584) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3752 = "llvm.mul"(%3750, %3585) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3753 = "llvm.mul"(%3750, %3586) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3754 = "llvm.zext"(%3733) <{nonNeg}> : (i64) -> i128
  %3755 = "llvm.mul"(%3754, %3584) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3756 = "llvm.mul"(%3754, %3588) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3757 = "llvm.zext"(%3739) <{nonNeg}> : (i64) -> i128
  %3758 = "llvm.mul"(%3757, %3589) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3759 = "llvm.lshr"(%3742, %3579) : (i128, i128) -> i128
  %3760 = "llvm.trunc"(%3742) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %3761 = "llvm.and"(%3760, %3565) : (i64, i64) -> i64
  %3762 = "llvm.add"(%3759, %3743) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3763 = "llvm.add"(%3762, %3747) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3764 = "llvm.lshr"(%3763, %3579) : (i128, i128) -> i128
  %3765 = "llvm.trunc"(%3763) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %3766 = "llvm.and"(%3765, %3565) : (i64, i64) -> i64
  %3767 = "llvm.add"(%3748, %3744) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3768 = "llvm.add"(%3767, %3751) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3769 = "llvm.add"(%3768, %3764) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3770 = "llvm.lshr"(%3769, %3579) : (i128, i128) -> i128
  %3771 = "llvm.trunc"(%3769) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %3772 = "llvm.and"(%3771, %3565) : (i64, i64) -> i64
  %3773 = "llvm.add"(%3752, %3749) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3774 = "llvm.add"(%3773, %3755) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3775 = "llvm.add"(%3774, %3770) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3776 = "llvm.lshr"(%3775, %3579) : (i128, i128) -> i128
  %3777 = "llvm.trunc"(%3775) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %3778 = "llvm.and"(%3777, %3565) : (i64, i64) -> i64
  %3779 = "llvm.add"(%3753, %3745) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3780 = "llvm.add"(%3779, %3756) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3781 = "llvm.add"(%3780, %3758) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3782 = "llvm.add"(%3781, %3776) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %3783 = "llvm.trunc"(%3782) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %3784 = "llvm.and"(%3783, %3583) : (i64, i64) -> i64
  %3785 = "llvm.sub"(%3611, %3761) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %3786 = "llvm.ashr"(%3785, %3567) : (i64, i64) -> i64
  %3787 = "llvm.lshr"(%3785, %3564) : (i64, i64) -> i64
  %3788 = "llvm.and"(%3787, %3590) : (i64, i64) -> i64
  %3789 = "llvm.add"(%3788, %3785) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %3790 = "llvm.add"(%3786, %3613) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %3791 = "llvm.sub"(%3790, %3766) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %3792 = "llvm.ashr"(%3791, %3567) : (i64, i64) -> i64
  %3793 = "llvm.lshr"(%3791, %3564) : (i64, i64) -> i64
  %3794 = "llvm.and"(%3793, %3590) : (i64, i64) -> i64
  %3795 = "llvm.add"(%3794, %3791) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %3796 = "llvm.add"(%3792, %3615) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %3797 = "llvm.sub"(%3796, %3772) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %3798 = "llvm.ashr"(%3797, %3567) : (i64, i64) -> i64
  %3799 = "llvm.lshr"(%3797, %3564) : (i64, i64) -> i64
  %3800 = "llvm.and"(%3799, %3590) : (i64, i64) -> i64
  %3801 = "llvm.add"(%3800, %3797) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %3802 = "llvm.sub"(%3617, %3778) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %3803 = "llvm.add"(%3802, %3798) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %3804 = "llvm.lshr"(%3803, %3567) : (i64, i64) -> i64
  %3805 = "llvm.shl"(%3804, %3572) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %3806 = "llvm.add"(%3805, %3803) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %3807 = "llvm.add"(%3804, %3784) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %3808 = "llvm.icmp"(%3740, %3807) <{predicate = 6 : i64}> : (i64, i64) -> i1
  %3809 = "llvm.select"(%3808, %3591, %3562) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %3810 = "llvm.or"(%3809, %3740) <{isDisjoint}> : (i64, i64) -> i64
  %3811 = "llvm.sub"(%3810, %3807) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %3812 = "llvm.add"(%3789, %3592) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %3813 = "llvm.lshr"(%3812, %3567) : (i64, i64) -> i64
  %3814 = "llvm.shl"(%3813, %3572) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %3815 = "llvm.add"(%3814, %3812) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %3816 = "llvm.or"(%3813, %3593) <{isDisjoint}> : (i64, i64) -> i64
  %3817 = "llvm.sub"(%3795, %3816) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %3818 = "llvm.lshr"(%3817, %3567) : (i64, i64) -> i64
  %3819 = "llvm.shl"(%3818, %3572) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %3820 = "llvm.add"(%3819, %3817) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %3821 = "llvm.or"(%3818, %3594) <{isDisjoint}> : (i64, i64) -> i64
  %3822 = "llvm.sub"(%3801, %3821) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %3823 = "llvm.ashr"(%3822, %3567) : (i64, i64) -> i64
  %3824 = "llvm.lshr"(%3822, %3567) : (i64, i64) -> i64
  %3825 = "llvm.shl"(%3824, %3572) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %3826 = "llvm.add"(%3825, %3822) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %3827 = "llvm.sub"(%3806, %3824) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %3828 = "llvm.lshr"(%3827, %3567) : (i64, i64) -> i64
  %3829 = "llvm.shl"(%3828, %3572) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %3830 = "llvm.add"(%3806, %3823) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %3831 = "llvm.add"(%3830, %3829) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %3832 = "llvm.or"(%3828, %3595) <{isDisjoint}> : (i64, i64) -> i64
  %3833 = "llvm.icmp"(%3811, %3832) <{predicate = 2 : i64}> : (i64, i64) -> i1
  %3834 = "llvm.select"(%3833, %3789, %3815) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %3835 = "llvm.select"(%3833, %3795, %3820) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %3836 = "llvm.select"(%3833, %3801, %3826) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %3837 = "llvm.select"(%3833, %3806, %3831) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %3838 = "llvm.select"(%3833, %3562, %3832) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %3839 = "llvm.sub"(%3811, %3838) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  "llvm.store"(%3834, %3596) <{alignment = 8 : i64, noalias_scopes = [#alias_scope1], ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %3840 = "llvm.getelementptr"(%3596) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3835, %3840) <{alignment = 8 : i64, noalias_scopes = [#alias_scope1], ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %3841 = "llvm.getelementptr"(%3596) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3836, %3841) <{alignment = 8 : i64, noalias_scopes = [#alias_scope1], ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %3842 = "llvm.getelementptr"(%3596) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3837, %3842) <{alignment = 8 : i64, noalias_scopes = [#alias_scope1], ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %3843 = "llvm.getelementptr"(%3596) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3839, %3843) <{alignment = 8 : i64, noalias_scopes = [#alias_scope1], ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.call"(%3599, %3596) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.array<32 x i8>}, {llvm.align = 8 : i64, llvm.nonnull, llvm.readonly}], callee = @Scalar.toBytes, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = write, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3596) : (!llvm.ptr) -> ()
  "llvm.intr.memcpy"(%arg60, %3599, %3570) <{arg_attrs = [{llvm.align = 1 : i64, llvm.dereferenceable = 32 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 1 : i64, llvm.dereferenceable = 32 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
  with @Scalar.toBytes := Scalar_toBytes

end

end MLIR.Zig
