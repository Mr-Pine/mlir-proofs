module

public import Firedancer.Common.Point
import Std.Data.ExtHashMap.Lemmas
import MLIR.Run.Tactic.Memory
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

/-! A field element's limbs in memory as one 320-bit value, and as the `vector<2xi64>` pairs of
adjacent limbs that vectorized code loads and stores. -/

namespace MLIR

open Memory

@[expose] public section

/-- The limbs' bits, limb `0` lowest. -/
def limbsBits (l : Fin 5 → BitVec 64) : BitVec 320 :=
  l 4 ++ l 3 ++ l 2 ++ l 1 ++ l 0

/-! ### Offsets and ranges -/

/-- An offset within a field element's 40 bytes does not wrap. -/
theorem Pointer.not_uaddOverflow_of_limbs {p : Pointer} (h : p.offset.toNat + 32 < 2 ^ 64)
    {k : BitVec 64} (hk : k.toNat ≤ 32) : ¬p.offset.uaddOverflow k := by
  simp only [BitVec.uaddOverflow, ge_iff_le, decide_eq_true_eq, Nat.not_le]
  omega

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

/-- Limbs that fit are 320 known bits. -/
theorem MemoryState.LimbsFit.fits {m : MemoryState} {p : Pointer} (h : m.LimbsFit p) :
    Fits m p 320 := by
  obtain ⟨ho, h0, h1, h2, h3, h4⟩ := h
  have hov (k : BitVec 64) (hk : k.toNat ≤ 32) := Pointer.not_uaddOverflow_of_limbs ho hk
  have a1 := Fits.append (hov 8#64 (by decide)) (by decide) rfl h0 h1
  have a2 := Fits.append (hov 16#64 (by decide)) (by decide) rfl a1 h2
  have a3 := Fits.append (hov 24#64 (by decide)) (by decide) rfl a2 h3
  exact Fits.append (hov 32#64 (by decide)) (by decide) rfl a3 h4

/-- The five limbs at `p` lie in one live block: room for 320 bits there. -/
theorem MemoryState.LimbsRoom.room320 {m : MemoryState} {p : Pointer} (h : m.LimbsRoom p) :
    Room m p 320 := by
  obtain ⟨ho, -, -, -, -, h4⟩ := h
  obtain ⟨blk, hblk, hl, hsz, hwr⟩ := h4.block
  refine Room.of_block (by simpa [Pointer.add_id] using hblk) hl ?_ hwr
  rw [show (32#64 : BitVec 64) = BitVec.ofNat 64 32 from rfl,
    Pointer.offsetInBits_add_limb ho (by omega)] at hsz
  unfold Pointer.offsetInBits
  omega

/-- Limbs whose 320 bits are known, offsets not wrapping, are limbs that fit. -/
theorem MemoryState.LimbsFit.of_fits' {m : MemoryState} {p : Pointer} (h : Fits m p 320)
    (ho : p.offset.toNat + 32 < 2 ^ 64) : m.LimbsFit p := by
  refine ⟨ho, h.mono (by omega), ?_, ?_, ?_, ?_⟩ <;>
    exact Fits.add_of_le (Pointer.not_uaddOverflow_of_limbs ho (by decide)) (by decide) h

/-- Limbs `o` bytes into a block known from its start fit. -/
theorem MemoryState.LimbsFit.of_fits_at {m : MemoryState} {p : Pointer} {o : Nat} (h : Fits m p v)
    (ho : p.offset = 0) (hv : 8 * (o + 40) ≤ v) (ho' : o + 40 ≤ 2 ^ 64) :
    m.LimbsFit (p.add (BitVec.ofNat 64 o)) := by
  have hf (c : Nat) (hc : c ≤ 32) :
    Fits m ((p.add (BitVec.ofNat 64 o)).add (BitVec.ofNat 64 c)) 64 := by
    rw [Pointer.add_add, ← BitVec.ofNat_add]
    exact
      Fits.add_of_le
        (by
          simp [ho, BitVec.uaddOverflow]; omega)
        (by
          simp; omega)
        h
  have h0 := hf 0 (by omega)
  rw [Pointer.add_zero'] at h0
  exact
    ⟨by
      simp [Pointer.add, ho]; omega, h0, hf 8 (by omega), hf 16 (by omega), hf 24 (by omega),
      hf 32 (by omega)⟩

/-- Five limbs `j` bytes into a block from its start, `j + 40` bytes within it. -/
theorem MemoryState.LimbsRoom.of_room_at {m : MemoryState} {p : Pointer} {n : Nat} {j : BitVec 64}
    (h : Room m p n) (ho : p.offset = 0) (hj : 8 * (j.toNat + 40) ≤ n)
    (hj' : j.toNat + 40 ≤ 2 ^ 64) : m.LimbsRoom (p.add j) := by
  have hr (c : BitVec 64) (hc : c.toNat ≤ 32) : Room m ((p.add j).add c) 64 := by
    rw [Pointer.add_add]
    have hjc : (j + c).toNat = j.toNat + c.toNat := by
      rw [BitVec.toNat_add, Nat.mod_eq_of_lt (show j.toNat + c.toNat < 2 ^ 64 by omega)]
    exact
      Room.add_of_le
        (by
          simp [ho, BitVec.uaddOverflow]; omega)
        (by
          rw [hjc]; omega)
        h
  have h0 := hr 0#64 (by decide)
  rw [Pointer.add_add, BitVec.add_zero] at h0
  exact
    ⟨by
      simp [Pointer.add, ho]; omega, h0, hr _ (by decide), hr _ (by decide), hr _ (by decide),
      hr _ (by decide)⟩

/-- Room for a point `k` bytes into a block from its start, `k + 160` bytes within it. -/
theorem MemoryState.PointRoom.of_room_at {m : MemoryState} {p : Pointer} {n : Nat} {k : BitVec 64}
    (h : Room m p n) (ho : p.offset = 0) (hk : 8 * (k.toNat + 160) ≤ n)
    (hk' : k.toNat + 160 ≤ 2 ^ 64) : m.PointRoom (p.add k) := by
  have hl (c : BitVec 64) (hc : c.toNat ≤ 120) : m.LimbsRoom ((p.add k).add c) := by
    rw [Pointer.add_add]
    have hkc : (k + c).toNat = k.toNat + c.toNat := by
      rw [BitVec.toNat_add, Nat.mod_eq_of_lt (show k.toNat + c.toNat < 2 ^ 64 by omega)]
    exact
      MemoryState.LimbsRoom.of_room_at h ho
        (by
          rw [hkc]; omega)
        (by
          rw [hkc]; omega)
  have h0 := hl 0#64 (by decide)
  rw [Pointer.add_add, BitVec.add_zero] at h0
  exact
    ⟨by
      simp [Pointer.add, ho]; omega, h0, hl _ (by decide), hl _ (by decide), hl _ (by decide)⟩

/-- The limbs at byte `o` of a known read: its bits. -/
theorem MemoryState.readLimbs_add_of_readAt {m : MemoryState} {p : Pointer} {x : BitVec v}
    (hf : InBounds m p v) (h : m.readAt p v = x) (hp : p.offset.toNat + o + 40 ≤ 2 ^ 64)
    (hv : 8 * o + 320 ≤ v) :
    m.readLimbs (p.add (BitVec.ofNat 64 o)) = fun i => x.extractLsb' (8 * o + 64 * i.val) 64 := by
  have hr (c : Nat) (hc : c ≤ 32) :
    m.readAt (p.add (BitVec.ofNat 64 (o + c))) 64 = x.extractLsb' (8 * o + 8 * c) 64 := by
    rw [MemoryState.readAt_add_of_readAt hf
        (by
          simp [BitVec.uaddOverflow]; omega)
        (by
          simp; omega)
        h]
    congr 1
    simp
    omega
  have h0 := hr 0 (by omega)
  simp only [Nat.add_zero, Nat.mul_zero] at h0
  funext i
  fin_cases i <;> simp only [MemoryState.readLimbs, Pointer.add_add, ← BitVec.ofNat_add]
  · exact h0
  · exact hr 8 (by omega)
  · exact hr 16 (by omega)
  · exact hr 24 (by omega)
  · exact hr 32 (by omega)

/-! ### Points at any offset -/

/-- An offset within a point's 160 bytes does not wrap. -/
theorem Pointer.not_uaddOverflow_of_point {p : Pointer} (ho : p.offset.toNat + 160 ≤ 2 ^ 64)
    {k : BitVec 64} (hk : k.toNat < 160) : ¬p.offset.uaddOverflow k := by
  simp only [BitVec.uaddOverflow, decide_eq_true_eq, Nat.not_le]; omega

/-- A field element's offset `a` inside an `n`-byte object whose offsets do not wrap. -/
theorem Pointer.coord_offset_le {p : Pointer} {a n : Nat} (hp : p.offset.toNat + n ≤ 2 ^ 64)
    (ha : a + 40 ≤ n) : (p.add (BitVec.ofNat 64 a)).offset.toNat + 32 < 2 ^ 64 := by
  simp only [Pointer.add, BitVec.toNat_add, BitVec.toNat_ofNat]
  rw [Nat.mod_eq_of_lt (by omega : a < 2 ^ 64), Nat.mod_eq_of_lt (by omega)]
  omega

/-- Room for limbs from room for their 320 bits. -/
theorem MemoryState.LimbsRoom.of_room' {m : MemoryState} {p : Pointer} (h : Room m p 320)
    (ho : p.offset.toNat + 32 < 2 ^ 64) : m.LimbsRoom p := by
  refine ⟨ho, h.mono (by omega), ?_, ?_, ?_, ?_⟩ <;>
    exact Room.add_of_le (Pointer.not_uaddOverflow_of_limbs ho (by decide)) (by decide) h

/-- Room for a point from room for its 1280 bits. -/
theorem MemoryState.PointRoom.of_room' {m : MemoryState} {p : Pointer} (h : Room m p 1280)
    (ho : p.offset.toNat + 160 ≤ 2 ^ 64) : m.PointRoom p :=
  ⟨ho, .of_room' (h.mono (by decide)) (by omega),
    .of_room' (Room.add_of_le (Pointer.not_uaddOverflow_of_point ho (by decide)) (by decide) h)
      (Pointer.coord_offset_le ho (a := 40) (by omega)),
    .of_room' (Room.add_of_le (Pointer.not_uaddOverflow_of_point ho (by decide)) (by decide) h)
      (Pointer.coord_offset_le ho (a := 80) (by omega)),
    .of_room' (Room.add_of_le (Pointer.not_uaddOverflow_of_point ho (by decide)) (by decide) h)
      (Pointer.coord_offset_le ho (a := 120) (by omega))⟩

/-- A point that fits from its 1280 bits that fit. -/
theorem MemoryState.PointFit.of_fits' {m : MemoryState} {p : Pointer} (h : Fits m p 1280)
    (ho : p.offset.toNat + 160 ≤ 2 ^ 64) : m.PointFit p :=
  ⟨ho, .of_fits' (h.mono (by decide)) (by omega),
    .of_fits' (Fits.add_of_le (Pointer.not_uaddOverflow_of_point ho (by decide)) (by decide) h)
      (Pointer.coord_offset_le ho (a := 40) (by omega)),
    .of_fits' (Fits.add_of_le (Pointer.not_uaddOverflow_of_point ho (by decide)) (by decide) h)
      (Pointer.coord_offset_le ho (a := 80) (by omega)),
    .of_fits' (Fits.add_of_le (Pointer.not_uaddOverflow_of_point ho (by decide)) (by decide) h)
      (Pointer.coord_offset_le ho (a := 120) (by omega))⟩

/-- A point's 1280 bits fit where its field elements do. -/
theorem MemoryState.PointFit.fits {m : MemoryState} {p : Pointer} (h : m.PointFit p) :
    Fits m p 1280 := by
  have hov (k : BitVec 64) (hk : k.toNat < 160) := Pointer.not_uaddOverflow_of_point h.1 hk
  exact
    Fits.append (off := 120#64) (hov _ (by decide)) rfl rfl
      (Fits.append (off := 80#64) (hov _ (by decide)) rfl rfl
        (Fits.append (off := 40#64) (hov _ (by decide)) rfl rfl h.limbsFit_0.fits
          h.limbsFit_40.fits)
        h.limbsFit_80.fits)
      h.limbsFit_120.fits

/-! ### Limbs as one 320-bit value -/

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

/-- Five limbs spliced in one after another: their bits spliced in at once. -/
theorem spliceBits_limbsBits {n : Nat} (b : BitVec n) (o : Nat) (l : Fin 5 → BitVec 64) :
    spliceBits
        (spliceBits (spliceBits (spliceBits (spliceBits b o (l 0)) (o + 64) (l 1)) (o + 128) (l 2))
          (o + 192) (l 3))
        (o + 256) (l 4) =
      spliceBits b o (limbsBits l) := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp only [getLsbD_spliceBits, getLsbD_limbsBits]
  by_cases h0 : o ≤ i <;> by_cases h1 : i < o + 64 <;> by_cases h2 : i < o + 128 <;>
    by_cases h3 : i < o + 192 <;>
    by_cases h4 : i < o + 256 <;>
    by_cases h5 : i < o + 320 <;>
    simp (disch := omega) only [ite_eq_left, ite_eq_right, Nat.sub_sub] <;>
    omega

/-- All-ones limbs' bits are all ones. -/
theorem limbsBits_allOnes : limbsBits (fun _ => BitVec.allOnes 64) = BitVec.allOnes 320 := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp only [getLsbD_limbsBits, BitVec.getLsbD_allOnes]
  split_ifs <;> simp <;> omega

/-- Storing limbs is storing their bits at once. -/
theorem MemoryState.storeLimbs_eq_storeAt {m : MemoryState} {p : Pointer} {l : Fin 5 → BitVec 64}
    (h : p.offset.toNat + 32 < 2 ^ 64) : m.storeLimbs p l = m.storeAt p (limbsBits l) := by
  have hp : p.offsetInBits = 8 * p.offset.toNat := rfl
  have o (k : Nat) (hk : k ≤ 32) :
    (p.add (BitVec.ofNat 64 k)).offsetInBits = p.offsetInBits + 8 * k :=
    hp ▸ Pointer.offsetInBits_add_limb h hk
  simp only [MemoryState.storeLimbs, MemoryState.storeAt, Pointer.add_id,
    MemoryState.modifyBlock_modifyBlock_self, implies_true, Function.comp_apply]
  congr 1
  funext blk
  simp only [Function.comp_apply, MemoryBlock.mk.injEq, true_and, and_true]
  rw [o 8 (by omega), o 16 (by omega), o 24 (by omega), o 32 (by omega)]
  refine ⟨heq_of_eq (spliceBits_limbsBits _ _ l), heq_of_eq ?_⟩
  rw [← limbsBits_allOnes]
  exact spliceBits_limbsBits _ _ (fun _ => BitVec.allOnes 64)

/-- The 320 bits at limbs that fit: the limbs' bits. -/
theorem MemoryState.readAt_eq_limbsBits {m : MemoryState} {p : Pointer} (h : m.LimbsFit p) :
    m.readAt p 320 = limbsBits (m.readLimbs p) := by
  -- in a copy of `m` with `p`'s block writable, which reads the same
  let m' := m.makeWritable p.id
  have hr (q : Pointer) (w : Nat) : m'.readAt q w = m.readAt q w := MemoryState.readAt_makeWritable
  have h' : m'.LimbsFit p :=
    ⟨h.1, h.2.1.makeWritable, h.2.2.1.makeWritable, h.2.2.2.1.makeWritable,
      h.2.2.2.2.1.makeWritable, h.2.2.2.2.2.makeWritable⟩
  have hl : m'.readLimbs p = m.readLimbs p := by
    funext i; fin_cases i <;> simp only [MemoryState.readLimbs, hr]
  rw [← hr, ← hl]
  conv_lhs => rw [← MemoryState.storeLimbs_readLimbs_self h']
  rw [MemoryState.storeLimbs_eq_storeAt h.1,
    MemoryState.readAt_storeAt_self (Room.makeWritable_self h.fits.live)]

/-- Limbs stored where there is room, read back whole: their bits. -/
theorem MemoryState.readAt_storeLimbs_self {m : MemoryState} {p : Pointer} (h : m.LimbsRoom p)
    (l : Fin 5 → BitVec 64) : (m.storeLimbs p l).readAt p 320 = limbsBits l := by
  rw [MemoryState.storeLimbs_eq_storeAt h.1, MemoryState.readAt_storeAt_self h.room320]

/-- A field element copied whole (a `memcpy` of 40 bytes): its limbs stored. -/
theorem MemoryState.storeAt_readAt_eq_storeLimbs {m m' : MemoryState} {p q : Pointer}
    (hq : m'.LimbsFit q) (hp : p.offset.toNat + 32 < 2 ^ 64) :
    m.storeAt p (m'.readAt q 320) = m.storeLimbs p (m'.readLimbs q) := by
  rw [MemoryState.readAt_eq_limbsBits hq, MemoryState.storeLimbs_eq_storeAt hp]

/-- Limbs in another block are unaffected by a store. -/
theorem MemoryState.readLimbs_storeAt_of_id_ne {m : MemoryState} {p q : Pointer} {x : BitVec w}
    (h : q.id ≠ p.id) : (m.storeAt q x).readLimbs p = m.readLimbs p := by
  funext i
  fin_cases i <;> simp only [MemoryState.readLimbs, Tactic.readThroughStore]

/-! ### Limb pairs -/

/-- The limb pair at byte `k ≤ 24` fits. -/
theorem MemoryState.LimbsFit.fits_pair {m : MemoryState} {p : Pointer} (h : m.LimbsFit p)
    {k : BitVec 64} (hk : k.toNat ≤ 24) : Fits m (p.add k) 128 :=
  Fits.add_of_le (Pointer.not_uaddOverflow_of_limbs h.1 (by omega)) (by omega) h.fits

/-- Room for the limb pair at byte `k ≤ 24`. -/
theorem MemoryState.LimbsRoom.room_pair {m : MemoryState} {p : Pointer} (h : m.LimbsRoom p)
    {k : BitVec 64} (hk : k.toNat ≤ 24) : Room m (p.add k) 128 :=
  Room.add_of_le (Pointer.not_uaddOverflow_of_limbs h.1 (by omega)) (by omega) h.room320

/-- The first limb pair fits. -/
theorem MemoryState.LimbsFit.fits_lo {m : MemoryState} (h : m.LimbsFit p) : Fits m p 128 :=
  h.fits.mono (by decide)

/-- The second limb pair fits. -/
theorem MemoryState.LimbsFit.fits_hi {m : MemoryState} (h : m.LimbsFit p) :
    Fits m (p.add 16#64) 128 :=
  h.fits_pair (by decide)

/-- Room for the first limb pair. -/
theorem MemoryState.LimbsRoom.room_lo {m : MemoryState} (h : m.LimbsRoom p) : Room m p 128 :=
  h.room320.mono (by decide)

/-- Room for the second limb pair. -/
theorem MemoryState.LimbsRoom.room_hi {m : MemoryState} (h : m.LimbsRoom p) :
    Room m (p.add 16#64) 128 :=
  h.room_pair (by decide)

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

/-- Lane 1 of the pair at byte `k ≤ 24` of limbs that fit: the next limb. -/
theorem MemoryState.LimbsFit.extractVecElem_one {m : MemoryState} {p : Pointer} (h : m.LimbsFit p)
    {k : BitVec 64} (hk : k.toNat ≤ 24) :
    Ty.extractVecElem 2 64 1 (m.readAt (p.add k) 128) = m.readAt (p.add (k + 8#64)) 64 := by
  have hov : ¬(p.add k).offset.uaddOverflow 8#64 := by
    have := h.1
    simp only [Pointer.add, BitVec.uaddOverflow, ge_iff_le, decide_eq_true_eq, Nat.not_le,
      BitVec.toNat_add]
    rw [Nat.mod_eq_of_lt (by omega)]
    simp
    omega
  rw [← Pointer.add_add, MemoryState.extractVecElem_one_readAt (h.fits_pair hk).inBounds hov]

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

/-- Bit `m` of packed lanes: bit `m % we` of lane `m / we`. -/
theorem BitVec.getLsbD_packLanes {we n : Nat} (v : Vector (BitVec we) n) {m : Nat}
    (hm : m < we * n) :
    (BitVec.packLanes v).getLsbD m = (v[m / we]'(Nat.div_lt_of_lt_mul hm)).getLsbD (m % we) := by
  have hwe : 0 < we := Nat.pos_of_ne_zero fun h => by simp [h] at hm
  have h :=
    BitVec.extractLsb'_packLanes_of_lt v (s := m) (w := 1) (Nat.div_lt_of_lt_mul hm)
      (Nat.mod_lt _ hwe)
  simpa [BitVec.getLsbD_extractLsb'] using congrArg (·.getLsbD 0) h

/-- A packed pair: its two lanes. -/
theorem BitVec.packLanes_pair (v : Vector (BitVec 64) 2) : BitVec.packLanes v = v[1] ++ v[0] := by
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

/-- Four packed lanes: lane 0 lowest. -/
theorem BitVec.packLanes_quad (v : Vector (BitVec 64) 4) :
    BitVec.packLanes v = v[3] ++ (v[2] ++ (v[1] ++ v[0])) := by
  simp only [BitVec.packLanes, Vector.tail_eq_cast_extract, Vector.getElem_cast,
    Vector.getElem_extract, Nat.reduceAdd]
  generalize v[0] = a, v[1] = b, v[2] = c, v[3] = d
  bv_decide

/-- A store of a packed pair: the stores of its two lanes. -/
theorem MemoryState.storeAt_packLanes {m : MemoryState} {p : Pointer}
    (hov : ¬p.offset.uaddOverflow 8#64) (v : Vector (BitVec 64) 2) :
    m.storeAt p (BitVec.packLanes v) = (m.storeAt p v[0]).storeAt (p.add 8#64) v[1] := by
  rw [MemoryState.storeAt_storeAt_append (k := 8) hov rfl (by decide), BitVec.packLanes_pair]

/-- `storeAt_packLanes` at limb `k ≤ 24` of limbs whose offsets do not wrap. -/
theorem MemoryState.storeAt_packLanes_limb {m : MemoryState} {p : Pointer}
    (h : p.offset.toNat + 32 < 2 ^ 64) {k : BitVec 64} (hk : k.toNat ≤ 24)
    (v : Vector (BitVec 64) 2) :
    m.storeAt (p.add k) (BitVec.packLanes v) =
      (m.storeAt (p.add k) v[0]).storeAt (p.add (k + 8#64)) v[1] := by
  have hov : ¬(p.add k).offset.uaddOverflow 8#64 := by
    simp only [Pointer.add, BitVec.uaddOverflow, ge_iff_le, decide_eq_true_eq, Nat.not_le,
      BitVec.toNat_add]
    rw [Nat.mod_eq_of_lt (by omega)]
    simp
    omega
  rw [MemoryState.storeAt_packLanes hov, Pointer.add_add]

/-- The limb pairs' stores at `p` and `p + 16`, then the last limb: the limbs' stores. -/
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

end

end MLIR
