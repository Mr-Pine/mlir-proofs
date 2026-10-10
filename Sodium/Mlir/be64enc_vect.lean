module

-- sodium-build/out/op/be64enc_vect.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Sodium.Mlir.store64_be

meta import MLIR.Semantics.Func
meta import Sodium.Mlir.store64_be

namespace MLIR.Sodium

@[expose] public section

mlir_def be64enc_vect :=
#loop_annotation = #llvm.loop_annotation<mustProgress = true>
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.noundef, llvm.range = #llvm.constant_range<i64, 16, 65>}], dso_local, function_type = !llvm.func<void (ptr, ptr, i64)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "ssp", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], sym_name = "be64enc_vect", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg17: !llvm.ptr, %arg18: !llvm.ptr, %arg19: i64):
  %262 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %263 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %264 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %265 = "llvm.lshr"(%arg19, %262) : (i64, i64) -> i64
  "llvm.br"(%263)[^bb1] : (i64) -> ()
^bb1(%266: i64):  // 2 preds: ^bb0, ^bb1
  %267 = "llvm.shl"(%266, %262) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %268 = "llvm.getelementptr"(%arg17, %267) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %269 = "llvm.getelementptr"(%arg18, %266) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %270 = "llvm.load"(%269) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  "llvm.call"(%268, %270) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @store64_be, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, i64) -> ()
  %271 = "llvm.add"(%266, %264) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %272 = "llvm.icmp"(%271, %265) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%272, %271)[^bb2, ^bb1] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb2:  // pred: ^bb1
  "llvm.return"() : () -> ()
}) : () -> ()
  with @store64_be := store64_be

end

end MLIR.Sodium
