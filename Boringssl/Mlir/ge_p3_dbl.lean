module

-- boringssl-build/out/op/_ZL9ge_p3_dblPN4bssl7ge_p1p1EPKNS_5ge_p3E.mlir
-- ge_p3_dbl(bssl::ge_p1p1*, bssl::ge_p3 const*)

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Boringssl.Mlir.ge_p3_to_p2
public import Boringssl.Mlir.ge_p2_dbl

meta import MLIR.Semantics.Func
meta import Boringssl.Mlir.ge_p3_to_p2
meta import Boringssl.Mlir.ge_p2_dbl

namespace MLIR.Boringssl

@[expose] public section

mlir_def ge_p3_dbl :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.noundef}], dso_local, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, no_inline, no_unwind, passthrough = ["mustprogress", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"], ["warn-stack-size", "25344"]], sym_name = "_ZL9ge_p3_dblPN4bssl7ge_p1p1EPKNS_5ge_p3E", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg57: !llvm.ptr, %arg58: !llvm.ptr):
  %1114 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1115 = "llvm.alloca"(%1114) <{alignment = 8 : i64, elem_type = !llvm.struct<"struct.bssl::ge_precomp", (struct<"struct.bssl::fe", (array<5 x i64>)>, struct<"struct.bssl::fe", (array<5 x i64>)>, struct<"struct.bssl::fe", (array<5 x i64>)>)>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%1115) : (!llvm.ptr) -> ()
  "llvm.call"(%1115, %arg58) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @_ZL11ge_p3_to_p2PN4bssl5ge_p2EPKNS_5ge_p3E, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%arg57, %1115) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZL9ge_p2_dblPN4bssl7ge_p1p1EPKNS_5ge_p2E, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1115) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
  with @_ZL11ge_p3_to_p2PN4bssl5ge_p2EPKNS_5ge_p3E := ge_p3_to_p2,
    @_ZL9ge_p2_dblPN4bssl7ge_p1p1EPKNS_5ge_p2E := ge_p2_dbl

end

end MLIR.Boringssl
