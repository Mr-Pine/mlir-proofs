module

-- crc/out/mlirproofs/regions/verify/fd_r52x5_quad_ge_add_table.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_add_nc
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_mul
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_negate_lazy
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_reduce
public import Firedancer.Crc.Verify.Mlir.wl_permute

meta import MLIR.Semantics.Func
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_add_nc
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_mul
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_negate_lazy
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_reduce
meta import Firedancer.Crc.Verify.Mlir.wl_permute

namespace MLIR.Firedancer.Crc.Verify

@[expose] public section

mlir_def fd_r52x5_quad_ge_add_table :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr, ptr, ptr, ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "256"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], sym_name = "fd_r52x5_quad_ge_add_table", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg186: !llvm.ptr, %arg187: !llvm.ptr, %arg188: !llvm.ptr, %arg189: !llvm.ptr, %arg190: !llvm.ptr, %arg191: vector<4xi64>, %arg192: vector<4xi64>, %arg193: vector<4xi64>, %arg194: vector<4xi64>, %arg195: vector<4xi64>, %arg196: vector<4xi64>, %arg197: vector<4xi64>, %arg198: vector<4xi64>, %arg199: vector<4xi64>, %arg200: vector<4xi64>):
  %2737 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %2738 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %2739 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %2740 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %2741 = "llvm.alloca"(%2737) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2742 = "llvm.alloca"(%2737) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2743 = "llvm.alloca"(%2737) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2744 = "llvm.alloca"(%2737) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2745 = "llvm.alloca"(%2737) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2746 = "llvm.alloca"(%2737) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2747 = "llvm.alloca"(%2737) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2748 = "llvm.alloca"(%2737) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2749 = "llvm.alloca"(%2737) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2750 = "llvm.alloca"(%2737) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2751 = "llvm.alloca"(%2737) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2752 = "llvm.alloca"(%2737) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2753 = "llvm.alloca"(%2737) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2754 = "llvm.alloca"(%2737) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2755 = "llvm.alloca"(%2737) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2756 = "llvm.alloca"(%2737) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2757 = "llvm.alloca"(%2737) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2758 = "llvm.alloca"(%2737) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2759 = "llvm.alloca"(%2737) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2760 = "llvm.alloca"(%2737) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2761 = "llvm.alloca"(%2737) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2762 = "llvm.alloca"(%2737) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2763 = "llvm.alloca"(%2737) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2764 = "llvm.alloca"(%2737) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2765 = "llvm.alloca"(%2737) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2766 = "llvm.alloca"(%2737) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2767 = "llvm.alloca"(%2737) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2768 = "llvm.alloca"(%2737) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2769 = "llvm.alloca"(%2737) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2770 = "llvm.alloca"(%2737) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2771 = "llvm.alloca"(%2737) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2772 = "llvm.alloca"(%2737) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2773 = "llvm.alloca"(%2737) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2774 = "llvm.alloca"(%2737) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2775 = "llvm.alloca"(%2737) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2776 = "llvm.alloca"(%2737) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2777 = "llvm.alloca"(%2737) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2778 = "llvm.alloca"(%2737) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2779 = "llvm.alloca"(%2737) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2780 = "llvm.alloca"(%2737) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %2781 = "llvm.call"(%arg191, %2737, %2738, %2739, %2740) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2782 = "llvm.call"(%arg192, %2737, %2738, %2739, %2740) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2783 = "llvm.call"(%arg193, %2737, %2738, %2739, %2740) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2784 = "llvm.call"(%arg194, %2737, %2738, %2739, %2740) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2785 = "llvm.call"(%arg195, %2737, %2738, %2739, %2740) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%2741) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2742) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2743) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2744) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2745) : (!llvm.ptr) -> ()
  "llvm.call"(%2741, %2742, %2743, %2744, %2745, %arg191, %arg192, %arg193, %arg194, %arg195) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_negate_lazy, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2786 = "llvm.load"(%2741) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2787 = "llvm.load"(%2742) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2788 = "llvm.load"(%2743) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2789 = "llvm.load"(%2744) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2790 = "llvm.load"(%2745) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2745) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2744) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2743) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2742) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2741) : (!llvm.ptr) -> ()
  %2791 = "llvm.shufflevector"(%2786, %arg191) <{mask = array<i32: 0, 5, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2792 = "llvm.shufflevector"(%2787, %arg192) <{mask = array<i32: 0, 5, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2793 = "llvm.shufflevector"(%2788, %arg193) <{mask = array<i32: 0, 5, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2794 = "llvm.shufflevector"(%2789, %arg194) <{mask = array<i32: 0, 5, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2795 = "llvm.shufflevector"(%2790, %arg195) <{mask = array<i32: 0, 5, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%2746) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2747) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2748) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2749) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2750) : (!llvm.ptr) -> ()
  "llvm.call"(%2746, %2747, %2748, %2749, %2750, %2781, %2782, %2783, %2784, %2785, %2791, %2792, %2793, %2794, %2795) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_add_nc, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2796 = "llvm.load"(%2746) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2797 = "llvm.load"(%2747) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2798 = "llvm.load"(%2748) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2799 = "llvm.load"(%2749) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2800 = "llvm.load"(%2750) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
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
  "llvm.call"(%2751, %2752, %2753, %2754, %2755, %2796, %2797, %2798, %2799, %2800) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_reduce, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2801 = "llvm.load"(%2751) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2802 = "llvm.load"(%2752) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2803 = "llvm.load"(%2753) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2804 = "llvm.load"(%2754) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2805 = "llvm.load"(%2755) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2755) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2754) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2753) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2752) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2751) : (!llvm.ptr) -> ()
  %2806 = "llvm.shufflevector"(%2801, %arg191) <{mask = array<i32: 0, 1, 6, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2807 = "llvm.shufflevector"(%2802, %arg192) <{mask = array<i32: 0, 1, 6, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2808 = "llvm.shufflevector"(%2803, %arg193) <{mask = array<i32: 0, 1, 6, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2809 = "llvm.shufflevector"(%2804, %arg194) <{mask = array<i32: 0, 1, 6, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2810 = "llvm.shufflevector"(%2805, %arg195) <{mask = array<i32: 0, 1, 6, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%2756) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2757) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2758) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2759) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2760) : (!llvm.ptr) -> ()
  "llvm.call"(%2756, %2757, %2758, %2759, %2760, %2806, %2807, %2808, %2809, %2810, %arg196, %arg197, %arg198, %arg199, %arg200) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2811 = "llvm.load"(%2756) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2812 = "llvm.load"(%2757) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2813 = "llvm.load"(%2758) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2814 = "llvm.load"(%2759) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2815 = "llvm.load"(%2760) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2760) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2759) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2758) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2757) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2756) : (!llvm.ptr) -> ()
  %2816 = "llvm.call"(%2811, %2738, %2737, %2739, %2740) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2817 = "llvm.call"(%2812, %2738, %2737, %2739, %2740) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2818 = "llvm.call"(%2813, %2738, %2737, %2739, %2740) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2819 = "llvm.call"(%2814, %2738, %2737, %2739, %2740) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2820 = "llvm.call"(%2815, %2738, %2737, %2739, %2740) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2821 = "llvm.call"(%2816, %2737, %2738, %2739, %2740) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2822 = "llvm.call"(%2817, %2737, %2738, %2739, %2740) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2823 = "llvm.call"(%2818, %2737, %2738, %2739, %2740) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2824 = "llvm.call"(%2819, %2737, %2738, %2739, %2740) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2825 = "llvm.call"(%2820, %2737, %2738, %2739, %2740) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%2761) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2762) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2763) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2764) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2765) : (!llvm.ptr) -> ()
  "llvm.call"(%2761, %2762, %2763, %2764, %2765, %2816, %2817, %2818, %2819, %2820) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_negate_lazy, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2826 = "llvm.load"(%2761) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2827 = "llvm.load"(%2762) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2828 = "llvm.load"(%2763) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2829 = "llvm.load"(%2764) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2830 = "llvm.load"(%2765) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2765) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2764) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2763) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2762) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2761) : (!llvm.ptr) -> ()
  %2831 = "llvm.shufflevector"(%2826, %2816) <{mask = array<i32: 0, 5, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2832 = "llvm.shufflevector"(%2827, %2817) <{mask = array<i32: 0, 5, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2833 = "llvm.shufflevector"(%2828, %2818) <{mask = array<i32: 0, 5, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2834 = "llvm.shufflevector"(%2829, %2819) <{mask = array<i32: 0, 5, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %2835 = "llvm.shufflevector"(%2830, %2820) <{mask = array<i32: 0, 5, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%2766) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2767) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2768) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2769) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2770) : (!llvm.ptr) -> ()
  "llvm.call"(%2766, %2767, %2768, %2769, %2770, %2821, %2822, %2823, %2824, %2825, %2831, %2832, %2833, %2834, %2835) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_add_nc, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2836 = "llvm.load"(%2766) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2837 = "llvm.load"(%2767) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2838 = "llvm.load"(%2768) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2839 = "llvm.load"(%2769) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2840 = "llvm.load"(%2770) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
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
  "llvm.call"(%2771, %2772, %2773, %2774, %2775, %2836, %2837, %2838, %2839, %2840) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_reduce, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2841 = "llvm.load"(%2771) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2842 = "llvm.load"(%2772) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2843 = "llvm.load"(%2773) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2844 = "llvm.load"(%2774) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2845 = "llvm.load"(%2775) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2775) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2774) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2773) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2772) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2771) : (!llvm.ptr) -> ()
  %2846 = "llvm.call"(%2841, %2738, %2739, %2739, %2738) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2847 = "llvm.call"(%2842, %2738, %2739, %2739, %2738) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2848 = "llvm.call"(%2843, %2738, %2739, %2739, %2738) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2849 = "llvm.call"(%2844, %2738, %2739, %2739, %2738) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2850 = "llvm.call"(%2845, %2738, %2739, %2739, %2738) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2851 = "llvm.call"(%2841, %2740, %2737, %2740, %2737) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2852 = "llvm.call"(%2842, %2740, %2737, %2740, %2737) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2853 = "llvm.call"(%2843, %2740, %2737, %2740, %2737) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2854 = "llvm.call"(%2844, %2740, %2737, %2740, %2737) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %2855 = "llvm.call"(%2845, %2740, %2737, %2740, %2737) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%2776) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2777) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2778) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2779) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2780) : (!llvm.ptr) -> ()
  "llvm.call"(%2776, %2777, %2778, %2779, %2780, %2846, %2847, %2848, %2849, %2850, %2851, %2852, %2853, %2854, %2855) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %2856 = "llvm.load"(%2776) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2857 = "llvm.load"(%2777) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2858 = "llvm.load"(%2778) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2859 = "llvm.load"(%2779) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %2860 = "llvm.load"(%2780) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%2780) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2779) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2778) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2777) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2776) : (!llvm.ptr) -> ()
  "llvm.store"(%2856, %arg186) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.store"(%2857, %arg187) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.store"(%2858, %arg188) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.store"(%2859, %arg189) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.store"(%2860, %arg190) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
  with @fd_r52x5_quad_add_nc := fd_r52x5_quad_add_nc, @fd_r52x5_quad_mul := fd_r52x5_quad_mul,
    @fd_r52x5_quad_negate_lazy := fd_r52x5_quad_negate_lazy,
    @fd_r52x5_quad_reduce := fd_r52x5_quad_reduce, @wl_permute := wl_permute

end

end MLIR.Firedancer.Crc.Verify
