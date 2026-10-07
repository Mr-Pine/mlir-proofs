module

public import Firedancer.Common.Limbs
import Std.Data.ExtHashMap.Lemmas

/-! Points in memory: `fd_ed25519_point_t`'s field elements `X, Y, T, Z` at byte offsets 0, 40, 80,
120, read and stored as a whole. -/

namespace LeanMLIR.RIR

open Memory

@[expose] public section

/-! ### Stores to disjoint ranges commute -/

theorem spliceBits_comm {n w v : Nat} (b : BitVec n) {o₁ o₂ : Nat} (x : BitVec w) (y : BitVec v)
    (h : o₁ + w ≤ o₂ ∨ o₂ + v ≤ o₁) :
    spliceBits (spliceBits b o₁ x) o₂ y = spliceBits (spliceBits b o₂ y) o₁ x := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp only [getLsbD_spliceBits]
  grind

theorem MemoryState.storeAt_comm {m : MemoryState} {p q : Pointer} {x : BitVec v} {y : BitVec w}
    (h : (Range.of p v).Disjoint (Range.of q w)) :
    (m.storeAt p x).storeAt q y = (m.storeAt q y).storeAt p x := by
  rcases m with ⟨mm⟩
  unfold MemoryState.storeAt
  by_cases hid : p.id = q.id
  · simp only [Range.Disjoint, Range.of, hid, ne_eq, not_true_eq_false, false_or] at h
    cases hb : (⟨mm⟩ : MemoryState)[q.id]? with
    | none => simp [hid, hb]
    | some
      blk =>
      simp only [hid, hb, MemoryState.getElem?_eq, Std.ExtHashMap.getElem?_insert_self,
        spliceBits_comm _ _ _ (by omega : _ ∨ _)]
      congr 1
      apply Std.ExtHashMap.ext_getElem?
      intro a
      simp only [Std.ExtHashMap.getElem?_insert]
      split <;> rfl
  · have hqp : q.id ≠ p.id := Ne.symm hid
    cases hp : mm[p.id]? <;> cases hq : mm[q.id]? <;>
      simp only [MemoryState.getElem?_eq, hp, hq, Std.ExtHashMap.getElem?_insert, beq_iff_eq, hid,
        hqp, ite_false]
    congr 1
    apply Std.ExtHashMap.ext_getElem?
    intro a
    simp only [Std.ExtHashMap.getElem?_insert, beq_iff_eq]
    grind

/-! ### Storing what is there -/

/-- Storing the bits a range holds changes nothing. -/
theorem MemoryState.storeAt_readAt_self {m : MemoryState} (h : Fits m p w) :
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
theorem MemoryState.storeLimbs_readLimbs_self {m : MemoryState} (h : m.LimbsFit p) :
    m.storeLimbs p (m.readLimbs p) = m := by
  obtain ⟨-, h0, h1, h2, h3, h4⟩ := h
  simp only [MemoryState.storeLimbs, MemoryState.readLimbs]
  rw [storeAt_readAt_self h0, storeAt_readAt_self h1, storeAt_readAt_self h2,
    storeAt_readAt_self h3, storeAt_readAt_self h4]

/-! ### Limbs in one block -/

/-- Limbs stored in a range apart from `p`'s, in any block: `p`'s limbs are unchanged. -/
@[mlir_read]
theorem MemoryState.readLimbs_storeLimbs_of_disjoint {m : MemoryState} {p q : Pointer}
    (h : (Range.of q 320).Disjoint (Range.of p 320)) (hq : q.offset.toNat + 32 < 2 ^ 64)
    (hp : p.offset.toNat + 32 < 2 ^ 64) : (m.storeLimbs q l).readLimbs p = m.readLimbs p := by
  by_cases hid : q.id = p.id
  · simp only [Range.Disjoint, Range.of, hid, ne_eq, not_true_eq_false, false_or,
      Pointer.offsetInBits] at h
    have hd (j k : Nat) (hj : j ≤ 32) (hk : k ≤ 32) :
      (Range.of (q.add (BitVec.ofNat 64 j)) 64).Disjoint
        (Range.of (p.add (BitVec.ofNat 64 k)) 64) := by
      simp only [Range.Disjoint, Range.of, Pointer.add, Pointer.offsetInBits, BitVec.toNat_add,
        BitVec.toNat_ofNat]
      right
      rw [Nat.mod_eq_of_lt (by omega : j < 2 ^ 64), Nat.mod_eq_of_lt (by omega : k < 2 ^ 64),
        Nat.mod_eq_of_lt (by omega), Nat.mod_eq_of_lt (by omega)]
      omega
    have hd0 (k : Nat) (hk : k ≤ 32) := hd 0 k (by omega) hk
    have hdq (j : Nat) (hj : j ≤ 32) := hd j 0 hj (by omega)
    simp only [Pointer.add, BitVec.add_zero] at hd0 hdq
    funext i
    fin_cases i <;> simp only [MemoryState.readLimbs, MemoryState.storeLimbs] <;>
      repeat
        rw [MemoryState.readAt_storeAt_disjoint
            (by
              first
              | exact hd _ _ (by decide) (by decide)
              | exact hd0 _ (by decide)
              | exact hdq _ (by decide)
              | simpa [Pointer.add] using hd 0 0 (by decide) (by decide))]
  · exact MemoryState.readLimbs_storeLimbs_of_id_ne hid

/-! ### Points -/

/-- A point's field elements, in `fd_ed25519_point_t`'s field order. -/
structure PointLimbs where
  X : Fin 5 → BitVec 64
  Y : Fin 5 → BitVec 64
  T : Fin 5 → BitVec 64
  Z : Fin 5 → BitVec 64

/-- The point at `p`: field elements at byte offsets 0, 40, 80, 120. -/
def MemoryState.readPoint (m : MemoryState) (p : Pointer) : PointLimbs :=
  ⟨m.readLimbs p, m.readLimbs (p.add 40#64), m.readLimbs (p.add 80#64), m.readLimbs (p.add 120#64)⟩

/-- Store a point at `p`, in the order the code does: `X, Y, Z, T`. -/
def MemoryState.storePoint (m : MemoryState) (p : Pointer) (P : PointLimbs) : MemoryState :=
  (((m.storeLimbs p P.X).storeLimbs (p.add 40#64) P.Y).storeLimbs (p.add 120#64) P.Z).storeLimbs
    (p.add 80#64) P.T

/-- The point at `p` fits: its offsets do not wrap, and each field element fits. -/
abbrev MemoryState.PointFit (m : MemoryState) (p : Pointer) : Prop :=
  p.offset.toNat + 160 ≤ 2 ^ 64 ∧
    m.LimbsFit p ∧ m.LimbsFit (p.add 40#64) ∧ m.LimbsFit (p.add 80#64) ∧ m.LimbsFit (p.add 120#64)

/-- Two field elements of one point, at byte offsets `a` and `b` 40 apart, do not overlap. -/
theorem Range.disjoint_coords {p : Pointer} {a b : Nat} (hp : p.offset.toNat + 160 ≤ 2 ^ 64)
    (ha : a ≤ 120) (hb : b ≤ 120) (hab : a + 40 ≤ b ∨ b + 40 ≤ a) :
    (Range.of (p.add (BitVec.ofNat 64 a)) 320).Disjoint
      (Range.of (p.add (BitVec.ofNat 64 b)) 320) := by
  simp only [Range.Disjoint, Range.of, Pointer.add, Pointer.offsetInBits, BitVec.toNat_add,
    BitVec.toNat_ofNat]
  right
  rw [Nat.mod_eq_of_lt (by omega : a < 2 ^ 64), Nat.mod_eq_of_lt (by omega : b < 2 ^ 64),
    Nat.mod_eq_of_lt (by omega), Nat.mod_eq_of_lt (by omega)]
  omega

theorem Pointer.add_zero' (p : Pointer) : p.add (BitVec.ofNat 64 0) = p := by simp [Pointer.add]

/-! The field elements of a point that fits, for the steps' side conditions. -/

@[mlir_transport]
theorem MemoryState.PointFit.limbsFit_X {m : MemoryState} (h : m.PointFit p) : m.LimbsFit p :=
  h.2.1

@[mlir_transport]
theorem MemoryState.PointFit.limbsFit_Y {m : MemoryState} (h : m.PointFit p) :
    m.LimbsFit (p.add 40#64) :=
  h.2.2.1

@[mlir_transport]
theorem MemoryState.PointFit.limbsFit_T {m : MemoryState} (h : m.PointFit p) :
    m.LimbsFit (p.add 80#64) :=
  h.2.2.2.1

@[mlir_transport]
theorem MemoryState.PointFit.limbsFit_Z {m : MemoryState} (h : m.PointFit p) :
    m.LimbsFit (p.add 120#64) :=
  h.2.2.2.2

@[mlir_read]
theorem MemoryState.readLimbs_storePoint_of_id_ne {m : MemoryState} {p q : Pointer}
    (h : p.id ≠ q.id) : (m.storePoint p P).readLimbs q = m.readLimbs q := by
  have h' (k : BitVec 64) : (p.add k).id ≠ q.id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.storePoint, readLimbs_storeLimbs_of_id_ne (h' _),
    readLimbs_storeLimbs_of_id_ne h]

theorem Range.disjoint_coord_base {p : Pointer} {a : Nat} (hp : p.offset.toNat + 160 ≤ 2 ^ 64)
    (ha : a ≤ 120) (h40 : 40 ≤ a) :
    (Range.of (p.add (BitVec.ofNat 64 a)) 320).Disjoint (Range.of p 320) := by
  simpa [Pointer.add_zero'] using Range.disjoint_coords (b := 0) hp ha (by omega) (by omega)

theorem Range.disjoint_coords_base' {p : Pointer} {a : Nat} (hp : p.offset.toNat + 160 ≤ 2 ^ 64)
    (ha : a ≤ 120) (h40 : 40 ≤ a) :
    (Range.of p 320).Disjoint (Range.of (p.add (BitVec.ofNat 64 a)) 320) :=
  Range.Disjoint.symm (Range.disjoint_coord_base hp ha h40)

theorem Pointer.coord_offset {p : Pointer} {a : Nat} (hp : p.offset.toNat + 160 ≤ 2 ^ 64)
    (ha : a ≤ 120) : (p.add (BitVec.ofNat 64 a)).offset.toNat + 32 < 2 ^ 64 := by
  simp only [Pointer.add, BitVec.toNat_add, BitVec.toNat_ofNat]
  rw [Nat.mod_eq_of_lt (by omega : a < 2 ^ 64), Nat.mod_eq_of_lt (by omega)]
  omega

/-- A coordinate of a point read past a store to another coordinate. -/
@[mlir_read]
theorem MemoryState.readLimbs_storeLimbs_coord {m : MemoryState} {p : Pointer} {a b : Nat}
    (h : m.PointFit p) (ha : a ≤ 120) (hb : b ≤ 120) (hab : a + 40 ≤ b ∨ b + 40 ≤ a) :
    (m.storeLimbs (p.add (BitVec.ofNat 64 a)) l).readLimbs (p.add (BitVec.ofNat 64 b)) =
      m.readLimbs (p.add (BitVec.ofNat 64 b)) :=
  readLimbs_storeLimbs_of_disjoint (Range.disjoint_coords h.1 ha hb hab)
    (Pointer.coord_offset h.1 ha) (Pointer.coord_offset h.1 hb)

/-- `readLimbs_storeLimbs_coord` for a store to `X`. -/
@[mlir_read]
theorem MemoryState.readLimbs_storeLimbs_coord_X {m : MemoryState} {p : Pointer} {b : Nat}
    (h : m.PointFit p) (hb : b ≤ 120) (h40 : 40 ≤ b) :
    (m.storeLimbs p l).readLimbs (p.add (BitVec.ofNat 64 b)) =
      m.readLimbs (p.add (BitVec.ofNat 64 b)) :=
  readLimbs_storeLimbs_of_disjoint (Range.disjoint_coords_base' h.1 hb h40) (by omega)
    (Pointer.coord_offset h.1 hb)

/-- `readLimbs_storeLimbs_coord` for a read of `X`. -/
@[mlir_read]
theorem MemoryState.readLimbs_storeLimbs_coord_of_X {m : MemoryState} {p : Pointer} {a : Nat}
    (h : m.PointFit p) (ha : a ≤ 120) (h40 : 40 ≤ a) :
    (m.storeLimbs (p.add (BitVec.ofNat 64 a)) l).readLimbs p = m.readLimbs p :=
  readLimbs_storeLimbs_of_disjoint (Range.disjoint_coord_base h.1 ha h40)
    (Pointer.coord_offset h.1 ha) (by omega)

@[mlir_read]
theorem MemoryState.readLimbs_storePoint_X {m : MemoryState} {p : Pointer} (h : m.PointFit p) :
    (m.storePoint p P).readLimbs p = P.X := by
  have hp : p.offset.toNat + 32 < 2 ^ 64 := by omega
  simp only [MemoryState.storePoint]
  rw [readLimbs_storeLimbs_of_disjoint
      (Range.disjoint_coord_base (a := 80) h.1 (by omega) (by omega))
      (Pointer.coord_offset (a := 80) h.1 (by omega)) hp,
    readLimbs_storeLimbs_of_disjoint
      (Range.disjoint_coord_base (a := 120) h.1 (by omega) (by omega))
      (Pointer.coord_offset (a := 120) h.1 (by omega)) hp,
    readLimbs_storeLimbs_of_disjoint (Range.disjoint_coord_base (a := 40) h.1 (by omega) (by omega))
      (Pointer.coord_offset (a := 40) h.1 (by omega)) hp,
    readLimbs_storeLimbs_self h.2.1]

@[mlir_read]
theorem MemoryState.readLimbs_storePoint_Y {m : MemoryState} {p : Pointer} (h : m.PointFit p) :
    (m.storePoint p P).readLimbs (p.add 40#64) = P.Y := by
  simp only [MemoryState.storePoint]
  rw [readLimbs_storeLimbs_of_disjoint
      (Range.disjoint_coords (a := 80) (b := 40) h.1 (by omega) (by omega) (by omega))
      (Pointer.coord_offset (a := 80) h.1 (by omega))
      (Pointer.coord_offset (a := 40) h.1 (by omega)),
    readLimbs_storeLimbs_of_disjoint
      (Range.disjoint_coords (a := 120) (b := 40) h.1 (by omega) (by omega) (by omega))
      (Pointer.coord_offset (a := 120) h.1 (by omega))
      (Pointer.coord_offset (a := 40) h.1 (by omega)),
    readLimbs_storeLimbs_self h.2.2.1.storeLimbs]

@[mlir_read]
theorem MemoryState.readLimbs_storePoint_Z {m : MemoryState} {p : Pointer} (h : m.PointFit p) :
    (m.storePoint p P).readLimbs (p.add 120#64) = P.Z := by
  simp only [MemoryState.storePoint]
  rw [readLimbs_storeLimbs_of_disjoint
      (Range.disjoint_coords (a := 80) (b := 120) h.1 (by omega) (by omega) (by omega))
      (Pointer.coord_offset (a := 80) h.1 (by omega))
      (Pointer.coord_offset (a := 120) h.1 (by omega)),
    readLimbs_storeLimbs_self h.2.2.2.2.storeLimbs.storeLimbs]

@[mlir_read]
theorem MemoryState.readLimbs_storePoint_T {m : MemoryState} {p : Pointer} (h : m.PointFit p) :
    (m.storePoint p P).readLimbs (p.add 80#64) = P.T := by
  simp only [MemoryState.storePoint]
  rw [readLimbs_storeLimbs_self h.2.2.2.1.storeLimbs.storeLimbs.storeLimbs]

theorem MemoryState.readPoint_storePoint_self {m : MemoryState} {p : Pointer} (h : m.PointFit p) :
    (m.storePoint p P).readPoint p = P := by
  simp only [MemoryState.readPoint, readLimbs_storePoint_X h, readLimbs_storePoint_Y h,
    readLimbs_storePoint_Z h, readLimbs_storePoint_T h]

theorem MemoryState.readPoint_storePoint_of_id_ne {m : MemoryState} {p q : Pointer}
    (h : p.id ≠ q.id) : (m.storePoint p P).readPoint q = m.readPoint q := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readPoint, readLimbs_storePoint_of_id_ne h,
    readLimbs_storePoint_of_id_ne (h' _)]

theorem MemoryState.readPoint_storeLimbs_of_id_ne {m : MemoryState} {p q : Pointer}
    (h : p.id ≠ q.id) : (m.storeLimbs p l).readPoint q = m.readPoint q := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readPoint, readLimbs_storeLimbs_of_id_ne h,
    readLimbs_storeLimbs_of_id_ne (h' _)]

/-! ### Points across writes, `alloca`s and frames -/

@[simp, mlir_state]
theorem MemoryState.limbsFit_storePoint_iff {m : MemoryState} :
    (m.storePoint p P).LimbsFit q ↔ m.LimbsFit q := by simp [MemoryState.storePoint]

@[mlir_mem, mlir_transport]
theorem MemoryState.LimbsFit.storePoint {m : MemoryState} (h : m.LimbsFit q) :
    (m.storePoint p P).LimbsFit q :=
  MemoryState.limbsFit_storePoint_iff.mpr h

@[mlir_mem, mlir_transport]
theorem MemoryState.PointFit.storeAt {m : MemoryState} {x : BitVec w} (h : m.PointFit q) :
    (m.storeAt p x).PointFit q :=
  ⟨h.1, h.2.1.storeAt, h.2.2.1.storeAt, h.2.2.2.1.storeAt, h.2.2.2.2.storeAt⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.PointFit.storeLimbs {m : MemoryState} (h : m.PointFit q) :
    (m.storeLimbs p l).PointFit q :=
  ⟨h.1, h.2.1.storeLimbs, h.2.2.1.storeLimbs, h.2.2.2.1.storeLimbs, h.2.2.2.2.storeLimbs⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.PointFit.storePoint {m : MemoryState} (h : m.PointFit q) :
    (m.storePoint p P).PointFit q :=
  ⟨h.1, h.2.1.storePoint, h.2.2.1.storePoint, h.2.2.2.1.storePoint, h.2.2.2.2.storePoint⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.PointFit.alloca {s : GlobalState} (hne : q.id ≠ s.allocaPtr.id)
    (h : s.mem.PointFit q) : (s.alloca n).mem.PointFit q := by
  have hne' (k : BitVec 64) : (q.add k).id ≠ s.allocaPtr.id := by simpa [Pointer.add_id] using hne
  exact
    ⟨h.1, h.2.1.alloca hne, h.2.2.1.alloca (hne' _), h.2.2.2.1.alloca (hne' _),
      h.2.2.2.2.alloca (hne' _)⟩

@[mlir_transport]
theorem MemoryState.PointFit.addBlock {s : GlobalState} {x : BitVec v} (hwf : s.WF)
    (h : s.mem.PointFit q) : (s.mem.addBlock ⟨s.alloc.nextFreeBlock⟩ n x).PointFit q :=
  ⟨h.1, h.2.1.addBlock hwf, h.2.2.1.addBlock hwf, h.2.2.2.1.addBlock hwf, h.2.2.2.2.addBlock hwf⟩

/-- Field element `k` bytes into a 160-byte block. -/
theorem MemoryState.LimbsFit.of_fits_add {m : MemoryState} {k : BitVec 64} (h : Fits m p 1280)
    (ho : p.offset = 0) (hk : k.toNat ≤ 120) : m.LimbsFit (p.add k) := by
  have hf : Fits m (p.add k) 320 :=
    Fits.add_of_le
      (by
        simp [ho, BitVec.uaddOverflow]; omega)
      (by omega) h
  have hoff : (p.add k).offset = k := by simp [Pointer.add, ho]
  have hov (off : BitVec 64) (hoff' : off.toNat ≤ 32) : ¬(p.add k).offset.uaddOverflow off := by
    simp [hoff, BitVec.uaddOverflow]
    omega
  refine
      ⟨by
        simp [hoff]; omega, hf.mono (by omega), ?_, ?_, ?_, ?_⟩ <;>
    exact Fits.add_of_le (hov _ (by decide)) (by decide) hf

/-- A 160-byte block from its start holds one point. -/
theorem MemoryState.PointFit.of_fits {m : MemoryState} (h : Fits m p 1280) (ho : p.offset = 0) :
    m.PointFit p :=
  ⟨by simp [ho], .of_fits (h.mono (by omega)) ho, .of_fits_add h ho (by decide),
    .of_fits_add h ho (by decide), .of_fits_add h ho (by decide)⟩

@[simp, mlir_mem]
theorem GlobalState.WF_storePoint {s : GlobalState} :
    ({ s with mem := m.storePoint p P } : GlobalState).WF ↔
      ({ s with mem := m } : GlobalState).WF := by
  simp [MemoryState.storePoint]

@[mlir_transport]
theorem GlobalState.WF.storePoint {s : GlobalState} (h : s.WF) :
    ({ s with mem := s.mem.storePoint p P } : GlobalState).WF :=
  GlobalState.WF_storePoint.mpr h

@[mlir_frame, mlir_erase]
theorem MemoryState.eraseFrom_storePoint {m : MemoryState} :
    (m.storePoint p P).eraseFrom n = (m.eraseFrom n).storePoint p P := by
  simp [MemoryState.storePoint, MemoryState.eraseFrom_storeLimbs]

@[mlir_frame, mlir_erase]
theorem MemoryState.storePoint_eraseFrom_of_le {m : MemoryState} (h : n ≤ p.id.id) :
    (m.eraseFrom n).storePoint p P = m.eraseFrom n := by
  simp [MemoryState.storePoint, MemoryState.storeLimbs_eraseFrom_of_le, Pointer.add, h]

/-- A point store that rewrites `Y` and `Z` with what they hold: the `X` and `T` stores. -/
theorem MemoryState.storePoint_of_Y_Z {m : MemoryState} {p : Pointer} (h : m.PointFit p) :
    m.storePoint p ⟨X, m.readLimbs (p.add 40#64), T, m.readLimbs (p.add 120#64)⟩ =
      (m.storeLimbs p X).storeLimbs (p.add 80#64) T := by
  have hp : p.offset.toNat + 32 < 2 ^ 64 := by omega
  have hY : (m.storeLimbs p X).readLimbs (p.add 40#64) = m.readLimbs (p.add 40#64) :=
    readLimbs_storeLimbs_of_disjoint
      (Range.disjoint_coords_base' (a := 40) h.1 (by omega) (by omega)) hp
      (Pointer.coord_offset (a := 40) h.1 (by omega))
  have hZ : (m.storeLimbs p X).readLimbs (p.add 120#64) = m.readLimbs (p.add 120#64) :=
    readLimbs_storeLimbs_of_disjoint
      (Range.disjoint_coords_base' (a := 120) h.1 (by omega) (by omega)) hp
      (Pointer.coord_offset (a := 120) h.1 (by omega))
  simp only [MemoryState.storePoint]
  rw [← hY, storeLimbs_readLimbs_self h.2.2.1.storeLimbs, ← hZ,
    storeLimbs_readLimbs_self h.2.2.2.2.storeLimbs]

end

end LeanMLIR.RIR
