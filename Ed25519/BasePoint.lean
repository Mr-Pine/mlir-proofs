module

public import Ed25519.Group
import Mathlib.Tactic.ReduceModChar

/-! The base point `B`. -/

namespace Ed25519

@[expose] public section

/-- The base point's `x`, the even root. -/
def Bx : ZMod p :=
  15112221349535400772501151409588531511454012693041857206046113283949847762202

/-- The base point's `y`, `4 / 5`. -/
def By : ZMod p :=
  46316835694926478169428394003475163141307993866256225615783033603165251855960

end

/-- `B`'s `y` is `4 / 5`. -/
public theorem By_eq : By = 4 / 5 := by
  rw [eq_div_iff (by decide)]
  decide

/-- `B` is on the curve. -/
public theorem onCurve_B : OnCurve Bx By := by
  unfold OnCurve Bx By d
  reduce_mod_char

/-- The base point `B`. -/
@[expose]
public def basePoint : Point :=
  ⟨Bx, By, onCurve_B⟩

end Ed25519
