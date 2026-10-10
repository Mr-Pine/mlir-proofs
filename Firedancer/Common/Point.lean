module

public import Firedancer.Common.Limbs
import Std.Data.ExtHashMap.Lemmas
import MLIR.Run.Tactic.Memory

/-! Points in memory: `fd_ed25519_point_t`'s field elements `X, Y, T, Z` at byte offsets 0, 40, 80,
120, read and stored as a whole. -/

namespace MLIR

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
  simp only [MemoryState.storeAt, MemoryState.storeDef]
  by_cases hid : p.id = q.id
  · simp only [Range.Disjoint, Range.of, hid, ne_eq, not_true_eq_false, false_or] at h
    rw [hid, modifyBlock_modifyBlock_self, modifyBlock_modifyBlock_self]
    congr 1
    funext blk
    simp only [Function.comp_apply, MemoryBlock.mk.injEq, true_and, and_true]
    exact
      ⟨heq_of_eq (spliceBits_comm _ _ _ (by omega)), heq_of_eq (spliceBits_comm _ _ _ (by omega))⟩
  · exact modifyBlock_comm hid

/-! ### Storing what is there -/

/-- Storing the known bits a range holds changes nothing. -/
theorem MemoryState.storeAt_readAt_self {m : MemoryState} (h : Fits m p w) :
    m.storeAt p (m.readAt p w) = m := by
  obtain ⟨blk, hblk, -, hsz, hd⟩ := h
  have hb : m.mem[p.id]? = some blk := hblk
  unfold MemoryBlock.lengthInBits at hsz
  simp only [MemoryState.storeAt, MemoryState.storeDef, MemoryState.readAt, hblk,
    MemoryState.modifyBlock]
  refine MemoryState.ext ?_ rfl
  apply Std.ExtHashMap.ext_getElem?
  intro k
  simp only [Std.ExtHashMap.getElem?_modify, beq_iff_eq]
  split
  · subst_vars
    rw [hb]
    simp only [Option.map_some, Option.some.injEq]
    cases blk
    simp only [MemoryBlock.mk.injEq, true_and, and_true] at hsz hd ⊢
    refine ⟨heq_of_eq ?_, heq_of_eq ?_⟩ <;> apply BitVec.eq_of_getLsbD_eq <;> intro i hi <;>
      rw [getLsbD_spliceBits]
    · rw [BitVec.getLsbD_extractLsb']
      split
      · have h1 : p.offsetInBits + (i - p.offsetInBits) = i := by omega
        have h2 : i - p.offsetInBits < w := by omega
        simp [h1, h2]
      · rfl
    · split
      · have := congrArg (·.getLsbD (i - p.offsetInBits)) hd
        have h1 : p.offsetInBits + (i - p.offsetInBits) = i := by omega
        simp only [BitVec.getLsbD_extractLsb', BitVec.getLsbD_allOnes] at this
        have h2 : i - p.offsetInBits < w := by omega
        simp_all
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

/-- Room for the point at `p` (an output): its offsets do not wrap, room for each field element. -/
abbrev MemoryState.PointRoom (m : MemoryState) (p : Pointer) : Prop :=
  p.offset.toNat + 160 ≤ 2 ^ 64 ∧
    m.LimbsRoom p ∧
    m.LimbsRoom (p.add 40#64) ∧ m.LimbsRoom (p.add 80#64) ∧ m.LimbsRoom (p.add 120#64)

theorem MemoryState.PointFit.room {m : MemoryState} (h : m.PointFit p) : m.PointRoom p :=
  ⟨h.1, h.2.1.room, h.2.2.1.room, h.2.2.2.1.room, h.2.2.2.2.room⟩

/-- `LimbsFit` in a memory where more bits are known. -/
theorem MemoryState.LimbsFit.of_imp {m m' : MemoryState}
    (hf : ∀ {q : Pointer} {w : Nat}, Fits m q w → Fits m' q w) (h : m.LimbsFit p) : m'.LimbsFit p :=
  ⟨h.1, hf h.2.1, hf h.2.2.1, hf h.2.2.2.1, hf h.2.2.2.2.1, hf h.2.2.2.2.2⟩

/-- `PointFit` in a memory where more bits are known. -/
theorem MemoryState.PointFit.of_imp {m m' : MemoryState}
    (hf : ∀ {q : Pointer} {w : Nat}, Fits m q w → Fits m' q w) (h : m.PointFit p) : m'.PointFit p :=
  ⟨h.1, h.2.1.of_imp hf, h.2.2.1.of_imp hf, h.2.2.2.1.of_imp hf, h.2.2.2.2.of_imp hf⟩

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

/-! ### Limb stores to disjoint ranges commute -/

/-- Limb `k` of the field element at `q` lies inside its 320 bits. -/
theorem Range.disjoint_limb {p q : Pointer} {k : Nat} (hq : q.offset.toNat + 32 < 2 ^ 64)
    (hk : k ≤ 32) (h : (Range.of p w).Disjoint (Range.of q 320)) :
    (Range.of (q.add (BitVec.ofNat 64 k)) 64).Disjoint (Range.of p w) := by
  by_cases hid : q.id = p.id
  · simp only [Range.Disjoint, Range.of, Pointer.add, Pointer.offsetInBits, BitVec.toNat_add,
      BitVec.toNat_ofNat, hid, ne_eq, not_true_eq_false, false_or] at h ⊢
    rw [Nat.mod_eq_of_lt (by omega : k < 2 ^ 64), Nat.mod_eq_of_lt (by omega)]
    omega
  · exact Or.inl (by simpa [Range.of, Pointer.add] using hid)

theorem MemoryState.storeAt_storeLimbs_comm {m : MemoryState} {p q : Pointer} {x : BitVec w}
    (hq : q.offset.toNat + 32 < 2 ^ 64) (h : (Range.of p w).Disjoint (Range.of q 320)) :
    (m.storeLimbs q l).storeAt p x = (m.storeAt p x).storeLimbs q l := by
  have h0 : (Range.of q 64).Disjoint (Range.of p w) := by
    simpa [Pointer.add_zero'] using Range.disjoint_limb (k := 0) hq (by omega) h
  simp only [MemoryState.storeLimbs]
  rw [storeAt_comm (Range.disjoint_limb (k := 32) hq (by omega) h),
    storeAt_comm (Range.disjoint_limb (k := 24) hq (by omega) h),
    storeAt_comm (Range.disjoint_limb (k := 16) hq (by omega) h),
    storeAt_comm (Range.disjoint_limb (k := 8) hq (by omega) h), storeAt_comm h0]

/-- Field elements stored in disjoint ranges: the stores commute. -/
theorem MemoryState.storeLimbs_comm {m : MemoryState} {p q : Pointer}
    (hp : p.offset.toNat + 32 < 2 ^ 64) (hq : q.offset.toNat + 32 < 2 ^ 64)
    (h : (Range.of p 320).Disjoint (Range.of q 320)) :
    (m.storeLimbs p a).storeLimbs q b = (m.storeLimbs q b).storeLimbs p a := by
  have hd (k : Nat) (hk : k ≤ 32) :=
    Range.disjoint_limb (p := p) (q := q) (k := k) (w := 320) hq hk h |>.symm
  have h0 : (Range.of q 64).Disjoint (Range.of p 320) := by
    simpa [Pointer.add_zero'] using Range.disjoint_limb (k := 0) hq (by omega) h
  rw [MemoryState.storeLimbs.eq_1 (m.storeLimbs p a) q b]
  rw [storeAt_storeLimbs_comm hp h0, storeAt_storeLimbs_comm hp (hd 8 (by omega)).symm,
    storeAt_storeLimbs_comm hp (hd 16 (by omega)).symm,
    storeAt_storeLimbs_comm hp (hd 24 (by omega)).symm,
    storeAt_storeLimbs_comm hp (hd 32 (by omega)).symm]
  rfl

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

@[mlir_transport]
theorem MemoryState.PointRoom.limbsRoom_X {m : MemoryState} (h : m.PointRoom p) : m.LimbsRoom p :=
  h.2.1

@[mlir_transport]
theorem MemoryState.PointRoom.limbsRoom_Y {m : MemoryState} (h : m.PointRoom p) :
    m.LimbsRoom (p.add 40#64) :=
  h.2.2.1

@[mlir_transport]
theorem MemoryState.PointRoom.limbsRoom_T {m : MemoryState} (h : m.PointRoom p) :
    m.LimbsRoom (p.add 80#64) :=
  h.2.2.2.1

@[mlir_transport]
theorem MemoryState.PointRoom.limbsRoom_Z {m : MemoryState} (h : m.PointRoom p) :
    m.LimbsRoom (p.add 120#64) :=
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
    (h : m.PointRoom p) (ha : a ≤ 120) (hb : b ≤ 120) (hab : a + 40 ≤ b ∨ b + 40 ≤ a) :
    (m.storeLimbs (p.add (BitVec.ofNat 64 a)) l).readLimbs (p.add (BitVec.ofNat 64 b)) =
      m.readLimbs (p.add (BitVec.ofNat 64 b)) :=
  readLimbs_storeLimbs_of_disjoint (Range.disjoint_coords h.1 ha hb hab)
    (Pointer.coord_offset h.1 ha) (Pointer.coord_offset h.1 hb)

/-- `readLimbs_storeLimbs_coord` for a store to `X`. -/
@[mlir_read]
theorem MemoryState.readLimbs_storeLimbs_coord_X {m : MemoryState} {p : Pointer} {b : Nat}
    (h : m.PointRoom p) (hb : b ≤ 120) (h40 : 40 ≤ b) :
    (m.storeLimbs p l).readLimbs (p.add (BitVec.ofNat 64 b)) =
      m.readLimbs (p.add (BitVec.ofNat 64 b)) :=
  readLimbs_storeLimbs_of_disjoint (Range.disjoint_coords_base' h.1 hb h40) (by omega)
    (Pointer.coord_offset h.1 hb)

/-- `readLimbs_storeLimbs_coord` for a read of `X`. -/
@[mlir_read]
theorem MemoryState.readLimbs_storeLimbs_coord_of_X {m : MemoryState} {p : Pointer} {a : Nat}
    (h : m.PointRoom p) (ha : a ≤ 120) (h40 : 40 ≤ a) :
    (m.storeLimbs (p.add (BitVec.ofNat 64 a)) l).readLimbs p = m.readLimbs p :=
  readLimbs_storeLimbs_of_disjoint (Range.disjoint_coord_base h.1 ha h40)
    (Pointer.coord_offset h.1 ha) (by omega)

@[mlir_read]
theorem MemoryState.readLimbs_storePoint_X {m : MemoryState} {p : Pointer} (h : m.PointRoom p) :
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
theorem MemoryState.readLimbs_storePoint_Y {m : MemoryState} {p : Pointer} (h : m.PointRoom p) :
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
theorem MemoryState.readLimbs_storePoint_Z {m : MemoryState} {p : Pointer} (h : m.PointRoom p) :
    (m.storePoint p P).readLimbs (p.add 120#64) = P.Z := by
  simp only [MemoryState.storePoint]
  rw [readLimbs_storeLimbs_of_disjoint
      (Range.disjoint_coords (a := 80) (b := 120) h.1 (by omega) (by omega) (by omega))
      (Pointer.coord_offset (a := 80) h.1 (by omega))
      (Pointer.coord_offset (a := 120) h.1 (by omega)),
    readLimbs_storeLimbs_self h.2.2.2.2.storeLimbs.storeLimbs]

@[mlir_read]
theorem MemoryState.readLimbs_storePoint_T {m : MemoryState} {p : Pointer} (h : m.PointRoom p) :
    (m.storePoint p P).readLimbs (p.add 80#64) = P.T := by
  simp only [MemoryState.storePoint]
  rw [readLimbs_storeLimbs_self h.2.2.2.1.storeLimbs.storeLimbs.storeLimbs]

@[mlir_read]
theorem MemoryState.readPoint_storePoint_self {m : MemoryState} {p : Pointer} (h : m.PointRoom p) :
    (m.storePoint p P).readPoint p = P := by
  simp only [MemoryState.readPoint, readLimbs_storePoint_X h, readLimbs_storePoint_Y h,
    readLimbs_storePoint_Z h, readLimbs_storePoint_T h]

@[mlir_read]
theorem MemoryState.readPoint_storePoint_of_id_ne {m : MemoryState} {p q : Pointer}
    (h : p.id ≠ q.id) : (m.storePoint p P).readPoint q = m.readPoint q := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readPoint, readLimbs_storePoint_of_id_ne h,
    readLimbs_storePoint_of_id_ne (h' _)]

@[mlir_read]
theorem MemoryState.readPoint_storeLimbs_of_id_ne {m : MemoryState} {p q : Pointer}
    (h : p.id ≠ q.id) : (m.storeLimbs p l).readPoint q = m.readPoint q := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readPoint, readLimbs_storeLimbs_of_id_ne h,
    readLimbs_storeLimbs_of_id_ne (h' _)]

/-! ### Points across writes, `alloca`s and frames -/

@[simp, mlir_state]
theorem MemoryState.limbsRoom_storePoint_iff {m : MemoryState} :
    (m.storePoint p P).LimbsRoom q ↔ m.LimbsRoom q := by simp [MemoryState.storePoint]

@[mlir_mem, mlir_transport]
theorem MemoryState.LimbsFit.storePoint {m : MemoryState} (h : m.LimbsFit q) :
    (m.storePoint p P).LimbsFit q :=
  h.storeLimbs.storeLimbs.storeLimbs.storeLimbs

@[mlir_mem, mlir_transport]
theorem MemoryState.LimbsRoom.storePoint {m : MemoryState} (h : m.LimbsRoom q) :
    (m.storePoint p P).LimbsRoom q :=
  MemoryState.limbsRoom_storePoint_iff.mpr h

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
theorem MemoryState.PointRoom.storeAt {m : MemoryState} {x : BitVec w} (h : m.PointRoom q) :
    (m.storeAt p x).PointRoom q :=
  ⟨h.1, h.2.1.storeAt, h.2.2.1.storeAt, h.2.2.2.1.storeAt, h.2.2.2.2.storeAt⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.PointRoom.storeLimbs {m : MemoryState} (h : m.PointRoom q) :
    (m.storeLimbs p l).PointRoom q :=
  ⟨h.1, h.2.1.storeLimbs, h.2.2.1.storeLimbs, h.2.2.2.1.storeLimbs, h.2.2.2.2.storeLimbs⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.PointRoom.storePoint {m : MemoryState} (h : m.PointRoom q) :
    (m.storePoint p P).PointRoom q :=
  ⟨h.1, h.2.1.storePoint, h.2.2.1.storePoint, h.2.2.2.1.storePoint, h.2.2.2.2.storePoint⟩

/-- A point stored where there is room is known. -/
@[mlir_fresh, mlir_mem]
theorem MemoryState.PointFit.storePoint_self {m : MemoryState} {p : Pointer} (h : m.PointRoom p) :
    (m.storePoint p P).PointFit p := by
  have hX : (m.storeLimbs p P.X).LimbsFit p := .storeLimbs_self h.2.1
  have hY : ((m.storeLimbs p P.X).storeLimbs (p.add 40#64) P.Y).LimbsFit (p.add 40#64) :=
    .storeLimbs_self h.2.2.1.storeLimbs
  have hZ :
    (((m.storeLimbs p P.X).storeLimbs (p.add 40#64) P.Y).storeLimbs (p.add 120#64) P.Z).LimbsFit
      (p.add 120#64) :=
    .storeLimbs_self h.2.2.2.2.storeLimbs.storeLimbs
  exact
    ⟨h.1, hX.storeLimbs.storeLimbs.storeLimbs, hY.storeLimbs.storeLimbs,
      .storeLimbs_self h.2.2.2.1.storeLimbs.storeLimbs.storeLimbs, hZ.storeLimbs⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.PointFit.alloca {s : GlobalState} (hne : q.id ≠ s.allocaPtr.id)
    (h : s.mem.PointFit q) : (s.alloca n d).mem.PointFit q := by
  have hne' (k : BitVec 64) : (q.add k).id ≠ s.allocaPtr.id := by simpa [Pointer.add_id] using hne
  exact
    ⟨h.1, h.2.1.alloca hne, h.2.2.1.alloca (hne' _), h.2.2.2.1.alloca (hne' _),
      h.2.2.2.2.alloca (hne' _)⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.PointRoom.alloca {s : GlobalState} (hne : q.id ≠ s.allocaPtr.id)
    (h : s.mem.PointRoom q) : (s.alloca n d).mem.PointRoom q := by
  have hne' (k : BitVec 64) : (q.add k).id ≠ s.allocaPtr.id := by simpa [Pointer.add_id] using hne
  exact
    ⟨h.1, h.2.1.alloca hne, h.2.2.1.alloca (hne' _), h.2.2.2.1.alloca (hne' _),
      h.2.2.2.2.alloca (hne' _)⟩

@[mlir_transport]
theorem MemoryState.PointFit.addBlock {s : GlobalState} {x : BitVec v} (hwf : s.WF)
    (h : s.mem.PointFit q) : (s.mem.addBlock ⟨s.alloc.nextFreeBlock⟩ n x).PointFit q :=
  ⟨h.1, h.2.1.addBlock hwf, h.2.2.1.addBlock hwf, h.2.2.2.1.addBlock hwf, h.2.2.2.2.addBlock hwf⟩

@[mlir_transport]
theorem MemoryState.PointRoom.addBlock {s : GlobalState} {x : BitVec v} (hwf : s.WF)
    (h : s.mem.PointRoom q) : (s.mem.addBlock ⟨s.alloc.nextFreeBlock⟩ n x).PointRoom q :=
  ⟨h.1, h.2.1.addBlock hwf, h.2.2.1.addBlock hwf, h.2.2.2.1.addBlock hwf, h.2.2.2.2.addBlock hwf⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.PointFit.lifetimeStart {m : MemoryState} {p q : Pointer} (h : m.PointFit p)
    (hne : p.id ≠ q.id) : (m.lifetimeStart q).PointFit p := by
  have hne' (k : BitVec 64) : (p.add k).id ≠ q.id := by simpa [Pointer.add_id] using hne
  exact
    ⟨h.1, h.2.1.lifetimeStart hne, h.2.2.1.lifetimeStart (hne' _), h.2.2.2.1.lifetimeStart (hne' _),
      h.2.2.2.2.lifetimeStart (hne' _)⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.PointFit.lifetimeEnd {m : MemoryState} {p q : Pointer} (h : m.PointFit p)
    (hne : p.id ≠ q.id) : (m.lifetimeEnd q).PointFit p := by
  have hne' (k : BitVec 64) : (p.add k).id ≠ q.id := by simpa [Pointer.add_id] using hne
  exact
    ⟨h.1, h.2.1.lifetimeEnd hne, h.2.2.1.lifetimeEnd (hne' _), h.2.2.2.1.lifetimeEnd (hne' _),
      h.2.2.2.2.lifetimeEnd (hne' _)⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.PointRoom.lifetimeStart {m : MemoryState} {p q : Pointer} (h : m.PointRoom p)
    (hne : p.id ≠ q.id) : (m.lifetimeStart q).PointRoom p := by
  have hne' (k : BitVec 64) : (p.add k).id ≠ q.id := by simpa [Pointer.add_id] using hne
  exact
    ⟨h.1, h.2.1.lifetimeStart hne, h.2.2.1.lifetimeStart (hne' _), h.2.2.2.1.lifetimeStart (hne' _),
      h.2.2.2.2.lifetimeStart (hne' _)⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.PointRoom.lifetimeEnd {m : MemoryState} {p q : Pointer} (h : m.PointRoom p)
    (hne : p.id ≠ q.id) : (m.lifetimeEnd q).PointRoom p := by
  have hne' (k : BitVec 64) : (p.add k).id ≠ q.id := by simpa [Pointer.add_id] using hne
  exact
    ⟨h.1, h.2.1.lifetimeEnd hne, h.2.2.1.lifetimeEnd (hne' _), h.2.2.2.1.lifetimeEnd (hne' _),
      h.2.2.2.2.lifetimeEnd (hne' _)⟩

/-- A lifetime marker keeps the bits. -/
@[mlir_read]
theorem MemoryState.readPoint_lifetimeStart {m : MemoryState} :
    (m.lifetimeStart q).readPoint p = m.readPoint p := by
  simp only [MemoryState.readPoint, readLimbs_lifetimeStart]

/-- A lifetime marker keeps the bits. -/
@[mlir_read]
theorem MemoryState.readPoint_lifetimeEnd {m : MemoryState} :
    (m.lifetimeEnd q).readPoint p = m.readPoint p := by
  simp only [MemoryState.readPoint, readLimbs_lifetimeEnd]

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

/-- `LimbsFit.of_fits_add` for room. -/
theorem MemoryState.LimbsRoom.of_room_add {m : MemoryState} {k : BitVec 64} (h : Room m p 1280)
    (ho : p.offset = 0) (hk : k.toNat ≤ 120) : m.LimbsRoom (p.add k) := by
  have hf : Room m (p.add k) 320 :=
    Room.add_of_le
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
    exact Room.add_of_le (hov _ (by decide)) (by decide) hf

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

/-- A 160-byte live block from its start has room for one point. -/
theorem MemoryState.PointRoom.of_room {m : MemoryState} (h : Room m p 1280) (ho : p.offset = 0) :
    m.PointRoom p :=
  ⟨by simp [ho], .of_room (h.mono (by omega)) ho, .of_room_add h ho (by decide),
    .of_room_add h ho (by decide), .of_room_add h ho (by decide)⟩

/-- A point elsewhere is unaffected by `alloca`. -/
@[mlir_frame, mlir_read]
theorem MemoryState.readPoint_alloca {s : GlobalState} (hne : p.id ≠ s.allocaPtr.id) :
    (s.alloca n d).mem.readPoint p = s.mem.readPoint p := by
  have hne' (k : BitVec 64) : (p.add k).id ≠ s.allocaPtr.id := by simpa [Pointer.add_id] using hne
  simp only [MemoryState.readPoint, readLimbs_alloca hne, readLimbs_alloca (hne' _)]

/-- A point outside a new block: the point before it. -/
@[mlir_read]
theorem MemoryState.readPoint_addBlock_of_id_ne {m : MemoryState} {x : BitVec v} (h : p.id ≠ b) :
    (m.addBlock b n x).readPoint p = m.readPoint p := by
  have h' (k : BitVec 64) : (p.add k).id ≠ b := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readPoint, readLimbs_addBlock_of_id_ne h,
    readLimbs_addBlock_of_id_ne (h' _)]

/-- Room for a point before a point store when there is room after it. -/
theorem MemoryState.PointRoom.of_storePoint {m : MemoryState} (h : (m.storePoint p P).PointRoom q) :
    m.PointRoom q :=
  ⟨h.1, limbsRoom_storePoint_iff.mp h.2.1, limbsRoom_storePoint_iff.mp h.2.2.1,
    limbsRoom_storePoint_iff.mp h.2.2.2.1, limbsRoom_storePoint_iff.mp h.2.2.2.2⟩

/-- `WF.storePoint` for a state written as a constructor, which unifies first-order. -/
@[mlir_transport]
theorem GlobalState.WF.storePoint_mk {a : AllocState} {m : MemoryState}
    (h : (⟨a, m⟩ : GlobalState).WF) : (⟨a, m.storePoint p P⟩ : GlobalState).WF :=
  GlobalState.WF.storePoint (s := ⟨a, m⟩) h

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

/-- A point store that keeps `T`: the `X`, `Y` and `Z` stores. -/
theorem MemoryState.storePoint_of_T {m : MemoryState} {p : Pointer} (h : m.PointFit p) :
    m.storePoint p ⟨X, Y, m.readLimbs (p.add 80#64), Z⟩ =
      ((m.storeLimbs p X).storeLimbs (p.add 40#64) Y).storeLimbs (p.add 120#64) Z := by
  have h' := h.storeLimbs (p := p) (l := X) |>.storeLimbs (p := p.add 40#64) (l := Y)
  simp only [MemoryState.storePoint]
  rw [← readLimbs_storeLimbs_coord_X (l := X) h.room (b := 80) (by omega) (by omega), ←
    readLimbs_storeLimbs_coord (l := Y) (h.storeLimbs.room) (a := 40) (b := 80) (by omega)
      (by omega) (by omega),
    ←
    readLimbs_storeLimbs_coord (l := Z) h'.room (a := 120) (b := 80) (by omega) (by omega)
      (by omega),
    storeLimbs_readLimbs_self h'.storeLimbs.2.2.2.1]

/-- A point store that keeps `Z`: the `X`, `Y` and `T` stores. -/
theorem MemoryState.storePoint_of_Z {m : MemoryState} {p : Pointer} (h : m.PointFit p) :
    m.storePoint p ⟨X, Y, T, m.readLimbs (p.add 120#64)⟩ =
      ((m.storeLimbs p X).storeLimbs (p.add 40#64) Y).storeLimbs (p.add 80#64) T := by
  simp only [MemoryState.storePoint]
  rw [← readLimbs_storeLimbs_coord_X (l := X) h.room (b := 120) (by omega) (by omega), ←
    readLimbs_storeLimbs_coord (l := Y) h.storeLimbs.room (a := 40) (b := 120) (by omega) (by omega)
      (by omega),
    storeLimbs_readLimbs_self h.storeLimbs.storeLimbs.2.2.2.2]

/-- Stores to two coordinates of a point commute. -/
theorem MemoryState.storeLimbs_comm_coord {m : MemoryState} {p : Pointer} {a b : Nat}
    (hp : p.offset.toNat + 160 ≤ 2 ^ 64) (ha : a ≤ 120) (hb : b ≤ 120)
    (hab : a + 40 ≤ b ∨ b + 40 ≤ a) :
    (m.storeLimbs (p.add (BitVec.ofNat 64 a)) A).storeLimbs (p.add (BitVec.ofNat 64 b)) B =
      (m.storeLimbs (p.add (BitVec.ofNat 64 b)) B).storeLimbs (p.add (BitVec.ofNat 64 a)) A :=
  storeLimbs_comm (Pointer.coord_offset hp ha) (Pointer.coord_offset hp hb)
    (Range.disjoint_coords hp ha hb hab)

/-- `storeLimbs_comm_coord` for `X`, stored second. -/
theorem MemoryState.storeLimbs_comm_coord_X {m : MemoryState} {p : Pointer} {a : Nat}
    (hp : p.offset.toNat + 160 ≤ 2 ^ 64) (ha : a ≤ 120) (h40 : 40 ≤ a) :
    (m.storeLimbs (p.add (BitVec.ofNat 64 a)) A).storeLimbs p B =
      (m.storeLimbs p B).storeLimbs (p.add (BitVec.ofNat 64 a)) A :=
  storeLimbs_comm (Pointer.coord_offset hp ha) (by omega) (Range.disjoint_coord_base hp ha h40)

/-- A point stored as `T, Z, Y, X`. -/
theorem MemoryState.storePoint_of_TZYX {m : MemoryState} {p : Pointer}
    (hp : p.offset.toNat + 160 ≤ 2 ^ 64) :
    (((m.storeLimbs (p.add 80#64) T).storeLimbs (p.add 120#64) Z).storeLimbs (p.add 40#64)
            Y).storeLimbs
        p X =
      m.storePoint p ⟨X, Y, T, Z⟩ := by
  rw [storeLimbs_comm_coord_X (a := 40) hp (by omega) (by omega),
    storeLimbs_comm_coord_X (a := 120) hp (by omega) (by omega),
    storeLimbs_comm_coord_X (a := 80) hp (by omega) (by omega),
    storeLimbs_comm_coord (a := 120) (b := 40) hp (by omega) (by omega) (by omega),
    storeLimbs_comm_coord (a := 80) (b := 40) hp (by omega) (by omega) (by omega),
    storeLimbs_comm_coord (a := 80) (b := 120) hp (by omega) (by omega) (by omega)]
  rfl

/-- Stores in different blocks commute. -/
theorem MemoryState.storeLimbs_comm_of_id_ne {m : MemoryState} {p q : Pointer} (h : p.id ≠ q.id) :
    (m.storeLimbs p a).storeLimbs q b = (m.storeLimbs q b).storeLimbs p a := by
  have hd {p' q' : Pointer} {v w : Nat} (h' : p'.id ≠ q'.id) :
    (Range.of p' v).Disjoint (Range.of q' w) := Or.inl h'
  simp only [MemoryState.storeLimbs]
  simp only [MemoryState.storeAt_comm
        (hd (p' := p.add _) (q' := q.add _) (by simpa [Pointer.add_id] using h)),
    MemoryState.storeAt_comm (hd (p' := p) (q' := q.add _) (by simpa [Pointer.add_id] using h)),
    MemoryState.storeAt_comm (hd (p' := p.add _) (q' := q) (by simpa [Pointer.add_id] using h)),
    MemoryState.storeAt_comm (hd (p' := p) (q' := q) h)]

/-- Points in different blocks: their stores commute. -/
theorem MemoryState.storePoint_comm {m : MemoryState} {p q : Pointer} (h : p.id ≠ q.id) :
    (m.storePoint p P).storePoint q Q = (m.storePoint q Q).storePoint p P := by
  simp only [MemoryState.storePoint]
  rw [storeLimbs_comm_of_id_ne (p := p.add 80#64) (q := q) (by simpa [Pointer.add_id] using h),
    storeLimbs_comm_of_id_ne (p := p.add 120#64) (q := q) (by simpa [Pointer.add_id] using h),
    storeLimbs_comm_of_id_ne (p := p.add 40#64) (q := q) (by simpa [Pointer.add_id] using h),
    storeLimbs_comm_of_id_ne (p := p) (q := q) (by simpa [Pointer.add_id] using h),
    storeLimbs_comm_of_id_ne (p := p.add 80#64) (q := q.add 40#64)
      (by simpa [Pointer.add_id] using h),
    storeLimbs_comm_of_id_ne (p := p.add 120#64) (q := q.add 40#64)
      (by simpa [Pointer.add_id] using h),
    storeLimbs_comm_of_id_ne (p := p.add 40#64) (q := q.add 40#64)
      (by simpa [Pointer.add_id] using h),
    storeLimbs_comm_of_id_ne (p := p) (q := q.add 40#64) (by simpa [Pointer.add_id] using h),
    storeLimbs_comm_of_id_ne (p := p.add 80#64) (q := q.add 120#64)
      (by simpa [Pointer.add_id] using h),
    storeLimbs_comm_of_id_ne (p := p.add 120#64) (q := q.add 120#64)
      (by simpa [Pointer.add_id] using h),
    storeLimbs_comm_of_id_ne (p := p.add 40#64) (q := q.add 120#64)
      (by simpa [Pointer.add_id] using h),
    storeLimbs_comm_of_id_ne (p := p) (q := q.add 120#64) (by simpa [Pointer.add_id] using h),
    storeLimbs_comm_of_id_ne (p := p.add 80#64) (q := q.add 80#64)
      (by simpa [Pointer.add_id] using h),
    storeLimbs_comm_of_id_ne (p := p.add 120#64) (q := q.add 80#64)
      (by simpa [Pointer.add_id] using h),
    storeLimbs_comm_of_id_ne (p := p.add 40#64) (q := q.add 80#64)
      (by simpa [Pointer.add_id] using h),
    storeLimbs_comm_of_id_ne (p := p) (q := q.add 80#64) (by simpa [Pointer.add_id] using h)]

/-- A point stored twice at the same place: the second. -/
theorem MemoryState.storePoint_storePoint_self {m : MemoryState} {p : Pointer}
    (hp : p.offset.toNat + 160 ≤ 2 ^ 64) :
    (m.storePoint p P).storePoint p Q = m.storePoint p Q := by
  simp only [MemoryState.storePoint]
  rw [storeLimbs_comm_coord_X (a := 80) hp (by omega) (by omega),
    storeLimbs_comm_coord_X (a := 120) hp (by omega) (by omega),
    storeLimbs_comm_coord_X (a := 40) hp (by omega) (by omega), storeLimbs_storeLimbs_self,
    storeLimbs_comm_coord (a := 80) (b := 40) hp (by omega) (by omega) (by omega),
    storeLimbs_comm_coord (a := 120) (b := 40) hp (by omega) (by omega) (by omega),
    storeLimbs_storeLimbs_self,
    storeLimbs_comm_coord (a := 80) (b := 120) hp (by omega) (by omega) (by omega),
    storeLimbs_storeLimbs_self, storeLimbs_storeLimbs_self]

/-- A point store into a block the erase removes: dropped before the erase moves inward, which would
simplify the store's memory first. -/
@[mlir_erase high]
theorem MemoryState.eraseFrom_storePoint_of_le {m : MemoryState} (h : n ≤ p.id.id) :
    (m.storePoint p P).eraseFrom n = m.eraseFrom n := by
  rw [eraseFrom_storePoint, storePoint_eraseFrom_of_le h]

/-! ### Other blocks and optional points -/

/-- A read outside the block of a point store: the read before it. -/
@[mlir_read]
theorem MemoryState.readAt_storePoint_of_id_ne {m : MemoryState} {p q : Pointer} (h : p.id ≠ q.id) :
    (m.storePoint p P).readAt q w = m.readAt q w := by
  have h' (k : BitVec 64) : (p.add k).id ≠ q.id := by simpa [Pointer.add_id] using h
  have h40 := h' 40#64
  have h80 := h' 80#64
  have h120 := h' 120#64
  simp only [MemoryState.storePoint, MemoryState.storeLimbs, Tactic.readThroughStore]

/-- A point outside the block of a store: the point before it. -/
@[mlir_read]
theorem MemoryState.readPoint_storeAt_of_id_ne {m : MemoryState} {p q : Pointer} {x : BitVec w}
    (h : p.id ≠ q.id) : (m.storeAt p x).readPoint q = m.readPoint q := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h
  have h0 := h' 0
  have h8 := h' 8#64
  simp only [MemoryState.readPoint]
  congr 1 <;> funext i <;> fin_cases i <;>
    simp only [MemoryState.readLimbs, Pointer.add_add, Tactic.readThroughStore]

/-- A point store keeps known bits known. -/
@[mlir_transport]
theorem Fits.storePoint {m : MemoryState} (h : Fits m q w) : Fits (m.storePoint p P) q w := by
  simp only [MemoryState.storePoint]
  exact h.storeLimbs.storeLimbs.storeLimbs.storeLimbs

/-- A point store keeps every block and its length. -/
@[mlir_transport]
theorem InBounds.storePoint {m : MemoryState} (h : InBounds m q w) :
    InBounds (m.storePoint p P) q w := by
  simp only [MemoryState.storePoint]
  exact h.storeLimbs.storeLimbs.storeLimbs.storeLimbs

/-- A point store keeps every block, its length and lifetime. -/
@[mlir_transport]
theorem Room.storePoint {m : MemoryState} (h : Room m q w) : Room (m.storePoint p P) q w := by
  simp only [MemoryState.storePoint]
  exact h.storeLimbs.storeLimbs.storeLimbs.storeLimbs

/-- The point `P?` stored at `p`, if there is one. -/
def MemoryState.storePointOpt (m : MemoryState) (p : Pointer) : Option PointLimbs → MemoryState
  | some P => m.storePoint p P
  | none => m

/-- A read outside the block of a limbs store: the read before it. -/
@[mlir_read]
theorem MemoryState.readAt_storeLimbs_of_id_ne {m : MemoryState} {p q : Pointer} (h : p.id ≠ q.id) :
    (m.storeLimbs q l).readAt p w = m.readAt p w := by
  simp only [MemoryState.storeLimbs, Tactic.readThroughStore]

theorem MemoryState.storePointOpt_none {m : MemoryState} : m.storePointOpt p none = m :=
  rfl

theorem MemoryState.storePointOpt_some {m : MemoryState} :
    m.storePointOpt p (some P) = m.storePoint p P :=
  rfl

/-- `storePointOpt` keeps every block and its length. -/
@[mlir_transport]
theorem Fits.storePointOpt {m : MemoryState} (h : Fits m q w) :
    Fits (m.storePointOpt p P?) q w := by
  cases P?
  · exact h
  · exact h.storePoint

/-- `storePointOpt` keeps every block and its length. -/
@[mlir_transport]
theorem InBounds.storePointOpt {m : MemoryState} (h : InBounds m q w) :
    InBounds (m.storePointOpt p P?) q w := by
  cases P?
  · exact h
  · exact h.storePoint

/-- `storePointOpt` keeps every block, its length and lifetime. -/
@[mlir_transport]
theorem Room.storePointOpt {m : MemoryState} (h : Room m q w) :
    Room (m.storePointOpt p P?) q w := by
  cases P?
  · exact h
  · exact h.storePoint

@[mlir_transport]
theorem MemoryState.LimbsRoom.storePointOpt {m : MemoryState} (h : m.LimbsRoom q) :
    (m.storePointOpt p P?).LimbsRoom q := by
  cases P?
  · exact h
  · exact h.storePoint

@[mlir_transport]
theorem MemoryState.PointRoom.storePointOpt {m : MemoryState} (h : m.PointRoom q) :
    (m.storePointOpt p P?).PointRoom q := by
  cases P?
  · exact h
  · exact h.storePoint

@[mlir_transport]
theorem MemoryState.LimbsFit.storePointOpt {m : MemoryState} (h : m.LimbsFit q) :
    (m.storePointOpt p P?).LimbsFit q := by
  cases P?
  · exact h
  · exact h.storePoint

@[mlir_transport]
theorem MemoryState.PointFit.storePointOpt {m : MemoryState} (h : m.PointFit q) :
    (m.storePointOpt p P?).PointFit q := by
  cases P?
  · exact h
  · exact h.storePoint

@[mlir_transport]
theorem GlobalState.WF.storePointOpt_mk {a : AllocState} {m : MemoryState}
    (h : (⟨a, m⟩ : GlobalState).WF) : (⟨a, m.storePointOpt p P?⟩ : GlobalState).WF := by
  cases P?
  · exact h
  · exact GlobalState.WF.storePoint_mk h

/-- A read outside the block of an optional point store: the read before it. -/
@[mlir_read]
theorem MemoryState.readAt_storePointOpt_of_id_ne {m : MemoryState} (h : q.id ≠ p.id) :
    (m.storePointOpt p P?).readAt q w = m.readAt q w := by
  cases P?
  · rfl
  · have h' (k : BitVec 64) : q.id ≠ (p.add k).id := by simpa [Pointer.add_id] using h
    simp only [MemoryState.storePointOpt_some, MemoryState.storePoint,
      MemoryState.readAt_storeLimbs_of_id_ne h, MemoryState.readAt_storeLimbs_of_id_ne (h' _)]

/-- A point outside the block of an optional point store: the point before it. -/
@[mlir_read]
theorem MemoryState.readPoint_storePointOpt_of_id_ne {m : MemoryState} (h : q.id ≠ p.id) :
    (m.storePointOpt p P?).readPoint q = m.readPoint q := by
  cases P?
  · rfl
  · exact MemoryState.readPoint_storePoint_of_id_ne (Ne.symm h)

@[mlir_erase]
theorem MemoryState.eraseFrom_storePointOpt {m : MemoryState} :
    (m.storePointOpt p P?).eraseFrom n = (m.eraseFrom n).storePointOpt p P? := by
  cases P?
  · rfl
  · exact MemoryState.eraseFrom_storePoint

-- last among the transports: tried after the structural ones, which carry a `…Room` fact
-- directly, so they do not search the `…Fit` facts first
attribute [-mlir_transport] MemoryState.LimbsFit.room

attribute [mlir_transport] MemoryState.LimbsFit.room MemoryState.PointFit.room

end

end MLIR
