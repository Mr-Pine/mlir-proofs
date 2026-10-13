module

public import MLIR.Run.Tactic

/-! Whole-block bits and definedness: masked stores spliced in, and known ranges read off a known
definedness. -/

namespace MLIR.Zig

open Memory

/-- A read over a masked store inside it: the bits read before, the stored ones spliced in. -/
public theorem _root_.MLIR.MemoryState.readAt_add_storeDef {m : MemoryState} {p : Pointer}
    {off : BitVec 64} (h : Room m p v) (hov : ¬p.offset.uaddOverflow off)
    (_hw : off.toNat * 8 + w ≤ v) (x d : BitVec w) :
    (m.storeDef (p.add off) x d).readAt p v = spliceBits (m.readAt p v) (off.toNat * 8) x := by
  obtain ⟨blk, hblk, -, hsz, hwr⟩ := h.block
  have hs := MemoryState.getElem?_storeDef_self (p := p.add off) (x := x) (d := d) hblk hwr
  simp only [Pointer.add_id] at hs
  simp only [MemoryState.readAt, hs, hblk]
  unfold MemoryBlock.lengthInBits at hsz
  rw [Pointer.offsetInBits_add hov]
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp only [BitVec.getLsbD_extractLsb', getLsbD_spliceBits]
  grind

/-- Definedness over a masked store inside it: `d` spliced in. -/
public theorem _root_.MLIR.MemoryState.definedAt_add_storeDef {m : MemoryState} {p : Pointer}
    {off : BitVec 64} (h : Room m p v) (hov : ¬p.offset.uaddOverflow off)
    (_hw : off.toNat * 8 + w ≤ v) (x d : BitVec w) :
    (m.storeDef (p.add off) x d).definedAt p v =
      spliceBits (m.definedAt p v) (off.toNat * 8) d := by
  obtain ⟨blk, hblk, -, hsz, hwr⟩ := h.block
  have hs := MemoryState.getElem?_storeDef_self (p := p.add off) (x := x) (d := d) hblk hwr
  simp only [Pointer.add_id] at hs
  simp only [MemoryState.definedAt, hs, hblk]
  unfold MemoryBlock.lengthInBits at hsz
  rw [Pointer.offsetInBits_add hov]
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp only [BitVec.getLsbD_extractLsb', getLsbD_spliceBits]
  grind

/-- Definedness inside a known definedness: its bits. -/
public theorem _root_.MLIR.MemoryState.definedAt_add_of_definedAt {m : MemoryState} {p : Pointer}
    {off : BitVec 64} {d : BitVec v} (h : InBounds m p v) (hov : ¬p.offset.uaddOverflow off)
    (hw : off.toNat * 8 + w ≤ v) (hd : m.definedAt p v = d) :
    m.definedAt (p.add off) w = d.extractLsb' (off.toNat * 8) w := by
  subst hd
  obtain ⟨blk, hblk, hsz⟩ := h
  have hblk' : m[(p.add off).id]? = some blk := hblk
  unfold MemoryBlock.lengthInBits at hsz
  simp only [MemoryState.definedAt, hblk, hblk', Pointer.offsetInBits_add hov]
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp only [BitVec.getLsbD_extractLsb']
  grind

/-- A range inside a block whose definedness `d` sets it: known. -/
public theorem Fits.of_definedAt_add {m : MemoryState} {p : Pointer} {off : BitVec 64}
    {d : BitVec v} (h : Live m p v) (hov : ¬p.offset.uaddOverflow off) (hw : off.toNat * 8 + w ≤ v)
    (hd : m.definedAt p v = d) (hset : d.extractLsb' (off.toNat * 8) w = BitVec.allOnes w) :
    Fits m (p.add off) w := by
  obtain ⟨blk, hblk, hl, hsz⟩ := h
  have hblk' : m[(p.add off).id]? = some blk := hblk
  have e := MemoryState.definedAt_add_of_definedAt ⟨blk, hblk, hsz⟩ hov hw hd
  unfold MemoryBlock.lengthInBits at hsz
  refine ⟨blk, hblk', hl, ?_, ?_⟩
  · simp only [MemoryBlock.lengthInBits, Pointer.offsetInBits_add hov]; omega
  · simp only [MemoryState.definedAt, hblk'] at e
    rw [e, hset]

end MLIR.Zig
