module

-- ~/fd-pr9879/build/llvm23-production/mlir_canonicalized/avx512/op/fd_f25519_sqr.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.R52x5.Mlir.fd_f25519_fold_unsigned

meta import MLIR.Semantics.Func
meta import Firedancer.R52x5.Mlir.fd_f25519_fold_unsigned

namespace MLIR.Firedancer.R52x5

@[expose] public section

mlir_def fd_f25519_sqr :=
#tbaa_root = #llvm.tbaa_root<id = "Simple C/C++ TBAA">
#tbaa_type_desc = #llvm.tbaa_type_desc<id = "omnipotent char", members = {<#tbaa_root, 0>}>
#tbaa_tag = #llvm.tbaa_tag<base_type = #tbaa_type_desc, access_type = #tbaa_type_desc, offset = 0>
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nofree, llvm.nonnull, llvm.noundef, llvm.returned, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<ptr (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], res_attrs = [{llvm.nonnull, llvm.noundef}], sym_name = "fd_f25519_sqr", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg154: !llvm.ptr, %arg155: !llvm.ptr):
  %4709 = "llvm.mlir.constant"() <{value = dense<18> : vector<8xi64>}> : () -> vector<8xi64>
  %4710 = "llvm.mlir.constant"() <{value = dense<[-1, -1, -1, -1, -1, 0, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %4711 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %4712 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %4713 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %4714 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %4715 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %4716 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %4717 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %4718 = "llvm.mlir.poison"() : () -> vector<6xi64>
  %4719 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %4720 = "llvm.mlir.constant"() <{value = dense<0> : vector<8xi64>}> : () -> vector<8xi64>
  %4721 = "llvm.mlir.constant"() <{value = dense<[0, 1, 1, 1, 1, 1, 0, 1]> : vector<8xi64>}> : () -> vector<8xi64>
  %4722 = "llvm.mlir.constant"() <{value = dense<[1, 2, 2, 2, 2, 2, 1, 2]> : vector<8xi64>}> : () -> vector<8xi64>
  %4723 = "llvm.mlir.constant"() <{value = dense<[0, 0, 0, 1, 1, 1, 1, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %4724 = "llvm.mlir.constant"() <{value = dense<[1, 0, 1, 2, 2, 2, 2, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %4725 = "llvm.mlir.constant"() <{value = dense<1> : vector<8xi64>}> : () -> vector<8xi64>
  %4726 = "llvm.mlir.constant"() <{value = dense<[0, -1, -1, -1, -1, -1, -1, -1]> : vector<8xi64>}> : () -> vector<8xi64>
  %4727 = "llvm.mlir.poison"() : () -> i64
  %4728 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %4729 = "llvm.mlir.undef"() : () -> vector<8xi64>
  %4730 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %4731 = "llvm.insertelement"(%4729, %4728, %4730) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4732 = "llvm.insertelement"(%4731, %4719, %4717) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4733 = "llvm.insertelement"(%4732, %4719, %4716) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4734 = "llvm.insertelement"(%4733, %4719, %4715) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4735 = "llvm.insertelement"(%4734, %4719, %4714) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4736 = "llvm.insertelement"(%4735, %4727, %4713) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4737 = "llvm.insertelement"(%4736, %4727, %4712) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4738 = "llvm.insertelement"(%4737, %4727, %4711) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4739 = "llvm.insertelement"(%4729, %4728, %4730) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4740 = "llvm.insertelement"(%4739, %4719, %4717) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4741 = "llvm.insertelement"(%4740, %4719, %4716) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4742 = "llvm.insertelement"(%4741, %4719, %4715) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4743 = "llvm.insertelement"(%4742, %4727, %4714) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4744 = "llvm.insertelement"(%4743, %4727, %4713) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4745 = "llvm.insertelement"(%4744, %4727, %4712) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4746 = "llvm.insertelement"(%4745, %4727, %4711) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4747 = "llvm.insertelement"(%4729, %4727, %4730) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4748 = "llvm.insertelement"(%4747, %4727, %4717) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4749 = "llvm.insertelement"(%4748, %4727, %4716) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4750 = "llvm.insertelement"(%4749, %4727, %4715) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4751 = "llvm.insertelement"(%4750, %4727, %4714) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4752 = "llvm.insertelement"(%4751, %4727, %4713) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4753 = "llvm.insertelement"(%4752, %4727, %4712) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4754 = "llvm.insertelement"(%4753, %4719, %4711) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4755 = "llvm.insertelement"(%4729, %4719, %4730) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4756 = "llvm.insertelement"(%4755, %4719, %4717) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4757 = "llvm.insertelement"(%4756, %4719, %4716) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4758 = "llvm.insertelement"(%4757, %4719, %4715) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4759 = "llvm.insertelement"(%4758, %4727, %4714) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4760 = "llvm.insertelement"(%4759, %4727, %4713) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4761 = "llvm.insertelement"(%4760, %4727, %4712) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4762 = "llvm.insertelement"(%4761, %4727, %4711) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %4763 = "llvm.load"(%arg155) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<6xi64>
  %4764 = "llvm.shufflevector"(%4763, %4718) <{mask = array<i32: 0, 0, 0, 0, 0, 2, 3, 3>}> : (vector<6xi64>, vector<6xi64>) -> vector<8xi64>
  %4765 = "llvm.shufflevector"(%4763, %4718) <{mask = array<i32: 0, 1, 2, 3, 4, 3, 3, 4>}> : (vector<6xi64>, vector<6xi64>) -> vector<8xi64>
  %4766 = "llvm.shufflevector"(%4763, %4718) <{mask = array<i32: 4, 5, 1, 1, 1, 1, 2, 5>}> : (vector<6xi64>, vector<6xi64>) -> vector<8xi64>
  %4767 = "llvm.shufflevector"(%4763, %4718) <{mask = array<i32: 4, 5, 1, 2, 3, 4, 4, 5>}> : (vector<6xi64>, vector<6xi64>) -> vector<8xi64>
  %4768 = "llvm.shufflevector"(%4763, %4718) <{mask = array<i32: 5, 5, 5, 5, 2, 5, 5, 5>}> : (vector<6xi64>, vector<6xi64>) -> vector<8xi64>
  %4769 = "llvm.call_intrinsic"(%4720, %4764, %4765) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4770 = "llvm.call_intrinsic"(%4720, %4764, %4765) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4771 = "llvm.call_intrinsic"(%4720, %4766, %4767) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4772 = "llvm.call_intrinsic"(%4720, %4766, %4767) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4773 = "llvm.call_intrinsic"(%4720, %4768, %4768) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4774 = "llvm.shl"(%4769, %4721) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4775 = "llvm.shl"(%4770, %4722) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4776 = "llvm.shl"(%4771, %4723) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4777 = "llvm.shl"(%4772, %4724) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4778 = "llvm.shl"(%4773, %4725) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4779 = "llvm.and"(%4776, %4726) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4780 = "llvm.add"(%4779, %4774) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4781 = "llvm.call_intrinsic"(%4780, %4768, %4768) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4782 = "llvm.and"(%4777, %4726) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4783 = "llvm.add"(%4782, %4775) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4784 = "llvm.add"(%4783, %4778) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4785 = "llvm.and"(%4776, %4738) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4786 = "llvm.and"(%4777, %4746) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4787 = "llvm.shufflevector"(%4754, %4784) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4788 = "llvm.add"(%4787, %4781) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4789 = "llvm.shufflevector"(%4754, %4786) <{mask = array<i32: 7, 8, 9, 10, 11, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4790 = "llvm.shufflevector"(%4784, %4762) <{mask = array<i32: 7, 8, 9, 10, 11, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4791 = "llvm.add"(%4789, %4785) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4792 = "llvm.add"(%4791, %4790) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4793 = "llvm.and"(%4788, %4710) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4794 = "llvm.shufflevector"(%4788, %4792) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4795 = "llvm.add"(%4794, %4793) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4796 = "llvm.mul"(%4794, %4709) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4797 = "llvm.add"(%4795, %4796) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4798 = "llvm.call"(%4797) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_f25519_fold_unsigned, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%4798, %arg154) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.return"(%arg154) : (!llvm.ptr) -> ()
}) : () -> ()
  with @fd_f25519_fold_unsigned := fd_f25519_fold_unsigned

end

end MLIR.Firedancer.R52x5
