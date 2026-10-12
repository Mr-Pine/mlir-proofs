module

public import Ed25519.Group
import Mathlib.Tactic.Abel
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Ring
public import Zig.Edwards25519_clearCofactor
public import Zig.Edwards25519_dbl
public import Zig.Edwards25519_rejectIdentity
public import Zig.Math.Point

/-! Zig's point doubling on the curve: `dbl` doubles in extended coordinates, `clearCofactor`
multiplies by 8, and `rejectIdentity` tests `x` against zero. -/

namespace MLIR.Zig

open _root_.Ed25519

/-! ## Doubled squares -/

/-- `sq2` gives twice the square, for limbs below `2^53`. -/
public theorem Fe.sq2.spec_val {a : Fin 5 → BitVec 64} (ha : Fe.Lt a (2 ^ 53)) :
    Limbs.val (Fe.sq2.spec a) = 2 * Limbs.val a ^ 2 := by
  have hA i : ValLe (a i) (a i).toNat (2 ^ 53 - 1) :=
    ⟨rfl, by
      have := ha i; omega⟩
  rw [Fe.sq2.spec]
  apply Fe.carry128.spec_valLe
  iterate 5
    · apply_rules [ValLe.shl, ValLe.add, ValLe.mul, ValLe.setWidth, ValLe.const]
      all_goals decide
  · decide
  · rw [Limbs.val_eq]
    simp only [show (19#128).toNat = 19 from rfl, show (38#128).toNat = 38 from rfl,
      show (2#128).toNat = 2 from rfl]
    push_cast
    generalize ((a 0).toNat : ZMod p) = a0
    generalize ((a 1).toNat : ZMod p) = a1
    generalize ((a 2).toNat : ZMod p) = a2
    generalize ((a 3).toNat : ZMod p) = a3
    generalize ((a 4).toNat : ZMod p) = a4
    linear_combination
      -2 *
        (2 * a1 * a4 + 2 * a2 * a3 + (2 * a2 * a4 + a3 ^ 2) * 2 ^ 51 + 2 * a3 * a4 * 2 ^ 102 +
          a4 ^ 2 * 2 ^ 153) *
        two_pow_255

/-! ## Doubling -/

section Dbl

variable {P : ZPt} {x y : ZMod p}

/-- `dbl` doubles, for `x`, `y`, `z` below `2^53`; the double's limbs are below `2^52`. -/
public theorem Edwards25519.dbl.spec_ext (hP : P.Ext x y) (hc : OnCurve x y)
    (hX : Fe.Lt P.x (2 ^ 53)) (hY : Fe.Lt P.y (2 ^ 53)) (hZ : Fe.Lt P.z (2 ^ 53)) :
    (Edwards25519.dbl.spec P).Ext (dbl x y).1 (dbl x y).2 ∧
      (Edwards25519.dbl.spec P).Lt (2 ^ 52) := by
  refine ⟨?_, Edwards25519.dbl.spec_lt P⟩
  obtain ⟨hz, hx, hy, -⟩ := hP
  have l63 {l : Fin 5 → BitVec 64} {B : ℕ} (h : Fe.Lt l B) (hB : B ≤ 2 ^ 63) : Fe.Lt l (2 ^ 63) :=
    h.mono hB
  have l54 {l : Fin 5 → BitVec 64} {B : ℕ} (h : Fe.Lt l B) (hB : B ≤ 2 ^ 54) : Fe.Lt l (2 ^ 54) :=
    h.mono hB
  -- `t0 = (X + Y)²`, `X²`, `Y²`, `2Z²`
  have aXY := Fe.add.spec_lt hX hY (by norm_num)
  have v0 := Fe.sq.spec_val (l54 aXY (by norm_num))
  rw [Fe.add.spec_val hX hY (by norm_num)] at v0
  have vx := Fe.sq.spec_val (l54 hX (by norm_num))
  have vy := Fe.sq.spec_val (l54 hY (by norm_num))
  have vz := Fe.sq2.spec_val hZ
  have b0 := Fe.sq.spec_lt (Fe.add.spec P.x P.y)
  have bx := Fe.sq.spec_lt P.x
  have by' := Fe.sq.spec_lt P.y
  have bz := Fe.carry128.spec_lt fun i => Fe.sq.cols P.z i <<< 1
  simp only [Edwards25519.dbl.spec]
  rw [← Fe.sq2.spec] at bz
  generalize Fe.sq.spec (Fe.add.spec P.x P.y) = T0 at *
  generalize Fe.sq.spec P.x = SX at *
  generalize Fe.sq.spec P.y = SY at *
  generalize Fe.sq2.spec P.z = SZ at *
  -- `y = Y² + X²`, `z = Y² - X²`, `x = t0 - y`, `t = 2Z² - z`
  have vY := Fe.add.spec_val by' bx (by norm_num)
  have bY := Fe.add.spec_lt by' bx (by norm_num)
  have vZ := Fe.sub.spec_val (l63 by' (by norm_num)) (l63 bx (by norm_num))
  have bZ := Fe.sub.spec_lt (b := SX) by' (by norm_num)
  have vX := Fe.sub.spec_val (l63 b0 (by norm_num)) (l63 bY (by norm_num))
  have bX := Fe.sub.spec_lt (b := Fe.add.spec SY SX) b0 (by norm_num)
  have vT := Fe.sub.spec_val (l63 bz (by norm_num)) (l63 bZ (by norm_num))
  have bT := Fe.sub.spec_lt (b := Fe.sub.spec SY SX) bz (by norm_num)
  unfold ZPt.Ext IsExt
  dsimp only
  rw [Fe.mul.spec_val (l54 bX (by norm_num)) (l54 bT (by norm_num)),
    Fe.mul.spec_val (l54 bY (by norm_num)) (l54 bZ (by norm_num)),
    Fe.mul.spec_val (l54 bZ (by norm_num)) (l54 bT (by norm_num)),
    Fe.mul.spec_val (l54 bX (by norm_num)) (l54 bY (by norm_num)), vX, vT, vY, vZ, v0, vx, vy, vz,
    hx, hy]
  have d₁ := dbl_den₁ hc
  have d₂ := dbl_den₂ hc
  have hz2 : Limbs.val P.z ^ 2 ≠ 0 := pow_ne_zero 2 hz
  generalize Limbs.val P.z = Z at *
  have e₁ : (y * Z) ^ 2 - (x * Z) ^ 2 = Z ^ 2 * (y ^ 2 - x ^ 2) := by ring
  have e₂ : 2 * Z ^ 2 - Z ^ 2 * (y ^ 2 - x ^ 2) = Z ^ 2 * (2 - y ^ 2 + x ^ 2) := by ring
  rw [e₁, e₂]
  refine ⟨mul_ne_zero (mul_ne_zero hz2 d₁) (mul_ne_zero hz2 d₂), ?_, ?_, by ring⟩
  · simp only [dbl]; field_simp; ring
  · simp only [dbl]; field_simp

/-- `dbl` on points of the curve's group. -/
public theorem Edwards25519.dbl.spec_point {A : Point} (hP : P.Ext A.x A.y)
    (hX : Fe.Lt P.x (2 ^ 53)) (hY : Fe.Lt P.y (2 ^ 53)) (hZ : Fe.Lt P.z (2 ^ 53)) :
    (Edwards25519.dbl.spec P).Ext (A + A).x (A + A).y ∧ (Edwards25519.dbl.spec P).Lt (2 ^ 52) := by
  have h := Edwards25519.dbl.spec_ext hP A.on hX hY hZ
  rwa [Point.dbl_eq] at h

/-- `clearCofactor` multiplies by 8, for `x`, `y`, `z` below `2^53`; its limbs are below `2^52`. -/
public theorem Edwards25519.clearCofactor.spec_point {A : Point} (hP : P.Ext A.x A.y)
    (hX : Fe.Lt P.x (2 ^ 53)) (hY : Fe.Lt P.y (2 ^ 53)) (hZ : Fe.Lt P.z (2 ^ 53)) :
    (Edwards25519.clearCofactor.spec P).Ext (8 • A).x (8 • A).y ∧
      (Edwards25519.clearCofactor.spec P).Lt (2 ^ 52) := by
  have l53 {l : Fin 5 → BitVec 64} (h : Fe.Lt l (2 ^ 52)) : Fe.Lt l (2 ^ 53) := h.mono (by norm_num)
  obtain ⟨h1, ⟨x1, y1, z1, -⟩⟩ := Edwards25519.dbl.spec_point hP hX hY hZ
  obtain ⟨h2, ⟨x2, y2, z2, -⟩⟩ := Edwards25519.dbl.spec_point h1 (l53 x1) (l53 y1) (l53 z1)
  have h3 := Edwards25519.dbl.spec_point h2 (l53 x2) (l53 y2) (l53 z2)
  have e : A + A + (A + A) + (A + A + (A + A)) = 8 • A := by abel
  rwa [e] at h3

end Dbl

/-! ## The identity test -/

/-- `rejectIdentity` errors (`3`) exactly when `x = 0`, for `P.x` below `2^63`. -/
public theorem Edwards25519.rejectIdentity.spec_eq {P : ZPt} {x y : ZMod p} (hP : P.Ext x y)
    (hx : Fe.Lt P.x (2 ^ 63)) :
    Edwards25519.rejectIdentity.spec P = if x = 0 then 3#16 else 0#16 := by
  obtain ⟨hz, hX, -, -⟩ := hP
  have e : Limbs.val P.x = 0 ↔ x = 0 := by rw [hX, mul_eq_zero, or_iff_left hz]
  unfold Edwards25519.rejectIdentity.spec
  rw [Fe.isZero.spec_eq hx]
  by_cases h : x = 0
  · simp [h, e.2 h]
  · simp [h, mt e.1 h]

end MLIR.Zig
