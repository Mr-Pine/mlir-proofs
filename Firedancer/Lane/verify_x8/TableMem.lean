module

public import Firedancer.Lane.verify_x8.Defs
public import Firedancer.Lane.Common.Mem
import Firedancer.Common.Memory
import Mathlib.Tactic.FinCases
import Std.Data.ExtHashMap.Lemmas

/-! The memory side of `verify_x8`'s table: a table entry's 1600 bytes, field elements and entries
read from their cells, the reads of a stored point, and the frame of the table's writes, which
keeps every block `At83` reads past the slots. -/

namespace MLIR.Firedancer.Lane.VerifyX8

open Firedancer.Avx512

@[expose] public section

/-! ### A table entry's bits -/

/-- Cell `j` of a table entry: limb `j % 5` of component `j / 5` (`p, m, k, nk, z`). -/
def _root_.MLIR.Firedancer.Lane.Niels.cell (N : Niels) (j : Fin 25) : Wwl :=
  (#v[N.p, N.m, N.k, N.nk, N.z][j.val / 5]'(by omega)).limb ⟨j.val % 5, by omega⟩

/-- A table entry's 1600 bytes, cell `0` lowest. -/
def _root_.MLIR.Firedancer.Lane.Niels.bits (N : Niels) : BitVec 12800 :=
  BitVec.packLanes (Vector.ofFn fun j : Fin 25 => BitVec.packLanes (N.cell j))

/-- A lane of a packed bitvector, bit by bit. -/
theorem getLsbD_packLanes {we n : Nat} (v : Vector (BitVec we) n) {i : Nat} (hi : i < we * n) :
    (BitVec.packLanes v).getLsbD i = (v[i / we]'(Nat.div_lt_of_lt_mul hi)).getLsbD (i % we) := by
  have hwe : 0 < we := Nat.pos_of_ne_zero fun h => by simp [h] at hi
  have h :=
    congrArg (·.getLsbD 0)
      (BitVec.extractLsb'_packLanes_of_lt v (s := i) (w := 1) (Nat.div_lt_of_lt_mul hi)
        (by have := Nat.mod_lt i hwe; omega))
  simpa using h

/-! ### Ranges of a block at offset zero -/

section Ranges

variable {m : MemoryState} {q : Pointer}

/-- No literal offset below `2 ^ 64` wraps from offset zero. -/
theorem nov_of_zero (hq : q.offset = 0) {k : Nat} (h : k < 2 ^ 64) :
    ¬q.offset.uaddOverflow (BitVec.ofNat 64 k) := by
  rw [hq]
  simp only [BitVec.uaddOverflow, BitVec.toNat_ofNat, decide_eq_true_eq, Nat.not_le,
    Nat.mod_eq_of_lt h]
  simpa using h

theorem add_ofNat_add_ofNat (a b : Nat) :
    (q.add (BitVec.ofNat 64 a)).add (BitVec.ofNat 64 b) = q.add (BitVec.ofNat 64 (a + b)) := by
  rw [Pointer.add_add, BitVec.ofNat_add]

theorem offset_add_ofNat (hq : q.offset = 0) {a : Nat} :
    (q.add (BitVec.ofNat 64 a)).offset = BitVec.ofNat 64 a := by
  simp [Pointer.add, hq]

/-- A range inside a fitting one, both from `q` plus a literal. -/
theorem fits_sub (hq : q.offset = 0) {o o' w w' : Nat} (h : Fits m (q.add (BitVec.ofNat 64 o)) w)
    (h1 : o ≤ o') (h2 : 8 * o' + w' ≤ 8 * o + w) (hlt : o' < 2 ^ 64) :
    Fits m (q.add (BitVec.ofNat 64 o')) w' := by
  have hlt' : o < 2 ^ 64 := by omega
  have := h.add_of_le (off := BitVec.ofNat 64 (o' - o)) (w := w')
    (by rw [offset_add_ofNat hq]; simp [BitVec.uaddOverflow]; omega)
    (by simp; omega)
  rwa [add_ofNat_add_ofNat, Nat.add_sub_cancel' h1] at this

/-- A range inside an in-bounds one, both from `q` plus a literal. -/
theorem inBounds_sub (hq : q.offset = 0) {o o' w w' : Nat}
    (h : InBounds m (q.add (BitVec.ofNat 64 o)) w) (h1 : o ≤ o') (h2 : 8 * o' + w' ≤ 8 * o + w)
    (hlt : o' < 2 ^ 64) : InBounds m (q.add (BitVec.ofNat 64 o')) w' := by
  have hlt' : o < 2 ^ 64 := by omega
  have := h.add_of_le (off := BitVec.ofNat 64 (o' - o)) (w := w')
    (by rw [offset_add_ofNat hq]; simp [BitVec.uaddOverflow]; omega)
    (by simp; omega)
  rwa [add_ofNat_add_ofNat, Nat.add_sub_cancel' h1] at this

/-- A read inside a known one, both from `q` plus a literal. -/
theorem readAt_sub (hq : q.offset = 0) {o o' w w' : Nat} {x : BitVec w}
    (hb : InBounds m (q.add (BitVec.ofNat 64 o)) w) (h : m.readAt (q.add (BitVec.ofNat 64 o)) w = x)
    (h1 : o ≤ o') (h2 : 8 * o' + w' ≤ 8 * o + w) (hlt : o' < 2 ^ 64) :
    m.readAt (q.add (BitVec.ofNat 64 o')) w' = x.extractLsb' (8 * (o' - o)) w' := by
  have hlt' : o < 2 ^ 64 := by omega
  have := MemoryState.readAt_add_of_readAt (off := BitVec.ofNat 64 (o' - o)) (w := w') hb
    (by rw [offset_add_ofNat hq]; simp [BitVec.uaddOverflow]; omega)
    (by simp; omega) h
  rw [add_ofNat_add_ofNat, Nat.add_sub_cancel' h1] at this
  rw [this]
  congr 1
  simp only [BitVec.toNat_ofNat]
  rw [Nat.mod_eq_of_lt (by omega)]
  omega

/-- `n + 1` 512-bit cells that fit, at `q` plus `o + 64 k`: their range fits. -/
theorem fits_cells (hq : q.offset = 0) {o : Nat} :
    ∀ (n : Nat), (∀ k : Fin (n + 1), Fits m (q.add (BitVec.ofNat 64 (o + 64 * k))) 512) →
      o + 64 * (n + 1) < 2 ^ 64 → Fits m (q.add (BitVec.ofNat 64 o)) (512 * (n + 1))
  | 0, h, _ => by simpa using h 0
  | n + 1, h, hlt => by
    have ih := fits_cells hq n (fun k => h k.castSucc) (by omega)
    have hl := h (Fin.last (n + 1))
    simp only [Fin.val_last] at hl
    rw [← add_ofNat_add_ofNat] at hl
    exact Fits.append (off := BitVec.ofNat 64 (64 * (n + 1)))
      (by rw [offset_add_ofNat hq]; simp [BitVec.uaddOverflow]; omega)
      (by simp; omega) (by omega) ih hl

/-- `n` 512-bit cells read at `q` plus `o + 64 k`: their range's bits. -/
theorem readAt_cells (hq : q.offset = 0) {o n : Nat} {f : Fin n → BitVec 512}
    (hb : InBounds m (q.add (BitVec.ofNat 64 o)) (512 * n)) (hlt : o + 64 * n < 2 ^ 64)
    (h : ∀ k : Fin n, m.readAt (q.add (BitVec.ofNat 64 (o + 64 * k))) 512 = f k) :
    m.readAt (q.add (BitVec.ofNat 64 o)) (512 * n) = BitVec.packLanes (Vector.ofFn f) := by
  refine MemoryState.readAt_eq_of_cells512 hb
    (by rw [offset_add_ofNat hq]; simp [BitVec.uaddOverflow]; omega) (by omega)
    fun k hk => ?_
  rw [add_ofNat_add_ofNat, h ⟨k, hk⟩, Nat.mul_comm 512 k,
    BitVec.extractLsb'_packLanes _ k hk, Vector.getElem_ofFn]

end Ranges

/-! ### Field elements and table entries from their reads -/

section Objects

variable {m : MemoryState} {q : Pointer}

/-- Component `k` of a table entry: `p, m, k, nk, z`. -/
def _root_.MLIR.Firedancer.Lane.Niels.comp (N : Niels) (k : Fin 5) : Fe :=
  #v[N.p, N.m, N.k, N.nk, N.z][k]

/-- A field element's 320 bytes, limb 0 lowest. -/
def _root_.MLIR.Firedancer.Lane.Fe.bits (a : Fe) : BitVec 2560 :=
  BitVec.packLanes (Vector.ofFn fun l : Fin 5 => BitVec.packLanes (a.limb l))

theorem fe_bits_extract (a : Fe) (l : Nat) (hl : l < 5) :
    a.bits.extractLsb' (512 * l) 512 = BitVec.packLanes (a.limb ⟨l, hl⟩) := by
  rw [Fe.bits, Nat.mul_comm, BitVec.extractLsb'_packLanes _ l hl, Vector.getElem_ofFn]

theorem niels_bits_extract (N : Niels) (j : Nat) (hj : j < 25) :
    N.bits.extractLsb' (512 * j) 512 =
      BitVec.packLanes ((N.comp ⟨j / 5, by omega⟩).limb ⟨j % 5, by omega⟩) := by
  rw [Niels.bits, Nat.mul_comm, BitVec.extractLsb'_packLanes _ j hj, Vector.getElem_ofFn]
  rfl

/-- A field element read as five cells. -/
theorem readAt_fe (hq : q.offset = 0) {o : Nat} {a : Fe}
    (hb : InBounds m (q.add (BitVec.ofNat 64 o)) 2560) (hlt : o + 320 < 2 ^ 64)
    (h : ∀ l : Fin 5, m.readAt (q.add (BitVec.ofNat 64 (o + 64 * l))) 512 =
      BitVec.packLanes (a.limb l)) :
    m.readAt (q.add (BitVec.ofNat 64 o)) 2560 = a.bits :=
  readAt_cells (n := 5) hq hb hlt h

/-- A field element's cells fit: it fits. -/
theorem fits_fe (hq : q.offset = 0) {o : Nat} (hlt : o + 320 < 2 ^ 64)
    (h : ∀ l : Fin 5, Fits m (q.add (BitVec.ofNat 64 (o + 64 * l))) 512) :
    Fits m (q.add (BitVec.ofNat 64 o)) 2560 :=
  fits_cells (n := 4) hq h hlt

/-- A table entry read as its five field elements. -/
theorem readAt_niels (hq : q.offset = 0) {o : Nat} {N : Niels}
    (hb : InBounds m (q.add (BitVec.ofNat 64 o)) 12800) (hlt : o + 1600 < 2 ^ 64)
    (h : ∀ k : Fin 5, m.readAt (q.add (BitVec.ofNat 64 (o + 320 * k))) 2560 = (N.comp k).bits) :
    m.readAt (q.add (BitVec.ofNat 64 o)) 12800 = N.bits := by
  refine readAt_cells (n := 25) hq hb hlt fun j => ?_
  have hj := j.isLt
  have hk : j.val / 5 < 5 := by omega
  have hf := h ⟨j.val / 5, hk⟩
  simp only at hf
  rw [readAt_sub hq (o := o + 320 * (j.val / 5))
      (inBounds_sub hq hb (by omega) (by omega) (by omega)) hf (by omega) (by omega) (by omega),
    show 8 * (o + 64 * j.val - (o + 320 * (j.val / 5))) = 512 * (j.val % 5) by omega,
    fe_bits_extract _ _ (by omega)]
  rfl

/-- A table entry's field elements fit: it fits. -/
theorem fits_niels (hq : q.offset = 0) {o : Nat} (hlt : o + 1600 < 2 ^ 64)
    (h : ∀ k : Fin 5, Fits m (q.add (BitVec.ofNat 64 (o + 320 * k))) 2560) :
    Fits m (q.add (BitVec.ofNat 64 o)) 12800 := by
  refine fits_cells (n := 24) hq (fun j => ?_) hlt
  have hj := j.isLt
  have hf := h ⟨j.val / 5, by omega⟩
  simp only at hf
  exact fits_sub hq hf (by omega) (by omega) (by omega)

/-- Lanes inside a read field element. -/
theorem readVec_of_fe (hq : q.offset = 0) {o : Nat} {a : Fe}
    (hb : InBounds m (q.add (BitVec.ofNat 64 o)) 2560) (hlt : o + 320 < 2 ^ 64)
    (h : m.readAt (q.add (BitVec.ofNat 64 o)) 2560 = a.bits) (l : Nat) (hl : l < 5) :
    m.readVec (q.add (BitVec.ofNat 64 (o + 64 * l))) = a.limb ⟨l, hl⟩ := by
  apply MemoryState.readVec_packLanes
  rw [readAt_sub hq hb h (by omega) (by omega) (by omega),
    show 8 * (o + 64 * l - o) = 512 * l by omega, fe_bits_extract]

/-- A read field element, as the object. -/
theorem readFe_of_fe (hq : q.offset = 0) {o : Nat} {a : Fe}
    (hb : InBounds m (q.add (BitVec.ofNat 64 o)) 2560) (hlt : o + 320 < 2 ^ 64)
    (h : m.readAt (q.add (BitVec.ofNat 64 o)) 2560 = a.bits) :
    m.readFe (q.add (BitVec.ofNat 64 o)) = a := by
  simp only [MemoryState.readFe, add_ofNat_add_ofNat (q := q) o 64,
    add_ofNat_add_ofNat (q := q) o 128, add_ofNat_add_ofNat (q := q) o 192,
    add_ofNat_add_ofNat (q := q) o 256]
  have h0 := readVec_of_fe hq hb hlt h 0 (by decide)
  have h1 := readVec_of_fe hq hb hlt h 1 (by decide)
  have h2 := readVec_of_fe hq hb hlt h 2 (by decide)
  have h3 := readVec_of_fe hq hb hlt h 3 (by decide)
  have h4 := readVec_of_fe hq hb hlt h 4 (by decide)
  simp only [Nat.mul_zero, Nat.add_zero, Nat.mul_one] at h0 h1 h2 h3 h4
  rw [h0, h1, h2, h3, h4]
  rfl

/-- A read table entry, as the object. -/
theorem readNiels_of_bits (hq : q.offset = 0) {o : Nat} {N : Niels}
    (hb : InBounds m (q.add (BitVec.ofNat 64 o)) 12800) (hlt : o + 1600 < 2 ^ 64)
    (h : m.readAt (q.add (BitVec.ofNat 64 o)) 12800 = N.bits) :
    m.readNiels (q.add (BitVec.ofNat 64 o)) = N := by
  have hc (k : Nat) (hk : k < 5) :
      m.readFe (q.add (BitVec.ofNat 64 (o + 320 * k))) = N.comp ⟨k, hk⟩ := by
    refine readFe_of_fe hq (inBounds_sub hq hb (by omega) (by omega) (by omega)) (by omega) ?_
    refine readAt_fe hq (inBounds_sub hq hb (by omega) (by omega) (by omega)) (by omega)
      fun l => ?_
    have hl := l.isLt
    rw [readAt_sub hq hb h (by omega) (by omega) (by omega),
      show 8 * (o + 320 * k + 64 * l.val - o) = 512 * (5 * k + l.val) by omega,
      niels_bits_extract _ _ (by omega)]
    simp only [show (5 * k + l.val) / 5 = k by omega, show (5 * k + l.val) % 5 = l.val by omega]
  simp only [MemoryState.readNiels, add_ofNat_add_ofNat (q := q) o 320,
    add_ofNat_add_ofNat (q := q) o 640, add_ofNat_add_ofNat (q := q) o 960,
    add_ofNat_add_ofNat (q := q) o 1280]
  have h0 := hc 0 (by decide)
  have h1 := hc 1 (by decide)
  have h2 := hc 2 (by decide)
  have h3 := hc 3 (by decide)
  have h4 := hc 4 (by decide)
  simp only [Nat.mul_zero, Nat.add_zero] at h0 h1 h2 h3 h4
  rw [h0, h1, h2, h3, h4]
  rfl

/-- Component `k` of a point: `x, y, z, t`. -/
def _root_.MLIR.Firedancer.Lane.Point.comp (P : Point) (k : Fin 4) : Fe :=
  #v[P.x, P.y, P.z, P.t][k]

/-- A 512-bit read, from its lanes. -/
theorem readAt_eq_of_readVec {p : Pointer} {v : Wwl} (h : m.readVec p = v) :
    m.readAt p 512 = BitVec.packLanes v := by
  rw [← h, MemoryState.readVec, BitVec.packLanes_extractVecElem8]

end Objects

/-! ### Objects past a store to another block -/

section PastStores

variable {m : MemoryState} {p q : Pointer} {x : BitVec w}

theorem readFe_storeAt_of_id_ne (h : p.id ≠ q.id) : (m.storeAt p x).readFe q = m.readFe q := by
  have h' (o : BitVec 64) : p.id ≠ (q.add o).id := by simpa using h
  simp only [MemoryState.readFe, MemoryState.readVec,
    MemoryState.readAt_storeAt_disjoint (Range.disjoint_of_id_ne h),
    MemoryState.readAt_storeAt_disjoint (Range.disjoint_of_id_ne (h' _))]

theorem readLanePoint_storeAt_of_id_ne (h : p.id ≠ q.id) :
    (m.storeAt p x).readLanePoint q = m.readLanePoint q := by
  have h' (o : BitVec 64) : p.id ≠ (q.add o).id := by simpa using h
  simp only [MemoryState.readLanePoint, readFe_storeAt_of_id_ne h, readFe_storeAt_of_id_ne (h' _)]

theorem readNiels_storeAt_of_id_ne (h : p.id ≠ q.id) :
    (m.storeAt p x).readNiels q = m.readNiels q := by
  have h' (o : BitVec 64) : p.id ≠ (q.add o).id := by simpa using h
  simp only [MemoryState.readNiels, readFe_storeAt_of_id_ne h, readFe_storeAt_of_id_ne (h' _)]

theorem readLanePoint_storeVec_of_id_ne {v : Wwl} (h : p.id ≠ q.id) :
    (m.storeVec p v).readLanePoint q = m.readLanePoint q :=
  readLanePoint_storeAt_of_id_ne h

theorem readNiels_storeVec_of_id_ne {v : Wwl} (h : p.id ≠ q.id) :
    (m.storeVec p v).readNiels q = m.readNiels q :=
  readNiels_storeAt_of_id_ne h

end PastStores

/-! ### Objects from explicit reads -/

section Explicit

variable {m : MemoryState} {q : Pointer}

theorem add_ofNat_zero : q.add (BitVec.ofNat 64 0) = q :=
  Pointer.add_zero q

/-- A field element at `q` plus `o` from its five cells. -/
theorem readAt_fe_at (hq : q.offset = 0) {w : Nat} (hb : InBounds m q w) (o : Nat)
    (hw : 8 * o + 2560 ≤ w) (hlt : o + 320 < 2 ^ 64) {A : Fe}
    (h0 : m.readAt (q.add (BitVec.ofNat 64 o)) 512 = BitVec.packLanes A.l0)
    (h1 : m.readAt (q.add (BitVec.ofNat 64 (o + 64))) 512 = BitVec.packLanes A.l1)
    (h2 : m.readAt (q.add (BitVec.ofNat 64 (o + 128))) 512 = BitVec.packLanes A.l2)
    (h3 : m.readAt (q.add (BitVec.ofNat 64 (o + 192))) 512 = BitVec.packLanes A.l3)
    (h4 : m.readAt (q.add (BitVec.ofNat 64 (o + 256))) 512 = BitVec.packLanes A.l4) :
    m.readAt (q.add (BitVec.ofNat 64 o)) 2560 = A.bits := by
  refine readAt_fe hq (inBounds_sub (o := 0) hq (by rwa [add_ofNat_zero]) (by omega) (by omega)
    (by omega)) hlt fun l => ?_
  fin_cases l
  exacts [h0, h1, h2, h3, h4]

/-- A field element at `q` from its five cells. -/
theorem readAt_fe_base (hq : q.offset = 0) {w : Nat} (hb : InBounds m q w) (hw : 2560 ≤ w)
    {A : Fe} (h0 : m.readAt q 512 = BitVec.packLanes A.l0)
    (h1 : m.readAt (q.add 64#64) 512 = BitVec.packLanes A.l1)
    (h2 : m.readAt (q.add 128#64) 512 = BitVec.packLanes A.l2)
    (h3 : m.readAt (q.add 192#64) 512 = BitVec.packLanes A.l3)
    (h4 : m.readAt (q.add 256#64) 512 = BitVec.packLanes A.l4) :
    m.readAt q 2560 = A.bits := by
  have := readAt_fe_at hq hb 0 (by omega) (by omega) (by rwa [add_ofNat_zero]) h1 h2 h3 h4
  rwa [add_ofNat_zero] at this

/-- A field element at `q` plus `o` fits when its five cells do. -/
theorem fits_fe_at (hq : q.offset = 0) (o : Nat) (hlt : o + 320 < 2 ^ 64)
    (h0 : Fits m (q.add (BitVec.ofNat 64 o)) 512)
    (h1 : Fits m (q.add (BitVec.ofNat 64 (o + 64))) 512)
    (h2 : Fits m (q.add (BitVec.ofNat 64 (o + 128))) 512)
    (h3 : Fits m (q.add (BitVec.ofNat 64 (o + 192))) 512)
    (h4 : Fits m (q.add (BitVec.ofNat 64 (o + 256))) 512) :
    Fits m (q.add (BitVec.ofNat 64 o)) 2560 := by
  refine fits_fe hq hlt fun l => ?_
  fin_cases l
  exacts [h0, h1, h2, h3, h4]

/-- A field element at `q` fits when its five cells do. -/
theorem fits_fe_base (hq : q.offset = 0) (h0 : Fits m q 512) (h1 : Fits m (q.add 64#64) 512)
    (h2 : Fits m (q.add 128#64) 512) (h3 : Fits m (q.add 192#64) 512)
    (h4 : Fits m (q.add 256#64) 512) : Fits m q 2560 := by
  have := fits_fe_at hq 0 (by omega) (by rwa [add_ofNat_zero]) h1 h2 h3 h4
  rwa [add_ofNat_zero] at this

/-- A table entry at `q` plus `o` from its five field elements. -/
theorem readAt_niels_at (hq : q.offset = 0) {w : Nat} (hb : InBounds m q w) (o : Nat)
    (hw : 8 * o + 12800 ≤ w) (hlt : o + 1600 < 2 ^ 64) {N : Niels}
    (h0 : m.readAt (q.add (BitVec.ofNat 64 o)) 2560 = N.p.bits)
    (h1 : m.readAt (q.add (BitVec.ofNat 64 (o + 320))) 2560 = N.m.bits)
    (h2 : m.readAt (q.add (BitVec.ofNat 64 (o + 640))) 2560 = N.k.bits)
    (h3 : m.readAt (q.add (BitVec.ofNat 64 (o + 960))) 2560 = N.nk.bits)
    (h4 : m.readAt (q.add (BitVec.ofNat 64 (o + 1280))) 2560 = N.z.bits) :
    m.readAt (q.add (BitVec.ofNat 64 o)) 12800 = N.bits := by
  refine readAt_niels hq (inBounds_sub (o := 0) hq (by rwa [add_ofNat_zero]) (by omega) (by omega)
    (by omega)) hlt fun k => ?_
  fin_cases k
  exacts [h0, h1, h2, h3, h4]

/-- A table entry at `q` from its five field elements. -/
theorem readAt_niels_base (hq : q.offset = 0) {w : Nat} (hb : InBounds m q w) (hw : 12800 ≤ w)
    {N : Niels} (h0 : m.readAt q 2560 = N.p.bits) (h1 : m.readAt (q.add 320#64) 2560 = N.m.bits)
    (h2 : m.readAt (q.add 640#64) 2560 = N.k.bits)
    (h3 : m.readAt (q.add 960#64) 2560 = N.nk.bits)
    (h4 : m.readAt (q.add 1280#64) 2560 = N.z.bits) : m.readAt q 12800 = N.bits := by
  have := readAt_niels_at hq hb 0 (N := N) (by omega) (by omega)
    (by rw [add_ofNat_zero]; exact h0) h1 h2 h3 h4
  rwa [add_ofNat_zero] at this

/-- A table entry at `q` plus `o` fits when its five field elements do. -/
theorem fits_niels_at (hq : q.offset = 0) (o : Nat) (hlt : o + 1600 < 2 ^ 64)
    (h0 : Fits m (q.add (BitVec.ofNat 64 o)) 2560)
    (h1 : Fits m (q.add (BitVec.ofNat 64 (o + 320))) 2560)
    (h2 : Fits m (q.add (BitVec.ofNat 64 (o + 640))) 2560)
    (h3 : Fits m (q.add (BitVec.ofNat 64 (o + 960))) 2560)
    (h4 : Fits m (q.add (BitVec.ofNat 64 (o + 1280))) 2560) :
    Fits m (q.add (BitVec.ofNat 64 o)) 12800 := by
  refine fits_niels hq hlt fun k => ?_
  fin_cases k
  exacts [h0, h1, h2, h3, h4]

/-- A table entry at `q` fits when its five field elements do. -/
theorem fits_niels_base (hq : q.offset = 0) (h0 : Fits m q 2560)
    (h1 : Fits m (q.add 320#64) 2560) (h2 : Fits m (q.add 640#64) 2560)
    (h3 : Fits m (q.add 960#64) 2560) (h4 : Fits m (q.add 1280#64) 2560) : Fits m q 12800 := by
  have := fits_niels_at hq 0 (by omega) (by rw [add_ofNat_zero]; exact h0) h1 h2 h3 h4
  rwa [add_ofNat_zero] at this

/-- The table entry at `q`, from its bits. -/
theorem readNiels_base (hq : q.offset = 0) {w : Nat} (hb : InBounds m q w) (hw : 12800 ≤ w)
    {N : Niels} (h : m.readAt q 12800 = N.bits) : m.readNiels q = N := by
  have := readNiels_of_bits (o := 0) hq (inBounds_sub (o := 0) hq (by rwa [add_ofNat_zero])
    (by omega) (by omega) (by omega)) (by omega) (by rwa [add_ofNat_zero])
  rwa [add_ofNat_zero] at this

/-- A fitting range at `q` and one right after it, at `q` plus `o`: their union fits. -/
theorem fits_append_at (hq : q.offset = 0) {v w : Nat} (o : Nat) (h₁ : Fits m q v)
    (h₂ : Fits m (q.add (BitVec.ofNat 64 o)) w) (hv : 8 * o = v) (hlt : o < 2 ^ 64) :
    Fits m q (v + w) :=
  Fits.append (nov_of_zero hq hlt) (by simp [Nat.mod_eq_of_lt hlt]; omega) rfl h₁ h₂

/-- Entry 0's stores fit as one range. -/
theorem fits_entry0 (hq : q.offset = 0) (h0 : Fits m q 512) (h1 : Fits m (q.add 64#64) 2048)
    (h2 : Fits m (q.add 320#64) 512) (h3 : Fits m (q.add 384#64) 4608)
    (h4 : Fits m (q.add 960#64) 512) (h5 : Fits m (q.add 1024#64) 512)
    (h6 : Fits m (q.add 1088#64) 512) (h7 : Fits m (q.add 1152#64) 512)
    (h8 : Fits m (q.add 1216#64) 512) (h9 : Fits m (q.add 1280#64) 512)
    (h10 : Fits m (q.add 1344#64) 2048) : Fits m (q.add 0#64) 12800 := by
  rw [Pointer.add_zero]
  exact fits_append_at hq 1344 (fits_append_at hq 1280 (fits_append_at hq 1216
    (fits_append_at hq 1152 (fits_append_at hq 1088 (fits_append_at hq 1024
      (fits_append_at hq 960 (fits_append_at hq 384 (fits_append_at hq 320
        (fits_append_at hq 64 h0 h1 rfl (by omega)) h2 rfl (by omega)) h3 rfl (by omega))
        h4 rfl (by omega)) h5 rfl (by omega)) h6 rfl (by omega)) h7 rfl (by omega)) h8 rfl
      (by omega)) h9 rfl (by omega)) h10 rfl (by omega)

/-- `zero_replicate8`: zero bytes are zero. -/
theorem zero_replicate8 (n : Nat) : (0#8).replicate n = 0#(8 * n) := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp [BitVec.getLsbD_replicate]

theorem zero_extract {n : Nat} (s w : Nat) : (0#n).extractLsb' s w = 0#w := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp

theorem packLanes_zero8 : BitVec.packLanes (Vector.replicate 8 0#64) = 0#512 := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  rw [getLsbD_packLanes _ (by omega)]
  simp

/-- A cell inside a `memset` of zeros, both from `q` plus a literal: zero. -/
theorem readAt_zero_cell (hq : q.offset = 0) {w : Nat} (hb : InBounds m q w) {o o' n : Nat}
    (h : m.readAt (q.add (BitVec.ofNat 64 o)) (8 * n) = BitVec.replicate n 0#8) (h1 : o ≤ o')
    (h2 : 8 * o' + 512 ≤ 8 * o + 8 * n) (hw : 8 * o + 8 * n ≤ w) (hlt : o' < 2 ^ 64) :
    m.readAt (q.add (BitVec.ofNat 64 o')) 512 = BitVec.packLanes (Vector.replicate 8 0#64) := by
  have hb' := inBounds_sub (o := 0) (o' := o) (w' := 8 * n) hq (by rw [add_ofNat_zero]; exact hb)
    (by omega) (by omega) (by omega)
  rw [readAt_sub hq hb' h h1 h2 hlt, zero_replicate8, zero_extract, packLanes_zero8]

/-- Entry 0, `Niels.zero`, from the code's stores: its ones and `2p` limbs and the `memset`s
between them. -/
theorem readAt_entry0 (hq : q.offset = 0) {w : Nat} (hb : InBounds m q w) (hw : 12800 ≤ w)
    (h0 : m.readAt q 512 = BitVec.packLanes (Vector.replicate 8 1#64))
    (h1 : m.readAt (q.add 64#64) 2048 = BitVec.replicate 256 0#8)
    (h2 : m.readAt (q.add 320#64) 512 = BitVec.packLanes (Vector.replicate 8 1#64))
    (h3 : m.readAt (q.add 384#64) 4608 = BitVec.replicate 576 0#8)
    (h4 : m.readAt (q.add 960#64) 512 = BitVec.packLanes (Vector.replicate 8 4503599627370458#64))
    (h5 : m.readAt (q.add 1024#64) 512 = BitVec.packLanes (Vector.replicate 8 4503599627370494#64))
    (h6 : m.readAt (q.add 1088#64) 512 = BitVec.packLanes (Vector.replicate 8 4503599627370494#64))
    (h7 : m.readAt (q.add 1152#64) 512 = BitVec.packLanes (Vector.replicate 8 4503599627370494#64))
    (h8 : m.readAt (q.add 1216#64) 512 = BitVec.packLanes (Vector.replicate 8 4503599627370494#64))
    (h9 : m.readAt (q.add 1280#64) 512 = BitVec.packLanes (Vector.replicate 8 1#64))
    (h10 : m.readAt (q.add 1344#64) 2048 = BitVec.replicate 256 0#8) :
    m.readAt (q.add 0#64) 12800 = Niels.zero.bits := by
  have hb0 : InBounds m (q.add (BitVec.ofNat 64 0)) w := by rw [add_ofNat_zero]; exact hb
  refine readAt_cells (o := 0) (n := 25) hq (inBounds_sub (o := 0) hq hb0 (by omega) (by omega)
    (by omega)) (by omega) fun j => ?_
  fin_cases j
  · show m.readAt (q.add 0#64) 512 = _
    rw [Pointer.add_zero, h0]
    rfl
  · exact readAt_zero_cell hq hb (o := 64) (o' := 64) (n := 256) h1 (by omega)
      (by omega) (by omega) (by omega)
  · exact readAt_zero_cell hq hb (o := 64) (o' := 128) (n := 256) h1 (by omega)
      (by omega) (by omega) (by omega)
  · exact readAt_zero_cell hq hb (o := 64) (o' := 192) (n := 256) h1 (by omega)
      (by omega) (by omega) (by omega)
  · exact readAt_zero_cell hq hb (o := 64) (o' := 256) (n := 256) h1 (by omega)
      (by omega) (by omega) (by omega)
  · show m.readAt (q.add 320#64) 512 = _
    rw [h2]
    rfl
  · exact readAt_zero_cell hq hb (o := 384) (o' := 384) (n := 576) h3 (by omega)
      (by omega) (by omega) (by omega)
  · exact readAt_zero_cell hq hb (o := 384) (o' := 448) (n := 576) h3 (by omega)
      (by omega) (by omega) (by omega)
  · exact readAt_zero_cell hq hb (o := 384) (o' := 512) (n := 576) h3 (by omega)
      (by omega) (by omega) (by omega)
  · exact readAt_zero_cell hq hb (o := 384) (o' := 576) (n := 576) h3 (by omega)
      (by omega) (by omega) (by omega)
  · exact readAt_zero_cell hq hb (o := 384) (o' := 640) (n := 576) h3 (by omega)
      (by omega) (by omega) (by omega)
  · exact readAt_zero_cell hq hb (o := 384) (o' := 704) (n := 576) h3 (by omega)
      (by omega) (by omega) (by omega)
  · exact readAt_zero_cell hq hb (o := 384) (o' := 768) (n := 576) h3 (by omega)
      (by omega) (by omega) (by omega)
  · exact readAt_zero_cell hq hb (o := 384) (o' := 832) (n := 576) h3 (by omega)
      (by omega) (by omega) (by omega)
  · exact readAt_zero_cell hq hb (o := 384) (o' := 896) (n := 576) h3 (by omega)
      (by omega) (by omega) (by omega)
  · show m.readAt (q.add 960#64) 512 = _
    rw [h4]
    rfl
  · show m.readAt (q.add 1024#64) 512 = _
    rw [h5]
    rfl
  · show m.readAt (q.add 1088#64) 512 = _
    rw [h6]
    rfl
  · show m.readAt (q.add 1152#64) 512 = _
    rw [h7]
    rfl
  · show m.readAt (q.add 1216#64) 512 = _
    rw [h8]
    rfl
  · show m.readAt (q.add 1280#64) 512 = _
    rw [h9]
    rfl
  · exact readAt_zero_cell hq hb (o := 1344) (o' := 1344) (n := 256) h10 (by omega)
      (by omega) (by omega) (by omega)
  · exact readAt_zero_cell hq hb (o := 1344) (o' := 1408) (n := 256) h10 (by omega)
      (by omega) (by omega) (by omega)
  · exact readAt_zero_cell hq hb (o := 1344) (o' := 1472) (n := 256) h10 (by omega)
      (by omega) (by omega) (by omega)
  · exact readAt_zero_cell hq hb (o := 1344) (o' := 1536) (n := 256) h10 (by omega)
      (by omega) (by omega) (by omega)

/-- `acc` after `fd_ed25519_lane_zero`: its `memset`s and the stores of its limbs `1`, `0`. -/
theorem readLanePoint_zero (hq : q.offset = 0) (hb : InBounds m q 10240)
    (h0 : m.readAt q 2560 = BitVec.replicate 320 0#8)
    (h1 : m.readAt (q.add 320#64) 512 = BitVec.packLanes (Vector.replicate 8 1#64))
    (h2 : m.readAt (q.add 384#64) 2048 = BitVec.replicate 256 0#8)
    (h3 : m.readAt (q.add 640#64) 512 = BitVec.packLanes (Vector.replicate 8 1#64))
    (h4 : m.readAt (q.add 704#64) 2048 = BitVec.replicate 256 0#8)
    (h5 : m.readAt (q.add 960#64) 512 = BitVec.packLanes (Vector.replicate 8 0#64))
    (h6 : m.readAt (q.add 1024#64) 2048 = BitVec.replicate 256 0#8) :
    m.readLanePoint q = Point.zero := by
  have h0' : m.readAt (q.add (BitVec.ofNat 64 0)) (8 * 320) = BitVec.replicate 320 0#8 := by
    rw [add_ofNat_zero]; exact h0
  have cx0 : m.readVec q = Vector.replicate 8 0#64 := by
    refine MemoryState.readVec_packLanes ?_
    have := readAt_zero_cell hq hb (o := 0) (o' := 0) (n := 320) h0' (by omega) (by omega)
      (by omega) (by omega)
    rwa [add_ofNat_zero] at this
  have cx1 : m.readVec (q.add 64#64) = Vector.replicate 8 0#64 :=
    MemoryState.readVec_packLanes (readAt_zero_cell hq hb (o := 0) (o' := 64) (n := 320) h0'
      (by omega) (by omega) (by omega) (by omega))
  have cx2 : m.readVec (q.add 128#64) = Vector.replicate 8 0#64 :=
    MemoryState.readVec_packLanes (readAt_zero_cell hq hb (o := 0) (o' := 128) (n := 320) h0'
      (by omega) (by omega) (by omega) (by omega))
  have cx3 : m.readVec (q.add 192#64) = Vector.replicate 8 0#64 :=
    MemoryState.readVec_packLanes (readAt_zero_cell hq hb (o := 0) (o' := 192) (n := 320) h0'
      (by omega) (by omega) (by omega) (by omega))
  have cx4 : m.readVec (q.add 256#64) = Vector.replicate 8 0#64 :=
    MemoryState.readVec_packLanes (readAt_zero_cell hq hb (o := 0) (o' := 256) (n := 320) h0'
      (by omega) (by omega) (by omega) (by omega))
  have cy0 : m.readVec (q.add 320#64) = _ := MemoryState.readVec_packLanes h1
  have cy1 : m.readVec (q.add 384#64) = Vector.replicate 8 0#64 :=
    MemoryState.readVec_packLanes (readAt_zero_cell hq hb (o := 384) (o' := 384) (n := 256) h2
      (by omega) (by omega) (by omega) (by omega))
  have cy2 : m.readVec (q.add 448#64) = Vector.replicate 8 0#64 :=
    MemoryState.readVec_packLanes (readAt_zero_cell hq hb (o := 384) (o' := 448) (n := 256) h2
      (by omega) (by omega) (by omega) (by omega))
  have cy3 : m.readVec (q.add 512#64) = Vector.replicate 8 0#64 :=
    MemoryState.readVec_packLanes (readAt_zero_cell hq hb (o := 384) (o' := 512) (n := 256) h2
      (by omega) (by omega) (by omega) (by omega))
  have cy4 : m.readVec (q.add 576#64) = Vector.replicate 8 0#64 :=
    MemoryState.readVec_packLanes (readAt_zero_cell hq hb (o := 384) (o' := 576) (n := 256) h2
      (by omega) (by omega) (by omega) (by omega))
  have cz0 : m.readVec (q.add 640#64) = _ := MemoryState.readVec_packLanes h3
  have cz1 : m.readVec (q.add 704#64) = Vector.replicate 8 0#64 :=
    MemoryState.readVec_packLanes (readAt_zero_cell hq hb (o := 704) (o' := 704) (n := 256) h4
      (by omega) (by omega) (by omega) (by omega))
  have cz2 : m.readVec (q.add 768#64) = Vector.replicate 8 0#64 :=
    MemoryState.readVec_packLanes (readAt_zero_cell hq hb (o := 704) (o' := 768) (n := 256) h4
      (by omega) (by omega) (by omega) (by omega))
  have cz3 : m.readVec (q.add 832#64) = Vector.replicate 8 0#64 :=
    MemoryState.readVec_packLanes (readAt_zero_cell hq hb (o := 704) (o' := 832) (n := 256) h4
      (by omega) (by omega) (by omega) (by omega))
  have cz4 : m.readVec (q.add 896#64) = Vector.replicate 8 0#64 :=
    MemoryState.readVec_packLanes (readAt_zero_cell hq hb (o := 704) (o' := 896) (n := 256) h4
      (by omega) (by omega) (by omega) (by omega))
  have ct0 : m.readVec (q.add 960#64) = _ := MemoryState.readVec_packLanes h5
  have ct1 : m.readVec (q.add 1024#64) = Vector.replicate 8 0#64 :=
    MemoryState.readVec_packLanes (readAt_zero_cell hq hb (o := 1024) (o' := 1024) (n := 256) h6
      (by omega) (by omega) (by omega) (by omega))
  have ct2 : m.readVec (q.add 1088#64) = Vector.replicate 8 0#64 :=
    MemoryState.readVec_packLanes (readAt_zero_cell hq hb (o := 1024) (o' := 1088) (n := 256) h6
      (by omega) (by omega) (by omega) (by omega))
  have ct3 : m.readVec (q.add 1152#64) = Vector.replicate 8 0#64 :=
    MemoryState.readVec_packLanes (readAt_zero_cell hq hb (o := 1024) (o' := 1152) (n := 256) h6
      (by omega) (by omega) (by omega) (by omega))
  have ct4 : m.readVec (q.add 1216#64) = Vector.replicate 8 0#64 :=
    MemoryState.readVec_packLanes (readAt_zero_cell hq hb (o := 1024) (o' := 1216) (n := 256) h6
      (by omega) (by omega) (by omega) (by omega))
  rw [MemoryState.readLanePoint_eq, cx0, cx1, cx2, cx3, cx4, cy0, cy1, cy2, cy3, cy4, cz0, cz1, cz2,
    cz3, cz4, ct0, ct1, ct2, ct3, ct4]
  rfl

/-- `acc` after `fd_ed25519_lane_zero` fits. -/
theorem fits_zero (hq : q.offset = 0) (h0 : Fits m q 2560)
    (h1 : Fits m (q.add 320#64) 512) (h2 : Fits m (q.add 384#64) 2048)
    (h3 : Fits m (q.add 640#64) 512) (h4 : Fits m (q.add 704#64) 2048)
    (h5 : Fits m (q.add 960#64) 512) (h6 : Fits m (q.add 1024#64) 2048) : Fits m q 10240 :=
  fits_append_at hq 1024 (fits_append_at hq 960 (fits_append_at hq 704 (fits_append_at hq 640
    (fits_append_at hq 384 (fits_append_at hq 320 h0 h1 rfl (by omega)) h2 rfl (by omega)) h3 rfl
    (by omega)) h4 rfl (by omega)) h5 rfl (by omega)) h6 rfl (by omega)

end Explicit

/-! ### The frame of the table's writes -/

/-- `m'` is `m` with blocks outside `K` written: the blocks in `K` the same, every block keeping its
length and writability, and the addresses and globals the same. -/
def _root_.MLIR.MemoryState.FrameOn (m m' : MemoryState) (K : BlockId → Prop) : Prop :=
  (∀ b, K b → m'[b]? = m[b]?) ∧ m'.unspec = m.unspec ∧ m'.table = m.table ∧
    ∀ b : BlockId, (m'[b]?).map (fun x : MemoryBlock => (x.length, x.writable)) =
      (m[b]?).map (fun x : MemoryBlock => (x.length, x.writable))

/-- The blocks the table leaves alone: below the call's frame, `kd`, `sd` and `r`. -/
def Keep (c : Call) (b : BlockId) : Prop :=
  b.id < c.s.alloc.nextFreeBlock ∨ b = (c.s.slot 0).id ∨ b = (c.s.slot 1).id ∨
    b = (c.s.slot 29).id

/-- A slot of the table's frame, past `kd`, `sd` and `r`: not kept. -/
theorem not_keep_slot (c : Call) {k : Nat} (hk : 2 ≤ k) (h29 : k ≠ 29) :
    ¬Keep c (c.s.slot k).id := by
  simp only [Keep, GlobalState.slot, BlockId.mk.injEq, not_or]
  omega

section FrameOn

variable {m m' : MemoryState} {K : BlockId → Prop} {p : Pointer}

/-- Nothing written. -/
theorem _root_.MLIR.MemoryState.FrameOn.refl (m : MemoryState) : m.FrameOn m K :=
  ⟨fun _ _ => rfl, rfl, rfl, fun _ => rfl⟩

/-- A change of a block outside `K` that keeps its length and writability. -/
theorem _root_.MLIR.MemoryState.FrameOn.modifyBlock (h : m.FrameOn m' K) {i : BlockId} (hi : ¬K i)
    {f : MemoryBlock → MemoryBlock}
    (hf : ∀ b, (f b).length = b.length ∧ (f b).writable = b.writable) :
    m.FrameOn (m'.modifyBlock i f) K := by
  refine ⟨fun b hb => ?_, h.2.1, h.2.2.1, fun b => ?_⟩
  · rw [MemoryState.getElem?_modifyBlock_ne fun e : b = i => hi (e ▸ hb), h.1 b hb]
  · rw [← h.2.2.2 b, MemoryState.getElem?_modifyBlock]
    split
    · rename_i e
      subst e
      cases m'[i]? with
      | none => rfl
      | some x =>
        simp only [Option.map_some, MemoryBlock.update]
        split <;> simp [hf]
    · rfl

/-- `FrameOn` past a store to a block outside `K`. -/
theorem _root_.MLIR.MemoryState.FrameOn.storeAt (h : m.FrameOn m' K) (hp : ¬K p.id)
    {x : BitVec w} : m.FrameOn (m'.storeAt p x) K :=
  h.modifyBlock hp fun _ => ⟨rfl, rfl⟩

/-- `FrameOn.storeAt` at an offset. -/
theorem _root_.MLIR.MemoryState.FrameOn.storeAt_add (h : m.FrameOn m' K) (hp : ¬K p.id)
    {o : BitVec 64} {x : BitVec w} : m.FrameOn (m'.storeAt (p.add o) x) K :=
  h.modifyBlock hp fun _ => ⟨rfl, rfl⟩

/-- `FrameOn` past a vector store. -/
theorem _root_.MLIR.MemoryState.FrameOn.storeVec (h : m.FrameOn m' K) (hp : ¬K p.id) {v : Wwl} :
    m.FrameOn (m'.storeVec p v) K :=
  h.storeAt hp

/-- `FrameOn.storeVec` at an offset. -/
theorem _root_.MLIR.MemoryState.FrameOn.storeVec_add (h : m.FrameOn m' K) (hp : ¬K p.id)
    {o : BitVec 64} {v : Wwl} : m.FrameOn (m'.storeVec (p.add o) v) K :=
  h.storeAt_add hp

/-- `FrameOn` past a lifetime start. -/
theorem _root_.MLIR.MemoryState.FrameOn.lifetimeStart (h : m.FrameOn m' K) (hp : ¬K p.id) :
    m.FrameOn (m'.lifetimeStart p) K :=
  h.modifyBlock hp fun _ => ⟨rfl, rfl⟩

/-- `FrameOn` past a lifetime end. -/
theorem _root_.MLIR.MemoryState.FrameOn.lifetimeEnd (h : m.FrameOn m' K) (hp : ¬K p.id) :
    m.FrameOn (m'.lifetimeEnd p) K :=
  h.modifyBlock hp fun _ => ⟨rfl, rfl⟩

/-- `FrameOn` past a field element store. -/
theorem _root_.MLIR.MemoryState.FrameOn.storeFe (h : m.FrameOn m' K) (hp : ¬K p.id) {a : Fe} :
    m.FrameOn (m'.storeFe p a) K :=
  ((((h.storeAt hp).storeAt_add hp).storeAt_add hp).storeAt_add hp).storeAt_add hp

/-- `FrameOn.storeFe` at an offset. -/
theorem _root_.MLIR.MemoryState.FrameOn.storeFe_add (h : m.FrameOn m' K) (hp : ¬K p.id)
    {o : BitVec 64} {a : Fe} : m.FrameOn (m'.storeFe (p.add o) a) K :=
  ((((h.storeAt_add hp).storeAt_add (p := p.add o) hp).storeAt_add (p := p.add o) hp).storeAt_add
    (p := p.add o) hp).storeAt_add (p := p.add o) hp

/-- `FrameOn` past a point store. -/
theorem _root_.MLIR.MemoryState.FrameOn.storeLanePoint (h : m.FrameOn m' K) (hp : ¬K p.id)
    {P : Point} : m.FrameOn (m'.storeLanePoint p P) K :=
  (((h.storeFe hp).storeFe_add hp).storeFe_add hp).storeFe_add hp

end FrameOn

/-! ### What the frame keeps -/

section Keep

variable {m m' : MemoryState} {K : BlockId → Prop}

theorem _root_.MLIR.MemoryState.FrameOn.sameOn (h : m.FrameOn m' K) : m.SameOn m' K :=
  ⟨h.1, h.2.1, h.2.2.1⟩

theorem _root_.MLIR.MemoryState.FrameOn.inBounds (h : m.FrameOn m' K) {p : Pointer} {w : Nat}
    (hp : InBounds m p w) : InBounds m' p w := by
  obtain ⟨b, hb, hw⟩ := hp
  have := h.2.2.2 p.id
  rw [hb] at this
  cases hb' : m'[p.id]? with
  | none => simp [hb'] at this
  | some b' =>
    simp only [hb', Option.map_some, Option.some.injEq, Prod.mk.injEq] at this
    exact ⟨b', hb', by simp only [MemoryBlock.lengthInBits] at hw ⊢; omega⟩

theorem _root_.MLIR.MemoryState.FrameOn.writable (h : m.FrameOn m' K) {p : Pointer}
    (hp : Writable m p) : Writable m' p := by
  obtain ⟨b, hb, hw⟩ := hp
  have := h.2.2.2 p.id
  rw [hb] at this
  cases hb' : m'[p.id]? with
  | none => simp [hb'] at this
  | some b' =>
    simp only [hb', Option.map_some, Option.some.injEq, Prod.mk.injEq] at this
    exact ⟨b', hb', this.2 ▸ hw⟩

/-- Two memories that agree below `n` erase to the same one. -/
theorem eraseFrom_eq_of_sameOn {n : Nat} (h : m.SameOn m' fun b => b.id < n) :
    m'.eraseFrom n = m.eraseFrom n := by
  ext1
  · apply Std.ExtHashMap.ext_getElem?
    intro b
    simp only [MemoryState.eraseFrom, Std.ExtHashMap.getElem?_filter']
    by_cases hb : b.id < n
    · have := h.1 b hb
      simp only [MemoryState.getElem?_eq] at this
      rw [this]
    · cases m'.mem[b]? <;> cases m.mem[b]? <;> simp [hb]
  · exact h.2.1
  · exact h.2.2

theorem _root_.MLIR.MemoryState.SameOn.readFe {p : Pointer} (h : m.SameOn m' K) (hp : K p.id) :
    m'.readFe p = m.readFe p := by
  simp only [MemoryState.readFe, MemoryState.readVec, h.readAt hp,
    h.readAt (q := p.add _) (by simpa using hp)]

theorem _root_.MLIR.MemoryState.SameOn.readLanePoint {p : Pointer} (h : m.SameOn m' K)
    (hp : K p.id) : m'.readLanePoint p = m.readLanePoint p := by
  simp only [MemoryState.readLanePoint, h.readFe hp, h.readFe (p := p.add _) (by simpa using hp)]

end Keep

/-! ### The hand-over's frame -/

section Rebuild

variable {c : Call} {S₀ S : GlobalState} {M : MemoryState}

theorem keep_below {b : BlockId} (h : b.id < c.s.alloc.nextFreeBlock) : Keep c b :=
  Or.inl h

/-- A `Base` survives writes outside the kept blocks. -/
theorem Call.Base.of_frameOn (h : c.Base S₀ M) (hf : S₀.mem.FrameOn S.mem (Keep c))
    (hwf : S.WF) : c.Base S M where
  wf := hwf
  globals := hf.sameOn.globals h.globals
  frame := by
    obtain ⟨b, hb, -⟩ := hf.inBounds (h.slots 32 (by decide))
    have := hwf.bound (c.s.slot 32).id (by
      rw [Std.ExtHashMap.mem_iff_isSome_getElem?, ← MemoryState.getElem?_eq, hb]; rfl)
    simp only [GlobalState.slot_id_id] at this
    omega
  slots k hk := hf.inBounds (h.slots k hk)
  writable k hk := hf.writable (h.writable k hk)
  mem := by
    rw [← h.mem]
    exact eraseFrom_eq_of_sameOn (hf.sameOn.mono fun _ hb => keep_below hb)
  tbl_lt := h.tbl_lt
  idp_lt := h.idp_lt
  tbl_fits := hf.sameOn.fits (keep_below h.tbl_lt) h.tbl_fits
  tbl_read := by rw [hf.sameOn.readAt (keep_below h.tbl_lt)]; exact h.tbl_read
  idp_fits := hf.sameOn.fits (keep_below h.idp_lt) h.idp_fits
  idp_read := by rw [hf.sameOn.readAt (keep_below h.idp_lt)]; exact h.idp_read

theorem keep_slot0 : Keep c (c.s.slot 0).id :=
  Or.inr (Or.inl rfl)

theorem keep_slot1 : Keep c (c.s.slot 1).id :=
  Or.inr (Or.inr (Or.inl rfl))

theorem keep_slot29 : Keep c (c.s.slot 29).id :=
  Or.inr (Or.inr (Or.inr rfl))

/-- A point in a kept block survives the frame's writes. -/
theorem Call.PointAt.of_frameOn {k : Nat} {P : Point} (h : c.PointAt S₀ k P)
    (hf : S₀.mem.FrameOn S.mem (Keep c)) (hk : Keep c (c.s.slot k).id) : c.PointAt S k P :=
  ⟨⟨h.fit.1, hf.sameOn.fits hk h.fit.2⟩, by rw [hf.sameOn.readLanePoint hk]; exact h.read⟩

end Rebuild

/-! ### Loads of a stored point -/

/-- Limb 0 of a stored point's `x`, as a load reads it. -/
theorem readAt_storeLanePoint_x0 {m : MemoryState} {p : Pointer} {P : Point}
    (hr : Room m p 10240) :
    (m.storeLanePoint p P).readAt p 512 = BitVec.packLanes P.x.l0 := by
  rw [MemoryState.storeLanePoint_eq]
  simp (disch := mem_fact) only [MemoryState.storeVec, MemoryState.readAt_storeAt_disjoint,
    MemoryState.readAt_storeAt_self]

/-- Limb 1 of a stored point's `x`, as a load reads it. -/
theorem readAt_storeLanePoint_x1 {m : MemoryState} {p : Pointer} {P : Point}
    (hov : ¬p.offset.uaddOverflow 1280#64) (hr : Room m p 10240) :
    (m.storeLanePoint p P).readAt (p.add 64#64) 512 = BitVec.packLanes P.x.l1 := by
  rw [MemoryState.storeLanePoint_eq]
  simp (disch := mem_fact) only [MemoryState.storeVec, MemoryState.readAt_storeAt_disjoint,
    MemoryState.readAt_storeAt_self]

/-- Limb 2 of a stored point's `x`, as a load reads it. -/
theorem readAt_storeLanePoint_x2 {m : MemoryState} {p : Pointer} {P : Point}
    (hov : ¬p.offset.uaddOverflow 1280#64) (hr : Room m p 10240) :
    (m.storeLanePoint p P).readAt (p.add 128#64) 512 = BitVec.packLanes P.x.l2 := by
  rw [MemoryState.storeLanePoint_eq]
  simp (disch := mem_fact) only [MemoryState.storeVec, MemoryState.readAt_storeAt_disjoint,
    MemoryState.readAt_storeAt_self]

/-- Limb 3 of a stored point's `x`, as a load reads it. -/
theorem readAt_storeLanePoint_x3 {m : MemoryState} {p : Pointer} {P : Point}
    (hov : ¬p.offset.uaddOverflow 1280#64) (hr : Room m p 10240) :
    (m.storeLanePoint p P).readAt (p.add 192#64) 512 = BitVec.packLanes P.x.l3 := by
  rw [MemoryState.storeLanePoint_eq]
  simp (disch := mem_fact) only [MemoryState.storeVec, MemoryState.readAt_storeAt_disjoint,
    MemoryState.readAt_storeAt_self]

/-- Limb 4 of a stored point's `x`, as a load reads it. -/
theorem readAt_storeLanePoint_x4 {m : MemoryState} {p : Pointer} {P : Point}
    (hov : ¬p.offset.uaddOverflow 1280#64) (hr : Room m p 10240) :
    (m.storeLanePoint p P).readAt (p.add 256#64) 512 = BitVec.packLanes P.x.l4 := by
  rw [MemoryState.storeLanePoint_eq]
  simp (disch := mem_fact) only [MemoryState.storeVec, MemoryState.readAt_storeAt_disjoint,
    MemoryState.readAt_storeAt_self]

/-- Limb 0 of a stored point's `y`, as a load reads it. -/
theorem readAt_storeLanePoint_y0 {m : MemoryState} {p : Pointer} {P : Point}
    (hov : ¬p.offset.uaddOverflow 1280#64) (hr : Room m p 10240) :
    (m.storeLanePoint p P).readAt (p.add 320#64) 512 = BitVec.packLanes P.y.l0 := by
  rw [MemoryState.storeLanePoint_eq]
  simp (disch := mem_fact) only [MemoryState.storeVec, MemoryState.readAt_storeAt_disjoint,
    MemoryState.readAt_storeAt_self]

/-- Limb 1 of a stored point's `y`, as a load reads it. -/
theorem readAt_storeLanePoint_y1 {m : MemoryState} {p : Pointer} {P : Point}
    (hov : ¬p.offset.uaddOverflow 1280#64) (hr : Room m p 10240) :
    (m.storeLanePoint p P).readAt (p.add 384#64) 512 = BitVec.packLanes P.y.l1 := by
  rw [MemoryState.storeLanePoint_eq]
  simp (disch := mem_fact) only [MemoryState.storeVec, MemoryState.readAt_storeAt_disjoint,
    MemoryState.readAt_storeAt_self]

/-- Limb 2 of a stored point's `y`, as a load reads it. -/
theorem readAt_storeLanePoint_y2 {m : MemoryState} {p : Pointer} {P : Point}
    (hov : ¬p.offset.uaddOverflow 1280#64) (hr : Room m p 10240) :
    (m.storeLanePoint p P).readAt (p.add 448#64) 512 = BitVec.packLanes P.y.l2 := by
  rw [MemoryState.storeLanePoint_eq]
  simp (disch := mem_fact) only [MemoryState.storeVec, MemoryState.readAt_storeAt_disjoint,
    MemoryState.readAt_storeAt_self]

/-- Limb 3 of a stored point's `y`, as a load reads it. -/
theorem readAt_storeLanePoint_y3 {m : MemoryState} {p : Pointer} {P : Point}
    (hov : ¬p.offset.uaddOverflow 1280#64) (hr : Room m p 10240) :
    (m.storeLanePoint p P).readAt (p.add 512#64) 512 = BitVec.packLanes P.y.l3 := by
  rw [MemoryState.storeLanePoint_eq]
  simp (disch := mem_fact) only [MemoryState.storeVec, MemoryState.readAt_storeAt_disjoint,
    MemoryState.readAt_storeAt_self]

/-- Limb 4 of a stored point's `y`, as a load reads it. -/
theorem readAt_storeLanePoint_y4 {m : MemoryState} {p : Pointer} {P : Point}
    (hov : ¬p.offset.uaddOverflow 1280#64) (hr : Room m p 10240) :
    (m.storeLanePoint p P).readAt (p.add 576#64) 512 = BitVec.packLanes P.y.l4 := by
  rw [MemoryState.storeLanePoint_eq]
  simp (disch := mem_fact) only [MemoryState.storeVec, MemoryState.readAt_storeAt_disjoint,
    MemoryState.readAt_storeAt_self]

/-- Limb 0 of a stored point's `z`, as a load reads it. -/
theorem readAt_storeLanePoint_z0 {m : MemoryState} {p : Pointer} {P : Point}
    (hov : ¬p.offset.uaddOverflow 1280#64) (hr : Room m p 10240) :
    (m.storeLanePoint p P).readAt (p.add 640#64) 512 = BitVec.packLanes P.z.l0 := by
  rw [MemoryState.storeLanePoint_eq]
  simp (disch := mem_fact) only [MemoryState.storeVec, MemoryState.readAt_storeAt_disjoint,
    MemoryState.readAt_storeAt_self]

/-- Limb 1 of a stored point's `z`, as a load reads it. -/
theorem readAt_storeLanePoint_z1 {m : MemoryState} {p : Pointer} {P : Point}
    (hov : ¬p.offset.uaddOverflow 1280#64) (hr : Room m p 10240) :
    (m.storeLanePoint p P).readAt (p.add 704#64) 512 = BitVec.packLanes P.z.l1 := by
  rw [MemoryState.storeLanePoint_eq]
  simp (disch := mem_fact) only [MemoryState.storeVec, MemoryState.readAt_storeAt_disjoint,
    MemoryState.readAt_storeAt_self]

/-- Limb 2 of a stored point's `z`, as a load reads it. -/
theorem readAt_storeLanePoint_z2 {m : MemoryState} {p : Pointer} {P : Point}
    (hov : ¬p.offset.uaddOverflow 1280#64) (hr : Room m p 10240) :
    (m.storeLanePoint p P).readAt (p.add 768#64) 512 = BitVec.packLanes P.z.l2 := by
  rw [MemoryState.storeLanePoint_eq]
  simp (disch := mem_fact) only [MemoryState.storeVec, MemoryState.readAt_storeAt_disjoint,
    MemoryState.readAt_storeAt_self]

/-- Limb 3 of a stored point's `z`, as a load reads it. -/
theorem readAt_storeLanePoint_z3 {m : MemoryState} {p : Pointer} {P : Point}
    (hov : ¬p.offset.uaddOverflow 1280#64) (hr : Room m p 10240) :
    (m.storeLanePoint p P).readAt (p.add 832#64) 512 = BitVec.packLanes P.z.l3 := by
  rw [MemoryState.storeLanePoint_eq]
  simp (disch := mem_fact) only [MemoryState.storeVec, MemoryState.readAt_storeAt_disjoint,
    MemoryState.readAt_storeAt_self]

/-- Limb 4 of a stored point's `z`, as a load reads it. -/
theorem readAt_storeLanePoint_z4 {m : MemoryState} {p : Pointer} {P : Point}
    (hov : ¬p.offset.uaddOverflow 1280#64) (hr : Room m p 10240) :
    (m.storeLanePoint p P).readAt (p.add 896#64) 512 = BitVec.packLanes P.z.l4 := by
  rw [MemoryState.storeLanePoint_eq]
  simp (disch := mem_fact) only [MemoryState.storeVec, MemoryState.readAt_storeAt_disjoint,
    MemoryState.readAt_storeAt_self]

/-- Limb 0 of a stored point's `t`, as a load reads it. -/
theorem readAt_storeLanePoint_t0 {m : MemoryState} {p : Pointer} {P : Point}
    (hov : ¬p.offset.uaddOverflow 1280#64) (hr : Room m p 10240) :
    (m.storeLanePoint p P).readAt (p.add 960#64) 512 = BitVec.packLanes P.t.l0 := by
  rw [MemoryState.storeLanePoint_eq]
  simp (disch := mem_fact) only [MemoryState.storeVec, MemoryState.readAt_storeAt_disjoint,
    MemoryState.readAt_storeAt_self]

/-- Limb 1 of a stored point's `t`, as a load reads it. -/
theorem readAt_storeLanePoint_t1 {m : MemoryState} {p : Pointer} {P : Point}
    (hov : ¬p.offset.uaddOverflow 1280#64) (hr : Room m p 10240) :
    (m.storeLanePoint p P).readAt (p.add 1024#64) 512 = BitVec.packLanes P.t.l1 := by
  rw [MemoryState.storeLanePoint_eq]
  simp (disch := mem_fact) only [MemoryState.storeVec, MemoryState.readAt_storeAt_disjoint,
    MemoryState.readAt_storeAt_self]

/-- Limb 2 of a stored point's `t`, as a load reads it. -/
theorem readAt_storeLanePoint_t2 {m : MemoryState} {p : Pointer} {P : Point}
    (hov : ¬p.offset.uaddOverflow 1280#64) (hr : Room m p 10240) :
    (m.storeLanePoint p P).readAt (p.add 1088#64) 512 = BitVec.packLanes P.t.l2 := by
  rw [MemoryState.storeLanePoint_eq]
  simp (disch := mem_fact) only [MemoryState.storeVec, MemoryState.readAt_storeAt_disjoint,
    MemoryState.readAt_storeAt_self]

/-- Limb 3 of a stored point's `t`, as a load reads it. -/
theorem readAt_storeLanePoint_t3 {m : MemoryState} {p : Pointer} {P : Point}
    (hov : ¬p.offset.uaddOverflow 1280#64) (hr : Room m p 10240) :
    (m.storeLanePoint p P).readAt (p.add 1152#64) 512 = BitVec.packLanes P.t.l3 := by
  rw [MemoryState.storeLanePoint_eq]
  simp (disch := mem_fact) only [MemoryState.storeVec, MemoryState.readAt_storeAt_disjoint,
    MemoryState.readAt_storeAt_self]

/-- Limb 4 of a stored point's `t`, as a load reads it. -/
theorem readAt_storeLanePoint_t4 {m : MemoryState} {p : Pointer} {P : Point}
    (hov : ¬p.offset.uaddOverflow 1280#64) (hr : Room m p 10240) :
    (m.storeLanePoint p P).readAt (p.add 1216#64) 512 = BitVec.packLanes P.t.l4 := by
  rw [MemoryState.storeLanePoint_eq]
  simp (disch := mem_fact) only [MemoryState.storeVec, MemoryState.readAt_storeAt_self]

end

end MLIR.Firedancer.Lane.VerifyX8
