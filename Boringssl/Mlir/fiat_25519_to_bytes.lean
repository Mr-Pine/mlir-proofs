module

-- boringssl-build/out/op/_ZL19fiat_25519_to_bytesPhPKm.mlir
-- fiat_25519_to_bytes(unsigned char*, unsigned long const*)

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Boringssl.Mlir.fiat_25519_cmovznz_u64
public import Firedancer.Ref.Mlir.fiat_25519_addcarryx_u51
public import Firedancer.Ref.Mlir.fiat_25519_subborrowx_u51

meta import MLIR.Semantics.Func
meta import Boringssl.Mlir.fiat_25519_cmovznz_u64
meta import Firedancer.Ref.Mlir.fiat_25519_addcarryx_u51
meta import Firedancer.Ref.Mlir.fiat_25519_subborrowx_u51

namespace MLIR.Boringssl

@[expose] public section

mlir_def fiat_25519_to_bytes :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"], ["warn-stack-size", "25344"]], sym_name = "_ZL19fiat_25519_to_bytesPhPKm", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg157: !llvm.ptr, %arg158: !llvm.ptr):
  %1767 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1768 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %1769 = "llvm.mlir.constant"() <{value = 2251799813685229 : i64}> : () -> i64
  %1770 = "llvm.mlir.constant"() <{value = 8 : i64}> : () -> i64
  %1771 = "llvm.mlir.constant"() <{value = 2251799813685247 : i64}> : () -> i64
  %1772 = "llvm.mlir.constant"() <{value = 16 : i64}> : () -> i64
  %1773 = "llvm.mlir.constant"() <{value = 24 : i64}> : () -> i64
  %1774 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %1775 = "llvm.mlir.constant"() <{value = 4 : i64}> : () -> i64
  %1776 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %1777 = "llvm.mlir.constant"() <{value = 6 : i64}> : () -> i64
  %1778 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %1779 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
  %1780 = "llvm.mlir.constant"() <{value = 48 : i64}> : () -> i64
  %1781 = "llvm.mlir.constant"() <{value = 255 : i64}> : () -> i64
  %1782 = "llvm.mlir.constant"() <{value = 56 : i64}> : () -> i64
  %1783 = "llvm.alloca"(%1767) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %1784 = "llvm.alloca"(%1767) <{alignment = 1 : i64, elem_type = i8}> : (i32) -> !llvm.ptr
  %1785 = "llvm.alloca"(%1767) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %1786 = "llvm.alloca"(%1767) <{alignment = 1 : i64, elem_type = i8}> : (i32) -> !llvm.ptr
  %1787 = "llvm.alloca"(%1767) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %1788 = "llvm.alloca"(%1767) <{alignment = 1 : i64, elem_type = i8}> : (i32) -> !llvm.ptr
  %1789 = "llvm.alloca"(%1767) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %1790 = "llvm.alloca"(%1767) <{alignment = 1 : i64, elem_type = i8}> : (i32) -> !llvm.ptr
  %1791 = "llvm.alloca"(%1767) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %1792 = "llvm.alloca"(%1767) <{alignment = 1 : i64, elem_type = i8}> : (i32) -> !llvm.ptr
  %1793 = "llvm.alloca"(%1767) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %1794 = "llvm.alloca"(%1767) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %1795 = "llvm.alloca"(%1767) <{alignment = 1 : i64, elem_type = i8}> : (i32) -> !llvm.ptr
  %1796 = "llvm.alloca"(%1767) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %1797 = "llvm.alloca"(%1767) <{alignment = 1 : i64, elem_type = i8}> : (i32) -> !llvm.ptr
  %1798 = "llvm.alloca"(%1767) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %1799 = "llvm.alloca"(%1767) <{alignment = 1 : i64, elem_type = i8}> : (i32) -> !llvm.ptr
  %1800 = "llvm.alloca"(%1767) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %1801 = "llvm.alloca"(%1767) <{alignment = 1 : i64, elem_type = i8}> : (i32) -> !llvm.ptr
  %1802 = "llvm.alloca"(%1767) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %1803 = "llvm.alloca"(%1767) <{alignment = 1 : i64, elem_type = i8}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%1783) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1784) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1785) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1786) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1787) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1788) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1789) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1790) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1791) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1792) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1793) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1794) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1795) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1796) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1797) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1798) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1799) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1800) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1801) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1802) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1803) : (!llvm.ptr) -> ()
  %1804 = "llvm.load"(%arg158) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  "llvm.call"(%1783, %1784, %1768, %1804, %1769) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef, llvm.zeroext}, {llvm.noundef}, {llvm.noundef}], callee = @_ZL25fiat_25519_subborrowx_u51PmPhhmm, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (!llvm.ptr, !llvm.ptr, i8, i64, i64) -> ()
  %1805 = "llvm.load"(%1784) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1806 = "llvm.getelementptr"(%arg158) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %1807 = "llvm.load"(%1806) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  "llvm.call"(%1785, %1786, %1805, %1807, %1771) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef, llvm.zeroext}, {llvm.noundef}, {llvm.noundef}], callee = @_ZL25fiat_25519_subborrowx_u51PmPhhmm, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (!llvm.ptr, !llvm.ptr, i8, i64, i64) -> ()
  %1808 = "llvm.load"(%1786) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1809 = "llvm.getelementptr"(%arg158) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %1810 = "llvm.load"(%1809) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  "llvm.call"(%1787, %1788, %1808, %1810, %1771) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef, llvm.zeroext}, {llvm.noundef}, {llvm.noundef}], callee = @_ZL25fiat_25519_subborrowx_u51PmPhhmm, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (!llvm.ptr, !llvm.ptr, i8, i64, i64) -> ()
  %1811 = "llvm.load"(%1788) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1812 = "llvm.getelementptr"(%arg158) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %1813 = "llvm.load"(%1812) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  "llvm.call"(%1789, %1790, %1811, %1813, %1771) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef, llvm.zeroext}, {llvm.noundef}, {llvm.noundef}], callee = @_ZL25fiat_25519_subborrowx_u51PmPhhmm, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (!llvm.ptr, !llvm.ptr, i8, i64, i64) -> ()
  %1814 = "llvm.load"(%1790) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1815 = "llvm.getelementptr"(%arg158) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %1816 = "llvm.load"(%1815) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  "llvm.call"(%1791, %1792, %1814, %1816, %1771) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef, llvm.zeroext}, {llvm.noundef}, {llvm.noundef}], callee = @_ZL25fiat_25519_subborrowx_u51PmPhhmm, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (!llvm.ptr, !llvm.ptr, i8, i64, i64) -> ()
  %1817 = "llvm.load"(%1792) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  "llvm.call"(%1793, %1817) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef, llvm.zeroext}], callee = @_ZL22fiat_25519_cmovznz_u64Pmhmm, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, i8) -> ()
  %1818 = "llvm.load"(%1783) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1819 = "llvm.load"(%1793) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1820 = "llvm.and"(%1819, %1769) : (i64, i64) -> i64
  "llvm.call"(%1794, %1795, %1768, %1818, %1820) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef, llvm.zeroext}, {llvm.noundef}, {llvm.noundef}], callee = @_ZL24fiat_25519_addcarryx_u51PmPhhmm, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (!llvm.ptr, !llvm.ptr, i8, i64, i64) -> ()
  %1821 = "llvm.load"(%1795) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1822 = "llvm.load"(%1785) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1823 = "llvm.and"(%1819, %1771) : (i64, i64) -> i64
  "llvm.call"(%1796, %1797, %1821, %1822, %1823) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef, llvm.zeroext}, {llvm.noundef}, {llvm.noundef}], callee = @_ZL24fiat_25519_addcarryx_u51PmPhhmm, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (!llvm.ptr, !llvm.ptr, i8, i64, i64) -> ()
  %1824 = "llvm.load"(%1797) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1825 = "llvm.load"(%1787) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  "llvm.call"(%1798, %1799, %1824, %1825, %1823) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef, llvm.zeroext}, {llvm.noundef}, {llvm.noundef}], callee = @_ZL24fiat_25519_addcarryx_u51PmPhhmm, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (!llvm.ptr, !llvm.ptr, i8, i64, i64) -> ()
  %1826 = "llvm.load"(%1799) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1827 = "llvm.load"(%1789) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  "llvm.call"(%1800, %1801, %1826, %1827, %1823) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef, llvm.zeroext}, {llvm.noundef}, {llvm.noundef}], callee = @_ZL24fiat_25519_addcarryx_u51PmPhhmm, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (!llvm.ptr, !llvm.ptr, i8, i64, i64) -> ()
  %1828 = "llvm.load"(%1801) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1829 = "llvm.load"(%1791) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  "llvm.call"(%1802, %1803, %1828, %1829, %1823) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef, llvm.zeroext}, {llvm.noundef}, {llvm.noundef}], callee = @_ZL24fiat_25519_addcarryx_u51PmPhhmm, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (!llvm.ptr, !llvm.ptr, i8, i64, i64) -> ()
  %1830 = "llvm.load"(%1802) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1831 = "llvm.shl"(%1830, %1775) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1832 = "llvm.load"(%1800) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1833 = "llvm.shl"(%1832, %1776) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1834 = "llvm.load"(%1798) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1835 = "llvm.shl"(%1834, %1777) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1836 = "llvm.load"(%1796) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1837 = "llvm.shl"(%1836, %1778) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1838 = "llvm.load"(%1794) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1839 = "llvm.trunc"(%1838) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1840 = "llvm.lshr"(%1838, %1770) : (i64, i64) -> i64
  %1841 = "llvm.trunc"(%1840) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1842 = "llvm.lshr"(%1838, %1772) : (i64, i64) -> i64
  %1843 = "llvm.trunc"(%1842) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1844 = "llvm.lshr"(%1838, %1773) : (i64, i64) -> i64
  %1845 = "llvm.trunc"(%1844) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1846 = "llvm.lshr"(%1838, %1774) : (i64, i64) -> i64
  %1847 = "llvm.trunc"(%1846) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1848 = "llvm.lshr"(%1838, %1779) : (i64, i64) -> i64
  %1849 = "llvm.trunc"(%1848) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1850 = "llvm.lshr"(%1838, %1780) : (i64, i64) -> i64
  %1851 = "llvm.and"(%1850, %1781) : (i64, i64) -> i64
  %1852 = "llvm.add"(%1851, %1837) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1853 = "llvm.trunc"(%1852) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1854 = "llvm.lshr"(%1852, %1770) : (i64, i64) -> i64
  %1855 = "llvm.trunc"(%1854) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1856 = "llvm.lshr"(%1852, %1772) : (i64, i64) -> i64
  %1857 = "llvm.trunc"(%1856) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1858 = "llvm.lshr"(%1852, %1773) : (i64, i64) -> i64
  %1859 = "llvm.trunc"(%1858) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1860 = "llvm.lshr"(%1852, %1774) : (i64, i64) -> i64
  %1861 = "llvm.trunc"(%1860) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1862 = "llvm.lshr"(%1852, %1779) : (i64, i64) -> i64
  %1863 = "llvm.trunc"(%1862) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1864 = "llvm.lshr"(%1852, %1780) : (i64, i64) -> i64
  %1865 = "llvm.and"(%1864, %1781) : (i64, i64) -> i64
  %1866 = "llvm.add"(%1865, %1835) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1867 = "llvm.trunc"(%1866) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1868 = "llvm.lshr"(%1866, %1770) : (i64, i64) -> i64
  %1869 = "llvm.trunc"(%1868) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1870 = "llvm.lshr"(%1866, %1772) : (i64, i64) -> i64
  %1871 = "llvm.trunc"(%1870) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1872 = "llvm.lshr"(%1866, %1773) : (i64, i64) -> i64
  %1873 = "llvm.trunc"(%1872) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1874 = "llvm.lshr"(%1866, %1774) : (i64, i64) -> i64
  %1875 = "llvm.trunc"(%1874) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1876 = "llvm.lshr"(%1866, %1779) : (i64, i64) -> i64
  %1877 = "llvm.trunc"(%1876) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1878 = "llvm.lshr"(%1866, %1780) : (i64, i64) -> i64
  %1879 = "llvm.trunc"(%1878) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1880 = "llvm.lshr"(%1866, %1782) : (i64, i64) -> i64
  %1881 = "llvm.add"(%1880, %1833) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1882 = "llvm.trunc"(%1881) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1883 = "llvm.lshr"(%1881, %1770) : (i64, i64) -> i64
  %1884 = "llvm.trunc"(%1883) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1885 = "llvm.lshr"(%1881, %1772) : (i64, i64) -> i64
  %1886 = "llvm.trunc"(%1885) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1887 = "llvm.lshr"(%1881, %1773) : (i64, i64) -> i64
  %1888 = "llvm.trunc"(%1887) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1889 = "llvm.lshr"(%1881, %1774) : (i64, i64) -> i64
  %1890 = "llvm.trunc"(%1889) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1891 = "llvm.lshr"(%1881, %1779) : (i64, i64) -> i64
  %1892 = "llvm.trunc"(%1891) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1893 = "llvm.lshr"(%1881, %1780) : (i64, i64) -> i64
  %1894 = "llvm.and"(%1893, %1781) : (i64, i64) -> i64
  %1895 = "llvm.add"(%1894, %1831) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1896 = "llvm.trunc"(%1895) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1897 = "llvm.lshr"(%1895, %1770) : (i64, i64) -> i64
  %1898 = "llvm.trunc"(%1897) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1899 = "llvm.lshr"(%1895, %1772) : (i64, i64) -> i64
  %1900 = "llvm.trunc"(%1899) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1901 = "llvm.lshr"(%1895, %1773) : (i64, i64) -> i64
  %1902 = "llvm.trunc"(%1901) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1903 = "llvm.lshr"(%1895, %1774) : (i64, i64) -> i64
  %1904 = "llvm.trunc"(%1903) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1905 = "llvm.lshr"(%1895, %1779) : (i64, i64) -> i64
  %1906 = "llvm.trunc"(%1905) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %1907 = "llvm.lshr"(%1895, %1780) : (i64, i64) -> i64
  %1908 = "llvm.trunc"(%1907) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%1839, %arg157) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1909 = "llvm.getelementptr"(%arg157) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1841, %1909) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1910 = "llvm.getelementptr"(%arg157) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1843, %1910) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1911 = "llvm.getelementptr"(%arg157) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 3>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1845, %1911) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1912 = "llvm.getelementptr"(%arg157) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1847, %1912) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1913 = "llvm.getelementptr"(%arg157) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 5>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1849, %1913) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1914 = "llvm.getelementptr"(%arg157) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1853, %1914) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1915 = "llvm.getelementptr"(%arg157) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 7>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1855, %1915) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1916 = "llvm.getelementptr"(%arg157) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1857, %1916) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1917 = "llvm.getelementptr"(%arg157) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 9>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1859, %1917) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1918 = "llvm.getelementptr"(%arg157) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 10>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1861, %1918) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1919 = "llvm.getelementptr"(%arg157) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 11>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1863, %1919) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1920 = "llvm.getelementptr"(%arg157) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 12>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1867, %1920) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1921 = "llvm.getelementptr"(%arg157) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 13>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1869, %1921) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1922 = "llvm.getelementptr"(%arg157) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 14>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1871, %1922) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1923 = "llvm.getelementptr"(%arg157) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 15>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1873, %1923) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1924 = "llvm.getelementptr"(%arg157) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1875, %1924) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1925 = "llvm.getelementptr"(%arg157) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 17>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1877, %1925) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1926 = "llvm.getelementptr"(%arg157) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 18>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1879, %1926) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1927 = "llvm.getelementptr"(%arg157) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 19>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1882, %1927) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1928 = "llvm.getelementptr"(%arg157) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 20>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1884, %1928) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1929 = "llvm.getelementptr"(%arg157) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 21>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1886, %1929) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1930 = "llvm.getelementptr"(%arg157) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 22>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1888, %1930) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1931 = "llvm.getelementptr"(%arg157) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 23>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1890, %1931) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1932 = "llvm.getelementptr"(%arg157) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1892, %1932) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1933 = "llvm.getelementptr"(%arg157) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 25>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1896, %1933) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1934 = "llvm.getelementptr"(%arg157) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 26>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1898, %1934) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1935 = "llvm.getelementptr"(%arg157) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 27>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1900, %1935) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1936 = "llvm.getelementptr"(%arg157) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 28>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1902, %1936) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1937 = "llvm.getelementptr"(%arg157) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 29>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1904, %1937) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1938 = "llvm.getelementptr"(%arg157) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 30>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1906, %1938) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %1939 = "llvm.getelementptr"(%arg157) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 31>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1908, %1939) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1803) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1802) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1801) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1800) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1799) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1798) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1797) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1796) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1795) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1794) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1793) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1792) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1791) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1790) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1789) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1788) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1787) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1786) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1785) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1784) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1783) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
  with @_ZL22fiat_25519_cmovznz_u64Pmhmm := fiat_25519_cmovznz_u64,
    @_ZL24fiat_25519_addcarryx_u51PmPhhmm := MLIR.Firedancer.Ref.fiat_25519_addcarryx_u51,
    @_ZL25fiat_25519_subborrowx_u51PmPhhmm := MLIR.Firedancer.Ref.fiat_25519_subborrowx_u51

end

end MLIR.Boringssl
