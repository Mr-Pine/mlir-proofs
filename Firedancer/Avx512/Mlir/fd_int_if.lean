module

-- build/native/gcc/mlir_canonicalized/avx512/region/fd_int_if.mlir

public import SSA.Projects.RIR.Semantics.Func
public import SSA.Projects.RIR.Syntax.Elab

meta import SSA.Projects.RIR.Semantics.Func

namespace LeanMLIR.RIR.Firedancer.Avx512

@[expose] public section

mlir_def fd_int_if :=
{
  ^bb0(%arg0: i32, %arg1: i32):
    %0 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
    %1 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
    %2 = "llvm.icmp"(%arg0, %0) <{predicate = 0 : i64}> : (i32, i32) -> i1
    %3 = "llvm.select"(%2, %arg1, %1) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i32, i32) -> i32
    "llvm.return"(%3) : (i32) -> ()
}

end

end LeanMLIR.RIR.Firedancer.Avx512
