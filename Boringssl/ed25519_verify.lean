module

public import MLIR.Run.Tactic
public import Firedancer.Common.Tactics
public import Firedancer.Common.Verify
public import Boringssl.Common.Point
public import Boringssl.CRYPTO_load_u64_le
public import Boringssl.CRYPTO_memcmp
public import Boringssl.OPENSSL_memcpy
public import Boringssl.SHA512_Init
public import Boringssl.SHA512_Update
public import Boringssl.SHA512_Final
public import Boringssl.fe_neg
public import Boringssl.fe_carry
public import Boringssl.x25519_sc_reduce
public import Boringssl.x25519_ge_tobytes
public import Boringssl.x25519_ge_frombytes_vartime
public import Boringssl.ge_double_scalarmult_vartime
public import Boringssl.Mlir.ed25519_verify
public import Ed25519.Decode
public import Boringssl.Math.Sha512
public import Boringssl.Math.Scalar
public import Boringssl.Math.Dsmb
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Boringssl

open _root_.Ed25519 (natLE bytesLE)

/-! ## Specification -/

@[expose] public section

namespace ed25519_verify

/-- `kOrder`'s words, the lowest less one, as the comparisons use them. -/
abbrev K3 : BitVec 64 :=
  0x1000000000000000#64

abbrev K2 : BitVec 64 :=
  0#64

abbrev K1 : BitVec 64 :=
  0x14def9dea2f79cd6#64

abbrev K0m1 : BitVec 64 :=
  0x5812631a5cf5d3ec#64

/-- `S < kOrder` as the loop over `S`'s little-endian words decides it, from the top. -/
def sOk (S : BitVec 256) : Bool :=
  if K3.ult (S.extractLsb' 192 64) then false
  else
    if S.extractLsb' 192 64 = K3 then
      if S.extractLsb' 128 64 = K2 then
        if K1.ult (S.extractLsb' 64 64) then false
        else if S.extractLsb' 64 64 = K1 then !K0m1.ult (S.extractLsb' 0 64) else true
      else false
    else true

/-- The blocks the loop's `CRYPTO_load_u64_le` calls allocate, one per word read. -/
def sBlocks (S : BitVec 256) : Nat :=
  1 +
    if K3.ult (S.extractLsb' 192 64) then 0
    else
      if S.extractLsb' 192 64 = K3 then
        1 +
          if S.extractLsb' 128 64 = K2 then
            1 +
              if K1.ult (S.extractLsb' 64 64) then 0 else if S.extractLsb' 64 64 = K1 then 1 else 0
          else 0
      else 0

/-- `A` negated: `fe_neg` and `fe_carry` of its `X` and `T`. -/
def negA (P : GeP3) : GeP3 :=
  ⟨Firedancer.Ref.fiat_25519_carry.spec (Firedancer.Ref.fiat_25519_opp.spec P.X), P.Y, P.Z,
    Firedancer.Ref.fiat_25519_carry.spec (Firedancer.Ref.fiat_25519_opp.spec P.T)⟩

/-- `h`: SHA-512 of `r ‖ A ‖ msg`, reduced mod `ℓ`. -/
noncomputable def hram (r A : BitVec 256) (msgLen : BitVec 64) (msg : BitVec (8 * msgLen.toNat)) :
    BitVec 256 :=
  x25519_sc_reduce.spec
    (BitVec.ofNat 512
      (natLE (_root_.Ed25519.Sha512.digest (bytesLE r ++ bytesLE A ++ bytesLE msg))))

/-- The blocks the SHA-512 calls allocate: they depend on the bytes counted, not on the hash
object's buffer, so they are counted from the zero object. -/
def hashBlocks (r A : BitVec 256) (msgLen : BitVec 64) (msg : BitVec (8 * msgLen.toNat)) : Nat :=
  let v₁ := BCM_sha512_init.spec (Sha512Ctx.ofBits 0 0)
  let v₂ := BCM_sha512_update.spec v₁ 32#64 r
  let v₃ := BCM_sha512_update.spec v₂ 32#64 A
  let v₄ := BCM_sha512_update.spec v₃ msgLen msg
  2 * BCM_sha512_update.cores v₁ 32#64 + 2 * BCM_sha512_update.cores v₂ 32#64 +
    2 * BCM_sha512_update.cores v₃ msgLen +
    (2 * sha512_final_impl.cores v₄ + 10)

end ed25519_verify

open ed25519_verify in
/-- `ed25519_verify` on the signature `r ‖ S` and the key `A`, the checks in the C's order: `S`'s
top three bits clear, `A` decodes, `S < ℓ`; then `1` if the encoding of `[h](-A) + [S] B` is `r`. -/
noncomputable def ed25519_verify.spec (msgLen : BitVec 64) (msg : BitVec (8 * msgLen.toNat))
    (r S A : BitVec 256) : BitVec 32 :=
  if (32#8).ule (S.extractLsb' 248 8) then 0#32
  else
    match x25519_ge_frombytes_vartime.spec A with
    | none => 0#32
    | some P =>
      if sOk S then
        let R := ge_double_scalarmult_vartime.spec (hram r A msgLen msg) (negA P) S
        if CRYPTO_memcmp.spec (x25519_ge_tobytes.spec R) r 32 = 0#32 then 1#32 else 0#32
      else 0#32

open ed25519_verify in
/-- The blocks `ed25519_verify` allocates, its callees' included: its nine locals, then each
call's on the path taken. -/
noncomputable def ed25519_verify.blocks (msgLen : BitVec 64) (msg : BitVec (8 * msgLen.toNat))
    (r S A : BitVec 256) : Nat :=
  9 +
    if (32#8).ule (S.extractLsb' 248 8) then 0
    else
      x25519_ge_frombytes_vartime.blocks A +
        match x25519_ge_frombytes_vartime.spec A with
        | none => 0
        | some _ =>
          sBlocks S +
            if sOk S then
              hashBlocks r A msgLen msg +
                ge_double_scalarmult_vartime.blocks (hram r A msgLen msg) S +
                51
            else 0

end

/-! ## Proof -/

section Proof

set_option hygiene false in
/-- The accepted path: `accept_run`, then the spec's equations. -/
local macro "accept" : tactic =>
  `(tactic|
    ( refine
        (accept_run msg msgLen sig pk A t pkcopy rcopy scopy ctx h R rcheck _ hAL mv rv Sv Av PA S E
              hArgs (by env_reads) hwf hmsg hmsg_off hsig hsig_off hpk hpk_off hmv hrv hAv hA_pt hAP
              hfits_rcopy hread_rcopy hfits_scopy hread_scopy hctx_bounds hh_bounds hR_bounds
              hrcheck_bounds (digits_hram rv Av msgLen mv) (digits_S htop) hok).trans
          ?_
      rw [hS]
      dsimp only
      erase_frame
      rw [← hret, ← hk, (spec_ok htop hfb hs.1).1, (spec_ok htop hfb hs.1).2, hs.2]
      simp [GlobalState.alloca]
      omega))

set_option hygiene false in
/-- A rejection after the copies: `reject_tail`, then the frame erased. -/
local macro "reject_exit" : tactic =>
  `(tactic|
    ( refine
        (reject_tail t pkcopy rcopy scopy A _ ⟨hAL.Nt, hAL.Npk, hAL.Nr, hAL.Ns, hAL.NA⟩ S E
              (by env_reads)).trans
          ?_
      rw [hS]
      dsimp only
      erase_frame))

open ed25519_verify

namespace ed25519_verify

/-- `S`'s top byte at least `32`: rejected, the locals' blocks only. -/
theorem spec_top {msgLen : BitVec 64} {msg : BitVec (8 * msgLen.toNat)} {r S A : BitVec 256}
    (h : ¬(S.extractLsb' 248 8).ult 32#8 = true) :
    spec msgLen msg r S A = 0#32 ∧ blocks msgLen msg r S A = 9 := by
  have hu : (32#8).ule (S.extractLsb' 248 8) = true := by
    simp only [BitVec.ult, BitVec.ule, decide_eq_true_eq, not_lt] at h ⊢
    exact h
  simp [spec, blocks, hu]

/-- `A` does not decode: rejected. -/
theorem spec_none {msgLen : BitVec 64} {msg : BitVec (8 * msgLen.toNat)} {r S A : BitVec 256}
    (h : (S.extractLsb' 248 8).ult 32#8 = true) (hA : x25519_ge_frombytes_vartime.spec A = none) :
    spec msgLen msg r S A = 0#32 ∧
      blocks msgLen msg r S A = 9 + x25519_ge_frombytes_vartime.blocks A := by
  have hu : (32#8).ule (S.extractLsb' 248 8) = false := by
    simp only [BitVec.ult, BitVec.ule, decide_eq_true_eq, decide_eq_false_iff_not, not_le] at h ⊢
    exact h
  simp [spec, blocks, hu, hA]

/-- `A` decodes and `S` is out of range: rejected. -/
theorem spec_sbad {msgLen : BitVec 64} {msg : BitVec (8 * msgLen.toNat)} {r S A : BitVec 256}
    {P : GeP3} (h : (S.extractLsb' 248 8).ult 32#8 = true)
    (hA : x25519_ge_frombytes_vartime.spec A = some P) (hs : sOk S = false) :
    spec msgLen msg r S A = 0#32 ∧
      blocks msgLen msg r S A = 9 + x25519_ge_frombytes_vartime.blocks A + sBlocks S := by
  have hu : (32#8).ule (S.extractLsb' 248 8) = false := by
    simp only [BitVec.ult, BitVec.ule, decide_eq_true_eq, decide_eq_false_iff_not, not_le] at h ⊢
    exact h
  simp [spec, blocks, hu, hA, hs, Nat.add_assoc]

/-- `A` decodes and `S < ℓ`: the encodings compared. -/
theorem spec_ok {msgLen : BitVec 64} {msg : BitVec (8 * msgLen.toNat)} {r S A : BitVec 256}
    {P : GeP3} (h : (S.extractLsb' 248 8).ult 32#8 = true)
    (hA : x25519_ge_frombytes_vartime.spec A = some P) (hs : sOk S = true) :
    spec msgLen msg r S A =
        (if
            CRYPTO_memcmp.spec
                (x25519_ge_tobytes.spec
                  (ge_double_scalarmult_vartime.spec (hram r A msgLen msg) (negA P) S))
                r 32 =
              0#32 then
          1#32
        else 0#32) ∧
      blocks msgLen msg r S A =
        9 + x25519_ge_frombytes_vartime.blocks A + sBlocks S +
          (hashBlocks r A msgLen msg + ge_double_scalarmult_vartime.blocks (hram r A msgLen msg) S +
            51) := by
  have hu : (32#8).ule (S.extractLsb' 248 8) = false := by
    simp only [BitVec.ult, BitVec.ule, decide_eq_true_eq, decide_eq_false_iff_not, not_le] at h ⊢
    exact h
  simp [spec, blocks, hu, hA, hs, Nat.add_assoc]

/-- `h`'s digits are in range: `h < ℓ`. -/
theorem digits_hram (r A : BitVec 256) (msgLen : BitVec 64) (msg : BitVec (8 * msgLen.toNat)) :
    ge_double_scalarmult_vartime.Digits (hram r A msgLen msg) := by
  refine ge_double_scalarmult_vartime.digits_of_lt ?_
  rw [hram, x25519_sc_reduce.spec_val]
  have h := _root_.Ed25519.ell_lt
  calc
    _ < _root_.Ed25519.ell :=
      Nat.mod_lt _
        (by
          unfold _root_.Ed25519.ell; decide)
    _ < 2 ^ 253 := h
    _ ≤ 2 ^ 255 := Nat.pow_le_pow_right (by decide) (by decide)

/-- `S`'s digits are in range when its top three bits are clear. -/
theorem digits_S {S : BitVec 256} (h : (S.extractLsb' 248 8).ult 32#8 = true) :
    ge_double_scalarmult_vartime.Digits S := by
  refine ge_double_scalarmult_vartime.digits_of_lt ?_
  have : S < BitVec.ofNat 256 (2 ^ 253) := by bv_decide
  simp only [BitVec.lt_def, BitVec.toNat_ofNat] at this
  omega

end ed25519_verify

/-- `Ok` past `k` buffered bytes, `0 < k < 128`: the bytes fit in the buffer, or their bulk is
`Ok`. -/
theorem ok_of_num {v : Sha512Ctx} {len : BitVec 64} {k : Nat} (hk : v.num.toNat = k) (hk0 : k ≠ 0)
    (hk128 : k < 128)
    (h : len.toNat < 128 - k ∨ BCM_sha512_update.BulkOk (len - BitVec.ofNat 64 (128 - k))) :
    BCM_sha512_update.Ok v len := by
  have hn : v.num ≠ 0#16 := fun h0 =>
    hk0
      (by
        rw [← hk, h0]; rfl)
  have hm : 128#64 - v.num.setWidth 64 = BitVec.ofNat 64 (128 - k) := by
    apply BitVec.eq_of_toNat_eq
    rw [BitVec.toNat_sub_of_le
        (by
          simp [BitVec.le_def]; omega)]
    simp only [BitVec.toNat_ofNat, BitVec.toNat_setWidth, hk]
    omega
  refine .inr ?_
  simp only [BCM_sha512_update.RestOk, hn, ↓reduceIte, hm]
  rcases h with h | h
  · left
    simp only [BitVec.ult, decide_eq_true_eq, BitVec.toNat_ofNat]
    omega
  · exact .inr h

/-! ### The hash object's counts -/

/-- `update`'s `num` depends on `num` and `len` only. -/
theorem num_update {v v' : Sha512Ctx} (h : v.num = v'.num) (len : BitVec 64)
    (d d' : BitVec (8 * len.toNat)) :
    (BCM_sha512_update.spec v len d).num = (BCM_sha512_update.spec v' len d').num := by
  simp only [BCM_sha512_update.spec, BCM_sha512_update.rest, BCM_sha512_update.bulk,
    BCM_sha512_update.leftover, h]
  split_ifs <;> simp [h]

theorem cores_congr {v v' : Sha512Ctx} (h : v.num = v'.num) (len : BitVec 64) :
    BCM_sha512_update.cores v len = BCM_sha512_update.cores v' len := by
  simp [BCM_sha512_update.cores, BCM_sha512_update.restCores, h]

theorem final_cores_congr {v v' : Sha512Ctx} (h : v.num = v'.num) :
    sha512_final_impl.cores v = sha512_final_impl.cores v' := by simp [sha512_final_impl.cores, h]

/-- `hashBlocks` from any initial object. -/
theorem hashBlocks_eq (v : Sha512Ctx) (rv Av : BitVec 256) (msgLen : BitVec 64)
    (mv : BitVec (8 * msgLen.toNat)) :
    hashBlocks rv Av msgLen mv =
      2 * BCM_sha512_update.cores (BCM_sha512_init.spec v) 32#64 +
        2 *
          BCM_sha512_update.cores (BCM_sha512_update.spec (BCM_sha512_init.spec v) 32#64 rv) 32#64 +
        2 *
          BCM_sha512_update.cores
            (BCM_sha512_update.spec (BCM_sha512_update.spec (BCM_sha512_init.spec v) 32#64 rv) 32#64
              Av)
            msgLen +
        (2 *
            sha512_final_impl.cores
              (BCM_sha512_update.spec
                (BCM_sha512_update.spec (BCM_sha512_update.spec (BCM_sha512_init.spec v) 32#64 rv)
                  32#64 Av)
                msgLen mv) +
          10) := by
  have h₁ : (BCM_sha512_init.spec (Sha512Ctx.ofBits 0 0)).num = (BCM_sha512_init.spec v).num := rfl
  have h₂ := num_update h₁ 32#64 rv rv
  have h₃ := num_update h₂ 32#64 Av Av
  have h₄ := num_update h₃ msgLen mv mv
  simp only [hashBlocks, cores_congr h₁, cores_congr h₂, cores_congr h₃, final_cores_congr h₄]

/-- The `== 0` test zero-extended: `1` or `0`. -/
theorem setWidth_ofBool_beq (x : BitVec 32) :
    BitVec.setWidth 32 (BitVec.ofBool (x == 0#32)) = if x = 0#32 then 1#32 else 0#32 := by
  by_cases h : x = 0#32
  · simp [h]
  · have : (x == 0#32) = false := by simpa using h
    simp [this, h]

/-- The digest's bits, reduced, of an object that absorbed `r ‖ A ‖ msg`: `hram`. -/
theorem hram_eq {v : Sha512Ctx} {rv Av : BitVec 256} {msgLen : BitVec 64}
    {mv : BitVec (8 * msgLen.toNat)}
    (h : v.Absorbed ([] ++ bytesLE rv ++ bytesLE Av ++ bytesLE mv)) :
    x25519_sc_reduce.spec
        (Firedancer.Words8.bits
          ((sha512_final_impl.spec v).h.map Firedancer.Ref.fd_ulong_bswap.spec)) =
      hram rv Av msgLen mv := by
  have hl : ([] ++ bytesLE rv ++ bytesLE Av ++ bytesLE mv).length < 2 ^ 96 := by
    simp only [List.nil_append, List.length_append, _root_.Ed25519.length_bytesLE]
    have := msgLen.isLt
    omega
  have e := h.final hl
  rw [List.nil_append] at e
  unfold hram
  congr 1
  rw [← e, _root_.Ed25519.natLE_bytesLE (n := 64), BitVec.ofNat_toNat, BitVec.setWidth_eq]

/-- `BCM_sha512_update` of no bytes returns `0` and changes nothing; `data` is not read. -/
theorem BCM_sha512_update.call_eq_zero (c data : Pointer) (s : GlobalState) (hwf : s.WF) :
    BCM_sha512_update.call (BCM_sha512_update.args (.value c) (.value data) (.value 0#64)) s =
      .value (.cons (.value 0#32) .nil, s) := by
  func_init
  block_init
  iterate 10 step_pure
  finish_block
  block_init
  finish_block
  rw [hS]

/-- `SHA512_Update` of no bytes returns `1` and changes nothing; `data` is not read. -/
theorem SHA512_Update.call_eq_zero (c data : Pointer) (s : GlobalState) (hwf : s.WF) :
    SHA512_Update.call (SHA512_Update.args (.value c) (.value data) (.value 0#64)) s =
      .value (.cons (.value 1#32) .nil, s) := by
  func_init
  block_init
  step_pure
  step_call using BCM_sha512_update.call_eq_zero
  finish_block
  rw [hS]

/-- `fe_neg.call_eq` with the limbs read given. -/
theorem fe_neg_of (h f : Pointer) (s : GlobalState) (hwf : s.WF) (hh : s.mem.LimbsRoom h)
    (hf : s.mem.LimbsFit f) {V : Fin 5 → BitVec 64} (hv : s.mem.readLimbs f = V) :
    fe_neg.call (fe_neg.args (.value h) (.value f)) s =
      .value
        (.nil, { s with mem := s.mem.storeLimbs h (Firedancer.Ref.fiat_25519_opp.spec V) }) := by
  rw [fe_neg.call_eq h f s hwf hh hf, hv]

/-- `x25519_ge_frombytes_vartime.call_eq` where decoding fails. -/
theorem frombytes_none (h buf : Pointer) (s : GlobalState) (hwf : s.WF) (hh : s.mem.PointRoom h)
    (hbuf : Fits s.mem buf (8 * 32)) (hbuf_off : ¬buf.offset.uaddOverflow 32#64)
    (hsep : h.id ≠ buf.id) (hd : x25519_ge_frombytes_vartime.spec (s.mem.readAt buf 256) = none) :
    x25519_ge_frombytes_vartime.call (x25519_ge_frombytes_vartime.args (.value h) (.value buf)) s =
      .value
        (.cons (.value 0#32) .nil,
          {
            alloc :=
              ⟨s.alloc.nextFreeBlock + x25519_ge_frombytes_vartime.blocks (s.mem.readAt buf 256)⟩,
            mem :=
              s.mem.storeP2 h
                ⟨x25519_ge_frombytes_vartime.x (s.mem.readAt buf 256),
                  x25519_ge_frombytes_vartime.y (s.mem.readAt buf 256), fe_1.spec⟩ }) := by
  rw [x25519_ge_frombytes_vartime.call_eq h buf s hwf hh hbuf hbuf_off hsep, hd]
  rfl

/-- `x25519_ge_frombytes_vartime.call_eq` where it decodes `P`. -/
theorem frombytes_some (h buf : Pointer) (s : GlobalState) (hwf : s.WF) (hh : s.mem.PointRoom h)
    (hbuf : Fits s.mem buf (8 * 32)) (hbuf_off : ¬buf.offset.uaddOverflow 32#64)
    (hsep : h.id ≠ buf.id) {P : GeP3}
    (hd : x25519_ge_frombytes_vartime.spec (s.mem.readAt buf 256) = some P) :
    x25519_ge_frombytes_vartime.call (x25519_ge_frombytes_vartime.args (.value h) (.value buf)) s =
      .value
        (.cons (.value 1#32) .nil,
          {
            alloc :=
              ⟨s.alloc.nextFreeBlock + x25519_ge_frombytes_vartime.blocks (s.mem.readAt buf 256)⟩,
            mem := s.mem.storeP3 h P }) := by
  rw [x25519_ge_frombytes_vartime.call_eq h buf s hwf hh hbuf hbuf_off hsep, hd]
  rfl

attribute [local mlir_read] MemoryState.readShaCtx_storeShaCtx_self

/-- Another object's lifetime starting keeps the hash object. -/
theorem MemoryState.readShaCtx_lifetimeStart_of_id_ne {m : MemoryState} {p c : Pointer}
    (h : c.id ≠ p.id) : (m.lifetimeStart p).readShaCtx c = m.readShaCtx c := by
  simp only [MemoryState.readShaCtx, MemoryState.readAt_lifetimeStart]
  congr 1
  simp only [MemoryState.definedAt, MemoryState.lifetimeStart, MemoryState.setLifetime,
    MemoryState.getElem?_modifyBlock_ne h]

/-- Limbs in another block than the hash object. -/
theorem MemoryState.readLimbs_storeShaCtx_of_id_ne {m : MemoryState} {q c : Pointer} {v : Sha512Ctx}
    (h : q.id ≠ c.id) : (m.storeShaCtx c v).readLimbs q = m.readLimbs q := by
  funext i
  fin_cases i <;> simp only [MemoryState.readLimbs] <;>
    exact MemoryState.readAt_storeShaCtx_of_id_ne h

/-- A `ge_p3` in another block than the hash object. -/
theorem MemoryState.readP3_storeShaCtx_of_id_ne {m : MemoryState} {q c : Pointer} {v : Sha512Ctx}
    (h : q.id ≠ c.id) : (m.storeShaCtx c v).readP3 q = m.readP3 q := by
  have h' (k : BitVec 64) : (q.add k).id ≠ c.id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readP3, MemoryState.readLimbs_storeShaCtx_of_id_ne h,
    MemoryState.readLimbs_storeShaCtx_of_id_ne (h' _)]

/-- A `ge_p3` in another block than the digest's words. -/
theorem MemoryState.readP3_storeWords8_of_id_ne {m : MemoryState} {p q : Pointer}
    {v : Vector (BitVec 64) 8} (h : p.id ≠ q.id) : (m.storeWords8 p v).readP3 q = m.readP3 q := by
  have h' (k : BitVec 64) : (p.add k).id ≠ q.id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.storeWords8, MemoryState.readP3_storeAt_of_id_ne h,
    MemoryState.readP3_storeAt_of_id_ne (h' _)]

/-- The hash object stored in the frame is gone once it is erased. -/
theorem MemoryState.eraseFrom_storeShaCtx_of_le {m : MemoryState} {c : Pointer} {v : Sha512Ctx}
    (h : n ≤ c.id.id) : (m.storeShaCtx c v).eraseFrom n = m.eraseFrom n :=
  MemoryState.eraseFrom_storeDef_of_le h

attribute [local mlir_erase high] MemoryState.eraseFrom_storeShaCtx_of_le
  MemoryState.eraseFrom_storeWords8_of_le

attribute [local mlir_read] MemoryState.readShaCtx_lifetimeStart_of_id_ne
  MemoryState.readP3_storeShaCtx_of_id_ne MemoryState.readP3_storeWords8_of_id_ne
  MemoryState.readAt_storeWords8_self

/-- Limbs in another block than the hash object stay known. -/
theorem MemoryState.LimbsFit.storeShaCtx {m : MemoryState} {q c : Pointer} {v : Sha512Ctx}
    (h : m.LimbsFit q) (hne : q.id ≠ c.id) : (m.storeShaCtx c v).LimbsFit q :=
  have hne' (k : BitVec 64) : (q.add k).id ≠ c.id := by simpa [Pointer.add_id] using hne
  ⟨h.1, Fits.storeShaCtx h.2.1 hne, Fits.storeShaCtx h.2.2.1 (hne' _),
    Fits.storeShaCtx h.2.2.2.1 (hne' _), Fits.storeShaCtx h.2.2.2.2.1 (hne' _),
    Fits.storeShaCtx h.2.2.2.2.2 (hne' _)⟩

/-- A point in another block than the hash object stays known. -/
theorem MemoryState.PointFit.storeShaCtx {m : MemoryState} {q c : Pointer} {v : Sha512Ctx}
    (h : m.PointFit q) (hne : q.id ≠ c.id) : (m.storeShaCtx c v).PointFit q :=
  have hne' (k : BitVec 64) : (q.add k).id ≠ c.id := by simpa [Pointer.add_id] using hne
  ⟨h.1, MemoryState.LimbsFit.storeShaCtx h.2.1 hne,
    MemoryState.LimbsFit.storeShaCtx h.2.2.1 (hne' _),
    MemoryState.LimbsFit.storeShaCtx h.2.2.2.1 (hne' _),
    MemoryState.LimbsFit.storeShaCtx h.2.2.2.2 (hne' _)⟩

/-- A point stays known past the digest's words. -/
theorem MemoryState.PointFit.storeWords8 {m : MemoryState} {p q : Pointer}
    {v : Vector (BitVec 64) 8} (h : m.PointFit q) : (m.storeWords8 p v).PointFit q :=
  h.of_imp Fits.storeWords8

attribute [local mlir_transport] MemoryState.PointFit.storeShaCtx MemoryState.PointFit.storeWords8

/-- The accepted path's objects: blocks apart, from their blocks' starts, in the frame from `N`
on. -/
structure AccLayout (msg sig pk A t pkcopy rcopy scopy ctx h R rcheck : Pointer) (N : Nat) :
    Prop where
  msg_ctx : msg.id ≠ ctx.id
  sig_ctx : sig.id ≠ ctx.id
  pk_ctx : pk.id ≠ ctx.id
  msg_h : msg.id ≠ h.id
  sig_h : sig.id ≠ h.id
  pk_h : pk.id ≠ h.id
  msg_R : msg.id ≠ R.id
  sig_R : sig.id ≠ R.id
  pk_R : pk.id ≠ R.id
  msg_rc : msg.id ≠ rcheck.id
  sig_rc : sig.id ≠ rcheck.id
  pk_rc : pk.id ≠ rcheck.id
  A_ctx : A.id ≠ ctx.id
  A_h : A.id ≠ h.id
  A_R : A.id ≠ R.id
  A_rc : A.id ≠ rcheck.id
  s_ctx : scopy.id ≠ ctx.id
  s_h : scopy.id ≠ h.id
  s_R : scopy.id ≠ R.id
  s_rc : scopy.id ≠ rcheck.id
  r_ctx : rcopy.id ≠ ctx.id
  r_h : rcopy.id ≠ h.id
  r_R : rcopy.id ≠ R.id
  r_rc : rcopy.id ≠ rcheck.id
  h_ctx : h.id ≠ ctx.id
  h_R : h.id ≠ R.id
  R_rc : R.id ≠ rcheck.id
  ctxo : ctx.offset = 0
  ho : h.offset = 0
  Ro : R.offset = 0
  rco : rcheck.offset = 0
  so : scopy.offset = 0
  ro : rcopy.offset = 0
  NA : N ≤ A.id.id
  Nt : N ≤ t.id.id
  Npk : N ≤ pkcopy.id.id
  Nr : N ≤ rcopy.id.id
  Ns : N ≤ scopy.id.id
  Nctx : N ≤ ctx.id.id
  Nh : N ≤ h.id.id
  NR : N ≤ R.id.id
  Nrc : N ≤ rcheck.id.id

/-- `^bb8` on: the hash, `h` reduced, `[h](-A) + [S] B`, its encoding compared with `r`; the
locals' lifetimes end and `1` or `0` is returned. -/
theorem accept_run (msg : Pointer) (msgLen : BitVec 64)
    (sig pk A t pkcopy rcopy scopy ctx h R rcheck : Pointer) (N : Nat)
    (hL : AccLayout msg sig pk A t pkcopy rcopy scopy ctx h R rcheck N)
    (mv : BitVec (8 * msgLen.toNat)) (rv Sv Av : BitVec 256) (PA : GeP3) (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs :
      E.args =
        (args (.value Pointer.null) (.value 0#64) (.value msg) (.value msgLen) (.value sig)
            (.value pk)).get)
    (hR :
      E ⊨ [%467 := 0#32, %468 := 32#64, %473 := A, %474 := t, %475 := pkcopy, %476 := rcopy, %477 :=
        scopy, %478 := ctx, %479 := h, %480 := R, %481 := rcheck])
    (hwf : S.WF) (hmsg : Fits S.mem msg (8 * msgLen.toNat))
    (hmsg_off : ¬msg.offset.uaddOverflow msgLen) (hsig : Fits S.mem sig 512)
    (hsig_off : ¬sig.offset.uaddOverflow 64#64) (hpk : Fits S.mem pk 256)
    (hpk_off : ¬pk.offset.uaddOverflow 32#64) (hmv : S.mem.readAt msg (8 * msgLen.toNat) = mv)
    (hrv : S.mem.readAt sig 256 = rv) (hAv : S.mem.readAt pk 256 = Av) (hA : S.mem.PointFit A)
    (hAP : S.mem.readP3 A = negA PA) (hrc : Fits S.mem rcopy 256)
    (hrcv : S.mem.readAt rcopy 256 = rv) (hsc : Fits S.mem scopy 256)
    (hscv : S.mem.readAt scopy 256 = Sv) (hctx : InBounds S.mem ctx 1664)
    (hh : InBounds S.mem h 512) (hRb : InBounds S.mem R 960) (hrcb : InBounds S.mem rcheck 256)
    (hdh : ge_double_scalarmult_vartime.Digits (hram rv Av msgLen mv))
    (hdS : ge_double_scalarmult_vartime.Digits Sv)
    (hok : msgLen.toNat < 64 ∨ BCM_sha512_update.BulkOk (msgLen - 64#64)) :
    (ed25519_verify.runFrom E ^bb8 S >>= fun p =>
        PoisonOr.value (p.1, ({ alloc := p.2.alloc, mem := p.2.mem.eraseFrom N } : GlobalState))) =
      .value
        (.cons
            (.value
              (if
                  CRYPTO_memcmp.spec
                      (x25519_ge_tobytes.spec
                        (ge_double_scalarmult_vartime.spec (hram rv Av msgLen mv) (negA PA) Sv))
                      rv 32 =
                    0#32 then
                1#32
              else 0#32))
            .nil,
          ({  alloc :=
                {
                  nextFreeBlock :=
                    S.alloc.nextFreeBlock + hashBlocks rv Av msgLen mv +
                      ge_double_scalarmult_vartime.blocks (hram rv Av msgLen mv) Sv +
                      51 }
              mem := S.mem.eraseFrom N } : GlobalState)) := by
  obtain
    ⟨hmc, hsc', hpc, hmh, hsh, hph, hmR, hsR, hpR, hmrc, hsrc, hprc, hAc, hAh, hAR, hArc, hsctx,
      hsh', hsR', hsrc', hrctx, hrh, hrR, hrrc, hhc, hhR, hRrc, hctxo, hho, hRo, hrco, hso, hro,
      hNA, hNt, hNpk, hNr, hNs, hNctx, hNh, hNR, hNrc⟩ :=
    hL
  block_init
  -- SHA512_Init(&hash_ctx); SHA512_Update(&hash_ctx, hash_prefix, 0);
  step_pure
  obtain ⟨v₀, hv₀⟩ : ∃ v, S.mem.readShaCtx ctx = v := ⟨_, rfl⟩
  step_call using SHA512_Init.call_eq
  step_call using SHA512_Update.call_eq_zero
  -- the bytes each update absorbs, and their bulks `Ok`
  have ha₁ := Sha512Ctx.absorbed_init v₀
  have hok₁ : BCM_sha512_update.Ok (BCM_sha512_init.spec v₀) 32#64 :=
    .inr (by simp [BCM_sha512_update.RestOk, BCM_sha512_update.BulkOk, BCM_sha512_init.spec])
  have hsig32 : ¬sig.offset.uaddOverflow 32#64 := BitVec.not_uaddOverflow_of_le hsig_off (by decide)
  clear hv₀
  -- SHA512_Update(&hash_ctx, signature, 32); SHA512_Update(&hash_ctx, public_key, 32);
  step_call using
    (SHA512_Update.call_eq (hv := (congrArg Sha512Ctx.Valid hread_ctx).mpr ha₁.valid) (hok :=
      (congrArg (BCM_sha512_update.Ok · 32#64) hread_ctx).mpr hok₁))
  have ha₂ := ha₁.update 32#64 rv hok₁
  have hok₂ :
    BCM_sha512_update.Ok (BCM_sha512_update.spec (BCM_sha512_init.spec v₀) 32#64 rv) 32#64 :=
    ok_of_num (k := 32)
      (by
        rw [ha₂.num]; simp)
      (by decide) (by decide) (.inl (by decide))
  step_call using
    (SHA512_Update.call_eq (hv := (congrArg Sha512Ctx.Valid hread_ctx).mpr ha₂.valid) (hok :=
      (congrArg (BCM_sha512_update.Ok · 32#64) hread_ctx).mpr hok₂))
  have ha₃ := ha₂.update 32#64 Av hok₂
  have hok₃ :
    BCM_sha512_update.Ok
      (BCM_sha512_update.spec (BCM_sha512_update.spec (BCM_sha512_init.spec v₀) 32#64 rv) 32#64 Av)
      msgLen :=
    ok_of_num (k := 64)
      (by
        rw [ha₃.num]; simp)
      (by decide) (by decide) (by simpa using hok)
  -- SHA512_Update(&hash_ctx, message, message_len); SHA512_Final(h, &hash_ctx);
  step_call using
    (SHA512_Update.call_eq (hv := (congrArg Sha512Ctx.Valid hread_ctx).mpr ha₃.valid) (hok :=
      (congrArg (BCM_sha512_update.Ok · msgLen) hread_ctx).mpr hok₃))
  have ha₄ := ha₃.update msgLen mv hok₃
  have hch : ctx.id ≠ h.id := hhc.symm
  step_pure
  have hh_w := MemoryState.Words8Room.of_room hroom_h hho
  have hh_o : ¬h.offset.uaddOverflow 64#64 := by simp [BitVec.uaddOverflow, hho]
  step_call using
    (SHA512_Final.call_eq (hv := (congrArg Sha512Ctx.Valid hread_ctx).mpr ha₄.valid) (hmd :=
      (congrArg Sha512Ctx.mdLen hread_ctx).trans ha₄.mdLen))
  have hh_f : Fits S.mem h 512 := hh_w.fits
  -- x25519_sc_reduce(h);
  step_call using x25519_sc_reduce.call_eq
  rw [hram_eq ha₄] at hread_h
  clear hread_ctx ha₁ ha₂ ha₃ ha₄ hok₁ hok₂ hok₃ hh_w hh_f
  -- ge_double_scalarmult_vartime(&R, h, &A, scopy);
  step_pure
  have hR_f := MemoryState.Fe3Room.of_room hroom_R hRo
  have hh_o32 : ¬h.offset.uaddOverflow 32#64 := by simp [BitVec.uaddOverflow, hho]
  have hs_o32 : ¬scopy.offset.uaddOverflow 32#64 := by simp [BitVec.uaddOverflow, hso]
  step_call using
    (ge_double_scalarmult_vartime.call_eq (hda := (congrArg _ hread_h).mpr hdh) (hdb :=
      (congrArg _ hscv).mpr hdS))
  -- x25519_ge_tobytes(rcheck, &R);
  step_pure
  step_call using x25519_ge_tobytes.call_eq
  -- return CRYPTO_memcmp(rcheck, rcopy, sizeof(rcheck)) == 0;
  step_call using CRYPTO_memcmp.call_eq
  iterate 6 step_pure
  finish_block
  block_init
  iterate 4 step_pure
  finish_block
  block_init
  step_pure
  finish_block
  rw [setWidth_ofBool_beq, hashBlocks_eq v₀, hS]
  dsimp only
  erase_frame
  simp only [Nat.add_assoc]

/-- `^bb9` with `0`: the locals' lifetimes end and `0` is returned. -/
theorem reject_tail (t pkcopy rcopy scopy A : Pointer) (N : Nat)
    (hN : N ≤ t.id.id ∧ N ≤ pkcopy.id.id ∧ N ≤ rcopy.id.id ∧ N ≤ scopy.id.id ∧ N ≤ A.id.id)
    (S : GlobalState) (E : ⟪Γ⟫)
    (hR : E ⊨ [%473 := A, %474 := t, %475 := pkcopy, %476 := rcopy, %477 := scopy, %514 := 0#32]) :
    (ed25519_verify.runFrom E ^bb9 S >>= fun p =>
        PoisonOr.value (p.1, ({ alloc := p.2.alloc, mem := p.2.mem.eraseFrom N } : GlobalState))) =
      .value
        (.cons (.value 0#32) .nil,
          ({ alloc := S.alloc, mem := S.mem.eraseFrom N } : GlobalState)) := by
  obtain ⟨h1, h2, h3, h4, h5⟩ := hN
  block_init
  iterate 4 step_pure
  finish_block
  block_init
  step_pure
  finish_block
  rw [hS]
  dsimp only
  rw [MemoryState.eraseFrom_lifetimeEnd_of_le h5, MemoryState.eraseFrom_lifetimeEnd_of_le h1,
    MemoryState.eraseFrom_lifetimeEnd_of_le h2, MemoryState.eraseFrom_lifetimeEnd_of_le h3,
    MemoryState.eraseFrom_lifetimeEnd_of_le h4]

-- eleven blocks and four exits in one proof: past the default budget
set_option maxHeartbeats 400000 in
/-- `ed25519_verify` on an empty prefix returns `spec` of the message, the signature `r ‖ S` at
`sig` and the key at `pk`; its frame is freed, the memory unchanged. -/
public theorem ed25519_verify.call_eq (msg : Pointer) (msgLen : BitVec 64) (sig pk : Pointer)
    (s : GlobalState) (hwf : s.WF) (hmsg : Fits s.mem msg (8 * msgLen.toNat))
    (hmsg_off : ¬msg.offset.uaddOverflow msgLen) (hsig : Fits s.mem sig 512)
    (hsig_off : ¬sig.offset.uaddOverflow 64#64) (hpk : Fits s.mem pk 256)
    (hpk_off : ¬pk.offset.uaddOverflow 32#64)
    (hok : msgLen.toNat < 64 ∨ BCM_sha512_update.BulkOk (msgLen - 64#64)) :
    ed25519_verify.call
        (ed25519_verify.args (.value Pointer.null) (.value 0#64) (.value msg) (.value msgLen)
          (.value sig) (.value pk))
        s =
      .value
        (.cons
            (.value
              (spec msgLen (s.mem.readAt msg (8 * msgLen.toNat)) (s.mem.readAt sig 256)
                (s.mem.readAt (sig.add 32#64) 256) (s.mem.readAt pk 256)))
            .nil,
          {
            alloc :=
              ⟨s.alloc.nextFreeBlock +
                  blocks msgLen (s.mem.readAt msg (8 * msgLen.toNat)) (s.mem.readAt sig 256)
                    (s.mem.readAt (sig.add 32#64) 256) (s.mem.readAt pk 256)⟩,
            mem := s.mem }) := by
  generalize hret :
    spec msgLen (s.mem.readAt msg (8 * msgLen.toNat)) (s.mem.readAt sig 256)
      (s.mem.readAt (sig.add 32#64) 256) (s.mem.readAt pk 256) =
    ret
  generalize hk :
    blocks msgLen (s.mem.readAt msg (8 * msgLen.toNat)) (s.mem.readAt sig 256)
      (s.mem.readAt (sig.add 32#64) 256) (s.mem.readAt pk 256) =
    k
  -- the inputs, named, and the byte the first check reads
  have hS63 :
    Fits s.mem (sig.add 63#64) 8 ∧
      s.mem.readAt (sig.add 63#64) 8 = (s.mem.readAt (sig.add 32#64) 256).extractLsb' 248 8 := by
    have h32 :=
      MemoryState.readAt_add_of_readAt (off := 32#64) (w := 256) hsig.inBounds
        (by
          simp [BitVec.uaddOverflow] at hsig_off ⊢; omega)
        (by decide) rfl
    have h63 :=
      MemoryState.readAt_add_of_readAt (off := 63#64) (w := 8) hsig.inBounds
        (by
          simp [BitVec.uaddOverflow] at hsig_off ⊢; omega)
        (by decide) rfl
    refine
      ⟨Fits.add_of_le
          (by
            simp [BitVec.uaddOverflow] at hsig_off ⊢; omega)
          (by decide) hsig,
        ?_⟩
    rw [h63, h32, BitVec.extractLsb'_extractLsb'_add (by decide)]
    rfl
  obtain ⟨hf63, hr63⟩ := hS63
  obtain ⟨mv, hmv⟩ : ∃ x, s.mem.readAt msg (8 * msgLen.toNat) = x := ⟨_, rfl⟩
  obtain ⟨rv, hrv⟩ : ∃ x, s.mem.readAt sig 256 = x := ⟨_, rfl⟩
  obtain ⟨Sv, hSv⟩ : ∃ x, s.mem.readAt (sig.add 32#64) 256 = x := ⟨_, rfl⟩
  obtain ⟨Av, hAv⟩ : ∃ x, s.mem.readAt pk 256 = x := ⟨_, rfl⟩
  rw [hmv, hrv, hSv, hAv] at hret hk
  rw [hSv] at hr63
  func_init
  have hr63₀ : S₀.mem.readAt (sig.add 63#64) 8 = Sv.extractLsb' 248 8 := hS ▸ hr63
  have hAv₀ : S₀.mem.readAt pk 256 = Av := hS ▸ hAv
  have hSv₀ : S₀.mem.readAt (sig.add 32#64) 256 = Sv := hS ▸ hSv
  block_init
  iterate 8 step_pure
  step_alloca with A
  step_alloca with t
  step_alloca with pkcopy
  step_alloca with rcopy
  step_alloca with scopy
  step_alloca with ctx
  step_alloca with h
  step_alloca with R
  step_alloca with rcheck
  step_pure
  -- if ((signature[63] & 224) != 0 || !x25519_ge_frombytes_vartime(&A, public_key)) return 0;
  step_pure
  step_load consuming hf63 hr63
  step_pure
  finish_block
  case isFalse =>
    -- `S`'s top bits set: `0`
    rw [hr63₀] at hbr
    block_init
    step_pure
    finish_block
    subst hS
    erase_frame
    rw [← hret, ← hk, (spec_top hbr).1, (spec_top hbr).2]
    simp [GlobalState.alloca]
  rw [hr63₀] at hbr
  have htop := hbr
  have hA_pt := MemoryState.PointRoom.of_room hroom_A hA_off
  clear hroom_A hA_bounds
  rcases hfb : x25519_ge_frombytes_vartime.spec Av with _ | PA
  · block_init
    step_call using
      (frombytes_none (s := S) (hd := by
        rw [hAv]; exact hfb))
    step_pure
    finish_block
    block_init
    step_pure
    finish_block
    subst hS
    erase_frame
    rw [← hret, ← hk, (spec_none htop hfb).1, (spec_none htop hfb).2]
    simp [GlobalState.alloca]
    omega
  block_init
  step_call using
    (frombytes_some (s := S) (hd := by
      rw [hAv]; exact hfb))
  have hA_room : S.mem.PointRoom A := hA_pt.room
  step_pure
  finish_block
  -- fe_neg(&t, &A.X); fe_carry(&A.X, &t); fe_neg(&t, &A.T); fe_carry(&A.T, &t);
  block_init
  step_pure
  have ht_l := MemoryState.LimbsRoom.of_room hroom_t ht_off
  clear hroom_t ht_bounds
  step_call using fe_neg.call_eq
  step_call using fe_carry.call_eq
  step_pure
  step_call using (fe_neg_of (V := PA.T))
  step_call using fe_carry.call_eq
  have hAP : S.mem.readP3 A = negA PA := by
    simp only [MemoryState.readP3, hread_A, hread_A_40, hread_A_80, hread_A_120, negA]
  clear hread_A hread_A_40 hread_A_80 hread_A_120 hread_t
  -- OPENSSL_memcpy(pkcopy, public_key, 32); … rcopy, signature …; … scopy, signature + 32 …
  step_pure
  step_call using OPENSSL_memcpy.call_eq
  step_pure
  step_call using OPENSSL_memcpy.call_eq
  step_pure
  step_pure
  step_call using OPENSSL_memcpy.call_eq
  rw [hSv₀] at hread_scopy
  have hAL : AccLayout msg sig pk A t pkcopy rcopy scopy ctx h R rcheck S₀.alloc.nextFreeBlock :=
    ⟨by mem_fact, by mem_fact, by mem_fact, by mem_fact, by mem_fact, by mem_fact, by mem_fact, by
      mem_fact, by mem_fact, by mem_fact, by mem_fact, by mem_fact, by mem_fact, by mem_fact, by
      mem_fact, by mem_fact, by mem_fact, by mem_fact, by mem_fact, by mem_fact, by mem_fact, by
      mem_fact, by mem_fact, by mem_fact, by mem_fact, by mem_fact, by mem_fact, hctx_off, hh_off,
      hR_off, hrcheck_off, hscopy_off, hrcopy_off, by slot_bound, by slot_bound, by slot_bound, by
      slot_bound, by slot_bound, by slot_bound, by slot_bound, by slot_bound, by slot_bound⟩
  -- for (size_t i = 3;; i--) { uint64_t word = CRYPTO_load_u64_le(scopy + i * 8); … }
  step_pure
  step_call using CRYPTO_load_u64_le.call_eq
  step_pure
  finish_block
  case isTrue =>
    -- `S`'s top word above `kOrder`'s: `0`
    have hs : sOk Sv = false ∧ sBlocks Sv = 1 := by simp [sOk, sBlocks, K3, hbr]
    clear hbr
    reject_exit
    rw [← hret, ← hk, (spec_sbad htop hfb hs.1).1, (spec_sbad htop hfb hs.1).2, hs.2]
    simp [GlobalState.alloca]
    omega
  have h3 := hbr
  block_init
  step_pure
  finish_block
  case isFalse =>
    -- below: accepted
    have hs : sOk Sv = true ∧ sBlocks Sv = 1 := by simp [sOk, sBlocks, K3, h3, hbr]
    accept
  have h3' := hbr
  block_init
  step_pure
  step_call using CRYPTO_load_u64_le.call_eq
  step_pure
  finish_block
  case
    isFalse =>
    have hs : sOk Sv = false ∧ sBlocks Sv = 2 := by simp [sOk, sBlocks, K3, K2, h3', hbr]
    clear h3 h3' hbr
    reject_exit
    rw [← hret, ← hk, (spec_sbad htop hfb hs.1).1, (spec_sbad htop hfb hs.1).2, hs.2]
    simp [GlobalState.alloca]
    omega
  have h2 := hbr
  block_init
  step_pure
  step_call using CRYPTO_load_u64_le.call_eq
  step_pure
  finish_block
  case
    isTrue =>
    have hs : sOk Sv = false ∧ sBlocks Sv = 3 := by simp [sOk, sBlocks, K3, K2, K1, h3', h2, hbr]
    clear h3 h3' h2 hbr
    reject_exit
    rw [← hret, ← hk, (spec_sbad htop hfb hs.1).1, (spec_sbad htop hfb hs.1).2, hs.2]
    simp [GlobalState.alloca]
    omega
  have h1 := hbr
  block_init
  step_pure
  finish_block
  case
    isFalse =>
    have hs : sOk Sv = true ∧ sBlocks Sv = 3 := by simp [sOk, sBlocks, K3, K2, K1, h3', h2, h1, hbr]
    accept
  have h1' := hbr
  block_init
  step_call using CRYPTO_load_u64_le.call_eq
  step_pure
  finish_block
  case isTrue =>
    rw [BitVec.setWidth_eq_extractLsb' (by decide)] at hbr
    have hs : sOk Sv = false ∧ sBlocks Sv = 4 := by
      simp [sOk, sBlocks, K3, K2, K1, K0m1, h3', h2, h1', hbr]
    clear h3 h3' h2 h1 h1' hbr
    reject_exit
    rw [← hret, ← hk, (spec_sbad htop hfb hs.1).1, (spec_sbad htop hfb hs.1).2, hs.2]
    simp [GlobalState.alloca]
    omega
  rw [BitVec.setWidth_eq_extractLsb' (by decide)] at hbr
  have hs : sOk Sv = true ∧ sBlocks Sv = 4 := by
    simp [sOk, sBlocks, K3, K2, K1, K0m1, h3', h2, h1', hbr]
  accept

end Proof

end MLIR.Boringssl
