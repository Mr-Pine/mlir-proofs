module

public import MLIR.Run.Tactic
import Std.Tactic.BVDecide
public import Firedancer.R52x5.Common.Wl
public import Firedancer.R52x5.Mlir.wc_bcast_wide

namespace MLIR.Firedancer.R52x5

/-! ## Proof -/

section Proof

/-- `0 - c` with `nsw`: no overflow unless `c` is `INT_MIN`. -/
private theorem ssubOverflow_zero {c : BitVec 32} (h : c ≠ BitVec.intMin 32) :
    (0#32).ssubOverflow c = false := by bv_decide

/-- `wc_bcast_wide( c0, c1, c2, c3 )` returns `wcBcast`, its lanes `-ck` twice; the `nsw` negation
needs no `ck` to be `INT_MIN`. -/
public theorem wc_bcast_wide.call_eq (c0 c1 c2 c3 : BitVec 32) (s : GlobalState) (hwf : s.WF)
    (hc :
      c0 ≠ BitVec.intMin 32 ∧
        c1 ≠ BitVec.intMin 32 ∧ c2 ≠ BitVec.intMin 32 ∧ c3 ≠ BitVec.intMin 32) :
    wc_bcast_wide.call (wc_bcast_wide.args (.value c0) (.value c1) (.value c2) (.value c3)) s =
      .value (.cons (Ty.wrap (wcBcast c0 c1 c2 c3)) .nil, s) := by
  obtain ⟨h0, h1, h2, h3⟩ := hc
  func_init
  block_init
  iterate 29 step_pure
  step_pure [ssubOverflow_zero h0, ssubOverflow_zero h1, ssubOverflow_zero h2, ssubOverflow_zero h3]
  finish_block
  rw [hS]
  rfl

end Proof

end MLIR.Firedancer.R52x5
