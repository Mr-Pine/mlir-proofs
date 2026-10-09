module

-- build/native/gcc/mlir_canonicalized/avx512/region/wv_ld.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Firedancer.Avx512

@[expose] public section

mlir_def wv_ld :=
{
  ^bb0(%arg0: !llvm.ptr):
    %0 = "llvm.load"(%arg0) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
    "llvm.return"(%0) : (vector<4xi64>) -> ()
}

end

end MLIR.Firedancer.Avx512
