module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

/-! `bignum_inv_p25519` is assembly outside crc's unit and has no IR. It is bound to a function of its
signature whose body is `llvm.unreachable`: a call is undefined behaviour, so a theorem that a
caller returns a value shows the call is not reached. -/

namespace MLIR.Firedancer.Crc.Verify

@[expose] public section

mlir_def bignum_inv_p25519 :=
"llvm.func"() <{CConv = #llvm.cconv<ccc>, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<external>, sym_name = "bignum_inv_p25519", visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr):
  "llvm.unreachable"() : () -> ()
}) : () -> ()

end

end MLIR.Firedancer.Crc.Verify
