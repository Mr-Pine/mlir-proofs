module

-- crc/out/mlirproofs/regions/verify/fd_r52x5_ge_affine_canon.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_inv_propose
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_limbs_is_one
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_lane_canon
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_mul
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_sqr
public import Firedancer.Crc.Ed25519.Avx512.Mlir.wl_permute

meta import MLIR.Semantics.Func
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_inv_propose
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_limbs_is_one
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_lane_canon
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_mul
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_sqr
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.wl_permute

namespace MLIR.Firedancer.Crc.Ed25519.Avx512

@[expose] public section

noncomputable mlir_def fd_r52x5_ge_affine_canon :=
#loop_annotation = #llvm.loop_annotation<mustProgress = true>
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, no_inline, no_unwind, passthrough = ["sspstrong", ["min-legal-vector-width", "256"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], sym_name = "fd_r52x5_ge_affine_canon", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg202: !llvm.ptr, %arg203: !llvm.ptr, %arg204: !llvm.ptr):
  %2582 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %2583 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %2584 = "llvm.mlir.poison"() : () -> vector<1xi64>
  %2585 = "llvm.mlir.poison"() : () -> vector<4xi64>
  %2586 = "llvm.mlir.constant"() <{value = 64 : i256}> : () -> i256
  %2587 = "llvm.mlir.poison"() : () -> vector<2xi64>
  %2588 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %2589 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %2590 = "llvm.mlir.constant"() <{value = 20 : i32}> : () -> i32
  %2591 = "llvm.mlir.constant"() <{value = 50 : i32}> : () -> i32
  %2592 = "llvm.mlir.constant"() <{value = 100 : i32}> : () -> i32
  %2593 = "llvm.alloca"(%2582) <{alignment = 16 : i64, elem_type = !llvm.array<5 x i64>}> : (i32) -> !llvm.ptr
  %2594 = "llvm.alloca"(%2582) <{alignment = 16 : i64, elem_type = !llvm.array<5 x i64>}> : (i32) -> !llvm.ptr
  %2595 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2596 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2597 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2598 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2599 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2600 = "llvm.alloca"(%2582) <{alignment = 16 : i64, elem_type = !llvm.array<5 x i64>}> : (i32) -> !llvm.ptr
  %2601 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2602 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2603 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2604 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2605 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2606 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2607 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2608 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2609 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2610 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2611 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2612 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2613 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2614 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2615 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2616 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2617 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2618 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2619 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2620 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2621 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2622 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2623 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2624 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2625 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2626 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2627 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2628 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2629 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2630 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2631 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2632 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2633 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2634 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2635 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2636 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2637 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2638 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2639 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2640 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2641 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2642 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2643 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2644 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2645 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2646 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2647 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2648 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2649 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2650 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2651 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2652 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2653 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2654 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2655 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2656 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2657 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2658 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2659 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2660 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2661 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2662 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2663 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2664 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2665 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2666 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2667 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2668 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2669 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2670 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2671 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2672 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2673 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2674 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2675 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2676 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2677 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2678 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2679 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2680 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2681 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2682 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2683 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2684 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2685 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2686 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2687 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2688 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2689 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2690 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2691 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2692 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2693 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2694 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2695 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2696 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2697 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2698 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2699 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2700 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2701 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2702 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2703 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2704 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2705 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2706 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2707 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2708 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2709 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2710 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2711 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2712 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2713 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2714 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2715 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2716 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2717 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2718 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2719 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2720 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2721 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2722 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2723 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2724 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2725 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2726 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2727 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2728 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2729 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2730 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2731 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2732 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2733 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2734 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2735 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2736 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2737 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2738 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2739 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2740 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2741 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2742 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2743 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2744 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2745 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2746 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2747 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2748 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2749 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2750 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2751 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2752 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2753 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2754 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2755 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2756 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2757 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2758 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2759 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2760 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2761 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2762 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2763 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2764 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2765 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2766 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2767 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2768 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2769 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2770 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2771 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2772 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2773 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2774 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2775 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2776 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2777 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2778 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2779 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2780 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2781 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2782 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2783 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2784 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2785 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2786 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2787 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2788 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2789 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2790 = "llvm.alloca"(%2582) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2791 = "llvm.load"(%arg204) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2792 = "llvm.getelementptr"(%arg204) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %2793 = "llvm.load"(%2792) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2794 = "llvm.getelementptr"(%arg204) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %2795 = "llvm.load"(%2794) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2796 = "llvm.getelementptr"(%arg204) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %2797 = "llvm.load"(%2796) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2798 = "llvm.getelementptr"(%arg204) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %2799 = "llvm.load"(%2798) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%2593) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2594) : (!llvm.ptr) -> ()
  "llvm.call"(%2593, %2791, %2793, %2795, %2797, %2799, %2583) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_lane_canon, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 7, 0>}> : (!llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, i32) -> ()
  "llvm.call"(%2594, %2593) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_inv_propose, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %2800 = "llvm.load"(%2594) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<1xi64>
  %2801 = "llvm.shufflevector"(%2800, %2584) <{mask = array<i32: 0, 0, 0, 0>}> : (vector<1xi64>, vector<1xi64>) -> vector<4xi64>
  %2802 = "llvm.getelementptr"(%2594) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %2803 = "llvm.load"(%2802) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2804 = "llvm.shufflevector"(%2803, %2585) <{mask = array<i32: 0, 0, 0, 0>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2805 = "llvm.bitcast"(%2803) : (vector<4xi64>) -> i256
  %2806 = "llvm.lshr"(%2805, %2586) : (i256, i256) -> i256
  %2807 = "llvm.trunc"(%2806) <{overflowFlags = 0 : i32}> : (i256) -> i128
  %2808 = "llvm.bitcast"(%2807) : (i128) -> vector<2xi64>
  %2809 = "llvm.shufflevector"(%2808, %2587) <{mask = array<i32: 0, 0, 0, 0>}> : (vector<2xi64>, vector<2xi64>) -> vector<4xi64>
  %2810 = "llvm.bitcast"(%2803) : (vector<4xi64>) -> vector<2xi128>
  %2811 = "llvm.extractelement"(%2810, %2588) : (vector<2xi128>, i64) -> i128
  %2812 = "llvm.bitcast"(%2811) : (i128) -> vector<2xi64>
  %2813 = "llvm.shufflevector"(%2812, %2587) <{mask = array<i32: 0, 0, 0, 0>}> : (vector<2xi64>, vector<2xi64>) -> vector<4xi64>
  %2814 = "llvm.shufflevector"(%2803, %2585) <{mask = array<i32: 3, 3, 3, 3>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%2595) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2596) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2597) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2598) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2599) : (!llvm.ptr) -> ()
  "llvm.call"(%2595, %2596, %2597, %2598, %2599, %2791, %2793, %2795, %2797, %2799, %2801, %2804, %2809, %2813, %2814) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2815 = "llvm.load"(%2595) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2816 = "llvm.load"(%2596) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2817 = "llvm.load"(%2597) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2818 = "llvm.load"(%2598) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2819 = "llvm.load"(%2599) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2599) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2598) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2597) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2596) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2595) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2600) : (!llvm.ptr) -> ()
  "llvm.call"(%2600, %2815, %2816, %2817, %2818, %2819, %2583) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_lane_canon, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 7, 0>}> : (!llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, i32) -> ()
  %2820 = "llvm.call"(%2600) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_r52x5_limbs_is_one, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i32
  %2821 = "llvm.icmp"(%2820, %2589) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2821, %2819, %2818, %2817, %2816, %2815)[^bb1, ^bb10] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 5>}> : (i1, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb1:  // pred: ^bb0
  %2822 = "llvm.call"(%2791, %2583, %2583, %2583, %2583) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2823 = "llvm.call"(%2793, %2583, %2583, %2583, %2583) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2824 = "llvm.call"(%2795, %2583, %2583, %2583, %2583) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2825 = "llvm.call"(%2797, %2583, %2583, %2583, %2583) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2826 = "llvm.call"(%2799, %2583, %2583, %2583, %2583) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%2601) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2602) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2603) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2604) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2605) : (!llvm.ptr) -> ()
  "llvm.call"(%2601, %2602, %2603, %2604, %2605, %2822, %2823, %2824, %2825, %2826) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2827 = "llvm.load"(%2601) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2828 = "llvm.load"(%2602) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2829 = "llvm.load"(%2603) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2830 = "llvm.load"(%2604) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2831 = "llvm.load"(%2605) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2605) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2604) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2603) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2602) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2601) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2606) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2607) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2608) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2609) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2610) : (!llvm.ptr) -> ()
  "llvm.call"(%2606, %2607, %2608, %2609, %2610, %2827, %2828, %2829, %2830, %2831) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2832 = "llvm.load"(%2606) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2833 = "llvm.load"(%2607) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2834 = "llvm.load"(%2608) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2835 = "llvm.load"(%2609) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2836 = "llvm.load"(%2610) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2610) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2609) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2608) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2607) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2606) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2611) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2612) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2613) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2614) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2615) : (!llvm.ptr) -> ()
  "llvm.call"(%2611, %2612, %2613, %2614, %2615, %2832, %2833, %2834, %2835, %2836) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2837 = "llvm.load"(%2611) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2838 = "llvm.load"(%2612) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2839 = "llvm.load"(%2613) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2840 = "llvm.load"(%2614) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2841 = "llvm.load"(%2615) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2615) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2614) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2613) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2612) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2611) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2616) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2617) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2618) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2619) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2620) : (!llvm.ptr) -> ()
  "llvm.call"(%2616, %2617, %2618, %2619, %2620, %2822, %2823, %2824, %2825, %2826, %2837, %2838, %2839, %2840, %2841) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2842 = "llvm.load"(%2616) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2843 = "llvm.load"(%2617) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2844 = "llvm.load"(%2618) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2845 = "llvm.load"(%2619) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2846 = "llvm.load"(%2620) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2620) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2619) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2618) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2617) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2616) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2621) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2622) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2623) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2624) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2625) : (!llvm.ptr) -> ()
  "llvm.call"(%2621, %2622, %2623, %2624, %2625, %2827, %2828, %2829, %2830, %2831, %2842, %2843, %2844, %2845, %2846) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2847 = "llvm.load"(%2621) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2848 = "llvm.load"(%2622) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2849 = "llvm.load"(%2623) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2850 = "llvm.load"(%2624) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2851 = "llvm.load"(%2625) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2625) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2624) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2623) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2622) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2621) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2626) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2627) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2628) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2629) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2630) : (!llvm.ptr) -> ()
  "llvm.call"(%2626, %2627, %2628, %2629, %2630, %2847, %2848, %2849, %2850, %2851) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2852 = "llvm.load"(%2626) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2853 = "llvm.load"(%2627) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2854 = "llvm.load"(%2628) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2855 = "llvm.load"(%2629) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2856 = "llvm.load"(%2630) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2630) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2629) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2628) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2627) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2626) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2631) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2632) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2633) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2634) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2635) : (!llvm.ptr) -> ()
  "llvm.call"(%2631, %2632, %2633, %2634, %2635, %2842, %2843, %2844, %2845, %2846, %2852, %2853, %2854, %2855, %2856) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2857 = "llvm.load"(%2631) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2858 = "llvm.load"(%2632) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2859 = "llvm.load"(%2633) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2860 = "llvm.load"(%2634) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2861 = "llvm.load"(%2635) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2635) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2634) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2633) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2632) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2631) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2636) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2637) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2638) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2639) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2640) : (!llvm.ptr) -> ()
  "llvm.call"(%2636, %2637, %2638, %2639, %2640, %2857, %2858, %2859, %2860, %2861) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2862 = "llvm.load"(%2636) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2863 = "llvm.load"(%2637) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2864 = "llvm.load"(%2638) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2865 = "llvm.load"(%2639) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2866 = "llvm.load"(%2640) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2640) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2639) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2638) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2637) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2636) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2641) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2642) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2643) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2644) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2645) : (!llvm.ptr) -> ()
  "llvm.call"(%2641, %2642, %2643, %2644, %2645, %2862, %2863, %2864, %2865, %2866) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2867 = "llvm.load"(%2641) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2868 = "llvm.load"(%2642) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2869 = "llvm.load"(%2643) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2870 = "llvm.load"(%2644) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2871 = "llvm.load"(%2645) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2645) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2644) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2643) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2642) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2641) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2641) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2642) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2643) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2644) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2645) : (!llvm.ptr) -> ()
  "llvm.call"(%2641, %2642, %2643, %2644, %2645, %2867, %2868, %2869, %2870, %2871) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2872 = "llvm.load"(%2641) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2873 = "llvm.load"(%2642) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2874 = "llvm.load"(%2643) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2875 = "llvm.load"(%2644) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2876 = "llvm.load"(%2645) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2645) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2644) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2643) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2642) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2641) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2641) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2642) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2643) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2644) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2645) : (!llvm.ptr) -> ()
  "llvm.call"(%2641, %2642, %2643, %2644, %2645, %2872, %2873, %2874, %2875, %2876) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2877 = "llvm.load"(%2641) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2878 = "llvm.load"(%2642) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2879 = "llvm.load"(%2643) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2880 = "llvm.load"(%2644) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2881 = "llvm.load"(%2645) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2645) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2644) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2643) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2642) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2641) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2641) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2642) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2643) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2644) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2645) : (!llvm.ptr) -> ()
  "llvm.call"(%2641, %2642, %2643, %2644, %2645, %2877, %2878, %2879, %2880, %2881) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2882 = "llvm.load"(%2641) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2883 = "llvm.load"(%2642) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2884 = "llvm.load"(%2643) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2885 = "llvm.load"(%2644) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2886 = "llvm.load"(%2645) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2645) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2644) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2643) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2642) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2641) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2646) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2647) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2648) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2649) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2650) : (!llvm.ptr) -> ()
  "llvm.call"(%2646, %2647, %2648, %2649, %2650, %2882, %2883, %2884, %2885, %2886, %2857, %2858, %2859, %2860, %2861) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2887 = "llvm.load"(%2646) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2888 = "llvm.load"(%2647) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2889 = "llvm.load"(%2648) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2890 = "llvm.load"(%2649) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2891 = "llvm.load"(%2650) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2650) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2649) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2648) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2647) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2646) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2651) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2652) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2653) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2654) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2655) : (!llvm.ptr) -> ()
  "llvm.call"(%2651, %2652, %2653, %2654, %2655, %2887, %2888, %2889, %2890, %2891) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2892 = "llvm.load"(%2651) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2893 = "llvm.load"(%2652) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2894 = "llvm.load"(%2653) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2895 = "llvm.load"(%2654) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2896 = "llvm.load"(%2655) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2655) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2654) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2653) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2652) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2651) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2656) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2657) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2658) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2659) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2660) : (!llvm.ptr) -> ()
  "llvm.call"(%2656, %2657, %2658, %2659, %2660, %2892, %2893, %2894, %2895, %2896) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2897 = "llvm.load"(%2656) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2898 = "llvm.load"(%2657) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2899 = "llvm.load"(%2658) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2900 = "llvm.load"(%2659) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2901 = "llvm.load"(%2660) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2660) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2659) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2658) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2657) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2656) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2656) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2657) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2658) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2659) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2660) : (!llvm.ptr) -> ()
  "llvm.call"(%2656, %2657, %2658, %2659, %2660, %2897, %2898, %2899, %2900, %2901) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2902 = "llvm.load"(%2656) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2903 = "llvm.load"(%2657) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2904 = "llvm.load"(%2658) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2905 = "llvm.load"(%2659) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2906 = "llvm.load"(%2660) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2660) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2659) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2658) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2657) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2656) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2656) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2657) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2658) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2659) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2660) : (!llvm.ptr) -> ()
  "llvm.call"(%2656, %2657, %2658, %2659, %2660, %2902, %2903, %2904, %2905, %2906) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2907 = "llvm.load"(%2656) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2908 = "llvm.load"(%2657) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2909 = "llvm.load"(%2658) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2910 = "llvm.load"(%2659) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2911 = "llvm.load"(%2660) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2660) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2659) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2658) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2657) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2656) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2656) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2657) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2658) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2659) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2660) : (!llvm.ptr) -> ()
  "llvm.call"(%2656, %2657, %2658, %2659, %2660, %2907, %2908, %2909, %2910, %2911) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2912 = "llvm.load"(%2656) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2913 = "llvm.load"(%2657) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2914 = "llvm.load"(%2658) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2915 = "llvm.load"(%2659) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2916 = "llvm.load"(%2660) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2660) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2659) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2658) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2657) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2656) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2656) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2657) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2658) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2659) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2660) : (!llvm.ptr) -> ()
  "llvm.call"(%2656, %2657, %2658, %2659, %2660, %2912, %2913, %2914, %2915, %2916) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2917 = "llvm.load"(%2656) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2918 = "llvm.load"(%2657) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2919 = "llvm.load"(%2658) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2920 = "llvm.load"(%2659) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2921 = "llvm.load"(%2660) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2660) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2659) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2658) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2657) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2656) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2656) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2657) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2658) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2659) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2660) : (!llvm.ptr) -> ()
  "llvm.call"(%2656, %2657, %2658, %2659, %2660, %2917, %2918, %2919, %2920, %2921) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2922 = "llvm.load"(%2656) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2923 = "llvm.load"(%2657) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2924 = "llvm.load"(%2658) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2925 = "llvm.load"(%2659) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2926 = "llvm.load"(%2660) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2660) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2659) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2658) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2657) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2656) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2656) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2657) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2658) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2659) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2660) : (!llvm.ptr) -> ()
  "llvm.call"(%2656, %2657, %2658, %2659, %2660, %2922, %2923, %2924, %2925, %2926) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2927 = "llvm.load"(%2656) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2928 = "llvm.load"(%2657) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2929 = "llvm.load"(%2658) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2930 = "llvm.load"(%2659) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2931 = "llvm.load"(%2660) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2660) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2659) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2658) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2657) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2656) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2656) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2657) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2658) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2659) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2660) : (!llvm.ptr) -> ()
  "llvm.call"(%2656, %2657, %2658, %2659, %2660, %2927, %2928, %2929, %2930, %2931) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2932 = "llvm.load"(%2656) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2933 = "llvm.load"(%2657) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2934 = "llvm.load"(%2658) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2935 = "llvm.load"(%2659) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2936 = "llvm.load"(%2660) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2660) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2659) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2658) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2657) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2656) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2656) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2657) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2658) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2659) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2660) : (!llvm.ptr) -> ()
  "llvm.call"(%2656, %2657, %2658, %2659, %2660, %2932, %2933, %2934, %2935, %2936) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2937 = "llvm.load"(%2656) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2938 = "llvm.load"(%2657) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2939 = "llvm.load"(%2658) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2940 = "llvm.load"(%2659) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2941 = "llvm.load"(%2660) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2660) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2659) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2658) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2657) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2656) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2661) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2662) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2663) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2664) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2665) : (!llvm.ptr) -> ()
  "llvm.call"(%2661, %2662, %2663, %2664, %2665, %2937, %2938, %2939, %2940, %2941, %2887, %2888, %2889, %2890, %2891) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2942 = "llvm.load"(%2661) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2943 = "llvm.load"(%2662) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2944 = "llvm.load"(%2663) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2945 = "llvm.load"(%2664) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2946 = "llvm.load"(%2665) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2665) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2664) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2663) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2662) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2661) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2666) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2667) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2668) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2669) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2670) : (!llvm.ptr) -> ()
  "llvm.call"(%2666, %2667, %2668, %2669, %2670, %2942, %2943, %2944, %2945, %2946) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2947 = "llvm.load"(%2666) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2948 = "llvm.load"(%2667) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2949 = "llvm.load"(%2668) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2950 = "llvm.load"(%2669) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2951 = "llvm.load"(%2670) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2670) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2669) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2668) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2667) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2666) : (!llvm.ptr) -> ()
  "llvm.br"(%2582, %2951, %2950, %2949, %2948, %2947)[^bb3] : (i32, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb2:  // pred: ^bb3
  "llvm.intr.lifetime.start"(%2676) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2677) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2678) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2679) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2680) : (!llvm.ptr) -> ()
  "llvm.call"(%2676, %2677, %2678, %2679, %2680, %3023, %3024, %3025, %3026, %3027, %2942, %2943, %2944, %2945, %2946) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2952 = "llvm.load"(%2676) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2953 = "llvm.load"(%2677) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2954 = "llvm.load"(%2678) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2955 = "llvm.load"(%2679) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2956 = "llvm.load"(%2680) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2680) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2679) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2678) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2677) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2676) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2681) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2682) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2683) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2684) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2685) : (!llvm.ptr) -> ()
  "llvm.call"(%2681, %2682, %2683, %2684, %2685, %2952, %2953, %2954, %2955, %2956) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2957 = "llvm.load"(%2681) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2958 = "llvm.load"(%2682) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2959 = "llvm.load"(%2683) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2960 = "llvm.load"(%2684) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2961 = "llvm.load"(%2685) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2685) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2684) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2683) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2682) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2681) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2686) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2687) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2688) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2689) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2690) : (!llvm.ptr) -> ()
  "llvm.call"(%2686, %2687, %2688, %2689, %2690, %2957, %2958, %2959, %2960, %2961) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2962 = "llvm.load"(%2686) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2963 = "llvm.load"(%2687) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2964 = "llvm.load"(%2688) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2965 = "llvm.load"(%2689) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2966 = "llvm.load"(%2690) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2690) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2689) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2688) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2687) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2686) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2686) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2687) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2688) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2689) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2690) : (!llvm.ptr) -> ()
  "llvm.call"(%2686, %2687, %2688, %2689, %2690, %2962, %2963, %2964, %2965, %2966) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2967 = "llvm.load"(%2686) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2968 = "llvm.load"(%2687) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2969 = "llvm.load"(%2688) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2970 = "llvm.load"(%2689) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2971 = "llvm.load"(%2690) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2690) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2689) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2688) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2687) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2686) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2686) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2687) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2688) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2689) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2690) : (!llvm.ptr) -> ()
  "llvm.call"(%2686, %2687, %2688, %2689, %2690, %2967, %2968, %2969, %2970, %2971) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2972 = "llvm.load"(%2686) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2973 = "llvm.load"(%2687) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2974 = "llvm.load"(%2688) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2975 = "llvm.load"(%2689) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2976 = "llvm.load"(%2690) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2690) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2689) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2688) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2687) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2686) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2686) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2687) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2688) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2689) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2690) : (!llvm.ptr) -> ()
  "llvm.call"(%2686, %2687, %2688, %2689, %2690, %2972, %2973, %2974, %2975, %2976) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2977 = "llvm.load"(%2686) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2978 = "llvm.load"(%2687) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2979 = "llvm.load"(%2688) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2980 = "llvm.load"(%2689) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2981 = "llvm.load"(%2690) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2690) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2689) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2688) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2687) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2686) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2686) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2687) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2688) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2689) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2690) : (!llvm.ptr) -> ()
  "llvm.call"(%2686, %2687, %2688, %2689, %2690, %2977, %2978, %2979, %2980, %2981) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2982 = "llvm.load"(%2686) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2983 = "llvm.load"(%2687) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2984 = "llvm.load"(%2688) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2985 = "llvm.load"(%2689) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2986 = "llvm.load"(%2690) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2690) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2689) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2688) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2687) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2686) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2686) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2687) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2688) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2689) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2690) : (!llvm.ptr) -> ()
  "llvm.call"(%2686, %2687, %2688, %2689, %2690, %2982, %2983, %2984, %2985, %2986) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2987 = "llvm.load"(%2686) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2988 = "llvm.load"(%2687) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2989 = "llvm.load"(%2688) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2990 = "llvm.load"(%2689) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2991 = "llvm.load"(%2690) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2690) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2689) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2688) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2687) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2686) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2686) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2687) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2688) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2689) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2690) : (!llvm.ptr) -> ()
  "llvm.call"(%2686, %2687, %2688, %2689, %2690, %2987, %2988, %2989, %2990, %2991) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2992 = "llvm.load"(%2686) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2993 = "llvm.load"(%2687) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2994 = "llvm.load"(%2688) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2995 = "llvm.load"(%2689) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2996 = "llvm.load"(%2690) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2690) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2689) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2688) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2687) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2686) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2686) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2687) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2688) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2689) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2690) : (!llvm.ptr) -> ()
  "llvm.call"(%2686, %2687, %2688, %2689, %2690, %2992, %2993, %2994, %2995, %2996) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2997 = "llvm.load"(%2686) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2998 = "llvm.load"(%2687) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2999 = "llvm.load"(%2688) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3000 = "llvm.load"(%2689) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3001 = "llvm.load"(%2690) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2690) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2689) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2688) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2687) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2686) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2686) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2687) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2688) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2689) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2690) : (!llvm.ptr) -> ()
  "llvm.call"(%2686, %2687, %2688, %2689, %2690, %2997, %2998, %2999, %3000, %3001) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %3002 = "llvm.load"(%2686) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3003 = "llvm.load"(%2687) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3004 = "llvm.load"(%2688) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3005 = "llvm.load"(%2689) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3006 = "llvm.load"(%2690) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2690) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2689) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2688) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2687) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2686) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2691) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2692) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2693) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2694) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2695) : (!llvm.ptr) -> ()
  "llvm.call"(%2691, %2692, %2693, %2694, %2695, %3002, %3003, %3004, %3005, %3006, %2887, %2888, %2889, %2890, %2891) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %3007 = "llvm.load"(%2691) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3008 = "llvm.load"(%2692) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3009 = "llvm.load"(%2693) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3010 = "llvm.load"(%2694) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3011 = "llvm.load"(%2695) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2695) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2694) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2693) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2692) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2691) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2696) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2697) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2698) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2699) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2700) : (!llvm.ptr) -> ()
  "llvm.call"(%2696, %2697, %2698, %2699, %2700, %3007, %3008, %3009, %3010, %3011) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %3012 = "llvm.load"(%2696) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3013 = "llvm.load"(%2697) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3014 = "llvm.load"(%2698) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3015 = "llvm.load"(%2699) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3016 = "llvm.load"(%2700) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2700) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2699) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2698) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2697) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2696) : (!llvm.ptr) -> ()
  "llvm.br"(%2582, %3016, %3015, %3014, %3013, %3012)[^bb5] : (i32, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb3(%3017: i32, %3018: vector<4xi64>, %3019: vector<4xi64>, %3020: vector<4xi64>, %3021: vector<4xi64>, %3022: vector<4xi64>):  // 2 preds: ^bb1, ^bb3
  "llvm.intr.lifetime.start"(%2671) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2672) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2673) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2674) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2675) : (!llvm.ptr) -> ()
  "llvm.call"(%2671, %2672, %2673, %2674, %2675, %3022, %3021, %3020, %3019, %3018) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %3023 = "llvm.load"(%2671) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3024 = "llvm.load"(%2672) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3025 = "llvm.load"(%2673) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3026 = "llvm.load"(%2674) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3027 = "llvm.load"(%2675) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2675) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2674) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2673) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2672) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2671) : (!llvm.ptr) -> ()
  %3028 = "llvm.add"(%3017, %2582) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %3029 = "llvm.icmp"(%3028, %2590) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%3029, %3028, %3027, %3026, %3025, %3024, %3023)[^bb2, ^bb3] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 6>}> : (i1, i32, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb4:  // pred: ^bb5
  "llvm.intr.lifetime.start"(%2706) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2707) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2708) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2709) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2710) : (!llvm.ptr) -> ()
  "llvm.call"(%2706, %2707, %2708, %2709, %2710, %3046, %3047, %3048, %3049, %3050, %3007, %3008, %3009, %3010, %3011) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %3030 = "llvm.load"(%2706) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3031 = "llvm.load"(%2707) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3032 = "llvm.load"(%2708) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3033 = "llvm.load"(%2709) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3034 = "llvm.load"(%2710) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2710) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2709) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2708) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2707) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2706) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2711) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2712) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2713) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2714) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2715) : (!llvm.ptr) -> ()
  "llvm.call"(%2711, %2712, %2713, %2714, %2715, %3030, %3031, %3032, %3033, %3034) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %3035 = "llvm.load"(%2711) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3036 = "llvm.load"(%2712) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3037 = "llvm.load"(%2713) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3038 = "llvm.load"(%2714) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3039 = "llvm.load"(%2715) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2715) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2714) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2713) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2712) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2711) : (!llvm.ptr) -> ()
  "llvm.br"(%2582, %3039, %3038, %3037, %3036, %3035)[^bb7] : (i32, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb5(%3040: i32, %3041: vector<4xi64>, %3042: vector<4xi64>, %3043: vector<4xi64>, %3044: vector<4xi64>, %3045: vector<4xi64>):  // 2 preds: ^bb2, ^bb5
  "llvm.intr.lifetime.start"(%2701) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2702) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2703) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2704) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2705) : (!llvm.ptr) -> ()
  "llvm.call"(%2701, %2702, %2703, %2704, %2705, %3045, %3044, %3043, %3042, %3041) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %3046 = "llvm.load"(%2701) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3047 = "llvm.load"(%2702) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3048 = "llvm.load"(%2703) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3049 = "llvm.load"(%2704) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3050 = "llvm.load"(%2705) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2705) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2704) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2703) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2702) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2701) : (!llvm.ptr) -> ()
  %3051 = "llvm.add"(%3040, %2582) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %3052 = "llvm.icmp"(%3051, %2591) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%3052, %3051, %3050, %3049, %3048, %3047, %3046)[^bb4, ^bb5] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 6>}> : (i1, i32, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb6:  // pred: ^bb7
  "llvm.intr.lifetime.start"(%2721) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2722) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2723) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2724) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2725) : (!llvm.ptr) -> ()
  "llvm.call"(%2721, %2722, %2723, %2724, %2725, %3069, %3070, %3071, %3072, %3073, %3030, %3031, %3032, %3033, %3034) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %3053 = "llvm.load"(%2721) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3054 = "llvm.load"(%2722) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3055 = "llvm.load"(%2723) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3056 = "llvm.load"(%2724) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3057 = "llvm.load"(%2725) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2725) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2724) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2723) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2722) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2721) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2726) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2727) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2728) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2729) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2730) : (!llvm.ptr) -> ()
  "llvm.call"(%2726, %2727, %2728, %2729, %2730, %3053, %3054, %3055, %3056, %3057) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %3058 = "llvm.load"(%2726) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3059 = "llvm.load"(%2727) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3060 = "llvm.load"(%2728) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3061 = "llvm.load"(%2729) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3062 = "llvm.load"(%2730) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2730) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2729) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2728) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2727) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2726) : (!llvm.ptr) -> ()
  "llvm.br"(%2582, %3062, %3061, %3060, %3059, %3058)[^bb9] : (i32, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb7(%3063: i32, %3064: vector<4xi64>, %3065: vector<4xi64>, %3066: vector<4xi64>, %3067: vector<4xi64>, %3068: vector<4xi64>):  // 2 preds: ^bb4, ^bb7
  "llvm.intr.lifetime.start"(%2716) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2717) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2718) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2719) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2720) : (!llvm.ptr) -> ()
  "llvm.call"(%2716, %2717, %2718, %2719, %2720, %3068, %3067, %3066, %3065, %3064) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %3069 = "llvm.load"(%2716) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3070 = "llvm.load"(%2717) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3071 = "llvm.load"(%2718) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3072 = "llvm.load"(%2719) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3073 = "llvm.load"(%2720) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2720) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2719) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2718) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2717) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2716) : (!llvm.ptr) -> ()
  %3074 = "llvm.add"(%3063, %2582) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %3075 = "llvm.icmp"(%3074, %2592) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%3075, %3074, %3073, %3072, %3071, %3070, %3069)[^bb6, ^bb7] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 6>}> : (i1, i32, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb8:  // pred: ^bb9
  "llvm.intr.lifetime.start"(%2736) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2737) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2738) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2739) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2740) : (!llvm.ptr) -> ()
  "llvm.call"(%2736, %2737, %2738, %2739, %2740, %3137, %3138, %3139, %3140, %3141, %3007, %3008, %3009, %3010, %3011) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %3076 = "llvm.load"(%2736) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3077 = "llvm.load"(%2737) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3078 = "llvm.load"(%2738) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3079 = "llvm.load"(%2739) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3080 = "llvm.load"(%2740) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2740) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2739) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2738) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2737) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2736) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2741) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2742) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2743) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2744) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2745) : (!llvm.ptr) -> ()
  "llvm.call"(%2741, %2742, %2743, %2744, %2745, %3076, %3077, %3078, %3079, %3080) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %3081 = "llvm.load"(%2741) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3082 = "llvm.load"(%2742) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3083 = "llvm.load"(%2743) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3084 = "llvm.load"(%2744) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3085 = "llvm.load"(%2745) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2745) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2744) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2743) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2742) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2741) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2746) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2747) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2748) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2749) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2750) : (!llvm.ptr) -> ()
  "llvm.call"(%2746, %2747, %2748, %2749, %2750, %3081, %3082, %3083, %3084, %3085) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %3086 = "llvm.load"(%2746) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3087 = "llvm.load"(%2747) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3088 = "llvm.load"(%2748) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3089 = "llvm.load"(%2749) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3090 = "llvm.load"(%2750) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2750) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2749) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2748) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2747) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2746) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2751) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2752) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2753) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2754) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2755) : (!llvm.ptr) -> ()
  "llvm.call"(%2751, %2752, %2753, %2754, %2755, %3086, %3087, %3088, %3089, %3090, %2822, %2823, %2824, %2825, %2826) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %3091 = "llvm.load"(%2751) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3092 = "llvm.load"(%2752) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3093 = "llvm.load"(%2753) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3094 = "llvm.load"(%2754) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3095 = "llvm.load"(%2755) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2755) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2754) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2753) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2752) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2751) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2756) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2757) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2758) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2759) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2760) : (!llvm.ptr) -> ()
  "llvm.call"(%2756, %2757, %2758, %2759, %2760, %3091, %3092, %3093, %3094, %3095) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %3096 = "llvm.load"(%2756) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3097 = "llvm.load"(%2757) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3098 = "llvm.load"(%2758) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3099 = "llvm.load"(%2759) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3100 = "llvm.load"(%2760) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2760) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2759) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2758) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2757) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2756) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2761) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2762) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2763) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2764) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2765) : (!llvm.ptr) -> ()
  "llvm.call"(%2761, %2762, %2763, %2764, %2765, %3096, %3097, %3098, %3099, %3100) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %3101 = "llvm.load"(%2761) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3102 = "llvm.load"(%2762) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3103 = "llvm.load"(%2763) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3104 = "llvm.load"(%2764) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3105 = "llvm.load"(%2765) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2765) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2764) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2763) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2762) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2761) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2766) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2767) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2768) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2769) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2770) : (!llvm.ptr) -> ()
  "llvm.call"(%2766, %2767, %2768, %2769, %2770, %3101, %3102, %3103, %3104, %3105) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %3106 = "llvm.load"(%2766) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3107 = "llvm.load"(%2767) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3108 = "llvm.load"(%2768) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3109 = "llvm.load"(%2769) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3110 = "llvm.load"(%2770) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2770) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2769) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2768) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2767) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2766) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2771) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2772) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2773) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2774) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2775) : (!llvm.ptr) -> ()
  "llvm.call"(%2771, %2772, %2773, %2774, %2775, %2822, %2823, %2824, %2825, %2826) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %3111 = "llvm.load"(%2771) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3112 = "llvm.load"(%2772) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3113 = "llvm.load"(%2773) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3114 = "llvm.load"(%2774) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3115 = "llvm.load"(%2775) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2775) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2774) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2773) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2772) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2771) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2776) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2777) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2778) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2779) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2780) : (!llvm.ptr) -> ()
  "llvm.call"(%2776, %2777, %2778, %2779, %2780, %3111, %3112, %3113, %3114, %3115, %2822, %2823, %2824, %2825, %2826) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %3116 = "llvm.load"(%2776) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3117 = "llvm.load"(%2777) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3118 = "llvm.load"(%2778) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3119 = "llvm.load"(%2779) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3120 = "llvm.load"(%2780) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2780) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2779) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2778) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2777) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2776) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2781) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2782) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2783) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2784) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2785) : (!llvm.ptr) -> ()
  "llvm.call"(%2781, %2782, %2783, %2784, %2785, %3106, %3107, %3108, %3109, %3110, %3116, %3117, %3118, %3119, %3120) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %3121 = "llvm.load"(%2781) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3122 = "llvm.load"(%2782) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3123 = "llvm.load"(%2783) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3124 = "llvm.load"(%2784) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3125 = "llvm.load"(%2785) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2785) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2784) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2783) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2782) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2781) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2786) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2787) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2788) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2789) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2790) : (!llvm.ptr) -> ()
  "llvm.call"(%2786, %2787, %2788, %2789, %2790, %2791, %2793, %2795, %2797, %2799, %3121, %3122, %3123, %3124, %3125) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %3126 = "llvm.load"(%2786) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3127 = "llvm.load"(%2787) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3128 = "llvm.load"(%2788) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3129 = "llvm.load"(%2789) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3130 = "llvm.load"(%2790) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2790) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2789) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2788) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2787) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2786) : (!llvm.ptr) -> ()
  "llvm.br"(%3130, %3129, %3128, %3127, %3126)[^bb10] : (vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb9(%3131: i32, %3132: vector<4xi64>, %3133: vector<4xi64>, %3134: vector<4xi64>, %3135: vector<4xi64>, %3136: vector<4xi64>):  // 2 preds: ^bb6, ^bb9
  "llvm.intr.lifetime.start"(%2731) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2732) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2733) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2734) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2735) : (!llvm.ptr) -> ()
  "llvm.call"(%2731, %2732, %2733, %2734, %2735, %3136, %3135, %3134, %3133, %3132) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %3137 = "llvm.load"(%2731) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3138 = "llvm.load"(%2732) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3139 = "llvm.load"(%2733) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3140 = "llvm.load"(%2734) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3141 = "llvm.load"(%2735) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2735) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2734) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2733) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2732) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2731) : (!llvm.ptr) -> ()
  %3142 = "llvm.add"(%3131, %2582) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %3143 = "llvm.icmp"(%3142, %2591) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%3143, %3142, %3141, %3140, %3139, %3138, %3137)[^bb8, ^bb9] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 6>}> : (i1, i32, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb10(%3144: vector<4xi64>, %3145: vector<4xi64>, %3146: vector<4xi64>, %3147: vector<4xi64>, %3148: vector<4xi64>):  // 2 preds: ^bb0, ^bb8
  "llvm.call"(%arg202, %3148, %3147, %3146, %3145, %3144, %2589) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_lane_canon, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 7, 0>}> : (!llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, i32) -> ()
  "llvm.call"(%arg203, %3148, %3147, %3146, %3145, %3144, %2582) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_lane_canon, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 7, 0>}> : (!llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, i32) -> ()
  "llvm.intr.lifetime.end"(%2600) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2594) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2593) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
  with @fd_r52x5_inv_propose := fd_r52x5_inv_propose,
    @fd_r52x5_limbs_is_one := fd_r52x5_limbs_is_one,
    @fd_r52x5_quad_lane_canon := fd_r52x5_quad_lane_canon, @fd_r52x5_quad_mul := fd_r52x5_quad_mul,
    @fd_r52x5_quad_sqr := fd_r52x5_quad_sqr, @wl_permute := wl_permute

end

end MLIR.Firedancer.Crc.Ed25519.Avx512
