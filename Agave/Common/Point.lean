module

public import Agave.Common.Limbs
public import Firedancer.Common.Point
import MLIR.Run.Tactic.Memory

/-! dalek's serial points in memory, read and stored as a whole: `EdwardsPoint`, `CompletedPoint`
and `ProjectiveNielsPoint`, four field elements at byte offsets 0, 40, 80, 120 (`PointFit`,
`PointRoom`, the layout's predicates), and `ProjectivePoint`, three at 0, 40, 80 (`ProjectiveFit`,
`ProjectiveRoom`). -/

namespace MLIR

open Memory

@[expose] public section

/-! ### Objects -/

/-- `EdwardsPoint`: extended `(X : Y : Z : T)`, `X Y = Z T`. -/
structure Agave.EdwardsPoint where
  X : Fin 5 → BitVec 64
  Y : Fin 5 → BitVec 64
  Z : Fin 5 → BitVec 64
  T : Fin 5 → BitVec 64

/-- `ProjectivePoint`: `(X : Y : Z)`. -/
structure Agave.ProjectivePoint where
  X : Fin 5 → BitVec 64
  Y : Fin 5 → BitVec 64
  Z : Fin 5 → BitVec 64

/-- `CompletedPoint`: `((X : Z), (Y : T))`. -/
structure Agave.CompletedPoint where
  X : Fin 5 → BitVec 64
  Y : Fin 5 → BitVec 64
  Z : Fin 5 → BitVec 64
  T : Fin 5 → BitVec 64

/-- `ProjectiveNielsPoint`: `(Y + X, Y - X, Z, 2d T)` of an extended point. -/
structure Agave.ProjectiveNielsPoint where
  Y_plus_X : Fin 5 → BitVec 64
  Y_minus_X : Fin 5 → BitVec 64
  Z : Fin 5 → BitVec 64
  T2d : Fin 5 → BitVec 64

/-- Four field elements at byte offsets 0, 40, 80, 120, stored in that order. -/
def MemoryState.storeFe4 (m : MemoryState) (p : Pointer) (a b c d : Fin 5 → BitVec 64) :
    MemoryState :=
  (((m.storeLimbs p a).storeLimbs (p.add 40#64) b).storeLimbs (p.add 80#64) c).storeLimbs
    (p.add 120#64) d

/-- Three field elements at byte offsets 0, 40, 80, stored in that order. -/
def MemoryState.storeFe3 (m : MemoryState) (p : Pointer) (a b c : Fin 5 → BitVec 64) :
    MemoryState :=
  ((m.storeLimbs p a).storeLimbs (p.add 40#64) b).storeLimbs (p.add 80#64) c

/-- The `ProjectivePoint` at `p` fits: its offsets do not wrap, and each field element fits. -/
abbrev MemoryState.ProjectiveFit (m : MemoryState) (p : Pointer) : Prop :=
  p.offset.toNat + 120 ≤ 2 ^ 64 ∧ m.LimbsFit p ∧ m.LimbsFit (p.add 40#64) ∧ m.LimbsFit (p.add 80#64)

/-- Room for the `ProjectivePoint` at `p` (an output): its offsets do not wrap, room for each field
element. -/
abbrev MemoryState.ProjectiveRoom (m : MemoryState) (p : Pointer) : Prop :=
  p.offset.toNat + 120 ≤ 2 ^ 64 ∧
    m.LimbsRoom p ∧ m.LimbsRoom (p.add 40#64) ∧ m.LimbsRoom (p.add 80#64)

theorem MemoryState.ProjectiveFit.room {m : MemoryState} (h : m.ProjectiveFit p)
    (hw : Writable m p) : m.ProjectiveRoom p :=
  ⟨h.1, h.2.1.room hw, h.2.2.1.room (hw.of_id_eq rfl), h.2.2.2.room (hw.of_id_eq rfl)⟩

/-! ### Field elements of one object -/

/-- Field elements at byte offsets `a` and `b`, 40 apart, inside `n` bytes from `p`: disjoint. -/
theorem Range.disjoint_coords_le {p : Pointer} {a b n : Nat} (hp : p.offset.toNat + n ≤ 2 ^ 64)
    (ha : a + 40 ≤ n) (hb : b + 40 ≤ n) (hab : a + 40 ≤ b ∨ b + 40 ≤ a) :
    (Range.of (p.add (BitVec.ofNat 64 a)) 320).Disjoint
      (Range.of (p.add (BitVec.ofNat 64 b)) 320) := by
  simp only [Range.Disjoint, Range.of, Pointer.add, Pointer.offsetInBits, BitVec.toNat_add,
    BitVec.toNat_ofNat]
  right
  rw [Nat.mod_eq_of_lt (by omega : a < 2 ^ 64), Nat.mod_eq_of_lt (by omega : b < 2 ^ 64),
    Nat.mod_eq_of_lt (by omega), Nat.mod_eq_of_lt (by omega)]
  omega

theorem Pointer.coord_offset_le {p : Pointer} {a n : Nat} (hp : p.offset.toNat + n ≤ 2 ^ 64)
    (ha : a + 40 ≤ n) : (p.add (BitVec.ofNat 64 a)).offset.toNat + 32 < 2 ^ 64 := by
  simp only [Pointer.add, BitVec.toNat_add, BitVec.toNat_ofNat]
  rw [Nat.mod_eq_of_lt (by omega : a < 2 ^ 64), Nat.mod_eq_of_lt (by omega)]
  omega

/-- A field element read past a store to another one of the same object. -/
theorem MemoryState.readLimbs_storeLimbs_coord_le {m : MemoryState} {p : Pointer} {a b n : Nat}
    (hp : p.offset.toNat + n ≤ 2 ^ 64) (ha : a + 40 ≤ n) (hb : b + 40 ≤ n)
    (hab : a + 40 ≤ b ∨ b + 40 ≤ a) :
    (m.storeLimbs (p.add (BitVec.ofNat 64 a)) l).readLimbs (p.add (BitVec.ofNat 64 b)) =
      m.readLimbs (p.add (BitVec.ofNat 64 b)) :=
  readLimbs_storeLimbs_of_disjoint (Range.disjoint_coords_le hp ha hb hab)
    (Pointer.coord_offset_le hp ha) (Pointer.coord_offset_le hp hb)

/-- `readLimbs_storeLimbs_coord_le` for a store to the first one. -/
theorem MemoryState.readLimbs_storeLimbs_coord_le_X {m : MemoryState} {p : Pointer} {b n : Nat}
    (hp : p.offset.toNat + n ≤ 2 ^ 64) (hb : b + 40 ≤ n) (h40 : 40 ≤ b) :
    (m.storeLimbs p l).readLimbs (p.add (BitVec.ofNat 64 b)) =
      m.readLimbs (p.add (BitVec.ofNat 64 b)) := by
  simpa [Pointer.add_zero'] using
    readLimbs_storeLimbs_coord_le (m := m) (l := l) (a := 0) hp (by omega) hb (by omega)

/-- `readLimbs_storeLimbs_coord_le` for a read of the first one. -/
theorem MemoryState.readLimbs_storeLimbs_coord_le_of_X {m : MemoryState} {p : Pointer} {a n : Nat}
    (hp : p.offset.toNat + n ≤ 2 ^ 64) (ha : a + 40 ≤ n) (h40 : 40 ≤ a) :
    (m.storeLimbs (p.add (BitVec.ofNat 64 a)) l).readLimbs p = m.readLimbs p := by
  simpa [Pointer.add_zero'] using
    readLimbs_storeLimbs_coord_le (m := m) (l := l) (b := 0) hp ha (by omega) (by omega)

/-! ### `ProjectiveFit` and `ProjectiveRoom` -/

@[mlir_transport]
theorem MemoryState.ProjectiveFit.limbsFit_X {m : MemoryState} (h : m.ProjectiveFit p) :
    m.LimbsFit p :=
  h.2.1

@[mlir_transport]
theorem MemoryState.ProjectiveFit.limbsFit_Y {m : MemoryState} (h : m.ProjectiveFit p) :
    m.LimbsFit (p.add 40#64) :=
  h.2.2.1

@[mlir_transport]
theorem MemoryState.ProjectiveFit.limbsFit_Z {m : MemoryState} (h : m.ProjectiveFit p) :
    m.LimbsFit (p.add 80#64) :=
  h.2.2.2

@[mlir_transport]
theorem MemoryState.ProjectiveRoom.limbsRoom_X {m : MemoryState} (h : m.ProjectiveRoom p) :
    m.LimbsRoom p :=
  h.2.1

@[mlir_transport]
theorem MemoryState.ProjectiveRoom.limbsRoom_Y {m : MemoryState} (h : m.ProjectiveRoom p) :
    m.LimbsRoom (p.add 40#64) :=
  h.2.2.1

@[mlir_transport]
theorem MemoryState.ProjectiveRoom.limbsRoom_Z {m : MemoryState} (h : m.ProjectiveRoom p) :
    m.LimbsRoom (p.add 80#64) :=
  h.2.2.2

@[mlir_mem, mlir_transport]
theorem MemoryState.ProjectiveFit.storeAt {m : MemoryState} {x : BitVec w} (h : m.ProjectiveFit q) :
    (m.storeAt p x).ProjectiveFit q :=
  ⟨h.1, h.2.1.storeAt, h.2.2.1.storeAt, h.2.2.2.storeAt⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.ProjectiveRoom.storeAt {m : MemoryState} {x : BitVec w}
    (h : m.ProjectiveRoom q) : (m.storeAt p x).ProjectiveRoom q :=
  ⟨h.1, h.2.1.storeAt, h.2.2.1.storeAt, h.2.2.2.storeAt⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.ProjectiveFit.storeLimbs {m : MemoryState} (h : m.ProjectiveFit q) :
    (m.storeLimbs p l).ProjectiveFit q :=
  ⟨h.1, h.2.1.storeLimbs, h.2.2.1.storeLimbs, h.2.2.2.storeLimbs⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.ProjectiveRoom.storeLimbs {m : MemoryState} (h : m.ProjectiveRoom q) :
    (m.storeLimbs p l).ProjectiveRoom q :=
  ⟨h.1, h.2.1.storeLimbs, h.2.2.1.storeLimbs, h.2.2.2.storeLimbs⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.ProjectiveFit.alloca {s : GlobalState} (hne : q.id ≠ s.allocaPtr.id)
    (h : s.mem.ProjectiveFit q) : (s.alloca n d).mem.ProjectiveFit q := by
  have hne' (k : BitVec 64) : (q.add k).id ≠ s.allocaPtr.id := by simpa [Pointer.add_id] using hne
  exact ⟨h.1, h.2.1.alloca hne, h.2.2.1.alloca (hne' _), h.2.2.2.alloca (hne' _)⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.ProjectiveRoom.alloca {s : GlobalState} (hne : q.id ≠ s.allocaPtr.id)
    (h : s.mem.ProjectiveRoom q) : (s.alloca n d).mem.ProjectiveRoom q := by
  have hne' (k : BitVec 64) : (q.add k).id ≠ s.allocaPtr.id := by simpa [Pointer.add_id] using hne
  exact ⟨h.1, h.2.1.alloca hne, h.2.2.1.alloca (hne' _), h.2.2.2.alloca (hne' _)⟩

@[mlir_transport]
theorem MemoryState.ProjectiveFit.addBlock {s : GlobalState} {x : BitVec v} (hwf : s.WF)
    (h : s.mem.ProjectiveFit q) : (s.mem.addBlock ⟨s.alloc.nextFreeBlock⟩ n x).ProjectiveFit q :=
  ⟨h.1, h.2.1.addBlock hwf, h.2.2.1.addBlock hwf, h.2.2.2.addBlock hwf⟩

@[mlir_transport]
theorem MemoryState.ProjectiveRoom.addBlock {s : GlobalState} {x : BitVec v} (hwf : s.WF)
    (h : s.mem.ProjectiveRoom q) : (s.mem.addBlock ⟨s.alloc.nextFreeBlock⟩ n x).ProjectiveRoom q :=
  ⟨h.1, h.2.1.addBlock hwf, h.2.2.1.addBlock hwf, h.2.2.2.addBlock hwf⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.ProjectiveFit.lifetimeStart {m : MemoryState} {p q : Pointer}
    (h : m.ProjectiveFit p) (hne : p.id ≠ q.id) : (m.lifetimeStart q).ProjectiveFit p := by
  have hne' (k : BitVec 64) : (p.add k).id ≠ q.id := by simpa [Pointer.add_id] using hne
  exact
    ⟨h.1, h.2.1.lifetimeStart hne, h.2.2.1.lifetimeStart (hne' _), h.2.2.2.lifetimeStart (hne' _)⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.ProjectiveFit.lifetimeEnd {m : MemoryState} {p q : Pointer}
    (h : m.ProjectiveFit p) (hne : p.id ≠ q.id) : (m.lifetimeEnd q).ProjectiveFit p := by
  have hne' (k : BitVec 64) : (p.add k).id ≠ q.id := by simpa [Pointer.add_id] using hne
  exact ⟨h.1, h.2.1.lifetimeEnd hne, h.2.2.1.lifetimeEnd (hne' _), h.2.2.2.lifetimeEnd (hne' _)⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.ProjectiveRoom.lifetimeStart {m : MemoryState} {p q : Pointer}
    (h : m.ProjectiveRoom p) (hne : p.id ≠ q.id) : (m.lifetimeStart q).ProjectiveRoom p := by
  have hne' (k : BitVec 64) : (p.add k).id ≠ q.id := by simpa [Pointer.add_id] using hne
  exact
    ⟨h.1, h.2.1.lifetimeStart hne, h.2.2.1.lifetimeStart (hne' _), h.2.2.2.lifetimeStart (hne' _)⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.ProjectiveRoom.lifetimeEnd {m : MemoryState} {p q : Pointer}
    (h : m.ProjectiveRoom p) (hne : p.id ≠ q.id) : (m.lifetimeEnd q).ProjectiveRoom p := by
  have hne' (k : BitVec 64) : (p.add k).id ≠ q.id := by simpa [Pointer.add_id] using hne
  exact ⟨h.1, h.2.1.lifetimeEnd hne, h.2.2.1.lifetimeEnd (hne' _), h.2.2.2.lifetimeEnd (hne' _)⟩

/-- Room for the field element `k ≤ 80` bytes into a 120-byte block. -/
theorem MemoryState.LimbsRoom.of_room_add₃ {m : MemoryState} {k : BitVec 64} (h : Room m p 960)
    (ho : p.offset = 0) (hk : k.toNat ≤ 80) : m.LimbsRoom (p.add k) := by
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

/-- A 120-byte live block from its start has room for one `ProjectivePoint`. -/
theorem MemoryState.ProjectiveRoom.of_room {m : MemoryState} (h : Room m p 960)
    (ho : p.offset = 0) : m.ProjectiveRoom p :=
  ⟨by simp [ho], .of_room (h.mono (by omega)) ho, .of_room_add₃ h ho (by decide),
    .of_room_add₃ h ho (by decide)⟩

/-! ### Four field elements -/

section Fe4

variable {m : MemoryState} {p q : Pointer} {a b c d : Fin 5 → BitVec 64}

theorem Fits.storeFe4 (h : Fits m q w) : Fits (m.storeFe4 p a b c d) q w :=
  h.storeLimbs.storeLimbs.storeLimbs.storeLimbs

theorem Room.storeFe4 (h : Room m q w) : Room (m.storeFe4 p a b c d) q w :=
  h.storeLimbs.storeLimbs.storeLimbs.storeLimbs

theorem InBounds.storeFe4 (h : InBounds m q w) : InBounds (m.storeFe4 p a b c d) q w :=
  h.storeLimbs.storeLimbs.storeLimbs.storeLimbs

theorem MemoryState.LimbsFit.storeFe4 (h : m.LimbsFit q) : (m.storeFe4 p a b c d).LimbsFit q :=
  h.storeLimbs.storeLimbs.storeLimbs.storeLimbs

theorem MemoryState.LimbsRoom.storeFe4 (h : m.LimbsRoom q) : (m.storeFe4 p a b c d).LimbsRoom q :=
  h.storeLimbs.storeLimbs.storeLimbs.storeLimbs

theorem MemoryState.PointFit.storeFe4 (h : m.PointFit q) : (m.storeFe4 p a b c d).PointFit q :=
  h.storeLimbs.storeLimbs.storeLimbs.storeLimbs

theorem MemoryState.PointRoom.storeFe4 (h : m.PointRoom q) : (m.storeFe4 p a b c d).PointRoom q :=
  h.storeLimbs.storeLimbs.storeLimbs.storeLimbs

theorem MemoryState.ProjectiveFit.storeFe4 (h : m.ProjectiveFit q) :
    (m.storeFe4 p a b c d).ProjectiveFit q :=
  h.storeLimbs.storeLimbs.storeLimbs.storeLimbs

theorem MemoryState.ProjectiveRoom.storeFe4 (h : m.ProjectiveRoom q) :
    (m.storeFe4 p a b c d).ProjectiveRoom q :=
  h.storeLimbs.storeLimbs.storeLimbs.storeLimbs

theorem MemoryState.limbsRoom_storeFe4_iff :
    (m.storeFe4 p a b c d).LimbsRoom q ↔ m.LimbsRoom q := by simp [MemoryState.storeFe4]

theorem GlobalState.WF_storeFe4 {s : GlobalState} :
    ({ s with mem := m.storeFe4 p a b c d } : GlobalState).WF ↔
      ({ s with mem := m } : GlobalState).WF := by
  simp [MemoryState.storeFe4]

theorem MemoryState.PointFit.storeFe4_self (h : m.PointRoom p) :
    (m.storeFe4 p a b c d).PointFit p :=
  ⟨h.1, (LimbsFit.storeLimbs_self h.2.1).storeLimbs.storeLimbs.storeLimbs,
    (LimbsFit.storeLimbs_self h.2.2.1.storeLimbs).storeLimbs.storeLimbs,
    (LimbsFit.storeLimbs_self h.2.2.2.1.storeLimbs.storeLimbs).storeLimbs,
    LimbsFit.storeLimbs_self h.2.2.2.2.storeLimbs.storeLimbs.storeLimbs⟩

theorem MemoryState.readLimbs_storeFe4_of_id_ne (h : p.id ≠ q.id) :
    (m.storeFe4 p a b c d).readLimbs q = m.readLimbs q := by
  have h' (k : BitVec 64) : (p.add k).id ≠ q.id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.storeFe4, readLimbs_storeLimbs_of_id_ne h,
    readLimbs_storeLimbs_of_id_ne (h' _)]

theorem MemoryState.readAt_storeFe4_of_id_ne (h : p.id ≠ q.id) :
    (m.storeFe4 p a b c d).readAt q w = m.readAt q w := by
  have h' (k : BitVec 64) : q.id ≠ (p.add k).id := by simpa [Pointer.add_id] using h.symm
  simp only [MemoryState.storeFe4, readAt_storeLimbs_of_id_ne h.symm,
    readAt_storeLimbs_of_id_ne (h' _)]

theorem MemoryState.readLimbs_storeFe4_0 (h : m.PointRoom p) :
    (m.storeFe4 p a b c d).readLimbs p = a := by
  rw [MemoryState.storeFe4, readLimbs_storeLimbs_coord_le_of_X (a := 120) h.1 (by omega) (by omega),
    readLimbs_storeLimbs_coord_le_of_X (a := 80) h.1 (by omega) (by omega),
    readLimbs_storeLimbs_coord_le_of_X (a := 40) h.1 (by omega) (by omega),
    readLimbs_storeLimbs_self h.2.1]

theorem MemoryState.readLimbs_storeFe4_1 (h : m.PointRoom p) :
    (m.storeFe4 p a b c d).readLimbs (p.add 40#64) = b := by
  rw [MemoryState.storeFe4,
    readLimbs_storeLimbs_coord_le (a := 120) (b := 40) h.1 (by omega) (by omega) (by omega),
    readLimbs_storeLimbs_coord_le (a := 80) (b := 40) h.1 (by omega) (by omega) (by omega),
    readLimbs_storeLimbs_self h.2.2.1.storeLimbs]

theorem MemoryState.readLimbs_storeFe4_2 (h : m.PointRoom p) :
    (m.storeFe4 p a b c d).readLimbs (p.add 80#64) = c := by
  rw [MemoryState.storeFe4,
    readLimbs_storeLimbs_coord_le (a := 120) (b := 80) h.1 (by omega) (by omega) (by omega),
    readLimbs_storeLimbs_self h.2.2.2.1.storeLimbs.storeLimbs]

theorem MemoryState.readLimbs_storeFe4_3 (h : m.PointRoom p) :
    (m.storeFe4 p a b c d).readLimbs (p.add 120#64) = d := by
  rw [MemoryState.storeFe4, readLimbs_storeLimbs_self h.2.2.2.2.storeLimbs.storeLimbs.storeLimbs]

theorem MemoryState.eraseFrom_storeFe4 :
    (m.storeFe4 p a b c d).eraseFrom n = (m.eraseFrom n).storeFe4 p a b c d := by
  simp [MemoryState.storeFe4, MemoryState.eraseFrom_storeLimbs]

theorem MemoryState.storeFe4_eraseFrom_of_le (h : n ≤ p.id.id) :
    (m.eraseFrom n).storeFe4 p a b c d = m.eraseFrom n := by
  simp [MemoryState.storeFe4, MemoryState.storeLimbs_eraseFrom_of_le, Pointer.add, h]

end Fe4

/-! ### Three field elements -/

section Fe3

variable {m : MemoryState} {p q : Pointer} {a b c : Fin 5 → BitVec 64}

theorem Fits.storeFe3 (h : Fits m q w) : Fits (m.storeFe3 p a b c) q w :=
  h.storeLimbs.storeLimbs.storeLimbs

theorem Room.storeFe3 (h : Room m q w) : Room (m.storeFe3 p a b c) q w :=
  h.storeLimbs.storeLimbs.storeLimbs

theorem InBounds.storeFe3 (h : InBounds m q w) : InBounds (m.storeFe3 p a b c) q w :=
  h.storeLimbs.storeLimbs.storeLimbs

theorem MemoryState.LimbsFit.storeFe3 (h : m.LimbsFit q) : (m.storeFe3 p a b c).LimbsFit q :=
  h.storeLimbs.storeLimbs.storeLimbs

theorem MemoryState.LimbsRoom.storeFe3 (h : m.LimbsRoom q) : (m.storeFe3 p a b c).LimbsRoom q :=
  h.storeLimbs.storeLimbs.storeLimbs

theorem MemoryState.PointFit.storeFe3 (h : m.PointFit q) : (m.storeFe3 p a b c).PointFit q :=
  h.storeLimbs.storeLimbs.storeLimbs

theorem MemoryState.PointRoom.storeFe3 (h : m.PointRoom q) : (m.storeFe3 p a b c).PointRoom q :=
  h.storeLimbs.storeLimbs.storeLimbs

theorem MemoryState.ProjectiveFit.storeFe3 (h : m.ProjectiveFit q) :
    (m.storeFe3 p a b c).ProjectiveFit q :=
  h.storeLimbs.storeLimbs.storeLimbs

theorem MemoryState.ProjectiveRoom.storeFe3 (h : m.ProjectiveRoom q) :
    (m.storeFe3 p a b c).ProjectiveRoom q :=
  h.storeLimbs.storeLimbs.storeLimbs

theorem MemoryState.limbsRoom_storeFe3_iff : (m.storeFe3 p a b c).LimbsRoom q ↔ m.LimbsRoom q := by
  simp [MemoryState.storeFe3]

theorem GlobalState.WF_storeFe3 {s : GlobalState} :
    ({ s with mem := m.storeFe3 p a b c } : GlobalState).WF ↔
      ({ s with mem := m } : GlobalState).WF := by
  simp [MemoryState.storeFe3]

theorem MemoryState.ProjectiveFit.storeFe3_self (h : m.ProjectiveRoom p) :
    (m.storeFe3 p a b c).ProjectiveFit p :=
  ⟨h.1, (LimbsFit.storeLimbs_self h.2.1).storeLimbs.storeLimbs,
    (LimbsFit.storeLimbs_self h.2.2.1.storeLimbs).storeLimbs,
    LimbsFit.storeLimbs_self h.2.2.2.storeLimbs.storeLimbs⟩

theorem MemoryState.readLimbs_storeFe3_of_id_ne (h : p.id ≠ q.id) :
    (m.storeFe3 p a b c).readLimbs q = m.readLimbs q := by
  have h' (k : BitVec 64) : (p.add k).id ≠ q.id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.storeFe3, readLimbs_storeLimbs_of_id_ne h,
    readLimbs_storeLimbs_of_id_ne (h' _)]

theorem MemoryState.readAt_storeFe3_of_id_ne (h : p.id ≠ q.id) :
    (m.storeFe3 p a b c).readAt q w = m.readAt q w := by
  have h' (k : BitVec 64) : q.id ≠ (p.add k).id := by simpa [Pointer.add_id] using h.symm
  simp only [MemoryState.storeFe3, readAt_storeLimbs_of_id_ne h.symm,
    readAt_storeLimbs_of_id_ne (h' _)]

theorem MemoryState.readLimbs_storeFe3_0 (h : m.ProjectiveRoom p) :
    (m.storeFe3 p a b c).readLimbs p = a := by
  rw [MemoryState.storeFe3, readLimbs_storeLimbs_coord_le_of_X (a := 80) h.1 (by omega) (by omega),
    readLimbs_storeLimbs_coord_le_of_X (a := 40) h.1 (by omega) (by omega),
    readLimbs_storeLimbs_self h.2.1]

theorem MemoryState.readLimbs_storeFe3_1 (h : m.ProjectiveRoom p) :
    (m.storeFe3 p a b c).readLimbs (p.add 40#64) = b := by
  rw [MemoryState.storeFe3,
    readLimbs_storeLimbs_coord_le (a := 80) (b := 40) h.1 (by omega) (by omega) (by omega),
    readLimbs_storeLimbs_self h.2.2.1.storeLimbs]

theorem MemoryState.readLimbs_storeFe3_2 (h : m.ProjectiveRoom p) :
    (m.storeFe3 p a b c).readLimbs (p.add 80#64) = c := by
  rw [MemoryState.storeFe3, readLimbs_storeLimbs_self h.2.2.2.storeLimbs.storeLimbs]

theorem MemoryState.eraseFrom_storeFe3 :
    (m.storeFe3 p a b c).eraseFrom n = (m.eraseFrom n).storeFe3 p a b c := by
  simp [MemoryState.storeFe3, MemoryState.eraseFrom_storeLimbs]

theorem MemoryState.storeFe3_eraseFrom_of_le (h : n ≤ p.id.id) :
    (m.eraseFrom n).storeFe3 p a b c = m.eraseFrom n := by
  simp [MemoryState.storeFe3, MemoryState.storeLimbs_eraseFrom_of_le, Pointer.add, h]

end Fe3

/-! ### The objects' reads and stores -/

/-- The `EdwardsPoint` at `p`. -/
def MemoryState.readEdwards (m : MemoryState) (p : Pointer) : Agave.EdwardsPoint :=
  ⟨m.readLimbs p, m.readLimbs (p.add 40#64), m.readLimbs (p.add 80#64), m.readLimbs (p.add 120#64)⟩

/-- Store a `EdwardsPoint` at `p`, `X` to `T`. -/
def MemoryState.storeEdwards (m : MemoryState) (p : Pointer) (P : Agave.EdwardsPoint) :
    MemoryState :=
  m.storeFe4 p P.X P.Y P.Z P.T

/-- The `ProjectivePoint` at `p`. -/
def MemoryState.readProjective (m : MemoryState) (p : Pointer) : Agave.ProjectivePoint :=
  ⟨m.readLimbs p, m.readLimbs (p.add 40#64), m.readLimbs (p.add 80#64)⟩

/-- Store a `ProjectivePoint` at `p`, `X` to `Z`. -/
def MemoryState.storeProjective (m : MemoryState) (p : Pointer) (P : Agave.ProjectivePoint) :
    MemoryState :=
  m.storeFe3 p P.X P.Y P.Z

/-- The `CompletedPoint` at `p`. -/
def MemoryState.readCompleted (m : MemoryState) (p : Pointer) : Agave.CompletedPoint :=
  ⟨m.readLimbs p, m.readLimbs (p.add 40#64), m.readLimbs (p.add 80#64), m.readLimbs (p.add 120#64)⟩

/-- Store a `CompletedPoint` at `p`, `X` to `T`. -/
def MemoryState.storeCompleted (m : MemoryState) (p : Pointer) (P : Agave.CompletedPoint) :
    MemoryState :=
  m.storeFe4 p P.X P.Y P.Z P.T

/-- The `ProjectiveNielsPoint` at `p`. -/
def MemoryState.readNiels (m : MemoryState) (p : Pointer) : Agave.ProjectiveNielsPoint :=
  ⟨m.readLimbs p, m.readLimbs (p.add 40#64), m.readLimbs (p.add 80#64), m.readLimbs (p.add 120#64)⟩

/-- Store a `ProjectiveNielsPoint` at `p`, `Y_plus_X` to `T2d`. -/
def MemoryState.storeNiels (m : MemoryState) (p : Pointer) (P : Agave.ProjectiveNielsPoint) :
    MemoryState :=
  m.storeFe4 p P.Y_plus_X P.Y_minus_X P.Z P.T2d

/-! ### `EdwardsPoint` stores -/

section Edwards

variable {m : MemoryState} {p q : Pointer} {P : Agave.EdwardsPoint}

@[mlir_transport]
theorem Fits.storeEdwards (h : Fits m q w) : Fits (m.storeEdwards p P) q w :=
  h.storeFe4

@[mlir_transport]
theorem Room.storeEdwards (h : Room m q w) : Room (m.storeEdwards p P) q w :=
  h.storeFe4

@[mlir_transport]
theorem InBounds.storeEdwards (h : InBounds m q w) : InBounds (m.storeEdwards p P) q w :=
  h.storeFe4

@[mlir_mem, mlir_transport]
theorem MemoryState.LimbsFit.storeEdwards (h : m.LimbsFit q) : (m.storeEdwards p P).LimbsFit q :=
  h.storeFe4

@[mlir_mem, mlir_transport]
theorem MemoryState.LimbsRoom.storeEdwards (h : m.LimbsRoom q) : (m.storeEdwards p P).LimbsRoom q :=
  h.storeFe4

@[mlir_mem, mlir_transport]
theorem MemoryState.PointFit.storeEdwards (h : m.PointFit q) : (m.storeEdwards p P).PointFit q :=
  h.storeFe4

@[mlir_mem, mlir_transport]
theorem MemoryState.PointRoom.storeEdwards (h : m.PointRoom q) : (m.storeEdwards p P).PointRoom q :=
  h.storeFe4

@[mlir_mem, mlir_transport]
theorem MemoryState.ProjectiveFit.storeEdwards (h : m.ProjectiveFit q) :
    (m.storeEdwards p P).ProjectiveFit q :=
  h.storeFe4

@[mlir_mem, mlir_transport]
theorem MemoryState.ProjectiveRoom.storeEdwards (h : m.ProjectiveRoom q) :
    (m.storeEdwards p P).ProjectiveRoom q :=
  h.storeFe4

@[simp, mlir_state]
theorem MemoryState.limbsRoom_storeEdwards_iff : (m.storeEdwards p P).LimbsRoom q ↔ m.LimbsRoom q :=
  limbsRoom_storeFe4_iff

theorem MemoryState.PointRoom.of_storeEdwards (h : (m.storeEdwards p P).PointRoom q) :
    m.PointRoom q :=
  ⟨h.1, limbsRoom_storeEdwards_iff.mp h.2.1, limbsRoom_storeEdwards_iff.mp h.2.2.1,
    limbsRoom_storeEdwards_iff.mp h.2.2.2.1, limbsRoom_storeEdwards_iff.mp h.2.2.2.2⟩

theorem MemoryState.ProjectiveRoom.of_storeEdwards (h : (m.storeEdwards p P).ProjectiveRoom q) :
    m.ProjectiveRoom q :=
  ⟨h.1, limbsRoom_storeEdwards_iff.mp h.2.1, limbsRoom_storeEdwards_iff.mp h.2.2.1,
    limbsRoom_storeEdwards_iff.mp h.2.2.2⟩

@[simp, mlir_mem]
theorem GlobalState.WF_storeEdwards {s : GlobalState} :
    ({ s with mem := m.storeEdwards p P } : GlobalState).WF ↔
      ({ s with mem := m } : GlobalState).WF :=
  WF_storeFe4

@[mlir_transport]
theorem GlobalState.WF.storeEdwards {s : GlobalState} (h : s.WF) :
    ({ s with mem := s.mem.storeEdwards p P } : GlobalState).WF :=
  GlobalState.WF_storeEdwards.mpr h

/-- `WF.storeEdwards` for a state written as a constructor, which unifies first-order. -/
@[mlir_transport]
theorem GlobalState.WF.storeEdwards_mk {a : AllocState} (h : (⟨a, m⟩ : GlobalState).WF) :
    (⟨a, m.storeEdwards p P⟩ : GlobalState).WF :=
  GlobalState.WF.storeEdwards (s := ⟨a, m⟩) h

/-- An `EdwardsPoint` stored where there is room is known. -/
@[mlir_fresh, mlir_mem]
theorem MemoryState.PointFit.storeEdwards_self (h : m.PointRoom p) :
    (m.storeEdwards p P).PointFit p :=
  PointFit.storeFe4_self h

@[mlir_read]
theorem MemoryState.readLimbs_storeEdwards_of_id_ne (h : p.id ≠ q.id) :
    (m.storeEdwards p P).readLimbs q = m.readLimbs q :=
  readLimbs_storeFe4_of_id_ne h

@[mlir_read]
theorem MemoryState.readAt_storeEdwards_of_id_ne (h : p.id ≠ q.id) :
    (m.storeEdwards p P).readAt q w = m.readAt q w :=
  readAt_storeFe4_of_id_ne h

@[mlir_read]
theorem MemoryState.readLimbs_storeEdwards_X (h : m.PointRoom p) :
    (m.storeEdwards p P).readLimbs p = P.X :=
  readLimbs_storeFe4_0 h

@[mlir_read]
theorem MemoryState.readLimbs_storeEdwards_Y (h : m.PointRoom p) :
    (m.storeEdwards p P).readLimbs (p.add 40#64) = P.Y :=
  readLimbs_storeFe4_1 h

@[mlir_read]
theorem MemoryState.readLimbs_storeEdwards_Z (h : m.PointRoom p) :
    (m.storeEdwards p P).readLimbs (p.add 80#64) = P.Z :=
  readLimbs_storeFe4_2 h

@[mlir_read]
theorem MemoryState.readLimbs_storeEdwards_T (h : m.PointRoom p) :
    (m.storeEdwards p P).readLimbs (p.add 120#64) = P.T :=
  readLimbs_storeFe4_3 h

@[mlir_frame, mlir_erase]
theorem MemoryState.eraseFrom_storeEdwards :
    (m.storeEdwards p P).eraseFrom n = (m.eraseFrom n).storeEdwards p P :=
  eraseFrom_storeFe4

@[mlir_frame, mlir_erase]
theorem MemoryState.storeEdwards_eraseFrom_of_le (h : n ≤ p.id.id) :
    (m.eraseFrom n).storeEdwards p P = m.eraseFrom n :=
  storeFe4_eraseFrom_of_le h

/-- A store into an erased block: dropped before the erase moves inward. -/
@[mlir_erase high]
theorem MemoryState.eraseFrom_storeEdwards_of_le (h : n ≤ p.id.id) :
    (m.storeEdwards p P).eraseFrom n = m.eraseFrom n := by
  rw [eraseFrom_storeEdwards, storeEdwards_eraseFrom_of_le h]

end Edwards

/-! ### `ProjectivePoint` stores -/

section Projective

variable {m : MemoryState} {p q : Pointer} {P : Agave.ProjectivePoint}

@[mlir_transport]
theorem Fits.storeProjective (h : Fits m q w) : Fits (m.storeProjective p P) q w :=
  h.storeFe3

@[mlir_transport]
theorem Room.storeProjective (h : Room m q w) : Room (m.storeProjective p P) q w :=
  h.storeFe3

@[mlir_transport]
theorem InBounds.storeProjective (h : InBounds m q w) : InBounds (m.storeProjective p P) q w :=
  h.storeFe3

@[mlir_mem, mlir_transport]
theorem MemoryState.LimbsFit.storeProjective (h : m.LimbsFit q) :
    (m.storeProjective p P).LimbsFit q :=
  h.storeFe3

@[mlir_mem, mlir_transport]
theorem MemoryState.LimbsRoom.storeProjective (h : m.LimbsRoom q) :
    (m.storeProjective p P).LimbsRoom q :=
  h.storeFe3

@[mlir_mem, mlir_transport]
theorem MemoryState.PointFit.storeProjective (h : m.PointFit q) :
    (m.storeProjective p P).PointFit q :=
  h.storeFe3

@[mlir_mem, mlir_transport]
theorem MemoryState.PointRoom.storeProjective (h : m.PointRoom q) :
    (m.storeProjective p P).PointRoom q :=
  h.storeFe3

@[mlir_mem, mlir_transport]
theorem MemoryState.ProjectiveFit.storeProjective (h : m.ProjectiveFit q) :
    (m.storeProjective p P).ProjectiveFit q :=
  h.storeFe3

@[mlir_mem, mlir_transport]
theorem MemoryState.ProjectiveRoom.storeProjective (h : m.ProjectiveRoom q) :
    (m.storeProjective p P).ProjectiveRoom q :=
  h.storeFe3

@[simp, mlir_state]
theorem MemoryState.limbsRoom_storeProjective_iff :
    (m.storeProjective p P).LimbsRoom q ↔ m.LimbsRoom q :=
  limbsRoom_storeFe3_iff

theorem MemoryState.PointRoom.of_storeProjective (h : (m.storeProjective p P).PointRoom q) :
    m.PointRoom q :=
  ⟨h.1, limbsRoom_storeProjective_iff.mp h.2.1, limbsRoom_storeProjective_iff.mp h.2.2.1,
    limbsRoom_storeProjective_iff.mp h.2.2.2.1, limbsRoom_storeProjective_iff.mp h.2.2.2.2⟩

theorem MemoryState.ProjectiveRoom.of_storeProjective
    (h : (m.storeProjective p P).ProjectiveRoom q) : m.ProjectiveRoom q :=
  ⟨h.1, limbsRoom_storeProjective_iff.mp h.2.1, limbsRoom_storeProjective_iff.mp h.2.2.1,
    limbsRoom_storeProjective_iff.mp h.2.2.2⟩

@[simp, mlir_mem]
theorem GlobalState.WF_storeProjective {s : GlobalState} :
    ({ s with mem := m.storeProjective p P } : GlobalState).WF ↔
      ({ s with mem := m } : GlobalState).WF :=
  WF_storeFe3

@[mlir_transport]
theorem GlobalState.WF.storeProjective {s : GlobalState} (h : s.WF) :
    ({ s with mem := s.mem.storeProjective p P } : GlobalState).WF :=
  GlobalState.WF_storeProjective.mpr h

/-- `WF.storeProjective` for a state written as a constructor, which unifies first-order. -/
@[mlir_transport]
theorem GlobalState.WF.storeProjective_mk {a : AllocState} (h : (⟨a, m⟩ : GlobalState).WF) :
    (⟨a, m.storeProjective p P⟩ : GlobalState).WF :=
  GlobalState.WF.storeProjective (s := ⟨a, m⟩) h

/-- A `ProjectivePoint` stored where there is room is known. -/
@[mlir_fresh, mlir_mem]
theorem MemoryState.ProjectiveFit.storeProjective_self (h : m.ProjectiveRoom p) :
    (m.storeProjective p P).ProjectiveFit p :=
  ProjectiveFit.storeFe3_self h

@[mlir_read]
theorem MemoryState.readLimbs_storeProjective_of_id_ne (h : p.id ≠ q.id) :
    (m.storeProjective p P).readLimbs q = m.readLimbs q :=
  readLimbs_storeFe3_of_id_ne h

@[mlir_read]
theorem MemoryState.readAt_storeProjective_of_id_ne (h : p.id ≠ q.id) :
    (m.storeProjective p P).readAt q w = m.readAt q w :=
  readAt_storeFe3_of_id_ne h

@[mlir_read]
theorem MemoryState.readLimbs_storeProjective_X (h : m.ProjectiveRoom p) :
    (m.storeProjective p P).readLimbs p = P.X :=
  readLimbs_storeFe3_0 h

@[mlir_read]
theorem MemoryState.readLimbs_storeProjective_Y (h : m.ProjectiveRoom p) :
    (m.storeProjective p P).readLimbs (p.add 40#64) = P.Y :=
  readLimbs_storeFe3_1 h

@[mlir_read]
theorem MemoryState.readLimbs_storeProjective_Z (h : m.ProjectiveRoom p) :
    (m.storeProjective p P).readLimbs (p.add 80#64) = P.Z :=
  readLimbs_storeFe3_2 h

@[mlir_frame, mlir_erase]
theorem MemoryState.eraseFrom_storeProjective :
    (m.storeProjective p P).eraseFrom n = (m.eraseFrom n).storeProjective p P :=
  eraseFrom_storeFe3

@[mlir_frame, mlir_erase]
theorem MemoryState.storeProjective_eraseFrom_of_le (h : n ≤ p.id.id) :
    (m.eraseFrom n).storeProjective p P = m.eraseFrom n :=
  storeFe3_eraseFrom_of_le h

/-- A store into an erased block: dropped before the erase moves inward. -/
@[mlir_erase high]
theorem MemoryState.eraseFrom_storeProjective_of_le (h : n ≤ p.id.id) :
    (m.storeProjective p P).eraseFrom n = m.eraseFrom n := by
  rw [eraseFrom_storeProjective, storeProjective_eraseFrom_of_le h]

end Projective

/-! ### `CompletedPoint` stores -/

section Completed

variable {m : MemoryState} {p q : Pointer} {P : Agave.CompletedPoint}

@[mlir_transport]
theorem Fits.storeCompleted (h : Fits m q w) : Fits (m.storeCompleted p P) q w :=
  h.storeFe4

@[mlir_transport]
theorem Room.storeCompleted (h : Room m q w) : Room (m.storeCompleted p P) q w :=
  h.storeFe4

@[mlir_transport]
theorem InBounds.storeCompleted (h : InBounds m q w) : InBounds (m.storeCompleted p P) q w :=
  h.storeFe4

@[mlir_mem, mlir_transport]
theorem MemoryState.LimbsFit.storeCompleted (h : m.LimbsFit q) :
    (m.storeCompleted p P).LimbsFit q :=
  h.storeFe4

@[mlir_mem, mlir_transport]
theorem MemoryState.LimbsRoom.storeCompleted (h : m.LimbsRoom q) :
    (m.storeCompleted p P).LimbsRoom q :=
  h.storeFe4

@[mlir_mem, mlir_transport]
theorem MemoryState.PointFit.storeCompleted (h : m.PointFit q) :
    (m.storeCompleted p P).PointFit q :=
  h.storeFe4

@[mlir_mem, mlir_transport]
theorem MemoryState.PointRoom.storeCompleted (h : m.PointRoom q) :
    (m.storeCompleted p P).PointRoom q :=
  h.storeFe4

@[mlir_mem, mlir_transport]
theorem MemoryState.ProjectiveFit.storeCompleted (h : m.ProjectiveFit q) :
    (m.storeCompleted p P).ProjectiveFit q :=
  h.storeFe4

@[mlir_mem, mlir_transport]
theorem MemoryState.ProjectiveRoom.storeCompleted (h : m.ProjectiveRoom q) :
    (m.storeCompleted p P).ProjectiveRoom q :=
  h.storeFe4

@[simp, mlir_state]
theorem MemoryState.limbsRoom_storeCompleted_iff :
    (m.storeCompleted p P).LimbsRoom q ↔ m.LimbsRoom q :=
  limbsRoom_storeFe4_iff

theorem MemoryState.PointRoom.of_storeCompleted (h : (m.storeCompleted p P).PointRoom q) :
    m.PointRoom q :=
  ⟨h.1, limbsRoom_storeCompleted_iff.mp h.2.1, limbsRoom_storeCompleted_iff.mp h.2.2.1,
    limbsRoom_storeCompleted_iff.mp h.2.2.2.1, limbsRoom_storeCompleted_iff.mp h.2.2.2.2⟩

theorem MemoryState.ProjectiveRoom.of_storeCompleted (h : (m.storeCompleted p P).ProjectiveRoom q) :
    m.ProjectiveRoom q :=
  ⟨h.1, limbsRoom_storeCompleted_iff.mp h.2.1, limbsRoom_storeCompleted_iff.mp h.2.2.1,
    limbsRoom_storeCompleted_iff.mp h.2.2.2⟩

@[simp, mlir_mem]
theorem GlobalState.WF_storeCompleted {s : GlobalState} :
    ({ s with mem := m.storeCompleted p P } : GlobalState).WF ↔
      ({ s with mem := m } : GlobalState).WF :=
  WF_storeFe4

@[mlir_transport]
theorem GlobalState.WF.storeCompleted {s : GlobalState} (h : s.WF) :
    ({ s with mem := s.mem.storeCompleted p P } : GlobalState).WF :=
  GlobalState.WF_storeCompleted.mpr h

/-- `WF.storeCompleted` for a state written as a constructor, which unifies first-order. -/
@[mlir_transport]
theorem GlobalState.WF.storeCompleted_mk {a : AllocState} (h : (⟨a, m⟩ : GlobalState).WF) :
    (⟨a, m.storeCompleted p P⟩ : GlobalState).WF :=
  GlobalState.WF.storeCompleted (s := ⟨a, m⟩) h

/-- A `CompletedPoint` stored where there is room is known. -/
@[mlir_fresh, mlir_mem]
theorem MemoryState.PointFit.storeCompleted_self (h : m.PointRoom p) :
    (m.storeCompleted p P).PointFit p :=
  PointFit.storeFe4_self h

@[mlir_read]
theorem MemoryState.readLimbs_storeCompleted_of_id_ne (h : p.id ≠ q.id) :
    (m.storeCompleted p P).readLimbs q = m.readLimbs q :=
  readLimbs_storeFe4_of_id_ne h

@[mlir_read]
theorem MemoryState.readAt_storeCompleted_of_id_ne (h : p.id ≠ q.id) :
    (m.storeCompleted p P).readAt q w = m.readAt q w :=
  readAt_storeFe4_of_id_ne h

@[mlir_read]
theorem MemoryState.readLimbs_storeCompleted_X (h : m.PointRoom p) :
    (m.storeCompleted p P).readLimbs p = P.X :=
  readLimbs_storeFe4_0 h

@[mlir_read]
theorem MemoryState.readLimbs_storeCompleted_Y (h : m.PointRoom p) :
    (m.storeCompleted p P).readLimbs (p.add 40#64) = P.Y :=
  readLimbs_storeFe4_1 h

@[mlir_read]
theorem MemoryState.readLimbs_storeCompleted_Z (h : m.PointRoom p) :
    (m.storeCompleted p P).readLimbs (p.add 80#64) = P.Z :=
  readLimbs_storeFe4_2 h

@[mlir_read]
theorem MemoryState.readLimbs_storeCompleted_T (h : m.PointRoom p) :
    (m.storeCompleted p P).readLimbs (p.add 120#64) = P.T :=
  readLimbs_storeFe4_3 h

@[mlir_frame, mlir_erase]
theorem MemoryState.eraseFrom_storeCompleted :
    (m.storeCompleted p P).eraseFrom n = (m.eraseFrom n).storeCompleted p P :=
  eraseFrom_storeFe4

@[mlir_frame, mlir_erase]
theorem MemoryState.storeCompleted_eraseFrom_of_le (h : n ≤ p.id.id) :
    (m.eraseFrom n).storeCompleted p P = m.eraseFrom n :=
  storeFe4_eraseFrom_of_le h

/-- A store into an erased block: dropped before the erase moves inward. -/
@[mlir_erase high]
theorem MemoryState.eraseFrom_storeCompleted_of_le (h : n ≤ p.id.id) :
    (m.storeCompleted p P).eraseFrom n = m.eraseFrom n := by
  rw [eraseFrom_storeCompleted, storeCompleted_eraseFrom_of_le h]

end Completed

/-! ### `ProjectiveNielsPoint` stores -/

section Niels

variable {m : MemoryState} {p q : Pointer} {P : Agave.ProjectiveNielsPoint}

@[mlir_transport]
theorem Fits.storeNiels (h : Fits m q w) : Fits (m.storeNiels p P) q w :=
  h.storeFe4

@[mlir_transport]
theorem Room.storeNiels (h : Room m q w) : Room (m.storeNiels p P) q w :=
  h.storeFe4

@[mlir_transport]
theorem InBounds.storeNiels (h : InBounds m q w) : InBounds (m.storeNiels p P) q w :=
  h.storeFe4

@[mlir_mem, mlir_transport]
theorem MemoryState.LimbsFit.storeNiels (h : m.LimbsFit q) : (m.storeNiels p P).LimbsFit q :=
  h.storeFe4

@[mlir_mem, mlir_transport]
theorem MemoryState.LimbsRoom.storeNiels (h : m.LimbsRoom q) : (m.storeNiels p P).LimbsRoom q :=
  h.storeFe4

@[mlir_mem, mlir_transport]
theorem MemoryState.PointFit.storeNiels (h : m.PointFit q) : (m.storeNiels p P).PointFit q :=
  h.storeFe4

@[mlir_mem, mlir_transport]
theorem MemoryState.PointRoom.storeNiels (h : m.PointRoom q) : (m.storeNiels p P).PointRoom q :=
  h.storeFe4

@[mlir_mem, mlir_transport]
theorem MemoryState.ProjectiveFit.storeNiels (h : m.ProjectiveFit q) :
    (m.storeNiels p P).ProjectiveFit q :=
  h.storeFe4

@[mlir_mem, mlir_transport]
theorem MemoryState.ProjectiveRoom.storeNiels (h : m.ProjectiveRoom q) :
    (m.storeNiels p P).ProjectiveRoom q :=
  h.storeFe4

@[simp, mlir_state]
theorem MemoryState.limbsRoom_storeNiels_iff : (m.storeNiels p P).LimbsRoom q ↔ m.LimbsRoom q :=
  limbsRoom_storeFe4_iff

theorem MemoryState.PointRoom.of_storeNiels (h : (m.storeNiels p P).PointRoom q) : m.PointRoom q :=
  ⟨h.1, limbsRoom_storeNiels_iff.mp h.2.1, limbsRoom_storeNiels_iff.mp h.2.2.1,
    limbsRoom_storeNiels_iff.mp h.2.2.2.1, limbsRoom_storeNiels_iff.mp h.2.2.2.2⟩

theorem MemoryState.ProjectiveRoom.of_storeNiels (h : (m.storeNiels p P).ProjectiveRoom q) :
    m.ProjectiveRoom q :=
  ⟨h.1, limbsRoom_storeNiels_iff.mp h.2.1, limbsRoom_storeNiels_iff.mp h.2.2.1,
    limbsRoom_storeNiels_iff.mp h.2.2.2⟩

@[simp, mlir_mem]
theorem GlobalState.WF_storeNiels {s : GlobalState} :
    ({ s with mem := m.storeNiels p P } : GlobalState).WF ↔
      ({ s with mem := m } : GlobalState).WF :=
  WF_storeFe4

@[mlir_transport]
theorem GlobalState.WF.storeNiels {s : GlobalState} (h : s.WF) :
    ({ s with mem := s.mem.storeNiels p P } : GlobalState).WF :=
  GlobalState.WF_storeNiels.mpr h

/-- `WF.storeNiels` for a state written as a constructor, which unifies first-order. -/
@[mlir_transport]
theorem GlobalState.WF.storeNiels_mk {a : AllocState} (h : (⟨a, m⟩ : GlobalState).WF) :
    (⟨a, m.storeNiels p P⟩ : GlobalState).WF :=
  GlobalState.WF.storeNiels (s := ⟨a, m⟩) h

/-- A `ProjectiveNielsPoint` stored where there is room is known. -/
@[mlir_fresh, mlir_mem]
theorem MemoryState.PointFit.storeNiels_self (h : m.PointRoom p) : (m.storeNiels p P).PointFit p :=
  PointFit.storeFe4_self h

@[mlir_read]
theorem MemoryState.readLimbs_storeNiels_of_id_ne (h : p.id ≠ q.id) :
    (m.storeNiels p P).readLimbs q = m.readLimbs q :=
  readLimbs_storeFe4_of_id_ne h

@[mlir_read]
theorem MemoryState.readAt_storeNiels_of_id_ne (h : p.id ≠ q.id) :
    (m.storeNiels p P).readAt q w = m.readAt q w :=
  readAt_storeFe4_of_id_ne h

@[mlir_read]
theorem MemoryState.readLimbs_storeNiels_Y_plus_X (h : m.PointRoom p) :
    (m.storeNiels p P).readLimbs p = P.Y_plus_X :=
  readLimbs_storeFe4_0 h

@[mlir_read]
theorem MemoryState.readLimbs_storeNiels_Y_minus_X (h : m.PointRoom p) :
    (m.storeNiels p P).readLimbs (p.add 40#64) = P.Y_minus_X :=
  readLimbs_storeFe4_1 h

@[mlir_read]
theorem MemoryState.readLimbs_storeNiels_Z (h : m.PointRoom p) :
    (m.storeNiels p P).readLimbs (p.add 80#64) = P.Z :=
  readLimbs_storeFe4_2 h

@[mlir_read]
theorem MemoryState.readLimbs_storeNiels_T2d (h : m.PointRoom p) :
    (m.storeNiels p P).readLimbs (p.add 120#64) = P.T2d :=
  readLimbs_storeFe4_3 h

@[mlir_frame, mlir_erase]
theorem MemoryState.eraseFrom_storeNiels :
    (m.storeNiels p P).eraseFrom n = (m.eraseFrom n).storeNiels p P :=
  eraseFrom_storeFe4

@[mlir_frame, mlir_erase]
theorem MemoryState.storeNiels_eraseFrom_of_le (h : n ≤ p.id.id) :
    (m.eraseFrom n).storeNiels p P = m.eraseFrom n :=
  storeFe4_eraseFrom_of_le h

/-- A store into an erased block: dropped before the erase moves inward. -/
@[mlir_erase high]
theorem MemoryState.eraseFrom_storeNiels_of_le (h : n ≤ p.id.id) :
    (m.storeNiels p P).eraseFrom n = m.eraseFrom n := by
  rw [eraseFrom_storeNiels, storeNiels_eraseFrom_of_le h]

end Niels

/-! ### `EdwardsPoint` reads -/

section ReadEdwards

variable {m : MemoryState} {p q : Pointer}

@[mlir_read]
theorem MemoryState.readEdwards_storeEdwards_self {P : Agave.EdwardsPoint} (h : m.PointRoom p) :
    (m.storeEdwards p P).readEdwards p = P := by
  rw [MemoryState.readEdwards, readLimbs_storeEdwards_X h, readLimbs_storeEdwards_Y h,
    readLimbs_storeEdwards_Z h, readLimbs_storeEdwards_T h]

@[mlir_read]
theorem MemoryState.readEdwards_storeEdwards_of_id_ne {P : Agave.EdwardsPoint} (h : p.id ≠ q.id) :
    (m.storeEdwards p P).readEdwards q = m.readEdwards q := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readEdwards, readLimbs_storeEdwards_of_id_ne h,
    readLimbs_storeEdwards_of_id_ne (h' _)]

@[mlir_read]
theorem MemoryState.readEdwards_storeProjective_of_id_ne {P : Agave.ProjectivePoint}
    (h : p.id ≠ q.id) : (m.storeProjective p P).readEdwards q = m.readEdwards q := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readEdwards, readLimbs_storeProjective_of_id_ne h,
    readLimbs_storeProjective_of_id_ne (h' _)]

@[mlir_read]
theorem MemoryState.readEdwards_storeCompleted_of_id_ne {P : Agave.CompletedPoint}
    (h : p.id ≠ q.id) : (m.storeCompleted p P).readEdwards q = m.readEdwards q := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readEdwards, readLimbs_storeCompleted_of_id_ne h,
    readLimbs_storeCompleted_of_id_ne (h' _)]

@[mlir_read]
theorem MemoryState.readEdwards_storeNiels_of_id_ne {P : Agave.ProjectiveNielsPoint}
    (h : p.id ≠ q.id) : (m.storeNiels p P).readEdwards q = m.readEdwards q := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readEdwards, readLimbs_storeNiels_of_id_ne h,
    readLimbs_storeNiels_of_id_ne (h' _)]

@[mlir_read]
theorem MemoryState.readEdwards_storeLimbs_of_id_ne (h : p.id ≠ q.id) :
    (m.storeLimbs p l).readEdwards q = m.readEdwards q := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readEdwards, readLimbs_storeLimbs_of_id_ne h,
    readLimbs_storeLimbs_of_id_ne (h' _)]

@[mlir_read]
theorem MemoryState.readEdwards_storeAt_of_id_ne {x : BitVec w} (h : p.id ≠ q.id) :
    (m.storeAt p x).readEdwards q = m.readEdwards q := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readEdwards, Agave.readLimbs_storeAt_of_id_ne h,
    Agave.readLimbs_storeAt_of_id_ne (h' _)]

/-- An `EdwardsPoint` elsewhere is unaffected by `alloca`. -/
@[mlir_frame, mlir_read]
theorem MemoryState.readEdwards_alloca {s : GlobalState} (hne : p.id ≠ s.allocaPtr.id) :
    (s.alloca n d).mem.readEdwards p = s.mem.readEdwards p := by
  have hne' (k : BitVec 64) : (p.add k).id ≠ s.allocaPtr.id := by simpa [Pointer.add_id] using hne
  simp only [MemoryState.readEdwards, readLimbs_alloca hne, readLimbs_alloca (hne' _)]

@[mlir_read]
theorem MemoryState.readEdwards_lifetimeStart :
    (m.lifetimeStart q).readEdwards p = m.readEdwards p := by
  simp only [MemoryState.readEdwards, readLimbs_lifetimeStart]

@[mlir_read]
theorem MemoryState.readEdwards_lifetimeEnd :
    (m.lifetimeEnd q).readEdwards p = m.readEdwards p := by
  simp only [MemoryState.readEdwards, readLimbs_lifetimeEnd]

@[mlir_read]
theorem MemoryState.readEdwards_addBlock_of_id_ne {x : BitVec v} (h : p.id ≠ b) :
    (m.addBlock b n x).readEdwards p = m.readEdwards p := by
  have h' (k : BitVec 64) : (p.add k).id ≠ b := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readEdwards, readLimbs_addBlock_of_id_ne h,
    readLimbs_addBlock_of_id_ne (h' _)]

end ReadEdwards

/-! ### `ProjectivePoint` reads -/

section ReadProjective

variable {m : MemoryState} {p q : Pointer}

@[mlir_read]
theorem MemoryState.readProjective_storeProjective_self {P : Agave.ProjectivePoint}
    (h : m.ProjectiveRoom p) : (m.storeProjective p P).readProjective p = P := by
  rw [MemoryState.readProjective, readLimbs_storeProjective_X h, readLimbs_storeProjective_Y h,
    readLimbs_storeProjective_Z h]

@[mlir_read]
theorem MemoryState.readProjective_storeEdwards_of_id_ne {P : Agave.EdwardsPoint}
    (h : p.id ≠ q.id) : (m.storeEdwards p P).readProjective q = m.readProjective q := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readProjective, readLimbs_storeEdwards_of_id_ne h,
    readLimbs_storeEdwards_of_id_ne (h' _)]

@[mlir_read]
theorem MemoryState.readProjective_storeProjective_of_id_ne {P : Agave.ProjectivePoint}
    (h : p.id ≠ q.id) : (m.storeProjective p P).readProjective q = m.readProjective q := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readProjective, readLimbs_storeProjective_of_id_ne h,
    readLimbs_storeProjective_of_id_ne (h' _)]

@[mlir_read]
theorem MemoryState.readProjective_storeCompleted_of_id_ne {P : Agave.CompletedPoint}
    (h : p.id ≠ q.id) : (m.storeCompleted p P).readProjective q = m.readProjective q := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readProjective, readLimbs_storeCompleted_of_id_ne h,
    readLimbs_storeCompleted_of_id_ne (h' _)]

@[mlir_read]
theorem MemoryState.readProjective_storeNiels_of_id_ne {P : Agave.ProjectiveNielsPoint}
    (h : p.id ≠ q.id) : (m.storeNiels p P).readProjective q = m.readProjective q := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readProjective, readLimbs_storeNiels_of_id_ne h,
    readLimbs_storeNiels_of_id_ne (h' _)]

@[mlir_read]
theorem MemoryState.readProjective_storeLimbs_of_id_ne (h : p.id ≠ q.id) :
    (m.storeLimbs p l).readProjective q = m.readProjective q := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readProjective, readLimbs_storeLimbs_of_id_ne h,
    readLimbs_storeLimbs_of_id_ne (h' _)]

@[mlir_read]
theorem MemoryState.readProjective_storeAt_of_id_ne {x : BitVec w} (h : p.id ≠ q.id) :
    (m.storeAt p x).readProjective q = m.readProjective q := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readProjective, Agave.readLimbs_storeAt_of_id_ne h,
    Agave.readLimbs_storeAt_of_id_ne (h' _)]

/-- A `ProjectivePoint` elsewhere is unaffected by `alloca`. -/
@[mlir_frame, mlir_read]
theorem MemoryState.readProjective_alloca {s : GlobalState} (hne : p.id ≠ s.allocaPtr.id) :
    (s.alloca n d).mem.readProjective p = s.mem.readProjective p := by
  have hne' (k : BitVec 64) : (p.add k).id ≠ s.allocaPtr.id := by simpa [Pointer.add_id] using hne
  simp only [MemoryState.readProjective, readLimbs_alloca hne, readLimbs_alloca (hne' _)]

@[mlir_read]
theorem MemoryState.readProjective_lifetimeStart :
    (m.lifetimeStart q).readProjective p = m.readProjective p := by
  simp only [MemoryState.readProjective, readLimbs_lifetimeStart]

@[mlir_read]
theorem MemoryState.readProjective_lifetimeEnd :
    (m.lifetimeEnd q).readProjective p = m.readProjective p := by
  simp only [MemoryState.readProjective, readLimbs_lifetimeEnd]

@[mlir_read]
theorem MemoryState.readProjective_addBlock_of_id_ne {x : BitVec v} (h : p.id ≠ b) :
    (m.addBlock b n x).readProjective p = m.readProjective p := by
  have h' (k : BitVec 64) : (p.add k).id ≠ b := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readProjective, readLimbs_addBlock_of_id_ne h,
    readLimbs_addBlock_of_id_ne (h' _)]

end ReadProjective

/-! ### `CompletedPoint` reads -/

section ReadCompleted

variable {m : MemoryState} {p q : Pointer}

@[mlir_read]
theorem MemoryState.readCompleted_storeCompleted_self {P : Agave.CompletedPoint}
    (h : m.PointRoom p) : (m.storeCompleted p P).readCompleted p = P := by
  rw [MemoryState.readCompleted, readLimbs_storeCompleted_X h, readLimbs_storeCompleted_Y h,
    readLimbs_storeCompleted_Z h, readLimbs_storeCompleted_T h]

@[mlir_read]
theorem MemoryState.readCompleted_storeEdwards_of_id_ne {P : Agave.EdwardsPoint} (h : p.id ≠ q.id) :
    (m.storeEdwards p P).readCompleted q = m.readCompleted q := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readCompleted, readLimbs_storeEdwards_of_id_ne h,
    readLimbs_storeEdwards_of_id_ne (h' _)]

@[mlir_read]
theorem MemoryState.readCompleted_storeProjective_of_id_ne {P : Agave.ProjectivePoint}
    (h : p.id ≠ q.id) : (m.storeProjective p P).readCompleted q = m.readCompleted q := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readCompleted, readLimbs_storeProjective_of_id_ne h,
    readLimbs_storeProjective_of_id_ne (h' _)]

@[mlir_read]
theorem MemoryState.readCompleted_storeCompleted_of_id_ne {P : Agave.CompletedPoint}
    (h : p.id ≠ q.id) : (m.storeCompleted p P).readCompleted q = m.readCompleted q := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readCompleted, readLimbs_storeCompleted_of_id_ne h,
    readLimbs_storeCompleted_of_id_ne (h' _)]

@[mlir_read]
theorem MemoryState.readCompleted_storeNiels_of_id_ne {P : Agave.ProjectiveNielsPoint}
    (h : p.id ≠ q.id) : (m.storeNiels p P).readCompleted q = m.readCompleted q := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readCompleted, readLimbs_storeNiels_of_id_ne h,
    readLimbs_storeNiels_of_id_ne (h' _)]

@[mlir_read]
theorem MemoryState.readCompleted_storeLimbs_of_id_ne (h : p.id ≠ q.id) :
    (m.storeLimbs p l).readCompleted q = m.readCompleted q := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readCompleted, readLimbs_storeLimbs_of_id_ne h,
    readLimbs_storeLimbs_of_id_ne (h' _)]

@[mlir_read]
theorem MemoryState.readCompleted_storeAt_of_id_ne {x : BitVec w} (h : p.id ≠ q.id) :
    (m.storeAt p x).readCompleted q = m.readCompleted q := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readCompleted, Agave.readLimbs_storeAt_of_id_ne h,
    Agave.readLimbs_storeAt_of_id_ne (h' _)]

/-- A `CompletedPoint` elsewhere is unaffected by `alloca`. -/
@[mlir_frame, mlir_read]
theorem MemoryState.readCompleted_alloca {s : GlobalState} (hne : p.id ≠ s.allocaPtr.id) :
    (s.alloca n d).mem.readCompleted p = s.mem.readCompleted p := by
  have hne' (k : BitVec 64) : (p.add k).id ≠ s.allocaPtr.id := by simpa [Pointer.add_id] using hne
  simp only [MemoryState.readCompleted, readLimbs_alloca hne, readLimbs_alloca (hne' _)]

@[mlir_read]
theorem MemoryState.readCompleted_lifetimeStart :
    (m.lifetimeStart q).readCompleted p = m.readCompleted p := by
  simp only [MemoryState.readCompleted, readLimbs_lifetimeStart]

@[mlir_read]
theorem MemoryState.readCompleted_lifetimeEnd :
    (m.lifetimeEnd q).readCompleted p = m.readCompleted p := by
  simp only [MemoryState.readCompleted, readLimbs_lifetimeEnd]

@[mlir_read]
theorem MemoryState.readCompleted_addBlock_of_id_ne {x : BitVec v} (h : p.id ≠ b) :
    (m.addBlock b n x).readCompleted p = m.readCompleted p := by
  have h' (k : BitVec 64) : (p.add k).id ≠ b := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readCompleted, readLimbs_addBlock_of_id_ne h,
    readLimbs_addBlock_of_id_ne (h' _)]

end ReadCompleted

/-! ### `ProjectiveNielsPoint` reads -/

section ReadNiels

variable {m : MemoryState} {p q : Pointer}

@[mlir_read]
theorem MemoryState.readNiels_storeNiels_self {P : Agave.ProjectiveNielsPoint} (h : m.PointRoom p) :
    (m.storeNiels p P).readNiels p = P := by
  rw [MemoryState.readNiels, readLimbs_storeNiels_Y_plus_X h, readLimbs_storeNiels_Y_minus_X h,
    readLimbs_storeNiels_Z h, readLimbs_storeNiels_T2d h]

@[mlir_read]
theorem MemoryState.readNiels_storeEdwards_of_id_ne {P : Agave.EdwardsPoint} (h : p.id ≠ q.id) :
    (m.storeEdwards p P).readNiels q = m.readNiels q := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readNiels, readLimbs_storeEdwards_of_id_ne h,
    readLimbs_storeEdwards_of_id_ne (h' _)]

@[mlir_read]
theorem MemoryState.readNiels_storeProjective_of_id_ne {P : Agave.ProjectivePoint}
    (h : p.id ≠ q.id) : (m.storeProjective p P).readNiels q = m.readNiels q := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readNiels, readLimbs_storeProjective_of_id_ne h,
    readLimbs_storeProjective_of_id_ne (h' _)]

@[mlir_read]
theorem MemoryState.readNiels_storeCompleted_of_id_ne {P : Agave.CompletedPoint} (h : p.id ≠ q.id) :
    (m.storeCompleted p P).readNiels q = m.readNiels q := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readNiels, readLimbs_storeCompleted_of_id_ne h,
    readLimbs_storeCompleted_of_id_ne (h' _)]

@[mlir_read]
theorem MemoryState.readNiels_storeNiels_of_id_ne {P : Agave.ProjectiveNielsPoint}
    (h : p.id ≠ q.id) : (m.storeNiels p P).readNiels q = m.readNiels q := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readNiels, readLimbs_storeNiels_of_id_ne h,
    readLimbs_storeNiels_of_id_ne (h' _)]

@[mlir_read]
theorem MemoryState.readNiels_storeLimbs_of_id_ne (h : p.id ≠ q.id) :
    (m.storeLimbs p l).readNiels q = m.readNiels q := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readNiels, readLimbs_storeLimbs_of_id_ne h,
    readLimbs_storeLimbs_of_id_ne (h' _)]

@[mlir_read]
theorem MemoryState.readNiels_storeAt_of_id_ne {x : BitVec w} (h : p.id ≠ q.id) :
    (m.storeAt p x).readNiels q = m.readNiels q := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readNiels, Agave.readLimbs_storeAt_of_id_ne h,
    Agave.readLimbs_storeAt_of_id_ne (h' _)]

/-- A `ProjectiveNielsPoint` elsewhere is unaffected by `alloca`. -/
@[mlir_frame, mlir_read]
theorem MemoryState.readNiels_alloca {s : GlobalState} (hne : p.id ≠ s.allocaPtr.id) :
    (s.alloca n d).mem.readNiels p = s.mem.readNiels p := by
  have hne' (k : BitVec 64) : (p.add k).id ≠ s.allocaPtr.id := by simpa [Pointer.add_id] using hne
  simp only [MemoryState.readNiels, readLimbs_alloca hne, readLimbs_alloca (hne' _)]

@[mlir_read]
theorem MemoryState.readNiels_lifetimeStart : (m.lifetimeStart q).readNiels p = m.readNiels p := by
  simp only [MemoryState.readNiels, readLimbs_lifetimeStart]

@[mlir_read]
theorem MemoryState.readNiels_lifetimeEnd : (m.lifetimeEnd q).readNiels p = m.readNiels p := by
  simp only [MemoryState.readNiels, readLimbs_lifetimeEnd]

@[mlir_read]
theorem MemoryState.readNiels_addBlock_of_id_ne {x : BitVec v} (h : p.id ≠ b) :
    (m.addBlock b n x).readNiels p = m.readNiels p := by
  have h' (k : BitVec 64) : (p.add k).id ≠ b := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readNiels, readLimbs_addBlock_of_id_ne h,
    readLimbs_addBlock_of_id_ne (h' _)]

end ReadNiels

-- last among the transports: tried after the structural ones, which carry a `…Room` fact
-- directly, so they do not search the `…Fit` facts first
attribute [-mlir_transport] MemoryState.LimbsFit.room MemoryState.PointFit.room

attribute [mlir_transport] MemoryState.LimbsFit.room MemoryState.PointFit.room
  MemoryState.ProjectiveFit.room

end

end MLIR
