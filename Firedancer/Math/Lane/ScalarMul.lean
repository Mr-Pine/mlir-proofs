module

public import Firedancer.Math.Avx512.Curve
public import Firedancer.Math.Dsmb
public import Firedancer.Lane.fd_ed25519_scalar_mul
import Mathlib.Tactic.Module

/-! `fd_ed25519_scalar_mul` computes `n A`: `ai` holds `A`'s odd multiples, each wNAF digit adds
its odd multiple, and the ladder doubles between digits. -/

namespace MLIR.Firedancer.Lane

namespace fd_ed25519_scalar_mul

open _root_.Ed25519 (Point)
open Firedancer.Avx512
open Avx512.fd_ed25519_double_scalar_mul_base (aiTable addDigit add1)
open Ref.fd_ed25519_double_scalar_mul_base (low low_succ low_256 low_add)

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

/-- An iteration's add takes `r`, `Q`, to `2 Q + d P`. -/
theorem add1_extF {tb : ℕ → Quad} {P Q : Point} {d : ℤ} {r : Quad} (hr : ExtF r Q)
    (htb : ∀ k < 8, PreF (tb k) ((2 * k + 1) • P)) (hd : (d = 0 ∨ Odd d) ∧ d.natAbs / 2 < 8) :
    ExtF (add1 tb d r).2 (2 • Q + d • P) := by
  have ht := dbl_extF hr
  rw [two_nsmul]
  unfold add1 addDigit
  split_ifs with h1 h2
  · exact add_extF ht (preF_odd htb h1 (hd.1.resolve_left (by omega)) hd.2)
  · rw [show Q + Q + d • P = Q + Q - (-d) • P by rw [neg_smul, sub_neg_eq_add]]
    exact sub_extF ht (preF_odd htb (by omega) (hd.1.resolve_left (by omega)).neg (by omega))
  · obtain rfl : d = 0 := by omega
    rw [zero_smul, add_zero]
    exact ht

/-! ## The ladder -/

/-- The main loop from `i` on `r`, `R`: `2^(i+1) R` plus the digits up to `i`. -/
theorem ladder_extF {ai : ℕ → Quad} {PA : Point} {w : Vector Int 256}
    (hai : ∀ k < 8, PreF (ai k) ((2 * k + 1) • PA))
    (hw : ∀ k (hk : k < 256), (w[k] = 0 ∨ Odd w[k]) ∧ w[k].natAbs / 2 < 8) :
    ∀ i (h : i < 256) {r : Quad} {R : Point}, ExtF r R →
      ExtF (ladder ai w i h r) ((2 ^ (i + 1) : ℤ) • R + low w (i + 1) • PA)
  | 0, h, r, R, hr => by
    rw [ladder]
    refine ExtF.congr (add1_extF hr hai (hw 0 h)) ?_
    rw [low_succ w h]
    simp only [low, Finset.range_zero, Finset.sum_empty]
    module
  | i + 1, h, r, R, hr => by
    rw [ladder]
    have := ladder_extF hai hw i (by omega) (add1_extF hr hai (hw (i + 1) h))
    refine ExtF.congr this ?_
    rw [low_succ w h]
    module

/-! ## The table of `A`'s odd multiples -/

/-- `ai[k]` is `(2k + 1) A`, precomputed. -/
theorem aiTable_preF {A : Quad} {PA : Point} (hA : ExtF A PA) (k : ℕ) :
    PreF (aiTable (fd_ed25519_point_dbln.spec A 1) (fd_curve25519_into_precomputed.spec A) k)
      ((2 * k + 1) • PA) := by
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
    rw [aiTable, ← e]
    exact fd_curve25519_into_precomputed.spec_pre hE (hF.unsigned.mono (by decide))

/-! ## The first non-zero digit -/

/-- `start` stops at `j`: the digits above it, up to `i`, are zero. -/
theorem start_some {w : Vector Int 256} :
    ∀ i (h : i < 256) {j : Fin 256}, start w i h = some j →
      ∀ k (hk : k < 256), j.val < k → k ≤ i → w[k] = 0
  | 0, _, _, _, _, _, hjk, hki => absurd hjk (by omega)
  | i + 1, h, j, hs, k, hk, hjk, hki => by
    rw [start] at hs
    split_ifs at hs with hz
    · by_cases hki' : k = i + 1
      · subst hki'
        exact hz
      · exact start_some i (by omega) hs k hk hjk (by omega)
    · have := congrArg Fin.val (Option.some.inj hs)
      simp only at this
      omega

/-- `start` finds nothing: the digits up to `i` are zero. -/
theorem start_none {w : Vector Int 256} :
    ∀ i (h : i < 256), start w i h = none → ∀ k (hk : k < 256), k ≤ i → w[k] = 0
  | 0, _, hs, k, hk, hki => by
    rw [start] at hs
    split_ifs at hs with hz
    · obtain rfl : k = 0 := by omega
      exact hz
  | i + 1, h, hs, k, hk, hki => by
    rw [start] at hs
    split_ifs at hs with hz
    · by_cases hki' : k = i + 1
      · subst hki'
        exact hz
      · exact start_none i (by omega) hs k hk (by omega)

/-! ## `n A` -/

/-- `scalar_mul` computes `n A`, folded, for `A` extended and folded and `n < 2^255`. -/
public theorem spec_val {A : Quad} {n : BitVec 256} (PA : Point) (hA : A.Ext PA.x PA.y)
    (hAF : A.Folded) (h : n.toNat < 2 ^ 255) :
    let R := spec n A
    let Q := n.toNat • PA
    R.Ext Q.x Q.y ∧ R.Folded := by
  show ExtF _ (n.toNat • PA)
  have hai := aiTable_preF ⟨hA, hAF⟩
  have hw (k) (hk : k < 256) := (Ref.fd_curve25519_scalar_wnaf.wnaf4_digit n hk).imp_right
    And.right
  have s := Ref.fd_curve25519_scalar_wnaf.wnaf_sum n (bits := 4) (by decide) h
  rw [← low_256] at s
  rw [← natCast_zsmul, ← s]
  unfold spec
  dsimp only
  generalize Ref.fd_curve25519_scalar_wnaf.wnaf n 4 = w at *
  generalize aiTable _ _ = ai at *
  split
  · rename_i i hs
    have hz : ∀ k (hk : k < 256), i.val + 1 ≤ k → w[k] = 0 := fun k hk hik =>
      start_some 255 (by decide) hs k hk (by omega) (by omega)
    have e := low_add hz (255 - i.val) (by omega)
    rw [show i.val + 1 + (255 - i.val) = 256 by omega] at e
    refine ExtF.congr (ladder_extF (fun k _ => hai k) hw i i.isLt (R := 0)
      fd_ed25519_point_set_zero.spec_ext) ?_
    rw [e, smul_zero, zero_add]
  · rename_i hs
    have hz : ∀ k (hk : k < 256), 0 ≤ k → w[k] = 0 := fun k hk _ =>
      start_none 255 (by decide) hs k hk (by omega)
    have e := low_add hz 256 (by omega)
    simp only [Nat.zero_add] at e
    rw [e]
    simp only [low, Finset.range_zero, Finset.sum_empty, zero_smul]
    exact fd_ed25519_point_set_zero.spec_ext

end fd_ed25519_scalar_mul

end MLIR.Firedancer.Lane
