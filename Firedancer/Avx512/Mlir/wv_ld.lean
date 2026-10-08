module

-- build/native/gcc/mlir_canonicalized/avx512/region/wv_ld.mlir

public import SSA.Projects.RIR.Semantics.Func
public import SSA.Projects.RIR.Syntax.Elab

meta import SSA.Projects.RIR.Semantics.Func

namespace LeanMLIR.RIR.Firedancer.Avx512

@[expose] public section

mlir_def wv_ld :=
{
  ^bb0(%arg0: !llvm.ptr):
    %0 = "llvm.load"(%arg0) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
    "llvm.return"(%0) : (vector<4xi64>) -> ()
}

end

end LeanMLIR.RIR.Firedancer.Avx512
