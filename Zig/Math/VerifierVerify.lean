module

public import Ed25519.Group
public import Ed25519.BasePoint
public import Ed25519.Order
public import Ed25519.Decode
public import Zig.Math.Point
public import Zig.Math.PointDbl
public import Zig.Math.Identity
public import Zig.Math.MulDoubleBasePublic
public import Zig.Verifier_verify
import Mathlib.Tactic.Abel

/-! `Verifier.verify`'s code on the curve: `WeakPublicKey` (`4`) when `32 A` has `x = 0`, else `0`
exactly when `8 [S]B = 8 R + 8 [k]A`, `k` the digest mod `ℓ`, else `5`. -/

namespace MLIR.Zig

open _root_.Ed25519

namespace Verifier.verify

/-- Bytes as a little-endian number are below `2^(8 n)`. -/
theorem natLE_lt : ∀ l : List (BitVec 8), natLE l < 2 ^ (8 * l.length)
  | [] => by simp [natLE]
  | b :: l => by
    have h1 := natLE_lt l
    have h2 := b.isLt
    simp only [natLE, List.length_cons]
    rw [show 8 * (l.length + 1) = 8 + 8 * l.length by omega, Nat.pow_add]
    generalize 2 ^ (8 * l.length) = X at *
    omega

/-- SHA-512's digest is 64 bytes. -/
theorem digest_length (M : List (BitVec 8)) : (Sha512.digest M).length = 64 := by
  simp [Sha512.digest, Sha512.bytesBE, List.length_flatMap]

set_option exponentiation.threshold 512 in
/-- `reduce64` of the digest's bytes: the digest mod `ℓ`. -/
theorem reduce64_toNat (M : List (BitVec 8)) :
    (reduce64 (digestBits M)).toNat = natLE (Sha512.digest M) % ell := by
  have h := natLE_lt (Sha512.digest M)
  rw [digest_length] at h
  have hl : ell < 2 ^ 256 := Ed25519.ell_lt.trans (by norm_num)
  rw [reduce64, digestBits, BitVec.toNat_ofNat, BitVec.toNat_ofNat, Nat.mod_eq_of_lt h]
  exact
    Nat.mod_eq_of_lt
      ((Nat.mod_lt _
            (by
              unfold ell; norm_num)).trans
        hl)

/-- `(n mod ℓ) B = n B`. -/
theorem mod_ell_smul (n : ℕ) : (n % ell) • basePoint = n • basePoint := by
  conv_rhs => rw [← Nat.mod_add_div n ell]
  rw [add_smul, mul_comm, mul_smul, Ed25519.ell_smul_basePoint, smul_zero, add_zero]

/-- `4 (-(8 A))` has `x = 0` iff `32 A` does. -/
theorem four_neg_eight (A : Point) : ((4 : ℕ) • -((8 : ℕ) • A)).x = 0 ↔ ((32 : ℕ) • A).x = 0 := by
  rw [smul_neg, smul_smul, Point.neg_x, neg_eq_zero, show (4 : ℕ) * 8 = 32 from rfl]

/-- `Verifier.verify`'s code, for `Pa`, `Pr` representing `A`, `R` with limbs below `2^53`, `sb`
the scalar's bytes and `M` the bytes hashed. -/
public theorem code_eq {A R : Point} {Pa Pr : ZPt} (hA : Pa.Ext A.x A.y) (hAb : Pa.Lt (2 ^ 53))
    (hR : Pr.Ext R.x R.y) (hRb : Pr.Lt (2 ^ 53)) (sb : BitVec 256) (M : List (BitVec 8)) :
    code M sb Pa Pr =
      if (32 • A).x = 0 then 4#16
      else
        if 8 • (sb.toNat • basePoint) = 8 • R + 8 • ((natLE (Sha512.digest M) % ell) • A) then 0#16
        else 5#16 := by
  obtain ⟨e8, l8⟩ := Edwards25519.clearCofactor.spec_point hA hAb.1 hAb.2.1 hAb.2.2.1
  have eN : (negA Pa).Ext (-(8 • A)).x (-(8 • A)).y :=
    Edwards25519.neg.spec_point e8 (l8.1.mono (by norm_num)) (l8.2.2.2.mono (by norm_num))
  have hm1 : (scalar.mul8.spec sb).msb = false :=
    msb_of_lt_ell
      (by
        rw [scalar.mul8.toNat_spec];
        exact
          Nat.mod_lt _
            (by
              unfold ell; norm_num))
  have hm2 : (reduce64 (digestBits M)).msb = false :=
    msb_of_lt_ell
      (by
        rw [reduce64_toNat];
        exact
          Nat.mod_lt _
            (by
              unfold ell; norm_num))
  obtain ⟨hnone, hsome⟩ :=
    Edwards25519.mulDoubleBasePublic.spec_point _ _ hm1 hm2 (b := 0#1) (by decide) eN (negA_lt Pa)
  rw [code]
  rcases hr : sbAh M sb Pa with _ | Q
  · rw [sbAh] at hr
    have h32 : (32 • A).x = 0 := (four_neg_eight A).1 (hnone.1 hr)
    simp only [codeOf, h32, ite_true]
  · rw [sbAh] at hr
    have h32 : (32 • A).x ≠ 0 := fun h => by
      have := hnone.2 ((four_neg_eight A).2 h)
      rw [hr] at this
      cases this
    obtain ⟨eQ, lQ⟩ := hsome Q hr
    obtain ⟨eR8, lR8⟩ := Edwards25519.clearCofactor.spec_point hR hRb.1 hRb.2.1 hRb.2.2.1
    obtain ⟨eC, lC⟩ := Edwards25519.sub.spec_point eQ eR8 lQ (ZPt.Lt.mono53 lR8)
    have key :
      (scalar.mul8.spec sb).toNat • basePoint + (reduce64 (digestBits M)).toNat • -(8 • A) - 8 • R =
          0 ↔
        8 • (sb.toNat • basePoint) = 8 • R + 8 • ((natLE (Sha512.digest M) % ell) • A) := by
      rw [scalar.mul8.toNat_spec, reduce64_toNat, mod_ell_smul, mul_smul, smul_neg, smul_comm _ 8, ←
        sub_eq_add_neg, sub_sub, sub_eq_zero, add_comm (8 • R)]
    simp only [codeOf, h32, ite_false, check,
      Verifier.isIdentity.spec_point eC (lC.1.mono (by norm_num)) (lC.2.1.mono (by norm_num))
          (lC.2.2.1.mono (by norm_num)),
      key]
