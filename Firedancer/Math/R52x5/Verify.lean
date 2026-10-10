module

public import Firedancer.Math.R52x5.Decode
public import Firedancer.Math.R52x5.Dsmb
public import Firedancer.Math.Verify
public import Firedancer.R52x5.fd_ed25519_verify
import Mathlib.Tactic.Abel

/-! The R52x5 `fd_ed25519_verify` computes `Ed25519.Firedancer.verify`, as Ref's does. -/

namespace MLIR.Firedancer.R52x5

open Firedancer.Ref
open _root_.Ed25519 (decode bytesLE)

/-- `fd_ed25519_verify`'s return code, on the base point's table, is
`Ed25519.Firedancer.verify`'s. -/
public theorem fd_ed25519_verify.spec_ret (msgSz : BitVec 64) (msg : BitVec (8 * msgSz.toNat))
    (r S A : BitVec 256) (buf0 : BitVec 1024) :
    (fd_ed25519_verify.spec fd_ed25519_base_point_wnaf_table.point msgSz msg r S A buf0).ret =
      Ed25519.Firedancer.verify (bytesLE msg) r S A := by
  have hval := fd_curve25519_scalar_validate.spec_iff S
  -- the table stays opaque: unfolded, the kernel would evaluate its literal
  generalize hT : fd_ed25519_base_point_wnaf_table.point = tbl
  -- by the equations: unfolding under `.ret` by defeq makes the kernel evaluate `validate S`
  rw [fd_ed25519_verify.spec, Ed25519.Firedancer.verify]
  by_cases hS : Ed25519.ell ≤ S.toNat
  · have : fd_curve25519_scalar_validate.spec S = false := by
      cases h : fd_curve25519_scalar_validate.spec S
      · rfl
      · exact absurd (hval.1 h) (Nat.not_lt.2 hS)
    rw [ite_eq_left (by rw [this]; rfl), ite_eq_left hS]
  have hv : fd_curve25519_scalar_validate.spec S = true := hval.2 (Nat.lt_of_not_le hS)
  -- `rw`, not `simp`: changing the `if`'s condition re-checks its instance, `validate S` unfolded
  rw [ite_eq_right (by rw [hv]; decide), ite_eq_right hS]
  obtain ⟨hnA, hnR, hok⟩ := fd_ed25519_point_frombytes_2x.spec_decode A r
  -- both decodings as constructors, so the `match`es reduce without evaluating `decode`
  rcases hdA : decode A with _ | PA
  · rw [hnA hdA]
    rfl
  rcases hdR : decode r with _ | PR
  · rw [hnR PA hdA hdR]
    rfl
  obtain ⟨Ap, Rp, hR, hAa, hAf, hRa, hRf⟩ := hok PA PR hdA hdR
  rw [hR]
  dsimp only
  rw [ite_eq_right (by decide), Option.getD_some,
    fd_ed25519_affine_is_small_order.spec_point hAa hAf,
    fd_ed25519_affine_is_small_order.spec_point hRa hRf]
  by_cases h8A : 8 • PA = 0
  · rw [ite_eq_left h8A, ite_eq_left (by decide), ite_eq_left h8A]
  rw [ite_eq_right h8A, ite_eq_right (by decide), ite_eq_right h8A]
  by_cases h8R : 8 • PR = 0
  · rw [ite_eq_left h8R, ite_eq_left (by decide), ite_eq_left h8R]
  rw [ite_eq_right h8R, ite_eq_right (by decide), ite_eq_right h8R]
  -- the hash, reduced
  have hd := Ref.fd_ed25519_verify.hash_eq buf0 r A msgSz msg
  generalize Firedancer.fd_ed25519_verify.hash buf0 r A msgSz msg = H at hd ⊢
  obtain ⟨sha4, kw⟩ := H
  have hk :
    (fd_curve25519_scalar_reduce.spec (Words8.bits kw)).toNat =
      Ed25519.natLE (Ed25519.Sha512.digest (bytesLE r ++ bytesLE A ++ bytesLE msg)) %
        Ed25519.ell := by
    rw [fd_curve25519_scalar_reduce.spec_val, ← hd, Ed25519.natLE_bytesLE (n := 64)]
  generalize fd_curve25519_scalar_reduce.spec (Words8.bits kw) = k at hk ⊢
  have hkl : k.toNat < 2 ^ 255 := by
    have :=
      Nat.mod_lt (Ed25519.natLE (Ed25519.Sha512.digest (bytesLE r ++ bytesLE A ++ bytesLE msg)))
        (show 0 < Ed25519.ell by
          unfold Ed25519.ell; decide)
    have := Ed25519.ell_lt
    omega
  -- `-A'`, then `k (-A') + S B`
  obtain ⟨heN, bN⟩ := fd_ed25519_point_neg.spec_ext hAa.ext hAf
  obtain ⟨heQ, bQ⟩ := fd_ed25519_double_scalar_mul_base.spec_val_base (-PA)
    (A := fd_ed25519_point_neg.spec Ap) (n1 := k) (n2 := S) heN bN hkl
    (by have := Ed25519.ell_lt; omega)
  rw [hT] at heQ bQ
  rw [fd_ed25519_point_affine_eq.spec_point heQ.proj hRa.ext.proj bQ hRf, hk]
  generalize
    Ed25519.natLE (Ed25519.Sha512.digest (bytesLE r ++ bytesLE A ++ bytesLE msg)) % Ed25519.ell = n
  have key :
    n • -PA + S.toNat • Ed25519.basePoint = PR ↔ S.toNat • Ed25519.basePoint = PR + n • PA := by
    rw [smul_neg]
    constructor <;> intro h
    · rw [← h]; abel
    · rw [h]; abel
  by_cases hq : S.toNat • Ed25519.basePoint = PR + n • PA
  · rw [ite_eq_left (key.2 hq), ite_eq_right (by decide), ite_eq_left hq]
  · rw [ite_eq_right (mt key.1 hq), ite_eq_left (by decide), ite_eq_right hq]

end MLIR.Firedancer.R52x5
