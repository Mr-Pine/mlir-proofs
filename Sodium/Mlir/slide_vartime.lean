module

-- sodium-build/out/op/slide_vartime.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Sodium

@[expose] public section

mlir_def slide_vartime :=
#loop_annotation = #llvm.loop_annotation<mustProgress = true>
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "ssp", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], sym_name = "slide_vartime", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg58: !llvm.ptr, %arg59: !llvm.ptr):
  %2482 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %2483 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %2484 = "llvm.mlir.constant"() <{value = 536870911 : i64}> : () -> i64
  %2485 = "llvm.mlir.constant"() <{value = 6 : i8}> : () -> i8
  %2486 = "llvm.mlir.constant"() <{value = 1 : i8}> : () -> i8
  %2487 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %2488 = "llvm.mlir.constant"() <{value = 7 : i8}> : () -> i8
  %2489 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %2490 = "llvm.mlir.constant"() <{value = 256 : i64}> : () -> i64
  %2491 = "llvm.mlir.constant"() <{value = 254 : i32}> : () -> i32
  %2492 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %2493 = "llvm.mlir.constant"() <{value = 255 : i64}> : () -> i64
  %2494 = "llvm.mlir.constant"() <{value = false}> : () -> i1
  %2495 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %2496 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %2497 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %2498 = "llvm.mlir.constant"() <{value = 16 : i32}> : () -> i32
  %2499 = "llvm.mlir.constant"() <{value = -15 : i32}> : () -> i32
  %2500 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %2501 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %2502 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %2503 = "llvm.mlir.constant"() <{value = 4 : i64}> : () -> i64
  %2504 = "llvm.mlir.constant"() <{value = 5 : i64}> : () -> i64
  %2505 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %2506 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
  "llvm.br"(%2482)[^bb1] : (i64) -> ()
^bb1(%2507: i64):  // 2 preds: ^bb0, ^bb1
  %2508 = "llvm.trunc"(%2507) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %2509 = "llvm.lshr"(%2507, %2483) : (i64, i64) -> i64
  %2510 = "llvm.and"(%2509, %2484) : (i64, i64) -> i64
  %2511 = "llvm.getelementptr"(%arg59, %2510) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %2512 = "llvm.load"(%2511) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2513 = "llvm.and"(%2508, %2485) : (i8, i8) -> i8
  %2514 = "llvm.lshr"(%2512, %2513) : (i8, i8) -> i8
  %2515 = "llvm.and"(%2514, %2486) : (i8, i8) -> i8
  %2516 = "llvm.getelementptr"(%arg58, %2507) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%2515, %2516) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2517 = "llvm.or"(%2507, %2487) <{isDisjoint}> : (i64, i64) -> i64
  %2518 = "llvm.trunc"(%2517) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %2519 = "llvm.lshr"(%2507, %2483) : (i64, i64) -> i64
  %2520 = "llvm.and"(%2519, %2484) : (i64, i64) -> i64
  %2521 = "llvm.getelementptr"(%arg59, %2520) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %2522 = "llvm.load"(%2521) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2523 = "llvm.and"(%2518, %2488) : (i8, i8) -> i8
  %2524 = "llvm.lshr"(%2522, %2523) : (i8, i8) -> i8
  %2525 = "llvm.and"(%2524, %2486) : (i8, i8) -> i8
  %2526 = "llvm.getelementptr"(%arg58, %2517) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%2525, %2526) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2527 = "llvm.add"(%2507, %2489) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2528 = "llvm.icmp"(%2527, %2490) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%2528, %2482, %2491, %2487, %2527)[^bb2, ^bb1] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 3, 1>}> : (i1, i64, i32, i64, i64) -> ()
^bb2(%2529: i64, %2530: i32, %2531: i64):  // 2 preds: ^bb1, ^bb56
  %2532 = "llvm.getelementptr"(%arg58, %2529) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %2533 = "llvm.load"(%2532) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2534 = "llvm.icmp"(%2533, %2492) <{predicate = 1 : i64}> : (i8, i8) -> i1
  %2535 = "llvm.icmp"(%2529, %2493) <{predicate = 6 : i64}> : (i64, i64) -> i1
  %2536 = "llvm.select"(%2534, %2535, %2494) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i1, i1) -> i1
  "llvm.cond_br"(%2536)[^bb3, ^bb56] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb3:  // pred: ^bb2
  %2537 = "llvm.intr.umin"(%2530, %2495) : (i32, i32) -> i32
  %2538 = "llvm.add"(%2537, %2496) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %2539 = "llvm.getelementptr"(%arg58, %2531) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %2540 = "llvm.load"(%2539) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2541 = "llvm.icmp"(%2540, %2492) <{predicate = 0 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%2541)[^bb11, ^bb4] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb4:  // pred: ^bb3
  %2542 = "llvm.sext"(%2540) : (i8) -> i32
  %2543 = "llvm.shl"(%2542, %2497) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %2544 = "llvm.load"(%2532) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2545 = "llvm.sext"(%2544) : (i8) -> i32
  %2546 = "llvm.add"(%2543, %2545) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %2547 = "llvm.icmp"(%2546, %2498) <{predicate = 2 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2547)[^bb5, ^bb6] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb5:  // pred: ^bb4
  %2548 = "llvm.trunc"(%2546) <{overflowFlags = 0 : i32}> : (i32) -> i8
  "llvm.store"(%2548, %2532) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.store"(%2492, %2539) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.br"()[^bb11] : () -> ()
^bb6:  // pred: ^bb4
  %2549 = "llvm.sub"(%2545, %2543) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %2550 = "llvm.icmp"(%2549, %2499) <{predicate = 2 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2550)[^bb56, ^bb7] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb7:  // pred: ^bb6
  %2551 = "llvm.trunc"(%2549) <{overflowFlags = 0 : i32}> : (i32) -> i8
  "llvm.store"(%2551, %2532) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.br"(%2531)[^bb8] : (i64) -> ()
^bb8(%2552: i64):  // 2 preds: ^bb7, ^bb10
  %2553 = "llvm.getelementptr"(%arg58, %2552) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %2554 = "llvm.load"(%2553) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2555 = "llvm.icmp"(%2554, %2492) <{predicate = 0 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%2555)[^bb9, ^bb10] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb9:  // pred: ^bb8
  "llvm.store"(%2486, %2553) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.br"()[^bb11] : () -> ()
^bb10:  // pred: ^bb8
  "llvm.store"(%2492, %2553) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2556 = "llvm.add"(%2552, %2487) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2557 = "llvm.icmp"(%2556, %2490) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%2557, %2556)[^bb11, ^bb8] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb11:  // 4 preds: ^bb3, ^bb5, ^bb9, ^bb10
  %2558 = "llvm.add"(%2531, %2487) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2559 = "llvm.icmp"(%2530, %2500) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2559)[^bb56, ^bb12] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb12:  // pred: ^bb11
  %2560 = "llvm.getelementptr"(%arg58, %2558) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %2561 = "llvm.load"(%2560) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2562 = "llvm.icmp"(%2561, %2492) <{predicate = 0 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%2562)[^bb20, ^bb13] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb13:  // pred: ^bb12
  %2563 = "llvm.sext"(%2561) : (i8) -> i32
  %2564 = "llvm.shl"(%2563, %2496) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %2565 = "llvm.load"(%2532) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2566 = "llvm.sext"(%2565) : (i8) -> i32
  %2567 = "llvm.add"(%2564, %2566) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %2568 = "llvm.icmp"(%2567, %2498) <{predicate = 2 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2568)[^bb19, ^bb14] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb14:  // pred: ^bb13
  %2569 = "llvm.sub"(%2566, %2564) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %2570 = "llvm.icmp"(%2569, %2499) <{predicate = 2 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2570)[^bb56, ^bb15] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb15:  // pred: ^bb14
  %2571 = "llvm.trunc"(%2569) <{overflowFlags = 0 : i32}> : (i32) -> i8
  "llvm.store"(%2571, %2532) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.br"(%2558)[^bb16] : (i64) -> ()
^bb16(%2572: i64):  // 2 preds: ^bb15, ^bb17
  %2573 = "llvm.getelementptr"(%arg58, %2572) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %2574 = "llvm.load"(%2573) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2575 = "llvm.icmp"(%2574, %2492) <{predicate = 0 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%2575)[^bb18, ^bb17] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb17:  // pred: ^bb16
  "llvm.store"(%2492, %2573) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2576 = "llvm.add"(%2572, %2487) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2577 = "llvm.icmp"(%2576, %2490) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%2577, %2576)[^bb20, ^bb16] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb18:  // pred: ^bb16
  "llvm.store"(%2486, %2573) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.br"()[^bb20] : () -> ()
^bb19:  // pred: ^bb13
  %2578 = "llvm.trunc"(%2567) <{overflowFlags = 0 : i32}> : (i32) -> i8
  "llvm.store"(%2578, %2532) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.store"(%2492, %2560) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.br"()[^bb20] : () -> ()
^bb20:  // 4 preds: ^bb12, ^bb17, ^bb18, ^bb19
  %2579 = "llvm.add"(%2531, %2489) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2580 = "llvm.icmp"(%2538, %2501) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2580)[^bb56, ^bb21] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb21:  // pred: ^bb20
  %2581 = "llvm.getelementptr"(%arg58, %2579) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %2582 = "llvm.load"(%2581) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2583 = "llvm.icmp"(%2582, %2492) <{predicate = 0 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%2583)[^bb29, ^bb22] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb22:  // pred: ^bb21
  %2584 = "llvm.sext"(%2582) : (i8) -> i32
  %2585 = "llvm.shl"(%2584, %2501) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %2586 = "llvm.load"(%2532) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2587 = "llvm.sext"(%2586) : (i8) -> i32
  %2588 = "llvm.add"(%2585, %2587) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %2589 = "llvm.icmp"(%2588, %2498) <{predicate = 2 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2589)[^bb28, ^bb23] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb23:  // pred: ^bb22
  %2590 = "llvm.sub"(%2587, %2585) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %2591 = "llvm.icmp"(%2590, %2499) <{predicate = 2 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2591)[^bb56, ^bb24] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb24:  // pred: ^bb23
  %2592 = "llvm.trunc"(%2590) <{overflowFlags = 0 : i32}> : (i32) -> i8
  "llvm.store"(%2592, %2532) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.br"(%2579)[^bb25] : (i64) -> ()
^bb25(%2593: i64):  // 2 preds: ^bb24, ^bb26
  %2594 = "llvm.getelementptr"(%arg58, %2593) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %2595 = "llvm.load"(%2594) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2596 = "llvm.icmp"(%2595, %2492) <{predicate = 0 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%2596)[^bb27, ^bb26] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb26:  // pred: ^bb25
  "llvm.store"(%2492, %2594) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2597 = "llvm.add"(%2593, %2487) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2598 = "llvm.icmp"(%2597, %2490) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%2598, %2597)[^bb29, ^bb25] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb27:  // pred: ^bb25
  "llvm.store"(%2486, %2594) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.br"()[^bb29] : () -> ()
^bb28:  // pred: ^bb22
  %2599 = "llvm.trunc"(%2588) <{overflowFlags = 0 : i32}> : (i32) -> i8
  "llvm.store"(%2599, %2532) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.store"(%2492, %2581) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.br"()[^bb29] : () -> ()
^bb29:  // 4 preds: ^bb21, ^bb26, ^bb27, ^bb28
  %2600 = "llvm.add"(%2531, %2483) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2601 = "llvm.icmp"(%2538, %2502) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2601)[^bb56, ^bb30] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb30:  // pred: ^bb29
  %2602 = "llvm.getelementptr"(%arg58, %2600) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %2603 = "llvm.load"(%2602) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2604 = "llvm.icmp"(%2603, %2492) <{predicate = 0 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%2604)[^bb38, ^bb31] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb31:  // pred: ^bb30
  %2605 = "llvm.sext"(%2603) : (i8) -> i32
  %2606 = "llvm.shl"(%2605, %2502) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %2607 = "llvm.load"(%2532) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2608 = "llvm.sext"(%2607) : (i8) -> i32
  %2609 = "llvm.add"(%2606, %2608) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %2610 = "llvm.icmp"(%2609, %2498) <{predicate = 2 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2610)[^bb37, ^bb32] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb32:  // pred: ^bb31
  %2611 = "llvm.sub"(%2608, %2606) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %2612 = "llvm.icmp"(%2611, %2499) <{predicate = 2 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2612)[^bb56, ^bb33] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb33:  // pred: ^bb32
  %2613 = "llvm.trunc"(%2611) <{overflowFlags = 0 : i32}> : (i32) -> i8
  "llvm.store"(%2613, %2532) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.br"(%2600)[^bb34] : (i64) -> ()
^bb34(%2614: i64):  // 2 preds: ^bb33, ^bb35
  %2615 = "llvm.getelementptr"(%arg58, %2614) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %2616 = "llvm.load"(%2615) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2617 = "llvm.icmp"(%2616, %2492) <{predicate = 0 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%2617)[^bb36, ^bb35] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb35:  // pred: ^bb34
  "llvm.store"(%2492, %2615) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2618 = "llvm.add"(%2614, %2487) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2619 = "llvm.icmp"(%2618, %2490) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%2619, %2618)[^bb38, ^bb34] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb36:  // pred: ^bb34
  "llvm.store"(%2486, %2615) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.br"()[^bb38] : () -> ()
^bb37:  // pred: ^bb31
  %2620 = "llvm.trunc"(%2609) <{overflowFlags = 0 : i32}> : (i32) -> i8
  "llvm.store"(%2620, %2532) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.store"(%2492, %2602) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.br"()[^bb38] : () -> ()
^bb38:  // 4 preds: ^bb30, ^bb35, ^bb36, ^bb37
  %2621 = "llvm.add"(%2531, %2503) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2622 = "llvm.icmp"(%2538, %2495) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2622)[^bb56, ^bb39] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb39:  // pred: ^bb38
  %2623 = "llvm.getelementptr"(%arg58, %2621) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %2624 = "llvm.load"(%2623) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2625 = "llvm.icmp"(%2624, %2492) <{predicate = 0 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%2625)[^bb47, ^bb40] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb40:  // pred: ^bb39
  %2626 = "llvm.sext"(%2624) : (i8) -> i32
  %2627 = "llvm.shl"(%2626, %2495) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %2628 = "llvm.load"(%2532) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2629 = "llvm.sext"(%2628) : (i8) -> i32
  %2630 = "llvm.add"(%2627, %2629) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %2631 = "llvm.icmp"(%2630, %2498) <{predicate = 2 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2631)[^bb46, ^bb41] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb41:  // pred: ^bb40
  %2632 = "llvm.sub"(%2629, %2627) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %2633 = "llvm.icmp"(%2632, %2499) <{predicate = 2 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2633)[^bb56, ^bb42] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb42:  // pred: ^bb41
  %2634 = "llvm.trunc"(%2632) <{overflowFlags = 0 : i32}> : (i32) -> i8
  "llvm.store"(%2634, %2532) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.br"(%2621)[^bb43] : (i64) -> ()
^bb43(%2635: i64):  // 2 preds: ^bb42, ^bb44
  %2636 = "llvm.getelementptr"(%arg58, %2635) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %2637 = "llvm.load"(%2636) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2638 = "llvm.icmp"(%2637, %2492) <{predicate = 0 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%2638)[^bb45, ^bb44] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb44:  // pred: ^bb43
  "llvm.store"(%2492, %2636) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2639 = "llvm.add"(%2635, %2487) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2640 = "llvm.icmp"(%2639, %2490) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%2640, %2639)[^bb47, ^bb43] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb45:  // pred: ^bb43
  "llvm.store"(%2486, %2636) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.br"()[^bb47] : () -> ()
^bb46:  // pred: ^bb40
  %2641 = "llvm.trunc"(%2630) <{overflowFlags = 0 : i32}> : (i32) -> i8
  "llvm.store"(%2641, %2532) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.store"(%2492, %2623) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.br"()[^bb47] : () -> ()
^bb47:  // 4 preds: ^bb39, ^bb44, ^bb45, ^bb46
  %2642 = "llvm.add"(%2531, %2504) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2643 = "llvm.icmp"(%2538, %2505) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2643)[^bb56, ^bb48] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb48:  // pred: ^bb47
  %2644 = "llvm.getelementptr"(%arg58, %2642) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %2645 = "llvm.load"(%2644) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2646 = "llvm.icmp"(%2645, %2492) <{predicate = 0 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%2646)[^bb56, ^bb49] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb49:  // pred: ^bb48
  %2647 = "llvm.sext"(%2645) : (i8) -> i32
  %2648 = "llvm.shl"(%2647, %2505) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %2649 = "llvm.load"(%2532) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2650 = "llvm.sext"(%2649) : (i8) -> i32
  %2651 = "llvm.add"(%2648, %2650) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %2652 = "llvm.icmp"(%2651, %2498) <{predicate = 2 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2652)[^bb55, ^bb50] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb50:  // pred: ^bb49
  %2653 = "llvm.sub"(%2650, %2648) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %2654 = "llvm.icmp"(%2653, %2499) <{predicate = 2 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2654)[^bb56, ^bb51] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb51:  // pred: ^bb50
  %2655 = "llvm.trunc"(%2653) <{overflowFlags = 0 : i32}> : (i32) -> i8
  "llvm.store"(%2655, %2532) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.br"(%2642)[^bb52] : (i64) -> ()
^bb52(%2656: i64):  // 2 preds: ^bb51, ^bb53
  %2657 = "llvm.getelementptr"(%arg58, %2656) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %2658 = "llvm.load"(%2657) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2659 = "llvm.icmp"(%2658, %2492) <{predicate = 0 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%2659)[^bb54, ^bb53] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb53:  // pred: ^bb52
  "llvm.store"(%2492, %2657) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2660 = "llvm.add"(%2656, %2487) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2661 = "llvm.icmp"(%2660, %2490) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%2661, %2660)[^bb56, ^bb52] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb54:  // pred: ^bb52
  "llvm.store"(%2486, %2657) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.br"()[^bb56] : () -> ()
^bb55:  // pred: ^bb49
  %2662 = "llvm.trunc"(%2651) <{overflowFlags = 0 : i32}> : (i32) -> i8
  "llvm.store"(%2662, %2532) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.store"(%2492, %2644) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.br"()[^bb56] : () -> ()
^bb56:  // 16 preds: ^bb2, ^bb6, ^bb11, ^bb14, ^bb20, ^bb23, ^bb29, ^bb32, ^bb38, ^bb41, ^bb47, ^bb48, ^bb50, ^bb53, ^bb54, ^bb55
  %2663 = "llvm.add"(%2529, %2487) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2664 = "llvm.add"(%2531, %2487) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2665 = "llvm.add"(%2530, %2506) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %2666 = "llvm.icmp"(%2663, %2490) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%2666, %2663, %2665, %2664)[^bb57, ^bb2] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 3>}> : (i1, i64, i32, i64) -> ()
^bb57:  // pred: ^bb56
  "llvm.return"() : () -> ()
}) : () -> ()

end

end MLIR.Sodium
