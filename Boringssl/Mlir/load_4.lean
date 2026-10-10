module

-- boringssl-build/out/op/_ZL6load_4PKh.mlir
-- load_4(unsigned char const*)

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Boringssl

@[expose] public section

mlir_def load_4 :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<i64 (ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"], ["warn-stack-size", "25344"]], res_attrs = [{llvm.noundef, llvm.range = #llvm.constant_range<i64, 0, 4294967296>}], sym_name = "_ZL6load_4PKh", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg45: !llvm.ptr):
  %521 = "llvm.load"(%arg45) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %522 = "llvm.zext"(%521) : (i32) -> i64
  "llvm.return"(%522) : (i64) -> ()
}) : () -> ()

end

end MLIR.Boringssl
