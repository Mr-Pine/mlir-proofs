module

-- sodium-build/out/op/ge25519_tobytes.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Sodium.Mlir.fe25519_invert
public import Sodium.Mlir.fe25519_isnegative
public import Sodium.Mlir.fe25519_mul
public import Sodium.Mlir.fe25519_tobytes

meta import MLIR.Semantics.Func
meta import Sodium.Mlir.fe25519_invert
meta import Sodium.Mlir.fe25519_isnegative
meta import Sodium.Mlir.fe25519_mul
meta import Sodium.Mlir.fe25519_tobytes

namespace MLIR.Sodium

@[expose] public section

mlir_def ge25519_tobytes :=
"llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "ssp", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], sym_name = "ge25519_tobytes", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg64: !llvm.ptr, %arg65: !llvm.ptr):
  %2736 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %2737 = "llvm.mlir.constant"() <{value = 7 : i8}> : () -> i8
  %2738 = "llvm.alloca"(%2736) <{alignment = 16 : i64, elem_type = !llvm.array<5 x i64>}> : (i32) -> !llvm.ptr
  %2739 = "llvm.alloca"(%2736) <{alignment = 16 : i64, elem_type = !llvm.array<5 x i64>}> : (i32) -> !llvm.ptr
  %2740 = "llvm.alloca"(%2736) <{alignment = 16 : i64, elem_type = !llvm.array<5 x i64>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%2738) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2739) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2740) : (!llvm.ptr) -> ()
  %2741 = "llvm.getelementptr"(%arg65) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 80>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%2738, %2741) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fe25519_invert, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%2739, %arg65, %2738) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fe25519_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  %2742 = "llvm.getelementptr"(%arg65) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%2740, %2742, %2738) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fe25519_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%arg64, %2740) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fe25519_tobytes, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %2743 = "llvm.call"(%2739) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @fe25519_isnegative, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i32
  %2744 = "llvm.getelementptr"(%arg64) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 31>}> : (!llvm.ptr) -> !llvm.ptr
  %2745 = "llvm.load"(%2744) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2746 = "llvm.trunc"(%2743) <{overflowFlags = 3 : i32}> : (i32) -> i8
  %2747 = "llvm.shl"(%2746, %2737) <{overflowFlags = 2 : i32}> : (i8, i8) -> i8
  %2748 = "llvm.xor"(%2747, %2745) : (i8, i8) -> i8
  "llvm.store"(%2748, %2744) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2740) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2739) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2738) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
  with @fe25519_invert := fe25519_invert, @fe25519_isnegative := fe25519_isnegative,
    @fe25519_mul := fe25519_mul, @fe25519_tobytes := fe25519_tobytes

end

end MLIR.Sodium
