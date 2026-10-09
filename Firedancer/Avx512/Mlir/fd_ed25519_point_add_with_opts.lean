module

-- build/llvm23/mlir_canonicalized/avx512/op/fd_ed25519_point_add_with_opts.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Avx512.Mlir.fd_r43x6_quad_mul_fast

meta import MLIR.Semantics.Func
meta import Firedancer.Avx512.Mlir.fd_r43x6_quad_mul_fast

namespace MLIR.Firedancer.Avx512

@[expose] public section

mlir_def fd_ed25519_point_add_with_opts :=
#tbaa_root = #llvm.tbaa_root<id = "Simple C/C++ TBAA">
#tbaa_type_desc = #llvm.tbaa_type_desc<id = "omnipotent char", members = {<#tbaa_root, 0>}>
#tbaa_tag = #llvm.tbaa_tag<base_type = #tbaa_type_desc, access_type = #tbaa_type_desc, offset = 0>
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nofree, llvm.noundef, llvm.returned, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.noundef, llvm.range = #llvm.constant_range<i32, 0, 2>}], dso_local, function_type = !llvm.func<ptr (ptr, ptr, ptr, i32)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], res_attrs = [{llvm.noundef}], sym_name = "fd_ed25519_point_add_with_opts", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg118: !llvm.ptr, %arg119: !llvm.ptr, %arg120: !llvm.ptr, %arg121: i32):
  %2462 = "llvm.mlir.constant"() <{value = dense<[0, 0, 0, 15037786634, 0, 0, 0, 309467527341]> : vector<8xi64>}> : () -> vector<8xi64>
  %2463 = "llvm.mlir.constant"() <{value = dense<[0, 0, 0, 507525298899, 0, 0, 0, 6596238350568]> : vector<8xi64>}> : () -> vector<8xi64>
  %2464 = "llvm.mlir.constant"() <{value = dense<[1, 1, 1, 3934839304537, 0, 0, 0, 521695520920]> : vector<8xi64>}> : () -> vector<8xi64>
  %2465 = "llvm.mlir.constant"() <{value = dense<[8796093022207, 8796093022207, 8796093022207, 8796093022207, 1099511627775, 1099511627775, 1099511627775, 1099511627775]> : vector<8xi64>}> : () -> vector<8xi64>
  %2466 = "llvm.mlir.constant"() <{value = dense<1048576> : vector<8xi64>}> : () -> vector<8xi64>
  %2467 = "llvm.mlir.constant"() <{value = dense<[159383552, 159383552, 159383552, 159383552, 1048576, 1048576, 1048576, 1048576]> : vector<8xi64>}> : () -> vector<8xi64>
  %2468 = "llvm.mlir.constant"() <{value = dense<8796093022207> : vector<8xi64>}> : () -> vector<8xi64>
  %2469 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %2470 = "llvm.mlir.constant"() <{value = dense<[43, 43, 43, 43, 40, 40, 40, 40]> : vector<8xi64>}> : () -> vector<8xi64>
  %2471 = "llvm.mlir.constant"() <{value = dense<43> : vector<8xi64>}> : () -> vector<8xi64>
  %2472 = "llvm.mlir.constant"() <{value = dense<-1048576> : vector<8xi64>}> : () -> vector<8xi64>
  %2473 = "llvm.mlir.constant"() <{value = dense<[-159383552, -159383552, -159383552, -159383552, -1048576, -1048576, -1048576, -1048576]> : vector<8xi64>}> : () -> vector<8xi64>
  %2474 = "llvm.mlir.constant"() <{value = 1099511627775 : i64}> : () -> i64
  %2475 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %2476 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %2477 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %2478 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %2479 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %2480 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %2481 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %2482 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %2483 = "llvm.mlir.poison"() : () -> vector<8xi64>
  %2484 = "llvm.mlir.poison"() : () -> i64
  %2485 = "llvm.mlir.constant"() <{value = 8796093022207 : i64}> : () -> i64
  %2486 = "llvm.mlir.constant"() <{value = 8796093022189 : i64}> : () -> i64
  %2487 = "llvm.mlir.undef"() : () -> vector<8xi64>
  %2488 = "llvm.insertelement"(%2487, %2486, %2482) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2489 = "llvm.insertelement"(%2488, %2484, %2481) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2490 = "llvm.insertelement"(%2489, %2484, %2480) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2491 = "llvm.insertelement"(%2490, %2484, %2479) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2492 = "llvm.insertelement"(%2491, %2485, %2478) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2493 = "llvm.insertelement"(%2492, %2484, %2477) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2494 = "llvm.insertelement"(%2493, %2484, %2476) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2495 = "llvm.insertelement"(%2494, %2484, %2475) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2496 = "llvm.insertelement"(%2487, %2485, %2482) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2497 = "llvm.insertelement"(%2496, %2484, %2481) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2498 = "llvm.insertelement"(%2497, %2484, %2480) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2499 = "llvm.insertelement"(%2498, %2484, %2479) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2500 = "llvm.insertelement"(%2499, %2485, %2478) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2501 = "llvm.insertelement"(%2500, %2484, %2477) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2502 = "llvm.insertelement"(%2501, %2484, %2476) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2503 = "llvm.insertelement"(%2502, %2484, %2475) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2504 = "llvm.insertelement"(%2487, %2485, %2482) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2505 = "llvm.insertelement"(%2504, %2484, %2481) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2506 = "llvm.insertelement"(%2505, %2484, %2480) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2507 = "llvm.insertelement"(%2506, %2484, %2479) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2508 = "llvm.insertelement"(%2507, %2474, %2478) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2509 = "llvm.insertelement"(%2508, %2484, %2477) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2510 = "llvm.insertelement"(%2509, %2484, %2476) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2511 = "llvm.insertelement"(%2510, %2484, %2475) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2512 = "llvm.insertelement"(%2487, %2484, %2482) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2513 = "llvm.insertelement"(%2512, %2484, %2481) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2514 = "llvm.insertelement"(%2513, %2484, %2480) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2515 = "llvm.insertelement"(%2514, %2484, %2479) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2516 = "llvm.insertelement"(%2515, %2469, %2478) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2517 = "llvm.insertelement"(%2516, %2469, %2477) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2518 = "llvm.insertelement"(%2517, %2469, %2476) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2519 = "llvm.insertelement"(%2518, %2469, %2475) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2520 = "llvm.insertelement"(%2487, %2486, %2482) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2521 = "llvm.insertelement"(%2520, %2484, %2481) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2522 = "llvm.insertelement"(%2521, %2484, %2480) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2523 = "llvm.insertelement"(%2522, %2486, %2479) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2524 = "llvm.insertelement"(%2523, %2485, %2478) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2525 = "llvm.insertelement"(%2524, %2484, %2477) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2526 = "llvm.insertelement"(%2525, %2484, %2476) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2527 = "llvm.insertelement"(%2526, %2485, %2475) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2528 = "llvm.insertelement"(%2487, %2485, %2482) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2529 = "llvm.insertelement"(%2528, %2484, %2481) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2530 = "llvm.insertelement"(%2529, %2484, %2480) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2531 = "llvm.insertelement"(%2530, %2485, %2479) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2532 = "llvm.insertelement"(%2531, %2485, %2478) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2533 = "llvm.insertelement"(%2532, %2484, %2477) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2534 = "llvm.insertelement"(%2533, %2484, %2476) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2535 = "llvm.insertelement"(%2534, %2485, %2475) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2536 = "llvm.insertelement"(%2487, %2485, %2482) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2537 = "llvm.insertelement"(%2536, %2484, %2481) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2538 = "llvm.insertelement"(%2537, %2484, %2480) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2539 = "llvm.insertelement"(%2538, %2485, %2479) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2540 = "llvm.insertelement"(%2539, %2474, %2478) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2541 = "llvm.insertelement"(%2540, %2484, %2477) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2542 = "llvm.insertelement"(%2541, %2484, %2476) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2543 = "llvm.insertelement"(%2542, %2474, %2475) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2544 = "llvm.alloca"(%2481) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %2545 = "llvm.alloca"(%2481) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %2546 = "llvm.alloca"(%2481) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %2547 = "llvm.alloca"(%2481) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %2548 = "llvm.alloca"(%2481) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %2549 = "llvm.alloca"(%2481) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %2550 = "llvm.alloca"(%2481) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %2551 = "llvm.alloca"(%2481) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %2552 = "llvm.alloca"(%2481) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %2553 = "llvm.alloca"(%2481) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %2554 = "llvm.alloca"(%2481) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %2555 = "llvm.alloca"(%2481) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %2556 = "llvm.alloca"(%2481) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %2557 = "llvm.alloca"(%2481) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %2558 = "llvm.alloca"(%2481) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %2559 = "llvm.icmp"(%arg121, %2482) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2559)[^bb2, ^bb1] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb1:  // pred: ^bb0
  %2560 = "llvm.load"(%arg120) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2561 = "llvm.getelementptr"(%arg120) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %2562 = "llvm.load"(%2561) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2563 = "llvm.getelementptr"(%arg120) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %2564 = "llvm.load"(%2563) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2565 = "llvm.load"(%arg119) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2566 = "llvm.shufflevector"(%2565, %2483) <{mask = array<i32: 1, -1, -1, -1, 5, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2567 = "llvm.getelementptr"(%arg119) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %2568 = "llvm.load"(%2567) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2569 = "llvm.shufflevector"(%2568, %2483) <{mask = array<i32: 1, -1, -1, -1, 5, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2570 = "llvm.getelementptr"(%arg119) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %2571 = "llvm.load"(%2570) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2572 = "llvm.shufflevector"(%2571, %2483) <{mask = array<i32: 1, -1, -1, -1, 5, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2573 = "llvm.sub"(%2566, %2565) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2574 = "llvm.add"(%2573, %2495) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2575 = "llvm.shufflevector"(%2574, %2565) <{mask = array<i32: 0, 8, 10, 11, 4, 12, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2576 = "llvm.sub"(%2569, %2568) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2577 = "llvm.add"(%2576, %2503) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2578 = "llvm.shufflevector"(%2577, %2568) <{mask = array<i32: 0, 8, 10, 11, 4, 12, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2579 = "llvm.sub"(%2572, %2571) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2580 = "llvm.add"(%2579, %2511) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2581 = "llvm.shufflevector"(%2580, %2571) <{mask = array<i32: 0, 8, 10, 11, 4, 12, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2582 = "llvm.add"(%2575, %2565) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2583 = "llvm.shufflevector"(%2575, %2582) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2584 = "llvm.add"(%2578, %2568) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2585 = "llvm.shufflevector"(%2578, %2584) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2586 = "llvm.add"(%2581, %2571) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2587 = "llvm.shufflevector"(%2581, %2586) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2588 = "llvm.add"(%2583, %2473) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2589 = "llvm.add"(%2585, %2472) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2590 = "llvm.add"(%2587, %2472) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2591 = "llvm.ashr"(%2588, %2471) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2592 = "llvm.ashr"(%2589, %2471) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2593 = "llvm.ashr"(%2590, %2470) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2594 = "llvm.mul"(%2593, %2519) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2595 = "llvm.and"(%2588, %2468) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2596 = "llvm.shufflevector"(%2594, %2593) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2597 = "llvm.add"(%2595, %2467) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2598 = "llvm.add"(%2597, %2596) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2599 = "llvm.and"(%2589, %2468) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2600 = "llvm.add"(%2591, %2466) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2601 = "llvm.add"(%2600, %2599) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2602 = "llvm.and"(%2590, %2465) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2603 = "llvm.add"(%2592, %2466) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2604 = "llvm.add"(%2603, %2602) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.intr.lifetime.start"(%2544) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2545) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2546) : (!llvm.ptr) -> ()
  "llvm.call"(%2544, %2545, %2546, %2560, %2562, %2564, %2598, %2601, %2604) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_quad_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 9, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
  %2605 = "llvm.load"(%2544) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2606 = "llvm.load"(%2545) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2607 = "llvm.load"(%2546) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.intr.lifetime.end"(%2546) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2545) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2544) : (!llvm.ptr) -> ()
  %2608 = "llvm.lshr"(%2605, %2471) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2609 = "llvm.lshr"(%2606, %2471) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2610 = "llvm.lshr"(%2607, %2470) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2611 = "llvm.mul"(%2610, %2519) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2612 = "llvm.and"(%2605, %2468) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2613 = "llvm.shufflevector"(%2611, %2610) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2614 = "llvm.add"(%2613, %2612) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2615 = "llvm.and"(%2606, %2468) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2616 = "llvm.add"(%2615, %2608) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2617 = "llvm.and"(%2607, %2465) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2618 = "llvm.add"(%2617, %2609) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2619 = "llvm.shufflevector"(%2614, %2483) <{mask = array<i32: 1, -1, -1, 2, 5, -1, -1, 6>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2620 = "llvm.shufflevector"(%2616, %2483) <{mask = array<i32: 1, -1, -1, 2, 5, -1, -1, 6>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2621 = "llvm.shufflevector"(%2618, %2483) <{mask = array<i32: 1, -1, -1, 2, 5, -1, -1, 6>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2622 = "llvm.sub"(%2619, %2614) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2623 = "llvm.add"(%2622, %2527) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2624 = "llvm.shufflevector"(%2614, %2483) <{mask = array<i32: -1, 0, 3, -1, -1, 4, 7, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2625 = "llvm.sub"(%2620, %2616) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2626 = "llvm.add"(%2625, %2535) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2627 = "llvm.shufflevector"(%2616, %2483) <{mask = array<i32: -1, 0, 3, -1, -1, 4, 7, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2628 = "llvm.sub"(%2621, %2618) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2629 = "llvm.add"(%2628, %2543) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2630 = "llvm.shufflevector"(%2618, %2483) <{mask = array<i32: -1, 0, 3, -1, -1, 4, 7, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2631 = "llvm.add"(%2624, %2614) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2632 = "llvm.shufflevector"(%2623, %2631) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2633 = "llvm.add"(%2627, %2616) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2634 = "llvm.shufflevector"(%2626, %2633) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2635 = "llvm.add"(%2630, %2618) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2636 = "llvm.shufflevector"(%2629, %2635) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2637 = "llvm.add"(%2632, %2473) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2638 = "llvm.add"(%2634, %2472) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2639 = "llvm.add"(%2636, %2472) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2640 = "llvm.ashr"(%2637, %2471) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2641 = "llvm.ashr"(%2638, %2471) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2642 = "llvm.ashr"(%2639, %2470) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2643 = "llvm.mul"(%2642, %2519) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2644 = "llvm.and"(%2637, %2468) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2645 = "llvm.shufflevector"(%2643, %2642) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2646 = "llvm.add"(%2645, %2467) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2647 = "llvm.add"(%2646, %2644) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2648 = "llvm.and"(%2638, %2468) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2649 = "llvm.add"(%2648, %2466) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2650 = "llvm.add"(%2649, %2640) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2651 = "llvm.and"(%2639, %2465) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2652 = "llvm.add"(%2641, %2466) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2653 = "llvm.add"(%2652, %2651) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2654 = "llvm.shufflevector"(%2647, %2483) <{mask = array<i32: 0, 2, 2, 0, 4, 6, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2655 = "llvm.shufflevector"(%2650, %2483) <{mask = array<i32: 0, 2, 2, 0, 4, 6, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2656 = "llvm.shufflevector"(%2653, %2483) <{mask = array<i32: 0, 2, 2, 0, 4, 6, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2657 = "llvm.shufflevector"(%2647, %2483) <{mask = array<i32: 3, 1, 3, 1, 7, 5, 7, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2658 = "llvm.shufflevector"(%2650, %2483) <{mask = array<i32: 3, 1, 3, 1, 7, 5, 7, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2659 = "llvm.shufflevector"(%2653, %2483) <{mask = array<i32: 3, 1, 3, 1, 7, 5, 7, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.intr.lifetime.start"(%2547) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2548) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2549) : (!llvm.ptr) -> ()
  "llvm.call"(%2547, %2548, %2549, %2654, %2655, %2656, %2657, %2658, %2659) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_quad_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 9, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
  %2660 = "llvm.load"(%2547) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2661 = "llvm.load"(%2548) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2662 = "llvm.load"(%2549) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.intr.lifetime.end"(%2549) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2548) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2547) : (!llvm.ptr) -> ()
  "llvm.br"(%2660, %2661, %2662)[^bb3] : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
^bb2:  // pred: ^bb0
  %2663 = "llvm.load"(%arg119) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2664 = "llvm.shufflevector"(%2663, %2483) <{mask = array<i32: 1, -1, -1, -1, 5, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2665 = "llvm.getelementptr"(%arg119) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %2666 = "llvm.load"(%2665) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2667 = "llvm.shufflevector"(%2666, %2483) <{mask = array<i32: 1, -1, -1, -1, 5, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2668 = "llvm.getelementptr"(%arg119) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %2669 = "llvm.load"(%2668) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2670 = "llvm.shufflevector"(%2669, %2483) <{mask = array<i32: 1, -1, -1, -1, 5, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2671 = "llvm.load"(%arg120) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2672 = "llvm.shufflevector"(%2671, %2483) <{mask = array<i32: 1, -1, -1, -1, 5, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2673 = "llvm.getelementptr"(%arg120) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %2674 = "llvm.load"(%2673) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2675 = "llvm.shufflevector"(%2674, %2483) <{mask = array<i32: 1, -1, -1, -1, 5, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2676 = "llvm.getelementptr"(%arg120) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %2677 = "llvm.load"(%2676) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2678 = "llvm.shufflevector"(%2677, %2483) <{mask = array<i32: 1, -1, -1, -1, 5, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2679 = "llvm.sub"(%2664, %2663) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2680 = "llvm.add"(%2679, %2495) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2681 = "llvm.shufflevector"(%2680, %2663) <{mask = array<i32: 0, 8, 10, 11, 4, 12, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2682 = "llvm.sub"(%2667, %2666) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2683 = "llvm.add"(%2682, %2503) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2684 = "llvm.shufflevector"(%2683, %2666) <{mask = array<i32: 0, 8, 10, 11, 4, 12, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2685 = "llvm.sub"(%2670, %2669) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2686 = "llvm.add"(%2685, %2511) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2687 = "llvm.shufflevector"(%2686, %2669) <{mask = array<i32: 0, 8, 10, 11, 4, 12, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2688 = "llvm.sub"(%2672, %2671) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2689 = "llvm.add"(%2688, %2495) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2690 = "llvm.shufflevector"(%2689, %2671) <{mask = array<i32: 0, 8, 10, 11, 4, 12, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2691 = "llvm.sub"(%2675, %2674) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2692 = "llvm.add"(%2691, %2503) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2693 = "llvm.shufflevector"(%2692, %2674) <{mask = array<i32: 0, 8, 10, 11, 4, 12, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2694 = "llvm.sub"(%2678, %2677) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2695 = "llvm.add"(%2694, %2511) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2696 = "llvm.shufflevector"(%2695, %2677) <{mask = array<i32: 0, 8, 10, 11, 4, 12, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2697 = "llvm.add"(%2681, %2663) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2698 = "llvm.shufflevector"(%2681, %2697) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2699 = "llvm.add"(%2684, %2666) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2700 = "llvm.shufflevector"(%2684, %2699) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2701 = "llvm.add"(%2687, %2669) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2702 = "llvm.shufflevector"(%2687, %2701) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2703 = "llvm.add"(%2690, %2671) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2704 = "llvm.shufflevector"(%2690, %2703) <{mask = array<i32: 0, 9, 2, 3, 4, 13, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2705 = "llvm.add"(%2693, %2674) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2706 = "llvm.shufflevector"(%2693, %2705) <{mask = array<i32: 0, 9, 2, 3, 4, 13, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2707 = "llvm.add"(%2696, %2677) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2708 = "llvm.shufflevector"(%2696, %2707) <{mask = array<i32: 0, 9, 2, 3, 4, 13, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2709 = "llvm.add"(%2698, %2473) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2710 = "llvm.add"(%2700, %2472) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2711 = "llvm.add"(%2702, %2472) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2712 = "llvm.ashr"(%2709, %2471) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2713 = "llvm.ashr"(%2710, %2471) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2714 = "llvm.ashr"(%2711, %2470) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2715 = "llvm.mul"(%2714, %2519) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2716 = "llvm.and"(%2709, %2468) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2717 = "llvm.shufflevector"(%2715, %2714) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2718 = "llvm.add"(%2716, %2467) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2719 = "llvm.add"(%2718, %2717) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2720 = "llvm.and"(%2710, %2468) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2721 = "llvm.add"(%2712, %2466) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2722 = "llvm.add"(%2721, %2720) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2723 = "llvm.and"(%2711, %2465) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2724 = "llvm.add"(%2713, %2466) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2725 = "llvm.add"(%2724, %2723) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2726 = "llvm.add"(%2704, %2473) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2727 = "llvm.add"(%2706, %2472) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2728 = "llvm.add"(%2708, %2472) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2729 = "llvm.ashr"(%2726, %2471) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2730 = "llvm.ashr"(%2727, %2471) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2731 = "llvm.ashr"(%2728, %2470) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2732 = "llvm.mul"(%2731, %2519) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2733 = "llvm.and"(%2726, %2468) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2734 = "llvm.shufflevector"(%2732, %2731) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2735 = "llvm.add"(%2733, %2467) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2736 = "llvm.add"(%2735, %2734) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2737 = "llvm.and"(%2727, %2468) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2738 = "llvm.add"(%2729, %2466) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2739 = "llvm.add"(%2738, %2737) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2740 = "llvm.and"(%2728, %2465) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2741 = "llvm.add"(%2730, %2466) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2742 = "llvm.add"(%2741, %2740) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.intr.lifetime.start"(%2550) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2551) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2552) : (!llvm.ptr) -> ()
  "llvm.call"(%2550, %2551, %2552, %2719, %2722, %2725, %2464, %2463, %2462) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_quad_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 9, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
  %2743 = "llvm.load"(%2550) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2744 = "llvm.load"(%2551) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2745 = "llvm.load"(%2552) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.intr.lifetime.end"(%2552) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2551) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2550) : (!llvm.ptr) -> ()
  %2746 = "llvm.lshr"(%2743, %2471) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2747 = "llvm.lshr"(%2744, %2471) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2748 = "llvm.lshr"(%2745, %2470) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2749 = "llvm.mul"(%2748, %2519) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2750 = "llvm.and"(%2743, %2468) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2751 = "llvm.shufflevector"(%2749, %2748) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2752 = "llvm.add"(%2751, %2750) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2753 = "llvm.and"(%2744, %2468) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2754 = "llvm.add"(%2753, %2746) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2755 = "llvm.and"(%2745, %2465) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2756 = "llvm.add"(%2755, %2747) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.intr.lifetime.start"(%2553) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2554) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2555) : (!llvm.ptr) -> ()
  "llvm.call"(%2553, %2554, %2555, %2752, %2754, %2756, %2736, %2739, %2742) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_quad_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 9, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
  %2757 = "llvm.load"(%2553) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2758 = "llvm.load"(%2554) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2759 = "llvm.load"(%2555) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.intr.lifetime.end"(%2555) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2554) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2553) : (!llvm.ptr) -> ()
  %2760 = "llvm.shufflevector"(%2757, %2483) <{mask = array<i32: 1, -1, -1, 2, 5, -1, -1, 6>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2761 = "llvm.shufflevector"(%2758, %2483) <{mask = array<i32: 1, -1, -1, 2, 5, -1, -1, 6>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2762 = "llvm.shufflevector"(%2759, %2483) <{mask = array<i32: 1, -1, -1, 2, 5, -1, -1, 6>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2763 = "llvm.sub"(%2760, %2757) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2764 = "llvm.add"(%2763, %2527) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2765 = "llvm.shufflevector"(%2757, %2483) <{mask = array<i32: -1, 0, 3, -1, -1, 4, 7, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2766 = "llvm.sub"(%2761, %2758) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2767 = "llvm.add"(%2766, %2535) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2768 = "llvm.shufflevector"(%2758, %2483) <{mask = array<i32: -1, 0, 3, -1, -1, 4, 7, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2769 = "llvm.sub"(%2762, %2759) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2770 = "llvm.add"(%2769, %2543) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2771 = "llvm.shufflevector"(%2759, %2483) <{mask = array<i32: -1, 0, 3, -1, -1, 4, 7, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2772 = "llvm.add"(%2765, %2757) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2773 = "llvm.shufflevector"(%2764, %2772) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2774 = "llvm.add"(%2768, %2758) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2775 = "llvm.shufflevector"(%2767, %2774) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2776 = "llvm.add"(%2771, %2759) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2777 = "llvm.shufflevector"(%2770, %2776) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2778 = "llvm.add"(%2773, %2473) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2779 = "llvm.add"(%2775, %2472) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2780 = "llvm.add"(%2777, %2472) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2781 = "llvm.ashr"(%2778, %2471) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2782 = "llvm.ashr"(%2779, %2471) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2783 = "llvm.ashr"(%2780, %2470) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2784 = "llvm.mul"(%2783, %2519) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2785 = "llvm.and"(%2778, %2468) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2786 = "llvm.shufflevector"(%2784, %2783) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2787 = "llvm.add"(%2785, %2467) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2788 = "llvm.add"(%2787, %2786) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2789 = "llvm.and"(%2779, %2468) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2790 = "llvm.add"(%2781, %2466) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2791 = "llvm.add"(%2790, %2789) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2792 = "llvm.and"(%2780, %2465) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2793 = "llvm.add"(%2782, %2466) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2794 = "llvm.add"(%2793, %2792) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2795 = "llvm.shufflevector"(%2788, %2483) <{mask = array<i32: 0, 2, 2, 0, 4, 6, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2796 = "llvm.shufflevector"(%2791, %2483) <{mask = array<i32: 0, 2, 2, 0, 4, 6, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2797 = "llvm.shufflevector"(%2794, %2483) <{mask = array<i32: 0, 2, 2, 0, 4, 6, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2798 = "llvm.shufflevector"(%2788, %2483) <{mask = array<i32: 3, 1, 3, 1, 7, 5, 7, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2799 = "llvm.shufflevector"(%2791, %2483) <{mask = array<i32: 3, 1, 3, 1, 7, 5, 7, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2800 = "llvm.shufflevector"(%2794, %2483) <{mask = array<i32: 3, 1, 3, 1, 7, 5, 7, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.intr.lifetime.start"(%2556) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2557) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2558) : (!llvm.ptr) -> ()
  "llvm.call"(%2556, %2557, %2558, %2795, %2796, %2797, %2798, %2799, %2800) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_quad_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 9, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
  %2801 = "llvm.load"(%2556) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2802 = "llvm.load"(%2557) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2803 = "llvm.load"(%2558) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.intr.lifetime.end"(%2558) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2557) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2556) : (!llvm.ptr) -> ()
  "llvm.br"(%2801, %2802, %2803)[^bb3] : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
^bb3(%2804: vector<8xi64>, %2805: vector<8xi64>, %2806: vector<8xi64>):  // 2 preds: ^bb1, ^bb2
  %2807 = "llvm.lshr"(%2804, %2471) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2808 = "llvm.lshr"(%2805, %2471) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2809 = "llvm.lshr"(%2806, %2470) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2810 = "llvm.mul"(%2809, %2519) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2811 = "llvm.and"(%2804, %2468) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2812 = "llvm.shufflevector"(%2810, %2809) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2813 = "llvm.add"(%2812, %2811) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%2813, %arg118) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2814 = "llvm.and"(%2805, %2468) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2815 = "llvm.add"(%2814, %2807) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2816 = "llvm.getelementptr"(%arg118) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2815, %2816) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2817 = "llvm.and"(%2806, %2465) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2818 = "llvm.add"(%2817, %2808) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2819 = "llvm.getelementptr"(%arg118) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2818, %2819) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.return"(%arg118) : (!llvm.ptr) -> ()
}) : () -> ()
  with @fd_r43x6_quad_mul_fast := fd_r43x6_quad_mul_fast

end

end MLIR.Firedancer.Avx512
