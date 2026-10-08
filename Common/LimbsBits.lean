module

public import Common.Limbs
import Std.Data.ExtHashMap.Lemmas

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

end LeanMLIR.RIR
