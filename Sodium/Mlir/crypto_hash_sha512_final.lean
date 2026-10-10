module

-- sodium-build/out/op/crypto_hash_sha512_final.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Sodium.Mlir.SHA512_Pad
public import Sodium.Mlir.be64enc_vect
public import Sodium.Mlir.sodium_memzero

meta import MLIR.Semantics.Func
meta import Sodium.Mlir.SHA512_Pad
meta import Sodium.Mlir.be64enc_vect
meta import Sodium.Mlir.sodium_memzero

namespace MLIR.Sodium

@[expose] public section

mlir_def crypto_hash_sha512_final :=
"llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writeonly}], dso_local, function_type = !llvm.func<i32 (ptr, ptr)>, linkage = #llvm.linkage<internal>, no_inline, no_unwind, passthrough = ["ssp", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], res_attrs = [{llvm.noundef}], sym_name = "crypto_hash_sha512_final", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg22: !llvm.ptr, %arg23: !llvm.ptr):
  %305 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %306 = "llvm.mlir.constant"() <{value = 64 : i64}> : () -> i64
  %307 = "llvm.mlir.constant"() <{value = 704 : i64}> : () -> i64
  %308 = "llvm.mlir.constant"() <{value = 208 : i64}> : () -> i64
  %309 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %310 = "llvm.alloca"(%305) <{alignment = 16 : i64, elem_type = !llvm.array<88 x i64>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%310) : (!llvm.ptr) -> ()
  "llvm.call"(%arg22, %310) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @SHA512_Pad, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%arg23, %arg22, %306) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @be64enc_vect, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.call"(%310, %307) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @sodium_memzero, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, i64) -> ()
  "llvm.call"(%arg22, %308) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @sodium_memzero, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, i64) -> ()
  "llvm.intr.lifetime.end"(%310) : (!llvm.ptr) -> ()
  "llvm.return"(%309) : (i32) -> ()
}) : () -> ()
  with @SHA512_Pad := SHA512_Pad, @be64enc_vect := be64enc_vect, @sodium_memzero := sodium_memzero

end

end MLIR.Sodium
