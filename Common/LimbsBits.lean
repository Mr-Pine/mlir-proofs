module

public import Common.Limbs
import Std.Data.ExtHashMap.Lemmas
import Mathlib.Tactic.Conv

/-! Five limbs as one 320-bit value: storing them is one 320-bit store, as a `memcpy` of a field
element writes them. -/

namespace LeanMLIR.RIR

open Memory

@[expose] public section

/-- The limbs' bits, limb `0` lowest. -/
def limbsBits (l : Fin 5 → BitVec 64) : BitVec 320 :=
  l 4 ++ l 3 ++ l 2 ++ l 1 ++ l 0

end

/-- Bit `j` of the limbs' bits: bit `j % 64` of limb `j / 64`. -/
theorem getLsbD_limbsBits (l : Fin 5 → BitVec 64) (j : Nat) :
    (limbsBits l).getLsbD j =
      if j < 64 then (l 0).getLsbD j
      else
        if j < 128 then (l 1).getLsbD (j - 64)
        else
          if j < 192 then (l 2).getLsbD (j - 128)
          else if j < 256 then (l 3).getLsbD (j - 192) else (l 4).getLsbD (j - 256) := by
  simp only [limbsBits, BitVec.getLsbD_append]
  simp only [Nat.sub_sub, Nat.reduceAdd]
  split_ifs <;>
    first
    | (exfalso; omega)
    | rfl

private theorem insert_insert_self (m : Std.ExtHashMap BlockId MemoryBlock) (k : BlockId)
    (v v' : MemoryBlock) : (m.insert k v).insert k v' = m.insert k v' := by
  apply Std.ExtHashMap.ext_getElem?
  intro a
  simp only [Std.ExtHashMap.getElem?_insert]
  split <;> rfl

/-- Storing limbs is storing their bits at once. -/
public theorem MemoryState.storeLimbs_eq_storeAt {m : MemoryState} {p : Pointer}
    {l : Fin 5 → BitVec 64} (h : p.offset.toNat + 32 < 2 ^ 64) :
    m.storeLimbs p l = m.storeAt p (limbsBits l) := by
  have o8 := Pointer.offsetInBits_add_limb (k := 8) h (by omega)
  have o16 := Pointer.offsetInBits_add_limb (k := 16) h (by omega)
  have o24 := Pointer.offsetInBits_add_limb (k := 24) h (by omega)
  have o32 := Pointer.offsetInBits_add_limb (k := 32) h (by omega)
  cases hb : m[p.id]? with
  | none =>
    have hn :
      ∀ {m' : MemoryState} {q : Pointer} {w} {x : BitVec w},
        m'[q.id]? = none → m'.storeAt q x = m' := by
      intro m' q w x hq; simp [MemoryState.storeAt, hq]
    simp [MemoryState.storeLimbs, hn, hb]
  | some blk =>
    rw [MemoryState.getElem?_eq] at hb
    simp [MemoryState.storeLimbs, MemoryState.storeAt, MemoryState.getElem?_eq, hb,
      insert_insert_self, o8, o16, o24, o32]
    have hp : p.offsetInBits = 8 * p.offset.toNat := rfl
    congr 2
    apply BitVec.eq_of_getLsbD_eq
    intro i hi
    simp only [getLsbD_spliceBits, getLsbD_limbsBits, hp]
    generalize 8 * p.offset.toNat = o
    simp only [Nat.sub_sub]
    split_ifs <;>
      first
      | (exfalso; omega)
      | rfl

/-! ### Storing what is there -/

/-- Storing the bits a range holds changes nothing. -/
public theorem MemoryState.storeAt_readAt_self {m : MemoryState} (h : Fits m p w) :
    m.storeAt p (m.readAt p w) = m := by
  obtain ⟨blk, hblk, hsz⟩ := h
  rcases m with ⟨mm⟩
  have hb : mm[p.id]? = some blk := by simpa [MemoryState.getElem?_eq] using hblk
  simp only [MemoryState.storeAt, MemoryState.readAt, MemoryState.getElem?_eq, hb]
  congr 1
  apply Std.ExtHashMap.ext_getElem?
  intro k
  simp only [Std.ExtHashMap.getElem?_insert, beq_iff_eq]
  split
  · subst_vars
    rw [hb]
    congr 1
    cases blk
    congr 1
    apply BitVec.eq_of_getLsbD_eq
    intro i hi
    rw [getLsbD_spliceBits, BitVec.getLsbD_extractLsb']
    split
    · have h1 : p.offsetInBits + (i - p.offsetInBits) = i := by omega
      have h2 : i - p.offsetInBits < w := by omega
      simp [h1, h2]
    · rfl
  · rfl

/-- Storing the limbs a field element holds changes nothing. -/
public theorem MemoryState.storeLimbs_readLimbs_self {m : MemoryState} (h : m.LimbsFit p) :
    m.storeLimbs p (m.readLimbs p) = m := by
  obtain ⟨-, h0, h1, h2, h3, h4⟩ := h
  simp only [MemoryState.storeLimbs, MemoryState.readLimbs]
  rw [storeAt_readAt_self h0, storeAt_readAt_self h1, storeAt_readAt_self h2,
    storeAt_readAt_self h3, storeAt_readAt_self h4]

/-- Limbs that fit are 320 bits that fit. -/
public theorem MemoryState.LimbsFit.fits {m : MemoryState} {p : Pointer} (h : m.LimbsFit p) :
    Fits m p 320 := by
  obtain ⟨ho, -, -, -, -, ⟨blk, hblk, hsz⟩⟩ := h
  have o32 := Pointer.offsetInBits_add_limb (k := 32) ho (by omega)
  refine ⟨blk, by simpa [Pointer.add] using hblk, ?_⟩
  have : p.offsetInBits = 8 * p.offset.toNat := rfl
  omega

/-- Limbs stored where 320 bits fit read back as their bits. -/
public theorem MemoryState.readAt_storeLimbs_self {m : MemoryState} {p : Pointer}
    {l : Fin 5 → BitVec 64} (hf : Fits m p 320) (h : p.offset.toNat + 32 < 2 ^ 64) :
    (m.storeLimbs p l).readAt p 320 = limbsBits l := by
  rw [storeLimbs_eq_storeAt h, MemoryState.readAt_storeAt_self hf]

/-- 320 bits where they fit, offsets not wrapping: five limbs that fit. -/
public theorem MemoryState.LimbsFit.of_fits' {m : MemoryState} {p : Pointer} (h : Fits m p 320)
    (ho : p.offset.toNat + 32 < 2 ^ 64) : m.LimbsFit p := by
  have hov : ∀ off : BitVec 64, off.toNat ≤ 32 → ¬p.offset.uaddOverflow off := by
    intro off hoff
    simp only [BitVec.uaddOverflow, decide_eq_true_eq, Nat.not_le]
    omega
  refine ⟨ho, h.mono (by omega), ?_, ?_, ?_, ?_⟩ <;>
    exact Fits.add_of_le (hov _ (by decide)) (by decide) h

/-- The 320 bits at limbs that fit: the limbs' bits. -/
public theorem MemoryState.readAt_eq_limbsBits {m : MemoryState} {p : Pointer} (h : Fits m p 320)
    (ho : p.offset.toNat + 32 < 2 ^ 64) : m.readAt p 320 = limbsBits (m.readLimbs p) := by
  conv_lhs => rw [← MemoryState.storeLimbs_readLimbs_self (MemoryState.LimbsFit.of_fits' h ho)]
  exact MemoryState.readAt_storeLimbs_self h ho

/-- A field element copied whole (a `memcpy` of 40 bytes): its limbs stored. -/
public theorem MemoryState.storeAt_readAt_eq_storeLimbs {m m' : MemoryState} {p q : Pointer}
    (hq : Fits m' q 320) (hqo : q.offset.toNat + 32 < 2 ^ 64) (hp : p.offset.toNat + 32 < 2 ^ 64) :
    m.storeAt p (m'.readAt q 320) = m.storeLimbs p (m'.readLimbs q) := by
  rw [MemoryState.readAt_eq_limbsBits hq hqo, MemoryState.storeLimbs_eq_storeAt hp]

/-- A field element copied whole reads back as the source's limbs. -/
public theorem MemoryState.readLimbs_storeAt_readAt {m : MemoryState} {p q : Pointer}
    (hq : m.LimbsFit q) (hp : m.LimbsFit p) :
    (m.storeAt p (m.readAt q 320)).readLimbs p = m.readLimbs q := by
  rw [MemoryState.storeAt_readAt_eq_storeLimbs hq.fits hq.1 hp.1,
    MemoryState.readLimbs_storeLimbs_self hp]

end LeanMLIR.RIR
