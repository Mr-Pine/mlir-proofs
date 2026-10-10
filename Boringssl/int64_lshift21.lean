module

public import MLIR.Run.Tactic
public import Boringssl.Mlir.int64_lshift21
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Boringssl

/-! ## Proof -/

section Proof

/-- `a << 21` loses no bit of a signed `a` in `[-2^42, 2^42)`: the compiled `shl nsw` holds. -/
public theorem int64_lshift21.nsw {a : BitVec 64}
    (ha : -4398046511104 ≤ a.toInt ∧ a.toInt < 4398046511104) : (a <<< 21).sshiftRight 21 = a := by
  have h0 : (-4398046511104#64).sle a := by
    rw [BitVec.sle_iff_toInt_le]; simp; omega
  have h1 : a.slt 4398046511104#64 := by
    rw [BitVec.slt_iff_toInt_lt]; simp; omega
  bv_decide

/-- `int64_lshift21` returns `a << 21` for `a` in `[-2^42, 2^42)`, the range its callers keep (the
compiled shift is `nsw`), and leaves the state alone. -/
public theorem int64_lshift21.call_eq (a : BitVec 64) (s : GlobalState) (hwf : s.WF)
    (ha : -4398046511104 ≤ a.toInt ∧ a.toInt < 4398046511104) :
    int64_lshift21.call (int64_lshift21.args (.value a)) s =
      .value (.cons (.value (a <<< 21)) .nil, s) := by
  func_init
  block_init
  step_pure
  step_pure [int64_lshift21.nsw ha]
  finish_block
  subst hS
  rfl

end Proof

end MLIR.Boringssl
