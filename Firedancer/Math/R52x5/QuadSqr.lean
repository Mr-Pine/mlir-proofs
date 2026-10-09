module

public import Firedancer.Math.R52x5.QuadMul
public import Firedancer.R52x5.fd_r52x5_quad_sqr_fast
import Firedancer.Math.Avx512.Mul
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Ring

/-! `fd_r52x5_quad_sqr_fast` in `ZMod p`: lane by lane, the square's 52-bit halves summed by
radix-`2^51` columns, off-diagonal ones doubled, then the fold of `fd_r52x5_quad_mul_fast`. -/

namespace MLIR.Firedancer.R52x5

open MLIR.Firedancer.Ref (p)
open Firedancer.Avx512 (madd52lo madd52hi)
open Firedancer.Avx512.R43x6 (madd52lo_lt madd52_split p_int)

/-! ## Columns -/

-- `ring` multiplies out `2^51` powers up to `2^408`
set_option exponentiation.threshold 512 in
/-- The columns of `X ^ 2`, `za + 19 zb`, are `X ^ 2` in `ZMod p`. -/
theorem quad_sqr_core {X : ℕ → ℕ} {L H : ℕ → ℕ → ℕ}
    (h : ∀ i j, i ≤ j → j < 5 → X i * X j = L i j + 2 ^ 52 * H i j) :
    ((limbs5 fun n => scol L H n + 19 * scol L H (n + 5) : ℕ) : ZMod p) =
      (limbs5 X : ZMod p) * limbs5 X := by
  have e : ∀ i j, i ≤ j → j < 5 → (X i : ℤ) * X j = L i j + 2 ^ 52 * H i j := fun i j hi hj => by
    exact_mod_cast h i j hi hj
  have hz :
    ((limbs5 fun n => scol L H n + 19 * scol L H (n + 5) : ℕ) : ℤ) +
        p * limbs5 (fun n => scol L H (n + 5)) =
      limbs5 X * limbs5 X := by
    simp only [limbs5, scol, Nat.reduceAdd]
    rw [p_int]
    push_cast
    linear_combination
      -(e 0 0 (by decide) (by decide) + 2 ^ 51 * 2 * e 0 1 (by decide) (by decide) +
          2 ^ 102 * (2 * e 0 2 (by decide) (by decide) + e 1 1 (by decide) (by decide)) +
          2 ^ 153 * (2 * e 0 3 (by decide) (by decide) + 2 * e 1 2 (by decide) (by decide)) +
          2 ^ 204 *
            (2 * e 0 4 (by decide) (by decide) + 2 * e 1 3 (by decide) (by decide) +
              e 2 2 (by decide) (by decide)) +
          2 ^ 255 * (2 * e 1 4 (by decide) (by decide) + 2 * e 2 3 (by decide) (by decide)) +
          2 ^ 306 * (2 * e 2 4 (by decide) (by decide) + e 3 3 (by decide) (by decide)) +
          2 ^ 357 * 2 * e 3 4 (by decide) (by decide) +
          2 ^ 408 * e 4 4 (by decide) (by decide))
  have := congrArg (Int.cast : ℤ → ZMod p) hz
  simpa only [Int.cast_add, Int.cast_mul, Int.cast_natCast, ZMod.natCast_self, zero_mul, add_zero,
    Nat.cast_mul] using this

/-! ## `fd_r52x5_quad_sqr_fast` -/

/-- `madd52lo`'s product, lane `j`, of limbs `i` and `k` of `X`. -/
def lsq (X : Quad5) (j : Fin 4) (i k : ℕ) : ℕ :=
  (madd52lo (X.laneN j i) (X.laneN j k)).toNat

/-- `madd52hi`'s product, lane `j`, of limbs `i` and `k` of `X`. -/
def hsq (X : Quad5) (j : Fin 4) (i k : ℕ) : ℕ :=
  (madd52hi (X.laneN j i) (X.laneN j k)).toNat

theorem wl_madd52hi_madd52lo (a b c d e : Wl) :
    wl_madd52hi (wl_madd52lo a b c) d e = wl_madd52lo (wl_madd52hi a d e) b c := by
  ext i hi : 1
  simp only [wl_madd52hi_getElem _ _ _ i hi, wl_madd52lo_getElem _ _ _ i hi]
  ac_rfl

/-- `fd_r52x5_quad_sqr_fast` as its columns, then `quadFold` (`z4_2`'s two fold terms the other
way round). -/
theorem quad_sqr_eq_fold (X : Quad5) :
    fd_r52x5_quad_sqr_fast.spec X =
      let x0 := X.P0
      let x1 := X.P1
      let x2 := X.P2
      let x3 := X.P3
      let x4 := X.P4
      let _zz := wl_zero
      let q1_2 := wl_madd52hi _zz x0 x0
      let q2_4 := wl_madd52hi _zz x0 x1
      let q3_2 := wl_madd52hi _zz x1 x1
      let q3_4 := wl_madd52hi _zz x0 x2
      let q5_2 := wl_madd52hi _zz x2 x2
      let q4_4 := wl_madd52hi (wl_madd52hi _zz x1 x2) x0 x3
      let q7_2 := wl_madd52hi _zz x3 x3
      let q5_4 := wl_madd52hi (wl_madd52hi _zz x1 x3) x0 x4
      let q9_2 := wl_madd52hi _zz x4 x4
      let q6_4 := wl_madd52hi (wl_madd52hi _zz x2 x3) x1 x4
      let q7_4 := wl_madd52hi _zz x2 x4
      let q8_4 := wl_madd52hi _zz x3 x4
      let z0_1 := wl_madd52lo _zz x0 x0
      let z1_1 := _zz
      let z1_2 := wl_madd52lo q1_2 x0 x1
      let z2_1 := wl_madd52lo (wl_shl q2_4 2) x1 x1
      let z2_2 := wl_madd52lo _zz x0 x2
      let z3_1 := wl_shl q3_4 2
      let z3_2 := wl_madd52lo (wl_madd52lo q3_2 x1 x2) x0 x3
      let z4_1 := wl_madd52lo (wl_shl q4_4 2) x2 x2
      let z4_2 := wl_madd52lo (wl_madd52lo _zz x1 x3) x0 x4
      let z5_1 := wl_shl q5_4 2
      let z5_2 := wl_madd52lo (wl_madd52lo q5_2 x2 x3) x1 x4
      let z6_1 := wl_madd52lo (wl_shl q6_4 2) x3 x3
      let z6_2 := wl_madd52lo _zz x2 x4
      let z7_1 := wl_shl q7_4 2
      let z7_2 := wl_madd52lo q7_2 x3 x4
      let z8_1 := wl_madd52lo (wl_shl q8_4 2) x4 x4
      let z9_1 := wl_shl q9_2 1
      let z5_1 := wl_add z5_1 (wl_shl z5_2 1)
      let z6_1 := wl_add z6_1 (wl_shl z6_2 1)
      let z7_1 := wl_add z7_1 (wl_shl z7_2 1)
      quadFold z0_1 z1_1 z2_1 z3_1 z4_1 z1_2 z2_2 z3_2 z4_2 z5_1 z6_1 z7_1 z8_1 z9_1 := by
  simp only [fd_r52x5_quad_sqr_fast.spec, quadFold, wl_madd52hi_madd52lo]

/-- A column of `fd_r52x5_quad_sqr_fast` in lane `j`: the lane operations, `toNat` with no
overflow. -/
local macro "sqr_col" : tactic =>
  `(tactic|
    ( simp only [Fin.getElem_fin, wl_madd52lo_getElem, wl_madd52hi_getElem, wl_add_getElem,
        wl_shl_getElem, Vector.getElem_replicate, scol, lsq, hsq, Quad5.laneN]
      madd_bounds
      simp only [BitVec.toNat_add, BitVec.toNat_shiftLeft, Nat.shiftLeft_eq,
        show BitVec.toNat (0 : BitVec 64) = 0 from rfl, Nat.zero_add]
      omega))

/-- `fd_r52x5_quad_sqr_fast` squares a `B(52)` QUAD lane by lane, limbs at most `2^56 - 2^52`
(`FD_R52X5_QUAD_NEGATE_LAZY`'s range). -/
public theorem fd_r52x5_quad_sqr_fast.spec_lane {X : Quad5} (hX : X.Below 52) (j : Fin 4) :
    (fd_r52x5_quad_sqr_fast.spec X).val j = X.val j ^ 2 ∧
      ∀ i, ((fd_r52x5_quad_sqr_fast.spec X).elem j i).toNat ≤ 2 ^ 56 - 2 ^ 52 := by
  have := hX j 0; have := hX j 1; have := hX j 2; have := hX j 3; have := hX j 4
  simp only [Quad5.elem_0, Quad5.elem_1, Quad5.elem_2, Quad5.elem_3, Quad5.elem_4,
    Fin.getElem_fin] at *
  rw [quad_sqr_eq_fold]
  refine
    quadFold_is (scol (lsq X j) (hsq X j)) (scol (lsq X j) (hsq X j)) (13 * 2 ^ 52) ?_ ?_ ?_ ?_ ?_
      ?_ ?_ ?_ ?_ ?_ (fun n hn => ?_) (by norm_num) ?_ (by norm_num)
  · sqr_col
  · sqr_col
  · sqr_col
  · sqr_col
  · sqr_col
  · sqr_col
  · sqr_col
  · sqr_col
  · sqr_col
  · sqr_col
  · match n, hn with
    | 0, _ | 1, _ | 2, _ | 3, _ | 4,
      _ =>
      simp only [Fin.getElem_fin, scol, lsq, hsq, Quad5.laneN]
      madd_bounds
      omega
  · rw [quad_sqr_core (L := lsq X j) (H := hsq X j) fun i k _ hk =>
        madd52_split (X.laneN_lt hX j (by omega)) (X.laneN_lt hX j hk),
      Quad5.val, Ref.Limbs.val_nat, Quad5.nat_elem, sq]

/-- `fd_r52x5_quad_sqr_fast` of a QUAD with limbs below `2^52`: the four squares, limbs at most
`2^56 - 2^52`. -/
public theorem fd_r52x5_quad_sqr_fast.spec_is {X : Quad5} (hX : X.Is v b) (hb : ∀ j, b j < 2 ^ 52) :
    (fd_r52x5_quad_sqr_fast.spec X).Is (fun j => v j ^ 2) (fun _ => 2 ^ 56 - 2 ^ 52) := by
  intro j
  obtain ⟨h1, h2⟩ := spec_lane (hX.below hb) j
  exact ⟨h1.trans (by rw [hX.val]), h2⟩

end MLIR.Firedancer.R52x5
