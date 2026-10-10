module

-- sodium-build/out/op/store64_be.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Sodium

@[expose] public section

mlir_def store64_be :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef, llvm.writeonly}, {llvm.noundef}], dso_local, function_type = !llvm.func<void (ptr, i64)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "ssp", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], sym_name = "store64_be", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg15: !llvm.ptr, %arg16: i64):
  %233 = "llvm.mlir.constant"() <{value = 8 : i64}> : () -> i64
  %234 = "llvm.mlir.constant"() <{value = 16 : i64}> : () -> i64
  %235 = "llvm.mlir.constant"() <{value = 24 : i64}> : () -> i64
  %236 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %237 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
  %238 = "llvm.mlir.constant"() <{value = 48 : i64}> : () -> i64
  %239 = "llvm.mlir.constant"() <{value = 56 : i64}> : () -> i64
  %240 = "llvm.trunc"(%arg16) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %241 = "llvm.getelementptr"(%arg15) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 7>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%240, %241) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %242 = "llvm.lshr"(%arg16, %233) : (i64, i64) -> i64
  %243 = "llvm.trunc"(%242) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %244 = "llvm.getelementptr"(%arg15) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 6>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%243, %244) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %245 = "llvm.lshr"(%arg16, %234) : (i64, i64) -> i64
  %246 = "llvm.trunc"(%245) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %247 = "llvm.getelementptr"(%arg15) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 5>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%246, %247) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %248 = "llvm.lshr"(%arg16, %235) : (i64, i64) -> i64
  %249 = "llvm.trunc"(%248) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %250 = "llvm.getelementptr"(%arg15) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 4>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%249, %250) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %251 = "llvm.lshr"(%arg16, %236) : (i64, i64) -> i64
  %252 = "llvm.trunc"(%251) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %253 = "llvm.getelementptr"(%arg15) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 3>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%252, %253) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %254 = "llvm.lshr"(%arg16, %237) : (i64, i64) -> i64
  %255 = "llvm.trunc"(%254) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %256 = "llvm.getelementptr"(%arg15) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 2>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%255, %256) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %257 = "llvm.lshr"(%arg16, %238) : (i64, i64) -> i64
  %258 = "llvm.trunc"(%257) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %259 = "llvm.getelementptr"(%arg15) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 1>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%258, %259) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %260 = "llvm.lshr"(%arg16, %239) : (i64, i64) -> i64
  %261 = "llvm.trunc"(%260) <{overflowFlags = 2 : i32}> : (i64) -> i8
  "llvm.store"(%261, %arg15) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end MLIR.Sodium
