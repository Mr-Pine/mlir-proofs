module

public import Firedancer.Math.BaseTable
public import Firedancer.Math.Group
public import Firedancer.Math.Wnaf
public import Firedancer.Ref.fd_ed25519_double_scalar_mul_base
import Mathlib.Algebra.BigOperators.Fin
import Mathlib.Tactic.Module

/-! The Ref `double_scalar_mul_base` computes `n1 A + n2 B` from a table of `B`'s odd multiples:
`ai` holds `A`'s, each wNAF digit adds its odd multiple, and the ladder doubles between digits. -/

namespace LeanMLIR.RIR.Firedancer.Ref

namespace fd_ed25519_double_scalar_mul_base

/-! ## Definitions -/

/-- `B` is `P` as `add_with_opts`'s precomputed operand with `Z = 1` flag `zOne`, loose. -/
def Opnd (B : PointLimbs) (zOne : BitVec 32) (P : Ed25519.Point) : Prop :=
  B.Operand zOne 1#32 P.x P.y ∧ B.Loose

/-- `R` is `P` as a completed point, loose. -/
def ComplL (R : PointLimbs) (P : Ed25519.Point) : Prop :=
  R.Compl P.x P.y ∧ R.Loose

/-- `R` is `P` in projective coordinates, as `partial_dbl` takes it. -/
def ProjT (R : PointLimbs) (P : Ed25519.Point) : Prop :=
  R.Proj P.x P.y ∧ Limbs.Under2p R.X ∧ Limbs.Tight R.Y ∧ Limbs.Loose R.Z

/-- `R` is `P` in extended coordinates, tight. -/
def ExtT (R : PointLimbs) (P : Ed25519.Point) : Prop :=
  R.Ext P.x P.y ∧ R.Tight

/-- The value of `w`'s low `i` digits, `Σ_{k < i} w[k] 2^k`. -/
def low (w : Vector Int 256) (i : ℕ) : ℤ :=
  ∑ k ∈ Finset.range i, if h : k < 256 then w[k] * 2 ^ k else 0

/-- `ExtT` of equal points. -/
theorem ExtT.congr {R : PointLimbs} {P Q : Ed25519.Point} (h : ExtT R P) (e : P = Q) : ExtT R Q :=
  e ▸ h

/-! ## Digits -/

/-- An odd positive `e` with `|e| / 2 < n` indexes its multiple in a table of odd multiples. -/
theorem opnd_odd {tb : ℕ → PointLimbs} {z : BitVec 32} {P : Ed25519.Point} {n : ℕ}
    (htb : ∀ k < n, Opnd (tb k) z ((2 * k + 1) • P)) {e : ℤ} (he : 0 < e) (ho : Odd e)
    (hn : e.natAbs / 2 < n) : Opnd (tb (e / 2).toNat) z (e • P) := by
  obtain ⟨m, rfl⟩ := ho
  have h2 : ((2 * ((2 * m + 1) / 2).toNat + 1 : ℕ) : ℤ) = 2 * m + 1 := by omega
  have := htb ((2 * m + 1) / 2).toNat (by omega)
  rwa [← natCast_zsmul, h2] at this

/-- `ai`'s entries: the flag `z` may be set at `e = 1`, where `Z = 1`. -/
theorem opnd_ai {ai : ℕ → PointLimbs} {P : Ed25519.Point}
    (hai : ∀ k < 8, Opnd (ai k) 0#32 ((2 * k + 1) • P)) (hai0 : Limbs.val (ai 0).Z = 1)
    {e : ℤ} (he : 0 < e) (ho : Odd e) (hn : e.natAbs ≤ 15) (z : BitVec 32)
    (hz : e ≠ 1 → z = 0#32) : Opnd (ai (e / 2).toNat) z (e • P) := by
  have h := opnd_odd hai he ho (by omega)
  by_cases h1 : e = 1
  · subst h1
    exact ⟨h.1.of_z_one hai0 z, h.2⟩
  · rw [hz h1]
    exact h

/-- A digit's add takes `t`, `Q`, to `Q + d P`. -/
theorem addDigit_compl {tb : ℕ → PointLimbs} {d : ℤ} {zp zm : BitVec 32} {r t : PointLimbs}
    {P Q : Ed25519.Point} (ht : ComplL t Q) (hp : 0 < d → Opnd (tb (d / 2).toNat) zp (d • P))
    (hm : d < 0 → Opnd (tb (-d / 2).toNat) zm ((-d) • P)) :
    ComplL (addDigit tb d zp zm r t).2 (Q + d • P) := by
  obtain ⟨hc, bX, bY, bT, bZ⟩ := ht
  have hpre : (1#32 = 0#32) = False := by decide
  unfold addDigit
  split_ifs with h1 h2
  · obtain ⟨hE, eX, eY, eT, eZ⟩ := fd_ed25519_point_add_final_mul.spec_ext hc bX bY bT bZ
    obtain ⟨hB, B1, B2, B3, B4⟩ := hp h1
    exact fd_ed25519_point_add_with_opts.spec_compl hE hB Q.on (d • P).on eX eY eT.loose eZ
      (by simp only [hpre, ite_false]; exact ⟨B1, B2⟩) B3 B4 (by decide)
  · obtain ⟨hE, eX, eY, eT, eZ⟩ := fd_ed25519_point_add_final_mul.spec_ext hc bX bY bT bZ
    obtain ⟨hB, B1, B2, B3, B4⟩ := hm h2
    rw [show Q + d • P = Q - (-d) • P by rw [neg_smul, sub_neg_eq_add]]
    exact fd_ed25519_point_sub_with_opts.spec_compl hE hB Q.on ((-d) • P).on eX eY eT.loose eZ
      (by simp only [hpre, ite_false]; exact ⟨B1, B2⟩) B3 B4 (by decide)
  · obtain rfl : d = 0 := by omega
    rw [zero_smul, add_zero]
    exact ⟨hc, bX, bY, bT, bZ⟩

/-- `add1` takes `r`, `Q`, to `2 Q + d A`, `ai` holding `A`'s odd multiples. -/
theorem add1_compl {ai : ℕ → PointLimbs} {P Q : Ed25519.Point} {d : ℤ} {r : PointLimbs}
    (hr : ProjT r Q) (hai : ∀ k < 8, Opnd (ai k) 0#32 ((2 * k + 1) • P))
    (hai0 : Limbs.val (ai 0).Z = 1) (hd : (d = 0 ∨ Odd d) ∧ d.natAbs ≤ 15) :
    ComplL (add1 ai d r).2 (2 • Q + d • P) := by
  obtain ⟨hp, bX, bY, bZ⟩ := hr
  obtain ⟨hD, dX, dY, dT, dZ⟩ := fd_ed25519_partial_dbl.spec_compl hp Q.on bX bY bZ
  rw [Ed25519.Point.dbl_eq] at hD
  rw [two_nsmul]
  unfold add1
  refine addDigit_compl ⟨hD, dX, dY, dT.loose, dZ.loose⟩ (fun h => ?_) (fun h => ?_)
  · exact opnd_ai hai hai0 h (hd.1.resolve_left (by omega)) hd.2 _ fun h1 => by simp [h1]
  · exact opnd_ai hai hai0 (by omega) (hd.1.resolve_left (by omega)).neg (by omega) _
      fun h1 => by simp [show d ≠ -1 by omega]

/-- An iteration's adds take `r`, `Q`, to `2 Q + d₁ A + d₂ B`. -/
theorem adds_compl {ai tbl : ℕ → PointLimbs} {PA PB Q : Ed25519.Point} {d1 d2 : ℤ}
    {r : PointLimbs} (hr : ProjT r Q) (hai : ∀ k < 8, Opnd (ai k) 0#32 ((2 * k + 1) • PA))
    (hai0 : Limbs.val (ai 0).Z = 1) (htbl : ∀ k < 128, Opnd (tbl k) 1#32 ((2 * k + 1) • PB))
    (hd1 : (d1 = 0 ∨ Odd d1) ∧ d1.natAbs ≤ 15) (hd2 : (d2 = 0 ∨ Odd d2) ∧ d2.natAbs ≤ 255) :
    ComplL (adds ai tbl d1 d2 r).2 (2 • Q + d1 • PA + d2 • PB) := by
  unfold adds
  exact addDigit_compl (add1_compl hr hai hai0 hd1)
    (fun h => opnd_odd htbl h (hd2.1.resolve_left (by omega)) (by omega))
    (fun h => opnd_odd htbl (by omega) (hd2.1.resolve_left (by omega)).neg (by omega))

/-! ## The ladder -/

/-- One more digit. -/
theorem low_succ (w : Vector Int 256) {i : ℕ} (h : i < 256) :
    low w (i + 1) = low w i + w[i] * 2 ^ i := by
  rw [low, Finset.sum_range_succ, dite_eq_left_of_eq_true (eq_true h)]
  rfl

/-- All digits: `w`'s value. -/
theorem low_256 (w : Vector Int 256) : low w 256 = ∑ i : Fin 256, w[i] * 2 ^ (i : ℕ) := by
  rw [low, ← Fin.sum_univ_eq_sum_range]
  simp

/-- Zero digits from `j` on add nothing. -/
theorem low_add {w : Vector Int 256} {j : ℕ} (hz : ∀ k (hk : k < 256), j ≤ k → w[k] = 0) :
    ∀ m, j + m ≤ 256 → low w (j + m) = low w j
  | 0, _ => rfl
  | m + 1, h => by
    rw [← Nat.add_assoc, low_succ w (by omega), hz _ _ (by omega), zero_mul, add_zero,
      low_add hz m (by omega)]

/-- The main loop from `i` on `r`, `R`: `2^(i+1) R` plus the digits up to `i`. -/
theorem ladder_ext {ai tbl : ℕ → PointLimbs} {PA PB : Ed25519.Point} {w1 w2 : Vector Int 256}
    (hai : ∀ k < 8, Opnd (ai k) 0#32 ((2 * k + 1) • PA)) (hai0 : Limbs.val (ai 0).Z = 1)
    (htbl : ∀ k < 128, Opnd (tbl k) 1#32 ((2 * k + 1) • PB))
    (hw1 : ∀ k (hk : k < 256), (w1[k] = 0 ∨ Odd w1[k]) ∧ w1[k].natAbs ≤ 15)
    (hw2 : ∀ k (hk : k < 256), (w2[k] = 0 ∨ Odd w2[k]) ∧ w2[k].natAbs ≤ 255) :
    ∀ i (h : i < 256) {r : PointLimbs} {R : Ed25519.Point}, ProjT r R →
      ExtT (ladder ai tbl w1 w2 i h r)
        ((2 ^ (i + 1) : ℤ) • R + low w1 (i + 1) • PA + low w2 (i + 1) • PB)
  | 0, h, r, R, hr => by
    rw [ladder]
    obtain ⟨hc, bX, bY, bT, bZ⟩ := adds_compl hr hai hai0 htbl (hw1 0 h) (hw2 0 h)
    refine ExtT.congr (fd_ed25519_point_add_final_mul.spec_ext hc bX bY bT bZ) ?_
    rw [low_succ w1 h, low_succ w2 h]
    simp only [low, Finset.range_zero, Finset.sum_empty]
    module
  | i + 1, h, r, R, hr => by
    rw [ladder]
    obtain ⟨hc, bX, bY, bT, bZ⟩ := adds_compl hr hai hai0 htbl (hw1 (i + 1) h) (hw2 (i + 1) h)
    obtain ⟨hp, pX, pY, pZ⟩ := fd_ed25519_point_add_final_mul_projective.spec_proj hc bX bY bT bZ
      (adds ai tbl w1[i + 1] w2[i + 1] r).1.T
    have := ladder_ext hai hai0 htbl hw1 hw2 i (by omega) ⟨hp, pX.under2p, pY, pZ.loose⟩
    refine ExtT.congr this ?_
    rw [low_succ w1 h, low_succ w2 h]
    module

/-! ## The table of `A`'s odd multiples -/

/-- `ai[i]` is `(2i + 1) A` as a precomputed operand, `ai[0]` with `Z = 1`. -/
theorem aiTable_opnd {A : PointLimbs} {PA : Ed25519.Point} (hA : A.Ext PA.x PA.y)
    (hAX : Limbs.Under2p A.X) (hAY : Limbs.Tight A.Y) (hAT : Limbs.Under2p A.T)
    (hAZ : Limbs.Tight A.Z) (hZ1 : Limbs.val A.Z = 1) :
    let ai := aiTable (fd_ed25519_point_dbln.spec A 1) (fd_curve25519_into_precomputed.spec A)
    Limbs.val (ai 0).Z = 1 ∧ ∀ k, Opnd (ai k) 0#32 ((2 * k + 1) • PA) := by
  intro ai
  obtain ⟨h0, b0X, b0Y, b0T, b0Z⟩ := fd_curve25519_into_precomputed.spec_operand hA hAX hAY
    hAT.loose
  have hai0 : Limbs.val (ai 0).Z = 1 := by
    simp only [ai, aiTable, b0Z, hZ1]
  obtain ⟨h2, b2X, b2Y, b2T, b2Z⟩ := fd_ed25519_point_dbln.spec_ext ⟨hA.1, hA.2.1, hA.2.2.1⟩
    PA.on hAX hAY hAZ.loose (n := 1) le_rfl
  rw [Ed25519.Point.dblN_eq] at h2
  refine ⟨hai0, fun k => ?_⟩
  induction k with
  | zero =>
    simp only [mul_zero, zero_add, one_smul]
    exact ⟨h0, b0X, b0Y, b0T.loose, b0Z ▸ hAZ.loose⟩
  | succ k ih =>
    obtain ⟨hB, B1, B2, B3, B4⟩ := ih
    have hB' : (ai k).Operand (if k + 1 = 1 then 1#32 else 0#32) 1#32
        ((2 * k + 1) • PA).x ((2 * k + 1) • PA).y := by
      split_ifs with hk
      · obtain rfl : k = 0 := by omega
        exact hB.of_z_one hai0 _
      · exact hB
    obtain ⟨hc, cX, cY, cT, cZ⟩ := fd_ed25519_point_add_with_opts.spec_compl (skip := 1#32) h2 hB'
      (2 ^ 1 • PA).on ((2 * k + 1) • PA).on b2X b2Y b2T.loose b2Z
      (by simp only [show (1#32 = 0#32) = False by decide, ite_false]; exact ⟨B1, B2⟩) B3 B4
      (by decide)
    obtain ⟨he, eX, eY, eT, eZ⟩ := fd_ed25519_point_add_final_mul.spec_ext hc cX cY cT cZ
    obtain ⟨hp, pX, pY, pT, pZ⟩ := fd_curve25519_into_precomputed.spec_operand he eX.under2p eY
      eT.loose
    have e : 2 ^ 1 • PA + (2 * k + 1) • PA = (2 * (k + 1) + 1) • PA := by
      rw [← add_smul]
      congr 1
      ring
    simp only [ai, aiTable]
    rw [← e]
    exact ⟨hp, pX, pY, pT.loose, pZ ▸ eZ.loose⟩

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

/-- `double_scalar_mul_base` computes `n1 A + n2 B`, tight, for `A` as `verify` passes it (`Z = 1`)
and `tbl` holding `B`'s odd multiples `(2j + 1) B` as precomputed operands with `Z = 1`. -/
public theorem spec_val {tbl : ℕ → PointLimbs} {A : PointLimbs}
    {n1 n2 : BitVec 256} (PA PB : Ed25519.Point) (hA : A.Ext PA.x PA.y)
    (hAX : Limbs.Under2p A.X) (hAY : Limbs.Tight A.Y) (hAT : Limbs.Under2p A.T)
    (hAZ : Limbs.Tight A.Z) (hZ1 : Limbs.val A.Z = 1)
    (htbl : ∀ j < 128,
      (tbl j).Operand 1#32 1#32 ((2 * j + 1) • PB).x ((2 * j + 1) • PB).y ∧ (tbl j).Loose)
    (h1 : n1.toNat < 2 ^ 255) (h2 : n2.toNat < 2 ^ 255) :
    let R := fd_ed25519_double_scalar_mul_base.spec tbl n1 A n2
    let Q := n1.toNat • PA + n2.toNat • PB
    R.Ext Q.x Q.y ∧ R.Tight := by
  show ExtT _ (n1.toNat • PA + n2.toNat • PB)
  obtain ⟨hai0, hai⟩ := aiTable_opnd hA hAX hAY hAT hAZ hZ1
  have hw1 (k) (hk : k < 256) := (fd_curve25519_scalar_wnaf.wnaf4_digit n1 hk).imp_right And.left
  have hw2 (k) (hk : k < 256) := (fd_curve25519_scalar_wnaf.wnaf8_digit n2 hk).imp_right And.left
  have s1 := fd_curve25519_scalar_wnaf.wnaf_sum n1 (bits := 4) (by decide) h1
  have s2 := fd_curve25519_scalar_wnaf.wnaf_sum n2 (bits := 8) (by decide) h2
  rw [← low_256] at s1 s2
  rw [← natCast_zsmul, ← natCast_zsmul, ← s1, ← s2]
  unfold spec
  dsimp only
  generalize fd_curve25519_scalar_wnaf.wnaf n1 4 = w1 at *
  generalize fd_curve25519_scalar_wnaf.wnaf n2 8 = w2 at *
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
    obtain ⟨hZ, bZ⟩ := fd_ed25519_point_set_zero.spec_ext
    refine ExtT.congr (ladder_ext (fun k _ => hai k) hai0 htbl hw1 hw2 i i.isLt (R := 0)
      ⟨⟨hZ.1, hZ.2.1, hZ.2.2.1⟩, bZ.1.under2p, bZ.2.1, bZ.2.2.2.loose⟩) ?_
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
public theorem spec_val_base {A : PointLimbs} {n1 n2 : BitVec 256} (PA : Ed25519.Point)
    (hA : A.Ext PA.x PA.y) (hAX : Limbs.Under2p A.X) (hAY : Limbs.Tight A.Y)
    (hAT : Limbs.Under2p A.T) (hAZ : Limbs.Tight A.Z) (hZ1 : Limbs.val A.Z = 1)
    (h1 : n1.toNat < 2 ^ 255) (h2 : n2.toNat < 2 ^ 255) :
    let R := fd_ed25519_double_scalar_mul_base.spec baseTbl n1 A n2
    let Q := n1.toNat • PA + n2.toNat • Ed25519.basePoint
    R.Ext Q.x Q.y ∧ R.Tight := by
  refine spec_val PA _ hA hAX hAY hAT hAZ hZ1 (fun j hj => ?_) h1 h2
  obtain ⟨hop, bX, bY, bT, bZ, -⟩ := baseTbl_operand hj
  rw [Ed25519.oddMul_eq_nsmul] at hop
  exact ⟨hop, bX, bY, bT.loose, bZ.loose⟩

end fd_ed25519_double_scalar_mul_base

end LeanMLIR.RIR.Firedancer.Ref
