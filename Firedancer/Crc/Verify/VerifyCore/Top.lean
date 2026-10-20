module

public import Firedancer.Crc.Verify.VerifyCore.Verify
public import Firedancer.Math.R52x5.Equal
public import Firedancer.Math.R52x5.Dsmb
public import Firedancer.Math.Verify
import Mathlib.Tactic.Abel

namespace MLIR.Firedancer.Crc.Verify

open MLIR.Firedancer.R52x5
open _root_.Ed25519 (decode bytesLE)

@[expose] public section

/-- `fd_r52x5_ge_decode2` decodes as `decode` does: lane 0 is `sa`, lane 1 is `sb`; a failed lane
0 leaves the low bit clear, a failed lane 1 alone sets it; both decoded give the affine points,
reduced. -/
def DecodeSpec : Prop :=
  ∀ sa sb : BitVec 256,
    let D := fd_r52x5_ge_decode2.spec sa sb
    (decode sa = none → D.2 = none ∧ D.1 &&& 1#32 = 0#32) ∧
      (∀ P, decode sa = some P → decode sb = none → D.2 = none ∧ D.1 &&& 1#32 ≠ 0#32) ∧
      ∀ P Q, decode sa = some P → decode sb = some Q →
        ∃ A B, D.2 = some (A, B) ∧ A.Affine P.x P.y ∧ A.Below 52 ∧ B.Affine Q.x Q.y ∧ B.Below 52

/-- `fd_r52x5_ge_is_small_order_affine` on an affine point, reduced: nonzero exactly when
`8 P = 0`. -/
def SmallOrderSpec : Prop :=
  ∀ (A : Quad5) (P : Ed25519.Point), A.Affine P.x P.y → A.Below 52 →
    (fd_r52x5_ge_is_small_order_affine.spec A = 0#32 ↔ ¬8 • P = 0)

/-- The equation check: `fd_r52x5_ge_eq_z1` of `[k](-A) + [S]B` (A's negation by the lane blend,
`B` from the table `TB`) against `R`, for affine reduced `A`, `R` and scalars at most `2^253`:
nonzero exactly when the sum is `R`. -/
def EquationSpec (TB : Nat → Quad5) : Prop :=
  ∀ (A R : Quad5) (PA PR : Ed25519.Point) (k S : BitVec 256),
    A.Affine PA.x PA.y → A.Below 52 → R.Affine PR.x PR.y → R.Below 52 →
    k.toNat ≤ 2 ^ 253 → S.toNat ≤ 2 ^ 253 →
    (fd_r52x5_ge_eq_z1.spec
        (fd_r52x5_double_scalar_mul_base.spec TB k (Quad5.laneIf 1 0 0 1 (fd_r52x5_quad_neg.spec A) A) S)
        R = 0#32 ↔ k.toNat • -PA + S.toNat • Ed25519.basePoint ≠ PR)

end

/-- crc's `fd_ed25519_verify` returns `Ed25519.Firedancer.verify`'s code, given the decoder, the
small-order check and the equation check computing their mathematical counterparts. -/
public theorem fd_ed25519_verify.spec_ret_of (TB : Nat → Quad5) (hdec : DecodeSpec)
    (hso : SmallOrderSpec) (heq : EquationSpec TB) (msgSz : BitVec 64)
    (msg : BitVec (8 * msgSz.toNat)) (r S A : BitVec 256) (buf0 : BitVec 1024) :
    (fd_ed25519_verify.spec TB msgSz msg r S A buf0).ret =
      Ed25519.Firedancer.verify (bytesLE msg) r S A := by
  have hval := Ref.fd_curve25519_scalar_validate.spec_iff S
  rw [fd_ed25519_verify.spec, Ed25519.Firedancer.verify]
  dsimp only
  rw [fd_r52x5_verify_core.spec]
  by_cases hS : Ed25519.ell ≤ S.toNat
  · have : Ref.fd_curve25519_scalar_validate.spec S = false := by
      cases h : Ref.fd_curve25519_scalar_validate.spec S
      · rfl
      · exact absurd (hval.1 h) (Nat.not_lt.2 hS)
    rw [ite_eq_left (by rw [this]; rfl), ite_eq_left hS]
  have hv : Ref.fd_curve25519_scalar_validate.spec S = true := hval.2 (Nat.lt_of_not_le hS)
  rw [ite_eq_right (by rw [hv]; decide), ite_eq_right hS]
  obtain ⟨hnA, hnR, hok⟩ := hdec A r
  obtain ⟨⟨dr, dP⟩, hD⟩ : ∃ D, fd_r52x5_ge_decode2.spec A r = D := ⟨_, rfl⟩
  rw [hD] at hnA hnR hok ⊢
  dsimp only at hnA hnR hok ⊢
  rcases hdA : decode A with _ | PA
  · obtain ⟨h2, h1⟩ := hnA hdA
    subst h2
    dsimp only
    rw [ite_eq_left h1]
  rcases hdR : decode r with _ | PR
  · obtain ⟨h2, h1⟩ := hnR PA hdA hdR
    subst h2
    dsimp only
    rw [ite_eq_right h1]
  obtain ⟨Ap, Rp, h2, hAa, hAb, hRa, hRb⟩ := hok PA PR hdA hdR
  subst h2
  dsimp only
  have hsA := hso Ap PA hAa hAb
  have hsR := hso Rp PR hRa hRb
  by_cases h8A : 8 • PA = 0
  · have h0 : fd_r52x5_ge_is_small_order_affine.spec Ap ≠ 0#32 := fun h => (hsA.1 h) h8A
    simp only [h0, h8A, ne_eq, not_false_eq_true, ite_true, ite_not]
  have h0 : fd_r52x5_ge_is_small_order_affine.spec Ap = 0#32 := hsA.2 h8A
  by_cases h8R : 8 • PR = 0
  · have h1 : fd_r52x5_ge_is_small_order_affine.spec Rp ≠ 0#32 := fun h => (hsR.1 h) h8R
    simp only [h0, h1, h8A, h8R, ne_eq, not_false_eq_true, ite_true, ite_false, not_true_eq_false]
  have h1 : fd_r52x5_ge_is_small_order_affine.spec Rp = 0#32 := hsR.2 h8R
  simp only [h0, h1, h8A, h8R, ne_eq, not_true_eq_false, ite_false, ite_true,
    show (1#32 = 0#32) = False by decide]
  have hd := Ref.fd_ed25519_verify.hash_eq buf0 r A msgSz msg
  generalize Firedancer.fd_ed25519_verify.hash buf0 r A msgSz msg = H at hd ⊢
  obtain ⟨sha4, kw⟩ := H
  have hk :
    (Ref.fd_curve25519_scalar_reduce.spec (Firedancer.Words8.bits kw)).toNat =
      Ed25519.natLE (Ed25519.Sha512.digest (bytesLE r ++ bytesLE A ++ bytesLE msg)) %
        Ed25519.ell := by
    rw [Ref.fd_curve25519_scalar_reduce.spec_val, ← hd, Ed25519.natLE_bytesLE (n := 64)]
  generalize Ref.fd_curve25519_scalar_reduce.spec (Firedancer.Words8.bits kw) = k at hk ⊢
  have hkl : k.toNat ≤ 2 ^ 253 := by
    have :=
      Nat.mod_lt (Ed25519.natLE (Ed25519.Sha512.digest (bytesLE r ++ bytesLE A ++ bytesLE msg)))
        (show 0 < Ed25519.ell by unfold Ed25519.ell; decide)
    have := Ed25519.ell_lt
    omega
  have hSl : S.toNat ≤ 2 ^ 253 := by have := Ed25519.ell_lt; omega
  have he := heq Ap Rp PA PR k S hAa hAb hRa hRb hkl hSl
  rw [hk] at he
  generalize
    Ed25519.natLE (Ed25519.Sha512.digest (bytesLE r ++ bytesLE A ++ bytesLE msg)) % Ed25519.ell = n
    at he ⊢
  have key :
    n • -PA + S.toNat • Ed25519.basePoint = PR ↔ S.toNat • Ed25519.basePoint = PR + n • PA := by
    rw [smul_neg]
    constructor <;> intro h
    · rw [← h]; abel
    · rw [h]; abel
  by_cases hq : S.toNat • Ed25519.basePoint = PR + n • PA
  · have : fd_r52x5_ge_eq_z1.spec
        (fd_r52x5_double_scalar_mul_base.spec TB k (Quad5.laneIf 1 0 0 1 (fd_r52x5_quad_neg.spec Ap) Ap) S)
        Rp ≠ 0#32 := fun h => he.1 h (key.2 hq)
    simp only [this, hq, ite_false, ite_true]
  · have : fd_r52x5_ge_eq_z1.spec
        (fd_r52x5_double_scalar_mul_base.spec TB k (Quad5.laneIf 1 0 0 1 (fd_r52x5_quad_neg.spec Ap) Ap) S)
        Rp = 0#32 := he.2 (mt key.1 hq)
    simp only [this, hq, ite_false, ite_true]


open fd_r52x5_double_scalar_mul_base in
/-- crc's `fd_ed25519_verify`, run on memory holding the signature `r ‖ S`, the key `A` and the
message, returns `Ed25519.Firedancer.verify`'s code, given the decoder, the small-order check and
the equation check on the base table `TB` computing their mathematical counterparts. -/
public theorem fd_ed25519_verify.call_ret (msg : Pointer) (msgSz : BitVec 64) (sig pk sha : Pointer)
    (TB : Nat → Quad5) (hdec : DecodeSpec) (hso : SmallOrderSpec) (heq : EquationSpec TB)
    (s : GlobalState) (hwf : s.WF)
    (hg : s.mem.Globals fd_ed25519_verify.globals) (flB tbB : BlockId)
    (hgf : s.mem.globals "fd_r52x5_base_table_init._fd_once_block_state" =
      some (flB, fd_r52x5_base_table_init__fd_once_block_state.image))
    (hgb : s.mem.globals "fd_r52x5_base_table" = some (tbB, fd_r52x5_base_table.image))
    (hfl : Fits s.mem ⟨flB, 0⟩ 1) (hset : s.mem.readAt ⟨flB, 0⟩ 1 = 1)
    (hTB : TableAt s.mem ⟨tbB, 0⟩ 128 TB)
    (hmsg : Fits s.mem msg (8 * msgSz.toNat)) (hmsg_off : ¬msg.offset.uaddOverflow msgSz)
    (hmsgSz : msgSz.toNat < 2 ^ 63) (hsig : Fits s.mem sig (8 * 64))
    (hsig_off : ¬sig.offset.uaddOverflow 64#64) (hpk : Fits s.mem pk (8 * 32))
    (hpk_off : ¬pk.offset.uaddOverflow 32#64) (hsha : s.mem.ShaFit sha) (hshaw : Writable s.mem sha)
    (hmsg_sha : msg.id ≠ sha.id) (hsig_sha : sig.id ≠ sha.id) (hpk_sha : pk.id ≠ sha.id)
    (hsha_fl : sha.id ≠ flB) (hsha_tb : sha.id ≠ tbB) :
    ∃ s',
      fd_ed25519_verify.call
          (fd_ed25519_verify.args (.value msg) (.value msgSz) (.value sig) (.value pk) (.value sha))
          s =
        .value
          (.cons
              (.value
                (Ed25519.Firedancer.verify (bytesLE (s.mem.readAt msg (8 * msgSz.toNat)))
                  (s.mem.readAt sig 256) (s.mem.readAt (sig.add 32#64) 256) (s.mem.readAt pk 256)))
              .nil,
            s') := by
  rw [fd_ed25519_verify.call_eq msg msgSz sig pk sha TB s hwf hg flB tbB hgf hgb hfl hset hTB hmsg
    hmsg_off hmsgSz hsig hsig_off hpk hpk_off hsha hshaw hmsg_sha hsig_sha hpk_sha hsha_fl hsha_tb]
  dsimp only
  rw [fd_ed25519_verify.spec_ret_of TB hdec hso heq]
  exact ⟨_, rfl⟩

end MLIR.Firedancer.Crc.Verify
