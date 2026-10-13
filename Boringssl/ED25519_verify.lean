module

public import MLIR.Run.Tactic
public import Boringssl.ed25519_verify
public import Boringssl.Math.Verify
public import Boringssl.Mlir.ED25519_verify
import Mathlib.Tactic.Ring
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

/-! BoringSSL's `ED25519_verify`: it returns `Boringssl.verify` of the message, signature and key,
`1` accepting and `0` rejecting. -/

namespace MLIR.Boringssl

open _root_.Ed25519 (natLE bytesLE)

/-! ## `ed25519_verify.spec` as `Boringssl.verify` -/

namespace ed25519_verify

/-- Bytes as a little-endian number fit their width. -/
theorem natLE_lt (L : List (BitVec 8)) : natLE L < 2 ^ (8 * L.length) := by
  induction L with
  | nil => simp [natLE]
  | cons b l ih =>
    simp only [natLE, List.length_cons]
    have hb := b.isLt
    rw [show 8 * (l.length + 1) = 8 * l.length + 8 by ring, pow_add]
    generalize 2 ^ (8 * l.length) = X at ih ⊢
    omega

theorem toNat_ofNat_of_lt {w x : Nat} (h : x < 2 ^ w) : (BitVec.ofNat w x).toNat = x := by
  rw [BitVec.toNat_ofNat]
  exact Nat.mod_eq_of_lt h

/-- The digest's 64 bytes. -/
theorem length_digest (m : List (BitVec 8)) : (_root_.Ed25519.Sha512.digest m).length = 64 := by
  have h8 (x : BitVec 64) : (_root_.Ed25519.Sha512.bytesBE x).length = 8 := by
    simp [_root_.Ed25519.Sha512.bytesBE]
  simp only [_root_.Ed25519.Sha512.digest, List.length_flatMap, h8]
  generalize _root_.Ed25519.Sha512.compressBlocks _ _ = v
  simp

/-- `S`'s top byte at least `32` exactly when `S ≥ 2^253`. -/
theorem top_iff (S : BitVec 256) : (32#8).ule (S.extractLsb' 248 8) = true ↔ 2 ^ 253 ≤ S.toNat := by
  have h : 2 ^ 253 ≤ S.toNat ↔ BitVec.ofNat 256 (2 ^ 253) ≤ S := by
    rw [BitVec.le_def]
    rfl
  rw [h]
  bv_decide

/-- The word loop decides `S < ℓ`. -/
theorem sOk_iff (S : BitVec 256) : sOk S = true ↔ S.toNat < _root_.Ed25519.ell := by
  rw [lt_ell_iff_words]
  unfold sOk
  generalize S.extractLsb' 192 64 = w3
  generalize S.extractLsb' 128 64 = w2
  generalize S.extractLsb' 64 64 = w1
  generalize S.extractLsb' 0 64 = w0
  bv_decide

/-- 32 equal bytes: equal. -/
theorem eq_of_bytes {x y : BitVec 256}
    (h : ∀ i < 32, x.extractLsb' (8 * i) 8 = y.extractLsb' (8 * i) 8) : x = y := by
  apply BitVec.eq_of_getLsbD_eq
  intro j hj
  have e := congrArg (·.getLsbD (j % 8)) (h (j / 8) (by omega))
  simp only [BitVec.getLsbD_extractLsb', show j % 8 < 8 by omega, decide_true, Bool.true_and] at e
  rwa [show 8 * (j / 8) + j % 8 = j by omega] at e

/-- `CRYPTO_memcmp` of 32 bytes is `0` exactly when they are equal. -/
theorem memcmp_eq_zero_iff (x y : BitVec 256) : CRYPTO_memcmp.spec x y 32 = 0#32 ↔ x = y := by
  rw [CRYPTO_memcmp.spec_eq_zero_iff]
  exact ⟨eq_of_bytes, fun h _ _ => h ▸ rfl⟩

/-- `negA` negates the point. -/
theorem negA_ext {P : GeP3} {Q : _root_.Ed25519.Point} (h : P.Ext Q) : (negA P).Ext (-Q) := by
  obtain ⟨⟨hz, hx, hy, ht⟩, tX, tY, tZ, tT⟩ := h
  obtain ⟨vX, bX⟩ := Firedancer.Ref.fiat_25519_opp.spec_val tX
  obtain ⟨vT, bT⟩ := Firedancer.Ref.fiat_25519_opp.spec_val tT
  obtain ⟨cX, tX'⟩ := Firedancer.Ref.fiat_25519_carry.spec_val bX
  obtain ⟨cT, tT'⟩ := Firedancer.Ref.fiat_25519_carry.spec_val bT
  refine ⟨⟨hz, ?_, hy, ?_⟩, tX', tY, tZ, tT'⟩
  · simp only [negA, cX, vX, hx, _root_.Ed25519.Point.neg_x]
    ring
  · simp only [negA, cX, vX, cT, vT]
    rw [neg_mul, neg_mul, ht]

/-- `ed25519_verify`'s result is `Ed25519.Boringssl.verify`'s. -/
public theorem spec_eq (msgLen : BitVec 64) (msg : BitVec (8 * msgLen.toNat)) (r S A : BitVec 256) :
    spec msgLen msg r S A = _root_.Ed25519.Boringssl.verify (bytesLE msg) r S A := by
  unfold spec _root_.Ed25519.Boringssl.verify
  by_cases htop : 2 ^ 253 ≤ S.toNat
  · simp only [(top_iff S).2 htop, htop, ↓reduceIte]
  have htop' : (32#8).ule (S.extractLsb' 248 8) = false := by
    simpa using fun h => htop ((top_iff S).1 h)
  simp only [htop', htop, Bool.false_eq_true, ↓reduceIte]
  rcases hA : x25519_ge_frombytes_vartime.spec A with _ | P
  · rw [(x25519_ge_frombytes_vartime.spec_eq_none_iff A).1 hA]
  obtain ⟨Q, hQ, hP, -⟩ := x25519_ge_frombytes_vartime.spec_some hA
  rw [hQ]
  dsimp only
  by_cases hS : _root_.Ed25519.ell ≤ S.toNat
  · have : sOk S = false := by
      cases h : sOk S
      · rfl
      · exact absurd ((sOk_iff S).1 h) (by omega)
    simp only [this, hS, Bool.false_eq_true, ↓reduceIte]
  simp only [(sOk_iff S).2 (by omega), hS, ↓reduceIte]
  have hl := _root_.Ed25519.ell_lt
  have hk :
    (hram r A msgLen msg).toNat =
      natLE (_root_.Ed25519.Sha512.digest (bytesLE r ++ bytesLE A ++ bytesLE msg)) %
        _root_.Ed25519.ell := by
    have := natLE_lt (_root_.Ed25519.Sha512.digest (bytesLE r ++ bytesLE A ++ bytesLE msg))
    rw [length_digest, show 8 * 64 = 512 from rfl] at this
    rw [hram, x25519_sc_reduce.spec_val, toNat_ofNat_of_lt this]
  have hkl : (hram r A msgLen msg).toNat < 2 ^ 255 := by
    rw [hk]
    calc
      _ < _root_.Ed25519.ell :=
        Nat.mod_lt _
          (by
            unfold _root_.Ed25519.ell; decide)
      _ < 2 ^ 253 := hl
      _ ≤ 2 ^ 255 := Nat.pow_le_pow_right (by decide) (by decide)
  have hR :=
    ge_double_scalarmult_vartime.spec_proj (a := hram r A msgLen msg) (b := S) (negA_ext hP) hkl
      (by omega)
  rw [x25519_ge_tobytes.spec_eq hR, hk]
  by_cases he :
    _root_.Ed25519.encode
        ((natLE (_root_.Ed25519.Sha512.digest (bytesLE r ++ bytesLE A ++ bytesLE msg)) %
              _root_.Ed25519.ell) •
            -Q +
          S.toNat • _root_.Ed25519.basePoint) =
      r
  · simp only [he, (memcmp_eq_zero_iff r r).2 rfl, ↓reduceIte]
  · have :
      ¬CRYPTO_memcmp.spec
            (_root_.Ed25519.encode
              ((natLE (_root_.Ed25519.Sha512.digest (bytesLE r ++ bytesLE A ++ bytesLE msg)) %
                    _root_.Ed25519.ell) •
                  -Q +
                S.toNat • _root_.Ed25519.basePoint))
            r 32 =
          0#32 :=
      fun h => he ((memcmp_eq_zero_iff _ _).1 h)
    simp only [this, he, ↓reduceIte]

end ed25519_verify

/-! ## Proof -/

section Proof

/-- `ED25519_verify` returns `Ed25519.Boringssl.verify` of the message at `msg`, the signature
`r ‖ S` at `sig` and the key at `pk`: `1` accepts, `0` rejects. The memory is unchanged; the
block counter advances by `ed25519_verify.blocks`. -/
public theorem ED25519_verify.call_eq (msg : Pointer) (msgLen : BitVec 64) (sig pk : Pointer)
    (s : GlobalState) (hwf : s.WF)
    (hg : s.mem.Globals ED25519_verify.globals) (hmsg : Fits s.mem msg (8 * msgLen.toNat))
    (hmsg_off : ¬msg.offset.uaddOverflow msgLen) (hmsgLen : msgLen.toNat < 2 ^ 63)
    (hsig : Fits s.mem sig 512) (hsig_off : ¬sig.offset.uaddOverflow 64#64)
    (hpk : Fits s.mem pk 256) (hpk_off : ¬pk.offset.uaddOverflow 32#64) :
    ED25519_verify.call (ED25519_verify.args (.value msg) (.value msgLen) (.value sig) (.value pk))
        s =
      .value
        (.cons
            (.value
              (_root_.Ed25519.Boringssl.verify (bytesLE (s.mem.readAt msg (8 * msgLen.toNat)))
                (s.mem.readAt sig 256) (s.mem.readAt (sig.add 32#64) 256) (s.mem.readAt pk 256)))
            .nil,
          {
            alloc :=
              ⟨s.alloc.nextFreeBlock +
                  ed25519_verify.blocks msgLen (s.mem.readAt msg (8 * msgLen.toNat))
                    (s.mem.readAt sig 256) (s.mem.readAt (sig.add 32#64) 256)
                    (s.mem.readAt pk 256)⟩,
            mem := s.mem }) := by
  rw [← ed25519_verify.spec_eq]
  func_init
  block_init
  iterate 2 step_pure
  step_call using ed25519_verify.call_eq
  finish_block
  subst hS
  erase_frame

end Proof

end MLIR.Boringssl
