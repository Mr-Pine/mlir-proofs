module

-- build/llvm23/mlir_canonicalized/avx512/op/fd_ed25519_point_to.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Firedancer.Avx512

@[expose] public section

mlir_def fd_ed25519_point_to :=
#tbaa_root = #llvm.tbaa_root<id = "Simple C/C++ TBAA">
#tbaa_type_desc = #llvm.tbaa_type_desc<id = "omnipotent char", members = {<#tbaa_root, 0>}>
#tbaa_tag = #llvm.tbaa_tag<base_type = #tbaa_type_desc, access_type = #tbaa_type_desc, offset = 0>
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr, ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], sym_name = "fd_ed25519_point_to", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg80: !llvm.ptr, %arg81: !llvm.ptr, %arg82: !llvm.ptr, %arg83: !llvm.ptr, %arg84: !llvm.ptr):
  %1859 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %1860 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %1861 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %1862 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %1863 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %1864 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %1865 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1866 = "llvm.mlir.poison"() : () -> i64
  %1867 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %1868 = "llvm.mlir.undef"() : () -> vector<8xi64>
  %1869 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %1870 = "llvm.insertelement"(%1868, %1867, %1869) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1871 = "llvm.insertelement"(%1870, %1866, %1865) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1872 = "llvm.insertelement"(%1871, %1867, %1864) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1873 = "llvm.insertelement"(%1872, %1866, %1863) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1874 = "llvm.insertelement"(%1873, %1867, %1862) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1875 = "llvm.insertelement"(%1874, %1866, %1861) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1876 = "llvm.insertelement"(%1875, %1867, %1860) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1877 = "llvm.insertelement"(%1876, %1866, %1859) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1878 = "llvm.insertelement"(%1868, %1866, %1869) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1879 = "llvm.insertelement"(%1878, %1867, %1865) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1880 = "llvm.insertelement"(%1879, %1866, %1864) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1881 = "llvm.insertelement"(%1880, %1867, %1863) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1882 = "llvm.insertelement"(%1881, %1866, %1862) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1883 = "llvm.insertelement"(%1882, %1867, %1861) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1884 = "llvm.insertelement"(%1883, %1866, %1860) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1885 = "llvm.insertelement"(%1884, %1867, %1859) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %1886 = "llvm.load"(%arg84) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %1887 = "llvm.getelementptr"(%arg84) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %1888 = "llvm.load"(%1887) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %1889 = "llvm.getelementptr"(%arg84) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %1890 = "llvm.load"(%1889) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %1891 = "llvm.shufflevector"(%1886, %1888) <{mask = array<i32: 0, 8, 2, 10, 4, 12, 6, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1892 = "llvm.shufflevector"(%1886, %1888) <{mask = array<i32: 1, 9, 3, 11, 5, 13, 7, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1893 = "llvm.shufflevector"(%1890, %1877) <{mask = array<i32: 0, 8, 2, 10, 4, 12, 6, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1894 = "llvm.shufflevector"(%1890, %1885) <{mask = array<i32: 1, 9, 3, 11, 5, 13, 7, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1895 = "llvm.shufflevector"(%1891, %1893) <{mask = array<i32: 0, 1, 8, 4, 5, 12, 9, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1895, %arg80) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1896 = "llvm.shufflevector"(%1892, %1894) <{mask = array<i32: 0, 1, 8, 4, 5, 12, 9, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1896, %arg81) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1897 = "llvm.shufflevector"(%1891, %1893) <{mask = array<i32: 2, 3, 10, 6, 7, 14, 9, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1897, %arg82) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1898 = "llvm.shufflevector"(%1892, %1894) <{mask = array<i32: 2, 3, 10, 6, 7, 14, 9, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1898, %arg83) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end MLIR.Firedancer.Avx512
