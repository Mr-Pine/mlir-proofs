module

public import Firedancer.Math.Avx512.BaseTable
public import Firedancer.Math.Avx512.Curve
public import Firedancer.Math.Dsmb
public import Firedancer.Avx512.fd_ed25519_double_scalar_mul_base
import Mathlib.Tactic.Module

/-! The AVX-512 `double_scalar_mul_base` computes `n1 A + n2 B` from a table of `B`'s odd
multiples: `ai` holds `A`'s, each wNAF digit adds its odd multiple, and the ladder doubles between
digits. -/

namespace MLIR.Firedancer.Avx512

namespace fd_ed25519_double_scalar_mul_base

open _root_.Ed25519 (Point)
open Ref.fd_ed25519_double_scalar_mul_base (low low_succ low_256 low_add)

/-! ## Definitions -/

/-- `R` is `P` in extended coordinates, folded, as the point operations give it. -/
def ExtF (R : Quad) (P : Point) : Prop :=
  R.Ext P.x P.y ∧ R.Folded

/-- `T` is `P` precomputed, folded, as the adds take their table operand. -/
def PreF (T : Quad) (P : Point) : Prop :=
  T.Pre P.x P.y ∧ T.Folded

/-- `ExtF` of equal points. -/
theorem ExtF.congr {R : Quad} {P Q : Point} (h : ExtF R P) (e : P = Q) : ExtF R Q :=
  e ▸ h

/-! ## The point operations on the group -/

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
  rw [_root_.Ed25519.Point.dbl_eq] at h
  exact h

/-! ## Digits -/

/-- An odd positive `e` with `|e| / 2 < n` indexes its multiple in a table of odd multiples. -/
theorem preF_odd {tb : ℕ → Quad} {P : Point} {n : ℕ}
    (htb : ∀ k < n, PreF (tb k) ((2 * k + 1) • P)) {e : ℤ} (he : 0 < e) (ho : Odd e)
    (hn : e.natAbs / 2 < n) : PreF (tb (e / 2).toNat) (e • P) := by
  obtain ⟨m, rfl⟩ := ho
  have h2 : ((2 * ((2 * m + 1) / 2).toNat + 1 : ℕ) : ℤ) = 2 * m + 1 := by omega
  have := htb ((2 * m + 1) / 2).toNat (by omega)
  rwa [← natCast_zsmul, h2] at this

/-- A digit's add takes `t`, `Q`, to `Q + d P`. -/
theorem addDigit_extF {tb : ℕ → Quad} {d : ℤ} {r t : Quad} {P Q : Point} (ht : ExtF t Q)
    (hp : 0 < d → PreF (tb (d / 2).toNat) (d • P))
    (hm : d < 0 → PreF (tb (-d / 2).toNat) ((-d) • P)) :
    ExtF (addDigit tb d r t).2 (Q + d • P) := by
  unfold addDigit
  split_ifs with h1 h2
  · exact add_extF ht (hp h1)
  · rw [show Q + d • P = Q - (-d) • P by rw [neg_smul, sub_neg_eq_add]]
    exact sub_extF ht (hm h2)
  · obtain rfl : d = 0 := by omega
    rw [zero_smul, add_zero]
    exact ht

/-- A digit's add from a table of `n` odd multiples of `P`: `Q + d P`. -/
theorem addDigit_tbl {tb : ℕ → Quad} {P Q : Point} {n : ℕ} {d : ℤ} {r t : Quad} (ht : ExtF t Q)
    (htb : ∀ k < n, PreF (tb k) ((2 * k + 1) • P)) (hd : d = 0 ∨ Odd d)
    (hn : d.natAbs / 2 < n) : ExtF (addDigit tb d r t).2 (Q + d • P) :=
  addDigit_extF ht (fun h => preF_odd htb h (hd.resolve_left (by omega)) hn)
    (fun h => preF_odd htb (by omega) (hd.resolve_left (by omega)).neg (by omega))

/-- An iteration's adds take `r`, `Q`, to `2 Q + d₁ A + d₂ B`. -/
theorem adds_extF {ai tbl : ℕ → Quad} {PA PB Q : Point} {d1 d2 : ℤ} {r : Quad} (hr : ExtF r Q)
    (hai : ∀ k < 8, PreF (ai k) ((2 * k + 1) • PA))
    (htbl : ∀ k < 128, PreF (tbl k) ((2 * k + 1) • PB))
    (hd1 : (d1 = 0 ∨ Odd d1) ∧ d1.natAbs / 2 < 8) (hd2 : (d2 = 0 ∨ Odd d2) ∧ d2.natAbs / 2 < 128) :
    ExtF (adds ai tbl d1 d2 r).2 (2 • Q + d1 • PA + d2 • PB) := by
  unfold adds add1
  rw [two_nsmul]
  exact addDigit_tbl (addDigit_tbl (dbl_extF hr) hai hd1.1 hd1.2) htbl hd2.1 hd2.2

/-! ## The ladder -/

/-- The main loop from `i` on `r`, `R`: `2^(i+1) R` plus the digits up to `i`. -/
theorem ladder_extF {ai tbl : ℕ → Quad} {PA PB : Point} {w1 w2 : Vector Int 256}
    (hai : ∀ k < 8, PreF (ai k) ((2 * k + 1) • PA))
    (htbl : ∀ k < 128, PreF (tbl k) ((2 * k + 1) • PB))
    (hw1 : ∀ k (hk : k < 256), (w1[k] = 0 ∨ Odd w1[k]) ∧ w1[k].natAbs / 2 < 8)
    (hw2 : ∀ k (hk : k < 256), (w2[k] = 0 ∨ Odd w2[k]) ∧ w2[k].natAbs / 2 < 128) :
    ∀ i (h : i < 256) {r : Quad} {R : Point}, ExtF r R →
      ExtF (ladder ai tbl w1 w2 i h r)
        ((2 ^ (i + 1) : ℤ) • R + low w1 (i + 1) • PA + low w2 (i + 1) • PB)
  | 0, h, r, R, hr => by
    rw [ladder]
    refine ExtF.congr (adds_extF hr hai htbl (hw1 0 h) (hw2 0 h)) ?_
    rw [low_succ w1 h, low_succ w2 h]
    simp only [low, Finset.range_zero, Finset.sum_empty]
    module
  | i + 1, h, r, R, hr => by
    rw [ladder]
    have := ladder_extF hai htbl hw1 hw2 i (by omega)
      (adds_extF hr hai htbl (hw1 (i + 1) h) (hw2 (i + 1) h))
    refine ExtF.congr this ?_
    rw [low_succ w1 h, low_succ w2 h]
    module

/-! ## The table of `A`'s odd multiples -/

/-- `ai[k]` is `(2k + 1) A`, precomputed. -/
theorem aiTable_preF {A : Quad} {PA : Point} (hA : ExtF A PA) (k : ℕ) :
    PreF (aiTable (fd_ed25519_point_dbln.spec A 1) (fd_curve25519_into_precomputed.spec A) k)
      ((2 * k + 1) • PA) := by
  have h2 := fd_ed25519_point_dbln.spec_ext hA.1.proj PA.on hA.2.unsigned (n := 1) le_rfl
  rw [_root_.Ed25519.Point.dblN_eq] at h2
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
theorem start_some {w1 w2 : Vector Int 256} :
    ∀ i (h : i < 256) {j : Fin 256}, start w1 w2 i h = some j →
      ∀ k (hk : k < 256), j.val < k → k ≤ i → w1[k] = 0 ∧ w2[k] = 0
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
theorem start_none {w1 w2 : Vector Int 256} :
    ∀ i (h : i < 256), start w1 w2 i h = none →
      ∀ k (hk : k < 256), k ≤ i → w1[k] = 0 ∧ w2[k] = 0
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

/-! ## `n1 A + n2 B` -/

/-- `double_scalar_mul_base` computes `n1 A + n2 B`, folded, for `A` extended and folded (as
`verify` passes it) and `tbl` holding `B`'s odd multiples `(2j + 1) B` precomputed and folded. -/
public theorem spec_val {tbl : ℕ → Quad} {A : Quad} {n1 n2 : BitVec 256} (PA PB : Point)
    (hA : A.Ext PA.x PA.y) (hAF : A.Folded)
    (htbl : ∀ j < 128,
      (tbl j).Pre ((2 * j + 1) • PB).x ((2 * j + 1) • PB).y ∧ (tbl j).Folded)
    (h1 : n1.toNat < 2 ^ 255) (h2 : n2.toNat < 2 ^ 255) :
    let R := fd_ed25519_double_scalar_mul_base.spec tbl n1 A n2
    let Q := n1.toNat • PA + n2.toNat • PB
    R.Ext Q.x Q.y ∧ R.Folded := by
  show ExtF _ (n1.toNat • PA + n2.toNat • PB)
  have hai := aiTable_preF ⟨hA, hAF⟩
  have hw1 (k) (hk : k < 256) := (Ref.fd_curve25519_scalar_wnaf.wnaf4_digit n1 hk).imp_right
    And.right
  have hw2 (k) (hk : k < 256) := (Ref.fd_curve25519_scalar_wnaf.wnaf8_digit n2 hk).imp_right
    And.right
  have s1 := Ref.fd_curve25519_scalar_wnaf.wnaf_sum n1 (bits := 4) (by decide) h1
  have s2 := Ref.fd_curve25519_scalar_wnaf.wnaf_sum n2 (bits := 8) (by decide) h2
  rw [← low_256] at s1 s2
  rw [← natCast_zsmul, ← natCast_zsmul, ← s1, ← s2]
  unfold spec
  dsimp only
  generalize Ref.fd_curve25519_scalar_wnaf.wnaf n1 4 = w1 at *
  generalize Ref.fd_curve25519_scalar_wnaf.wnaf n2 8 = w2 at *
  generalize aiTable _ _ = ai at *
  split
  · rename_i i hs
    have hz1 : ∀ k (hk : k < 256), i.val + 1 ≤ k → w1[k] = 0 := fun k hk hik =>
      (start_some 255 (by decide) hs k hk (by omega) (by omega)).1
    have hz2 : ∀ k (hk : k < 256), i.val + 1 ≤ k → w2[k] = 0 := fun k hk hik =>
      (start_some 255 (by decide) hs k hk (by omega) (by omega)).2
    have e1 := low_add hz1 (255 - i.val) (by omega)
    have e2 := low_add hz2 (255 - i.val) (by omega)
    rw [show i.val + 1 + (255 - i.val) = 256 by omega] at e1 e2
    refine ExtF.congr (ladder_extF (fun k _ => hai k) htbl hw1 hw2 i i.isLt (R := 0)
      fd_ed25519_point_set_zero.spec_ext) ?_
    rw [e1, e2, smul_zero, zero_add]
  · rename_i hs
    have hz1 : ∀ k (hk : k < 256), 0 ≤ k → w1[k] = 0 := fun k hk _ =>
      (start_none 255 (by decide) hs k hk (by omega)).1
    have hz2 : ∀ k (hk : k < 256), 0 ≤ k → w2[k] = 0 := fun k hk _ =>
      (start_none 255 (by decide) hs k hk (by omega)).2
    have e1 := low_add hz1 256 (by omega)
    have e2 := low_add hz2 256 (by omega)
    simp only [Nat.zero_add] at e1 e2
    rw [e1, e2]
    simp only [low, Finset.range_zero, Finset.sum_empty, zero_smul, add_zero]
    exact fd_ed25519_point_set_zero.spec_ext

/-- With the base point's table: `n1 A + n2 B` for `B` the base point. -/
public theorem spec_val_base {A : Quad} {n1 n2 : BitVec 256} (PA : Point)
    (hA : A.Ext PA.x PA.y) (hAF : A.Folded) (h1 : n1.toNat < 2 ^ 255)
    (h2 : n2.toNat < 2 ^ 255) :
    let R := fd_ed25519_double_scalar_mul_base.spec fd_ed25519_base_point_wnaf_table.point n1 A n2
    let Q := n1.toNat • PA + n2.toNat • _root_.Ed25519.basePoint
    R.Ext Q.x Q.y ∧ R.Folded := by
  refine spec_val PA _ hA hAF (fun j hj => ?_) h1 h2
  obtain ⟨e0, e1, e2, e3, hf, -⟩ := fd_ed25519_base_point_wnaf_table.point_operand hj
  rw [Ref.Ed25519.oddMul_eq_nsmul] at e0 e1 e3
  exact ⟨Quad.Pre.of_affine e0 e1 e2 e3, hf⟩

end fd_ed25519_double_scalar_mul_base

end MLIR.Firedancer.Avx512
