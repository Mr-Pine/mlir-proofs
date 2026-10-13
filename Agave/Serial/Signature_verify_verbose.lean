module

public import Agave.Common.Decompress
public import Agave.Common.Sha512
public import Agave.Serial.CompressedEdwardsY_decompress
public import Agave.Serial.FieldElement51_Neg_neg
public import Agave.Serial.Mlir.Signature_verify_verbose
public import Agave.Serial.Sha512_Update_chain_slice_u8
public import Agave.Serial.VerificationKey_verify_dalek_prehashed
public import Agave.Serial.scalar_from_sha512
public import MLIR.Run.Tactic
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Agave.Serial

open Sha512VarCore_VariableOutputCore_finalize_variable_core (readBack)
open compress512 (flatBits_ofFn_bytes)
open _root_.Ed25519

/-! ## Specification -/

@[expose] public section

/-- `-A`: `X` and `T` negated. -/
def Signature_verify_verbose.minusA (A : EdwardsPoint) : EdwardsPoint :=
  ⟨FieldElement51_Neg_neg.spec A.X, A.Y, A.Z, FieldElement51_Neg_neg.spec A.T⟩

/-- `Signature::verify_verbose(sig, pubkey, msg)`: `1` (`MalformedPublicKey`) when `pubkey` does
not decompress (`A?`, its `decompress`), else `verify_dalek_prehashed` of `-A`, the signature's `R`
and `s`, and the challenge of `R`, `pubkey` and `msg`. -/
def Signature_verify_verbose.spec (R S pk : BitVec 256) (A? : Option EdwardsPoint)
    (msg : List (BitVec 8)) : BitVec 8 :=
  match A? with
  | none => 1#8
  | some A =>
    VerificationKey_verify_dalek_prehashed.spec (Signature_verify_verbose.minusA A) R S
      (scalar_from_sha512.spec (bytesLE R ++ bytesLE pk ++ msg))

/-- `update`'s `compress512` calls on `len` bytes into a buffer holding `r` bytes. -/
def Signature_verify_verbose.chainCalls (r : Nat) (len : BitVec 64) : Nat :=
  let P := BitVec.ofNat 8 r
  let rem := 128#64 - P.setWidth 64
  if len.ult rem then 0
  else
    if P = 0#8 then
      BlockBuffer_UInt_UTerm_B1_B0_Eager_digest_blocks_Sha512_Update_update_closure_0.tailCalls len
    else
      1 +
        BlockBuffer_UInt_UTerm_B1_B0_Eager_digest_blocks_Sha512_Update_update_closure_0.tailCalls
          (len - rem)

/-- The blocks `verify_verbose` allocates: its 16 slots, `decompress`'s, and on a key
`scalar_from_sha512`'s and `verify_dalek_prehashed`'s. -/
def Signature_verify_verbose.blocks (R S pk : BitVec 256) (A? : Option EdwardsPoint)
    (msg : List (BitVec 8)) : Nat :=
  match A? with
  | none => 16 + 158
  | some A =>
    16 + 159 + scalar_from_sha512.frames +
      VerificationKey_verify_dalek_prehashed.blocks (Signature_verify_verbose.minusA A) R S
        (scalar_from_sha512.spec (bytesLE R ++ bytesLE pk ++ msg))

end

/-! ## Proof -/

namespace Signature_verify_verbose

section Proof

open BlockBuffer_UInt_UTerm_B1_B0_Eager_digest_blocks_Sha512_Update_update_closure_0
  (globals_updateMem writable_updateMem)

/-- A state's memory after a store: the stored bits are known. -/
theorem fitsBack {S : GlobalState} {a : AllocState} {m : MemoryState} {p : Pointer} {X : BitVec w}
    (hS : S = ⟨a, m.storeAt p X⟩) (h : Room S.mem p w) : Fits S.mem p w := by
  subst hS
  exact Fits.storeAt_self (Room.storeAt_iff.1 h)

/-- A 168-byte slot holds `decompress`'s result. -/
theorem optEdwardsRoom_of {m : MemoryState} {p : Pointer} (h : Room m p 1344) (ho : p.offset = 0) :
    m.OptEdwardsRoom p :=
  ⟨by simp [ho], h.mono (by decide),
    Room.add_of_le (by simp [BitVec.uaddOverflow, ho]) (by decide) h⟩

/-- Reads in another block past `decompress`'s result. -/
@[local mlir_read]
public theorem readAt_storeOptEdwards_of_id_ne {m : MemoryState} {p q : Pointer}
    {P? : Option EdwardsPoint} (h : q.id ≠ p.id) :
    (m.storeOptEdwards p P?).readAt q w = m.readAt q w := by
  cases P? <;>
    simp only [MemoryState.storeOptEdwards, MemoryState.storeEdwards, MemoryState.storeFe4,
      MemoryState.storeLimbs] <;>
    simp only [Tactic.readThroughStore]

/-- Room after `decompress`'s result: room before it. -/
theorem room_of_storeOptEdwards {m : MemoryState} {p q : Pointer} {P? : Option EdwardsPoint}
    (h : Room (m.storeOptEdwards p P?) q w) : Room m q w := by
  cases P? <;>
    simpa only [MemoryState.storeOptEdwards, MemoryState.storeEdwards, MemoryState.storeFe4,
      Room.storeLimbs_iff, Room.storeAt_iff] using h

/-- `decompress`'s point, read back whole: its bits, known. -/
theorem point_of_decomp {S : GlobalState} {a : AllocState} {m : MemoryState} {p : Pointer}
    {P : EdwardsPoint} (hS : S = ⟨a, m.storeOptEdwards p (some P)⟩) (h : S.mem.OptEdwardsRoom p) :
    S.mem.readAt (p.add 8#64) 1280 = edwardsBits P ∧ Fits S.mem (p.add 8#64) 1280 := by
  subst hS
  have hm : m.OptEdwardsRoom p :=
    ⟨h.1, room_of_storeOptEdwards h.2.1, room_of_storeOptEdwards h.2.2⟩
  exact ⟨readAt_storeOptEdwards_point hm, MemoryState.PointFit.fits (pointFit_storeOptEdwards hm)⟩

/-- `decompress`'s point result as the tag's and the point bits' stores. -/
theorem decomp_some_eq {S : GlobalState} {a : AllocState} {m : MemoryState} {p : Pointer}
    {P : EdwardsPoint} (hS : S = ⟨a, m.storeOptEdwards p (some P)⟩) (h : S.mem.OptEdwardsRoom p) :
    S = ⟨a, (m.storeAt p 1#64).storeAt (p.add 8#64) (edwardsBits P)⟩ := by
  subst hS
  have hm : m.OptEdwardsRoom p :=
    ⟨h.1, room_of_storeOptEdwards h.2.1, room_of_storeOptEdwards h.2.2⟩
  rw [storeOptEdwards_some hm, storeAt_edwardsBits (optEdwardsRoom_pointRoom hm).1]

/-- A point's 1280 known bits: the point, and its limbs fit. -/
theorem edwards_of_bits {m : MemoryState} {p : Pointer} {P : EdwardsPoint} (hf : Fits m p 1280)
    (ho : p.offset.toNat + 160 ≤ 2 ^ 64) (hr : m.readAt p 1280 = edwardsBits P) :
    m.readEdwards p = P ∧ m.PointFit p :=
  ⟨readEdwards_of_readAt hf ho hr, MemoryState.PointFit.of_fits' hf ho⟩

/-- Room for limbs `k` bytes into a slot. -/
theorem limbsRoom_at {m : MemoryState} {p : Pointer} {k : BitVec 64} (h : Room m p w)
    (ho : p.offset = 0) (hk : k.toNat * 8 + 320 ≤ w) (hk' : k.toNat ≤ 1024) :
    m.LimbsRoom (p.add k) := by
  have hf : Room m (p.add k) 320 :=
    Room.add_of_le
      (by
        simp [ho, BitVec.uaddOverflow]; omega)
      hk h
  have hoff : (p.add k).offset = k := by simp [Pointer.add, ho]
  have hov (off : BitVec 64) (hoff' : off.toNat ≤ 32) : ¬(p.add k).offset.uaddOverflow off := by
    simp [hoff, BitVec.uaddOverflow]
    omega
  refine
      ⟨by
        simp [hoff]; omega, hf.mono (by omega), ?_, ?_, ?_, ?_⟩ <;>
    exact Room.add_of_le (hov _ (by decide)) (by decide) hf

/-- `-&a` with `a`'s limbs `X`. -/
theorem neg_of (out a : Pointer) (s : GlobalState) (hwf : s.WF) (hout : s.mem.LimbsRoom out)
    (ha : s.mem.LimbsFit a) (hsep : out.id ≠ a.id) {X : Fin 5 → BitVec 64}
    (hX : s.mem.readLimbs a = X) :
    FieldElement51_Neg_neg.call (FieldElement51_Neg_neg.args (.value out) (.value a)) s =
      .value (.nil, { s with mem := s.mem.storeLimbs out (FieldElement51_Neg_neg.spec X) }) := by
  rw [FieldElement51_Neg_neg.call_eq out a s hwf hout ha hsep, hX]

/-- `VerificationKey { A_bytes, minus_A }` stored field by field: one store of its bits. -/
theorem key_store {m : MemoryState} {p : Pointer} (ho : p.offset = 0) (PK : BitVec 256)
    (X Y Z T : Fin 5 → BitVec 64) :
    ((((m.storeLimbs (p.add 32#64) X).storeAt (p.add 72#64) (limbsBits Y)).storeAt (p.add 112#64)
                (limbsBits Z)).storeLimbs
            (p.add 152#64) T).storeAt
        p PK =
      m.storeAt p (edwardsBits ⟨X, Y, Z, T⟩ ++ PK) := by
  have hov (q : Pointer) (k : BitVec 64) (hq : q.offset.toNat ≤ 152) (hk : k.toNat ≤ 120) :
    ¬q.offset.uaddOverflow k := by
    simp only [BitVec.uaddOverflow, decide_eq_true_eq, Nat.not_le]; omega
  have e (a b : BitVec 64) (c : BitVec 64) (h : a + b = c) : (p.add a).add b = p.add c := by
    rw [Pointer.add_add, h]
  rw [MemoryState.storeLimbs_eq_storeAt (by simp [Pointer.add, ho]),
    MemoryState.storeLimbs_eq_storeAt (by simp [Pointer.add, ho]), ← e 32#64 40#64 72#64 rfl,
    MemoryState.storeAt_storeAt_concat
      (hov (p.add 32#64) 40#64 (by simp [Pointer.add, ho]) (by decide)) rfl,
    ← e 32#64 80#64 112#64 rfl,
    MemoryState.storeAt_storeAt_concat
      (hov (p.add 32#64) 80#64 (by simp [Pointer.add, ho]) (by decide)) rfl,
    ← e 32#64 120#64 152#64 rfl,
    MemoryState.storeAt_storeAt_concat (p := p.add 32#64) (off := 120#64)
      (by simp [BitVec.uaddOverflow, Pointer.add, ho]) rfl,
    MemoryState.storeAt_storeAt_below (by simp [BitVec.uaddOverflow, ho]) rfl]
  rfl

/-- A point's bits: `Y` at bit 320. -/
theorem edwardsBits_Y (P : EdwardsPoint) : (edwardsBits P).extractLsb' 320 320 = limbsBits P.Y := by
  simp only [edwardsBits]
  generalize limbsBits P.X = x
  generalize limbsBits P.Y = y
  generalize limbsBits P.Z = z
  generalize limbsBits P.T = t
  bv_decide

/-- A point's bits: `Z` at bit 640. -/
theorem edwardsBits_Z (P : EdwardsPoint) : (edwardsBits P).extractLsb' 640 320 = limbsBits P.Z := by
  simp only [edwardsBits]
  generalize limbsBits P.X = x
  generalize limbsBits P.Y = y
  generalize limbsBits P.Z = z
  generalize limbsBits P.T = t
  bv_decide

/-- A lifetime end and a store into another block commute. -/
theorem lifetimeEnd_storeAt_comm {m : MemoryState} {p q : Pointer} {x : BitVec w}
    (h : q.id ≠ p.id) : (m.storeAt p x).lifetimeEnd q = (m.lifetimeEnd q).storeAt p x :=
  MemoryState.modifyBlock_comm (Ne.symm h)

/-- The signature stored as its first byte and the other 63: its `R` and `s`. -/
theorem sig_reads {S : GlobalState} {a : AllocState} {m : MemoryState} {p : Pointer}
    {x : BitVec 256} {y : BitVec 248} {b : BitVec 8}
    (hS : S = ⟨a, (m.storeAt (p.add 1#64) (x ++ y)).storeAt p b⟩) (hb : Room S.mem p 512)
    (ho : p.offset = 0) :
    Fits S.mem p 512 ∧ S.mem.readAt p 256 = y ++ b ∧ S.mem.readAt (p.add 32#64) 256 = x := by
  rw [MemoryState.storeAt_storeAt_below (by simp [BitVec.uaddOverflow, ho]) rfl] at hS
  have hf : Fits S.mem p 512 := fitsBack hS hb
  have hr : S.mem.readAt p 512 = (x ++ y) ++ b := readBack hS hb
  refine ⟨hf, ?_, ?_⟩
  · have :=
      MemoryState.readAt_add_of_readAt (off := 0#64) (w := 256) hf.inBounds
        (by simp [BitVec.uaddOverflow, ho]) (by decide) hr
    rw [Pointer.add_zero] at this
    rw [this]
    bv_decide
  · rw [MemoryState.readAt_add_of_readAt hf.inBounds (by simp [BitVec.uaddOverflow, ho]) (by decide)
        hr]
    bv_decide

/-- The IV global's words: SHA-512's `IV`. -/
theorem iv_words {hw : (Ty.array 64 (.bv 8)).width = 512} :
    ∀ k,
      k < 8 →
        (Ty.flatBits anon_042b818bc72209407b52bd0e4d6c8368_139.lit (hw := hw)).extractLsb' (64 * k)
            64 =
          Sha512.IV[k]! := by
  unfold anon_042b818bc72209407b52bd0e4d6c8368_139.lit
  rw [flatBits_ofFn_bytes]
  decide +kernel

/-- No bits are always known. -/
theorem fits_zero {m : MemoryState} {p : Pointer} (h : Room m p w) : Fits m p 0 := by
  obtain ⟨⟨b, hb, hl, hw⟩, -⟩ := h
  exact
    ⟨b, hb, hl, by omega, by
      apply BitVec.eq_of_toNat_eq; simp⟩

/-- `Sha512::default()` in a 208-byte slot: the `IV` at `+ 128`, the block count `0`, the
position `0`; it has absorbed nothing. -/
theorem absorbed_init {S : GlobalState} {a : AllocState} {m : MemoryState} {d : Pointer}
    {X : BitVec 512}
    (hS :
      S =
        ⟨a, ((m.storeAt (d.add 128#64) X).storeAt (d.add 192#64) 0#128).storeAt (d.add 127#64) 0#8⟩)
    (hX : ∀ k, k < 8 → X.extractLsb' (64 * k) 64 = Sha512.IV[k]!) (hroom : Room S.mem d 1664)
    (ho : d.offset = 0) : S.mem.Sha2Absorbed d [] := by
  subst hS
  have hr0 : Room m d 1664 := Room.storeAt_iff.1 (Room.storeAt_iff.1 (Room.storeAt_iff.1 hroom))
  have hrk (k : Nat) (w : Nat) (hk : k * 8 + w ≤ 1664) : Room m (d.add (BitVec.ofNat 64 k)) w :=
    Room.add_of_le
      (by
        simp [BitVec.uaddOverflow, ho]; omega)
      (by
        simp; omega)
      hr0
  have hdj (a b v w : Nat) (ha : a ≤ 208) (hb : b ≤ 208)
    (h : a * 8 + v ≤ b * 8 ∨ b * 8 + w ≤ a * 8) :
    (Range.of (d.add (BitVec.ofNat 64 a)) v).Disjoint (Range.of (d.add (BitVec.ofNat 64 b)) w) := by
    simp only [Range.Disjoint, Range.of, Pointer.offsetInBits, Pointer.add, ho, BitVec.toNat_add,
      BitVec.toNat_ofNat]
    rw [Nat.mod_eq_of_lt (show a < 2 ^ 64 by omega), Nat.mod_eq_of_lt (show b < 2 ^ 64 by omega)]
    simp
    omega
  have hX0 : Fits (m.storeAt (d.add 128#64) X) (d.add 128#64) 512 :=
    Fits.storeAt_self (hrk 128 512 (by decide))
  have hw (j : Nat) (hj : j < 8) :
    (((m.storeAt (d.add 128#64) X).storeAt (d.add 192#64) 0#128).storeAt (d.add 127#64) 0#8).readAt
        ((d.add 128#64).add (BitVec.ofNat 64 (8 * j))) 64 =
      Sha512.IV[j]! := by
    have e :
      (d.add 128#64).add (BitVec.ofNat 64 (8 * j)) = d.add (BitVec.ofNat 64 (128 + 8 * j)) := by
      rw [Pointer.add_add, BitVec.ofNat_add]
    rw [e, MemoryState.readAt_storeAt_disjoint (hdj 127 _ 8 64 (by decide) (by omega) (by omega)),
      MemoryState.readAt_storeAt_disjoint (hdj 192 _ 128 64 (by decide) (by omega) (by omega)), ← e,
      MemoryState.readAt_storeAt_add (hrk 128 512 (by decide))
        (by
          simp [BitVec.uaddOverflow, Pointer.add, ho]; omega)
        (by
          simp; omega)]
    rw [show (BitVec.ofNat 64 (8 * j)).toNat * 8 = 64 * j by
        simp; omega]
    exact hX j hj
  refine
    ⟨by simp [ho], hroom, Fits.storeAt_self ((hrk 127 8 (by decide)).storeAt.storeAt), ?_,
      fits_zero hroom, ?_, ⟨by simp [Pointer.add, ho], ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩, ?_,
      (Fits.storeAt_self (hrk 192 128 (by decide)).storeAt).storeAt, ?_⟩
  · rw [MemoryState.readAt_storeAt_self ((hrk 127 8 (by decide)).storeAt.storeAt)]
    rfl
  · simp [bytesLE]
  · exact (hX0.mono (by decide)).storeAt.storeAt
  all_goals
    try
      exact
        (Fits.add_of_le (by simp [BitVec.uaddOverflow, Pointer.add, ho]) (by decide)
            hX0).storeAt.storeAt
  · rw [Sha512.compressBlocks_of_lt (by decide)]
    simp only [MemoryState.readSha512]
    have h0 := hw 0 (by decide)
    simp only [Nat.mul_zero, Pointer.add_zero] at h0
    rw [h0, hw 1 (by decide), hw 2 (by decide), hw 3 (by decide), hw 4 (by decide),
      hw 5 (by decide), hw 6 (by decide), hw 7 (by decide)]
    rfl
  · rw [MemoryState.readAt_storeAt_disjoint (hdj 127 192 8 128 (by decide) (by decide) (by decide)),
      MemoryState.readAt_storeAt_self (hrk 192 128 (by decide)).storeAt]
    rfl

/-! ### Facts past `chain`'s memory -/

open BlockBuffer_UInt_UTerm_B1_B0_Eager_digest_blocks_Sha512_Update_update_closure_0 in
/-- `update` changes only the object's block. -/
theorem getElem?_updateMem {m : MemoryState} {self data p : Pointer} {len : BitVec 64}
    (h : p.id ≠ self.id) : (updateMem m self data len)[p.id]? = m[p.id]? := by
  have hs {w : Nat} {m : MemoryState} {k : BitVec 64} {x : BitVec w} :
    (m.storeAt (self.add k) x)[p.id]? = m[p.id]? := MemoryState.getElem?_storeAt_ne h
  have hs0 {w : Nat} {m : MemoryState} {x : BitVec w} : (m.storeAt self x)[p.id]? = m[p.id]? :=
    MemoryState.getElem?_storeAt_ne h
  have hs1 {w : Nat} {m : MemoryState} {k k' : BitVec 64} {x : BitVec w} :
    (m.storeAt ((self.add k).add k') x)[p.id]? = m[p.id]? := MemoryState.getElem?_storeAt_ne h
  have hc {m : MemoryState} {c b} : (compressMem m self c b)[p.id]? = m[p.id]? := by
    simp only [compressMem, MemoryState.storeSha512, hs, hs1]
  have ht {m : MemoryState} {inp n} : (tailMem m self inp n)[p.id]? = m[p.id]? := by
    simp only [tailMem]
    split <;> simp only [hs, hs0, hc]
  dsimp only [updateMem]
  split
  · simp only [hs]
  split
  · exact ht
  · simp only [ht, hc, hs]

open BlockBuffer_UInt_UTerm_B1_B0_Eager_digest_blocks_Sha512_Update_update_closure_0 in
@[local mlir_transport]
theorem fits_updateMem {m : MemoryState} {self data p : Pointer} {len : BitVec 64} (h : Fits m p w)
    (hne : p.id ≠ self.id) : Fits (updateMem m self data len) p w := by
  simpa only [Fits, getElem?_updateMem hne] using h

open BlockBuffer_UInt_UTerm_B1_B0_Eager_digest_blocks_Sha512_Update_update_closure_0 in
@[local mlir_transport]
theorem inBounds_updateMem {m : MemoryState} {self data p : Pointer} {len : BitVec 64}
    (h : InBounds m p w) : InBounds (updateMem m self data len) p w := by
  have hc {m : MemoryState} {c b} (h : InBounds m p w) : InBounds (compressMem m self c b) p w := by
    simp only [compressMem]; exact h.storeAt.storeSha512
  have ht {m : MemoryState} {inp n} (h : InBounds m p w) : InBounds (tailMem m self inp n) p w := by
    simp only [tailMem]
    split
    · exact h.storeAt.storeAt
    · exact (hc h).storeAt.storeAt
  dsimp only [updateMem]
  split
  · exact h.storeAt.storeAt
  split
  · exact ht h
  · exact ht (hc h.storeAt)

open BlockBuffer_UInt_UTerm_B1_B0_Eager_digest_blocks_Sha512_Update_update_closure_0 in
@[local mlir_read]
public theorem readAt_updateMem_of_id_ne {m : MemoryState} {self data q : Pointer} {len : BitVec 64}
    (hne : q.id ≠ self.id) : (updateMem m self data len).readAt q w = m.readAt q w := by
  simp only [MemoryState.readAt, getElem?_updateMem hne]

open Sha512_Update_chain_slice_u8 in
@[local mlir_transport]
theorem fits_copyObj {m : MemoryState} {out self p : Pointer} (h : Fits m p w)
    (hne : p.id ≠ out.id) : Fits (copyObj m out self) p w := by
  simpa only [copyObj, Fits, MemoryState.getElem?_storeDef_ne hne] using h

open Sha512_Update_chain_slice_u8 in
@[local mlir_transport]
theorem inBounds_copyObj {m : MemoryState} {out self p : Pointer} (h : InBounds m p w) :
    InBounds (copyObj m out self) p w :=
  InBounds.storeDef h

open Sha512_Update_chain_slice_u8 in
@[local mlir_transport]
theorem room_copyObj {m : MemoryState} {out self p : Pointer} (h : Room m p w) :
    Room (copyObj m out self) p w :=
  Room.storeDef h

open Sha512_Update_chain_slice_u8 in
@[local mlir_transport]
theorem wf_copyObj_mk {a : AllocState} {m : MemoryState} {out self : Pointer}
    (h : (⟨a, m⟩ : GlobalState).WF) : (⟨a, copyObj m out self⟩ : GlobalState).WF :=
  GlobalState.WF.storeDef_mk h

open Sha512_Update_chain_slice_u8 in
@[local mlir_read]
public theorem readAt_copyObj_of_id_ne {m : MemoryState} {out self q : Pointer}
    (hne : q.id ≠ out.id) : (copyObj m out self).readAt q w = m.readAt q w := by
  simp only [copyObj, MemoryState.readAt, MemoryState.getElem?_storeDef_ne hne]

open BlockBuffer_UInt_UTerm_B1_B0_Eager_digest_blocks_Sha512_Update_update_closure_0
    Sha512_Update_chain_slice_u8 in
/-- `chain` on sha2's `Sha512` at `self` having absorbed `M`. -/
theorem chain_of (out self data : Pointer) (len : BitVec 64) (M : List (BitVec 8)) (s : GlobalState)
    (hwf : s.WF) (hg : s.mem.Globals Sha512_Update_chain_slice_u8.globals)
    (hA : s.mem.Sha2Absorbed self M) (hout : Room s.mem out 1664)
    (hdata : Fits s.mem data (8 * len.toNat)) (hdo : data.offset.toNat + len.toNat < 2 ^ 64)
    (hlen : len.toNat < 2 ^ 63) (hsd : self.id ≠ data.id) (hso : self.id ≠ out.id) :
    Sha512_Update_chain_slice_u8.call
        (Sha512_Update_chain_slice_u8.args (.value out) (.value self) (.value data) (.value len))
        s =
      .value
        (.nil,
          { s with mem := copyObj (updateMem s.mem self data len) out self }) := by
  have hP := hA.pos
  exact
    Sha512_Update_chain_slice_u8.call_eq out self data len s hwf hg hA.room hA.off hA.posFits
      (by omega)
      (by
        rw [hP]; exact hA.bufFits)
      hA.stateFit hA.countFits hout hdata hdo hlen hsd hso

open BlockBuffer_UInt_UTerm_B1_B0_Eager_digest_blocks_Sha512_Update_update_closure_0
    Sha512_Update_chain_slice_u8 in
/-- After `chain`: the moved object has absorbed the bytes too. -/
theorem absorbed_chain {S : GlobalState} {a : AllocState} {m : MemoryState}
    {out self data : Pointer} {len : BitVec 64} {M : List (BitVec 8)}
    (hS : S = ⟨a, copyObj (updateMem m self data len) out self⟩) (hA : m.Sha2Absorbed self M)
    (hout : Room m out 1664) (hoo : out.offset = 0) (hdata : Fits m data (8 * len.toNat))
    (hdo : data.offset.toNat + len.toNat < 2 ^ 64) (hlen : len.toNat < 2 ^ 63)
    (hsd : self.id ≠ data.id) :
    S.mem.Sha2Absorbed out (M ++ bytesLE (m.readAt data (8 * len.toNat))) := by
  subst hS
  exact chain_absorbed hA hout (by simp [hoo]) hdata hdo hlen hsd

open BlockBuffer_UInt_UTerm_B1_B0_Eager_digest_blocks_Sha512_Update_update_closure_0 in
/-- `update`'s calls on sha2's `Sha512` having absorbed `M`. -/
theorem updateCalls_eq {m : MemoryState} {self : Pointer} {M : List (BitVec 8)} {len : BitVec 64}
    (h : m.Sha2Absorbed self M) :
    updateCalls m self len = Signature_verify_verbose.chainCalls (M.length % 128) len := by
  have hP : m.readAt (self.add 127#64) 8 = BitVec.ofNat 8 (M.length % 128) := by
    apply BitVec.eq_of_toNat_eq
    rw [h.pos, BitVec.toNat_ofNat]
    exact (Nat.mod_eq_of_lt (by omega : M.length % 128 < 2 ^ 8)).symm
  simp only [updateCalls, Signature_verify_verbose.chainCalls, hP]

open BlockBuffer_UInt_UTerm_B1_B0_Eager_digest_blocks_Sha512_Update_update_closure_0 in
/-- A frame's `update` is erased with it. -/
@[local mlir_erase high]
theorem eraseFrom_updateMem_of_le {m : MemoryState} {self data : Pointer} {len : BitVec 64}
    (h : n ≤ self.id.id) : (updateMem m self data len).eraseFrom n = m.eraseFrom n := by
  have hs {w : Nat} {m : MemoryState} {k : BitVec 64} {x : BitVec w} :
    (m.storeAt (self.add k) x).eraseFrom n = m.eraseFrom n := MemoryState.eraseFrom_storeAt_of_le h
  have hs0 {w : Nat} {m : MemoryState} {x : BitVec w} :
    (m.storeAt self x).eraseFrom n = m.eraseFrom n := MemoryState.eraseFrom_storeAt_of_le h
  have hs1 {w : Nat} {m : MemoryState} {k k' : BitVec 64} {x : BitVec w} :
    (m.storeAt ((self.add k).add k') x).eraseFrom n = m.eraseFrom n :=
    MemoryState.eraseFrom_storeAt_of_le h
  have hc {m : MemoryState} {c b} : (compressMem m self c b).eraseFrom n = m.eraseFrom n := by
    simp only [compressMem, MemoryState.storeSha512, hs, hs1]
  have ht {m : MemoryState} {inp k} : (tailMem m self inp k).eraseFrom n = m.eraseFrom n := by
    simp only [tailMem]
    split <;> simp only [hs, hs0, hc]
  dsimp only [updateMem]
  split
  · simp only [hs]
  split
  · exact ht
  · simp only [ht, hc, hs]

/-- `verify_dalek_prehashed` on the key `P`, the signature's `R` and `s`, the challenge `H`. -/
theorem verify_of (self sig h : Pointer) (s : GlobalState) (hwf : s.WF)
    (hg : s.mem.Globals VerificationKey_verify_dalek_prehashed.globals)
    (hself : s.mem.PointFit (self.add 32#64)) (hself_off : ¬self.offset.uaddOverflow 32#64)
    (hsig : Fits s.mem sig 512) (hsig_off : ¬sig.offset.uaddOverflow 64#64) (hh : Fits s.mem h 256)
    (hh_off : ¬h.offset.uaddOverflow 32#64) {P : EdwardsPoint} {R S H : BitVec 256}
    (hP : s.mem.readEdwards (self.add 32#64) = P) (hR : s.mem.readAt sig 256 = R)
    (hS : s.mem.readAt (sig.add 32#64) 256 = S) (hH : s.mem.readAt h 256 = H)
    (hlt : H.toNat < 2 ^ 255) :
    VerificationKey_verify_dalek_prehashed.call
        (VerificationKey_verify_dalek_prehashed.args (.value self) (.value sig) (.value h)) s =
      .value
        (.cons (.value (VerificationKey_verify_dalek_prehashed.spec P R S H)) .nil,
          {
            alloc :=
              ⟨s.alloc.nextFreeBlock + VerificationKey_verify_dalek_prehashed.blocks P R S H⟩,
            mem := s.mem }) := by
  rw [VerificationKey_verify_dalek_prehashed.call_eq self sig h s hwf hg hself hself_off hsig
      hsig_off
      hh hh_off
      (by
        rw [hH]; exact hlt),
    hP, hR, hS, hH]

/-- The challenge scalar is below `2 ^ 255`. -/
theorem scalar_lt (M : List (BitVec 8)) : (scalar_from_sha512.spec M).toNat < 2 ^ 255 := by
  rw [scalar_from_sha512.toNat_spec]
  have : ell < 2 ^ 255 := by decide +kernel
  exact lt_of_lt_of_le (Nat.mod_lt _ (by decide)) this.le

/-- A block unchanged keeps its object's absorbed bytes. -/
theorem absorbed_of_block {m m' : MemoryState} {d : Pointer} {M : List (BitVec 8)}
    (hb : m'[d.id]? = m[d.id]?) (h : m.Sha2Absorbed d M) : m'.Sha2Absorbed d M := by
  have hf {p : Pointer} {w : Nat} (h : Fits m p w) (hp : p.id = d.id) : Fits m' p w := by
    simpa only [Fits, hp, hb] using h
  have hr (p : Pointer) (hp : p.id = d.id) (w : Nat) : m'.readAt p w = m.readAt p w := by
    simp only [MemoryState.readAt, hp, hb]
  have hs : m'.readSha512 (d.add 128#64) = m.readSha512 (d.add 128#64) := by
    simp only [MemoryState.readSha512, MemoryState.readAt, Pointer.add_id, hb]
  obtain ⟨hoff, hroom, hpf, hp, hbf, hbuf, ⟨hso, h0, h1, h2, h3, h4, h5, h6, h7⟩, hst, hcf, hc⟩ := h
  refine
    ⟨hoff, hroom.of_getElem?_eq hb, hf hpf rfl, by rwa [hr (d.add 127#64) rfl],
      hf hbf rfl, by rwa [hr d rfl],
      ⟨hso, hf h0 rfl, hf h1 rfl, hf h2 rfl, hf h3 rfl, hf h4 rfl, hf h5 rfl, hf h6 rfl, hf h7 rfl⟩,
      by rwa [hs], hf hcf rfl, by rwa [hr (d.add 192#64) rfl]⟩

/-- A lifetime end elsewhere keeps the absorbed bytes. -/
@[local mlir_transport]
theorem absorbed_lifetimeEnd {m : MemoryState} {d q : Pointer} {M : List (BitVec 8)}
    (hne : d.id ≠ q.id) (h : m.Sha2Absorbed d M) : (m.lifetimeEnd q).Sha2Absorbed d M :=
  absorbed_of_block (MemoryState.getElem?_setLifetime_ne hne) h

attribute [local mlir_transport]
  BlockBuffer_UInt_UTerm_B1_B0_Eager_digest_blocks_Sha512_Update_update_closure_0.room_updateMem
  BlockBuffer_UInt_UTerm_B1_B0_Eager_digest_blocks_Sha512_Update_update_closure_0.wf_updateMem

/-- The IV global's initializer gives its folded constant, leaving the state. -/
theorem anon_042b818bc72209407b52bd0e4d6c8368_139.value_eq (s : GlobalState) :
    anon_042b818bc72209407b52bd0e4d6c8368_139.value s =
      .value (Ty.wrap anon_042b818bc72209407b52bd0e4d6c8368_139.lit, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

-- about 200 steps over a frame of 16 blocks and 9 calls: past the default heartbeats
set_option maxHeartbeats 800000 in
/-- `Signature::verify_verbose(sig, pubkey, msg)` on the 64-byte signature at `sig`, the 32-byte
public key at `pk` and `len` bytes at `msg`: returns `spec` (`1` for a key that does not
decompress, else `verify_dalek_prehashed`'s byte) and leaves the memory as it was; only the counter
moves on (`blocks`). -/
public theorem call_eq (sig pk msg : Pointer) (len : BitVec 64) (s : GlobalState) (hwf : s.WF)
    (hg : s.mem.Globals Signature_verify_verbose.globals) (hsig : Fits s.mem sig 512)
    (hsig_off : ¬sig.offset.uaddOverflow 64#64)
    (hpk : Fits s.mem pk 256) (hpk_off : ¬pk.offset.uaddOverflow 32#64)
    (hmsg : Fits s.mem msg (8 * len.toNat)) (hmo : msg.offset.toNat + len.toNat < 2 ^ 64)
    (hlen : len.toNat < 2 ^ 63) :
    Signature_verify_verbose.call (args (.value sig) (.value pk) (.value msg) (.value len)) s =
      .value
        (.cons
            (.value
              (Signature_verify_verbose.spec (s.mem.readAt sig 256)
                (s.mem.readAt (sig.add 32#64) 256) (s.mem.readAt pk 256)
                (CompressedEdwardsY_decompress.spec (s.mem.readAt pk 256))
                (bytesLE (s.mem.readAt msg (8 * len.toNat)))))
            .nil,
          {
            alloc :=
              ⟨s.alloc.nextFreeBlock +
                  Signature_verify_verbose.blocks (s.mem.readAt sig 256)
                    (s.mem.readAt (sig.add 32#64) 256) (s.mem.readAt pk 256)
                    (CompressedEdwardsY_decompress.spec (s.mem.readAt pk 256))
                    (bytesLE (s.mem.readAt msg (8 * len.toNat)))⟩,
            mem := s.mem }) := by
  have hpk_split : s.mem.readAt pk 256 = s.mem.readAt (pk.add 1#64) 248 ++ s.mem.readAt pk 8 :=
    MemoryState.readAt_append (w := 248) (v := 8)
      (by
        simp [BitVec.uaddOverflow] at hpk_off ⊢; omega)
      rfl
  have hsig_split : s.mem.readAt sig 256 = s.mem.readAt (sig.add 1#64) 248 ++ s.mem.readAt sig 8 :=
    MemoryState.readAt_append (w := 248) (v := 8)
      (by
        simp [BitVec.uaddOverflow] at hsig_off ⊢; omega)
      rfl
  obtain ⟨pk0, hpk0⟩ : ∃ b, s.mem.readAt pk 8 = b := ⟨_, rfl⟩
  obtain ⟨pk1, hpk1⟩ : ∃ b, s.mem.readAt (pk.add 1#64) 248 = b := ⟨_, rfl⟩
  obtain ⟨sig0, hsig0⟩ : ∃ b, s.mem.readAt sig 8 = b := ⟨_, rfl⟩
  obtain ⟨sig1, hsig1⟩ : ∃ b, s.mem.readAt (sig.add 1#64) 248 = b := ⟨_, rfl⟩
  obtain ⟨S_bytes, hS_bytes⟩ : ∃ b, s.mem.readAt (sig.add 32#64) 256 = b := ⟨_, rfl⟩
  obtain ⟨msgb, hmsgb⟩ : ∃ b, s.mem.readAt msg (8 * len.toNat) = b := ⟨_, rfl⟩
  rw [hpk0, hpk1] at hpk_split
  rw [hsig0, hsig1] at hsig_split
  rw [hpk_split, hsig_split, hS_bytes, hmsgb]
  func_init
  have hS_bytes₀ : S₀.mem.readAt (sig.add 32#64) 256 = S_bytes := hS ▸ hS_bytes
  block_init
  iterate 8 step_pure
  step_addressof anon_042b818bc72209407b52bd0e4d6c8368_139.value_eq with iv
  generalize hivb : Ty.flatBits anon_042b818bc72209407b52bd0e4d6c8368_139.lit = ivb at hread_iv
  iterate 3 step_pure
  step_alloca with hasher0
  step_alloca with hasher1
  step_alloca with hasher2
  step_alloca with hasher3
  step_alloca with k
  step_alloca with key0
  step_alloca with A
  step_alloca with decomp
  step_alloca with A1
  step_alloca with A2
  step_alloca with A_bytes
  step_alloca with sig_tail
  step_alloca with signature
  step_alloca with key1
  step_alloca with key2
  step_alloca with key
  iterate 3 step_pure
  -- `VerificationKeyBytes::try_from(pubkey_bytes)`
  step_load
  step_pure
  step_pure
  step_pure
  step_memcpy
  step_store
  rw [MemoryState.storeAt_storeAt_below (off := 1#64) (by simp [BitVec.uaddOverflow, hA_bytes_off])
      rfl] at hS
  have hread_pkb : S.mem.readAt A_bytes 256 = pk1 ++ pk0 := readBack hS hroom_A_bytes
  clear hread_A_bytes hread_A_bytes_1 hfits_A_bytes hfits_A_bytes_1
  have hfits_pkb : Fits S.mem A_bytes 256 := fitsBack hS hroom_A_bytes
  iterate 4 step_pure
  have hdecomp_opt := optEdwardsRoom_of hroom_decomp hdecomp_off
  step_call using CompressedEdwardsY_decompress.call_eq consuming hdecomp_opt
  -- the globals and the writable blocks past `storeOptEdwards`, which the step does not see
  -- through
  any_goals
    rw [hS']
    first
    | exact hg.mono MemoryState.globals_storeOptEdwards fun _ h => h
    | exact Writable.storeOptEdwards (by assumption)
  obtain ⟨Aopt, hAopt⟩ : ∃ x, CompressedEdwardsY_decompress.spec (pk1 ++ pk0) = x := ⟨_, rfl⟩
  rw [hAopt] at hS hread_decomp ⊢
  rcases Aopt with _ | Apt
  · simp only [Option.isSome_none, Bool.false_eq_true, ↓reduceIte] at hread_decomp
    step_load
    step_pure
    finish_block
    block_init
    iterate 7 step_pure
    finish_block
    block_init
    step_pure
    finish_block
    subst hS
    simp only [MemoryState.storeOptEdwards]
    erase_frame
    simp only [Signature_verify_verbose.spec, Signature_verify_verbose.blocks, GlobalState.alloca,
      Option.isSome_none, Bool.false_eq_true, ↓reduceIte]
  · simp only [Option.isSome_some, ↓reduceIte] at hread_decomp
    step_load
    step_pure
    finish_block
    block_init
    -- `-A`
    step_pure
    step_pure
    have hfits_pt := (point_of_decomp hS (optEdwardsRoom_of hroom_decomp hdecomp_off)).2
    replace hS := decomp_some_eq hS (optEdwardsRoom_of hroom_decomp hdecomp_off)
    have hfits_pt' : Fits S.mem (decomp.add 8#64) (8 * (160#64).toNat) := hfits_pt
    step_memcpy consuming hfits_pt hfits_pt'
    step_pure
    step_pure
    step_memcpy
    step_pure
    step_memcpy
    step_pure
    step_pure
    step_pure
    have hA_pt := (edwards_of_bits hfits_A (by simp [hA_off]) hread_A).1
    have hA_fit := (edwards_of_bits hfits_A (by simp [hA_off]) hread_A).2
    step_call using
      (neg_of (hout := limbsRoom_at hroom_key0 hkey0_off (k := 32#64) (by decide) (by decide))
        (ha := hA_fit.2.1) (hX := congrArg EdwardsPoint.X hA_pt))
    clear hread_A1_6 hread_A2_6 hread_decomp
    step_pure
    step_pure
    step_memcpy
    step_pure
    step_pure
    step_memcpy
    step_pure
    step_pure
    step_call using
      (neg_of (hout := limbsRoom_at hroom_key0 hkey0_off (k := 152#64) (by decide) (by decide))
        (ha := hA_fit.2.2.2.2) (hX := congrArg EdwardsPoint.T hA_pt))
    step_memcpy
    rw [edwardsBits_Y, edwardsBits_Z, key_store hkey0_off] at hS
    clear hA_pt hA_fit hread_A hfits_A hread_key0 hfits_key0 hfits_key0_112 hfits_key0_72
    have hvk_read : S.mem.readAt key0 1536 = _ := readBack hS hroom_key0
    have hvk_fits : Fits S.mem key0 1536 := fitsBack hS hroom_key0
    step_pure
    step_memcpy
    iterate 4 step_pure
    step_memcpy
    step_pure
    step_memcpy
    step_pure
    clear hread_key1_6 hread_key2_6 hread_pkb
    -- `Signature::from_slice(self.as_ref())`
    step_pure
    step_pure
    step_pure
    step_load
    step_pure
    step_memcpy
    step_pure
    step_memcpy
    rw [hS_bytes₀,
      MemoryState.storeAt_storeAt_concat (off := 31#64)
        (by simp [BitVec.uaddOverflow, hsig_tail_off]) rfl] at hS
    clear hread_sig_tail hread_sig_tail_31 hfits_sig_tail hfits_sig_tail_31 hvk_read
    have hst_read : S.mem.readAt sig_tail 504 = _ := readBack hS hroom_sig_tail
    have hst_fits : Fits S.mem sig_tail (8 * (63#64).toNat) := fitsBack hS hroom_sig_tail
    step_pure
    step_memcpy
    step_pure
    step_store
    clear hst_read hread_signature hread_signature_1 hfits_signature hfits_signature_1
    have hne : sig_tail.id ≠ signature.id := by mem_fact
    rw [lifetimeEnd_storeAt_comm (p := signature.add 1#64) hne] at hS
    have hsigF := (sig_reads hS hroom_signature hsignature_off).1
    have hsigR := (sig_reads hS hroom_signature hsignature_off).2.1
    have hsigS := (sig_reads hS hroom_signature hsignature_off).2.2
    clear hne
    -- `Sha512::default()`
    iterate 5 step_pure
    step_pure
    step_memcpy
    step_pure
    step_store
    step_pure
    step_store
    have hA0 :=
      absorbed_init hS
        (by
          rw [← hivb]; exact iv_words)
        hroom_hasher0 hhasher0_off
    clear hfits_hasher0_127 hread_hasher0_127 hread_hasher0_192 hread_hasher0_128 hfits_hasher0_192
      hfits_hasher0_128 hroom_hasher0 hhasher0_bounds hiv_live hiv_fits hread_iv hkey0_bounds
      hA_bounds hdecomp_bounds hA1_bounds hA2_bounds hA_bytes_bounds hsig_tail_bounds hkey1_bounds
      hkey2_bounds hpk0 hpk_split hpk1 hsig0 hsig_split hsig1 hS_bytes hpk hsig
    -- `.chain(&signature.r_bytes()[..])`
    obtain ⟨m₁, hm₁⟩ : ∃ m, S.mem = m := ⟨_, rfl⟩
    have hA0' : m₁.Sha2Absorbed hasher0 [] := hm₁ ▸ hA0
    have hroom1' : Room m₁ hasher1 1664 := hm₁ ▸ hroom_hasher1
    have hsigF' : Fits m₁ signature (8 * (32#64).toNat) := hm₁ ▸ hsigF.mono (by decide)
    have hsigR' : m₁.readAt signature (8 * (32#64).toNat) = sig1 ++ sig0 := hm₁ ▸ hsigR
    step_call using (chain_of (M := []) (hA := hA0) (hdata := hsigF.mono (by decide))) consuming hA0
    -- the globals and the writable blocks past `updateMem`, which the step does not see through
    any_goals
      rw [hS']
      first
      | exact hg.mono globals_updateMem fun _ h => h
      | exact Writable.storeDef (writable_updateMem (by mem_fact))
    dsimp only at hm₁
    rw [hm₁] at hS
    have hAbs1 :=
      absorbed_chain hS hA0' hroom1' hhasher1_off hsigF' (by simp [hsignature_off]) (by decide)
        (by mem_fact)
    rw [← hm₁] at hS
    rw [hsigR', List.nil_append] at hAbs1
    clear hA0' hroom1' hsigF' hsigR' hm₁ m₁
    step_pure
    -- `.chain(&self.A_bytes.0[..])`
    have hkeyR : S.mem.readAt key 256 = pk1 ++ pk0 := by
      have :=
        MemoryState.readAt_add_of_readAt (off := 0#64) (w := 256) hfits_key.inBounds
          (by simp [BitVec.uaddOverflow, hkey_off]) (by decide) hread_key
      rw [Pointer.add_zero] at this
      rw [this]
      exact BitVec.extractLsb'_append_eq_right
    obtain ⟨m₁, hm₁⟩ : ∃ m, S.mem = m := ⟨_, rfl⟩
    have hA' : m₁.Sha2Absorbed hasher1 (bytesLE (sig1 ++ sig0)) := hm₁ ▸ hAbs1
    have hroom' : Room m₁ hasher2 1664 := hm₁ ▸ hroom_hasher2
    have hF' : Fits m₁ key (8 * (32#64).toNat) := hm₁ ▸ hfits_key.mono (by decide)
    have hR' : m₁.readAt key (8 * (32#64).toNat) = pk1 ++ pk0 := by
      rw [← hm₁]; exact hkeyR
    step_call using (chain_of (hA := hAbs1) (hdata := hfits_key.mono (by decide))) consuming hAbs1
      hkeyR
    -- the globals and the writable blocks past `updateMem`, which the step does not see through
    any_goals
      rw [hS']
      first
      | exact hg.mono globals_updateMem fun _ h => h
      | exact Writable.storeDef (writable_updateMem (by mem_fact))
    dsimp only at hm₁
    rw [hm₁] at hS
    have hAbs2 :=
      absorbed_chain hS hA' hroom' hhasher2_off hF' (by simp [hkey_off]) (by decide) (by mem_fact)
    rw [← hm₁] at hS
    rw [hR'] at hAbs2
    clear hA' hroom' hF' hR' hm₁ m₁
    step_pure
    -- `.chain(msg)`
    obtain ⟨m₁, hm₁⟩ : ∃ m, S.mem = m := ⟨_, rfl⟩
    have hA' : m₁.Sha2Absorbed hasher2 (bytesLE (sig1 ++ sig0) ++ bytesLE (pk1 ++ pk0)) :=
      hm₁ ▸ hAbs2
    have hroom' : Room m₁ hasher3 1664 := hm₁ ▸ hroom_hasher3
    have hF' : Fits m₁ msg (8 * len.toNat) := hm₁ ▸ hmsg
    have hR' : m₁.readAt msg (8 * len.toNat) = msgb := hm₁ ▸ hmsgb
    step_call using (chain_of (hA := hAbs2)) consuming hAbs2 hmsg hmsgb
    -- the globals and the writable blocks past `updateMem`, which the step does not see through
    any_goals
      rw [hS']
      first
      | exact hg.mono globals_updateMem fun _ h => h
      | exact Writable.storeDef (writable_updateMem (by mem_fact))
    dsimp only at hm₁
    rw [hm₁] at hS
    have hAbs3 := absorbed_chain hS hA' hroom' hhasher3_off hF' hmo hlen (by mem_fact)
    rw [← hm₁] at hS
    rw [hR'] at hAbs3
    clear hA' hroom' hF' hR' hm₁ m₁
    step_pure
    -- `scalar_from_sha512(..)`
    step_call using (scalar_from_sha512.call_eq (hA := hAbs3)) consuming hAbs3
    step_pure
    -- `verify_dalek_prehashed(&signature, k)`
    have hkey_ov : ¬key.offset.uaddOverflow 32#64 := by simp [BitVec.uaddOverflow, hkey_off]
    have hkeyP :
      S.mem.readAt (key.add 32#64) 1280 = edwardsBits (Signature_verify_verbose.minusA Apt) := by
      rw [MemoryState.readAt_add_of_readAt hfits_key.inBounds hkey_ov (by decide) hread_key]
      exact BitVec.extractLsb'_append_eq_left
    have hkeyF : Fits S.mem (key.add 32#64) 1280 := Fits.add_of_le hkey_ov (by decide) hfits_key
    have hPt := edwards_of_bits hkeyF (by simp [Pointer.add, hkey_off]) hkeyP
    step_call using
      (verify_of key signature k (hself := hPt.2) (hP := hPt.1) (hR := hsigR) (hS := hsigS) (hH :=
        hread_k) (hlt := scalar_lt _)) consuming
      hPt hkeyP hkeyF
    step_pure
    step_pure
    finish_block
    block_init
    step_pure
    finish_block
    subst hS
    simp only [Sha512_Update_chain_slice_u8.copyObj]
    erase_frame
    simp only [Signature_verify_verbose.spec, Signature_verify_verbose.blocks, GlobalState.alloca,
      Option.isSome_some, ↓reduceIte, List.append_assoc]
    congr 4
    omega

end Proof

end Signature_verify_verbose

end MLIR.Agave.Serial
