module

public import MLIR.Semantics.Effectful.Memory.Operations
public import Firedancer.Common.Limbs
import Std.Data.ExtHashMap.Lemmas
import Std.Tactic.BVDecide
import Mathlib.Tactic.FinCases

/-! A field element's limbs as two `vector<2xi64>` pairs (offsets 0 and 16) and a last limb, as the
SLP-vectorized fiat code loads and stores them. -/

namespace MLIR

open Memory

@[expose] public section

/-- An offset within a field element's 40 bytes does not wrap. -/
theorem Pointer.not_uaddOverflow_of_limbs {p : Pointer} (h : p.offset.toNat + 32 < 2 ^ 64)
    {k : BitVec 64} (hk : k.toNat ≤ 32) : ¬p.offset.uaddOverflow k := by
  simp only [BitVec.uaddOverflow, ge_iff_le, decide_eq_true_eq, Nat.not_le]
  omega

/-- Two adjacent ranges with room: their union has room. -/
theorem Room.append {off : BitVec 64} (hov : ¬p.offset.uaddOverflow off) (hv : off.toNat * 8 = v)
    (hu : v + w = u) (h₁ : Room m p v) (h₂ : Room m (p.add off) w) : Room m p u := by
  subst hu
  obtain ⟨⟨blk, hblk, hl, hsz⟩, hw⟩ := h₁
  obtain ⟨⟨blk', hblk', _, hsz'⟩, -⟩ := h₂
  have hb : blk' = blk := by
    have : m[p.id]? = some blk' := hblk'
    rw [hblk] at this
    exact (Option.some.inj this).symm
  subst hb
  rw [Pointer.offsetInBits_add hov] at hsz'
  exact ⟨⟨blk', hblk, hl, by omega⟩, hw⟩

/-- The first limb pair fits. -/
theorem MemoryState.LimbsFit.fits_lo {m : MemoryState} (h : m.LimbsFit p) : Fits m p 128 :=
  Fits.append (off := 8#64) (Pointer.not_uaddOverflow_of_limbs h.1 (by decide)) (by decide) rfl
    h.2.1 h.2.2.1

/-- The second limb pair fits. -/
theorem MemoryState.LimbsFit.fits_hi {m : MemoryState} (h : m.LimbsFit p) :
    Fits m (p.add 16#64) 128 := by
  refine Fits.append (off := 8#64) (w := 64) ?_ (by decide) rfl h.2.2.2.1 ?_
  · simp only [Pointer.add, BitVec.uaddOverflow, ge_iff_le, decide_eq_true_eq, Nat.not_le,
      BitVec.toNat_add]
    have := h.1
    rw [Nat.mod_eq_of_lt
        (by
          simp; omega)]
    simp
    omega
  · rw [Pointer.add_add]
    exact h.2.2.2.2.1

/-- Room for the first limb pair. -/
theorem MemoryState.LimbsRoom.room_lo {m : MemoryState} (h : m.LimbsRoom p) : Room m p 128 :=
  Room.append (off := 8#64) (Pointer.not_uaddOverflow_of_limbs h.1 (by decide)) (by decide) rfl
    h.2.1 h.2.2.1

/-- Room for the second limb pair. -/
theorem MemoryState.LimbsRoom.room_hi {m : MemoryState} (h : m.LimbsRoom p) :
    Room m (p.add 16#64) 128 := by
  refine Room.append (off := 8#64) (w := 64) ?_ (by decide) rfl h.2.2.2.1 ?_
  · simp only [Pointer.add, BitVec.uaddOverflow, ge_iff_le, decide_eq_true_eq, Nat.not_le,
      BitVec.toNat_add]
    have := h.1
    rw [Nat.mod_eq_of_lt
        (by
          simp; omega)]
    simp
    omega
  · rw [Pointer.add_add]
    exact h.2.2.2.2.1

/-- Lane 0 of a 128-bit read: the 64-bit read. -/
theorem MemoryState.extractVecElem_zero_readAt {m : MemoryState} :
    Ty.extractVecElem 2 64 0 (m.readAt p 128) = m.readAt p 64 := by
  rw [MemoryState.readAt_of_readAt_le (w := 64) (v := 128) (by decide) rfl, Ty.extractVecElem_eq]
  ext i hi
  simp

/-- Lane 1 of a 128-bit read: the 64-bit read 8 bytes on. -/
theorem MemoryState.extractVecElem_one_readAt {m : MemoryState} (h : InBounds m p 128)
    (hov : ¬p.offset.uaddOverflow 8#64) :
    Ty.extractVecElem 2 64 1 (m.readAt p 128) = m.readAt (p.add 8#64) 64 := by
  rw [MemoryState.readAt_add_of_readAt (w := 64) h hov (by decide) rfl, Ty.extractVecElem_eq]
  rfl

/-- A 128-bit store: the stores of its two 64-bit halves. -/
theorem MemoryState.storeAt_pair {m : MemoryState} {p : Pointer} (hov : ¬p.offset.uaddOverflow 8#64)
    (x : BitVec 128) :
    m.storeAt p x =
      (m.storeAt p (x.extractLsb' 0 64)).storeAt (p.add 8#64) (x.extractLsb' 64 64) := by
  simp only [MemoryState.storeAt, Pointer.add_id,
    MemoryState.modifyBlock_modifyBlock_self, implies_true]
  congr 1
  funext blk
  simp only [Function.comp_apply, Pointer.offsetInBits_add hov, MemoryBlock.mk.injEq, true_and,
    and_true]
  refine ⟨heq_of_eq ?_, heq_of_eq ?_⟩ <;> apply BitVec.eq_of_getLsbD_eq <;> intro i hi <;>
    simp only [getLsbD_spliceBits, BitVec.getLsbD_extractLsb', BitVec.getLsbD_allOnes] <;>
    by_cases h₁ : p.offsetInBits ≤ i <;>
    by_cases h₂ : p.offsetInBits + 64 ≤ i <;>
    by_cases h₃ : i < p.offsetInBits + 128 <;>
    simp [*] <;>
    (repeat' split) <;>
    simp_all <;>
    (first
      | omega
      | (rw [show 64 + (i - (p.offsetInBits + 64)) = i - p.offsetInBits by omega]; simp; omega))

/-- A store of a packed pair: the stores of its two lanes. -/
theorem MemoryState.storeAt_packLanes {m : MemoryState} {p : Pointer}
    (hov : ¬p.offset.uaddOverflow 8#64) (v : Vector (BitVec 64) 2) :
    m.storeAt p (BitVec.packLanes v) = (m.storeAt p v[0]).storeAt (p.add 8#64) v[1] := by
  rw [MemoryState.storeAt_pair hov, BitVec.extractLsb'_packLanes_of_lt v (by decide) (by decide),
    BitVec.extractLsb'_packLanes_of_lt v (by decide) (by decide)]
  simp

/-- Nor the second pair's lane 1. -/
theorem Pointer.not_uaddOverflow_add16 {p : Pointer} (h : p.offset.toNat + 32 < 2 ^ 64) :
    ¬(p.add 16#64).offset.uaddOverflow 8#64 := by
  simp only [Pointer.add, BitVec.uaddOverflow, ge_iff_le, decide_eq_true_eq, Nat.not_le,
    BitVec.toNat_add]
  rw [Nat.mod_eq_of_lt
      (by
        simp; omega)]
  simp
  omega

/-- The limb pairs' stores at `p` and `p + 16`, as a field element's limb stores. -/
theorem MemoryState.storeAt_packLanes_limbs {m : MemoryState} {p : Pointer}
    (h : p.offset.toNat + 32 < 2 ^ 64) (lo hi : Vector (BitVec 64) 2) (x4 : BitVec 64) :
    ((m.storeAt p (BitVec.packLanes lo)).storeAt (p.add 16#64) (BitVec.packLanes hi)).storeAt
        (p.add 32#64) x4 =
      m.storeLimbs p fun
        | 0 => lo[0]
        | 1 => lo[1]
        | 2 => hi[0]
        | 3 => hi[1]
        | 4 => x4 := by
  rw [MemoryState.storeAt_packLanes (Pointer.not_uaddOverflow_of_limbs h (by decide)),
    MemoryState.storeAt_packLanes (Pointer.not_uaddOverflow_add16 h), Pointer.add_add]
  rfl

/-- Lane 1 of the first pair's read: limb 1. -/
theorem MemoryState.LimbsFit.extractVecElem_one_lo {m : MemoryState} (h : m.LimbsFit p) :
    Ty.extractVecElem 2 64 1 (m.readAt p 128) = m.readAt (p.add 8#64) 64 :=
  extractVecElem_one_readAt h.fits_lo.inBounds (Pointer.not_uaddOverflow_of_limbs h.1 (by decide))

/-- Lane 1 of the second pair's read: limb 3. -/
theorem MemoryState.LimbsFit.extractVecElem_one_hi {m : MemoryState} (h : m.LimbsFit p) :
    Ty.extractVecElem 2 64 1 (m.readAt (p.add 16#64) 128) = m.readAt (p.add 24#64) 64 := by
  rw [extractVecElem_one_readAt h.fits_hi.inBounds (Pointer.not_uaddOverflow_add16 h.1),
    Pointer.add_add]
  rfl

/-- A store of `y ++ x`: `x`, then `y` right after it. -/
theorem MemoryState.storeAt_append {m : MemoryState} {p : Pointer} {off : BitVec 64} {x : BitVec v}
    {y : BitVec w} (hov : ¬p.offset.uaddOverflow off) (hoff : off.toNat * 8 = v) :
    m.storeAt p (y ++ x) = (m.storeAt p x).storeAt (p.add off) y := by
  simp only [MemoryState.storeAt, Pointer.add_id,
    MemoryState.modifyBlock_modifyBlock_self, implies_true]
  congr 1
  funext blk
  simp only [Function.comp_apply, Pointer.offsetInBits_add hov, hoff, MemoryBlock.mk.injEq,
    true_and, and_true]
  refine ⟨heq_of_eq ?_, heq_of_eq ?_⟩ <;> apply BitVec.eq_of_getLsbD_eq <;> intro i hi <;>
    simp only [getLsbD_spliceBits, BitVec.getLsbD_append, BitVec.getLsbD_allOnes]
  · grind
  · split <;> split <;> (try split) <;> (try simp only [decide_eq_decide]) <;> omega

/-- A 320-bit store from `p`: the five limbs' stores. -/
theorem MemoryState.storeAt_eq_storeLimbs {m : MemoryState} {p : Pointer}
    (h : p.offset.toNat + 32 < 2 ^ 64) (x : BitVec 320) :
    m.storeAt p x = m.storeLimbs p fun i => x.extractLsb' (64 * i.val) 64 := by
  have hx :
    x =
      x.extractLsb' 256 64 ++ x.extractLsb' 192 64 ++ x.extractLsb' 128 64 ++ x.extractLsb' 64 64 ++
        x.extractLsb' 0 64 := by
    bv_decide
  have hov (k : BitVec 64) (hk : k.toNat ≤ 32) (j : BitVec 64) (hj : j.toNat + k.toNat ≤ 32) :
    ¬(p.add j).offset.uaddOverflow k := by
    simp only [Pointer.add, BitVec.uaddOverflow, ge_iff_le, decide_eq_true_eq, Nat.not_le,
      BitVec.toNat_add]
    rw [Nat.mod_eq_of_lt (by omega)]
    omega
  conv_lhs => rw [hx]
  rw [MemoryState.storeAt_append (off := 8#64) (Pointer.not_uaddOverflow_of_limbs h (by decide))
      (by decide),
    MemoryState.storeAt_append (off := 8#64) (hov 8#64 (by decide) 8#64 (by decide)) (by decide)]
  simp only [Pointer.add_add, BitVec.reduceAdd]
  rw [MemoryState.storeAt_append (off := 8#64) (hov 8#64 (by decide) 16#64 (by decide)) (by decide)]
  simp only [Pointer.add_add, BitVec.reduceAdd]
  rw [MemoryState.storeAt_append (off := 8#64) (hov 8#64 (by decide) 24#64 (by decide)) (by decide)]
  simp only [Pointer.add_add, BitVec.reduceAdd, MemoryState.storeLimbs]
  rfl

/-- A field element's 40 bytes fit. -/
theorem MemoryState.LimbsFit.fits320 {m : MemoryState} (h : m.LimbsFit p) : Fits m p 320 := by
  have hov (k : BitVec 64) (hk : k.toNat ≤ 32) := Pointer.not_uaddOverflow_of_limbs h.1 hk
  exact
    Fits.append (off := 32#64) (w := 64) (hov _ (by decide)) (by decide) rfl
      (Fits.append (off := 24#64) (w := 64) (hov _ (by decide)) (by decide) rfl
        (Fits.append (off := 16#64) (w := 64) (hov _ (by decide)) (by decide) rfl
          (Fits.append (off := 8#64) (w := 64) (hov _ (by decide)) (by decide) rfl h.2.1 h.2.2.1)
          h.2.2.2.1)
        h.2.2.2.2.1)
      h.2.2.2.2.2

/-- Room for a field element's 40 bytes. -/
theorem MemoryState.LimbsRoom.room320 {m : MemoryState} (h : m.LimbsRoom p) : Room m p 320 := by
  have hov (k : BitVec 64) (hk : k.toNat ≤ 32) := Pointer.not_uaddOverflow_of_limbs h.1 hk
  exact
    Room.append (off := 32#64) (w := 64) (hov _ (by decide)) (by decide) rfl
      (Room.append (off := 24#64) (w := 64) (hov _ (by decide)) (by decide) rfl
        (Room.append (off := 16#64) (w := 64) (hov _ (by decide)) (by decide) rfl
          (Room.append (off := 8#64) (w := 64) (hov _ (by decide)) (by decide) rfl h.2.1 h.2.2.1)
          h.2.2.2.1)
        h.2.2.2.2.1)
      h.2.2.2.2.2

/-- A 320-bit read of limbs that fit: their reads. -/
theorem MemoryState.LimbsFit.extractLsb'_readAt {m : MemoryState} (h : m.LimbsFit p) :
    (fun i : Fin 5 => (m.readAt p 320).extractLsb' (64 * i.val) 64) = m.readLimbs p := by
  have hf := h.fits320
  have hr (k : BitVec 64) (hk : k.toNat ≤ 32) :=
    MemoryState.readAt_add_of_readAt (w := 64) hf.inBounds
      (Pointer.not_uaddOverflow_of_limbs h.1 hk) (by omega) rfl
  funext i
  fin_cases i
  · show _ = m.readAt p 64
    rw [MemoryState.readAt_of_readAt_le (w := 64) (v := 320) (by decide) rfl]
    ext j hj
    simp
  · exact (hr 8#64 (by decide)).symm
  · exact (hr 16#64 (by decide)).symm
  · exact (hr 24#64 (by decide)).symm
  · exact (hr 32#64 (by decide)).symm

/-- A 64-bit store over the first stored limb: that limb replaced. -/
theorem MemoryState.storeLimbs_storeAt_self {m : MemoryState} {p : Pointer}
    (h : p.offset.toNat + 32 < 2 ^ 64) (l : Fin 5 → BitVec 64) (x : BitVec 64) :
    (m.storeLimbs p l).storeAt p x =
      m.storeLimbs p fun
        | 0 => x
        | 1 => l 1
        | 2 => l 2
        | 3 => l 3
        | 4 => l 4 := by
  simp only [MemoryState.storeLimbs, MemoryState.storeAt, Pointer.add_id,
    MemoryState.modifyBlock_modifyBlock_self, implies_true, Function.comp_apply]
  congr 1
  funext blk
  have ho (k : Nat) (hk : k ≤ 32) := Pointer.offsetInBits_add_limb (p := p) h hk
  simp only [Function.comp_apply, MemoryBlock.mk.injEq, true_and, and_true]
  rw [show (8#64 : BitVec 64) = BitVec.ofNat 64 8 from rfl,
    show (16#64 : BitVec 64) = BitVec.ofNat 64 16 from rfl,
    show (24#64 : BitVec 64) = BitVec.ofNat 64 24 from rfl,
    show (32#64 : BitVec 64) = BitVec.ofNat 64 32 from rfl, ho 8 (by decide), ho 16 (by decide),
    ho 24 (by decide), ho 32 (by decide), show p.offsetInBits = 8 * p.offset.toNat from rfl]
  refine ⟨heq_of_eq ?_, heq_of_eq ?_⟩ <;> apply BitVec.eq_of_getLsbD_eq <;> intro i hi <;>
    simp only [getLsbD_spliceBits, BitVec.getLsbD_allOnes] <;>
    grind

end

end MLIR
