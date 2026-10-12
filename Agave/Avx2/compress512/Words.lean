module

public import Agave.Avx2.compress512.Basic
public import Firedancer.Common.Memory
import Firedancer.Common.Point

/-! The state words' stores: `accumulate_state`'s, lowest first, as `storeSha512`'s, and over
each other. -/

namespace MLIR.Agave.Avx2.compress512

open _root_.Ed25519 MLIR.Agave

/-- The eight words' bits, word `0` lowest. -/
@[expose]
public def wordsBits (v : Vector (BitVec 64) 8) : BitVec 512 :=
  v[7] ++ (v[6] ++ (v[5] ++ (v[4] ++ (v[3] ++ (v[2] ++ (v[1] ++ v[0]))))))

theorem not_uaddOverflow_word {p : Pointer} (hp : p.offset.toNat + 56 < 2 ^ 64) {k : Nat}
    (hk : k ≤ 56) : ¬p.offset.uaddOverflow (BitVec.ofNat 64 k) := by
  simp [BitVec.uaddOverflow]; omega

/-- The words stored lowest first: their bits at once. -/
public theorem storeWords_eq_storeAt {m : MemoryState} {p : Pointer}
    (hp : p.offset.toNat + 56 < 2 ^ 64) (v : Vector (BitVec 64) 8) :
    storeWords m p v = m.storeAt p (wordsBits v) := by
  unfold storeWords wordsBits
  rw [MemoryState.storeAt_storeAt_append (not_uaddOverflow_word hp (k := 8) (by decide)) rfl
      (by decide),
    MemoryState.storeAt_storeAt_append (not_uaddOverflow_word hp (k := 16) (by decide)) rfl
      (by decide),
    MemoryState.storeAt_storeAt_append (not_uaddOverflow_word hp (k := 24) (by decide)) rfl
      (by decide),
    MemoryState.storeAt_storeAt_append (not_uaddOverflow_word hp (k := 32) (by decide)) rfl
      (by decide),
    MemoryState.storeAt_storeAt_append (not_uaddOverflow_word hp (k := 40) (by decide)) rfl
      (by decide),
    MemoryState.storeAt_storeAt_append (not_uaddOverflow_word hp (k := 48) (by decide)) rfl
      (by decide),
    MemoryState.storeAt_storeAt_append (not_uaddOverflow_word hp (k := 56) (by decide)) rfl
      (by decide)]

theorem disj0 {p : Pointer} (hp : p.offset.toNat + 56 < 2 ^ 64) {k : Nat} (hk : 8 ≤ k)
    (hk' : k ≤ 56) : (Range.of (p.add (BitVec.ofNat 64 k)) 64).Disjoint (Range.of p 64) := by
  simp only [Range.Disjoint, Range.of, Pointer.offsetInBits, Pointer.add, BitVec.toNat_add,
    BitVec.toNat_ofNat]
  right; right
  rw [Nat.mod_eq_of_lt (by omega : k < 2 ^ 64), Nat.mod_eq_of_lt (by omega)]
  omega

/-- `storeSha512`'s order, the lowest word last: the same stores. -/
public theorem storeSha512_eq_storeWords {m : MemoryState} {p : Pointer}
    (hp : p.offset.toNat + 56 < 2 ^ 64) (v : Vector (BitVec 64) 8) :
    m.storeSha512 p v = storeWords m p v := by
  unfold MemoryState.storeSha512 storeWords
  rw [MemoryState.storeAt_comm (disj0 hp (k := 56) (by decide) (by decide)),
    MemoryState.storeAt_comm (disj0 hp (k := 48) (by decide) (by decide)),
    MemoryState.storeAt_comm (disj0 hp (k := 40) (by decide) (by decide)),
    MemoryState.storeAt_comm (disj0 hp (k := 32) (by decide) (by decide)),
    MemoryState.storeAt_comm (disj0 hp (k := 24) (by decide) (by decide)),
    MemoryState.storeAt_comm (disj0 hp (k := 16) (by decide) (by decide)),
    MemoryState.storeAt_comm (disj0 hp (k := 8) (by decide) (by decide))]

/-- The state words stored over a previous store of them. -/
public theorem storeSha512_storeWords {m : MemoryState} {p : Pointer}
    (hp : p.offset.toNat + 56 < 2 ^ 64) (v w : Vector (BitVec 64) 8) :
    (storeWords m p w).storeSha512 p v = m.storeSha512 p v := by
  rw [storeSha512_eq_storeWords hp, storeSha512_eq_storeWords hp, storeWords_eq_storeAt hp,
    storeWords_eq_storeAt hp, storeWords_eq_storeAt hp, MemoryState.storeAt_storeAt_self]

/-- State words that fit, stored back: nothing changes. -/
public theorem storeSha512_readSha512 {m : MemoryState} {p : Pointer} (h : m.Sha512Fit p) :
    m.storeSha512 p (m.readSha512 p) = m := by
  obtain ⟨hp, h0, h1, h2, h3, h4, h5, h6, h7⟩ := h
  rw [storeSha512_eq_storeWords hp]
  simp only [storeWords, MemoryState.readSha512, Vector.getElem_mk, List.getElem_toArray,
    List.getElem_cons_succ, List.getElem_cons_zero]
  rw [MemoryState.storeAt_readAt_self h0, MemoryState.storeAt_readAt_self h1,
    MemoryState.storeAt_readAt_self h2, MemoryState.storeAt_readAt_self h3,
    MemoryState.storeAt_readAt_self h4, MemoryState.storeAt_readAt_self h5,
    MemoryState.storeAt_readAt_self h6, MemoryState.storeAt_readAt_self h7]

@[mlir_transport]
public theorem Fits.storeWords {m : MemoryState} {p q : Pointer} {v : Vector (BitVec 64) 8}
    {w : Nat} (h : Fits m q w) : Fits (storeWords m p v) q w :=
  h.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt

@[mlir_transport]
public theorem Room.storeWords {m : MemoryState} {p q : Pointer} {v : Vector (BitVec 64) 8}
    {w : Nat} (h : Room m q w) : Room (storeWords m p v) q w :=
  h.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt

@[mlir_transport]
public theorem InBounds.storeWords {m : MemoryState} {p q : Pointer} {v : Vector (BitVec 64) 8}
    {w : Nat} (h : InBounds m q w) : InBounds (storeWords m p v) q w :=
  h.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt

@[mlir_transport]
public theorem GlobalState.WF.storeWords {s : GlobalState} {p : Pointer} {v : Vector (BitVec 64) 8}
    (h : s.WF) : ({ s with mem := storeWords s.mem p v } : GlobalState).WF :=
  h.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt

/-- `K`'s pairs past the state words' stores. -/
@[mlir_transport]
public theorem KPairs.storeWords {m : MemoryState} {Kp p : Pointer} {v : Vector (BitVec 64) 8}
    (h : KPairs m Kp) (hne : p.id ≠ Kp.id) : KPairs (compress512.storeWords m p v) Kp := by
  unfold compress512.storeWords
  iterate 8 refine KPairs.storeAt ?_ (by simpa [Pointer.add_id] using hne)
  exact h

/-- A read apart from the state words, past their stores. -/
public theorem readAt_storeWords_of_disjoint {m : MemoryState} {p q : Pointer}
    {v : Vector (BitVec 64) 8} {w : Nat} (hp : p.offset.toNat + 56 < 2 ^ 64)
    (h : (Range.of p 512).Disjoint (Range.of q w)) :
    (storeWords m p v).readAt q w = m.readAt q w := by
  rw [← storeSha512_eq_storeWords hp, MemoryState.readAt_storeSha512_of_disjoint hp h]

/-- The state words stored, read back. -/
public theorem readSha512_storeWords_self {m : MemoryState} {p : Pointer} {v : Vector (BitVec 64) 8}
    (hp : p.offset.toNat + 56 < 2 ^ 64) (h : InBounds m p 512) :
    (storeWords m p v).readSha512 p = v := by
  rw [← storeSha512_eq_storeWords hp, MemoryState.readSha512_storeSha512_self hp h]

/-- Erasing a frame commutes with the state words' stores. -/
public theorem eraseFrom_storeWords {m : MemoryState} {p : Pointer} {v : Vector (BitVec 64) 8} :
    (storeWords m p v).eraseFrom B = storeWords (m.eraseFrom B) p v := by
  simp only [storeWords, MemoryState.eraseFrom_storeAt]

/-- The state words past a lifetime marker. -/
public theorem readSha512_lifetimeEnd {m : MemoryState} {p q : Pointer} :
    (m.lifetimeEnd q).readSha512 p = m.readSha512 p := by
  simp only [MemoryState.readSha512, MemoryState.readAt_lifetimeEnd]

/-- State words that fit: their 512 bits known. -/
public theorem MemoryState.Sha512Fit.fits {m : MemoryState} {p : Pointer} (h : m.Sha512Fit p) :
    Fits m p 512 := by
  obtain ⟨hp, h0, h1, h2, h3, h4, h5, h6, h7⟩ := h
  have a1 := Fits.append (v := 64) (not_uaddOverflow_word hp (k := 8) (by decide)) rfl rfl h0 h1
  have a2 := Fits.append (v := 128) (not_uaddOverflow_word hp (k := 16) (by decide)) rfl rfl a1 h2
  have a3 := Fits.append (v := 192) (not_uaddOverflow_word hp (k := 24) (by decide)) rfl rfl a2 h3
  have a4 := Fits.append (v := 256) (not_uaddOverflow_word hp (k := 32) (by decide)) rfl rfl a3 h4
  have a5 := Fits.append (v := 320) (not_uaddOverflow_word hp (k := 40) (by decide)) rfl rfl a4 h5
  have a6 := Fits.append (v := 384) (not_uaddOverflow_word hp (k := 48) (by decide)) rfl rfl a5 h6
  exact Fits.append (v := 448) (not_uaddOverflow_word hp (k := 56) (by decide)) rfl rfl a6 h7

end MLIR.Agave.Avx2.compress512
