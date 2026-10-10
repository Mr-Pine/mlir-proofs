module

public import Ed25519.Firedancer
public import Ed25519.Decode
public import Ed25519.BasePoint
public import Ed25519.Group
public import Firedancer.Math.Curve
public import Firedancer.Math.Sha512
public import Firedancer.Math.Scalar
public import Firedancer.Math.Dsmb
public import Firedancer.Ref.fd_ed25519_verify
import Mathlib.Tactic.Abel
import Mathlib.Tactic.LinearCombination

/-! `fd_ed25519_verify` computes `Ed25519.Firedancer.verify`: `frombytes` fails and succeeds as
`decode` does, and the checks run in the spec's order. -/

namespace MLIR.Firedancer.Ref

open _root_.Ed25519

/-! ## Decoding -/

section Decode

/-- `frombytes` fails exactly when `decode` does. -/
public theorem fd_ed25519_point_frombytes.spec_eq_none_iff_decode (buf : BitVec 256) :
    fd_ed25519_point_frombytes.spec buf = none ↔ Ed25519.decode buf = none := by
  rw [fd_ed25519_point_frombytes.spec_eq_none_iff, Ed25519.decode_eq_none, ← not_exists,
    ← not_exists, Ed25519.exists_decodes_iff]

/-- A point `frombytes` returns is the one `decode` finds, affine, with the limb bounds the
callers need. -/
public theorem fd_ed25519_point_frombytes.spec_some_decode {buf : BitVec 256} {P : PointLimbs}
    (h : fd_ed25519_point_frombytes.spec buf = some P) :
    ∃ Q, Ed25519.decode buf = some Q ∧ P.Ext Q.x Q.y ∧ Limbs.val P.Z = 1 ∧ Limbs.Under2p P.X ∧
      Limbs.nat P.X < 2 * p ∧ Limbs.Tight P.Y ∧ Limbs.Tight P.T ∧ Limbs.Tight P.Z := by
  obtain ⟨x, he, hc, hpar, hz, hX, hXn, hY, hT, hZ⟩ := fd_ed25519_point_frombytes.spec_some h
  exact ⟨⟨x, _, hc⟩, Ed25519.decode_eq_some ⟨rfl, hpar⟩, he, hz, hX, hXn, hY, hT, hZ⟩

/-- An affine point's limbs hold its coordinates. -/
theorem PointLimbs.ext_val_xy {P : PointLimbs} {x y : ZMod p} (h : P.Ext x y)
    (hz : Limbs.val P.Z = 1) : Limbs.val P.X = x ∧ Limbs.val P.Y = y := by
  obtain ⟨-, hx, hy, -⟩ := h
  exact ⟨by rw [hx, hz, mul_one], by rw [hy, hz, mul_one]⟩

/-- `is_small_order` on a decoded point decides `8 P = 0`. -/
theorem fd_ed25519_affine_is_small_order.spec_decoded {P : PointLimbs} {Q : Ed25519.Point}
    (he : P.Ext Q.x Q.y) (hz : Limbs.val P.Z = 1) (hX : Limbs.Under2p P.X)
    (hXn : Limbs.nat P.X < 2 * p) (hY : Limbs.Tight P.Y) :
    fd_ed25519_affine_is_small_order.spec P = if 8 • Q = 0 then 1#32 else 0#32 := by
  obtain ⟨vx, vy⟩ := PointLimbs.ext_val_xy he hz
  rw [fd_ed25519_affine_is_small_order.spec_val hX hXn hY (by rw [vx, vy]; exact Q.on), vx, vy]
  exact if_congr (Ed25519.Point.smallOrder_iff_nsmul Q) rfl rfl

end Decode

/-! ## Verification -/

section Verify

open fd_ed25519_double_scalar_mul_base in
/-- `fd_ed25519_verify`'s return code, on the base point's table, is
`Ed25519.Firedancer.verify`'s. -/
public theorem fd_ed25519_verify.spec_ret (msgSz : BitVec 64) (msg : BitVec (8 * msgSz.toNat))
    (r S A : BitVec 256) (buf0 : BitVec 1024) :
    (fd_ed25519_verify.spec baseTbl msgSz msg r S A buf0).ret =
      Ed25519.Firedancer.verify (bytesLE msg) r S A := by
  have hval := fd_curve25519_scalar_validate.spec_iff S
  -- the table stays opaque: unfolded, the kernel would evaluate its 20 KB literal
  generalize hT : baseTbl = tbl
  -- by the equations: unfolding under `.ret` by defeq makes the kernel evaluate `validate S`
  rw [fd_ed25519_verify.spec, Ed25519.Firedancer.verify]
  by_cases hS : Ed25519.ell ≤ S.toNat
  · have : fd_curve25519_scalar_validate.spec S = false := by
      cases h : fd_curve25519_scalar_validate.spec S
      · rfl
      · exact absurd (hval.1 h) (Nat.not_lt.2 hS)
    rw [ite_eq_left (by rw [this]; rfl), ite_eq_left hS]
  have hv : fd_curve25519_scalar_validate.spec S = true := hval.2 (Nat.lt_of_not_le hS)
  have hSl : S.toNat < Ed25519.ell := Nat.lt_of_not_le hS
  -- `rw`, not `simp`: changing the `if`'s condition re-checks its instance, `validate S` unfolded
  rw [ite_eq_right (by rw [hv]; decide), ite_eq_right hS]
  -- both decodings as constructors, so the `match`es reduce without evaluating `frombytes`
  rcases hAo : fd_ed25519_point_frombytes.spec A with _ | Ap <;>
    rcases hRo : fd_ed25519_point_frombytes.spec r with _ | Rp
  · have hres : fd_ed25519_point_frombytes_2x.spec A r = -1#32 := by
      rw [fd_ed25519_point_frombytes_2x.spec, hAo]; rfl
    rw [(fd_ed25519_point_frombytes.spec_eq_none_iff_decode A).1 hAo, hres]
    rfl
  · have hres : fd_ed25519_point_frombytes_2x.spec A r = -1#32 := by
      rw [fd_ed25519_point_frombytes_2x.spec, hAo]; rfl
    rw [(fd_ed25519_point_frombytes.spec_eq_none_iff_decode A).1 hAo, hres]
    rfl
  · have hres : fd_ed25519_point_frombytes_2x.spec A r = -2#32 := by
      rw [fd_ed25519_point_frombytes_2x.spec, hAo, hRo]; rfl
    obtain ⟨PA, hdA, -⟩ := fd_ed25519_point_frombytes.spec_some_decode hAo
    rw [hdA, (fd_ed25519_point_frombytes.spec_eq_none_iff_decode r).1 hRo, hres]
    rfl
  obtain ⟨PA, hdA, heA, hzA, hXA, hXnA, hYA, hTA, hZA⟩ :=
    fd_ed25519_point_frombytes.spec_some_decode hAo
  obtain ⟨PR, hdR, heR, hzR, hXR, hXnR, hYR, hTR, hZR⟩ :=
    fd_ed25519_point_frombytes.spec_some_decode hRo
  rw [hdA, hdR]
  dsimp only
  rw [fd_ed25519_affine_is_small_order.spec_decoded heA hzA hXA hXnA hYA,
    fd_ed25519_affine_is_small_order.spec_decoded heR hzR hXR hXnR hYR]
  by_cases h8A : 8 • PA = 0
  · rw [ite_eq_left h8A, ite_eq_left (by decide), ite_eq_left h8A]
  rw [ite_eq_right h8A, ite_eq_right (by decide), ite_eq_right h8A]
  by_cases h8R : 8 • PR = 0
  · rw [ite_eq_left h8R, ite_eq_left (by decide), ite_eq_left h8R]
  rw [ite_eq_right h8R, ite_eq_right (by decide), ite_eq_right h8R]
  -- the hash, reduced
  have hd := fd_ed25519_verify.hash_eq buf0 r A msgSz msg
  generalize fd_ed25519_verify.hash buf0 r A msgSz msg = H at hd ⊢
  obtain ⟨sha4, kw⟩ := H
  have hk : (fd_curve25519_scalar_reduce.spec (Words8.bits kw)).toNat =
      Ed25519.natLE (Sha512.digest (bytesLE r ++ bytesLE A ++ bytesLE msg)) % Ed25519.ell := by
    rw [fd_curve25519_scalar_reduce.spec_val, ← hd, Ed25519.natLE_bytesLE (n := 64)]
  generalize fd_curve25519_scalar_reduce.spec (Words8.bits kw) = k at hk ⊢
  have hkl : k.toNat < 2 ^ 255 := by
    have := Nat.mod_lt (Ed25519.natLE (Sha512.digest (bytesLE r ++ bytesLE A ++ bytesLE msg)))
      (show 0 < Ed25519.ell by unfold Ed25519.ell; decide)
    have := Ed25519.ell_lt
    omega
  -- `-A'`, then `k (-A') + S B`
  obtain ⟨heN, bXN, bTN⟩ := fd_ed25519_point_neg.spec_ext heA hXA hTA.under2p
  obtain ⟨heQ, bQ⟩ := fd_ed25519_double_scalar_mul_base.spec_val_base (-PA)
    (A := fd_ed25519_point_neg.spec Ap) (n1 := k) (n2 := S) heN bXN hYA bTN hZA hzA hkl
    (by have := Ed25519.ell_lt; omega)
  rw [hT] at heQ bQ
  rw [fd_ed25519_verify_equation.spec,
    fd_ed25519_point_eq_z1.spec_val ⟨heQ.1, heQ.2.1, heQ.2.2.1⟩ bQ.1 bQ.2.1 bQ.2.2.2.loose
      hXR.loose hYR.loose]
  obtain ⟨vx, vy⟩ := PointLimbs.ext_val_xy heR hzR
  rw [vx, vy, hk]
  generalize Ed25519.natLE (Sha512.digest (bytesLE r ++ bytesLE A ++ bytesLE msg)) % Ed25519.ell = n
  have key : (PR.x = (n • -PA + S.toNat • Ed25519.basePoint).x ∧
      PR.y = (n • -PA + S.toNat • Ed25519.basePoint).y) ↔
      S.toNat • Ed25519.basePoint = PR + n • PA := by
    rw [← Ed25519.Point.ext_iff, smul_neg]
    constructor <;> intro h
    · rw [h]; abel
    · rw [← sub_eq_iff_eq_add.2 h]; abel
  by_cases hq : S.toNat • Ed25519.basePoint = PR + n • PA
  · rw [ite_eq_left (key.2 hq), ite_eq_right (by decide), ite_eq_left hq]
  · rw [ite_eq_right (mt key.1 hq), ite_eq_left rfl, ite_eq_right hq]

end Verify

end MLIR.Firedancer.Ref
