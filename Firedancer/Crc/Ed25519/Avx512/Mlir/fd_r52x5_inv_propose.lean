module

-- crc/out/mlirproofs/regions/verify/fd_r52x5_inv_propose.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Crc.Ed25519.Extern.bignum_inv_p25519

meta import MLIR.Semantics.Func
meta import Firedancer.Crc.Ed25519.Extern.bignum_inv_p25519

namespace MLIR.Firedancer.Crc.Ed25519.Avx512

@[expose] public section

noncomputable mlir_def fd_r52x5_inv_propose :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, no_inline, no_unwind, passthrough = ["sspstrong", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], sym_name = "fd_r52x5_inv_propose", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg118: !llvm.ptr, %arg119: !llvm.ptr):
  %539 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %540 = "llvm.mlir.constant"() <{value = dense<[0, 13, 26, 39]> : vector<4xi64>}> : () -> vector<4xi64>
  %541 = "llvm.mlir.constant"() <{value = dense<[51, 38, 25, 12]> : vector<4xi64>}> : () -> vector<4xi64>
  %542 = "llvm.mlir.constant"() <{value = 13 : i64}> : () -> i64
  %543 = "llvm.mlir.constant"() <{value = dense<[26, 39]> : vector<2xi64>}> : () -> vector<2xi64>
  %544 = "llvm.mlir.poison"() : () -> vector<4xi64>
  %545 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %546 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %547 = "llvm.mlir.poison"() : () -> vector<2xi64>
  %548 = "llvm.mlir.constant"() <{value = dense<2251799813685247> : vector<4xi64>}> : () -> vector<4xi64>
  %549 = "llvm.mlir.constant"() <{value = 12 : i64}> : () -> i64
  %550 = "llvm.alloca"(%539) <{alignment = 16 : i64, elem_type = !llvm.array<4 x i64>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%550) : (!llvm.ptr) -> ()
  %551 = "llvm.getelementptr"(%arg119) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %552 = "llvm.getelementptr"(%550) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %553 = "llvm.getelementptr"(%550) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %554 = "llvm.getelementptr"(%550) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %555 = "llvm.load"(%arg119) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %556 = "llvm.load"(%551) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %557 = "llvm.lshr"(%555, %540) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %558 = "llvm.shl"(%556, %541) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %559 = "llvm.or"(%558, %557) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.store"(%559, %550) <{alignment = 16 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.call"(%550, %550) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @bignum_inv_p25519, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %560 = "llvm.load"(%550) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %561 = "llvm.load"(%552) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %562 = "llvm.load"(%552) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  %563 = "llvm.intr.fshl"(%561, %560, %542) : (i64, i64, i64) -> i64
  %564 = "llvm.load"(%554) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %565 = "llvm.load"(%553) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  %566 = "llvm.intr.fshl"(%565, %562, %543) : (vector<2xi64>, vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %567 = "llvm.insertelement"(%544, %560, %545) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %568 = "llvm.insertelement"(%567, %563, %546) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %569 = "llvm.shufflevector"(%566, %547) <{mask = array<i32: 0, 1, -1, -1>}> : (vector<2xi64>, vector<2xi64>) -> vector<4xi64>
  %570 = "llvm.shufflevector"(%568, %569) <{mask = array<i32: 0, 1, 4, 5>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %571 = "llvm.and"(%570, %548) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.store"(%571, %arg118) <{alignment = 8 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %572 = "llvm.lshr"(%564, %549) : (i64, i64) -> i64
  %573 = "llvm.getelementptr"(%arg118) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%572, %573) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%550) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
  with @bignum_inv_p25519 := bignum_inv_p25519

end

end MLIR.Firedancer.Crc.Ed25519.Avx512
