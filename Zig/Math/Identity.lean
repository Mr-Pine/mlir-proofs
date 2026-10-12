module

public import Ed25519.Curve
public import Ed25519.Group
public import Zig.Common.Globals
public import Zig.Math.Point
public import Zig.Verifier_isIdentity

/-! `isIdentity` tests for the curve's identity, and the identity global represents it. -/

namespace MLIR.Zig

open _root_.Ed25519
variable {P : ZPt} {x y : ZMod p}

/-- `isIdentity` is `1` iff `P` is `(0, 1)`, for the bounds its `call_eq` assumes. -/
public theorem Verifier.isIdentity.spec_ext (hP : P.Ext x y) (hx : Fe.Lt P.x (2 ^ 63))
    (hy : Fe.Lt P.y (2 ^ 62)) (hz : Fe.Lt P.z (2 ^ 63)) :
    Verifier.isIdentity.spec P = BitVec.ofBool (decide (x = 0 ∧ y = 1)) := by
  obtain ⟨hZ, eX, eY, -⟩ := hP
  have hy63 := hy.mono (show 2 ^ 62 ≤ 2 ^ 63 by decide)
  have hs :=
    (Fe.sub.spec_lt (b := P.z) hy (by decide)).mono (show 2 ^ 62 + 2 ^ 52 ≤ 2 ^ 63 by decide)
  have e1 : Limbs.val P.x = 0 ↔ x = 0 := by rw [eX, mul_eq_zero, or_iff_left hZ]
  have e2 : Limbs.val P.y - Limbs.val P.z = 0 ↔ y = 1 := by
    rw [eY, sub_eq_zero]
    constructor
    · intro h; exact mul_right_cancel₀ hZ (h.trans (one_mul _).symm)
    · rintro rfl; exact one_mul _
  unfold Verifier.isIdentity.spec
  rw [Fe.isZero.spec_eq hx, Fe.isZero.spec_eq hs, Fe.sub.spec_val hy63 hz]
  by_cases h1 : x = 0 <;> by_cases h2 : y = 1 <;> simp [e1, e2, h1, h2]

/-- `isIdentity` on points of the curve's group: `1` iff `A = 0`. -/
public theorem Verifier.isIdentity.spec_point {A : Point} (hP : P.Ext A.x A.y)
    (hx : Fe.Lt P.x (2 ^ 63)) (hy : Fe.Lt P.y (2 ^ 62)) (hz : Fe.Lt P.z (2 ^ 63)) :
    Verifier.isIdentity.spec P = 1#1 ↔ A = 0 := by
  have hb (q : Prop) [Decidable q] : BitVec.ofBool (decide q) = 1#1 ↔ q := by
    by_cases h : q <;> simp [h]
  rw [Verifier.isIdentity.spec_ext hP hx hy hz, hb]
  exact ⟨fun h => Point.ext h.1 h.2, fun h => h ▸ ⟨rfl, rfl⟩⟩

/-- The identity global represents `0`. -/
public theorem Edwards25519.identity_ext :
    Edwards25519.identity.Ext (0 : Point).x (0 : Point).y := by
  unfold ZPt.Ext IsExt
  simp [Edwards25519.identity, Limbs.val_eq, Fe.mk5]

end MLIR.Zig
