"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 8 : i64, llvm.dead_on_unwind, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writable, llvm.writeonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], sym_name = "_RNvXs6_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u645fieldRNtB5_14FieldElement51NtNtNtCsgxBkk5gSRhY_4core3ops5arith3Neg3neg", target_cpu = "x86-64-v2", target_features = #llvm.target_features<["+avx", "+avx2", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+crc32", "+ssse3"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg41: !llvm.ptr, %arg42: !llvm.ptr):
  %1917 = "llvm.mlir.constant"() <{value = dense<[36028797018963664, 36028797018963952, 36028797018963952, 36028797018963952]> : vector<4xi64>}> : () -> vector<4xi64>
  %1918 = "llvm.mlir.constant"() <{value = dense<36028797018963952> : vector<4xi64>}> : () -> vector<4xi64>
  %1919 = "llvm.mlir.constant"() <{value = dense<51> : vector<4xi64>}> : () -> vector<4xi64>
  %1920 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %1921 = "llvm.mlir.constant"() <{value = 51 : i64}> : () -> i64
  %1922 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %1923 = "llvm.mlir.constant"() <{value = 2251799813685247 : i64}> : () -> i64
  %1924 = "llvm.mlir.constant"() <{value = dense<2251799813685247> : vector<4xi64>}> : () -> vector<4xi64>
  %1925 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %1926 = "llvm.getelementptr"(%arg42) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %1927 = "llvm.getelementptr"(%arg41) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %1928 = "llvm.load"(%arg42) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1929 = "llvm.load"(%1926) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1930 = "llvm.sub"(%1917, %1928) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1931 = "llvm.sub"(%1918, %1929) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1932 = "llvm.lshr"(%1930, %1919) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1933 = "llvm.extractelement"(%1931, %1920) : (vector<4xi64>, i64) -> i64
  %1934 = "llvm.lshr"(%1933, %1921) : (i64, i64) -> i64
  %1935 = "llvm.extractelement"(%1930, %1922) : (vector<4xi64>, i64) -> i64
  %1936 = "llvm.and"(%1935, %1923) : (i64, i64) -> i64
  %1937 = "llvm.and"(%1931, %1924) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1938 = "llvm.mul"(%1934, %1925) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1939 = "llvm.add"(%1938, %1936) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1940 = "llvm.add"(%1937, %1932) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.store"(%1939, %arg41) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.store"(%1940, %1927) <{alignment = 8 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
