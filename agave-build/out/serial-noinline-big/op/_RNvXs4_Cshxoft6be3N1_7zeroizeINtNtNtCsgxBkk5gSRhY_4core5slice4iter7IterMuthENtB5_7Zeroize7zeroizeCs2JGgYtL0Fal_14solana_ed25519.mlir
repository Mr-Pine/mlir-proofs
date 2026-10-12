#alias_scope_domain36 = #llvm.alias_scope_domain<id = distinct[36]<>, description = "_RNvXCshxoft6be3N1_7zeroizehNtB2_7Zeroize7zeroizeCs2JGgYtL0Fal_14solana_ed25519">
#alias_scope56 = #llvm.alias_scope<id = distinct[132]<>, domain = #alias_scope_domain36, description = "_RNvXCshxoft6be3N1_7zeroizehNtB2_7Zeroize7zeroizeCs2JGgYtL0Fal_14solana_ed25519: argument 0">
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 16 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}], dso_local, function_type = !llvm.func<void (ptr)>, linkage = #llvm.linkage<internal>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], sym_name = "_RNvXs4_Cshxoft6be3N1_7zeroizeINtNtNtCsgxBkk5gSRhY_4core5slice4iter7IterMuthENtB5_7Zeroize7zeroizeCs2JGgYtL0Fal_14solana_ed25519", target_cpu = "x86-64-v2", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg30: !llvm.ptr):
  %415 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %416 = "llvm.getelementptr"(%arg30) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %417 = "llvm.load"(%arg30) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> !llvm.ptr
  %418 = "llvm.load"(%416) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> !llvm.ptr
  %419 = "llvm.icmp"(%417, %418) <{predicate = 0 : i64}> : (!llvm.ptr, !llvm.ptr) -> i1
  "llvm.cond_br"(%419, %417)[^bb2, ^bb1] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, !llvm.ptr) -> ()
^bb1(%420: !llvm.ptr):  // 2 preds: ^bb0, ^bb1
  %421 = "llvm.getelementptr"(%420) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%421, %arg30) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.store"(%415, %420) <{alias_scopes = [#alias_scope56], alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  "llvm.fence"() <{ordering = 7 : i64, syncscope = "singlethread"}> : () -> ()
  %422 = "llvm.load"(%arg30) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> !llvm.ptr
  %423 = "llvm.load"(%416) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> !llvm.ptr
  %424 = "llvm.icmp"(%422, %423) <{predicate = 0 : i64}> : (!llvm.ptr, !llvm.ptr) -> i1
  "llvm.cond_br"(%424, %422)[^bb2, ^bb1] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, !llvm.ptr) -> ()
^bb2:  // 2 preds: ^bb0, ^bb1
  "llvm.return"() : () -> ()
}) : () -> ()
