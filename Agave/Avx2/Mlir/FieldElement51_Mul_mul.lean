module

-- agave-build/out/avx2-noinline/op/_RNvXs5_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u645fieldRNtB5_14FieldElement51NtNtNtCsgxBkk5gSRhY_4core3ops5arith3Mul3mul.mlir
-- <&solana_ed25519[c79103de3f6f5451]::backend::serial::u64::field::FieldElement51 as core[c0acaeba6ab4c2e0]::ops::arith::Mul>::mul

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Agave.Avx2

@[expose] public section

mlir_def FieldElement51_Mul_mul :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 8 : i64, llvm.dead_on_unwind, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writable, llvm.writeonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], sym_name = "_RNvXs5_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u645fieldRNtB5_14FieldElement51NtNtNtCsgxBkk5gSRhY_4core3ops5arith3Mul3mul", target_cpu = "x86-64-v2", target_features = #llvm.target_features<["+avx", "+avx2", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+crc32", "+ssse3"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg59: !llvm.ptr, %arg60: !llvm.ptr, %arg61: !llvm.ptr):
  %2530 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %2531 = "llvm.mlir.constant"() <{value = 51 : i128}> : () -> i128
  %2532 = "llvm.mlir.constant"() <{value = 18446744073709551615 : i128}> : () -> i128
  %2533 = "llvm.mlir.constant"() <{value = 2251799813685247 : i64}> : () -> i64
  %2534 = "llvm.mlir.constant"() <{value = 51 : i64}> : () -> i64
  %2535 = "llvm.getelementptr"(%arg61) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %2536 = "llvm.load"(%2535) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2537 = "llvm.mul"(%2536, %2530) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2538 = "llvm.getelementptr"(%arg61) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %2539 = "llvm.load"(%2538) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2540 = "llvm.mul"(%2539, %2530) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2541 = "llvm.getelementptr"(%arg61) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %2542 = "llvm.load"(%2541) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2543 = "llvm.mul"(%2542, %2530) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2544 = "llvm.getelementptr"(%arg61) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %2545 = "llvm.load"(%2544) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2546 = "llvm.mul"(%2545, %2530) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2547 = "llvm.load"(%arg60) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2548 = "llvm.load"(%arg61) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2549 = "llvm.zext"(%2547) : (i64) -> i128
  %2550 = "llvm.zext"(%2548) : (i64) -> i128
  %2551 = "llvm.mul"(%2550, %2549) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2552 = "llvm.getelementptr"(%arg60) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %2553 = "llvm.load"(%2552) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2554 = "llvm.zext"(%2553) : (i64) -> i128
  %2555 = "llvm.zext"(%2537) : (i64) -> i128
  %2556 = "llvm.mul"(%2554, %2555) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2557 = "llvm.add"(%2556, %2551) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2558 = "llvm.getelementptr"(%arg60) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %2559 = "llvm.load"(%2558) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2560 = "llvm.zext"(%2559) : (i64) -> i128
  %2561 = "llvm.zext"(%2540) : (i64) -> i128
  %2562 = "llvm.mul"(%2560, %2561) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2563 = "llvm.add"(%2557, %2562) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2564 = "llvm.getelementptr"(%arg60) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %2565 = "llvm.load"(%2564) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2566 = "llvm.zext"(%2565) : (i64) -> i128
  %2567 = "llvm.zext"(%2543) : (i64) -> i128
  %2568 = "llvm.mul"(%2566, %2567) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2569 = "llvm.add"(%2563, %2568) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2570 = "llvm.getelementptr"(%arg60) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %2571 = "llvm.load"(%2570) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2572 = "llvm.zext"(%2571) : (i64) -> i128
  %2573 = "llvm.zext"(%2546) : (i64) -> i128
  %2574 = "llvm.mul"(%2572, %2573) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2575 = "llvm.add"(%2569, %2574) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2576 = "llvm.mul"(%2572, %2550) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2577 = "llvm.zext"(%2536) : (i64) -> i128
  %2578 = "llvm.mul"(%2549, %2577) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2579 = "llvm.mul"(%2554, %2561) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2580 = "llvm.mul"(%2560, %2567) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2581 = "llvm.mul"(%2566, %2573) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2582 = "llvm.mul"(%2566, %2550) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2583 = "llvm.mul"(%2572, %2577) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2584 = "llvm.zext"(%2539) : (i64) -> i128
  %2585 = "llvm.mul"(%2549, %2584) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2586 = "llvm.mul"(%2554, %2567) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2587 = "llvm.mul"(%2560, %2573) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2588 = "llvm.mul"(%2560, %2550) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2589 = "llvm.mul"(%2566, %2577) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2590 = "llvm.mul"(%2572, %2584) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2591 = "llvm.zext"(%2542) : (i64) -> i128
  %2592 = "llvm.mul"(%2549, %2591) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2593 = "llvm.mul"(%2554, %2573) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2594 = "llvm.mul"(%2554, %2550) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2595 = "llvm.mul"(%2560, %2577) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2596 = "llvm.mul"(%2566, %2584) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2597 = "llvm.mul"(%2572, %2591) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2598 = "llvm.zext"(%2545) : (i64) -> i128
  %2599 = "llvm.mul"(%2549, %2598) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2600 = "llvm.lshr"(%2575, %2531) : (i128, i128) -> i128
  %2601 = "llvm.and"(%2600, %2532) : (i128, i128) -> i128
  %2602 = "llvm.add"(%2579, %2578) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2603 = "llvm.add"(%2602, %2580) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2604 = "llvm.add"(%2603, %2581) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2605 = "llvm.add"(%2604, %2576) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2606 = "llvm.add"(%2605, %2601) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2607 = "llvm.trunc"(%2575) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %2608 = "llvm.and"(%2607, %2533) : (i64, i64) -> i64
  %2609 = "llvm.lshr"(%2606, %2531) : (i128, i128) -> i128
  %2610 = "llvm.and"(%2609, %2532) : (i128, i128) -> i128
  %2611 = "llvm.add"(%2586, %2585) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2612 = "llvm.add"(%2611, %2587) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2613 = "llvm.add"(%2612, %2582) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2614 = "llvm.add"(%2613, %2583) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2615 = "llvm.add"(%2614, %2610) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2616 = "llvm.trunc"(%2606) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %2617 = "llvm.and"(%2616, %2533) : (i64, i64) -> i64
  %2618 = "llvm.lshr"(%2615, %2531) : (i128, i128) -> i128
  %2619 = "llvm.and"(%2618, %2532) : (i128, i128) -> i128
  %2620 = "llvm.add"(%2593, %2592) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2621 = "llvm.add"(%2620, %2588) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2622 = "llvm.add"(%2621, %2589) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2623 = "llvm.add"(%2622, %2590) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2624 = "llvm.add"(%2623, %2619) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2625 = "llvm.trunc"(%2615) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %2626 = "llvm.and"(%2625, %2533) : (i64, i64) -> i64
  %2627 = "llvm.lshr"(%2624, %2531) : (i128, i128) -> i128
  %2628 = "llvm.and"(%2627, %2532) : (i128, i128) -> i128
  %2629 = "llvm.add"(%2594, %2599) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2630 = "llvm.add"(%2629, %2595) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2631 = "llvm.add"(%2630, %2596) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2632 = "llvm.add"(%2631, %2597) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2633 = "llvm.add"(%2632, %2628) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2634 = "llvm.trunc"(%2624) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %2635 = "llvm.and"(%2634, %2533) : (i64, i64) -> i64
  %2636 = "llvm.lshr"(%2633, %2531) : (i128, i128) -> i128
  %2637 = "llvm.trunc"(%2636) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %2638 = "llvm.trunc"(%2633) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %2639 = "llvm.and"(%2638, %2533) : (i64, i64) -> i64
  %2640 = "llvm.mul"(%2637, %2530) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2641 = "llvm.add"(%2640, %2608) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2642 = "llvm.lshr"(%2641, %2534) : (i64, i64) -> i64
  %2643 = "llvm.add"(%2642, %2617) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2644 = "llvm.and"(%2641, %2533) : (i64, i64) -> i64
  "llvm.store"(%2644, %arg59) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %2645 = "llvm.getelementptr"(%arg59) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2643, %2645) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %2646 = "llvm.getelementptr"(%arg59) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2626, %2646) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %2647 = "llvm.getelementptr"(%arg59) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2635, %2647) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %2648 = "llvm.getelementptr"(%arg59) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2639, %2648) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end MLIR.Agave.Avx2
