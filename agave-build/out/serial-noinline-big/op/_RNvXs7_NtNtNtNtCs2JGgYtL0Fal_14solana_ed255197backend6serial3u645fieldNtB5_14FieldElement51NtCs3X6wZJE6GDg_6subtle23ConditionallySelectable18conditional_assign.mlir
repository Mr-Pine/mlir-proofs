"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.noundef}], dso_local, function_type = !llvm.func<void (ptr, ptr, i8)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], sym_name = "_RNvXs7_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldNtB5_14FieldElement51NtCs3X6wZJE6GDg_6subtle23ConditionallySelectable18conditional_assign", target_cpu = "x86-64-v2", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg49: !llvm.ptr, %arg50: !llvm.ptr, %arg51: i8):
  %618 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %619 = "llvm.mlir.poison"() : () -> vector<2xi64>
  %620 = "llvm.zext"(%arg51) : (i8) -> i64
  %621 = "llvm.sub"(%618, %620) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %622 = "llvm.load"(%arg49) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  %623 = "llvm.load"(%arg50) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  %624 = "llvm.xor"(%623, %622) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %625 = "llvm.insertelement"(%619, %621, %618) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  %626 = "llvm.shufflevector"(%625, %619) <{mask = array<i32: 0, 0>}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %627 = "llvm.and"(%624, %626) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %628 = "llvm.xor"(%627, %622) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  "llvm.store"(%628, %arg49) <{alignment = 8 : i64, ordering = 0 : i64}> : (vector<2xi64>, !llvm.ptr) -> ()
  %629 = "llvm.getelementptr"(%arg49) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %630 = "llvm.getelementptr"(%arg50) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %631 = "llvm.load"(%629) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  %632 = "llvm.load"(%630) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  %633 = "llvm.xor"(%632, %631) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %634 = "llvm.and"(%633, %626) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %635 = "llvm.xor"(%634, %631) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  "llvm.store"(%635, %629) <{alignment = 8 : i64, ordering = 0 : i64}> : (vector<2xi64>, !llvm.ptr) -> ()
  %636 = "llvm.getelementptr"(%arg49) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %637 = "llvm.load"(%636) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %638 = "llvm.getelementptr"(%arg50) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %639 = "llvm.load"(%638) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %640 = "llvm.xor"(%639, %637) : (i64, i64) -> i64
  %641 = "llvm.and"(%640, %621) : (i64, i64) -> i64
  %642 = "llvm.xor"(%641, %637) : (i64, i64) -> i64
  "llvm.store"(%642, %636) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
