module

-- zig-build/out/op/Scalar.add.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Zig

@[expose] public section

mlir_def Scalar_add :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.noalias, llvm.nocapture, llvm.nonnull, llvm.sret = !llvm.struct<"Scalar", (array<5 x i64>)>, llvm.writeonly}, {llvm.align = 8 : i64, llvm.nocapture, llvm.nonnull, llvm.readonly}, {llvm.align = 8 : i64, llvm.nocapture, llvm.nonnull, llvm.readonly}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, minsize, no_unwind, optsize, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["target-cpu", "x86-64"]], sym_name = "Scalar.add", target_cpu = "x86-64", target_features = #llvm.target_features<["+64bit", "+cmov", "+cx8", "+fxsr", "+idivq-to-divl", "+macrofusion", "+mmx", "+nopl", "+slow-3ops-lea", "+slow-incdec", "+vzeroupper", "+x87", "-16bit-mode", "-32bit-mode", "-adx", "-aes", "-allow-light-256-bit", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tf32", "-amx-tile", "-amx-transpose", "-avx", "-avx10.1-256", "-avx10.1-512", "-avx10.2-256", "-avx10.2-512", "-avx2", "-avx512bf16", "-avx512bitalg", "-avx512bw", "-avx512cd", "-avx512dq", "-avx512f", "-avx512fp16", "-avx512ifma", "-avx512vbmi", "-avx512vbmi2", "-avx512vl", "-avx512vnni", "-avx512vp2intersect", "-avx512vpopcntdq", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-bmi", "-bmi2", "-branch-hint", "-branchfusion", "-ccmp", "-cf", "-cldemote", "-clflushopt", "-clwb", "-clzero", "-cmpccxadd", "-crc32", "-cx16", "-egpr", "-enqcmd", "-ermsb", "-evex512", "-f16c", "-false-deps-getmant", "-false-deps-lzcnt-tzcnt", "-false-deps-mulc", "-false-deps-mullq", "-false-deps-perm", "-false-deps-popcnt", "-false-deps-range", "-fast-11bytenop", "-fast-15bytenop", "-fast-7bytenop", "-fast-bextr", "-fast-dpwssd", "-fast-gather", "-fast-hops", "-fast-imm16", "-fast-lzcnt", "-fast-movbe", "-fast-scalar-fsqrt", "-fast-scalar-shift-masks", "-fast-shld-rotate", "-fast-variable-crosslane-shuffle", "-fast-variable-perlane-shuffle", "-fast-vector-fsqrt", "-fast-vector-shift-masks", "-faster-shift-than-shuffle", "-fma", "-fma4", "-fsgsbase", "-fsrm", "-gfni", "-harden-sls-ijmp", "-harden-sls-ret", "-hreset", "-idivl-to-divb", "-inline-asm-use-gpr32", "-invpcid", "-kl", "-lea-sp", "-lea-uses-ag", "-lvi-cfi", "-lvi-load-hardening", "-lwp", "-lzcnt", "-movbe", "-movdir64b", "-movdiri", "-movrs", "-mwaitx", "-ndd", "-nf", "-no-bypass-delay", "-no-bypass-delay-blend", "-no-bypass-delay-mov", "-no-bypass-delay-shuffle", "-pad-short-functions", "-pclmul", "-pconfig", "-pku", "-popcnt", "-ppx", "-prefer-128-bit", "-prefer-256-bit", "-prefer-mask-registers", "-prefer-movmsk-over-vtest", "-prefer-no-gather", "-prefer-no-scatter", "-prefetchi", "-prfchw", "-ptwrite", "-push2pop2", "-raoint", "-rdpid", "-rdpru", "-rdrnd", "-rdseed", "-retpoline", "-retpoline-external-thunk", "-retpoline-indirect-branches", "-retpoline-indirect-calls", "-rtm", "-sahf", "-sbb-dep-breaking", "-serialize", "-seses", "-sgx", "-sha", "-sha512", "-shstk", "-slow-lea", "-slow-pmaddwd", "-slow-pmulld", "-slow-shld", "-slow-two-mem-ops", "-slow-unaligned-mem-16", "-slow-unaligned-mem-32", "-sm3", "-sm4", "-soft-float", "-sse", "-sse2", "-sse3", "-sse4.1", "-sse4.2", "-sse4a", "-sse-unaligned-mem", "-ssse3", "-tagged-globals", "-tbm", "-tsxldtrk", "-tuning-fast-imm-vector-shift", "-uintr", "-use-glm-div-sqrt-costs", "-use-slm-arith-costs", "-usermsr", "-vaes", "-vpclmulqdq", "-waitpkg", "-wbnoinvd", "-widekl", "-xop", "-xsave", "-xsavec", "-xsaveopt", "-xsaves", "-zu"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg35: !llvm.ptr, %arg36: !llvm.ptr, %arg37: !llvm.ptr):
  %820 = "llvm.mlir.constant"() <{value = 56 : i64}> : () -> i64
  %821 = "llvm.mlir.constant"() <{value = 72057594037927935 : i64}> : () -> i64
  %822 = "llvm.mlir.constant"() <{value = -5175514460705773 : i64}> : () -> i64
  %823 = "llvm.mlir.constant"() <{value = 63 : i64}> : () -> i64
  %824 = "llvm.mlir.constant"() <{value = 70332060721272408 : i64}> : () -> i64
  %825 = "llvm.mlir.constant"() <{value = 72057594037927936 : i64}> : () -> i64
  %826 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %827 = "llvm.mlir.constant"() <{value = -5343 : i64}> : () -> i64
  %828 = "llvm.mlir.constant"() <{value = -5342 : i64}> : () -> i64
  %829 = "llvm.mlir.constant"() <{value = 5343 : i64}> : () -> i64
  %830 = "llvm.mlir.constant"() <{value = 5342 : i64}> : () -> i64
  %831 = "llvm.mlir.constant"() <{value = -268435457 : i64}> : () -> i64
  %832 = "llvm.mlir.constant"() <{value = -268435456 : i64}> : () -> i64
  %833 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %834 = "llvm.load"(%arg36) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %835 = "llvm.load"(%arg37) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %836 = "llvm.add"(%835, %834) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %837 = "llvm.lshr"(%836, %820) : (i64, i64) -> i64
  %838 = "llvm.and"(%836, %821) : (i64, i64) -> i64
  %839 = "llvm.getelementptr"(%arg36) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %840 = "llvm.load"(%839) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %841 = "llvm.getelementptr"(%arg37) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %842 = "llvm.load"(%841) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %843 = "llvm.add"(%842, %840) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %844 = "llvm.add"(%843, %837) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %845 = "llvm.lshr"(%844, %820) : (i64, i64) -> i64
  %846 = "llvm.and"(%844, %821) : (i64, i64) -> i64
  %847 = "llvm.getelementptr"(%arg36) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %848 = "llvm.load"(%847) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %849 = "llvm.getelementptr"(%arg37) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %850 = "llvm.load"(%849) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %851 = "llvm.add"(%850, %848) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %852 = "llvm.add"(%851, %845) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %853 = "llvm.lshr"(%852, %820) : (i64, i64) -> i64
  %854 = "llvm.and"(%852, %821) : (i64, i64) -> i64
  %855 = "llvm.getelementptr"(%arg36) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %856 = "llvm.load"(%855) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %857 = "llvm.getelementptr"(%arg37) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %858 = "llvm.load"(%857) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %859 = "llvm.add"(%858, %856) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %860 = "llvm.add"(%859, %853) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %861 = "llvm.lshr"(%860, %820) : (i64, i64) -> i64
  %862 = "llvm.and"(%860, %821) : (i64, i64) -> i64
  %863 = "llvm.getelementptr"(%arg36) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %864 = "llvm.load"(%863) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %865 = "llvm.getelementptr"(%arg37) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %866 = "llvm.load"(%865) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %867 = "llvm.add"(%866, %864) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %868 = "llvm.add"(%867, %861) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %869 = "llvm.add"(%838, %822) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %870 = "llvm.lshr"(%869, %823) : (i64, i64) -> i64
  %871 = "llvm.shl"(%870, %820) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %872 = "llvm.add"(%869, %871) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %873 = "llvm.or"(%870, %824) <{isDisjoint}> : (i64, i64) -> i64
  %874 = "llvm.icmp"(%846, %873) <{predicate = 6 : i64}> : (i64, i64) -> i1
  %875 = "llvm.select"(%874, %825, %826) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %876 = "llvm.sub"(%846, %873) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %877 = "llvm.add"(%876, %875) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %878 = "llvm.select"(%874, %827, %828) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %879 = "llvm.select"(%874, %829, %830) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %880 = "llvm.icmp"(%854, %879) <{predicate = 6 : i64}> : (i64, i64) -> i1
  %881 = "llvm.sext"(%880) : (i1) -> i64
  %882 = "llvm.select"(%880, %825, %826) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %883 = "llvm.add"(%878, %854) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %884 = "llvm.add"(%883, %882) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %885 = "llvm.icmp"(%862, %826) <{predicate = 0 : i64}> : (i64, i64) -> i1
  %886 = "llvm.and"(%885, %880) : (i1, i1) -> i1
  %887 = "llvm.select"(%886, %825, %826) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %888 = "llvm.add"(%862, %881) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %889 = "llvm.add"(%888, %887) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %890 = "llvm.select"(%886, %831, %832) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %891 = "llvm.add"(%890, %868) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %892 = "llvm.lshr"(%891, %823) : (i64, i64) -> i64
  %893 = "llvm.shl"(%892, %820) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %894 = "llvm.add"(%891, %893) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %895 = "llvm.add"(%892, %833) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %896 = "llvm.xor"(%872, %838) : (i64, i64) -> i64
  %897 = "llvm.and"(%895, %896) : (i64, i64) -> i64
  %898 = "llvm.xor"(%897, %838) : (i64, i64) -> i64
  %899 = "llvm.xor"(%877, %846) : (i64, i64) -> i64
  %900 = "llvm.and"(%895, %899) : (i64, i64) -> i64
  %901 = "llvm.xor"(%900, %846) : (i64, i64) -> i64
  %902 = "llvm.xor"(%884, %854) : (i64, i64) -> i64
  %903 = "llvm.and"(%895, %902) : (i64, i64) -> i64
  %904 = "llvm.xor"(%903, %854) : (i64, i64) -> i64
  %905 = "llvm.xor"(%889, %862) : (i64, i64) -> i64
  %906 = "llvm.and"(%895, %905) : (i64, i64) -> i64
  %907 = "llvm.xor"(%906, %862) : (i64, i64) -> i64
  %908 = "llvm.xor"(%894, %868) : (i64, i64) -> i64
  %909 = "llvm.and"(%908, %895) : (i64, i64) -> i64
  %910 = "llvm.xor"(%909, %868) : (i64, i64) -> i64
  "llvm.store"(%898, %arg35) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %911 = "llvm.getelementptr"(%arg35) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%901, %911) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %912 = "llvm.getelementptr"(%arg35) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%904, %912) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %913 = "llvm.getelementptr"(%arg35) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%907, %913) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %914 = "llvm.getelementptr"(%arg35) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%910, %914) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end MLIR.Zig
