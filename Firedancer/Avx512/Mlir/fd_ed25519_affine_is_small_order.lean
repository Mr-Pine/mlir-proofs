module

-- build/llvm23/mlir_canonicalized/avx512/op/fd_ed25519_affine_is_small_order.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Avx512.Mlir.fd_ed25519_point_to
public import Firedancer.Avx512.Mlir.fd_f25519_eq
public import Firedancer.Avx512.Mlir.fd_f25519_is_zero
public import Firedancer.Avx512.Mlir.fd_ed25519_order8_point_y0
public import Firedancer.Avx512.Mlir.fd_ed25519_order8_point_y1

meta import MLIR.Semantics.Func
meta import Firedancer.Avx512.Mlir.fd_ed25519_point_to
meta import Firedancer.Avx512.Mlir.fd_f25519_eq
meta import Firedancer.Avx512.Mlir.fd_f25519_is_zero
meta import Firedancer.Avx512.Mlir.fd_ed25519_order8_point_y0
meta import Firedancer.Avx512.Mlir.fd_ed25519_order8_point_y1

namespace MLIR.Firedancer.Avx512

@[expose] public section

mlir_def fd_ed25519_affine_is_small_order :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<i32 (ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], res_attrs = [{llvm.range = #llvm.constant_range<i32, 0, 2>}], sym_name = "fd_ed25519_affine_is_small_order", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg44: !llvm.ptr):
  %659 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %660 = "llvm.mlir.addressof"() <{global_name = @fd_ed25519_order8_point_y0}> : () -> !llvm.ptr
  %661 = "llvm.mlir.addressof"() <{global_name = @fd_ed25519_order8_point_y1}> : () -> !llvm.ptr
  %662 = "llvm.alloca"(%659) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %663 = "llvm.alloca"(%659) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %664 = "llvm.alloca"(%659) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %665 = "llvm.alloca"(%659) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%662) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%663) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%664) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%665) : (!llvm.ptr) -> ()
  "llvm.call"(%662, %663, %664, %665, %arg44) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_ed25519_point_to, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  %666 = "llvm.call"(%662) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_f25519_is_zero, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i32
  %667 = "llvm.call"(%663) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_f25519_is_zero, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i32
  %668 = "llvm.or"(%667, %666) : (i32, i32) -> i32
  %669 = "llvm.call"(%663, %660) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_f25519_eq, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> i32
  %670 = "llvm.or"(%668, %669) : (i32, i32) -> i32
  %671 = "llvm.call"(%663, %661) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_f25519_eq, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> i32
  %672 = "llvm.or"(%670, %671) : (i32, i32) -> i32
  "llvm.intr.lifetime.end"(%665) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%664) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%663) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%662) : (!llvm.ptr) -> ()
  "llvm.return"(%672) : (i32) -> ()
}) : () -> ()
  with @fd_ed25519_point_to := fd_ed25519_point_to, @fd_f25519_eq := fd_f25519_eq,
    @fd_f25519_is_zero := fd_f25519_is_zero,
    @fd_ed25519_order8_point_y0 := fd_ed25519_order8_point_y0,
    @fd_ed25519_order8_point_y1 := fd_ed25519_order8_point_y1

end

end MLIR.Firedancer.Avx512
