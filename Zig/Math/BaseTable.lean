module

public import Ed25519.BasePoint
public import Ed25519.Order
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Ring
public import Zig.Common.BasePointPc
public import Zig.Math.Point

/-! The base-point table `basePointPc`: entry `i` is `i B`. The entries are checked by the kernel,
over `ℕ` mod `p`, against the extended-coordinates sum. -/

namespace MLIR.Zig

open _root_.Ed25519

namespace BaseTable

open Ed25519.ExtN

/-! ## Extended coordinates over `ℕ` -/

/-- `B`. -/
def BE : E :=
  ⟨BxN, ByN, BxN * ByN % p, 1⟩

/-- `B` and `A` are the same projective point, `B.Z ≠ 0`: cross-multiplied. -/
def projEq (A B : E) : Bool :=
  mulN B.X A.Z == mulN A.X B.Z && mulN B.Y A.Z == mulN A.Y B.Z && mulN B.T A.Z == mulN A.T B.Z &&
    B.Z % p != 0

theorem natCast_eq {a b : ℕ} (h : a % p = b % p) : (a : ZMod p) = b :=
  (ZMod.natCast_eq_natCast_iff' a b p).2 h

theorem rep_of_projEq {P : Point} {A B : E} (hA : Rep P A) (h : projEq A B = true) : Rep P B := by
  unfold projEq at h
  unfold Rep IsExt at hA ⊢
  simp only [Bool.and_eq_true, beq_iff_eq, bne_iff_ne, ne_eq] at h
  obtain ⟨⟨⟨hX, hY⟩, hT⟩, hZ⟩ := h
  replace hX := congrArg (Nat.cast (R := ZMod p)) hX
  replace hY := congrArg (Nat.cast (R := ZMod p)) hY
  replace hT := congrArg (Nat.cast (R := ZMod p)) hT
  rw [cast_mulN, cast_mulN] at hX hY hT
  have hZ' : (B.Z : ZMod p) ≠ 0 := fun h0 => hZ (by rw [← ZMod.val_natCast, h0, ZMod.val_zero])
  obtain ⟨hZA, eX, eY, eT⟩ := hA
  generalize (A.X : ZMod p) = XA at *
  generalize (A.Y : ZMod p) = YA at *
  generalize (A.T : ZMod p) = TA at *
  generalize (A.Z : ZMod p) = ZA at *
  generalize (B.X : ZMod p) = XB at *
  generalize (B.Y : ZMod p) = YB at *
  generalize (B.T : ZMod p) = TB at *
  generalize (B.Z : ZMod p) = ZB at *
  subst eX eY
  refine ⟨hZ', mul_right_cancel₀ hZA ?_, mul_right_cancel₀ hZA ?_, ?_⟩
  · linear_combination hX
  · linear_combination hY
  · refine mul_right_cancel₀ (pow_ne_zero 2 hZA) ?_
    linear_combination ZB * ZA * hT + ZB ^ 2 * eT - YB * ZA * hX - P.x * ZA * ZB * hY

/-- A point's limbs as extended coordinates. -/
def ofPt (P : ZPt) : E :=
  ⟨Limbs.nat P.x, Limbs.nat P.y, Limbs.nat P.t, Limbs.nat P.z⟩

/-- Entry `n`, the neutral point past the end. -/
def tbl (n : ℕ) : E :=
  if h : n < 16 then ofPt Edwards25519.basePointPc.pts[n] else ⟨0, 1, 0, 1⟩

/-- Entry `0` is the neutral point, and entry `n + 1` is entry `n` plus `B`. -/
theorem tbl_ok :
    decide (tbl 0 = ⟨0, 1, 0, 1⟩) &&
      (List.range 15).all fun n => projEq (eadd (tbl n) BE) (tbl (n + 1)) := by
  decide +kernel

/-- Entry `n` represents `n B`. -/
theorem rep_tbl : ∀ n, n < 16 → Rep (n • basePoint) (tbl n) := by
  obtain ⟨h0, hs⟩ := Bool.and_eq_true _ _ ▸ tbl_ok
  intro n
  induction n with
  | zero =>
    intro _
    rw [zero_smul, of_decide_eq_true h0]
    exact rep_zero
  | succ n ih =>
    intro h
    rw [succ_nsmul]
    exact
      rep_of_projEq (rep_add (ih (by omega)) rep_B)
        (List.all_eq_true.1 hs n (List.mem_range.2 (by omega)))

end BaseTable

open BaseTable in
/-- Entry `i` of the base-point table is `i B`. -/
public theorem Edwards25519.basePointPc.pts_ext (i : Fin 16) :
    (Edwards25519.basePointPc.pts[i]).Ext ((i : ℕ) • basePoint).x ((i : ℕ) • basePoint).y := by
  have h := rep_tbl i i.isLt
  simp only [tbl, i.isLt, ↓reduceDIte] at h
  unfold ZPt.Ext
  simp only [Limbs.val_nat]
  exact h

end MLIR.Zig
