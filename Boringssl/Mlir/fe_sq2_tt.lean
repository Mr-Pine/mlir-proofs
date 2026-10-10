module

-- boringssl-build/out/op/_ZL9fe_sq2_ttPN4bssl2feEPKS0_.mlir
-- fe_sq2_tt(bssl::fe*, bssl::fe const*)

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Boringssl.Mlir.fe_add
public import Boringssl.Mlir.fe_carry
public import Boringssl.Mlir.fe_sq_tt

meta import MLIR.Semantics.Func
meta import Boringssl.Mlir.fe_add
meta import Boringssl.Mlir.fe_carry
meta import Boringssl.Mlir.fe_sq_tt

namespace MLIR.Boringssl

@[expose] public section

mlir_def fe_sq2_tt :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"], ["warn-stack-size", "25344"]], sym_name = "_ZL9fe_sq2_ttPN4bssl2feEPKS0_", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg53: !llvm.ptr, %arg54: !llvm.ptr):
  %1102 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1103 = "llvm.alloca"(%1102) <{alignment = 8 : i64, elem_type = !llvm.struct<"struct.bssl::fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  "llvm.call"(%arg53, %arg54) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @_ZL8fe_sq_ttPN4bssl2feEPKS0_, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1103) : (!llvm.ptr) -> ()
  "llvm.call"(%1103, %arg53, %arg53) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZL6fe_addPN4bssl8fe_looseEPKNS_2feES4_, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%arg53, %1103) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZL8fe_carryPN4bssl2feEPKNS_8fe_looseE, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1103) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
  with @_ZL6fe_addPN4bssl8fe_looseEPKNS_2feES4_ := fe_add,
    @_ZL8fe_carryPN4bssl2feEPKNS_8fe_looseE := fe_carry, @_ZL8fe_sq_ttPN4bssl2feEPKS0_ := fe_sq_tt

end

end MLIR.Boringssl
