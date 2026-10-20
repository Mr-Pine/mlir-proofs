module

-- crc/out/mlirproofs/regions/verify/fd_r52x5_inv_propose.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Crc.Verify.Extern.bignum_inv_p25519

meta import MLIR.Semantics.Func
meta import Firedancer.Crc.Verify.Extern.bignum_inv_p25519

namespace MLIR.Firedancer.Crc.Verify

@[expose] public section

noncomputable mlir_def fd_r52x5_inv_propose :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, no_inline, no_unwind, passthrough = ["sspstrong", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], sym_name = "fd_r52x5_inv_propose", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg45: !llvm.ptr, %arg46: !llvm.ptr):
  %127 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %128 = "llvm.mlir.constant"() <{value = dense<[0, 13, 26, 39]> : vector<4xi64>}> : () -> vector<4xi64>
  %129 = "llvm.mlir.constant"() <{value = dense<[51, 38, 25, 12]> : vector<4xi64>}> : () -> vector<4xi64>
  %130 = "llvm.mlir.constant"() <{value = 13 : i64}> : () -> i64
  %131 = "llvm.mlir.constant"() <{value = dense<[26, 39]> : vector<2xi64>}> : () -> vector<2xi64>
  %132 = "llvm.mlir.poison"() : () -> vector<4xi64>
  %133 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %134 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %135 = "llvm.mlir.poison"() : () -> vector<2xi64>
  %136 = "llvm.mlir.constant"() <{value = dense<2251799813685247> : vector<4xi64>}> : () -> vector<4xi64>
  %137 = "llvm.mlir.constant"() <{value = 12 : i64}> : () -> i64
  %138 = "llvm.alloca"(%127) <{alignment = 16 : i64, elem_type = !llvm.array<4 x i64>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%138) : (!llvm.ptr) -> ()
  %139 = "llvm.getelementptr"(%arg46) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %140 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %141 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %142 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %143 = "llvm.load"(%arg46) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %144 = "llvm.load"(%139) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %145 = "llvm.lshr"(%143, %128) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %146 = "llvm.shl"(%144, %129) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %147 = "llvm.or"(%146, %145) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.store"(%147, %138) <{alignment = 16 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.call"(%138, %138) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @bignum_inv_p25519, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %148 = "llvm.load"(%138) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %149 = "llvm.load"(%140) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %150 = "llvm.load"(%140) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  %151 = "llvm.intr.fshl"(%149, %148, %130) : (i64, i64, i64) -> i64
  %152 = "llvm.load"(%142) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %153 = "llvm.load"(%141) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  %154 = "llvm.intr.fshl"(%153, %150, %131) : (vector<2xi64>, vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %155 = "llvm.insertelement"(%132, %148, %133) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %156 = "llvm.insertelement"(%155, %151, %134) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %157 = "llvm.shufflevector"(%154, %135) <{mask = array<i32: 0, 1, -1, -1>}> : (vector<2xi64>, vector<2xi64>) -> vector<4xi64>
  %158 = "llvm.shufflevector"(%156, %157) <{mask = array<i32: 0, 1, 4, 5>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %159 = "llvm.and"(%158, %136) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.store"(%159, %arg45) <{alignment = 8 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  %160 = "llvm.lshr"(%152, %137) : (i64, i64) -> i64
  %161 = "llvm.getelementptr"(%arg45) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%160, %161) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%138) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
  with @bignum_inv_p25519 := bignum_inv_p25519

end

end MLIR.Firedancer.Crc.Verify
