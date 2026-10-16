module

import all Firedancer.Math.Dsmb
public import Firedancer.Math.Dsmb
public import Firedancer.Math.GroupOps
public import Firedancer.Ref.fd_ed25519_scalar_mul
import Mathlib.Tactic.Module

/-! `fd_ed25519_scalar_mul` computes `n P` (`n` without bit 255) for an affine `P`: the ladder of
`double_scalar_mul_base` with only `A`'s digits. -/

namespace MLIR.Firedancer.Ref

open _root_.Ed25519 fd_ed25519_double_scalar_mul_base

namespace fd_ed25519_scalar_mul

/-- The main loop from `i` on `r`, `R`: `2^(i+1) R` plus the digits up to `i`. -/
theorem ladder_ext {ai : ℕ → PointLimbs} {PA : Ed25519.Point} {w : Vector Int 256}
    (hai : ∀ k < 8, Opnd (ai k) 0#32 ((2 * k + 1) • PA)) (hai0 : Limbs.val (ai 0).Z = 1)
    (hw : ∀ k (hk : k < 256), (w[k] = 0 ∨ Odd w[k]) ∧ w[k].natAbs ≤ 15) :
    ∀ i (h : i < 256) {r : PointLimbs} {R : Ed25519.Point},
      ProjT r R → ExtT (ladder ai w i h r) ((2 ^ (i + 1) : ℤ) • R + low w (i + 1) • PA)
  | 0, h, r, R, hr => by
    rw [ladder]
    obtain ⟨hc, bX, bY, bT, bZ⟩ := add1_compl hr hai hai0 (hw 0 h)
    refine ExtT.congr (fd_ed25519_point_add_final_mul.spec_ext hc bX bY bT bZ) ?_
    rw [low_succ w h]
    simp only [low, Finset.range_zero, Finset.sum_empty]
    module
  | i + 1, h, r, R, hr => by
    rw [ladder]
    obtain ⟨hc, bX, bY, bT, bZ⟩ := add1_compl hr hai hai0 (hw (i + 1) h)
    obtain ⟨hp, pX, pY, pZ⟩ :=
      fd_ed25519_point_add_final_mul_projective.spec_proj hc bX bY bT bZ (add1 ai w[i + 1] r).1.T
    have := ladder_ext hai hai0 hw i (by omega) ⟨hp, pX.under2p, pY, pZ.loose⟩
    refine ExtT.congr this ?_
    rw [low_succ w h]
    module

/-- `start` stops at `j`: the digits above it, up to `i`, are zero. -/
theorem start_some {w : Vector Int 256} :
    ∀ i (h : i < 256) {j : Fin 256},
      start w i h = some j → ∀ k (hk : k < 256), j.val < k → k ≤ i → w[k] = 0
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

end fd_ed25519_scalar_mul

/-- The wNAF reads only bits `0..254`. -/
public theorem fd_curve25519_scalar_wnaf.wnaf_mod (x : BitVec 256) (bits : ℕ) :
    fd_curve25519_scalar_wnaf.wnaf x bits =
      fd_curve25519_scalar_wnaf.wnaf ((x.setWidth 255).setWidth 256) bits := by
  unfold fd_curve25519_scalar_wnaf.wnaf fd_curve25519_scalar_wnaf.n0
  rw [BitVec.setWidth_setWidth_of_le (x.setWidth 255) (show 255 ≤ 256 by decide),
    BitVec.setWidth_eq]

/-- `fd_ed25519_scalar_mul` on a representative of `P` with `Z = 1`: `(n mod 2^255) P`, tight. -/
public theorem fd_ed25519_scalar_mul.spec_ext {A : PointLimbs} {P : Ed25519.Point} (hA : A.Rep P)
    (hZ1 : Limbs.val A.Z = 1) (n : BitVec 256) :
    let R := fd_ed25519_scalar_mul.spec n A
    let Q := (n.toNat % 2 ^ 255) • P
    R.Ext Q.x Q.y ∧ R.Tight := by
  show ExtT _ _
  obtain ⟨hE, hAX, hAY, hAT, hAZ⟩ := hA
  obtain ⟨hai0, hai⟩ := aiTable_opnd hE hAX hAY hAT.under2p hAZ hZ1
  have hn : ((n.setWidth 255).setWidth 256).toNat = n.toNat % 2 ^ 255 := by
    simp only [BitVec.toNat_setWidth]
    exact Nat.mod_eq_of_lt ((Nat.mod_lt _ (by decide)).trans (by decide))
  have hw (k) (hk : k < 256) := (fd_curve25519_scalar_wnaf.wnaf4_digit n hk).imp_right And.left
  have s :=
    fd_curve25519_scalar_wnaf.wnaf_sum ((n.setWidth 255).setWidth 256) (bits := 4) (by decide)
      (hn ▸ Nat.mod_lt _ (by decide))
  rw [← fd_curve25519_scalar_wnaf.wnaf_mod, hn, ← low_256] at s
  rw [← natCast_zsmul, ← s]
  unfold fd_ed25519_scalar_mul.spec
  dsimp only
  generalize fd_curve25519_scalar_wnaf.wnaf n 4 = w at *
  generalize aiTable _ _ = ai at *
  split
  · rename_i i hs
    have hz : ∀ k (hk : k < 256), i.val + 1 ≤ k → w[k] = 0 := fun k hk hik =>
      fd_ed25519_scalar_mul.start_some 255 (by decide) hs k hk (by omega) (by omega)
    have e := low_add hz (255 - i.val) (by omega)
    rw [show i.val + 1 + (255 - i.val) = 256 by omega] at e
    obtain ⟨hZ, bZ⟩ := fd_ed25519_point_set_zero.spec_ext
    refine
      ExtT.congr
        (fd_ed25519_scalar_mul.ladder_ext (fun k _ => hai k) hai0 hw i i.isLt (R := 0)
          ⟨⟨hZ.1, hZ.2.1, hZ.2.2.1⟩, bZ.1.under2p, bZ.2.1, bZ.2.2.2.loose⟩)
        ?_
    rw [e, smul_zero, zero_add]
  · rename_i hs
    have hz : ∀ k (hk : k < 256), 0 ≤ k → w[k] = 0 := fun k hk _ =>
      fd_ed25519_scalar_mul.start_none 255 (by decide) hs k hk (by omega)
    have e := low_add hz 256 (by omega)
    simp only [Nat.zero_add] at e
    rw [e]
    simp only [low, Finset.range_zero, Finset.sum_empty, zero_smul]
    exact fd_ed25519_point_set_zero.spec_ext

/-- `fd_ed25519_scalar_mul` represents `(n mod 2^255) P`. -/
public theorem fd_ed25519_scalar_mul.rep {A : PointLimbs} {P : Ed25519.Point} (hA : A.Rep P)
    (hZ1 : Limbs.val A.Z = 1) (n : BitVec 256) :
    (fd_ed25519_scalar_mul.spec n A).Rep ((n.toNat % 2 ^ 255) • P) :=
  .of_tight (fd_ed25519_scalar_mul.spec_ext hA hZ1 n).1 (fd_ed25519_scalar_mul.spec_ext hA hZ1 n).2

/-- For `n < 2^255` (every validated scalar, `n < ℓ`): `n P`. -/
public theorem fd_ed25519_scalar_mul.rep_of_lt {A : PointLimbs} {P : Ed25519.Point} (hA : A.Rep P)
    (hZ1 : Limbs.val A.Z = 1) {n : BitVec 256} (hn : n.toNat < 2 ^ 255) :
    (fd_ed25519_scalar_mul.spec n A).Rep (n.toNat • P) := by
  have := fd_ed25519_scalar_mul.rep hA hZ1 n
  rwa [Nat.mod_eq_of_lt hn] at this

end MLIR.Firedancer.Ref
