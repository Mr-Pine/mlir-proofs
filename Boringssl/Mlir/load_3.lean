module

-- boringssl-build/out/op/_ZL6load_3PKh.mlir
-- load_3(unsigned char const*)

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Boringssl

@[expose] public section

mlir_def load_3 :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<i64 (ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"], ["warn-stack-size", "25344"]], res_attrs = [{llvm.noundef, llvm.range = #llvm.constant_range<i64, 0, 16777216>}], sym_name = "_ZL6load_3PKh", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg46: !llvm.ptr):
  %523 = "llvm.mlir.constant"() <{value = 16 : i64}> : () -> i64
  %524 = "llvm.load"(%arg46) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i16
  %525 = "llvm.zext"(%524) : (i16) -> i64
  %526 = "llvm.getelementptr"(%arg46) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2>}> : (!llvm.ptr) -> !llvm.ptr
  %527 = "llvm.load"(%526) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %528 = "llvm.zext"(%527) : (i8) -> i64
  %529 = "llvm.shl"(%528, %523) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %530 = "llvm.or"(%529, %525) <{isDisjoint}> : (i64, i64) -> i64
  "llvm.return"(%530) : (i64) -> ()
}) : () -> ()

end

end MLIR.Boringssl
