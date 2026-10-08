module

public import Firedancer.Avx512.Common.Point
public import Firedancer.Avx512.Globals
public import Firedancer.Common.Point
public import Firedancer.Common.Dsmb

/-! Points in memory, as their callers use them: stores that commute, overwrite or restore, tables
of points, and points read from a known read. -/

namespace LeanMLIR.RIR

open Firedancer Firedancer.Avx512

@[expose] public section

/-- A vector's bits from its lanes. -/
theorem BitVec.packLanes_extractVecElem (x : BitVec 512) :
    BitVec.packLanes (Vector.ofFn fun i : Fin 8 => Ty.extractVecElem 8 64 i x) = x := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  rw [BitVec.getLsbD_packLanes _ hi, Vector.getElem_ofFn, Ty.extractVecElem_eq,
    BitVec.getLsbD_extractLsb']
  simp only [show i % 64 < 64 by omega, decide_true, Bool.true_and]
  congr 1
  omega

/-- Storing the lanes a vector holds changes nothing. -/
theorem MemoryState.storeVec_readVec_self {m : MemoryState} (h : Fits m p 512) :
    m.storeVec p (m.readVec p) = m := by
  rw [MemoryState.storeVec, MemoryState.readVec, BitVec.packLanes_extractVecElem,
    MemoryState.storeAt_readAt_self h]

/-- Storing what a point holds changes nothing. -/
theorem MemoryState.storeQuad_readQuad_self {m : MemoryState} (h : m.QuadFit p) :
    m.storeQuad p (m.readQuad p) = m := by
  simp only [MemoryState.storeQuad, MemoryState.readQuad]
  rw [MemoryState.storeVec_readVec_self h.fits_03, MemoryState.storeVec_readVec_self h.fits_14,
    MemoryState.storeVec_readVec_self h.fits_25]

/-- `storeQuad_readQuad_self` with the point named. -/
theorem MemoryState.storeQuad_readQuad_self' {m : MemoryState} (h : m.QuadFit p)
    (hP : m.readQuad p = P) : m.storeQuad p P = m := by rw [← hP, storeQuad_readQuad_self h]

/-- A point fits before a point store if it fits after it. -/
theorem MemoryState.QuadFit.of_storeQuad {m : MemoryState} (h : (m.storeQuad p P).QuadFit q) :
    m.QuadFit q := by
  simpa only [MemoryState.QuadFit, MemoryState.storeQuad, MemoryState.storeVec,
    Fits.storeAt_iff] using h

/-- A point stored twice at the same place: the second. -/
theorem MemoryState.storeQuad_storeQuad_self {m : MemoryState} {p : Pointer}
    (hp : p.offset.toNat + 192 ≤ 2 ^ 64) : (m.storeQuad p P).storeQuad p Q = m.storeQuad p Q :=
  MemoryState.storeAt_quad_twice hp

/-- Points in different blocks: their stores commute. -/
theorem MemoryState.storeQuad_comm {m : MemoryState} {p q : Pointer} (h : p.id ≠ q.id) :
    (m.storeQuad p P).storeQuad q Q = (m.storeQuad q Q).storeQuad p P := by
  have hd (a b : BitVec 64) : (Range.of (p.add a) 512).Disjoint (Range.of (q.add b) 512) :=
    Or.inl (by simpa [Range.of, Pointer.add] using h)
  have h0 : p.add 0#64 = p := by simp [Pointer.add]
  have h0' : q.add 0#64 = q := by simp [Pointer.add]
  have hpq := hd 0#64 0#64
  have hp1 := hd 0#64 64#64
  have hp2 := hd 0#64 128#64
  have h1q := hd 64#64 0#64
  have h2q := hd 128#64 0#64
  rw [h0, h0'] at hpq
  rw [h0] at hp1 hp2
  rw [h0'] at h1q h2q
  simp only [MemoryState.storeQuad, MemoryState.storeVec]
  rw [MemoryState.storeAt_swap h2q, MemoryState.storeAt_swap h1q, MemoryState.storeAt_swap hpq,
    MemoryState.storeAt_swap (hd 128#64 64#64), MemoryState.storeAt_swap (hd 64#64 64#64),
    MemoryState.storeAt_swap hp1, MemoryState.storeAt_swap (hd 128#64 128#64),
    MemoryState.storeAt_swap (hd 64#64 128#64), MemoryState.storeAt_swap hp2]

/-- A read outside the block of a point store: the read before it. -/
@[mlir_read]
theorem MemoryState.readAt_storeQuad_of_id_ne {m : MemoryState} {p q : Pointer} (h : p.id ≠ q.id) :
    (m.storeQuad p P).readAt q w = m.readAt q w := by
  have hd (a : BitVec 64) : (Range.of (p.add a) 512).Disjoint (Range.of q w) :=
    Or.inl (by simpa [Range.of, Pointer.add] using h)
  have h0 : (Range.of p 512).Disjoint (Range.of q w) := Or.inl (by simpa [Range.of] using h)
  simp only [MemoryState.storeQuad, MemoryState.storeVec, MemoryState.readAt_storeAt_disjoint, hd,
    h0]

/-- A point store into a block the erase removes: dropped. -/
@[mlir_erase high]
theorem MemoryState.eraseFrom_storeQuad_of_le {m : MemoryState} (h : n ≤ p.id.id) :
    (m.storeQuad p P).eraseFrom n = m.eraseFrom n := by
  rw [MemoryState.eraseFrom_storeQuad, MemoryState.storeQuad_eraseFrom_of_le h]

/-- Entry `k` of a table of `n` points from `p` fits where the table does. -/
theorem MemoryState.QuadFit.entry {m : MemoryState} {p : Pointer} (h : Fits m p (1536 * n))
    (hp : p.offset.toNat + 192 * n < 2 ^ 64) (hk : k < n) :
    m.QuadFit (p.add (BitVec.ofNat 64 (192 * k))) := by
  have hf (o : Nat) (ho : o + 64 ≤ 192) : Fits m (p.add (BitVec.ofNat 64 (192 * k + o))) 512 :=
    Fits.add_of_le
      (by
        simp [BitVec.uaddOverflow]; omega)
      (by
        simp; omega)
      h
  have hoff : (p.add (BitVec.ofNat 64 (192 * k))).offset.toNat = p.offset.toNat + 192 * k := by
    simp only [Pointer.add, BitVec.toNat_add, BitVec.toNat_ofNat]
    omega
  have hf0 := hf 0 (by omega)
  simp only [Nat.add_zero] at hf0
  refine ⟨by omega, hf0, ?_, ?_⟩
  · rw [show (64#64 : BitVec 64) = BitVec.ofNat 64 64 from rfl, add_ofNat_add]
    exact hf 64 (by omega)
  · rw [show (128#64 : BitVec 64) = BitVec.ofNat 64 128 from rfl, add_ofNat_add]
    exact hf 128 (by omega)

/-- A vector at byte `o` of a known read: its bits. -/
theorem MemoryState.readVec_add_of_readAt {m : MemoryState} {p : Pointer} {x : BitVec v}
    (hf : Fits m p v) (h : m.readAt p v = x) (hp : p.offset.toNat + o + 64 ≤ 2 ^ 64)
    (hv : 8 * o + 512 ≤ v) :
    m.readVec (p.add (BitVec.ofNat 64 o)) =
      Vector.ofFn fun i => x.extractLsb' (8 * o + 64 * i.val) 64 := by
  have ho : (BitVec.ofNat 64 o).toNat = o := by
    simp; omega
  rw [MemoryState.readVec,
    MemoryState.readAt_add_of_readAt hf
      (by
        simp [BitVec.uaddOverflow]; omega)
      (by
        rw [ho]; omega)
      h,
    ho]
  apply Vector.ext
  intro i hi
  simp only [Vector.getElem_ofFn, Ty.extractVecElem_eq]
  apply BitVec.eq_of_getLsbD_eq
  intro j hj
  simp only [BitVec.getLsbD_extractLsb', hj, decide_true, Bool.true_and,
    show i * 64 + j < 512 by omega]
  congr 1
  omega

/-- The point at byte `o` of a known read: its bits. -/
theorem MemoryState.readQuad_add_of_readAt {m : MemoryState} {p : Pointer} {x : BitVec v}
    (hf : Fits m p v) (h : m.readAt p v = x) (hp : p.offset.toNat + o + 192 ≤ 2 ^ 64)
    (hv : 8 * o + 1536 ≤ v) : m.readQuad (p.add (BitVec.ofNat 64 o)) = quadAt x (8 * o) := by
  simp only [MemoryState.readQuad, quadAt, add_ofNat_add]
  rw [MemoryState.readVec_add_of_readAt hf h (by omega) (by omega),
    MemoryState.readVec_add_of_readAt (o := o + 64) hf h (by omega) (by omega),
    MemoryState.readVec_add_of_readAt (o := o + 128) hf h (by omega) (by omega)]
  congr 1

/-- The point at byte `b` from `p`, past a point stored at byte `a`, apart from it. -/
theorem MemoryState.readQuad_storeQuad_apart {m : MemoryState} {p : Pointer} {a b : Nat}
    (hp : p.offset.toNat + a + 192 ≤ 2 ^ 64) (hb : p.offset.toNat + b + 192 ≤ 2 ^ 64)
    (hab : a + 192 ≤ b ∨ b + 192 ≤ a) :
    (m.storeQuad (p.add (BitVec.ofNat 64 a)) P).readQuad (p.add (BitVec.ofNat 64 b)) =
      m.readQuad (p.add (BitVec.ofNat 64 b)) := by
  have hd (c d : Nat) (hc : c ≤ 128) (hd : d ≤ 128) :
    (Range.of (p.add (BitVec.ofNat 64 (a + c))) 512).Disjoint
      (Range.of (p.add (BitVec.ofNat 64 (b + d))) 512) :=
    Range.disjoint_add (by omega) (by omega) (by omega)
  have h00 := hd 0 0 (by omega) (by omega)
  have h01 := hd 0 64 (by omega) (by omega)
  have h02 := hd 0 128 (by omega) (by omega)
  have h10 := hd 64 0 (by omega) (by omega)
  have h20 := hd 128 0 (by omega) (by omega)
  simp only [Nat.add_zero] at h00 h01 h02 h10 h20
  simp only [MemoryState.readQuad, MemoryState.storeQuad, MemoryState.readVec, MemoryState.storeVec,
    add_ofNat_add, MemoryState.readAt_storeAt_disjoint h00, MemoryState.readAt_storeAt_disjoint h01,
    MemoryState.readAt_storeAt_disjoint h02, MemoryState.readAt_storeAt_disjoint h10,
    MemoryState.readAt_storeAt_disjoint h20,
    MemoryState.readAt_storeAt_disjoint (hd 64 64 (by omega) (by omega)),
    MemoryState.readAt_storeAt_disjoint (hd 64 128 (by omega) (by omega)),
    MemoryState.readAt_storeAt_disjoint (hd 128 64 (by omega) (by omega)),
    MemoryState.readAt_storeAt_disjoint (hd 128 128 (by omega) (by omega))]

end

end LeanMLIR.RIR
