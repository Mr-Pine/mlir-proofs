module

public import SSA.Projects.RIR.Run.Tactic
public import Firedancer.Ref.Mlir.fd_ulong_bswap
import Std.Tactic.BVDecide

namespace LeanMLIR.RIR.Firedancer.Ref

/-! ## Specification -/

@[expose] public section

/-- `__builtin_bswap64( x )`: `x`'s eight bytes in reverse order. -/
def fd_ulong_bswap.spec (x : BitVec 64) : BitVec 64 :=
  x.extractLsb' 0 8 ++ x.extractLsb' 8 8 ++ x.extractLsb' 16 8 ++ x.extractLsb' 24 8 ++
    x.extractLsb' 32 8 ++
    x.extractLsb' 40 8 ++
    x.extractLsb' 48 8 ++
    x.extractLsb' 56 8

end

/-! ## Proof -/

section Proof

/-- `llvm.intr.bswap`'s byte loop computes `spec`. -/
theorem fd_ulong_bswap.foldl_eq (x : BitVec 64) :
    (List.range 8).foldl (fun acc i => acc ||| (x >>> (8 * i) &&& 255#64) <<< (64 - 8 * (i + 1)))
        0#64 =
      fd_ulong_bswap.spec x := by
  simp only [List.range_succ, List.range_zero, List.nil_append, List.foldl_cons, List.foldl_nil,
    List.foldl_append, fd_ulong_bswap.spec]
  bv_decide

/-- `fd_ulong_bswap` returns `spec x`. -/
public theorem fd_ulong_bswap.call_eq (x : BitVec 64) (s : GlobalState) (hwf : s.WF) :
    fd_ulong_bswap.call (fd_ulong_bswap.args (.value x)) s =
      .value (.cons (.value (fd_ulong_bswap.spec x)) .nil, s) := by
  func_init
  block_init
  step_pure [fd_ulong_bswap.foldl_eq]
  finish_block
  rw [hS]

end Proof

end LeanMLIR.RIR.Firedancer.Ref
