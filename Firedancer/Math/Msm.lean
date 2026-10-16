module

import all Firedancer.Math.Dsmb
public import Firedancer.Math.ScalarMul
public import Firedancer.Ref.fd_ed25519_multi_scalar_mul
import Mathlib.Algebra.BigOperators.GroupWithZero.Action
import Mathlib.Algebra.BigOperators.Intervals
import Mathlib.Tactic.Module

/-! `fd_ed25519_multi_scalar_mul_with_opts` (`base_sz = 0`) and `fd_ed25519_multi_scalar_mul`
compute `Σ (nⱼ mod 2^255) Pⱼ` for affine `Pⱼ`. -/

namespace MLIR.Firedancer.Ref

open _root_.Ed25519 fd_ed25519_double_scalar_mul_base

namespace fd_ed25519_multi_scalar_mul_with_opts

/-- One point's digit add from its table `ai`: `Q + d P`. -/
theorem digit_compl {ai : ℕ → PointLimbs} {P Q : Ed25519.Point} {d : ℤ}
    {rt : PointLimbs × PointLimbs} (ht : ComplL rt.2 Q)
    (hai : ∀ k < 8, Opnd (ai k) 0#32 ((2 * k + 1) • P)) (hai0 : Limbs.val (ai 0).Z = 1)
    (hd : (d = 0 ∨ Odd d) ∧ d.natAbs ≤ 15) :
    ComplL
      (addDigit ai d (if d = 1 then 1#32 else 0#32) (if d = -1 then 1#32 else 0#32) rt.1 rt.2).2
      (Q + d • P) := by
  refine addDigit_compl ht (fun h => ?_) (fun h => ?_)
  · exact opnd_ai hai hai0 h (hd.1.resolve_left (by omega)) hd.2 _ fun h1 => by simp [h1]
  · exact
      opnd_ai hai hai0 (by omega) (hd.1.resolve_left (by omega)).neg (by omega) _ fun h1 => by
        simp [show d ≠ -1 by omega]

/-- The adds over points `0..m` at bit `i`: `Q + Σ_{j<m} wⱼ[i] Pⱼ`. -/
theorem fold_compl {ai : ℕ → ℕ → PointLimbs} {w : ℕ → Vector Int 256} {P : ℕ → Ed25519.Point}
    {i : Fin 256} {M : ℕ} (hai : ∀ j < M, ∀ k < 8, Opnd (ai j k) 0#32 ((2 * k + 1) • P j))
    (hai0 : ∀ j < M, Limbs.val (ai j 0).Z = 1)
    (hw : ∀ j, ((w j)[i] = 0 ∨ Odd (w j)[i]) ∧ (w j)[i].natAbs ≤ 15) {Q : Ed25519.Point} :
    ∀ (m : ℕ),
      m ≤ M →
        ∀ {rt : PointLimbs × PointLimbs},
          ComplL rt.2 Q →
            ComplL
              ((List.range m).foldl
                  (fun rt j =>
                    let n := (w j)[i]
                    addDigit (ai j) n (if n = 1 then 1#32 else 0#32) (if n = -1 then 1#32 else 0#32)
                      rt.1 rt.2)
                  rt).2
              (Q + ∑ j ∈ Finset.range m, (w j)[i] • P j)
  | 0, _, rt, h => by simpa using h
  | m + 1, hm, rt, h => by
    rw [List.range_succ, List.foldl_append, List.foldl_cons, List.foldl_nil, Finset.sum_range_succ,
      ← add_assoc]
    exact
      digit_compl (fold_compl hai hai0 hw m (by omega) h) (hai m (by omega)) (hai0 m (by omega))
        (hw m)

/-- An iteration with `base_sz = 0` at bit `i` on `r`, `R`: `2 R + Σ_{j<sz} wⱼ[i] Pⱼ`. -/
theorem iter_compl {tbl : ℕ → PointLimbs} {ai : ℕ → ℕ → PointLimbs} {w : ℕ → Vector Int 256}
    {P : ℕ → Ed25519.Point} {sz : BitVec 64} {i : Fin 256}
    (hai : ∀ j < sz.toNat, ∀ k < 8, Opnd (ai j k) 0#32 ((2 * k + 1) • P j))
    (hai0 : ∀ j < sz.toNat, Limbs.val (ai j 0).Z = 1)
    (hw : ∀ j, ((w j)[i] = 0 ∨ Odd (w j)[i]) ∧ (w j)[i].natAbs ≤ 15) {r : PointLimbs}
    {R : Ed25519.Point} (hr : ProjT r R) :
    ComplL (iter tbl ai w 0#64 sz i r).2 (2 • R + ∑ j ∈ Finset.range sz.toNat, (w j)[i] • P j) := by
  obtain ⟨hp, bX, bY, bZ⟩ := hr
  obtain ⟨hD, dX, dY, dT, dZ⟩ := fd_ed25519_partial_dbl.spec_compl hp R.on bX bY bZ
  rw [Ed25519.Point.dbl_eq] at hD
  have hf :=
    fold_compl (Q := R + R) (i := i) hai hai0 hw sz.toNat le_rfl (rt :=
      (r, fd_ed25519_partial_dbl.spec r)) ⟨hD, dX, dY, dT.loose, dZ.loose⟩
  rw [two_nsmul]
  simpa [iter, adds, List.range_eq_range'] using hf

/-- One more digit of every point. -/
theorem sum_low_succ (w : ℕ → Vector Int 256) (P : ℕ → Ed25519.Point) (m : ℕ) {i : ℕ}
    (h : i < 256) :
    ∑ j ∈ Finset.range m, low (w j) (i + 1) • P j =
      ∑ j ∈ Finset.range m, low (w j) i • P j +
        (2 ^ i : ℤ) • ∑ j ∈ Finset.range m, (w j)[i] • P j := by
  rw [Finset.smul_sum, ← Finset.sum_add_distrib]
  refine Finset.sum_congr rfl fun j _ => ?_
  rw [low_succ _ h, add_smul, mul_comm, mul_smul]

/-- The ladder with `base_sz = 0` from `i` on `r`, `R`: `2^(i+1) R` plus each point's digits up to
`i`. -/
theorem ladder_ext {tbl : ℕ → PointLimbs} {ai : ℕ → ℕ → PointLimbs} {w : ℕ → Vector Int 256}
    {P : ℕ → Ed25519.Point} {sz : BitVec 64}
    (hai : ∀ j < sz.toNat, ∀ k < 8, Opnd (ai j k) 0#32 ((2 * k + 1) • P j))
    (hai0 : ∀ j < sz.toNat, Limbs.val (ai j 0).Z = 1)
    (hw : ∀ j k (hk : k < 256), ((w j)[k] = 0 ∨ Odd (w j)[k]) ∧ (w j)[k].natAbs ≤ 15) :
    ∀ i (h : i < 256) {r : PointLimbs} {R : Ed25519.Point},
      ProjT r R →
        ExtT (ladder tbl ai w 0#64 sz i h r)
          ((2 ^ (i + 1) : ℤ) • R + ∑ j ∈ Finset.range sz.toNat, low (w j) (i + 1) • P j)
  | 0, h, r, R, hr => by
    rw [ladder]
    obtain ⟨hc, cX, cY, cT, cZ⟩ :=
      iter_compl (tbl := tbl) (sz := sz) (i := ⟨0, h⟩) hai hai0 (fun j => hw j 0 h) hr
    refine ExtT.congr (fd_ed25519_point_add_final_mul.spec_ext hc cX cY cT cZ) ?_
    rw [sum_low_succ w P _ h]
    simp only [low, Finset.range_zero, Finset.sum_empty, zero_smul, Finset.sum_const_zero, zero_add,
      pow_zero, one_smul, Fin.getElem_fin]
    module
  | i + 1, h, r, R, hr => by
    rw [ladder]
    obtain ⟨hc, cX, cY, cT, cZ⟩ :=
      iter_compl (tbl := tbl) (sz := sz) (i := ⟨i + 1, h⟩) hai hai0 (fun j => hw j (i + 1) h) hr
    obtain ⟨hq, pX, pY, pZ⟩ :=
      fd_ed25519_point_add_final_mul_projective.spec_proj hc cX cY cT cZ
        (iter tbl ai w 0#64 sz ⟨i + 1, h⟩ r).1.T
    refine ExtT.congr (ladder_ext hai hai0 hw i (by omega) ⟨hq, pX.under2p, pY, pZ.loose⟩) ?_
    rw [sum_low_succ w P _ h]
    simp only [Fin.getElem_fin, smul_add]
    module

/-- All width-4 digits of `x`: `x mod 2^255`. -/
theorem low_wnaf4 (x : BitVec 256) :
    low (fd_curve25519_scalar_wnaf.wnaf x 4) 256 = ((x.toNat % 2 ^ 255 : ℕ) : ℤ) := by
  have hn : ((x.setWidth 255).setWidth 256).toNat = x.toNat % 2 ^ 255 := by
    simp only [BitVec.toNat_setWidth]
    exact Nat.mod_eq_of_lt ((Nat.mod_lt _ (by decide)).trans (by decide))
  have s :=
    fd_curve25519_scalar_wnaf.wnaf_sum ((x.setWidth 255).setWidth 256) (bits := 4) (by decide)
      (hn ▸ Nat.mod_lt _ (by decide))
  rw [← fd_curve25519_scalar_wnaf.wnaf_mod, hn, ← low_256] at s
  exact s

/-- `ai[j]`, built from an affine representative of `Pⱼ`, holds `Pⱼ`'s odd multiples. -/
theorem aiTable_rep {A : PointLimbs} {P : Ed25519.Point} (hA : A.Rep P) (hZ1 : Limbs.val A.Z = 1) :
    let ai := aiTable (fd_ed25519_point_dbln.spec A 1) (fd_curve25519_into_precomputed.spec A)
    Limbs.val (ai 0).Z = 1 ∧ ∀ k, Opnd (ai k) 0#32 ((2 * k + 1) • P) :=
  aiTable_opnd hA.1 hA.2.1 hA.2.2.1 hA.2.2.2.1.under2p hA.2.2.2.2 hZ1

end fd_ed25519_multi_scalar_mul_with_opts

/-- `with_opts` with `base_sz = 0` on affine representatives `aⱼ` of `Pⱼ`, `j < sz`:
`Σ_{j<sz} (nⱼ mod 2^255) Pⱼ`, tight, whatever `tbl`. (The C needs `sz ≤ 32`.) -/
public theorem fd_ed25519_multi_scalar_mul_with_opts.spec_ext (tbl : ℕ → PointLimbs)
    (n : ℕ → BitVec 256) (a : ℕ → PointLimbs) (sz : BitVec 64) {P : ℕ → Ed25519.Point}
    (ha : ∀ j < sz.toNat, (a j).Rep (P j) ∧ Limbs.val (a j).Z = 1) :
    let R := fd_ed25519_multi_scalar_mul_with_opts.spec tbl n a sz 0#64
    let Q := ∑ j ∈ Finset.range sz.toNat, ((n j).toNat % 2 ^ 255) • P j
    R.Ext Q.x Q.y ∧ R.Tight := by
  show ExtT _ _
  open
    fd_ed25519_multi_scalar_mul_with_opts in
    have key :=
      ladder_ext (tbl := tbl) (ai := fun j =>
        aiTable (fd_ed25519_point_dbln.spec (a j) 1) (fd_curve25519_into_precomputed.spec (a j)))
        (w := fun j => fd_curve25519_scalar_wnaf.wnaf (n j) 4) (sz := sz) (P := P)
        (fun j hj k _ => (aiTable_rep (ha j hj).1 (ha j hj).2).2 k)
        (fun j hj => (aiTable_rep (ha j hj).1 (ha j hj).2).1)
        (fun j k hk => (fd_curve25519_scalar_wnaf.wnaf4_digit (n j) hk).imp_right And.left) 255
        (by decide) (R := 0)
        ⟨⟨fd_ed25519_point_set_zero.spec_ext.1.1, fd_ed25519_point_set_zero.spec_ext.1.2.1,
            fd_ed25519_point_set_zero.spec_ext.1.2.2.1⟩,
          fd_ed25519_point_set_zero.spec_ext.2.1.under2p, fd_ed25519_point_set_zero.spec_ext.2.2.1,
          fd_ed25519_point_set_zero.spec_ext.2.2.2.2.loose⟩
    unfold fd_ed25519_multi_scalar_mul_with_opts.spec
    simp only [ne_eq, not_true_eq_false, false_and, ite_false]
    refine ExtT.congr key ?_
    rw [smul_zero, zero_add]
    refine Finset.sum_congr rfl fun j _ => ?_
    rw [fd_ed25519_multi_scalar_mul_with_opts.low_wnaf4, natCast_zsmul]

/-- The batch loop from `i` on a representative of `R`, with `sz ≤ i + 32 k`:
`R + Σ_{i ≤ j < sz} (nⱼ mod 2^255) Pⱼ`. -/
theorem fd_ed25519_multi_scalar_mul.loop_rep {n : ℕ → BitVec 256} {a : ℕ → PointLimbs} {sz : ℕ}
    {P : ℕ → Ed25519.Point} (hsz : sz < 2 ^ 64)
    (ha : ∀ j < sz, (a j).Rep (P j) ∧ Limbs.val (a j).Z = 1) :
    ∀ k i {r : PointLimbs} {R : Ed25519.Point},
      sz ≤ i + 32 * k →
        r.Rep R →
        (fd_ed25519_multi_scalar_mul.loop n a sz k i r).Rep
          (R + ∑ j ∈ Finset.Ico i sz, ((n j).toNat % 2 ^ 255) • P j)
  | 0, i, r, R, hk, hr => by
    rw [fd_ed25519_multi_scalar_mul.loop, Finset.Ico_eq_empty (by omega), Finset.sum_empty,
      add_zero]
    exact hr
  | k + 1, i, r, R, hk, hr => by
    rw [fd_ed25519_multi_scalar_mul.loop]
    split_ifs with hi
    · dsimp only
      have hb :
        (BitVec.ofNat 64 (min (sz - i) fd_ed25519_multi_scalar_mul.BATCH_SZ)).toNat =
          min (sz - i) 32 := by
        rw [BitVec.toNat_ofNat,
          Nat.mod_eq_of_lt
            (by
              unfold fd_ed25519_multi_scalar_mul.BATCH_SZ; omega)]
        rfl
      obtain ⟨hE, hT⟩ :=
        fd_ed25519_multi_scalar_mul_with_opts.spec_ext (fun _ => fd_ed25519_point_set_zero.spec)
          (fun j => n (i + j)) (fun j => a (i + j))
          (BitVec.ofNat 64 (min (sz - i) fd_ed25519_multi_scalar_mul.BATCH_SZ)) (P := fun j =>
          P (i + j))
          (fun j hj =>
            ha (i + j)
              (by
                rw [hb] at hj; omega))
      have := fd_ed25519_point_add.rep hr (.of_tight hE hT)
      have e :=
        fd_ed25519_multi_scalar_mul.loop_rep (n := n) hsz ha k (i + 32)
          (by
            unfold fd_ed25519_multi_scalar_mul.BATCH_SZ at *; omega)
          this
      unfold fd_ed25519_multi_scalar_mul.BATCH_SZ at hb e ⊢
      refine (congrArg _ ?_).mp e
      have hs :=
        Finset.sum_Ico_eq_sum_range (fun j => ((n j).toNat % 2 ^ 255) • P j) i (i + min (sz - i) 32)
      rw [Nat.add_sub_cancel_left] at hs
      rw [hb, add_assoc, ← hs]
      by_cases hl : sz ≤ i + 32
      · rw [show i + min (sz - i) 32 = sz by omega,
          Finset.Ico_eq_empty_of_le (show sz ≤ i + 32 from hl), Finset.sum_empty, add_zero]
      · rw [show i + min (sz - i) 32 = i + 32 by omega,
          Finset.sum_Ico_consecutive _ (by omega) (by omega)]
    · rw [Finset.Ico_eq_empty (by omega), Finset.sum_empty, add_zero]
      exact hr

/-- `fd_ed25519_multi_scalar_mul` on affine representatives `aⱼ` of `Pⱼ`, `j < sz`:
`Σ_{j<sz} (nⱼ mod 2^255) Pⱼ`. -/
public theorem fd_ed25519_multi_scalar_mul.spec_rep (n : ℕ → BitVec 256) (a : ℕ → PointLimbs)
    (sz : BitVec 64) {P : ℕ → Ed25519.Point}
    (ha : ∀ j < sz.toNat, (a j).Rep (P j) ∧ Limbs.val (a j).Z = 1) :
    (fd_ed25519_multi_scalar_mul.spec n a sz).Rep
      (∑ j ∈ Finset.range sz.toNat, ((n j).toNat % 2 ^ 255) • P j) := by
  have :=
    fd_ed25519_multi_scalar_mul.loop_rep (n := n) sz.isLt ha (sz.toNat / 32 + 1) 0 (by omega)
      fd_ed25519_point_set_zero.spec_rep
  rw [zero_add] at this
  rw [fd_ed25519_multi_scalar_mul.spec, Finset.range_eq_Ico]
  exact this

end MLIR.Firedancer.Ref
