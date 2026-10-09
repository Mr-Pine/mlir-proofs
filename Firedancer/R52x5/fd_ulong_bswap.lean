module

public import MLIR.Run.Tactic
public import Firedancer.Ref.fd_ulong_bswap
public import Firedancer.R52x5.Mlir.fd_ulong_bswap
import Std.Tactic.BVDecide

namespace MLIR.Firedancer.R52x5

/-! ## Proof -/

section Proof

/-- `llvm.intr.bswap`'s byte loop computes `Ref.fd_ulong_bswap.spec`. -/
theorem fd_ulong_bswap.foldl_eq (x : BitVec 64) :
    (List.range 8).foldl (fun acc i => acc ||| (x >>> (8 * i) &&& 255#64) <<< (64 - 8 * (i + 1)))
        0#64 =
      Ref.fd_ulong_bswap.spec x := by
  simp only [List.range_succ, List.range_zero, List.nil_append, List.foldl_cons, List.foldl_nil,
    List.foldl_append, Ref.fd_ulong_bswap.spec]
  bv_decide

/-- `fd_ulong_bswap` returns `Ref.fd_ulong_bswap.spec x`. -/
public theorem fd_ulong_bswap.call_eq (x : BitVec 64) (s : GlobalState) (hwf : s.WF) :
    fd_ulong_bswap.call (fd_ulong_bswap.args (.value x)) s =
      .value (.cons (.value (Ref.fd_ulong_bswap.spec x)) .nil, s) := by
  func_init
  block_init
  step_pure [fd_ulong_bswap.foldl_eq]
  finish_block
  rw [hS]

end Proof

end MLIR.Firedancer.R52x5
