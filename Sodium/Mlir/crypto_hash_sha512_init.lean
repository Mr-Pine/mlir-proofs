module

-- sodium-build/out/op/crypto_hash_sha512_init.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Sodium.Mlir.crypto_hash_sha512_init_sha512_initial_state

meta import MLIR.Semantics.Func
meta import Sodium.Mlir.crypto_hash_sha512_init_sha512_initial_state

namespace MLIR.Sodium

@[expose] public section

mlir_def crypto_hash_sha512_init :=
"llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nonnull, llvm.noundef}], dso_local, function_type = !llvm.func<i32 (ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "ssp", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], res_attrs = [{llvm.noundef}], sym_name = "crypto_hash_sha512_init", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg36: !llvm.ptr):
  %1516 = "llvm.mlir.constant"() <{value = 64 : i64}> : () -> i64
  %1517 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %1518 = "llvm.mlir.constant"() <{value = 16 : i64}> : () -> i64
  %1519 = "llvm.mlir.addressof"() <{global_name = @crypto_hash_sha512_init.sha512_initial_state}> : () -> !llvm.ptr
  %1520 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %1521 = "llvm.getelementptr"(%arg36) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memset"(%1521, %1517, %1518) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 16 : i64, llvm.nonnull, llvm.noundef}, {}, {}], isVolatile = false}> : (!llvm.ptr, i8, i64) -> ()
  "llvm.intr.memcpy"(%arg36, %1519, %1516) <{arg_attrs = [{llvm.align = 1 : i64, llvm.dereferenceable = 64 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 16 : i64, llvm.dereferenceable = 64 : i64, llvm.nonnull, llvm.noundef}, {llvm.noundef}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.return"(%1520) : (i32) -> ()
}) : () -> ()
  with @crypto_hash_sha512_init.sha512_initial_state := crypto_hash_sha512_init_sha512_initial_state

end

end MLIR.Sodium
