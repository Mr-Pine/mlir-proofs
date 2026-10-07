module

-- build/native/gcc/mlir_canonicalized/ref/region/fiat_25519_cmovznz_u64.mlir

public import SSA.Projects.RIR.Semantics.Func
public import SSA.Projects.RIR.Syntax.Elab

meta import SSA.Projects.RIR.Semantics.Func

namespace LeanMLIR.RIR.Firedancer.Ref

@[expose] public section

mlir_def fiat_25519_cmovznz_u64 :=
{
  ^bb0(%arg0: !llvm.ptr, %arg1: i8, %arg2: i64, %arg3: i64):
    %0 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
    %1 = "llvm.icmp"(%arg1, %0) <{predicate = 0 : i64}> : (i8, i8) -> i1
    %2 = "llvm.select"(%1, %arg2, %arg3) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
    "llvm.store"(%2, %arg0) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
    "llvm.return"() : () -> ()
}

end

end LeanMLIR.RIR.Firedancer.Ref
