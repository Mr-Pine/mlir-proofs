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
^bb0(%arg116: !llvm.ptr, %arg117: !llvm.ptr, %arg118: !llvm.ptr, %arg119: i32):
  %2452 = "llvm.mlir.constant"() <{value = dense<[0, 0, 0, 15037786634, 0, 0, 0, 309467527341]> : vector<8xi64>}> : () -> vector<8xi64>
  %2453 = "llvm.mlir.constant"() <{value = dense<[0, 0, 0, 507525298899, 0, 0, 0, 6596238350568]> : vector<8xi64>}> : () -> vector<8xi64>
  %2454 = "llvm.mlir.constant"() <{value = dense<[1, 1, 1, 3934839304537, 0, 0, 0, 521695520920]> : vector<8xi64>}> : () -> vector<8xi64>
  %2455 = "llvm.mlir.constant"() <{value = dense<[8796093022207, 8796093022207, 8796093022207, 8796093022207, 1099511627775, 1099511627775, 1099511627775, 1099511627775]> : vector<8xi64>}> : () -> vector<8xi64>
  %2456 = "llvm.mlir.constant"() <{value = dense<1048576> : vector<8xi64>}> : () -> vector<8xi64>
  %2457 = "llvm.mlir.constant"() <{value = dense<[159383552, 159383552, 159383552, 159383552, 1048576, 1048576, 1048576, 1048576]> : vector<8xi64>}> : () -> vector<8xi64>
  %2458 = "llvm.mlir.constant"() <{value = dense<8796093022207> : vector<8xi64>}> : () -> vector<8xi64>
  %2459 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %2460 = "llvm.mlir.constant"() <{value = dense<[43, 43, 43, 43, 40, 40, 40, 40]> : vector<8xi64>}> : () -> vector<8xi64>
  %2461 = "llvm.mlir.constant"() <{value = dense<43> : vector<8xi64>}> : () -> vector<8xi64>
  %2462 = "llvm.mlir.constant"() <{value = dense<-1048576> : vector<8xi64>}> : () -> vector<8xi64>
  %2463 = "llvm.mlir.constant"() <{value = dense<[-159383552, -159383552, -159383552, -159383552, -1048576, -1048576, -1048576, -1048576]> : vector<8xi64>}> : () -> vector<8xi64>
  %2464 = "llvm.mlir.constant"() <{value = 1099511627775 : i64}> : () -> i64
  %2465 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %2466 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %2467 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %2468 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %2469 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %2470 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %2471 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %2472 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %2473 = "llvm.mlir.poison"() : () -> vector<8xi64>
  %2474 = "llvm.mlir.poison"() : () -> i64
  %2475 = "llvm.mlir.constant"() <{value = 8796093022207 : i64}> : () -> i64
  %2476 = "llvm.mlir.constant"() <{value = 8796093022189 : i64}> : () -> i64
  %2477 = "llvm.mlir.undef"() : () -> vector<8xi64>
  %2478 = "llvm.insertelement"(%2477, %2476, %2472) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2479 = "llvm.insertelement"(%2478, %2474, %2471) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2480 = "llvm.insertelement"(%2479, %2474, %2470) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2481 = "llvm.insertelement"(%2480, %2474, %2469) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2482 = "llvm.insertelement"(%2481, %2475, %2468) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2483 = "llvm.insertelement"(%2482, %2474, %2467) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2484 = "llvm.insertelement"(%2483, %2474, %2466) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2485 = "llvm.insertelement"(%2484, %2474, %2465) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2486 = "llvm.insertelement"(%2477, %2475, %2472) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2487 = "llvm.insertelement"(%2486, %2474, %2471) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2488 = "llvm.insertelement"(%2487, %2474, %2470) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2489 = "llvm.insertelement"(%2488, %2474, %2469) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2490 = "llvm.insertelement"(%2489, %2475, %2468) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2491 = "llvm.insertelement"(%2490, %2474, %2467) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2492 = "llvm.insertelement"(%2491, %2474, %2466) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2493 = "llvm.insertelement"(%2492, %2474, %2465) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2494 = "llvm.insertelement"(%2477, %2475, %2472) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2495 = "llvm.insertelement"(%2494, %2474, %2471) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2496 = "llvm.insertelement"(%2495, %2474, %2470) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2497 = "llvm.insertelement"(%2496, %2474, %2469) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2498 = "llvm.insertelement"(%2497, %2464, %2468) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2499 = "llvm.insertelement"(%2498, %2474, %2467) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2500 = "llvm.insertelement"(%2499, %2474, %2466) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2501 = "llvm.insertelement"(%2500, %2474, %2465) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2502 = "llvm.insertelement"(%2477, %2474, %2472) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2503 = "llvm.insertelement"(%2502, %2474, %2471) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2504 = "llvm.insertelement"(%2503, %2474, %2470) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2505 = "llvm.insertelement"(%2504, %2474, %2469) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2506 = "llvm.insertelement"(%2505, %2459, %2468) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2507 = "llvm.insertelement"(%2506, %2459, %2467) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2508 = "llvm.insertelement"(%2507, %2459, %2466) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2509 = "llvm.insertelement"(%2508, %2459, %2465) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2510 = "llvm.insertelement"(%2477, %2476, %2472) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2511 = "llvm.insertelement"(%2510, %2474, %2471) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2512 = "llvm.insertelement"(%2511, %2474, %2470) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2513 = "llvm.insertelement"(%2512, %2476, %2469) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2514 = "llvm.insertelement"(%2513, %2475, %2468) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2515 = "llvm.insertelement"(%2514, %2474, %2467) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2516 = "llvm.insertelement"(%2515, %2474, %2466) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2517 = "llvm.insertelement"(%2516, %2475, %2465) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2518 = "llvm.insertelement"(%2477, %2475, %2472) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2519 = "llvm.insertelement"(%2518, %2474, %2471) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2520 = "llvm.insertelement"(%2519, %2474, %2470) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2521 = "llvm.insertelement"(%2520, %2475, %2469) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2522 = "llvm.insertelement"(%2521, %2475, %2468) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2523 = "llvm.insertelement"(%2522, %2474, %2467) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2524 = "llvm.insertelement"(%2523, %2474, %2466) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2525 = "llvm.insertelement"(%2524, %2475, %2465) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2526 = "llvm.insertelement"(%2477, %2475, %2472) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2527 = "llvm.insertelement"(%2526, %2474, %2471) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2528 = "llvm.insertelement"(%2527, %2474, %2470) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2529 = "llvm.insertelement"(%2528, %2475, %2469) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2530 = "llvm.insertelement"(%2529, %2464, %2468) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2531 = "llvm.insertelement"(%2530, %2474, %2467) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2532 = "llvm.insertelement"(%2531, %2474, %2466) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2533 = "llvm.insertelement"(%2532, %2464, %2465) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2534 = "llvm.alloca"(%2471) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %2535 = "llvm.alloca"(%2471) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %2536 = "llvm.alloca"(%2471) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %2537 = "llvm.alloca"(%2471) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %2538 = "llvm.alloca"(%2471) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %2539 = "llvm.alloca"(%2471) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %2540 = "llvm.alloca"(%2471) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %2541 = "llvm.alloca"(%2471) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %2542 = "llvm.alloca"(%2471) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %2543 = "llvm.alloca"(%2471) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %2544 = "llvm.alloca"(%2471) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %2545 = "llvm.alloca"(%2471) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %2546 = "llvm.alloca"(%2471) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %2547 = "llvm.alloca"(%2471) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %2548 = "llvm.alloca"(%2471) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %2549 = "llvm.icmp"(%arg119, %2472) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2549)[^bb2, ^bb1] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb1:  // pred: ^bb0
  %2550 = "llvm.load"(%arg118) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2551 = "llvm.getelementptr"(%arg118) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %2552 = "llvm.load"(%2551) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2553 = "llvm.getelementptr"(%arg118) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %2554 = "llvm.load"(%2553) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2555 = "llvm.load"(%arg117) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2556 = "llvm.shufflevector"(%2555, %2473) <{mask = array<i32: 1, -1, -1, -1, 5, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2557 = "llvm.getelementptr"(%arg117) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %2558 = "llvm.load"(%2557) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2559 = "llvm.shufflevector"(%2558, %2473) <{mask = array<i32: 1, -1, -1, -1, 5, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2560 = "llvm.getelementptr"(%arg117) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %2561 = "llvm.load"(%2560) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2562 = "llvm.shufflevector"(%2561, %2473) <{mask = array<i32: 1, -1, -1, -1, 5, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2563 = "llvm.sub"(%2556, %2555) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2564 = "llvm.add"(%2563, %2485) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2565 = "llvm.shufflevector"(%2564, %2555) <{mask = array<i32: 0, 8, 10, 11, 4, 12, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2566 = "llvm.sub"(%2559, %2558) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2567 = "llvm.add"(%2566, %2493) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2568 = "llvm.shufflevector"(%2567, %2558) <{mask = array<i32: 0, 8, 10, 11, 4, 12, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2569 = "llvm.sub"(%2562, %2561) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2570 = "llvm.add"(%2569, %2501) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2571 = "llvm.shufflevector"(%2570, %2561) <{mask = array<i32: 0, 8, 10, 11, 4, 12, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2572 = "llvm.add"(%2565, %2555) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2573 = "llvm.shufflevector"(%2565, %2572) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2574 = "llvm.add"(%2568, %2558) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2575 = "llvm.shufflevector"(%2568, %2574) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2576 = "llvm.add"(%2571, %2561) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2577 = "llvm.shufflevector"(%2571, %2576) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2578 = "llvm.add"(%2573, %2463) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2579 = "llvm.add"(%2575, %2462) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2580 = "llvm.add"(%2577, %2462) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2581 = "llvm.ashr"(%2578, %2461) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2582 = "llvm.ashr"(%2579, %2461) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2583 = "llvm.ashr"(%2580, %2460) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2584 = "llvm.mul"(%2583, %2509) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2585 = "llvm.and"(%2578, %2458) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2586 = "llvm.shufflevector"(%2584, %2583) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2587 = "llvm.add"(%2585, %2457) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2588 = "llvm.add"(%2587, %2586) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2589 = "llvm.and"(%2579, %2458) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2590 = "llvm.add"(%2581, %2456) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2591 = "llvm.add"(%2590, %2589) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2592 = "llvm.and"(%2580, %2455) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2593 = "llvm.add"(%2582, %2456) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2594 = "llvm.add"(%2593, %2592) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.intr.lifetime.start"(%2534) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2535) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2536) : (!llvm.ptr) -> ()
  "llvm.call"(%2534, %2535, %2536, %2550, %2552, %2554, %2588, %2591, %2594) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_quad_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 9, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
  %2595 = "llvm.load"(%2534) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2596 = "llvm.load"(%2535) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2597 = "llvm.load"(%2536) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.intr.lifetime.end"(%2536) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2535) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2534) : (!llvm.ptr) -> ()
  %2598 = "llvm.lshr"(%2595, %2461) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2599 = "llvm.lshr"(%2596, %2461) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2600 = "llvm.lshr"(%2597, %2460) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2601 = "llvm.mul"(%2600, %2509) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2602 = "llvm.and"(%2595, %2458) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2603 = "llvm.shufflevector"(%2601, %2600) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2604 = "llvm.add"(%2603, %2602) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2605 = "llvm.and"(%2596, %2458) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2606 = "llvm.add"(%2605, %2598) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2607 = "llvm.and"(%2597, %2455) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2608 = "llvm.add"(%2607, %2599) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2609 = "llvm.shufflevector"(%2604, %2473) <{mask = array<i32: 1, -1, -1, 2, 5, -1, -1, 6>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2610 = "llvm.shufflevector"(%2606, %2473) <{mask = array<i32: 1, -1, -1, 2, 5, -1, -1, 6>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2611 = "llvm.shufflevector"(%2608, %2473) <{mask = array<i32: 1, -1, -1, 2, 5, -1, -1, 6>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2612 = "llvm.sub"(%2609, %2604) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2613 = "llvm.add"(%2612, %2517) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2614 = "llvm.shufflevector"(%2604, %2473) <{mask = array<i32: -1, 0, 3, -1, -1, 4, 7, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2615 = "llvm.sub"(%2610, %2606) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2616 = "llvm.add"(%2615, %2525) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2617 = "llvm.shufflevector"(%2606, %2473) <{mask = array<i32: -1, 0, 3, -1, -1, 4, 7, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2618 = "llvm.sub"(%2611, %2608) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2619 = "llvm.add"(%2618, %2533) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2620 = "llvm.shufflevector"(%2608, %2473) <{mask = array<i32: -1, 0, 3, -1, -1, 4, 7, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2621 = "llvm.add"(%2614, %2604) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2622 = "llvm.shufflevector"(%2613, %2621) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2623 = "llvm.add"(%2617, %2606) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2624 = "llvm.shufflevector"(%2616, %2623) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2625 = "llvm.add"(%2620, %2608) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2626 = "llvm.shufflevector"(%2619, %2625) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2627 = "llvm.add"(%2622, %2463) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2628 = "llvm.add"(%2624, %2462) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2629 = "llvm.add"(%2626, %2462) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2630 = "llvm.ashr"(%2627, %2461) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2631 = "llvm.ashr"(%2628, %2461) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2632 = "llvm.ashr"(%2629, %2460) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2633 = "llvm.mul"(%2632, %2509) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2634 = "llvm.and"(%2627, %2458) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2635 = "llvm.shufflevector"(%2633, %2632) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2636 = "llvm.add"(%2635, %2457) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2637 = "llvm.add"(%2636, %2634) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2638 = "llvm.and"(%2628, %2458) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2639 = "llvm.add"(%2638, %2456) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2640 = "llvm.add"(%2639, %2630) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2641 = "llvm.and"(%2629, %2455) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2642 = "llvm.add"(%2631, %2456) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2643 = "llvm.add"(%2642, %2641) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2644 = "llvm.shufflevector"(%2637, %2473) <{mask = array<i32: 0, 2, 2, 0, 4, 6, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2645 = "llvm.shufflevector"(%2640, %2473) <{mask = array<i32: 0, 2, 2, 0, 4, 6, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2646 = "llvm.shufflevector"(%2643, %2473) <{mask = array<i32: 0, 2, 2, 0, 4, 6, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2647 = "llvm.shufflevector"(%2637, %2473) <{mask = array<i32: 3, 1, 3, 1, 7, 5, 7, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2648 = "llvm.shufflevector"(%2640, %2473) <{mask = array<i32: 3, 1, 3, 1, 7, 5, 7, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2649 = "llvm.shufflevector"(%2643, %2473) <{mask = array<i32: 3, 1, 3, 1, 7, 5, 7, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.intr.lifetime.start"(%2537) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2538) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2539) : (!llvm.ptr) -> ()
  "llvm.call"(%2537, %2538, %2539, %2644, %2645, %2646, %2647, %2648, %2649) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_quad_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 9, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
  %2650 = "llvm.load"(%2537) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2651 = "llvm.load"(%2538) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2652 = "llvm.load"(%2539) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.intr.lifetime.end"(%2539) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2538) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2537) : (!llvm.ptr) -> ()
  "llvm.br"(%2650, %2651, %2652)[^bb3] : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
^bb2:  // pred: ^bb0
  %2653 = "llvm.load"(%arg117) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2654 = "llvm.shufflevector"(%2653, %2473) <{mask = array<i32: 1, -1, -1, -1, 5, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2655 = "llvm.getelementptr"(%arg117) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %2656 = "llvm.load"(%2655) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2657 = "llvm.shufflevector"(%2656, %2473) <{mask = array<i32: 1, -1, -1, -1, 5, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2658 = "llvm.getelementptr"(%arg117) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %2659 = "llvm.load"(%2658) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2660 = "llvm.shufflevector"(%2659, %2473) <{mask = array<i32: 1, -1, -1, -1, 5, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2661 = "llvm.load"(%arg118) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2662 = "llvm.shufflevector"(%2661, %2473) <{mask = array<i32: 1, -1, -1, -1, 5, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2663 = "llvm.getelementptr"(%arg118) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %2664 = "llvm.load"(%2663) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2665 = "llvm.shufflevector"(%2664, %2473) <{mask = array<i32: 1, -1, -1, -1, 5, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2666 = "llvm.getelementptr"(%arg118) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %2667 = "llvm.load"(%2666) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2668 = "llvm.shufflevector"(%2667, %2473) <{mask = array<i32: 1, -1, -1, -1, 5, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2669 = "llvm.sub"(%2654, %2653) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2670 = "llvm.add"(%2669, %2485) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2671 = "llvm.shufflevector"(%2670, %2653) <{mask = array<i32: 0, 8, 10, 11, 4, 12, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2672 = "llvm.sub"(%2657, %2656) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2673 = "llvm.add"(%2672, %2493) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2674 = "llvm.shufflevector"(%2673, %2656) <{mask = array<i32: 0, 8, 10, 11, 4, 12, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2675 = "llvm.sub"(%2660, %2659) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2676 = "llvm.add"(%2675, %2501) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2677 = "llvm.shufflevector"(%2676, %2659) <{mask = array<i32: 0, 8, 10, 11, 4, 12, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2678 = "llvm.sub"(%2662, %2661) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2679 = "llvm.add"(%2678, %2485) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2680 = "llvm.shufflevector"(%2679, %2661) <{mask = array<i32: 0, 8, 10, 11, 4, 12, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2681 = "llvm.sub"(%2665, %2664) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2682 = "llvm.add"(%2681, %2493) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2683 = "llvm.shufflevector"(%2682, %2664) <{mask = array<i32: 0, 8, 10, 11, 4, 12, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2684 = "llvm.sub"(%2668, %2667) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2685 = "llvm.add"(%2684, %2501) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2686 = "llvm.shufflevector"(%2685, %2667) <{mask = array<i32: 0, 8, 10, 11, 4, 12, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2687 = "llvm.add"(%2671, %2653) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2688 = "llvm.shufflevector"(%2671, %2687) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2689 = "llvm.add"(%2674, %2656) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2690 = "llvm.shufflevector"(%2674, %2689) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2691 = "llvm.add"(%2677, %2659) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2692 = "llvm.shufflevector"(%2677, %2691) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2693 = "llvm.add"(%2680, %2661) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2694 = "llvm.shufflevector"(%2680, %2693) <{mask = array<i32: 0, 9, 2, 3, 4, 13, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2695 = "llvm.add"(%2683, %2664) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2696 = "llvm.shufflevector"(%2683, %2695) <{mask = array<i32: 0, 9, 2, 3, 4, 13, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2697 = "llvm.add"(%2686, %2667) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2698 = "llvm.shufflevector"(%2686, %2697) <{mask = array<i32: 0, 9, 2, 3, 4, 13, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2699 = "llvm.add"(%2688, %2463) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2700 = "llvm.add"(%2690, %2462) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2701 = "llvm.add"(%2692, %2462) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2702 = "llvm.ashr"(%2699, %2461) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2703 = "llvm.ashr"(%2700, %2461) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2704 = "llvm.ashr"(%2701, %2460) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2705 = "llvm.mul"(%2704, %2509) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2706 = "llvm.and"(%2699, %2458) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2707 = "llvm.shufflevector"(%2705, %2704) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2708 = "llvm.add"(%2706, %2457) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2709 = "llvm.add"(%2708, %2707) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2710 = "llvm.and"(%2700, %2458) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2711 = "llvm.add"(%2702, %2456) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2712 = "llvm.add"(%2711, %2710) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2713 = "llvm.and"(%2701, %2455) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2714 = "llvm.add"(%2703, %2456) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2715 = "llvm.add"(%2714, %2713) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2716 = "llvm.add"(%2694, %2463) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2717 = "llvm.add"(%2696, %2462) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2718 = "llvm.add"(%2698, %2462) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2719 = "llvm.ashr"(%2716, %2461) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2720 = "llvm.ashr"(%2717, %2461) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2721 = "llvm.ashr"(%2718, %2460) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2722 = "llvm.mul"(%2721, %2509) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2723 = "llvm.and"(%2716, %2458) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2724 = "llvm.shufflevector"(%2722, %2721) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2725 = "llvm.add"(%2723, %2457) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2726 = "llvm.add"(%2725, %2724) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2727 = "llvm.and"(%2717, %2458) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2728 = "llvm.add"(%2719, %2456) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2729 = "llvm.add"(%2728, %2727) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2730 = "llvm.and"(%2718, %2455) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2731 = "llvm.add"(%2720, %2456) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2732 = "llvm.add"(%2731, %2730) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.intr.lifetime.start"(%2540) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2541) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2542) : (!llvm.ptr) -> ()
  "llvm.call"(%2540, %2541, %2542, %2709, %2712, %2715, %2454, %2453, %2452) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_quad_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 9, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
  %2733 = "llvm.load"(%2540) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2734 = "llvm.load"(%2541) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2735 = "llvm.load"(%2542) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.intr.lifetime.end"(%2542) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2541) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2540) : (!llvm.ptr) -> ()
  %2736 = "llvm.lshr"(%2733, %2461) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2737 = "llvm.lshr"(%2734, %2461) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2738 = "llvm.lshr"(%2735, %2460) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2739 = "llvm.mul"(%2738, %2509) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2740 = "llvm.and"(%2733, %2458) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2741 = "llvm.shufflevector"(%2739, %2738) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2742 = "llvm.add"(%2741, %2740) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2743 = "llvm.and"(%2734, %2458) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2744 = "llvm.add"(%2743, %2736) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2745 = "llvm.and"(%2735, %2455) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2746 = "llvm.add"(%2745, %2737) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.intr.lifetime.start"(%2543) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2544) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2545) : (!llvm.ptr) -> ()
  "llvm.call"(%2543, %2544, %2545, %2742, %2744, %2746, %2726, %2729, %2732) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_quad_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 9, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
  %2747 = "llvm.load"(%2543) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2748 = "llvm.load"(%2544) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2749 = "llvm.load"(%2545) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.intr.lifetime.end"(%2545) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2544) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2543) : (!llvm.ptr) -> ()
  %2750 = "llvm.shufflevector"(%2747, %2473) <{mask = array<i32: 1, -1, -1, 2, 5, -1, -1, 6>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2751 = "llvm.shufflevector"(%2748, %2473) <{mask = array<i32: 1, -1, -1, 2, 5, -1, -1, 6>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2752 = "llvm.shufflevector"(%2749, %2473) <{mask = array<i32: 1, -1, -1, 2, 5, -1, -1, 6>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2753 = "llvm.sub"(%2750, %2747) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2754 = "llvm.add"(%2753, %2517) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2755 = "llvm.shufflevector"(%2747, %2473) <{mask = array<i32: -1, 0, 3, -1, -1, 4, 7, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2756 = "llvm.sub"(%2751, %2748) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2757 = "llvm.add"(%2756, %2525) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2758 = "llvm.shufflevector"(%2748, %2473) <{mask = array<i32: -1, 0, 3, -1, -1, 4, 7, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2759 = "llvm.sub"(%2752, %2749) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2760 = "llvm.add"(%2759, %2533) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2761 = "llvm.shufflevector"(%2749, %2473) <{mask = array<i32: -1, 0, 3, -1, -1, 4, 7, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2762 = "llvm.add"(%2755, %2747) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2763 = "llvm.shufflevector"(%2754, %2762) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2764 = "llvm.add"(%2758, %2748) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2765 = "llvm.shufflevector"(%2757, %2764) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2766 = "llvm.add"(%2761, %2749) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2767 = "llvm.shufflevector"(%2760, %2766) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2768 = "llvm.add"(%2763, %2463) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2769 = "llvm.add"(%2765, %2462) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2770 = "llvm.add"(%2767, %2462) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2771 = "llvm.ashr"(%2768, %2461) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2772 = "llvm.ashr"(%2769, %2461) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2773 = "llvm.ashr"(%2770, %2460) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2774 = "llvm.mul"(%2773, %2509) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2775 = "llvm.and"(%2768, %2458) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2776 = "llvm.shufflevector"(%2774, %2773) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2777 = "llvm.add"(%2775, %2457) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2778 = "llvm.add"(%2777, %2776) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2779 = "llvm.and"(%2769, %2458) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2780 = "llvm.add"(%2771, %2456) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2781 = "llvm.add"(%2780, %2779) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2782 = "llvm.and"(%2770, %2455) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2783 = "llvm.add"(%2772, %2456) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2784 = "llvm.add"(%2783, %2782) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2785 = "llvm.shufflevector"(%2778, %2473) <{mask = array<i32: 0, 2, 2, 0, 4, 6, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2786 = "llvm.shufflevector"(%2781, %2473) <{mask = array<i32: 0, 2, 2, 0, 4, 6, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2787 = "llvm.shufflevector"(%2784, %2473) <{mask = array<i32: 0, 2, 2, 0, 4, 6, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2788 = "llvm.shufflevector"(%2778, %2473) <{mask = array<i32: 3, 1, 3, 1, 7, 5, 7, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2789 = "llvm.shufflevector"(%2781, %2473) <{mask = array<i32: 3, 1, 3, 1, 7, 5, 7, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2790 = "llvm.shufflevector"(%2784, %2473) <{mask = array<i32: 3, 1, 3, 1, 7, 5, 7, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.intr.lifetime.start"(%2546) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2547) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2548) : (!llvm.ptr) -> ()
  "llvm.call"(%2546, %2547, %2548, %2785, %2786, %2787, %2788, %2789, %2790) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_quad_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 9, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
  %2791 = "llvm.load"(%2546) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2792 = "llvm.load"(%2547) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2793 = "llvm.load"(%2548) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.intr.lifetime.end"(%2548) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2547) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2546) : (!llvm.ptr) -> ()
  "llvm.br"(%2791, %2792, %2793)[^bb3] : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
^bb3(%2794: vector<8xi64>, %2795: vector<8xi64>, %2796: vector<8xi64>):  // 2 preds: ^bb1, ^bb2
  %2797 = "llvm.lshr"(%2794, %2461) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2798 = "llvm.lshr"(%2795, %2461) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2799 = "llvm.lshr"(%2796, %2460) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2800 = "llvm.mul"(%2799, %2509) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2801 = "llvm.and"(%2794, %2458) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2802 = "llvm.shufflevector"(%2800, %2799) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2803 = "llvm.add"(%2802, %2801) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%2803, %arg116) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2804 = "llvm.and"(%2795, %2458) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2805 = "llvm.add"(%2804, %2797) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2806 = "llvm.getelementptr"(%arg116) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2805, %2806) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2807 = "llvm.and"(%2796, %2455) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2808 = "llvm.add"(%2807, %2798) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2809 = "llvm.getelementptr"(%arg116) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2808, %2809) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.return"(%arg116) : (!llvm.ptr) -> ()
}) : () -> ()
  with @fd_r43x6_quad_mul_fast := fd_r43x6_quad_mul_fast

end

end MLIR.Firedancer.Avx512
