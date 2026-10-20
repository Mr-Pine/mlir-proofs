module

-- crc/out/mlirproofs/regions/verify/fd_r52x5_quad_to_table.mlir

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

mlir_def fd_r52x5_quad_to_table :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr, ptr, ptr, ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "256"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], sym_name = "fd_r52x5_quad_to_table", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg124: !llvm.ptr, %arg125: !llvm.ptr, %arg126: !llvm.ptr, %arg127: !llvm.ptr, %arg128: !llvm.ptr, %arg129: vector<4xi64>, %arg130: vector<4xi64>, %arg131: vector<4xi64>, %arg132: vector<4xi64>, %arg133: vector<4xi64>):
  %628 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %629 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %630 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %631 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %632 = "llvm.mlir.constant"() <{value = dense<[1, 1, 2, 1859910466990425]> : vector<4xi64>}> : () -> vector<4xi64>
  %633 = "llvm.mlir.constant"() <{value = dense<[0, 0, 0, 932731440258426]> : vector<4xi64>}> : () -> vector<4xi64>
  %634 = "llvm.mlir.constant"() <{value = dense<[0, 0, 0, 1072319116312658]> : vector<4xi64>}> : () -> vector<4xi64>
  %635 = "llvm.mlir.constant"() <{value = dense<[0, 0, 0, 1815898335770999]> : vector<4xi64>}> : () -> vector<4xi64>
  %636 = "llvm.mlir.constant"() <{value = dense<[0, 0, 0, 633789495995903]> : vector<4xi64>}> : () -> vector<4xi64>
  %637 = "llvm.alloca"(%628) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %638 = "llvm.alloca"(%628) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %639 = "llvm.alloca"(%628) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %640 = "llvm.alloca"(%628) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %641 = "llvm.alloca"(%628) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %642 = "llvm.alloca"(%628) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %643 = "llvm.alloca"(%628) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %644 = "llvm.alloca"(%628) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %645 = "llvm.alloca"(%628) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %646 = "llvm.alloca"(%628) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %647 = "llvm.alloca"(%628) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %648 = "llvm.alloca"(%628) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %649 = "llvm.alloca"(%628) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %650 = "llvm.alloca"(%628) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %651 = "llvm.alloca"(%628) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %652 = "llvm.alloca"(%628) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %653 = "llvm.alloca"(%628) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %654 = "llvm.alloca"(%628) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %655 = "llvm.alloca"(%628) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %656 = "llvm.alloca"(%628) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %657 = "llvm.call"(%arg129, %628, %629, %630, %631) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %658 = "llvm.call"(%arg130, %628, %629, %630, %631) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %659 = "llvm.call"(%arg131, %628, %629, %630, %631) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %660 = "llvm.call"(%arg132, %628, %629, %630, %631) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %661 = "llvm.call"(%arg133, %628, %629, %630, %631) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%637) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%638) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%639) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%640) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%641) : (!llvm.ptr) -> ()
  "llvm.call"(%637, %638, %639, %640, %641, %arg129, %arg130, %arg131, %arg132, %arg133) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_negate_lazy, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %662 = "llvm.load"(%637) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %663 = "llvm.load"(%638) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %664 = "llvm.load"(%639) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %665 = "llvm.load"(%640) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %666 = "llvm.load"(%641) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%641) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%640) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%639) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%638) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%637) : (!llvm.ptr) -> ()
  %667 = "llvm.shufflevector"(%662, %arg129) <{mask = array<i32: 0, 5, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %668 = "llvm.shufflevector"(%663, %arg130) <{mask = array<i32: 0, 5, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %669 = "llvm.shufflevector"(%664, %arg131) <{mask = array<i32: 0, 5, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %670 = "llvm.shufflevector"(%665, %arg132) <{mask = array<i32: 0, 5, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %671 = "llvm.shufflevector"(%666, %arg133) <{mask = array<i32: 0, 5, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%642) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%643) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%644) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%645) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%646) : (!llvm.ptr) -> ()
  "llvm.call"(%642, %643, %644, %645, %646, %657, %658, %659, %660, %661, %667, %668, %669, %670, %671) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_add_nc, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %672 = "llvm.load"(%642) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %673 = "llvm.load"(%643) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %674 = "llvm.load"(%644) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %675 = "llvm.load"(%645) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %676 = "llvm.load"(%646) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%646) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%645) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%644) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%643) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%642) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%647) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%648) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%649) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%650) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%651) : (!llvm.ptr) -> ()
  "llvm.call"(%647, %648, %649, %650, %651, %672, %673, %674, %675, %676) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_reduce, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %677 = "llvm.load"(%647) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %678 = "llvm.load"(%648) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %679 = "llvm.load"(%649) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %680 = "llvm.load"(%650) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %681 = "llvm.load"(%651) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%651) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%650) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%649) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%648) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%647) : (!llvm.ptr) -> ()
  %682 = "llvm.shufflevector"(%677, %arg129) <{mask = array<i32: 0, 1, 6, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %683 = "llvm.shufflevector"(%678, %arg130) <{mask = array<i32: 0, 1, 6, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %684 = "llvm.shufflevector"(%679, %arg131) <{mask = array<i32: 0, 1, 6, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %685 = "llvm.shufflevector"(%680, %arg132) <{mask = array<i32: 0, 1, 6, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %686 = "llvm.shufflevector"(%681, %arg133) <{mask = array<i32: 0, 1, 6, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%652) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%653) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%654) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%655) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%656) : (!llvm.ptr) -> ()
  "llvm.call"(%652, %653, %654, %655, %656, %682, %683, %684, %685, %686, %632, %633, %634, %635, %636) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %687 = "llvm.load"(%652) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %688 = "llvm.load"(%653) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %689 = "llvm.load"(%654) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %690 = "llvm.load"(%655) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %691 = "llvm.load"(%656) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%656) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%655) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%654) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%653) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%652) : (!llvm.ptr) -> ()
  "llvm.store"(%687, %arg124) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.store"(%688, %arg125) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.store"(%689, %arg126) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.store"(%690, %arg127) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.store"(%691, %arg128) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
  with @fd_r52x5_quad_add_nc := fd_r52x5_quad_add_nc, @fd_r52x5_quad_mul := fd_r52x5_quad_mul,
    @fd_r52x5_quad_negate_lazy := fd_r52x5_quad_negate_lazy,
    @fd_r52x5_quad_reduce := fd_r52x5_quad_reduce, @wl_permute := wl_permute

end

end MLIR.Firedancer.Crc.Verify
