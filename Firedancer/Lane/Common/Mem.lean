module

public import Firedancer.Avx512.Common.Vec
public import Firedancer.Common.Point
public import Firedancer.Lane.Common.Point
import Firedancer.Common.Memory

/-! The lane objects in memory. An `fd_ed25519_lane_fe_t` is five 512-bit vectors at byte offsets
0, 64, 128, 192, 256; a point `x, y, z, t` is four of them at 0, 320, 640, 960; a table entry
`p, m, k, nk, z` five at 0, 320, 640, 960, 1280. An object's predicate is one `Fits`/`Room` of its
whole range and a no-wrap bound, from which the steps find each vector. -/

namespace MLIR

@[expose] public section

open Firedancer.Avx512 Firedancer.Lane

/-! ### Objects -/

/-- The field element at `p`. -/
def MemoryState.readFe (m : MemoryState) (p : Pointer) : Fe :=
  ⟨m.readVec p, m.readVec (p.add 64#64), m.readVec (p.add 128#64), m.readVec (p.add 192#64),
    m.readVec (p.add 256#64)⟩

/-- Store a field element at `p`, limb 0 first. -/
def MemoryState.storeFe (m : MemoryState) (p : Pointer) (a : Fe) : MemoryState :=
  ((((m.storeVec p a.l0).storeVec (p.add 64#64) a.l1).storeVec (p.add 128#64) a.l2).storeVec
        (p.add 192#64) a.l3).storeVec
    (p.add 256#64) a.l4

/-- The point at `p`. -/
def MemoryState.readLanePoint (m : MemoryState) (p : Pointer) : Point :=
  ⟨m.readFe p, m.readFe (p.add 320#64), m.readFe (p.add 640#64), m.readFe (p.add 960#64)⟩

/-- Store a point at `p` in the order the group operations do: `x`, `z`, `y`, `t`. -/
def MemoryState.storeLanePoint (m : MemoryState) (p : Pointer) (P : Point) : MemoryState :=
  (((m.storeFe p P.x).storeFe (p.add 640#64) P.z).storeFe (p.add 320#64) P.y).storeFe (p.add 960#64)
    P.t

/-- The table entry at `p`. -/
def MemoryState.readNiels (m : MemoryState) (p : Pointer) : Niels :=
  ⟨m.readFe p, m.readFe (p.add 320#64), m.readFe (p.add 640#64), m.readFe (p.add 960#64),
    m.readFe (p.add 1280#64)⟩

/-- The field element at `p` fits: its offsets do not wrap, and its 320 bytes are known. -/
abbrev MemoryState.FeFit (m : MemoryState) (p : Pointer) : Prop :=
  ¬p.offset.uaddOverflow 320#64 ∧ Fits m p 2560

/-- Room for a field element at `p` (an output), and its offsets do not wrap. -/
abbrev MemoryState.FeRoom (m : MemoryState) (p : Pointer) : Prop :=
  ¬p.offset.uaddOverflow 320#64 ∧ Room m p 2560

/-- The point at `p` fits: its offsets do not wrap, and its 1280 bytes are known. -/
abbrev MemoryState.LanePointFit (m : MemoryState) (p : Pointer) : Prop :=
  ¬p.offset.uaddOverflow 1280#64 ∧ Fits m p 10240

/-- Room for a point at `p` (an output), and its offsets do not wrap. -/
abbrev MemoryState.LanePointRoom (m : MemoryState) (p : Pointer) : Prop :=
  ¬p.offset.uaddOverflow 1280#64 ∧ Room m p 10240

/-- The table entry at `p` fits: its offsets do not wrap, and its 1600 bytes are known. -/
abbrev MemoryState.NielsFit (m : MemoryState) (p : Pointer) : Prop :=
  ¬p.offset.uaddOverflow 1600#64 ∧ Fits m p 12800

attribute [mlir_mem] MemoryState.FeFit MemoryState.FeRoom MemoryState.LanePointFit
  MemoryState.LanePointRoom MemoryState.NielsFit

/-! ### Offsets inside an object -/

/-- `p.add a` and `p.add b` address disjoint ranges when neither offset wraps and they are apart. -/
theorem Range.disjoint_of_add {p : Pointer} {a b : BitVec 64} (ha : ¬p.offset.uaddOverflow a)
    (hb : ¬p.offset.uaddOverflow b)
    (h : a.toNat * 8 + v ≤ b.toNat * 8 ∨ b.toNat * 8 + w ≤ a.toNat * 8) :
    (Range.of (p.add a) v).Disjoint (Range.of (p.add b) w) := by
  simp only [Range.Disjoint, Range.of, Pointer.offsetInBits_add ha, Pointer.offsetInBits_add hb]
  omega

/-- `Range.disjoint_of_add` with offsets below a bound that does not wrap. -/
theorem Range.disjoint_of_add_le {p : Pointer} {a b c : BitVec 64} (hc : ¬p.offset.uaddOverflow c)
    (ha : a.toNat ≤ c.toNat) (hb : b.toNat ≤ c.toNat)
    (h : a.toNat * 8 + v ≤ b.toNat * 8 ∨ b.toNat * 8 + w ≤ a.toNat * 8) :
    (Range.of (p.add a) v).Disjoint (Range.of (p.add b) w) :=
  Range.disjoint_of_add (BitVec.not_uaddOverflow_of_le hc ha) (BitVec.not_uaddOverflow_of_le hc hb)
    h

/-- Lanes past a store to a disjoint range. -/
theorem MemoryState.readVec_storeVec_disjoint {m : MemoryState}
    (h : (Range.of p 512).Disjoint (Range.of q 512)) :
    (m.storeVec p v).readVec q = m.readVec q := by rw [readVec, readVec, readAt_storeVec_disjoint h]

/-- Lanes stored twice at the same place: the second. -/
theorem MemoryState.storeVec_storeVec_self {m : MemoryState} :
    (m.storeVec p v).storeVec p v' = m.storeVec p v' :=
  storeAt_storeAt_self

/-- Lanes stored at disjoint places: the stores commute. -/
theorem MemoryState.storeVec_comm {m : MemoryState}
    (h : (Range.of p 512).Disjoint (Range.of q 512)) :
    (m.storeVec p v).storeVec q u = (m.storeVec q u).storeVec p v :=
  storeAt_comm h

/-- Eight 64-bit lanes of a 512-bit value, packed: the value. -/
theorem BitVec.packLanes_extractVecElem8 (x : BitVec 512) :
    BitVec.packLanes (Vector.ofFn fun i : Fin 8 => Ty.extractVecElem 8 64 i x) = x := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  have h :=
    BitVec.extractLsb'_packLanes (Vector.ofFn fun i : Fin 8 => Ty.extractVecElem 8 64 i x) (i / 64)
      (by omega)
  have hb := congrArg (fun y => y.getLsbD (i % 64)) h
  simp only [BitVec.getLsbD_extractLsb', show i % 64 < 64 by omega, decide_true, Bool.true_and,
    show i / 64 * 64 + i % 64 = i by omega] at hb
  rw [hb, Vector.getElem_ofFn, Ty.extractVecElem_eq, BitVec.getLsbD_extractLsb']
  simp only [show i % 64 < 64 by omega, decide_true, Bool.true_and]
  congr 1
  omega

/-- Storing the lanes a vector holds changes nothing. -/
theorem MemoryState.storeVec_readVec_self' {m : MemoryState} (h : Fits m p 512) :
    m.storeVec p (m.readVec p) = m := by
  rw [MemoryState.storeVec, MemoryState.readVec, BitVec.packLanes_extractVecElem8,
    MemoryState.storeAt_readAt_self h]

/-- A load of a `<8 x i64>` as the steps give it: `readVec`. -/
theorem MemoryState.ofFn_extractVecElem_readAt {m : MemoryState} :
    (Vector.ofFn fun i => Ty.extractVecElem 8 64 i (m.readAt p 512)) = m.readVec p :=
  rfl

/-- `toNat` of an offset plus a literal, below `2 ^ 64`. -/
theorem BitVec.toNat_add_lit {a : BitVec 64} {k : Nat} (h : a.toNat + k < 2 ^ 64)
    (hk : k < 2 ^ 64) : (a + BitVec.ofNat 64 k).toNat = a.toNat + k := by
  rw [BitVec.toNat_add, BitVec.toNat_ofNat, Nat.mod_eq_of_lt hk, Nat.mod_eq_of_lt h]

/-- Lanes at `p.add b` past lanes stored at `p.add a`, both inside a range from `p` that does not
wrap, apart. -/
theorem MemoryState.readVec_storeVec_apart {m : MemoryState} {p : Pointer} {a b c : BitVec 64}
    (hc : ¬p.offset.uaddOverflow c) (ha : a.toNat + 64 ≤ c.toNat) (hb : b.toNat + 64 ≤ c.toNat)
    (hab : a.toNat + 64 ≤ b.toNat ∨ b.toNat + 64 ≤ a.toNat) :
    (m.storeVec (p.add a) v).readVec (p.add b) = m.readVec (p.add b) :=
  readVec_storeVec_disjoint (Range.disjoint_of_add_le hc (by omega) (by omega) (by omega))

/-- `readVec_storeVec_apart` for a read at `p`. -/
theorem MemoryState.readVec_storeVec_apart_base {m : MemoryState} {p : Pointer} {a c : BitVec 64}
    (hc : ¬p.offset.uaddOverflow c) (ha : a.toNat + 64 ≤ c.toNat) (h64 : 64 ≤ a.toNat) :
    (m.storeVec (p.add a) v).readVec p = m.readVec p := by
  simpa using
    readVec_storeVec_apart (b := 0#64) (v := v) (m := m) hc ha
      (by
        simp; omega)
      (by
        simp; omega)

/-- `readVec_storeVec_apart` for a store at `p`. -/
theorem MemoryState.readVec_storeVec_base_apart {m : MemoryState} {p : Pointer} {b c : BitVec 64}
    (hc : ¬p.offset.uaddOverflow c) (hb : b.toNat + 64 ≤ c.toNat) (h64 : 64 ≤ b.toNat) :
    (m.storeVec p v).readVec (p.add b) = m.readVec (p.add b) := by
  simpa using
    readVec_storeVec_apart (a := 0#64) (v := v) (m := m) hc
      (by
        simp; omega)
      hb
      (by
        simp; omega)

/-! ### Field elements -/

section Fe

variable {m : MemoryState} {p q : Pointer} {a : Fe}

/-- The no-wrap bound of an object, for an offset inside it. -/
theorem not_uaddOverflow_le {p : Pointer} {c : BitVec 64} (h : ¬p.offset.uaddOverflow c)
    (o : BitVec 64) (ho : o.toNat ≤ c.toNat) : ¬p.offset.uaddOverflow o :=
  BitVec.not_uaddOverflow_of_le h ho

/-- An object inside a range that does not wrap does not wrap either. -/
theorem not_uaddOverflow_add {p : Pointer} {c o k : BitVec 64} (h : ¬p.offset.uaddOverflow c)
    (hk : o.toNat + k.toNat ≤ c.toNat) : ¬(p.add o).offset.uaddOverflow k := by
  have := c.isLt
  rw [show (p.add o).offset = p.offset + o from rfl]
  simp only [BitVec.uaddOverflow, BitVec.toNat_add, ge_iff_le, decide_eq_true_eq,
    Nat.reducePow] at h ⊢
  omega

theorem MemoryState.FeFit.fits (h : m.FeFit p) : Fits m p 2560 :=
  h.2

theorem MemoryState.FeRoom.room (h : m.FeRoom p) : Room m p 2560 :=
  h.2

/-- A field element known in a writable block has room. -/
theorem MemoryState.FeFit.feRoom (h : m.FeFit p) (hw : Writable m p) : m.FeRoom p :=
  ⟨h.1, h.2.room hw⟩

@[simp, mlir_state]
theorem Room.storeFe_iff : Room (m.storeFe q a) p w ↔ Room m p w := by
  simp [MemoryState.storeFe, MemoryState.storeVec]

@[simp, mlir_state]
theorem InBounds.storeFe_iff : InBounds (m.storeFe q a) p w ↔ InBounds m p w := by
  simp [MemoryState.storeFe, MemoryState.storeVec]

@[mlir_mem, mlir_transport]
theorem Fits.storeFe (h : Fits m p w) : Fits (m.storeFe q a) p w :=
  h.storeVec.storeVec.storeVec.storeVec.storeVec

@[mlir_mem, mlir_transport]
theorem Room.storeFe (h : Room m p w) : Room (m.storeFe q a) p w :=
  Room.storeFe_iff.mpr h

@[mlir_mem, mlir_transport]
theorem InBounds.storeFe (h : InBounds m p w) : InBounds (m.storeFe q a) p w :=
  InBounds.storeFe_iff.mpr h

@[mlir_mem, mlir_transport]
theorem Writable.storeFe (h : Writable m p) : Writable (m.storeFe q a) p :=
  h.storeAt.storeAt.storeAt.storeAt.storeAt

@[simp, mlir_mem]
theorem GlobalState.WF_storeFe {s : GlobalState} :
    ({ s with mem := m.storeFe p a } : GlobalState).WF ↔
      ({ s with mem := m } : GlobalState).WF := by
  simp [MemoryState.storeFe, MemoryState.storeVec]

@[mlir_transport]
theorem GlobalState.WF.storeFe {s : GlobalState} (h : s.WF) :
    ({ s with mem := s.mem.storeFe p a } : GlobalState).WF :=
  GlobalState.WF_storeFe.mpr h

@[mlir_transport]
theorem GlobalState.WF.storeFe_mk {al : AllocState} (h : (⟨al, m⟩ : GlobalState).WF) :
    (⟨al, m.storeFe p a⟩ : GlobalState).WF :=
  GlobalState.WF.storeFe (s := ⟨al, m⟩) h

@[mlir_mem, mlir_transport]
theorem MemoryState.FeFit.storeAt {x : BitVec w} (h : m.FeFit p) : (m.storeAt q x).FeFit p :=
  ⟨h.1, h.2.storeAt⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.FeFit.storeVec (h : m.FeFit p) : (m.storeVec q v).FeFit p :=
  ⟨h.1, h.2.storeVec⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.FeFit.storeFe (h : m.FeFit p) : (m.storeFe q a).FeFit p :=
  ⟨h.1, h.2.storeFe⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.FeRoom.storeAt {x : BitVec w} (h : m.FeRoom p) : (m.storeAt q x).FeRoom p :=
  ⟨h.1, h.2.storeAt⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.FeRoom.storeVec (h : m.FeRoom p) : (m.storeVec q v).FeRoom p :=
  ⟨h.1, h.2.storeVec⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.FeRoom.storeFe (h : m.FeRoom p) : (m.storeFe q a).FeRoom p :=
  ⟨h.1, h.2.storeFe⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.FeFit.alloca {s : GlobalState} (hwf : s.WF) (h : s.mem.FeFit p) :
    (s.alloca n d).mem.FeFit p :=
  ⟨h.1, h.2.alloca hwf⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.FeRoom.alloca {s : GlobalState} (hwf : s.WF) (h : s.mem.FeRoom p) :
    (s.alloca n d).mem.FeRoom p :=
  ⟨h.1, h.2.alloca hwf⟩

@[mlir_transport]
theorem MemoryState.FeFit.addBlock {s : GlobalState} {x : BitVec v} (hwf : s.WF)
    (h : s.mem.FeFit p) : (s.mem.addBlock ⟨s.alloc.nextFreeBlock⟩ n x).FeFit p :=
  ⟨h.1, h.2.addBlock hwf⟩

@[mlir_transport]
theorem MemoryState.FeRoom.addBlock {s : GlobalState} {x : BitVec v} (hwf : s.WF)
    (h : s.mem.FeRoom p) : (s.mem.addBlock ⟨s.alloc.nextFreeBlock⟩ n x).FeRoom p :=
  ⟨h.1, h.2.addBlock hwf⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.FeFit.lifetimeStart (h : m.FeFit p) (hne : p.id ≠ q.id) :
    (m.lifetimeStart q).FeFit p :=
  ⟨h.1, h.2.lifetimeStart hne⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.FeFit.lifetimeEnd (h : m.FeFit p) (hne : p.id ≠ q.id) :
    (m.lifetimeEnd q).FeFit p :=
  ⟨h.1, h.2.lifetimeEnd hne⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.FeRoom.lifetimeStart (h : m.FeRoom p) (hne : p.id ≠ q.id) :
    (m.lifetimeStart q).FeRoom p :=
  ⟨h.1, h.2.lifetimeStart hne⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.FeRoom.lifetimeEnd (h : m.FeRoom p) (hne : p.id ≠ q.id) :
    (m.lifetimeEnd q).FeRoom p :=
  ⟨h.1, h.2.lifetimeEnd hne⟩

/-- The limbs of a field element's range fit. -/
theorem MemoryState.FeFit.fits_limb (h : m.FeFit p) (o : BitVec 64)
    (ho : o.toNat ≤ 256 := by decide) : Fits m (p.add o) 512 :=
  h.2.add_of_le (not_uaddOverflow_le h.1 o (Nat.le_trans ho (by decide))) (by omega)

/-- `fits_limb` at limb 0. -/
theorem MemoryState.FeFit.fits_limb0 (h : m.FeFit p) : Fits m p 512 :=
  h.2.mono (by decide)

theorem MemoryState.FeRoom.room_limb (h : m.FeRoom p) (o : BitVec 64)
    (ho : o.toNat ≤ 256 := by decide) : Room m (p.add o) 512 :=
  h.2.add_of_le (not_uaddOverflow_le h.1 o (Nat.le_trans ho (by decide))) (by omega)

theorem MemoryState.FeRoom.room_limb0 (h : m.FeRoom p) : Room m p 512 :=
  h.2.mono (by decide)

/-- Two limbs of one field element are disjoint. -/
theorem MemoryState.FeRoom.disjoint (h : m.FeRoom p) (a b : BitVec 64) (ha : a.toNat ≤ 256)
    (hb : b.toNat ≤ 256) (hab : a.toNat + 64 ≤ b.toNat ∨ b.toNat + 64 ≤ a.toNat) :
    (Range.of (p.add a) 512).Disjoint (Range.of (p.add b) 512) :=
  Range.disjoint_of_add_le h.1 (Nat.le_trans ha (by decide)) (Nat.le_trans hb (by decide))
    (by omega)

/-- A field element stored where there is room reads back. -/
@[mlir_read]
theorem MemoryState.readFe_storeFe_self (h : m.FeRoom p) : (m.storeFe p a).readFe p = a := by
  have d (a b : BitVec 64) (ha : a.toNat ≤ 256 := by decide) (hb : b.toNat ≤ 256 := by decide)
    (hab : a.toNat + 64 ≤ b.toNat ∨ b.toNat + 64 ≤ a.toNat := by decide) := h.disjoint a b ha hb hab
  have d0 (b : BitVec 64) (hb : b.toNat ≤ 256 := by decide) (h64 : 64 ≤ b.toNat := by decide) :
    (Range.of p 512).Disjoint (Range.of (p.add b) 512) := by
    simpa using
      h.disjoint 0#64 b (by decide) hb
        (by
          simp; omega)
  rcases a with ⟨a0, a1, a2, a3, a4⟩
  simp only [readFe, storeFe]
  congr 1
  · rw [readVec_storeVec_disjoint (d0 256#64).symm, readVec_storeVec_disjoint (d0 192#64).symm,
      readVec_storeVec_disjoint (d0 128#64).symm, readVec_storeVec_disjoint (d0 64#64).symm,
      readVec_storeVec_self h.room_limb0]
  · rw [readVec_storeVec_disjoint (d 256#64 64#64), readVec_storeVec_disjoint (d 192#64 64#64),
      readVec_storeVec_disjoint (d 128#64 64#64),
      readVec_storeVec_self (h.room_limb 64#64).storeVec]
  · rw [readVec_storeVec_disjoint (d 256#64 128#64), readVec_storeVec_disjoint (d 192#64 128#64),
      readVec_storeVec_self (h.room_limb 128#64).storeVec.storeVec]
  · rw [readVec_storeVec_disjoint (d 256#64 192#64),
      readVec_storeVec_self (h.room_limb 192#64).storeVec.storeVec.storeVec]
  · rw [readVec_storeVec_self (h.room_limb 256#64).storeVec.storeVec.storeVec.storeVec]

/-- A field element at `p.add b` past one stored at `p.add a`, both inside a range from `p` that
does not wrap, apart. -/
theorem MemoryState.readFe_storeFe_apart {a b c : BitVec 64} (hc : ¬p.offset.uaddOverflow c)
    (ha : a.toNat + 320 ≤ c.toNat) (hb : b.toNat + 320 ≤ c.toNat)
    (hab : a.toNat + 320 ≤ b.toNat ∨ b.toNat + 320 ≤ a.toNat) :
    (m.storeFe (p.add a) x).readFe (p.add b) = m.readFe (p.add b) := by
  have := a.isLt
  have := b.isLt
  have := c.isLt
  simp only [readFe, storeFe, Pointer.add_add]
  simp (disch :=
    ((try simp only [BitVec.toNat_add, BitVec.toNat_ofNat, Nat.reducePow, Nat.reduceMod]);
     omega)) only [readVec_storeVec_apart hc]

/-- `readFe_storeFe_apart` for a read at `p`. -/
theorem MemoryState.readFe_storeFe_apart_base {a c : BitVec 64} (hc : ¬p.offset.uaddOverflow c)
    (ha : a.toNat + 320 ≤ c.toNat) (h : 320 ≤ a.toNat) :
    (m.storeFe (p.add a) x).readFe p = m.readFe p := by
  simpa using
    readFe_storeFe_apart (b := 0#64) (x := x) (m := m) hc ha
      (by
        simp; omega)
      (by
        simp; omega)

/-- `readFe_storeFe_apart` for a store at `p`. -/
theorem MemoryState.readFe_storeFe_base_apart {b c : BitVec 64} (hc : ¬p.offset.uaddOverflow c)
    (hb : b.toNat + 320 ≤ c.toNat) (h : 320 ≤ b.toNat) :
    (m.storeFe p x).readFe (p.add b) = m.readFe (p.add b) := by
  simpa using
    readFe_storeFe_apart (a := 0#64) (x := x) (m := m) hc
      (by
        simp; omega)
      hb
      (by
        simp; omega)

/-- A framed callee's state over a field element store keeps `WF`. -/
@[mlir_transport]
theorem GlobalState.WF.add_blocks_storeFe {s : GlobalState} (h : s.WF) :
    (⟨⟨s.alloc.nextFreeBlock + k⟩, s.mem.storeFe p a⟩ : GlobalState).WF :=
  GlobalState.WF.storeFe (s := ⟨⟨s.alloc.nextFreeBlock + k⟩, s.mem⟩) h.add_blocks

/-- Limb 0 of a stored field element, as a load reads it. -/
@[mlir_read]
theorem MemoryState.readAt_storeFe_l0 (hov : ¬p.offset.uaddOverflow 320#64) (hr : Room m p 2560) :
    (m.storeFe p a).readAt p 512 = BitVec.packLanes a.l0 := by
  have h : m.FeRoom p := ⟨hov, hr⟩
  have d0 (b : BitVec 64) (hb : b.toNat ≤ 256 := by decide) (h64 : 64 ≤ b.toNat := by decide) :
    (Range.of (p.add b) 512).Disjoint (Range.of p 512) := by
    simpa using
      h.disjoint b 0#64 hb (by decide)
        (by
          simp; omega)
  simp only [storeFe, storeVec, readAt_storeAt_disjoint (d0 256#64),
    readAt_storeAt_disjoint (d0 192#64), readAt_storeAt_disjoint (d0 128#64),
    readAt_storeAt_disjoint (d0 64#64), readAt_storeAt_self h.room_limb0]

/-- Limb 1 of a stored field element, as a load reads it. -/
@[mlir_read]
theorem MemoryState.readAt_storeFe_l1 (hov : ¬p.offset.uaddOverflow 320#64) (hr : Room m p 2560) :
    (m.storeFe p a).readAt (p.add 64#64) 512 = BitVec.packLanes a.l1 := by
  have h : m.FeRoom p := ⟨hov, hr⟩
  simp only [storeFe, storeVec,
    readAt_storeAt_disjoint (h.disjoint 256#64 64#64 (by decide) (by decide) (by decide)),
    readAt_storeAt_disjoint (h.disjoint 192#64 64#64 (by decide) (by decide) (by decide)),
    readAt_storeAt_disjoint (h.disjoint 128#64 64#64 (by decide) (by decide) (by decide)),
    readAt_storeAt_self (h.room_limb 64#64).storeAt]

/-- Limb 2 of a stored field element, as a load reads it. -/
@[mlir_read]
theorem MemoryState.readAt_storeFe_l2 (hov : ¬p.offset.uaddOverflow 320#64) (hr : Room m p 2560) :
    (m.storeFe p a).readAt (p.add 128#64) 512 = BitVec.packLanes a.l2 := by
  have h : m.FeRoom p := ⟨hov, hr⟩
  simp only [storeFe, storeVec,
    readAt_storeAt_disjoint (h.disjoint 256#64 128#64 (by decide) (by decide) (by decide)),
    readAt_storeAt_disjoint (h.disjoint 192#64 128#64 (by decide) (by decide) (by decide)),
    readAt_storeAt_self (h.room_limb 128#64).storeAt.storeAt]

/-- Limb 3 of a stored field element, as a load reads it. -/
@[mlir_read]
theorem MemoryState.readAt_storeFe_l3 (hov : ¬p.offset.uaddOverflow 320#64) (hr : Room m p 2560) :
    (m.storeFe p a).readAt (p.add 192#64) 512 = BitVec.packLanes a.l3 := by
  have h : m.FeRoom p := ⟨hov, hr⟩
  simp only [storeFe, storeVec,
    readAt_storeAt_disjoint (h.disjoint 256#64 192#64 (by decide) (by decide) (by decide)),
    readAt_storeAt_self (h.room_limb 192#64).storeAt.storeAt.storeAt]

/-- Limb 4 of a stored field element, as a load reads it. -/
@[mlir_read]
theorem MemoryState.readAt_storeFe_l4 (hov : ¬p.offset.uaddOverflow 320#64) (hr : Room m p 2560) :
    (m.storeFe p a).readAt (p.add 256#64) 512 = BitVec.packLanes a.l4 := by
  have h : m.FeRoom p := ⟨hov, hr⟩
  simp only [storeFe, storeVec,
    readAt_storeAt_self (h.room_limb 256#64).storeAt.storeAt.storeAt.storeAt]

/-- A field element stored where there is room is known. -/
@[mlir_fresh, mlir_mem]
theorem MemoryState.FeFit.storeFe_self (h : m.FeRoom p) : (m.storeFe p a).FeFit p := by
  have f0 : Fits (m.storeFe p a) p 512 :=
    (Fits.storeVec_self h.room_limb0).storeVec.storeVec.storeVec.storeVec
  have f1 : Fits (m.storeFe p a) (p.add 64#64) 512 :=
    (Fits.storeVec_self (h.room_limb 64#64).storeVec).storeVec.storeVec.storeVec
  have f2 : Fits (m.storeFe p a) (p.add 128#64) 512 :=
    (Fits.storeVec_self (h.room_limb 128#64).storeVec.storeVec).storeVec.storeVec
  have f3 : Fits (m.storeFe p a) (p.add 192#64) 512 :=
    (Fits.storeVec_self (h.room_limb 192#64).storeVec.storeVec.storeVec).storeVec
  have f4 : Fits (m.storeFe p a) (p.add 256#64) 512 :=
    Fits.storeVec_self (h.room_limb 256#64).storeVec.storeVec.storeVec.storeVec
  have hov (o : BitVec 64) (ho : o.toNat ≤ 320 := by decide) := not_uaddOverflow_le h.1 o ho
  exact
    ⟨h.1,
      Fits.append (v := 2048) (hov 256#64) (by decide) (by decide)
        (Fits.append (v := 1536) (hov 192#64) (by decide) (by decide)
          (Fits.append (v := 1024) (hov 128#64) (by decide) (by decide)
            (Fits.append (v := 512) (hov 64#64) (by decide) (by decide) f0 f1) f2)
          f3)
        f4⟩

/-- Storing what a field element holds changes nothing. -/
theorem MemoryState.storeFe_readFe_self (h : m.FeFit p) : m.storeFe p (m.readFe p) = m := by
  simp only [storeFe, readFe]
  rw [storeVec_readVec_self' h.fits_limb0, storeVec_readVec_self' (h.fits_limb 64#64),
    storeVec_readVec_self' (h.fits_limb 128#64), storeVec_readVec_self' (h.fits_limb 192#64),
    storeVec_readVec_self' (h.fits_limb 256#64)]

/-- A read in another block than a field element store: the read before it. -/
@[mlir_read]
theorem MemoryState.readAt_storeFe_of_id_ne (h : p.id ≠ q.id) :
    (m.storeFe p a).readAt q w = m.readAt q w := by
  have hd (o : BitVec 64) : (Range.of (p.add o) 512).Disjoint (Range.of q w) :=
    Range.disjoint_of_id_ne (by simpa using h)
  simp only [storeFe, storeVec, readAt_storeAt_disjoint (hd _),
    readAt_storeAt_disjoint (Range.disjoint_of_id_ne h)]

/-- Lanes in another block than a field element store: the lanes before it. -/
@[mlir_read]
theorem MemoryState.readVec_storeFe_of_id_ne (h : p.id ≠ q.id) :
    (m.storeFe p a).readVec q = m.readVec q := by rw [readVec, readVec, readAt_storeFe_of_id_ne h]

/-- A field element in another block than a field element store: the one before it. -/
@[mlir_read]
theorem MemoryState.readFe_storeFe_of_id_ne (h : p.id ≠ q.id) :
    (m.storeFe p a).readFe q = m.readFe q := by
  have h' (o : BitVec 64) : p.id ≠ (q.add o).id := by simpa using h
  simp only [readFe, readVec_storeFe_of_id_ne h, readVec_storeFe_of_id_ne (h' _)]

@[mlir_frame, mlir_erase]
theorem MemoryState.eraseFrom_storeFe :
    (m.storeFe p a).eraseFrom n = (m.eraseFrom n).storeFe p a := by
  simp only [storeFe, eraseFrom_storeVec]

@[mlir_frame, mlir_erase]
theorem MemoryState.storeFe_eraseFrom_of_le (h : n ≤ p.id.id) :
    (m.eraseFrom n).storeFe p a = m.eraseFrom n := by
  have h' (o : BitVec 64) : n ≤ (p.add o).id.id := by simpa using h
  simp only [storeFe, storeVec_eraseFrom_of_le h, storeVec_eraseFrom_of_le (h' _)]

@[mlir_erase high]
theorem MemoryState.eraseFrom_storeFe_of_le (h : n ≤ p.id.id) :
    (m.storeFe p a).eraseFrom n = m.eraseFrom n := by
  rw [eraseFrom_storeFe, storeFe_eraseFrom_of_le h]

@[mlir_frame, mlir_read]
theorem MemoryState.readFe_alloca {s : GlobalState} (hne : p.id ≠ s.allocaPtr.id) :
    (s.alloca n d).mem.readFe p = s.mem.readFe p := by
  have hne' (o : BitVec 64) : (p.add o).id ≠ s.allocaPtr.id := by simpa using hne
  simp only [readFe, readVec_alloca hne, readVec_alloca (hne' _)]

@[mlir_read]
theorem MemoryState.readFe_lifetimeStart : (m.lifetimeStart q).readFe p = m.readFe p := by
  simp only [readFe, readVec_lifetimeStart]

@[mlir_read]
theorem MemoryState.readFe_lifetimeEnd : (m.lifetimeEnd q).readFe p = m.readFe p := by
  simp only [readFe, readVec_lifetimeEnd]

end Fe

/-! ### Points -/

section Point

variable {m : MemoryState} {p q : Pointer} {a : Fe} {P : Point}

theorem MemoryState.LanePointFit.fit_x (h : m.LanePointFit p) : m.FeFit p :=
  ⟨not_uaddOverflow_le h.1 _ (by decide), h.2.mono (by decide)⟩

theorem MemoryState.LanePointFit.fit_y (h : m.LanePointFit p) : m.FeFit (p.add 320#64) :=
  ⟨not_uaddOverflow_add h.1 (by decide),
    h.2.add_of_le (not_uaddOverflow_le h.1 _ (by decide)) (by decide)⟩

theorem MemoryState.LanePointFit.fit_z (h : m.LanePointFit p) : m.FeFit (p.add 640#64) :=
  ⟨not_uaddOverflow_add h.1 (by decide),
    h.2.add_of_le (not_uaddOverflow_le h.1 _ (by decide)) (by decide)⟩

@[mlir_transport]
theorem MemoryState.LanePointFit.fit_t (h : m.LanePointFit p) : m.FeFit (p.add 960#64) :=
  ⟨not_uaddOverflow_add h.1 (by decide),
    h.2.add_of_le (not_uaddOverflow_le h.1 _ (by decide)) (by decide)⟩

theorem MemoryState.LanePointRoom.room_x (h : m.LanePointRoom p) : m.FeRoom p :=
  ⟨not_uaddOverflow_le h.1 _ (by decide), h.2.mono (by decide)⟩

theorem MemoryState.LanePointRoom.room_y (h : m.LanePointRoom p) : m.FeRoom (p.add 320#64) :=
  ⟨not_uaddOverflow_add h.1 (by decide),
    h.2.add_of_le (not_uaddOverflow_le h.1 _ (by decide)) (by decide)⟩

theorem MemoryState.LanePointRoom.room_z (h : m.LanePointRoom p) : m.FeRoom (p.add 640#64) :=
  ⟨not_uaddOverflow_add h.1 (by decide),
    h.2.add_of_le (not_uaddOverflow_le h.1 _ (by decide)) (by decide)⟩

theorem MemoryState.LanePointRoom.room_t (h : m.LanePointRoom p) : m.FeRoom (p.add 960#64) :=
  ⟨not_uaddOverflow_add h.1 (by decide),
    h.2.add_of_le (not_uaddOverflow_le h.1 _ (by decide)) (by decide)⟩

/-- A point known in a writable block has room. -/
theorem MemoryState.LanePointFit.room (h : m.LanePointFit p) (hw : Writable m p) :
    m.LanePointRoom p :=
  ⟨h.1, h.2.room hw⟩

@[simp, mlir_state]
theorem Room.storeLanePoint_iff : Room (m.storeLanePoint q P) p w ↔ Room m p w := by
  simp [MemoryState.storeLanePoint]

@[simp, mlir_state]
theorem InBounds.storeLanePoint_iff : InBounds (m.storeLanePoint q P) p w ↔ InBounds m p w := by
  simp [MemoryState.storeLanePoint]

@[mlir_mem, mlir_transport]
theorem Fits.storeLanePoint (h : Fits m p w) : Fits (m.storeLanePoint q P) p w :=
  h.storeFe.storeFe.storeFe.storeFe

@[mlir_mem, mlir_transport]
theorem Room.storeLanePoint (h : Room m p w) : Room (m.storeLanePoint q P) p w :=
  Room.storeLanePoint_iff.mpr h

@[mlir_mem, mlir_transport]
theorem InBounds.storeLanePoint (h : InBounds m p w) : InBounds (m.storeLanePoint q P) p w :=
  InBounds.storeLanePoint_iff.mpr h

@[mlir_mem, mlir_transport]
theorem Writable.storeLanePoint (h : Writable m p) : Writable (m.storeLanePoint q P) p :=
  h.storeFe.storeFe.storeFe.storeFe

@[simp, mlir_mem]
theorem GlobalState.WF_storeLanePoint {s : GlobalState} :
    ({ s with mem := m.storeLanePoint p P } : GlobalState).WF ↔
      ({ s with mem := m } : GlobalState).WF := by
  simp [MemoryState.storeLanePoint]

@[mlir_transport]
theorem GlobalState.WF.storeLanePoint {s : GlobalState} (h : s.WF) :
    ({ s with mem := s.mem.storeLanePoint p P } : GlobalState).WF :=
  GlobalState.WF_storeLanePoint.mpr h

@[mlir_transport]
theorem GlobalState.WF.storeLanePoint_mk {al : AllocState} (h : (⟨al, m⟩ : GlobalState).WF) :
    (⟨al, m.storeLanePoint p P⟩ : GlobalState).WF :=
  GlobalState.WF.storeLanePoint (s := ⟨al, m⟩) h

@[mlir_mem, mlir_transport]
theorem MemoryState.FeFit.storeLanePoint (h : m.FeFit p) : (m.storeLanePoint q P).FeFit p :=
  ⟨h.1, h.2.storeLanePoint⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.FeRoom.storeLanePoint (h : m.FeRoom p) : (m.storeLanePoint q P).FeRoom p :=
  ⟨h.1, h.2.storeLanePoint⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.LanePointFit.storeAt {x : BitVec w} (h : m.LanePointFit p) :
    (m.storeAt q x).LanePointFit p :=
  ⟨h.1, h.2.storeAt⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.LanePointFit.storeVec (h : m.LanePointFit p) :
    (m.storeVec q v).LanePointFit p :=
  ⟨h.1, h.2.storeVec⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.LanePointFit.storeFe (h : m.LanePointFit p) : (m.storeFe q a).LanePointFit p :=
  ⟨h.1, h.2.storeFe⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.LanePointFit.storeLanePoint (h : m.LanePointFit p) :
    (m.storeLanePoint q P).LanePointFit p :=
  ⟨h.1, h.2.storeLanePoint⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.LanePointRoom.storeAt {x : BitVec w} (h : m.LanePointRoom p) :
    (m.storeAt q x).LanePointRoom p :=
  ⟨h.1, h.2.storeAt⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.LanePointRoom.storeVec (h : m.LanePointRoom p) :
    (m.storeVec q v).LanePointRoom p :=
  ⟨h.1, h.2.storeVec⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.LanePointRoom.storeFe (h : m.LanePointRoom p) :
    (m.storeFe q a).LanePointRoom p :=
  ⟨h.1, h.2.storeFe⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.LanePointRoom.storeLanePoint (h : m.LanePointRoom p) :
    (m.storeLanePoint q P).LanePointRoom p :=
  ⟨h.1, h.2.storeLanePoint⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.LanePointFit.alloca {s : GlobalState} (hwf : s.WF) (h : s.mem.LanePointFit p) :
    (s.alloca n d).mem.LanePointFit p :=
  ⟨h.1, h.2.alloca hwf⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.LanePointRoom.alloca {s : GlobalState} (hwf : s.WF)
    (h : s.mem.LanePointRoom p) : (s.alloca n d).mem.LanePointRoom p :=
  ⟨h.1, h.2.alloca hwf⟩

@[mlir_transport]
theorem MemoryState.LanePointFit.addBlock {s : GlobalState} {x : BitVec v} (hwf : s.WF)
    (h : s.mem.LanePointFit p) : (s.mem.addBlock ⟨s.alloc.nextFreeBlock⟩ n x).LanePointFit p :=
  ⟨h.1, h.2.addBlock hwf⟩

@[mlir_transport]
theorem MemoryState.LanePointRoom.addBlock {s : GlobalState} {x : BitVec v} (hwf : s.WF)
    (h : s.mem.LanePointRoom p) : (s.mem.addBlock ⟨s.alloc.nextFreeBlock⟩ n x).LanePointRoom p :=
  ⟨h.1, h.2.addBlock hwf⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.LanePointFit.lifetimeStart (h : m.LanePointFit p) (hne : p.id ≠ q.id) :
    (m.lifetimeStart q).LanePointFit p :=
  ⟨h.1, h.2.lifetimeStart hne⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.LanePointFit.lifetimeEnd (h : m.LanePointFit p) (hne : p.id ≠ q.id) :
    (m.lifetimeEnd q).LanePointFit p :=
  ⟨h.1, h.2.lifetimeEnd hne⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.LanePointRoom.lifetimeStart (h : m.LanePointRoom p) (hne : p.id ≠ q.id) :
    (m.lifetimeStart q).LanePointRoom p :=
  ⟨h.1, h.2.lifetimeStart hne⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.LanePointRoom.lifetimeEnd (h : m.LanePointRoom p) (hne : p.id ≠ q.id) :
    (m.lifetimeEnd q).LanePointRoom p :=
  ⟨h.1, h.2.lifetimeEnd hne⟩

/-- A point stored where there is room reads back. -/
@[mlir_read]
theorem MemoryState.readLanePoint_storeLanePoint_self (h : m.LanePointRoom p) :
    (m.storeLanePoint p P).readLanePoint p = P := by
  have hc := h.1
  rcases P with ⟨x, y, z, t⟩
  simp only [readLanePoint, storeLanePoint]
  congr 1
  · rw [readFe_storeFe_apart_base hc (by decide) (by decide),
      readFe_storeFe_apart_base hc (by decide) (by decide),
      readFe_storeFe_apart_base hc (by decide) (by decide), readFe_storeFe_self h.room_x]
  · rw [readFe_storeFe_apart hc (by decide) (by decide) (by decide),
      readFe_storeFe_self h.room_y.storeFe.storeFe]
  · rw [readFe_storeFe_apart hc (by decide) (by decide) (by decide),
      readFe_storeFe_apart hc (by decide) (by decide) (by decide),
      readFe_storeFe_self h.room_z.storeFe]
  · rw [readFe_storeFe_self h.room_t.storeFe.storeFe.storeFe]

/-- A point stored where there is room is known. -/
@[mlir_fresh, mlir_mem]
theorem MemoryState.LanePointFit.storeLanePoint_self (h : m.LanePointRoom p) :
    (m.storeLanePoint p P).LanePointFit p := by
  have hov (o : BitVec 64) (ho : o.toNat ≤ 1280 := by decide) := not_uaddOverflow_le h.1 o ho
  have fx : Fits (m.storeLanePoint p P) p 2560 :=
    (MemoryState.FeFit.storeFe_self h.room_x).2.storeFe.storeFe.storeFe
  have fz : Fits (m.storeLanePoint p P) (p.add 640#64) 2560 :=
    (MemoryState.FeFit.storeFe_self h.room_z.storeFe).2.storeFe.storeFe
  have fy : Fits (m.storeLanePoint p P) (p.add 320#64) 2560 :=
    (MemoryState.FeFit.storeFe_self h.room_y.storeFe.storeFe).2.storeFe
  have ft : Fits (m.storeLanePoint p P) (p.add 960#64) 2560 :=
    (MemoryState.FeFit.storeFe_self h.room_t.storeFe.storeFe.storeFe).2
  exact
    ⟨h.1,
      Fits.append (v := 7680) (hov 960#64) (by decide) (by decide)
        (Fits.append (v := 5120) (hov 640#64) (by decide) (by decide)
          (Fits.append (v := 2560) (hov 320#64) (by decide) (by decide) fx fy) fz)
        ft⟩

/-- Storing what a point holds changes nothing. -/
theorem MemoryState.storeLanePoint_readLanePoint_self (h : m.LanePointFit p) :
    m.storeLanePoint p (m.readLanePoint p) = m := by
  simp only [storeLanePoint, readLanePoint]
  rw [storeFe_readFe_self h.fit_x, storeFe_readFe_self h.fit_z, storeFe_readFe_self h.fit_y,
    storeFe_readFe_self h.fit_t]

/-- A read in another block than a point store: the read before it. -/
@[mlir_read]
theorem MemoryState.readAt_storeLanePoint_of_id_ne (h : p.id ≠ q.id) :
    (m.storeLanePoint p P).readAt q w = m.readAt q w := by
  have h' (o : BitVec 64) : (p.add o).id ≠ q.id := by simpa using h
  simp only [storeLanePoint, readAt_storeFe_of_id_ne h, readAt_storeFe_of_id_ne (h' _)]

@[mlir_read]
theorem MemoryState.readVec_storeLanePoint_of_id_ne (h : p.id ≠ q.id) :
    (m.storeLanePoint p P).readVec q = m.readVec q := by
  rw [readVec, readVec, readAt_storeLanePoint_of_id_ne h]

@[mlir_read]
theorem MemoryState.readFe_storeLanePoint_of_id_ne (h : p.id ≠ q.id) :
    (m.storeLanePoint p P).readFe q = m.readFe q := by
  have h' (o : BitVec 64) : p.id ≠ (q.add o).id := by simpa using h
  simp only [readFe, readVec_storeLanePoint_of_id_ne h, readVec_storeLanePoint_of_id_ne (h' _)]

@[mlir_read]
theorem MemoryState.readLanePoint_storeFe_of_id_ne (h : p.id ≠ q.id) :
    (m.storeFe p a).readLanePoint q = m.readLanePoint q := by
  have h' (o : BitVec 64) : p.id ≠ (q.add o).id := by simpa using h
  simp only [readLanePoint, readFe_storeFe_of_id_ne h, readFe_storeFe_of_id_ne (h' _)]

@[mlir_read]
theorem MemoryState.readLanePoint_storeLanePoint_of_id_ne (h : p.id ≠ q.id) :
    (m.storeLanePoint p P).readLanePoint q = m.readLanePoint q := by
  have h' (o : BitVec 64) : p.id ≠ (q.add o).id := by simpa using h
  simp only [readLanePoint, readFe_storeLanePoint_of_id_ne h, readFe_storeLanePoint_of_id_ne (h' _)]

@[mlir_frame, mlir_erase]
theorem MemoryState.eraseFrom_storeLanePoint :
    (m.storeLanePoint p P).eraseFrom n = (m.eraseFrom n).storeLanePoint p P := by
  simp only [storeLanePoint, eraseFrom_storeFe]

@[mlir_frame, mlir_erase]
theorem MemoryState.storeLanePoint_eraseFrom_of_le (h : n ≤ p.id.id) :
    (m.eraseFrom n).storeLanePoint p P = m.eraseFrom n := by
  have h' (o : BitVec 64) : n ≤ (p.add o).id.id := by simpa using h
  simp only [storeLanePoint, storeFe_eraseFrom_of_le h, storeFe_eraseFrom_of_le (h' _)]

@[mlir_erase high]
theorem MemoryState.eraseFrom_storeLanePoint_of_le (h : n ≤ p.id.id) :
    (m.storeLanePoint p P).eraseFrom n = m.eraseFrom n := by
  rw [eraseFrom_storeLanePoint, storeLanePoint_eraseFrom_of_le h]

@[mlir_frame, mlir_read]
theorem MemoryState.readLanePoint_alloca {s : GlobalState} (hne : p.id ≠ s.allocaPtr.id) :
    (s.alloca n d).mem.readLanePoint p = s.mem.readLanePoint p := by
  have hne' (o : BitVec 64) : (p.add o).id ≠ s.allocaPtr.id := by simpa using hne
  simp only [readLanePoint, readFe_alloca hne, readFe_alloca (hne' _)]

@[mlir_read]
theorem MemoryState.readLanePoint_lifetimeStart :
    (m.lifetimeStart q).readLanePoint p = m.readLanePoint p := by
  simp only [readLanePoint, readFe_lifetimeStart]

@[mlir_read]
theorem MemoryState.readLanePoint_lifetimeEnd :
    (m.lifetimeEnd q).readLanePoint p = m.readLanePoint p := by
  simp only [readLanePoint, readFe_lifetimeEnd]

/-- The point at `p` as its twenty vectors, at the offsets `getelementptr` gives them. -/
theorem MemoryState.readLanePoint_eq :
    m.readLanePoint p =
      ⟨⟨m.readVec p, m.readVec (p.add 64#64), m.readVec (p.add 128#64), m.readVec (p.add 192#64),
          m.readVec (p.add 256#64)⟩,
        ⟨m.readVec (p.add 320#64), m.readVec (p.add 384#64), m.readVec (p.add 448#64),
          m.readVec (p.add 512#64), m.readVec (p.add 576#64)⟩,
        ⟨m.readVec (p.add 640#64), m.readVec (p.add 704#64), m.readVec (p.add 768#64),
          m.readVec (p.add 832#64), m.readVec (p.add 896#64)⟩,
        ⟨m.readVec (p.add 960#64), m.readVec (p.add 1024#64), m.readVec (p.add 1088#64),
          m.readVec (p.add 1152#64), m.readVec (p.add 1216#64)⟩⟩ := by
  simp only [readLanePoint, readFe, Pointer.add_add, BitVec.reduceAdd]

/-- A point stored as its twenty vector stores, at the offsets `getelementptr` gives them. -/
theorem MemoryState.storeLanePoint_eq :
    m.storeLanePoint p P =
      (((((((((((((((((((m.storeVec p P.x.l0).storeVec (p.add 64#64) P.x.l1).storeVec (p.add 128#64)
                                                                            P.x.l2).storeVec
                                                                        (p.add 192#64)
                                                                        P.x.l3).storeVec
                                                                    (p.add 256#64) P.x.l4).storeVec
                                                                (p.add 640#64) P.z.l0).storeVec
                                                            (p.add 704#64) P.z.l1).storeVec
                                                        (p.add 768#64) P.z.l2).storeVec
                                                    (p.add 832#64) P.z.l3).storeVec
                                                (p.add 896#64) P.z.l4).storeVec
                                            (p.add 320#64) P.y.l0).storeVec
                                        (p.add 384#64) P.y.l1).storeVec
                                    (p.add 448#64) P.y.l2).storeVec
                                (p.add 512#64) P.y.l3).storeVec
                            (p.add 576#64) P.y.l4).storeVec
                        (p.add 960#64) P.t.l0).storeVec
                    (p.add 1024#64) P.t.l1).storeVec
                (p.add 1088#64) P.t.l2).storeVec
            (p.add 1152#64) P.t.l3).storeVec
        (p.add 1216#64) P.t.l4 := by
  simp only [storeLanePoint, storeFe, Pointer.add_add, BitVec.reduceAdd]

/-- A point whose `t` the memory already holds, stored as the code stores it when it skips `t`:
fifteen vector stores, at the offsets `getelementptr` gives them. -/
theorem MemoryState.storeLanePoint_eq_of_t (hov : ¬p.offset.uaddOverflow 1280#64)
    (h : m.FeFit (p.add 960#64)) (ht : P.t = m.readFe (p.add 960#64)) :
    m.storeLanePoint p P =
      ((((((((((((((m.storeVec p P.x.l0).storeVec (p.add 64#64) P.x.l1).storeVec (p.add 128#64)
                                                        P.x.l2).storeVec
                                                    (p.add 192#64) P.x.l3).storeVec
                                                (p.add 256#64) P.x.l4).storeVec
                                            (p.add 640#64) P.z.l0).storeVec
                                        (p.add 704#64) P.z.l1).storeVec
                                    (p.add 768#64) P.z.l2).storeVec
                                (p.add 832#64) P.z.l3).storeVec
                            (p.add 896#64) P.z.l4).storeVec
                        (p.add 320#64) P.y.l0).storeVec
                    (p.add 384#64) P.y.l1).storeVec
                (p.add 448#64) P.y.l2).storeVec
            (p.add 512#64) P.y.l3).storeVec
        (p.add 576#64) P.y.l4 := by
  rw [storeLanePoint, ht, ←
    readFe_storeFe_base_apart (x := P.x) (b := 960#64) hov (by decide) (by decide), ←
    readFe_storeFe_apart (x := P.z) (a := 640#64) (b := 960#64) hov (by decide) (by decide)
      (by decide),
    ←
    readFe_storeFe_apart (x := P.y) (a := 320#64) (b := 960#64) hov (by decide) (by decide)
      (by decide),
    storeFe_readFe_self h.storeFe.storeFe.storeFe]
  simp only [storeFe, Pointer.add_add, BitVec.reduceAdd]

end Point

/-! ### Table entries -/

section Niels

variable {m : MemoryState} {p q : Pointer} {a : Fe} {P : Point}

@[mlir_mem, mlir_transport]
theorem MemoryState.NielsFit.storeAt {x : BitVec w} (h : m.NielsFit p) :
    (m.storeAt q x).NielsFit p :=
  ⟨h.1, h.2.storeAt⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.NielsFit.storeVec (h : m.NielsFit p) : (m.storeVec q v).NielsFit p :=
  ⟨h.1, h.2.storeVec⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.NielsFit.storeFe (h : m.NielsFit p) : (m.storeFe q a).NielsFit p :=
  ⟨h.1, h.2.storeFe⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.NielsFit.storeLanePoint (h : m.NielsFit p) :
    (m.storeLanePoint q P).NielsFit p :=
  ⟨h.1, h.2.storeLanePoint⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.NielsFit.alloca {s : GlobalState} (hwf : s.WF) (h : s.mem.NielsFit p) :
    (s.alloca n d).mem.NielsFit p :=
  ⟨h.1, h.2.alloca hwf⟩

@[mlir_transport]
theorem MemoryState.NielsFit.addBlock {s : GlobalState} {x : BitVec v} (hwf : s.WF)
    (h : s.mem.NielsFit p) : (s.mem.addBlock ⟨s.alloc.nextFreeBlock⟩ n x).NielsFit p :=
  ⟨h.1, h.2.addBlock hwf⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.NielsFit.lifetimeStart (h : m.NielsFit p) (hne : p.id ≠ q.id) :
    (m.lifetimeStart q).NielsFit p :=
  ⟨h.1, h.2.lifetimeStart hne⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.NielsFit.lifetimeEnd (h : m.NielsFit p) (hne : p.id ≠ q.id) :
    (m.lifetimeEnd q).NielsFit p :=
  ⟨h.1, h.2.lifetimeEnd hne⟩

@[mlir_read]
theorem MemoryState.readNiels_storeFe_of_id_ne (h : p.id ≠ q.id) :
    (m.storeFe p a).readNiels q = m.readNiels q := by
  have h' (o : BitVec 64) : p.id ≠ (q.add o).id := by simpa using h
  simp only [readNiels, readFe_storeFe_of_id_ne h, readFe_storeFe_of_id_ne (h' _)]

@[mlir_read]
theorem MemoryState.readNiels_storeLanePoint_of_id_ne (h : p.id ≠ q.id) :
    (m.storeLanePoint p P).readNiels q = m.readNiels q := by
  have h' (o : BitVec 64) : p.id ≠ (q.add o).id := by simpa using h
  simp only [readNiels, readFe_storeLanePoint_of_id_ne h, readFe_storeLanePoint_of_id_ne (h' _)]

@[mlir_frame, mlir_read]
theorem MemoryState.readNiels_alloca {s : GlobalState} (hne : p.id ≠ s.allocaPtr.id) :
    (s.alloca n d).mem.readNiels p = s.mem.readNiels p := by
  have hne' (o : BitVec 64) : (p.add o).id ≠ s.allocaPtr.id := by simpa using hne
  simp only [readNiels, readFe_alloca hne, readFe_alloca (hne' _)]

@[mlir_read]
theorem MemoryState.readNiels_lifetimeStart : (m.lifetimeStart q).readNiels p = m.readNiels p := by
  simp only [readNiels, readFe_lifetimeStart]

@[mlir_read]
theorem MemoryState.readNiels_lifetimeEnd : (m.lifetimeEnd q).readNiels p = m.readNiels p := by
  simp only [readNiels, readFe_lifetimeEnd]

/-- The table entry at `p` as its vectors, at the offsets `getelementptr` gives them. -/
theorem MemoryState.readNiels_eq :
    m.readNiels p =
      ⟨⟨m.readVec p, m.readVec (p.add 64#64), m.readVec (p.add 128#64), m.readVec (p.add 192#64),
          m.readVec (p.add 256#64)⟩,
        ⟨m.readVec (p.add 320#64), m.readVec (p.add 384#64), m.readVec (p.add 448#64),
          m.readVec (p.add 512#64), m.readVec (p.add 576#64)⟩,
        ⟨m.readVec (p.add 640#64), m.readVec (p.add 704#64), m.readVec (p.add 768#64),
          m.readVec (p.add 832#64), m.readVec (p.add 896#64)⟩,
        ⟨m.readVec (p.add 960#64), m.readVec (p.add 1024#64), m.readVec (p.add 1088#64),
          m.readVec (p.add 1152#64), m.readVec (p.add 1216#64)⟩,
        ⟨m.readVec (p.add 1280#64), m.readVec (p.add 1344#64), m.readVec (p.add 1408#64),
          m.readVec (p.add 1472#64), m.readVec (p.add 1536#64)⟩⟩ := by
  simp only [readNiels, readFe, Pointer.add_add, BitVec.reduceAdd]

end Niels

/-! ### Whole objects from their cells -/

/-- Two values of `64 n` bits with the same 64-bit cells are equal. -/
theorem _root_.BitVec.eq_of_cells64 {n : Nat} {x y : BitVec (64 * n)}
    (h : ∀ k < n, x.extractLsb' (64 * k) 64 = y.extractLsb' (64 * k) 64) : x = y := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  have hk := congrArg (·.getLsbD (i % 64)) (h (i / 64) (by omega))
  simp only [BitVec.getLsbD_extractLsb', show i % 64 < 64 by omega, decide_true, Bool.true_and,
    show 64 * (i / 64) + i % 64 = i by omega] at hk
  exact hk

/-- A read of `64 n` bits whose 64-bit cells are known. -/
theorem MemoryState.readAt_eq_of_cells {m : MemoryState} {p : Pointer} {n : Nat}
    {X : BitVec (64 * n)} (hb : InBounds m p (64 * n))
    (hov : ¬p.offset.uaddOverflow (BitVec.ofNat 64 (8 * n))) (hn : 8 * n < 2 ^ 64)
    (h : ∀ k < n, m.readAt (p.add (BitVec.ofNat 64 (8 * k))) 64 = X.extractLsb' (64 * k) 64) :
    m.readAt p (64 * n) = X := by
  apply BitVec.eq_of_cells64
  intro k hk
  rw [← h k hk,
    MemoryState.readAt_add_of_readAt hb
      (BitVec.not_uaddOverflow_of_le hov
        (by
          simp; omega))
      (by
        simp; omega)
      rfl]
  congr 1
  simp; omega

/-- A field element's five stores as one store of its bits, limb 0 lowest. -/
theorem MemoryState.storeFe_eq_storeAt {m : MemoryState} {p : Pointer} {a : Fe}
    (hov : ¬p.offset.uaddOverflow 320#64) :
    m.storeFe p a =
      m.storeAt p
        (BitVec.packLanes a.l4 ++
          (BitVec.packLanes a.l3 ++
            (BitVec.packLanes a.l2 ++ (BitVec.packLanes a.l1 ++ BitVec.packLanes a.l0)))) := by
  have ho (o : Nat) (h : o ≤ 320) : ¬p.offset.uaddOverflow (BitVec.ofNat 64 o) :=
    BitVec.not_uaddOverflow_of_le hov
      (by
        simp; omega)
  simp only [storeFe, storeVec]
  rw [show (64#64 : BitVec 64) = BitVec.ofNat 64 64 from rfl,
    storeAt_storeAt_append (ho 64 (by omega)) (by rfl) (by decide),
    show (128#64 : BitVec 64) = BitVec.ofNat 64 128 from rfl,
    storeAt_storeAt_append (ho 128 (by omega)) (by rfl) (by decide),
    show (192#64 : BitVec 64) = BitVec.ofNat 64 192 from rfl,
    storeAt_storeAt_append (ho 192 (by omega)) (by rfl) (by decide),
    show (256#64 : BitVec 64) = BitVec.ofNat 64 256 from rfl,
    storeAt_storeAt_append (ho 256 (by omega)) (by rfl) (by decide)]

theorem _root_.BitVec.getLsbD_packLanes64 {n : Nat} (v : Vector (BitVec 64) n) {i : Nat}
    (hi : i < 64 * n) :
    (BitVec.packLanes v).getLsbD i = (v[i / 64]'(by omega)).getLsbD (i % 64) := by
  have h :=
    congrArg (·.getLsbD 0)
      (BitVec.extractLsb'_packLanes_of_lt v (s := i) (w := 1) (by omega) (by omega))
  simpa using h

theorem _root_.BitVec.eq_of_cells512 {n : Nat} {x y : BitVec (512 * n)}
    (h : ∀ k < n, x.extractLsb' (512 * k) 512 = y.extractLsb' (512 * k) 512) : x = y := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  have hk := congrArg (·.getLsbD (i % 512)) (h (i / 512) (by omega))
  simp only [BitVec.getLsbD_extractLsb', show i % 512 < 512 by omega, decide_true, Bool.true_and,
    show 512 * (i / 512) + i % 512 = i by omega] at hk
  exact hk

theorem MemoryState.readAt_eq_of_cells512 {m : MemoryState} {p : Pointer} {n : Nat}
    {X : BitVec (512 * n)} (hb : InBounds m p (512 * n))
    (hov : ¬p.offset.uaddOverflow (BitVec.ofNat 64 (64 * n))) (hn : 64 * n < 2 ^ 64)
    (h : ∀ k < n, m.readAt (p.add (BitVec.ofNat 64 (64 * k))) 512 = X.extractLsb' (512 * k) 512) :
    m.readAt p (512 * n) = X := by
  apply BitVec.eq_of_cells512
  intro k hk
  rw [← h k hk,
    MemoryState.readAt_add_of_readAt hb
      (BitVec.not_uaddOverflow_of_le hov
        (by
          simp; omega))
      (by
        simp; omega)
      rfl]
  congr 1
  simp; omega

/-- Eight copies of a vector's lanes, packed: each 512-bit cell is the vector. -/
theorem packLanes_rep8_cell (A : Vector (BitVec 64) 8) (k : Nat) (hk : k < 8) :
    (BitVec.packLanes (Vector.ofFn fun j : Fin 64 => A[j.val % 8])).extractLsb' (512 * k) 512 =
      BitVec.packLanes A := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  rw [BitVec.getLsbD_extractLsb', BitVec.getLsbD_packLanes64 _ (by omega),
    BitVec.getLsbD_packLanes64 _ (by omega)]
  simp only [hi, decide_true, Bool.true_and, Vector.getElem_ofFn]
  simp only [show (512 * k + i) / 64 % 8 = i / 64 by omega,
    show (512 * k + i) % 64 = i % 64 by omega]

end

end MLIR
