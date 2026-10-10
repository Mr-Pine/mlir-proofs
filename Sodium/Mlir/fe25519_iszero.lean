module

-- sodium-build/out/op/fe25519_iszero.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Sodium.Mlir.fe25519_tobytes
public import Sodium.Mlir.sodium_is_zero

meta import MLIR.Semantics.Func
meta import Sodium.Mlir.fe25519_tobytes
meta import Sodium.Mlir.sodium_is_zero

namespace MLIR.Sodium

@[expose] public section

mlir_def fe25519_iszero :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<i32 (ptr)>, linkage = #llvm.linkage<internal>, no_inline, no_unwind, passthrough = ["ssp", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], sym_name = "fe25519_iszero", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg83: !llvm.ptr):
  %2815 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %2816 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %2817 = "llvm.alloca"(%2815) <{alignment = 16 : i64, elem_type = !llvm.array<32 x i8>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%2817) : (!llvm.ptr) -> ()
  "llvm.call"(%2817, %arg83) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fe25519_tobytes, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %2818 = "llvm.call"(%2817, %2816) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @sodium_is_zero, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, i64) -> i32
  "llvm.intr.lifetime.end"(%2817) : (!llvm.ptr) -> ()
  "llvm.return"(%2818) : (i32) -> ()
}) : () -> ()
  with @fe25519_tobytes := fe25519_tobytes, @sodium_is_zero := sodium_is_zero

end

end MLIR.Sodium
