module

public import Sodium.crypto_sign_ed25519_verify_detached
public import Sodium.crypto_verify_32
public import Sodium.Math.Point
public import Sodium.Math.Dsmb
public import Sodium.Math.Verify
public import Boringssl.Math.Scalar
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

/-! `crypto_sign_ed25519_verify_detached` returns `Sodium.verify`: its checks are the byte
predicates, `S < ℓ` and `decode`; `h` is SHA-512 of `r ‖ A ‖ msg` mod `ℓ`; the double scalar
multiplication computes `[h](-A) + [S] B` and `ge25519_tobytes` encodes it; `crypto_verify_32`
compares it with `r`. -/

namespace MLIR.Sodium

open _root_.Ed25519 (natLE bytesLE ell ell_lt encode decode basePoint)

/-- `(1 & ((d - 1) >> 8)) - 1` on a byte: `0` for `d = 0`, `-1` otherwise. -/
theorem sodium_memcmp.ret_byte (d : BitVec 8) :
    (1#32 &&& ((d.setWidth 32 - 1#32) >>> 8)) - 1#32 = if d = 0#8 then 0#32 else -1#32 := by
  by_cases h : d = 0#8
  · subst h
    decide
  · simp only [h, ↓reduceIte]
    bv_decide

/-- `sodium_memcmp.spec 32` is `0` on equal bytes, `-1` on others. -/
theorem sodium_memcmp.spec_eq_ite (x y : BitVec 256) :
    sodium_memcmp.spec 32 x y = if x = y then 0#32 else -1#32 := by
  have hz := sodium_memcmp.spec_eq_zero_iff 32 x y
  have hr : sodium_memcmp.spec 32 x y = 0#32 ∨ sodium_memcmp.spec 32 x y = -1#32 := by
    unfold sodium_memcmp.spec
    dsimp only
    rw [sodium_memcmp.ret_byte]
    split <;> simp
  split
  · exact hz.2 ‹_›
  · exact hr.resolve_left fun h => ‹¬x = y› (hz.1 h)

/-- `h`'s value: SHA-512 of `r ‖ A ‖ msg` mod `ℓ`. -/
theorem hram_toNat (r A : BitVec 256) (mlen : BitVec 64) (msg : BitVec (8 * mlen.toNat)) :
    (_crypto_sign_ed25519_verify_detached.hram r A mlen msg).toNat =
      natLE (_root_.Ed25519.Sha512.digest (bytesLE r ++ bytesLE A ++ bytesLE msg)) % ell := by
  have e := hash_eq (HashState.ofBits 0 0) r A mlen msg
  rw [_crypto_sign_ed25519_verify_detached.hram, Boringssl.x25519_sc_reduce.spec_val, ← e,
    _root_.Ed25519.natLE_bytesLE (n := 64), BitVec.ofNat_toNat, BitVec.setWidth_eq]

/-- `h` is below `ℓ`, so its slide digits are in range. -/
public theorem hram_digits (r A : BitVec 256) (mlen : BitVec 64) (msg : BitVec (8 * mlen.toNat)) :
    Boringssl.ge_double_scalarmult_vartime.Digits
      (_crypto_sign_ed25519_verify_detached.hram r A mlen msg) := by
  refine ge25519_double_scalarmult_vartime.digits_of_lt ?_
  rw [hram_toNat]
  have :=
    Nat.mod_lt (natLE (_root_.Ed25519.Sha512.digest (bytesLE r ++ bytesLE A ++ bytesLE msg)))
      (show 0 < ell by
        have := ell_lt; unfold ell; omega)
  have := ell_lt
  omega

/-- `S < ℓ`: its slide digits are in range. -/
public theorem digits_of_lt_ell {S : BitVec 256} (h : S.toNat < ell) :
    Boringssl.ge_double_scalarmult_vartime.Digits S :=
  ge25519_double_scalarmult_vartime.digits_of_lt
    (by
      have := ell_lt; omega)

/-- `ProjLt` with a larger bound. -/
theorem _root_.MLIR.GeP2.ProjLt.mono {P : GeP2} {Q : _root_.Ed25519.Point} {b c : ℕ}
    (h : P.ProjLt Q b) (hbc : b ≤ c) : P.ProjLt Q c :=
  ⟨h.1, h.2.1.mono hbc, h.2.2.1.mono hbc, h.2.2.2.mono hbc⟩

/-- The C's result: `Sodium.verify` on the message bytes. -/
public theorem _crypto_sign_ed25519_verify_detached.spec_eq (mlen : BitVec 64)
    (msg : BitVec (8 * mlen.toNat)) (r S A : BitVec 256) :
    _crypto_sign_ed25519_verify_detached.spec mlen msg r S A =
      _root_.Ed25519.Sodium.verify (bytesLE msg) r S A := by
  unfold _crypto_sign_ed25519_verify_detached.spec _root_.Ed25519.Sodium.verify
  rw [sc25519_is_canonical.spec_eq, ge25519_has_small_order.spec_eq r, ge25519_is_canonical.spec_eq,
    ge25519_has_small_order.spec_eq A]
  have e10 : (1#32 = 0#32) = False := by decide
  by_cases h1 : S.toNat < ell
  swap
  · simp only [h1, ↓reduceIte, not_false_eq_true, true_or]
  by_cases h2 : _root_.Ed25519.Sodium.HasSmallOrder r
  · simp only [h1, h2, ↓reduceIte, ne_eq, e10, not_false_eq_true, or_true]
  by_cases h3 : _root_.Ed25519.Sodium.IsCanonical A
  swap
  · simp only [h1, h2, h3, ↓reduceIte, ne_eq, e10, not_true_eq_false, not_false_eq_true, or_false,
      true_or]
  by_cases h4 : _root_.Ed25519.Sodium.HasSmallOrder A
  · simp only [h1, h2, h3, h4, ↓reduceIte, ne_eq, e10, not_true_eq_false, not_false_eq_true,
      or_false, or_true]
  rcases hP : ge25519_frombytes_negate_vartime.spec A with _ | P
  · rw [(ge25519_frombytes_negate_vartime.spec_eq_none_iff A).1 hP]
    simp only [h1, h2, h3, h4, ↓reduceIte, ne_eq, e10, not_true_eq_false, or_false]
  obtain ⟨Q, hQ, hext, -⟩ := ge25519_frombytes_negate_vartime.spec_some hP
  rw [hQ]
  simp only [h1, h2, h3, h4, ↓reduceIte, ne_eq, e10, not_true_eq_false, or_false]
  have hh := hram_toNat r A mlen msg
  have hl := ell_lt
  have hk :=
    Nat.mod_lt (natLE (_root_.Ed25519.Sha512.digest (bytesLE r ++ bytesLE A ++ bytesLE msg)))
      (show 0 < ell by
        unfold ell; omega)
  have hproj :=
    ge25519_double_scalarmult_vartime.spec_projLt hext (a :=
      _crypto_sign_ed25519_verify_detached.hram r A mlen msg) (b := S) (by omega) (by omega)
  rw [ge25519_tobytes.spec_eq (hproj.mono (by decide)), hh, sodium_memcmp.spec_eq_ite]
  generalize encode _ = E
  by_cases he : E = r
  · simp [he]
  · simp [he, Ne.symm he]

/-- `crypto_sign_ed25519_verify_detached(sig, m, mlen, pk)` returns `Sodium.verify` of the `mlen`
bytes at `m`, the signature `r ‖ S` at `sig` and the key at `pk`: `0` accepts, `-1` rejects.
Memory is unchanged; `crypto_verify_32` behaves as `crypto_verify_32.Spec` states. -/
public theorem crypto_sign_ed25519_verify_detached.call_eq_verify (sig m pk : Pointer)
    (mlen : BitVec 64) (s : GlobalState) (hwf : s.WF)
    (hg : s.mem.Globals crypto_sign_ed25519_verify_detached.globals) (hsig : Fits s.mem sig 512)
    (hsig_off : ¬sig.offset.uaddOverflow 64#64) (hm : Fits s.mem m (8 * mlen.toNat))
    (hm_off : ¬m.offset.uaddOverflow mlen) (hpk : Fits s.mem pk 256)
    (hpk_off : ¬pk.offset.uaddOverflow 32#64) (hv32 : crypto_verify_32.Spec) :
    crypto_sign_ed25519_verify_detached.call
        (crypto_sign_ed25519_verify_detached.args (.value sig) (.value m) (.value mlen) (.value pk))
        s =
      .value
        (.cons
            (.value
              (_root_.Ed25519.Sodium.verify (bytesLE (s.mem.readAt m (8 * mlen.toNat)))
                (s.mem.readAt sig 256) (s.mem.readAt (sig.add 32#64) 256) (s.mem.readAt pk 256)))
            .nil,
          {
            alloc :=
              ⟨s.alloc.nextFreeBlock +
                  _crypto_sign_ed25519_verify_detached.blocks mlen (s.mem.readAt m (8 * mlen.toNat))
                    (s.mem.readAt sig 256) (s.mem.readAt (sig.add 32#64) 256)
                    (s.mem.readAt pk 256)⟩,
            mem := s.mem }) := by
  rw [crypto_sign_ed25519_verify_detached.call_eq_spec sig m pk mlen s hwf hg hsig hsig_off hm
      hm_off hpk hpk_off hv32 (hram_digits _ _ _ _) digits_of_lt_ell,
    _crypto_sign_ed25519_verify_detached.spec_eq]

/-- `crypto_sign_ed25519_verify_detached(sig, m, mlen, pk)` returns `Sodium.verify` of the `mlen`
bytes at `m`, the signature `r ‖ S` at `sig` and the key at `pk`: `0` accepts, `-1` rejects.
Memory is unchanged. -/
public theorem crypto_sign_ed25519_verify_detached.call_eq (sig m pk : Pointer) (mlen : BitVec 64)
    (s : GlobalState) (hwf : s.WF)
    (hg : s.mem.Globals crypto_sign_ed25519_verify_detached.globals) (hsig : Fits s.mem sig 512)
    (hsig_off : ¬sig.offset.uaddOverflow 64#64) (hm : Fits s.mem m (8 * mlen.toNat))
    (hm_off : ¬m.offset.uaddOverflow mlen) (hpk : Fits s.mem pk 256)
    (hpk_off : ¬pk.offset.uaddOverflow 32#64) :
    crypto_sign_ed25519_verify_detached.call
        (crypto_sign_ed25519_verify_detached.args (.value sig) (.value m) (.value mlen) (.value pk))
        s =
      .value
        (.cons
            (.value
              (_root_.Ed25519.Sodium.verify (bytesLE (s.mem.readAt m (8 * mlen.toNat)))
                (s.mem.readAt sig 256) (s.mem.readAt (sig.add 32#64) 256) (s.mem.readAt pk 256)))
            .nil,
          {
            alloc :=
              ⟨s.alloc.nextFreeBlock +
                  _crypto_sign_ed25519_verify_detached.blocks mlen (s.mem.readAt m (8 * mlen.toNat))
                    (s.mem.readAt sig 256) (s.mem.readAt (sig.add 32#64) 256)
                    (s.mem.readAt pk 256)⟩,
            mem := s.mem }) :=
  crypto_sign_ed25519_verify_detached.call_eq_verify sig m pk mlen s hwf hg hsig hsig_off hm hm_off
    hpk hpk_off crypto_verify_32.call_eq

end MLIR.Sodium
