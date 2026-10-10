#alias_scope_domain124 = #llvm.alias_scope_domain<id = distinct[124]<>, description = "_RNvXNvMsb_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx25fieldNtB8_18FieldElement2625x47shuffleB1a_NtB2_16___Impl_shuffle__13__impl_shuffle">
#alias_scope216 = #llvm.alias_scope<id = distinct[358]<>, domain = #alias_scope_domain124, description = "_RNvXNvMsb_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx25fieldNtB8_18FieldElement2625x47shuffleB1a_NtB2_16___Impl_shuffle__13__impl_shuffle: argument 1">
#alias_scope217 = #llvm.alias_scope<id = distinct[359]<>, domain = #alias_scope_domain124, description = "_RNvXNvMsb_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx25fieldNtB8_18FieldElement2625x47shuffleB1a_NtB2_16___Impl_shuffle__13__impl_shuffle: argument 0">
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 32 : i64, llvm.dead_on_unwind, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writable, llvm.writeonly}, {llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], sym_name = "_RNvXNvMs7_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx27edwardsNtB8_13ExtendedPoint6doubleB1c_NtB2_15___Impl_double__12__impl_double", target_cpu = "x86-64-v2", target_features = #llvm.target_features<["+avx", "+avx2", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+crc32", "+ssse3", "+avx", "+avx2", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+crc32", "+ssse3"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg18: !llvm.ptr, %arg19: !llvm.ptr):
  %558 = "llvm.mlir.constant"() <{value = 134217726 : i32}> : () -> i32
  %559 = "llvm.mlir.constant"() <{value = 134217690 : i32}> : () -> i32
  %560 = "llvm.mlir.constant"() <{value = 67108862 : i32}> : () -> i32
  %561 = "llvm.mlir.constant"() <{value = 33554431 : i32}> : () -> i32
  %562 = "llvm.mlir.constant"() <{value = 67108863 : i32}> : () -> i32
  %563 = "llvm.mlir.constant"() <{value = dense<51> : vector<4xi64>}> : () -> vector<4xi64>
  %564 = "llvm.mlir.constant"() <{value = dense<33554431> : vector<4xi64>}> : () -> vector<4xi64>
  %565 = "llvm.mlir.constant"() <{value = dense<25> : vector<4xi64>}> : () -> vector<4xi64>
  %566 = "llvm.mlir.constant"() <{value = dense<67108863> : vector<4xi64>}> : () -> vector<4xi64>
  %567 = "llvm.mlir.constant"() <{value = dense<26> : vector<4xi64>}> : () -> vector<4xi64>
  %568 = "llvm.mlir.constant"() <{value = 9223371899415822336 : i64}> : () -> i64
  %569 = "llvm.mlir.constant"() <{value = 4611685880988434432 : i64}> : () -> i64
  %570 = "llvm.mlir.undef"() : () -> vector<4xi64>
  %571 = "llvm.mlir.poison"() : () -> i64
  %572 = "llvm.mlir.constant"() <{value = 9223369425514659840 : i64}> : () -> i64
  %573 = "llvm.mlir.constant"() <{value = dense<1> : vector<4xi64>}> : () -> vector<4xi64>
  %574 = "llvm.mlir.constant"() <{value = dense<4294967295> : vector<4xi64>}> : () -> vector<4xi64>
  %575 = "llvm.mlir.constant"() <{value = dense<19> : vector<4xi64>}> : () -> vector<4xi64>
  %576 = "llvm.mlir.constant"() <{value = dense<1> : vector<8xi32>}> : () -> vector<8xi32>
  %577 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %578 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %579 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %580 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %581 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %582 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %583 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %584 = "llvm.mlir.poison"() : () -> vector<8xi32>
  %585 = "llvm.mlir.poison"() : () -> i32
  %586 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %587 = "llvm.mlir.undef"() : () -> vector<8xi32>
  %588 = "llvm.insertelement"(%587, %586, %586) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %589 = "llvm.insertelement"(%588, %586, %583) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %590 = "llvm.insertelement"(%589, %585, %582) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %591 = "llvm.insertelement"(%590, %585, %581) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %592 = "llvm.insertelement"(%591, %586, %580) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %593 = "llvm.insertelement"(%592, %586, %579) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %594 = "llvm.insertelement"(%593, %585, %578) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %595 = "llvm.insertelement"(%594, %585, %577) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %596 = "llvm.insertelement"(%587, %585, %586) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %597 = "llvm.insertelement"(%596, %585, %583) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %598 = "llvm.insertelement"(%597, %586, %582) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %599 = "llvm.insertelement"(%598, %586, %581) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %600 = "llvm.insertelement"(%599, %585, %580) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %601 = "llvm.insertelement"(%600, %585, %579) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %602 = "llvm.insertelement"(%601, %586, %578) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %603 = "llvm.insertelement"(%602, %586, %577) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %604 = "llvm.insertelement"(%570, %571, %586) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %605 = "llvm.insertelement"(%604, %571, %583) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %606 = "llvm.insertelement"(%605, %571, %582) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %607 = "llvm.insertelement"(%606, %572, %581) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %608 = "llvm.insertelement"(%570, %571, %586) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %609 = "llvm.insertelement"(%608, %571, %583) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %610 = "llvm.insertelement"(%609, %571, %582) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %611 = "llvm.insertelement"(%610, %569, %581) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %612 = "llvm.insertelement"(%570, %571, %586) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %613 = "llvm.insertelement"(%612, %571, %583) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %614 = "llvm.insertelement"(%613, %571, %582) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %615 = "llvm.insertelement"(%614, %568, %581) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %616 = "llvm.insertelement"(%587, %562, %586) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %617 = "llvm.insertelement"(%616, %585, %583) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %618 = "llvm.insertelement"(%617, %562, %582) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %619 = "llvm.insertelement"(%618, %585, %581) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %620 = "llvm.insertelement"(%619, %562, %580) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %621 = "llvm.insertelement"(%620, %585, %579) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %622 = "llvm.insertelement"(%621, %562, %578) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %623 = "llvm.insertelement"(%622, %585, %577) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %624 = "llvm.insertelement"(%587, %561, %586) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %625 = "llvm.insertelement"(%624, %585, %583) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %626 = "llvm.insertelement"(%625, %561, %582) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %627 = "llvm.insertelement"(%626, %585, %581) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %628 = "llvm.insertelement"(%627, %561, %580) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %629 = "llvm.insertelement"(%628, %585, %579) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %630 = "llvm.insertelement"(%629, %561, %578) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %631 = "llvm.insertelement"(%630, %585, %577) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %632 = "llvm.insertelement"(%587, %586, %586) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %633 = "llvm.insertelement"(%632, %586, %583) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %634 = "llvm.insertelement"(%633, %586, %582) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %635 = "llvm.insertelement"(%634, %586, %581) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %636 = "llvm.insertelement"(%635, %585, %580) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %637 = "llvm.insertelement"(%636, %585, %579) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %638 = "llvm.insertelement"(%637, %585, %578) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %639 = "llvm.insertelement"(%638, %585, %577) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %640 = "llvm.insertelement"(%587, %585, %586) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %641 = "llvm.insertelement"(%640, %586, %583) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %642 = "llvm.insertelement"(%641, %585, %582) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %643 = "llvm.insertelement"(%642, %586, %581) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %644 = "llvm.insertelement"(%643, %586, %580) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %645 = "llvm.insertelement"(%644, %585, %579) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %646 = "llvm.insertelement"(%645, %586, %578) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %647 = "llvm.insertelement"(%646, %585, %577) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %648 = "llvm.insertelement"(%587, %585, %586) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %649 = "llvm.insertelement"(%648, %559, %583) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %650 = "llvm.insertelement"(%649, %585, %582) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %651 = "llvm.insertelement"(%650, %560, %581) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %652 = "llvm.insertelement"(%651, %559, %580) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %653 = "llvm.insertelement"(%652, %585, %579) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %654 = "llvm.insertelement"(%653, %560, %578) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %655 = "llvm.insertelement"(%654, %585, %577) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %656 = "llvm.insertelement"(%587, %585, %586) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %657 = "llvm.insertelement"(%656, %558, %583) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %658 = "llvm.insertelement"(%657, %585, %582) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %659 = "llvm.insertelement"(%658, %560, %581) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %660 = "llvm.insertelement"(%659, %558, %580) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %661 = "llvm.insertelement"(%660, %585, %579) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %662 = "llvm.insertelement"(%661, %560, %578) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %663 = "llvm.insertelement"(%662, %585, %577) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %664 = "llvm.insertelement"(%587, %586, %586) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %665 = "llvm.insertelement"(%664, %585, %583) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %666 = "llvm.insertelement"(%665, %586, %582) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %667 = "llvm.insertelement"(%666, %585, %581) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %668 = "llvm.insertelement"(%667, %585, %580) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %669 = "llvm.insertelement"(%668, %586, %579) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %670 = "llvm.insertelement"(%669, %585, %578) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %671 = "llvm.insertelement"(%670, %586, %577) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %672 = "llvm.alloca"(%583) <{alignment = 32 : i64, elem_type = !llvm.array<160 x i8>}> : (i32) -> !llvm.ptr
  %673 = "llvm.alloca"(%583) <{alignment = 32 : i64, elem_type = !llvm.array<160 x i8>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%673) : (!llvm.ptr) -> ()
  %674 = "llvm.load"(%arg19) <{alias_scopes = [#alias_scope216], alignment = 32 : i64, noalias_scopes = [#alias_scope217], ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %675 = "llvm.getelementptr"(%arg19) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %676 = "llvm.load"(%675) <{alias_scopes = [#alias_scope216], alignment = 32 : i64, noalias_scopes = [#alias_scope217], ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %677 = "llvm.getelementptr"(%arg19) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %678 = "llvm.load"(%677) <{alias_scopes = [#alias_scope216], alignment = 32 : i64, noalias_scopes = [#alias_scope217], ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %679 = "llvm.getelementptr"(%arg19) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %680 = "llvm.load"(%679) <{alias_scopes = [#alias_scope216], alignment = 32 : i64, noalias_scopes = [#alias_scope217], ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %681 = "llvm.shufflevector"(%674, %584) <{mask = array<i32: -1, -1, -1, -1, -1, 1, -1, 3>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %682 = "llvm.shufflevector"(%676, %584) <{mask = array<i32: -1, -1, -1, -1, -1, 1, -1, 3>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %683 = "llvm.shufflevector"(%678, %584) <{mask = array<i32: -1, -1, -1, -1, -1, 1, -1, 3>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %684 = "llvm.shufflevector"(%680, %584) <{mask = array<i32: -1, -1, -1, -1, -1, 1, -1, 3>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %685 = "llvm.getelementptr"(%arg19) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %686 = "llvm.load"(%685) <{alias_scopes = [#alias_scope216], alignment = 32 : i64, noalias_scopes = [#alias_scope217], ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %687 = "llvm.shufflevector"(%686, %584) <{mask = array<i32: -1, -1, -1, -1, -1, 1, -1, 3>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %688 = "llvm.getelementptr"(%673) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %689 = "llvm.getelementptr"(%673) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %690 = "llvm.getelementptr"(%673) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %691 = "llvm.getelementptr"(%673) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%672) : (!llvm.ptr) -> ()
  %692 = "llvm.shufflevector"(%674, %584) <{mask = array<i32: -1, -1, -1, -1, -1, 0, -1, 2>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %693 = "llvm.shufflevector"(%676, %584) <{mask = array<i32: -1, -1, -1, -1, -1, 0, -1, 2>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %694 = "llvm.shufflevector"(%678, %584) <{mask = array<i32: -1, -1, -1, -1, -1, 0, -1, 2>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %695 = "llvm.shufflevector"(%680, %584) <{mask = array<i32: -1, -1, -1, -1, -1, 0, -1, 2>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %696 = "llvm.shufflevector"(%686, %584) <{mask = array<i32: -1, -1, -1, -1, -1, 0, -1, 2>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %697 = "llvm.getelementptr"(%672) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %698 = "llvm.getelementptr"(%672) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %699 = "llvm.getelementptr"(%672) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %700 = "llvm.getelementptr"(%672) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %701 = "llvm.add"(%692, %681) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %702 = "llvm.add"(%693, %682) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %703 = "llvm.add"(%694, %683) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %704 = "llvm.add"(%695, %684) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %705 = "llvm.add"(%696, %687) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %706 = "llvm.shufflevector"(%674, %701) <{mask = array<i32: 0, 1, 2, 3, 4, 13, 6, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %707 = "llvm.shufflevector"(%676, %702) <{mask = array<i32: 0, 1, 2, 3, 4, 13, 6, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %708 = "llvm.shufflevector"(%678, %703) <{mask = array<i32: 0, 1, 2, 3, 4, 13, 6, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %709 = "llvm.shufflevector"(%680, %704) <{mask = array<i32: 0, 1, 2, 3, 4, 13, 6, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %710 = "llvm.shufflevector"(%686, %705) <{mask = array<i32: 0, 1, 2, 3, 4, 13, 6, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %711 = "llvm.shufflevector"(%706, %595) <{mask = array<i32: 0, 8, 1, 9, 4, 12, 5, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %712 = "llvm.shufflevector"(%706, %603) <{mask = array<i32: 2, 10, 3, 11, 6, 14, 7, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %713 = "llvm.bitcast"(%711) : (vector<8xi32>) -> vector<4xi64>
  %714 = "llvm.bitcast"(%712) : (vector<8xi32>) -> vector<4xi64>
  %715 = "llvm.shufflevector"(%707, %595) <{mask = array<i32: 0, 8, 1, 9, 4, 12, 5, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %716 = "llvm.shufflevector"(%707, %603) <{mask = array<i32: 2, 10, 3, 11, 6, 14, 7, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %717 = "llvm.bitcast"(%715) : (vector<8xi32>) -> vector<4xi64>
  %718 = "llvm.bitcast"(%716) : (vector<8xi32>) -> vector<4xi64>
  %719 = "llvm.shufflevector"(%708, %595) <{mask = array<i32: 0, 8, 1, 9, 4, 12, 5, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %720 = "llvm.shufflevector"(%708, %603) <{mask = array<i32: 2, 10, 3, 11, 6, 14, 7, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %721 = "llvm.bitcast"(%719) : (vector<8xi32>) -> vector<4xi64>
  %722 = "llvm.bitcast"(%720) : (vector<8xi32>) -> vector<4xi64>
  %723 = "llvm.shufflevector"(%709, %595) <{mask = array<i32: 0, 8, 1, 9, 4, 12, 5, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %724 = "llvm.shufflevector"(%709, %603) <{mask = array<i32: 2, 10, 3, 11, 6, 14, 7, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %725 = "llvm.bitcast"(%723) : (vector<8xi32>) -> vector<4xi64>
  %726 = "llvm.bitcast"(%724) : (vector<8xi32>) -> vector<4xi64>
  %727 = "llvm.shufflevector"(%710, %595) <{mask = array<i32: 0, 8, 1, 9, 4, 12, 5, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %728 = "llvm.shufflevector"(%710, %603) <{mask = array<i32: 2, 10, 3, 11, 6, 14, 7, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %729 = "llvm.bitcast"(%727) : (vector<8xi32>) -> vector<4xi64>
  %730 = "llvm.bitcast"(%728) : (vector<8xi32>) -> vector<4xi64>
  %731 = "llvm.shl"(%711, %576) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %732 = "llvm.bitcast"(%731) : (vector<8xi32>) -> vector<4xi64>
  %733 = "llvm.shl"(%712, %576) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %734 = "llvm.bitcast"(%733) : (vector<8xi32>) -> vector<4xi64>
  %735 = "llvm.shl"(%715, %576) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %736 = "llvm.bitcast"(%735) : (vector<8xi32>) -> vector<4xi64>
  %737 = "llvm.shl"(%716, %576) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %738 = "llvm.bitcast"(%737) : (vector<8xi32>) -> vector<4xi64>
  %739 = "llvm.shl"(%719, %576) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %740 = "llvm.bitcast"(%739) : (vector<8xi32>) -> vector<4xi64>
  %741 = "llvm.shl"(%720, %576) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %742 = "llvm.bitcast"(%741) : (vector<8xi32>) -> vector<4xi64>
  %743 = "llvm.shl"(%723, %576) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %744 = "llvm.bitcast"(%743) : (vector<8xi32>) -> vector<4xi64>
  %745 = "llvm.shl"(%724, %576) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %746 = "llvm.bitcast"(%745) : (vector<8xi32>) -> vector<4xi64>
  %747 = "llvm.mul"(%722, %575) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %748 = "llvm.mul"(%725, %575) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %749 = "llvm.mul"(%726, %575) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %750 = "llvm.mul"(%729, %575) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %751 = "llvm.mul"(%730, %575) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %752 = "llvm.mul"(%713, %713) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %753 = "llvm.and"(%750, %574) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %754 = "llvm.mul"(%753, %736) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %755 = "llvm.and"(%748, %574) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %756 = "llvm.mul"(%755, %740) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %757 = "llvm.and"(%751, %574) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %758 = "llvm.mul"(%757, %734) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %759 = "llvm.and"(%749, %574) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %760 = "llvm.mul"(%759, %738) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %761 = "llvm.and"(%747, %574) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %762 = "llvm.mul"(%761, %722) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %763 = "llvm.add"(%760, %762) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %764 = "llvm.add"(%763, %758) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %765 = "llvm.shl"(%764, %573) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %766 = "llvm.add"(%756, %752) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %767 = "llvm.add"(%766, %754) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %768 = "llvm.add"(%767, %765) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %769 = "llvm.mul"(%732, %714) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %770 = "llvm.mul"(%753, %738) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %771 = "llvm.mul"(%755, %742) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %772 = "llvm.mul"(%757, %717) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %773 = "llvm.mul"(%759, %721) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %774 = "llvm.add"(%772, %773) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %775 = "llvm.shl"(%774, %573) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %776 = "llvm.add"(%771, %769) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %777 = "llvm.add"(%776, %770) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %778 = "llvm.add"(%777, %775) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %779 = "llvm.mul"(%717, %732) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %780 = "llvm.mul"(%734, %714) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %781 = "llvm.add"(%780, %779) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %782 = "llvm.mul"(%753, %740) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %783 = "llvm.mul"(%755, %725) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %784 = "llvm.mul"(%757, %738) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %785 = "llvm.mul"(%759, %742) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %786 = "llvm.add"(%784, %785) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %787 = "llvm.shl"(%786, %573) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %788 = "llvm.add"(%781, %783) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %789 = "llvm.add"(%788, %782) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %790 = "llvm.add"(%789, %787) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %791 = "llvm.mul"(%718, %732) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %792 = "llvm.mul"(%717, %734) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %793 = "llvm.add"(%792, %791) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %794 = "llvm.mul"(%753, %742) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %795 = "llvm.add"(%793, %794) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %796 = "llvm.mul"(%757, %721) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %797 = "llvm.mul"(%759, %725) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %798 = "llvm.add"(%796, %797) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %799 = "llvm.shl"(%798, %573) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %800 = "llvm.add"(%795, %799) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %801 = "llvm.mul"(%721, %732) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %802 = "llvm.mul"(%738, %734) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %803 = "llvm.mul"(%717, %717) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %804 = "llvm.mul"(%753, %744) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %805 = "llvm.mul"(%757, %742) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %806 = "llvm.mul"(%759, %726) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %807 = "llvm.add"(%805, %806) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %808 = "llvm.shl"(%807, %573) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %809 = "llvm.add"(%801, %803) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %810 = "llvm.add"(%809, %802) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %811 = "llvm.add"(%810, %804) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %812 = "llvm.add"(%811, %808) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %813 = "llvm.mul"(%722, %732) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %814 = "llvm.mul"(%721, %734) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %815 = "llvm.add"(%814, %813) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %816 = "llvm.mul"(%736, %718) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %817 = "llvm.add"(%815, %816) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %818 = "llvm.mul"(%753, %746) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %819 = "llvm.add"(%817, %818) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %820 = "llvm.mul"(%757, %725) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %821 = "llvm.shl"(%820, %573) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %822 = "llvm.add"(%819, %821) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %823 = "llvm.mul"(%725, %732) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %824 = "llvm.mul"(%742, %734) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %825 = "llvm.mul"(%721, %736) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %826 = "llvm.mul"(%738, %718) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %827 = "llvm.mul"(%753, %729) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %828 = "llvm.mul"(%757, %746) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %829 = "llvm.shl"(%828, %573) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %830 = "llvm.add"(%826, %825) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %831 = "llvm.add"(%830, %823) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %832 = "llvm.add"(%831, %824) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %833 = "llvm.add"(%832, %827) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %834 = "llvm.add"(%833, %829) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %835 = "llvm.mul"(%726, %732) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %836 = "llvm.mul"(%725, %734) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %837 = "llvm.mul"(%722, %736) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %838 = "llvm.mul"(%721, %738) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %839 = "llvm.mul"(%757, %729) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %840 = "llvm.shl"(%839, %573) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %841 = "llvm.add"(%838, %837) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %842 = "llvm.add"(%841, %835) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %843 = "llvm.add"(%842, %836) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %844 = "llvm.add"(%843, %840) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %845 = "llvm.mul"(%729, %732) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %846 = "llvm.mul"(%746, %734) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %847 = "llvm.mul"(%725, %736) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %848 = "llvm.mul"(%742, %738) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %849 = "llvm.mul"(%721, %721) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %850 = "llvm.mul"(%757, %730) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %851 = "llvm.shl"(%850, %573) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %852 = "llvm.add"(%847, %849) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %853 = "llvm.add"(%852, %848) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %854 = "llvm.add"(%853, %845) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %855 = "llvm.add"(%854, %846) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %856 = "llvm.add"(%855, %851) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %857 = "llvm.mul"(%730, %732) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %858 = "llvm.mul"(%729, %734) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %859 = "llvm.mul"(%726, %736) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %860 = "llvm.mul"(%725, %738) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %861 = "llvm.mul"(%740, %722) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %862 = "llvm.add"(%860, %859) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %863 = "llvm.add"(%862, %861) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %864 = "llvm.add"(%863, %857) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %865 = "llvm.add"(%864, %858) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %866 = "llvm.sub"(%607, %768) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %867 = "llvm.shufflevector"(%768, %866) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %868 = "llvm.sub"(%611, %778) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %869 = "llvm.shufflevector"(%778, %868) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %870 = "llvm.sub"(%615, %790) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %871 = "llvm.shufflevector"(%790, %870) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %872 = "llvm.sub"(%611, %800) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %873 = "llvm.shufflevector"(%800, %872) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %874 = "llvm.sub"(%615, %812) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %875 = "llvm.shufflevector"(%812, %874) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %876 = "llvm.sub"(%611, %822) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %877 = "llvm.shufflevector"(%822, %876) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %878 = "llvm.sub"(%615, %834) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %879 = "llvm.shufflevector"(%834, %878) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %880 = "llvm.sub"(%611, %844) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %881 = "llvm.shufflevector"(%844, %880) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %882 = "llvm.sub"(%615, %856) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %883 = "llvm.shufflevector"(%856, %882) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %884 = "llvm.sub"(%611, %865) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %885 = "llvm.shufflevector"(%865, %884) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %886 = "llvm.lshr"(%867, %567) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %887 = "llvm.add"(%886, %869) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %888 = "llvm.and"(%867, %566) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %889 = "llvm.lshr"(%875, %567) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %890 = "llvm.add"(%889, %877) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %891 = "llvm.and"(%875, %566) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %892 = "llvm.lshr"(%887, %565) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %893 = "llvm.add"(%892, %871) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %894 = "llvm.and"(%887, %564) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %895 = "llvm.lshr"(%890, %565) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %896 = "llvm.add"(%895, %879) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %897 = "llvm.and"(%890, %564) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %898 = "llvm.lshr"(%893, %567) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %899 = "llvm.add"(%898, %873) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %900 = "llvm.lshr"(%896, %567) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %901 = "llvm.add"(%900, %881) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %902 = "llvm.lshr"(%899, %565) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %903 = "llvm.add"(%902, %891) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %904 = "llvm.lshr"(%901, %565) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %905 = "llvm.add"(%904, %883) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %906 = "llvm.lshr"(%903, %567) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %907 = "llvm.add"(%906, %897) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %908 = "llvm.lshr"(%905, %567) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %909 = "llvm.add"(%908, %885) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %910 = "llvm.lshr"(%909, %565) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %911 = "llvm.and"(%910, %566) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %912 = "llvm.lshr"(%909, %563) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %913 = "llvm.mul"(%911, %575) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %914 = "llvm.mul"(%912, %575) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %915 = "llvm.add"(%913, %888) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %916 = "llvm.add"(%914, %894) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %917 = "llvm.lshr"(%915, %567) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %918 = "llvm.add"(%916, %917) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %919 = "llvm.bitcast"(%915) : (vector<4xi64>) -> vector<8xi32>
  %920 = "llvm.and"(%919, %623) : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %921 = "llvm.bitcast"(%918) : (vector<4xi64>) -> vector<8xi32>
  %922 = "llvm.shufflevector"(%920, %921) <{mask = array<i32: 0, 2, 8, 10, 4, 6, 12, 14>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %923 = "llvm.bitcast"(%893) : (vector<4xi64>) -> vector<8xi32>
  %924 = "llvm.and"(%923, %623) : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %925 = "llvm.bitcast"(%899) : (vector<4xi64>) -> vector<8xi32>
  %926 = "llvm.and"(%925, %631) : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %927 = "llvm.shufflevector"(%924, %926) <{mask = array<i32: 0, 2, 8, 10, 4, 6, 12, 14>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %928 = "llvm.bitcast"(%907) : (vector<4xi64>) -> vector<8xi32>
  %929 = "llvm.bitcast"(%903) : (vector<4xi64>) -> vector<8xi32>
  %930 = "llvm.and"(%929, %623) : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %931 = "llvm.shufflevector"(%930, %928) <{mask = array<i32: 0, 2, 8, 10, 4, 6, 12, 14>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %932 = "llvm.bitcast"(%896) : (vector<4xi64>) -> vector<8xi32>
  %933 = "llvm.and"(%932, %623) : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %934 = "llvm.bitcast"(%901) : (vector<4xi64>) -> vector<8xi32>
  %935 = "llvm.and"(%934, %631) : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %936 = "llvm.shufflevector"(%933, %935) <{mask = array<i32: 0, 2, 8, 10, 4, 6, 12, 14>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %937 = "llvm.bitcast"(%905) : (vector<4xi64>) -> vector<8xi32>
  %938 = "llvm.and"(%937, %623) : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %939 = "llvm.bitcast"(%909) : (vector<4xi64>) -> vector<8xi32>
  %940 = "llvm.and"(%939, %631) : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %941 = "llvm.shufflevector"(%938, %940) <{mask = array<i32: 0, 2, 8, 10, 4, 6, 12, 14>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %942 = "llvm.shufflevector"(%922, %584) <{mask = array<i32: 0, 0, 2, 2, 0, 0, 2, 2>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %943 = "llvm.shufflevector"(%927, %584) <{mask = array<i32: 0, 0, 2, 2, 0, 0, 2, 2>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %944 = "llvm.shufflevector"(%931, %584) <{mask = array<i32: 0, 0, 2, 2, 0, 0, 2, 2>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %945 = "llvm.shufflevector"(%936, %584) <{mask = array<i32: 0, 0, 2, 2, 0, 0, 2, 2>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %946 = "llvm.shufflevector"(%941, %584) <{mask = array<i32: 0, 0, 2, 2, 0, 0, 2, 2>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %947 = "llvm.shufflevector"(%922, %584) <{mask = array<i32: 1, 1, 3, 3, 1, 1, 3, 3>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %948 = "llvm.shufflevector"(%927, %584) <{mask = array<i32: 1, 1, 3, 3, 1, 1, 3, 3>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %949 = "llvm.shufflevector"(%931, %584) <{mask = array<i32: 1, 1, 3, 3, 1, 1, 3, 3>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %950 = "llvm.shufflevector"(%936, %584) <{mask = array<i32: 1, 1, 3, 3, 1, 1, 3, 3>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %951 = "llvm.shufflevector"(%941, %584) <{mask = array<i32: 1, 1, 3, 3, 1, 1, 3, 3>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %952 = "llvm.shl"(%922, %576) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %953 = "llvm.shl"(%927, %576) <{overflowFlags = 3 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %954 = "llvm.shl"(%931, %576) <{overflowFlags = 3 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %955 = "llvm.shl"(%936, %576) <{overflowFlags = 3 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %956 = "llvm.shl"(%941, %576) <{overflowFlags = 3 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %957 = "llvm.shufflevector"(%639, %952) <{mask = array<i32: 0, 1, 2, 3, 12, -1, 14, -1>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %958 = "llvm.shufflevector"(%639, %953) <{mask = array<i32: 0, 1, 2, 3, 12, -1, 14, -1>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %959 = "llvm.shufflevector"(%639, %954) <{mask = array<i32: 0, 1, 2, 3, 12, -1, 14, -1>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %960 = "llvm.shufflevector"(%639, %955) <{mask = array<i32: 0, 1, 2, 3, 12, -1, 14, -1>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %961 = "llvm.shufflevector"(%639, %956) <{mask = array<i32: 0, 1, 2, 3, 12, -1, 14, -1>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %962 = "llvm.shufflevector"(%957, %922) <{mask = array<i32: 0, 1, 2, 3, 4, 13, 6, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %963 = "llvm.shufflevector"(%958, %927) <{mask = array<i32: 0, 1, 2, 3, 4, 13, 6, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %964 = "llvm.shufflevector"(%959, %931) <{mask = array<i32: 0, 1, 2, 3, 4, 13, 6, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %965 = "llvm.shufflevector"(%960, %936) <{mask = array<i32: 0, 1, 2, 3, 4, 13, 6, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %966 = "llvm.shufflevector"(%961, %941) <{mask = array<i32: 0, 1, 2, 3, 4, 13, 6, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %967 = "llvm.add"(%962, %942) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %968 = "llvm.add"(%963, %943) <{overflowFlags = 3 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %969 = "llvm.add"(%964, %944) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %970 = "llvm.add"(%965, %945) <{overflowFlags = 3 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %971 = "llvm.add"(%966, %946) <{overflowFlags = 3 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %972 = "llvm.shufflevector"(%947, %647) <{mask = array<i32: 0, 9, 2, 11, 12, 5, 14, 7>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %973 = "llvm.shufflevector"(%948, %647) <{mask = array<i32: 0, 9, 2, 11, 12, 5, 14, 7>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %974 = "llvm.shufflevector"(%949, %647) <{mask = array<i32: 0, 9, 2, 11, 12, 5, 14, 7>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %975 = "llvm.shufflevector"(%950, %647) <{mask = array<i32: 0, 9, 2, 11, 12, 5, 14, 7>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %976 = "llvm.shufflevector"(%951, %647) <{mask = array<i32: 0, 9, 2, 11, 12, 5, 14, 7>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %977 = "llvm.add"(%967, %972) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %978 = "llvm.add"(%968, %973) <{overflowFlags = 3 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %979 = "llvm.add"(%969, %974) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %980 = "llvm.add"(%970, %975) <{overflowFlags = 3 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %981 = "llvm.add"(%971, %976) <{overflowFlags = 3 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %982 = "llvm.sub"(%655, %947) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %983 = "llvm.sub"(%663, %948) <{overflowFlags = 1 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %984 = "llvm.sub"(%663, %949) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %985 = "llvm.sub"(%663, %950) <{overflowFlags = 1 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %986 = "llvm.sub"(%663, %951) <{overflowFlags = 1 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %987 = "llvm.shufflevector"(%671, %982) <{mask = array<i32: 0, 9, 2, 11, 12, 5, 14, 7>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %988 = "llvm.shufflevector"(%671, %983) <{mask = array<i32: 0, 9, 2, 11, 12, 5, 14, 7>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %989 = "llvm.shufflevector"(%671, %984) <{mask = array<i32: 0, 9, 2, 11, 12, 5, 14, 7>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %990 = "llvm.shufflevector"(%671, %985) <{mask = array<i32: 0, 9, 2, 11, 12, 5, 14, 7>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %991 = "llvm.shufflevector"(%671, %986) <{mask = array<i32: 0, 9, 2, 11, 12, 5, 14, 7>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %992 = "llvm.add"(%977, %987) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %993 = "llvm.add"(%978, %988) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %994 = "llvm.add"(%979, %989) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %995 = "llvm.add"(%980, %990) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %996 = "llvm.add"(%981, %991) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %997 = "llvm.shufflevector"(%992, %584) <{mask = array<i32: 5, 1, 7, 3, 1, 5, 3, 7>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %998 = "llvm.shufflevector"(%993, %584) <{mask = array<i32: 5, 1, 7, 3, 1, 5, 3, 7>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %999 = "llvm.shufflevector"(%994, %584) <{mask = array<i32: 5, 1, 7, 3, 1, 5, 3, 7>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1000 = "llvm.shufflevector"(%995, %584) <{mask = array<i32: 5, 1, 7, 3, 1, 5, 3, 7>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1001 = "llvm.shufflevector"(%996, %584) <{mask = array<i32: 5, 1, 7, 3, 1, 5, 3, 7>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  "llvm.store"(%997, %672) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  "llvm.store"(%998, %697) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  "llvm.store"(%999, %698) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  "llvm.store"(%1000, %699) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  "llvm.store"(%1001, %700) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  %1002 = "llvm.shufflevector"(%992, %584) <{mask = array<i32: 4, 0, 6, 2, 4, 0, 6, 2>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1003 = "llvm.shufflevector"(%993, %584) <{mask = array<i32: 4, 0, 6, 2, 4, 0, 6, 2>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1004 = "llvm.shufflevector"(%994, %584) <{mask = array<i32: 4, 0, 6, 2, 4, 0, 6, 2>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1005 = "llvm.shufflevector"(%995, %584) <{mask = array<i32: 4, 0, 6, 2, 4, 0, 6, 2>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1006 = "llvm.shufflevector"(%996, %584) <{mask = array<i32: 4, 0, 6, 2, 4, 0, 6, 2>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  "llvm.store"(%1002, %673) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  "llvm.store"(%1003, %688) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  "llvm.store"(%1004, %689) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  "llvm.store"(%1005, %690) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  "llvm.store"(%1006, %691) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  "llvm.call"(%arg18, %673, %672) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvXNvXsf_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx25fieldRNtB8_18FieldElement2625x4NtNtNtCsgxBkk5gSRhY_4core3ops5arith3Mul3mulB1a_NtB2_12___Impl_mul__9__impl_mul, fastmathFlags = #llvm.fastmath<none>, inline_hint, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%672) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%673) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
