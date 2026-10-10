module

-- agave-build/out/serial-noinline/op/_RNvMsp_NtCs2JGgYtL0Fal_14solana_ed255196scalarNtNtNtNtNtB7_7backend6serial3u646scalar8Scalar524pack.mlir
-- <solana_ed25519[1fe0933b11699477]::backend::serial::u64::scalar::Scalar52>::pack

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Agave.Serial

@[expose] public section

mlir_def Scalar52_pack :=
#alias_scope_domain68 = #llvm.alias_scope_domain<id = distinct[68]<>, description = "_RNvMs2_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar528to_bytes">
#alias_scope131 = #llvm.alias_scope<id = distinct[227]<>, domain = #alias_scope_domain68, description = "_RNvMs2_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar528to_bytes: argument 1">
#alias_scope132 = #llvm.alias_scope<id = distinct[228]<>, domain = #alias_scope_domain68, description = "_RNvMs2_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar528to_bytes: argument 0">
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 1 : i64, llvm.dead_on_unwind, llvm.dereferenceable = 32 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writable, llvm.writeonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], sym_name = "_RNvMsp_NtCs2JGgYtL0Fal_14solana_ed255196scalarNtNtNtNtNtB7_7backend6serial3u646scalar8Scalar524pack", target_cpu = "x86-64-v2", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg28: !llvm.ptr, %arg29: !llvm.ptr):
  %473 = "llvm.mlir.constant"() <{value = 8 : i64}> : () -> i64
  %474 = "llvm.mlir.constant"() <{value = 16 : i64}> : () -> i64
  %475 = "llvm.mlir.constant"() <{value = 24 : i64}> : () -> i64
  %476 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %477 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
  %478 = "llvm.mlir.constant"() <{value = 48 : i64}> : () -> i64
  %479 = "llvm.mlir.constant"() <{value = 4 : i64}> : () -> i64
  %480 = "llvm.mlir.constant"() <{value = 12 : i64}> : () -> i64
  %481 = "llvm.mlir.constant"() <{value = 20 : i64}> : () -> i64
  %482 = "llvm.mlir.constant"() <{value = 28 : i64}> : () -> i64
  %483 = "llvm.mlir.constant"() <{value = 36 : i64}> : () -> i64
  %484 = "llvm.mlir.constant"() <{value = 44 : i64}> : () -> i64
  %485 = "llvm.load"(%arg29) <{alias_scopes = [#alias_scope131], alignment = 8 : i64, noalias_scopes = [#alias_scope132], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %486 = "llvm.trunc"(%485) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %487 = "llvm.lshr"(%485, %473) : (i64, i64) -> i64
  %488 = "llvm.trunc"(%487) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %489 = "llvm.lshr"(%485, %474) : (i64, i64) -> i64
  %490 = "llvm.trunc"(%489) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %491 = "llvm.lshr"(%485, %475) : (i64, i64) -> i64
  %492 = "llvm.trunc"(%491) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %493 = "llvm.lshr"(%485, %476) : (i64, i64) -> i64
  %494 = "llvm.trunc"(%493) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %495 = "llvm.lshr"(%485, %477) : (i64, i64) -> i64
  %496 = "llvm.trunc"(%495) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %497 = "llvm.lshr"(%485, %478) : (i64, i64) -> i64
  %498 = "llvm.getelementptr"(%arg29) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %499 = "llvm.load"(%498) <{alias_scopes = [#alias_scope131], alignment = 8 : i64, noalias_scopes = [#alias_scope132], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %500 = "llvm.shl"(%499, %479) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %501 = "llvm.or"(%500, %497) : (i64, i64) -> i64
  %502 = "llvm.trunc"(%501) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %503 = "llvm.lshr"(%499, %479) : (i64, i64) -> i64
  %504 = "llvm.trunc"(%503) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %505 = "llvm.lshr"(%499, %480) : (i64, i64) -> i64
  %506 = "llvm.trunc"(%505) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %507 = "llvm.lshr"(%499, %481) : (i64, i64) -> i64
  %508 = "llvm.trunc"(%507) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %509 = "llvm.lshr"(%499, %482) : (i64, i64) -> i64
  %510 = "llvm.trunc"(%509) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %511 = "llvm.lshr"(%499, %483) : (i64, i64) -> i64
  %512 = "llvm.trunc"(%511) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %513 = "llvm.lshr"(%499, %484) : (i64, i64) -> i64
  %514 = "llvm.trunc"(%513) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %515 = "llvm.getelementptr"(%arg29) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %516 = "llvm.load"(%515) <{alias_scopes = [#alias_scope131], alignment = 8 : i64, noalias_scopes = [#alias_scope132], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %517 = "llvm.trunc"(%516) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %518 = "llvm.lshr"(%516, %473) : (i64, i64) -> i64
  %519 = "llvm.trunc"(%518) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %520 = "llvm.lshr"(%516, %474) : (i64, i64) -> i64
  %521 = "llvm.trunc"(%520) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %522 = "llvm.lshr"(%516, %475) : (i64, i64) -> i64
  %523 = "llvm.trunc"(%522) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %524 = "llvm.lshr"(%516, %476) : (i64, i64) -> i64
  %525 = "llvm.trunc"(%524) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %526 = "llvm.lshr"(%516, %477) : (i64, i64) -> i64
  %527 = "llvm.trunc"(%526) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %528 = "llvm.lshr"(%516, %478) : (i64, i64) -> i64
  %529 = "llvm.getelementptr"(%arg29) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %530 = "llvm.load"(%529) <{alias_scopes = [#alias_scope131], alignment = 8 : i64, noalias_scopes = [#alias_scope132], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %531 = "llvm.shl"(%530, %479) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %532 = "llvm.or"(%531, %528) : (i64, i64) -> i64
  %533 = "llvm.trunc"(%532) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %534 = "llvm.lshr"(%530, %479) : (i64, i64) -> i64
  %535 = "llvm.trunc"(%534) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %536 = "llvm.lshr"(%530, %480) : (i64, i64) -> i64
  %537 = "llvm.trunc"(%536) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %538 = "llvm.lshr"(%530, %481) : (i64, i64) -> i64
  %539 = "llvm.trunc"(%538) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %540 = "llvm.lshr"(%530, %482) : (i64, i64) -> i64
  %541 = "llvm.trunc"(%540) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %542 = "llvm.lshr"(%530, %483) : (i64, i64) -> i64
  %543 = "llvm.trunc"(%542) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %544 = "llvm.lshr"(%530, %484) : (i64, i64) -> i64
  %545 = "llvm.trunc"(%544) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %546 = "llvm.getelementptr"(%arg29) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %547 = "llvm.load"(%546) <{alias_scopes = [#alias_scope131], alignment = 8 : i64, noalias_scopes = [#alias_scope132], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %548 = "llvm.trunc"(%547) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %549 = "llvm.lshr"(%547, %473) : (i64, i64) -> i64
  %550 = "llvm.trunc"(%549) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %551 = "llvm.lshr"(%547, %474) : (i64, i64) -> i64
  %552 = "llvm.trunc"(%551) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %553 = "llvm.lshr"(%547, %475) : (i64, i64) -> i64
  %554 = "llvm.trunc"(%553) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %555 = "llvm.lshr"(%547, %476) : (i64, i64) -> i64
  %556 = "llvm.trunc"(%555) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %557 = "llvm.lshr"(%547, %477) : (i64, i64) -> i64
  %558 = "llvm.trunc"(%557) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%486, %arg28) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %559 = "llvm.getelementptr"(%arg28) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%488, %559) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %560 = "llvm.getelementptr"(%arg28) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%490, %560) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %561 = "llvm.getelementptr"(%arg28) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 3>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%492, %561) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %562 = "llvm.getelementptr"(%arg28) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%494, %562) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %563 = "llvm.getelementptr"(%arg28) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 5>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%496, %563) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %564 = "llvm.getelementptr"(%arg28) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%502, %564) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %565 = "llvm.getelementptr"(%arg28) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 7>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%504, %565) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %566 = "llvm.getelementptr"(%arg28) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%506, %566) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %567 = "llvm.getelementptr"(%arg28) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 9>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%508, %567) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %568 = "llvm.getelementptr"(%arg28) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 10>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%510, %568) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %569 = "llvm.getelementptr"(%arg28) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 11>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%512, %569) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %570 = "llvm.getelementptr"(%arg28) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 12>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%514, %570) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %571 = "llvm.getelementptr"(%arg28) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 13>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%517, %571) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %572 = "llvm.getelementptr"(%arg28) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 14>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%519, %572) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %573 = "llvm.getelementptr"(%arg28) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 15>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%521, %573) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %574 = "llvm.getelementptr"(%arg28) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%523, %574) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %575 = "llvm.getelementptr"(%arg28) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 17>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%525, %575) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %576 = "llvm.getelementptr"(%arg28) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 18>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%527, %576) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %577 = "llvm.getelementptr"(%arg28) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 19>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%533, %577) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %578 = "llvm.getelementptr"(%arg28) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 20>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%535, %578) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %579 = "llvm.getelementptr"(%arg28) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 21>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%537, %579) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %580 = "llvm.getelementptr"(%arg28) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 22>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%539, %580) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %581 = "llvm.getelementptr"(%arg28) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 23>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%541, %581) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %582 = "llvm.getelementptr"(%arg28) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%543, %582) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %583 = "llvm.getelementptr"(%arg28) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 25>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%545, %583) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %584 = "llvm.getelementptr"(%arg28) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 26>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%548, %584) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %585 = "llvm.getelementptr"(%arg28) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 27>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%550, %585) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %586 = "llvm.getelementptr"(%arg28) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 28>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%552, %586) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %587 = "llvm.getelementptr"(%arg28) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 29>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%554, %587) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %588 = "llvm.getelementptr"(%arg28) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 30>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%556, %588) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %589 = "llvm.getelementptr"(%arg28) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 31>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%558, %589) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end MLIR.Agave.Serial
