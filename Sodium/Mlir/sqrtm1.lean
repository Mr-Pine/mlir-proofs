module

-- sodium-build/out/op/sqrtm1.mlir

public import MLIR.Semantics.GlobalInitializer
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.GlobalInitializer

namespace MLIR.Sodium

@[expose] public section

mlir_const_def sqrtm1 :=
"llvm.mlir.global"() <{addr_space = 0 : i32, alignment = 16 : i64, constant, dso_local, global_type = !llvm.array<5 x i64>, linkage = #llvm.linkage<internal>, sym_name = "sqrtm1", unnamed_addr = 0 : i64, value = dense<[1718705420411056, 234908883556509, 2233514472574048, 2117202627021982, 765476049583133]> : tensor<5xi64>, visibility_ = 0 : i64}> ({
}) : () -> ()

end

end MLIR.Sodium
