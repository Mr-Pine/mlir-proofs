module

public import Agave.Avx2.Mlir.agave_ed25519_verify
public import Agave.Avx2.Signature_verify_verbose
public import Agave.Math.PrehashedAvx2
public import Agave.Serial.agave_ed25519_verify
public import MLIR.Run.Tactic

/-! Agave's `agave_ed25519_verify` (`Signature::verify`): it returns `MLIR.Agave.verify` of the
message, signature and key, which is Firedancer's `verify` accepting with `R`'s `y` below `p`. -/

namespace MLIR.Agave.Avx2

open _root_.Ed25519

/-! ## Specification -/

@[expose] public section

/-- `agave_ed25519_verify(pubkey, signature, msg, len)`: `verify_verbose` returned `Ok(())`
(`-1`). -/
noncomputable def agave_ed25519_verify.spec (R S pk : BitVec 256) (msg : List (BitVec 8)) :
    BitVec 1 :=
  BitVec.ofBool
    (Signature_verify_verbose.spec R S pk (Serial.CompressedEdwardsY_decompress.spec pk) msg ==
      255#8)

end

/-! ## Meaning -/

namespace agave_ed25519_verify

/-- `verify_verbose`'s spec on a decompression result `A?` that decodes `pk`: `-1` exactly when
`verify` accepts. -/
public theorem spec_eq_of {R S pk : BitVec 256} {msg : List (BitVec 8)} {A? : Option EdwardsPoint}
    (hd : DecodesExt pk A?) :
    BitVec.ofBool (Signature_verify_verbose.spec R S pk A? msg == 255#8) =
      BitVec.ofBool (verify msg R S pk) := by
  rw [verify_eq_verifyBody]
  rcases A? with _ | A
  · rw [show decode pk = none from hd]
    rfl
  obtain ⟨Q, hQ, hext, hlt⟩ := hd
  rw [hQ]
  obtain ⟨nb, ne⟩ := Serial.negA_ext hlt hext
  have hk := Serial.scalar_from_sha512.toNat_spec (bytesLE R ++ bytesLE pk ++ msg)
  have hk' : (Serial.scalar_from_sha512.spec (bytesLE R ++ bytesLE pk ++ msg)).toNat < 2 ^ 255 := by
    rw [hk];
    exact
      (Nat.mod_lt _
            (by
              unfold ell; omega)).trans
        Serial.agave_ed25519_verify.ell_lt
  simp only [Signature_verify_verbose.spec, Serial.Signature_verify_verbose.minusA]
  rw [VerificationKey_verify_dalek_prehashed.spec_eq nb ne R S _ hk', hk, challenge]
  cases verifyBody Q R S (natLE (Sha512.digest (bytesLE R ++ bytesLE pk ++ msg)) % ell) <;> rfl

/-- The spec is `verify` of the message, `r ‖ S` and the key. -/
public theorem spec_eq (R S pk : BitVec 256) (msg : List (BitVec 8)) :
    spec R S pk msg = BitVec.ofBool (verify msg R S pk) :=
  spec_eq_of (Serial.CompressedEdwardsY_decompress.spec_val pk)

end agave_ed25519_verify

/-! ## Proof -/

namespace agave_ed25519_verify

section Proof

/-- `agave_ed25519_verify(pubkey, signature, msg, len)` returns `verify` of the `len` bytes at
`msg`, the signature `r ‖ S` at `sig` and the key at `pk`: `1` accepts, `0` rejects. The memory
is left as it was; the counter moves on by `verify_verbose`'s `blocks`. -/
public theorem call_eq (pk sig msg : Pointer) (len : BitVec 64) (s : GlobalState) (hwf : s.WF)
    (hg : s.mem.Globals agave_ed25519_verify.globals) (hpk : Fits s.mem pk 256)
    (hpk_off : ¬pk.offset.uaddOverflow 32#64) (hsig : Fits s.mem sig 512)
    (hsig_off : ¬sig.offset.uaddOverflow 64#64) (hmsg : Fits s.mem msg (8 * len.toNat))
    (hmo : msg.offset.toNat + len.toNat < 2 ^ 64) (hlen : len.toNat < 2 ^ 63) :
    agave_ed25519_verify.call (args (.value pk) (.value sig) (.value msg) (.value len)) s =
      .value
        (.cons
            (.value
              (BitVec.ofBool
                (verify (bytesLE (s.mem.readAt msg (8 * len.toNat))) (s.mem.readAt sig 256)
                  (s.mem.readAt (sig.add 32#64) 256) (s.mem.readAt pk 256))))
            .nil,
          {
            alloc :=
              ⟨s.alloc.nextFreeBlock +
                  Signature_verify_verbose.blocks (s.mem.readAt sig 256)
                    (s.mem.readAt (sig.add 32#64) 256) (s.mem.readAt pk 256)
                    (Serial.CompressedEdwardsY_decompress.spec (s.mem.readAt pk 256))
                    (bytesLE (s.mem.readAt msg (8 * len.toNat))) len⟩,
            mem := s.mem }) := by
  rw [← spec_eq]
  func_init
  block_init
  step_pure
  step_call using Signature_verify_verbose.call_eq
  step_pure
  finish_block
  subst hS
  erase_frame
  rfl

/-- `call_eq` against Firedancer: `1` exactly when Firedancer's `verify` returns success and `R`'s
`y` is below `p`. -/
public theorem call_eq_firedancer (pk sig msg : Pointer) (len : BitVec 64) (s : GlobalState)
    (hwf : s.WF) (hg : s.mem.Globals agave_ed25519_verify.globals) (hpk : Fits s.mem pk 256)
    (hpk_off : ¬pk.offset.uaddOverflow 32#64) (hsig : Fits s.mem sig 512)
    (hsig_off : ¬sig.offset.uaddOverflow 64#64) (hmsg : Fits s.mem msg (8 * len.toNat))
    (hmo : msg.offset.toNat + len.toNat < 2 ^ 64) (hlen : len.toNat < 2 ^ 63) :
    agave_ed25519_verify.call (args (.value pk) (.value sig) (.value msg) (.value len)) s =
      .value
        (.cons
            (.value
              (BitVec.ofBool
                (Firedancer.verify (bytesLE (s.mem.readAt msg (8 * len.toNat)))
                      (s.mem.readAt sig 256) (s.mem.readAt (sig.add 32#64) 256)
                      (s.mem.readAt pk 256) ==
                    0#32 &&
                  decide (CanonicalY (s.mem.readAt sig 256)))))
            .nil,
          {
            alloc :=
              ⟨s.alloc.nextFreeBlock +
                  Signature_verify_verbose.blocks (s.mem.readAt sig 256)
                    (s.mem.readAt (sig.add 32#64) 256) (s.mem.readAt pk 256)
                    (Serial.CompressedEdwardsY_decompress.spec (s.mem.readAt pk 256))
                    (bytesLE (s.mem.readAt msg (8 * len.toNat))) len⟩,
            mem := s.mem }) := by
  rw [← verify_eq_firedancer]
  exact call_eq pk sig msg len s hwf hg hpk hpk_off hsig hsig_off hmsg hmo hlen

end Proof

end agave_ed25519_verify

end MLIR.Agave.Avx2
