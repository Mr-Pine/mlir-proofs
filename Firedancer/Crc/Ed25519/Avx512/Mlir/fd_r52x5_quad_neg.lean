module

-- crc/out/mlirproofs/regions/verify/fd_r52x5_quad_neg.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Firedancer.Crc.Ed25519.Avx512

@[expose] public section

mlir_def fd_r52x5_quad_neg :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr, ptr, ptr, ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "256"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], sym_name = "fd_r52x5_quad_neg", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg179: !llvm.ptr, %arg180: !llvm.ptr, %arg181: !llvm.ptr, %arg182: !llvm.ptr, %arg183: !llvm.ptr, %arg184: vector<4xi64>, %arg185: vector<4xi64>, %arg186: vector<4xi64>, %arg187: vector<4xi64>, %arg188: vector<4xi64>):
  %1519 = "llvm.mlir.constant"() <{value = dense<36028797018963664> : vector<4xi64>}> : () -> vector<4xi64>
  %1520 = "llvm.mlir.constant"() <{value = dense<2251799813685247> : vector<4xi64>}> : () -> vector<4xi64>
  %1521 = "llvm.mlir.constant"() <{value = dense<36028797018963952> : vector<4xi64>}> : () -> vector<4xi64>
  %1522 = "llvm.mlir.constant"() <{value = dense<51> : vector<4xi64>}> : () -> vector<4xi64>
  %1523 = "llvm.mlir.constant"() <{value = dense<19> : vector<4xi64>}> : () -> vector<4xi64>
  %1524 = "llvm.sub"(%1519, %arg184) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1525 = "llvm.and"(%1524, %1520) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1526 = "llvm.sub"(%1521, %arg188) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1527 = "llvm.lshr"(%1526, %1522) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1528 = "llvm.call_intrinsic"(%1525, %1523, %1527) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1529 = "llvm.lshr"(%1524, %1522) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1530 = "llvm.sub"(%1521, %arg185) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1531 = "llvm.and"(%1530, %1520) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1532 = "llvm.add"(%1531, %1529) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1533 = "llvm.lshr"(%1530, %1522) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1534 = "llvm.sub"(%1521, %arg186) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1535 = "llvm.and"(%1534, %1520) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1536 = "llvm.add"(%1535, %1533) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1537 = "llvm.lshr"(%1534, %1522) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1538 = "llvm.sub"(%1521, %arg187) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1539 = "llvm.and"(%1538, %1520) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1540 = "llvm.add"(%1539, %1537) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1541 = "llvm.lshr"(%1538, %1522) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1542 = "llvm.and"(%1526, %1520) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1543 = "llvm.add"(%1542, %1541) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.store"(%1528, %arg179) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.store"(%1532, %arg180) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.store"(%1536, %arg181) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.store"(%1540, %arg182) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.store"(%1543, %arg183) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end MLIR.Firedancer.Crc.Ed25519.Avx512
