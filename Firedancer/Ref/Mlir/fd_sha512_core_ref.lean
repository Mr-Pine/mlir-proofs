module

-- build/llvm23/mlir_canonicalized/ref/op/fd_sha512_core_ref.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Ref.Mlir.fd_ulong_bswap
public import Firedancer.Ref.Mlir.fd_ulong_rotate_right
public import Firedancer.Ref.Mlir.fd_sha512_core_ref_K

meta import MLIR.Semantics.Func
meta import Firedancer.Ref.Mlir.fd_ulong_bswap
meta import Firedancer.Ref.Mlir.fd_ulong_rotate_right
meta import Firedancer.Ref.Mlir.fd_sha512_core_ref_K

namespace MLIR.Firedancer.Ref

@[expose] public section

mlir_def fd_sha512_core_ref :=
#loop_unroll = #llvm.loop_unroll<disable = true>
#tbaa_root = #llvm.tbaa_root<id = "Simple C/C++ TBAA">
#loop_annotation = #llvm.loop_annotation<unroll = #loop_unroll, mustProgress = true>
#tbaa_type_desc = #llvm.tbaa_type_desc<id = "omnipotent char", members = {<#tbaa_root, 0>}>
#tbaa_type_desc1 = #llvm.tbaa_type_desc<id = "long", members = {<#tbaa_type_desc, 0>}>
#tbaa_tag1 = #llvm.tbaa_tag<base_type = #tbaa_type_desc1, access_type = #tbaa_type_desc1, offset = 0>
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.noundef, llvm.range = #llvm.constant_range<i64, 1, 144115188075855872>}], dso_local, function_type = !llvm.func<void (ptr, ptr, i64)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], sym_name = "fd_sha512_core_ref", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg57: !llvm.ptr, %arg58: !llvm.ptr, %arg59: i64):
  %866 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %867 = "llvm.mlir.constant"() <{value = 16 : i64}> : () -> i64
  %868 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %869 = "llvm.mlir.constant"() <{value = 14 : i32}> : () -> i32
  %870 = "llvm.mlir.constant"() <{value = 18 : i32}> : () -> i32
  %871 = "llvm.mlir.constant"() <{value = 41 : i32}> : () -> i32
  %872 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %873 = "llvm.mlir.addressof"() <{global_name = @fd_sha512_core_ref.K}> : () -> !llvm.ptr
  %874 = "llvm.mlir.constant"() <{value = 28 : i32}> : () -> i32
  %875 = "llvm.mlir.constant"() <{value = 34 : i32}> : () -> i32
  %876 = "llvm.mlir.constant"() <{value = 39 : i32}> : () -> i32
  %877 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %878 = "llvm.mlir.constant"() <{value = 15 : i64}> : () -> i64
  %879 = "llvm.mlir.constant"() <{value = 14 : i64}> : () -> i64
  %880 = "llvm.mlir.constant"() <{value = 8 : i32}> : () -> i32
  %881 = "llvm.mlir.constant"() <{value = 7 : i64}> : () -> i64
  %882 = "llvm.mlir.constant"() <{value = 19 : i32}> : () -> i32
  %883 = "llvm.mlir.constant"() <{value = 61 : i32}> : () -> i32
  %884 = "llvm.mlir.constant"() <{value = 6 : i64}> : () -> i64
  %885 = "llvm.mlir.constant"() <{value = 9 : i64}> : () -> i64
  %886 = "llvm.mlir.constant"() <{value = 80 : i64}> : () -> i64
  %887 = "llvm.alloca"(%866) <{alignment = 16 : i64, elem_type = !llvm.array<16 x i64>}> : (i32) -> !llvm.ptr
  %888 = "llvm.getelementptr"(%arg57) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %889 = "llvm.getelementptr"(%arg57) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %890 = "llvm.getelementptr"(%arg57) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %891 = "llvm.getelementptr"(%arg57) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %892 = "llvm.getelementptr"(%arg57) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  %893 = "llvm.getelementptr"(%arg57) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 48>}> : (!llvm.ptr) -> !llvm.ptr
  %894 = "llvm.getelementptr"(%arg57) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 56>}> : (!llvm.ptr) -> !llvm.ptr
  %895 = "llvm.load"(%arg57) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %896 = "llvm.load"(%888) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %897 = "llvm.load"(%889) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %898 = "llvm.load"(%890) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %899 = "llvm.load"(%891) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %900 = "llvm.load"(%892) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %901 = "llvm.load"(%893) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %902 = "llvm.load"(%894) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  "llvm.br"(%902, %901, %900, %899, %898, %897, %896, %895, %arg58, %arg59)[^bb1] : (i64, i64, i64, i64, i64, i64, i64, i64, !llvm.ptr, i64) -> ()
^bb1(%903: i64, %904: i64, %905: i64, %906: i64, %907: i64, %908: i64, %909: i64, %910: i64, %911: !llvm.ptr, %912: i64):  // 2 preds: ^bb0, ^bb4
  "llvm.intr.lifetime.start"(%887) : (!llvm.ptr) -> ()
  "llvm.br"(%910, %909, %908, %907, %868, %903, %904, %905, %906)[^bb2] : (i64, i64, i64, i64, i64, i64, i64, i64, i64) -> ()
^bb2(%913: i64, %914: i64, %915: i64, %916: i64, %917: i64, %918: i64, %919: i64, %920: i64, %921: i64):  // 2 preds: ^bb1, ^bb2
  %922 = "llvm.getelementptr"(%911, %917) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %923 = "llvm.load"(%922) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %924 = "llvm.call"(%923) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_ulong_bswap, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (i64) -> i64
  %925 = "llvm.getelementptr"(%887, %917) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%924, %925) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  %926 = "llvm.call"(%921, %869) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ulong_rotate_right, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (i64, i32) -> i64
  %927 = "llvm.call"(%921, %870) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ulong_rotate_right, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (i64, i32) -> i64
  %928 = "llvm.xor"(%927, %926) : (i64, i64) -> i64
  %929 = "llvm.call"(%921, %871) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ulong_rotate_right, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (i64, i32) -> i64
  %930 = "llvm.xor"(%928, %929) : (i64, i64) -> i64
  %931 = "llvm.and"(%920, %921) : (i64, i64) -> i64
  %932 = "llvm.xor"(%921, %872) : (i64, i64) -> i64
  %933 = "llvm.and"(%919, %932) : (i64, i64) -> i64
  %934 = "llvm.or"(%933, %931) <{isDisjoint}> : (i64, i64) -> i64
  %935 = "llvm.getelementptr"(%873, %917) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %936 = "llvm.load"(%935) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %937 = "llvm.add"(%934, %918) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %938 = "llvm.add"(%937, %924) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %939 = "llvm.add"(%938, %930) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %940 = "llvm.add"(%939, %936) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %941 = "llvm.call"(%913, %874) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ulong_rotate_right, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (i64, i32) -> i64
  %942 = "llvm.call"(%913, %875) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ulong_rotate_right, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (i64, i32) -> i64
  %943 = "llvm.xor"(%942, %941) : (i64, i64) -> i64
  %944 = "llvm.call"(%913, %876) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ulong_rotate_right, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (i64, i32) -> i64
  %945 = "llvm.xor"(%943, %944) : (i64, i64) -> i64
  %946 = "llvm.xor"(%914, %915) : (i64, i64) -> i64
  %947 = "llvm.and"(%913, %946) : (i64, i64) -> i64
  %948 = "llvm.and"(%914, %915) : (i64, i64) -> i64
  %949 = "llvm.xor"(%947, %948) : (i64, i64) -> i64
  %950 = "llvm.add"(%940, %916) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %951 = "llvm.add"(%940, %949) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %952 = "llvm.add"(%951, %945) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %953 = "llvm.add"(%917, %877) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %954 = "llvm.icmp"(%953, %867) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%954, %952, %913, %914, %915, %867, %919, %920, %921, %950, %952, %913, %914, %915, %953, %919, %920, %921, %950)[^bb3, ^bb2] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 9, 9>}> : (i1, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64) -> ()
^bb3(%955: i64, %956: i64, %957: i64, %958: i64, %959: i64, %960: i64, %961: i64, %962: i64, %963: i64):  // 2 preds: ^bb2, ^bb3
  %964 = "llvm.add"(%959, %877) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %965 = "llvm.and"(%964, %878) : (i64, i64) -> i64
  %966 = "llvm.getelementptr"(%887, %965) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %967 = "llvm.load"(%966) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %968 = "llvm.add"(%959, %879) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %969 = "llvm.and"(%968, %878) : (i64, i64) -> i64
  %970 = "llvm.getelementptr"(%887, %969) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %971 = "llvm.load"(%970) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %972 = "llvm.call"(%967, %866) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ulong_rotate_right, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (i64, i32) -> i64
  %973 = "llvm.call"(%967, %880) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ulong_rotate_right, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (i64, i32) -> i64
  %974 = "llvm.lshr"(%967, %881) : (i64, i64) -> i64
  %975 = "llvm.xor"(%972, %974) : (i64, i64) -> i64
  %976 = "llvm.xor"(%975, %973) : (i64, i64) -> i64
  %977 = "llvm.call"(%971, %882) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ulong_rotate_right, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (i64, i32) -> i64
  %978 = "llvm.call"(%971, %883) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ulong_rotate_right, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (i64, i32) -> i64
  %979 = "llvm.lshr"(%971, %884) : (i64, i64) -> i64
  %980 = "llvm.xor"(%977, %979) : (i64, i64) -> i64
  %981 = "llvm.xor"(%980, %978) : (i64, i64) -> i64
  %982 = "llvm.add"(%959, %885) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %983 = "llvm.and"(%982, %878) : (i64, i64) -> i64
  %984 = "llvm.getelementptr"(%887, %983) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %985 = "llvm.load"(%984) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %986 = "llvm.and"(%959, %878) : (i64, i64) -> i64
  %987 = "llvm.getelementptr"(%887, %986) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %988 = "llvm.load"(%987) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %989 = "llvm.add"(%985, %976) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %990 = "llvm.add"(%989, %981) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %991 = "llvm.add"(%990, %988) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%991, %987) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  %992 = "llvm.call"(%963, %869) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ulong_rotate_right, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (i64, i32) -> i64
  %993 = "llvm.call"(%963, %870) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ulong_rotate_right, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (i64, i32) -> i64
  %994 = "llvm.xor"(%993, %992) : (i64, i64) -> i64
  %995 = "llvm.call"(%963, %871) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ulong_rotate_right, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (i64, i32) -> i64
  %996 = "llvm.xor"(%994, %995) : (i64, i64) -> i64
  %997 = "llvm.and"(%962, %963) : (i64, i64) -> i64
  %998 = "llvm.xor"(%963, %872) : (i64, i64) -> i64
  %999 = "llvm.and"(%961, %998) : (i64, i64) -> i64
  %1000 = "llvm.or"(%999, %997) <{isDisjoint}> : (i64, i64) -> i64
  %1001 = "llvm.getelementptr"(%873, %959) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1002 = "llvm.load"(%1001) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %1003 = "llvm.add"(%1000, %960) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1004 = "llvm.add"(%1003, %991) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1005 = "llvm.add"(%1004, %996) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1006 = "llvm.add"(%1005, %1002) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1007 = "llvm.call"(%955, %874) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ulong_rotate_right, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (i64, i32) -> i64
  %1008 = "llvm.call"(%955, %875) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ulong_rotate_right, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (i64, i32) -> i64
  %1009 = "llvm.xor"(%1008, %1007) : (i64, i64) -> i64
  %1010 = "llvm.call"(%955, %876) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ulong_rotate_right, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (i64, i32) -> i64
  %1011 = "llvm.xor"(%1009, %1010) : (i64, i64) -> i64
  %1012 = "llvm.xor"(%956, %957) : (i64, i64) -> i64
  %1013 = "llvm.and"(%955, %1012) : (i64, i64) -> i64
  %1014 = "llvm.and"(%956, %957) : (i64, i64) -> i64
  %1015 = "llvm.xor"(%1013, %1014) : (i64, i64) -> i64
  %1016 = "llvm.add"(%1006, %958) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1017 = "llvm.add"(%1006, %1015) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1018 = "llvm.add"(%1017, %1011) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1019 = "llvm.icmp"(%964, %886) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1019, %1018, %955, %956, %957, %964, %961, %962, %963, %1016)[^bb4, ^bb3] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 9>}> : (i1, i64, i64, i64, i64, i64, i64, i64, i64, i64) -> ()
^bb4:  // pred: ^bb3
  %1020 = "llvm.add"(%1018, %910) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%1020, %arg57) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  %1021 = "llvm.add"(%955, %909) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%1021, %888) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  %1022 = "llvm.add"(%956, %908) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%1022, %889) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  %1023 = "llvm.add"(%957, %907) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%1023, %890) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  %1024 = "llvm.add"(%1016, %906) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%1024, %891) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  %1025 = "llvm.add"(%963, %905) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%1025, %892) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  %1026 = "llvm.add"(%962, %904) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%1026, %893) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  %1027 = "llvm.add"(%961, %903) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%1027, %894) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  %1028 = "llvm.getelementptr"(%911) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.lifetime.end"(%887) : (!llvm.ptr) -> ()
  %1029 = "llvm.add"(%912, %872) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1030 = "llvm.icmp"(%1029, %868) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1030, %1027, %1026, %1025, %1024, %1023, %1022, %1021, %1020, %1028, %1029)[^bb5, ^bb1] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 10>}> : (i1, i64, i64, i64, i64, i64, i64, i64, i64, !llvm.ptr, i64) -> ()
^bb5:  // pred: ^bb4
  "llvm.return"() : () -> ()
}) : () -> ()
  with @fd_ulong_bswap := fd_ulong_bswap, @fd_ulong_rotate_right := fd_ulong_rotate_right,
    @fd_sha512_core_ref.K := fd_sha512_core_ref_K

end

end MLIR.Firedancer.Ref
