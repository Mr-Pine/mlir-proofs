module

-- sodium-build/out/op/fe25519_tobytes.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Sodium.Mlir.fe25519_reduce
public import Sodium.Mlir.store64_le

meta import MLIR.Semantics.Func
meta import Sodium.Mlir.fe25519_reduce
meta import Sodium.Mlir.store64_le

namespace MLIR.Sodium

@[expose] public section

mlir_def fe25519_tobytes :=
"llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "ssp", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], sym_name = "fe25519_tobytes", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg107: !llvm.ptr, %arg108: !llvm.ptr):
  %3220 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %3221 = "llvm.mlir.constant"() <{value = 51 : i64}> : () -> i64
  %3222 = "llvm.mlir.constant"() <{value = 13 : i64}> : () -> i64
  %3223 = "llvm.mlir.constant"() <{value = 38 : i64}> : () -> i64
  %3224 = "llvm.mlir.constant"() <{value = 26 : i64}> : () -> i64
  %3225 = "llvm.mlir.constant"() <{value = 25 : i64}> : () -> i64
  %3226 = "llvm.mlir.constant"() <{value = 39 : i64}> : () -> i64
  %3227 = "llvm.mlir.constant"() <{value = 12 : i64}> : () -> i64
  %3228 = "llvm.alloca"(%3220) <{alignment = 16 : i64, elem_type = !llvm.array<5 x i64>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%3228) : (!llvm.ptr) -> ()
  "llvm.call"(%3228, %arg108) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fe25519_reduce, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %3229 = "llvm.load"(%3228) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3230 = "llvm.getelementptr"(%3228) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %3231 = "llvm.load"(%3230) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3232 = "llvm.shl"(%3231, %3221) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %3233 = "llvm.or"(%3232, %3229) : (i64, i64) -> i64
  %3234 = "llvm.lshr"(%3231, %3222) : (i64, i64) -> i64
  %3235 = "llvm.getelementptr"(%3228) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %3236 = "llvm.load"(%3235) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3237 = "llvm.shl"(%3236, %3223) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %3238 = "llvm.or"(%3237, %3234) : (i64, i64) -> i64
  %3239 = "llvm.lshr"(%3236, %3224) : (i64, i64) -> i64
  %3240 = "llvm.getelementptr"(%3228) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %3241 = "llvm.load"(%3240) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3242 = "llvm.shl"(%3241, %3225) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %3243 = "llvm.or"(%3242, %3239) : (i64, i64) -> i64
  %3244 = "llvm.lshr"(%3241, %3226) : (i64, i64) -> i64
  %3245 = "llvm.getelementptr"(%3228) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %3246 = "llvm.load"(%3245) <{alignment = 16 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %3247 = "llvm.shl"(%3246, %3227) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %3248 = "llvm.or"(%3247, %3244) : (i64, i64) -> i64
  "llvm.call"(%arg107, %3233) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @store64_le, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, i64) -> ()
  %3249 = "llvm.getelementptr"(%arg107) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%3249, %3238) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @store64_le, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, i64) -> ()
  %3250 = "llvm.getelementptr"(%arg107) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%3250, %3243) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @store64_le, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, i64) -> ()
  %3251 = "llvm.getelementptr"(%arg107) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%3251, %3248) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @store64_le, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, i64) -> ()
  "llvm.intr.lifetime.end"(%3228) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
  with @fe25519_reduce := fe25519_reduce, @store64_le := store64_le

end

end MLIR.Sodium
