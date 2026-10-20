module

-- crc/out/mlirproofs/regions/verify/fd_ed25519_verify.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_verify_core

meta import MLIR.Semantics.Func
meta import Firedancer.Crc.Verify.Mlir.fd_r52x5_verify_core

namespace MLIR.Firedancer.Crc.Verify

@[expose] public section

noncomputable mlir_def fd_ed25519_verify :=
"llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<i32 (ptr, i64, ptr, ptr, ptr)>, linkage = #llvm.linkage<external>, no_inline, no_unwind, passthrough = ["sspstrong", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], res_attrs = [{llvm.range = #llvm.constant_range<i32, -3, 1>}], sym_name = "fd_ed25519_verify", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg134: !llvm.ptr, %arg135: i64, %arg136: !llvm.ptr, %arg137: !llvm.ptr, %arg138: !llvm.ptr):
  %692 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %693 = "llvm.mlir.zero"() : () -> !llvm.ptr
  %694 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %695 = "llvm.mlir.constant"() <{value = -3 : i32}> : () -> i32
  %696 = "llvm.alloca"(%692) <{alignment = 4 : i64, elem_type = i32}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%696) : (!llvm.ptr) -> ()
  "llvm.store"(%692, %696) <{alignment = 4 : i64, ordering = 0 : i64}> : (i32, !llvm.ptr) -> ()
  %697 = "llvm.call"(%arg134, %arg135, %arg136, %arg137, %arg138, %693, %696, %693) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_verify_core, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 8, 0>}> : (!llvm.ptr, i64, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> i32
  %698 = "llvm.icmp"(%697, %694) <{predicate = 0 : i64}> : (i32, i32) -> i1
  %699 = "llvm.load"(%696) <{alignment = 4 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %700 = "llvm.icmp"(%699, %694) <{predicate = 0 : i64}> : (i32, i32) -> i1
  %701 = "llvm.select"(%700, %695, %694) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i32, i32) -> i32
  %702 = "llvm.select"(%698, %701, %697) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i32, i32) -> i32
  "llvm.intr.lifetime.end"(%696) : (!llvm.ptr) -> ()
  "llvm.return"(%702) : (i32) -> ()
}) : () -> ()
  with @fd_r52x5_verify_core := fd_r52x5_verify_core

end

end MLIR.Firedancer.Crc.Verify
