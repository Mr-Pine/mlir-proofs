module

public import MLIR.Run.Tactic
public import Firedancer.Common.Tactics
public import Firedancer.Common.Dsmb
public import Boringssl.Common.Point
public import Sodium.Common.Sha512
public import Sodium.sc25519_is_canonical
public import Sodium.sc25519_reduce
public import Sodium.ge25519_has_small_order
public import Sodium.ge25519_is_canonical
public import Sodium.ge25519_frombytes_negate_vartime
public import Sodium._crypto_sign_ed25519_ref10_hinit
public import Sodium.crypto_hash_sha512_update
public import Sodium.crypto_hash_sha512_final
public import Sodium.ge25519_double_scalarmult_vartime
public import Sodium.ge25519_tobytes
public import Sodium.sodium_memcmp
public import Sodium.Math.Sha512
public import Ed25519.Decode
import Mathlib.Tactic.FinCases
import Mathlib.Data.Fintype.Basic
public import Sodium.Mlir._crypto_sign_ed25519_verify_detached

namespace MLIR.Sodium

open _root_.Ed25519 (natLE bytesLE)

/-! ## Specification -/

@[expose] public section

/-- `crypto_verify_32(x, y)` as its `call_eq` states it: `0` if the 32 bytes at `x` and at `y`
agree, `-1` if not; memory unchanged, the counter advanced by `crypto_verify_n`'s six locals. -/
abbrev crypto_verify_32.Spec : Prop :=
  ∀ (x y : Pointer) (s : GlobalState),
    s.WF →
      Fits s.mem x 256 →
      Fits s.mem y 256 →
      ¬x.offset.uaddOverflow 32#64 →
      ¬y.offset.uaddOverflow 32#64 →
      crypto_verify_32.call (crypto_verify_32.args (.value x) (.value y)) s =
        .value
          (.cons (.value (if s.mem.readAt x 256 = s.mem.readAt y 256 then 0#32 else -1#32)) .nil,
            { alloc := ⟨s.alloc.nextFreeBlock + 6⟩, mem := s.mem })

namespace _crypto_sign_ed25519_verify_detached

/-- `h`: SHA-512 of `r ‖ A ‖ msg`, reduced mod `ℓ` by `sc25519_reduce`. -/
noncomputable def hram (r A : BitVec 256) (mlen : BitVec 64) (msg : BitVec (8 * mlen.toNat)) :
    BitVec 256 :=
  Boringssl.x25519_sc_reduce.spec
    (BitVec.ofNat 512
      (natLE (_root_.Ed25519.Sha512.digest (bytesLE r ++ bytesLE A ++ bytesLE msg))))

/-- The blocks the hash calls allocate: each update's and the final's `tmp64`. -/
def hashBlocks : Nat :=
  1 + 1 + 1 + 1

end _crypto_sign_ed25519_verify_detached

open _crypto_sign_ed25519_verify_detached in
/-- `_crypto_sign_ed25519_verify_detached(sig, m, mlen, pk, 0)` on the signature `r ‖ S`, the
message `msg` and the key `A`, the checks in the C's order: `0` accepts, `-1` rejects. -/
noncomputable def _crypto_sign_ed25519_verify_detached.spec (mlen : BitVec 64)
    (msg : BitVec (8 * mlen.toNat)) (r S A : BitVec 256) : BitVec 32 :=
  if sc25519_is_canonical.spec S = 0#32 then -1#32
  else
    if ge25519_has_small_order.spec r ≠ 0#32 then -1#32
    else
      if ge25519_is_canonical.spec A = 0#32 then -1#32
      else
        if ge25519_has_small_order.spec A ≠ 0#32 then -1#32
        else
          match ge25519_frombytes_negate_vartime.spec A with
          | none => -1#32
          | some P =>
            let rcheck :=
              ge25519_tobytes.spec (ge25519_double_scalarmult_vartime.spec (hram r A mlen msg) P S)
            (if rcheck = r then 0#32 else -1#32) ||| sodium_memcmp.spec 32 r rcheck

open _crypto_sign_ed25519_verify_detached in
/-- The blocks `_crypto_sign_ed25519_verify_detached` allocates, its callees' included: its five
locals, then each call's on the path taken (`17`: `ge25519_tobytes`'s ten, `crypto_verify_32`'s
six, `sodium_memcmp`'s one). -/
noncomputable def _crypto_sign_ed25519_verify_detached.blocks (mlen : BitVec 64)
    (msg : BitVec (8 * mlen.toNat)) (r S A : BitVec 256) : Nat :=
  5 +
    if
        sc25519_is_canonical.spec S = 0#32 ∨
          ge25519_has_small_order.spec r ≠ 0#32 ∨
          ge25519_is_canonical.spec A = 0#32 ∨ ge25519_has_small_order.spec A ≠ 0#32 then
      0
    else
      ge25519_frombytes_negate_vartime.blocks A +
        match ge25519_frombytes_negate_vartime.spec A with
        | none => 0
        | some _ =>
          hashBlocks + ge25519_double_scalarmult_vartime.blocks (hram r A mlen msg) S + 17

end

/-! ## Proof -/

section Proof

set_option hygiene false in
/-- A rejection: `^bb6` returns `-1`, the frame erased; `spec` and `blocks` by the checks `args`. -/
local macro "reject" " [" args:Lean.Parser.Tactic.simpLemma,* "]" : tactic =>
  `(tactic| (
    refine (exit_block hs h rcheck A R S₀.alloc.nextFreeBlock
      ⟨by slot_bound, by slot_bound, by slot_bound, by slot_bound, by slot_bound⟩ _ S E
      (by env_reads) S₀.mem (by rw [hS]; erase_frame)).trans ?_
    rw [← hres, ← hk, hS]
    simp [spec, blocks, GlobalState.alloca, $args,*]))

attribute [local mlir_transport] GlobalState.WF.storeHashState_mk

attribute [local mlir_read] MemoryState.readHashState_storeHashState_self

namespace _crypto_sign_ed25519_verify_detached

/-- `^bb6`: the locals' lifetimes end and `v` is returned; the frame erased, what is left is the
memory without them. -/
theorem exit_block (hs h rcheck A R : Pointer) (N : Nat)
    (hN : N ≤ hs.id.id ∧ N ≤ h.id.id ∧ N ≤ rcheck.id.id ∧ N ≤ A.id.id ∧ N ≤ R.id.id) (v : BitVec 32)
    (S : GlobalState) (E : ⟪Γ⟫)
    (hR : E ⊨ [%3317 := v, %3292 := hs, %3293 := h, %3294 := rcheck, %3295 := A, %3296 := R])
    (M : MemoryState) (he : S.mem.eraseFrom N = M) :
    (_crypto_sign_ed25519_verify_detached.runFrom E ^bb6 S >>= fun p =>
        PoisonOr.value (p.1, ({ alloc := p.2.alloc, mem := p.2.mem.eraseFrom N } : GlobalState))) =
      .value (.cons (.value v) .nil, ({ alloc := S.alloc, mem := M } : GlobalState)) := by
  obtain ⟨h1, h2, h3, h4, h5⟩ := hN
  block_init
  iterate 5 step_pure
  finish_block
  rw [hS]
  dsimp only
  rw [MemoryState.eraseFrom_lifetimeEnd_of_le h1, MemoryState.eraseFrom_lifetimeEnd_of_le h2,
    MemoryState.eraseFrom_lifetimeEnd_of_le h3, MemoryState.eraseFrom_lifetimeEnd_of_le h4,
    MemoryState.eraseFrom_lifetimeEnd_of_le h5, he]

end _crypto_sign_ed25519_verify_detached

/-- Limbs in another block than the hash struct. -/
theorem MemoryState.readLimbs_storeHashState_of_id_ne {m : MemoryState} {q c : Pointer}
    {v : HashState} (h : q.id ≠ c.id) : (m.storeHashState c v).readLimbs q = m.readLimbs q := by
  funext i
  fin_cases i <;> simp only [MemoryState.readLimbs] <;>
    exact MemoryState.readAt_storeHashState_of_id_ne h

/-- A `ge25519_p3` in another block than the hash struct. -/
theorem MemoryState.readP3_storeHashState_of_id_ne {m : MemoryState} {q c : Pointer} {v : HashState}
    (h : q.id ≠ c.id) : (m.storeHashState c v).readP3 q = m.readP3 q := by
  have h' (k : BitVec 64) : (q.add k).id ≠ c.id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readP3, MemoryState.readLimbs_storeHashState_of_id_ne h,
    MemoryState.readLimbs_storeHashState_of_id_ne (h' _)]

/-- Limbs in another block than the hash struct stay known. -/
theorem MemoryState.LimbsFit.storeHashState {m : MemoryState} {q c : Pointer} {v : HashState}
    (h : m.LimbsFit q) (hne : q.id ≠ c.id) : (m.storeHashState c v).LimbsFit q :=
  have hne' (k : BitVec 64) : (q.add k).id ≠ c.id := by simpa [Pointer.add_id] using hne
  ⟨h.1, Fits.storeHashState h.2.1 hne, Fits.storeHashState h.2.2.1 (hne' _),
    Fits.storeHashState h.2.2.2.1 (hne' _), Fits.storeHashState h.2.2.2.2.1 (hne' _),
    Fits.storeHashState h.2.2.2.2.2 (hne' _)⟩

/-- A point in another block than the hash struct stays known. -/
theorem MemoryState.PointFit.storeHashState {m : MemoryState} {q c : Pointer} {v : HashState}
    (h : m.PointFit q) (hne : q.id ≠ c.id) : (m.storeHashState c v).PointFit q :=
  have hne' (k : BitVec 64) : (q.add k).id ≠ c.id := by simpa [Pointer.add_id] using hne
  ⟨h.1, MemoryState.LimbsFit.storeHashState h.2.1 hne,
    MemoryState.LimbsFit.storeHashState h.2.2.1 (hne' _),
    MemoryState.LimbsFit.storeHashState h.2.2.2.1 (hne' _),
    MemoryState.LimbsFit.storeHashState h.2.2.2.2 (hne' _)⟩

attribute [local mlir_read] MemoryState.readP3_storeHashState_of_id_ne

attribute [local mlir_transport] MemoryState.PointFit.storeHashState

/-- `crypto_hash_sha512_update.call_eq` with the struct `v` and the bytes `D` read given. -/
theorem update_of (st inp : Pointer) (inlen : BitVec 64) (s : GlobalState) (hwf : s.WF)
    (hg : s.mem.Globals crypto_hash_sha512_update.globals) (hst : s.mem.HashStateFit st)
    {v : HashState} {D : BitVec (8 * inlen.toNat)} (hv : s.mem.readHashState st = v)
    (hpre : v.Prefix (v.count1.toNat / 8 % 128)) (hin : Fits s.mem inp (8 * inlen.toNat))
    (hino : ¬inp.offset.uaddOverflow inlen) (hsep : inp.id ≠ st.id)
    (hD : s.mem.readAt inp (8 * inlen.toNat) = D) :
    crypto_hash_sha512_update.call
        (crypto_hash_sha512_update.args (.value st) (.value inp) (.value inlen)) s =
      .value
        (.cons (.value 0#32) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1⟩,
            mem := s.mem.storeHashState st (crypto_hash_sha512_update.spec v inlen D) }) := by
  subst hv hD
  exact crypto_hash_sha512_update.call_eq st inp inlen s hwf hg hst hpre hin hino hsep

/-- `crypto_hash_sha512_final.call_eq` with the struct `v` read given. -/
theorem final_of (st out : Pointer) (s : GlobalState) (hwf : s.WF)
    (hg : s.mem.Globals crypto_hash_sha512_final.globals) (hst : s.mem.HashStateFit st)
    {v : HashState} (hv : s.mem.readHashState st = v) (hpre : v.Prefix (SHA512_Pad.r v))
    (hout : Room s.mem out 512) (houto : out.offset.toNat + 64 < 2 ^ 64) (hsep : out.id ≠ st.id) :
    crypto_hash_sha512_final.call (crypto_hash_sha512_final.args (.value st) (.value out)) s =
      .value
        (.cons (.value 0#32) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1⟩,
            mem :=
              (s.mem.storeAt out (crypto_hash_sha512_final.spec v)).storeAt st
                (0 : BitVec (8 * (208#64).toNat)) }) := by
  subst hv
  exact crypto_hash_sha512_final.call_eq st out s hwf hg hst hpre hout houto hsep

/-- `WF` past an update: the counter advanced, the struct stored. -/
theorem GlobalState.WF.storeHashState_mk {s : GlobalState} (h : s.WF) :
    (⟨⟨s.alloc.nextFreeBlock + k⟩, s.mem.storeHashState c v⟩ : GlobalState).WF :=
  GlobalState.WF.storeHashState (s := ⟨⟨s.alloc.nextFreeBlock + k⟩, s.mem⟩)
    (GlobalState.WF.add_blocks h)

/-- `WF` past `final`: the counter advanced, the digest and the zeroed struct stored. -/
theorem GlobalState.WF.storeAt_storeAt_mk {s : GlobalState} {x : BitVec u} {y : BitVec w}
    (h : s.WF) :
    (⟨⟨s.alloc.nextFreeBlock + k⟩, (s.mem.storeAt p x).storeAt q y⟩ : GlobalState).WF :=
  GlobalState.WF.storeAt (s := ⟨_, s.mem.storeAt p x⟩)
    (GlobalState.WF.storeAt (s := ⟨⟨s.alloc.nextFreeBlock + k⟩, s.mem⟩)
      (GlobalState.WF.add_blocks h))

attribute [local mlir_transport] GlobalState.WF.storeHashState_mk
  GlobalState.WF.storeAt_storeAt_mk

/-- The digest's bits, reduced, of a struct that absorbed `r ‖ A ‖ msg`: `hram`. -/
theorem hram_eq {v : HashState} {rv Av : BitVec 256} {mlen : BitVec 64}
    {mv : BitVec (8 * mlen.toNat)} (h : v.Absorbed ([] ++ bytesLE rv ++ bytesLE Av ++ bytesLE mv)) :
    Boringssl.x25519_sc_reduce.spec (crypto_hash_sha512_final.spec v) =
      _crypto_sign_ed25519_verify_detached.hram rv Av mlen mv := by
  have e := h.final
  rw [List.nil_append] at e
  unfold _crypto_sign_ed25519_verify_detached.hram
  congr 1
  rw [← e, _root_.Ed25519.natLE_bytesLE (n := 64), BitVec.ofNat_toNat, BitVec.setWidth_eq]

/-- The struct stored into a block of an erased frame is lost. -/
theorem MemoryState.eraseFrom_storeHashState_of_le {m : MemoryState} {c : Pointer} {v : HashState}
    (h : n ≤ c.id.id) : (m.storeHashState c v).eraseFrom n = m.eraseFrom n :=
  MemoryState.eraseFrom_overlay_of_le h

attribute [local mlir_erase high] MemoryState.eraseFrom_storeHashState_of_le

/-- `ge25519_frombytes_negate_vartime.call_eq` where decoding the bytes `x` fails. -/
theorem frombytes_none (h buf : Pointer) (s : GlobalState) (hwf : s.WF)
    (hg : s.mem.Globals ge25519_frombytes_negate_vartime.globals) (hh : s.mem.PointRoom h)
    (hbuf : Fits s.mem buf 256) (hbuf_off : buf.offset.toNat + 32 < 2 ^ 64) (hsep : h.id ≠ buf.id)
    {x : BitVec 256} (hx : s.mem.readAt buf 256 = x)
    (hd : ge25519_frombytes_negate_vartime.spec x = none) :
    ge25519_frombytes_negate_vartime.call
        (ge25519_frombytes_negate_vartime.args (.value h) (.value buf)) s =
      .value
        (.cons (.value (-1#32)) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + ge25519_frombytes_negate_vartime.blocks x⟩,
            mem :=
              s.mem.storeP2 h
                ⟨ge25519_frombytes_negate_vartime.x x, ge25519_frombytes_negate_vartime.y x,
                  Boringssl.fe_1.spec⟩ }) := by
  rw [ge25519_frombytes_negate_vartime.call_eq h buf s hwf hg hh hbuf hbuf_off hsep, hx, hd]
  rfl

/-- `ge25519_frombytes_negate_vartime.call_eq` where the bytes `x` decode to `P`. -/
theorem frombytes_some (h buf : Pointer) (s : GlobalState) (hwf : s.WF)
    (hg : s.mem.Globals ge25519_frombytes_negate_vartime.globals) (hh : s.mem.PointRoom h)
    (hbuf : Fits s.mem buf 256) (hbuf_off : buf.offset.toNat + 32 < 2 ^ 64) (hsep : h.id ≠ buf.id)
    {x : BitVec 256} {P : GeP3} (hx : s.mem.readAt buf 256 = x)
    (hd : ge25519_frombytes_negate_vartime.spec x = some P) :
    ge25519_frombytes_negate_vartime.call
        (ge25519_frombytes_negate_vartime.args (.value h) (.value buf)) s =
      .value
        (.cons (.value 0#32) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + ge25519_frombytes_negate_vartime.blocks x⟩,
            mem := s.mem.storeP3 h P }) := by
  rw [ge25519_frombytes_negate_vartime.call_eq h buf s hwf hg hh hbuf hbuf_off hsep, hx, hd]
  rfl

open _crypto_sign_ed25519_verify_detached in
/-- `_crypto_sign_ed25519_verify_detached(sig, m, mlen, pk, 0)` returns `spec` of the `mlen` bytes
at `m` and of the signature `r ‖ S` at `sig` and the key at `pk`, `crypto_verify_32` taken as
`crypto_verify_32.Spec` states it; memory is unchanged and the counter advances by `blocks`. The
inputs may alias. -/
public theorem _crypto_sign_ed25519_verify_detached.call_eq (sig m pk : Pointer) (mlen : BitVec 64)
    (s : GlobalState) (hwf : s.WF)
    (hg : s.mem.Globals _crypto_sign_ed25519_verify_detached.globals) (hsig : Fits s.mem sig 512)
    (hsig_off : ¬sig.offset.uaddOverflow 64#64) (hm : Fits s.mem m (8 * mlen.toNat))
    (hm_off : ¬m.offset.uaddOverflow mlen) (hpk : Fits s.mem pk 256)
    (hpk_off : ¬pk.offset.uaddOverflow 32#64) (hv32 : crypto_verify_32.Spec)
    (hdh :
      Boringssl.ge_double_scalarmult_vartime.Digits
        (hram (s.mem.readAt sig 256) (s.mem.readAt pk 256) mlen (s.mem.readAt m (8 * mlen.toNat))))
    (hdS :
      (s.mem.readAt (sig.add 32#64) 256).toNat < Ed25519.ell →
        Boringssl.ge_double_scalarmult_vartime.Digits (s.mem.readAt (sig.add 32#64) 256)) :
    _crypto_sign_ed25519_verify_detached.call
        (_crypto_sign_ed25519_verify_detached.args (.value sig) (.value m) (.value mlen) (.value pk)
          (.value 0#32))
        s =
      .value
        (.cons
            (.value
              (spec mlen (s.mem.readAt m (8 * mlen.toNat)) (s.mem.readAt sig 256)
                (s.mem.readAt (sig.add 32#64) 256) (s.mem.readAt pk 256)))
            .nil,
          {
            alloc :=
              ⟨s.alloc.nextFreeBlock +
                  blocks mlen (s.mem.readAt m (8 * mlen.toNat)) (s.mem.readAt sig 256)
                    (s.mem.readAt (sig.add 32#64) 256) (s.mem.readAt pk 256)⟩,
            mem := s.mem }) := by
  -- the inputs, named before the frame grows
  obtain ⟨rv, hrv⟩ : ∃ x, s.mem.readAt sig 256 = x := ⟨_, rfl⟩
  obtain ⟨Sv, hSv⟩ : ∃ x, s.mem.readAt (sig.add 32#64) 256 = x := ⟨_, rfl⟩
  obtain ⟨Av, hAv⟩ : ∃ x, s.mem.readAt pk 256 = x := ⟨_, rfl⟩
  obtain ⟨mv, hmv⟩ : ∃ x, s.mem.readAt m (8 * mlen.toNat) = x := ⟨_, rfl⟩
  rw [hrv, hAv, hmv] at hdh
  rw [hrv, hSv, hAv, hmv]
  rw [hSv] at hdS
  generalize hres : spec mlen mv rv Sv Av = res
  generalize hk : blocks mlen mv rv Sv Av = k
  have hS32 : Fits s.mem (sig.add 32#64) 256 := by mem_fact
  have hS32_off : ¬(sig.add 32#64).offset.uaddOverflow 32#64 := by
    simp only [BitVec.uaddOverflow, Pointer.add, BitVec.toNat_add, BitVec.toNat_ofNat,
      decide_eq_true_eq, not_le, Nat.reduceMod, Nat.reducePow] at hsig_off ⊢
    omega
  have hpk_lt : pk.offset.toNat + 32 < 2 ^ 64 := by
    simp only [BitVec.uaddOverflow, BitVec.toNat_ofNat, decide_eq_true_eq, not_le, Nat.reduceMod,
      Nat.reducePow] at hpk_off
    omega
  have hsig_off32 : ¬sig.offset.uaddOverflow 32#64 := by
    simp only [BitVec.uaddOverflow, BitVec.toNat_ofNat, decide_eq_true_eq, not_le, Nat.reduceMod,
      Nat.reducePow] at hsig_off ⊢
    omega
  func_init
  have hrv₀ : S₀.mem.readAt sig 256 = rv := hS ▸ hrv
  have hSv₀ : S₀.mem.readAt (sig.add 32#64) 256 = Sv := hS ▸ hSv
  have hAv₀ : S₀.mem.readAt pk 256 = Av := hS ▸ hAv
  have hmv₀ : S₀.mem.readAt m (8 * mlen.toNat) = mv := hS ▸ hmv
  block_init
  iterate 4 step_pure
  -- crypto_hash_sha512_state hs; unsigned char h[64]; unsigned char rcheck[32]; ge25519_p3 A;
  -- ge25519_p2 R;
  step_alloca with hs
  step_alloca with h
  step_alloca with rcheck
  step_alloca with A
  step_alloca with R
  iterate 5 step_pure
  -- sc25519_is_canonical(sig + 32) == 0
  step_pure
  step_call using sc25519_is_canonical.call_eq
  rw [hSv₀] at hE
  step_pure
  finish_block
  case isTrue => reject [hbr]
  have hc1 := hbr
  clear hbr
  -- ge25519_has_small_order(sig) != 0
  block_init
  step_call using ge25519_has_small_order.call_eq
  step_pure
  finish_block
  case isFalse => reject [hc1, hbr]
  have hc2 := hbr
  clear hbr
  -- ge25519_is_canonical(pk) == 0
  block_init
  step_call using ge25519_is_canonical.call_eq
  step_pure
  finish_block
  case isTrue => reject [hc1, hc2, hbr]
  have hc3 := hbr
  clear hbr
  -- ge25519_has_small_order(pk) != 0
  block_init
  step_call using ge25519_has_small_order.call_eq
  step_pure
  finish_block
  case isFalse => reject [hc1, hc2, hc3, hbr]
  have hc4 := hbr
  clear hbr
  -- ge25519_frombytes_negate_vartime(&A, pk) != 0
  block_init
  have hA_pt := MemoryState.PointRoom.of_room hroom_A hA_off
  rcases hP : ge25519_frombytes_negate_vartime.spec Av with _ | P
  case none =>
    step_call using (frombytes_none (hx := hAv) (hd := hP)) consuming hAv hA_pt
    step_pure
    finish_block
    reject [hc1, hc2, hc3, hc4, hP, Nat.add_assoc]
  step_call using (frombytes_some (hx := hAv) (hd := hP)) consuming hA_pt
  step_pure
  finish_block
  -- _crypto_sign_ed25519_ref10_hinit(&hs, prehashed);
  block_init
  step_call using _crypto_sign_ed25519_ref10_hinit.call_eq
  obtain ⟨v₁, e⟩ : ∃ v, S.mem.readHashState hs = v := ⟨_, rfl⟩
  rw [hS, MemoryState.readHashState_storeHashState_self (by mem_fact)] at e
  have ha₁ : v₁.Absorbed [] := e ▸ HashState.absorbed_init _
  rw [e] at hS
  clear e
  -- crypto_hash_sha512_update(&hs, sig, 32);
  have hv : S.mem.readHashState hs = v₁ := by
    rw [hS]
    exact MemoryState.readHashState_storeHashState_self (by mem_fact)
  step_call using (update_of (hv := hv) (hpre := ha₁.prefix) (hD := hrv)) consuming hv
  obtain ⟨v₂, e⟩ : ∃ v, crypto_hash_sha512_update.spec v₁ 32#64 rv = v := ⟨_, rfl⟩
  have ha₂ : v₂.Absorbed ([] ++ bytesLE rv) := e ▸ ha₁.update 32#64 rv
  rw [e] at hS
  clear e
  -- crypto_hash_sha512_update(&hs, pk, 32);
  have hv : S.mem.readHashState hs = v₂ := by
    rw [hS]
    exact MemoryState.readHashState_storeHashState_self (by mem_fact)
  step_call using (update_of (hv := hv) (hpre := ha₂.prefix) (hD := hAv)) consuming hv
  obtain ⟨v₃, e⟩ : ∃ v, crypto_hash_sha512_update.spec v₂ 32#64 Av = v := ⟨_, rfl⟩
  have ha₃ : v₃.Absorbed ([] ++ bytesLE rv ++ bytesLE Av) := e ▸ ha₂.update 32#64 Av
  rw [e] at hS
  clear e
  -- crypto_hash_sha512_update(&hs, m, mlen);
  have hv : S.mem.readHashState hs = v₃ := by
    rw [hS]
    exact MemoryState.readHashState_storeHashState_self (by mem_fact)
  step_call using (update_of (hv := hv) (hpre := ha₃.prefix) (hD := hmv)) consuming hv
  obtain ⟨v₄, e⟩ : ∃ v, crypto_hash_sha512_update.spec v₃ mlen mv = v := ⟨_, rfl⟩
  have ha₄ : v₄.Absorbed ([] ++ bytesLE rv ++ bytesLE Av ++ bytesLE mv) := e ▸ ha₃.update mlen mv
  rw [e] at hS
  clear e
  -- crypto_hash_sha512_final(&hs, h);
  have hv : S.mem.readHashState hs = v₄ := by
    rw [hS]
    exact MemoryState.readHashState_storeHashState_self (by mem_fact)
  step_call using (final_of (hv := hv) (hpre := ha₄.prefix)) consuming hv
  clear hhashStateFit_hs
  -- sc25519_reduce(h);
  step_call using sc25519_reduce.call_eq
  rw [hram_eq ha₄] at hS hread_h
  clear hread_hs hfits_hs hroom_hs hhs_bounds hAv hmv hm hpk
  -- ge25519_double_scalarmult_vartime(&R, h, &A, sig + 32);
  have hdSv :=
    hdS
      (by
        rw [sc25519_is_canonical.spec_eq] at hc1
        by_contra hlt
        exact hc1 (ite_eq_right_iff.2 fun h => absurd h hlt))
  have hda : Boringssl.ge_double_scalarmult_vartime.Digits (S.mem.readAt h 256) := by
    rw [hread_h]
    exact hdh
  have hdb : Boringssl.ge_double_scalarmult_vartime.Digits (S.mem.readAt (sig.add 32#64) 256) := by
    rw [hSv]
    exact hdSv
  have hR_fe3 := MemoryState.Fe3Room.of_room hroom_R hR_off
  step_call using ge25519_double_scalarmult_vartime.call_eq consuming hR_fe3 hA_pt hread_A hS32 hda
    hdb hread_h hSv
  clear hdSv hfits_h hroom_h hh_bounds hroom_A hA_bounds
  -- ge25519_tobytes(rcheck, &R);
  step_call using ge25519_tobytes.call_eq consuming hR_fe3
  -- crypto_verify_32(rcheck, sig) | (-(rcheck == sig)) | sodium_memcmp(sig, rcheck, 32)
  step_call using hv32
  step_pure
  step_pure
  step_call using sodium_memcmp.call_eq
  step_pure
  finish_block
  refine
    (exit_block hs h rcheck A R S₀.alloc.nextFreeBlock
          ⟨by slot_bound, by slot_bound, by slot_bound, by slot_bound, by slot_bound⟩ _ S E
          (by env_reads) S₀.mem
          (by
            rw [hS]; erase_frame)).trans
      ?_
  have hrs : (rcheck == sig) = false := beq_false_of_ne fun e => hsig_ne_rcheck (by rw [e])
  rw [← hres, ← hk, hS]
  simp [spec, blocks, hashBlocks, hc1, hc2, hc3, hc4, hP, hSv₀, hrs, GlobalState.alloca]
  simp +arith

end Proof

end MLIR.Sodium
