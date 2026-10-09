module

-- ~/fd-pr9879/build/llvm23-production/mlir_canonicalized/avx512/op/fd_f25519_mul.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.R52x5.Mlir.fd_f25519_fold_unsigned

meta import MLIR.Semantics.Func
meta import Firedancer.R52x5.Mlir.fd_f25519_fold_unsigned

namespace MLIR.Firedancer.R52x5

@[expose] public section

mlir_def fd_f25519_mul :=
#tbaa_root = #llvm.tbaa_root<id = "Simple C/C++ TBAA">
#tbaa_type_desc = #llvm.tbaa_type_desc<id = "omnipotent char", members = {<#tbaa_root, 0>}>
#tbaa_tag = #llvm.tbaa_tag<base_type = #tbaa_type_desc, access_type = #tbaa_type_desc, offset = 0>
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nofree, llvm.noundef, llvm.returned, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<ptr (ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], res_attrs = [{llvm.noundef}], sym_name = "fd_f25519_mul", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg151: !llvm.ptr, %arg152: !llvm.ptr, %arg153: !llvm.ptr):
  %4604 = "llvm.mlir.constant"() <{value = dense<18> : vector<8xi64>}> : () -> vector<8xi64>
  %4605 = "llvm.mlir.constant"() <{value = dense<[-1, -1, -1, -1, -1, 0, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %4606 = "llvm.mlir.poison"() : () -> vector<8xi64>
  %4607 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %4608 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %4609 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %4610 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %4611 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %4612 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %4613 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %4614 = "llvm.mlir.poison"() : () -> vector<5xi64>
  %4615 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %4616 = "llvm.mlir.constant"() <{value = dense<0> : vector<8xi64>}> : () -> vector<8xi64>
  %4617 = "llvm.mlir.constant"() <{value = dense<1> : vector<8xi64>}> : () -> vector<8xi64>
  %4618 = "llvm.mlir.poison"() : () -> i64
  %4619 = "llvm.mlir.undef"() : () -> vector<8xi64>
  %4620 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %4621 = "llvm.insertelement"(%4619, %4618, %4620) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4622 = "llvm.insertelement"(%4621, %4618, %4613) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4623 = "llvm.insertelement"(%4622, %4618, %4612) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4624 = "llvm.insertelement"(%4623, %4618, %4611) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4625 = "llvm.insertelement"(%4624, %4618, %4610) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4626 = "llvm.insertelement"(%4625, %4618, %4609) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4627 = "llvm.insertelement"(%4626, %4618, %4608) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4628 = "llvm.insertelement"(%4627, %4615, %4607) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4629 = "llvm.insertelement"(%4619, %4618, %4620) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4630 = "llvm.insertelement"(%4629, %4618, %4613) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4631 = "llvm.insertelement"(%4630, %4618, %4612) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4632 = "llvm.insertelement"(%4631, %4618, %4611) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4633 = "llvm.insertelement"(%4632, %4618, %4610) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4634 = "llvm.insertelement"(%4633, %4618, %4609) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4635 = "llvm.insertelement"(%4634, %4615, %4608) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4636 = "llvm.insertelement"(%4635, %4615, %4607) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4637 = "llvm.insertelement"(%4619, %4618, %4620) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4638 = "llvm.insertelement"(%4637, %4618, %4613) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4639 = "llvm.insertelement"(%4638, %4618, %4612) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4640 = "llvm.insertelement"(%4639, %4618, %4611) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4641 = "llvm.insertelement"(%4640, %4618, %4610) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4642 = "llvm.insertelement"(%4641, %4615, %4609) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4643 = "llvm.insertelement"(%4642, %4615, %4608) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4644 = "llvm.insertelement"(%4643, %4615, %4607) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4645 = "llvm.insertelement"(%4619, %4618, %4620) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4646 = "llvm.insertelement"(%4645, %4618, %4613) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4647 = "llvm.insertelement"(%4646, %4618, %4612) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4648 = "llvm.insertelement"(%4647, %4618, %4611) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4649 = "llvm.insertelement"(%4648, %4615, %4610) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4650 = "llvm.insertelement"(%4649, %4615, %4609) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4651 = "llvm.insertelement"(%4650, %4615, %4608) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4652 = "llvm.insertelement"(%4651, %4615, %4607) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4653 = "llvm.insertelement"(%4619, %4615, %4620) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4654 = "llvm.insertelement"(%4653, %4618, %4613) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4655 = "llvm.insertelement"(%4654, %4618, %4612) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4656 = "llvm.insertelement"(%4655, %4618, %4611) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4657 = "llvm.insertelement"(%4656, %4618, %4610) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4658 = "llvm.insertelement"(%4657, %4618, %4609) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4659 = "llvm.insertelement"(%4658, %4618, %4608) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4660 = "llvm.insertelement"(%4659, %4618, %4607) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4661 = "llvm.insertelement"(%4619, %4618, %4620) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4662 = "llvm.insertelement"(%4661, %4618, %4613) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4663 = "llvm.insertelement"(%4662, %4618, %4612) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4664 = "llvm.insertelement"(%4663, %4615, %4611) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4665 = "llvm.insertelement"(%4664, %4615, %4610) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4666 = "llvm.insertelement"(%4665, %4615, %4609) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4667 = "llvm.insertelement"(%4666, %4615, %4608) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4668 = "llvm.insertelement"(%4667, %4615, %4607) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4669 = "llvm.load"(%arg152) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<5xi64>
  %4670 = "llvm.shufflevector"(%4669, %4614) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<5xi64>, vector<5xi64>) -> vector<8xi64>
  %4671 = "llvm.shufflevector"(%4669, %4614) <{mask = array<i32: 1, 1, 1, 1, 1, 1, 1, 1>}> : (vector<5xi64>, vector<5xi64>) -> vector<8xi64>
  %4672 = "llvm.shufflevector"(%4669, %4614) <{mask = array<i32: 2, 2, 2, 2, 2, 2, 2, 2>}> : (vector<5xi64>, vector<5xi64>) -> vector<8xi64>
  %4673 = "llvm.shufflevector"(%4669, %4614) <{mask = array<i32: 3, 3, 3, 3, 3, 3, 3, 3>}> : (vector<5xi64>, vector<5xi64>) -> vector<8xi64>
  %4674 = "llvm.shufflevector"(%4669, %4614) <{mask = array<i32: 4, 4, 4, 4, 4, 4, 4, 4>}> : (vector<5xi64>, vector<5xi64>) -> vector<8xi64>
  %4675 = "llvm.load"(%arg153) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %4676 = "llvm.call_intrinsic"(%4616, %4670, %4675) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4677 = "llvm.shl"(%4676, %4617) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4678 = "llvm.call_intrinsic"(%4677, %4671, %4675) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4679 = "llvm.call_intrinsic"(%4616, %4671, %4675) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4680 = "llvm.shl"(%4679, %4617) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4681 = "llvm.call_intrinsic"(%4680, %4672, %4675) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4682 = "llvm.call_intrinsic"(%4616, %4672, %4675) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4683 = "llvm.shl"(%4682, %4617) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4684 = "llvm.call_intrinsic"(%4683, %4673, %4675) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4685 = "llvm.call_intrinsic"(%4616, %4673, %4675) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4686 = "llvm.shl"(%4685, %4617) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4687 = "llvm.call_intrinsic"(%4686, %4674, %4675) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4688 = "llvm.call_intrinsic"(%4616, %4674, %4675) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4689 = "llvm.shl"(%4688, %4617) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4690 = "llvm.shufflevector"(%4628, %4678) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4691 = "llvm.shufflevector"(%4636, %4681) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4692 = "llvm.shufflevector"(%4644, %4684) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4693 = "llvm.shufflevector"(%4652, %4687) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4694 = "llvm.shufflevector"(%4687, %4660) <{mask = array<i32: 4, 5, 6, 7, 8, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4695 = "llvm.shufflevector"(%4668, %4689) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4696 = "llvm.shufflevector"(%4689, %4606) <{mask = array<i32: 3, 4, 5, 6, 7, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4697 = "llvm.call_intrinsic"(%4690, %4670, %4675) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4698 = "llvm.add"(%4692, %4691) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4699 = "llvm.add"(%4698, %4693) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4700 = "llvm.add"(%4699, %4697) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4701 = "llvm.add"(%4700, %4695) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4702 = "llvm.add"(%4696, %4694) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4703 = "llvm.and"(%4701, %4605) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4704 = "llvm.shufflevector"(%4701, %4702) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4705 = "llvm.add"(%4703, %4704) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4706 = "llvm.mul"(%4704, %4604) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4707 = "llvm.add"(%4705, %4706) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4708 = "llvm.call"(%4707) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_f25519_fold_unsigned, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%4708, %arg151) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.return"(%arg151) : (!llvm.ptr) -> ()
}) : () -> ()
  with @fd_f25519_fold_unsigned := fd_f25519_fold_unsigned

end

end MLIR.Firedancer.R52x5
