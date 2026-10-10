module

-- sodium-build/out/op/d2.mlir

public import MLIR.Semantics.GlobalInitializer
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.GlobalInitializer

namespace MLIR.Sodium

@[expose] public section

mlir_const_def d2 :=
"llvm.mlir.global"() <{addr_space = 0 : i32, alignment = 16 : i64, constant, dso_local, global_type = !llvm.array<5 x i64>, linkage = #llvm.linkage<internal>, sym_name = "d2", unnamed_addr = 0 : i64, value = dense<[1859910466990425, 932731440258426, 1072319116312658, 1815898335770999, 633789495995903]> : tensor<5xi64>, visibility_ = 0 : i64}> ({
}) : () -> ()

end

end MLIR.Sodium
