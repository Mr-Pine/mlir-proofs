module

-- agave-build/out/serial-noinline-big/op/_RNvMso_NtCs2JGgYtL0Fal_14solana_ed255196scalarNtB5_6Scalar17non_adjacent_form.mlir
-- <solana_ed25519[1fe0933b11699477]::scalar::Scalar>::non_adjacent_form

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Agave.Serial

@[expose] public section

mlir_def Scalar_non_adjacent_form :=
#alias_scope_domain33 = #llvm.alias_scope_domain<id = distinct[33]<>, description = "_RNvNtCs2JGgYtL0Fal_14solana_ed255196scalar16read_le_u64_into">
#alias_scope50 = #llvm.alias_scope<id = distinct[126]<>, domain = #alias_scope_domain33, description = "_RNvNtCs2JGgYtL0Fal_14solana_ed255196scalar16read_le_u64_into: argument 0">
#alias_scope51 = #llvm.alias_scope<id = distinct[127]<>, domain = #alias_scope_domain33, description = "_RNvNtCs2JGgYtL0Fal_14solana_ed255196scalar16read_le_u64_into: argument 1">
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 1 : i64, llvm.dead_on_unwind, llvm.dereferenceable = 256 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writable, llvm.writeonly}, {llvm.dereferenceable = 32 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.noundef, llvm.range = #llvm.constant_range<i64, 5, 9>}], dso_local, function_type = !llvm.func<void (ptr, ptr, i64)>, linkage = #llvm.linkage<internal>, passthrough = ["nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], personality = @rust_eh_personality, sym_name = "_RNvMso_NtCs2JGgYtL0Fal_14solana_ed255196scalarNtB5_6Scalar17non_adjacent_form", target_cpu = "x86-64-v2", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg42: !llvm.ptr, %arg43: !llvm.ptr, %arg44: i64):
  %502 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %503 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %504 = "llvm.mlir.constant"() <{value = 256 : i64}> : () -> i64
  %505 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
  %506 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %507 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %508 = "llvm.mlir.constant"() <{value = 64 : i64}> : () -> i64
  %509 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %510 = "llvm.mlir.constant"() <{value = 6 : i64}> : () -> i64
  %511 = "llvm.mlir.constant"() <{value = 63 : i64}> : () -> i64
  %512 = "llvm.alloca"(%502) <{alignment = 16 : i64, elem_type = !llvm.array<40 x i8>}> : (i32) -> !llvm.ptr
  "llvm.intr.memset"(%arg42, %503, %504) <{arg_attrs = [{llvm.align = 1 : i64, llvm.dereferenceable = 256 : i64, llvm.nonnull, llvm.noundef}, {}, {}], isVolatile = false}> : (!llvm.ptr, i8, i64) -> ()
  "llvm.intr.lifetime.start"(%512) : (!llvm.ptr) -> ()
  "llvm.intr.memset"(%512, %503, %505) <{arg_attrs = [{llvm.align = 16 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {}, {}], isVolatile = false}> : (!llvm.ptr, i8, i64) -> ()
  "llvm.intr.experimental.noalias.scope.decl"() <{scope = #alias_scope50}> : () -> ()
  "llvm.intr.experimental.noalias.scope.decl"() <{scope = #alias_scope51}> : () -> ()
  %513 = "llvm.load"(%arg43) <{alias_scopes = [#alias_scope50], alignment = 1 : i64, noalias_scopes = [#alias_scope51], ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  "llvm.store"(%513, %512) <{alias_scopes = [#alias_scope51], alignment = 16 : i64, noalias_scopes = [#alias_scope50], ordering = 0 : i64}> : (vector<2xi64>, !llvm.ptr) -> ()
  %514 = "llvm.getelementptr"(%512) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %515 = "llvm.getelementptr"(%arg43) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %516 = "llvm.load"(%515) <{alias_scopes = [#alias_scope50], alignment = 1 : i64, noalias_scopes = [#alias_scope51], ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  "llvm.store"(%516, %514) <{alias_scopes = [#alias_scope51], alignment = 16 : i64, noalias_scopes = [#alias_scope50], ordering = 0 : i64}> : (vector<2xi64>, !llvm.ptr) -> ()
  %517 = "llvm.shl"(%506, %arg44) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %518 = "llvm.add"(%517, %507) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %519 = "llvm.sub"(%508, %arg44) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %520 = "llvm.lshr"(%517, %506) <{isExact}> : (i64, i64) -> i64
  %521 = "llvm.trunc"(%517) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.br"(%509, %509)[^bb1] : (i64, i64) -> ()
^bb1(%522: i64, %523: i64):  // 2 preds: ^bb0, ^bb7
  "llvm.br"(%522)[^bb3] : (i64) -> ()
^bb2:  // 2 preds: ^bb6, ^bb7
  "llvm.intr.lifetime.end"(%512) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
^bb3(%524: i64):  // 2 preds: ^bb1, ^bb6
  %525 = "llvm.lshr"(%524, %510) : (i64, i64) -> i64
  %526 = "llvm.and"(%524, %511) : (i64, i64) -> i64
  %527 = "llvm.icmp"(%526, %519) <{predicate = 6 : i64}> : (i64, i64) -> i1
  %528 = "llvm.getelementptr"(%512, %525) <{elem_type = i64, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %529 = "llvm.load"(%528) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %530 = "llvm.lshr"(%529, %526) : (i64, i64) -> i64
  "llvm.cond_br"(%527, %530)[^bb5, ^bb4] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
^bb4:  // pred: ^bb3
  %531 = "llvm.getelementptr"(%528) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %532 = "llvm.load"(%531) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %533 = "llvm.sub"(%509, %524) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %534 = "llvm.and"(%533, %511) : (i64, i64) -> i64
  %535 = "llvm.shl"(%532, %534) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %536 = "llvm.or"(%535, %530) : (i64, i64) -> i64
  "llvm.br"(%536)[^bb5] : (i64) -> ()
^bb5(%537: i64):  // 2 preds: ^bb3, ^bb4
  %538 = "llvm.and"(%537, %518) : (i64, i64) -> i64
  %539 = "llvm.add"(%538, %523) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %540 = "llvm.and"(%539, %506) : (i64, i64) -> i64
  %541 = "llvm.icmp"(%540, %509) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%541, %539, %524)[^bb6, ^bb7] <{operandSegmentSizes = array<i32: 1, 0, 2>}> : (i1, i64, i64) -> ()
^bb6:  // pred: ^bb5
  %542 = "llvm.add"(%524, %506) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %543 = "llvm.icmp"(%542, %504) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%543, %542)[^bb2, ^bb3] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb7(%544: i64, %545: i64):  // pred: ^bb5
  %546 = "llvm.icmp"(%544, %520) <{predicate = 9 : i64}> : (i64, i64) -> i1
  %547 = "llvm.trunc"(%544) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %548 = "llvm.select"(%546, %521, %503) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i8, i8) -> i8
  %549 = "llvm.sub"(%547, %548) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  %550 = "llvm.zext"(%546) : (i1) -> i64
  %551 = "llvm.getelementptr"(%arg42, %545) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%549, %551) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %552 = "llvm.add"(%545, %arg44) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %553 = "llvm.icmp"(%552, %504) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%553, %552, %550)[^bb1, ^bb2] <{operandSegmentSizes = array<i32: 1, 2, 0>}> : (i1, i64, i64) -> ()
}) : () -> ()

end

end MLIR.Agave.Serial
