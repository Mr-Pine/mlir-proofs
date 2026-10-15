module

public import Firedancer.Math.Avx512.Curve
public import Firedancer.Math.Dsmb
public import Firedancer.Math.Wnaf
public import Firedancer.LaneNI.fd_ed25519_multi_scalar_mul
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Algebra.BigOperators.GroupWithZero.Action
import Mathlib.Tactic.Module

/-! `fd_ed25519_multi_scalar_mul_with_opts` computes `Σ n[j] A[j]`: `ai[j]` holds `A[j]`'s odd
multiples, each wNAF digit adds its point's odd multiple, and the ladder doubles between digits.
`fd_ed25519_multi_scalar_mul` adds up its batches of 32. -/

namespace MLIR.Firedancer.LaneNI

namespace fd_ed25519_multi_scalar_mul_with_opts

open _root_.Ed25519 (Point)
open Firedancer.Avx512
open Avx512.fd_ed25519_double_scalar_mul_base (aiTable addDigit)
open Ref.fd_ed25519_double_scalar_mul_base (low low_succ low_256)

/-! ## The point operations on the group -/

/-- `R` is `P` in extended coordinates, folded, as the point operations give it. -/
def ExtF (R : Quad) (P : Point) : Prop :=
  R.Ext P.x P.y ∧ R.Folded

/-- `T` is `P` precomputed, folded, as the adds take their table operand. -/
def PreF (T : Quad) (P : Point) : Prop :=
  T.Pre P.x P.y ∧ T.Folded

/-- `ExtF` of equal points. -/
theorem ExtF.congr {R : Quad} {P Q : Point} (h : ExtF R P) (e : P = Q) : ExtF R Q :=
  e ▸ h

/-- `add_with_opts` of a precomputed operand: `Q + P`. -/
theorem add_extF {t b : Quad} {Q P : Point} (ht : ExtF t Q) (hb : PreF b P) :
    ExtF (fd_ed25519_point_add_with_opts.spec t b 1#32) (Q + P) := by
  have hpre : ¬(1#32 = 0) := by decide
  refine fd_ed25519_point_add_with_opts.spec_ext ht.1 ?_ Q.on P.on
    (ht.2.unsigned.mono (by decide)) ?_
  · rw [Quad.Operand, ite_eq_right hpre]
    exact hb.1
  · rw [ite_eq_right hpre]
    exact hb.2.unsigned.mono (by decide)

/-- `sub_with_opts` of a precomputed operand: `Q - P`. -/
theorem sub_extF {t b : Quad} {Q P : Point} (ht : ExtF t Q) (hb : PreF b P) :
    ExtF (fd_ed25519_point_sub_with_opts.spec t b 1#32) (Q - P) :=
  fd_ed25519_point_sub_with_opts.spec_ext ht.1
    (by rw [Quad.Operand, ite_eq_right (by decide)]; exact hb.1) Q.on P.on
    (ht.2.unsigned.mono (by decide)) hb.2

/-- `partial_dbl`: `Q + Q`. -/
theorem dbl_extF {r : Quad} {Q : Point} (hr : ExtF r Q) :
    ExtF (fd_ed25519_partial_dbl.spec r) (Q + Q) := by
  have h := fd_ed25519_partial_dbl.spec_ext hr.1.proj Q.on hr.2.unsigned
  rw [Ed25519.Point.dbl_eq] at h
  exact h

/-! ## Digits -/

/-- An odd positive `e` with `|e| / 2 < 8` indexes its multiple in the table of odd multiples. -/
theorem preF_odd {tb : ℕ → Quad} {P : Point}
    (htb : ∀ k < 8, PreF (tb k) ((2 * k + 1) • P)) {e : ℤ} (he : 0 < e) (ho : Odd e)
    (hn : e.natAbs / 2 < 8) : PreF (tb (e / 2).toNat) (e • P) := by
  obtain ⟨m, rfl⟩ := ho
  have h2 : ((2 * ((2 * m + 1) / 2).toNat + 1 : ℕ) : ℤ) = 2 * m + 1 := by omega
  have := htb ((2 * m + 1) / 2).toNat (by omega)
  rwa [← natCast_zsmul, h2] at this

/-- A digit's add takes `t`, `Q`, to `Q + d P`. -/
theorem addDigit_extF {tb : ℕ → Quad} {P Q : Point} {d : ℤ} {r t : Quad} (ht : ExtF t Q)
    (htb : ∀ k < 8, PreF (tb k) ((2 * k + 1) • P)) (hd : (d = 0 ∨ Odd d) ∧ d.natAbs / 2 < 8) :
    ExtF (addDigit tb d r t).2 (Q + d • P) := by
  unfold addDigit
  split_ifs with h1 h2
  · exact add_extF ht (preF_odd htb h1 (hd.1.resolve_left (by omega)) hd.2)
  · rw [show Q + d • P = Q - (-d) • P by rw [neg_smul, sub_neg_eq_add]]
    exact sub_extF ht (preF_odd htb (by omega) (hd.1.resolve_left (by omega)).neg (by omega))
  · obtain rfl : d = 0 := by omega
    rw [zero_smul, add_zero]
    exact ht

/-- The adds of points `0 … m - 1` at digit `i` take `t`, `Q`, to `Q + Σ w[j][i] A[j]`. -/
theorem adds_extF {ai : ℕ → ℕ → Quad} {PA : ℕ → Point} {w : ℕ → Vector Int 256} {i sz : ℕ}
    (hi : i < 256) (hai : ∀ j < sz, ∀ k < 8, PreF (ai j k) ((2 * k + 1) • PA j))
    (hw : ∀ j k (hk : k < 256), ((w j)[k] = 0 ∨ Odd (w j)[k]) ∧ (w j)[k].natAbs / 2 < 8) :
    ∀ m, m ≤ sz → ∀ {r t : Quad} {Q : Point}, ExtF t Q →
      ExtF (adds ai w i hi m (r, t)).2 (Q + ∑ j ∈ Finset.range m, (w j)[i] • PA j)
  | 0, _, _, _, _, ht => by
    simp only [adds, Finset.range_zero, Finset.sum_empty, add_zero]
    exact ht
  | m + 1, hm, r, t, Q, ht => by
    rw [adds, Finset.sum_range_succ, ← add_assoc]
    exact addDigit_extF (adds_extF hi hai hw m (by omega) ht) (hai m (by omega)) (hw m i hi)

/-! ## The ladder -/

/-- The main loop from `i` on `r`, `R`: `2^(i+1) R` plus each point's digits up to `i`. -/
theorem ladder_extF {ai : ℕ → ℕ → Quad} {PA : ℕ → Point} {w : ℕ → Vector Int 256} {sz : ℕ}
    (hai : ∀ j < sz, ∀ k < 8, PreF (ai j k) ((2 * k + 1) • PA j))
    (hw : ∀ j k (hk : k < 256), ((w j)[k] = 0 ∨ Odd (w j)[k]) ∧ (w j)[k].natAbs / 2 < 8) :
    ∀ i (h : i < 256) {r : Quad} {R : Point}, ExtF r R →
      ExtF (ladder ai w sz i h r)
        ((2 ^ (i + 1) : ℤ) • R + ∑ j ∈ Finset.range sz, low (w j) (i + 1) • PA j)
  | 0, h, r, R, hr => by
    rw [ladder]
    refine ExtF.congr (adds_extF h hai hw sz le_rfl (r := r) (dbl_extF hr)) ?_
    congr 1
    · rw [zero_add, pow_one, two_smul]
    · refine Finset.sum_congr rfl fun j _ => ?_
      rw [low_succ (w j) h]
      simp [low]
  | i + 1, h, r, R, hr => by
    rw [ladder]
    have := ladder_extF (sz := sz) hai hw i (by omega)
      (adds_extF h hai hw sz le_rfl (r := r) (dbl_extF hr))
    refine ExtF.congr this ?_
    have e : ∀ j ∈ Finset.range sz,
        low (w j) (i + 1 + 1) • PA j =
          low (w j) (i + 1) • PA j + (2 ^ (i + 1) : ℤ) • ((w j)[i + 1] • PA j) := by
      intro j _
      rw [low_succ (w j) h, add_smul, smul_smul, mul_comm]
    rw [Finset.sum_congr rfl e, Finset.sum_add_distrib, ← Finset.smul_sum]
    generalize ∑ j ∈ Finset.range sz, (w j)[i + 1] • PA j = D
    generalize ∑ j ∈ Finset.range sz, low (w j) (i + 1) • PA j = L
    rw [pow_succ]
    module

/-! ## The table of `A`'s odd multiples -/

/-- `ai[k]` is `(2k + 1) A`, precomputed. -/
theorem table_preF {A : Quad} {PA : Point} (hA : ExtF A PA) (k : ℕ) :
    PreF (table A k) ((2 * k + 1) • PA) := by
  have h2 := fd_ed25519_point_dbln.spec_ext hA.1.proj PA.on hA.2.unsigned (n := 1) le_rfl
  rw [Ed25519.Point.dblN_eq] at h2
  induction k with
  | zero =>
    rw [mul_zero, zero_add, one_smul]
    exact fd_curve25519_into_precomputed.spec_pre hA.1 (hA.2.unsigned.mono (by decide))
  | succ k ih =>
    have e : 2 ^ 1 • PA + (2 * k + 1) • PA = (2 * (k + 1) + 1) • PA := by
      rw [← add_smul]
      congr 1
      ring
    obtain ⟨hE, hF⟩ := add_extF h2 ih
    rw [table, aiTable, ← e]
    exact fd_curve25519_into_precomputed.spec_pre hE (hF.unsigned.mono (by decide))

/-! ## `Σ n[j] A[j]` -/

/-- `multi_scalar_mul_with_opts` computes `Σ n[j] A[j]`, folded, for each `A[j]` extended and
folded and each `n[j] < 2^255`. -/
public theorem spec_val {x : ℕ → BitVec 256} {A : ℕ → Quad} {sz : ℕ} (PA : ℕ → Point)
    (hA : ∀ j < sz, (A j).Ext (PA j).x (PA j).y) (hAF : ∀ j < sz, (A j).Folded)
    (hx : ∀ j < sz, (x j).toNat < 2 ^ 255) :
    let R := spec x A sz
    let Q := ∑ j ∈ Finset.range sz, (x j).toNat • PA j
    R.Ext Q.x Q.y ∧ R.Folded := by
  show ExtF _ _
  have hai : ∀ j < sz, ∀ k < 8, PreF (table (A j) k) ((2 * k + 1) • PA j) :=
    fun j hj k _ => table_preF ⟨hA j hj, hAF j hj⟩ k
  have hw (j k) (hk : k < 256) := (Ref.fd_curve25519_scalar_wnaf.wnaf4_digit (x j) hk).imp_right
    And.right
  refine ExtF.congr (ladder_extF hai hw 255 (by decide) (R := 0)
    fd_ed25519_point_set_zero.spec_ext) ?_
  rw [smul_zero, zero_add]
  refine Finset.sum_congr rfl fun j hj => ?_
  rw [low_256, Ref.fd_curve25519_scalar_wnaf.wnaf_sum (x j) (by decide)
    (hx j (Finset.mem_range.1 hj)), natCast_zsmul]

end fd_ed25519_multi_scalar_mul_with_opts

namespace fd_ed25519_multi_scalar_mul

open _root_.Ed25519 (Point)
open Firedancer.Avx512
open fd_ed25519_multi_scalar_mul_with_opts (ExtF)

/-- `r` after `k` batches: the sum over the points `0 … min (32k) sz - 1`. -/
theorem acc_extF {x : ℕ → BitVec 256} {A : ℕ → Quad} {sz : ℕ} (PA : ℕ → Point)
    (hA : ∀ j < sz, (A j).Ext (PA j).x (PA j).y) (hAF : ∀ j < sz, (A j).Folded)
    (hx : ∀ j < sz, (x j).toNat < 2 ^ 255) :
    ∀ k, ExtF (acc x A sz k) (∑ j ∈ Finset.range (min (32 * k) sz), (x j).toNat • PA j)
  | 0 => by
    simp only [acc, Nat.mul_zero, Nat.zero_min, Finset.range_zero, Finset.sum_empty]
    exact fd_ed25519_point_set_zero.spec_ext
  | k + 1 => by
    have hb := fd_ed25519_multi_scalar_mul_with_opts.spec_val (sz := min (sz - 32 * k) 32)
      (x := fun j => x (32 * k + j)) (A := fun j => A (32 * k + j)) (fun j => PA (32 * k + j))
      (fun j hj => hA (32 * k + j) (by omega)) (fun j hj => hAF (32 * k + j) (by omega))
      (fun j hj => hx (32 * k + j) (by omega))
    have hr := acc_extF PA hA hAF hx k
    have e : min (32 * (k + 1)) sz = min (32 * k) sz + min (sz - 32 * k) 32 := by omega
    rw [acc, e, Finset.sum_range_add]
    have hs : ∑ j ∈ Finset.range (min (sz - 32 * k) 32), (x (min (32 * k) sz + j)).toNat •
        PA (min (32 * k) sz + j) =
        ∑ j ∈ Finset.range (min (sz - 32 * k) 32), (x (32 * k + j)).toNat • PA (32 * k + j) := by
      refine Finset.sum_congr rfl fun j hj => ?_
      rw [Finset.mem_range] at hj
      rw [show min (32 * k) sz = 32 * k by omega]
    rw [hs]
    refine fd_ed25519_point_add_with_opts.spec_ext hr.1 ?_ (Point.on _) (Point.on _)
      (hr.2.unsigned.mono (by decide)) ?_
    · simp only [Quad.Operand, ite_true]
      exact hb.1
    · simp only [ite_true]
      exact hb.2.unsigned.mono (by decide)

/-- `multi_scalar_mul` computes `Σ n[j] A[j]`, folded, for each `A[j]` extended and folded and
each `n[j] < 2^255`. -/
public theorem spec_val {x : ℕ → BitVec 256} {A : ℕ → Quad} {sz : ℕ} (PA : ℕ → Point)
    (hA : ∀ j < sz, (A j).Ext (PA j).x (PA j).y) (hAF : ∀ j < sz, (A j).Folded)
    (hx : ∀ j < sz, (x j).toNat < 2 ^ 255) :
    let R := spec x A sz
    let Q := ∑ j ∈ Finset.range sz, (x j).toNat • PA j
    R.Ext Q.x Q.y ∧ R.Folded := by
  have h := acc_extF PA hA hAF hx ((sz + 31) / 32)
  rw [show min (32 * ((sz + 31) / 32)) sz = sz by omega] at h
  exact h

end fd_ed25519_multi_scalar_mul

end MLIR.Firedancer.LaneNI
