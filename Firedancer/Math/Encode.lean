module

public import Ed25519.Encode
public import Firedancer.Math.Curve
public import Firedancer.Math.Inv
public import Firedancer.Ref.fd_ed25519_point_tobytes
import Mathlib.Tactic.NormNum
import Std.Tactic.BVDecide

/-! `fd_ed25519_point_tobytes`, with the ref and the s2n inverse: the RFC 8032 encoding of the point
its limbs represent. -/

namespace MLIR.Firedancer.Ref

open _root_.Ed25519

/-- Setting bit 255 of a number below `2^255` to `b` adds `2^255 b`. -/
theorem xor_sign_bit {out : BitVec 256} (h : out.toNat < 2 ^ 255) {b : ℕ} (hb : b < 2) :
    out ^^^ (((BitVec.ofNat 32 b <<< 7).setWidth 8).setWidth 256 <<< 248) =
      BitVec.ofNat 256 (out.toNat + 2 ^ 255 * b) := by
  have hlt : out < BitVec.ofNat 256 (2 ^ 255) := by
    rw [BitVec.lt_def, BitVec.toNat_ofNat]
    exact h.trans_le (by norm_num)
  have e : BitVec.ofNat 256 (out.toNat + 2 ^ 255 * b) = out + BitVec.ofNat 256 (2 ^ 255 * b) := by
    apply BitVec.eq_of_toNat_eq
    simp only [BitVec.toNat_ofNat, BitVec.toNat_add, Nat.add_mod_mod]
  rw [e]
  rcases (by omega : b = 0 ∨ b = 1) with rfl | rfl
  · rw [Nat.mul_zero]
    bv_decide
  · rw [Nat.mul_one]
    bv_decide

/-- `tobytes` with an inverse that inverts `A.Z` into loose limbs: `P`'s encoding, for `A` a
representative of `P` with `X`, `Y` loose. -/
public theorem fd_ed25519_point_tobytes.withInv_eq {inv : (Fin 5 → BitVec 64) → Fin 5 → BitVec 64}
    {A : PointLimbs} {P : Ed25519.Point} (hA : A.Ext P.x P.y) (hX : Limbs.Loose A.X)
    (hY : Limbs.Loose A.Y)
    (hinv : Limbs.val (inv A.Z) = (Limbs.val A.Z)⁻¹ ∧ Limbs.Loose (inv A.Z)) :
    fd_ed25519_point_tobytes.withInv inv A = Ed25519.encode P := by
  obtain ⟨hz, ex, ey, -⟩ := hA
  obtain ⟨vi, bi⟩ := hinv
  obtain ⟨vx, bx⟩ := fd_f25519_mul.spec_val hX bi
  obtain ⟨vy, by'⟩ := fd_f25519_mul.spec_val hY bi
  rw [vi, ex, mul_inv_cancel_right₀ hz] at vx
  rw [vi, ey, mul_inv_cancel_right₀ hz] at vy
  have ho := fd_f25519_tobytes.spec_val by'.under2p by'.nat_lt
  rw [vy] at ho
  unfold fd_ed25519_point_tobytes.withInv
  dsimp only
  rw [fd_f25519_sgn.spec_val bx.under2p bx.nat_lt, vx,
    xor_sign_bit (ho ▸ (ZMod.val_lt P.y).trans (by norm_num)) (Nat.mod_lt _ (by norm_num)), ho]
  rfl

/-- The ref `tobytes` (no s2n) on a representative of `P`, `X`, `Y`, `Z` loose: `P`'s encoding. -/
public theorem fd_ed25519_point_tobytes.spec_eq {A : PointLimbs} {P : Ed25519.Point}
    (hA : A.Ext P.x P.y) (hX : Limbs.Loose A.X) (hY : Limbs.Loose A.Y) (hZ : Limbs.Loose A.Z) :
    fd_ed25519_point_tobytes.spec A = Ed25519.encode P := by
  obtain ⟨v, t⟩ := fd_f25519_inv.spec_val hZ
  exact fd_ed25519_point_tobytes.withInv_eq hA hX hY ⟨v, t.loose⟩

/-- The s2n `tobytes` (deployed x86-64/arm) on a representative of `P`, `X`, `Y` loose, `Z` tight:
`P`'s encoding. -/
public theorem fd_ed25519_point_tobytes.s2n_eq {A : PointLimbs} {P : Ed25519.Point}
    (hA : A.Ext P.x P.y) (hX : Limbs.Loose A.X) (hY : Limbs.Loose A.Y) (hZ : Limbs.Tight A.Z) :
    fd_ed25519_point_tobytes.s2n A = Ed25519.encode P := by
  obtain ⟨v, t⟩ := fd_f25519_inv.s2n_val hZ
  exact fd_ed25519_point_tobytes.withInv_eq hA hX hY ⟨v, t.loose⟩

end MLIR.Firedancer.Ref
