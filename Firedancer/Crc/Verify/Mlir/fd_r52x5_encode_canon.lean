module

-- crc/out/mlirproofs/regions/verify/fd_r52x5_encode_canon.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Firedancer.Crc.Verify

@[expose] public section

mlir_def fd_r52x5_encode_canon :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {}, {llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, i64, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], sym_name = "fd_r52x5_encode_canon", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg145: !llvm.ptr, %arg146: i64, %arg147: !llvm.ptr):
  %1682 = "llvm.mlir.constant"() <{value = 51 : i64}> : () -> i64
  %1683 = "llvm.mlir.constant"() <{value = 13 : i64}> : () -> i64
  %1684 = "llvm.mlir.constant"() <{value = 38 : i64}> : () -> i64
  %1685 = "llvm.mlir.constant"() <{value = 26 : i64}> : () -> i64
  %1686 = "llvm.mlir.constant"() <{value = 25 : i64}> : () -> i64
  %1687 = "llvm.mlir.constant"() <{value = 39 : i64}> : () -> i64
  %1688 = "llvm.mlir.constant"() <{value = 12 : i64}> : () -> i64
  %1689 = "llvm.mlir.constant"() <{value = 7 : i8}> : () -> i8
  %1690 = "llvm.mlir.constant"() <{value = 56 : i64}> : () -> i64
  %1691 = "llvm.load"(%arg147) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1692 = "llvm.getelementptr"(%arg147) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %1693 = "llvm.load"(%1692) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1694 = "llvm.shl"(%1693, %1682) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1695 = "llvm.or"(%1694, %1691) : (i64, i64) -> i64
  "llvm.store"(%1695, %arg145) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1696 = "llvm.load"(%1692) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1697 = "llvm.lshr"(%1696, %1683) : (i64, i64) -> i64
  %1698 = "llvm.getelementptr"(%arg147) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %1699 = "llvm.load"(%1698) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1700 = "llvm.shl"(%1699, %1684) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1701 = "llvm.or"(%1700, %1697) : (i64, i64) -> i64
  %1702 = "llvm.getelementptr"(%arg145) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1701, %1702) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1703 = "llvm.load"(%1698) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1704 = "llvm.lshr"(%1703, %1685) : (i64, i64) -> i64
  %1705 = "llvm.getelementptr"(%arg147) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %1706 = "llvm.load"(%1705) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1707 = "llvm.shl"(%1706, %1686) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1708 = "llvm.or"(%1707, %1704) : (i64, i64) -> i64
  %1709 = "llvm.getelementptr"(%arg145) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1708, %1709) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1710 = "llvm.load"(%1705) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1711 = "llvm.lshr"(%1710, %1687) : (i64, i64) -> i64
  %1712 = "llvm.getelementptr"(%arg147) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %1713 = "llvm.load"(%1712) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1714 = "llvm.shl"(%1713, %1688) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1715 = "llvm.or"(%1714, %1711) : (i64, i64) -> i64
  %1716 = "llvm.getelementptr"(%arg145) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1715, %1716) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1717 = "llvm.trunc"(%arg146) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1718 = "llvm.shl"(%1717, %1689) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  %1719 = "llvm.getelementptr"(%arg145) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 31>}> : (!llvm.ptr) -> !llvm.ptr
  %1720 = "llvm.lshr"(%1714, %1690) : (i64, i64) -> i64
  %1721 = "llvm.trunc"(%1720) <{overflowFlags = 2 : i32}> : (i64) -> i8
  %1722 = "llvm.xor"(%1718, %1721) : (i8, i8) -> i8
  "llvm.store"(%1722, %1719) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end MLIR.Firedancer.Crc.Verify
