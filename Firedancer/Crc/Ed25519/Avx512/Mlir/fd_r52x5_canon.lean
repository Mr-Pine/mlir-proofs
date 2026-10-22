module

-- crc/out/mlirproofs/regions/verify/fd_r52x5_canon.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Firedancer.Crc.Ed25519.Avx512

@[expose] public section

mlir_def fd_r52x5_canon :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], sym_name = "fd_r52x5_canon", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg120: !llvm.ptr, %arg121: !llvm.ptr):
  %574 = "llvm.mlir.constant"() <{value = 2251799813685247 : i64}> : () -> i64
  %575 = "llvm.mlir.constant"() <{value = 51 : i64}> : () -> i64
  %576 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %577 = "llvm.mlir.poison"() : () -> vector<4xi64>
  %578 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %579 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %580 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %581 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %582 = "llvm.mlir.constant"() <{value = dense<2251799813685247> : vector<4xi64>}> : () -> vector<4xi64>
  %583 = "llvm.load"(%arg121) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %584 = "llvm.and"(%583, %574) : (i64, i64) -> i64
  %585 = "llvm.getelementptr"(%arg121) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %586 = "llvm.load"(%585) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %587 = "llvm.lshr"(%586, %575) : (i64, i64) -> i64
  %588 = "llvm.mul"(%587, %576) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %589 = "llvm.add"(%588, %584) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %590 = "llvm.getelementptr"(%arg121) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %591 = "llvm.load"(%590) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %592 = "llvm.lshr"(%591, %575) : (i64, i64) -> i64
  %593 = "llvm.and"(%586, %574) : (i64, i64) -> i64
  %594 = "llvm.add"(%592, %593) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %595 = "llvm.getelementptr"(%arg121) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %596 = "llvm.load"(%595) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %597 = "llvm.lshr"(%596, %575) : (i64, i64) -> i64
  %598 = "llvm.and"(%591, %574) : (i64, i64) -> i64
  %599 = "llvm.add"(%597, %598) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %600 = "llvm.getelementptr"(%arg121) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %601 = "llvm.load"(%600) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %602 = "llvm.lshr"(%601, %575) : (i64, i64) -> i64
  %603 = "llvm.and"(%596, %574) : (i64, i64) -> i64
  %604 = "llvm.add"(%602, %603) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %605 = "llvm.lshr"(%583, %575) : (i64, i64) -> i64
  %606 = "llvm.and"(%601, %574) : (i64, i64) -> i64
  %607 = "llvm.add"(%606, %605) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %608 = "llvm.add"(%589, %576) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %609 = "llvm.lshr"(%608, %575) : (i64, i64) -> i64
  %610 = "llvm.add"(%607, %609) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %611 = "llvm.lshr"(%610, %575) : (i64, i64) -> i64
  %612 = "llvm.add"(%611, %604) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %613 = "llvm.lshr"(%612, %575) : (i64, i64) -> i64
  %614 = "llvm.add"(%613, %599) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %615 = "llvm.lshr"(%614, %575) : (i64, i64) -> i64
  %616 = "llvm.add"(%615, %594) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %617 = "llvm.lshr"(%616, %575) : (i64, i64) -> i64
  %618 = "llvm.mul"(%617, %576) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %619 = "llvm.add"(%618, %589) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %620 = "llvm.lshr"(%619, %575) : (i64, i64) -> i64
  %621 = "llvm.add"(%620, %607) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %622 = "llvm.lshr"(%621, %575) : (i64, i64) -> i64
  %623 = "llvm.add"(%622, %604) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %624 = "llvm.lshr"(%623, %575) : (i64, i64) -> i64
  %625 = "llvm.add"(%624, %599) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %626 = "llvm.insertelement"(%577, %619, %578) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %627 = "llvm.insertelement"(%626, %621, %579) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %628 = "llvm.insertelement"(%627, %623, %580) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %629 = "llvm.insertelement"(%628, %625, %581) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %630 = "llvm.and"(%629, %582) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %631 = "llvm.lshr"(%625, %575) : (i64, i64) -> i64
  %632 = "llvm.add"(%631, %594) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %633 = "llvm.and"(%632, %574) : (i64, i64) -> i64
  "llvm.store"(%630, %arg120) <{alignment = 8 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %634 = "llvm.getelementptr"(%arg120) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%633, %634) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end MLIR.Firedancer.Crc.Ed25519.Avx512
