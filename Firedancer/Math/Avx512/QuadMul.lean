module

public import Firedancer.Math.Avx512.Mul
public import Firedancer.Avx512.fd_r43x6_quad_mul_fast
import Mathlib.Tactic.Ring

/-! `fd_r43x6_quad_mul_fast` in `ZMod p`: four independent products, each lane `j < 4` and
`j + 4` of the QUAD's vectors one element's limbs. -/

namespace MLIR.Firedancer.Avx512

open _root_.Ed25519 (p)

namespace R43x6

-- the lane `simp` sets are shared by all lanes, each using part of them
set_option linter.unusedSimpArgs false

@[expose] public section

/-- Element `j < 4` of a QUAD `q03 q14 q25`: limbs 0-2 in lane `j`, limbs 3-5 in lane `j + 4`,
lanes 6 and 7 zero (`FD_R43X6_QUAD_UNPACK`). -/
def quadElem (q03 q14 q25 : Wwl) (j : ℕ) : Wwl :=
  #v[q03[j]!, q14[j]!, q25[j]!, q03[j + 4]!, q14[j + 4]!, q25[j + 4]!, 0, 0]

end

/-- `madd52lo`'s product of limb `k` of element `j` of `x` and limb `i` of element `j` of `y`. -/
def lquad (x03 x14 x25 y03 y14 y25 : Wwl) (j k i : ℕ) : ℕ :=
  (madd52lo (quadElem x03 x14 x25 j)[k]! (quadElem y03 y14 y25 j)[i]!).toNat

/-- `madd52hi`'s product of limb `k` of element `j` of `x` and limb `i` of element `j` of `y`. -/
def hquad (x03 x14 x25 y03 y14 y25 : Wwl) (j k i : ℕ) : ℕ :=
  (madd52hi (quadElem x03 x14 x25 j)[k]! (quadElem y03 y14 y25 j)[i]!).toNat

/-- An element `j < 4` of a QUAD whose limbs are the columns `za + 152 zb` of `X * Y` has value
`X * Y` and `u63` limbs. -/
theorem quad_val_of_lanes {z03 z14 z25 : Wwl} {L H : ℕ → ℕ → ℕ} {X Y : ℕ → ℕ} {j : ℕ}
    (hj : j < 4) (e0 : (z03[j]'(by omega)).toNat = mcol L H 0 + 152 * mcol L H 6)
    (e1 : (z14[j]'(by omega)).toNat = mcol L H 1 + 152 * mcol L H 7)
    (e2 : (z25[j]'(by omega)).toNat = mcol L H 2 + 152 * mcol L H 8)
    (e3 : (z03[j + 4]'(by omega)).toNat = mcol L H 3 + 152 * mcol L H 9)
    (e4 : (z14[j + 4]'(by omega)).toNat = mcol L H 4 + 152 * mcol L H 10)
    (e5 : (z25[j + 4]'(by omega)).toNat = mcol L H 5 + 152 * mcol L H 11)
    (h : ∀ k i, k < 6 → i < 6 → X k * Y i = L k i + 2 ^ 52 * H k i)
    (hc : ∀ n, n < 6 → mcol L H n + 152 * mcol L H (n + 6) < 2 ^ 63) :
    val (quadElem z03 z14 z25 j) = (limbs6 X : ZMod p) * limbs6 Y ∧
      Unsigned 63 (quadElem z03 z14 z25 j) := by
  have e : ∀ k, k < 6 → (quadElem z03 z14 z25 j)[k]!.toNat = mcol L H k + 152 * mcol L H (k + 6) :=
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
  refine ⟨val_of_mcol ?_ z63 h, z63⟩
  rw [nat_eq_limbs6]
  simp only [limbs6, e 0 (by norm_num), e 1 (by norm_num), e 2 (by norm_num), e 3 (by norm_num),
    e 4 (by norm_num), e 5 (by norm_num)]

set_option hygiene false in
/-- The bounds `omega` needs on the `madd52` halves in lane 0 of element 0. -/
local macro "quad_mul_bounds00" : tactic =>
  `(tactic| (
    have := madd52lo_lt (x03[0]'(by decide)) (y03[0]'(by decide))
    have := madd52lo_lt (x14[0]'(by decide)) (y25[4]'(by decide))
    have := madd52lo_lt (x25[0]'(by decide)) (y14[4]'(by decide))
    have := madd52lo_lt (x03[4]'(by decide)) (y03[4]'(by decide))
    have := madd52lo_lt (x14[4]'(by decide)) (y25[0]'(by decide))
    have := madd52lo_lt (x25[4]'(by decide)) (y14[0]'(by decide))
    have := madd52hi_lt47 (a := (x03[0]'(by decide))) (b := (y25[4]'(by decide)))
      (by simpa [quadElem] using hx 0) (by simpa [quadElem] using hy 5)
    have := madd52hi_lt47 (a := (x14[0]'(by decide))) (b := (y14[4]'(by decide)))
      (by simpa [quadElem] using hx 1) (by simpa [quadElem] using hy 4)
    have := madd52hi_lt47 (a := (x25[0]'(by decide))) (b := (y03[4]'(by decide)))
      (by simpa [quadElem] using hx 2) (by simpa [quadElem] using hy 3)
    have := madd52hi_lt47 (a := (x03[4]'(by decide))) (b := (y25[0]'(by decide)))
      (by simpa [quadElem] using hx 3) (by simpa [quadElem] using hy 2)
    have := madd52hi_lt47 (a := (x14[4]'(by decide))) (b := (y14[0]'(by decide)))
      (by simpa [quadElem] using hx 4) (by simpa [quadElem] using hy 1)
    have := madd52hi_lt47 (a := (x25[4]'(by decide))) (b := (y03[0]'(by decide)))
      (by simpa [quadElem] using hx 5) (by simpa [quadElem] using hy 0)
    skip))

set_option hygiene false in
/-- The bounds `omega` needs on the `madd52` halves in lane 1 of element 0. -/
local macro "quad_mul_bounds01" : tactic =>
  `(tactic| (
    have := madd52lo_lt (x03[0]'(by decide)) (y14[0]'(by decide))
    have := madd52lo_lt (x14[0]'(by decide)) (y03[0]'(by decide))
    have := madd52lo_lt (x25[0]'(by decide)) (y25[4]'(by decide))
    have := madd52lo_lt (x03[4]'(by decide)) (y14[4]'(by decide))
    have := madd52lo_lt (x14[4]'(by decide)) (y03[4]'(by decide))
    have := madd52lo_lt (x25[4]'(by decide)) (y25[0]'(by decide))
    have := madd52hi_lt47 (a := (x03[0]'(by decide))) (b := (y03[0]'(by decide)))
      (by simpa [quadElem] using hx 0) (by simpa [quadElem] using hy 0)
    have := madd52hi_lt47 (a := (x14[0]'(by decide))) (b := (y25[4]'(by decide)))
      (by simpa [quadElem] using hx 1) (by simpa [quadElem] using hy 5)
    have := madd52hi_lt47 (a := (x25[0]'(by decide))) (b := (y14[4]'(by decide)))
      (by simpa [quadElem] using hx 2) (by simpa [quadElem] using hy 4)
    have := madd52hi_lt47 (a := (x03[4]'(by decide))) (b := (y03[4]'(by decide)))
      (by simpa [quadElem] using hx 3) (by simpa [quadElem] using hy 3)
    have := madd52hi_lt47 (a := (x14[4]'(by decide))) (b := (y25[0]'(by decide)))
      (by simpa [quadElem] using hx 4) (by simpa [quadElem] using hy 2)
    have := madd52hi_lt47 (a := (x25[4]'(by decide))) (b := (y14[0]'(by decide)))
      (by simpa [quadElem] using hx 5) (by simpa [quadElem] using hy 1)
    skip))

set_option hygiene false in
/-- The bounds `omega` needs on the `madd52` halves in lane 2 of element 0. -/
local macro "quad_mul_bounds02" : tactic =>
  `(tactic| (
    have := madd52lo_lt (x03[0]'(by decide)) (y25[0]'(by decide))
    have := madd52lo_lt (x14[0]'(by decide)) (y14[0]'(by decide))
    have := madd52lo_lt (x25[0]'(by decide)) (y03[0]'(by decide))
    have := madd52lo_lt (x03[4]'(by decide)) (y25[4]'(by decide))
    have := madd52lo_lt (x14[4]'(by decide)) (y14[4]'(by decide))
    have := madd52lo_lt (x25[4]'(by decide)) (y03[4]'(by decide))
    have := madd52hi_lt47 (a := (x03[0]'(by decide))) (b := (y14[0]'(by decide)))
      (by simpa [quadElem] using hx 0) (by simpa [quadElem] using hy 1)
    have := madd52hi_lt47 (a := (x14[0]'(by decide))) (b := (y03[0]'(by decide)))
      (by simpa [quadElem] using hx 1) (by simpa [quadElem] using hy 0)
    have := madd52hi_lt47 (a := (x25[0]'(by decide))) (b := (y25[4]'(by decide)))
      (by simpa [quadElem] using hx 2) (by simpa [quadElem] using hy 5)
    have := madd52hi_lt47 (a := (x03[4]'(by decide))) (b := (y14[4]'(by decide)))
      (by simpa [quadElem] using hx 3) (by simpa [quadElem] using hy 4)
    have := madd52hi_lt47 (a := (x14[4]'(by decide))) (b := (y03[4]'(by decide)))
      (by simpa [quadElem] using hx 4) (by simpa [quadElem] using hy 3)
    have := madd52hi_lt47 (a := (x25[4]'(by decide))) (b := (y25[0]'(by decide)))
      (by simpa [quadElem] using hx 5) (by simpa [quadElem] using hy 2)
    skip))

set_option hygiene false in
/-- The bounds `omega` needs on the `madd52` halves in lane 3 of element 0. -/
local macro "quad_mul_bounds03" : tactic =>
  `(tactic| (
    have := madd52lo_lt (x03[0]'(by decide)) (y03[4]'(by decide))
    have := madd52lo_lt (x14[0]'(by decide)) (y25[0]'(by decide))
    have := madd52lo_lt (x25[0]'(by decide)) (y14[0]'(by decide))
    have := madd52lo_lt (x03[4]'(by decide)) (y03[0]'(by decide))
    have := madd52lo_lt (x14[4]'(by decide)) (y25[4]'(by decide))
    have := madd52lo_lt (x25[4]'(by decide)) (y14[4]'(by decide))
    have := madd52hi_lt47 (a := (x03[0]'(by decide))) (b := (y25[0]'(by decide)))
      (by simpa [quadElem] using hx 0) (by simpa [quadElem] using hy 2)
    have := madd52hi_lt47 (a := (x14[0]'(by decide))) (b := (y14[0]'(by decide)))
      (by simpa [quadElem] using hx 1) (by simpa [quadElem] using hy 1)
    have := madd52hi_lt47 (a := (x25[0]'(by decide))) (b := (y03[0]'(by decide)))
      (by simpa [quadElem] using hx 2) (by simpa [quadElem] using hy 0)
    have := madd52hi_lt47 (a := (x03[4]'(by decide))) (b := (y25[4]'(by decide)))
      (by simpa [quadElem] using hx 3) (by simpa [quadElem] using hy 5)
    have := madd52hi_lt47 (a := (x14[4]'(by decide))) (b := (y14[4]'(by decide)))
      (by simpa [quadElem] using hx 4) (by simpa [quadElem] using hy 4)
    have := madd52hi_lt47 (a := (x25[4]'(by decide))) (b := (y03[4]'(by decide)))
      (by simpa [quadElem] using hx 5) (by simpa [quadElem] using hy 3)
    skip))

set_option hygiene false in
/-- The bounds `omega` needs on the `madd52` halves in lane 4 of element 0. -/
local macro "quad_mul_bounds04" : tactic =>
  `(tactic| (
    have := madd52lo_lt (x03[0]'(by decide)) (y14[4]'(by decide))
    have := madd52lo_lt (x14[0]'(by decide)) (y03[4]'(by decide))
    have := madd52lo_lt (x25[0]'(by decide)) (y25[0]'(by decide))
    have := madd52lo_lt (x03[4]'(by decide)) (y14[0]'(by decide))
    have := madd52lo_lt (x14[4]'(by decide)) (y03[0]'(by decide))
    have := madd52lo_lt (x25[4]'(by decide)) (y25[4]'(by decide))
    have := madd52hi_lt47 (a := (x03[0]'(by decide))) (b := (y03[4]'(by decide)))
      (by simpa [quadElem] using hx 0) (by simpa [quadElem] using hy 3)
    have := madd52hi_lt47 (a := (x14[0]'(by decide))) (b := (y25[0]'(by decide)))
      (by simpa [quadElem] using hx 1) (by simpa [quadElem] using hy 2)
    have := madd52hi_lt47 (a := (x25[0]'(by decide))) (b := (y14[0]'(by decide)))
      (by simpa [quadElem] using hx 2) (by simpa [quadElem] using hy 1)
    have := madd52hi_lt47 (a := (x03[4]'(by decide))) (b := (y03[0]'(by decide)))
      (by simpa [quadElem] using hx 3) (by simpa [quadElem] using hy 0)
    have := madd52hi_lt47 (a := (x14[4]'(by decide))) (b := (y25[4]'(by decide)))
      (by simpa [quadElem] using hx 4) (by simpa [quadElem] using hy 5)
    have := madd52hi_lt47 (a := (x25[4]'(by decide))) (b := (y14[4]'(by decide)))
      (by simpa [quadElem] using hx 5) (by simpa [quadElem] using hy 4)
    skip))

set_option hygiene false in
/-- The bounds `omega` needs on the `madd52` halves in lane 5 of element 0. -/
local macro "quad_mul_bounds05" : tactic =>
  `(tactic| (
    have := madd52lo_lt (x03[0]'(by decide)) (y25[4]'(by decide))
    have := madd52lo_lt (x14[0]'(by decide)) (y14[4]'(by decide))
    have := madd52lo_lt (x25[0]'(by decide)) (y03[4]'(by decide))
    have := madd52lo_lt (x03[4]'(by decide)) (y25[0]'(by decide))
    have := madd52lo_lt (x14[4]'(by decide)) (y14[0]'(by decide))
    have := madd52lo_lt (x25[4]'(by decide)) (y03[0]'(by decide))
    have := madd52hi_lt47 (a := (x03[0]'(by decide))) (b := (y14[4]'(by decide)))
      (by simpa [quadElem] using hx 0) (by simpa [quadElem] using hy 4)
    have := madd52hi_lt47 (a := (x14[0]'(by decide))) (b := (y03[4]'(by decide)))
      (by simpa [quadElem] using hx 1) (by simpa [quadElem] using hy 3)
    have := madd52hi_lt47 (a := (x25[0]'(by decide))) (b := (y25[0]'(by decide)))
      (by simpa [quadElem] using hx 2) (by simpa [quadElem] using hy 2)
    have := madd52hi_lt47 (a := (x03[4]'(by decide))) (b := (y14[0]'(by decide)))
      (by simpa [quadElem] using hx 3) (by simpa [quadElem] using hy 1)
    have := madd52hi_lt47 (a := (x14[4]'(by decide))) (b := (y03[0]'(by decide)))
      (by simpa [quadElem] using hx 4) (by simpa [quadElem] using hy 0)
    have := madd52hi_lt47 (a := (x25[4]'(by decide))) (b := (y25[4]'(by decide)))
      (by simpa [quadElem] using hx 5) (by simpa [quadElem] using hy 5)
    skip))

set_option hygiene false in
/-- The bounds `omega` needs on the `madd52` halves in lane 0 of element 1. -/
local macro "quad_mul_bounds10" : tactic =>
  `(tactic| (
    have := madd52lo_lt (x03[1]'(by decide)) (y03[1]'(by decide))
    have := madd52lo_lt (x14[1]'(by decide)) (y25[5]'(by decide))
    have := madd52lo_lt (x25[1]'(by decide)) (y14[5]'(by decide))
    have := madd52lo_lt (x03[5]'(by decide)) (y03[5]'(by decide))
    have := madd52lo_lt (x14[5]'(by decide)) (y25[1]'(by decide))
    have := madd52lo_lt (x25[5]'(by decide)) (y14[1]'(by decide))
    have := madd52hi_lt47 (a := (x03[1]'(by decide))) (b := (y25[5]'(by decide)))
      (by simpa [quadElem] using hx 0) (by simpa [quadElem] using hy 5)
    have := madd52hi_lt47 (a := (x14[1]'(by decide))) (b := (y14[5]'(by decide)))
      (by simpa [quadElem] using hx 1) (by simpa [quadElem] using hy 4)
    have := madd52hi_lt47 (a := (x25[1]'(by decide))) (b := (y03[5]'(by decide)))
      (by simpa [quadElem] using hx 2) (by simpa [quadElem] using hy 3)
    have := madd52hi_lt47 (a := (x03[5]'(by decide))) (b := (y25[1]'(by decide)))
      (by simpa [quadElem] using hx 3) (by simpa [quadElem] using hy 2)
    have := madd52hi_lt47 (a := (x14[5]'(by decide))) (b := (y14[1]'(by decide)))
      (by simpa [quadElem] using hx 4) (by simpa [quadElem] using hy 1)
    have := madd52hi_lt47 (a := (x25[5]'(by decide))) (b := (y03[1]'(by decide)))
      (by simpa [quadElem] using hx 5) (by simpa [quadElem] using hy 0)
    skip))

set_option hygiene false in
/-- The bounds `omega` needs on the `madd52` halves in lane 1 of element 1. -/
local macro "quad_mul_bounds11" : tactic =>
  `(tactic| (
    have := madd52lo_lt (x03[1]'(by decide)) (y14[1]'(by decide))
    have := madd52lo_lt (x14[1]'(by decide)) (y03[1]'(by decide))
    have := madd52lo_lt (x25[1]'(by decide)) (y25[5]'(by decide))
    have := madd52lo_lt (x03[5]'(by decide)) (y14[5]'(by decide))
    have := madd52lo_lt (x14[5]'(by decide)) (y03[5]'(by decide))
    have := madd52lo_lt (x25[5]'(by decide)) (y25[1]'(by decide))
    have := madd52hi_lt47 (a := (x03[1]'(by decide))) (b := (y03[1]'(by decide)))
      (by simpa [quadElem] using hx 0) (by simpa [quadElem] using hy 0)
    have := madd52hi_lt47 (a := (x14[1]'(by decide))) (b := (y25[5]'(by decide)))
      (by simpa [quadElem] using hx 1) (by simpa [quadElem] using hy 5)
    have := madd52hi_lt47 (a := (x25[1]'(by decide))) (b := (y14[5]'(by decide)))
      (by simpa [quadElem] using hx 2) (by simpa [quadElem] using hy 4)
    have := madd52hi_lt47 (a := (x03[5]'(by decide))) (b := (y03[5]'(by decide)))
      (by simpa [quadElem] using hx 3) (by simpa [quadElem] using hy 3)
    have := madd52hi_lt47 (a := (x14[5]'(by decide))) (b := (y25[1]'(by decide)))
      (by simpa [quadElem] using hx 4) (by simpa [quadElem] using hy 2)
    have := madd52hi_lt47 (a := (x25[5]'(by decide))) (b := (y14[1]'(by decide)))
      (by simpa [quadElem] using hx 5) (by simpa [quadElem] using hy 1)
    skip))

set_option hygiene false in
/-- The bounds `omega` needs on the `madd52` halves in lane 2 of element 1. -/
local macro "quad_mul_bounds12" : tactic =>
  `(tactic| (
    have := madd52lo_lt (x03[1]'(by decide)) (y25[1]'(by decide))
    have := madd52lo_lt (x14[1]'(by decide)) (y14[1]'(by decide))
    have := madd52lo_lt (x25[1]'(by decide)) (y03[1]'(by decide))
    have := madd52lo_lt (x03[5]'(by decide)) (y25[5]'(by decide))
    have := madd52lo_lt (x14[5]'(by decide)) (y14[5]'(by decide))
    have := madd52lo_lt (x25[5]'(by decide)) (y03[5]'(by decide))
    have := madd52hi_lt47 (a := (x03[1]'(by decide))) (b := (y14[1]'(by decide)))
      (by simpa [quadElem] using hx 0) (by simpa [quadElem] using hy 1)
    have := madd52hi_lt47 (a := (x14[1]'(by decide))) (b := (y03[1]'(by decide)))
      (by simpa [quadElem] using hx 1) (by simpa [quadElem] using hy 0)
    have := madd52hi_lt47 (a := (x25[1]'(by decide))) (b := (y25[5]'(by decide)))
      (by simpa [quadElem] using hx 2) (by simpa [quadElem] using hy 5)
    have := madd52hi_lt47 (a := (x03[5]'(by decide))) (b := (y14[5]'(by decide)))
      (by simpa [quadElem] using hx 3) (by simpa [quadElem] using hy 4)
    have := madd52hi_lt47 (a := (x14[5]'(by decide))) (b := (y03[5]'(by decide)))
      (by simpa [quadElem] using hx 4) (by simpa [quadElem] using hy 3)
    have := madd52hi_lt47 (a := (x25[5]'(by decide))) (b := (y25[1]'(by decide)))
      (by simpa [quadElem] using hx 5) (by simpa [quadElem] using hy 2)
    skip))

set_option hygiene false in
/-- The bounds `omega` needs on the `madd52` halves in lane 3 of element 1. -/
local macro "quad_mul_bounds13" : tactic =>
  `(tactic| (
    have := madd52lo_lt (x03[1]'(by decide)) (y03[5]'(by decide))
    have := madd52lo_lt (x14[1]'(by decide)) (y25[1]'(by decide))
    have := madd52lo_lt (x25[1]'(by decide)) (y14[1]'(by decide))
    have := madd52lo_lt (x03[5]'(by decide)) (y03[1]'(by decide))
    have := madd52lo_lt (x14[5]'(by decide)) (y25[5]'(by decide))
    have := madd52lo_lt (x25[5]'(by decide)) (y14[5]'(by decide))
    have := madd52hi_lt47 (a := (x03[1]'(by decide))) (b := (y25[1]'(by decide)))
      (by simpa [quadElem] using hx 0) (by simpa [quadElem] using hy 2)
    have := madd52hi_lt47 (a := (x14[1]'(by decide))) (b := (y14[1]'(by decide)))
      (by simpa [quadElem] using hx 1) (by simpa [quadElem] using hy 1)
    have := madd52hi_lt47 (a := (x25[1]'(by decide))) (b := (y03[1]'(by decide)))
      (by simpa [quadElem] using hx 2) (by simpa [quadElem] using hy 0)
    have := madd52hi_lt47 (a := (x03[5]'(by decide))) (b := (y25[5]'(by decide)))
      (by simpa [quadElem] using hx 3) (by simpa [quadElem] using hy 5)
    have := madd52hi_lt47 (a := (x14[5]'(by decide))) (b := (y14[5]'(by decide)))
      (by simpa [quadElem] using hx 4) (by simpa [quadElem] using hy 4)
    have := madd52hi_lt47 (a := (x25[5]'(by decide))) (b := (y03[5]'(by decide)))
      (by simpa [quadElem] using hx 5) (by simpa [quadElem] using hy 3)
    skip))

set_option hygiene false in
/-- The bounds `omega` needs on the `madd52` halves in lane 4 of element 1. -/
local macro "quad_mul_bounds14" : tactic =>
  `(tactic| (
    have := madd52lo_lt (x03[1]'(by decide)) (y14[5]'(by decide))
    have := madd52lo_lt (x14[1]'(by decide)) (y03[5]'(by decide))
    have := madd52lo_lt (x25[1]'(by decide)) (y25[1]'(by decide))
    have := madd52lo_lt (x03[5]'(by decide)) (y14[1]'(by decide))
    have := madd52lo_lt (x14[5]'(by decide)) (y03[1]'(by decide))
    have := madd52lo_lt (x25[5]'(by decide)) (y25[5]'(by decide))
    have := madd52hi_lt47 (a := (x03[1]'(by decide))) (b := (y03[5]'(by decide)))
      (by simpa [quadElem] using hx 0) (by simpa [quadElem] using hy 3)
    have := madd52hi_lt47 (a := (x14[1]'(by decide))) (b := (y25[1]'(by decide)))
      (by simpa [quadElem] using hx 1) (by simpa [quadElem] using hy 2)
    have := madd52hi_lt47 (a := (x25[1]'(by decide))) (b := (y14[1]'(by decide)))
      (by simpa [quadElem] using hx 2) (by simpa [quadElem] using hy 1)
    have := madd52hi_lt47 (a := (x03[5]'(by decide))) (b := (y03[1]'(by decide)))
      (by simpa [quadElem] using hx 3) (by simpa [quadElem] using hy 0)
    have := madd52hi_lt47 (a := (x14[5]'(by decide))) (b := (y25[5]'(by decide)))
      (by simpa [quadElem] using hx 4) (by simpa [quadElem] using hy 5)
    have := madd52hi_lt47 (a := (x25[5]'(by decide))) (b := (y14[5]'(by decide)))
      (by simpa [quadElem] using hx 5) (by simpa [quadElem] using hy 4)
    skip))

set_option hygiene false in
/-- The bounds `omega` needs on the `madd52` halves in lane 5 of element 1. -/
local macro "quad_mul_bounds15" : tactic =>
  `(tactic| (
    have := madd52lo_lt (x03[1]'(by decide)) (y25[5]'(by decide))
    have := madd52lo_lt (x14[1]'(by decide)) (y14[5]'(by decide))
    have := madd52lo_lt (x25[1]'(by decide)) (y03[5]'(by decide))
    have := madd52lo_lt (x03[5]'(by decide)) (y25[1]'(by decide))
    have := madd52lo_lt (x14[5]'(by decide)) (y14[1]'(by decide))
    have := madd52lo_lt (x25[5]'(by decide)) (y03[1]'(by decide))
    have := madd52hi_lt47 (a := (x03[1]'(by decide))) (b := (y14[5]'(by decide)))
      (by simpa [quadElem] using hx 0) (by simpa [quadElem] using hy 4)
    have := madd52hi_lt47 (a := (x14[1]'(by decide))) (b := (y03[5]'(by decide)))
      (by simpa [quadElem] using hx 1) (by simpa [quadElem] using hy 3)
    have := madd52hi_lt47 (a := (x25[1]'(by decide))) (b := (y25[1]'(by decide)))
      (by simpa [quadElem] using hx 2) (by simpa [quadElem] using hy 2)
    have := madd52hi_lt47 (a := (x03[5]'(by decide))) (b := (y14[1]'(by decide)))
      (by simpa [quadElem] using hx 3) (by simpa [quadElem] using hy 1)
    have := madd52hi_lt47 (a := (x14[5]'(by decide))) (b := (y03[1]'(by decide)))
      (by simpa [quadElem] using hx 4) (by simpa [quadElem] using hy 0)
    have := madd52hi_lt47 (a := (x25[5]'(by decide))) (b := (y25[5]'(by decide)))
      (by simpa [quadElem] using hx 5) (by simpa [quadElem] using hy 5)
    skip))

set_option hygiene false in
/-- The bounds `omega` needs on the `madd52` halves in lane 0 of element 2. -/
local macro "quad_mul_bounds20" : tactic =>
  `(tactic| (
    have := madd52lo_lt (x03[2]'(by decide)) (y03[2]'(by decide))
    have := madd52lo_lt (x14[2]'(by decide)) (y25[6]'(by decide))
    have := madd52lo_lt (x25[2]'(by decide)) (y14[6]'(by decide))
    have := madd52lo_lt (x03[6]'(by decide)) (y03[6]'(by decide))
    have := madd52lo_lt (x14[6]'(by decide)) (y25[2]'(by decide))
    have := madd52lo_lt (x25[6]'(by decide)) (y14[2]'(by decide))
    have := madd52hi_lt47 (a := (x03[2]'(by decide))) (b := (y25[6]'(by decide)))
      (by simpa [quadElem] using hx 0) (by simpa [quadElem] using hy 5)
    have := madd52hi_lt47 (a := (x14[2]'(by decide))) (b := (y14[6]'(by decide)))
      (by simpa [quadElem] using hx 1) (by simpa [quadElem] using hy 4)
    have := madd52hi_lt47 (a := (x25[2]'(by decide))) (b := (y03[6]'(by decide)))
      (by simpa [quadElem] using hx 2) (by simpa [quadElem] using hy 3)
    have := madd52hi_lt47 (a := (x03[6]'(by decide))) (b := (y25[2]'(by decide)))
      (by simpa [quadElem] using hx 3) (by simpa [quadElem] using hy 2)
    have := madd52hi_lt47 (a := (x14[6]'(by decide))) (b := (y14[2]'(by decide)))
      (by simpa [quadElem] using hx 4) (by simpa [quadElem] using hy 1)
    have := madd52hi_lt47 (a := (x25[6]'(by decide))) (b := (y03[2]'(by decide)))
      (by simpa [quadElem] using hx 5) (by simpa [quadElem] using hy 0)
    skip))

set_option hygiene false in
/-- The bounds `omega` needs on the `madd52` halves in lane 1 of element 2. -/
local macro "quad_mul_bounds21" : tactic =>
  `(tactic| (
    have := madd52lo_lt (x03[2]'(by decide)) (y14[2]'(by decide))
    have := madd52lo_lt (x14[2]'(by decide)) (y03[2]'(by decide))
    have := madd52lo_lt (x25[2]'(by decide)) (y25[6]'(by decide))
    have := madd52lo_lt (x03[6]'(by decide)) (y14[6]'(by decide))
    have := madd52lo_lt (x14[6]'(by decide)) (y03[6]'(by decide))
    have := madd52lo_lt (x25[6]'(by decide)) (y25[2]'(by decide))
    have := madd52hi_lt47 (a := (x03[2]'(by decide))) (b := (y03[2]'(by decide)))
      (by simpa [quadElem] using hx 0) (by simpa [quadElem] using hy 0)
    have := madd52hi_lt47 (a := (x14[2]'(by decide))) (b := (y25[6]'(by decide)))
      (by simpa [quadElem] using hx 1) (by simpa [quadElem] using hy 5)
    have := madd52hi_lt47 (a := (x25[2]'(by decide))) (b := (y14[6]'(by decide)))
      (by simpa [quadElem] using hx 2) (by simpa [quadElem] using hy 4)
    have := madd52hi_lt47 (a := (x03[6]'(by decide))) (b := (y03[6]'(by decide)))
      (by simpa [quadElem] using hx 3) (by simpa [quadElem] using hy 3)
    have := madd52hi_lt47 (a := (x14[6]'(by decide))) (b := (y25[2]'(by decide)))
      (by simpa [quadElem] using hx 4) (by simpa [quadElem] using hy 2)
    have := madd52hi_lt47 (a := (x25[6]'(by decide))) (b := (y14[2]'(by decide)))
      (by simpa [quadElem] using hx 5) (by simpa [quadElem] using hy 1)
    skip))

set_option hygiene false in
/-- The bounds `omega` needs on the `madd52` halves in lane 2 of element 2. -/
local macro "quad_mul_bounds22" : tactic =>
  `(tactic| (
    have := madd52lo_lt (x03[2]'(by decide)) (y25[2]'(by decide))
    have := madd52lo_lt (x14[2]'(by decide)) (y14[2]'(by decide))
    have := madd52lo_lt (x25[2]'(by decide)) (y03[2]'(by decide))
    have := madd52lo_lt (x03[6]'(by decide)) (y25[6]'(by decide))
    have := madd52lo_lt (x14[6]'(by decide)) (y14[6]'(by decide))
    have := madd52lo_lt (x25[6]'(by decide)) (y03[6]'(by decide))
    have := madd52hi_lt47 (a := (x03[2]'(by decide))) (b := (y14[2]'(by decide)))
      (by simpa [quadElem] using hx 0) (by simpa [quadElem] using hy 1)
    have := madd52hi_lt47 (a := (x14[2]'(by decide))) (b := (y03[2]'(by decide)))
      (by simpa [quadElem] using hx 1) (by simpa [quadElem] using hy 0)
    have := madd52hi_lt47 (a := (x25[2]'(by decide))) (b := (y25[6]'(by decide)))
      (by simpa [quadElem] using hx 2) (by simpa [quadElem] using hy 5)
    have := madd52hi_lt47 (a := (x03[6]'(by decide))) (b := (y14[6]'(by decide)))
      (by simpa [quadElem] using hx 3) (by simpa [quadElem] using hy 4)
    have := madd52hi_lt47 (a := (x14[6]'(by decide))) (b := (y03[6]'(by decide)))
      (by simpa [quadElem] using hx 4) (by simpa [quadElem] using hy 3)
    have := madd52hi_lt47 (a := (x25[6]'(by decide))) (b := (y25[2]'(by decide)))
      (by simpa [quadElem] using hx 5) (by simpa [quadElem] using hy 2)
    skip))

set_option hygiene false in
/-- The bounds `omega` needs on the `madd52` halves in lane 3 of element 2. -/
local macro "quad_mul_bounds23" : tactic =>
  `(tactic| (
    have := madd52lo_lt (x03[2]'(by decide)) (y03[6]'(by decide))
    have := madd52lo_lt (x14[2]'(by decide)) (y25[2]'(by decide))
    have := madd52lo_lt (x25[2]'(by decide)) (y14[2]'(by decide))
    have := madd52lo_lt (x03[6]'(by decide)) (y03[2]'(by decide))
    have := madd52lo_lt (x14[6]'(by decide)) (y25[6]'(by decide))
    have := madd52lo_lt (x25[6]'(by decide)) (y14[6]'(by decide))
    have := madd52hi_lt47 (a := (x03[2]'(by decide))) (b := (y25[2]'(by decide)))
      (by simpa [quadElem] using hx 0) (by simpa [quadElem] using hy 2)
    have := madd52hi_lt47 (a := (x14[2]'(by decide))) (b := (y14[2]'(by decide)))
      (by simpa [quadElem] using hx 1) (by simpa [quadElem] using hy 1)
    have := madd52hi_lt47 (a := (x25[2]'(by decide))) (b := (y03[2]'(by decide)))
      (by simpa [quadElem] using hx 2) (by simpa [quadElem] using hy 0)
    have := madd52hi_lt47 (a := (x03[6]'(by decide))) (b := (y25[6]'(by decide)))
      (by simpa [quadElem] using hx 3) (by simpa [quadElem] using hy 5)
    have := madd52hi_lt47 (a := (x14[6]'(by decide))) (b := (y14[6]'(by decide)))
      (by simpa [quadElem] using hx 4) (by simpa [quadElem] using hy 4)
    have := madd52hi_lt47 (a := (x25[6]'(by decide))) (b := (y03[6]'(by decide)))
      (by simpa [quadElem] using hx 5) (by simpa [quadElem] using hy 3)
    skip))

set_option hygiene false in
/-- The bounds `omega` needs on the `madd52` halves in lane 4 of element 2. -/
local macro "quad_mul_bounds24" : tactic =>
  `(tactic| (
    have := madd52lo_lt (x03[2]'(by decide)) (y14[6]'(by decide))
    have := madd52lo_lt (x14[2]'(by decide)) (y03[6]'(by decide))
    have := madd52lo_lt (x25[2]'(by decide)) (y25[2]'(by decide))
    have := madd52lo_lt (x03[6]'(by decide)) (y14[2]'(by decide))
    have := madd52lo_lt (x14[6]'(by decide)) (y03[2]'(by decide))
    have := madd52lo_lt (x25[6]'(by decide)) (y25[6]'(by decide))
    have := madd52hi_lt47 (a := (x03[2]'(by decide))) (b := (y03[6]'(by decide)))
      (by simpa [quadElem] using hx 0) (by simpa [quadElem] using hy 3)
    have := madd52hi_lt47 (a := (x14[2]'(by decide))) (b := (y25[2]'(by decide)))
      (by simpa [quadElem] using hx 1) (by simpa [quadElem] using hy 2)
    have := madd52hi_lt47 (a := (x25[2]'(by decide))) (b := (y14[2]'(by decide)))
      (by simpa [quadElem] using hx 2) (by simpa [quadElem] using hy 1)
    have := madd52hi_lt47 (a := (x03[6]'(by decide))) (b := (y03[2]'(by decide)))
      (by simpa [quadElem] using hx 3) (by simpa [quadElem] using hy 0)
    have := madd52hi_lt47 (a := (x14[6]'(by decide))) (b := (y25[6]'(by decide)))
      (by simpa [quadElem] using hx 4) (by simpa [quadElem] using hy 5)
    have := madd52hi_lt47 (a := (x25[6]'(by decide))) (b := (y14[6]'(by decide)))
      (by simpa [quadElem] using hx 5) (by simpa [quadElem] using hy 4)
    skip))

set_option hygiene false in
/-- The bounds `omega` needs on the `madd52` halves in lane 5 of element 2. -/
local macro "quad_mul_bounds25" : tactic =>
  `(tactic| (
    have := madd52lo_lt (x03[2]'(by decide)) (y25[6]'(by decide))
    have := madd52lo_lt (x14[2]'(by decide)) (y14[6]'(by decide))
    have := madd52lo_lt (x25[2]'(by decide)) (y03[6]'(by decide))
    have := madd52lo_lt (x03[6]'(by decide)) (y25[2]'(by decide))
    have := madd52lo_lt (x14[6]'(by decide)) (y14[2]'(by decide))
    have := madd52lo_lt (x25[6]'(by decide)) (y03[2]'(by decide))
    have := madd52hi_lt47 (a := (x03[2]'(by decide))) (b := (y14[6]'(by decide)))
      (by simpa [quadElem] using hx 0) (by simpa [quadElem] using hy 4)
    have := madd52hi_lt47 (a := (x14[2]'(by decide))) (b := (y03[6]'(by decide)))
      (by simpa [quadElem] using hx 1) (by simpa [quadElem] using hy 3)
    have := madd52hi_lt47 (a := (x25[2]'(by decide))) (b := (y25[2]'(by decide)))
      (by simpa [quadElem] using hx 2) (by simpa [quadElem] using hy 2)
    have := madd52hi_lt47 (a := (x03[6]'(by decide))) (b := (y14[2]'(by decide)))
      (by simpa [quadElem] using hx 3) (by simpa [quadElem] using hy 1)
    have := madd52hi_lt47 (a := (x14[6]'(by decide))) (b := (y03[2]'(by decide)))
      (by simpa [quadElem] using hx 4) (by simpa [quadElem] using hy 0)
    have := madd52hi_lt47 (a := (x25[6]'(by decide))) (b := (y25[6]'(by decide)))
      (by simpa [quadElem] using hx 5) (by simpa [quadElem] using hy 5)
    skip))

set_option hygiene false in
/-- The bounds `omega` needs on the `madd52` halves in lane 0 of element 3. -/
local macro "quad_mul_bounds30" : tactic =>
  `(tactic| (
    have := madd52lo_lt (x03[3]'(by decide)) (y03[3]'(by decide))
    have := madd52lo_lt (x14[3]'(by decide)) (y25[7]'(by decide))
    have := madd52lo_lt (x25[3]'(by decide)) (y14[7]'(by decide))
    have := madd52lo_lt (x03[7]'(by decide)) (y03[7]'(by decide))
    have := madd52lo_lt (x14[7]'(by decide)) (y25[3]'(by decide))
    have := madd52lo_lt (x25[7]'(by decide)) (y14[3]'(by decide))
    have := madd52hi_lt47 (a := (x03[3]'(by decide))) (b := (y25[7]'(by decide)))
      (by simpa [quadElem] using hx 0) (by simpa [quadElem] using hy 5)
    have := madd52hi_lt47 (a := (x14[3]'(by decide))) (b := (y14[7]'(by decide)))
      (by simpa [quadElem] using hx 1) (by simpa [quadElem] using hy 4)
    have := madd52hi_lt47 (a := (x25[3]'(by decide))) (b := (y03[7]'(by decide)))
      (by simpa [quadElem] using hx 2) (by simpa [quadElem] using hy 3)
    have := madd52hi_lt47 (a := (x03[7]'(by decide))) (b := (y25[3]'(by decide)))
      (by simpa [quadElem] using hx 3) (by simpa [quadElem] using hy 2)
    have := madd52hi_lt47 (a := (x14[7]'(by decide))) (b := (y14[3]'(by decide)))
      (by simpa [quadElem] using hx 4) (by simpa [quadElem] using hy 1)
    have := madd52hi_lt47 (a := (x25[7]'(by decide))) (b := (y03[3]'(by decide)))
      (by simpa [quadElem] using hx 5) (by simpa [quadElem] using hy 0)
    skip))

set_option hygiene false in
/-- The bounds `omega` needs on the `madd52` halves in lane 1 of element 3. -/
local macro "quad_mul_bounds31" : tactic =>
  `(tactic| (
    have := madd52lo_lt (x03[3]'(by decide)) (y14[3]'(by decide))
    have := madd52lo_lt (x14[3]'(by decide)) (y03[3]'(by decide))
    have := madd52lo_lt (x25[3]'(by decide)) (y25[7]'(by decide))
    have := madd52lo_lt (x03[7]'(by decide)) (y14[7]'(by decide))
    have := madd52lo_lt (x14[7]'(by decide)) (y03[7]'(by decide))
    have := madd52lo_lt (x25[7]'(by decide)) (y25[3]'(by decide))
    have := madd52hi_lt47 (a := (x03[3]'(by decide))) (b := (y03[3]'(by decide)))
      (by simpa [quadElem] using hx 0) (by simpa [quadElem] using hy 0)
    have := madd52hi_lt47 (a := (x14[3]'(by decide))) (b := (y25[7]'(by decide)))
      (by simpa [quadElem] using hx 1) (by simpa [quadElem] using hy 5)
    have := madd52hi_lt47 (a := (x25[3]'(by decide))) (b := (y14[7]'(by decide)))
      (by simpa [quadElem] using hx 2) (by simpa [quadElem] using hy 4)
    have := madd52hi_lt47 (a := (x03[7]'(by decide))) (b := (y03[7]'(by decide)))
      (by simpa [quadElem] using hx 3) (by simpa [quadElem] using hy 3)
    have := madd52hi_lt47 (a := (x14[7]'(by decide))) (b := (y25[3]'(by decide)))
      (by simpa [quadElem] using hx 4) (by simpa [quadElem] using hy 2)
    have := madd52hi_lt47 (a := (x25[7]'(by decide))) (b := (y14[3]'(by decide)))
      (by simpa [quadElem] using hx 5) (by simpa [quadElem] using hy 1)
    skip))

set_option hygiene false in
/-- The bounds `omega` needs on the `madd52` halves in lane 2 of element 3. -/
local macro "quad_mul_bounds32" : tactic =>
  `(tactic| (
    have := madd52lo_lt (x03[3]'(by decide)) (y25[3]'(by decide))
    have := madd52lo_lt (x14[3]'(by decide)) (y14[3]'(by decide))
    have := madd52lo_lt (x25[3]'(by decide)) (y03[3]'(by decide))
    have := madd52lo_lt (x03[7]'(by decide)) (y25[7]'(by decide))
    have := madd52lo_lt (x14[7]'(by decide)) (y14[7]'(by decide))
    have := madd52lo_lt (x25[7]'(by decide)) (y03[7]'(by decide))
    have := madd52hi_lt47 (a := (x03[3]'(by decide))) (b := (y14[3]'(by decide)))
      (by simpa [quadElem] using hx 0) (by simpa [quadElem] using hy 1)
    have := madd52hi_lt47 (a := (x14[3]'(by decide))) (b := (y03[3]'(by decide)))
      (by simpa [quadElem] using hx 1) (by simpa [quadElem] using hy 0)
    have := madd52hi_lt47 (a := (x25[3]'(by decide))) (b := (y25[7]'(by decide)))
      (by simpa [quadElem] using hx 2) (by simpa [quadElem] using hy 5)
    have := madd52hi_lt47 (a := (x03[7]'(by decide))) (b := (y14[7]'(by decide)))
      (by simpa [quadElem] using hx 3) (by simpa [quadElem] using hy 4)
    have := madd52hi_lt47 (a := (x14[7]'(by decide))) (b := (y03[7]'(by decide)))
      (by simpa [quadElem] using hx 4) (by simpa [quadElem] using hy 3)
    have := madd52hi_lt47 (a := (x25[7]'(by decide))) (b := (y25[3]'(by decide)))
      (by simpa [quadElem] using hx 5) (by simpa [quadElem] using hy 2)
    skip))

set_option hygiene false in
/-- The bounds `omega` needs on the `madd52` halves in lane 3 of element 3. -/
local macro "quad_mul_bounds33" : tactic =>
  `(tactic| (
    have := madd52lo_lt (x03[3]'(by decide)) (y03[7]'(by decide))
    have := madd52lo_lt (x14[3]'(by decide)) (y25[3]'(by decide))
    have := madd52lo_lt (x25[3]'(by decide)) (y14[3]'(by decide))
    have := madd52lo_lt (x03[7]'(by decide)) (y03[3]'(by decide))
    have := madd52lo_lt (x14[7]'(by decide)) (y25[7]'(by decide))
    have := madd52lo_lt (x25[7]'(by decide)) (y14[7]'(by decide))
    have := madd52hi_lt47 (a := (x03[3]'(by decide))) (b := (y25[3]'(by decide)))
      (by simpa [quadElem] using hx 0) (by simpa [quadElem] using hy 2)
    have := madd52hi_lt47 (a := (x14[3]'(by decide))) (b := (y14[3]'(by decide)))
      (by simpa [quadElem] using hx 1) (by simpa [quadElem] using hy 1)
    have := madd52hi_lt47 (a := (x25[3]'(by decide))) (b := (y03[3]'(by decide)))
      (by simpa [quadElem] using hx 2) (by simpa [quadElem] using hy 0)
    have := madd52hi_lt47 (a := (x03[7]'(by decide))) (b := (y25[7]'(by decide)))
      (by simpa [quadElem] using hx 3) (by simpa [quadElem] using hy 5)
    have := madd52hi_lt47 (a := (x14[7]'(by decide))) (b := (y14[7]'(by decide)))
      (by simpa [quadElem] using hx 4) (by simpa [quadElem] using hy 4)
    have := madd52hi_lt47 (a := (x25[7]'(by decide))) (b := (y03[7]'(by decide)))
      (by simpa [quadElem] using hx 5) (by simpa [quadElem] using hy 3)
    skip))

set_option hygiene false in
/-- The bounds `omega` needs on the `madd52` halves in lane 4 of element 3. -/
local macro "quad_mul_bounds34" : tactic =>
  `(tactic| (
    have := madd52lo_lt (x03[3]'(by decide)) (y14[7]'(by decide))
    have := madd52lo_lt (x14[3]'(by decide)) (y03[7]'(by decide))
    have := madd52lo_lt (x25[3]'(by decide)) (y25[3]'(by decide))
    have := madd52lo_lt (x03[7]'(by decide)) (y14[3]'(by decide))
    have := madd52lo_lt (x14[7]'(by decide)) (y03[3]'(by decide))
    have := madd52lo_lt (x25[7]'(by decide)) (y25[7]'(by decide))
    have := madd52hi_lt47 (a := (x03[3]'(by decide))) (b := (y03[7]'(by decide)))
      (by simpa [quadElem] using hx 0) (by simpa [quadElem] using hy 3)
    have := madd52hi_lt47 (a := (x14[3]'(by decide))) (b := (y25[3]'(by decide)))
      (by simpa [quadElem] using hx 1) (by simpa [quadElem] using hy 2)
    have := madd52hi_lt47 (a := (x25[3]'(by decide))) (b := (y14[3]'(by decide)))
      (by simpa [quadElem] using hx 2) (by simpa [quadElem] using hy 1)
    have := madd52hi_lt47 (a := (x03[7]'(by decide))) (b := (y03[3]'(by decide)))
      (by simpa [quadElem] using hx 3) (by simpa [quadElem] using hy 0)
    have := madd52hi_lt47 (a := (x14[7]'(by decide))) (b := (y25[7]'(by decide)))
      (by simpa [quadElem] using hx 4) (by simpa [quadElem] using hy 5)
    have := madd52hi_lt47 (a := (x25[7]'(by decide))) (b := (y14[7]'(by decide)))
      (by simpa [quadElem] using hx 5) (by simpa [quadElem] using hy 4)
    skip))

set_option hygiene false in
/-- The bounds `omega` needs on the `madd52` halves in lane 5 of element 3. -/
local macro "quad_mul_bounds35" : tactic =>
  `(tactic| (
    have := madd52lo_lt (x03[3]'(by decide)) (y25[7]'(by decide))
    have := madd52lo_lt (x14[3]'(by decide)) (y14[7]'(by decide))
    have := madd52lo_lt (x25[3]'(by decide)) (y03[7]'(by decide))
    have := madd52lo_lt (x03[7]'(by decide)) (y25[3]'(by decide))
    have := madd52lo_lt (x14[7]'(by decide)) (y14[3]'(by decide))
    have := madd52lo_lt (x25[7]'(by decide)) (y03[3]'(by decide))
    have := madd52hi_lt47 (a := (x03[3]'(by decide))) (b := (y14[7]'(by decide)))
      (by simpa [quadElem] using hx 0) (by simpa [quadElem] using hy 4)
    have := madd52hi_lt47 (a := (x14[3]'(by decide))) (b := (y03[7]'(by decide)))
      (by simpa [quadElem] using hx 1) (by simpa [quadElem] using hy 3)
    have := madd52hi_lt47 (a := (x25[3]'(by decide))) (b := (y25[3]'(by decide)))
      (by simpa [quadElem] using hx 2) (by simpa [quadElem] using hy 2)
    have := madd52hi_lt47 (a := (x03[7]'(by decide))) (b := (y14[3]'(by decide)))
      (by simpa [quadElem] using hx 3) (by simpa [quadElem] using hy 1)
    have := madd52hi_lt47 (a := (x14[7]'(by decide))) (b := (y03[3]'(by decide)))
      (by simpa [quadElem] using hx 4) (by simpa [quadElem] using hy 0)
    have := madd52hi_lt47 (a := (x25[7]'(by decide))) (b := (y25[7]'(by decide)))
      (by simpa [quadElem] using hx 5) (by simpa [quadElem] using hy 5)
    skip))

/-- A lane of `fd_r43x6_quad_mul_fast` as its columns: the lane operations, `toNat` with no
overflow, then `ring`. -/
local macro "quad_mul_lane" : tactic =>
  `(tactic| (
    unfold fd_r43x6_quad_mul_fast.spec
    iterate 3
      try simp only [wwl_add_get, wwl_and_get, wwl_shl_get, wwl_madd52lo_get,
        wwl_madd52hi_get, wwl_pack_halves_get, wwv_add_if_get, wwl_get0, wwl_get1,
        wwl_get2, wwl_get3, wwl_get4, wwl_get5, wwl_get6, wwl_get7, wwl_zero_get, getD_get,
        Vector.getElem_replicate, BitVec.reduceToNat, Nat.reduceMod, Nat.reduceLT, Nat.reduceAdd,
        Nat.reduceSub, Nat.reduceMul, ite_true, ite_false, Vector.getElem_mk,
        List.getElem_toArray, List.getElem_cons_zero, List.getElem_cons_succ,
        BitVec.reduceGetLsb, Bool.false_eq_true, ↓reduceIte]
    simp only [mcol, lquad, hquad, quadElem, getElem!_pos, Nat.reduceLT, Nat.reduceAdd,
      Vector.getElem_mk, List.getElem_toArray, List.getElem_cons_zero, List.getElem_cons_succ,
      BitVec.zero_add, BitVec.add_zero, BitVec.toNat_add, BitVec.toNat_shiftLeft,
      Nat.shiftLeft_eq, BitVec.reduceToNat, BitVec.toNat_zero, Nat.reducePow, Nat.reduceMod,
      Nat.zero_add, Nat.add_zero, Nat.zero_mod, Nat.zero_mul]
    simp (disch := omega) only [Nat.mod_eq_of_lt, Nat.mod_mod]
    ring))

theorem quad_mul_lane00 {x03 x14 x25 y03 y14 y25 : Wwl}
    (hx : Unsigned 47 (quadElem x03 x14 x25 0)) (hy : Unsigned 47 (quadElem y03 y14 y25 0)) :
    (fd_r43x6_quad_mul_fast.spec x03 x14 x25 y03 y14 y25).1[0].toNat =
      mcol (lquad x03 x14 x25 y03 y14 y25 0) (hquad x03 x14 x25 y03 y14 y25 0) 0 +
        152 * mcol (lquad x03 x14 x25 y03 y14 y25 0) (hquad x03 x14 x25 y03 y14 y25 0) 6 := by
  quad_mul_bounds00
  quad_mul_lane

theorem quad_mul_lane01 {x03 x14 x25 y03 y14 y25 : Wwl}
    (hx : Unsigned 47 (quadElem x03 x14 x25 0)) (hy : Unsigned 47 (quadElem y03 y14 y25 0)) :
    (fd_r43x6_quad_mul_fast.spec x03 x14 x25 y03 y14 y25).2.1[0].toNat =
      mcol (lquad x03 x14 x25 y03 y14 y25 0) (hquad x03 x14 x25 y03 y14 y25 0) 1 +
        152 * mcol (lquad x03 x14 x25 y03 y14 y25 0) (hquad x03 x14 x25 y03 y14 y25 0) 7 := by
  quad_mul_bounds01
  quad_mul_lane

theorem quad_mul_lane02 {x03 x14 x25 y03 y14 y25 : Wwl}
    (hx : Unsigned 47 (quadElem x03 x14 x25 0)) (hy : Unsigned 47 (quadElem y03 y14 y25 0)) :
    (fd_r43x6_quad_mul_fast.spec x03 x14 x25 y03 y14 y25).2.2[0].toNat =
      mcol (lquad x03 x14 x25 y03 y14 y25 0) (hquad x03 x14 x25 y03 y14 y25 0) 2 +
        152 * mcol (lquad x03 x14 x25 y03 y14 y25 0) (hquad x03 x14 x25 y03 y14 y25 0) 8 := by
  quad_mul_bounds02
  quad_mul_lane

theorem quad_mul_lane03 {x03 x14 x25 y03 y14 y25 : Wwl}
    (hx : Unsigned 47 (quadElem x03 x14 x25 0)) (hy : Unsigned 47 (quadElem y03 y14 y25 0)) :
    (fd_r43x6_quad_mul_fast.spec x03 x14 x25 y03 y14 y25).1[4].toNat =
      mcol (lquad x03 x14 x25 y03 y14 y25 0) (hquad x03 x14 x25 y03 y14 y25 0) 3 +
        152 * mcol (lquad x03 x14 x25 y03 y14 y25 0) (hquad x03 x14 x25 y03 y14 y25 0) 9 := by
  quad_mul_bounds03
  quad_mul_lane

theorem quad_mul_lane04 {x03 x14 x25 y03 y14 y25 : Wwl}
    (hx : Unsigned 47 (quadElem x03 x14 x25 0)) (hy : Unsigned 47 (quadElem y03 y14 y25 0)) :
    (fd_r43x6_quad_mul_fast.spec x03 x14 x25 y03 y14 y25).2.1[4].toNat =
      mcol (lquad x03 x14 x25 y03 y14 y25 0) (hquad x03 x14 x25 y03 y14 y25 0) 4 +
        152 * mcol (lquad x03 x14 x25 y03 y14 y25 0) (hquad x03 x14 x25 y03 y14 y25 0) 10 := by
  quad_mul_bounds04
  quad_mul_lane

theorem quad_mul_lane05 {x03 x14 x25 y03 y14 y25 : Wwl}
    (hx : Unsigned 47 (quadElem x03 x14 x25 0)) (hy : Unsigned 47 (quadElem y03 y14 y25 0)) :
    (fd_r43x6_quad_mul_fast.spec x03 x14 x25 y03 y14 y25).2.2[4].toNat =
      mcol (lquad x03 x14 x25 y03 y14 y25 0) (hquad x03 x14 x25 y03 y14 y25 0) 5 +
        152 * mcol (lquad x03 x14 x25 y03 y14 y25 0) (hquad x03 x14 x25 y03 y14 y25 0) 11 := by
  quad_mul_bounds05
  quad_mul_lane

theorem quad_mul_lane10 {x03 x14 x25 y03 y14 y25 : Wwl}
    (hx : Unsigned 47 (quadElem x03 x14 x25 1)) (hy : Unsigned 47 (quadElem y03 y14 y25 1)) :
    (fd_r43x6_quad_mul_fast.spec x03 x14 x25 y03 y14 y25).1[1].toNat =
      mcol (lquad x03 x14 x25 y03 y14 y25 1) (hquad x03 x14 x25 y03 y14 y25 1) 0 +
        152 * mcol (lquad x03 x14 x25 y03 y14 y25 1) (hquad x03 x14 x25 y03 y14 y25 1) 6 := by
  quad_mul_bounds10
  quad_mul_lane

theorem quad_mul_lane11 {x03 x14 x25 y03 y14 y25 : Wwl}
    (hx : Unsigned 47 (quadElem x03 x14 x25 1)) (hy : Unsigned 47 (quadElem y03 y14 y25 1)) :
    (fd_r43x6_quad_mul_fast.spec x03 x14 x25 y03 y14 y25).2.1[1].toNat =
      mcol (lquad x03 x14 x25 y03 y14 y25 1) (hquad x03 x14 x25 y03 y14 y25 1) 1 +
        152 * mcol (lquad x03 x14 x25 y03 y14 y25 1) (hquad x03 x14 x25 y03 y14 y25 1) 7 := by
  quad_mul_bounds11
  quad_mul_lane

theorem quad_mul_lane12 {x03 x14 x25 y03 y14 y25 : Wwl}
    (hx : Unsigned 47 (quadElem x03 x14 x25 1)) (hy : Unsigned 47 (quadElem y03 y14 y25 1)) :
    (fd_r43x6_quad_mul_fast.spec x03 x14 x25 y03 y14 y25).2.2[1].toNat =
      mcol (lquad x03 x14 x25 y03 y14 y25 1) (hquad x03 x14 x25 y03 y14 y25 1) 2 +
        152 * mcol (lquad x03 x14 x25 y03 y14 y25 1) (hquad x03 x14 x25 y03 y14 y25 1) 8 := by
  quad_mul_bounds12
  quad_mul_lane

theorem quad_mul_lane13 {x03 x14 x25 y03 y14 y25 : Wwl}
    (hx : Unsigned 47 (quadElem x03 x14 x25 1)) (hy : Unsigned 47 (quadElem y03 y14 y25 1)) :
    (fd_r43x6_quad_mul_fast.spec x03 x14 x25 y03 y14 y25).1[5].toNat =
      mcol (lquad x03 x14 x25 y03 y14 y25 1) (hquad x03 x14 x25 y03 y14 y25 1) 3 +
        152 * mcol (lquad x03 x14 x25 y03 y14 y25 1) (hquad x03 x14 x25 y03 y14 y25 1) 9 := by
  quad_mul_bounds13
  quad_mul_lane

theorem quad_mul_lane14 {x03 x14 x25 y03 y14 y25 : Wwl}
    (hx : Unsigned 47 (quadElem x03 x14 x25 1)) (hy : Unsigned 47 (quadElem y03 y14 y25 1)) :
    (fd_r43x6_quad_mul_fast.spec x03 x14 x25 y03 y14 y25).2.1[5].toNat =
      mcol (lquad x03 x14 x25 y03 y14 y25 1) (hquad x03 x14 x25 y03 y14 y25 1) 4 +
        152 * mcol (lquad x03 x14 x25 y03 y14 y25 1) (hquad x03 x14 x25 y03 y14 y25 1) 10 := by
  quad_mul_bounds14
  quad_mul_lane

theorem quad_mul_lane15 {x03 x14 x25 y03 y14 y25 : Wwl}
    (hx : Unsigned 47 (quadElem x03 x14 x25 1)) (hy : Unsigned 47 (quadElem y03 y14 y25 1)) :
    (fd_r43x6_quad_mul_fast.spec x03 x14 x25 y03 y14 y25).2.2[5].toNat =
      mcol (lquad x03 x14 x25 y03 y14 y25 1) (hquad x03 x14 x25 y03 y14 y25 1) 5 +
        152 * mcol (lquad x03 x14 x25 y03 y14 y25 1) (hquad x03 x14 x25 y03 y14 y25 1) 11 := by
  quad_mul_bounds15
  quad_mul_lane

theorem quad_mul_lane20 {x03 x14 x25 y03 y14 y25 : Wwl}
    (hx : Unsigned 47 (quadElem x03 x14 x25 2)) (hy : Unsigned 47 (quadElem y03 y14 y25 2)) :
    (fd_r43x6_quad_mul_fast.spec x03 x14 x25 y03 y14 y25).1[2].toNat =
      mcol (lquad x03 x14 x25 y03 y14 y25 2) (hquad x03 x14 x25 y03 y14 y25 2) 0 +
        152 * mcol (lquad x03 x14 x25 y03 y14 y25 2) (hquad x03 x14 x25 y03 y14 y25 2) 6 := by
  quad_mul_bounds20
  quad_mul_lane

theorem quad_mul_lane21 {x03 x14 x25 y03 y14 y25 : Wwl}
    (hx : Unsigned 47 (quadElem x03 x14 x25 2)) (hy : Unsigned 47 (quadElem y03 y14 y25 2)) :
    (fd_r43x6_quad_mul_fast.spec x03 x14 x25 y03 y14 y25).2.1[2].toNat =
      mcol (lquad x03 x14 x25 y03 y14 y25 2) (hquad x03 x14 x25 y03 y14 y25 2) 1 +
        152 * mcol (lquad x03 x14 x25 y03 y14 y25 2) (hquad x03 x14 x25 y03 y14 y25 2) 7 := by
  quad_mul_bounds21
  quad_mul_lane

theorem quad_mul_lane22 {x03 x14 x25 y03 y14 y25 : Wwl}
    (hx : Unsigned 47 (quadElem x03 x14 x25 2)) (hy : Unsigned 47 (quadElem y03 y14 y25 2)) :
    (fd_r43x6_quad_mul_fast.spec x03 x14 x25 y03 y14 y25).2.2[2].toNat =
      mcol (lquad x03 x14 x25 y03 y14 y25 2) (hquad x03 x14 x25 y03 y14 y25 2) 2 +
        152 * mcol (lquad x03 x14 x25 y03 y14 y25 2) (hquad x03 x14 x25 y03 y14 y25 2) 8 := by
  quad_mul_bounds22
  quad_mul_lane

theorem quad_mul_lane23 {x03 x14 x25 y03 y14 y25 : Wwl}
    (hx : Unsigned 47 (quadElem x03 x14 x25 2)) (hy : Unsigned 47 (quadElem y03 y14 y25 2)) :
    (fd_r43x6_quad_mul_fast.spec x03 x14 x25 y03 y14 y25).1[6].toNat =
      mcol (lquad x03 x14 x25 y03 y14 y25 2) (hquad x03 x14 x25 y03 y14 y25 2) 3 +
        152 * mcol (lquad x03 x14 x25 y03 y14 y25 2) (hquad x03 x14 x25 y03 y14 y25 2) 9 := by
  quad_mul_bounds23
  quad_mul_lane

theorem quad_mul_lane24 {x03 x14 x25 y03 y14 y25 : Wwl}
    (hx : Unsigned 47 (quadElem x03 x14 x25 2)) (hy : Unsigned 47 (quadElem y03 y14 y25 2)) :
    (fd_r43x6_quad_mul_fast.spec x03 x14 x25 y03 y14 y25).2.1[6].toNat =
      mcol (lquad x03 x14 x25 y03 y14 y25 2) (hquad x03 x14 x25 y03 y14 y25 2) 4 +
        152 * mcol (lquad x03 x14 x25 y03 y14 y25 2) (hquad x03 x14 x25 y03 y14 y25 2) 10 := by
  quad_mul_bounds24
  quad_mul_lane

theorem quad_mul_lane25 {x03 x14 x25 y03 y14 y25 : Wwl}
    (hx : Unsigned 47 (quadElem x03 x14 x25 2)) (hy : Unsigned 47 (quadElem y03 y14 y25 2)) :
    (fd_r43x6_quad_mul_fast.spec x03 x14 x25 y03 y14 y25).2.2[6].toNat =
      mcol (lquad x03 x14 x25 y03 y14 y25 2) (hquad x03 x14 x25 y03 y14 y25 2) 5 +
        152 * mcol (lquad x03 x14 x25 y03 y14 y25 2) (hquad x03 x14 x25 y03 y14 y25 2) 11 := by
  quad_mul_bounds25
  quad_mul_lane

theorem quad_mul_lane30 {x03 x14 x25 y03 y14 y25 : Wwl}
    (hx : Unsigned 47 (quadElem x03 x14 x25 3)) (hy : Unsigned 47 (quadElem y03 y14 y25 3)) :
    (fd_r43x6_quad_mul_fast.spec x03 x14 x25 y03 y14 y25).1[3].toNat =
      mcol (lquad x03 x14 x25 y03 y14 y25 3) (hquad x03 x14 x25 y03 y14 y25 3) 0 +
        152 * mcol (lquad x03 x14 x25 y03 y14 y25 3) (hquad x03 x14 x25 y03 y14 y25 3) 6 := by
  quad_mul_bounds30
  quad_mul_lane

theorem quad_mul_lane31 {x03 x14 x25 y03 y14 y25 : Wwl}
    (hx : Unsigned 47 (quadElem x03 x14 x25 3)) (hy : Unsigned 47 (quadElem y03 y14 y25 3)) :
    (fd_r43x6_quad_mul_fast.spec x03 x14 x25 y03 y14 y25).2.1[3].toNat =
      mcol (lquad x03 x14 x25 y03 y14 y25 3) (hquad x03 x14 x25 y03 y14 y25 3) 1 +
        152 * mcol (lquad x03 x14 x25 y03 y14 y25 3) (hquad x03 x14 x25 y03 y14 y25 3) 7 := by
  quad_mul_bounds31
  quad_mul_lane

theorem quad_mul_lane32 {x03 x14 x25 y03 y14 y25 : Wwl}
    (hx : Unsigned 47 (quadElem x03 x14 x25 3)) (hy : Unsigned 47 (quadElem y03 y14 y25 3)) :
    (fd_r43x6_quad_mul_fast.spec x03 x14 x25 y03 y14 y25).2.2[3].toNat =
      mcol (lquad x03 x14 x25 y03 y14 y25 3) (hquad x03 x14 x25 y03 y14 y25 3) 2 +
        152 * mcol (lquad x03 x14 x25 y03 y14 y25 3) (hquad x03 x14 x25 y03 y14 y25 3) 8 := by
  quad_mul_bounds32
  quad_mul_lane

theorem quad_mul_lane33 {x03 x14 x25 y03 y14 y25 : Wwl}
    (hx : Unsigned 47 (quadElem x03 x14 x25 3)) (hy : Unsigned 47 (quadElem y03 y14 y25 3)) :
    (fd_r43x6_quad_mul_fast.spec x03 x14 x25 y03 y14 y25).1[7].toNat =
      mcol (lquad x03 x14 x25 y03 y14 y25 3) (hquad x03 x14 x25 y03 y14 y25 3) 3 +
        152 * mcol (lquad x03 x14 x25 y03 y14 y25 3) (hquad x03 x14 x25 y03 y14 y25 3) 9 := by
  quad_mul_bounds33
  quad_mul_lane

theorem quad_mul_lane34 {x03 x14 x25 y03 y14 y25 : Wwl}
    (hx : Unsigned 47 (quadElem x03 x14 x25 3)) (hy : Unsigned 47 (quadElem y03 y14 y25 3)) :
    (fd_r43x6_quad_mul_fast.spec x03 x14 x25 y03 y14 y25).2.1[7].toNat =
      mcol (lquad x03 x14 x25 y03 y14 y25 3) (hquad x03 x14 x25 y03 y14 y25 3) 4 +
        152 * mcol (lquad x03 x14 x25 y03 y14 y25 3) (hquad x03 x14 x25 y03 y14 y25 3) 10 := by
  quad_mul_bounds34
  quad_mul_lane

theorem quad_mul_lane35 {x03 x14 x25 y03 y14 y25 : Wwl}
    (hx : Unsigned 47 (quadElem x03 x14 x25 3)) (hy : Unsigned 47 (quadElem y03 y14 y25 3)) :
    (fd_r43x6_quad_mul_fast.spec x03 x14 x25 y03 y14 y25).2.2[7].toNat =
      mcol (lquad x03 x14 x25 y03 y14 y25 3) (hquad x03 x14 x25 y03 y14 y25 3) 5 +
        152 * mcol (lquad x03 x14 x25 y03 y14 y25 3) (hquad x03 x14 x25 y03 y14 y25 3) 11 := by
  quad_mul_bounds35
  quad_mul_lane

theorem quad_mul_spec0 {x03 x14 x25 y03 y14 y25 : Wwl}
    (hx : Unsigned 47 (quadElem x03 x14 x25 0)) (hy : Unsigned 47 (quadElem y03 y14 y25 0)) :
    let z := fd_r43x6_quad_mul_fast.spec x03 x14 x25 y03 y14 y25
    val (quadElem z.1 z.2.1 z.2.2 0) =
        val (quadElem x03 x14 x25 0) * val (quadElem y03 y14 y25 0) ∧
      Unsigned 63 (quadElem z.1 z.2.1 z.2.2 0) := by
  intro z
  have e0 : z.1[0].toNat =
      mcol (lquad x03 x14 x25 y03 y14 y25 0) (hquad x03 x14 x25 y03 y14 y25 0) 0 +
        152 * mcol (lquad x03 x14 x25 y03 y14 y25 0) (hquad x03 x14 x25 y03 y14 y25 0) 6 :=
    quad_mul_lane00 hx hy
  have e1 : z.2.1[0].toNat =
      mcol (lquad x03 x14 x25 y03 y14 y25 0) (hquad x03 x14 x25 y03 y14 y25 0) 1 +
        152 * mcol (lquad x03 x14 x25 y03 y14 y25 0) (hquad x03 x14 x25 y03 y14 y25 0) 7 :=
    quad_mul_lane01 hx hy
  have e2 : z.2.2[0].toNat =
      mcol (lquad x03 x14 x25 y03 y14 y25 0) (hquad x03 x14 x25 y03 y14 y25 0) 2 +
        152 * mcol (lquad x03 x14 x25 y03 y14 y25 0) (hquad x03 x14 x25 y03 y14 y25 0) 8 :=
    quad_mul_lane02 hx hy
  have e3 : z.1[4].toNat =
      mcol (lquad x03 x14 x25 y03 y14 y25 0) (hquad x03 x14 x25 y03 y14 y25 0) 3 +
        152 * mcol (lquad x03 x14 x25 y03 y14 y25 0) (hquad x03 x14 x25 y03 y14 y25 0) 9 :=
    quad_mul_lane03 hx hy
  have e4 : z.2.1[4].toNat =
      mcol (lquad x03 x14 x25 y03 y14 y25 0) (hquad x03 x14 x25 y03 y14 y25 0) 4 +
        152 * mcol (lquad x03 x14 x25 y03 y14 y25 0) (hquad x03 x14 x25 y03 y14 y25 0) 10 :=
    quad_mul_lane04 hx hy
  have e5 : z.2.2[4].toNat =
      mcol (lquad x03 x14 x25 y03 y14 y25 0) (hquad x03 x14 x25 y03 y14 y25 0) 5 +
        152 * mcol (lquad x03 x14 x25 y03 y14 y25 0) (hquad x03 x14 x25 y03 y14 y25 0) 11 :=
    quad_mul_lane05 hx hy
  clear_value z
  rw [val_eq_nat (hx.mono (by norm_num)), val_eq_nat (hy.mono (by norm_num)), nat_eq_limbs6,
    nat_eq_limbs6]
  exact quad_val_of_lanes (L := lquad x03 x14 x25 y03 y14 y25 0)
    (H := hquad x03 x14 x25 y03 y14 y25 0) (by norm_num) e0 e1 e2 e3 e4 e5
    (fun k i hk hi => madd52_split ((hx.get! hk).trans (by norm_num))
      ((hy.get! hi).trans (by norm_num)))
    (mcol_lt (fun _ _ _ _ => madd52lo_lt _ _)
      fun k i hk hi => madd52hi_lt47 (hx.get! hk) (hy.get! hi))

theorem quad_mul_spec1 {x03 x14 x25 y03 y14 y25 : Wwl}
    (hx : Unsigned 47 (quadElem x03 x14 x25 1)) (hy : Unsigned 47 (quadElem y03 y14 y25 1)) :
    let z := fd_r43x6_quad_mul_fast.spec x03 x14 x25 y03 y14 y25
    val (quadElem z.1 z.2.1 z.2.2 1) =
        val (quadElem x03 x14 x25 1) * val (quadElem y03 y14 y25 1) ∧
      Unsigned 63 (quadElem z.1 z.2.1 z.2.2 1) := by
  intro z
  have e0 : z.1[1].toNat =
      mcol (lquad x03 x14 x25 y03 y14 y25 1) (hquad x03 x14 x25 y03 y14 y25 1) 0 +
        152 * mcol (lquad x03 x14 x25 y03 y14 y25 1) (hquad x03 x14 x25 y03 y14 y25 1) 6 :=
    quad_mul_lane10 hx hy
  have e1 : z.2.1[1].toNat =
      mcol (lquad x03 x14 x25 y03 y14 y25 1) (hquad x03 x14 x25 y03 y14 y25 1) 1 +
        152 * mcol (lquad x03 x14 x25 y03 y14 y25 1) (hquad x03 x14 x25 y03 y14 y25 1) 7 :=
    quad_mul_lane11 hx hy
  have e2 : z.2.2[1].toNat =
      mcol (lquad x03 x14 x25 y03 y14 y25 1) (hquad x03 x14 x25 y03 y14 y25 1) 2 +
        152 * mcol (lquad x03 x14 x25 y03 y14 y25 1) (hquad x03 x14 x25 y03 y14 y25 1) 8 :=
    quad_mul_lane12 hx hy
  have e3 : z.1[5].toNat =
      mcol (lquad x03 x14 x25 y03 y14 y25 1) (hquad x03 x14 x25 y03 y14 y25 1) 3 +
        152 * mcol (lquad x03 x14 x25 y03 y14 y25 1) (hquad x03 x14 x25 y03 y14 y25 1) 9 :=
    quad_mul_lane13 hx hy
  have e4 : z.2.1[5].toNat =
      mcol (lquad x03 x14 x25 y03 y14 y25 1) (hquad x03 x14 x25 y03 y14 y25 1) 4 +
        152 * mcol (lquad x03 x14 x25 y03 y14 y25 1) (hquad x03 x14 x25 y03 y14 y25 1) 10 :=
    quad_mul_lane14 hx hy
  have e5 : z.2.2[5].toNat =
      mcol (lquad x03 x14 x25 y03 y14 y25 1) (hquad x03 x14 x25 y03 y14 y25 1) 5 +
        152 * mcol (lquad x03 x14 x25 y03 y14 y25 1) (hquad x03 x14 x25 y03 y14 y25 1) 11 :=
    quad_mul_lane15 hx hy
  clear_value z
  rw [val_eq_nat (hx.mono (by norm_num)), val_eq_nat (hy.mono (by norm_num)), nat_eq_limbs6,
    nat_eq_limbs6]
  exact quad_val_of_lanes (L := lquad x03 x14 x25 y03 y14 y25 1)
    (H := hquad x03 x14 x25 y03 y14 y25 1) (by norm_num) e0 e1 e2 e3 e4 e5
    (fun k i hk hi => madd52_split ((hx.get! hk).trans (by norm_num))
      ((hy.get! hi).trans (by norm_num)))
    (mcol_lt (fun _ _ _ _ => madd52lo_lt _ _)
      fun k i hk hi => madd52hi_lt47 (hx.get! hk) (hy.get! hi))

theorem quad_mul_spec2 {x03 x14 x25 y03 y14 y25 : Wwl}
    (hx : Unsigned 47 (quadElem x03 x14 x25 2)) (hy : Unsigned 47 (quadElem y03 y14 y25 2)) :
    let z := fd_r43x6_quad_mul_fast.spec x03 x14 x25 y03 y14 y25
    val (quadElem z.1 z.2.1 z.2.2 2) =
        val (quadElem x03 x14 x25 2) * val (quadElem y03 y14 y25 2) ∧
      Unsigned 63 (quadElem z.1 z.2.1 z.2.2 2) := by
  intro z
  have e0 : z.1[2].toNat =
      mcol (lquad x03 x14 x25 y03 y14 y25 2) (hquad x03 x14 x25 y03 y14 y25 2) 0 +
        152 * mcol (lquad x03 x14 x25 y03 y14 y25 2) (hquad x03 x14 x25 y03 y14 y25 2) 6 :=
    quad_mul_lane20 hx hy
  have e1 : z.2.1[2].toNat =
      mcol (lquad x03 x14 x25 y03 y14 y25 2) (hquad x03 x14 x25 y03 y14 y25 2) 1 +
        152 * mcol (lquad x03 x14 x25 y03 y14 y25 2) (hquad x03 x14 x25 y03 y14 y25 2) 7 :=
    quad_mul_lane21 hx hy
  have e2 : z.2.2[2].toNat =
      mcol (lquad x03 x14 x25 y03 y14 y25 2) (hquad x03 x14 x25 y03 y14 y25 2) 2 +
        152 * mcol (lquad x03 x14 x25 y03 y14 y25 2) (hquad x03 x14 x25 y03 y14 y25 2) 8 :=
    quad_mul_lane22 hx hy
  have e3 : z.1[6].toNat =
      mcol (lquad x03 x14 x25 y03 y14 y25 2) (hquad x03 x14 x25 y03 y14 y25 2) 3 +
        152 * mcol (lquad x03 x14 x25 y03 y14 y25 2) (hquad x03 x14 x25 y03 y14 y25 2) 9 :=
    quad_mul_lane23 hx hy
  have e4 : z.2.1[6].toNat =
      mcol (lquad x03 x14 x25 y03 y14 y25 2) (hquad x03 x14 x25 y03 y14 y25 2) 4 +
        152 * mcol (lquad x03 x14 x25 y03 y14 y25 2) (hquad x03 x14 x25 y03 y14 y25 2) 10 :=
    quad_mul_lane24 hx hy
  have e5 : z.2.2[6].toNat =
      mcol (lquad x03 x14 x25 y03 y14 y25 2) (hquad x03 x14 x25 y03 y14 y25 2) 5 +
        152 * mcol (lquad x03 x14 x25 y03 y14 y25 2) (hquad x03 x14 x25 y03 y14 y25 2) 11 :=
    quad_mul_lane25 hx hy
  clear_value z
  rw [val_eq_nat (hx.mono (by norm_num)), val_eq_nat (hy.mono (by norm_num)), nat_eq_limbs6,
    nat_eq_limbs6]
  exact quad_val_of_lanes (L := lquad x03 x14 x25 y03 y14 y25 2)
    (H := hquad x03 x14 x25 y03 y14 y25 2) (by norm_num) e0 e1 e2 e3 e4 e5
    (fun k i hk hi => madd52_split ((hx.get! hk).trans (by norm_num))
      ((hy.get! hi).trans (by norm_num)))
    (mcol_lt (fun _ _ _ _ => madd52lo_lt _ _)
      fun k i hk hi => madd52hi_lt47 (hx.get! hk) (hy.get! hi))

theorem quad_mul_spec3 {x03 x14 x25 y03 y14 y25 : Wwl}
    (hx : Unsigned 47 (quadElem x03 x14 x25 3)) (hy : Unsigned 47 (quadElem y03 y14 y25 3)) :
    let z := fd_r43x6_quad_mul_fast.spec x03 x14 x25 y03 y14 y25
    val (quadElem z.1 z.2.1 z.2.2 3) =
        val (quadElem x03 x14 x25 3) * val (quadElem y03 y14 y25 3) ∧
      Unsigned 63 (quadElem z.1 z.2.1 z.2.2 3) := by
  intro z
  have e0 : z.1[3].toNat =
      mcol (lquad x03 x14 x25 y03 y14 y25 3) (hquad x03 x14 x25 y03 y14 y25 3) 0 +
        152 * mcol (lquad x03 x14 x25 y03 y14 y25 3) (hquad x03 x14 x25 y03 y14 y25 3) 6 :=
    quad_mul_lane30 hx hy
  have e1 : z.2.1[3].toNat =
      mcol (lquad x03 x14 x25 y03 y14 y25 3) (hquad x03 x14 x25 y03 y14 y25 3) 1 +
        152 * mcol (lquad x03 x14 x25 y03 y14 y25 3) (hquad x03 x14 x25 y03 y14 y25 3) 7 :=
    quad_mul_lane31 hx hy
  have e2 : z.2.2[3].toNat =
      mcol (lquad x03 x14 x25 y03 y14 y25 3) (hquad x03 x14 x25 y03 y14 y25 3) 2 +
        152 * mcol (lquad x03 x14 x25 y03 y14 y25 3) (hquad x03 x14 x25 y03 y14 y25 3) 8 :=
    quad_mul_lane32 hx hy
  have e3 : z.1[7].toNat =
      mcol (lquad x03 x14 x25 y03 y14 y25 3) (hquad x03 x14 x25 y03 y14 y25 3) 3 +
        152 * mcol (lquad x03 x14 x25 y03 y14 y25 3) (hquad x03 x14 x25 y03 y14 y25 3) 9 :=
    quad_mul_lane33 hx hy
  have e4 : z.2.1[7].toNat =
      mcol (lquad x03 x14 x25 y03 y14 y25 3) (hquad x03 x14 x25 y03 y14 y25 3) 4 +
        152 * mcol (lquad x03 x14 x25 y03 y14 y25 3) (hquad x03 x14 x25 y03 y14 y25 3) 10 :=
    quad_mul_lane34 hx hy
  have e5 : z.2.2[7].toNat =
      mcol (lquad x03 x14 x25 y03 y14 y25 3) (hquad x03 x14 x25 y03 y14 y25 3) 5 +
        152 * mcol (lquad x03 x14 x25 y03 y14 y25 3) (hquad x03 x14 x25 y03 y14 y25 3) 11 :=
    quad_mul_lane35 hx hy
  clear_value z
  rw [val_eq_nat (hx.mono (by norm_num)), val_eq_nat (hy.mono (by norm_num)), nat_eq_limbs6,
    nat_eq_limbs6]
  exact quad_val_of_lanes (L := lquad x03 x14 x25 y03 y14 y25 3)
    (H := hquad x03 x14 x25 y03 y14 y25 3) (by norm_num) e0 e1 e2 e3 e4 e5
    (fun k i hk hi => madd52_split ((hx.get! hk).trans (by norm_num))
      ((hy.get! hi).trans (by norm_num)))
    (mcol_lt (fun _ _ _ _ => madd52lo_lt _ _)
      fun k i hk hi => madd52hi_lt47 (hx.get! hk) (hy.get! hi))


/-- `fd_r43x6_quad_mul_fast` multiplies element `j < 4` of two QUADs of `u47` limbs into `u63`
limbs. -/
public theorem fd_r43x6_quad_mul_fast_spec {x03 x14 x25 y03 y14 y25 : Wwl} {j : ℕ} (hj : j < 4)
    (hx : Unsigned 47 (quadElem x03 x14 x25 j)) (hy : Unsigned 47 (quadElem y03 y14 y25 j)) :
    let z := fd_r43x6_quad_mul_fast.spec x03 x14 x25 y03 y14 y25
    val (quadElem z.1 z.2.1 z.2.2 j) =
        val (quadElem x03 x14 x25 j) * val (quadElem y03 y14 y25 j) ∧
      Unsigned 63 (quadElem z.1 z.2.1 z.2.2 j) := by
  match j, hj with
  | 0, _ => exact quad_mul_spec0 hx hy
  | 1, _ => exact quad_mul_spec1 hx hy
  | 2, _ => exact quad_mul_spec2 hx hy
  | 3, _ => exact quad_mul_spec3 hx hy

end R43x6

end MLIR.Firedancer.Avx512
