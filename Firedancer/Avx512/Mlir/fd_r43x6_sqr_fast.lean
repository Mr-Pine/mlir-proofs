module

-- build/llvm23/mlir_canonicalized/avx512/op/fd_r43x6_sqr_fast.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Firedancer.Avx512

@[expose] public section

mlir_def fd_r43x6_sqr_fast :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.noundef}], dso_local, function_type = !llvm.func<vector<8xi64> (vector<8xi64>)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], sym_name = "fd_r43x6_sqr_fast", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg40: vector<8xi64>):
  %545 = "llvm.mlir.constant"() <{value = dense<24> : vector<8xi64>}> : () -> vector<8xi64>
  %546 = "llvm.mlir.constant"() <{value = dense<7> : vector<8xi64>}> : () -> vector<8xi64>
  %547 = "llvm.mlir.constant"() <{value = dense<[-1, -1, -1, -1, -1, -1, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %548 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %549 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %550 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %551 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %552 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %553 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %554 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %555 = "llvm.mlir.poison"() : () -> vector<8xi64>
  %556 = "llvm.mlir.constant"() <{value = dense<[0, 1, 1, 1, 1, 1, 0, 1]> : vector<8xi64>}> : () -> vector<8xi64>
  %557 = "llvm.mlir.constant"() <{value = dense<[0, 1, 0, 1, 1, 1, 1, 1]> : vector<8xi64>}> : () -> vector<8xi64>
  %558 = "llvm.mlir.constant"() <{value = dense<[1, 1, 0, 1, 0, 1, 1, 1]> : vector<8xi64>}> : () -> vector<8xi64>
  %559 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %560 = "llvm.mlir.constant"() <{value = dense<0> : vector<8xi64>}> : () -> vector<8xi64>
  %561 = "llvm.mlir.constant"() <{value = dense<9> : vector<8xi64>}> : () -> vector<8xi64>
  %562 = "llvm.mlir.constant"() <{value = dense<[0, 0, -1, -1, -1, -1, -1, -1]> : vector<8xi64>}> : () -> vector<8xi64>
  %563 = "llvm.mlir.constant"() <{value = dense<[0, -1, 0, -1, -1, -1, -1, -1]> : vector<8xi64>}> : () -> vector<8xi64>
  %564 = "llvm.mlir.poison"() : () -> i64
  %565 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %566 = "llvm.mlir.undef"() : () -> vector<8xi64>
  %567 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %568 = "llvm.insertelement"(%566, %565, %567) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %569 = "llvm.insertelement"(%568, %565, %554) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %570 = "llvm.insertelement"(%569, %559, %553) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %571 = "llvm.insertelement"(%570, %559, %552) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %572 = "llvm.insertelement"(%571, %559, %551) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %573 = "llvm.insertelement"(%572, %559, %550) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %574 = "llvm.insertelement"(%573, %564, %549) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %575 = "llvm.insertelement"(%574, %564, %548) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %576 = "llvm.insertelement"(%566, %565, %567) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %577 = "llvm.insertelement"(%576, %559, %554) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %578 = "llvm.insertelement"(%577, %565, %553) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %579 = "llvm.insertelement"(%578, %559, %552) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %580 = "llvm.insertelement"(%579, %559, %551) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %581 = "llvm.insertelement"(%580, %559, %550) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %582 = "llvm.insertelement"(%581, %564, %549) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %583 = "llvm.insertelement"(%582, %564, %548) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %584 = "llvm.insertelement"(%566, %565, %567) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %585 = "llvm.insertelement"(%584, %565, %554) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %586 = "llvm.insertelement"(%585, %559, %553) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %587 = "llvm.insertelement"(%586, %559, %552) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %588 = "llvm.insertelement"(%587, %559, %551) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %589 = "llvm.insertelement"(%588, %564, %550) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %590 = "llvm.insertelement"(%589, %564, %549) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %591 = "llvm.insertelement"(%590, %564, %548) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %592 = "llvm.insertelement"(%566, %565, %567) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %593 = "llvm.insertelement"(%592, %559, %554) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %594 = "llvm.insertelement"(%593, %565, %553) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %595 = "llvm.insertelement"(%594, %559, %552) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %596 = "llvm.insertelement"(%595, %559, %551) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %597 = "llvm.insertelement"(%596, %564, %550) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %598 = "llvm.insertelement"(%597, %564, %549) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %599 = "llvm.insertelement"(%598, %564, %548) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %600 = "llvm.insertelement"(%566, %564, %567) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %601 = "llvm.insertelement"(%600, %564, %554) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %602 = "llvm.insertelement"(%601, %564, %553) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %603 = "llvm.insertelement"(%602, %564, %552) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %604 = "llvm.insertelement"(%603, %564, %551) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %605 = "llvm.insertelement"(%604, %564, %550) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %606 = "llvm.insertelement"(%605, %564, %549) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %607 = "llvm.insertelement"(%606, %559, %548) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %608 = "llvm.insertelement"(%566, %559, %567) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %609 = "llvm.insertelement"(%608, %559, %554) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %610 = "llvm.insertelement"(%609, %559, %553) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %611 = "llvm.insertelement"(%610, %559, %552) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %612 = "llvm.insertelement"(%611, %559, %551) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %613 = "llvm.insertelement"(%612, %564, %550) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %614 = "llvm.insertelement"(%613, %564, %549) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %615 = "llvm.insertelement"(%614, %564, %548) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %616 = "llvm.shufflevector"(%arg40, %555) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 3, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %617 = "llvm.shufflevector"(%arg40, %555) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 3, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %618 = "llvm.shufflevector"(%arg40, %555) <{mask = array<i32: 4, 4, 1, 1, 1, 1, 1, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %619 = "llvm.shufflevector"(%arg40, %555) <{mask = array<i32: 4, 5, 1, 2, 3, 4, 5, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %620 = "llvm.shufflevector"(%arg40, %555) <{mask = array<i32: 3, 7, 5, 7, 2, 2, 2, 2>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %621 = "llvm.shufflevector"(%arg40, %555) <{mask = array<i32: 5, 7, 5, 7, 2, 3, 4, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %622 = "llvm.shl"(%616, %556) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %623 = "llvm.shl"(%618, %557) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %624 = "llvm.shl"(%620, %558) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %625 = "llvm.call_intrinsic"(%560, %623, %619) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %626 = "llvm.call_intrinsic"(%560, %624, %621) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %627 = "llvm.call_intrinsic"(%560, %622, %617) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %628 = "llvm.shl"(%627, %561) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %629 = "llvm.call_intrinsic"(%560, %623, %619) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %630 = "llvm.shl"(%629, %561) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %631 = "llvm.call_intrinsic"(%560, %624, %621) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %632 = "llvm.shl"(%631, %561) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %633 = "llvm.and"(%625, %562) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %634 = "llvm.and"(%626, %563) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %635 = "llvm.add"(%634, %633) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %636 = "llvm.call_intrinsic"(%635, %622, %617) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %637 = "llvm.and"(%630, %562) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %638 = "llvm.and"(%632, %563) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %639 = "llvm.add"(%637, %628) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %640 = "llvm.add"(%639, %638) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %641 = "llvm.and"(%625, %575) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %642 = "llvm.and"(%626, %583) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %643 = "llvm.and"(%630, %591) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %644 = "llvm.and"(%632, %599) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %645 = "llvm.add"(%644, %643) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %646 = "llvm.shufflevector"(%607, %640) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %647 = "llvm.add"(%646, %636) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %648 = "llvm.shufflevector"(%607, %645) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %649 = "llvm.shufflevector"(%640, %615) <{mask = array<i32: 7, 8, 9, 10, 11, 12, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %650 = "llvm.add"(%642, %641) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %651 = "llvm.add"(%650, %648) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %652 = "llvm.add"(%651, %649) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %653 = "llvm.and"(%647, %547) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %654 = "llvm.shufflevector"(%647, %652) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %655 = "llvm.shl"(%654, %546) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %656 = "llvm.add"(%655, %653) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %657 = "llvm.mul"(%654, %545) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %658 = "llvm.add"(%656, %657) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.return"(%658) : (vector<8xi64>) -> ()
}) : () -> ()

end

end MLIR.Firedancer.Avx512
