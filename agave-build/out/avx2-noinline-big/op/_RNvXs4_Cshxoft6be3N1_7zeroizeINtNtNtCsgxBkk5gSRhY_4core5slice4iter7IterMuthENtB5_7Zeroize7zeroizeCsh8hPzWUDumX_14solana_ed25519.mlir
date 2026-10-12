#alias_scope_domain90 = #llvm.alias_scope_domain<id = distinct[90]<>, description = "_RNvXCshxoft6be3N1_7zeroizehNtB2_7Zeroize7zeroizeCsh8hPzWUDumX_14solana_ed25519">
#alias_scope138 = #llvm.alias_scope<id = distinct[267]<>, domain = #alias_scope_domain90, description = "_RNvXCshxoft6be3N1_7zeroizehNtB2_7Zeroize7zeroizeCsh8hPzWUDumX_14solana_ed25519: argument 0">
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 16 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}], dso_local, function_type = !llvm.func<void (ptr)>, linkage = #llvm.linkage<internal>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], sym_name = "_RNvXs4_Cshxoft6be3N1_7zeroizeINtNtNtCsgxBkk5gSRhY_4core5slice4iter7IterMuthENtB5_7Zeroize7zeroizeCsh8hPzWUDumX_14solana_ed25519", target_cpu = "x86-64-v2", target_features = #llvm.target_features<["+avx", "+avx2", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+crc32", "+ssse3"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg35: !llvm.ptr):
  %527 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %528 = "llvm.getelementptr"(%arg35) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %529 = "llvm.load"(%arg35) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> !llvm.ptr
  %530 = "llvm.load"(%528) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> !llvm.ptr
  %531 = "llvm.icmp"(%529, %530) <{predicate = 0 : i64}> : (!llvm.ptr, !llvm.ptr) -> i1
  "llvm.cond_br"(%531, %529)[^bb2, ^bb1] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, !llvm.ptr) -> ()
^bb1(%532: !llvm.ptr):  // 2 preds: ^bb0, ^bb1
  %533 = "llvm.getelementptr"(%532) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%533, %arg35) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.store"(%527, %532) <{alias_scopes = [#alias_scope138], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  "llvm.fence"() <{ordering = 7 : i64, syncscope = "singlethread"}> : () -> ()
  %534 = "llvm.load"(%arg35) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> !llvm.ptr
  %535 = "llvm.load"(%528) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> !llvm.ptr
  %536 = "llvm.icmp"(%534, %535) <{predicate = 0 : i64}> : (!llvm.ptr, !llvm.ptr) -> i1
  "llvm.cond_br"(%536, %534)[^bb2, ^bb1] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, !llvm.ptr) -> ()
^bb2:  // 2 preds: ^bb0, ^bb1
  "llvm.return"() : () -> ()
}) : () -> ()
