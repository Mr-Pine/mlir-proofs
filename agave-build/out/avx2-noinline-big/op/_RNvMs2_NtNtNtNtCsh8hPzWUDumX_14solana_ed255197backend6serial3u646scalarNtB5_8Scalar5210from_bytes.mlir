#alias_scope_domain46 = #llvm.alias_scope_domain<id = distinct[46]<>, description = "_RNvXCshxoft6be3N1_7zeroizeyNtB2_7Zeroize7zeroizeCsh8hPzWUDumX_14solana_ed25519">
#alias_scope_domain47 = #llvm.alias_scope_domain<id = distinct[47]<>, description = "_RNvXs4_Cshxoft6be3N1_7zeroizeINtNtNtCsgxBkk5gSRhY_4core5slice4iter7IterMutyENtB5_7Zeroize7zeroizeCsh8hPzWUDumX_14solana_ed25519">
#alias_scope65 = #llvm.alias_scope<id = distinct[194]<>, domain = #alias_scope_domain46, description = "_RNvXCshxoft6be3N1_7zeroizeyNtB2_7Zeroize7zeroizeCsh8hPzWUDumX_14solana_ed25519: argument 0">
#alias_scope66 = #llvm.alias_scope<id = distinct[195]<>, domain = #alias_scope_domain47, description = "_RNvXs4_Cshxoft6be3N1_7zeroizeINtNtNtCsgxBkk5gSRhY_4core5slice4iter7IterMutyENtB5_7Zeroize7zeroizeCsh8hPzWUDumX_14solana_ed25519: argument 0">
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 8 : i64, llvm.dead_on_unwind, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writable, llvm.writeonly}, {llvm.dereferenceable = 32 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], sym_name = "_RNvMs2_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar5210from_bytes", target_cpu = "x86-64-v2", target_features = #llvm.target_features<["+avx", "+avx2", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+crc32", "+ssse3"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg77: !llvm.ptr, %arg78: !llvm.ptr):
  %2588 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %2589 = "llvm.mlir.constant"() <{value = 8 : i64}> : () -> i64
  %2590 = "llvm.mlir.constant"() <{value = 12 : i64}> : () -> i64
  %2591 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %2592 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
  %2593 = "llvm.mlir.constant"() <{value = 48 : i64}> : () -> i64
  %2594 = "llvm.mlir.constant"() <{value = 16 : i64}> : () -> i64
  %2595 = "llvm.mlir.constant"() <{value = 24 : i64}> : () -> i64
  %2596 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %2597 = "llvm.mlir.constant"() <{value = 36 : i64}> : () -> i64
  %2598 = "llvm.mlir.constant"() <{value = 4503599627370495 : i64}> : () -> i64
  %2599 = "llvm.alloca"(%2588) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %2600 = "llvm.alloca"(%2588) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %2601 = "llvm.alloca"(%2588) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %2602 = "llvm.alloca"(%2588) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%2599) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2600) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2601) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2602) : (!llvm.ptr) -> ()
  %2603 = "llvm.load"(%arg78) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2604 = "llvm.getelementptr"(%arg78) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %2605 = "llvm.load"(%2604) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %2606 = "llvm.zext"(%2605) : (i32) -> i64
  %2607 = "llvm.getelementptr"(%arg78) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 12>}> : (!llvm.ptr) -> !llvm.ptr
  %2608 = "llvm.load"(%2607) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2609 = "llvm.zext"(%2608) : (i8) -> i64
  %2610 = "llvm.shl"(%2609, %2591) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2611 = "llvm.or"(%2610, %2606) <{isDisjoint}> : (i64, i64) -> i64
  %2612 = "llvm.getelementptr"(%arg78) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 13>}> : (!llvm.ptr) -> !llvm.ptr
  %2613 = "llvm.load"(%2612) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2614 = "llvm.zext"(%2613) : (i8) -> i64
  %2615 = "llvm.shl"(%2614, %2592) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2616 = "llvm.getelementptr"(%arg78) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 14>}> : (!llvm.ptr) -> !llvm.ptr
  %2617 = "llvm.load"(%2616) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i16
  %2618 = "llvm.zext"(%2617) : (i16) -> i64
  %2619 = "llvm.shl"(%2618, %2593) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %2620 = "llvm.or"(%2615, %2619) <{isDisjoint}> : (i64, i64) -> i64
  %2621 = "llvm.or"(%2620, %2611) <{isDisjoint}> : (i64, i64) -> i64
  "llvm.store"(%2621, %2600) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %2622 = "llvm.getelementptr"(%arg78) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %2623 = "llvm.load"(%2622) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i16
  %2624 = "llvm.zext"(%2623) : (i16) -> i64
  %2625 = "llvm.getelementptr"(%arg78) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 18>}> : (!llvm.ptr) -> !llvm.ptr
  %2626 = "llvm.load"(%2625) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2627 = "llvm.zext"(%2626) : (i8) -> i64
  %2628 = "llvm.shl"(%2627, %2594) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2629 = "llvm.or"(%2628, %2624) <{isDisjoint}> : (i64, i64) -> i64
  %2630 = "llvm.getelementptr"(%arg78) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 19>}> : (!llvm.ptr) -> !llvm.ptr
  %2631 = "llvm.load"(%2630) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2632 = "llvm.zext"(%2631) : (i8) -> i64
  %2633 = "llvm.shl"(%2632, %2595) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2634 = "llvm.or"(%2633, %2629) <{isDisjoint}> : (i64, i64) -> i64
  %2635 = "llvm.getelementptr"(%arg78) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 20>}> : (!llvm.ptr) -> !llvm.ptr
  %2636 = "llvm.load"(%2635) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i16
  %2637 = "llvm.zext"(%2636) : (i16) -> i64
  %2638 = "llvm.shl"(%2637, %2591) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2639 = "llvm.getelementptr"(%arg78) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 22>}> : (!llvm.ptr) -> !llvm.ptr
  %2640 = "llvm.load"(%2639) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i16
  %2641 = "llvm.zext"(%2640) : (i16) -> i64
  %2642 = "llvm.shl"(%2641, %2593) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %2643 = "llvm.or"(%2638, %2642) <{isDisjoint}> : (i64, i64) -> i64
  %2644 = "llvm.or"(%2643, %2634) <{isDisjoint}> : (i64, i64) -> i64
  "llvm.store"(%2644, %2601) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %2645 = "llvm.getelementptr"(%arg78) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %2646 = "llvm.load"(%2645) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2647 = "llvm.zext"(%2646) : (i8) -> i64
  %2648 = "llvm.getelementptr"(%arg78) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 25>}> : (!llvm.ptr) -> !llvm.ptr
  %2649 = "llvm.load"(%2648) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2650 = "llvm.zext"(%2649) : (i8) -> i64
  %2651 = "llvm.shl"(%2650, %2589) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2652 = "llvm.or"(%2651, %2647) <{isDisjoint}> : (i64, i64) -> i64
  %2653 = "llvm.getelementptr"(%arg78) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 26>}> : (!llvm.ptr) -> !llvm.ptr
  %2654 = "llvm.load"(%2653) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i16
  %2655 = "llvm.zext"(%2654) : (i16) -> i64
  %2656 = "llvm.shl"(%2655, %2594) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2657 = "llvm.getelementptr"(%arg78) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 28>}> : (!llvm.ptr) -> !llvm.ptr
  %2658 = "llvm.load"(%2657) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i16
  %2659 = "llvm.zext"(%2658) : (i16) -> i64
  %2660 = "llvm.shl"(%2659, %2591) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2661 = "llvm.or"(%2656, %2660) <{isDisjoint}> : (i64, i64) -> i64
  %2662 = "llvm.getelementptr"(%arg78) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 30>}> : (!llvm.ptr) -> !llvm.ptr
  %2663 = "llvm.load"(%2662) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i16
  %2664 = "llvm.zext"(%2663) : (i16) -> i64
  %2665 = "llvm.shl"(%2664, %2593) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %2666 = "llvm.or"(%2661, %2665) <{isDisjoint}> : (i64, i64) -> i64
  %2667 = "llvm.or"(%2666, %2652) <{isDisjoint}> : (i64, i64) -> i64
  "llvm.store"(%2667, %2602) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.store"(%2596, %2599) <{alias_scopes = [#alias_scope65], alignment = 8 : i64, noalias_scopes = [#alias_scope66], ordering = 0 : i64, volatile_}> : (i64, !llvm.ptr) -> ()
  "llvm.fence"() <{ordering = 7 : i64, syncscope = "singlethread"}> : () -> ()
  "llvm.store"(%2596, %2600) <{alias_scopes = [#alias_scope65], alignment = 8 : i64, noalias_scopes = [#alias_scope66], ordering = 0 : i64, volatile_}> : (i64, !llvm.ptr) -> ()
  "llvm.fence"() <{ordering = 7 : i64, syncscope = "singlethread"}> : () -> ()
  "llvm.store"(%2596, %2601) <{alias_scopes = [#alias_scope65], alignment = 8 : i64, noalias_scopes = [#alias_scope66], ordering = 0 : i64, volatile_}> : (i64, !llvm.ptr) -> ()
  "llvm.fence"() <{ordering = 7 : i64, syncscope = "singlethread"}> : () -> ()
  "llvm.store"(%2596, %2602) <{alias_scopes = [#alias_scope65], alignment = 8 : i64, noalias_scopes = [#alias_scope66], ordering = 0 : i64, volatile_}> : (i64, !llvm.ptr) -> ()
  "llvm.fence"() <{ordering = 7 : i64, syncscope = "singlethread"}> : () -> ()
  %2668 = "llvm.lshr"(%2666, %2594) <{isExact}> : (i64, i64) -> i64
  %2669 = "llvm.intr.fshl"(%2652, %2644, %2597) : (i64, i64, i64) -> i64
  %2670 = "llvm.intr.fshl"(%2634, %2620, %2595) : (i64, i64, i64) -> i64
  %2671 = "llvm.and"(%2670, %2598) : (i64, i64) -> i64
  %2672 = "llvm.intr.fshl"(%2611, %2603, %2590) : (i64, i64, i64) -> i64
  %2673 = "llvm.and"(%2603, %2598) : (i64, i64) -> i64
  "llvm.store"(%2673, %arg77) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %2674 = "llvm.getelementptr"(%arg77) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2672, %2674) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %2675 = "llvm.getelementptr"(%arg77) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2671, %2675) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %2676 = "llvm.getelementptr"(%arg77) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2669, %2676) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %2677 = "llvm.getelementptr"(%arg77) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2668, %2677) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2599) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2600) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2601) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2602) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
