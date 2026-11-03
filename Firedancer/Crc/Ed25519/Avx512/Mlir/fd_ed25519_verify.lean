module

-- crc/out/mlirproofs/regions/verify/fd_ed25519_verify.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_ed25519_crc_verify_core

meta import MLIR.Semantics.Func
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_ed25519_crc_verify_core

namespace MLIR.Firedancer.Crc.Ed25519.Avx512

@[expose] public section

noncomputable mlir_def fd_ed25519_verify :=
"llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<i32 (ptr, i64, ptr, ptr, ptr)>, linkage = #llvm.linkage<external>, no_inline, no_unwind, passthrough = ["sspstrong", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], res_attrs = [{llvm.range = #llvm.constant_range<i32, -3, 1>}], sym_name = "fd_ed25519_verify", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg170: !llvm.ptr, %arg171: i64, %arg172: !llvm.ptr, %arg173: !llvm.ptr, %arg174: !llvm.ptr):
  %1251 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1252 = "llvm.mlir.zero"() : () -> !llvm.ptr
  %1253 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %1254 = "llvm.mlir.constant"() <{value = -3 : i32}> : () -> i32
  %1255 = "llvm.alloca"(%1251) <{alignment = 4 : i64, elem_type = i32}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%1255) : (!llvm.ptr) -> ()
  "llvm.store"(%1251, %1255) <{alignment = 4 : i64, ordering = 0 : i64}> : (i32, !llvm.ptr) -> ()
  %1256 = "llvm.call"(%arg170, %arg171, %arg172, %arg173, %arg174, %1252, %1255, %1252) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_crc_verify_core, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 8, 0>}> : (!llvm.ptr, i64, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> i32
  %1257 = "llvm.icmp"(%1256, %1253) <{predicate = 0 : i64}> : (i32, i32) -> i1
  %1258 = "llvm.load"(%1255) <{alignment = 4 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %1259 = "llvm.icmp"(%1258, %1253) <{predicate = 0 : i64}> : (i32, i32) -> i1
  %1260 = "llvm.select"(%1259, %1254, %1253) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i32, i32) -> i32
  %1261 = "llvm.select"(%1257, %1260, %1256) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i32, i32) -> i32
  "llvm.intr.lifetime.end"(%1255) : (!llvm.ptr) -> ()
  "llvm.return"(%1261) : (i32) -> ()
}) : () -> ()
  with @fd_ed25519_crc_verify_core := fd_ed25519_crc_verify_core

end

end MLIR.Firedancer.Crc.Ed25519.Avx512
