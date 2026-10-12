"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 8 : i64, llvm.dead_on_unwind, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writable, llvm.writeonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], sym_name = "_RNvXs6_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u645fieldRNtB5_14FieldElement51NtNtNtCsgxBkk5gSRhY_4core3ops5arith3Neg3neg", target_cpu = "x86-64-v2", target_features = #llvm.target_features<["+avx", "+avx2", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+crc32", "+ssse3"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg87: !llvm.ptr, %arg88: !llvm.ptr):
  %3037 = "llvm.mlir.constant"() <{value = dense<[36028797018963664, 36028797018963952, 36028797018963952, 36028797018963952]> : vector<4xi64>}> : () -> vector<4xi64>
  %3038 = "llvm.mlir.constant"() <{value = dense<36028797018963952> : vector<4xi64>}> : () -> vector<4xi64>
  %3039 = "llvm.mlir.constant"() <{value = dense<51> : vector<4xi64>}> : () -> vector<4xi64>
  %3040 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %3041 = "llvm.mlir.constant"() <{value = 51 : i64}> : () -> i64
  %3042 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %3043 = "llvm.mlir.constant"() <{value = 2251799813685247 : i64}> : () -> i64
  %3044 = "llvm.mlir.constant"() <{value = dense<2251799813685247> : vector<4xi64>}> : () -> vector<4xi64>
  %3045 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %3046 = "llvm.getelementptr"(%arg88) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %3047 = "llvm.getelementptr"(%arg87) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %3048 = "llvm.load"(%arg88) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3049 = "llvm.load"(%3046) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %3050 = "llvm.sub"(%3037, %3048) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3051 = "llvm.sub"(%3038, %3049) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3052 = "llvm.lshr"(%3050, %3039) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3053 = "llvm.extractelement"(%3051, %3040) : (vector<4xi64>, i64) -> i64
  %3054 = "llvm.lshr"(%3053, %3041) : (i64, i64) -> i64
  %3055 = "llvm.extractelement"(%3050, %3042) : (vector<4xi64>, i64) -> i64
  %3056 = "llvm.and"(%3055, %3043) : (i64, i64) -> i64
  %3057 = "llvm.and"(%3051, %3044) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %3058 = "llvm.mul"(%3054, %3045) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %3059 = "llvm.add"(%3058, %3056) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %3060 = "llvm.add"(%3057, %3052) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.store"(%3059, %arg87) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.store"(%3060, %3047) <{alignment = 8 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
