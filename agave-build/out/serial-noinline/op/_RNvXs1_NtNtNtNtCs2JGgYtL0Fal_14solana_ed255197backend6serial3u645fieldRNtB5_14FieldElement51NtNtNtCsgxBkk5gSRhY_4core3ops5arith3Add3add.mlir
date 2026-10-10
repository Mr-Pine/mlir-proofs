#alias_scope_domain67 = #llvm.alias_scope_domain<id = distinct[67]<>, description = "_RNvXs0_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldNtB5_14FieldElement51INtNtNtCsgxBkk5gSRhY_4core3ops5arith9AddAssignRB16_E10add_assign">
#alias_scope129 = #llvm.alias_scope<id = distinct[225]<>, domain = #alias_scope_domain67, description = "_RNvXs0_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldNtB5_14FieldElement51INtNtNtCsgxBkk5gSRhY_4core3ops5arith9AddAssignRB16_E10add_assign: argument 1">
#alias_scope130 = #llvm.alias_scope<id = distinct[226]<>, domain = #alias_scope_domain67, description = "_RNvXs0_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldNtB5_14FieldElement51INtNtNtCsgxBkk5gSRhY_4core3ops5arith9AddAssignRB16_E10add_assign: argument 0">
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 8 : i64, llvm.dead_on_unwind, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writable, llvm.writeonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], sym_name = "_RNvXs1_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldRNtB5_14FieldElement51NtNtNtCsgxBkk5gSRhY_4core3ops5arith3Add3add", target_cpu = "x86-64-v2", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg47: !llvm.ptr, %arg48: !llvm.ptr, %arg49: !llvm.ptr):
  %1269 = "llvm.getelementptr"(%arg48) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %1270 = "llvm.getelementptr"(%arg48) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %1271 = "llvm.load"(%1270) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1272 = "llvm.getelementptr"(%arg49) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %1273 = "llvm.getelementptr"(%arg49) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %1274 = "llvm.load"(%1273) <{alias_scopes = [#alias_scope129], alignment = 8 : i64, noalias_scopes = [#alias_scope130], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1275 = "llvm.add"(%1271, %1274) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1276 = "llvm.load"(%arg48) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  %1277 = "llvm.load"(%arg49) <{alias_scopes = [#alias_scope129], alignment = 8 : i64, noalias_scopes = [#alias_scope130], ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  %1278 = "llvm.add"(%1276, %1277) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  "llvm.store"(%1278, %arg47) <{alignment = 8 : i64, ordering = 0 : i64}> : (vector<2xi64>, !llvm.ptr) -> ()
  %1279 = "llvm.getelementptr"(%arg47) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %1280 = "llvm.load"(%1269) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  %1281 = "llvm.load"(%1272) <{alias_scopes = [#alias_scope129], alignment = 8 : i64, noalias_scopes = [#alias_scope130], ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  %1282 = "llvm.add"(%1280, %1281) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  "llvm.store"(%1282, %1279) <{alignment = 8 : i64, ordering = 0 : i64}> : (vector<2xi64>, !llvm.ptr) -> ()
  %1283 = "llvm.getelementptr"(%arg47) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1275, %1283) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
