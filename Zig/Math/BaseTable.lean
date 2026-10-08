module

public import Ed25519.BasePoint
public import Zig.Math.Point
public import Zig.Edwards25519_basePointPc
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Ring

/-! The base-point table `basePointPc`: entry `i` is `i B`, its limbs below `2^52`. The entries are
checked by the kernel, over `ℕ` mod `p`, against the extended-coordinates sum. -/

namespace LeanMLIR.RIR.Zig

open _root_.Ed25519

namespace BaseTable

/-! ## Extended coordinates over `ℕ` -/

/-- `a b mod p`. -/
def mulN (a b : ℕ) : ℕ :=
  a * b % p

/-- `a + b mod p`. -/
def addN (a b : ℕ) : ℕ :=
  (a + b) % p

/-- `a - b mod p`. -/
def subN (a b : ℕ) : ℕ :=
  (a + (p - b % p)) % p

theorem cast_mulN (a b : ℕ) : ((mulN a b : ℕ) : ZMod p) = a * b := by
  rw [mulN, ZMod.natCast_mod, Nat.cast_mul]

theorem cast_addN (a b : ℕ) : ((addN a b : ℕ) : ZMod p) = a + b := by
  rw [addN, ZMod.natCast_mod, Nat.cast_add]

theorem cast_subN (a b : ℕ) : ((subN a b : ℕ) : ZMod p) = a - b := by
  rw [subN, ZMod.natCast_mod, Nat.cast_add, Nat.cast_sub (Nat.mod_lt _ (by decide)).le,
    ZMod.natCast_self, ZMod.natCast_mod]
  ring

/-- `2 d`. -/
def d2N : ℕ :=
  2 * 37095705934669439343138083508754565189542113879843219016388785533085940283555

theorem cast_d2N : ((d2N : ℕ) : ZMod p) = 2 * d := by
  rw [d2N, Nat.cast_mul, Nat.cast_ofNat, Nat.cast_ofNat, d]

/-- Extended coordinates `(X : Y : T : Z)` over `ℕ`. -/
structure E where
  X : ℕ
  Y : ℕ
  T : ℕ
  Z : ℕ
  deriving DecidableEq

/-- `A` are extended coordinates of `P`, mod `p`. -/
def Rep (P : Point) (A : E) : Prop :=
  IsExt P.x P.y A.X A.Y A.T A.Z

/-- The sum, by `add_compl`'s completed point. -/
def eadd (A B : E) : E :=
  let r₅ := mulN (subN A.Y A.X) (subN B.Y B.X)
  let r₆ := mulN (addN A.Y A.X) (addN B.Y B.X)
  let r₇ := mulN (mulN A.T B.T) d2N
  let r₈ := mulN (addN A.Z A.Z) B.Z
  ⟨mulN (subN r₆ r₅) (subN r₈ r₇), mulN (addN r₆ r₅) (addN r₈ r₇), mulN (subN r₆ r₅) (addN r₆ r₅),
    mulN (addN r₈ r₇) (subN r₈ r₇)⟩

theorem rep_add {P Q : Point} {A B : E} (hA : Rep P A) (hB : Rep Q B) : Rep (P + Q) (eadd A B) := by
  simp only [Rep, eadd, cast_mulN, cast_addN, cast_subN, cast_d2N, Point.add_x, Point.add_y]
  obtain ⟨n₁, n₂, c₁, c₂⟩ := add_compl hA hB P.on Q.on
  exact
    ⟨mul_ne_zero n₁ n₂, by
      rw [c₁]; ring, by
      rw [c₂]; ring, by ring⟩

/-- `B`. -/
def BE : E :=
  ⟨15112221349535400772501151409588531511454012693041857206046113283949847762202,
    46316835694926478169428394003475163141307993866256225615783033603165251855960,
    15112221349535400772501151409588531511454012693041857206046113283949847762202 *
        46316835694926478169428394003475163141307993866256225615783033603165251855960 %
      p,
    1⟩

theorem rep_B : Rep basePoint BE := by
  refine ⟨by simp [BE], ?_, ?_, ?_⟩
  · rw [BE, Nat.cast_one, mul_one, Nat.cast_ofNat]; rfl
  · rw [BE, Nat.cast_one, mul_one, Nat.cast_ofNat]; rfl
  · rw [BE, Nat.cast_one, mul_one, ZMod.natCast_mod, Nat.cast_mul]

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

theorem rep_zero : Rep 0 ⟨0, 1, 0, 1⟩ :=
  ⟨by simp, by simp, by simp, by simp⟩

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

/-- The base-point table's limbs are below `2^52`. -/
public theorem Edwards25519.basePointPc.pts_lt (i : Fin 16) :
    (Edwards25519.basePointPc.pts[i]).Lt (2 ^ 52) := by
  revert i
  unfold ZPt.Lt Fe.Lt
  decide +kernel

end LeanMLIR.RIR.Zig
