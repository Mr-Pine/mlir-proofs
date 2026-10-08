module

public import Firedancer.Math.Avx512.QuadMul
public import Firedancer.Avx512.fd_r43x6_quad_sqr_fast
import Mathlib.Tactic.Ring

/-! `fd_r43x6_quad_sqr_fast` in `ZMod p`: four independent squares, each lane `j < 4` and `j + 4`
of the QUAD's vectors one element's limbs. -/

namespace LeanMLIR.RIR.Firedancer.Avx512

open LeanMLIR.RIR.Firedancer.Ref (p)

namespace R43x6

-- the lane `simp` sets are shared by all lanes, each using part of them
set_option linter.unusedSimpArgs false

/-- The limb pairs `a < b` whose product `fd_r43x6_quad_sqr_fast` doubles through limb `b`. -/
abbrev QuadSqrSwap (a b : ℕ) : Prop :=
  (a = 4 ∧ b = 5) ∨ (a = 1 ∧ b = 5) ∨ (a = 2 ∧ b = 3)

/-- `madd52lo`'s product of limbs `a ≤ b` of element `j` of `x`, one of them doubled unless
`a = b`. -/
def lqsqr (x03 x14 x25 : Wwl) (j a b : ℕ) : ℕ :=
  if a = b then
    (madd52lo (quadElem x03 x14 x25 j)[a]! (quadElem x03 x14 x25 j)[a]!).toNat
  else if QuadSqrSwap a b then
    (madd52lo ((quadElem x03 x14 x25 j)[b]! <<< 1) (quadElem x03 x14 x25 j)[a]!).toNat
  else (madd52lo ((quadElem x03 x14 x25 j)[a]! <<< 1) (quadElem x03 x14 x25 j)[b]!).toNat

/-- `madd52hi`'s product of limbs `a ≤ b` of element `j` of `x`, one of them doubled unless
`a = b`. -/
def hqsqr (x03 x14 x25 : Wwl) (j a b : ℕ) : ℕ :=
  if a = b then
    (madd52hi (quadElem x03 x14 x25 j)[a]! (quadElem x03 x14 x25 j)[a]!).toNat
  else if QuadSqrSwap a b then
    (madd52hi ((quadElem x03 x14 x25 j)[b]! <<< 1) (quadElem x03 x14 x25 j)[a]!).toNat
  else (madd52hi ((quadElem x03 x14 x25 j)[a]! <<< 1) (quadElem x03 x14 x25 j)[b]!).toNat

theorem lqsqr_lt {x03 x14 x25 : Wwl} {j a b : ℕ} : lqsqr x03 x14 x25 j a b < 2 ^ 52 := by
  unfold lqsqr
  split
  · exact madd52lo_lt _ _
  · split <;> exact madd52lo_lt _ _

theorem hqsqr_lt {x03 x14 x25 : Wwl} {j : ℕ} (hx : Unsigned 47 (quadElem x03 x14 x25 j)) :
    ∀ a b, a ≤ b → b < 6 → hqsqr x03 x14 x25 j a b < 2 ^ 43 := fun a b _ hb => by
  unfold hqsqr
  split
  · exact (madd52hi_lt47 (hx.get! (by omega)) (hx.get! (by omega))).trans (by norm_num)
  · split
    · exact madd52hi_lt48 (shl1_lt (hx.get! hb)) (hx.get! (by omega))
    · exact madd52hi_lt48 (shl1_lt (hx.get! (by omega))) (hx.get! hb)

theorem lqsqr_split {x03 x14 x25 : Wwl} {j : ℕ} (hx : Unsigned 47 (quadElem x03 x14 x25 j)) :
    ∀ i, i < 6 → (quadElem x03 x14 x25 j)[i]!.toNat * (quadElem x03 x14 x25 j)[i]!.toNat =
      lqsqr x03 x14 x25 j i i + 2 ^ 52 * hqsqr x03 x14 x25 j i i := fun i hi => by
  simp only [lqsqr, hqsqr, ↓reduceIte]
  exact madd52_split ((hx.get! hi).trans (by norm_num)) ((hx.get! hi).trans (by norm_num))

theorem lqsqr_split' {x03 x14 x25 : Wwl} {j : ℕ} (hx : Unsigned 47 (quadElem x03 x14 x25 j)) :
    ∀ a b, a < b → b < 6 →
      2 * (quadElem x03 x14 x25 j)[a]!.toNat * (quadElem x03 x14 x25 j)[b]!.toNat =
        lqsqr x03 x14 x25 j a b + 2 ^ 52 * hqsqr x03 x14 x25 j a b := fun a b hab hb => by
  have ba := hx.get! (show a < 6 by omega)
  have bb := hx.get! hb
  simp only [lqsqr, hqsqr, show a ≠ b by omega, ↓reduceIte]
  split
  · rw [← madd52_split ((shl1_lt bb).trans (by norm_num)) (ba.trans (by norm_num)),
      shl1_toNat (by omega)]
    ring
  · rw [← madd52_split ((shl1_lt ba).trans (by norm_num)) (bb.trans (by norm_num)),
      shl1_toNat (by omega)]

/-- An element `j < 4` of a QUAD whose limbs are the columns `za + 152 zb` of `X ^ 2` has value
`X ^ 2` and `u63` limbs. -/
theorem quad_val_of_scol_lanes {z03 z14 z25 : Wwl} {L H : ℕ → ℕ → ℕ} {X : ℕ → ℕ} {j : ℕ}
    (hj : j < 4) (e0 : (z03[j]'(by omega)).toNat = scol L H 0 + 152 * scol L H 6)
    (e1 : (z14[j]'(by omega)).toNat = scol L H 1 + 152 * scol L H 7)
    (e2 : (z25[j]'(by omega)).toNat = scol L H 2 + 152 * scol L H 8)
    (e3 : (z03[j + 4]'(by omega)).toNat = scol L H 3 + 152 * scol L H 9)
    (e4 : (z14[j + 4]'(by omega)).toNat = scol L H 4 + 152 * scol L H 10)
    (e5 : (z25[j + 4]'(by omega)).toNat = scol L H 5 + 152 * scol L H 11)
    (hd : ∀ i, i < 6 → X i * X i = L i i + 2 ^ 52 * H i i)
    (ho : ∀ i j, i < j → j < 6 → 2 * X i * X j = L i j + 2 ^ 52 * H i j)
    (hc : ∀ n, n < 6 → scol L H n + 152 * scol L H (n + 6) < 2 ^ 63) :
    val (quadElem z03 z14 z25 j) = (limbs6 X : ZMod p) ^ 2 ∧
      Unsigned 63 (quadElem z03 z14 z25 j) := by
  have e : ∀ k, k < 6 → (quadElem z03 z14 z25 j)[k]!.toNat = scol L H k + 152 * scol L H (k + 6) :=
    fun k hk => by
      match k, hk with
      | 0, _ | 1, _ | 2, _ | 3, _ | 4, _ | 5, _ =>
        simp only [quadElem, getElem!_pos, Vector.getElem_mk, List.getElem_toArray,
          List.getElem_cons_zero, List.getElem_cons_succ, Nat.reduceLT, Nat.reduceAdd, e0, e1, e2,
          e3, e4, e5, show j < 8 by omega, show j + 4 < 8 by omega]
  have z63 : Unsigned 63 (quadElem z03 z14 z25 j) := fun i => by
    have := e i i.2
    rw [getElem!_pos _ _ (by omega)] at this
    rw [this]
    exact hc i i.2
  refine ⟨val_of_scol ?_ z63 hd ho, z63⟩
  rw [nat_eq_limbs6]
  simp only [limbs6, e 0 (by norm_num), e 1 (by norm_num), e 2 (by norm_num), e 3 (by norm_num),
    e 4 (by norm_num), e 5 (by norm_num)]

set_option hygiene false in
/-- The bounds `omega` needs on the `madd52` halves in lane 0 of element 0. -/
local macro "quad_sqr_bounds00" : tactic =>
  `(tactic| (
    have := madd52lo_lt (x03[0]'(by decide)) (x03[0]'(by decide))
    have := madd52lo_lt ((x25[4]'(by decide)) <<< 1) (x14[0]'(by decide))
    have := madd52lo_lt ((x25[0]'(by decide)) <<< 1) (x14[4]'(by decide))
    have := madd52lo_lt (x03[4]'(by decide)) (x03[4]'(by decide))
    have := madd52hi_lt48 (a := (x03[0]'(by decide)) <<< 1) (b := (x25[4]'(by decide)))
      (shl1_lt (by simpa [quadElem] using hx 0)) (by simpa [quadElem] using hx 5)
    have := madd52hi_lt48 (a := (x14[0]'(by decide)) <<< 1) (b := (x14[4]'(by decide)))
      (shl1_lt (by simpa [quadElem] using hx 1)) (by simpa [quadElem] using hx 4)
    have := madd52hi_lt48 (a := (x03[4]'(by decide)) <<< 1) (b := (x25[0]'(by decide)))
      (shl1_lt (by simpa [quadElem] using hx 3)) (by simpa [quadElem] using hx 2)
    skip))

set_option hygiene false in
/-- The bounds `omega` needs on the `madd52` halves in lane 1 of element 0. -/
local macro "quad_sqr_bounds01" : tactic =>
  `(tactic| (
    have := madd52lo_lt ((x03[0]'(by decide)) <<< 1) (x14[0]'(by decide))
    have := madd52lo_lt ((x25[0]'(by decide)) <<< 1) (x25[4]'(by decide))
    have := madd52lo_lt ((x03[4]'(by decide)) <<< 1) (x14[4]'(by decide))
    have := madd52hi_lt47 (a := (x03[0]'(by decide))) (b := (x03[0]'(by decide)))
      (by simpa [quadElem] using hx 0) (by simpa [quadElem] using hx 0)
    have := madd52hi_lt48 (a := (x25[4]'(by decide)) <<< 1) (b := (x14[0]'(by decide)))
      (shl1_lt (by simpa [quadElem] using hx 5)) (by simpa [quadElem] using hx 1)
    have := madd52hi_lt48 (a := (x25[0]'(by decide)) <<< 1) (b := (x14[4]'(by decide)))
      (shl1_lt (by simpa [quadElem] using hx 2)) (by simpa [quadElem] using hx 4)
    have := madd52hi_lt47 (a := (x03[4]'(by decide))) (b := (x03[4]'(by decide)))
      (by simpa [quadElem] using hx 3) (by simpa [quadElem] using hx 3)
    skip))

set_option hygiene false in
/-- The bounds `omega` needs on the `madd52` halves in lane 2 of element 0. -/
local macro "quad_sqr_bounds02" : tactic =>
  `(tactic| (
    have := madd52lo_lt ((x03[0]'(by decide)) <<< 1) (x25[0]'(by decide))
    have := madd52lo_lt (x14[0]'(by decide)) (x14[0]'(by decide))
    have := madd52lo_lt ((x03[4]'(by decide)) <<< 1) (x25[4]'(by decide))
    have := madd52lo_lt (x14[4]'(by decide)) (x14[4]'(by decide))
    have := madd52hi_lt48 (a := (x03[0]'(by decide)) <<< 1) (b := (x14[0]'(by decide)))
      (shl1_lt (by simpa [quadElem] using hx 0)) (by simpa [quadElem] using hx 1)
    have := madd52hi_lt48 (a := (x25[0]'(by decide)) <<< 1) (b := (x25[4]'(by decide)))
      (shl1_lt (by simpa [quadElem] using hx 2)) (by simpa [quadElem] using hx 5)
    have := madd52hi_lt48 (a := (x03[4]'(by decide)) <<< 1) (b := (x14[4]'(by decide)))
      (shl1_lt (by simpa [quadElem] using hx 3)) (by simpa [quadElem] using hx 4)
    skip))

set_option hygiene false in
/-- The bounds `omega` needs on the `madd52` halves in lane 3 of element 0. -/
local macro "quad_sqr_bounds03" : tactic =>
  `(tactic| (
    have := madd52lo_lt ((x03[0]'(by decide)) <<< 1) (x03[4]'(by decide))
    have := madd52lo_lt ((x14[0]'(by decide)) <<< 1) (x25[0]'(by decide))
    have := madd52lo_lt ((x25[4]'(by decide)) <<< 1) (x14[4]'(by decide))
    have := madd52hi_lt48 (a := (x03[0]'(by decide)) <<< 1) (b := (x25[0]'(by decide)))
      (shl1_lt (by simpa [quadElem] using hx 0)) (by simpa [quadElem] using hx 2)
    have := madd52hi_lt47 (a := (x14[0]'(by decide))) (b := (x14[0]'(by decide)))
      (by simpa [quadElem] using hx 1) (by simpa [quadElem] using hx 1)
    have := madd52hi_lt48 (a := (x03[4]'(by decide)) <<< 1) (b := (x25[4]'(by decide)))
      (shl1_lt (by simpa [quadElem] using hx 3)) (by simpa [quadElem] using hx 5)
    have := madd52hi_lt47 (a := (x14[4]'(by decide))) (b := (x14[4]'(by decide)))
      (by simpa [quadElem] using hx 4) (by simpa [quadElem] using hx 4)
    skip))

set_option hygiene false in
/-- The bounds `omega` needs on the `madd52` halves in lane 4 of element 0. -/
local macro "quad_sqr_bounds04" : tactic =>
  `(tactic| (
    have := madd52lo_lt ((x03[0]'(by decide)) <<< 1) (x14[4]'(by decide))
    have := madd52lo_lt ((x14[0]'(by decide)) <<< 1) (x03[4]'(by decide))
    have := madd52lo_lt (x25[0]'(by decide)) (x25[0]'(by decide))
    have := madd52lo_lt (x25[4]'(by decide)) (x25[4]'(by decide))
    have := madd52hi_lt48 (a := (x03[0]'(by decide)) <<< 1) (b := (x03[4]'(by decide)))
      (shl1_lt (by simpa [quadElem] using hx 0)) (by simpa [quadElem] using hx 3)
    have := madd52hi_lt48 (a := (x14[0]'(by decide)) <<< 1) (b := (x25[0]'(by decide)))
      (shl1_lt (by simpa [quadElem] using hx 1)) (by simpa [quadElem] using hx 2)
    have := madd52hi_lt48 (a := (x25[4]'(by decide)) <<< 1) (b := (x14[4]'(by decide)))
      (shl1_lt (by simpa [quadElem] using hx 5)) (by simpa [quadElem] using hx 4)
    skip))

set_option hygiene false in
/-- The bounds `omega` needs on the `madd52` halves in lane 5 of element 0. -/
local macro "quad_sqr_bounds05" : tactic =>
  `(tactic| (
    have := madd52lo_lt ((x03[0]'(by decide)) <<< 1) (x25[4]'(by decide))
    have := madd52lo_lt ((x14[0]'(by decide)) <<< 1) (x14[4]'(by decide))
    have := madd52lo_lt ((x03[4]'(by decide)) <<< 1) (x25[0]'(by decide))
    have := madd52hi_lt48 (a := (x03[0]'(by decide)) <<< 1) (b := (x14[4]'(by decide)))
      (shl1_lt (by simpa [quadElem] using hx 0)) (by simpa [quadElem] using hx 4)
    have := madd52hi_lt48 (a := (x14[0]'(by decide)) <<< 1) (b := (x03[4]'(by decide)))
      (shl1_lt (by simpa [quadElem] using hx 1)) (by simpa [quadElem] using hx 3)
    have := madd52hi_lt47 (a := (x25[0]'(by decide))) (b := (x25[0]'(by decide)))
      (by simpa [quadElem] using hx 2) (by simpa [quadElem] using hx 2)
    have := madd52hi_lt47 (a := (x25[4]'(by decide))) (b := (x25[4]'(by decide)))
      (by simpa [quadElem] using hx 5) (by simpa [quadElem] using hx 5)
    skip))

set_option hygiene false in
/-- The bounds `omega` needs on the `madd52` halves in lane 0 of element 1. -/
local macro "quad_sqr_bounds10" : tactic =>
  `(tactic| (
    have := madd52lo_lt (x03[1]'(by decide)) (x03[1]'(by decide))
    have := madd52lo_lt ((x25[5]'(by decide)) <<< 1) (x14[1]'(by decide))
    have := madd52lo_lt ((x25[1]'(by decide)) <<< 1) (x14[5]'(by decide))
    have := madd52lo_lt (x03[5]'(by decide)) (x03[5]'(by decide))
    have := madd52hi_lt48 (a := (x03[1]'(by decide)) <<< 1) (b := (x25[5]'(by decide)))
      (shl1_lt (by simpa [quadElem] using hx 0)) (by simpa [quadElem] using hx 5)
    have := madd52hi_lt48 (a := (x14[1]'(by decide)) <<< 1) (b := (x14[5]'(by decide)))
      (shl1_lt (by simpa [quadElem] using hx 1)) (by simpa [quadElem] using hx 4)
    have := madd52hi_lt48 (a := (x03[5]'(by decide)) <<< 1) (b := (x25[1]'(by decide)))
      (shl1_lt (by simpa [quadElem] using hx 3)) (by simpa [quadElem] using hx 2)
    skip))

set_option hygiene false in
/-- The bounds `omega` needs on the `madd52` halves in lane 1 of element 1. -/
local macro "quad_sqr_bounds11" : tactic =>
  `(tactic| (
    have := madd52lo_lt ((x03[1]'(by decide)) <<< 1) (x14[1]'(by decide))
    have := madd52lo_lt ((x25[1]'(by decide)) <<< 1) (x25[5]'(by decide))
    have := madd52lo_lt ((x03[5]'(by decide)) <<< 1) (x14[5]'(by decide))
    have := madd52hi_lt47 (a := (x03[1]'(by decide))) (b := (x03[1]'(by decide)))
      (by simpa [quadElem] using hx 0) (by simpa [quadElem] using hx 0)
    have := madd52hi_lt48 (a := (x25[5]'(by decide)) <<< 1) (b := (x14[1]'(by decide)))
      (shl1_lt (by simpa [quadElem] using hx 5)) (by simpa [quadElem] using hx 1)
    have := madd52hi_lt48 (a := (x25[1]'(by decide)) <<< 1) (b := (x14[5]'(by decide)))
      (shl1_lt (by simpa [quadElem] using hx 2)) (by simpa [quadElem] using hx 4)
    have := madd52hi_lt47 (a := (x03[5]'(by decide))) (b := (x03[5]'(by decide)))
      (by simpa [quadElem] using hx 3) (by simpa [quadElem] using hx 3)
    skip))

set_option hygiene false in
/-- The bounds `omega` needs on the `madd52` halves in lane 2 of element 1. -/
local macro "quad_sqr_bounds12" : tactic =>
  `(tactic| (
    have := madd52lo_lt ((x03[1]'(by decide)) <<< 1) (x25[1]'(by decide))
    have := madd52lo_lt (x14[1]'(by decide)) (x14[1]'(by decide))
    have := madd52lo_lt ((x03[5]'(by decide)) <<< 1) (x25[5]'(by decide))
    have := madd52lo_lt (x14[5]'(by decide)) (x14[5]'(by decide))
    have := madd52hi_lt48 (a := (x03[1]'(by decide)) <<< 1) (b := (x14[1]'(by decide)))
      (shl1_lt (by simpa [quadElem] using hx 0)) (by simpa [quadElem] using hx 1)
    have := madd52hi_lt48 (a := (x25[1]'(by decide)) <<< 1) (b := (x25[5]'(by decide)))
      (shl1_lt (by simpa [quadElem] using hx 2)) (by simpa [quadElem] using hx 5)
    have := madd52hi_lt48 (a := (x03[5]'(by decide)) <<< 1) (b := (x14[5]'(by decide)))
      (shl1_lt (by simpa [quadElem] using hx 3)) (by simpa [quadElem] using hx 4)
    skip))

set_option hygiene false in
/-- The bounds `omega` needs on the `madd52` halves in lane 3 of element 1. -/
local macro "quad_sqr_bounds13" : tactic =>
  `(tactic| (
    have := madd52lo_lt ((x03[1]'(by decide)) <<< 1) (x03[5]'(by decide))
    have := madd52lo_lt ((x14[1]'(by decide)) <<< 1) (x25[1]'(by decide))
    have := madd52lo_lt ((x25[5]'(by decide)) <<< 1) (x14[5]'(by decide))
    have := madd52hi_lt48 (a := (x03[1]'(by decide)) <<< 1) (b := (x25[1]'(by decide)))
      (shl1_lt (by simpa [quadElem] using hx 0)) (by simpa [quadElem] using hx 2)
    have := madd52hi_lt47 (a := (x14[1]'(by decide))) (b := (x14[1]'(by decide)))
      (by simpa [quadElem] using hx 1) (by simpa [quadElem] using hx 1)
    have := madd52hi_lt48 (a := (x03[5]'(by decide)) <<< 1) (b := (x25[5]'(by decide)))
      (shl1_lt (by simpa [quadElem] using hx 3)) (by simpa [quadElem] using hx 5)
    have := madd52hi_lt47 (a := (x14[5]'(by decide))) (b := (x14[5]'(by decide)))
      (by simpa [quadElem] using hx 4) (by simpa [quadElem] using hx 4)
    skip))

set_option hygiene false in
/-- The bounds `omega` needs on the `madd52` halves in lane 4 of element 1. -/
local macro "quad_sqr_bounds14" : tactic =>
  `(tactic| (
    have := madd52lo_lt ((x03[1]'(by decide)) <<< 1) (x14[5]'(by decide))
    have := madd52lo_lt ((x14[1]'(by decide)) <<< 1) (x03[5]'(by decide))
    have := madd52lo_lt (x25[1]'(by decide)) (x25[1]'(by decide))
    have := madd52lo_lt (x25[5]'(by decide)) (x25[5]'(by decide))
    have := madd52hi_lt48 (a := (x03[1]'(by decide)) <<< 1) (b := (x03[5]'(by decide)))
      (shl1_lt (by simpa [quadElem] using hx 0)) (by simpa [quadElem] using hx 3)
    have := madd52hi_lt48 (a := (x14[1]'(by decide)) <<< 1) (b := (x25[1]'(by decide)))
      (shl1_lt (by simpa [quadElem] using hx 1)) (by simpa [quadElem] using hx 2)
    have := madd52hi_lt48 (a := (x25[5]'(by decide)) <<< 1) (b := (x14[5]'(by decide)))
      (shl1_lt (by simpa [quadElem] using hx 5)) (by simpa [quadElem] using hx 4)
    skip))

set_option hygiene false in
/-- The bounds `omega` needs on the `madd52` halves in lane 5 of element 1. -/
local macro "quad_sqr_bounds15" : tactic =>
  `(tactic| (
    have := madd52lo_lt ((x03[1]'(by decide)) <<< 1) (x25[5]'(by decide))
    have := madd52lo_lt ((x14[1]'(by decide)) <<< 1) (x14[5]'(by decide))
    have := madd52lo_lt ((x03[5]'(by decide)) <<< 1) (x25[1]'(by decide))
    have := madd52hi_lt48 (a := (x03[1]'(by decide)) <<< 1) (b := (x14[5]'(by decide)))
      (shl1_lt (by simpa [quadElem] using hx 0)) (by simpa [quadElem] using hx 4)
    have := madd52hi_lt48 (a := (x14[1]'(by decide)) <<< 1) (b := (x03[5]'(by decide)))
      (shl1_lt (by simpa [quadElem] using hx 1)) (by simpa [quadElem] using hx 3)
    have := madd52hi_lt47 (a := (x25[1]'(by decide))) (b := (x25[1]'(by decide)))
      (by simpa [quadElem] using hx 2) (by simpa [quadElem] using hx 2)
    have := madd52hi_lt47 (a := (x25[5]'(by decide))) (b := (x25[5]'(by decide)))
      (by simpa [quadElem] using hx 5) (by simpa [quadElem] using hx 5)
    skip))

set_option hygiene false in
/-- The bounds `omega` needs on the `madd52` halves in lane 0 of element 2. -/
local macro "quad_sqr_bounds20" : tactic =>
  `(tactic| (
    have := madd52lo_lt (x03[2]'(by decide)) (x03[2]'(by decide))
    have := madd52lo_lt ((x25[6]'(by decide)) <<< 1) (x14[2]'(by decide))
    have := madd52lo_lt ((x25[2]'(by decide)) <<< 1) (x14[6]'(by decide))
    have := madd52lo_lt (x03[6]'(by decide)) (x03[6]'(by decide))
    have := madd52hi_lt48 (a := (x03[2]'(by decide)) <<< 1) (b := (x25[6]'(by decide)))
      (shl1_lt (by simpa [quadElem] using hx 0)) (by simpa [quadElem] using hx 5)
    have := madd52hi_lt48 (a := (x14[2]'(by decide)) <<< 1) (b := (x14[6]'(by decide)))
      (shl1_lt (by simpa [quadElem] using hx 1)) (by simpa [quadElem] using hx 4)
    have := madd52hi_lt48 (a := (x03[6]'(by decide)) <<< 1) (b := (x25[2]'(by decide)))
      (shl1_lt (by simpa [quadElem] using hx 3)) (by simpa [quadElem] using hx 2)
    skip))

set_option hygiene false in
/-- The bounds `omega` needs on the `madd52` halves in lane 1 of element 2. -/
local macro "quad_sqr_bounds21" : tactic =>
  `(tactic| (
    have := madd52lo_lt ((x03[2]'(by decide)) <<< 1) (x14[2]'(by decide))
    have := madd52lo_lt ((x25[2]'(by decide)) <<< 1) (x25[6]'(by decide))
    have := madd52lo_lt ((x03[6]'(by decide)) <<< 1) (x14[6]'(by decide))
    have := madd52hi_lt47 (a := (x03[2]'(by decide))) (b := (x03[2]'(by decide)))
      (by simpa [quadElem] using hx 0) (by simpa [quadElem] using hx 0)
    have := madd52hi_lt48 (a := (x25[6]'(by decide)) <<< 1) (b := (x14[2]'(by decide)))
      (shl1_lt (by simpa [quadElem] using hx 5)) (by simpa [quadElem] using hx 1)
    have := madd52hi_lt48 (a := (x25[2]'(by decide)) <<< 1) (b := (x14[6]'(by decide)))
      (shl1_lt (by simpa [quadElem] using hx 2)) (by simpa [quadElem] using hx 4)
    have := madd52hi_lt47 (a := (x03[6]'(by decide))) (b := (x03[6]'(by decide)))
      (by simpa [quadElem] using hx 3) (by simpa [quadElem] using hx 3)
    skip))

set_option hygiene false in
/-- The bounds `omega` needs on the `madd52` halves in lane 2 of element 2. -/
local macro "quad_sqr_bounds22" : tactic =>
  `(tactic| (
    have := madd52lo_lt ((x03[2]'(by decide)) <<< 1) (x25[2]'(by decide))
    have := madd52lo_lt (x14[2]'(by decide)) (x14[2]'(by decide))
    have := madd52lo_lt ((x03[6]'(by decide)) <<< 1) (x25[6]'(by decide))
    have := madd52lo_lt (x14[6]'(by decide)) (x14[6]'(by decide))
    have := madd52hi_lt48 (a := (x03[2]'(by decide)) <<< 1) (b := (x14[2]'(by decide)))
      (shl1_lt (by simpa [quadElem] using hx 0)) (by simpa [quadElem] using hx 1)
    have := madd52hi_lt48 (a := (x25[2]'(by decide)) <<< 1) (b := (x25[6]'(by decide)))
      (shl1_lt (by simpa [quadElem] using hx 2)) (by simpa [quadElem] using hx 5)
    have := madd52hi_lt48 (a := (x03[6]'(by decide)) <<< 1) (b := (x14[6]'(by decide)))
      (shl1_lt (by simpa [quadElem] using hx 3)) (by simpa [quadElem] using hx 4)
    skip))

set_option hygiene false in
/-- The bounds `omega` needs on the `madd52` halves in lane 3 of element 2. -/
local macro "quad_sqr_bounds23" : tactic =>
  `(tactic| (
    have := madd52lo_lt ((x03[2]'(by decide)) <<< 1) (x03[6]'(by decide))
    have := madd52lo_lt ((x14[2]'(by decide)) <<< 1) (x25[2]'(by decide))
    have := madd52lo_lt ((x25[6]'(by decide)) <<< 1) (x14[6]'(by decide))
    have := madd52hi_lt48 (a := (x03[2]'(by decide)) <<< 1) (b := (x25[2]'(by decide)))
      (shl1_lt (by simpa [quadElem] using hx 0)) (by simpa [quadElem] using hx 2)
    have := madd52hi_lt47 (a := (x14[2]'(by decide))) (b := (x14[2]'(by decide)))
      (by simpa [quadElem] using hx 1) (by simpa [quadElem] using hx 1)
    have := madd52hi_lt48 (a := (x03[6]'(by decide)) <<< 1) (b := (x25[6]'(by decide)))
      (shl1_lt (by simpa [quadElem] using hx 3)) (by simpa [quadElem] using hx 5)
    have := madd52hi_lt47 (a := (x14[6]'(by decide))) (b := (x14[6]'(by decide)))
      (by simpa [quadElem] using hx 4) (by simpa [quadElem] using hx 4)
    skip))

set_option hygiene false in
/-- The bounds `omega` needs on the `madd52` halves in lane 4 of element 2. -/
local macro "quad_sqr_bounds24" : tactic =>
  `(tactic| (
    have := madd52lo_lt ((x03[2]'(by decide)) <<< 1) (x14[6]'(by decide))
    have := madd52lo_lt ((x14[2]'(by decide)) <<< 1) (x03[6]'(by decide))
    have := madd52lo_lt (x25[2]'(by decide)) (x25[2]'(by decide))
    have := madd52lo_lt (x25[6]'(by decide)) (x25[6]'(by decide))
    have := madd52hi_lt48 (a := (x03[2]'(by decide)) <<< 1) (b := (x03[6]'(by decide)))
      (shl1_lt (by simpa [quadElem] using hx 0)) (by simpa [quadElem] using hx 3)
    have := madd52hi_lt48 (a := (x14[2]'(by decide)) <<< 1) (b := (x25[2]'(by decide)))
      (shl1_lt (by simpa [quadElem] using hx 1)) (by simpa [quadElem] using hx 2)
    have := madd52hi_lt48 (a := (x25[6]'(by decide)) <<< 1) (b := (x14[6]'(by decide)))
      (shl1_lt (by simpa [quadElem] using hx 5)) (by simpa [quadElem] using hx 4)
    skip))

set_option hygiene false in
/-- The bounds `omega` needs on the `madd52` halves in lane 5 of element 2. -/
local macro "quad_sqr_bounds25" : tactic =>
  `(tactic| (
    have := madd52lo_lt ((x03[2]'(by decide)) <<< 1) (x25[6]'(by decide))
    have := madd52lo_lt ((x14[2]'(by decide)) <<< 1) (x14[6]'(by decide))
    have := madd52lo_lt ((x03[6]'(by decide)) <<< 1) (x25[2]'(by decide))
    have := madd52hi_lt48 (a := (x03[2]'(by decide)) <<< 1) (b := (x14[6]'(by decide)))
      (shl1_lt (by simpa [quadElem] using hx 0)) (by simpa [quadElem] using hx 4)
    have := madd52hi_lt48 (a := (x14[2]'(by decide)) <<< 1) (b := (x03[6]'(by decide)))
      (shl1_lt (by simpa [quadElem] using hx 1)) (by simpa [quadElem] using hx 3)
    have := madd52hi_lt47 (a := (x25[2]'(by decide))) (b := (x25[2]'(by decide)))
      (by simpa [quadElem] using hx 2) (by simpa [quadElem] using hx 2)
    have := madd52hi_lt47 (a := (x25[6]'(by decide))) (b := (x25[6]'(by decide)))
      (by simpa [quadElem] using hx 5) (by simpa [quadElem] using hx 5)
    skip))

set_option hygiene false in
/-- The bounds `omega` needs on the `madd52` halves in lane 0 of element 3. -/
local macro "quad_sqr_bounds30" : tactic =>
  `(tactic| (
    have := madd52lo_lt (x03[3]'(by decide)) (x03[3]'(by decide))
    have := madd52lo_lt ((x25[7]'(by decide)) <<< 1) (x14[3]'(by decide))
    have := madd52lo_lt ((x25[3]'(by decide)) <<< 1) (x14[7]'(by decide))
    have := madd52lo_lt (x03[7]'(by decide)) (x03[7]'(by decide))
    have := madd52hi_lt48 (a := (x03[3]'(by decide)) <<< 1) (b := (x25[7]'(by decide)))
      (shl1_lt (by simpa [quadElem] using hx 0)) (by simpa [quadElem] using hx 5)
    have := madd52hi_lt48 (a := (x14[3]'(by decide)) <<< 1) (b := (x14[7]'(by decide)))
      (shl1_lt (by simpa [quadElem] using hx 1)) (by simpa [quadElem] using hx 4)
    have := madd52hi_lt48 (a := (x03[7]'(by decide)) <<< 1) (b := (x25[3]'(by decide)))
      (shl1_lt (by simpa [quadElem] using hx 3)) (by simpa [quadElem] using hx 2)
    skip))

set_option hygiene false in
/-- The bounds `omega` needs on the `madd52` halves in lane 1 of element 3. -/
local macro "quad_sqr_bounds31" : tactic =>
  `(tactic| (
    have := madd52lo_lt ((x03[3]'(by decide)) <<< 1) (x14[3]'(by decide))
    have := madd52lo_lt ((x25[3]'(by decide)) <<< 1) (x25[7]'(by decide))
    have := madd52lo_lt ((x03[7]'(by decide)) <<< 1) (x14[7]'(by decide))
    have := madd52hi_lt47 (a := (x03[3]'(by decide))) (b := (x03[3]'(by decide)))
      (by simpa [quadElem] using hx 0) (by simpa [quadElem] using hx 0)
    have := madd52hi_lt48 (a := (x25[7]'(by decide)) <<< 1) (b := (x14[3]'(by decide)))
      (shl1_lt (by simpa [quadElem] using hx 5)) (by simpa [quadElem] using hx 1)
    have := madd52hi_lt48 (a := (x25[3]'(by decide)) <<< 1) (b := (x14[7]'(by decide)))
      (shl1_lt (by simpa [quadElem] using hx 2)) (by simpa [quadElem] using hx 4)
    have := madd52hi_lt47 (a := (x03[7]'(by decide))) (b := (x03[7]'(by decide)))
      (by simpa [quadElem] using hx 3) (by simpa [quadElem] using hx 3)
    skip))

set_option hygiene false in
/-- The bounds `omega` needs on the `madd52` halves in lane 2 of element 3. -/
local macro "quad_sqr_bounds32" : tactic =>
  `(tactic| (
    have := madd52lo_lt ((x03[3]'(by decide)) <<< 1) (x25[3]'(by decide))
    have := madd52lo_lt (x14[3]'(by decide)) (x14[3]'(by decide))
    have := madd52lo_lt ((x03[7]'(by decide)) <<< 1) (x25[7]'(by decide))
    have := madd52lo_lt (x14[7]'(by decide)) (x14[7]'(by decide))
    have := madd52hi_lt48 (a := (x03[3]'(by decide)) <<< 1) (b := (x14[3]'(by decide)))
      (shl1_lt (by simpa [quadElem] using hx 0)) (by simpa [quadElem] using hx 1)
    have := madd52hi_lt48 (a := (x25[3]'(by decide)) <<< 1) (b := (x25[7]'(by decide)))
      (shl1_lt (by simpa [quadElem] using hx 2)) (by simpa [quadElem] using hx 5)
    have := madd52hi_lt48 (a := (x03[7]'(by decide)) <<< 1) (b := (x14[7]'(by decide)))
      (shl1_lt (by simpa [quadElem] using hx 3)) (by simpa [quadElem] using hx 4)
    skip))

set_option hygiene false in
/-- The bounds `omega` needs on the `madd52` halves in lane 3 of element 3. -/
local macro "quad_sqr_bounds33" : tactic =>
  `(tactic| (
    have := madd52lo_lt ((x03[3]'(by decide)) <<< 1) (x03[7]'(by decide))
    have := madd52lo_lt ((x14[3]'(by decide)) <<< 1) (x25[3]'(by decide))
    have := madd52lo_lt ((x25[7]'(by decide)) <<< 1) (x14[7]'(by decide))
    have := madd52hi_lt48 (a := (x03[3]'(by decide)) <<< 1) (b := (x25[3]'(by decide)))
      (shl1_lt (by simpa [quadElem] using hx 0)) (by simpa [quadElem] using hx 2)
    have := madd52hi_lt47 (a := (x14[3]'(by decide))) (b := (x14[3]'(by decide)))
      (by simpa [quadElem] using hx 1) (by simpa [quadElem] using hx 1)
    have := madd52hi_lt48 (a := (x03[7]'(by decide)) <<< 1) (b := (x25[7]'(by decide)))
      (shl1_lt (by simpa [quadElem] using hx 3)) (by simpa [quadElem] using hx 5)
    have := madd52hi_lt47 (a := (x14[7]'(by decide))) (b := (x14[7]'(by decide)))
      (by simpa [quadElem] using hx 4) (by simpa [quadElem] using hx 4)
    skip))

set_option hygiene false in
/-- The bounds `omega` needs on the `madd52` halves in lane 4 of element 3. -/
local macro "quad_sqr_bounds34" : tactic =>
  `(tactic| (
    have := madd52lo_lt ((x03[3]'(by decide)) <<< 1) (x14[7]'(by decide))
    have := madd52lo_lt ((x14[3]'(by decide)) <<< 1) (x03[7]'(by decide))
    have := madd52lo_lt (x25[3]'(by decide)) (x25[3]'(by decide))
    have := madd52lo_lt (x25[7]'(by decide)) (x25[7]'(by decide))
    have := madd52hi_lt48 (a := (x03[3]'(by decide)) <<< 1) (b := (x03[7]'(by decide)))
      (shl1_lt (by simpa [quadElem] using hx 0)) (by simpa [quadElem] using hx 3)
    have := madd52hi_lt48 (a := (x14[3]'(by decide)) <<< 1) (b := (x25[3]'(by decide)))
      (shl1_lt (by simpa [quadElem] using hx 1)) (by simpa [quadElem] using hx 2)
    have := madd52hi_lt48 (a := (x25[7]'(by decide)) <<< 1) (b := (x14[7]'(by decide)))
      (shl1_lt (by simpa [quadElem] using hx 5)) (by simpa [quadElem] using hx 4)
    skip))

set_option hygiene false in
/-- The bounds `omega` needs on the `madd52` halves in lane 5 of element 3. -/
local macro "quad_sqr_bounds35" : tactic =>
  `(tactic| (
    have := madd52lo_lt ((x03[3]'(by decide)) <<< 1) (x25[7]'(by decide))
    have := madd52lo_lt ((x14[3]'(by decide)) <<< 1) (x14[7]'(by decide))
    have := madd52lo_lt ((x03[7]'(by decide)) <<< 1) (x25[3]'(by decide))
    have := madd52hi_lt48 (a := (x03[3]'(by decide)) <<< 1) (b := (x14[7]'(by decide)))
      (shl1_lt (by simpa [quadElem] using hx 0)) (by simpa [quadElem] using hx 4)
    have := madd52hi_lt48 (a := (x14[3]'(by decide)) <<< 1) (b := (x03[7]'(by decide)))
      (shl1_lt (by simpa [quadElem] using hx 1)) (by simpa [quadElem] using hx 3)
    have := madd52hi_lt47 (a := (x25[3]'(by decide))) (b := (x25[3]'(by decide)))
      (by simpa [quadElem] using hx 2) (by simpa [quadElem] using hx 2)
    have := madd52hi_lt47 (a := (x25[7]'(by decide))) (b := (x25[7]'(by decide)))
      (by simpa [quadElem] using hx 5) (by simpa [quadElem] using hx 5)
    skip))

/-- A lane of `fd_r43x6_quad_sqr_fast` as its columns: the lane operations, `toNat` with no
overflow, then `ring`. -/
local macro "quad_sqr_lane" : tactic =>
  `(tactic| (
    unfold fd_r43x6_quad_sqr_fast.spec
    iterate 3
      try simp only [wwl_add_get, wwl_and_get, wwl_shl_get, wwl_madd52lo_get,
        wwl_madd52hi_get, wwl_pack_halves_get, wwl_pack_h0_h1_get, wwl_get0, wwl_get1,
        wwl_get2, wwl_get3, wwl_get4, wwl_get5, wwl_get6, wwl_get7, wwl_zero_get, getD_get,
        Vector.getElem_replicate, BitVec.reduceToNat, Nat.reduceMod, Nat.reduceLT, Nat.reduceAdd,
        Nat.reduceSub, Nat.reduceMul, ite_true, ite_false, Vector.getElem_mk,
        List.getElem_toArray, List.getElem_cons_zero, List.getElem_cons_succ,
        Bool.false_eq_true, ↓reduceIte]
    try simp only [madd52lo_zero, madd52hi_zero, madd52lo_zero', madd52hi_zero',
      madd52lo_zero_left, madd52hi_zero_left, BitVec.zero_shiftLeft]
    simp only [scol, lqsqr, hqsqr, QuadSqrSwap, quadElem, getElem!_pos, Nat.reduceLT, Nat.reduceAdd,
      Nat.reduceEqDiff, Vector.getElem_mk, List.getElem_toArray, List.getElem_cons_zero,
      List.getElem_cons_succ, ↓reduceIte, and_true, and_false, or_false, or_true, false_or,
      true_or, BitVec.zero_add, BitVec.add_zero, BitVec.toNat_add, BitVec.toNat_shiftLeft,
      Nat.shiftLeft_eq, BitVec.reduceToNat, BitVec.toNat_zero, Nat.reducePow, Nat.reduceMod,
      Nat.zero_add, Nat.add_zero, Nat.zero_mod, Nat.zero_mul]
    simp (disch := omega) only [Nat.mod_eq_of_lt, Nat.mod_mod]
    ring))

theorem quad_sqr_lane00 {x03 x14 x25 : Wwl}
    (hx : Unsigned 47 (quadElem x03 x14 x25 0)) :
    (fd_r43x6_quad_sqr_fast.spec x03 x14 x25).1[0].toNat =
      scol (lqsqr x03 x14 x25 0) (hqsqr x03 x14 x25 0) 0 +
        152 * scol (lqsqr x03 x14 x25 0) (hqsqr x03 x14 x25 0) 6 := by
  quad_sqr_bounds00
  quad_sqr_lane

theorem quad_sqr_lane01 {x03 x14 x25 : Wwl}
    (hx : Unsigned 47 (quadElem x03 x14 x25 0)) :
    (fd_r43x6_quad_sqr_fast.spec x03 x14 x25).2.1[0].toNat =
      scol (lqsqr x03 x14 x25 0) (hqsqr x03 x14 x25 0) 1 +
        152 * scol (lqsqr x03 x14 x25 0) (hqsqr x03 x14 x25 0) 7 := by
  quad_sqr_bounds01
  quad_sqr_lane

theorem quad_sqr_lane02 {x03 x14 x25 : Wwl}
    (hx : Unsigned 47 (quadElem x03 x14 x25 0)) :
    (fd_r43x6_quad_sqr_fast.spec x03 x14 x25).2.2[0].toNat =
      scol (lqsqr x03 x14 x25 0) (hqsqr x03 x14 x25 0) 2 +
        152 * scol (lqsqr x03 x14 x25 0) (hqsqr x03 x14 x25 0) 8 := by
  quad_sqr_bounds02
  quad_sqr_lane

theorem quad_sqr_lane03 {x03 x14 x25 : Wwl}
    (hx : Unsigned 47 (quadElem x03 x14 x25 0)) :
    (fd_r43x6_quad_sqr_fast.spec x03 x14 x25).1[4].toNat =
      scol (lqsqr x03 x14 x25 0) (hqsqr x03 x14 x25 0) 3 +
        152 * scol (lqsqr x03 x14 x25 0) (hqsqr x03 x14 x25 0) 9 := by
  quad_sqr_bounds03
  quad_sqr_lane

theorem quad_sqr_lane04 {x03 x14 x25 : Wwl}
    (hx : Unsigned 47 (quadElem x03 x14 x25 0)) :
    (fd_r43x6_quad_sqr_fast.spec x03 x14 x25).2.1[4].toNat =
      scol (lqsqr x03 x14 x25 0) (hqsqr x03 x14 x25 0) 4 +
        152 * scol (lqsqr x03 x14 x25 0) (hqsqr x03 x14 x25 0) 10 := by
  quad_sqr_bounds04
  quad_sqr_lane

theorem quad_sqr_lane05 {x03 x14 x25 : Wwl}
    (hx : Unsigned 47 (quadElem x03 x14 x25 0)) :
    (fd_r43x6_quad_sqr_fast.spec x03 x14 x25).2.2[4].toNat =
      scol (lqsqr x03 x14 x25 0) (hqsqr x03 x14 x25 0) 5 +
        152 * scol (lqsqr x03 x14 x25 0) (hqsqr x03 x14 x25 0) 11 := by
  quad_sqr_bounds05
  quad_sqr_lane

theorem quad_sqr_lane10 {x03 x14 x25 : Wwl}
    (hx : Unsigned 47 (quadElem x03 x14 x25 1)) :
    (fd_r43x6_quad_sqr_fast.spec x03 x14 x25).1[1].toNat =
      scol (lqsqr x03 x14 x25 1) (hqsqr x03 x14 x25 1) 0 +
        152 * scol (lqsqr x03 x14 x25 1) (hqsqr x03 x14 x25 1) 6 := by
  quad_sqr_bounds10
  quad_sqr_lane

theorem quad_sqr_lane11 {x03 x14 x25 : Wwl}
    (hx : Unsigned 47 (quadElem x03 x14 x25 1)) :
    (fd_r43x6_quad_sqr_fast.spec x03 x14 x25).2.1[1].toNat =
      scol (lqsqr x03 x14 x25 1) (hqsqr x03 x14 x25 1) 1 +
        152 * scol (lqsqr x03 x14 x25 1) (hqsqr x03 x14 x25 1) 7 := by
  quad_sqr_bounds11
  quad_sqr_lane

theorem quad_sqr_lane12 {x03 x14 x25 : Wwl}
    (hx : Unsigned 47 (quadElem x03 x14 x25 1)) :
    (fd_r43x6_quad_sqr_fast.spec x03 x14 x25).2.2[1].toNat =
      scol (lqsqr x03 x14 x25 1) (hqsqr x03 x14 x25 1) 2 +
        152 * scol (lqsqr x03 x14 x25 1) (hqsqr x03 x14 x25 1) 8 := by
  quad_sqr_bounds12
  quad_sqr_lane

theorem quad_sqr_lane13 {x03 x14 x25 : Wwl}
    (hx : Unsigned 47 (quadElem x03 x14 x25 1)) :
    (fd_r43x6_quad_sqr_fast.spec x03 x14 x25).1[5].toNat =
      scol (lqsqr x03 x14 x25 1) (hqsqr x03 x14 x25 1) 3 +
        152 * scol (lqsqr x03 x14 x25 1) (hqsqr x03 x14 x25 1) 9 := by
  quad_sqr_bounds13
  quad_sqr_lane

theorem quad_sqr_lane14 {x03 x14 x25 : Wwl}
    (hx : Unsigned 47 (quadElem x03 x14 x25 1)) :
    (fd_r43x6_quad_sqr_fast.spec x03 x14 x25).2.1[5].toNat =
      scol (lqsqr x03 x14 x25 1) (hqsqr x03 x14 x25 1) 4 +
        152 * scol (lqsqr x03 x14 x25 1) (hqsqr x03 x14 x25 1) 10 := by
  quad_sqr_bounds14
  quad_sqr_lane

theorem quad_sqr_lane15 {x03 x14 x25 : Wwl}
    (hx : Unsigned 47 (quadElem x03 x14 x25 1)) :
    (fd_r43x6_quad_sqr_fast.spec x03 x14 x25).2.2[5].toNat =
      scol (lqsqr x03 x14 x25 1) (hqsqr x03 x14 x25 1) 5 +
        152 * scol (lqsqr x03 x14 x25 1) (hqsqr x03 x14 x25 1) 11 := by
  quad_sqr_bounds15
  quad_sqr_lane

theorem quad_sqr_lane20 {x03 x14 x25 : Wwl}
    (hx : Unsigned 47 (quadElem x03 x14 x25 2)) :
    (fd_r43x6_quad_sqr_fast.spec x03 x14 x25).1[2].toNat =
      scol (lqsqr x03 x14 x25 2) (hqsqr x03 x14 x25 2) 0 +
        152 * scol (lqsqr x03 x14 x25 2) (hqsqr x03 x14 x25 2) 6 := by
  quad_sqr_bounds20
  quad_sqr_lane

theorem quad_sqr_lane21 {x03 x14 x25 : Wwl}
    (hx : Unsigned 47 (quadElem x03 x14 x25 2)) :
    (fd_r43x6_quad_sqr_fast.spec x03 x14 x25).2.1[2].toNat =
      scol (lqsqr x03 x14 x25 2) (hqsqr x03 x14 x25 2) 1 +
        152 * scol (lqsqr x03 x14 x25 2) (hqsqr x03 x14 x25 2) 7 := by
  quad_sqr_bounds21
  quad_sqr_lane

theorem quad_sqr_lane22 {x03 x14 x25 : Wwl}
    (hx : Unsigned 47 (quadElem x03 x14 x25 2)) :
    (fd_r43x6_quad_sqr_fast.spec x03 x14 x25).2.2[2].toNat =
      scol (lqsqr x03 x14 x25 2) (hqsqr x03 x14 x25 2) 2 +
        152 * scol (lqsqr x03 x14 x25 2) (hqsqr x03 x14 x25 2) 8 := by
  quad_sqr_bounds22
  quad_sqr_lane

theorem quad_sqr_lane23 {x03 x14 x25 : Wwl}
    (hx : Unsigned 47 (quadElem x03 x14 x25 2)) :
    (fd_r43x6_quad_sqr_fast.spec x03 x14 x25).1[6].toNat =
      scol (lqsqr x03 x14 x25 2) (hqsqr x03 x14 x25 2) 3 +
        152 * scol (lqsqr x03 x14 x25 2) (hqsqr x03 x14 x25 2) 9 := by
  quad_sqr_bounds23
  quad_sqr_lane

theorem quad_sqr_lane24 {x03 x14 x25 : Wwl}
    (hx : Unsigned 47 (quadElem x03 x14 x25 2)) :
    (fd_r43x6_quad_sqr_fast.spec x03 x14 x25).2.1[6].toNat =
      scol (lqsqr x03 x14 x25 2) (hqsqr x03 x14 x25 2) 4 +
        152 * scol (lqsqr x03 x14 x25 2) (hqsqr x03 x14 x25 2) 10 := by
  quad_sqr_bounds24
  quad_sqr_lane

theorem quad_sqr_lane25 {x03 x14 x25 : Wwl}
    (hx : Unsigned 47 (quadElem x03 x14 x25 2)) :
    (fd_r43x6_quad_sqr_fast.spec x03 x14 x25).2.2[6].toNat =
      scol (lqsqr x03 x14 x25 2) (hqsqr x03 x14 x25 2) 5 +
        152 * scol (lqsqr x03 x14 x25 2) (hqsqr x03 x14 x25 2) 11 := by
  quad_sqr_bounds25
  quad_sqr_lane

theorem quad_sqr_lane30 {x03 x14 x25 : Wwl}
    (hx : Unsigned 47 (quadElem x03 x14 x25 3)) :
    (fd_r43x6_quad_sqr_fast.spec x03 x14 x25).1[3].toNat =
      scol (lqsqr x03 x14 x25 3) (hqsqr x03 x14 x25 3) 0 +
        152 * scol (lqsqr x03 x14 x25 3) (hqsqr x03 x14 x25 3) 6 := by
  quad_sqr_bounds30
  quad_sqr_lane

theorem quad_sqr_lane31 {x03 x14 x25 : Wwl}
    (hx : Unsigned 47 (quadElem x03 x14 x25 3)) :
    (fd_r43x6_quad_sqr_fast.spec x03 x14 x25).2.1[3].toNat =
      scol (lqsqr x03 x14 x25 3) (hqsqr x03 x14 x25 3) 1 +
        152 * scol (lqsqr x03 x14 x25 3) (hqsqr x03 x14 x25 3) 7 := by
  quad_sqr_bounds31
  quad_sqr_lane

theorem quad_sqr_lane32 {x03 x14 x25 : Wwl}
    (hx : Unsigned 47 (quadElem x03 x14 x25 3)) :
    (fd_r43x6_quad_sqr_fast.spec x03 x14 x25).2.2[3].toNat =
      scol (lqsqr x03 x14 x25 3) (hqsqr x03 x14 x25 3) 2 +
        152 * scol (lqsqr x03 x14 x25 3) (hqsqr x03 x14 x25 3) 8 := by
  quad_sqr_bounds32
  quad_sqr_lane

theorem quad_sqr_lane33 {x03 x14 x25 : Wwl}
    (hx : Unsigned 47 (quadElem x03 x14 x25 3)) :
    (fd_r43x6_quad_sqr_fast.spec x03 x14 x25).1[7].toNat =
      scol (lqsqr x03 x14 x25 3) (hqsqr x03 x14 x25 3) 3 +
        152 * scol (lqsqr x03 x14 x25 3) (hqsqr x03 x14 x25 3) 9 := by
  quad_sqr_bounds33
  quad_sqr_lane

theorem quad_sqr_lane34 {x03 x14 x25 : Wwl}
    (hx : Unsigned 47 (quadElem x03 x14 x25 3)) :
    (fd_r43x6_quad_sqr_fast.spec x03 x14 x25).2.1[7].toNat =
      scol (lqsqr x03 x14 x25 3) (hqsqr x03 x14 x25 3) 4 +
        152 * scol (lqsqr x03 x14 x25 3) (hqsqr x03 x14 x25 3) 10 := by
  quad_sqr_bounds34
  quad_sqr_lane

theorem quad_sqr_lane35 {x03 x14 x25 : Wwl}
    (hx : Unsigned 47 (quadElem x03 x14 x25 3)) :
    (fd_r43x6_quad_sqr_fast.spec x03 x14 x25).2.2[7].toNat =
      scol (lqsqr x03 x14 x25 3) (hqsqr x03 x14 x25 3) 5 +
        152 * scol (lqsqr x03 x14 x25 3) (hqsqr x03 x14 x25 3) 11 := by
  quad_sqr_bounds35
  quad_sqr_lane

theorem quad_sqr_spec0 {x03 x14 x25 : Wwl}
    (hx : Unsigned 47 (quadElem x03 x14 x25 0)) :
    let z := fd_r43x6_quad_sqr_fast.spec x03 x14 x25
    val (quadElem z.1 z.2.1 z.2.2 0) = val (quadElem x03 x14 x25 0) ^ 2 ∧
      Unsigned 63 (quadElem z.1 z.2.1 z.2.2 0) := by
  intro z
  have e0 : z.1[0].toNat =
      scol (lqsqr x03 x14 x25 0) (hqsqr x03 x14 x25 0) 0 +
        152 * scol (lqsqr x03 x14 x25 0) (hqsqr x03 x14 x25 0) 6 :=
    quad_sqr_lane00 hx
  have e1 : z.2.1[0].toNat =
      scol (lqsqr x03 x14 x25 0) (hqsqr x03 x14 x25 0) 1 +
        152 * scol (lqsqr x03 x14 x25 0) (hqsqr x03 x14 x25 0) 7 :=
    quad_sqr_lane01 hx
  have e2 : z.2.2[0].toNat =
      scol (lqsqr x03 x14 x25 0) (hqsqr x03 x14 x25 0) 2 +
        152 * scol (lqsqr x03 x14 x25 0) (hqsqr x03 x14 x25 0) 8 :=
    quad_sqr_lane02 hx
  have e3 : z.1[4].toNat =
      scol (lqsqr x03 x14 x25 0) (hqsqr x03 x14 x25 0) 3 +
        152 * scol (lqsqr x03 x14 x25 0) (hqsqr x03 x14 x25 0) 9 :=
    quad_sqr_lane03 hx
  have e4 : z.2.1[4].toNat =
      scol (lqsqr x03 x14 x25 0) (hqsqr x03 x14 x25 0) 4 +
        152 * scol (lqsqr x03 x14 x25 0) (hqsqr x03 x14 x25 0) 10 :=
    quad_sqr_lane04 hx
  have e5 : z.2.2[4].toNat =
      scol (lqsqr x03 x14 x25 0) (hqsqr x03 x14 x25 0) 5 +
        152 * scol (lqsqr x03 x14 x25 0) (hqsqr x03 x14 x25 0) 11 :=
    quad_sqr_lane05 hx
  clear_value z
  rw [val_eq_nat (hx.mono (by norm_num)), nat_eq_limbs6]
  exact quad_val_of_scol_lanes (by norm_num) e0 e1 e2 e3 e4 e5 (lqsqr_split hx) (lqsqr_split' hx)
    (scol_lt (fun _ _ _ _ => lqsqr_lt) (hqsqr_lt hx))

theorem quad_sqr_spec1 {x03 x14 x25 : Wwl}
    (hx : Unsigned 47 (quadElem x03 x14 x25 1)) :
    let z := fd_r43x6_quad_sqr_fast.spec x03 x14 x25
    val (quadElem z.1 z.2.1 z.2.2 1) = val (quadElem x03 x14 x25 1) ^ 2 ∧
      Unsigned 63 (quadElem z.1 z.2.1 z.2.2 1) := by
  intro z
  have e0 : z.1[1].toNat =
      scol (lqsqr x03 x14 x25 1) (hqsqr x03 x14 x25 1) 0 +
        152 * scol (lqsqr x03 x14 x25 1) (hqsqr x03 x14 x25 1) 6 :=
    quad_sqr_lane10 hx
  have e1 : z.2.1[1].toNat =
      scol (lqsqr x03 x14 x25 1) (hqsqr x03 x14 x25 1) 1 +
        152 * scol (lqsqr x03 x14 x25 1) (hqsqr x03 x14 x25 1) 7 :=
    quad_sqr_lane11 hx
  have e2 : z.2.2[1].toNat =
      scol (lqsqr x03 x14 x25 1) (hqsqr x03 x14 x25 1) 2 +
        152 * scol (lqsqr x03 x14 x25 1) (hqsqr x03 x14 x25 1) 8 :=
    quad_sqr_lane12 hx
  have e3 : z.1[5].toNat =
      scol (lqsqr x03 x14 x25 1) (hqsqr x03 x14 x25 1) 3 +
        152 * scol (lqsqr x03 x14 x25 1) (hqsqr x03 x14 x25 1) 9 :=
    quad_sqr_lane13 hx
  have e4 : z.2.1[5].toNat =
      scol (lqsqr x03 x14 x25 1) (hqsqr x03 x14 x25 1) 4 +
        152 * scol (lqsqr x03 x14 x25 1) (hqsqr x03 x14 x25 1) 10 :=
    quad_sqr_lane14 hx
  have e5 : z.2.2[5].toNat =
      scol (lqsqr x03 x14 x25 1) (hqsqr x03 x14 x25 1) 5 +
        152 * scol (lqsqr x03 x14 x25 1) (hqsqr x03 x14 x25 1) 11 :=
    quad_sqr_lane15 hx
  clear_value z
  rw [val_eq_nat (hx.mono (by norm_num)), nat_eq_limbs6]
  exact quad_val_of_scol_lanes (by norm_num) e0 e1 e2 e3 e4 e5 (lqsqr_split hx) (lqsqr_split' hx)
    (scol_lt (fun _ _ _ _ => lqsqr_lt) (hqsqr_lt hx))

theorem quad_sqr_spec2 {x03 x14 x25 : Wwl}
    (hx : Unsigned 47 (quadElem x03 x14 x25 2)) :
    let z := fd_r43x6_quad_sqr_fast.spec x03 x14 x25
    val (quadElem z.1 z.2.1 z.2.2 2) = val (quadElem x03 x14 x25 2) ^ 2 ∧
      Unsigned 63 (quadElem z.1 z.2.1 z.2.2 2) := by
  intro z
  have e0 : z.1[2].toNat =
      scol (lqsqr x03 x14 x25 2) (hqsqr x03 x14 x25 2) 0 +
        152 * scol (lqsqr x03 x14 x25 2) (hqsqr x03 x14 x25 2) 6 :=
    quad_sqr_lane20 hx
  have e1 : z.2.1[2].toNat =
      scol (lqsqr x03 x14 x25 2) (hqsqr x03 x14 x25 2) 1 +
        152 * scol (lqsqr x03 x14 x25 2) (hqsqr x03 x14 x25 2) 7 :=
    quad_sqr_lane21 hx
  have e2 : z.2.2[2].toNat =
      scol (lqsqr x03 x14 x25 2) (hqsqr x03 x14 x25 2) 2 +
        152 * scol (lqsqr x03 x14 x25 2) (hqsqr x03 x14 x25 2) 8 :=
    quad_sqr_lane22 hx
  have e3 : z.1[6].toNat =
      scol (lqsqr x03 x14 x25 2) (hqsqr x03 x14 x25 2) 3 +
        152 * scol (lqsqr x03 x14 x25 2) (hqsqr x03 x14 x25 2) 9 :=
    quad_sqr_lane23 hx
  have e4 : z.2.1[6].toNat =
      scol (lqsqr x03 x14 x25 2) (hqsqr x03 x14 x25 2) 4 +
        152 * scol (lqsqr x03 x14 x25 2) (hqsqr x03 x14 x25 2) 10 :=
    quad_sqr_lane24 hx
  have e5 : z.2.2[6].toNat =
      scol (lqsqr x03 x14 x25 2) (hqsqr x03 x14 x25 2) 5 +
        152 * scol (lqsqr x03 x14 x25 2) (hqsqr x03 x14 x25 2) 11 :=
    quad_sqr_lane25 hx
  clear_value z
  rw [val_eq_nat (hx.mono (by norm_num)), nat_eq_limbs6]
  exact quad_val_of_scol_lanes (by norm_num) e0 e1 e2 e3 e4 e5 (lqsqr_split hx) (lqsqr_split' hx)
    (scol_lt (fun _ _ _ _ => lqsqr_lt) (hqsqr_lt hx))

theorem quad_sqr_spec3 {x03 x14 x25 : Wwl}
    (hx : Unsigned 47 (quadElem x03 x14 x25 3)) :
    let z := fd_r43x6_quad_sqr_fast.spec x03 x14 x25
    val (quadElem z.1 z.2.1 z.2.2 3) = val (quadElem x03 x14 x25 3) ^ 2 ∧
      Unsigned 63 (quadElem z.1 z.2.1 z.2.2 3) := by
  intro z
  have e0 : z.1[3].toNat =
      scol (lqsqr x03 x14 x25 3) (hqsqr x03 x14 x25 3) 0 +
        152 * scol (lqsqr x03 x14 x25 3) (hqsqr x03 x14 x25 3) 6 :=
    quad_sqr_lane30 hx
  have e1 : z.2.1[3].toNat =
      scol (lqsqr x03 x14 x25 3) (hqsqr x03 x14 x25 3) 1 +
        152 * scol (lqsqr x03 x14 x25 3) (hqsqr x03 x14 x25 3) 7 :=
    quad_sqr_lane31 hx
  have e2 : z.2.2[3].toNat =
      scol (lqsqr x03 x14 x25 3) (hqsqr x03 x14 x25 3) 2 +
        152 * scol (lqsqr x03 x14 x25 3) (hqsqr x03 x14 x25 3) 8 :=
    quad_sqr_lane32 hx
  have e3 : z.1[7].toNat =
      scol (lqsqr x03 x14 x25 3) (hqsqr x03 x14 x25 3) 3 +
        152 * scol (lqsqr x03 x14 x25 3) (hqsqr x03 x14 x25 3) 9 :=
    quad_sqr_lane33 hx
  have e4 : z.2.1[7].toNat =
      scol (lqsqr x03 x14 x25 3) (hqsqr x03 x14 x25 3) 4 +
        152 * scol (lqsqr x03 x14 x25 3) (hqsqr x03 x14 x25 3) 10 :=
    quad_sqr_lane34 hx
  have e5 : z.2.2[7].toNat =
      scol (lqsqr x03 x14 x25 3) (hqsqr x03 x14 x25 3) 5 +
        152 * scol (lqsqr x03 x14 x25 3) (hqsqr x03 x14 x25 3) 11 :=
    quad_sqr_lane35 hx
  clear_value z
  rw [val_eq_nat (hx.mono (by norm_num)), nat_eq_limbs6]
  exact quad_val_of_scol_lanes (by norm_num) e0 e1 e2 e3 e4 e5 (lqsqr_split hx) (lqsqr_split' hx)
    (scol_lt (fun _ _ _ _ => lqsqr_lt) (hqsqr_lt hx))


/-- `fd_r43x6_quad_sqr_fast` squares element `j < 4` of a QUAD of `u47` limbs into `u63`
limbs. -/
public theorem fd_r43x6_quad_sqr_fast_spec {x03 x14 x25 : Wwl} {j : ℕ} (hj : j < 4)
    (hx : Unsigned 47 (quadElem x03 x14 x25 j)) :
    let z := fd_r43x6_quad_sqr_fast.spec x03 x14 x25
    val (quadElem z.1 z.2.1 z.2.2 j) = val (quadElem x03 x14 x25 j) ^ 2 ∧
      Unsigned 63 (quadElem z.1 z.2.1 z.2.2 j) := by
  match j, hj with
  | 0, _ => exact quad_sqr_spec0 hx
  | 1, _ => exact quad_sqr_spec1 hx
  | 2, _ => exact quad_sqr_spec2 hx
  | 3, _ => exact quad_sqr_spec3 hx

end R43x6

end LeanMLIR.RIR.Firedancer.Avx512
