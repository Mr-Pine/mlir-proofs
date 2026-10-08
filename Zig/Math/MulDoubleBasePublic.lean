module

public import Ed25519.Group
public import Ed25519.BasePoint
public import Zig.Math.Point
public import Zig.Math.PointDbl
public import Zig.Math.Identity
public import Zig.Math.Slide
public import Zig.Math.BaseTable
public import Zig.Math.Precompute
public import Zig.Edwards25519_mulDoubleBasePublic
import Mathlib.Algebra.BigOperators.Fin
import Mathlib.Tactic.Abel
import Mathlib.Tactic.Module

/-! `mulDoubleBasePublic`'s spec on the curve: `n1 B + n2 A` from the scalars' digits and the
tables of `B`'s and `A`'s multiples, `error.WeakPublicKey` exactly when `4 A` has `x = 0`. -/

namespace LeanMLIR.RIR.Zig

open _root_.Ed25519

namespace Edwards25519.mulDoubleBasePublic

/-- `T`'s entries `0 … 8` represent `k A`, their limbs below `2^53`. -/
@[expose]
public def TblOf (T : Nat → ZPt) (A : Point) : Prop :=
  ∀ k < 9, (T k).Ext (k • A).x (k • A).y ∧ (T k).Lt (2 ^ 53)

/-- A positive digit `d ≤ 8`: its index, as an integer. -/
theorem digit_pos {d : BitVec 8} (h : 0 < d.toInt) (h8 : d.toInt ≤ 8) :
    d.toNat < 9 ∧ (d.toNat : ℤ) = d.toInt := by
  revert d; decide

/-- A negative digit `-8 ≤ d`: its index `-d`, as an integer. -/
theorem digit_neg {d : BitVec 8} (h : d.toInt < 0) (h8 : -8 ≤ d.toInt) :
    (-d).toNat < 9 ∧ ((-d).toNat : ℤ) = -d.toInt := by
  revert d; decide

variable {T : Nat → ZPt} {A R : Point} {Q : ZPt}

/-- A digit's step adds `d A`. -/
theorem digitStep_ext (hT : TblOf T A) (hQ : Q.Ext R.x R.y) (hQb : Q.Lt (2 ^ 53)) {d : BitVec 8}
    (hd : -8 ≤ d.toInt ∧ d.toInt ≤ 8) :
    (digitStep T d Q).Ext (R + d.toInt • A).x (R + d.toInt • A).y ∧
      (digitStep T d Q).Lt (2 ^ 53) := by
  unfold digitStep
  split
  · rename_i h
    obtain ⟨hk, hc⟩ := digit_pos h hd.2
    obtain ⟨he, hb⟩ := hT _ hk
    obtain ⟨e, b⟩ := Edwards25519.add.spec_point hQ he hQb hb
    rw [← hc, natCast_zsmul]
    exact ⟨e, ZPt.Lt.mono53 b⟩
  · split
    · rename_i h
      obtain ⟨hk, hc⟩ := digit_neg h hd.1
      obtain ⟨he, hb⟩ := hT _ hk
      obtain ⟨e, b⟩ := Edwards25519.sub.spec_point hQ he hQb hb
      have : R + d.toInt • A = R - (-d).toNat • A := by
        rw [← natCast_zsmul, hc, neg_zsmul, sub_neg_eq_add]
      rw [this]
      exact ⟨e, ZPt.Lt.mono53 b⟩
    · have : d.toInt = 0 := by omega
      rw [this, zero_smul, add_zero]
      exact ⟨hQ, hQb⟩

/-- Four doublings multiply by 16. -/
theorem dbl4_ext (hQ : Q.Ext R.x R.y) (hQb : Q.Lt (2 ^ 53)) :
    (dbl4 Q).Ext ((16 : ℤ) • R).x ((16 : ℤ) • R).y ∧ (dbl4 Q).Lt (2 ^ 53) := by
  obtain ⟨h1, b1⟩ := Edwards25519.dbl.spec_point hQ hQb.1 hQb.2.1 hQb.2.2.1
  have b1 := ZPt.Lt.mono53 b1
  obtain ⟨h2, b2⟩ := Edwards25519.dbl.spec_point h1 b1.1 b1.2.1 b1.2.2.1
  have b2 := ZPt.Lt.mono53 b2
  obtain ⟨h3, b3⟩ := Edwards25519.dbl.spec_point h2 b2.1 b2.2.1 b2.2.2.1
  have b3 := ZPt.Lt.mono53 b3
  obtain ⟨h4, b4⟩ := Edwards25519.dbl.spec_point h3 b3.1 b3.2.1 b3.2.2.1
  have e :
    R + R + (R + R) + (R + R + (R + R)) + (R + R + (R + R) + (R + R + (R + R))) = (16 : ℤ) • R := by
    module
  rw [← e]
  exact ⟨h4, ZPt.Lt.mono53 b4⟩

/-- Digit `k` of `x`, as an integer. -/
abbrev dig (x : BitVec 256) (k : Nat) : ℤ :=
  (Edwards25519.slide.digit x k).toInt

/-- The loop from `pos = i` on `R`: `16^i R + Σ_{k ≤ i} 16^k (e1_k B + e2_k A)`. -/
theorem ladder_ext {B : Point} (hB : TblOf baseTbl B) (hT : TblOf T A) {x1 x2 : BitVec 256}
    (hd1 : ∀ k < 64, -8 ≤ dig x1 k ∧ dig x1 k ≤ 8) (hd2 : ∀ k < 64, -8 ≤ dig x2 k ∧ dig x2 k ≤ 8) :
    ∀ i < 64,
      ∀ (Q : ZPt) (R : Point),
        Q.Ext R.x R.y →
          Q.Lt (2 ^ 53) →
            let V :=
              ((16 : ℤ) ^ i) • R + (∑ k ∈ Finset.range (i + 1), (16 : ℤ) ^ k * dig x1 k) • B +
                (∑ k ∈ Finset.range (i + 1), (16 : ℤ) ^ k * dig x2 k) • A
            (ladder T x1 x2 i Q).Ext V.x V.y ∧ (ladder T x1 x2 i Q).Lt (2 ^ 53) := by
  intro i
  induction i with
  | zero =>
    intro _ Q R hQ hQb
    obtain ⟨h1, b1⟩ := digitStep_ext hB hQ hQb (hd1 0 (by omega))
    obtain ⟨h2, b2⟩ := digitStep_ext hT h1 b1 (hd2 0 (by omega))
    have e :
      R + dig x1 0 • B + dig x2 0 • A =
        ((16 : ℤ) ^ 0) • R + (∑ k ∈ Finset.range 1, (16 : ℤ) ^ k * dig x1 k) • B +
          (∑ k ∈ Finset.range 1, (16 : ℤ) ^ k * dig x2 k) • A := by
      simp
    simp only
    rw [← e]
    exact ⟨h2, b2⟩
  | succ i ih =>
    intro hi Q R hQ hQb
    obtain ⟨h1, b1⟩ := digitStep_ext hB hQ hQb (hd1 (i + 1) hi)
    obtain ⟨h2, b2⟩ := digitStep_ext hT h1 b1 (hd2 (i + 1) hi)
    obtain ⟨h3, b3⟩ := dbl4_ext h2 b2
    have h := ih (by omega) _ _ h3 b3
    simp only at h ⊢
    have e :
      ((16 : ℤ) ^ i) • ((16 : ℤ) • (R + dig x1 (i + 1) • B + dig x2 (i + 1) • A)) +
          (∑ k ∈ Finset.range (i + 1), (16 : ℤ) ^ k * dig x1 k) • B +
          (∑ k ∈ Finset.range (i + 1), (16 : ℤ) ^ k * dig x2 k) • A =
        ((16 : ℤ) ^ (i + 1)) • R + (∑ k ∈ Finset.range (i + 1 + 1), (16 : ℤ) ^ k * dig x1 k) • B +
          (∑ k ∈ Finset.range (i + 1 + 1), (16 : ℤ) ^ k * dig x2 k) • A := by
      rw [Finset.sum_range_succ _ (i + 1), Finset.sum_range_succ _ (i + 1)]
      module
    rw [← e]
    exact h

/-- `slide`'s digits, weighted, sum to the scalar, below `2^255`. -/
theorem sum_dig {x : BitVec 256} (h : x.msb = false) :
    ∑ k ∈ Finset.range 64, (16 : ℤ) ^ k * dig x k = x.toNat := by
  rw [← Edwards25519.slide.spec_sum x h, ← Fin.sum_univ_eq_sum_range]
  refine Finset.sum_congr rfl fun k _ => ?_
  simp [Edwards25519.slide.spec, mul_comm]

/-- `slide`'s digits of a scalar below `2^255` are in `[-8, 8]`. -/
theorem dig_bound {x : BitVec 256} (h : x.msb = false) (k : Nat) (hk : k < 64) :
    -8 ≤ dig x k ∧ dig x k ≤ 8 := by
  have := Edwards25519.slide.spec_digit x h ⟨k, hk⟩
  simp only [Edwards25519.slide.spec, Fin.getElem_fin, Vector.getElem_ofFn] at this
  exact ⟨this.1, this.2.1⟩

/-- The whole loop from the identity: `n1 B + n2 A`. -/
public theorem ladder_point {B : Point} (hB : TblOf baseTbl B) (hT : TblOf T A) {x1 x2 : BitVec 256}
    (hm1 : x1.msb = false) (hm2 : x2.msb = false) :
    (ladder T x1 x2 63 identity).Ext (x1.toNat • B + x2.toNat • A).x
        (x1.toNat • B + x2.toNat • A).y ∧
      (ladder T x1 x2 63 identity).Lt (2 ^ 53) := by
  have id53 : identity.Lt (2 ^ 53) := by
    refine ⟨?_, ?_, ?_, ?_⟩ <;> intro i <;> fin_cases i <;> decide
  have h := ladder_ext hB hT (dig_bound hm1) (dig_bound hm2) 63 (by omega) _ _ identity_ext id53
  simp only [sum_dig hm1, sum_dig hm2, smul_zero, zero_add, natCast_zsmul] at h
  exact h

/-- The base point's table represents `k B`. -/
public theorem baseTbl_of : TblOf baseTbl basePoint := fun k hk => by
  have h1 := Edwards25519.basePointPc.pts_ext ⟨k, by omega⟩
  have h2 := Edwards25519.basePointPc.pts_lt ⟨k, by omega⟩
  simp only [baseTbl, show k < 16 by omega, dite_true]
  exact ⟨h1, ZPt.Lt.mono53 h2⟩

/-- `precompute`'s table of a point representing `A` represents `k A`. -/
public theorem pcTbl_of {P : ZPt} (hP : P.Ext A.x A.y) (hPb : P.Lt (2 ^ 53)) : TblOf (pcTbl P) A :=
  fun k hk => by
  have h := Edwards25519.precompute.spec_point hP hPb ⟨k, hk⟩
  simp only [pcTbl, hk, dite_true]
  exact h

/-- With `is_base` set: `n1 B + n2 B`, `p2`'s point ignored. -/
public theorem spec_base (x1 x2 : BitVec 256) (hm1 : x1.msb = false) (hm2 : x2.msb = false)
    (P2 : ZPt) :
    ∃ Q,
      spec x1 1#1 P2 x2 = some Q ∧
        Q.Ext (x1.toNat • basePoint + x2.toNat • basePoint).x
          (x1.toNat • basePoint + x2.toNat • basePoint).y ∧
        Q.Lt (2 ^ 53) :=
  ⟨_, by simp [spec], ladder_point baseTbl_of baseTbl_of hm1 hm2⟩

/-- Without `is_base`, for `P2` representing `A`: `error.WeakPublicKey` exactly when `4 A` has
`x = 0`, else `n1 B + n2 A`. -/
public theorem spec_point (x1 x2 : BitVec 256) (hm1 : x1.msb = false) (hm2 : x2.msb = false)
    {b : BitVec 1} (hb : b ≠ 1#1) {P2 : ZPt} (hP : P2.Ext A.x A.y) (hPb : P2.Lt (2 ^ 53)) :
    (spec x1 b P2 x2 = none ↔ (4 • A).x = 0) ∧
      ∀ Q,
        spec x1 b P2 x2 = some Q →
          Q.Ext (x1.toNat • basePoint + x2.toNat • A).x (x1.toNat • basePoint + x2.toNat • A).y ∧
            Q.Lt (2 ^ 53) := by
  have hT := pcTbl_of hP hPb
  obtain ⟨h4, b4⟩ := hT 4 (by omega)
  have hr := Edwards25519.rejectIdentity.spec_eq h4 (b4.1.mono (by norm_num))
  have hL := ladder_point baseTbl_of hT hm1 hm2
  unfold spec
  simp only [hb, ite_false, hr]
  by_cases h : (4 • A).x = 0
  · simp [h]
  · refine ⟨by simp [h], fun Q hQ => ?_⟩
    simp only [h, ite_false, ite_true, Option.some.injEq] at hQ
    exact hQ ▸ hL

end Edwards25519.mulDoubleBasePublic

end LeanMLIR.RIR.Zig
