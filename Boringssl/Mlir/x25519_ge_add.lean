module

-- boringssl-build/out/op/_ZN4bssl13x25519_ge_addEPNS_7ge_p1p1EPKNS_5ge_p3EPKNS_9ge_cachedE.mlir
-- bssl::x25519_ge_add(bssl::ge_p1p1*, bssl::ge_p3 const*, bssl::ge_cached const*)

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Boringssl.Mlir.fe_mul_tll
public import Boringssl.Mlir.fe_mul_tlt
public import Boringssl.Mlir.fe_mul_ttl
public import Boringssl.Mlir.fe_add
public import Boringssl.Mlir.fe_sub
public import Boringssl.Mlir.fe_carry

meta import MLIR.Semantics.Func
meta import Boringssl.Mlir.fe_mul_tll
meta import Boringssl.Mlir.fe_mul_tlt
meta import Boringssl.Mlir.fe_mul_ttl
meta import Boringssl.Mlir.fe_add
meta import Boringssl.Mlir.fe_sub
meta import Boringssl.Mlir.fe_carry

namespace MLIR.Boringssl

@[expose] public section

mlir_def x25519_ge_add :=
"llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"], ["warn-stack-size", "25344"]], sym_name = "_ZN4bssl13x25519_ge_addEPNS_7ge_p1p1EPKNS_5ge_p3EPKNS_9ge_cachedE", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg66: !llvm.ptr, %arg67: !llvm.ptr, %arg68: !llvm.ptr):
  %1145 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1146 = "llvm.alloca"(%1145) <{alignment = 8 : i64, elem_type = !llvm.struct<"struct.bssl::fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %1147 = "llvm.alloca"(%1145) <{alignment = 8 : i64, elem_type = !llvm.struct<"struct.bssl::fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %1148 = "llvm.alloca"(%1145) <{alignment = 8 : i64, elem_type = !llvm.struct<"struct.bssl::fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %1149 = "llvm.alloca"(%1145) <{alignment = 8 : i64, elem_type = !llvm.struct<"struct.bssl::fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%1146) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1147) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1148) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1149) : (!llvm.ptr) -> ()
  %1150 = "llvm.getelementptr"(%arg67) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%arg66, %1150, %arg67) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @_ZL6fe_addPN4bssl8fe_looseEPKNS_2feES4_, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  %1151 = "llvm.getelementptr"(%arg66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%1151, %1150, %arg67) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @_ZL6fe_subPN4bssl8fe_looseEPKNS_2feES4_, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%1148, %arg66, %arg68) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @_ZL10fe_mul_tllPN4bssl2feEPKNS_8fe_looseES4_, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  %1152 = "llvm.getelementptr"(%arg68) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%1147, %1151, %1152) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZL10fe_mul_tllPN4bssl2feEPKNS_8fe_looseES4_, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  %1153 = "llvm.getelementptr"(%arg68) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 120>}> : (!llvm.ptr) -> !llvm.ptr
  %1154 = "llvm.getelementptr"(%arg67) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 120>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%1149, %1153, %1154) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZL10fe_mul_tltPN4bssl2feEPKNS_8fe_looseEPKS0_, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  %1155 = "llvm.getelementptr"(%arg67) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 80>}> : (!llvm.ptr) -> !llvm.ptr
  %1156 = "llvm.getelementptr"(%arg68) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 80>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%1146, %1155, %1156) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZL10fe_mul_ttlPN4bssl2feEPKS0_PKNS_8fe_looseE, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  %1157 = "llvm.getelementptr"(%arg66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 120>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%1157, %1146, %1146) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZL6fe_addPN4bssl8fe_looseEPKNS_2feES4_, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%arg66, %1148, %1147) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZL6fe_subPN4bssl8fe_looseEPKNS_2feES4_, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%1151, %1148, %1147) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZL6fe_addPN4bssl8fe_looseEPKNS_2feES4_, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%1148, %1157) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZL8fe_carryPN4bssl2feEPKNS_8fe_looseE, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %1158 = "llvm.getelementptr"(%arg66) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 80>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%1158, %1148, %1149) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZL6fe_addPN4bssl8fe_looseEPKNS_2feES4_, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%1157, %1148, %1149) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZL6fe_subPN4bssl8fe_looseEPKNS_2feES4_, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1149) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1148) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1147) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1146) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
  with @_ZL10fe_mul_tllPN4bssl2feEPKNS_8fe_looseES4_ := fe_mul_tll,
    @_ZL10fe_mul_tltPN4bssl2feEPKNS_8fe_looseEPKS0_ := fe_mul_tlt,
    @_ZL10fe_mul_ttlPN4bssl2feEPKS0_PKNS_8fe_looseE := fe_mul_ttl,
    @_ZL6fe_addPN4bssl8fe_looseEPKNS_2feES4_ := fe_add,
    @_ZL6fe_subPN4bssl8fe_looseEPKNS_2feES4_ := fe_sub,
    @_ZL8fe_carryPN4bssl2feEPKNS_8fe_looseE := fe_carry

end

end MLIR.Boringssl
