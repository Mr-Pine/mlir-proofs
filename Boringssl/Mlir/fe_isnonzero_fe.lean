module

-- boringssl-build/out/op/_ZL12fe_isnonzeroPKN4bssl2feE.mlir
-- fe_isnonzero(bssl::fe const*)

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Boringssl.Mlir.CRYPTO_memcmp
public import Boringssl.Mlir.fe_tobytes
public import Boringssl.Mlir.fe_isnonzero_zero

meta import MLIR.Semantics.Func
meta import Boringssl.Mlir.CRYPTO_memcmp
meta import Boringssl.Mlir.fe_tobytes
meta import Boringssl.Mlir.fe_isnonzero_zero

namespace MLIR.Boringssl

@[expose] public section

mlir_def fe_isnonzero_fe :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<i32 (ptr)>, linkage = #llvm.linkage<internal>, no_inline, no_unwind, passthrough = ["mustprogress", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"], ["warn-stack-size", "25344"]], res_attrs = [{llvm.noundef, llvm.range = #llvm.constant_range<i32, 0, 2>}], sym_name = "_ZL12fe_isnonzeroPKN4bssl2feE", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg99: !llvm.ptr):
  %1444 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1445 = "llvm.mlir.addressof"() <{global_name = @_ZZL12fe_isnonzeroPKN4bssl2feEE4zero}> : () -> !llvm.ptr
  %1446 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %1447 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %1448 = "llvm.alloca"(%1444) <{alignment = 16 : i64, elem_type = !llvm.array<32 x i8>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%1448) : (!llvm.ptr) -> ()
  "llvm.call"(%1448, %arg99) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZL10fe_tobytesPhPKN4bssl2feE, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %1449 = "llvm.call"(%1448, %1445, %1446) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @CRYPTO_memcmp, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> i32
  %1450 = "llvm.icmp"(%1449, %1447) <{predicate = 1 : i64}> : (i32, i32) -> i1
  %1451 = "llvm.zext"(%1450) : (i1) -> i32
  "llvm.intr.lifetime.end"(%1448) : (!llvm.ptr) -> ()
  "llvm.return"(%1451) : (i32) -> ()
}) : () -> ()
  with @CRYPTO_memcmp := CRYPTO_memcmp, @_ZL10fe_tobytesPhPKN4bssl2feE := fe_tobytes,
    @_ZZL12fe_isnonzeroPKN4bssl2feEE4zero := fe_isnonzero_zero

end

end MLIR.Boringssl
