module

-- build/llvm23/mlir_canonicalized/ref/op/fiat_25519_carry_square.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Firedancer.Ref

@[expose] public section

mlir_def fiat_25519_carry_square :=
#tbaa_root = #llvm.tbaa_root<id = "Simple C/C++ TBAA">
#tbaa_type_desc = #llvm.tbaa_type_desc<id = "omnipotent char", members = {<#tbaa_root, 0>}>
#tbaa_type_desc1 = #llvm.tbaa_type_desc<id = "long", members = {<#tbaa_type_desc, 0>}>
#tbaa_tag1 = #llvm.tbaa_tag<base_type = #tbaa_type_desc1, access_type = #tbaa_type_desc1, offset = 0>
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], sym_name = "fiat_25519_carry_square", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg32: !llvm.ptr, %arg33: !llvm.ptr):
  %509 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %510 = "llvm.mlir.constant"() <{value = 38 : i64}> : () -> i64
  %511 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %512 = "llvm.mlir.constant"() <{value = 51 : i128}> : () -> i128
  %513 = "llvm.mlir.constant"() <{value = 2251799813685247 : i64}> : () -> i64
  %514 = "llvm.mlir.constant"() <{value = 18446744073709551615 : i128}> : () -> i128
  %515 = "llvm.mlir.constant"() <{value = 51 : i64}> : () -> i64
  %516 = "llvm.getelementptr"(%arg33) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %517 = "llvm.load"(%516) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %518 = "llvm.mul"(%517, %509) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %519 = "llvm.mul"(%517, %510) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %520 = "llvm.shl"(%517, %511) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %521 = "llvm.getelementptr"(%arg33) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %522 = "llvm.load"(%521) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %523 = "llvm.mul"(%522, %509) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %524 = "llvm.mul"(%522, %510) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %525 = "llvm.shl"(%522, %511) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %526 = "llvm.getelementptr"(%arg33) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %527 = "llvm.load"(%526) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %528 = "llvm.shl"(%527, %511) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %529 = "llvm.getelementptr"(%arg33) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %530 = "llvm.load"(%529) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %531 = "llvm.shl"(%530, %511) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %532 = "llvm.zext"(%517) : (i64) -> i128
  %533 = "llvm.zext"(%518) : (i64) -> i128
  %534 = "llvm.mul"(%533, %532) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %535 = "llvm.zext"(%522) : (i64) -> i128
  %536 = "llvm.zext"(%519) : (i64) -> i128
  %537 = "llvm.mul"(%535, %536) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %538 = "llvm.zext"(%523) : (i64) -> i128
  %539 = "llvm.mul"(%538, %535) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %540 = "llvm.zext"(%527) : (i64) -> i128
  %541 = "llvm.mul"(%540, %536) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %542 = "llvm.zext"(%524) : (i64) -> i128
  %543 = "llvm.mul"(%540, %542) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %544 = "llvm.mul"(%540, %540) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %545 = "llvm.zext"(%530) : (i64) -> i128
  %546 = "llvm.mul"(%545, %536) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %547 = "llvm.zext"(%525) : (i64) -> i128
  %548 = "llvm.mul"(%545, %547) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %549 = "llvm.zext"(%528) : (i64) -> i128
  %550 = "llvm.mul"(%545, %549) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %551 = "llvm.mul"(%545, %545) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %552 = "llvm.load"(%arg33) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %553 = "llvm.zext"(%552) : (i64) -> i128
  %554 = "llvm.zext"(%520) : (i64) -> i128
  %555 = "llvm.mul"(%553, %554) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %556 = "llvm.mul"(%553, %547) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %557 = "llvm.mul"(%553, %549) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %558 = "llvm.zext"(%531) : (i64) -> i128
  %559 = "llvm.mul"(%553, %558) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %560 = "llvm.mul"(%553, %553) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %561 = "llvm.add"(%546, %543) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %562 = "llvm.add"(%561, %560) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %563 = "llvm.lshr"(%562, %512) : (i128, i128) -> i128
  %564 = "llvm.trunc"(%562) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %565 = "llvm.and"(%564, %513) : (i64, i64) -> i64
  %566 = "llvm.add"(%548, %544) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %567 = "llvm.add"(%566, %555) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %568 = "llvm.add"(%550, %534) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %569 = "llvm.add"(%568, %556) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %570 = "llvm.add"(%551, %537) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %571 = "llvm.add"(%570, %557) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %572 = "llvm.add"(%541, %539) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %573 = "llvm.add"(%572, %559) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %574 = "llvm.and"(%563, %514) : (i128, i128) -> i128
  %575 = "llvm.add"(%573, %574) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %576 = "llvm.lshr"(%575, %512) : (i128, i128) -> i128
  %577 = "llvm.trunc"(%575) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %578 = "llvm.and"(%577, %513) : (i64, i64) -> i64
  %579 = "llvm.and"(%576, %514) : (i128, i128) -> i128
  %580 = "llvm.add"(%571, %579) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %581 = "llvm.lshr"(%580, %512) : (i128, i128) -> i128
  %582 = "llvm.trunc"(%580) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %583 = "llvm.and"(%582, %513) : (i64, i64) -> i64
  %584 = "llvm.and"(%581, %514) : (i128, i128) -> i128
  %585 = "llvm.add"(%569, %584) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %586 = "llvm.lshr"(%585, %512) : (i128, i128) -> i128
  %587 = "llvm.trunc"(%585) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %588 = "llvm.and"(%587, %513) : (i64, i64) -> i64
  %589 = "llvm.and"(%586, %514) : (i128, i128) -> i128
  %590 = "llvm.add"(%567, %589) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %591 = "llvm.lshr"(%590, %512) : (i128, i128) -> i128
  %592 = "llvm.trunc"(%591) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %593 = "llvm.trunc"(%590) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %594 = "llvm.and"(%593, %513) : (i64, i64) -> i64
  %595 = "llvm.mul"(%592, %509) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %596 = "llvm.add"(%595, %565) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %597 = "llvm.lshr"(%596, %515) : (i64, i64) -> i64
  %598 = "llvm.and"(%596, %513) : (i64, i64) -> i64
  %599 = "llvm.add"(%597, %578) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %600 = "llvm.lshr"(%599, %515) : (i64, i64) -> i64
  %601 = "llvm.and"(%599, %513) : (i64, i64) -> i64
  %602 = "llvm.add"(%600, %583) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  "llvm.store"(%598, %arg32) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  %603 = "llvm.getelementptr"(%arg32) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%601, %603) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  %604 = "llvm.getelementptr"(%arg32) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%602, %604) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  %605 = "llvm.getelementptr"(%arg32) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%588, %605) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  %606 = "llvm.getelementptr"(%arg32) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%594, %606) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end MLIR.Firedancer.Ref
