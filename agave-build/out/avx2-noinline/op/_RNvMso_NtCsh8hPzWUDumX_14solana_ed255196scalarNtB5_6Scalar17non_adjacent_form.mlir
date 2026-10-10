#alias_scope_domain123 = #llvm.alias_scope_domain<id = distinct[123]<>, description = "_RNvNtCsh8hPzWUDumX_14solana_ed255196scalar16read_le_u64_into">
#alias_scope214 = #llvm.alias_scope<id = distinct[356]<>, domain = #alias_scope_domain123, description = "_RNvNtCsh8hPzWUDumX_14solana_ed255196scalar16read_le_u64_into: argument 0">
#alias_scope215 = #llvm.alias_scope<id = distinct[357]<>, domain = #alias_scope_domain123, description = "_RNvNtCsh8hPzWUDumX_14solana_ed255196scalar16read_le_u64_into: argument 1">
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 1 : i64, llvm.dead_on_unwind, llvm.dereferenceable = 256 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writable, llvm.writeonly}, {llvm.dereferenceable = 32 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.noundef, llvm.range = #llvm.constant_range<i64, 5, 9>}], dso_local, function_type = !llvm.func<void (ptr, ptr, i64)>, linkage = #llvm.linkage<internal>, passthrough = ["nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], personality = @rust_eh_personality, sym_name = "_RNvMso_NtCsh8hPzWUDumX_14solana_ed255196scalarNtB5_6Scalar17non_adjacent_form", target_cpu = "x86-64-v2", target_features = #llvm.target_features<["+avx", "+avx2", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+crc32", "+ssse3"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg20: !llvm.ptr, %arg21: !llvm.ptr, %arg22: i64):
  %1007 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1008 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %1009 = "llvm.mlir.constant"() <{value = 256 : i64}> : () -> i64
  %1010 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
  %1011 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %1012 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %1013 = "llvm.mlir.constant"() <{value = 64 : i64}> : () -> i64
  %1014 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %1015 = "llvm.mlir.constant"() <{value = 6 : i64}> : () -> i64
  %1016 = "llvm.mlir.constant"() <{value = 63 : i64}> : () -> i64
  %1017 = "llvm.alloca"(%1007) <{alignment = 8 : i64, elem_type = !llvm.array<40 x i8>}> : (i32) -> !llvm.ptr
  "llvm.intr.memset"(%arg20, %1008, %1009) <{arg_attrs = [{llvm.align = 1 : i64, llvm.dereferenceable = 256 : i64, llvm.nonnull, llvm.noundef}, {}, {}], isVolatile = false}> : (!llvm.ptr, i8, i64) -> ()
  "llvm.intr.lifetime.start"(%1017) : (!llvm.ptr) -> ()
  "llvm.intr.memset"(%1017, %1008, %1010) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {}, {}], isVolatile = false}> : (!llvm.ptr, i8, i64) -> ()
  "llvm.intr.experimental.noalias.scope.decl"() <{scope = #alias_scope214}> : () -> ()
  "llvm.intr.experimental.noalias.scope.decl"() <{scope = #alias_scope215}> : () -> ()
  %1018 = "llvm.load"(%arg21) <{alias_scopes = [#alias_scope214], alignment = 1 : i64, noalias_scopes = [#alias_scope215], ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.store"(%1018, %1017) <{alias_scopes = [#alias_scope215], alignment = 8 : i64, noalias_scopes = [#alias_scope214], ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %1019 = "llvm.shl"(%1011, %arg22) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1020 = "llvm.add"(%1019, %1012) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1021 = "llvm.sub"(%1013, %arg22) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1022 = "llvm.lshr"(%1019, %1011) <{isExact}> : (i64, i64) -> i64
  %1023 = "llvm.trunc"(%1019) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.br"(%1014, %1014)[^bb1] : (i64, i64) -> ()
^bb1(%1024: i64, %1025: i64):  // 2 preds: ^bb0, ^bb7
  "llvm.br"(%1024)[^bb3] : (i64) -> ()
^bb2:  // 2 preds: ^bb6, ^bb7
  "llvm.intr.lifetime.end"(%1017) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
^bb3(%1026: i64):  // 2 preds: ^bb1, ^bb6
  %1027 = "llvm.lshr"(%1026, %1015) : (i64, i64) -> i64
  %1028 = "llvm.and"(%1026, %1016) : (i64, i64) -> i64
  %1029 = "llvm.icmp"(%1028, %1021) <{predicate = 6 : i64}> : (i64, i64) -> i1
  %1030 = "llvm.getelementptr"(%1017, %1027) <{elem_type = i64, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1031 = "llvm.load"(%1030) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1032 = "llvm.lshr"(%1031, %1028) : (i64, i64) -> i64
  "llvm.cond_br"(%1029, %1032)[^bb5, ^bb4] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
^bb4:  // pred: ^bb3
  %1033 = "llvm.getelementptr"(%1030) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %1034 = "llvm.load"(%1033) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1035 = "llvm.sub"(%1014, %1026) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %1036 = "llvm.and"(%1035, %1016) : (i64, i64) -> i64
  %1037 = "llvm.shl"(%1034, %1036) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1038 = "llvm.or"(%1037, %1032) : (i64, i64) -> i64
  "llvm.br"(%1038)[^bb5] : (i64) -> ()
^bb5(%1039: i64):  // 2 preds: ^bb3, ^bb4
  %1040 = "llvm.and"(%1039, %1020) : (i64, i64) -> i64
  %1041 = "llvm.add"(%1040, %1025) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1042 = "llvm.and"(%1041, %1011) : (i64, i64) -> i64
  %1043 = "llvm.icmp"(%1042, %1014) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1043, %1041, %1026)[^bb6, ^bb7] <{operandSegmentSizes = array<i32: 1, 0, 2>}> : (i1, i64, i64) -> ()
^bb6:  // pred: ^bb5
  %1044 = "llvm.add"(%1026, %1011) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1045 = "llvm.icmp"(%1044, %1009) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1045, %1044)[^bb2, ^bb3] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb7(%1046: i64, %1047: i64):  // pred: ^bb5
  %1048 = "llvm.icmp"(%1046, %1022) <{predicate = 9 : i64}> : (i64, i64) -> i1
  %1049 = "llvm.trunc"(%1046) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1050 = "llvm.select"(%1048, %1023, %1008) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i8, i8) -> i8
  %1051 = "llvm.sub"(%1049, %1050) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  %1052 = "llvm.zext"(%1048) : (i1) -> i64
  %1053 = "llvm.getelementptr"(%arg20, %1047) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%1051, %1053) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1054 = "llvm.add"(%1047, %arg22) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %1055 = "llvm.icmp"(%1054, %1009) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1055, %1054, %1052)[^bb1, ^bb2] <{operandSegmentSizes = array<i32: 1, 2, 0>}> : (i1, i64, i64) -> ()
}) : () -> ()
