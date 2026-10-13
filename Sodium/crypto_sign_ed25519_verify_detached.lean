module

public import MLIR.Run.Tactic
public import Sodium._crypto_sign_ed25519_verify_detached
public import Sodium.Mlir.crypto_sign_ed25519_verify_detached

namespace MLIR.Sodium

/-! ## Proof -/

section Proof

open _crypto_sign_ed25519_verify_detached in
/-- `crypto_sign_ed25519_verify_detached(sig, m, mlen, pk)` is
`_crypto_sign_ed25519_verify_detached(sig, m, mlen, pk, 0)`: it returns `spec`, memory unchanged,
the counter advanced by `blocks`. -/
public theorem crypto_sign_ed25519_verify_detached.call_eq_spec (sig m pk : Pointer)
    (mlen : BitVec 64) (s : GlobalState) (hwf : s.WF)
    (hg : s.mem.Globals crypto_sign_ed25519_verify_detached.globals) (hsig : Fits s.mem sig 512)
    (hsig_off : ¬sig.offset.uaddOverflow 64#64) (hm : Fits s.mem m (8 * mlen.toNat))
    (hm_off : ¬m.offset.uaddOverflow mlen) (hpk : Fits s.mem pk 256)
    (hpk_off : ¬pk.offset.uaddOverflow 32#64) (hv32 : crypto_verify_32.Spec)
    (hdh :
      Boringssl.ge_double_scalarmult_vartime.Digits
        (hram (s.mem.readAt sig 256) (s.mem.readAt pk 256) mlen (s.mem.readAt m (8 * mlen.toNat))))
    (hdS :
      (s.mem.readAt (sig.add 32#64) 256).toNat < Ed25519.ell →
        Boringssl.ge_double_scalarmult_vartime.Digits (s.mem.readAt (sig.add 32#64) 256)) :
    crypto_sign_ed25519_verify_detached.call
        (crypto_sign_ed25519_verify_detached.args (.value sig) (.value m) (.value mlen) (.value pk))
        s =
      .value
        (.cons
            (.value
              (_crypto_sign_ed25519_verify_detached.spec mlen (s.mem.readAt m (8 * mlen.toNat))
                (s.mem.readAt sig 256) (s.mem.readAt (sig.add 32#64) 256) (s.mem.readAt pk 256)))
            .nil,
          {
            alloc :=
              ⟨s.alloc.nextFreeBlock +
                  _crypto_sign_ed25519_verify_detached.blocks mlen (s.mem.readAt m (8 * mlen.toNat))
                    (s.mem.readAt sig 256) (s.mem.readAt (sig.add 32#64) 256)
                    (s.mem.readAt pk 256)⟩,
            mem := s.mem }) := by
  func_init
  block_init
  step_pure
  step_call using _crypto_sign_ed25519_verify_detached.call_eq
  finish_block
  subst hS
  erase_frame

end Proof

end MLIR.Sodium
