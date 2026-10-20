module

-- crc/out/mlirproofs/regions/verify/fd_r52x5_double_scalar_mul_base_split.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_base_table_init
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_ge_add_table
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_ge_dbl
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_neg
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_wnaf
public import Firedancer.Crc.Verify.Mlir.wl_permute
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_base_split_table
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_base_table

meta import MLIR.Semantics.Func
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_base_table_init
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_ge_add_table
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_ge_dbl
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_neg
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_wnaf
meta import Firedancer.Crc.Verify.Mlir.wl_permute
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_base_split_table
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_base_table

namespace MLIR.Firedancer.Crc.Verify

@[expose] public section

mlir_def fd_r52x5_double_scalar_mul_base_split :=
#loop_annotation = #llvm.loop_annotation<mustProgress = true>
"llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nocapture, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.noundef, llvm.readonly}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = readwrite, argMem = readwrite, inaccessibleMem = none, errnoMem = readwrite, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "256"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], sym_name = "fd_r52x5_double_scalar_mul_base_split", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg167: !llvm.ptr, %arg168: !llvm.ptr, %arg169: !llvm.ptr, %arg170: !llvm.ptr):
  %2457 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %2458 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %2459 = "llvm.mlir.constant"() <{value = 8 : i32}> : () -> i32
  %2460 = "llvm.mlir.constant"() <{value = 264 : i32}> : () -> i32
  %2461 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %2462 = "llvm.mlir.constant"() <{value = 263 : i32}> : () -> i32
  %2463 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %2464 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %2465 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %2466 = "llvm.mlir.constant"() <{value = dense<[0, 1, 1, 0]> : vector<4xi64>}> : () -> vector<4xi64>
  %2467 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %2468 = "llvm.mlir.constant"() <{value = dense<0> : vector<4xi64>}> : () -> vector<4xi64>
  %2469 = "llvm.mlir.constant"() <{value = 33 : i64}> : () -> i64
  %2470 = "llvm.mlir.constant"() <{value = 768 : i64}> : () -> i64
  %2471 = "llvm.mlir.addressof"() <{global_name = @fd_r52x5_base_split_table}> : () -> !llvm.ptr
  %2472 = "llvm.mlir.addressof"() <{global_name = @fd_r52x5_base_table}> : () -> !llvm.ptr
  %2473 = "llvm.mlir.constant"() <{value = 0 : i16}> : () -> i16
  %2474 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
  %2475 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %2476 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %2477 = "llvm.mlir.constant"() <{value = 8 : i64}> : () -> i64
  %2478 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %2479 = "llvm.alloca"(%2457) <{alignment = 16 : i64, elem_type = !llvm.array<264 x i16>}> : (i32) -> !llvm.ptr
  %2480 = "llvm.alloca"(%2457) <{alignment = 16 : i64, elem_type = !llvm.array<264 x i16>}> : (i32) -> !llvm.ptr
  %2481 = "llvm.alloca"(%2457) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2482 = "llvm.alloca"(%2457) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2483 = "llvm.alloca"(%2457) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2484 = "llvm.alloca"(%2457) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2485 = "llvm.alloca"(%2457) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2486 = "llvm.alloca"(%2457) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2487 = "llvm.alloca"(%2457) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2488 = "llvm.alloca"(%2457) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2489 = "llvm.alloca"(%2457) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2490 = "llvm.alloca"(%2457) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2491 = "llvm.alloca"(%2457) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2492 = "llvm.alloca"(%2457) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2493 = "llvm.alloca"(%2457) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2494 = "llvm.alloca"(%2457) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2495 = "llvm.alloca"(%2457) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2496 = "llvm.alloca"(%2457) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2497 = "llvm.alloca"(%2457) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2498 = "llvm.alloca"(%2457) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2499 = "llvm.alloca"(%2457) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2500 = "llvm.alloca"(%2457) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2501 = "llvm.alloca"(%2457) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2502 = "llvm.alloca"(%2457) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2503 = "llvm.alloca"(%2457) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2504 = "llvm.alloca"(%2457) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2505 = "llvm.alloca"(%2457) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2506 = "llvm.alloca"(%2457) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2507 = "llvm.alloca"(%2457) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2508 = "llvm.alloca"(%2457) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2509 = "llvm.alloca"(%2457) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2510 = "llvm.alloca"(%2457) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2511 = "llvm.alloca"(%2457) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2512 = "llvm.alloca"(%2457) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2513 = "llvm.alloca"(%2457) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2514 = "llvm.alloca"(%2457) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2515 = "llvm.alloca"(%2457) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  "llvm.call"() <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, callee = @fd_r52x5_base_table_init, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = readwrite, argMem = readwrite, inaccessibleMem = none, errnoMem = readwrite, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
  "llvm.intr.lifetime.start"(%2479) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2480) : (!llvm.ptr) -> ()
  %2516 = "llvm.call"(%2479, %arg168, %2458) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_wnaf, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> i32
  %2517 = "llvm.call"(%2480, %arg170, %2459) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_wnaf, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> i32
  %2518 = "llvm.icmp"(%2516, %2460) <{predicate = 2 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2518)[^bb1, ^bb2] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb1:  // pred: ^bb0
  %2519 = "llvm.sext"(%2516) : (i32) -> i64
  %2520 = "llvm.shl"(%2519, %2461) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %2521 = "llvm.getelementptr"(%2479, %2520) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %2522 = "llvm.sub"(%2462, %2516) <{overflowFlags = 0 : i32}> : (i32, i32) -> i32
  %2523 = "llvm.zext"(%2522) : (i32) -> i64
  %2524 = "llvm.shl"(%2523, %2461) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2525 = "llvm.add"(%2524, %2463) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  "llvm.intr.memset"(%2521, %2464, %2525) <{arg_attrs = [{llvm.align = 2 : i64, llvm.dereferenceable = 1 : i64, llvm.nonnull, llvm.noundef}, {}, {}], isVolatile = false}> : (!llvm.ptr, i8, i64) -> ()
  "llvm.br"()[^bb2] : () -> ()
^bb2:  // 2 preds: ^bb0, ^bb1
  %2526 = "llvm.icmp"(%2517, %2460) <{predicate = 2 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2526)[^bb4, ^bb3] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb3:  // 2 preds: ^bb2, ^bb4
  "llvm.br"(%2465, %2466, %2468, %2468, %2468, %2468)[^bb6] : (i64, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb4:  // pred: ^bb2
  %2527 = "llvm.sext"(%2517) : (i32) -> i64
  %2528 = "llvm.shl"(%2527, %2461) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %2529 = "llvm.getelementptr"(%2480, %2528) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %2530 = "llvm.sub"(%2462, %2517) <{overflowFlags = 0 : i32}> : (i32, i32) -> i32
  %2531 = "llvm.zext"(%2530) : (i32) -> i64
  %2532 = "llvm.shl"(%2531, %2461) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2533 = "llvm.add"(%2532, %2463) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  "llvm.intr.memset"(%2529, %2464, %2533) <{arg_attrs = [{llvm.align = 2 : i64, llvm.dereferenceable = 1 : i64, llvm.nonnull, llvm.noundef}, {}, {}], isVolatile = false}> : (!llvm.ptr, i8, i64) -> ()
  "llvm.br"()[^bb3] : () -> ()
^bb5:  // pred: ^bb7
  "llvm.store"(%2686, %arg167) <{alignment = 64 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %2534 = "llvm.getelementptr"(%arg167) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2685, %2534) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %2535 = "llvm.getelementptr"(%arg167) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2684, %2535) <{alignment = 64 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %2536 = "llvm.getelementptr"(%arg167) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2683, %2536) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %2537 = "llvm.getelementptr"(%arg167) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2682, %2537) <{alignment = 64 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2480) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2479) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
^bb6(%2538: i64, %2539: vector<4xi64>, %2540: vector<4xi64>, %2541: vector<4xi64>, %2542: vector<4xi64>, %2543: vector<4xi64>):  // 2 preds: ^bb3, ^bb7
  "llvm.intr.lifetime.start"(%2481) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2482) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2483) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2484) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2485) : (!llvm.ptr) -> ()
  "llvm.call"(%2481, %2482, %2483, %2484, %2485, %2539, %2540, %2541, %2542, %2543) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_ge_dbl, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2544 = "llvm.load"(%2481) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2545 = "llvm.load"(%2482) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2546 = "llvm.load"(%2483) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2547 = "llvm.load"(%2484) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2548 = "llvm.load"(%2485) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2485) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2484) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2483) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2482) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2481) : (!llvm.ptr) -> ()
  "llvm.br"(%2467, %2544, %2545, %2546, %2547, %2548)[^bb8] : (i64, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb7:  // pred: ^bb16
  %2549 = "llvm.add"(%2538, %2478) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %2550 = "llvm.icmp"(%2538, %2467) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%2550, %2549, %2686, %2685, %2684, %2683, %2682)[^bb5, ^bb6] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 6>}> : (i1, i64, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb8(%2551: i64, %2552: vector<4xi64>, %2553: vector<4xi64>, %2554: vector<4xi64>, %2555: vector<4xi64>, %2556: vector<4xi64>):  // 2 preds: ^bb6, ^bb16
  %2557 = "llvm.mul"(%2551, %2469) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2558 = "llvm.add"(%2557, %2538) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2559 = "llvm.getelementptr"(%2479, %2558) <{elem_type = i16, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %2560 = "llvm.load"(%2559) <{alignment = 2 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i16
  %2561 = "llvm.getelementptr"(%2480, %2558) <{elem_type = i16, noWrapFlags = 3 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %2562 = "llvm.load"(%2561) <{alignment = 2 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i16
  %2563 = "llvm.mul"(%2551, %2470) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2564 = "llvm.getelementptr"(%arg169, %2563) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %2565 = "llvm.icmp"(%2551, %2467) <{predicate = 0 : i64}> : (i64, i64) -> i1
  %2566 = "llvm.getelementptr"(%2471, %2551) <{elem_type = !llvm.array<128 x struct<"struct.fd_r52x5_ge", (vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, array<32 x i8>)>>, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %2567 = "llvm.getelementptr"(%2566) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -24576>}> : (!llvm.ptr) -> !llvm.ptr
  %2568 = "llvm.select"(%2565, %2472, %2567) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %2569 = "llvm.sext"(%2560) : (i16) -> i32
  %2570 = "llvm.icmp"(%2560, %2473) <{predicate = 4 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%2570)[^bb9, ^bb10] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb9:  // pred: ^bb8
  %2571 = "llvm.add"(%2569, %2474) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %2572 = "llvm.lshr"(%2571, %2457) : (i32, i32) -> i32
  %2573 = "llvm.zext"(%2572) <{nonNeg}> : (i32) -> i64
  %2574 = "llvm.getelementptr"(%2564, %2573) <{elem_type = !llvm.struct<"struct.fd_r52x5_ge", (vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, array<32 x i8>)>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %2575 = "llvm.load"(%2574) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2576 = "llvm.getelementptr"(%2574) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %2577 = "llvm.load"(%2576) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2578 = "llvm.getelementptr"(%2574) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %2579 = "llvm.load"(%2578) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2580 = "llvm.getelementptr"(%2574) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %2581 = "llvm.load"(%2580) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2582 = "llvm.getelementptr"(%2574) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %2583 = "llvm.load"(%2582) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%2486) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2487) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2488) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2489) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2490) : (!llvm.ptr) -> ()
  "llvm.call"(%2486, %2487, %2488, %2489, %2490, %2552, %2553, %2554, %2555, %2556, %2575, %2577, %2579, %2581, %2583) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_ge_add_table, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2584 = "llvm.load"(%2486) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2585 = "llvm.load"(%2487) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2586 = "llvm.load"(%2488) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2587 = "llvm.load"(%2489) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2588 = "llvm.load"(%2490) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2490) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2489) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2488) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2487) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2486) : (!llvm.ptr) -> ()
  "llvm.br"(%2588, %2587, %2586, %2585, %2584)[^bb12] : (vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb10:  // pred: ^bb8
  %2589 = "llvm.icmp"(%2560, %2473) <{predicate = 2 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%2589, %2556, %2555, %2554, %2553, %2552)[^bb11, ^bb12] <{operandSegmentSizes = array<i32: 1, 0, 5>}> : (i1, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb11:  // pred: ^bb10
  %2590 = "llvm.xor"(%2569, %2474) : (i32, i32) -> i32
  %2591 = "llvm.lshr"(%2590, %2457) : (i32, i32) -> i32
  %2592 = "llvm.zext"(%2591) <{nonNeg}> : (i32) -> i64
  %2593 = "llvm.getelementptr"(%2564, %2592) <{elem_type = !llvm.struct<"struct.fd_r52x5_ge", (vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, array<32 x i8>)>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %2594 = "llvm.load"(%2593) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2595 = "llvm.getelementptr"(%2593) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %2596 = "llvm.load"(%2595) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2597 = "llvm.getelementptr"(%2593) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %2598 = "llvm.load"(%2597) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2599 = "llvm.getelementptr"(%2593) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %2600 = "llvm.load"(%2599) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2601 = "llvm.getelementptr"(%2593) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %2602 = "llvm.load"(%2601) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2603 = "llvm.call"(%2594, %2457, %2475, %2476, %2458) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2604 = "llvm.call"(%2596, %2457, %2475, %2476, %2458) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2605 = "llvm.call"(%2598, %2457, %2475, %2476, %2458) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2606 = "llvm.call"(%2600, %2457, %2475, %2476, %2458) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2607 = "llvm.call"(%2602, %2457, %2475, %2476, %2458) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%2491) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2492) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2493) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2494) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2495) : (!llvm.ptr) -> ()
  "llvm.call"(%2491, %2492, %2493, %2494, %2495, %2603, %2604, %2605, %2606, %2607) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_neg, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2608 = "llvm.load"(%2491) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2609 = "llvm.load"(%2492) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2610 = "llvm.load"(%2493) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2611 = "llvm.load"(%2494) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2612 = "llvm.load"(%2495) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2495) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2494) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2493) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2492) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2491) : (!llvm.ptr) -> ()
  %2613 = "llvm.shufflevector"(%2603, %2608) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2614 = "llvm.shufflevector"(%2604, %2609) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2615 = "llvm.shufflevector"(%2605, %2610) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2616 = "llvm.shufflevector"(%2606, %2611) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2617 = "llvm.shufflevector"(%2607, %2612) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%2496) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2497) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2498) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2499) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2500) : (!llvm.ptr) -> ()
  "llvm.call"(%2496, %2497, %2498, %2499, %2500, %2552, %2553, %2554, %2555, %2556, %2613, %2614, %2615, %2616, %2617) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_ge_add_table, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2618 = "llvm.load"(%2496) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2619 = "llvm.load"(%2497) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2620 = "llvm.load"(%2498) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2621 = "llvm.load"(%2499) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2622 = "llvm.load"(%2500) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2500) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2499) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2498) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2497) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2496) : (!llvm.ptr) -> ()
  "llvm.br"(%2622, %2621, %2620, %2619, %2618)[^bb12] : (vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb12(%2623: vector<4xi64>, %2624: vector<4xi64>, %2625: vector<4xi64>, %2626: vector<4xi64>, %2627: vector<4xi64>):  // 3 preds: ^bb9, ^bb10, ^bb11
  %2628 = "llvm.sext"(%2562) : (i16) -> i32
  %2629 = "llvm.icmp"(%2562, %2473) <{predicate = 4 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%2629)[^bb13, ^bb14] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb13:  // pred: ^bb12
  %2630 = "llvm.add"(%2628, %2474) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %2631 = "llvm.lshr"(%2630, %2457) : (i32, i32) -> i32
  %2632 = "llvm.zext"(%2631) <{nonNeg}> : (i32) -> i64
  %2633 = "llvm.getelementptr"(%2568, %2632) <{elem_type = !llvm.struct<"struct.fd_r52x5_ge", (vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, array<32 x i8>)>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %2634 = "llvm.load"(%2633) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2635 = "llvm.getelementptr"(%2633) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %2636 = "llvm.load"(%2635) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2637 = "llvm.getelementptr"(%2633) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %2638 = "llvm.load"(%2637) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2639 = "llvm.getelementptr"(%2633) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %2640 = "llvm.load"(%2639) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2641 = "llvm.getelementptr"(%2633) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %2642 = "llvm.load"(%2641) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%2501) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2502) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2503) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2504) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2505) : (!llvm.ptr) -> ()
  "llvm.call"(%2501, %2502, %2503, %2504, %2505, %2627, %2626, %2625, %2624, %2623, %2634, %2636, %2638, %2640, %2642) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_ge_add_table, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2643 = "llvm.load"(%2501) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2644 = "llvm.load"(%2502) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2645 = "llvm.load"(%2503) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2646 = "llvm.load"(%2504) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2647 = "llvm.load"(%2505) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2505) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2504) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2503) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2502) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2501) : (!llvm.ptr) -> ()
  "llvm.br"(%2647, %2646, %2645, %2644, %2643)[^bb16] : (vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb14:  // pred: ^bb12
  %2648 = "llvm.icmp"(%2562, %2473) <{predicate = 2 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%2648, %2623, %2624, %2625, %2626, %2627)[^bb15, ^bb16] <{operandSegmentSizes = array<i32: 1, 0, 5>}> : (i1, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb15:  // pred: ^bb14
  %2649 = "llvm.xor"(%2628, %2474) : (i32, i32) -> i32
  %2650 = "llvm.lshr"(%2649, %2457) : (i32, i32) -> i32
  %2651 = "llvm.zext"(%2650) <{nonNeg}> : (i32) -> i64
  %2652 = "llvm.getelementptr"(%2568, %2651) <{elem_type = !llvm.struct<"struct.fd_r52x5_ge", (vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, array<32 x i8>)>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %2653 = "llvm.load"(%2652) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2654 = "llvm.getelementptr"(%2652) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %2655 = "llvm.load"(%2654) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2656 = "llvm.getelementptr"(%2652) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %2657 = "llvm.load"(%2656) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2658 = "llvm.getelementptr"(%2652) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %2659 = "llvm.load"(%2658) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2660 = "llvm.getelementptr"(%2652) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %2661 = "llvm.load"(%2660) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2662 = "llvm.call"(%2653, %2457, %2475, %2476, %2458) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2663 = "llvm.call"(%2655, %2457, %2475, %2476, %2458) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2664 = "llvm.call"(%2657, %2457, %2475, %2476, %2458) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2665 = "llvm.call"(%2659, %2457, %2475, %2476, %2458) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2666 = "llvm.call"(%2661, %2457, %2475, %2476, %2458) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%2506) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2507) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2508) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2509) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2510) : (!llvm.ptr) -> ()
  "llvm.call"(%2506, %2507, %2508, %2509, %2510, %2662, %2663, %2664, %2665, %2666) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_neg, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2667 = "llvm.load"(%2506) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2668 = "llvm.load"(%2507) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2669 = "llvm.load"(%2508) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2670 = "llvm.load"(%2509) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2671 = "llvm.load"(%2510) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2510) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2509) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2508) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2507) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2506) : (!llvm.ptr) -> ()
  %2672 = "llvm.shufflevector"(%2662, %2667) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2673 = "llvm.shufflevector"(%2663, %2668) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2674 = "llvm.shufflevector"(%2664, %2669) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2675 = "llvm.shufflevector"(%2665, %2670) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2676 = "llvm.shufflevector"(%2666, %2671) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%2511) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2512) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2513) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2514) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2515) : (!llvm.ptr) -> ()
  "llvm.call"(%2511, %2512, %2513, %2514, %2515, %2627, %2626, %2625, %2624, %2623, %2672, %2673, %2674, %2675, %2676) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_ge_add_table, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2677 = "llvm.load"(%2511) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2678 = "llvm.load"(%2512) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2679 = "llvm.load"(%2513) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2680 = "llvm.load"(%2514) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2681 = "llvm.load"(%2515) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2515) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2514) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2513) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2512) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2511) : (!llvm.ptr) -> ()
  "llvm.br"(%2681, %2680, %2679, %2678, %2677)[^bb16] : (vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb16(%2682: vector<4xi64>, %2683: vector<4xi64>, %2684: vector<4xi64>, %2685: vector<4xi64>, %2686: vector<4xi64>):  // 3 preds: ^bb13, ^bb14, ^bb15
  %2687 = "llvm.add"(%2551, %2461) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2688 = "llvm.icmp"(%2687, %2477) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%2688, %2687, %2686, %2685, %2684, %2683, %2682)[^bb7, ^bb8] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 6>}> : (i1, i64, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
}) : () -> ()
  with @fd_r52x5_base_table_init := fd_r52x5_base_table_init,
    @fd_r52x5_quad_ge_add_table := fd_r52x5_quad_ge_add_table,
    @fd_r52x5_quad_ge_dbl := fd_r52x5_quad_ge_dbl, @fd_r52x5_quad_neg := fd_r52x5_quad_neg,
    @fd_r52x5_wnaf := fd_r52x5_wnaf, @wl_permute := wl_permute,
    @fd_r52x5_base_split_table := fd_r52x5_base_split_table,
    @fd_r52x5_base_table := fd_r52x5_base_table

end

end MLIR.Firedancer.Crc.Verify
