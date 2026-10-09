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
^bb0(%arg61: !llvm.ptr, %arg62: !llvm.ptr, %arg63: i64):
  %868 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %869 = "llvm.mlir.constant"() <{value = 16 : i64}> : () -> i64
  %870 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %871 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %872 = "llvm.mlir.constant"() <{value = 14 : i32}> : () -> i32
  %873 = "llvm.mlir.constant"() <{value = 18 : i32}> : () -> i32
  %874 = "llvm.mlir.constant"() <{value = 41 : i32}> : () -> i32
  %875 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %876 = "llvm.mlir.addressof"() <{global_name = @fd_sha512_core_ref.K}> : () -> !llvm.ptr
  %877 = "llvm.mlir.constant"() <{value = 28 : i32}> : () -> i32
  %878 = "llvm.mlir.constant"() <{value = 34 : i32}> : () -> i32
  %879 = "llvm.mlir.constant"() <{value = 39 : i32}> : () -> i32
  %880 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %881 = "llvm.mlir.constant"() <{value = 15 : i64}> : () -> i64
  %882 = "llvm.mlir.constant"() <{value = 14 : i64}> : () -> i64
  %883 = "llvm.mlir.constant"() <{value = 8 : i32}> : () -> i32
  %884 = "llvm.mlir.constant"() <{value = 7 : i64}> : () -> i64
  %885 = "llvm.mlir.constant"() <{value = 19 : i32}> : () -> i32
  %886 = "llvm.mlir.constant"() <{value = 61 : i32}> : () -> i32
  %887 = "llvm.mlir.constant"() <{value = 6 : i64}> : () -> i64
  %888 = "llvm.mlir.constant"() <{value = 9 : i64}> : () -> i64
  %889 = "llvm.mlir.constant"() <{value = 80 : i64}> : () -> i64
  %890 = "llvm.alloca"(%868) <{alignment = 16 : i64, elem_type = !llvm.array<16 x i64>}> : (i32) -> !llvm.ptr
  %891 = "llvm.getelementptr"(%arg61) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %892 = "llvm.getelementptr"(%arg61) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %893 = "llvm.getelementptr"(%arg61) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %894 = "llvm.getelementptr"(%arg61) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %895 = "llvm.getelementptr"(%arg61) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  %896 = "llvm.getelementptr"(%arg61) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 48>}> : (!llvm.ptr) -> !llvm.ptr
  %897 = "llvm.getelementptr"(%arg61) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 56>}> : (!llvm.ptr) -> !llvm.ptr
  %898 = "llvm.load"(%arg61) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %899 = "llvm.load"(%891) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %900 = "llvm.load"(%892) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %901 = "llvm.load"(%893) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %902 = "llvm.load"(%894) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %903 = "llvm.load"(%895) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %904 = "llvm.load"(%896) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %905 = "llvm.load"(%897) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  "llvm.br"(%905, %904, %903, %902, %901, %900, %899, %898, %arg62, %arg63)[^bb1] : (i64, i64, i64, i64, i64, i64, i64, i64, !llvm.ptr, i64) -> ()
^bb1(%906: i64, %907: i64, %908: i64, %909: i64, %910: i64, %911: i64, %912: i64, %913: i64, %914: !llvm.ptr, %915: i64):  // 2 preds: ^bb0, ^bb4
  "llvm.intr.lifetime.start"(%890) : (!llvm.ptr) -> ()
  "llvm.br"(%913, %912, %911, %910, %909, %908, %870, %906, %907)[^bb2] : (i64, i64, i64, i64, i64, i64, i64, i64, i64) -> ()
^bb2(%916: i64, %917: i64, %918: i64, %919: i64, %920: i64, %921: i64, %922: i64, %923: i64, %924: i64):  // 2 preds: ^bb1, ^bb2
  %925 = "llvm.shl"(%922, %871) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %926 = "llvm.getelementptr"(%914, %925) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %927 = "llvm.load"(%926) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %928 = "llvm.call"(%927) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_ulong_bswap, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (i64) -> i64
  %929 = "llvm.getelementptr"(%890, %922) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%928, %929) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  %930 = "llvm.call"(%920, %872) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ulong_rotate_right, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (i64, i32) -> i64
  %931 = "llvm.call"(%920, %873) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ulong_rotate_right, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (i64, i32) -> i64
  %932 = "llvm.xor"(%931, %930) : (i64, i64) -> i64
  %933 = "llvm.call"(%920, %874) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ulong_rotate_right, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (i64, i32) -> i64
  %934 = "llvm.xor"(%932, %933) : (i64, i64) -> i64
  %935 = "llvm.and"(%920, %921) : (i64, i64) -> i64
  %936 = "llvm.xor"(%920, %875) : (i64, i64) -> i64
  %937 = "llvm.and"(%924, %936) : (i64, i64) -> i64
  %938 = "llvm.or"(%935, %937) <{isDisjoint}> : (i64, i64) -> i64
  %939 = "llvm.getelementptr"(%876, %922) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %940 = "llvm.load"(%939) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %941 = "llvm.add"(%938, %923) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %942 = "llvm.add"(%941, %928) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %943 = "llvm.add"(%942, %934) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %944 = "llvm.add"(%943, %940) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %945 = "llvm.call"(%916, %877) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ulong_rotate_right, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (i64, i32) -> i64
  %946 = "llvm.call"(%916, %878) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ulong_rotate_right, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (i64, i32) -> i64
  %947 = "llvm.xor"(%946, %945) : (i64, i64) -> i64
  %948 = "llvm.call"(%916, %879) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ulong_rotate_right, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (i64, i32) -> i64
  %949 = "llvm.xor"(%947, %948) : (i64, i64) -> i64
  %950 = "llvm.xor"(%917, %918) : (i64, i64) -> i64
  %951 = "llvm.and"(%916, %950) : (i64, i64) -> i64
  %952 = "llvm.and"(%917, %918) : (i64, i64) -> i64
  %953 = "llvm.xor"(%951, %952) : (i64, i64) -> i64
  %954 = "llvm.add"(%944, %919) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %955 = "llvm.add"(%944, %953) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %956 = "llvm.add"(%955, %949) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %957 = "llvm.add"(%922, %880) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %958 = "llvm.icmp"(%957, %869) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%958, %956, %916, %917, %918, %954, %920, %869, %924, %921, %956, %916, %917, %918, %954, %920, %957, %924, %921)[^bb3, ^bb2] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 9, 9>}> : (i1, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64) -> ()
^bb3(%959: i64, %960: i64, %961: i64, %962: i64, %963: i64, %964: i64, %965: i64, %966: i64, %967: i64):  // 2 preds: ^bb2, ^bb3
  %968 = "llvm.add"(%965, %880) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %969 = "llvm.and"(%968, %881) : (i64, i64) -> i64
  %970 = "llvm.getelementptr"(%890, %969) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %971 = "llvm.load"(%970) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %972 = "llvm.add"(%965, %882) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %973 = "llvm.and"(%972, %881) : (i64, i64) -> i64
  %974 = "llvm.getelementptr"(%890, %973) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %975 = "llvm.load"(%974) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %976 = "llvm.call"(%971, %868) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ulong_rotate_right, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (i64, i32) -> i64
  %977 = "llvm.call"(%971, %883) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ulong_rotate_right, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (i64, i32) -> i64
  %978 = "llvm.lshr"(%971, %884) : (i64, i64) -> i64
  %979 = "llvm.xor"(%976, %978) : (i64, i64) -> i64
  %980 = "llvm.xor"(%979, %977) : (i64, i64) -> i64
  %981 = "llvm.call"(%975, %885) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ulong_rotate_right, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (i64, i32) -> i64
  %982 = "llvm.call"(%975, %886) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ulong_rotate_right, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (i64, i32) -> i64
  %983 = "llvm.lshr"(%975, %887) : (i64, i64) -> i64
  %984 = "llvm.xor"(%981, %983) : (i64, i64) -> i64
  %985 = "llvm.xor"(%984, %982) : (i64, i64) -> i64
  %986 = "llvm.add"(%965, %888) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %987 = "llvm.and"(%986, %881) : (i64, i64) -> i64
  %988 = "llvm.getelementptr"(%890, %987) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %989 = "llvm.load"(%988) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %990 = "llvm.and"(%965, %881) : (i64, i64) -> i64
  %991 = "llvm.getelementptr"(%890, %990) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %992 = "llvm.load"(%991) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %993 = "llvm.add"(%989, %980) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %994 = "llvm.add"(%993, %985) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %995 = "llvm.add"(%994, %992) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%995, %991) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  %996 = "llvm.call"(%963, %872) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ulong_rotate_right, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (i64, i32) -> i64
  %997 = "llvm.call"(%963, %873) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ulong_rotate_right, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (i64, i32) -> i64
  %998 = "llvm.xor"(%997, %996) : (i64, i64) -> i64
  %999 = "llvm.call"(%963, %874) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ulong_rotate_right, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (i64, i32) -> i64
  %1000 = "llvm.xor"(%998, %999) : (i64, i64) -> i64
  %1001 = "llvm.and"(%963, %964) : (i64, i64) -> i64
  %1002 = "llvm.xor"(%963, %875) : (i64, i64) -> i64
  %1003 = "llvm.and"(%967, %1002) : (i64, i64) -> i64
  %1004 = "llvm.or"(%1001, %1003) : (i64, i64) -> i64
  %1005 = "llvm.getelementptr"(%876, %965) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1006 = "llvm.load"(%1005) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %1007 = "llvm.add"(%1004, %966) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1008 = "llvm.add"(%1007, %995) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1009 = "llvm.add"(%1008, %1000) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1010 = "llvm.add"(%1009, %1006) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1011 = "llvm.call"(%959, %877) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ulong_rotate_right, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (i64, i32) -> i64
  %1012 = "llvm.call"(%959, %878) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ulong_rotate_right, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (i64, i32) -> i64
  %1013 = "llvm.xor"(%1012, %1011) : (i64, i64) -> i64
  %1014 = "llvm.call"(%959, %879) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_ulong_rotate_right, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (i64, i32) -> i64
  %1015 = "llvm.xor"(%1013, %1014) : (i64, i64) -> i64
  %1016 = "llvm.xor"(%960, %961) : (i64, i64) -> i64
  %1017 = "llvm.and"(%959, %1016) : (i64, i64) -> i64
  %1018 = "llvm.and"(%960, %961) : (i64, i64) -> i64
  %1019 = "llvm.xor"(%1017, %1018) : (i64, i64) -> i64
  %1020 = "llvm.add"(%1010, %962) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1021 = "llvm.add"(%1010, %1019) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1022 = "llvm.add"(%1021, %1015) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1023 = "llvm.icmp"(%968, %889) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1023, %1022, %959, %960, %961, %1020, %963, %968, %967, %964)[^bb4, ^bb3] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 9>}> : (i1, i64, i64, i64, i64, i64, i64, i64, i64, i64) -> ()
^bb4:  // pred: ^bb3
  %1024 = "llvm.add"(%1022, %913) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%1024, %arg61) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  %1025 = "llvm.add"(%959, %912) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%1025, %891) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  %1026 = "llvm.add"(%960, %911) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%1026, %892) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  %1027 = "llvm.add"(%961, %910) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%1027, %893) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  %1028 = "llvm.add"(%1020, %909) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%1028, %894) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  %1029 = "llvm.add"(%963, %908) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%1029, %895) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  %1030 = "llvm.add"(%964, %907) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%1030, %896) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  %1031 = "llvm.add"(%967, %906) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.store"(%1031, %897) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  %1032 = "llvm.getelementptr"(%914) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.lifetime.end"(%890) : (!llvm.ptr) -> ()
  %1033 = "llvm.add"(%915, %875) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1034 = "llvm.icmp"(%1033, %870) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1034, %1031, %1030, %1029, %1028, %1027, %1026, %1025, %1024, %1032, %1033)[^bb5, ^bb1] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 10>}> : (i1, i64, i64, i64, i64, i64, i64, i64, i64, !llvm.ptr, i64) -> ()
^bb5:  // pred: ^bb4
  "llvm.return"() : () -> ()
}) : () -> ()
  with @fd_ulong_bswap := fd_ulong_bswap, @fd_ulong_rotate_right := fd_ulong_rotate_right,
    @fd_sha512_core_ref.K := fd_sha512_core_ref_K

end

end MLIR.Firedancer.Ref
