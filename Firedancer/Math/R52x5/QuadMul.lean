module

public import Firedancer.Math.R52x5.Mul
public import Firedancer.Math.R52x5.Point
public import Firedancer.R52x5.fd_r52x5_quad_mul_fast
import Firedancer.Math.Avx512.Mul
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Ring
public meta import Lean.Elab.Tactic

/-! `fd_r52x5_quad_mul_fast` in `ZMod p`: lane by lane, the products' 52-bit halves summed by
radix-`2^51` columns, then the C's fold of columns 5-9 by `2^255 = 19`. -/

namespace MLIR.Firedancer.R52x5

open _root_.Ed25519 (p)
open Firedancer.Avx512 (madd52lo madd52hi)
open Firedancer.Avx512.R43x6 (madd52lo_lt madd52lo_toNat madd52hi_toNat madd52_split)

/-! ## The fold -/

@[expose] public section

/-- The end of `fd_r52x5_quad_mul_fast`: columns `z5 … z9` times 19 into limbs 0-4, each split
by `madd52` at bit 52, then `rk = zk_1 + 2 zk_2`. -/
def quadFold (z0_1 z1_1 z2_1 z3_1 z4_1 z1_2 z2_2 z3_2 z4_2 z5 z6 z7 z8 z9 : Wl) : Quad5 :=
  let z0_2 := wl_zero
  let t0 := wl_zero
  let t1 := wl_zero
  let r19 := wl_bcast 19
  let t1 := wl_madd52lo t1 r19 (wl_shru z9 52)
  let z1_2 := wl_madd52lo z1_2 r19 (wl_shru z5 52)
  let z2_2 := wl_madd52lo z2_2 r19 (wl_shru z6 52)
  let z3_2 := wl_madd52lo z3_2 r19 (wl_shru z7 52)
  let z0_1 := wl_madd52lo z0_1 r19 z5
  let z1_1 := wl_madd52lo z1_1 r19 z6
  let z1_2 := wl_madd52hi z1_2 r19 z5
  let z2_1 := wl_madd52lo z2_1 r19 z7
  let z2_2 := wl_madd52hi z2_2 r19 z6
  let z3_1 := wl_madd52lo z3_1 r19 z8
  let z3_2 := wl_madd52hi z3_2 r19 z7
  let z4_1 := wl_madd52lo z4_1 r19 z9
  let z4_2 := wl_madd52hi z4_2 r19 z8
  let t0 := wl_madd52hi t0 r19 z9
  let z0_2 := wl_madd52lo z0_2 r19 (wl_add t0 t1)
  let z4_2 := wl_madd52lo z4_2 r19 (wl_shru z8 52)
  let r0 := wl_add (wl_add z0_1 z0_2) z0_2
  let r1 := wl_add (wl_add z1_1 z1_2) z1_2
  let r2 := wl_add (wl_add z2_1 z2_2) z2_2
  let r3 := wl_add (wl_add z3_1 z3_2) z3_2
  let r4 := wl_add (wl_add z4_1 z4_2) z4_2
  ⟨r0, r1, r2, r3, r4⟩

end

/-! Lanes of the fold in `ℕ`. -/

/-- `madd52lo( 19, c )` in `ℕ`. -/
def lo19 (c : ℕ) : ℕ :=
  19 * (c % 2 ^ 52) % 2 ^ 52

/-- `madd52hi( 19, c )` in `ℕ`. -/
def hi19 (c : ℕ) : ℕ :=
  19 * (c % 2 ^ 52) / 2 ^ 52

theorem lo19_lt (c : ℕ) : lo19 c < 2 ^ 52 :=
  Nat.mod_lt _ (by decide)

theorem hi19_lt (c : ℕ) : hi19 c < 19 := by
  unfold hi19; omega

theorem lo19_of_lt {c : ℕ} (h : c < 2 ^ 47) : lo19 c = 19 * c := by
  unfold lo19; omega

/-- `19 c` split at bit 52 as the fold splits it. -/
theorem lo19_hi19 (c : ℕ) : 19 * c = lo19 c + 2 ^ 52 * (hi19 c + 19 * (c / 2 ^ 52)) := by
  unfold lo19 hi19; omega

theorem toNat_and_m52 (z : BitVec 64) : (z &&& Firedancer.Avx512.m52).toNat = z.toNat % 2 ^ 52 := by
  rw [BitVec.toNat_and]
  exact Firedancer.Avx512.R43x6.and_m52 _

theorem madd52lo_and (a b : BitVec 64) :
    madd52lo a (b &&& Firedancer.Avx512.m52) = madd52lo a b := by
  unfold madd52lo; rw [BitVec.and_assoc, BitVec.and_self]

theorem madd52hi_and (a b : BitVec 64) :
    madd52hi a (b &&& Firedancer.Avx512.m52) = madd52hi a b := by
  unfold madd52hi; rw [BitVec.and_assoc, BitVec.and_self]

theorem toNat_madd52lo_19 (z : BitVec 64) : (madd52lo 19 z).toNat = lo19 z.toNat := by
  have := toNat_and_m52 z
  rw [← madd52lo_and, madd52lo_toNat (by decide) (by omega), this]
  rfl

theorem toNat_madd52hi_19 (z : BitVec 64) : (madd52hi 19 z).toNat = hi19 z.toNat := by
  have := toNat_and_m52 z
  rw [← madd52hi_and, madd52hi_toNat (by decide) (by omega), this]
  rfl

theorem toNat_madd52lo_19_shr (z : BitVec 64) :
    (madd52lo 19 (z >>> 52)).toNat = 19 * (z.toNat / 2 ^ 52) := by
  have := z.isLt
  rw [toNat_madd52lo_19, BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow, lo19_of_lt (by omega)]

/-- The fold's limbs in `ℕ`, for `zk_1`, `zk_2` below `2^60`. -/
theorem quadFold_toNat {z0_1 z1_1 z2_1 z3_1 z4_1 z1_2 z2_2 z3_2 z4_2 z5 z6 z7 z8 z9 : Wl}
    (j : Fin 4) (ha0 : z0_1[j].toNat < 2 ^ 60) (ha1 : z1_1[j].toNat < 2 ^ 60)
    (ha2 : z2_1[j].toNat < 2 ^ 60) (ha3 : z3_1[j].toNat < 2 ^ 60) (ha4 : z4_1[j].toNat < 2 ^ 60)
    (hb1 : z1_2[j].toNat < 2 ^ 60) (hb2 : z2_2[j].toNat < 2 ^ 60) (hb3 : z3_2[j].toNat < 2 ^ 60)
    (hb4 : z4_2[j].toNat < 2 ^ 60) :
    let Q := quadFold z0_1 z1_1 z2_1 z3_1 z4_1 z1_2 z2_2 z3_2 z4_2 z5 z6 z7 z8 z9
    (Q.elem j 0).toNat =
        z0_1[j].toNat + lo19 z5[j].toNat +
          2 * (19 * (hi19 z9[j].toNat + 19 * (z9[j].toNat / 2 ^ 52))) ∧
      (Q.elem j 1).toNat =
        z1_1[j].toNat + lo19 z6[j].toNat +
          2 * (z1_2[j].toNat + (hi19 z5[j].toNat + 19 * (z5[j].toNat / 2 ^ 52))) ∧
      (Q.elem j 2).toNat =
        z2_1[j].toNat + lo19 z7[j].toNat +
          2 * (z2_2[j].toNat + (hi19 z6[j].toNat + 19 * (z6[j].toNat / 2 ^ 52))) ∧
      (Q.elem j 3).toNat =
        z3_1[j].toNat + lo19 z8[j].toNat +
          2 * (z3_2[j].toNat + (hi19 z7[j].toNat + 19 * (z7[j].toNat / 2 ^ 52))) ∧
      (Q.elem j 4).toNat =
        z4_1[j].toNat + lo19 z9[j].toNat +
          2 * (z4_2[j].toNat + (hi19 z8[j].toNat + 19 * (z8[j].toNat / 2 ^ 52))) := by
  simp only [quadFold, Quad5.elem_0, Quad5.elem_1, Quad5.elem_2, Quad5.elem_3, Quad5.elem_4,
    Fin.getElem_fin, wl_madd52lo_getElem, wl_madd52hi_getElem, wl_add_getElem, wl_shru_getElem,
    wl_bcast_getElem, Vector.getElem_replicate] at *
  have := z5[(j : ℕ)].isLt; have := z6[(j : ℕ)].isLt; have := z7[(j : ℕ)].isLt
  have := z8[(j : ℕ)].isLt; have := z9[(j : ℕ)].isLt
  have := hi19_lt z5[(j : ℕ)].toNat; have := hi19_lt z6[(j : ℕ)].toNat
  have := hi19_lt z7[(j : ℕ)].toNat; have := hi19_lt z8[(j : ℕ)].toNat
  have := hi19_lt z9[(j : ℕ)].toNat
  have := lo19_lt z5[(j : ℕ)].toNat; have := lo19_lt z6[(j : ℕ)].toNat
  have := lo19_lt z7[(j : ℕ)].toNat; have := lo19_lt z8[(j : ℕ)].toNat
  have := lo19_lt z9[(j : ℕ)].toNat
  have h0 : BitVec.toNat (0 : BitVec 64) = 0 := rfl
  simp (disch := omega) only [BitVec.toNat_add, toNat_madd52lo_19, toNat_madd52hi_19, h0,
    BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow, Nat.zero_add, Nat.mod_eq_of_lt, lo19_of_lt]
  refine ⟨?_, ?_, ?_, ?_, ?_⟩ <;> omega

/-- The fold of columns `A 0 … A 4` (`zk_1 + 2 zk_2`) and `C 5 … C 9` (`zk`, any 64 bits) has
value `Σ (A n + 19 C (n + 5)) 2^(51 n)`, limbs at most `B + 2^52 + 2^22` for `A n ≤ B < 2^60`. -/
theorem quadFold_spec {z0_1 z1_1 z2_1 z3_1 z4_1 z1_2 z2_2 z3_2 z4_2 z5 z6 z7 z8 z9 : Wl} {j : Fin 4}
    {A C : ℕ → ℕ} {B : ℕ} (hA0 : z0_1[j].toNat = A 0)
    (hA1 : z1_1[j].toNat + 2 * z1_2[j].toNat = A 1) (hA2 : z2_1[j].toNat + 2 * z2_2[j].toNat = A 2)
    (hA3 : z3_1[j].toNat + 2 * z3_2[j].toNat = A 3) (hA4 : z4_1[j].toNat + 2 * z4_2[j].toNat = A 4)
    (hC5 : z5[j].toNat = C 5) (hC6 : z6[j].toNat = C 6) (hC7 : z7[j].toNat = C 7)
    (hC8 : z8[j].toNat = C 8) (hC9 : z9[j].toNat = C 9) (hB : ∀ n < 5, A n ≤ B)
    (hB60 : B < 2 ^ 60) :
    let Q := quadFold z0_1 z1_1 z2_1 z3_1 z4_1 z1_2 z2_2 z3_2 z4_2 z5 z6 z7 z8 z9
    Q.val j = ((limbs5 fun n => A n + 19 * C (n + 5) : ℕ) : ZMod p) ∧
      ∀ i, (Q.elem j i).toNat ≤ B + 2 ^ 52 + 2 ^ 22 := by
  intro Q
  have := hB 0 (by decide); have := hB 1 (by decide); have := hB 2 (by decide)
  have := hB 3 (by decide); have := hB 4 (by decide)
  obtain ⟨r0, r1, r2, r3, r4⟩ :=
    quadFold_toNat (z0_1 := z0_1) (z1_1 := z1_1) (z2_1 := z2_1) (z3_1 := z3_1) (z4_1 := z4_1)
      (z1_2 := z1_2) (z2_2 := z2_2) (z3_2 := z3_2) (z4_2 := z4_2) (z5 := z5) (z6 := z6) (z7 := z7)
      (z8 := z8) (z9 := z9) j (by omega) (by omega) (by omega) (by omega) (by omega) (by omega)
      (by omega) (by omega) (by omega)
  /- `K c` is what the fold carries out of `19 c` at bit 52. -/
  let K (c : ℕ) := hi19 c + 19 * (c / 2 ^ 52)
  replace r0 : (Q.elem j 0).toNat = A 0 + lo19 (C 5) + 38 * K (C 9) := by
    rw [r0, hA0, hC5, hC9]; ring
  replace r1 : (Q.elem j 1).toNat = A 1 + lo19 (C 6) + 2 * K (C 5) := by
    rw [r1, ← hA1, hC6, hC5]; ring
  replace r2 : (Q.elem j 2).toNat = A 2 + lo19 (C 7) + 2 * K (C 6) := by
    rw [r2, ← hA2, hC7, hC6]; ring
  replace r3 : (Q.elem j 3).toNat = A 3 + lo19 (C 8) + 2 * K (C 7) := by
    rw [r3, ← hA3, hC8, hC7]; ring
  replace r4 : (Q.elem j 4).toNat = A 4 + lo19 (C 9) + 2 * K (C 8) := by
    rw [r4, ← hA4, hC9, hC8]; ring
  refine ⟨?_, fun i => ?_⟩
  · have s (c : ℕ) : (19 : ZMod p) * c = lo19 c + 2 ^ 52 * K c := by
      exact_mod_cast congrArg (Nat.cast (R := ZMod p)) (lo19_hi19 c)
    rw [Quad5.val, Ed25519.Limbs.val_eq, r0, r1, r2, r3, r4]
    simp only [limbs5]
    push_cast
    linear_combination
      -(s (C 5) + 2 ^ 51 * s (C 6) + 2 ^ 102 * s (C 7) + 2 ^ 153 * s (C 8) + 2 ^ 204 * s (C 9)) -
        2 * (K (C 9) : ZMod p) * Ed25519.two_pow_255
  · have k (c : ℕ) (hc : c < 2 ^ 64) : K c ≤ 77823 := by
      have := hi19_lt c; simp only [K]; omega
    have := k (C 5) (hC5 ▸ z5[j].isLt); have := k (C 6) (hC6 ▸ z6[j].isLt)
    have := k (C 7) (hC7 ▸ z7[j].isLt); have := k (C 8) (hC8 ▸ z8[j].isLt)
    have := k (C 9) (hC9 ▸ z9[j].isLt)
    have := lo19_lt (C 5); have := lo19_lt (C 6); have := lo19_lt (C 7); have := lo19_lt (C 8)
    have := lo19_lt (C 9)
    fin_cases i
    · show (Q.elem j 0).toNat ≤ _; rw [r0]; omega
    · show (Q.elem j 1).toNat ≤ _; rw [r1]; omega
    · show (Q.elem j 2).toNat ≤ _; rw [r2]; omega
    · show (Q.elem j 3).toNat ≤ _; rw [r3]; omega
    · show (Q.elem j 4).toNat ≤ _; rw [r4]; omega

/-- `quadFold_spec` in the shape of a goal about `quadFold`'s value and limbs. -/
public theorem quadFold_is {z0_1 z1_1 z2_1 z3_1 z4_1 z1_2 z2_2 z3_2 z4_2 z5 z6 z7 z8 z9 : Wl}
    {j : Fin 4} (A C : ℕ → ℕ) (B : ℕ) {v : ZMod p} {b : ℕ} (hA0 : z0_1[j].toNat = A 0)
    (hA1 : z1_1[j].toNat + 2 * z1_2[j].toNat = A 1) (hA2 : z2_1[j].toNat + 2 * z2_2[j].toNat = A 2)
    (hA3 : z3_1[j].toNat + 2 * z3_2[j].toNat = A 3) (hA4 : z4_1[j].toNat + 2 * z4_2[j].toNat = A 4)
    (hC5 : z5[j].toNat = C 5) (hC6 : z6[j].toNat = C 6) (hC7 : z7[j].toNat = C 7)
    (hC8 : z8[j].toNat = C 8) (hC9 : z9[j].toNat = C 9) (hB : ∀ n < 5, A n ≤ B) (hB60 : B < 2 ^ 60)
    (hv : ((limbs5 fun n => A n + 19 * C (n + 5) : ℕ) : ZMod p) = v)
    (hb : B + 2 ^ 52 + 2 ^ 22 ≤ b) :
    (quadFold z0_1 z1_1 z2_1 z3_1 z4_1 z1_2 z2_2 z3_2 z4_2 z5 z6 z7 z8 z9).val j = v ∧
      ∀ i,
        ((quadFold z0_1 z1_1 z2_1 z3_1 z4_1 z1_2 z2_2 z3_2 z4_2 z5 z6 z7 z8 z9).elem j i).toNat ≤
          b := by
  obtain ⟨h1, h2⟩ := quadFold_spec hA0 hA1 hA2 hA3 hA4 hC5 hC6 hC7 hC8 hC9 hB hB60
  exact ⟨h1.trans hv, fun i => (h2 i).trans hb⟩

/-! ## Columns -/

/-- Limb `k`'s lane `j` of `Q`, zero past limb 4. -/
@[expose]
public def Quad5.laneN (Q : Quad5) (j : Fin 4) : ℕ → BitVec 64
  | 0 => Q.P0[j]
  | 1 => Q.P1[j]
  | 2 => Q.P2[j]
  | 3 => Q.P3[j]
  | 4 => Q.P4[j]
  | _ => 0

public theorem Quad5.nat_elem (Q : Quad5) (j : Fin 4) :
    Ed25519.Limbs.nat (Q.elem j) = limbs5 fun k => (Q.laneN j k).toNat :=
  rfl

public theorem Quad5.laneN_lt {Q : Quad5} (h : Q.Below 52) (j : Fin 4) {k : ℕ} (hk : k < 5) :
    (Q.laneN j k).toNat < 2 ^ 52 := by
  match k, hk with
  | 0, _ => exact h j 0
  | 1, _ => exact h j 1
  | 2, _ => exact h j 2
  | 3, _ => exact h j 3
  | 4, _ => exact h j 4

public meta section

open Lean Meta Elab Tactic in
/-- The `madd52lo`/`madd52hi` subterms of `e`. -/
partial def maddTerms (e : Expr) (acc : Array Expr) : Array Expr :=
  let acc :=
    if (e.isAppOfArity ``madd52lo 2 || e.isAppOfArity ``madd52hi 2) && !acc.contains e then
      acc.push e
    else acc
  match e with
  | .app f a => maddTerms a (maddTerms f acc)
  | .mdata _ b => maddTerms b acc
  | _ => acc

open Lean Meta Elab Tactic in
/-- `madd_bounds`: each `madd52lo a b` of the goal below `2^52`, and each `madd52hi a b` whose
operands' 52-bit bounds are hypotheses. -/
elab "madd_bounds" : tactic =>
  withMainContext do
    for t in maddTerms (← instantiateMVars (← getMainTarget)) #[] do
      let a ← Term.exprToSyntax t.appFn!.appArg!
      let b ← Term.exprToSyntax t.appArg!
      if t.isAppOfArity ``madd52lo 2 then
        evalTactic (← `(tactic| have := madd52lo_lt $a $b))
      else
        evalTactic
            (←
              `(tactic|
                  try have := madd52hi_lt52 (a := $a) (b := $b) (by assumption) (by assumption)))

end

/-! ## `fd_r52x5_quad_mul_fast` -/

/-- `madd52lo`'s product, lane `j`, of limb `k` of `X` and limb `i` of `Y`. -/
def lq (X Y : Quad5) (j : Fin 4) (k i : ℕ) : ℕ :=
  (madd52lo (X.laneN j k) (Y.laneN j i)).toNat

/-- `madd52hi`'s product, lane `j`, of limb `k` of `X` and limb `i` of `Y`. -/
def hq (X Y : Quad5) (j : Fin 4) (k i : ℕ) : ℕ :=
  (madd52hi (X.laneN j k) (Y.laneN j i)).toNat

/-- `fd_r52x5_quad_mul_fast` as its columns, then `quadFold`. -/
theorem quad_mul_eq_fold (X Y : Quad5) :
    fd_r52x5_quad_mul_fast.spec X Y =
      let x0 := X.P0
      let x1 := X.P1
      let x2 := X.P2
      let x3 := X.P3
      let x4 := X.P4
      let y0 := Y.P0
      let y1 := Y.P1
      let y2 := Y.P2
      let y3 := Y.P3
      let y4 := Y.P4
      let _zz := wl_zero
      let z0_1 := wl_madd52lo _zz x0 y0
      let z1_1 := wl_madd52lo (wl_madd52lo _zz x1 y0) x0 y1
      let z2_1 := wl_madd52lo (wl_madd52lo (wl_madd52lo _zz x2 y0) x1 y1) x0 y2
      let z3_1 := wl_madd52lo (wl_madd52lo (wl_madd52lo _zz x3 y0) x2 y1) x1 y2
      let z3_1 := wl_madd52lo z3_1 x0 y3
      let z4_1 := wl_madd52lo (wl_madd52lo (wl_madd52lo _zz x4 y0) x3 y1) x2 y2
      let z4_1 := wl_madd52lo (wl_madd52lo z4_1 x1 y3) x0 y4
      let z5_1 := wl_madd52lo (wl_madd52lo (wl_madd52lo _zz x4 y1) x3 y2) x2 y3
      let z5_1 := wl_madd52lo z5_1 x1 y4
      let z6_1 := wl_madd52lo (wl_madd52lo (wl_madd52lo _zz x4 y2) x3 y3) x2 y4
      let z7_1 := wl_madd52lo (wl_madd52lo _zz x4 y3) x3 y4
      let z8_1 := wl_madd52lo _zz x4 y4
      let z1_2 := wl_madd52hi _zz x0 y0
      let z2_2 := wl_madd52hi (wl_madd52hi _zz x1 y0) x0 y1
      let z3_2 := wl_madd52hi (wl_madd52hi (wl_madd52hi _zz x2 y0) x1 y1) x0 y2
      let z4_2 := wl_madd52hi (wl_madd52hi (wl_madd52hi _zz x3 y0) x2 y1) x1 y2
      let z4_2 := wl_madd52hi z4_2 x0 y3
      let z5_2 := wl_madd52hi (wl_madd52hi (wl_madd52hi _zz x4 y0) x3 y1) x2 y2
      let z5_2 := wl_madd52hi (wl_madd52hi z5_2 x1 y3) x0 y4
      let z6_2 := wl_madd52hi (wl_madd52hi (wl_madd52hi _zz x4 y1) x3 y2) x2 y3
      let z6_2 := wl_madd52hi z6_2 x1 y4
      let z7_2 := wl_madd52hi (wl_madd52hi (wl_madd52hi _zz x4 y2) x3 y3) x2 y4
      let z8_2 := wl_madd52hi (wl_madd52hi _zz x4 y3) x3 y4
      let z9_2 := wl_madd52hi _zz x4 y4
      let z5 := wl_add (wl_add z5_1 z5_2) z5_2
      let z6 := wl_add (wl_add z6_1 z6_2) z6_2
      let z7 := wl_add (wl_add z7_1 z7_2) z7_2
      let z8 := wl_add (wl_add z8_1 z8_2) z8_2
      let z9 := wl_add z9_2 z9_2
      quadFold z0_1 z1_1 z2_1 z3_1 z4_1 z1_2 z2_2 z3_2 z4_2 z5 z6 z7 z8 z9 :=
  rfl

/-- A column of `fd_r52x5_quad_mul_fast` in lane `j`: the lane operations, `toNat` with no
overflow. -/
local macro "mul_col" : tactic =>
  `(tactic|
    ( simp only [Fin.getElem_fin, wl_madd52lo_getElem, wl_madd52hi_getElem, wl_add_getElem,
        Vector.getElem_replicate, mcol, lq, hq, Quad5.laneN]
      madd_bounds
      simp only [BitVec.toNat_add, show BitVec.toNat (0 : BitVec 64) = 0 from rfl, Nat.zero_add]
      omega))

/-- `fd_r52x5_quad_mul_fast` multiplies `B(52)` QUADs lane by lane, limbs at most `2^56 - 2^52`
(`FD_R52X5_QUAD_NEGATE_LAZY`'s range). -/
public theorem fd_r52x5_quad_mul_fast.spec_lane {X Y : Quad5} (hX : X.Below 52) (hY : Y.Below 52)
    (j : Fin 4) :
    (fd_r52x5_quad_mul_fast.spec X Y).val j = X.val j * Y.val j ∧
      ∀ i, ((fd_r52x5_quad_mul_fast.spec X Y).elem j i).toNat ≤ 2 ^ 56 - 2 ^ 52 := by
  have := hX j 0; have := hX j 1; have := hX j 2; have := hX j 3; have := hX j 4
  have := hY j 0; have := hY j 1; have := hY j 2; have := hY j 3; have := hY j 4
  simp only [Quad5.elem_0, Quad5.elem_1, Quad5.elem_2, Quad5.elem_3, Quad5.elem_4,
    Fin.getElem_fin] at *
  rw [quad_mul_eq_fold]
  refine
    quadFold_is (mcol (lq X Y j) (hq X Y j)) (mcol (lq X Y j) (hq X Y j)) (13 * 2 ^ 52) ?_ ?_ ?_ ?_
      ?_ ?_ ?_ ?_ ?_ ?_ (fun n hn => ?_) (by norm_num) ?_ (by norm_num)
  · mul_col
  · mul_col
  · mul_col
  · mul_col
  · mul_col
  · mul_col
  · mul_col
  · mul_col
  · mul_col
  · mul_col
  · match n, hn with
    | 0, _ | 1, _ | 2, _ | 3, _ | 4,
      _ =>
      simp only [Fin.getElem_fin, mcol, lq, hq, Quad5.laneN]
      madd_bounds
      omega
  · rw [cast_of_core
        (mul_core (L := lq X Y j) (H := hq X Y j) fun k i hk hi =>
          madd52_split (X.laneN_lt hX j hk) (Y.laneN_lt hY j hi)),
      Quad5.val, Quad5.val, Ed25519.Limbs.val_nat, Ed25519.Limbs.val_nat, Quad5.nat_elem,
      Quad5.nat_elem, Nat.cast_mul]

/-- `fd_r52x5_quad_mul_fast` of QUADs with limbs below `2^52`: the four products, limbs at most
`2^56 - 2^52`. -/
public theorem fd_r52x5_quad_mul_fast.spec_is {X Y : Quad5} (hX : X.Is v b) (hY : Y.Is w c)
    (hb : ∀ j, b j < 2 ^ 52) (hc : ∀ j, c j < 2 ^ 52) :
    (fd_r52x5_quad_mul_fast.spec X Y).Is (fun j => v j * w j) (fun _ => 2 ^ 56 - 2 ^ 52) := by
  intro j
  obtain ⟨h1, h2⟩ := spec_lane (hX.below hb) (hY.below hc) j
  exact ⟨h1.trans (by rw [hX.val, hY.val]), h2⟩

end MLIR.Firedancer.R52x5
