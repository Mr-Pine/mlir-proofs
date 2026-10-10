module

public import Ed25519.Scalar
public import Boringssl.x25519_sc_reduce
public import Firedancer.Math.Scalar
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Boringssl

open _root_.Ed25519

/-! ## Reduce -/

/-- `x25519_sc_reduce` computes `x mod ℓ`. -/
public theorem x25519_sc_reduce.spec_val (x : BitVec 512) :
    (x25519_sc_reduce.spec x).toNat = x.toNat % Ed25519.ell := by
  rw [x25519_sc_reduce.spec_eq, MLIR.Firedancer.Ref.fd_curve25519_scalar_reduce.spec_val]

/-! ## `S < ℓ` -/

/-- `S < ℓ` on `S`'s little-endian words (`CRYPTO_load_u64_le(S + 8 i)`), compared from the top
against `kOrder`'s as `ED25519_verify` does: below at the first word that differs, not below if all
are equal. -/
public theorem lt_ell_iff_words (S : BitVec 256) :
    S.toNat < Ed25519.ell ↔
      S.extractLsb' 192 64 < 0x1000000000000000#64 ∨
        S.extractLsb' 192 64 = 0x1000000000000000#64 ∧
          S.extractLsb' 128 64 = 0#64 ∧
          (S.extractLsb' 64 64 < 0x14def9dea2f79cd6#64 ∨
            S.extractLsb' 64 64 = 0x14def9dea2f79cd6#64 ∧
              S.extractLsb' 0 64 < 0x5812631a5cf5d3ed#64) := by
  have h :
    S.toNat < Ed25519.ell ↔
      S < 0x1000000000000000000000000000000014def9dea2f79cd65812631a5cf5d3ed#256 := by
    rw [BitVec.lt_def]
    rfl
  rw [h]
  bv_decide

end MLIR.Boringssl
