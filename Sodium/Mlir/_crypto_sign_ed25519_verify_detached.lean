module

-- sodium-build/out/op/_crypto_sign_ed25519_verify_detached.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Sodium.Mlir._crypto_sign_ed25519_ref10_hinit
public import Sodium.Mlir.crypto_hash_sha512_final
public import Sodium.Mlir.crypto_hash_sha512_update
public import Sodium.Mlir.crypto_verify_32
public import Sodium.Mlir.ge25519_double_scalarmult_vartime
public import Sodium.Mlir.ge25519_frombytes_negate_vartime
public import Sodium.Mlir.ge25519_has_small_order
public import Sodium.Mlir.ge25519_is_canonical
public import Sodium.Mlir.ge25519_tobytes
public import Sodium.Mlir.sc25519_is_canonical
public import Sodium.Mlir.sc25519_reduce
public import Sodium.Mlir.sodium_memcmp

meta import MLIR.Semantics.Func
meta import Sodium.Mlir._crypto_sign_ed25519_ref10_hinit
meta import Sodium.Mlir.crypto_hash_sha512_final
meta import Sodium.Mlir.crypto_hash_sha512_update
meta import Sodium.Mlir.crypto_verify_32
meta import Sodium.Mlir.ge25519_double_scalarmult_vartime
meta import Sodium.Mlir.ge25519_frombytes_negate_vartime
meta import Sodium.Mlir.ge25519_has_small_order
meta import Sodium.Mlir.ge25519_is_canonical
meta import Sodium.Mlir.ge25519_tobytes
meta import Sodium.Mlir.sc25519_is_canonical
meta import Sodium.Mlir.sc25519_reduce
meta import Sodium.Mlir.sodium_memcmp

namespace MLIR.Sodium

@[expose] public section

mlir_def _crypto_sign_ed25519_verify_detached :=
"llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], dso_local, function_type = !llvm.func<i32 (ptr, ptr, i64, ptr, i32)>, linkage = #llvm.linkage<internal>, no_inline, no_unwind, passthrough = ["ssp", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], sym_name = "_crypto_sign_ed25519_verify_detached", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg118: !llvm.ptr, %arg119: !llvm.ptr, %arg120: i64, %arg121: !llvm.ptr, %arg122: i32):
  %3288 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %3289 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %3290 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %3291 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
  %3292 = "llvm.alloca"(%3288) <{alignment = 8 : i64, elem_type = !llvm.struct<"struct.crypto_hash_sha512_state", (array<8 x i64>, array<2 x i64>, array<128 x i8>)>}> : (i32) -> !llvm.ptr
  %3293 = "llvm.alloca"(%3288) <{alignment = 16 : i64, elem_type = !llvm.array<64 x i8>}> : (i32) -> !llvm.ptr
  %3294 = "llvm.alloca"(%3288) <{alignment = 16 : i64, elem_type = !llvm.array<32 x i8>}> : (i32) -> !llvm.ptr
  %3295 = "llvm.alloca"(%3288) <{alignment = 8 : i64, elem_type = !llvm.struct<"struct.ge25519_p3", (array<5 x i64>, array<5 x i64>, array<5 x i64>, array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %3296 = "llvm.alloca"(%3288) <{alignment = 8 : i64, elem_type = !llvm.struct<"struct.ge25519_p2", (array<5 x i64>, array<5 x i64>, array<5 x i64>)>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%3292) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3293) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3294) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3295) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%3296) : (!llvm.ptr) -> ()
  "llvm.fence"() <{ordering = 4 : i64}> : () -> ()
  %3297 = "llvm.getelementptr"(%arg118) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %3298 = "llvm.call"(%3297) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @sc25519_is_canonical, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i32
  %3299 = "llvm.icmp"(%3298, %3290) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%3299, %3291)[^bb6, ^bb1] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i32) -> ()
^bb1:  // pred: ^bb0
  %3300 = "llvm.call"(%arg118) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @ge25519_has_small_order, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i32
  %3301 = "llvm.icmp"(%3300, %3290) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%3301, %3291)[^bb2, ^bb6] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb2:  // pred: ^bb1
  %3302 = "llvm.call"(%arg121) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @ge25519_is_canonical, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i32
  %3303 = "llvm.icmp"(%3302, %3290) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%3303, %3291)[^bb6, ^bb3] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i32) -> ()
^bb3:  // pred: ^bb2
  %3304 = "llvm.call"(%arg121) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @ge25519_has_small_order, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i32
  %3305 = "llvm.icmp"(%3304, %3290) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%3305, %3291)[^bb4, ^bb6] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb4:  // pred: ^bb3
  %3306 = "llvm.call"(%3295, %arg121) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @ge25519_frombytes_negate_vartime, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> i32
  %3307 = "llvm.icmp"(%3306, %3290) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%3307, %3291)[^bb5, ^bb6] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb5:  // pred: ^bb4
  "llvm.call"(%3292, %arg122) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @_crypto_sign_ed25519_ref10_hinit, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, i32) -> ()
  %3308 = "llvm.call"(%3292, %arg118, %3289) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crypto_hash_sha512_update, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> i32
  %3309 = "llvm.call"(%3292, %arg121, %3289) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crypto_hash_sha512_update, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> i32
  %3310 = "llvm.call"(%3292, %arg119, %arg120) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @crypto_hash_sha512_update, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> i32
  %3311 = "llvm.call"(%3292, %3293) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @crypto_hash_sha512_final, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> i32
  "llvm.call"(%3293) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @sc25519_reduce, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> ()
  "llvm.call"(%3296, %3293, %3295, %3297) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @ge25519_double_scalarmult_vartime, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%3294, %3296) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @ge25519_tobytes, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %3312 = "llvm.call"(%3294, %arg118) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @crypto_verify_32, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = read, argMem = read, inaccessibleMem = readwrite, errnoMem = read, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> i32
  %3313 = "llvm.icmp"(%3294, %arg118) <{predicate = 0 : i64}> : (!llvm.ptr, !llvm.ptr) -> i1
  %3314 = "llvm.select"(%3313, %3291, %3312) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i32, i32) -> i32
  %3315 = "llvm.call"(%arg118, %3294, %3289) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @sodium_memcmp, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> i32
  %3316 = "llvm.or"(%3314, %3315) : (i32, i32) -> i32
  "llvm.br"(%3316)[^bb6] : (i32) -> ()
^bb6(%3317: i32):  // 6 preds: ^bb0, ^bb1, ^bb2, ^bb3, ^bb4, ^bb5
  "llvm.intr.lifetime.end"(%3296) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3295) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3294) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3293) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%3292) : (!llvm.ptr) -> ()
  "llvm.return"(%3317) : (i32) -> ()
}) : () -> ()
  with @_crypto_sign_ed25519_ref10_hinit := _crypto_sign_ed25519_ref10_hinit,
    @crypto_hash_sha512_final := crypto_hash_sha512_final,
    @crypto_hash_sha512_update := crypto_hash_sha512_update, @crypto_verify_32 := crypto_verify_32,
    @ge25519_double_scalarmult_vartime := ge25519_double_scalarmult_vartime,
    @ge25519_frombytes_negate_vartime := ge25519_frombytes_negate_vartime,
    @ge25519_has_small_order := ge25519_has_small_order,
    @ge25519_is_canonical := ge25519_is_canonical, @ge25519_tobytes := ge25519_tobytes,
    @sc25519_is_canonical := sc25519_is_canonical, @sc25519_reduce := sc25519_reduce,
    @sodium_memcmp := sodium_memcmp

end

end MLIR.Sodium
