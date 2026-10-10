module

public import MLIR.Semantics.Effectful.Memory.Operations
public import Firedancer.Common.Point
public import Firedancer.Common.Memory
import Std.Data.ExtHashMap.Lemmas
import MLIR.Run.Tactic.Memory
import Std.Tactic.BVDecide

/-! `FieldElement51` in memory: `readLimbs`' five limbs, which the vectorized code also loads and
stores as `vector<2xi64>` pairs of adjacent limbs, and copies whole. -/

namespace MLIR.Agave

open Memory

@[expose] public section

/-- A limb offset `k ≤ 32` does not wrap. -/
theorem not_uaddOverflow_limb {p : Pointer} (h : p.offset.toNat + 32 < 2 ^ 64) {k : BitVec 64}
    (hk : k.toNat ≤ 32) : ¬p.offset.uaddOverflow k := by
  simp only [BitVec.uaddOverflow, ge_iff_le, decide_eq_true_eq, Nat.not_le]
  omega

/-- Limbs that fit are 320 known bits. -/
theorem fits_of_limbsFit {m : MemoryState} {p : Pointer} (h : m.LimbsFit p) : Fits m p 320 := by
  obtain ⟨ho, h0, h1, h2, h3, h4⟩ := h
  have a1 := Fits.append (not_uaddOverflow_limb ho (k := 8#64) (by decide)) (by decide) rfl h0 h1
  have a2 := Fits.append (not_uaddOverflow_limb ho (k := 16#64) (by decide)) (by decide) rfl a1 h2
  have a3 := Fits.append (not_uaddOverflow_limb ho (k := 24#64) (by decide)) (by decide) rfl a2 h3
  exact Fits.append (not_uaddOverflow_limb ho (k := 32#64) (by decide)) (by decide) rfl a3 h4

/-- Room for limbs is room for 320 bits. -/
theorem room_of_limbsRoom {m : MemoryState} {p : Pointer} (h : m.LimbsRoom p) : Room m p 320 := by
  obtain ⟨ho, -, -, -, -, ⟨blk, hblk, hl, hsz⟩⟩ := h
  rw [Pointer.offsetInBits_add (not_uaddOverflow_limb ho (by decide))] at hsz
  exact
    ⟨blk, by simpa [Pointer.add_id] using hblk, hl, by
      simp at hsz; omega⟩

/-- The limb pair at byte `k ≤ 24` fits. -/
theorem fits_pair {m : MemoryState} {p : Pointer} (h : m.LimbsFit p) {k : BitVec 64}
    (hk : k.toNat ≤ 24) : Fits m (p.add k) 128 :=
  Fits.add_of_le (not_uaddOverflow_limb h.1 (by omega)) (by omega) (fits_of_limbsFit h)

/-- Room for the limb pair at byte `k ≤ 24`. -/
theorem room_pair {m : MemoryState} {p : Pointer} (h : m.LimbsRoom p) {k : BitVec 64}
    (hk : k.toNat ≤ 24) : Room m (p.add k) 128 :=
  Room.add_of_le (not_uaddOverflow_limb h.1 (by omega)) (by omega) (room_of_limbsRoom h)

/-- The first limb pair fits. -/
theorem fits_pair0 {m : MemoryState} {p : Pointer} (h : m.LimbsFit p) : Fits m p 128 :=
  (fits_of_limbsFit h).mono (by decide)

/-- Room for the first limb pair. -/
theorem room_pair0 {m : MemoryState} {p : Pointer} (h : m.LimbsRoom p) : Room m p 128 :=
  (room_of_limbsRoom h).mono (by decide)

/-- Lane 0 of a 128-bit read: the 64-bit read. -/
theorem lane0_readAt {m : MemoryState} {p : Pointer} :
    Ty.extractVecElem 2 64 0 (m.readAt p 128) = m.readAt p 64 := by
  rw [MemoryState.readAt_of_readAt_le (w := 64) (v := 128) (by decide) rfl, Ty.extractVecElem_eq]
  ext i hi
  simp

/-- Lane 1 of a 128-bit read inside limbs that fit: the next limb. -/
theorem lane1_readAt {m : MemoryState} {p : Pointer} (h : m.LimbsFit p) {k : BitVec 64}
    (hk : k.toNat ≤ 24) :
    Ty.extractVecElem 2 64 1 (m.readAt (p.add k) 128) = m.readAt (p.add (k + 8#64)) 64 := by
  have hov : ¬(p.add k).offset.uaddOverflow 8#64 := by
    have := h.1
    simp only [Pointer.add, BitVec.uaddOverflow, ge_iff_le, decide_eq_true_eq, Nat.not_le,
      BitVec.toNat_add]
    rw [Nat.mod_eq_of_lt (by omega)]
    simp
    omega
  rw [← Pointer.add_add,
    MemoryState.readAt_add_of_readAt (w := 64) (fits_pair h hk).inBounds hov (by decide) rfl,
    Ty.extractVecElem_eq]
  rfl

/-- Lane 1 of the first pair: limb 1. -/
theorem lane1_readAt0 {m : MemoryState} {p : Pointer} (h : m.LimbsFit p) :
    Ty.extractVecElem 2 64 1 (m.readAt p 128) = m.readAt (p.add 8#64) 64 := by
  simpa [Pointer.add] using lane1_readAt h (k := 0#64) (by decide)

/-- A packed pair: its two lanes. -/
theorem packLanes_two (v : Vector (BitVec 64) 2) : BitVec.packLanes v = v[1] ++ v[0] := by
  have h0 := BitVec.extractLsb'_packLanes v 0 (by decide)
  have h1 := BitVec.extractLsb'_packLanes v 1 (by decide)
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  rw [BitVec.getLsbD_append]
  split
  · have := congrArg (·.getLsbD i) h0
    simp only [BitVec.getLsbD_extractLsb', Nat.zero_mul, Nat.zero_add] at this
    simpa [*] using this
  · have := congrArg (·.getLsbD (i - 64)) h1
    simp only [BitVec.getLsbD_extractLsb', Nat.one_mul] at this
    rw [show 64 + (i - 64) = i by omega] at this
    simpa [show i - 64 < 64 by omega] using this

/-- A store of a packed pair: the stores of its two lanes. -/
theorem storeAt_packLanes {m : MemoryState} {p : Pointer} (hov : ¬p.offset.uaddOverflow 8#64)
    (v : Vector (BitVec 64) 2) :
    m.storeAt p (BitVec.packLanes v) = (m.storeAt p v[0]).storeAt (p.add 8#64) v[1] := by
  rw [MemoryState.storeAt_storeAt_append (k := 8) hov rfl (by decide), packLanes_two]

/-- `storeAt_packLanes` at limb `k ≤ 24` of limbs whose offsets do not wrap. -/
theorem storeAt_packLanes_limb {m : MemoryState} {p : Pointer} (h : p.offset.toNat + 32 < 2 ^ 64)
    {k : BitVec 64} (hk : k.toNat ≤ 24) (v : Vector (BitVec 64) 2) :
    m.storeAt (p.add k) (BitVec.packLanes v) =
      (m.storeAt (p.add k) v[0]).storeAt (p.add (k + 8#64)) v[1] := by
  have hov : ¬(p.add k).offset.uaddOverflow 8#64 := by
    simp only [Pointer.add, BitVec.uaddOverflow, ge_iff_le, decide_eq_true_eq, Nat.not_le,
      BitVec.toNat_add]
    rw [Nat.mod_eq_of_lt (by omega)]
    simp
    omega
  rw [storeAt_packLanes hov, Pointer.add_add]

/-- Two limb stores at distinct limbs commute. -/
theorem storeAt_limb_comm {m : MemoryState} {p : Pointer} (h : p.offset.toNat + 32 < 2 ^ 64)
    {j k : Nat} (hj : j ≤ 32) (hk : k ≤ 32) (hjk : j + 8 ≤ k ∨ k + 8 ≤ j) (x y : BitVec 64) :
    (m.storeAt (p.add (BitVec.ofNat 64 j)) x).storeAt (p.add (BitVec.ofNat 64 k)) y =
      (m.storeAt (p.add (BitVec.ofNat 64 k)) y).storeAt (p.add (BitVec.ofNat 64 j)) x := by
  apply MemoryState.storeAt_comm
  simp only [Range.Disjoint, Range.of, Pointer.add, Pointer.offsetInBits, BitVec.toNat_add,
    BitVec.toNat_ofNat]
  right
  rw [Nat.mod_eq_of_lt (by omega : j < 2 ^ 64), Nat.mod_eq_of_lt (by omega : k < 2 ^ 64),
    Nat.mod_eq_of_lt (by omega), Nat.mod_eq_of_lt (by omega)]
  omega

/-- A limb store past one at limb 0 commutes with it. -/
theorem storeAt_limb0_comm {m : MemoryState} {p : Pointer} (h : p.offset.toNat + 32 < 2 ^ 64)
    {k : Nat} (hk8 : 8 ≤ k) (hk : k ≤ 32) (x y : BitVec 64) :
    (m.storeAt (p.add (BitVec.ofNat 64 k)) y).storeAt p x =
      (m.storeAt p x).storeAt (p.add (BitVec.ofNat 64 k)) y := by
  have := storeAt_limb_comm (m := m) h (j := k) (k := 0) hk (by omega) (by omega) y x
  simpa only [Pointer.add_zero'] using this

/-- Limbs stored as the pairs at bytes 0 and 16 and the last limb (`add`, `conditional_assign`). -/
theorem storeAt_pairs_eq_storeLimbs {m : MemoryState} {p : Pointer}
    (h : p.offset.toNat + 32 < 2 ^ 64) (lo hi : Vector (BitVec 64) 2) (x4 : BitVec 64) :
    ((m.storeAt p (BitVec.packLanes lo)).storeAt (p.add 16#64) (BitVec.packLanes hi)).storeAt
        (p.add 32#64) x4 =
      m.storeLimbs p fun
        | 0 => lo[0]
        | 1 => lo[1]
        | 2 => hi[0]
        | 3 => hi[1]
        | 4 => x4 := by
  rw [storeAt_packLanes (not_uaddOverflow_limb h (by decide)),
    storeAt_packLanes_limb h (k := 16#64) (by decide)]
  rfl

/-- Limbs stored as the pair at byte 8, limb 0, then the pair at byte 24 (`sub`, `neg`). -/
theorem storeAt_pairs_eq_storeLimbs' {m : MemoryState} {p : Pointer}
    (h : p.offset.toNat + 32 < 2 ^ 64) (x0 : BitVec 64) (v12 v34 : Vector (BitVec 64) 2) :
    ((m.storeAt (p.add 8#64) (BitVec.packLanes v12)).storeAt p x0).storeAt (p.add 24#64)
        (BitVec.packLanes v34) =
      m.storeLimbs p fun
        | 0 => x0
        | 1 => v12[0]
        | 2 => v12[1]
        | 3 => v34[0]
        | 4 => v34[1] := by
  rw [storeAt_packLanes_limb h (k := 8#64) (by decide),
    storeAt_packLanes_limb h (k := 24#64) (by decide)]
  rw [show (8#64 + 8#64 : BitVec 64) = BitVec.ofNat 64 16 from rfl,
    storeAt_limb0_comm h (k := 16) (by omega) (by omega),
    storeAt_limb0_comm (m := m) h (k := 8) (by omega) (by omega)]
  rfl

/-- Limbs in another block are unaffected by a store. -/
@[mlir_read]
theorem readLimbs_storeAt_of_id_ne {m : MemoryState} {p q : Pointer} {x : BitVec w}
    (h : q.id ≠ p.id) : (m.storeAt q x).readLimbs p = m.readLimbs p := by
  funext i
  fin_cases i <;> simp only [MemoryState.readLimbs, Tactic.readThroughStore]

/-- A store right after another: one store of both. -/
theorem storeAt_storeAt_add {m : MemoryState} {p : Pointer} {off : BitVec 64} {x : BitVec v}
    {y : BitVec w} (hov : ¬p.offset.uaddOverflow off) (hoff : off.toNat * 8 = v) :
    (m.storeAt p x).storeAt (p.add off) y = m.storeAt p (y ++ x) := by
  simp only [MemoryState.storeAt, MemoryState.storeDef, Pointer.add_id,
    MemoryState.modifyBlock_modifyBlock_self]
  congr 1
  funext blk
  simp only [Function.comp_apply, Pointer.offsetInBits_add hov, hoff, MemoryBlock.mk.injEq,
    true_and, and_true]
  refine ⟨heq_of_eq ?_, heq_of_eq ?_⟩ <;> apply BitVec.eq_of_getLsbD_eq <;> intro i hi <;>
    simp only [Memory.getLsbD_spliceBits, BitVec.getLsbD_append, BitVec.getLsbD_allOnes]
  · grind
  · split <;> split <;> (try split) <;> (try simp only [decide_eq_decide]) <;> omega

/-! ### Whole limbs -/

/-- The limbs' bits, limb `0` lowest. -/
def limbsBits (l : Fin 5 → BitVec 64) : BitVec 320 :=
  l 4 ++ (l 3 ++ (l 2 ++ (l 1 ++ l 0)))

/-- Storing limbs is storing their bits at once. -/
theorem storeLimbs_eq_storeAt {m : MemoryState} {p : Pointer} {l : Fin 5 → BitVec 64}
    (h : p.offset.toNat + 32 < 2 ^ 64) : m.storeLimbs p l = m.storeAt p (limbsBits l) := by
  have hov (k : Nat) (hk : k ≤ 32) : ¬p.offset.uaddOverflow (BitVec.ofNat 64 k) :=
    not_uaddOverflow_limb h
      (by
        simp; omega)
  unfold MemoryState.storeLimbs
  rw [MemoryState.storeAt_storeAt_append (hov 8 (by omega)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (hov 16 (by omega)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (hov 24 (by omega)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (hov 32 (by omega)) rfl (by decide)]
  rfl

/-- The 320 bits at limbs that fit: the limbs' bits. -/
theorem readAt_eq_limbsBits {m : MemoryState} {p : Pointer} (h : m.LimbsFit p) :
    m.readAt p 320 = limbsBits (m.readLimbs p) := by
  conv_lhs => rw [← MemoryState.storeLimbs_readLimbs_self h]
  rw [storeLimbs_eq_storeAt h.1, MemoryState.readAt_storeAt_self (fits_of_limbsFit h).inBounds]

/-- Limbs stored where there is room, read back whole: their bits. -/
@[mlir_read]
theorem readAt_storeLimbs_self {m : MemoryState} {p : Pointer} (h : m.LimbsRoom p)
    (l : Fin 5 → BitVec 64) : (m.storeLimbs p l).readAt p 320 = limbsBits l := by
  rw [storeLimbs_eq_storeAt h.1, MemoryState.readAt_storeAt_self (room_of_limbsRoom h).inBounds]

/-- A field element copied whole (a `memcpy` of 40 bytes): its limbs stored. -/
theorem storeAt_readAt_eq_storeLimbs {m m' : MemoryState} {p q : Pointer} (hq : m'.LimbsFit q)
    (hp : p.offset.toNat + 32 < 2 ^ 64) :
    m.storeAt p (m'.readAt q 320) = m.storeLimbs p (m'.readLimbs q) := by
  rw [readAt_eq_limbsBits hq, storeLimbs_eq_storeAt hp]

end

end MLIR.Agave
