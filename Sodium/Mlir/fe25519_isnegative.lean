module

-- sodium-build/out/op/fe25519_isnegative.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Sodium.Mlir.fe25519_tobytes

meta import MLIR.Semantics.Func
meta import Sodium.Mlir.fe25519_tobytes

namespace MLIR.Sodium

@[expose] public section

mlir_def fe25519_isnegative :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<i32 (ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "ssp", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], res_attrs = [{llvm.range = #llvm.constant_range<i32, 0, 2>}], sym_name = "fe25519_isnegative", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg80: !llvm.ptr):
  %2807 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %2808 = "llvm.mlir.constant"() <{value = 1 : i8}> : () -> i8
  %2809 = "llvm.alloca"(%2807) <{alignment = 16 : i64, elem_type = !llvm.array<32 x i8>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%2809) : (!llvm.ptr) -> ()
  "llvm.call"(%2809, %arg80) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fe25519_tobytes, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %2810 = "llvm.load"(%2809) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2811 = "llvm.and"(%2810, %2808) : (i8, i8) -> i8
  %2812 = "llvm.zext"(%2811) <{nonNeg}> : (i8) -> i32
  "llvm.intr.lifetime.end"(%2809) : (!llvm.ptr) -> ()
  "llvm.return"(%2812) : (i32) -> ()
}) : () -> ()
  with @fe25519_tobytes := fe25519_tobytes

end

end MLIR.Sodium
